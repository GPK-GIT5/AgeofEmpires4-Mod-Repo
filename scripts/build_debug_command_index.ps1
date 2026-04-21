<#
.SYNOPSIS
  Builds a structured index of all Debug_* console commands in Onslaught.

.DESCRIPTION
  Scans debug/*.scar for function Debug_*() definitions.
  Extracts: function name, parameters, file, line, category (from filename),
  and leading comment (description). Outputs CSV + markdown reference.

.PARAMETER Root
  Workspace root. Default: C:\Users\Jordan\Documents\AoE4-Workspace
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$ErrorActionPreference = 'Stop'
$debugDir  = Join-Path $Root "Gamemodes\Onslaught\assets\scar\debug"
$indexDir  = Join-Path $Root "references\indexes"
$modsDir   = Join-Path $Root "references\mods"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Onslaught Debug Command Inventory" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

$debugFiles = Get-ChildItem $debugDir -Filter "*.scar" -File | Sort-Object Name
$funcRx = [regex]::new('^function\s+(Debug_\w+|debug_\w+)\s*\(([^)]*)\)', 'Compiled')

$entries = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($file in $debugFiles) {
    $relPath = $file.Name
    # Derive category from filename: cba_debug_leaver.scar -> leaver
    $category = $relPath -replace '^cba_debug_?', '' -replace '\.scar$', ''
    if (-not $category -or $category -eq 'cba_debug') { $category = "core" }

    $lines = [System.IO.File]::ReadAllLines($file.FullName)
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $m = $funcRx.Match($lines[$i])
        if (-not $m.Success) { continue }

        $funcName = $m.Groups[1].Value
        $params = $m.Groups[2].Value.Trim()

        # Scrape leading comment (up to 5 lines above)
        $desc = ""
        for ($k = $i - 1; $k -ge [math]::Max(0, $i - 5); $k--) {
            $cl = $lines[$k].Trim()
            if ($cl -match '^--\s*(.+)') {
                $commentText = $Matches[1].Trim()
                if ($commentText -notmatch '^[-=]+$') {
                    $desc = if ($desc) { "$commentText $desc" } else { $commentText }
                }
            } else {
                break
            }
        }

        $entries.Add([PSCustomObject]@{
            Function    = $funcName
            Params      = $params
            Category    = $category
            File        = $relPath
            Line        = $i + 1
            Description = $desc
        })
    }
}

Write-Host "  Debug commands found: $($entries.Count)" -ForegroundColor Green
$catCounts = $entries | Group-Object Category | Sort-Object Count -Descending
foreach ($c in $catCounts) {
    Write-Host "    $($c.Name): $($c.Count)" -ForegroundColor Gray
}

# =====================================================================
# OUTPUT CSV
# =====================================================================
$csvPath = Join-Path $indexDir "onslaught-debug-commands.csv"
$csv = [System.Collections.Generic.List[string]]::new()
$csv.Add('"Function","Params","Category","File","Line","Description"')
foreach ($e in ($entries | Sort-Object Category, Function)) {
    $safeDesc = $e.Description -replace '"','""'
    $csv.Add("`"$($e.Function)`",`"$($e.Params)`",`"$($e.Category)`",`"$($e.File)`",`"$($e.Line)`",`"$safeDesc`"")
}
[System.IO.File]::WriteAllLines($csvPath, $csv)
Write-Host "  -> $csvPath ($($entries.Count) rows)" -ForegroundColor Gray

# =====================================================================
# OUTPUT MARKDOWN
# =====================================================================
$mdPath = Join-Path $modsDir "onslaught-debug-commands.md"
$md = [System.Text.StringBuilder]::new()
[void]$md.AppendLine("# Onslaught Debug Command Inventory")
[void]$md.AppendLine()
[void]$md.AppendLine("Auto-generated on $timestamp. All `Debug_*` console commands available in the Onslaught mod.")
[void]$md.AppendLine()
[void]$md.AppendLine("- **$($entries.Count)** debug commands across **$($catCounts.Count)** categories")
[void]$md.AppendLine("- **$($debugFiles.Count)** debug source files")
[void]$md.AppendLine()

[void]$md.AppendLine("## Category Summary")
[void]$md.AppendLine()
[void]$md.AppendLine("| Category | Commands | Source File |")
[void]$md.AppendLine("|----------|----------|-------------|")
foreach ($c in $catCounts) {
    $sampleFile = ($entries | Where-Object { $_.Category -eq $c.Name } | Select-Object -First 1).File
    [void]$md.AppendLine("| $($c.Name) | $($c.Count) | $sampleFile |")
}
[void]$md.AppendLine()

# Per-category command listing
foreach ($c in $catCounts) {
    [void]$md.AppendLine("## $($c.Name)")
    [void]$md.AppendLine()
    [void]$md.AppendLine("| Command | Parameters | Description |")
    [void]$md.AppendLine("|---------|------------|-------------|")
    foreach ($e in ($entries | Where-Object { $_.Category -eq $c.Name } | Sort-Object Function)) {
        $paramDisplay = if ($e.Params) { "``$($e.Params)``" } else { "—" }
        $descDisplay = if ($e.Description) { $e.Description } else { "—" }
        [void]$md.AppendLine("| ``$($e.Function)`` | $paramDisplay | $descDisplay |")
    }
    [void]$md.AppendLine()
}

[System.IO.File]::WriteAllText($mdPath, $md.ToString())
Write-Host "  -> $mdPath" -ForegroundColor Gray

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " Debug Command Inventory Complete" -ForegroundColor Cyan
Write-Host "  Commands: $($entries.Count) | Categories: $($catCounts.Count) | Files: $($debugFiles.Count)" -ForegroundColor White
Write-Host "================================================================" -ForegroundColor Cyan
