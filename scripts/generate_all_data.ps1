<#
.SYNOPSIS
  Generates missing blueprint tables, canonical-buildings.json, weapon catalog,
  core template inheritance, tier chains, entity lifecycle, and per-civ gap-fill
  from existing workspace JSON + external EBP XML dump.

.DESCRIPTION
  Phase 1: Generate 14 missing civ blueprint reference tables (references/blueprints/)
  Phase 2: Generate canonical-buildings.json (data/aoe4/data/canonical/)
  Phase 3: Generate standalone weapon catalog (data/aoe4/data/canonical/weapon-catalog.json)
  Phase 4: Cross-reference workspace JSON vs external XML dump
  Phase 5: Extract core template inheritance (core-templates.json, inheritance-map.json)
  Phase 6: Extract tier upgrade chains + weapon linkage (tier-chains.json, unit-weapon-linkage.json)
  Phase 7: Build unified entity lifecycle catalog (entity-lifecycle.json)
  Phase 8: Per-civ EBP gap fill from XML dump (appends to blueprint tables)
  Phase 9: HA variant delta extraction (ha-variant-deltas.json + per-variant files)
  Phase 10: Neutral & special entity merge (neutral-entities.json + blueprint update)
  Phase 11: Onslaught function + globals + imports index (onslaught-function-index, onslaught-globals-index, onslaught-imports-index)
  Phase 12: Onslaught API usage cross-reference (onslaught-api-usage-map)
  Phase 13: Campaign & rogue entity extraction (campaign-entities.json + campaign-blueprints.md)
  Phase 14: Onslaught event-handler cross-reference (onslaught-event-handlers.csv, onslaught-event-handler-map.md)
  Phase 15: Onslaught options schema (onslaught-options-schema.md)
  Phase 16: Onslaught blueprint usage audit (onslaught-blueprint-audit.csv, onslaught-blueprint-audit.md)
  Phase 17: Onslaught reward tree extraction (onslaught-reward-trees.csv, onslaught-reward-trees.md)
  Phase 18: Onslaught debug command inventory (onslaught-debug-commands.csv, onslaught-debug-commands.md)
  Phase 19: Onslaught module lifecycle delegate map (onslaught-module-lifecycle.csv, onslaught-module-lifecycle.md)
  Phase 20: SCAR engine API typed CSV export (scar-engine-functions.csv, scar-engine-constants.csv)

.PARAMETER ExternalDump
  Path to the external Gameplay_data_duplicate EBP races folder.
  Default: C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races
#>
param(
    [string]$ExternalDump = "C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races"
)

$ErrorActionPreference = 'Stop'
$root = "c:\Users\Jordan\Documents\AoE4-Workspace"
$dataRoot = Join-Path $root "data\aoe4\data"
$bpRoot = Join-Path $root "references\blueprints"
$canonRoot = Join-Path $dataRoot "canonical"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# =====================================================================
# CIV NAME MAPPING: folder name -> display name + suffix
# =====================================================================
$civMap = @{
    "abbasid"          = @{ display = "Abbasid Dynasty"; suffix = "ABB"; existing = $true }
    "ayyubids"         = @{ display = "Ayyubids"; suffix = "AYY"; existing = $false }
    "byzantines"       = @{ display = "Byzantines"; suffix = "BYZ"; existing = $false }
    "chinese"          = @{ display = "Chinese"; suffix = "CHI"; existing = $true }
    "delhi"            = @{ display = "Delhi Sultanate"; suffix = "SUL"; existing = $false }
    "english"          = @{ display = "English"; suffix = "ENG"; existing = $true }
    "french"           = @{ display = "French"; suffix = "FR"; existing = $true }
    "goldenhorde"      = @{ display = "Golden Horde"; suffix = "GOL"; existing = $false }
    "hre"              = @{ display = "Holy Roman Empire"; suffix = "HRE"; existing = $true }
    "japanese"         = @{ display = "Japanese"; suffix = "JPN"; existing = $false }
    "jeannedarc"       = @{ display = "Jeanne d'Arc"; suffix = "JDA"; existing = $false }
    "lancaster"        = @{ display = "Lancaster"; suffix = "LAN"; existing = $false }
    "macedonian"       = @{ display = "Macedonian"; suffix = "MAC"; existing = $false }
    "malians"          = @{ display = "Malians"; suffix = "MAL"; existing = $false }
    "mongols"          = @{ display = "Mongols"; suffix = "MON"; existing = $true }
    "orderofthedragon" = @{ display = "Order of the Dragon"; suffix = "OTD"; existing = $false }
    "ottomans"         = @{ display = "Ottomans"; suffix = "OTT"; existing = $false }
    "rus"              = @{ display = "Rus"; suffix = "RUS"; existing = $true }
    "sengoku"          = @{ display = "Sengoku"; suffix = "SEN"; existing = $false }
    "templar"          = @{ display = "Templar"; suffix = "TMP"; existing = $false }
    "tughlaq"          = @{ display = "Tughlaq"; suffix = "TUG"; existing = $false }
    "zhuxi"            = @{ display = "Zhu Xi's Legacy"; suffix = "ZHX"; existing = $false }
}

