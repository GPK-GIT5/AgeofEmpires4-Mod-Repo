print("GENERATING CRATERS...")

--------------------------------------------------
--TERRAIN TYPES
--------------------------------------------------

-- variables containing terrain types to be used in map
n = tt_none  -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

p = tt_plains
c = tt_plains_clearing_craters
m = tt_mountains
i = tt_impasse_mountains
b = tt_plateau_low
bc = tt_plateau_low_clear
bt = tt_trees_plateau_low_craters
h = tt_hills_gentle_rolling
e = tt_hills_low_rolling

t = tt_trees_plains_stealth_large
v = tt_valley_shallow
l = tt_lake_medium_craters -- places a crater lake with a local distribution of fish
s = tt_settlement_plateau_craters

m = tt_meteor_craters

playerStartTerrain = tt_player_start_classic_plateau_low_craters -- classic mode start

--------------------------------------------------
--TUNABLES
--------------------------------------------------

-- playerStartBuffer is a buffer from the edge of the map for placing player starts. 
-- Will not strictly hit this number (some players may be a square closer or further to the edge), but establishes the player start circle radius
-- Larger numbers result in a smaller circle of player starts. Too large a number will not leave room for players to each have their own starting square.
playerStartBuffer = 2 -- default 2, range should be no more/less than 2-4

-- lake placement variables
placeLakes = true -- bool to determine if lakes are placed (may make this a random chance in hte future if desired)
baseMinLakeDistanceFromPlayers = 2 -- Should scale with map sizes above 640
baseMinLakeSeperation = 2

-- crater placement variables
minDistanceFromCraters = 3 -- how far craters must be from player starts
minDistanceFromPlayers = {[416] = 3, [512] = 3, [640] = 3, [768] = 3, [896] = 3}
minDistanceFromLakes = {[416] = 2, [512] = 2, [640] = 2, [768] = 2, [896] = 2}

meteorAngleOffset = {[416] = 25, [512] = 20, [640] = 20, [768] = 20, [896] = 20}
meteorEdgeBuffer = 2

-- edge tree variables
minTreePlayerSeparation = 2 -- minimum distance edge trees must be from player starts

--------------------------------------------------
--FUNCTIONS
--------------------------------------------------

--- PLACE PLAYER STARTS
 -- places player positions in a regular circle to facilitate dividing the map between teams. Handles both random and teams together placement.
 -- randomPlacement is the passed in variable to chekc if the player has chosen random placement or teams together
 -- teamTable is the teamMappingTable created below
 -- numPlayers is the total number of players in thhe match
 -- size is the map size
 -- midPoint is the center of the coarse grid
 -- edgeBuffer is the rough distance from the map edge that will help define the radius of the player placement circle
 -- startTT is the player start terrain type
 -- terrain layout is the terrainLayoutResult table that stores terrain and player start info
