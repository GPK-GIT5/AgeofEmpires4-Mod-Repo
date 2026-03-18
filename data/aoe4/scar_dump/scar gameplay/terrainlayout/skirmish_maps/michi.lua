-- Copyright 2024 Developed by Relic Entertainment
print("GENERATING MICHI...")

--------------------------------------------------
--TERRAIN TYPES
--------------------------------------------------
-- variables containing terrain types to be used in map
nullTerrain = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

forestTerrain = tt_forest_blocking_michi
stealthTerrain = tt_forest_stealth_michi
plainsTerrain = tt_plains
playerStartTerrain = tt_player_start_plains_michi
settlementTerrain = tt_settlement_hills
sacredSiteTerrain = tt_holy_site


--------------------------------------------------
--TUNABLES
--------------------------------------------------

baseCenterLineVariance = 1 -- when drawing a single line of forest with Random Positions selected this is the number of squares on either side of the centerline the line can be placed

-- playerStartBuffer is a buffer from the edge of the map for placing player starts. 
-- Will not strictly hit this number (some players may be a square closer or further to the edge), but establishes the player start circle radius
-- Larger numbers result in a smaller circle of player starts. Too large a number will not leave room for players to each have their own starting square.
playerStartBuffer = 2 -- default 2, range should be no more/less than 2-4

-- nuetral settlements
centerExclusionPercentage = 0.3 -- percentage of map size that must be exluded from the center of the map
minTradeSeparation = 4 -- minimum distance neutral trade posts must be from one another
minTradePlayerSeparation = 1 -- minimum distance trade posts must be from player starts
minSacredSeparation = 3 -- minimum distance sacred sites must be from one another
minSacredPlayerSeparation = 2  -- minimum distance sacred sites must be from player starts
baseMinTradeForestSeparation = 3 -- minimum distance trade posts must be from forest squares
smallTeamMinTradeForestSeparation = 2 -- minimum distance trade posts must be from forest squares for small teams
smallTeamSize = 1 -- the size of team that uses smallTeamMinTradeForestSeparation

stealthChance = 1.0 -- chance a stealth terrain will be placed. Set to 1 but can be reduced if we want to thin out stealth terrain

--------------------------------------------------
--FUNCTIONS
--------------------------------------------------

--- PLACE PLAYER STARTS
 -- places player positions in a regular circle to facilitate dividing the map between teams. Handles both random and teams together placement.
 -- randomPlacement is the passed in variable to chekc if the player has chosen random placement or teams together
 -- teamTable is the teamMappingTable created below
 -- numPlayers is the total number of players in the match
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
	
	print("World Player Count: " ..worldPlayerCount)
	-- set angleOffset depending on number of players to avoid players starting inside forest wall
	if(randomPlacement == true) then
		if(worldPlayerCount > 0 and worldPlayerCount < 4) then
			angleOffset = 0
		elseif(worldPlayerCount == 4) then
			angleOffset = 45
		elseif(worldPlayerCount == 5) then
			angleOffset = 36
		elseif(worldPlayerCount == 6) then
			angleOffset = 10
		elseif(worldPlayerCount > 6) then
			angleOffset = 22
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
	
end

--- GET PLAYER TEAM
 -- gets the teamID for the team that the passed in player belongs to
 -- teamTable is the team mapping table
 -- playerIndex is the id of the player whose team is being looked for
function GetPlayerTeam(teamTable, playerIndex)
	local noTeamFound = -1
	
	for tIndex = 1, #teamTable do
		currentTeam = teamTable[tIndex].teamID
		
		for pIndex = 1, #teamTable[tIndex].players do
			if(playerIndex == teamTable[tIndex].players[pIndex].playerID) then
				return currentTeam
			end
		end
	end
	
	print("ERROR: No team found for player: " ..playerIndex)
	return noTeamFound -- fallthrough if player id match not found
end

--- GET SMALLEST TEAM SIZE
 -- returns the size of the smallest team
 -- team table is hte team mapping table
function GetSmallestTeamSize(teamTable)
	local smallestTeamSize = 100
	
	for index = 1, #teamTable do
		if(teamTable[index].playerCount < smallestTeamSize) then
			smallestTeamSize = teamTable[index].playerCount
		end
	end
	
	return smallestTeamSize
end

--- GET MANHATTEN DISTANCE
 -- returns the calculated manhatten distance between the passed in coords
function GetManhattenDistance(row1, col1, row2, col2)
	local distance = math.abs(row1 - row2) + math.abs(col1 - col2)
	return distance
end

