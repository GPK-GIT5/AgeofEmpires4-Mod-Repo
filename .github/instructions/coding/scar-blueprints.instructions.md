---
applyTo: "**/*.scar"
---

# SCAR Blueprint Resolution — AoE4

Blueprint lookup patterns for DLC-aware civilization entity/squad/upgrade resolution.

## AGS_ENTITY_TABLE

Central lookup table mapping `player_civ` → `bp_type` → attribName string. Defined in `ags_blueprints.scar`.

Each civilization has its own complete entry — **16 entries total**: 10 base civs (english, french, hre, chinese, russian, abbasid, mongol, sultanate, malian, ottoman) + 6 DLC variants (abbasid_ha_01, chinese_ha_01, french_ha_01, hre_ha_01, japanese, byzantine) + 1 neutral.

```lua
-- Structure
AGS_ENTITY_TABLE = {
    english = {
        castle = "building_defense_keep_eng",
        villager = "unit_villager_1_eng",
        barracks = "building_unit_infantry_control_eng",
        -- ... full set of bp_type keys
    },
    chinese_ha_01 = {
        castle = "building_defense_keep_chi",
        villager = "unit_villager_1_chi",
        -- ... Zhu Xi's Legacies uses own complete entry
    },
}
```

## Lookup Functions

Three functions wrap the table lookup with `BP_Get*Blueprint`:

```lua
-- Entity blueprint (EBP) — buildings, entities
AGS_GetCivilizationEntity(player_civ, bp_type)
-- → BP_GetEntityBlueprint(AGS_ENTITY_TABLE[player_civ][bp_type])

-- Squad blueprint (SBP) — units
AGS_GetCivilizationUnit(player_civ, bp_type)
-- → BP_GetSquadBlueprint(AGS_ENTITY_TABLE[player_civ][bp_type])

-- Upgrade blueprint (UBP) — technologies
AGS_GetCivilizationUpgrade(player_civ, bp_type)
-- → BP_GetUpgradeBlueprint(AGS_ENTITY_TABLE[player_civ][bp_type])
```

Returns nil if `player_civ` or `bp_type` key is missing.

## Common bp_type Keys

Used across most civilization entries:

| Key | Type | Example attribName |
|-----|------|--------------------|
| castle | Building | `building_defense_keep_eng` |
| town_center | Building | `building_town_center_eng` |
| town_center_capital | Building | `building_town_center_capital_eng` |
| market | Building | `building_econ_market_control_eng` |
| villager | Unit | `unit_villager_1_eng` |
| scout | Unit | `unit_scout_1_eng` |
| barracks | Building | `building_unit_infantry_control_eng` |
| stable | Building | `building_unit_cavalry_control_eng` |
| archery_range | Building | `building_unit_ranged_control_eng` |
| siege_workshop | Building | `building_unit_siege_control_eng` |
| house | Building | `building_house_control_eng` |
| monastery | Building | `building_unit_religious_control_eng` |
| monk | Unit | `unit_monk_3_eng` |
| scar_dock | Building | `building_unit_naval_eng` |

## Civ-Specific Branching

Civ-specific logic uses direct `player_civ` string comparison (no parent map):

```lua
if player_civ == "english" then
    -- English-specific path (Keep as workshop)
elseif player_civ == "chinese" then
    -- Chinese-specific path (Clocktower)
elseif player_civ == "french" then
    -- French-specific path (Ecole)
elseif player_civ == "french_ha_01" then
    -- Jeanne d'Arc uses different Ecole blueprint
elseif player_civ == "chinese_ha_01" then
    -- Zhu Xi uses different siege variants
end
```

## Landmark Exclusion

Use the universal type check — covers all 29+ landmarks across all civs automatically:

```lua
if Entity_IsEBPOfType(eid, "landmark") then
    return  -- skip landmarks in production counts
end
```

Do NOT enumerate landmark blueprints per-civ.

## Anti-Patterns

- Referencing `AGS_CIV_PARENT_MAP` — does not exist
- Using `branch_civ` — not a pattern in this codebase
- Hardcoding attribNames instead of using `AGS_ENTITY_TABLE` lookup
- Assuming DLC variants share parent civ entries — each has its own full entry
