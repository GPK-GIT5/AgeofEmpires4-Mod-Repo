<!-- DOC:ARCH:LIFECYCLE -->
# Architecture: README to AI Reference Material Workflow

**Generated:** 2026-03-01T15:00:00Z  
**Source:** .skills/readme-to-ai-reference/SKILL.md v1.0.0

---

## Lifecycle Phases

### Phase 1: Initialization

**Trigger:** User provides README.md + repo structure + source code map  
**Precondition:** All inputs valid and accessible

| Step | Action | Output |
|------|--------|--------|
| 1.1 | Load and parse README.md | Markdown AST |
| 1.2 | Index repository file listing | File registry |
| 1.3 | Index functions/constants from code | Symbol registry |
| 1.4 | Initialize output structures | Empty /ai/ directory |

**Postcondition:** All registries loaded, ready for extraction

---

### Phase 2: Extraction

<!-- DOC:ARCH:EXTRACTION -->

**Precondition:** Initialization complete

| Step | Action | Output |
|------|--------|--------|
| 2.1 | Extract factual assertions from README | Facts corpus (unsanitized) |
| 2.2 | Categorize: structural, functional, config, terms | Categorized facts |
| 2.3 | Identify information gaps | Gap list |
| 2.4 | Cross-reference with code registries | Facts + verification status |

**Postcondition:** All README content extracted and categorized

**Example facts extracted:**
- "Parser module handles config validation" → Functional
- "Runs on Python 3.8+" → Configurational
- "JWT = JSON Web Token" → Terminological

---

### Phase 3: Validation

<!-- DOC:ARCH:VALIDATION -->

**Precondition:** Extraction complete

| Step | Action | Output |
|------|--------|--------|
| 3.1 | Verify file paths against repo | Path status (exists/missing) |
| 3.2 | Verify functions via symbol registry | Function status (found/unknown) |
| 3.3 | Verify constants/settings vs. code | Constant status (verified/unknown) |
| 3.4 | Mark unverified items as "Unknown" | Validated facts |

**Postcondition:** All facts marked with verification status

**Quality: If > 10% marked "Unknown", flag for review**

---

### Phase 4: Structuring

<!-- DOC:ARCH:STRUCTURING -->

**Precondition:** Validation complete

| Step | Action | Output |
|------|--------|--------|
| 4.1 | Assign facts to primitives (INDEX, ARCH, FILE, etc.) | Facts grouped by type |
| 4.2 | Format into tables/lists per primitive | Draft reference files |
| 4.3 | Generate stable anchor IDs | Anchored files |
| 4.4 | Add metadata (timestamps, checksums, versions) | Final draft files |

**Postcondition:** 6 reference material files ready for gates

**Files generated:**
- ai/AI_INDEX.md
- ai/architecture.md
- ai/file_index.md
- ai/settings_schema.yaml
- ai/capabilities_map.md
- ai/glossary.md

---

### Phase 5: Quality Gates

<!-- DOC:ARCH:QUALITY_GATES -->

**Precondition:** Structuring complete

| Gate # | Gate Name | Check | Failure Action |
|--------|-----------|-------|-----------------|
| 1 | Verification | All paths/functions/constants verified | Return to dev with list |
| 2 | Anchor validity | Unique, valid, stable anchors | Return to dev with locations |
| 3 | Hallucination guards | No invented content | Return to dev with examples |
| 4 | Schema compliance | Valid YAML/Markdown | Return to dev with errors |
| 5 | Cognitive load | Word counts, heading depth | Return to dev with sizes |
| 6 | Cross-references | Links reachable | Return to dev with broken links |
| 7 | Metadata | Timestamps, checksums | Return to dev with missing fields |

**Decision logic:**
- All gates PASS → **RELEASE** ✅
- Any gate FAIL → **REJECT** ❌ (back to developer)

**Postcondition:** Either released or returned with detailed errors

---

### Phase 6: Release / Revision

<!-- DOC:ARCH:RELEASE -->

**Branch 1: All gates PASS**
1. Record generation metrics in changelog
2. Move files to /ai/ (or equivalent destination)
3. Return SUCCESS with statistics
4. **END**

**Branch 2: Any gate FAILS**
1. Collect detailed error report
2. Point to specific offending content
3. Return ERRORS with remediation path
4. **LOOP BACK to Phase 4 (developer iterates)**

---

## Module Boundaries

### Extraction Module

**Responsibility:** Parse README, categorize facts  
**Delegates to:** Validation module  
**Called by:** Initialization

**Functions:**
- parse_markdown()
- extract_assertions()
- categorize_facts()

---

### Validation Module

**Responsibility:** Verify facts against code/repo  
**Delegates to:** Structuring module  
**Called by:** Extraction

**Functions:**
- verify_file_paths()
- verify_functions()
- verify_constants()
- mark_unknown()

---

### Structuring Module

**Responsibility:** Organize facts into references  
**Delegates to:** Quality Gates module  
**Called by:** Validation

**Functions:**
- assign_to_primitive()
- format_tables()
- generate_anchors()
- add_metadata()

---

### Quality Gates Module

**Responsibility:** Validate output against 7 gates  
**Delegates to:** Release/Revision  
**Called by:** Structuring

**Functions:**
- gate_verification()
- gate_anchor_validity()
- gate_hallucination_guards()
- gate_schema_compliance()
- gate_cognitive_load()
- gate_cross_references()
- gate_metadata()

---

## Data Flow

```
README.md + repo + code
    ↓
[Extraction] → Facts corpus
    ↓
[Validation] → Validated facts
    ↓
[Structuring] → Draft /ai/ files
    ↓
[Quality Gates] → PASS or FAIL
    ↓ (PASS)
/ai/ directory (released)
    ↓ (FAIL)
Error report → Developer (revise)
```

---

## Error Handling

**If extraction fails:** Return error with line number in README  
**If validation fails:** Queue for manual review (> 10% unknown)  
**If structuring fails:** Return schema error with details  
**If gates fail:** Return gate name + specific violations  

**Recovery:** Developer fixes issue, reruns skill (Phase 1 or 4 depending on error)

---

## End
