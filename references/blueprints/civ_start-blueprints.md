# Civilization Start - Blueprints

> Auto-extracted from `Attributes dump.txt` for use in SCAR scripting.
> Use with `BP_GetSquadBlueprint()`, `BP_GetEntityBlueprint()`, `BP_GetUpgradeBlueprint()`

---

## Upgrade Blueprints (UPG)

| Blueprint Name | PBG ID |
|---|---|
| `UPGRADE_ADD_CHEER_ABILITY` | 412759 |
| `UPGRADE_ADD_PICKUP_RESOURCE_ABILITY` | 390786 |
| `UPGRADE_TRAIT_TOWER_OUTPOST_SIGHT_RANGE_INCREASED` | 475876 |
| `UPGRADE_TRAIT_UPGRADE_COSTS_ON_DROPOFFS` | 475530 |

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


