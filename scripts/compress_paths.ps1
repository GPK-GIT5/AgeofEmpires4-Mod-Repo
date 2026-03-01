$file = "c:\Users\Jordan\Documents\AoE4-Workspace\mods\Japan\assets\scenarios\multiplayer\coop_4_japanese\scar\coop_4_japanese_data.scar"
$content = [System.IO.File]::ReadAllText($file)
$t = "`t"

$old = @"
-- Marker Compositions
function Unit_Path_Data()

	-- Allied Waves
	ally_assault_1 = {
		mkr_ally_raid1_1,
		mkr_ally_raid1_2,
		mkr_ally_raid1_3, 
	} -- Village raid #1
	ally_assault_2 = {
		mkr_ally_raid2_1,
		mkr_ally_raid2_2,
		mkr_ally_raid2_3,
		mkr_ally_raid2_4,
	} -- Village raid #2
	ally_assault_3 = {
		mkr_ally_raid3_1,
		mkr_ally_raid3_2,
		mkr_ally_raid3_3,
		mkr_ally_raid3_4,
	} -- Village raid #3
	ally_assault_4 = {
		mkr_ally_raid4_1,
		mkr_ally_raid4_2,
		mkr_ally_raid4_3, 
	} -- Village raid #4
	
	ally_siege_1 = {
		mkr_ally_raid1_1,
		mkr_ally_raid1_2,
		mkr_ally_raid1_3, 
		mkr_spawn_south_1,
		mkr_dest_siege_1,
		mkr_dest_siege_keep1,
		mkr_dest_gate_1,
		mkr_dest_siege_keep2,
	} -- City raid #1
	ally_siege_2 = {
		mkr_ally_raid2_1,
		mkr_ally_raid2_2,
		mkr_ally_raid2_3,
		mkr_ally_raid2_4, 
		mkr_spawn_south_1,
		mkr_dest_siege_2,
		mkr_dest_siege_keep1,
		mkr_dest_gate_1,
		mkr_dest_siege_keep2,
	} -- City raid #2
	ally_siege_3 = {
		mkr_ally_raid3_1,
		mkr_ally_raid3_2,
		mkr_ally_raid3_3,
		mkr_ally_raid3_4,
		mkr_spawn_south_2,
		mkr_dest_siege_3,
		mkr_dest_siege_keep2,
		mkr_dest_gate_2,
		mkr_dest_siege_keep1,
	} -- City raid #3
	
	-- Attack Waves
	wave_path_1 = {
		mkr_wave_1_path_1,
		mkr_wave_1_path_2,
		mkr_wave_1_path_3,
		mkr_wave_1_path_4,
		mkr_wave_path_village,
		mkr_village_main_2,
		mkr_objective_tc,
	}
	wave_path_1_flank = {
		mkr_wave_1_path_1,
		mkr_wave_1_path_2,
		mkr_wave_1_path_3,
		mkr_wave_1_path_4,
		mkr_wave_1_flank_1,
		mkr_wave_1_flank_2,
		mkr_objective_tc,
	}
	wave_path_1_resources = {
		mkr_wave_1_start_flank,
		mkr_wave_1_path_4,
		mkr_wave_resources_1,
		mkr_wave_1_resources_1,
		mkr_wave_1_resources_2,
		mkr_wave_1_resources_3,
		mkr_objective_tc, -- TC #1
	}
	-- Wave Side #2
	wave_path_2 = {
		mkr_wave_mid_path_1,
		mkr_wave_mid_path_2,
		mkr_wave_mid_path_3,
		mkr_wave_mid_path_4,
		mkr_wave_path_village,
		mkr_village_main_2,
		mkr_objective_tc,
	}
	wave_path_2_flank = {
		mkr_wave_2_path_1,
		mkr_wave_2_path_2,
		mkr_wave_path_village,
		mkr_wave_resources_1,
		mkr_wave_2_compound,
		mkr_wave_2_trade,
		mkr_wave_2_flank_1,
		mkr_wave_2_flank_2,
		mkr_village_main_2,
		mkr_objective_tc,
	}
	wave_path_2_resources = {
		mkr_wave_mid_path_1,
		mkr_wave_2_path_2,
		mkr_wave_path_village,
		mkr_wave_resources_1,
		mkr_wave_resources_2,
		mkr_wave_resources_3,
		mkr_wave_2_trade,
		mkr_wave_2_compound,
		mkr_wave_2_flank_1,
		mkr_wave_2_flank_2,
		mkr_village_main_2,
		mkr_objective_tc,
	}
	
	-- Patrols
	patrol_village_main = {
		mkr_village_main_3,
		mkr_village_main_2,
		mkr_village_main_1a,
		mkr_wave_2_flank_2,
		mkr_village_main_1a,
		mkr_wave_1_resources_3,
		mkr_village_main_1a,
		mkr_village_main_3,
	}
	patrol_village_1 = {
		mkr_wave_2_resources_2,
		mkr_wave_2_resources_3,
		mkr_wave_2_trade,
		mkr_wave_2_compound,
		mkr_wave_1_resources_1,
		mkr_side_1_compound,
		mkr_wave_1_flank_2,
		mkr_wave_1_resources_3,
		mkr_wave_2_resources_2,
		mkr_wave_2_resources_3,
		mkr_wave_2_trade,
		mkr_wave_2_compound,
	}
	patrol_village_2 = {
		mkr_wave_1_resources_1,
		mkr_side_1_compound,
		mkr_wave_1_flank_2,
		mkr_wave_1_resources_3,
		mkr_wave_2_resources_2,
		mkr_wave_2_resources_3,
		mkr_wave_2_trade,
		mkr_wave_2_compound,
		mkr_wave_1_resources_1,
		mkr_side_1_compound,
	}
	patrol_city_1 = {
		mkr_dest_siege_keep1,
		mkr_dest_siege_keep2,
		mkr_wave_1_spawn,
	}
	patrol_city_2 = {
		mkr_dest_siege_keep2,
		mkr_dest_siege_keep1,
		mkr_spawn_wave_4,
	}
	
