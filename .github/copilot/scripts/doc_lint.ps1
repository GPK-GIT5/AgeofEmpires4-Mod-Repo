#!/usr/bin/env pwsh
<#
.SYNOPSIS
Deterministic documentation linting for readme-to-ai-reference skill.

.DESCRIPTION
Validates anchor uniqueness, YAML compliance, forbidden phrases, and file sizes
for reference material primitives. Compliance checks only—no extra heuristics.

Checks (v2 spec):
1. File size limits on specific .md files
2. Anchor uniqueness in .skills/readme-to-ai-reference/ai/**/*.md
3. YAML parsing on settings_schema.yaml (yq/python fallback)
4. Forbidden phrases in .skills/readme-to-ai-reference/ai/**/*.md

Output: [PASS] / [FAIL] / [WARN] format.
Exit code: 0 if no FAILs, 1 if any FAIL detected.

.NOTES
Execution context: workspace root
#>

$ErrorActionPreference = 'Stop'

# Counters
$checks = @{
    PassCount = 0
    FailCount = 0
    WarnCount = 0
}

# Forbidden phrases (exactly these; keep editable)
$forbiddenPhrases = @(
    "likely located",
    "probably in",
    "might be in",
    "assumed to be",
    "should be in"
)

#region Helper Functions

function Write-Check {
    param(
        [ValidateSet('PASS', 'FAIL', 'WARN')]
        [string]$Status,
        [string]$Message
    )
    
    $color = switch ($Status) {
        'PASS' { 'Green' }
        'FAIL' { 'Red' }
        'WARN' { 'Yellow' }
    }
    
    Write-Host "[$Status] $Message" -ForegroundColor $color
    
    if ($Status -eq 'PASS') { $checks.PassCount++ }
    elseif ($Status -eq 'FAIL') { $checks.FailCount++ }
    elseif ($Status -eq 'WARN') { $checks.WarnCount++ }
}

function Get-AnchorMatches {
    param([string]$FilePath)
    
    $content = Get-Content -Path $FilePath -Raw
    $pattern = '<!--\s*DOC:(\w+):(\w+)\s*-->'
    $matches = [regex]::Matches($content, $pattern)
    
    return $matches | ForEach-Object {
        @{
            Anchor   = $_.Value.Trim()
            Area     = $_.Groups[1].Value
            Name     = $_.Groups[2].Value
            File     = $FilePath
        }
    }
}

function Test-YamlWithYq {
    param([string]$FilePath)
    
    try {
        $yq = Get-Command yq -ErrorAction Stop
        & yq eval '.' $FilePath > $null 2>&1
        return $?
    }
    catch {
        return $null
    }
}

function Test-YamlWithPython {
    param([string]$FilePath)
    
    try {
        $python = Get-Command python -ErrorAction Stop
        $tempScript = [System.IO.Path]::GetTempFileName() + ".py"
        
        $pyCode = @"
import yaml
try:
    with open('$FilePath', 'r') as f:
        yaml.safe_load(f)
    print('valid')
except:
    print('invalid')
"@
        Set-Content -Path $tempScript -Value $pyCode -Encoding UTF8
        $result = & $python $tempScript 2>&1
        Remove-Item $tempScript -ErrorAction SilentlyContinue
        
        return $result -like "*valid*"
    }
    catch {
        return $null
    }
}

#endregion

#region Check Implementations

Write-Host ""
Write-Host "=== DOCUMENTATION LINT (v2 spec) ===" -ForegroundColor Cyan
Write-Host ""

# 1. FILE SIZE LIMITS
Write-Host "Check 1: File Size Limits" -ForegroundColor Cyan
Write-Host ""

$fileSizeTests = @(
    @{ Path = '.github/copilot-instructions.md'; Limit = 4000 },
    @{ Path = '.github/instructions/ai-reference.instructions.md'; Limit = 4000 }
)

foreach ($test in $fileSizeTests) {
    if (Test-Path $test.Path) {
        $size = (Get-Content -Path $test.Path -Raw).Length
        if ($size -lt $test.Limit) {
            Write-Check 'PASS' "$($test.Path): $size / $($test.Limit) chars"
        } else {
            Write-Check 'FAIL' "$($test.Path): $size / $($test.Limit) chars (over limit by $($size - $test.Limit))"
        }
    } else {
        Write-Check 'WARN' "$($test.Path): file not found"
    }
}

