# Age of Empires IV Content Editor - Editor Interface Guide

> Full text extracted from 23 official modding guide articles at support.ageofempires.com

---

## Article 1: Content Editor Interface

### Overview

The Age of Empires Content Editor is a multi-faceted editor program that allows you to create mods in Age of Empires IV.

This editor allows you to have a variety of files and programs open at the same time, allowing you to work on map terrain, unit stats, scripting, and similar elements all in once place.

This guide covers the basic layout and functions of the Content Editor, including how to customize the editor's UI to suit your specific needs.

### Editor Layout

When you first open the editor, it will appear as the image below.

Note that some of these areas such as the Properties panel (5) and the Transformation panel (6) may not be visible, as they are contextual panels that only appear if you have something selected.

See the descriptions below for the functions of these labelled areas.

### 1) Main Menu

The main menu of the editor. Provides access to all main tools of the editor, including specialized functions. The main menu offers an alternate path to almost every tool or function in the editor.

### 2) Render View

The central window of the editor where you do most of your work. The content here will change contextually depending on what tool you currently have open, either displaying the map itself, scripting data, unit information, procedural mapping, or a number of other major interactive interfaces.

### 3) Asset Explorer

The master file display that lets you browse assets for your current project. Clicking a file in this list and dragging it onto the Render View will open the information in that file.

### 4) Scenario Tree

The area that contains all assets currently on your map, including all rocks, grasses, trees, units, and similar elements. If an asset has been given a specific name, it will displayed here under that name.

### 5) Object Browser

The central repository of all available objects you can import into your map. To import an object from the Object Browser onto your map, find it here and drag it onto the Render View.

Hidden in tabs behind the Object Browser are also four additional panels: Console, Error List, History, and Output. These panels each have a specialized function.

### 6) Properties

Displays all information related to the currently-selected asset. Also contains a variety of editing tools the modify the selected asset. The information here will change depending on what asset you currently have selected, and if nothing is selected it will appear blank.

### 7) Transformation

Contains all the tools for transforming the currently-selected asset, including moving, rotating, scaling, grid snapping, and similar functions. The information here will change depending on what asset you currently have selected, and if nothing is selected the interface will not appear at all.

### 8) Playback

Allows you to Play, Pause, or Stop the any animations in the scene. Animations can include tree and grass sway, unit idle animations, smoke, clouds, butterflies, and similar effects.

---

## Article 2: 1 - Main Menu

### Overview

The Main Menu offers access to all the tools available in the Content Editor, including functions, panels, and other specialized tools.

This menu appears along the top of the editor interface, and is organized into two rows of menu items:

1. A series of Drop-Down Menus along the top row, listed below.
2. A series of Tool Icons along the bottom row, customized through the Windows menu.

### Drop-Down Menus

Provided below are quick descriptions and links to guides for each section of the main menu.

| Menu Item | Description |
| --- | --- |
| File | Options that cover general file functions such as New, Open, Save, Import, and Export. |
| Edit | Options that cover standard editing functions such as Undo, Copy, Paste, and Find. |
| View | Options that allow you to open and control various tool panels in the Content Editor. |
| Build | Provides options related to packaging your files and burning your mod so that you can play it. |
| Burn | Includes options that offer more control over what files are cleaned from your cache. |
| Attributes | Includes controls and access to datasets when using Tuning Packs. |
| Reflect | Contains a number of tools for finding and organizing data. |
| Localization | Options for working with localized text such as text and UI elements. |
| Scenario | Contains most tools you'll need to edit a scenario as well as a large list of visual display toggles. |
| Script | Contains controls related to scripting. |
| Tools | Options that allow you to customize and optimize the various tools within the Content Editor. |
| Window | Allows for the customization, saving and loading of Content Editor panel configurations. |
| Help | Shows the information about your current version of the software. |

---

## Article 3: 2 - Render View

### Overview

The Render View is located in the center of the editor's UI and is the main viewport you use to perform your work.

The content here will change depending on what type of mod you are working on:

- When working on a Crafted Map, this is the main area where you make changes to the game world, allowing you to pan around, select objects, edit objects, and modify imported content.
- When working on Tuning Pack, this is where the attribute editor appears.
- When working on a Generated Map or Game Mode, this is where the script information appears.

### Displaying the Render View

If the Render View is not displayed, it can be opened manually through the Main Menu under: View > Render.

### Render View Cameras

When working on a map, a variety of alternate camera views for the Render View are available under: Main Menu > Scenario > Switch Camera

These camera views allow you to change how map information is displayed in this window.

