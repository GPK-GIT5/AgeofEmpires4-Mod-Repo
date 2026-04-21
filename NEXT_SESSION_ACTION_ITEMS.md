# 🎯 NEXT SESSION ACTION ITEMS — Determinism Fix Validation

**Status**: Phase Next-3 COMPLETE — Ready for validation testing  
**Date**: 2026-03-30  
**File Modified**: Gamemodes/Onslaught/assets/scar/playerui/playerui_ranking.scar  
**Compilation**: ✅ Zero errors (validated with get_errors)

---

## TL;DR: What Changed

| Issue | Fix | Test Command |
|-------|-----|--------------|
| Force-wait-audit shows stale glow after expiry | Added fresh `PlayerUI_Ranking_Update()` call + PRE/POST snapshots before/after | `PlayerUI_Debug_ForceWaitAudit("up3", 3.0)` |
| TestStability can't detect contested (gap too large) | Scenario [4]: scores (50,60) → (180,185), gap now 10 vs threshold 15 | `PlayerUI_Debug_TestStability()` |

**Expected Validation Outcome**:
- PRE_RECOMPUTE snapshot: `glow=0.90, pUp=true` (stale force state)
- POST_RECOMPUTE snapshot: `glow=0.00, pUp=false` (force cleared by update)
- TestStability [4]: `contested=true` (gap=10 < threshold=15)

---

## Validation Checklist for Next Session

Run these 3 console commands and verify outputs:

### ✅ Test 1: Force Determinism
```lua
PlayerUI_Debug_ForceWaitAudit("up3", 3.0)
```
**Check scarlog for**:
- [ ] PRE_RECOMPUTE: glow=0.90
- [ ] POST_RECOMPUTE: glow=0.00
- [ ] Transition happens in single command output
- [ ] Re-running produces identical output

### ✅ Test 2: Contested Detection
```lua
PlayerUI_Debug_TestStability()
```
**Check scarlog for**:
- [ ] Entry [4]: score 50→185, stable 50→180
- [ ] Entry [4]: contested=true
- [ ] Entry [4] comment: "gap=10 < threshold=15"
- [ ] Entry [3]: stable=190 (blocked by cooldown)

### ✅ Test 3: System Status
```lua
PlayerUI_Debug_SystemStatus()
```
**Check scarlog for**:
- [ ] forced=0 (no entries in force window)
- [ ] No entries showing both pUp=true and force=0.0

---

## Detailed Documentation

For comprehensive technical details, see:
- **Full Summary**: [`changelog/2026-03-30_DETERMINISM_FIX_SUMMARY.md`](changelog/2026-03-30_DETERMINISM_FIX_SUMMARY.md)
- **Session Notes**: `/memories/session/phase-next-3-determinism-fix.md`
- **Quick Reference**: `/memories/session/validation-quick-reference.md`

---

## Code Changes Summary

```diff
File: Gamemodes/Onslaught/assets/scar/playerui/playerui_ranking.scar

-- Lines 1746-1759: _PlayerUI_Debug_FWA_DeferredAudit()
-  PlayerUI_Debug_PredictionSnapshot(tag, 0)
+  PlayerUI_Debug_PredictionSnapshot(tag .. "_PRE_RECOMPUTE", 0)
+  PlayerUI_Ranking_Update()
+  PlayerUI_Debug_PredictionSnapshot(tag .. "_POST_RECOMPUTE", 0)

-- Lines 2033-2036: TestStability scenario
-  stableScores = { 300, 200, 190, 50 }
+  stableScores = { 300, 200, 190, 180 }
-  rawScores = { 300, 250, 195, 60 }
+  rawScores = { 300, 250, 195, 185 }

-- Lines 2087: Expected text
-  print("[STABILITY_TEST]   [4] contested=true (within threshold of [3] after [3] stays)")
+  print("[STABILITY_TEST]   [4] contested=true (gap=10 < threshold=15, within [3] after [3] locked)")
```

---

## What Still Needs Testing

1. **Glow latching fix actual behavior** — PRE/POST snapshots will confirm whether glow reset is firing
2. **Determinism across repeated runs** — Run same command 3× to verify consistent output
3. **Integration with XAML UI** — Confirm glows actually disappear in UI (not just in debug output)

---

## If Validation Fails

See "Risk Assessment" section in `changelog/2026-03-30_DETERMINISM_FIX_SUMMARY.md` for mitigation steps.

**Red flags and solutions**:
- PRE + POST both show glow=0.90 → fresh update not clearing force flag, check WriteFieldsToSlots
- PRE shows forceRem>0.0 → force window didn't fully expire, increase test wait time
- TestStability [4] shows contested=false → scenario not updated, verify lines 2033-2036

---

## Next Phase: Phase Next-4

Once validation passes, proceed to full integration:
- Remove debug force tools from production
- Test arrow pipeline with real ranking updates (not debug-forced)
- Verify FLIP animation doesn't break arrow visibility
- Stress test with eliminated players, rapid changes

---

**Quick Links**:
- 📋 Full Summary: [`2026-03-30_DETERMINISM_FIX_SUMMARY.md`](changelog/2026-03-30_DETERMINISM_FIX_SUMMARY.md)
- 🔍 Session Notes: View `/memories/session/` directory
- ⚡ Quick Ref: `/memories/session/validation-quick-reference.md`

**Last Validated**: 2026-03-30 (compilation: ✅ zero errors)
