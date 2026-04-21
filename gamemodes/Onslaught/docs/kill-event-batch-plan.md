# Kill Event Batch Processing — Implementation Plan

## Architecture Overview

Two global event types (`GE_SquadKilled`, `GE_EntityKilled`) previously fired synchronously to all registered handlers per kill. The batch system replaces direct event handler registrations with a single capture handler per event type that snapshots context and queues entries for 1-second batch processing.

**Infrastructure location:** `cba_options.scar` — `_CBA_SQUAD_KILL_BATCH`, `_CBA_ENTITY_KILL_BATCH`

---

## Completed: GE_SquadKilled Batch (All 5 Handlers)

**Dispatch: 5 → 1 per event**

| Handler | File | Context Snapshot |
|---------|------|-----------------|
| `CBA_Options_SiegeLimit_SquadKilled` | cba_options.scar | Siege classification (cached) |
| `_BL_OnSquadKilled` | cba_debug_battle_lag.scar | Owner ID |
| `AGS_LimitsUI_OnSquadKilled` | ags_limits_ui.scar | None (DeferUpdate) |
| `AGS_SpecialPopulationUI_OnSquadKilled` | ags_special_population_ui.scar | None (DeferUpdate) |
| `_OnSquadKilledRule` | tracking_squadlosses.scar | Worker/military flags |

## Completed: GE_EntityKilled Phase 1 — Context-Free (4 of 15 Handlers)

**Dispatch: 15 → 12 per event**

| Handler | File | Context Snapshot | Notes |
|---------|------|-----------------|-------|
| `_BL_OnEntityKilled` | cba_debug_battle_lag.scar | Owner ID | Via `_BL_BatchEntityKilled` wrapper |
| `AGS_LimitsUI_OnEntityKilled` | ags_limits_ui.scar | None | DeferUpdate only |
| `AGS_SpecialPopulationUI_OnEntityKilled` | ags_special_population_ui.scar | None | DeferUpdate only |
| `_AI_OnEntityKilled` | cba_ai_player.scar | Entity handle + owner | Synthetic context → original handler |

---

## Completed: Entity Property Snapshot Migration (Phase 2 — 4 Handlers)

**Objective:** Migrated 4 handlers that access entity properties at event time. Extended `CBA_EntityKillBatch_Capture` to snapshot entity state (type flags, blueprint, progress, owner) while the entity is still valid. Wonder_OnEntityKilled deferred to Phase 3 (requires `context.killer`).

**Dispatch: 12 → 8 per event**

**Dependencies:**
- Phase 1 complete (entity batch infrastructure exists) ✅

**Handlers:**

| Handler | File | Snapshot Fields | Status |
|---------|------|-----------------|--------|
| `AGS_AutoPop_OnEntityKilled` | ags_auto_population.scar | `is_building`, `Entity_GetBlueprint` (ebp), player resolution | ✅ Batched |
| `CBA_Options_SiegeLimit_EntityKilled` | cba_options.scar | `IsSiegeEntityCached`, siege sub-types (ram/rt/st), `Entity_GetBuildingProgress`, `GetSiegeWeaponPointsEntity`, player resolution | ✅ Batched |
| `CBA_Options_BuildingLimit_OnEntityKilled` | cba_options.scar | `Entity_GetID`, `IsProductionCapBuildingByEntity`, `IsWorkshopCapBuilding`, `is_outpost`, `is_stone_wall_tower`, player resolution + age | ✅ Batched |
| `AGS_DockHouse_OnEntityKilled` | ags_siege_house.scar | `Entity_GetBuildingProgress`, `AGS_DockHouse_IsDock`, player resolution | ✅ Batched |

**Snapshot struct:**
```lua
{ victim, victim_owner, entity_id, owner_pid, player, player_idx, player_civ, branch_civ, age,
  progress, is_finished, is_building, ebp, is_siege, is_ram_type, is_rt_type, is_st_type,
  siege_points, is_prod, is_workshop, is_outpost, is_stone_wall_tower, is_dock }
```

**Registration pattern:** Direct `Rule_AddGlobalEvent(handler, GE_EntityKilled)` replaced with `CBA_EntityKillBatch_SetHandler(key, true/false)` at the same lifecycle points.

**Consolidation:** Siege threshold application consolidated per dirty-player per batch. AutoPop reconcile coalesced (one-shot per batch). UI updates via existing `AGS_LimitsUI_DeferUpdate`.

---

## Phase 3: Killer Entity Snapshot Migration

**Objective:** Migrate Wonder + 2 rewards handlers that access `context.killer`. Requires snapshotting killer entity properties (which may also be dead by batch time).

**Dispatch: 8 → 5 per event**

**Dependencies:**
- Phase 2 complete (entity snapshot infrastructure exists)
- Rewards handler audit: both `rewards.scar` and `cba_rewards.scar` versions must be validated

**Handlers:**

