---
applyTo: "references/audits/**"
---

# Audit Outputs

Auto-generated validation reports from `scripts/validate_data.ps1`.

## Reports

| File | Checks |
|------|--------|
| `pipeline-audit.md` | Civ coverage, production completeness, upgrade chain continuity, alias collisions, runtime truth conflicts |

## Audit Checks

1. **Civ Coverage**: Cross-references SCAR `AGS_CIV_PREFIXES` (24 civs) against data `civs-index.json` (23 civs)
2. **Production Completeness**: Identifies units with no `producedBy` building
3. **Upgrade Chain Continuity**: Detects age-tier gaps (e.g., Age 2 → Age 4 with no Age 3)
4. **Alias Collisions**: Display names that resolve to multiple baseIds
5. **Static Truth Conflicts**: TAG_MISSING, TAG_EXTRA, DPS_OUTLIER from weapon-vs-class analysis of static data exports (not live runtime validated)

## Regeneration

```powershell
.\scripts\validate_data.ps1
```
