<#
.SYNOPSIS
  Builds a module lifecycle delegate map for Onslaught.

.DESCRIPTION
  Finds all Core_RegisterModule() calls, resolves module name strings,
  then scans for ModuleName_Phase() delegate functions.
  Outputs the lifecycle participation matrix as CSV + markdown.

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

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Onslaught Module Lifecycle Map" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# =====================================================================
# 1. FIND ALL MODULE REGISTRATIONS
# =====================================================================
$allFiles = Get-ChildItem -Path $scarRoot -Recurse -Filter "*.scar" | Sort-Object FullName

# First pass: collect all MODULE = "value" constant definitions
$moduleConstants = @{}
$constRx = [regex]::new('(\w+_MODULE)\s*=\s*"([^"]+)"', 'Compiled')
foreach ($file in $allFiles) {
    foreach ($line in [System.IO.File]::ReadAllLines($file.FullName)) {
        $m = $constRx.Match($line)
        if ($m.Success) {
            $moduleConstants[$m.Groups[1].Value] = $m.Groups[2].Value
        }
    }
}
# Also handle module = "string" patterns in local tables
$moduleLocalRx = [regex]::new('(\w+)\.module\s*=\s*"([^"]+)"', 'Compiled')
foreach ($file in $allFiles) {
    foreach ($line in [System.IO.File]::ReadAllLines($file.FullName)) {
        $m = $moduleLocalRx.Match($line)
        if ($m.Success) {
            $moduleConstants["$($m.Groups[1].Value).module"] = $m.Groups[2].Value
        }
    }
}

# Second pass: find Core_RegisterModule() calls and resolve module names
$registerRx = [regex]::new('Core_RegisterModule\(\s*([^)]+)\s*\)', 'Compiled')
$modules = [System.Collections.Generic.Dictionary[string, PSCustomObject]]::new()

foreach ($file in $allFiles) {
    $relPath = $file.FullName.Substring($scarRoot.Length + 1).Replace('\', '/')
    $lines = [System.IO.File]::ReadAllLines($file.FullName)
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $rm = $registerRx.Match($lines[$i])
        if (-not $rm.Success) { continue }

        $rawArg = $rm.Groups[1].Value.Trim()
        # Resolve to string name
        $moduleName = ""
        if ($rawArg -match '^"([^"]+)"$') {
            $moduleName = $Matches[1]
        } elseif ($moduleConstants.ContainsKey($rawArg)) {
            $moduleName = $moduleConstants[$rawArg]
        } else {
            $moduleName = $rawArg  # Unresolved, use raw
        }

        if (-not $modules.ContainsKey($moduleName)) {
            $modules[$moduleName] = [PSCustomObject]@{
                Name     = $moduleName
                File     = $relPath
                Line     = $i + 1
                RawConst = $rawArg
            }
        }
    }
}

Write-Host "  Modules registered: $($modules.Count)" -ForegroundColor Green

# =====================================================================
# 2. CANONICAL LIFECYCLE PHASE ORDER (from cba.scar init flow)
# =====================================================================
$lifecyclePhases = @(
    "SetupSettings",
    "AdjustSettings",
    "UpdateModuleSettings",
    "DiplomacyEnabled",
    "TributeEnabled",
    "EarlyInitializations",
    "LateInitializations",
    "PresetInitialize",
    "PresetExecute",
    "PresetFinalize",
    "PrepareStart",
    "OnStarting",
    "OnPlay",
    "OnPlayerDefeated",
    "OnGameOver",
    "OnObjectiveToggle",
    # Event delegates
    "TreatyStarted",
    "TreatyEnded",
    "OnDamageReceived",
    "OnEntityKilled",
    "OnLandmarkDestroyed",
    "OnConstructionComplete"
)

# =====================================================================
# 3. SCAN FOR DELEGATE FUNCTIONS PER MODULE
# =====================================================================
$delegateEntries = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($modEntry in $modules.Values) {
    $modName = $modEntry.Name
    # Build regex for ModuleName_Phase() patterns
    $funcPrefix = [regex]::Escape($modName) + '_'

    foreach ($file in $allFiles) {
        $relPath = $file.FullName.Substring($scarRoot.Length + 1).Replace('\', '/')
        $lines = [System.IO.File]::ReadAllLines($file.FullName)
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match "^function\s+${funcPrefix}(\w+)\s*\(") {
                $phase = $Matches[1]
                $delegateEntries.Add([PSCustomObject]@{
                    Module   = $modName
                    Phase    = $phase
                    Function = "${modName}_${phase}"
                    File     = $relPath
                    Line     = $i + 1
                })
            }
        }
    }
}

