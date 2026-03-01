# Reference Generation Strategy

**Date:** 2026-03-01  
**Scope:** Defines three generation modes for the `readme-to-ai-reference` skill  
**Parent Skill:** [SKILL.md](../../.skills/readme-to-ai-reference/SKILL.md)  
**Evaluation Spec:** [REFERENCE_SPEC_03_EVALUATION.md](REFERENCE_SPEC_03_EVALUATION.md)

---

## Purpose

The `readme-to-ai-reference` skill can generate reference material at different levels of detail and verification rigor. This document formalizes three generation modes, their tradeoffs, and the metadata system used to communicate confidence to downstream consumers.

---

## Metadata System

<!-- DOC:STRATEGY:METADATA -->

Every fact in generated reference material carries a verification tag. These tags appear inline, in table columns, or in YAML comments.

### Verification Tags

| Tag | Meaning | Format |
|-----|---------|--------|
| `VERIFIED` | Fact confirmed against source code or repository structure | `<!-- VERIFIED: method -->`  |
| `INFERRED` | Fact deduced from naming conventions, patterns, or README context | `<!-- INFERRED: basis -->` |
| `UNKNOWN` | Fact could not be confirmed; source inspection required | `Unknown — requires source inspection` |

### Timestamp

Every reference primitive includes a `LAST_VERIFIED` timestamp in its metadata header:

```markdown
**Last Verified:** 2026-03-01  
**Verification Method:** file_search, grep_search, PowerShell  
```

For YAML files, use a comment block:

```yaml
# LAST_VERIFIED: 2026-03-01
# VERIFICATION_METHOD: grep_search + source read
```

### Source Attribution

Each fact is attributed to exactly one primary source:

| Source Type | Format | Example |
|-------------|--------|---------|
| README | `SOURCE: README L42` | Line reference in source README |
| Repository | `SOURCE: FILE:path/to/file.ext` | Verified via file_search or list_dir |
| Source code | `SOURCE: CODE:path/file.ext:L42` | Verified via grep_search or read_file |
| Domain knowledge | `SOURCE: DOMAIN` | AoE4/SCAR conventions (no specific file) |

### Composite Example

```markdown
| File | Responsibility | Functions | Verification |
|------|---------------|-----------|--------------|
| `helpers/ags_teams.scar` | Team management API | `AGS_Teams_CreateInitialTeams()` | VERIFIED — CODE:helpers/ags_teams.scar:L74 |
| `helpers/ags_starts.scar` | Starting scenario utilities | Unknown — requires source inspection | INFERRED — README L290 |
```

```yaml
AGS_GS_TEAM_VICTORY_FFA:
  value: 0
  type: integer
  # VERIFIED — CODE:ags_global_settings.scar:L85
  # LAST_VERIFIED: 2026-03-01
```

---

## Generation Modes

<!-- DOC:STRATEGY:MODES -->

### Mode 1: Conservative (README-Only)

<!-- DOC:STRATEGY:CONSERVATIVE -->

#### Definition

Generate reference material using **only** the README and repository directory listing. No source files are read. Every implementation detail is marked `UNKNOWN`.

#### Specification

| Attribute | Value |
|-----------|-------|
| **Data Sources** | README.md, file_search, list_dir |
| **Hallucination Risk** | Minimal — no opportunity to invent details |
| **Utility Level** | Low — high density of `UNKNOWN` markers |
| **Verification Required** | Directory existence only |
| **Typical Unknown Count** | 50–150 per project |

#### When to Use

- Initial scaffold when no source access is available
- Rapidly changing codebases where details go stale within days
- Audit-sensitive environments requiring zero hallucination tolerance
- First pass before selective source inspection

#### Output Characteristics

- File paths: Only directory-level (`conditions/` not `conditions/ags_conquest.scar`)
- Functions: All marked `UNKNOWN`
- Constants: Names from README only; types and defaults `UNKNOWN`
- Delegates: All marked `UNKNOWN`
- Verification tags: `INFERRED` (from README) or `UNKNOWN`

#### Workflow Branch

```
Parse README → Validate Directories → Structure → Gates (skip Gate 1 func/const checks) → Release
```

Quality gates adjusted:
- Gate 1 (Verification): Paths only; functions and constants **deferred**
- Gate 3 (Hallucination): Strict — any unverified detail must be `UNKNOWN`
- Gates 2, 4–7: Applied normally

---

### Mode 2: Detailed (Source-Inspected)

<!-- DOC:STRATEGY:DETAILED -->

#### Definition

Generate reference material using README **plus** direct source code inspection. Read key files, extract function signatures, verify constants, trace delegate registrations.

#### Specification

