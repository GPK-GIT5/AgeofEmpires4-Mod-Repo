# Gameplay Scripts Index

131 SCAR scripts from the gameplay systems. Source: `Combined Gameplay.scar`

## Core Systems

| Script | Line | Description |
|--------|------|-------------|
| **cardinal.scar** | 5949 | Core game framework - player setup, module registration, initialization |
| **cardinal_encounter.scar** | 7853 | Core encounter system |
| **cardinal_narrative.scar** | 8432 | Narrative/story system |
| **gamesetup.scar** | 26987 | Game initialization and setup |
| **gamefunctions.scar** | 26550 | Core game utility functions |
| **gamescarutil.scar** | 26857 | SCAR utility functions |
| **network.scar** | 48402 | Network multiplayer events |
| **designerlib.scar** | 21488 | Designer utility library |
| **mission.scar** | 30771 | Base mission framework |

## Win Conditions

| Script | Line | Description |
|--------|------|-------------|
| **annihilation.scar** | 560 | Eliminate all enemy units/buildings |
| **conquest.scar** | 16332 | Destroy enemy landmarks |
| **elimination.scar** | 23572 | Player elimination |
| **regicide.scar** | 53117 | Kill the enemy king |
| **religious.scar** | 53554 | Sacred Sites / Religious victory |
| **wonder.scar** | 69482 | Wonder victory |
| **surrender.scar** | 65831 | Surrender handling |
| **score.scar** | 63456 | Score tracking |

## Game Modes

| Script | Line | Description |
|--------|------|-------------|
| **standard_mode.scar** | 65109 | Standard game mode |
| **combat_mode.scar** | 14839 | Combat-focused mode |
| **king_of_the_hill_mode.scar** | 28958 | King of the Hill |
| **full_moon_mode.scar** | 25928 | Full Moon mode |
| **chaotic_climate_mode.scar** | 9438 | Weather effects mode |
| **seasons_feast_mode.scar** | 63994 | Seasonal feast mode |
| **sandbox_mode.scar** | 63328 | Sandbox/free build |
| **map_monsters_mode.scar** | 29862 | Map monsters mode |
| **none_mode.scar** | 48458 | No special mode |
| **empirewars.scar** | 23792 | Empire Wars start |
| **chart_a_course.scar** | 11095 | Chart a Course mode |
| **classic_start.scar** | 13660 | Classic start mode |

## Army System

| Script | Line | Description |
|--------|------|-------------|
| **army.scar** | 1020 | Army initialization, targets, movement, combat |
| **army_encounter.scar** | 2351 | Army AI encounter integration |
| **ai_encounter_util.scar** | 514 | AI encounter utility functions |

## MissionOMatic System

| Script | Line | Description |
|--------|------|-------------|
| **missionomatic.scar** | 31006 | Core mission orchestration |
| **missionomatic_actionlist.scar** | 32101 | Action list definitions |
| **missionomatic_allybanners.scar** | 33222 | Allied banner decorations |
| **missionomatic_artofwar.scar** | 33316 | Art of War challenges |
| **missionomatic_audiotrigger.scar** | 33961 | Audio trigger system |
| **missionomatic_battalions.scar** | 34259 | Battalion management |
| **missionomatic_conditionlist.scar** | 34614 | Condition definitions |
| **missionomatic_custommetrics.scar** | 35385 | Custom metrics tracking |
| **missionomatic_leader.scar** | 35494 | Leader unit management |
| **missionomatic_leadertent.scar** | 35905 | Leader tent system |
| **missionomatic_location.scar** | 36052 | Location/area management |
| **missionomatic_objectives.scar** | 37064 | Objective management |
| **missionomatic_playbills.scar** | 37490 | Playbill/narrative triggers |
| **missionomatic_raiding.scar** | 37667 | Raiding system |
| **missionomatic_reporting.scar** | 38184 | Reporting/stats |
| **missionomatic_unitrequests.scar** | 38348 | Unit request/spawn system |
| **missionomatic_upgrades.scar** | 39054 | Upgrade management |
| **missionomatic_utility.scar** | 40717 | MissionOMatic utilities |
| **missionomatic_wave.scar** | 43086 | Wave spawning system |

## AI Modules

| Script | Line | Description |
|--------|------|-------------|
| **module_attack.scar** | 43662 | Attack module |
| **module_common.scar** | 44121 | Common module utilities |
| **module_defend.scar** | 44295 | Defend module |
| **module_rovingarmy.scar** | 44865 | Roving army behavior |
| **module_siege.scar** | 46420 | Siege behavior |
| **module_townlife.scar** | 46866 | Town life (villager AI) |
| **module_unitspawner.scar** | 47370 | Unit spawning module |

## AI Plans

| Script | Line | Description |
|--------|------|-------------|
| **plan_attack.scar** | 51189 | Attack plan |
| **plan_defend.scar** | 51705 | Defend plan |
| **plan_donothing.scar** | 52210 | Idle/hold plan |
| **plan_move.scar** | 52268 | Movement plan |
| **plan_townlife.scar** | 52639 | Town life plan |

## AI Encounter System

| Script | Line | Description |
|--------|------|-------------|
| **core_encounter.scar** | 20572 | Core encounter framework |
| **combat_fitness_consts.scar** | 13807 | Combat fitness constants |
| **combat_fitness_util.scar** | 13900 | Combat fitness calculations |
| **prefabs_config.scar** | 53113 | AI prefab configuration |

