<#
.SYNOPSIS
    Master extraction script — runs all Phase 1 and Phase 2 extraction and batching.
.DESCRIPTION
    Run this once to regenerate all reference indexes and Claude batches.
    Phase 1: Extract functions, imports, objectives, groups, globals from all .scar files
    Phase 2: Generate mission-grouped batches with embedded prompts
.PARAMETER MaxBatchKB
    Maximum batch size in KB (default: 80)
.EXAMPLE
    .\run_all_extraction.ps1
    .\run_all_extraction.ps1 -MaxBatchKB 60
#>

param(
    [string]$WorkspaceRoot = "C:\Users\Jordan\Documents\AoE4-Workspace",
    [int]$MaxBatchKB = 80
)

$scriptDir = "$WorkspaceRoot\scripts"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  AoE4 SCAR Reference Extraction Pipeline" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Phase 1a: Function Index
Write-Host "[Phase 1a] Extracting function signatures..." -ForegroundColor Yellow
& "$scriptDir\extract_functions.ps1" -WorkspaceRoot $WorkspaceRoot
Write-Host ""

# Phase 1b: Imports, Objectives, Groups, Globals
Write-Host "[Phase 1b] Extracting imports, objectives, groups, globals..." -ForegroundColor Yellow
& "$scriptDir\extract_data.ps1" -WorkspaceRoot $WorkspaceRoot
Write-Host ""

# Phase 2: Batch Generation
Write-Host "[Phase 2] Generating mission-grouped batches (${MaxBatchKB}KB limit)..." -ForegroundColor Yellow
& "$scriptDir\generate_batches_v2.ps1" -WorkspaceRoot $WorkspaceRoot -MaxBatchBytes ($MaxBatchKB * 1024)
Write-Host ""

# Summary
Write-Host "============================================" -ForegroundColor Green
Write-Host "  Extraction Complete!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Generated artifacts:" -ForegroundColor White
Write-Host "  reference/function-index.csv    — All function signatures (CSV)" -ForegroundColor Gray
Write-Host "  reference/function-index.md     — All function signatures (Markdown)" -ForegroundColor Gray
Write-Host "  reference/imports-index.csv     — Import dependency graph" -ForegroundColor Gray
Write-Host "  reference/objectives-index.csv  — All OBJ_/SOBJ_ constants" -ForegroundColor Gray
Write-Host "  reference/groups-index.csv      — All SGroup/EGroup declarations" -ForegroundColor Gray
Write-Host "  reference/globals-index.csv     — Global variable assignments" -ForegroundColor Gray
Write-Host "  reference/data-index.md         — Combined dependency summary" -ForegroundColor Gray
Write-Host "  reference/dumps/Claude_Batches_v2/  — Batches for Claude processing" -ForegroundColor Gray
Write-Host ""
Write-Host "Next: Process batches through Claude using the workflow in:" -ForegroundColor Yellow
Write-Host "  reference/extraction-workflow.md" -ForegroundColor Yellow
