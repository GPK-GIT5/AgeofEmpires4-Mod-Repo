-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("start of NAGARI map")

------------------
--GRID SETUP
------------------
terrainLayoutResult = {}    -- set up initial table for coarse map grid

--setting useful variables to reference world dimensions
--call the standard function to set up our grid using standard dimensions/square
--function found in scar/terrainlayout/library/map_setup
--use this function if creating a map with standard resolution and dimension (most maps)
--see the island maps for examples of non-standard resolutions

gridHeight, gridWidth, gridSize = SetCoarseGrid() -- setting up the map grid

if (gridHeight % 2 == 0) then
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then
	gridWidth = gridWidth - 1
end

gridSize = gridWidth 

--the number of players is grabbed from the map setup menu screen and includes both human and AI players
playerStarts = worldPlayerCount --set the number of players

--these are terrain types that define specific geographic features
n = tt_none
h = tt_hills
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_low_rolling
mr = tt_hills_med_rolling
hr = tt_hills_high_rolling
low = tt_plateau_low
med = tt_plateau_med
high = tt_plateau_high
p = tt_plains
lakeTerrain = tt_lake_hill_fish
mountainTerrain = tt_mountains_small

-- setting up the map terrain using the function in the map_setup lua file in the library folder
terrainLayoutResult = SetUpGrid(gridSize, tt_none, terrainLayoutResult)
playerStartTerrain = tt_player_start_classic_plains_no_tertiary_wood -- classic mode start terrain

------------------------
--REFERENCE VALUES
------------------------
--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
-- you need to use this function when creating a new map
-- found in the engine library under scar/terrainlayout/library/setsquaresfunctions

baseGridSize = 13
outerRadius = 3.5 / baseGridSize * gridSize
middleRadius = 2.5 / baseGridSize * gridSize
innerRadius = 1.25 / baseGridSize * gridSize
mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapThirdSize = math.ceil(gridSize/3)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--------------------------
--MAP SIZE SPECIFIC VALUES
--------------------------
if(worldTerrainWidth <= 416) then --for micro maps
	minRangeLength = math.ceil(gridSize*0.45)
	maxRangeLength = math.ceil(gridSize*0.6)
	lakeSize = 7 -- for the main lake
	minSmallLakeSize = 3 -- for smaller lakes
	maxSmallLakeSize = 4
	edgeVariance = math.ceil(GetRandomInRange(0,1))
elseif(worldTerrainWidth <= 512) then --for tiny maps
	minRangeLength = math.ceil(gridSize*0.45)
	maxRangeLength = math.ceil(gridSize*0.6)
	lakeSize = 10 -- for the main lake
	minSmallLakeSize = 3 -- for smaller lakes
	maxSmallLakeSize = 4
	edgeVariance = math.ceil(GetRandomInRange(0,1))
elseif(worldTerrainWidth <= 640) then  --for small maps
	minRangeLength = math.ceil(gridSize*0.45)
	maxRangeLength = math.ceil(gridSize*0.6)
	lakeSize = 24 -- for the main lake
	minSmallLakeSize = 3 -- for smaller lakes
	maxSmallLakeSize = 4
	edgeVariance = math.ceil(GetRandomInRange(0,2))
elseif(worldTerrainWidth <= 768) then  --for medium maps	
	minRangeLength = math.ceil(gridSize*0.45)
	maxRangeLength = math.ceil(gridSize*0.6)
	lakeSize = 28 -- for the main lake
	minSmallLakeSize = 3 -- for smaller lakes
	maxSmallLakeSize = 4
	edgeVariance = math.ceil(GetRandomInRange(0,2))
elseif(worldTerrainWidth <= 896) then  --for large maps
	minRangeLength = math.ceil(gridSize*0.45)
	maxRangeLength = math.ceil(gridSize*0.6)
	lakeSize = 37 -- for the main lake
	minSmallLakeSize = 3 -- for smaller lakes
	maxSmallLakeSize = 4
	edgeVariance = math.ceil(GetRandomInRange(0,2))	
end

print("LakeSize is set to " .. lakeSize)
print("edgeVariance is " .. edgeVariance)
numOfRanges = 2
print("numOfRanges is set to " .. numOfRanges)

------------------------
--MOUNTAINS
------------------------
--High Level Decision: Is the mountain range vertical, horizontal, or diagonal?
orientationWeightTable = {}

