<#
.SYNOPSIS
  Extracts structured reward tree data from Onslaught and Arena reward .scar files.

.DESCRIPTION
  Parses _CBA.rewards["civ"][threshold]={...} blocks and CBA_KILL_POINTS from:
    - cba_rewards_onslaught.scar (22 civs)
    - cba_rewards_arena.scar (Arena mode rewards)
    - cba_kill_scoring.scar (kill point tiers)
  Outputs CSV + markdown reference.

.PARAMETER Root
  Workspace root. Default: C:\Users\Jordan\Documents\AoE4-Workspace
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$ErrorActionPreference = 'Stop'
$rewardDir  = Join-Path $Root "Gamemodes\Onslaught\assets\scar\rewards"
$indexDir   = Join-Path $Root "references\indexes"
$modsDir    = Join-Path $Root "references\mods"
$timestamp  = Get-Date -Format "yyyy-MM-dd HH:mm"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Onslaught Reward Tree Extraction" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# =====================================================================
# 1. PARSE REWARD ENTRIES FROM ALL REWARD FILES
# =====================================================================
$rewardFiles = @(
    @{ Path = "cba_rewards_onslaught.scar"; Mode = "onslaught" },
    @{ Path = "cba_rewards_arena.scar";     Mode = "arena" }
)

$rewards = [System.Collections.Generic.List[PSCustomObject]]::new()

# Pattern: _CBA.rewards["civname"][threshold]={
$blockStartRx = [regex]::new('_CBA\.rewards\["([^"]+)"\]\[(\d+)\]\s*=\s*\{', 'Compiled')
# Disabled blocks inside --[[ ]] multiline comments
$commentOpenRx  = [regex]::new('--\[\[', 'Compiled')
$commentCloseRx = [regex]::new('\]\]', 'Compiled')
# Conditional wrapper: if AGS_GLOBAL_SETTINGS.Option_Reward_Age then
$condOpenRx = [regex]::new('if\s+AGS_GLOBAL_SETTINGS\.(\w+)\s+then', 'Compiled')

