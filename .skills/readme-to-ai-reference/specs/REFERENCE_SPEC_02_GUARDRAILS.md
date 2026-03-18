# Reference Material Implementation Spec: Guardrails & Non-Invention Rules

**Date:** 2026-03-01  
**Scope:** Hallucination mitigation, authority hierarchy, non-invention constraints, quality gates  
**Parent Document:** [REFERENCE_DESIGN_2026-03.md](archive/2026-03/REFERENCE_DESIGN_2026-03.md) *(archived)*

---

## Core Non-Invention Rules

All AI reference material must enforce these constraints:

### Rule 1: Never Invent File Paths

**Constraint:** Only list files that exist in the repository.

**Enforcement:**
- Verify every file path against actual repository structure
- Use exact relative paths (verified via filesystem inspection)
- Mark missing/unknown files explicitly

**Example violation:** Listing `src/utils/parser.py` when the file doesn't exist

**Remediation:**
```
● WRONG: "Parsing handled in src/utils/parser.py"
● RIGHT: "Parsing handled in src/parser.py"
● RIGHT with uncertainty: "Unknown — src/utils/parser.py not found; check src/"
```

---

### Rule 2: Never Invent Function Names

**Constraint:** List only functions present in source code.

**Enforcement:**
- Verify function names via static code analysis
- Use exact names and signatures from codebase
- Mark uncertain functions explicitly

**Example violation:** Listing `validate_input()` when the function is actually `validate()`

**Remediation:**
```
● WRONG: "key_functions: validate_input(), parse_config()"
● RIGHT: "key_functions: validate(), parse_config()"
● RIGHT with uncertainty: "key_functions: Unknown — requires static analysis"
```

---

### Rule 3: Never Invent Constants or Settings

**Constraint:** All constants/settings must exist in codebase with verifiable default values.

**Enforcement:**
- Verify constant name against code
- Verify default value at generation time
- Flag type mismatches (e.g., "type is integer but default is a string")
- Only include constants actually used in the system

**Example violation:** Listing `MAX_RETRY=5` when the code uses `RETRY_ATTEMPTS=3`

**Remediation:**
```yaml
● WRONG:
  constant_name: "MAX_RETRY"
  default_value: 5
  
● RIGHT:
  constant_name: "RETRY_ATTEMPTS"
  default_value: 3
  type: "integer"
  source_file: "src/config.py"
  
● RIGHT with uncertainty:
  constant_name: "UNKNOWN_SETTING"
  default_value: "Unknown — not found in static analysis"
```

---

### Rule 4: Explicit "Unknown" Marking

**Constraint:** When information cannot be verified from source, mark explicitly.

**Enforcement:**
- Use consistent marker: `"Unknown — requires source inspection"`
- Include recommendation for where to look
- Never leave fields blank or with placeholder values

**Example:**
```
Unknown — requires source inspection.
Recommendation: Check [filename] line [line_number] for current behavior.
```

**Examples in context:**

**In file_index.md:**
```
| unknown_module.py | Unknown — requires source inspection | Unknown — not found | [] | [] | <!-- DOC:FILE:UNKNOWN_001 --> |
```

**In settings_schema.yaml:**
```yaml
- category: "unknown"
  constant_name: "UNKNOWN_CONSTANT"
  type: "Unknown — type not determined"
  default_value: "Unknown — requires code inspection"
  source_file: "Unknown — location not found"
```

**In glossary.md:**
```markdown
### UnknownTerm

**Definition:** Unknown — not clearly defined in source code.

**Used in:** Unknown — requires codebase search

**Recommendation:** Search for "UnknownTerm" in codebase to verify usage.

<!-- DOC:GLOSSARY:UNKNOWN_001 -->
```

---

## Authority Hierarchy

When information conflicts or is ambiguous, resolve using this hierarchy:

```
1. settings_schema.yaml (runtime authority)
2. file_index.md (structural truth)
3. architecture.md (conceptual truth)
4. README (narrative reference, may be outdated)
5. Source code (ground truth for verification)
```

### Hierarchy Rules

**Rule H1:** If settings_schema.yaml says DEFAULT=30 and README says "default is 60", use 30 (verify in code).

**Rule H2:** If file_index.md says module X delegates to Y, but architecture.md says no delegation, mark as conflicting and investigate code.

**Rule H3:** If README describes a feature as "handled by X" but file_index.md lists multiple files, defer to file_index (more specific).

