<#
.SYNOPSIS
    Extracts all function signatures from AoE4 .scar (Lua) files into CSV and markdown indexes.
.DESCRIPTION
    Scans all .scar files in campaign and gameplay directories, extracts function names/params/line numbers,
    and outputs both a CSV (machine-searchable) and a markdown table (human-readable).
#>

param(
    [string]$WorkspaceRoot = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$roots = @(
    @{ Path = "$WorkspaceRoot\reference\dumps\scar campaign"; Category = "campaign" },
    @{ Path = "$WorkspaceRoot\reference\dumps\scar gameplay"; Category = "gameplay" }
)

$outputCsv = "$WorkspaceRoot\reference\function-index.csv"
$outputMd  = "$WorkspaceRoot\reference\function-index.md"

$results = [System.Collections.ArrayList]::new()

foreach ($root in $roots) {
    $basePath = $root.Path
    $category = $root.Category
    
    Get-ChildItem $basePath -Recurse -Filter "*.scar" | ForEach-Object {
        $file = $_
        $relPath = $file.FullName.Replace($basePath + "\", "")
        $lines = Get-Content $file.FullName -ErrorAction SilentlyContinue
        
        if ($null -eq $lines) { return }
        
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\s*function\s+([A-Za-z_][\w.:]*)\s*\(([^)]*)\)') {
                $funcName = $Matches[1]
                $params = $Matches[2].Trim()
                
                # Determine visibility: underscore prefix = private
                $visibility = if ($funcName -match '^_') { "private" } else { "public" }
                
                # Determine role from filename suffix
                $role = "core"
                if ($file.BaseName -match '_([^_]+)$') {
                    $role = $Matches[1]
                }
                
                [void]$results.Add([PSCustomObject]@{
                    Category   = $category
                    File       = $relPath
                    FileName   = $file.Name
                    Function   = $funcName
                    Params     = $params
                    Line       = $i + 1
                    Visibility = $visibility
                    FileRole   = $role
                })
            }
        }
    }
}

# Sort by category then file then line
$sorted = $results | Sort-Object Category, File, Line

# Export CSV
$sorted | Export-Csv $outputCsv -NoTypeInformation -Encoding UTF8
Write-Host "CSV exported: $outputCsv ($($sorted.Count) functions)"

# Export Markdown
$md = [System.Text.StringBuilder]::new()
[void]$md.AppendLine("# AoE4 SCAR Function Index")
[void]$md.AppendLine("")
[void]$md.AppendLine("Auto-generated on $(Get-Date -Format 'yyyy-MM-dd HH:mm'). Total functions: **$($sorted.Count)**")
[void]$md.AppendLine("")

# Stats
$byCat = $sorted | Group-Object Category
foreach ($g in $byCat) {
    [void]$md.AppendLine("- **$($g.Name)**: $($g.Count) functions across $(($g.Group | Select-Object -Unique File).Count) files")
}
[void]$md.AppendLine("")

# Group by category, then file
foreach ($cat in ($sorted | Group-Object Category | Sort-Object Name)) {
    [void]$md.AppendLine("## $($cat.Name)")
    [void]$md.AppendLine("")
    
    foreach ($fileGroup in ($cat.Group | Group-Object File | Sort-Object Name)) {
        [void]$md.AppendLine("### $($fileGroup.Name)")
        [void]$md.AppendLine("")
        [void]$md.AppendLine("| Line | Function | Params | Visibility |")
        [void]$md.AppendLine("|------|----------|--------|------------|")
        
        foreach ($func in $fileGroup.Group) {
            $paramDisplay = if ($func.Params -eq "") { "—" } else { "``$($func.Params)``" }
            [void]$md.AppendLine("| $($func.Line) | ``$($func.Function)`` | $paramDisplay | $($func.Visibility) |")
        }
        [void]$md.AppendLine("")
    }
}

$md.ToString() | Set-Content $outputMd -Encoding UTF8
Write-Host "Markdown exported: $outputMd"
Write-Host "Done. $($sorted.Count) functions extracted."
