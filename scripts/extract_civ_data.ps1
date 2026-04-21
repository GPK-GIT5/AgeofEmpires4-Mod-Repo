<#
.SYNOPSIS
    Extracts derived civ data from AoE4 JSON files: health-by-age, DPS, normalized tech costs,
    weapon modifiers, production chains, DLC completeness, and blueprint suffix catalog.
.DESCRIPTION
    Stage 2a of the Civ Data Extraction Plan.
    Reads from data/aoe4/data/ (units, buildings, technologies, civilizations).
    Produces JSON files in data/aoe4/data/derived/.
.PARAMETER WorkspaceRoot
    Root of the AoE4 workspace. Defaults to the known workspace path.
.PARAMETER Stages
    Comma-separated list of stages to run. Default: all.
    Valid: health,dps,techcosts,modifiers,production,dlc,suffixes
.EXAMPLE
    .\extract_civ_data.ps1
    .\extract_civ_data.ps1 -Stages "health,dps"
#>

param(
    [string]$WorkspaceRoot = "C:\Users\Jordan\Documents\AoE4-Workspace",
    [string]$Stages = "health,dps,techcosts,modifiers,production,dlc,suffixes"
)

$dataRoot   = "$WorkspaceRoot\data\aoe4\data"
$outDir     = "$dataRoot\derived"
$stageList  = $Stages -split ','

if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

Write-Host "[extract_civ_data] Output: $outDir"
Write-Host "[extract_civ_data] Stages: $($stageList -join ', ')"
Write-Host ""

# ─── Load unified data ───────────────────────────────────────────────────────

function Load-UnifiedJson {
    param([string]$SubDir)
    $path = "$dataRoot\$SubDir\all-unified.json"
    if (-not (Test-Path $path)) {
        $path = "$dataRoot\$SubDir\all.json"
    }
    if (Test-Path $path) {
        $raw = Get-Content $path -Raw -Encoding utf8
        return ($raw | ConvertFrom-Json)
    }
    Write-Host "  [WARN] No unified JSON found in $SubDir" -ForegroundColor Yellow
    return $null
}

$unitsData = $null
$buildingsData = $null
$techsData = $null
$civsIndex = $null

function Ensure-Units {
    if ($null -eq $script:unitsData) {
        Write-Host "  Loading units..."
        $script:unitsData = Load-UnifiedJson "units"
    }
    return $script:unitsData
}
function Ensure-Buildings {
    if ($null -eq $script:buildingsData) {
        Write-Host "  Loading buildings..."
        $script:buildingsData = Load-UnifiedJson "buildings"
    }
    return $script:buildingsData
}
function Ensure-Techs {
    if ($null -eq $script:techsData) {
        Write-Host "  Loading technologies..."
        $script:techsData = Load-UnifiedJson "technologies"
    }
    return $script:techsData
}
function Ensure-CivsIndex {
    if ($null -eq $script:civsIndex) {
        $path = "$dataRoot\civilizations\civs-index.json"
        if (Test-Path $path) {
            $script:civsIndex = (Get-Content $path -Raw -Encoding utf8 | ConvertFrom-Json)
        }
    }
    return $script:civsIndex
}

# Helper: get all variations from a unified JSON data object
function Get-AllVariations {
    param($JsonData)
    $results = @()
    if ($null -eq $JsonData) { return $results }
    $items = if ($JsonData.data) { $JsonData.data } else { $JsonData }
    foreach ($item in $items) {
        if ($item.variations) {
            foreach ($v in $item.variations) {
                $results += $v
            }
        } else {
            $results += $item
        }
    }
    return $results
}

# ─── Stage: Health by Age ─────────────────────────────────────────────────────

