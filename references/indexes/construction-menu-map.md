# Construction Menu Map (Derived)

Generated: 2026-04-07 17:43:47

Derivation:
- Building data from all-optimized.json (aoe4world)
- Menu group inference: regular buildings -> `{prefix}age{minAge}`, landmarks -> `{prefix}age{wonderAge}_wonders`
- Civ prefix mapping aligned with `AGS_CIV_PREFIXES` in ags_blueprints.scar
- `in_cardinal` indicates whether `Player_SetMaximumAge` in cardinal.scar handles this civ

## Per-Civ Menu Summary

| race_name | menu_prefix | age_type | in_cardinal | cardinal_prefix | age_menus | wonder_menus | buildings |
|---|---|---|---|---|---|---|---:|
| abbasid | `abb_` | wing | True | abb_ | abb_age2;abb_age3;abb_age4 | abb_age2_wonders | 25 |
| abbasid_ha_01 | `abb_ha_01_` | wing | False |  | abb_ha_01_age2;abb_ha_01_age3;abb_ha_01_age4 | abb_ha_01_age2_wonders | 25 |
| byzantine | `byz_` | landmark | False |  | byz_age2;byz_age3;byz_age4 | byz_age1_wonders;byz_age2_wonders;byz_age3_wonders | 33 |
| byzantine_ha_mac | `byz_ha_mac_` | landmark | False |  | byz_ha_mac_age2;byz_ha_mac_age3;byz_ha_mac_age4 | byz_ha_mac_age1_wonders;byz_ha_mac_age2_wonders;byz_ha_mac_age3_wonders | 31 |
| chinese | `chi_` | landmark | True | chi_ | chi_age2;chi_age3;chi_age4 | chi_age1_wonders;chi_age2_wonders;chi_age3_wonders | 33 |
| chinese_ha_01 | `chi_ha_01_` | landmark | False |  | chi_ha_01_age2;chi_ha_01_age3;chi_ha_01_age4 | chi_ha_01_age1_wonders;chi_ha_01_age2_wonders;chi_ha_01_age3_wonders | 33 |
| english | `eng_` | landmark | True | eng_ | eng_age2;eng_age3;eng_age4 | eng_age1_wonders;eng_age2_wonders;eng_age3_wonders | 30 |
| french | `fre_` | landmark | True | fre_ | fre_age2;fre_age3;fre_age4 | fre_age1_wonders;fre_age2_wonders;fre_age3_wonders | 30 |
| french_ha_01 | `fre_ha_01_` | landmark | False |  | fre_ha_01_age2;fre_ha_01_age3;fre_ha_01_age4 | fre_ha_01_age1_wonders;fre_ha_01_age2_wonders;fre_ha_01_age3_wonders | 30 |
| hre | `hre_` | landmark | True | hre_ | hre_age2;hre_age3;hre_age4 | hre_age1_wonders;hre_age2_wonders;hre_age3_wonders | 30 |
| hre_ha_01 | `hre_ha_01_` | landmark | False |  | hre_ha_01_age2;hre_ha_01_age3;hre_ha_01_age4 | hre_ha_01_age1_wonders;hre_ha_01_age2_wonders;hre_ha_01_age3_wonders | 30 |
| japanese | `jpn_` | landmark | False |  | jpn_age2;jpn_age3;jpn_age4 | jpn_age1_wonders;jpn_age2_wonders;jpn_age3_wonders | 29 |
| japanese_ha_sen | `jpn_ha_sen_` | landmark | False |  | jpn_ha_sen_age2;jpn_ha_sen_age3;jpn_ha_sen_age4 | jpn_ha_sen_age1_wonders;jpn_ha_sen_age2_wonders;jpn_ha_sen_age3_wonders | 31 |
| lancaster | `lan_` | landmark | False |  | lan_age2;lan_age3;lan_age4 | lan_age1_wonders;lan_age2_wonders;lan_age3_wonders | 31 |
| malian | `mal_` | landmark | False |  | mal_age2;mal_age3;mal_age4 | mal_age1_wonders;mal_age2_wonders;mal_age3_wonders | 32 |
| mongol | `mon_` | landmark | True | mon_ | mon_age2;mon_age3;mon_age4 | mon_age1_wonders;mon_age2_wonders;mon_age3_wonders | 21 |
| mongol_ha_gol | `mon_ha_gol_` | upgrade | False |  | mon_ha_gol_age2;mon_ha_gol_age3;mon_ha_gol_age4 | mon_ha_gol_age1_wonders | 19 |
| ottoman | `ott_` | landmark | True | sul_ | ott_age2;ott_age3;ott_age4 | ott_age1_wonders;ott_age2_wonders;ott_age3_wonders | 31 |
| rus | `rus_` | landmark | True | rus_ | rus_age2;rus_age3;rus_age4 | rus_age1_wonders;rus_age2_wonders;rus_age3_wonders | 30 |
| sultanate | `sul_` | landmark | True | sul_ | sul_age2;sul_age3;sul_age4 | sul_age1_wonders;sul_age2_wonders;sul_age3_wonders | 30 |
| sultanate_ha_tug | `sul_ha_tug_` | landmark | False |  | sul_ha_tug_age2;sul_ha_tug_age3;sul_ha_tug_age4 | sul_ha_tug_age1_wonders;sul_ha_tug_age2_wonders;sul_ha_tug_age3_wonders | 28 |
| templar | `tem_` | upgrade | False |  | tem_age2;tem_age3;tem_age4 |  | 23 |

## Validation: Missing from cardinal.scar

The following 13 civs are **not** handled by `Player_SetMaximumAge` in cardinal.scar:

| race_name | menu_prefix | age_type | age_menus | wonder_menus |
|---|---|---|---|---|
| abbasid_ha_01 | `abb_ha_01_` | wing | abb_ha_01_age2;abb_ha_01_age3;abb_ha_01_age4 | abb_ha_01_age2_wonders |
| byzantine | `byz_` | landmark | byz_age2;byz_age3;byz_age4 | byz_age1_wonders;byz_age2_wonders;byz_age3_wonders |
| byzantine_ha_mac | `byz_ha_mac_` | landmark | byz_ha_mac_age2;byz_ha_mac_age3;byz_ha_mac_age4 | byz_ha_mac_age1_wonders;byz_ha_mac_age2_wonders;byz_ha_mac_age3_wonders |
| chinese_ha_01 | `chi_ha_01_` | landmark | chi_ha_01_age2;chi_ha_01_age3;chi_ha_01_age4 | chi_ha_01_age1_wonders;chi_ha_01_age2_wonders;chi_ha_01_age3_wonders |
| french_ha_01 | `fre_ha_01_` | landmark | fre_ha_01_age2;fre_ha_01_age3;fre_ha_01_age4 | fre_ha_01_age1_wonders;fre_ha_01_age2_wonders;fre_ha_01_age3_wonders |
| hre_ha_01 | `hre_ha_01_` | landmark | hre_ha_01_age2;hre_ha_01_age3;hre_ha_01_age4 | hre_ha_01_age1_wonders;hre_ha_01_age2_wonders;hre_ha_01_age3_wonders |
| japanese | `jpn_` | landmark | jpn_age2;jpn_age3;jpn_age4 | jpn_age1_wonders;jpn_age2_wonders;jpn_age3_wonders |
| japanese_ha_sen | `jpn_ha_sen_` | landmark | jpn_ha_sen_age2;jpn_ha_sen_age3;jpn_ha_sen_age4 | jpn_ha_sen_age1_wonders;jpn_ha_sen_age2_wonders;jpn_ha_sen_age3_wonders |
| lancaster | `lan_` | landmark | lan_age2;lan_age3;lan_age4 | lan_age1_wonders;lan_age2_wonders;lan_age3_wonders |
| malian | `mal_` | landmark | mal_age2;mal_age3;mal_age4 | mal_age1_wonders;mal_age2_wonders;mal_age3_wonders |
| mongol_ha_gol | `mon_ha_gol_` | upgrade | mon_ha_gol_age2;mon_ha_gol_age3;mon_ha_gol_age4 | mon_ha_gol_age1_wonders |
| sultanate_ha_tug | `sul_ha_tug_` | landmark | sul_ha_tug_age2;sul_ha_tug_age3;sul_ha_tug_age4 | sul_ha_tug_age1_wonders;sul_ha_tug_age2_wonders;sul_ha_tug_age3_wonders |
| templar | `tem_` | upgrade | tem_age2;tem_age3;tem_age4 |  |

These civs silently skip all age-menu locking when `Player_SetMaximumAge` is called.

## Validation: Ottoman Menu Prefix Mismatch

