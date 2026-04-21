---
name: "Gamemode Option"
description: "Scaffold a new CBA/Onslaught gamemode option following the verified cba_options.scar module pattern."
---

# Gamemode Option Template

Generate a new gamemode option module for the Onslaught/CBA tuning pack.

## Parameters

- **Option name**: PascalCase identifier (e.g., `BuildingLimit`, `SiegeLimit`, `VillagerSpawner`)
- **Setting key**: `AGS_GLOBAL_SETTINGS` field name (e.g., `MaximumProductionBuildings`)
- **Events**: Which game events trigger the option logic
- **Purpose**: What the option controls

## Instructions

1. Follow the module registration pattern from `cba_options.scar`:
   - Register: `Core_RegisterModule("ModuleName")`
   - Gate on setting: `if AGS_GLOBAL_SETTINGS.SettingKey ~= 0 then`
2. Register event handlers in `PresetFinalize()` using narrowest scope
3. For counter-based options (building limits, siege limits):
   - Initialize per-player counters in PLAYERS loop
   - Increment on Start/Complete events
   - Decrement on Cancel/Killed events
   - Recount after ownership transfer (`Entity_SetPlayerOwner` doesn't fire events)
4. For civ-specific branching:
   - Use direct `player_civ ==` comparison
   - Each DLC variant gets explicit check if behavior differs
   - Use `AGS_CIV_PARENT_MAP[player_civ] or player_civ` (`branch_civ`) for Dynasties DLC variant fallback (6 civs)
   - Knights DLC variants (chinese_ha_01, etc.) have their own full table entries — do NOT use parent map for these
5. Exclude landmarks from production counts: `Entity_IsEBPOfType(eid, "landmark")`
6. Use `AGS_GetCivilizationEntity(player_civ, bp_type)` for blueprint lookups

## Template

```lua
-----------------------------------------------------------------------
-- {{OptionName}} Module
-----------------------------------------------------------------------
{{OPTION_MODULE}} = "CBA_Options_{{OptionName}}"
Core_RegisterModule({{OPTION_MODULE}})

function CBA_Options_{{OptionName}}_UpdateModuleSettings()
	AGS_Print("CBA_Options_{{OptionName}}_UpdateModuleSettings")
end

function CBA_Options_{{OptionName}}_PresetFinalize()
	AGS_Print("CBA_Options_{{OptionName}}_PresetFinalize")

	if AGS_GLOBAL_SETTINGS.{{SettingKey}} ~= 0 then
		-- Register event handlers
		Rule_AddGlobalEvent(CBA_Options_{{OptionName}}_OnEvent, {{GE_EVENT}})

		-- Initialize per-player state
		for i, player in pairs(PLAYERS) do
			player.{{optionName}}_count = 0
		end
	end
end

function CBA_Options_{{OptionName}}_OnEvent(context)
	-- Extract context (verify fields against game-events.md)
	local entity = context.entity
	local player = context.player

	if not Entity_IsValid(entity) then
		return
	end

	-- Skip landmarks (universal exclusion)
	if Entity_IsEBPOfType(Entity_GetBlueprint(entity), "landmark") then
		return
	end

	-- Player lookup
	for i, p in pairs(PLAYERS) do
		if p.id == player then
			-- Civ-specific logic (direct comparison)
			local player_civ = Player_GetRaceName(player)

			-- Update counter
			p.{{optionName}}_count = p.{{optionName}}_count + 1

			-- Enforce limit
			if p.{{optionName}}_count >= AGS_GLOBAL_SETTINGS.{{SettingKey}} then
				-- Lock production / apply restriction
			end
			break
		end
	end
end
```

## Verified Patterns (from cba_options.scar)

| Pattern | Implementation |
|---------|---------------|
| Module registration | `Core_RegisterModule("CBA_Options")` |
| Settings gate | `if AGS_GLOBAL_SETTINGS.MaximumProductionBuildings ~= 0 then` |
| Event registration | `Rule_AddGlobalEvent(handler, GE_ConstructionStart)` |
| Player iteration | `for i, player in pairs(PLAYERS) do` |
| Landmark exclusion | `Entity_IsEBPOfType(context.pbg, "landmark")` |
| Counter increment | `player.buildingLimit_count = player.buildingLimit_count + 1` |
| BP lookup | `AGS_GetCivilizationEntity(player_civ, "siege_workshop")` |
| Civ branching | `if player_civ == "english" then ... elseif player_civ == "chinese" then` |

## Checklist

- [ ] Module registered with `Core_RegisterModule`
- [ ] Setting gated in `PresetFinalize()`
- [ ] Events use correct scope (see `references/api/game-events.md`)
- [ ] Per-player state initialized in PLAYERS loop
- [ ] Landmark exclusion via `Entity_IsEBPOfType`
- [ ] DLC variants tested (16 civs have AGS_ENTITY_TABLE entries)
- [ ] Counter recount handled after ownership transfers
- [ ] `AGS_CIV_PARENT_MAP` / `branch_civ` used only for Dynasties variants (not Knights DLC)
