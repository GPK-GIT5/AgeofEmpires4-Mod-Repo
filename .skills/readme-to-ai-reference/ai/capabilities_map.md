<!-- DOC:CAP:CAPABILITIES -->
# Capabilities Map: Feature to Implementation

**Generated:** 2026-03-01T15:00:00Z  
**Source:** .skills/readme-to-ai-reference/SKILL.md v1.0.0

---

## System Capabilities

| Capability | Files Involved | Entry Points | Key Functions | Related Settings | Examples |
|------------|-----------------|--------------|----------------|-------------------|----------|
| README Parsing | Extraction module | parse_readme() | parse_markdown(), extract_assertions() | Unknown | <!-- DOC:CAP:CAP_001 --> |
| Fact Validation | Validation module | validate_facts() | verify_file_paths(), verify_functions(), verify_constants(), mark_unknown() | HALLUCINATION_RULE_* | <!-- DOC:CAP:CAP_002 --> |
| Reference Structuring | Structuring module | structure_references() | assign_to_primitive(), format_tables(), generate_anchors(), add_metadata() | Unknown | <!-- DOC:CAP:CAP_003 --> |
| Quality Gate Execution | Quality Gates module | run_all_gates() | gate_verification(), gate_anchor_validity(), gate_hallucination_guards(), gate_schema_compliance() | GATE_* | <!-- DOC:CAP:CAP_004 --> |
| Hallucination Prevention | Validation + Quality Gates | prevent_hallucination() | mark_unknown(), verify_*, gate_hallucination_guards() | HALLUCINATION_RULE_* | <!-- DOC:CAP:CAP_005 --> |
| Authority Hierarchy Enforcement | Quality Gates module | enforce_hierarchy() | gate_verification(), resolve_conflicts() | Unknown | <!-- DOC:CAP:CAP_006 --> |
| Cognitive Load Management | Quality Gates module | check_cognitive_load() | gate_cognitive_load(), gate_max_word_count(), gate_max_table_rows() | GATE_MAX_* | <!-- DOC:CAP:CAP_007 --> |
| Output Validation | Quality Gates module | validate_output() | All 7 gate functions | Unknown | <!-- DOC:CAP:CAP_008 --> |
| Error Reporting | Release Handler | report_errors() | Unknown — requires code inspection | Unknown | <!-- DOC:CAP:CAP_009 --> |
| Metrics Tracking | Release Handler | track_metrics() | Unknown — requires code inspection | OUTPUT_TOTAL_WORD_BUDGET | <!-- DOC:CAP:CAP_010 --> |

---

## Feature Dependencies

**Feature: Hallucination Prevention**
- Depends on: Fact Validation, Authority Hierarchy Enforcement
- Enables: Quality Gate Execution, Output Validation
- Related settings: HALLUCINATION_RULE_1–4, GATE_UNKNOWN_THRESHOLD

**Feature: Quality Gate Execution**
- Depends on: Reference Structuring, Hallucination Prevention
- Enables: Output Validation, Metrics Tracking
- Related settings: GATE_MAX_*, EVALS_*_TARGET

**Feature: Authority Hierarchy Enforcement**
- Depends on: Fact Validation
- Enables: Quality Gate Execution
- Related: settings_schema.yaml (runtime authority), file_index.md (structural truth)

---

## End
