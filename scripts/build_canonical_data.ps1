<#
.SYNOPSIS
    Builds canonical unit data with baseId as the identity key.
    Maps all attribName variants and aliases back to base concepts (e.g. "archer").
.DESCRIPTION
    Reads from data/aoe4/data/ (units, buildings, technologies, civilizations).
    Produces JSON files in data/aoe4/data/canonical/:
      - alias-map.json           7-index lookup (baseId, attribName, slug, displayName, pbgid, class, producedBy)
      - canonical-units.json     One entry per baseId with merged stats, civs, age spread
      - upgrade-chains.json      Age-tier progression per baseId (hp/damage/armor deltas)
      - weapon-profiles.json     Weapon archetypes per baseId (type, damage, range, speed, modifiers)
      - production-graph.json    Producer -> product relationships with ages and civs
      - static-truth.json        Behavioral classification derived from static weapon/class data (not live runtime)
.PARAMETER WorkspaceRoot
    Root of the AoE4 workspace.
.PARAMETER Stages
    Comma-separated list of stages to run. Default: all.
    Valid: alias,canonical,upgrades,weapons,production,truth
.EXAMPLE
    .\build_canonical_data.ps1
    .\build_canonical_data.ps1 -Stages "alias,canonical"
#>

param(
    [string]$WorkspaceRoot = "C:\Users\Jordan\Documents\AoE4-Workspace",
    [string]$Stages = "alias,canonical,upgrades,weapons,production,truth"
)

$dataRoot   = "$WorkspaceRoot\data\aoe4\data"
$outDir     = "$dataRoot\canonical"
$stageList  = $Stages -split ','

if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

Write-Host "[build_canonical_data] Output: $outDir"
Write-Host "[build_canonical_data] Stages: $($stageList -join ', ')"
Write-Host ""

# ─── Shared Loaders ──────────────────────────────────────────────────────────

$script:unitsData    = $null
$script:buildingsData = $null
$script:techsData    = $null
$script:civsIndex    = $null

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

function Get-AllVariations {
    param($JsonData)
    $results = [System.Collections.Generic.List[object]]::new()
    if ($null -eq $JsonData) { return $results }
    $items = if ($JsonData.data) { $JsonData.data } else { $JsonData }
    foreach ($item in $items) {
        if ($item.variations) {
            foreach ($v in $item.variations) {
                $results.Add($v)
            }
        } else {
            $results.Add($item)
        }
    }
    return $results
}

function Write-JsonOutput {
    param([string]$FileName, $Data)
    $path = "$outDir\$FileName"
    $Data | ConvertTo-Json -Depth 20 -Compress:$false | Set-Content $path -Encoding utf8
    $size = (Get-Item $path).Length
    Write-Host "  -> $FileName ($([math]::Round($size/1024,1)) KB)"
}

# ─── Stage: Alias Map ────────────────────────────────────────────────────────
# Produces 7 lookup indexes, all pointing back to canonical baseId.

