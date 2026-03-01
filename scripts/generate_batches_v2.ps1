<#
.SYNOPSIS
    Generates mission-grouped batch files for Claude summarization of AoE4 .scar files.
.DESCRIPTION
    Groups files by mission folder (campaign) or system folder (gameplay), creates batches
    that stay under 40KB to fit within a single Claude context turn, and prepends a standardized
    summarization prompt. Each batch is self-contained and includes a manifest header.
#>

param(
    [string]$WorkspaceRoot = "C:\Users\Jordan\Documents\AoE4-Workspace",
    [int]$MaxBatchBytes = 40 * 1024,  # 40KB target per batch (~10K tokens input)
    [switch]$DryRun
)

$campaignBase = "$WorkspaceRoot\reference\dumps\scar campaign\scenarios"
$gameplayBase = "$WorkspaceRoot\reference\dumps\scar gameplay"
$batchDir     = "$WorkspaceRoot\reference\dumps\Claude_Batches_v2"

if (-not $DryRun) {
    New-Item $batchDir -ItemType Directory -Force | Out-Null
}

$batchNum = 1
$manifest = [System.Collections.ArrayList]::new()

# The standardized prompt header
$promptHeader = @"
You are analyzing SCAR scripts from an Age of Empires IV mission or system.

For this batch, produce:

1. **OVERVIEW** (3-5 sentences): What does this mission/system do? Key mechanics and flow?

2. **FILE ROLES**: One line per file — filename | role (core/data/objectives/training/spawns/automated/other) | one-sentence purpose.

3. **FUNCTION INDEX** (table):
   | Function | File | Purpose (10 words max) |
   Skip trivial SGroup/EGroup creation and simple getters.
   Focus on gameplay logic, AI behavior, spawn/wave management, objective triggers.

4. **KEY SYSTEMS**:
   - Objectives: list all OBJ_/SOBJ_ constants with brief purpose
   - Difficulty: list Util_DifVar parameters and what they scale
   - Spawns: describe wave/spawn patterns and unit compositions
   - AI: any AI_Enable, encounter plans, patrol logic
   - Timers: key Rule_AddInterval/Rule_AddOneShot with timing values and purpose

5. **CROSS-REFERENCES**: imports from other missions, shared globals, inter-file function calls.

Keep output under 400 lines. Do NOT reproduce code. Be technical and precise.

---

"@

function Write-Batch {
    param(
        [string]$Label,
        [string]$Category,
        [System.Collections.ArrayList]$Files
    )
    
    if ($Files.Count -eq 0) { return }
    
    $content = [System.Text.StringBuilder]::new()
    [void]$content.Append($promptHeader)
    [void]$content.AppendLine("# BATCH: $Label")
    [void]$content.AppendLine("# Category: $Category")
    [void]$content.AppendLine("# Files: $($Files.Count)")
    [void]$content.AppendLine("")
    
    $totalSize = 0
    foreach ($f in $Files) {
        [void]$content.AppendLine("# FILE: $($f.Name)")
        $fileContent = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
        if ($fileContent) {
            [void]$content.AppendLine($fileContent)
            $totalSize += $fileContent.Length
        }
        [void]$content.AppendLine("")
    }
    
    $batchPath = "$batchDir\Batch_$batchNum.txt"
    
    if (-not $DryRun) {
        $content.ToString() | Set-Content $batchPath -Encoding UTF8
    }
    
    [void]$manifest.Add([PSCustomObject]@{
        Batch    = "Batch_$batchNum"
        Label    = $Label
        Category = $Category
        Files    = $Files.Count
        SizeKB   = [math]::Round($totalSize / 1024, 1)
    })
    
    $script:batchNum++
}

function Process-FolderGroup {
    param(
        [string]$FolderPath,
        [string]$Label,
        [string]$Category
    )
    
    $files = Get-ChildItem $FolderPath -Filter "*.scar" -File | Sort-Object Name
    if ($files.Count -eq 0) { return }
    
    $totalSize = ($files | Measure-Object Length -Sum).Sum
    
    if ($totalSize -le $MaxBatchBytes) {
        # Fits in one batch
        $fileList = [System.Collections.ArrayList]::new()
        foreach ($f in $files) { [void]$fileList.Add($f) }
        Write-Batch -Label $Label -Category $Category -Files $fileList
    } else {
        # Split into size-bounded sub-batches
        $currentBatch = [System.Collections.ArrayList]::new()
        $currentSize = 0
        $partNum = 1
        
        foreach ($f in $files) {
            if ($currentSize + $f.Length -gt $MaxBatchBytes -and $currentBatch.Count -gt 0) {
                Write-Batch -Label "$Label (Part $partNum)" -Category $Category -Files $currentBatch
                $currentBatch = [System.Collections.ArrayList]::new()
                $currentSize = 0
                $partNum++
            }
            [void]$currentBatch.Add($f)
            $currentSize += $f.Length
        }
        if ($currentBatch.Count -gt 0) {
            $partLabel = if ($partNum -gt 1) { "$Label (Part $partNum)" } else { $Label }
            Write-Batch -Label $partLabel -Category $Category -Files $currentBatch
        }
    }
}

