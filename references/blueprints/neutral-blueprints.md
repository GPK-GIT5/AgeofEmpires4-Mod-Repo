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


---

> Additional entries appended from XML dump (2026-04-02 04:11:52)

### Additional Building Entities (from XML dump)

| Blueprint Name | PBG ID | Source | Sub-Category |
|---|---|---|---|
| `BUILDING_TRADE_POST_FALL` | 1073744273 | neutral | seasonal |
| `BUILDING_TRADE_POST_HALLOWEEN` | 1073744274 | neutral | seasonal |
| `BUILDING_TRADE_POST_MID_EAST_CAMPAIGN` | 1073744270 | neutral | campaign |
| `BUILDING_TRADE_POST_WINTER` | 1073744275 | neutral | seasonal |
| `NAVAL_TRADE_POST_CYPRUS` | 1073744272 | neutral | campaign |
| `NAVAL_TRADE_POST_HALLOWEEN` | 1073744276 | neutral | seasonal |
| `NAVAL_TRADE_POST_WINTER` | 1073744277 | neutral | seasonal |

### Additional Unit Entities (from XML dump)

| Blueprint Name | PBG ID | Source | Sub-Category |
|---|---|---|---|
| `UNIT_PHOTON_MAN` | 1073742567 | cheat | standard |
| `UNIT_RONIN_NEU` | 1073744286 | neutral | standard |