function Build-AliasMap {
    Write-Host "[STAGE] Alias Map"
    $data = Ensure-Units
    if ($null -eq $data) { return }

    # Index containers
    $byBaseId      = @{}  # baseId -> canonical entry
    $byAttribName  = @{}  # attribName -> baseId
    $bySlug        = @{}  # variation slug (id) -> baseId
    $byDisplayName = @{}  # display name -> baseId[]  (can be many-to-one)
    $byPbgId       = @{}  # pbgid -> baseId
    $byClass       = @{}  # class tag -> baseId[]
    $byProducedBy  = @{}  # producer slug -> baseId[]

    $items = if ($data.data) { $data.data } else { $data }
    $totalVariations = 0

    foreach ($item in $items) {
        $baseId = $item.id
        if (-not $baseId) { continue }

        # Canonical entry
        $entry = @{
            baseId       = $baseId
            name         = $item.name
            type         = $item.type
            civs         = @($item.civs | Sort-Object)
            unique       = [bool]$item.unique
            minAge       = $item.minAge
            classes      = @($item.classes)
            displayClasses = @($item.displayClasses)
            variationCount = 0
            attribNames  = @()
            slugs        = @()
        }

        $attribs = [System.Collections.Generic.List[string]]::new()
        $slugs   = [System.Collections.Generic.List[string]]::new()

        if ($item.variations) {
            foreach ($v in $item.variations) {
                $totalVariations++
                $entry.variationCount++

                # attribName index
                if ($v.attribName) {
                    $byAttribName[$v.attribName] = $baseId
                    $attribs.Add($v.attribName)
                }

                # slug index (variation id like "archer-2")
                if ($v.id) {
                    $bySlug[$v.id] = $baseId
                    $slugs.Add($v.id)
                }

                # pbgid index
                if ($v.pbgid) {
                    $byPbgId["$($v.pbgid)"] = $baseId
                }

                # producedBy index
                if ($v.producedBy) {
                    foreach ($prod in $v.producedBy) {
                        if (-not $byProducedBy.ContainsKey($prod)) {
                            $byProducedBy[$prod] = [System.Collections.Generic.HashSet[string]]::new()
                        }
                        [void]$byProducedBy[$prod].Add($baseId)
                    }
                }
            }
        }

        $entry.attribNames = @($attribs | Sort-Object -Unique)
        $entry.slugs       = @($slugs | Sort-Object -Unique)

        $byBaseId[$baseId] = $entry

        # displayName index (use item-level name; collisions are expected)
        $dn = $item.name
        if ($dn) {
            if (-not $byDisplayName.ContainsKey($dn)) {
                $byDisplayName[$dn] = [System.Collections.Generic.HashSet[string]]::new()
            }
            [void]$byDisplayName[$dn].Add($baseId)
        }

        # class index
        if ($item.classes) {
            foreach ($cls in $item.classes) {
                if (-not $byClass.ContainsKey($cls)) {
                    $byClass[$cls] = [System.Collections.Generic.HashSet[string]]::new()
                }
                [void]$byClass[$cls].Add($baseId)
            }
        }
    }

    # Convert HashSets to sorted arrays for JSON
    $byDisplayNameOut = @{}
    foreach ($kv in $byDisplayName.GetEnumerator()) {
        $byDisplayNameOut[$kv.Key] = @($kv.Value | Sort-Object)
    }
    $byClassOut = @{}
    foreach ($kv in $byClass.GetEnumerator()) {
        $byClassOut[$kv.Key] = @($kv.Value | Sort-Object)
    }
    $byProducedByOut = @{}
    foreach ($kv in $byProducedBy.GetEnumerator()) {
        $byProducedByOut[$kv.Key] = @($kv.Value | Sort-Object)
    }

    $aliasMap = [ordered]@{
        _meta = @{
            generated   = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            description = "7-index alias map. All keys resolve to canonical baseId."
            baseIdCount = $byBaseId.Count
            variationCount = $totalVariations
        }
        byBaseId      = $byBaseId
        byAttribName  = $byAttribName
        bySlug        = $bySlug
        byDisplayName = $byDisplayNameOut
        byPbgId       = $byPbgId
        byClass       = $byClassOut
        byProducedBy  = $byProducedByOut
    }

    Write-Host "  Base IDs: $($byBaseId.Count) | Variations: $totalVariations"
    Write-Host "  AttribNames: $($byAttribName.Count) | Slugs: $($bySlug.Count) | PbgIds: $($byPbgId.Count)"
    Write-Host "  DisplayNames: $($byDisplayNameOut.Count) | Classes: $($byClassOut.Count) | Producers: $($byProducedByOut.Count)"
    Write-JsonOutput "alias-map.json" $aliasMap
}

# ─── Stage: Canonical Units ──────────────────────────────────────────────────
# One entry per baseId with merged cross-civ stats.

