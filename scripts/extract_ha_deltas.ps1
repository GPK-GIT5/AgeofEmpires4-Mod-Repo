<#
.SYNOPSIS
  Extracts HA variant delta data: entity overrides, parent references,
  and variant-unique entities for each Historical Age variant race.

.DESCRIPTION
  For each HA variant folder in the external EBP XML dump:
  1. Parses every entity XML for parent_pbg, pbgid, overrideParent count
  2. Resolves parent to core template or parent-civ entity
  3. Identifies variant-unique entities (no matching base-civ counterpart by name stem)
  4. Produces per-variant delta JSON + unified ha-variant-deltas.json

.PARAMETER ExternalDump
  Path to the external Gameplay_data_duplicate EBP races folder.
  Default: C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races
#>
param(
    [string]$ExternalDump = "C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races"
)

$ErrorActionPreference = 'Stop'
$root = "c:\Users\Jordan\Documents\AoE4-Workspace"
$canonRoot = Join-Path $root "data\aoe4\data\canonical"
$haOutputRoot = Join-Path $root "data\aoe4\data\ha-variants"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if (-not (Test-Path $haOutputRoot)) { New-Item -ItemType Directory -Path $haOutputRoot -Force | Out-Null }

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " HA Variant Delta Extraction" -ForegroundColor Cyan
Write-Host " $timestamp" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan

# HA variant folder -> parent civ folder mapping
$haToParent = [ordered]@{
    "french_ha_01"      = "french"
    "abbasid_ha_01"     = "abbasid"
    "chinese_ha_01"     = "chinese"
    "hre_ha_01"         = "hre"
    "japanese_ha_sen"   = "japanese"
    "mongol_ha_gol"     = "mongol"
    "sultanate_ha_tug"  = "sultanate"
    "lancaster"         = "english"
    "byzantine_ha_mac"  = "byzantine"
}

# Build parent-civ entity index for matching: baseName -> { race, path, pbgid }
Write-Host "`n--- Phase 1: Indexing Parent Civ Entities ---" -ForegroundColor Yellow
$parentCivIndex = @{}
$parentCivRaces = $haToParent.Values | Sort-Object -Unique
foreach ($pcRace in $parentCivRaces) {
    $raceDir = Join-Path $ExternalDump $pcRace
    if (-not (Test-Path $raceDir)) {
        # Try alternate names
        $alt = switch ($pcRace) {
            "byzantine" { "byzantine" }
            default { $pcRace }
        }
        $raceDir = Join-Path $ExternalDump $alt
    }
    if (-not (Test-Path $raceDir)) { Write-Host "  WARN: Parent civ folder not found: $pcRace" -ForegroundColor Red; continue }

    $xmlFiles = Get-ChildItem $raceDir -Recurse -Filter "*.xml" -File
    foreach ($xf in $xmlFiles) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($xf.Name)
        $relPath = $xf.FullName.Substring($ExternalDump.Length + 1).Replace('\', '/')
        $parentCivIndex[$baseName.ToLower()] = @{
            race = $pcRace
            path = $relPath
        }
    }
}
Write-Host "  Parent civ index: $($parentCivIndex.Count) entities across $($parentCivRaces.Count) civs" -ForegroundColor Green

# Also index core entities for reference
$coreDir = Join-Path $ExternalDump "core"
$coreIndex = @{}
if (Test-Path $coreDir) {
    foreach ($xf in (Get-ChildItem $coreDir -Recurse -Filter "*.xml" -File)) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($xf.Name)
        $coreIndex[$baseName.ToLower()] = $true
    }
}
Write-Host "  Core index: $($coreIndex.Count) entities" -ForegroundColor Green

# =====================================================================
# Phase 2: Extract per-variant deltas
# =====================================================================
Write-Host "`n--- Phase 2: Extracting Variant Deltas ---" -ForegroundColor Yellow

$allVariantSummaries = @()
$totalEntities = 0
$totalOverrides = 0
$totalUnique = 0

