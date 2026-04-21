<#
.SYNOPSIS
  Extracts function definitions, global variables, and imports from all
  Onslaught .scar files. Produces Markdown + CSV indexes matching the
  existing function-index format in references/indexes/.

.DESCRIPTION
  Scans Gamemodes/Onslaught/assets/scar/ recursively for all .scar files.
  Extracts:
    - Function definitions: line, name, params, visibility (public/_private)
    - Top-level global variable assignments
    - import() statements
  Outputs:
    - references/indexes/onslaught-function-index.md
    - references/indexes/onslaught-function-index.csv
    - references/indexes/onslaught-globals-index.csv
    - references/indexes/onslaught-imports-index.csv

.PARAMETER Root
  Workspace root. Default: C:\Users\Jordan\Documents\AoE4-Workspace
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$ErrorActionPreference = 'Stop'
$scarRoot   = Join-Path $Root "Gamemodes\Onslaught\assets\scar"
$indexDir   = Join-Path $Root "references\indexes"
$timestamp  = Get-Date -Format "yyyy-MM-dd HH:mm"

if (-not (Test-Path $scarRoot)) {
    Write-Error "Onslaught scar root not found: $scarRoot"
    return
}

# =====================================================================
# COLLECT ALL .scar FILES
# =====================================================================
$allFiles = Get-ChildItem -Path $scarRoot -Recurse -Filter "*.scar" | Sort-Object FullName
Write-Host "Found $($allFiles.Count) .scar files under $scarRoot" -ForegroundColor Cyan

# =====================================================================
# SUBSYSTEM CLASSIFICATION
# =====================================================================
function Get-Subsystem {
    param([string]$RelPath)
    $parts = $RelPath -split '[/\\]'
    if ($parts.Count -ge 2) {
        return $parts[0].ToLower()
    }
    return "root"
}

function Get-FileRole {
    param([string]$FileName)
    $fn = $FileName.ToLower()
    if ($fn -match '_data\.scar$|_constants\.scar$|_config\.scar$') { return "data" }
    if ($fn -match '_debug|^debug') { return "debug" }
    if ($fn -match '_test|_stress|_coverage|_validation') { return "test" }
    if ($fn -match '_ui\.scar$|_hud\.scar$|_animate') { return "ui" }
    if ($fn -match '_xaml') { return "xaml" }
    if ($fn -match 'reward') { return "rewards" }
    if ($fn -match 'condition|wincondition') { return "conditions" }
    if ($fn -match 'option') { return "options" }
    if ($fn -match 'objective') { return "objectives" }
    if ($fn -match 'helper|blueprint|team|start') { return "helpers" }
    if ($fn -match 'special') { return "specials" }
    return "core"
}

# =====================================================================
# PARSE EACH FILE
# =====================================================================
$functions = [System.Collections.Generic.List[PSCustomObject]]::new()
$globals   = [System.Collections.Generic.List[PSCustomObject]]::new()
$imports   = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($file in $allFiles) {
    $relPath  = $file.FullName.Substring($scarRoot.Length + 1).Replace('\', '/')
    $subsys   = Get-Subsystem $relPath
    $fileRole = Get-FileRole $file.Name
    $lines    = [System.IO.File]::ReadAllLines($file.FullName)
    $insideFunction = $false
    $braceDepth = 0

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $lineNum = $i + 1

        # ---- FUNCTION DEFINITIONS ----
        # Match: function FuncName(params)  or  local function FuncName(params)
        if ($line -match '^\s*(local\s+)?function\s+([A-Za-z_][A-Za-z0-9_.:]*)\s*\(([^)]*)\)') {
            $isLocal   = $null -ne $Matches[1]
            $funcName  = $Matches[2]
            $params    = $Matches[3].Trim()
            # Visibility: local = file-scoped; leading _ = private convention; else public
            $visibility = if ($isLocal) { "local" } elseif ($funcName -match '^_') { "private" } else { "public" }

            $functions.Add([PSCustomObject]@{
                Subsystem  = $subsys
                File       = $relPath
                FileName   = $file.Name
                Function   = $funcName
                Params     = $params
                Line       = $lineNum
                Visibility = $visibility
                FileRole   = $fileRole
            })
        }

        # Also match: SomeName = function(params)  (anonymous function assigned to variable)
        if ($line -match '^\s*(local\s+)?([A-Za-z_][A-Za-z0-9_.]*)\s*=\s*function\s*\(([^)]*)\)') {
            $isLocal   = $null -ne $Matches[1]
            $varName   = $Matches[2]
            $params    = $Matches[3].Trim()
            # Skip table field assignments like { OnComplete = function() }
            if ($line -match '^\s*[A-Za-z_]' -and $line -notmatch '^\s*\{' -and $varName -notmatch '^\s') {
                $visibility = if ($isLocal) { "local" } elseif ($varName -match '^_') { "private" } else { "public" }
                $functions.Add([PSCustomObject]@{
                    Subsystem  = $subsys
                    File       = $relPath
                    FileName   = $file.Name
                    Function   = $varName
                    Params     = $params
                    Line       = $lineNum
                    Visibility = $visibility
                    FileRole   = $fileRole
                })
            }
        }

        # ---- IMPORT STATEMENTS ----
        if ($line -match 'import\s*\(\s*["\x27]([^"'']+)["\x27]\s*\)') {
            $imports.Add([PSCustomObject]@{
                Subsystem = $subsys
                File      = $relPath
                Import    = $Matches[1]
                Line      = $lineNum
            })
        }

        # ---- GLOBAL VARIABLE ASSIGNMENTS ----
        # Only top-level (no leading whitespace) non-local assignments
        # Pattern: VARNAME = value  (but not inside a function body)
        # We approximate "top-level" by: line starts at column 0, no leading whitespace
        if ($line -match '^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+)$') {
            $varName = $Matches[1]
            $value   = $Matches[2].Trim()
            # Skip function definitions (already handled above)
            if ($value -notmatch '^function\s*\(') {
                # Skip common false positives (loop vars, etc.)
                if ($varName -ne 'i' -and $varName -ne 'j' -and $varName -ne 'k' -and $varName -ne 'v' -and $varName -ne '_') {
                    $globals.Add([PSCustomObject]@{
                        Subsystem = $subsys
                        File      = $relPath
                        Variable  = $varName
                        Line      = $lineNum
                        Value     = if ($value.Length -gt 120) { $value.Substring(0, 120) + "..." } else { $value }
                    })
                }
            }
        }
    }
}

