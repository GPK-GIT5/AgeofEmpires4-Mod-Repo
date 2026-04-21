---
name: "scar-debug"
description: "Diagnose and fix SCAR/Lua runtime errors in AoE4 mods, generate/maintain the Onslaught split debugger, and surface test/validation commands. Use when: user reports nil errors, entity crashes, EventRule misfires, blueprint resolution failures, production/building limit desyncs, requests debug file generation/updates, asks for test commands, asks for validation commands, completes debug file work, or needs post-work verification."
metadata:
  version: "2.1.0"
  author: "Copilot Skill: scar-debug"
  keywords: ["scar", "lua", "debug", "aoe4", "runtime-errors", "entity", "blueprint", "onslaught", "debugger", "test", "validation", "commands"]
---

# Skill: SCAR Debug

**Purpose:** Systematically diagnose and resolve SCAR/Lua runtime errors in AoE4 mod scripts, maintain the Onslaught split debugger architecture, and proactively surface test/validation commands.

**Input:** Error description, affected `.scar` file(s), reproduction steps (if available), debug generation request, or testing/validation request
**Output:** Root cause diagnosis + targeted code fix, regenerated debug files, or recommended test commands

---

## Split Debugger Architecture

> **Canonical spec:** `.github/instructions/core/debugger-architecture.instructions.md`
>
> The full module table (28 files), branch naming, state tables, and known audit findings are defined there. Do not duplicate topology here.

---

## Debug Workflow

### Phase 1: Triage

1. Identify error category:
   - **Nil reference** — variable/function undefined or out of scope
   - **Entity crash** — invalid Entity/EGroup handle (despawned, transferred, nil)
   - **Blueprint failure** — `BP_GetEntityBlueprint` returns nil (wrong attribName, DLC variant)
   - **EventRule misfire** — callback not triggering, wrong scope, stale reference
   - **State desync** — counters/limits out of sync after ownership transfer or disconnect
   - **UI crash** — XamlPresenter fatal patterns (Width/Height/Opacity binding)
2. Read the reported error context (file + surrounding lines)
3. Check if error is in lifecycle init vs runtime callback

### Phase 2: Diagnosis

1. **Scope check:** SCAR has no `local` file scope; all non-local are globals
2. **Nil trace:** Trace variable back to assignment; check `World_GetPlayerAt()` indexing, empty groups, BP lookup
3. **Entity validity:** Check `Entity_IsValid()`/`Entity_IsAlive()` guards; ownership transfers don't auto-update counters
4. **EventRule audit:** Verify scope, context fields (see `references/api/game-events.md`), premature `Rule_RemoveMe()`
5. **Blueprint resolution:** `AGS_ENTITY_TABLE[player_civ][bp_type]` — each civ has its own full entry
6. **Civ variant patterns:** Direct `player_civ ==` comparison; each DLC variant has own AGS_ENTITY_TABLE entry

### Phase 3: Fix

1. Apply minimal targeted fix to root cause
2. Add entity validity guard only if handle can legitimately be invalid
3. Verify fix doesn't break DLC variant coverage
4. If fix involves counters/limits, ensure recount functions are called after state changes

### Phase 4: Surface Test Commands

Follow `.github/instructions/core/testing-response.instructions.md` for format, placement, and constraints.

**Trigger — runs automatically after ANY of these:**
- Phase 3 fix is complete
- User asks for test/validation/debug commands
- Debug file work is complete
- New debug `.scar` files were created
- Any `.scar` code was edited, reviewed, or verified

### Phase 5: Log Gaps

When a Testing section uses a `<!-- GAP: ... -->` marker (no existing `Debug_*` covers the change), append an entry to `references/audits/debugger-gap-log.md`:

> Row format: `| YYYY-MM-DD | area | gap description | workaround used | status |`

Status values: `open` (no Debug_* exists), `resolved` (helper added).

### Reference Sync Gate

