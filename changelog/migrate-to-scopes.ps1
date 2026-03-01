# Migration Script: Split INDEX.jsonl into 3 Scopes
# Routes existing changelog entries into mods/, system/, and workspace/ scopes

$ErrorActionPreference = "Stop"

# Use PSScriptRoot directly since this script lives in changelog/
$changelogPath = $PSScriptRoot
$sourceFile = Join-Path $changelogPath "INDEX.jsonl"
$backupFile = Join-Path $changelogPath "INDEX.jsonl.backup"

# Target scope files
$modsFile = Join-Path $changelogPath "mods\INDEX.jsonl"
$systemFile = Join-Path $changelogPath "system\INDEX.jsonl"
$workspaceFile = Join-Path $changelogPath "workspace\INDEX.jsonl"

# Initialize empty scope files (creates if don't exist)
@($modsFile, $systemFile, $workspaceFile) | ForEach-Object {
    if (-not (Test-Path $_)) {
        New-Item -Path $_ -ItemType File -Force | Out-Null
    }
}

# Check source exists
if (-not (Test-Path $sourceFile)) {
    Write-Error "Source file not found: $sourceFile"
    exit 1
}

Write-Host "Starting migration..." -ForegroundColor Cyan
Write-Host "Source: $sourceFile" -ForegroundColor Gray

# Backup original
Copy-Item $sourceFile $backupFile -Force
Write-Host "✓ Backed up to: INDEX.jsonl.backup" -ForegroundColor Green

# Initialize counters
$modsCount = 0
$systemCount = 0
$workspaceCount = 0
$totalCount = 0

# Process each line
Get-Content $sourceFile | ForEach-Object {
    $line = $_.Trim()
    if ([string]::IsNullOrWhiteSpace($line)) { return }
    
    $totalCount++
    
    try {
        $entry = $_ | ConvertFrom-Json
        $filePath = $entry.file
        
        # Route by path pattern
        if ($filePath -match "^mods/") {
            Add-Content -Path $modsFile -Value $_
            $modsCount++
            Write-Host "  → mods: $filePath" -ForegroundColor Blue
        }
        elseif ($filePath -match "^changelog/") {
            Add-Content -Path $systemFile -Value $_
            $systemCount++
            Write-Host "  → system: $filePath" -ForegroundColor Yellow
        }
        else {
            Add-Content -Path $workspaceFile -Value $_
            $workspaceCount++
            Write-Host "  → workspace: $filePath" -ForegroundColor Magenta
        }
    }
    catch {
        Write-Warning "Failed to parse line: $_"
        Write-Warning "Error: $($_.Exception.Message)"
    }
}

# Report summary
Write-Host "`nMigration Complete!" -ForegroundColor Green
Write-Host "===================" -ForegroundColor Green
Write-Host "Total entries processed: $totalCount"
Write-Host "  Mods scope:      $modsCount → mods\INDEX.jsonl"
Write-Host "  System scope:    $systemCount → system\INDEX.jsonl"
Write-Host "  Workspace scope: $workspaceCount → workspace\INDEX.jsonl"
Write-Host "`nOriginal backed up as: INDEX.jsonl.backup"
Write-Host "Rollback command: Copy-Item INDEX.jsonl.backup INDEX.jsonl -Force"

# Clean up original INDEX.jsonl (backup preserved)
if (Test-Path $sourceFile) {
    Remove-Item $sourceFile -Force
    Write-Host "`n✓ Removed root INDEX.jsonl (backup preserved)" -ForegroundColor Green
}
