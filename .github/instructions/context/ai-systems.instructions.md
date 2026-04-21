---
applyTo: "**/cba_ai_player.scar,**/cba_debug_ai_player.scar,**/cba_debug_ai_behavior.scar,**/cba_training.scar,**/ags_ai.scar,data/aoe4/scar_dump/scar gameplay/ai/**"
---

# AI Systems — Official Reference Auto-Load

When editing AI-related SCAR files, always consult these verified official sources before introducing new patterns.

## Official AI Scripts (extracted base game)

| File | Role |
|------|------|
| `data/aoe4/scar_dump/scar gameplay/ai/army.scar` | Army lifecycle: init, target sequencing, state machine, death/revival |
| `data/aoe4/scar_dump/scar gameplay/ai/army_encounter.scar` | ArmyEncounterFamily — squad clustering, StateTree notifications, parent/child promotion |
| `data/aoe4/scar_dump/scar gameplay/ai/ai_encounter_util.scar` | String helpers for encounter end-reasons and notification types |
| `data/aoe4/scar_dump/scar gameplay/ai/wave_generator.scar` | WaveGenerator — timed unit spawning, build-time simulation, staging/assault army integration |
| `data/aoe4/scar_dump/scar gameplay/ai/combat_fitness_util.scar` | Combat fitness simulation — test encounters, health measurement, matchup scoring |
| `data/aoe4/scar_dump/scar gameplay/ai/combat_fitness_consts.scar` | SBP filter list for combat fitness characterization |

## Official Gamemode & Setup Scripts (AI config hooks)

| File | AI-Relevant Content |
|------|---------------------|
| `data/aoe4/scar_dump/scar gameplay/gamesetup.scar` | `MT_MULTIPLAYER` constant; `AI_IsLocalAIPlayer()` check; `Mission_SetDifficulty()` hook |
| `data/aoe4/scar_dump/scar gameplay/gamemodes/standard_mode.scar` | Multiplayer baseline gamemode AI behavior |
| `data/aoe4/scar_dump/scar gameplay/gamemodes/chart_a_course.scar` | `ChartACourse_SelectUpgradeForAIPlayer()` — per-AI-player upgrade selection |
| `data/aoe4/scar_dump/scar gameplay/missionomatic/missionomatic.scar` | Skirmish-driven module orchestrator; `Util_DifVar()` difficulty scaling |
| `data/aoe4/scar_dump/scar gameplay/missionomatic/modules/module_townlife.scar` | `AIPlayer_GetOrCreateHomebase()` skirmish AI economy module |

## Official API Documentation

| Source | Key APIs |
|--------|----------|
| `data/aoe4/scardocs/Essence_ScarFunctions.api` | `AIPlayer_*`, `AIEncounter_*`, `AI_*`, `AIProductionScoring_*` |
| `data/aoe4/scardocs/Essence_Constants.api` | `PCMD_AIPlayer`, `ST_AIPLAYER`, `GE_AIPlayer_EncounterNotification`, `GE_AIPlayer_Migrated` |

## Workspace AI Reference Docs

| Doc | Content |
|-----|---------|
| `references/gameplay/ai.md` | Army system, encounter plans, wave generator, combat fitness — full function index |
| `references/systems/ai-patterns.md` | Army lifecycle, encounter plan architecture, campaign AI per-civ usage index |
| `references/systems/difficulty-index.md` | `Util_DifVar()` 4-tier and 7-tier scaling; per-campaign difficulty matrix |
| `Gamemodes/Advanced Game Settings/docs/ai/AI_INDEX.md` | AGS AI integration: handicaps, multiplayer config, `ags_ai.scar` module |

## Key Patterns (consult before writing new AI code)

### Army Init Pattern
```
Army_Init({ player, sgroup, targets, targetOrder, onDeathFunction, onDeathReset, combatArena })
```
Target orders: `TARGET_ORDER_LINEAR`, `LOOP`, `PATROL`, `RANDOM`

### Difficulty Scaling Pattern
```
local value = Util_DifVar({easy_val, normal_val, hard_val, expert_val})
```

### AI Player Detection
```
if AI_IsLocalAIPlayer(player) then ... end
```

### WaveGenerator Flow
`WaveGenerator_Init` → `WaveGenerator_SetUnits` → `WaveGenerator_Prepare` → `WaveGenerator_Monitor` → `WaveGenerator_Launch`

### StateTree Encounter Creation
```
Cardinal_CreateAIEncounterWithStateModelTunings(player, sgroup, stateTreeConfig, stateModelTunings)
```

### Building Engagement Presets
`BUILDINGS_NONE` | `BUILDINGS_ALL` | `BUILDINGS_ALL_BUT_TC` | `BUILDINGS_THREATENING` | `BUILDINGS_IMPORTANT`

### Encounter End Reasons
`AtDestination` | `EnemiesAtTargetCleared` | `Timeout` | `CombatThreshold` | `ShouldFallback` | `SelfSquadsEmpty` | `CannotReachDestination` | `Torndown` | `WasAttacked`

## Attack-Move Styles
`attackMoveStyle_ignoreEverything` | `ignorePassive` | `normal` | `aggressive` | `attackEverything` | `excludeTC`
