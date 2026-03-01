<!-- DOC:GLOSSARY:TERMS -->
# Glossary: Terminology & Definitions

**Generated:** 2026-03-01T15:00:00Z  
**Source:** .skills/readme-to-ai-reference/SKILL.md v1.0.0

---

### AI Reference Material

**Definition:** Machine-queryable, structured documentation derived from human README files. Consists of 6 reference primitive types designed to minimize hallucination and optimize retrieval for AI systems.

**Canonical form:** "AI Reference Layer" or "Reference Material"

**Related:** Reference Primitives, Diátaxis, Hallucination Mitigation

**Used in:** AI_INDEX.md, architecture.md (system overview)

**Example:** The /ai/ directory containing AI_INDEX.md, architecture.md, file_index.md, settings_schema.yaml, capabilities_map.md, glossary.md

<!-- DOC:GLOSSARY:AI_REFERENCE_MATERIAL -->

---

### Anchor

**Definition:** HTML comment in markdown used for stable, programmatic cross-referencing. Format: `<!-- DOC:TYPE:ID -->`

**Canonical form:** "Stable anchor" or "Documentation anchor"

**Related:** Documentation, Metadata, Cross-linking

**Used in:** All reference primitive files

**Example:** `<!-- DOC:FILE:FILE_001 -->`

<!-- DOC:GLOSSARY:ANCHOR -->

---

### Authority Hierarchy

**Definition:** Precedence order for resolving conflicting information: settings_schema.yaml (1, highest) → file_index.md (2) → architecture.md (3) → README (4) → Source code (5, lowest).

**Canonical form:** "Hierarchy" or "Source-of-truth precedence"

**Related:** Conflict Resolution, Grounding, Hallucination Mitigation

**Used in:** REFERENCE_SPEC_02_GUARDRAILS.md

**Example:** If README says "timeout=60" but settings_schema.yaml says "timeout=30", use 30 (settings_schema wins)

<!-- DOC:GLOSSARY:AUTHORITY_HIERARCHY -->

---

### Capability

**Definition:** User-visible feature or system behavior that is implemented through files, functions, and settings.

**Canonical form:** "Feature" or "Capability"

**Related:** Capabilities Map, Implementation, Feature

**Used in:** capabilities_map.md

**Example:** "JWT Authentication" is a capability implemented in auth.py and middleware.py

<!-- DOC:GLOSSARY:CAPABILITY -->

---

### Checksum

**Definition:** Hash value (MD5, SHA256) of generated reference material used to detect changes and trigger regeneration.

**Canonical form:** "Hash" or "Change detection hash"

**Related:** Metadata, Version Tracking, Regeneration

**Used in:** Reference file metadata

**Example:** CHECKSUM: 7a3d2f91e5a8c9b4

<!-- DOC:GLOSSARY:CHECKSUM -->

---

### Cognitive Load

**Definition:** Mental effort required to parse and understand documentation. Mitigated through word count limits, heading depth limits, and table size limits.

**Canonical form:** "Cognitive overload" (negative form) or "Readability"

**Related:** Chunking Strategy, Reference Primitive, Quality Gate

**Used in:** REFERENCE_SPEC_01_STRUCTURE.md

**Example:** Limit files to 1,200 words and tables to 20 rows to prevent cognitive overload

<!-- DOC:GLOSSARY:COGNITIVE_LOAD -->

---

### Diátaxis

**Definition:** Framework for organizing documentation into four types: Tutorial (learning), How-to (tasks), Reference (lookup), Explanation (understanding).

**Canonical form:** "Diátaxis framework" (exact spelling)

**Related:** Documentation Architecture, Content Separation, README Conversion

**Used in:** REFERENCE_DESIGN_2026-03.md

**Example:** README = Tutorial + How-to + Explanation; AI Reference Material = Reference (pure lookup)

<!-- DOC:GLOSSARY:DIATAXIS -->

---

### Hallucination

**Definition:** LLM behavior of generating plausible-sounding but false information (invented file paths, function names, constants) not present in source material.

**Canonical form:** "Hallucination" (standard AI terminology)

**Related:** Non-Invention Rules, Grounding, Authority Hierarchy, "Unknown" Markers

**Used in:** REFERENCE_SPEC_02_GUARDRAILS.md, REFERENCE_SPEC_03_EVALUATION.md

**Example:** Skill generates "src/utils/validate.py" when file doesn't exist (hallucination)

<!-- DOC:GLOSSARY:HALLUCINATION -->

---

