# GitHub Batch Reference Index

> **Generated:** 2026-02-27 | **Refactored:** 2026-06-14 (3-batch cycle)  
> **Location:** `data/github/`  
> **Purpose:** Hierarchical navigation for AI retrieval across all batch outputs  
> **Hierarchy:** Concept → API → Pattern → Example

---

## Batch Inventory

| Batch | File | Title | URLs | Date |
|---|---|---|---|---|
| 01 | [batch_01.md](batch_01.md) / [batch_01.json](batch_01.json) | Instructions, Skills, Agents & Prompt Engineering | 21 | 2026-02-26 |
| 03 | [batch_03.md](batch_03.md) / [batch_03.json](batch_03.json) | TypeScript-to-Lua Pipeline, Lua Ecosystem & OOP Libraries | 17 | 2026-02-27 |
| 04 | [batch_04.md](batch_04.md) / [batch_04.json](batch_04.json) | SCAR Scripting API, AoE4 Modding Tools & Community | 12+9 | 2026-06-14 |

### Special Artifacts

| File | Purpose |
|---|---|
| [scar_skill_schema.json](scar_skill_schema.json) | JSON Schema for SCAR AI skill abstractions (inputs/outputs/triggers/state/lifecycle/composability) |

---

## Topic Hierarchy — Concept → API → Pattern → Example

### Layer 1 — Concepts: AI Agent & Copilot Customization
- **Batch 01** §1–§3: File architecture, precedence rules, instruction patterns
- **Batch 01** §4–§5: Skill & agent design patterns
- **Batch 01** §6: 10-component prompt framework, role/tone/CoT patterns
- **Batch 01** §7: Context engineering — retrieval-oriented doc templates, token budgets
- **Batch 01** §8: Cross-platform skill paths, agent config filenames

### Layer 2 — Concepts: Lua Language & Tooling
- **Batch 03** §3: Lua foundations (versions, features, AoE4 Lua 5.1-compatible subset)
- **Batch 03** §4: LuaLS language server & type annotations
- **Batch 03** §5: Luacheck static analysis & linting
- **Batch 03** §6: LuaRocks package management
- **Batch 03** §7: Style conventions (Olivine-Labs guide, SCAR deviations)

### Layer 3 — APIs: SCAR Engine API Surface
- **Batch 04** §1: Module taxonomy (60+ modules organized by domain)
- **Batch 04** §2: Core type system (32 types — Entity, Player, ScarPosition, PropertyBagGroup, etc.)
- **Batch 04** §3: Entity API (~150 functions — lifecycle, health, spatial, StateModel, production, weapons)
- **Batch 04** §4: Player API (~90 functions — identity, resources, population, abilities, visibility)
- **Batch 04** §5: Group APIs — SGroup (32 fn) & EGroup (26 fn) — structural symmetry
- **Batch 04** §6: EventRule system (22 functions — 4-scope event-driven architecture)
- **Batch 04** §7: Game API (~50 functions — state, timing, data store, sim control)
- **Batch 04** §8: UI API (~70 functions — event cues, kickers, minimap blips, tags, flash)
- **Batch 04** §9: Scar runtime (9 functions — Scar_DoFile module loading, no require)

### Layer 4 — APIs: TypeScript-to-Lua Pipeline
- **Batch 03** §1: TSTL core transpiler (tsconfig, targets, type declarations)
- **Batch 03** §2: AoE4 SCAR integration workflow (@aoemods/aoetypes, template project)

### Layer 5 — Patterns: SCAR Scripting
- **Batch 04** §6.2–§6.3: Event-driven architecture patterns (scope hierarchy, self-removal, pause/unpause)
- **Batch 04** §2.2: Type architecture (structured vs opaque handles, PropertyBagGroup composite key)
- **Batch 04** §5.3: SGroup/EGroup structural symmetry (shared API, domain-specific extensions)
- **Batch 04** §4.1: StateModel key-value store pattern (Entity/Player/Squad × 9 data types)
- **scar_skill_schema.json**: Reusable AI skill abstraction schema

### Layer 6 — Patterns: Lua OOP & Gamedev
- **Batch 03** §8: OOP library comparison (middleclass, classic, 30log, hump.class)
- **Batch 03** §9: HUMP gamedev utilities — portable patterns for SCAR
- **Batch 03** §10: awesome-lua ecosystem map with SCAR relevance ratings

