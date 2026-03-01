# Getting Started — Official AoE4 Modding Guide

> Source: [Age of Empires Support — Getting Started](https://support.ageofempires.com/hc/en-us/sections/360012376652)

---

## Table of Contents

1. [Launching the Content Editor](#launching-the-content-editor)
2. [Types of Mods](#types-of-mods)
3. [Content Editor Basics](#content-editor-basics)
4. [Camera Controls](#camera-controls)
5. [Customizing the Editor](#customizing-the-editor)
6. [Ottoman & Malian Content Update](#ottoman--malian-content-update)
7. [Testing Your Mod](#testing-your-mod)
8. [Publishing and Using Mods](#publishing-and-using-mods)
9. [Localizing Your Mod](#localizing-your-mod)
10. [Reporting Issues](#reporting-issues)
11. [Turn Off Steam FPS Counter](#turn-off-steam-fps-counter)

---

## Launching the Content Editor

The Age of Empires IV Content Editor is a free tool that enables modding from within the game.

### Steam

1. Open your Steam Library
2. Navigate to the **Tools** section
3. Find and install **Age of Empires IV Content Editor**
4. Launch it from your Steam Library

### Xbox App (PC)

1. Open the Xbox app
2. Search for "Age of Empires IV Content Editor"
3. Install and launch

**Note:** The Content Editor requires the base game to be installed.

---

## Types of Mods

There are four main types of mods you can create:

### Crafted Maps
Hand-built maps using the terrain editor, object placement, and scripting tools. You control every detail of the map layout including terrain, objects, player positions, and scripted events.

### Tuning Packs
Data modifications that override unit stats, costs, and behaviors without changing the core game files. Tuning packs use the Attribute Editor to modify values like health, damage, speed, and resource costs.

### Generated Maps
Procedurally generated map layouts defined by LUA scripts and Attribute Editor data. These create randomly generated terrain, resource placement, and player positions each time the map is loaded — similar to the built-in random map types.

### Game Modes
Custom game rules and win conditions created through SCAR scripting. Game modes can modify starting conditions, create objectives, spawn units, and define custom victory/defeat logic.

---

## Content Editor Basics

The Content Editor is the primary tool for creating all mod types.

### Main Interface Areas

| Area | Description |
|------|-------------|
| **Main Menu** | File operations, build, attributes, and tool access |
| **Render View** | 3D viewport for visualizing and editing maps |
| **Asset Explorer** | Browse all available game assets and mod files |
| **Scenario Tree** | Hierarchical view of all objects on the map |
| **Object Browser** | Search and drag assets onto the map |
| **Properties Panel** | Edit properties of selected objects |
| **Console** | View script output and errors |

### Creating a New Mod

1. Launch the Content Editor
2. Select **Create a New Mod**
3. Choose your mod type (Crafted Map, Tuning Pack, Generated Map, or Game Mode)
4. Enter a name and configure settings
5. Press **Finish** to begin working

---

## Camera Controls

| Control | Action |
|---------|--------|
| **Middle Mouse Button** | Slide / pan the camera |
| **Scroll Wheel** | Zoom in and out |
| **Alt + Middle Mouse** | Pivot / rotate the camera |
| **Alt + Right Mouse** | Zoom in and out (alternative) |

### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| **F** | Focus on selected object |
| **Ctrl+Z** | Undo |
| **Ctrl+Y** | Redo |
| **Ctrl+S** | Save |
| **Delete** | Delete selected object |

---

## Customizing the Editor

The editor interface is highly customizable:

### Panel Management
- **Resize** panels by dragging their edges
- **Hide** panels by clicking their close button
- **Minimize** panels by clicking the minimize icon
- **Dock** panels by dragging them to edges or tabs
- **Float** panels by dragging them away from docked positions

### Saving Layouts
- Save custom layouts via **Window > Save Layout**
- Load saved layouts via **Window > Load Layout**
- Reset to default via **Window > Reset Layout**

### Custom Toolbars
- Access via **Tools > Customize Toolbars**
- Toggle visibility of specialized toolbars like ScriptEditor.Debugging

---

## Ottoman & Malian Content Update

When using Ottoman and Malian civilization assets:

### Naming Conventions
- Ottoman assets use the `_ott` suffix (e.g., `unit_spearman_1_ott`)
- Malian assets use the `_mal` suffix (e.g., `unit_spearman_1_mal`)

### Finding Assets
- Use the Asset Explorer or Find in Attributes (`Ctrl+Shift+A`) to search for civilization-specific assets
- Filter by typing the civilization suffix in search fields

---

## Testing Your Mod

### Building Your Mod

1. Save your work via **File > Save** (or `Ctrl+S`)
2. Build your mod via **Build > Build Mod**
3. The built mod is saved to:
   ```
   C:\Users\[YourName]\Documents\My Games\Age of Empires IV\mods\extension\local
   ```

### Testing In-Game

1. Launch Age of Empires IV
2. Go to **Skirmish** or **Custom** game setup
3. Select your mod from the appropriate dropdown:
   - **Map**: For Crafted Maps and Generated Maps
   - **Game Mode**: For Game Modes
   - **Tuning Pack**: For Tuning Packs
4. Configure match settings and start a game

### Dev Mode Testing

For advanced testing with debug features:
1. Right-click Age of Empires IV in Steam → **Properties**
2. In Launch Options, enter: `-dev`
3. This enables the SCAR console, debug cheats, and Content Editor attachment

---

## Publishing and Using Mods

### Publishing

1. **Build** your mod via Build > Build Mod
2. Launch Age of Empires IV
3. Navigate to **Mods > My Mods**
4. Open the **Mod Publisher**
5. Select your mod and configure its display settings
6. Click **Publish**

### Mod Status Indicators
- **Orange** = Local (unpublished)
- **Green** = Published

### Subscribing to Mods
- Browse other mods via **Mods > Browse Mods**
- Subscribe to download and use other players' mods

---

## Localizing Your Mod

The localization system allows you to translate your mod's text into 15 supported languages.

### Localization Database (LocDB)
- Text strings are stored in a localization database
- Each string has a unique key and translations for each language
- Access via **Main Menu > Localization**

### Supported Languages
English, French, German, Spanish, Italian, Portuguese (Brazilian), Russian, Polish, Turkish, Korean, Japanese, Chinese (Simplified), Chinese (Traditional), Malay, Vietnamese

### Pipeline Stages
1. Create text entries with unique keys
2. Enter the default (English) text
3. Add translations for each supported language
4. Build the mod to compile localization data

---

## Reporting Issues

If you encounter issues with the Content Editor or modding tools:

- Visit the [Age of Empires Support site](https://support.ageofempires.com)
- Provide detailed reproduction steps
- Include relevant log files from: `Documents\My Games\Age of Empires IV\Logfiles\`

---

## Turn Off Steam FPS Counter

The Steam FPS counter can sometimes interfere with the Content Editor display.

To disable it:
1. Open **Steam > Settings > In-Game**
2. Set **In-game FPS counter** to **Off**
