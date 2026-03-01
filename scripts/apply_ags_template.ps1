<#
.SYNOPSIS
    Replace AGS_ENTITY_TABLE + CIV_SUFFIX with template-generated version
#>
$file = "c:\Users\Jordan\Documents\AoE4-Workspace\mods\Japan\assets\scenarios\multiplayer\coop_4_japanese\scar\coop_4_japanese_data.scar"
$content = Get-Content $file -Raw

# Find block boundaries
$startIdx = $content.IndexOf("AGS_ENTITY_TABLE = {")
$civSuffixStart = $content.IndexOf("local CIV_SUFFIX = {", $startIdx)
# Find end of CIV_SUFFIX closing brace
$civSuffixEndBrace = $content.IndexOf("}", $civSuffixStart + 20)
$endIdx = $civSuffixEndBrace + 1  # include the }

$blockToReplace = $content.Substring($startIdx, $endIdx - $startIdx)
$blockLines = ($blockToReplace -split "`r?`n").Count
Write-Host "Replacing $blockLines lines (chars $startIdx to $endIdx)" -ForegroundColor Cyan

$t = "`t"

$replacement = @"
-- Civ suffix map (shared by AGS_ENTITY_TABLE + CBA_SIEGE_TABLE generators)
local CIV_SUFFIX = {
${t}english = "eng", chinese = "chi", french = "fre", hre = "hre", rus = "rus",
${t}abbasid = "abb", mongol = "mon", sultanate = "sul", malian = "mal",
${t}ottoman = "ott", japanese = "jpn", byzantine = "byz",
}

