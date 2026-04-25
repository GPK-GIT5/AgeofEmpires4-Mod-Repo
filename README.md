# Age of Empires 4 — Modding Workspace

A development and reference workspace for AoE4 SCAR scripting, custom game modes, scenarios, and mod tooling.
Contains live mod source, extracted game data, reference documentation, and Copilot AI integration.

---

## Workspace Overview

| What it is | What it's for |
|---|---|
| Active mod source | Two published mods under active development (`Gamemodes/`) |
| Custom scenarios | Coop map scripts for Arabia, Japanese, Taiga, and Woodland maps (`Scenarios/`) |
| SCAR reference | Extracted API, constants, events, and script indexes for lookup while coding |
| Raw game data | Lua runtime dump, blueprint data, and SCAR script dumps from the live game |
| Automation scripts | PowerShell tools for data extraction, auditing, and CI regression |
| AI integration | Copilot custom instructions, skills, and agents tuned for this codebase |

---

## Folder Structure

| Folder | Purpose |
|---|---|
| `Gamemodes/` | Mod source files — Advanced Game Settings (AGS) and Onslaught (CBA) |
| `Scenarios/` | Scenario SCAR scripts for custom coop maps |
| `references/` | AI-generated reference docs: API, systems, UI, navigation index |
| `data/` | Extracted raw game data: SCAR dump, blueprints, UCS strings, sysconfig |
| `user_references/` | Community guides, official modding articles (78), and reusable patterns |
| `scripts/` | PowerShell build, audit, and data-extraction automation |
| `changelog/` | Session-level implementation summaries and before/after comparisons |
| `.github/` | Copilot instructions, custom agents, architecture docs, known-issues registry |
| `.skills/` | VS Code Copilot skill files (SCAR debug, data extraction, console commands) |

---

## Mods in This Workspace

| Mod | Folder | Description |
|---|---|---|
| **Advanced Game Settings** | `Gamemodes/Advanced Game Settings/` | Lobby option framework: population, team balance, siege limits, auto-population |
| **Onslaught (CBA Custom)** | `Gamemodes/Onslaught/` | Full CBA game mode with auto-age, boon selection, player UI, leaver handling |

---

## Key Reference Files

| File | What it covers |
|---|---|
| [references/api/scar-api-functions.md](references/api/scar-api-functions.md) | 4,435 SCAR API functions across 157 categories |
| [references/api/constants-and-enums.md](references/api/constants-and-enums.md) | 700+ constants and enums with type prefixes |
| [references/api/game-events.md](references/api/game-events.md) | 175 game events (`GE_*`) with numeric IDs |
| [user_references/guides/scar-scripting-basics.md](user_references/guides/scar-scripting-basics.md) | Common SCAR patterns and scripting fundamentals |
| [user_references/guides/common-patterns.md](user_references/guides/common-patterns.md) | Reusable code patterns extracted from official scripts |
| [.github/instructions/coding/known-issues.instructions.md](.github/instructions/coding/known-issues.instructions.md) | Known crash patterns and instability bugs (KI-* registry) |
| [references/navigation/INDEX.md](references/navigation/INDEX.md) | Full index of all 25 reference files, organized by workflow |

---

## How to Use This Workspace

1. **Open** `AoE4-Workspace.code-workspace` in VS Code — all folders load as roots.
2. **Write mod code** in `Gamemodes/Onslaught/assets/scar/` or `Gamemodes/Advanced Game Settings/assets/scar/`.
3. **Look up APIs** in `references/api/` while coding. `.scar` files use Lua syntax highlighting.
4. **Run automation** from `scripts/` using PowerShell — see `scripts/run_regression_suite.ps1` for CI.
5. **Check AI guidance** in `.github/copilot-instructions.md` before asking Copilot for help.

---

## File Conventions

| Convention | Pattern | Example |
|---|---|---|
| Script files | `.scar` = Lua | `cba.scar`, `cardinal.scar` |
| Function names | `Category_ActionName` | `Squad_GetHealth()`, `Player_SetResource()` |
| Constants | `UPPER_CASE` with type prefix | `RT_Food`, `GE_EntityKilled`, `CMD_Move` |
| Game event hooks | `Rule_AddGlobalEvent(fn, GE_*)` | `Rule_AddGlobalEvent(OnAgeUp, GE_PlayerAgeUp)` |
| Named callbacks only | `Rule_Add*` rejects anonymous functions | Use named globals + queue pattern for deferred calls |
