<#
.SYNOPSIS
    Parses the AoE4 Attributes dump file to extract all blueprints (SBP, EBP, UPG)
    organized by faction, and outputs per-faction markdown reference files.
#>

$dumpPath = Join-Path $PSScriptRoot "..\reference\Dumps\Attributes dump.txt"
$outputDir = Join-Path $PSScriptRoot "..\reference\blueprints"

if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$lines = Get-Content $dumpPath

# ---- State machine parser ----
# We look for top-level tables: [SBP], [EBP], [UPG]
# Inside each, we look for faction tables: [FACTION_NAME]
# Inside each faction, we collect blueprint entries with their PropertyBagGroupID

$data = @{}  # $data["SBP"]["ABBASID"] = @( @{Name="..."; ID="..."}, ... )

$currentTable = $null
$currentFaction = $null
$currentEntry = $null
$braceDepth = 0
$tableDepth = 0
$factionDepth = 0
$entryDepth = 0
$inEntry = $false

# Track brace depth for the top-level tables
$targetTables = @("SBP", "EBP", "UPG")
$skipFactions = @("__skipsave", "CIV_START")

$i = 0
$totalLines = $lines.Count

Write-Host "Parsing $totalLines lines..."

# Simple approach: find the SBP, EBP, UPG table starts, then parse each
function Find-TableRange {
    param([string[]]$Lines, [string]$TableName)
    
    $start = -1
    $depth = 0
    $foundStart = $false
    
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $line = $Lines[$i]
        
        if (-not $foundStart) {
            # Match top-level table like: [SBP] => (table: ...)
            if ($line -match "^\s{4}\[$TableName\]\s*=>\s*\(table:") {
                $start = $i
                $depth = 1
                $foundStart = $true
            }
        } else {
            # Count braces
            $opens = ([regex]::Matches($line, '\{') | Measure-Object).Count
            $closes = ([regex]::Matches($line, '\}') | Measure-Object).Count
            $depth += $opens - $closes
            if ($depth -le 0) {
                return @{ Start = $start; End = $i }
            }
        }
    }
    
    if ($foundStart) {
        return @{ Start = $start; End = $Lines.Count - 1 }
    }
    return $null
}

function Parse-BlueprintTable {
    param([string[]]$Lines, [int]$Start, [int]$End)
    
    $factions = @{}
    $currentFaction = $null
    $factionDepth = 0
    $currentBPName = $null
    $currentBPID = $null
    $inEntry = $false
    $entryDepth = 0
    
    for ($i = $Start + 1; $i -le $End; $i++) {
        $line = $Lines[$i]
        
        $opens = ([regex]::Matches($line, '\{') | Measure-Object).Count
        $closes = ([regex]::Matches($line, '\}') | Measure-Object).Count
        
        if ($currentFaction -eq $null) {
            # Look for faction: [FACTION_NAME] => (table: ...)
            if ($line -match '^\s{8}\[(\w+)\]\s*=>\s*\(table:') {
                $fName = $Matches[1]
                if ($fName -ne "__skipsave") {
                    $currentFaction = $fName
                    $factionDepth = 1
                    $factions[$currentFaction] = [System.Collections.ArrayList]::new()
                }
            }
        } else {
            # Always track faction depth
            $factionDepth += $opens - $closes
            
            if ($inEntry) {
                # Inside an expanded entry - look for PropertyBagGroupID
                if ($line -match 'PropertyBagGroupID.*?(\d+)') {
                    $currentBPID = $Matches[1]
                }
                
                $entryDepth += $opens - $closes
                if ($entryDepth -le 0) {
                    $id = if ($currentBPID) { $currentBPID } else { "(unknown)" }
                    $factions[$currentFaction].Add(@{ Name = $currentBPName; ID = $id }) | Out-Null
                    $inEntry = $false
                    $currentBPName = $null
                    $currentBPID = $null
                }
            } else {
                # Look for blueprint entry (expanded with braces)
                if ($line -match '^\s{12}\[(\w+)\]\s*=>\s*\(pbg _mt:.*\)\s*\{') {
                    $currentBPName = $Matches[1]
                    if ($currentBPName -ne "__skipsave") {
                        $inEntry = $true
                        $entryDepth = 1
                        $currentBPID = $null
                    }
                }
                # Look for collapsed blueprint entry (no braces, single line)
                elseif ($line -match '^\s{12}\[(\w+)\]\s*=>\s*<pbg _mt:.*>') {
                    $bpName = $Matches[1]
                    if ($bpName -ne "__skipsave") {
                        $factions[$currentFaction].Add(@{ Name = $bpName; ID = "(collapsed)" }) | Out-Null
                    }
                }
            }
            
            # Check if faction ended
            if ($factionDepth -le 0) {
                $currentFaction = $null
                $inEntry = $false
            }
        }
    }
    
    return $factions
}

