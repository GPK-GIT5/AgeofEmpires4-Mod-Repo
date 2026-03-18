# Auto-Changelog Generator
# Detects file changes via git, generates JSONL entries, and updates markdown.
# Runs on VS Code startup via .vscode/tasks.json (runOn: folderOpen).
# Gate: Skips silently if last run was < 24 hours ago.
#
# Usage:
#   .\auto-changelog.ps1              # Normal auto-run (24h gate)
#   .\auto-changelog.ps1 -Force       # Bypass 24h gate
#   .\auto-changelog.ps1 -DryRun      # Preview without writing
#   .\auto-changelog.ps1 -Hours 12    # Custom threshold

param(
    [switch]$Force,
    [switch]$DryRun,
    [Alias("Hours")]
    [int]$HoursThreshold = 24
)

$ErrorActionPreference = "Stop"

# ── Paths ────────────────────────────────────────────────────────────────────
$changelogRoot = Split-Path $PSScriptRoot -Parent          # changelog/
$workspaceRoot = Split-Path $changelogRoot -Parent         # AoE4-Workspace/
$outputDir     = Join-Path $changelogRoot "output"
$stateFile     = Join-Path $changelogRoot ".last-auto-run"
$validateScript = Join-Path $PSScriptRoot "validate-entry.ps1"
$overviewScript = Join-Path $PSScriptRoot "generate-overview.ps1"
$detailedScript = Join-Path $PSScriptRoot "generate-detailed-entries.ps1"

# ── 24-Hour Gate ─────────────────────────────────────────────────────────────
if ((Test-Path $stateFile) -and -not $Force) {
    $lastRun = [DateTime]::Parse((Get-Content $stateFile -Raw).Trim())
    $hoursSince = [math]::Round(((Get-Date).ToUniversalTime() - $lastRun.ToUniversalTime()).TotalHours, 1)
    if ($hoursSince -lt $HoursThreshold) {
        Write-Host "Auto-changelog: Last run ${hoursSince}h ago (threshold: ${HoursThreshold}h). Skipping." -ForegroundColor DarkGray
        exit 0
    }
}

# ── Git Availability Check ───────────────────────────────────────────────────
Push-Location $workspaceRoot
try {
    $null = git rev-parse --git-dir 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Auto-changelog: Not a git repository. Exiting."
        exit 0
    }
} catch {
    Write-Warning "Auto-changelog: git not found. Exiting."
    exit 0
}

# ── Collect Changes ──────────────────────────────────────────────────────────
# Determine the "since" boundary
$sinceDate = if (Test-Path $stateFile) {
    (Get-Content $stateFile -Raw).Trim()
} else {
    # First run: look back 7 days
    (Get-Date).AddDays(-7).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
}

# Extensions worth tracking (everything else is skipped)
$knownExtensions = @(".scar",".md",".ps1",".json",".jsonl",".csv",".ts",".xml",".yaml",".yml",".xaml")

# Path prefixes to skip (archives, backups, binary-heavy directories, bulk data)
$skipPatterns = @(
    '^\.github/copilot-skills-archive/'
    '^\.github/copilot/(scripts|archive|SESSION_SNAPSHOT)'
    '^data/(aoe4/)?(scar_dump|data)/'
    '^data/(buildings|units|technologies|civilizations)/'
    '/cache/'
    '\.aoe4mod$'
    '\.(png|jpg|bin|pdn|rdo|burnproj|locdb|dll|exe)$'
)

# Committed changes since last run
$committedRaw = git log --after="$sinceDate" --name-status --pretty=format:"COMMIT:%s" --diff-filter=AMRD 2>$null
# Staged changes only (explicit user action via git add; skip unstaged WIP)
$stagedRaw = git diff --name-status --cached 2>$null

# Parse into a hashtable: file -> { status, source, message }
# Apply extension and path filters during parsing
$changes = [ordered]@{}
$currentCommitMsg = ""
$skippedCount = 0

function Test-ShouldSkip([string]$fp) {
    $ext = [System.IO.Path]::GetExtension($fp)
    if ($ext -and $ext -notin $script:knownExtensions) { return $true }
    foreach ($pat in $script:skipPatterns) {
        if ($fp -match $pat) { return $true }
    }
    return $false
}

foreach ($line in $committedRaw) {
    if ($line -match '^COMMIT:(.*)') {
        $currentCommitMsg = $matches[1].Trim()
        continue
    }
    if ($line -match '^([AMDR])\t(.+)$') {
        $gitStatus = $matches[1]
        $filePath  = $matches[2] -replace '\\', '/'
        if (Test-ShouldSkip $filePath) { $skippedCount++; continue }
        $changes[$filePath] = @{
            Status  = $gitStatus
            Source  = "committed"
            Message = $currentCommitMsg
        }
    }
}

foreach ($line in $stagedRaw) {
    if ($line -match '^([AMDR])\t(.+)$') {
        $gitStatus = $matches[1]
        $filePath  = $matches[2] -replace '\\', '/'
        if (Test-ShouldSkip $filePath) { $skippedCount++; continue }
        $changes[$filePath] = @{
            Status  = $gitStatus
            Source  = "uncommitted"
            Message = ""
        }
    }
}

