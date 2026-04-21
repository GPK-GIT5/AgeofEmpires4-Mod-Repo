# AI_INDEX.md — Advanced Game Settings (AGS)

**Purpose:** Canonical AI reference for AGS system architecture, navigation, and key concepts.  
**Version:** 4.2.0.5  
**Type:** AoE4 Multiplayer Gamemode Framework  
**Authors:** Relic Entertainment, Woprock

---

<!-- DOC:META:OVERVIEW -->
## System Overview

Advanced Game Settings (AGS) is a modular gamemode framework for Age of Empires IV providing:
- **Win Conditions:** 11 pluggable victory systems (Conquest, Religious, Wonder, Regicide, Score, Treaty, Elimination, Annihilation, Team Solidarity, Surrender, Culture)
- **Starting Scenarios:** 7 configurations (Settled, Nomadic, Fortified, Scattered, Keep, King, Scout) + State Wars DLC
- **Gameplay Modifiers:** 30+ settings (resources, ages, vision, population, handicaps, restrictions)
- **Diplomacy:** 3 team modes (FFA, Static, Dynamic) with tributes and relations
- **AI Support:** Adaptive behavior with handicaps
- **Observer UI:** Player switching and replay controls

**Architecture:** Delegate-based lifecycle extending Cardinal.scar framework.  
**Codebase:** 97 .scar files, ~15,000 lines across 14 subsystems.

---

<!-- DOC:ARCH:FILE_STRUCTURE -->
## Architecture Map

```
Advanced Game Settings/
├── assets/scar/
│   ├── ags_cardinal.scar           ← Entry point (285 lines)
│   ├── ags_global_settings.scar    ← Config table (1,189 lines, 100+ constants)
│   │
│   ├── conditions/                 ← Win/loss conditions (11 modules)
│   │   ├── ags_conquest.scar
│   │   ├── ags_religious.scar
│   │   ├── ags_wonder.scar
│   │   ├── ags_regicide.scar
│   │   ├── ags_score.scar
│   │   └── conditiondata/          ← Data files (11 modules)
│   │
│   ├── startconditions/            ← Starting scenarios (7 + 3 DLC)
│   │   ├── ags_start_settled.scar
│   │   ├── ags_start_nomadic.scar
│   │   ├── ags_start_fortified.scar
│   │   └── statewars/              ← DLC scenarios (3 modules)
│   │
│   ├── gameplay/                   ← Game modifiers (30+ modules)
│   │   ├── ags_starting_resources.scar
│   │   ├── ags_starting_age.scar
│   │   ├── ags_population_capacity.scar
│   │   ├── ags_map_vision.scar
│   │   └── statewars/              ← DLC features (3 modules)
│   │
│   ├── coreconditions/             ← Condition framework (5 modules)
│   │   ├── ags_conditions.scar          ← Victory/defeat logic
│   │   ├── ags_conditions_match.scar    ← Match state
│   │   ├── ags_conditions_objectives.scar
│   │   ├── ags_conditions_notifications.scar
│   │   └── ags_conditions_presentations.scar
│   │
│   ├── helpers/                    ← Utility modules (3)
│   │   ├── ags_teams.scar          ← Team API (332 lines)
│   │   ├── ags_starts.scar         ← Starting config
│   │   └── ags_blueprints.scar     ← Blueprint helpers
│   │
│   ├── diplomacy/                  ← Diplomatic systems (5 + 1 template)
│   │   ├── ags_diplomacy.scar
│   │   ├── ags_relations.scar
│   │   ├── ags_tributes.scar
│   │   └── ags_diplomacy_ui.scar
│   │
│   ├── ai/                         ← AI adjustments (1)
│   │   └── ags_ai.scar
│   │
│   ├── gamemodes/                  ← Preset configurations (5)
│   │   ├── ags_standard.scar
│   │   ├── ags_nomad.scar
│   │   └── ags_tournament_nomad.scar
│   │
│   ├── replay/                     ← Observer UI (4 + 4 XAML)
│   │   ├── observerui.scar
│   │   └── xaml/                   ← UI controls
│   │
│   ├── specials/                   ← Utilities (3)
│   │   ├── ags_utilities.scar
│   │   └── ags_match_ui.scar
│   │
│   └── balance/                    ← Balance tweaks (1)
│       └── ags_tournament_nomad_balance.scar
```

