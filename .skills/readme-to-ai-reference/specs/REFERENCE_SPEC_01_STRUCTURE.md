# Reference Material Implementation Spec: Structure & Primitives

**Date:** 2026-03-01  
**Scope:** Reference primitive definitions, file structure, chunking limits, anchor conventions  
**Parent Document:** [REFERENCE_DESIGN_2026-03.md](archive/2026-03/REFERENCE_DESIGN_2026-03.md) *(archived)*

---

## Reference Primitive Types (6 Types)

All reference material is composed from these six primitive types. Each answers a specific query class.

### Type 1: INDEX (Canonical Entry Point)

**File:** `ai/AI_INDEX.md`  
**Purpose:** Machine-readable system overview and navigation authority.

**Contains:**
- System overview (2–5 bullet points, precise)
- Navigation index to all primitives
- Source-of-truth hierarchy explicit definition
- Links to reference primitives
- Stable anchors for programmatic access
- Generation metadata (timestamp, version, checksum)

**Example anchor:** `<!-- DOC:INDEX:NAVIGATION -->`

**Query class:** "What is this system?" / "Where do I find X documentation?" / "What reference layers exist?"

**Word count target:** 200–300 words

---

### Type 2: ARCHITECTURE SPECIFICATION

**File:** `ai/architecture.md`  
**Purpose:** Deterministic structural and operational description.

**Contains:**
- Lifecycle phases (init → run → shutdown)
- Module/component boundaries
- Execution flow (preconditions → action → postcondition)
- Delegate relationships and responsibility flow
- Deterministic anchor IDs per phase
- Generation metadata

**Example anchor:** `<!-- DOC:ARCH:LIFECYCLE_PHASES -->`

**Query class:** "What modules exist?" / "How does X communicate with Y?" / "What is execution order?"

**Word count target:** 600–900 words

---

### Type 3: FILE INDEX

**File:** `ai/file_index.md`  
**Purpose:** Precise file-to-responsibility mapping (prevents "Where is X?" hallucinations).

**Format:** Markdown table with anchored rows

**Columns:**
- `file_path`: Exact path relative to repo root
- `responsibility`: 1–2 sentence purpose
- `key_functions`: Function/method names (no descriptions)
- `delegates_to`: Files this file calls/depends
- `called_by`: Files that call this file
- `anchor_id`: Programmatic reference (e.g., `FILE_001`)

**Example row:**
```
| src/parser.py | Parses configuration files | parse_config(), validate() | src/config.py | src/main.py | <!-- DOC:FILE:FILE_001 --> |
```

**Query class:** "Where is X implemented?" / "What files handle Y?" / "Who calls function_z?"

**Row count target:** 10–25 rows  
**Total word count:** 500–1,200 words

---

### Type 4: SETTINGS SCHEMA

**File:** `ai/settings_schema.yaml`  
**Purpose:** Machine-readable configuration authority (prevents invented setting names/values).

**Structure:** YAML list of settings with metadata

**Per-setting fields:**
- `category`: Logical group (e.g., "networking", "performance")
- `constant_name`: Exact identifier in code
- `type`: Data type (string, integer, boolean, enum, list)
- `default_value`: Factory default
- `unit`: Measurement unit (if applicable)
- `description`: 1–2 sentences
- `source_file`: File defining/using this constant
- `used_by`: Files that reference it
- `example_value`: Representative usage (optional)
- `anchor_id`: Programmatic reference (e.g., `SETTING_001`)

**Example setting:**
```yaml
- category: "networking"
  constant_name: "DEFAULT_TIMEOUT"
  type: "integer"
  default_value: 30
  unit: "seconds"
  description: "HTTP request timeout in seconds"
  source_file: "src/config.py"
  used_by:
    - "src/api.py"
    - "src/client.py"
  example_value: 60
  anchor_id: "SETTING_001"
```

**Query class:** "What settings affect X?" / "What is default for Y?" / "Where is constant Z defined?"

**Setting count target:** 20–50 settings  
**Total word count:** 300–800 words

---

### Type 5: CAPABILITIES MAP

**File:** `ai/capabilities_map.md`  
**Purpose:** Feature-to-implementation mapping (prevents cross-module hallucination).

**Format:** Markdown table with cross-links

**Columns:**
- `capability`: User-visible feature (e.g., "JWT Authentication")
- `files_involved`: Primary implementation files
- `entry_points`: Functions users call
- `key_functions`: Internal functions
- `settings`: Related configuration
- `examples`: Example file paths (if applicable)
- `anchor_id`: Programmatic reference (e.g., `CAP_001`)

