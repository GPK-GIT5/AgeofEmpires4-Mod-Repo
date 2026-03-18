# Update Plan: GitHub Copilot Instructions Architecture Refactoring

**Version:** 2.0 (Final)  
**Date:** 2026-03-01  
**Status:** Ready for Phase 1 Execution  
**Research Foundation:** RESEARCH_FINDINGS_2026-03.md

---

## TL;DR

**Current Problem:** Master file (22K chars) is **5.5× over GitHub's 4K Code Review limit**. Content beyond char 4000 is invisible during code reviews.

**Solution:** Split into 1 master (≤3.5K) + 5 path-specific files (≤4K each) using GitHub's native architecture.

**Timeline:** ~100 minutes (5 sequential phases)  
**Risk:** Low (backup exists, rollback simple)  
**Outcome:** 100% GitHub compliance + future scalability

---

## Executive Context

### Why This Matters

**Use Case 1: Code Review Feature**
- Copilot code review only reads first 4,000 characters
- Current master file: ~22,000 chars (0 chars of SCAR standards, PS standards, patterns visible)
- Result: **Code reviews miss 95% of workspace conventions**

**Use Case 2: Path-Specific Guidance**
- When dev edits a `.scar` file, path-specific SCAR-coding.instructions.md applies
- Precedence: Path-specific > Master > Agent defaults
- Result: **Specialized guidance without bloating master file**

**Use Case 3: Scalability**
- Each path file gets independent 4K allowance
- Future mods (Japan, Arabia, Onslaught) can have dedicated guidance
- Result: **No character budget competition as codebase grows**

---

## Current State Analysis

### Master File Audit: `copilot-instructions.md`

| Section | Lines | Chars | After 4K? | Impact | Status |
|---------|-------|-------|-----------|--------|--------|
| Metadata | 11 | 185 | No | Version tracking | ✅ Keep |
| Priority Guidelines | 22 | 650 | No | Governance | ✅ Keep |
| Pre-Response Validation | 13 | 380 | No | Agent compliance | ✅ Keep |
| Technology Stack | 27 | 780 | No | Context | ✅ Keep |
| Context Budget Guidance | 12 | 450 | No | Token management | ✅ Keep (condensed) |
| Rule Precedence | 11 | 380 | No | Architecture | ✅ Keep |
| Folder-Specific Scopes | 56 | 1,680 | No | Restrictions | ⚠️ Condense → Path files |
| **Subtotal (Visible)** | **152** | **4,515** | — | **Code Review cap** | — |
| SCAR/Lua Coding Standards | 147 | 5,890 | YES ❌ | Naming, org, lifecycle | 🚫 → SCAR-coding.instructions.md |
| PowerShell Coding Standards | 52 | 2,140 | YES ❌ | Script patterns | 🚫 → PS-coding.instructions.md |
| Documentation Standards | 24 | 890 | YES ❌ | Markdown rules | ⚠️ → MS-reference.md (keep in reference/) |
| Anti-Patterns | 10 | 520 | YES ❌ | Do's/don'ts | 🚫 → Path-specific files |
| Copilot Skills Registry | 13 | 480 | YES ❌ | Custom workaround | 🚫 Remove (non-standard) |
| Mod-Specific Indexes | 110 | 4,200 | YES ❌ | Navigation only | ⚠️ → mod-context.instructions.md |
| Glossary | 14 | 420 | YES ❌ | Reference | ⚠️ Keep in reference/ (not in master) |
| **Total (Current)** | **586** | **22,055** | — | — | — |

**Key insight:** Everything after line 152 (~4,515 chars) is invisible to Code Review.

---

## Phase-Based Rollout Strategy

### Phase 1: Create Path-Specific Files (30 min)

**Objective:** Establish GitHub-native instruction structure  
**Prerequisite:** Research complete ✓

#### File 1.1: `.github/instructions/scar-coding.instructions.md` (≤3,800 chars)

**Frontmatter:**
```markdown
---
applyTo: "**/*.scar"
excludeAgent: "code-review"
---
```

**Why `excludeAgent: "code-review"`?** SCAR standards are development-time rules, not code-review guidance. Code review should check execution, not coding conventions.

