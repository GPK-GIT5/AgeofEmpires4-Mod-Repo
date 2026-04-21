---
applyTo: "Gamemodes/Onslaught/assets/scar/debug/**"
---

# Debugger Architecture — Canonical Spec

> **Single source of truth** for the Onslaught split debugger topology, namespace hierarchy, and state tables.
> Command catalog and tag registry live in `.skills/scar-debug/SKILL.md`.

## Branch & Entry Chain

`onslaught-v3.3` — `cba.scar` → `import("debug/cba_debug.scar")` → 27 sub-file imports.

## Namespace Hierarchy

The `debug` global table provides structured access to all debug functionality. Populated at load time by `if debug then ... end` self-registration blocks in each domain file.

```
debug
├── run(tag)              -- Primary dispatcher (nil/"all" → Debug_RunAll)
├── list(filter)          -- Discovery: show registered tags
├── status()              -- Show populated sub-tables and function counts
├── _register(tag, fn)    -- Internal: register a tag handler
├── _registry             -- Internal: tag → {handler, description, tier}
├── _safety               -- Safety layer for destructive commands
│   ├── exclude_human     -- bool (default true)
│   ├── include_human()   -- Unlock human player targeting
│   ├── exclude_human_reset()
│   ├── validate_target(idx)
│   └── is_test_lobby()
├── playerUI              -- 11 functions, .run() async sub-orchestrator
├── players               -- 21 functions, .run(idx) safety-gated delegation
├── siege                 -- 5 functions, .run() async sub-orchestrator
├── data                  -- 14 functions, .run() sync sequential
├── limits                -- 5 functions
├── inspect               -- 18 functions
├── helpers               -- 15 functions
├── validation            -- 13 functions
├── ai                    -- 3 functions
├── qa                    -- 4 functions
└── prompt                -- 5 functions
```

## Orchestration

### Master Orchestrator (`Debug_RunAll`)

Queues 9 suites via `_Debug_MasterEnqueue` → `_Debug_MasterAdvance`. Waits for `_Debug_EndMarker` after each suite before advancing. Crash-protected: pcall wraps each suite launch; on failure, records 0/1 and auto-recovers to next suite.

### Sub-Orchestrator (`_Debug_Sub*`)

System-level `.run()` functions use a parallel queue: `_Debug_SubStart` → `_Debug_SubEnqueue` → `_Debug_SubLaunch` → `_Debug_SubAdvance`. Same EndMarker-driven chaining. `_Debug_SubFinalReport` fires its own EndMarker so the master can chain sub-orchestrator results.

**Constraint:** Only one sub-orchestrator active at a time. `_cba_debug._sub` is a singleton.

### EndMarker Hook

`_Debug_EndMarker(suite_name, passed, total, elapsed)` checks both `_cba_debug._master.awaiting` and `_cba_debug._sub.awaiting` to advance the correct orchestrator.

## Tag Registry (22 tags)

Each domain file registers tags via `debug._register(tag, handler, desc, tier)`. Tags are dispatched by `debug.run(tag)` with pcall crash protection. See `.skills/scar-debug/SKILL.md` § Tag Registry for the full table.

## Module Table (33 files)