- **Game Camera** — Switches to the default camera used in-game, with identical zoom levels and view angles.
- **Tools Camera** — The default editor camera that allows control beyond the limitations of what is seen normally in-game.
- **Debug Camera** — Free-form camera that allows for unhinged navigation, allowing for extremely close up view of objects, units, and other elements.
- **OrthoTop Camera** — Direct, top-down view, similar to the minimap.
- **OrthoFront Camera** — Front cross-section view. Use Alt + Left click + Drag additional zoom in and out of the scene.
- **OrthoBack Camera** — Back cross-section view. Use Alt + Left Click + Drag for additional zoom in and out of the scene.
- **OrthoRight Camera** — Right cross-section view. Use Alt + Left Click + Drag for additional zoom in and out of the scene.
- **OrthoLeft Camera** — Left cross-section view. Use Alt + Left Click + Drag for additional zoom in and out of the scene.

---

## Article 4: 3 - Asset Explorer

### Overview

The Asset Explorer is where all the source working assets for your map are stored, such as materials, textures, and scenarios are found within the editor. Essentially, the Asset Explorer acts identically to Windows File Explorer for viewing these assets, and both these file explorers will have the same content within them.

Opening a file through the Asset Explorer allows you to open its contents into the file into the Render View to make edits to them.

By default, the Asset Explorer appears along the right side of the Content Editor interface.

### Displaying the Asset Explorer

If the Asset Explorer is not displayed, it can be opened manually through the Main Menu under: View > Asset Explorer.

### Asset Explorer Layout

The Asset Explorer panel contains a number of basic functions.

The Search Field along the top of the panel will allow you to focus the folder or file content.

Folders can be expanded and collapsed to display information.

### Functions of Asset Explorer

The main function of the Asset Explorer is to Left-Click and drag items from the file structure onto the Render View to open their contents.

In the example below, you can see minimap being loaded.

If you close your map scenario by accident, you can re-load it by dragging and dropping the .scenario file in the Asset Explorer onto the Render View.

### Asset Explorer vs Object Browser

It is important to not mistake the Asset Explorer with the Object Browser. You cannot place assets from the Asset Explorer into a scene in the same way you can with the Object Browser. Instead, dragging an fbx or rgo file into the render window will simply open the file in the Render Window.

---

## Article 5: 4 - Scenario Tree

### Overview

The Scenario Tree panel contains the data for everything currently in your level, including objects, trees, grass, lighting effects, smoke effects, audio regions, players, starting positions, and similar entities currently on your map.

By default, this panel is located to the left of the Render View.

### Displaying the Scenario Tree

If the Scenario Tree is not displaying in the editor, it can be manually opened by performing the following steps:

1. In the Asset Explorer, find your map's .scenario file.
2. Left Click on the .scenario file and drag it onto the Render View. This will cause the map information to re-load into your current scenario, rebuilding and re-populating your Scenario Tree with the assets on your map.
3. The Scenario Tree will now be visible to the left of the Render View again.

### Scenario Tree Contextual Panel

Clicking on anything in the Scenario Tree will bring up a panel along the bottom of the interface that contains the functions and information related to whatever you clicked on.

This panel is contextual, with the content and controls changing depending on the type of element selected. If nothing is selected, this panel will not appear.

### Scenario Tree Tool Bar

The scenario tree Tool Bar appears along the top of the Scenario Tree panel.

This bar is extensive, and contains a large number of functions related to editing areas of your map.

Because they are so numerous, most of these controls will not be visible along the top of the Scenario Tree, and are accessed through the Expand button in the top-right corner of the panel.

Along the top of the Scenario Tree are a number of core functions that are always visible.

These are from left-to right.

### Default Mode

Default Mode is the standard mode for viewing a map.

It eliminates the normal Fog of War that shrouds vision on the map, allowing you to see and select any entity on the map.

### Fog of War Mode

Fog of War mode will turn on the Fog of War, only revealing the immediate area around your cursor.

When in Fog of War mode, a special FoV panel will appear along the bottom of the interface, allowing you to adjust the size of your sight revealing cursor.

### Ruler Mode

When active, this mode will allow you to see the distance between two points.

- Right-Click to place the first marker (blue)
- Left-Click to place the second marker (red)

On flat terrain, the measurement tool will draw a yellow line between the two points that will avoid impassable areas, showing where units can path.

When Ruler Mode is active, a special Rule panel will appear along the bottom of the screen that contains a number of controls related to the ruler tool.

**Pathfinding**

- Generic - Shows how a standard unit will path. The sliders allow you to adjust the type and size of this hypothetical unit.
- Entity - Shows how a specific unit will path. The entity can be chosen from the given list.

**Distances**

- Straight Line - Shows the exact distance between the two points.
- Elevation Delta - The elevation distance between the two points.
- Pathfinding - Shows the distance a unit will have to travel between the two points.

**Settings**

- Show Edge - shows the direct line between the two points, appearing as a blue line.
- Show Path - shows the unit path between the two points, appearing as a yellow line.

### Terrain Mode

Allows you to draw a box on your map to copy and/or move everything that is selected in the box.

### Name Selected Blueprint

