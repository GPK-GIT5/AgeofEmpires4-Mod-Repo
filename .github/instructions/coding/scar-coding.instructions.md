---
applyTo: "**/*.scar"
---

# SCAR/Lua Standards — AoE4

SCAR Lua 5.x with engine globals. No `require()` — use `import()`. No metatables. Tabs (size 4).

## Evidence-First Rule

- Only apply patterns and API usage confirmed by existing codebase examples or verified working implementations. Do not apply speculative, theoretical, or untested guidance.
- Prefer minimal, proven solutions over comprehensive coverage. A smaller fix that is verified working is always preferable to a broader change based on assumptions.
- When uncertain whether a pattern works at runtime, flag it explicitly rather than shipping it silently.

## Iterative Troubleshooting (Soft Guard)

When a SCAR fix requires more than one attempt, these practices help converge faster. All items are advisory (should/may) — use judgment.

### Before each attempt
- State the hypothesis in one sentence and what observable evidence would confirm or refute it.
- Note what changed since the last attempt and why the new change addresses the root cause differently.

### Between attempts — evidence delta
- Compare scarlog output or debug probe results to the prior run. If behavior is unchanged after a code change, the hypothesis should be reconsidered before iterating the same approach.
- Record the delta briefly (e.g., "progress still 0.00 — villager command not reaching entity").

### Escalation signals
- Same error after 3 independent code changes → pause iteration; pivot to root-cause analysis (add instrumentation, trace call path, inspect engine assumptions).
- Debug output metric unchanged across attempts → add intermediate print markers to narrow the stall window before editing production logic again.
- Instrumentation before repeated edits: when a fix doesn't take, prefer adding a targeted log/probe first, then re-running, over making another speculative code change.

### Assumption revalidation
- After 2+ failed attempts, re-read the relevant engine API docs or codebase examples to verify the assumed call semantics still hold.
- Check whether the function under test is actually being reached at runtime (e.g., rule registered, import present, guard conditions met).

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

## Player Handle Safety

- `World_GetPlayerAt()` returns an engine player handle (`plyr_mt`). Treat it as opaque unless normalized.
- In logs/debug `string.format`, use `%s` + `tostring(...)` for player values unless you have verified a numeric ID.
- Do not key maps by `player.id` and then index with `World_GetPlayerAt()` results without normalization; prefer `Core_GetPlayersTableEntry(playerHandle)` and pass around player entries.

## Event Rules

Use the narrowest scope that fits. Narrower = better performance, fewer false triggers.

| Scope | Registration | Fires When |
|-------|-------------|------------|
| Global | `Rule_AddGlobalEvent(cb, GE)` | Any object, any player |
| Player | `EventRule_AddPlayerEvent(cb, player, GE)` | That player's objects only |
| Entity | `EventRule_AddEntityEvent(cb, entity, GE)` | That specific entity only |
| Squad | `EventRule_AddSquadEvent(cb, squad, GE)` | That specific squad only |

Pass custom data via `EventRule_Add*Data` variants — data merges into the callback `context`.

### Context Fields

Each event provides specific fields in `context`. **Only access documented fields** — see `references/api/game-events.md`.

- `GE_EntityKilled` → `context.victim`, `context.killer`, `context.victimOwner`
- `GE_ConstructionComplete` → `context.entity`, `context.player`
- `GE_UpgradeComplete` → `context.player`, `context.upgrade`
- `GE_BuildItemComplete` → `context.entity`, `context.player`, `context.squad`
- `GE_EntityOwnerChange` → `context.entity`, `context.prevOwner`, `context.newOwner`

### Event Pitfalls

