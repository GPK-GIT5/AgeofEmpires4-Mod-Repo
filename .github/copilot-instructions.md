# Copilot Instructions

AoE4 modding workspace: SCAR Lua scenarios, PowerShell automation, Markdown docs.

## Priority Guidelines

0. **Test commands after edits:** Every response that edits or creates `.scar` files **must** end with a `## Testing` section containing ≥1 console command. See `.github/instructions/core/testing-response.instructions.md` for full contract. Present as a markdown table with columns `Step | Command | Description | Expected results` — one command per row. No other format is permitted for runnable commands anywhere in the response.
1. **Console commands — table only:** Never use fenced code blocks (` ```lua `, ` ```scar `, or plain ` ``` `), numbered/bulleted lists, bold-label pairs, inline runnable commands in prose, or any non-table format for console commands in any response context. Use the markdown table format defined in `.github/instructions/core/console-commands.instructions.md` § Presentation Format — columns: `Step | Command | Description | Expected results`. One command per row, raw command text only in the Command cell. Console commands must appear literally in the response body — never via file-editing tools, terminal execution, or code-application mechanisms.
2. **No `Scar_DoString(...)` command wrappers:** Never emit `Scar_DoString(...)` in user-facing runnable console commands. Output direct callable command text instead (for example, `CBA_AIPlayer_Status()`).
3. **Minimal table rows only:** Keep each command row concise (single-purpose Description + primary Expected results signal only).
4. **No duplicate command rows:** Do not repeat the same command text within one table; use one orchestrator/tracker command when progression must be observed over time.
5. **No runnable-command prose lists:** Do not present console commands as numbered bullets, bold subheadings, example snippets, or addenda outside the required table. Search/exploration notes may appear above `## Testing`, but runnable commands belong only in the table.
6. **No raw tool-trace output in responses:** Never echo tool traces such as `Searched for regex ...`, terminal analyzer lines, or other system/tool bookkeeping into user-facing responses. Summarize findings in plain prose instead.
7. **Version Compatibility**: Respect detected technology versions
8. **Sources of Truth**: `references/` and `data/aoe4/` are the authoritative sources for all game data, API behavior, and scripting patterns. Prefer these over assumptions, generated rules, or outdated logic.
   - Verify SCAR behavior against: `references/gameplay/`, `references/campaigns/`, `references/api/`, `references/ui/`
   - Verify game data against: `data/aoe4/data/`, `data/aoe4/scardocs/`, `data/aoe4/scar_dump/`
   - Resolution order for data lookups: see `.github/instructions/context/data-catalog.instructions.md`
9. **Codebase Patterns**: Scan existing `.scar`/`.ps1` files before introducing anything new
10. **Architectural Consistency**: Maintain file-split architecture, naming, module patterns
11. **Code Quality**: Prioritize consistency with existing code over external best practices

---

## Pre-Response Validation

- [ ] Scope tier identified (Console / Folder-Specific / General)
- [ ] File type restrictions honored (if Scenarios/ or Gamemodes/ scope)
- [ ] Naming conventions matched (see path-specific files)
- [ ] No external patterns introduced (scanned existing code first)
- [ ] Index consulted before file read (if mod-specific work)

---

## Technology Stack

- **Lua (SCAR)**: 5.x (Relic); `.scar`; `import()` not `require()`; no metatables
- **PowerShell**: 7+ (pwsh); `$ErrorActionPreference = "Stop"`
- **VS Code**: Tabs (size 4), `sumneko.lua` ext
- **Docs**: Markdown; no HTML; relative paths; forward slashes
- **Data**: `.json`, `.csv`, `.jsonl` in `data/`, `references/`

---

## Coding Standards (Path-Specific)

Detailed standards auto-load via `.github/instructions/`:

- **SCAR Lua** (`**/*.scar`): `coding/scar-coding.instructions.md`
- **XAML/UI** (`**/*.scar`): `coding/xaml-ui.instructions.md`
- **Siege Limits** (`**/cba_options.scar`, etc.): `coding/scar-siege-limits.instructions.md`
- **PowerShell** (`**/*.ps1`): `coding/ps-coding.instructions.md`
- **LocDB** (`**/locdb/*.csv`): `coding/locdb.instructions.md`
- **Folder scope** (`Scenarios/**`, `Gamemodes/**`): `context/folder-scope.instructions.md`
- **AI Reference** (`.skills/**`, `**/ai/**`): `core/ai-reference.instructions.md`
- **AI Systems** (`**/cba_ai_player.scar`, `**/cba_debug_ai*.scar`, `**/cba_training.scar`, `**/ags_ai.scar`, `data/aoe4/scar_dump/scar gameplay/ai/**`): `context/ai-systems.instructions.md`

---

## Context Budget

- Max 3 .scar files per response; prefer Quick Ref + index over speculative reads
- Read mod index (`references/mods/MOD-INDEX.md`) before exploratory .scar reads

---

## Quick Reference

| Task | Primary Doc | Fallback |
|------|-------------|----------|
| SCAR API function lookup | `references/indexes/function-index.md` | `references/api/scar-api-functions.md` |
| Onslaught function index | `references/indexes/onslaught-function-index.md` | `references/indexes/onslaught-function-index.csv` |
| Onslaught globals index | `references/indexes/onslaught-globals-index.md` | `references/indexes/onslaught-globals-index.csv` |
| Onslaught API usage map | `references/mods/onslaught-api-usage-map.md` | `references/indexes/onslaught-api-usage.csv` |
| Onslaught patterns | `references/mods/onslaught-patterns.md` | `Gamemodes/Onslaught/assets/scar/` |
| Onslaught event handlers | `references/mods/onslaught-event-handler-map.md` | `references/indexes/onslaught-event-handlers.csv` |
| Onslaught options schema | `references/mods/onslaught-options-schema.md` | `Gamemodes/Onslaught/assets/scar/gameplay/ags_global_settings.scar` |
| Onslaught blueprint audit | `references/mods/onslaught-blueprint-audit.md` | `references/indexes/onslaught-blueprint-audit.csv` |
| Campaign entities | `data/aoe4/data/canonical/campaign-entities.json` | `references/blueprints/campaign-blueprints.md` |
| Onslaught reward trees | `references/mods/onslaught-reward-trees.md` | `references/indexes/onslaught-reward-trees.csv` |
| Onslaught debug commands | `references/mods/onslaught-debug-commands.md` | `references/indexes/onslaught-debug-commands.csv` |
| Onslaught module lifecycle | `references/mods/onslaught-module-lifecycle.md` | `references/indexes/onslaught-module-lifecycle.csv` |
| SCAR engine API signatures | `references/indexes/scar-engine-functions.csv` | `data/aoe4/scardocs/parsed_functions.json` |
| SCAR engine constants | `references/indexes/scar-engine-constants.csv` | `data/aoe4/scardocs/parsed_constants.json` |
| Blueprint resolution | `references/.skill/SKILL-GUIDE.md` | `references/blueprints/` |
| Unit/building/tech data | `references/navigation/data-index.md` | `data/aoe4/data/` |
| Data catalog (all sources) | `.github/instructions/context/data-catalog.instructions.md` | `references/blueprints/README.md` |
| Canonical unit identity | `data/aoe4/data/canonical/alias-map.json` | `data/aoe4/data/canonical/canonical-units.json` |
| Canonical buildings | `data/aoe4/data/canonical/canonical-buildings.json` | `data/aoe4/data/buildings/all-unified.json` |
| Weapon catalog | `data/aoe4/data/canonical/weapon-catalog.json` | `data/aoe4/data/canonical/weapon-profiles.json` |
| Core templates & inheritance | `data/aoe4/data/canonical/core-templates.json` | `data/aoe4/data/canonical/inheritance-map.json` |
| Tier upgrade chains | `data/aoe4/data/canonical/tier-chains.json` | `data/aoe4/data/canonical/unit-weapon-linkage.json` |
| Entity lifecycle (unified) | `data/aoe4/data/canonical/entity-lifecycle.json` | `data/aoe4/data/canonical/inheritance-map.json` |
| HA variant deltas | `data/aoe4/data/canonical/ha-variant-deltas.json` | `data/aoe4/data/ha-variants/` |
| Age progression & landmarks | `references/gameplay/age-progression.md` | `data/aoe4/data/derived/bp-suffix-catalog.json` |
| Constants and enums | `references/api/constants-and-enums.md` | `references/api/commands-reference.md` |
| Changelog workflow | `changelog/README.md` | `changelog/docs/QUICKSTART.md` |
| AI reference generation | `.skills/readme-to-ai-reference/SKILL.md` | `.skills/readme-to-ai-reference/specs/` |
| AI systems (official patterns) | `references/gameplay/ai.md` | `references/systems/ai-patterns.md` |
| SCAR debug generation | `.skills/scar-debug/SKILL.md` | `references/mods/onslaught-debug-reference.md` |
| PlayerUI / XamlPresenter | `references/ui/PlayerUI_Architecture.md` | `references/ui/UI_SetPlayerDataContext_QuickReference.md` |
| Gamemode option impl | `.github/prompts/gamemode-option.prompt.md` | `Gamemodes/Onslaught/assets/scar/gameplay/cba_options.scar` |
| Data extraction pipeline | `.skills/data-extraction/SKILL.md` | `scripts/run_all_extraction.ps1` |
| Canonical data pipeline | `scripts/build_canonical_data.ps1` | `scripts/validate_data.ps1` |
| Crash pattern / known issues | `.github/instructions/coding/known-issues.instructions.md` | `references/ui/PlayerUI_Architecture.md` |

---

## Validation

- **Structure**: `scripts/structure_lint.ps1`
- **Docs**: `scripts/doc_lint.ps1`
- **SCAR**: Content Editor in-game console
- **Data**: `scripts/run_all_extraction.ps1` — never hand-edit
- **Canonical**: `scripts/validate_data.ps1` → `references/audits/pipeline-audit.md`
- **Changelog**: `changelog/scripts/validate-entry.ps1`

---

## Glossary

- **attribName**: Blueprint variant id (e.g., `unit_spearman_1_abb`); resolves to a **baseId**
- **baseId**: Canonical unit identity (e.g., `archer`, `man-at-arms`); see `data/aoe4/data/canonical/`
- **SCAR**: Scripting At Relic — Lua-based scripting for AoE4
- **EBP/SBP/UBP**: Entity/Squad/Upgrade Blueprint