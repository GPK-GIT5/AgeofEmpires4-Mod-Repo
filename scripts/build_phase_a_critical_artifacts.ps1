<#
.SYNOPSIS
  Builds missing Phase A critical artifacts for completeness verification.

.DESCRIPTION
  Produces:
    - data/aoe4/data/canonical/attrib-archive-index.json
    - data/aoe4/data/canonical/data-archive-index.json
    - data/aoe4/data/canonical/xp3data-archive-index.json
    - data/aoe4/data/canonical/weapon-standalone-stats.json

  Archive index files are generated from Steam cardinal archive file metadata.
  Weapon standalone stats are derived from canonical weapon-catalog.json.
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace",
    [string]$ArchiveRoot = "C:\Program Files (x86)\Steam\steamapps\common\Age of Empires IV\cardinal\archives",
    [string]$CanonicalDir = "",
    [string]$WeaponCatalogPath = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($CanonicalDir)) {
    $CanonicalDir = Join-Path $Root "data\aoe4\data\canonical"
}
if ([string]::IsNullOrWhiteSpace($WeaponCatalogPath)) {
    $WeaponCatalogPath = Join-Path $CanonicalDir "weapon-catalog.json"
}

if (-not (Test-Path $CanonicalDir)) {
    New-Item -ItemType Directory -Path $CanonicalDir -Force | Out-Null
}

function Write-JsonFile {
    param(
        [Parameter(Mandatory = $true)]$Object,
        [Parameter(Mandatory = $true)][string]$Path
    )

    $Object | ConvertTo-Json -Depth 100 | Set-Content -Path $Path -Encoding UTF8
}

function Get-NumberStats {
    param([object[]]$Values)

    if ($null -eq $Values) {
        return [ordered]@{
            count = 0
            min = $null
            max = $null
            avg = $null
        }
    }

    $nums = @()
    foreach ($v in $Values) {
        if ($null -ne $v) {
            $nums += [double]$v
        }
    }

    if ($nums.Count -eq 0) {
        return [ordered]@{
            count = 0
            min = $null
            max = $null
            avg = $null
        }
    }

    $sum = 0.0
    foreach ($n in $nums) { $sum += $n }

    return [ordered]@{
        count = $nums.Count
        min = [math]::Round(($nums | Measure-Object -Minimum).Minimum, 4)
        max = [math]::Round(($nums | Measure-Object -Maximum).Maximum, 4)
        avg = [math]::Round(($sum / $nums.Count), 4)
    }
}

function Build-ArchiveDomainIndex {
    param(
        [Parameter(Mandatory = $true)][string]$Domain,
        [Parameter(Mandatory = $true)][string]$OutputFileName
    )

    $domainRegex = "^" + [regex]::Escape($Domain) + "(\.|$)"
    $domainFiles = @()

    if (Test-Path $ArchiveRoot) {
        $domainFiles = @(Get-ChildItem -Path $ArchiveRoot -File | Where-Object { $_.Name -match $domainRegex } | Sort-Object Name)
    }

    $entries = @()
    foreach ($f in $domainFiles) {
        $entries += [ordered]@{
            name = $f.Name
            sizeBytes = [int64]$f.Length
            sizeMB = [math]::Round(($f.Length / 1MB), 3)
            lastWriteTime = $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
            fullPath = $f.FullName
        }
    }

    $totalBytes = 0
    foreach ($f in $domainFiles) { $totalBytes += [int64]$f.Length }

    $index = [ordered]@{
        _meta = [ordered]@{
            generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            description = "Phase A archive-domain marker index"
            domain = $Domain
            sourceRoot = $ArchiveRoot
            sourceRootExists = (Test-Path $ArchiveRoot)
            fileCount = $domainFiles.Count
            totalBytes = [int64]$totalBytes
            totalMB = [math]::Round(($totalBytes / 1MB), 3)
        }
        files = $entries
    }

    $outputPath = Join-Path $CanonicalDir $OutputFileName
    Write-JsonFile -Object $index -Path $outputPath
    Write-Host ("[PhaseA] " + $Domain + " archive index: " + $domainFiles.Count + " file(s) -> " + $outputPath)
}

