--IF YOU ARE CREATING A CUSTOM LAYOUT----------------------------------------------------------

--uncomment the following section if you want to use the grid to layout a specific map style

terrainLayoutResult = {}    -- set up initial table for coarse map grid

--setting useful variables to reference world dimensions. This sets the map to our defualt resolution of 40m per grid square, which is reccommended.
--when generating our maps, each square on the grid is represented by a terrain type (hills, mountain, plains, etc) whose height is determined
--by a height/width calculation. When you change grid resolution, this calculation is affected. For example, with a higher resolution grid
--(for example 25m vs the standard 40m), all terrain features will be generated smaller, which in the case of things like mountains, can
--affect their ability to create impasse on the map. Use a custom resolution at your own discretion, but do not expect that all terrain
--will work as intended. Terrain types have been tuned at the default 40m resolution. 
gridHeight, gridWidth, gridSize = SetCoarseGrid()

--If you wish to set a custom resolution, use the following function. A higher resolution, keeping the caveats in mind, is often useful for making
--things like island maps, or maze-like maps where you need higher granularity in your terrain features.
--gridRes = 25
--gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(gridRes)

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map
--NOTE: AoE4 MapGen is designed to generate square maps. The grid you will be working with will always need to have gridWidth = gridHeight

--set the number of players. this info is grabbed from the lobby
playerStarts = worldPlayerCount


p = { terrainType = tt_plains  }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }
o = { terrainType = tt_ocean }

--lake terrain
ls = { terrainType = tt_lake_shallow }
ld = { terrainType = tt_lake_deep }

--cliff terrain types
p0 = { terrainType = tt_plains_cliff }
p1 = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_standard }
p3 = { terrainType = tt_plateau_med }
p4 = { terrainType = tt_plateau_high }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
--use these to spawn dense tree areas
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }
s = { terrainType = tt_trees_plains_stealth }




q0 = { terrainType = tt_player_start_classic_plains, playerIndex = 0 }
q1 = { terrainType = tt_player_start_classic_plains, playerIndex = 1 }
q2 = { terrainType = tt_player_start_classic_plains, playerIndex = 2 }
q3 = { terrainType = tt_player_start_classic_plains, playerIndex = 3 }
q4 = { terrainType = tt_player_start_classic_plains, playerIndex = 4 }
q5 = { terrainType = tt_player_start_classic_plains, playerIndex = 5 }
q6 = { terrainType = tt_player_start_classic_plains, playerIndex = 6 }
q7 = { terrainType = tt_player_start_classic_plains, playerIndex = 7 }


--Additionally, here are 3 map grids that start with empty ocean. Great for creating your own island maps!

--512 ocean template
terrainLayoutResult =
{ {o, o, o, o, o, o, p, p, p, p, p, p, p}
, {o, o, o, o, o, o, p, p, p, p, p, q1, p}
, {o, o, o, o, o, o, p, p, j, j, j, p, p}
, {o, o, o, o, o, o, p, p, j, j, j, p, p}
, {o, o, o, o, o, o, p, p, p, p, p, p, p}
, {o, o, o, o, o, o, p, p, p, p, p, p, p}
, {o, o, o, o, o, o, p, p, p, p, p, p, p}
, {o, o, o, o, o, o, p, p, p, p, p, p, p}
, {o, o, o, o, o, o, p, p, s, s, s, p, p}
, {o, o, o, o, o, o, p, p, s, s, s, p, p}
, {o, o, o, o, o, o, p, p, p, p, p, p, p}
, {o, o, o, o, o, o, p, p, p, p, p, q0, p}
, {o, o, o, o, o, o, p, p, p, p, p, p, p}
}