foreach ($haRace in $haToParent.Keys) {
    $parentCiv = $haToParent[$haRace]
    $haDir = Join-Path $ExternalDump $haRace

    if (-not (Test-Path $haDir)) { Write-Host "  SKIP: $haRace not found" -ForegroundColor Yellow; continue }

    $xmlFiles = Get-ChildItem $haDir -Recurse -Filter "*.xml" -File
    Write-Host "  $haRace ($($xmlFiles.Count) entities, parent: $parentCiv)" -ForegroundColor White

    $entities = @()
    $variantUnique = 0
    $coreParented = 0
    $civParented = 0
    $noParent = 0
    $raceOverrides = 0

    foreach ($xf in $xmlFiles) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($xf.Name)
        $relPath = $xf.FullName.Substring((Join-Path $ExternalDump $haRace).Length + 1).Replace('\', '/')
        $xml = Get-Content $xf.FullName -Raw

        # Extract parent_pbg
        $parentPbg = ""
        if ($xml -match 'name="parent_pbg"\s+value="([^"]*)"') {
            $parentPbg = $Matches[1]
        }

        # Extract pbgid
        $pbgid = 0
        if ($xml -match 'name="pbgid"\s+value="(\d+)"') {
            $pbgid = [int]$Matches[1]
        }

        # Count override fields
        $overrideCount = ([regex]::Matches($xml, 'overrideParent="True"')).Count
        $raceOverrides += $overrideCount

        # Classify parent type
        $parentType = "none"
        $parentRace = ""
        $parentEntity = ""
        if ($parentPbg -match 'races\\core\\') {
            $parentType = "core"
            $coreParented++
            if ($parentPbg -match 'races\\core\\[^\\]+\\(.+)$') { $parentEntity = $Matches[1] }
        } elseif ($parentPbg.Length -gt 0) {
            $parentType = "civ"
            $civParented++
            if ($parentPbg -match 'races\\([^\\]+)\\') { $parentRace = $Matches[1] }
            if ($parentPbg -match 'races\\[^\\]+\\[^\\]+\\(.+)$') { $parentEntity = $Matches[1] }
        } else {
            $noParent++
        }

        # Determine category from path
        $category = "other"
        if ($relPath -match '^units/') { $category = "unit" }
        elseif ($relPath -match '^buildings/') { $category = "building" }
        elseif ($relPath -match '^weapons/') { $category = "weapon" }
        elseif ($relPath -match '^codex_dummy/') { $category = "codex_dummy" }

        # Derive name stem by stripping HA variant suffix
        # e.g., unit_archer_2_fre_ha_01 -> unit_archer_2_fre (direct parent-civ match)
        # e.g., unit_abbey_king_2_lan -> unit_abbey_king_2 (needs + _eng suffix)
        $isUnique = $false
        $stemDirect = $baseName -replace '_ha_\d+$', '' -replace '_ha_[a-z]+$', ''
        # For lancaster/mac/gol/sen/tug, strip their specific suffixes  
        $stemBase = $stemDirect -replace '_lan$', '' -replace '_mac$', '' -replace '_gol$', '' -replace '_sen$', '' -replace '_tug$', ''

        $parentSuffixes = switch ($parentCiv) {
            "french"    { @("_fre") }
            "abbasid"   { @("_abb") }
            "chinese"   { @("_chi") }
            "hre"       { @("_hre") }
            "japanese"  { @("_jpn") }
            "mongol"    { @("_mon") }
            "sultanate" { @("_sul") }
            "english"   { @("_eng") }
            "byzantine" { @("_byz") }
            default     { @() }
        }

        $hasParentCounterpart = $false
        # 1. Direct match: stemDirect already has civ suffix (most HA entities)
        if ($parentCivIndex.ContainsKey($stemDirect.ToLower())) {
            $hasParentCounterpart = $true
        }
        # 2. Base stem + parent civ suffix (for lancaster/mac/gol/sen/tug naming)
        if (-not $hasParentCounterpart) {
            foreach ($suffix in $parentSuffixes) {
                if ($parentCivIndex.ContainsKey(($stemBase + $suffix).ToLower())) {
                    $hasParentCounterpart = $true
                    break
                }
            }
        }
        # 3. Check core entity index
        if (-not $hasParentCounterpart) {
            if ($coreIndex.ContainsKey($stemDirect.ToLower()) -or $coreIndex.ContainsKey($stemBase.ToLower())) {
                $hasParentCounterpart = $true
            }
        }

        if (-not $hasParentCounterpart -and $category -ne "codex_dummy") {
            $isUnique = $true
            $variantUnique++
        }

        $entities += [PSCustomObject]@{
            entity        = $baseName
            path          = $relPath
            category      = $category
            pbgid         = $pbgid
            parentType    = $parentType
            parentPbg     = $parentPbg
            parentRace    = $parentRace
            parentEntity  = $parentEntity
            overrideCount = $overrideCount
            isUnique      = $isUnique
        }
    }

    $totalEntities += $xmlFiles.Count
    $totalOverrides += $raceOverrides
    $totalUnique += $variantUnique

    # Build per-variant output
    $variantOutput = [PSCustomObject]@{
        _meta = [PSCustomObject]@{
            generated     = $timestamp
            variant       = $haRace
            parentCiv     = $parentCiv
            totalEntities = $xmlFiles.Count
            coreParented  = $coreParented
            civParented   = $civParented
            noParent      = $noParent
            totalOverrides = $raceOverrides
            uniqueEntities = $variantUnique
        }
        entities = $entities | Sort-Object { $_.category }, { $_.entity }
    }

    $variantFilePath = Join-Path $haOutputRoot "$haRace-deltas.json"
    $variantOutput | ConvertTo-Json -Depth 10 | Set-Content -Path $variantFilePath -Encoding UTF8

    Write-Host "    core=$coreParented civ=$civParented none=$noParent unique=$variantUnique overrides=$raceOverrides" -ForegroundColor Gray

    $allVariantSummaries += [PSCustomObject]@{
        variant        = $haRace
        parentCiv      = $parentCiv
        totalEntities  = $xmlFiles.Count
        coreParented   = $coreParented
        civParented    = $civParented
        noParent       = $noParent
        totalOverrides = $raceOverrides
        uniqueEntities = $variantUnique
        units          = ($entities | Where-Object { $_.category -eq "unit" }).Count
        buildings      = ($entities | Where-Object { $_.category -eq "building" }).Count
        weapons        = ($entities | Where-Object { $_.category -eq "weapon" }).Count
    }
}

