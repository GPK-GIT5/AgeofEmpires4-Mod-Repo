---
applyTo: "**/*.scar"
---

# SCAR/Lua Standards — AoE4

SCAR Lua 5.x with engine globals. No `require()` — use `import()`. No metatables. Tabs (size 4).

## Naming Conventions

| Element | Convention | Examples |
|---------|-----------|----------|
| Lifecycle functions | `Mission_PascalCase()` | `Mission_SetupPlayers()`, `Mission_Start()` |
| Phase functions | `PhaseN_Name_Action()` | `Phase1_Village_Main_InitObjectives()` |
| System functions | `System_Action()` | `Difficulty_Init()`, `Training_Init()` |
| Helper functions | `PascalCase()` | `GetPlayerCiv()`, `ResolveCivKey()` |
| Debug functions | `Debug_Name()` | `Debug_PlayerSlots()`, `Validator_PlayerCivDump()` |
| Private functions | `_PascalCase()` | `_ResolveGlobalPath()`, `_MergeTier()` |
| Rule callbacks | `Context_Rule_Action()` | `Phase1_Barracks_Side_Rule_Counters()` |
| Player globals | `playerN` | `player1`, `player2`, ... `player6` |
| Group variables | `sg_`/`eg_`/`mkr_` prefix | `sg_army`, `eg_buildings`, `mkr_spawn` |
| Constants | `UPPER_CASE` with prefix | `RT_Food`, `GE_EntityKilled`, `BP_SIEGE_MANGONEL` |
| Objective constants | `OBJ_`/`SOBJ_`/`TOBJ_` | `OBJ_Phase1_Village_Main` |
| Data tables | `UPPER_CASE` or `PascalCase` | `PLAYERS`, `AGS_ENTITY_TABLE` |

## File Split Pattern

| File | Responsibility |
|------|---------------|
| `coop_N_name.scar` | Main orchestrator: lifecycle, HUD, disconnect, utilities |
| `coop_N_name_data.scar` | Data tables: AGS_ENTITY_TABLE, Unit_Types, DLC resolver |
| `coop_N_name_difficulty.scar` | Difficulty tiers: TIER_DEFAULTS + overrides |
| `coop_N_name_objectives.scar` | Objectives, callbacks, rule monitors |
| `coop_N_name_spawns.scar` | Wave scheduling, timing, spawn markers |

## Mission Lifecycle

1. `Mission_SetupPlayers()` → `World_GetPlayerAt()` slots
2. `Mission_SetupVariables()` → Init globals, groups, tables
3. `Mission_SetRestrictions()` → Lock/unlock production
4. `Mission_Preset()` → AI, modifiers, objectives init
5. `Mission_Start()` → Start objectives, rules, spawns

## Common API Patterns

```lua
-- Rules system
Rule_AddInterval(callback, seconds)
Rule_AddOneShot(callback, delay)
Rule_AddGlobalEvent(callback, GE_Event)
Rule_RemoveMe()

-- Blueprint resolution (DLC-aware)
AGS_GetCivilizationEntity(player_civ, bp_type)
BP_GetEntityBlueprint("attribName")

-- Restrictions
Player_SetEntityProductionAvailability(player, ebp, ITEM_LOCKED)

-- Module registration
Core_RegisterModule("MyModule")
```

## Error Handling

- Fatal: `error("[TAG] message")` with bracketed prefix
- Guards: `if x == nil then error("[TAG] not found: " .. key) end`
- Logging: `print("[TAG] info")` with bracketed prefix
- Debug: `if DLC_DEBUG then print("[DLC] trace") end`
- State flags: `if g_gameOver then return end`

## Console Command Constraints

When generating commands for the AoE4 Content Editor console:
- **Single expression/statement only** — no multi-line scripts
- **No `local`** — console discards local scope after each input
- **No control-flow blocks** — no `if/then/end`, `for/do/end`
- **No cross-command state** — each command is independent
- If task needs control flow → write a function in .scar, call it from console

## Blueprint Resolution

When resolving blueprint references (attribName, pbgid, legacy paths):
1. Use `AGS_GetCivilizationEntity(player_civ, "type")` for DLC-aware lookups
2. Use `BP_GetEntityBlueprint("attribName")` for direct lookups
3. Fallback: check `references/blueprints/` or `data/aoe4/data/all-baseids.json`

## Anti-Patterns & Self-Check

- `require()` → use `import()`
- Spaces → Tabs (size 4)
- External patterns → scan existing code first
- Loading 4+ .scar files → check MOD-INDEX.md first
- Verify naming matches convention table
- Error messages use `[TAG]` prefix
- No patterns not found in existing codebase
