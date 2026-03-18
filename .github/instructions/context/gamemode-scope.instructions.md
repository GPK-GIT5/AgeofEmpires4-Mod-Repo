---
applyTo: "Gamemodes/**"
---

# Gamemode Folder Scope — AoE4 Workspace

## File Restrictions

When working on files inside `Gamemodes/`:

- **ONLY** read, generate, edit, review, debug, or refactor `.scar`, `.md`, `.csv`, and `.xml` files
- **DO NOT** read, validate, or edit binary, image, or build artifact files: `.bin`, `.pdn`, `.png`, `.rdo`, `.aoe4mod`, `.burnproj`, `.locdb`

## Mod Structure

- **Runtime files** (`.scar`, `assets/scar/`, `scar/`) are always valid — never move or flag them
- **Documentation** (`.md`, index files) is only allowed inside a `docs/` subfolder per mod
- Never place loose `.md` files at a mod root or in non-docs subdirectories

## External Reference Access

These directories remain accessible for lookups that support gamemode development:
- `references/` — indexes, function docs, blueprint data
- `user_references/official-guides/` — editor and modding workflows
- `data/aoe4/data/` — game balance JSON

## Coding Standards

SCAR files in gamemodes follow the same standards as mods. See `scar-coding.instructions.md` for naming conventions, file organization, and API patterns.