function Extract-HealthByAge {
    Write-Host "[STAGE] Health by Age"
    $data = Ensure-Units
    if ($null -eq $data) { return }
    $variations = Get-AllVariations $data
    Write-Host "  Variations: $($variations.Count)"

    $healthMap = @{}
    foreach ($v in $variations) {
        $baseId = $v.baseId
        if (-not $baseId) { $baseId = $v.id }
        $age = $v.age
        $hp = $v.hitpoints
        if (-not $baseId -or -not $age) { continue }
        $civsList = if ($v.civs) { ($v.civs -join ",") } else { "all" }
        $key = "$baseId|$civsList"

        if (-not $healthMap.ContainsKey($key)) {
            $healthMap[$key] = @{
                baseId = $baseId
                civs = $civsList
                name = $v.name
                hpByAge = @{}
            }
        }
        $healthMap[$key].hpByAge["$age"] = $hp
    }

    $output = $healthMap.Values | Sort-Object { $_.baseId } | ForEach-Object {
        [PSCustomObject]@{
            baseId  = $_.baseId
            name    = $_.name
            civs    = $_.civs
            hpByAge = $_.hpByAge
        }
    }

    $outPath = "$outDir\health-by-age.json"
    $output | ConvertTo-Json -Depth 5 | Set-Content $outPath -Encoding utf8
    Write-Host "  -> $outPath ($($output.Count) entries)"
}

# ─── Stage: DPS Computation ───────────────────────────────────────────────────

function Extract-DPS {
    Write-Host "[STAGE] DPS Computation"
    $data = Ensure-Units
    if ($null -eq $data) { return }
    $variations = Get-AllVariations $data
    Write-Host "  Variations: $($variations.Count)"

    $dpsEntries = @()
    foreach ($v in $variations) {
        $baseId = $v.baseId
        if (-not $baseId) { $baseId = $v.id }
        $age = $v.age
        $civsList = if ($v.civs) { ($v.civs -join ",") } else { "all" }

        $weapons = @()
        $totalDps = 0.0
        if ($v.weapons) {
            foreach ($w in $v.weapons) {
                $damage = [double]($w.damage)
                $dur = $w.durations
                $cycletime = 0.0
                if ($dur) {
                    $cycletime = [double]($dur.aim) + [double]($dur.windup) + [double]($dur.attack) +
                                 [double]($dur.winddown) + [double]($dur.reload)
                }
                $dps = if ($cycletime -gt 0) { [math]::Round($damage / $cycletime, 2) } else { 0.0 }
                $totalDps += $dps
                $weapons += [PSCustomObject]@{
                    name      = $w.name
                    type      = $w.type
                    damage    = $damage
                    cycleTime = [math]::Round($cycletime, 3)
                    dps       = $dps
                    rangeMax  = if ($w.range) { $w.range.max } else { 0 }
                }
            }
        }

        $dpsEntries += [PSCustomObject]@{
            baseId   = $baseId
            name     = $v.name
            civs     = $civsList
            age      = $age
            attribName = $v.attribName
            hitpoints  = $v.hitpoints
            totalDps   = [math]::Round($totalDps, 2)
            weapons    = $weapons
        }
    }

    $outPath = "$outDir\dps-by-unit.json"
    $dpsEntries | Sort-Object baseId, age | ConvertTo-Json -Depth 5 | Set-Content $outPath -Encoding utf8
    Write-Host "  -> $outPath ($($dpsEntries.Count) entries)"
}

# ─── Stage: Normalized Tech Costs ─────────────────────────────────────────────

function Extract-TechCosts {
    Write-Host "[STAGE] Normalized Tech Costs"
    $data = Ensure-Techs
    if ($null -eq $data) { return }
    $variations = Get-AllVariations $data
    Write-Host "  Variations: $($variations.Count)"

    $entries = @()
    foreach ($v in $variations) {
        $normalized = @{ food = 0; wood = 0; gold = 0; stone = 0; time = 0 }
        $costs = $v.costs
        if ($costs -and $costs -is [array]) {
            foreach ($c in $costs) {
                $res = $c.resource
                $amt = [double]($c.amount)
                if ($res -and $normalized.ContainsKey($res.ToLower())) {
                    $normalized[$res.ToLower()] = $amt
                }
            }
        } elseif ($costs) {
            # Already object form
            foreach ($prop in @("food","wood","gold","stone","time")) {
                if ($costs.PSObject.Properties[$prop]) {
                    $normalized[$prop] = [double]($costs.$prop)
                }
            }
        }
        $normalized["total"] = $normalized.food + $normalized.wood + $normalized.gold + $normalized.stone

        $entries += [PSCustomObject]@{
            id         = $v.id
            baseId     = $v.baseId
            name       = $v.name
            attribName = $v.attribName
            age        = $v.age
            civs       = if ($v.civs) { ($v.civs -join ",") } else { "all" }
            costs      = $normalized
            appliesTo  = $v.appliesTo
            effects    = $v.effects
            unique     = $v.unique
        }
    }

    $outPath = "$outDir\tech-costs-normalized.json"
    $entries | Sort-Object id | ConvertTo-Json -Depth 8 | Set-Content $outPath -Encoding utf8
    Write-Host "  -> $outPath ($($entries.Count) entries)"
}

