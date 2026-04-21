---
applyTo: "**/*.scar"
description: "Central registry of confirmed crash patterns, instability bugs, and verified workarounds for the Onslaught SCAR codebase. Auto-loads for all SCAR files."
---

# Known Issues Registry

> **Purpose:** Single-source lookup for all confirmed crash/instability patterns. Instruction files link here via `[KI-xxx-nnn]` identifiers instead of duplicating descriptions.
> **Last Updated:** 2026-04-20

## Severity Tier Mapping

| Registry Tier | XAML-UI Equivalent | Criteria |
|---|---|---|
| **FATAL** | FATAL | Confirmed crash — reproduced at least once with crash dialog, D3D error, or SCAR halt |
| **HIGH** | WARN-HIGH | Likely crash — pattern avoided in all shipping code, or 1 crash report without isolated repro |
| **MEDIUM** | WARN-LOW | Silent bug — incorrect behavior with no crash; visual glitch, state desync, or log noise |
| **LOW** | (cosmetic) | Cosmetic or test-only — wrong assertion, log spam, minor visual artifact |

## Status Lifecycle

```
ACTIVE ──→ FIXED        (patch applied + verification passes)
ACTIVE ──→ MITIGATED    (workaround applied, root cause remains)
ACTIVE ──→ WONTFIX      (accepted risk with documented rationale)
MITIGATED ──→ FIXED     (root cause resolved)
FIXED ──→ ACTIVE        (regression detected — add regression note)
```

## Maintenance Protocol

- **New issue:** Add entry when a crash/instability pattern is confirmed through runtime reproduction. Assign next sequential ID in its category.
- **Status update:** Change status when fix is applied and verified. Add verification date and session reference.
- **Regression:** If a FIXED issue recurs, change status back to ACTIVE and add a "Regression" note with date and trigger.
- **Pruning:** FIXED issues with 3+ months since verification and no regression may be moved to the Resolved Archive section at the bottom. Never delete — only archive.

## ID Scheme

Format: `KI-{category}-{seq}`

| Code | Scope |
|---|---|
| `XAML` | XamlPresenter / XAML string construction |
| `DC` | DataContext / UI_SetDataContext |
| `TOGGLE` | HUD toggle / visibility transitions |
| `ANIM` | Animation engine (pulse, decay, FLIP) |
| `LIFE` | Module lifecycle (init, finalize, teardown) |
| `SIEGE` | Siege/building limits |
| `AGE` | Age progression / Player_SetMaximumAge |
| `CIV` | Civ-specific (HoW, landmarks, variants) |
| `DEBUG` | Debug suite issues |

---

## Quick Lookup Table