function Build-WeaponStandaloneStats {
    $outputPath = Join-Path $CanonicalDir "weapon-standalone-stats.json"

    if (-not (Test-Path $WeaponCatalogPath)) {
        $payload = [ordered]@{
            _meta = [ordered]@{
                generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                description = "Derived standalone weapon stats from weapon-catalog.json"
                sourcePath = $WeaponCatalogPath
                sourceExists = $false
                status = "missing_source"
                uniqueWeapons = 0
                totalProfiles = 0
            }
            data = @()
        }

        Write-JsonFile -Object $payload -Path $outputPath
        Write-Host ("[PhaseA] weapon standalone stats: source missing -> " + $outputPath)
        return
    }

    $catalog = Get-Content -Path $WeaponCatalogPath -Raw | ConvertFrom-Json
    $profiles = @()
    if ($null -ne $catalog.data) {
        $profiles = @($catalog.data)
    }

    $grouped = $profiles | Group-Object { ("" + $_.weaponName + "|" + $_.type) }
    $rows = @()

    foreach ($g in $grouped) {
        $items = @($g.Group)
        if ($items.Count -eq 0) { continue }

        $first = $items[0]
        $civs = @($items | ForEach-Object { $_.civ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)
        $ages = @($items | ForEach-Object { $_.age } | Where-Object { $null -ne $_ })
        $unitSources = @($items | ForEach-Object { $_.unitSource } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Sort-Object -Unique)

        $rangeMaxValues = @()
        $rangeMinValues = @()
        foreach ($it in $items) {
            if ($null -ne $it.range) {
                if ($null -ne $it.range.max) { $rangeMaxValues += [double]$it.range.max }
                if ($null -ne $it.range.min) { $rangeMinValues += [double]$it.range.min }
            }
        }

        $rows += [ordered]@{
            weaponName = $first.weaponName
            type = $first.type
            sampleCount = $items.Count
            civCount = $civs.Count
            civs = $civs
            age = [ordered]@{
                min = if ($ages.Count -gt 0) { ($ages | Measure-Object -Minimum).Minimum } else { $null }
                max = if ($ages.Count -gt 0) { ($ages | Measure-Object -Maximum).Maximum } else { $null }
            }
            damage = Get-NumberStats -Values @($items | ForEach-Object { $_.damage })
            speed = Get-NumberStats -Values @($items | ForEach-Object { $_.speed })
            rangeMin = Get-NumberStats -Values $rangeMinValues
            rangeMax = Get-NumberStats -Values $rangeMaxValues
            unitSourcesPreview = @($unitSources | Select-Object -First 8)
        }
    }

    $rows = @($rows | Sort-Object weaponName, type)

    $payload = [ordered]@{
        _meta = [ordered]@{
            generated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            description = "Derived standalone weapon stats from weapon-catalog.json"
            sourcePath = $WeaponCatalogPath
            sourceExists = $true
            status = "derived_from_weapon_catalog"
            totalProfiles = $profiles.Count
            uniqueWeapons = $rows.Count
        }
        data = $rows
    }

    Write-JsonFile -Object $payload -Path $outputPath
    Write-Host ("[PhaseA] weapon standalone stats: " + $rows.Count + " grouped weapon rows -> " + $outputPath)
}

Build-ArchiveDomainIndex -Domain "Attrib" -OutputFileName "attrib-archive-index.json"
Build-ArchiveDomainIndex -Domain "Data" -OutputFileName "data-archive-index.json"
Build-ArchiveDomainIndex -Domain "Xp3Data" -OutputFileName "xp3data-archive-index.json"
Build-WeaponStandaloneStats
