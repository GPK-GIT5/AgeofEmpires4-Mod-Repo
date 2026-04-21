---
applyTo: "**/*.scar,references/blueprints/**,data/aoe4/data/**"
---

# Data Catalog — Workspace Data Sources

Complete inventory of extracted game data available in this workspace.
Consult this when working with blueprint names, unit stats, weapon profiles, building data, or technology trees.

## Blueprint Lookup Tables (`references/blueprints/`)

Per-civ markdown tables mapping `attribName` (uppercase) → `pbgid` for use with `BP_GetSquadBlueprint()`, `BP_GetEntityBlueprint()`, `BP_GetUpgradeBlueprint()`.

**22 player factions covered:** abbasid, ayyubids, byzantines, chinese, english, french, goldenhorde, hre, japanese, jeannedarc, lancaster, macedonian, malians, mongol, orderofthedragon, ottomans, rus, sengoku, sultanate (Delhi), templar, tughlaq, zhuxi

**6 special categories:** campaign, civ_start, common, core, gaia, neutral

**Usage:** `references/blueprints/{civname}-blueprints.md` — search for `UNIT_*`, `BUILDING_*`, `UPGRADE_*` by name.

## Entity Data (`data/aoe4/data/`)

| Category | Path | Per-Civ Files | Unified |
|----------|------|---------------|---------|
| Units | `data/aoe4/data/units/` | 1,266 JSONs in 22 civ subfolders | `all-unified.json` (215 base units) |
| Buildings | `data/aoe4/data/buildings/` | 861 JSONs in 22 civ subfolders | `all-unified.json` (156 base buildings) |
| Technologies | `data/aoe4/data/technologies/` | 2,207 JSONs in 22 civ subfolders | `all-unified.json` |
| Civilizations | `data/aoe4/data/civilizations/` | 22 civ JSONs | `civs-index.json` |

**Per-entity JSON fields:** `id`, `baseId`, `name`, `pbgid`, `attribName`, `age`, `civs`, `description`, `classes`, `displayClasses`, `unique`, `costs` (food/wood/stone/gold/time/popcap), `producedBy`, `weapons[]`, `armor[]`, `hitpoints`

## Canonical Data (`data/aoe4/data/canonical/`)

| File | Entries | Purpose |
|------|---------|---------|
| `alias-map.json` | 981 aliases | 7-index lookup: byBaseId, byAttribName, bySlug, byDisplayName, byPbgId, byClass, byProducedBy |
| `canonical-units.json` | 215 | Base unit concepts with age ranges, civ distribution, classes |
| `canonical-buildings.json` | 156 | Base building concepts with age, civ coverage, classes |
| `core-templates.json` | 171 | Core template defaults (hitpoints, costs, sight, build time) — inheritance parents for all civ entities |
| `inheritance-map.json` | 2,846 | Entity→parent inheritance links with core template defaults + override counts |
| `tier-chains.json` | 424 | Tier upgrade chains: entity → upgrade PBG → next-tier EBP/SBP |
| `unit-weapon-linkage.json` | 1,123 | Entity → weapon blueprint (WBP) references with full paths |
| `entity-lifecycle.json` | 2,846 | Unified per-entity catalog: parent defaults + tier chains + weapon links |
| `weapon-profiles.json` | 189 | Per-baseId weapon archetypes (damage, range, speed, modifiers) |
| `weapon-catalog.json` | 1,388 | Standalone weapon catalog from all unit profiles (per-civ, per-age) |
| `production-graph.json` | — | Producer → unit/tech relationships with civ coverage |
| `upgrade-chains.json` | — | Per-baseId age-tier stat progression |
| `static-truth.json` | — | Behavioral classification from static weapon/class data |
| `ha-variant-deltas.json` | 895 | HA variant summary: 9 variants, parent mappings, override counts, unique entities |
| `neutral-entities.json` | 18 | Neutral + cheat entities (trade posts, seasonal, photon_man) |
| `campaign-entities.json` | 518 | Campaign & rogue race entities (campaign, crusader_cmp, ayyubid_cmp, rogue) |

