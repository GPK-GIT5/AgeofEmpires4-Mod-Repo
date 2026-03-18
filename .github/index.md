# .github Directory Map

> Last updated: 2026-03-18

## Layout

```
.github/
├── copilot-instructions.md       ← master Copilot config (≤ 4000 chars)
├── index.md                      ← this file
├── instructions/                 ← Copilot auto-loaded (applyTo frontmatter)
│   ├── coding/                   ← language-specific standards
│   │   ├── scar-coding.instructions.md
│   │   └── ps-coding.instructions.md
│   ├── context/                  ← folder scope & navigation
│   │   ├── gamemode-scope.instructions.md
│   │   ├── mods-scope.instructions.md
│   │   └── mod-context.instructions.md
│   └── core/                     ← cross-cutting domain rules
│       └── ai-reference.instructions.md
├── architecture/                 ← human-facing design & onboarding docs
│   ├── QUICKSTART.md
│   ├── REFERENCE_DESIGN_2026-03.md
│   └── RESEARCH_FINDINGS_2026-03.md
├── archive/                      ← superseded content, grouped by date
│   └── 2026-03/
└── workflows/                    ← GitHub Actions CI
    └── workflow-guard.yml
```

## Rules (enforced by `scripts/structure_lint.ps1`)

| Rule | What It Checks |
|------|----------------|
| 1 | `.github/` root: only `copilot-instructions.md` and `index.md` |
| 2 | `instructions/{coding,context,core}/`: grouped `*.instructions.md` with `applyTo`, prefix-per-group, ≤4K, no nesting |
| 3 | No stale `copilot/` wrapper directory |
| 4 | Master instructions ≤ 4000 chars |
| 5 | `.skills/` root: only `index.md` |
| 6 | Each skill folder has `SKILL.md` |
| 7 | `workflows/`: only `.yml` files |
| 8 | Standard subdirectories present |

## Naming Conventions

| Pattern | Scope | Example |
|---------|-------|---------|
| `*.instructions.md` | Copilot auto-loaded (must have `applyTo`) | `scar-coding.instructions.md` |
| `UPPERCASE.md` | Human-facing docs, specs, manifests | `SKILL.md`, `QUICKSTART.md` |
| `lowercase-kebab.md` | Reference data, generated output | `architecture.md` |
| `NAME_YYYY-MM.md` | Date-stamped archive content | `UPDATE_PLAN_2026-03.md` |
| `index.md` | Directory entry point | `.github/index.md` |

## Validation

```powershell
./scripts/structure_lint.ps1   # structure rules (8 checks)
./scripts/doc_lint.ps1         # documentation quality (anchors, YAML, phrases, sizes)
```

Both run in CI via `workflow-guard.yml`.
