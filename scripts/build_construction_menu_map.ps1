param(
    [string]$BuildingsJson = "C:/Users/Jordan/Documents/AoE4-Workspace/data/aoe4/data/buildings/all-optimized.json",
    [string]$OutCsv = "C:/Users/Jordan/Documents/AoE4-Workspace/references/indexes/construction-menu-map.csv",
    [string]$OutMd = "C:/Users/Jordan/Documents/AoE4-Workspace/references/indexes/construction-menu-map.md",
    [string]$OutLua = "C:/Users/Jordan/Documents/AoE4-Workspace/references/indexes/construction-menu-map.lua"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path $BuildingsJson)) {
    throw "Buildings dataset not found: $BuildingsJson"
}

# ------------------------------------------------------------------
# 1) aoe4world civ code -> race_name + menu_prefix
# ------------------------------------------------------------------
# This table must stay in sync with AGS_CIV_PREFIXES in ags_blueprints.scar
# plus cardinal.scar's hardcoded prefix table.
$civCodeMap = @{
    # Base civs
    ab  = @{ race = "abbasid";          prefix = "abb_";         age_type = "wing" }
    ch  = @{ race = "chinese";          prefix = "chi_";         age_type = "landmark" }
    de  = @{ race = "sultanate";        prefix = "sul_";         age_type = "landmark" }
    en  = @{ race = "english";          prefix = "eng_";         age_type = "landmark" }
    fr  = @{ race = "french";           prefix = "fre_";         age_type = "landmark" }
    hr  = @{ race = "hre";              prefix = "hre_";         age_type = "landmark" }
    mo  = @{ race = "mongol";           prefix = "mon_";         age_type = "landmark" }
    ru  = @{ race = "rus";              prefix = "rus_";         age_type = "landmark" }
    # DLC civs
    by  = @{ race = "byzantine";        prefix = "byz_";         age_type = "landmark" }
    ja  = @{ race = "japanese";         prefix = "jpn_";         age_type = "landmark" }
    ma  = @{ race = "malian";           prefix = "mal_";         age_type = "landmark" }
    ot  = @{ race = "ottoman";          prefix = "ott_";         age_type = "landmark" }
    hl  = @{ race = "lancaster";        prefix = "lan_";         age_type = "landmark" }
    kt  = @{ race = "templar";          prefix = "tem_";         age_type = "upgrade" }
    # HA variants
    ay  = @{ race = "abbasid_ha_01";    prefix = "abb_ha_01_";   age_type = "wing" }
    zx  = @{ race = "chinese_ha_01";    prefix = "chi_ha_01_";   age_type = "landmark" }
    je  = @{ race = "french_ha_01";     prefix = "fre_ha_01_";   age_type = "landmark" }
    od  = @{ race = "hre_ha_01";        prefix = "hre_ha_01_";   age_type = "landmark" }
    gol = @{ race = "mongol_ha_gol";    prefix = "mon_ha_gol_";  age_type = "upgrade" }
    mac = @{ race = "byzantine_ha_mac"; prefix = "byz_ha_mac_";  age_type = "landmark" }
    sen = @{ race = "japanese_ha_sen";  prefix = "jpn_ha_sen_";  age_type = "landmark" }
    tug = @{ race = "sultanate_ha_tug"; prefix = "sul_ha_tug_";  age_type = "landmark" }
}

# ------------------------------------------------------------------
# 2) Load buildings data
# ------------------------------------------------------------------
$buildRoot = Get-Content $BuildingsJson -Raw | ConvertFrom-Json
$buildings = @($buildRoot.data)

# ------------------------------------------------------------------
# 3) Classify each building variation into a construction menu group
# ------------------------------------------------------------------
# Menu groups:
#   {prefix}age{N}          — regular buildings that appear at age N (N=2,3,4)
#   {prefix}age{N}_wonders  — landmark selection at age N (N=1,2,3)
#   {prefix}age1            — Dark Age buildings (always available, no lock needed)
#   siege_engineer           — special engineer construction menu
#   siege_engineer_field_construction_mon — Mongol-specific engineer menu

$rows = New-Object System.Collections.Generic.List[pscustomobject]

