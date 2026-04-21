<#
.SYNOPSIS
  Merges neutral and cheat entities from the external XML dump into the
  existing neutral-blueprints.md and canonical data.

.DESCRIPTION
  1. Scans neutral/ and cheat/ folders in external dump for entities not
     already in neutral-blueprints.md
  2. Appends missing entries to the blueprint table
  3. Generates neutral-entities.json in canonical output

.PARAMETER ExternalDump
  Path to the external Gameplay_data_duplicate EBP races folder.
  Default: C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races
#>
param(
    [string]$ExternalDump = "C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races"
)

$ErrorActionPreference = 'Stop'
$root = "c:\Users\Jordan\Documents\AoE4-Workspace"
$canonRoot = Join-Path $root "data\aoe4\data\canonical"
$bpRoot = Join-Path $root "references\blueprints"
$neutralBpPath = Join-Path $bpRoot "neutral-blueprints.md"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Neutral & Special Entity Merge" -ForegroundColor Cyan
Write-Host " $timestamp" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan

# Load existing neutral blueprint entries
$existingEntries = @{}
if (Test-Path $neutralBpPath) {
    $content = Get-Content $neutralBpPath -Raw
    $matches = [regex]::Matches($content, '`([A-Z0-9_]+)`')
    foreach ($m in $matches) {
        $existingEntries[$m.Groups[1].Value.ToLower()] = $true
    }
}
Write-Host "  Existing neutral entries: $($existingEntries.Count)" -ForegroundColor Gray

# Scan neutral + cheat folders
$sourceFolders = @("neutral", "cheat")
$allEntities = @()
$newEntities = @()

foreach ($folder in $sourceFolders) {
    $folderPath = Join-Path $ExternalDump $folder
    if (-not (Test-Path $folderPath)) {
        Write-Host "  SKIP: $folder folder not found" -ForegroundColor Yellow
        continue
    }

    $xmlFiles = Get-ChildItem $folderPath -Recurse -Filter "*.xml" -File
    Write-Host "  $folder`: $($xmlFiles.Count) XML files" -ForegroundColor White

    foreach ($xf in $xmlFiles) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($xf.Name)
        $relPath = $xf.FullName.Substring((Join-Path $ExternalDump $folder).Length + 1).Replace('\', '/')
        $xml = Get-Content $xf.FullName -Raw

        # Extract pbgid
        $pbgid = 0
        if ($xml -match 'name="pbgid"\s+value="(\d+)"') {
            $pbgid = [int]$Matches[1]
        }

        # Extract parent_pbg
        $parentPbg = ""
        if ($xml -match 'name="parent_pbg"\s+value="([^"]*)"') {
            $parentPbg = $Matches[1]
        }

        # Category from path
        $category = "other"
        if ($relPath -match '^units/') { $category = "unit" }
        elseif ($relPath -match '^buildings/') { $category = "building" }
        elseif ($relPath -match '^weapons/') { $category = "weapon" }

        # Sub-category (campaign, seasonal, etc.)
        $subCategory = "standard"
        if ($relPath -match '/campaign/') { $subCategory = "campaign" }
        elseif ($relPath -match '/seasonal/') { $subCategory = "seasonal" }

        $entity = [PSCustomObject]@{
            entity      = $baseName
            race        = $folder
            path        = $relPath
            category    = $category
            subCategory = $subCategory
            pbgid       = $pbgid
            parentPbg   = $parentPbg
        }
        $allEntities += $entity

        # Check if new
        if (-not $existingEntries.ContainsKey($baseName.ToUpper())) {
            $newEntities += $entity
        }
    }
}

Write-Host "`n  Total entities: $($allEntities.Count)" -ForegroundColor Green
Write-Host "  New (not in blueprint table): $($newEntities.Count)" -ForegroundColor $(if ($newEntities.Count -gt 0) { "Yellow" } else { "Green" })

