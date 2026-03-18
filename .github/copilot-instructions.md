# Copilot Instructions

AoE4 modding workspace: SCAR Lua scenarios, PowerShell automation, Markdown docs.

## Priority Guidelines

1. **Version Compatibility**: Respect detected technology versions
2. **Sources of Truth**: Reference indexes → specific docs → official guides
3. **Codebase Patterns**: Scan existing `.scar`/`.ps1` files before introducing anything new
4. **Architectural Consistency**: Maintain file-split architecture, naming, module patterns
5. **Code Quality**: Prioritize consistency with existing code over external best practices

---

## Pre-Response Validation

- [ ] Scope tier identified (Console / Folder-Specific / General)
- [ ] File type restrictions honored (if Scenarios/ or Gamemodes/ scope)
- [ ] Naming conventions matched (see path-specific files)
- [ ] No external patterns introduced (scanned existing code first)
- [ ] Index consulted before file read (if mod-specific work)

---

## Technology Stack

| Technology | Version | Notes |
|-----------|---------|-------|
| Lua (SCAR) | 5.x (Relic) | `.scar`; `import()` not `require()`; no metatables |
| PowerShell | 7+ (pwsh) | `$ErrorActionPreference = "Stop"` |
| VS Code | — | Tabs (size 4), `sumneko.lua` ext |
| Data formats | `.json`, `.csv`, `.jsonl` | `data/`, `references/` |
| Documentation | Markdown | No HTML; relative paths; forward slashes |
| Build system | None | `scripts/run_all_extraction.ps1` |

---

## Coding Standards (Path-Specific)

Detailed standards auto-load via `.github/instructions/`:

- **SCAR Lua** (`**/*.scar`): `coding/scar-coding.instructions.md`
- **SCAR Events** (`**/*.scar`): `coding/scar-events.instructions.md`
- **SCAR Blueprints** (`**/*.scar`): `coding/scar-blueprints.instructions.md`
- **XAML/UI** (`**/*.scar`): `coding/xaml-ui.instructions.md`
- **PowerShell** (`**/*.ps1`): `coding/ps-coding.instructions.md`
- **Scenarios scope** (`Scenarios/**`): `context/mods-scope.instructions.md`
- **Gamemodes scope** (`Gamemodes/**`): `context/gamemode-scope.instructions.md`
- **Scenario context** (`Scenarios/**`, `references/mods/**`): `context/mod-context.instructions.md`
- **AI Reference** (`.skills/**`, `**/ai/**`): `core/ai-reference.instructions.md`

---

## Rule Precedence

1. **Console Command Generation** — Stateless single-expression Lua for AoE4 console
2. **Folder-Specific Scopes** — File restrictions for `Scenarios/` or `Gamemodes/`
3. **General Rules** — Default for all other work

Non-conflicting tiers stack. Higher tiers override lower on same topic.

---

## Context Budget

- Max 3 .scar files per response; prefer Quick Ref + index over speculative reads
- Read mod index (`references/mods/MOD-INDEX.md`) before exploratory .scar reads

---

## Quick Reference

| Task | Primary Doc | Fallback |
|------|-------------|----------|
| SCAR API function lookup | `references/indexes/function-index.md` | `references/api/scar-api-functions.md` |
| Blueprint resolution | `references/.skill/SKILL-GUIDE.md` | `references/blueprints/` |
| Unit/building/tech data | `references/navigation/data-index.md` | `data/aoe4/data/` |
| Constants and enums | `references/api/constants-and-enums.md` | `references/api/commands-reference.md` |
| Changelog workflow | `changelog/README.md` | `changelog/docs/QUICKSTART.md` |
| AI reference generation | `.skills/readme-to-ai-reference/SKILL.md` | `.skills/readme-to-ai-reference/specs/` |
| SCAR debug generation | `.skills/scar-debug/SKILL.md` | `references/mods/onslaught-debug-reference.md` |
| Gamemode option impl | `.github/prompts/gamemode-option.prompt.md` | `Gamemodes/Onslaught/assets/scar/gameplay/cba_options.scar` |
| Data extraction pipeline | `.skills/data-extraction/SKILL.md` | `scripts/run_all_extraction.ps1` |

---

## Validation

- **Structure**: `scripts/structure_lint.ps1` — directory rules, naming, frontmatter
- **Docs**: `scripts/doc_lint.ps1` — anchors, YAML, forbidden phrases, sizes
- **SCAR**: Content Editor in-game console
- **PowerShell**: `$ErrorActionPreference = "Stop"` + `try/catch`
- **Data**: `scripts/run_all_extraction.ps1` — never hand-edit
- **Changelog**: `changelog/scripts/validate-entry.ps1`

---

## Glossary

- **attribName**: Canonical blueprint id (e.g., `unit_spearman_1_abb`)
- **SCAR**: Scripting At Relic — Lua-based scripting for AoE4
- **EBP/SBP/UBP**: Entity/Squad/Upgrade Blueprint