When a debug `.scar` file is added, removed, or renamed:
1. Update the import list in `cba_debug.scar`.
2. Update the module table in `.github/instructions/core/debugger-architecture.instructions.md`.
3. If new public console-facing diagnostics are added (`Debug_*` or `debug.*` namespace functions), add them to the Command Catalog and Tag Registry above.
4. Ensure each domain file has an `if debug then ... end` registration block with `debug._register()` calls.
5. Run `scripts/structure_lint.ps1` to verify module count matches.

Do not merge debug file changes without completing all 4 steps.

**Action:** Select commands from the Command Catalog below, matched to the area changed. Present each as a row in the markdown table format defined in `console-commands.instructions.md` § Presentation Format (columns: Step | Command | Description | Expected results). Never use fenced code blocks for console commands.

---

## How to Use the Debug System

The debug system has two paths: **structured** (tag-based, safe-by-default) and **expert** (direct global calls, no guardrails).

### Structured Path — `debug.run(tag)`

Primary entry point. Dispatches by tag name, with pcall crash protection and structured output.

> **Documentation reference only.** When surfacing these in a response, use the table format per `console-commands.instructions.md` § Presentation Format.

| Call | Effect |
|------|--------|
| debug.run("smoke") | Quick 7-test smoke check |
| debug.run("siege") | Full siege pipeline: quick + field + pending + workshop |
| debug.run("playerui") | Full PlayerUI diagnostic: init + data + UI + ranking + animation |
| debug.run("data") | Blueprint audit + civ overview + data extraction |
| debug.run("players", 2) | Full player system validation (safety-gated, defaults to player 2) |
| debug.run("all") | Run all master suites end-to-end (case-insensitive) |

### Discovery

| Call | Effect |
|------|--------|
| debug.list() | Show all registered tags with tier and description |
| debug.list("siege") | Filter by substring |
| debug.status() | Show populated sub-tables and function counts |

### Subsystem Runners

Four subsystems have `.run()` orchestrators that chain their sub-suites in correct order:

| Runner | Chains | Pattern |
|--------|--------|---------|
| `debug.playerUI.run()` | Init/Data/UI/Ranking → Animation | Async sub-orchestrator |
| `debug.siege.run()` | Quick → Field → Pending → Workshop | Async sub-orchestrator |
| `debug.data.run()` | Blueprint Audit → Civ Overview → Data Summary | Sync sequential |
| `debug.players.run(idx)` | Full system validation (safety-gated) | Delegated async |

### Safety Layer

Destructive commands on the structured path require explicit opt-in for human-player targets:

| Call | Effect |
|------|--------|
| debug._safety.include_human() | Unlock human player as target (session only) |
| debug._safety.exclude_human_reset() | Re-enable protection |
| debug._safety.validate_target(idx) | Check if target is safe (used internally) |

### Expert Path — Direct Global Calls

All `Debug_*` globals remain available for power users. These bypass safety gates and tag dispatch:

| Call | Effect |
|------|--------|
| Debug_RunAll() | Master 9-suite orchestrator |
| Debug_PlayerUI() | PlayerUI diagnostics directly |
| Debug_SiegeLimits() | Siege quick test directly |
| Debug_LeaverConversion_Full() | Leaver pipeline directly |

### Limitations

- **Single sub-orchestrator:** Only one `debug.*.run()` can be active at a time. Starting a second overwrites the first.
- **Async callback crashes:** If a suite's deferred callback crashes (inside `Rule_AddOneShot`), the sub-orchestrator stalls. Setup-phase crashes are caught and auto-recover.

---

## Tag Registry

22 tags. Tiers: T1 = quick/read-only, T2 = multi-phase, T3 = deep/interactive.

