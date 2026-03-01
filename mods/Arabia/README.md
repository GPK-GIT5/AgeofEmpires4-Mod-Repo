# CO-2 Arabia — AoE4 Co-op Scenario

[![AoE4 Version](https://img.shields.io/badge/AoE4-Content%20Editor-blue)](https://www.ageofempires.com/games/age-of-empires-iv/)
[![Scenario Type](https://img.shields.io/badge/Type-Co--op%20Multiplayer-green)](.)
[![Players](https://img.shields.io/badge/Players-2%20Co--op-orange)](.)

A 2-player cooperative scenario for Age of Empires IV featuring time-based objectives, dynamic reinforcements, and difficulty scaling. Created by **Comrad Ping** with special thanks to Foxplot and the AoE4 Modding Discord community.

---

## Project Description

**CO-2 Arabia** is a cooperative siege scenario where two players must work together to capture enemy settlements, destroy fortifications, and seize an Ottoman city before time runs out. The mission features:

- **Asymmetric Player Roles**: Player 1 focuses on melee/cavalry units, Player 2 on ranged units
- **Progressive Objectives**: Capture mining camps, seize gates, destroy siege workshops, and assault the keep
- **Dynamic Difficulty Scaling**: Four AI difficulty levels (Easy, Intermediate, Hard, Hardest) with adjusted timers, reinforcements, and enemy compositions
- **Civilization-Specific Unit Compositions**: Tailored starting units and reinforcements for all civilizations including DLC factions (Malians, Ottomans, Byzantines, etc.)
- **Timed Challenge**: Players must complete objectives before a countdown expires or face mission failure

---

## Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Game Engine** | Age of Empires IV — Essence Engine | Latest Patch |
| **Scripting Language** | SCAR (Lua-based) | AoE4 Editor |
| **Framework** | MissionOMatic.scar | Relic Framework |
| **Win Conditions** | Annihilation, Surrender, Elimination | Built-in |
| **Optional Module** | Day/Night Cycle (disabled by default) | Custom by Tommy |

### Core Dependencies

```lua
import("MissionOMatic/MissionOMatic.scar")     -- Mission framework
import("winconditions/annihilation.scar")      -- Victory/defeat conditions
import("winconditions/surrender.scar")         -- Player surrender support
import("winconditions/elimination.scar")       -- Disconnection handling
```

---

## Project Architecture

### High-Level Structure

```
CO-2 Arabia Scenario
├── Mission Lifecycle (Main Script)
│   ├── Mission_SetupPlayers()      → Player configuration & age restrictions
│   ├── Mission_SetupVariables()    → SGroup/EGroup initialization
│   ├── Mission_SetRestrictions()   → Building/unit restrictions per civ
│   ├── Mission_Preset()            → Pre-intro setup (objectives, AI)
│   └── Mission_Start()             → Post-intro execution (spawns, rules)
│
├── Data Layer (coop_2_arabia_data.scar)
│   ├── Unit_Types{}                → Unit composition tables
│   └── AGS_ENTITY_TABLE{}          → Per-civilization blueprint mappings
│
├── Objectives System (coop_2_arabia_objectives.scar)
│   ├── OBJ_SeizeCity               → Main timed objective (countdown)
│   ├── OBJ_CaptureEnemiesTown      → Capture mining camp
│   ├── OBJ_DestroyCheckpoint       → Seize city gates
│   ├── OBJ_DestroySiegeWorkshop    → Destroy siege facilities
│   └── OBJ_DestroyKeep             → Final assault on Ottoman keep
│
└── Optional Modules
    └── day_night_cycle.scar        → Environmental time progression
```

### Key Systems

#### 1. **Objective Chain System**
Sequential objective unlocking based on completion triggers:
```
OBJ_CaptureEnemiesTown → OBJ_DestroyCheckpoint → OBJ_DestroySiegeWorkshop → OBJ_DestroyKeep
                  ↓
              OBJ_SeizeCity (Parallel Timer)
```

#### 2. **Dynamic Reinforcement System**
- **Threshold-based**: Reinforcements spawn when player forces drop below 30% of starting strength
- **Location-adaptive**: Spawn locations switch from initial to captured settlements
- **Civilization-aware**: Faction-specific unit compositions

#### 3. **Difficulty Scaling**
| Difficulty | Timer | Starting Enemy Forces | Restrictions |
|-----------|-------|----------------------|--------------|
| Easy (0) | 80 min | Standard (26 units) | Upgrades granted, Keep production locked |
| Intermediate (1) | 80 min | Standard | Keep production locked |
| Hard (2) | 60 min | Increased (38 units) | Monk conversion disabled, Keep locked |
| Hardest (3+) | 45 min | Increased | Full restrictions |

---

## Getting Started

### Prerequisites

- **Age of Empires IV** (latest version)
- **Age of Empires IV Content Editor** (official modding tools)
- Basic understanding of:
  - SCAR scripting (Lua-based)
  - Content Editor interface (Scenario Tree, Object Browser)
  - Blueprint naming conventions

### Installation

1. **Clone or Download** the mod files to your AoE4 modding directory:
   ```
   Documents/My Games/Age of Empires IV/mods/Arabia/
   ```

2. **Open in Content Editor**:
   - Launch the AoE4 Content Editor
   - File → Open → Navigate to `mods/Arabia/`
   - Open `Coop_Arabia.aoe4mod`

3. **Build the Mod**:
   - In the Content Editor: **Build → Build Mod**
   - Wait for compilation to complete (check Console/Output panels for errors)

4. **Test in-game**:
   - Launch Age of Empires IV
   - Main Menu → Mods → Enable "CO-2 Arabia"
   - Create Lobby → Select "Coop 2 Arabia" scenario

### Configuration

#### Adjusting Difficulty
Modify AI difficulty in-game during lobby setup. The script auto-detects difficulty via player names:

```lua
function GetAIDifficulty(player)
    local AIPlayerNames = {
        [Loc_ToAnsi(1309)] = 0,     -- A.I. Easy
        [Loc_ToAnsi(1310)] = 1,     -- A.I. Intermediate
        [Loc_ToAnsi(1311)] = 2,     -- A.I. Hard
        [Loc_ToAnsi(1312)] = 3,     -- A.I. Hardest
    }
    return AIPlayerNames[Loc_ToAnsi(Player_GetDisplayName(player))] or 2
end
```

#### Enabling Day/Night Cycle
Uncomment line 23 in [coop_2_arabia.scar](assets/scenarios/multiplayer/coop_2_arabia/coop_2_arabia.scar):

```lua
import("day_night_cycle.scar")
```

**Requirements**: Atmosphere states `day`, `dawn`, `dusk`, `dusk2`, `night`, `night2` must be configured in the scenario file.

---

## Project Structure

```
mods/Arabia/
├── assets/
│   ├── scenarios/multiplayer/coop_2_arabia/
│   │   ├── coop_2_arabia.scar              # Main mission logic (851 lines)
│   │   ├── coop_2_arabia_data.scar         # Unit compositions & blueprints (300 lines)
│   │   ├── coop_2_arabia_objectives.scar   # Objective definitions (610 lines)
│   │   └── day_night_cycle.scar            # Optional environmental module (150 lines)
│   ├── mod.png                             # Mod thumbnail
│   └── mod.rdo                             # Win condition configuration
├── cache/                                  # Build artifacts (auto-generated)
├── .aoe4/                                  # Editor metadata
└── Coop_Arabia.aoe4mod                     # Mod package file
```

### File Responsibilities

| File | Purpose | Key Contents |
|------|---------|-------------|
| **coop_2_arabia.scar** | Mission orchestration | Player setup, restrictions, AGS_ENTITY_TABLE, reinforcement logic |
| **coop_2_arabia_data.scar** | Static game data | Unit_Types{} — 30+ unit composition tables for spawns/waves |
| **coop_2_arabia_objectives.scar** | Objective system | 5 primary objectives with UI callbacks, completion triggers |
| **day_night_cycle.scar** | Optional atmosphere | 6-state time cycle (day→dusk→night→dawn, 30min intervals) |

---

## Key Features

### ✅ Core Gameplay

- **Cooperative 2-Player Design**: Complementary roles (melee + ranged) encourage teamwork
- **Progressive Siege Campaign**: 5-stage objective chain with escalating difficulty
- **Countdown Timer**: Race against the clock (45-80 minutes depending on difficulty)
- **Smart Reinforcements**: Automatic unit deployments when player forces are low

### 🎮 Advanced Mechanics

- **Civilization-Specific Balancing**: All 16 civilizations supported with unique unit spawns
  - Example: Malians start with Donso + Javelin Throwers instead of standard Archers
  - Mongols use Khan scouts; Abbasid get Camel units
- **Dynamic AI Difficulty**: 
  - Enemy force scaling (26-38 starting units)
  - Adjusted countdown timers
  - Tech restrictions (e.g., no monk conversion on Hard+)
- **Patrol Behavior System**: Enemy units cycle between waypoints with attack-move commands
- **Capture Mechanics**: Location-based capture points with defender requirements

### 🔧 Technical Features

- **AGS (Advanced Game Settings) Integration**: Uses `AGS_ENTITY_TABLE` for blueprint resolution across all civilizations
- **Modular Objective System**: Each objective is self-contained with UI callbacks
- **Rule-Based State Machine**: Interval rules for patrols, proximity checks, reinforcement triggers
- **Error-Resilient Design**: Fallback spawn locations, force-complete conditions

---

## Development Workflow

### Branching Strategy
This mod follows a **feature-based workflow**:
- `main` — Stable release version
- `feature/*` — New features (e.g., `feature/add-ottoman-support`)
- `bugfix/*` — Bug fixes (e.g., `bugfix/reinforcement-spawn-location`)

### Testing Workflow

1. **Local Testing**:
   ```powershell
   # From Content Editor console
   print(AI_Difficulty)                          # Check detected difficulty
   print(SGroup_Count(sg_player1_start))         # Verify spawn counts
   Objective_Complete(OBJ_CaptureEnemiesTown)    # Force-complete objectives for testing
   ```

2. **Multi-Player Testing**:
   - Host lobby with AI set to desired difficulty
   - Test both player roles (melee/ranged)
   - Verify reinforcement triggers at 30% force threshold

3. **Civilization Coverage**:
   - Test each civilization variant in `Unit_Types` table
   - Confirm blueprints resolve correctly via `AGS_GetCivilizationEntity()`

### Debugging

Common issues and solutions:

| Issue | Diagnosis | Fix |
|-------|-----------|-----|
| Units not spawning | Check blueprint names in AGS_ENTITY_TABLE | Verify attribName via [Blueprint Resolution Skill](../../reference/.skill/SKILL-GUIDE.md) |
| Timer not starting | Objective UI setup failed | Check `SeizeCity_UI()` callback registration |
| Reinforcements spawn at wrong location | Rule trigger order | Ensure `SGroup_Count` thresholds evaluated correctly |
| Patrol cycle stops | SGroup cleared unexpectedly | Add debug prints in `Patrol_Cycle()` |

---

## Coding Standards

### SCAR Scripting Conventions

#### 1. **Naming Conventions**
```lua
-- Functions: PascalCase with descriptive verb prefixes
function Mission_Start()
function Reinforcements_Player1()
function Objective_Register()

-- Variables: snake_case with type prefixes
sg_player1_start        -- SGroup (Squad Group)
eg_siege_targets        -- EGroup (Entity Group)
mkr_spawn_location      -- Marker
i_destroyedCheckpoint   -- Integer counter

-- Constants: UPPER_SNAKE_CASE
AGS_BP_STONEWALL = "stone_wall"
```

#### 2. **Blueprint Management**
Always use `AGS_ENTITY_TABLE` for civilization-aware blueprint resolution:

```lua
-- ❌ AVOID: Hardcoded blueprints
Player_SetEntityProductionAvailability(player1, 
    BP_GetEntityBlueprint("building_defense_keep_eng"), ITEM_LOCKED)

-- ✅ CORRECT: Use AGS helper
Player_SetEntityProductionAvailability(player1, 
    AGS_GetCivilizationEntity(player.raceName, AGS_BP_KEEP), ITEM_LOCKED)
```

#### 3. **Rule Registration**
- Use descriptive context parameters for clarity:
```lua
Rule_AddInterval(Patrol_Cycle, 25, { 
    sgroup = sg_start_camp01, 
    spawn_loc = mkr_start_trader1, 
    dest_loc = mkr_start_trader2 
})
```

#### 4. **Comment Standards**
```lua
-- Section headers for major blocks
------------------------------------------- 
-- Objective Capture Mine
-------------------------------------------

-- Inline comments for complex logic
if SGroup_Count(sg_start_troops) < 0.1 * count_start_troop then
    Rule_RemoveMe()  -- Stop patrol when 90% eliminated
end
```

#### 5. **File Restrictions (Workspace Rule)**
Per [copilot-instructions.md](../../.github/copilot-instructions.md):
- **ONLY** edit `.scar` and `.md` files within `mods/` folder
- **DO NOT** modify `.scenario`, `.rdo`, or asset files directly (use Content Editor GUI)

---

## Testing

### Unit Testing Approach

This mod uses **manual console testing** via the Content Editor's built-in Lua console:

```lua
-- Test objective completion
Objective_Complete(OBJ_CaptureEnemiesTown, true, false)

-- Test reinforcement thresholds
print(SGroup_Count(sg_player1_start) / count_start_player1)

-- Verify blueprint resolution for a civilization
print(AGS_GetCivilizationEntity("ottoman", AGS_BP_KEEP))
```

### Integration Testing

1. **Objective Chain**:
   - Complete each objective in sequence
   - Verify subsequent objective auto-starts
   - Test timer countdown behavior at each difficulty

2. **Reinforcement Logic**:
   - Reduce player forces to <30% manually (delete squads)
   - Confirm reinforcements spawn at correct location
   - Test all civilization variants

3. **Difficulty Scaling**:
   - Play through mission at each AI difficulty (Easy→Hardest)
   - Verify enemy unit counts match expected values
   - Confirm timer adjustments (80/80/60/45 minutes)

### Test Coverage

| System | Coverage | Method |
|--------|----------|--------|
| Objective Triggers | ✅ Full | Manual playthrough |
| Civilization Variants | ⚠️ Partial | Tested 8/16 civs |
| Difficulty Scaling | ✅ Full | All 4 levels tested |
| Reinforcement Logic | ✅ Full | Threshold + location switching |
| Day/Night Cycle | ❌ Disabled | Optional module, not tested |

---

## Contributing

### Guidelines

1. **Read the Copilot Instructions**: Familiarize yourself with [.github/copilot-instructions.md](../../.github/copilot-instructions.md)
   - Understand Mods Folder Scope restrictions
   - Follow Console Command Generation rules for testing
   - Use Blueprint Resolution Skill for adding new unit types

2. **Code Exemplars**:
   ```lua
   -- Example: Adding a new civilization to AGS_ENTITY_TABLE
   byzantine = {
       castle = "building_defense_keep_byz",
       town_center = "building_town_center_byz",
       villager = "unit_villager_1_byz",
       -- ... add all required blueprint mappings
   }
   ```

3. **Submission Process**:
   - Fork the repository
   - Create a feature branch: `feature/add-byzantine-support`
   - Make changes **only to .scar or .md files**
   - Test thoroughly (see [Testing](#testing) section)
   - Submit pull request with:
     - Description of changes
     - Test results (which civs/difficulties tested)
     - Screenshots/video if applicable

4. **Blueprint Reference**:
   When adding new units or buildings:
   - Consult [reference/blueprints/](../../reference/blueprints/) for attribName lookup
   - Use [data-index.md](../../reference/data-index.md) for unit stats
   - Follow [SCAR API Reference](../../reference/scar-api-functions.md) for function signatures

### Areas for Contribution

- [ ] **DLC Civilization Support**: Add Byzantine, Zhu Xi's Legacy civilization variants
- [ ] **Difficulty Balancing**: Tune enemy spawn counts/timers based on community feedback
- [ ] **Optional Objectives**: Add secondary objectives (collect relics, save villagers)
- [ ] **Day/Night Optimization**: Fix shadow flickering issues in atmosphere module
- [ ] **Localization**: Add string table support for non-English languages

---

## License

This mod is provided **as-is** for community use. 

- **Created by**: Comrad Ping
- **Special Thanks**: Foxplot, AoE4 Modding Discord community, Tommy (Day/Night Cycle)
- **Engine**: Age of Empires IV © Microsoft / Relic Entertainment

For questions about modding tools and SCAR API, consult:
- [Official AoE4 Modding Guides](../../official-guides/01-getting-started.md)
- [AoE4 Modding Discord](https://discord.gg/aoe4mods) *(note: verify current invite link)*

---

## Additional Resources

### Workspace References

- **SCAR API Functions**: [reference/scar-api-functions.md](../../reference/scar-api-functions.md)
- **Constants & Enums**: [reference/constants-and-enums.md](../../reference/constants-and-enums.md)
- **Game Events**: [reference/game-events.md](../../reference/game-events.md)
- **Objective System Index**: [reference/objectives-index.csv](../../reference/objectives-index.csv)

### Official Guides

1. [Getting Started with AoE4 Modding](../../official-guides/01-getting-started.md)
2. [Content Editor Interface Overview](../../official-guides/02-editor-interface.md)
3. [SCAR Scripting Basics](../../guides/scar-scripting-basics.md)

### Related Mods

- **Japan Co-op Scenario**: [mods/Japan/](../Japan/) — 4-player co-op with DLC civ restrictions
- **CBA Mod Summary**: [mods/cba-mod-summary.md](../cba-mod-summary.md) — Community balance adjustments

---

**Last Updated**: February 28, 2026  
**Mod Version**: 1.0 (Stable)  
**Tested With**: AoE4 Patch [Current]