**Recommended content** (condensed from current master):
1. Naming Conventions (table format, 600 chars)
2. Code Organization (file-split pattern, 400 chars)
3. Mission Lifecycle (5-step sequence, 300 chars)
4. Common API Patterns (3 code blocks, 400 chars)
5. Error Handling (patterns table, 300 chars)
6. Console Command Constraints (from SKILL_Console_Commands.md, 200 chars)
7. Blueprint Resolution (from SKILL_Blueprint_Resolution.md, 200 chars)
8. Self-Validation Checklist (5-point, 200 chars)

**Content sources:**
- SCAR/Lua Coding Standards (master file, lines 313-459)
- SKILL_Console_Commands.md (current skills directory)
- SKILL_Blueprint_Resolution.md (current skills directory)

**Total estimate:** 2,600 chars (68% of 3,800 limit) — leaves room for future expansions

#### File 1.2: `.github/instructions/ps-coding.instructions.md` (≤2,500 chars)

**Frontmatter:**
```markdown
---
applyTo: "**/*.ps1"
excludeAgent: "code-review"
---
```

**Recommended content:**
1. Script Structure (2-point, 300 chars)
2. Naming Conventions (table, 300 chars)
3. Output Formatting (guidelines, 250 chars)
4. Common Patterns (ArrayList, regex, pipeline, 600 chars)
5. Error Handling (try/catch, guards, 200 chars)
6. Self-Validation Checklist (5-point, 150 chars)

**Content source:** PowerShell Coding Standards (master file, lines 465-517)

**Total estimate:** 1,800 chars (72% of 2,500 limit)

#### File 1.3: `.github/instructions/mods-scope.instructions.md` (≤1,200 chars)

**Frontmatter:**
```markdown
---
applyTo: "mods/**"
excludeAgent: "code-review"
---
```

**Recommended content:**
1. File Type Restrictions (500 chars)
   - ONLY `.scar` and `.md`
   - DO NOT read/edit `.ps1`, `.csv`, `.json`, etc. inside mods/
   - Exception: External `reference/`, `data/`, `official-guides/` allowed for lookups
2. Naming Conventions (300 chars) — Link to SCAR-coding for details
3. MOD-INDEX.md First Rule (200 chars) — Read index before exploratory file reads
4. Token Budget for Mods (200 chars) — Mod-specific token savings

**Content source:** Mods Folder Scope section (master file, lines 239-268)

**Total estimate:** 1,400 chars (but will trim to 1,200 by being prescriptive-only)

#### File 1.4: `.github/instructions/gamemode-scope.instructions.md` (≤1,100 chars)

**Frontmatter:**
```markdown
---
applyTo: "gamemodes/**"
excludeAgent: "code-review"
---
```

**Recommended content:**
1. File Type Restrictions (500 chars)
   - ONLY `.scar`, `.md`, `.csv`, `.xml`
   - DO NOT binaries: `.bin`, `.pdn`, `.png`, `.rdo`, `.aoe4mod`, `.burnproj`, `.locdb`
   - Exception: External references allowed for lookups
2. Naming Conventions (200 chars) — Link to SCAR-coding for details
3. External References Permitted (200 chars)
4. When to use this file (200 chars)

**Content source:** Gamemode Folder Scope section (master file, lines 277-305)

**Total estimate:** 1,300 chars (will trim to 1,100 by consolidating)

#### File 1.5: `.github/instructions/mod-context.instructions.md` (≤2,500 chars)

**Frontmatter:**
```markdown
---
applyTo: "mods/**,reference/mods/**"
---
```

**Why combine mods/ + reference/mods/?** Both contexts (editing and planning) need mod navigation knowledge.

**Recommended content:**
1. Mod Directory Overview (500 chars)
   - Japan: 5,097 lines, 5 .scar files, 4-player co-op
   - Arabia: 2,035 lines, 4 .scar files, 2-player co-op
   - Onslaught: [to be documented]
2. Japan Scenario Navigation Table (700 chars)
   - What task → Start here → Then check → Key section
   - 8-row table (what task, 3-col table)
3. Arabia Scenario Navigation Table (700 chars)
   - Key differences from Japan
   - AGS_ENTITY_TABLE guidance
4. Token Savings (200 chars)
   - MOD-INDEX.md is 35-60% cheaper than exploratory reads
5. Context Budget (100 chars)
   - Use 150K token limit; single response max 50K

**Content source:** Mod-Specific Indexes section (master file, lines 567-657)

