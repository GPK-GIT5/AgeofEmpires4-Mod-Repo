---
name: "scar-debug"
description: "Diagnose and fix SCAR/Lua runtime errors in AoE4 mods. Use when: user reports nil errors, entity crashes, AI state machine failures, EventRule misfires, blueprint resolution failures, or production/building limit desyncs."
metadata:
  version: "1.0.0"
  author: "Copilot Skill: scar-debug"
  keywords: ["scar", "lua", "debug", "aoe4", "runtime-errors", "entity", "blueprint"]
---

# Skill: SCAR Debug

**Purpose:** Systematically diagnose and resolve SCAR/Lua runtime errors in AoE4 mod scripts.

**Input:** Error description, affected `.scar` file(s), reproduction steps (if available)
**Output:** Root cause diagnosis + targeted code fix

---

## Workflow

### Phase 1: Triage

1. Identify error category from description:
   - **Nil reference** — variable/function undefined or out of scope
   - **Entity crash** — invalid Entity/EGroup handle (despawned, transferred, nil)
   - **Blueprint failure** — `BP_GetEntityBlueprint` returns nil (wrong attribName, DLC variant)
   - **EventRule misfire** — callback not triggering, wrong scope, stale reference
   - **State desync** — counters/limits out of sync after ownership transfer or disconnect
   - **UI crash** — XamlPresenter fatal patterns (Width/Height/Opacity binding, MergedDictionaries + local resources)
2. Read the reported error context (file + surrounding lines)
3. Check if error is in lifecycle init vs runtime callback

### Phase 2: Diagnosis

1. **Scope check:** Verify variable scope — SCAR has no `local` file scope; all non-local are globals
2. **Nil trace:** For nil errors, trace the variable back to its assignment; check:
   - `World_GetPlayerAt()` slot indexing (0-based)
   - `Player_GetEntities()` / `Player_GetSquads()` returning empty groups
   - Blueprint lookup returning nil (civ variant mismatch, DLC coverage gap)
3. **Entity validity:** For entity crashes, check:
   - `Entity_IsValid()` / `Entity_IsAlive()` guards before operations
   - Ownership transfer via `Entity_SetPlayerOwner` (counters don't auto-update)
   - Entity despawn between event fire and callback execution
4. **EventRule audit:** For event misfires, verify:
   - Correct scope: `Rule_AddGlobalEvent` vs `EventRule_AddPlayerEvent` vs `EventRule_AddEntityEvent`
   - Context fields match event type (see `references/api/game-events.md`)
   - Callback not removed prematurely by `Rule_RemoveMe()` in shared handler
5. **Blueprint resolution:** For BP failures, check:
   - `AGS_ENTITY_TABLE[player_civ][bp_type]` — each civ (including DLC variants) has its own full entry
   - `AGS_GetCivilizationEntity(player_civ, bp_type)` wraps `BP_GetEntityBlueprint(AGS_ENTITY_TABLE[player_civ][bp_type])`
   - Exact attribName string (no typos, correct civ suffix)
6. **Civ variant patterns:**
   - Direct `player_civ ==` comparison for civ-specific checks (no parent map exists)
   - Each DLC variant (chinese_ha_01, french_ha_01, abbasid_ha_01, hre_ha_01, japanese, byzantine) has its own AGS_ENTITY_TABLE entry
   - Landmark exclusion: `Entity_IsEBPOfType(eid, "landmark")` — universal, no per-civ checks needed

### Phase 3: Fix

1. Apply minimal targeted fix to root cause
2. Add entity validity guard only if the entity handle can legitimately be invalid at call site
3. Verify fix doesn't break DLC variant coverage
4. If fix involves counters/limits, ensure recount functions are called after state changes

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
