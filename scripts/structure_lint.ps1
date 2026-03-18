#!/usr/bin/env pwsh
<#
.SYNOPSIS
Enforces workspace directory structure rules automatically.

.DESCRIPTION
Validates that .github/ and .skills/ directories follow the reorganized
convention: only index/entry files at root, all content in subfolders,
consistent naming, no stale wrappers.

Run from workspace root or CI. Exit 0 = PASS, 1 = FAIL.

.EXAMPLE
./scripts/structure_lint.ps1
#>

$ErrorActionPreference = 'Stop'

$pass = 0; $fail = 0; $warn = 0

function Write-Check {
    param(
        [ValidateSet('PASS','FAIL','WARN')]
        [string]$Status,
        [string]$Message
    )
    $color = switch ($Status) { 'PASS' { 'Green' } 'FAIL' { 'Red' } 'WARN' { 'Yellow' } }
    Write-Host "[$Status] $Message" -ForegroundColor $color
    switch ($Status) { 'PASS' { $script:pass++ } 'FAIL' { $script:fail++ } 'WARN' { $script:warn++ } }
}

Write-Host ""
Write-Host "=== STRUCTURE LINT ===" -ForegroundColor Cyan
Write-Host ""

# ── 1. .github root: only allowed files ──────────────────────────────────
Write-Host "Rule 1: .github root contains only index/entry files" -ForegroundColor Cyan

$allowedGithubRoot = @('copilot-instructions.md', 'index.md')
$githubRootFiles = Get-ChildItem '.github' -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notin $allowedGithubRoot }

if ($githubRootFiles) {
    foreach ($f in $githubRootFiles) {
        Write-Check 'FAIL' ".github/$($f.Name) — not an index/entry file; move to a subfolder"
    }
} else {
    Write-Check 'PASS' ".github root: only index/entry files"
}

# ── 2. instructions/ grouped structure ────────────────────────────────────
Write-Host ""
Write-Host "Rule 2: instructions/ grouped conventions" -ForegroundColor Cyan

# Allowed groups → prefix whitelist per group.
# To add a new file: pick the right group, use an existing prefix or add one here.
$instrGroups = @{
    'coding'  = @('scar-', 'ps-', 'xaml-')          # language-specific standards
    'context' = @('gamemode-', 'mods-', 'mod-')      # folder scope & navigation
    'core'    = @('ai-', 'blueprint-', 'compat-')    # cross-cutting domain rules
}

$instrDir = '.github/instructions'
$instrCharLimit = 4000

