# Leaver Verification — Results Interpretation Guide

**Purpose:** Understand test outputs and make decisions based on results

---

## Test Output Interpretation

### LeaverVerify_AutoRunAll() Output

**Full PASS (Expected):**
```
[LEAVER_VERIFY] Hero behavior: 4 pass, 0 fail
[LEAVER_VERIFY]   unit_khan_ [chinese] → unit_horseman_ [✓ CORRECT POLICY]
[LEAVER_VERIFY]   unit_jeanne_ [french] → unit_knight_ [✓ CORRECT POLICY]
[LEAVER_VERIFY]   unit_abbey_king_ [english] → unit_manatarms_ [✓ CORRECT POLICY]
[LEAVER_VERIFY]   unit_wynguard_ [english] → DESTROY [✓ CORRECT POLICY]

[LEAVER_VERIFY] Elephant mapping: 2 pass, 0 fail
[LEAVER_VERIFY]   unit_war_elephant_ → unit_knight_ (ratio=0.3, tier=4) [✓ CORRECT]
[LEAVER_VERIFY]   unit_tower_elephant_ → unit_knight_ (ratio=0.3, tier=4) [✓ CORRECT]

[LEAVER_VERIFY] Military routes: 6 pass, 0 fail
[LEAVER_VERIFY]   Route direct (suffix swap) [✓ ACTIVE]
[LEAVER_VERIFY]   Route tier_bump (diff tier, same role) [✓ ACTIVE]
[LEAVER_VERIFY]   Route civ_unique_archetype (policy table) [✓ ACTIVE]
[LEAVER_VERIFY]   Route receiver_class (remap via class) [✓ ACTIVE]
[LEAVER_VERIFY]   Route generic_archetype (role lookup) [✓ ACTIVE]
[LEAVER_VERIFY]   Route destroy (no fallback) [✓ ACTIVE]

[LEAVER_VERIFY] Transfer-only classifier: ✓ PASS
[LEAVER_VERIFY]   Expected: gaia_*, herdable_*
[LEAVER_VERIFY]   Military transfer-only count: 0 [✓ CORRECT: None]

[LEAVER_VERIFY] Stats consistency: ✓ ALL CHECKS PASSED
[LEAVER_VERIFY]   Bucket exclusivity: 12/12 verify sum=total [✓ PASS]
[LEAVER_VERIFY]   Backward compat: mil_converted = sum(routes) [✓ PASS]
[LEAVER_VERIFY]   Backward compat: mil_killed = sum(destroys) [✓ PASS]
```

**Decision:** ✅ **PROCEED** — All systems nominal

---

### Partial FAIL (Investigate Required)

**Hero Test FAIL Example:**
```
[LEAVER_VERIFY] Hero behavior: 2 pass, 2 fail
[LEAVER_VERIFY]   unit_khan_ [chinese] → unit_horseman_ [✓ PASS]
[LEAVER_VERIFY]   unit_jeanne_ [french] → unit_manatarms_ [✗ FAIL: expected unit_knight_]
[LEAVER_VERIFY]   unit_abbey_king_ [english] → unit_manatarms_ [✓ PASS]
[LEAVER_VERIFY]   unit_wynguard_ [english] → DESTROY [✓ PASS]
```

**Action:**
1. **Stop** — Don't proceed with other tests
2. **Root cause:** Check cba.scar lines 1225–1230 (jeanne entry)
3. **Likely issue:** Jeanne policy target is wrong (should be `unit_knight_`, not `unit_manatarms_`)
4. **Fix:** Open cba.scar, find jeanne entry, verify target matches specification
5. **Retry:** Run `LeaverVerify_HeroBehavior()` again

**Specification Reference (Lines 1225–1230 in cba.scar):**
```scar
-- jeanne_* → knight (policy archetype)
["unit_jeanne_"] = {
    policy = "archetype",
    fallback_uuid = "unit_knight_",
    ratio = 1.0,
    tier = 3,
},
```

---

### Elephant Test FAIL Example

```
[LEAVER_VERIFY] Elephant mapping: 1 pass, 1 fail
[LEAVER_VERIFY]   unit_war_elephant_ → unit_knight_ (ratio=0.5, tier=4) [✗ FAIL: expected ratio=0.3]
[LEAVER_VERIFY]   unit_tower_elephant_ → unit_knight_ (ratio=0.3, tier=4) [✓ PASS]
```

**Action:**
1. **Root cause:** War elephant ratio is 0.5 instead of 0.3
2. **Check:** Lines 1256–1257 in cba.scar
3. **Fix:** Update ratio from 0.5 to 0.3
4. **Verify:** Both elephants should have ratio=0.3

