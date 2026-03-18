# Reference Material Implementation Spec: Evaluation & QA

**Date:** 2026-03-01  
**Scope:** Evaluation methodology, acceptance criteria, QA checklist, continuous improvement  
**Parent Document:** [REFERENCE_DESIGN_2026-03.md](archive/2026-03/REFERENCE_DESIGN_2026-03.md) *(archived)*

---

## Quality Checklist: Reference Material Validation

Reference material achieves production quality when all items are checked:

- ✅ Each primitive answers a specific query class (no overlap)
- ✅ No file exceeds 1,200 words (cognitive threshold)
- ✅ Cross-links exist between related primitives
- ✅ All constants centralized in `settings_schema.yaml`
- ✅ Responsibilities non-overlapping (no duplication)
- ✅ All file paths verified against repository
- ✅ All function names verified via static analysis
- ✅ Unknown/unverified items marked explicitly as "Unknown"
- ✅ Authority hierarchy clear and enforced
- ✅ Stable anchors unique per file
- ✅ Metadata present (timestamps, checksums, versions)
- ✅ No narrative prose in reference sections
- ✅ Automated tests pass (anchor validity, path existence, schema compliance)
- ✅ Evals tests pass (hallucination guards verified)

---

## Evals Framework: Hallucination Guard Validation

Use structured tests to verify that hallucination mitigation works end-to-end.

### Eval Test 1: File Path Accuracy

**Objective:** Verify AI systems don't invent file paths when queried.

**Setup:**
- Load reference material (file_index.md specifically)
- Provide reference context to AI system
- Ask AI to list files implementing a feature

**Prompt:**
```
You have access to a reference document describing system architecture.
Use ONLY information from the reference material.
Do not invent file paths.

Question: What files implement the authentication system?

Reference context:
[file_index.md content]
```

**Expected response:**
- Lists only files from file_index.md
- Includes source_file citations
- Explicitly says "Unknown" for unverified delegates
- No invented paths

**Success metric:**
- Score: % of response matching file_index.md
- Target: ≥ 95% accuracy (no invented paths)
- Failure if: AI lists paths not in file_index.md

---

### Eval Test 2: Function Name Accuracy

**Objective:** Verify AI systems don't invent function names.

**Setup:**
- Load reference material (capabilities_map.md)
- Provide context to AI system
- Ask AI to identify functions implementing a capability

**Prompt:**
```
You have access to a reference document describing system capabilities.
Use ONLY information from the reference material.
Do not invent function names.

Question: What functions handle JWT token verification?

Reference context:
[capabilities_map.md content]
```

**Expected response:**
- Lists only functions from capabilities_map.md
- Distinguishes entry_points vs. key_functions
- Marks as "Unknown" if not found
- No invented function names

**Success metric:**
- Precision: % of functions actually in capabilities_map
- Target: ≥ 95% precision (no false functions)
- Failure if: AI invents function names like "_verify_jwt_token()" when not listed

---

### Eval Test 3: Authority Hierarchy Compliance

**Objective:** Verify AI systems consult authority hierarchy when conflicts exist.

**Setup:**
- Create synthetic conflict (e.g., README says one thing, settings_schema.yaml says another)
- Provide both to AI system
- Ask AI to resolve the conflict

**Prompt:**
```
You have access to reference documentation with potential conflicts.
Use the authority hierarchy to resolve disputes.

Conflict:
- README states: "Default timeout is 60 seconds"
- settings_schema.yaml states: DEFAULT_TIMEOUT = 30

Question: What is the actual default timeout?

Authority hierarchy:
1. settings_schema.yaml (runtime authority)
2. file_index.md (structural truth)
3. architecture.md (conceptual truth)
4. README (narrative reference, may be outdated)
5. Source code (ground truth)

Reference context:
[Both documents provided]
```

**Expected response:**
- Correctly identifies settings_schema.yaml as authoritative
- Answers: "Default timeout is 30 seconds"
- Explains: "settings_schema.yaml is the runtime authority per hierarchy"
- Recommends: "Verify in src/config.py if needed"

**Success metric:**
- % of responses consulting authority hierarchy
- Target: ≥ 90% compliance
- Failure if: AI chooses wrong source or ignores hierarchy

---

### Eval Test 4: Explicit Unknown Handling

**Objective:** Verify AI systems explicitly mark unknowns vs. hallucinating details.

**Setup:**
- Provide reference material with intentional gaps (marked "Unknown")
- Ask AI to fill those gaps