Pop-Location

if ($skippedCount -gt 0) {
    Write-Host "Auto-changelog: Skipped $skippedCount files (unrecognized extension or excluded path)" -ForegroundColor DarkGray
}

if ($changes.Count -eq 0) {
    Write-Host "Auto-changelog: No git changes detected." -ForegroundColor DarkGray
    if (-not $DryRun) {
        (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ") | Set-Content $stateFile -Encoding UTF8
    }
    exit 0
}

# First-run guard: if no state file and too many changes, set baseline and exit
$isFirstRun = -not (Test-Path $stateFile)
if ($isFirstRun -and $changes.Count -gt 100) {
    Write-Host "Auto-changelog: First run detected $($changes.Count) changes (likely historical diff)." -ForegroundColor Yellow
    Write-Host "  Setting baseline timestamp. Future runs will only log new changes." -ForegroundColor Yellow
    if (-not $DryRun) {
        (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ") | Set-Content $stateFile -Encoding UTF8
    }
    exit 0
}

# ── Filter Already-Logged Files ──────────────────────────────────────────────
$alreadyLogged = @{}
$sinceDateTime = [DateTime]::Parse($sinceDate)

foreach ($scope in @("mods", "system", "workspace")) {
    $scopeDir = Join-Path $outputDir $scope
    if (-not (Test-Path $scopeDir)) { continue }
    # Scan all daily .jsonl files across all month directories
    Get-ChildItem $scopeDir -Recurse -Filter "*.jsonl" | ForEach-Object {
        Get-Content $_.FullName | Where-Object { $_.Trim() -ne "" } | ForEach-Object {
            try {
                $entry = $_ | ConvertFrom-Json
                $entryTime = if ($entry.timestamp -is [DateTime]) { $entry.timestamp } else { [DateTime]::Parse($entry.timestamp) }
                if ($entryTime -ge $sinceDateTime) {
                    $alreadyLogged[$entry.file] = $true
                }
            } catch { }
        }
    }
}

# Remove already-logged and changelog-internal files from the change set
$filteredChanges = [ordered]@{}
foreach ($key in $changes.Keys) {
    if ($alreadyLogged.ContainsKey($key)) { continue }
    # Skip the auto-changelog state file and generated output inside output/
    if ($key -match '^changelog/(\.last-auto-run|output/.+\.(md|jsonl))$') { continue }
    $filteredChanges[$key] = $changes[$key]
}

if ($filteredChanges.Count -eq 0) {
    Write-Host "Auto-changelog: All changes already logged." -ForegroundColor DarkGray
    if (-not $DryRun) {
        (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ") | Set-Content $stateFile -Encoding UTF8
    }
    exit 0
}

# ── Heuristic Maps ───────────────────────────────────────────────────────────

# Extension → type
$typeMap = @{
    ".scar" = "scar";       ".md" = "markdown";    ".ps1" = "powershell"
    ".json" = "json";       ".jsonl" = "json";     ".csv" = "csv"
    ".ts"   = "typescript"; ".xml" = "config";     ".yaml" = "config"
    ".yml"  = "config";     ".xaml" = "config"
}

# Git letter → entry status
$statusMap = @{ "A" = "added"; "M" = "modified"; "D" = "removed"; "R" = "modified" }

function Get-Scope([string]$fp) {
    if ($fp -match '^(Scenarios|Gamemodes)/') { return "mods" }
    if ($fp -match '^changelog/')             { return "system" }
    return "workspace"
}

function Get-Category([string]$fp) {
    if ($fp -match '^(Scenarios|Gamemodes)/') { return "mods" }
    if ($fp -match '^references?/')           { return "reference" }
    if ($fp -match '^data/')                  { return "data" }
    if ($fp -match '^scripts/')              { return "scripts" }
    if ($fp -match '^user_references/')       { return "guides" }
    if ($fp -match '^changelog/')            { return "systems" }
    return "other"
}

function Get-Audience([string]$fp) {
    if ($fp -match '^(Scenarios|Gamemodes)/') { return "modders" }
    if ($fp -match '^user_references/')       { return "users" }
    return "api-tools"
}

function Get-Impact([string]$fp, [string]$entryStatus) {
    $ext = [System.IO.Path]::GetExtension($fp)
    if ($ext -eq ".md")                       { return "documentation" }
    if ($entryStatus -eq "added")             { return "minor" }
    if ($ext -in @(".json", ".csv", ".jsonl")) { return "internal" }
    return "minor"
}

function Get-Tags([string]$fp) {
    $tags = [System.Collections.Generic.List[string]]::new()
    $tags.Add("auto-detected")
    $ext = [System.IO.Path]::GetExtension($fp)
    if ($ext -eq ".scar")           { $tags.Add("scar") }
    if ($ext -eq ".md")             { $tags.Add("docs") }
    if ($ext -eq ".ps1")            { $tags.Add("powershell") }
    if ($ext -in @(".json",".jsonl",".csv")) { $tags.Add("data") }
    if ($fp -match 'cba|Onslaught')  { $tags.Add("onslaught") }
    if ($fp -match 'ags')           { $tags.Add("ags") }
    if ($fp -match 'coop_')         { $tags.Add("scenario") }
    if ($fp -match '\.github/')     { $tags.Add("ci") }
    # Ensure 2+ tags so ConvertFrom-Json deserializes as array
    $scope = Get-Scope $fp
    if ($tags.Count -lt 2) { $tags.Add($scope) }
    return ,$tags.ToArray()
}

function Build-ChangeDescription([string]$fp, [string]$entryStatus, [hashtable]$info) {
    $fileName = [System.IO.Path]::GetFileName($fp)
    $verb = switch ($entryStatus) {
        "added"    { "Added" }
        "modified" { "Modified" }
        "removed"  { "Removed" }
        default    { "Changed" }
    }

    # Use commit message if available and meaningful
    if ($info.Message -and $info.Message.Length -gt 10) {
        $msg = $info.Message
        if ($msg.Length -gt 120) { $msg = $msg.Substring(0, 117) + "..." }
        return "$verb $fileName — $msg"
    }

    return "$verb $fileName"
}

# ── Build Entries ────────────────────────────────────────────────────────────
$timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$scopeEntries = @{ mods = @(); system = @(); workspace = @() }
$maxPerScope = 50  # Cap entries per scope to keep changelogs meaningful

foreach ($fp in $filteredChanges.Keys) {
    $scope = Get-Scope $fp
    if ($scopeEntries[$scope].Count -ge $maxPerScope) { continue }

    $info        = $filteredChanges[$fp]
    $gitStatus   = $info.Status
    $ext         = [System.IO.Path]::GetExtension($fp)
    $entryStatus = if ($statusMap[$gitStatus]) { $statusMap[$gitStatus] } else { "modified" }

    $entry = [ordered]@{
        timestamp = $timestamp
        file      = $fp
        status    = $entryStatus
        type      = if ($typeMap[$ext]) { $typeMap[$ext] } else { "config" }
        change    = Build-ChangeDescription $fp $entryStatus $info
        impact    = Get-Impact $fp $entryStatus
        category  = Get-Category $fp
        audience  = Get-Audience $fp
        tags      = Get-Tags $fp
    }

    $scope = Get-Scope $fp
    $scopeEntries[$scope] += $entry
}

# ── Validate & Append ────────────────────────────────────────────────────────
$totalAdded = 0
$affectedScopes = @()

Write-Host ""
Write-Host "Auto-changelog: Processing $($filteredChanges.Count) change(s)..." -ForegroundColor Cyan
Write-Host ""

# Determine today's date for daily file naming
$today = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")
$currentMonth = (Get-Date).ToUniversalTime().ToString("yyyy-MM")

foreach ($scope in @("mods", "system", "workspace")) {
    $entries = $scopeEntries[$scope]
    if ($entries.Count -eq 0) { continue }

    $monthDir  = Join-Path $outputDir $scope $currentMonth
    $dailyFile = Join-Path $monthDir "$today.jsonl"

    if (-not (Test-Path $monthDir)) {
        New-Item -ItemType Directory -Path $monthDir -Force | Out-Null
    }

    foreach ($entry in $entries) {
        $jsonLine = $entry | ConvertTo-Json -Compress -Depth 4

        # Validate via existing validator (suppress info messages)
        $valid = & $validateScript -Entry $jsonLine 6>$null

        if ($valid -eq $true) {
            if (-not $DryRun) {
                Add-Content -Path $dailyFile -Value $jsonLine -Encoding UTF8
            }
            $totalAdded++
            $icon = switch ($entry.status) { "added" { "+" } "removed" { "-" } default { "~" } }
            Write-Host "  $icon [$scope] $($entry.file)" -ForegroundColor Green
        } else {
            Write-Warning "  Skipped (validation failed): $($entry.file)"
        }
    }

    $affectedScopes += $scope
}

# ── Generate Markdown ────────────────────────────────────────────────────────
if (-not $DryRun -and $affectedScopes.Count -gt 0) {
    Write-Host ""
    foreach ($scope in ($affectedScopes | Select-Object -Unique)) {
        Write-Host "  Generating markdown for: $scope" -ForegroundColor DarkCyan
        & $overviewScript -Scope $scope -Month $currentMonth
        & $detailedScript -Scope $scope -Month $currentMonth
    }
}

# ── Update State File ────────────────────────────────────────────────────────
if (-not $DryRun) {
    $timestamp | Set-Content $stateFile -Encoding UTF8
}

# ── Summary ──────────────────────────────────────────────────────────────────
Write-Host ""
if ($totalAdded -gt 0) {
    Write-Host "Auto-changelog: $totalAdded entries added across $($affectedScopes.Count) scope(s)" -ForegroundColor Green
} else {
    Write-Host "Auto-changelog: No new entries generated." -ForegroundColor DarkGray
}
if ($DryRun) {
    Write-Host "(DRY RUN — no files were modified)" -ForegroundColor Yellow
}