**Specification Reference (Lines 1256–1260):**
```scar
-- Both elephants → knight (ratio 0.3, tier 4)
["unit_war_elephant_"] = {
    ...
    ratio = 0.3,  -- Changed from 0.5
    ...
},
["unit_tower_elephant_"] = {
    ...
    ratio = 0.3,  -- Changed from 0.5
    ...
},
```

---

### Military Routes Test FAIL Example

```
[LEAVER_VERIFY] Military routes: 2 pass, 4 fail
[LEAVER_VERIFY]   Route direct (suffix swap) [✓ ACTIVE]
[LEAVER_VERIFY]   Route tier_bump (diff tier, same role) [✗ INACTIVE]
[LEAVER_VERIFY]   Route civ_unique_archetype (policy table) [✗ INACTIVE]
[LEAVER_VERIFY]   Route receiver_class (remap via class) [✗ INACTIVE]
[LEAVER_VERIFY]   Route generic_archetype (role lookup) [✗ INACTIVE]
[LEAVER_VERIFY]   Route destroy (no fallback) [✓ ACTIVE]
```

**Action:**
1. **Root cause:** Mid-tier routes not activating — likely `_ResolveMilitaryRoute` function broken
2. **Check:** Function exists at cba.scar lines 1518–1568
3. **Debug:** Run `Debug_LeaverConversion_MilResolve(1, 2)` to get per-tier breakdown
4. **Look for errors:** Scarlog should show which tier is failing (watch for `[ERROR]` or `[WARN]` lines)

**Common reasons:**
- Function syntax error (parsing failed)
- `_ResolveGenericArchetypeFallback` not found (missing Tier 5)
- `_LEAVER_CANONICAL_ROLE` table missing (will cause Tier 5 FAIL, others may still work)

---

### Stats Consistency Test FAIL Example

```
[LEAVER_VERIFY] Stats consistency: ✗ FAIL
[LEAVER_VERIFY]   Bucket exclusivity: 9/12 verify sum=total [✗ FAIL: 45 squads but only 42 accounted]
[LEAVER_VERIFY]   Backward compat: mil_converted = sum(routes) [✗ FAIL: computed 25, bucket sum 23]
```

**Action:**
1. **Check:** Some statistics not being recorded to buckets
2. **Uncommon issue:** Usually means a code path bypasses stats increment
3. **Recovery:** Check lines 2555–2620 (military loop) for any Squad_SetPlayerOwner or Squad_Kill without incrementing stats

**Example problem code (WRONG):**
```scar
if some_condition then
    Squad_SetPlayerOwner(squad, dst_player)  -- ← Missing stats increment!
end
```

**Correct code:**
```scar
if route == "direct" then
    ml_stats.mil_direct = ml_stats.mil_direct + 1
    Squad_Create(..., squad, ...)
end
```

---

## Debug_LeaverConversion_MilResolve(src, dst) Output

**Expected output (routes working):**
```
[LEAVER_MIL_RESOLVE] P1→P2 military resolution summary
[LEAVER_MIL_RESOLVE] Direct suffix swap: 8 routes found (e.g., archer_2 → archer_2)
[LEAVER_MIL_RESOLVE] Tier-bump fallback: 5 routes found (e.g., archer_1 → archer_2)
[LEAVER_MIL_RESOLVE] Civ-unique archetype: 12 routes found (e.g., khan_3 → horseman_3)
[LEAVER_MIL_RESOLVE] Receiver-class remap: 3 routes found (e.g., manatarms → spearman)
[LEAVER_MIL_RESOLVE] Generic archetype: 6 routes found (e.g., crossbow → archer)
[LEAVER_MIL_RESOLVE] No resolve (destroy): 2 routes found (e.g., unique_siege)
```

**Interpretation:**
- ✓ All route types have counts > 0 → Healthy fallback chain
- ✓ Mix of routes → Good coverage
- ✓ Some destroy → Expected (unique units without fallbacks)

**Red flags:**
- ✗ All zeros except "Direct" → Tiers 2–5 broken
- ✗ All "destroy": No fallbacks working at all
- ✗ Transfer-only count > 0 in military section

---

## Debug_LeaverConversion_Stress(n) Output

