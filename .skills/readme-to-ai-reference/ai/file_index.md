<!-- DOC:FILE:FILES -->
# File Index: Skill Implementation

**Generated:** 2026-03-01T15:00:00Z  
**Source:** .skills/readme-to-ai-reference/SKILL.md v1.0.0

---

## Module Implementation Files

| File Path | Responsibility | Key Functions | Delegates To | Called By | Anchor |
|-----------|-----------------|----------------|--------------|-----------|--------|
| .skills/readme-to-ai-reference/SKILL.md | Skill manifest and specification | N/A (metadata) | N/A | GitHub Copilot | <!-- DOC:FILE:SKILL_MANIFEST --> |
| .github/copilot/REFERENCE_SPEC_01_STRUCTURE.md | Reference primitive types and chunking limits | N/A (spec) | N/A | Developers | <!-- DOC:FILE:SPEC_01 --> |
| .github/copilot/REFERENCE_SPEC_02_GUARDRAILS.md | Non-invention rules and quality gates | N/A (spec) | N/A | Developers | <!-- DOC:FILE:SPEC_02 --> |
| .github/copilot/REFERENCE_SPEC_03_EVALUATION.md | Evals framework and metrics | N/A (spec) | N/A | Developers | <!-- DOC:FILE:SPEC_03 --> |
| Unknown | Extraction module (parse README) | parse_markdown(), extract_assertions() | Validation module | Main workflow | <!-- DOC:FILE:UNKNOWN_001 --> |
| Unknown | Validation module (verify facts) | verify_file_paths(), verify_functions(), mark_unknown() | Structuring module | Extraction | <!-- DOC:FILE:UNKNOWN_002 --> |
| Unknown | Structuring module (format refs) | assign_to_primitive(), generate_anchors() | Quality Gates | Validation | <!-- DOC:FILE:UNKNOWN_003 --> |
| Unknown | Quality Gates module (validate output) | gate_verification(), gate_anchor_validity() | Release handler | Structuring | <!-- DOC:FILE:UNKNOWN_004 --> |

---

## Output Reference Material Files

| File Path | Responsibility | Key Outputs | Format | Size |
|-----------|-----------------|-------------|--------|------|
| ai/AI_INDEX.md | Navigation entry point and system overview | Links to all primitives, authority hierarchy | Markdown | 200–300 words |
| ai/architecture.md | Lifecycle phases, modules, execution flow | Phase diagrams, module boundaries, data flow | Markdown | 600–900 words |
| ai/file_index.md | File-to-responsibility mapping | Table: file_path, responsibility, functions | Markdown | 500–1,200 words |
| ai/settings_schema.yaml | Configuration authority and defaults | YAML list: category, constant_name, type | YAML | 300–800 words |
| ai/capabilities_map.md | Feature-to-implementation mapping | Table: feature, files, functions, settings | Markdown | 400–800 words |
| ai/glossary.md | Terminology and definitions | Terms with definitions, usage, related links | Markdown | 300–600 words |

---

## Implementation Status

**Fully Implemented:**
- ✅ SKILL.md (manifest and specification)
- ✅ REFERENCE_SPEC files (structure, guardrails, evaluation)
- ✅ This reference material (ai/* files for the skill itself)

**Partially Implemented:**
- 🔶 Extraction module — Unknown (code not in scope)
- 🔶 Validation module — Unknown (code not in scope)
- 🔶 Structuring module — Unknown (code not in scope)
- 🔶 Quality Gates module — Unknown (code not in scope)

**Deployment Status:**
- 🟢 Skill scaffold available at: `.skills/readme-to-ai-reference/SKILL.md`
- 🟢 Specifications available in `.github/copilot/`
- 🟢 Example reference material available at: `.skills/readme-to-ai-reference/ai/`

---

## Next Steps

| Step | Owner | Status |
|------|-------|--------|
| 1. Implement extraction module (Python/TypeScript) | Skill developer | 🔲 TODO |
| 2. Implement validation module | Skill developer | 🔲 TODO |
| 3. Implement structuring module | Skill developer | 🔲 TODO |
| 4. Implement quality gates | Skill developer | 🔲 TODO |
| 5. Test with sample README | QA | 🔲 TODO |
| 6. Run evals suite (4+ tests) | QA | 🔲 TODO |
| 7. Deploy to Copilot marketplace | DevOps | 🔲 TODO |

---

## End
