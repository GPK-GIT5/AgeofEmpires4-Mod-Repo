"""
Static analysis of the leaver military pipeline coverage.
Traces every civ-unique unit through the 5-tier resolver for all 22×21 civ pairs
to identify remaining gaps after the Tier 3→4 cascade fix.

This mirrors the in-game _ResolveMilitaryRoute logic at the code level.
"""

# === DATA TABLES (mirrored from cba.scar) ===

CIV_PREFIXES = {
    "chinese": "chi_", "english": "eng_", "french": "fre_", "hre": "hre_",
    "mongol": "mon_", "rus": "rus_", "sultanate": "sul_", "abbasid": "abb_",
    "malian": "mal_", "ottoman": "ott_",
    "abbasid_ha_01": "abb_ha_01_", "chinese_ha_01": "chi_ha_01_",
    "french_ha_01": "fre_ha_01_", "hre_ha_01": "hre_ha_01_",
    "japanese": "jpn_", "byzantine": "byz_",
    "mongol_ha_gol": "mon_ha_gol_", "lancaster": "lan_", "templar": "tem_",
    "byzantine_ha_mac": "byz_ha_mac_", "japanese_ha_sen": "jpn_ha_sen_",
    "sultanate_ha_tug": "sul_ha_tug_",
}

ALL_CIVS = sorted(CIV_PREFIXES.keys())

# Which standard archetypes each civ is KNOWN to have (based on receiver-class gaps)
# Standard units that ALL civs have: spearman, archer, horseman (basic Infantry/Ranged/Cavalry)
# Units missing per civ (from _LEAVER_RECEIVER_CLASS_MAP):
CIV_MISSING_STANDARD = {
    "japanese":        {"manatarms", "crossbowman", "monk"},
    "japanese_ha_sen": {"manatarms", "crossbowman", "culverin", "monk"},
    "lancaster":       {"archer", "horseman", "knight", "manatarms", "crossbowman",
                        "springald", "mangonel", "bombard", "trebuchet", "culverin",
                        "ribauldequin", "ram", "siege_tower"},
    "malian":          {"knight", "manatarms", "crossbowman"},
    "templar":         {"knight", "bombard", "culverin", "ribauldequin"},
    "chinese":         {"ribauldequin"},
    "chinese_ha_01":   {"ribauldequin"},
    "mongol_ha_gol":   {"trebuchet", "culverin", "ribauldequin"},
}

# Receiver-class remaps: receiver_civ → {missing_role → replacement_role}
RECEIVER_CLASS_MAP = {
    "japanese":        {"manatarms": "samurai", "crossbowman": "ozutsu", "monk": "DESTROY"},
    "japanese_ha_sen": {"manatarms": "samurai", "crossbowman": "ozutsu", "culverin": "springald", "monk": "DESTROY"},
    "lancaster":       {"archer": "yeoman", "horseman": "hobelar", "knight": "hobelar",
                        "manatarms": "earlsguard", "crossbowman": "yeoman",
                        "springald": "SIEGE_SPRINGALD", "mangonel": "SIEGE_SPRINGALD",
                        "bombard": "SIEGE_SPRINGALD", "trebuchet": "SIEGE_SPRINGALD",
                        "culverin": "SIEGE_SPRINGALD", "ribauldequin": "SIEGE_SPRINGALD",
                        "ram": "SIEGE_SPRINGALD", "siege_tower": "SIEGE_SPRINGALD"},
    "malian":          {"knight": "horseman", "manatarms": "gbeto", "crossbowman": "javelin"},
    "templar":         {"knight": "horseman", "bombard": "TREBUCHET_FULL", "culverin": "springald", "ribauldequin": "mangonel"},
    "chinese":         {"ribauldequin": "nest_of_bees"},
    "chinese_ha_01":   {"ribauldequin": "nest_of_bees"},
    "hre":             {"monk": "monk_t1"},
    "hre_ha_01":       {"monk": "monk_t1"},
    "byzantine":       {"monk": "monk_t2"},
    "byzantine_ha_mac":{"monk": "monk_t2"},
    "sultanate":       {"monk": "monk_t2"},
    "sultanate_ha_tug":{"monk": "monk_t2"},
    "abbasid_ha_01":   {"monk": "monk_base_abb"},
    "mongol_ha_gol":   {"trebuchet": "mangonel", "culverin": "bombard", "ribauldequin": "mangonel"},
}

