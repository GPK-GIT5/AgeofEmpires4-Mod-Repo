<#
.SYNOPSIS
  Maps official SCAR engine API function usage across Onslaught source files.
  Produces an API cross-reference showing which engine functions are called,
  where, and how frequently.

.DESCRIPTION
  1. Reads scar-engine-api-signatures.md to extract all namespace prefixes
  2. Scans all Onslaught .scar files for calls matching Namespace_FunctionName()
  3. Also detects common Lua/SCAR utility patterns (Rule_Add*, Core_*, Util_*, etc.)
  4. Generates:
     - references/mods/onslaught-api-usage-map.md  (human-readable)
     - references/indexes/onslaught-api-usage.csv   (machine-readable)

.PARAMETER Root
  Workspace root. Default: C:\Users\Jordan\Documents\AoE4-Workspace
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$ErrorActionPreference = 'Stop'
$scarRoot  = Join-Path $Root "Gamemodes\Onslaught\assets\scar"
$sigFile   = Join-Path $Root "references\api\scar-engine-api-signatures.md"
$indexDir  = Join-Path $Root "references\indexes"
$modsDir   = Join-Path $Root "references\mods"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

# =====================================================================
# 1. EXTRACT KNOWN API NAMESPACES FROM SIGNATURES FILE
# =====================================================================
$sigContent = Get-Content $sigFile -Raw
$namespaces = [System.Collections.Generic.HashSet[string]]::new()

# Parse the namespace table: | `Entity` | 230 |
$sigContent -split "`n" | ForEach-Object {
    if ($_ -match '^\|\s*`([A-Za-z_]+)`\s*\|\s*(\d+)\s*\|') {
        [void]$namespaces.Add($Matches[1])
    }
}

# Add well-known SCAR framework prefixes not in engine API
$extraPrefixes = @(
    'Rule', 'Core', 'Util', 'Table', 'Timer', 'Objective',
    'WinCondition', 'Music', 'Ping', 'SetupModule', 'Diplomacy',
    'MissionPrint', 'Tactic', 'Resource', 'AGS', 'Tech',
    'Upgrade', 'Blueprint', 'Ability', 'Tax', 'Population'
)
foreach ($p in $extraPrefixes) {
    [void]$namespaces.Add($p)
}

Write-Host "Loaded $($namespaces.Count) API namespaces/prefixes" -ForegroundColor Cyan

# =====================================================================
# 2. SCAN ONSLAUGHT FILES FOR API CALLS
# =====================================================================
$allFiles = Get-ChildItem -Path $scarRoot -Recurse -Filter "*.scar" | Sort-Object FullName

# Build regex pattern: (Entity|Squad|Player|...)_[A-Za-z0-9_]+
# We look for word-boundary calls like Entity_IsAlive(
$nsPattern = ($namespaces | Sort-Object -Descending { $_.Length } | ForEach-Object { [regex]::Escape($_) }) -join '|'
$callRegex = [regex]::new("(?<!\w)((?:$nsPattern)_[A-Za-z0-9_]+)\s*\(", 'Compiled')

# Track: api_func -> list of {file, line}
$apiUsage = @{}
$fileApiCount = @{}

foreach ($file in $allFiles) {
    $relPath = $file.FullName.Substring($scarRoot.Length + 1).Replace('\', '/')
    $lines   = [System.IO.File]::ReadAllLines($file.FullName)
    $fileCalls = 0

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        # Skip pure comments
        if ($line -match '^\s*--') { continue }

        $matches2 = $callRegex.Matches($line)
        foreach ($m in $matches2) {
            $funcName = $m.Groups[1].Value
            $lineNum  = $i + 1

            if (-not $apiUsage.ContainsKey($funcName)) {
                $apiUsage[$funcName] = [System.Collections.Generic.List[PSCustomObject]]::new()
            }
            $apiUsage[$funcName].Add([PSCustomObject]@{
                File = $relPath
                Line = $lineNum
            })
            $fileCalls++
        }
    }

    if ($fileCalls -gt 0) {
        $fileApiCount[$relPath] = $fileCalls
    }
}