Allows you to name the blueprint you currently have selected.

### Regenerate All

Will regenerate all Impassable and Non-Buildable areas after you have made edits.

For example, if you move a building, resource, or terrain slope, this will assure that all areas that are impassable and non-buildable are correctly generated.

You must save the map before the effects of these changes will appear in the editor.

---

## Article 6: 5 - Object Browser

### Overview

The object browser is the main panel for dragging and dropping any kind of object, asset, marker, splat, deform, or similar elements onto your custom map.

Nearly everything that can be imported into a map can be found here.

### Opening the Object Browser

Normally, the Object Browser is open by default and appears on the center-bottom of the main editor interface.

### Displaying the Object Browser

If the Object Browser is not already open, you can open the interface from the top tool bar by navigating: Scenario > Object Browser

### Using the Object Browser

The Object Browser is a navigable interface that allows you to search for, select, and drag items into the main viewport.

When you drag an item from the Object Browser onto the main viewport, the brush will change to match your selection. You may then click to place the object you selected.

### Object Tool Properties

When the base templates in the Object Browser are dragged into the viewport, they are often "blank" and need to have their tool properties set. To set the tool properties of a Base Template, use the Properties panel on the right side of the interface to set the specifics of the currently selected tool.

### Browsing via Folders

You can also browse the folders in the Object Browser to access various objects. If you navigate this way, all properties are already pre-loaded, allowing the tools to be used immediately without having to load.

When using these folders, simply drag a specific object onto the map to instantly import it.

### The Object Browser Bar

The Object Browser Bar appears along the top of the Properties Panel and contains a number of universal controls, regardless of what kind of entity is selected.

- **Refresh:** Refreshes the selection on all items.
- **Icon Size:** Changes the display icons in the interface to small, medium or large.
- **Details:** Changes the display to show a horizontal view that includes the details of the items in the Object Browser.
- **Search All:** Causes the search field to search all folders in the Object Browser.
- **Search Current:** Causes the search field to search the current folder in the Object Browser.
- **Arrow Buttons:** These buttons allow ease of navigation within the folders (back, forward, parent).

---

## Article 7: 5 - Console

### Overview

The Console panel allows you to enter console commands.

By default the Console panel is displayed along the bottom of the Content Editor interface, displayed in tabs behind the Object Browser.

It is recommended you only use this window if you are familiar with the Content Editor and the console commands you wish to enter.

---

## Article 8: 5 - Error List, History, and Output

### Overview

The Error List, History, and Output panels are specialized output displays that contain specific information on your mod.

By default, all three of these panels are displayed along the bottom of the Content Editor interface, nested within tabs.

### Displaying These Panels

If any of these panels are not displaying in the editor, each can be manually opened via the Main Menu through View.

### Error List

The Error list window provides a list of errors you may have encountered or introduced in to your crafted maps or related files.

For example: When saving a map you may get a pop up similar to the one below:

After clicking Yes or No the Error List will list all the Errors, Warnings and Messages accumulated this way.

- Double clicking any error on this list or pressing the load icon will take you to the issue in the Scenario tree.
- The refresh and clear commands will either refresh the error list results, or clear the results.
- The dropdown at left provides access to Current Document, Open Documents, or Burn Errors.

### History

The History Window provides a list of actions you have taken on your mod.

- You can select any item, and if desired, can undo everything after that point.
- You can step backwards, undoing the item, or step forward, redoing the next item on the list.

### Output

Output is a live log file for your mod.

Any messages traced in code will appear here.

---

## Article 9: 6 - Properties

### Overview

The Properties panel shows all information on whatever object or asset you currently have selected, as well as additional controls related to the selected object.

This quick guide covers what the Property panel does and basic functions you can perform with it.

### The Properties Panel

By default, the Properties panel appears on the right side of the editor interface and at first appears blank.

When an object is selected, information for the object will populate the panel.

### Displaying the Properties Panel

If the Properties panel is not displaying, you can display it by using the Main Menu and navigating to: View > Properties

### Properties Panel Layout

The type of asset you have selected will appear along the top of the Properties Panel.

In the example below you can see an "Entity Blueprint" has been selected, in this case, a tree.

### Properties Panel Information

The following section lists the various information contained in the Properties panel.

#### Editor

- **Comment** - Any comments added to the asset. In most cases this will be blank, but if you are intending to pass the map off to other creators, you can leave notes for each other here.
- **Display Name** - The name that will display in the scenario tree window. Most commonly used for splines, groups, or transformers to better organize them and set the export name.
- **Exclude from Game** - If checked, the asset will not show in game.
- **Locked** - If checked, the asset cannot be selected in the Render View.
- **Visible** - If unchecked, the asset will not be visible in the render view, but will still be visible in game.

#### Blueprint

- **Blueprint** - The file name of the selected object.
- **Owner** - The entity that controls the asset, either a specified player or the overall "world" for neutral assets.

