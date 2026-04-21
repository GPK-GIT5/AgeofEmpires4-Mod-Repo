param(
    [string]$RacesRoot = "C:/Users/Jordan/Documents/AOE4_Attributes/attrib/sbps/races",
    [string]$BuildingsJson = "C:/Users/Jordan/Documents/AoE4-Workspace/data/aoe4/data/buildings/all-optimized.json",
    [string]$OutCsv = "C:/Users/Jordan/Documents/AoE4-Workspace/references/indexes/villager-engineers-map.csv",
    [string]$OutMd = "C:/Users/Jordan/Documents/AoE4-Workspace/references/indexes/villager-engineers-map.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path $RacesRoot)) {
    throw "Races root not found: $RacesRoot"
}
if (-not (Test-Path $BuildingsJson)) {
    throw "Buildings dataset not found: $BuildingsJson"
}

$buildRoot = Get-Content $BuildingsJson -Raw | ConvertFrom-Json
$buildings = @($buildRoot.data)

# Build civ_code -> villager-buildable variation list.
$civToBuildings = @{}
foreach ($b in $buildings) {
    $producers = @()
    if ($b.PSObject.Properties.Name -contains "producedBy") {
        $producers = @($b.producedBy)
    }
    if (-not ($producers -contains "villager")) {
        continue
    }

    $variations = @()
    if ($b.PSObject.Properties.Name -contains "variations") {
        $variations = @($b.variations)
    }

    foreach ($v in $variations) {
        foreach ($code in @($v.civs)) {
            if (-not $civToBuildings.ContainsKey($code)) {
                $civToBuildings[$code] = @()
            }
            $civToBuildings[$code] += [pscustomobject]@{
                building_id   = $b.id
                building_name = $b.name
                variation_id  = $v.id
                attrib_name   = $v.attribName
                civ_code      = $code
            }
        }
    }
}

# Deduplicate civ->building mapping by attrib_name.
foreach ($code in @($civToBuildings.Keys)) {
    $civToBuildings[$code] = @(
        $civToBuildings[$code] |
            Sort-Object attrib_name -Unique
    )
}

# Inventory villager squad files across all race folders.
$villagerFiles = @()
$allRaceFolders = Get-ChildItem $RacesRoot -Directory | Sort-Object Name
foreach ($race in $allRaceFolders) {
    $files = @(Get-ChildItem $race.FullName -File -Filter "unit_villager_1*.rgd" | Sort-Object Name)
    if ($files.Count -eq 0) {
        $villagerFiles += [pscustomobject]@{
            race_folder    = $race.Name
            villager_squad = ""
            token_raw      = ""
            token_norm     = ""
            variant        = "no_villager"
        }
        continue
    }

    foreach ($f in $files) {
        $base = $f.BaseName
        $token = ""
        if ($base -eq "unit_villager_1") {
            $token = "core"
        } else {
            $token = $base.Substring("unit_villager_1_".Length)
        }

        $variant = "standard"
        if ($token -match "^nomad_") {
            $variant = "nomad"
        } elseif ($token -match "^double_") {
            $variant = "double"
        }

        $norm = $token -replace "^nomad_", "" -replace "^double_", ""

        $villagerFiles += [pscustomobject]@{
            race_folder    = $race.Name
            villager_squad = $f.Name
            token_raw      = $token
            token_norm     = $norm
            variant        = $variant
        }
    }
}

# Infer token->civ_code mapping from attrib_name suffixes.
$allVariations = @()
foreach ($code in @($civToBuildings.Keys)) {
    foreach ($entry in @($civToBuildings[$code])) {
        $allVariations += [pscustomobject]@{
            civ_code    = $code
            attrib_name = $entry.attrib_name
        }
    }
}

$tokenToCode = @{}
$tokensToInfer = @(
    $villagerFiles |
        Where-Object { $_.token_raw -and $_.token_raw -ne "core" } |
        ForEach-Object { $_.token_raw; $_.token_norm } |
        Where-Object { $_ } |
        Sort-Object -Unique
)