**Entry Flow:** Gamemode imports `ags_cardinal.scar` → Cardinal imports all subsystems → Delegates execute in registration order.

---

<!-- DOC:ARCH:DELEGATE_LIFECYCLE -->
## Delegate Lifecycle

AGS extends Cardinal's mission lifecycle with 6 phases:

| Phase | Function | Purpose | Timing | Delegates Invoked |
|-------|----------|---------|--------|-------------------|
| 1 | `AGS_Cardinal_OnGameSetup()` | Read win condition options from lobby | Pre-init | `SetupSettings`, `AdjustSettings`, `UpdateModuleSettings` |
| 2 | `AGS_Cardinal_OnInit()` | Early module initialization | Init | `EarlyInitializations` |
| 3 | `AGS_Cardinal_PostInit()` | Late module initialization | Init | `LateInitializations` |
| 4 | `AGS_Cardinal_Preset()` | Spawn entities, apply vision | Pre-start | `PresetInitialize`, `PresetExecute`, `PresetFinalize` |
| 5 | `AGS_Cardinal_PreStart()` | Final preparations before game start | 1 frame before start | `PrepareStart` |
| 6 | `AGS_Cardinal_Start()` | Game begins, start monitoring | Start | `OnStarting`, `OnPlay` |

**Module Registration:**
```lua
AGS_ModuleName_MODULE = "AGS_ModuleName"
Core_RegisterModule(AGS_ModuleName_MODULE)
```

**Execution Order:** First registered = first executed within each phase.

**Common Delegate Pattern:**
```lua
function AGS_ModuleName_UpdateModuleSettings()    -- Phase 1: Read config
function AGS_ModuleName_PresetFinalize()          -- Phase 4: Initialize
function AGS_ModuleName_OnPlay()                  -- Phase 6: Start monitoring
```

---

<!-- DOC:ARCH:CONFIGURATION -->
## Global Configuration

**Source:** `ags_global_settings.scar` (1,189 lines)

**Primary Table:** `AGS_GLOBAL_SETTINGS` — Centralized config with 100+ options.

**Constant Naming:** `AGS_GS_[CATEGORY]_[VALUE]`

**Key Categories:**

| Category | Pattern | Examples |
|----------|---------|----------|
| Team Victory | `AGS_GS_TEAM_VICTORY_*` | `FFA`, `STANDARD`, `DYNAMIC` |
| Settlement | `AGS_GS_SETTLEMENT_*` | `SCATTERED`, `NOMADIC`, `SETTLED`, `FORTIFIED` |
| Ages | `AGS_GS_AGE_*` | `DARK`, `FEUDAL`, `CASTLE`, `IMPERIAL` |
| Resources | `AGS_GS_RESOURCES_*` | `LOW`, `NORMAL`, `HIGH`, `MAXIMUM` |
| TC Restrictions | `AGS_GS_TC_RESTRICTIONS_*` | `NONE`, `NORMAL`, `LANDMARKS` |
| Vision | `AGS_GS_MAP_VISION_*` | `CONCEALED`, `EXPLORED`, `REVEALED` |
| Team Vision | `AGS_GS_TEAM_VISION_*` | `NONE`, `REQUIRES_MARKET`, `ALWAYS` |
| Handicap | `AGS_GS_HANDICAP_TYPE_*` | `DISABLED`, `ECONOMIC`, `MILITARY`, `BOTH` |
| Colors | `AGS_GS_COLOR_*` | `BLUE`, `RED`, `YELLOW`, etc. |

**Local Player Reference:** `AGS_GS_LOCAL_PLAYER` — Used for UI/visual logic only (not gameplay, to avoid desync).

---

<!-- DOC:NAV:WHERE_TO_FIND -->
## Navigation: Where to Find X

### Win Conditions