Ottoman uses `ott_` prefix natively but cardinal.scar maps it to `sul_`.
This means `Player_SetMaximumAge` targets `sul_age2/3/4` menus for Ottoman,
which are actually **Sultanate** menu IDs. If Ottoman has distinct `ott_age*` menus, these calls are no-ops.

## Building Detail by Menu Group (per civ)

### abbasid

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `abb_age1` | dark_age | Barracks | building_unit_infantry_control_abb | 1 |
| `abb_age1` | dark_age | Capital Town Center | building_town_center_capital_abb | 1 |
| `abb_age1` | dark_age | Dock | building_unit_naval_abb | 1 |
| `abb_age1` | dark_age | Farm | building_resource_farm_control_abb | 1 |
| `abb_age1` | dark_age | House | building_house_control_abb | 1 |
| `abb_age1` | dark_age | Lumber Camp | building_econ_wood_control_abb | 1 |
| `abb_age1` | dark_age | Mill | building_econ_food_control_abb | 1 |
| `abb_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_abb | 1 |
| `abb_age1` | dark_age | Mosque | building_unit_religious_control_abb | 1 |
| `abb_age1` | dark_age | Outpost | building_defense_outpost_control_abb | 1 |
| `abb_age1` | dark_age | Palisade | building_defense_palisade_abb | 1 |
| `abb_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_abb | 1 |
| `abb_age1` | dark_age | Stable | building_unit_cavalry_control_abb | 1 |
| `abb_age1` | dark_age | Town Center | building_town_center_abb | 1 |
| `abb_age2` | regular | Archery Range | building_unit_ranged_control_abb | 2 |
| `abb_age2` | regular | Blacksmith | building_tech_unit_infantry_control_abb | 2 |
| `abb_age2` | regular | Market | building_econ_market_control_abb | 2 |
| `abb_age2` | regular | Stone Wall | building_defense_wall_abb | 2 |
| `abb_age2` | regular | Stone Wall Gate | building_defense_wall_gate_abb | 2 |
| `abb_age2` | regular | Stone Wall Tower | building_defense_tower_abb | 2 |
| `abb_age2_wonders` | landmark | House of Wisdom | building_house_of_wisdom_control_abb | 1 |
| `abb_age3` | regular | Keep | building_defense_keep_control_abb | 3 |
| `abb_age3` | regular | Siege Workshop | building_unit_siege_control_abb | 3 |
| `abb_age4` | regular | Madrasa | building_tech_university_control_abb | 4 |
| `abb_age4` | wonder | Prayer Hall of Uqba | building_wonder_age4_great_mosque_control_abb | 4 |

### abbasid_ha_01

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `abb_ha_01_age1` | dark_age | Barracks | building_unit_infantry_control_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Capital Town Center | building_town_center_capital_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Dock | building_unit_naval_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Farm | building_resource_farm_control_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | House | building_house_control_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Lumber Camp | building_econ_wood_control_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Mill | building_econ_food_control_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Mosque | building_unit_religious_control_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Outpost | building_defense_outpost_control_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Palisade | building_defense_palisade_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Stable | building_unit_cavalry_control_abb_ha_01 | 1 |
| `abb_ha_01_age1` | dark_age | Town Center | building_town_center_abb_ha_01 | 1 |
| `abb_ha_01_age2` | regular | Archery Range | building_unit_ranged_control_abb_ha_01 | 2 |
| `abb_ha_01_age2` | regular | Blacksmith | building_tech_unit_infantry_control_abb_ha_01 | 2 |
| `abb_ha_01_age2` | regular | Market | building_econ_market_control_abb_ha_01 | 2 |
| `abb_ha_01_age2` | regular | Stone Wall | building_defense_wall_abb_ha_01 | 2 |
| `abb_ha_01_age2` | regular | Stone Wall Gate | building_defense_wall_gate_abb_ha_01 | 2 |
| `abb_ha_01_age2` | regular | Stone Wall Tower | building_defense_tower_abb_ha_01 | 2 |
| `abb_ha_01_age2_wonders` | landmark | House of Wisdom | building_house_of_wisdom_control_abb_ha_01 | 1 |
| `abb_ha_01_age3` | regular | Keep | building_defense_keep_control_abb_ha_01 | 3 |
| `abb_ha_01_age3` | regular | Siege Workshop | building_unit_siege_control_abb_ha_01 | 3 |
| `abb_ha_01_age4` | regular | Madrasa | building_tech_university_control_abb_ha_01 | 4 |
| `abb_ha_01_age4` | wonder | Prayer Hall of Uqba | building_wonder_age4_great_mosque_control_abb_ha_01 | 4 |

### byzantine

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `byz_age1` | dark_age | Aqueduct | building_aqueduct_bastion_byz | 1 |
| `byz_age1` | dark_age | Barracks | building_unit_infantry_control_byz | 1 |
| `byz_age1` | dark_age | Capital Town Center | building_town_center_capital_byz | 1 |
| `byz_age1` | dark_age | Cistern | building_cistern_byz | 1 |
| `byz_age1` | dark_age | Dock | building_unit_naval_byz | 1 |
| `byz_age1` | dark_age | House | building_house_control_byz | 1 |
| `byz_age1` | dark_age | Lumber Camp | building_econ_wood_control_byz | 1 |
| `byz_age1` | dark_age | Mill | building_econ_food_control_byz | 1 |
| `byz_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_byz | 1 |
| `byz_age1` | dark_age | Olive Grove | building_resource_farm_byz | 1 |
| `byz_age1` | dark_age | Outpost | building_defense_outpost_byz | 1 |
| `byz_age1` | dark_age | Palisade | building_defense_palisade_byz | 1 |
| `byz_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_byz | 1 |
| `byz_age1` | dark_age | Stable | building_unit_cavalry_control_byz | 1 |
| `byz_age1` | dark_age | Town Center | building_town_center_byz | 1 |
| `byz_age1_wonders` | landmark | Grand Winery | building_landmark_age1_winery_byz | 1 |
| `byz_age1_wonders` | landmark | Imperial Hippodrome | building_landmark_age1_hippodrome_byz | 1 |
| `byz_age2` | regular | Archery Range | building_unit_ranged_control_byz | 2 |
| `byz_age2` | regular | Blacksmith | building_tech_unit_infantry_control_byz | 2 |
| `byz_age2` | regular | Market | building_econ_market_control_byz | 2 |
| `byz_age2` | regular | Mercenary House | building_unit_mercenary_house_byz | 2 |
| `byz_age2` | regular | Stone Wall | building_defense_wall_byz | 2 |
| `byz_age2` | regular | Stone Wall Gate | building_defense_wall_gate_byz | 2 |
| `byz_age2` | regular | Stone Wall Tower | building_defense_tower_byz | 2 |
| `byz_age2_wonders` | landmark | Cistern of the First Hill | building_landmark_age2_cistern_byz | 2 |
| `byz_age2_wonders` | landmark | Golden Horn Tower | building_landmark_age2_galata_tower_byz | 2 |
| `byz_age3` | regular | Keep | building_defense_keep_byz | 3 |
| `byz_age3` | regular | Monastery | building_unit_religious_control_byz | 3 |
| `byz_age3` | regular | Siege Workshop | building_unit_siege_control_byz | 3 |
| `byz_age3_wonders` | landmark | Foreign Engineering Company | building_landmark_age3_eastern_merc_house_byz | 3 |
| `byz_age3_wonders` | landmark | Palatine School | building_landmark_age3_western_merc_house_byz | 3 |
| `byz_age4` | wonder | Cathedral of Divine Wisdom | building_wonder_age4_hagia_sophia_byz | 4 |
| `byz_age4` | regular | University | building_tech_university_control_byz | 4 |