| Attribute | Value |
|-----------|-------|
| **Data Sources** | README.md, file_search, list_dir, read_file, grep_search |
| **Hallucination Risk** | Medium — high specificity increases surface area for error |
| **Utility Level** | High — actionable file names, signatures, data structures |
| **Verification Required** | Full: paths, functions, constants, delegates |
| **Typical Unknown Count** | 5–20 per project (edge cases only) |

#### When to Use

- Stable codebases with infrequent structural changes
- Production reference material for developer-facing AI tools
- Projects where source code is fully available and readable
- When accuracy of function signatures and constants is critical

#### Output Characteristics

- File paths: Full paths with line counts (e.g., `helpers/ags_teams.scar (332 lines)`)
- Functions: Verified signatures with parameter names and return types
- Constants: Names, types, default values, and usage patterns
- Delegates: Registration order, phase assignments, callback names
- Verification tags: Predominantly `VERIFIED` with `SOURCE: CODE:path:L##`

#### Workflow Branch

```
Parse README → Inspect Source (read_file, grep_search) → Validate All → Structure → Full Gates → Release
```

Quality gates adjusted:
- Gate 1 (Verification): **Full enforcement** — all paths, functions, constants
- Gate 3 (Hallucination): Standard — unverified edge cases marked `UNKNOWN`
- Gate 5 (Cognitive Load): Monitor closely — detailed mode tends toward verbosity
- Gates 2, 4, 6, 7: Applied normally

#### Source Inspection Budget

To prevent runaway context consumption:

| Inspection Type | Budget | Priority |
|-----------------|--------|----------|
| Entry point files | Read full | Always |
| Config/settings files | Read full | Always |
| Core framework files | Read first 100 lines | High |
| Feature implementation files | grep for function defs | Medium |
| Utility/helper files | grep for exports | Low |
| Test/data files | Skip unless referenced | Lowest |

Maximum files read per generation: **10**  
Maximum grep searches per generation: **20**

---

### Mode 3: Hybrid (Recommended Default)

<!-- DOC:STRATEGY:HYBRID -->

#### Definition

Generate reference material using README for structure, with **selective** source inspection for high-value verification targets. Combines the safety of Conservative with the utility of Detailed.

#### Specification

| Attribute | Value |
|-----------|-------|
| **Data Sources** | README.md, file_search, list_dir, read_file (selective), grep_search (targeted) |
| **Hallucination Risk** | Low — verified where it matters, `INFERRED` elsewhere |
| **Utility Level** | High — key details verified, non-critical items marked clearly |
| **Verification Required** | Paths (all), functions (top 10–15), constants (documented subset) |
| **Typical Unknown Count** | 10–30 per project |

#### When to Use

- **Default mode** for most projects
- Codebases with good README documentation
- Projects where partial source access is practical
- When balancing accuracy with generation speed

#### Output Characteristics

- File paths: Full paths for core files; directory-level for periphery
- Functions: Verified for entry points and public API; `INFERRED` for internal helpers
- Constants: Verified for documented constants; `UNKNOWN` for undocumented
- Delegates: Verified for lifecycle phases; `INFERRED` for module-specific callbacks
- Verification tags: Mixed `VERIFIED` / `INFERRED` / `UNKNOWN` with clear ratios

#### Workflow Branch

```
Parse README → Validate Directories → Selective Source Inspection → Structure → Full Gates → Release
```

Quality gates adjusted:
- Gate 1 (Verification): Paths verified; functions/constants verified for **priority targets only**
- Gate 3 (Hallucination): Standard — `INFERRED` claims must cite basis
- All other gates: Applied normally

#### Selective Inspection Criteria

Inspect source code for these priority targets:

| Priority | Target | Method | Example |
|----------|--------|--------|---------|
| **P0** | Entry point file | read_file (full) | `ags_cardinal.scar` |
| **P0** | Global config file | read_file (full) | `ags_global_settings.scar` |
| **P1** | Core framework API | grep for function defs | `ags_conditions.scar` |
| **P1** | Primary helper modules | grep for exports | `ags_teams.scar` |
| **P2** | Feature implementations | grep for module registration | `conditions/*.scar` |
| **P3** | UI/peripheral modules | Skip (use README only) | `replay/*.scar` |

**Rule:** P0 targets are always inspected. P1 targets inspected if budget allows. P2/P3 use README-only data with `INFERRED` tags.

---

## Mode Comparison

<!-- DOC:STRATEGY:COMPARISON -->