function Build-CanonicalUnits {
    Write-Host "[STAGE] Canonical Units"
    $data = Ensure-Units
    if ($null -eq $data) { return }
    $civsIdx = Ensure-CivsIndex

    $items = if ($data.data) { $data.data } else { $data }
    $canonicalList = [System.Collections.Generic.List[object]]::new()

    foreach ($item in $items) {
        $baseId = $item.id
        if (-not $baseId) { continue }

        # Group variations by civ
        $civVariations = @{}
        $ageSpread = @{}
        $allProducers = [System.Collections.Generic.HashSet[string]]::new()

        if ($item.variations) {
            foreach ($v in $item.variations) {
                $age = $v.age
                $ageKey = "age_$age"
                if ($age -and -not $ageSpread.ContainsKey($ageKey)) {
                    $ageSpread[$ageKey] = @{
                        age    = [int]$age
                        hp     = $v.hitpoints
                        name   = $v.name
                        costs  = $v.costs
                    }
                }
                if ($v.producedBy) {
                    foreach ($p in $v.producedBy) { [void]$allProducers.Add($p) }
                }
                if ($v.civs) {
                    foreach ($c in $v.civs) {
                        if (-not $civVariations.ContainsKey($c)) {
                            $civVariations[$c] = [System.Collections.Generic.List[object]]::new()
                        }
                        $civVariations[$c].Add($v)
                    }
                }
            }
        }

        # Determine civ availability with expansion info
        $civDetail = @{}
        foreach ($c in @($item.civs | Sort-Object)) {
            $expansion = "unknown"
            if ($civsIdx -and $civsIdx.$c) {
                $expansion = ($civsIdx.$c.expansion -join ",")
            }
            $varCount = if ($civVariations.ContainsKey($c)) { $civVariations[$c].Count } else { 0 }
            $civDetail[$c] = @{
                expansion = $expansion
                variations = $varCount
            }
        }

        $canonical = [ordered]@{
            baseId         = $baseId
            name           = $item.name
            type           = $item.type
            unique         = [bool]$item.unique
            minAge         = $item.minAge
            civs           = @($item.civs | Sort-Object)
            civCount       = @($item.civs).Count
            civDetail      = $civDetail
            displayClasses = @($item.displayClasses)
            classes        = @($item.classes)
            ageSpread      = $ageSpread
            producedBy     = @($allProducers | Sort-Object)
        }

        $canonicalList.Add($canonical)
    }

    $output = [ordered]@{
        _meta = @{
            generated   = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            description = "Canonical units indexed by baseId. One entry per base concept."
            count       = $canonicalList.Count
        }
        data = @($canonicalList)
    }

    Write-Host "  Canonical units: $($canonicalList.Count)"
    Write-JsonOutput "canonical-units.json" $output
}

# ─── Stage: Upgrade Chains ───────────────────────────────────────────────────
# Per-baseId age-tier progression showing stat deltas.

function Build-UpgradeChains {
    Write-Host "[STAGE] Upgrade Chains"
    $data = Ensure-Units
    if ($null -eq $data) { return }

    $items = if ($data.data) { $data.data } else { $data }
    $chains = [System.Collections.Generic.List[object]]::new()

    foreach ($item in $items) {
        $baseId = $item.id
        if (-not $baseId) { continue }
        if (-not $item.variations -or $item.variations.Count -eq 0) { continue }

        # Group by age, take first variation per age as representative
        $byAge = @{}
        foreach ($v in $item.variations) {
            $age = $v.age
            if ($age -and -not $byAge.ContainsKey($age)) {
                $byAge[$age] = $v
            }
        }

        $ages = @($byAge.Keys | Sort-Object)
        if ($ages.Count -lt 1) { continue }

        $tiers = [System.Collections.Generic.List[object]]::new()
        $prevHp = 0
        $prevDmg = 0

        foreach ($age in $ages) {
            $v = $byAge[$age]
            $hp = if ($v.hitpoints) { $v.hitpoints } else { 0 }

            # Primary weapon damage
            $dmg = 0
            if ($v.weapons -and $v.weapons.Count -gt 0) {
                $dmg = $v.weapons[0].damage
                if (-not $dmg) { $dmg = 0 }
            }

            # Armor totals
            $meleeArmor = 0
            $rangedArmor = 0
            if ($v.armor) {
                foreach ($a in $v.armor) {
                    if ($a.type -eq "melee") { $meleeArmor += $a.value }
                    if ($a.type -eq "ranged") { $rangedArmor += $a.value }
                }
            }

            $tier = [ordered]@{
                age         = [int]$age
                name        = $v.name
                attribName  = $v.attribName
                hp          = $hp
                hpDelta     = $hp - $prevHp
                damage      = $dmg
                damageDelta = $dmg - $prevDmg
                meleeArmor  = $meleeArmor
                rangedArmor = $rangedArmor
                costs       = $v.costs
            }

            $tiers.Add($tier)
            $prevHp = $hp
            $prevDmg = $dmg
        }

        $chain = [ordered]@{
            baseId    = $baseId
            name      = $item.name
            unique    = [bool]$item.unique
            tierCount = $tiers.Count
            tiers     = @($tiers)
        }
        $chains.Add($chain)
    }

    $output = [ordered]@{
        _meta = @{
            generated   = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            description = "Age-tier upgrade chains per baseId. Shows HP/damage/armor deltas."
            count       = $chains.Count
        }
        data = @($chains)
    }

    Write-Host "  Upgrade chains: $($chains.Count)"
    Write-JsonOutput "upgrade-chains.json" $output
}

