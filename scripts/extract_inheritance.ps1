<#
.SYNOPSIS
  Extracts template inheritance chains from the external EBP XML dump.
  Produces core-templates.json and inheritance-map.json.

.DESCRIPTION
  Phase 1: Parse core template XMLs for default stat values (costs, hitpoints, sight, armor, etc.)
  Phase 2: Scan ALL civ entities for parent_pbg references and overrideParent fields
  Phase 3: Build inheritance-map linking every civ entity → core parent → defaults + overrides
  Phase 4: Produce inheritance-resolved canonical supplement

.PARAMETER ExternalDump
  Path to the external Gameplay_data_duplicate EBP races folder.
#>
param(
    [string]$ExternalDump = "C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races"
)

$ErrorActionPreference = 'Stop'
$root = "c:\Users\Jordan\Documents\AoE4-Workspace"
$canonRoot = Join-Path $root "data\aoe4\data\canonical"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Template Inheritance Extraction" -ForegroundColor Cyan
Write-Host " $timestamp" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan

# =====================================================================
# HELPER: Extract key stat values from XML content
# =====================================================================
function Get-EntityStats {
    param([string]$XmlContent, [string]$FilePath)

    $stats = [ordered]@{}

    # Costs
    $costBlock = $false
    $costs = @{}
    foreach ($line in ($XmlContent -split "`n")) {
        $trimmed = $line.Trim()

        # parent_pbg
        if ($trimmed -match 'name="parent_pbg"\s+value="([^"]*)"') {
            $stats['parentPbg'] = $Matches[1]
        }

        # pbgid
        if ($trimmed -match 'name="pbgid"\s+value="(\d+)"') {
            $stats['pbgid'] = [int]$Matches[1]
        }

        # hitpoints
        if ($trimmed -match 'name="hitpoints"\s+value="([\d.]+)"') {
            $stats['hitpoints'] = [float]$Matches[1]
        }

        # Resource costs (food, wood, stone, gold, popcap)
        if ($trimmed -match 'name="(food|wood|stone|gold|popcap)"\s+value="([\d.]+)"') {
            $key = $Matches[1]
            $val = [float]$Matches[2]
            if (-not $costs.Contains($key) -or $val -gt 0) {
                $costs[$key] = $val
            }
        }

        # time_seconds
        if ($trimmed -match 'name="time_seconds"\s+value="([\d.]+)"') {
            if (-not $stats.Contains('buildTime')) {
                $stats['buildTime'] = [float]$Matches[1]
            }
        }

        # sight_radius / inner_radius
        if ($trimmed -match 'name="(inner_radius|outer_radius)"\s+value="([\d.]+)"') {
            $stats["sight_$($Matches[1])"] = [float]$Matches[2]
        }

        # armor
        if ($trimmed -match 'name="(armor_scalar|armor_scalar_melee|armor_scalar_ranged)"\s+value="([\d.]+)"') {
            $stats[$Matches[1]] = [float]$Matches[2]
        }

        # speed
        if ($trimmed -match 'name="speed_scaling_table"') { }
        if ($trimmed -match 'name="(max_speed)"\s+value="([\d.]+)"') {
            $stats['maxSpeed'] = [float]$Matches[2]
        }

        # Weapon damage
        if ($trimmed -match 'name="(damage)"\s+value="([\d.]+)"') {
            if (-not $stats.Contains('damage')) {
                $stats['damage'] = [float]$Matches[2]
            }
        }

        # Weapon range
        if ($trimmed -match 'name="(max|min)"\s+value="([\d.]+)"' -and $trimmed -notmatch 'speed') {
            $rKey = "range_$($Matches[1])"
            if (-not $stats.Contains($rKey)) {
                $stats[$rKey] = [float]$Matches[2]
            }
        }

        # race_type
        if ($trimmed -match 'name="race_type"\s+value="racebps\\([^"]+)"') {
            $stats['raceType'] = $Matches[1]
        }

        # overrideParent fields
        if ($trimmed -match 'overrideParent="True"') {
            if (-not $stats.Contains('overrideCount')) { $stats['overrideCount'] = 0 }
            $stats['overrideCount']++
        }
    }

    if ($costs.Count -gt 0) { $stats['costs'] = [PSCustomObject]$costs }

    return $stats
}

# =====================================================================
# PHASE 1: Parse Core Templates
# =====================================================================
Write-Host "`n--- PHASE 1: Core Templates ---" -ForegroundColor Yellow

$corePath = Join-Path $ExternalDump "core"
$coreTemplates = @{}

