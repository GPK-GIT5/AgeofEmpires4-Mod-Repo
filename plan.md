# SCAR Instruction System — Structured Improvement Plan

> **Purpose:** Session-transfer document. Provides a complete, actionable plan for introducing a dedicated known-issues registry and lightweight issue logging format into the `.github/instructions/` system.  
> **Date:** 2026-04-20  
> **Prerequisite:** Complete the 8 pending debug fixes (see Appendix A) before starting this plan.

---

## 1  Problem Statement

Crash-pattern knowledge is scattered across 7+ locations with no single lookup point:

| Location | What Lives There | Problem |
|---|---|---|
| `xaml-ui.instructions.md` §1–§4 | XAML-specific crash tiers (FATAL-1, FATAL-2, WARN-HIGH 1–7) | Covers only XAML string construction; excludes DataContext, sanitizer, toggle, and lifecycle crash patterns |
| `debugger-architecture.instructions.md` | 5 known audit findings (inline) | Buried in architecture spec; no severity tier, no status tracking |
| `scar-coding.instructions.md` §3 | 6 event pitfalls | Lifecycle-focused, not crash-focused |
| `references/ui/PlayerUI_Architecture.md` | Pulse constants, XAML safety rules §1–§5 | Reference doc, not agent-actionable instruction |
| Repository memories | 10+ crash patterns (D3D toggle, unbound numerics, sanitizer bypass, pulse field, HoW detection, etc.) | Ephemeral; auto-expire if not re-stored; no structured format |
| Code comments | Inline crash notes (`-- FATAL`, `-- D3D crash`, `-- never emit`) | Discoverable only by reading each file; no index |
| `changelog/` + `references/ai_sessions/` | Historical diagnosis narratives | Immutable logs mixed with active knowledge; no status tracking |

**Consequences:**
- Agent must search 16+ files to verify whether a pattern is known before making changes.
- Same pattern documented 3–4 times with inconsistent severity labels (`FATAL` vs `BUG` vs `KNOWN ISSUE`).
- No lifecycle tracking: a fixed issue looks identical to an active one.
- No way to distinguish prescriptive rules from descriptive history.

---

## 2  Design Principles

1. **Single registry, multiple consumers.** One canonical file lists all known crash/instability patterns. Instruction files and reference docs link to it rather than duplicating entries.
2. **Three-layer separation.** Rules (prescriptive) → Known Issues (descriptive, status-tracked) → Historical Logs (immutable). No cross-contamination.
3. **Lightweight format.** Each issue is a single Markdown section with 8 fixed fields. No JSON, no database, no tooling dependency.
4. **Agent-actionable.** The file uses `applyTo` frontmatter so it auto-loads for relevant files. Severity tiers and action directives match the existing `xaml-ui.instructions.md` pattern.
5. **No duplication.** Existing files that contain crash patterns will link to the new registry via `[KI-nnn]` identifiers instead of repeating the full description.

---

## 3  Architecture

### 3.1  Three-Layer Model

```
Layer 1: RULES (prescriptive, auto-loaded)
  .github/instructions/coding/*.instructions.md
  .github/instructions/core/*.instructions.md
  └── Tell the agent what to DO and NOT DO
      Cross-reference known issues via [KI-nnn] links

Layer 2: KNOWN ISSUES (descriptive, status-tracked)
  .github/instructions/coding/known-issues.instructions.md   ← NEW
  └── Central registry of crash patterns, instability bugs, and
      verified workarounds. Each entry has a lifecycle status.

Layer 3: HISTORICAL LOGS (immutable, never prescriptive)
  references/ai_sessions/session_*.md
  changelog/*.md
  └── Diagnosis narratives, session transcripts, implementation
      summaries. Never referenced as active rules.
```

### 3.2  New File Location

```
.github/instructions/coding/known-issues.instructions.md
```

