-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING ROLLING RIVERS")

terrainLayoutResult = {}

gridHeight, gridWidth, gridSize = SetCoarseGrid()

if (gridHeight % 2 == 0) then
	gridHeight = gridHeight -1
end

if (gridWidth % 2 == 0) then
	gridWidth = gridWidth -1
end

gridSize = gridWidth

playerStarts = worldPlayerCount

n = tt_none
h = tt_hills
s = tt_mountains_small
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_low_rolling
mr = tt_hills_med_rolling
hr = tt_hills_high_rolling
low = tt_plateau_low
med = tt_plateau_med
high = tt_plateau_high
p = tt_plains
t = tt_impasse_trees_plains
v = tt_valley
r = tt_river
o = tt_ocean

mapRes = 24
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(mapRes)

-- setting up the map terrain using the function in the map_setup lua file in the library folder
terrainLayoutResult = SetUpGrid(gridSize, p, terrainLayoutResult)



playerStartTerrainHill = tt_player_start_classic_hills_low_rolling -- classic mode start
playerStartTerrainPlain = tt_player_start_classic_plains

teamsList, playersPerTeam = SetUpTeams()

teamMappingTable = CreateTeamMappingTable()

------------------------
--REFERENCE VALUES
------------------------

--bounty squares are used to populate an area of the map with extra resources
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains

--the following are markers used to determine player and settlement spawn points
s = tt_player_start_hills
sp = tt_settlement_plains
sh = tt_settlement_hills
seb = tt_settlement_hills_high_rolling

--reference values
baseGridSize = 13
outerRadius = 3.5 / baseGridSize * gridSize
middleRadius = 2.5 / baseGridSize * gridSize
innerRadius = 1.25 / baseGridSize * gridSize
mapHalfSize = math.ceil(gridSize / 2)
mapThirdSize = math.ceil(gridSize / 3)
mapQuarterSize = math.ceil(gridSize / 4)
mapEighthSize = math.ceil(gridSize / 8)

------------------------
--RIVERS
------------------------

--sets up start/end points for rivers based on the orientation
riverPoints = {}

--draw the first arm of U shape
riverRow1 = mapThirdSize 
riverCol1 = #terrainLayoutResult
riverRow2 = mapThirdSize 
riverCol2 = mapThirdSize
riverPoints = DrawLineOfTerrainNoDiagonal(riverRow1, riverCol1, riverRow2, riverCol2, true, r, gridSize, terrainLayoutResult)

--loop through and record all these points in river table
riverTable = {}
for riverPointIndex = 1, #riverPoints do
	
	table.insert(riverTable, riverPoints[riverPointIndex])
end
terrainLayoutResult[riverRow1][riverCol1].terrainType = tt_river --ensures that the first point is a river tile

riverPoints = {}

--draw the second arm of U shape
riverRow1 = mapThirdSize + 1
riverCol1 = mapThirdSize
riverRow2 = #terrainLayoutResult - mapThirdSize + 1
riverCol2 = mapThirdSize
riverPoints = DrawLineOfTerrainNoDiagonal(riverRow1, riverCol1, riverRow2, riverCol2, true, r, gridSize, terrainLayoutResult)

for riverPointIndex = 1, #riverPoints do
	
	table.insert(riverTable, riverPoints[riverPointIndex])
end
terrainLayoutResult[riverRow1][riverCol1].terrainType = tt_river --ensures that the first point is a river tile

--draw final arm of U shape
riverRow1 = #terrainLayoutResult - mapThirdSize + 1
riverCol1 = mapThirdSize + 1
riverRow2 = #terrainLayoutResult - mapThirdSize + 1
riverCol2 = #terrainLayoutResult
riverPoints = DrawLineOfTerrainNoDiagonal(riverRow1, riverCol1, riverRow2, riverCol2, true, r, gridSize, terrainLayoutResult)

for riverPointIndex = 1, #riverPoints do
	
	table.insert(riverTable, riverPoints[riverPointIndex])
end
terrainLayoutResult[riverRow1][riverCol1].terrainType = tt_river --ensures that the first point is a river tile
-- generate river result table for river generation
riverResult = {} -- river result table must be named this to create rivers
table.insert(riverResult, 1, riverTable)

-- debug output of river results
for index = 1, #riverResult do

	for pIndex = 1, #riverResult[index] do
		x = riverResult[index][pIndex][1]
		y = riverResult[index][pIndex][2]
		print("** River " ..index .." Point " ..pIndex .." Row " ..x ..", Column " ..y)
	end

