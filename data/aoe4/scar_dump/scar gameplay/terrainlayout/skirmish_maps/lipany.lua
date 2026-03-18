-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING LIPANY")

-- variables containing terrain types to be used in map
n = tt_none  -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

s = tt_player_start_plains
p = tt_plains

m = tt_mountains
i = tt_impasse_mountains
b = tt_plateau_low
h = tt_hills_gentle_rolling
t = tt_trees_plains_stealth_large
v = tt_valley_shallow

playerStartTerrain = tt_player_start_classic_hills_low_rolling -- classic mode start

-- MAP/GAME SET UP ------------------------------------------------------------------------
gridHeight, gridWidth, gridSize = SetCoarseGrid() -- sets the coarse dimensions using the function found in map_setup lua file in the library folder

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid for terrain types and other data using default function found in map_setup lua in library folder
terrainLayoutresult = {} -- the grid for all terrain data (must use this name)
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)
closeStarts = false

teamMappingTable = CreateTeamMappingTable()
	
minPlayerDistance = 4.5
minTeamDistance = math.ceil(gridSize * 1.2)
edgeBuffer = 1
if(worldTerrainHeight >= 768) then
	edgeBuffer = 2
end

if(worldTerrainWidth <= 417) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2
		innerExclusion = 0.45
		cornerThreshold = 1
	elseif(worldTerrainWidth <= 513) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2
		innerExclusion = 0.45
		cornerThreshold = 1
	elseif(worldTerrainWidth <= 641) then
		minTeamDistance = Round((#terrainLayoutResult * 1.2))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2
		innerExclusion = 0.5
		cornerThreshold = 2
	elseif(worldTerrainWidth <= 769) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2
		innerExclusion = 0.5
		cornerThreshold = 2
	else
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2
		innerExclusion = 0.5
		cornerThreshold = 3
	end

playerStartTerrain = tt_player_start_classic_plains

spawnBlockers = {}
table.insert(spawnBlockers, tt_impasse_mountains)
table.insert(spawnBlockers, tt_mountains)
table.insert(spawnBlockers, tt_plateau_med)
table.insert(spawnBlockers, tt_plateau_low)

basicTerrain = {}
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_hills_gentle_rolling)
table.insert(basicTerrain, tt_none)

--cornerThreshold = 1

--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .5, cornerThreshold, spawnBlockers, 1, 0.001, playerStartTerrain, tt_plains_smooth, 3, true, terrainLayoutResult)
terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, 1, 0.001, playerStartTerrain, tt_plains_smooth, 2, true, terrainLayoutResult)
startLocationPositions = {}

--loop through and record player starts
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
		
		currentData = {}
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			currentData = {row, col}
			table.insert(startLocationPositions, currentData)
		end
		
	end
end

-- PLACE TERRAIN FEATURES

-- place mountain or cliff areas around player starts
numImpasseSquares = 3

impasseTerrainTypes = {b, b, b, v, v, v, h, h, h} -- table holding the types of terrain used for impasse area. Multiple entries used for weighting

