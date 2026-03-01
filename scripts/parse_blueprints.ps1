$file = "c:\Users\Jordan\Documents\AoE4-Workspace\reference\Dumps\Attributes dump.txt"
$lines = [System.IO.File]::ReadAllLines($file)
$totalLines = $lines.Count

# We need to find the 5 tables: unit_upgrades, SBP, EBP, upgrade, research_upgrades
# Each table is at a specific indentation level

$output = @{}
$currentTable = $null
$currentFaction = $null
$currentSubKey = $null  # for unit_upgrades sub-tables (age tiers)
$currentBP = $null
$depth = 0

# Track brace depth to know when tables end
$tableStartLine = @{}
$tableDepth = @{}

# State machine approach
$state = "SEARCHING"  # SEARCHING, IN_TABLE, IN_FACTION, IN_SUBFACTION, IN_BP
$braceStack = @()

# Simpler approach: use regex to find table starts and then parse entries
$targetTables = @("unit_upgrades", "SBP", "EBP", "upgrade", "research_upgrades")

$results = @{}
foreach ($t in $targetTables) {
    $results[$t] = [ordered]@{}
}

$i = 0
$insideTable = $null
$factionName = $null
$subGroupName = $null  # For unit_upgrades age tiers
$bpName = $null
$tableIndent = 0
$factionIndent = 0
$subGroupIndent = 0
$bpIndent = 0

# Track indentation levels
$indentStack = @()

Write-Host "Parsing $totalLines lines..."

for ($i = 0; $i -lt $totalLines; $i++) {
    $line = $lines[$i]
    
    # Skip empty lines
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    
    $trimmed = $line.TrimStart()
    $indent = $line.Length - $trimmed.Length
    
    # Look for top-level table declarations
    if ($null -eq $insideTable) {
        foreach ($t in $targetTables) {
            if ($trimmed -match "^\[$([regex]::Escape($t))\] => \(table:") {
                $insideTable = $t
                $tableIndent = $indent
                Write-Host "Found table [$t] at line $($i+1), indent=$indent"
                break
            }
        }
        continue
    }
    
    # We're inside a target table
    # Check if we've exited the table (closing brace at table indent or less)
    if ($trimmed -eq "}" -and $indent -le $tableIndent) {
        Write-Host "Table [$insideTable] ended at line $($i+1)"
        $insideTable = $null
        $factionName = $null
        $subGroupName = $null
        continue
    }
    
    # Look for faction-level entries [FACTION_NAME] => (table:
    if ($trimmed -match '^\[(\w+)\] => \(table:' -and $indent -eq ($tableIndent + 4)) {
        $factionName = $matches[1]
        $factionIndent = $indent
        $subGroupName = $null
        if (-not $results[$insideTable].Contains($factionName)) {
            $results[$insideTable][$factionName] = [ordered]@{}
        }
        continue
    }
    
    # For unit_upgrades: look for sub-group entries like [AGE_DARK] => (table:
    if ($insideTable -eq "unit_upgrades" -and $null -ne $factionName) {
        if ($trimmed -match '^\[(\w+)\] => \(table:' -and $indent -gt $factionIndent) {
            $subGroupName = $matches[1]
            $subGroupIndent = $indent
            continue
        }
    }
    
    # Look for blueprint entries - expanded: [NAME] => (pbg _mt:
    if ($null -ne $factionName -and $trimmed -match '^\[(\w+)\] => \(pbg _mt:') {
        $bpName = $matches[1]
        $bpIndent = $indent
        # Next line should have PropertyBagGroupID
        continue
    }
    
    # Look for collapsed blueprint entries: [NAME] => <pbg _mt:
    if ($null -ne $factionName -and $trimmed -match '^\[(\w+)\] => <pbg _mt:') {
        $collapsedName = $matches[1]
        if ($insideTable -eq "unit_upgrades" -and $null -ne $subGroupName) {
            $key = "${subGroupName}/${collapsedName}"
            $results[$insideTable][$factionName][$key] = "(collapsed)"
        } else {
            $results[$insideTable][$factionName][$collapsedName] = "(collapsed)"
        }
        continue
    }
    
    # Look for PropertyBagGroupID
    if ($null -ne $bpName -and $trimmed -match '^\[PropertyBagGroupID\] => \(number\) (\d+)') {
        $pbgId = $matches[1]
        if ($insideTable -eq "unit_upgrades" -and $null -ne $subGroupName) {
            $key = "${subGroupName}/${bpName}"
            $results[$insideTable][$factionName][$key] = $pbgId
        } else {
            $results[$insideTable][$factionName][$bpName] = $pbgId
        }
        $bpName = $null
        continue
    }
    
    # Look for numbered entries in unit_upgrades: [1] => (pbg _mt:
    if ($insideTable -eq "unit_upgrades" -and $null -ne $subGroupName) {
        if ($trimmed -match '^\[(\d+)\] => \(pbg _mt:') {
            $bpName = "entry_$($matches[1])"
            continue
        }
        if ($trimmed -match '^\[(\d+)\] => <pbg _mt:') {
            $key = "${subGroupName}/entry_$($matches[1])"
            $results[$insideTable][$factionName][$key] = "(collapsed)"
            continue
        }
    }
    
    # Reset bpName if we hit a closing brace
    if ($trimmed -eq "}") {
        $bpName = $null
    }
}

# Output results
$outputPath = "c:\Users\Jordan\Documents\AoE4-Workspace\reference\blueprint-data.md"
$sb = [System.Text.StringBuilder]::new()

[void]$sb.AppendLine("# AoE4 Blueprint Data Reference")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("Extracted from ``Attributes dump.txt`` - organized by TABLE > FACTION > BLUEPRINT_NAME => PropertyBagGroupID")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("Legend: ``(collapsed)`` = referenced as ``<pbg>`` with no ID available in this dump")
[void]$sb.AppendLine("")

foreach ($table in $targetTables) {
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("## [$table]")
    [void]$sb.AppendLine("")
    
    if ($results[$table].Count -eq 0) {
        [void]$sb.AppendLine("*(No data found)*")
        [void]$sb.AppendLine("")
        continue
    }
    
    foreach ($faction in $results[$table].Keys) {
        if ($faction -eq "__skipsave") { continue }
        
        [void]$sb.AppendLine("### $faction")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("| Blueprint | PropertyBagGroupID |")
        [void]$sb.AppendLine("|-----------|-------------------|")
        
        $entries = $results[$table][$faction]
        foreach ($bp in $entries.Keys) {
            if ($bp -eq "__skipsave") { continue }
            $id = $entries[$bp]
            [void]$sb.AppendLine("| $bp | $id |")
        }
        [void]$sb.AppendLine("")
    }
}

# Write output
[System.IO.File]::WriteAllText($outputPath, $sb.ToString())
Write-Host ""
Write-Host "Output written to: $outputPath"
Write-Host ""

# Summary stats
foreach ($table in $targetTables) {
    $factionCount = ($results[$table].Keys | Where-Object { $_ -ne "__skipsave" }).Count
    $totalEntries = 0
    foreach ($f in $results[$table].Keys) {
        if ($f -ne "__skipsave") { $totalEntries += $results[$table][$f].Count }
    }
    Write-Host "[$table]: $factionCount factions, $totalEntries total entries"
}
