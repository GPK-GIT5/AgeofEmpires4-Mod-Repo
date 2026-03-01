-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--CHANNEL Map Script

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

--the following are markers used to determine player and settlement spawn points
s = tt_player_start_hills
sp = tt_settlement_plains
sh = tt_settlement_hills
seb = tt_settlement_hills_high_rolling

playerStartTerrain = tt_player_start_classic_plains

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
--in channel, only 2 islands are ever created
numIslands = 2
distanceBetweenIslandStarts = 7
islandGap = 6
mapRes = 25
islandVariance = 0
landCoverage = 0.65
--varaibles for 512 maps
if(worldTerrainWidth <= 513) then
	distanceBetweenIslandStarts = 7
	islandGap = 6
	mapRes = 15
	islandVariance = 2
	landCoverage = 0.9
--variables for maps up to 768
elseif(worldTerrainWidth <= 769) then
	distanceBetweenIslandStarts = 9
	islandGap = 7
	mapRes = 20
	islandVariance = 3
	landCoverage = 0.95
--variables for maps larger than 768
else
	distanceBetweenIslandStarts = 11
	islandGap = 8
	mapRes = 22
	islandVariance = 4
	landCoverage = 0.95
end

islandsToAdd = Round((worldGetRandom() * islandVariance))
numIslands = numIslands + Round(islandsToAdd * worldGetRandom())


gridHeight, gridWidth, gridSize = SetCoarseGrid(mapRes)
--these values are values received specifically to let the script know information about map dimensions
--the number of players is grabbed from the map setup menu screen and includes both human and AI players
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
		
		if((i >= edgeGap and i < (gridSize - (edgeGap - 1))) and j >= edgeGap and j < (gridSize - (edgeGap - 1))) then
			currentPoint = {}
			currentPoint = {i, j}
			table.insert(openList, currentPoint)
		end
		
	end
end

edgeGap = 0

--this function returns a set of points that are a guaranteed distance apart from each other. great for finding points to grow islands from
--function found in scar/terrainlayout/library/template_functions
islandStartingPoints = GetSetOfSquaresDistanceApart(numIslands, distanceBetweenIslandStarts, openList, terrainLayoutResult)

--set weights very low on islands placed after the 2 main islands
--the weight table acts as a way to set which islands grow more than others. This lets the players starting islands be larger than the rest
weightTable = {}

maxExtraIslandWeight = 0.35
for i = 1, numIslands do
	currentData = {}
	currentIslandWeight = 0
	if(i <= 2) then
		currentIslandWeight = 1
	else
		currentIslandWeight = (worldGetRandom() * maxExtraIslandWeight)
	end
	currentData = {
		i,
		currentIslandWeight
	}
	table.insert(weightTable, currentData)
	
end

--call the create islands function to generate the islands needed


equalIslandLandPercent = 0.85

--call the create islands function to generate the islands needed
--this grows islands from the previously found starting points, and grows them based on the weight table.
--islands weighted more heavily will grow more than islands that have less weight
--function found in scar/terrainlayout/library/template_functions
islandPoints = {}
--islandPoints = CreateIslandsWeighted(islandStartingPoints, weightTable, landCoverage, islandGap, edgeGap, terrainLayoutResult)
islandPoints = CreateIslandsWeightedEven(islandStartingPoints, 2, equalIslandLandPercent, weightTable, landCoverage, islandGap, edgeGap, terrainLayoutResult)
--iterate through generated island points and put down land
for islandIndex = 1, #islandPoints do
	
	--iterate through points on the island
	for islandPointIndex = 1, #islandPoints[islandIndex] do
		
		--grab this point and set the terrain
		currentRow = islandPoints[islandIndex][islandPointIndex][1]
		currentCol = islandPoints[islandIndex][islandPointIndex][2]
		
		--set the terrain
		terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
		
	end
	
end


--go through islands and set any terrain touching ocean to a beach
for islandIndex = 1, #islandPoints do
	
	--iterate through points on the island
	for islandPointIndex = 1, #islandPoints[islandIndex] do
		
		--grab this point
		currentRow = islandPoints[islandIndex][islandPointIndex][1]
		currentCol = islandPoints[islandIndex][islandPointIndex][2]
		
		--check the neighbors
		currentNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
		
		hasOceanNeighbor = false
		--iterate through neighbors of this point
		for neighborIndex, neighbor in ipairs(currentNeighbors) do
			
			--check the terrain types of all neighbors, check for ocean terrain type
			currentNeighborRow = neighbor.x 
			currentNeighborCol = neighbor.y 
			
			if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
				hasOceanNeighbor = true
			end
		end
		
		--if there was at least one ocean neighbor, turn this square into a beach
		beachChance = 0.7
		if(hasOceanNeighbor == true) then
			if(worldGetRandom() < beachChance) then
				terrainLayoutResult[currentRow][currentCol].terrainType = tt_beach
			end
		end
		
	end
	
end


