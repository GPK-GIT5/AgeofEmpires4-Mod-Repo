<#
.SYNOPSIS
  Audits blueprint name usage in Onslaught source against workspace reference tables.
  Detects BP names used in code but missing from documentation.

.DESCRIPTION
  1. Collects all BP names from references/blueprints/*.md
  2. Scans Onslaught .scar for BP_Get*Blueprint("name") and string patterns matching BP names
  3. Cross-references usage vs reference coverage
  4. Reports: FOUND, MISSING, and coverage percentage

.PARAMETER Root
  Workspace root. Default: C:\Users\Jordan\Documents\AoE4-Workspace
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$ErrorActionPreference = 'Stop'
$scarRoot = Join-Path $Root "Gamemodes\Onslaught\assets\scar"
$bpRoot   = Join-Path $Root "references\blueprints"
$indexDir = Join-Path $Root "references\indexes"
$modsDir  = Join-Path $Root "references\mods"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Onslaught Blueprint Usage Audit" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# =====================================================================
# 1. LOAD ALL KNOWN BP NAMES FROM REFERENCE TABLES
# =====================================================================
$knownBPs = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

$bpFiles = Get-ChildItem $bpRoot -Filter "*.md" -File
foreach ($f in $bpFiles) {
    $content = Get-Content $f.FullName -Raw
    # Match backtick-wrapped BP names in tables
    $matches2 = [regex]::Matches($content, '`([A-Z0-9_]+)`')
    foreach ($m in $matches2) {
        [void]$knownBPs.Add($m.Groups[1].Value)
    }
}

Write-Host "  Known BP names in reference tables: $($knownBPs.Count)" -ForegroundColor Gray

# Also load from canonical JSON
$canonDir = Join-Path $Root "data\aoe4\data\canonical"
foreach ($jsonFile in @("canonical-buildings.json", "entity-lifecycle.json", "campaign-entities.json", "neutral-entities.json")) {
    $jp = Join-Path $canonDir $jsonFile
    if (Test-Path $jp) {
        $content = Get-Content $jp -Raw
        $matches2 = [regex]::Matches($content, '"attribName"\s*:\s*"([^"]+)"')
        foreach ($m in $matches2) {
            [void]$knownBPs.Add($m.Groups[1].Value)
        }
    }
}

Write-Host "  Known BP names (with canonical): $($knownBPs.Count)" -ForegroundColor Gray

# =====================================================================
# 2. SCAN ONSLAUGHT FOR BP NAME USAGE
# =====================================================================
$allFiles = Get-ChildItem -Path $scarRoot -Recurse -Filter "*.scar" | Sort-Object FullName

$usedBPs = @{}  # bp_name -> list of {file, line}

# Regex for BP_Get*Blueprint("name")
$bpCallRegex = [regex]::new('BP_Get(?:Squad|Entity|Upgrade|Ability)Blueprint\s*\(\s*"([^"]+)"', 'Compiled')
# Regex for string literals matching unit_/building_/upgrade_ patterns
$bpStringRegex = [regex]::new('"((?:unit|building|upgrade|wonder|landmark)_[a-z0-9_]+)"', 'Compiled')

foreach ($file in $allFiles) {
    $relPath = $file.FullName.Substring($scarRoot.Length + 1).Replace('\', '/')
    $lines = [System.IO.File]::ReadAllLines($file.FullName)

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -match '^\s*--') { continue }

        # BP_Get*Blueprint calls
        foreach ($m in $bpCallRegex.Matches($line)) {
            $bpName = $m.Groups[1].Value
            if (-not $usedBPs.ContainsKey($bpName)) {
                $usedBPs[$bpName] = [System.Collections.Generic.List[PSCustomObject]]::new()
            }
            $usedBPs[$bpName].Add([PSCustomObject]@{ File = $relPath; Line = $i + 1 })
        }

        # String literals matching BP patterns
        foreach ($m in $bpStringRegex.Matches($line)) {
            $bpName = $m.Groups[1].Value
            if (-not $usedBPs.ContainsKey($bpName)) {
                $usedBPs[$bpName] = [System.Collections.Generic.List[PSCustomObject]]::new()
            }
            $usedBPs[$bpName].Add([PSCustomObject]@{ File = $relPath; Line = $i + 1 })
        }
    }
}

$uniqueUsed = $usedBPs.Count
Write-Host "  Unique BP names used in Onslaught: $uniqueUsed" -ForegroundColor Green

# =====================================================================
# 3. CROSS-REFERENCE
# =====================================================================
$found = [System.Collections.Generic.List[string]]::new()
$missing = [System.Collections.Generic.List[string]]::new()

foreach ($bpName in ($usedBPs.Keys | Sort-Object)) {
    if ($knownBPs.Contains($bpName) -or $knownBPs.Contains($bpName.ToUpper())) {
        $found.Add($bpName)
    } else {
        $missing.Add($bpName)
    }
}

$coveragePct = if ($uniqueUsed -gt 0) { [math]::Round(($found.Count / $uniqueUsed) * 100, 1) } else { 0 }
Write-Host "  Coverage: $($found.Count) found, $($missing.Count) missing ($coveragePct%)" -ForegroundColor $(if ($missing.Count -gt 0) { "Yellow" } else { "Green" })

# =====================================================================
# 4. OUTPUT CSV
# =====================================================================
$csvPath = Join-Path $indexDir "onslaught-blueprint-audit.csv"
$csv = [System.Collections.Generic.List[string]]::new()
$csv.Add('"Blueprint","Status","CallCount","Files","FirstFile","FirstLine"')

foreach ($bp in ($usedBPs.Keys | Sort-Object)) {
    $calls = $usedBPs[$bp]
    $status = if ($found.Contains($bp)) { "FOUND" } else { "MISSING" }
    $uniqueFiles = ($calls | Select-Object -Property File -Unique).Count
    $first = $calls[0]
    $csv.Add("`"$bp`",`"$status`",`"$($calls.Count)`",`"$uniqueFiles`",`"$($first.File)`",`"$($first.Line)`"")
}

[System.IO.File]::WriteAllLines($csvPath, $csv)
Write-Host "  -> $csvPath ($uniqueUsed rows)" -ForegroundColor Gray

# =====================================================================
# 5. OUTPUT MARKDOWN
# =====================================================================
$mdPath = Join-Path $modsDir "onslaught-blueprint-audit.md"
$md = [System.Text.StringBuilder]::new()
[void]$md.AppendLine("# Onslaught Blueprint Usage Audit")
[void]$md.AppendLine()
[void]$md.AppendLine("Auto-generated on $timestamp. Cross-references blueprint names used in Onslaught source against workspace reference tables.")
[void]$md.AppendLine()
[void]$md.AppendLine("- **$uniqueUsed** unique blueprint names found in Onslaught code")
[void]$md.AppendLine("- **$($found.Count)** found in reference tables ($coveragePct% coverage)")
[void]$md.AppendLine("- **$($missing.Count)** missing from reference tables")
[void]$md.AppendLine()

if ($missing.Count -gt 0) {
    [void]$md.AppendLine("## Missing Blueprints")
    [void]$md.AppendLine()
    [void]$md.AppendLine("These blueprint names are used in Onslaught code but not found in any reference table:")
    [void]$md.AppendLine()
    [void]$md.AppendLine("| Blueprint Name | Usage Count | Files | Example Location |")
    [void]$md.AppendLine("|----------------|-------------|-------|-----------------|")
    foreach ($bp in $missing) {
        $calls = $usedBPs[$bp]
        $uniqueFiles = ($calls | Select-Object -Property File -Unique).Count
        $first = $calls[0]
        [void]$md.AppendLine("| ``$bp`` | $($calls.Count) | $uniqueFiles | $($first.File):$($first.Line) |")
    }
    [void]$md.AppendLine()
}

# Categorize missing by type
$missingUnits    = ($missing | Where-Object { $_ -match '^unit_' }).Count
$missingBuildings = ($missing | Where-Object { $_ -match '^building_' }).Count
$missingUpgrades  = ($missing | Where-Object { $_ -match '^upgrade_' }).Count
$missingOther     = $missing.Count - $missingUnits - $missingBuildings - $missingUpgrades

[void]$md.AppendLine("### Missing by Type")
[void]$md.AppendLine()
[void]$md.AppendLine("| Type | Count |")
[void]$md.AppendLine("|------|-------|")
[void]$md.AppendLine("| Units | $missingUnits |")
[void]$md.AppendLine("| Buildings | $missingBuildings |")
[void]$md.AppendLine("| Upgrades | $missingUpgrades |")
[void]$md.AppendLine("| Other | $missingOther |")
[void]$md.AppendLine()

# Top files by BP reference density
[void]$md.AppendLine("## Top 20 Files by Blueprint Reference Density")
[void]$md.AppendLine()
$fileUsage = @{}
foreach ($bp in $usedBPs.Keys) {
    foreach ($call in $usedBPs[$bp]) {
        if (-not $fileUsage.ContainsKey($call.File)) { $fileUsage[$call.File] = 0 }
        $fileUsage[$call.File]++
    }
}
[void]$md.AppendLine("| # | File | BP References |")
[void]$md.AppendLine("|---|------|---------------|")
$rank = 0
foreach ($entry in ($fileUsage.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 20)) {
    $rank++
    [void]$md.AppendLine("| $rank | $($entry.Key) | $($entry.Value) |")
}
[void]$md.AppendLine()

[System.IO.File]::WriteAllText($mdPath, $md.ToString())
Write-Host "  -> $mdPath" -ForegroundColor Gray

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " Blueprint Audit Complete" -ForegroundColor Cyan
Write-Host "  Used: $uniqueUsed | Found: $($found.Count) | Missing: $($missing.Count) | Coverage: $coveragePct%" -ForegroundColor White
Write-Host "================================================================" -ForegroundColor Cyan