# Civ-unique units → archetype target role
CIV_UNIQUE_FALLBACK = {
    # Heroes
    "khan": ("horseman", 1.0), "jeanne": ("knight", 1.0),
    "abbey_king": ("manatarms", 1.0), "wynguard": ("DESTROY", 0),
    # Malian
    "gbeto": ("manatarms", 0.75), "javelin": ("archer", 1.0),
    "musofadi": ("horseman", 1.0), "donso": ("spearman", 1.0),
    # English
    "longbowman": ("archer", 1.0),
    # Chinese
    "palace_guard": ("manatarms", 1.0), "fire_lancer": ("horseman", 1.0),
    "zhuge_nu": ("crossbowman", 1.0), "nest_of_bees": ("mangonel", 1.0),
    "grenadier": ("handcannoneer", 1.0), "official": ("monk", 1.0),
    # Mongol
    "mangudai": ("archer", 1.0), "keshik": ("horseman", 1.0),
    # Rus
    "streltsy": ("handcannoneer", 1.0), "horse_archer": ("archer", 1.0),
    "warrior_monk": ("monk", 1.0),
    # Ottoman
    "janissary": ("handcannoneer", 1.0), "sipahi": ("knight", 1.0),
    "great_bombard": ("bombard", 1.0), "mehter": ("monk", 1.0),
    # Abbasid
    "camel_archer": ("archer", 1.0), "camel_rider": ("horseman", 1.0),
    # Sultanate
    "war_elephant": ("knight", 0.3), "tower_elephant": ("knight", 0.3),
    "ghulam": ("manatarms", 1.0),
    # HRE
    "landsknecht": ("manatarms", 1.0),
    # Byzantine
    "cataphract": ("knight", 1.0), "limitanei": ("spearman", 1.0),
    "varangian_guard": ("manatarms", 1.0),
    # Japanese
    "samurai": ("manatarms", 1.0), "onna_musha": ("horseman", 1.0),
    "mounted_samurai": ("knight", 1.0), "ozutsu": ("handcannoneer", 1.0),
    # Lancaster
    "yeoman": ("archer", 1.0), "hobelar": ("horseman", 1.0),
    "earlsguard": ("manatarms", 1.0),
}

# Which civs own which unique units
CIV_UNIQUE_UNITS = {
    "english":         ["longbowman", "abbey_king"],
    "french":          ["jeanne"],
    "hre":             ["landsknecht"],
    "mongol":          ["mangudai", "keshik", "khan"],
    "chinese":         ["palace_guard", "fire_lancer", "zhuge_nu", "nest_of_bees", "grenadier", "official"],
    "rus":             ["streltsy", "horse_archer", "warrior_monk"],
    "sultanate":       ["war_elephant", "tower_elephant", "ghulam"],
    "abbasid":         ["camel_archer", "camel_rider"],
    "malian":          ["gbeto", "javelin", "musofadi", "donso"],
    "ottoman":         ["janissary", "sipahi", "great_bombard", "mehter"],
    "japanese":        ["samurai", "onna_musha", "mounted_samurai", "ozutsu"],
    "byzantine":       ["cataphract", "limitanei", "varangian_guard"],
    "lancaster":       ["yeoman", "hobelar", "earlsguard"],
    "templar":         [],  # Uses standard French units
    # Variant civs inherit parent's unique units
    "abbasid_ha_01":   ["camel_archer", "camel_rider"],
    "chinese_ha_01":   ["palace_guard", "fire_lancer", "zhuge_nu", "nest_of_bees", "grenadier", "official"],
    "french_ha_01":    ["jeanne"],
    "hre_ha_01":       ["landsknecht"],
    "mongol_ha_gol":   ["mangudai", "keshik", "khan"],
    "sultanate_ha_tug":["war_elephant", "tower_elephant", "ghulam"],
    "byzantine_ha_mac":["cataphract", "limitanei", "varangian_guard"],
    "japanese_ha_sen": ["samurai", "onna_musha", "mounted_samurai", "ozutsu"],
}

# Civs known to lack handcannoneer BP entirely
CIVS_NO_HANDCANNONEER = {"chinese", "chinese_ha_01", "malian", "japanese", "japanese_ha_sen"}

# Standard units that virtually all civs have (can be suffix-swapped)
STANDARD_ROLES = ["spearman", "archer", "horseman", "knight", "manatarms", "crossbowman",
                  "handcannoneer", "monk", "springald", "mangonel", "bombard", "trebuchet",
                  "culverin", "ribauldequin", "ram", "siege_tower"]

# Canonical role mapping for Tier 5
CANONICAL_ROLE = {
    "spearman": "spearman", "manatarms": "manatarms", "landsknecht": "manatarms",
    "archer": "archer", "crossbowman": "crossbowman",
    "handcannoneer": "handcannoneer", "handcannon": "handcannoneer",
    "horseman": "horseman", "knight": "knight", "sipahi": "knight", "camel_rider": "horseman",
    "monk": "monk", "springald": "springald", "mangonel": "mangonel",
    "bombard": "bombard", "trebuchet": "trebuchet", "culverin": "culverin",
    "ribauldequin": "mangonel", "ram": "ram", "siege_tower": "siege_tower", "siege": "springald",
}


