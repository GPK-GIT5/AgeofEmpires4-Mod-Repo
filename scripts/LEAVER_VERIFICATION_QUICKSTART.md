# Quick Execution Guide — Leaver Verification

**Run this after loading Onslaught mod with latest cba.scar**

---

## Step 1: Enable Debug Mode (1 minute)

In-game console (F10):

```
_LEAVER_DEBUG_VERBOSE = true
_LEAVER_DEBUG_BYPASS_GATES = true
```

---

## Step 2: Run Auto Verification (2 minutes)

**One command, does 5 full tests:**

```
LeaverVerify_AutoRunAll()
```

**Expected output in scarlog:**
```
[LEAVER_VERIFY] Hero behavior: 4 pass, 0 fail
[LEAVER_VERIFY] Elephant mapping: 2 pass, 0 fail  
[LEAVER_VERIFY] Military routes: 6 pass, 0 fail
[LEAVER_VERIFY] Transfer-only classifier: ✓ PASS
[LEAVER_VERIFY] Stats consistency: ✓ ALL CHECKS PASSED
```

**If ALL PASS → Continue to Step 3**  
**If ANY FAIL → STOP, investigate specific failure**

---

## Step 3: Military Route Details (1 minute)

Run these 3 in order:

```
Debug_LeaverConversion_MilResolve(1, 2)
Debug_LeaverConversion_MilResolve(2, 3)
Debug_LeaverConversion_MilResolve(1, 4)
```

**Check scarlog for routes in use:**
- `direct` (suffix swap)
- `tier_bump` (different tier, same role)
- `civ_unique_archetype` (policy table fallback)
- `receiver_class` (remap via class alias)
- `generic_archetype` (role-based lookup)
- `destroy` (no fallback exists)

**Expected:** Mix of all routes, NO transfers.

---

## Step 4: Stress Test — Disconnect Players (5 minutes)

In-game, trigger leaver pipeline by disconnecting 2–3 players sequentially:

```
Debug_LeaverConversion_Stress(3)
```

**Or manually:**
1. Exit as Player 1 (or use console to boot)
2. Wait for transfer (watch scarlog for `[LEAVER_*]` spam)
3. Once complete, exit as Player 2
4. Wait for transfer
5. Once complete, exit as Player 3

**Scarlog should show 3 `[LEAVER_END]` lines, one per disconnect.**

**Check format:**
```
[LEAVER_END] eng→fre | direct=15 tier_bump=8 unique=5 class=0 generic=2 | d:policy=1 age=0 fail=0 nomap=0 ratio=0
```

**Validate:**  
✓ All convert counts > 0  
✓ All destroy counts make sense  
✓ No hangs, completes in <1s per exit

---

## Step 5: Coverage Audit (10 minutes, optional)

Tests all 400+ civ-pair combinations:

```
Debug_LeaverCoverage_AllCivPairs()
```

**Expected:**
```
[COVERAGE] All civ-pairs: 382 tested
[COVERAGE] avg_quality: 2.3/3.0
[COVERAGE] gaps: 3
```

**Validation:** Quality ≥ 2.0, gaps ≤ 5

---

## Step 6: Review Full Logs

**File location:**
```
%USERPROFILE%\Documents\My Games\Age of Empires IV\LogFiles\<YYYY-MM-DD>\scarlog_*.txt
```

**Search for:**
- `[LEAVER_VERIFY]` — Test results
- `[LEAVER_XFER]` — Per-squad outcomes (should show routes, never transfers except gaia)
- `[LEAVER_END]` — Final aggregate stats

**Red flags to look for:**
- ✗ `[LEAVER_XFER] <military_unit> [transfer-only]` — FAIL
- ✗ No `[LEAVER_VERIFY]` lines — Module didn't run
- ✗ `direct=0 bump=0 unique=0 class=0 generic=0` — No routes working

---

## Decision Tree

| Observation | Meaning | Action |
|---|---|---|
| All PASS in Step 2 | ✓ Implementation correct | **PROCEED TO PRODUCTION** |
| Hero test FAIL | ✗ Policy not applied | Check cba.scar lines 1216–1240 |
| Elephant FAIL | ✗ Ratio wrong | Check cba.scar lines 1256–1257 |
| Routes all "destroy" | ⚠ Age gate block? | Rerun with bypass gates enabled |
| Stats don't sum | ⚠ Accounting error | Run `LeaverVerify_StatsConsistency()` |
| Stress test hangs | ✗ Infinite loop | Enable `_LEAVER_DEBUG_FRAME_STEP` for per-frame trace |

---

## Summary

**Total time: ~30 minutes**

- 2m: Setup
- 2m: Auto verify
- 1m: Route details
- 5m: Stress test
- 10m: Coverage (optional)
- 10m: Log review

**Output:** `leaver_verification_report_<DATE>.txt` in `%TEMP%` or alongside scarlog

**Next:** If all PASS, proceed to Step 8 (Eco classifier audit) or Step 10 (Documentation)
