# Castle Blood Automatic (CBA) — Mod Summary

> Custom AoE4 game mode where units auto-spawn at each player's castle and fight. Players age up by accumulating kills instead of gathering resources.

---

## File Overview

| File | Role |
|---|---|
| `cba 2023 all-in-one.scar` | **Main entry point** — game setup, spawn loop, kill tracking, age-ups, victory logic |
| `gameplay/cba_items.scar` | Per-civ blueprint tables + item/upgrade lockouts + civ-specific starting conditions |
| `gameplay/cba_event_cues.scar` | Age-up notification event cues |
| `gameplay/spawnbehavior.scar` | Team assignment, vision sharing, player colors *(currently disabled)* |
| `gameplay/holysite.scar` | Religious (Holy Site) win condition *(currently disabled)* |
| `gameplay/ownscore.scar` | Score tracking (military/economy/society/tech) — customized for CBA |
| `winconditions/ownsurrender.scar` | Surrender handling — destroys all player assets, checks victory |
| `winconditions/ownelimination.scar` | Disconnect/quit handling — same cleanup + victory check |
| `winconditions/cba_ui.scar` | In-game "Info" button + togglable panel showing per-civ balance stats |

---

## How the Mod Works

### Game Flow

1. **`Mod_OnInit()`** — Kills neutral walls, gives 99999 resources, sets all players to Age 2, spawns castles/buildings/towers per player, locks most construction/siege/upgrades, starts the unit spawn timer, registers kill/gate/construction event handlers
2. **`Mod_Start()`** — Creates 3 player objectives: reach kill threshold, destroy enemy castles, destroy gates
3. **`Mod_SpawnUnits()`** *(runs on interval)* — For each alive player under pop cap, spawns their unique unit at their castle and orders it toward the enemy. Spawn count = number of surviving castles
4. **`Mod_StoreKills()`** *(GE_EntityKilled)* — Tracks kills per player. Elephants count as 3. When kill thresholds are met, triggers age-up to Age 3 or Age 4 with an event cue notification
5. **`Mod_StoreGate()`** — Tracks destroyed gates/buildings. When threshold met, spawns 2 villagers for the player (if enabled)
6. **`Mod_CastleDeath()`** — When a castle is destroyed: recount castles. If 0 remain → kill all player assets → eliminate player → check victory

### Win/Loss Conditions

- **Victory:** Last player/team standing (all enemy castles destroyed)
- **Defeat paths:** Castle destruction (main), surrender (pause menu), disconnect/quit
- All three paths destroy the player's units/buildings and then check if any surviving player has zero enemies remaining

---

## Key Data Structures

### `_modStartTable` *(main file)*
Per-civ balance settings for all 22 civilizations (base + variants):

| Field | Purpose |
|---|---|
| `player_spawnrate` | Unit spawn interval multiplier |
| `pop` | Population cap |
| `GateRequired` | Number of buildings/gates to destroy before villagers spawn |
| `KillsAge3Required` | Kill count needed to reach Castle Age |
| `KillsAge4Required` | Kill count needed to reach Imperial Age |

Civs: `english`, `french`, `rus`, `hre`, `mongol`, `chinese`, `sultanate`, `abbasid`, `ottoman`, `malian`, `japanese`, `byzantine`, `lancaster`, `templar`, + variant civs (`abbasid_ha_01`, `french_ha_01`, `chinese_ha_01`, `hre_ha_01`, `sultanate_ha_tug`, `japanese_ha_sen`, `byzantine_ha_mac`, `mongol_ha_gol`)

### `_modBlueprintTable` *(main file)*
Per-civ spawning blueprints:

| Field | Purpose |
|---|---|
| `ebp_building` | Castle entity blueprint |
| `ebp_building_bs` | Blacksmith entity blueprint |
| `ebp_building_uni` | University entity blueprint |
| `ebp_building_tower` | Tower entity blueprint |
| `sbp_unique` | Auto-spawned unique unit (squad blueprint) |
| `sbp_villager` | Villager squad blueprint |
| `sbp_king` | King unit squad blueprint |

### `CBA_ENTITY_TABLE` *(cba_items.scar)*
Per-civ entity/squad blueprints used for **locking production**:

- Buildings: `castle`, `town_center`, `market`, `house_of_wisdom`, `palisade_wall/gate`, `dock`, `house`, `outpost`, `farm`, `miningcamp`, `mill`, `lumbercamp`, `stone_wall/gate/tower`
- Siege units: `springald`, `mangonel`, `trebuchet`, `culverin`, `bombard`, `ribauldequin`
- Civ-specific extras: Mongol packed buildings, Byzantine cistern/aqueduct, Malian cattle/pitmine, etc.

### `_modSpawnTable` *(main file)*
8 hardcoded player slots with XYZ positions for castle, blacksmith, university, towers, and marker references for unit pathing (close/mid/far destinations).

---

## File Details

### `cba 2023 all-in-one.scar` — Main File

**Imports:** `cardinal`, `ScarUtil`, `ownscore`, `CBA_items`, `ownelimination`, `ownsurrender`, `current_dynasty_ui`, `cheat`, `CBA_event_cues`, `CBA_UI`