-- tuning data for weight of mountain range orientation
verticalWeight = 1
horizontalWeight = 1

--create empty data point for cumulative weight also
cumulativeWeightRangeTypeTable = {}

--insert entries into this weight table containing our choices
table.insert(orientationWeightTable, {"vertical", verticalWeight})
table.insert(orientationWeightTable, {"horizontal", horizontalWeight})

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
--Select start and end coordinates for the two mountain ranges
--------------
--create 2 tables that'll hold the randomly chosen start and end points for each range
startCoordTable = {}
endCoordTable = {}

--set rangeLength for first range
--rangeLength = math.ceil(GetRandomInRange(minRangeLength, maxRangeLength))
rangeLength = mapHalfSize - 1

startA = math.ceil(GetRandomInRange(mapThirdSize, mapQuarterSize))
startB = 1
startCoord = {startA,startB}
table.insert(startCoordTable, startCoord)
print("Range 1 startA randomly set to " .. startA)
print("Range 1 startB set to " .. startB)

endA = math.ceil(GetRandomInRange(mapQuarterSize, mapThirdSize))
endB = rangeLength
endCoord = {endA,endB}	
table.insert(endCoordTable, endCoord)
print("Range 1 endA randomly set to " .. endA)
print("Range 1 endB set to " .. endB)	

startARange1 = startA

--same thing for range 2
--rangeLength = math.ceil(GetRandomInRange(minRangeLength, maxRangeLength))

startA = gridSize - startCoordTable[1][1]
startB = gridSize
startCoord = {startA,startB}
table.insert(startCoordTable, startCoord)
print("Range 2 startA randomly set to " .. startA)
print("Range 2 startB set to " .. startB)

endA = gridSize - endCoordTable[1][1]
endB = gridSize - rangeLength + 1
endCoord = {endA,endB}	
table.insert(endCoordTable, endCoord)
print("Range 2 endA randomly set to " .. endA)
print("Range 2 endB set to " .. endB)	

startARange2 = startA
--------------
--Select start and end coordinates
--------------
--Draw the ranges and set to appropriate terrain

for rangeIndex = 1, numOfRanges do
	
	startA = startCoordTable[rangeIndex][1]
	startB = startCoordTable[rangeIndex][2]
	endA = endCoordTable[rangeIndex][1]
	endB = endCoordTable[rangeIndex][2]	
	
	if (rangeType == 1) then --vertical
		--DrawLineOfTerrainNoDiagonal(startA, startB, endA, endB, true, mountainTerrain, gridSize, terrainLayoutResult)
		DrawLineOfTerrain(startA, startB, endA, endB, mountainTerrain, true, gridSize)
	else -- horizontal
		--DrawLineOfTerrainNoDiagonal(startB, startA, endB, endA, true, mountainTerrain, gridSize, terrainLayoutResult)
		DrawLineOfTerrain(startB, startA, endB, endA, mountainTerrain, true, gridSize)
	end
	
end

--adds a passage by checking mountain tiles somewhere close to the edge of the map
for row = 1, gridSize do
	for col = 1, gridSize do
		if((terrainLayoutResult[row][col].terrainType == mountainTerrain) and ((row == 1 + edgeVariance) or (row == gridSize - edgeVariance) or (col == 1 + edgeVariance) or (col == gridSize - edgeVariance))) then
			terrainLayoutResult[row][col].terrainType = tt_trees_plains_clearing
		end
	end
end

------------------------
--LAKES
------------------------
--create main lake starting at the very center of the map
lakeRing = {}

if(worldTerrainWidth <= 512) then --for micro maps
	lakeRing = Get12Neighbors(mapHalfSize, mapHalfSize, terrainLayoutResult)
else
	lakeRing = Get20Neighbors(mapHalfSize, mapHalfSize, terrainLayoutResult)
end