# ─── Stage: Weapon Modifiers ──────────────────────────────────────────────────

function Extract-WeaponModifiers {
    Write-Host "[STAGE] Weapon Modifiers"
    $data = Ensure-Units
    if ($null -eq $data) { return }
    $variations = Get-AllVariations $data

    $entries = @()
    foreach ($v in $variations) {
        if (-not $v.weapons) { continue }
        foreach ($w in $v.weapons) {
            if (-not $w.modifiers -or $w.modifiers.Count -eq 0) { continue }
            $entries += [PSCustomObject]@{
                unitBaseId = if ($v.baseId) { $v.baseId } else { $v.id }
                unitName   = $v.name
                attribName = $v.attribName
                age        = $v.age
                civs       = if ($v.civs) { ($v.civs -join ",") } else { "all" }
                weaponName = $w.name
                weaponType = $w.type
                modifiers  = $w.modifiers
            }
        }
    }

    $outPath = "$outDir\weapon-modifiers.json"
    $entries | Sort-Object unitBaseId, age | ConvertTo-Json -Depth 6 | Set-Content $outPath -Encoding utf8
    Write-Host "  -> $outPath ($($entries.Count) entries)"
}

# ─── Stage: Production Chains ─────────────────────────────────────────────────

function Extract-ProductionChains {
    Write-Host "[STAGE] Production Chains"
    $unitData = Ensure-Units
    $bldgData = Ensure-Buildings
    $techData = Ensure-Techs

    $chains = @{}  # producer -> products[]

    foreach ($src in @(
        @{ Data = $unitData; Type = "unit" },
        @{ Data = $bldgData; Type = "building" },
        @{ Data = $techData; Type = "technology" }
    )) {
        if ($null -eq $src.Data) { continue }
        $variations = Get-AllVariations $src.Data
        foreach ($v in $variations) {
            if (-not $v.producedBy) { continue }
            $productId = if ($v.baseId) { $v.baseId } else { $v.id }
            $civsList = if ($v.civs) { ($v.civs -join ",") } else { "all" }
            foreach ($producer in $v.producedBy) {
                $pKey = $producer.ToLower()
                if (-not $chains.ContainsKey($pKey)) {
                    $chains[$pKey] = @()
                }
                $chains[$pKey] += [PSCustomObject]@{
                    id   = $productId
                    name = $v.name
                    type = $src.Type
                    age  = $v.age
                    civs = $civsList
                }
            }
        }
    }

    $output = $chains.GetEnumerator() | Sort-Object Name | ForEach-Object {
        [PSCustomObject]@{
            producer = $_.Name
            products = ($_.Value | Sort-Object type, id, age)
        }
    }

    $outPath = "$outDir\production-chains.json"
    $output | ConvertTo-Json -Depth 5 | Set-Content $outPath -Encoding utf8
    Write-Host "  -> $outPath ($($output.Count) producers)"
}

# ─── Stage: DLC Completeness ─────────────────────────────────────────────────

