---
applyTo: "**/cba_options.scar,**/cba.scar,**/cba_rewards.scar,**/cba_siege_data.scar"
---

# Siege Limit System — Onslaught

## Architecture

All siege gating flows through a centralized **Recount → ApplyThreshold** pipeline. No event handler should lock/unlock production items directly.

```
Event (BuildItemComplete / SquadKilled / ConstructionStart / ConstructionCancelled)
  → CBA_Options_SiegeLimit_Recount(player)
  → CBA_Options_SiegeLimit_ApplyThreshold(player)
  → CBA_Options_FieldConstruct_Gate(player)   -- MUST run last
```

## Core Functions (cba_options.scar)

| Function | Line | Purpose |
|----------|------|---------|
| `CBA_Options_SiegeLimit_Recount` | ~L875 | Scans live squads, derives siege count. Excludes rams and siege towers. |
| `CBA_Options_SiegeLimit_ApplyThreshold` | ~L917 | Cascading lock/unlock with `>=` thresholds. |
| `CBA_Options_RamLimit_ApplyThreshold` | ~L1285 | Separate ram threshold. |
| `CBA_Options_SiegeTowerLimit_ApplyThreshold` | ~L1296 | Separate siege tower threshold. |
| `CBA_Options_FieldConstruct_Gate` | ~L1189 | Overrides cascade unlocks for civs without `AGS_UP_SIEGE_ENGINEERS`. Must run AFTER all `ApplyThreshold` calls. |
| `CBA_Options_RevalidateAll` | ~L1157 | Calls all recount + threshold + gate functions for a player. |

## Rules

1. **Bidirectional thresholds** — Every `ApplyThreshold` function MUST have both lock AND unlock branches. A lock-only function causes permanent production locks.

2. **FieldConstruct_Gate ordering** — `FieldConstruct_Gate` MUST run AFTER `SiegeLimit_ApplyThreshold` in every code path. It overrides cascade unlocks for civs that lack `AGS_UP_SIEGE_ENGINEERS`.

3. **Use RevalidateAll for multi-system changes** — When granting upgrades that affect multiple limit systems (e.g., Siege Engineers reward), call `CBA_Options_RevalidateAll(player)`, not individual threshold functions.

4. **Rams and siege towers are decoupled** — They have their own separate Recount/ApplyThreshold functions and are excluded from the main siege count.

5. **No inline lock/unlock** — Event handlers must NOT call `Player_SetEntityProductionAvailability` directly. Always go through the Recount → ApplyThreshold pipeline.

## CBA_SIEGE_TABLE (cba_siege_data.scar)

- Knights DLC civs (`abbasid_ha_01`, `chinese_ha_01`, `french_ha_01`, `hre_ha_01`) require `_ha_01` suffix on unit blueprint strings.
- Dynasties DLC civs (`mongol_ha_gol`, `lancaster`, `templar`, etc.) use `AGS_CIV_PARENT_MAP` fallback — no separate siege table entries needed.

## Point Values

| Unit | Points |
|------|--------|
| Springald | 1 |
| Trebuchet (TR) / Culverin | 2 |
| Mangonel / Trebuchet (CW) / Cannon / Bombard / Nest of Bees / Ribauldequin | 3 |
| Ottoman Great Bombard | 4 |
| Ram / Siege Tower | Separate limit (not counted in main siege total) |

## Pending Counter Invariants

1. **ConstructionStart must NOT call `RamLimit_Recount` or `SiegeTowerLimit_Recount`** — their self-correction resets pending to the current scaffold count in the entity list. When multiple constructions fire in the same tick, the new scaffolds haven't materialized yet, so pending resets to 0 before each increment and never exceeds 1.
2. **ConstructionComplete/Cancelled must NOT manually decrement pending** — recount self-correction rebuilds pending from ground truth (live scaffolds). Manual decrement + self-correction = double-decrement.
3. **`ram_tower` counts as weight=2** in all paths: recount entity loop, recount squad loop, ConstructionStart pending increment, and Disable lock/unlock.
