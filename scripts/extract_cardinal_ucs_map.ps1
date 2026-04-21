<#
.SYNOPSIS
  Extracts a canonical localization map from data/aoe4/cardinal.ucs.

.DESCRIPTION
  Parses UCS lines of the format: <id><TAB><text>.
  Writes:
    - data/aoe4/data/canonical/localization-cardinal-ucs.json
    - references/indexes/cardinal-ucs-strings.csv
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace",
    [string]$InputFile = "",
    [string]$OutputJson = "",
    [string]$OutputCsv = ""
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($InputFile)) {
    $InputFile = Join-Path $Root "data\aoe4\cardinal.ucs"
}
if ([string]::IsNullOrWhiteSpace($OutputJson)) {
    $OutputJson = Join-Path $Root "data\aoe4\data\canonical\localization-cardinal-ucs.json"
}
if ([string]::IsNullOrWhiteSpace($OutputCsv)) {
    $OutputCsv = Join-Path $Root "references\indexes\cardinal-ucs-strings.csv"
}

if (-not (Test-Path $InputFile)) {
    throw "Input file not found: $InputFile"
}

$outputJsonDir = Split-Path -Parent $OutputJson
$outputCsvDir = Split-Path -Parent $OutputCsv
New-Item -ItemType Directory -Path $outputJsonDir -Force | Out-Null
New-Item -ItemType Directory -Path $outputCsvDir -Force | Out-Null

$lines = [System.IO.File]::ReadAllLines($InputFile)
$entries = New-Object System.Collections.Generic.List[object]
$invalidLineCount = 0
$duplicateCount = 0
$seen = @{}

foreach ($line in $lines) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    if ($line -match '^\s*(\d+)\t(.*)$') {
        $id = [int64]$Matches[1]
        $text = $Matches[2]

        if ($seen.ContainsKey($id)) {
            $duplicateCount++
        } else {
            $seen[$id] = $true
        }

        $entries.Add([PSCustomObject]@{
            id   = $id
            text = $text
        })
    } else {
        $invalidLineCount++
    }
}

$sortedEntries = $entries | Sort-Object id
$entryCount = @($sortedEntries).Count
$minId = if ($entryCount -gt 0) { ($sortedEntries | Select-Object -First 1).id } else { $null }
$maxId = if ($entryCount -gt 0) { ($sortedEntries | Select-Object -Last 1).id } else { $null }

$json = [ordered]@{
    _meta = [ordered]@{
        generated = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        source = "data/aoe4/cardinal.ucs"
        totalEntries = $entryCount
        uniqueIds = $seen.Count
        duplicateIds = $duplicateCount
        invalidLines = $invalidLineCount
        minId = $minId
        maxId = $maxId
        description = "Canonical ID-to-text map parsed from cardinal.ucs"
    }
    data = $sortedEntries
}

$json | ConvertTo-Json -Depth 6 | Set-Content -Path $OutputJson -Encoding utf8
$sortedEntries | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding utf8

Write-Host "Generated localization map:" -ForegroundColor Cyan
Write-Host "  JSON: $OutputJson" -ForegroundColor Gray
Write-Host "  CSV : $OutputCsv" -ForegroundColor Gray
Write-Host "  Entries: $entryCount (unique IDs: $($seen.Count), duplicates: $duplicateCount, invalid lines: $invalidLineCount)" -ForegroundColor Green
