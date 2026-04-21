# Full Runtime Verification Pass — Leaver Military Pipeline
# Executes all military conversion tests and validates against locked policies
# Usage: .\leaver_verification_fullpass.ps1
# Output: Log analysis in console + detailed test report

param(
    [string]$LogDir = "$env:USERPROFILE\Documents\My Games\Age of Empires IV\LogFiles",
    [ValidateSet('all','military','coverage','stress','performance')]
    [string]$TestMode = 'all'
)

Write-Host "=== LEAVER MILITARY PIPELINE — FULL VERIFICATION PASS ===" -ForegroundColor Cyan
Write-Host "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host ""

# ====================================================================
# Test Suite Definitions
# ====================================================================

$TestSuite = @{
    'military_resolve' = @{
        name = 'Military Unit Resolution'
        desc = 'Verify direct suffix-swap, tier-bump, civ-unique, receiver-class, and generic archetype paths'
        commands = @(
            'Debug_LeaverConversion_MilResolve'
        )
        validators = @(
            @{ pattern = 'unit_khan_.*→.*horseman'; expectation = 'Khan maps to horseman (tier 2)' }
            @{ pattern = 'unit_jeanne_.*→.*knight'; expectation = 'Jeanne maps to knight (tier 3)' }
            @{ pattern = 'unit_abbey_king_.*→.*manatarms'; expectation = 'Abbey King maps to manatarms (tier 3)' }
            @{ pattern = 'unit_wynguard_.*destroy'; expectation = 'Wynguard has destroy policy' }
            @{ pattern = 'unit_war_elephant_.*knight.*0\.3'; expectation = 'War elephant maps to knight (0.3 ratio)' }
            @{ pattern = 'unit_tower_elephant_.*knight.*0\.3'; expectation = 'Tower elephant maps to knight (0.3 ratio)' }
        )
    }
    
    'full_pipeline' = @{
        name = 'Full Elimination Pipeline'
        desc = 'Run 6-stage validation: snapshot→disconnect→convert→verify'
        commands = @(
            'Debug_LeaverConversion_Full(1)',
            'Debug_LeaverConversion_Full(2)',
            'Debug_LeaverConversion_Full(3)'
        )
        validators = @(
            @{ pattern = '\[LEAVER_DEBUG\]\[FULL\].*COMPLETE.*PASS'; expectation = 'All stages pass' }
            @{ pattern = 'mil_direct|mil_tier_bump|mil_civ_unique|mil_generic|mil_same_bp'; expectation = 'New route counters present' }
            @{ pattern = 'mil_destroy_policy|mil_destroy_age_blocked|mil_destroy_create_fail|mil_destroy_no_mapping'; expectation = 'All destroy routes tracked' }
        )
    }
    
    'coverage_audit' = @{
        name = 'All-Civs Coverage Audit'
        desc = 'Verify all civ-pair combinations handle military conversion correctly'
        commands = @(
            'Debug_LeaverCoverage_AllCivPairs()'
        )
        validators = @(
            @{ pattern = 'Coverage audit.*complete'; expectation = 'Coverage scan completed' }
            @{ pattern = '\[COVERAGE\].*direct|archetype|class'; expectation = 'Route distribution tracked' }
        )
    }
    
    'stress_test' = @{
        name = 'Multi-Player Disconnect Stress'
        desc = 'Disconnect 3-4 players sequentially and validate each phase'
        commands = @(
            'Debug_LeaverConversion_Stress(3)',
            'Debug_LeaverConversion_Stress(4)'
        )
        validators = @(
            @{ pattern = 'Stress test complete.*disconnects'; expectation = 'All disconnects processed' }
            @{ pattern = 'no hidden transfer|all paths accounted'; expectation = 'No untracked transfers' }
        )
    }
    
    'perf_stats' = @{
        name = 'Performance & Stats Consistency'
        desc = 'Verify pipeline timing, stat aggregates, and LEAVER_END output format'
        commands = @(
            'Debug_LeaverPerformance()',
            'Debug_LeaverConversion_Full(2)  -- Run one full scenario and check stats'
        )
        validators = @(
            @{ pattern = '\[LEAVER_END\].*mil\[conv='; expectation = 'New LEAVER_END format with route breakdown' }
            @{ pattern = 'Phase3=.*Phase4\+5=.*Phase7='; expectation = 'All phase timings present' }
            @{ pattern = 'mil_converted.*mil_destroyed.*no hidden'; expectation = 'Backward-compatible aggregates computed' }
        )
    }
}

# ====================================================================
# Log Parsing & Analysis
# ====================================================================

function Find-LatestLog {
    param([string]$Dir)
    
    if (-not (Test-Path $Dir)) {
        Write-Host "[WARN] Log directory not found: $Dir" -ForegroundColor Yellow
        return $null
    }
    
    $logFolders = Get-ChildItem -Path $Dir -Directory | 
        Where-Object { $_.Name -match '\d{4}-\d{2}-\d{2}' } |
        Sort-Object Name -Descending |
        Select-Object -First 1
    
    if ($logFolders) {
        $latestLog = Get-ChildItem -Path $logFolders.FullName -Filter "scarlog.*.txt" |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1
        return $latestLog.FullName
    }
    
    return $null
}