print("lakeRing has " .. #lakeRing .. " tiles")

for lakeRingIndex, coord in ipairs(lakeRing) do
			
	row = coord.x
	col = coord.y
		
	if (terrainLayoutResult[row][col].terrainType ~= mountainTerrain) then
		terrainLayoutResult[row][col].terrainType = lakeTerrain
		print("startRing set to lake")
	end
end

--ensures lakes run all the way to the edge of the mountain ranges

if (rangeType == 1) then --vertical
	for row = startARange1, startARange2 do
		for col = mapHalfSize-mapEighthSize, mapHalfSize+mapEighthSize do
			if(terrainLayoutResult[row][col].terrainType == tt_none) then
				terrainLayoutResult[row][col].terrainType = lakeTerrain
			end
		end
	end
else
	for row = mapHalfSize-mapEighthSize, mapHalfSize+mapEighthSize do
		for col = startARange1, startARange2 do
			if(terrainLayoutResult[row][col].terrainType == tt_none) then
				terrainLayoutResult[row][col].terrainType = lakeTerrain
			end
		end
	end	
end

GrowTerrainAreaToSize(mapHalfSize, mapHalfSize, lakeSize, {tt_none, lakeTerrain}, lakeTerrain, terrainLayoutResult)

--make sure the lake doesn't escape the inner part of the map
for row = 1, gridSize do
	for col = 1, gridSize do	
		if(terrainLayoutResult[row][col].terrainType == lakeTerrain) then
			if(row < mapThirdSize or col < mapThirdSize or row > gridSize - mapThirdSize or col > gridSize - mapThirdSize) then
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
		end
	end
end

--make some smaller lakes in the corner of the map, and set settlement spawns to be opposite of them

if (rangeType == 1) then --vertical
	lakeARow = 1
	lakeACol = 1
	lakeBRow = gridSize
	lakeBCol = gridSize
	terrainLayoutResult[2][gridSize-1].terrainType = tt_settlement_plains
	terrainLayoutResult[gridSize-1][2].terrainType = tt_settlement_plains
else -- horizontal
	lakeARow = 1
	lakeACol = gridSize
	lakeBRow = gridSize
	lakeBCol = 1
	terrainLayoutResult[2][2].terrainType = tt_settlement_plains
	terrainLayoutResult[gridSize-1][gridSize-1].terrainType = tt_settlement_plains
end

smallLakeASize = math.ceil(GetRandomInRange(minSmallLakeSize, maxSmallLakeSize))
print("smallLakeSize for lake B set to " .. smallLakeASize)

lakeARing = {}
lakeARing = GetNeighbors(lakeARow, lakeACol, terrainLayoutResult)
print("lakeARing has " .. #lakeARing .. " tiles")
	
for lakeARingIndex, coord in ipairs(lakeARing) do
			
	row = coord.x
	col = coord.y
		
	if (terrainLayoutResult[row][col].terrainType ~= mountainTerrain) then
		terrainLayoutResult[row][col].terrainType = tt_lake_shallow_hill
		print("lakeARing set to lake")
	end
end	
GrowTerrainAreaToSize(lakeARow, lakeACol, smallLakeASize, {tt_none, tt_lake_shallow_hill}, tt_lake_shallow_hill, terrainLayoutResult)

smallLakeBSize = math.ceil(GetRandomInRange(minSmallLakeSize, maxSmallLakeSize))
print("smallLakeSize for lake B set to " .. smallLakeBSize)	

lakeBRing = {}
lakeBRing = GetNeighbors(lakeBRow, lakeBCol, terrainLayoutResult)
print("lakeBRing has " .. #lakeBRing .. " tiles")
	
for lakeBRingIndex, coord in ipairs(lakeBRing) do
			
	row = coord.x
	col = coord.y
		
	if (terrainLayoutResult[row][col].terrainType ~= mountainTerrain) then
		terrainLayoutResult[row][col].terrainType = tt_lake_shallow_hill
		print("lakeBRing set to lake")
	end
end	
GrowTerrainAreaToSize(lakeBRow, lakeBCol, smallLakeBSize, {tt_none, tt_lake_shallow_hill}, tt_lake_shallow_hill, terrainLayoutResult)

--smooths out the lake to fill in any empty "holes" caused by the growterrain function
for row = 1, gridSize do
	for col = 1, gridSize do

	adjLake = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_lake_shallow_hill}, terrainLayoutResult)
	
	--check to see if it found any adjacent lakes, if there are more than 4 then set to lakes as well
	if(#adjLake >= 4) then
		print("found " .. #adjLake .. " lakes adjacent to " .. row .. ", " .. col)
		if (terrainLayoutResult[row][col].terrainType ~= mountainTerrain) then
			terrainLayoutResult[row][col].terrainType = tt_lake_shallow_hill
			print("set adjacent tile to lake")
		end
	end

	end
end

--loop through lakes and ensure their shores are shallow lake terrain
for row = 1, gridSize do
	for col = 1, gridSize do
	
		--check for lake terrain
		if(terrainLayoutResult[row][col].terrainType == lakeTerrain) then
			
			--grab neighbors, check for anything not also lake
			currentNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			hasLandNeighbor = false
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_none or terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_plains) then
					hasLandNeighbor = true
				end
				
			end
			
			currentNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				--check for lake-adjacent mountains
				if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == mountainTerrain) then
					terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_impasse_mountains
				end
				
			end
			
			if(hasLandNeighbor == true) then
				terrainLayoutResult[row][col].terrainType = tt_lake_shallow_clearing
			end
		end
	end
end

--set corner lake squares to spawn fish
terrainLayoutResult[lakeARow][lakeACol].terrainType = tt_lake_shallow_hill_fish
terrainLayoutResult[lakeBRow][lakeBCol].terrainType = tt_lake_shallow_hill_fish

--SETS ALL TT_NONE NEXT TO LAKES INTO PLAINS IF NOT MOUNTAIN (this avoids having hills next to lakes)

tempNeighborList = {}

for row = 1, gridSize do
	for col = 1, gridSize do
		-- first loop that checks if the tile is a lake
		if (terrainLayoutResult[row][col].terrainType == tt_lake_shallow_clearing or terrainLayoutResult[row][col].terrainType == lakeTerrain) then
			-- if lake, then find all the neighbors
			tempNeighborList = Get8Neighbors(row, col, terrainLayoutResult)
			
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				-- if the tile is a "none" tile (mountains and lakes wont be affected)
				if(terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_lake_shallow_clearing and terrainLayoutResult[tempRow][tempCol].terrainType ~= lakeTerrain 
						and terrainLayoutResult[tempRow][tempCol].terrainType ~= mountainTerrain and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_trees_plains_clearing
						and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_impasse_mountains) then					
					--set to plains
					terrainLayoutResult[tempRow][tempCol].terrainType = tt_valley_shallow_clearing_large
				end
			end			
		end
	end
end

--------------------------------
-- CLEANUP
--------------------------------

--checks for any passage (clearing) tiles, and replace the neighboring tiles IF not mountains to try and ensure paths are not blocked
for row = 1, gridSize do
	for col = 1, gridSize do
		-- first loop that checks if the tile is a passage tile (tt_plains_clearing)
		if (terrainLayoutResult[row][col].terrainType == tt_trees_plains_clearing) then

			tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
			
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				-- if the tile is not a mountain tile, then
				if(terrainLayoutResult[tempRow][tempCol].terrainType ~= mountainTerrain) then
					print("Found a non-mountain tile next to a passage! Turning into a plains tile! Coordinates x " .. tempRow .. " y " .. tempCol)
					terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
				end
			end			
		end
	end
end

--eliminate single lake squares
for row = 1, gridSize do
	for col = 1, gridSize do
		-- first loop that checks if the tile is a passage tile (tt_plains_clearing)
		if (terrainLayoutResult[row][col].terrainType == lakeTerrain or terrainLayoutResult[row][col].terrainType == tt_lake_shallow_clearing) then

			adjLakes = GetNeighbors(row, col, terrainLayoutResult)
			adjLakeNum = 0
			--loop through neighbors of the current square to look for lakes
			for testNeighborIndex, testNeighbor in ipairs(adjLakes) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
				
				if(currentTerrainType == lakeTerrain or currentTerrainType == tt_lake_shallow_clearing) then
					adjLakeNum = adjLakeNum + 1
				end
			end
			
			if(adjLakeNum == 0) then
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
		end
	end
end

--ensure lakes next to mountains are not shallow
for row = 1, gridSize do
	for col = 1, gridSize do
		if (terrainLayoutResult[row][col].terrainType == tt_lake_shallow_clearing) then

			adjMountains = GetNeighbors(row, col, terrainLayoutResult)
			adjMountainNum = 0
			adjPlainsNum = 0
			--loop through neighbors of the current square to look for lakes
			for testNeighborIndex, testNeighbor in ipairs(adjMountains) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
				
				if(currentTerrainType == mountainTerrain) then
					adjMountainNum = adjMountainNum + 1
				elseif(currentTerrainType == tt_lake_shallow_clearing or currentTerrainType == tt_plains) then
					adjPlainsNum = adjPlainsNum + 1
				end
			end
			
			if(adjMountainNum > 0 and adjPlainsNum == 0) then
				terrainLayoutResult[row][col].terrainType = lakeTerrain
			end
			
		end
	end
end

--check all lakes to ensure edge lakes are shallow
for row = 1, gridSize do
	for col = 1, gridSize do
		if (terrainLayoutResult[row][col].terrainType == lakeTerrain) then

			adjMountains = GetNeighbors(row, col, terrainLayoutResult)
			adjPlainsNum = 0
			--loop through neighbors of the current square to look for lakes
			for testNeighborIndex, testNeighbor in ipairs(adjMountains) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
				
				
				if(currentTerrainType == tt_plains or currentTerrainType == tt_none) then
					adjPlainsNum = adjPlainsNum + 1
				end
			end
			
			if(adjPlainsNum > 0) then
				terrainLayoutResult[row][col].terrainType = tt_lake_shallow_clearing
			end
		end
	end
end



------------------------
--PLAYER STARTS SETUP
------------------------
--Start Position Stuff--------------------------------------------------------------------------------
teamsList, playersPerTeam = SetUpTeams()

--Start Position Stuff---------------------------------------------------------------------------------
teamMappingTable = CreateTeamMappingTable()
minTeamDistance = gridSize
minPlayerDistance = 5
edgeBuffer = 2
spawnBlockers = {tt_mountains, tt_impasse_mountains, mountainTerrain, lakeTerrain, tt_lake_shallow_clearing, tt_plains_clearing, tt_holy_site}
openTypes = {tt_plains, tt_none}
cornerThreshold = 0

if(randomPositions == true) then
	minPlayerDistance = minTeamDistance
end

if (#teamMappingTable == 2) and (randomPositions == false) and (worldPlayerCount >= 2) then
	minTeamDistance = 7
	minPlayerDistance = 8
	if (rangeType == 1) then --vertical orientation
		terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .48, cornerThreshold, false, spawnBlockers, 1, 0.05, playerStartTerrain, tt_plains, 1, false, terrainLayoutResult)
	else --horizontal orientation
		terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .48, cornerThreshold, true, spawnBlockers, 1, 0.05, playerStartTerrain, tt_plains, 1, false,terrainLayoutResult)
	end
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .4, cornerThreshold, spawnBlockers, 1, 0.05, playerStartTerrain, tt_plains, 1, false, terrainLayoutResult)
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