#### Groups

- **Group Names** - The name of the group the asset belongs to, if any.

#### Scenario References

- **Exclude from scenario references** - If checked, the asset will not be present or visible in any referenced scenario.

#### Transform

- **Align Lock** - Controls how the object sits on the terrain angle.
  - Select None for a flat horizontal alignment.
  - Select Perpendicular to match the terrain angle.
- **Height Lock** - How the asset sits on top of the terrain.
  - Select None to detach the asset from the terrain, allowing you to move it anywhere.
  - Select Terrain to snap the asset to the terrain.
  - Select Surface to snap the asset to any collision surface, including water.
- **Offset** - Enter a value to offset the asset from height level. Allows you to elevate an asset from the terrain or surface while still following the height of terrain or surface.
- **Offset Lock** - Select from world Y or relative Y. If set to relative Y, the offset will be perpendicular to the terrain angle.
- **Orientation** - Shows the local angle x,y,z of the asset.
- **Position** - Shows the exact position of the asset. The value 0/0 indicates the exact center of the map.
- **Scale** - Allows you to set a different proportional scale. "1" is equivalent to 100% scale.

---

## Article 10: 7 - Transformation

### Overview

The Transformation panel allows you to make changes to a selected object. When an object is not selected, the transformation panel will not appear.

By default, the Transformation panel will appear along the right-side of the editor interface, below the Properties panel.

### Displaying the Transformation Panel

If the Transform panel is not appearing, you can manually open it by going to: File > Scenario > Transformation

### Transform Functions

The Transform panel has a number of functions that are consistent regardless of what type of object you have selected.

### Main Toolbar

The main toolbar along the top of the Transformation panel contains a number of core functions for manipulating the object. These functions are listed left-to-right below.

#### Main Functions

- **Move:** Allows you to move the selected object to a new location.
- **Rotate:** Allows you to rotate the selected object along a number of axis.
- **Scale:** Allows you to adjust the size of the selected object.
- **Rect Transform:** Allows you to manipulate the position and scale of the selected object's footprint. See the section below for additional information.

#### Space Functions

- **World Space:** Causes changes to take place in the world space.
- **Parent Space:** Causes changes to take place in the parent space.
- **Local Space:** Causes changes to take place in the local space.

#### Pivot Functions

- **Central Pivot:** Sets the central pivot point to the middle of all selected objects.
- **Individual Pivot:** Sets the pivot point at the center of each selected object.

#### Misc Functions

- **Random Rotator:** When selected, will randomize the rotation of each new placed object.
- **Translation Only Rect Transform:** When selected, when using rectangular transform to scale an object, only the position of the object will be scaled, and not the object itself.

#### Snapping

These tools allow you to snap the object to fine tune its placement:

- **Snap To Grid:** If checked, snaps the object to the map's grid. The grid size can be set by the slider.
- **Snap To Height:** If checked, will only allow the object to be raised or lowered by the pre-set amounts set by the slider.
- **Snap To Rotation:** If checked, will only allow the object to be rotated at the pre-set angle set by the slider.

### Rectangular Transform

The Rect Transform tool has a number of functions that may not immediately be apparent. We will cover these functions below.

#### Scaling Splats and Splines

One of the main functions of the Rect Transform tool is to manipulate Splats and Splines, allowing you to perform the following:

- Scale splats visually without manually typing the size.
- Adjust the scale of a curved spline.
- Adjust the scale multiple splines at once. Note that when working with splines, only the control points will be scaled, and not the strip of the spline itself.
- Scaling the position of a number of selected assets. Note that in the example below, the rocks get closer but do not scale in size.

---

## Article 11: 8 - Playback

### Overview

The Playback controls allow you to Pause, Play, Stop, and Reset the scene of your map.

This can be useful for seeing an accurate representation of how your map will look like in-game, including unit animations, smoke, flowing water, waving grass, and similar effects.

If your map has any scripted events such as unit patrols or pre-set actions, the Playback controls will cause these events to play out in real-time.

By default, the Playback controls can be found on the right side of the Content Editor interface, below the Properties panel.

### Displaying the Playback Panel

If the Playback controls are not appearing in your Editor Interface, they can be manually opened through: Main Menu > View > Playback

### Playback Controls

The playback controls are relatively straightforward, consisting of Play, Pause, Stop, and Reset functions.

- **Play** — The Play button will begin the playback of your map. You can see the time stamp of your map's current playback displayed underneath the Play button.
- **Pause** — The Pause button will halt the playback of your map at its current timestamp.
- **Stop** — The Stop button will halt and reset the playback to the 0.00 marker.
- **Reset** — The Reset button will reset the playback to the 0.00 marker, but allow the scenario to keep playing from that point.

---

## Article 12: Main Menu - File

### Overview

The File dropdown in the Main Menu contains the core file functions such as opening new mods, saving your mod, and exporting your mod once it is finished.