foreach ($rf in $rewardFiles) {
    $filePath = Join-Path $rewardDir $rf.Path
    if (-not (Test-Path $filePath)) {
        Write-Host "  SKIP: $($rf.Path) not found" -ForegroundColor Yellow
        continue
    }
    $lines = [System.IO.File]::ReadAllLines($filePath)
    $mode = $rf.Mode
    $inComment = $false
    $activeCondition = ""

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]

        # Track multiline comment blocks
        if ($commentOpenRx.IsMatch($line)) { $inComment = $true }
        if ($inComment) {
            if ($commentCloseRx.IsMatch($line)) { $inComment = $false }
            continue
        }

        # Track conditional wrapper
        $condMatch = $condOpenRx.Match($line)
        if ($condMatch.Success) {
            $activeCondition = $condMatch.Groups[1].Value
        }
        if ($line -match '^\s*end\s*$' -and $activeCondition) {
            $activeCondition = ""
        }

        # Match reward block start
        $bm = $blockStartRx.Match($line)
        if (-not $bm.Success) { continue }

        $civ = $bm.Groups[1].Value
        $threshold = [int]$bm.Groups[2].Value
        $condition = $activeCondition

        # Collect block lines until closing }
        $blockText = $line
        $j = $i + 1
        $braceDepth = 1
        while ($j -lt $lines.Count -and $braceDepth -gt 0) {
            $bl = $lines[$j]
            foreach ($ch in $bl.ToCharArray()) {
                if ($ch -eq '{') { $braceDepth++ }
                elseif ($ch -eq '}') { $braceDepth-- }
            }
            $blockText += "`n$bl"
            $j++
        }

        # Extract fields from block
        $title = ""; $rewardType = ""; $bpName = ""; $count = ""; $ageVal = ""

        if ($blockText -match 'title\s*=\s*"([^"]*)"') { $title = $Matches[1] }
        elseif ($blockText -match 'title\s*=\s*Loc_FormatText\(([^)]+)\)') { $title = "Loc:$($Matches[1].Trim())" }
        elseif ($blockText -match 'title\s*=\s*("\$[^"]+")') { $title = $Matches[1] }

        if ($blockText -match 'upgradeBP\s*=\s*"([^"]+)"') {
            $rewardType = "upgradeBP"; $bpName = $Matches[1]
        } elseif ($blockText -match 'upgrade\s*=\s*(\w+)') {
            $rewardType = "upgrade_const"; $bpName = $Matches[1]
        }
        if ($blockText -match 'unit\s*=\s*BP_GetSquadBlueprint\("([^"]+)"\)') {
            if ($rewardType) { $rewardType += "+unit" } else { $rewardType = "unit" }
            $bpName = if ($bpName) { "$bpName|$($Matches[1])" } else { $Matches[1] }
        }
        if ($blockText -match 'unit_upgrade\s*=\s*BP_GetSquadBlueprint\("([^"]+)"\)') {
            if ($rewardType) { $rewardType += "+unit_upgrade" } else { $rewardType = "unit_upgrade" }
            $bpName = if ($bpName) { "$bpName|$($Matches[1])" } else { $Matches[1] }
        }
        if ($blockText -match 'age\s*=\s*(\d+)') {
            if ($rewardType) { $rewardType += "+age" } else { $rewardType = "age" }
            $ageVal = $Matches[1]
        }
        if ($blockText -match 'num\s*=\s*(\d+)') { $count = $Matches[1] }
        if ($blockText -match 'num_upgrade\s*=\s*(\d+)') { $count = $Matches[1] }

        if (-not $rewardType) { $rewardType = "unknown" }

        $rewards.Add([PSCustomObject]@{
            Mode      = $mode
            Civ       = $civ
            Threshold = $threshold
            Type      = $rewardType
            Blueprint = $bpName
            Count     = $count
            Age       = $ageVal
            Condition = $condition
            Title     = $title
            File      = $rf.Path
            Line      = $i + 1
        })
    }
}

Write-Host "  Reward entries parsed: $($rewards.Count)" -ForegroundColor Green

# =====================================================================
# 2. PARSE KILL SCORING
# =====================================================================
$killScoring = [System.Collections.Generic.List[PSCustomObject]]::new()
$killFile = Join-Path $rewardDir "cba_kill_scoring.scar"
if (Test-Path $killFile) {
    $content = Get-Content $killFile -Raw
    $tierRx = [regex]::new('types\s*=\s*\{([^}]+)\}\s*,\s*points\s*=\s*(\d+)', 'Compiled')
    foreach ($m in $tierRx.Matches($content)) {
        $types = ($m.Groups[1].Value -replace '"','').Trim() -split '\s*,\s*'
        $points = [int]$m.Groups[2].Value
        $killScoring.Add([PSCustomObject]@{
            Types  = ($types -join ', ')
            Points = $points
        })
    }
}
Write-Host "  Kill scoring tiers: $($killScoring.Count)" -ForegroundColor Green

