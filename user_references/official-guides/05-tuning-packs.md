# Tuning Packs — Official AoE4 Modding Guide

> Source: [Age of Empires Support — Tuning Packs](https://support.ageofempires.com/hc/en-us/sections/4408498807444-Tuning-Packs)

---

## Table of Contents

1. [Attribute Editor Guide](#attribute-editor-guide)
2. [Creating a Tuning Pack](#creating-a-tuning-pack)
3. [Tutorial 1: Cloning an Asset](#tutorial-1-cloning-an-asset)
4. [Tutorial 2: Modifying Unit Cost](#tutorial-2-modifying-unit-cost)
5. [Tutorial 3: Propagating Unit Stats](#tutorial-3-propagating-unit-stats)
6. [Tutorial 4: Modifying Unit Stats](#tutorial-4-modifying-unit-stats)
7. [Tutorial 5: Hardpoints and Damage](#tutorial-5-hardpoints-and-damage)
8. [Tutorial 6: Weapons Masterclass](#tutorial-6-weapons-masterclass)

---

## Attribute Editor Guide

The Attribute Editor is the main interface for Tuning Packs.

### What the Editor Can Do
- Change unit stats (health, armor, speed, gather rates)
- Modify unit behavior
- Adjust resource amounts
- Change unit scale
- Adjust villager gather rates
- Change effect and behavior of upgrades
- Adjust map elements (tree density, resource distribution, herd sizes)
- Manipulate the build menu

### What the Editor Cannot Do
- Create new civilizations
- Create new functionality
- Create new upgrades
- Add new abilities

### With Extra Work
- Create new units

### Launching
Create a new Tuning Pack mod → automatically opens the Attribute Editor.

### Interface Layout

| Area | Description |
|------|-------------|
| **1) Main Viewport** | Primary work area, context-sensitive display. Supports multiple tabs. |
| **2) Scenario Panel** | Search content manually, displays current tuning pack items. Tree View or List View. |
| **3) Asset Explorer** | All files in your mod. Double-click to open. |
| **4) Attributes Menu** | All possible data types to display. |
| **5) Find Results** | Opened via Attributes > Find in Attributes. Search all game data. |

### Find in Attributes

The most useful search tool: **Attributes > Find in Attributes** (or `Ctrl+Shift+A`)

- **Name field**: Enter search term
- **Variable Value field**: Filter by asset type
- Results appear at the bottom panel

#### Data Types in Search Results

| Template Type | Description |
|---------------|-------------|
| **EBPS** | Entity Blueprint — unit statistics |
| **SBPS** | Squad Blueprint — unit behavior |
| **Attachments** | Equipment types (shield, spear, sword) |
| **Upgrade** | Unit and technology upgrades |
| **Ability** | Unit and building abilities |
| **Weapon** | Weapon stats (attached to hardpoints) |
| **Hotkeys** | Pre-existing hotkey bindings |
| **Statemodel_schema** | Player and civilization parameters |

### Tree View vs List View
- **Tree View**: Hierarchical browsing — good for exploring
- **List View**: Alphabetical listing — good when you know what you want

### Spacebar Drilldown
Press **Spacebar** to quickly open/drill into selected data. Works on most selectable items.

### Categories of Content

| Category | Key Contents |
|----------|-------------|
| **EBPS** | Hardpoints, health/armor, cost, holds, spawner extension, move speed, gather rate, upgrades |
| **SBPS** | Production requirements, abilities, tooltip info |
| **Weapons** | Attack speed, damage/falloff, AOE behavior, bonus damage modifiers |
| **Army** | Starting resources/units/buildings |
| **State Model Schema** | Global player values, building values (repair cost, relic limits), civ-specific values |
| **Upgrades** | Requirements, filter conditions, local max limit, icon |

---

## Creating a Tuning Pack

### Steps

1. Open the Content Editor → **Create a New Mod**
2. Select **Tuning Pack** → press **Next**
3. Enter a **Name** (file name)
4. Enter **Mod Display Name** (visible to other players) and **Mod Description**
5. Set save **Location** (default: Documents folder)
6. Press **Finish** — your tuning pack loads

### Video Guide
[Age of Empires IV: Tuning Packs](https://www.youtube.com/watch?v=GN-4k5ry8S8)

---

## Tutorial 1: Cloning an Asset

To modify a unit, you must first clone it from the base game data.

### Steps

1. Open **Attributes > EBPS** to access Entity Blueprints
2. Navigate to the unit: **Attributes > Races > French > Units > unit_spearman_1_fre**
3. Right-click the unit → **Clone...**
4. In the clone dialog:
   - Add a **Description** (optional note)
   - **DO NOT modify the file name** — the game only overwrites units with matching file names
   - Check **Clone LocStrings** (copies text data correctly)
   - Check **Clone Override Parent Settings** (prevents inherited stats from lower tiers)
   - **Clone Specific Extensions** makes only changed values appear

5. Your cloned unit appears in your mod folder with the matching filepath

### Loading the Mod
If the Attributes menu doesn't show your mod:
- Find your mod file (`YOURMODNAME.xml`) in the File Explorer
- Drag it onto the Render View to load it

### Cloning Higher Tier Units
Always check **Clone Override Parent Settings** for tier 2+ units. Otherwise, an Imperial Age Spearman inherits Dark Age stats.

---

## Tutorial 2: Modifying Unit Cost

### Steps

1. **Find the cost**: Select unit → navigate to `extensions > cost_ext > time_cost > cost`
2. **Change the value**: Double-click the food field → enter new value (e.g., 60 → 40)
3. **Save**: File > Save
4. **Build**: Build > Build Mod
5. **Test**: Launch AoE4 → Game Setup → select your Tuning Pack → start match → verify change

### Bold Values
Values displayed in **bold** are currently overwriting the parent blueprint's original value. This is a quick visual indicator of what your tuning pack changes.

---

## Tutorial 3: Propagating Unit Stats

Changes to one unit tier (e.g., Dark Age Spearman) don't automatically apply to other tiers.

### Manual Propagation

1. **Filter the data**: Open Races > French > Units, type "Spearman" in filter
2. **Clone remaining tiers**: Right-click each tier → Clone
3. **Select all tiers**: Hold Ctrl + click each cloned spearman
4. **Change the Common column**: Updating the value in the Common column applies to all selected

### Mass Propagation (Advanced)

For modifying the same unit across all civilizations:

1. Clone all individual civ units (checking **Clone Override Parent Settings**)
2. Clone the **Core** version of the unit (matching the unit number, e.g., `unit_horseman_1`)
3. Make changes to the Core unit → changes propagate to all cloned civ variants
4. Verify inheritance on each cloned unit
5. If a unit isn't inheriting: Right-click → **Inherit from Parent**

### Troubleshooting
- **Bold values** indicate overrides from elsewhere — core changes won't propagate there
- Clone the Core unit **AFTER** cloning all civ-specific units
- Ensure your mod name appears **first** in the `parent_pbg` list

---

## Tutorial 4: Modifying Unit Stats

### Build Time
Location: `time_seconds` field (value in seconds)

### Movement Speed
Location: `extensions > moving_ext > speed_scaling_table > default_speed`

- Speed is in **meters per second** (1 meter = 1/4 tile)
- `max_speed` = maximum speed with buffs/modifiers
- **Never set max_speed above 8** — causes errors

### Unit Health
Location: `health_ext`

| Sub-node | Description |
|----------|-------------|
| **armor_scaler_by_damage_type** | Resistance per damage type (fire, melee, ranged) |
| **hitpoints** | Total health pool |
| **regeneration** | Health regen per tick (8 ticks/second) — rare stat |

### Population Cost
Location: `cost_ext > time_cost > cost > personel_pop`

- Most human units: 1 pop
- Siege and naval: typically higher

### Sight Range
Location: `sight_ext > sight_package`

Values in **meters** (4 meters = 1 tile).

#### The Sight "Lampshade" Model

AoE4 unit vision has a "lampshade" shape:

| Parameter | Description |
|-----------|-------------|
| **Inner Radius** | Base sight that "floats" above the unit. Max vision radius when looking uphill. |
| **Inner Height** | Max height of sight origin. Controls how far up a cliff the unit can see. Additive with elevation. |
| **Ground Plane** | The cutoff at normal ground level. Actual flat-ground sight (between Inner and Outer radius). |
| **Outer Height** | Max depth of vision. Controls how far down a cliff the unit can see. |
| **Outer Radius** | Max range when at higher elevation. Greatest vision when looking downhill. |

- If Inner Radius = Outer Radius → sight identical in all situations
- If Outer > Inner → unit sees further downhill, less far uphill
- **Ground Plane** value is derived from Inner/Outer Radius ratio, adjusted by Inner/Outer Height

#### Stealth Forests
- Stealth forests block sight with a height value of **500**
- Unit needs `inner_height > 500` to see into stealth forests
- High ground elevation adds to vision height, potentially exceeding 500

---

## Tutorial 5: Hardpoints and Damage

Hardpoints are weapon slots where units equip weapons. The weapon deals damage, not the unit directly.

### Accessing Weapon Data

1. Select unit → open `combat_ext > hardpoints > 1.hardpoint > weapon_table`
2. Units can have up to **4 weapons** (most have 1)
3. Navigate to `1.weapon > non_entity_weapon_wrapper` for weapon stats
4. Right-click the weapon reference → **Go to Reference** to open the weapon file

> **Warning**: Do not change weapon order — high likelihood of breaking unit functionality.

### Cloning a Weapon

1. Open **Attributes > Weapons**
2. Navigate to **Races > Common > Melee**
3. Find `weapon_spearman_1` → Right-click → **Clone**
4. Cloned weapon appears under your mod

### Changing Weapon Damage

Navigate to `weapon_bag > damage`:
- **min**: Minimum damage per attack
- **max**: Maximum damage per attack

Default AoE4: min and max are identical (no variance), but you can set different values for damage ranges.

---

## Tutorial 6: Weapons Masterclass

### Melee vs Ranged Attacks

| Aspect | Melee | Ranged |
|--------|-------|--------|
| **Range** | Adjacent only | Within weapon range |
| **Speed Factors** | Aim + Wind Up/Down + Cooldown | Aim + Wind Up/Down + Reload |
| **Aim Time** | Usually 0 | Almost always > 0 |
| **Between-Attack Timer** | Cooldown | Reload |

### Wind Up and Wind Down
Location: `fire` section

| Property | Description |
|----------|-------------|
| **wind_up** | Time from attack animation start to damage/projectile launch |
| **wind_down** | Time to finish attack animation after striking |

> **Caution**: Extreme values may desync attacks from animations.

### Weapon Cooldown (Melee)
Location: `cooldown` (in seconds)

- Reduce cooldown → faster attacks
- Increase cooldown → slower attacks
- Example: Spearman default = 0.75 seconds

### Aim Time (Ranged)
Location: `aim > fire_aim_time`

| Property | Description |
|----------|-------------|
| **min** | Minimum aim time |
| **max** | Maximum aim time (random between min/max each shot) |

- Any value > 0 **prevents firing while moving**
- Value of 0 = can fire while moving (Mongolian horse archers)
- Default AoE4: min and max are identical (no variance)

### Reload Time (Ranged)
Location: `reload`

| Property | Description |
|----------|-------------|
| **min** | Minimum reload time |
| **max** | Maximum reload time |

Same variance mechanics as aim time.

### Weapon Range
Location: `range`

| Property | Description |
|----------|-------------|
| **max** | Maximum attack range |
| **min** | Minimum attack range (creates dead zone) |

Example: Trebuchet = max 64m, min 11m.

### Area of Effect (AOE) Damage

Location: `area_effect`

#### Damage Zones
Three concentric zones with damage multipliers:

| Zone | Description |
|------|-------------|
| **Near** | Center of impact outward. Typically 100% damage. |
| **Mid** | Middle ring. Typically reduced damage. |
| **Far** | Outermost ring. Typically minimal damage. |

#### Distance Settings
Under `distance` — defines zone boundaries in meters (1 tile = 4m):
- Example trebuchet: 100% to 0.4m, 25% to 0.8m, 10% to 1.2m

#### Outer Radius
Under `area_info > outer_radius` — master override for AOE area.
- Distance values beyond outer_radius have no effect
- Must be ≥ your largest distance value

### Projectiles
Location: `weapon_bag > projectile > projectile` → Right-click → **Go To Reference**

Open `projectile_ext` for core characteristics:
- Trajectory, tracking behavior, speed
- Visual appearance and effects

### Bonus Damage
Location: `target_type_table`

| Property | Description |
|----------|-------------|
| **base_damage_multiplier** | Additive bonus damage value (e.g., 5 = +5 damage per attack) |
| **unit_type** | Target unit type file name that triggers the bonus |
| **multipliers** | For multiplicative bonus damage instead of additive |

Example: Archers deal +5 damage to targets flagged as `light_melee_infantry` (spearmen).