### Layer 7 — Tools & Data: AoE4 Modding Ecosystem
- **Batch 04** §10: AOEMods.Essence (C# library — .sga, .rrtex, .rrgeom, .rgd conversion)
- **Batch 04** §11: aoemods/attrib (full game data dump — ebps, sbps, weapons, statemodel_schema)
- **Batch 04** §12: Community ecosystem (GitHub repos, Discord, forums)

---

## Quick-Access: Key Reference Tables

| Topic | Location | Description |
|---|---|---|
| **Copilot file map** | Batch 01 §1.1 | All customization file types, triggers, scopes |
| **Instruction precedence** | Batch 01 §2.1 | Priority chain (highest → lowest) |
| **10-component prompt framework** | Batch 01 §6.1 | Role, tone, data, task, examples, history, CoT, format |
| **TSTL tsconfig reference** | Batch 03 §1.2 | Minimal working configuration |
| **Lua target matrix** | Batch 03 §1.3 | All supported Lua targets |
| **LuaLS annotations** | Batch 03 §4.2 | Complete annotation syntax reference |
| **OOP library comparison** | Batch 03 §8.1 | Feature matrix across 4 libraries |
| **SCAR module taxonomy** | Batch 04 §1.1 | 60+ modules by domain (complete index) |
| **SCAR type system** | Batch 04 §2.1 | 32 types with field structures |
| **Entity API key signatures** | Batch 04 §3.1 | ~150 functions organized by domain |
| **Player API key signatures** | Batch 04 §4.1 | ~90 functions organized by domain |
| **EventRule architecture** | Batch 04 §6.1–§6.3 | 4-scope event system + patterns |
| **SGroup/EGroup symmetry** | Batch 04 §5.3 | Feature comparison table |
| **StateModel data types** | Batch 04 §3.1 (Entity) | Bool/Float/Int/Target/Vector3f/EnumTable |
| **Essence format support** | Batch 04 §10.2 | SGA/rrtex/rrgeom/RGD read/write/convert |
| **Attrib key directories** | Batch 04 §11.2 | ebps, sbps, abilities, weapons, statemodel_schema |
| **Enum reference** | Batch 04 §2.3 | CapType, RT, Relationship, UIEventType, etc. |
| **SCAR AI Skill Schema** | scar_skill_schema.json | JSON Schema for skill abstractions |

---

## Cross-Batch Terminology Normalization

| Canonical Term | Aliases / Prior Usage | Defined In |
|---|---|---|
| **EventRule** | Rule_* (incorrect), event rule, rule system | Batch 04 §6 |
| **PropertyBagGroup** | PBG, blueprint, blueprint reference | Batch 04 §2.1 |
| **StateModel** | state model, entity state, key-value store | Batch 04 §3.1, §4.1 |
| **ScarPosition** | position, pos, world position | Batch 04 §2.1 |
| **Scar_DoFile** | import, require (incorrect), module load | Batch 04 §9 |
| **TSTL** | TypeScriptToLua, TS-to-Lua | Batch 03 §1 |
| **LuaLS** | lua-language-server, sumneko-lua | Batch 03 §4 |
| **EBP/SBP** | entity blueprint, squad blueprint | Batch 04 §1.1, §11.2 |
| **branch_civ** | AGS_CIV_PARENT_MAP[player_civ], parent civ | Workspace convention |

---

## JSON Companion Files

Each batch has a companion `.json` file with structured metadata:
- `categories`: URL groupings by topic
- `key_patterns`: Machine-readable extraction of patterns, conventions, and config schemas
- Use JSON files for programmatic queries; use Markdown files for reading context

The `scar_skill_schema.json` is a standalone JSON Schema (draft 2020-12) defining the structure for reusable SCAR AI skill abstractions. It includes:
- **inputs/outputs** with SCAR type bindings and source/destination routing
- **triggers** mapped to EventRule_Add* calls with scope levels
- **state_dependencies** on StateModel keys with typed get/set function derivation
- **lifecycle** hooks (init/update/events/cleanup/save-restore)
- **composability** rules (conflicts, dependencies, civ variants, concurrency)
- **Example:** BuildingLimit skill demonstrating the schema
