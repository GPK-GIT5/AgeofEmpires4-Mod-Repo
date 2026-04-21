<#
.SYNOPSIS
  Fills per-civ EBP gaps: extracts entities from external XML dump that are missing
  from workspace blueprint tables. Appends new entries to existing blueprint .md files.

.DESCRIPTION
  1. Loads existing blueprint tables and builds a set of known attribNames per civ
  2. Scans external XML dump for all EBP entities with pbgid
  3. Identifies missing entries not in current blueprint tables
  4. Produces gap-fill-report.json with all missing entries categorized

.PARAMETER ExternalDump
  Path to the external Gameplay_data_duplicate EBP races folder.
#>
param(
    [string]$ExternalDump = "C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races"
)

$ErrorActionPreference = 'Stop'
$root = "c:\Users\Jordan\Documents\AoE4-Workspace"
$bpRoot = Join-Path $root "references\blueprints"
$canonRoot = Join-Path $root "data\aoe4\data\canonical"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Per-Civ EBP Gap Fill" -ForegroundColor Cyan
Write-Host " $timestamp" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan

# Map external race folder names to workspace civ keys
$raceToFile = @{
    "abbasid"          = "abbasid"
    "byzantine"        = "byzantines"
    "chinese"          = "chinese"
    "english"          = "english"
    "french"           = "french"
    "hre"              = "hre"
    "japanese"         = "japanese"
    "malian"           = "malians"
    "mongol"           = "mongol"
    "ottoman"          = "ottomans"
    "rus"              = "rus"
    "sultanate"        = "sultanate"
    "templar"          = "templar"
    # HA variants → their parent civ files
    "abbasid_ha_01"    = "ayyubids"
    "byzantine_ha_mac" = "macedonian"
    "chinese_ha_01"    = "zhuxi"
    "french_ha_01"     = "jeannedarc"
    "hre_ha_01"        = "orderofthedragon"
    "japanese_ha_sen"  = "sengoku"
    "mongol_ha_gol"    = "goldenhorde"
    "sultanate_ha_tug" = "tughlaq"
    "lancaster"        = "lancaster"
}

# =====================================================================
# PHASE 1: Load existing blueprint tables
# =====================================================================
Write-Host "`n--- PHASE 1: Load Existing Blueprints ---" -ForegroundColor Yellow

$knownByFile = @{}
$bpFiles = Get-ChildItem $bpRoot -Filter "*-blueprints.md"

foreach ($f in $bpFiles) {
    $civKey = $f.BaseName -replace '-blueprints$', ''
    $names = @{}
    foreach ($line in (Get-Content $f.FullName)) {
        if ($line -match '^\|\s*`([A-Z_0-9]+)`\s*\|\s*(\d+)\s*\|') {
            $names[$Matches[1].ToLower()] = [int]$Matches[2]
        }
    }
    $knownByFile[$civKey] = $names
    Write-Host "  ${civKey}: $($names.Count) existing entries" -ForegroundColor Gray
}