# =====================================================================
# CAMPAIGN: Group by mission folder (leaf directories containing .scar)
# =====================================================================

Write-Host "Processing campaign files..."
$campaignDirs = Get-ChildItem $campaignBase -Directory -Recurse | Where-Object {
    (Get-ChildItem $_.FullName -Filter "*.scar" -File).Count -gt 0
} | Sort-Object FullName

foreach ($dir in $campaignDirs) {
    $relPath = $dir.FullName.Replace($campaignBase + "\", "")
    $label = $relPath -replace '\\', '/'
    Process-FolderGroup -FolderPath $dir.FullName -Label $label -Category "campaign"
}

# =====================================================================
# GAMEPLAY: Group by system folder
# =====================================================================

Write-Host "Processing gameplay files..."

# Root-level gameplay files (cardinal.scar, objectives.scar, etc.)
$rootFiles = Get-ChildItem $gameplayBase -Filter "*.scar" -File | Sort-Object Name
if ($rootFiles.Count -gt 0) {
    $rootList = [System.Collections.ArrayList]::new()
    foreach ($f in $rootFiles) { [void]$rootList.Add($f) }
    
    $rootSize = ($rootFiles | Measure-Object Length -Sum).Sum
    if ($rootSize -le $MaxBatchBytes) {
        Write-Batch -Label "gameplay/core" -Category "gameplay" -Files $rootList
    } else {
        # Split root files into batches
        $currentBatch = [System.Collections.ArrayList]::new()
        $currentSize = 0
        $partNum = 1
        foreach ($f in $rootFiles) {
            if ($currentSize + $f.Length -gt $MaxBatchBytes -and $currentBatch.Count -gt 0) {
                Write-Batch -Label "gameplay/core (Part $partNum)" -Category "gameplay" -Files $currentBatch
                $currentBatch = [System.Collections.ArrayList]::new()
                $currentSize = 0
                $partNum++
            }
            [void]$currentBatch.Add($f)
            $currentSize += $f.Length
        }
        if ($currentBatch.Count -gt 0) {
            Write-Batch -Label "gameplay/core (Part $partNum)" -Category "gameplay" -Files $currentBatch
        }
    }
}

# Gameplay subdirectories
$gameplayDirs = Get-ChildItem $gameplayBase -Directory | Sort-Object Name
foreach ($dir in $gameplayDirs) {
    $subDirs = Get-ChildItem $dir.FullName -Directory -Recurse | Where-Object {
        (Get-ChildItem $_.FullName -Filter "*.scar" -File).Count -gt 0
    }
    
    if ($subDirs.Count -gt 0) {
        # Has subdirectories with .scar files — process each
        # But first check if the parent dir itself has files
        $dirFiles = Get-ChildItem $dir.FullName -Filter "*.scar" -File
        if ($dirFiles.Count -gt 0) {
            Process-FolderGroup -FolderPath $dir.FullName -Label "gameplay/$($dir.Name)" -Category "gameplay"
        }
        foreach ($sub in $subDirs) {
            $subRel = $sub.FullName.Replace($gameplayBase + "\", "") -replace '\\', '/'
            Process-FolderGroup -FolderPath $sub.FullName -Label "gameplay/$subRel" -Category "gameplay"
        }
    } else {
        # Flat directory — process as one group
        Process-FolderGroup -FolderPath $dir.FullName -Label "gameplay/$($dir.Name)" -Category "gameplay"
    }
}

# =====================================================================
# MANIFEST
# =====================================================================

$manifestPath = "$batchDir\batch_manifest.csv"
$manifest | Export-Csv $manifestPath -NoTypeInformation -Encoding UTF8

# Markdown manifest
$mdManifest = [System.Text.StringBuilder]::new()
[void]$mdManifest.AppendLine("# Claude Batch Manifest (v2)")
[void]$mdManifest.AppendLine("")
[void]$mdManifest.AppendLine("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
[void]$mdManifest.AppendLine("Total batches: **$($manifest.Count)**")
[void]$mdManifest.AppendLine("Total files: **$(($manifest | Measure-Object -Property Files -Sum).Sum)**")
[void]$mdManifest.AppendLine("")
[void]$mdManifest.AppendLine("| # | Batch | Label | Category | Files | Size (KB) |")
[void]$mdManifest.AppendLine("|---|-------|-------|----------|-------|-----------|")

$idx = 1
foreach ($m in $manifest) {
    [void]$mdManifest.AppendLine("| $idx | $($m.Batch) | $($m.Label) | $($m.Category) | $($m.Files) | $($m.SizeKB) |")
    $idx++
}

$mdManifest.ToString() | Set-Content "$batchDir\batch_manifest.md" -Encoding UTF8

Write-Host ""
Write-Host "=========================================="
Write-Host "Batch generation complete!"
Write-Host "  Total batches: $($manifest.Count)"
Write-Host "  Total files:   $(($manifest | Measure-Object -Property Files -Sum).Sum)"
Write-Host "  Output dir:    $batchDir"
Write-Host "  Manifest:      $manifestPath"
Write-Host "=========================================="
