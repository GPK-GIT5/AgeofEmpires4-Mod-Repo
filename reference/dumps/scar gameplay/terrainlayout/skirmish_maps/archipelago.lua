-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--ARCHIPELAGO Map Script

n = tt_none

--these are terrain types that define specific geographic features
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

--bounty squares are used to populate an area of the map with extra resources
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains
bs = tt_bounty_stone_plains

--the following are markers used to determine player and settlement spawn points
s = tt_player_start_hills
sp = tt_settlement_plains
sh = tt_settlement_hills
seb = tt_settlement_hills_high_rolling

playerStartTerrain = tt_player_start_classic_plains_naval_archipelago

teamMappingTable = {}
teamMappingTable = CreateTeamMappingTable()

--this means the game is FFA
FFA = false
if(#teamMappingTable == worldPlayerCount) then
	FFA = true
end

--[[
--islands need higher res grid to be effective
--This function sets the meters-per-grid ratio to a specified scale instead of the usual 40m. 
--when creating your own maps, use the library function that uses the standard size, found in scar/terrainlayout/library/map_setup
local function SetCoarseGrid(metersPerSquare)

	local mapHeight
	local mapWidth
	local mapSize
	
	mapHeight = Round(worldTerrainHeight / metersPerSquare, 0) -- set resolution of coarse map rows
	mapWidth = Round(worldTerrainWidth / metersPerSquare, 0) -- set resolution of coarse map columns
	
	if (mapHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
		mapHeight = mapHeight - 1
	end

	if (mapWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
		mapWidth = mapWidth - 1
	end
	
	mapSize = mapWidth -- set resolution of coarse map
	
	return mapHeight, mapWidth, mapSize

end

--calculate number of islands and distance between them based on map size
numIslands = 15
distanceBetweenIslandStarts = 3
islandGap = 4
mapRes = 20
islandVariance = 0
landCoverage = 0.4
--for tiny maps
if(worldTerrainWidth <= 513) then
	numIslands = 8
	distanceBetweenIslandStarts = 5
	islandGap = 5
	mapRes = 15
	islandVariance = 3
	landCoverage = 0.85
--for small maps
elseif(worldTerrainWidth <= 769) then
	numIslands = 11
	distanceBetweenIslandStarts = 5
	islandGap = 5
	mapRes = 20
	islandVariance = 4
	landCoverage = 0.75
--for sizes larger than 768
else
	numIslands = 14
	distanceBetweenIslandStarts = 6
	islandGap = 6
	mapRes = 22
	islandVariance = 4
	landCoverage = 0.7
end


--calculate how many islands to create
islandsToAdd = Round((worldGetRandom() * islandVariance))
numIslands = numIslands + islandsToAdd


gridHeight, gridWidth, gridSize = SetCoarseGrid(mapRes)

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid with ocean base
terrainLayoutResult = SetUpGrid(gridSize, tt_ocean, terrainLayoutResult)




edgeGap = 3

--create valid locations for islands to be seeded
openList = {}
for i = 1, #terrainLayoutResult do
	for j = 1, #terrainLayoutResult do
		--this check ensures that islands will start away from the edge of the map
		if((i >= edgeGap and i < (gridSize - (edgeGap - 1))) and j >= edgeGap and j < (gridSize - (edgeGap - 1))) then
			currentPoint = {}
			currentPoint = {i, j}
			table.insert(openList, currentPoint)
		end
		
	end
end


edgeGap = 0

--GetSetOfSquaresDistanceApart(numOfSquares, distanceBetweenSquares, squaresToUse, terrainTable)
--this function returns a set of points that are a guaranteed distance apart from each other. great for finding points to grow islands from
--function found in scar/terrainlayout/library/template_functions
islandStartingPoints = GetSetOfSquaresDistanceApart(numIslands, distanceBetweenIslandStarts, openList, terrainLayoutResult)



--set weights very low on islands placed after the players' starting islands
--the weight table acts as a way to set which islands grow more than others. This lets the players starting islands be larger than the rest
weightTable = {}

maxExtraIslandWeight = 0.6
minExtraIslandWeight = 0.3
for i = 1, numIslands do
	currentData = {}
	currentIslandWeight = 0
	if(i <= worldPlayerCount) then
		currentIslandWeight = 1
	else
		currentIslandWeight = (worldGetRandom() * maxExtraIslandWeight)
		if(currentIslandWeight < minExtraIslandWeight) then
			currentIslandWeight = minExtraIslandWeight
		end
	end
	currentData = {
		i,
		currentIslandWeight
	}
	table.insert(weightTable, currentData)
	
end
--]]

--calculate number of islands and distance between them based on map size
	
--set island number to be the number of players in the game
numIslands = worldPlayerCount
distanceBetweenIslands = 4
islandGap = 3
edgeGap = 0
mapRes = 20
islandVariance = 0
landCoverage = 0.4
if(worldTerrainWidth <= 417) then
	playerEdgeGap = 2
	distanceBetweenIslands = 4
	distanceBetweenIslandsExtra = 3.5
	islandSize = 138
	islandGap = 3
	mapRes = 15
	minIslandNum = worldPlayerCount + 2
	maxIslandNum = 5
	islandVariance = 2
	landCoverage = 0.95
	equalIslandLandPercent = 0.25
	innerExclusion = 0.495
	
	extraIslandSize = 68
--	distanceBetweenIslands = math.ceil(mapRes * 0.95)
	
	--THIS IS TEAMS TOGETHER
	if(randomPositions == false) then
		minTeamDistance = math.ceil(mapRes * 1.4)
		minPlayerDistance = 10
	else
		minTeamDistance = math.ceil(mapRes * 1.4)
		minPlayerDistance = math.ceil(mapRes * 1.4)
	end
	
	if(FFA == true) then
		minTeamDistance = math.ceil(mapRes * 1.1)
		minPlayerDistance = 20
	end
elseif(worldTerrainWidth <= 513) then
	playerEdgeGap = 2
	distanceBetweenIslands = 4
	distanceBetweenIslandsExtra = 3.5
	islandSize = 134
	islandGap = 3
	mapRes = 15
	minIslandNum = worldPlayerCount + 2
	maxIslandNum = 7
	islandVariance = 2
	landCoverage = 0.95
	equalIslandLandPercent = 0.275
	innerExclusion = 0.295
	
	extraIslandSize = 86
--	distanceBetweenIslands = math.ceil(mapRes * 0.85)
	
	if(randomPositions == false) then
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = 12
	else
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = math.ceil(mapRes * 1.2)
	end
	
	if(FFA == true) then
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = 20
	end
	
elseif(worldTerrainWidth <= 641) then
	playerEdgeGap = 2
	distanceBetweenIslands = 4
	distanceBetweenIslandsExtra = 3.5
	islandSize = 120
	islandGap = 3
	mapRes = 20
	minIslandNum = worldPlayerCount + 2
	if(minIslandNum < 5) then
		minIslandNum = 5
	end
	maxIslandNum = worldPlayerCount + 3
	islandVariance = 6
	landCoverage = 0.95
	equalIslandLandPercent = 0.3
	innerExclusion = 0.465
	
	extraIslandSize = 96
--	distanceBetweenIslands = math.ceil(mapRes * 0.85)
	
	if(randomPositions == false) then
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = 18
	else
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = math.ceil(mapRes * 1.2)
	end
	
	if(FFA == true) then
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = 20
	end
	
elseif(worldTerrainWidth <= 769) then
	playerEdgeGap = 3
	distanceBetweenIslands = 4
	distanceBetweenIslandsExtra = 3.5
	islandSize = 116
	islandGap = 3
	mapRes = 20
	minIslandNum = worldPlayerCount + 2
	if(minIslandNum < 7) then
		minIslandNum = 7
	end
	maxIslandNum = worldPlayerCount + 4
	islandVariance = 6
	landCoverage = 0.9
	equalIslandLandPercent = 0.3
	innerExclusion = 0.585
	
	extraIslandSize = 92
--	distanceBetweenIslands = math.ceil(mapRes * 0.85)
	
	if(randomPositions == false) then
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = 16
	else
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = math.ceil(mapRes * 1.2)
	end
	
	if(FFA == true) then
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = 22
	end
	
else
	playerEdgeGap = 3
	distanceBetweenIslands = 4
	distanceBetweenIslandsExtra = 3.5
	islandSize = 126
	islandGap = 3
	mapRes = 20
	minIslandNum = worldPlayerCount + 3
	if(minIslandNum < 9) then
		minIslandNum = 9
	end
	maxIslandNum = worldPlayerCount + 6
	islandVariance = 7
	landCoverage = 0.95
	equalIslandLandPercent = 0.3
	innerExclusion = 0.625
	
	extraIslandSize = 106
--	distanceBetweenIslands = math.ceil(mapRes * 0.85)
	
	if(randomPositions == false) then
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = 16
	else
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = math.ceil(mapRes * 1.2)
	end
	
	if(FFA == true) then
		islandSize = 90
		minIslandNum = 11
		maxIslandNum = 13
		minTeamDistance = math.ceil(mapRes * 1.2)
		minPlayerDistance = 24
	end
end

islandSizePlayerMod = 4
islandSize = math.ceil(islandSize - (worldPlayerCount * islandSizePlayerMod))

cliffChance = 0.00

forestChance = 0.0

	
mountainChance = 0.00
hillChance = 0.00

--islandsToAdd = Round((worldGetRandom() * islandVariance))
--numIslands = numIslands + islandsToAdd

cliffChanceMin = 0.01
cliffChanceMax = 0.03
--cliffChance = Normalize(worldGetRandom(), cliffChanceMin, cliffChanceMax)
cliffChance = 0
inlandTerrainChanceMin = 0.03
inlandTerrainChanceMax = 0.115
inlandTerrainChance = Normalize(worldGetRandom(), inlandTerrainChanceMin, inlandTerrainChanceMax)

inlandTerrain = {}
--table.insert(inlandTerrain, tt_mountains)
--table.insert(inlandTerrain, tt_impasse_trees_plains)
table.insert(inlandTerrain, tt_hills_gentle_rolling)
table.insert(inlandTerrain, tt_hills_low_rolling)
--table.insert(inlandTerrain, tt_plateau_low)


gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(mapRes)
--these values are values received specifically to let the script know information about map dimensions
--the number of players is grabbed from the map setup menu screen and includes both human and AI players
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid with ocean base
terrainLayoutResult = SetUpGrid(gridSize, tt_ocean, terrainLayoutResult)


edgeGap = 0
startingEdgeGap = 0
--create valid locations for islands to be seeded
--this basically loops through the grid and adds every square that is not on the edge as a valid spot
openList = {}
for i = 1, #terrainLayoutResult do
	for j = 1, #terrainLayoutResult do
		
		if((i >= edgeGap and i < (gridSize - (edgeGap - 1))) and j >= edgeGap and j < (gridSize - (edgeGap - 1))) then
			currentPoint = {}
			currentPoint = {i, j}
			table.insert(openList, currentPoint)
		end
		
	end
end

editedPlayerCount = worldPlayerCount
if(editedPlayerCount < 2) then
	--editedPlayerCount = 2
end

--totalIslandNum is how many extra islands to spawn
totalIslandNum = math.ceil(Normalize(worldGetRandom(), minIslandNum, maxIslandNum)) - editedPlayerCount

--set weights very low on islands placed after the players' islands
weightTable = {}

maxExtraIslandWeight = 0.8
minExtraIslandWeight = 0.55
for i = 1, numIslands do
	currentData = {}
	currentIslandWeight = 0
	if(i <= editedPlayerCount) then
		currentIslandWeight = 1.65
	else
		currentIslandWeight = (worldGetRandom() * maxExtraIslandWeight)
		if(currentIslandWeight < minExtraIslandWeight) then
			currentIslandWeight = minExtraIslandWeight
		end
	end
	currentData = {
		i,
		currentIslandWeight
	}
	table.insert(weightTable, currentData)
	
end



startBufferRadius = 2
impasseTypes = {}
table.insert(impasseTypes, tt_impasse_mountains)
table.insert(impasseTypes, tt_mountains)
table.insert(impasseTypes, tt_plateau_med)
table.insert(impasseTypes, tt_plateau_low)
inlandRadius = 2
impasseDistance = 1
topSelectionThreshold = 0.01


--CreateIslandsTeamsApart(weightTable, landCoverage, equalIslandLandPercent, editedPlayerCount, distanceBetweenIslands, edgeGap, islandGap, teamMappingTable, playerStartTerrain, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, terrainLayoutResult)

--CreateIslandsTeamsApartEven(islandSize, equalIslandNum, totalIslandNum, distanceBetweenIslands, edgeBuffer, innerExclusion, islandGap, teamMappingTable, playerStartTerrain, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, minTeamDistance, minPlayerDistance, impasseTypes, impasseDistance, topSelectionThreshold, playerEdgeGap, terrainGrid)

randomSpawnLocations = FFA or randomPositions
CreateIslandsTeamsApartEven(islandSize, editedPlayerCount, totalIslandNum, distanceBetweenIslands, edgeGap, innerExclusion, inlandRadius, islandGap, teamMappingTable, playerStartTerrain, startBufferRadius, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, minTeamDistance, minPlayerDistance, impasseTypes, impasseDistance, topSelectionThreshold, playerEdgeGap, terrainLayoutResult, randomSpawnLocations)

--[[
equalIslandChance = 0.00
if(worldGetRandom() < equalIslandChance) then
	equalIslands = true
	print("generating EQUAL ISLANDS")
else
	equalIslands = false
	print("generating NON EQUAL EXTRA ISLANDS")
end
]]--

--put forests on starting islands
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do

		if(terrainLayoutResult[row][col].terrainType == tt_island_plains or terrainLayoutResult[row][col].terrainType == tt_plains) then
			if(worldGetRandom() < 0.6) then
				terrainLayoutResult[row][col].terrainType = tt_impasse_trees_plains_naval
			end
		end
	end
end

specialTerrain = {}
specialTerrain = {tt_bounty_gold_plains, tt_bounty_stone_plains}

extraIslands = {}

equalIslands = false
extraIslands = FillWithIslands(extraIslandSize, equalIslands, totalIslandNum, distanceBetweenIslandsExtra, startingEdgeGap, edgeGap, 0, islandGap, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, impasseTypes, impasseDistance, specialTerrain, playerStartTerrain, terrainLayoutResult)


--make a trade post on the shore of each extra island
inlandIslandSquares = {}

for islandIndex = 1, #extraIslands do
	inlandIslandSquares[islandIndex] = {}
	currentBeachSquares = {}
	currentInlandSquares = {}
	for islandSquareIndex = 1, #extraIslands[islandIndex] do
		
		currentRow = extraIslands[islandIndex][islandSquareIndex][1]
		currentCol = extraIslands[islandIndex][islandSquareIndex][2]
		oceanNeighbors = 0
		
		currentNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
		
		for neighborIndex, islandNeighbor in ipairs(currentNeighbors) do	
			currentNeighborRow = islandNeighbor.x
			currentNeighborCol = islandNeighbor.y
			
			if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
				oceanNeighbors = oceanNeighbors + 1
			end
		end
		
		if(oceanNeighbors == 1 and (currentRow > 2 and currentCol > 2 and currentRow < gridSize - 1 and currentCol < gridSize - 1)) then
			newInfo = {}
			newInfo = {currentRow, currentCol}
			print("adding " .. currentRow .. ", " .. currentCol .. " as a beach square")
			table.insert(currentBeachSquares, newInfo)
		end
		
		currentNeighbors = Get8Neighbors(currentRow, currentCol, terrainLayoutResult)
		
		for neighborIndex, islandNeighbor in ipairs(currentNeighbors) do	
			currentNeighborRow = islandNeighbor.x
			currentNeighborCol = islandNeighbor.y
			
			if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
				oceanNeighbors = oceanNeighbors + 1
			end
		end
		
		if(oceanNeighbors == 0) then
			newInfo = {}
			newInfo = {currentRow, currentCol}
			print("adding " .. currentRow .. ", " .. currentCol .. " as an inland square")
			table.insert(currentInlandSquares, newInfo)
			table.insert(inlandIslandSquares[islandIndex], newInfo)
		end
	end
	
	--if beach squares exist 
	if(#currentBeachSquares > 0) then
		randomBeachIndex = math.ceil(worldGetRandom() * #currentBeachSquares)
		chosenRow = currentBeachSquares[randomBeachIndex][1]
		chosenCol = currentBeachSquares[randomBeachIndex][2]
		print("setting " .. chosenRow .. ", " .. chosenCol .. " as a naval trade post square")
		terrainLayoutResult[chosenRow][chosenCol].terrainType = tt_settlement_naval
	end
	
	--make forests on islands
	counter = 0
	if(#currentInlandSquares > 0) then
		for inlandIndex = 1, #currentInlandSquares do
		
			currentRow = currentInlandSquares[inlandIndex][1]
			currentCol = currentInlandSquares[inlandIndex][2]
			if(counter == 2) then
				if(worldGetRandom() < 0.4) then
					terrainLayoutResult[currentRow][currentCol].terrainType = tt_impasse_trees_plains_naval
				end
			elseif(counter == 3) then
				terrainLayoutResult[currentRow][currentCol].terrainType = tt_impasse_trees_plains_naval
			end
			
			counter = counter + 1
			if(counter >= 4) then
				counter = 0
			end
		end
	end
	
end

for inlandIslandIndex = 1, #inlandIslandSquares do
	currentCount = #inlandIslandSquares[inlandIslandIndex]
	inlandIslandSquares[inlandIslandIndex].count = currentCount
end

--sort inland islands by size
table.sort(inlandIslandSquares, function(a,b) return a.count > b.count end)
print("inland squares by island:")
for inlandIslandIndex = 1, #inlandIslandSquares do
	print("number of inland squares on island " .. inlandIslandIndex .. " is " .. #inlandIslandSquares[inlandIslandIndex])
end

mapHalfSize = Round((gridSize / 2), 0)

if(#inlandIslandSquares > 1) then
	
	--get average position of biggest island
	averageRow = 0
	averageCol = 0
	for island1Index = 1, #inlandIslandSquares[1] do
		
		currentRow = inlandIslandSquares[1][island1Index][1]
		currentCol = inlandIslandSquares[1][island1Index][2]
		
		averageRow = averageRow + currentRow
		averageCol = averageCol + currentCol
	end
	
	averageRow = Round((averageRow / #inlandIslandSquares[1]), 0)
	averageCol = Round((averageCol / #inlandIslandSquares[1]), 0)
	
	holyRow, holyCol = GetClosestSquare(averageRow, averageCol, inlandIslandSquares[1])
	
	terrainLayoutResult[holyRow][holyCol].terrainType = tt_holy_site
	
	currentNeighbors = {}
	currentNeighbors = GetNeighbors(averageRow, averageCol, terrainLayoutResult)
		
	for neighborIndex, islandNeighbor in ipairs(currentNeighbors) do	
		currentNeighborRow = islandNeighbor.x
		currentNeighborCol = islandNeighbor.y
		
		if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_impasse_trees_plains_naval) then
			terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
		end
	end
	
	lineToOcean = {}
	lineToOcean = DrawLineOfTerrainNoDiagonalReturn(averageRow, averageCol, mapHalfSize, mapHalfSize, false, tt_plains, gridSize, terrainLayoutResult)
	
	for lineIndex = 1, #lineToOcean do
		
		currentRow = lineToOcean[lineIndex][1]
		currentCol = lineToOcean[lineIndex][2]
		
		if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_impasse_trees_plains_naval) then
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
		end
		
		if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_ocean) then
			break
		end
		
	end
	
	--get average position for second largest island
	averageRow = 0
	averageCol = 0
	for island2Index = 1, #inlandIslandSquares[2] do
		
		currentRow = inlandIslandSquares[2][island2Index][1]
		currentCol = inlandIslandSquares[2][island2Index][2]
		
		averageRow = averageRow + currentRow
		averageCol = averageCol + currentCol
	end
	
	averageRow = Round((averageRow / #inlandIslandSquares[2]), 0)
	averageCol = Round((averageCol / #inlandIslandSquares[2]), 0)
	
	holyRow, holyCol = GetClosestSquare(averageRow, averageCol, inlandIslandSquares[2])
	
	terrainLayoutResult[holyRow][holyCol].terrainType = tt_holy_site
	
	currentNeighbors = {}
	currentNeighbors = GetNeighbors(averageRow, averageCol, terrainLayoutResult)
		
	for neighborIndex, islandNeighbor in ipairs(currentNeighbors) do	
		currentNeighborRow = islandNeighbor.x
		currentNeighborCol = islandNeighbor.y
		
		if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_impasse_trees_plains_naval) then
			terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
		end
	end
	
	lineToOcean = {}
	lineToOcean = DrawLineOfTerrainNoDiagonalReturn(averageRow, averageCol, mapHalfSize, mapHalfSize, false, tt_plains, gridSize, terrainLayoutResult)
	
	for lineIndex = 1, #lineToOcean do
		
		currentRow = lineToOcean[lineIndex][1]
		currentCol = lineToOcean[lineIndex][2]
		
		if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_impasse_trees_plains_naval) then
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
		end
		
		if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_ocean) then
			break
		end
		
	end
	
else
	
	averageRow = 0
	averageCol = 0
	for islandIndex = 1, #inlandIslandSquares[1] do
		
		currentRow = inlandIslandSquares[1][islandIndex][1]
		currentCol = inlandIslandSquares[1][islandIndex][2]
		
		averageRow = averageRow + currentRow
		averageCol = averageCol + currentCol
	end
	
	averageRow = Round((averageRow / #inlandIslandSquares[1]), 0)
	averageCol = Round((averageCol / #inlandIslandSquares[1]), 0)
	--find furthest points on this island
	
	row1, col1 = GetFurthestSquare(averageRow, averageCol, inlandIslandSquares[1])
	
	row2, col2 = GetFurthestSquare(row1, col1, inlandIslandSquares[1])
	
	terrainLayoutResult[row1][col1].terrainType = tt_holy_site
	terrainLayoutResult[row2][col2].terrainType = tt_holy_site
	
	currentNeighbors = {}
	currentNeighbors = GetNeighbors(row1, col1, terrainLayoutResult)
		
	for neighborIndex, islandNeighbor in ipairs(currentNeighbors) do	
		currentNeighborRow = islandNeighbor.x
		currentNeighborCol = islandNeighbor.y
		
		if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_impasse_trees_plains_naval) then
			terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
		end
	end
	
	currentNeighbors = {}
	currentNeighbors = GetNeighbors(row2, col2, terrainLayoutResult)
		
	for neighborIndex, islandNeighbor in ipairs(currentNeighbors) do	
		currentNeighborRow = islandNeighbor.x
		currentNeighborCol = islandNeighbor.y
		
		if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_impasse_trees_plains_naval) then
			terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
		end
	end
	
	lineToOcean = {}
	lineToOcean = DrawLineOfTerrainNoDiagonalReturn(row1, col1, mapHalfSize, mapHalfSize, false, tt_plains, gridSize, terrainLayoutResult)
	
	for lineIndex = 1, #lineToOcean do
		
		currentRow = lineToOcean[lineIndex][1]
		currentCol = lineToOcean[lineIndex][2]
		
		if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_impasse_trees_plains_naval) then
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
		end
		
		if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_ocean) then
			break
		end
		
	end
	
	
	lineToOcean = {}
	lineToOcean = DrawLineOfTerrainNoDiagonalReturn(row2, col2, mapHalfSize, mapHalfSize, false, tt_plains, gridSize, terrainLayoutResult)
	
	for lineIndex = 1, #lineToOcean do
		
		currentRow = lineToOcean[lineIndex][1]
		currentCol = lineToOcean[lineIndex][2]
		
		if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_impasse_trees_plains_naval) then
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
		end
		
		if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_ocean) then
			break
		end
		
	end
	
end


--fill empty ocean with trees
islandDistanceTrees = 3
openOceanSquares = {}
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == tt_ocean) then
		
			isNearLand = false
			
			oceanNeighbors = {}
			oceanNeighbors = GetAllSquaresInRadius(row, col, islandDistanceTrees, terrainLayoutResult)
			for oceanCheckIndex, oceanCheckNeighbor in ipairs(oceanNeighbors) do	
				currentOceanCheckNeighborRow = oceanCheckNeighbor[1]
				currentOceanCheckNeighborCol = oceanCheckNeighbor[2]
				
				currentOceanCheckTT = terrainLayoutResult[currentOceanCheckNeighborRow][currentOceanCheckNeighborCol].terrainType
				if(currentOceanCheckTT ~= tt_ocean) then
					isNearLand = true
				end
			end
			
			if(isNearLand == false) then
				newInfo = {}
				newInfo = {row, col}
				table.insert(openOceanSquares, newInfo)
				print("inserting open ocean square at " .. row .. ", " .. col)
			end
			
		end
		
	end
end

--assign open ocean squares to be additional tree covered islands
if(#openOceanSquares > 0) then

	for oceanIndex = 1, #openOceanSquares do

		currentRow = openOceanSquares[oceanIndex][1]
		currentCol = openOceanSquares[oceanIndex][2]
		
		terrainLayoutResult[currentRow][currentCol].terrainType = tt_impasse_trees_hills_naval
		print("placing trees at " .. currentRow .. ", " .. currentCol)
	end
end



print("END ARCHIPELAGO MAP SCRIPT")
--END Archipelago Map Script