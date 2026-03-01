<#
.SYNOPSIS
    Compress Unit_Types table using U() helper + compress CIV maps to single-line
#>
$file = "c:\Users\Jordan\Documents\AoE4-Workspace\mods\Japan\assets\scenarios\multiplayer\coop_4_japanese\scar\coop_4_japanese_data.scar"
$content = Get-Content $file -Raw
$t = "`t"

# Find Unit_Types block boundaries
$utStart = $content.IndexOf("-- Group types`r`nUnit_Types = {")
if ($utStart -lt 0) { $utStart = $content.IndexOf("-- Group types`nUnit_Types = {") }

# Find end of Unit_Types closing brace (followed by blank lines then Player Starting Unit section)
$utEndMarker = "-------------------------------------------`r`n-- Player Starting Unit Lookup Tables"
$utEndIdx = $content.IndexOf($utEndMarker, $utStart)
if ($utEndIdx -lt 0) {
    $utEndMarker = "-------------------------------------------`n-- Player Starting Unit Lookup Tables"
    $utEndIdx = $content.IndexOf($utEndMarker, $utStart)
}

# Find end of REINFORCE_RANGED_MAP section (end of CIV maps)
$mapsEndMarker = "-------------------------------------------`r`n`r`n-- Batch-create"
$mapsEndIdx = $content.IndexOf($mapsEndMarker, $utEndIdx)
if ($mapsEndIdx -lt 0) {
    $mapsEndMarker = "-------------------------------------------`n`n-- Batch-create"
    $mapsEndIdx = $content.IndexOf($mapsEndMarker, $utEndIdx)
}
$mapsEndIdx += "-------------------------------------------".Length + 2  # include the dashes + newline

$block = $content.Substring($utStart, $mapsEndIdx - $utStart)
$blockLines = ($block -split "`r?`n").Count
Write-Host "Replacing $blockLines lines (Unit_Types + CIV maps)" -ForegroundColor Cyan

$NOB = "SBP.CHINESE.UNIT_NEST_OF_BEES_4_CHI"
$MNG = "SBP.CHINESE.UNIT_MANGONEL_3_CHI"

$replacement = @"
-- Unit composition helper: U(type, count) / S(sbp, count)
local function U(t, n) return {type = t, numSquads = n} end
local function S(bp, n) return {sbp = bp, numSquads = n} end