Write-Host "Extracted: $($functions.Count) functions, $($globals.Count) globals, $($imports.Count) imports" -ForegroundColor Green

# =====================================================================
# OUTPUT: FUNCTION INDEX CSV
# =====================================================================
$csvFuncPath = Join-Path $indexDir "onslaught-function-index.csv"
$csvHeader = '"Subsystem","File","FileName","Function","Params","Line","Visibility","FileRole"'
$csvLines = [System.Collections.Generic.List[string]]::new()
$csvLines.Add($csvHeader)
foreach ($f in $functions) {
    $escapedParams = $f.Params -replace '"', '""'
    $escapedFunc   = $f.Function -replace '"', '""'
    $csvLines.Add("`"$($f.Subsystem)`",`"$($f.File)`",`"$($f.FileName)`",`"$escapedFunc`",`"$escapedParams`",`"$($f.Line)`",`"$($f.Visibility)`",`"$($f.FileRole)`"")
}
[System.IO.File]::WriteAllLines($csvFuncPath, $csvLines)
Write-Host "  -> $csvFuncPath ($($functions.Count) rows)" -ForegroundColor Gray

# =====================================================================
# OUTPUT: GLOBALS INDEX CSV
# =====================================================================
$csvGlobPath = Join-Path $indexDir "onslaught-globals-index.csv"
$csvGlobHeader = '"Subsystem","File","Variable","Line","Value"'
$csvGlobLines = [System.Collections.Generic.List[string]]::new()
$csvGlobLines.Add($csvGlobHeader)
foreach ($g in $globals) {
    $escapedVal = $g.Value -replace '"', '""'
    $csvGlobLines.Add("`"$($g.Subsystem)`",`"$($g.File)`",`"$($g.Variable)`",`"$($g.Line)`",`"$escapedVal`"")
}
[System.IO.File]::WriteAllLines($csvGlobPath, $csvGlobLines)
Write-Host "  -> $csvGlobPath ($($globals.Count) rows)" -ForegroundColor Gray

# =====================================================================
# OUTPUT: IMPORTS INDEX CSV
# =====================================================================
$csvImpPath = Join-Path $indexDir "onslaught-imports-index.csv"
$csvImpHeader = '"Subsystem","File","Import","Line"'
$csvImpLines = [System.Collections.Generic.List[string]]::new()
$csvImpLines.Add($csvImpHeader)
foreach ($imp in $imports) {
    $csvImpLines.Add("`"$($imp.Subsystem)`",`"$($imp.File)`",`"$($imp.Import)`",`"$($imp.Line)`"")
}
[System.IO.File]::WriteAllLines($csvImpPath, $csvImpLines)
Write-Host "  -> $csvImpPath ($($imports.Count) rows)" -ForegroundColor Gray

# =====================================================================
# OUTPUT: FUNCTION INDEX MARKDOWN
# =====================================================================
$mdPath = Join-Path $indexDir "onslaught-function-index.md"
$md = [System.Text.StringBuilder]::new()
[void]$md.AppendLine("# Onslaught Function Index")
[void]$md.AppendLine()
[void]$md.AppendLine("Auto-generated on $timestamp. Total functions: **$($functions.Count)**")
[void]$md.AppendLine()

# Summary by subsystem
$bySubsys = $functions | Group-Object Subsystem | Sort-Object Name
foreach ($group in $bySubsys) {
    $fileCount = ($group.Group | Select-Object -Property File -Unique).Count
    [void]$md.AppendLine("- **$($group.Name)**: $($group.Count) functions across $fileCount files")
}
[void]$md.AppendLine()

# Visibility summary
$pubCount   = ($functions | Where-Object { $_.Visibility -eq 'public' }).Count
$privCount  = ($functions | Where-Object { $_.Visibility -eq 'private' }).Count
$localCount = ($functions | Where-Object { $_.Visibility -eq 'local' }).Count
[void]$md.AppendLine("Visibility: **$pubCount** public, **$privCount** private (`_` prefix), **$localCount** local")
[void]$md.AppendLine()

# Per-subsystem → per-file tables
foreach ($subGroup in $bySubsys) {
    [void]$md.AppendLine("## $($subGroup.Name)")
    [void]$md.AppendLine()

    $byFile = $subGroup.Group | Group-Object File | Sort-Object Name
    foreach ($fileGroup in $byFile) {
        [void]$md.AppendLine("### $($fileGroup.Name)")
        [void]$md.AppendLine()
        [void]$md.AppendLine("| Line | Function | Params | Visibility |")
        [void]$md.AppendLine("|------|----------|--------|------------|")
        foreach ($fn in ($fileGroup.Group | Sort-Object Line)) {
            $paramDisplay = if ($fn.Params) { $fn.Params } else { [char]0x2014 }  # em dash
            [void]$md.AppendLine("| $($fn.Line) | ``$($fn.Function)`` | $paramDisplay | $($fn.Visibility) |")
        }
        [void]$md.AppendLine()
    }
}

[System.IO.File]::WriteAllText($mdPath, $md.ToString())
Write-Host "  -> $mdPath" -ForegroundColor Gray

# =====================================================================
# OUTPUT: GLOBALS SUMMARY MARKDOWN (appended to function index)
# =====================================================================
$mdGlobPath = Join-Path $indexDir "onslaught-globals-index.md"
$mdGlob = [System.Text.StringBuilder]::new()
[void]$mdGlob.AppendLine("# Onslaught Globals Index")
[void]$mdGlob.AppendLine()
[void]$mdGlob.AppendLine("Auto-generated on $timestamp. Total top-level assignments: **$($globals.Count)**")
[void]$mdGlob.AppendLine()

$globBySubsys = $globals | Group-Object Subsystem | Sort-Object Name
foreach ($group in $globBySubsys) {
    [void]$mdGlob.AppendLine("- **$($group.Name)**: $($group.Count) globals")
}
[void]$mdGlob.AppendLine()

foreach ($subGroup in $globBySubsys) {
    [void]$mdGlob.AppendLine("## $($subGroup.Name)")
    [void]$mdGlob.AppendLine()
    $byFile = $subGroup.Group | Group-Object File | Sort-Object Name
    foreach ($fileGroup in $byFile) {
        [void]$mdGlob.AppendLine("### $($fileGroup.Name)")
        [void]$mdGlob.AppendLine()
        [void]$mdGlob.AppendLine("| Line | Variable | Value (truncated) |")
        [void]$mdGlob.AppendLine("|------|----------|--------------------|")
        foreach ($g in ($fileGroup.Group | Sort-Object Line)) {
            $valDisplay = $g.Value -replace '\|', '\|'
            [void]$mdGlob.AppendLine("| $($g.Line) | ``$($g.Variable)`` | ``$valDisplay`` |")
        }
        [void]$mdGlob.AppendLine()
    }
}

[System.IO.File]::WriteAllText($mdGlobPath, $mdGlob.ToString())
Write-Host "  -> $mdGlobPath" -ForegroundColor Gray

# =====================================================================
# SUMMARY
# =====================================================================
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Onslaught Index Generation Complete" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Functions: $($functions.Count) ($pubCount public, $privCount private, $localCount local)"
Write-Host "  Globals:   $($globals.Count)"
Write-Host "  Imports:   $($imports.Count)"
Write-Host "  Files:     $($allFiles.Count) .scar files"
Write-Host "  Subsystems: $($bySubsys.Count) ($($bySubsys.Name -join ', '))"
Write-Host "================================================================" -ForegroundColor Cyan
