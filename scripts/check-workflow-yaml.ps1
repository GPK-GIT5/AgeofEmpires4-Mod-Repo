# Encoding: UTF-8 with BOM
# Guard: Detect duplicate doc_lint.ps1 workflows on push/pull_request triggers.
# Fails CI if more than one workflow is configured to run doc_lint.ps1 on the
# same event triggers, which causes duplicate GitHub Actions runs.
$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$workspaceRoot = if ($PSScriptRoot) {
	Resolve-Path (Join-Path $PSScriptRoot "..") | Select-Object -ExpandProperty Path
} else {
	(Get-Location).Path
}

$workflowDir = Join-Path $workspaceRoot ".github" "workflows"

if (-not (Test-Path $workflowDir)) {
	Write-Information "[INFO] No .github/workflows directory found."
	exit 0
}

$workflowFiles = Get-ChildItem -Path $workflowDir -Filter "*.yml" -File | Sort-Object Name

if (-not $workflowFiles) {
	Write-Information "[INFO] No workflow .yml files found in $workflowDir"
	exit 0
}

# Find workflows that run doc_lint.ps1 AND trigger on push or pull_request
$docLintWorkflows = [System.Collections.Generic.List[string]]::new()

foreach ($file in $workflowFiles) {
	$content = Get-Content -Path $file.FullName -Raw

	$runsDocLint = $content -match 'doc_lint\.ps1'
	$triggersPush = $content -match '(?m)^\s*push:'
	$triggersPR = $content -match '(?m)^\s*pull_request:'

	if ($runsDocLint -and ($triggersPush -or $triggersPR)) {
		$docLintWorkflows.Add($file.Name)
	}
}

if ($docLintWorkflows.Count -gt 1) {
	$list = $docLintWorkflows -join ", "
	Write-Error "[FAIL] Duplicate doc-lint workflows detected: $list. Only ONE workflow may run doc_lint.ps1 on push/pull_request to prevent duplicate CI runs. Remove or disable the extras."
	exit 1
}

if ($docLintWorkflows.Count -eq 0) {
	Write-Warning "[WARN] No workflow found that runs doc_lint.ps1 on push/pull_request. Documentation lint may not be enforced in CI."
	exit 0
}

Write-Information "[PASS] Workflow guard passed. Exactly one doc-lint workflow: $($docLintWorkflows[0])"
exit 0
