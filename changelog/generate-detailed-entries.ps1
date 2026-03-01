# Generate Detailed Changelog Entries from JSONL
# Converts INDEX.jsonl data into human-readable markdown prose
# Usage: .\generate-detailed-entries.ps1 -Scope workspace

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("mods", "system", "workspace")]
    [string]$Scope
)

$ErrorActionPreference = "Stop"

# Determine paths
$scopeDir = Join-Path $PSScriptRoot $Scope
$indexFile = Join-Path $scopeDir "INDEX.jsonl"
$currentMonth = Get-Date -Format "yyyy-MM"
$mdFile = Join-Path $scopeDir "$currentMonth.md"

# Check files exist
if (-not (Test-Path $indexFile)) {
    Write-Warning "No INDEX.jsonl found in $Scope scope. Skipping."
    exit 0
}

if (-not (Test-Path $mdFile)) {
    Write-Warning "No $currentMonth.md found in $Scope scope. Run generate-overview.ps1 first."
    exit 1
}

Write-Host "Generating detailed entries for: $Scope scope" -ForegroundColor Cyan

# Parse JSONL
$entries = Get-Content $indexFile | Where-Object { $_.Trim() -ne "" } | ForEach-Object {
    $_ | ConvertFrom-Json
}

if ($entries.Count -eq 0) {
    Write-Host "ℹ No entries in '$Scope' scope yet." -ForegroundColor Gray
    exit 0
}

# Group by date
$grouped = @()
foreach ($entry in $entries) {
    try {
        # Handle both DateTime objects and ISO 8601 strings
        if ($entry.timestamp -is [DateTime]) {
            $timestamp = $entry.timestamp
        } else {
            $timestamp = [DateTime]::Parse($entry.timestamp)
        }
        $dateStr = $timestamp.ToString("yyyy-MM-dd")
        $grouped += [PSCustomObject]@{ Date = $dateStr; Entry = $entry }
    } catch {
        Write-Warning "Skipping entry with invalid timestamp: $($entry.timestamp)"
    }
}

$grouped = $grouped | Group-Object Date | Sort-Object Name -Descending

# Build detailed sections
$detailedSections = @()

foreach ($dateGroup in $grouped) {
    $date = $dateGroup.Name
    $dateEntries = $dateGroup.Group | Select-Object -ExpandProperty Entry
    
    # Generate section title (summarize impacts)
    $impacts = ($dateEntries | Select-Object -ExpandProperty impact -Unique | Sort-Object) -join ", "
    $impactTitle = if ($impacts.Length -gt 40) { $impacts.Substring(0, 37) + "..." } else { $impacts }
    
    $sectionHeader = "## [$date] Changelog Entries"
    $detailedSections += ""
    $detailedSections += $sectionHeader
    $detailedSections += ""
    
    # Group by file for better organization
    $byFile = $dateEntries | Group-Object file | Sort-Object Name
    
    foreach ($fileGroup in $byFile) {
        $fileName = $fileGroup.Name
        $fileEntries = $fileGroup.Group
        
        # File subsection header
        $detailedSections += "### $fileName"
        $detailedSections += ""
        
        # Process each entry for this file
        foreach ($entry in $fileEntries) {
            # Status icon
            $statusIcon = switch ($entry.status) {
                "added"    { "➕" }
                "modified" { "✏️" }
                "removed"  { "❌" }
                default    { "•" }
            }
            
            # Impact badge (uppercase for visibility)
            $impactBadge = "**[$($entry.impact.ToUpper())]**"
            
            # Build entry block
            $detailedSections += "$statusIcon $impactBadge **$($entry.status.ToUpper())** — $($entry.change)"
            $detailedSections += ""
            
            # Metadata table (compact format)
            $detailedSections += "| Property | Value |"
            $detailedSections += "|----------|-------|"
            $detailedSections += "| **Type** | ``$($entry.type)`` |"
            $detailedSections += "| **Category** | ``$($entry.category)`` |"
            $detailedSections += "| **Audience** | ``$($entry.audience)`` |"
            $detailedSections += "| **Tags** | $($entry.tags -join ', ') |"
            
            # Optional notes (if present, display prominently)
            if ($entry.notes) {
                $detailedSections += ""
                $detailedSections += "> **Additional Context:** $($entry.notes)"
            }
            
            $detailedSections += ""
        }
    }
    
    $detailedSections += "---"
}

# Read existing MD file
$mdContent = Get-Content $mdFile -Raw

# Find the insertion point (after "---" that ends the overview section)
if ($mdContent -match "(?s)(.*?---\r?\n)(.*)") {
    $beforeDivider = $matches[1]
    $afterDivider = $matches[2]
    
    # Check if detailed entries already exist
    if ($afterDivider -match "## \[\d{4}-\d{2}-\d{2}\]") {
        # Replace existing detailed sections
        $newContent = $beforeDivider + "`n" + ($detailedSections -join "`n")
        Write-Host "✓ Updated existing detailed entries" -ForegroundColor Green
    }
    else {
        # Append new detailed sections
        $newContent = $beforeDivider + "`n" + ($detailedSections -join "`n")
        Write-Host "✓ Added detailed entries" -ForegroundColor Green
    }
}
else {
    Write-Warning "Could not find '---' divider in $mdFile. Cannot append entries."
    exit 1
}

# Write back
try {
    Set-Content -Path $mdFile -Value $newContent -NoNewline -Encoding UTF8
    Write-Host "✓ Detailed entries successfully written" -ForegroundColor Green
} catch {
    Write-Error "Failed to write to $mdFile : $($_.Exception.Message)"
    exit 1
}

Write-Host "Detailed entries generated for $Scope scope" -ForegroundColor Cyan
Write-Host "  Entries: $($entries.Count) | Dates: $($grouped.Count)"
Write-Host "  Output: $mdFile"