# Append new entries to neutral-blueprints.md
if ($newEntities.Count -gt 0 -and (Test-Path $neutralBpPath)) {
    $bpContent = Get-Content $neutralBpPath -Raw

    # Check for existing appendix
    if ($bpContent -match '### Additional.*Entities \(from XML dump\)') {
        Write-Host "  SKIP: neutral-blueprints.md already has XML dump appendix" -ForegroundColor Yellow
    } else {
        $sb = [System.Text.StringBuilder]::new()
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("---")
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("> Additional entries appended from XML dump ($timestamp)")
        [void]$sb.AppendLine()

        $newUnits = $newEntities | Where-Object { $_.category -eq "unit" } | Sort-Object { $_.entity }
        $newBuildings = $newEntities | Where-Object { $_.category -eq "building" } | Sort-Object { $_.entity }
        $newOther = $newEntities | Where-Object { $_.category -notin @("unit", "building") } | Sort-Object { $_.entity }

        if ($newBuildings.Count -gt 0) {
            [void]$sb.AppendLine("### Additional Building Entities (from XML dump)")
            [void]$sb.AppendLine()
            [void]$sb.AppendLine("| Blueprint Name | PBG ID | Source | Sub-Category |")
            [void]$sb.AppendLine("|---|---|---|---|")
            foreach ($e in $newBuildings) {
                [void]$sb.AppendLine("| ``$($e.entity.ToUpper())`` | $($e.pbgid) | $($e.race) | $($e.subCategory) |")
            }
            [void]$sb.AppendLine()
        }

        if ($newUnits.Count -gt 0) {
            [void]$sb.AppendLine("### Additional Unit Entities (from XML dump)")
            [void]$sb.AppendLine()
            [void]$sb.AppendLine("| Blueprint Name | PBG ID | Source | Sub-Category |")
            [void]$sb.AppendLine("|---|---|---|---|")
            foreach ($e in $newUnits) {
                [void]$sb.AppendLine("| ``$($e.entity.ToUpper())`` | $($e.pbgid) | $($e.race) | $($e.subCategory) |")
            }
            [void]$sb.AppendLine()
        }

        if ($newOther.Count -gt 0) {
            [void]$sb.AppendLine("### Additional Special Entities (from XML dump)")
            [void]$sb.AppendLine()
            [void]$sb.AppendLine("| Blueprint Name | PBG ID | Source | Sub-Category |")
            [void]$sb.AppendLine("|---|---|---|---|")
            foreach ($e in $newOther) {
                [void]$sb.AppendLine("| ``$($e.entity.ToUpper())`` | $($e.pbgid) | $($e.race) | $($e.subCategory) |")
            }
            [void]$sb.AppendLine()
        }

        $appendText = $sb.ToString()
        Add-Content -Path $neutralBpPath -Value $appendText -Encoding UTF8
        Write-Host "  Appended $($newEntities.Count) entries to neutral-blueprints.md" -ForegroundColor Green
    }
}

# Generate canonical JSON
$canonOutput = [PSCustomObject]@{
    _meta = [PSCustomObject]@{
        generated     = $timestamp
        description   = "Neutral and special entities from XML dump (neutral/ + cheat/ folders)"
        totalEntities = $allEntities.Count
        newEntities   = $newEntities.Count
        sources       = $sourceFolders
    }
    entities = $allEntities | Sort-Object { $_.race }, { $_.category }, { $_.entity }
}

$canonPath = Join-Path $canonRoot "neutral-entities.json"
$canonOutput | ConvertTo-Json -Depth 10 | Set-Content -Path $canonPath -Encoding UTF8
Write-Host "  Saved: canonical/neutral-entities.json ($($allEntities.Count) entities)" -ForegroundColor Green

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " NEUTRAL MERGE COMPLETE" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Total entities: $($allEntities.Count)" -ForegroundColor White
Write-Host "  New appended: $($newEntities.Count)" -ForegroundColor White