function Extract-DLCCompleteness {
    Write-Host "[STAGE] DLC Completeness"
    $civsIdx = Ensure-CivsIndex

    # Known parent map (matches AGS_CIV_PARENT_MAP)
    $parentMap = @{
        "mongol_ha_gol"    = "mongol"
        "lancaster"        = "english"
        "templar"          = "french"
        "byzantine_ha_mac" = "byzantine"
        "japanese_ha_sen"  = "japanese"
        "sultanate_ha_tug" = "sultanate"
    }

    $report = @()
    foreach ($variant in $parentMap.Keys | Sort-Object) {
        $parent = $parentMap[$variant]

        $delta = @{ variant = $variant; parent = $parent; units = @{}; buildings = @{}; technologies = @{} }
        foreach ($category in @("units", "buildings", "technologies")) {
            $variantDir = "$dataRoot\$category\$variant"
            $parentDir  = "$dataRoot\$category\$parent"

            $variantFiles = @()
            $parentFiles  = @()
            if (Test-Path $variantDir) {
                $variantFiles = Get-ChildItem $variantDir -Filter "*.json" | ForEach-Object { $_.BaseName }
            }
            if (Test-Path $parentDir) {
                $parentFiles = Get-ChildItem $parentDir -Filter "*.json" | ForEach-Object { $_.BaseName }
            }

            $onlyVariant = $variantFiles | Where-Object { $_ -notin $parentFiles }
            $onlyParent  = $parentFiles  | Where-Object { $_ -notin $variantFiles }
            $shared      = $variantFiles | Where-Object { $_ -in $parentFiles }

            $delta.$category = [PSCustomObject]@{
                variantCount   = $variantFiles.Count
                parentCount    = $parentFiles.Count
                sharedCount    = $shared.Count
                onlyInVariant  = @($onlyVariant | Sort-Object)
                onlyInParent   = @($onlyParent  | Sort-Object)
            }
        }
        $report += [PSCustomObject]$delta
    }

    $outPath = "$outDir\dlc-completeness.json"
    $report | ConvertTo-Json -Depth 5 | Set-Content $outPath -Encoding utf8
    Write-Host "  -> $outPath ($($report.Count) variants)"
}

# ─── Stage: BP Suffix Catalog ─────────────────────────────────────────────────

function Extract-BPSuffixCatalog {
    Write-Host "[STAGE] BP Suffix Catalog"
    $civsIdx = Ensure-CivsIndex
    $unitData = Ensure-Units
    $bldgData = Ensure-Buildings

    $suffixMap = @{}
    foreach ($src in @($unitData, $bldgData)) {
        if ($null -eq $src) { continue }
        $variations = Get-AllVariations $src
        foreach ($v in $variations) {
            $attr = $v.attribName
            if (-not $attr) { continue }
            $civs = $v.civs
            if (-not $civs) { continue }
            foreach ($civ in $civs) {
                if (-not $suffixMap.ContainsKey($civ)) {
                    $suffixMap[$civ] = [System.Collections.Generic.HashSet[string]]::new()
                }
                [void]$suffixMap[$civ].Add($attr)
            }
        }
    }

    $output = $suffixMap.GetEnumerator() | Sort-Object Name | ForEach-Object {
        [PSCustomObject]@{
            civ         = $_.Name
            bpCount     = $_.Value.Count
            attribNames = @($_.Value | Sort-Object)
        }
    }

    $outPath = "$outDir\bp-suffix-catalog.json"
    $output | ConvertTo-Json -Depth 4 | Set-Content $outPath -Encoding utf8
    Write-Host "  -> $outPath ($($output.Count) civs)"
}

# ─── Dispatch ─────────────────────────────────────────────────────────────────

$stageMap = @{
    "health"    = { Extract-HealthByAge }
    "dps"       = { Extract-DPS }
    "techcosts" = { Extract-TechCosts }
    "modifiers" = { Extract-WeaponModifiers }
    "production"= { Extract-ProductionChains }
    "dlc"       = { Extract-DLCCompleteness }
    "suffixes"  = { Extract-BPSuffixCatalog }
}

$ran = 0
foreach ($stage in $stageList) {
    $s = $stage.Trim().ToLower()
    if ($stageMap.ContainsKey($s)) {
        & $stageMap[$s]
        $ran++
        Write-Host ""
    } else {
        Write-Host "[WARN] Unknown stage: $s" -ForegroundColor Yellow
    }
}

Write-Host "[extract_civ_data] Done. Ran $ran stages."
