-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
terrainLayoutResult = {}    -- set up initial table for coarse map grid

--setting useful variables to reference world dimensions
mapRes = 25
gridWidth, gridHeight, gridSize = SetCustomCoarseGrid(mapRes)

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map
--NOTE: AoE4 MapGen is designed to generate square maps. The grid you will be working with will always need to have gridWidth = gridHeight

--set the number of players
playerStarts = worldPlayerCount
n = { terrainType = tt_none }

p = { terrainType = tt_plains  }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }
o = { terrainType = tt_ocean }

--cliff terrain types
p0 = { terrainType = tt_plains_cliff }
p1 = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_med }
p3 = { terrainType = tt_plateau_high }
q0 = { terrainType = tt_player_start_classic_plains, playerIndex = 0 }
q1 = { terrainType = tt_player_start_classic_plains, playerIndex = 1 }
q2 = { terrainType = tt_player_start_classic_plains, playerIndex = 2 }
q3 = { terrainType = tt_player_start_classic_plains, playerIndex = 3 }
q4 = { terrainType = tt_player_start_classic_plains, playerIndex = 4 }
q5 = { terrainType = tt_player_start_classic_plains, playerIndex = 5 }
q6 = { terrainType = tt_player_start_classic_plains, playerIndex = 6 }
q7 = { terrainType = tt_player_start_classic_plains, playerIndex = 7 }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
--use these to spawn dense tree areas
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }


terrainLayoutResult =
{ {p, j, p, p, j, p, o, o, o, o, p, j, p, p, p, o, o, o, p, p, j, p, p, j, p}
, {p, p, p, p, n, n, o, o, o, o, o, n, n, n, n, n, o, o, o, n, n, p, p, p, j}
, {j, p, q6,p, p, o, o, o, o, o, o, n, n, n, n, n, o, o, o, n, p, p, q2,p, p}
, {p, p, p, p, n, o, o, o, o, o, o, o, o, o, o, n, o, o, o, o, n, p, p, p, p}
, {j, n, p, n, n, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, n, n, p, n, j}
, {p, n, n, n, n, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, n, n, n, n, p}
, {p, n, n, n, o, o, o, o, o, n, p, n, n, n, o, o, o, o, o, o, n, n, n, n, p}
, {o, o, o, o, o, o, o, o, n, p, p, p, n, n, n, o, o, o, o, o, n, n, n, n, j}
, {o, o, o, o, o, o, o, n, p, p, q4,p, p, n, n, n, o, o, o, o, o, n, n, n, p}
, {o, o, o, o, o, o, o, n, n, p, p, p, n, n, n, n, n, o, o, o, o, n, p, n, j}
, {o, o, o, o, o, o, o, n, n, n, p, n, n, n, n, n, o, o, o, o, n, p, p, p, p}
, {o, o, o, o, o, o, o, o, n, n, n, n, n, n, n, n, o, o, o, o, p, p, q3,p, p}
, {o, o, o, o, o, o, o, o, o, o, n, n, n, n, p, n, o, o, o, o, n, p, p, p, j}
, {p, n, o, o, o, o, o, o, o, o, n, n, n, p, p, p, n, o, o, o, n, n, p, n, p}
, {p, n, p, n, o, o, o, o, o, o, o, n, p, p, q5,p, p, o, o, o, o, n, n, n, p}
, {p, p, p, p, n, o, o, o, o, o, o, o, n, p, p, p, n, n, o, o, o, o, o, n, p}
, {j, p, q0,p, p, n, o, o, o, o, o, o, n, n, p, n, n, n, o, o, o, o, o, o, o}
, {p, p, p, p, n, n, n, o, o, o, o, o, o, n, n, n, n, n, o, o, o, o, o, o, o}
, {p, n, p, n, n, n, n, o, o, o, o, o, o, o, n, n, n, o, o, o, o, o, o, o, o}
, {j, n, n, n, n, n, n, o, o, o, o, o, o, o, n, n, o, o, o, o, o, o, o, o, o}
, {p, n, n, n, n, n, p, n, n, o, o, o, o, o, o, o, o, o, o, o, o, n, n, n, p}
, {p, n, n, n, n, p, p, p, n, n, o, o, o, o, o, o, o, o, o, o, n, n, p, n, p}
, {j, n, n, n, p, p, q1,p, p, n, n, o, o, o, o, o, o, o, n, n, n, p, p, p, j}
, {p, n, n, n, n, p, p, p, n, n, n, o, o, o, o, o, n, n, n, n, p, p, q7,p, p}
, {p, j, p, p, j, p, p, j, p, j, p, p, o, o, o, p, p, j, p, j, p, j, p, j, p}
}