| # | File | Purpose |
|---|------|---------|
| 1 | `cba_debug.scar` | Entry point — imports all sub-files, seals module registry |
| 2 | `cba_debug_settings.scar` | Centralized settings registry — typed flags, accessor API |
| 3 | `cba_debug_registry.scar` | Module manifest registry — dependency tracking, auto-discovery |
| 4 | `cba_debug_rules.scar` | Rule/invariant registry — declarative validation with severity levels |
| 5 | `cba_debug_core.scar` | State `_cba_debug`, `debug` table, tag dispatch, master/sub orchestrators, safety layer, step mode, hooks |
| 6 | `cba_debug_helpers.scar` | Baseline resources, spawn, smoke tests |
| 7 | `cba_debug_validation.scar` | 6-phase validation |
| 8 | `cba_debug_inspectors.scar` | Read-only state inspectors |
| 9 | `cba_debug_stress.scar` | 8-stage stress test (16 civs) |
| 10 | `cba_debug_coverage.scar` | 10-batch API coverage |
| 11 | `cba_debug_event_probes.scar` | Mock-context event probes |
| 12 | `cba_debug_destructive.scar` | Force destroy/eliminate/surrender/transfer |
| 13 | `cba_debug_limits_ui.scar` | Building/siege limit UI diagnostics |
| 14 | `cba_debug_leaver.scar` | Disconnect/transfer/annihilation edge cases |
| 15 | `cba_debug_spawn_sequences.scar` | Table-driven spawn plans |
| 16 | `cba_debug_advanced_stress.scar` | 6 extreme-edge stress scenarios |
| 17 | `cba_debug_ui_prompts.scar` | UI-driven interactive checks |
| 18 | `cba_debug_comprehensive_stress.scar` | 12-category stress suite |
| 19 | `cba_debug_ai_behavior.scar` | 8-scenario AI behavior validation |
| 20 | `cba_debug_ai_player.scar` | 10-phase AI player module validation suite |
| 21 | `cba_debug_ai_stress.scar` | 15-category AI player stress-test suite |
| 22 | `cba_debug_qa_runner.scar` | 8-topic Q&A diagnostic runner |
| 23 | `cba_debug_playerui.scar` | PlayerUI init/data/rendering |
| 24 | `cba_debug_playerui_anim.scar` | PlayerUI animation/crash isolation |
| 25 | `cba_debug_scenario.scar` | 7-stage scenario orchestrator |
| 26 | `cba_debug_siege_test.scar` | Quick siege-limit validation |
| 27 | `cba_debug_autopop.scar` | Population baseline and cap verification |
| 28 | `cba_debug_battle_lag.scar` | Battle lag diagnosis and performance harness |
| 29 | `cba_debug_boon_selection.scar` | Boon selection panel debugging utilities |
| 30 | `cba_debug_blueprint_audit.scar` | Blueprint existence audit |
| 31 | `cba_debug_civ_overview.scar` | Civ data overview and consistency |
| 32 | `cba_debug_data_extract.scar` | Runtime BP/cost/garrison extraction |
| 33 | `cba_verify_military_pipeline.scar` | Leaver military suffix/class-fallback verification |

## Source Filenames (onslaught-v3.3)

| File | Purpose |
|------|---------|
| `rewards/cba_rewards.scar` | Kill rewards, civ-specific reward tables |
| `cba_annihilation.scar` | Annihilation win condition |
| `cba_religious.scar` | Sacred site / religious victory |
| `wonder.scar` | Wonder victory |
| `cba_options.scar` | Building limits, option parsing |
| `cba_auto_age.scar` | Auto-age system |
| `ags_global_settings.scar` | Global settings (~80+ fields) |
| `gameplay/cba_economy.scar` | Economy |

## State Tables

| Table | Source | Key Fields |
|-------|--------|------------|
| `_mod` | cba.scar | module, castles, speed, pop_cap, pop_interval, objective |
| `_CBA` | cba_rewards.scar | module, rewards, center, obj_kill_title |
| `_buildingLimit` | cba_options.scar | module, objective_buildingLimit |
| `_autoage` | cba_auto_age.scar | module, options |
| `_annihilation` | cba_annihilation.scar | type_map, types, sfx, cue |
| `_religious` | cba_religious.scar | sites, time_victory, conversion_radius |
| `_wonder` | wonder.scar | time_victory, FOWRadius, types |
| `AGS_GLOBAL_SETTINGS` | ags_global_settings.scar | ~80+ fields |

## Known Audit Findings

> Full details, root cause, and verification in [known-issues.instructions.md](../coding/known-issues.instructions.md).

| — | Finding | Registry | Status |
|---|---------|----------|--------|
| a | Building-limit counters desync after `Entity_SetPlayerOwner` (no construction events) | [KI-SIEGE-001] | ACTIVE |
| b | English keeps dual-classified in production counting | [KI-SIEGE-002] | ACTIVE |
| c | `Player_SetMaximumAge` returns early at AGE_IMPERIAL — cannot uncap; use `CBA_AutoAge_SetMaximumAge` | [KI-AGE-001] | MITIGATED |
| d | Siege-limit disable: 4-tier restriction cascade (civ-specific) | — | Documented |
| e | Phase 3 civ-sync tests 3.1b–3.1e validate `AGS_CIV_PREFIXES` against `AGS_ENTITY_TABLE`, `_CBA.rewards`, `CBA_CIV_BP_SUFFIX`, and `_LEAVER_MILITARY_SUFFIX_OVERRIDE`. Arena placeholder aliases (japanese→ottoman, byzantine→abbasid) are warn-only in 3.1c. | — | Documented |