| Tag | Tier | Handler | Description |
|-----|------|---------|-------------|
| `smoke` | T1 | `Debug_RunSmokeTests` | 7-test smoke (players, keeps, limits) |
| `helpers` | T1 | `Debug_RunSmokeTests` | Alias → smoke |
| `inspect` | T1 | `Debug_GetBuildingLimitState` | Read-only state inspectors |
| `limits` | T1 | `Debug_GetLimitsUIState` | Building/siege limit UI diagnostics |
| `anchors` | T1 | `Debug_ValidateSpawnAnchors` | Spawn anchor validation (read-only) |
| `validation` | T2 | `Debug_FullValidation` | 6-phase boot/config/runtime/data/endstate/limits |
| `stress` | T2 | `Debug_StressTest` | 8-stage stress test |
| `coverage` | T2 | `Debug_CoverageTest` | 10-batch API coverage |
| `events` | T2 | `Debug_EventProbes` | Mock-context handler resilience |
| `leaver` | T2 | `Debug_LeaverConversion_Full` | Leaver 6-stage conversion pipeline |
| `players` | T2 | `debug.players.run` | Full player system validation (safety-gated) |
| `playerui` | T2 | `debug.playerUI.run` | PlayerUI full diagnostic + animation |
| `siege` | T2 | `debug.siege.run` | Siege full pipeline (~60s) |
| `data` | T2 | `debug.data.run` | Blueprint audit + civ overview + data extraction |
| `ai` | T3 | `Debug_AIBehavior` | 8-scenario AI knowledge tests |
| `qa` | T3 | `Debug_QADiagnostic` | 8-topic visual Q&A verification |
| `advanced` | T3 | `Debug_AdvancedStressAll` | Edge-case stress scenarios |
| `comprehensive` | T3 | `Debug_ComprehensiveStress` | 12-category comprehensive stress |
| `scenario` | T3 | `Debug_Scenario` | 7-stage full orchestration |
| `prompts` | T3 | `Debug_InteractiveChecks` | Interactive XamlPresenter prompts |
| `prompt` | T3 | `Debug_InteractiveChecks` | Alias → prompts |
| `destructive` | T3 | *(info only)* | Lists destructive commands (direct-call only) |

---

## Command Catalog

> Tiers: T1 = every edit, T2 = multi-file, T3 = deep pass. See `testing-response.instructions.md` § Validation Tiers.
>
> **Output format lock:** The tables in this section are reference only. In user-facing responses, every runnable command must be emitted as a table row per `console-commands.instructions.md` § Presentation Format (no fenced blocks, no runnable inline/bullet commands).

### Master Suite (T3)
| Command | Description |
|---------|-------------|
| `debug.run("all")` | Run all master suites end-to-end (preferred entry) |
| `Debug_RunAll()` | Same, via direct global call |
| `Debug_RunAll(true)` | Same, with step mode (pauses between every phase) |

### Quick Diagnostics (T1)
| Command | Description |
|---------|-------------|
| `debug.run("smoke")` | 7-test smoke check via tag dispatch (preferred) |
| `debug.run("inspect")` | Read-only state inspectors via tag dispatch |
| `debug.run("limits")` | Building/siege limit UI diagnostics via tag dispatch |
| `debug.run("anchors")` | Spawn anchor validation via tag dispatch |
| `Debug_RunSmokeTests()` | 7-test smoke check (PLAYERS, _mod, keeps, center, win conds, limits) |
| `Debug_SetBaseline(500)` | Set all resource types to N for all players |
| `Debug_GetPopCap(1)` | Show pop/cap/max for player |
| `Debug_GetKillScore(1)` | Show kills and next reward requirement |
| `Debug_KeepDiagnostic()` | Alive/HP for all keeps |
| `Debug_PrecacheStatus()` | AGS_ENTITY_TABLE castle BP resolution |
| `Debug_Spawn("unit_name", 1, 3)` | Spawn N units at player's keep |

### Read-Only Inspectors (T2)
| Command | Description |
|---------|-------------|
| `Debug_GetBuildingLimitState()` | Per-player building counts vs limits |
| `Debug_GetSiegeLimitState()` | Per-player siege counts vs limits |
| `Debug_GetKeepOwnershipMap()` | Keep alive/owner for all players |
| `Debug_GetVillagerState()` | Villager count per player |
| `Debug_GetOptionParseResults()` | Parsed settings from AGS_GLOBAL_SETTINGS |
| `Debug_GetPostDefeatState()` | Per-player eliminated/entity count |
| `Debug_GetReligiousState()` | Sacred site progress (myreligious.scar) |
| `Debug_GetWonderState()` | Wonder timer state (wonder.scar) |
| `Debug_GetAutoAgeState()` | Auto-age module state (cba_auto_age.scar) |
| `Debug_RamSiegeTowerLimitState()` | Ram/siege tower detailed counter state |
| `Debug_GetStarterKeepState()` | English starter keep tracking state |
| `Debug_GetLeaverBalanceState()` | Team balance after disconnects |