**Location:** `assets/scar/conditions/`  
**Count:** 11 conditions + 11 data files

| Condition | File | Victory Trigger | Key Delegates |
|-----------|------|-----------------|---------------|
| Conquest | `ags_conquest.scar` | Destroy all landmarks | `OnStructureKilled` |
| Religious | `ags_religious.scar` | Control sacred sites 10min | `OnStrategicPointChanged`, `OnTimerTick` |
| Wonder | `ags_wonder.scar` | Build + defend wonder 15min | `OnConstructionComplete`, timer |
| Regicide | `ags_regicide.scar` | Kill enemy king units | `OnEntityKilled` |
| Score | `ags_score.scar` | Highest score at time limit | Timer-based |
| Treaty | `ags_treaty.scar` | Post-treaty combat | `TreatyStarted`, `TreatyEnded` |
| Elimination | `ags_elimination.scar` | Player quits | `OnPlayerDefeated` |
| Annihilation | `ags_annihilation.scar` | Destroy everything | Entity checks |
| Team Solidarity | `ags_team_solidarity.scar` | Team-wide elimination | Team state |
| Surrender | `ags_surrender.scar` | Manual surrender | UI callback |
| Culture | `ags_culture.scar` | Cultural victory | Custom logic |

**Shared Framework:** `coreconditions/ags_conditions.scar`  
**Victory Function:** `AGS_Conditions_CheckVictory(is_allowed, presentation_func, reason, opt_objective)`

---

### Starting Scenarios

**Location:** `assets/scar/startconditions/`  
**Count:** 7 base + 3 State Wars DLC

| Scenario | File | Description | Entity Modifications |
|----------|------|-------------|---------------------|
| Settled | `ags_start_settled.scar` | Standard AoE4 start | None (default) |
| Nomadic | `ags_start_nomadic.scar` | No Town Center | Remove TC, add villagers |
| Fortified | `ags_start_fortified.scar` | Defensive start | Add walls, towers, scout |
| Scattered | `ags_start_scattered.scar` | Randomized resources | Adjust resource proximity |
| Keep | `ags_starting_keep.scar` | Keep instead of TC | Replace TC blueprint |
| King | `ags_starting_king.scar` | Extra king unit | Spawn additional king |
| Scout | `ags_starting_scout.scar` | Scout cavalry | Add scout unit |

**State Wars DLC:**
- `statewars/ags_start_pilgrims.scar` — Migration scenario
- `statewars/ags_start_city.scar` — Pre-built cities
- `statewars/ags_starting_cities.scar` — City locations

**Execution Phase:** Phase 4 (`PresetFinalize`)

---

### Gameplay Modifiers

**Location:** `assets/scar/gameplay/`  
**Count:** 30+ modules

**Categories:**

| Category | Files | Key Functions |
|----------|-------|---------------|
| **Resources** | `ags_starting_resources.scar`, `ags_game_rates.scar`, `ags_treasures.scar` | Set stockpiles (0-999,999), gather multipliers |
| **Ages** | `ags_starting_age.scar`, `ags_ending_age.scar`, `ags_technology_age.scar` | Age start/lock, tech availability |
| **Vision** | `ags_map_vision.scar`, `ags_team_vision.scar`, `ags_reveal_spawn.scar` | Concealed/explored/revealed, shared vision |
| **Population** | `ags_population_capacity.scar`, `ags_house_modifier.scar` | Limits (25-1000), house capacity |
| **Balance** | `ags_handicaps.scar`, `ags_team_balance.scar` | Economic/military bonuses, auto-balance |
| **Buildings** | `ags_town_center_restrictions.scar`, `ags_wonder_construction.scar`, `ags_no_dock.scar` | TC rules, wonder enable/disable |
| **Other** | `ags_simulation_speed.scar`, `ags_ding.scar`, `ags_color_maintainer.scar` | Game speed, audio cues, color fixes |

**State Wars DLC:**
- `statewars/ags_reveal_cities.scar`
- `statewars/ags_statewars_bonuses.scar`
- `statewars/ags_relicization.scar`

**Execution Phase:** Phases 4-6 (varies by modifier)

