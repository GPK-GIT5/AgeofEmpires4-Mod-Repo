<#
.SYNOPSIS
    Catalogs all AoE4 data sources with file counts, sizes, and freshness.
    Stage 1 of the Civ Data Extraction Plan.
.DESCRIPTION
    Scans data/aoe4/data/ subdirectories and produces a source inventory JSON
    plus a data authority matrix markdown file.
.PARAMETER WorkspaceRoot
    Root of the AoE4 workspace.
#>

param(
    [string]$WorkspaceRoot = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$dataRoot = "$WorkspaceRoot\data\aoe4\data"
$outJson  = "$WorkspaceRoot\data\aoe4\source-inventory.json"
$outMd    = "$WorkspaceRoot\references\workspace\data-authority-matrix.md"

Write-Host "[source_inventory] Scanning: $dataRoot"
Write-Host ""

# ─── Scan directories ─────────────────────────────────────────────────────────

$inventory = @()

$categories = @("civilizations", "units", "buildings", "technologies")
foreach ($cat in $categories) {
    $catPath = "$dataRoot\$cat"
    if (-not (Test-Path $catPath)) {
        $inventory += [PSCustomObject]@{
            category    = $cat
            status      = "missing"
            fileCount   = 0
            totalSizeKB = 0
            lastModified = $null
            subDirs     = @()
            unifiedFile = $null
        }
        continue
    }

    $allFiles = Get-ChildItem $catPath -Recurse -File
    $totalSize = ($allFiles | Measure-Object -Property Length -Sum).Sum
    $lastMod = ($allFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime

    $unified = $null
    foreach ($uf in @("all-unified.json", "all.json", "all-optimized.json")) {
        $ufPath = "$catPath\$uf"
        if (Test-Path $ufPath) {
            $ufInfo = Get-Item $ufPath
            $unified = [PSCustomObject]@{
                name     = $uf
                sizeKB   = [math]::Round($ufInfo.Length / 1024, 1)
                modified = $ufInfo.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
            }
            break
        }
    }

    $subDirs = Get-ChildItem $catPath -Directory | ForEach-Object {
        $subFiles = Get-ChildItem $_.FullName -File -Filter "*.json" -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            name      = $_.Name
            fileCount = $subFiles.Count
        }
    }

    $inventory += [PSCustomObject]@{
        category     = $cat
        status       = "present"
        fileCount    = $allFiles.Count
        totalSizeKB  = [math]::Round($totalSize / 1024, 1)
        lastModified = $lastMod.ToString("yyyy-MM-dd HH:mm")
        subDirs      = @($subDirs)
        unifiedFile  = $unified
    }
}

# Scardocs
$scardocsPath = "$WorkspaceRoot\data\aoe4\scardocs"
if (Test-Path $scardocsPath) {
    $scFiles = Get-ChildItem $scardocsPath -File
    $inventory += [PSCustomObject]@{
        category     = "scardocs"
        status       = "present"
        fileCount    = $scFiles.Count
        totalSizeKB  = [math]::Round(($scFiles | Measure-Object Length -Sum).Sum / 1024, 1)
        lastModified = ($scFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString("yyyy-MM-dd HH:mm")
        subDirs      = @()
        unifiedFile  = $null
    }
}

# SCAR dump
$scarDumpPath = "$WorkspaceRoot\data\aoe4\scar_dump"
if (Test-Path $scarDumpPath) {
    $sdFiles = Get-ChildItem $scarDumpPath -Recurse -File -Filter "*.scar"
    $inventory += [PSCustomObject]@{
        category     = "scar_dump"
        status       = "present"
        fileCount    = $sdFiles.Count
        totalSizeKB  = [math]::Round(($sdFiles | Measure-Object Length -Sum).Sum / 1024, 1)
        lastModified = ($sdFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString("yyyy-MM-dd HH:mm")
        subDirs      = @(Get-ChildItem $scarDumpPath -Directory | ForEach-Object {
            [PSCustomObject]@{ name = $_.Name; fileCount = (Get-ChildItem $_.FullName -Recurse -File).Count }
        })
        unifiedFile  = $null
    }
}

# DLC inventory
$dlcPath = "$dataRoot\dlc_bp_inventory.txt"
if (Test-Path $dlcPath) {
    $dlcInfo = Get-Item $dlcPath
    $inventory += [PSCustomObject]@{
        category     = "dlc_bp_inventory"
        status       = "present"
        fileCount    = 1
        totalSizeKB  = [math]::Round($dlcInfo.Length / 1024, 1)
        lastModified = $dlcInfo.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
        subDirs      = @()
        unifiedFile  = $null
    }
}

# Civs index check
$civsIdxPath = "$dataRoot\civilizations\civs-index.json"
$civsCount = 0
if (Test-Path $civsIdxPath) {
    $civsJson = Get-Content $civsIdxPath -Raw -Encoding utf8 | ConvertFrom-Json
    if ($civsJson -is [array]) { $civsCount = $civsJson.Count }
    else {
        $civsCount = ($civsJson.PSObject.Properties | Measure-Object).Count
    }
}

# Per-civ folder coverage
$civCoverage = @{}
foreach ($cat in @("units", "buildings", "technologies")) {
    $catPath = "$dataRoot\$cat"
    if (Test-Path $catPath) {
        $dirs = Get-ChildItem $catPath -Directory
        foreach ($d in $dirs) {
            if (-not $civCoverage.ContainsKey($d.Name)) {
                $civCoverage[$d.Name] = @{}
            }
            $civCoverage[$d.Name][$cat] = (Get-ChildItem $d.FullName -File -Filter "*.json").Count
        }
    }
}

$coverageList = $civCoverage.GetEnumerator() | Sort-Object Name | ForEach-Object {
    [PSCustomObject]@{
        civ          = $_.Name
        unitFiles    = if ($_.Value.ContainsKey("units")) { $_.Value["units"] } else { 0 }
        buildingFiles = if ($_.Value.ContainsKey("buildings")) { $_.Value["buildings"] } else { 0 }
        techFiles    = if ($_.Value.ContainsKey("technologies")) { $_.Value["technologies"] } else { 0 }
    }
}

# ─── Write JSON ───────────────────────────────────────────────────────────────

$result = [PSCustomObject]@{
    generated    = (Get-Date).ToString("yyyy-MM-dd HH:mm")
    civsInIndex  = $civsCount
    sources      = $inventory
    civCoverage  = @($coverageList)
}

$result | ConvertTo-Json -Depth 5 | Set-Content $outJson -Encoding utf8
Write-Host "[source_inventory] -> $outJson"

# ─── Write authority matrix ───────────────────────────────────────────────────

$mdLines = @(
    "# Data Authority Matrix"
    ""
    "> Which data source is authoritative for each domain."
    "> Generated: $((Get-Date).ToString('yyyy-MM-dd HH:mm'))"
    ""
    "## Source Priority"
    ""
    "| Data Domain | Authoritative Source | Backup / Cross-check | Notes |"
    "|-------------|---------------------|----------------------|-------|"
    "| Unit stats (HP, cost, damage) | ``data/aoe4/data/units/all-unified.json`` | Runtime ``BP_GetEntityBPCost`` | JSON has full schema; runtime validates |"
    "| Building stats | ``data/aoe4/data/buildings/all-unified.json`` | Runtime ``BP_GetEntityBPCost`` | Garrison capacity is runtime-only |"
    "| Technology costs | ``data/aoe4/data/technologies/all-unified.json`` | Runtime ``Player_GetUpgradeBPCost`` | JSON costs may be array format |"
    "| Blueprint existence | Runtime ``EBP_Exists`` / ``SBP_Exists`` | JSON attribName presence | Runtime is ground truth |"
    "| Civ identity | ``data/aoe4/data/civilizations/civs-index.json`` | ``AGS_ENTITY_TABLE`` key set | 22 civs in JSON; runtime may have more |"
    "| Civ parent mapping | ``AGS_CIV_PARENT_MAP`` (SCAR) | Cross-check with DLC inventory | 6 DLC variants mapped |"
    "| Blueprint suffix | ``CBA_CIV_BP_SUFFIX`` (SCAR) | Derivable from attribName patterns | SCAR table is authoritative |"
    "| SCAR API signatures | ``data/aoe4/scardocs/parsed_functions.json`` | ``references/api/scar-engine-api-signatures.md`` | 1,983 functions |"
    "| Game events | ``references/api/game-events.md`` | n/a | 188 GE_* events |"
    "| Function index | ``references/indexes/function-index.csv`` | n/a | 8,989 workspace functions |"
    "| DLC blueprint names | ``data/aoe4/data/dlc_bp_inventory.txt`` | Per-civ JSON folders | Pipe-delimited attribName-to-id map |"
    "| Production chains | Derived from ``producedBy[]`` in JSON | n/a | Computed in Stage 2a |"
    "| Unit DPS | Derived from weapons[] in JSON | n/a | Computed in Stage 2a |"
    ""
    "## Civ Coverage (per-civ JSON file counts)"
    ""
    "| Civ | Units | Buildings | Technologies |"
    "|-----|-------|-----------|--------------|"
)

foreach ($c in $coverageList) {
    $mdLines += "| $($c.civ) | $($c.unitFiles) | $($c.buildingFiles) | $($c.techFiles) |"
}

$mdLines += ""
$mdLines += "## Source Freshness"
$mdLines += ""
$mdLines += "| Category | Files | Size (KB) | Last Modified |"
$mdLines += "|----------|-------|-----------|---------------|"
foreach ($src in $inventory) {
    $mdLines += "| $($src.category) | $($src.fileCount) | $($src.totalSizeKB) | $($src.lastModified) |"
}

$mdLines -join "`n" | Set-Content $outMd -Encoding utf8
Write-Host "[source_inventory] -> $outMd"
Write-Host ""
Write-Host "[source_inventory] Done."