### byzantine_ha_mac

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `byz_ha_mac_age1` | dark_age | Capital Town Center | building_town_center_capital_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Dock | building_unit_naval_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Farm | building_resource_farm_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | House | building_house_control_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Lumber Camp | building_econ_wood_control_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Mill | building_econ_food_control_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Outpost | building_defense_outpost_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Palisade | building_defense_palisade_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Runestones | building_varangian_runestone_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Stable | building_unit_cavalry_control_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Town Center | building_town_center_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Varangian Stronghold | building_unit_passive_trait_byz_ha_mac | 1 |
| `byz_ha_mac_age1` | dark_age | Varangian Warcamp | building_unit_varangian_warcamp_byz_ha_mac | 1 |
| `byz_ha_mac_age1_wonders` | landmark | Grand Winery | building_landmark_age1_winery_byz_ha_mac | 1 |
| `byz_ha_mac_age1_wonders` | landmark | Imperial Hippodrome | building_landmark_age1_hippodrome_byz_ha_mac | 1 |
| `byz_ha_mac_age2` | regular | Archery Range | building_unit_ranged_control_byz_ha_mac | 2 |
| `byz_ha_mac_age2` | regular | Market | building_econ_market_control_byz_ha_mac | 2 |
| `byz_ha_mac_age2` | regular | Stone Wall | building_defense_wall_byz_ha_mac | 2 |
| `byz_ha_mac_age2` | regular | Stone Wall Gate | building_defense_wall_gate_byz_ha_mac | 2 |
| `byz_ha_mac_age2` | regular | Stone Wall Tower | building_defense_tower_byz_ha_mac | 2 |
| `byz_ha_mac_age2` | regular | Varangian Arsenal | building_tech_unit_varangian_byz_ha_mac | 2 |
| `byz_ha_mac_age2_wonders` | landmark | Cistern of the First Hill | building_landmark_age2_cistern_byz_ha_mac | 2 |
| `byz_ha_mac_age2_wonders` | landmark | Golden Horn Tower | building_landmark_age2_galata_tower_byz_ha_mac | 2 |
| `byz_ha_mac_age3` | regular | Keep | building_defense_keep_byz_ha_mac | 3 |
| `byz_ha_mac_age3` | regular | Monastery | building_unit_religious_control_byz_ha_mac | 3 |
| `byz_ha_mac_age3` | regular | Siege Workshop | building_unit_siege_control_byz_ha_mac | 3 |
| `byz_ha_mac_age3_wonders` | landmark | Foreign Engineering Company | building_landmark_age3_eastern_merc_house_byz_ha_mac | 3 |
| `byz_ha_mac_age3_wonders` | landmark | Palatine School | building_landmark_age3_western_merc_house_byz_ha_mac | 3 |
| `byz_ha_mac_age4` | wonder | Cathedral of Divine Wisdom | building_wonder_age4_hagia_sophia_byz_ha_mac | 4 |

### chinese

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `chi_age1` | dark_age | Barracks | building_unit_infantry_control_chi | 1 |
| `chi_age1` | dark_age | Capital Town Center | building_town_center_capital_chi | 1 |
| `chi_age1` | dark_age | Dock | building_unit_naval_chi | 1 |
| `chi_age1` | dark_age | Farm | building_resource_farm_chi | 1 |
| `chi_age1` | dark_age | Granary | building_dynasty_granary_control_chi | 1 |
| `chi_age1` | dark_age | House | building_house_control_chi | 1 |
| `chi_age1` | dark_age | Lumber Camp | building_econ_wood_control_chi | 1 |
| `chi_age1` | dark_age | Mill | building_econ_food_control_chi | 1 |
| `chi_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_chi | 1 |
| `chi_age1` | dark_age | Outpost | building_defense_outpost_chi | 1 |
| `chi_age1` | dark_age | Pagoda | building_dynasty_pagoda_control_chi | 1 |
| `chi_age1` | dark_age | Palisade | building_defense_palisade_chi | 1 |
| `chi_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_chi | 1 |
| `chi_age1` | dark_age | Stable | building_unit_cavalry_control_chi | 1 |
| `chi_age1` | dark_age | Town Center | building_town_center_chi | 1 |
| `chi_age1` | dark_age | Village | building_dynasty_village_control_chi | 1 |
| `chi_age1_wonders` | landmark | Barbican of the Sun | building_landmark_age1_gatehouse_control_chi | 1 |
| `chi_age1_wonders` | landmark | Imperial Academy | building_landmark_age1_academy_control_chi | 1 |
| `chi_age2` | regular | Archery Range | building_unit_ranged_control_chi | 2 |
| `chi_age2` | regular | Blacksmith | building_tech_unit_infantry_control_chi | 2 |
| `chi_age2` | regular | Market | building_econ_market_control_chi | 2 |
| `chi_age2` | regular | Stone Wall | building_defense_wall_chi | 2 |
| `chi_age2` | regular | Stone Wall Gate | building_defense_wall_gate_chi | 2 |
| `chi_age2` | regular | Stone Wall Tower | building_defense_tower_chi | 2 |
| `chi_age2_wonders` | landmark | Astronomical Clocktower | building_landmark_age2_clocktower_control_chi | 2 |
| `chi_age2_wonders` | landmark | Imperial Palace | building_landmark_age2_palace_control_chi | 2 |
| `chi_age3` | regular | Keep | building_defense_keep_chi | 3 |
| `chi_age3` | regular | Monastery | building_unit_religious_control_chi | 3 |
| `chi_age3` | regular | Siege Workshop | building_unit_siege_control_chi | 3 |
| `chi_age3_wonders` | landmark | Great Wall Gatehouse | building_landmark_age3_great_wall_control_chi | 3 |
| `chi_age3_wonders` | landmark | Spirit Way | building_landmark_age3_spirit_way_control_chi | 3 |
| `chi_age4` | wonder | Enclave of the Emperor | building_wonder_age4_forbidden_control_chi | 4 |
| `chi_age4` | regular | University | building_tech_university_control_chi | 4 |

### chinese_ha_01

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `chi_ha_01_age1` | dark_age | Barracks | building_unit_infantry_control_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Capital Town Center | building_town_center_capital_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Dock | building_unit_naval_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Farm | building_resource_farm_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Granary | building_dynasty_granary_control_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | House | building_house_control_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Lumber Camp | building_econ_wood_control_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Mill | building_econ_food_control_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Outpost | building_defense_outpost_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Pagoda | building_dynasty_pagoda_control_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Palisade | building_defense_palisade_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Stable | building_unit_cavalry_control_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Town Center | building_town_center_chi_ha_01 | 1 |
| `chi_ha_01_age1` | dark_age | Village | building_dynasty_village_control_chi_ha_01 | 1 |
| `chi_ha_01_age1_wonders` | landmark | Jiangnan Tower | building_landmark_age1_prefecture_chi_ha_01 | 1 |
| `chi_ha_01_age1_wonders` | landmark | Meditation Gardens | building_landmark_age1_meditation_gardens_control_chi_ha_01 | 1 |
| `chi_ha_01_age2` | regular | Archery Range | building_unit_ranged_control_chi_ha_01 | 2 |
| `chi_ha_01_age2` | regular | Blacksmith | building_tech_unit_infantry_control_chi_ha_01 | 2 |
| `chi_ha_01_age2` | regular | Market | building_econ_market_control_chi_ha_01 | 2 |
| `chi_ha_01_age2` | regular | Stone Wall | building_defense_wall_chi_ha_01 | 2 |
| `chi_ha_01_age2` | regular | Stone Wall Gate | building_defense_wall_gate_chi_ha_01 | 2 |
| `chi_ha_01_age2` | regular | Stone Wall Tower | building_defense_tower_chi_ha_01 | 2 |
| `chi_ha_01_age2_wonders` | landmark | Mount Lu Academy | building_landmark_age2_white_deer_grotto_control_chi_ha_01 | 2 |
| `chi_ha_01_age2_wonders` | landmark | Shaolin Monastery | building_landmark_age2_shaolin_temple_control_chi_ha_01 | 2 |
| `chi_ha_01_age3` | regular | Keep | building_defense_keep_chi_ha_01 | 3 |
| `chi_ha_01_age3` | regular | Monastery | building_unit_religious_control_chi_ha_01 | 3 |
| `chi_ha_01_age3` | regular | Siege Workshop | building_unit_siege_control_chi_ha_01 | 3 |
| `chi_ha_01_age3_wonders` | landmark | Temple of the Sun | building_landmark_age3_temple_of_the_sun_control_chi_ha_01 | 3 |
| `chi_ha_01_age3_wonders` | landmark | Zhu Xi's Library | building_landmark_age3_library_chi_ha_01 | 3 |
| `chi_ha_01_age4` | wonder | Enclave of the Emperor | building_wonder_age4_forbidden_control_chi_ha_01 | 4 |
| `chi_ha_01_age4` | regular | University | building_tech_university_control_chi_ha_01 | 4 |