-- cycle through each player start
for pIndex = 1, #startLocationPositions do
	pX = startLocationPositions[pIndex][1]
	pY = startLocationPositions[pIndex][2]
	
	potentialImpasseSquares = GetAllSquaresInRingAroundSquare(pX, pY, 3, 1, terrainLayoutResult)
	-- remove any squares that are on the map border
	for index = #potentialImpasseSquares, 1, -1 do
		x = potentialImpasseSquares[index][1]
		y = potentialImpasseSquares[index][2]
		
		if (x == 1 or x == gridHeight or y == 1 or y == gridWidth) then
			table.remove(potentialImpasseSquares, index)
		end
	end
	
	-- randomly determine terrain type from impasse terrain table and place it
	for sIndex = 1, numImpasseSquares do
		squareIndex = GetRandomIndex(potentialImpasseSquares)
		x = potentialImpasseSquares[squareIndex][1]
		y = potentialImpasseSquares[squareIndex][2]
		if(terrainLayoutResult[x][y].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[x][y].terrainType = GetRandomElement(impasseTerrainTypes)
		end
		table.remove(potentialImpasseSquares, squareIndex)
	end
	
end

-- place a stealth wood roughly between all players combined.
-- calculate mid point
if(#startLocationPositions > 1) then -- only place the forest if there is more than one player
	
	-- add up start location row and column values to calculate average
	xTotal = 0
	yTotal = 0
	for index = 1, #startLocationPositions do
		x = startLocationPositions[index][1]
		y = startLocationPositions[index][2]
		xTotal = xTotal + x
		yTotal = yTotal + y
	end
	
	-- place forest terrain center at average position between players
	forestCenterX = math.floor(xTotal / #startLocationPositions)
	forestCenterY = math.floor(yTotal / #startLocationPositions)
	
	-- place stealth forest
	baseNumForests = 3 -- base number of forests (after the initial 1st forest placement)
	numForests = math.floor(baseNumForests / 13 * gridSize) -- number of forests after scaling for # of players and map size
	print("Number of stealth forests is " ..numForests)
--	terrainLayoutResult[forestCenterX][forestCenterY].terrainType = t
	
	forestRingRadius = 1
	forestRingWidth = 1
	
	-- increase the radius of hte forest area as large maps will have more forest squares
	if numForests > 8 then
		forestRingRadius = 2
		forestRingWidth = 2
	end
	
	-- pick a random square around the forest center and set it to forest terrain
	for index = 1, numForests do
		x,y = GetSquareInRingAroundSquare(forestCenterX, forestCenterY, 1, 1, {playerStartTerrain, t}, terrainLayoutResult)
		
		if (x~= nil and y ~= nil) then
	--		terrainLayoutResult[x][y].terrainType = t
		end
		
	end
	
end

--------------------------------
-- CLEANUP
--------------------------------

--checks for any large patches of inaccessible terrain and breaks it up
	for row = 1, gridSize do
		for col = 1, gridSize do
			if (terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) then
				adjMountain = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_mountains}, terrainLayoutResult)
				adjPlateau = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_plateau_low}, terrainLayoutResult)
				totalImpasse = #adjMountain + #adjPlateau
				--check to see if it found too many adjacent plateaus or mountains, then this tile gets set to a gentle hill to allow a way up
				if(totalImpasse >= 5) then
					print("tile found surrounded by impasse")
					print("found " .. #adjMountain .. " mountain adjacent to " .. row .. ", " .. col)
					print("found " .. #adjPlateau .. " plateau adjacent to " .. row .. ", " .. col)
					terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
					print("set terrain surrounded by impasse to hill")
				end
			end
		end
	end	

--replaces any plateaus found on the edge of the map with a gentle hill instead
for row = 1, gridSize do
	for col = 1, gridSize do
		if((terrainLayoutResult[row][col].terrainType == tt_plateau_low) and (row == 1 or row == gridSize or col == 1 or col == gridSize)) then
			terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
		end
	end
end

--do a pass around all player starts to ensure flat build space
for pIndex = 1, #startLocationPositions do
	pX = startLocationPositions[pIndex][1]
	pY = startLocationPositions[pIndex][2]
	
	startNeighbors = Get20Neighbors(pX, pY, terrainLayoutResult)
	for neighborIndex, startNeighbor in ipairs(startNeighbors) do
		currentNeighborRow = startNeighbor.x
		currentNeighborCol = startNeighbor.y 
		terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains_smooth
	end
	
end

--ensure that the edge of the map is flat
for row = 1, gridSize do
	for col = 1, gridSize do
		if((terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) and (row <= 2 or row >= gridSize-1 or col <= 2 or col >= gridSize-1)) then
			terrainLayoutResult[row][col].terrainType = tt_plains
		end
	end
end

--pick a spot on the edge of the map
randomFirstCoord = math.ceil(worldGetRandom() * #terrainLayoutResult)
randomSecondCoord = #terrainLayoutResult - randomFirstCoord

if(randomSecondCoord < 1) then
	randomSecondCoord = 1
end
tradePostCoord1 = {}
tradePostCoord2 = {}
if(worldGetRandom() > 0.5) then
	tradePostCoord1 = {1, randomFirstCoord}
	tradePostCoord2 = {#terrainLayoutResult, randomSecondCoord}
else
	tradePostCoord1 = {randomFirstCoord, 1}
	tradePostCoord2 = {randomSecondCoord, #terrainLayoutResult}
end



terrainLayoutResult[tradePostCoord1[1]][tradePostCoord1[2]].terrainType = tt_settlement_plains
tradeNeighbors = {}
tradeNeighbors = Get8Neighbors(tradePostCoord1[1], tradePostCoord1[2], terrainLayoutResult)

for neighborIndex, tradeNeighbor in ipairs(tradeNeighbors) do	
	currentNeighborRow = tradeNeighbor.x
	currentNeighborCol = tradeNeighbor.y
	
	terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
end

terrainLayoutResult[tradePostCoord2[1]][tradePostCoord2[2]].terrainType = tt_settlement_plains
tradeNeighbors = {}
tradeNeighbors = Get8Neighbors(tradePostCoord2[1], tradePostCoord2[2], terrainLayoutResult)

for neighborIndex, tradeNeighbor in ipairs(tradeNeighbors) do	
	currentNeighborRow = tradeNeighbor.x
	currentNeighborCol = tradeNeighbor.y
	
	terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
end

--draw line of plains to the centre of the map from each player start
mapHalfSize = math.ceil(gridSize / 2)
for row = 1, gridSize do
	for col = 1, gridSize do
		
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			newLine = {}
			newLine = DrawLineOfTerrainNoDiagonalReturn(row, col, mapHalfSize, mapHalfSize, false, tt_plains, gridSize, terrainLayoutResult)
			
			for lineIndex = 1, #newLine do
			
				currentRow = newLine[lineIndex][1]
				currentCol = newLine[lineIndex][2]
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType ~= playerStartTerrain and terrainLayoutResult[currentRow][currentCol].terrainType ~= tt_settlement_plains) then
					terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
				end
			end
			
		end
	end
end

print("END OF LIPANY LUA SCRIPT")
