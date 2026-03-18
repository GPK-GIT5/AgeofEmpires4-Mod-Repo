---
applyTo: "**/*.ps1"
---

# PowerShell Coding Standards — AoE4 Workspace

Target PowerShell 7+ (pwsh). Use tabs (size 4), not spaces. No build system — automation via `scripts/run_all_extraction.ps1`.

## Script Structure

```powershell
<#
.SYNOPSIS
    Brief description
.DESCRIPTION
    Detailed description
.PARAMETER ParamName
    Parameter description
.EXAMPLE
    .\script-name.ps1 -Param "value"
#>
param(
    [string]$WorkspaceRoot = "C:\Users\Jordan\Documents\AoE4-Workspace",
    [Parameter(Mandatory=$true)]
    [ValidateSet("mods", "system", "workspace")]
    [string]$Scope
)

$ErrorActionPreference = "Stop"
```

## Naming Conventions

| Element | Convention | Examples |
|---------|-----------|----------|
| Script files | kebab-case or snake_case | `validate-entry.ps1`, `extract_functions.ps1` |
| Functions | PascalCase | `Find-TableRange`, `Parse-BlueprintTable` |
| Variables | $camelCase or $PascalCase | `$scopePath`, `$indexFile` |

## Output Formatting

- `Write-Host -ForegroundColor`: Green=success, Yellow=warning, Cyan=info, Red=error
- Unicode symbols: `✓`=valid, `✗`=invalid, `ℹ`=info
- Phased labels: `[Phase 1a]`, `[Phase 2]` with `====` dividers
- `[System.Text.StringBuilder]` for large markdown generation

## Common Patterns

- **Collections**: `[System.Collections.ArrayList]::new()` with `[void]$list.Add(...)`
- **Regex**: `[regex]::Matches()` for multi-match, `-match` for single
- **Pipelines**: `Get-Content | ConvertFrom-Json | Group-Object | Sort-Object`
- **Dual output**: CSV + Markdown from same extraction
- **Paths**: `Join-Path $PSScriptRoot ...` for relative paths
- **Guards**: `Test-Path` before file ops, `try/catch` for JSON parsing

## Validation

- `$ErrorActionPreference = "Stop"` in every script
- `Test-Path` guards before file operations
- `try/catch` for JSON parsing
- CSV indexes regenerated via `scripts/run_all_extraction.ps1` — never hand-edit
- **Changelog workflow:** See `changelog/QUICKSTART.md`

## Self-Check

Before submitting PowerShell code, verify:
- [ ] `param()` block with comment-based help
- [ ] `$ErrorActionPreference = "Stop"` present
- [ ] Naming matches convention table above
- [ ] `Test-Path` guards on file operations
- [ ] No patterns not found in existing scripts