-- Finds the two furthest squares from two separate tables of squares using manhatten distance
-- squaresTable01 & squaresTable01 must be formatted as table[index][row or col], e.g. the third square in the table would be at table[3][1] (row), table[3][2] (col)
-- distance is calculated to 4 significant figures
function GetFurthestPairOfSquaresManhatten(squaresTable01, squaresTable02)
	local square01 = {}
	local square02 = {}
	
	local furthestDistance = 0
	
	for index01 = 1, #squaresTable01 do
		
		for index02 = 1, #squaresTable02 do
			
			row01 = squaresTable01[index01][1]
			col01 = squaresTable01[index01][2]
			
			row02 = squaresTable02[index02][1]
			col02 = squaresTable02[index02][2]
			
			local distance = GetManhattenDistance(row01, col01, row02, col02)
			
			if(distance > furthestDistance) then
				furthestDistance = distance
				square01 = {row01, col01}
				square02 = {row02, col02}
			end
			
		end
		
	end
	
	return square01, square02
	
end

function GetTwoClosestSquaresManhatten(targetRow, targetCol, playerTeamSquares)
	local square01 = {}
	local square02 = {}
	
	local allSquares = {}
	
	-- assemble all squares into single table
	for index = 1, #playerTeamSquares do
		local currentTeamID = playerTeamSquares[index].teamID
		
		local currentRow = playerTeamSquares[index].startRow
		local currentCol = playerTeamSquares[index].startCol
			
		table.insert(allSquares, {row = currentRow, col = currentCol, teamID = currentTeamID})
	end
	
	-- first pass to find first closest square
	local closestDistance = math.huge
	local closestIndex = nil
	local openSquares = DeepCopy(allSquares)
	
	for index = 1, #openSquares do
		local currentRow = openSquares[index].row
		local currentCol = openSquares[index].col
		local currentID = openSquares[index].teamID
		
		if(currentRow ~= targetRow and currentCol ~= targetCol) then
			local distance = GetManhattenDistance(targetRow, targetCol, currentRow, currentCol)
			
			if(distance < closestDistance) then
				closestIndex = index
				square01 = {currentRow, currentCol, teamID = currentID}
				closestDistance = distance
			end
		end
	end
	
	-- remove the closest square in order to find the next closest square
	table.remove(openSquares, closestIndex)
	
	-- second pass to find next closest square
	closestDistance = math.huge
	
	for index = 1, #openSquares do
		local currentRow = openSquares[index].row
		local currentCol = openSquares[index].col
		local currentID = openSquares[index].teamID
		
		if(currentRow ~= targetRow and currentCol ~= targetCol) then
			local distance = GetManhattenDistance(targetRow, targetCol, currentRow, currentCol)
			
			if(distance < closestDistance) then
				square02 = {currentRow, currentCol, teamID = currentID}
				closestDistance = distance
			end
		end
	end
	
	-- the two closest squares
	return square01, square02
end