| Dimension | Conservative | Detailed | Hybrid |
|-----------|-------------|----------|--------|
| **Data sources** | README + dirs | README + dirs + source | README + dirs + selective source |
| **Hallucination risk** | Minimal | Medium | Low |
| **Utility** | Low | High | High |
| **Unknown markers** | 50–150 | 5–20 | 10–30 |
| **Generation time** | Fast (~5 min) | Slow (~20 min) | Moderate (~10 min) |
| **Maintenance cost** | Low | High | Medium |
| **Files read** | 0 | 5–10 | 2–5 |
| **Grep searches** | 0 | 10–20 | 5–10 |
| **Best for** | Scaffolds, audits | Stable production | Default for most projects |
| **Accuracy** | 100% (nothing invented) | 99%+ (verified) | 95%+ (mix of verified + inferred) |

---

## Mode Selection Flowchart

```
Is source code available?
├── No → Conservative Mode
└── Yes
    ├── Is codebase stable (< monthly structural changes)?
    │   ├── Yes → Detailed Mode
    │   └── No → Hybrid Mode
    └── Is this the first generation?
        ├── Yes → Hybrid Mode (default)
        └── No (regeneration)
            ├── Major README change → Hybrid Mode
            └── Minor update → Conservative Mode (patch only changed sections)
```

---

## Verification Tag Distribution Targets

<!-- DOC:STRATEGY:TARGETS -->

Each mode should produce reference material with approximately this tag distribution:

| Tag | Conservative | Detailed | Hybrid |
|-----|-------------|----------|--------|
| `VERIFIED` | 10–20% | 80–95% | 40–60% |
| `INFERRED` | 20–30% | 5–15% | 30–40% |
| `UNKNOWN` | 50–70% | 0–5% | 10–20% |

If a generated output deviates by more than 15% from these targets, review the inspection budget and mode selection.

---

## Integration with SKILL.md

<!-- DOC:STRATEGY:INTEGRATION -->

### Config Parameter

```yaml
config:
  generation_mode: "hybrid"  # conservative | detailed | hybrid
```

### Workflow Branching

The skill workflow branches at Phase 2 (Validate Against Source) based on `generation_mode`:

| Phase | Conservative | Detailed | Hybrid |
|-------|-------------|----------|--------|
| **Phase 1: Parse** | Full README parse | Full README parse | Full README parse |
| **Phase 2: Validate** | Dirs only | Full source inspection | Selective inspection (P0–P1) |
| **Phase 3: Structure** | `UNKNOWN` heavy | `VERIFIED` heavy | Mixed tags |
| **Phase 4: Gates** | Skip func/const verification | Full gate enforcement | Gate 1 partial (priority targets) |
| **Phase 5: Release** | With high unknown count | With verification metadata | With confidence tiers |

### Output Metadata Header

Every generated file includes a mode declaration:

```markdown
**Generation Mode:** hybrid  
**Last Verified:** 2026-03-01  
**Verification Coverage:** 52% VERIFIED, 33% INFERRED, 15% UNKNOWN  
```

---

## Validation Against AGS Case Study

<!-- DOC:STRATEGY:VALIDATION -->

The AGS evaluation (see [_eval_report.md](../../gamemodes/Advanced%20Game%20Settings/ai/_eval_report.md)) produced outputs from both approaches, validating the mode framework:

| Output | Mode Equivalent | Score | Unknowns |
|--------|----------------|-------|----------|
| AI_INDEX.md (existing) | Detailed | 99.2% path accuracy, 100% function accuracy | 3 |
| 5 regenerated primitives | Conservative | 100% accuracy (no invention) | 47 |
| Recommended approach | Hybrid | Projected 95%+ accuracy | 10–30 |

**Key Insight:** The Detailed AI_INDEX.md achieved near-perfect accuracy because the source code was thoroughly inspected. The Conservative primitives achieved perfect safety but sacrificed utility. Hybrid mode — the recommended default — would have verified P0/P1 targets (entry point, config, teams, conditions framework) while marking P2/P3 features as `INFERRED`.

---

## Related Documents

- **Skill Definition:** [SKILL.md](../../.skills/readme-to-ai-reference/SKILL.md)
- **Structure Spec:** [REFERENCE_SPEC_01_STRUCTURE.md](REFERENCE_SPEC_01_STRUCTURE.md)
- **Guardrails Spec:** [REFERENCE_SPEC_02_GUARDRAILS.md](REFERENCE_SPEC_02_GUARDRAILS.md)
- **Evaluation Spec:** [REFERENCE_SPEC_03_EVALUATION.md](REFERENCE_SPEC_03_EVALUATION.md)
- **Research Foundation:** [REFERENCE_DESIGN_2026-03.md](archive/2026-03/REFERENCE_DESIGN_2026-03.md) *(archived)*
- **AGS Eval Report:** [_eval_report.md](../../gamemodes/Advanced%20Game%20Settings/ai/_eval_report.md)