### english

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `eng_age1` | dark_age | Barracks | building_unit_infantry_control_eng | 1 |
| `eng_age1` | dark_age | Capital Town Center | building_town_center_capital_eng | 1 |
| `eng_age1` | dark_age | Dock | building_unit_naval_eng | 1 |
| `eng_age1` | dark_age | Farm | building_resource_farm_eng | 1 |
| `eng_age1` | dark_age | House | building_house_control_eng | 1 |
| `eng_age1` | dark_age | Lumber Camp | building_econ_wood_control_eng | 1 |
| `eng_age1` | dark_age | Mill | building_econ_food_control_eng | 1 |
| `eng_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_eng | 1 |
| `eng_age1` | dark_age | Outpost | building_defense_outpost_eng | 1 |
| `eng_age1` | dark_age | Palisade | building_defense_palisade_eng | 1 |
| `eng_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_eng | 1 |
| `eng_age1` | dark_age | Stable | building_unit_cavalry_control_eng | 1 |
| `eng_age1` | dark_age | Town Center | building_town_center_eng | 1 |
| `eng_age1_wonders` | landmark | Abbey of Kings | building_landmark_age1_westminster_abbey_eng | 1 |
| `eng_age1_wonders` | landmark | Council Hall | building_landmark_age1_westminster_hall_eng | 1 |
| `eng_age2` | regular | Archery Range | building_unit_ranged_control_eng | 2 |
| `eng_age2` | regular | Blacksmith | building_tech_unit_infantry_control_eng | 2 |
| `eng_age2` | regular | Market | building_econ_market_control_eng | 2 |
| `eng_age2` | regular | Stone Wall | building_defense_wall_eng | 2 |
| `eng_age2` | regular | Stone Wall Gate | building_defense_wall_gate_eng | 2 |
| `eng_age2` | regular | Stone Wall Tower | building_defense_tower_eng | 2 |
| `eng_age2_wonders` | landmark | King's Palace | building_landmark_age2_westminster_palace_eng | 2 |
| `eng_age2_wonders` | landmark | The White Tower | building_landmark_age2_white_tower_eng | 2 |
| `eng_age3` | regular | Keep | building_defense_keep_eng | 3 |
| `eng_age3` | regular | Monastery | building_unit_religious_control_eng | 3 |
| `eng_age3` | regular | Siege Workshop | building_unit_siege_control_eng | 3 |
| `eng_age3_wonders` | landmark | Berkshire Palace | building_landmark_age3_windsor_castle_eng | 3 |
| `eng_age3_wonders` | landmark | Wynguard Palace | building_landmark_age3_whitehall_palace_eng | 3 |
| `eng_age4` | wonder | Cathedral of St. Thomas | building_wonder_age4_canterbury_cathedral_eng | 4 |
| `eng_age4` | regular | University | building_tech_university_control_eng | 4 |

### french

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `fre_age1` | dark_age | Barracks | building_unit_infantry_control_fre | 1 |
| `fre_age1` | dark_age | Capital Town Center | building_town_center_capital_fre | 1 |
| `fre_age1` | dark_age | Dock | building_unit_naval_fre | 1 |
| `fre_age1` | dark_age | Farm | building_resource_farm_fre | 1 |
| `fre_age1` | dark_age | House | building_house_control_fre | 1 |
| `fre_age1` | dark_age | Lumber Camp | building_econ_wood_control_fre | 1 |
| `fre_age1` | dark_age | Mill | building_econ_food_control_fre | 1 |
| `fre_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_fre | 1 |
| `fre_age1` | dark_age | Outpost | building_defense_outpost_fre | 1 |
| `fre_age1` | dark_age | Palisade | building_defense_palisade_fre | 1 |
| `fre_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_fre | 1 |
| `fre_age1` | dark_age | Stable | building_unit_cavalry_control_fre | 1 |
| `fre_age1` | dark_age | Town Center | building_town_center_fre | 1 |
| `fre_age1_wonders` | landmark | Chamber of Commerce | building_landmark_age1_chamber_of_commerce_fre | 1 |
| `fre_age1_wonders` | landmark | School of Cavalry | building_landmark_age1_casernes_centrales_fre | 1 |
| `fre_age2` | regular | Archery Range | building_unit_ranged_control_fre | 2 |
| `fre_age2` | regular | Blacksmith | building_tech_unit_infantry_control_fre | 2 |
| `fre_age2` | regular | Market | building_econ_market_control_fre | 2 |
| `fre_age2` | regular | Stone Wall | building_defense_wall_fre | 2 |
| `fre_age2` | regular | Stone Wall Gate | building_defense_wall_gate_fre | 2 |
| `fre_age2` | regular | Stone Wall Tower | building_defense_tower_fre | 2 |
| `fre_age2_wonders` | landmark | Guild Hall | building_landmark_age2_guild_hall_fre | 2 |
| `fre_age2_wonders` | landmark | Royal Institute | building_landmark_age3_le_grande_university_fre | 2 |
| `fre_age3` | regular | Keep | building_defense_keep_fre | 3 |
| `fre_age3` | regular | Monastery | building_unit_religious_control_fre | 3 |
| `fre_age3` | regular | Siege Workshop | building_unit_siege_control_fre | 3 |
| `fre_age3_wonders` | landmark | College of Artillery | building_landmark_age3_ecole_de_poudre_a_canon_fre | 3 |
| `fre_age3_wonders` | landmark | Red Palace | building_landmark_age2_la_chateau_rouge_fre | 3 |
| `fre_age4` | wonder | Notre Dame | building_wonder_age4_la_grande_cathedral_fre | 4 |
| `fre_age4` | regular | University | building_tech_university_control_fre | 4 |

### french_ha_01

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `fre_ha_01_age1` | dark_age | Barracks | building_unit_infantry_control_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Capital Town Center | building_town_center_capital_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Dock | building_unit_naval_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Farm | building_resource_farm_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | House | building_house_control_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Lumber Camp | building_econ_wood_control_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Mill | building_econ_food_control_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Outpost | building_defense_outpost_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Palisade | building_defense_palisade_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Stable | building_unit_cavalry_control_fre_ha_01 | 1 |
| `fre_ha_01_age1` | dark_age | Town Center | building_town_center_fre_ha_01 | 1 |
| `fre_ha_01_age1_wonders` | landmark | Chamber of Commerce | building_landmark_age1_chamber_of_commerce_fre_ha_01 | 1 |
| `fre_ha_01_age1_wonders` | landmark | School of Cavalry | building_landmark_age1_casernes_centrales_fre_ha_01 | 1 |
| `fre_ha_01_age2` | regular | Archery Range | building_unit_ranged_control_fre_ha_01 | 2 |
| `fre_ha_01_age2` | regular | Blacksmith | building_tech_unit_infantry_control_fre_ha_01 | 2 |
| `fre_ha_01_age2` | regular | Market | building_econ_market_control_fre_ha_01 | 2 |
| `fre_ha_01_age2` | regular | Stone Wall | building_defense_wall_fre_ha_01 | 2 |
| `fre_ha_01_age2` | regular | Stone Wall Gate | building_defense_wall_gate_fre_ha_01 | 2 |
| `fre_ha_01_age2` | regular | Stone Wall Tower | building_defense_tower_fre_ha_01 | 2 |
| `fre_ha_01_age2_wonders` | landmark | Guild Hall | building_landmark_age2_guild_hall_fre_ha_01 | 2 |
| `fre_ha_01_age2_wonders` | landmark | Royal Institute | building_landmark_age3_le_grande_university_fre_ha_01 | 2 |
| `fre_ha_01_age3` | regular | Keep | building_defense_keep_fre_ha_01 | 3 |
| `fre_ha_01_age3` | regular | Monastery | building_unit_religious_control_fre_ha_01 | 3 |
| `fre_ha_01_age3` | regular | Siege Workshop | building_unit_siege_control_fre_ha_01 | 3 |
| `fre_ha_01_age3_wonders` | landmark | College of Artillery | building_landmark_age3_ecole_de_poudre_a_canon_fre_ha_01 | 3 |
| `fre_ha_01_age3_wonders` | landmark | Red Palace | building_landmark_age2_la_chateau_rouge_fre_ha_01 | 3 |
| `fre_ha_01_age4` | wonder | Notre Dame | building_wonder_age4_la_grande_cathedral_fre_ha_01 | 4 |
| `fre_ha_01_age4` | regular | University | building_tech_university_control_fre_ha_01 | 4 |

