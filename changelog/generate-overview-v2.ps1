# Generate Overview Table for Changelog Scope - Box Feature Version
# Auto-generates a compact box dashboard + table summarizing changes by date from INDEX.jsonl

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("mods", "system", "workspace")]
    [string]$Scope
)

$ErrorActionPreference = "Stop"

$scopePath = Join-Path $PSScriptRoot $Scope
$indexFile = Join-Path $scopePath "INDEX.jsonl"
$currentMonth = Get-Date -Format "yyyy-MM"
$mdFile = Join-Path $scopePath "$currentMonth.md"

if (-not (Test-Path $indexFile)) {
    Write-Warning "No INDEX.jsonl found in $Scope scope."
    exit 0
}

if (-not (Test-Path $mdFile)) {
    Write-Warning "No $currentMonth.md found in $Scope scope. Create it first."
    exit 1
}

Write-Host "Generating overview for: $Scope scope" -ForegroundColor Cyan

$entries = Get-Content $indexFile | Where-Object { $_.Trim() -ne "" } | ForEach-Object { $_ | ConvertFrom-Json }
$entries = @($entries)

if ($entries.Count -eq 0) {
    Write-Host "ℹ No entries in '$Scope' scope yet." -ForegroundColor Cyan
    exit 0
}

# Group entries by date
$dateGroups = @{}
foreach ($entry in $entries) {
    $ts = if ($entry.timestamp -is [DateTime]) { $entry.timestamp } else { [DateTime]$entry.timestamp }
    $dateStr = $ts.ToString("yyyy-MM-dd")
    if (-not $dateGroups.ContainsKey($dateStr)) { $dateGroups[$dateStr] = @() }
    $dateGroups[$dateStr] += $entry
}

$sortedDates = $dateGroups.Keys | Sort-Object -Descending

# Calculate metrics
$totalEntries = $entries.Count
$uniqueFiles = @($entries | Select-Object -ExpandProperty file -Unique).Count
$dateCount = $sortedDates.Count

# Build impact distribution
$impactMap = @{}
foreach ($entry in $entries) {
    $imp = $entry.impact
    if (-not $impactMap.ContainsKey($imp)) { $impactMap[$imp] = 0 }
    $impactMap[$imp] += 1
}

$topImpacts = ($impactMap.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 3 | ForEach-Object { "$($_.Name) ($($_.Value))" }) -join ", "
if ($topImpacts.Length -gt 40) { $topImpacts = $topImpacts.Substring(0, 37) + "..." }

# Quality metrics
$validEntries = @($entries | Where-Object { $_.timestamp -and $_.file -and $_.status -and $_.type -and $_.change -and $_.impact }).Count
$qualityPercent = [math]::Round(($validEntries / $totalEntries) * 100)

# Status and score
$statusEmoji = if ($qualityPercent -eq 100) { "🟢" } elseif ($qualityPercent -ge 95) { "🟡" } else { "🔴" }
$starRating = if ($qualityPercent -ge 95) { "⭐⭐⭐⭐⭐" } elseif ($qualityPercent -ge 80) { "⭐⭐⭐⭐" } else { "⭐⭐⭐" }
$healthScore = [math]::Min(100, [math]::Round(($qualityPercent * 0.4) + (([math]::Min($totalEntries, 20) / 20) * 100 * 0.3) + (if ($dateCount -gt 1) { 30 } else { 15 })))

# Build box
$scopeTitle = ($Scope.Substring(0, 1).ToUpper() + $Scope.Substring(1)) + " Changelog"
$monthName = Get-Date -Format "MMMM yyyy"
$box = @(
    "┌" + ("─" * 48) + "┐"
    "│ " + ($scopeTitle + " — " + $monthName).PadRight(47) + "│"
    "├" + ("─" * 48) + "┤"
    "│                                                │"
    ("│  Entries:      " + "$totalEntries total".PadRight(33) + "│")
    ("│  Files:        " + "$uniqueFiles unique".PadRight(33) + "│")
    ("│  Days:         " + "$dateCount".PadRight(33) + "│")
    ("│  Top impacts:  " + "$topImpacts".PadRight(33) + "│")
    ("│  Quality:      " + "$qualityPercent% ($validEntries/$totalEntries valid)".PadRight(33) + "│")
    ("│  Status:       " + "$statusEmoji HEALTHY".PadRight(33) + "│")
    ("│  Score:        " + "$starRating ($healthScore/100)".PadRight(33) + "│")
    "│                                                │"
    "└" + ("─" * 48) + "┘"
) -join "`n"

# Build table
$tableRows = @()
foreach ($date in $sortedDates) {
    $entriesForDate = $dateGroups[$date]
    $count = $entriesForDate.Count
    $files = @($entriesForDate | Select-Object -ExpandProperty file -Unique).Count
    $impacts = @($entriesForDate | Select-Object -ExpandProperty impact -Unique | Sort-Object) -join ", "
    
    $countDisplay = if ($files -eq 1 -and $count -eq 1) { "1 entry" } elseif ($files -eq $count) { "$count entries" } else { "$files files ($count entries)" }
    if ($impacts.Length -gt 40) { $impacts = $impacts.Substring(0, 37) + "..." }
    
    $tableRows += "| $date | $countDisplay | $impacts | [→](#$date) |"
}

$overviewSection = @"
$box

## Quick Overview

| Date | Changes | Key Areas | Details |
|------|---------|-----------|---------|
$($tableRows -join "`n")

---

"@

$mdContent = Get-Content $mdFile -Raw

if ($mdContent -match "(?s)┌.*?---\r?\n") {
    $mdContent = $mdContent -replace "(?s)┌.*?---\r?\n", $overviewSection
    Write-Host "✓ Updated existing overview" -ForegroundColor Green
} else {
    if ($mdContent -match "^# ") {
        $mdContent = $mdContent -replace "(^# .*?\r?\n)", "`$1`n$overviewSection"
    } else {
        $mdContent = $overviewSection + "`n" + $mdContent
    }
    Write-Host "✓ Inserted new overview" -ForegroundColor Green
}

try {
    Set-Content -Path $mdFile -Value $mdContent -NoNewline
    Write-Host "✓ Overview successfully written" -ForegroundColor Green
} catch {
    Write-Error "Failed to write overview: $($_.Exception.Message)"
    exit 1
}

Write-Host "Overview generated for $Scope scope" -ForegroundColor Cyan
Write-Host "  Entries: $totalEntries | Quality: $qualityPercent% | Score: $healthScore/100"
Write-Host "  Output: $mdFile"