# Existing blueprint files use these names (map from README)
$existingBpFiles = @(
    "abbasid-blueprints.md", "chinese-blueprints.md", "english-blueprints.md",
    "french-blueprints.md", "hre-blueprints.md", "mongol-blueprints.md",
    "rus-blueprints.md", "sultanate-blueprints.md"
)

# Map existing file stems to civ folder names for skip logic
$existingCivFolders = @("abbasid","chinese","english","french","hre","mongols","rus")
# sultanate -> maps to delhi in data folder
$existingCivFolders += "delhi"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " AoE4 Workspace Data Generation" -ForegroundColor Cyan
Write-Host " $timestamp" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan

# =====================================================================
# PHASE 1: Generate Missing Blueprint Tables
# =====================================================================
Write-Host "`n--- PHASE 1: Blueprint Reference Tables ---" -ForegroundColor Yellow

function Get-BlueprintEntries {
    param([string]$CivFolder, [string]$Category)

    $entries = @()
    $catDir = Join-Path $dataRoot "$Category\$CivFolder"

    if (Test-Path $catDir) {
        $files = Get-ChildItem $catDir -Filter "*.json"
        foreach ($f in $files) {
            $json = Get-Content $f.FullName -Raw | ConvertFrom-Json
            if ($json.attribName -and $json.pbgid) {
                $entries += [PSCustomObject]@{
                    Name  = $json.attribName.ToUpper()
                    PbgId = $json.pbgid
                    Type  = $Category
                    Age   = $json.age
                }
            }
        }
    }
    return $entries | Sort-Object Name
}

$generatedCount = 0
$skippedCount = 0

foreach ($civKey in ($civMap.Keys | Sort-Object)) {
    $info = $civMap[$civKey]

    # Skip civs that already have blueprint files
    if ($civKey -in $existingCivFolders) {
        $skippedCount++
        continue
    }

    $bpFileName = "$civKey-blueprints.md"
    $bpFilePath = Join-Path $bpRoot $bpFileName

    Write-Host "  Generating: $bpFileName" -ForegroundColor Green

    # Collect all blueprint entries
    $units = Get-BlueprintEntries -CivFolder $civKey -Category "units"
    $buildings = Get-BlueprintEntries -CivFolder $civKey -Category "buildings"
    $techs = Get-BlueprintEntries -CivFolder $civKey -Category "technologies"

    # Build markdown
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine("# $($info.display) - Blueprints")
    [void]$sb.AppendLine()
    [void]$sb.AppendLine("> Auto-generated from workspace JSON data ($timestamp).")
    [void]$sb.AppendLine("> Use with ``BP_GetSquadBlueprint()``, ``BP_GetEntityBlueprint()``, ``BP_GetUpgradeBlueprint()``")
    [void]$sb.AppendLine()
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine()

    # Units (SBP)
    [void]$sb.AppendLine("## Squad Blueprints (SBP) - Units")
    [void]$sb.AppendLine()
    if ($units.Count -gt 0) {
        [void]$sb.AppendLine("| Blueprint Name | PBG ID |")
        [void]$sb.AppendLine("|---|---|")
        foreach ($u in $units) {
            [void]$sb.AppendLine("| ``$($u.Name)`` | $($u.PbgId) |")
        }
    } else {
        [void]$sb.AppendLine("_No unit blueprints found._")
    }
    [void]$sb.AppendLine()

    # Buildings (EBP)
    [void]$sb.AppendLine("## Entity Blueprints (EBP) - Buildings & Entities")
    [void]$sb.AppendLine()
    if ($buildings.Count -gt 0) {
        [void]$sb.AppendLine("| Blueprint Name | PBG ID |")
        [void]$sb.AppendLine("|---|---|")
        foreach ($b in $buildings) {
            [void]$sb.AppendLine("| ``$($b.Name)`` | $($b.PbgId) |")
        }
    } else {
        [void]$sb.AppendLine("_No building blueprints found._")
    }
    [void]$sb.AppendLine()

    # Technologies (UPG)
    [void]$sb.AppendLine("## Upgrade Blueprints (UPG) - Technologies")
    [void]$sb.AppendLine()
    if ($techs.Count -gt 0) {
        [void]$sb.AppendLine("| Blueprint Name | PBG ID |")
        [void]$sb.AppendLine("|---|---|")
        foreach ($t in $techs) {
            [void]$sb.AppendLine("| ``$($t.Name)`` | $($t.PbgId) |")
        }
    } else {
        [void]$sb.AppendLine("_No technology blueprints found._")
    }

    $sb.ToString() | Set-Content -Path $bpFilePath -Encoding UTF8

    $generatedCount++
    Write-Host "    -> $($units.Count) units, $($buildings.Count) buildings, $($techs.Count) techs" -ForegroundColor Gray
}

Write-Host "`n  Phase 1 complete: $generatedCount tables generated, $skippedCount skipped (already exist)" -ForegroundColor Cyan

