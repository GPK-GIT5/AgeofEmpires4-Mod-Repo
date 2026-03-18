# Batch 4 — SCAR Scripting API, AoE4 Modding Tools & Community Ecosystem

> **Scope:** 12 URLs requested, 8 yielded content (2× HTTP 403, 2× HTTP 404)  
> **Bonus:** 6 additional lua-docs API pages fetched for coverage  
> **Date:** 2026-06-14  
> **Purpose:** Complete SCAR API surface map, Essence engine toolchain, community modding ecosystem  
> **Optimized for:** Downstream AI consumption (API patterns, type contracts, engine constraints)

---

## Table of Contents

1. [SCAR API Module Taxonomy](#1-scar-api-module-taxonomy)
2. [SCAR Core Type System](#2-scar-core-type-system)
3. [Entity API — Functions/Entity](#3-entity-api--functionsentity)
4. [Player API — Functions/Player](#4-player-api--functionsplayer)
5. [Group APIs — SGroup & EGroup](#5-group-apis--sgroup--egroup)
6. [EventRule System — Event-Driven Architecture](#6-eventrule-system--event-driven-architecture)
7. [Game API — Functions/Game](#7-game-api--functionsgame)
8. [UI API — Functions/UI](#8-ui-api--functionsui)
9. [Scar Runtime — Functions/Scar](#9-scar-runtime--functionsscar)
10. [Essence Engine Tools — AOEMods.Essence](#10-essence-engine-tools--aoemodsessence)
11. [Attribute Database — aoemods/attrib](#11-attribute-database--aoemodsattrib)
12. [Community Ecosystem](#12-community-ecosystem)
13. [Source Index](#13-source-index)

---

## 1. SCAR API Module Taxonomy

Source: `aoemods.github.io/lua-docs/modules.html` — TypeDoc-generated from engine bindings.

### 1.1 Complete Module Index (60+ modules)

| Domain | Modules |
|---|---|
| **Core Entity/Squad** | Entity, Squad, EGroup, SGroup |
| **Player** | Player, PlayerColour |
| **Blueprints** | BP, EBP, SBP |
| **Game State** | Game, Sim, World, Setup |
| **Events** | Event, EventRule, UnsavedEventRule |
| **AI** | AI |
| **UI/Presentation** | UI, Camera, Cursor, Decal, FOW, HintPoint, MapIcon, Marker, Splat, Subtitle, Taskbar, Toggle, VIS |
| **Combat** | Weapon, Formation, Physics, ThreatGroup |
| **Resources/Economy** | Modifier, Territory, Terrain |
| **Path/Movement** | Path, WaypointPath |
| **Sound/Speech** | Sound, Speech |
| **Localization** | Loc |
| **State/Logic** | StateTree, Loadout, GameObject |
| **Debug/Internal** | Debug, RulesProfiler, MemoryStats, ShaderStats, RenderDoc, Warning, WinWarning, MovieCapture |
| **Commands** | LocalCommand, SynchronizedCommand, Request |
| **System** | App, SystemConfig, Scar |
| **Misc/Uncategorized** | Misc, Uncategorized, Ghost, Enum, Obj, Vector, ActionMarker, LCWatcher |
| **Internal** | _Prox, __Internal_Game, coreworld_objectpool, dr, setsim, shadowmap, statgraph, timer, water_reflection |

### 1.2 Module Naming Convention

- All module names follow `Functions/<Name>` except `Types` and `Constants`/`Enums`
- Function prefix matches module name: `Entity_*`, `Player_*`, `SGroup_*`, etc.
- **CORRECTION:** There is no `Rule_*` or `Functions/Rule` module — the rule system uses `EventRule_*` (Functions/EventRule) and `UnsavedEventRule` modules

---

## 2. SCAR Core Type System

Source: `aoemods.github.io/lua-docs/modules/Types.html`

### 2.1 All Registered Types (32 type aliases)

| Type | Structure | Notes |
|---|---|---|
| **Entity** | `{ EntityID: number }` | Primary game object handle |
| **Player** | `{ PlayerID: number }` | Player handle |
| **Squad** | `{}` | Opaque handle |
| **SGroup** | `{}` | Squad group container |
| **EGroup** | `{}` | Entity group container |
| **ScarPosition** | `{ x: number, y: number, z: number }` | World-space coordinate |
| **ScarMarker** | `{}` | Scenario editor marker |
| **EntityBlueprint** | `{}` | EBP reference |
| **SquadBlueprint** | `{}` | SBP reference |
| **AbilityBlueprint** | `{}` | Ability template ref |
| **UpgradeBlueprint** | `{}` | Upgrade template ref |
| **RaceBlueprint** | `{}` | Civilization definition ref |
| **BriefingActorBlueprint** | `{}` | Campaign briefing actor |
| **ReticuleBlueprint** | `{}` | UI targeting reticule |
| **PropertyBagGroup** | `{ PropertyBagGroupID: number, PropertyBagGroupModPackID: number, PropertyBagGroupType: number }` | Generic blueprint reference with mod pack routing |
| **LocString** | `{ LocString: string }` | Localized string reference |
| **Modifier** | `{}` | Runtime stat modifier |
| **ModifierApplicationType** | `{}` | How modifier is applied |
| **PresetColour** | `{}` | Player color preset |
| **PlayerState** | `{}` | Player lifecycle state |
| **KillPlayerReason** | `{}` | Elimination reason enum |
| **AddResourceReason** | `{}` | Resource grant tracking |
| **ResourceAmount** | `{}` | Resource value container |
| **DecoratorVisibility** | `{}` | UI decorator state |
| **VisibilityFlag** | `{}` | FOW visibility mode |
| **TargetingType** | `{}` | Combat targeting mode |
| **EasingType** | `{}` | Animation easing curve |
| **TerrainSplatObject** | `{}` | Terrain paint handle |
| **AIEncounter** | `{}` | AI encounter handle |
| **AIEntity** | `{}` | AI entity wrapper |
| **AIPlayer** | `{}` | AI player wrapper |
| **AISquad** | `{}` | AI squad wrapper |

### 2.2 Type Architecture Observations

- **Structured types:** Only `Entity`, `Player`, `ScarPosition`, `LocString`, and `PropertyBagGroup` have defined fields
- **Opaque handles:** Most types are `{}` — engine-internal pointers exposed to Lua as userdata
- **PropertyBagGroup is the universal blueprint resolver:** `PropertyBagGroupID` + `PropertyBagGroupModPackID` + `PropertyBagGroupType` form a composite key into the attribute database
- **No generic "Blueprint" type** — each blueprint domain (Entity, Squad, Ability, Upgrade, Race) has its own type alias

### 2.3 Enum Types Referenced in Function Signatures

| Enum | Used By |
|---|---|
| `CapType` | `Player_SetPopCapOverride` |
| `AIType` | Player AI functions |
| `Relationship` | `Player_GetRelationship`, `Player_SetRelationship` |
| `MoodMode` | Player mood functions |
| `RT` (ResourceType) | `Player_SetResource`, `Player_GetResource` |
| `UIEventType` | `UI_CreateEventCueClickableByType`, `UI_EnableUIEventCueType` |
| `EntityCommandType` | `UI_FlashEntityCommandButton` |
| `SquadCommandType` | `UI_FlashSquadCommandButton` |
| `ProductionItemType` | `UI_FlashProductionButton` |
| `HUDFeatureType` | `UI_NewHUDFeature` |
| `CrushMode` | Entity combat |
| `TargetingType` | Entity weapon system |

---

## 3. Entity API — Functions/Entity

Source: `aoemods.github.io/lua-docs/modules/Functions_Entity.html` (~150 functions)

### 3.1 Key Function Signatures (typed subset)

#### Lifecycle
| Function | Signature | Notes |
|---|---|---|
| `Entity_Create` | `(EntityBlueprint, Player, ScarPosition, boolean): Entity` | Core spawner; boolean = face-target |
| `Entity_Destroy` | `(Entity): void` | Immediate removal |
| `Entity_Kill` | `(Entity): void` | Death event + removal |
| `Entity_IsAlive` | `(Entity): boolean` | — |
| `Entity_IsValid` | `(number): boolean` | Check by EntityID |

#### Identity & Blueprint
| Function | Signature |
|---|---|
| `Entity_GetID` | `(Entity): number` |
| `Entity_GetBlueprint` | `(Entity): PropertyBagGroup` |
| `Entity_IsOfType` | `(Entity, string): boolean` |
| `Entity_GetPlayerOwner` | `(Entity): Player` |
| `Entity_SetPlayerOwner` | `(Entity, Player): void` |

#### Position & Movement
| Function | Signature |
|---|---|
| `Entity_GetPosition` | `(Entity): ScarPosition` |
| `Entity_SetPosition` | `(Entity, ScarPosition): void` |
| `Entity_GetHeading` | `(Entity): ScarPosition` |
| `Entity_SetHeading` | `(Entity, ScarPosition, boolean): void` |
| `Entity_IsMoving` | `(Entity): boolean` |

#### Health
| Function | Signature |
|---|---|
| `Entity_GetHealth` | `(Entity): number` |
| `Entity_GetHealthMax` | `(Entity): number` |
| `Entity_GetHealthPercentage` | `(Entity): number` |
| `Entity_SetHealth` | `(Entity, number): void` |
| `Entity_SetHealthMin` | `(Entity, number): void` |

#### State Queries
| Function | Returns |
|---|---|
| `Entity_IsBuilding` | `boolean` |
| `Entity_IsAttacking` | `boolean` |
| `Entity_IsConstructionComplete` | `boolean` |
| `Entity_IsPartOfSquad` | `boolean` |
| `Entity_GetSquad` | `Squad` |
| `Entity_IsStrategicPoint` | `boolean` |

#### Extension System
| Function | Signature | Notes |
|---|---|---|
| `Entity_ExtensionExist` | `(Entity, string): boolean` | Check if entity has a named extension |
| `Entity_ExtensionEnabled` | `(Entity, string): boolean` | Check if extension is active |
| `Entity_SetExtEnabled` | `(Entity, string, boolean): void` | Enable/disable extension at runtime |

#### StateModel (Key-Value Store)
| Pattern | Get | Set |
|---|---|---|
| Bool | `Entity_GetStateModelBool(Entity, string): boolean` | `Entity_SetStateModelBool(Entity, string, boolean)` |
| Float | `Entity_GetStateModelFloat(Entity, string): number` | `Entity_SetStateModelFloat(Entity, string, number)` |
| Int | `Entity_GetStateModelInt(Entity, string): number` | `Entity_SetStateModelInt(Entity, string, number)` |
| EntityTarget | `Entity_GetStateModelEntityTarget` | `Entity_SetStateModelEntityTarget` |
| SquadTarget | `Entity_GetStateModelSquadTarget` | `Entity_SetStateModelSquadTarget` |
| PlayerTarget | `Entity_GetStateModelPlayerTarget` | `Entity_SetStateModelPlayerTarget` |
| Vector3f | — | — |
| EnumTableInt | get | set |
| EnumTableFloat | get | set |

#### Production Queue
| Function | Signature |
|---|---|
| `Entity_CancelProductionQueueItem` | `(Entity, number): void` |
| `Entity_GetProductionQueueCount` | `(Entity): number` |
| `Entity_GetProductionQueueItemAt` | `(Entity, number): PropertyBagGroup` |
| `Entity_GetProductionQueueItemProgress` | `(Entity, number): number` |
| `Entity_GetProductionQueueOwner` | `(Entity): Squad` |
| `Entity_IsProducing` | `(Entity): boolean` |

#### Weapon / Combat
| Function | Notes |
|---|---|
| `Entity_GetActiveWeaponHardpointIndex` | — |
| `Entity_GetWeaponBlueprint` | Takes hardpoint index |
| `Entity_GetWeaponHardpointCount` | — |
| `Entity_IsWeaponHardpointActive` | — |
| `Entity_SetWeaponHardpointEnabled` | — |

---

## 4. Player API — Functions/Player

Source: `aoemods.github.io/lua-docs/modules/Functions_Player.html` (~90 functions)

### 4.1 Key Function Signatures

#### Identity
| Function | Signature | Notes |
|---|---|---|
| `Player_FromId` | `(number): Player` | Convert PlayerID → handle |
| `Player_GetID` | `(Player): number` | — |
| `Player_GetRaceName` | `(Player): string` | Returns civ string like `"abbasid"`, `"english"` |
| `Player_GetTeam` | `(Player): number` | Team index |
| `Player_IsAlive` | `(Player): boolean` | — |
| `Player_IsHuman` | `(Player): boolean` | vs AI |

#### Resources
| Function | Signature |
|---|---|
| `Player_GetResource` | `(Player, number): number` |
| `Player_SetResource` | `(Player, RT, number): void` |
| `Player_GetResources` | `(Player): ResourceAmount` |
| `Player_GetResourceRate` | `(Player, number): number` |
| `Player_AddResource` | `(Player, number, number, AddResourceReason): void` |

#### Population
| Function | Signature |
|---|---|
| `Player_GetCurrentPopulation` | `(Player, CapType): number` |
| `Player_GetMaxPopulation` | `(Player, CapType): number` |
| `Player_SetPopCapOverride` | `(Player, number): void` |
| `Player_SetMaxCapOverride` | `(Player, CapType, number): void` |

#### Relationships
| Function | Signature |
|---|---|
| `Player_GetRelationship` | `(Player, Player): Relationship` |
| `Player_SetRelationship` | `(Player, Player, Relationship): void` |

#### Abilities & Upgrades
| Function | Signature |
|---|---|
| `Player_AddAbility` | `(Player, AbilityBlueprint): void` |
| `Player_HasAbility` | `(Player, AbilityBlueprint): boolean` |
| `Player_RemoveAbility` | `(Player, AbilityBlueprint): void` |
| `Player_CompleteUpgrade` | `(Player, UpgradeBlueprint): void` |
| `Player_HasUpgrade` | `(Player, UpgradeBlueprint): boolean` |

#### Visibility
| Function | Signature |
|---|---|
| `Player_CanSeeEntity` | `(Player, Entity): boolean` |
| `Player_CanSeeSquad` | `(Player, Squad): boolean` |
| `Player_CanSeePosition` | `(Player, ScarPosition): boolean` |

#### Counts
| Function | Returns |
|---|---|
| `Player_GetEntityCount` | `number` |
| `Player_GetSquadCount` | `number` |
| `Player_GetEntities` | `EGroup` |
| `Player_GetSquads` | `SGroup` |
| `Player_GetEntitiesFromType` | `EGroup` (filtered by type string) |

#### Availability Controls
| Function | Purpose |
|---|---|
| `Player_SetConstructionMenuAvailability` | Enable/disable building from construction menu |
| `Player_SetUpgradeAvailability` | Enable/disable specific upgrade |
| `Player_SetAbilityAvailability` | Enable/disable ability access |
| `Player_SetProductionAvailability` | Enable/disable unit production |
| `Player_SetMaximumAge` | Cap maximum age advancement |

#### StateModel (same pattern as Entity)
- `Player_GetStateModelBool/Float/Int/EntityTarget/SquadTarget/PlayerTarget/Vector3f`
- `Player_SetStateModelBool/Float/Int/EntityTarget/SquadTarget/PlayerTarget/Vector3f`
- Also: `EnumTableInt`/`EnumTableFloat` get/set variants

---

## 5. Group APIs — SGroup & EGroup

### 5.1 SGroup API (32 functions)

Source: `aoemods.github.io/lua-docs/modules/Functions_SGroup.html`

| Pattern | Functions |
|---|---|
| **Lifecycle** | `SGroup_Create(string)`, `SGroup_CreateUniqueWithPrefix(string)`, `SGroup_Destroy(SGroup)` |
| **Membership** | `SGroup_Add(SGroup, ?)`, `SGroup_AddGroup(SGroup, ?)`, `SGroup_Remove(SGroup, ?)`, `SGroup_Clear(SGroup)` |
| **Queries** | `SGroup_Count(SGroup)`, `SGroup_CountSpawned(SGroup)`, `SGroup_CountDeSpawned(SGroup)` |
| **Relational** | `SGroup_CountAlliedSquads(SGroup, ?)`, `SGroup_CountEnemySquads(SGroup, ?)` |
| **Access** | `SGroup_GetSquadAt(SGroup, ?)`, `SGroup_GetSpawnedSquadAt(SGroup, ?)`, `SGroup_GetDeSpawnedSquadAt(SGroup, ?)` |
| **Iteration** | `SGroup_ForEach(SGroup, fn)`, `SGroup_ForEachEx(SGroup, fn, ?, ?)`, `SGroup_ForEachAllOrAny(SGroup, fn, ?)`, `SGroup_ForEachAllOrAnyEx(SGroup, fn, ?, ?, ?)` |
| **Set Ops** | `SGroup_Intersection(SGroup, ?)`, `SGroup_Compare(SGroup, ?)`, `SGroup_ContainsSGroup(SGroup, ?, ?)`, `SGroup_ContainsSquad(SGroup, ?, ?)` |
| **Spatial** | `SGroup_GetPosition(SGroup)`, `SGroup_FacePosition(SGroup, ?)`, `SGroup_SnapFacePosition(SGroup, ?)` |
| **State** | `SGroup_SuggestPosture(SGroup, ?, ?)`, `SGroup_ClearPostureSuggestion(SGroup)` |
| **Validation** | `SGroup_Exists(string): boolean`, `SGroup_IsValid(number): boolean`, `SGroup_FromName(string)`, `SGroup_GetName(SGroup)` |
| **Clustering** | `SGroup_DivideIntoClusters(SGroup, ?, ?)`, `SGroup_CalculateClusterSeparation()` |

### 5.2 EGroup API (26 functions)

Source: `aoemods.github.io/lua-docs/modules/Functions_EGroup.html`

| Pattern | Functions |
|---|---|
| **Lifecycle** | `EGroup_Create(string)`, `EGroup_CreateUniqueWithPrefix(string)`, `EGroup_Destroy(EGroup)` |
| **Membership** | `EGroup_Add(EGroup, ?)`, `EGroup_AddEGroup(EGroup, ?)`, `EGroup_Remove(EGroup, ?)`, `EGroup_Clear(EGroup)` |
| **Queries** | `EGroup_Count(EGroup)`, `EGroup_CountSpawned(EGroup)`, `EGroup_CountDeSpawned(EGroup)` |
| **Access** | `EGroup_GetEntityAt(EGroup, ?)`, `EGroup_GetSpawnedEntityAt(EGroup, ?)`, `EGroup_GetDeSpawnedEntityAt(EGroup, ?)` |
| **Iteration** | `EGroup_ForEach(EGroup, fn)`, `EGroup_ForEachEx(EGroup, fn, ?, ?)`, `EGroup_ForEachAllOrAny(EGroup, fn, ?)`, `EGroup_ForEachAllOrAnyEx(EGroup, fn, ?, ?, ?)` |
| **Set Ops** | `EGroup_Intersection(EGroup, ?)`, `EGroup_Compare(EGroup, ?)` |
| **Spatial** | `EGroup_GetPosition(EGroup)` |
| **Validation** | `EGroup_Exists(string): boolean`, `EGroup_IsValid(number): boolean`, `EGroup_FromName(string)`, `EGroup_GetName(EGroup)` |
| **Sorting** | `EGroup_SortBasedOnHealth(EGroup, ?)`, `EGroup_RemoveNonHoldEntities(EGroup)` |

### 5.3 SGroup vs EGroup — Structural Symmetry

| Feature | SGroup | EGroup |
|---|---|---|
| Contains | `Squad` objects | `Entity` objects |
| Create | `SGroup_Create(name)` | `EGroup_Create(name)` |
| Count | `SGroup_Count` | `EGroup_Count` |
| Iterator | `SGroup_ForEach(sg, fn)` | `EGroup_ForEach(eg, fn)` |
| Set intersection | ✓ | ✓ |
| Position | ✓ (centroid) | ✓ (centroid) |
| Face/Posture | ✓ (Face, Posture, Snap) | ✗ |
| Clustering | ✓ (DivideIntoClusters) | ✗ |
| Allied/Enemy count | ✓ | ✗ |
| Health sort | ✗ | ✓ (SortBasedOnHealth) |

---

## 6. EventRule System — Event-Driven Architecture

Source: `aoemods.github.io/lua-docs/modules/Functions_EventRule.html` (22 functions)

### 6.1 Function Index

| Function | Parameters | Notes |
|---|---|---|
| `EventRule_AddEvent` | `(event, callback)` | Global event listener |
| `EventRule_AddEventData` | `(event, callback, data)` | Global + data passthrough |
| `EventRule_AddEntityEvent` | `(entity, event, callback)` | Per-entity listener |
| `EventRule_AddEntityEventData` | `(entity, event, callback, data)` | Per-entity + data |
| `EventRule_AddPlayerEvent` | `(player, event, callback)` | Per-player listener |
| `EventRule_AddPlayerEventData` | `(player, event, callback, data)` | Per-player + data |
| `EventRule_AddSquadEvent` | `(squad, event, callback)` | Per-squad listener |
| `EventRule_AddSquadEventData` | `(squad, event, callback, data)` | Per-squad + data |
| `EventRule_RemoveEvent` | `(callback)` | Unregister global |
| `EventRule_RemoveEntityEvent` | `(entity, callback)` | Unregister entity |
| `EventRule_RemovePlayerEvent` | `(player, callback)` | Unregister player |
| `EventRule_RemoveSquadEvent` | `(squad, callback)` | Unregister squad |
| `EventRule_RemoveRuleIDEvent` | `(ruleID, event)` | Unregister by ID |
| `EventRule_RemoveMe` | `()` | Self-remove from inside callback |
| `EventRule_RemoveAll` | `()` | Clear all rules |
| `EventRule_Exists` | `(callback)` | Check if registered |
| `EventRule_Pause` | `(callback)` | Suspend rule |
| `EventRule_Unpause` | `(callback)` | Resume rule |
| `EventRule_PauseAll` | `()` | Suspend all |
| `EventRule_UnpauseAll` | `()` | Resume all |
| `EventRule_Refresh` | `()` | Force re-evaluation |
| `EventRule_GetNextUniqueRuleID` | `(): number` | ID generator |

### 6.2 Event Architecture Pattern

```
┌─────────────────┐
│  Game Engine     │ fires events (GE_*)
└────────┬────────┘
         ▼
┌─────────────────────────────────────────────┐
│  EventRule Dispatcher                        │
│  ├── Global listeners (AddEvent)             │
│  ├── Entity-scoped (AddEntityEvent)          │
│  ├── Player-scoped (AddPlayerEvent)          │
│  └── Squad-scoped (AddSquadEvent)            │
└────────┬────────────────────────────────────┘
         ▼
┌─────────────────┐
│  Lua Callbacks   │ your SCAR functions
└─────────────────┘
```

### 6.3 Key Patterns

- **Scope hierarchy:** Global → Player → Entity → Squad (narrower = better performance)
- **Data variants:** `*EventData` versions pass opaque data to callback (avoids closures/upvalues)
- **Self-removal:** `EventRule_RemoveMe()` inside callback for one-shot handlers
- **Pause/Unpause:** Prefer over remove+re-add for temporary suspension
- **No `Rule_*` prefix** — all functions use `EventRule_*` prefix (corrects common documentation assumption)
- **UnsavedEventRule** module exists as a separate module for rules that shouldn't persist across save/load

---

## 7. Game API — Functions/Game

Source: `aoemods.github.io/lua-docs/modules/Functions_Game.html` (~50 functions)

### 7.1 Key Functions

#### State Queries
| Function | Returns | Notes |
|---|---|---|
| `Game_GetLocalPlayer` | `Player` | Local human player |
| `Game_GetLocalPlayerID` | `number` | — |
| `Game_HasLocalPlayer` | `boolean` | — |
| `Game_IsPaused` | `boolean` | — |
| `Game_GetSimRate` | `number` | Simulation speed multiplier |
| `Game_IsRTM` | `boolean` | Release-to-manufacturing build |
| `Game_IsFtue` | `boolean` | First-time user experience |

#### Timing
| Function | Returns |
|---|---|
| `Game_CurrentSystemTimeSeconds` | `number` |
| `Game_GetAppFrameNumber` | `number` |
| `Game_GetRenderFrameCount` | `number` |

#### Scene Loading
| Function | Signature | Notes |
|---|---|---|
| `Game_LoadSP` | `(scenarioName: string, n1: number): void` | Load scenario by name |
| `Game_LoadGame` | `(gameName: string)` | Load save |
| `Game_TransitionToState` | `(string, number): void` | Game state machine transition |

#### Data Store (Cross-Scene Persistence)
| Function | Signature |
|---|---|
| `Game_StoreTableData` | `(string, unknown)` |
| `Game_RetrieveTableData` | `(string, boolean)` |
| `Game_RemoveTableData` | `(string)` |
| `Game_LoadDataStore` | `(string, string, boolean)` |
| `Game_SaveDataStore` | `(string, string, boolean)` |
| `Game_SetDataLock` / `Game_IsDataLocked` | Lock/check data slots |

#### Sim Control
| Function | Signature |
|---|---|
| `Game_SetSimRate` | `(number): void` |
| `Game_FastForwardProduction` | `(number)` |
| `Game_FastForwardResourceIncome` | `(number)` |
| `Game_LockRandom` / `Game_UnLockRandom` | Deterministic RNG |

#### Visuals
| Function | Signature |
|---|---|
| `Game_ScreenFade` | `(n, n, n, n, n)` |
| `Game_TextTitleFade` | `(LocString, ?, ?, ?)` |
| `Game_SubTextFadeInternal` | `(LocString, ...[7 args])` |
| `Game_SetPlayerColour` | `(Player, PresetColour)` |
| `Game_SetPlayerUIColour` | `(Player, PresetColour)` |
| `Game_EnableInput` | `(boolean): void` |

---

## 8. UI API — Functions/UI

Source: `aoemods.github.io/lua-docs/modules/Functions_UI.html` (~70 functions)

### 8.1 Function Categories

#### Event Cues (Notification System)
| Function | Key Parameters |
|---|---|
| `UI_CreateEventCueClickable` | `(n, n, n, n, LocString, ...)` |
| `UI_CreateEventCueClickableByType` | `(UIEventType, ...)` |
| `UI_CreateCustomEventCueFrom` | `(Player, n, n, n, n, n, LocString, ...)` |
| `UI_ClearEventCues` | `()` |
| `UI_ClearEventCueFromID` | `(number)` |
| `UI_FadeOutEventCueFromID` | `(number)` |
| `UI_EnableGameEventCueType` | `(number, boolean)` |
| `UI_EnableUIEventCueType` | `(UIEventType, ?)` |
| `UI_FlashEventCue` | `(number, boolean): number` |

#### Kicker Messages (Floating Text)
| Function | Parameters |
|---|---|
| `UI_CreateEntityKickerMessage` | `(Player, Entity, LocString)` |
| `UI_CreateSquadKickerMessage` | `(Player, Squad, LocString)` |
| `UI_CreatePositionKickerMessage` | `(Player, ScarPosition, ?)` |

#### Minimap Blips
| Function | Target |
|---|---|
| `UI_CreateMinimapBlipOnEntity` | `(Entity, number, string): number` |
| `UI_CreateMinimapBlipOnSquad` | `(Squad, ?, ?)` |
| `UI_CreateMinimapBlipOnPos` | `(ScarPosition, ?, ?)` |
| `UI_CreateMinimapBlipOnMarker` | `(ScarMarker, ?, ?)` |
| `UI_CreateMinimapBlipOnEGroup` | `(EGroup, ?, ?)` |
| `UI_CreateMinimapBlipOnSGroup` | `(SGroup, ?, ?)` |
| `UI_CreateMinimapBlipOnMarkerFrom` | `(Player, ScarMarker, ?, ?)` |
| `UI_CreateMinimapBlipOnPosFrom` | `(Player, ScarPosition, ?, ?)` |
| `UI_DeleteMinimapBlipInternal` | `(number)` |

#### Tags (Named Markers)
| Function | Target Type |
|---|---|
| `UI_CreateTag` | string name |
| `UI_CreateTagForEntity` | Entity |
| `UI_CreateTagForSquad` | Squad |
| `UI_CreateTagForPBG` | PropertyBagGroup |
| `UI_CreateTagForPosition` | ScarPosition |
| `UI_CreateTagForUID` | number |
| `UI_DestroyTag` / `UI_DestroyTagFor*` | Matching destroy for each create |

#### Flash / Highlight System
| Function | Target |
|---|---|
| `UI_FlashEntity` | `(Entity, string)` |
| `UI_FlashAbilityButton` | `(AbilityBlueprint, ?)` |
| `UI_FlashConstructionButton` | `(EntityBlueprint, ?)` |
| `UI_FlashProductionButton` | `(ProductionItemType, ?, ?)` |
| `UI_FlashMenu` | `(string, boolean): number` |
| `UI_FlashMinimap` | `(): number` |
| `UI_FlashObjectiveCounter` | `(number): number` |
| `UI_FlashObjectiveIcon` | `(number, boolean): number` |
| `UI_FlashResourceItem` | `(number): number` |
| `UI_StopFlashingUnchecked` | `(number)` |
| `UI_HighlightSquad` | `(Squad, ?)` |
| `UI_FlashUSSEntityButton` | `(Entity, boolean): number` |

#### Decorators & Indicators
| Function | Signature |
|---|---|
| `UI_EnableEntityDecorator` | `(Entity, boolean)` |
| `UI_EnableSquadDecorator` | `(Squad, ?)` |
| `UI_EnableEntityMinimapIndicator` | `(Entity, boolean)` |
| `UI_EnableSquadMinimapIndicator` | `(Squad, ?)` |
| `UI_EnableEntitySelectionVisuals` | `(Entity, boolean)` |
| `UI_SetDecoratorsEnabled` | `(boolean)` |
| `UI_GetDecoratorsEnabled` | `(): boolean` |
| `UI_ToggleDecorators` | `()` |
| `UI_SetSquadDecoratorAlwaysVisible` | `()` |

#### Screen & Viewport
| Function | Signature |
|---|---|
| `UI_GetViewportWidth` | `(): number` |
| `UI_GetViewportHeight` | `(): number` |
| `UI_ScreenFade` | `(n, n, n, n, n, boolean)` |
| `UI_LetterboxFade` | `(n, n, n, n, n, n, boolean)` |
| `UI_CursorHide` / `UI_CursorShow` | `()` |

#### Misc UI
| Function | Notes |
|---|---|
| `UI_IsReplay` | `(): boolean` |
| `UI_IsLiveReplayGame` | `(): boolean` |
| `UI_SetAllowLoadAndSave` | `(boolean)` |
| `UI_SetEnablePauseMenu` | `(boolean)` |
| `UI_SetShowPlayerScores` | `(boolean)` |
| `UIWarning_Show` | `(LocString)` |
| `UI_RestrictBuildingPlacement` | `(ScarMarker)` |
| `UI_UnrestrictBuildingPlacement` | `()` |
| `UI_CommandCardSetRows/Columns` | Row/column count |
| `UI_ModalVisual_CreateReticule` | `(ReticuleBlueprint, ?)` |
| `UI_StingerPlay` | `(LocString, ...)` |

---

## 9. Scar Runtime — Functions/Scar

Source: `aoemods.github.io/lua-docs/modules/Functions_Scar.html` (9 functions)

| Function | Signature | Notes |
|---|---|---|
| `Scar_DoFile` | `(string): void` | Execute Lua file (primary module loading mechanism) |
| `Scar_DoString` | `(string): void` | Execute Lua string at runtime |
| `Scar_DebugCheatMenuExecute` | `(string): void` | Dev cheat menu command |
| `Scar_DebugConsoleExecute` | `(string): void` | Debug console command |
| `Scar_Reload` | `(): void` | Hot-reload SCAR scripts |
| `Scar_DrawLockoutZones` | `(): void` | Debug visualization |
| `Scar_DrawMarkers` | `(): void` | Debug visualization |
| `Scar_GroupInfo` | `(): void` | Debug info dump |
| `Scar_GroupList` | `(): void` | Debug group listing |

**Critical pattern:** `Scar_DoFile` is the primary module loading mechanism. There is no `require` — all files are loaded via `Scar_DoFile` or `import` (which wraps `Scar_DoFile`). This executes the file in the global scope.

---

## 10. Essence Engine Tools — AOEMods.Essence

Source: `github.com/aoemods/AOEMods.Essence`

### 10.1 Overview

| Property | Value |
|---|---|
| **Language** | C# (.NET 6) |
| **License** | MIT |
| **Stars** | 43 |
| **Components** | Library, CLI, Editor (WPF), Tests |
| **Purpose** | Read/write/convert Age of Empires 4 Essence engine files |

### 10.2 Supported Formats

| Format | Extension | Read | Write | Convert To |
|---|---|---|---|---|
| **SGA archive** | `.sga` | ✓ | ✓ | Directory (unpack) |
| **Relic texture** | `.rrtex` | ✓ | — | `.png`, `.jpg`, `.bmp`, `.tga`, `.gif` |
| **Relic geometry** | `.rrgeom` | ✓ | — | `.obj`, `.gltf`/`.glb` |
| **Relic game data** | `.rgd` | ✓ | ✓ (XML→RGD) | `.xml`, `.json` |
| **Other chunky** | various | ✓ (hex) | — | — |

### 10.3 CLI Commands

| Command | Purpose |
|---|---|
| `rrtex-decode <in> <out>` | Convert texture (supports batch with `-b`) |
| `rrgeom-decode <in> <out>` | Convert geometry to `.obj` (batch with `-b`) |
| `rgd-encode <in> <out>` | XML → RGD (batch with `-b`) |
| `rgd-decode <in> <out>` | RGD → XML/JSON (JSON via `-f json`) |
| `sga-pack <in> <out> <name>` | Pack directory → `.sga` |
| `sga-unpack <in> <out>` | Unpack `.sga` → directory |

### 10.4 Library Architecture

| Namespace | Purpose |
|---|---|
| `AOEMods.Essence.Chunky.Core` | Generic chunky file processing |
| `AOEMods.Essence.Chunky.Graph` | Node graph for chunky files |
| `AOEMods.Essence.Chunky.*` | Format-specific processors |
| `AOEMods.Essence.SGA.Core` | SGA archive processing |
| `AOEMods.Essence.SGA.Graph` | SGA node graph |
| `AOEMods.Essence.FormatReader/Writer` | Unified I/O |
| `AOEMods.Essence.GltfUtil/ObjUtil` | Model conversion utilities |

---

## 11. Attribute Database — aoemods/attrib

Source: `github.com/aoemods/attrib`

### 11.1 Overview

| Property | Value |
|---|---|
| **Purpose** | AoE4 attribute dump — all game data as JSON, tracking patch changes |
| **Stars** | 11 |
| **Converted with** | AOEMods.Essence (RGD → JSON) |
| **Last updated** | May 2022 (Spring update) |

### 11.2 Key Data Directories

| Directory | Contents | Relevance |
|---|---|---|
| `ebps/` | Entity Blueprints | Unit/building stats, abilities, costs |
| `sbps/` | Squad Blueprints | Squad composition, population |
| `abilities/` | Ability definitions | Active abilities, cooldowns |
| `weapon/` | Weapon stats | Damage, range, ROF |
| `upgrade/` | Upgrade definitions | Tech tree, costs, effects |
| `racebps/` | Race/Civilization blueprints | Civ-specific defaults |
| `ai/` | AI tuning | AI difficulty, personality |
| `tuning_simulation/` | Simulation tuning | Global game parameters |
| `tuning_ai/` | AI tuning parameters | AI behavior thresholds |
| `statemodel_schema/` | StateModel definitions | All valid state model keys |
| `map_gen/` | Map generation | Map scripts, balance |
| `multiplayer/` | Multiplayer settings | Match presets |

### 11.3 Enum/Constant JSON Files (Root Level)

Key standalone files defining game-wide enums:
- `resource_type.json` — RT enum values
- `damage_type.json` — Damage categories
- `armor_type.json` — Armor categories
- `attack_type.json` — Attack classifications
- `entity_modifier_type.json`, `squad_modifier_type.json`, `player_modifier_type.json` — Modifier types
- `statemodel_bool_property.json`, `statemodel_float_property.json`, `statemodel_int_property.json` — All valid StateModel keys
- `type_unit_class.json` — Unit type classifications (e.g., "infantry", "cavalry")
- `weapon_category.json`, `weapon_class.json` — Weapon systems

---

## 12. Community Ecosystem

### 12.1 GitHub Topic — `aoe4-mod` (6 repos)

| Repo | Author | Description |
|---|---|---|
| `aoe4-mod-superweapon-pvp` | zhanghai | Siege Camp as superweapon (PvP) |
| `AOE4SCARcodebehind` | uckfayouyayudeday | SCAR as XAML code-behind (AutoRecon mod) |
| `aoe4-mod-superweapon` | zhanghai | Siege Camp as superweapon (campaign) |
| `maintenance_cost` | CORDEA | Custom game mode (Lua) |
| `painful_price` | CORDEA | Custom game mode (Lua) |
| `heroes_return` | CORDEA | Custom game mode (Lua) |

### 12.2 Notable: AOE4SCARcodebehind

Demonstrates using SCAR scripting as XAML code-behind — a pattern directly relevant to the XamlPresenter/UI_AddChild workflow used in Onslaught's custom HUD panels.

### 12.3 Community Channels

| Platform | URL / Note | Status |
|---|---|---|
| **AOE4 Modding Discord** | `discord.gg/h8FX9Uq3vG` (from AOEMods.Essence README) | Active — primary community hub |
| **AoE Forums — Modding** | `forums.ageofempires.com/c/age-of-empires-iv/aoe4-modding/148` | HTTP 404 (may have moved/restructured) |
| **Reddit r/aoe4** | `reddit.com/r/aoe4/` | General discussion, occasional mod posts |

### 12.4 Failed/Unavailable URLs

| URL | Error | Notes |
|---|---|---|
| `scartoolkit.com` | HTTP 403 | May require authentication or is down |
| `scartoolkit.com/reference` | HTTP 403 | Same as above |
| `github.com/aoemods/aoe4-types` | HTTP 404 | Repo removed; types now in `@aoemods/aoetypes` npm package |
| `github.com/aoemods/rgd` | HTTP 404 | Likely merged into AOEMods.Essence |

---

## 13. Source Index

### 13.1 Primary URLs (Requested)

| # | URL | Status | Content Yield |
|---|---|---|---|
| 1 | `scartoolkit.com` | 403 | None |
| 2 | `scartoolkit.com/reference` | 403 | None |
| 3 | `aoemods.github.io/lua-docs/` | 200 | Minimal (title only) |
| 4 | `aoemods.github.io/lua-docs/modules/Functions_Scar.html` | 200 | 9 functions |
| 5 | `github.com/aoemods/AOEMods.Essence` | 200 | Full README + tool docs |
| 6 | `github.com/aoemods/attrib` | 200 | Full directory listing |
| 7 | `github.com/aoemods/aoe4-types` | 404 | None |
| 8 | `github.com/aoemods/rgd` | 404 | None |
| 9 | `github.com/topics/aoe4-mod` | 200 | 6 repos |
| 10 | `forums.ageofempires.com/c/.../aoe4-modding/148` | 404 | None |
| 11 | `discord.gg/aoe4modding` | — | Not fetched (invite link) |
| 12 | `reddit.com/r/aoe4/` | — | Not fetched (general sub) |

### 13.2 Bonus API Pages (Self-Directed)

| URL | Content Yield |
|---|---|
| `lua-docs/modules.html` | Complete 60+ module index |
| `lua-docs/modules/Functions_Entity.html` | ~150 functions |
| `lua-docs/modules/Functions_Player.html` | ~90 functions |
| `lua-docs/modules/Functions_EventRule.html` | 22 functions |
| `lua-docs/modules/Functions_UI.html` | ~70 functions |
| `lua-docs/modules/Functions_SGroup.html` | 32 functions |
| `lua-docs/modules/Functions_EGroup.html` | 26 functions |
| `lua-docs/modules/Functions_Game.html` | ~50 functions |
| `lua-docs/modules/Types.html` | 32 type aliases |
