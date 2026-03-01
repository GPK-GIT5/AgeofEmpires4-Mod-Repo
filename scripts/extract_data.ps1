<#
.SYNOPSIS
    Extracts imports, objectives, SGroup/EGroup declarations, and global variables from AoE4 .scar files.
.DESCRIPTION
    Produces four reference files:
    - imports-index.csv: All import() statements (dependency graph)
    - objectives-index.csv: All OBJ_/SOBJ_ objective constants
    - groups-index.csv: All SGroup/EGroup creation calls
    - globals-index.csv: Key global variable assignments
#>

param(
    [string]$WorkspaceRoot = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$roots = @(
    @{ Path = "$WorkspaceRoot\reference\dumps\scar campaign"; Category = "campaign" },
    @{ Path = "$WorkspaceRoot\reference\dumps\scar gameplay"; Category = "gameplay" }
)

$outDir = "$WorkspaceRoot\reference"

$imports    = [System.Collections.ArrayList]::new()
$objectives = [System.Collections.ArrayList]::new()
$groups     = [System.Collections.ArrayList]::new()
$globals    = [System.Collections.ArrayList]::new()

# Track unique objectives to avoid massive duplicates
$seenObjectives = @{}

foreach ($root in $roots) {
    $basePath = $root.Path
    $category = $root.Category
    
    Get-ChildItem $basePath -Recurse -Filter "*.scar" | ForEach-Object {
        $file = $_
        $relPath = $file.FullName.Replace($basePath + "\", "")
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($null -eq $content) { return }
        $lines = $content -split "`n"
        $funcDepth = 0
        
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            $lineNum = $i + 1
            
            # IMPORTS: import("something.scar")
            if ($line -match 'import\(\s*"([^"]+)"\s*\)') {
                [void]$imports.Add([PSCustomObject]@{
                    Category = $category
                    File     = $relPath
                    Import   = $Matches[1]
                    Line     = $lineNum
                })
            }
            
            # OBJECTIVES: OBJ_ or SOBJ_ constants (capture assignment and usage)
            $objMatches = [regex]::Matches($line, '\b(S?OBJ_[A-Za-z0-9_]+)\b')
            foreach ($m in $objMatches) {
                $objName = $m.Value
                $key = "$category|$relPath|$objName"
                if (-not $seenObjectives.ContainsKey($key)) {
                    $seenObjectives[$key] = $true
                    
                    # Determine if this is a definition (assignment) or usage
                    $context = "usage"
                    if ($line -match "^\s*$([regex]::Escape($objName))\s*=") {
                        $context = "definition"
                    }
                    
                    [void]$objectives.Add([PSCustomObject]@{
                        Category  = $category
                        File      = $relPath
                        Objective = $objName
                        Context   = $context
                        Line      = $lineNum
                    })
                }
            }
            
            # SGROUP/EGROUP CREATION
            if ($line -match '(SGroup_CreateIfNotFound|EGroup_CreateIfNotFound)\(\s*"([^"]+)"\s*\)') {
                $groupType = if ($Matches[1] -match "SGroup") { "SGroup" } else { "EGroup" }
                [void]$groups.Add([PSCustomObject]@{
                    Category  = $category
                    File      = $relPath
                    GroupType = $groupType
                    GroupName = $Matches[2]
                    Line      = $lineNum
                })
            }
            
            # Track function depth for global scope detection
            if ($line -match '^\s*function\s+') { $funcDepth++ }
            if ($line -match '^\s*end\s*$' -or $line -match '^\s*end\s*--') { 
                if ($funcDepth -gt 0) { $funcDepth-- }
            }
            
            # GLOBAL VARIABLES: only at file scope (funcDepth == 0)
            if ($funcDepth -eq 0 -and $line -match '^\s*(g_\w+|[A-Z][A-Z_0-9]{2,})\s*=' -and $line -notmatch '^\s*--' -and $line -notmatch '^\s*local\b') {
                $varName = $Matches[1]
                # Skip common enum/constant prefixes that are engine-level
                if ($varName -notmatch '^(FILTER_|RT_|R_|AGE_|CT_|MUT_|ITEM_|ST_)') {
                    [void]$globals.Add([PSCustomObject]@{
                        Category = $category
                        File     = $relPath
                        Variable = $varName
                        Line     = $lineNum
                        Value    = $line.Trim().Substring(0, [Math]::Min($line.Trim().Length, 120))
                    })
                }
            }
        }
    }
}

# Export all
$imports | Sort-Object Category, File, Line | Export-Csv "$outDir\imports-index.csv" -NoTypeInformation -Encoding UTF8
Write-Host "Imports: $($imports.Count) entries -> imports-index.csv"

$objectives | Sort-Object Objective, Category, File | Export-Csv "$outDir\objectives-index.csv" -NoTypeInformation -Encoding UTF8
Write-Host "Objectives: $($objectives.Count) entries -> objectives-index.csv"

$groups | Sort-Object Category, File, GroupName | Export-Csv "$outDir\groups-index.csv" -NoTypeInformation -Encoding UTF8
Write-Host "Groups: $($groups.Count) entries -> groups-index.csv"

$globals | Sort-Object Category, File, Line | Export-Csv "$outDir\globals-index.csv" -NoTypeInformation -Encoding UTF8
Write-Host "Globals: $($globals.Count) entries -> globals-index.csv"

# Generate a compact markdown summary
$md = [System.Text.StringBuilder]::new()
[void]$md.AppendLine("# AoE4 SCAR Dependency & Data Index")
[void]$md.AppendLine("")
[void]$md.AppendLine("Auto-generated on $(Get-Date -Format 'yyyy-MM-dd HH:mm').")
[void]$md.AppendLine("")
[void]$md.AppendLine("## Summary")
[void]$md.AppendLine("- **Imports**: $($imports.Count) import statements")
[void]$md.AppendLine("- **Unique imports**: $(($imports | Select-Object -Unique Import).Count) distinct modules")
[void]$md.AppendLine("- **Objectives**: $(($objectives | Select-Object -Unique Objective).Count) unique OBJ_/SOBJ_ constants")
[void]$md.AppendLine("- **Groups**: $($groups.Count) SGroup/EGroup declarations ($(($groups | Where-Object GroupType -eq 'SGroup').Count) SGroups, $(($groups | Where-Object GroupType -eq 'EGroup').Count) EGroups)")
[void]$md.AppendLine("- **Globals**: $($globals.Count) global variable assignments")
[void]$md.AppendLine("")

# Objective listing (unique, sorted)
[void]$md.AppendLine("## All Objectives")
[void]$md.AppendLine("")
[void]$md.AppendLine("| Objective | Defined In | Also Used In |")
[void]$md.AppendLine("|-----------|-----------|--------------|")

$objByName = $objectives | Group-Object Objective | Sort-Object Name
foreach ($og in $objByName) {
    $defs = ($og.Group | Where-Object Context -eq "definition" | Select-Object -Unique File).File
    $uses = ($og.Group | Where-Object Context -eq "usage" | Select-Object -Unique File).File
    $defStr = if ($defs) { ($defs | ForEach-Object { $_ -replace '.*\\', '' }) -join ", " } else { "—" }
    $useStr = if ($uses) { ($uses | ForEach-Object { $_ -replace '.*\\', '' }) -join ", " } else { "—" }
    [void]$md.AppendLine("| ``$($og.Name)`` | $defStr | $useStr |")
}

[void]$md.AppendLine("")

# Most-imported modules
[void]$md.AppendLine("## Most-Imported Modules")
[void]$md.AppendLine("")
$topImports = $imports | Group-Object Import | Sort-Object Count -Descending | Select-Object -First 30
foreach ($ti in $topImports) {
    [void]$md.AppendLine("- **$($ti.Name)** — imported by $($ti.Count) files")
}

$md.ToString() | Set-Content "$outDir\data-index.md" -Encoding UTF8
Write-Host "Markdown summary: data-index.md"
Write-Host "Done."
