---
name: copilot-skill-blueprint-resolution
description: Resolve AoE4 SCAR blueprint references from attribName, pbgid, or legacy paths using workspace sources-of-truth.
---

# Copilot Skill: Blueprint Resolution

**Purpose:** Resolve SCAR blueprint references — attribName, pbgid, or legacy paths.

**Docs:** [README.md](../../reference/.skill/README.md) · [SKILL-GUIDE.md](../../reference/.skill/SKILL-GUIDE.md)

**When to invoke:**
- User explicitly asks to resolve, convert, or validate a blueprint
- Code generation requires a blueprint id that is not already known

## Recognized Request Patterns

Copilot should recognize these patterns in user input and invoke the Skill:

- "Resolve blueprint `unit_archer_2_abb` for Abbasid"
- "What is attribName for `unit_men_at_arms_1_eng`? Confirm civ."
- "Resolve pbgid `190862`"
- "Convert `ebps/races/chinese/units/zhuge_nu` to attribName"
- "Batch resolve: `unit_scout_1_eng`, `unit_scout_1_fre`, `unit_scout_1_hre`"

## Workflow

1. Invoke Copilot Skill with the identifier (attribName, pbgid, or legacy path)
2. If civ validation is requested, confirm match; report `valid=false` + suggestions if mismatch
3. **If Skill unavailable:** fall back to [blueprints/](../../reference/blueprints/)
4. **If still unresolved:** cross-check [data-index.md](../../reference/data-index.md) and [data/](../../data/)
