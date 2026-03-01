# Game Modes — Official AoE4 Modding Guide

> Source: [Age of Empires Support — Game Modes](https://support.ageofempires.com/hc/en-us/sections/4408498853268-Game-Modes)

---

## Table of Contents

1. [Introduction to Scripting](#introduction-to-scripting)
2. [Creating a Game Mode](#creating-a-game-mode)
3. [Editing a Script](#editing-a-script)
4. [Editing a Win Condition](#editing-a-win-condition)
5. [Script Debugging](#script-debugging)

---

## Introduction to Scripting

### What is LUA?

LUA is a lightweight programming language embedded in Age of Empires IV.

Key differences from other languages:
- **Dynamically Typed** — variables can be reassigned to different types; use `scartype()` to check types
- **8 basic types** but AoE4 uses 6: `nil`, `boolean`, `number`, `string`, `function`, `table`

Learn LUA: [Official LUA website](https://www.lua.org/start.html)

### What is SCAR?

**SCAR** (Scripting At Relic) is LUA integrated into the AoE4 Content Editor with custom functions for modifying game objects and parameters.

If you know LUA, you know how to script in AoE4.

SCAR is used for:
- Multiplayer game mode logic
- Campaign missions
- Procedural map generation
- Debug functions

SCAR runs at a **global** level — a single script presides over the entire game session.

### Scardocs

A bundled function reference accessible via: **Script > Documentation** (opens in web browser)

How to use:
1. Select a function category in the left panel (e.g., FOW)
2. Select a function to view description and parameters
3. Use the function in your script

---

## Creating a Game Mode

### Steps

1. Open Content Editor → **Create a New Mod**
2. Select **Game Mode** → press **Next**
3. Select a **Template**:
   - **Blank Template**: Minimum necessary data, build from scratch
   - **Royal Rumble Template**: Script and win condition for a Regicide variant
   - **Template with Examples**: Heavily commented with useful function examples (recommended for beginners)
4. Enter **Name** (file name) and **Display Name** (player-visible)
5. Press **Next**
6. Enter **Mod Name** (display name for browsing) and **Mod Description**
7. Set save **Location** (default: Documents folder)
8. Press **Finish** — your game mode loads

---

## Editing a Script

### Opening a Script

When you create a Game Mode, your script opens as a tab: `[your_game_mode_name].scar`

Location: **Mod > Scar > WinConditions > [your_game_mode_name].scar**

If closed, drag from the Asset Explorer onto the Render View to reopen.

### Imported Scripts

Use `import()` to initialize other scripts alongside your game mode:

```lua
import("surrender.scar")  -- Controls pause menu Surrender button
```

The Blank Template includes commonly useful game scripts. Remove any you don't need.

### Scripting Framework

Functions that run automatically at different match stages:

| Function | When Called |
|----------|------------|
| `_OnGameSetup` | During load, as part of game setup sequence |
| `_PreInit` | Before initialization, before other module OnInit functions |
| `_OnInit` | On match initialization, before player gets control |
| `_Start` | After initialization, when game is fading up from black |
| `_OnPlayerDefeated` | When `Core_SetPlayerDefeated()` is invoked |
| `_OnGameOver` | When `Core_OnGameOver()` is called — used for cleanup |

**Function Naming**: Functions are prepended with the registered script name. Default is "Mod" (e.g., `Mod_OnGameSetup`). If you register as "TowerDefense", use `TowerDefense_OnGameSetup()`.

### Options

Create UI elements in the Custom/Skirmish lobby for match host configuration.

#### Setup

1. Create UI elements in the Win Condition `.rdo` file
2. In your script, read host selections:

```lua
function Mod_OnGameSetup()
    options_selected = {}
end

function Mod_OnInit()
    options_selected = {}
    Setup_GetWinConditionOptions(options_selected)
    
    if options_selected.my_option_section.my_drop_down.enum_value == 
       options_selected.my_option_section.my_drop_down.enum_items.my_first_option then
        -- First option selected
    elseif options_selected.my_option_section.my_drop_down.enum_value == 
           options_selected.my_option_section.my_drop_down.enum_items.my_second_option then
        -- Second option selected
    end
end
```

### Rules

Rules call functions at specific moments during a match.

| Rule Type | Function | Description |
|-----------|----------|-------------|
| **One Shot** | `Rule_AddOneShot(FunctionName, Delay)` | Calls function after delay (seconds) |
| **Interval** | `Rule_AddInterval(FunctionName, Interval)` | Calls function repeatedly on interval |
| **Global Event** | `Rule_AddGlobalEvent(FunctionName, GE_Key)` | Calls function when game event occurs |

```lua
function Mod_OnInit()
    Rule_AddInterval(Mod_GiveResources, 60)  -- Every 60 seconds
end

function Mod_GiveResources()
    -- Give resources to players
end
```

**Tip**: Type "GE" in your script to browse available global events (e.g., `GE_OnConstructionComplete`).

### Players

#### Using the Local Player

The local player is whoever is running the script on their machine. Useful for player-specific actions.

```lua
function Mod_ExploreMap()
    localPlayer = Core_GetPlayersTableEntry(Game_GetLocalPlayer())
    local player_civ = Player_GetRaceName(localPlayer.id)
    
    if player_civ == "mongol" then
        FOW_PlayerExploreAll(localPlayer.id)
    end
end
```

#### Using the PLAYERS Table

Global table containing all players (including AI). Use `for` loop to iterate:

```lua
function Mod_OnInit()
    for i, player in pairs(PLAYERS) do
        -- Ages: Dark=1, Feudal=2, Castle=3, Imperial=4
        Player_SetCurrentAge(player.id, 4)
        
        Player_SetResource(player.id, RT_Food, 1000)
        Player_SetResource(player.id, RT_Wood, 50)
        Player_SetResource(player.id, RT_Gold, 0)
        Player_SetResource(player.id, RT_Stone, 0)
        
        Player_SetMaxPopulation(player.id, CT_Personnel, 50)
    end
end
```

### Creating Objectives

Objectives display in the top-left corner during a match.

```lua
function Mod_SetupObjective()
    localPlayer = Core_GetPlayersTableEntry(Game_GetLocalPlayer())
    
    -- Create objective
    objective = Obj_Create(localPlayer.id, "Destroy the enemy houses", Loc_Empty(),
        "icons\\races\\common\\victory_conditions\\victory_condition_conquest",
        "ConquestObjectiveTemplate", localPlayer.raceName, OT_Primary, 0)
    
    -- Configure objective
    Obj_SetState(objective, OS_Incomplete)
    Obj_SetVisible(objective, true)
    Obj_SetProgressVisible(objective, true)
    Obj_SetCounterType(objective, COUNTER_CountUpTo)
    Obj_SetCounterCount(objective, 0)
    Obj_SetCounterMax(objective, 5)
    Obj_SetProgress(objective, 0 / 5)
end

function Mod_OnHouseDestroyed()
    houses_destroyed = houses_destroyed + 1
    Obj_SetCounterCount(objective, houses_destroyed)
    Obj_SetProgress(objective, houses_destroyed / 5)
    
    if houses_destroyed == 5 then
        Obj_SetState(objective, OS_Complete)
    end
end
```

### Finding Objects

Find entities like buildings on the map for scripted interactions:

```lua
function Mod_FindTownCenter()
    for i, player in pairs(PLAYERS) do
        -- Get all player entities
        local eg_player_entities = Player_GetEntities(player.id)
        
        -- Filter to Town Centers only
        EGroup_Filter(eg_player_entities, "town_center", FILTER_KEEP)
        
        -- Get the first (and usually only starting) Town Center
        local entity = EGroup_GetEntityAt(eg_player_entities, 1)
        local entity_id = Entity_GetID(entity)
        local position = Entity_GetPosition(entity)
        
        -- Store for later reference
        player.town_center = {
            entity = entity,
            entity_id = entity_id,
            position = position,
        }
        
        -- Reveal for first 30 seconds (radius 40, duration 30)
        FOW_RevealArea(player.town_center.position, 40, 30)
    end
end
```

**Finding blueprints**: Navigate to **File > Asset Wizard**, add Attributes mod, then **Attributes > ebps** to browse entity blueprints and their `type_ext` types.

### Spawning Units

Units are "squads" in the Content Editor. Blueprint data is in the squad blueprint (sbp).

```lua
function Mod_SpawnUnits()
    local localPlayer = Core_GetPlayersTableEntry(Game_GetLocalPlayer())
    
    -- Get squad blueprint
    local sbp_spearman = BP_GetSquadBlueprint("unit_spearman_4_eng")
    
    -- Get spawn position (20 units forward, 10 units right of Town Center)
    local spawn_position = Util_GetOffsetPosition(player.town_center.position, 20, 10)
    
    -- Create squad group container
    local sg_player_spearmen = SGroup_CreateIfNotFound("spearmen")
    
    -- Spawn 16 spearmen
    UnitEntry_DeploySquads(localPlayer.id, sg_player_spearmen,
        {{sbp = sbp_spearman, numSquads = 16}}, spawn_position)
end
```

Browse squad blueprints via **File > Asset Wizard** → Attributes mod → **Attributes > sbps**

---

## Editing a Win Condition

The Win Condition (`.rdo` file) defines Game Mode parameters without scripting.

### Opening
When creating a Game Mode, `[mod name].rdo` opens automatically.

If closed: **Asset Explorer > Mod > Scar > Winconditions > [mod name].rdo**

### Display Properties

| Property | Description |
|----------|-------------|
| **Display Name** | Shown when selecting game type in lobby and on loading screen |
| **Description** | Shown under mod name; "No Mod/Key" if empty |
| **Selected Image** | Mod icon in lobby (428x428 PNG, 32-bit depth). Place in `Assets/UI/Images/` in mod folder. |
| **Unselected Image** | Not referenced in AoE4 — leave blank |
| **Icon Properties** | Not referenced in AoE4 — leave blank |

### Modifiers

#### StartingBuildingReplacements
Replace the Town Center with a different building:
- Set **Key** to `"default_mp"` to enable replacement
- Set **Value** by selecting a building via "..." button
- Per-civilization replacement supported (add entries per Race)

#### StartingSquads
Replace default starting villagers:
- Right-click **StartingSquads** → Add
- Click "..." to select replacement unit

#### PlayerUpgrades
Give starting upgrades per civilization:
- Right-click **PlayerUpgrades** → Add
- Select upgrades to grant at match start
- **Note**: Only global upgrades work here; unit-specific upgrades need script

#### EgroupNamePrefixDestroyList
Specify egroup names whose entities are destroyed at match start.

#### GameModeType
Legacy — can be ignored for mods.

### Options

Connect to your Game Mode script for host-configurable settings.

#### Option Types

| Type | Description |
|------|-------------|
| **Boolean** | On/off toggle (e.g., Win Condition toggles) |
| **Enumeration** | Drop-down list of choices (e.g., Starting Resources) |
| **Integer** | Number slider (not well-supported in UI — use Boolean/Enumeration instead) |

#### Creating Options

1. Right-click **Options** → Add to create an Option Section
2. Set **Display Name** (section header in lobby)
3. Set **Key** (referenced in script, no spaces)
4. Set **Featured** toggle (shows on loading screen if true)
5. Right-click section's **Options** → Add to create individual options
6. Configure each option with Display Name, Key, Description, and default values

#### Enumeration Setup Example (Starting Resources)

1. Add Enumeration option with Key `"option_resources"`
2. Right-click **EnumItems** → Add for each option
3. Set per item: Display Name, Key (e.g., `"resources_standard"`), IsDefaultValue
4. First entry: set `IsDefaultValue = On`
5. Keys reference tuning data in `Tuning_simulation` Attributes category

### Scripts Section

| Property | Description |
|----------|-------------|
| **Win Condition Script** | The `.scar` script that runs for your Game Mode (auto-set on creation) |
| **Scenario Script** | Optional script that replaces any Crafted Map scenario script |

### Setup Section

| Property | Description |
|----------|-------------|
| **Name** | Unique identifier for this Game Mode |
| **DevOnly** | If true, only accessible with `-dev` launch argument |
| **MaxTeams** | Maximum number of joinable teams |
| **PrecacheList** | Assets to load alongside the Game Mode. Add assets here if they appear as red cubes. |
| **PermittedInventoryItemCategories** | If `IIT_PlayerCosmetic` selected, equipped Monuments appear in Town Centers |
| **ObjectiveUnitTypes** | Legacy — not used in AoE4 |
| **TuningModGUID** | Tuning Pack GUID to auto-select when this Game Mode is chosen |

---

## Script Debugging

### The Script Debugging Tool

Connects the Content Editor to the game client to debug scripts.

### Preparing the Editor

1. Open **Script** dropdown in toolbar
2. Open **Script > Debugging > Locals** — displays local variables at breakpoints
3. Open **Script > Debugging > Globals** — displays global variables at breakpoints
4. Open **Tools > Customize Toolbars** → check **ScriptEditor.Debugging** → close
5. Debugging shortcut buttons appear below the toolbar

### Connecting to the Game

1. Right-click AoE4 in Steam → **Properties**
2. Set Launch Options: `-dev`
3. Launch Age of Empires IV
4. In Content Editor, click **Attach** button
5. Click in the gutter left of a line number to create a **breakpoint**
6. Start a match with your mod selected
7. Game pauses at breakpoint; Global and Local panes populate

> **Note**: `-dev` mode means you can only play with others also using `-dev`.

### Debugging Functions

| Button | Action |
|--------|--------|
| **Run** | Unfreeze game, continue until next breakpoint |
| **Step Into** | Enter into called functions, stepping line by line |
| **Step Out** | Complete current function, pause in caller |
| **Step Over** | Execute one line, move to next (follows script structure) |
| **Detach** | Disconnect debugger, game continues ignoring breakpoints |

### SCAR Console

Open in-game with `Alt + Shift + ~` (requires `-dev` mode).

Two functions:
1. **Log display**: Shows `print()` output and SCAR errors
2. **Direct input**: Type and execute functions in real-time (e.g., `Mod_FindTownCenter()`)

### Log Files

Location: `Documents\My Games\Age of Empires IV\Logfiles\`

- New folder created per game launch (timestamped)
- Key file: **scarlog.txt**

### Fatal SCAR Errors

Game freezes and displays the error in the SCAR console (also written to scarlog.txt).

#### Anatomy of an Error
- Stacktrace shows the execution path
- Your script may be at the top, or the crash may be deep in a library
- Look down the stacktrace for the last point executing YOUR script

#### Continuing from an Error
- Press **Pause** key to attempt to continue
- If error is in a rule, it may trigger again immediately
- Try fixing the script, reburning, and hot-reloading

### Common Errors

| Error | Cause |
|-------|-------|
| **Tried to call global ???? (a nil value)** | Function doesn't exist — likely misspelled or missing import |
| **Invalid parameter ??? (type expected = ???, received = ???)** | Wrong variable type passed to a C++ function |
| **Invalid SGroup\* in ParmTraits<>::Pop** | Used destroyed group — called `SGroup_Destroy()` instead of `SGroup_DestroyAllSquads()` |