# 2. ANCHOR UNIQUENESS
Write-Host ""
Write-Host "Check 2: Anchor Uniqueness" -ForegroundColor Cyan
Write-Host ""

$skillPath = '.skills/readme-to-ai-reference/ai'

if (Test-Path $skillPath) {
    $mdFiles = Get-ChildItem -Path $skillPath -Include '*.md' -Recurse
    $anchorMap = @{}
    
    foreach ($file in $mdFiles) {
        $anchors = Get-AnchorMatches -FilePath $file.FullName
        
        foreach ($anchor in $anchors) {
            $key = "$($anchor.Area):$($anchor.Name)"
            if ($anchorMap.ContainsKey($key)) {
                $anchorMap[$key] += $file.FullName
            } else {
                $anchorMap[$key] = @($file.FullName)
            }
        }
    }
    
    $duplicates = $anchorMap.Keys | Where-Object { $anchorMap[$_].Count -gt 1 }
    
    if ($duplicates.Count -eq 0) {
        Write-Check 'PASS' "No duplicate anchors ($($anchorMap.Count) unique)"
    } else {
        foreach ($dup in $duplicates) {
            Write-Check 'FAIL' "Duplicate anchor [$dup] in:"
            foreach ($file in $anchorMap[$dup]) {
                Write-Host "    $file" -ForegroundColor Red
            }
        }
    }
} else {
    Write-Check 'WARN' "$skillPath not found"
}

# 3. YAML VALIDATION
Write-Host ""
Write-Host "Check 3: YAML Validation (dependency-aware)" -ForegroundColor Cyan
Write-Host ""

$yamlPath = '.skills/readme-to-ai-reference/ai/settings_schema.yaml'

if (Test-Path $yamlPath) {
    # Try yq first
    $yqResult = Test-YamlWithYq -FilePath $yamlPath
    
    if ($yqResult -eq $true) {
        Write-Check 'PASS' "${yamlPath}: valid (checked with yq)"
    } elseif ($yqResult -eq $false) {
        Write-Check 'FAIL' "${yamlPath}: parse error (yq)"
    } else {
        # yq not found, try python
        $pyResult = Test-YamlWithPython -FilePath $yamlPath
        
        if ($pyResult -eq $true) {
            Write-Check 'PASS' "${yamlPath}: valid (checked with python/PyYAML)"
        } elseif ($pyResult -eq $false) {
            Write-Check 'FAIL' "${yamlPath}: parse error (python)"
        } else {
            # Neither available
            Write-Check 'WARN' "${yamlPath}: no parser available (yq/python skipped)"
        }
    }
} else {
    Write-Check 'WARN' "${yamlPath}: file not found"
}

# 4. FORBIDDEN PHRASES
Write-Host ""
Write-Host "Check 4: Forbidden Phrases" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $skillPath) {
    $mdFiles = Get-ChildItem -Path $skillPath -Include '*.md' -Recurse
    $issuesFound = $false
    
    foreach ($file in $mdFiles) {
        $content = Get-Content -Path $file.FullName -Raw
        $lines = $content -split "`n"
        
        foreach ($phrase in $forbiddenPhrases) {
            $lineNum = 0
            foreach ($line in $lines) {
                $lineNum++
                if ($line -match [regex]::Escape($phrase)) {
                    Write-Check 'FAIL' "$($file.Name): line $lineNum contains '$phrase'"
                    Write-Host "    $($line.Trim())" -ForegroundColor Red
                    $issuesFound = $true
                }
            }
        }
    }
    
    if (-not $issuesFound) {
        Write-Check 'PASS' "No forbidden phrases found"
    }
} else {
    Write-Check 'WARN' "$skillPath not found"
}

#endregion

#region Summary and Exit

Write-Host ""
Write-Host "=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "PASS: $($checks.PassCount) | FAIL: $($checks.FailCount) | WARN: $($checks.WarnCount)" -ForegroundColor Cyan

Write-Host ""

if ($checks.FailCount -gt 0) {
    Write-Host "[FAIL] LINT FAILED" -ForegroundColor Red
    exit 1
} else {
    Write-Host "[PASS] LINT PASSED" -ForegroundColor Green
    exit 0
}

#endregion
