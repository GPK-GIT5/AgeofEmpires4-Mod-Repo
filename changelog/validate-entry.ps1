# Validate JSONL Entry Against Schema
# Ensures changelog entries conform to required structure before appending
# Usage: .\validate-entry.ps1 -Entry $jsonString

param(
    [Parameter(Mandatory=$true)]
    [string]$Entry
)

$ErrorActionPreference = "Stop"

# Define schema
$schema = @{
    timestamp = @{ type = "string"; pattern = "^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{1,3})?(Z|[+-]\d{2}:\d{2})?$"; required = $true }
    file = @{ type = "string"; required = $true }
    status = @{ type = "enum"; values = @("added", "modified", "removed"); required = $true }
    type = @{ type = "enum"; values = @("markdown", "json", "csv", "powershell", "typescript", "config", "scar"); required = $true }
    change = @{ type = "string"; required = $true }
    impact = @{ type = "enum"; values = @("critical", "major", "minor", "bugfix", "documentation", "refactor", "internal", "other"); required = $true }
    category = @{ type = "enum"; values = @("reference", "data", "mods", "scripts", "guides", "systems", "other"); required = $true }
    audience = @{ type = "enum"; values = @("scripters", "modders", "testers", "users", "api-tools"); required = $true }
    tags = @{ type = "array"; required = $true }
    notes = @{ type = "string"; required = $false }
}

# Parse JSON
try {
    $obj = $Entry | ConvertFrom-Json
} catch {
    Write-Host "✗ INVALID JSON" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Gray
    return $false
}

$isValid = $true
$errors = @()

# Validate each field
foreach ($fieldName in $schema.Keys) {
    $fieldSchema = $schema[$fieldName]
    $value = $obj.PSObject.Properties[$fieldName]
    
    # Check if required field exists
    if ($fieldSchema.required -and -not $value) {
        $errors += "Missing required field: $fieldName"
        $isValid = $false
        continue
    }
    
    if (-not $value) {
        # Field optional and missing - OK
        continue
    }
    
    $fieldValue = $value.Value
    
    # Special handling: ConvertFrom-Json converts ISO 8601 timestamps to DateTime objects
    # Convert back to ISO 8601 string for validation if needed
    if ($fieldName -eq "timestamp" -and $fieldValue -is [DateTime]) {
        $fieldValue = $fieldValue.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        $value.Value = $fieldValue
    }
    
    # Validate type for string
    if ($fieldSchema.type -eq "string" -and $fieldValue -isnot [string]) {
        $errors += "${fieldName}: expected string, got $($fieldValue.GetType().Name)"
        $isValid = $false
    }
    elseif ($fieldSchema.type -eq "array" -and $fieldValue -isnot [array]) {
        $errors += "${fieldName}: expected array, got $($fieldValue.GetType().Name)"
        $isValid = $false
    }
    elseif ($fieldSchema.type -eq "enum") {
        if ($fieldValue -notin $fieldSchema.values) {
            $errors += "${fieldName}: '$fieldValue' not in allowed values: $($fieldSchema.values -join ', ')"
            $isValid = $false
        }
    }
    
    # Validate pattern (timestamp)
    if ($fieldSchema.pattern -and $fieldValue -notmatch $fieldSchema.pattern) {
        $errors += "${fieldName}: '$fieldValue' does not match pattern $($fieldSchema.pattern)"
        $isValid = $false
    }
}

# Check for unknown fields
foreach ($prop in $obj.PSObject.Properties.Name) {
    if ($prop -notin $schema.Keys) {
        Write-Warning "Unknown field: $prop (will be preserved but not in schema)"
    }
}

# Report results
if ($isValid) {
    Write-Host "✓ VALID ENTRY" -ForegroundColor Green
    Write-Host "  File: $($obj.file)" -ForegroundColor White
    Write-Host "  Status: $($obj.status)" -ForegroundColor White
    Write-Host "  Impact: $($obj.impact)" -ForegroundColor White
    Write-Output $true  # Output to pipeline so caller can test result
} else {
    Write-Host "✗ INVALID ENTRY" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "  ✗ $error" -ForegroundColor Red
    }
    Write-Output $false  # Output to pipeline so caller can test result
}
