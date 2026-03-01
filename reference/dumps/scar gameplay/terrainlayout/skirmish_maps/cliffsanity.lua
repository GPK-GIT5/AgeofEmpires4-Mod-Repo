-- Copyright 2024, Microsoft, Developed by Relic Entertainment

print("GENERATING CLIFFSANITY MAP...")

---------------------------------------------------------------------------------------------------------
-- TERRAIN TYPES 
---------------------------------------------------------------------------------------------------------

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout
rnd = tt_flatland_cliffsanity -- used to draw lines through cliffs to increase chance of unblocked passage

h = tt_hills
m = tt_mountains_small
e = tt_hills_gentle_rolling
b = tt_hills_low_rolling_cliffsanity
d = tt_hills_med_rolling
j = tt_hills_high_rolling_cliffsanity
l = tt_plateau_low_fine_grid
g = tt_plateau_med
k = tt_plateau_high
i = tt_mountains
ii = tt_impasse_mountains

playerStartTerrain = tt_player_start_classic_plains_cliffsanity
settlementTerrain = tt_settlement_plains
sacredTerrain = tt_holy_site

---------------------------------------------------------------------------------------------------------
-- TUNABLES 
---------------------------------------------------------------------------------------------------------

baseGridScale = 8 -- grid square scale used for final layout

randomFillPercent = 52 -- percentage of the map that will be "wall" (1). Wall is impasse terrain.
playerStartBufferSquares = {[416] = 5, [512] = 5, [640] = 4, [768] = 4, [896] = 3} -- the number of squares to reserve around player starts so the players have space to build based on map size
settlementBufferSquares = {[416] = 4, [512] = 4, [640] = 3, [768] = 3, [896] = 2} -- the number of squares to reserve around settlements based on map size
sacredBufferSquares = {[416] = 3, [512] = 3, [640] = 2, [768] = 2, [896] = 2} -- the number of squares to reserve around settlements based on map size
borderBuffer = 2 -- the number of squares around the edge of the map that are cleared for traversability
smoothingPasses = 3 -- number of times to smooth the map
baseMinimumCliffSize = 500 -- the minimum size (in grid sqaures) of a cliffs in order to connect to their tops
minimumOpenPercent = 49 -- below this percentage of open space, clifftops can be connected
minimumOpenPercent_416 = 75 -- below this percentage of open space, clifftops can be connected
minimumOpenPercent_512 = 75 -- below this percentage of open space, clifftops can be connected

---------------------------------------------------------------------------------------------------------
-- FUNCTIONS 
---------------------------------------------------------------------------------------------------------

--- FAST REMOVE
 -- Only works on tables with numerical indices and where order is ambiguous