# ─── Stage: Weapon Profiles ──────────────────────────────────────────────────
# Weapon archetypes per baseId (type, damage range, speed, modifiers).

function Build-WeaponProfiles {
    Write-Host "[STAGE] Weapon Profiles"
    $data = Ensure-Units
    if ($null -eq $data) { return }

    $items = if ($data.data) { $data.data } else { $data }
    $profiles = [System.Collections.Generic.List[object]]::new()

    foreach ($item in $items) {
        $baseId = $item.id
        if (-not $baseId) { continue }
        if (-not $item.variations -or $item.variations.Count -eq 0) { continue }

        # Collect unique weapon names across all variations
        $weaponMap = @{}  # weaponName -> best variation weapon entry (highest age)
        foreach ($v in $item.variations) {
            if (-not $v.weapons) { continue }
            foreach ($w in $v.weapons) {
                $wName = $w.name
                if (-not $wName) { $wName = "unknown" }
                $existing = $weaponMap[$wName]
                if (-not $existing -or $v.age -gt $existing._age) {
                    $weaponMap[$wName] = @{
                        _age      = $v.age
                        name      = $wName
                        type      = $w.type
                        damage    = $w.damage
                        speed     = $w.speed
                        range     = $w.range
                        modifiers = $w.modifiers
                        durations = $w.durations
                        attribName = $w.attribName
                    }
                }
            }
        }

        if ($weaponMap.Count -eq 0) { continue }

        $weaponList = [System.Collections.Generic.List[object]]::new()
        foreach ($kv in ($weaponMap.GetEnumerator() | Sort-Object Key)) {
            $w = $kv.Value
            $modCount = if ($w.modifiers) { $w.modifiers.Count } else { 0 }
            $weaponEntry = [ordered]@{
                name       = $w.name
                type       = $w.type
                damage     = $w.damage
                speed      = $w.speed
                range      = $w.range
                modifierCount = $modCount
                modifiers  = $w.modifiers
                durations  = $w.durations
                attribName = $w.attribName
            }
            $weaponList.Add($weaponEntry)
        }

        $profile = [ordered]@{
            baseId      = $baseId
            name        = $item.name
            weaponCount = $weaponList.Count
            weapons     = @($weaponList)
        }
        $profiles.Add($profile)
    }

    $output = [ordered]@{
        _meta = @{
            generated   = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            description = "Weapon profiles per baseId. Shows highest-age variant of each weapon type."
            count       = $profiles.Count
        }
        data = @($profiles)
    }

    Write-Host "  Weapon profiles: $($profiles.Count)"
    Write-JsonOutput "weapon-profiles.json" $output
}

# ─── Stage: Production Graph ─────────────────────────────────────────────────
# Building -> unit/tech production relationships.