--loop through and remove mountains against the map edge
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
		
		if(row <=2 or row >= gridSize - 1 or col <=2 or col >= gridSize-1) then
			if(terrainLayoutResult[row][col].terrainType == mountainTerrain) then
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
		end
	end
end

------------
--HOLY SITES
------------
-- placing holy sites in script rather than using balance distribution to accomodate a divided map of this type
numberOfHolySites = 2 -- this is the maximum; the actual number may be less depending on arrangement and player count.

-- variables for placing holy sites scaling to map size
print("holy sites TO PLACE: " ..numberOfHolySites)
playerDistanceBase = 4.0 -- the base distance for holy sites from player starts
holySiteDistanceBase = 4.0 -- base distance holy sites must be apart from each other
minimumHolySiteDistancePlayer = Round(playerDistanceBase / 13.0 * gridSize * 1.2, 0)
minimumHolySiteDistancePlayer = math.ceil(minimumHolySiteDistancePlayer * 2 / worldPlayerCount)
print("minimumHolySiteDistancePlayer = " ..minimumHolySiteDistancePlayer)
minimumHolySiteDistanceHolySites = Round(holySiteDistanceBase / 13.0 * gridSize * 1.2, 0)
minimumHolySiteDistanceHolySites = math.ceil(minimumHolySiteDistanceHolySites * 2 / worldPlayerCount)
print("minimumHolySiteDistanceHolySites = " ..minimumHolySiteDistanceHolySites)

