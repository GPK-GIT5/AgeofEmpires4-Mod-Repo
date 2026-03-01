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

--When placing terrain for islands, remember that the ocean terrain tiles act almost like "valleys" in that they have low overall land height
--Forming islands requires terrain to be higher than the water line. Hills will add their height together to rise land up out of the water
--forming an island with just plains may not get you the island shape you want, as it may not pull the land up out of the water (especially with higher grid resolutions)

p = { terrainType = tt_plains  }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains }
i = { terrainType = tt_impasse_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }
o = { terrainType = tt_ocean }
x = { terrainType = tt_lake_shallow}

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



--here is a blank grid filled with ocean
--replace the ocean tiles with plains, hills and cliffs to create islands
--if bunched together, most regular land tiles will form islands, but single squares of lower terrain may not poke out above water

--feel free to copy this grid, or simply uncomment and edit this grid directly
--[[
terrainLayoutResult =
{ {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
}
--]]

--here is a sample island map for 2 players that copies a "migration" style
--this map will work on any of our sizes, and will scale up to the larger sizes even with a smaller grid resolution
--this will result in each island being larger, but the overall shapes remaining similar
--[[
terrainLayoutResult =
{ {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, g, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, g, g, g, o, o, o, o, o, o, o, o, o, o, g, g, o, o, o}
, {o, o, g,q0, g, g, o, o, o, o, o, o, o, o, g, g, g, g, o, o}
, {o, g, g, g, g, g, o, o, o, o, o, o, o, o, g, g, g, o, o, o}
, {o, o, g, g, o, o, o, o, o, o, o, o,p1, g, g, g, g, o, o, o}
, {o, o, o, g, o, o, o, o, g,p1,p1,p1, d, g, g, g, g, o, o, o}
, {o, o, o, o, o, o, o, o, g, g, g, d, g, g, g, g, o, o, o, o}
, {o, o, o, o, o, o, o, g, g, g, g, g, g, g, g, g, o, o, o, o}
, {o, o, o, o, o, o, g, g, g, g, g, g, g, g, g, o, o, o, o, o}
, {o, o, o, g, g, g, g, g, g, g, g, g, g, g, o, o, o, o, o, o}
, {o, o, o, g, g, g, g, g, g, g, g, g, g, o, o, o, o, o, o, o}
, {o, o, g, g, g, g, g, g, g, g, g, o, o, o, o, o, o, o, o, o}
, {o, o, g, g, g, g, g, d,p1,p1, o, o, o, o, o, g, g, o, o, o}
, {o, o, g, g, g, g,p1,p1, o, o, o, o, o, o, o, g, g, o, o, o}
, {o, o, g, g, g, o, o, o, o, o, o, o, o, g, g, g, g, g, o, o}
, {o, o, g, g, o, o, o, o, o, o, o, o, g, g, g,q1, g, g, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, g, g, g, g, g, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, g, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
}
--]]


--this grid is a higher resolution grid, used to either get more specific shapes for your islands, or to generate larger maps
--note: grids of this size will be less effective when generating smaller map sizes, as each square takes up less overall land space.
--for example, mountains created at this scale individually will sometimes not be large enough to produce mountainous terrain.
--for best results, use this grid size with larger map sizes
--[[
terrainLayoutResult =
{ {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
}
--]]

--here is a sample island map with 4 players
--note: this layout works best on 768 and 896 map sizes. On smaller sizes, the islands may not form as intended
--always be aware of your grid resolution when generating maps at various sizes - making a larger grid will not increase the amount of land space you have to work with!
--note: the q0 - q3 terrain types contain player starts. when generating this map with those terrain types in place, you need to generate with 4 players, or you can remove them

terrainLayoutResult =
{ {o, o, o, o, o, o, o, o, o, o, o, o, o, o, g, g, g, g, g, g, g, g, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, g, g, o, o, o, o, g, g, g, g, g, g, g, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, g, g, g, g, g, g, g, g, g, g, o, o, g, g, g, g, g, g, g, o, o, o,p1, g, g, g, g, g, o, o}
, {o, o, g, g, g, g, g, g, g, g, g, g, o, o, g, g, g, g, g, g, g, o, o, o,p1, d, g, g, g, g, o, o}
, {o, o, g, g,q0, g, g, g, g, g, g,p1, o, o, o, o, o, o, g, g, g, o, o,p1, d, g, g,q1, g, g, o, o}
, {o, g, g, g, g, g, g, o, o, g, g,p1, o, o, o, o, o, o, o, g, g, o, o,p1, g, g, g, g, g, g, o, o}
, {o, o, g, g, g, g, o, o, o,p1,p1, o, o, o, o, o, g, o, o, o, o, o, o, g, g, g, g, g, g, g, o, o}
, {o, o, o, g, g, g, o, o, o, o, o, o, o, o, o, g, g, o, o, o, o, o, o, o, g, g, g, g, g, g, o, o}
, {o, o, o, g, g, d, g, o, o, o, o, o, o, o, g, g, g, o, o, o, o, o, o, g, g, g, g, g, g, o, o, o}
, {o, o, o, o,p1,p1,p1, o, o, o, o, o, o, o, g, g, g, g, o, o, o, o, o,p1, d, d, g, g, g, o, o, o}
, {o, o, o, o,p1,p1,p1, o, o, o, o, o, g, g, g, g, g, g, g, o, o, o, o,p1,p1,p1, g, g, g, g, o, o}
, {o, g, o, o, o, o, o, o, o, o, o, o, g, g, g, g, g, g, g, o, o, o, o, o,p1,p1, o, o, g, g, g, o}
, {o, g, g, o, o, o, o, o, o, o, o, o, g, g, g, m, g, g, g, g, g, o, o, o, o, o, o, o, o, o, o, o}
, {o, g, g, g, g, o, o, o, o, o, g, g, g, g, m, i, m, g, g, g, g, g, o, o, o, o, o, o, o, o, o, o}
, {o, g, g, g, g, o, o, o, o, g, g, g, g, g, m, i, m, g, g, g, g, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, g, g, o, o, o, o, o, o, g, g, g, g, g, m, g, g, g, o, o, o, g, g, o, o, o, g, g, g, g, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, g, g, g, g, g, g, g, o, o, o, g, g, g, o, o, g, g, g, g, g}
, {o, o, o, o, g, o, o, o, o, o, o, o, o, g, g, g, g, g, o, o, o, g, g, g, g, o, o, g, g, g, g, g}
, {o, o, o, o,p1,p1, o, o, o, o, o, o, o, o, g, g, o, o, o, o, o, o, g, g, g, o, o, o, g, g, g, g}
, {o, o, o, o,p1,p1,p1, g, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, g, g, o}
, {o, o, o, g, d, d, g, g, o, o, o, o, o, o, o, o, o, g, g, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, g, g, g, g, g, o, o, o, o, o, o, o, o, g, g, g, g, o, o, o, o, o, g, g, g, o, o, o, o}
, {o, o, g, g, g, g, o, o, o, o, o, o, o, o, o, o, o, g, g, g, o, o, o,p1,p1, d, g, g, o, o, o, o}
, {o, o, o, g, g, g, g, o, o, o, o, o, g, g, g, o, o, g, o, o, o, o, g,p1,p1, d, g, g, o, o, o, o}
, {o, o, g, g, g, g,p1, o, o, o, o, g, g, g, g, g, o, o, o, o, o, o, o, o, o, g, g, g, g, g, o, o}
, {o, o, g, g, g, g,p1, o, o, o, g, g, p, x, p, g, o, o, o, o, o, o, o, o, o, g, g, g, g, g, o, o}
, {o, o, g, g, g, g,p1, o, o, o, o, g, x, x, x, g, o, o, o, o,p1,p1, o, o, o, o, g, g, g, g, o, o}
, {o, o, g, g,q3, g, g, g, o, o, o, g, p, x, p, g, o, o, o,p1, d, d, g, o, g, g, g,q2, g, g, o, o}
, {o, o, g, g, g, g, g, g, g, o, o, g, g, g, g, g, o, o, o,p1, d, g, g, g, g, g, g, g, g, o, o, o}
, {o, o, o, o, o, g, g, g, g, o, o, o, g, g, g, g, g, o, o,p1, g, o, g, g, g, o, o, g, g, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
, {o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o}
}