function Build-ProductionGraph {
    Write-Host "[STAGE] Production Graph"
    $units = Ensure-Units
    $buildings = Ensure-Buildings
    $techs = Ensure-Techs

    $graph = @{}  # producerSlug -> { units: [], techs: [], civs: {} }

    # Units
    if ($units) {
        $items = if ($units.data) { $units.data } else { $units }
        foreach ($item in $items) {
            if (-not $item.variations) { continue }
            foreach ($v in $item.variations) {
                if (-not $v.producedBy) { continue }
                foreach ($prod in $v.producedBy) {
                    if (-not $graph.ContainsKey($prod)) {
                        $graph[$prod] = @{
                            units = [System.Collections.Generic.HashSet[string]]::new()
                            techs = [System.Collections.Generic.HashSet[string]]::new()
                            civs  = [System.Collections.Generic.HashSet[string]]::new()
                        }
                    }
                    [void]$graph[$prod].units.Add($item.id)
                    if ($v.civs) {
                        foreach ($c in $v.civs) {
                            [void]$graph[$prod].civs.Add($c)
                        }
                    }
                }
            }
        }
    }

    # Technologies
    if ($techs) {
        $tItems = if ($techs.data) { $techs.data } else { $techs }
        foreach ($tItem in $tItems) {
            if (-not $tItem.variations) { continue }
            foreach ($tv in $tItem.variations) {
                if (-not $tv.producedBy) { continue }
                foreach ($prod in $tv.producedBy) {
                    if (-not $graph.ContainsKey($prod)) {
                        $graph[$prod] = @{
                            units = [System.Collections.Generic.HashSet[string]]::new()
                            techs = [System.Collections.Generic.HashSet[string]]::new()
                            civs  = [System.Collections.Generic.HashSet[string]]::new()
                        }
                    }
                    [void]$graph[$prod].techs.Add($tItem.id)
                    if ($tv.civs) {
                        foreach ($c in $tv.civs) {
                            [void]$graph[$prod].civs.Add($c)
                        }
                    }
                }
            }
        }
    }

    # Convert to output format
    $graphList = [System.Collections.Generic.List[object]]::new()
    foreach ($kv in ($graph.GetEnumerator() | Sort-Object Key)) {
        $entry = [ordered]@{
            producer  = $kv.Key
            units     = @($kv.Value.units | Sort-Object)
            unitCount = $kv.Value.units.Count
            techs     = @($kv.Value.techs | Sort-Object)
            techCount = $kv.Value.techs.Count
            civs      = @($kv.Value.civs | Sort-Object)
        }
        $graphList.Add($entry)
    }

    $output = [ordered]@{
        _meta = @{
            generated   = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            description = "Production graph. Each producer (building) lists its unit and tech products with civ coverage."
            producerCount = $graphList.Count
        }
        data = @($graphList)
    }

    Write-Host "  Producers: $($graphList.Count)"
    Write-JsonOutput "production-graph.json" $output
}

# ─── Stage: Static Truth ─────────────────────────────────────────────────────
# Derives behavioral role from static weapon/class data and compares against declared classes.
# NOTE: This is NOT validated from live in-game runtime. It cross-checks the aoe4world.com
# static data exports. Discrepancies may reflect data export limitations, not actual bugs.