---

### Diplomacy System

**Location:** `assets/scar/diplomacy/`  
**Count:** 5 modules + 1 Xbox template

| Module | Purpose | Key Functions |
|--------|---------|---------------|
| `ags_diplomacy.scar` | Core diplomacy engine | Team mode enforcement |
| `ags_relations.scar` | Alliance/enemy state | `AGS_Relations_SetRelationship()` |
| `ags_tributes.scar` | Resource transfers | Tribute validation, transfer logic |
| `ags_diplomacy_ui.scar` | UI integration | Diplomatic action callbacks |
| `diplomacy_xbox_template.scar` | Xbox platform template | Console-specific logic |

**Team Victory Modes:**
- `AGS_GS_TEAM_VICTORY_FFA = 0` — Free-for-all (no permanent teams)
- `AGS_GS_TEAM_VICTORY_STANDARD = 1` — Static teams from lobby
- `AGS_GS_TEAM_VICTORY_DYNAMIC = 2` — Players can shift alliances in-game

**API Source:** `helpers/ags_teams.scar` (332 lines)

---

### Observer/Replay UI

**Location:** `assets/scar/replay/`  
**Count:** 4 .scar + 4 XAML controls

| Module | Purpose |
|--------|---------|
| `observerui.scar` | Main observer logic |
| `observeruirules.scar` | Visibility rules |
| `observeruiupdateui.scar` | UI refresh logic |
| `ags_replay.scar` | Replay-specific features |

**XAML Controls:**
- `xaml/toggleuibutton.scar` — Toggle UI visibility
- `xaml/swapplayers1v1button.scar` — 1v1 player switching
- `xaml/observe2players.scar` — 2v2+ observer controls
- `xaml/observenplayers.scar` — N-player observer

**Use Case:** Spectating, casting, replay analysis.

---

### Global Settings & Constants

**Location:** `assets/scar/ags_global_settings.scar` (1,189 lines)

**Access Pattern:**
```lua
-- Read settings
if AGS_GLOBAL_SETTINGS.Annihilation then
    -- Annihilation win condition enabled
end

-- Use constants
if AGS_GLOBAL_SETTINGS.StartingAge == AGS_GS_AGE_FEUDAL then
    -- Start in Feudal Age
end
```

**Module-Specific Constants:** Often defined in condition/modifier files (e.g., `ags_religious.scar` has Sacred Sites constants).

**Build Version:** `AGS_GLOBAL_SETTINGS_BUILD = "4.2.0.5"`

---

### Team Management API

**Location:** `helpers/ags_teams.scar` (332 lines)

**Key Functions:**

| Function | Returns | Purpose |
|----------|---------|---------|
| `AGS_Teams_CreateInitialTeams()` | void | Initialize team structures from lobby |
| `AGS_Teams_DoesWinnerGroupExists()` | table or nil | Returns winning team(s) or nil |
| `AGS_Teams_IsSingleTeamSandbox()` | boolean | Detect co-op mode (all players on same team) |
| `AGS_Teams_GetActiveTeamCount()` | integer | Count remaining teams |
| `AGS_Teams_GetTeamPlayers(team_index)` | table | Get all players on team |

**Data Structure:**
```lua
player.AGS_Team.index    -- Team ID
player.AGS_Team.allies   -- Table of allied players
```

**Important:** AGS overwrites `player.team` on elimination/game end for correct post-game display.

---

### Condition Framework

**Location:** `coreconditions/` (5 modules)

**Core Module:** `ags_conditions.scar` (74 lines)

**Universal Victory Function:**
```lua
AGS_Conditions_CheckVictory(
    is_allowed_to_check,      -- boolean: Can check now?
    presentation_function,     -- function: Victory screen callback
    reason,                    -- WinReason enum
    opt_objective              -- (optional) Objective ID
)
```

**Supporting Modules:**