function PlacePlayerStarts(randomPlacement, teamTable, numPlayers, size, midPoint, edgeBuffer, startTT, terrainLayout)	
	print("!!! PLACE PLAYER STARTS")
	-- place positions in a circle around the map
	local positions = {} -- holds the row and column of the start positions
	
	local radius = midPoint - edgeBuffer -- calculate the radius of the circle
	local increment = Round(360 / numPlayers, 0) -- calculate the angle increment based on thhe number of players	
	local angleOffset = Round(GetRandomInRange(0, 4), 0) * 15 -- will add a random rotation to the player starts
	
	if(worldTerrainWidth == 512 and worldPlayerCount >=4) then
		angleOffset = Round(GetRandomInRange(0, 3), 0) * 45 -- keeps angles at 45 degrees to ensure space for lake placement
	elseif(worldTerrainWidth == 640 and worldPlayerCount >=4)then
		local roll = Round(GetRandomInRange(1, 3), 0) -- sets angles to ensure space for lake placement (20, 50, 72)
		if(roll == 1) then
			angleOffset = 20
		elseif(roll == 2) then
			angleOffset = 50
		elseif(roll == 3) then
			angleOffset = 72
		end
	end

	-- calculate row and column values for the circle of positions
	for index = 1, numPlayers do
		local angle = index * increment + angleOffset
		row = Round(radius * math.cos(angle * math.pi / 180), 0)
		col = Round(radius * math.sin(angle * math.pi / 180), 0)
		row = row + midPoint
		col = col + midPoint
		
		table.insert(positions, {row, col})
	end
	
	if(randomPlacement == true) then -- assign players to locations randomly
		for tIndex = 1, #teamTable do
			for pIndex = 1, #teamTable[tIndex].players do
				posIndex = GetRandomIndex(positions)
				terrainLayout[positions[posIndex][1]][positions[posIndex][2]].terrainType = startTT
				terrainLayout[positions[posIndex][1]][positions[posIndex][2]].playerIndex = teamTable[tIndex].players[pIndex].playerID - 1
				table.remove(positions, posIndex)
			end
		end
	else -- assign players grouped together with their team
		local posIndex = 1
		
		for tIndex = 1, #teamTable do
			for pIndex = 1, #teamTable[tIndex].players do
				terrainLayout[positions[posIndex][1]][positions[posIndex][2]].terrainType = startTT
				terrainLayout[positions[posIndex][1]][positions[posIndex][2]].playerIndex = teamTable[tIndex].players[pIndex].playerID - 1
				print("Team " ..teamTable[tIndex].teamID ..", Player " ..teamTable[tIndex].players[pIndex].playerID - 1 ..", Row " ..positions[posIndex][1] ..", Col " ..positions[posIndex][2])
				posIndex = posIndex + 1
			end
		end
	end
	
	return angleOffset -- will use this later to place meteors
end

--- PLACE METEORS
 -- places meteors in a ring based on the previously placed player starts
function PlaceMeteors(angleOffsetPlayers, numMeteors, meteorOffset, size, midPoint, edgeBuffer, meteorTT, terrainLayout)
	-- place positions in a circle around the map
	local positions = {} -- holds the row and column of the meteor positions
	
	local radius = midPoint - edgeBuffer -- calculate the radius of the circle
	local increment = Round(360 / numMeteors, 0) -- calculate the angle increment based on the number of meteors (should always be equal to num players)
	local totalOffset = (angleOffsetPlayers + meteorOffset) * 1
	
	-- calculate row and column values for the circle of positions
	for index = 1, numMeteors do
		local angle = index * increment + totalOffset
		row = Round(radius * math.cos(angle * math.pi / 180), 0)
		col = Round(radius * math.sin(angle * math.pi / 180), 0)
		row = row + midPoint
		col = col + midPoint
		
		table.insert(positions, {row, col})
	end
	
	-- place the meteor terrain at the calculated positions
	for index = 1, #positions do
		local row = positions[index][1]
		local col = positions[index][2]
		--terrainLayout[row][col].terrainType = meteorTT
	end
	
	return positions
end

