-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING ALTAI")

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout
r = tt_flatland -- flatland will not be used in the map. This is just to set a square to "random"

h = tt_hills
m = tt_mountains
l = tt_mountains_small
i = tt_impasse_mountains
b = tt_hills_low_rolling
mr = tt_hills_med_rolling
p = tt_plains

playerStartTerrainHill = tt_player_start_classic_hills_low_rolling -- classic mode start
playerStartTerrainPlain = tt_player_start_classic_plains


-- MAP/GAME SET UP ------------------------------------------------------------------------

-- setting up the map grid using default function found in map_setup lua in library folder
terrainLayoutResult = {}    -- set up initial table for coarse map grid (must be named this)
gridHeight, gridWidth, gridSize = SetCoarseGrid()

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- set up start positions tables
masterStartPositionsTable = MakeStartPositionsTableClose(gridWidth, gridHeight, gridSize)
-- copy master start positions table to open list for player set up
openStartPositions = DeepCopy(masterStartPositionsTable)

-- debug info for player start areas
for index = 1, #openStartPositions do
	print("OSP ID " ..index .." is " ..openStartPositions[index].startID .." Number of connections is: " ..#openStartPositions[index].connections)	 
end

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

--reference values
baseGridSize = 13
outerRadius = 3.5 / baseGridSize * gridSize
middleRadius = 2.5 / baseGridSize * gridSize
innerRadius = 1.25 / baseGridSize * gridSize
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

rowMidPoint = Round(gridHeight / 2, 0)
colMidPoint = Round(gridWidth / 2, 0)

--------------------------
--MAP SIZE SPECIFIC VALUES
--------------------------

if (randomPositions == true) then -- place players without regard to grouping teams together		
	
	--Start Position Stuff---------------------------------------------------------------------------------
	
	if(worldTerrainWidth <= 417) then
		minPassages = 1
		maxPassages = 1
		numRange = 2
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2
		innerExclusion = 0.45
		topSelectionThreshold = 0.1
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 1
		mapCenterBuffer = 3	
		mapEdgeBuffer = 2
	elseif(worldTerrainWidth <= 513) then
		minPassages = 1
		maxPassages = 1
		numRange = 2
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = 6
		edgeBuffer = 2
		innerExclusion = 0.45
		topSelectionThreshold = 0.033
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 1
		mapCenterBuffer = 4	
		mapEdgeBuffer = 2
	elseif(worldTerrainWidth <= 641) then
		minPassages = 1
		maxPassages = 2
		numRange = 2
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = 7
		edgeBuffer = 1
		innerExclusion = 0.45
		topSelectionThreshold = 0.05
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 2
		mapCenterBuffer = 5	
		mapEdgeBuffer = 2
	elseif(worldTerrainWidth <= 769) then
		minPassages = 2
		maxPassages = 3
		numRange = 2
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 1
		innerExclusion = 0.5
		topSelectionThreshold = 0.05
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 3
		mapCenterBuffer = 6	
		mapEdgeBuffer = 3
	else
		minPassages = 2
		maxPassages = 3
		numRange = 2
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 1
		innerExclusion = 0.5
		topSelectionThreshold = 0.1
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 3
		mapCenterBuffer = 6	
		mapEdgeBuffer = 3
	end

else
	--Determine number of mountain ranges and passages
	if(worldTerrainWidth <= 416) then --for micro maps
		minPassages = 1
		maxPassages = 1
		numRange = 2 --any more than 2 and this breaks
		minPlayerDistance = 7
		minTeamDistance = 9
		edgeBuffer = 2
		innerExclusion = 0.5
		topSelectionThreshold = 0.1
		cornerThreshold = 1
		mapCenterBuffer = 3	
		mapEdgeBuffer = 2	
	elseif(worldTerrainWidth <= 512) then --for tiny maps
		minPassages = 1
		maxPassages = 1
		numRange =  2 --any more than 2 and this breaks
		minPlayerDistance = 4
		minTeamDistance = 9
		edgeBuffer = 2
		innerExclusion = 0.45
		topSelectionThreshold = 0.05
		cornerThreshold = 1
		mapCenterBuffer = 4	
		mapEdgeBuffer = 2	
	elseif(worldTerrainWidth <= 640) then  --for small maps
		minPassages = 2
		maxPassages = 2
		numRange = 2 --any more than 2 and this breaks
		minPlayerDistance = 3
		minTeamDistance = 9
		edgeBuffer = 1
		innerExclusion = 0.52
		topSelectionThreshold = 0.015
		cornerThreshold = 1
		mapCenterBuffer = 5	
		mapEdgeBuffer = 2
	elseif(worldTerrainWidth <= 768) then  --for medium maps
		minPassages = 3
		maxPassages = 3
		numRange = 2
		minPlayerDistance = 3.5
		minTeamDistance = 9
		edgeBuffer = 1
		innerExclusion = 0.54
		topSelectionThreshold = 0.018
		cornerThreshold = 2
		mapCenterBuffer = 7
		mapEdgeBuffer = 2
		print("setting 768 settings")
	else  --for large maps
		minPassages = 3
		maxPassages = 3
		numRange = 2
		minPlayerDistance = 4
		minTeamDistance = 9
		edgeBuffer = 1
		innerExclusion = 0.55
		topSelectionThreshold = 0.01
		cornerThreshold = 3
		mapCenterBuffer = 7	
		mapEdgeBuffer = 2	
	end
	
end
print("numRange is equal to " .. numRange)

numPassages = math.ceil(GetRandomInRange(minPassages, maxPassages))
print("numPassages is equal to " .. numPassages)

--innerExclusion = 0.4


------------------------
--MOUNTAINS
------------------------
--High Level Decision: Is the mountain range vertical, horizontal, or diagonal?
orientationWeightTable = {}

-- tuning data for weight of mountain range orientation
verticalWeight = 1
horizontalWeight = 1
--diagonalWeight = 1

--create empty data point for cumulative weight also
cumulativeWeightRangeTypeTable = {}

--insert entries into this weight table containing our choices
table.insert(orientationWeightTable, {"vertical", verticalWeight})
table.insert(orientationWeightTable, {"horizontal", horizontalWeight})
--table.insert(orientationWeightTable, {"diagonal", diagonalWeight})

--total up the table weight in order to correctly be able to get a weighted selection
totalOrientationWeight = 0
for index, weightedElement in ipairs(orientationWeightTable) do
	cumulativeWeightRangeTypeTable[index] = totalOrientationWeight + weightedElement[2]
	totalOrientationWeight = totalOrientationWeight + weightedElement[2]
end

--make a weighted selection
currentWeightRangeType = worldGetRandom() * totalOrientationWeight
rangeType = 0

--loop through however many times based on number of elements in the selection list
for index = 1, #orientationWeightTable do
	--loop through cumulative weights until we find the correct value range
	if(currentWeightRangeType < cumulativeWeightRangeTypeTable[index]) then
		rangeType = index
		break
	end
end

print("Current mountain range selection type is " .. orientationWeightTable[rangeType][1])



--------------
--Select start and end coordinates for mountain ranges
--------------

--divide the map into 2 equal parts
mapChunks = {}
print("gridSize is " .. gridSize)

-- create temp variables to hold the information when the loop starts
firstTileIndex = mapHalfSize - mapCenterBuffer
lastTileIndex = mapHalfSize - mapCenterBuffer

--for the 1st chunk, set values and enter into the table
newInfo = {}
newInfo = {firstTileIndex,lastTileIndex}
		
table.insert(mapChunks,1,newInfo)

print("for chunk 1" )
print("firstTileIndex is set to " .. firstTileIndex)
print("lastTileIndex is set to " .. lastTileIndex)


--do the same thing for the next chunk
--get the first and last tile of the second chunk
firstTileIndexChunk2 = mapHalfSize + mapCenterBuffer
lastTileIndexChunk2 = mapHalfSize + mapCenterBuffer

print("for chunk 2 " )
print("firstTileIndexChunk2 is set to " .. firstTileIndexChunk2)
print("lastTileIndexChunk2 is set to " .. lastTileIndexChunk2)
	
newInfo = {}
newRowChunk2 = firstTileIndexChunk2
newColChunk2 = lastTileIndexChunk2
newInfoChunk2 = {newRowChunk2,newColChunk2}

table.insert(mapChunks,2,newInfoChunk2)


--create 2 tables that'll hold the randomly chosen start and end points
--note: for balance and fair player spawning, start and end points are the same in this case. Using variable start and end points will create non-straight mountain ranges
--if using variable end points, ensure that impasse buffering on player spawns take this into account
startCoordTable = {}
endCoordTable = {}

--loop through, pick a random point in the range provided in each chunk, and insert into a chosen table
for chunkIndex = 1, numRange do
	minValue = mapChunks[chunkIndex][1]
	maxValue = mapChunks[chunkIndex][2]
	
	print("minValue is " .. minValue .. " max value is " .. maxValue)
	
	startA = mapChunks[chunkIndex][1]
	startB = 1
	startCoord = {startA,startB}
	table.insert(startCoordTable, chunkIndex, startCoord)
	print("for chunkIndex " .. chunkIndex)
	print("startA randomly set to " .. startA)
	print("startB set to " .. startB)
	
	endA = startA
	endB = gridSize
	endCoord = {endA,endB}	
	table.insert(endCoordTable, chunkIndex, endCoord)
	print("endA randomly set to " .. endA)
	print("endB set to " .. endB)	
end

--------------
--Draw the ranges and set to appropriate terrain
--------------
passageSquares = {}
ranges = {}

for rangeIndex = 1, numRange do

	rangePoints = {}
	
	startA = startCoordTable[rangeIndex][1]
	startB = startCoordTable[rangeIndex][2]
	endA = endCoordTable[rangeIndex][1]
	endB = endCoordTable[rangeIndex][2]	
	
	if (rangeType == 1) then
		rangePoints = DrawLineOfTerrainExlusive(startA, startB, endA, endB, tt_mountain_range, {tt_plains_smooth, tt_player_start_classic_hills_low_rolling, playerStartTerrainPlain}, meander, gridSize)
		print("range type is horizontal")
	else
		rangePoints = DrawLineOfTerrainExlusive(startB, startA, endB, endA, tt_mountain_range, {tt_plains_smooth, tt_player_start_classic_hills_low_rolling, playerStartTerrainPlain}, meander, gridSize)	
	end
	
	print("rangePoints contains " .. #rangePoints )
	table.insert(ranges, rangePoints)
	
	
end




-- remove mountains from the map's corner squares to avoid large camera blocking mountains
terrainLayoutResult[1][1].terrainType = p
terrainLayoutResult[1][gridWidth].terrainType = p
terrainLayoutResult[gridHeight][1].terrainType = p
terrainLayoutResult[gridHeight][gridWidth].terrainType = p

--------------------------------
-- CLEANUP
--------------------------------


--checks for any edge tiles that are of type mountain and replaces them with hills
for row = 1, gridSize do
	for col = 1, gridSize do
		if((terrainLayoutResult[row][col].terrainType == tt_mountains) and (row == 1 or row == gridSize or col == 1 or col == gridSize)) then
			terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
		end
	end
end

------------------------
-- PLAYER STARTS SETUP
------------------------
teamsList, playersPerTeam = SetUpTeams()

teamMappingTable = CreateTeamMappingTable()

playerStartTerrain = tt_player_start_classic_hills_mountains_altai --tt_player_start_classic_plains

spawnBlockers = {}
--table.insert(spawnBlockers, tt_impasse_mountains)
--table.insert(spawnBlockers, tt_mountains)
--table.insert(spawnBlockers, tt_mountains_small)
table.insert(spawnBlockers, tt_mountain_range)
table.insert(spawnBlockers, tt_plains_clearing)

basicTerrain = {}
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_hills_low_rolling)
table.insert(basicTerrain, tt_hills_gentle_rolling)


if(#teamMappingTable == 2) then
	if(rangeType == 1) then
		terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, true, spawnBlockers, 1, topSelectionThreshold, playerStartTerrain, tt_plains_smooth, 1.5, true, terrainLayoutResult)
	else
		terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, false, spawnBlockers, 1, topSelectionThreshold, playerStartTerrain, tt_plains_smooth, 1.5, true, terrainLayoutResult)
	end
	