foreach ($b in $buildings) {
    if (-not ($b.PSObject.Properties.Name -contains "variations")) { continue }
    $variations = @($b.variations)

    foreach ($v in $variations) {
        foreach ($code in @($v.civs)) {
            if (-not $civCodeMap.ContainsKey($code)) { continue }

            $civInfo = $civCodeMap[$code]
            $prefix = $civInfo.prefix

            # Determine building classes
            $bClasses = @()
            if ($b.PSObject.Properties.Name -contains "classes") { $bClasses += @($b.classes) }
            $vClasses = @()
            if ($v.PSObject.Properties.Name -contains "classes") { $vClasses += @($v.classes) }
            $allClasses = @($bClasses + $vClasses | Sort-Object -Unique)

            # Determine age
            $age = 1
            if ($b.PSObject.Properties.Name -contains "minAge") { $age = [int]$b.minAge }

            # Check if this is a landmark/wonder
            $isLandmark = $false
            $wonderAge = 0
            if ($allClasses -contains "wonder_dark_age") {
                $isLandmark = $true; $wonderAge = 1
            } elseif ($allClasses -contains "wonder_feudal_age") {
                $isLandmark = $true; $wonderAge = 2
            } elseif ($allClasses -contains "wonder_castle_age") {
                $isLandmark = $true; $wonderAge = 3
            }

            # Check for Age 4 wonders (final wonders)
            $isFinalWonder = ($allClasses -contains "wonder") -and (-not $isLandmark) -and ($age -ge 4 -or $b.name -match "wonder|great.*mosque|hagia.*sophia|forbidden|cathedral|final.*wonder|agra.*fort|nikko|glucksburg|canterbury")

            # Assign menu group
            $menuGroup = ""
            $menuType = "regular"
            if ($isLandmark) {
                $menuGroup = "${prefix}age${wonderAge}_wonders"
                $menuType = "landmark"
            } elseif ($isFinalWonder) {
                $menuGroup = "${prefix}age4"
                $menuType = "wonder"
            } elseif ($age -ge 2) {
                $menuGroup = "${prefix}age${age}"
                $menuType = "regular"
            } else {
                $menuGroup = "${prefix}age1"
                $menuType = "dark_age"
            }

            $rows.Add([pscustomobject]@{
                race_name     = $civInfo.race
                civ_code      = $code
                menu_prefix   = $prefix
                age_type      = $civInfo.age_type
                menu_group    = $menuGroup
                menu_type     = $menuType
                building_age  = $age
                building_id   = $b.id
                building_name = $b.name
                attrib_name   = $v.attribName
                pbgid         = $v.pbgid
                is_landmark   = $isLandmark
                wonder_age    = $wonderAge
                classes       = ($allClasses -join ";")
            })
        }
    }
}

$rows = @($rows | Sort-Object race_name, menu_group, building_age, building_name)

# ------------------------------------------------------------------
# 4) Build per-civ menu summary (the key output for age-lock validation)
# ------------------------------------------------------------------
$menuSummary = New-Object System.Collections.Generic.List[pscustomobject]

