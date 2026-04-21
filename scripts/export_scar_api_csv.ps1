<#
.SYNOPSIS
  Converts parsed scardocs JSON into CSV indexes for machine consumption.

.DESCRIPTION
  Reads data/aoe4/scardocs/parsed_functions.json and parsed_constants.json
  and outputs flat CSV files for SCAR engine API function signatures and constants.

.PARAMETER Root
  Workspace root. Default: C:\Users\Jordan\Documents\AoE4-Workspace
#>
param(
    [string]$Root = "C:\Users\Jordan\Documents\AoE4-Workspace"
)

$ErrorActionPreference = 'Stop'
$scardocs = Join-Path $Root "data\aoe4\scardocs"
$indexDir = Join-Path $Root "references\indexes"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host " SCAR Engine API CSV Export" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# =====================================================================
# 1. FUNCTION SIGNATURES CSV
# =====================================================================
$funcPath = Join-Path $scardocs "parsed_functions.json"
if (Test-Path $funcPath) {
    $funcs = Get-Content $funcPath -Raw | ConvertFrom-Json
    $csv = [System.Collections.Generic.List[string]]::new()
    $csv.Add('"Name","Namespace","ParamRaw","Description"')
    foreach ($f in ($funcs | Sort-Object namespace, name)) {
        $safeName = $f.name
        $safeNs   = $f.namespace
        $safeDesc = ($f.description -replace '"','""' -replace '[\r\n]+',' ').Trim()
        $safeParams = ($f.paramRaw -replace '"','""').Trim()
        $csv.Add("`"$safeName`",`"$safeNs`",`"$safeParams`",`"$safeDesc`"")
    }
    $csvOutPath = Join-Path $indexDir "scar-engine-functions.csv"
    [System.IO.File]::WriteAllLines($csvOutPath, $csv)
    Write-Host "  Functions: $($funcs.Count) -> $csvOutPath" -ForegroundColor Green
} else {
    Write-Host "  SKIP: parsed_functions.json not found" -ForegroundColor Yellow
}

# =====================================================================
# 2. CONSTANTS CSV
# =====================================================================
$constPath = Join-Path $scardocs "parsed_constants.json"
if (Test-Path $constPath) {
    $consts = Get-Content $constPath -Raw | ConvertFrom-Json
    $csv = [System.Collections.Generic.List[string]]::new()
    $csv.Add('"Category","Constant"')
    $totalConsts = 0
    $categories = 0
    foreach ($prop in ($consts.PSObject.Properties | Sort-Object Name)) {
        $category = $prop.Name
        $categories++
        foreach ($val in $prop.Value) {
            $csv.Add("`"$category`",`"$val`"")
            $totalConsts++
        }
    }
    $csvOutPath = Join-Path $indexDir "scar-engine-constants.csv"
    [System.IO.File]::WriteAllLines($csvOutPath, $csv)
    Write-Host "  Constants: $totalConsts across $categories categories -> $csvOutPath" -ForegroundColor Green
} else {
    Write-Host "  SKIP: parsed_constants.json not found" -ForegroundColor Yellow
}

# =====================================================================
# 3. NAMESPACE SUMMARY
# =====================================================================
if (Test-Path $funcPath) {
    $nsSummary = $funcs | Group-Object namespace | Sort-Object Count -Descending
    Write-Host "`n  Top namespaces:" -ForegroundColor Gray
    foreach ($ns in ($nsSummary | Select-Object -First 15)) {
        Write-Host "    $($ns.Name): $($ns.Count)" -ForegroundColor Gray
    }
}

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host " SCAR Engine API Export Complete" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
