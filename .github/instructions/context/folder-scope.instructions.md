---
applyTo: "Scenarios/**,Gamemodes/**"
---

# Folder Scope — AoE4 Workspace

## File Restrictions

| Folder | Allowed types | Forbidden |
|--------|--------------|-----------|
| `Scenarios/` | `.scar`, `.md` | All other types |
| `Gamemodes/` | `.scar`, `.md`, `.csv`, `.xml` | `.bin`, `.pdn`, `.png`, `.rdo`, `.aoe4mod`, `.burnproj`, `.locdb` |

## Mod Structure

- **Runtime files** (`.scar`, `assets/scar/`, `scar/`) are always valid — never move or flag them
- **Documentation** (`.md`) only inside a `docs/` subfolder per mod
- Never place loose `.md` files at a mod root

## External Reference Access

These directories are the authoritative sources for game data and API behavior:
- `references/` — indexes, function docs, blueprint data, API signatures, gameplay systems
- `data/aoe4/` — official game data (entity JSONs, scardocs, engine dumps, sysconfig)
- `user_references/official-guides/` — editor and modding workflows

Always prefer these sources over assumptions or generated rules when validating behavior.

## Index-First Rule

When a mod has a dedicated index, **read it first** before exploratory file reads:
- Japan: `references/mods/MOD-INDEX.md`
- Arabia: `references/mods/arabia-mod-index.md`

## Token Budget

- Max 3 .scar files per response
- Check MOD-INDEX.md before loading full source files
