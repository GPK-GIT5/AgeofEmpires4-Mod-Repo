<#
.SYNOPSIS
  Extracts event handler registrations, Rule_Add* / Rule_Remove* calls, and
  builds a GE_ event → handler function cross-reference for Onslaught.

.DESCRIPTION
  Scans all Onslaught .scar files for:
    - Rule_AddGlobalEvent(handler, GE_Event)
    - Rule_RemoveGlobalEvent(handler)
    - Rule_AddInterval(handler, interval)
    - Rule_AddOneShot(handler, delay, ...)
    - Rule_Remove(handler)
  Outputs:
    - references/indexes/onslaught-event-handlers.csv
    - references/mods/onslaught-event-handler-map.md

.PARAMETER Root
  Workspace root. Default: C:\Users\Jordan\Documents\AoE4-Workspace
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$ErrorActionPreference = 'Stop'
$scarRoot  = Join-Path $Root "Gamemodes\Onslaught\assets\scar"
$indexDir  = Join-Path $Root "references\indexes"
$modsDir   = Join-Path $Root "references\mods"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

$allFiles = Get-ChildItem -Path $scarRoot -Recurse -Filter "*.scar" | Sort-Object FullName
Write-Host "Scanning $($allFiles.Count) .scar files for event/rule registrations..." -ForegroundColor Cyan

# =====================================================================
# PARSE ALL RULE REGISTRATIONS
# =====================================================================
$eventHandlers = [System.Collections.Generic.List[PSCustomObject]]::new()
$intervalRules = [System.Collections.Generic.List[PSCustomObject]]::new()
$oneShotRules  = [System.Collections.Generic.List[PSCustomObject]]::new()
$removeOps     = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($file in $allFiles) {
    $relPath = $file.FullName.Substring($scarRoot.Length + 1).Replace('\', '/')
    $lines = [System.IO.File]::ReadAllLines($file.FullName)

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $lineNum = $i + 1

        # Skip comments
        if ($line -match '^\s*--') { continue }

        # Rule_AddGlobalEvent(handler, GE_Event)
        if ($line -match 'Rule_AddGlobalEvent\s*\(\s*([A-Za-z_][A-Za-z0-9_.]*)\s*,\s*(GE_[A-Za-z_]+)') {
            $eventHandlers.Add([PSCustomObject]@{
                Handler = $Matches[1]
                Event   = $Matches[2]
                File    = $relPath
                Line    = $lineNum
                Action  = "register"
            })
        }

        # Rule_RemoveGlobalEvent(handler)
        if ($line -match 'Rule_RemoveGlobalEvent\s*\(\s*([A-Za-z_][A-Za-z0-9_.]*)') {
            $removeOps.Add([PSCustomObject]@{
                Handler = $Matches[1]
                Type    = "global_event"
                File    = $relPath
                Line    = $lineNum
            })
        }

        # Rule_AddInterval(handler, seconds)
        if ($line -match 'Rule_AddInterval\s*\(\s*([A-Za-z_][A-Za-z0-9_.]*)\s*,\s*([0-9.]+)') {
            $intervalRules.Add([PSCustomObject]@{
                Handler  = $Matches[1]
                Interval = $Matches[2]
                File     = $relPath
                Line     = $lineNum
            })
        }

        # Rule_AddOneShot(handler, delay, ...)
        if ($line -match 'Rule_AddOneShot\s*\(\s*([A-Za-z_][A-Za-z0-9_.]*)\s*,\s*([0-9.]+)') {
            $oneShotRules.Add([PSCustomObject]@{
                Handler = $Matches[1]
                Delay   = $Matches[2]
                File    = $relPath
                Line    = $lineNum
            })
        }

        # Rule_Remove(handler) — non-event removal
        if ($line -match 'Rule_Remove\s*\(\s*([A-Za-z_][A-Za-z0-9_.]*)' -and $line -notmatch 'Rule_RemoveGlobalEvent') {
            $removeOps.Add([PSCustomObject]@{
                Handler = $Matches[1]
                Type    = "interval_or_oneshot"
                File    = $relPath
                Line    = $lineNum
            })
        }
    }
}

Write-Host "  Event handlers: $($eventHandlers.Count)" -ForegroundColor Green
Write-Host "  Interval rules: $($intervalRules.Count)" -ForegroundColor Green
Write-Host "  OneShot rules:  $($oneShotRules.Count)" -ForegroundColor Green
Write-Host "  Remove ops:     $($removeOps.Count)" -ForegroundColor Green

# =====================================================================
# OUTPUT: CSV
# =====================================================================
$csvPath = Join-Path $indexDir "onslaught-event-handlers.csv"
$csv = [System.Collections.Generic.List[string]]::new()
$csv.Add('"RuleType","Handler","EventOrParam","File","Line"')