function GetTeamEdgeSquares(teamIndex, squaresTable, playerTeamSquares)
	local edge01 = {}
	local edge02 = {}
		
	for index = 1, #squaresTable do
		local row = squaresTable[index][1]
		local col = squaresTable[index][2]
		local square01, square02 = GetTwoClosestSquaresManhatten(row, col, playerTeamSquares)
		
		if(square01.teamID ~= teamIndex or square02.teamID ~= teamIndex) then
			if(#edge01 < 1) then
				edge01 = {row, col}
			elseif(#edge02 < 1) then
				edge02 = {row, col}
			end
		end
	end
	
	return edge01, edge02
end

--- GET CLOSEST UNCONNECTED SQAURE
 -- finds the nearest enemy square that has not yet been connected for purposes of dividing the teams withh forest lines
 -- currentTeam is the team we're checking the connection for
 -- square to connect is the square on hte current team we're trying to connect
 -- squares table is the table of squares to test distance against for possible connection
function GetClosestUnconnectedSquare(currentTeam, squareToConnect, squaresTable)
	print("!!! GET CLOSEST UNCONNECTED SQUARE")
	local closestDistance = 10000
	local closestTeamIndex = 0
	local closestSquareIndex = 0
	local closestSquare = {}
	
	for index = 1, #teamEdges do
		for sIndex = 1, #teamEdges[index].edgeSquares do
			if(currentTeam ~= teamEdges[index].teamID and teamEdges[index].edgeSquares[sIndex].connected == false) then
				local row = teamEdges[index].edgeSquares[sIndex][1]
				local col = teamEdges[index].edgeSquares[sIndex][2]
				local distance = GetDistance(squareToConnect[1], squareToConnect[2], row, col, 4)
				
				if(distance < closestDistance) then
					closestDistance = distance
					closestTeamIndex = index
					closestSquareIndex = sIndex				 
				end			
			end
		end
	end
	
	closestSquare = teamEdges[closestTeamIndex].edgeSquares[closestSquareIndex]
	teamEdges[closestTeamIndex].edgeSquares[closestSquareIndex].connected = true
	
	return closestSquare
	
end

--- GET DIVIDING POINTS
-- finds the square that is inbetween the outer most players of each team in order to divide the map into sections by team
-- teamSquares is the table holding the squares of the outer most players for each team and their connection status
function GetDividingPoints (teamSquares)
	print("!!! GET DIVIDING POINTS")
	local teamDividingPoints = {}
	
	for tIndex = 1, #teamSquares do -- cycle through each team
		for eIndex = 1, #teamSquares[tIndex].edgeSquares do -- cycle through each edge square
			local currentRow = teamSquares[tIndex].edgeSquares[eIndex][1]
			local currentCol = teamSquares[tIndex].edgeSquares[eIndex][2]
			local currentTeam = teamSquares[tIndex].teamID
			
			local closestDistance = 10000
			local closestSquareIndex = 0
			local closestTeamIndex = 0
			
			if(teamSquares[tIndex].edgeSquares[eIndex].connected == false) then				
				for sIndex = 1, #teamSquares do
					for dIndex = 1, #teamSquares[sIndex].edgeSquares do
						if(teamSquares[sIndex].teamID ~= currentTeam and teamSquares[sIndex].edgeSquares[dIndex].connected == false) then
							local row = teamEdges[sIndex].edgeSquares[dIndex][1]
							local col = teamEdges[sIndex].edgeSquares[dIndex][2]
							local distance = GetDistance(currentRow, currentCol, row, col, 4)
							
							if(distance < closestDistance) then
								closestDistance = distance
								closestTeamIndex = sIndex
								closestSquareIndex = dIndex			 
							end	
						end
					end
				end
				
				local closestRow = teamSquares[closestTeamIndex].edgeSquares[closestSquareIndex][1]
				local closestCol = teamSquares[closestTeamIndex].edgeSquares[closestSquareIndex][2]
				
				local rowAvg = Round((currentRow + closestRow) / 2, 0)
				local colAvg = Round((currentCol + closestCol) / 2, 0)
				
				table.insert(teamDividingPoints, {rowAvg, colAvg})
				teamSquares[closestTeamIndex].edgeSquares[closestSquareIndex].connected = true
				teamSquares[tIndex].edgeSquares[eIndex].connected = true
				
			end
		end
		
	end
	
	return teamDividingPoints
	
end

--- EXTRAPOLATE LINE
-- takes a line drawn from the middle square of the map to an outer point and extends it to the map edge
-- mapMid is the mid point of the map
-- outerRow is the row of the outer point of the line
-- outer col is the col of the outer point of the line
-- mapSize is the map grid size
function ExtrapolateLineEnd(mapMid, outerRow, outerCol, mapSize)
	print("!!! EXTRAPOLATE LINE END")
	local finalRow = -1
	local finalCol = -1
	
	if(outerRow == mapMid) then
		if(outerCol < mapMid) then
			finalRow = outerRow
			finalCol = 1
			return finalRow, finalCol
		else
			finalRow = outerRow
			finalCol = mapSize
			return finalRow, finalCol
		end
	elseif(outerCol == mapMid) then
		if(outerRow < mapMid) then
			finalRow = 1
			finalCol = outerCol
			return finalRow, finalCol
		else
			finalRow = mapSize
			finalCol = outerCol
			return finalRow, finalCol
		end
	end
	
	local m = nil
	local b = nil
	
	if(outerRow < mapMid and outerCol < mapMid) then -- top left map quadrant
		if (outerRow <= outerCol) then -- solving for column
			m = (mapMid - outerCol) / (mapMid - outerRow)
			b = mapMid - (m * mapMid)
			
			finalRow = 1	
			finalCol = m * finalRow + b
		else -- solving for row
			m = (mapMid - outerRow) / (mapMid - outerCol)
			b = mapMid - (m * mapMid)
			
			finalCol = 1
			finalRow = m * finalCol + b
		end
	elseif(outerRow < mapMid and outerCol > mapMid) then -- top right map quadrant
		if(outerRow - 1 <= mapSize - outerCol) then  -- solving for column
			m = (mapMid - outerCol) / (mapMid - outerRow)
        	b = mapMid - (m * mapMid)
			
			finalRow = 1
			finalCol =  m * finalRow + b
		else -- solving for row
			m = (mapMid - outerRow) / (mapMid - outerCol)
        	b = mapMid - (m * mapMid)

			finalCol = mapSize
			finalRow = m * finalCol + b
		end		
	elseif(outerRow > mapMid and outerCol > mapMid) then -- bottom right map quadrant
		if(outerRow >= outerCol) then -- solving for column
			m = (mapMid - outerCol) / (mapMid - outerRow)
        	b = mapMid - m * mapMid
			
			finalRow = mapSize
			finalCol = m * finalRow + b
		else -- solving for row
			m = (mapMid - outerRow) / (mapMid - outerCol)
        	b = mapMid - (m * mapMid)
			
			finalCol = mapSize
			finalRow = m * finalCol + b
		end	
	elseif(outerRow > mapMid and outerCol < mapMid) then -- bottom left map quadrant
		if(mapSize - outerRow <= outerCol - 1) then -- solving for column
			m = (mapMid - outerCol) / (mapMid - outerRow)
			b = mapMid - m * mapMid
			
			finalRow = mapSize 
			finalCol = m * finalRow + b
		else -- solving for row
			m = (mapMid - outerRow) / (mapMid - outerCol)
			b = mapMid - (m * mapMid)
			
			finalCol = 1
			finalRow = m * finalCol + b			
		end
	end
	
	-- ensure whole numbers
	finalRow = Round(finalRow, 0)
	finalCol = Round(finalCol, 0)
	
	print("Extrapolation executed.")
	return finalRow, finalCol
	
end

--- PLACE SACRED SITES
-- places sacred sites inside the forest wall, one for each forest line.
-- numSites is the number of sites to place
-- minDistanceSacred is the minimum distance sites must be apart from other sacred sites
-- minDistancePlayer is the minimum distance sites must be apart from player start locations
-- midPoint is the map mid point
-- forestTT is the terrain type of the forest wall
-- playerTT is the player starting terrain type
-- size is the map grid size
function PlaceSacredSites(treeLines, minDistanceSacred, minDistancePlayer, midPoint, playerTT, sacredTT, size)
	print("!!! PLACE SACRED SITES")
	local forestSquares = {}
	local playerSquares = {}
	local sacredSquares = {}
	
	table.insert(sacredSquares, {midPoint, midPoint})
	
	for row = 1, size do
		for col = 1, size do
			if(terrainLayoutResult[row][col].terrainType == playerTT) then
				table.insert(playerSquares, {row, col})
			end
		end
	end
	
	for i = 1, #treeLines do
		forestSquares = DeepCopy(forestLines[i])
		local sitePlaced = false
		while (#forestSquares > 0 and sitePlaced == false) do
			local squareIndex = GetRandomIndex(forestSquares)
			local potentialRow = forestSquares[squareIndex][1]
			local potentialCol = forestSquares[squareIndex][2]
			
			if(#sacredSquares < 1) then
				if(SquaresFarEnoughApartEuclidian(potentialRow, potentialCol, minDistancePlayer, playerSquares, size) == true) then
					table.insert(sacredSquares, {potentialRow, potentialCol})
					terrainLayoutResult[potentialRow][potentialCol].terrainType = sacredTT
					sitePlaced = true
				end
			else
				if(SquaresFarEnoughApartEuclidian(potentialRow, potentialCol, minDistanceSacred, sacredSquares, size) == true
						and SquaresFarEnoughApartEuclidian(potentialRow, potentialCol, minDistancePlayer, playerSquares, size) == true) then
					table.insert(sacredSquares, {potentialRow, potentialCol})
					terrainLayoutResult[potentialRow][potentialCol].terrainType = sacredTT
					sitePlaced = true
				end
			end
			
			table.remove(forestSquares, squareIndex)
		end
	end

	if(#sacredSquares > #treeLines and #treeLines > 2) then
		table.remove(sacredSquares, 1)
	end
	
	return sacredSquares
end

--- INITIALIZE MAP FLAGS
-- creates a table with x, y coordinates all set to false for local functions that require setting flags true or false 
-- to see if a square has been checked. table must conform to map dimensions
function InitializeMapFlags()
	local mapFlags = {}
	
	-- set up the map flags table with all entries set to false (not checked)
	for x = 1, gridHeight do	
		mapFlags[x] = {}
		
		for y = 1, gridWidth do						
			mapFlags[x][y] = false			
		end
		
	end
	
	return mapFlags
	
end

--- GET REGION SQUARES
-- flood fill function to get matching square types connected to the sqaure passed in at startX, startY
-- map grid is the table holding the 1s and 0s representing impasse and open squares respectively
-- startX is the starting row for the square to begin filling from
-- startY is the starting column for the square to begin filling from
-- squareType is the terrain type to check for inclusion in the flood fill
function GetRegionSquares(mapGrid, startX, startY, squareType)
	local squares = {} -- the table holding square coordinates for this region (format squares[n].row and squares[n].col)
	local mapFlags = {} -- used to track if a square has been checked	
	
	mapFlags = InitializeMapFlags() -- sets all the flags to false (have not been checked)
	
	 -- table of squares to be checked
	local queue = {} -- squares will be added and removed as they are checked
	
	-- add the start square to the queue
	table.insert(queue, {startX, startY})
	
	-- set the starting square status to checked
	mapFlags[startX][startY] = true	
	
	while(#queue > 0) do
		-- get the current square from the first in the queue
		local currentSquare = queue[1]
		-- add the first square of the queue to the squares list
		table.insert(squares, queue[1])
		-- remove that square from the queue
		table.remove(queue, 1)
		
		for x = currentSquare[1] - 1, currentSquare[1] + 1 do
			
			for y = currentSquare[2] - 1, currentSquare[2] + 1 do
				
				if(x > 0 and x <= gridSize and y > 0 and y <= gridSize) then					
					if(x == currentSquare[1] or y == currentSquare[2]) then
					
						local currentFlag = mapFlags[x][y]
					
						if(mapFlags[x][y] == false and mapGrid[x][y].terrainType == squareType) then
							
							mapFlags[x][y] = true
							table.insert(queue, 1, {x, y})
					
						end
						
					end					
					
				end
				
			end
			
		end
		
	end

	return squares
		
end

--------------------------------------------------
--MAIN MAP SCRIPT
--------------------------------------------------

-- MAP/GAME SET UP ------------------------------------------------------------------------
terrainLayoutResult = {}    -- set up initial table for coarse map grid. Must be named this

gridHeight, gridWidth, gridSize = SetCoarseGrid() -- set up the map grid using function found in map_setup lua in the library folder
mapMidPoint = math.ceil(gridSize / 2)

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, nullTerrain, terrainLayoutResult) -- set up the layout table using the function found in map_setup in the library folder

-- set up team mapping table here instead of in player setup section to check team composition for forest placement
if(worldPlayerCount > 0) then
	teamMappingTable = CreateTeamMappingTable()
end

forestLines = {}
-- DRAW SINGLE LINE OF TREES BEFORE PLACING PLAYER STARTS IF RANDOM POSITIONS SELECTED
if(randomPositions == true or worldPlayerCount < 1 or #teamMappingTable < 2) then  -- accounting for zero players in case map is generated in tool or if there is only one team
	print("!!! Placing Center Forest Line for Random Or Zero to One Players")
	centerLineVariance = Round(baseCenterLineVariance * 416 / worldTerrainWidth, 0)

	startRowLeft = Round(GetRandomInRange(mapMidPoint - centerLineVariance, mapMidPoint + centerLineVariance), 0)
	startRowRight = Round(GetRandomInRange(mapMidPoint - centerLineVariance, mapMidPoint + centerLineVariance), 0)
	
	-- restrict the position of forest wall in 6 and 3 player matches to avoid players starting inside forest wall
	if(worldPlayerCount == 6 or worldPlayerCount == 3) then
		startRowLeft = mapMidPoint
		startRowRight = mapMidPoint
	end
	
	local line = DrawLineOfTerrainReturn(mapMidPoint, mapMidPoint, startRowLeft, 1, forestTerrain, false, gridSize) -- draw line across the center of map
	table.insert(forestLines, line)
	line = DrawLineOfTerrainReturn(mapMidPoint, mapMidPoint, startRowRight, gridSize, forestTerrain, false, gridSize) -- draw line across the center of map
	table.insert(forestLines, line)
end

-- PLAYER SETUP ---------------------------------------------------------------------------

if(worldPlayerCount > 0) then
	if(randomPositions == true or worldPlayerCount < 1 or #teamMappingTable < 2) then
		PlacePlayerStarts(true, teamMappingTable, worldPlayerCount, gridSize, mapMidPoint, playerStartBuffer, playerStartTerrain, terrainLayoutResult)
	else
		PlacePlayerStarts(false, teamMappingTable, worldPlayerCount, gridSize, mapMidPoint, playerStartBuffer, playerStartTerrain, terrainLayoutResult)
	end
end

startLocationPositions = {} -- inmitialize table to hold start positions

--loop through and record player starts
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
		
		currentData = {}
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			currentData = {row, col, playerID = terrainLayoutResult[row][col].playerIndex}
			table.insert(startLocationPositions, currentData)
		end
		
	end
end

-- set up a table with all the relevant data for every player
playerTeamPositions = {} -- formatted: {startCol = , startRow = , playerID = , teamID = , teamCount = }

-- fill in the table details for each player
if(#startLocationPositions > 0) then
	for index = 1, #startLocationPositions do
		local currentData = {}
		local playerRow = startLocationPositions[index][1]
		local playerCol = startLocationPositions[index][2]
		local playerIndex = startLocationPositions[index].playerID
		local playerTeamID = GetPlayerTeam(teamMappingTable, startLocationPositions[index].playerID + 1) -- add 1 to the player ID to match team mapping table, terrainLayoutResult uses base 0 table index	
		
		local numTeammates = 0
		for tIndex = 1, #teamMappingTable do
			if(playerTeamID == teamMappingTable[tIndex].teamID) then
				numTeammates = teamMappingTable[tIndex].playerCount
			end
		end
		--print("@@@ Team " ..playerTeamID .." Player " ..playerIndex .." at Row " ..playerRow ..", Col " ..playerCol)
		table.insert(playerTeamPositions, {startCol = playerCol, startRow = playerRow, playerID = playerIndex, teamID = playerTeamID, teamCount = numTeammates})
	end
end

-- PLACE FOREST BASED ON TEAMS TOGETHER
-- if teams are placed together then draw lines of forest isolating each team

teamEdges = {} -- table holding the outermost team members' starting positions and connection status

if(randomPositions == false and worldPlayerCount > 0 and #teamMappingTable > 1) then -- dividing lines will have been decided already if randomPositions is true or there are zero players or only one team
	local teammateSquares = {}

	for tIndex = 1, #teamMappingTable do
		local currentTeam = teamMappingTable[tIndex].teamID
		local currentSquares = {}
		
		for pIndex = 1, #playerTeamPositions do
			if(playerTeamPositions[pIndex].teamID == currentTeam) then
				local row = playerTeamPositions[pIndex].startRow
				local col = playerTeamPositions[pIndex].startCol
				table.insert(currentSquares, {row, col})
			end
		end

		table.insert(teammateSquares, {squares = currentSquares, teamID = currentTeam})
	end	

	for index = 1, #teammateSquares do
		if(#teammateSquares[index].squares > 1 and #teammateSquares[index].squares < 6 and worldTerrainWidth > 416)then
			local squares01 = teammateSquares[index].squares
			local squares02 = teammateSquares[index].squares
			local edgeSquare01, edgeSquare02 = GetFurthestPairOfSquaresManhatten(squares01, squares02)
			local edge01 = {edgeSquare01[1], edgeSquare01[2], connected = false}
			local edge02 = {edgeSquare02[1], edgeSquare02[2], connected = false}
			
			table.insert(teamEdges, {edgeSquares = {edge01, edge02}, teamID = teammateSquares[index].teamID})
		elseif(#teammateSquares[index].squares >= 6) then
			local edgeSquare01, edgeSquare02 = GetTeamEdgeSquares(teammateSquares[index].teamID, teammateSquares[index].squares, playerTeamPositions)
			local edge01 = {edgeSquare01[1], edgeSquare01[2], connected = false}
			local edge02 = {edgeSquare02[1], edgeSquare02[2], connected = false}
			table.insert(teamEdges, {edgeSquares = {edge01, edge02}, teamID = teammateSquares[index].teamID})
		else
			local edge01 = {teammateSquares[index].squares[1][1] + 1, teammateSquares[index].squares[1][2] - 1, connected = false}
			local edge02 = {teammateSquares[index].squares[1][1] - 1, teammateSquares[index].squares[1][2] + 1, connected = false}
			
			table.insert(teamEdges, {edgeSquares = {edge01, edge02}, teamID = teammateSquares[index].teamID})
		end
	end
	
	
	
	local dividingPoints = {} -- table to hold the halfway points between opposing team starts using team edges squares.
	
	if(#startLocationPositions < 3 and #startLocationPositions > 0) then -- make sure the forest line is straight in one or two player games	
		local dividingRow01 = 0
		local dividingCol01 = 0
		local dividingRow02 = 0
		local dividingCol02 = 0
		
		if(#startLocationPositions == 2) then -- calculate dividing points for two players
			if(startLocationPositions[1][2] == startLocationPositions[2][2]) then -- both players are on the same column
				dividingRow01 = mapMidPoint
				dividingCol01 = 1 + playerStartBuffer
				dividingRow02 = mapMidPoint
				dividingCol02 = gridSize - playerStartBuffer
				
			elseif(startLocationPositions[1][1] == startLocationPositions[2][1]) then -- both players are on the same row
				dividingRow01 = 1 + playerStartBuffer
				dividingCol01 = mapMidPoint
				dividingRow02 = gridSize - playerStartBuffer
				dividingCol02 = mapMidPoint
			else
				if(math.abs(mapMidPoint - startLocationPositions[1][1]) < math.abs(mapMidPoint - startLocationPositions[1][2])) then
					dividingRow01 = 1
					dividingCol01 = mapMidPoint
					dividingRow02 = gridSize
					dividingCol02 = mapMidPoint
				else
					dividingRow01 = mapMidPoint
					dividingCol01 = 1
					dividingRow02 = mapMidPoint
					dividingCol02 = gridSize
				end
			end
			
			table.insert(dividingPoints, {dividingRow01, dividingCol01})
			table.insert(dividingPoints, {dividingRow02, dividingCol02})
		else  -- mirror the single player start position, then calculate the dividing points
			local row01 = startLocationPositions[1][1]
			local row02 = gridHeight - row01 + 1
			local col01 = startLocationPositions[1][2]
			local col02 = gridWidth - col01 + 1
			
			if(startLocationPositions[1][2] == col02) then -- both players are on the same column
				dividingRow01 = mapMidPoint
				dividingCol01 = 1 + playerStartBuffer
				dividingRow02 = mapMidPoint
				dividingCol02 = gridSize - playerStartBuffer
				
			elseif(startLocationPositions[1][1] == row02) then -- both players are on the same row
				dividingRow01 = 1 + playerStartBuffer
				dividingCol01 = mapMidPoint
				dividingRow02 = gridSize - playerStartBuffer
				dividingCol02 = mapMidPoint
			else
				dividingRow01 = row01
				dividingCol01 = col02
				dividingRow02 = row02
				dividingCol02 = col01
			end
			
			table.insert(dividingPoints, {dividingRow01, dividingCol01})
			table.insert(dividingPoints, {dividingRow02, dividingCol02})						
		end
	else -- set the dividing points to divide up the map like a pizza for games with more than 2 players		
		dividingPoints = GetDividingPoints(teamEdges)
	end
	
	-- place lines of trees between opposing teams
	for index = 1, #dividingPoints do
		local startRow = dividingPoints[index][1]
		local startCol = dividingPoints[index][2]
		--local treeLine = DrawLineOfTerrainReturn(startRow, startCol, mapMidPoint, mapMidPoint, forestTerrain, false, gridSize) -- draw line from dividing point to center of map
		
		local edgeRow, edgeCol = ExtrapolateLineEnd(mapMidPoint, startRow, startCol, gridSize)
		--local treeLine = DrawLineOfTerrainReturn(startRow, startCol, edgeRow, edgeCol, forestTerrain, false, gridSize) -- draw line to edge of map
		local treeLine = DrawLineOfTerrainReturn(mapMidPoint, mapMidPoint, edgeRow, edgeCol, forestTerrain, false, gridSize) -- draw line to edge of map
		table.insert(forestLines, treeLine)
		
		print("Dividing Point " ..index .." at Row: " ..startRow ..", Col: " ..startCol)
		print("Edge Row: " ..edgeRow ..", Edge Col: " ..edgeCol)
	end
end

-- place sacred site terrain
sacredSites = {}

print("*** Num Forest Lines: "..#forestLines)

sacredSites = PlaceSacredSites(forestLines, minSacredSeparation, minSacredPlayerSeparation, mapMidPoint, playerStartTerrain, sacredSiteTerrain, gridSize)

for index = 1, #sacredSites do
	local row = sacredSites[index][1]
	local col = sacredSites[index][2]
	
	terrainLayoutResult[row][col].terrainType = sacredSiteTerrain
	
	
	local neighbors = GetNeighbors(row, col, terrainLayoutResult)
	
	for nIndex = 1, #neighbors do
		local nRow = neighbors[nIndex].x
		local nCol = neighbors[nIndex].y
		
		if(terrainLayoutResult[nRow][nCol].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[nRow][nCol].terrainType = forestTerrain
		end
	end
end

print("Num Sacred Sites: " ..#sacredSites)
if(#sacredSites < 3) then
	-- place sacred site in middle of map
	terrainLayoutResult[mapMidPoint][mapMidPoint].terrainType = sacredSiteTerrain
	table.insert(sacredSites, {mapMidPoint, mapMidPoint})
end

-- fill in center forest area to ensure it is blocked by trees
terrainLayoutResult[mapMidPoint + 1][mapMidPoint].terrainType = forestTerrain
terrainLayoutResult[mapMidPoint - 1][mapMidPoint].terrainType = forestTerrain
terrainLayoutResult[mapMidPoint][mapMidPoint + 1].terrainType = forestTerrain
terrainLayoutResult[mapMidPoint][mapMidPoint - 1].terrainType = forestTerrain

-- Place stealth terrain next to forest terrain
-- loop through terrain layout squares
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == forestTerrain) then -- find forest terrain
			local neighbors = GetNeighbors(row, col, terrainLayoutResult)
			for nIndex = 1, #neighbors do
				local nRow = neighbors[nIndex].x
				local nCol = neighbors[nIndex].y
				
				if(terrainLayoutResult[nRow][nCol].terrainType == nullTerrain) then -- check only the blank squares
					if(worldGetRandom() <= stealthChance) then 
						terrainLayoutResult[nRow][nCol].terrainType = stealthTerrain -- place stealth terrain
					end
				end
			end
		end
	end
end

local tradeSquares = {} -- table to store placed trade posts
local exclusionAmount = Round(gridSize * centerExclusionPercentage, 0) -- number of central squares to eliminate from trade placement contention

-- get all forest squares
forestSquares = {}

for row = 1, gridSize do
	for col = 1, gridSize do			
		if(terrainLayoutResult[row][col].terrainType == forestTerrain)	 then
			table.insert(forestSquares, {row, col})
		end
	end
end

-- set forest separation based on team size
smallestTeam = GetSmallestTeamSize(teamMappingTable)
minTradeForestSeparation = baseMinTradeForestSeparation

-- if team is too small use smaller separation distance
if(smallestTeam <= smallTeamSize) then
		minTradeForestSeparation = smallTeamMinTradeForestSeparation
end

-- loop through each team to get the team's centroid position and the region squares in this team's section of the map, then check distances
for index = 1, #teamMappingTable do
	local currentTeamID = teamMappingTable[index].teamID
	local teamMemberLocations = {}	
	
	-- find and store all team member positions
	for pIndex = 1, #playerTeamPositions do
		if(playerTeamPositions[pIndex].teamID == currentTeamID) then
			table.insert(teamMemberLocations, {playerTeamPositions[pIndex].startRow, playerTeamPositions[pIndex].startCol})
		end
	end
	
	-- sum all the rows and columns to calculate the central team position
	local rowSum = 0
	local colSum = 0
	
	for tIndex = 1, #teamMemberLocations do				
		rowSum = rowSum + teamMemberLocations[tIndex][1]
		colSum = colSum + teamMemberLocations[tIndex][2]
	end
	
	-- calculate the centroid of the team member positions
	local centerRow = Round(rowSum / #teamMemberLocations, 0)
	local centerCol = Round(colSum / #teamMemberLocations, 0)
	
	-- get the empty squares in this team's region
	teamRegionSquares = GetRegionSquares(terrainLayoutResult, centerRow, centerCol, nullTerrain)
	
	-- cull squares from the middle of the map
	for index = #teamRegionSquares, 1, -1 do		
		
		local row = teamRegionSquares[index][1]
		local col = teamRegionSquares[index][2]

		if(#teamRegionSquares > 0) then -- ensure there a region squares available to check distance against			
			-- remove squares that are too close to the map center, too close to playters or too close to forest squares
			if((row > exclusionAmount and col > exclusionAmount and row < mapMidPoint + exclusionAmount and col < mapMidPoint + exclusionAmount)) then				
				-- cull squares in center area
				table.remove(teamRegionSquares, index)
			elseif((row > exclusionAmount and col > exclusionAmount and row < gridSize - exclusionAmount and col < gridSize - exclusionAmount)) then				
				-- cull squares in center area
				table.remove(teamRegionSquares, index)			
			elseif(SquaresFarEnoughApart(row, col, minTradePlayerSeparation, startLocationPositions, gridSize) == false) then
				-- cull squares that are too close to playerstarts
				table.remove(teamRegionSquares, index)
			elseif(SquaresFarEnoughApart(row, col, minTradeForestSeparation, forestSquares, gridSize) == false) then
				-- cull squares that are too close to forests			
				table.remove(teamRegionSquares, index)
			elseif(#tradeSquares > 0) then
				-- remove squares that are too close to previously placed trading posts
				if(SquaresFarEnoughApart(row, col, minTradeSeparation, tradeSquares, gridSize) == false) then				
					print("### Too close to trade square.")
					table.remove(teamRegionSquares, index)
				end					
			end
		end	
	end
	
	-- place the trade post in the furthest square for optimal trade
	if(#teamRegionSquares > 0) then
		local tradeRow, tradeCol = GetFurthestSquare(centerRow, centerCol, teamRegionSquares)
		table.insert(tradeSquares, {tradeRow, tradeCol})	
		terrainLayoutResult[tradeRow][tradeCol].terrainType = settlementTerrain
	else
		print("ERROR: No squares to choose from to place trade post!")
	end
	
	for index = 1, #sacredSites do
		local row = sacredSites[index][1]
		local col = sacredSites[index][2]
		terrainLayoutResult[row][col].terrainType = sacredSiteTerrain
	end
	
end


print("END OF MICHI LUA SCRIPT")