### Validation & Test Suites (T2–T3)
| Command | Description |
|---------|-------------|
| `debug.run("validation")` | 6-phase validation via tag dispatch (~10s) |
| `debug.run("stress")` | 8-stage stress test via tag dispatch (~25s) |
| `debug.run("coverage")` | 10-batch API coverage via tag dispatch (~40s) |
| `debug.run("events")` | Mock-context handler resilience via tag dispatch |
| `debug.run("siege")` | Siege full pipeline: quick + field + pending + workshop (~60s) |
| `debug.run("playerui")` | PlayerUI full diagnostic + animation |
| `debug.run("data")` | Blueprint audit + civ overview + data extraction |
| `debug.run("players")` | Player full system validation (safety-gated, default player 2) |
| `Debug_FullValidation()` | 6-phase validation (~12s) |
| `Debug_LimitEnforcementValidator()` | Phase 5 (Limits) only |
| `Debug_StressTest()` | 8-stage stress test (~25s) |
| `Debug_SiegeLimitStressTest()` | Dedicated siege/ram/tower stress test |
| `Debug_StressStage(n)` | Individual stress stage 1-8 |
| `Debug_CoverageTest()` | 10-batch API coverage (~40s) |
| `Debug_CoverageBatch(n)` | Individual coverage batch 1-10 |
| `Debug_EventProbes()` | Mock-context handler resilience |
| `Debug_Scenario()` | Full 7-stage orchestrated run |
| `Debug_ScenarioStatus()` | Check scenario progress |
| `Debug_ScenarioStop()` | Abort running scenario |

### Destructive (T3, safety-gated)

> On the structured path, destructive commands require `debug._safety.include_human()` to target the human player.
> `debug.run("destructive")` prints the command reference without executing anything.

| Command | Description |
|---------|-------------|
| `debug.players.forceKeepDestroy(idx)` | Kill player's keep (safety-gated) |
| `debug.players.forceEliminate(idx)` | Trigger elimination path (safety-gated) |
| `debug.players.forceSurrender(idx)` | Trigger surrender path (safety-gated) |
| `debug.players.forceTransfer(src, dst)` | Transfer all buildings src→dst (safety-gated) |
| `debug.players.validateAnchors()` | Check spawn positions (read-only) |
| `Debug_ForceKeepDestroy(1)` | Kill player's keep (expert, no safety gate) |
| `Debug_ForceEliminatePlayer(2)` | Trigger elimination path (expert) |
| `Debug_ForceSurrender(1)` | Trigger surrender path (expert) |
| `Debug_ForceTransferTest(1, 2)` | Transfer all buildings src→dst (expert) |
| `Debug_ValidateSpawnAnchors()` | Check spawn positions |

### Limits UI (T2)
| Command | Description |
|---------|-------------|
| `Debug_GetLimitsUIState()` | Building/siege limit summary |
| `Debug_ConstructionTrace(1)` | Entity type breakdown for player |
| `Debug_LimitsUIStress()` | Counter consistency check (desync detection) |

### Leaver (T2)
| Command | Description |
|---------|-------------|
| `debug.run("leaver")` | Leaver 6-stage conversion pipeline via tag dispatch |
| `debug.run("players")` | Full player system validation via tag dispatch (safety-gated) |
| `debug.players.forceDisconnect(idx)` | Simulate player disconnect (safety-gated) |
| `debug.players.forceAnnihilation(idx)` | Kill all player entities/squads (safety-gated) |
| `Debug_ForceDisconnect(1)` | Simulate player disconnect (expert) |
| `Debug_ForceAnnihilation(1)` | Kill all player entities/squads (expert) |

