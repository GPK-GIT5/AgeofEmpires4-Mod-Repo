# Skills Catalog

Available Copilot Agent Skills in this workspace.

| Skill | Status | Entry Point | Purpose |
|-------|--------|-------------|---------|
| `readme-to-ai-reference` | production | [SKILL.md](readme-to-ai-reference/SKILL.md) | Transform READMEs into AI-optimized reference primitives |
| `scar-debug` | draft | [SKILL.md](scar-debug/SKILL.md) | Generate SCAR debug output helpers |
| `console-commands` | draft | [SKILL.md](console-commands/SKILL.md) | Console command generation with test commands |
| `data-extraction` | draft | [SKILL.md](data-extraction/SKILL.md) | SCAR reference extraction pipeline |

## Structure Convention

Each skill folder follows this layout:

```
skill-name/
├── SKILL.md              ← required: manifest (objective, workflow, outputs)
├── SPECIFICATION.md      ← required for production: quality gates, rules
├── ai/                   ← generated reference output (6 primitives)
│   ├── AI_INDEX.md
│   ├── architecture.md
│   ├── capabilities_map.md
│   ├── file_index.md
│   ├── glossary.md
│   └── settings_schema.yaml
└── specs/                ← implementation specifications
```

**Draft** skills only need `SKILL.md`. Promote to **production** by adding `SPECIFICATION.md` and `ai/` output.
