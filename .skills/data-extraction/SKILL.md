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

---

## Blueprint & Canonical Data Pipeline

Separate from the SCAR index extraction above, these scripts generate blueprint tables and canonical game data from workspace JSON and the external XML EBP dump.

### Full canonical generation
```powershell
.\scripts\generate_all_data.ps1
```

Runs Phases 1–10:
1. Per-civ blueprint reference tables (22 civs → `references/blueprints/`)
2. Canonical buildings (`data/aoe4/data/canonical/canonical-buildings.json`)
3. Weapon catalog (`data/aoe4/data/canonical/weapon-catalog.json`)
4. Cross-reference report vs external XML dump
5. Core template inheritance (`core-templates.json` + `inheritance-map.json`)
6. Tier chains + weapon linkage (`tier-chains.json` + `unit-weapon-linkage.json`)
7. Entity lifecycle (`entity-lifecycle.json` — cross-links inheritance + tiers + weapons)
8. Per-civ EBP gap fill (appends missing entities to blueprint tables)
9. HA variant deltas (`ha-variant-deltas.json` + per-variant files in `ha-variants/`)
10. Neutral & special entities (`neutral-entities.json` + blueprint update)

### Individual scripts
```powershell
.\scripts\build_canonical_data.ps1                     # alias, units, weapons, production, upgrades, truth
.\scripts\extract_inheritance.ps1                      # core-templates.json + inheritance-map.json
.\scripts\extract_tier_chains.ps1                      # tier-chains.json + unit-weapon-linkage.json
.\scripts\build_entity_lifecycle.ps1                   # entity-lifecycle.json (cross-links all three)
.\scripts\fill_blueprint_gaps.ps1                      # per-civ EBP gap fill from XML dump
.\scripts\extract_ha_deltas.ps1                        # ha-variant-deltas.json + per-variant files
.\scripts\merge_neutral_entities.ps1                   # neutral-entities.json + blueprint update
.\scripts\validate_data.ps1                            # audit report
```

### Canonical output files

| File | Entries | Source |
|------|---------|--------|
| `canonical/core-templates.json` | 171 | External XML core templates (hitpoints, costs, sight, build time) |
| `canonical/inheritance-map.json` | 2,846 | All civ entities → parent links + override counts |
| `canonical/tier-chains.json` | 424 | Tier upgrade chains (upgrade PBG → next-tier EBP + SBP) |
| `canonical/unit-weapon-linkage.json` | 1,123 | Entity → weapon blueprint (WBP) references |
| `canonical/entity-lifecycle.json` | 2,846 | Unified per-entity: parent defaults + tier chains + weapon links |
| `canonical/canonical-buildings.json` | 156 | Cross-civ building concepts |
| `canonical/weapon-catalog.json` | 1,388 | All weapon instances across civs/ages |
| `canonical/ha-variant-deltas.json` | 895 | HA variant summary: 9 variants, parent mappings, override counts |
| `canonical/neutral-entities.json` | 18 | Neutral + cheat entities (trade posts, seasonal, photon_man) |
| `ha-variants/{variant}-deltas.json` | 9 files | Per-variant entity delta detail |

---

## Onslaught Index Extraction

Separate from the campaign/gameplay index extraction, these scripts extract function definitions, globals, imports, and API usage from the Onslaught mod source.

### Full Onslaught index generation
```powershell
.\scripts\build_onslaught_index.ps1       # functions + globals + imports
.\scripts\build_api_usage_map.ps1         # API cross-reference
```

### Onslaught output files

| File | Entries | Content |
|------|---------|---------|
| `references/indexes/onslaught-function-index.md` | ~1,741 | Onslaught function definitions (per-subsystem Markdown tables) |
| `references/indexes/onslaught-function-index.csv` | ~1,741 | CSV: Subsystem, File, Function, Params, Line, Visibility, FileRole |
| `references/indexes/onslaught-globals-index.md` | ~647 | Top-level global variable assignments (per-subsystem) |
| `references/indexes/onslaught-globals-index.csv` | ~647 | CSV: Subsystem, File, Variable, Line, Value |
| `references/indexes/onslaught-imports-index.csv` | ~187 | CSV: Subsystem, File, Import, Line |
| `references/indexes/onslaught-api-usage.csv` | ~861 | CSV: Namespace, Function, CallCount, Files, FirstFile, FirstLine |
| `references/mods/onslaught-api-usage-map.md` | ~861 | Onslaught → SCAR API cross-reference (top 50, per-namespace detail) |
| `references/mods/onslaught-patterns.md` | 10 | Canonical code patterns for Onslaught development |
