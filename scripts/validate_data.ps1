<#
.SYNOPSIS
    Validates canonical data against SCAR runtime expectations and reports gaps.
.DESCRIPTION
    Cross-references canonical JSON outputs against:
      - AGS_CIV_PREFIXES (24 civs) vs civs-index (23 civs)
      - Blueprint suffix patterns vs attribName patterns
      - Production chain completeness (every unit has a producer)
      - Upgrade chain continuity (no missing age tiers)
      - Alias collisions (display names resolving to multiple baseIds)
    Produces a structured markdown audit report.
.PARAMETER WorkspaceRoot
    Root of the AoE4 workspace.
#>

param(
    [string]$WorkspaceRoot = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$dataRoot     = "$WorkspaceRoot\data\aoe4\data"
$canonicalDir = "$dataRoot\canonical"
$auditDir     = "$WorkspaceRoot\references\audits"

if (-not (Test-Path $auditDir)) {
    New-Item -ItemType Directory -Path $auditDir -Force | Out-Null
}

Write-Host "[validate_data] Canonical: $canonicalDir"
Write-Host "[validate_data] Audit output: $auditDir"
Write-Host ""

# ─── Load Data ────────────────────────────────────────────────────────────────

function Load-Json {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        Write-Host "  [MISSING] $Path" -ForegroundColor Yellow
        return $null
    }
    return (Get-Content $Path -Raw -Encoding utf8 | ConvertFrom-Json)
}

$aliasMap   = Load-Json "$canonicalDir\alias-map.json"
$canonical  = Load-Json "$canonicalDir\canonical-units.json"
$upgrades   = Load-Json "$canonicalDir\upgrade-chains.json"
$production = Load-Json "$canonicalDir\production-graph.json"
$truth      = Load-Json "$canonicalDir\static-truth.json"
$civsIndex  = Load-Json "$dataRoot\civilizations\civs-index.json"

if (-not $canonical) {
    Write-Host "[ERROR] canonical-units.json not found. Run build_canonical_data.ps1 first." -ForegroundColor Red
    exit 1
}

# ─── SCAR CIV_PREFIXES reference ─────────────────────────────────────────────
# Hardcoded from ags_blueprints.scar — the SCAR-side truth for civ suffixes.
# 22 civs total: 10 base + 6 DLC variants (Sultans Ascend) + 6 DLC variants (Dynasties & Knights).
# The data source (civs-index.json) also has 22 civs — these should always match.

$scarCivPrefixes = @{
    "chinese"         = "chi_"
    "english"         = "eng_"
    "french"          = "fre_"
    "hre"             = "hre_"
    "mongol"          = "mon_"
    "rus"             = "rus_"
    "sultanate"       = "sul_"
    "abbasid"         = "abb_"
    "malian"          = "mal_"
    "ottoman"         = "ott_"
    "abbasid_ha_01"   = "abb_ha_01_"
    "chinese_ha_01"   = "chi_ha_01_"
    "french_ha_01"    = "fre_ha_01_"
    "hre_ha_01"       = "hre_ha_01_"
    "japanese"        = "jpn_"
    "byzantine"       = "byz_"
    "mongol_ha_gol"   = "mon_ha_gol_"
    "lancaster"       = "lan_"
    "templar"         = "tem_"
    "byzantine_ha_mac" = "byz_ha_mac_"
    "japanese_ha_sen" = "jpn_ha_sen_"
    "sultanate_ha_tug" = "sul_ha_tug_"
}

# Mapping from civs-index abbr -> scarCivPrefixes key (attribName field)
$abbrToAttrib = @{}
if ($civsIndex) {
    foreach ($prop in $civsIndex.PSObject.Properties) {
        $abbr = $prop.Name
        $info = $prop.Value
        if ($info.attribName) {
            $abbrToAttrib[$abbr] = $info.attribName
        }
    }
}

# ─── Audit 1: Civ Coverage ───────────────────────────────────────────────────

