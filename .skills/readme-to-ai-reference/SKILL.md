---
name: "readme-to-ai-reference"
description: "Transforms human-readable READMEs into AI-optimized reference material (Diátaxis-based, hallucination-guarded, structured primitives)"
metadata:
  version: "1.0.0"
  author: "Copilot Skill: readme-to-ai-reference"
  keywords: ["documentation", "reference-material", "assistant", "readme", "hallucination-mitigation"]
---

# Skill: README to AI Reference Material

**Purpose:**<br>
Convert human-readable README.md files into machine-optimized AI reference material following deterministic, hallucination-guarded patterns.

**Input:** A README.md file describing a software system<br>
**Output:** Structured reference primitives in `/ai/` directory

---

## Objective

Transform narrative README documentation into structured, machine-queryable reference primitives that:

1. **Minimize hallucination** through explicit non-invention rules
2. **Optimize retrieval** via semantic chunking and anchored cross-links
3. **Enable automation** through deterministic schemas
4. **Support continuous evaluation** via quality gates and evals tests

---

## Inputs

| Input | Format | Required | Description |
|-------|--------|----------|-------------|
| `source_readme` | Markdown (.md) | ✅ Yes | Human-readable system documentation |
| `repo_structure` | File listing | ✅ Yes | List of actual repository files (for validation) |
| `source_code_map` | Text/JSON | ✅ Yes | Function/constant names from static analysis |
| `config` (optional) | YAML | ❌ No | Overrides for chunking limits, strictness level |

### Config Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `generation_mode` | string | `hybrid` | `conservative`, `detailed`, `hybrid` | Controls data sources, verification depth, and unknown marker density |
| `chunking_limit` | integer | `1200` | 500–2000 | Maximum words per output file |
| `strictness` | string | `standard` | `strict`, `standard`, `relaxed` | Hallucination guard strictness level |

**Mode Details:** See [REFERENCE_GENERATION_STRATEGY.md](specs/REFERENCE_GENERATION_STRATEGY.md)

---

## Workflow

### Phase 1: Parse README

1. Extract all factual assertions from README
2. Categorize by type: structural, functional, configurational, terminological
3. Identify gaps: information assumed but not stated

**Output:** Extracted facts corpus (structured but unsanitized)

### Phase 2: Validate Against Source

**This phase branches based on `generation_mode`:**

#### Conservative Mode (README-only)
1. Cross-reference file paths against repository directories (list_dir, file_search)
2. Mark all function names as `UNKNOWN`
3. Mark all constants/settings types and defaults as `UNKNOWN`
4. Tag verified paths as `VERIFIED`, README-derived facts as `INFERRED`

#### Detailed Mode (Source-inspected)
1. Cross-reference file paths against actual repository
2. Read entry point and config files (read_file — up to 10 files)
3. Verify function names via grep_search (up to 20 searches)
4. Verify constants/settings from source code
5. Mark remaining edge cases as `UNKNOWN`

#### Hybrid Mode (Recommended default)
1. Cross-reference file paths against actual repository
2. Inspect P0 targets: entry point file, global config file (read_file — 2–5 files)
3. Inspect P1 targets: core framework API, primary helpers (grep_search — 5–10 searches)
4. Mark P2/P3 targets as `INFERRED` with README citation
5. Mark unresolvable items as `UNKNOWN`

**Output:** Validated facts corpus (with verification tags: `VERIFIED` / `INFERRED` / `UNKNOWN`)

### Phase 3: Classify & Structure

1. Assign each fact to reference primitive type (INDEX, ARCHITECTURE, FILE, SETTINGS, CAPABILITIES, GLOSSARY)
2. Organize into tables/lists per primitive format
3. Generate stable anchors using naming convention
4. Add metadata (timestamps, checksums, source pointers)

**Output:** Draft reference material (6 files in /ai/)

### Phase 4: Quality Gates

1. **Verification gate:** All paths, function names, constants verified
2. **Anchor gate:** All anchors unique, valid, stable
3. **Hallucination gate:** No invented content, explicit unknowns
4. **Schema gate:** YAML valid, markdown valid, tables complete
5. **Cognitive load gate:** Word counts, heading depth, table sizes
6. **Cross-reference gate:** Links reachable, index complete
7. **Metadata gate:** Timestamps, checksums, versions recorded

**Decision:** All gates pass → Release. Any gate fails → Return to developer with detailed errors.

---

## Outputs

| File | Format | Purpose | Size |
|------|--------|---------|------|
| `ai/AI_INDEX.md` | Markdown | Navigation entry point | 200–300 words |
| `ai/architecture.md` | Markdown | Structural & flow description | 600–900 words |
| `ai/file_index.md` | Markdown | File-to-responsibility mapping | 500–1,200 words |
| `ai/settings_schema.yaml` | YAML | Configuration authority | 300–800 words |
| `ai/capabilities_map.md` | Markdown | Feature-to-implementation mapping | 400–800 words |
| `ai/glossary.md` | Markdown | Terminology grounding | 300–600 words |

**Total:** 2,300–5,300 words (optimized for RAG context windows)

---

## Quality Gates & Specification

For detailed quality gates, non-invention rules, hallucination mitigation strategy, acceptance criteria, and developer notes, see [SPECIFICATION.md](SPECIFICATION.md).

---

## Implementation References

- **Structure & Primitives:** [REFERENCE_SPEC_01_STRUCTURE.md](specs/REFERENCE_SPEC_01_STRUCTURE.md)
- **Guardrails & Rules:** [REFERENCE_SPEC_02_GUARDRAILS.md](specs/REFERENCE_SPEC_02_GUARDRAILS.md)
- **Evaluation & QA:** [REFERENCE_SPEC_03_EVALUATION.md](specs/REFERENCE_SPEC_03_EVALUATION.md)
- **Research Foundation:** [REFERENCE_DESIGN_2026-03.md](../../.github/architecture/REFERENCE_DESIGN_2026-03.md) *(archived)*
- **Agent Skill Dev:** [RESEARCH_FINDINGS_2026-03.md](../../.github/architecture/RESEARCH_FINDINGS_2026-03.md) *(archived)*
- **Generation Strategy:** [REFERENCE_GENERATION_STRATEGY.md](specs/REFERENCE_GENERATION_STRATEGY.md)

---

## Developer Notes

This skill is designed to be:

- **Deterministic:** Same input → same output structure (not a chatbot)
- **Verifiable:** All outputs checksum-tracked and version-aware
- **Continuous:** Can regenerate when README updates (via changelog triggers)
- **Auditable:** Every claim traceable to source README or code
- **Safe:** Multiple gates prevent hallucination before release

**Failure modes handled:**

- Missing files: Mark as "Unknown"
- Ambiguous delegates: Investigate; if unresolvable, mark as "Unknown"
- Conflicts: Use authority hierarchy; document in changelog
- Parse errors: Halt with detailed error; require manual inspection

---

## End
