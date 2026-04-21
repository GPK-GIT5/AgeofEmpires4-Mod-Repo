<#
.SYNOPSIS
  Extracts tier upgrade chains and unit→weapon linkage from the external EBP XML dump.
  Produces tier-chains.json and unit-weapon-linkage.json.

.DESCRIPTION
  Phase 1: Parse statetree_tier_* fields from all unit XMLs to build upgrade progression chains
  Phase 2: Parse non_entity_weapon_wrapper_pbg from all entities to build unit→weapon linkage

.PARAMETER ExternalDump
  Path to the external Gameplay_data_duplicate EBP races folder.
#>
param(
    [string]$ExternalDump = "C:\Users\Jordan\Documents\Gameplay_data_duplicate\assets\attrib\instances\ebps\races"
)

$ErrorActionPreference = 'Stop'
$root = "c:\Users\Jordan\Documents\AoE4-Workspace"
$canonRoot = Join-Path $root "data\aoe4\data\canonical"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Tier Chain & Weapon Linkage Extraction" -ForegroundColor Cyan
Write-Host " $timestamp" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan

# =====================================================================
# PHASE 1: Tier Upgrade Chains
# =====================================================================
Write-Host "`n--- PHASE 1: Tier Upgrade Chains ---" -ForegroundColor Yellow

$tierChains = @{}
$entityCount = 0
$chainCount = 0

Get-ChildItem $ExternalDump -Directory | ForEach-Object {
    $race = $_.Name
    Get-ChildItem $_.FullName -Recurse -Filter "*.xml" -File | ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        $baseName = [IO.Path]::GetFileNameWithoutExtension($_.Name)

        # Extract all tier upgrade target entities (non-empty only)
        $upgrades = [regex]::Matches($content, 'name="statetree_tier_requirements_pbg"\s+value="([^"]+)"')
        $targets = [regex]::Matches($content, 'name="statetree_tier_pgb_upgrade_target_entity"\s+value="([^"]+)"')
        $squads = [regex]::Matches($content, 'name="statetree_tier_pgb_upgrade_target_squad"\s+value="([^"]+)"')

        if ($targets.Count -gt 0) {
            $entityCount++
            # Build unique tier steps (dedup: same entity can repeat in multiple state trees)
            $steps = @{}
            for ($i = 0; $i -lt $targets.Count; $i++) {
                $targetEbp = $targets[$i].Groups[1].Value
                if ($targetEbp -and -not $steps.Contains($targetEbp)) {
                    $upgPbg = if ($i -lt $upgrades.Count) { $upgrades[$i].Groups[1].Value } else { "" }
                    $sqPbg = if ($i -lt $squads.Count) { $squads[$i].Groups[1].Value } else { "" }
                    $steps[$targetEbp] = [PSCustomObject]@{
                        upgradePbg   = $upgPbg
                        targetEntity = $targetEbp
                        targetSquad  = $sqPbg
                    }
                }
            }

            if ($steps.Count -gt 0) {
                $chainCount += $steps.Count
                $key = "$race/$baseName"
                $tierChains[$key] = [PSCustomObject]@{
                    entity   = $baseName
                    race     = $race
                    tiers    = @($steps.Values | Sort-Object { $_.targetEntity })
                    tierCount = $steps.Count
                }
            }
        }
    }
}

Write-Host "  Entities with tier chains: $entityCount" -ForegroundColor Green
Write-Host "  Total tier steps: $chainCount" -ForegroundColor Green

# Save tier-chains.json
$tierOutput = [PSCustomObject]@{
    _meta = [PSCustomObject]@{
        generated   = $timestamp
        description = "Tier upgrade chains extracted from EBP XML. Maps each entity to its upgrade progression (upgrade PBG → next-tier EBP + SBP)."
        entitiesWithChains = $entityCount
        totalTierSteps     = $chainCount
    }
    data = [ordered]@{}
}

foreach ($key in ($tierChains.Keys | Sort-Object)) {
    $tierOutput.data[$key] = $tierChains[$key]
}

