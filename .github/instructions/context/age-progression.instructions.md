---
applyTo: "Gamemodes/**/assets/scar/gameplay/*age*.scar,Gamemodes/**/assets/scar/gameplay/ags_starting*.scar,Scenarios/**/*age*.scar,references/gameplay/age-progression.md"
description: "Apply when working on civilization age progression, landmark mechanics, age-up systems, or any civ-mechanic work involving age transitions, landmark BPs, or the cardinal age API."
---

# Age Progression & Landmark Mechanics

Always consult `references/gameplay/age-progression.md` before modifying or generating code that touches age transitions, landmark blueprints, or civ-specific progression mechanics.

## Procedure Taxonomy — Non-Negotiable

Not all civs use landmark construction to age up. Before writing any age-progression logic, identify which procedure category applies:

| Procedure | Civs | Key Detail |
|-----------|------|------------|
| Standard landmark (2 choices per age) | English, French, HRE, Rus, Delhi, Chinese, Malians, Ottomans, Byzantines, Japanese — plus most HA suffix variants | BP class: `building_landmark_age{N}_*` |
| Wing research | Abbasid (`abb`), Ayyubids (`abbasid_ha_01`) | No landmark; research on House of Wisdom |
| Core-building upgrade | Golden Horde (`mongol_ha_gol`) | Golden Tent + `age_up_upgrade` type; detect via `BP_IsUpgradeOfType` |
| Nomadic wonder | Mongols (`mon`) | BP class is `building_wonder_age{N}_*_moving_mon`, **not** `building_landmark` |
| Commandery selection | Knights Templar (`templar`) | No landmark; 3 commandery choices per age bracket |
| Standard + parallel progression | Jeanne d'Arc, Order of the Dragon, House of Lancaster, Macedonian Dynasty, Sengoku, Tughluq, Zhu Xi's Legacy | Standard landmarks; second progression axis tracked separately |

## HA Variant Rules

- Most HA variants share their base civ's procedure. BP suffix is `_<baseciv>_ha_<tag>`.
- **Zhu Xi's Legacy** and **Sengoku** have entirely distinct landmark BPs — do not derive from base Chinese/Japanese BP names.
- **Ayyubids** and **Golden Horde** use non-landmark procedures — do not add landmark BPs for them.
- Always check `data/aoe4/data/derived/bp-suffix-catalog.json` before assuming a landmark BP exists for a variant civ.

## SCAR API Constraints

- Use `Player_GetCurrentAge(player.id)` to read age; constants `AGE_DARK=1` through `AGE_IMPERIAL=4`.
- Apply age upgrades in **reverse order** (Imperial → Castle → Feudal) to avoid audio-cue overlap. See `classic_start.scar` for the canonical pattern.
- `Player_SetMaximumAge` locks construction menus but does not strip upgrades already held.
- Mongols: `building_wonder_age*` BPs satisfy `BP_IsEntityOfType("wonder")`, not `"landmark"`.

## Do Not Duplicate

Landmark BP names, wing upgrade IDs, and commandery lists live exclusively in `references/gameplay/age-progression.md`. Do not copy that data into scripts or other instruction files — reference the doc instead.