foreach ($e in $eventHandlers) {
    $csv.Add("`"global_event`",`"$($e.Handler)`",`"$($e.Event)`",`"$($e.File)`",`"$($e.Line)`"")
}
foreach ($e in $intervalRules) {
    $csv.Add("`"interval`",`"$($e.Handler)`",`"$($e.Interval)s`",`"$($e.File)`",`"$($e.Line)`"")
}
foreach ($e in $oneShotRules) {
    $csv.Add("`"oneshot`",`"$($e.Handler)`",`"$($e.Delay)s`",`"$($e.File)`",`"$($e.Line)`"")
}
foreach ($e in $removeOps) {
    $csv.Add("`"remove_$($e.Type)`",`"$($e.Handler)`",`"`",`"$($e.File)`",`"$($e.Line)`"")
}

[System.IO.File]::WriteAllLines($csvPath, $csv)
Write-Host "  -> $csvPath ($($csv.Count - 1) rows)" -ForegroundColor Gray

# =====================================================================
# OUTPUT: MARKDOWN
# =====================================================================
$mdPath = Join-Path $modsDir "onslaught-event-handler-map.md"
$md = [System.Text.StringBuilder]::new()
[void]$md.AppendLine("# Onslaught Event Handler Map")
[void]$md.AppendLine()
[void]$md.AppendLine("Auto-generated on $timestamp. Maps game events, intervals, and one-shot rules to handler functions.")
[void]$md.AppendLine()

# Summary
$uniqueEvents = ($eventHandlers | Select-Object -Property Event -Unique).Count
$uniqueHandlers = (($eventHandlers + $intervalRules + $oneShotRules) | Select-Object -Property Handler -Unique).Count
[void]$md.AppendLine("- **$($eventHandlers.Count)** global event registrations ($uniqueEvents unique events)")
[void]$md.AppendLine("- **$($intervalRules.Count)** interval rules")
[void]$md.AppendLine("- **$($oneShotRules.Count)** one-shot rules")
[void]$md.AppendLine("- **$uniqueHandlers** unique handler functions")
[void]$md.AppendLine("- **$($removeOps.Count)** removal operations")
[void]$md.AppendLine()

# GE_ Event → Handlers matrix
[void]$md.AppendLine("## Game Event → Handler Matrix")
[void]$md.AppendLine()
[void]$md.AppendLine("| Event | Handlers | Files |")
[void]$md.AppendLine("|-------|----------|-------|")

$byEvent = $eventHandlers | Group-Object Event | Sort-Object { $_.Count } -Descending
foreach ($group in $byEvent) {
    $handlers = ($group.Group | Select-Object -Property Handler -Unique | ForEach-Object { "``$($_.Handler)``" }) -join ", "
    $files = ($group.Group | Select-Object -Property File -Unique | ForEach-Object { $_.File }) -join ", "
    [void]$md.AppendLine("| ``$($group.Name)`` | $handlers | $files |")
}
[void]$md.AppendLine()

# Handler lifecycle: registered + removed
[void]$md.AppendLine("## Handler Lifecycle (Register / Remove Pairs)")
[void]$md.AppendLine()
[void]$md.AppendLine("| Handler | Registered | Removed | Balance |")
[void]$md.AppendLine("|---------|------------|---------|---------|")

$handlerSet = [System.Collections.Generic.HashSet[string]]::new()
foreach ($e in $eventHandlers) { [void]$handlerSet.Add($e.Handler) }
foreach ($e in $intervalRules) { [void]$handlerSet.Add($e.Handler) }

foreach ($handler in ($handlerSet | Sort-Object)) {
    $regCount = ($eventHandlers | Where-Object { $_.Handler -eq $handler }).Count
    $regCount += ($intervalRules | Where-Object { $_.Handler -eq $handler }).Count
    $remCount = ($removeOps | Where-Object { $_.Handler -eq $handler }).Count
    $balance = if ($regCount -gt $remCount) { "+" + ($regCount - $remCount) } elseif ($regCount -lt $remCount) { "-" + ($remCount - $regCount) } else { "balanced" }
    [void]$md.AppendLine("| ``$handler`` | $regCount | $remCount | $balance |")
}
[void]$md.AppendLine()

# Interval rules detail
[void]$md.AppendLine("## Interval Rules")
[void]$md.AppendLine()
[void]$md.AppendLine("| Handler | Interval | File | Line |")
[void]$md.AppendLine("|---------|----------|------|------|")
foreach ($e in ($intervalRules | Sort-Object Handler)) {
    [void]$md.AppendLine("| ``$($e.Handler)`` | $($e.Interval)s | $($e.File) | $($e.Line) |")
}
[void]$md.AppendLine()

# OneShot rules detail
[void]$md.AppendLine("## OneShot Rules (Top 30 by Frequency)")
[void]$md.AppendLine()
[void]$md.AppendLine("| Handler | Delay | Count | Example File |")
[void]$md.AppendLine("|---------|-------|-------|-------------|")
$byOneShot = $oneShotRules | Group-Object Handler | Sort-Object Count -Descending | Select-Object -First 30
foreach ($group in $byOneShot) {
    $first = $group.Group[0]
    [void]$md.AppendLine("| ``$($group.Name)`` | $($first.Delay)s | $($group.Count) | $($first.File) |")
}
[void]$md.AppendLine()

[System.IO.File]::WriteAllText($mdPath, $md.ToString())
Write-Host "  -> $mdPath" -ForegroundColor Gray

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " Event Handler Map Complete" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
