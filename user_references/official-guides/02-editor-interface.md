# Editor Interface — Official AoE4 Modding Guide

> Source: [Age of Empires Support — Editor Interface](https://support.ageofempires.com/hc/en-us/sections/4408498791060-Editor-Interface)

---

## Table of Contents

1. [Content Editor Interface Overview](#content-editor-interface-overview)
2. [Render View](#render-view)
3. [Asset Explorer](#asset-explorer)
4. [Scenario Tree](#scenario-tree)
5. [Object Browser](#object-browser)
6. [Console](#console)
7. [Error List, History & Output](#error-list-history--output)
8. [Properties Panel](#properties-panel)
9. [Transformation Panel](#transformation-panel)
10. [Playback Panel](#playback-panel)
11. [Main Menu Reference](#main-menu-reference)

---

## Content Editor Interface Overview

The Content Editor consists of multiple dockable panels that together form the workspace for creating mods.

### Core Panels

| Panel | Purpose |
|-------|---------|
| **Main Menu** | Access file operations, build, attributes, and tools |
| **Render View** | 3D viewport for map visualization and editing |
| **Asset Explorer** | Browse all files in your mod project |
| **Scenario Tree** | Hierarchical list of all objects and settings on the map |
| **Object Browser** | Search and place game assets |
| **Console** | Script output and command input |
| **Properties** | View/edit properties of selected objects |
| **Transformation** | Position, rotation, and scale controls |
| **Playback** | Environment simulation controls (time of day, weather) |

---

## Render View

The Render View is the main 3D viewport where you visually interact with your map.

### Features
- Real-time 3D rendering of terrain, objects, and effects
- Click to select objects directly in the viewport
- Drag assets from the Object Browser onto the Render View to place them
- Multiple render modes and overlays available via the Scenario menu

### Camera Controls
| Control | Action |
|---------|--------|
| Middle Mouse | Pan/slide camera |
| Scroll Wheel | Zoom |
| Alt + Middle Mouse | Pivot/rotate |
| F | Focus on selected object |

---

## Asset Explorer

The Asset Explorer displays all files in your current mod project.

### Usage
- Double-click files to open them in the appropriate editor
- Drag `.scar` files onto the Render View to open them in the script editor
- Drag `.rdo` files to open Win Condition editors
- Navigate through folder hierarchy to find mod assets

---

## Scenario Tree

The Scenario Tree is a hierarchical view of all objects and settings on a map.

### Key Sections

| Section | Contents |
|---------|----------|
| **Scenario** | Top-level container for the map |
| **Players** | Player slots and their settings |
| **Terrain** | Height map, colour map, water, grass, impasse, camera mesh, etc. |
| **Atmosphere** | Sun, ambient, sky, fog, clouds, wind, colour grading |
| **Metadata Map** | Metadata layers (trees, fog of war, etc.) |
| **Custom Layers** | User-created folders for organizing assets |

### Toolbar Controls

The Scenario Tree toolbar provides 23 lock controls for constraining selection and editing:
- Lock by object type (entities, squads, visuals, splats, decals, etc.)
- Lock position, rotation, scale independently
- Lock terrain interaction

### Working with Assets
- **Drag & drop** assets from the Object Browser into the Scenario Tree
- **Right-click** to access context menus (Add, Clone, Delete, etc.)
- **Select** an item to view its properties in the Properties Panel
- **Multi-select** by holding Ctrl or Shift

---

## Object Browser

The Object Browser allows you to search for and place game assets.

### Asset Types
| Icon | Type | Description |
|------|------|-------------|
| Box | Entity Blueprint (EBP) | Interactive game objects with behaviors |
| Shield | Squad Blueprint (SBP) | Unit groups with AI behaviors |
| Eye | Visual Blueprint | Non-interactive visual objects |

### Usage
- Type in the search field to filter assets
- Drag assets from the Object Browser onto the Render View or Scenario Tree
- Groups, Transformers, Randomizers, and Replicators are also available here

---

## Console

The Console panel displays script output and allows command input.

### Features
- View `print()` statement output from SCAR scripts
- See error messages and warnings
- Execute SCAR functions directly (when in dev mode)
- Access via **Script > Console** or the View menu

---

## Error List, History & Output

### Error List
- Displays compilation and runtime errors
- Double-click errors to navigate to the source

### History
- Records all actions performed in the editor
- Useful for tracking changes and debugging

### Output
- Shows build output and system messages
- Displays mod compilation status

---

## Properties Panel

The Properties panel shows the editable properties of whatever is currently selected.

### Common Properties
- **Position** (X, Y, Z coordinates)
- **Rotation** (degrees)
- **Scale** (uniform or per-axis)
- **Owner** (which player owns the object)
- **Display Name** / **Comment** fields

### Contextual Properties
Properties change based on what's selected:
- **Terrain tools**: Brush settings (size, shape, strength, feather)
- **Players**: AI difficulty, race, paint scheme, starting conditions
- **Objects**: Entity-specific properties
- **Atmosphere**: Sun angle, fog density, cloud settings

---

## Transformation Panel

The Transformation panel provides precise numeric control over object placement.

### Controls
| Property | Description |
|----------|-------------|
| **Position** | X, Y, Z world coordinates |
| **Rotation** | Euler angles in degrees |
| **Scale** | Uniform or non-uniform scaling |

### Tools
- **Move** (W): Translate objects
- **Rotate** (E): Rotate objects
- **Scale** (R): Scale objects
- Snap settings for grid-aligned placement

---

## Playback Panel

The Playback panel simulates environmental conditions.

### Controls
- **Time of Day**: Scrub through 24-hour cycle
- **Play/Pause**: Animate time progression
- **Weather**: Toggle weather effects
- Useful for previewing atmosphere settings and lighting

---

## Main Menu Reference

### File Menu (16 items)

| Command | Description |
|---------|-------------|
| New | Create a new scenario |
| Open | Open an existing scenario |
| Close | Close current scenario |
| Save | Save current scenario |
| Save As | Save with a new name |
| Save All | Save all open files |
| Recent Files | List of recently opened files |
| Asset Wizard | Create/import new assets |
| Burn | Burn scripts to the mod |
| Burn All | Burn all scripts |
| Reload | Reload current file |
| Import | Import external assets |
| Export | Export assets |
| Settings | Editor settings |
| Preferences | Editor preferences |
| Exit | Close the editor |

### Edit Menu (8 items)

| Command | Description |
|---------|-------------|
| Undo | Undo last action (Ctrl+Z) |
| Redo | Redo undone action (Ctrl+Y) |
| Cut | Cut selected (Ctrl+X) |
| Copy | Copy selected (Ctrl+C) |
| Paste | Paste from clipboard (Ctrl+V) |
| Delete | Delete selected (Delete) |
| Select All | Select all objects (Ctrl+A) |
| Find and Replace | Search and replace in scripts |

### View Menu (8 items)

| Command | Description |
|---------|-------------|
| Render View | Toggle Render View panel |
| Asset Explorer | Toggle Asset Explorer panel |
| Scenario Tree | Toggle Scenario Tree panel |
| Object Browser | Toggle Object Browser panel |
| Properties | Toggle Properties panel |
| Console | Toggle Console panel |
| Output | Toggle Output panel |
| Error List | Toggle Error List panel |

### Build Menu (2 items)

| Command | Description |
|---------|-------------|
| Build Mod | Compile and build current mod |
| Build All | Build all modified assets |

### Burn Menu (3 items)

| Command | Description |
|---------|-------------|
| Burn | Burn current script to mod |
| Burn All | Burn all scripts |
| Reload | Reload burned scripts |

### Attributes Menu (6 items)

| Command | Description |
|---------|-------------|
| EBPS | Entity Blueprints editor |
| SBPS | Squad Blueprints editor |
| Weapons | Weapons data editor |
| Upgrades | Upgrades data editor |
| Abilities | Abilities data editor |
| Find in Attributes | Search all game data (Ctrl+Shift+A) |

### Reflect Menu (6 items — Unsupported)

The Reflect menu contains legacy functionality that is not fully supported in the current version of the Content Editor.

### Localization Menu (4 items)

| Command | Description |
|---------|-------------|
| Open LocDB | Open localization database |
| Create LocDB | Create new localization database |
| Import Translations | Import translation files |
| Export Translations | Export translation files |

### Scenario Menu

The Scenario menu is extensive with sub-sections:

#### Panel Sub-menu
- Information display settings
- Blueprint List access

#### Overlay Sub-menu (50+ items)
Controls visibility of various overlays in the Render View:
- Terrain overlays (height, colour, impasse, grass, water, metadata)
- Object overlays (entities, squads, visuals, splats, decals)
- Debug overlays (collision, pathfinding, audio zones)
- Camera mesh overlay

### Script Menu

| Sub-menu | Description |
|----------|-------------|
| **Documentation** | Opens Scardocs in browser |
| **Console** | Opens script console |
| **Bookmarks** | Manage script bookmarks |
| **Breakpoints** | Manage debugger breakpoints |
| **Debugging** | Locals, Globals, Call Stack panels |

### Tools Menu

| Command | Description |
|---------|-------------|
| Customize Commands | Customize keyboard shortcuts |
| Customize Toolbars | Toggle toolbar visibility |

### Window Menu (4 items)

| Command | Description |
|---------|-------------|
| Save Layout | Save current panel layout |
| Load Layout | Load a saved layout |
| Reset Layout | Reset to default layout |
| Close All | Close all open tabs |
