# Generate Overview Table for Changelog Scope
# Auto-generates a compact box dashboard + table summarizing changes by date from daily JSONL files.
# Output: output/{scope}/{month}/INDEX.md

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("mods", "system", "workspace")]
    [string]$Scope,

    [string]$Month = (Get-Date -Format "yyyy-MM")
)

$ErrorActionPreference = "Stop"

# Script lives in changelog/scripts/; output is at changelog/output/
$monthDir = Join-Path (Split-Path $PSScriptRoot -Parent) "output" $Scope $Month
$mdFile   = Join-Path $monthDir "INDEX.md"

# Check month directory exists
if (-not (Test-Path $monthDir)) {
    Write-Warning "No output directory found: $monthDir. Skipping."
    exit 0
}

# Read all daily .jsonl files in this month directory
$jsonlFiles = Get-ChildItem $monthDir -Filter "*.jsonl" | Sort-Object Name
if ($jsonlFiles.Count -eq 0) {
    Write-Warning "No daily .jsonl files in $monthDir. Skipping."
    exit 0
}

# Create INDEX.md if it doesn't exist
if (-not (Test-Path $mdFile)) {
    $scopeTitleCase = ($Scope.Substring(0,1).ToUpper() + $Scope.Substring(1))
    # Parse month name from the Month parameter
    $parsedDate = [DateTime]::ParseExact($Month, "yyyy-MM", $null)
    $monthName  = $parsedDate.ToString("MMMM yyyy")
    $initialContent = if ($Scope -eq "workspace") {
        "# Changelog — $monthName`n`n"
    } elseif ($Scope -eq "system") {
        "# Changelog: $monthName — System`n`n"
    } else {
        "# Changelog: $monthName — $scopeTitleCase`n`n"
    }
    Set-Content -Path $mdFile -Value $initialContent -Encoding UTF8
    Write-Host "  Created INDEX.md" -ForegroundColor Yellow
}

Write-Host "Generating overview for: $Scope scope ($Month)" -ForegroundColor Cyan

# Parse entries from all daily JSONL files
$entries = foreach ($f in $jsonlFiles) {
    Get-Content $f.FullName | Where-Object { $_.Trim() -ne "" } | ForEach-Object {
        $_ | ConvertFrom-Json
    }
}

if ($entries.Count -eq 0) {
    Write-Host "ℹ No entries in '$Scope' scope yet." -ForegroundColor Cyan
    Write-Host "  Use: " -NoNewline -ForegroundColor Cyan
    Write-Host ".\scripts\validate-entry.ps1 -Entry '{...}'" -ForegroundColor Yellow
    Write-Host "  Then append valid entries to: $indexFile" -ForegroundColor Cyan
    exit 0
}

# Group by date (extract from timestamp) with safety checks
$grouped = @()
foreach ($entry in $entries) {
    try {
        $dateStr = if ($entry.timestamp -is [DateTime]) {
            $entry.timestamp.ToString("yyyy-MM-dd")
        } else {
            ([DateTime]$entry.timestamp).ToString("yyyy-MM-dd")
        }
        $grouped += [PSCustomObject]@{ Date = $dateStr; Entry = $entry }
    } catch {
        Write-Warning "Skipping entry with invalid timestamp: $($entry.timestamp)"
    }
}

# Group and sort by date
$grouped = $grouped | Group-Object Date | Sort-Object Name -Descending

# Calculate scope metrics
$totalEntries = $entries.Count
$uniqueFiles = ($entries | Select-Object -ExpandProperty file -Unique).Count
$dateCount = $grouped.Count

# Impact distribution
$impactCounts = $entries | Group-Object impact | Select-Object @{ Label="Name"; Expression={ $_.Name }}, Count | Sort-Object Count -Descending
$topImpacts = ($impactCounts | Select-Object -First 3 | ForEach-Object { "$($_.Name) ($($_.Count))" }) -join ", "
if ($topImpacts.Length -gt 40) {
    $topImpacts = $topImpacts.Substring(0, 37) + "..."
}

# Quality metrics
$validEntries = ($entries | Where-Object { $_.timestamp -and $_.file -and $_.status -and $_.type -and $_.change -and $_.impact }).Count
$qualityPercent = if ($totalEntries -gt 0) { [math]::Round(($validEntries / $totalEntries) * 100) } else { 0 }

# Status emoji (detect terminal capability, fallback to ASCII)
$supportsEmoji = $host.Name -match "ConsoleHost|PowerShell ISE|Visual Studio Code Host|pwsh"
if ($supportsEmoji -and $qualityPercent -eq 100) { 
    $statusEmoji = "🟢" 
} elseif ($supportsEmoji -and $qualityPercent -ge 95) { 
    $statusEmoji = "🟡" 
} else { 
    if ($qualityPercent -eq 100) { $statusEmoji = "[OK]" } else { $statusEmoji = "[!!]" } 
}