local function FastRemove(table, index)
    table[index] = table[#table]
    table[#table] = nil
end

--- RANDOM FILL MAP
-- randomly sets each coarse grid square to 1 based on fill percent where 1 = impasse
function RandomFillMap(width, height, fillPercent)
	local map = {}
	for col = 1, width do
		map[col] = {}
		for row = 1, height do
			if worldGetRandom() * 100 < fillPercent then
				map[col][row] = 1
			else
				map[col][row] = 0
			end
		end
	end
	
	return map
	
end

function RandomFillMapOptimal(width, height, fillPercent)
	local numSquares = Round((fillPercent / 100) * (width * height))
	local map = {}
	local openSquares = {}
	local squaresIndex = 1
	for col = 1, width do
		map[col] = {}
		for row = 1, height do			
			map[col][row] = 0
			openSquares[squaresIndex] = {col, row}
			squaresIndex = squaresIndex + 1
		end
	end

	for index = 1, numSquares do
		local sIndex = GetRandomIndex(openSquares)
		local col = openSquares[sIndex][1]
		local row = openSquares[sIndex][2]
		map[col][row] = 1
		FastRemove(openSquares, sIndex)
	end
	
	return map
end

--- MAKE PLAYER SPACE
-- creates empty space in the map located around player starts to ensure enough room for players
-- map is the table holding "wall" (1) vs. "floor" (0) values
-- startsTable is the table holding player start locations generated below
-- startBuffer is the number of squares to reserve around the player start
function MakePlayerSpace(map, startsTable, startBuffer)
	local newMap = DeepCopy(map)
	
	for index = 1, #startsTable do
		startCol = startsTable[index][1]
		startRow = startsTable[index][2]
		
		for col = startCol - startBuffer, startCol + startBuffer do
			for row = startRow - startBuffer, startRow + startBuffer do
				if col > 0 and col <= #map and row > 0 and row <= #map[index] then					
					newMap[col][row] = 0
				end
			end
		end
	end
	
	return newMap
	
end

--- GET SURROUNDING WALL COUNT
-- gets the squares surrounding the target squares and calculates the wall count (wall squares have a value of 1) in the gridMap
function GetSurroundingWallCount(map, gridCol, gridRow)
	local wallCount = 0
	
	for col = gridCol - 1, gridCol + 1 do		
		for row = gridRow - 1, gridRow +1 do
			if gridCol ~= col or gridRow ~= row then
				if col - 1 > 0 and col + 1 <= #map  and row - 1 > 0  and row + 1 < #map[col] then	
					if map[col][row] == 1 then wallCount = wallCount + 1 end
				else
					if worldGetRandom() <= 0.5 then wallCount = wallCount + 1 end
				end
			end
		end
	end
	
	return wallCount
end

--- SMOOTH MAP
-- smooths the random noise to make contiguous shapes of impasse and open space 
function SmoothMap(map)
	
	for col = 1, #map do		
		for row = 1, #map[col] do
			local neighborWallGrids = 0
			
			neighborWallGrids = GetSurroundingWallCount(map, col, row)
			
			if neighborWallGrids > 4 then
				map[col][row] = 1
			elseif neighborWallGrids < 4 then
				map[col][row] = 0
			end
			
		end
	end
	
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
function GetRegionSquares(mapGrid, startX, startY)
	local insert = table.insert
	local squares = {} -- the table holding square coordinates for this region (format squares[n].row and squares[n].col)
	local mapFlags = {} -- used to track if a square has been checked	
	
	mapFlags = InitializeMapFlags() -- sets all the flags to false (have not been checked)
	
	local squareType = mapGrid[startX][startY] -- holds the square type of the starting square
	
	 -- table of squares to be checked
	local queue = {} -- squares will be added and removed as they are checked
	
	-- add the start square to the queue
	insert(queue, {startX, startY})
	
	-- set the starting square status to checked
	mapFlags[startX][startY] = true	
	
	while(#queue > 0) do
		-- get the current square from the first in the queue
		local currentSquare = queue[1]
		-- add the first square of the queue to the squares list
		insert(squares, queue[1])
		-- remove that square from the queue
		FastRemove(queue, 1)
		
		for x = currentSquare[1] - 1, currentSquare[1] + 1 do
			
			for y = currentSquare[2] - 1, currentSquare[2] + 1 do
				
				if(x > 0 and x <= gridSize and y > 0 and y <= gridSize) then					
					if(x == currentSquare[1] or y == currentSquare[2]) then
					
						local currentFlag = mapFlags[x][y]
						local currentType = mapGrid[x][y]
					
						if(mapFlags[x][y] == false and mapGrid[x][y] == squareType) then
							
							mapFlags[x][y] = true
							insert(queue, 1, {x, y})
					
						end
						
					end					
					
				end
				
			end
			
		end
		
	end

	return squares
		
end

--- GET REGIONS
-- return a table holding tables of squares for each region (squares of the same type that are connected)
function GetRegions(mapGrid, squareType)
	local insert = table.insert
	local regions = {} -- a table to hold tables containing the squares of the region
	local mapFlags = {} -- used to track if a square has been checked
	mapFlags = InitializeMapFlags()
	
	for x = 1, gridHeight do
		
		for y = 1, gridWidth do
			local currentMapFlag = mapFlags[x][y]
			local currentTileType = mapGrid[x][y]
			
			if(currentMapFlag == false and currentTileType == squareType) then
				local newRegion = {} -- table for the region squares		
				newRegion = GetRegionSquares(mapGrid, x, y) -- add the region squares to the table
				insert(regions, newRegion) -- insert this region into the regions table				
				
				for i = 1, #newRegion do
					-- set the flag for each region square to true, indicating it has been checked
					mapFlags[newRegion[i][1]][newRegion[i][2]] = true			
				end	
				
			end						
			
		end		
		
	end
	
	return regions
		
end

--- GENERATE ROOMS
-- generates a complex table holding the data needed to connect map regions that are isolated
-- formats the table as so:
	-- roomSquares: a list of squares formatted to roomSquares[n][1] for col and roomSquares[n][2] for row
	-- connectedRooms: a table containing the roomIDs of the connected rooms
	-- roomID: an int representing the unique identifier of the room
	-- isConnected: a bool noting whether the room has been connected to another room
	-- isMainRoom: a bool indicating if this is the "main" (largest) room from which we test if all other rooms can reach it
	-- isAccessibleFromMainRoom: a bool indicating if this room can reach the main room to avoid cennected rooms that are isolated from the map and thus inaccessible to players
function GenerateRooms(regionSquares)
	--local insert = table.insert
	local roomTable = {}
	for i = 1, #regionSquares do
		roomTable[i] = { roomSquares = regionSquares[i], connectedRooms = {}, roomID = i, roomSize = #regionSquares[i], isConnected = false, isMainRoom = false, isAccessibleFromMainRoom = false}
	end	
	
	return roomTable
	
end

--- GET LARGEST ROOM
-- returns the index of the largest room in the rooms table
function GetLargestRoom(roomsTable)
	local largestRoomIndex = 0
	local mostSquares = 0
	
	for index = 1, #roomsTable do
		if (roomsTable[index].roomSize > mostSquares) then
			largestRoomIndex = index
			mostSquares = roomsTable[index].roomSize
		end
	end
	
	return largestRoomIndex
	
end

--- SET MAIN ROOM
-- sets the largest room in the rooms table to be the "main" room. Main room is used to test that all rooms are accessible to the players.
function SetMainRoom(roomsTable)
	largestRoomIndex = GetLargestRoom(roomsTable)
	roomsTable[largestRoomIndex].isMainRoom = true
	roomsTable[largestRoomIndex].isAccessibleFromMainRoom = true
end

--- SET ACCESSIBLE FROM MAIN ROOM
-- checks accessiblity to main room and sets rooms that are to accessible
function SetAccessibleFromMainRoom(room)
	if(room.isAccessibleFromMainRoom == false) then --check if accessible bool is set
		room.isAccessibleFromMainRoom = true -- set the bool
		for i = 1, #room.connectedRooms do
			SetAccessibleFromMainRoom(room.connectedRooms[i]) --set the bool for all connected rooms
		end
	end
end

--- CONNECT ROOMS
-- adds the room id of each room to each other to indicate they are connected
function ConnectRooms(roomA, roomB)
	local insert = table.insert
	local aIndex = 1
	local bIndex = 1
	
	-- check for accessibility to main room 
	if (roomA.isAccessibleFromMainRoom == true) then
		SetAccessibleFromMainRoom(roomB)
	elseif(roomB.isAccessibleFromMainRoom == true) then
		SetAccessibleFromMainRoom(roomA)
	end
	
	insert(roomA.connectedRooms, roomB.roomID)
	roomA.isConnected = true	
	insert(roomB.connectedRooms, roomA.roomID)	
	roomB.isConnected = true
	
end

--- IS CONNECTED
-- checks to see if two rooms are connected and returns the connected state
function IsConnected(roomA, roomB)
	
	local connected = false
	
	if(tableContainsAny( roomA.connectedRooms, roomB.roomID ) and tableContainsAny( roomB.connectedRooms, roomA.roomID )) then
		connected = true
	end
	
	return connected
	
end

--- CONNECT CLOSEST ROOMS
-- finds pairs of rooms that are closest to one another and connects them
function ConnectClosestRooms(allRoomsTable, terrainType, gridSize, forceAccessibilityFromMainRoom)
	local insert = table.insert
	local roomTableA = {}
	local roomTableB = {}
	
	if(forceAccessibilityFromMainRoom == true) then
		for r = 1, #allRoomsTable do
			if(allRoomsTable[r].isAccessibleFromMainRoom == true) then				
				insert(roomTableB, allRoomsTable[r])
			else
				insert(roomTableA, allRoomsTable[r])
			end
		end
	else
		roomTableA = DeepCopy(allRoomsTable)
		roomTableB = DeepCopy(allRoomsTable)
	end
	
	-- check!
	
	local shortestDistance = 1000000
	local bestRoomA
	local bestRoomB
	local bestSquareA
	local bestSquareB
	local possibleConnectionFound = false
	
	
	for roomsA = 1, #roomTableA do
		roomA = roomTableA[roomsA]
		--print("---------- Room A: " ..roomsA)
		--print("---------- CHECKING ROOM ID " ..roomA.roomID)
		shortestDistance = 1000000
		
		if(forceAccessibilityFromMainRoom == false) then
			possibleConnectionFound = false
			if(#roomA.connectedRooms > 0) then
				goto continue
			end
		end		
			
		for roomsB = 1, #roomTableB do				
			roomB = roomTableB[roomsB]
			
			if(roomA.roomID ~= roomB.roomID or IsConnected(roomA,roomB) == false) then
				
				local square1 = {}
				local square2 = {}
				
				square1, square2 = GetClosestPairOfSquares(roomTableA[roomsA].roomSquares, roomTableB[roomsB].roomSquares)
				
				local distanceBetweenRooms = GetDistanceDecimal(square1[1], square1[2], square2[1], square2[2], 4)
				
				--print("RoomID " ..roomTableA[roomsA].roomID .." is " ..distanceBetweenRooms .." distance from RoomID " ..roomTableB[roomsB].roomID)
				
				if(distanceBetweenRooms < shortestDistance) then
					--print("RoomID " ..roomTableA[roomsA].roomID .." is closer to RoomID " ..roomTableB[roomsB].roomID)
					shortestDistance = distanceBetweenRooms
					bestRoomA = roomTableA[roomsA]
					bestRoomB = roomTableB[roomsB]
					bestSquareA = square1
					bestSquareB = square2
					possibleConnectionFound = true
					
				end
				
			end								
			
		end

		-- connect the rooms if they were found			
		if(possibleConnectionFound == true and forceAccessibilityFromMainRoom == false) then
			ConnectRooms(bestRoomA, bestRoomB)
			insert(roomConnectionPairs, {bestSquareA, bestSquareB})	
		end		
		::continue::
	end
	
	if(possibleConnectionFound == true and forceAccessibilityFromMainRoom == true) then
		ConnectRooms(bestRoomA, bestRoomB)
		insert(roomConnectionPairs, {bestSquareA, bestSquareB})
		ConnectClosestRooms(allRoomsTable, terrainType, gridSize, true)
	end
	
	if(forceAccessibilityFromMainRoom == false) then
		ConnectClosestRooms(allRoomsTable, terrainType, gridSize, true)	
	end
end

--- SET WALL TERRAIN
-- sets squares in the coarse grid to impasse based on the contents of map (a 2d table with rows and columns)
function SetWallTerrain(map, width, height, terrain)
	
	for col = 1, width do
		for row = 1, height do
			if map[col][row] == 1 then
				terrainLayoutResult[col][row].terrainType = terrain			
			end
		end
	end
	
end

--- DRAW PLAYER PASSAGES
-- draws lines of open terrain between the players to facilitate gameplaY
function DrawPlayerPassages(startSquares, passageTerrain, terrainGrid)
	local ceil = math.ceil
	
	for i = 1, #startLocationPositions do
		for j = i, #startLocationPositions do
			if(i ~= j) then								
				rowP1 = startLocationPositions[i][1]
				colP1 = startLocationPositions[i][2]
				
				rowP2 = startLocationPositions[j][1]
				colP2 = startLocationPositions[j][2]				
				
				-- get a random square near the center of the map
				width = ceil(gridSize / 2)
				buffer = ceil((gridSize - width) / 2)
				startRow = 1 + buffer
				endRow = gridSize - buffer
				startCol = 1 + buffer
				endCol = gridSize - buffer
				
				halfRow, halfCol = GetSquareInBox (startRow, endRow, startCol, endCol, gridSize)
				
				line1 = DrawLineOfTerrainReturn(rowP1, colP1, halfRow, halfCol, passageTerrain, true, gridSize)
				line2 = DrawLineOfTerrainReturn(halfRow, halfCol, rowP2, colP2, passageTerrain, true, gridSize)
				
				-- fatten line 1
				for lineIndex = 1, #line1 do
					x = line1[lineIndex][1]
					y = line1[lineIndex][2]
					squares = GetNeighbors(x, y, terrainLayoutResult)
					
					for squaresIndex = 1, #squares do
						terrainLayoutResult[squares[squaresIndex].x][squares[squaresIndex].y].terrainType = passageTerrain
					end
					
				end
				
				-- fatten line 2
				for lineIndex = 1, #line2 do
					x = line2[lineIndex][1]
					y = line2[lineIndex][2]
					squares = GetNeighbors(x, y, terrainLayoutResult)
					
					for squaresIndex = 1, #squares do
						terrainLayoutResult[squares[squaresIndex].x][squares[squaresIndex].y].terrainType = passageTerrain
					end
					
				end
			end		
		end
	end
end

--- GET PLAYER TEAM
 -- gets the teamID for the team that the passed in player belongs to
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

--- GET CLOSEST TEAMMATE
 -- finds the closest teamate to connect to to ensure teamates are not cut off from one another. Will skip teammates that are already flagged as connected.
function GetClosestTeammate(player, playerTeam, playerCol, playerRow, playerStartsTable, connectedTeammates)
	local closestDistance = 100000
	local closestCol = 0
	local closestRow = 0
	local closestTeammate = -1

	for index = 1, #playerStartsTable do
		-- make sure we're not connecting the current player to themselves
		if(player ~= playerStartsTable[index].playerID) then
			-- check that the player in the list is on the same team
			if(playerTeam == playerStartsTable[index].teamID) then
				-- check and see if the player in the list is already connected and proceed if not
				if(tableContainsAny(connectedTeammates, playerStartsTable[index].playerID) == false) then
					local distance = GetDistance(playerCol, playerRow, playerStartsTable[index].startCol, playerStartsTable[index].startRow, 4)
					if (distance < closestDistance) then
						closestDistance = distance
						closestCol = playerStartsTable[index].startCol
						closestRow = playerStartsTable[index].startRow
						closestTeammate =  playerStartsTable[index].playerID
					end
				end
			end
		end
	end
	
	return closestTeammate, closestCol, closestRow
	
end

--- FATTEN LINE
 -- makes a single corase grid square wide about 3 squares wide
function FattenLine(lineSquares, lineTerrain)
	
	for lineIndex = 1, #lineSquares do
		x = lineSquares[lineIndex][1]
		y = lineSquares[lineIndex][2]
		gridMap[x][y] = 0
		local squares = GetNeighbors(x, y, terrainLayoutResult)
		
		for squaresIndex = 1, #squares do
			terrainLayoutResult[squares[squaresIndex].x][squares[squaresIndex].y].terrainType = lineTerrain
			gridMap[squares[squaresIndex].x][squares[squaresIndex].y] = 0
		end
		
	end
end

--- CONNECT TEAMMATES
 -- draws lines of clear terrain between teammates to ensure no player is cut off from their team by impasse
function ConnectTeammates(playerStartsTable)
	local insert = table.insert
	local teamConnections = {}
	
	for index = 1, #playerStartsTable do
		currentPlayer = playerStartsTable[index].playerID
		
		-- check to see if the player has teammates and proceed to connect if true
		if(playerStartsTable[index].teamCount > 1) then
			-- check to see if the current player is already connected to a teammate proceed to connect if not
			if(tableContainsAny(teamConnections, currentPlayer) == false) then				 
				teammate, teamCol, teamRow = GetClosestTeammate(currentPlayer, playerStartsTable[index].teamID, playerStartsTable[index].startCol, playerStartsTable[index].startRow, playerStartsTable, teamConnections)
				-- ensure we found a teammate to connect to (there chould be one less connecting line than the number of teammates)
				if (teammate >= 0) then
					local connectingLine = DrawLineOfTerrainNoDiagonalReturn(playerStartsTable[index].startCol, playerStartsTable[index].startRow, teamCol, teamRow, true, rnd, gridSize, terrainLayoutResult)
					
					-- fatten line
					FattenLine(connectingLine, rnd)
					insert(teamConnections, currentPlayer) -- add the connected player to the connected table
				end
			end			
		end
	end
end

--- CONNECT ENEMY TEAMS
 -- makes sure there is an easy line of passage to enemy teams
function ConnectEnemyTeams(playerStartsTable)
	local ceil = math.ceil
	local insert = table.insert
	local numConnections = 0
	
	if(#teamMappingTable > 4) then
		numConnections = 4
	else
		numConnections = #teamMappingTable
	end
	
	local teamStarts = {}
	
	for tIndex = 1, numConnections do
		playerStarts = {}
		local currentTeamID = teamMappingTable[tIndex].teamID
		
		for pIndex = 1, #playerStartsTable do
			if(playerStartsTable[pIndex].teamID == currentTeamID) then
				insert(playerStarts, {playerStartsTable[pIndex].startCol, playerStartsTable[pIndex].startRow})
			end
		end
		
		insert(teamStarts, playerStarts)
	end
	
	for tIndex = 1, #teamStarts do
		local colTotal = 0
		local rowTotal = 0
		
		for pIndex = 1, #teamStarts[tIndex] do
			colTotal = colTotal + teamStarts[tIndex][pIndex][1]
			rowTotal = rowTotal + teamStarts[tIndex][pIndex][2]
		end
		
		local connectingCol = Round(colTotal / #teamStarts[tIndex], 0)
		local connectingRow = Round(rowTotal / #teamStarts[tIndex], 0)
		
		centerCol = ceil(gridSize / 2)
		centerRow = ceil(gridSize / 2)
		
		-- connect to center of map
		local connectingLine = DrawLineOfTerrainNoDiagonalReturn(connectingCol, connectingRow, centerCol, centerRow, true, rnd, gridSize, terrainLayoutResult)
		FattenLine(connectingLine, rnd)
		
		-- connect to closest player on the team
		local closestCol, closestRow, closestIndex = GetClosestSquare(connectingCol, connectingRow, teamStarts[tIndex])
		connectingLine = DrawLineOfTerrainNoDiagonalReturn(connectingCol, connectingRow, closestCol, closestRow, true, rnd, gridSize, terrainLayoutResult)
		FattenLine(connectingLine, rnd)
	end
end


--- GET BEST CLIFFTOP
 -- tries to find a clifftop large enough to hold content and close enough to each player to be fair
function GetBestClifftop(minCliffSize, clifftopsTable, playerStartsTable)
	
	local largestRoomSize = clifftopsTable[GetLargestRoom(clifftopsTable)].roomSize
	local closestFurthestDistance = 100000
	local cliffIndex = 0
	
	if(largestRoomSize <= minCliffSize) then
		minCliffSize = largestRoomSize - 500
	end
		
	-- cycle through each clifftop that is => than minCliffSize
	for cIndex = 1, #clifftopsTable do
		--if(clifftopsTable[cIndex].roomSize >= minCliffSize) then
			-- cycle through each player to find the closest clifftop square to each player and note the furthest closest square
			local currentFurthestDistance = 0
			for pIndex = 1, #playerStartsTable do
				
				local pCol = playerStartsTable[pIndex].startCol
				local pRow = playerStartsTable[pIndex].startRow
				
				local closeCol, closeRow, closestIndex = GetClosestSquare(pCol, pRow, clifftopsTable[cIndex].roomSquares)
				local distance = GetDistance(pCol, pRow, closeCol, closeRow, 4)
				
				-- check the distance to see if it is the furthest of all the players
				if(distance > currentFurthestDistance) then
					currentFurthestDistance = distance
				end
			end
			
			-- check to see if the current furthest distance is closer than the other clifftops' furthest distance
			if(currentFurthestDistance < closestFurthestDistance) then
				closestFurthestDistance = currentFurthestDistance
				cliffIndex = cIndex
			end
		--end
	end	
	
	print("Cliff Index: " ..cliffIndex)
	-- return the clifftop with the smallest furthest closest square	
	return cliffIndex
end

function ConnectClifftop(cliffIndex, clifftopsTable, playerStartsTable, cliffTT, connectionTT01, connectionTT02)
	local insert = table.insert
	-- cycle through each player and add a ramp up the cliff on the closest cliff square
	for pIndex = 1, #playerStartsTable do
		local cliffCol, cliffRow, cliffIndex = GetClosestSquare(playerStartsTable[pIndex].startCol, playerStartsTable[pIndex].startRow, clifftopsTable[cliffIndex].roomSquares)
		terrainLayoutResult[cliffCol][cliffRow].terrainType = connectionTT01
		
		local neighbors = GetNeighbors(cliffCol, cliffRow, terrainLayoutResult)
		local rampSquares01 = {}
		
		for nIndex = 1, #neighbors do
			local col = neighbors[nIndex].x
			local row = neighbors[nIndex].y
			--if(terrainLayoutResult[col][row].terrainType ~= cliffTT) then
				terrainLayoutResult[col][row].terrainType = connectionTT01
				insert(rampSquares01, {x = col, y = row}) -- add the ramp squares to the table
			--end
		end

		-- cycle through the ramp squares and place the next set of ramp squares
		for rIndex = 1, #rampSquares01 do
			local nCol = rampSquares01[rIndex].x
			local nRow = rampSquares01[rIndex].y
			local rampNeighbors = GetNeighbors(nCol, nRow, terrainLayoutResult)

			for rnIndex = 1, #rampNeighbors do
				local rCol = rampNeighbors[rnIndex].x
				local rRow = rampNeighbors[rnIndex].y
				if(terrainLayoutResult[rCol][rRow].terrainType ~= cliffTT) then					
					terrainLayoutResult[rCol][rRow].terrainType = connectionTT02	
				end
			end
		end
	end
end

--- PASSAGE IS NARROW
 -- checks either side of an open terrain square to see if it has impasse on either side (rows and/or columns) and marks it as a clearing in the layout table
 -- impasseTT = the impase terrain to check for next ot the target square
 -- checkCol = the column we're cheking for narrowness
 -- checkRow = the row we're checking for narrowness
function PassageIsNarrow(impasseTT, checkCol, checkRow, mapSize)

	-- check column on low edge
	if(checkCol == 1) then
		if(terrainLayoutResult[checkCol + 1][checkRow].terrainType == impasseTT) then
			return true
		end
	end
	
	-- check column on high edge		
	if(checkCol == mapSize) then
		if(terrainLayoutResult[checkCol - 1][checkRow].terrainType == impasseTT) then
			return true
		end
	end
	
	-- check row on low edge
	if(checkRow == 1) then
		if(terrainLayoutResult[checkCol][checkRow + 1].terrainType == impasseTT) then
			return true
		end
	end
	
	--check row on high edge
	if(checkRow == mapSize) then
		if(terrainLayoutResult[checkCol][checkRow - 1].terrainType == impasseTT) then
			return true
		end
	end
	
	-- check column on either side
	if(checkCol > 1 and checkCol < mapSize and terrainLayoutResult[checkCol + 1][checkRow].terrainType == impasseTT and terrainLayoutResult[checkCol - 1][checkRow].terrainType == impasseTT) then
		return true
	end
	
	-- check row on either side
	if(checkRow > 1 and checkRow < mapSize and terrainLayoutResult[checkCol][checkRow + 1].terrainType == impasseTT and terrainLayoutResult[checkCol][checkRow - 1].terrainType == impasseTT) then
		return true
	end
	
	-- check diagonal
	if(checkCol > 1 and checkCol < mapSize and checkRow > 1 and checkRow < mapSize) then
		if(terrainLayoutResult[checkCol - 1][checkRow - 1].terrainType == impasseTT and terrainLayoutResult[checkCol + 1][checkRow + 1].terrainType == impasseTT) then
			return true
		end
		
		if(terrainLayoutResult[checkCol - 1][checkRow + 1].terrainType == impasseTT and terrainLayoutResult[checkCol + 1][checkRow - 1].terrainType == impasseTT) then
			return true
		end
	end
		
	return false
		
end

--- CLEAR PASSAGES
 -- goes through each terrain square considered open (navigable by units) and checks to see if it is bracketed by impasse
 -- bracketed (narrow) squares have their terrain type replaced with a spawn blocker to prevent trees clogging the passages through cliffs
 -- impasseTT = the impasse terrain type to check for
 -- openTT = the open terrain type to check for bracketing (narrowness)
 -- clearTT is the terrain type that blocks spawns
function ClearPassages(impasseTT, openTT, clearTT, mapSize)
	local numSquaresChecked = 0 
	local numNarrowPassages = 0
	
	for col = 1, #terrainLayoutResult do
		for row = 1, #terrainLayoutResult do
			if(terrainLayoutResult[col][row].terrainType == openTT)then
				numSquaresChecked = numSquaresChecked + 1
				if(PassageIsNarrow(impasseTT, col, row, mapSize) == true) then
					terrainLayoutResult[col][row].terrainType = clearTT
					numNarrowPassages = numNarrowPassages + 1
				end
			end
		end
	end

	print("Number of Squares Checked: " ..numSquaresChecked .." Number of Narrow Passages: " ..numNarrowPassages)	
end

--- PLACE TRADE SETTLEMENTS
-- places a terrain type that spawns nuetral settlements along the edge of the map
-- settlementSquares are the potential locations to choose for placing a settlement
-- startLocations is the table holding the player start positions (formatted {{col, row}, {col, row}, etc.})
-- minPlayerDistance is the minimum distance the settlement must be from players
-- minTradeDistance is the minimum distance settlements must be from one another
-- numSettlements is the number of settlements to place
function PlaceTradeSettlements(settlementSquares, startLocations, minPlayerDistance, minTradeDistance, numSettlements, gridSize)	
	local settlementLocations = {}

	while (#settlementSquares > 0 and #settlementLocations < numSettlements) do		
		local squareIndex = GetRandomIndex(settlementSquares)		
		local sCol = settlementSquares[squareIndex][1]
		local sRow = settlementSquares[squareIndex][2]
		
		--SquaresFarEnoughApart(row, column, minDistance, gridPositions, coarseGridSize)
		if(SquaresFarEnoughApart(sCol, sRow, minPlayerDistance, startLocations, gridSize) == true and #settlementLocations == 0) then
			table.insert(settlementLocations, {sCol, sRow})
		elseif(SquaresFarEnoughApart(sCol, sRow, minPlayerDistance, startLocations, gridSize) == true and SquaresFarEnoughApart(sCol, sRow, minTradeDistance, settlementLocations, gridSize) == true) then
			table.insert(settlementLocations, {sCol, sRow})
		end	
		
		table.remove(settlementSquares, squareIndex)
	end

	return settlementLocations	
end

---------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------
-- MAIN MAP SCRIPT 
---------------------------------------------------------------------------------------------------------

-- MAP GRID SETUP--------------------------------------
terrainLayoutResult = {}    -- set up initial table for coarse map grid. Must be named this.

--TEMP MAP GRID SETUP
-- setting the grid up as if it was an ordinary map griid scale at first in order to get player start locations faster. Will extrapolate positions to finer grid later
tempGridHeight, tempGridWidth, tempGridSize = SetCoarseGrid() -- sets up the coarse grid using the function in the map_setup lua file in the library folder

-- debug output for grid setup
print("TEMPORARY GRID HEIGHT IS " ..tempGridHeight .." TEMPORARY GRID WIDTH IS " ..tempGridWidth .." TEMPORARY GRID SIZE IS " ..tempGridSize)

-- setting up the map grid
terrainLayoutResult = SetUpGrid(tempGridSize, n, terrainLayoutResult)

playerStarts = worldPlayerCount

local insert = table.insert

-- PLAYER STARTS ---------------------------------------

teamMappingTable = {} -- initialize table to hold players and their teams

-- set variables for player start is there is at least one player
if(worldPlayerCount > 0) then -- ensure there is at least one player before setting player starts
	teamMappingTable = CreateTeamMappingTable() -- creates the player data for teams

	--print("Num Teams: " ..#teamMappingTable)

	-- set player start inputs based on map size (see PlacePlayerStartsRing function in map_setup.lua)
	minPlayerDistance = 4.5 -- multiply by 5 since coarse grid squares are five times smaller in this map (change multiplier here if square size changes. More multipliers below.)
	minTeamDistance = math.ceil(tempGridSize * 1.2)
	edgeBuffer = 1 -- * 5
	if(worldTerrainHeight >= 768) then
		edgeBuffer = 2 -- * 5
	end

	if(worldTerrainWidth <= 417) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2 -- * 5
		innerExclusion = 0.45
		cornerThreshold = 1 -- * 5
	elseif(worldTerrainWidth <= 513) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2 -- * 5
		innerExclusion = 0.45
		cornerThreshold = 1 -- * 5
	elseif(worldTerrainWidth <= 641) then
		minTeamDistance = Round((#terrainLayoutResult * 1.2))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2 -- * 5
		innerExclusion = 0.5
		cornerThreshold = 2 -- * 5
	elseif(worldTerrainWidth <= 769) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2 -- * 5
		innerExclusion = 0.5
		cornerThreshold = 2 -- * 5
	else
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2 -- * 5
		innerExclusion = 0.5
		cornerThreshold = 3 -- * 5
	end

	spawnBlockers = {tt_impasse_mountains}

	basicTerrain = {tt_none}

end

tempStartLocationPositions = {}
startingPositions = {} -- formatted so squares far enough apart function works

gridSize = tempGridSize -- temporarily set gridSize to tempGridSize so Place Players function can reference it

local PlacePlayerStartsRing = PlacePlayerStartsRing

-- setup the player starts
if #teamMappingTable > 0 then
	
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, 1, 0.001, playerStartTerrain, tt_plains_smooth, 2, true, terrainLayoutResult)

	--loop through and record player starts
	for col = 1, #terrainLayoutResult do
		for row = 1, #terrainLayoutResult do
			
			currentData = {}
			if(terrainLayoutResult[col][row].terrainType == playerStartTerrain) then
				currentData = {x = col, y = row, pIndex = terrainLayoutResult[col][row].playerIndex}
				insert(tempStartLocationPositions, currentData)
				insert(startingPositions, {col, row})
			end
			
		end
		
	end
	
end

-- place neutral trading posts
potentialTradeSquares = {} -- table to hold terrain squares to choose from for settlements

-- find squares along the edge of the map that do not get too far into the corners
for col = 1, gridSize do
	for row = 1, gridSize do
		if((col == 1 or col == gridSize) and (row > 2 and row <= gridSize - 2)) then
			if(terrainLayoutResult[col][row].terrainType == n or terrainLayoutResult[col][row].terrainType == b) then
				table.insert(potentialTradeSquares, {col, row})
			end
		elseif((row == 1 or row == gridSize) and (col > 2 and col <= gridSize - 2)) then
			if(terrainLayoutResult[col][row].terrainType == n or terrainLayoutResult[col][row].terrainType == b) then
				table.insert(potentialTradeSquares, {col, row})
			end
		end
	end
end

neutralSettlementLocations = {}
neutralSettlementLocations = PlaceTradeSettlements(potentialTradeSquares, startingPositions, 4, tempGridSize - 2, 2, tempGridSize)

--FINAL MAP GRID SETUP ------------------------------------

-- Set grid to finer scale to produce map layout
terrainLayoutResult = {}    -- reset the terrain grid

-- scale the grid size for consistency and performance
finalGridScale = math.floor(baseGridScale / 416 * worldTerrainHeight - (worldTerrainHeight/416)^2 + 1)

if(worldTerrainHeight > 416) then finalGridScale = finalGridScale - 1 end

print("FINAL GRID SCALE = " ..finalGridScale)

gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(finalGridScale) -- sets up the coarse grid using a smaller grid square size for a finer grid
mapMidPoint = math.ceil(gridSize / 2)

-- debug output for grid setup
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

-- convert larger map scale start positions to finer map scale and add them to the terrain layout
startLocationPositions = {}

-- loop through all the start positions convert for the new grid size and map accordingly
for index = 1, #tempStartLocationPositions do
	currentCol = tempStartLocationPositions[index].x
	currentRow = tempStartLocationPositions[index].y	
	
	colModifier = 0
	if(currentCol > tempGridSize * 0.7) then
		colModifier = 0.5
	end
	
	rowModifier = 0
	if(currentCol > tempGridSize * 0.7) then
		rowModifier = 0.5
	end
	
	finalCol = Round((currentCol - colModifier) / tempGridSize * gridSize)
	finalRow = Round((currentRow - rowModifier) / tempGridSize * gridSize)
	terrainLayoutResult[finalCol][finalRow].terrainType = playerStartTerrain
	terrainLayoutResult[finalCol][finalRow].playerIndex = tempStartLocationPositions[index].pIndex
	
	insert(startLocationPositions, {finalCol, finalRow, pIndex = tempStartLocationPositions[index].pIndex + 1})
end

-- loop through the settlement positions and convert for the new grid size and map accordingly
settlementLocationPositions = {}

for index = 1, #neutralSettlementLocations do
	currentCol = neutralSettlementLocations[index][1]
	currentRow = neutralSettlementLocations[index][2]	
	
	colModifier = 0
	if(currentCol > tempGridSize * 0.7) then
		colModifier = 0.5
	end
	
	rowModifier = 0
	if(currentCol > tempGridSize * 0.7) then
		rowModifier = 0.5
	end
	
	finalCol = Round((currentCol - colModifier) / tempGridSize * gridSize)
	finalRow = Round((currentRow - rowModifier) / tempGridSize * gridSize)
	terrainLayoutResult[finalCol][finalRow].terrainType = settlementTerrain
	
	insert(settlementLocationPositions, {finalCol, finalRow})
end


-- MAP LAYOUT SETUP ------------------------------------
gridMap = {} -- the map that will hold "Wall" (1) vs. "Floor" (0) types

-- randomly fill the map with wither a "wall" (1) or a "floor" (0)
gridMap = RandomFillMapOptimal(gridWidth, gridHeight, randomFillPercent)

-- reserve space for the players by setting a chunk of grid squares to "floor" (0)
if #startLocationPositions > 0 then
	gridMap = MakePlayerSpace(gridMap, startLocationPositions, playerStartBufferSquares[worldTerrainWidth])
end

--reserve space for nuetral settlements using the make player space function
if #settlementLocationPositions > 0 then
	gridMap = MakePlayerSpace(gridMap, settlementLocationPositions, playerStartBufferSquares[worldTerrainWidth])
end

sacredLocationPositions = {}


if(worldGetRandom() < 0.5) then
	if(worldGetRandom() < 0.5) then
		sacredLocationPositions = {{mapMidPoint, mapMidPoint}, {mapMidPoint, 6}, {mapMidPoint, gridSize - 6}} -- map left/right
	else
		sacredLocationPositions = {{mapMidPoint, mapMidPoint}, {6, mapMidPoint}, {gridSize - 6, mapMidPoint}} -- map/top bottom
	end
else
	if(worldGetRandom() < 0.5) then
		sacredLocationPositions = {{mapMidPoint, mapMidPoint}, {6, 6}, {gridSize - 6, gridSize - 6}} -- map corners top left/bottom right
	else
		sacredLocationPositions = {{mapMidPoint, mapMidPoint}, {6, gridSize - 6}, {gridSize - 6, 6}} -- map corners bottom left/top right
	end
end

-- reserve space for sacred sites using the make player space function
gridMap = MakePlayerSpace(gridMap, sacredLocationPositions, sacredBufferSquares[worldTerrainWidth])


-- smooth the map so it looks more "cave-like"
for i = 1, smoothingPasses do
	SmoothMap(gridMap)
end

-- get the "floor" regions (area of contiguous terrain that players can traverse)
openRegions = GetRegions(gridMap, 0)

-- get the table of rooms for connection
rooms = GenerateRooms(openRegions)

-- set the "wall" squares to an impasse terrain type
SetWallTerrain(gridMap, gridWidth, gridHeight, l)

-- determine the largest open region and set it as the "main room"
SetMainRoom(rooms)

-- connect the rooms and draw the connections in the terrainLayoutResult
roomConnectionPairs = {}
ConnectClosestRooms(rooms, rnd, gridSize, false)

connectingLines = {} -- table for holding the squares of ther connecting lines
-- determine the squares for the connecting lines
for i = 1, #roomConnectionPairs do
	for j = 1, #roomConnectionPairs[1] do
		local x = roomConnectionPairs[i][j][1]
		local y = roomConnectionPairs[i][j][2]
		--print("Connection " ..i ..": Row " ..x .." Col " ..y)		
	end		
	
	line = DrawLineOfTerrainNoDiagonalReturn(roomConnectionPairs[i][1][1], roomConnectionPairs[i][1][2], roomConnectionPairs[i][2][1], roomConnectionPairs[i][2][2], true, rnd, gridSize, terrainLayoutResult)

	insert(connectingLines, line)
	
end

-- set the terrain of the connecting lines
for i = 1, #connectingLines do
	
	for j = 1, #connectingLines[i] do
		x = connectingLines[i][j][1]
		y = connectingLines[i][j][2]
		squares = GetNeighbors(x, y, terrainLayoutResult)
		
		for k = 1, #squares do
			terrainLayoutResult[squares[k].x][squares[k].y].terrainType = rnd
			gridMap[squares[k].x][squares[k].y] = 0
		end
		
	end
	
end

-- set up a table with all the relevant data for every player
playerTeamPositions = {} -- formatted: {startCol = , startRow = , playerID = , teamID = , teamCount = }

-- fill in the table details for each player
if(#startLocationPositions > 0) then
	for index = 1, #startLocationPositions do
		local currentData = {}
		local playerCol = startLocationPositions[index][1]
		local playerRow = startLocationPositions[index][2]
		local playerIndex = startLocationPositions[index].pIndex
		local playerTeamID = GetPlayerTeam(teamMappingTable, startLocationPositions[index].pIndex)		
		
		local numTeammates = 0
		for tIndex = 1, #teamMappingTable do
			if(playerTeamID == teamMappingTable[tIndex].teamID) then
				numTeammates = teamMappingTable[tIndex].playerCount
			end
		end
		
		insert(playerTeamPositions, {startCol = playerCol, startRow = playerRow, playerID = playerIndex, teamID = playerTeamID, teamCount = numTeammates})
	end
end

-- draw lines of terrain connecting teammates to prevent isolated players.
ConnectTeammates(playerTeamPositions)

-- draw direct passages to connect enemy teams
ConnectEnemyTeams(playerTeamPositions)

-- get the "wall" regions (area of contiguous impasse)
impasseRegions = GetRegions(gridMap, 1)

-- get the table of clifftops for map analysis
clifftops = GenerateRooms(impasseRegions)

print("Number of rooms: " ..#rooms)
print("Number of clifftops: " ..#clifftops)

totalOpenSquares = 0
totalImpasseSquares = 0

for index = 1, #clifftops do
	print("Clifftop " ..clifftops[index].roomID ..", Size: " ..clifftops[index].roomSize)
	totalImpasseSquares = totalImpasseSquares + clifftops[index].roomSize
	
end

for index = 1, #rooms do
	totalOpenSquares = totalOpenSquares + rooms[index].roomSize
end

print("Open Squares: " ..totalOpenSquares ..", Impasse Squares: " ..totalImpasseSquares)
print("Percentage Open: " ..totalOpenSquares / (gridSize * gridSize) * 100)
print("Percentage Cliff: " ..totalImpasseSquares / (gridSize * gridSize) * 100)

-- scale cliff size for map size
minimumCliffSize = baseMinimumCliffSize * 416 / worldTerrainHeight

-- set minOpenPercent based on map size
if(worldTerrainWidth <= 416) then
	minimumOpenPercent = minimumOpenPercent_416
elseif(worldTerrainWidth <= 512) then
	minimumOpenPercent = minimumOpenPercent_512
end

-- grant access to best cliff if cliffs are big enough
if((totalOpenSquares / (gridSize * gridSize) * 100) < minimumOpenPercent or clifftops[GetLargestRoom(clifftops)].roomSize >= minimumCliffSize) then
	print("Connecting clifftops...")
	bestCliffIndex = GetBestClifftop(minimumCliffSize, clifftops, playerTeamPositions)
	ConnectClifftop(bestCliffIndex, clifftops, playerTeamPositions, l, b, b)
end

-- check for narrow passages and mark them to be clear of spawns
ClearPassages(l, n, rnd, gridSize)

-- set the settlement squares to ensure they have not been overwritten
--print("!!! Number of Settlements: " ..#settlementLocationPositions)
if(#settlementLocationPositions > 0) then
	for index = 1, #settlementLocationPositions do
		col = settlementLocationPositions[index][1]
		row = settlementLocationPositions[index][2]
		
		terrainLayoutResult[col][row].terrainType = settlementTerrain
	end
end

-- set the settlement squares to ensure they have not been overwritten
--print("!!! Number of Sacred Sites: " ..#sacredLocationPositions)
if(#sacredLocationPositions > 0) then
	for index = 1, #sacredLocationPositions do
		col = sacredLocationPositions[index][1]
		row = sacredLocationPositions[index][2]
		
		terrainLayoutResult[col][row].terrainType = sacredTerrain
	end
end

-- set the player start squares to player start terrain type
if #startLocationPositions > 0 then
	
	for index = 1, #startLocationPositions do
		col = startLocationPositions[index][1]
		row = startLocationPositions[index][2]
		
		terrainLayoutResult[col][row].terrainType = playerStartTerrain		
	end
end

-- ensure passages on ouside edge of map are wide enough to avoid unwanted unplayable space
for row = 1, gridSize do
	if(terrainLayoutResult[row][gridSize].terrainType ~= l) then
		if(terrainLayoutResult[row][gridSize - 1].terrainType == l) then
			terrainLayoutResult[row][gridSize - 1].terrainType = rnd
		end
	end
	
	if(terrainLayoutResult[row][1].terrainType ~= l) then
		if(terrainLayoutResult[row][2].terrainType == l) then
			terrainLayoutResult[row][2].terrainType = rnd
		end
	end
end

for col = 1, gridSize do
	if(terrainLayoutResult[gridSize][col].terrainType ~= l) then
		if(terrainLayoutResult[gridSize - 1][col].terrainType == l) then
			terrainLayoutResult[gridSize - 1][col].terrainType = rnd
		end
	end
	
	if(terrainLayoutResult[1][col].terrainType ~= l) then
		if(terrainLayoutResult[2][col].terrainType == l) then
			terrainLayoutResult[2][col].terrainType = rnd
		end
	end
end


print("END OF CLIFFSANITY LUA SCRIPT")