$groupedByCiv = $rows | Group-Object race_name
foreach ($civGroup in $groupedByCiv) {
    $race = $civGroup.Name
    $civRows = @($civGroup.Group)
    $info = $civRows[0]

    # Collect distinct menu groups for this civ
    $menus = @($civRows | Select-Object -ExpandProperty menu_group | Sort-Object -Unique)

    # Age menus (regular buildings per age tier)
    $ageMenus = @($menus | Where-Object { $_ -match "age[234]$" })
    # Wonder/landmark menus
    $wonderMenus = @($menus | Where-Object { $_ -match "age[123]_wonders$" })
    # Dark age menu (informational)
    $darkMenus = @($menus | Where-Object { $_ -match "age1$" })

    # Count buildings per menu
    $menuCounts = @{}
    foreach ($r in $civRows) {
        if (-not $menuCounts.ContainsKey($r.menu_group)) { $menuCounts[$r.menu_group] = 0 }
        $menuCounts[$r.menu_group]++
    }

    # Cardinal.scar coverage check
    $cardinalPrefixes = @{
        "chi_" = $true; "eng_" = $true; "fre_" = $true; "hre_" = $true;
        "mon_" = $true; "rus_" = $true; "sul_" = $true; "abb_" = $true
    }
    $inCardinal = $cardinalPrefixes.ContainsKey($info.menu_prefix)

    # Ottoman special case: cardinal uses sul_ for ottoman
    $cardinalPrefix = $info.menu_prefix
    if ($race -eq "ottoman") {
        $inCardinal = $true
        $cardinalPrefix = "sul_"
    }

    $menuSummary.Add([pscustomobject]@{
        race_name           = $race
        menu_prefix         = $info.menu_prefix
        age_type            = $info.age_type
        in_cardinal         = $inCardinal
        cardinal_prefix     = if ($inCardinal) { $cardinalPrefix } else { "" }
        age_menus           = ($ageMenus -join ";")
        wonder_menus        = ($wonderMenus -join ";")
        age_menu_count      = $ageMenus.Count
        wonder_menu_count   = $wonderMenus.Count
        total_buildings     = $civRows.Count
        menu_building_counts = (($menuCounts.GetEnumerator() | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Value)" }) -join ";")
    })
}

$menuSummary = @($menuSummary | Sort-Object race_name)

# ------------------------------------------------------------------
# 5) Write CSV (full building-level detail)
# ------------------------------------------------------------------
$csvDir = Split-Path $OutCsv -Parent
if (-not (Test-Path $csvDir)) { New-Item -Path $csvDir -ItemType Directory | Out-Null }
$rows | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------------
# 6) Write Markdown report (civ-level menu summary + validation)
# ------------------------------------------------------------------
$mdDir = Split-Path $OutMd -Parent
if (-not (Test-Path $mdDir)) { New-Item -Path $mdDir -ItemType Directory | Out-Null }

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Construction Menu Map (Derived)")
$md.Add("")
$md.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$md.Add("")
$md.Add("Derivation:")
$md.Add("- Building data from all-optimized.json (aoe4world)")
$md.Add("- Menu group inference: regular buildings -> ``{prefix}age{minAge}``, landmarks -> ``{prefix}age{wonderAge}_wonders``")
$md.Add("- Civ prefix mapping aligned with ``AGS_CIV_PREFIXES`` in ags_blueprints.scar")
$md.Add("- ``in_cardinal`` indicates whether ``Player_SetMaximumAge`` in cardinal.scar handles this civ")
$md.Add("")
$md.Add("## Per-Civ Menu Summary")
$md.Add("")
$md.Add("| race_name | menu_prefix | age_type | in_cardinal | cardinal_prefix | age_menus | wonder_menus | buildings |")
$md.Add("|---|---|---|---|---|---|---|---:|")
foreach ($s in $menuSummary) {
    $ageCell = $s.age_menus.Replace("|", "\\|")
    $wonderCell = $s.wonder_menus.Replace("|", "\\|")
    $md.Add("| $($s.race_name) | ``$($s.menu_prefix)`` | $($s.age_type) | $($s.in_cardinal) | $($s.cardinal_prefix) | $ageCell | $wonderCell | $($s.total_buildings) |")
}

$md.Add("")
$md.Add("## Validation: Missing from cardinal.scar")
$md.Add("")
$missing = @($menuSummary | Where-Object { -not $_.in_cardinal })
if ($missing.Count -eq 0) {
    $md.Add("All playable civs are covered by cardinal.scar prefix table.")
} else {
    $md.Add("The following $(($missing.Count)) civs are **not** handled by ``Player_SetMaximumAge`` in cardinal.scar:")
    $md.Add("")
    $md.Add("| race_name | menu_prefix | age_type | age_menus | wonder_menus |")
    $md.Add("|---|---|---|---|---|")
    foreach ($m in $missing) {
        $md.Add("| $($m.race_name) | ``$($m.menu_prefix)`` | $($m.age_type) | $($m.age_menus) | $($m.wonder_menus) |")
    }
    $md.Add("")
    $md.Add("These civs silently skip all age-menu locking when ``Player_SetMaximumAge`` is called.")
}

$md.Add("")
$md.Add("## Validation: Ottoman Menu Prefix Mismatch")
$md.Add("")
$ottomanEntry = $menuSummary | Where-Object { $_.race_name -eq "ottoman" }
if ($ottomanEntry -and $ottomanEntry.menu_prefix -ne $ottomanEntry.cardinal_prefix) {
    $md.Add("Ottoman uses ``$($ottomanEntry.menu_prefix)`` prefix natively but cardinal.scar maps it to ``$($ottomanEntry.cardinal_prefix)``.")
    $md.Add("This means ``Player_SetMaximumAge`` targets ``$($ottomanEntry.cardinal_prefix)age2/3/4`` menus for Ottoman,")
    $md.Add("which are actually **Sultanate** menu IDs. If Ottoman has distinct ``ott_age*`` menus, these calls are no-ops.")
} else {
    $md.Add("Ottoman prefix alignment verified.")
}

$md.Add("")
$md.Add("## Building Detail by Menu Group (per civ)")
$md.Add("")
foreach ($civGroup in ($rows | Group-Object race_name | Sort-Object Name)) {
    $md.Add("### $($civGroup.Name)")
    $md.Add("")
    $md.Add("| menu_group | type | building_name | attrib_name | age |")
    $md.Add("|---|---|---|---|---:|")
    foreach ($r in @($civGroup.Group | Sort-Object menu_group, building_age, building_name)) {
        $md.Add("| ``$($r.menu_group)`` | $($r.menu_type) | $($r.building_name) | $($r.attrib_name) | $($r.building_age) |")
    }
    $md.Add("")
}

Set-Content -Path $OutMd -Value $md -Encoding UTF8

# ------------------------------------------------------------------
# 7) Write Lua lookup table for runtime use
# ------------------------------------------------------------------
$lua = New-Object System.Collections.Generic.List[string]
$lua.Add("-- Construction Menu Map (Derived)")
$lua.Add("-- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$lua.Add("-- Source: all-optimized.json + AGS_CIV_PREFIXES")
$lua.Add("-- Usage: CONSTRUCTION_MENU_MAP[race_name] returns per-civ menu info")
$lua.Add("")
$lua.Add("CONSTRUCTION_MENU_MAP = {")
foreach ($s in $menuSummary) {
    $lua.Add("    [""$($s.race_name)""] = {")
    $lua.Add("        prefix = ""$($s.menu_prefix)"",")
    $lua.Add("        age_type = ""$($s.age_type)"",")
    $lua.Add("        in_cardinal = $($s.in_cardinal.ToString().ToLower()),")

    # Age menus
    $ageList = @()
    if ($s.age_menus) { $ageList = @($s.age_menus -split ";") }
    $ageQuoted = ($ageList | ForEach-Object { '"' + $_ + '"' }) -join ", "
    $lua.Add("        age_menus = { $ageQuoted },")

    # Wonder menus
    $wonderList = @()
    if ($s.wonder_menus) { $wonderList = @($s.wonder_menus -split ";") }
    $wonderQuoted = ($wonderList | ForEach-Object { '"' + $_ + '"' }) -join ", "
    $lua.Add("        wonder_menus = { $wonderQuoted },")

    $lua.Add("    },")
}
$lua.Add("}")
$lua.Add("")
$lua.Add("-- Convenience: cardinal.scar-compatible prefix table (all civs)")
$lua.Add("CONSTRUCTION_MENU_PREFIXES = {")
foreach ($s in $menuSummary) {
    $lua.Add("    [""$($s.race_name)""] = ""$($s.menu_prefix)"",")
}
$lua.Add("}")

Set-Content -Path $OutLua -Value $lua -Encoding UTF8

# ------------------------------------------------------------------
# 8) Summary output
# ------------------------------------------------------------------
"Wrote: $OutCsv"
"Wrote: $OutMd"
"Wrote: $OutLua"
"Total building rows: $($rows.Count)"
"Civs with menu data: $($menuSummary.Count)"
"Missing from cardinal.scar: $(@($menuSummary | Where-Object { -not $_.in_cardinal }).Count)"
