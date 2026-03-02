# Copilot Instructions

AoE4 modding workspace: SCAR Lua scenarios, PowerShell automation, Markdown docs.

## Metadata

- Last Updated: 2026-03-01
- Architecture: Master + path-specific instruction files

---

## Priority Guidelines

1. **Version Compatibility**: Respect detected technology versions
2. **Sources of Truth**: Reference indexes → specific docs → official guides
3. **Codebase Patterns**: Scan existing `.scar`/`.ps1` files before introducing anything new
4. **Architectural Consistency**: Maintain file-split architecture, naming, module patterns
5. **Code Quality**: Prioritize consistency with existing code over external best practices

---

## Pre-Response Validation

- [ ] Scope tier identified (Console / Folder-Specific / General)
- [ ] File type restrictions honored (if mods/ or gamemodes/ scope)
- [ ] Naming conventions matched (see path-specific files)
- [ ] No external patterns introduced (scanned existing code first)
- [ ] Index consulted before file read (if mod-specific work)

---

## Technology Stack

| Technology | Version | Notes |
|-----------|---------|-------|
| Lua (SCAR) | 5.x (Relic) | `.scar` files; `import()` not `require()`; no metatables |
| PowerShell | 7+ (pwsh) | `scripts/`, `changelog/`; `$ErrorActionPreference = "Stop"` |
| VS Code | Primary editor | Tabs (size 4), word wrap, `sumneko.lua` extension |
| Data formats | `.json`, `.csv`, `.jsonl` | `data/`, `reference/`, `changelog/` |
| Documentation | Markdown exclusively | No HTML; relative paths; forward slashes |
| Build system | None | Automation via `scripts/run_all_extraction.ps1` |

---

## Coding Standards (Path-Specific)

Detailed standards auto-load via `.github/instructions/`:

- **SCAR Lua** (`**/*.scar`): `scar-coding.instructions.md`
- **PowerShell** (`**/*.ps1`): `ps-coding.instructions.md`
- **Mods scope** (`mods/**`): `mods-scope.instructions.md`
- **Gamemodes scope** (`gamemodes/**`): `gamemode-scope.instructions.md`
- **Mod context** (`mods/**`, `reference/mods/**`): `mod-context.instructions.md`
- **AI Reference** (`.skills/**`, `**/ai/**`): `ai-reference.instructions.md`

---

## Rule Precedence

1. **Console Command Generation** — Stateless single-expression Lua for AoE4 console
2. **Folder-Specific Scopes** — File restrictions for `mods/` or `gamemodes/`
3. **General Rules** — Default for all other work

Non-conflicting tiers stack. Higher tiers override lower on same topic.

---

## Context Budget

- Never load more than 3 .scar files in a single response
- If Quick Ref + one index lookup answers, stop — don't speculatively load source files
- Read `mods/Japan/MOD-INDEX.md` before exploratory .scar reads (35-60% token savings)

---

## Quick Reference

| Task | Primary Doc | Fallback |
|------|-------------|----------|
| SCAR API function lookup | `reference/function-index.md` | `reference/scar-api-functions.md` |
| Blueprint resolution | `reference/.skill/SKILL-GUIDE.md` | `reference/blueprints/` |
| Unit/building/tech data | `reference/data-index.md` | `data/` |
| Constants and enums | `reference/constants-and-enums.md` | `reference/commands-reference.md` |
| Changelog workflow | `changelog/QUICKSTART.md` | `changelog/README.md` |
| AI reference generation | `.skills/readme-to-ai-reference/SKILL.md` | `.github/copilot/REFERENCE_GENERATION_STRATEGY.md` |

---

## Validation

- **SCAR**: Content Editor in-game console (no external test framework)
- **PowerShell**: `$ErrorActionPreference = "Stop"` + `Test-Path` + `try/catch`
- **Data**: CSV indexes via `scripts/run_all_extraction.ps1` — never hand-edit
- **Changelog**: `reference/deterministic-workflow-guidelines.md` for deterministic workflows; `validate-entry.ps1` before appending to INDEX.jsonl

---

## Glossary

- **attribName**: Canonical blueprint id (e.g., `unit_spearman_1_abb`)
- **SCAR**: Scripting At Relic — Lua-based scripting for AoE4
- **EBP/SBP/UBP**: Entity/Squad/Upgrade Blueprint