### hre

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `hre_age1` | dark_age | Barracks | building_unit_infantry_control_hre | 1 |
| `hre_age1` | dark_age | Capital Town Center | building_town_center_capital_hre | 1 |
| `hre_age1` | dark_age | Dock | building_unit_naval_hre | 1 |
| `hre_age1` | dark_age | Farm | building_resource_farm_hre | 1 |
| `hre_age1` | dark_age | House | building_house_control_hre | 1 |
| `hre_age1` | dark_age | Lumber Camp | building_econ_wood_control_hre | 1 |
| `hre_age1` | dark_age | Mill | building_econ_food_control_hre | 1 |
| `hre_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_hre | 1 |
| `hre_age1` | dark_age | Outpost | building_defense_outpost_hre | 1 |
| `hre_age1` | dark_age | Palisade | building_defense_palisade_hre | 1 |
| `hre_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_hre | 1 |
| `hre_age1` | dark_age | Stable | building_unit_cavalry_control_hre | 1 |
| `hre_age1` | dark_age | Town Center | building_town_center_hre | 1 |
| `hre_age1_wonders` | landmark | Aachen Chapel | building_landmark_age1_palantine_chapel_hre | 1 |
| `hre_age1_wonders` | landmark | Meinwerk Palace | building_landmark_age1_imperial_palace_of_paderborn_hre | 1 |
| `hre_age2` | regular | Archery Range | building_unit_ranged_control_hre | 2 |
| `hre_age2` | regular | Blacksmith | building_tech_unit_infantry_control_hre | 2 |
| `hre_age2` | regular | Market | building_econ_market_control_hre | 2 |
| `hre_age2` | regular | Stone Wall | building_defense_wall_hre | 2 |
| `hre_age2` | regular | Stone Wall Gate | building_defense_wall_gate_hre | 2 |
| `hre_age2` | regular | Stone Wall Tower | building_defense_tower_hre | 2 |
| `hre_age2_wonders` | landmark | Burgrave Palace | building_landmark_age2_nuremberg_castle_hre | 2 |
| `hre_age2_wonders` | landmark | Regnitz Cathedral | building_landmark_age2_bamberg_cathedral_hre | 2 |
| `hre_age3` | regular | Keep | building_defense_keep_hre | 3 |
| `hre_age3` | regular | Monastery | building_unit_religious_control_hre | 3 |
| `hre_age3` | regular | Siege Workshop | building_unit_siege_control_hre | 3 |
| `hre_age3_wonders` | landmark | Elzbach Palace | building_landmark_age3_eltz_castle_hre | 3 |
| `hre_age3_wonders` | landmark | Palace of Swabia | building_landmark_age3_hohenzollern_castle_hre | 3 |
| `hre_age4` | wonder | Great Palace of Flensburg | building_wonder_age4_glucksburg_castle_hre | 4 |
| `hre_age4` | regular | University | building_tech_university_control_hre | 4 |

### hre_ha_01

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `hre_ha_01_age1` | dark_age | Barracks | building_unit_infantry_control_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Capital Town Center | building_town_center_capital_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Dock | building_unit_naval_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Farm | building_resource_farm_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | House | building_house_control_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Lumber Camp | building_econ_wood_control_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Mill | building_econ_food_control_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Outpost | building_defense_outpost_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Palisade | building_defense_palisade_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Stable | building_unit_cavalry_control_hre_ha_01 | 1 |
| `hre_ha_01_age1` | dark_age | Town Center | building_town_center_hre_ha_01 | 1 |
| `hre_ha_01_age1_wonders` | landmark | Aachen Chapel | building_landmark_age1_palantine_chapel_hre_ha_01 | 1 |
| `hre_ha_01_age1_wonders` | landmark | Meinwerk Palace | building_landmark_age1_imperial_palace_of_paderborn_hre_ha_01 | 1 |
| `hre_ha_01_age2` | regular | Archery Range | building_unit_ranged_control_hre_ha_01 | 2 |
| `hre_ha_01_age2` | regular | Blacksmith | building_tech_unit_infantry_control_hre_ha_01 | 2 |
| `hre_ha_01_age2` | regular | Market | building_econ_market_control_hre_ha_01 | 2 |
| `hre_ha_01_age2` | regular | Stone Wall | building_defense_wall_hre_ha_01 | 2 |
| `hre_ha_01_age2` | regular | Stone Wall Gate | building_defense_wall_gate_hre_ha_01 | 2 |
| `hre_ha_01_age2` | regular | Stone Wall Tower | building_defense_tower_hre_ha_01 | 2 |
| `hre_ha_01_age2_wonders` | landmark | Burgrave Palace | building_landmark_age2_nuremberg_castle_hre_ha_01 | 2 |
| `hre_ha_01_age2_wonders` | landmark | Regnitz Cathedral | building_landmark_age2_bamberg_cathedral_hre_ha_01 | 2 |
| `hre_ha_01_age3` | regular | Keep | building_defense_keep_hre_ha_01 | 3 |
| `hre_ha_01_age3` | regular | Monastery | building_unit_religious_control_hre_ha_01 | 3 |
| `hre_ha_01_age3` | regular | Siege Workshop | building_unit_siege_control_hre_ha_01 | 3 |
| `hre_ha_01_age3_wonders` | landmark | Elzbach Palace | building_landmark_age3_eltz_castle_hre_ha_01 | 3 |
| `hre_ha_01_age3_wonders` | landmark | Palace of Swabia | building_landmark_age3_hohenzollern_castle_hre_ha_01 | 3 |
| `hre_ha_01_age4` | wonder | Great Palace of Flensburg | building_wonder_age4_glucksburg_castle_hre_ha_01 | 4 |
| `hre_ha_01_age4` | regular | University | building_tech_university_control_hre_ha_01 | 4 |

