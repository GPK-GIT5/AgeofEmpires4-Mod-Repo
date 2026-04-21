<#
.SYNOPSIS
  Extracts the AGS_GLOBAL_SETTINGS options schema from ags_global_settings.scar
  and produces a structured YAML-like reference document.

.DESCRIPTION
  Parses ags_global_settings.scar for:
    - AGS_GS_* enum constants (with values)
    - AGS_GLOBAL_SETTINGS default values (with inline comments)
    - .rdo section mappings from SetupSettings()
  Outputs:
    - references/mods/onslaught-options-schema.md

.PARAMETER Root
  Workspace root. Default: C:\Users\Jordan\Documents\AoE4-Workspace
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$ErrorActionPreference = 'Stop'
$settingsFile = Join-Path $Root "Gamemodes\Onslaught\assets\scar\ags_global_settings.scar"
$modsDir      = Join-Path $Root "references\mods"
$timestamp    = Get-Date -Format "yyyy-MM-dd HH:mm"

$lines = [System.IO.File]::ReadAllLines($settingsFile)
Write-Host "Parsing $($lines.Count) lines from ags_global_settings.scar..." -ForegroundColor Cyan

# =====================================================================
# PHASE 1: EXTRACT ENUM CONSTANTS
# =====================================================================
$enums = [ordered]@{}  # group_name -> list of {name, value}
$currentGroup = ""

foreach ($line in $lines) {
    # Detect enum group from comments like "-- Team Victory"
    if ($line -match '^--\s+([A-Za-z ]+)$') {
        $currentGroup = $Matches[1].Trim()
    }
    # Match: AGS_GS_TEAM_VICTORY_FFA = 0
    if ($line -match '^(AGS_GS_[A-Z_]+)\s*=\s*(-?\d+)') {
        $name  = $Matches[1]
        $value = $Matches[2]
        # Extract comment
        $comment = ""
        if ($line -match '--\s*(.+)$') {
            $comment = $Matches[1].Trim()
        }
        # Auto-detect group from name prefix
        $group = $currentGroup
        if (-not $group -and $name -match '^AGS_GS_([A-Z]+)_') {
            $group = $Matches[1]
        }
        if (-not $enums.Contains($group)) {
            $enums[$group] = [System.Collections.Generic.List[PSCustomObject]]::new()
        }
        $enums[$group].Add([PSCustomObject]@{
            Name    = $name
            Value   = [int]$value
            Comment = $comment
        })
    }
    # Also match fixed constants
    if ($line -match '^(AGS_CBA_[A-Z_]+)\s*=\s*(-?\d+)') {
        $name  = $Matches[1]
        $value = $Matches[2]
        $comment = ""
        if ($line -match '--\s*(.+)$') { $comment = $Matches[1].Trim() }
        $group = "CBA Fixed Limits"
        if (-not $enums.Contains($group)) {
            $enums[$group] = [System.Collections.Generic.List[PSCustomObject]]::new()
        }
        $enums[$group].Add([PSCustomObject]@{
            Name    = $name
            Value   = [int]$value
            Comment = $comment
        })
    }
}

$totalEnums = ($enums.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
Write-Host "  Enum constants: $totalEnums across $($enums.Count) groups" -ForegroundColor Green

# =====================================================================
# PHASE 2: EXTRACT AGS_GLOBAL_SETTINGS DEFAULTS
# =====================================================================
$settings = [System.Collections.Generic.List[PSCustomObject]]::new()
$inSettings = $false
$currentSection = "Top Level"
$braceDepth = 0

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]

    # Detect start of AGS_GLOBAL_SETTINGS table
    if ($line -match '^AGS_GLOBAL_SETTINGS\s*=\s*\{') {
        $inSettings = $true
        $braceDepth = 1
        continue
    }

    if (-not $inSettings) { continue }

    # Track brace depth
    $opens  = ([regex]::Matches($line, '\{')).Count
    $closes = ([regex]::Matches($line, '\}')).Count
    $braceDepth += $opens - $closes

    if ($braceDepth -le 0) { break }

    # Detect section comments like "-- Win Conditions"
    if ($line -match '^\s*--\s+([A-Z][A-Za-z/ -]+)$') {
        $currentSection = $Matches[1].Trim()
        continue
    }

    # Detect nested table start: SomeName = {
    if ($line -match '^\s+([A-Za-z_]+)\s*=\s*\{') {
        $currentSection = $Matches[1]
        continue
    }

    # Match setting: Key = value, -- comment
    if ($line -match '^\s+([A-Za-z_]+)\s*=\s*([^,]+),?\s*(?:--\s*(.+))?$') {
        $key     = $Matches[1]
        $rawVal  = $Matches[2].Trim().TrimEnd(',')
        $comment = if ($Matches[3]) { $Matches[3].Trim() } else { "" }

        # Determine type
        $type = "unknown"
        $enumGroup = ""
        if ($rawVal -eq 'true' -or $rawVal -eq 'false') {
            $type = "bool"
        } elseif ($rawVal -match '^-?\d+$') {
            $type = "int"
        } elseif ($rawVal -match '^-?\d+\.\d+$') {
            $type = "float"
        } elseif ($rawVal -match '^"') {
            $type = "string"
        } elseif ($rawVal -match '^AGS_GS_([A-Z_]+)') {
            $type = "enum"
            # Find enum group
            foreach ($gName in $enums.Keys) {
                foreach ($e in $enums[$gName]) {
                    if ($e.Name -eq $rawVal) {
                        $enumGroup = $gName
                        break
                    }
                }
                if ($enumGroup) { break }
            }
        }

        $settings.Add([PSCustomObject]@{
            Section   = $currentSection
            Key       = $key
            Default   = $rawVal
            Type      = $type
            EnumGroup = $enumGroup
            Comment   = $comment
            Line      = $i + 1
        })
    }
}

