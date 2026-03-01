---
applyTo: "gamemodes/**"
---

# Gamemode Folder Scope — AoE4 Workspace

## File Restrictions

When working on files inside `gamemodes/`:

- **ONLY** read, generate, edit, review, debug, or refactor `.scar`, `.md`, `.csv`, and `.xml` files
- **DO NOT** read, validate, or edit binary, image, or build artifact files: `.bin`, `.pdn`, `.png`, `.rdo`, `.aoe4mod`, `.burnproj`, `.locdb`

## External Reference Access

These directories remain accessible for lookups that support gamemode development:
- `reference/` — indexes, function docs, blueprint data
- `data/` — game balance JSON
- `official-guides/` — editor and modding workflows

## Coding Standards

SCAR files in gamemodes follow the same standards as mods. See `scar-coding.instructions.md` for naming conventions, file organization, and API patterns.