**Example row:**
```
| JWT Authentication | src/auth.py, src/middleware.py | authenticate() | _verify_token(), _extract_claims() | JWT_SECRET, TOKEN_EXPIRY | examples/auth_test.py | <!-- DOC:CAP:CAP_001 --> |
```

**Query class:** "How is X feature implemented?" / "What files handle Y?" / "Is module Z responsible for W?"

**Feature count target:** 5–15 features  
**Total word count:** 400–800 words

---

### Type 6: GLOSSARY

**File:** `ai/glossary.md`  
**Purpose:** Terminology grounding (prevents semantic hallucination).

**Format:** Markdown definition list

**Per-term fields:**
- **Term:** Exact spelling/capitalization as used in codebase
- **Definition:** 1–3 sentences, precise
- **Symbol:** Canonical short form (e.g., "JWT")
- **Related terms:** Cross-links (e.g., "See also: Token expiration")
- **Source file(s):** Where term is defined/heavily used
- **Example:** Code or usage pattern (optional)
- **Anchor:** Programmatic reference (e.g., `GLOSSARY_001`)

**Example term:**
```markdown
### JWT (JSON Web Token)

**Definition:** A stateless authentication token containing claims and signature.

**Related:** Authentication, Token expiration, Claims

**Used in:** src/auth.py, src/middleware.py

**Example:** `token = jwt.encode(claims, JWT_SECRET)`

<!-- DOC:GLOSSARY:GLOSSARY_001 -->
```

**Query class:** "What does X mean?" / "Is term Y used in this codebase?" / "What is the correct spelling?"

**Term count target:** 15–30 terms  
**Total word count:** 300–600 words

---

## Chunking Strategy (Retrieval Optimization)

### Optimal Fragment Sizing

- **Reference file target:** 500–1,200 words per file
- **Table row target:** 5–20 rows per table
- **Heading depth:** Maximum H3 (avoid H4 nesting to prevent cognitive overload)
- **Code block size:** ≤10 lines (larger examples link to source files)

### Format Principles

- **Avoid narrative prose** in reference files
- **Prefer tables** for structured data (file index, settings schema)
- **Prefer lists** for unordered relationships (capabilities map)
- **Use bullet points** for parallel concepts
- **Add stable comment anchors:** `<!-- DOC:MAP:CAPABILITIES -->`

### Metadata for Retrieval

Each primitive should include:
- **Internal ID:** `<!-- DOC:TYPE:IDENTIFIER -->`
- **Generation timestamp:** `Generated: 2026-03-01T14:30:00Z`
- **Source version:** Reference which README/source version produced this
- **Checksum or hash:** Enable change detection for regeneration

---

## Anchor Naming Conventions

All anchors follow this pattern for stability and programmatic access:

**Format:** `<!-- DOC:TYPE:IDENTIFIER -->`

**Type values:**
- `INDEX` — Sections in AI_INDEX.md
- `ARCH` — Sections in architecture.md
- `FILE` — Rows in file_index.md
- `SETTING` — Settings in settings_schema.yaml
- `CAP` — Rows in capabilities_map.md
- `GLOSSARY` — Terms in glossary.md

**Examples:**
```markdown
<!-- DOC:INDEX:NAVIGATION -->
<!-- DOC:ARCH:LIFECYCLE_PHASES -->
<!-- DOC:FILE:FILE_001 -->
<!-- DOC:SETTING:SETTING_001 -->
<!-- DOC:CAP:CAP_001 -->
<!-- DOC:GLOSSARY:JWT -->
```

**Rules:**
- Anchors must be unique within each file
- Anchors must survive regeneration (not change unless content changes)
- Anchors serve as programmatic cross-references

---

## Expected Output File Structure

```
/ai/
  ├── AI_INDEX.md              (200–300 words)
  ├── architecture.md          (600–900 words)
  ├── file_index.md            (500–1,200 words)
  ├── settings_schema.yaml     (300–800 words)
  ├── capabilities_map.md      (400–800 words)
  └── glossary.md              (300–600 words)

Total: 2,300–5,300 words (manageable for RAG + LLM context)
```

---

## Transformation Pipeline

**Input:** Human README (narrative, mixed content, conceptual)  
**↓**  
**Canonical Extraction:** Parse and categorize all factual assertions  
**↓**  
**Deterministic Structuring:** Map facts to reference primitive types  
**↓**  
**Output:** AI Reference Layer (structured, indexed, query-optimized, grounded)

---

## End