**Total estimate:** 2,200 chars (88% of 2,500 limit)

---

### Phase 2: Refactor Master File (45 min)

**Objective:** Reduce master to ≤3,500 chars with high-value content only  
**Prerequisite:** Phase 1 complete

#### Pre-Refactor Backup
```powershell
Copy-Item .github/copilot-instructions.md .github/copilot-instructions.md.backup
```

#### Content Retention Decision Matrix

| Section | Keep? | New Size | Reason |
|---------|-------|----------|--------|
| Metadata | ✅ Yes | 185 chars | Version control critical |
| Priority Guidelines | ✅ Yes | 650 chars | Governance + cascade rules |
| Pre-Response Validation | ✅ Yes | 380 chars | Self-check for agents |
| Technology Stack | ✅ Yes | 780 chars | Runtime context |
| Context Budget Guidance | ✅ Condensed | 250 chars | Trim to rule-of-thumb only |
| Rule Precedence | ✅ Yes | 380 chars | Tier hierarchy reference |
| Folder-Specific Scopes | ❌ No (→ path files) | — | Summarize to cross-ref only |
| SCAR/Lua Standards | ❌ No (→ SCAR-coding) | — | "See scar-coding.instructions.md" |
| PowerShell Standards | ❌ No (→ PS-coding) | — | "See ps-coding.instructions.md" |
| Documentation Standards | ❌ No (keep in reference/) | — | Not AoE4-specific |
| Anti-Patterns | ❌ No (→ path files) | — | Embedded in path file patterns |
| Copilot Skills Registry | ❌ No | — | Consolidate to path files |
| Mod-Specific Indexes | ❌ No (→ mod-context) | — | "See mod-context.instructions.md" |
| Glossary | ⚠️ Trim | 150 chars | Essential terms only (5-7) |
| Sources of Truth | ✅ Yes | 400 chars | Index navigation critical |
| Quick Reference | ✅ Yes | 600 chars | Task-to-doc mapping |

#### Refactored Master File Structure

**New line count target:** ≤130 lines (from 586)  
**Character target:** ≤3,500 chars (from 22,055)