**Expected output (3 disconnects):**
```
[LEAVER_TRANSFER] P1 eliminated
[LEAVER_XFER] unit_archer_2_eng [transfer] → P2 (dst_civ=french) | direct | mil_direct
[LEAVER_XFER] unit_khan_3_eng [transfer] → P2 (dst_civ=french) | civ_unique_archetype | mil_civ_unique_archetype
[LEAVER_XFER] unit_knight_4_eng [transfer] → P2 (dst_civ=french) | tier_bump | mil_tier_bump
... (more transfers)
[LEAVER_END] eng→fre | 0.45s | ent=120 sq=78 | bldg[...] eco[...] mil[conv=45 dest=8 same=0 xfer=0 | direct=15 bump=8 unique=15 class=4 generic=3 | d:pol=2 age=1 fail=3 nomap=2 ratio=0]

[LEAVER_TRANSFER] P2 eliminated
[LEAVER_XFER] ... (second transfer)
[LEAVER_END] fre→mal | ...

[LEAVER_TRANSFER] P3 eliminated
[LEAVER_XFER] ... (third transfer)
[LEAVER_END] mal→jap | ...
```

**Validation Checklist:**
- [ ] 3 `[LEAVER_TRANSFER]` events (one per disconnect)
- [ ] 3 `[LEAVER_END]` stats lines with route breakdown
- [ ] No `mil_transfer_only` in military section (xfer=0 expected)
- [ ] `conv + dest + same + xfer = total squares processed`
- [ ] Each run completes in < 1.0 second
- [ ] No `[ERROR]` or `[WARN]` spam in scarlog

**Example problem:**
```
[LEAVER_TRANSFER] P1 eliminated
[LEAVER_XFER] unit_archer_2_eng [transfer] → P2 (dst_civ=french) | no_route | mil_transfer_only
✗ FAIL: Military archer should never be transfer-only!
```
→ Debug `_Leaver_IsNeutralOrTransferOnlySquad()` classifier

---

## Debug_LeaverCoverage_AllCivPairs() Output

**Expected output:**
```
[COVERAGE] Testing all civ-pair combinations...
[COVERAGE] Testing eng→fre: 45/45 units resolved (coverage=1.0, quality=2.8)
[COVERAGE] Testing fre→mal: 52/52 units resolved (coverage=1.0, quality=2.5)
[COVERAGE] Testing mal→chi: 38/40 units attempted (coverage=0.95, quality=2.2)
... (more pairs)
[COVERAGE] Audit complete
[COVERAGE]   Total pairs tested: 382
[COVERAGE]   avg_coverage: 0.97
[COVERAGE]   avg_quality: 2.3/3.0
[COVERAGE]   identified_gaps: 7
```

**Quality Scale (units resolved per pair):**
- **3.0:** All military units have direct suffix match (perfect routing)
- **2.5–2.9:** Most units convert via direct or tier-bump (good)
- **2.0–2.4:** Some units require archetype fallback (acceptable)
- **1.5–1.9:** Heavy archetype/generic fallback dependency (risky)
- **< 1.5:** Many units destroyed due to no fallback (bad)

**Validation:**
- ✓ avg_quality ≥ 2.0 → Acceptable cross-civ balance
- ✓ gaps ≤ 10 → Minimal unreachable units
- ✗ avg_quality < 2.0 → Weak coverage; fallback tiers may need tuning
- ✗ gaps > 20 → Many orphaned units; consider adding to _LEAVER_CANONICAL_ROLE

---

## LEAVER_END Log Format Interpretation

**New format (post-refactor):**
```
[LEAVER_END] eng→fre | 0.42s | ent=120 sq=78 | bldg[res=15 stor=3 unres=2] eco[con=5 dest=1 xfer=0] mil[conv=45 dest=8 same=0 xfer=0 | direct=15 bump=8 unique=15 class=4 generic=3 | d:pol=2 age=1 fail=3 nomap=2 ratio=0]
```

### Section Breakdown

| Section | Meaning | Example |
|---------|---------|---------|
| `eng→fre` | Source civ → destination civ | Export from English to French |
| `0.42s` | Total transfer time | Should be < 1.0s |
| `sq=78` | Military squads processed | Major component of transfer |
| `mil[conv=45]` | **Converted** squads (all routes) | 45 squads became new units |
| `mil[dest=8]` | **Destroyed** squads (no fallback) | 8 squads killed; reasonable ratio |
| `mil[same=0]` | Same-BP exception transfers | 0 = different civs; 1+ = edge case |
| `mil[xfer=0]` | Transfer-only military | Should always be 0 in military! |
| `direct=15` | Direct suffix swap conversions | e.g., archer_2 → archer_2 |
| `bump=8` | Tier-bump conversions | e.g., archer_1 → archer_2 |
| `unique=15` | Civ-unique archetype conversions | e.g., khan_3 → horseman_3 |
| `class=4` | Receiver-class remap conversions | e.g., archer → crossbow |
| `generic=3` | Generic archetype conversions | e.g., crossbow → archer via role |
| `d:pol=2` | Destroyed via policy (wynguard, etc) | Expected; intended destroys |
| `d:age=1` | Destroyed due to age-gate block | Receiver civ can't build it yet |
| `d:fail=3` | Destroyed due to create-fail | Insufficient resources, pop cap |
| `d:nomap=2` | Destroyed due to unknown unit type | Shouldn't happen; debug artifact |
| `d:ratio=0` | Destroyed due to ratio skip | Very rare; casualty efficiency |