Write-Host "  Settings keys: $($settings.Count)" -ForegroundColor Green

# =====================================================================
# PHASE 3: OUTPUT MARKDOWN
# =====================================================================
$mdPath = Join-Path $modsDir "onslaught-options-schema.md"
$md = [System.Text.StringBuilder]::new()
[void]$md.AppendLine("# Onslaught Options Schema")
[void]$md.AppendLine()
[void]$md.AppendLine("Auto-generated on $timestamp from ``ags_global_settings.scar``.")
[void]$md.AppendLine("Complete schema of ``AGS_GLOBAL_SETTINGS`` with types, defaults, enums, and descriptions.")
[void]$md.AppendLine()
[void]$md.AppendLine("- **$($settings.Count)** option keys")
[void]$md.AppendLine("- **$totalEnums** enum constants across $($enums.Count) groups")
[void]$md.AppendLine()

# Enum reference
[void]$md.AppendLine("## Enum Constants")
[void]$md.AppendLine()

foreach ($group in $enums.Keys) {
    [void]$md.AppendLine("### $group")
    [void]$md.AppendLine()
    [void]$md.AppendLine("| Constant | Value | Note |")
    [void]$md.AppendLine("|----------|-------|------|")
    foreach ($e in $enums[$group]) {
        $note = if ($e.Comment) { $e.Comment } else { "" }
        [void]$md.AppendLine("| ``$($e.Name)`` | $($e.Value) | $note |")
    }
    [void]$md.AppendLine()
}

# Settings by section
[void]$md.AppendLine("## Settings Schema")
[void]$md.AppendLine()

$bySection = $settings | Group-Object Section
foreach ($group in $bySection) {
    [void]$md.AppendLine("### $($group.Name)")
    [void]$md.AppendLine()
    [void]$md.AppendLine("| Key | Type | Default | Enum Group | Description |")
    [void]$md.AppendLine("|-----|------|---------|------------|-------------|")
    foreach ($s in $group.Group) {
        $desc = if ($s.Comment) { $s.Comment } else { "" }
        $enumCol = if ($s.EnumGroup) { $s.EnumGroup } else { "" }
        [void]$md.AppendLine("| ``$($s.Key)`` | $($s.Type) | ``$($s.Default)`` | $enumCol | $desc |")
    }
    [void]$md.AppendLine()
}

# Quick lookup: CBA-specific options
[void]$md.AppendLine("## CBA / Onslaught-Specific Options")
[void]$md.AppendLine()
[void]$md.AppendLine("These options are unique to Onslaught mode (not present in standard AGS):")
[void]$md.AppendLine()
[void]$md.AppendLine("| Key | Type | Default | Description |")
[void]$md.AppendLine("|-----|------|---------|-------------|")
$cbaKeys = $settings | Where-Object { $_.Section -match 'CBA|Onslaught' -or $_.Key -match 'CBA|Reward|AutoAge|NoSiege|NoWall|NoArsenal|DockHouse|EliminatedLose|gatherRate|SpecialPopulation' }
foreach ($s in $cbaKeys) {
    $desc = if ($s.Comment) { $s.Comment } else { "" }
    [void]$md.AppendLine("| ``$($s.Key)`` | $($s.Type) | ``$($s.Default)`` | $desc |")
}
[void]$md.AppendLine()

[System.IO.File]::WriteAllText($mdPath, $md.ToString())
Write-Host "  -> $mdPath" -ForegroundColor Gray

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " Options Schema Extraction Complete" -ForegroundColor Cyan
Write-Host "  Keys: $($settings.Count), Enums: $totalEnums" -ForegroundColor White
Write-Host "================================================================" -ForegroundColor Cyan