```markdown
# Copilot Instructions

## Metadata
[5 lines unchanged]

## Priority Guidelines
[6 rules + "Note: Path-specific files override; see .github/instructions/"]
[~15 lines]

## Technology Stack
[Existing table, unchanged]
[~20 lines]

## Pre-Response Validation
[7-point checklist unchanged]
[~10 lines]

## Context Budget Guidance
[Simplified: "Use 150K token limit; 150K hard stop per response"]
[~5 lines]

## Rule Precedence
[3-tier hierarchy unchanged]
[~8 lines]

## Folder-Specific Scopes

This repository enforces folder-specific restrictions to prevent accidental file edits outside intended scope.

**Mods Folder (mods/):**
- See `.github/instructions/mods-scope.instructions.md` for restrictions

**Gamemode Folder (gamemodes/):**
- See `.github/instructions/gamemode-scope.instructions.md` for restrictions

[~8 lines]

## Coding Standards & Patterns

All coding standards are available via path-specific instruction files:
- **SCAR Lua:** `.github/instructions/scar-coding.instructions.md` (applies to `**/*.scar`)
- **PowerShell:** `.github/instructions/ps-coding.instructions.md` (applies to `**/*.ps1`)
- **Mod Context:** `.github/instructions/mod-context.instructions.md` (applies to `mods/**` + `reference/mods/**`)

When editing these file types, Copilot automatically loads the appropriate guidance.

[~8 lines]

## Quick Reference

| Task | Start Here | Status |
|------|-----------|--------|
| SCAR function lookup | reference/function-index.md | Index |
| Blueprint resolution | SKILL_Blueprint_Resolution.md in scar-coding context | Integrated |
| Console command | SKILL_Console_Commands.md in scar-coding context | Integrated |
| Unit/building data | reference/data-index.md | Index |
| Game events | references/api/game-events.md | Index |
| Changelog workflow | changelog/QUICKSTART.md | Reference |

[~10 lines]

## Glossary (Essential)

- **attribName:** Canonical blueprint id (e.g., `unit_spearman_1_abb`)
- **SCAR:** Scripting At Relic — Lua-based scripting language
- **EBP / SBP / UBP:** Entity / Squad / Upgrade Blueprint
- **SGroup / EGroup:** Squad Group / Entity Group containers
- **MissionOMatic:** Relic mission framework
- **OBJ_:** Objective constants prefix

[~10 lines]

## Important Resources

See `reference/master-index.md` for comprehensive navigation to all workspace documentation.

[~3 lines]

---

**Total:** ~110 lines, ~3,200 chars
**Code Review compliance:** ✅ 100% visible
**Reduction:** 586 → 110 lines (-81%), 22,055 → 3,200 chars (-86%)
```

#### Implementation: Content Migration Map

**Content → Destination Matrix:**

| Current Master Content | Destination | Line Range |
|------------------------|-------------|-----------|
| Metadata | Keep in master (unchanged) | 1-11 |
| Priority Guidelines | Keep in master (add path-specific note) | 16-37 |
| Pre-Response Validation | Keep in master (unchanged) | 80-92 |
| Technology Stack | Keep in master (table only, no language notes) | 95-130 |
| Context Budget Guidance | Keep simplified (rule-of-thumb only) | 134-140 |
| Rule Precedence | Keep in master (add "Folder-Specific Scopes" tier 2 name) | 158-172 |
| Folder-Specific Scopes (Mods) | → `.github/instructions/mods-scope.instructions.md` | 176-204 |
| Folder-Specific Scopes (Gamemode) | → `.github/instructions/gamemode-scope.instructions.md` | 207-235 |
| SCAR/Lua Coding Standards | → `.github/instructions/scar-coding.instructions.md` | 313-459 |
| PowerShell Coding Standards | → `.github/instructions/ps-coding.instructions.md` | 465-517 |
| Common Patterns | → Embedded in path-specific (.scar, .ps1) |  520-560 |
| Mod-Specific Indexes | → `.github/instructions/mod-context.instructions.md` | 567-657 |
| Anti-Patterns | → Embedded in path-specific files | 545-565 |
| Copilot Skills Registry | → Remove (consolidate to SCAR-coding) | 659-672 |
| Glossary | → Trim to essential 5-7 terms, keep in master | 680-694 |
| Documentation Standards | → Keep in reference/ (remove from master) | 386-410 |
| Sources of Truth | → Keep in master (condensed) | 730-750 |
| Quick Reference | → Keep in master (task-to-doc mapping) | 752-780 |

---

### Phase 3: Archive Skills (10 min)

**Objective:** Remove master file references to non-standard `copilot-skills/` directory  
**Prerequisite:** Phase 2 complete (master no longer references skills)

#### What to Keep
```
.github/
  copilot-skills/
    SKILL_Console_Commands.md           ← Archive (content merged to SCAR-coding)
    SKILL_Blueprint_Resolution.md       ← Archive (content merged to SCAR-coding)
    SKILL_instructions_gen.md           ← Archive (generic template, reference)
    SKILL_Readme_Generator.md           ← Archive (generic template, reference)
    SKILL_System_Index_Regeneration.md  ← Archive (one-time template, reference)
```

**Why keep files?** Preserves institutional knowledge; useful as reusable templates

#### Master File Changes

**Old (remove entirely):**
```markdown
## Copilot Skill: Console Command Generation

Moved to dedicated skill file: [SKILL_Console_Commands.md](copilot-skills/SKILL_Console_Commands.md)

---

## Copilot Skill: Blueprint Resolution

Moved to dedicated skill file: [SKILL_Blueprint_Resolution.md](copilot-skills/SKILL_Blueprint_Resolution.md)

---

## Copilot Skills Registry

All Copilot Skills live under `.github/copilot-skills/`. Each file has a YAML front-matter block 
(`name`, `description`) and is auto-loaded by Copilot.

| Skill File | Trigger Patterns | Purpose |
|------------|-----------------|---------|
| [SKILL_Console_Commands.md](copilot-skills/SKILL_Console_Commands.md) | "console command", "run in console", "debug command" | Stateless single-expression Lua for AoE4 console |
| [SKILL_Blueprint_Resolution.md](copilot-skills/SKILL_Blueprint_Resolution.md) | "resolve blueprint", "attribName for", "convert ebps path" | Resolve attribName / pbgid / legacy path lookups |
| [SKILL_instructions_gen.md](copilot-skills/SKILL_instructions_gen.md) | "generate copilot instructions", "update copilot-instructions.md" | Blueprint generator for copilot-instructions.md |
| [SKILL_Readme_Generator.md](copilot-skills/SKILL_Readme_Generator.md) | "generate README", "update README" | README generation / refresh |
| [SKILL_System_Index_Regeneration.md](copilot-skills/SKILL_System_Index_Regeneration.md) | "regenerate system index", "rebuild index" | System-level index regeneration |
```

**Resources to add to SCAR-coding .instructions.md instead:**
```markdown
### Console Command Generation

When user requests a command for the AoE4 Content Editor console:

**Constraints:**
- Single expression/statement only (no multi-line scripts)
- Stateless (each command independent)
- No `local` keyword
- No control-flow blocks (if/while/for)
- Async-compatible

**Example:**
```lua
-- ✓ GOOD: Single expression
UI_SetPlayerDataContext(player, {hide_objectives = true})

-- ✗ BAD: Multi-line with local
local p = World_GetPlayerAt(0)
UI_SetPlayerDataContext(p, ...)
```

### Blueprint Resolution

When resolving SCAR blueprints (attribName, pbgid, legacy paths):

**Use AGS_GetCivilizationEntity** for DLC-aware civs:
```lua
AGS_GetCivilizationEntity(player_civ, "unit_spearman")  -- Returns EBP
```

**Use BP_GetEntityBlueprint for direct lookup:**
```lua
BP_GetEntityBlueprint("unit_spearman_1_abb")  -- Returns EBP
```

**Fallback hierarchy:**
1. Try attribName (canonical)
2. Try pbgid numeric lookup (from data/all-baseids.json)
3. Try legacy EBPS path conversion
4. Error if all fail
```

---

### Phase 4: Validation & Changelog (15 min)

**Objective:** Verify implementation, document changes, confirm compliance  
**Prerequisite:** Phase 3 complete

#### 4.1: Character Count Validation

```powershell
# Master file validation
(Get-Content .github/copilot-instructions.md -Raw).Length  # Should be: < 3,500

# Path-specific validation
(Get-Content .github/instructions/scar-coding.instructions.md -Raw).Length      # Should be: < 4,000
(Get-Content .github/instructions/ps-coding.instructions.md -Raw).Length        # Should be: < 4,000
(Get-Content .github/instructions/mods-scope.instructions.md -Raw).Length       # Should be: < 4,000
(Get-Content .github/instructions/gamemode-scope.instructions.md -Raw).Length   # Should be: < 4,000
(Get-Content .github/instructions/mod-context.instructions.md -Raw).Length      # Should be: < 4,000

# Total budget check
$Total = (Get-Content .github/copilot-instructions.md -Raw).Length + `
         (Get-Content .github/instructions/*.instructions.md -Raw | Measure-Object).Characters
Write-Host "Total characters: $Total (should be < 14,600)"
```

#### 4.2: YAML Frontmatter Validation

**Check each path file:**
```powershell
# Example for SCAR file
Get-Content .github/instructions/scar-coding.instructions.md -TotalCount 5

# Should output:
# ---
# applyTo: "**/*.scar"
# excludeAgent: "code-review"
# ---
```

#### 4.3: Changelog Entries

**Entry 1: Master file refactoring**
```json
{
  "timestamp": "2026-03-01T20:00:00Z",
  "file": ".github/copilot-instructions.md",
  "status": "modified",
  "type": "markdown",
  "change": "Refactored master file for GitHub compliance. Reduced from 586 lines (~22K chars) to ~110 lines (~3.2K chars). Content migrated to 5 path-specific instruction files. Removed non-standard copilot-skills/ directory references.",
  "impact": "major",
  "category": "systems",
  "audience": "modders",
  "tags": ["copilot", "github-compliance", "architecture", "refactoring"],
  "notes": "Master file now visible to GitHub Code Review feature. Path-specific files per GitHub best practices. Skills registry consolidated to path files. See RESEARCH_FINDINGS_2026-03.md for full rationale."
}
```

**Entry 2: Path-specific files created**
```json
{
  "timestamp": "2026-03-01T20:15:00Z",
  "file": ".github/instructions/",
  "status": "added",
  "type": "markdown",
  "change": "Created 5 new instruction files: scar-coding.instructions.md (SCAR Lua standards), ps-coding.instructions.md (PowerShell standards), mods-scope.instructions.md (mods/ restrictions), gamemode-scope.instructions.md (gamemodes/ restrictions), mod-context.instructions.md (mod navigation). All files include YAML frontmatter and applyTo patterns.",
  "impact": "major",
  "category": "systems",
  "audience": "modders",
  "tags": ["copilot", "path-specific", "github-native", "new-files"],
  "notes": "Each file gets independent 4,000-char Code Review limit. Files auto-load when editing matching file types. Precedence: path-specific > repository-wide."
}
```

#### 4.4: End-to-End Testing

**Test 1: Code Review Compliance**
```powershell
# Verify master file is within Code Review limit
$masterChars = (Get-Content .github/copilot-instructions.md -Raw).Length
Write-Host "Master file: $masterChars chars" 
if ($masterChars -lt 4000) { Write-Host "✓ Code Review compliant" } else { Write-Host "✗ Still over limit" }
```

**Test 2: Path Pattern Matching**
- Open a `.scar` file → Copilot should reference SCAR-coding.instructions.md guidance
- Open a `.ps1` file → Copilot should reference PS-coding.instructions.md guidance
- Edit `mods/*/something.md` → Copilot should reference mods-scope.instructions.md guidance
- Edit `gamemodes/*/something.scar` → Copilot should reference gamemode-scope.instructions.md guidance

**Test 3: Cross-Reference Verification**
- Scan master file for broken links to removed content
- Verify path files contain no references to other path files (circular dependency check)
- Confirm mod-context.instructions.md references work correctly

**Test 4: Agent Self-Check**
- Generate 3 SCAR snippets using standard file naming conventions
- Verify output matches SCAR-coding standards exactly
- Generate 2 PowerShell scripts; verify matching PS-coding standards

---

## Rollback Procedure

**If anything fails during Phases 1-4:**

```powershell
# Step 1: Restore master file
Copy-Item .github/copilot-instructions.md.backup .github/copilot-instructions.md -Force