### japanese

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `jpn_age1` | dark_age | Barracks | building_unit_infantry_jpn | 1 |
| `jpn_age1` | dark_age | Capital Town Center | building_town_center_capital_jpn | 1 |
| `jpn_age1` | dark_age | Dock | building_unit_naval_jpn | 1 |
| `jpn_age1` | dark_age | Farm | building_resource_farm_jpn | 1 |
| `jpn_age1` | dark_age | Farmhouse | building_house_jpn | 1 |
| `jpn_age1` | dark_age | Forge | building_econ_mining_camp_jpn | 1 |
| `jpn_age1` | dark_age | Lumber Camp | building_econ_wood_jpn | 1 |
| `jpn_age1` | dark_age | Outpost | building_defense_outpost_jpn | 1 |
| `jpn_age1` | dark_age | Palisade | building_defense_palisade_jpn | 1 |
| `jpn_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_jpn | 1 |
| `jpn_age1` | dark_age | Stable | building_unit_cavalry_jpn | 1 |
| `jpn_age1` | dark_age | Town Center | building_town_center_jpn | 1 |
| `jpn_age1_wonders` | landmark | Koka Township | building_landmark_age1_shinobi_jpn | 1 |
| `jpn_age1_wonders` | landmark | Kura Storehouse | building_landmark_age1_storehouse_jpn | 1 |
| `jpn_age2` | regular | Archery Range | building_unit_ranged_jpn | 2 |
| `jpn_age2` | regular | Market | building_econ_market_jpn | 2 |
| `jpn_age2` | regular | Stone Wall | building_defense_wall_jpn | 2 |
| `jpn_age2` | regular | Stone Wall Gate | building_defense_wall_gate_jpn | 2 |
| `jpn_age2` | regular | Stone Wall Tower | building_defense_tower_jpn | 2 |
| `jpn_age2_wonders` | landmark | Floating Gate | building_landmark_age2_shinto_jpn | 2 |
| `jpn_age2_wonders` | landmark | Temple of Equality | building_landmark_age2_buddhist_jpn | 2 |
| `jpn_age3` | regular | Buddhist Temple | building_unit_religious_buddhist_jpn | 3 |
| `jpn_age3` | regular | Shinto Shrine | building_unit_religious_shinto_jpn | 3 |
| `jpn_age3` | regular | Siege Workshop | building_unit_siege_jpn | 3 |
| `jpn_age3_wonders` | landmark | Castle of the Crow | building_landmark_age3_treasure_jpn | 3 |
| `jpn_age3_wonders` | landmark | Tanegashima Gunsmith | building_landmark_age3_ozutsu_jpn | 3 |
| `jpn_age4` | regular | Castle | building_defense_keep_jpn | 4 |
| `jpn_age4` | wonder | Tokugawa Shrine | building_wonder_age4_nikko_toshogu_jpn | 4 |
| `jpn_age4` | regular | University | building_tech_university_jpn | 4 |

### japanese_ha_sen

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `jpn_ha_sen_age1` | dark_age | Barracks | building_unit_infantry_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Capital Town Center | building_town_center_capital_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Dock | building_unit_naval_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Farm | building_resource_farm_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Farmhouse | building_house_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Forge | building_econ_mining_camp_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Lumber Camp | building_econ_wood_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Matsuri | building_econ_matsuri_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Outpost | building_defense_outpost_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Palisade | building_defense_palisade_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Stable | building_unit_cavalry_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1` | dark_age | Town Center | building_town_center_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1_wonders` | landmark | Koka Township | building_landmark_age1_shinobi_jpn_ha_sen | 1 |
| `jpn_ha_sen_age1_wonders` | landmark | Ryokan | building_landmark_age1_ryokan_jpn_ha_sen | 1 |
| `jpn_ha_sen_age2` | regular | Archery Range | building_unit_ranged_jpn_ha_sen | 2 |
| `jpn_ha_sen_age2` | regular | Hojo Clan Daimyo Estate | building_unit_daimyo_estate_hojo_jpn_ha_sen | 2 |
| `jpn_ha_sen_age2` | regular | Oda Clan Daimyo Estate | building_unit_daimyo_estate_oda_jpn_ha_sen | 2 |
| `jpn_ha_sen_age2` | regular | Stone Wall | building_defense_wall_jpn_ha_sen | 2 |
| `jpn_ha_sen_age2` | regular | Stone Wall Gate | building_defense_wall_gate_jpn_ha_sen | 2 |
| `jpn_ha_sen_age2` | regular | Stone Wall Tower | building_defense_tower_jpn_ha_sen | 2 |
| `jpn_ha_sen_age2` | regular | Takeda Clan Daimyo Estate | building_unit_daimyo_estate_takeda_jpn_ha_sen | 2 |
| `jpn_ha_sen_age2_wonders` | landmark | Sake Brewery | building_landmark_age2_brewery_jpn_ha_sen | 2 |
| `jpn_ha_sen_age2_wonders` | landmark | Temple of Equality | building_landmark_age2_buddhist_jpn_ha_sen | 2 |
| `jpn_ha_sen_age3` | regular | Buddhist Temple | building_unit_religious_buddhist_jpn_ha_sen | 3 |
| `jpn_ha_sen_age3` | regular | Siege Workshop | building_unit_siege_jpn_ha_sen | 3 |
| `jpn_ha_sen_age3_wonders` | landmark | Castle of the Crow | building_landmark_age3_crow_jpn_ha_sen | 3 |
| `jpn_ha_sen_age3_wonders` | landmark | Sword Hunt Statue | building_landmark_age3_statue_jpn_ha_sen | 3 |
| `jpn_ha_sen_age4` | regular | Castle | building_defense_keep_crow_discount_jpn_ha_sen | 4 |
| `jpn_ha_sen_age4` | wonder | Tokugawa Shrine | building_wonder_age4_nikko_toshogu_jpn_ha_sen | 4 |
| `jpn_ha_sen_age4` | regular | University | building_tech_university_jpn_ha_sen | 4 |

### lancaster

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `lan_age1` | dark_age | Barracks | building_unit_barracks_lan | 1 |
| `lan_age1` | dark_age | Capital Town Center | building_town_center_capital_lan | 1 |
| `lan_age1` | dark_age | Dock | building_unit_dock_lan | 1 |
| `lan_age1` | dark_age | Farm | building_resource_farm_lan | 1 |
| `lan_age1` | dark_age | House | building_house_lan | 1 |
| `lan_age1` | dark_age | Lumber Camp | building_econ_wood_lan | 1 |
| `lan_age1` | dark_age | Mill | building_econ_mill_lan | 1 |
| `lan_age1` | dark_age | Mining Camp | building_econ_mining_camp_lan | 1 |
| `lan_age1` | dark_age | Outpost | building_defense_outpost_lan | 1 |
| `lan_age1` | dark_age | Palisade | building_defense_palisade_lan | 1 |
| `lan_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_lan | 1 |
| `lan_age1` | dark_age | Stable | building_unit_stable_lan | 1 |
| `lan_age1` | dark_age | Town Center | building_town_center_lan | 1 |
| `lan_age1_wonders` | landmark | Abbey of Kings | building_landmark_age1_abbey_lan | 1 |
| `lan_age1_wonders` | landmark | Lancaster Castle | building_landmark_age1_lancastercastle_lan | 1 |
| `lan_age2` | regular | Archery Range | building_unit_range_lan | 2 |
| `lan_age2` | regular | Blacksmith | building_tech_blacksmith_lan | 2 |
| `lan_age2` | regular | Manor | building_manor_lan | 2 |
| `lan_age2` | regular | Market | building_econ_market_lan | 2 |
| `lan_age2` | regular | Stone Wall | building_defense_wall_lan | 2 |
| `lan_age2` | regular | Stone Wall Gate | building_defense_wall_gate_lan | 2 |
| `lan_age2` | regular | Stone Wall Tower | building_defense_tower_lan | 2 |
| `lan_age2_wonders` | landmark | King's College | building_landmark_age2_kingscollege_lan | 2 |
| `lan_age2_wonders` | landmark | The White Tower | building_landmark_age2_white_tower_lan | 2 |
| `lan_age3` | regular | Keep | building_defense_keep_lan | 3 |
| `lan_age3` | regular | Monastery | building_unit_monastery_lan | 3 |
| `lan_age3` | regular | Siege Workshop | building_unit_siege_workshop_lan | 3 |
| `lan_age3_wonders` | landmark | Berkshire Palace | building_landmark_age3_berkshire_lan | 3 |
| `lan_age3_wonders` | landmark | Wynguard Palace | building_landmark_age3_wynguard_lan | 3 |
| `lan_age4` | wonder | Cathedral of St. Thomas | building_wonder_age4_lan | 4 |
| `lan_age4` | regular | University | building_tech_university_lan | 4 |

