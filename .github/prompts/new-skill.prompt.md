---
name: "New Skill"
description: "Scaffold a new .skills/<name>/SKILL.md following workspace conventions and Batch 01 quality standards."
---

# New Skill Template

Create a new Copilot skill definition for this workspace.

## Parameters

- **Skill name**: snake-case identifier (e.g., `scar-debug`, `data-extraction`)
- **Domain**: What problem domain does this skill address?
- **Trigger phrase**: When should Copilot activate this? ("Use when: ...")

## Instructions

1. Create `.skills/{{skill-name}}/SKILL.md`
2. Use the YAML frontmatter format below
3. Description MUST include a "Use when:" clause for activation scoring
4. Keywords should be specific enough for relevance matching
5. Tools array should be minimal — only what the workflow requires
6. Workflow should have 2–4 phases with clear inputs/outputs per phase
7. Total file should stay under 500 lines (progressive disclosure)
8. Reference files table should only list paths verified to exist

## Template

```markdown
---
name: "{{skill-name}}"
description: "{{One-line purpose}}. Use when: {{trigger conditions}}."
metadata:
  version: "1.0.0"
  author: "Copilot Skill: {{skill-name}}"
  keywords: [{{3-7 relevant keywords}}]
tools:
  - read_file
  - grep_search
  {{- additional tools as needed}}
---

# Skill: {{Display Name}}

**Purpose:** {{What this skill does}}

**Input:** {{What the user provides}}
**Output:** {{What the skill produces}}

---

## Workflow

### Phase 1: {{Name}}

1. {{Step}}
2. {{Step}}

### Phase 2: {{Name}}

1. {{Step}}
2. {{Step}}

---

## Reference Files

| Resource | Path |
|----------|------|
| {{name}} | {{verified path}} |
```

## Quality Checklist (from Batch 01 §4)

- [ ] YAML frontmatter valid — name, description, metadata, tools
- [ ] Description includes "Use when:" clause
- [ ] Keywords are specific and domain-relevant
- [ ] Workflow phases have clear entry/exit criteria
- [ ] All referenced file paths verified with `Test-Path`
- [ ] File under 500 lines
- [ ] No invented function names, file paths, or constants