if(worldPlayerCount == 1) then
    minimumHolySiteDistancePlayer = 1.0
end

holySiteLocations = {} -- table to hold holy site locations
-- find a place to put the holy site
print("PLACING " ..numberOfHolySites .." holy sites")

-- find all the plateau squares remaining on the coarse grid for holy site placement
validSquareListA = {}
validSquareListB = {}

if (rangeType == 1) then --vertical
	holySiteRowMin = mapHalfSize
	holySiteRowMax = mapHalfSize
	holySiteAColMin = 1
	holySiteAColMax = 1
	holySiteBColMin = gridSize
	holySiteBColMax = gridSize
	
	--loop through and add items to validSquareLists - A
	for row = holySiteRowMin, holySiteRowMax do
		for col = holySiteAColMin, holySiteAColMax do
			finalCoord = {row, col}
			if (terrainLayoutResult[row][col].terrainType ~= tt_lake_shallow_clearing) and (terrainLayoutResult[row][col].terrainType ~= tt_impasse_mountains) then
				table.insert(validSquareListA, finalCoord)
			end
		end
	end	

	--loop through and add items to validSquareLists - B
	for row = holySiteRowMin, holySiteRowMax do
		for col = holySiteBColMin, holySiteBColMax do
			finalCoord = {row, col}
			if (terrainLayoutResult[row][col].terrainType ~= tt_lake_shallow_clearing) and (terrainLayoutResult[row][col].terrainType ~= tt_impasse_mountains) then
				table.insert(validSquareListB, finalCoord)
			end
		end
	end	
	