### malian

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `mal_age1` | dark_age | Barracks | building_unit_infantry_mal | 1 |
| `mal_age1` | dark_age | Capital Town Center | building_town_center_capital_mal | 1 |
| `mal_age1` | dark_age | Dock | building_unit_naval_mal | 1 |
| `mal_age1` | dark_age | Farm | building_resource_farm_mal | 1 |
| `mal_age1` | dark_age | House | building_house_mal | 1 |
| `mal_age1` | dark_age | Lumber Camp | building_econ_wood_mal | 1 |
| `mal_age1` | dark_age | Mill | building_econ_food_mal | 1 |
| `mal_age1` | dark_age | Mining Camp | building_econ_mining_camp_mal | 1 |
| `mal_age1` | dark_age | Mosque | building_unit_religious_mal | 1 |
| `mal_age1` | dark_age | Palisade | building_defense_palisade_mal | 1 |
| `mal_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_mal | 1 |
| `mal_age1` | dark_age | Pit Mine | building_open_pit_mine_small_mal | 1 |
| `mal_age1` | dark_age | Stable | building_unit_cavalry_mal | 1 |
| `mal_age1` | dark_age | Toll Outpost | building_defense_outpost_mal | 1 |
| `mal_age1` | dark_age | Town Center | building_town_center_mal | 1 |
| `mal_age1_wonders` | landmark | Mansa Quarry | building_landmark_age1_landmarkb_mal | 1 |
| `mal_age1_wonders` | landmark | Saharan Trade Network | building_landmark_age1_landmarka_mal | 1 |
| `mal_age2` | regular | Archery Range | building_unit_ranged_mal | 2 |
| `mal_age2` | regular | Blacksmith | building_tech_unit_infantry_mal | 2 |
| `mal_age2` | regular | Cattle Ranch | building_econ_ranch_mal | 2 |
| `mal_age2` | regular | Market | building_econ_market_mal | 2 |
| `mal_age2` | regular | Stone Wall | building_defense_wall_mal | 2 |
| `mal_age2` | regular | Stone Wall Gate | building_defense_wall_gate_mal | 2 |
| `mal_age2` | regular | Stone Wall Tower | building_defense_tower_mal | 2 |
| `mal_age2_wonders` | landmark | Farimba Garrison | building_landmark_age2_landmarkd_control_mal | 2 |
| `mal_age2_wonders` | landmark | Grand Fulani Corral | building_landmark_age2_landmarkc_control_mal | 2 |
| `mal_age3` | regular | Keep | building_defense_keep_mal | 3 |
| `mal_age3` | regular | Siege Workshop | building_unit_siege_mal | 3 |
| `mal_age3_wonders` | landmark | Fort of the Huntress | building_landmark_age3_landmarkf_mal | 3 |
| `mal_age3_wonders` | landmark | Griot Bara | building_landmark_age3_landmarke_mal | 3 |
| `mal_age4` | wonder | Great Mosque | building_wonder_age4_great_mosque_control_mal | 4 |
| `mal_age4` | regular | Madrasa | building_tech_university_mal | 4 |

### mongol

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `mon_age1` | dark_age | Barracks | building_unit_infantry_mon | 1 |
| `mon_age1` | dark_age | Capital Town Center | building_town_center_capital_mon | 1 |
| `mon_age1` | dark_age | Dock | building_unit_naval_mon | 1 |
| `mon_age1` | dark_age | Ger | building_house_mon | 1 |
| `mon_age1` | dark_age | Outpost | building_defense_outpost_mon | 1 |
| `mon_age1` | dark_age | Ovoo | building_stone_deposit_ovoo_mon | 1 |
| `mon_age1` | dark_age | Pasture | building_pasture_mon | 1 |
| `mon_age1` | dark_age | Stable | building_unit_cavalry_mon | 1 |
| `mon_age1` | dark_age | Town Center | building_town_center_mon | 1 |
| `mon_age1_wonders` | landmark | Deer Stones | building_wonder_age1_deer_stones_mon | 1 |
| `mon_age1_wonders` | landmark | The Silver Tree | building_wonder_age2_karakorum_mon | 1 |
| `mon_age2` | regular | Archery Range | building_unit_ranged_mon | 2 |
| `mon_age2` | regular | Blacksmith | building_tech_unit_infantry_mon | 2 |
| `mon_age2` | regular | Market | building_econ_market_mon | 2 |
| `mon_age2_wonders` | landmark | Kurultai | building_wonder_age1_kurultai_mon | 2 |
| `mon_age2_wonders` | landmark | Steppe Redoubt | building_wonder_age2_khara_khoto_mon | 2 |
| `mon_age3` | regular | Prayer Tent | building_unit_religious_mon | 3 |
| `mon_age3` | regular | Siege Workshop | building_unit_siege_mon | 3 |
| `mon_age3_wonders` | landmark | Khaganate Palace | building_wonder_age3_khanbaliq_mon | 3 |
| `mon_age3_wonders` | landmark | The White Stupa | building_wonder_age3_stupa_mon | 3 |
| `mon_age4` | wonder | Monument of the Great Khan | building_wonder_age4_final_wonder_mon | 4 |

### mongol_ha_gol

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `mon_ha_gol_age1` | dark_age | Barracks | building_unit_infantry_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Capital Town Center | building_town_center_capital_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Dock | building_unit_naval_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Fortified Outpost | building_fortified_outpost_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Ger | building_house_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Ovoo | building_stone_deposit_ovoo_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Palisade | building_defense_palisade_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Relic Ovoo | building_relic_ovoo_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Stable | building_unit_cavalry_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Stockyard | building_resource_pasture_mon_ha_gol | 1 |
| `mon_ha_gol_age1` | dark_age | Town Center | building_town_center_mon_ha_gol | 1 |
| `mon_ha_gol_age1_wonders` | landmark | Golden Tent | building_landmark_golden_tent_mon_ha_gol | 1 |
| `mon_ha_gol_age2` | regular | Archery Range | building_unit_ranged_mon_ha_gol | 2 |
| `mon_ha_gol_age2` | regular | Blacksmith | building_tech_unit_infantry_mon_ha_gol | 2 |
| `mon_ha_gol_age2` | regular | Market | building_econ_market_mon_ha_gol | 2 |
| `mon_ha_gol_age3` | regular | Prayer Tent | building_unit_religious_mon_ha_gol | 3 |
| `mon_ha_gol_age3` | regular | Siege Workshop | building_unit_siege_mon_ha_gol | 3 |
| `mon_ha_gol_age4` | wonder | Monument of the Great Khan | building_wonder_age4_final_wonder_mon_ha_gol | 4 |

### ottoman

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `ott_age1` | dark_age | Barracks | building_unit_infantry_ott | 1 |
| `ott_age1` | dark_age | Capital Town Center | building_town_center_capital_ott | 1 |
| `ott_age1` | dark_age | Dock | building_unit_naval_ott | 1 |
| `ott_age1` | dark_age | Farm | building_resource_farm_ott | 1 |
| `ott_age1` | dark_age | House | building_house_ott | 1 |
| `ott_age1` | dark_age | Lumber Camp | building_econ_wood_ott | 1 |
| `ott_age1` | dark_age | Military School | building_military_school_ott | 1 |
| `ott_age1` | dark_age | Mill | building_econ_food_ott | 1 |
| `ott_age1` | dark_age | Mining Camp | building_econ_mining_camp_ott | 1 |
| `ott_age1` | dark_age | Mosque | building_unit_religious_ott | 1 |
| `ott_age1` | dark_age | Outpost | building_defense_outpost_ott | 1 |
| `ott_age1` | dark_age | Palisade | building_defense_palisade_ott | 1 |
| `ott_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_ott | 1 |
| `ott_age1` | dark_age | Stable | building_unit_cavalry_ott | 1 |
| `ott_age1` | dark_age | Town Center | building_town_center_ott | 1 |
| `ott_age1_wonders` | landmark | Sultanhani Trade Network | building_landmark_age1_han_caravanserai_ott | 1 |
| `ott_age1_wonders` | landmark | Twin Minaret Medrese | building_landmark_age1_cifte_minareli_medrese_ott | 1 |
| `ott_age2` | regular | Archery Range | building_unit_ranged_ott | 2 |
| `ott_age2` | regular | Blacksmith | building_tech_unit_infantry_ott | 2 |
| `ott_age2` | regular | Market | building_econ_market_ott | 2 |
| `ott_age2` | regular | Stone Wall | building_defense_wall_ott | 2 |
| `ott_age2` | regular | Stone Wall Gate | building_defense_wall_gate_ott | 2 |
| `ott_age2` | regular | Stone Wall Tower | building_defense_tower_ott | 2 |
| `ott_age2_wonders` | landmark | Istanbul Imperial Palace | building_landmark_age2_topkapi_palace_ott | 2 |
| `ott_age2_wonders` | landmark | Mehmed Imperial Armory | building_landmark_age2_tophane_armory_ott | 2 |
| `ott_age3` | regular | Keep | building_defense_keep_ott | 3 |
| `ott_age3` | regular | Siege Workshop | building_unit_siege_ott | 3 |
| `ott_age3_wonders` | landmark | Istanbul Observatory | building_landmark_age3_istanbul_observatory_ott | 3 |
| `ott_age3_wonders` | landmark | Sea Gate Castle | building_landmark_age3_kilitbahir_castle_ott | 3 |
| `ott_age4` | wonder | Azure Mosque | building_wonder_age4_blue_mosque_ott | 4 |
| `ott_age4` | regular | University | building_tech_university_ott | 4 |