1. **Stale entity handles** — Always check `Entity_IsValid(entity)` before operations on stored handles.
2. **Wrong scope** — `Rule_AddGlobalEvent` fires for ALL players. Use `EventRule_AddPlayerEvent` when monitoring one player.
3. **Missing cleanup** — Forgetting `Rule_RemoveMe()` in one-shot handlers causes repeated execution.
4. **Ownership transfer blind spot** — `Entity_SetPlayerOwner` does NOT fire `GE_ConstructionComplete` or `GE_ConstructionStart`. Counter systems must recount manually after transfers. See [KI-SIEGE-001](known-issues.instructions.md#ki-siege-001-building-limit-counter-desync-after-entity_setplayerowner).
5. **EventRule on dead entity** — Registering on a destroyed entity is silently ignored. Verify validity first.
6. **Overly broad type filters** — Do not rely only on generic type tags (e.g., `"siege"`). Include explicit subtype checks (`"ram"`, `"fire_ram"`, `"scar_ram"`, `"ram_tower"`, `"siege_tower"`) so recounts cannot go stale.

## Blueprint Resolution

`AGS_ENTITY_TABLE` maps `player_civ` → `bp_type` → attribName. Defined in `ags_blueprints.scar`.

- **17 direct entries**: 10 base civs + 6 Knights DLC variants (abbasid_ha_01, chinese_ha_01, french_ha_01, hre_ha_01, japanese, byzantine) + neutral
- **6 Dynasties variants** (mongol_ha_gol, lancaster, templar, byzantine_ha_mac, japanese_ha_sen, sultanate_ha_tug) resolve via `AGS_CIV_PARENT_MAP` fallback

Lookup functions:
- `AGS_GetCivilizationEntity(player_civ, bp_type)` → EBP
- `AGS_GetCivilizationUnit(player_civ, bp_type)` → SBP
- `AGS_GetCivilizationUpgrade(player_civ, bp_type)` → UBP
- `BP_GetEntityBlueprint("attribName")` → direct lookup (nil if invalid)

Civ-specific branching:
- **Direct comparison** for unique behavior: `if player_civ == "english" then`
- **Parent-map fallback** for Dynasties variants: `local branch_civ = AGS_CIV_PARENT_MAP[player_civ] or player_civ`

Landmark exclusion: `Entity_IsEBPOfType(eid, "landmark")` — universal, covers all civs.

### Blueprint Anti-Patterns

- Hardcoding attribNames instead of `AGS_ENTITY_TABLE` lookup
- Assuming all DLC variants share parent entries — Knights DLC civs each have their own full table entry
- Using `AGS_CIV_PARENT_MAP` for Knights DLC civs — the parent map only covers 6 Dynasties variants

## Counter System Discipline

When modifying any counter system (building limits, siege limits, population caps):

1. **State timeline** — Before changing shared mutable state (pending counters, limit counts), trace every function that reads/writes the variable in the same tick and verify the execution order.
2. **Data table audit** — When changing any filter-by-type function, verify all types in the associated data table are covered in the filter.
3. **Self-correction interaction** — Do not call recount functions that contain self-correction logic before incrementing a counter that self-correction would overwrite.
4. **Arithmetic sanity** — When using modifiers (build time, speed), write the expected result in a comment (e.g., `-- 0.02 * 50.0 = 1.0 net neutral — BUG`).

## Error Handling

- Fatal: `error("[TAG] message")` with bracketed prefix
- Guards: `if x == nil then error("[TAG] not found: " .. key) end`
- Logging: `print("[TAG] info")` with bracketed prefix
- State flags: `if g_gameOver then return end`

## Console Command Constraints

> **Canonical spec:** `.github/instructions/core/console-commands.instructions.md`
>
> All hard constraints, allowed patterns, forbidden→fix table, presentation format, selection heuristic, and pre-send self-check are defined there. Do not duplicate rules here.

## Reference Gate

When editing `.scar` files under `Gamemodes/Onslaught/assets/scar/debug/`:
- Any new, removed, or renamed debug file → update `.github/instructions/core/debugger-architecture.instructions.md` module table and `cba_debug.scar` imports.
- Any new public `Debug_*` function → add to `.skills/scar-debug/SKILL.md` Command Catalog with correct tier annotation.

## Civ Addition Checklist

When adding a new civilization or DLC variant to Onslaught, update **every** system below. Automated validation (test 3.1b–3.1e) catches most gaps at runtime; this checklist prevents them at authoring time.

| # | File / Table | Action |
|---|---|---|
| 1 | `AGS_CIV_PREFIXES` (ags_blueprints.scar) | Add `civ_name = "suffix_"` entry |
| 2 | `AGS_ENTITY_TABLE` (ags_blueprints.scar) | Add direct entry **OR** add to `AGS_CIV_PARENT_MAP` + `AGS_UNIT_BP_OVERRIDES.villager` |
| 3 | `CBA_CIV_BP_SUFFIX` (cba_siege_data.scar) | Add `civ_name = "suffix"` entry |
| 4 | Onslaught rewards (cba_rewards_onslaught.scar) | Add reward table or alias (`_CBA.rewards["new"] = _CBA.rewards["parent"]`) |
| 5 | Arena rewards (cba_rewards_arena.scar) | Add reward table or alias |
| 6 | `_LEAVER_RECEIVER_CLASS_MAP` (cba.scar) | Add entry if civ lacks standard archetypes (archer, manatarms, knight, crossbowman, monk, or any siege type) |
| 7 | `_LEAVER_CIV_UNIQUE_FALLBACK` (cba.scar) | Add entries for unique unit prefixes not shared with base civs; put specific prefixes before generic ones |
| 8 | `_LEAVER_MILITARY_SUFFIX_OVERRIDE` (cba.scar) | Add entry if military BPs use a suffix different from `AGS_CIV_PREFIXES` |
| 9 | Run `Debug_FullValidation()` | Tests 3.1b–3.1e verify sync across all tables; all must pass |