-- AGS_ENTITY_TABLE — Generated from template + per-civ overrides
-- Universal keys: always pattern_{suffix}
local AGS_UNIVERSAL = {
${t}{k="town_center_capital", f="building_town_center_capital_%s"},
${t}{k="town_center",         f="building_town_center_%s"},
${t}{k="castle",              f="building_defense_keep_%s"},
${t}{k="villager",            f="unit_villager_1_%s"},
${t}{k="scout",               f="unit_scout_1_%s"},
${t}{k="king",                f="unit_king_1_%s"},
${t}{k="scar_dock",           f="building_unit_naval_%s"},
${t}{k="palisade_wall",       f="building_defense_palisade_%s"},
${t}{k="palisade_gate",       f="building_defense_palisade_gate_%s"},
${t}{k="monk",                f="unit_monk_3_%s"},
${t}{k="crossbow",            f="unit_crossbowman_3_%s"},
${t}{k="stone_wall",          f="building_defense_wall_%s"},
}
-- Variant keys: "control" civs get ctrl format, others get base format
local AGS_VARIANT = {
${t}{k="market",        ctrl="building_econ_market_control_%s",        base="building_econ_market_%s"},
${t}{k="monastery",     ctrl="building_unit_religious_control_%s",     base="building_unit_religious_%s"},
${t}{k="barracks",      ctrl="building_unit_infantry_control_%s",      base="building_unit_infantry_%s"},
${t}{k="stable",        ctrl="building_unit_cavalry_control_%s",       base="building_unit_cavalry_%s"},
${t}{k="archery_range", ctrl="building_unit_ranged_control_%s",        base="building_unit_ranged_%s"},
${t}{k="siege_workshop",ctrl="building_unit_siege_control_%s",         base="building_unit_siege_%s"},
${t}{k="house",         ctrl="building_house_control_%s",              base="building_house_%s"},
${t}{k="blacksmith",    ctrl="building_tech_unit_infantry_control_%s", base="building_tech_unit_infantry_%s"},
${t}{k="mining_camp",   ctrl="building_econ_mining_camp_control_%s",   base="building_econ_mining_camp_%s"},
${t}{k="lumber_camp",   ctrl="building_econ_wood_control_%s",          base="building_econ_wood_%s"},
${t}{k="mill",          ctrl="building_econ_food_control_%s",          base="building_econ_food_%s"},
${t}{k="arsenal",       ctrl="building_tech_unit_ranged_control_%s",   base="building_tech_unit_ranged_%s"},
}
local AGS_IS_CTRL = {eng=true, chi=true, fre=true, hre=true, rus=true, sul=true, byz=true, abb=true}
-- Per-civ overrides (wonder + entries that differ from template)
local AGS_OVERRIDES = {
${t}english = {town_center_landmark = "building_landmark_age2_westminster_palace_eng", wonder_imperial_age = "building_wonder_age4_canterbury_cathedral_eng"},
${t}chinese = {wonder_imperial_age = "building_wonder_age4_forbidden_control_chi"},
${t}french = {wonder_imperial_age = "building_wonder_age4_la_grande_cathedral_fre"},
${t}hre = {town_center_landmark = "building_landmark_age3_hohenzollern_castle_hre", monk = "unit_monk_1_hre", wonder_imperial_age = "building_wonder_age4_glucksburg_castle_hre"},
${t}rus = {castle = "building_defense_keep_control_rus", wonder_imperial_age = "building_wonder_age4_saint_basils_cathedral_control_rus"},
${t}abbasid = {
${t}${t}castle = "building_defense_keep_control_abb", springald_buildable = "unit_springald_3_buildable_abb",
${t}${t}mangonel_buildable = "unit_mangonel_3_buildable_abb", house_of_wisdom = "building_house_of_wisdom_control_abb",
${t}${t}wonder_imperial_age = "building_wonder_age4_great_mosque_control_abb",
${t}},
${t}mongol = {
${t}${t}castle = "building_defense_keep_control_nov", town_center_capital_moving = "building_town_center_capital_moving_mon",
${t}${t}scout = "unit_khan_1_mon", house_moving = "building_house_moving_mon",
${t}${t}wonder_imperial_age = "building_wonder_age4_final_wonder_mon",
${t}${t}mining_camp = "building_house_mon", lumber_camp = "building_house_mon", mill = "building_house_mon",
${t}},
${t}sultanate = {castle = "building_defense_keep_control_sul", monk = "unit_monk_2_sul", wonder_imperial_age = "building_wonder_age4_agra_fort_control_sul"},
${t}malian = {wonder_imperial_age = "building_wonder_age4_great_mosque_control_mal", arsenal = "building_tech_unit_ranged_control_nrm"},
${t}ottoman = {wonder_imperial_age = "building_wonder_age4_blue_mosque_ott", arsenal = "building_tech_unit_ranged_control_lith"},
${t}japanese = {wonder_imperial_age = "building_wonder_age4_great_mosque_control_jpn", mill = "building_house_jpn", arsenal = "building_tech_unit_ranged_control_nrm"},
${t}byzantine = {wonder_imperial_age = "building_wonder_age4_forbidden_control_byz", arsenal = "building_tech_unit_ranged_control_abb"},
}
local AGS_REMOVE = {
${t}mongol = {palisade_wall=true, palisade_gate=true, stone_wall=true},
${t}malian = {crossbow=true}, ottoman = {crossbow=true}, japanese = {crossbow=true},
}
-- Expansion civs (all use _control_ variant)
local DLC_AGS = {
${t}abbasid_ha_01 = {sfx = "abb_ha_01", over = {
${t}${t}castle = "building_defense_keep_control_abb_ha_01", springald_buildable = "unit_springald_3_buildable_abb_ha_01",
${t}${t}mangonel_buildable = "unit_mangonel_3_buildable_abb_ha_01", house_of_wisdom = "building_house_of_wisdom_control_abb_ha_01",
${t}${t}wonder_imperial_age = "building_wonder_age4_great_mosque_control_abb_ha_01",
${t}}},
${t}chinese_ha_01 = {sfx = "chi_ha_01", over = {wonder_imperial_age = "building_wonder_age4_forbidden_control_chi_ha_01"}},
${t}french_ha_01 = {sfx = "fre_ha_01", over = {wonder_imperial_age = "building_wonder_age4_la_grande_cathedral_fre_ha_01"}},
${t}hre_ha_01 = {sfx = "hre_ha_01", over = {
${t}${t}town_center_landmark = "building_landmark_age3_hohenzollern_castle_hre_ha_01",
${t}${t}monk = "unit_monk_1_hre_ha_01", wonder_imperial_age = "building_wonder_age4_glucksburg_castle_hre_ha_01",
${t}}},
}
function _BuildEntityTable()
${t}AGS_ENTITY_TABLE = {}
${t}for civ, sfx in pairs(CIV_SUFFIX) do
${t}${t}local entry = {}
${t}${t}local is_ctrl = AGS_IS_CTRL[sfx]
${t}${t}for _, t in ipairs(AGS_UNIVERSAL) do entry[t.k] = string.format(t.f, sfx) end
${t}${t}for _, t in ipairs(AGS_VARIANT) do entry[t.k] = string.format(is_ctrl and t.ctrl or t.base, sfx) end
${t}${t}if AGS_OVERRIDES[civ] then for k, v in pairs(AGS_OVERRIDES[civ]) do entry[k] = v end end
${t}${t}if AGS_REMOVE[civ] then for k, _ in pairs(AGS_REMOVE[civ]) do entry[k] = nil end end
${t}${t}AGS_ENTITY_TABLE[civ] = entry
${t}end
${t}for dlc, spec in pairs(DLC_AGS) do
${t}${t}local entry = {}
${t}${t}for _, t in ipairs(AGS_UNIVERSAL) do entry[t.k] = string.format(t.f, spec.sfx) end
${t}${t}for _, t in ipairs(AGS_VARIANT) do entry[t.k] = string.format(t.ctrl, spec.sfx) end
${t}${t}if spec.over then for k, v in pairs(spec.over) do entry[k] = v end end
${t}${t}AGS_ENTITY_TABLE[dlc] = entry
${t}end
end
_BuildEntityTable()
"@

$repLines = ($replacement -split "`n").Count
Write-Host "Replacement: $repLines lines" -ForegroundColor Green

# Apply replacement
$newContent = $content.Substring(0, $startIdx) + $replacement + $content.Substring($endIdx)
Set-Content $file -Value $newContent -NoNewline -Encoding UTF8

# Also remove the now-duplicate "-- Civ suffix map" + CIV_SUFFIX block that appears before SIEGE section
# (It was already there from Phase 2 — now we have CIV_SUFFIX in the AGS section)
$newContent2 = Get-Content $file -Raw
$dupStart = $newContent2.IndexOf("`r`n`r`n-- Civ suffix map (shared by AGS_ENTITY_TABLE lookups and CBA_SIEGE_TABLE generator)")
if ($dupStart -ge 0) {
    $dupEnd = $newContent2.IndexOf("}", $dupStart + 50) + 1
    $newContent2 = $newContent2.Substring(0, $dupStart) + $newContent2.Substring($dupEnd)
    Set-Content $file -Value $newContent2 -NoNewline -Encoding UTF8
    Write-Host "Removed duplicate CIV_SUFFIX block" -ForegroundColor Yellow
}

$finalLines = (Get-Content $file).Length
$saved = 2948 - $finalLines
Write-Host "Final: $finalLines lines | Saved: $saved ($([math]::Round($saved / 2948 * 100, 1))%)" -ForegroundColor Cyan