# =====================================================================
# 3. OUTPUT CSV
# =====================================================================
$csvPath = Join-Path $indexDir "onslaught-reward-trees.csv"
$csv = [System.Collections.Generic.List[string]]::new()
$csv.Add('"Mode","Civ","Threshold","Type","Blueprint","Count","Age","Condition","Title","File","Line"')
foreach ($r in ($rewards | Sort-Object Mode, Civ, Threshold)) {
    $safeTitle = $r.Title -replace '"','""'
    $csv.Add("`"$($r.Mode)`",`"$($r.Civ)`",`"$($r.Threshold)`",`"$($r.Type)`",`"$($r.Blueprint)`",`"$($r.Count)`",`"$($r.Age)`",`"$($r.Condition)`",`"$safeTitle`",`"$($r.File)`",`"$($r.Line)`"")
}
[System.IO.File]::WriteAllLines($csvPath, $csv)
Write-Host "  -> $csvPath ($($rewards.Count) rows)" -ForegroundColor Gray

# =====================================================================
# 4. OUTPUT MARKDOWN
# =====================================================================
$mdPath = Join-Path $modsDir "onslaught-reward-trees.md"
$md = [System.Text.StringBuilder]::new()
[void]$md.AppendLine("# Onslaught Reward Tree Reference")
[void]$md.AppendLine()
[void]$md.AppendLine("Auto-generated on $timestamp. Structured extraction of all kill-threshold rewards.")
[void]$md.AppendLine()

# Summary stats
$civCount = ($rewards | Select-Object -ExpandProperty Civ -Unique).Count
$onslaughtCount = ($rewards | Where-Object { $_.Mode -eq 'onslaught' }).Count
$arenaCount = ($rewards | Where-Object { $_.Mode -eq 'arena' }).Count
[void]$md.AppendLine("- **$($rewards.Count)** total reward entries across **$civCount** civilizations")
[void]$md.AppendLine("- **$onslaughtCount** Onslaught mode, **$arenaCount** Arena mode")
[void]$md.AppendLine("- **$($killScoring.Count)** kill scoring tiers")
[void]$md.AppendLine()

# Kill scoring table
[void]$md.AppendLine("## Kill Point Scoring")
[void]$md.AppendLine()
[void]$md.AppendLine("| Entity Types | Points |")
[void]$md.AppendLine("|-------------|--------|")
foreach ($ks in $killScoring) {
    [void]$md.AppendLine("| $($ks.Types) | $($ks.Points) |")
}
[void]$md.AppendLine()

# Per-civ reward type distribution
[void]$md.AppendLine("## Reward Distribution by Civilization")
[void]$md.AppendLine()
[void]$md.AppendLine("| Civ | Mode | Rewards | Max Threshold | Upgrades | Units | Ages |")
[void]$md.AppendLine("|-----|------|---------|---------------|----------|-------|------|")
foreach ($group in ($rewards | Group-Object Civ, Mode | Sort-Object Name)) {
    $parts = $group.Name -split ', '
    $civName = $parts[0]; $modeName = $parts[1]
    $entries = $group.Group
    $maxThresh = ($entries | Measure-Object -Property Threshold -Maximum).Maximum
    $upgradeCount = ($entries | Where-Object { $_.Type -match 'upgrade' }).Count
    $unitCount = ($entries | Where-Object { $_.Type -match 'unit' }).Count
    $ageCount = ($entries | Where-Object { $_.Type -match 'age' }).Count
    [void]$md.AppendLine("| $civName | $modeName | $($entries.Count) | $maxThresh | $upgradeCount | $unitCount | $ageCount |")
}
[void]$md.AppendLine()

# Top 10 highest thresholds
[void]$md.AppendLine("## Highest Kill Thresholds")
[void]$md.AppendLine()
[void]$md.AppendLine("| Civ | Mode | Threshold | Type | Blueprint |")
[void]$md.AppendLine("|-----|------|-----------|------|-----------|")
foreach ($r in ($rewards | Sort-Object Threshold -Descending | Select-Object -First 15)) {
    [void]$md.AppendLine("| $($r.Civ) | $($r.Mode) | $($r.Threshold) | $($r.Type) | ``$($r.Blueprint)`` |")
}
[void]$md.AppendLine()

[System.IO.File]::WriteAllText($mdPath, $md.ToString())
Write-Host "  -> $mdPath" -ForegroundColor Gray

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " Reward Tree Extraction Complete" -ForegroundColor Cyan
Write-Host "  Entries: $($rewards.Count) | Civs: $civCount | Kill tiers: $($killScoring.Count)" -ForegroundColor White
Write-Host "================================================================" -ForegroundColor Cyan