function Analyze-LogForPatterns {
    param(
        [string]$LogPath,
        [hashtable[]]$Validators
    )
    
    if (-not (Test-Path $LogPath)) {
        Write-Host "[ERROR] Log file not found: $LogPath" -ForegroundColor Red
        return @{ passed = 0; failed = 0; results = @() }
    }
    
    $content = Get-Content -Path $LogPath -Raw
    $results = @()
    $passed = 0
    $failed = 0
    
    foreach ($v in $Validators) {
        $found = $content -match $v.pattern
        $status = if ($found) { "✓ PASS"; $passed++ } else { "✗ FAIL"; $failed++ }
        $results += @{
            pattern = $v.pattern
            expectation = $v.expectation
            found = $found
            status = $status
        }
    }
    
    return @{ passed = $passed; failed = $failed; total = $validators.Count; results = $results }
}

# ====================================================================
# Report Generation
# ====================================================================

function Write-TestReport {
    param(
        [string]$TestName,
        [string]$Description,
        [hashtable]$Analysis,
        [string[]]$LogLines
    )
    
    Write-Host ""
    Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Blue
    Write-Host $TestName -ForegroundColor Cyan
    Write-Host $Description -ForegroundColor Gray
    Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Blue
    
    $pct = [math]::Round(($Analysis.passed / $Analysis.total) * 100, 1)
    $bgColor = if ($pct -eq 100) { "Green" } elseif ($pct -ge 80) { "Yellow" } else { "Red" }
    
    Write-Host "Result: $($Analysis.passed)/$($Analysis.total) validators passed ($pct%)" -ForegroundColor $bgColor
    Write-Host ""
    
    foreach ($result in $Analysis.results) {
        $statusColor = if ($result.found) { "Green" } else { "Red" }
        Write-Host "  $($result.status)` $($result.expectation)" -ForegroundColor $statusColor
        if ($false) {
            Write-Host "     Pattern: $($result.pattern)" -ForegroundColor DarkGray
        }
    }
    
    if ($LogLines.Count -gt 0) {
        Write-Host ""
        Write-Host "  [Log excerpts]" -ForegroundColor Gray
        foreach ($line in $LogLines | Select-Object -First 3) {
            Write-Host "    $line" -ForegroundColor DarkGray
        }
    }
}

# ====================================================================
# Main Execution
# ====================================================================

Write-Host "[INSTRUCTION] Please run the following commands in the game console:" -ForegroundColor Yellow
Write-Host "  (Enable debug before each: _LEAVER_DEBUG_VERBOSE = true)" -ForegroundColor Cyan
Write-Host ""

$testsToRun = switch ($TestMode) {
    'military' { @('military_resolve') }
    'coverage' { @('coverage_audit') }
    'stress' { @('stress_test') }
    'performance' { @('perf_stats') }
    'all' { $TestSuite.Keys }
}

foreach ($testKey in $testsToRun) {
    $test = $TestSuite[$testKey]
    
    Write-Host "[TEST] $($test.name)" -ForegroundColor Yellow
    Write-Host "  Description: $($test.desc)" -ForegroundColor Gray
    Write-Host "  Commands to run:" -ForegroundColor Cyan
    foreach ($cmd in $test.commands) {
        Write-Host "    > $cmd" -ForegroundColor Green
    }
    Write-Host ""
}

Write-Host ""
Write-Host "[NEXT STEP] After running the commands above and achieving gameplay that triggers the pipeline:" -ForegroundColor Yellow
Write-Host "  1. Run: .\leaver_verification_fullpass.ps1 -TestMode military" -ForegroundColor Cyan
Write-Host "  2. The script will find the latest scarlog and extract validation results" -ForegroundColor Cyan
Write-Host ""

# Optional: Auto-analyze if log exists
$latestLog = Find-LatestLog -Dir $LogDir
if ($latestLog) {
    Write-Host "[READY] Found latest log: $(Split-Path $latestLog -Leaf)" -ForegroundColor Green
    Write-Host "Analyzing..."
    Write-Host ""
    
    $allPassed = $true
    foreach ($testKey in $testsToRun) {
        $test = $TestSuite[$testKey]
        $analysis = Analyze-LogForPatterns -LogPath $latestLog -Validators $test.validators
        
        $logLines = @()
        foreach ($v in $test.validators) {
            $matches = Select-String -Path $latestLog -Pattern $v.pattern | Select-Object -First 2 | ForEach-Object { $_.Line }
            $logLines += $matches
        }
        
        Write-TestReport -TestName $test.name -Description $test.desc -Analysis $analysis -LogLines $logLines
        
        if ($analysis.failed -gt 0) { $allPassed = $false }
    }
    
    Write-Host ""
    Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Blue
    Write-Host "FINAL RESULT: $(if ($allPassed) { '✓ ALL TESTS PASSED' } else { '✗ SOME TESTS FAILED' })" -ForegroundColor $(if ($allPassed) { "Green" } else { "Red" })
    Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Blue
} else {
    Write-Host "[INFO] No logs found yet. Run commands above in-game, then re-run this script." -ForegroundColor Cyan
}