end -- Path needs to be called from this function first
"@

$new = @"
-- Marker path compositions (single-line for compactness)
function Unit_Path_Data()
${t}-- Allied Waves (village raids #1-4, city raids #1-3)
${t}ally_assault_1 = {mkr_ally_raid1_1, mkr_ally_raid1_2, mkr_ally_raid1_3}
${t}ally_assault_2 = {mkr_ally_raid2_1, mkr_ally_raid2_2, mkr_ally_raid2_3, mkr_ally_raid2_4}
${t}ally_assault_3 = {mkr_ally_raid3_1, mkr_ally_raid3_2, mkr_ally_raid3_3, mkr_ally_raid3_4}
${t}ally_assault_4 = {mkr_ally_raid4_1, mkr_ally_raid4_2, mkr_ally_raid4_3}
${t}ally_siege_1 = {mkr_ally_raid1_1, mkr_ally_raid1_2, mkr_ally_raid1_3, mkr_spawn_south_1, mkr_dest_siege_1, mkr_dest_siege_keep1, mkr_dest_gate_1, mkr_dest_siege_keep2}
${t}ally_siege_2 = {mkr_ally_raid2_1, mkr_ally_raid2_2, mkr_ally_raid2_3, mkr_ally_raid2_4, mkr_spawn_south_1, mkr_dest_siege_2, mkr_dest_siege_keep1, mkr_dest_gate_1, mkr_dest_siege_keep2}
${t}ally_siege_3 = {mkr_ally_raid3_1, mkr_ally_raid3_2, mkr_ally_raid3_3, mkr_ally_raid3_4, mkr_spawn_south_2, mkr_dest_siege_3, mkr_dest_siege_keep2, mkr_dest_gate_2, mkr_dest_siege_keep1}
${t}-- Attack Waves (side #1: main, flank, resources; side #2: main, flank, resources)
${t}wave_path_1 = {mkr_wave_1_path_1, mkr_wave_1_path_2, mkr_wave_1_path_3, mkr_wave_1_path_4, mkr_wave_path_village, mkr_village_main_2, mkr_objective_tc}
${t}wave_path_1_flank = {mkr_wave_1_path_1, mkr_wave_1_path_2, mkr_wave_1_path_3, mkr_wave_1_path_4, mkr_wave_1_flank_1, mkr_wave_1_flank_2, mkr_objective_tc}
${t}wave_path_1_resources = {mkr_wave_1_start_flank, mkr_wave_1_path_4, mkr_wave_resources_1, mkr_wave_1_resources_1, mkr_wave_1_resources_2, mkr_wave_1_resources_3, mkr_objective_tc}
${t}wave_path_2 = {mkr_wave_mid_path_1, mkr_wave_mid_path_2, mkr_wave_mid_path_3, mkr_wave_mid_path_4, mkr_wave_path_village, mkr_village_main_2, mkr_objective_tc}
${t}wave_path_2_flank = {mkr_wave_2_path_1, mkr_wave_2_path_2, mkr_wave_path_village, mkr_wave_resources_1, mkr_wave_2_compound, mkr_wave_2_trade, mkr_wave_2_flank_1, mkr_wave_2_flank_2, mkr_village_main_2, mkr_objective_tc}
${t}wave_path_2_resources = {mkr_wave_mid_path_1, mkr_wave_2_path_2, mkr_wave_path_village, mkr_wave_resources_1, mkr_wave_resources_2, mkr_wave_resources_3, mkr_wave_2_trade, mkr_wave_2_compound, mkr_wave_2_flank_1, mkr_wave_2_flank_2, mkr_village_main_2, mkr_objective_tc}
${t}-- Patrols
${t}patrol_village_main = {mkr_village_main_3, mkr_village_main_2, mkr_village_main_1a, mkr_wave_2_flank_2, mkr_village_main_1a, mkr_wave_1_resources_3, mkr_village_main_1a, mkr_village_main_3}
${t}patrol_village_1 = {mkr_wave_2_resources_2, mkr_wave_2_resources_3, mkr_wave_2_trade, mkr_wave_2_compound, mkr_wave_1_resources_1, mkr_side_1_compound, mkr_wave_1_flank_2, mkr_wave_1_resources_3, mkr_wave_2_resources_2, mkr_wave_2_resources_3, mkr_wave_2_trade, mkr_wave_2_compound}
${t}patrol_village_2 = {mkr_wave_1_resources_1, mkr_side_1_compound, mkr_wave_1_flank_2, mkr_wave_1_resources_3, mkr_wave_2_resources_2, mkr_wave_2_resources_3, mkr_wave_2_trade, mkr_wave_2_compound, mkr_wave_1_resources_1, mkr_side_1_compound}
${t}patrol_city_1 = {mkr_dest_siege_keep1, mkr_dest_siege_keep2, mkr_wave_1_spawn}
${t}patrol_city_2 = {mkr_dest_siege_keep2, mkr_dest_siege_keep1, mkr_spawn_wave_4}
end
"@

$idx = $content.IndexOf($old)
if ($idx -lt 0) {
    Write-Host "ERROR: Could not find marker path block" -ForegroundColor Red
    exit 1
}

$before = $content.Substring(0, $idx)
$after = $content.Substring($idx + $old.Length)
$result = $before + $new + $after

[System.IO.File]::WriteAllText($file, $result)
$lines = ($result -split "`n").Count
Write-Host "SUCCESS: Marker paths compressed. New line count: $lines" -ForegroundColor Green
