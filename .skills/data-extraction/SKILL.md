---
name: "data-extraction"
description: "Run and validate the SCAR reference extraction pipeline. Use when: user needs to regenerate function indexes, update reference data, prepare extraction batches, or verify index integrity."
metadata:
  version: "1.0.0"
  author: "Copilot Skill: data-extraction"
  keywords: ["extraction", "pipeline", "indexes", "scar", "functions", "references", "batch"]
---

# Skill: Data Extraction

**Purpose:** Run the SCAR reference extraction pipeline to regenerate all function indexes, dependency graphs, and processing batches from workspace `.scar` files.

**Input:** Extraction request (full pipeline or specific phase)
**Output:** Updated index files in `references/indexes/` + optional batches

---

## Workflow

### Phase 1: Pre-Flight Check

1. Verify workspace root: `C:\Users\Jordan\Documents\AoE4-Workspace`
2. Verify scripts exist:
   - `scripts/run_all_extraction.ps1` (orchestrator)
   - `scripts/extract_functions.ps1` (Phase 1a: function signatures)
   - `scripts/extract_data.ps1` (Phase 1b: imports, objectives, groups, globals)
   - `scripts/generate_batches_v2.ps1` (Phase 2: mission-grouped batches)
3. Check for `.scar` source files in `Gamemodes/` and `Scenarios/`

### Phase 2: Execute Pipeline

**Full pipeline** (default):
```powershell
.\scripts\run_all_extraction.ps1
```

**With custom batch size:**
```powershell
.\scripts\run_all_extraction.ps1 -MaxBatchKB 60
```

**Individual phases** (for targeted updates):
```powershell
# Phase 1a only: function signatures
.\scripts\extract_functions.ps1 -WorkspaceRoot "C:\Users\Jordan\Documents\AoE4-Workspace"

# Phase 1b only: imports, objectives, groups, globals
.\scripts\extract_data.ps1 -WorkspaceRoot "C:\Users\Jordan\Documents\AoE4-Workspace"

# Phase 2 only: batch generation
.\scripts\generate_batches_v2.ps1 -WorkspaceRoot "C:\Users\Jordan\Documents\AoE4-Workspace" -MaxBatchBytes 81920
```

### Phase 3: Validate Outputs

Verify expected output files exist and have content:

| Output File | Content |
|-------------|---------|
| `references/indexes/function-index.csv` | Function signatures (Category, File, Function, Params, Line) |
| `references/indexes/function-index.md` | Same data in Markdown table format |
| `references/indexes/imports-index.csv` | Import dependency graph |
| `references/indexes/objectives-index.csv` | OBJ_/SOBJ_ constant declarations |
| `references/indexes/groups-index.csv` | SGroup/EGroup declarations |
| `references/indexes/globals-index.csv` | Global variable assignments |
| `references/navigation/data-index.md` | Combined dependency summary |

**Row count sanity checks** (approximate baselines from Feb 2026):
- function-index.csv: ~8,900+ rows
- globals-index.csv: ~14,000+ rows
- groups-index.csv: ~3,200+ rows
- imports-index.csv: ~1,200+ rows
- objectives-index.csv: ~800+ rows

If row counts drop significantly, investigate whether source `.scar` files were removed or the extraction regex changed.

---

## Common Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| Empty CSV output | Wrong WorkspaceRoot path | Verify `-WorkspaceRoot` points to workspace root with `Gamemodes/` and `Scenarios/` |
| Missing function-index.md | extract_functions.ps1 didn't run | Run Phase 1a explicitly |
| Batch size too large | MaxBatchKB too high for target | Reduce to 60KB for smaller batch consumers |
| Stale indexes | Source .scar files changed | Re-run full pipeline |

## Reference Files

| Resource | Path |
|----------|------|
| Orchestrator | `scripts/run_all_extraction.ps1` |
| Function extractor | `scripts/extract_functions.ps1` |
| Data extractor | `scripts/extract_data.ps1` |
| Batch generator | `scripts/generate_batches_v2.ps1` |
| Output indexes | `references/indexes/` |
| Navigation summary | `references/navigation/data-index.md` |