--- GET CRATER EXIT
-- gets the immediate cardinal point neighbors of the crater square and selects the one closest to the player start square
-- to be used repeatedly to generate a ramp out of the lake square so each player has a reachable lake
-- playerCol, playerRow is the player start position
-- craterCOl, craterRow is hte crater position
-- layoutResult is the terrainLayoutResult
-- placeCliff terrain is a bool that places the terrain on hte map if true
-- cliff terrain is the terrain type for the cliff
function GetCraterExit (playerCol, playerRow, craterCol, craterRow, layoutResult, placeCliffTerrain, cliffTerrain)
	local getNeighborResults = {}
	getNeighborResults = GetNeighbors(craterCol, craterRow, layoutResult)
	
	local craterNeighborSquares = {}
	
	-- format the neighbor results to work with get closest square
	if(#getNeighborResults > 0) then
		if(#getNeighborResults > 0) then
			for j = 1, #getNeighborResults do
				local nCol = getNeighborResults[j].x
				local nRow = getNeighborResults[j].y
				table.insert(craterNeighborSquares, {nCol, nRow})
			end
		end
	end
	
	if(placeCliffTerrain == true) then
		for i = 1, #craterNeighborSquares do
			col = craterNeighborSquares[i][1]
			row = craterNeighborSquares[i][2]
			if(col ~= playerCol and row ~= playerRow) then				
				if(layoutResult[col][row].terrainType ~= l and layoutResult[col][row].terrainType ~= c) then -- do not place neighboring cliff terrain over plains or player starts
					layoutResult[col][row].terrainType = cliffTerrain
				end
			end
		end
	end
	
	local exitCol = 0
	local exitRow = 0
	local exitIndex = 0
	
	--get the closest neighbor square to the player start
	if(#craterNeighborSquares > 0) then		
		exitCol, exitRow, exitIndex = GetClosestSquare(playerCol, playerRow, craterNeighborSquares)
	else
		print("ZERO NEIGHBORS TO CRATER SQUARE")
	end
	
	print("Exit Col: " ..exitCol .." Exit Row: " ..exitRow)
	return exitCol, exitRow
end

--- PLACE LAKE CRATERS
-- places one lake crater near each player and creates a lane of traversable terrain towards that player for access
 -- size is the coarse grid size
 -- playerLocations is the table holding the positions of the player starts
 -- minPlayerDistance is the minimum distance lakes must be from each player
 -- minLakeDistance is the distance each lake must be from all other lakes
 -- lakeExitTerrain are three variables holding the terrain types that create a "ramp" down to the lake
function PlaceLakeCraters(size, playerLocations, minPlayerDistance, minLakeDistance, lakeTerrain, lakeExitTerrain1, lakeExitTerrain2, lakeExitTerrain3)
	print("--- PLACE LAKE CRATERS ---")
	
	-- create a table of potential lake squares
	local openSquares = {} -- table holding the position of the squares
	for col = 1, size do
		for row = 1, size do
			if(SquaresFarEnoughApartEuclidian(col, row, minPlayerDistance, playerLocations, size) == true) then	--square is far enough from players			
				if (col > 3 and col < gridSize - 3 and row > 3 and row <= gridSize - 3) then
					if(terrainLayoutResult[col][row].terrainType == n) then
						table.insert(openSquares, {col, row})
					end	
				end
			end
		end
	end
	
	local pIndex = 1
	local lakeSquares = {} -- table to hold the lake sqaures
	local lakeTable = {} -- table to hold the lake coords and each player's coords
	
	while(#openSquares > 0 and pIndex <= #playerLocations) do		
		lakeSquareSelected = false
		
		pCol = playerLocations[pIndex][1]
		pRow = playerLocations[pIndex][2]
		
		-- variables for the closest lake square to the current player
		local lakeCol = 0
		local lakeRow = 0
		local lakeSquareIndex = 0
		
		-- find the closest lake square to the current player
		lakeCol, lakeRow, lakeSquareIndex = GetClosestSquare(pCol, pRow, openSquares)
		
		if(#lakeSquares > 0) then -- check if any lakes have been placed
			if(SquaresFarEnoughApartEuclidian(lakeCol, lakeRow, minLakeDistance, lakeSquares, size) == true) then -- ensure the new lake is far enough from the other lakes
				terrainLayoutResult[lakeCol][lakeRow].terrainType = lakeTerrain
				table.insert(lakeSquares, {lakeCol, lakeRow})
				table.insert(lakeTable, {lake = {lakeCol, lakeRow}, player = {pCol, pRow}})
				table.remove(openSquares, lakeSquareIndex)
				pIndex = pIndex + 1
				lakeSquareSelected = true
			else
				table.remove(openSquares, lakeSquareIndex)
			end
		else  -- place the first lake crater				
			terrainLayoutResult[lakeCol][lakeRow].terrainType = lakeTerrain
			table.insert(lakeSquares, {lakeCol, lakeRow})
			table.insert(lakeTable, {lake = {lakeCol, lakeRow}, player = {pCol, pRow}})
			table.remove(openSquares, lakeSquareIndex)
			pIndex = pIndex + 1
			lakeSquareSelected = true
		end
		
		if(lakeSquareSelected == true) then
			-- three passes of the GetCraterExit function to make a traversible ramp out of the lake
			local rampCol = 0
			local rampRow = 0
			rampCol, rampRow = GetCraterExit(pCol, pRow, lakeCol, lakeRow, terrainLayoutResult, true, b) -- get the first ramp square from the lake
			if (rampCol ~= nil and rampRow ~= nil) then
				terrainLayoutResult[rampCol][rampRow].terrainType = lakeExitTerrain1
			end
			
			rampCol, rampRow = GetCraterExit(pCol, pRow, rampCol, rampRow, terrainLayoutResult, true, lakeExitTerrain1) -- get the exit square from the previous ramp square. Use previous ramp terrain to surround square if placeCliffTerrain set to true
			if (rampCol ~= nil and rampRow ~= nil) then
				terrainLayoutResult[rampCol][rampRow].terrainType = lakeExitTerrain2
			end
			
			rampCol, rampRow = GetCraterExit(pCol, pRow, rampCol, rampRow, terrainLayoutResult, false, lakeExitTerrain2) -- get the exit square from the previous ramp square
			if (rampCol ~= nil and rampRow ~= nil) then
				terrainLayoutResult[rampCol][rampRow].terrainType = lakeExitTerrain3
			end
		end			
	end
	
	return lakeTable
end

--- SMOOTH LAKE RAMPS
 -- ensures a smooth gradient of terrain around the lake ramps to remove excess impasse that blocks players
 -- rampTT01, rampTT02, rampTT03 are the terrain types used for hte lake ramps with rampTT01 being xlosest to the lake
function SmoothLakeRamps(rampTT01, rampTT02, rampTT03)
	
	local ramp01Squares = {}
	local ramp02Squares = {}
	local ramp03Squares = {}
	
	-- find all the rampTT01 squares
	for col = 1, gridSize do
		for row = 1, gridSize do
			if (terrainLayoutResult[col][row].terrainType  == rampTT01) then
				table.insert(ramp01Squares, {col,row})			
			end
		end
	end
	
	-- go through each ramp square, get its cardinal neighbors and place rampTT02 sqares on empty and cliff squares to smooth the ramp gradient
	for rIndex = 1, #ramp01Squares do
		local rampNeighbors = GetNeighbors(ramp01Squares[rIndex][1], ramp01Squares[rIndex][2], terrainLayoutResult)
		
		for nIndex = 1, #rampNeighbors do
			local rCol = rampNeighbors[nIndex].x
			local rRow = rampNeighbors[nIndex].y
			if(terrainLayoutResult[rCol][rRow].terrainType == n or terrainLayoutResult[rCol][rRow].terrainType == b) then
				terrainLayoutResult[rCol][rRow].terrainType = rampTT02
			end
		end
	end
	
	-- find all the rampTT02 squares
	for col = 1, gridSize do
		for row = 1, gridSize do
			if (terrainLayoutResult[col][row].terrainType  == rampTT02) then
				table.insert(ramp02Squares, {col,row})			
			end
		end
	end
	
	-- go through each ramp square, get its cardinal neighbors and place rampTT03 sqares on empty and cliff squares to smooth the ramp gradient
	for rIndex = 1, #ramp02Squares do
		local rampNeighbors = GetNeighbors(ramp02Squares[rIndex][1], ramp02Squares[rIndex][2], terrainLayoutResult)
		
		for nIndex = 1, #rampNeighbors do
			local rCol = rampNeighbors[nIndex].x
			local rRow = rampNeighbors[nIndex].y
			if(terrainLayoutResult[rCol][rRow].terrainType == n or terrainLayoutResult[rCol][rRow].terrainType == b) then
				terrainLayoutResult[rCol][rRow].terrainType = rampTT03
			end
		end
	end
		
end

--- SELECT TREE SQUARE
-- finds a square to place a terrain type that spawns the nuetral settlement from a list of edge squares passed in
-- startLocations is the table holding the player start positions (formatted {{col, row}, {col, row}, etc.})
function SelectTreeSquare(squares, startLocations)
	local treeCol = 0
	local treeRow = 0
	
	while(#squares > 0) do
		local squareIndex = GetRandomIndex(squares)
		
		treeCol = squares[squareIndex][1]
		treeRow = squares[squareIndex][2]
		
		if(SquaresFarEnoughApart(treeCol,treeRow, minTreePlayerSeparation, startLocations, gridSize) == true) then			
			return treeCol, treeRow
		end
		
		table.remove(squares, squareIndex)
	end
	
	return treeCol, treeRow
end

--- PLACE EDGE TREES
-- places terrain with a local dense woods distribution on the mid sides of the map
-- startLocations is the table holding the player start positions (formatted {{col, row}, {col, row}, etc.})
function PlaceEdgeTrees(startLocations)
	
	local sideTreeWidth = math.floor(gridSize * 0.2) - 1
	local mapHalfSize = math.ceil(gridSize/2)
	local lowSquare = mapHalfSize - sideTreeWidth
	local highSquare = mapHalfSize + sideTreeWidth
	
	local topSquares = {}
	local bottomSquares = {}
	local leftSquares = {}
	local rightSquares = {}
	
	-- top trees
	local range = Round(GetRandomInRange(lowSquare, highSquare), 0)
	
	for index = lowSquare, highSquare do
		table.insert(topSquares, {1, index})
		table.insert(bottomSquares, {gridSize, index})
		table.insert(leftSquares, {index, 1})
		table.insert(rightSquares, {index, gridSize})
	end
	
	-- top trees
	local treeCol, treeRow = SelectTreeSquare(topSquares, startLocations)
	
	if(treeCol > 0 and treeRow > 0) then
		terrainLayoutResult[treeCol][treeRow].terrainType = bt
	end
	
	-- bottom trees
	treeCol, treeRow = SelectTreeSquare(bottomSquares, startLocations)
	
	if(treeCol > 0 and treeRow > 0) then
		terrainLayoutResult[treeCol][treeRow].terrainType = bt
	end
	
	-- left trees
	treeCol, treeRow = SelectTreeSquare(leftSquares, startLocations)
	
	if(treeCol > 0 and treeRow > 0) then
		terrainLayoutResult[treeCol][treeRow].terrainType = bt
	end
	
	-- right trees
	treeCol, treeRow = SelectTreeSquare(rightSquares, startLocations)
	
	if(treeCol > 0 and treeRow > 0) then
		terrainLayoutResult[treeCol][treeRow].terrainType = bt
	end		
	
end

--- PLACE TRADE SETTLEMENTS
-- places a terrain type that spawns nuetral settlements along the edge of the map
-- settlementSquares are the potential locations to choose for placing a settlement
-- startLocations is the table holding the player start positions (formatted {{col, row}, {col, row}, etc.})
-- minPlayerDistance is the minimum distance the settlement must be from players
-- numSettlements is the number of settlements to place
function PlaceTradeSettlements(settlementSquares, startLocations, minPlayerDistance, meteorPositions, minMeteorDistance, numSettlements)	
	print("PLACE TRADE SETTLEMENTS")
	local settlementLocations = {}

	while (#settlementSquares > 0 and #settlementLocations < numSettlements) do
		--print("COUNT: " ..count .. " Settlement Squares: " ..#settlementSquares)
		local squareIndex = GetRandomIndex(settlementSquares)		
		local sCol = settlementSquares[squareIndex][1]
		local sRow = settlementSquares[squareIndex][2]
		
		local neighbors = GetNeighbors(sCol, sRow, terrainLayoutResult)
		
		for index = 1, #neighbors do
			local nCol = neighbors[index].x
			local nRow = neighbors[index].y

			if(terrainLayoutResult[nCol][nRow].terrainType == p or terrainLayoutResult[nCol][nRow].terrainType == v or terrainLayoutResult[nCol][nRow].terrainType == h) then
				goto continue
			end
		end
		
		if(SquaresFarEnoughApartEuclidian(sCol, sRow, minPlayerDistance, startLocations, gridSize) == true and #settlementLocations == 0) then
			if(SquaresFarEnoughApartEuclidian(sCol, sRow, minMeteorDistance, meteorPositions, gridSize) == true) then
				terrainLayoutResult[sCol][sRow].terrainType = s
				table.insert(settlementLocations, {sCol, sRow})
				local sCol02 = gridSize - sCol + 1
				local sRow02 = gridSize - sRow + 1
				terrainLayoutResult[sCol02][sRow02].terrainType = s
				table.insert(settlementLocations, {sCol02, sRow02})
			end
		end	
		
		::continue::
		table.remove(settlementSquares, squareIndex)
	end	

	return settlementLocations	
	
end

--------------------------------------------------
--MAIN MAP SCRIPT
--------------------------------------------------

-- MAP/GAME SET UP ------------------------------------------------------------------------
gridHeight, gridWidth, gridSize = SetCoarseGrid() -- sets the coarse dimensions using the function found in map_setup lua file in the library folder
mapMidPoint = math.ceil(gridSize / 2)

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid for terrain types and other data using default function found in map_setup lua in library folder
terrainLayoutResult = {} -- the grid for all terrain data (must use this name)
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)


-- PLAYER SETUP ---------------------------------------------------------------------------
-- set variables for player start is there is at least one player
if(worldPlayerCount > 0) then -- ensure there is at least one player before setting player starts
	teamMappingTable = CreateTeamMappingTable()
	playerAngleOffset = PlacePlayerStarts(randomPlacement, teamMappingTable, worldPlayerCount, gridSize, mapMidPoint, playerStartBuffer, playerStartTerrain, terrainLayoutResult)
end

startLocationPositions = {} -- inmitialize table to hold start positions

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

-- PLACE TERRAIN FEATURES -------------------------------------------------------------

--do a pass around all player starts to ensure flat build space
for pIndex = 1, #startLocationPositions do
	pX = startLocationPositions[pIndex][1]
	pY = startLocationPositions[pIndex][2]
	
	startNeighbors = Get20Neighbors(pX, pY, terrainLayoutResult)
	for neighborIndex, startNeighbor in ipairs(startNeighbors) do
		currentNeighborRow = startNeighbor.x
		currentNeighborCol = startNeighbor.y
		if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == n) then
			terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = b
		end
	end
	
end

-- Lake crater placement near player starts
-- scale the base distance based on map size
minLakeDistanceFromPlayers = baseMinLakeDistanceFromPlayers

if(worldTerrainWidth > 10000) then -- after testing have dcided not to scale but keeping in case latter scaling needed 
	minLakeDistanceFromPlayers = Round(baseMinLakeDistanceFromPlayers / 512 * worldTerrainWidth)
end

-- place lake craters
minLakeSeperation = 2
lakeTable = {}

if(placeLakes == true) then -- may make lake apperance random in the future if desired
	if(#startLocationPositions > 0) then
		lakeTable = PlaceLakeCraters(gridSize, startLocationPositions, minLakeDistanceFromPlayers, minLakeSeperation, l, c, h, e)
	end
end

-- smooth the lake "ramps" to reduce map clogging impasse
SmoothLakeRamps(c, h, e)

for index = 1, #lakeTable do
	lakeNieghborsXY = GetNeighbors(lakeTable[index].lake[1], lakeTable[index].lake[2], terrainLayoutResult)
	lakeNeighbors = {}
	
	for nIndex = 1, #lakeNieghborsXY do
		col = lakeNieghborsXY[nIndex].x
		row = lakeNieghborsXY[nIndex].y
		table.insert(lakeNeighbors, {col, row})
	end
	
	pCol = lakeTable[index].player[1]
	pRow = lakeTable[index].player[2]
	cliffCol, cliffRow, cliffIndex = GetFurthestSquare(pCol, pRow, lakeNeighbors)
	terrainLayoutResult[cliffCol][cliffRow].terrainType = b
end

meteorLocations = {}
meteorLocations = PlaceMeteors(playerAngleOffset, worldPlayerCount, meteorAngleOffset[worldTerrainWidth], gridSize, mapMidPoint, meteorEdgeBuffer, m, terrainLayoutResult)

-- individually adjust crater positions if they are too close to player starts
for index = 1, #meteorLocations do
	local row = meteorLocations[index][1]
	local col = meteorLocations[index][2]
	
	local playerRow, playerCol, playerIndex = GetClosestSquare(row, col, startLocationPositions)
	
	if(SquaresFarEnoughApart(row, col, minDistanceFromPlayers[worldTerrainWidth], {{playerRow, playerCol}}, gridSize) == false) then
		-- move the square further from this player position by one square
		local neighbors = GetNeighbors(row, col, terrainLayoutResult)
		local formattedNeighbors = {}
		
		for nIndex = 1, #neighbors do
			local x = neighbors[nIndex].x
			local y = neighbors[nIndex].y
			table.insert(formattedNeighbors, {x, y})
		end
		
		local fRow, fCol, fIndex = GetFurthestSquare(playerRow, playerCol, formattedNeighbors)
		meteorLocations[index] = {fRow, fCol}
	end
end

-- format lake positions for use in distance functions
lakePositions = {}
for index = 1, #lakeTable do
	local row = lakeTable[index].lake[1]
	local col = lakeTable[index].lake[2]
	
	table.insert(lakePositions, {row, col})
end

-- check if the craters are too close to lakes
for index = 1, #meteorLocations do
	local row = meteorLocations[index][1]
	local col = meteorLocations[index][2]
	
	local lakeRow, lakeCol, lakeIndex = GetClosestSquare(row, col, lakePositions)
	
	-- move meteor if too close to lake
	if(SquaresFarEnoughApart(row, col, minDistanceFromLakes[worldTerrainWidth], {{lakeRow, lakeCol}}, gridSize) == false) then
		-- adjust meteor position
		local neighbors = GetNeighbors(row, col, terrainLayoutResult)
		local formattedNeighbors = {}
		
		for nIndex = 1, #neighbors do
			local x = neighbors[nIndex].x
			local y = neighbors[nIndex].y
			table.insert(formattedNeighbors, {x, y})
		end
		
		local fRow, fCol, fIndex = GetFurthestSquare(lakeRow, lakeCol, formattedNeighbors)
		meteorLocations[index] = {fRow, fCol}
	end
end

-- place clearing terrain in the map corners to make room for dense woods
terrainLayoutResult[1][1].terrainType = bc
terrainLayoutResult[1][gridSize].terrainType = bc
terrainLayoutResult[gridSize][1].terrainType = bc
terrainLayoutResult[gridSize][gridSize].terrainType = bc

-- place tree terrain on middle edges of maps
PlaceEdgeTrees(startLocationPositions)

-- place neutral trading posts
potentialTradeSquares = {} -- table to hold terrain squares to choose from for settlements

-- find squares along the edge of the map that do not get too far into the dense woods in the corner
-- set the start and end squares to search from

-- values for map size 416
startingCol = 2
startingRow = 2
endingCol = gridSize - 1
endingRow = gridSize - 1

-- adjust start and end squares based on map size to avoid corner trees
if(worldTerrainWidth > 512) then
	startingCol = 2
	startingRow = 2
	endingCol = gridSize - 1
	endingRow = gridSize - 1
end

if(worldTerrainWidth > 640) then
	startingCol = 3
	startingRow = 3
	endingCol = gridSize - 2
	endingRow = gridSize - 2
end

if(worldTerrainWidth > 768) then
	startingCol = 5
	startingRow = 5
	endingCol = gridSize - 4
	endingRow = gridSize - 4
end

-- populate the table with squares to choose from for settlements
for col = 1, gridSize do
	for row = 1, gridSize do
		if((col == 1 or col == gridSize) and (row > startingRow and row < endingRow)) then
			if(terrainLayoutResult[col][row].terrainType == n or terrainLayoutResult[col][row].terrainType == b) then
				table.insert(potentialTradeSquares, {col, row})
			end
		elseif((row == 1 or row == gridSize) and (col > startingCol and col < endingCol)) then
			if(terrainLayoutResult[col][row].terrainType == n or terrainLayoutResult[col][row].terrainType == b) then
				table.insert(potentialTradeSquares, {col, row})
			end
		end
	end
end

settlementPositions = PlaceTradeSettlements(potentialTradeSquares, startLocationPositions, 3, meteorLocations, 1.5, 2)

if(#lakeTable < worldPlayerCount) then
	print("ERROR: Missing " ..worldPlayerCount - #lakeTable .." lake crater(s)!")
end

-- place the craters
for index = 1, #meteorLocations do
	local row = meteorLocations[index][1]
	local col = meteorLocations[index][2]
	
	terrainLayoutResult[row][col].terrainType = m
end
	
-- reset player start terrain to ensure all players have proper resources to start
for index = 1, #startLocationPositions do
	row = startLocationPositions[index][1]
	col = startLocationPositions[index][2]
	terrainLayoutResult[row][col].terrainType = playerStartTerrain
end



print("END OF CRATERS LUA SCRIPT")