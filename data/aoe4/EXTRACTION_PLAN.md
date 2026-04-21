# Workspace Data Extraction Plan
> Generated: 2026-04-02 | Cross-referenced against `Gameplay_data_duplicate` EBP XML dump

## Current State Summary

| Metric | Count |
|--------|-------|
| Workspace unique attribNames | 2,216 |
| External XML files (EBP dump) | 3,024 |
| External race folders | 29 |
| **Missing in workspace** | **1,500** |
| Workspace-only (API, no XML) | 692 (1,688 techs + 55 units — expected: external dump is EBP-only) |

### Missing Entity Breakdown

| Type | Count | Notes |
|------|-------|-------|
| Units (`unit_*`) | 776 | Weapons EBPs (infantry/cavalry entities), campaign heroes, HA variants |
| Buildings (`building_*`) | 373 | Core templates, campaign buildings, HA variant structures |
| Weapons (`wpn_*`) | 217 | Standalone weapon EBPs (not in API extraction) |
| Projectiles (`projectile_*`) | 17 | Projectile entities |
| Other | 117 | Misc: carts, props, codex dummies, viz entities |

### Missing by Race (Top 10)

| Race | Total | Weapons | Units | Buildings | Priority |
|------|-------|---------|-------|-----------|----------|
| `campaign/` | 232 | 6 | 98 | 100 | LOW — scenario editing only |
| `core/` | 177 | 73 | 70 | 33 | **HIGH** — inheritance templates |
| `crusader_cmp` | 112 | 3 | 71 | 38 | LOW — campaign variant |
| `ayyubid_cmp` | 97 | 4 | 58 | 35 | LOW — campaign variant |
| `french_ha_01` | 85 | 6 | 58 | 4 | MEDIUM — Jeanne d'Arc HA variant |
| `rogue` | 77 | 2 | 49 | 22 | LOW — NPC faction |
| `english` | 67 | 22 | 30 | 5 | **HIGH** — weapon EBPs for base civ |
| `mongol` | 63 | 3 | 33 | 24 | **HIGH** — weapon/building EBPs |
| `templar` | 48 | 5 | 17 | 5 | MEDIUM — codex/gameplay items |
| `japanese` | 43 | 8 | 25 | 4 | MEDIUM — weapon/unit EBPs |

---

## Prioritized Extraction Tasks

### Priority 1: Core Templates (177 entities) ✅ COMPLETED
**Why:** These are the inheritance parents for ALL civ-specific EBPs. They define default stats, shared extensions, and base property values that civ variants override. Essential for understanding modifier chains and verifying data correctness.
**Source:** `ebps/races/core/` → buildings/, units/, weapons/, substructs/
**Output:** `data/aoe4/data/canonical/core-templates.json` (171 entries) + `data/aoe4/data/canonical/inheritance-map.json` (2,846 entries)
**Script:** `scripts/extract_inheritance.ps1` (also integrated as Phase 5 of `generate_all_data.ps1`)
**Results:** 171 core templates parsed (65 units, 33 buildings, 73 weapons); 2,612/2,846 entities linked to parents; 2,021 core-linked; 28 races covered.