else
	
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, 1, 0.05, playerStartTerrain, tt_plains_smooth, 1.5, true, terrainLayoutResult)
end
--add all start positions to a table
startLocationPositions = {}

--loop through and record player starts
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
		
		currentData = {}
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			currentData = {row, col}
			table.insert(startLocationPositions, currentData)
			print("Chosen start location - Row: " .. row .. " Col " .. col)
		end
		
	end
end


--randomly selects passages and cuts holes into the mountain range
previousIndex = 1
for passageIndex = 1, numPassages do
	for rangeNum = 1, 2 do
		if(rangeNum == 1) then
			chosenIndex = math.ceil(GetRandomInRange(3,#ranges[1]-3)) --points are slightly further away from the edge since those will be passages
			previousIndex = chosenIndex
			passageRow = ranges[1][chosenIndex][1]
			passageCol = ranges[1][chosenIndex][2]
			
			print("Chosen passage index is " .. chosenIndex .. " row " .. passageRow .. " col " .. passageCol )
			
			terrainLayoutResult[passageRow][passageCol].terrainType = tt_trees_plains_stealth_large
			newInfo = {}
			newInfo = {passageRow, passageCol}
			table.insert(passageSquares, newInfo)
		else
			chosenIndex = #ranges[2] - previousIndex
			passageRow = ranges[2][chosenIndex][1]
			passageCol = ranges[2][chosenIndex][2]
			
			print("Chosen passage index is " .. chosenIndex .. " row " .. passageRow .. " col " .. passageCol )
			
			terrainLayoutResult[passageRow][passageCol].terrainType = tt_trees_plains_stealth_large
			newInfo = {}
			newInfo = {passageRow, passageCol}
			table.insert(passageSquares, newInfo)
		end
	end
end

------------------------
--HILLS GENERATION
------------------------

terrainChance = 0.8

for row = 1, gridSize do
	for col = 1, gridSize do
		if (terrainLayoutResult[row][col].terrainType == tt_plains) then
			if(worldGetRandom() < terrainChance) then
				terrainLayoutResult[row][col].terrainType = tt_hills
			end
		end
	end
end

for passageIndex = 1, #passageSquares do
	currentRow = passageSquares[passageIndex][1]
	currentCol = passageSquares[passageIndex][2]
	
	terrainLayoutResult[currentRow][currentCol].terrainType = tt_trees_plains_stealth_large
end

lowTerrainHillVariance = 0.65

for row = 1, gridSize do
	for col = 1, gridSize do
		--check for the terrain type you had chosen before
		if(terrainLayoutResult[row][col].terrainType == tt_hills) then
			if(worldGetRandom() < lowTerrainHillVariance) then
				terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
			end
		end
	end
end

medTerrainHillVariance = 0.6

for row = 1, gridSize do
	for col = 1, gridSize do
		--check for the terrain type you had chosen before
		if(terrainLayoutResult[row][col].terrainType == tt_hills_low_rolling) then
			if(worldGetRandom() < medTerrainHillVariance) then
				terrainLayoutResult[row][col].terrainType = tt_hills_med_rolling
			end
		end
	end
end	

extraMountainVariance = 0.5

for row = 1, gridSize do
	for col = 1, gridSize do
		--check for the terrain type you had chosen before
		if(terrainLayoutResult[row][col].terrainType == tt_hills_med_rolling) then
			if(worldGetRandom() < extraMountainVariance) then
				terrainLayoutResult[row][col].terrainType = tt_mountains
			end
		end
	end
end	

valleyChance = 0.5

for row = 1, gridSize do
	for col = 1, gridSize do
		if (terrainLayoutResult[row][col].terrainType == tt_plains) then
			if(worldGetRandom() < valleyChance) then
				terrainLayoutResult[row][col].terrainType = tt_valley
			end
		end
	end
end

--ensure passages are open and available
for passageIndex = 1, #passageSquares do

	currentRow = passageSquares[passageIndex][1]
	currentCol = passageSquares[passageIndex][2]
	
	pasageNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
	
	for index, neighbor in ipairs(pasageNeighbors) do
		
		tempRow = neighbor.x
		tempCol = neighbor.y
		
		if(terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_mountain_range and terrainLayoutResult[tempRow][tempCol].terrainType ~= playerStartTerrain and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_trees_plains_stealth_large) then
			if(worldGetRandom() < 0.6) then
				terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_gentle_rolling
			else
				terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
			end
			
		end
		
	end
	
end


--horizontal mountains
if(rangeType == 1) then
	for index = 1, gridSize do
		if(terrainLayoutResult[1][index].terrainType ~= tt_settlement_hills or 
				terrainLayoutResult[1][index].terrainType ~= tt_poi_ruins) then
			terrainLayoutResult[1][index].terrainType = tt_hills_gentle_rolling
		end
		
		if(terrainLayoutResult[gridSize][index].terrainType ~= tt_settlement_hills or 
				terrainLayoutResult[gridSize][index].terrainType ~= tt_poi_ruins) then
			terrainLayoutResult[gridSize][index].terrainType = tt_hills_gentle_rolling
		end
	end
	randomCol1 = math.ceil(GetRandomInRange((gridSize * 0.2), (gridSize * 0.3)))
	randomRow1 = 1
	
	randomCol2 = gridSize - randomCol1
	randomRow2 = gridSize
	
	randomCol3 = math.ceil(GetRandomInRange((gridSize * 0.7), (gridSize * 0.8)))
	randomRow3 = 1
	
	randomCol4 = gridSize - randomCol3
	randomRow4 = gridSize
	
--vertical mountains
else
	for index = 1, gridSize do
		if(terrainLayoutResult[index][1].terrainType ~= tt_settlement_hills) then
			terrainLayoutResult[index][1].terrainType = tt_hills_gentle_rolling
		end
		
		if(terrainLayoutResult[index][gridSize].terrainType ~= tt_settlement_hills) then
			terrainLayoutResult[index][gridSize].terrainType = tt_hills_gentle_rolling
		end
	end
	
	randomRow1 = math.ceil(GetRandomInRange((gridSize * 0.2), (gridSize * 0.3)))
	randomCol1 = 1
	
	randomRow2 = gridSize - randomRow1
	randomCol2 = gridSize
	
	randomRow3 = math.ceil(GetRandomInRange((gridSize * 0.7), (gridSize * 0.8)))
	randomCol3 = 1
	
	randomRow4 = gridSize - randomRow3
	randomCol4 = gridSize
	
end

terrainLayoutResult[randomRow1][randomCol1].terrainType = tt_holy_site_hill
holyNeighbors = Get8Neighbors(randomRow1, randomCol1, terrainLayoutResult)
for index, neighbor in ipairs(holyNeighbors) do
		
	tempRow = neighbor.x
	tempCol = neighbor.y
	
	if(terrainLayoutResult[tempRow][tempCol].terrainType ~= playerStartTerrain and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_settlement_hills) then
		if(worldGetRandom() < 0.6) then
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_gentle_rolling
		else
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
		end
	end
end

terrainLayoutResult[randomRow2][randomCol2].terrainType = tt_holy_site_hill

holyNeighbors = Get8Neighbors(randomRow2, randomCol2, terrainLayoutResult)
for index, neighbor in ipairs(holyNeighbors) do
		
	tempRow = neighbor.x
	tempCol = neighbor.y
	
	if(terrainLayoutResult[tempRow][tempCol].terrainType ~= playerStartTerrain and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_settlement_hills) then
		if(worldGetRandom() < 0.6) then
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_gentle_rolling
		else
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
		end
	end
end
print("random row and col 1: " .. randomRow1 .. ", " .. randomCol1)
print("random row and col 2: " .. randomRow2 .. ", " .. randomCol2)

terrainLayoutResult[rowMidPoint][colMidPoint].terrainType = tt_holy_site_hill
holyNeighbors = Get8Neighbors(rowMidPoint, colMidPoint, terrainLayoutResult)
for index, neighbor in ipairs(holyNeighbors) do
		
	tempRow = neighbor.x
	tempCol = neighbor.y
	
	if(terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_holy_site_hill) then
		terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_gentle_rolling
	end
end

terrainLayoutResult[randomRow3][randomCol3].terrainType = tt_gold_large_single
terrainLayoutResult[randomRow4][randomCol4].terrainType = tt_gold_large_single

goldNeighbors = Get8Neighbors(randomRow3, randomCol3, terrainLayoutResult)
for index, neighbor in ipairs(goldNeighbors) do
		
	tempRow = neighbor.x
	tempCol = neighbor.y
	
	if(terrainLayoutResult[tempRow][tempCol].terrainType ~= playerStartTerrain and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_holy_site_hill and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_settlement_hills) then
		if(worldGetRandom() < 0.6) then
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_gentle_rolling
		else
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
		end
	end
end

goldNeighbors = Get8Neighbors(randomRow4, randomCol4, terrainLayoutResult)
for index, neighbor in ipairs(goldNeighbors) do
		
	tempRow = neighbor.x
	tempCol = neighbor.y
	
	if(terrainLayoutResult[tempRow][tempCol].terrainType ~= playerStartTerrain and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_holy_site_hill and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_settlement_hills) then
		if(worldGetRandom() < 0.6) then
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_gentle_rolling
		else
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
		end
	end
end

--make mountain ranges not hit the edge of the world for balance
for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(row == 1 or col == 1 or row == gridSize or col == gridSize) then
			if(terrainLayoutResult[row][col].terrainType ~= tt_holy_site_hill and terrainLayoutResult[row][col].terrainType ~= tt_settlement_hills and terrainLayoutResult[row][col].terrainType ~= tt_gold_large_single) then
				
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
		end
	end
end

--ensure that mountains are not near start positions
startMountainClearing = 4
for startIndex = 1, #startLocationPositions do
	
	currentRow = startLocationPositions[startIndex][1]
	currentCol = startLocationPositions[startIndex][2]
	
	startNeighbors = GetAllSquaresInRadius(currentRow, currentCol, startMountainClearing, terrainLayoutResult)
	
	for neighborIndex = 1, #startNeighbors do
		currentCheckRow = startNeighbors[neighborIndex][1]
		currentCheckCol = startNeighbors[neighborIndex][2]
		if(terrainLayoutResult[currentCheckRow][currentCheckCol].terrainType == tt_mountains) then
			terrainLayoutResult[currentCheckRow][currentCheckCol].terrainType = tt_hills_gentle_rolling
		end
	end
end


tradeChance = worldGetRandom()

--place holy sites and trade posts deliberately
if(tradeChance > 0.5) then
	terrainLayoutResult[1][1].terrainType = tt_poi_ruins
	terrainLayoutResult[gridSize][gridSize].terrainType = tt_poi_ruins
	
	terrainLayoutResult[1][3].terrainType = tt_settlement_hills
	terrainLayoutResult[gridSize][gridSize - 2].terrainType = tt_settlement_hills
else
	terrainLayoutResult[1][gridSize].terrainType = tt_poi_ruins
	terrainLayoutResult[gridSize][1].terrainType = tt_poi_ruins
	
	terrainLayoutResult[1][gridSize - 2].terrainType = tt_settlement_hills
	terrainLayoutResult[gridSize][3].terrainType = tt_settlement_hills
end
--[[
--place holy sites and trade posts deliberately
if(tradeChance > 0.5) then
	terrainLayoutResult[2][1].terrainType = tt_plains
	terrainLayoutResult[1][2].terrainType = tt_plains
	terrainLayoutResult[2][2].terrainType = tt_plains
	terrainLayoutResult[gridSize-1][gridSize].terrainType = tt_plains
	terrainLayoutResult[gridSize][gridSize-1].terrainType = tt_plains
	terrainLayoutResult[gridSize-1][gridSize-1].terrainType = tt_plains
else
	terrainLayoutResult[1][gridSize-1].terrainType = tt_plains
	terrainLayoutResult[2][gridSize].terrainType = tt_plains
	terrainLayoutResult[2][gridSize-1].terrainType = tt_plains
	terrainLayoutResult[gridSize-1][1].terrainType = tt_plains
	terrainLayoutResult[gridSize][2].terrainType = tt_plains
	terrainLayoutResult[gridSize-1][2].terrainType = tt_plains
end
--]]
print("END OF ALTAI LUA SCRIPT")