def resolve_unique_unit(unit_name, src_civ, rcv_civ):
    """Trace the 5-tier resolver for a civ-unique unit → receiver civ."""
    entry = CIV_UNIQUE_FALLBACK.get(unit_name)
    if not entry:
        return "UNMAPPED", f"{unit_name} not in fallback table"
    
    archetype, ratio = entry
    if archetype == "DESTROY":
        return "destroy_policy", f"{unit_name} → DESTROY (policy)"
    
    rcv_suffix = CIV_PREFIXES[rcv_civ].rstrip("_")
    rcv_missing = CIV_MISSING_STANDARD.get(rcv_civ, set())
    
    # Tier 3: Try archetype BP directly
    if archetype not in rcv_missing:
        # Archetype exists for receiver (direct or standard)
        return "civ_unique_archetype", f"{unit_name} → {archetype} (Tier 3 direct, ratio={ratio})"
    
    # Tier 3 failed: archetype doesn't exist for receiver. CASCADE FIX applies.
    # Promoted role = archetype. Try Tier 4 with promoted role.
    rcv_class = RECEIVER_CLASS_MAP.get(rcv_civ, {})
    if archetype in rcv_class:
        remap = rcv_class[archetype]
        if remap == "DESTROY":
            return "destroy_policy", f"{unit_name} → {archetype} → DESTROY (receiver class policy)"
        return "receiver_class", f"{unit_name} → {archetype} → {remap} (Tier 3→4 cascade, ratio={ratio})"
    
    # Tier 5: Generic archetype fallback with canonical role
    canonical = CANONICAL_ROLE.get(archetype, archetype)
    if canonical not in rcv_missing:
        return "generic_archetype", f"{unit_name} → {archetype} → canonical {canonical} (Tier 5, ratio={ratio})"
    
    # Canonical also missing for receiver? Check if receiver-class has canonical
    if canonical in rcv_class:
        remap = rcv_class[canonical]
        if remap == "DESTROY":
            return "destroy_policy", f"{unit_name} → {canonical} → DESTROY"
        return "receiver_class", f"{unit_name} → {canonical} → {remap} (Tier 5→4)"
    
    # Check for handcannoneer special case (some civs completely lack HC BPs)
    if archetype == "handcannoneer" and rcv_civ in CIVS_NO_HANDCANNONEER:
        return "destroy_no_mapping", f"{unit_name} → handcannoneer → NO BP for {rcv_civ}"
    
    return "destroy_no_mapping", f"{unit_name} → {archetype} → NO RESOLUTION for {rcv_civ}"


def resolve_standard_units(src_civ, rcv_civ):
    """Check standard unit suffix-swap (Tier 1) + receiver-class (Tier 4) for a pair."""
    rcv_missing = CIV_MISSING_STANDARD.get(rcv_civ, set())
    rcv_class = RECEIVER_CLASS_MAP.get(rcv_civ, {})
    issues = []
    for role in STANDARD_ROLES:
        if role in rcv_missing:
            if role in rcv_class:
                remap = rcv_class[role]
                if remap == "DESTROY":
                    issues.append(("destroy_policy", f"std:{role} → DESTROY (rcv class)"))
                # else: receiver-class resolves it
            else:
                # Missing and no class remap — check generic
                canonical = CANONICAL_ROLE.get(role, role)
                if canonical not in rcv_missing:
                    pass  # Generic archetype resolves
                elif canonical in rcv_class:
                    pass  # Generic → class resolves
                else:
                    issues.append(("destroy_no_mapping", f"std:{role} → NO RESOLUTION"))
    return issues


