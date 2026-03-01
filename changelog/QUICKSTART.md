# Quick Start — Adding Your First Changelog Entry

Add changes to the AoE4 workspace changelog in 5 minutes. This guide covers the essential workflow.

## 1. Identify Your Scope (1 minute)

Determine which category your change belongs to:

| File Path | Scope | Example: Changed `reference/commands-reference.md` |
|-----------|-------|------|
| `mods/*` | **mods** | Changes to mod files, templates |
| `changelog/*` (scripts, configs, JSON schemas) | **system** | Updated `validate-entry.ps1` script |
| Everything else: `reference/`, `data/`, `guides/`, root configs | **workspace** | ✅ Use **workspace** scope |

## 2. Create Your Entry (2 minutes)

A changelog entry is a single line of valid JSON. Create it using this template:

```json
{
  "timestamp": "2026-02-24T15:30:00Z",
  "file": "reference/commands-reference.md",
  "status": "added",
  "type": "markdown",
  "change": "Added 5 new game events (OnPlayerDefeat, OnGameEnd, OnResourceTransfer, OnUnitKilled, OnBuildingCompleted)",
  "impact": "documentation",
  "category": "reference",
  "audience": "scripters",
  "tags": ["api", "events", "scar"],
  "notes": "Resolves GitHub issue #42, enables event-driven mod logic"
}
```

**Field Quick Reference:**
- **timestamp**: `ISO 8601` format with Z suffix (e.g., `2026-02-24T15:30:00Z`). All changes in same prompt get same timestamp.
- **file**: Relative path from workspace root (e.g., `reference/commands-reference.md`)
- **status**: `added`, `modified`, or `removed`
- **type**: File type such as `markdown`, `json`, `typescript`, `powershell`, `config`
- **change**: What changed (1-2 sentences)
- **impact**: `critical`, `major`, `minor`, `bugfix`, `documentation`, `refactor`, `internal`, `other`
- **category**: Topic area (`reference`, `data`, `scripts`, `mods`, `guides`, `systems`)
- **audience**: Who cares (`scripters`, `modders`, `testers`, `users`, `api-tools`)
- **tags**: Array of searchable keywords
- **notes**: Optional additional context (GitHub issues, related tasks, etc.)

**Required vs Optional:** 9 fields are required; `notes` is optional.

## 3. Validate Before Appending (1 minute)

Always validate your entry before adding it to the log:

```powershell
cd changelog
# Copy your entry object (the entire JSON) and run:
.\validate-entry.ps1 -Entry '{"timestamp":"2026-02-24T15:30:00Z","file":"reference/commands-reference.md",...}'
```

**Expected output if valid:**
```
✓ Valid entry - ready to append to INDEX.jsonl
```

**If invalid,** you'll see a clear error message showing which field failed. Fix it and try again.

## 4. Append to Scope Log (1 minute)

Once validated, append to the appropriate scope's `INDEX.jsonl`:

```powershell
# Append to workspace scope (most common)
Add-Content changelog\workspace\INDEX.jsonl '{"timestamp":"2026-02-24T15:30:00Z","file":"reference/commands-reference.md",...}'

# Or mods scope:
Add-Content changelog\mods\INDEX.jsonl '{"timestamp":"2026-02-24T15:30:00Z",...}'

# Or system scope:
Add-Content changelog\system\INDEX.jsonl '{"timestamp":"2026-02-24T15:30:00Z",...}'
```

**Tip:** Copy the validated entry string exactly (including outer braces), then paste it in the `Add-Content` command.

## 5. Auto-Generate Summary (Optional, 1 minute)

After adding entries, generate an updated overview table:

```powershell
cd changelog
.\generate-overview.ps1 -Scope workspace
```

This creates a summary table in `workspace/2026-02.md` showing all changes grouped by date.

## Next Steps

- **View all entries for a file:** `Get-Content workspace\INDEX.jsonl | jq 'select(.file=="reference/commands-reference.md")'`
- **Export for release notes:** Copy the table from `workspace/2026-02.md`
- **Query by impact:** `Get-Content workspace\INDEX.jsonl | jq 'select(.impact=="critical")'`
- **See all options:** Check [README.md — Quick Reference](README.md#quick-reference)

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Validation fails with "timestamp" error | Ensure format is `YYYY-MM-DDTHH:MM:SSZ` with Z suffix |
| Validation fails with missing field | Every entry needs all 10 fields (`timestamp`, `file`, `status`, `type`, `change`, `impact`, `category`, `audience`, `tags`, `notes`) |
| Path errors when running scripts | Make sure you're in the `changelog/` directory before running `.ps1` scripts |
| Can't find my change in overview | Verify you used the correct scope (`mods/`, `system/`, or `workspace/`) |

---

**Questions?** See [README.md — Scope Definitions](README.md#scope-definitions) or [README.md — Schema Consistency Rules](README.md#schema-consistency-rules).