Unit_Types = {
${t}-- Player starting units: Melee role
${t}start_player_melee     = {U("scar_horseman", 7), U("scar_spearman", 20), U("scar_scout", 3)},
${t}start_player_melee_inf = {U("scar_manatarms", 20), U("scar_scout", 3)},
${t}start_player_melee_cav = {U("scar_knight", 15), U("scar_horseman", 5), U("scar_scout", 3)},
${t}start_player_melee_mal = {U("scar_horseman", 7), U("scar_manatarms", 20), U("scar_scout", 3)},
${t}start_player_melee_abb = {U("scar_horseman", 20), U("scar_spearman", 10), U("scar_scout", 3)},
${t}-- Player starting units: Ranged role
${t}start_player_ranged     = {U("scar_archer", 15), U("scar_scout", 3)},
${t}start_player_ranged_mon = {U("scar_horsearcher", 15), U("scar_scout", 3)},
${t}start_player_ranged_rus = {U("scar_horsearcher", 15), U("scar_scout", 3)},
${t}start_player_ranged_abb = {U("scar_camel_rider", 5), U("scar_camel_archer", 10), U("scar_scout", 3)},
${t}start_player_ranged_mal = {U("scar_javelin", 20), U("scar_scout", 3)},
${t}start_player_ranged_chi = {U("scar_repeater_crossbow", 15), U("scar_scout", 3)},
${t}-- Reinforcements: Melee
${t}units_player_melee_reinforce     = {U("scar_horseman", 5), U("scar_spearman", 15)},
${t}units_player_melee_reinforce_inf = {U("scar_manatarms", 4), U("scar_spearman", 6)},
${t}units_player_melee_reinforce_cav = {U("scar_horseman", 7), U("scar_knight", 3)},
${t}units_player_melee_reinforce_mal = {U("scar_horseman", 3), U("scar_manatarms", 7)},
${t}-- Reinforcements: Ranged
${t}units_player_ranged_reinforce     = {U("scar_spearman", 10), U("scar_archer", 10)},
${t}units_player_ranged_reinforce_cav = {U("scar_horseman", 5), U("scar_horsearcher", 5)},
${t}units_player_ranged_reinforce_mal = {U("scar_manatarms", 5), U("scar_javelin", 5)},
${t}units_player_ranged_reinforce_chi = {U("scar_spearman", 6), U("scar_repeater_crossbow", 4)},
${t}units_player_ranged_reinforce_abb = {U("scar_camel_archer", 5), U("scar_camel_rider", 3)},
${t}-- Villager groups (faction-based)
${t}units_player_melee     = {U("scar_villager", 10), U("scar_spearman", 20)},
${t}units_player_ranged    = {U("scar_villager", 10), U("scar_archer", 15)},
${t}units_player_melee_mal = {U("scar_villager", 10), U("scar_manatarms", 20)},
${t}units_player_ranged_mal = {U("scar_villager", 10), U("scar_javelin", 15)},
${t}units_player_ranged_chi = {U("scar_villager", 10), U("scar_repeater_crossbow", 10)},
${t}-- Hostile: Static defenders & patrols
${t}units_camp          = {U("scar_spearman", 10), U("scar_archer", 5)},
${t}units_camp_hard     = {U("scar_manatarms", 5), U("scar_spearman", 10), U("scar_archer", 8)},
${t}units_camp_easy     = {U("scar_spearman", 7), U("scar_archer", 3)},
${t}units_patrol        = {U("scar_spearman", 10), U("scar_archer", 10)},
${t}units_patrol_hard   = {U("scar_manatarms", 10), U("scar_archer", 10)},
${t}units_cityguards      = {U("scar_manatarms", 20), U("scar_spearman", 20), U("scar_crossbowman", 15)},
${t}units_cityguards_hard = {U("scar_manatarms", 20), U("scar_spearman", 20), U("scar_knight", 15), U("scar_handcannon", 15)},
${t}units_cityguards_final = {U("scar_manatarms", 20), U("scar_spearman", 10), U("scar_knight", 10)},
${t}units_river_guards  = {U("scar_horseman", 10), U("scar_spearman", 20), U("scar_repeater_crossbow", 10), U("scar_archer", 10), S($MNG, 2)},
${t}units_cavalry_chi   = {U("scar_horseman", 5), U("scar_firelancer", 5)},
${t}-- Hostile: Ranged defenders
${t}units_ranged       = {U("scar_handcannon", 10), S($MNG, 1)},
${t}units_ranged_light = {U("scar_archer", 10), U("scar_springald", 1)},
${t}units_ranged_hard  = {U("scar_handcannon", 20), S($MNG, 2), U("scar_bombard", 1)},
${t}-- Hostile: Attack waves
${t}wave_city_5m       = {U("scar_horseman", 5), U("scar_archer", 5), U("scar_spearman", 10)},
${t}wave_city_10m_flank = {U("scar_knight", 5), U("scar_horseman", 10), U("scar_firelancer", 5)},
${t}wave_city_10m      = {U("scar_firelancer", 5), U("scar_repeater_crossbow", 10), U("scar_manatarms", 10), U("scar_spearman", 10)},
${t}wave_city_15m      = {U("scar_crossbowman", 10), U("scar_knight", 5), U("scar_manatarms", 15), U("scar_spearman", 5), U("scar_ram", 3), S($NOB, 1)},
${t}wave_city_20m      = {U("scar_knight", 15), U("scar_horseman", 15), U("scar_firelancer", 10)},
${t}wave_city_25m      = {U("scar_manatarms", 20), U("scar_knight", 10), U("scar_spearman", 10), U("scar_crossbowman", 10), U("scar_repeater_crossbow", 10), S($NOB, 2)},
${t}wave_city_30m      = {U("scar_manatarms", 20), U("scar_knight", 20), U("scar_crossbowman", 10), U("scar_handcannon", 10), U("scar_bombard", 2)},
${t}wave_city_40m      = {U("scar_spearman", 20), U("scar_manatarms", 25), U("scar_knight", 20), U("scar_handcannon", 15), S($NOB, 2), U("scar_bombard", 1), U("scar_ram", 3)},
${t}wave_city_45m      = {U("scar_knight", 20), U("scar_horseman", 20), U("scar_firelancer", 10)},
${t}wave_siege         = {S($NOB, 2), U("scar_bombard", 1), U("scar_manatarms", 10), U("scar_spearman", 20)},
${t}wave_no_siege      = {U("scar_spearman", 20), U("scar_repeater_crossbow", 10)},
${t}-- Allied units
${t}units_ally_infantry = {U("scar_manatarms", 25), U("scar_archer", 15)},
${t}wave_allied_siege   = {U("scar_manatarms", 20), U("scar_knight", 5), U("scar_bombard", 2)},
${t}wave_villageCaptured = {U("scar_archer", 10), U("scar_manatarms", 10), U("scar_spearman", 15)},
${t}guards_cliff        = {U("scar_archer", 20), S($NOB, 2)},
${t}-- Misc
${t}wave_light      = {U("scar_spearman", 10), U("scar_archer", 5), U("scar_horseman", 5)},
${t}wave_checkpoint = {U("scar_spearman", 10), U("scar_archer", 10), U("scar_manatarms", 5)},
}