### Validation Rules

**Check:** `direct + bump + unique + class + generic ≠ conv`
- **If mismatch:** Stats accounting error
- **Action:** Run `LeaverVerify_StatsConsistency()`

**Check:** `conv + dest + same + xfer ≠ total_squads`
- **If mismatch:** Missing exception bucket
- **Action:** Check if transfer-only or same-BP military excluded

**Check:** `d:pol + d:age + d:fail + d:nomap + d:ratio ≠ dest`
- **If mismatch:** Unknown destroy reason
- **Action:** Might indicate code path outside destroy handling

**Example VALID line:**
```
mil[conv=50 dest=15 same=0 xfer=0 | direct=20 bump=15 unique=10 class=3 generic=2 | d:pol=5 age=3 fail=5 nomap=2 ratio=0]
```
→ Route sum: 20+15+10+3+2 = 50 ✓  
→ Destroy sum: 5+3+5+2+0 = 15 ✓  
→ Total: 50+15+0+0 = 65 ✓

**Example INVALID line (DON'T EXPECT THIS):**
```
mil[conv=50 dest=15 same=0 xfer=0 | direct=20 bump=15 unique=10 class=3 generic=1 | ...]
```
→ Route sum: 20+15+10+3+1 = 49 ✗  
→ Does not match conv=50 → BUG

---

## Decision Matrix: What to Do Based on Results

| Test | Result | Decision |
|------|--------|----------|
| AutoRunAll | ✓ ALL PASS | → Proceed to stress test (Debug_LeaverConversion_Stress) |
| AutoRunAll | ✗ Hero FAIL | → Fix cba.scar lines 1216–1240; re-verify |
| AutoRunAll | ✗ Elephant FAIL | → Fix cba.scar lines 1256–1257; re-verify |
| AutoRunAll | ✗ Route FAIL | → Check _ResolveMilitaryRoute function; syntax error likely |
| AutoRunAll | ✗ Stats FAIL | → Audit military loop for missing stat increments |
| MilResolve | ✓ All routes active | → Healthy fallback chain ✓ |
| MilResolve | ✗ No routes | → _ResolveMilitaryRoute broken or not called |
| Stress Test | ✓ 3 transfers complete | → Proceed to coverage audit |
| Stress Test | ✗ Hangs > 2s | → Infinite loop in _Leaver_ContinueTransfer |
| Stress Test | ✗ mil[xfer=1+] military | → Transfer-only classifier too broad; debug |
| Coverage | ✓ avg_quality ≥ 2.0 | → Ship to production ✓ |
| Coverage | ✗ avg_quality < 2.0 | → Tuning needed (add entries to _LEAVER_CANONICAL_ROLE) |
| Coverage | ✗ gaps > 10 | → Missing unit mappings; expand generic fallback tier |

---

## Troubleshooting Quicklinks

**Problem:** `[LEAVER_VERIFY] Hero behavior: 2 pass, 2 fail`
→ See [Hero Test FAIL Example](#hero-test-fail-example)

**Problem:** `[LEAVER_VERIFY] Elephant mapping: 1 pass, 1 fail`
→ See [Elephant Test FAIL Example](#elephant-test-fail-example)

**Problem:** `[LEAVER_VERIFY] Military routes: 1 pass, 5 fail`
→ See [Military Routes Test FAIL Example](#military-routes-test-fail-example)

**Problem:** `[LEAVER_VERIFY] Stats consistency: ✗ FAIL`
→ See [Stats Consistency Test FAIL Example](#stats-consistency-test-fail-example)

**Problem:** `[COVERAGE] avg_quality: 1.8/3.0`
→ See [Decision Matrix](#decision-matrix-what-to-do-based-on-results) (Coverage row)

**Problem:** Scarlog shows `[LEAVER_XFER] unit_archer_2 [transfer] ... mil_transfer_only`
→ Debug: Check `_Leaver_IsNeutralOrTransferOnlySquad(nil, "unit_archer_2")` is returning false

---

## Summary

**All PASS?** ✅ **Implementation is correct.** Ship to production.

**Some FAIL?** 🔍 **Use decision matrix to pick next action.** Most failures point to specific code locations.

**Hangs/Crashes?** ⚠️ **Infrastructure issue.** Check scarlog for [ERROR] or [WARN] before specific phase.

**Coverage low?** 📊 **Balance issue.** Expand generic archetype mappings in _LEAVER_CANONICAL_ROLE.