**Rationale:**
- Lives alongside `xaml-ui.instructions.md` and `scar-coding.instructions.md` (its primary consumers).
- Uses `.instructions.md` extension so Copilot auto-loads it for matching files.
- `applyTo: "Gamemodes/Onslaught/assets/scar/**"` scopes to Onslaught SCAR code (most crash patterns are Onslaught-specific).

### 3.3  Issue ID Scheme

Format: `KI-{category}-{seq}`

| Category Code | Scope |
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

Example: `KI-DC-001` = first DataContext known issue.

---

## 4  Issue Entry Format

Each issue is a level-3 heading with 8 fixed fields in a definition list:

```markdown
### KI-{cat}-{seq}: {Short Title}

**Status:** ACTIVE | FIXED | MITIGATED | WONTFIX  
**Severity:** FATAL | HIGH | MEDIUM | LOW  
**Affected Files:** `path/to/file.scar` (line range if stable)  
**Discovered:** {date} — {session or changelog ref}  
**Root Cause:** {1–3 sentence technical explanation}  
**Symptoms:** {What the user/developer sees — error message, crash dialog, visual glitch}  
**Fix/Workaround:** {What was done or should be done}  
**Verification:** {Console command or test that proves the fix holds}  
```

### Field Definitions

| Field | Required | Notes |
|---|---|---|
| **Status** | Yes | `ACTIVE` = unfixed, blocks work. `FIXED` = patched and verified. `MITIGATED` = workaround in place, root cause unresolved. `WONTFIX` = accepted risk, documented why. |
| **Severity** | Yes | Matches `xaml-ui.instructions.md` tier system: `FATAL` = confirmed crash. `HIGH` = likely crash / untested path. `MEDIUM` = silent bug. `LOW` = cosmetic. |
| **Affected Files** | Yes | Workspace-relative paths. Use line ranges only when stable (constants, table definitions). |
| **Discovered** | Yes | ISO date + link to session/changelog that first documented it. |
| **Root Cause** | Yes | Technical, not narrative. Should be self-contained (reader doesn't need to read the session log). |
| **Symptoms** | Yes | Copy-pasteable error message or visual description. Aids grep-based lookup. |
| **Fix/Workaround** | Yes | For ACTIVE: describe the planned approach. For FIXED: describe what was done + cite the commit/session. |
| **Verification** | Yes | Console command, test tag, or manual step that proves the fix. |

### Status Transitions

```
ACTIVE ──→ FIXED        (patch applied + verification passes)
ACTIVE ──→ MITIGATED    (workaround applied, root cause remains)
ACTIVE ──→ WONTFIX      (accepted risk with documented rationale)
MITIGATED ──→ FIXED     (root cause resolved)
FIXED ──→ ACTIVE        (regression detected — add regression note)
```

---

## 5  Initial Registry Contents

Seed the new file with all currently known issues from across the workspace. These are grouped by category.

### 5.1  XAML / DataContext Crash Patterns (migrate from `xaml-ui.instructions.md`)

| ID | Title | Status | Severity | Source |
|---|---|---|---|---|
| KI-XAML-001 | Width/Height DataContext binding crash | FIXED | FATAL | xaml-ui.instructions.md FATAL-1 |
| KI-XAML-002 | Opacity binding in ItemsControl ItemTemplate — D3D crash | FIXED | FATAL | xaml-ui.instructions.md FATAL-2 |
| KI-XAML-003 | Attached-property setter syntax (`(Grid.Column)`) crash | FIXED | HIGH | xaml-ui.instructions.md WARN-HIGH-5, Incident 1 |
| KI-XAML-004 | Ranking threshold blocks elimination animation | FIXED | MEDIUM | xaml-ui.instructions.md Incident 3 |

### 5.2  DataContext / Sanitizer Patterns (from repo memory + session work)

| ID | Title | Status | Severity | Source |
|---|---|---|---|---|
| KI-DC-001 | Unbound numeric fields in ItemsSource crash D3D on toggle | FIXED | FATAL | Repo memory; playerui_updateui.scar sanitizer |
| KI-DC-002 | `killScorePulseScale` unbound numeric in DataContext | FIXED | FATAL | Repo memory; removed from DataContext |
| KI-DC-003 | Direct `UI_SetDataContext` bypass of sanitizer in Toggle | FIXED | FATAL | Repo memory; routed through `PlayerUI_ApplyDataContext()` |
| KI-DC-004 | `PlayerUI_PresetFinalize` missing sanitizer before collapse | FIXED | FATAL | Session work; added `pcall(PlayerUI_ApplyDataContext)` |
| KI-DC-005 | Opacity→Fill-alpha encoding for elimination overlays | FIXED | FATAL | Repo memory; `_PlayerUI_FillWithOpacity()` pattern |

### 5.3  Toggle / Visibility Patterns (from V2–V4 fixes)

| ID | Title | Status | Severity | Source |
|---|---|---|---|---|
| KI-TOGGLE-001 | Rapid toggle causes D3D crash (no throttle) | FIXED | FATAL | V2 fix; 0.3s throttle via `_PlayerUI_LastToggleTime` |
| KI-TOGGLE-002 | Staged visibility — scores/objectives visible before DataContext ready | FIXED | HIGH | V3 fix; deferred via `Rule_AddOneShot` |
| KI-TOGGLE-003 | Early-game toggle before first Ring Rule populates DataContext | FIXED | HIGH | V4 fix; guard at `gameTime < 8.0s` |

### 5.4  Animation Engine Patterns (from current session)

| ID | Title | Status | Severity | Source |
|---|---|---|---|---|
| KI-ANIM-001 | Score pulse `prevScore` vs `lastScore` field name mismatch | ACTIVE | FATAL | Debug helpers seed with wrong field → `nil > number` crash at L760 |
| KI-ANIM-002 | Pulse constants test uses stale assertion range | ACTIVE | LOW | Test expects `peak > 1.0` but constant is delta 0.12 |
| KI-ANIM-003 | Parabolic mapping test uses wrong formula | ACTIVE | LOW | Debug T4.3 formula doesn't match runtime `1.0 + peak * eased` |

### 5.5  Debug Suite Patterns (from current session)

| ID | Title | Status | Severity | Source |
|---|---|---|---|---|
| KI-DEBUG-001 | Hide HUD test fails due to toggle throttle | ACTIVE | LOW | Test runs <0.3s after Show test; throttle rejects |
| KI-DEBUG-002 | Tick rule test fails — `Rule_IsPaused` unavailable | ACTIVE | LOW | API may not exist in all SCAR versions |
| KI-DEBUG-003 | Deferred queue test fails — sync check on async operation | ACTIVE | LOW | Queue not drained when `_PlayerUI_RankTransitionLock` active |

### 5.6  Lifecycle / Age / Civ Patterns (from existing docs)

| ID | Title | Status | Severity | Source |
|---|---|---|---|---|
| KI-AGE-001 | `Player_SetMaximumAge` silently no-ops for 13 modern civs | MITIGATED | HIGH | Repo memory; use `CBA_AutoAge_SetMaximumAge` |
| KI-CIV-001 | HoW entity type detection fails — `house_of_wisdom_abb` mismatch | MITIGATED | MEDIUM | Repo memory; both Abbasid variants share same unit_type |
| KI-SIEGE-001 | Building-limit counter desync after `Entity_SetPlayerOwner` | ACTIVE | MEDIUM | debugger-architecture.instructions.md audit finding |

---

## 6  Cross-Reference Integration

After creating the registry, update existing files to reference it instead of duplicating crash descriptions.

### 6.1  `xaml-ui.instructions.md` — Add Registry Links

In each FATAL/WARN-HIGH rule and Known Incident section, add a one-line cross-reference:

```markdown
> **Registry:** [KI-XAML-001](known-issues.instructions.md#ki-xaml-001-widthheight-datacontext-binding-crash)
```

Keep the existing rule text (it's prescriptive — "don't emit this pattern"). The registry provides the descriptive complement (root cause, discovery date, verification command).

### 6.2  `debugger-architecture.instructions.md` — Replace Inline Findings

Replace the 5 inline "known audit findings" with a summary table linking to registry entries:

```markdown
## Known Audit Findings

| Finding | Registry | Status |
|---|---|---|
| Building-limit counter desync | [KI-SIEGE-001] | ACTIVE |
| Player_SetMaximumAge scope | [KI-AGE-001] | MITIGATED |
| ... | ... | ... |
```

### 6.3  `scar-coding.instructions.md` — Link Event Pitfalls

Where event pitfalls overlap with known issues (e.g., `Entity_SetPlayerOwner` not firing construction events), add `[KI-SIEGE-001]` inline.

### 6.4  Reference Docs — No Changes

Reference files (`references/ui/PlayerUI_Architecture.md`, etc.) are descriptive, not prescriptive. They may contain their own crash notes. These do NOT need registry links — they serve a different audience (human readers doing deep dives). The registry is for agent consumption.

---

## 7  Implementation Steps

### Phase 1: Create the Registry (1 step)

1. Create `.github/instructions/coding/known-issues.instructions.md` with:
   - Frontmatter: `applyTo: "Gamemodes/Onslaught/assets/scar/**"`
   - Header explaining purpose, format spec, and status lifecycle
   - Quick lookup table (all issues, sortable by status/severity)
   - Full entries for all issues in §5 above (24 entries)

### Phase 2: Cross-Reference Existing Files (4 edits)

2. `xaml-ui.instructions.md` — Add `Registry: [KI-XAML-nnn]` links to FATAL-1, FATAL-2, WARN-HIGH-5, and Incidents 1–3.
3. `debugger-architecture.instructions.md` — Replace inline audit findings with summary table + registry links.
4. `scar-coding.instructions.md` — Add `[KI-SIEGE-001]` to `Entity_SetPlayerOwner` event pitfall.
5. `copilot-instructions.md` — Add `known-issues.instructions.md` to the Quick Reference table under "Crash pattern lookup".

### Phase 3: Establish Maintenance Protocol (documentation only)

6. Add a "Maintenance" section to the registry file header with these rules:
   - **New issue:** Add an entry when a crash/instability pattern is confirmed through runtime reproduction. Assign the next sequential ID in its category.
   - **Status update:** Change status when a fix is applied and verified. Add the verification date and session reference.
   - **Regression:** If a FIXED issue recurs, change status back to ACTIVE and add a "Regression" note with the date and trigger.
   - **Pruning:** FIXED issues with 3+ months since verification and no regression may be moved to a "Resolved Archive" section at the bottom of the file (collapsed by default). Never delete — only archive.

---

## 8  Validation Criteria

The plan is complete when:

- [x] `known-issues.instructions.md` exists with all 22 entries from §5
- [x] All ACTIVE issues have actionable Fix/Workaround descriptions
- [x] All FIXED issues have Verification commands that currently pass
- [x] `xaml-ui.instructions.md` contains `Registry:` links for all FATAL/WARN-HIGH entries
- [x] `debugger-architecture.instructions.md` audit findings replaced with registry links
- [x] `copilot-instructions.md` Quick Reference table includes crash pattern lookup row
- [x] Agent can answer "Is pattern X known?" by reading only the registry file (no multi-file search needed)

---

## Appendix A: Pending Debug Fixes (Complete Before Starting This Plan)

These 8 fixes from the current session must be applied first. All are debug/test code — no runtime crash pattern regressions.

| # | File | Change | Safe Against |
|---|---|---|---|
| 1 | `cba_debug_playerui_anim.scar` ~L1706 | `prevScore` → `lastScore` | No DataContext impact; internal state table |
| 2 | `cba_debug_playerui_anim.scar` ~L2237 | `prevScore` → `lastScore` | Same as above |
| 3 | `playerui_animate.scar` ~L760 | Add `pulse.lastScore ~= nil and` nil guard | Defensive; short-circuit skips comparison |
| 4 | `cba_debug_playerui_anim.scar` ~L1335 | Assertion `peak > 1.0` → `peak > 0 and peak < 1.0` | Test-only; matches runtime delta constant |
| 5 | `cba_debug_playerui_anim.scar` ~L1717 | Fix parabolic formula to `1.0 + peak * eased` | Test-only; aligns with runtime L1141 |
| 6 | `cba_debug_playerui.scar` ~L407 | Add `_PlayerUI_LastToggleTime = -1` before toggle | Test-only; resets to init value |
| 7 | `cba_debug_playerui_anim.scar` ~L1275 | pcall fallback for `Rule_IsPaused` unavailability | Test-only; graceful degradation |
| 8 | `cba_debug_playerui_anim.scar` ~L1671 | Add `or _PlayerUI_RankTransitionLock` tolerance | Test-only; matches T1.6 pattern |

**Verification after all 8 fixes:**
1. `debug.playerUI.run()` → 138/138 PASS
2. `debug.playerUI.stressTest(2.0)` → all 6 stages PASS
3. `debug.playerUI.animMonitor()` for 30+ seconds → no fatal, clean ticks
4. Toggle HUD 10+ times rapidly → no crash

---

## Appendix B: Scarlog Analysis (2026-04-20 14:13:38)

### Summary

| Metric | Value |
|---|---|
| Total lines | 2122 |
| PlayerUI suite | 46/47 PASS (1 FAIL: Hide HUD throttle) |
| PlayerUI_Anim suite | 88/91 PASS (3 FAIL: Rule_IsPaused, pulse constants, deferred queue) |
| Combined | 134/138 PASS |
| Stress test stages | All 6 PASS |
| Toggle throttle test | 10/10 ok, no crash |
| Reward validation | PASS — 47 clean ticks, 0 failed |
| Fatal error | `playerui_animate.scar:760: attempt to compare nil with number` — halted execution during reward playback after debug pulse seed corrupted `_PlayerUI_ScorePulse` entry |

### Failure Detail

| Line | Test | Output | Root Cause | Fix |
|---|---|---|---|---|
| 576 | Hide HUD (Toggle to collapsed) | `HudVisible=true` | Toggle throttle rejects call <0.3s after Show | Reset `_PlayerUI_LastToggleTime = -1` before test |
| 629 | Tick rule ↔ dirty flag consistency | `Rule_IsPaused error` | API unavailable in this SCAR version | pcall fallback: treat error as "skip" |
| 641 | Pulse constants valid | `decay=0.3 peak=0.12` | Assertion `peak > 1.0` wrong for delta constant | Change to `peak > 0 and peak < 1.0` |
| 776 | Deferred queue drained | `2 remaining` | Sync check before async `Rule_AddOneShot` completes | Allow non-zero when `_PlayerUI_RankTransitionLock` active |

### Non-Failure Observations

- **AGS_WARN spam (lines 365–403):** 40 warnings for `Player_SetEntityProductionAvailability skipped nil EntityBlueprint` — civ-specific buildings (mercenary_house, passive_trait_building, daimyo_estate_*) attempted for civs that don't have them. Not a crash risk; cosmetic log noise. Could be silenced with a BP existence check in `BuildingLimit_UnlockPlayer`.
- **AUTOAGE locked HA variants (lines 358–359, 410–411):** `chinese_ha_01` and `sultanate_ha_tug` show `locked=6/12` with 6 age/wonder upgrades failing. Expected behavior — HA variant age menus differ from base civs. `CBA_AutoAge_SetMaximumAge` handles this correctly.
- **Scarlog truncation (line 2122):** Log ends mid-sentence during reward playback. The fatal error at L760 halted SCAR execution before the engine flushed the write buffer.