### Precache Manifest (T2)
| Command | Description |
|---------|-------------|
| `debug.leaver.precache.summary()` | Precache manifest summary: routes, targets, gaps, age-1 exclusions |
| `debug.leaver.precache.gaps()` | List unresolved precache gaps grouped by source BP |
| `debug.leaver.precache.confirmed()` | List all confirmed-safe target BPs (sorted) |
| `debug.leaver.precache.report()` | Full precache coverage report: routes + runtime guard + timing + weapon-audit summary |
| `debug.leaver.precache.forced()` | Batch-test all forced-precache BPs + DLC/variant MaA/Knight resolution vs all 22 civs |
| `debug.leaver.precache.weaponaudit()` | Weapon-hardpoint audit: spawn each forced-precache BP, inspect Entity weapon sub-resources |
| `debug.leaver.precache.transfer("abbasid", "english")` | Transfer inspector: resolve route + spawn target + inspect weapon hardpoints (defaults to Abbasid receiver) |
| `Debug_LeaverResolve_ForcedBP()` | Same as forced, via direct global call |
| `Debug_LeaverWeaponAudit()` | Same as weaponaudit, via direct global call |
| `Debug_LeaverTransferInspector("abbasid", "english")` | Same as transfer, via direct global call |

### Logging (T1)
| Command | Description |
|---------|-------------|
| `DebugLog("area", "msg")` | Filtered structured log |
| `DebugLog_SetFilter("stress", "coverage")` | Show only matching areas |
| `DebugLog_SetFilter()` | Clear filter (show all) |

### PlayerUI Diagnostics (T2)
| Command | Description |
|---------|-------------|
| `PlayerUI_Animate_Debug_ResetEliminationDiag()` | Reset elimination animation counters |
| `PlayerUI_Animate_Debug_PrintEliminationDiag()` | Print elimination animation counters and last observed frame metrics |
| `PlayerUI_Debug_PrintEliminationSnapshot(1)` | Print focused elimination state for one index (opacity/progress/fence/seed/reason) |
| `PlayerUI_Debug_PrintFullSnapshot(1)` | Print full PlayerUI state for one index (elimination + ranking + animation keys + pulse/decay) |
| `PlayerUI_Animate_Debug_RetriggerElimFade(1)` | Force a fresh fade run for an already-eliminated index (visual tuning helper) |
| `PlayerUI_Debug_ToggleProbe("all")` | Probe raw toggle path directly from PlayerUI module (`hud`, `scores`, `objectives`, `all`) |

### PlayerUI Animation Suite (T2)
| Command | Description |
|---------|-------------|
| `Debug_PlayerUI_Anim()` | Run 7-phase PlayerUI animation diagnostics (engine/state/bindings/FLIP/pulse/crash/monitor) |
| `Debug_PlayerUI_Anim_FeatureStatus()` | Print current PlayerUI feature flag values |
| `Debug_PlayerUI_Anim_Features(true, false, true, true)` | Toggle move/scale/pulse/dim runtime features for isolation |
| `Debug_PlayerUI_Anim_PresetSafe()` | Apply safe preset (move/scale/pulse/dim OFF) |
| `Debug_PlayerUI_Anim_PresetAll()` | Apply full preset (move/scale/pulse/dim ON) |
| `Debug_PlayerUI_Anim_TogglePaths(true, false, false)` | Isolate HUD/scores/objective toggle paths |
| `Debug_PlayerUI_Anim_TogglePresetHudOnly()` | Quick toggle preset: HUD only |
| `Debug_PlayerUI_Anim_TogglePresetFull()` | Quick toggle preset: HUD + scores + objectives |
| `Debug_PlayerUI_Anim_ApplyWhenVisible(true)` | Enable/disable live DataContext apply while HUD visible |
| `Debug_PlayerUI_Anim_ToggleProbe("hud")` | Run toggle probe through animation debug wrapper |
| `Debug_PlayerUI_Anim_SetMinimalHud(true)` | Select minimal-safe HUD template for next game load |
| `Debug_PlayerUI_Anim_RestoreStage1()` | Restore stage 1 baseline |
| `Debug_PlayerUI_Anim_RestoreStage2()` | Restore stage 2 (PlayerScores path) |
| `Debug_PlayerUI_Anim_RestoreStage3()` | Restore stage 3 (objective path) |
| `Debug_PlayerUI_Anim_RestoreStage4()` | Restore stage 4 (live apply while visible) |
| `Debug_PlayerUI_Anim_RestoreStage5()` | Restore stage 5 (visual feature flags) |
| `Debug_PlayerUI_Anim_RestoreStage6()` | Restore stage 6 (pulse emphasis path) |
| `Debug_PlayerUI_Anim_RunStaged(2.0)` | Single-command staged restore + probes + full diagnostics |
| `Debug_PlayerUI_Elim_ValidateFull()` | One-command lifecycle validator: auto-runs eliminate, surrender, and disconnect with pass/fail summary |
| `Debug_PlayerUI_Elim_ValidateFull(true)` | Verbose lifecycle validator mode (extra per-stage snapshots and elimination animation trace output) |
| `Debug_PlayerUI_Anim_Monitor()` | Start continuous PlayerUI animation invariant monitor |
| `Debug_PlayerUI_Anim_MonitorStop()` | Stop monitor and print violations/ticks summary |
| `Debug_PlayerUI_Anim_Stress(10)` | Run rapid rank-swap stress rounds |
| `Debug_PlayerUI_Anim_Pulse(1)` | Inject score pulse for one player index |
| `Debug_PlayerUI_Anim_ValidateDataContext()` | Validate DataContext fields/types used by animation bindings |
| `Debug_PlayerUI_Anim_Snapshot()` | Print one-shot global animation snapshot |

