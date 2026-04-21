<#
.SYNOPSIS
  Verifies critical workspace completeness sections for Phase A.

.DESCRIPTION
  Emits a machine-readable status report for critical sections:
    1) cardinal.ucs presence
    2) canonical UCS localization map presence/coverage
    3) compiled archive domains (Attrib/Data/XP3Data) extraction status
    4) standalone weapon stats extraction status

  Output:
    - data/aoe4/data/canonical/critical-sections-report.json
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace",
    [string]$ReportPath = ""
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($ReportPath)) {
    $ReportPath = Join-Path $Root "data\aoe4\data\canonical\critical-sections-report.json"
}

function New-Check {
    param(
        [string]$Name,
        [string]$Status,
        [string]$Details,
        [string]$PathHint
    )

    return [PSCustomObject]@{
        section  = $Name
        status   = $Status
        details  = $Details
        pathHint = $PathHint
    }
}

$checks = New-Object System.Collections.Generic.List[object]

$ucsPath = Join-Path $Root "data\aoe4\cardinal.ucs"
$locMapPath = Join-Path $Root "data\aoe4\data\canonical\localization-cardinal-ucs.json"

# 1) cardinal.ucs presence
if (Test-Path $ucsPath) {
    $checks.Add((New-Check -Name "cardinal.ucs extracted" -Status "ok" -Details "Found extracted UCS source file." -PathHint "data/aoe4/cardinal.ucs"))
} else {
    $checks.Add((New-Check -Name "cardinal.ucs extracted" -Status "missing" -Details "Missing extracted UCS source file." -PathHint "data/aoe4/cardinal.ucs"))
}

# 2) canonical UCS map coverage
if ((Test-Path $ucsPath) -and (Test-Path $locMapPath)) {
    $ucsCount = ([System.IO.File]::ReadLines($ucsPath) | Where-Object { $_ -match '^\s*\d+\t' } | Measure-Object).Count
    $locJson = Get-Content $locMapPath -Raw | ConvertFrom-Json
    $mapCount = if ($locJson._meta.totalEntries) { [int]$locJson._meta.totalEntries } else { 0 }

    if ($mapCount -ge $ucsCount -and $mapCount -gt 0) {
        $checks.Add((New-Check -Name "canonical localization map" -Status "ok" -Details "Canonical map present with $mapCount entries (UCS parse lines: $ucsCount)." -PathHint "data/aoe4/data/canonical/localization-cardinal-ucs.json"))
    } elseif ($mapCount -gt 0) {
        $checks.Add((New-Check -Name "canonical localization map" -Status "partial" -Details "Canonical map has $mapCount entries, lower than expected UCS parse lines $ucsCount." -PathHint "data/aoe4/data/canonical/localization-cardinal-ucs.json"))
    } else {
        $checks.Add((New-Check -Name "canonical localization map" -Status "missing" -Details "Canonical map file exists but has no entries." -PathHint "data/aoe4/data/canonical/localization-cardinal-ucs.json"))
    }
} else {
    $checks.Add((New-Check -Name "canonical localization map" -Status "missing" -Details "Missing canonical ID-to-text map generated from cardinal.ucs." -PathHint "data/aoe4/data/canonical/localization-cardinal-ucs.json"))
}

# 3) archive domain extraction markers
$archiveMarkers = @(
    @{ Name = "Attrib archive domain"; Path = "data/aoe4/data/canonical/attrib-archive-index.json" },
    @{ Name = "Data archive domain"; Path = "data/aoe4/data/canonical/data-archive-index.json" },
    @{ Name = "XP3Data archive domain"; Path = "data/aoe4/data/canonical/xp3data-archive-index.json" }
)

foreach ($marker in $archiveMarkers) {
    $fullPath = Join-Path $Root $marker.Path
    if (Test-Path $fullPath) {
        $checks.Add((New-Check -Name $marker.Name -Status "ok" -Details "Archive-domain extraction marker exists." -PathHint $marker.Path))
    } else {
        $checks.Add((New-Check -Name $marker.Name -Status "missing" -Details "No extracted archive-domain dataset marker found." -PathHint $marker.Path))
    }
}

# 4) standalone weapon stats extraction marker
$weaponStatsPath = Join-Path $Root "data\aoe4\data\canonical\weapon-standalone-stats.json"
if (Test-Path $weaponStatsPath) {
    $checks.Add((New-Check -Name "Standalone weapon stats" -Status "ok" -Details "Standalone weapon stats dataset exists." -PathHint "data/aoe4/data/canonical/weapon-standalone-stats.json"))
} else {
    $checks.Add((New-Check -Name "Standalone weapon stats" -Status "missing" -Details "Standalone WBP stat dataset not found (known partial extraction gap)." -PathHint "data/aoe4/data/canonical/weapon-standalone-stats.json"))
}

$missingCount = @($checks | Where-Object { $_.status -eq "missing" }).Count
$partialCount = @($checks | Where-Object { $_.status -eq "partial" }).Count
$okCount = @($checks | Where-Object { $_.status -eq "ok" }).Count

$report = [ordered]@{
    _meta = [ordered]@{
        generated = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        description = "Phase A critical section completeness check"
        ok = $okCount
        partial = $partialCount
        missing = $missingCount
    }
    checks = $checks
}

$reportDir = Split-Path -Parent $ReportPath
New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
$report | ConvertTo-Json -Depth 6 | Set-Content -Path $ReportPath -Encoding utf8

Write-Host "Wrote report: $ReportPath" -ForegroundColor Cyan
Write-Host "  OK: $okCount  Partial: $partialCount  Missing: $missingCount" -ForegroundColor Yellow
