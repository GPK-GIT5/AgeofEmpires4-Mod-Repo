<#
.SYNOPSIS
    SCAR Blueprint Resolution Skill - Cache Management Helper
    
.DESCRIPTION
    PowerShell utility for managing the SQLite blueprint cache:
    - Validate cache health
    - Detect source file updates
    - Export cache statistics
    - Trigger cache reset
    - Monitor cache growth
    
.NOTES
    Author: Blueprint Skill Manager
    Version: 1.0
    Date: 2026-02-24
#>

param(
    [Parameter(ParameterSetName = "Status", Mandatory = $false)]
    [switch]$Status,
    
    [Parameter(ParameterSetName = "Check", Mandatory = $false)]
    [switch]$Check,
    
    [Parameter(ParameterSetName = "Reset", Mandatory = $false)]
    [switch]$Reset,
    
    [Parameter(ParameterSetName = "Export", Mandatory = $false)]
    [switch]$Export,
    
    [Parameter(ParameterSetName = "Monitor", Mandatory = $false)]
    [switch]$Monitor,
    
    [Parameter(ParameterSetName = "PostExtract", Mandatory = $false)]
    [switch]$PostExtract,
    
    [string]$SkillDir = "reference\.skill",
    [string]$DataDir = "data",
    [string]$OutputFile = $null
)

# ============================================================================
# CONSTANTS
# ============================================================================

$CacheDbPath = Join-Path $SkillDir "blueprints.db"
$CacheMetadataPath = Join-Path $SkillDir "cache-metadata.json"
$CacheExportPath = Join-Path $SkillDir "blueprint-cache-export.json"
$SourceFiles = @{
    "units"        = Join-Path $DataDir "units\all.json"
    "buildings"    = Join-Path $DataDir "buildings\all.json"
    "technologies" = Join-Path $DataDir "technologies\all.json"
}

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Test-CacheExists {
    <#
    .SYNOPSIS
        Check if cache database exists and is valid
    #>
    return (Test-Path $CacheDbPath) -and (Test-Path $CacheMetadataPath)
}

function Get-CacheMetadata {
    <#
    .SYNOPSIS
        Load cache metadata from JSON
    #>
    if (-not (Test-Path $CacheMetadataPath)) {
        Write-Host "    [WARN] Cache metadata not found" -ForegroundColor Yellow
        return $null
    }
    
    try {
        return Get-Content $CacheMetadataPath -Raw | ConvertFrom-Json
    }
    catch {
        Write-Host "    [ERROR] Failed to parse cache metadata: $_" -ForegroundColor Red
        return $null
    }
}

function Get-SourceFileTimestamps {
    <#
    .SYNOPSIS
        Get modification timestamps for source data files
    #>
    $timestamps = @{}
    
    foreach ($type in $SourceFiles.Keys) {
        $path = $SourceFiles[$type]
        if (Test-Path $path) {
            $item = Get-Item $path
            $timestamps[$type] = @{
                Path     = $path
                Modified = $item.LastWriteTime.ToString("o")
                Size     = "$([math]::Round($item.Length / 1MB, 2)) MB"
            }
        }
        else {
            $timestamps[$type] = @{
                Path     = $path
                Modified = "N/A"
                Size     = "N/A (file not found)"
            }
        }
    }
    
    return $timestamps
}

function Compare-CacheSourceTimestamps {
    <#
    .SYNOPSIS
        Compare cache metadata timestamps vs. actual source file timestamps
    #>
    $metadata = Get-CacheMetadata
    if (!$metadata) { return $null }
    
    $sourceTimestamps = Get-SourceFileTimestamps
    $comparison = @{}
    
    foreach ($type in $SourceFiles.Keys) {
        $cachedTime = [datetime]::Parse($metadata.source_timestamps.$type)
        $actualTime = if ($sourceTimestamps[$type].Modified -eq "N/A") { 
            [datetime]::MinValue 
        } 
        else { 
            [datetime]::Parse($sourceTimestamps[$type].Modified) 
        }
        
        $isStale = $actualTime -gt $cachedTime
        
        $comparison[$type] = @{
            CachedTime    = $cachedTime.ToString("o")
            ActualTime    = $actualTime.ToString("o")
            IsStale       = $isStale
            TimeDiff      = if ($isStale) { "SOURCE NEWER" } else { "In sync" }
        }
    }
    
    return $comparison
}