### File Menu Functions

| Menu Item | Description |
| --- | --- |
| New | Opens the master menu for creating a new mod. |
| New Mod | Opens the main menu for creating a entirely new mod. |
| Run Asset Wizard | Opens the mod wizard for crafting a new asset for your mod. |
| Open | Opens a dialogue to browse anywhere on your machine. |
| Recent Files | Opens a short list of the most recent files you have worked on. |
| Recent Mods | Opens a short list of the most mods you have worked on. |
| Reload from Disk | Reloads from disk any file you currently have open in a window. |
| Save | Saves the current element of the mod you have open. |
| Save As | Saves your mod under a new name. |
| Save All | Saves all the changes you have made to all aspects of your mod. |
| Import | Imports data from a saved mod into the current one. |
| Export As | Exports your current mod. |
| Close | Closes the current item your current mod. |
| Close All | Closes all items in your current mod. |
| Close Mod | Closes the mod you currently have open. |
| Exit | Closes the Content Editor. |

---

## Article 13: Main Menu - Edit

### Overview

The Edit menu contains a variety of undo, copy, paste, and find/replace functions.

### Edit Menu Functions

| Menu Item | Description |
| --- | --- |
| Undo | Undo your last command. |
| Redo | Redo your last command. |
| Cut | Removes the selected item and copies it to the clipboard. |
| Copy | Copies the selected item to the clipboard. |
| Copy Mod Guid | Copies the GUID (Globally Unique Identifier) associated with the mod. |
| Paste | Pastes the current object on the clipboard. |
| Find | Allows access to a number of specialized search functions. See workflow below for details. |
| Replace | Specialized command for replacing scripts. Non-functional unless you have a script open. |

---

## Article 14: Main Menu - View

### Overview

The View menu opens access to the most common windows in the content editor, such as the Render view, Console, Error List, and similar tools.

This menu also contains a number of additional controls to show additional elements and take screenshots.

### View Menu Functions

| Menu Item | Description |
| --- | --- |
| Asset Explorer | Opens the Asset Explorer that shows the source content of the project. |
| Console | Opens the Console window, which allows you to enter console commands. |
| Error List | Opens the Error List window that shows you a list of errors you may have in your scene or asset. |
| History | Opens the History window which provides a list of action undertaken by the user. |
| Output | Opens the Output window which displays a live log file. Messages that are traced anywhere in code will appear here. |
| Properties | Opens the Properties window, which displays specialized information on the selected asset. |
| Playback | Opens the Playback window, allowing you to Pause or Play the scene environmental effects. |
| Render View | Opens the main Render View at the center of the editor, where you can see your map and or content pack. |

---

## Article 15: Main Menu - Build

### Overview

The Build menu contains controls for building your mod.

### Build Functions

| Menu Item | Description |
| --- | --- |
| Build Mod | Takes all the content that is in your mod, packages it, and burns it so you can play your game mod. |
| Clean Mod | Deletes all the temp files associated with your mod. Note that "Clean" function in the Build menu differs from the "Clean" functions in the Burn menu. |

---

## Article 16: Main Menu - Burn

### Overview

The Burn menu offers tools involving managing the cache of your mod.

### Burn Menu Functions

| Menu Item | Description |
| --- | --- |
| Clean... | Every time you make a change, a temporary copy is saved to the cache. This option opens a dialogue that allows you to select which items in your cache you wish to delete. Note that the "Clean" function in the Burn menu differs from the "Clean" function in the Build menu. |
| Clean Cache | Cleans the entire cache. |
| Auto Close Burn Window | Toggles the "Auto Close Burn Window" option. |

---

## Article 17: Main Menu - Attributes

### Overview

The Attributes menu grants access to all the various types of data when working with Tuning Packs.

Most of these options require you to open up and be modifying a Tuning Pack. Attribute files can be found in the Asset Browser by navigating to Cardinal > Attrib.

### Attribute Menu Functions

| Menu Item | Description |
| --- | --- |
| Advanced | Opens a contextual attribute menu. |
| Mods | Not relevant to the current Content Editor feature set. |
| Enums | Not relevant to the current Content Editor feature set. |
| Templates | Not relevant to the current Content Editor feature set. |
| Find in Attributes | Searches attribute data using a defined keyword. Recommended method of navigating the large amount of game data within Age of Empires IV. |
| Go to Category | Jumps to a defined section in the attributes. Alternative to scrolling. |

---

## Article 18: Main Menu - Reflect

### Overview

The Reflect menu is used to access state tree data.

The Age of Empires IV Content editor does not currently support these functions.

### Reflect Menu Functions