**Rule H4:** If any primitive contradicts source code, flag as "Out of sync — requires regeneration."

### Conflict Resolution Template

When conflicts detected:
```
CONFLICT DETECTED:
  Source 1: [source] says [claim]
  Source 2: [source] says [contradictory^claim]
  
RESOLUTION:
  Authority: [which source wins per hierarchy]
  Action: [Accept from authoritative source / Mark as "Unknown"]
  Verification: [How to verify correct answer]
```

---

## Quality Gates (Pre-Release Checklist)

Reference material must pass these gates before release:

### Gate 1: Verification Tests

- ✅ All file paths in file_index.md exist in repository
- ✅ All function names in capabilities_map.md found via static analysis
- ✅ All constants in settings_schema.yaml exist in source code
- ✅ Default values match actual code defaults
- ✅ All source_file references are correct

**Test command:**
```bash
python validate_reference_material.py --check-paths --check-functions --check-constants
```

**Failure handling:** Block release; return detailed list of violations with remediation path.

---

### Gate 2: Anchor Validity Tests

- ✅ All anchors follow naming convention (DOC:TYPE:ID)
- ✅ All anchors are unique within their file
- ✅ All cross-references (links) point to existing anchors
- ✅ Anchors stable across regeneration (not randomized)

**Test command:**
```bash
python validate_reference_material.py --check-anchors
```

**Failure handling:** Block release; list duplicate or invalid anchors.

---

### Gate 3: Hallucination Guard Tests

- ✅ No narrative prose in reference sections (only tables/lists)
- ✅ No invented file paths (marked explicitly if unknown)
- ✅ No invented function names (marked explicitly if unknown)
- ✅ No invented constants (marked explicitly if unknown)
- ✅ Authority hierarchy clearly documented

**Test command:**
```bash
python validate_hallucination_guards.py --strict
```

**Failure handling:** Block release; point to specific offending content.

---

### Gate 4: Schema Compliance Tests

- ✅ settings_schema.yaml valid YAML 1.2 syntax
- ✅ file_index.md table rows have all required columns
- ✅ capabilities_map.md table rows complete
- ✅ glossary.md follows definition list format

**Test command:**
```bash
python validate_schema_compliance.py
```

**Failure handling:** Block release; show schema validation errors.

---

### Gate 5: Size & Cognitive Load Tests

- ✅ No file exceeds 1,200 words
- ✅ Max heading depth is H3 (no H4+)
- ✅ Table rows < 20 per table
- ✅ Code blocks ≤ 10 lines (or linked to source)

**Test command:**
```bash
python validate_cognitive_load.py
```

**Failure handling:** Block release; recommend splitting overly large files.

---

### Gate 6: Cross-Reference Integrity Tests

- ✅ All files mentioned in AI_INDEX.md exist
- ✅ Cross-links between primitives all valid
- ✅ No orphaned sections (unreferenced from index)
- ✅ Navigation hub (AI_INDEX.md) is complete

**Test command:**
```bash
python validate_cross_references.py
```

**Failure handling:** Block release; list unreachable sections.

---

### Gate 7: Metadata Completeness Tests

- ✅ Generation timestamp present in each file
- ✅ Source version identifier present
- ✅ Checksum or hash recorded (for change detection)
- ✅ Anchor IDs present in all primitives

**Test command:**
```bash
python validate_metadata.py
```

**Failure handling:** Block release; add missing metadata.

---

## Release Checklist (Manual)

Before releasing reference material, verify:

- [ ] All 7 quality gates pass
- [ ] Generated by skill with no manual edits (or edits documented)
- [ ] README source version recorded (enables regeneration tracking)
- [ ] Authority hierarchy conflicts resolved
- [ ] "Unknown" items investigated and justified
- [ ] Peer review completed (for first-time generation)
- [ ] Changelog entry created

**Release approval:** All gates pass + manual checklist complete = APPROVED FOR RELEASE

---

## Recovery Procedure: Handling Gate Failures

**If gates fail during generation:**

1. **Identify failing gate** (e.g., "Verification test: file_index.md includes non-existent path")
2. **Investigate root cause** (e.g., "README lists /src/utils/parser.py but file doesn't exist")
3. **Remediate** (e.g., "Remove from file_index; mark in glossary as 'Unknown'")
4. **Re-run gates** until all pass
5. **Document in changelog** (e.g., "Fixed file path mismatch: removed non-existent src/utils/parser.py")

**Do NOT release with failed gates.** This breaks hallucination guarantees.

---

## End
