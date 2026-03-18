<#
.SYNOPSIS
    Parses AoE4 scardocs .api files into structured JSON and cross-references
    with existing workspace API documentation.

.DESCRIPTION
    Phase 2 of scardocs integration:
    1. Parse Essence_ScarFunctions.api → parsed_functions.json
    2. Parse Essence_Constants.api → parsed_constants.json
    3. Cross-reference with references/api/scar-api-functions.md
    4. Output gap report

.EXAMPLE
    .\scripts\extract_scardocs.ps1
    .\scripts\extract_scardocs.ps1 -ReportOnly
#>
[CmdletBinding()]
param(
    [switch]$ReportOnly
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$scardocsDir  = Join-Path $PSScriptRoot '..\data\aoe4\scardocs'
$funcApiFile  = Join-Path $scardocsDir 'Essence_ScarFunctions.api'
$constApiFile = Join-Path $scardocsDir 'Essence_Constants.api'
$refApiFile   = Join-Path $PSScriptRoot '..\references\api\scar-api-functions.md'

# ── Parse Functions ──────────────────────────────────────────────────

function Parse-FunctionsApi {
    param([string]$Path)

    $lines = Get-Content $Path -Encoding UTF8
    $results = [System.Collections.Generic.List[PSObject]]::new()

    # Regex: FunctionName( params ) RETURNS:  =>description
    # Handles standard lines and the "0( Void FunctionName(...)" broken prefix
    $rxStandard = '^(?<name>[A-Za-z_]\w*)\(\s*(?<params>.*?)\s*\)\s*RETURNS:\s*=>\s*(?<desc>.+)$'
    $rxBrokenPrefix = '^0\(\s*Void\s+(?<name>[A-Za-z_]\w*)\((?<params>.*?)\s*\)\s*RETURNS:\s*=>\s*(?<desc>.+)$'

    foreach ($line in $lines) {
        $line = $line.Trim()
        if (-not $line -or $line.StartsWith('#')) { continue }
        if ($line.StartsWith('__declspec')) { continue }  # broken header lines without names

        $m = $null
        if ($line -match $rxStandard) {
            $m = $Matches
        }
        elseif ($line -match $rxBrokenPrefix) {
            $m = $Matches
        }

        if ($m) {
            $funcName = $m['name']
            $rawParams = $m['params'].Trim()
            $desc = $m['desc'].Trim()

            # Parse parameter list: "Type1 name1, Type2 name2, ..."
            $params = @()
            if ($rawParams -and $rawParams -ne 'Void') {
                foreach ($p in ($rawParams -split ',')) {
                    $p = $p.Trim()
                    if (-not $p) { continue }
                    # Match "TypeName paramName" or just "TypeName" (no param name)
                    if ($p -match '^(?<type>[A-Za-z_]\w*)(?:\s+(?<pname>\w+))?$') {
                        $params += [PSCustomObject]@{
                            type = $Matches['type']
                            name = if ($Matches['pname']) { $Matches['pname'] } else { $null }
                        }
                    }
                    else {
                        # Complex param (e.g., nested types) — store raw
                        $params += [PSCustomObject]@{ type = $p; name = $null }
                    }
                }
            }

            # Derive namespace from function name prefix
            $ns = if ($funcName -match '^([A-Za-z]+_)') { $Matches[1].TrimEnd('_') } else { 'Misc' }

            $results.Add([PSCustomObject]@{
                name        = $funcName
                namespace   = $ns
                params      = $params
                paramRaw    = $rawParams
                description = $desc
            })
        }
    }
    return $results
}

# ── Parse Constants ──────────────────────────────────────────────────

function Parse-ConstantsApi {
    param([string]$Path)

    $lines = Get-Content $Path -Encoding UTF8
    $results = [System.Collections.Generic.List[PSObject]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new()

    # Skip noise: type keywords, standalone short words, hex literals
    $skipPatterns = @('int32_t','static_cast','REFLECT_HIDDEN','ll','x0000','x0001','x0002','x0004')

    foreach ($line in $lines) {
        $line = $line.Trim()
        if (-not $line -or $line.StartsWith('#')) { continue }
        if ($line -in $skipPatterns) { continue }
        if ($line.Length -lt 2) { continue }

        # Deduplicate
        if (-not $seen.Add($line)) { continue }

        # Derive category prefix
        $category = 'Uncategorized'
        if ($line -match '^([A-Z][A-Za-z]+)_') {
            $category = $Matches[1]
        }
        elseif ($line -match '^([a-z][A-Za-z]+)_?[A-Z]') {
            $category = $Matches[1]
        }

        $results.Add([PSCustomObject]@{
            name     = $line
            category = $category
        })
    }
    return $results
}

# ── Extract workspace function names from scar-api-functions.md ──────

function Get-WorkspaceFunctionNames {
    param([string]$Path)

    $names = [System.Collections.Generic.HashSet[string]]::new()
    $content = Get-Content $Path -Encoding UTF8

    foreach ($line in $content) {
        # Match backtick-wrapped function names: `FunctionName` or `FunctionName()`
        $matches = [regex]::Matches($line, '`([A-Za-z_]\w*?)(?:\(\))?`')
        foreach ($m in $matches) {
            [void]$names.Add($m.Groups[1].Value)
        }
    }
    return $names
}

# ── Main ─────────────────────────────────────────────────────────────

Write-Host "`n=== Scardocs Extraction ===" -ForegroundColor Cyan

# Parse functions
Write-Host "`nParsing functions from: $funcApiFile"
$functions = Parse-FunctionsApi -Path $funcApiFile
Write-Host "  Parsed: $($functions.Count) functions"

$nsByCount = $functions | Group-Object namespace | Sort-Object Count -Descending
Write-Host "  Namespaces: $($nsByCount.Count)"
Write-Host "  Top 10:"
$nsByCount | Select-Object -First 10 | ForEach-Object {
    Write-Host "    $($_.Name): $($_.Count)"
}

# Parse constants
Write-Host "`nParsing constants from: $constApiFile"
$constants = Parse-ConstantsApi -Path $constApiFile
Write-Host "  Parsed: $($constants.Count) unique constants"

$catByCount = $constants | Group-Object category | Sort-Object Count -Descending
Write-Host "  Categories: $($catByCount.Count)"
Write-Host "  Top 15:"
$catByCount | Select-Object -First 15 | ForEach-Object {
    Write-Host "    $($_.Name): $($_.Count)"
}

# Cross-reference with workspace
Write-Host "`nCross-referencing with workspace: $refApiFile"
$workspaceNames = Get-WorkspaceFunctionNames -Path $refApiFile
Write-Host "  Workspace function names found: $($workspaceNames.Count)"

$scardocNames = [System.Collections.Generic.HashSet[string]]::new()
foreach ($f in $functions) { [void]$scardocNames.Add($f.name) }

$inBoth = $scardocNames.Where({ $workspaceNames.Contains($_) })
$scardocOnly = $scardocNames.Where({ -not $workspaceNames.Contains($_) })
$workspaceOnly = $workspaceNames.Where({ -not $scardocNames.Contains($_) })

Write-Host "`n--- Cross-Reference Results ---" -ForegroundColor Yellow
Write-Host "  In both (merge candidates): $($inBoth.Count)"
Write-Host "  Scardocs only (NEW engine functions): $($scardocOnly.Count)"
Write-Host "  Workspace only (gameplay helpers): $($workspaceOnly.Count)"

if ($scardocOnly.Count -gt 0) {
    Write-Host "`n  NEW engine functions not in workspace:" -ForegroundColor Red
    $scardocOnly | Sort-Object | Select-Object -First 30 | ForEach-Object {
        Write-Host "    + $_"
    }
    if ($scardocOnly.Count -gt 30) {
        Write-Host "    ... and $($scardocOnly.Count - 30) more"
    }
}

# Output JSON files
if (-not $ReportOnly) {
    $funcJson = $functions | ConvertTo-Json -Depth 4 -Compress:$false
    $funcOutPath = Join-Path $scardocsDir 'parsed_functions.json'
    Set-Content -Path $funcOutPath -Value $funcJson -Encoding UTF8
    Write-Host "`nWrote: $funcOutPath ($([math]::Round((Get-Item $funcOutPath).Length/1024,1)) KB)"

    $constGrouped = [ordered]@{}
    foreach ($grp in ($constants | Group-Object category | Sort-Object Name)) {
        $constGrouped[$grp.Name] = @($grp.Group | ForEach-Object { $_.name })
    }
    $constJson = $constGrouped | ConvertTo-Json -Depth 3 -Compress:$false
    $constOutPath = Join-Path $scardocsDir 'parsed_constants.json'
    Set-Content -Path $constOutPath -Value $constJson -Encoding UTF8
    Write-Host "Wrote: $constOutPath ($([math]::Round((Get-Item $constOutPath).Length/1024,1)) KB)"

    # Write scardoc-only functions list for enrichment
    $gapPath = Join-Path $scardocsDir 'gap_functions_scardoc_only.txt'
    $scardocOnly | Sort-Object | Set-Content -Path $gapPath -Encoding UTF8
    Write-Host "Wrote: $gapPath ($($scardocOnly.Count) functions)"

    # Write merge-candidate list (functions in both) with typed signatures
    $mergePath = Join-Path $scardocsDir 'merge_candidates.json'
    $mergeCandidates = $functions | Where-Object { $workspaceNames.Contains($_.name) }
    $mergeCandidates | ConvertTo-Json -Depth 4 -Compress:$false | Set-Content -Path $mergePath -Encoding UTF8
    Write-Host "Wrote: $mergePath ($($mergeCandidates.Count) functions with typed signatures)"
}

Write-Host "`n=== Done ===" -ForegroundColor Green