| ID | Title | Status | Severity |
|---|---|---|---|
| [KI-XAML-001](#ki-xaml-001-widthheight-datacontext-binding-crash) | Width/Height DataContext binding crash | FIXED | FATAL |
| [KI-XAML-002](#ki-xaml-002-opacity-binding-in-itemscontrol-itemtemplate--d3d-crash) | Opacity binding in ItemsControl ItemTemplate — D3D crash | FIXED | FATAL |
| [KI-XAML-003](#ki-xaml-003-attached-property-setter-syntax-crash) | Attached-property setter syntax crash | FIXED | HIGH |
| [KI-XAML-004](#ki-xaml-004-ranking-threshold-blocks-elimination-animation) | Ranking threshold blocks elimination animation | FIXED | MEDIUM |
| [KI-DC-001](#ki-dc-001-unbound-numeric-fields-in-itemssource-crash-d3d-on-toggle) | Unbound numeric fields in ItemsSource crash D3D on toggle | FIXED | FATAL |
| [KI-DC-002](#ki-dc-002-killscorepulsescale-unbound-numeric-in-datacontext) | killScorePulseScale unbound numeric in DataContext | FIXED | FATAL |
| [KI-DC-003](#ki-dc-003-direct-ui_setdatacontext-bypass-of-sanitizer-in-toggle) | Direct UI_SetDataContext bypass of sanitizer in Toggle | FIXED | FATAL |
| [KI-DC-004](#ki-dc-004-playerui_presetfinalize-missing-sanitizer-before-collapse) | PlayerUI_PresetFinalize missing sanitizer before collapse | FIXED | FATAL |
| [KI-DC-005](#ki-dc-005-opacityfill-alpha-encoding-for-elimination-overlays) | Opacity→Fill-alpha encoding for elimination overlays | FIXED | FATAL |
| [KI-TOGGLE-001](#ki-toggle-001-rapid-toggle-causes-d3d-crash) | Rapid toggle causes D3D crash (no throttle) | FIXED | FATAL |
| [KI-TOGGLE-002](#ki-toggle-002-staged-visibility--scoresbjectives-visible-before-datacontext-ready) | Staged visibility — scores/objectives visible before DataContext ready | FIXED | HIGH |
| [KI-TOGGLE-003](#ki-toggle-003-early-game-toggle-before-first-ring-rule) | Early-game toggle before first Ring Rule populates DataContext | FIXED | HIGH |
| [KI-ANIM-001](#ki-anim-001-score-pulse-prevscore-vs-lastscore-field-name-mismatch) | Score pulse prevScore vs lastScore field name mismatch | ACTIVE | FATAL |
| [KI-ANIM-002](#ki-anim-002-pulse-constants-test-uses-stale-assertion-range) | Pulse constants test uses stale assertion range | ACTIVE | LOW |
| [KI-ANIM-003](#ki-anim-003-parabolic-mapping-test-uses-wrong-formula) | Parabolic mapping test uses wrong formula | ACTIVE | LOW |
| [KI-DEBUG-001](#ki-debug-001-hide-hud-test-fails-due-to-toggle-throttle) | Hide HUD test fails due to toggle throttle | ACTIVE | LOW |
| [KI-DEBUG-002](#ki-debug-002-tick-rule-test-fails--rule_ispaused-unavailable) | Tick rule test fails — Rule_IsPaused unavailable | ACTIVE | LOW |
| [KI-DEBUG-003](#ki-debug-003-deferred-queue-test-fails--sync-check-on-async-operation) | Deferred queue test fails — sync check on async operation | ACTIVE | LOW |
| [KI-AGE-001](#ki-age-001-player_setmaximumage-silently-no-ops-for-13-modern-civs) | Player_SetMaximumAge silently no-ops for 13 modern civs | MITIGATED | HIGH |
| [KI-CIV-001](#ki-civ-001-how-entity-type-detection-fails--house_of_wisdom_abb-mismatch) | HoW entity type detection fails — house_of_wisdom_abb mismatch | MITIGATED | MEDIUM |
| [KI-SIEGE-001](#ki-siege-001-building-limit-counter-desync-after-entity_setplayerowner) | Building-limit counter desync after Entity_SetPlayerOwner | ACTIVE | MEDIUM |
| [KI-SIEGE-002](#ki-siege-002-english-keeps-dual-classified-in-production-counting) | English keeps dual-classified in production counting | ACTIVE | MEDIUM |

---

## Full Entries

---

### KI-XAML-001: Width/Height DataContext Binding Crash

**Status:** FIXED
**Severity:** FATAL
**Affected Files:** `Gamemodes/Onslaught/assets/scar/AGS/ags_limits_ui.scar` (L721, L922), `Gamemodes/Onslaught/assets/scar/debug/cba_debug_ui_prompts.scar` (L33)
**Discovered:** 2026-03 — xaml-ui.instructions.md FATAL-1
**Root Cause:** XamlPresenter crashes when `Width` or `Height` are bound via `{Binding [field]}`. Width/Height are computed at creation time by the layout engine; dynamic DataContext binding interferes with panel initialization.
**Symptoms:** XamlPresenter crash on first render when panel contains `Width="{Binding [my_width]}"` or `Height="{Binding [my_height]}"`.
**Fix/Workaround:** Use static string placeholder + `string.gsub()` at panel creation time, OR use `ElementName` proxy from off-screen width-source element, OR recreate entire panel on width change. 3 independent sources confirm FATAL classification.
**Verification:** Verify no `Width="{Binding` or `Height="{Binding` patterns exist in any `.scar` file: `grep -r 'Width="{Binding' Gamemodes/`

---

### KI-XAML-002: Opacity Binding in ItemsControl ItemTemplate — D3D Crash

**Status:** FIXED
**Severity:** FATAL
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/xaml/playerui_hud.scar`
**Discovered:** 2026-03-30 — xaml-ui.instructions.md FATAL-2
**Root Cause:** `Opacity="{Binding [x]}"` on Viewbox elements inside `ItemsControl.ItemTemplate` rows crashes D3D on Collapsed→Visible toggle. The WPF bridge cannot serialize opacity bindings for elements within templates during visibility transitions.
**Symptoms:** D3D crash dialog on HUD toggle (Collapsed→Visible) when ItemTemplate rows contain Opacity DataContext bindings.
**Fix/Workaround:** Use Fill-alpha (`#AARRGGBB`) bindings on child Path elements instead of Opacity bindings on parent Viewbox elements. Implemented via `_PlayerUI_FillWithOpacity()` helper.
**Verification:** Verify no `Opacity="{Binding` patterns inside `ItemTemplate` blocks: `grep -A5 'ItemTemplate' Gamemodes/ | grep 'Opacity="{Binding'`

---

### KI-XAML-003: Attached-Property Setter Syntax Crash

**Status:** FIXED
**Severity:** HIGH
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/xaml/playerui_hud.scar`
**Discovered:** 2026-03 — xaml-ui.instructions.md WARN-HIGH-5, Incident 1
**Root Cause:** AoE4 XamlPresenter has custom attached-property parsing. WPF parenthesized form `Property="(Grid.Column)"` is not recognized and causes runtime crash during element reordering (eliminated-row mirroring).
**Symptoms:** XamlPresenter runtime crash during element reordering when `<Setter>` uses `Property="(Grid.Column)"` syntax.
**Fix/Workaround:** Always use engine form `Property="Grid.Column"` / `Property="Grid.Row"` in `<Setter>` elements. Verified by reverting to observer template syntax (teamvteam.scar L677–679).
**Verification:** `grep -r 'Property="(Grid' Gamemodes/` — should return 0 results.

---

### KI-XAML-004: Ranking Threshold Blocks Elimination Animation

**Status:** FIXED
**Severity:** MEDIUM
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/playerui_ranking.scar`
**Discovered:** 2026-03 — xaml-ui.instructions.md Incident 3
**Root Cause:** Eliminated sentinel score initialized as `-1`, only ~1 point below lowest alive player. Threshold gate (`delta >= 15`) blocks reorder, preventing bottom-drop FLIP animation.
**Symptoms:** Eliminated player row fails to animate to bottom position when alive player scores are low (near 15-point margin).
**Fix/Workaround:** Changed eliminated sentinel score from `-1` to `-100000`, guaranteeing alive player scores always exceed the 15-point threshold.
**Verification:** Eliminate a player when alive scores are <20 → eliminated row animates to bottom within 1 FLIP cycle.

---

### KI-DC-001: Unbound Numeric Fields in ItemsSource Crash D3D on Toggle

**Status:** FIXED
**Severity:** FATAL
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/playerui_updateui.scar` (sanitizer), `Gamemodes/Onslaught/assets/scar/playerui/playerui_ranking.scar`
**Discovered:** 2026-03 — repo memory, runtime toggle testing
**Root Cause:** The AoE4 SCAR-WPF bridge crashes when ItemsSource entries in DataContext contain numeric fields that have no corresponding XAML binding. Only string fields matching explicit `{Binding [fieldName]}` paths are safe. Adding any NEW unbound numeric field triggers D3D crash on Collapsed→Visible toggle.
**Symptoms:** D3D crash on HUD toggle when DataContext ItemsSource arrays contain numeric fields without matching XAML `{Binding}`.
**Fix/Workaround:** Sanitizer in `PlayerUI_ApplyDataContext()` strips unbound numeric fields from per-player entries before WPF bridge serialization. All DataContext pushes must route through this sanitizer.
**Verification:** Toggle HUD 10+ times rapidly after adding a test numeric field → no crash.

---

### KI-DC-002: killScorePulseScale Unbound Numeric in DataContext

**Status:** FIXED
**Severity:** FATAL
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/playerui_animate.scar` (~L1109), `Gamemodes/Onslaught/assets/scar/playerui/uidatacontext/initialize_datacontext.scar` (~L44)
**Discovered:** 2026-04 — repo memory
**Root Cause:** `killScorePulseScale` was an unbound numeric field written to per-player ItemsSource entries. Only `killScorePulseFontSize` (bound at playerui_hud.scar L274) should be published to DataContext. The scale value was a local computation intermediate leaked into the shared state.
**Symptoms:** D3D toggle crash identical to KI-DC-001 pattern, triggered by the `killScorePulseScale` field.
**Fix/Workaround:** Made `killScorePulseScale` a local variable in `ApplyDisplayValues`. Removed initialization from `initialize_datacontext.scar`. Only `killScorePulseFontSize` is published.
**Verification:** `grep -r 'killScorePulseScale' Gamemodes/Onslaught/assets/scar/playerui/` — should appear only in local variable declarations, never in DataContext writes.

---

### KI-DC-003: Direct UI_SetDataContext Bypass of Sanitizer in Toggle

**Status:** FIXED
**Severity:** FATAL
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/playerui_updateui.scar` (~L2076)
**Discovered:** 2026-04 — repo memory
**Root Cause:** `PlayerUI_Toggle()` contained a direct `pcall(UI_SetDataContext, 'PlayerUIHud', PlayerUiDataContext)` call at the pre-show DataContext refresh step, bypassing the sanitizer in `PlayerUI_ApplyDataContext()`. Unbound numeric fields were present during the Collapsed→Visible transition.
**Symptoms:** D3D crash on HUD toggle despite sanitizer being in place for all periodic update paths (8s, 1s, 0.1s rules).
**Fix/Workaround:** Routed the toggle's DataContext refresh through `PlayerUI_ApplyDataContext()` which strips unbound numerics before WPF bridge serialization.
**Verification:** Toggle HUD 10+ times rapidly → no crash. Verify no direct `UI_SetDataContext.*PlayerUIHud` calls exist outside `PlayerUI_ApplyDataContext`.

---

### KI-DC-004: PlayerUI_PresetFinalize Missing Sanitizer Before Collapse

**Status:** FIXED
**Severity:** FATAL
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/playerui_updateui.scar`
**Discovered:** 2026-04 — session work
**Root Cause:** `PlayerUI_PresetFinalize` path collapsed the HUD panel without first running the sanitizer pass, leaving stale unbound numerics in the DataContext for the next visibility toggle.
**Symptoms:** D3D crash on next HUD toggle after a preset finalize operation.
**Fix/Workaround:** Added `pcall(PlayerUI_ApplyDataContext)` before the collapse call in `PlayerUI_PresetFinalize`.
**Verification:** Run preset finalize → toggle HUD → no crash.

---

### KI-DC-005: Opacity→Fill-Alpha Encoding for Elimination Overlays

**Status:** FIXED
**Severity:** FATAL
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/xaml/playerui_hud.scar` (L176, L189, L347, L375), `Gamemodes/Onslaught/assets/scar/playerui/playerui_animate.scar` (L797, L806), `Gamemodes/Onslaught/assets/scar/playerui/playerui_updateui.scar` (L182, L1074)
**Discovered:** 2026-04 — repo memory
**Root Cause:** All Opacity bindings inside `ItemsControl` `DataTemplate` elements cause D3D crash on toggle (same root as KI-XAML-002). Elimination overlay fade effects required an alternative approach.
**Symptoms:** D3D crash on HUD toggle when elimination overlays use `Opacity="{Binding [elimRevealOpacity]}"`.
**Fix/Workaround:** Converted all Opacity bindings to Fill-alpha (`#AARRGGBB`) string bindings (`elimStrikethroughFill`, `elimOverlayNameFill`, `elimOverlayStatsFill`, `elimGlowFill`). Helpers `_PlayerUI_FillWithOpacity()` and `_PlayerUI_GlowFillWithOpacity()` encode opacity into the alpha channel. `_PlayerUI_UpdateElimFills()` must be called after any write to internal `elimRevealOpacity` or `elimGlowOpacity` state.
**Verification:** Eliminate player → verify overlay fades appear → toggle HUD 10+ times → no crash.

---

### KI-TOGGLE-001: Rapid Toggle Causes D3D Crash

**Status:** FIXED
**Severity:** FATAL
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/playerui_updateui.scar`
**Discovered:** 2026-04 — V2 fix
**Root Cause:** Rapid HUD toggling (multiple toggles within <0.3s) causes D3D crash because the WPF bridge cannot complete visibility transitions fast enough.
**Symptoms:** D3D crash when pressing toggle key rapidly.
**Fix/Workaround:** Added 0.3s throttle via `_PlayerUI_LastToggleTime` guard. Toggle requests within 0.3s of previous toggle are silently rejected.
**Verification:** Mash toggle key 10+ times rapidly → no crash, throttle rejects extras.

---

### KI-TOGGLE-002: Staged Visibility — Scores/Objectives Visible Before DataContext Ready

**Status:** FIXED
**Severity:** HIGH
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/playerui_updateui.scar`
**Discovered:** 2026-04 — V3 fix
**Root Cause:** On toggle-to-visible, score and objective sub-panels became visible before their DataContext fields were populated, causing brief flash of uninitialized values.
**Symptoms:** Brief visual flash of "0" scores or empty objective text on HUD show.
**Fix/Workaround:** Deferred sub-panel visibility via `Rule_AddOneShot` — main container becomes visible first, DataContext populates, then sub-panels show on next frame.
**Verification:** Toggle HUD on → no flash of uninitialized values.

---

### KI-TOGGLE-003: Early-Game Toggle Before First Ring Rule Populates DataContext

**Status:** FIXED
**Severity:** HIGH
**Affected Files:** `Gamemodes/Onslaught/assets/scar/playerui/playerui_updateui.scar`
**Discovered:** 2026-04 — V4 fix
**Root Cause:** First Ring Rule fires at 8.0s game time. If player toggles HUD before 8.0s, DataContext is empty/partially initialized, causing visual artifacts or potential crash.
**Symptoms:** Garbled or missing HUD data when toggling before 8s game time.
**Fix/Workaround:** Guard in toggle path: if `gameTime < 8.0s`, reject toggle with log message.
**Verification:** Start game → immediately toggle HUD before 8s → toggle is rejected, no crash.

---

### KI-ANIM-001: Score Pulse prevScore vs lastScore Field Name Mismatch

**Status:** ACTIVE
**Severity:** FATAL
**Affected Files:** `Gamemodes/Onslaught/assets/scar/debug/cba_debug_playerui_anim.scar` (~L1706, ~L2237), `Gamemodes/Onslaught/assets/scar/playerui/playerui_animate.scar` (~L760)
**Discovered:** 2026-04-20 — scarlog analysis (Appendix B of plan.md)
**Root Cause:** Debug test helpers seed `_PlayerUI_ScorePulse` entries with field name `prevScore` but runtime code at playerui_animate.scar L760 reads `pulse.lastScore`. Mismatch causes `nil > number` comparison crash when debug-seeded pulse entries reach the runtime comparison.
**Symptoms:** `playerui_animate.scar:760: attempt to compare nil with number` — halts SCAR execution.
**Fix/Workaround:** (Planned) Change `prevScore` to `lastScore` in debug seed code at L1706 and L2237. Add nil guard `pulse.lastScore ~= nil and` at runtime L760 as defensive safety.
**Verification:** `debug.playerUI.run()` → 138/138 PASS. Run `debug.playerUI.stressTest(2.0)` → no fatal.

---

### KI-ANIM-002: Pulse Constants Test Uses Stale Assertion Range

**Status:** ACTIVE
**Severity:** LOW
**Affected Files:** `Gamemodes/Onslaught/assets/scar/debug/cba_debug_playerui_anim.scar` (~L1335)
**Discovered:** 2026-04-20 — scarlog analysis
**Root Cause:** Test assertion checks `peak > 1.0 and peak < 2.0` but the constant `_PLAYERUI_PULSE_SCALE_PEAK` is a delta value (0.12), not a runtime multiplied value. Assertion bounds are wrong for validating the constant.
**Symptoms:** Test reports FAIL with `decay=0.3 peak=0.12` — false negative.
**Fix/Workaround:** (Planned) Change assertion to `peak > 0 and peak < 1.0`.
**Verification:** `debug.playerUI.run()` → pulse constants test PASS.

---

### KI-ANIM-003: Parabolic Mapping Test Uses Wrong Formula

**Status:** ACTIVE
**Severity:** LOW
**Affected Files:** `Gamemodes/Onslaught/assets/scar/debug/cba_debug_playerui_anim.scar` (~L1717)
**Discovered:** 2026-04-20 — scarlog analysis
**Root Cause:** Debug test formula `1.0 + (4 * pv * (1 - pv)) * (peak - 1.0)` does not match runtime formula `1.0 + peak * (4 * pv * (1 - pv))` at playerui_animate.scar ~L1141.
**Symptoms:** Parabolic mapping boundary test produces wrong expected values — false negative.
**Fix/Workaround:** (Planned) Change test formula to `1.0 + peak * eased` where `eased = 4 * pv * (1 - pv)`.
**Verification:** `debug.playerUI.run()` → parabolic mapping test PASS.

---

### KI-DEBUG-001: Hide HUD Test Fails Due to Toggle Throttle

**Status:** ACTIVE
**Severity:** LOW
**Affected Files:** `Gamemodes/Onslaught/assets/scar/debug/cba_debug_playerui.scar` (~L407)
**Discovered:** 2026-04-20 — scarlog analysis
**Root Cause:** "Hide HUD" test runs <0.3s after the preceding "Show HUD" test. The toggle throttle (KI-TOGGLE-001) rejects the hide call because it's within the 0.3s window.
**Symptoms:** Test reports `HudVisible=true` — hide operation was silently rejected by throttle.
**Fix/Workaround:** (Planned) Add `_PlayerUI_LastToggleTime = -1` before the test to reset the throttle timer to its initialization value.
**Verification:** `debug.playerUI.run()` → "Hide HUD (Toggle to collapsed)" test PASS.

---

### KI-DEBUG-002: Tick Rule Test Fails — Rule_IsPaused Unavailable

**Status:** ACTIVE
**Severity:** LOW
**Affected Files:** `Gamemodes/Onslaught/assets/scar/debug/cba_debug_playerui_anim.scar` (~L1275)
**Discovered:** 2026-04-20 — scarlog analysis
**Root Cause:** `Rule_IsPaused` API may not exist in all SCAR engine versions. Current pcall returns false on error, causing test failure instead of graceful skip.
**Symptoms:** Test reports `Rule_IsPaused error`.
**Fix/Workaround:** (Planned) Convert pcall error path to return `true` (skip test) instead of `false` (fail test). The test validates a non-critical diagnostic and should degrade gracefully.
**Verification:** `debug.playerUI.run()` → "Tick rule ↔ dirty flag consistency" test PASS or SKIP.

---

### KI-DEBUG-003: Deferred Queue Test Fails — Sync Check on Async Operation

**Status:** ACTIVE
**Severity:** LOW
**Affected Files:** `Gamemodes/Onslaught/assets/scar/debug/cba_debug_playerui_anim.scar` (~L1671)
**Discovered:** 2026-04-20 — scarlog analysis
**Root Cause:** Test checks `#_RANKING_DEFERRED_TARGETS == 0` synchronously, but deferred queue drains via `Rule_AddOneShot` (async). When `_PlayerUI_RankTransitionLock` is active, queue entries are intentionally held.
**Symptoms:** Test reports `2 remaining` — false negative when transition lock is active.
**Fix/Workaround:** (Planned) Change assertion to `n == 0 or _PlayerUI_RankTransitionLock` to tolerate non-zero queue during active transition locks.
**Verification:** `debug.playerUI.run()` → "Deferred queue drained" test PASS.

---

### KI-AGE-001: Player_SetMaximumAge Silently No-Ops for 13 Modern Civs

**Status:** MITIGATED
**Severity:** HIGH
**Affected Files:** `data/aoe4/scar_dump/scar gameplay/cardinal.scar` (~L680), `Gamemodes/Onslaught/assets/scar/gameplay/cba_auto_age.scar` (~L138, ~L238)
**Discovered:** 2026-03 — repo memory
**Root Cause:** `Player_SetMaximumAge` in cardinal.scar uses a hardcoded 9-civ prefix table (chi_, eng_, fre_, hre_, mon_, rus_, sul_, abb_ + campaign aliases). Silently no-ops for 13 modern civs: all HA variants, byzantine, japanese, malian, ottoman (wrong prefix→sul_), lancaster, templar.
**Symptoms:** Age cap not applied for modern civs. No error message — menu items remain accessible.
**Fix/Workaround:** `CBA_AutoAge_SetMaximumAge` in cba_auto_age.scar replaces the vanilla function using `AGS_CIV_PREFIXES` (22 civs) with per-civ menu prefix resolution, wing upgrade handling for abbasid/ayyubid, and pcall-wrapped menu calls.
**Verification:** `debug.autoage.verify()` → all 22 civs show correct age cap.

---

### KI-CIV-001: HoW Entity Type Detection Fails — house_of_wisdom_abb Mismatch

**Status:** MITIGATED
**Severity:** MEDIUM
**Affected Files:** `Gamemodes/Onslaught/assets/scar/AGS/CBA/helpers/ags_blueprints.scar` (~L402, ~L573)
**Discovered:** 2026-03 — repo memory
**Root Cause:** Both Abbasid and Abbasid_ha_01 (Ayyubid) HoW EBPs expose `unit_type` value `house_of_wisdom_abb`, so `Entity_IsOfType` checks for `house_of_wisdom` (without `_abb` suffix) fail to detect HoW entities.
**Symptoms:** HoW detection functions return false for actual HoW entities. Wing upgrades and rebuild hooks silently skip.
**Fix/Workaround:** Detection functions in ags_blueprints.scar use explicit `house_of_wisdom_abb` string match instead of partial type check.
**Verification:** Build HoW as Abbasid and Ayyubid → both detected by helper functions.

---

### KI-SIEGE-001: Building-Limit Counter Desync After Entity_SetPlayerOwner

**Status:** ACTIVE
**Severity:** MEDIUM
**Affected Files:** `Gamemodes/Onslaught/assets/scar/gameplay/cba.scar`, `Gamemodes/Onslaught/assets/scar/gameplay/cba_siege_data.scar`
**Discovered:** 2026-03 — debugger-architecture.instructions.md audit finding #1
**Root Cause:** `Entity_SetPlayerOwner` does NOT fire `GE_ConstructionComplete` or `GE_ConstructionStart`. Counter systems that rely on these events to track building counts will desync when ownership is transferred (e.g., leaver redistribution).
**Symptoms:** Building-limit counters show incorrect counts after entity ownership transfer. May allow or block construction incorrectly.
**Fix/Workaround:** (Planned) Counter systems must call `RamLimit_Recount` / `SiegeTowerLimit_Recount` manually after any `Entity_SetPlayerOwner` call.
**Verification:** Transfer a keep via `Entity_SetPlayerOwner` → verify building counts match actual entity counts via `debug.siege.verify()`.

---

### KI-SIEGE-002: English Keeps Dual-Classified in Production Counting

**Status:** ACTIVE
**Severity:** MEDIUM
**Affected Files:** `Gamemodes/Onslaught/assets/scar/gameplay/cba.scar`
**Discovered:** 2026-03 — debugger-architecture.instructions.md audit finding #2
**Root Cause:** English keeps are classified as both a keep and a production building, causing them to be counted twice in certain production-limit checks.
**Symptoms:** English players may hit production limits earlier than expected, or counters may report inflated building counts.
**Fix/Workaround:** (Planned) Deduplicate classification in production counting logic — check for English keep explicitly and count once.
**Verification:** Play as English → verify keep counts via `debug.siege.verify()` match actual keep count.

---

## Resolved Archive

_No archived entries yet. FIXED entries older than 3 months with no regression will be moved here._