| Module | Purpose | Key Functions |
|--------|---------|---------------|
| `ags_conditions_match.scar` | Match state tracking | `AGS_SetPlayerVictorious()`, `AGS_EndGame()` |
| `ags_conditions_objectives.scar` | Objective creation/updates | `AGS_Objectives_Create()`, `AGS_Objectives_Update()` |
| `ags_conditions_notifications.scar` | Player notifications | `AGS_Notifications_Eliminated()`, etc. |
| `ags_conditions_presentations.scar` | Victory/defeat presentations | `AGS_Presentations_Victory()`, `AGS_Presentations_Defeat()` |

**Primary Condition:** Only one condition per match can be "primary" (displays main objective).

---

### Preset Gamemodes

**Location:** `assets/scar/gamemodes/`  
**Count:** 5 presets

| Gamemode | File | Configuration | Use Case |
|----------|------|---------------|----------|
| Standard | `ags_standard.scar` | Default AGS settings | Competitive matches |
| Nomad | `ags_nomad.scar` | No starting TC | Migration gameplay |
| King of the Hill | `ags_koth.scar` | Control points | Unique objective |
| City States | `ags_city_states.scar` | Pre-built cities | State Wars DLC |
| Tournament Nomad | `ags_tournament_nomad.scar` | Balanced nomad | Competitive nomad |

**Pattern:** Each gamemode imports `ags_cardinal.scar` and overrides specific delegates for custom behavior.

**Balance Adjustments:** `balance/ags_tournament_nomad_balance.scar` contains gamemode-specific balance tweaks.

---

<!-- DOC:ARCH:CORE_DEPENDENCIES -->
## Core Dependencies

**Required Imports (in order):**
```lua
import("cardinal.scar")                          -- Relic's base framework
import("helpers/ags_blueprints.scar")           -- Blueprint management
import("helpers/ags_teams.scar")                -- Team tracking API
import("helpers/ags_starts.scar")               -- Starting configuration
import("coreconditions/ags_conditions.scar")    -- Condition framework
import("ags_global_settings.scar")              -- Centralized config
```

**Cardinal Framework:** AGS extends Cardinal's delegate-based mission system. Cardinal provides:
- Module registration: `Core_RegisterModule()`
- Delegate invocation: `Core_CallDelegateFunctions()`
- Base lifecycle: `OnGameSetup`, `OnInit`, `OnPlay`

**AGS Extensions:** Additional phases (`PostInit`, `Preset`, `PreStart`) + subsystem orchestration.

---

<!-- DOC:PATTERNS:MODULE_STRUCTURE -->
## Module Implementation Pattern

**Standard Module Structure:**

```lua
---------------------------------------------------------------------------------------------------
-- Module Declaration
---------------------------------------------------------------------------------------------------
AGS_ModuleName_MODULE = "AGS_ModuleName"

-- Local state (if needed)
local _module_data = { }

---------------------------------------------------------------------------------------------------
-- Delegates
---------------------------------------------------------------------------------------------------
Core_RegisterModule(AGS_ModuleName_MODULE)

-- Phase 1: Read configuration
function AGS_ModuleName_UpdateModuleSettings()
    if AGS_GLOBAL_SETTINGS.SomeOption then
        -- Store local state
    end
end

-- Phase 4: Initialize before game starts
function AGS_ModuleName_PresetFinalize()
    -- Spawn entities, set up objectives
end

-- Phase 6: Begin gameplay logic
function AGS_ModuleName_OnPlay()
    -- Start monitoring, register events
end

-- Event callbacks
function AGS_ModuleName_OnPlayerDefeated(player, reason)
    -- Handle elimination
end

function AGS_ModuleName_OnGameOver()
    -- Cleanup
end

---------------------------------------------------------------------------------------------------
-- Functions (module-specific logic)
---------------------------------------------------------------------------------------------------
function AGS_ModuleName_CheckVictory()
    -- Local helper functions
end
```

**Naming Conventions:**
- Modules: `AGS_[System]_MODULE`
- Functions: `AGS_[System]_[Action]()`
- Constants: `AGS_GS_[CATEGORY]_[VALUE]`

---

<!-- DOC:PATTERNS:VICTORY_FLOW -->
## Victory Flow Pattern

**Standard Win Condition Flow:**

