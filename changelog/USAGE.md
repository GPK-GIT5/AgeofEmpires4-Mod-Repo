# Changelog Usage Guide

┌─────────────────────────────────────────────────┐
│          📋 CHANGELOG QUICK REFERENCE          │
├─────────────────────────────────────────────────┤
│                                                 │
│  📝 Add Entry     → validate → append → gen    │
│  🔍 View Changes  → open 2026-02.md            │
│  📊 Update Views  → generate-overview.ps1      │
│  📖 Full Details  → generate-detailed-entries  │
│                                                 │
└─────────────────────────────────────────────────┘

---

## ➕ Add New Entry

### Step 1: Copy Template

📂 Location: `changelog/templates/entry-template.jsonl`

```json
{"timestamp":"2026-02-24T00:00:00Z","file":"path/to/file","status":"added","type":"markdown","change":"Brief description of what changed","impact":"minor","category":"reference","audience":"users","tags":"example,tag"}
```

### Step 2: Validate Entry

```powershell
# Paste your entry here (replace the JSON string)
$entry = '{"timestamp":"2026-02-24T00:00:00Z",...}'
.\validate-entry.ps1 -Entry $entry
```

✅ **Expected:** Green checkmark "VALID ENTRY"  
❌ **If errors:** Fix the highlighted field and re-validate

### Step 3: Choose Scope

- Changed files starting with `mods/`? → Use `mods/INDEX.jsonl`
- Changed files in `changelog/`? → Use `system/INDEX.jsonl`
- Changed anything else? → Use `workspace/INDEX.jsonl`

### Step 4: Append to JSONL

```powershell
# Replace <scope> with: mods, system, or workspace
$entry | Out-File -FilePath <scope>\INDEX.jsonl -Append -Encoding utf8 -NoNewline
"`n" | Out-File -FilePath <scope>\INDEX.jsonl -Append -Encoding utf8 -NoNewline
```

### Step 5: Generate Changelog

```powershell
# Replace <scope> with your chosen scope
.\generate-overview.ps1 -Scope <scope>
.\generate-detailed-entries.ps1 -Scope <scope>
```

📂 **Output:** `<scope>/2026-02.md` updated with your entry

---

## 🔍 View Changelogs

📂 **File Locations:**
- Workspace changes: `workspace/2026-02.md`
- System changes: `system/2026-02.md`
- Mod changes: `mods/2026-02.md`

**What's inside:**
- Dashboard with health metrics at top
- Quick overview table (grouped by date)
- Detailed entries (scroll down past `---`)

---

## 🔎 Query Examples

### Find all critical changes

```powershell
Get-Content workspace\INDEX.jsonl,system\INDEX.jsonl,mods\INDEX.jsonl | 
  ConvertFrom-Json | 
  Where-Object { $_.impact -eq "critical" }
```

### Find changes to a specific file

```powershell
Get-Content workspace\INDEX.jsonl | 
  ConvertFrom-Json | 
  Where-Object { $_.file -like "*INDEX.md*" }
```

### Count entries by impact

```powershell
Get-Content workspace\INDEX.jsonl | 
  ConvertFrom-Json | 
  Group-Object impact | 
  Select-Object Name, Count
```

### Find all changes in last 7 days

```powershell
$cutoff = (Get-Date).AddDays(-7)
Get-Content workspace\INDEX.jsonl,system\INDEX.jsonl,mods\INDEX.jsonl | 
  ConvertFrom-Json | 
  Where-Object { [DateTime]$_.timestamp -gt $cutoff }
```

### Group changes by file

```powershell
Get-Content workspace\INDEX.jsonl | 
  ConvertFrom-Json | 
  Group-Object file | 
  Select-Object Name, Count | 
  Sort-Object Count -Descending
```

---

## ⚠️ Common Issues

**Validation fails with "Field missing"**  
→ Check template has all 9 required fields (timestamp, file, status, type, change, impact, category, audience, tags)

**Dashboard not updating**  
→ Run both scripts: `generate-overview.ps1` then `generate-detailed-entries.ps1`

**Emoji showing as boxes/question marks**  
→ Normal in older terminals. Functionality still works.

**Entry appears twice**  
→ You appended to wrong scope. Check file path routing in Step 3.

**Invalid impact value error**  
→ Use only these values: `critical`, `major`, `minor`, `bugfix`, `documentation`, `refactor`, `internal`, `other`

**JSONL file corrupted**  
→ Each line must be valid JSON. Check for missing commas, quotes, or braces. Use a JSON validator.

---

## 📂 File Locations

```
changelog/
├── 📜 USAGE.md              ← You are here
├── 📜 QUICKSTART.md         ← Detailed onboarding guide
├── 📜 README.md             ← Full system documentation
│
├── 🔧 validate-entry.ps1    ← Step 2: Validation script
├── 🔧 generate-overview.ps1 ← Step 5a: Dashboard generator
├── 🔧 generate-detailed-entries.ps1 ← Step 5b: Entry generator
│
├── templates/
│   └── entry-template.jsonl ← Step 1: Copy this
│
├── workspace/               ← Most changes go here
│   ├── INDEX.jsonl          ← Append entries here
│   └── 2026-02.md          ← View results here
│
├── system/                  ← Changelog infrastructure changes
│   ├── INDEX.jsonl
│   └── 2026-02.md
│
└── mods/                    ← Mod-specific changes
    ├── INDEX.jsonl
    └── 2026-02.md
```

---

## 📚 Additional Resources

- **Full Documentation:** [README.md](README.md)
- **Quick Start Guide:** [QUICKSTART.md](QUICKSTART.md)
- **Schema Reference:** [README.md#schema](README.md#schema)
- **Health Scoring:** [README.md#health-scoring](README.md#health-scoring)

---

## 🎯 Quick Tips

✨ **Copy the template** → Always start with `entry-template.jsonl`  
🔍 **Validate first** → Catch errors before appending  
📂 **Right scope** → Use file path to determine scope  
🔄 **Run both scripts** → Overview + detailed entries  
🧹 **Keep it clean** → One entry per logical change