Write-Host "  Delegate functions found: $($delegateEntries.Count)" -ForegroundColor Green

# =====================================================================
# 4. OUTPUT CSV
# =====================================================================
$csvPath = Join-Path $indexDir "onslaught-module-lifecycle.csv"
$csv = [System.Collections.Generic.List[string]]::new()
$csv.Add('"Module","Phase","Function","File","Line"')
foreach ($d in ($delegateEntries | Sort-Object Module, Phase)) {
    $csv.Add("`"$($d.Module)`",`"$($d.Phase)`",`"$($d.Function)`",`"$($d.File)`",`"$($d.Line)`"")
}
[System.IO.File]::WriteAllLines($csvPath, $csv)
Write-Host "  -> $csvPath ($($delegateEntries.Count) rows)" -ForegroundColor Gray

# =====================================================================
# 5. OUTPUT MARKDOWN
# =====================================================================
$mdPath = Join-Path $modsDir "onslaught-module-lifecycle.md"
$md = [System.Text.StringBuilder]::new()
[void]$md.AppendLine("# Onslaught Module Lifecycle Map")
[void]$md.AppendLine()
[void]$md.AppendLine("Auto-generated on $timestamp. Maps all registered modules to their lifecycle delegate functions.")
[void]$md.AppendLine()
[void]$md.AppendLine("- **$($modules.Count)** registered modules")
[void]$md.AppendLine("- **$($delegateEntries.Count)** delegate function implementations")
[void]$md.AppendLine("- **$($lifecyclePhases.Count)** canonical lifecycle phases")
[void]$md.AppendLine()

# Canonical phase order
[void]$md.AppendLine("## Lifecycle Phase Order")
[void]$md.AppendLine()
[void]$md.AppendLine("Delegates are called in this order during match initialization (from ``cba.scar``):")
[void]$md.AppendLine()
$phaseNum = 0
foreach ($phase in $lifecyclePhases) {
    $phaseNum++
    $participantCount = ($delegateEntries | Where-Object { $_.Phase -eq $phase }).Count
    [void]$md.AppendLine("${phaseNum}. **$phase** — $participantCount modules")
}
[void]$md.AppendLine()

# Phase participation matrix
[void]$md.AppendLine("## Phase Participation Matrix")
[void]$md.AppendLine()

# Build header: Module | Phase1 | Phase2 | ...
$corePhases = $lifecyclePhases | Select-Object -First 13  # Init/runtime phases
$headerLine = "| Module | " + ($corePhases -join " | ") + " |"
$sepLine    = "|--------|" + (($corePhases | ForEach-Object { "---" }) -join "|") + "|"
[void]$md.AppendLine($headerLine)
[void]$md.AppendLine($sepLine)

foreach ($modEntry in ($modules.Values | Sort-Object Name)) {
    $modName = $modEntry.Name
    $modDelegates = $delegateEntries | Where-Object { $_.Module -eq $modName }
    $phaseNames = $modDelegates | Select-Object -ExpandProperty Phase
    $cells = @($modName)
    foreach ($phase in $corePhases) {
        $cells += if ($phaseNames -contains $phase) { "✓" } else { "" }
    }
    [void]$md.AppendLine("| " + ($cells -join " | ") + " |")
}
[void]$md.AppendLine()

# Per-module detail
[void]$md.AppendLine("## Module Details")
[void]$md.AppendLine()
foreach ($modEntry in ($modules.Values | Sort-Object Name)) {
    $modName = $modEntry.Name
    $modDelegates = $delegateEntries | Where-Object { $_.Module -eq $modName } | Sort-Object Phase
    [void]$md.AppendLine("### $modName")
    [void]$md.AppendLine()
    [void]$md.AppendLine("- **Registration:** $($modEntry.File):$($modEntry.Line)")
    [void]$md.AppendLine("- **Delegates:** $($modDelegates.Count)")
    [void]$md.AppendLine()
    if ($modDelegates.Count -gt 0) {
        [void]$md.AppendLine("| Phase | Function | File | Line |")
        [void]$md.AppendLine("|-------|----------|------|------|")
        foreach ($d in $modDelegates) {
            [void]$md.AppendLine("| $($d.Phase) | ``$($d.Function)`` | $($d.File) | $($d.Line) |")
        }
        [void]$md.AppendLine()
    }
}

[System.IO.File]::WriteAllText($mdPath, $md.ToString())
Write-Host "  -> $mdPath" -ForegroundColor Gray

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " Module Lifecycle Map Complete" -ForegroundColor Cyan
Write-Host "  Modules: $($modules.Count) | Delegates: $($delegateEntries.Count)" -ForegroundColor White
Write-Host "================================================================" -ForegroundColor Cyan