## HA Variant Data (`data/aoe4/data/ha-variants/`)

Per-variant delta JSONs for 9 Historical Age variants. Each file contains per-entity parent reference, override count, uniqueness flag, and category classification.

**Variants:** french_ha_01 (Jeanne d'Arc), abbasid_ha_01 (Ayyubids), chinese_ha_01 (Zhu Xi), hre_ha_01 (Order of Dragon), japanese_ha_sen (Sengoku), mongol_ha_gol (Golden Horde), sultanate_ha_tug (Tughlaq), lancaster, byzantine_ha_mac (Macedonian)

**Usage:** `data/aoe4/data/ha-variants/{variant}-deltas.json`

## Derived Analysis (`data/aoe4/data/derived/`)

| File | Purpose |
|------|---------|
| `dps-by-unit.json` | DPS calculations per unit |
| `health-by-age.json` | Health scaling by age |
| `weapon-modifiers.json` | Weapon modifier catalog |
| `tech-costs-normalized.json` | Technology cost normalization |
| `production-chains.json` | Extended production chain analysis |
| `dlc-completeness.json` | DLC coverage map |
| `bp-suffix-catalog.json` | Blueprint name suffix patterns for age/civ detection |

## Resolution Order

When looking up game data:
1. **By blueprint name** → `references/blueprints/{civ}-blueprints.md`
2. **By baseId/attribName** → `data/aoe4/data/canonical/alias-map.json`
3. **By unit concept** → `data/aoe4/data/canonical/canonical-units.json` or `canonical-buildings.json`
4. **By core template defaults** → `data/aoe4/data/canonical/core-templates.json` (inherited hitpoints, costs, sight)
5. **By inheritance chain** → `data/aoe4/data/canonical/inheritance-map.json` (entity → core parent → defaults)
6. **By tier/upgrade chain** → `data/aoe4/data/canonical/tier-chains.json` (entity → upgrade → next tier)
7. **By weapon blueprint** → `data/aoe4/data/canonical/unit-weapon-linkage.json` (entity → WBP paths)
8. **By unified entity view** → `data/aoe4/data/canonical/entity-lifecycle.json` (defaults + tiers + weapons per entity)
9. **By weapon stats** → `data/aoe4/data/canonical/weapon-catalog.json` or `weapon-profiles.json`
10. **By per-civ detail** → `data/aoe4/data/{units|buildings|technologies}/{civname}/`
11. **By cross-civ comparison** → `data/aoe4/data/{category}/all-unified.json`
12. **By HA variant delta** → `data/aoe4/data/canonical/ha-variant-deltas.json` or `data/aoe4/data/ha-variants/{variant}-deltas.json`
13. **By neutral/special entity** → `data/aoe4/data/canonical/neutral-entities.json`
14. **By campaign/rogue entity** → `data/aoe4/data/canonical/campaign-entities.json`

## Cross-Reference Report

`data/aoe4/data/cross-reference-report.json` documents entities present in the external XML EBP dump but absent from workspace JSON. Primarily: weapon EBPs (217), core templates (177), campaign entities (441), HA variant deltas (286). See `data/aoe4/EXTRACTION_PLAN.md` for remaining extraction priorities.

## Onslaught Mod Indexes (`references/indexes/`, `references/mods/`)

Auto-generated from `Gamemodes/Onslaught/assets/scar/` source files.

| File | Entries | Content |
|------|---------|---------|
| `onslaught-function-index.md` | ~1,741 | All Onslaught function definitions grouped by subsystem |
| `onslaught-function-index.csv` | ~1,741 | CSV: Subsystem, File, Function, Params, Line, Visibility, FileRole |
| `onslaught-globals-index.md` | ~647 | Top-level global variable assignments per subsystem |
| `onslaught-globals-index.csv` | ~647 | CSV: Subsystem, File, Variable, Line, Value |
| `onslaught-imports-index.csv` | ~187 | Import dependency graph for Onslaught files |
| `onslaught-api-usage.csv` | ~861 | SCAR engine API calls found in Onslaught source |
| `onslaught-api-usage-map.md` | — | Cross-reference: top 50 API calls, per-namespace detail, file density |
| `onslaught-patterns.md` | 10 | Canonical code patterns (module registration, options, BP resolution, rules, UI) |
| `onslaught-event-handler-map.md` | — | GE_ event → handler cross-reference, lifecycle balance, interval/oneshot detail |
| `onslaught-event-handlers.csv` | ~200 | All Rule_Add* / Rule_Remove* registrations (type, event, handler, file, line) |
| `onslaught-options-schema.md` | 95 keys | AGS_GLOBAL_SETTINGS schema: types, defaults, enum groups (12 groups, 50 constants) |
| `onslaught-blueprint-audit.md` | — | Blueprint usage vs reference coverage (1,529 used, 84.4% covered) |
| `onslaught-blueprint-audit.csv` | ~1,529 | Per-BP status: FOUND/MISSING, call count, files, first location |
| `onslaught-reward-trees.csv` | ~918 | Kill-threshold reward data: civ, mode, threshold, reward type, BP, count |
| `onslaught-reward-trees.md` | — | Reward tree reference: per-civ distribution, kill scoring tiers, highest thresholds |
| `onslaught-debug-commands.csv` | 236 | All Debug_* console commands: function, params, category, file, description |
| `onslaught-debug-commands.md` | — | Debug command inventory by category (27 categories across 29 files) |
| `onslaught-module-lifecycle.csv` | ~566 | Module → delegate function matrix: module, phase, function, file, line |
| `onslaught-module-lifecycle.md` | — | Module lifecycle map: 41 modules, phase participation matrix, delegate details |
| `scar-engine-functions.csv` | 1,976 | SCAR engine API function signatures: name, namespace, params, description |
| `scar-engine-constants.csv` | 876 | SCAR engine constants by category (134 categories) |

**Regeneration:**
```powershell
.\scripts\build_onslaught_index.ps1       # functions + globals + imports
.\scripts\build_api_usage_map.ps1         # API cross-reference
.\scripts\build_event_handler_map.ps1     # event-handler cross-reference
.\scripts\build_options_schema.ps1        # options schema
.\scripts\audit_blueprint_usage.ps1       # blueprint usage audit
.\scripts\extract_reward_trees.ps1        # reward tree extraction
.\scripts\build_debug_command_index.ps1   # debug command inventory
.\scripts\build_module_lifecycle.ps1      # module lifecycle map
.\scripts\export_scar_api_csv.ps1         # SCAR engine API CSV
```

### Onslaught Lookup Order

When looking up Onslaught mod code:
1. **By function name** → `references/indexes/onslaught-function-index.csv` (search Function column)
2. **By global/state variable** → `references/indexes/onslaught-globals-index.csv`
3. **By API function usage** → `references/indexes/onslaught-api-usage.csv` (which engine APIs used where)
4. **By code pattern** → `references/mods/onslaught-patterns.md` (10 canonical patterns)
5. **By import chain** → `references/indexes/onslaught-imports-index.csv`
6. **By event/rule handler** → `references/indexes/onslaught-event-handlers.csv` or `references/mods/onslaught-event-handler-map.md`
7. **By game option** → `references/mods/onslaught-options-schema.md` (setting key, type, default, enum group)
8. **By blueprint coverage** → `references/mods/onslaught-blueprint-audit.md` (FOUND/MISSING status)
9. **By reward tree** → `references/indexes/onslaught-reward-trees.csv` or `references/mods/onslaught-reward-trees.md`
10. **By debug command** → `references/indexes/onslaught-debug-commands.csv` or `references/mods/onslaught-debug-commands.md`
11. **By module lifecycle** → `references/indexes/onslaught-module-lifecycle.csv` or `references/mods/onslaught-module-lifecycle.md`
12. **By SCAR engine API signature** → `references/indexes/scar-engine-functions.csv` (typed params + descriptions)
13. **By SCAR engine constant** → `references/indexes/scar-engine-constants.csv` (category → name)