### Quality Gate

**Definition:** Automated validation checkpoint (one of 7) that reference material must pass before release: Verification, Anchor Validity, Hallucination Guards, Schema Compliance, Cognitive Load, Cross-References, Metadata.

**Canonical form:** "Quality gate" or "Validation gate"

**Related:** Quality Checklist, Acceptance Criteria, Release Procedure

**Used in:** REFERENCE_SPEC_02_GUARDRAILS.md

**Example:** Gate 1 (Verification) checks that all file paths listed in file_index.md actually exist

<!-- DOC:GLOSSARY:QUALITY_GATE -->

---

### Reference Primitive

**Definition:** One of 6 fundamental reference material types: INDEX, ARCHITECTURE, FILE INDEX, SETTINGS SCHEMA, CAPABILITIES MAP, GLOSSARY.

**Canonical form:** "Primitive" (short) or "Reference Primitive Type"

**Related:** AI Reference Material, Diátaxis, Structuring

**Used in:** REFERENCE_SPEC_01_STRUCTURE.md

**Example:** file_index.md is a Reference Primitive of type FILE INDEX

<!-- DOC:GLOSSARY:REFERENCE_PRIMITIVE -->

---

### Rule 1: Never Invent File Paths

**Definition:** Core non-invention constraint: only list files that exist in the repository. Unverified files marked as "Unknown — requires inspection."

**Canonical form:** "Rule 1" or "File Path Non-Invention Rule"

**Related:** Non-Invention Rules, Hallucination Mitigation, Quality Gate 3

**Used in:** REFERENCE_SPEC_02_GUARDRAILS.md, REFERENCE_SPEC_03_EVALUATION.md

**Example:** Do NOT write "src/parser.py" if file doesn't exist; write "Unknown — src/parser.py not verified"

<!-- DOC:GLOSSARY:RULE_1 -->

---

### Rule 2: Never Invent Function Names

**Definition:** Core non-invention constraint: only list functions found in source code via static analysis. Unverified functions marked as "Unknown — not found in static analysis."

**Canonical form:** "Rule 2" or "Function Name Non-Invention Rule"

**Related:** Non-Invention Rules, Hallucination Mitigation, Static Analysis

**Used in:** REFERENCE_SPEC_02_GUARDRAILS.md

**Example:** Do NOT write "validate_input()" if function is actually "validate()"; use exact name

<!-- DOC:GLOSSARY:RULE_2 -->

---

### Rule 3: Never Invent Constants

**Definition:** Core non-invention constraint: all constants/settings must exist in codebase with verifiable default values.

**Canonical form:** "Rule 3" or "Constant Non-Invention Rule"

**Related:** Non-Invention Rules, settings_schema.yaml, Source Code Verification

**Used in:** REFERENCE_SPEC_02_GUARDRAILS.md

**Example:** Do NOT assume DEFAULT_TIMEOUT=60; verify actual default in src/config.py first

<!-- DOC:GLOSSARY:RULE_3 -->

---

### Rule 4: Mark Unknown Explicitly

**Definition:** Core non-invention constraint: unverified information must be explicitly marked "Unknown — requires source inspection." Never leave blank or guess.

**Canonical form:** "Rule 4" or "Explicit Unknown Marking"

**Related:** Non-Invention Rules, "Unknown" Markers, Hallucination Mitigation

**Used in:** REFERENCE_SPEC_02_GUARDRAILS.md

**Example:** Unknown — requires source inspection; Recommendation: Check src/business_logic.py for current delegate

<!-- DOC:GLOSSARY:RULE_4 -->

---

### Unknown Marker

**Definition:** Standard phrase "Unknown — requires source inspection" used to mark unverified information in reference material instead of inventing details.

**Canonical form:** "Unknown" (always this exact phrase)

**Related:** Rule 4, Hallucination Mitigation, Explicit Marking

**Used in:** All reference primitive files

**Example:** `description: "Unknown — requires source inspection"`

<!-- DOC:GLOSSARY:UNKNOWN_MARKER -->

---

## Cross-Reference Index

- **Hallucination prevention:** See Quality Gate 3 (Hallucination Guards), Rules 1–4
- **Authority hierarchy:** See REFERENCE_SPEC_02_GUARDRAILS.md
- **Reference primitives:** See REFERENCE_SPEC_01_STRUCTURE.md
- **Evals and metrics:** See REFERENCE_SPEC_03_EVALUATION.md
- **Full research:** See REFERENCE_DESIGN_2026-03.md

---

## End
