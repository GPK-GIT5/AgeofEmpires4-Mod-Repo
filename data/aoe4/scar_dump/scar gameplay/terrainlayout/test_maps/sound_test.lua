
n = tt_none

h = tt_hills
m = tt_mountains
i = tt_impasse_mountains
k = tt_mountains_small
b = tt_hills_high_rolling
o = tt_ocean
u = tt_plains
f = tt_flatland
s = tt_campaign_starting_pos
bb = tt_bounty_berries_flatland
p = tt_hills_plateau
pt = tt_hills_plateau_test
v = tt_valley
vs = tt_valley_shallow
bg = tt_bounty_gold_plains
c = tt_plains_clearing

f1 = tt_impasse_trees_plains
f2 = tt_impasse_trees_hills_low_rolling
f3 = tt_impasse_trees_hills_high_rolling

cc = tt_city_centre
cf = tt_city_farming
cm = tt_city_military
cl = tt_city_lumbercamp
cs = tt_city_stonecamp
cg = tt_city_goldcamp

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

terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)


--Whole terrain combo tests
-- setting up the map grid

--[[
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, v, n, n, n, n, n, n}
, {n, n, n, n, v, n, n, n, n, n, n}
, {n, n, n, n, v, m, n, n, n, n, n}
, {n, n, n, n, v, n, n, n, n, n, n}
, {n, n, n, n, v, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}
]]--

terrainLayoutResult[1][1].playerIndex = 0
terrainLayoutResult[1][1].terrainType = s
terrainLayoutResult[gridSize-1][gridSize-1].playerIndex = 1
terrainLayoutResult[gridSize-1][gridSize-1].terrainType = s

terrainLayoutResult[10][11].terrainType = m
terrainLayoutResult[11][10].terrainType = v
terrainLayoutResult[12][10].terrainType = v
terrainLayoutResult[9][10].terrainType = v
terrainLayoutResult[8][10].terrainType = v
terrainLayoutResult[10][10].terrainType = v