| Function | Purpose |
|---|---|
| `Mod_OnGameSetup()` | Initialize options |
| `Mod_PreInit()` | Read win condition options, optionally show score |
| `Mod_OnInit()` | Main init — UI, cleanup walls, stats, events, castles, spawns, locks |
| `Mod_Start()` | Set up 3 objectives |
| `Mod_PlayerStartingStats()` | Explore map, set age 2, give resources, assign per-civ stats |
| `Mod_SpawnUnits()` | Core spawn loop (interval rule) |
| `Mod_StoreKills(context)` | Kill tracking + age-up logic |
| `Mod_StoreGate(context)` | Gate/building destruction tracking + villager spawn |
| `Mod_CastleDeath(context)` | Castle death → player elimination |
| `Mod_FindCastle()` | Find each player's starting castle |
| `Mod_SpawnCastles()` | Spawn extra castles, blacksmith, university, towers |
| `Mod_SpawnBuilding(table_item)` | Helper to spawn a building at position |
| `Mod_GiveResources()` | Grant 50000 resources every 600s |
| `Get_Spanwer(spawner_num)` | Map magic numbers to marker positions (8 players × 9 markers) |
| `Annihilation_CheckVictory()` | Check if game should end |
| `Annihilation_WinnerPresentation()` | Victory stinger |
| `Annihilation_LoserPresentation()` | Defeat/eliminated stinger |
| `KillAllNeutralWalls()` | Destroy all neutral walls on map |
| `ApplyTestMode()` | Debug — lower thresholds for testing |
| `ScoreVisibility_Show()` | Show score UI |

### `gameplay/cba_items.scar` — Blueprints & Lockouts

| Function | Purpose |
|---|---|
| `CBA_Items_Lock()` | Remove most buildings, siege, upgrades, abilities from all players. Enforces CBA rules |
| `CivStartingStats()` | Per-civ special setup (Ottoman military school, Japanese action points, HRE auto-repair removal, Mongol bonuses, Chinese dynasty init, etc.) |
| `Apply_tobuildings(context)` | On construction: disable burn, add custom scuttle ability |
| `UpdateChineseDynasty(player)` | Apply dynasty upgrades for Chinese/Zhu Xi on age-up |

### `gameplay/cba_event_cues.scar` — Notifications

| Function | Purpose |
|---|---|
| `EventCues_NotifyAgeUp(player, selfTitle, otherTitle)` | Show colored event cue when any player ages up |

Data: Stores upgrade blueprints for `feudal_age`, `castle_age`, `imperial_age` and localized text IDs for the notification messages.

### `gameplay/spawnbehavior.scar` — Teams & Colors *(disabled)*

| Function | Purpose |
|---|---|
| `AssignTeamsAndShareVision()` | Players 1-4 → Team 1, 5-8 → Team 2 |
| `EnsureVisionSharing(teamIndex)` | Set `R_ALLY` for all pairs within team |
| `AssignColorToPlayers()` | Assign 8 predefined colors + brief FOW reveal |
| `DebugRelationships(teamIndex)` | Print relationship debug info |

### `gameplay/holysite.scar` — Religious Victory *(disabled)*

Standard Relic Holy Site system. Players capture sites with monks; holding all sites starts a countdown timer (20s). Currently commented out in the main file.

### `gameplay/ownscore.scar` — Score Tracking

Customized from Relic's base system:
- Military/Economy/Society/Tech scores at 20% of resource values
- **CBA customization:** `Score_OnEntityKilled` gives flat +50 military score per kill (human/cavalry types only), -50 for the victim's owner
- `Score_GetCurrentAge()` checks upgrade blueprints to determine player's current age

### `winconditions/ownsurrender.scar` — Surrender

| Function | Purpose |
|---|---|
| `Surrender_Notify(playerID)` | Network callback — show cue, destroy all assets, eliminate |
| `Surrender_CheckVictory()` | Find player with 0 enemies → declare victory |

### `winconditions/ownelimination.scar` — Elimination

| Function | Purpose |
|---|---|
| `Elimination_OnPlayerAITakeover(context)` | Handle disconnect — show cue, eliminate |
| `Elimination_CheckVictory()` | Same victory check as surrender |

Both reference `_annihilation.is_diplomacy_enabled` from the main file for presentation logic.

### `winconditions/cba_ui.scar` — Info Panel

| Function | Purpose |
|---|---|
| `InitializeAllUI()` | Create the info button (called from `Mod_OnInit`) |
| `InfoPanel_CreateUI()` | Build WPF XAML panel showing all in-game civs with their balance stats |
| `ToggleInfoButton()` | Toggle info panel on/off |

Reads `_modStartTable` to display: civ flag, name, gate requirement, Age 3/4 kill thresholds, pop cap, spawn rate.

---

## Architecture Notes

- **No encapsulation** — all modules share globals freely (`_annihilation`, `_modStartTable`, `PLAYERS`, etc.)
- **Three separate elimination paths** (castle death, surrender, disconnect) with partially duplicated asset-cleanup and victory-check logic
- **Dual blueprint tables** — `_modBlueprintTable` (spawning) and `CBA_ENTITY_TABLE` (locking) define overlapping data for the same civs; updating one without the other is a maintenance risk
- **`Get_Spanwer()` magic numbers** — uses digit patterns (1, 11, 111, ..., 888888888) to map 72 markers across 8 player slots; a 2D table `[slot][marker]` would be cleaner
- **`villager_spawn_enabled`** is a single global toggle shared by all players
- **22 civilizations supported** including 8 base civs + variant civs (Ayyubids, Zhu Xi, Jeanne d'Arc, Order of the Dragon, Lancaster, Knights Templar, Sengoku Daimyo, Tughlaq Dynasty, Macedonian Dynasty, Golden Horde)
