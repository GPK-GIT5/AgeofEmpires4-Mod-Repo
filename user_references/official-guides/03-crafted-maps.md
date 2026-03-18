# Crafted Maps — Official AoE4 Modding Guide

> Source: [Age of Empires Support — Crafted Maps](https://support.ageofempires.com/hc/en-us/sections/4408506179348-Crafted-Maps)

---

## Table of Contents

1. [Creating a New Crafted Map](#creating-a-new-crafted-map)
2. [Using the Terrain Layout Tool](#using-the-terrain-layout-tool)
3. [Mastering the Scenario Tree](#mastering-the-scenario-tree)
4. [Painter Tool Guide](#painter-tool-guide)
5. [Introduction to Objects and Units](#introduction-to-objects-and-units)
6. [Sculpting Terrain](#sculpting-terrain)
7. [Colouring Terrain](#colouring-terrain)
8. [Using Automated Terrain Tools](#using-automated-terrain-tools)
9. [Using Random Map Generation](#using-random-map-generation)
10. [Placing Ground Textures](#placing-ground-textures)
11. [Ultimate Water Guide](#ultimate-water-guide)
12. [Ultimate Atmosphere Guide](#ultimate-atmosphere-guide)
13. [Ultimate Grass Guide](#ultimate-grass-guide)
14. [Placing Trees](#placing-trees)
15. [Placing Splats and Decals](#placing-splats-and-decals)
16. [Creating and Using Palettes](#creating-and-using-palettes)
17. [Placing Special Effects](#placing-special-effects)
18. [Placing Lights](#placing-lights)
19. [Creating Groups of Objects (Stamps)](#creating-groups-of-objects-stamps)
20. [Creating Ambient Audio Zones](#creating-ambient-audio-zones)
21. [Placing Impasse Areas](#placing-impasse-areas)
22. [Using your Map's Inventory (Blueprint List)](#using-your-maps-inventory-blueprint-list)
23. [Creating Fog of War Areas](#creating-fog-of-war-areas)
24. [Placing Player Starting Positions](#placing-player-starting-positions)
25. [Adjusting Player Settings](#adjusting-player-settings)
26. [Adjusting the Player Camera](#adjusting-the-player-camera)
27. [Grouping Objects Together](#grouping-objects-together)
28. [Creating Instanced Objects (Replicators)](#creating-instanced-objects-replicators)
29. [Using Scenario Tree Layers](#using-scenario-tree-layers)
30. [Spawning Random Units and Objects](#spawning-random-units-and-objects)

---

## Creating a New Crafted Map

### Steps
1. Launch the Content Editor and select **Create a New Mod**
2. Select **Crafted Map** and press **Next**
3. Enter a **Map Name** (file name) and **Display Name** (visible to players)
4. Choose a template:
   - **Beginner**: Pre-built terrain with objects, ideal for learning
   - **Intermediate**: Empty map with basic terrain setup
5. Enter a **Mod Description** and set the save **Location**
6. Press **Finish** to begin editing

### Map Settings
- **Map Size**: Controls the playable area dimensions
- **Biome**: Sets the default visual theme (grassland, desert, etc.)

---

## Using the Terrain Layout Tool

The Terrain Layout Tool is a grid-based tool for quickly sketching out the broad layout of a crafted map.

### Grid System
- The map is divided into a grid of large squares
- Each square can be painted with a terrain type
- Components include: **Terrain**, **Players**, **Rivers**, and **Crossings**

### Terrain Types
| Type | Description |
|------|-------------|
| Plains | Flat, open ground |
| Hills | Elevated terrain |
| Mountains | Impassable high terrain |
| Forest | Pre-placed tree coverage |
| Beach | Coastal terrain |

### Player Placement
- Drag player markers onto grid squares
- Each player needs a starting position
- Players can be placed in any valid position

### Rivers & Crossings
- Paint river paths through grid squares
- Add crossings to create passable river sections
- Rivers/crossings generate automatically based on painted paths

### Flipped Design
- Use the **Flip** option to create symmetrical maps
- Design one half; the other mirrors automatically

---

## Mastering the Scenario Tree

The Scenario Tree is the backbone of your map's organization.

### Toolbar (23 Lock Controls)
Lock controls constrain what can be selected or edited:
- Lock entities, squads, visuals, splats, decals independently
- Lock position, rotation, scale axes
- Lock terrain interaction to prevent accidental edits

### Key Folders

#### Atmosphere Tools
| Tool | Settings |
|------|----------|
| **Sun** | Direction, color, intensity, shadow settings |
| **Ambient** | Color, intensity, sky contribution |
| **Fog** | Start/end distance, color, density, height fog |
| **Exposure** | Auto/manual exposure, bloom, adaptation speed |
| **Clouds** | Cloud cover, speed, scale, density |

#### Player Settings
- Per-player configuration for AI difficulty, civilization, color, team, starting age
- Status: Open / Closed / AI

#### Terrain Tools
| Tool | Purpose |
|------|---------|
| Audio Region | Define ambient audio zones |
| Camera Mesh | Adjust player camera height layer |
| Colour Map | Paint terrain color |
| Grass | Paint grass coverage |
| Height Map | Sculpt terrain elevation |
| Impasse Map | Define passability areas |
| Interactivity Map | Set interactive terrain zones |
| Megatile | Large terrain features |
| Metadata Map | Data layers (trees, fog of war, etc.) |
| Tiles | Ground texture tiles |
| Water Flow | Water flow direction painting |
| Water Height | Water level painting |
| Water Tiles | Water texture tiles |

---

## Painter Tool Guide

The Painter Tool is the primary tool for painting terrain, textures, and data layers.

### Dual Brush System
- **Left Mouse Button (LMB)**: Primary brush
- **Right Mouse Button (RMB)**: Secondary brush
- Each button can be assigned different materials/settings

### Brush Properties

| Property | Description |
|----------|-------------|
| **Blend** | How the paint blends with existing content |
| **Strength** | Intensity of the brush effect (0–1) |
| **Gusto** | Degree of the effect per stroke |
| **Feather** | Softness of brush edges (0 = hard, 1 = fully soft) |
| **Size** | Diameter of the brush in cells |
| **Shape** | Circle or Square |
| **Mode** | Additive, Subtractive, Flatten, Roughen, Smoothen |
| **Texture** | Selected texture/material to paint |

### Blend Modes
8 blend modes available for terrain colour painting including normal alpha blending, additive, multiplicative, and specialized modes.

---

## Introduction to Objects and Units

### Object Types

| Type | Blueprint | Description |
|------|-----------|-------------|
| **Entity** | EBP (Entity Blueprint) | Interactive gameplay objects — buildings, resources, relics. Have health, can be targeted, respond to commands. |
| **Squad** | SBP (Squad Blueprint) | Groups of units with AI behaviors — soldiers, villagers, scouts. Controlled by player or AI. |
| **Visual** | Visual Blueprint | Non-interactive decorative objects — rocks, ruins, props. No gameplay interaction, purely cosmetic. |

### Placing Objects
1. Open the **Object Browser**
2. Search for the desired asset
3. Select the correct blueprint type (Entity = box icon, Squad = shield, Visual = eye)
4. Drag onto the **Render View** or **Scenario Tree**
5. Adjust position and properties

---

## Sculpting Terrain

### Height Map Brushes (7 Types)

| Brush | Description |
|-------|-------------|
| **Feathered Tip Sculpt** | Standard brush with adjustable feathering |
| **Textured Tip Sculpt** | Uses an uploaded image as brush shape |
| **Feathered Tip Extrude** | Raises/lowers terrain in geometric shapes |
| **Textured Tip Extrude** | Like extrude but with image-based shape |
| **Set Height** | Paints terrain to a specific height value |
| **Smooth** | Smooths terrain irregularities |
| **Sample** | Captures height data from terrain to use as brush settings |

### Terrain Deform Shapes
Pre-made geometric deformations:
- **Cube**: Flat-topped rectangular elevation
- **Cylinder**: Circular flat-topped elevation
- **Wedge**: Sloped rectangular elevation

### Heightfield Deform
An advanced terrain sculpting system that applies complex deformation patterns.

### Modes
- **Additive**: Raises terrain
- **Subtractive**: Lowers terrain
- **Flatten**: Levels terrain to brush height
- **Roughen**: Adds noise/bumps
- **Smoothen**: Eliminates roughness

---

## Colouring Terrain

### Colour Map Painting
Use the Painter Tool with the Colour Map selected to paint terrain colors.

### Blend Modes (8 Types)
Multiple blend modes control how painted colors interact with existing terrain:
- Normal alpha blending
- Additive, subtractive
- Multiplicative
- Specialized color modes

### RGBA Lock
- Lock individual color channels (R, G, B, A) to paint only specific channels
- Useful for detailed terrain coloring effects

---

## Using Automated Terrain Tools

### Generators (7 Types)

| Generator | Description |
|-----------|-------------|
| **Auto Tile** | Automatically assigns tiles based on terrain features |
| **Erode** | Simulates erosion on terrain |
| **Gaussian Blur** | Applies gaussian blur to terrain height/color |
| **Random Scenario** | Generates a full random scenario layout |
| **Scale World** | Scales the entire terrain uniformly |
| **Shift World** | Shifts the entire terrain vertically |
| **Slope World** | Applies a slope across the entire terrain |

### Accessing Generators
- Right-click on **Terrain** in the Scenario Tree
- Select the generator from the context menu
- Configure parameters in the dialog
- Press **OK** to apply

---

## Using Random Map Generation

The Random Scenario generator creates a complete randomized map layout.

### Interface Sections

#### Blueprint Settings
- Map name and template selection
- Base terrain type configuration

#### Generation Settings
- Map size and scale
- Terrain noise parameters (amplitude, frequency, octaves)
- Mountain and valley generation
- Water level settings

#### Randomization Settings
- Seed value for reproducible generation
- Player placement parameters
- Resource distribution controls

#### Win Condition Settings
- Default win condition selection
- Available victory types

---

## Placing Ground Textures

### Tile System
- Maps use a tile-based texturing system
- **Maximum 8 tiles per chunk** — exceeding this limit causes rendering issues
- **Cell size**: 16 or 32 (controls texture resolution)

### Placing Tiles
1. Select **Tiles** under Terrain in the Scenario Tree
2. Open the Painter Tool
3. Select a tile from the available textures
4. Paint tiles onto the terrain

### Custom Tiles
- Create custom tile textures for unique terrain looks
- Import via the Asset Explorer

### Merge Tiles
- Use the merge function to combine overlapping tile boundaries
- Produces smoother transitions between different terrain textures

### Important Notes
- Keep track of tile count per chunk (max 8)
- Use fewer unique tiles across adjacent areas for better performance
- Larger cell sizes (32) give lower resolution but better performance

---

## Ultimate Water Guide

### Water System Components

#### Flood Markers
- Define base water level for an area
- Place from the Object Browser (search "Flood" or "Water")
- Set water height via the Properties panel

#### Water Tiles (Max 4 per chunk)
- Apply water surface textures
- Different tile types available (ocean, river, lake, swamp)
- Maximum of 4 water tiles per chunk

### Flow System

#### Flow Painting
Paint water flow direction and speed using the Painter Tool with Water Flow selected.

#### Flow Brushes (4 Types)
| Brush | Description |
|-------|-------------|
| **Directional** | Paints flow in a specific direction |
| **Radial Outward** | Flow radiates outward from center |
| **Radial Inward** | Flow moves toward center |
| **Spiral** | Creates spiral flow patterns |

#### Flow Markers
- Place markers to auto-generate flow patterns
- The system interpolates flow between markers
- Useful for rivers and streams

### Foam Painting
- Paint foam onto water surfaces for visual detail
- Control foam intensity and density

### Water Tile Properties

| Category | Properties |
|----------|------------|
| **Flow** | Direction, speed, turbulence |
| **Foam** | Intensity, density, color |
| **Water** | Color, transparency, depth, refraction |
| **Wind** | Surface wave response to wind |

---

## Ultimate Atmosphere Guide

The atmosphere system controls all environmental lighting and weather conditions.

### Sun Settings
| Property | Description |
|----------|-------------|
| Direction | Angle of sunlight |
| Color | Sunlight color tint |
| Intensity | Brightness of direct sunlight |
| Shadow Color | Color of shadows cast by the sun |
| Shadow Softness | Edge softness of shadows |

### Ambient Settings
| Property | Description |
|----------|-------------|
| Color | Ambient light color |
| Intensity | Ambient brightness |
| Sky Contribution | How much sky color affects ambient |

### Sky Settings
- Sky color and gradient
- Horizon blending
- Sky texture settings

### Wind Settings
- Wind direction and speed
- Affects grass, trees, water, clouds, and particles

### Fog Settings
| Property | Description |
|----------|-------------|
| Start Distance | Where fog begins |
| End Distance | Where fog reaches full density |
| Color | Fog color |
| Density | Overall fog thickness |
| Height Fog | Fog that accumulates at lower elevations |
| Height Fog Falloff | Rate of height fog density change |

### Cloud Settings
| Property | Description |
|----------|-------------|
| Cover | Percentage of sky covered |
| Speed | Movement speed of clouds |
| Scale | Size of cloud formations |
| Density | Thickness of clouds |
| Shadow | Cloud shadow intensity on terrain |

### Colour Grading
- Post-processing color adjustments
- Saturation, contrast, brightness
- Color balance per shadow/midtone/highlight

### Influence Settings
- Controls how atmosphere affects different surfaces
- Adjustable per material type

### FOW (Fog of War) Display
- Fog of war visual appearance settings
- Shroud color and opacity

### Debug Settings
- Visualization tools for atmosphere parameters
- Override controls for testing

---

## Ultimate Grass Guide

### Grass Painting System
Paint grass coverage using the Painter Tool with the Grass layer selected.

### Brush Modes (5 Types)
| Mode | Description |
|------|-------------|
| **Additive** | Adds grass density |
| **Subtractive** | Removes grass density |
| **Set** | Sets grass to specific density |
| **Smooth** | Smooths grass density transitions |
| **Noise** | Adds random variation to density |

### Grass Types
- **Splat-based grass**: Standard grass applied as coverage maps
- Different grass types per biome

### Spline Grass Removal
- Grass can be automatically removed along spline paths (roads, walls)

### Slope Controls
- Grass automatically adjusts based on terrain slope
- Steep slopes reduce or eliminate grass placement
- Configure maximum slope threshold for grass

---

## Placing Trees

### Method 1: Metadata Map
Create a metadata layer for trees and paint them using the Painter Tool.

#### Tree Metadata Types (5 Types)
Each corresponds to a different density/type of tree coverage:
1. Light forest
2. Medium forest
3. Dense forest
4. Sparse trees
5. Mixed forest

#### Steps
1. Right-click **Metadata Map** in Scenario Tree → **+Add**
2. Create a new layer and name it
3. Right-click the layer → **+Add**
4. Select the tree metadata type
5. Set the metadata value and colour in Properties
6. Select the layer and use the Painter to paint tree areas

### Method 2: Palette Brush
Use the Object Painter palette to place individual or groups of trees.

#### Steps
1. Open the Object Painter panel
2. Select a palette containing tree brushes
3. Configure brush settings (density, size, scatter)
4. Paint trees directly onto the terrain

---

## Placing Splats and Decals

### Splats
- **2D terrain-only** visual overlays
- Applied directly onto the terrain surface
- Cannot appear on objects or 3D surfaces
- Common uses: dirt patches, mud, road markings, ground detail

#### Placing Splats
1. Search for splats in the Object Browser
2. Drag onto the Render View
3. Adjust position, rotation, and scale

### Decals
- **3D volume** projections
- Can project onto terrain AND objects
- More expensive than splats but more versatile
- Common uses: blood splatters, burn marks, projected patterns

#### Creating Custom Splats/Decals
- Create material files for custom visuals
- Import textures through the Asset Explorer
- Assign materials to splat/decal blueprints

---

## Creating and Using Palettes

Palettes organize reusable sets of objects and brushes for quick placement.

### Palette Types

#### Groups/Sets
- Collections of objects bundled together
- Place the entire group at once
- Useful for pre-made arrangements (campsites, ruins, fortifications)

#### Brushes
- Paintable collections using the Object Painter
- Configure density, spacing, and randomization
- **Bristles**: Individual object types within a brush (multiple bristle types create varied placement)

### Object Painter Panel
| Control | Description |
|---------|-------------|
| **Brush Selection** | Choose which brush/palette to paint with |
| **Density** | Number of objects per area unit |
| **Size** | Brush diameter |
| **Scatter** | Randomization of placement within brush area |
| **Rotation** | Random rotation of placed objects |
| **Scale** | Random scale variation range |

### Creating a Palette
1. Select objects in the Scenario Tree or Render View
2. Right-click → Save as Palette
3. Name and save to the mod's palette library
4. Access saved palettes through the Object Browser

---

## Placing Special Effects

### Marker Types

#### Action Markers
- Spawn visual/audio effects at a location
- Configure based on **time of day** and **weather** conditions
- Effects play conditionally based on environment settings

#### Scar Markers
- Scriptable markers that can be referenced from SCAR code
- Properties: **Position**, **Direction**, **Area**, **Name**, **Type**
- Used to define locations for scripted events

#### Water Markers
Two sub-types:
- **Flood Markers**: Set base water level height
- **Flow Markers**: Define water flow direction and speed for auto-generation

---

## Placing Lights

### Light Types
Only **Point Lights** are currently functional in the Content Editor.

### Point Light Properties
| Property | Description |
|----------|-------------|
| **Colour** | RGB color of the light |
| **Intensity** | Brightness (default: 8) |
| **Attenuation Start** | Distance where light starts to fade |
| **Attenuation End** | Distance where light fully fades to zero |

### Usage
1. Search for "light" in the Object Browser
2. Drag a Point Light onto the map
3. Adjust properties in the Properties panel
4. Position to illuminate desired areas

---

## Creating Groups of Objects (Stamps)

### Stamps
Stamps are reusable visual asset groups created with the Transformer system.

**Important Limitation**: Stamps can only contain visual assets (visuals, strips, splats). They **cannot** contain entities or squads.

### Creating a Stamp
1. Create a **Transformer** from the Object Browser
2. Add visual assets to the Transformer in the Scenario Tree
3. Arrange assets as desired
4. Save the Transformer as a Stamp via the palette system

### Using Stamps
- Copy and paste stamps to quickly replicate arrangements
- Each stamp instance is independent — changes to one don't affect others unless using Replicators

---

## Creating Ambient Audio Zones

### Audio Region Types (5 Types)

| Type | Description |
|------|-------------|
| **Field** | Open field/grassland ambient sounds |
| **Hills** | Elevated terrain ambient sounds |
| **Mountains** | Mountain/high altitude ambient sounds |
| **Ocean** | Ocean/deep water ambient sounds |
| **Forest** | Forest/woodland ambient sounds |

### Painting Audio Zones
1. Select the Audio Region tool from the Scenario Tree
2. Open the Painter Tool
3. Select the desired audio type
4. Paint audio zones onto the terrain

### River Audio
- River audio automatically overrides painted audio regions along river paths
- No manual configuration needed for river sounds

---

## Placing Impasse Areas

Impasse areas define where units can and cannot move.

### Pass Types (4 Types)

| Pass Type | Description |
|-----------|-------------|
| **Infantry** | Controls infantry unit passability |
| **Vehicle** | Controls siege/vehicle passability |
| **Waterdefault** | Controls water passability for ships |
| **Can't Build** | Prevents building construction in the area |

### Painting Impasse
1. Select **Impasse Map** in the Scenario Tree
2. Open the Painter Tool
3. Select the pass type
4. Paint impasse zones onto the terrain

### Overlay Settings
| Setting | Description |
|---------|-------------|
| **Paint** | Shows manually painted impasse areas |
| **Terrain** | Shows impasse generated from terrain features |
| **Objects** | Shows impasse generated from placed objects |

### Visual Indicators
- **Green areas** = Custom painted impasse zones
- Toggle overlays to see different sources of impassability

### Regenerate All
If the impasse display appears incorrect or out of date:
- Use **Regenerate All** to refresh the impasse map
- This recalculates all impasse areas from terrain, objects, and paint data

---

## Using your Map's Inventory (Blueprint List)

The Blueprint List shows a full inventory of all assets on your map.

### Opening
Navigate to: **Main Menu > Scenario > Blueprint List**

### Controls

| Control | Description |
|---------|-------------|
| **Sort By Name** | Click "Blueprint" column header — sorts alphabetically |
| **Sort By Count** | Click "Count" column header — sorts by quantity |
| **Go to Selection** | Selects all instances of that blueprint on the map (or double-click) |
| **Refresh Results** | Re-loads assets to reflect recent changes |
| **Group By Blueprint** | Groups identical blueprints together (ON by default) |

### Filters
Toggle visibility of specific blueprint types:
- **Filter Decal**: Show/hide decals
- **Filter Entity**: Show/hide entities
- **Filter Heightfield Deforms**: Show/hide heightfield deforms
- **Filter Splat**: Show/hide splats
- **Filter Squad**: Show/hide squads
- **Filter Strip Component**: Show/hide strip components
- **Filter Visual**: Show/hide visuals

---

## Creating Fog of War Areas

### Step 1: Create a Fog of War Metadata Map

1. Right-click on **Metadata Map** in the Scenario Tree → **+Add**
2. Name the new layer
3. Right-click the layer → **+Add**
4. Find and select **fow_visibility_type** Metadata → press OK
5. Select the new Family Manager Enum
6. Use the **Value** field in Properties to select a fog of war type
7. Optionally set a **Colour** for the brush

### Step 2: Paint Fog of War with Palette

1. Select **Metadata Map** in Scenario Tree
2. Open the Painter panel
3. Use the **Layer** dropdown to select your fog of war layer
4. Use the **Metadata** dropdown to select the fog type
5. Configure brush **Shape** and **Size**
6. Paint fog of war areas (LMB for primary, RMB for secondary brush)

### Fog of War Types

| Type | Effect |
|------|--------|
| **Visible** | Area always visible, no fog of war |
| **Explored** | Area appears explored but covered with fog of war |
| **Sight plus Shroud** | Area appears completely unexplored |

---

## Placing Player Starting Positions

### Start Location Types

| Blueprint | Color | Description |
|-----------|-------|-------------|
| **starting_position_share** | Green | Full start — Town Center + villagers + scout |
| **starting_position_no_to** | Red | Start without Town Center (for custom scenarios) |
| Blue/Purple variations | Blue/Purple | Specialized — not recommended for general use |

### Placement Steps
1. Open the **Object Browser** and search for "Start"
2. Select the **Entity Blueprint** (box icon), NOT the Visual Blueprint (eye icon)
3. Drag onto the map
4. Select the start location and set its **Owner** in the Properties panel
5. Setting Owner to "World" creates a neutral town center

### Critical Notes
- **Maps must have enough start locations for the number of players** in a game lobby
- If there are not enough start locations, the match will **fail to load and crash**
- Always test with the expected number of players

---

## Adjusting Player Settings

### Accessing Settings
Select a player under **Players** in the Scenario Tree to open their Properties panel.

### Available Settings

#### AI Difficulty
- **Default**: Players choose AI difficulty in lobby
- Other settings lock to that difficulty level

#### Team Randomization
- **Do not Randomize** checkbox: Prevents team/starting location randomization
- Should be checked for custom missions
- Off by default for skirmish/multiplayer

#### Paint Scheme
- Controls unit, building, and banner colors
- Two color sets: Campaign and Default colors
- Set via the "..." button

#### Race (Civilization)
- Leave blank: Players choose in lobby
- Set to specific civ + check **Lock Race**: Forces that civilization
- Set via the "..." button → select from civilization list

#### Starting Conditions
- Controls starting Age (Dark, Feudal, Castle, Imperial)
- Leave blank: Host can set in lobby
- Set to specific age for missions/scenarios

#### Status
| Value | Effect |
|-------|--------|
| **Open** | Player can join the slot |
| **Close** | Player cannot participate |
| **AI** | Slot is AI-only |

### Slot Flags

| Flag | Effect |
|------|--------|
| **Lock AI Difficulty** | Prevents changing AI difficulty |
| **Lock Paint Scheme** | Prevents changing player color |
| **Lock Race** | Prevents civilization selection |
| **Lock Slot** | Not available in current version |
| **Lock Status** | Prevents changing slot status (open/closed/AI) |
| **Lock Team** | Prevents team changes |

> For custom missions: Lock Race, Lock Status, and Lock Team should always be checked.

---

## Adjusting the Player Camera

The Camera Mesh defines the surface the player camera rides on, smoothing out terrain irregularities.

### How It Works
- The camera rests on the Camera Mesh, not directly on terrain
- Auto-generated based on terrain surface when map is created
- Provides smooth camera movement regardless of terrain roughness

### Viewing the Camera Mesh
Click the **Select Camera Mesh** icon in the main toolbar to toggle the red grid overlay.

### Adding/Editing Camera Mesh

1. Right-click **Terrain** in Scenario Tree → **+Add**
2. A Camera Mesh entity appears
3. Select it to display the red grid
4. Use the Painter Tool to modify

### Generate Default
Auto-generates a mesh conforming to terrain with configurable parameters:
- **Smooth Radius**: Higher = gentler grid, lower = choppier
- **Maximum Height Radius**: Higher = flatter overall grid, lower = follows terrain dips more

> **Warning**: Regenerating overwrites manual changes.

### Camera Mesh Brushes (6 Types)

| Brush | Description |
|-------|-------------|
| **Feathered Tip Sculpt** | Standard brush with feathering control |
| **Textured Tip Sculpt** | Image-based brush shape |
| **Feathered Tip Extrude** | Raises/lowers in geometric shapes |
| **Textured Tip Extrude** | Image-based extrude shape |
| **Set Height** | Paints consistent, level height |
| **Sample** | Copies height data from selection |

### Brush Properties

| Property | Description |
|----------|-------------|
| **Feather** | Edge softness ratio |
| **Gusto** | Effect magnitude per stroke |
| **Mode** | Additive, Subtractive, Flatten, Roughen, Smoothen |
| **Shape** | Circle or Square |
| **Size** | Diameter in cells |
| **Strength** | Effect magnitude |

---

## Grouping Objects Together

### Groups
Organize assets under a single group in the Scenario Tree for easy selection and management.

#### Creating a Group
1. Find **Group** in the Object Browser
2. Drag onto the Scenario Tree
3. Move assets into the group via drag & drop

#### Group Behavior
- Selecting the group selects all objects within it
- Center pivot is the relative center of all contained assets
- Pivot repositions automatically as assets change

#### Group Properties
| Property | Description |
|----------|-------------|
| **Comment** | Notes visible to editor users |
| **Compound** | Makes group selectable as one unit in Render View |
| **Display Name** | Custom group name (default: "group") |
| **Locked** | Prevents editing |
| **Visible** | Controls editor visibility |

### Transformers
Similar to Groups but serve as the parent of assets and can be saved as Stamps.

#### Key Differences from Groups
- Transformer is the parent — child positions are relative to the transformer position
- Can be saved as a Stamp for reuse
- Center pivot serves as the reference point for all child positions

#### Transformer Properties
Same as Group Properties: Comment, Compound, Display Name, Locked, Visible.

---

## Creating Instanced Objects (Replicators)

Replicators instance an object or group, allowing simultaneous copying, modification, and spawning.

### Concepts
- **Replicator**: The parent container
- **Replica**: An instance of the content
- **Template**: The source content that all replicas reference
- Changes to the Template propagate to ALL replicas

### Creating a Replicator
1. Drag **Replicator** from Object Browser onto the map
2. The Replicator starts empty
3. Add Replicas via Right-click → **+Add**
4. Drag assets onto the **Template** node

### Important: Position
Set the Transformer position to **0,0,0** — offset transformers cause offset replicas.

### Saving Replicators
- Cannot be saved alone; must be saved under a **Palette**
- **Tip**: Remove replicas before saving to avoid unwanted instances on other maps
- Saved replicators are accessible through the Object Browser

### Common Uses
- Randomized campsites
- Sets of random rocks/bushes
- Quick-placement decoration clusters

---

## Using Scenario Tree Layers

Layers organize assets within the Scenario Tree into containers.

### Default Layer
- Auto-created with the map name when a new map is made
- Contains starting positions by default
- Cannot be renamed or removed

### Creating New Layers
1. Right-click **Scenario** in the Scenario Tree → **+Add**
2. Enter a layer name
3. Check/uncheck **Set as Default Parent** (new objects auto-placed into default parent layer)

### Layer Functions

#### Multiple Selection
Selecting a layer selects all objects within it — useful for batch operations.

#### Include/Exclude Elements
Right-click layer → **Include/Exclude** opens a dialog:

**Game Options:**
- **No Change**: Keep current settings
- **Include In Game**: Contents appear when played
- **Exclude From Game**: Contents hidden when played

**Scenario Reference Options:**
For layers in base scenarios used by scenario references:
- **Include In Scenario References**: Available to referencing scenarios
- **Exclude From Scenario References**: Unique to this map only

#### Expand/Collapse
Right-click on Scenario or Layer → **Expand All** / **Collapse All**
- On Scenario: Affects all folders and sub-structures
- On Layer: Affects only that layer and its contents

---

## Spawning Random Units and Objects

### Randomizer System
A Randomizer randomly selects one asset from a pre-defined list of possibilities.

### Components

| Component | Description |
|-----------|-------------|
| **Randomizer** | Parent container for probability entries |
| **Probability** | Child entry with a specific chance and attached object |
| **Replicator** | Required to actually spawn the randomized result |

### Creating a Randomizer

1. Drag **Randomizer** from Object Browser into the Scenario Tree
2. Two Probability entries are auto-created (minimum 2 needed)
3. Add more Probabilities: Right-click Randomizer → **Add**
4. Attach objects: Drag assets from Object Browser onto each Probability

### Probability Properties
| Property | Description |
|----------|-------------|
| **Locked** | Prevents editing |
| **Visible** | Editor visibility |
| **Probability** | Percentage chance (all should sum to 100%) |

### Randomizer Properties
| Property | Description |
|----------|-------------|
| **Comment** | Editor notes |
| **Display Name** | Custom name |
| **Locked** | Prevents editing |
| **Visible** | Editor visibility |
| **Seed** | Determines which probability is chosen |

### Using with Replicator

The Randomizer needs a Replicator to actually spawn objects:

1. Prepare your Randomizer with objects in each Probability
2. Create a **Replicator** (drag from Object Browser)
3. Drag the prepared Randomizer onto the **Template** under the Replicator
4. The Replicator now generates a random asset each time it's created
5. Use **+Add** on the Replicator to create additional random instances

### Using with Splines
- Drag a Randomizer onto a spline's instance component
- Creates randomized objects along the spline path

### Randomizing Transformers
- Random Transformer randomly rotates or shifts objects from their initial position
- Used to make clusters of rocks, bushes, trees look varied and natural