# ============================================================================
# COMMAND HANDLERS
# ============================================================================

function Show-CacheStatus {
    <#
    .SYNOPSIS
        Display current cache status and statistics
    #>
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║         SCAR Blueprint Resolution Skill - Cache Status     ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    if (-not (Test-CacheExists)) {
        Write-Host "  Status: NOT INITIALIZED" -ForegroundColor Red
        Write-Host "  Reason: Cache database or metadata file not found"
        Write-Host ""
        Write-Host "  Path: $CacheDbPath"
        Write-Host "  Path: $CacheMetadataPath"
        Write-Host ""
        Write-Host "  → Run 'Invoke-CacheReset' to initialize on first Skill call" -ForegroundColor Yellow
        return
    }
    
    $metadata = Get-CacheMetadata
    if (!$metadata) { return }
    
    # Database Status
    Write-Host "Database Status:" -ForegroundColor Green
    Write-Host "  Path: $CacheDbPath"
    Write-Host "  Size: $(if (Test-Path $CacheDbPath) { "$([math]::Round((Get-Item $CacheDbPath).Length / 1MB, 2)) MB" } else { 'N/A' })"
    Write-Host ""
    
    # Cache Statistics
    Write-Host "Cache Statistics:" -ForegroundColor Green
    Write-Host "  Total Entries: $($metadata.total_entries)"
    Write-Host "  ├─ Units: $($metadata.entry_breakdown.units)"
    Write-Host "  ├─ Buildings: $($metadata.entry_breakdown.buildings)"
    Write-Host "  └─ Technologies: $($metadata.entry_breakdown.technologies)"
    Write-Host ""
    
    # Performance Metrics
    Write-Host "Performance Metrics:" -ForegroundColor Green
    Write-Host "  Hit Rate: $(($metadata.cache_hit_rate * 100).ToString('F1'))%"
    Write-Host "  Total Hits: $($metadata.cache_hits)"
    Write-Host "  Total Misses: $($metadata.cache_misses)"
    Write-Host "  Avg Latency: $($metadata.avg_resolution_ms) ms"
    Write-Host ""
    
    # Timestamps
    Write-Host "Timestamps:" -ForegroundColor Green
    Write-Host "  Initialized: $($metadata.cache_init_date)"
    Write-Host "  Last Flush: $($metadata.last_flush)"
    Write-Host "  Last Stats: $($metadata.last_stats_export)"
    Write-Host ""
    
    # Cache Health
    Write-Host "Cache Health:" -ForegroundColor Green
    Write-Host "  Invalidated: $(if ($metadata.cache_invalidated) { 'YES (stale)' } else { 'NO' })"
    Write-Host "  Dirty Count: $($metadata.dirty_count)"
    Write-Host "  Schema Version: $($metadata.schema_version)"
    Write-Host ""
}

function Invoke-CacheHealthCheck {
    <#
    .SYNOPSIS
        Verify cache health and compare with source files
    #>
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║              Cache Health Check - Validation               ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    # Check cache existence
    Write-Host "1. Cache Existence Check:" -ForegroundColor Green
    if (Test-Path $CacheDbPath) {
        Write-Host "   ✓ Database exists: $CacheDbPath" -ForegroundColor Green
    }
    else {
        Write-Host "   ✗ Database missing: $CacheDbPath" -ForegroundColor Red
    }
    
    if (Test-Path $CacheMetadataPath) {
        Write-Host "   ✓ Metadata exists: $CacheMetadataPath" -ForegroundColor Green
    }
    else {
        Write-Host "   ✗ Metadata missing: $CacheMetadataPath" -ForegroundColor Red
    }
    Write-Host ""
    
    # Source file status
    Write-Host "2. Source File Status:" -ForegroundColor Green
    $sourceTimestamps = Get-SourceFileTimestamps
    foreach ($type in $sourceTimestamps.Keys) {
        $info = $sourceTimestamps[$type]
        $status = if ($info.Modified -eq "N/A") { "[MISSING]" } else { "[OK]" }
        Write-Host "   $status $type : $($info.Size) (Modified: $($info.Modified))"
    }
    Write-Host ""
    
    # Cache staleness check
    Write-Host "3. Cache Staleness Check:" -ForegroundColor Green
    if (Test-CacheExists) {
        $comparison = Compare-CacheSourceTimestamps
        $isAnyStale = $false
        
        foreach ($type in $comparison.Keys) {
            $info = $comparison[$type]
            $staleIcon = if ($info.IsStale) { "⚠" } else { "✓" }
            Write-Host "   $staleIcon $type : $($info.TimeDiff)"
            if ($info.IsStale) { $isAnyStale = $true }
        }
        
        Write-Host ""
        if ($isAnyStale) {
            Write-Host "   [ACTION REQUIRED] Cache is stale. Run cache update or reset." -ForegroundColor Yellow
        }
        else {
            Write-Host "   [OK] Cache is up-to-date with source files." -ForegroundColor Green
        }
    }
    else {
        Write-Host "   (Cache not initialized)" -ForegroundColor Gray
    }
    Write-Host ""
}

