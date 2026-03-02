# README to AI Reference Material - Specification

Detailed specification for quality gates, non-invention rules, hallucination mitigation, and acceptance criteria.

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