if (Test-Path $instrDir) {
    # 2a. No loose files at instructions/ root
    $rootFiles = Get-ChildItem $instrDir -File -ErrorAction SilentlyContinue
    if ($rootFiles) {
        foreach ($f in $rootFiles) {
            Write-Check 'FAIL' "instructions/$($f.Name) — loose file; move into coding/, context/, or core/"
        }
    } else {
        Write-Check 'PASS' "instructions/ root: no loose files"
    }

    # 2b. Only allowed subdirectories
    $subDirs = Get-ChildItem $instrDir -Directory
    foreach ($d in $subDirs) {
        if ($instrGroups.ContainsKey($d.Name)) {
            Write-Check 'PASS' "instructions/$($d.Name)/ — recognized group"
        } else {
            Write-Check 'FAIL' "instructions/$($d.Name)/ — unknown group. Allowed: $($instrGroups.Keys -join ', ')"
        }
    }

    # 2c-2f. Per-file checks within each group
    foreach ($groupName in $instrGroups.Keys) {
        $groupDir = Join-Path $instrDir $groupName
        if (-not (Test-Path $groupDir)) {
            Write-Check 'WARN' "instructions/$groupName/ — group directory missing"
            continue
        }

        $groupPrefixes = $instrGroups[$groupName]

        # No nested subdirectories within groups
        $nested = Get-ChildItem $groupDir -Directory -ErrorAction SilentlyContinue
        if ($nested) {
            foreach ($nd in $nested) {
                Write-Check 'FAIL' "instructions/$groupName/$($nd.Name)/ — nesting beyond 1 level not allowed"
            }
        }

        # Non-instruction files
        $badFiles = Get-ChildItem $groupDir -File |
            Where-Object { $_.Name -notmatch '\.instructions\.md$' }
        foreach ($bf in $badFiles) {
            Write-Check 'FAIL' "$groupName/$($bf.Name) — must match *.instructions.md"
        }

        foreach ($f in (Get-ChildItem $groupDir -Filter '*.instructions.md' -ErrorAction SilentlyContinue)) {
            $content = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
            $head = ($content -split "`n" | Select-Object -First 5) -join "`n"

            # applyTo frontmatter
            if ($head -match 'applyTo:\s*"[^"]+"') {
                Write-Check 'PASS' "$groupName/$($f.Name) — valid applyTo"
            } else {
                Write-Check 'FAIL' "$groupName/$($f.Name) — missing or malformed applyTo"
            }

            # Size guard
            $size = $content.Length
            if ($size -le $instrCharLimit) {
                Write-Check 'PASS' "$groupName/$($f.Name) — $size / $instrCharLimit chars"
            } else {
                Write-Check 'FAIL' "$groupName/$($f.Name) — $size chars (over by $($size - $instrCharLimit))"
            }

            # Prefix matches group
            $prefixOk = $false
            foreach ($p in $groupPrefixes) {
                if ($f.Name.StartsWith($p)) { $prefixOk = $true; break }
            }
            if ($prefixOk) {
                Write-Check 'PASS' "$groupName/$($f.Name) — prefix matches group"
            } else {
                Write-Check 'FAIL' "$groupName/$($f.Name) — prefix doesn't match group. Expected: $($groupPrefixes -join ', ')"
            }
        }
    }
} else {
    Write-Check 'WARN' "instructions/ directory not found"
}

# ── 3. No stale copilot/ wrapper ─────────────────────────────────────────
Write-Host ""
Write-Host "Rule 3: No stale .github/copilot/ directory" -ForegroundColor Cyan

if (Test-Path '.github/copilot') {
    Write-Check 'FAIL' ".github/copilot/ still exists — should have been removed during reorg"
} else {
    Write-Check 'PASS' "No stale copilot/ wrapper"
}

# ── 4. copilot-instructions.md size guard ─────────────────────────────────
Write-Host ""
Write-Host "Rule 4: Master instructions ≤ 4000 chars" -ForegroundColor Cyan

$masterPath = '.github/copilot-instructions.md'
if (Test-Path $masterPath) {
    $size = (Get-Content $masterPath -Raw).Length
    if ($size -le 4000) {
        Write-Check 'PASS' "copilot-instructions.md: $size / 4000 chars"
    } else {
        Write-Check 'FAIL' "copilot-instructions.md: $size / 4000 chars (over by $($size - 4000))"
    }
} else {
    Write-Check 'FAIL' "copilot-instructions.md not found"
}

# ── 5. .skills root: only index.md ───────────────────────────────────────
Write-Host ""
Write-Host "Rule 5: .skills root contains only index.md" -ForegroundColor Cyan

$allowedSkillsRoot = @('index.md')
$skillsRootFiles = Get-ChildItem '.skills' -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notin $allowedSkillsRoot }

if ($skillsRootFiles) {
    foreach ($f in $skillsRootFiles) {
        Write-Check 'FAIL' ".skills/$($f.Name) — not an index file; move to a skill subfolder"
    }
} else {
    Write-Check 'PASS' ".skills root: only index files"
}

# ── 6. Each skill has SKILL.md ───────────────────────────────────────────
Write-Host ""
Write-Host "Rule 6: Each skill folder has SKILL.md" -ForegroundColor Cyan