| Menu Item | Description |
| --- | --- |
| Favorites | Not relevant to the current Content Editor feature set. |
| Type Browser | Not relevant to the current Content Editor feature set. |
| Find In Data Objects | Not relevant to the current Content Editor feature set. |
| Go To Dag Path | Not relevant to the current Content Editor feature set. |
| Go To Data Object | Not relevant to the current Content Editor feature set. |
| Save Migrated | Not relevant to the current Content Editor feature set. |

---

## Article 19: Main Menu - Localization

### Overview

Items in the Localization menu allow you to work with and modify the text assets in your mod (called "localized strings").

These options are only relevant if you have opened your mod's localization database.

### Localization Menu Functions

| Menu Item | Description |
| --- | --- |
| Spell Check | Runs a spell check on the contents of your localization database (this includes all the text assets in your mod). |
| Show Out of Date Translations | (Toggle on/off) If enabled, highlights foreign language strings in which either of the following is true: The string has never been translated. The English string has changed since it was last translated. Note that the highlighting occurs only on the translation field itself, so relative language must be displayed to see this. |
| Ignore Out of Date Case | (Toggle on/off) If enabled, the above highlighting ignores changes in the English text that consist only of capitalization. |
| Ignore Out of Date Punctuation | (Toggle on/off) If enabled, the above highlighting ignores changes in the English text that consist only of punctuation. |

---

## Article 20: Main Menu - Scenario

### Overview

The Scenario Menu contains most tools you will need to edit a scenario as well as a large list of visual toggles.

This will be one of the most commonly used menus when working on a map within the Content Editor.

### Scenario Menu Functions

Due to its size, the Scenario Menu has been broken down into multiple sections, separated by main category of function and detailed below.

### Panel Options

These options open new panels within the editor.

| Menu Item | Description |
| --- | --- |
| Audio Region Template | Opens the Audio Region Templates panel that allows you to set the map's audio template. |
| Blueprint List | Opens the Blueprint List that shows all the blueprints that are currently in your map. |
| Blueprint Painter | Opens the Object Painter panel that contains controls for modifying your object brush size. |
| Group List | Opens the Group List panel, showing all currently active groups in your map. |
| Minimap | Opens the Minimap panel that shows an active minimap of your map, as it would appear in game. |
| Object Browser | Opens the Object Browser panel that contains all objects you can import into your map. |
| Painter | Opens the Painter panel that controls your left mouse button and right mouse button painter tools. |
| Palettes | Opens the Palettes panel that allows you to manage and display all sets of brushes currently loaded into your map. |
| Transformation | Opens the Transformation panel that allows you to modify the size, rotation, and similar aspects of an object. |
| Resize Tool | Opens the Resize Scenario panel that allows you to modify overall size of your map. |
| Generators | Opens the Generators drop-down menu that contains a number of terrain modification tools. |
| Last Used Generator | Selects your last used Generator tool. |

### Information Options

These options offer new ways to view information in the editor.

| Menu Item | Description |
| --- | --- |
| Switch Camera | Choose from a variety of camera options, each offering a unique view. |
| > Game Camera | Simulates the in-game camera, including restricted zoom levels. |
| > Tool Camera | The default camera, allowing for the largest freedom in zoom. |
| > Debug Camera | Switches to a zoomed-in, ground-level view for viewing fine details. |
| > Ortho Top | Shows a simple top-down view of the map. |
| > Ortho Front | Shows a cross-section of the map from the front of the map. |
| > Ortho Back | Shows a cross-section of the map from the back of the map. |
| > Ortho Right | Shows a cross-section of the map from the right side of the map. |
| > Ortho Left | Shows a cross-section of the map from the left side of the map. |
| Validate Position | Toggles the camera position. If you paint an area with elements you can interact with, it will constrain the camera to that area. If nothing is painted, it will constrain the camera to the terrain. |
| Toggle Atmosphere Fog | Shows/Hides atmospheric fog. |
| Toggle FX | Shows or hides visual effects (smoke, fire, etc). In the current version of the editor, this function is disabled. |
| Toggle Rendering Meshes | Shows or hides all 3D meshes, including objects, visuals, EBPs, etc. |
| Game Object Layers | Shows or hides specific 3D meshes, similar to the function above, but more targeted. |
| > Default | Shows or hides all rendered objects, including buildings, resources, stamps, effects, etc. |
| > Terrain | Not relevant to the current Content Editor feature set. |
| > Clearables | Shows or hides clearable objects, such as bushes and decorative rocks. |
| Display Chunks | Shows the Tile chunk borders. |
| Display Interactivity | Not relevant to the current Content Editor feature set. |
| Display Playable Area | Draws a thin red border between the playable and non-playable (out of bounds) area on the map. |
| Display Land Tile Counts | Shows the number of texture tiles / chunk on the terrain. |
| Display Water Tile Counts | Shows the number of water tiles / chunk on the water. |
| Display Action Markers | Hides any action markers placed on the map. |
| Display Construction Grid | Shows the grid used by the AoEIV buildings to ensure alignment. |
| Display Districts in Construction Grid | Not relevant to the current Content Editor feature set. |
| Display Entity Extensions | Extra debug visualization based on entity that you're viewing. It shows walkable surfaces for bridge. |
| Display Entity Line of Sight Blockers | Not relevant to the current Content Editor feature set. |
| Display Entity Shot Blockers | Not relevant to the current Content Editor feature set. |
| Display Grass | Hides grass on the terrain. |
| Display Lights | Hides the light object "icon", but the light remains. |
| Display Light Debugging | Not relevant to the current Content Editor feature set. |
| Display Messages | Hides any "message" objects / text on the map. |
| Display Mesh Areas | For generated forests, this shows the triangle mesh area. |
| Display Movement Nodes | Movement nodes are unused on the Age IV project, using this toggle will have no effect. |
| Display Prefab Markers | Hides Prefab Marker elements. |
| Display Prefab Marker Connections | Hides Prefab Marker Connection elements. |
| Display Prefab Names | Hides Prefab Marker Proximity elements. |
| Display Prefab Marker Names | Hides Prefab Marker Name elements. |
| Display Scar Markers | Hides Scar Marker elements. |
| Display Scar Marker Names | Hides Scar Marker Name elements. |
| Display Scar Marker Proximity | Hides Scar Marker Proximity elements. |
| Display Snow | Not relevant to the current Content Editor feature set. |
| Display Splats | Not relevant to the current Content Editor feature set. |
| Display Water | Not relevant to the current Content Editor feature set. |
| Display Water Flood and Flow Markers | Shows and hides the markers used to set water height and direct water flow. |
| Display Waypoint Path | Shows waypoint path. |
| Display Waypoint Path Names | Toggles the visibility of the waypoint path spline names. |
| Debug | Not relevant to the current Content Editor feature set. |
| Overlays | Contains a selection of crafted map or design related overlays. |