foreach ($token in $tokensToInfer) {
    $pattern = "_" + [regex]::Escape($token) + "$"
    $hits = @(
        $allVariations |
            Where-Object { $_.attrib_name -match $pattern } |
            Group-Object civ_code |
            Sort-Object Count -Descending
    )
    if ($hits.Count -gt 0) {
        $tokenToCode[$token] = $hits[0].Name
    }
}

# Build final rows for CSV/Markdown.
$rows = @()
foreach ($vf in $villagerFiles) {
    if ($vf.variant -eq "no_villager") {
        $rows += [pscustomobject]@{
            race_folder              = $vf.race_folder
            villager_squad           = ""
            variant                  = "no_villager"
            squad_engineers_ext      = "not_available"
            civ_code                 = ""
            buildings_count          = 0
            buildings_attrib_names   = ""
            buildings_ids            = ""
            source                   = "race folder has no unit_villager_1*.rgd"
        }
        continue
    }

    $code = ""
    if ($tokenToCode.ContainsKey($vf.token_raw)) {
        $code = $tokenToCode[$vf.token_raw]
    } elseif ($tokenToCode.ContainsKey($vf.token_norm)) {
        $code = $tokenToCode[$vf.token_norm]
    }

    $buildList = @()
    if ($code -and $civToBuildings.ContainsKey($code)) {
        $buildList = @($civToBuildings[$code])
    }

    $attribs = @($buildList | Select-Object -ExpandProperty attrib_name | Sort-Object -Unique)
    $ids = @($buildList | Select-Object -ExpandProperty building_id | Sort-Object -Unique)

    $source = "derived from all-optimized.json producedBy=villager; villager squad from external races .rgd"
    if (-not $code) {
        $source = "could not infer civ code from token"
    }

    $rows += [pscustomobject]@{
        race_folder              = $vf.race_folder
        villager_squad           = $vf.villager_squad
        variant                  = $vf.variant
        squad_engineers_ext      = "indirect (rgd decode unavailable in this environment)"
        civ_code                 = $code
        buildings_count          = $attribs.Count
        buildings_attrib_names   = ($attribs -join ";")
        buildings_ids            = ($ids -join ";")
        source                   = $source
    }
}

$rows = @($rows | Sort-Object race_folder, variant, villager_squad)

$csvDir = Split-Path $OutCsv -Parent
$mdDir = Split-Path $OutMd -Parent
if (-not (Test-Path $csvDir)) { New-Item -Path $csvDir -ItemType Directory | Out-Null }
if (-not (Test-Path $mdDir)) { New-Item -Path $mdDir -ItemType Directory | Out-Null }

$rows | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Villager squad_engineers_ext Mapping (Derived)")
$md.Add("")
$md.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$md.Add("")
$md.Add("Assumptions:")
$md.Add("- External villager squad files are binary .rgd and were not decoded directly in this environment.")
$md.Add("- Building lists are derived from all-optimized.json where producedBy includes villager.")
$md.Add("- Token-to-civ mapping is inferred from variation attrib_name suffixes.")
$md.Add("")
$md.Add("| race_folder | villager_squad | variant | civ_code | buildings_count | buildings_attrib_names |")
$md.Add("|---|---|---|---|---:|---|")
foreach ($r in $rows) {
    $attribCell = $r.buildings_attrib_names.Replace("|", "\\|")
    $md.Add("| $($r.race_folder) | $($r.villager_squad) | $($r.variant) | $($r.civ_code) | $($r.buildings_count) | $attribCell |")
}

Set-Content -Path $OutMd -Value $md -Encoding UTF8

"Wrote: $OutCsv"
"Wrote: $OutMd"
"Rows: $($rows.Count)"
"Mapped villager squads: $(@($rows | Where-Object { $_.villager_squad }).Count)"
"Unmapped civ_code rows: $(@($rows | Where-Object { $_.villager_squad -and -not $_.civ_code }).Count)"