else -- horizontal
	holySiteARowMin = 1
	holySiteARowMax = 1
	holySiteColMin = mapHalfSize
	holySiteColMax = mapHalfSize
	holySiteBRowMin = gridSize
	holySiteBRowMax = gridSize		

	--loop through and add items to validSquareLists - A
	for row = holySiteARowMin, holySiteARowMax do
		for col = holySiteColMin, holySiteColMax do
			finalCoord = {row, col}
			if (terrainLayoutResult[row][col].terrainType ~= tt_lake_shallow_clearing) and (terrainLayoutResult[row][col].terrainType ~= tt_impasse_mountains) then
				table.insert(validSquareListA, finalCoord)
			end
		end
	end	

	--loop through and add items to validSquareLists - B
	for row = holySiteBRowMin, holySiteBRowMax do
		for col = holySiteColMin, holySiteColMax do
			finalCoord = {row, col}
			if (terrainLayoutResult[row][col].terrainType ~= tt_lake_shallow_clearing) and (terrainLayoutResult[row][col].terrainType ~= tt_impasse_mountains) then
				table.insert(validSquareListB, finalCoord)
			end
		end
	end	
end


print("validSquareListA contains " ..  #validSquareListA)
print("validSquareListB contains " ..  #validSquareListB)

--Select a tile to turn into a Holy Site

holySiteAPlaced = false
while (holySiteAPlaced == false and #validSquareListA>0) do
	holySiteIndex = math.ceil(GetRandomInRange(1,#validSquareListA))
	holySiteRow = validSquareListA[holySiteIndex][1]
	holySiteCol = validSquareListA[holySiteIndex][2]
	holySiteCoords = {holySiteRow, holySiteCol}
	

	table.insert(holySiteLocations,holySiteCoords)
	terrainLayoutResult[holySiteRow][holySiteCol].terrainType = tt_holy_site
	print("holy site " ..(#holySiteLocations) .." PLACED AT: " ..holySiteRow ..", " ..holySiteCol)
	holySiteAPlaced = true	
    
end

holySiteBPlaced = false
while (holySiteBPlaced == false and #validSquareListB>0) do
	holySiteIndex = math.ceil(GetRandomInRange(1,#validSquareListB))
	holySiteRow = validSquareListB[holySiteIndex][1]
	holySiteCol = validSquareListB[holySiteIndex][2]
	holySiteCoords = {holySiteRow, holySiteCol}
	
	
	table.insert(holySiteLocations,holySiteCoords)
	terrainLayoutResult[holySiteRow][holySiteCol].terrainType = tt_holy_site
	print("holy site " ..(#holySiteLocations) .." PLACED AT: " ..holySiteRow ..", " ..holySiteCol)
	holySiteBPlaced = true    
	
end

if(holySiteAPlaced == false) then
	print("Could not find a valid location for a holy site A after trying every square")
end

if(holySiteBPlaced == false) then
	print("Could not find a valid location for a holy site B after trying every square")
end

print("end of NAGARI map")