### PlayerUI Ranking (T2)
| Command | Description |
|---------|-------------|
| `PlayerUI_Ranking_DebugPrintState()` | Print rank-state tables and lock state for both teams |
| `PlayerUI_Ranking_DebugForceSwap("teamLeft", 1, 2)` | Force a rank swap to exercise FLIP transition |
| `PlayerUI_Ranking_DebugSetScore("teamLeft", 2, 500)` | Force score for one rank entry (stability test helper) |

### Step Mode & Hooks (T3)
| Command | Description |
|---------|-------------|
| `Debug_StepMode(true)` | Enable step mode — suites pause between phases |
| `Debug_StepMode(false)` | Disable step mode — suites auto-advance (default) |
| `Debug_Continue()` | Resume from a step-mode pause |
| `Debug_Skip()` | Skip the paused phase and advance to next |
| `Debug_StepStatus()` | Show current step-mode state (waiting? which phase?) |
| `Debug_RegisterHook("name", fn)` | Register a named hook callable from console |
| `Debug_FireHook("name")` | Execute a registered hook by name |
| `Debug_ListHooks()` | List all registered hooks |
| `Debug_ClearHooks()` | Remove all registered hooks |

### Spawn Plans (T3)
| Command | Description |
|---------|-------------|
| `Debug_RunSpawnPlan(plan)` | Execute a table-driven spawn plan with delays and validation |
| `Debug_SpawnAndValidate("bp", 1, 5, nil)` | Single spawn + immediate validation |
| `Debug_SpawnPlan_SiegeStress()` | Pre-built plan: siege units at threshold boundaries |
| `Debug_SpawnPlan_MixedArmy(1)` | Pre-built plan: mixed infantry/ranged/cav for player |

### Visual Validation (T3)
| Command | Description |
|---------|-------------|
| `Debug_WaitForVisual("desc", 30)` | Pause for visual inspection with timeout |
| `Debug_Confirm()` | Confirm visual check passed |
| `Debug_Reject("reason")` | Reject visual check with reason |
| `Debug_FocusPlayer(1)` | Camera jump to player's keep + FOW reveal |
| `Debug_FocusPosition(x, y, z)` | Camera jump to world position + FOW reveal |
| `Debug_SlowMotion(true)` | Set sim rate to 0.25x (use sparingly) |
| `Debug_SlowMotion(false)` | Restore sim rate to 1.0x |
| `Debug_PauseAI()` | Freeze AI for all players |
| `Debug_ResumeAI()` | Unfreeze AI for all players |
| `Debug_ToggleOverlays()` | Toggle entity/squad debug overlays |
| `Debug_VisualValidation_KeepDestroy(1)` | Full sequence: focus, destroy keep, camera cue, cleanup |
| `Debug_VisualValidation_SiegeSpawn(1)` | Full sequence: focus, spawn siege plan, camera cue |