$skillDirs = Get-ChildItem '.skills' -Directory -ErrorAction SilentlyContinue
foreach ($dir in $skillDirs) {
    $skillFile = Join-Path $dir.FullName 'SKILL.md'
    if (Test-Path $skillFile) {
        Write-Check 'PASS' ".skills/$($dir.Name)/SKILL.md present"
    } else {
        Write-Check 'FAIL' ".skills/$($dir.Name)/ — missing SKILL.md entry point"
    }
}

# ── 7. workflows/ contains only .yml ─────────────────────────────────────
Write-Host ""
Write-Host "Rule 7: workflows/ contains only .yml files" -ForegroundColor Cyan

$wfDir = '.github/workflows'
if (Test-Path $wfDir) {
    $badWf = Get-ChildItem $wfDir -File | Where-Object { $_.Extension -ne '.yml' }
    if ($badWf) {
        foreach ($f in $badWf) {
            Write-Check 'FAIL' "workflows/$($f.Name) — non-YAML file in workflows/"
        }
    } else {
        Write-Check 'PASS' "workflows/ contains only .yml"
    }
} else {
    Write-Check 'WARN' "workflows/ not found"
}

# ── 8. architecture/ and archive/ exist ──────────────────────────────────
Write-Host ""
Write-Host "Rule 8: Standard subdirectories present" -ForegroundColor Cyan

foreach ($sub in @('.github/architecture', '.github/archive', '.github/instructions', '.github/workflows')) {
    if (Test-Path $sub) {
        Write-Check 'PASS' "$sub/ exists"
    } else {
        Write-Check 'WARN' "$sub/ missing"
    }
}

# ── 9. Gamemodes/ and Scenarios/ mod structure ────────────────────────────
Write-Host ""
Write-Host "Rule 9: Gamemodes/ and Scenarios/ — docs only in docs/" -ForegroundColor Cyan

# Runtime paths that are always valid and must never be flagged.
$runtimeDirNames = @('assets', 'scar', '.aoe4', 'archives', 'docs')
$runtimeExts     = @('.scar', '.aoe4mod')

foreach ($root in @('Gamemodes', 'Scenarios')) {
    if (-not (Test-Path $root)) { continue }

    foreach ($mod in (Get-ChildItem $root -Directory -ErrorAction SilentlyContinue)) {
        $modLabel = "$root/$($mod.Name)"

        # 9a. Loose .md files at mod root
        $looseMd = Get-ChildItem $mod.FullName -File -Filter '*.md' -ErrorAction SilentlyContinue
        if ($looseMd) {
            foreach ($f in $looseMd) {
                Write-Check 'FAIL' "$modLabel/$($f.Name) — .md file outside docs/; move to $modLabel/docs/"
            }
        }

        # 9b. .md files in non-docs subdirectories (recursive)
        $subDirs = Get-ChildItem $mod.FullName -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -ne 'docs' }
        foreach ($sub in $subDirs) {
            $deepMd = Get-ChildItem $sub.FullName -Recurse -File -Filter '*.md' -ErrorAction SilentlyContinue
            foreach ($f in $deepMd) {
                $rel = $f.FullName.Substring($mod.FullName.Length + 1) -replace '\\', '/'
                Write-Check 'FAIL' "$modLabel/$rel — .md file outside docs/"
            }
        }

        # 9c. If docs/ exists, PASS
        if (Test-Path (Join-Path $mod.FullName 'docs')) {
            Write-Check 'PASS' "$modLabel/docs/ present"
        }
    }
}

# ── Summary ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "PASS: $pass | FAIL: $fail | WARN: $warn" -ForegroundColor Cyan
Write-Host ""

if ($fail -gt 0) {
    Write-Host "[FAIL] STRUCTURE LINT FAILED" -ForegroundColor Red
    exit 1
} else {
    Write-Host "[PASS] STRUCTURE LINT PASSED" -ForegroundColor Green
    exit 0
}