-- Civ → Unit_Types key maps (melee: P1&3, ranged: P2&4)
CIV_MELEE_MAP = {malian = "start_player_melee_mal", abbasid = "start_player_melee_abb", rus = "start_player_melee_cav", french = "start_player_melee_cav", french_ha_01 = "start_player_melee_cav", english = "start_player_melee_inf", lancaster = "start_player_melee_inf", hre = "start_player_melee_inf", hre_ha_01 = "start_player_melee_inf", templar = "start_player_melee_inf", japanese = "start_player_melee_inf", chinese_ha_01 = "start_player_melee_inf"}
CIV_RANGED_MAP = {malian = "start_player_ranged_mal", chinese = "start_player_ranged_chi", chinese_ha_01 = "start_player_ranged_chi", abbasid = "start_player_ranged_abb", mongol = "start_player_ranged_mon", mongol_ha_gol = "start_player_ranged_mon", rus = "start_player_ranged_rus"}

UNIQUE_UNIT_MELEE = {mongol = {type = "scar_khan", numSquads = 1}, english = {sbp = SBP.ENGLISH.UNIT_ABBEY_KING_2, numSquads = 1}, french_ha_01 = {sbp = SBP.FRENCH_HA_01.UNIT_JEANNE_D_ARC_2_WOMANATARMS_FRE_HA_01, numSquads = 1}}
UNIQUE_UNIT_RANGED = {mongol = {type = "scar_khan", numSquads = 1}, english = {sbp = SBP.ENGLISH.UNIT_ABBEY_KING_2, numSquads = 1}, french_ha_01 = {sbp = SBP.FRENCH_HA_01.UNIT_JEANNE_D_ARC_2_ARCHER_FRE_HA_01, numSquads = 1}}
UNIQUE_UNIT_DEFAULT = {type = "scar_monk", numSquads = 3}

REINFORCE_MELEE_MAP = {malian = "units_player_melee_reinforce_mal", rus = "units_player_melee_reinforce_cav", french = "units_player_melee_reinforce_cav", french_ha_01 = "units_player_melee_reinforce_cav", english = "units_player_melee_reinforce_inf", lancaster = "units_player_melee_reinforce_inf", hre = "units_player_melee_reinforce_inf", hre_ha_01 = "units_player_melee_reinforce_inf", templar = "units_player_melee_reinforce_inf"}
REINFORCE_RANGED_MAP = {malian = "units_player_ranged_reinforce_mal", chinese = "units_player_ranged_reinforce_chi", chinese_ha_01 = "units_player_ranged_reinforce_chi", abbasid = "units_player_ranged_reinforce_abb", abbasid_ha_01 = "units_player_ranged_reinforce_abb", rus = "units_player_ranged_reinforce_cav", mongol = "units_player_ranged_reinforce_cav", mongol_ha_gol = "units_player_ranged_reinforce_cav"}
"@

$repLines = ($replacement -split "`n").Count
Write-Host "Replacement: $repLines lines (was $blockLines)" -ForegroundColor Green

# Apply replacement
$newContent = $content.Substring(0, $utStart) + $replacement + $content.Substring($mapsEndIdx)
Set-Content $file -Value $newContent -NoNewline -Encoding UTF8

$finalLines = (Get-Content $file).Length
$saved = 2948 - $finalLines
Write-Host "Final: $finalLines lines | Saved: $saved ($([math]::Round($saved / 2948 * 100, 1))%)" -ForegroundColor Cyan
