---
name: "SCAR Event Handler"
description: "Generate a SCAR event handler with proper EventRule registration, context field access, and cleanup."
---

# SCAR Event Handler

Generate a SCAR event callback for AoE4 modding.

## Parameters

- **Event**: Which game event? (e.g., `GE_EntityKilled`, `GE_ConstructionComplete`, `GE_UpgradeComplete`)
- **Scope**: Global, per-player, per-entity, or per-squad?
- **Purpose**: What should the callback do?
- **Mod**: Which mod is this for? (check existing patterns in that mod's `.scar` files)

## Instructions

1. Look up the event in `references/api/game-events.md` to confirm context fields
2. Use the narrowest EventRule scope that fits:
   - `Rule_AddGlobalEvent(callback, GE_Event)` — all objects
   - `EventRule_AddPlayerEvent(callback, player, GE_Event)` — one player
   - `EventRule_AddEntityEvent(callback, entity, GE_Event)` — one entity
   - `EventRule_AddSquadEvent(callback, squad, GE_Event)` — one squad
3. Name the callback per convention: `Context_Rule_Action()` (e.g., `Phase1_Base_Rule_OnBuildingComplete`)
4. Access context fields with `context.fieldName` — only use fields documented for that event
5. Add entity/squad validity guards if handles might be stale
6. Include cleanup: `Rule_RemoveMe()` for one-shot, or paired `Rule_RemoveGlobalEvent()` for explicit removal
7. Follow coding standards in `.github/instructions/coding/scar-coding.instructions.md`

## Template

```lua
-- Register (in init function)
Rule_AddGlobalEvent({{callbackName}}, {{GE_EVENT}})

-- Callback
function {{callbackName}}(context)
    -- Extract context fields (verified against game-events.md)
    local entity = context.entity
    local player = context.player

    -- Guard: verify entity still valid
    if not Entity_IsValid(entity) then
        return
    end

    -- TODO: Implement handler logic

end
```

## Checklist

- [ ] Event constant exists in `references/api/game-events.md`
- [ ] Context fields match event documentation
- [ ] Scope is narrowest possible
- [ ] Callback naming follows `Context_Rule_Action` convention
- [ ] Entity/squad validity checked before use
- [ ] Cleanup mechanism defined (one-shot or explicit removal)
