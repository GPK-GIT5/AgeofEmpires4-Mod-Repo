---
applyTo: "Scenarios/**"
---

# Scenarios Folder Scope — AoE4 Workspace

## File Restrictions

When working on files inside `Scenarios/`:

- **ONLY** read, generate, edit, review, debug, or refactor `.scar` and `.md` files
- **DO NOT** read, validate, or edit any other file type inside `Scenarios/`

## Mod Structure

- **Runtime files** (`.scar`, `assets/scar/`, `scar/`) are always valid — never move or flag them
- **Documentation** (`.md`, index files) is only allowed inside a `docs/` subfolder per mod
- Never place loose `.md` files at a mod root or in non-docs subdirectories

## External Reference Access

These directories remain accessible for lookups that support `.scar`/`.md` work:
- `references/` — indexes, function docs, blueprint data
- `user_references/official-guides/` — editor and modding workflows
- `data/aoe4/data/` — game balance JSON

## Index-First Rule

When a mod has a dedicated index (e.g., MOD-INDEX.md), **read it first** before exploratory file reads. This saves 35-60% token budget vs. reading individual .scar files.

- Japan mod: Read `references/mods/MOD-INDEX.md` (NOT `Scenarios/Japan/MOD-INDEX.md`)
- Arabia mod: Read `references/mods/arabia-mod-index.md`

## Token Budget

- Never load more than 3 .scar files in a single response
- If a Quick Ref + one index lookup answers the question, stop
- Check MOD-INDEX.md before loading full source files