# Calculate scope health score (0-100)
# Extract conditional values to avoid parser issues
$qualityWeight = $qualityPercent * 0.4
$activityWeight = ([math]::Min($totalEntries, 20) / 20) * 100 * 0.3
$consistencyWeight = if ($dateCount -gt 1) { 30 } else { 15 }
$healthScore = [math]::Min(100, [math]::Round($qualityWeight + $activityWeight + $consistencyWeight))

# Map score to star rating (with ASCII fallback)
if ($supportsEmoji) {
    $starRating = if ($healthScore -ge 95) { "⭐⭐⭐⭐⭐" } elseif ($healthScore -ge 80) { "⭐⭐⭐⭐" } else { "⭐⭐⭐" }
} else {
    $starRating = if ($healthScore -ge 95) { "*****" } elseif ($healthScore -ge 80) { "****" } else { "***" }
}

# Emoji icons with ASCII fallback
if ($supportsEmoji) {
    $iconEntries = "📊"
    $iconFiles = "📁"
    $iconDays = "📅"
    $iconImpacts = "🎯"
    $iconQuality = "✅"
    $iconStatus = $statusEmoji
    $iconScore = "⭐"
} else {
    $iconEntries = "[#]"
    $iconFiles = "[F]"
    $iconDays = "[D]"
    $iconImpacts = "[>]"
    $iconQuality = "[+]"
    $iconStatus = $statusEmoji
    $iconScore = "[*]"
}

# Build ASCII art header (51 chars total)
$scopeTitle = ($Scope.Substring(0,1).ToUpper() + $Scope.Substring(1)).ToUpper() + " HEALTH"
$monthName = Get-Date -Format "MMMM yyyy"
$border = "═" * 51
$header = "  $scopeTitle — $monthName"

# Build status dashboard with emoji indicators
$statusBox = @"
$border
$header
$border

  $iconEntries Entries:      $totalEntries total
  $iconFiles Files:        $uniqueFiles unique
  $iconDays Days:         $dateCount
  $iconImpacts Top Impacts:  $topImpacts
  $iconQuality Quality:      $qualityPercent% ($validEntries/$totalEntries valid)
  $iconStatus Status:       HEALTHY
  $iconScore Score:        $healthScore/100 ($starRating)

$border
"@

# Build table rows
$tableRows = @()
foreach ($group in $grouped) {
    $date = $group.Name
    $entryCount = $group.Group.Count
    $uniqueFiles = ($group.Group | Select-Object -ExpandProperty Entry | Select-Object -ExpandProperty file -Unique).Count
    
    # Show "X files (Y entries)" with improved single-entry grammar
    $countDisplay = if ($uniqueFiles -eq 1 -and $entryCount -eq 1) {
        "1 entry"
    } elseif ($uniqueFiles -eq $entryCount) {
        "$entryCount entries"
    } else {
        "$uniqueFiles files ($entryCount entries)"
    }
    
    # Extract unique impacts as "key areas"
    $keyAreas = ($group.Group | Select-Object -ExpandProperty Entry | Select-Object -ExpandProperty impact -Unique | Sort-Object) -join ", "
    if ($keyAreas.Length -gt 40) {
        $keyAreas = $keyAreas.Substring(0, 37) + "..."
    }
    
    # Link to the daily JSONL file
    $dailyLink = "$date.jsonl"
    
    $tableRows += "| $date | $countDisplay | $keyAreas | [$date.jsonl]($dailyLink) |"
}

# Build complete overview section with box + table
$overviewSection = @"
$statusBox

## Quick Overview

| Date | Changes | Key Areas | Details |
|------|---------|-----------|---------|
$($tableRows -join "`n")

---

"@

# Read existing MD file
$mdContent = Get-Content $mdFile -Raw

# Check if overview section exists (match from box/border start to divider)
# Match both old box format (┌) and new ASCII art format (═)
if ($mdContent -match "(?s)[┌═].*?---\r?\n") {
    # Replace existing box + table
    $mdContent = $mdContent -replace "(?s)[┌═].*?---\r?\n", $overviewSection
    Write-Host "✓ Updated existing overview" -ForegroundColor Green
}
else {
    # Insert at top (after title if exists)
    if ($mdContent -match "^# ") {
        $mdContent = $mdContent -replace "(^# .*?\r?\n)", "`$1`n$overviewSection"
    }
    else {
        $mdContent = $overviewSection + "`n" + $mdContent
    }
    Write-Host "✓ Inserted new overview" -ForegroundColor Green
}

# Write back
try {
    Set-Content -Path $mdFile -Value $mdContent -NoNewline
    Write-Host "✓ Overview successfully written" -ForegroundColor Green
} catch {
    Write-Error "Failed to write overview to $mdFile : $($_.Exception.Message)"
    exit 1
}

Write-Host "Overview generated for $Scope scope ($Month)" -ForegroundColor Cyan
Write-Host "  Entries: $totalEntries | Quality: $qualityPercent% | Score: $healthScore/100"
Write-Host "  Output: $mdFile"