| Handler | File | Required Killer Snapshot |
|---------|------|------------------------|
| `Wonder_OnEntityKilled` | wonder.scar | `Entity_GetPlayerOwner(context.killer)`, self-destruct check (`killer == victim`), victim type/progress/position/ID |
| `CBA_Rewards_OnEntityKilled` | rewards.scar | `context.killer.EntityID`, `Entity_FromID(killer)`, killer type flags |
| `CBA_Rewards_OnEntityKilled` | rewards/cba_rewards.scar | Same + killer owner validation |

**Deliverables:**
1. Extended snapshot with killer entity fields: `{ killer_entity_id, killer_owner, killer_type_flags, is_self_destruct }`
2. Refactored Wonder + rewards handlers to use snapshot — no `Entity_GetPlayerOwner(killer)` or `Entity_FromID(killer.EntityID)` at batch time
3. Runtime validation: reward gold/resources still awarded correctly on kills; wonder event cues fire with correct attacker info

**Risk: High** — Killer entity may be transferred/dead between capture and batch. All reward-decision inputs must be captured at event time. Incorrect snapshot could cause wrong reward amounts. Wonder event cues are cosmetic but should reference correct attacker player.

---

## Always Immediate (4 Handlers — Never Batched)

These handlers trigger victory/defeat state changes and MUST remain synchronous:

| Handler | File | Reason |
|---------|------|--------|
| `Mod_OnEntityKilled` | cba.scar | Calls `Core_SetPlayerDefeated`, `Core_SetPlayerVictorious` |
| `Annihilation_OnEntityKilled` | cba_annihilation.scar | Calls `Core_SetPlayerDefeated` with WR_ANNIHILATION |
| `AGS_Annihilation_OnEntityKilled` | ags_annihilation.scar | Calls `AGS_SetPlayerDefeated` with WR_ANNIHILATION |
| `AGS_Wonder_OnEntityKilled` | ags_wonder.scar | Conditionally calls `AGS_SetPlayerDefeated` (LastStand mode) |

**1-second deferral would cause visible game-state lag before defeat/victory screens.**

---

## Testing Console Commands

### Batch System Health

| Step | Command | Validates | Expected Output |
|------|---------|-----------|-----------------|
| 1 | `Debug_SiegePerfReset()` | Resets all perf counters + both batch queues | `[DEBUG] _CBA_PERF counters + siege cache + batch queues reset at tick N` |
| 2 | `Debug_SiegePerfReport()` | Verifies counters initialized to zero | Line 3: `batch_sq=0/0  batch_ek=0/0  sq_pending=0  ek_pending=0` |
| 3 | *(play 3–5 min with combat)* | — | — |
| 4 | `Debug_SiegePerfReport()` | Batch processing active for both kill types | `batch_sq>0` and `batch_ek>0`, `batch_sq_ticks>0` and `batch_ek_ticks>0` |

### Siege Limit Correctness

| Step | Command | Validates | Expected Output |
|------|---------|-----------|-----------------|
| 1 | `Debug_SiegeStatus()` | Current siege/ram/ST counts per player | Counts match observed live units |
| 2 | *(destroy siege units)* | — | — |
| 3 | `Debug_SiegeStatus()` | Counts decrease within 2s of batch + deferred recheck | Counts match after units are dead |
| 4 | `Debug_RecountValidate()` | No drift between incremental and full recount | `RecountValidate OK` for all players |

### AI Building Rebuild

| Step | Command | Validates | Expected Output |
|------|---------|-----------|-----------------|
| 1 | *(destroy AI building)* | AI rebuild detection fires from batch processor | `[AI_PLAYER] P? lost barracks - will rebuild.` in scarlog (within 1–2s) |

### Battle Lag Harness

| Step | Command | Validates | Expected Output |
|------|---------|-----------|-----------------|
| 1 | `Debug_BattleLagTest()` | Harness starts, batch handlers activated | `[BATTLE_LAG] observe → start` |
| 2 | *(wait 60s of combat)* | — | — |
| 3 | `Debug_BattleLagStatus()` | Entity + squad kill events recorded via batch | `GE_EntityKilled` and `GE_SquadKilled` event counts > 0 |
| 4 | `Debug_BattleLagStop()` | Harness stops, batch handlers deactivated | `[BATTLE_LAG] finalize` |

### Victory/Defeat (Regression Check)

| Step | Action | Validates | Expected |
|------|--------|-----------|----------|
| 1 | Destroy all player buildings/units | Annihilation fires immediately (not batched) | Defeat screen within 1 frame |
| 2 | Destroy keep | Keep-loss fires immediately (Mod_OnEntityKilled) | Defeat screen within 1 frame |
| 3 | Destroy wonder | Wonder destruction fires immediately | Defeat if LastStand enabled |

### Observer UI (Regression Check)

| Step | Action | Validates | Expected |
|------|--------|-----------|----------|
| 1 | Kill worker squads in combat | Worker loss counter increments | Observer stats show updated worker losses within 1–2s |
| 2 | Kill military squads in combat | Military loss counter increments | Observer stats show updated military losses within 1–2s |