end

-- generate ford result table for ford generation
fordResults = {} -- must be named this to place fords
fordTable = {} -- temp place to hold main river ford points
woodBridgeResults = {} -- must be named this to place stone bridges
woodBridgeTable = {} -- temp place to hold stone bridge points

ford1Index = math.ceil(#riverResult[1] * 0.2)
ford2Index = math.ceil(#riverResult[1] * 0.8)

table.insert(fordTable, riverResult[1][ford1Index])
print("ford 1 index is " .. ford1Index)
table.insert(fordTable, riverResult[1][ford2Index])
print("ford 2 index is " .. ford2Index)

--replacing bridge with ford for now
bridgeIndex = math.ceil(#riverResult[1] / 2)

table.insert(woodBridgeTable, riverResult[1][bridgeIndex])
print("bridge index is " .. bridgeIndex)
table.insert(fordResults, fordTable)
table.insert(woodBridgeResults, woodBridgeTable)


--fill river island with stealth woods
for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(row > mapThirdSize and row < (#terrainLayoutResult - mapThirdSize) and col > mapThirdSize) then
			if(worldTerrainHeight > 417) then
				terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth_large
			else
				terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth
			end
		end
	end
end





-------
-- PLAYER HILLS
-------

-- grab player start locations
-- check neighbors
-- set all neighbors to hills


------------------------
--HILLS GENERATION
------------------------
terrainChance = 0.3
terrainHillVariance = 0.6


for row = 1, gridSize do
	for col = 1, gridSize do
		if (terrainLayoutResult[row][col].terrainType ~= tt_river and terrainLayoutResult[row][col].terrainType ~= tt_trees_plains_stealth_large and terrainLayoutResult[row][col].terrainType ~= tt_trees_plains_stealth) then
			if(worldGetRandom() < terrainChance) then
				terrainLayoutResult[row][col].terrainType = tt_hills
			end
		end
	end
end

for row = 1, gridSize do
	for col = 1, gridSize do
		--check for the terrain type you had chosen before
		if(terrainLayoutResult[row][col].terrainType == tt_hills) then
			if(worldGetRandom() < terrainHillVariance) then
				terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
			end
		end
	end
end
			
---------------------
-- SETS ALL TILES NEXT TO RIVERS INTO PLAINS
---------------------

--GetNeighbors(xLoc, yLoc, terrainGrid)

-- loop through grid
-- if riverpoint, get neighbor (returns a table)
-- loop through returned table and check if river
-- if not river set to plains

tempNeighborList = {}

for row = 1, gridSize do
	for col = 1, gridSize do
		-- first loop that checks if the tile is a river
		if (terrainLayoutResult[row][col].terrainType == tt_river) then
			-- if river, then find all the neighbors
			tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
			
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				-- if the tile is not a river tile, then
				if(terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_river and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_settlement_plains
						and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_trees_plains_stealth) then					
					--set to plains
					terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
				end
			end			
		end
	end
end


if(worldTerrainWidth <= 416) then --for micro maps
	innerExclusion = 0.4
	minPlayerDistance = 10
	minTeamDistance = gridSize	
	stealthRes = 2
	hillWidth = math.ceil(gridSize * 0.15)
	hillHeight = math.ceil(gridSize * 0.72)
	spawnBlockDistance = 2
	holySiteHillRadius = 1
	plateauTerrain = tt_plateau_standard
	stealthTerrain = tt_trees_plains_stealth
elseif(worldTerrainWidth <= 512) then --for tiny maps
	innerExclusion = 0.4
	minPlayerDistance = 5.5
	minTeamDistance = gridSize*1.5
	stealthRes = 3
	hillWidth = math.ceil(gridSize * 0.18)
	hillHeight = math.ceil(gridSize * 0.72)
	spawnBlockDistance = 2
	holySiteHillRadius = 2
	plateauTerrain = tt_plateau_standard
	stealthTerrain = tt_trees_plains_stealth_large
elseif(worldTerrainWidth <= 640) then  --for small maps
	innerExclusion = 0.45
	minPlayerDistance = 6
	minTeamDistance = gridSize
	stealthRes = 4
	hillWidth = math.ceil(gridSize * 0.18)
	hillHeight = math.ceil(gridSize * 0.72)
	spawnBlockDistance = 3
	holySiteHillRadius = 2
	plateauTerrain = tt_plateau_standard
	stealthTerrain = tt_trees_plains_stealth_large
elseif(worldTerrainWidth <= 768) then  --for medium maps
	innerExclusion = 0.5
	minPlayerDistance = 6
	minTeamDistance = gridSize
	stealthRes = 6
	hillWidth = math.ceil(gridSize * 0.16)
	hillHeight = math.ceil(gridSize * 0.72)
	spawnBlockDistance = 3
	holySiteHillRadius = 2
	plateauTerrain = tt_plateau_standard
	stealthTerrain = tt_trees_plains_stealth_large
elseif(worldTerrainWidth <= 896) then  --for large maps
	innerExclusion = 0.45
	minPlayerDistance = 7
	minTeamDistance = gridSize
	stealthRes = 7
	hillWidth = math.ceil(gridSize * 0.15)
	hillHeight = math.ceil(gridSize * 0.72)
	spawnBlockDistance = 3
	holySiteHillRadius = 2
	plateauTerrain = tt_plateau_standard
	stealthTerrain = tt_trees_plains_stealth_large
end

if(#teamMappingTable <= 2) then
	if(worldTerrainWidth <= 416) then
		innerExclusion = 0.65
		
	elseif(worldTerrainWidth <= 512) then --for tiny maps
		innerExclusion = 0.65
		
	elseif(worldTerrainWidth <= 640) then  --for small maps
		innerExclusion = 0.7
		
	elseif(worldTerrainWidth <= 768) then  --for medium maps
		innerExclusion = 0.7
		
	elseif(worldTerrainWidth <= 896) then  --for large maps
		innerExclusion = 0.7
		
	end
end

--put double boar on island
boarRow = mapHalfSize
boarCol = mapHalfSize
terrainLayoutResult[boarRow][boarCol].terrainType = tt_boar_spawner_double


--set holy site on island
holySiteRow = mapHalfSize
holySiteCol = mapHalfSize + mapQuarterSize
terrainLayoutResult[holySiteRow][holySiteCol].terrainType = tt_holy_site_hill_danger

sacredSiteNeighbors = GetNeighbors(holySiteRow, holySiteCol, terrainLayoutResult)
		
for neighborIndex, sacredSiteNeighbor in ipairs(sacredSiteNeighbors) do
	row = sacredSiteNeighbor.x
	col = sacredSiteNeighbor.y
	
	if(terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains) then
		terrainLayoutResult[row][col].terrainType = tt_plains
	end
end

--place holy site on hill

--create the hill
for row = 1, gridSize do
	for col = 1, gridSize do
		if(row <= hillHeight and row > (gridSize - hillHeight) and col <= hillWidth and terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains) then
			if(row <= mapThirdSize or row > (gridSize - mapThirdSize)) then
				terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
			else
				terrainLayoutResult[row][col].terrainType = plateauTerrain
			end
		end
	end
end

for row = 1, gridSize do
	for col = 1, gridSize do
		if((row >= hillHeight+1 or row <= (gridSize - hillHeight)) and col <= hillWidth * 2) then
			terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
		end
	end
end

for row = 1, gridSize do
	for col = 1, gridSize do
		if(row == Round(#terrainLayoutResult/2, 0) and col <= hillWidth) then
			terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
			hillNeighbors = {}
			hillNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			for neighborIndex, hillNeighbor in ipairs(hillNeighbors) do
				neighborRow = hillNeighbor.x
				neighborCol = hillNeighbor.y
				
				if(terrainLayoutResult[neighborRow][neighborCol].terrainType == tt_plains or terrainLayoutResult[neighborRow][neighborCol].terrainType == tt_none) then
					terrainLayoutResult[neighborRow][neighborCol].terrainType = tt_hills_gentle_rolling_clearing
				end
			end
		end
		if(row == Round(#terrainLayoutResult/2, 0) and col == hillWidth) then
			terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling_clearing
		end
	end
end


for row = 1, gridSize do
	for col = 1, gridSize do
		if(row == Round(#terrainLayoutResult/2, 0) and col == 2) then
			terrainLayoutResult[row][col].terrainType = tt_holy_site_hill
			--[[
			surroundingSquares = {}
			surroundingSquares = GetAllSquaresInRingAroundSquare(row, col, holySiteHillRadius, holySiteHillRadius, terrainLayoutResult)
			
			for testNeighborIndex, testNeighbor in ipairs(surroundingSquares) do
				testNeighborRow = testNeighbor[1]
				testNeighborCol = testNeighbor[2]
				currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
				if(currentTerrainType ~= tt_settlement_plains and currentTerrainType ~= tt_holy_site_hill) then
					terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = plateauTerrain
				end
			end
			--]]
		end
	end
end

--set trade post in top corner
tradePost1Row = 2
tradePost1Col = 2
terrainLayoutResult[tradePost1Row][tradePost1Col].terrainType = tt_settlement_plains

tradePostNeighbors = GetNeighbors(tradePost1Row, tradePost1Col, terrainLayoutResult)
		
for neighborIndex, tradePostNeighbor in ipairs(tradePostNeighbors) do
	row = tradePostNeighbor.x
	col = tradePostNeighbor.y
	
	if(terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains) then
		terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
	end
end

--set trade post in other hill corner
tradePost2Row = gridHeight - 1
tradePost2Col = 2
terrainLayoutResult[tradePost2Row][tradePost2Col].terrainType = tt_settlement_plains
print("trade post at " .. tradePost2Row .. ", " .. tradePost2Col)

------------------------
-- PLAYER STARTS SETUP
------------------------

edgeBuffer = 2
cornerThreshold = 0

playerStartTerrain = tt_player_start_classic_hills_mountains

if(randomPositions == false and #teamMappingTable <= 2) then

spawnBlockers = {}
	table.insert(spawnBlockers, tt_impasse_mountains)
	table.insert(spawnBlockers, tt_mountains)
	table.insert(spawnBlockers, tt_plateau_med)
	table.insert(spawnBlockers, tt_settlement_plains)
	table.insert(spawnBlockers, tt_river)
	table.insert(spawnBlockers, tt_trees_plains_stealth_large)
	table.insert(spawnBlockers, tt_plateau_low)
	table.insert(spawnBlockers, tt_plateau_standard)
	table.insert(spawnBlockers, tt_hills_low_rolling)

else
	spawnBlockers = {}
	table.insert(spawnBlockers, tt_impasse_mountains)
	table.insert(spawnBlockers, tt_mountains)
	table.insert(spawnBlockers, tt_plateau_med)
	table.insert(spawnBlockers, tt_settlement_plains)
	table.insert(spawnBlockers, tt_river)
	table.insert(spawnBlockers, tt_trees_plains_stealth_large)
	table.insert(spawnBlockers, tt_plateau_low)
	table.insert(spawnBlockers, tt_plateau_standard)
	
end

if(randomPositions == true) then
	minPlayerDistance = minTeamDistance
end

basicTerrain = {}
table.insert(basicTerrain, tt_none)
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_plains_clearing)
table.insert(basicTerrain, tt_flatland)


--terrainLayoutResult = PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, spawnBlockers, basicTerrain, playerStartTerrain, terrainLayoutResult)
--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .35, spawnBlockers, 1, 0.05, playerStartTerrain, tt_plains, terrainLayoutResult)
if(#teamMappingTable <= 2 and worldPlayerCount > 2 and randomPositions == false) then
	terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, false, spawnBlockers, spawnBlockDistance, 0.001, playerStartTerrain, tt_plains, 1, false, terrainLayoutResult)
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, spawnBlockDistance, 0.001, playerStartTerrain, tt_plains, 1, false, terrainLayoutResult)
end

stealthResTerrain = {}
table.insert(stealthResTerrain, tt_pocket_gold_food)
table.insert(stealthResTerrain, tt_pocket_stone_food)
table.insert(stealthResTerrain, tt_bounty_stone_plains)
table.insert(stealthResTerrain, tt_bounty_gold_plains)

print("stealthRes is " .. stealthRes)

for stealthNum = 1, stealthRes do
	stealthSquares = {}
	if(worldTerrainHeight > 417) then
		stealthSquares = GetSquaresOfType(tt_trees_plains_stealth_large, gridSize, terrainLayoutResult)
	else
		stealthSquares = GetSquaresOfType(tt_trees_plains_stealth, gridSize, terrainLayoutResult)
	end
	
	randomIndex = math.ceil(worldGetRandom() * #stealthSquares)
	
	randomRow = stealthSquares[randomIndex][1]
	randomCol = stealthSquares[randomIndex][2]
	
	randomTerrainRoll = math.ceil(worldGetRandom() * #stealthResTerrain)
	chosenTerrain = stealthResTerrain[randomTerrainRoll]
	
	terrainLayoutResult[randomRow][randomCol].terrainType = chosenTerrain
	
end


print("END OF ROLLING RIVERS LUA SCRIPT")