# Changelog System

Automated, scope-separated change tracking with dual-format output (JSONL + Markdown).

## Directory Structure

```
changelog/
├── README.md                          ← You are here
├── docs/
│   ├── QUICKSTART.md                  ← Onboarding guide (manual workflow)
│   ├── USAGE.md                       ← Quick reference card
│   └── entry-template.jsonl           ← JSONL entry template
├── scripts/
│   ├── auto-changelog.ps1             ← Core automation (runs on VS Code open)
│   ├── generate-overview.ps1          ← Dashboard + overview table generator
│   ├── generate-detailed-entries.ps1  ← Detailed markdown prose generator
│   └── validate-entry.ps1            ← JSONL schema validator
├── output/
│   ├── mods/                          ← Scenarios/ + Gamemodes/ changes
│   │   └── YYYY-MM/                   ← Monthly directory
│   │       ├── YYYY-MM-DD.jsonl       ← Daily log (one per automation run)
│   │       └── INDEX.md               ← Monthly overview + detailed entries
│   ├── system/                        ← changelog/ infrastructure changes
│   │   └── YYYY-MM/
│   │       ├── YYYY-MM-DD.jsonl
│   │       └── INDEX.md
│   └── workspace/                     ← Everything else (references, data, scripts)
│       └── YYYY-MM/
│           ├── YYYY-MM-DD.jsonl
│           └── INDEX.md
├── archive/                           ← Historical scripts + pre-migration backups
└── .last-auto-run                     ← State file (gitignored)
```

## How It Works

### Automatic Mode (Default)

On every VS Code startup, `.vscode/tasks.json` triggers `scripts/auto-changelog.ps1`:

1. **Gate check** — Skips if last run was < 24 hours ago
2. **Git scan** — Collects committed + uncommitted changes since last run
3. **Dedup** — Filters out files already present in daily .jsonl logs
4. **Heuristics** — Infers type, impact, category, audience, and tags from file paths
5. **Validate** — Each entry passes through `validate-entry.ps1`
6. **Append** — Valid entries go to the correct scope's daily file (`output/{scope}/{YYYY-MM}/{YYYY-MM-DD}.jsonl`)
7. **Generate** — Runs overview + detailed generators → `output/{scope}/{YYYY-MM}/INDEX.md`
8. **Stamp** — Updates `.last-auto-run` timestamp

**Override options:**
```powershell
cd changelog
.\scripts\auto-changelog.ps1 -Force        # Bypass 24h gate
.\scripts\auto-changelog.ps1 -DryRun       # Preview without writing
.\scripts\auto-changelog.ps1 -Hours 12     # Custom threshold
```

### Manual Mode

For hand-crafted entries with richer descriptions:

```powershell
cd changelog

# 1. Validate
.\scripts\validate-entry.ps1 -Entry '{"timestamp":"2026-03-18T12:00:00Z","file":"reference/INDEX.md","status":"modified","type":"markdown","change":"Reorganized navigation hub","impact":"documentation","category":"reference","audience":"api-tools","tags":["navigation"]}'

# 2. Append to correct scope's daily file
Add-Content output\workspace\2026-03\2026-03-18.jsonl '<validated entry>'

# 3. Generate markdown
.\scripts\generate-overview.ps1 -Scope workspace -Month 2026-03
.\scripts\generate-detailed-entries.ps1 -Scope workspace -Month 2026-03
```

## Scope Routing

| File Path | Scope | Daily Log |
|-----------|-------|-----------|
| `Scenarios/**`, `Gamemodes/**` | **mods** | `output/mods/{YYYY-MM}/{YYYY-MM-DD}.jsonl` |
| `changelog/**` | **system** | `output/system/{YYYY-MM}/{YYYY-MM-DD}.jsonl` |
| Everything else | **workspace** | `output/workspace/{YYYY-MM}/{YYYY-MM-DD}.jsonl` |

## JSONL Schema

| Field | Type | Required | Values |
|-------|------|----------|--------|
| `timestamp` | string | Yes | ISO 8601 UTC (`2026-03-18T12:00:00Z`) |
| `file` | string | Yes | Relative path from workspace root |
| `status` | enum | Yes | `added`, `modified`, `removed` |
| `type` | enum | Yes | `markdown`, `json`, `csv`, `powershell`, `typescript`, `config`, `scar` |
| `change` | string | Yes | 1-line description |
| `impact` | enum | Yes | `critical`, `major`, `minor`, `bugfix`, `documentation`, `refactor`, `internal`, `other` |
| `category` | enum | Yes | `reference`, `data`, `mods`, `scripts`, `guides`, `systems`, `other` |
| `audience` | enum | Yes | `scripters`, `modders`, `testers`, `users`, `api-tools` |
| `tags` | array | Yes | Lowercase string tags |
| `notes` | string | No | Additional context |

## Querying

```powershell
# All entries for a specific file (current month)
Get-Content output\workspace\2026-03\*.jsonl | ConvertFrom-Json | Where-Object { $_.file -eq "reference/INDEX.md" }

# All critical changes across scopes and months
Get-ChildItem output -Recurse -Filter "*.jsonl" | Get-Content | ConvertFrom-Json | Where-Object { $_.impact -eq "critical" }

# Count entries per scope (all months)
foreach ($s in @("mods","system","workspace")) {
    $count = (Get-ChildItem output\$s -Recurse -Filter "*.jsonl" | Get-Content | Measure-Object -Line).Lines
    "$s : $count entries"
}
```

## Rotation

- **Daily**: Each automation run creates `{YYYY-MM-DD}.jsonl` in the appropriate month directory
- **Monthly**: `INDEX.md` per scope per month (auto-regenerated by generators)
- **Archive**: Move old month directories when quarter closes
