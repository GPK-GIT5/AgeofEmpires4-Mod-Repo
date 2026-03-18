---
applyTo: ".skills/**,**/ai/*.md,**/ai/*.yaml"
---

# AI Reference Generation

**Skill:** `.skills/readme-to-ai-reference/SKILL.md`  
**Specs:** `.skills/readme-to-ai-reference/specs/` (strategy, structure, guardrails, evaluation)  
**Lint:** `scripts/doc_lint.ps1`

---

## Quick Reference

| Mode | Data Sources | Risk |
|------|-------------|------|
| `conservative` | README + dirs only | Minimal |
| `detailed` | README + full source inspection | Medium |
| `hybrid` *(default)* | README + selective P0/P1 inspection | Low |

## Non-Invention Rules (Always Enforced)

1. **Never invent file paths** — only list files present in the repository
2. **Never invent function names** — only include names found via static analysis
3. **Never invent constants/settings** — all constants must exist in source code
4. **Mark all gaps explicitly:** `Unknown — requires source inspection`

## Authority Hierarchy (Highest Wins)

1. `settings_schema.yaml` — runtime configuration authority
2. `file_index.md` — verified structural truth
3. `architecture.md` — conceptual/design truth
4. `README.md` — narrative reference (may be outdated)
5. Source code — ground truth for all verification

## Output Primitives

Six files in project-local `ai/`: AI_INDEX.md, architecture.md, file_index.md, settings_schema.yaml, capabilities_map.md, glossary.md

**Full workflow, quality gates, verification metadata:** See `.skills/readme-to-ai-reference/SKILL.md` and `.skills/readme-to-ai-reference/SPECIFICATION.md`

## Quality Gates (all must pass before release)

1. ✅ All file paths in `file_index.md` exist in repository
2. ✅ All anchors follow `<!-- DOC:TYPE:ID -->`, unique per file
3. ✅ No invented content; all unknowns marked explicitly
4. ✅ `settings_schema.yaml` is valid YAML
5. ✅ No file exceeds 1,200 words
6. ✅ All cross-links reachable; `AI_INDEX.md` complete
7. ✅ Metadata header present in every generated file

---

## Reference Example

AGS (Advanced Game Settings) reference material at:  
`Gamemodes/Advanced Game Settings/docs/ai/` — eval report: `docs/ai/_eval_report.md`