function Invoke-CacheReset {
    <#
    .SYNOPSIS
        Reset cache database and metadata (full invalidation)
    #>
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║                    CACHE RESET - WARNING                   ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "This will delete:" -ForegroundColor Red
    Write-Host "  1. SQLite database: $CacheDbPath"
    Write-Host "  2. Cache metadata: $CacheMetadataPath"
    Write-Host ""
    Write-Host "The cache will be reinitialized on the next Skill call." -ForegroundColor Yellow
    Write-Host ""
    
    $response = Read-Host "Proceed with cache reset? (y/N)"
    if ($response -ne "y" -and $response -ne "Y") {
        Write-Host "Cache reset cancelled." -ForegroundColor Green
        return
    }
    
    Write-Host ""
    Write-Host "Resetting cache..." -ForegroundColor Cyan
    
    # Delete cache files
    if (Test-Path $CacheDbPath) {
        Remove-Item $CacheDbPath -Force
        Write-Host "  ✓ Deleted database" -ForegroundColor Green
    }
    
    if (Test-Path $CacheMetadataPath) {
        Remove-Item $CacheMetadataPath -Force
        Write-Host "  ✓ Deleted metadata" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Cache reset complete. Next Skill initialization will rebuild." -ForegroundColor Green
    Write-Host ""
}

function Export-CacheStatistics {
    <#
    .SYNOPSIS
        Export cache statistics and metadata to JSON file
    #>
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                  Cache Statistics Export                   ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    if (-not (Test-CacheExists)) {
        Write-Host "Cache not initialized. No statistics to export." -ForegroundColor Yellow
        return
    }
    
    $metadata = Get-CacheMetadata
    $sourceTimestamps = Get-SourceFileTimestamps
    
    $exportData = @{
        ExportDate       = (Get-Date).ToString("o")
        CacheMetadata    = $metadata
        SourceTimestamps = $sourceTimestamps
        Comparison       = Compare-CacheSourceTimestamps
    }
    
    $outPath = $OutputFile ?? (Join-Path $SkillDir "cache-stats-export-$(Get-Date -Format 'yyyyMMdd-HHmmss').json")
    
    try {
        $exportData | ConvertTo-Json -Depth 5 | Set-Content $outPath
        Write-Host "✓ Statistics exported to: $outPath" -ForegroundColor Green
        Write-Host ""
        Write-Host "Summary:" -ForegroundColor Green
        Write-Host "  Total Cached: $($metadata.total_entries) entries"
        Write-Host "  Hit Rate: $(($metadata.cache_hit_rate * 100).ToString('F1'))%"
        Write-Host "  Database Size: $([math]::Round((Get-Item $CacheDbPath).Length / 1MB, 2)) MB"
    }
    catch {
        Write-Host "✗ Export failed: $_" -ForegroundColor Red
    }
    Write-Host ""
}

function Monitor-CacheGrowth {
    <#
    .SYNOPSIS
        Monitor cache growth over time (continuous polling)
    #>
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║               Cache Growth Monitor (Live)                  ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Polling every 5 seconds... Press Ctrl+C to stop." -ForegroundColor Yellow
    Write-Host ""
    
    $previousTotal = 0
    
    while ($true) {
        try {
            if (Test-CacheExists) {
                $metadata = Get-CacheMetadata
                $dbSize = if (Test-Path $CacheDbPath) { [math]::Round((Get-Item $CacheDbPath).Length / 1MB, 2) } else { 0 }
                $delta = $metadata.total_entries - $previousTotal
                $deltaIcon = if ($delta -gt 0) { "↑" } else { "→" }
                
                $timestamp = Get-Date -Format "HH:mm:ss"
                Write-Host "[$timestamp] Entries: $($metadata.total_entries) $deltaIcon | Hit Rate: $(($metadata.cache_hit_rate * 100).ToString('F1'))% | Size: ${dbSize}MB | Dirty: $($metadata.dirty_count)"
                
                $previousTotal = $metadata.total_entries
            }
            else {
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Cache not initialized" -ForegroundColor Gray
            }
            
            Start-Sleep -Seconds 5
        }
        catch {
            Write-Host "Error during monitoring: $_" -ForegroundColor Red
            Start-Sleep -Seconds 5
        }
    }
}

function Invoke-PostExtractionHook {
    <#
    .SYNOPSIS
        Post-extraction hook: detect source file updates and validate cache
    #>
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║        Post-Extraction Hook: Cache Validation              ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Checking source file modifications after extraction..." -ForegroundColor Green
    Write-Host ""
    
    $sourceTimestamps = Get-SourceFileTimestamps
    $sourceUpdated = @()
    
    foreach ($type in $sourceTimestamps.Keys) {
        $info = $sourceTimestamps[$type]
        if ($info.Modified -ne "N/A") {
            Write-Host "  [$type] Updated: $($info.Modified) | Size: $($info.Size)"
            $sourceUpdated += $type
        }
    }
    
    Write-Host ""
    
    if ($sourceUpdated.Count -gt 0 -and (Test-CacheExists)) {
        Write-Host "Source files detected as updated." -ForegroundColor Yellow
        $comparison = Compare-CacheSourceTimestamps
        
        Write-Host ""
        Write-Host "Cache Staleness Status:" -ForegroundColor Yellow
        $isStale = $false
        foreach ($type in $comparison.Keys) {
            $info = $comparison[$type]
            if ($info.IsStale) {
                Write-Host "  ⚠ $type : SOURCE NEWER (cache will be marked stale)" -ForegroundColor Yellow
                $isStale = $true
            }
            else {
                Write-Host "  ✓ $type : In sync" -ForegroundColor Green
            }
        }
        
        Write-Host ""
        if ($isStale) {
            Write-Host "Recommendation: Run 'Invoke-CacheReset' to rebuild cache on next Skill initialization." -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "No source updates detected or cache not initialized." -ForegroundColor Green
    }
    
    Write-Host ""
}

# ============================================================================
# MAIN ENTRYPOINT
# ============================================================================

if ($Status) {
    Show-CacheStatus
}
elseif ($Check) {
    Invoke-CacheHealthCheck
}
elseif ($Reset) {
    Invoke-CacheReset
}
elseif ($Export) {
    Export-CacheStatistics
}
elseif ($Monitor) {
    Monitor-CacheGrowth
}
elseif ($PostExtract) {
    Invoke-PostExtractionHook
}
else {
    Write-Host "SCAR Blueprint Resolution Skill - Cache Management Helper" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Green
    Write-Host "  .\manage-blueprint-cache.ps1 -Status          # Show cache status & statistics"
    Write-Host "  .\manage-blueprint-cache.ps1 -Check           # Health check & validation"
    Write-Host "  .\manage-blueprint-cache.ps1 -Reset           # Full cache reset (interactive)"
    Write-Host "  .\manage-blueprint-cache.ps1 -Export          # Export statistics to JSON"
    Write-Host "  .\manage-blueprint-cache.ps1 -Monitor         # Live cache growth monitor"
    Write-Host "  .\manage-blueprint-cache.ps1 -PostExtract     # Post-extraction hook"
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Green
    Write-Host "  -SkillDir <path>    Cache directory (default: reference\.skill)"
    Write-Host "  -DataDir <path>     Data directory (default: data)"
    Write-Host "  -OutputFile <path>  Export file path (for -Export)"
    Write-Host ""
}