### rus

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `rus_age1` | dark_age | Barracks | building_unit_infantry_control_rus | 1 |
| `rus_age1` | dark_age | Capital Town Center | building_town_center_capital_rus | 1 |
| `rus_age1` | dark_age | Dock | building_unit_naval_rus | 1 |
| `rus_age1` | dark_age | Farm | building_resource_farm_control_rus | 1 |
| `rus_age1` | dark_age | Fortified Palisade Gate | building_defense_palisade_gate_rus | 1 |
| `rus_age1` | dark_age | Fortified Palisade Wall | building_defense_palisade_rus | 1 |
| `rus_age1` | dark_age | House | building_house_control_rus | 1 |
| `rus_age1` | dark_age | Hunting Cabin | building_hunting_cabin_rus | 1 |
| `rus_age1` | dark_age | Lumber Camp | building_econ_wood_control_rus | 1 |
| `rus_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_rus | 1 |
| `rus_age1` | dark_age | Stable | building_unit_cavalry_control_rus | 1 |
| `rus_age1` | dark_age | Town Center | building_town_center_rus | 1 |
| `rus_age1` | dark_age | Wooden Fortress | building_defense_wooden_fort_rus | 1 |
| `rus_age1_wonders` | landmark | Kremlin | building_landmark_age1_novgorod_kremlin_control_rus | 1 |
| `rus_age1_wonders` | landmark | The Golden Gate | building_landmark_age1_golden_gate_vladimir_control_rus | 1 |
| `rus_age2` | regular | Archery Range | building_unit_ranged_control_rus | 2 |
| `rus_age2` | regular | Blacksmith | building_tech_unit_infantry_control_rus | 2 |
| `rus_age2` | regular | Market | building_econ_market_control_rus | 2 |
| `rus_age2` | regular | Stone Wall | building_defense_wall_rus | 2 |
| `rus_age2` | regular | Stone Wall Gate | building_defense_wall_gate_rus | 2 |
| `rus_age2` | regular | Stone Wall Tower | building_defense_tower_rus | 2 |
| `rus_age2_wonders` | landmark | Abbey of the Trinity | building_landmark_age2_trinity_lavra_control_rus | 2 |
| `rus_age2_wonders` | landmark | High Trade House | building_landmark_age2_muscovy_trade_company_control_rus | 2 |
| `rus_age3` | regular | Keep | building_defense_keep_control_rus | 3 |
| `rus_age3` | regular | Monastery | building_unit_religious_control_rus | 3 |
| `rus_age3` | regular | Siege Workshop | building_unit_siege_control_rus | 3 |
| `rus_age3_wonders` | landmark | High Armory | building_landmark_age3_kremlin_armoury_rus | 3 |
| `rus_age3_wonders` | landmark | Spasskaya Tower | building_landmark_age3_spassakaya_tower_control_rus | 3 |
| `rus_age4` | wonder | Cathedral of the Tsar | building_wonder_age4_saint_basils_cathedral_control_rus | 4 |
| `rus_age4` | regular | University | building_tech_university_control_rus | 4 |

### sultanate

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `sul_age1` | dark_age | Barracks | building_unit_infantry_control_sul | 1 |
| `sul_age1` | dark_age | Capital Town Center | building_town_center_capital_sul | 1 |
| `sul_age1` | dark_age | Dock | building_unit_naval_sul | 1 |
| `sul_age1` | dark_age | Farm | building_resource_farm_control_sul | 1 |
| `sul_age1` | dark_age | House | building_house_control_sul | 1 |
| `sul_age1` | dark_age | Lumber Camp | building_econ_wood_control_sul | 1 |
| `sul_age1` | dark_age | Mill | building_econ_food_control_sul | 1 |
| `sul_age1` | dark_age | Mining Camp | building_econ_mining_camp_control_sul | 1 |
| `sul_age1` | dark_age | Mosque | building_unit_religious_control_sul | 1 |
| `sul_age1` | dark_age | Outpost | building_defense_outpost_control_sul | 1 |
| `sul_age1` | dark_age | Palisade | building_defense_palisade_sul | 1 |
| `sul_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_sul | 1 |
| `sul_age1` | dark_age | Stable | building_unit_cavalry_control_sul | 1 |
| `sul_age1` | dark_age | Town Center | building_town_center_sul | 1 |
| `sul_age1_wonders` | landmark | Dome of the Faith | building_landmark_age1_quwwat_ul_islam_control_sul | 1 |
| `sul_age1_wonders` | landmark | Tower of Victory | building_landmark_age1_qutub_minar_control_sul | 1 |
| `sul_age2` | regular | Archery Range | building_unit_ranged_control_sul | 2 |
| `sul_age2` | regular | Blacksmith | building_tech_unit_infantry_control_sul | 2 |
| `sul_age2` | regular | Market | building_econ_market_control_sul | 2 |
| `sul_age2` | regular | Stone Wall | building_defense_wall_sul | 2 |
| `sul_age2` | regular | Stone Wall Gate | building_defense_wall_gate_sul | 2 |
| `sul_age2` | regular | Stone Wall Tower | building_defense_tower_sul | 2 |
| `sul_age2_wonders` | landmark | Compound of the Defender | building_landmark_age2_siri_fort_control_sul | 2 |
| `sul_age2_wonders` | landmark | House of Learning | building_landmark_age2_khiji_mosque_control_sul | 2 |
| `sul_age3` | regular | Keep | building_defense_keep_control_sul | 3 |
| `sul_age3` | regular | Siege Workshop | building_unit_siege_control_sul | 3 |
| `sul_age3_wonders` | landmark | Hisar Academy | building_landmark_age3_madrasa_e_firoz_sul | 3 |
| `sul_age3_wonders` | landmark | Palace of the Sultan | building_landmark_age3_bijay_mandal_palace_control_sul | 3 |
| `sul_age4` | wonder | Great Palace of Agra | building_wonder_age4_agra_fort_control_sul | 4 |
| `sul_age4` | regular | Madrasa | building_tech_university_control_sul | 4 |

### sultanate_ha_tug

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `sul_ha_tug_age1` | dark_age | Barracks | building_unit_infantry_control_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | Capital Town Center | building_town_center_capital_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | Dock | building_unit_naval_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | Farm | building_resource_farm_control_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | House | building_house_control_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | Mosque | building_unit_religious_control_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | Outpost | building_defense_outpost_control_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | Palisade | building_defense_palisade_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | Stable | building_unit_cavalry_control_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | Town Center | building_town_center_sul_ha_tug | 1 |
| `sul_ha_tug_age1` | dark_age | Worker Elephant | building_dummy_worker_elephant_sul_ha_tug | 1 |
| `sul_ha_tug_age1_wonders` | landmark | Dome of the Faith | building_landmark_age1_quwwat_ul_islam_control_sul_ha_tug | 1 |
| `sul_ha_tug_age1_wonders` | landmark | Tower of Victory | building_landmark_age1_qutub_minar_control_sul_ha_tug | 1 |
| `sul_ha_tug_age2` | regular | Archery Range | building_unit_ranged_control_sul_ha_tug | 2 |
| `sul_ha_tug_age2` | regular | Blacksmith | building_tech_unit_infantry_control_sul_ha_tug | 2 |
| `sul_ha_tug_age2` | regular | Market | building_econ_market_control_sul_ha_tug | 2 |
| `sul_ha_tug_age2` | regular | Stone Wall | building_defense_wall_sul_ha_tug | 2 |
| `sul_ha_tug_age2` | regular | Stone Wall Gate | building_defense_wall_gate_sul_ha_tug | 2 |
| `sul_ha_tug_age2` | regular | Stone Wall Tower | building_defense_tower_sul_ha_tug | 2 |
| `sul_ha_tug_age2` | regular | Tughlaqabad Fort | building_defense_keep_control_sul_ha_tug | 2 |
| `sul_ha_tug_age2_wonders` | landmark | Compound of the Defender | building_landmark_age2_siri_fort_control_sul_ha_tug | 2 |
| `sul_ha_tug_age2_wonders` | landmark | House of Learning | building_landmark_age2_khiji_mosque_control_sul_ha_tug | 2 |
| `sul_ha_tug_age3` | regular | Siege Workshop | building_unit_siege_control_sul_ha_tug | 3 |
| `sul_ha_tug_age3_wonders` | landmark | Hisar Academy | building_landmark_age3_madrasa_e_firoz_sul_ha_tug | 3 |
| `sul_ha_tug_age3_wonders` | landmark | Palace of the Sultan | building_landmark_age3_bijay_mandal_palace_control_sul_ha_tug | 3 |
| `sul_ha_tug_age4` | wonder | Great Palace of Agra | building_wonder_age4_agra_fort_control_sul_ha_tug | 4 |
| `sul_ha_tug_age4` | regular | Madrasa | building_tech_university_control_sul_ha_tug | 4 |

### templar

| menu_group | type | building_name | attrib_name | age |
|---|---|---|---|---:|
| `tem_age1` | dark_age | Barracks | building_barracks_tem | 1 |
| `tem_age1` | dark_age | Capital Town Center | building_town_center_capital_tem | 1 |
| `tem_age1` | dark_age | Farm | building_resource_farm_tem | 1 |
| `tem_age1` | dark_age | Harbor | building_dock_tem | 1 |
| `tem_age1` | dark_age | House | building_house_control_tem | 1 |
| `tem_age1` | dark_age | Mill | building_mill_tem | 1 |
| `tem_age1` | dark_age | Mining Camp | building_mining_camp_tem | 1 |
| `tem_age1` | dark_age | Outpost | building_defense_outpost_tem | 1 |
| `tem_age1` | dark_age | Palisade | building_defense_palisade_wall_tem | 1 |
| `tem_age1` | dark_age | Palisade Gate | building_defense_palisade_gate_tem | 1 |
| `tem_age1` | dark_age | Stable | building_stable_tem | 1 |
| `tem_age1` | dark_age | Town Center | building_town_center_tem | 1 |
| `tem_age2` | regular | Archery Range | building_archery_range_tem | 2 |
| `tem_age2` | regular | Blacksmith | building_tech_blacksmith_tem | 2 |
| `tem_age2` | regular | Fortress | building_defense_fortress_tem | 2 |
| `tem_age2` | regular | Market | building_market_tem | 2 |
| `tem_age2` | regular | Stone Wall | building_defense_stone_wall_tem | 2 |
| `tem_age2` | regular | Stone Wall Gate | building_defense_stone_wall_gate_tem | 2 |
| `tem_age2` | regular | Stone Wall Tower | building_defense_stone_tower_tem | 2 |
| `tem_age3` | regular | Monastery | building_monastery_tem | 3 |
| `tem_age3` | regular | Siege Workshop | building_siege_workshop_tem | 3 |
| `tem_age4` | wonder | Notre Dame | building_wonder_tem | 4 |
| `tem_age4` | regular | University | building_tech_university_tem | 4 |