--go back through islands and set anything inland to regular plains terrain
--inland defined as squares that don't touch an ocean but are adjacent to a beach or island plains
innerIslandPoints = {}
for islandIndex = 1, #islandPoints do
	innerIslandPoints[islandIndex] = {}
	--iterate through points on the island
	for islandPointIndex = 1, #islandPoints[islandIndex] do
		
		--grab this point
		currentRow = islandPoints[islandIndex][islandPointIndex][1]
		currentCol = islandPoints[islandIndex][islandPointIndex][2]
		currentInfo = {}
		--check the neighbors
		currentNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
		
		hasOceanNeighbor = false
		--iterate through neighbors of this point
		for neighborIndex, neighbor in ipairs(currentNeighbors) do
			
			--check the terrain types of all neighbors, check for ocean terrain type
			currentNeighborRow = neighbor.x 
			currentNeighborCol = neighbor.y 
			
			if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean or terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_beach) then
				hasOceanNeighbor = true
			end
		end
		
		if(hasOceanNeighbor == false and currentRow > 3 and currentRow < (gridSize - 2) and currentCol > 3 and currentCol < (gridSize - 2)) then
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
			currentInfo = {currentRow, currentCol}
			table.insert(innerIslandPoints[islandIndex], currentInfo)
		end
		
	end
	
end





--find largest islands, put spawns on them
islandSizes = {}
for islandIndex = 1, #islandPoints do
	
	currentIslandSquares = #islandPoints[islandIndex]
	currentData = {
		islandNum = islandIndex,
		islandSquares = currentIslandSquares
	}
	
	table.insert(islandSizes, currentData)

end

--this will sort the table based on size of island
table.sort(islandSizes, function(a,b) return a.islandSquares > b.islandSquares end)

currentIslandSwitch = 1


--*******************************
--need to find spread out positions on each island for players to spawn

maxDistance = math.ceil((worldTerrainWidth / mapRes) * 0.55)

firstHalfPlayers = math.ceil(worldPlayerCount / 2)
islandOne = islandSizes[1].islandNum
--firstHalfPoints = GetSetOfSquaresDistanceApart(firstHalfPlayers, 10, innerIslandPoints[islandOne], terrainLayoutResult)

--GetFurthestPoints is a function that will find points within a specified set of squares that are up to a maximum distance apart
--function found in scar/terrainlayout/library/template_functions
firstHalfPoints = GetFurthestStarts(firstHalfPlayers, maxDistance, innerIslandPoints[islandOne], terrainLayoutResult)
secondHalfPlayers = worldPlayerCount - firstHalfPlayers
islandTwo = islandSizes[2].islandNum
--secondHalfPoints = GetSetOfSquaresDistanceApart(secondHalfPlayers, 10, innerIslandPoints[islandTwo], terrainLayoutResult)
secondHalfPoints = GetFurthestStarts(secondHalfPlayers, maxDistance, innerIslandPoints[islandTwo], terrainLayoutResult)

--ISLAND 1
for playerNum = 1, firstHalfPlayers do
	
	--find the middle of each island (or square closest to the middle)
	averageRow = 0
	averageCol = 0
	
	currentIsland = islandSizes[1].islandNum
	
	currentRow = firstHalfPoints[playerNum][1]
	currentCol = firstHalfPoints[playerNum][2]
	
	terrainLayoutResult[currentRow][currentCol].terrainType = playerStartTerrain
	terrainLayoutResult[currentRow][currentCol].playerIndex = playerNum - 1
	
	-- add buffer squares around player starts
	--this function returns all squares in a ring around the specified coordinate on the grid
	--function found in the engine folder under scar/terrainlayout/library/getsquaresfunctions
	bufferSquares = GetAllSquaresInRingAroundSquare(currentRow, currentCol, 3, 3, terrainLayoutResult)
	for bIndex = 1, #bufferSquares do
		row = bufferSquares[bIndex][1]
		col = bufferSquares[bIndex][2]
		
		if (terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[row][col].terrainType = tt_plains_smooth
		end
		
	end
	
end

--ISLAND 2
for playerNum = 1, secondHalfPlayers do
	
	--find the middle of each island (or square closest to the middle)
	averageRow = 0
	averageCol = 0
	
	currentIsland = islandSizes[2].islandNum
	
	currentRow = secondHalfPoints[playerNum][1]
	currentCol = secondHalfPoints[playerNum][2]
	
	terrainLayoutResult[currentRow][currentCol].terrainType = playerStartTerrain
	terrainLayoutResult[currentRow][currentCol].playerIndex = ((playerNum - 1) + firstHalfPlayers) --you must assign player IDs to the starting squares, starting at player 0 (matches the game setup screen)
	
	-- add buffer squares around player starts
	bufferSquares = GetAllSquaresInRingAroundSquare(currentRow, currentCol, 3, 3, terrainLayoutResult)
	for bIndex = 1, #bufferSquares do
		row = bufferSquares[bIndex][1]
		col = bufferSquares[bIndex][2]
		
		if (terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[row][col].terrainType = tt_plains_smooth
		end
		
	end
	
end

--[[
--choose number of lakes to create
baseLakeNum = 1
numOfLakes = baseLakeNum + (math.ceil((worldGetRandom() * baseLakeNum)/2))

maxLakeSize = 3
minLakeSize = 2
--set the types of terrain that the lake function will seek to avoid
impasseTypes = {m, i, med, high, tt_lake_shallow, tt_lake_deep, tt_swamp, tt_ocean, tt_beach, tt_player_start_classic_plains, tt_plains_smooth}
--the CreateLake function will search through the map and find an open spot to fill with a lake within the size bounds
----function found in scar/terrainlayout/library/template_functions
CreateLake(maxLakeSize, minLakeSize, impasseTypes, tt_lake_shallow, numOfLakes, terrainLayoutResult)
--]]
--END Channel Map Script