### Advanced Stress Scenarios (T3)
| Command | Description |
|---------|-------------|
| `Debug_AdvancedStressAll()` | Run all 6 scenarios in chained sequence |
| `Debug_AdvStress_SiegeCascade()` | Siege units at every threshold via spawn plan |
| `Debug_AdvStress_RapidElimination()` | Camera-tracked P2→P3→P4 elimination chain |
| `Debug_AdvStress_BuildingLimitOscillation()` | 10-cycle recount oscillation |
| `Debug_AdvStress_MaxPopPressure()` | Pop cap consistency under saturation |
| `Debug_AdvStress_BlueprintStorm()` | Resolve all BP types for all 16 civs |
| `Debug_AdvStress_ConcurrentThrash()` | Interleave siege/building/auto-age/reward calls |

---

## Cross-Log Triage Workflow

When investigating weapon/precache failures that don't appear in SCAR output (scarlog), correlate with engine-level logs:

### Log Locations

| Log | Path | Content |
|-----|------|---------|
| SCAR output (scarlog) | Run folder `/LogFiles/` | SCAR `print()` output, manifest reports, `[PRECACHE-MISS]` guards |
| Engine warnings (persistent) | `C:/Users/<user>/Documents/My Games/Age of Empires IV/warnings.log` | Engine-level asset/resource warnings across all sessions |
| Per-session warnings | Run folder `/LogFiles/warnings.<timestamp>.txt` | Engine warnings for a single session |
| Per-session sim messages | Run folder `/LogFiles/simmessages.<timestamp>.txt` | Loading steps, mod init |

### Triage Steps

| Step | Command / Action | Purpose |
|------|------------------|---------|
| 1 | debug.leaver.precache.report() | Check for route gaps (SCAR level) |
| 2 | debug.leaver.precache.weaponaudit() | Check for weapon sub-resource failures (spawn + inspect) |
| 3 | debug.leaver.precache.transfer("abbasid") | Focused Abbasid receiver inspection |
| 4 | Check engine `warnings.log` | If weapon-audit is clear but visual issues persist, search for `weapon_` + unit BP, `precache`/`resource` + BP, `failed`/`missing` near session timestamps |

### Useful Filters (for engine logs)

| Pattern | Matches |
|---------|---------|
| weapon_manatarms_3_abb | Weapon sub-resource for MaA |
| precache.*abb | Precache entries for Abbasid |
| missing.*blueprint | Missing blueprint warnings |

---

## Recommended Test Plans

> **Reference only.** Plans below list command *sequences* for human reference. When surfacing commands in a response, use the markdown table format per `console-commands.instructions.md` § Presentation Format — one row per command.

Use these when surfacing commands in Phase 4.

### Single-Command Full Run (one console entry)

| Variant | Command | Notes |
|---------|---------|-------|
| Tag dispatch (preferred) | debug.run("all") | Runs all master suites end-to-end via tag dispatch |
| Legacy equivalent | Debug_RunAll() | Identical behavior, no tag dispatch overhead |
| Step mode | Debug_RunAll(true) | Pause between every phase across all suites |

Each suite auto-chains on completion via `_Debug_EndMarker`. Final summary prints `[CBA_DEBUG_END] suite=MasterSuite` with aggregate pass/total. Crash-protected: if any suite throws during setup, it records a fail and the pipeline continues.

### Fast Pass (~2 min, in-game console)

| Path | Command |
|------|---------|
| Tag dispatch | debug.run("smoke") |
| Tag dispatch | debug.run("inspect") |
| Tag dispatch | debug.run("limits") |

Legacy equivalent:

| Command |
|---------|
| Debug_RunSmokeTests() |
| Debug_GetOptionParseResults() |
| Debug_GetBuildingLimitState() |
| Debug_GetSiegeLimitState() |
| Debug_GetLimitsUIState() |

### Full Pass — Individual Suites (~5 min, in-game console)

