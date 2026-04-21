# Advanced Game Settings — AoE4 Multiplayer Gamemode

[![AoE4 Editor](https://img.shields.io/badge/AoE4-Content_Editor-blue.svg)](.)
[![Type](https://img.shields.io/badge/Type-Gamemode-green.svg)](.)
[![Players](https://img.shields.io/badge/Players-1v1_to_4v4-orange.svg)](.)
[![Build](https://img.shields.io/badge/Build-4.2.0.5-brightgreen.svg)](.)

A comprehensive multiplayer gamemode framework for Age of Empires IV that provides extensive customization options for competitive and casual matches. Created by Relic Entertainment and enhanced by Woprock, AGS enables players to configure win conditions, starting scenarios, gameplay modifiers, diplomacy settings, and more through a modular scripting system.

**Key Features:**
- 11 win conditions (Conquest, Religious, Wonder, Regicide, Score, etc.)
- 7 starting scenarios (Settled, Nomadic, Fortified, Scattered, etc.)
- 30+ gameplay modifiers (resources, ages, vision, population, etc.)
- Dynamic team management and diplomacy
- Full AI support with adaptive behavior
- Observer/replay UI with player switching

**Authors:** Relic Entertainment, Woprock  
**Version:** 4.2.0.5

---

## Technology Stack

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Game Engine | Age of Empires IV | Latest Patch | Runtime environment |
| Scripting | SCAR (Lua-based) | Lua 5.x | Game logic and event handling |
| Framework | Cardinal.scar | Relic | Core mission lifecycle framework |
| UI | XAML + SCAR | AoE4 Editor | Observer controls and in-game UI |

### Core Dependencies

```lua
import("cardinal.scar")                      -- Relic's core framework
import("helpers/ags_blueprints.scar")       -- Blueprint management
import("helpers/ags_teams.scar")            -- Team tracking and API
import("helpers/ags_starts.scar")           -- Starting configuration
import("coreconditions/ags_conditions.scar") -- Condition framework
import("ags_global_settings.scar")           -- Centralized configuration
```

---

## Project Architecture

### High-Level Structure

```
Advanced Game Settings/
├── assets/scar/
│   ├── ags_cardinal.scar           (Entry point, delegate orchestration)
│   ├── ags_global_settings.scar    (1,189 lines - centralized config)
│   ├── conditions/                 (Win/loss conditions)
│   │   ├── ags_conquest.scar
│   │   ├── ags_religious.scar
│   │   ├── ags_wonder.scar
│   │   ├── ags_regicide.scar
│   │   ├── ags_score.scar
│   │   ├── ags_treaty.scar
│   │   ├── ags_elimination.scar
│   │   ├── ags_annihilation.scar
│   │   ├── ags_team_solidarity.scar
│   │   ├── ags_surrender.scar
│   │   └── conditiondata/          (Data files for conditions)
│   ├── startconditions/            (Starting scenarios)
│   │   ├── ags_start_settled.scar
│   │   ├── ags_start_nomadic.scar
│   │   ├── ags_start_fortified.scar
│   │   ├── ags_start_scattered.scar
│   │   ├── ags_starting_keep.scar
│   │   ├── ags_starting_king.scar
│   │   ├── ags_starting_scout.scar
│   │   └── statewars/              (State Wars DLC scenarios)
│   ├── gameplay/                   (30+ game modifiers)
│   │   ├── ags_starting_resources.scar
│   │   ├── ags_starting_age.scar
│   │   ├── ags_ending_age.scar
│   │   ├── ags_population_capacity.scar
│   │   ├── ags_map_vision.scar
│   │   ├── ags_team_vision.scar
│   │   ├── ags_handicaps.scar
│   │   ├── ags_game_rates.scar
│   │   └── statewars/              (State Wars features)
│   ├── coreconditions/             (Condition framework)
│   │   ├── ags_conditions.scar
│   │   ├── ags_conditions_match.scar
│   │   ├── ags_conditions_objectives.scar
│   │   ├── ags_conditions_notifications.scar
│   │   └── ags_conditions_presentations.scar
│   ├── helpers/                    (Utility modules)
│   │   ├── ags_teams.scar          (Team tracking API)
│   │   ├── ags_starts.scar         (Starting config)
│   │   └── ags_blueprints.scar     (Blueprint helpers)
│   ├── diplomacy/                  (Diplomatic interactions)
│   │   ├── ags_diplomacy.scar
│   │   ├── ags_relations.scar
│   │   ├── ags_tributes.scar
│   │   └── ags_diplomacy_ui.scar
│   ├── ai/                         (AI adjustments)
│   │   └── ags_ai.scar
│   ├── gamemodes/                  (Preset configurations)
│   │   ├── ags_standard.scar
│   │   ├── ags_nomad.scar
│   │   ├── ags_koth.scar
│   │   ├── ags_city_states.scar
│   │   └── ags_tournament_nomad.scar
│   ├── replay/                     (Observer UI)
│   │   ├── observerui.scar
│   │   ├── observeruirules.scar
│   │   ├── observeruiupdateui.scar
│   │   └── xaml/                   (UI controls)
│   ├── specials/                   (Utilities)
│   │   ├── ags_utilities.scar
│   │   ├── ags_match_ui.scar
│   │   └── ags_testing.scar
│   └── balance/                    (Balance adjustments)
│       └── ags_tournament_nomad_balance.scar
└── Advanced Game Settings.aoe4mod  (Mod package)
```

**Total:** 97 .scar files, ~15,000 lines of code

---

## Key Systems

### 1. Delegate Lifecycle (ags_cardinal.scar)

AGS extends Cardinal's lifecycle with custom phases:

| Phase | Function | Purpose | Delegates Called |
|-------|----------|---------|------------------|
| Setup | `AGS_Cardinal_OnGameSetup()` | Read win condition options | `SetupSettings`, `AdjustSettings`, `UpdateModuleSettings` |
| Init | `AGS_Cardinal_OnInit()` | Early initialization | `EarlyInitializations` |
| Post-Init | `AGS_Cardinal_PostInit()` | Late initialization | `LateInitializations` |
| Preset | `AGS_Cardinal_Preset()` | Pre-start spawning | `PresetInitialize`, `PresetExecute`, `PresetFinalize` |
| Pre-Start | `AGS_Cardinal_PreStart()` | 1-frame before start | `PrepareStart` |
| Start | `AGS_Cardinal_Start()` | Game begins | `OnStarting`, `OnPlay` |

**Execution Order:** Modules register via `Core_RegisterModule()` and implement delegates. First registered = first executed.

### 2. Global Settings (ags_global_settings.scar)

Centralized configuration table (`AGS_GLOBAL_SETTINGS`) with 100+ options:

**Key Constants:**
```lua
-- Team Victory Modes
AGS_GS_TEAM_VICTORY_FFA = 0         -- Free-for-all
AGS_GS_TEAM_VICTORY_STANDARD = 1    -- Static teams
AGS_GS_TEAM_VICTORY_DYNAMIC = 2     -- Dynamic diplomacy

-- Starting Scenarios
AGS_GS_SETTLEMENT_SCATTERED = 0     -- Scattered resources
AGS_GS_SETTLEMENT_NOMADIC = 1       -- No starting TC
AGS_GS_SETTLEMENT_SETTLED = 2       -- Standard start
AGS_GS_SETTLEMENT_FORTIFIED = 3     -- Stone walls + towers

-- Ages
AGS_GS_AGE_DARK = 1
AGS_GS_AGE_FEUDAL = 2
AGS_GS_AGE_CASTLE = 3
AGS_GS_AGE_IMPERIAL = 4
AGS_GS_AGE_LATE_IMPERIAL = 5

-- Resources Presets
AGS_GS_RESOURCES_LOW = 1            -- 100 resources
AGS_GS_RESOURCES_NORMAL = 2         -- 200 resources (default)
AGS_GS_RESOURCES_HIGH = 4           -- 5000 resources
AGS_GS_RESOURCES_MAXIMUM = 6        -- 999,999 resources
```

### 3. Team Management (helpers/ags_teams.scar)

Dynamic team tracking system:

**API Functions:**
- `AGS_Teams_CreateInitialTeams()` — Initialize team structures
- `AGS_Teams_DoesWinnerGroupExists()` — Check for winning teams
- `AGS_Teams_IsSingleTeamSandbox()` — Detect co-op mode
- `AGS_Teams_GetActiveTeamCount()` — Count remaining teams
- Player data structure: `player.AGS_Team.index`, `player.AGS_Team.allies`

**Dynamic Diplomacy:** Teams can shift mid-game based on player relations (AGS_GS_TEAM_VICTORY_DYNAMIC).

### 4. Win Conditions (conditions/)

11 pluggable win conditions with shared framework:

| Condition | File | Victory Trigger | Delegates |
|-----------|------|----------------|-----------|
| Conquest | ags_conquest.scar | Destroy all landmarks | `OnStructureKilled` |
| Religious | ags_religious.scar | Control sacred sites (10min) | `OnStrategicPointChanged` |
| Wonder | ags_wonder.scar | Build + defend wonder (15min) | `OnConstructionComplete` |
| Regicide | ags_regicide.scar | Kill enemy king units | `OnEntityKilled` |
| Score | ags_score.scar | Highest score at time limit | Timer-based |
| Treaty | ags_treaty.scar | Post-treaty aggression allowed | Timer + relations |
| Elimination | ags_elimination.scar | Player quits | `OnPlayerDefeated` |
| Annihilation | ags_annihilation.scar | Destroy everything | Entity checks |
| Team Solidarity | ags_team_solidarity.scar | Team-wide elimination | Team state |
| Surrender | ags_surrender.scar | Manual surrender | UI callback |
| Culture | ags_culture.scar | Cultural victory (rare) | Custom logic |

**Shared Flow:**
1. `UpdateModuleSettings()` — Read configuration
2. `PresetFinalize()` — Initialize objectives
3. `OnPlay()` — Start monitoring
4. `TryDeclareWinners()` — Check victory conditions
5. `AGS_Conditions_CheckVictory()` — Declare winners + end game

### 5. Starting Scenarios (startconditions/)

7 starting configurations:

| Scenario | Description | Entity Changes |
|----------|-------------|----------------|
| Settled | Standard AoE4 start | Default spawns |
| Nomadic | No Town Center | Remove TC, add villagers |
| Fortified | Defensive start | Add stone walls, towers, scout |
| Scattered | Randomized resources | Adjust resource proximity |
| Starting Keep | Keep instead of TC | Replace TC blueprint |
| Starting King | Extra king unit | Spawn additional king |
| Starting Scout | Scout cavalry | Add scout unit |

**State Wars DLC:**
- **Pilgrims:** Special migration scenario
- **City States:** Pre-built cities with buildings
- **Starting Cities:** Defined city locations

### 6. Gameplay Modifiers (gameplay/)

30+ configurable settings:

**Resource Modifiers:**
- `ags_starting_resources.scar` — Initial stockpiles (0 to 999,999)
- `ags_game_rates.scar` — Gather/production speed multipliers
- `ags_treasures.scar` — Map treasure spawns

**Age Modifiers:**
- `ags_starting_age.scar` — Begin in Feudal/Castle/Imperial
- `ags_ending_age.scar` — Lock maximum age
- `ags_technology_age.scar` — Technology availability

**Vision Modifiers:**
- `ags_map_vision.scar` — Concealed/Explored/Revealed
- `ags_team_vision.scar` — Shared team vision
- `ags_reveal_spawn.scar` — Reveal starting locations

**Balance Modifiers:**
- `ags_handicaps.scar` — Economic/military bonuses
- `ags_population_capacity.scar` — Population limits (25 to 1000)
- `ags_team_balance.scar` — Auto-balance resources/population

**Building Modifiers:**
- `ags_town_center_restrictions.scar` — TC building rules
- `ags_wonder_construction.scar` — Wonder enable/disable
- `ags_no_dock.scar` — Disable Dock construction

### 7. Diplomacy System (diplomacy/)

Multi-layered diplomatic interactions:

**Components:**
- `ags_diplomacy.scar` — Core diplomacy engine
- `ags_relations.scar` — Alliance/enemy state management
- `ags_tributes.scar` — Resource transfers between players
- `ags_diplomacy_ui.scar` — UI integration

**Team Victory Modes:**
- **Standard:** Static teams from lobby
- **Dynamic:** Players can shift alliances in-game
- **FFA:** No permanent teams, everyone for themselves

### 8. Core Conditions Framework (coreconditions/)

Shared utilities for all win conditions:

**Modules:**
- `ags_conditions.scar` — Victory checking logic
- `ags_conditions_match.scar` — Match state tracking
- `ags_conditions_objectives.scar` — Objective creation/updates
- `ags_conditions_notifications.scar` — Player notifications
- `ags_conditions_presentations.scar` — Victory/defeat presentations

**Key Functions:**
- `AGS_Conditions_CheckVictory()` — Universal victory resolver
- `AGS_Conditions_IsPrimary()` — Determine primary win condition
- `AGS_SetPlayerVictorious()` — Trigger victory state
- `AGS_EndGame()` — Quit match

### 9. Observer/Replay UI (replay/)

Spectator controls for casting and replay analysis:

**Features:**
- Player perspective switching (1v1, 2v2+)
- UI toggle controls
- Resource/tech visibility
- XAML-based control panels

**Files:**
- `observerui.scar` — Main observer logic
- `observeruirules.scar` — Visibility rules
- `observeruiupdateui.scar` — UI refresh logic
- `xaml/` — Control definitions

### 10. Preset Gamemodes (gamemodes/)

Pre-configured game modes:

| Gamemode | Configuration | Use Case |
|----------|--------------|----------|
| Standard | Default AGS settings | Competitive matches |
| Nomad | No starting TC | Migration gameplay |
| King of the Hill | Control points | Unique objective |
| City States | Pre-built cities | State Wars DLC |
| Tournament Nomad | Balanced nomad start | Competitive nomad |

Each gamemode imports `ags_cardinal.scar` and overrides specific delegates.

---

## File Structure

### Entry Points

| File | Lines | Purpose | Key Functions |
|------|-------|---------|---------------|
| [ags_cardinal.scar](assets/scar/ags_cardinal.scar) | 285 | Main orchestrator, delegate invocation | `AGS_Cardinal_OnGameSetup()`, `AGS_Cardinal_OnInit()`, `AGS_Cardinal_Start()` |
| [ags_global_settings.scar](assets/scar/ags_global_settings.scar) | 1,189 | Centralized configuration table | `AGS_GLOBAL_SETTINGS` (table), 100+ constants |

### Core Systems

| Directory | Files | Purpose | Example |
|-----------|-------|---------|---------|
| [conditions/](assets/scar/conditions) | 11 + 11 data | Win/loss conditions | `ags_religious.scar` (Sacred Sites) |
| [startconditions/](assets/scar/startconditions) | 7 + 3 (DLC) | Starting scenarios | `ags_start_nomadic.scar` (No TC) |
| [gameplay/](assets/scar/gameplay) | 30+ | Game modifiers | `ags_starting_age.scar` (Feudal start) |
| [coreconditions/](assets/scar/coreconditions) | 5 | Condition framework | `ags_conditions.scar` (Victory logic) |
| [helpers/](assets/scar/helpers) | 3 | Utility modules | `ags_teams.scar` (Team API) |
| [diplomacy/](assets/scar/diplomacy) | 5 + template | Diplomacy system | `ags_relations.scar` (Alliances) |
| [ai/](assets/scar/ai) | 1 | AI adjustments | `ags_ai.scar` (AI handicaps) |
| [gamemodes/](assets/scar/gamemodes) | 5 | Preset configs | `ags_standard.scar` (Default) |
| [replay/](assets/scar/replay) | 4 + 4 XAML | Observer UI | `observerui.scar` (Player switching) |
| [specials/](assets/scar/specials) | 3 | Utilities | `ags_utilities.scar` (Common helpers) |
| [balance/](assets/scar/balance) | 1 | Balance tweaks | `ags_tournament_nomad_balance.scar` |

### Key Function Signatures

**ags_cardinal.scar:**
```lua
function AGS_Cardinal_OnGameSetup()          -- Phase 1: Read options
function AGS_Cardinal_OnInit()               -- Phase 2: Early init
function AGS_Cardinal_PostInit()             -- Phase 3: Late init
function AGS_Cardinal_Preset()               -- Phase 4: Spawning
function AGS_Cardinal_PreStart()             -- Phase 5: Pre-start (1 frame)
function AGS_Cardinal_Start()                -- Phase 6: Game start
```

**helpers/ags_teams.scar (332 lines):**
```lua
function AGS_Teams_CreateInitialTeams()      -- Initialize team structures
function AGS_Teams_DoesWinnerGroupExists()   -- Returns winning team table or nil
function AGS_Teams_IsSingleTeamSandbox()     -- Detect co-op mode
function AGS_Teams_GetActiveTeamCount()      -- Count remaining teams
```

**coreconditions/ags_conditions.scar (74 lines):**
```lua
function AGS_Conditions_CheckVictory(is_allowed, presentation_func, reason, opt_objective)
function AGS_Conditions_IsAnyHumanAlive()    -- Check for human players
function AGS_Conditions_IsPrimary(reason)    -- Is this primary win condition?
```

**conditions/ags_religious.scar (example):**
```lua
function AGS_Religious_UpdateModuleSettings()        -- Read settings
function AGS_Religious_PresetFinalize()              -- Initialize sites
function AGS_Religious_OnPlay()                      -- Start monitoring
function AGS_Religious_OnStrategicPointChanged()     -- Sacred site captured
function AGS_Religious_OnTimerTick()                 -- Progress timer
function AGS_Religious_TryDeclareWinners()           -- Check victory
```

---

## Getting Started

### Loading in Content Editor

1. **Open AoE4 Content Editor:**
   - Launch Age of Empires IV
   - Navigate to **Tools** → **Content Editor**

2. **Load Advanced Game Settings:**
   - **File** → **Open Mod**
   - Browse to: `Gamemodes/Advanced Game Settings/Advanced Game Settings.aoe4mod`
   - Select a gamemode entry point:
     - `ags_standard.scar` — Default configuration
     - `ags_nomad.scar` — Nomadic start
     - `ags_koth.scar` — King of the Hill

3. **Test in Simulation:**
   - Click **Play** button (top toolbar)
   - Select map, civs, and AGS options
   - Launch match

### Playing the Gamemode

1. **Lobby Setup:**
   - Create multiplayer lobby
   - Select map with AGS enabled
   - Configure game settings via AGS options menu:
     - Win Conditions (Conquest, Religious, Wonder, etc.)
     - Starting Scenario (Settled, Nomadic, Fortified, etc.)
     - Resources (Low, Normal, High, Maximum)
     - Ages (Starting/Ending age restrictions)
     - Vision (Map vision, team vision)
     - Diplomacy (Static teams, dynamic alliances, FFA)

2. **In-Game:**
   - Objectives display in top-left corner
   - Treaty timer (if enabled) shows in UI
   - Sacred sites/wonders highlighted with markers
   - Notifications for major events (eliminations, victories)

3. **Observer Mode:**
   - Join as observer/watch replay
   - Use observer UI controls to switch player perspectives
   - Toggle UI elements for clarity

---

## Development Notes

### Architecture Patterns

1. **Delegate System:**
   - All modules register via `Core_RegisterModule()`
   - Implement lifecycle delegates: `UpdateModuleSettings`, `PresetFinalize`, `OnPlay`, etc.
   - Execution order = registration order

2. **Centralized Configuration:**
   - All settings in `AGS_GLOBAL_SETTINGS` table
   - Modules read settings during `UpdateModuleSettings()`
   - Constants prefixed with `AGS_GS_`

3. **Team Abstraction:**
   - Use `player.AGS_Team` instead of `player.team`
   - AGS overwrites `player.team` on elimination/game end for correct display
   - Helper functions in `ags_teams.scar` for team queries

4. **Condition Framework:**
   - All win conditions use `AGS_Conditions_CheckVictory()`
   - Primary condition displays main objective
   - Secondary conditions can trigger (e.g., Elimination during Religious)

### Known Limitations

1. **State Wars DLC Dependencies:**
   - `startconditions/statewars/` requires State Wars DLC
   - `gameplay/statewars/` files check for DLC before activating

2. **Performance Considerations:**
   - 97 files imported = significant load time
   - Delegate chain can be deep (10+ modules per phase)
   - Observer UI adds overhead in replays

3. **AI Support:**
   - AI adjustments in `ai/ags_ai.scar` are basic
   - Complex conditions (Treaty, Team Solidarity) may confuse AI
   - Handicaps partially compensate

### Future Enhancements

- [ ] Modular loading (only import active conditions/modifiers)
- [ ] Performance profiling for delegate chains
- [ ] Enhanced AI behavior for custom conditions
- [ ] State Wars integration (full migration gameplay)
- [ ] Custom UI for settings preview
- [ ] Tournament presets (verified balance configs)

### Technical Debt

- **Tight coupling:** `ags_cardinal.scar` imports all systems (no conditional loading)
- **Global state:** `AGS_GLOBAL_SETTINGS` accessed directly by many modules
- **Magic numbers:** Some constants defined inline instead of in `ags_global_settings.scar`
- **Delegate overload:** Some phases call 3+ delegates (can be optimized)

---

## Contributing

When modifying Advanced Game Settings:

1. **Follow Naming Conventions:**
   - Module names: `AGS_[System]_MODULE`
   - Functions: `AGS_[System]_[Action]()`
   - Constants: `AGS_GS_[CATEGORY]_[VALUE]`

2. **Register Modules Correctly:**
   ```lua
   AGS_MYMODULE_MODULE = "AGS_MyModule"
   Core_RegisterModule(AGS_MYMODULE_MODULE)
   ```

3. **Implement Required Delegates:**
   - `UpdateModuleSettings()` — Read configuration
   - `PresetFinalize()` — Initialize state before game starts
   - `OnPlay()` — Begin gameplay logic

4. **Test Thoroughly:**
   - Single-player vs. AI
   - Multiplayer lobby (2v2, 3v3, 4v4)
   - Observer mode
   - Different win condition combinations

5. **Document Changes:**
   - Update `AGS_GLOBAL_SETTINGS_BUILD` version
   - Add comments explaining complex logic
   - Update this README if adding new systems

---

## Reference Documentation

- **SCAR API:** See [references/api/scar-api-functions.md](../../references/api/scar-api-functions.md)
- **Function Index:** See [reference/function-index.md](../../references/indexes/function-index.md)
- **Constants:** See [references/api/constants-and-enums.md](../../references/api/constants-and-enums.md)
- **Game Events:** See [references/api/game-events.md](../../references/api/game-events.md)
- **Cardinal Framework:** `import("cardinal.scar")` (Relic's base mission system)

---

## License

Age of Empires IV and Advanced Game Settings are © Relic Entertainment / Xbox Game Studios. This documentation is for educational/modding purposes only.
