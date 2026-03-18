# File Index: Advanced Game Settings

<!-- DOC:FILE_INDEX:MAIN -->

**Last Updated**: 2026-03-01  
**Authority**: Verified via repository directory listing + README.md  
**Verification Status**: Paths verified ✓ | Function signatures require source inspection

---

## Core Files

<!-- DOC:FILE_INDEX:CORE -->

| File Path | Responsibility | Key Functions | Delegates |
|-----------|----------------|---------------|-----------|
| `assets/scar/ags_cardinal.scar` | Main orchestrator and entry point | Unknown (285 lines total) | Unknown (6 lifecycle delegates) |
| `assets/scar/ags_global_settings.scar` | Global configuration constants (100+ settings) | Unknown (1,189 lines total) | None (data-only) |

**Source**: README.md lines 420-450

---

## Win Conditions Framework

<!-- DOC:FILE_INDEX:CORECONDITIONS -->

**Directory**: `assets/scar/coreconditions/`

| File Path | Responsibility | Key Functions | Delegates |
|-----------|----------------|---------------|-----------|
| `coreconditions/ags_conditions.scar` | Base win condition framework | Unknown | Unknown |
| `coreconditions/ags_conditions_match.scar` | Match-specific condition logic | Unknown | Unknown |
| Unknown (4 additional files) | Unknown | Unknown | Unknown |

**Verification**: Directory exists with 6 files total. Specific responsibilities require source inspection.

---

## Win Conditions Implementations

<!-- DOC:FILE_INDEX:CONDITIONS -->

**Directory**: `assets/scar/conditions/`

| File Path | Win Condition Type | Key Functions | Delegates |
|-----------|-------------------|---------------|-----------|
| Unknown | Conquest | Unknown | Unknown |
| Unknown | Wonder Victory | Unknown | Unknown |
| Unknown | Sacred Sites | Unknown | Unknown |
| Unknown | Landmark Race | Unknown | Unknown |
| Unknown | Regicide | Unknown | Unknown |
| Unknown | King of the Hill | Unknown | Unknown |
| Unknown | Treaty | Unknown | Unknown |
| Unknown | Domination | Unknown | Unknown |
| Unknown | Diplomacy-based win | Unknown | Unknown |
| Unknown | No Condition (sandbox) | Unknown | Unknown |
| Unknown | Custom Condition | Unknown | Unknown |

**Verification**: Directory exists with 11 files total + `conditiondata/` subdirectory. README confirms these 11 condition types exist (lines 110-150). Specific file names and implementations require source inspection.

---

## Starting Scenarios

<!-- DOC:FILE_INDEX:STARTCONDITIONS -->

**Directory**: `assets/scar/startconditions/`

| File Path | Scenario Type | Key Functions | Delegates |
|-----------|---------------|---------------|-----------|
| Unknown | Nomad (no starting TC) | Unknown | Unknown |
| Unknown | Dark Age Rush (Age I start) | Unknown | Unknown |
| Unknown | King of the Hill (central landmark) | Unknown | Unknown |
| Unknown | Tiny (ultra-small map) | Unknown | Unknown |
| Unknown | Empire Wars | Unknown | Unknown |
| Unknown | Turbo | Unknown | Unknown |
| Unknown | Regicide Start | Unknown | Unknown |

**Verification**: Directory exists in repository structure. README confirms these 7 scenario types (lines 170-210). Specific file names require source inspection.

---

## Helper Modules

<!-- DOC:FILE_INDEX:HELPERS -->

**Directory**: `assets/scar/helpers/`

| File Path | Responsibility | Key Functions | Delegates |
|-----------|----------------|---------------|-----------|
| `helpers/ags_teams.scar` | Team management API | Unknown (README mentions: alliance queries, enemy checks) | None (utility module) |
| `helpers/ags_starts.scar` | Starting scenario utilities | Unknown (README mentions: resource modification, tech tree changes) | Unknown |
| `helpers/ags_blueprints.scar` | Blueprint lookup functions | Unknown (README mentions: entity/building blueprint resolution) | None (utility module) |

**Verification**: Directory exists with exactly 3 files. Responsibilities from README lines 250-300. Function signatures require source inspection.

---

## Gameplay Modifiers

<!-- DOC:FILE_INDEX:GAMEPLAY -->

**Directory**: `assets/scar/gameplay/`

| File Path | Modifier Category | Key Functions | Delegates |
|-----------|-------------------|---------------|-----------|
| Unknown (30+ files) | Population cap, starting resources, tech tree, unit/building restrictions, etc. | Unknown | Unknown |

**Verification**: Directory exists in repository structure. README mentions 30+ modifiers (lines 220-280) but does not map them to specific files. Requires source inspection.

---

## Diplomacy System

<!-- DOC:FILE_INDEX:DIPLOMACY -->

**Directory**: `assets/scar/diplomacy/`

| File Path | Responsibility | Key Functions | Delegates |
|-----------|----------------|---------------|-----------|
| Unknown | Lock teams feature | Unknown | Unknown |
| Unknown | Additional diplomacy mechanics | Unknown | Unknown |

**Verification**: Directory exists in repository structure. README mentions "Lock Teams" feature (line 300). Requires source inspection.

---

## AI Integration

<!-- DOC:FILE_INDEX:AI -->

**Directory**: `assets/scar/ai/`

**Status**: Directory exists in repository structure. README does not document AI integration details. Requires source inspection.

---

## Replay Support

<!-- DOC:FILE_INDEX:REPLAY -->

**Directory**: `assets/scar/replay/`

**Status**: Directory exists in repository structure. README does not document replay features. Requires source inspection.

---

## Additional Directories

<!-- DOC:FILE_INDEX:ADDITIONAL -->

The following directories exist in the repository structure but are not documented in the README:

- `assets/scar/gamemodes/`
- `assets/scar/specials/`
- `assets/scar/balance/`
- `assets/scar/winconditions/`

**Status**: Requires source inspection to determine responsibility and usage.

---

## File Count Summary

| Category | Verified Count | Source |
|----------|----------------|--------|
| Core files | 2 | Repository + README |
| Win condition framework | 6+ | Repository listing (coreconditions/) |
| Win condition implementations | 11+ | Repository listing (conditions/) + README |
| Starting scenarios | 7+ | README documentation |
| Helper modules | 3 | Repository listing (helpers/) |
| Gameplay modifiers | 30+ | README documentation |
| Total SCAR files | 97+ | README line 5 |
| Total lines of code | ~15,000 | README line 5 |

---

## Authority Note

**Verified Data**:
- Directory structure and file counts via repository inspection
- Module categories and high-level responsibilities from README documentation

**Unverified Data (requires source inspection)**:
- Specific file names in conditions/, startconditions/, gameplay/, diplomacy/ directories
- Function signatures and implementations
- Delegate registration and lifecycle hooks
- Data structures and APIs

Use this file index to locate files for direct inspection. Do not assume implementation details without source verification.
