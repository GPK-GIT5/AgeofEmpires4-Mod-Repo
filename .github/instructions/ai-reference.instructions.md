---
applyTo: ".skills/**,**/ai/*.md,**/ai/*.yaml"
---

# AI Reference Generation

**Skill:** `.skills/readme-to-ai-reference/SKILL.md`  
**Strategy:** `.github/copilot/REFERENCE_GENERATION_STRATEGY.md`  
**Governing Specs:** `.github/copilot/REFERENCE_SPEC_01_STRUCTURE.md` · `REFERENCE_SPEC_02_GUARDRAILS.md` · `REFERENCE_SPEC_03_EVALUATION.md`

---

## How to Use

Invoke with `generation_mode` in config (defaults to `hybrid`):

```yaml
config:
  generation_mode: hybrid   # conservative | detailed | hybrid
```

| Mode | Data Sources | Risk | Unknowns |
|------|-------------|------|---------|
| `conservative` | README + dirs only | Minimal | 50–150 |
| `detailed` | README + full source inspection | Medium | 5–20 |
| `hybrid` *(default)* | README + selective P0/P1 inspection | Low | 10–30 |

**P0 targets** (always inspect): entry point file, global config file  
**P1 targets** (inspect if budget allows): core framework API, primary helpers  
**P2/P3**: README-only with `INFERRED` tag

---

## Non-Invention Rules

**CRITICAL — enforced for every output:**

1. **Never invent file paths** — only list files present in the repository
2. **Never invent function names** — only include names found via static analysis
3. **Never invent constants/settings** — all constants must exist in source code
4. **Mark all gaps explicitly:**

```
Unknown — requires source inspection.
Recommendation: Check [file] for current behavior.
```

---

## Verification Metadata

Every generated file must include in its header:

```markdown
**Generation Mode:** hybrid
**Last Verified:** YYYY-MM-DD
**Verification Coverage:** NN% VERIFIED, NN% INFERRED, NN% UNKNOWN
```

### Verification Tags

| Tag | Meaning | Inline Format |
|-----|---------|--------------|
| `VERIFIED` | Confirmed against source code or repository | `<!-- VERIFIED: method -->` |
| `INFERRED` | Deduced from patterns or README context | `<!-- INFERRED: basis -->` |
| `UNKNOWN` | Cannot confirm — inspection required | `Unknown — requires source inspection` |

### Source Attribution

| Source Type | Format |
|-------------|--------|
| README | `SOURCE: README L42` |
| Repository listing | `SOURCE: FILE:path/to/file.ext` |
| Source code | `SOURCE: CODE:path/file.ext:L42` |

---

## Authority Hierarchy

Resolve conflicts top-down (highest wins):

1. `settings_schema.yaml` — runtime configuration authority
2. `file_index.md` — verified structural truth
3. `architecture.md` — conceptual/design truth
4. `README.md` — narrative reference (may be outdated)
5. Source code — ground truth for all verification

---

## Output Primitives

Six files generated in project-local `ai/` directory:

| File | Purpose | Size |
|------|---------|------|
| `AI_INDEX.md` | Navigation entry point | 200–300 words |
| `architecture.md` | Lifecycle, modules, data flow | 600–900 words |
| `file_index.md` | File-to-responsibility mapping | 500–1,200 words |
| `settings_schema.yaml` | Configuration constants authority | 300–800 words |
| `capabilities_map.md` | Feature-to-implementation mapping | 400–800 words |
| `glossary.md` | Terminology grounding | 300–600 words |

Anchor convention: `<!-- DOC:TYPE:ID -->` (unique per file, stable across regenerations)

---

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
`gamemodes/Advanced Game Settings/ai/` — eval report: `ai/_eval_report.md`