def main():
    print("=" * 80)
    print("LEAVER MILITARY PIPELINE — STATIC COVERAGE ANALYSIS")
    print("Post-fix: Tier 3→4 cascade + Lancaster/Official entries")
    print("=" * 80)
    print()

    total_pairs = 0
    total_unique_tests = 0
    gaps = []
    destroy_policy = []
    coverage_by_pair = {}

    for src in ALL_CIVS:
        for rcv in ALL_CIVS:
            if src == rcv:
                continue
            total_pairs += 1
            pair_key = f"{src}→{rcv}"
            pair_gaps = []
            pair_policies = []

            # Test unique units from source civ
            unique_units = CIV_UNIQUE_UNITS.get(src, [])
            for unit in unique_units:
                total_unique_tests += 1
                route, detail = resolve_unique_unit(unit, src, rcv)
                if route == "destroy_no_mapping" or route == "UNMAPPED":
                    pair_gaps.append(detail)
                    gaps.append((pair_key, detail))
                elif route == "destroy_policy":
                    pair_policies.append(detail)
                    destroy_policy.append((pair_key, detail))

            # Test standard unit resolution
            std_issues = resolve_standard_units(src, rcv)
            for route, detail in std_issues:
                if route == "destroy_no_mapping":
                    pair_gaps.append(detail)
                    gaps.append((pair_key, detail))
                elif route == "destroy_policy":
                    pair_policies.append(detail)
                    destroy_policy.append((pair_key, detail))

            quality = 3  # perfect
            if pair_policies:
                quality = 2  # has intentional destroys
            if pair_gaps:
                quality = 0  # has unresolved gaps

            coverage_by_pair[pair_key] = {
                "quality": quality,
                "gaps": pair_gaps,
                "policies": pair_policies,
            }

    # === REPORT ===
    q_counts = {0: 0, 1: 0, 2: 0, 3: 0}
    for v in coverage_by_pair.values():
        q_counts[v["quality"]] += 1

    avg_q = sum(v["quality"] for v in coverage_by_pair.values()) / len(coverage_by_pair) if coverage_by_pair else 0

    print(f"PAIRS TESTED: {total_pairs}")
    print(f"UNIQUE UNIT TESTS: {total_unique_tests}")
    print(f"QUALITY DISTRIBUTION: q3(perfect)={q_counts[3]} q2(policy-destroy)={q_counts[2]} q1={q_counts[1]} q0(gaps)={q_counts[0]}")
    print(f"AVERAGE QUALITY: {avg_q:.2f}/3.0")
    print()

    if gaps:
        print(f"{'=' * 80}")
        print(f"GAPS ({len(gaps)} unit×pair combinations with destroy_no_mapping):")
        print(f"{'=' * 80}")
        seen_details = {}
        for pair, detail in gaps:
            if detail not in seen_details:
                seen_details[detail] = []
            seen_details[detail].append(pair)
        for detail, pairs in sorted(seen_details.items()):
            print(f"\n  {detail}")
            print(f"    Affected pairs ({len(pairs)}): {', '.join(pairs[:8])}")
            if len(pairs) > 8:
                print(f"    ... and {len(pairs) - 8} more")
    else:
        print("*** ZERO GAPS — all unit×pair combinations resolve ***")
    print()

    if destroy_policy:
        print(f"{'=' * 80}")
        print(f"INTENTIONAL DESTROY POLICIES ({len(destroy_policy)} unit×pair combinations):")
        print(f"{'=' * 80}")
        seen = {}
        for pair, detail in destroy_policy:
            if detail not in seen:
                seen[detail] = 0
            seen[detail] += 1
        for detail, count in sorted(seen.items(), key=lambda x: -x[1]):
            print(f"  [{count:3d} pairs] {detail}")
    print()

    # Gap pairs detail
    gap_pairs = sorted(set(p for p, _ in gaps))
    if gap_pairs:
        print(f"{'=' * 80}")
        print(f"GAP PAIRS ({len(gap_pairs)} pairs with at least one unresolved unit):")
        print(f"{'=' * 80}")
        for p in gap_pairs:
            info = coverage_by_pair[p]
            print(f"  {p}: {len(info['gaps'])} gap(s)")
            for g in info['gaps']:
                print(f"    - {g}")
    print()

    # PASS/FAIL verdict
    print("=" * 80)
    critical_gaps = [g for g in gaps if "UNMAPPED" in g[1]]
    fixable_gaps = [g for g in gaps if "handcannoneer" in g[1]]
    design_gaps = [g for g in gaps if g not in critical_gaps and g not in fixable_gaps]
    
    print(f"CRITICAL GAPS (unmapped units): {len(critical_gaps)}")
    print(f"DESIGN GAPS (no equivalent unit exists): {len(fixable_gaps) + len(design_gaps)}")
    print(f"  - handcannoneer→civ with no gunpowder: {len(fixable_gaps)}")
    print(f"  - other: {len(design_gaps)}")
    print()
    
    if critical_gaps:
        print("VERDICT: *** FAIL *** — unmapped unit types found")
    elif len(gaps) <= 5:
        print("VERDICT: *** PASS *** — all gaps are design-acceptable (≤5)")
    elif avg_q >= 2.0:
        print(f"VERDICT: *** PASS (with known gaps) *** — avg quality {avg_q:.2f} ≥ 2.0, {len(gap_pairs)} pairs affected")
    else:
        print(f"VERDICT: *** FAIL *** — avg quality {avg_q:.2f} < 2.0")
    print("=" * 80)


if __name__ == "__main__":
    main()