### Priority 2: Weapon EBPs & Linkage (217 standalone + 1,123 linked) ✅ PARTIALLY COMPLETED
**Why:** Standalone weapon entity blueprints define damage, range, reload, and modifier data independently from the units that use them. The workspace currently has weapon *profiles* (embedded in unit data) but not the standalone weapon EBPs with inheritance chains.
**Source:** `ebps/races/*/weapons/` folders + `non_entity_weapon_wrapper_pbg` refs from all entities
**Output:** `data/aoe4/data/canonical/unit-weapon-linkage.json` (1,123 entities → 3,297 weapon refs), `data/aoe4/data/canonical/tier-chains.json` (424 entities, 658 tier steps)
**Script:** `scripts/extract_tier_chains.ps1` (also integrated as Phase 6 of `generate_all_data.ps1`)
**Status:** Unit→weapon linkage extracted. Tier upgrade chains extracted. Remaining: standalone weapon EBP stat extraction (damage/range/reload from WBP XML namespace — requires `weapon\races\` not `ebps\races\` folder access).

### Priority 3: Per-Civ Unit/Building EBP Gap Fill (base civs) ✅ COMPLETED
**Why:** Each base civ has 15–67 EBPs in the XML dump that didn't match workspace attribNames. These include: weapon entities filed under units/ (e.g., `wpn_melee_*`), campaign hero variants, siege crew entities, and building subcomponents (gates, bastions).
**Source:** `ebps/races/{english,mongol,french,chinese,abbasid,rus,hre,sultanate}/`
**Output:** 556 entries appended to 22 per-civ blueprint tables + `data/aoe4/data/canonical/gap-fill-report.json`
**Script:** `scripts/fill_blueprint_gaps.ps1` (also integrated as Phase 8 of `generate_all_data.ps1`)
**Results:** 541 gaps identified across 21 civs (initial run) + 18 mongol gaps (re-run after mapping fix). Entries categorized as units, buildings, weapons, or other and appended with duplicate protection.

### Priority 4: HA Variant Deltas (9 folders, 895 entities) ✅ COMPLETED
**Why:** Historical Age variant races (french_ha_01, abbasid_ha_01, etc.) contain unit/building EBPs that extend parent civ entities with variant-specific overrides. Useful for variant-civ conversion routing.
**Source:** `ebps/races/*_ha_*/ + lancaster/ + byzantine_ha_mac/`
**Output:** `data/aoe4/data/canonical/ha-variant-deltas.json` (unified summary) + `data/aoe4/data/ha-variants/{variant}-deltas.json` (9 per-variant files)
**Script:** `scripts/extract_ha_deltas.ps1` (also integrated as Phase 9 of `generate_all_data.ps1`)
**Results:** 895 total entities across 9 variants; 25,217 override fields; 196 variant-unique entities. Most entities inherit from core templates (754) with some from parent civ (72) and 69 with no parent.

### Priority 5: Campaign/Rogue Entities (518 entities) ✅ COMPLETED
**Why:** Campaign-only factions (campaign/, crusader_cmp, ayyubid_cmp) and the rogue NPC faction have entities not present in multiplayer API extraction. Useful for scenario editing and campaign modding only.
**Source:** `ebps/races/campaign/ + crusader_cmp/ + ayyubid_cmp/ + rogue/`
**Output:** `data/aoe4/data/canonical/campaign-entities.json` (518 entities) + 294 new entries appended to `references/blueprints/campaign-blueprints.md`
**Script:** `scripts/extract_campaign_entities.ps1` (also integrated as Phase 13 of `generate_all_data.ps1`)
**Results:** 518 entities across 4 campaign races (campaign: 232 across 9 sub-civs, crusader_cmp: 112, ayyubid_cmp: 97, rogue: 77). 294 genuinely new entries appended to campaign-blueprints.md (356 existing preserved).

### Priority 6: Neutral/Special Entities (18 entities) ✅ COMPLETED
**Why:** Neutral buildings (sacred sites, trade posts, seasonal variants) and debug entities (cheat photon_man) not present in multiplayer API extraction.
**Source:** `ebps/races/neutral/ + cheat/`
**Output:** `data/aoe4/data/canonical/neutral-entities.json` (18 entities) + 9 new entries appended to `references/blueprints/neutral-blueprints.md`
**Script:** `scripts/merge_neutral_entities.ps1` (also integrated as Phase 10 of `generate_all_data.ps1`)
**Results:** 18 entities cataloged; 9 new entries (campaign/seasonal trade posts, ronin, photon_man) appended to blueprint table with duplicate protection.

---

## What Cannot Be Extracted from This Dump

| Data Type | Status | Alternative Source |
|-----------|--------|--------------------|
| **Squad Blueprints (SBP)** | Not in XML dump (EBP-only) | AoE4 World API / Attributes dump.txt |
| **Upgrade Blueprints (UBP)** | Not in XML dump | AoE4 World API (already have 2,207) |
| **Ability Blueprints (ABP)** | Not in XML dump | Game runtime / SCAR API |
| **Technology effects/modifiers** | Not in XML dump | AoE4 World API (already embedded in tech JSON) |

## Verification Checklist

- [x] 14 missing blueprint tables generated (ayyubids through zhuxi)
- [x] canonical-buildings.json created (156 entries)
- [x] weapon-catalog.json created (1,388 weapon profiles from unit data)
- [x] cross-reference-report.json generated (1,500 missing identified)
- [x] README.md updated with all 22 civs
- [x] Core templates extracted (Priority 1)
- [x] Weapon EBPs extracted (Priority 2 — linkage complete, WBP stats blocked by binary format)
- [x] Per-civ EBP gap filled (Priority 3 — 556 entries across 22 civs)
- [x] Entity lifecycle catalog generated (2,846 unified entries)
- [x] HA variant deltas mapped (Priority 4 — 895 entities, 9 variants, 196 unique)
- [ ] Campaign entities cataloged (Priority 5)
- [x] Neutral entities merged (Priority 6 — 18 entities, 9 new appended)
