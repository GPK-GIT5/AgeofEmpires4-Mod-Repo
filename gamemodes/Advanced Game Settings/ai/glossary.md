# Glossary: Advanced Game Settings

<!-- DOC:GLOSSARY:MAIN -->

**Last Updated**: 2026-03-01  
**Authority**: Derived from README.md + Age of Empires IV domain knowledge  
**Purpose**: Define AGS-specific terminology and concepts

---

## Framework & Technology

<!-- DOC:GLOSSARY:FRAMEWORK -->

### AGS (Advanced Game Settings)
Comprehensive multiplayer gamemode framework for Age of Empires IV that allows players to customize win conditions, starting scenarios, gameplay modifiers, and diplomacy settings. Consists of 97+ SCAR files (~15,000 lines of code).

**Source**: README.md line 1

### Cardinal.scar
Relic Entertainment's delegate-based mission framework for Age of Empires IV. Provides lifecycle management through 6 phases: Setup → Init → PostInit → Preset → PreStart → Start. AGS is built on top of Cardinal.

**Source**: README.md line 20

### Delegate
A callback function registered with Cardinal.scar that is invoked at specific lifecycle phases. Delegates enable modular initialization and event handling across multiple systems.

**Source**: README.md line 85

### SCAR (Scripting At Relic)
Lua 5.x-based scripting language used for Age of Empires IV custom scenarios and gamemodes. Files use `.scar` extension.

**Source**: README.md line 15

---

## Win Conditions

<!-- DOC:GLOSSARY:WIN_CONDITIONS -->

### Conquest
Standard elimination win condition. Victory is achieved by destroying all enemy landmarks (Town Centers, keeps, and unique civ landmarks).

**Source**: README.md line 110

### Wonder Victory
Players race to build a Wonder and defend it for a specified time period. First player to successfully hold their Wonder wins.

**Source**: README.md line 120

### Sacred Sites
Map-specific holy locations that players capture and hold. First player to reach target score (accumulated over time holding sites) wins.

**Source**: README.md line 125

### Landmark Race
Victory condition where players must build all available landmarks before their opponents. Encourages aggressive expansion and building.

**Source**: README.md line 130

### Regicide
Each player starts with or receives a unique "king" unit. Victory is achieved by eliminating all enemy kings while protecting your own.

**Source**: README.md line 135

### King of the Hill
Players compete to control a central landmark. Victory goes to the player who controls it for the longest cumulative time.

**Source**: README.md line 140

### Treaty
Peace period at the start of the match where combat is prohibited. After the treaty expires, standard rules (typically Conquest) apply.

**Source**: README.md line 145

---

## Starting Scenarios

<!-- DOC:GLOSSARY:STARTING_SCENARIOS -->

### Nomad Start
Players begin with starting villagers but no Town Center. Players must find a location to build their first TC, adding strategic map control decisions.

**Source**: README.md line 170

### Dark Age Rush
All players start in Age I (Dark Age) with modified tech tree access. Encourages early aggression and rush strategies.

**Source**: README.md line 180

### King of the Hill Start
Players spawn near a central landmark that is the focus of the King of the Hill win condition. Emphasizes early control of the center.

**Source**: README.md line 185

---

## Core Concepts

<!-- DOC:GLOSSARY:CORE -->

### Blueprint
Relic's data-driven entity definition system. Blueprints define properties for units, buildings, and abilities. AGS uses blueprints for dynamic game object creation and modification.

**Source**: README.md line 290 + AoE4 domain knowledge

### Gameplay Modifier
Configurable rule that alters core game mechanics. AGS includes 30+ modifiers such as population cap adjustment, resource multipliers, tech tree restrictions, and unit exclusions.

**Source**: README.md line 220

### Observer UI
XAML-based interface panels that provide real-time information to spectators. Shows win condition progress, player stats, and match status.

**Source**: README.md line 350

### Lock Teams
Diplomacy setting that prevents players from changing alliances mid-match. Ensures teams remain fixed after game start.

**Source**: README.md line 300

---

## Technical Terms

<!-- DOC:GLOSSARY:TECHNICAL -->

### Constants (AGS_GS_*)
Global configuration values defined in `ags_global_settings.scar`. All AGS constants use the prefix `AGS_GS_*` and follow SCREAMING_SNAKE_CASE naming convention. Over 100 constants control gamemode behavior.

**Source**: README.md lines 420-450

### Lifecycle Phase
One of the 6 Cardinal.scar initialization stages: Setup, Init, PostInit, Preset, PreStart, Start. Each phase serves specific initialization responsibilities.

**Source**: README.md line 85

### XAML (eXtensible Application Markup Language)
XML-based UI definition language used for Age of Empires IV interface elements. AGS uses XAML for observer panels and player settings screens.

**Source**: README.md line 350 + AoE4 domain knowledge

---

## File & Directory Terminology

<!-- DOC:GLOSSARY:FILES -->

### `ags_cardinal.scar`
Main orchestrator file (285 lines) that serves as the entry point for AGS. Registers delegates with Cardinal.scar and initializes core systems.

**Source**: README.md line 420

### `ags_global_settings.scar`
Central configuration file (1,189 lines) containing 100+ constants that control AGS behavior. Imported by all modules.

**Source**: README.md line 450

### `conditions/`
Directory containing 11 win condition implementation files. Each file is self-contained and handles a specific victory condition.

**Source**: [file_index.md](file_index.md) + README.md line 110

### `startconditions/`
Directory containing 7+ starting scenario implementation files that modify initial game state.

**Source**: [file_index.md](file_index.md) + README.md line 170

### `helpers/`
Utility module directory containing shared functions for team management (`ags_teams.scar`), starting scenarios (`ags_starts.scar`), and blueprint resolution (`ags_blueprints.scar`).

**Source**: [file_index.md](file_index.md)

---

## Acronyms

<!-- DOC:GLOSSARY:ACRONYMS -->

| Acronym | Full Name | Description |
|---------|-----------|-------------|
| AGS | Advanced Game Settings | This gamemode framework |
| SCAR | Scripting At Relic | Lua-based scripting language |
| TC | Town Center | Primary economic building and landmark |
| KOTH | King of the Hill | Win condition type |
| XAML | eXtensible Application Markup Language | UI definition format |
| UI | User Interface | On-screen display elements |

---

## Authority Note

This glossary is derived from README.md documentation and general Age of Empires IV domain knowledge. Terms marked "Unknown" or requiring deeper technical detail should be verified by inspecting source code directly.

**Verified**: Term definitions from README  
**Unverified**: Implementation-specific details (exact data structures, function signatures, etc.)

For complete technical specifications, see:
- [architecture.md](architecture.md) for system design
- [file_index.md](file_index.md) for file locations
- [settings_schema.yaml](settings_schema.yaml) for configuration constants
- [capabilities_map.md](capabilities_map.md) for feature implementations