| Command |
|---------|
| Debug_FullValidation() |
| Debug_LimitEnforcementValidator() |
| Debug_StressTest() |
| Debug_SiegeLimitStressTest() |
| Debug_CoverageTest() |
| Debug_EventProbes() |
| Debug_ScenarioStatus() |

### Targeted Pass (select by area)

> Names listed for reference. When surfacing in responses, each command gets its own row in the command table.

| Area | Commands |
|------|----------|
| Limits | Debug_GetBuildingLimitState, Debug_GetSiegeLimitState, Debug_LimitsUIStress |
| Leaver/Transfer | Debug_LeaverValidation, Debug_TransferValidation, Debug_GetLeaverBalanceState |
| Stress | Debug_StressStage, Debug_CoverageBatch |
| Blueprints | Debug_PrecacheStatus, Debug_LeaverResolve_ForcedBP |
| Precache | Debug_PrecacheManifest_Summary, Debug_PrecacheManifest_Gaps, Debug_PrecacheManifest_Report |
| UI | Debug_GetLimitsUIState, Debug_ConstructionTrace |

### Step Mode Pass (~5+ min, interactive)

| Order | Command | Notes |
|-------|---------|-------|
| 1 | Debug_StepMode(true) | Enable step mode |
| 2 | Debug_FullValidation() | Or any suite |
| 3 | Debug_StepStatus() | Console shows [STEP] prompt after each phase — inspect state |
| 4 | Debug_Continue() | Advance to next phase (or Debug_Skip() to skip) |
| — | *(repeat 3–4)* | Until [CBA_DEBUG_END] marker prints with pass/total/elapsed |
| last | Debug_StepMode(false) | Disable step mode |

### Spawn + Visual Pass (~3 min, interactive)

| Order | Command | Notes |
|-------|---------|-------|
| 1 | Debug_FocusPlayer(1) | Focus camera on player 1's keep |
| 2 | Debug_PauseAI() | Freeze AI for observation |
| 3 | Debug_SpawnPlan_SiegeStress() | Observe siege units at threshold boundaries; camera cues mark steps |
| 4 | Debug_ResumeAI() | Unfreeze AI after plan completes |

### Workspace Validation (PowerShell, from repo root)

| Command | Purpose |
|---------|---------|
| pwsh -File .\scripts\structure_lint.ps1 | Structure lint |
| pwsh -File .\scripts\doc_lint.ps1 | Documentation lint |
| pwsh -File .\scripts\run_all_extraction.ps1 | Data extraction |
| pwsh -File .\changelog\scripts\validate-entry.ps1 -EntryPath ".\changelog\docs\entry-template.jsonl" | Changelog validation |

---

## Common Pitfalls

| Pitfall | Pattern | Fix |
|---------|---------|-----|
| Nil player | `World_GetPlayerAt(N)` with wrong slot | Verify player count with `World_GetPlayerCount()` |
| Stale entity | Stored handle after `Entity_Destroy` | Check `Entity_IsValid()` before use |
| Wrong scope | `Rule_AddGlobalEvent` for player-specific | Use `EventRule_AddPlayerEvent` |
| DLC variant miss | `player_civ == "english"` misses Lancaster | Ensure DLC variant has its own `AGS_ENTITY_TABLE` entry |
| Transfer desync | `Entity_SetPlayerOwner` doesn't fire construction events | Call recount after transfer |
| UI Width bind | `Width="{Binding [field]}"` in XamlPresenter | Fatal crash — use Fill color or static width |

---

## Reference Files

| Resource | Path |
|----------|------|
| Game events | `references/api/game-events.md` |
| SCAR API | `references/api/scar-api-functions.md` |
| Constants | `references/api/constants-and-enums.md` |
| Blueprints | `references/blueprints/` |
| Mod debug ref | `references/mods/onslaught-debug-reference.md` |
| SCAR coding rules | `.github/instructions/coding/scar-coding.instructions.md` |
| Blueprint rules | `.github/instructions/coding/scar-blueprints.instructions.md` |
| XAML/UI rules | `.github/instructions/coding/xaml-ui.instructions.md` |