# =====================================================================
# PHASE 2: Generate canonical-buildings.json
# =====================================================================
Write-Host "`n--- PHASE 2: Canonical Buildings ---" -ForegroundColor Yellow

$unifiedBuildingsPath = Join-Path $dataRoot "buildings\all-unified.json"
$canonBuildingsPath = Join-Path $canonRoot "canonical-buildings.json"

if (Test-Path $unifiedBuildingsPath) {
    $allBuildings = Get-Content $unifiedBuildingsPath -Raw | ConvertFrom-Json

    $canonEntries = @()
    $buildingList = if ($allBuildings.data) { $allBuildings.data } else { $allBuildings }

    foreach ($bld in $buildingList) {
        $civCodes = @()
        if ($bld.civs) { $civCodes = @($bld.civs) }

        $canonEntries += [PSCustomObject]@{
            baseId       = $bld.baseId
            name         = $bld.name
            type         = "building"
            unique       = if ($null -ne $bld.unique) { $bld.unique } else { $false }
            minAge       = $bld.age
            civs         = $civCodes
            civCount     = $civCodes.Count
            classes      = if ($bld.displayClasses) { @($bld.displayClasses) } else { @() }
            attribName   = if ($bld.attribName) { $bld.attribName } else { "" }
            pbgid        = if ($bld.pbgid) { $bld.pbgid } else { 0 }
        }
    }

    $canonOutput = [PSCustomObject]@{
        _meta = [PSCustomObject]@{
            generated   = $timestamp
            description = "Canonical buildings indexed by baseId. One entry per base concept."
            count       = $canonEntries.Count
        }
        data  = $canonEntries
    }

    $canonOutput | ConvertTo-Json -Depth 10 | Set-Content -Path $canonBuildingsPath -Encoding UTF8
    Write-Host "  Generated: canonical-buildings.json ($($canonEntries.Count) entries)" -ForegroundColor Green
} else {
    Write-Host "  WARN: all-unified.json not found at $unifiedBuildingsPath" -ForegroundColor Red
}

# =====================================================================
# PHASE 3: Standalone Weapon Catalog
# =====================================================================
Write-Host "`n--- PHASE 3: Weapon Catalog ---" -ForegroundColor Yellow

$weaponCatalogPath = Join-Path $canonRoot "weapon-catalog.json"
$weaponEntries = @()
$processedUnits = @{}

foreach ($civKey in ($civMap.Keys | Sort-Object)) {
    $unitDir = Join-Path $dataRoot "units\$civKey"
    if (-not (Test-Path $unitDir)) { continue }

    $unitFiles = Get-ChildItem $unitDir -Filter "*.json"
    foreach ($uf in $unitFiles) {
        $unit = Get-Content $uf.FullName -Raw | ConvertFrom-Json
        if (-not $unit.weapons -or $unit.weapons.Count -eq 0) { continue }

        foreach ($wpn in $unit.weapons) {
            $wpnKey = "$($wpn.name)|$($unit.attribName)"
            if ($processedUnits.ContainsKey($wpnKey)) { continue }
            $processedUnits[$wpnKey] = $true

            $modifiers = @()
            if ($wpn.modifiers) {
                foreach ($mod in $wpn.modifiers) {
                    $modifiers += [PSCustomObject]@{
                        property = $mod.property
                        target   = $mod.target
                        effect   = $mod.effect
                        value    = $mod.value
                    }
                }
            }

            $rangeObj = $null
            if ($wpn.range) {
                $rangeObj = [PSCustomObject]@{
                    min = $wpn.range.min
                    max = $wpn.range.max
                }
            }

            $durObj = $null
            if ($wpn.durations) {
                $durObj = [PSCustomObject]@{
                    aim      = $wpn.durations.aim
                    windup   = $wpn.durations.windup
                    attack   = $wpn.durations.attack
                    winddown = $wpn.durations.winddown
                    reload   = $wpn.durations.reload
                }
            }

            $weaponEntries += [PSCustomObject]@{
                weaponName = $wpn.name
                type       = if ($wpn.type) { $wpn.type } else { "unknown" }
                damage     = $wpn.damage
                speed      = $wpn.speed
                range      = $rangeObj
                durations  = $durObj
                modifiers  = $modifiers
                unitSource = $unit.attribName
                unitName   = $unit.name
                civ        = $civKey
                age        = $unit.age
            }
        }
    }
}

$weaponOutput = [PSCustomObject]@{
    _meta = [PSCustomObject]@{
        generated   = $timestamp
        description = "Standalone weapon catalog extracted from all unit weapon profiles. Keyed by weapon name + unit source."
        count       = $weaponEntries.Count
    }
    data = $weaponEntries | Sort-Object { $_.weaponName }, { $_.civ }
}

$weaponOutput | ConvertTo-Json -Depth 10 | Set-Content -Path $weaponCatalogPath -Encoding UTF8
Write-Host "  Generated: weapon-catalog.json ($($weaponEntries.Count) entries)" -ForegroundColor Green