## Objectives System

| Script | Line | Description |
|--------|------|-------------|
| **objectives.scar** | 48564 | Objective creation, tracking, timer bars |
| **momobjective.scar** | 47568 | MissionOMatic objective wrapper |
| **momobjective_schema.scar** | 47589 | Objective schema definitions |

## Game Modifiers & Economy

| Script | Line | Description |
|--------|------|-------------|
| **game_modifiers.scar** | 27782 | Global game modifier system |
| **gathering_utility.scar** | 28281 | Resource gathering utilities |
| **diplomacy.scar** | 22011 | Diplomacy/tribute system |

## UI Systems

| Script | Line | Description |
|--------|------|-------------|
| **event_cues.scar** | 25192 | Event cue notification system |
| **currentageui.scar** | 21448 | Age display UI |
| **vizierui.scar** | 68818 | Vizier/advisor UI (Ottoman) |
| **xbox_diplomacy_menus.scar** | 70577 | Xbox diplomacy UI |
| **replaystatviewer.scar** | 54883 | Replay statistics viewer |
| **campaignpanel.scar** | 2849 | Campaign panel UI |

## Triggers & Events

| Script | Line | Description |
|--------|------|-------------|
| **canseetrigger.scar** | 5518 | Vision-based trigger |
| **canseetrigger_schema.scar** | 5801 | Vision trigger schema |
| **healthtrigger.scar** | 28638 | Health-based trigger |
| **healthtrigger_schema.scar** | 28854 | Health trigger schema |
| **playertrigger.scar** | 52715 | Player state trigger |
| **playertrigger_schema.scar** | 52954 | Player trigger schema |
| **exclusionarea.scar** | 25795 | Area exclusion zones |
| **exclusionarea_schema.scar** | 25839 | Exclusion area schema |
| **pickups.scar** | 51084 | Item pickup system |
| **pickups_schema.scar** | 51127 | Pickup schema |
| **villagerlife.scar** | 68268 | Villager life simulation |
| **villagerlife_schema.scar** | 68587 | Villager life schema |

## Unit Management

| Script | Line | Description |
|--------|------|-------------|
| **unitentry.scar** | 66944 | Unit entry/spawn sequences |
| **unitexit.scar** | 67648 | Unit exit/despawn sequences |
| **unit_trainer.scar** | 67948 | Unit training system |
| **dynamic_spawning.scar** | 23420 | Dynamic unit spawning |
| **wave_generator.scar** | 68872 | Wave attack generator |
| **markerpaths.scar** | 30524 | Marker-based pathfinding |

## Training System (Per-Civ)

| Script | Line | Description |
|--------|------|-------------|
| **coretrainingconditions.scar** | 17253 | Core training conditions |
| **coretraininggoals.scar** | 19692 | Core training goals |
| **abbasidtrainingconditions.scar** | 1 | Abbasid conditions |
| **abbasidtraininggoals.scar** | 302 | Abbasid goals |
| **chinesetrainingconditions.scar** | 13141 | Chinese conditions |
| **chinesetraininggoals.scar** | 13523 | Chinese goals |
| **englishtrainingconditions.scar** | 24874 | English conditions |
| **englishtraininggoals.scar** | 25094 | English goals |
| **frenchtraininggoals.scar** | 25889 | French goals |
| **mongoltrainingconditions.scar** | 47822 | Mongol conditions |
| **mongoltraininggoals.scar** | 48199 | Mongol goals |
| **sultanatetrainingconditions.scar** | 65421 | Sultanate conditions |
| **sultanatetraininggoals.scar** | 65690 | Sultanate goals |
| **rustrainingconditions.scar** | 63033 | Rus conditions |
| **rustraininggoals.scar** | 63249 | Rus goals |
| **campaigntraininggoals.scar** | 5259 | Campaign-specific goals |

## Rogue-like Mode

| Script | Line | Description |
|--------|------|-------------|
| **rogue.scar** | 55051 | Rogue mode core |
| **rogue_boons.scar** | 55548 | Boon/reward system |
| **rogue_data.scar** | 55713 | Data definitions |
| **rogue_events.scar** | 55961 | Event handling |
| **rogue_factions.scar** | 56245 | Faction system |
| **rogue_favors.scar** | 56443 | Favor mechanics |
| **rogue_lanes.scar** | 56616 | Lane/path system |
| **rogue_misc.scar** | 56801 | Misc utilities |
| **rogue_objectives.scar** | 56954 | Objectives |
| **rogue_outlaws.scar** | 58482 | Outlaw encounters |
| **rogue_poi.scar** | 59255 | Points of interest |
| **rogue_resource_spots.scar** | 60821 | Resource spot management |
| **rogue_roamers.scar** | 61076 | Roaming units |
| **rogue_rounds.scar** | 61364 | Round progression |
| **rogue_sites.scar** | 62044 | Site management |
| **rogue_tech_tree.scar** | 62209 | Tech tree modifications |
| **rogue_wave_templates.scar** | 62604 | Wave templates |

## Miscellaneous

| Script | Line | Description |
|--------|------|-------------|
| **cheat.scar** | 12964 | Cheat system |
| **chatcheats.scar** | 12273 | Chat-based cheats |
| **autotest.scar** | 2776 | Automated testing |
| **shieldwall.scar** | 64633 | Shield wall mechanic |
| **team.scar** | 66076 | Team management |
| **vision.scar** | 68696 | Vision/fog system |