# ---- Parse each table ----
$allData = @{}

foreach ($tableName in $targetTables) {
    Write-Host "Finding [$tableName] table range..."
    $range = Find-TableRange -Lines $lines -TableName $tableName
    if ($range) {
        Write-Host "  Found at lines $($range.Start)-$($range.End)"
        $parsed = Parse-BlueprintTable -Lines $lines -Start $range.Start -End $range.End
        $allData[$tableName] = $parsed
        foreach ($faction in $parsed.Keys) {
            Write-Host "    $faction : $($parsed[$faction].Count) entries"
        }
    } else {
        Write-Host "  NOT FOUND"
    }
}

# ---- Collect all player factions ----
$allFactions = @{}
foreach ($tableName in $targetTables) {
    if ($allData.ContainsKey($tableName)) {
        foreach ($faction in $allData[$tableName].Keys) {
            if (-not $allFactions.ContainsKey($faction)) {
                $allFactions[$faction] = @{}
            }
            $allFactions[$faction][$tableName] = $allData[$tableName][$faction]
        }
    }
}

# ---- Determine which are "player" factions vs utility ----
$utilityFactions = @("GAIA", "CAMPAIGN", "CORE", "NEUTRAL", "CIV_START", "COMMON")

# ---- Write per-faction files ----
foreach ($faction in ($allFactions.Keys | Sort-Object)) {
    $isUtility = $faction -in $utilityFactions
    $fileName = "$($faction.ToLower())-blueprints.md"
    $filePath = Join-Path $outputDir $fileName
    
    $sb = [System.Text.StringBuilder]::new()
    
    $factionDisplay = switch ($faction) {
        "ABBASID" { "Abbasid Dynasty" }
        "HRE" { "Holy Roman Empire" }
        "ENGLISH" { "English" }
        "CHINESE" { "Chinese" }
        "FRENCH" { "French" }
        "RUS" { "Rus" }
        "MONGOL" { "Mongols" }
        "SULTANATE" { "Delhi Sultanate" }
        "NORMANS" { "Normans" }
        "GAIA" { "Gaia (Neutral Units)" }
        "CAMPAIGN" { "Campaign" }
        "CORE" { "Core (Shared)" }
        "NEUTRAL" { "Neutral" }
        "CIV_START" { "Civilization Start" }
        default { $faction }
    }
    
    [void]$sb.AppendLine("# $factionDisplay - Blueprints")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("> Auto-extracted from ``Attributes dump.txt`` for use in SCAR scripting.")
    [void]$sb.AppendLine("> Use with ``BP_GetSquadBlueprint()``, ``BP_GetEntityBlueprint()``, ``BP_GetUpgradeBlueprint()``")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine("")
    
    # SBP - Squad (Unit) Blueprints
    if ($allFactions[$faction].ContainsKey("SBP")) {
        $entries = $allFactions[$faction]["SBP"]
        [void]$sb.AppendLine("## Squad Blueprints (SBP) - Units")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("| Blueprint Name | PBG ID |")
        [void]$sb.AppendLine("|---|---|")
        foreach ($entry in ($entries | Sort-Object { $_.Name })) {
            [void]$sb.AppendLine("| ``$($entry.Name)`` | $($entry.ID) |")
        }
        [void]$sb.AppendLine("")
    }
    
    # EBP - Entity (Building) Blueprints
    if ($allFactions[$faction].ContainsKey("EBP")) {
        $entries = $allFactions[$faction]["EBP"]
        [void]$sb.AppendLine("## Entity Blueprints (EBP) - Buildings & Entities")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("| Blueprint Name | PBG ID |")
        [void]$sb.AppendLine("|---|---|")
        foreach ($entry in ($entries | Sort-Object { $_.Name })) {
            [void]$sb.AppendLine("| ``$($entry.Name)`` | $($entry.ID) |")
        }
        [void]$sb.AppendLine("")
    }
    
    # UPG - Upgrade Blueprints
    if ($allFactions[$faction].ContainsKey("UPG")) {
        $entries = $allFactions[$faction]["UPG"]
        [void]$sb.AppendLine("## Upgrade Blueprints (UPG)")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("| Blueprint Name | PBG ID |")
        [void]$sb.AppendLine("|---|---|")
        foreach ($entry in ($entries | Sort-Object { $_.Name })) {
            [void]$sb.AppendLine("| ``$($entry.Name)`` | $($entry.ID) |")
        }
        [void]$sb.AppendLine("")
    }
    
    # Write SCAR usage example at the bottom
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## SCAR Usage Examples")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("``````lua")
    [void]$sb.AppendLine("-- Get a squad blueprint by name")
    [void]$sb.AppendLine("local sbp = BP_GetSquadBlueprint(""unit_name_here"")")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("-- Get an entity blueprint by name")
    [void]$sb.AppendLine("local ebp = BP_GetEntityBlueprint(""entity_name_here"")")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("-- Get an upgrade blueprint by name")
    [void]$sb.AppendLine("local ubp = BP_GetUpgradeBlueprint(""upgrade_name_here"")")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("-- Get a blueprint by PBG ID")
    [void]$sb.AppendLine("local sbp = BP_GetSquadBlueprintByPbgID(167674)")
    [void]$sb.AppendLine("local ebp = BP_GetEntityBlueprintByPbgID(107180)")
    [void]$sb.AppendLine("``````")
    [void]$sb.AppendLine("")
    
    Set-Content -Path $filePath -Value $sb.ToString() -Encoding UTF8
    Write-Host "Wrote $filePath"
}