$tierPath = Join-Path $canonRoot "tier-chains.json"
$tierOutput | ConvertTo-Json -Depth 10 | Set-Content -Path $tierPath -Encoding UTF8
Write-Host "  Saved: canonical/tier-chains.json" -ForegroundColor Green

# Per-race stats
$raceStats = $tierChains.Values | Group-Object race | Sort-Object Count -Descending
Write-Host "`n  Race breakdown:"
foreach ($r in $raceStats | Select-Object -First 15) {
    $steps = ($r.Group | Measure-Object -Property tierCount -Sum).Sum
    Write-Host "    $($r.Name): $($r.Count) entities, $steps steps"
}

# =====================================================================
# PHASE 2: Unit → Weapon EBP Linkage
# =====================================================================
Write-Host "`n--- PHASE 2: Unit → Weapon Linkage ---" -ForegroundColor Yellow

$weaponLinks = @{}
$linkedEntities = 0
$totalWeaponRefs = 0

Get-ChildItem $ExternalDump -Directory | ForEach-Object {
    $race = $_.Name
    Get-ChildItem $_.FullName -Recurse -Filter "*.xml" -File | ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        $baseName = [IO.Path]::GetFileNameWithoutExtension($_.Name)

        # Extract weapon blueprint references
        $weaponRefs = [regex]::Matches($content, 'name="non_entity_weapon_wrapper_pbg"\s+value="([^"]+)"')

        if ($weaponRefs.Count -gt 0) {
            $linkedEntities++
            $weapons = @()
            $seen = @{}
            foreach ($m in $weaponRefs) {
                $wpnPath = $m.Groups[1].Value
                if ($wpnPath -and -not $seen.Contains($wpnPath)) {
                    $seen[$wpnPath] = $true
                    $totalWeaponRefs++
                    # Extract weapon name from path
                    $wpnName = ($wpnPath -split '\\')[-1]
                    $weapons += [PSCustomObject]@{
                        weaponPath = $wpnPath
                        weaponName = $wpnName
                    }
                }
            }

            $key = "$race/$baseName"
            $weaponLinks[$key] = [PSCustomObject]@{
                entity      = $baseName
                race        = $race
                weapons     = $weapons
                weaponCount = $weapons.Count
            }
        }
    }
}

Write-Host "  Entities with weapon links: $linkedEntities" -ForegroundColor Green
Write-Host "  Unique weapon references: $totalWeaponRefs" -ForegroundColor Green

# Save unit-weapon-linkage.json
$wpnOutput = [PSCustomObject]@{
    _meta = [PSCustomObject]@{
        generated    = $timestamp
        description  = "Unit/building → weapon blueprint (WBP) linkage extracted from EBP XML. Maps entities to their equipped weapon blueprints via non_entity_weapon_wrapper_pbg."
        linkedEntities   = $linkedEntities
        uniqueWeaponRefs = $totalWeaponRefs
    }
    data = [ordered]@{}
}

foreach ($key in ($weaponLinks.Keys | Sort-Object)) {
    $wpnOutput.data[$key] = $weaponLinks[$key]
}

$wpnPath = Join-Path $canonRoot "unit-weapon-linkage.json"
$wpnOutput | ConvertTo-Json -Depth 10 | Set-Content -Path $wpnPath -Encoding UTF8
Write-Host "  Saved: canonical/unit-weapon-linkage.json" -ForegroundColor Green

# Weapon reference frequency analysis
Write-Host "`n  Top weapons by reference count:"
$allWpns = @{}
foreach ($entry in $weaponLinks.Values) {
    foreach ($w in $entry.weapons) {
        if (-not $allWpns.Contains($w.weaponName)) { $allWpns[$w.weaponName] = 0 }
        $allWpns[$w.weaponName]++
    }
}
$allWpns.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 15 | ForEach-Object {
    Write-Host "    $($_.Key): $($_.Value) refs"
}

# =====================================================================
# SUMMARY
# =====================================================================
Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " EXTRACTION COMPLETE" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Tier chains: $entityCount entities, $chainCount steps" -ForegroundColor White
Write-Host "  Weapon linkage: $linkedEntities entities, $totalWeaponRefs refs" -ForegroundColor White
