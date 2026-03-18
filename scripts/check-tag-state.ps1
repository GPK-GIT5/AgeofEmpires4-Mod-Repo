# Encoding: UTF-8 with BOM
# Tag-state awareness check (informational only).
# Reports drift between HEAD and the latest semver tag on main/master.
# Never blocks CI — exits 0 in all cases.
$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# ── Branch scope gate ──────────────────────────────────────
$branch = $env:GITHUB_REF_NAME
if (-not $branch) {
	try { $branch = (git rev-parse --abbrev-ref HEAD 2>&1).Trim() } catch { $branch = "unknown" }
}

if ($branch -notin @("main", "master")) {
	Write-Information "[INFO] Tag-state check skipped (branch: $branch)."
	exit 0
}

# ── Fetch tags (CI shallow clones may lack them) ───────────
try {
	git fetch --tags --quiet 2>&1 | Out-Null
} catch {
	Write-Warning "[WARN] Could not fetch tags: $_"
}

# ── Collect v* tags ────────────────────────────────────────
$allTags = @(git tag --list 'v*' 2>&1 | Where-Object { $_ -is [string] })

if ($allTags.Count -eq 0) {
	Write-Information "[INFO] No v* tags found. Tagging not yet established."
	exit 0
}

# ── Separate semver from bookmark tags ─────────────────────
$semverPattern = '^v\d+\.\d+(\.\d+)?$'
$semverTags = @($allTags | Where-Object { $_ -match $semverPattern })
$bookmarkTags = @($allTags | Where-Object { $_ -notmatch $semverPattern })

if ($bookmarkTags.Count -gt 0) {
	$list = ($bookmarkTags | ForEach-Object { $_.Trim() }) -join ", "
	Write-Information "[INFO] Bookmark tags (ignored for drift): $list"
}

if ($semverTags.Count -eq 0) {
	Write-Information "[INFO] No semver tags found. Only bookmark tags exist."
	exit 0
}

# ── Find latest semver tag by commit date ──────────────────
$latestTag = $null
$latestDate = [datetime]::MinValue

foreach ($tag in $semverTags) {
	$t = $tag.Trim()
	try {
		$dateStr = (git log -1 --format='%aI' $t 2>&1).Trim()
		$tagDate = [datetime]::Parse($dateStr)
		if ($tagDate -gt $latestDate) {
			$latestDate = $tagDate
			$latestTag = $t
		}
	} catch {
		# Skip unparseable tag
	}
}

if (-not $latestTag) {
	Write-Information "[INFO] Could not resolve latest semver tag."
	exit 0
}

# ── Compare HEAD to latest tag ─────────────────────────────
$tagCommit = (git rev-parse "$latestTag^{}" 2>&1).Trim()
$headCommit = (git rev-parse HEAD 2>&1).Trim()

$aheadCount = 0
try {
	$aheadCount = [int](git rev-list --count "$latestTag..HEAD" 2>&1).Trim()
} catch {
	$aheadCount = -1
}

if ($tagCommit -eq $headCommit) {
	Write-Host "[INFO] HEAD is at latest tag: $latestTag" -ForegroundColor Green
} elseif ($aheadCount -gt 0) {
	Write-Host "[INFO] HEAD is $aheadCount commit(s) ahead of $latestTag." -ForegroundColor Yellow
} else {
	$shortTag = $tagCommit.Substring(0, [Math]::Min(8, $tagCommit.Length))
	$shortHead = $headCommit.Substring(0, [Math]::Min(8, $headCommit.Length))
	Write-Host "[INFO] Tag state: $latestTag (tag=$shortTag, HEAD=$shortHead)" -ForegroundColor Cyan
}

$tagList = ($semverTags | ForEach-Object { $_.Trim() }) -join ", "
Write-Information "[INFO] Semver tags: $tagList"

exit 0
