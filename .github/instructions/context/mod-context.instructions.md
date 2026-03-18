---
applyTo: "Scenarios/**,references/mods/**"
---

# Mod Context & Navigation — AoE4 Workspace

## Index-First Principle

Always read the mod's index file before exploratory .scar file reads. Indexes provide function catalogs, objective chains, blueprint tables, and architecture overviews at 35-60% lower token cost.

## Japan Scenario (`Scenarios/Japan/`)

**Index:** `references/mods/MOD-INDEX.md` — 4-player co-op · 5,097 lines · 5 .scar files

**Navigation by task:**

| Task | Start Here |
|------|-----------|
| Quick overview | `references/mods/MOD-INDEX.md` Quick Start section |
| Function signature | `references/mods/japan_reference/japan-guide-api-reference.md` |
| Adding a restriction | `references/mods/japan_reference/japan-stage4-restriction.md` |
| Exploring stages | `references/mods/japan_reference/japan-checkpoint-index.md` |
| DLC civ internals | `references/mods/japan_reference/japan-stage1-summary.md` |
| Restriction audit | `references/mods/japan_reference/japan-stage4-restriction.md` |

**Important:** Always use `references/mods/MOD-INDEX.md`, never `Scenarios/Japan/MOD-INDEX.md` (Scenarios Folder Scope rule).

## Arabia Scenario (`Scenarios/Arabia/`)

**Index:** `references/mods/arabia-mod-index.md` — 2-player co-op · 2,035 lines · 4 .scar files

**Use when:**
- Adding civilization support to AGS_ENTITY_TABLE
- Understanding difficulty scaling (Easy/Intermediate/Hard/Hardest)
- Modifying objective chain logic
- Debugging reinforcement spawn mechanics

**Key differences from Japan:**
- 2-player vs. 4-player co-op
- Timed countdown (45-80 min) vs. phase-based progression
- Supports vanilla + 4 DLC civs
- Threshold-based reinforcements (30% depletion) vs. scripted waves
- Uses `AGS_GetCivilizationEntity()` helper

## Common Patterns

**Condensed objectives fix** — use `UI_SetPlayerDataContext` override:
```lua
for _, player in pairs(PLAYERS) do
    UI_SetPlayerDataContext(player.id, {hide_condensed_objectives_override = true})
end
```

**Import pattern:**
```lua
import("MissionOMatic/MissionOMatic.scar")
import("scar/Coop_4_Japanese_difficulty.scar")
```
