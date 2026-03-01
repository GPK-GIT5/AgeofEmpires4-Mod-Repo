# Gaia (Neutral Units) - Blueprints

> Auto-extracted from `Attributes dump.txt` for use in SCAR scripting.
> Use with `BP_GetSquadBlueprint()`, `BP_GetEntityBlueprint()`, `BP_GetUpgradeBlueprint()`

---

## Squad Blueprints (SBP) - Units

| Blueprint Name | PBG ID |
|---|---|
| `GAIA_HERDABLE_SHEEP` | 106855 |
| `GAIA_HERDABLE_SHEEP_CORPSE` | 167604 |
| `GAIA_HUNTABLE_BOAR` | 107473 |
| `GAIA_HUNTABLE_BOAR_CORPSE` | 167674 |
| `GAIA_HUNTABLE_DEER` | 106856 |
| `GAIA_HUNTABLE_DEER_CORPSE` | 167675 |
| `GAIA_HUNTABLE_PROTOTYPE_CROCODILE` | 107474 |
| `GAIA_HUNTABLE_WOLF` | 127481 |
| `GAIA_HUNTABLE_WOLF_CORPSE` | 169555 |

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