$totalKnown = ($knownByFile.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
Write-Host "  Total known entries: $totalKnown" -ForegroundColor Green

# =====================================================================
# PHASE 2: Scan external dump for all EBP entities
# =====================================================================
Write-Host "`n--- PHASE 2: Scan External Dump ---" -ForegroundColor Yellow

$allExternal = @{}
$raceDirs = Get-ChildItem $ExternalDump -Directory

foreach ($raceDir in $raceDirs) {
    $race = $raceDir.Name
    $xmlFiles = Get-ChildItem $raceDir.FullName -Recurse -Filter "*.xml" -File

    foreach ($xf in $xmlFiles) {
        $content = Get-Content $xf.FullName -Raw
        $baseName = [IO.Path]::GetFileNameWithoutExtension($xf.Name)

        # Extract pbgid
        $pbgid = 0
        if ($content -match 'name="pbgid"\s+value="(\d+)"') {
            $pbgid = [int]$Matches[1]
        }

        # Determine category from path
        $relParts = $xf.FullName.Substring($raceDir.FullName.Length + 1).Replace('\', '/').Split('/')
        $category = if ($relParts.Count -ge 2) { $relParts[0] } else { "other" }

        if (-not $allExternal.ContainsKey($race)) { $allExternal[$race] = @() }
        $allExternal[$race] += [PSCustomObject]@{
            name     = $baseName
            nameUpper = $baseName.ToUpper()
            pbgid    = $pbgid
            category = $category
            race     = $race
        }
    }
}

$totalExternal = ($allExternal.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
Write-Host "  Total external entities: $totalExternal" -ForegroundColor Green

# =====================================================================
# PHASE 3: Identify gaps
# =====================================================================
Write-Host "`n--- PHASE 3: Identify Gaps ---" -ForegroundColor Yellow

$gapsByFile = @{}
$totalGaps = 0
$totalFilled = 0

foreach ($race in $allExternal.Keys) {
    $fileKey = $raceToFile[$race]
    if (-not $fileKey) { continue }  # Skip unmapped races (core, campaign, rogue, etc.)

    $known = $knownByFile[$fileKey]
    if (-not $known) {
        Write-Host "  WARNING: No blueprint file found for $fileKey (race=$race)" -ForegroundColor Red
        continue
    }

    $gaps = @()
    foreach ($entity in $allExternal[$race]) {
        if (-not $known.ContainsKey($entity.name)) {
            $gaps += $entity
            $totalGaps++
        }
    }

    if ($gaps.Count -gt 0) {
        if (-not $gapsByFile.ContainsKey($fileKey)) { $gapsByFile[$fileKey] = @() }
        $gapsByFile[$fileKey] += $gaps
    }
}

Write-Host "  Total gaps found: $totalGaps" -ForegroundColor Green

# =====================================================================
# PHASE 4: Append to blueprint files
# =====================================================================
Write-Host "`n--- PHASE 4: Append Missing Entries ---" -ForegroundColor Yellow

foreach ($fileKey in ($gapsByFile.Keys | Sort-Object)) {
    $gaps = $gapsByFile[$fileKey]
    $bpFile = Join-Path $bpRoot "$fileKey-blueprints.md"

    if (-not (Test-Path $bpFile)) {
        Write-Host "  SKIP: $fileKey-blueprints.md not found" -ForegroundColor Yellow
        continue
    }

    $content = Get-Content $bpFile -Raw

    # Categorize gaps
    $unitGaps = $gaps | Where-Object { $_.category -eq 'units' -or $_.name -match '^unit_' }
    $bldgGaps = $gaps | Where-Object { $_.category -eq 'buildings' -or $_.name -match '^building_' }
    $wpnGaps = $gaps | Where-Object { $_.category -eq 'weapons' -or $_.name -match '^wpn_' }
    $otherGaps = $gaps | Where-Object {
        $_.category -ne 'units' -and $_.category -ne 'buildings' -and $_.category -ne 'weapons' -and
        $_.name -notmatch '^unit_' -and $_.name -notmatch '^building_' -and $_.name -notmatch '^wpn_'
    }

    # Build appendix sections
    $sb = [System.Text.StringBuilder]::new()

    if ($unitGaps.Count -gt 0) {
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("### Additional Unit/Weapon EBPs (from XML dump)")
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("| Blueprint Name | PBG ID |")
        [void]$sb.AppendLine("|---|---|")
        foreach ($g in ($unitGaps | Sort-Object nameUpper)) {
            [void]$sb.AppendLine("| ``$($g.nameUpper)`` | $($g.pbgid) |")
        }
        $totalFilled += $unitGaps.Count
    }

    if ($bldgGaps.Count -gt 0) {
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("### Additional Building EBPs (from XML dump)")
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("| Blueprint Name | PBG ID |")
        [void]$sb.AppendLine("|---|---|")
        foreach ($g in ($bldgGaps | Sort-Object nameUpper)) {
            [void]$sb.AppendLine("| ``$($g.nameUpper)`` | $($g.pbgid) |")
        }
        $totalFilled += $bldgGaps.Count
    }

    if ($wpnGaps.Count -gt 0) {
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("### Additional Weapon EBPs (from XML dump)")
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("| Blueprint Name | PBG ID |")
        [void]$sb.AppendLine("|---|---|")
        foreach ($g in ($wpnGaps | Sort-Object nameUpper)) {
            [void]$sb.AppendLine("| ``$($g.nameUpper)`` | $($g.pbgid) |")
        }
        $totalFilled += $wpnGaps.Count
    }

    if ($otherGaps.Count -gt 0) {
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("### Other EBPs (from XML dump)")
        [void]$sb.AppendLine()
        [void]$sb.AppendLine("| Blueprint Name | PBG ID |")
        [void]$sb.AppendLine("|---|---|")
        foreach ($g in ($otherGaps | Sort-Object nameUpper)) {
            [void]$sb.AppendLine("| ``$($g.nameUpper)`` | $($g.pbgid) |")
        }
        $totalFilled += $otherGaps.Count
    }

    if ($sb.Length -gt 0) {
        # Check if appendix already exists to avoid duplicates
        if ($content -match '### Additional.*EBPs \(from XML dump\)') {
            Write-Host "  SKIP: $fileKey already has XML dump appendix" -ForegroundColor Yellow
        } else {
            $content + $sb.ToString() | Set-Content -Path $bpFile -Encoding UTF8
            Write-Host "  ${fileKey}: +$($gaps.Count) entries ($($unitGaps.Count) units, $($bldgGaps.Count) buildings, $($wpnGaps.Count) weapons)" -ForegroundColor Green
        }
    }
}

# =====================================================================
# PHASE 5: Save gap report
# =====================================================================
Write-Host "`n--- PHASE 5: Gap Report ---" -ForegroundColor Yellow

$reportData = [ordered]@{}
foreach ($fileKey in ($gapsByFile.Keys | Sort-Object)) {
    $gaps = $gapsByFile[$fileKey]
    $reportData[$fileKey] = [PSCustomObject]@{
        totalGaps = $gaps.Count
        byCategory = ($gaps | Group-Object category | ForEach-Object {
            [PSCustomObject]@{ category = $_.Name; count = $_.Count }
        })
        entries = ($gaps | Sort-Object nameUpper | Select-Object name, nameUpper, pbgid, category, race)
    }
}

$report = [PSCustomObject]@{
    _meta = [PSCustomObject]@{
        generated  = $timestamp
        description = "Per-civ EBP gap fill report. Entities in external XML dump missing from workspace blueprint tables."
        totalGaps  = $totalGaps
        totalFilled = $totalFilled
        civsCovered = $gapsByFile.Keys.Count
    }
    data = $reportData
}

$reportPath = Join-Path $canonRoot "gap-fill-report.json"
$report | ConvertTo-Json -Depth 10 | Set-Content -Path $reportPath -Encoding UTF8
Write-Host "  Saved: canonical/gap-fill-report.json" -ForegroundColor Green

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " GAP FILL COMPLETE" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Gaps identified: $totalGaps across $($gapsByFile.Keys.Count) civs" -ForegroundColor White
Write-Host "  Entries appended: $totalFilled" -ForegroundColor White