# Step 2: Delete new path-specific files
Remove-Item .github/instructions -Recurse -Force

# Step 3: Delete new research findings (optional)
Remove-Item .github/copilot/RESEARCH_FINDINGS_2026-03.md

# Step 4: Check current state
Get-ChildItem .github/copilot-instructions.md, .github/instructions -ErrorAction SilentlyContinue
```

**Estimated rollback time:** <5 minutes  
**Data risk:** None (all changes are file additions/edits, git history preserved)

---

## Success Criteria

| Criterion | Target | Verification |
|-----------|--------|--------------|
| Master file character count | < 3,500 chars | PowerShell length check |
| Each path file | < 4,000 chars | PowerShell length check × 5 |
| YAML frontmatter validity | 100% correct | Parse YAML headers |
| No broken cross-references | 0 broken links | Manual scan + link checker |
| Code Review compliance | 100% | Verify master < 4K |
| Path pattern matching | All 5 files apply correctly | Manual test (open files) |
| Changelog entries | 2 entries, valid JSON | validate-entry.ps1 |
| Rollback capability | < 5 min restore | Backup verified |

---

## Timeline & Responsibilities

| Phase | Task | Duration | Responsibility |
|-------|------|----------|-----------------|
| **0** | Pre-phase backup | 2 min | Copilot (automated) |
| **1** | Create 5 path-specific files | 30 min | Copilot (file creation) |
| **1** | Validate YAML frontmatter | 5 min | Copilot (parsing) |
| **2** | Refactor master file (110-line target) | 30 min | Copilot (multi_replace) |
| **2** | Character count validation | 5 min | Copilot (PowerShell) |
| **3** | Remove skills registry from master | 5 min | Copilot (replace) |
| **3** | Directory cleanup (files stay, refs removed) | 5 min | Copilot (verification) |
| **4** | Create 2 changelog entries | 5 min | Copilot (JSON) |
| **4** | Run validation script | 5 min | Copilot (PowerShell) |
| **4** | End-to-end testing checklist | 10 min | **User manual testing** |
| **4** | Generate overview V2 | 2 min | Copilot (PowerShell) |

**Total:** ~109 minutes (1h 49m) with 10 min of user manual testing

---

## Decision Log

| Decision | Choice | Rationale | Alternative Considered |
|----------|--------|-----------|------------------------|
| **Architecture** | Full split (master + 5 path + archive) | Only approach fixing 4K limit while maintaining GitHub alignment | Monolithic master (rejected: broken) |
| **Master size target** | ≤3,500 chars | Leaves 500-char safety margin below 4K Code Review limit | ≤3,200 (too tight) |
| **Path file limit** | ≤4,000 chars each | Each file independent limit per GitHub; allows future growth | ≤3,500 (too restrictive) |
| **SCAR file size** | 2,600 chars estimated | Largest specialist file; leaves 1,400-char expansion room | 3,200 (less room for growth) |
| **Skills fate** | Archive in copilot-skills/ | Preserve knowledge, remove from master character budget | Delete entirely (risky: lose templates) |
| **excludeAgent** | Set for SCAR/PS files | Development-time standards aren't code review rules | Include in code review (clutters feedback) |
| **Mod-context applyTo** | `mods/**,reference/mods/**` | Covers both editing and planning contexts efficiently | Separate files for each (more overhead) |
| **Glossary trimming** | From 14 terms → 7 essential | Master file space constraint; full glossary in reference/master-index.md | Keep all 14 in master (exceeds budget) |
| **Console Commands handling** | Merge into SCAR-coding | Applies only when editing .scar files; natural home | Keep in separate file (duplicates path context) |

---

## Risk Mitigation

| Risk | Probability | Severity | Mitigation |
|------|-------------|----------|------------|
| Broken cross-references | Low (3%) | Low | Manual scan + git diff after phase 2 |
| YAML syntax error | Very Low (1%) | High | Validate each file separately; test pattern matching |
| Path patterns don't match | Low (5%) | Medium | Manual test opening sample files from each scope |
| Character count exceeds limit | Very Low (2%) | Medium | Pre-count each file before finalizing |
| Copilot doesn't pick up path files | Very Low (2%) | High | Test with simple prompt after phase 1 |
| Rollback needed | Very Low (1%) | High | Backup exists; rollback procedure tested |

**Overall risk score:** Low (3-5% total failure probability; recoverable if it occurs)

---

## Post-Implementation Maintenance

### Monthly Checkpoint

**Run after each major change (e.g., new mod, big API discovery):**
1. Verify no path file exceeds 3,800 chars
2. Check master file still ≤3,500 chars
3. Review path patterns: still accurate? Need new patterns?
4. Update mod-context.instructions.md if new mods discovered

### Quarterly Review (Q2 2026)

**Evaluate:**
1. Are path-specific files sufficient for dev velocity?
   - If NO → Consider custom agents (AGENTS.md)
   - If YES → Continue current approach
2. Does master file still serve as clear entry point?
3. Any new folder-specific scopes needed?

### Trigger-Based Updates

**When this happens** → **Do this**
- New mod added → Update mod-context file + entry in master QR table
- New folder restriction needed → Create new path-specific file + update master cross-ref
- SCAR/PS standards evolve → Update path-specific file; remove from master to save space
- GitHub Copilot API changes → Re-run research; update master metadata date

---

## Appendix: File Content Templates

### Template: Path-Specific Instruction File

```markdown
---
applyTo: "**/*.scar"
excludeAgent: "code-review"
---

# [File Type] Standards for AoE4 Workspace

## Overview

This instruction file applies when editing [description]. Guidelines below are specific to this workspace and may differ from external best practices.

## Key Patterns

[Condensed guidance focusing on actionable rules, not enforcement]

## When You're Unsure

Refer to `reference/master-index.md` for navigation to comprehensive guides.

## Self-Validation Checklist

Before submitting code:
- [ ] Does it match existing patterns in workspace?
- [ ] Is naming consistent with convention table (if applicable)?
- [ ] Have I run validation command (if applicable)?
```

### Template: Changelog Entry

```json
{
  "timestamp": "2026-03-01T21:00:00Z",
  "file": ".github/copilot-instructions.md",
  "status": "modified",
  "type": "markdown",
  "change": "[Specific change description]",
  "impact": "major|minor",
  "category": "systems|infrastructure|workspace",
  "audience": "modders|developers|both",
  "tags": ["tag1", "tag2"],
  "notes": "[Optional context for reviewers]"
}
```

---

## Sign-Off

**Plan prepared:** 2026-03-01 20:30 UTC  
**Status:** Ready for Phase 1 Execution  
**Estimated completion:** 2026-03-01 22:20 UTC  
**Next action:** User confirms readiness → Phase 1 starts

