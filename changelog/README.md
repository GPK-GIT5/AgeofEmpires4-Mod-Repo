# Changelog Directory — Dual Format with Scope Separation

This directory maintains change logs in two formats for different audiences and use cases, organized into **3 scopes** for better separation and queryability.

## Directory Structure

```
changelog/
├── README.md (this file)
├── mods/
│   ├── 2026-02.md (human-readable mod changes)
│   └── INDEX.jsonl (AI-parseable mod changes)
├── system/
│   ├── 2026-02.md (human-readable changelog infrastructure changes)
│   └── INDEX.jsonl (AI-parseable system changes)
├── workspace/
│   ├── 2026-02.md (human-readable workspace changes)
│   └── INDEX.jsonl (AI-parseable workspace changes)
└── archive/ (historical logs)
```

## Scope Definitions

| Scope | Tracks | Directory Paths | Excludes |
|-------|--------|-----------------|----------|
| **mods/** | All changes in mods directory | `mods/**` | None |
| **system/** | Changelog infrastructure changes | `changelog/**` (README, scripts, templates) | Actual log content (`.md`, `.jsonl` entries) |
| **workspace/** | All other workspace changes | `reference/`, `data/`, root configs, scripts, guides | `mods/`, `changelog/` |

**Scope is implicit:** Determined by which subdirectory contains the log files, not by a schema field.

## Format Overview

### 1. Human-Readable Logs (`YYYY-MM.md`)
- **Location:** `mods/2026-02.md`, `system/2026-02.md`, `workspace/2026-02.md`
- **Format:** Markdown narrative with context, hierarchy, and notes
- **Audience:** Project team, maintainers, documentation reviewers
- **Content:** Auto-generated overview table + detailed change descriptions, impact analysis, related tasks, notes
- **Use:** Manual review, release notes, project history
- **Auto-Overview:** Run `generate-overview.ps1 -Scope <scope>` to insert/update summary table

**Example:**
```markdown
## [2026-02-24] Reference Documentation Consolidation

**Summary:** Unified reference directory navigation with centralized INDEX.md hub.

**Changes:**

### reference/ (Documentation Updates)
- **INDEX.md** [Added]
  [Detailed description of what changed and why]
  *Impact: AI-readiness, discoverability.*
```

---

### 2. AI-Parseable Logs (`INDEX.jsonl`)
- **Location:** `mods/INDEX.jsonl`, `system/INDEX.jsonl`, `workspace/INDEX.jsonl` (append-only per scope)
- **Format:** JSONL (JSON Lines) — one object per line, newline-delimited
- **Audience:** Automated tools, AI analysis, change tracking systems
- **Content:** Structured data with consistent schema (scope determined by file location)
- **Use:** Automated diff generation, change queries, version history analysis, integration with CI/CD

**Schema (per line):**
```json
{
  "timestamp": "ISO 8601 string (UTC)",
  "file": "relative/path/to/file",
  "status": "added|modified|removed",
  "type": "markdown|json|csv|powershell|typescript|config",
  "change": "1-line description of change",
  "impact": "critical|major|minor|bugfix|documentation|refactor|internal|other",
  "category": "reference|data|mods|scripts|guides|systems|other",
  "audience": "scripters|modders|testers|users|api-tools",
  "metrics": "optional comma-separated values",
  "tags": ["tag1", "tag2"]
}
```

**Example:**
```jsonl
{"timestamp":"2026-02-24T00:00:00Z","file":"reference/INDEX.md","status":"added","type":"markdown","change":"Created comprehensive navigation hub with CSV schema legend","impact":"ai-readiness","category":"reference","audience":"api-tools","metrics":"8989_functions,14158_globals","tags":["navigation","metadata"]}
```

---

## Usage Instructions

### Adding a New Entry

1. **After making changes, create JSONL entries:**
   - Use `validate-entry.ps1` to verify schema compliance
   - Generate entries manually or via AI assistance

2. **Auto-detect the correct scope:**
   - The prompt generates entries with file paths
   - **Automatic scope routing** (no manual choice needed):
     - If ANY file path starts with `mods/` → append entries to **mods/** scope
     - Else if ANY file path matches `changelog/` → append entries to **system/** scope
     - Else (reference/, data/, guides/, scripts/, root) → append entries to **workspace/** scope
   - *Example: If you edited `reference/INDEX.md` and `data/buildings.json`, both go to workspace/*

3. **Validate before appending (IMPORTANT):**
   ```powershell
   # Test each JSONL line with schema validator
   $entry = '{"timestamp":"2026-02-24T14:30:00Z","file":"reference/INDEX.md",...}'
   .\ validate-entry.ps1 -Entry $entry
   
   # Output:
   # ✓ VALID ENTRY
   #   File: reference/INDEX.md
   #   Status: added
   #   Impact: ai-readiness
   ```
   - Only append to INDEX.jsonl if validation passes
   - Fixes malformed JSON **before** it corrupts the log

4. **Append to AI log (mods/INDEX.jsonl, etc):**
   ```bash
   # Only add lines that passed validate-entry.ps1
   {"timestamp":"...","file":"...","status":"..."}
   ```

5. **Generate human-readable changelogs:**
   ```powershell
   # Auto-generate dashboard + detailed entries
   .\generate-overview.ps1 -Scope workspace
   .\generate-detailed-entries.ps1 -Scope workspace
   ```

6. **Alternative: Manual detailed entries (mods/2026-02.md, etc):**
   ```markdown
   ## [YYYY-MM-DD] Your Session Title
   [Write detailed descriptions based on JSONL entries]
   ```

7. **Old workflow reference:**
   ```bash
   # Only add lines that passed validate-entry.ps1
   {"timestamp":"...","file":"...","status":"..."}
   ```

### Querying AI Log

**Single-scope queries (PowerShell + jq):**
```powershell
# Parse all workspace changes affecting reference/
Get-Content workspace\INDEX.jsonl | jq 'select(.file | startswith("reference/"))'

# Find all balance-related changes in mods scope
Get-Content mods\INDEX.jsonl | jq 'select(.impact=="balance")'

# Extract file list from system scope
Get-Content system\INDEX.jsonl | jq -r '.file' | sort | uniq
```

**Cross-scope queries:**
```powershell
# Find all balance changes across mods AND workspace
Get-Content mods\INDEX.jsonl,workspace\INDEX.jsonl | jq 'select(.impact=="balance")'

# List all files touched across all scopes
Get-Content mods\INDEX.jsonl,system\INDEX.jsonl,workspace\INDEX.jsonl | jq -r '.file' | sort | uniq

# Count entries per scope
"Mods: $(Get-Content mods\INDEX.jsonl | Measure-Object -Line | Select-Object -ExpandProperty Lines)"
"System: $(Get-Content system\INDEX.jsonl | Measure-Object -Line | Select-Object -ExpandProperty Lines)"
"Workspace: $(Get-Content workspace\INDEX.jsonl | Measure-Object -Line | Select-Object -ExpandProperty Lines)"
```

### Auto-Generating Overview Tables

**Generate compact summary for a scope:**
```powershell
.\generate-overview.ps1 -Scope mods
.\generate-overview.ps1 -Scope system
.\generate-overview.ps1 -Scope workspace
```

This scans the scope's `INDEX.jsonl`, groups by date, and inserts/updates a summary table at the top of the monthly `.md` file:

```markdown
## Quick Overview

| Date | Files Changed | Key Areas | Details |
|------|---------------|-----------|------| 
| 2026-02-24 | 5 | balance, units | [→](#2026-02-24) |
```

---

## Schema Consistency Rules

To maintain AI-readiness, follow these rules when adding entries. Use `validate-entry.ps1` to check before appending.

| Field | Valid Values | Notes |
|-------|--------------|-------|
| `timestamp` | ISO 8601 UTC (e.g., `2026-02-24T14:30:00Z`) | Required; use same timestamp for all entries in one session |
| `file` | relative path (e.g., `reference/INDEX.md`) | Required; used for scope auto-routing |
| `status` | added, modified, removed | Required; machine-parseable |
| `type` | markdown, json, csv, powershell, typescript, config | Required; lower-case file extension |
| `change` | 1-line description | Required; clear action description |
| `impact` | ai-readiness, balance, documentation, navigation, refactor, bugfix, other | Required; consistent across sessions |
| `category` | reference, data, mods, scripts, guides, other | Required; generally matches top-level directory |
| `audience` | scripters, modders, testers, users, api-tools | Required; who this affects |
| `tags` | Array of lowercase strings | Required; use: navigation, metadata, structure, content, balance, ui, etc. |
| `notes` | Free-form string (optional) | Optional; additional context such as GitHub issues, related decisions, or cross-references |
| `notes` | Free-form string (optional) | Optional; additional context such as GitHub issues, related decisions, or cross-references |

**Validation:** Run `validate-entry.ps1` to catch schema errors before appending.

---

## Understanding Timestamps & Sessions

**Timestamp Semantics:**
- **What:** ISO 8601 UTC format: `2026-02-24T14:30:00Z`
- **When to use:** Timestamp of session start, not file creation time
- **Granularity:** Per-session (all entries in one prompt batch use same timestamp)
- **Purpose:** Allows grouping related changes as atomic unit; enables session-level aggregation

**Example:**
```jsonl
{"timestamp":"2026-02-24T14:30:00Z","file":"reference/INDEX.md","status":"added",...}
{"timestamp":"2026-02-24T14:30:00Z","file":"reference/master-index.md","status":"modified",...}
{"timestamp":"2026-02-24T15:45:00Z","file":"reference/.skill/schema.ts","status":"added",...}
```
→ Three entries: two from 14:30 session, one from 15:45 session (grouped by timestamp)

---

## Rotation & Archiving

- **Monthly rotation:** Create new `YYYY-MM.md` file each month
- **Override:** Keep scope INDEX.jsonl files singular; append continuously (never rotate)
- **Archive:** Move old month files to `archive/` folder when quarter closes
- **Long-term:** If INDEX.jsonl exceeds 10K lines, rotate: `archive/INDEX_2026-Q1.jsonl`

---

## Schema Consistency Rules (Reference)

Reminder of field constraints (validated by `validate-entry.ps1`):

| Field | Valid Values | Notes |
|-------|--------------|-------|
| `status` | added, modified, removed | Machine-parseable; required |
| `type` | markdown, json, csv, powershell, etc. | Lower-case file extension |
| `impact` | ai-readiness, balance, documentation, navigation, refactor, bugfix | Consistent across sessions |
| `category` | reference, data, scripts, guides, other | Matches top-level directory |
| `audience` | users, api-tools, game-engine | Who this affects |
| `tags` | Array of lowercase strings | Use: navigation, metadata, structure, content, etc. |

---

## Enforcement Reminder by Scope

| Scope | Directory Pattern | Enforcement |
|-------|-------------------|-------------|
| **mods/** | `mods/**` | Log all production changes; dev/experimental changes optional |
| **system/** | `changelog/**` (infrastructure only) | Log structural changes to README, scripts, templates |
| **workspace/** | `reference/`, `data/`, root scripts/configs | **Required:** All changes must be logged before commit |

**Use `validate-entry.ps1` to verify entries before appending. Use `generate-overview.ps1` and `generate-detailed-entries.ps1` to create human-readable changelogs.**

---

## Quick Reference

| Need | Use |
|------|-----|
| Human review of what changed | Read scope-specific `mods/2026-02.md`, `system/2026-02.md`, or `workspace/2026-02.md` |
| Quick monthly summary | Run `.\generate-overview.ps1 -Scope <scope>` then view table at top of `.md` file |
| Find all changes affecting FILE | `Get-Content <scope>\INDEX.jsonl \| jq 'select(.file=="FILE")'` |
| Export changes for release notes | Extract from overview table + details section in `.md` files |
| Query changes by impact (single scope) | `Get-Content workspace\INDEX.jsonl \| jq 'select(.impact=="IMPACT")'` |
| Query changes by impact (all scopes) | `Get-Content mods\INDEX.jsonl,system\INDEX.jsonl,workspace\INDEX.jsonl \| jq 'select(.impact=="IMPACT")'` |
| List all files changed in scope | `Get-Content workspace\INDEX.jsonl \| jq -r '.file' \| sort \| uniq` |
| Validate entry before appending | `.\validate-entry.ps1 -Entry '{...jsonl line...}'` (checks schema, types, required fields) |
| Migrate from old pre-scope structure | Run `.\migrate-to-scopes.ps1` (one-time migration from root `INDEX.jsonl`) |
| Rollback to pre-scope structure | `Copy-Item archive\pre-scope-split\INDEX.jsonl.backup .\INDEX.jsonl -Force` (restores original structure, 30-day window) |
| Which scope to use? | Check file path: `reference/*` or `data/*` → workspace; `mods/*` → mods; `changelog/*` → system |