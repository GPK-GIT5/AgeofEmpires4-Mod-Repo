# Neutral - Blueprints

> Auto-extracted from `Attributes dump.txt` for use in SCAR scripting.
> Use with `BP_GetSquadBlueprint()`, `BP_GetEntityBlueprint()`, `BP_GetUpgradeBlueprint()`

---

## Squad Blueprints (SBP) - Units

| Blueprint Name | PBG ID |
|---|---|
| `UNIT_ARCHER_2_NEU` | 136439 |
| `UNIT_ARCHER_3_NEU` | 136440 |
| `UNIT_ARCHER_4_NEU` | 136441 |
| `UNIT_KNIGHT_2_NEU` | 136446 |
| `UNIT_KNIGHT_3_NEU` | 136447 |
| `UNIT_KNIGHT_4_NEU` | 136448 |
| `UNIT_MANATARMS_1_NEU` | 136442 |
| `UNIT_MANATARMS_2_NEU` | 136443 |
| `UNIT_MANATARMS_3_NEU` | 136444 |
| `UNIT_MANATARMS_4_NEU` | 136445 |
| `UNIT_SPEARMAN_1_NEU` | 136431 |
| `UNIT_SPEARMAN_2_NEU` | 136433 |
| `UNIT_SPEARMAN_3_NEU` | 136435 |
| `UNIT_SPEARMAN_4_NEU` | 136437 |

## Entity Blueprints (EBP) - Buildings & Entities

| Blueprint Name | PBG ID |
|---|---|
| `BUILDING_DEFENSE_OUTPOST_NEU` | 169566 |
| `BUILDING_TRADE_POST_CORE` | 2026066 |
| `BUILDING_TRADE_POST_EAST` | 2026067 |
| `BUILDING_TRADE_POST_MID_EAST` | 2026068 |
| `BUILDING_TRADE_POST_WEST` | 2026069 |
| `BUILDING_TRADE_POST_WEST_TRIBUTE` | 2033045 |
| `NAVAL_TRADE_POST_EAST` | 2026070 |
| `NAVAL_TRADE_POST_MID_EAST` | 2026071 |
| `NAVAL_TRADE_POST_WEST` | 2026072 |

---

## SCAR Usage Examples

```lua
-- Get a squad blueprint by name
local sbp = BP_GetSquadBlueprint("unit_name_here")

-- Get an entity blueprint by name
local ebp = BP_GetEntityBlueprint("entity_name_here")

-- Get an upgrade blueprint by name
local ubp = BP_GetUpgradeBlueprint("upgrade_name_here")

-- Get a blueprint by PBG ID
local sbp = BP_GetSquadBlueprintByPbgID(167674)
local ebp = BP_GetEntityBlueprintByPbgID(107180)
```


