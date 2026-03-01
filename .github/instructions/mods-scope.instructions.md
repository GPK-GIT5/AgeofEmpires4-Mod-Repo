---
applyTo: "mods/**"
---

# Mods Folder Scope — AoE4 Workspace

## File Restrictions

When working on files inside `mods/`:

- **ONLY** read, generate, edit, review, debug, or refactor `.scar` and `.md` files
- **DO NOT** read, validate, or edit any other file type inside `mods/`

## External Reference Access

These directories remain accessible for lookups that support `.scar`/`.md` work:
- `reference/` — indexes, function docs, blueprint data
- `data/` — game balance JSON
- `official-guides/` — editor and modding workflows

## Index-First Rule

When a mod has a dedicated index (e.g., MOD-INDEX.md), **read it first** before exploratory file reads. This saves 35-60% token budget vs. reading individual .scar files.

- Japan mod: Read `reference/mods/MOD-INDEX.md` (NOT `mods/Japan/MOD-INDEX.md`)
- Arabia mod: Read `reference/mods/arabia-mod-index.md`

## Token Budget

- Never load more than 3 .scar files in a single response
- If a Quick Ref + one index lookup answers the question, stop
- Check MOD-INDEX.md before loading full source files