function Build-RuntimeTruth {
    Write-Host "[STAGE] Static Truth (behavior-derived from static data, not live runtime)"
    $data = Ensure-Units
    if ($null -eq $data) { return }

    $items = if ($data.data) { $data.data } else { $data }
    $conflicts = [System.Collections.Generic.List[object]]::new()
    $totalChecked = 0

    foreach ($item in $items) {
        $baseId = $item.id
        if (-not $baseId) { continue }
        if (-not $item.variations -or $item.variations.Count -eq 0) { continue }

        $totalChecked++
        $declaredClasses = @($item.classes)
        $unitConflicts = [System.Collections.Generic.List[object]]::new()

        # Use representative variation (highest age)
        $rep = $item.variations | Sort-Object { $_.age } | Select-Object -Last 1

        # Derive behavioral tags from weapon data
        $derivedTags = [System.Collections.Generic.HashSet[string]]::new()
        $hasRangedWeapon = $false
        $hasMeleeWeapon = $false
        $hasSiegeWeapon = $false
        $primaryRange = 0

        if ($rep.weapons) {
            foreach ($w in $rep.weapons) {
                $wType = $w.type
                if ($wType -eq "ranged") {
                    $hasRangedWeapon = $true
                    if ($w.range -and $w.range.max) {
                        if ($w.range.max -gt $primaryRange) {
                            $primaryRange = $w.range.max
                        }
                    }
                }
                elseif ($wType -eq "melee") {
                    $hasMeleeWeapon = $true
                }
                elseif ($wType -eq "siege") {
                    $hasSiegeWeapon = $true
                }
            }
        }

        # Derive expected tags
        if ($hasRangedWeapon) { [void]$derivedTags.Add("ranged") }
        if ($hasMeleeWeapon) { [void]$derivedTags.Add("melee") }
        if ($hasSiegeWeapon) { [void]$derivedTags.Add("siege") }
        if ($hasRangedWeapon -and -not $hasMeleeWeapon) { [void]$derivedTags.Add("ranged_only") }
        if ($hasMeleeWeapon -and -not $hasRangedWeapon) { [void]$derivedTags.Add("melee_only") }
        if ($primaryRange -ge 8) { [void]$derivedTags.Add("long_range") }

        # Movement classification
        $speed = 0
        if ($rep.movement -and $rep.movement.speed) { $speed = $rep.movement.speed }
        if ($speed -ge 1.5) { [void]$derivedTags.Add("fast") }
        if ($speed -lt 1.0 -and $speed -gt 0) { [void]$derivedTags.Add("slow") }

        # Check: ranged tag present in declared classes?
        $declaredIsRanged = $declaredClasses -contains "ranged"
        $declaredIsMelee = $declaredClasses -contains "melee"
        $declaredIsInfantry = $declaredClasses -contains "infantry"
        $declaredIsCavalry = ($declaredClasses -contains "cavalry") -or ($declaredClasses -contains "horseman") -or ($declaredClasses -contains "knight")

        # TAG_MISSING: derived says ranged but classes don't include it
        if ($hasRangedWeapon -and -not $declaredIsRanged) {
            $unitConflicts.Add(@{
                type    = "TAG_MISSING"
                tag     = "ranged"
                detail  = "Has ranged weapon ($($rep.weapons[0].name)) but 'ranged' not in classes"
            })
        }

        # TAG_EXTRA: classes say ranged but no ranged weapon found
        if ($declaredIsRanged -and -not $hasRangedWeapon) {
            $unitConflicts.Add(@{
                type    = "TAG_EXTRA"
                tag     = "ranged"
                detail  = "Declared 'ranged' in classes but no ranged weapon found"
            })
        }

        # DPS_OUTLIER: check if damage is way above/below expected for age tier
        if ($rep.weapons -and $rep.weapons.Count -gt 0 -and $rep.hitpoints) {
            $dmg = $rep.weapons[0].damage
            $hp = $rep.hitpoints
            if ($dmg -and $hp) {
                $ratio = [math]::Round($dmg / $hp, 3)
                # Glass cannon detection (damage > 40% of own HP)
                if ($ratio -gt 0.4) {
                    $unitConflicts.Add(@{
                        type   = "DPS_OUTLIER"
                        tag    = "glass_cannon"
                        detail = "Damage/HP ratio $ratio (>0.4): $dmg dmg / $hp HP"
                    })
                }
            }
        }

        $entry = [ordered]@{
            baseId          = $baseId
            name            = $item.name
            derivedTags     = @($derivedTags | Sort-Object)
            declaredClasses = $declaredClasses
            primaryRange    = $primaryRange
            speed           = $speed
            conflictCount   = $unitConflicts.Count
            conflicts       = @($unitConflicts)
        }

        $conflicts.Add($entry)
    }

    $withConflicts = @($conflicts | Where-Object { $_.conflictCount -gt 0 })

    $output = [ordered]@{
        _meta = @{
            generated      = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            description    = "Static truth pass. Derives behavioral tags from weapon/class data exports (aoe4world.com). NOT validated from live in-game runtime. Conflicts may reflect data export limitations."
            totalChecked   = $totalChecked
            withConflicts  = $withConflicts.Count
            conflictRate   = if ($totalChecked -gt 0) { [math]::Round($withConflicts.Count / $totalChecked * 100, 1) } else { 0 }
        }
        data = @($conflicts)
    }

    Write-Host "  Checked: $totalChecked | Conflicts: $($withConflicts.Count) ($($output._meta.conflictRate)%)"
    Write-JsonOutput "static-truth.json" $output
}

# ─── Stage Dispatch ──────────────────────────────────────────────────────────

$stageMap = @{
    "alias"      = { Build-AliasMap }
    "canonical"  = { Build-CanonicalUnits }
    "upgrades"   = { Build-UpgradeChains }
    "weapons"    = { Build-WeaponProfiles }
    "production" = { Build-ProductionGraph }
    "truth"      = { Build-RuntimeTruth }
}

foreach ($stage in $stageList) {
    $s = $stage.Trim()
    if ($stageMap.ContainsKey($s)) {
        & $stageMap[$s]
        Write-Host ""
    } else {
        Write-Host "[WARN] Unknown stage: $s" -ForegroundColor Yellow
    }
}

Write-Host "[build_canonical_data] Done."
