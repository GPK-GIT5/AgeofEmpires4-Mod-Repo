<#
.SYNOPSIS
  Cross-links inheritance-map, tier-chains, and unit-weapon-linkage into a unified
  entity lifecycle catalog. Produces entity-lifecycle.json.

.DESCRIPTION
  For each civ entity, merges:
  - Parent template + inherited defaults (from inheritance-map.json)
  - Tier upgrade chain (from tier-chains.json)
  - Equipped weapon blueprints (from unit-weapon-linkage.json)
  Into a single resolved view per entity.
#>

$ErrorActionPreference = 'Stop'
$root = "c:\Users\Jordan\Documents\AoE4-Workspace"
$canonRoot = Join-Path $root "data\aoe4\data\canonical"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " Entity Lifecycle Cross-Link" -ForegroundColor Cyan
Write-Host " $timestamp" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Cyan

# Load source catalogs
Write-Host "`n  Loading catalogs..." -ForegroundColor Gray

$inherit = (Get-Content (Join-Path $canonRoot "inheritance-map.json") -Raw | ConvertFrom-Json).data
$tiers = (Get-Content (Join-Path $canonRoot "tier-chains.json") -Raw | ConvertFrom-Json).data
$weapons = (Get-Content (Join-Path $canonRoot "unit-weapon-linkage.json") -Raw | ConvertFrom-Json).data

Write-Host "    Inheritance: $($inherit.Count) entities" -ForegroundColor Gray
Write-Host "    Tier chains: $($tiers.PSObject.Properties.Count) entries" -ForegroundColor Gray
Write-Host "    Weapon links: $($weapons.PSObject.Properties.Count) entries" -ForegroundColor Gray

# Build quick lookup tables
$tierByKey = @{}
foreach ($prop in $tiers.PSObject.Properties) {
    $tierByKey[$prop.Name] = $prop.Value
}

$wpnByKey = @{}
foreach ($prop in $weapons.PSObject.Properties) {
    $wpnByKey[$prop.Name] = $prop.Value
}

# Build lifecycle entries
Write-Host "`n  Cross-linking..." -ForegroundColor Yellow

$lifecycle = @()
$withTier = 0
$withWeapon = 0
$withBoth = 0
$withDefaults = 0

foreach ($entry in $inherit) {
    $key = "$($entry.race)/$($entry.entity)"

    $resolved = [ordered]@{
        entity        = $entry.entity
        race          = $entry.race
        category      = $entry.category
        pbgid         = $entry.pbgid
        parentPbg     = $entry.parentPbg
        parentIsCore  = $entry.parentIsCore
        overrideCount = $entry.overrideCount
    }

    # Merge parent defaults
    if ($entry.parentDefaults) {
        $resolved['parentDefaults'] = $entry.parentDefaults
        $withDefaults++
    }

    # Merge tier chain
    if ($tierByKey.ContainsKey($key)) {
        $tc = $tierByKey[$key]
        $resolved['tierChain'] = $tc.tiers
        $resolved['tierCount'] = $tc.tierCount
        $withTier++
    }

    # Merge weapon loadout
    if ($wpnByKey.ContainsKey($key)) {
        $wl = $wpnByKey[$key]
        $resolved['weapons'] = $wl.weapons
        $resolved['weaponCount'] = $wl.weaponCount
        $withWeapon++
    }

    if ($tierByKey.ContainsKey($key) -and $wpnByKey.ContainsKey($key)) {
        $withBoth++
    }

    $lifecycle += [PSCustomObject]$resolved
}

Write-Host "  Total entities: $($lifecycle.Count)" -ForegroundColor Green
Write-Host "    With parent defaults: $withDefaults" -ForegroundColor Gray
Write-Host "    With tier chain: $withTier" -ForegroundColor Gray
Write-Host "    With weapon loadout: $withWeapon" -ForegroundColor Gray
Write-Host "    With both tier + weapon: $withBoth" -ForegroundColor Gray

# Save entity-lifecycle.json
$output = [PSCustomObject]@{
    _meta = [PSCustomObject]@{
        generated      = $timestamp
        description    = "Unified entity lifecycle catalog. Cross-links inheritance (core template defaults), tier upgrade chains, and weapon loadout for every entity in the EBP XML dump."
        totalEntities  = $lifecycle.Count
        withDefaults   = $withDefaults
        withTierChain  = $withTier
        withWeapons    = $withWeapon
        withBoth       = $withBoth
        sources        = @("inheritance-map.json", "tier-chains.json", "unit-weapon-linkage.json")
    }
    data = $lifecycle
}

$outPath = Join-Path $canonRoot "entity-lifecycle.json"
$output | ConvertTo-Json -Depth 10 | Set-Content -Path $outPath -Encoding UTF8
$sizeKB = [math]::Round((Get-Item $outPath).Length / 1KB, 1)
Write-Host "  Saved: canonical/entity-lifecycle.json ($sizeKB KB)" -ForegroundColor Green

# Category summary
Write-Host "`n  Category breakdown:"
$lifecycle | Group-Object category | Sort-Object Count -Descending | Select-Object -First 10 | ForEach-Object {
    $wt = ($_.Group | Where-Object { $_.tierChain }).Count
    $ww = ($_.Group | Where-Object { $_.weapons }).Count
    Write-Host "    $($_.Name): $($_.Count) entities ($wt with tiers, $ww with weapons)"
}

# Race summary with enrichment rate
Write-Host "`n  Enrichment by race (top 15):"
$lifecycle | Group-Object race | Sort-Object Count -Descending | Select-Object -First 15 | ForEach-Object {
    $total = $_.Count
    $enriched = ($_.Group | Where-Object { $_.tierChain -or $_.weapons -or $_.parentDefaults }).Count
    $pct = [math]::Round($enriched / $total * 100, 0)
    Write-Host "    $($_.Name): $total entities, $enriched enriched ($pct%)"
}

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " CROSS-LINK COMPLETE" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