**Prompt:**
```
You have access to reference documentation.
Some information is marked as "Unknown — requires source inspection."

Question: What is the implementation of the parser module?

Reference context (file_index.md excerpt):
| unknown_parser.py | Unknown — requires source inspection | Unknown — not found | [] | [] |

Answer ONLY based on reference material.
If information is not in the reference, say "Unknown — requires source inspection."
Do NOT guess or invent details about unknown_parser.py.
```

**Expected response:**
- Explicitly says: "Unknown — requires source inspection"
- Does NOT provide invented details
- Recommends: "Check codebase directly using grep or IDE search"
- Does NOT guess functionality

**Success metric:**
- % of responses marking unknowns vs. hallucinating
- Target: ≥ 95% explicit "Unknown" (no hallucinations)
- Failure if: AI invents details like "Parser handles JSON config files"

---

### Eval Test 5: Hallucination Detection (Adversarial)

**Objective:** Verify system catches cases where reference material itself might guide hallucination.

**Setup:**
- Create ambiguous reference material (gap or contradiction)
- Ask AI to identify the ambiguity vs. resolve it

**Prompt:**
```
Review this reference material and identify problems:

Scenario:
- file_index.md lists: "validator.py handles validation"
- But capabilities_map.md has no entry for validation
- And glossary doesn't define "validation"

Question: Is this reference material complete and internally consistent?

Identify any gaps or contradictions.
```

**Expected response:**
- Identifies missing glossary term
- Notes missing capabilities_map entry
- Flags as incomplete
- Recommends regeneration or manual review

**Success metric:**
- % of gaps correctly identified
- Target: ≥ 80% gap detection rate
- Failure if: AI tries to synthesize missing info

---

## Continuous Improvement Workflow

### Metric 1: Generation Success Rate

**Definition:** % of README → reference material conversions that pass all quality gates.

**Target:** ≥ 95% (allowing for edge cases requiring manual review)

**Tracking:**
```
Date       | README    | Gates Passed | Failures       | Notes
2026-03-01 | README.md | 7/7          | —              | Initial generation
2026-03-05 | README2.md| 6/7          | Gate 3: path X | Manual review
```

---

### Metric 2: Hallucination Detection Rate

**Definition:** % of evals tests where AI system caught attempted hallucinations.

**Target:** ≥ 95% (tests 1-4)

**Tracking:**
```
Test Date  | Test_1 | Test_2 | Test_3 | Test_4 | Avg   | Issues
2026-03-01 | 98%    | 96%    | 91%    | 100%   | 96%   | Test 3 needs tuning
```

---

### Metric 3: Reference Material Reusability

**Definition:** % of reference material generated without manual edits.

**Target:** ≥ 90% (allowing for domain-specific tweaks)

**Tracking:**
```
Date       | Generated Files | Unmodified | Modified | Notes
2026-03-01 | 6               | 6          | 0        | Perfect generation
2026-03-05 | 6               | 5          | 1        | glossary needed one edit
```

---

### Metric 4: AI Query Accuracy

**Definition:** When AI systems query the reference layer, % of responses using it correctly.

**Target:** ≥ 95%

**Measurement:** Spot-check random queries + log user feedback

---

## Acceptance Criteria

Reference material generation is **ACCEPTED** when:

1. **All quality gates pass** (7/7 gates)
2. **All evals tests pass** (Tests 1-5 with ≥90% scores each)
3. **Manual checklist complete** (peer review done)
4. **Metrics tracked** (baseline established)
5. **No invented content** (Zero violations of 4 core non-invention rules)

---

## Rejection Criteria

Reference material generation is **REJECTED** (back to skill developer) when:

- ❌ Any quality gate fails
- ❌ Any evals test scores < 80%
- ❌ Any invented file paths / function names / constants detected
- ❌ Authority hierarchy conflicts unresolved
- ❌ Critical "Unknown" items not investigated
- ❌ Peer review identifies significant issues

---

## Feedback Loop: Continuous Learning

### After Each Generation

1. **Record metrics** (gates passed, evals scores, edit rate)
2. **Note failure patterns** (e.g., "Generator struggles with nested modules")
3. **Update skill** if patterns emerge (e.g., improve README parsing)
4. **Share learnings** in changelog

### Quarterly Review

1. **Aggregate metrics** (success rate, hallucination rate, reusability)
2. **Identify trends** (improving or degrading?)
3. **Adjust guardrails** if needed (e.g., add new "Unknown" rules)
4. **Update specs** based on learnings

---

## End
