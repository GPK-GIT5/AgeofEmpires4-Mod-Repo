# Generated Maps — Official AoE4 Modding Guide

> Source: [Age of Empires Support — Generated Maps](https://support.ageofempires.com/hc/en-us/sections/4408498885396-Generated-Maps)

---

## Table of Contents

1. [Introduction to Generated Maps](#introduction-to-generated-maps)
2. [Creating a Generated Map](#creating-a-generated-map)
3. [Generated Map Basics](#generated-map-basics)
   - [Terrain Table](#terrain-table)
   - [Player Starts](#player-starts)
   - [Balanced Resource Settings](#balanced-resource-settings)
   - [Distributions](#distributions)
   - [Terrain Types](#terrain-types)

---

## Introduction to Generated Maps

A Generated Map is a set of defined parameters used to create a random map layout — the same process used for built-in map types like Archipelago, Mongolian Heights, and Dry Arabia.

Generated maps:
- Follow an overall pattern but are random every time
- Can be loaded in a game lobby where size, biome, and player count are configurable
- Use two main tools: the **Attribute Editor** and the **Content Editor**

### Attribute Editor
The program for editing mapgen data:
- Map name, resource spawns, spawn permissions, biome-specific grass
- Primarily edits the `map_gen_layout` data
- Handles **where objects are placed** on generated terrain

### LUA Scripts
LUA scripts serve as the map's blueprints:
- Set physical parameters for terrain generation
- Determine where mountains, rivers, and player positions end up
- Can place objects and resources in specific locations

Example: On King of the Hill, the hilltop Sacred Site is placed in the very center using the LUA script, while on other maps Sacred Sites use distribution data.

---

## Creating a Generated Map

### Steps

1. **Open** the Content Editor → **Create New Mod**
2. Select **Generated Map** → press **Next**
3. Enter settings:
   - **Generated Map Name**: File name (internal only)
   - **Display Name**: What other players see
   - **Template**:
     - **Basic**: Recommended for beginners, contains explanatory notes
     - **Advanced**: Adds river-making examples for experienced modders
4. Enter a **Mod Description** and set file **Location**
5. Set **Locale** for localization language
6. Press **Finish** — your new map loads and you can begin working

---

## Generated Map Basics

Five key concepts govern generated maps:

| Concept | Description |
|---------|-------------|
| **Terrain Table** | Virtual LUA table holding all map generation info |
| **Player Starts** | Encoded spawn positions for player town centers |
| **Balanced Resource Settings** | Resource placement relative to player positions |
| **Distributions** | Lists of objects placed via terrain type or global lists |
| **Terrain Types** | Data defining each grid square's terrain and distributions |

---

### Terrain Table

The `terrainLayoutResult` table holds all map information passed to the terrain generator.

Think of it as a **square grid** where each cell contains:
- A **terrain type** (required)
- A **player index** (optional)

#### Syntax Examples

```lua
-- Set terrain type for a grid cell
terrainLayoutResult[row][col].terrainType = tt_plains

-- Place a player with starting resources
terrainLayoutResult[playerRow][playerCol].terrainType = tt_player_start_classic_plains
terrainLayoutResult[playerRow][playerCol].playerIndex = 1
```

---

### Player Starts

A Player Start is a spawn location where `playerIndex` corresponds to lobby order.

**Note:** In code, `playerIndex` starts at 0. A 2-player map uses indexes 0 and 1.

When placed:
- A marker is placed at the cell center
- Hooks into the Game Mode script to place starting objects (Town Center, villagers, scout)
- Separate from local distributions — you can create starts without resources

#### Player Start Functions

| Function | Description |
|----------|-------------|
| **PlacePlayerStarts** | Basic placement, respects impasse and minimum distances. May place near center. |
| **PlacePlayerStartsRing** | Standard for most open maps. Places in a ring with parameters for corner/impasse/center avoidance. Think of a "donut" overlay. |
| **PlacePlayerStartsTogetherRing** | Modified ring for multi-team games (e.g., 2v2v2v2). Teammates spawn in same quadrant. Used on Confluence. |
| **PlacePlayerStartsDivided** | Places 2 teams in opposing straight lines (horizontal or vertical). Used on Mountain Pass, Mongolian Heights, Nagari. |

All functions accept parameters for:
- Terrain types to avoid
- Player spawn distances and team distances
- Recursive fallback (reduces distances if placement fails)
- Flat buffer terrain around players (recommended radius of 2 tiles for build space)

---

### Balanced Resource Settings

#### Setting and Tuning Per Map

In the Attribute Editor: `map_gen > map_gen_layout` → `selectable_map_sizes`

Resource amounts are controllable **per map size**, giving flexibility to place different amounts per size per map.

#### Distribution Balancing

Found under `distribution_balancing` heading — each entry overrides a specific resource's default settings (based on `map_gen_size` defaults).

Including an entry signals you want to deviate from defaults (e.g., set `contested_base_spawn_count` to 0 for sacred sites when manually placing them via script).

##### Resource Placement Parameters

| Parameter | Description |
|-----------|-------------|
| **accessible_spawns** | Resources placed within each player's accessible area. Range 0.1 (edge) to 1.0 (close to player). |
| **accessible_range_min/max** | Defines accessible resource placement zone. E.g., 0.8/1.0 = only in bright white areas. |
| **avoid_any_spawn_distance** | Minimum distance from other resources (meters). Falls back to shorter distance if space is insufficient. |
| **avoid_same_spawn_distance** | Spreads individual instances of this resource type from each other. |
| **contested_additional_spawns_per_player** | Scales contested resource count by player count. Supports decimals (0.5 = +2 extra gold in 4-player game). |
| **contested_base_spawn_count** | Standard quantity of this resource for the map (total, not per player). |
| **contested_excludes_starting_land_mass** | If true, resource spawns only on neutral islands (for island maps). |
| **contested_range_min/max** | Placement zone for contested resources. 0.45-0.55 = halfway between players. Closer to 0.0 = closer to players. |
| **spawn_priority** | Placement order. Higher priority = placed first. Win condition objects (sacred sites) > stone/gold. |

#### Additional Variables

| Variable | Description |
|----------|-------------|
| **contested_range** | Width of the contested area |
| **distribution_balancing_list** | List of resources distributed by balanced system. Add more via Attribute Editor: `map_gen > distribution > distribution_balancing_list` |
| **player_start_influence_distance** | Minimum distance from player starts for resource placement |
| **solo_play_contested_area_start/end** | Defines contested map for single-player/sandbox mode |

#### Biome Settings

Per-map biome customization:
- Right-click `selectable_biomes` → add new data point
- **additional_distributions**: Global distribution spawned only in this biome (e.g., different tree quantities). Use `map_gen > distribution > global_distributions > additional`
- **atmosphere**: Override atmosphere data for this map/biome combo (e.g., foggy version of normally sunny map). Files in `scenarios > atmosphere`
- **biome**: Which biome this data affects. Found in `map_gen > map_gen_biome`

---

### Distributions

Distribution is the method for placing objects procedurally during map generation — trees, rocks, resource deposits, settlements, everything.

#### Global vs Local

| Type | Scope | Example |
|------|-------|---------|
| **Global** | Map-wide scattering | Individual trees scattered across the entire map |
| **Local** | Radial placement around a specific point | Gold deposit near a terrain type center point |

**Local distributions** are attached to terrain types placed via LUA scripts:
1. Generate starting resources (player start terrain → local distribution)
2. Generate resources in specific locations

#### Regions vs Cells

| Type | Behavior | Use Case |
|------|----------|----------|
| **Region** | Radial area that blocks other regions from overlapping | Forests, gold deposits (need guaranteed spacing) |
| **Cell** | Single 1m cell, no blocking | Cliffside rocks, sheep (okay to be close together) |

Both can be global or local. Both support **group spawns** (multiple objects in a radius with configurable density — used for forests).

**Caution**: Gold deposits should use Region placement (not Cell) to prevent overlapping and ensure mining camp space.

#### Distribution Passes (4 Phases)

| Pass | Priority | Contents |
|------|----------|----------|
| **1. Local Distributions** | Highest | Starting resources — ensures gameplay fairness |
| **2. Balanced Distributions** | High | On-map gold, stone, settlements, religious objects |
| **3. Global Biome Distributions** | Medium | Biome-specific objects (override generic globals) |
| **4. Global Distributions** | Lowest | Map "dressing" — rocks, bushes, trees |

---

### Terrain Types

A Terrain Type wraps data for generating one grid square of a map. Each type is characterized by:
1. What it does to terrain **elevation**
2. Whether it spawns something via a **local distribution**

#### Common Terrain Types

| Type | Purpose |
|------|---------|
| `tt_plains` | Basic flat open ground |
| `tt_mountains` | Mountain terrain |
| `tt_settlement_plains` | Spawns a Trade Post on flat ground |
| `tt_player_start_classic_plains` | Player spawn with standard starting resources |

#### Terrain Type Properties

| Property | Description |
|----------|-------------|
| **global_distribution_blocking_radius** | Radius around center blocked from global distribution placement |
| **is_lake_source** | If true, attempts to spawn water in concave terrain |
| **local_distribution_priority** | Controls ordering of local distributions (higher = earlier) |
| **local_distributions** | List of objects/resources spawned within a radius from center |
| **min_cliff_height** | Height threshold for cliff formation with adjacent squares |

#### Terrain Height Parameters

| Parameter | Description |
|-----------|-------------|
| **amplitude** | Height deviation from base. Higher = taller mountains/deeper valleys |
| **direction_bias** | Positive (>0) = hills/mountains upward. Negative = valleys downward |
| **shift_variance** | How much height can deviate from base. Higher = more rolling variation |
| **height_over_width** | Base height of terrain. Higher = hills, lower = valleys (before variance/amplitude) |