# ---- Write index file ----
$indexPath = Join-Path $outputDir "README.md"
$sb = [System.Text.StringBuilder]::new()

[void]$sb.AppendLine("# AoE4 Blueprint Reference")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("Blueprint data extracted from the Attributes dump for use in SCAR scripting.")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## Blueprint Types")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("| Type | Code | Description |")
[void]$sb.AppendLine("|------|------|-------------|")
[void]$sb.AppendLine("| **SBP** | Squad Blueprint | Units (soldiers, villagers, traders, ships) |")
[void]$sb.AppendLine("| **EBP** | Entity Blueprint | Buildings, walls, landmarks, siege (placed entities) |")
[void]$sb.AppendLine("| **UPG** | Upgrade Blueprint | Technologies, age-ups, unique upgrades |")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("## Player Factions")
[void]$sb.AppendLine("")

$playerFactions = $allFactions.Keys | Where-Object { $_ -notin $utilityFactions } | Sort-Object
foreach ($faction in $playerFactions) {
    $factionDisplay = switch ($faction) {
        "ABBASID" { "Abbasid Dynasty" }
        "HRE" { "Holy Roman Empire" }
        "ENGLISH" { "English" }
        "CHINESE" { "Chinese" }
        "FRENCH" { "French" }
        "RUS" { "Rus" }
        "MONGOL" { "Mongols" }
        "SULTANATE" { "Delhi Sultanate" }
        "NORMANS" { "Normans" }
        default { $faction }
    }
    $fileName = "$($faction.ToLower())-blueprints.md"
    
    $sbpCount = if ($allFactions[$faction].ContainsKey("SBP")) { $allFactions[$faction]["SBP"].Count } else { 0 }
    $ebpCount = if ($allFactions[$faction].ContainsKey("EBP")) { $allFactions[$faction]["EBP"].Count } else { 0 }
    $upgCount = if ($allFactions[$faction].ContainsKey("UPG")) { $allFactions[$faction]["UPG"].Count } else { 0 }
    
    [void]$sb.AppendLine("- [$factionDisplay]($fileName) - $sbpCount units, $ebpCount entities, $upgCount upgrades")
}

[void]$sb.AppendLine("")
[void]$sb.AppendLine("## Other")
[void]$sb.AppendLine("")

$otherFactions = $allFactions.Keys | Where-Object { $_ -in $utilityFactions } | Sort-Object
foreach ($faction in $otherFactions) {
    $factionDisplay = switch ($faction) {
        "GAIA" { "Gaia (Neutral Units)" }
        "CAMPAIGN" { "Campaign" }
        "CORE" { "Core (Shared)" }
        "NEUTRAL" { "Neutral" }
        "CIV_START" { "Civilization Start" }
        "COMMON" { "Common (Shared Upgrades)" }
        default { $faction }
    }
    $fileName = "$($faction.ToLower())-blueprints.md"
    
    $sbpCount = if ($allFactions[$faction].ContainsKey("SBP")) { $allFactions[$faction]["SBP"].Count } else { 0 }
    $ebpCount = if ($allFactions[$faction].ContainsKey("EBP")) { $allFactions[$faction]["EBP"].Count } else { 0 }
    $upgCount = if ($allFactions[$faction].ContainsKey("UPG")) { $allFactions[$faction]["UPG"].Count } else { 0 }
    
    [void]$sb.AppendLine("- [$factionDisplay]($fileName) - $sbpCount units, $ebpCount entities, $upgCount upgrades")
}

[void]$sb.AppendLine("")

Set-Content -Path $indexPath -Value $sb.ToString() -Encoding UTF8
Write-Host "`nWrote index: $indexPath"
Write-Host "Done!"