### Overlay Options

These options will place an overlay on the Render View.

| Menu Item | Description |
| --- | --- |
| None | Removes all overlays. |
| Audio Region Map | Shows/hides any painted audio region. |
| Can't Build Map | Displays location that the player wont be able to build. |
| Camera Mesh | Shows/hides the Camera Mesh. |
| Cover Map | Shows/hides the Cover Map. |
| Impasse Map | Shows/hides the Impass Map. |
| Grid | Shows/hides a checkerboard image over the map, size can be edited in Tools/Settings/Scenario Settings/Overlay. |
| Grid Lines | Shows/hides a grid image over the map, size can be edited in Tools/Settings/Scenario Settings/Overlay. |
| Interactivity Map | Shows/hides the Interactivity Map. |
| Material Map | Shows/hides the Material Map, displaying different material types by colour. |
| Metadata Map | Shows/hides the Metadata Map. Note that only the top-of-the-list option in Metadata Map is displayed. |
| Path Map | Shows where the player can't path through. |
| Territory Influence Map | Not relevant to the current Content Editor feature set. |
| Territory Cell Map | Not relevant to the current Content Editor feature set. |
| Overlay Camera Mesh On Top | Not relevant to the current Content Editor feature set. |
| Overlay Impass Map Paint | Shows/hides a subset of Impass Map. |
| Overlay Impass Map Objects | Shows/hides a subset of the Impass Map. |
| Overlay Impass Map Terrain | Shows/hides a subset of the Impass Map. |
| Overlay Territory Flash Nil | Not relevant to the current Content Editor feature set. |
| Overlay Territory Flash Unconnected | Not relevant to the current Content Editor feature set. |

---

## Article 21: Main Menu - Script

### Overview

Scripts are pre-defined sections of code that can create a wide variety of functionality within a scenario, such as adding alternate victory conditions, creating new game modes, and triggering scripted events.

The script menu contains tools and commands for working with, organizing, and importing scripts inside your scenario.

### Script Menu Functions

| Menu Item | Description |
| --- | --- |
| Open File in Project... | Shows all your script files. Serves as a shortcut for finding and opening scripts in your mod. |
| Find In Files | Opens a find function for the scenario for scripts. |
| Replace in Files | Opens a find/replace command for the scripts in your scenario. |
| Go To... | Go-to command for your currently open script. Does not function unless a script is open. |
| Bookmarks | Opens a secondary sub-menu with commands relating to script bookmarks. See Bookmarks below. |
| Breakpoints | Opens a secondary sub-menu with a list of breakpoints for use in debugging. See Breakpoints below. |
| Debugging | Opens a secondary sub-menu with commands relating to debugging scripts. See Debugging below. |
| Attach | Attaches an editor to game to perform debugging. |
| Detach | Detaches the editor from game to stop debugging. |
| Run | If execution is paused at a breakpoint, this command resumes execution and runs the currently-selected script. |
| Step Into | If an obstruction pointer is on a line with a function it will break within that function. |
| Step Out | If execution is paused/broken within a function, this moves to the first instruction outside of that function. |
| Step Over | Skips a function. |
| Show Line Numbers | Toggle visibility of line numbers in script editor. |
| Documentation | Opens the official documentation for working with scripts. |