# =====================================================================
# PHASE 4: Cross-Reference vs External XML Dump
# =====================================================================
Write-Host "`n--- PHASE 4: Cross-Reference External XML Dump ---" -ForegroundColor Yellow

$crossRefPath = Join-Path $dataRoot "cross-reference-report.json"

if (-not (Test-Path $ExternalDump)) {
    Write-Host "  WARN: External dump not found at $ExternalDump — skipping cross-reference" -ForegroundColor Red
} else {
    # Build set of all workspace attribNames
    $wsAttribNames = @{}
    foreach ($category in @("units","buildings","technologies")) {
        $catDir = Join-Path $dataRoot $category
        foreach ($civDir in (Get-ChildItem $catDir -Directory)) {
            foreach ($f in (Get-ChildItem $civDir.FullName -Filter "*.json")) {
                $json = Get-Content $f.FullName -Raw | ConvertFrom-Json
                if ($json.attribName) {
                    $wsAttribNames[$json.attribName.ToLower()] = [PSCustomObject]@{
                        category = $category
                        civ      = $civDir.Name
                        pbgid    = $json.pbgid
                    }
                }
            }
        }
    }

    Write-Host "  Workspace has $($wsAttribNames.Count) unique attribNames" -ForegroundColor Gray

    # Scan external XML files and extract names/pbgids
    $externalEntities = @()
    $missingInWorkspace = @()
    $raceDirs = Get-ChildItem $ExternalDump -Directory

    foreach ($raceDir in $raceDirs) {
        $xmlFiles = Get-ChildItem $raceDir.FullName -Recurse -Filter "*.xml" -File
        foreach ($xf in $xmlFiles) {
            # Derive attribName from path: race/category/filename (without .xml)
            $relPath = $xf.FullName.Substring($ExternalDump.Length + 1).Replace('\','/')
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($xf.Name)
            $race = $raceDir.Name

            # Extract pbgid from XML (quick regex)
            $xmlContent = Get-Content $xf.FullName -Raw -ErrorAction SilentlyContinue
            $pbgid = 0
            if ($xmlContent -match 'name="pbgid"\s+value="(\d+)"') {
                $pbgid = [int]$Matches[1]
            }

            $entity = [PSCustomObject]@{
                race     = $race
                path     = $relPath
                baseName = $baseName
                pbgid    = $pbgid
            }
            $externalEntities += $entity

            # Check if this entity (by basename) exists in workspace
            if (-not $wsAttribNames.ContainsKey($baseName.ToLower())) {
                $missingInWorkspace += $entity
            }
        }
    }

    Write-Host "  External dump has $($externalEntities.Count) XML files across $($raceDirs.Count) races" -ForegroundColor Gray
    Write-Host "  Missing in workspace: $($missingInWorkspace.Count) entities" -ForegroundColor $(if ($missingInWorkspace.Count -gt 0) { "Yellow" } else { "Green" })

    # Categorize missing by race
    $missingByRace = @{}
    foreach ($m in $missingInWorkspace) {
        if (-not $missingByRace.ContainsKey($m.race)) {
            $missingByRace[$m.race] = @()
        }
        $missingByRace[$m.race] += $m
    }

    # Also find workspace entries NOT in external (API-only entities)
    $externalBaseNames = @{}
    foreach ($e in $externalEntities) {
        $externalBaseNames[$e.baseName.ToLower()] = $true
    }

    $workspaceOnlyCount = 0
    foreach ($key in $wsAttribNames.Keys) {
        if (-not $externalBaseNames.ContainsKey($key)) {
            $workspaceOnlyCount++
        }
    }
    Write-Host "  Workspace-only (no XML match): $workspaceOnlyCount entities" -ForegroundColor Gray

    # Build report
    $racesSummary = @()
    foreach ($race in ($missingByRace.Keys | Sort-Object)) {
        $items = $missingByRace[$race]
        $racesSummary += [PSCustomObject]@{
            race         = $race
            missingCount = $items.Count
            samples      = ($items | Select-Object -First 10 baseName, path, pbgid)
        }
    }

    $reportOutput = [PSCustomObject]@{
        _meta = [PSCustomObject]@{
            generated         = $timestamp
            description       = "Cross-reference report: workspace JSON vs external XML EBP dump"
            externalDumpPath  = $ExternalDump
        }
        summary = [PSCustomObject]@{
            workspaceAttribNames   = $wsAttribNames.Count
            externalXmlFiles       = $externalEntities.Count
            externalRaces          = $raceDirs.Count
            missingInWorkspace     = $missingInWorkspace.Count
            workspaceOnlyEntities  = $workspaceOnlyCount
        }
        missingByRace = $racesSummary
    }

    $reportOutput | ConvertTo-Json -Depth 10 | Set-Content -Path $crossRefPath -Encoding UTF8
    Write-Host "  Generated: cross-reference-report.json" -ForegroundColor Green
}

# =====================================================================
# PHASE 5: Update README
# =====================================================================
Write-Host "`n--- PHASE 5: Updating Blueprint README ---" -ForegroundColor Yellow

$allBpFiles = Get-ChildItem $bpRoot -Filter "*-blueprints.md" | Sort-Object Name
$readmePath = Join-Path $bpRoot "README.md"

$readmeSb = [System.Text.StringBuilder]::new()
[void]$readmeSb.AppendLine("# AoE4 Blueprint Reference")
[void]$readmeSb.AppendLine()
[void]$readmeSb.AppendLine("Blueprint data extracted from game data for use in SCAR scripting.")
[void]$readmeSb.AppendLine("Auto-updated: $timestamp")
[void]$readmeSb.AppendLine()
[void]$readmeSb.AppendLine("## Blueprint Types")
[void]$readmeSb.AppendLine()
[void]$readmeSb.AppendLine("| Type | Code | Description |")
[void]$readmeSb.AppendLine("|------|------|-------------|")
[void]$readmeSb.AppendLine("| **SBP** | Squad Blueprint | Units (soldiers, villagers, traders, ships) |")
[void]$readmeSb.AppendLine("| **EBP** | Entity Blueprint | Buildings, walls, landmarks, siege (placed entities) |")
[void]$readmeSb.AppendLine("| **UPG** | Upgrade Blueprint | Technologies, age-ups, unique upgrades |")
[void]$readmeSb.AppendLine()
[void]$readmeSb.AppendLine("## Player Factions")
[void]$readmeSb.AppendLine()

$civFiles = @()
$otherFiles = @()

foreach ($f in $allBpFiles) {
    $stem = $f.BaseName -replace '-blueprints$',''
    if ($civMap.ContainsKey($stem)) {
        $civFiles += $f
    } else {
        $otherFiles += $f
    }
}

foreach ($f in $civFiles) {
    $stem = $f.BaseName -replace '-blueprints$',''
    $displayName = if ($civMap.ContainsKey($stem)) { $civMap[$stem].display } else { $stem }
    # Count entries by reading file
    $content = Get-Content $f.FullName -Raw
    $unitCount = ([regex]::Matches($content, '(?<=## Squad Blueprints)[\s\S]*?(?=##|$)') |
        ForEach-Object { ([regex]::Matches($_.Value, '^\|.*\|.*\|$', 'Multiline')).Count - 1 }) | Select-Object -First 1
    $buildingCount = ([regex]::Matches($content, '(?<=## Entity Blueprints)[\s\S]*?(?=##|$)') |
        ForEach-Object { ([regex]::Matches($_.Value, '^\|.*\|.*\|$', 'Multiline')).Count - 1 }) | Select-Object -First 1
    $techCount = ([regex]::Matches($content, '(?<=## Upgrade Blueprints)[\s\S]*?(?=##|$)') |
        ForEach-Object { ([regex]::Matches($_.Value, '^\|.*\|.*\|$', 'Multiline')).Count - 1 }) | Select-Object -First 1

    if ($null -eq $unitCount) { $unitCount = 0 }
    if ($null -eq $buildingCount) { $buildingCount = 0 }
    if ($null -eq $techCount) { $techCount = 0 }

    [void]$readmeSb.AppendLine("- [$displayName]($($f.Name)) - $unitCount units, $buildingCount buildings, $techCount techs")
}

[void]$readmeSb.AppendLine()
[void]$readmeSb.AppendLine("## Other")
[void]$readmeSb.AppendLine()

foreach ($f in $otherFiles) {
    $stem = $f.BaseName -replace '-blueprints$',''
    [void]$readmeSb.AppendLine("- [$stem]($($f.Name))")
}

$readmeSb.ToString() | Set-Content -Path $readmePath -Encoding UTF8
Write-Host "  Updated: README.md with $($civFiles.Count) civ entries" -ForegroundColor Green

# =====================================================================
# PHASE 5: Core Template Inheritance Extraction
# =====================================================================
Write-Host "`n--- PHASE 5: Core Template Inheritance ---" -ForegroundColor Yellow

if (Test-Path $ExternalDump) {
    Write-Host "  Running extract_inheritance.ps1..." -ForegroundColor Gray
    $inheritScript = Join-Path $root "scripts\extract_inheritance.ps1"
    if (Test-Path $inheritScript) {
        & $inheritScript -ExternalDump $ExternalDump
        $coreTemplatePath = Join-Path $canonRoot "core-templates.json"
        $inheritMapPath = Join-Path $canonRoot "inheritance-map.json"
        $coreCount = if (Test-Path $coreTemplatePath) { ((Get-Content $coreTemplatePath -Raw | ConvertFrom-Json)._meta.count) } else { 0 }
        $inheritCount = if (Test-Path $inheritMapPath) { ((Get-Content $inheritMapPath -Raw | ConvertFrom-Json)._meta.totalEntities) } else { 0 }
        Write-Host "  Core templates: $coreCount" -ForegroundColor Green
        Write-Host "  Inheritance links: $inheritCount" -ForegroundColor Green
    } else {
        Write-Host "  SKIP: extract_inheritance.ps1 not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "  SKIP: External dump not available" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 6: Tier Chain & Weapon Linkage Extraction
# =====================================================================
Write-Host "`n--- PHASE 6: Tier Chains & Weapon Linkage ---" -ForegroundColor Yellow

if (Test-Path $ExternalDump) {
    $tierScript = Join-Path $root "scripts\extract_tier_chains.ps1"
    if (Test-Path $tierScript) {
        Write-Host "  Running extract_tier_chains.ps1..." -ForegroundColor Gray
        & $tierScript -ExternalDump $ExternalDump
        $tierPath = Join-Path $canonRoot "tier-chains.json"
        $wpnLinkPath = Join-Path $canonRoot "unit-weapon-linkage.json"
        $tierCount = if (Test-Path $tierPath) { ((Get-Content $tierPath -Raw | ConvertFrom-Json)._meta.entitiesWithChains) } else { 0 }
        $wpnLinkCount = if (Test-Path $wpnLinkPath) { ((Get-Content $wpnLinkPath -Raw | ConvertFrom-Json)._meta.linkedEntities) } else { 0 }
        Write-Host "  Tier chains: $tierCount entities" -ForegroundColor Green
        Write-Host "  Weapon linkage: $wpnLinkCount entities" -ForegroundColor Green
    } else {
        Write-Host "  SKIP: extract_tier_chains.ps1 not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "  SKIP: External dump not available" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 7: Entity Lifecycle (cross-link inheritance + tiers + weapons)
# =====================================================================
Write-Host "`n--- PHASE 7: Entity Lifecycle ---" -ForegroundColor Yellow

$lifecycleScript = Join-Path $root "scripts\build_entity_lifecycle.ps1"
if (Test-Path $lifecycleScript) {
    Write-Host "  Running build_entity_lifecycle.ps1..." -ForegroundColor Gray
    & $lifecycleScript
    $lifecyclePath = Join-Path $canonRoot "entity-lifecycle.json"
    $lifecycleCount = if (Test-Path $lifecyclePath) { ((Get-Content $lifecyclePath -Raw | ConvertFrom-Json)._meta.totalEntities) } else { 0 }
    Write-Host "  Entity lifecycle: $lifecycleCount entities" -ForegroundColor Green
} else {
    Write-Host "  SKIP: build_entity_lifecycle.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 8: Per-Civ EBP Gap Fill
# =====================================================================
Write-Host "`n--- PHASE 8: Per-Civ Gap Fill ---" -ForegroundColor Yellow

if (Test-Path $ExternalDump) {
    $gapScript = Join-Path $root "scripts\fill_blueprint_gaps.ps1"
    if (Test-Path $gapScript) {
        Write-Host "  Running fill_blueprint_gaps.ps1..." -ForegroundColor Gray
        & $gapScript -ExternalDump $ExternalDump
        $gapReportPath = Join-Path $canonRoot "gap-fill-report.json"
        $gapCount = if (Test-Path $gapReportPath) { ((Get-Content $gapReportPath -Raw | ConvertFrom-Json)._meta.totalGaps) } else { 0 }
        Write-Host "  Gaps filled: $gapCount" -ForegroundColor Green
    } else {
        Write-Host "  SKIP: fill_blueprint_gaps.ps1 not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "  SKIP: External dump not available" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 9: HA Variant Deltas
# =====================================================================
Write-Host "`n--- PHASE 9: HA Variant Deltas ---" -ForegroundColor Yellow

if (Test-Path $ExternalDump) {
    $haScript = Join-Path $root "scripts\extract_ha_deltas.ps1"
    if (Test-Path $haScript) {
        Write-Host "  Running extract_ha_deltas.ps1..." -ForegroundColor Gray
        & $haScript -ExternalDump $ExternalDump
        $haPath = Join-Path $canonRoot "ha-variant-deltas.json"
        $haCount = if (Test-Path $haPath) { ((Get-Content $haPath -Raw | ConvertFrom-Json)._meta.totalEntities) } else { 0 }
        Write-Host "  HA variant entities: $haCount" -ForegroundColor Green
    } else {
        Write-Host "  SKIP: extract_ha_deltas.ps1 not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "  SKIP: External dump not available" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 10: Neutral & Special Entities
# =====================================================================
Write-Host "`n--- PHASE 10: Neutral & Special Entities ---" -ForegroundColor Yellow

if (Test-Path $ExternalDump) {
    $neutralScript = Join-Path $root "scripts\merge_neutral_entities.ps1"
    if (Test-Path $neutralScript) {
        Write-Host "  Running merge_neutral_entities.ps1..." -ForegroundColor Gray
        & $neutralScript -ExternalDump $ExternalDump
        $neutralPath = Join-Path $canonRoot "neutral-entities.json"
        $neutralCount = if (Test-Path $neutralPath) { ((Get-Content $neutralPath -Raw | ConvertFrom-Json)._meta.totalEntities) } else { 0 }
        Write-Host "  Neutral entities: $neutralCount" -ForegroundColor Green
    } else {
        Write-Host "  SKIP: merge_neutral_entities.ps1 not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "  SKIP: External dump not available" -ForegroundColor Yellow
}

# =====================================================================
# SUMMARY
# =====================================================================
Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " GENERATION COMPLETE" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Blueprint tables generated: $generatedCount" -ForegroundColor White
Write-Host "  Canonical buildings: $(if (Test-Path $canonBuildingsPath) { (Get-Content $canonBuildingsPath -Raw | ConvertFrom-Json)._meta.count } else { 'FAILED' })" -ForegroundColor White
Write-Host "  Weapon catalog entries: $($weaponEntries.Count)" -ForegroundColor White
Write-Host "  Cross-reference report: $(if (Test-Path $crossRefPath) { 'generated' } else { 'skipped' })" -ForegroundColor White
Write-Host "  Core templates: $(if (Test-Path (Join-Path $canonRoot 'core-templates.json')) { (Get-Content (Join-Path $canonRoot 'core-templates.json') -Raw | ConvertFrom-Json)._meta.count } else { 'skipped' })" -ForegroundColor White
Write-Host "  Inheritance map: $(if (Test-Path (Join-Path $canonRoot 'inheritance-map.json')) { (Get-Content (Join-Path $canonRoot 'inheritance-map.json') -Raw | ConvertFrom-Json)._meta.totalEntities } else { 'skipped' })" -ForegroundColor White
Write-Host "  Tier chains: $(if (Test-Path (Join-Path $canonRoot 'tier-chains.json')) { (Get-Content (Join-Path $canonRoot 'tier-chains.json') -Raw | ConvertFrom-Json)._meta.entitiesWithChains } else { 'skipped' })" -ForegroundColor White
Write-Host "  Weapon linkage: $(if (Test-Path (Join-Path $canonRoot 'unit-weapon-linkage.json')) { (Get-Content (Join-Path $canonRoot 'unit-weapon-linkage.json') -Raw | ConvertFrom-Json)._meta.linkedEntities } else { 'skipped' })" -ForegroundColor White
Write-Host "  Entity lifecycle: $(if (Test-Path (Join-Path $canonRoot 'entity-lifecycle.json')) { (Get-Content (Join-Path $canonRoot 'entity-lifecycle.json') -Raw | ConvertFrom-Json)._meta.totalEntities } else { 'skipped' })" -ForegroundColor White
Write-Host "  Gap fill: $(if (Test-Path (Join-Path $canonRoot 'gap-fill-report.json')) { (Get-Content (Join-Path $canonRoot 'gap-fill-report.json') -Raw | ConvertFrom-Json)._meta.totalGaps } else { 'skipped' }) gaps" -ForegroundColor White
Write-Host "  HA variant deltas: $(if (Test-Path (Join-Path $canonRoot 'ha-variant-deltas.json')) { (Get-Content (Join-Path $canonRoot 'ha-variant-deltas.json') -Raw | ConvertFrom-Json)._meta.totalEntities } else { 'skipped' })" -ForegroundColor White
Write-Host "  Neutral entities: $(if (Test-Path (Join-Path $canonRoot 'neutral-entities.json')) { (Get-Content (Join-Path $canonRoot 'neutral-entities.json') -Raw | ConvertFrom-Json)._meta.totalEntities } else { 'skipped' })" -ForegroundColor White

# =====================================================================
# PHASE 11: Onslaught Function + Globals + Imports Index
# =====================================================================
Write-Host "`n--- PHASE 11: Onslaught Function Index ---" -ForegroundColor Yellow

$onslaughtIndexScript = Join-Path $root "scripts\build_onslaught_index.ps1"
if (Test-Path $onslaughtIndexScript) {
    Write-Host "  Running build_onslaught_index.ps1..." -ForegroundColor Gray
    & $onslaughtIndexScript -Root $root
} else {
    Write-Host "  SKIP: build_onslaught_index.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 12: Onslaught API Usage Cross-Reference
# =====================================================================
Write-Host "`n--- PHASE 12: Onslaught API Usage Map ---" -ForegroundColor Yellow

$apiUsageScript = Join-Path $root "scripts\build_api_usage_map.ps1"
if (Test-Path $apiUsageScript) {
    Write-Host "  Running build_api_usage_map.ps1..." -ForegroundColor Gray
    & $apiUsageScript -Root $root
} else {
    Write-Host "  SKIP: build_api_usage_map.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 13: Campaign & Rogue Entity Extraction
# =====================================================================
Write-Host "`n--- PHASE 13: Campaign & Rogue Entities ---" -ForegroundColor Yellow

if (Test-Path $ExternalDump) {
    $campScript = Join-Path $root "scripts\extract_campaign_entities.ps1"
    if (Test-Path $campScript) {
        Write-Host "  Running extract_campaign_entities.ps1..." -ForegroundColor Gray
        & $campScript -ExternalDump $ExternalDump -Root $root
    } else {
        Write-Host "  SKIP: extract_campaign_entities.ps1 not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "  SKIP: External dump not available" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 14: Onslaught Event-Handler Cross-Reference
# =====================================================================
Write-Host "`n--- PHASE 14: Onslaught Event-Handler Map ---" -ForegroundColor Yellow

$eventScript = Join-Path $root "scripts\build_event_handler_map.ps1"
if (Test-Path $eventScript) {
    Write-Host "  Running build_event_handler_map.ps1..." -ForegroundColor Gray
    & $eventScript -Root $root
} else {
    Write-Host "  SKIP: build_event_handler_map.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 15: Onslaught Options Schema
# =====================================================================
Write-Host "`n--- PHASE 15: Onslaught Options Schema ---" -ForegroundColor Yellow

$optionsScript = Join-Path $root "scripts\build_options_schema.ps1"
if (Test-Path $optionsScript) {
    Write-Host "  Running build_options_schema.ps1..." -ForegroundColor Gray
    & $optionsScript -Root $root
} else {
    Write-Host "  SKIP: build_options_schema.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 16: Onslaught Blueprint Usage Audit
# =====================================================================
Write-Host "`n--- PHASE 16: Onslaught Blueprint Audit ---" -ForegroundColor Yellow

$bpAuditScript = Join-Path $root "scripts\audit_blueprint_usage.ps1"
if (Test-Path $bpAuditScript) {
    Write-Host "  Running audit_blueprint_usage.ps1..." -ForegroundColor Gray
    & $bpAuditScript -Root $root
} else {
    Write-Host "  SKIP: audit_blueprint_usage.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 17: Onslaught Reward Tree Extraction
# =====================================================================
Write-Host "`n--- PHASE 17: Onslaught Reward Trees ---" -ForegroundColor Yellow

$rewardScript = Join-Path $root "scripts\extract_reward_trees.ps1"
if (Test-Path $rewardScript) {
    Write-Host "  Running extract_reward_trees.ps1..." -ForegroundColor Gray
    & $rewardScript -Root $root
} else {
    Write-Host "  SKIP: extract_reward_trees.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 18: Onslaught Debug Command Inventory
# =====================================================================
Write-Host "`n--- PHASE 18: Onslaught Debug Commands ---" -ForegroundColor Yellow

$debugCmdScript = Join-Path $root "scripts\build_debug_command_index.ps1"
if (Test-Path $debugCmdScript) {
    Write-Host "  Running build_debug_command_index.ps1..." -ForegroundColor Gray
    & $debugCmdScript -Root $root
} else {
    Write-Host "  SKIP: build_debug_command_index.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 19: Onslaught Module Lifecycle Map
# =====================================================================
Write-Host "`n--- PHASE 19: Onslaught Module Lifecycle ---" -ForegroundColor Yellow

$lifecycleScript = Join-Path $root "scripts\build_module_lifecycle.ps1"
if (Test-Path $lifecycleScript) {
    Write-Host "  Running build_module_lifecycle.ps1..." -ForegroundColor Gray
    & $lifecycleScript -Root $root
} else {
    Write-Host "  SKIP: build_module_lifecycle.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 20: SCAR Engine API CSV Export
# =====================================================================
Write-Host "`n--- PHASE 20: SCAR Engine API CSV ---" -ForegroundColor Yellow

$apiCsvScript = Join-Path $root "scripts\export_scar_api_csv.ps1"
if (Test-Path $apiCsvScript) {
    Write-Host "  Running export_scar_api_csv.ps1..." -ForegroundColor Gray
    & $apiCsvScript -Root $root
} else {
    Write-Host "  SKIP: export_scar_api_csv.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 21: Cardinal UCS Localization Map
# =====================================================================
Write-Host "`n--- PHASE 21: Cardinal UCS Localization Map ---" -ForegroundColor Yellow

$ucsMapScript = Join-Path $root "scripts\extract_cardinal_ucs_map.ps1"
if (Test-Path $ucsMapScript) {
    Write-Host "  Running extract_cardinal_ucs_map.ps1..." -ForegroundColor Gray
    & $ucsMapScript -Root $root
} else {
    Write-Host "  SKIP: extract_cardinal_ucs_map.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 22: Build Phase A Critical Artifacts
# =====================================================================
Write-Host "`n--- PHASE 22: Build Phase A Critical Artifacts ---" -ForegroundColor Yellow

$phaseABuildScript = Join-Path $root "scripts\build_phase_a_critical_artifacts.ps1"
if (Test-Path $phaseABuildScript) {
    Write-Host "  Running build_phase_a_critical_artifacts.ps1..." -ForegroundColor Gray
    & $phaseABuildScript -Root $root
} else {
    Write-Host "  SKIP: build_phase_a_critical_artifacts.ps1 not found" -ForegroundColor Yellow
}

# =====================================================================
# PHASE 23: Phase A Critical Sections Verification
# =====================================================================
Write-Host "`n--- PHASE 23: Phase A Critical Sections Verification ---" -ForegroundColor Yellow

$phaseAVerifyScript = Join-Path $root "scripts\verify_phase_a_critical_sections.ps1"
if (Test-Path $phaseAVerifyScript) {
    Write-Host "  Running verify_phase_a_critical_sections.ps1..." -ForegroundColor Gray
    & $phaseAVerifyScript -Root $root
} else {
    Write-Host "  SKIP: verify_phase_a_critical_sections.ps1 not found" -ForegroundColor Yellow
}