1. **Setup Phase (`UpdateModuleSettings`):**
   ```lua
   function AGS_WinCondition_UpdateModuleSettings()
       if not AGS_GLOBAL_SETTINGS.WinCondition then
           return  -- Condition disabled
       end
       -- Read condition-specific settings
   end
   ```

2. **Initialize Phase (`PresetFinalize`):**
   ```lua
   function AGS_WinCondition_PresetFinalize()
       -- Create objectives, initialize tracking
       AGS_WinCondition_CreateObjective()
   end
   ```

3. **Start Phase (`OnPlay`):**
   ```lua
   function AGS_WinCondition_OnPlay()
       -- Register event callbacks, start timers
       Rule_AddInterval(AGS_WinCondition_OnTimerTick, 1)
   end
   ```

4. **Monitor Phase (event callbacks):**
   ```lua
   function AGS_WinCondition_OnEventTrigger(context)
       -- Update state, check victory
       AGS_WinCondition_TryDeclareWinners()
   end
   ```

5. **Victory Check:**
   ```lua
   function AGS_WinCondition_TryDeclareWinners()
       local is_victory_achieved = AGS_Conditions_CheckVictory(
           should_check,
           AGS_Presentations_WinConditionVictory,
           WR_WIN_CONDITION,
           objective_id
       )
   end
   ```

**Shared Victory Logic:** `AGS_Conditions_CheckVictory()` handles winner resolution, presentations, and game ending.

---

<!-- DOC:TECH:AI_SUPPORT -->
## AI Support

**Location:** `ai/ags_ai.scar` (1 module)

**Purpose:** Adjust AI behavior for AGS-specific conditions and modifiers.

**Key Adjustments:**
- Handicap application (economic/military bonuses)
- Starting resource compensation
- Age progression adjustments
- Population capacity awareness

**Limitations:**
- AI struggles with complex conditions (Treaty, Team Solidarity)
- Dynamic diplomacy may confuse AI alliance logic
- Sacred Sites and Wonder victory not fully optimized

**Compensations:** Handicaps and resource bonuses help balance AI performance.

---

<!-- DOC:TECH:KNOWN_ISSUES -->
## Known Limitations

1. **Performance:**
   - 97 files imported = significant load time
   - Delegate chains can be deep (10+ modules per phase)
   - No conditional loading (all systems imported regardless of use)

2. **State Wars DLC:**
   - `startconditions/statewars/` requires DLC ownership
   - `gameplay/statewars/` checks for DLC before activating
   - Some features unavailable without DLC

3. **AI Support:**
   - Basic adjustments only
   - Complex conditions may confuse AI
   - Handicaps only partially compensate

4. **Tight Coupling:**
   - `ags_cardinal.scar` imports all subsystems
   - No modular loading based on enabled features
   - Global state (`AGS_GLOBAL_SETTINGS`) accessed directly

---

<!-- DOC:REF:EXTERNAL_DOCS -->
## External References

**Workspace Documentation:**
- SCAR API: `../../references/api/scar-api-functions.md`
- Function Index: `../../references/indexes/function-index.md`
- Constants: `../../references/api/constants-and-enums.md`
- Game Events: `../../references/api/game-events.md`

**Comprehensive Documentation:**
- Full README: `../README.md` (427 lines, complete system documentation)

**Source Code:**
- Entry Point: `../assets/scar/ags_cardinal.scar` (285 lines)
- Global Config: `../assets/scar/ags_global_settings.scar` (1,189 lines)
- All Subsystems: `../assets/scar/` (14 subdirectories)

---

<!-- DOC:META:CHANGELOG -->
## Document Metadata

**Created:** 2026-03-01  
**Version:** 1.0  
**Type:** AI Reference Index  
**Parent:** README.md (v4.2.0.5)  
**Scope:** Navigation and architectural reference (not comprehensive documentation)

**Update Triggers:**
- Major architecture changes (lifecycle phases, delegate patterns)
- New subsystems added (e.g., new win conditions, modifiers)
- AGS version increments (update build number)
- Navigation structure changes

**Maintenance:** Sync with README.md when major sections change.
