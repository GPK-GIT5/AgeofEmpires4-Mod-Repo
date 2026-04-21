#!/usr/bin/env pwsh
<#
.SYNOPSIS
Validates and auto-fixes markdown link paths in references/navigation/master-index.md.

.DESCRIPTION
Parses every markdown link [text](target) in master-index.md, resolves each target
relative to the navigation/ folder, and checks whether the target exists on disk.
Broken links are auto-fixed by searching known reference locations for a match.

Integrates with the repo lint pipeline: same Write-Check output format, exit 0/1.

.PARAMETER Fix
Apply fixes to the file. Without this flag, runs in dry-run mode (report only).

.EXAMPLE
./scripts/fix_master_index_links.ps1          # Dry-run: report only
./scripts/fix_master_index_links.ps1 -Fix     # Apply fixes in-place

.NOTES
Run from workspace root. Expects references/navigation/master-index.md to exist.
#>

param(
    [switch]$Fix
)

$ErrorActionPreference = 'Stop'

$pass = 0; $fail = 0; $warn = 0; $fixed = 0

function Write-Check {
    param(
        [ValidateSet('PASS','FAIL','WARN','FIX')]
        [string]$Status,
        [string]$Message
    )
    $color = switch ($Status) { 'PASS' { 'Green' } 'FAIL' { 'Red' } 'WARN' { 'Yellow' } 'FIX' { 'Cyan' } }
    Write-Host "[$Status] $Message" -ForegroundColor $color
    switch ($Status) { 'PASS' { $script:pass++ } 'FAIL' { $script:fail++ } 'WARN' { $script:warn++ } 'FIX' { $script:fixed++ } }
}

# ── Paths ─────────────────────────────────────────────────────────────────
$targetFile = 'references/navigation/master-index.md'

if (-not (Test-Path $targetFile)) {
    Write-Host "[FAIL] $targetFile not found — run from workspace root" -ForegroundColor Red
    exit 1
}

$navDir   = (Resolve-Path 'references/navigation').Path
$refDir   = (Resolve-Path 'references').Path
$repoRoot = (Resolve-Path '.').Path

# ── Known search roots (order = preference) ───────────────────────────────
# For a broken link "foo/bar.md", we search these directories for "foo/bar.md".
$searchRoots = @(
    @{ Base = $refDir;   Prefix = '../' },
    @{ Base = $repoRoot; Prefix = '../../' }
)

Write-Host ""
Write-Host "=== MASTER-INDEX LINK VALIDATOR ===" -ForegroundColor Cyan
if (-not $Fix) { Write-Host "(dry-run mode — use -Fix to apply changes)" -ForegroundColor Yellow }
Write-Host ""

# ── Parse links ───────────────────────────────────────────────────────────
$lines = Get-Content $targetFile
$linkPattern = '\[([^\]]*)\]\(([^)]+)\)'

$totalLinks = 0
$brokenLinks = @()

for ($i = 0; $i -lt $lines.Count; $i++) {
    $lineNum = $i + 1
    $line = $lines[$i]

    foreach ($match in [regex]::Matches($line, $linkPattern)) {
        $totalLinks++
        $displayText = $match.Groups[1].Value
        $rawTarget   = $match.Groups[2].Value

        # Skip external links and anchors
        if ($rawTarget -match '^https?://' -or $rawTarget -match '^#') { continue }

        # Resolve against navigation/ dir
        $absTarget = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($navDir, $rawTarget))

        if (Test-Path $absTarget) {
            # Link resolves — all good
            continue
        }

        # ── Broken: try to find the correct path ─────────────────────────
        # Strip any leading ../ segments to get the "bare" relative tail
        $tail = $rawTarget -replace '^(\.\./)+', ''

        $foundFix = $null

        foreach ($root in $searchRoots) {
            $candidate = Join-Path $root.Base $tail
            if (Test-Path $candidate) {
                $foundFix = $root.Prefix + $tail
                break
            }
        }

        # Fallback: search by filename across known roots
        if (-not $foundFix) {
            $fileName = [System.IO.Path]::GetFileName($tail)
            foreach ($root in $searchRoots) {
                $found = Get-ChildItem -Path $root.Base -Filter $fileName -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($found) {
                    $relFromRoot = $found.FullName.Substring($root.Base.Length + 1) -replace '\\', '/'
                    $foundFix = $root.Prefix + $relFromRoot
                    break
                }
            }
        }

        if ($foundFix) {
            $brokenLinks += @{
                Line        = $lineNum
                Display     = $displayText
                OldTarget   = $rawTarget
                NewTarget   = $foundFix
                Fixable     = $true
            }
        } else {
            $brokenLinks += @{
                Line        = $lineNum
                Display     = $displayText
                OldTarget   = $rawTarget
                NewTarget   = $null
                Fixable     = $false
            }
        }
    }
}

# ── Report ────────────────────────────────────────────────────────────────
Write-Host "Scanned $totalLinks links in $targetFile" -ForegroundColor Cyan
Write-Host ""

if ($brokenLinks.Count -eq 0) {
    Write-Check 'PASS' "All $totalLinks links resolve correctly"
} else {
    foreach ($b in $brokenLinks) {
        if ($b.Fixable) {
            if ($Fix) {
                # Apply the fix: replace this exact link occurrence on this line
                $oldFragment = "]($($b.OldTarget))"
                $newFragment = "]($($b.NewTarget))"
                $lines[$b.Line - 1] = $lines[$b.Line - 1].Replace($oldFragment, $newFragment)
                Write-Check 'FIX' "L$($b.Line): $($b.OldTarget) -> $($b.NewTarget)"
            } else {
                Write-Check 'FAIL' "L$($b.Line): $($b.OldTarget) -> would fix to $($b.NewTarget)"
            }
        } else {
            Write-Check 'FAIL' "L$($b.Line): $($b.OldTarget) — no matching file found on disk"
        }
    }
}

# ── Write fixes ───────────────────────────────────────────────────────────
if ($Fix -and $fixed -gt 0) {
    $lines | Set-Content $targetFile
    Write-Host ""
    Write-Check 'PASS' "Wrote $fixed fixes to $targetFile"
}

# ── Summary ───────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=== SUMMARY ===" -ForegroundColor Cyan

$unfixable = @($brokenLinks | Where-Object { -not $_.Fixable }).Count
$stats = "Total: $totalLinks | OK: $($totalLinks - $brokenLinks.Count) | Broken: $($brokenLinks.Count)"
if ($Fix) {
    $stats += " | Fixed: $fixed | Unfixable: $unfixable"
} else {
    $fixable = @($brokenLinks | Where-Object { $_.Fixable }).Count
    $stats += " | Fixable: $fixable | Unfixable: $unfixable"
}
Write-Host $stats -ForegroundColor Cyan

Write-Host ""
if ($brokenLinks.Count -eq 0) {
    Write-Host "[PASS] MASTER-INDEX LINKS OK" -ForegroundColor Green
    exit 0
} elseif ($Fix -and $unfixable -eq 0) {
    Write-Host "[PASS] ALL BROKEN LINKS FIXED" -ForegroundColor Green
    exit 0
} else {
    if ($Fix) {
        Write-Host "[FAIL] $unfixable links could not be auto-fixed" -ForegroundColor Red
    } else {
        Write-Host "[FAIL] $($brokenLinks.Count) broken links found (run with -Fix to repair)" -ForegroundColor Red
    }
    exit 1
}
