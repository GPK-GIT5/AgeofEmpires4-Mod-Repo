# Age of Empires 4 — Modding Workspace

A comprehensive reference workspace for AoE4 SCAR scripting, modding, and debugging.

## Quick Navigation

### 📚 Complete Reference Documentation
**For comprehensive index of all 25 reference files, see [reference/INDEX.md](reference/INDEX.md)** – Organized by workflow, includes quick-start tasks and statistics.

### Copilot Guidance
Use [.github/copilot-instructions.md](.github/copilot-instructions.md) for repo-specific Copilot usage and links to the Copilot Skill.

### API & Data Reference
| Reference | Description |
|-----------|-------------|
| [reference/scar-api-functions.md](reference/scar-api-functions.md) | All 4,435 SCAR API functions organized by category |
| [reference/UI_SetPlayerDataContext_FieldDiscovery.md](reference/UI_SetPlayerDataContext_FieldDiscovery.md) | Complete discovery of 18 modifiable UI_SetPlayerDataContext fields (scarModel + overrides) |
| [reference/constants-and-enums.md](reference/constants-and-enums.md) | 700+ constants, enums, typed values |
| [reference/game-events.md](reference/game-events.md) | 175 game events (GE_*) with numeric IDs |
| [reference/commands-reference.md](reference/commands-reference.md) | Entity, Squad, and Player command types |
| [scripts/gameplay-index.md](scripts/gameplay-index.md) | Index of 131 gameplay scripts |
| [scripts/campaign-index.md](scripts/campaign-index.md) | Index of 570 campaign scripts |
| [guides/scar-scripting-basics.md](guides/scar-scripting-basics.md) | SCAR scripting patterns & common code |
| [guides/common-patterns.md](guides/common-patterns.md) | Reusable code patterns from official scripts |
| [data-sources.md](data-sources.md) | Paths to all raw data files |

### Official Modding Guides (78 Articles)
| Guide | Articles | Description |
|-------|----------|-------------|
| [official-guides/01-getting-started.md](official-guides/01-getting-started.md) | 11 | Launching the editor, mod types, camera controls, testing, publishing |
| [official-guides/02-editor-interface.md](official-guides/02-editor-interface.md) | 23 | Render View, Scenario Tree, Object Browser, Properties, all menus |
| [official-guides/03-crafted-maps.md](official-guides/03-crafted-maps.md) | 30 | Terrain, textures, water, atmosphere, objects, players, audio, effects |
| [official-guides/04-generated-maps.md](official-guides/04-generated-maps.md) | 3 | Terrain tables, player starts, distributions, terrain types |
| [official-guides/05-tuning-packs.md](official-guides/05-tuning-packs.md) | 8 | Attribute Editor, cloning, costs, stats, hardpoints, weapons |
| [official-guides/06-game-modes.md](official-guides/06-game-modes.md) | 5 | SCAR scripting, win conditions, rules, objectives, debugging |

## Data Overview

### Source Data
- **SCAR API Documentation** — Official function_list.htm with full signatures
- **Lua Runtime Dump** — 32K-line dump of the entire Lua state at runtime
- **Gameplay Scripts** — 131 scripts (71K lines): win conditions, AI, armies, objectives, game modes
- **Campaign Scripts** — 570 scripts (322K lines): all campaign missions, challenges, training

### What's Covered
- **4,435 functions** across 157 categories (Squad_, Entity_, Player_, UI_, AI_, etc.)
- **700+ constants & enums** across 40+ type categories
- **175 game events** for hooking into gameplay systems
- **131 gameplay scripts** including win conditions, army system, AI encounters
- **570 campaign scripts** covering all campaigns: Abbasid, Anglo-Norman, Hundred Years War, Grand Duchy of Moscow, Mongol, Sultan's Ascend, plus challenges and training

## Key Systems

### Core Architecture
| System | Key Files | Description |
|--------|-----------|-------------|
| **Cardinal** | `cardinal.scar` | Core game framework, player setup, initialization |
| **MissionOMatic** | `missionomatic.scar` | Mission orchestration, objectives, spawning |
| **Army System** | `army.scar`, `army_encounter.scar` | AI-controlled army units with targets & behaviors |
| **Win Conditions** | `annihilation.scar`, `conquest.scar`, `wonder.scar`, etc. | Victory/defeat logic |
| **Objectives** | `objectives.scar`, `momobjective.scar` | Objective creation and tracking |
| **AI Encounters** | `ai_encounter_util.scar`, `module_*.scar` | AI behavior modules |

### Game Modes
`standard_mode.scar`, `combat_mode.scar`, `king_of_the_hill_mode.scar`, `full_moon_mode.scar`, `chaotic_climate_mode.scar`, `seasons_feast_mode.scar`, `sandbox_mode.scar`, `map_monsters_mode.scar`, `none_mode.scar`

### Training System
Per-civilization training conditions and goals:
`coretrainingconditions.scar`, `coretraininggoals.scar`, plus civilization-specific files for Abbasid, Chinese, English, French, Mongol, Sultanate, and Rus

## File Conventions
- `.scar` files are Lua scripts (set to Lua syntax highlighting in this workspace)
- Functions follow `Category_ActionName` naming: `Squad_GetHealth()`, `Player_SetResource()`
- Constants use `UPPER_CASE` with type prefix: `RT_Food`, `GE_EntityKilled`, `CMD_Move`
- Game events are registered with `Rule_AddGlobalEvent(callback, GE_EventName)`
