<#
.SYNOPSIS
  Extracts campaign, crusader_cmp, ayyubid_cmp, and rogue entity blueprints
  from the external EBP XML dump. Produces canonical JSON catalogs and appends
  entries to per-race blueprint reference tables.

.DESCRIPTION
  Scans the 4 campaign-related race folders in the external XML dump:
    - campaign/ (232 entities, 9 sub-civs)
    - crusader_cmp/ (112 entities)
    - ayyubid_cmp/ (97 entities)
    - rogue/ (77 entities)
  For each entity: extracts attribName, parent_pbg reference, entity type,
  sub-race/category classification, and any pbgid.
  Outputs:
    - data/aoe4/data/canonical/campaign-entities.json (unified catalog)
    - Appends to references/blueprints/campaign-blueprints.md (with dup protection)

.PARAMETER ExternalDump
  Path to external EBP races folder.
  Default: C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races

.PARAMETER Root
  Workspace root.
  Default: C:\Users\Jordan\Documents\AoE4-Workspace
#>
param(
    [string]$ExternalDump = "C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races",
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$ErrorActionPreference = 'Stop'
$canonRoot  = Join-Path $Root "data\aoe4\data\canonical"
$bpRoot     = Join-Path $Root "references\blueprints"
$timestamp  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$campaignRaces = @('campaign', 'crusader_cmp', 'ayyubid_cmp', 'rogue')

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Campaign/Rogue Entity Extraction" -ForegroundColor Cyan
Write-Host " $timestamp" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan

# =====================================================================
# PHASE 1: PARSE ALL XML FILES
# =====================================================================
$allEntities = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($race in $campaignRaces) {
    $raceDir = Join-Path $ExternalDump $race
    if (-not (Test-Path $raceDir)) {
        Write-Host "  SKIP: $race folder not found at $raceDir" -ForegroundColor Yellow
        continue
    }

    $xmlFiles = Get-ChildItem $raceDir -Recurse -Filter "*.xml" -File
    Write-Host "  $race : $($xmlFiles.Count) XML files" -ForegroundColor Gray

    foreach ($xml in $xmlFiles) {
        $content = Get-Content $xml.FullName -Raw
        $attribName = $xml.BaseName.ToUpper()

        # Classify entity type
        $entityType = if ($attribName -match '^UNIT_') { "unit" }
                      elseif ($attribName -match '^BUILDING_') { "building" }
                      elseif ($attribName -match '^WPN_') { "weapon" }
                      elseif ($attribName -match '^PROJECTILE_') { "projectile" }
                      else { "other" }

        # Extract parent_pbg
        $parent = ""
        if ($content -match 'name="parent_pbg"\s+value="([^"]*)"') {
            $parent = $Matches[1]
        }

        # Extract pbgid if present
        $pbgid = ""
        if ($content -match 'name="pbgid"\s+value="(\d+)"') {
            $pbgid = $Matches[1]
        }

        # Sub-race for campaign/ folder (has civ subfolders)
        $subRace = ""
        $relPath = $xml.FullName.Substring($raceDir.Length + 1).Replace('\', '/')
        if ($race -eq "campaign") {
            $parts = $relPath -split '/'
            if ($parts.Count -ge 2) {
                $subRace = $parts[0]  # e.g., "chinese", "english", "normans"
            }
        }

        # Category from folder structure
        $category = ""
        $folderParts = $relPath -split '/'
        foreach ($part in $folderParts) {
            if ($part -match '^(units|buildings|weapons|projectile)$') {
                $category = $part
                break
            }
        }
        if (-not $category -and $entityType -ne "other") {
            $category = $entityType + "s"
        }

        # Classify parent origin
        $parentOrigin = "none"
        if ($parent -match 'races\\core\\|races\.core\.') {
            $parentOrigin = "core"
        } elseif ($parent -ne "") {
            $parentOrigin = "other"
        }

        $allEntities.Add([PSCustomObject]@{
            race        = $race
            subRace     = $subRace
            attribName  = $attribName
            entityType  = $entityType
            category    = $category
            parent      = $parent
            parentOrigin = $parentOrigin
            pbgid       = $pbgid
            relPath     = $relPath
        })
    }
}

Write-Host "`n  Total entities parsed: $($allEntities.Count)" -ForegroundColor Green

# =====================================================================
# PHASE 2: GENERATE CANONICAL JSON
# =====================================================================
$byRace = @{}
foreach ($e in $allEntities) {
    if (-not $byRace.ContainsKey($e.race)) {
        $byRace[$e.race] = [System.Collections.Generic.List[PSCustomObject]]::new()
    }
    $byRace[$e.race].Add($e)
}

$jsonOutput = [ordered]@{
    _meta = [ordered]@{
        generated     = $timestamp
        source        = $ExternalDump
        totalEntities = $allEntities.Count
        races         = [ordered]@{}
    }
    entities = @{}
}

foreach ($race in $campaignRaces) {
    if (-not $byRace.ContainsKey($race)) { continue }
    $raceEntities = $byRace[$race]

    $unitCount  = ($raceEntities | Where-Object { $_.entityType -eq "unit" }).Count
    $bldgCount  = ($raceEntities | Where-Object { $_.entityType -eq "building" }).Count
    $wpnCount   = ($raceEntities | Where-Object { $_.entityType -eq "weapon" -or $_.entityType -eq "projectile" }).Count
    $otherCount = ($raceEntities | Where-Object { $_.entityType -eq "other" }).Count
    $coreCount  = ($raceEntities | Where-Object { $_.parentOrigin -eq "core" }).Count

    $jsonOutput._meta.races[$race] = [ordered]@{
        total    = $raceEntities.Count
        units    = $unitCount
        buildings = $bldgCount
        weapons  = $wpnCount
        other    = $otherCount
        coreParent = $coreCount
    }

    $raceList = [System.Collections.Generic.List[object]]::new()
    foreach ($e in ($raceEntities | Sort-Object attribName)) {
        $entry = [ordered]@{
            attribName  = $e.attribName
            entityType  = $e.entityType
            parent      = $e.parent
            parentOrigin = $e.parentOrigin
        }
        if ($e.subRace) { $entry["subRace"] = $e.subRace }
        if ($e.pbgid)   { $entry["pbgid"]   = $e.pbgid }
        $raceList.Add($entry)
    }
    $jsonOutput.entities[$race] = $raceList
}

$jsonPath = Join-Path $canonRoot "campaign-entities.json"
$jsonOutput | ConvertTo-Json -Depth 6 | Set-Content $jsonPath -Encoding UTF8
Write-Host "  Saved: $jsonPath ($($allEntities.Count) entities)" -ForegroundColor Green

# =====================================================================
# PHASE 3: APPEND TO BLUEPRINT TABLES
# =====================================================================
$bpFile = Join-Path $bpRoot "campaign-blueprints.md"

if (Test-Path $bpFile) {
    $existingContent = Get-Content $bpFile -Raw

    # Collect existing attribNames to avoid duplicates
    $existingNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $existingContent -split "`n" | ForEach-Object {
        if ($_ -match '`([A-Z0-9_]+)`') {
            [void]$existingNames.Add($Matches[1])
        }
    }

    $newEntries = $allEntities | Where-Object { -not $existingNames.Contains($_.attribName) } | Sort-Object race, entityType, attribName
    $appendCount = $newEntries.Count

    if ($appendCount -gt 0) {
        $sb = [System.Text.StringBuilder]::new()
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("## Campaign/Rogue Entities (Auto-Appended $timestamp)")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("| attribName | Race | Type | Parent Origin |")
        [void]$sb.AppendLine("|------------|------|------|---------------|")
        foreach ($e in $newEntries) {
            $raceLabel = if ($e.subRace) { "$($e.race)/$($e.subRace)" } else { $e.race }
            [void]$sb.AppendLine("| ``$($e.attribName)`` | $raceLabel | $($e.entityType) | $($e.parentOrigin) |")
        }

        Add-Content $bpFile $sb.ToString() -Encoding UTF8
        Write-Host "  Appended $appendCount new entries to campaign-blueprints.md" -ForegroundColor Green
    } else {
        Write-Host "  No new entries to append (all $($allEntities.Count) already present)" -ForegroundColor Gray
    }
    Write-Host "  Existing entries: $($existingNames.Count), new: $appendCount" -ForegroundColor Gray
} else {
    Write-Host "  WARN: campaign-blueprints.md not found at $bpFile" -ForegroundColor Yellow
}

# =====================================================================
# SUMMARY
# =====================================================================
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Campaign/Rogue Extraction Complete" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
foreach ($race in $campaignRaces) {
    if ($byRace.ContainsKey($race)) {
        $r = $byRace[$race]
        Write-Host "  $race : $($r.Count) entities" -ForegroundColor White
    }
}
Write-Host "  Total: $($allEntities.Count)" -ForegroundColor White
Write-Host "================================================================" -ForegroundColor Cyan