$report = [System.Text.StringBuilder]::new()
[void]$report.AppendLine("# Data Pipeline Audit Report")
[void]$report.AppendLine("")
[void]$report.AppendLine("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$report.AppendLine("")

[void]$report.AppendLine("## 1. Civ Coverage")
[void]$report.AppendLine("")
[void]$report.AppendLine("| SCAR attribName | SCAR Prefix | Data abbr | Status |")
[void]$report.AppendLine("|---|---|---|---|")

$scarOnly = @()
$dataOnly = @()

foreach ($kv in ($scarCivPrefixes.GetEnumerator() | Sort-Object Key)) {
    $attrib = $kv.Key
    $prefix = $kv.Value
    $matchAbbr = ($abbrToAttrib.GetEnumerator() | Where-Object { $_.Value -eq $attrib } | Select-Object -First 1)
    if ($matchAbbr) {
        [void]$report.AppendLine("| $attrib | $prefix | $($matchAbbr.Key) | OK |")
    } else {
        [void]$report.AppendLine("| $attrib | $prefix | — | **SCAR only** |")
        $scarOnly += $attrib
    }
}

foreach ($kv in ($abbrToAttrib.GetEnumerator() | Sort-Object Key)) {
    if (-not $scarCivPrefixes.ContainsKey($kv.Value)) {
        [void]$report.AppendLine("| $($kv.Value) | — | $($kv.Key) | **Data only** |")
        $dataOnly += $kv.Key
    }
}

[void]$report.AppendLine("")
if ($scarOnly.Count -gt 0) {
    [void]$report.AppendLine("**SCAR-only civs** (no data match): $($scarOnly -join ', ')")
}
if ($dataOnly.Count -gt 0) {
    [void]$report.AppendLine("**Data-only civs** (no SCAR match): $($dataOnly -join ', ')")
}
if ($scarOnly.Count -eq 0 -and $dataOnly.Count -eq 0) {
    [void]$report.AppendLine("All civs matched between SCAR and data sources.")
}
[void]$report.AppendLine("")

# ─── Audit 2: Production Completeness ────────────────────────────────────────

[void]$report.AppendLine("## 2. Production Completeness")
[void]$report.AppendLine("")

$unitsWithoutProducer = @()
if ($canonical.data) {
    foreach ($unit in $canonical.data) {
        if (-not $unit.producedBy -or $unit.producedBy.Count -eq 0) {
            $unitsWithoutProducer += $unit.baseId
        }
    }
}

if ($unitsWithoutProducer.Count -gt 0) {
    [void]$report.AppendLine("**Units with no producer:** $($unitsWithoutProducer.Count)")
    [void]$report.AppendLine("")
    [void]$report.AppendLine("| baseId | Name |")
    [void]$report.AppendLine("|---|---|")
    foreach ($uid in ($unitsWithoutProducer | Sort-Object)) {
        $match = $canonical.data | Where-Object { $_.baseId -eq $uid } | Select-Object -First 1
        $name = if ($match) { $match.name } else { "?" }
        [void]$report.AppendLine("| $uid | $name |")
    }
} else {
    [void]$report.AppendLine("All units have at least one producer.")
}
[void]$report.AppendLine("")

# ─── Audit 3: Upgrade Chain Continuity ───────────────────────────────────────

[void]$report.AppendLine("## 3. Upgrade Chain Continuity")
[void]$report.AppendLine("")

$gapUnits = @()
if ($upgrades -and $upgrades.data) {
    foreach ($chain in $upgrades.data) {
        if ($chain.tierCount -lt 2) { continue }
        $ages = @($chain.tiers | ForEach-Object { $_.age } | Sort-Object)
        for ($i = 1; $i -lt $ages.Count; $i++) {
            $gap = $ages[$i] - $ages[$i - 1]
            if ($gap -gt 1) {
                $gapUnits += @{
                    baseId = $chain.baseId
                    name   = $chain.name
                    gap    = "Age $($ages[$i-1]) -> $($ages[$i])"
                }
            }
        }
    }
}

if ($gapUnits.Count -gt 0) {
    [void]$report.AppendLine("**Units with age gaps:** $($gapUnits.Count)")
    [void]$report.AppendLine("")
    [void]$report.AppendLine("| baseId | Name | Gap |")
    [void]$report.AppendLine("|---|---|---|")
    foreach ($g in $gapUnits) {
        [void]$report.AppendLine("| $($g.baseId) | $($g.name) | $($g.gap) |")
    }
} else {
    [void]$report.AppendLine("No age-tier gaps found in upgrade chains.")
}
[void]$report.AppendLine("")

# ─── Audit 4: Alias Collisions ───────────────────────────────────────────────

[void]$report.AppendLine("## 4. Alias Collisions (Display Name)")
[void]$report.AppendLine("")

$collisions = @()
if ($aliasMap -and $aliasMap.byDisplayName) {
    foreach ($prop in $aliasMap.byDisplayName.PSObject.Properties) {
        $name = $prop.Name
        $ids = @($prop.Value)
        if ($ids.Count -gt 1) {
            $collisions += @{ name = $name; baseIds = ($ids -join ", ") }
        }
    }
}

if ($collisions.Count -gt 0) {
    [void]$report.AppendLine("**Collisions:** $($collisions.Count) display names map to multiple baseIds")
    [void]$report.AppendLine("")
    [void]$report.AppendLine("| Display Name | Base IDs |")
    [void]$report.AppendLine("|---|---|")
    foreach ($c in ($collisions | Sort-Object { $_.name })) {
        [void]$report.AppendLine("| $($c.name) | $($c.baseIds) |")
    }
} else {
    [void]$report.AppendLine("No display name collisions found.")
}
[void]$report.AppendLine("")

# ─── Audit 5: Runtime Truth Conflicts ────────────────────────────────────────

[void]$report.AppendLine("## 5. Static Truth Conflicts (behavior-derived, not live runtime)")
[void]$report.AppendLine("")

if ($truth -and $truth.data) {
    $withConflicts = @($truth.data | Where-Object { $_.conflictCount -gt 0 })
    if ($withConflicts.Count -gt 0) {
        [void]$report.AppendLine("**Units with conflicts:** $($withConflicts.Count) / $($truth._meta.totalChecked)")
        [void]$report.AppendLine("")
        [void]$report.AppendLine("| baseId | Name | Type | Detail |")
        [void]$report.AppendLine("|---|---|---|---|")
        foreach ($u in $withConflicts) {
            foreach ($c in $u.conflicts) {
                [void]$report.AppendLine("| $($u.baseId) | $($u.name) | $($c.type) | $($c.detail) |")
            }
        }
    } else {
        [void]$report.AppendLine("No runtime truth conflicts found.")
    }
} else {
    [void]$report.AppendLine("Static truth data not available. Run ``build_canonical_data.ps1 -Stages truth`` first.")
}
[void]$report.AppendLine("")

# ─── Audit 6: Summary Stats ──────────────────────────────────────────────────

[void]$report.AppendLine("## 6. Summary")
[void]$report.AppendLine("")
[void]$report.AppendLine("| Metric | Value |")
[void]$report.AppendLine("|---|---|")

$unitCount = if ($canonical.data) { $canonical.data.Count } else { 0 }
$varCount = if ($aliasMap -and $aliasMap._meta) { $aliasMap._meta.variationCount } else { "?" }
$prodCount = if ($production -and $production.data) { $production.data.Count } else { "?" }
$chainCount = if ($upgrades -and $upgrades.data) { $upgrades.data.Count } else { "?" }

[void]$report.AppendLine("| Canonical units (baseIds) | $unitCount |")
[void]$report.AppendLine("| Total variations | $varCount |")
[void]$report.AppendLine("| Producers | $prodCount |")
[void]$report.AppendLine("| Upgrade chains | $chainCount |")
[void]$report.AppendLine("| SCAR civs (AGS_CIV_PREFIXES) | $($scarCivPrefixes.Count) |")
[void]$report.AppendLine("| Data civs (civs-index) | $($abbrToAttrib.Count) |")
[void]$report.AppendLine("| Units without producer | $($unitsWithoutProducer.Count) |")
[void]$report.AppendLine("| Age-tier gaps | $($gapUnits.Count) |")
[void]$report.AppendLine("| Display name collisions | $($collisions.Count) |")

$conflictCount = 0
if ($truth -and $truth.data) {
    $conflictCount = @($truth.data | Where-Object { $_.conflictCount -gt 0 }).Count
}
[void]$report.AppendLine("| Static truth conflicts | $conflictCount |")
[void]$report.AppendLine("")

# ─── Write Report ─────────────────────────────────────────────────────────────

$reportPath = "$auditDir\pipeline-audit.md"
$report.ToString() | Set-Content $reportPath -Encoding utf8
$size = (Get-Item $reportPath).Length
Write-Host "[validate_data] Report: $reportPath ($([math]::Round($size/1024,1)) KB)"
Write-Host "[validate_data] Done."
