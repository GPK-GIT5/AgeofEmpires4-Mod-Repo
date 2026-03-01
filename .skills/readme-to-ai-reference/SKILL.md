---
name: "README to AI Reference Material"
description: "Transforms human-readable READMEs into AI-optimized reference material (Diátaxis-based, hallucination-guarded, structured primitives)"
version: "1.0.0"
author: "Copilot Skill: readme-to-ai-reference"
keywords: ["documentation", "reference-material", "assistant", "readme", "hallucination-mitigation"]
---

# Skill: README to AI Reference Material

**Purpose:**  
Convert human-readable README.md files into machine-optimized AI reference material following deterministic, hallucination-guarded patterns.

**Input:** A README.md file describing a software system  
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

**Mode Details:** See [REFERENCE_GENERATION_STRATEGY.md](../../.github/copilot/REFERENCE_GENERATION_STRATEGY.md)

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

## Quality Gates (Must All Pass)

### Gate 1: Verification
- ✅ All file paths in file_index.md exist in repository
- ✅ All functions in capabilities_map.md found via static analysis
- ✅ All constants in settings_schema.yaml verified in source code

### Gate 2: Anchor Validity
- ✅ All anchors follow convention: `<!-- DOC:TYPE:ID -->`
- ✅ All anchors unique within each file
- ✅ All cross-links point to existing anchors

### Gate 3: Hallucination Guards
- ✅ No invented file paths
- ✅ No invented function names
- ✅ No invented constants
- ✅ Authority hierarchy enforced
- ✅ "Unknown" markers used for unverified content

### Gate 4: Schema Compliance
- ✅ settings_schema.yaml valid YAML 1.2
- ✅ file_index.md tables structurally valid
- ✅ capabilities_map.md tables complete
- ✅ glossary.md follows format conventions

### Gate 5: Cognitive Load
- ✅ No file exceeds 1,200 words
- ✅ Max heading depth is H3
- ✅ Table rows < 20 per table
- ✅ Code blocks ≤ 10 lines

### Gate 6: Cross-References
- ✅ All referenced files exist
- ✅ All anchor links reachable
- ✅ No orphaned sections
- ✅ AI_INDEX.md complete

### Gate 7: Metadata
- ✅ Generation timestamps recorded
- ✅ Source version identifier present
- ✅ Checksums for change detection
- ✅ Anchor IDs in all primitives

---

## Non-Invention Rules

**CRITICAL: These rules must be enforced for every output.**

### Rule 1: Never Invent File Paths
- Only list files present in repository
- Use exact relative paths
- Mark missing files: `"Unknown — requires source inspection"`

### Rule 2: Never Invent Function Names
- Only list functions found via static analysis
- Use exact names/signatures from codebase
- Mark unverified: `"Unknown — not found in static analysis"`

### Rule 3: Never Invent Constants/Settings
- All constants must exist in codebase
- Default values verified from source
- Type mismatches flagged immediately

### Rule 4: Mark Unknown Fields Explicitly
```
Unknown — requires source inspection.
Recommendation: Check [file] for current behavior.
```

---

## Hallucination Mitigation Strategy

### Authority Hierarchy (for conflict resolution)

```
1. settings_schema.yaml (runtime authority)
2. file_index.md (structural truth)
3. architecture.md (conceptual truth)
4. README (narrative, may be outdated)
5. Source code (ground truth for verification)
```

When sources conflict, consult this hierarchy rather than guessing.

### Explicit Unknown Markers

For any unverified information:
- ✍️ Write: `"Unknown — requires source inspection"`
- ✍️ Recommend: `"Check [source_file:line_number]"`
- ✍️ Never: Invent details, leave blank, or guess

### Pre-Release Checklist

Before releasing reference material:
- [ ] All quality gates pass
- [ ] Zero violations of non-invention rules
- [ ] Authority hierarchy conflicts resolved
- [ ] "Unknown" items investigated and justified
- [ ] Peer review completed
- [ ] Changelog entry created

---

## Acceptance Criteria

✅ **Reference material is ACCEPTED when:**

1. All 7 quality gates pass
2. All 4 non-invention rules verified
3. Hallucination evals tests pass (≥90%)
4. Manual peer review approved
5. Metrics tracked in changelog

❌ **Reference material is REJECTED when:**

- Any quality gate fails
- Any non-invention rule violated
- Evals tests score < 80%
- Authority hierarchy conflicts unresolved

---

## Implementation References

- **Structure & Primitives:** [REFERENCE_SPEC_01_STRUCTURE.md](../../copilot/REFERENCE_SPEC_01_STRUCTURE.md)
- **Guardrails & Rules:** [REFERENCE_SPEC_02_GUARDRAILS.md](../../copilot/REFERENCE_SPEC_02_GUARDRAILS.md)
- **Evaluation & QA:** [REFERENCE_SPEC_03_EVALUATION.md](../../copilot/REFERENCE_SPEC_03_EVALUATION.md)
- **Research Foundation:** [REFERENCE_DESIGN_2026-03.md](../../.github/copilot/archive/2026-03/REFERENCE_DESIGN_2026-03.md) *(archived)*
- **Agent Skill Dev:** [RESEARCH_FINDINGS_2026-03.md](../../.github/copilot/archive/2026-03/RESEARCH_FINDINGS_2026-03.md) *(archived)*
- **Generation Strategy:** [REFERENCE_GENERATION_STRATEGY.md](../../.github/copilot/REFERENCE_GENERATION_STRATEGY.md)

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