$totalCalls = ($apiUsage.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
$uniqueFuncs = $apiUsage.Count
Write-Host "Found $uniqueFuncs unique API functions with $totalCalls total call sites" -ForegroundColor Green

# =====================================================================
# 3. CLASSIFY BY NAMESPACE
# =====================================================================
$byNamespace = @{}
foreach ($funcName in $apiUsage.Keys) {
    if ($funcName -match '^([A-Za-z]+)_') {
        $ns = $Matches[1]
    } else {
        $ns = "Other"
    }
    if (-not $byNamespace.ContainsKey($ns)) {
        $byNamespace[$ns] = [System.Collections.Generic.List[string]]::new()
    }
    $byNamespace[$ns].Add($funcName)
}

# =====================================================================
# 4. OUTPUT: API USAGE CSV
# =====================================================================
$csvPath = Join-Path $indexDir "onslaught-api-usage.csv"
$csvLines = [System.Collections.Generic.List[string]]::new()
$csvLines.Add('"Namespace","Function","CallCount","Files","FirstFile","FirstLine"')

foreach ($funcName in ($apiUsage.Keys | Sort-Object)) {
    $calls = $apiUsage[$funcName]
    $callCount = $calls.Count
    $uniqueFiles = ($calls | Select-Object -Property File -Unique).Count
    $first = $calls[0]
    $ns = if ($funcName -match '^([A-Za-z]+)_') { $Matches[1] } else { "Other" }
    $csvLines.Add("`"$ns`",`"$funcName`",`"$callCount`",`"$uniqueFiles`",`"$($first.File)`",`"$($first.Line)`"")
}

[System.IO.File]::WriteAllLines($csvPath, $csvLines)
Write-Host "  -> $csvPath ($uniqueFuncs rows)" -ForegroundColor Gray

# =====================================================================
# 5. OUTPUT: API USAGE MAP MARKDOWN
# =====================================================================
$mdPath = Join-Path $modsDir "onslaught-api-usage-map.md"
$md = [System.Text.StringBuilder]::new()
[void]$md.AppendLine("# Onslaught SCAR API Usage Map")
[void]$md.AppendLine()
[void]$md.AppendLine("Auto-generated on $timestamp. Cross-reference of official SCAR engine API functions used in Onslaught.")
[void]$md.AppendLine()
[void]$md.AppendLine("- **$uniqueFuncs** unique API functions called")
[void]$md.AppendLine("- **$totalCalls** total call sites across $($allFiles.Count) files")
[void]$md.AppendLine("- **$($fileApiCount.Count)** files contain API calls")
[void]$md.AppendLine()

# Namespace summary table
[void]$md.AppendLine("## Namespace Summary")
[void]$md.AppendLine()
[void]$md.AppendLine("| Namespace | Unique Functions | Total Calls |")
[void]$md.AppendLine("|-----------|-----------------|-------------|")

$sortedNs = $byNamespace.GetEnumerator() | Sort-Object { 
    ($_.Value | ForEach-Object { $apiUsage[$_].Count } | Measure-Object -Sum).Sum 
} -Descending

foreach ($entry in $sortedNs) {
    $nsCalls = ($entry.Value | ForEach-Object { $apiUsage[$_].Count } | Measure-Object -Sum).Sum
    [void]$md.AppendLine("| ``$($entry.Key)`` | $($entry.Value.Count) | $nsCalls |")
}
[void]$md.AppendLine()

# Top 50 most-called functions
[void]$md.AppendLine("## Top 50 Most-Called API Functions")
[void]$md.AppendLine()
[void]$md.AppendLine("| # | Function | Calls | Files | Example Location |")
[void]$md.AppendLine("|---|----------|-------|-------|-----------------|")

$rank = 0
$topFuncs = $apiUsage.GetEnumerator() | Sort-Object { $_.Value.Count } -Descending | Select-Object -First 50
foreach ($entry in $topFuncs) {
    $rank++
    $calls = $entry.Value
    $uniqueFiles = ($calls | Select-Object -Property File -Unique).Count
    $first = $calls[0]
    [void]$md.AppendLine("| $rank | ``$($entry.Key)`` | $($calls.Count) | $uniqueFiles | $($first.File):$($first.Line) |")
}
[void]$md.AppendLine()

# Per-namespace detail: function list with call counts
[void]$md.AppendLine("## Per-Namespace Detail")
[void]$md.AppendLine()

foreach ($entry in $sortedNs) {
    $ns = $entry.Key
    $funcs = $entry.Value | Sort-Object { $apiUsage[$_].Count } -Descending
    $nsCalls = ($funcs | ForEach-Object { $apiUsage[$_].Count } | Measure-Object -Sum).Sum
    [void]$md.AppendLine("### $ns ($($funcs.Count) functions, $nsCalls calls)")
    [void]$md.AppendLine()
    [void]$md.AppendLine("| Function | Calls | Files |")
    [void]$md.AppendLine("|----------|-------|-------|")
    foreach ($fn in $funcs) {
        $calls = $apiUsage[$fn]
        $uniqueFiles = ($calls | Select-Object -Property File -Unique).Count
        [void]$md.AppendLine("| ``$fn`` | $($calls.Count) | $uniqueFiles |")
    }
    [void]$md.AppendLine()
}

# Top 20 files by API call density
[void]$md.AppendLine("## Top 20 Files by API Call Density")
[void]$md.AppendLine()
[void]$md.AppendLine("| # | File | API Calls |")
[void]$md.AppendLine("|---|------|-----------|")

$rank = 0
$topFiles = $fileApiCount.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 20
foreach ($entry in $topFiles) {
    $rank++
    [void]$md.AppendLine("| $rank | $($entry.Key) | $($entry.Value) |")
}
[void]$md.AppendLine()

[System.IO.File]::WriteAllText($mdPath, $md.ToString())
Write-Host "  -> $mdPath" -ForegroundColor Gray

# =====================================================================
# SUMMARY
# =====================================================================
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Onslaught API Usage Map Complete" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Unique API functions: $uniqueFuncs"
Write-Host "  Total call sites:    $totalCalls"
Write-Host "  Files with API calls: $($fileApiCount.Count)"
Write-Host "  Namespaces:          $($byNamespace.Count)"
Write-Host "================================================================" -ForegroundColor Cyan