### Bookmarks Sub-Menu

| Menu Item | Description |
| --- | --- |
| Bookmarks | Opens the Bookmarks panel. |
| Toggle bookmarks | Shows or hides the bookmark your cursor is currently over. |
| Toggle All Bookmarks | Shows or hides all bookmarks. |
| Previous Bookmark | Goes to the previous bookmark in your master library. |
| Next Bookmark | Goes to the next bookmark in your master library. |
| Clear Bookmarks | Clears all bookmarks. |
| Previous Bookmark in Document | Goes to the previous bookmark in your current scenario. |
| Next Bookmark in Document | Goes to the next bookmark in your current scenario. |

### Breakpoints Sub-Menu

| Menu Item | Description |
| --- | --- |
| Breakpoints | Opens the Breakpoints panel. |
| Toggle Breakpoint | Toggles a single breakpoint on/off. Breakpoints that are toggled off will cause execution to no longer pause on that breakpoint. |
| Toggle All Breakpoints | Toggles all breakpoints on/off. Breakpoints that are toggled off will cause execution to no longer pause on that breakpoint. |
| Clear Breakpoints | Clears all breakpoints in breakpoint list. |

### Debugging Sub-Menu

| Menu Item | Description |
| --- | --- |
| Call Stack | Opens the Call Stack panel. If you have a script open, this will show the call stack of all the currently executing functions as a stack. |
| Globals | Opens the Globals panel. This requires you to have a script open. Not declared with local prefix in LUA. |
| Locals | Opens the Locals panel. Declared with local prefix in LUA. |

---

## Article 22: Main Menu - Tools

### Overview

The Tools menu offers different ways to optimize your user experience while working within the Content Editor.

This functionality includes setting up hot keys or short cuts, choosing various tool bars to show or hide, and modifying tool or gizmo colours for visibility.

### Tools Menu Functions

| Menu Item | Description |
| --- | --- |
| Mute Audio | Mutes all audio input from the editor. In the current version of the editor, this has been disabled. |
| Customize Commands | Allows you to edit hotkeys and shortcuts for nearly all tools and functions within the Content Editor. See below. |
| Customize Toolbars | Allows you to show or hide toolbars, as well as create your own toolbars. See below. |
| Settings | Allows you to set a vast array of default settings. |

### Customize Commands

Clicking on Customize Commands will cause the Command Customizer interface to appear.

This interface allows you to customize keyboard shortcuts for almost any function in the editor.

The list of possible functions is incredibly large. It is recommended you use the Search field to find the function you are looking for.

If a key command is currently being used for a function, it will appear in the Shortcut for Selected Command field when that command is selected. If no key is currently tied to it, this field will appear blank.

To delete a currently-assigned keyboard shortcut, have it selected and press the "-" button beside the Shortcut for Selected Command field.

To assign a new key binding for a command, select the command and:

1. Make sure the Shortcut for Selected Command field is blank.
2. Enter your new key combination into the Press Shortcut Keys field.
3. Press the "+" button beside the Press Shortcut Keys field.
4. Your shortcut will now be saved and ready for use.

If the key combination you just made is already in use by another shortcut, it will appear in the Shortcut Currently Used By field.

### Customize Toolbars

Clicking on Customize Toolbars will cause the ToolBar Customizer interface to appear.

This interface allows you to show or hide various existing sets of toolbars, as well as create and save toolbars of your own.

This interface has two tabs:

1. **ToolBars** is a list of all available toolbars and contains controls for creating toolbars.
2. **Commands** shows the content of each toolbar. Double-click an item in the ToolBars tab to view its contents.

To enable a toolbar, Select the toolbar in the ToolBars tab and Tick the box next to it. That toolbar will then appear at the top of the main editor interface directly below the Main Tool Bar.

Un-Ticking its box will hide a toolbar.

The ToolBar tab has a pair of Up and Down buttons at the bottom of the interface to move a selected toolbar up or down.

The ToolBar tab also has an Import and an Export button at the bottom of the interface that allows you to import a toolbar you have in another scenario, or save a toolbar you have made in this one for export into another scenario.

---

## Article 23: Main Menu - Window

### Overview

The Window menu allows you to save, modify, and import various editor window layouts you have created.

### Window Menu Functions

| Menu Item | Description |
| --- | --- |
| Save Window Layout | Allows you to name and save your current window layout. |
| Apply Window Layout | Allows you to apply any window layout you have saved to your current editor. |
| Manage Window Layouts | Opens an interface that allows you to rename and delete your saved window layout. |
| Reset Window Layout | Re-sets your current window layout to the default layout. |
