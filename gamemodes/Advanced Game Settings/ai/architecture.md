# Architecture: Advanced Game Settings

<!-- DOC:ARCHITECTURE:MAIN -->

**Last Updated**: 2026-03-01  
**Authority**: Derived from README.md (lines 1-539)  
**Source**: `gamemodes/Advanced Game Settings/README.md`

---

## System Overview

Advanced Game Settings (AGS) is a comprehensive Age of Empires IV multiplayer gamemode that extends the base game with customizable win conditions, starting scenarios, gameplay modifiers, and diplomacy features. Built on Relic's Cardinal.scar framework, AGS uses a delegate-based architecture for lifecycle management and event orchestration.

**Core Design Principles**:
- **Modular Win Conditions**: Each condition is self-contained in dedicated files
- **Delegate-Based Lifecycle**: 6-phase initialization and execution model
- **Data-Driven Configuration**: Over 100 constants control gameplay behavior
- **Observer Support**: Real-time UI updates for spectators via XAML

---

## Execution Flow

### Delegate Lifecycle Phases

<!-- DOC:ARCHITECTURE:LIFECYCLE -->

AGS follows Cardinal.scar's 6-phase delegate lifecycle:

| Phase | Function | Responsibility | Notes |
|-------|----------|----------------|-------|
| **1. Setup** | Unknown | Module initialization | Earliest hook — Unknown requires source inspection |
| **2. Init** | Unknown | Object creation and state setup | Unknown requires source inspection |
| **3. PostInit** | Unknown | Cross-module wiring | Unknown requires source inspection |
| **4. Preset** | Unknown | Pre-game configuration application | Unknown requires source inspection |
| **5. PreStart** | Unknown | Final prep before game begins | Unknown requires source inspection |
| **6. Start** | Unknown | Game loop activation | Unknown requires source inspection |

**Authority Note**: Delegate function signatures and specific responsibilities require source code inspection. The README confirms these 6 phases exist but does not document implementation details.

---

## Module Boundaries

<!-- DOC:ARCHITECTURE:MODULES -->

### Core Framework (`coreconditions/`)

Verified files (from repository structure):
- `ags_conditions.scar` — Unknown (base condition framework)
- `ags_conditions_match.scar` — Unknown (match-specific logic)
- Unknown (4 additional files in directory)

**Responsibilities** (from README):
- Win condition lifecycle management
- Progress tracking and completion events
- UI synchronization for observers

### Win Conditions (`conditions/`)

Verified files (11 total):
- Unknown specific condition implementations (README mentions: Conquest, Wonder, Sacred Sites, Landmark Race, Regicide, King of the Hill, Treaty, Domination, Diplomacy, No Condition, Custom)

**Responsibilities**:
- Self-contained win condition logic
- Victory state monitoring
- Player elimination handling

### Starting Scenarios (`startconditions/`)

**Responsibilities** (from README):
- Nomad (no starting Town Center)
- Dark Age Rush (Age I start)
- King of the Hill (central landmark control)
- Tiny (ultra-small map variant)
- Unknown (3 additional scenarios mentioned: Empire Wars, Turbo, Regicide Start)

**Authority Note**: Directory verified in repository but specific file names require inspection.

### Helper Modules (`helpers/`)

Verified files:
- `ags_teams.scar` — Team management API
- `ags_starts.scar` — Starting scenario utilities
- `ags_blueprints.scar` — Blueprint lookup functions

**Responsibilities** (from README):
- Team alliance and enemy queries
- Starting resources and tech tree modifications
- Entity/building blueprint resolution

### Gameplay Modifiers (`gameplay/`)

**Responsibilities** (from README):
- Population cap adjustment (25-1,000 range)
- Starting resource multipliers
- Tech tree modifications
- Building/unit exclusions
- Unknown (30+ total modifiers)

**Authority Note**: Directory verified but specific file mappings require source inspection.

### Diplomacy System (`diplomacy/`)

**Responsibilities** (from README):
- Lock teams feature
- Unknown additional diplomacy mechanics

**Authority Note**: Directory verified but implementation details require source inspection.

---

## Data Flow

<!-- DOC:ARCHITECTURE:DATAFLOW -->

```
Game Start
    ↓
Load Settings (ags_global_settings.scar)
    ↓
Initialize Delegates (6 phases)
    ↓
Apply Starting Scenario (startconditions/)
    ↓
Apply Gameplay Modifiers (gameplay/)
    ↓
Activate Win Condition (conditions/)
    ↓
Game Loop (Cardinal.scar)
    ↓
Monitor Victory State (coreconditions/)
    ↓
Update Observer UI (XAML panels)
```

---

## Key Integration Points

<!-- DOC:ARCHITECTURE:INTEGRATION -->

### Cardinal.scar Framework

- **Entry Point**: `ags_cardinal.scar` (285 lines) — Main orchestrator
- **Integration**: Unknown (requires inspection of Cardinal.scar imports)
- **Delegate Registration**: Unknown (requires source inspection)

### Global Settings

- **File**: `ags_global_settings.scar` (1,189 lines)
- **Contents**: 100+ constants (prefixed with `AGS_GS_*`)
- **Usage**: Imported by all modules via `import("ags_global_settings.scar")`

### UI Synchronization

- **Mechanism**: Unknown (requires inspection)
- **Format**: XAML panels for observers
- **Update Frequency**: Unknown (requires source inspection)

---

## Error Handling

Unknown — README does not document error handling patterns. Requires source inspection.

---

## Performance Considerations

Unknown — README does not document performance characteristics. Requires source inspection.

---

## Extension Points

From README documentation:

1. **Custom Win Conditions**: Add new files to `conditions/` directory
2. **Custom Starting Scenarios**: Add new files to `startconditions/` directory
3. **Custom Gameplay Modifiers**: Add new files to `gameplay/` directory
4. **Custom Constants**: Define new `AGS_GS_*` constants in `ags_global_settings.scar`

Specific extension APIs and interfaces: Unknown — requires source inspection.

---

## Authority Disclaimer

This architecture document is derived from README.md and verified directory structure. Function signatures, data structures, and implementation details marked "Unknown" require direct source code inspection for accuracy. See [file_index.md](file_index.md) for verified file paths to inspect.
