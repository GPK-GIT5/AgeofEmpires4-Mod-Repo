---
applyTo: "**/*.scar"
---

# SCAR Event Rules — AoE4

Event-driven programming patterns for SCAR scripting. Auto-loaded for all `.scar` files.

## EventRule Scope Hierarchy

Use the narrowest scope that fits. Narrower = better performance, fewer false triggers.

| Scope | Registration | Fires When |
|-------|-------------|------------|
| Global | `Rule_AddGlobalEvent(cb, GE)` | Any object, any player |
| Player | `EventRule_AddPlayerEvent(cb, player, GE)` | That player's objects only |
| Entity | `EventRule_AddEntityEvent(cb, entity, GE)` | That specific entity only |
| Squad | `EventRule_AddSquadEvent(cb, squad, GE)` | That specific squad only |

### Data Variants

Pass custom data to callbacks using `*Data` variants:

```lua
EventRule_AddPlayerEventData(callback, player, GE_Event, {custom_key = value})
```

The data table merges into the callback's `context` parameter.

## Context Fields

Each event provides specific fields in `context`. **Only access documented fields** — see `references/api/game-events.md`.

Common patterns:
- `GE_EntityKilled` → `context.victim`, `context.killer`, `context.victimOwner`
- `GE_ConstructionComplete` → `context.entity`, `context.player`
- `GE_UpgradeComplete` → `context.player`, `context.upgrade`
- `GE_BuildItemComplete` → `context.entity`, `context.player`, `context.squad`
- `GE_EntityOwnerChange` → `context.entity`, `context.prevOwner`, `context.newOwner`

## Callback Naming

Follow `Context_Rule_Action` convention:

```lua
Phase1_Base_Rule_OnBuildingComplete(context)
CBA_Options_Rule_OnEntityKilled(context)
Spawns_Wave_Rule_OnTimerExpired(context)
```

## Interval & Timer Rules

```lua
Rule_AddInterval(callback, seconds)   -- repeating
Rule_AddOneShot(callback, delay)      -- fire once after delay
Rule_RemoveMe()                       -- remove self from inside callback
```

## Common Pitfalls

1. **Stale entity handles** — Entity may be destroyed between event fire and callback. Always check `Entity_IsValid(entity)` before operations.
2. **Wrong scope** — `Rule_AddGlobalEvent` fires for ALL players. Use `EventRule_AddPlayerEvent` when monitoring one player's events.
3. **Missing cleanup** — Forgetting `Rule_RemoveMe()` in one-shot handlers causes repeated execution. Forgetting paired `Rule_RemoveGlobalEvent` causes memory leaks.
4. **Ownership transfer blind spot** — `Entity_SetPlayerOwner` does NOT fire `GE_ConstructionComplete` or `GE_ConstructionStart`. Counter systems must recount manually after transfers.
5. **EventRule on dead entity** — Registering `EventRule_AddEntityEvent` on a destroyed entity is silently ignored. Verify entity validity before registration.
6. **Context field assumptions** — Not all events populate all fields. Accessing an undocumented field returns nil without error.