# =====================================================================
# Phase 3: Unified summary
# =====================================================================
Write-Host "`n--- Phase 3: Unified Summary ---" -ForegroundColor Yellow

$unifiedOutput = [PSCustomObject]@{
    _meta = [PSCustomObject]@{
        generated       = $timestamp
        description     = "HA variant delta summary. Per-variant detail in data/aoe4/data/ha-variants/{variant}-deltas.json"
        totalVariants   = $allVariantSummaries.Count
        totalEntities   = $totalEntities
        totalOverrides  = $totalOverrides
        totalUnique     = $totalUnique
    }
    variants = $allVariantSummaries
}

$unifiedPath = Join-Path $canonRoot "ha-variant-deltas.json"
$unifiedOutput | ConvertTo-Json -Depth 10 | Set-Content -Path $unifiedPath -Encoding UTF8
Write-Host "  Saved: canonical/ha-variant-deltas.json" -ForegroundColor Green
Write-Host "  Saved: $($allVariantSummaries.Count) per-variant delta files in ha-variants/" -ForegroundColor Green

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " HA DELTA EXTRACTION COMPLETE" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Total variants: $($allVariantSummaries.Count)" -ForegroundColor White
Write-Host "  Total entities: $totalEntities" -ForegroundColor White
Write-Host "  Total overrides: $totalOverrides" -ForegroundColor White
Write-Host "  Variant-unique: $totalUnique" -ForegroundColor White
