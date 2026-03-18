# Capabilities Map: Advanced Game Settings

<!-- DOC:CAPABILITIES:MAIN -->

**Last Updated**: 2026-03-01  
**Authority**: Derived from README.md feature descriptions + verified directory structure  
**Purpose**: Map user-facing features to implementation files and entry points

---

## Win Conditions

<!-- DOC:CAPABILITIES:WIN_CONDITIONS -->

| Capability | Description | Implementation File | Entry Point | Settings |
|------------|-------------|---------------------|-------------|----------|
| **Conquest** | Eliminate all enemy landmarks to win | Unknown (in conditions/) | Unknown | `AGS_GS_WIN_CONQUEST` |
| **Wonder Victory** | Build and hold a Wonder for specified time | Unknown (in conditions/) | Unknown | `AGS_GS_WIN_WONDER` |
| **Sacred Sites** | Capture and hold Sacred Sites to accumulate points | Unknown (in conditions/) | Unknown | `AGS_GS_WIN_SACRED_SITES` |
| **Landmark Race** | First player to build all available landmarks wins | Unknown (in conditions/) | Unknown | `AGS_GS_WIN_LANDMARK_RACE` |
| **Regicide** | Protect your king; eliminate enemy kings to win | Unknown (in conditions/) | Unknown | `AGS_GS_WIN_REGICIDE` |
| **King of the Hill** | Control a central landmark for longest time | Unknown (in conditions/) | Unknown | `AGS_GS_WIN_KOTH` |
| **Treaty** | Peace period with no combat; then standard rules apply | Unknown (in conditions/) | Unknown | `AGS_GS_WIN_TREATY` |
| **Domination** | Unknown victory criteria | Unknown (in conditions/) | Unknown | Unknown |
| **Diplomacy** | Win condition based on diplomatic alliances | Unknown (in conditions/) | Unknown | Unknown |
| **No Condition** | Sandbox mode with no win criteria | Unknown (in conditions/) | Unknown | Unknown |
| **Custom** | User-defined custom win condition | Unknown (in conditions/) | Unknown | Unknown |

**Source**: README.md lines 110-150  
**Verification**: Directory `assets/scar/conditions/` exists with 11 files. Specific file names, entry points, and setting mappings require source inspection.

---

## Starting Scenarios

<!-- DOC:CAPABILITIES:STARTING_SCENARIOS -->

| Capability | Description | Implementation File | Entry Point | Settings |
|------------|-------------|---------------------|-------------|----------|
| **Nomad** | Players start with villagers but no Town Center | Unknown (in startconditions/) | Unknown | `AGS_GS_START_NOMAD` |
| **Dark Age Rush** | All players start in Age I (Dark Age) | Unknown (in startconditions/) | Unknown | `AGS_GS_START_DARK_AGE` |
| **King of the Hill** | Players start near a central landmark to control | Unknown (in startconditions/) | Unknown | `AGS_GS_START_KOTH` |
| **Tiny** | Ultra-small map variant with compressed starting positions | Unknown (in startconditions/) | Unknown | Unknown |
| **Empire Wars** | Unknown starting scenario | Unknown (in startconditions/) | Unknown | Unknown |
| **Turbo** | Unknown starting scenario (likely faster resource gathering) | Unknown (in startconditions/) | Unknown | Unknown |
| **Regicide Start** | Players start with a king unit | Unknown (in startconditions/) | Unknown | Unknown |

**Source**: README.md lines 170-210  
**Verification**: Directory `assets/scar/startconditions/` exists. Specific file names and entry points require source inspection.

---

## Gameplay Modifiers

<!-- DOC:CAPABILITIES:GAMEPLAY_MODIFIERS -->

### Population Cap

| Capability | Description | Implementation File | Entry Point | Settings |
|------------|-------------|---------------------|-------------|----------|
| **Adjust Population Cap** | Set population cap between 25 and 1,000 | Unknown (in gameplay/) | Unknown | `AGS_GS_POP_CAP_MIN`, `AGS_GS_POP_CAP_MAX` |

**Source**: README.md line 220

### Starting Resources

| Capability | Description | Implementation File | Entry Point | Settings |
|------------|-------------|---------------------|-------------|----------|
| **Resource Multiplier** | Multiply starting resources (food, wood, gold, stone) | Unknown (in gameplay/) | Unknown | `AGS_GS_STARTING_RESOURCES_MULTIPLIER` |

**Source**: README.md line 240

### Tech Tree Modifications

