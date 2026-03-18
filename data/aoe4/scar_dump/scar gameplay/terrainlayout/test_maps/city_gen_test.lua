
n = tt_none

h = tt_hills
ht = tt_hills_high_test
hr = tt_hills_rocky
m = tt_mountains
i = tt_impasse_mountains
k = tt_mountains_small
b = tt_hills_high_rolling
o = tt_ocean
u = tt_plains
f = tt_flatland
s = tt_player_start_classic_hills_high_rolling
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
ccr = tt_city_crafts
cf = tt_city_farming
cm = tt_city_military
cm2 = tt_city_military_small
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
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)


terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

--fill map with plains
for i = 1, gridSize do
	for j = 1, gridSize do
	
		terrainLayoutResult[i][j].terrainType = u
	
	end
end

terrainLayoutResult[1][1].playerIndex = 1
terrainLayoutResult[1][1].terrainType = u
--terrainLayoutResult[gridSize-1][gridSize-1].playerIndex = 1
terrainLayoutResult[gridSize-1][gridSize-1].terrainType = u

--place city centre on centre marker location
terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = cc
terrainLayoutResult[mapHalfSize][mapHalfSize].playerIndex = 0

terrainLayoutResult[mapHalfSize-1][mapHalfSize].terrainType = cm
terrainLayoutResult[mapHalfSize-1][mapHalfSize].playerIndex = 0

terrainLayoutResult[mapHalfSize+1][mapHalfSize+1].terrainType = cf
terrainLayoutResult[mapHalfSize+1][mapHalfSize+1].playerIndex = 0

terrainLayoutResult[mapHalfSize+1][mapHalfSize].terrainType = ccr
terrainLayoutResult[mapHalfSize+1][mapHalfSize].playerIndex = 0

terrainLayoutResult[mapHalfSize + 2][mapHalfSize].terrainType = cl
terrainLayoutResult[mapHalfSize + 2][mapHalfSize].playerIndex = 0

terrainLayoutResult[mapHalfSize][mapHalfSize - 1].terrainType = cg
terrainLayoutResult[mapHalfSize][mapHalfSize - 1].playerIndex = 0