$categories = @("units", "buildings", "weapons")
foreach ($cat in $categories) {
    $catPath = Join-Path $corePath $cat
    if (-not (Test-Path $catPath)) { continue }

    $xmlFiles = Get-ChildItem $catPath -Recurse -Filter "*.xml" -File
    foreach ($xf in $xmlFiles) {
        $content = Get-Content $xf.FullName -Raw
        $baseName = [IO.Path]::GetFileNameWithoutExtension($xf.Name)
        $relPath = "ebps\races\core\$cat\$baseName"

        $stats = Get-EntityStats -XmlContent $content -FilePath $xf.FullName
        $stats['category'] = $cat
        $stats['baseName'] = $baseName
        $stats['templatePath'] = $relPath
        $stats['source'] = $xf.FullName.Substring($ExternalDump.Length + 1).Replace('\', '/')

        $coreTemplates[$relPath] = $stats
    }
}

Write-Host "  Core templates parsed: $($coreTemplates.Count)" -ForegroundColor Green
Write-Host "    units: $(($coreTemplates.Values | Where-Object { $_.category -eq 'units' }).Count)" -ForegroundColor Gray
Write-Host "    buildings: $(($coreTemplates.Values | Where-Object { $_.category -eq 'buildings' }).Count)" -ForegroundColor Gray
Write-Host "    weapons: $(($coreTemplates.Values | Where-Object { $_.category -eq 'weapons' }).Count)" -ForegroundColor Gray

# Save core-templates.json
$coreOutput = [PSCustomObject]@{
    _meta = [PSCustomObject]@{
        generated   = $timestamp
        description = "Core template defaults extracted from EBP XML dump. These are inheritance parents for all civ-specific entities."
        count       = $coreTemplates.Count
        categories  = [PSCustomObject]@{
            units    = ($coreTemplates.Values | Where-Object { $_.category -eq 'units' }).Count
            buildings = ($coreTemplates.Values | Where-Object { $_.category -eq 'buildings' }).Count
            weapons  = ($coreTemplates.Values | Where-Object { $_.category -eq 'weapons' }).Count
        }
    }
    data = [ordered]@{}
}

foreach ($key in ($coreTemplates.Keys | Sort-Object)) {
    $coreOutput.data[$key] = $coreTemplates[$key]
}

$coreOutput | ConvertTo-Json -Depth 10 | Set-Content -Path (Join-Path $canonRoot "core-templates.json") -Encoding UTF8
Write-Host "  Saved: canonical/core-templates.json" -ForegroundColor Green

# =====================================================================
# PHASE 2: Scan All Civ Entities for parent_pbg Links
# =====================================================================
Write-Host "`n--- PHASE 2: Inheritance Map ---" -ForegroundColor Yellow

$inheritanceMap = @{}
$raceDirs = Get-ChildItem $ExternalDump -Directory | Where-Object { $_.Name -ne 'core' }

foreach ($raceDir in $raceDirs) {
    $xmlFiles = Get-ChildItem $raceDir.FullName -Recurse -Filter "*.xml" -File
    foreach ($xf in $xmlFiles) {
        $content = Get-Content $xf.FullName -Raw
        $baseName = [IO.Path]::GetFileNameWithoutExtension($xf.Name)
        $relPath = $xf.FullName.Substring($ExternalDump.Length + 1).Replace('\', '/')

        # Extract parent_pbg
        $parentPbg = $null
        if ($content -match 'name="parent_pbg"\s+value="([^"]*)"') {
            $parentPbg = $Matches[1]
        }

        # Extract pbgid
        $pbgid = 0
        if ($content -match 'name="pbgid"\s+value="(\d+)"') {
            $pbgid = [int]$Matches[1]
        }

        # Count overrideParent fields
        $overrideCount = ([regex]::Matches($content, 'overrideParent="True"')).Count

        # Determine category from path
        $pathParts = $relPath.Split('/')
        $category = "other"
        if ($pathParts.Count -ge 3) {
            $category = $pathParts[1]  # units, buildings, weapons, etc.
        }

        $entry = [PSCustomObject]@{
            entity        = $baseName
            race          = $raceDir.Name
            category      = $category
            path          = $relPath
            pbgid         = $pbgid
            parentPbg     = $parentPbg
            hasParent     = [bool]($parentPbg -and $parentPbg.Length -gt 0)
            parentIsCore  = [bool]($parentPbg -and $parentPbg -match '\\core\\')
            overrideCount = $overrideCount
        }

        $inheritanceMap[$relPath] = $entry
    }
}

Write-Host "  Entities scanned: $($inheritanceMap.Count)" -ForegroundColor Green

# Statistics
$withParent = ($inheritanceMap.Values | Where-Object { $_.hasParent }).Count
$parentIsCore = ($inheritanceMap.Values | Where-Object { $_.parentIsCore }).Count
$noParent = ($inheritanceMap.Values | Where-Object { -not $_.hasParent }).Count
Write-Host "    With parent_pbg: $withParent" -ForegroundColor Gray
Write-Host "    Parent is core: $parentIsCore" -ForegroundColor Gray
Write-Host "    No parent (root): $noParent" -ForegroundColor Gray

# =====================================================================
# PHASE 3: Build Resolved Inheritance Map
# =====================================================================
Write-Host "`n--- PHASE 3: Resolved Inheritance ---" -ForegroundColor Yellow

$resolvedEntries = @()

foreach ($entry in ($inheritanceMap.Values | Sort-Object { $_.race }, { $_.entity })) {
    $resolved = [ordered]@{
        entity        = $entry.entity
        race          = $entry.race
        category      = $entry.category
        path          = $entry.path
        pbgid         = $entry.pbgid
        parentPbg     = $entry.parentPbg
        parentIsCore  = $entry.parentIsCore
        overrideCount = $entry.overrideCount
    }

    # If parent is a core template, link to defaults
    if ($entry.parentIsCore -and $entry.parentPbg) {
        $parentKey = $entry.parentPbg.Replace('/', '\')
        if ($coreTemplates.Contains($parentKey)) {
            $parent = $coreTemplates[$parentKey]
            $resolved['parentDefaults'] = [ordered]@{}
            if ($parent.Contains('hitpoints')) { $resolved['parentDefaults']['hitpoints'] = $parent['hitpoints'] }
            if ($parent.Contains('costs')) { $resolved['parentDefaults']['costs'] = $parent['costs'] }
            if ($parent.Contains('buildTime')) { $resolved['parentDefaults']['buildTime'] = $parent['buildTime'] }
            if ($parent.Contains('maxSpeed')) { $resolved['parentDefaults']['maxSpeed'] = $parent['maxSpeed'] }
            if ($parent.Contains('damage')) { $resolved['parentDefaults']['damage'] = $parent['damage'] }
            if ($parent.Contains('range_max')) { $resolved['parentDefaults']['range_max'] = $parent['range_max'] }
        }
    }

    $resolvedEntries += [PSCustomObject]$resolved
}

# Save inheritance-map.json
$inheritOutput = [PSCustomObject]@{
    _meta = [PSCustomObject]@{
        generated      = $timestamp
        description    = "Entity-to-parent inheritance map. Links civ-specific entities to their core template parents and inherited defaults."
        totalEntities  = $resolvedEntries.Count
        withParent     = $withParent
        parentIsCore   = $parentIsCore
        noParent       = $noParent
    }
    data = $resolvedEntries
}

$inheritOutput | ConvertTo-Json -Depth 10 | Set-Content -Path (Join-Path $canonRoot "inheritance-map.json") -Encoding UTF8
Write-Host "  Saved: canonical/inheritance-map.json ($($resolvedEntries.Count) entries)" -ForegroundColor Green

# =====================================================================
# PHASE 4: Summary Statistics
# =====================================================================
Write-Host "`n--- PHASE 4: Coverage Summary ---" -ForegroundColor Yellow

# Per-race breakdown
$raceBreakdown = $inheritanceMap.Values | Group-Object race | Sort-Object Count -Descending |
    Select-Object @{N='Race';E={$_.Name}}, Count,
        @{N='WithCoreParent';E={($_.Group | Where-Object { $_.parentIsCore }).Count}},
        @{N='Overrides';E={($_.Group | Measure-Object -Property overrideCount -Sum).Sum}}

Write-Host "`n  Race    | Total | CoreParent | Overrides"
Write-Host "  --------|-------|------------|----------"
foreach ($r in $raceBreakdown) {
    Write-Host ("  {0,-7} | {1,5} | {2,10} | {3,9}" -f $r.Race, $r.Count, $r.WithCoreParent, $r.Overrides)
}

# Per-category breakdown
Write-Host "`n  Category | Total | WithParent | CoreParent"
$catBreakdown = $inheritanceMap.Values | Group-Object category | Sort-Object Count -Descending
foreach ($c in $catBreakdown) {
    $wp = ($c.Group | Where-Object { $_.hasParent }).Count
    $cp = ($c.Group | Where-Object { $_.parentIsCore }).Count
    Write-Host ("  {0,-9} | {1,5} | {2,10} | {3,10}" -f $c.Name, $c.Count, $wp, $cp)
}

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " EXTRACTION COMPLETE" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Core templates: $($coreTemplates.Count)" -ForegroundColor White
Write-Host "  Inheritance links: $withParent / $($inheritanceMap.Count) entities" -ForegroundColor White
Write-Host "  Core-linked: $parentIsCore entities" -ForegroundColor White