| Capability | Description | Implementation File | Entry Point | Settings |
|------------|-------------|---------------------|-------------|----------|
| **Unit Exclusions** | Disable specific unit types from tech tree | Unknown (in gameplay/) | Unknown | Unknown |
| **Building Exclusions** | Disable specific buildings from tech tree | Unknown (in gameplay/) | Unknown | Unknown |
| **Technology Restrictions** | Lock or unlock specific technologies | Unknown (in gameplay/) | Unknown | `AGS_GS_TECH_TREE_MODIFICATIONS` |

**Source**: README.md lines 250-280

### Additional Modifiers

README documents **30+ total gameplay modifiers** but does not enumerate all of them. Additional modifiers (Unknown — requires source inspection):

- Unknown (20+ additional modifiers in gameplay/ directory)

**Source**: README.md line 220  
**Verification**: Directory `assets/scar/gameplay/` exists. File enumeration and capability mapping require source inspection.

---

## Team Management

<!-- DOC:CAPABILITIES:TEAM_MANAGEMENT -->

| Capability | Description | Implementation File | Entry Point | Settings |
|------------|-------------|---------------------|-------------|----------|
| **Alliance Queries** | Check if players are allies or enemies | `helpers/ags_teams.scar` | Unknown | None (API function) |
| **Enemy Checks** | Identify enemy players for given player | `helpers/ags_teams.scar` | Unknown | None (API function) |
| **Lock Teams** | Prevent mid-game diplomacy changes | Unknown (in diplomacy/) | Unknown | `AGS_GS_LOCK_TEAMS` |

**Source**: README.md lines 250-300  
**Verification**: File `helpers/ags_teams.scar` exists. Function names and signatures require source inspection.

---

## Blueprint Utilities

<!-- DOC:CAPABILITIES:BLUEPRINTS -->

| Capability | Description | Implementation File | Entry Point | Settings |
|------------|-------------|---------------------|-------------|----------|
| **Entity Lookup** | Resolve entity blueprints by name or ID | `helpers/ags_blueprints.scar` | Unknown | None (API function) |
| **Building Lookup** | Resolve building blueprints by name or ID | `helpers/ags_blueprints.scar` | Unknown | None (API function) |

**Source**: README.md line 290  
**Verification**: File `helpers/ags_blueprints.scar` exists. Function names and signatures require source inspection.

---

## Observer Features

<!-- DOC:CAPABILITIES:OBSERVER -->

| Capability | Description | Implementation File | Entry Point | Settings |
|------------|-------------|---------------------|-------------|----------|
| **Real-Time Progress UI** | Observer panels showing win condition progress and player stats | Unknown (XAML + SCAR integration) | Unknown | `AGS_GS_OBSERVER_UI_ENABLED` |

**Source**: README.md line 350  
**Verification**: XAML files mentioned but not documented. UI integration requires source inspection.

---

## Diplomacy System

<!-- DOC:CAPABILITIES:DIPLOMACY -->

| Capability | Description | Implementation File | Entry Point | Settings |
|------------|-------------|---------------------|-------------|----------|
| **Lock Teams** | Prevent alliance changes during match | Unknown (in diplomacy/) | Unknown | `AGS_GS_LOCK_TEAMS` |
| Unknown | Additional diplomacy mechanics | Unknown (in diplomacy/) | Unknown | Unknown |

**Source**: README.md line 300  
**Verification**: Directory `assets/scar/diplomacy/` exists. Specific capabilities require source inspection.

---

## Coverage Summary

| Category | Documented Capabilities | Verified Files | Unverified Details |
|----------|-------------------------|----------------|---------------------|
| Win Conditions | 11 | 11 files in conditions/ | File names, entry points, settings mappings |
| Starting Scenarios | 7 | Directory exists | File names, entry points |
| Gameplay Modifiers | 30+ | Directory exists | 20+ undocumented modifiers |
| Team Management | 3 API functions | 1 file (ags_teams.scar) | Function signatures |
| Blueprint Utilities | 2 API functions | 1 file (ags_blueprints.scar) | Function signatures |
| Observer Features | 1 | Unknown | XAML files, integration logic |
| Diplomacy | 1+ | Directory exists | Specific capabilities |

---

## Authority Note

This capabilities map is derived from README.md feature descriptions and verified directory structure. **Implementation files, entry points, and settings mappings** marked as "Unknown" require direct source code inspection for accuracy.

For production use:
1. Inspect each file in the verified directories
2. Extract function signatures and entry points
3. Map settings constants to specific capabilities
4. Document undocumented modifiers (20+ in gameplay/)

See [file_index.md](file_index.md) for verified file paths to inspect.
