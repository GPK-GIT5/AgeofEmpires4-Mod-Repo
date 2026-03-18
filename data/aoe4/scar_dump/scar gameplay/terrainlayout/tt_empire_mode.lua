
n = tt_none

h = tt_hills
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_high_rolling
o = tt_ocean
p = tt_plains
f = tt_flatland
s = tt_player_start_hills
bb = tt_bounty_berries_flatland
pl = tt_hills_plateau

terrainLayoutResult = {}    -- set up initial table for coarse map grid

gridHeight = Round(worldTerrainHeight / 46.5, 0) -- set resolution of coarse map rows
gridWidth = Round(worldTerrainWidth / 46.5, 0) -- set resolution of coarse map columns

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end

gridSize = gridWidth -- set resolution of coarse map


-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)