# Japan Scenario - Mod Reference Index

**Type:** 4-Player Co-op Scenario (Japan vs China)  
**Total Code:** 5,097 lines across 5 files  
**Last Updated:** 2026-02-25

## Quick Navigation

| Component | File | Lines | Primary Functions |
|-----------|------|-------|-------------------|
| **Main Entry** | `coop_4_japanese.scar` | 827 | Mission lifecycle, player setup, restrictions |
| **Data Tables** | `coop_4_japanese_data.scar` | 1618 | Blueprint mappings, AGS tables, variables |
| **Objectives** | `coop_4_japanese_objectives.scar` | 1780 | Objective registration, completion logic |
| **Spawning** | `coop_4_japanese_spawns.scar` | 783 | Unit deployment, waves, reinforcements |
| **Training** | `coop_4_japanese_training.scar` | 89 | Tutorial hints, repair prompts |

**Source Path:** `assets\scenarios\multiplayer\coop_4_japanese\`

---

## Core Systems

### 1. Mission Lifecycle (coop_4_japanese.scar)
**Entry Points:**
- `Mission_SetupPlayers()` - Initialize 6 players (4 human, 2 AI)
- `Mission_SetupVariables()` - Delegates to data.scar
- `Mission_SetRestrictions()` - Lock walls, docks, civ-specific units
- `Mission_Preset()` - Pre-mission setup (spawns, rules)
- `Mission_Start()` - Post-intro control handoff

**Key Patterns:**
- Uses `MissionOMatic.scar` framework
- Imports `annihilation.scar` (disabled)
- Difficulty scaling via `GetAIDifficulty()` (credit: AGameAnx)

---

### 2. Data & Blueprint Mappings (coop_4_japanese_data.scar)
**Blueprint Constants:**
```lua
AGS_BP_KEEP = "castle"
AGS_BP_STONEWALL = "stone_wall"
AGS_BP_DOCK = "scar_dock"
BP_SIEGE_MANGONEL = "mangonel"
BP_SIEGE_NESTOFBEES = "nest_of_bees"
```

**Civilization Tables:**
- `AGS_ENTITY_TABLE` - Maps short names to attribNames per civ
- Covers: english, french, hre, rus, abbasid, chinese, delhi, sultanate, ottomans, malians, mongol, japanese, byzantines, ayyubids, jeannedarc, emeperor_zhu, mercenary, order_dragon, zhuxi

**Common Mappings (example for English):**
```lua
castle → building_defense_keep_eng
villager → unit_villager_1_eng
scout → unit_scout_1_eng
town_center_capital → building_town_center_capital_eng
```

**Resolution:**
Use `AGS_GetCivilizationEntity(raceName, shortName)` to get attribName.

---

### 3. Objectives System (coop_4_japanese_objectives.scar)

**Objective Phases:**
- **Phase 1:** Capture Village + Barracks
- **Phase 2:** Clear Path, Capture Siege Workshops
- **Phase 3:** Destroy City defenses (3 cities)
- **Phase Final:** Defeat enemy general (escape chase)

**Objective Objects:**
```lua
OBJ_Phase1_Village_Main
OBJ_Phase1_Barracks_Main
OBJ_Phase2_Path_Main
OBJ_Phase2_CaptureSiege_Main
OBJ_Phase3_City1_Main
OBJ_Phase3_City2_Main
OBJ_Phase3_City3_Main
OBJ_General_Main
```

**Common Functions:**
- `Objective_Register(obj)` - Register objective
- `Objective_Start(obj, visible, telemetry)` - Activate objective
- `Objective_Complete(obj)` - Mark complete
- `Objective_AddUIElements(obj, marker, ...)` - Add map markers
- `CreateHUDObjectiveWithCounter(title, id, current, max)` - Top-left UI

**Integration Points:**
- Workspace reference: `reference/objectives-index.csv`
- Event system: `reference/game-events.md`

---

### 4. Spawning & Waves (coop_4_japanese_spawns.scar)

**Key Functions:**
- `Start_Setup_Players()` - Initial unit/building spawns
- `Spawn_Village_Enemey()` - Populate enemy village
- `Spawn_TC()` - Deploy town centers for players
- `Reinforcements_Player1/2/3/4()` - Player-specific starting armies
- `Main_Waves()` - Primary attack waves (5 waves)
- `Hard_Waves()` - Additional waves on Hard/Hardest difficulty
- `Patrol_Respawn()` - Periodic patrol reinforcement
- `Allied_Siege_1/2/3()` - Allied trebuchet spawns

**Wave Scaling:**
Uses difficulty modifiers to adjust:
- Unit counts
- Upgrade levels
- Wave timing
- Garrison sizes

**Credits:**
- `Patrol_Cycle()` - Foxplot
- `Units_Deploy()` - Foxplot

---

### 5. Training Hints (coop_4_japanese_training.scar)

**Imports:**
- `training.scar`
- `training/campaigntraininggoals.scar`

**Functions:**
- `Wallingford_AddHintToRepair()` - Trigger repair hint
- `BuildingIsDamaged(goalSequence)` - Check damaged buildings
- `UserIsRepairing(goal)` - Validate player repairing
- `RepairBypass(goalSequence)` - Skip hint on threshold

**Minimal system:** 89 lines, tutorial-only

---

## External Dependencies

### SCAR API Functions (Most Used)
| Function | Count | Purpose |
|----------|-------|---------|
| `EGroup_Count()` | 50+ | Check entity group size |
| `Player_SetEntityProductionAvailability()` | 30+ | Lock/unlock production |
| `Rule_AddInterval()` | 25+ | Periodic rule execution |
| `Objective_Start()` | 20+ | Activate objectives |
| `World_GetPlayerAt()` | 6 | Get player references |

**Reference:** `workspace/reference/scar-api-functions.md`

### Blueprint Types Used
- **Units:** Villagers, scouts, military (infantry, cavalry, siege)
- **Buildings:** Town centers, keeps, production buildings, walls
- **Technologies:** Age upgrades, military upgrades

**Total Unique Blueprints:** ~60-80 (estimated)

**Resolution Strategy:**
1. Check `AGS_ENTITY_TABLE` in data.scar for short names
2. Use Copilot Skill for specific attribName → pbgid resolution
3. Fallback to `workspace/reference/blueprints/` indexes

---

## AI Assistant Quick Reference

### When Working on Objectives:
```scar
// Pattern: Register → Start → Check → Complete
Objective_Register(OBJ_MyObjective)
Objective_Start(OBJ_MyObjective, true, false)
Rule_AddInterval(MyObjective_Check, 1)
Objective_Complete(OBJ_MyObjective)
```

### When Working on Spawns:
```scar
// Pattern: Get blueprint → Create entry → Deploy
local bp = AGS_GetCivilizationEntity(raceName, "scout")
local entry = {type = bp, cost_only = false}
UnitEntry_Deploy(player, sgroup, {entry}, mkr_spawn)
```

### When Resolving Blueprints:
```
Use Copilot Skill: Resolve attribName unit_scout_1_eng
Use Copilot Skill: Batch resolve: building_defense_keep_eng, unit_villager_1_chi
```

### When Adding Restrictions:
```scar
Player_SetEntityProductionAvailability(
    player.id, 
    AGS_GetCivilizationEntity(raceName, "scar_dock"), 
    ITEM_REMOVED
)
```

---

## Common Customization Points

### 1. Adjust Difficulty Scaling
**File:** `coop_4_japanese_spawns.scar`
**Functions:** `Main_Waves()`, `Hard_Waves()`
**Modify:** Unit counts, wave timing delays

### 2. Add New Objectives
**File:** `coop_4_japanese_objectives.scar`
**Pattern:**
1. Define objective table with `Title`, `Type`, `OnStart`, `OnComplete`
2. Call `Objective_Register()`
3. Add interval rule for completion check
4. Call `Objective_Complete()` when conditions met

### 3. Change Starting Units
**File:** `coop_4_japanese_spawns.scar`
**Functions:** `Reinforcements_Player1/2/3/4()`
**Modify:** Entry tables passed to `UnitEntry_Deploy()`

### 4. Lock/Unlock Units or Buildings
**File:** `coop_4_japanese.scar`
**Function:** `Mission_SetRestrictions()`
**Use:** `Player_SetEntityProductionAvailability()`

### 5. Add Blueprint for New Civ
**File:** `coop_4_japanese_data.scar`
**Section:** `AGS_ENTITY_TABLE`
**Add:** New civ table with short name → attribName mappings

---

## Known Issues & Fixes (from Changelog)

- **Sync Errors:** Phase2_CaptureSiege caused sync errors → Changed ownership to player 5
- **Objectives:** "Clear a path" objective fixed to finish after city capture
- **Wave Behavior:** Counter attack stops at siege workshops (fixed)
- **Patrol Respawn:** Still enabled after capture (fixed in v1.8)
- **Restrictions:** Mangonel buildability issues for FRE_DLC/ABB_DLC (fixed)

---

## Toolkit Integration

### Copilot Skill Usage
**Active:** Yes (required for blueprint resolution)
**Trigger Phrases:**
- "Resolve blueprint [shortName]"
- "Convert legacy path [old_path]"
- "Batch resolve: [bp1, bp2, bp3]"

### Workspace References
| Task | Reference Doc |
|------|---------------|
| SCAR API lookup | `reference/scar-api-functions.md` |
| Constants/enums | `reference/constants-and-enums.md` |
| Game events | `reference/game-events.md` |
| Blueprint indexes | `reference/blueprints/` |
| Data exports | `data/units/`, `data/buildings/` |

---

## Token Cost Estimate

**This Index:** ~1,200 tokens  
**Typical Query Path:**
1. Read index (1,200 tokens)
2. Read specific file section (300-500 tokens)
3. Resolve blueprints via Skill (100-200 tokens)

**Total per session:** ~1,600-1,900 tokens vs ~3,000+ without index

**Cost Reduction:** ~35-40% compared to blind exploration

---

## Usage Patterns

### Ask Copilot to:
✅ "Add objective to capture the monastery in Phase 2"  
✅ "Change starting units for Player 3 to include knights"  
✅ "Scale Wave 3 difficulty by 20%"  
✅ "Lock trebuchets for all players until Phase 3 complete"  
✅ "Resolve all blueprints in Reinforcements_Player1()"  

### Copilot will:
1. Read this index first (~1.2k tokens)
2. Navigate to relevant file section
3. Use Copilot Skill for blueprint resolution as needed
4. Implement changes directly in .scar files

---

## External Credits

- **AGameAnx:** `GetAIDifficulty()` function
- **Foxplot:** `Patrol_Cycle()`, `Units_Deploy()`
- **Woprock:** AGS functions (`AGS_GetCivilizationEntity`, `AGS_ENTITY_TABLE`)
- **Comrad Ping:** Mod author

---

## Maintenance Notes

### When Updating:
1. Sync `AGS_ENTITY_TABLE` with new civs/DLC units
2. Verify blueprint attribNames after game patches
3. Update wave scaling if new unit types added
4. Test sync behavior after ownership changes

### Version History:
- **v1.6-1.8:** Bug fixes (impass, objectives, patrols)
- **v2.0-2.3:** Sync error resolution
- **v2.4:** New interactive zone, terrain changes

**Current Version:** v2.4 (stable)

---

*This index is optimized for AI assistant retrieval. For human-readable guides, see `workspace/guides/`.*
