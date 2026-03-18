print("GENERATING DUNGEON...")

--------------------------------------------------
--TERRAIN TYPES
--------------------------------------------------

-- variables containing terrain types to be used in map
nullTerrain = tt_none  -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

plainsTerrain = tt_flatland
plainsBlockerTerrain = tt_plains_block_dungeon
mountainTerrain = tt_mountains
cliffTerrain = {[416] = tt_plateau_med_dungeon, [512] = tt_plateau_med_dungeon, [640] = tt_plateau_med_dungeon_640, [768] = tt_plateau_med_dungeon, [896] = tt_plateau_med_dungeon_896}
cliffTerrainHigh = {[416] = tt_plateau_high_dungeon, [512] = tt_plateau_high_dungeon, [640] = tt_plateau_high_dungeon_640, [768] = tt_plateau_high_dungeon, [896] = tt_plateau_high_dungeon_896}
settlementTerrain = tt_settlement_plains
sacredTerrain = tt_holy_site_dungeon

playerStartTerrain = tt_player_start_dungeon -- set this to the appropriate terrain for nomad vs classic mode

goldTerrain = tt_gold_room_dungeon -- places a set of gold deposits
smallGoldTerrain = tt_gold_large_single -- places a single large gold deposit
woodTerrain = tt_wood_room_dungeon
stoneTerrain = tt_stone_room_dungeon

poiRandomTerrain = tt_poi_random_dungeon

testTerrain = tt_settlement_hills -- using this to see if pathfinding works
markerTerrain = tt_hills -- using this to mark start and end region for pathing tests when debugging
centerPositionTerrain = tt_valley -- using this to mark the center of dungeon rooms when debugging

--------------------------------------------------
--TUNABLES
--------------------------------------------------
debugTextOn = false -- set to true to see debug text
drawLeaves = false -- set true for debug terrain layout to show leaf divisions (also set drawRooms to false)
drawRooms = true -- set true for final map (set to false if debugging leaf divisions)
drawLeafConnections = true -- set to true for final map (draws extra connections between regions based on leaf siblings)

gridSquareSize = {[416] = 22, [512] = 24, [640] = 24, [768] = 24, [896] = 24}

minLeafSize = {[416] = 5, [512] = 5, [640] = 6, [768] = 6, [896] = 6} -- smallest size a leaf can be based on size. Do not split a leaf that is equal to or less than this minimum
minRoomSize = {[416] = 4, [512] = 4, [640] = 4, [768] = 5, [896] = 5} -- smallest size a room can be. Do not define a room that is equal to or less than this minimum.
searchBuffer = 2 -- when attempting to create extra passages, extend past min room length by this amount

-- leaf format
	-- leaf = {topRow <int>, bottomRow <int>, topCol <int>, bottomCol <int>, child01 <leaf>, child02 <leaf>, roomSquares = {{row, col}, ...}, level<int>}

numPoi = {[416] = 2, [512] = 2, [640] = 3, [768] = 4, [896] = 4}
poiBufferPlayers = {[416] = 6, [512] = 7, [640] = 7, [768] = 7, [896] = 7}
maxWoodRooms = {[416] = 2, [512] = 2, [640] = 3, [768] = 4, [896] = 4}
maxStoneRooms = {[416] = 2, [512] = 2, [640] = 3, [768] = 4, [896] = 4}

--------------------------------------------------
--FUNCTIONS
--------------------------------------------------

function GetLeafSplitPosition(leafToSplit, isVertical)
	local splitPosition = 0
	local lowValue = 0
	local highValue = 0
	
	if(isVertical == true) then -- get the width of the leaf		
		if(leafToSplit.TopCol == 1) then
			lowValue = leafToSplit.topCol + minLeafSize[worldTerrainWidth]
			highValue = leafToSplit.bottomCol - minLeafSize[worldTerrainWidth] - 1
		elseif(leafToSplit.bottomCol == gridSize) then
			lowValue = leafToSplit.topCol + minLeafSize[worldTerrainWidth] + 1
			highValue = leafToSplit.bottomCol - minLeafSize[worldTerrainWidth]
		else
			lowValue = leafToSplit.topCol + minLeafSize[worldTerrainWidth]
			highValue = leafToSplit.bottomCol - minLeafSize[worldTerrainWidth]
		end
		
		splitPosition = Round(GetRandomInRange(lowValue, highValue), 0)
	else -- get the height of the leaf
		if(leafToSplit.topRow == 1) then
			lowValue = leafToSplit.topRow + minLeafSize[worldTerrainWidth]
			highValue = leafToSplit.bottomRow - minLeafSize[worldTerrainWidth] - 1
		elseif(leafToSplit.bottomRow == gridSize) then
			lowValue = leafToSplit.topRow + minLeafSize[worldTerrainWidth] + 1
			highValue = leafToSplit.bottomRow - minLeafSize[worldTerrainWidth]
		else
			lowValue = leafToSplit.topRow + minLeafSize[worldTerrainWidth]
			highValue = leafToSplit.bottomRow - minLeafSize[worldTerrainWidth]
		end
		
		splitPosition = Round(GetRandomInRange(lowValue, highValue), 0)
	end
	
	return splitPosition
	
end

--- SPLIT LEAF
function SplitLeaf(leaf, leafIndex)
	local leaf01 = {}
	local leaf02 = {}
	
	-- check if leaf is already split
	if(leaf.child01 == nil and leaf.child02 == nil) then
		-- check if leaf is big enough to split
		local height = leaf.bottomRow - leaf.topRow + 1
		local width = leaf.bottomCol - leaf.topCol + 1
		
		--if(height > minLeafSize[worldTerrainWidth] * 2 - 1 or width > minLeafSize[worldTerrainWidth] * 2 - 1) then -- leaf is big enough to split
		if(height > minLeafSize[worldTerrainWidth] * 2 or width > minLeafSize[worldTerrainWidth] * 2) then -- leaf is big enough to split
			-- split leaf
			if(height > width) then -- horizontal split
				local splitRow = GetLeafSplitPosition(leaf, false)
				leaf01 = {topRow = leaf.topRow, bottomRow = splitRow, topCol = leaf.topCol, bottomCol = leaf.bottomCol, child01 = nil, child02 = nil, roomSquares = nil}
				leaf02 = {topRow = splitRow, bottomRow = leaf.bottomRow, topCol = leaf.topCol, bottomCol = leaf.bottomCol, child01 = nil, child02 = nil, roomSquares = nil}
			elseif(width > height)then -- vertical split
				local splitCol = GetLeafSplitPosition(leaf, true)
				leaf01 = {topRow = leaf.topRow, bottomRow = leaf.bottomRow, topCol = leaf.topCol, bottomCol = splitCol, child01 = nil, child02 = nil, roomSquares = nil}
				leaf02 = {topRow = leaf.topRow, bottomRow = leaf.bottomRow, topCol = splitCol, bottomCol = leaf.bottomCol, child01 = nil, child02 = nil, roomSquares = nil}
			elseif(worldGetRandom() > 0.5) then -- horizontal split
				local splitRow = GetLeafSplitPosition(leaf, false)
				leaf01 = {topRow = leaf.topRow, bottomRow = splitRow, topCol = leaf.topCol, bottomCol = leaf.bottomCol, child01 = nil, child02 = nil, roomSquares = nil}
				leaf02 = {topRow = splitRow, bottomRow = leaf.bottomRow, topCol = leaf.topCol, bottomCol = leaf.bottomCol, child01 = nil, child02 = nil, roomSquares = nil}
			else -- vertical split
				local splitCol = GetLeafSplitPosition(leaf, true)
				leaf01 = {topRow = leaf.topRow, bottomRow = leaf.bottomRow, topCol = leaf.topCol, bottomCol = splitCol, child01 = nil, child02 = nil, roomSquares = nil}
				leaf02 = {topRow = leaf.topRow, bottomRow = leaf.bottomRow, topCol = splitCol, bottomCol = leaf.bottomCol, child01 = nil, child02 = nil, roomSquares = nil}
			end
			
			leaf.child01 = leaf01
			leaf.child02 = leaf02
			table.insert(openLeaves, leaf01)
			table.insert(openLeaves, leaf02)
			table.insert(leaves, leaf01)
			table.insert(leaves, leaf02)
		end
	end
	table.remove(openLeaves, leafIndex)
end

--- DEFINE ROOM
function DefineRoom(leaf)
	local currentRoomSquares = {}
	
	local roomTopRow = 0
	local roomBottomRow = 0
	local roomTopCol = 0
	local roomBottomCol = 0
	
	if(leaf.topRow == 1) then
		roomTopRow = leaf.topRow
	else
		roomTopRow = leaf.topRow + 1
	end
	
	if(leaf.bottomRow == gridSize) then
		roomBottomRow = leaf.bottomRow
	else
		roomBottomRow = leaf.bottomRow - 1
	end
	
	if(leaf.topCol == 1) then
		roomTopCol = leaf.topCol
	else
		roomTopCol = leaf.topCol + 1
	end
	
	if(leaf.bottomCol == gridSize) then
		roomBottomCol = leaf.bottomCol
	else
		roomBottomCol = leaf.bottomCol - 1
	end
	
	
	-- potentially shrink room for variety
	if(roomBottomRow - roomTopRow + 1 > minRoomSize[worldTerrainWidth] + 1) then
		if (worldGetRandom() > 0.5) then -- shrink room
			if(roomTopRow == 1) then
				roomBottomRow = roomBottomRow - 1
			elseif(roomBottomRow == gridSize) then
				roomTopRow = roomTopRow + 1
			else
				if(worldGetRandom() > 0.5) then
					roomBottomRow = roomBottomRow - 1
				else
					roomTopRow = roomTopRow + 1
				end
			end
		end
	end
	
	if(roomBottomCol - roomTopCol + 1 > minRoomSize[worldTerrainWidth] + 1) then
		if (worldGetRandom() > 0.75) then -- shrink room
			if(roomTopCol == 1) then
				roomBottomCol = roomBottomCol - 1
			elseif(roomBottomRow == gridSize) then
				roomTopCol = roomTopCol + 1
			else
				if(worldGetRandom() > 0.5) then
					roomBottomCol = roomBottomCol - 1
				else
					roomTopCol = roomTopCol + 1
				end
			end
		end
	end
	
	for currentRow = roomTopRow, roomBottomRow do
		for currentCol = roomTopCol, roomBottomCol do
			local currentSquare = {currentRow, currentCol}
			table.insert(currentRoomSquares, currentSquare)
		end
	end
	
	if(currentRoomSquares == nil) then
		print("ERROR: Room squares are not defined! In DEFINE ROOM")
	end
	
	if (debugText == true) then
		print("!!! Room Top Row: " ..roomTopRow .." Room Bottom Row:" ..roomBottomRow .." Room Top Col: " ..roomTopCol .." Room Bottom Col: " ..roomBottomCol)
		print("!!! Leaf Top Row: " ..leaf.topRow .." Leaf Bottom Row: " ..leaf.bottomRow .." Leaf Top Col: " ..leaf.topCol .." Leaf Bottom Col: " ..leaf.bottomCol)
	end

	return currentRoomSquares
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

--- GENERATE REGION DATA
-- generates a complex table holding the data needed to connect map regions that are isolated
-- formats the table as so:
-- roomSquares: a list of squares formatted to regionSquares[n][1] for col and regionSquares[n][2] for row
-- connectedRegions: a table containing the roomIDs of the connected regionss
-- regionID: an int representing the unique identifier of the region
-- isConnected: a bool noting whether the region has been connected to another region
-- isMainRegion: a bool indicating if this is the "main" (largest) region from which we test if all other regions can reach it
-- isAccessibleFromMainRegion: a bool indicating if this region can reach the main region to avoid connected regions that are isolated from the map and thus inaccessible to players
function GenerateRegionData(regionSquares)
	local regionTable = {}
	local currentID = 1
	for i = 1, #regionSquares do
		local squares = regionSquares[i]
		local topRow = squares[1][1]
		local topCol = squares[1][2]
		
		local bottomRow = squares[#squares][1]
		local bottomCol = squares[#squares][2]
		
		local midRow = math.floor((bottomRow - topRow) / 2) + topRow
		local midCol = math.floor((bottomCol - topCol) / 2) + topCol
		
		local center = {midRow, midCol}
		
		regionTable[i] = { regionSquares = regionSquares[i], connectedRegions = {}, regionID = i, regionCenter = center, regionSize = #regionSquares[i], isConnected = false, isMainRegion = false, isAccessibleFromMainRegion = false, occupied = false}
	end	
	
	return regionTable	
end

--- GET LARGEST REGION
-- returns the index of the largest room in the rooms table
function GetLargestRegion(regionsTable)
	local largestRegionIndex = 0
	local mostSquares = 0
	
	for index = 1, #regionsTable do
		if (regionsTable[index].regionSize > mostSquares) then
			largestRegionIndex = index
			mostSquares = regionsTable[index].regionSize
		end
	end
	
	return largestRegionIndex
	
end

--- SET MAIN REGION
-- sets the largest room in the rooms table to be the "main" room. Main room is used to test that all rooms are accessible to the players.
function SetMainRegion(regionsTable)
	largestRegionIndex = GetLargestRegion(regionsTable)
	regionsTable[largestRegionIndex].isMainRegion = true
	regionsTable[largestRegionIndex].isAccessibleFromMainRegion = true
end

--- SET ACCESSIBLE FROM MAIN REGION
-- checks accessiblity to main room and sets rooms that are to accessible
function SetAccessibleFromMainRegion(region)
	if(region.isAccessibleFromMainRegion == false) then --check if accessible bool is set
		region.isAccessibleFromMainRegion = true -- set the bool
		for i = 1, #region.connectedRegions do
			if(type(region.connectedRegions[i]) == "table") then
				SetAccessibleFromMainRegion(region.connectedRegions[i]) --set the bool for all connected rooms
			end
		end
	end
end

--- CONNECT REGIONS
-- adds the region id of each region to each other to indicate they are connected
function ConnectRegions(regionA, regionB)
	local insert = table.insert
	local aIndex = 1
	local bIndex = 1
	
	-- check for accessibility to main room 
	if (regionA.isAccessibleFromMainRegion == true) then
		SetAccessibleFromMainRegion(regionB)
	elseif(regionB.isAccessibleFromMainRegion == true) then
		SetAccessibleFromMainRegion(regionA)
	end
	
	insert(regionA.connectedRegions, regionB.regionID)
	regionA.isConnected = true	
	insert(regionB.connectedRegions, regionA.regionID)	
	regionB.isConnected = true
	
end

--- IS CONNECTED
-- checks to see if two regions are connected and returns the connected state
function IsConnected(regionA, regionB)
	
	local connected = false
	
	if(tableContainsAny( regionA.connectedRegions, regionB.regionID ) and tableContainsAny( regionB.connectedRegions, regionA.regionID )) then
		connected = true
	end
	
	return connected
	
end

--- CONNECT CLOSEST REGIONS
-- finds pairs of regions that are closest to one another and connects them
function ConnectClosestRegions(allRegionsTable, terrainType, gridSize, forceAccessibilityFromMainRegion, regionConnectionPairs)
	local insert = table.insert
	local regionTableA = {}
	local regionTableB = {}
	
	if(forceAccessibilityFromMainRegion == true) then
		for r = 1, #allRegionsTable do
			if(allRegionsTable[r].isAccessibleFromMainRegion == true) then				
				insert(regionTableB, allRegionsTable[r])
			else
				insert(regionTableA, allRegionsTable[r])
			end
		end
	else
		regionTableA = DeepCopy(allRegionsTable)
		regionTableB = DeepCopy(allRegionsTable)
	end
	
	-- check!
	
	local shortestDistance = 1000000
	local bestRegionA
	local bestRegionB
	local bestSquareA
	local bestSquareB
	local possibleConnectionFound = false
	
	
	for regionsA = 1, #regionTableA do
		local regionA = regionTableA[regionsA]

		shortestDistance = 1000000
		
		if(forceAccessibilityFromMainRegion == false) then
			possibleConnectionFound = false
			if(#regionA.connectedRegions > 0) then
				goto continue
			end
		end		
		
		for regionsB = 1, #regionTableB do				
			local regionB = regionTableB[regionsB]
			
			if(regionA.regionID ~= regionB.regionID or IsConnected(regionA,regionB) == false) then
				
				local square1 = {}
				local square2 = {}
				
				square1, square2 = GetClosestPairOfSquares(regionTableA[regionsA].regionSquares, regionTableB[regionsB].regionSquares)
				
				local distanceBetweenRegions = GetDistanceDecimal(square1[1], square1[2], square2[1], square2[2], 4)
				
				if(distanceBetweenRegions < shortestDistance) then
					shortestDistance = distanceBetweenRegions
					bestRegionA = regionTableA[regionsA]
					bestRegionB = regionTableB[regionsB]
					bestSquareA = square1
					bestSquareB = square2
					possibleConnectionFound = true
					
				end
				
			end								
			
		end

		-- connect the regions if they were found			
		if(possibleConnectionFound == true and forceAccessibilityFromMainRegion == false) then
			ConnectRegions(bestRegionA, bestRegionB)
			insert(regionConnectionPairs, {bestSquareA, bestSquareB})	
		end		
		::continue::
	end
	
	if(possibleConnectionFound == true and forceAccessibilityFromMainRegion == true) then
		ConnectRegions(bestRegionA, bestRegionB)
		insert(regionConnectionPairs, {bestSquareA, bestSquareB})
		ConnectClosestRegions(allRegionsTable, terrainType, gridSize, true, regionConnectionPairs)
	end
	
	if(forceAccessibilityFromMainRegion == false) then
		ConnectClosestRegions(allRegionsTable, terrainType, gridSize, true, regionConnectionPairs)	
	end
end

--- GET REGION BY ID
 -- Returns the region from the table whose id matches the passed in id 
function GetRegionByID(id, regionTable)
	for i = 1, #regionTable do
		if(regionTable[i].regionID == id) then
			return regionTable[i]
		end
	end
	
	print("ERROR: No region matched ID " ..id)
	return nil
end

--- CREATE NODE
 -- creates a node table from a grid square for use in pathfinding
function CreateNode(regionID, regionTable)
	local region = GetRegionByID(regionID, regionTable)
	print("CREATE NODE - region ID: " ..region.regionID)
	local node = {regionID = region.regionID, position = region.regionCenter, connectedRegions = region.connectedRegions, g = math.huge, h = 0, parent = nil}
	return node
end

--- GET LOWEST F NODE INDEX
 -- returns the node in the open node list with the lowest f score for pathfinding
function GetLowestFNodeIndex(nodeList)
	local nodeIndex = nil
	local lowestF = math.huge
	
	for i = 1, #nodeList do
		if(nodeList[i].f < lowestF) then
			lowestF = nodeList[i].f
			nodeIndex = i
		end
	end
	
	if(nodeIndex == nil)then		
		print("ERROR:  No node found")		
	end
			
	return nodeIndex
end

--- NODE TABLE CONTAINS COORDS
 -- returns true if the coordinates ofthe passed in node are in the node table
function NodeTableContainsCoords(nodeTable, node)	
	for i = 1, #nodeTable do
		if(nodeTable[i].position[1] == node.position[1] and nodeTable[i].position[2] == node.position[2]) then
			return true
		end
	end
	
	return false
end

--- GET MANHATTEN DISTANCE
 -- returns the calculated manhatten distance between the passed in coords
function GetManhattenDistance(row1, col1, row2, col2)
	local distance = math.abs(row1 - row2) + math.abs(col1 - col2)
	return distance
end

---CALCULATE TOTAL DISTANCE TILES
 -- works backwards through the passed in nodes parents to generate the path and return its distance 
function CalculateTotalDistanceTiles(endNode)
	--print("CALCULATE TOTAL DISTANCE")
	local totalDistance = 0
	local currentNode = endNode
	
	local count = 50
	
	while(currentNode.parent ~= nil and count > 0) do
		--terrainLayoutResult[currentNode.position[1]][currentNode.position[2]].terrainType = testTerrain
		totalDistance= totalDistance + 1
		currentNode = currentNode.parent
		
		--print("Calculate Count: " ..count)
		count = count - 1		
	end
	
	--terrainLayoutResult[currentNode.position[1]][currentNode.position[2]].terrainType = testTerrain
	return totalDistance
end

--- CREATE NODE TILES
 -- Formats the passed in data into a node returns the resulting table
function CreateNodeTiles(tileRow, tileCol, g)
	local node = {position = {tileRow, tileCol}, g = g, h = 0, parent = nil}
	return node
end

--- GET VALID NEIGHBORS
-- returns the cardinal point neighbors of a grid sqare if they are the correct terrain and inside the grid
function GetValidNeighbors(row, col, validTerrain)
	local neighbors = {}
	
	local neighbor = {row - 1, col}
	if(row - 1 >= 1) then
		if(terrainLayoutResult[neighbor[1]][neighbor[2]].terrainType == validTerrain) then
			table.insert(neighbors, neighbor)
		end
	end
	
	neighbor = {row, col + 1}
	if(col + 1 <= gridSize) then
		if(terrainLayoutResult[neighbor[1]][neighbor[2]].terrainType == validTerrain) then
			table.insert(neighbors, neighbor)
		end
	end
	
	neighbor = {row + 1, col}
	if(row + 1 <= gridSize) then
		if(terrainLayoutResult[neighbor[1]][neighbor[2]].terrainType == validTerrain) then
			table.insert(neighbors, neighbor)
		end
	end
	
	neighbor = {row, col - 1}
	if(col - 1 >= 1) then 
		if(terrainLayoutResult[neighbor[1]][neighbor[2]].terrainType == validTerrain) then
			table.insert(neighbors, neighbor)
		end
	end
	--print("Returning " ..#neighbors .." valid neighbors")
	return neighbors
end

--- GET PATH DISTANCE TILES
 -- calculates the path distance (as a player would path to it) between two regions. This function counts coarse map grid squares and not euclidian distance between nodes. 
 -- start is the starting region's mid poiont coordinates
 -- goal is the destination region's mid poiont coordinates
 -- regionTable is a table containing all regions
function GetPathDistanceTiles(start, goal, regionTable, validTerrain)
	local startNode = CreateNodeTiles(start[1], start[2], 0)
	--terrainLayoutResult[startNode.position[1]][startNode.position[2]].terrainType = centerPositionTerrain
	
	startNode.g = 0
	startNode.h = GetManhattenDistance(start[1], start[2], goal[1], goal[2])
	startNode.f = startNode.g + startNode.h
	
	local openList = {startNode} -- table contains regions to be evaluated for pathing
	local closedList = {} -- rooms already evaluated
	local currentG = 0
	
	local count = 1000
	
	while (#openList > 0 and count > 0) do		
		local currentNodeIndex = GetLowestFNodeIndex(openList)
		local currentNode = openList[currentNodeIndex]
		table.remove(openList, currentNodeIndex)
		table.insert(closedList, currentNode)
		--print("CurrentNode ID: " ..currentNode.regionID)
		--print("!!! Current Row: " ..currentNode.position[1] ..", Current Col: " ..currentNode.position[2] .. ", Goal Row: " ..goal[1] ..", Goal Col: " ..goal[2])
		if (currentNode.position[1] == goal[1] and currentNode.position[2] == goal[2]) then -- we've reached the target region
			-- calculate the path distance and return it
			local totalDistance = CalculateTotalDistanceTiles(currentNode)
			return totalDistance
		end
		
		local neighbors = GetValidNeighbors(currentNode.position[1], currentNode.position[2], validTerrain)
		currentG = currentG + 1
		
		if(neighbors ~= nil) then			
			for i = 1, #neighbors do
				local neighborNode = CreateNodeTiles(neighbors[i][1], neighbors[i][2], currentG)					
				--print("Neighbor Node at Row " ..neighborNode.position[1] ..", Col " ..neighborNode.position[2])
				-- check if the current node we picked that is adjacent to the current node is in the closed list
				if(NodeTableContainsCoords(closedList, neighborNode) == true) then
					-- skip this neighbor as we already scrutinized it
				else -- check this neighbor
					if(NodeTableContainsCoords(openList, neighborNode) == false) then				
						--print("Adding neighbor to open list")
						neighborNode.g = currentG -- calculate the distance between the neighbor node and the start node
						--neighborNode.g = GetManhattenDistance(neighborNode.position[1], neighborNode.position[2], start[1], start[2])
						neighborNode.h = GetManhattenDistance(neighborNode.position[1], neighborNode.position[2], goal[1], goal[2]) -- calculate the distance between the neighbor node and the goal region
						neighborNode.parent = currentNode
						neighborNode.f = neighborNode.g + neighborNode.h
						table.insert(openList, neighborNode)
					elseif(currentG < neighborNode.g) then -- test if the current node worse than than the neighbor node						
						neighborNode.g = currentG
						neighborNode.h = GetManhattenDistance(neighborNode.position[1], neighborNode.position[2], goal[1], goal[2]) -- calculate the distance between the neighbor node and the goal region
						neighborNode.f = neighborNode.g + neighborNode.h
						neighborNode.parent = currentNode
					end								
				end			
			end
		end
		
		--print("$$$ Count: " ..count)
		count = count - 1
	end
	print("ERROR: No valid path found!  Count: " ..count)
	return nil
end

--- GET FURTHEST UNOCCUPIED REGION
 -- uses a combination of a8 pathfinding and euclidian distance to find the furthest unoccupied region from the passed in region
function GetFurthestUnoccupiedRegion(startRegion, regionTable, validTerrain)
	local furthestDistance = 0
	local furthestRegionIndex = nil
	
	for i = 1, #regionTable do
		if(regionTable[i].occupied == false and startRegion.regionID ~= regionTable[i].regionID) then
			local distance = GetPathDistanceTiles(startRegion.regionCenter, regionTable[i].regionCenter, regionTable, validTerrain)
			local euclidianDistance = GetDistance(startRegion.regionCenter[1], startRegion.regionCenter[2], regionTable[i].regionCenter[1], regionTable[i].regionCenter[2], 0)
			if(distance ~= nil) then
				local totalDistance = distance + euclidianDistance
				if(totalDistance > furthestDistance) then
					furthestDistance = totalDistance
					furthestRegionIndex = i					
				end
			end
		end
	end
	
	return furthestRegionIndex
end

--- GET RANDOM UNOCCUPIED REGION
 -- gets a random region that is not currently set to occuppied
function GetRandomUnoccupiedRegionIndex(regionTable, playerLocations)
	local openRegions = DeepCopy(regionTable)
	local regionSelected = false
	local regionIndex = -1
	
	while(regionSelected == false and #openRegions > 0) do
		local randomIndex = GetRandomIndex(openRegions)
		print("Random Index: " ..randomIndex .. ", Occupied = " ..tostring(openRegions[randomIndex].occupied))
		if(openRegions[randomIndex].occupied == false) then
			regionIndex = randomIndex
			regionSelected = true
		end
		
		table.remove(openRegions, randomIndex)
	end
	
	return regionIndex
end

--- GET CLOSEST UNOCCUPIED REGION
 -- uses a* pathfinding to find the unoccupied region that is closest to the passed in region
function GetClosestUnoccupiedRegion(startRegion, regionTable, validTerrain)
	local closestDistance = math.huge
	local closestRoomIndex = nil
	
	for i = 1, #regionTable do
		if(regionTable[i].occupied == false and startRegion.regionID ~= regionTable[i].regionID) then
			local distance = GetPathDistanceTiles(startRegion.regionCenter, regionTable[i].regionCenter, regionTable, validTerrain)
			if(distance ~= nil) then
				if(distance < closestDistance) then
					closestDistance = distance
					closestRoomIndex = i
				end
			end
		end
	end
	
	return closestRoomIndex
end

--- GET UNOCCPIED REGION FURTHEST FROM TEAMS
 -- finds the unoccupied region that is the furthest combined distance from all previously placed teams
function GetUnoccupiedRegionFurthestFromTeams(teamRegionIndexes, regionTable, validTerrain)
	local bestDistance = 0
	local bestRegionIndex = nil
	
	for i = 1, #regionTable do -- check all regions
		local totalDistance = 0
		
		if(regionTable[i].occupied == false) then
			for j = 1, #teamRegionIndexes do -- compare relative to all previously placed teams
				if (i ~= j) then
					local regionIndex = teamRegionIndexes[j]
					local testIndex = i
					print("Num Region Table Entries: " ..#regionTable)
					print("Region Index: " ..regionIndex)
					print("Test Index: " ..testIndex)
					local distance = GetPathDistanceTiles(regionTable[regionIndex].regionCenter, regionTable[i].regionCenter, regionTable, validTerrain)
					local euclidianDistance = GetDistance(regionTable[regionIndex].regionCenter[1], regionTable[regionIndex].regionCenter[2], 
						regionTable[i].regionCenter[1], regionTable[i].regionCenter[2], 0)
					
					if(distance ~= nil) then
						totalDistance = totalDistance + distance + euclidianDistance			
					end
				end
			end
			
			if(totalDistance > bestDistance) then
				bestDistance = totalDistance
				bestRegionIndex = i		
			end
		end
	end
	
	return bestRegionIndex
end

--- GET UNOCCPIED REGION FURTHEST FROM TEAMS
 -- finds the unoccupied region that is the furthest combined distance from all previously placed teams
function GetUnoccupiedRegionFurthestFromPlayers(regionTable, validTerrain)
	local bestDistance = 0
	local bestRegionIndex = nil
	
	for i = 1, #regionTable do -- check all regions
		local totalDistance = 0
		
		if(regionTable[i].occupied == false) then
			for j = 1, #regionTable do -- compare relative to all previously placed teams
				if (i ~= j and regionTable[j].occupied == true) then
					local regionIndex = j
					local testIndex = i
					print("Num Region Table Entries: " ..#regionTable)
					print("Region Index: " ..regionIndex)
					print("Test Index: " ..testIndex)
					local distance = GetPathDistanceTiles(regionTable[regionIndex].regionCenter, regionTable[i].regionCenter, regionTable, validTerrain)
					local euclidianDistance = GetDistance(regionTable[regionIndex].regionCenter[1], regionTable[regionIndex].regionCenter[2], 
						regionTable[i].regionCenter[1], regionTable[i].regionCenter[2], 0)
					
					if(distance ~= nil) then
						totalDistance = totalDistance + distance + euclidianDistance			
					end
				end
			end
			
			if(totalDistance > bestDistance) then
				bestDistance = totalDistance
				bestRegionIndex = i		
			end
		end
	end
	
	if(bestRegionIndex == nil) then 
		print("ERROR: No valid region index found. Returning nil.")
	end
	
	return bestRegionIndex
end

function GetScore(row, col, terrainToCount)
	local score = 0
	local squares = GetNeighbors(row, col, terrainLayoutResult)
	
	for i = 1, #squares do
		local x = squares[i].x
		local y = squares[i].y
		
		for t = 1, #terrainToCount do
			if(terrainLayoutResult[x][y].terrainType == terrainToCount[t]) then
				score = score + 1
				break
			end
		end
	end
	
	return score
end

function GetCenterRegion(regionTable)
	local distance = math.huge
	local regionIndex = nil
	
	for i = 1, #regionTable do
		local row = regionTable[i].regionCenter[1]
		local col = regionTable[i].regionCenter[2]
		
		local currentDistance = GetManhattenDistance(mapMidPoint, mapMidPoint, row, col)
		
		if(currentDistance < distance) then
			regionIndex = i 
			distance = currentDistance
		end
	end
	
	if(regionIndex ~= nil) then
		return regionIndex, regionTable[regionIndex]
	else
		print("ERROR: Failed to find center region")
		return nil, nil
	end
end

function GetCornerRegions(regionTable)
	local cornerRegions = {}
	local distance = math.huge
	local currentDistance = nil
	local currentIndex = nil
	
	for i = 1, #regionTable do
		local row = regionTable[i].regionCenter[1]
		local col = regionTable[i].regionCenter[2]
		
		currentDistance = GetManhattenDistance(1, 1, row, col)
		
		if(currentDistance < distance) then
			currentIndex = i
			distance = currentDistance
		end
	end
	
	table.insert(cornerRegions, {regionIndex = currentIndex, region = regionTable[currentIndex]})
	
	distance = math.huge
	currentDistance = nil
	currentIndex = nil
	
	for i = 1, #regionTable do
		local row = regionTable[i].regionCenter[1]
		local col = regionTable[i].regionCenter[2]
		
		currentDistance = GetManhattenDistance(1, gridSize, row, col)
		
		if(currentDistance < distance) then
			currentIndex = i
			distance = currentDistance
		end
	end
	
	table.insert(cornerRegions, {regionIndex = currentIndex, region = regionTable[currentIndex]})
	
	distance = math.huge
	currentDistance = nil
	currentIndex = nil
	
	for i = 1, #regionTable do
		local row = regionTable[i].regionCenter[1]
		local col = regionTable[i].regionCenter[2]
		
		currentDistance = GetManhattenDistance(gridSize, gridSize, row, col)
		
		if(currentDistance < distance) then
			currentIndex = i
			distance = currentDistance
		end
	end
	
	table.insert(cornerRegions, {regionIndex = currentIndex, region = regionTable[currentIndex]})
	
	distance = math.huge
	currentDistance = nil
	currentIndex = nil
	
	for i = 1, #regionTable do
		local row = regionTable[i].regionCenter[1]
		local col = regionTable[i].regionCenter[2]
		
		currentDistance = GetManhattenDistance(gridSize, 1, row, col)
		
		if(currentDistance < distance) then
			currentIndex = i
			distance = currentDistance
		end
	end
	
	table.insert(cornerRegions, {regionIndex = currentIndex, region = regionTable[currentIndex]})
	
	return cornerRegions
			
end

function GetUnoccupiedRegionsClosestToCorners(placementSquares, regionTable)
	local cornerRegions = {}
	
	local tempRow, tempCol, tempIndex = GetClosestSquare(1, 1, placementSquares)
	local tempRegion = {regionIndex = 100, regionCenter = {tempRow, tempCol}}
	local currentRegionIndex = GetClosestUnoccupiedRegion(tempRegion, regionTable, plainsTerrain)
	table.insert(cornerRegions, regionTable[currentRegionIndex])
	
	tempRow, tempCol, tempIndex = GetClosestSquare(gridSize, gridSize, placementSquares)
	tempRegion = {regionIndex = 100, regionCenter = {tempRow, tempCol}}
	currentRegionIndex = GetClosestUnoccupiedRegion(tempRegion, regionTable, plainsTerrain)
	table.insert(cornerRegions, regionTable[currentRegionIndex])
	
	tempRow, tempCol, tempIndex = GetClosestSquare(1, gridSize, placementSquares)
	tempRegion = {regionIndex = 100, regionCenter = {tempRow, tempCol}}
	currentRegionIndex = GetClosestUnoccupiedRegion(tempRegion, regionTable, plainsTerrain)
	table.insert(cornerRegions, regionTable[currentRegionIndex])
	
	tempRow, tempCol, tempIndex = GetClosestSquare(gridSize, 1, placementSquares)
	tempRegion = {regionIndex = 100, regionCenter = {tempRow, tempCol}}
	currentRegionIndex = GetClosestUnoccupiedRegion(tempRegion, regionTable, plainsTerrain)
	table.insert(cornerRegions, regionTable[currentRegionIndex])
	
	return cornerRegions
			
end

function PlaceSacredSiteFallback(playerLocations, sacredLocations)
	print("--- PLACE SACRED SITE FALLBACK ---")
	local potentialSquares = {}
	local occupiedLocations = {}
	
	-- format player positions to work with distance check functions
	for index = 1, #playerLocations do
		local row = playerLocations[index].row
		local col = playerLocations[index].col
		table.insert(occupiedLocations, {row, col})
	end
	
	for index = 1, #sacredLocations do
		local row = sacredLocations[index][1]
		local col = sacredLocations[index][2]
		table.insert(occupiedLocations, {row, col})
	end
	
	-- get squares available for sacred site
	for row = 1, gridSize do
		for col = 1, gridSize do
			if(terrainLayoutResult[row][col].terrainType == plainsTerrain) then
				table.insert(potentialSquares, {row, col})
			end
		end
	end
	
	local sacredPosition, distance = GetFurthestSquareFromSquares(potentialSquares, occupiedLocations)
	local sacredRow =sacredPosition[1]
	local sacredCol = sacredPosition[2]
	
	print("Sacred Row: " ..sacredRow ..", Sacred Col: " ..sacredCol .. ", Distance: " ..distance)
	terrainLayoutResult[sacredRow][sacredCol].terrainType = sacredTerrain
	
	local neighbors = GetNeighbors(sacredRow, sacredCol, terrainLayoutResult)
	
	for index = 1, #neighbors do
		local row = neighbors[index].x
		local col = neighbors[index].y
		
		if(terrainLayoutResult[row][col].terrainType == cliffTerrain[worldTerrainWidth] or terrainLayoutResult[row][col].terrainType == cliffTerrainHigh[worldTerrainWidth]) then
			terrainLayoutResult[row][col].terrainType = plainsTerrain
		end
	end
	
end
	
--------------------------------------------------
--MAIN MAP SCRIPT
--------------------------------------------------

print("DrawLeaves = " ..tostring(drawLeaves))
print("DrawRooms = " ..tostring(drawRooms))

-- MAP/GAME SET UP ------------------------------------------------------------------------

gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(gridSquareSize[worldTerrainWidth]) -- sets the coarse dimensions using the function found in map_setup lua file in the library folder
mapMidPoint = math.ceil(gridSize / 2)

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid for terrain types and other data using default function found in map_setup lua in library folder
terrainLayoutResult = {} -- the grid for all terrain data (must use this name)
terrainLayoutResult = SetUpGrid(gridSize, nullTerrain, terrainLayoutResult)

firstLeaf = {topRow = 1, bottomRow = gridHeight, topCol = 1, bottomCol = gridWidth, child01 = nil, child02 = nil}

leaves = {}
table.insert(leaves, firstLeaf)
openLeaves = {}
table.insert(openLeaves, firstLeaf)

count = 1 -- failsafe for possible infinite loop

-- divide and add leaves until they are smaller than the minimum required to divide
while(#openLeaves > 0 and count < 100) do
	local currentLeaf = openLeaves[#openLeaves]
	leafIndex = #openLeaves
	SplitLeaf(currentLeaf, leafIndex)
	count = count + 1
end

if(drawLeaves == true) then
	-- debug draw lines of terrain to define leaves (turn off for final map)
	for i = 1, #leaves do
		local topRow = leaves[i].topRow
		local bottomRow = leaves[i].bottomRow
		local topCol = leaves[i].topCol
		local bottomCol = leaves[i].bottomCol
		
		-- top row -> top Col - bottom col
		if(topRow ~= 1) then
			DrawLineOfTerrain(topRow, topCol, topRow, bottomCol, cliffTerrain[worldTerrainWidth], false, gridSize)
		end
		
		if(bottomRow ~= gridSize) then
			DrawLineOfTerrain(bottomRow, topCol, bottomRow, bottomCol, cliffTerrain[worldTerrainWidth], false, gridSize)
		end
		
		if(topCol ~= 1) then
			DrawLineOfTerrain(topRow, topCol, bottomRow, topCol, cliffTerrain[worldTerrainWidth], false, gridSize)
		end
		
		if(bottomCol ~= gridSize) then
			DrawLineOfTerrain(topRow, bottomCol, bottomRow, bottomCol, cliffTerrain[worldTerrainWidth], false, gridSize)
		end		
	end
end


-- debug output
if(debugTextOn == true) then
	for i = 1, #leaves do
		local leaf = leaves[i]
		print("Leaf " ..i ..":")
		print("Top Row: " ..leaf.topRow ..", Bottom Row: " ..leaf.bottomRow ..", Top Col: " ..leaf.topCol ..", Bottom Col: " ..leaf.bottomCol)
	end
	
	print("--- Leaves with Rooms: ")
	for i = 1, #leaves do
		local leaf = leaves[i]
		if(leaf.child01 == nil or leaf.child02 == nil) then
			print("Leaf " ..i ..":")
			print("Top Row: " ..leaf.topRow ..", Bottom Row: " ..leaf.bottomRow ..", Top Col: " ..leaf.topCol ..", Bottom Col: " ..leaf.bottomCol)
		end
	end
	
end


if(drawRooms == true) then
	-- define rooms within leaves. Only put rooms in leaves with no children
	allRooms = {} -- table to hold all room squares for placing players, resources, etc.
	for i = 1, #leaves do
		if(leaves[i].child01 == nil or leaves[i].child02 == nil) then
			if(leaves[i].roomSquares == nil) then
				print("Define Room for Leaf " ..i)
				leaves[i].roomSquares = DefineRoom(leaves[i])
				table.insert(allRooms, leaves[i].roomSquares)
			end
		end	
	end
	
	-- set rooms to traversable terrain
	for i = 1, #leaves do
		if(leaves[i].roomSquares == nil) then
			--print("No rooms!!!")
		else
			for j = 1, #leaves[i].roomSquares do			
				local row = leaves[i].roomSquares[j][1]
				local col = leaves[i].roomSquares[j][2]
				
				if(row >= 1 and row <= gridSize and col >= 1 and col <= gridSize) then
					terrainLayoutResult[row][col].terrainType = plainsTerrain
				end
			end
		end
	end
end

	connectionLines = {} -- table to hold all squares for connection lines
if(drawLeafConnections == true) then
	-- connect leaves with passages
	for i = 1, #leaves do
		local leaf = leaves[i]
		
		if (leaf.child01 ~= nil and leaf.child02 ~= nil) then
			print("Connecting children of leaf " ..i)
			local startRow = math.floor((leaf.child01.bottomRow - leaf.child01.topRow) / 2 + leaf.child01.topRow)
			local startCol = math.floor((leaf.child01.bottomCol - leaf.child01.topCol) / 2 + leaf.child01.topCol)
			local endRow = math.floor((leaf.child02.bottomRow - leaf.child02.topRow) / 2 + leaf.child02.topRow)
			local endCol = math.floor((leaf.child02.bottomCol - leaf.child02.topCol) / 2 + leaf.child02.topCol)
			--print("Draw line from row " ..startRow ..", col " ..startCol .." to row " ..endRow ..", col " ..endCol)
			local line = DrawLineOfTerrainNoDiagonalReturn(startRow, startCol, endRow, endCol, true, plainsTerrain, gridSize, terrainLayoutResult)
			table.insert(connectionLines, line)
		end
	end
end


-- REGION STUFF (connect rooms with passages) ------------------------------------------------------------------------------
if(drawRooms == true) then
	regions = GenerateRegionData(allRooms)

	-- determine the largest open region and set it as the "main region"
	SetMainRegion(regions)

	-- connect the regions and get the connections in the terrainLayoutResult
	regionConnectionPairs = {}
	ConnectClosestRegions(regions, plainsTerrain, gridSize, false, regionConnectionPairs)



	-- determine the squares for the connecting lines
	for i = 1, #regionConnectionPairs do
		for j = 1, #regionConnectionPairs[1] do
			local x = regionConnectionPairs[i][j][1]
			local y = regionConnectionPairs[i][j][2]	
		end		
		
		local line = DrawLineOfTerrainNoDiagonalReturn(regionConnectionPairs[i][1][1], regionConnectionPairs[i][1][2], regionConnectionPairs[i][2][1], regionConnectionPairs[i][2][2], false, plainsTerrain, gridSize, terrainLayoutResult)
		table.insert(connectionLines, line)
	end


	-- set the terrain of the connecting lines as plains for pathfinding
	for i = 1, #connectionLines do
		
		for j = 1, #connectionLines[i] do
			x = connectionLines[i][j][1]
			y = connectionLines[i][j][2]
			if(terrainLayoutResult[x][y].terrainType ~= centerPositionTerrain)then
				terrainLayoutResult[x][y].terrainType = plainsTerrain
			end
		end
	end


	for i = 1, #leaves do
		if(leaves[i].child01 == nil or leaves[i].child02 == nil) then
			if(leaves[i].roomSquares ~= nil and leaves[i].roomSquares ~= nil) then
				local square01, square02 = GetClosestPairOfSquares(leaves[i].roomSquares, leaves[i].roomSquares)
				DrawLineOfTerrainNoDiagonal(square01[1], square01[2], square02[1], square02[2], true, centerPositionTerrain, gridSize, terrainLayoutResult)
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------

-- PLAYER PLACEMENT ----------------------------------------------------------------------------------

teamMappingTable = {} -- initialize table to hold players and their teams
playerStartLocations = {}

if(debugTextOn == true and drawRooms == true) then print("Number of Rooms: " ..#regions .." Number of Players: " ..worldPlayerCount) end

-- debug text for region connections
if(debugTextOn == true and drawRooms == true) then
	for i = 1, #regions do
		print("Region: " ..regions[i].regionID ..", Num Connections: " ..#regions[i].connectedRegions ..", Region Center: Row " ..regions[i].regionCenter[1] ..", Col " ..regions[i].regionCenter[2])
		if(#regions[i].connectedRegions > 0)then
			print("  Connected Regions:")
			for j = 1, #regions[i].connectedRegions do
				print("    Region " ..regions[i].connectedRegions[j])
			end
		else
			print("")
		end
	end
end

validPlacementSquares = {}
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
		if(terrainLayoutResult[row][col].terrainType == plainsTerrain)then
			table.insert(validPlacementSquares, {row, col})
		end
	end
end

cornerRegions = GetUnoccupiedRegionsClosestToCorners(validPlacementSquares, regions)

-- create connections from corner regions to nearby regions to ensure corner placement and avoid teammates in hte center of the map
for i = 1, #cornerRegions do
	local cRow = cornerRegions[i].regionCenter[1]
	local cCol = cornerRegions[i].regionCenter[2]
	local startRow = 0
	local startCol = 0
	local endRow = 0
	local endCol = 0
	local tempLine = {}
	
	if(cRow < mapMidPoint) then
		startRow = cRow	
		endRow = cRow + 7
	else	
		startRow = cRow - 7
		endRow = cRow
	end
	
	if (cCol < mapMidPoint) then
		startCol = cCol
		endCol = cCol + 7
	else
		startCol = cCol - 7
		endCol = cCol
	end
	
	print("CornerRow: " ..cRow ..", CornerCol: " ..cCol)
	print("StartRow: " ..startRow ..", StartCol: " ..startCol)
	print("EndRow: " ..endRow ..", EndCol: " ..endCol)
	
	for row = startRow, endRow do
		if(terrainLayoutResult[row][cCol].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[row][cCol].terrainType = plainsTerrain
			table.insert(tempLine, {row, cCol})
		end
	end
	
	table.insert(connectionLines, tempLine)
	tempLine = {}
	
	for col = startCol, endCol do
		if(terrainLayoutResult[cRow][col].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[cRow][col].terrainType = plainsTerrain
			table.insert(tempLine, {cRow, col})
		end
	end
	
	table.insert(connectionLines, tempLine)
end

firstTeamRegion = GetRandomElement(cornerRegions)
firstTeamRegionIndex = -1

for i = 1, #regions do
	if(regions[i].regionID == firstTeamRegion.regionID) then
		firstTeamRegionIndex = i
	end
end

teamStartRegionIndexes = {} -- table holds the region indexes for each team (the starting region where the first team member was placed)

if (worldPlayerCount > 0) then
	teamMappingTable = CreateTeamMappingTable() -- creates the player data for teams
	
	if(randomPositions == false) then
		print("PLACING PLAYERS - TEAMS TOGETHER -------------------------------------")
		-- place initial starting location for each team
		for i = 1, #teamMappingTable do
			local lastRegionIndex = 1
			if(i == 1) then
				local square = regions[firstTeamRegionIndex].regionCenter
				local row = square[1]
				local col = square[2]
				table.insert(playerStartLocations, {row = row, col = col, playerID = teamMappingTable[i].players[1].playerID - 1})
				regions[firstTeamRegionIndex].occupied = true
				table.insert(teamStartRegionIndexes, firstTeamRegionIndex)
			else
				local regionIndex = GetUnoccupiedRegionFurthestFromTeams(teamStartRegionIndexes, regions, plainsTerrain)
				local square = regions[regionIndex].regionCenter
				table.insert(playerStartLocations, {row = square[1], col = square[2], playerID = teamMappingTable[i].players[1].playerID - 1})		
				regions[regionIndex].occupied = true
				table.insert(teamStartRegionIndexes, regionIndex)
				lastRegionIndex = regionIndex			
			end
		end

		-- place remaining teamates near initial placement
		for i = 1, #teamMappingTable do
			if(#teamMappingTable[i].players > 1) then
				for j = 2, #teamMappingTable[i].players do
					local teamRegionIndex = teamStartRegionIndexes[i]
					local regionIndex = GetClosestUnoccupiedRegion(regions[teamRegionIndex], regions, plainsTerrain)
					local square = regions[regionIndex].regionCenter
					table.insert(playerStartLocations, {row = square[1], col = square[2], playerID = teamMappingTable[i].players[j].playerID - 1})
					terrainLayoutResult[square[1]][square[2]].terrainType = playerStartTerrain
					terrainLayoutResult[square[1]][square[2]].playerIndex = teamMappingTable[i].players[j].playerID - 1			
					regions[regionIndex].occupied = true
				end
			end
		end
	else
		print("PLACING PLAYERS - RANDOM LOCATIONS -------------------------------------")
		local minPlayerDistance = 6
		
		for i = 1, #teamMappingTable do -- cycle through every team
			for j = 1, #teamMappingTable[i].players do -- cycle through each player on the team
				local openRegions = {} -- table to hold regions to select for player placement
				
				if(i == 1 and j == 1) then -- place the first player in the first region as a starting point
					local row = regions[firstTeamRegionIndex].regionCenter[1]
					local col = regions[firstTeamRegionIndex].regionCenter[2]
					table.insert(playerStartLocations, {row = row, col = col, playerID = teamMappingTable[i].players[j].playerID - 1}) -- add the first player to the player start locations table
					table.insert(teamStartRegionIndexes, firstTeamRegionIndex)
					regions[firstTeamRegionIndex].occupied = true
				else -- place remaining players					
					local count = 50 -- failsafe to prevent infinite loops
					local playerPlaced = false -- bool to switch if we've placed a player
					openRegions = DeepCopy(regions) -- copy the regions table for region selection for each player					
					
					while(playerPlaced == false and #openRegions > 0 and count > 0) do -- loop through the regions until a valid region is found (furthest as p[ossible from all players and above minimum distance to all placed players)										
						local potentialRegionIndex = GetUnoccupiedRegionFurthestFromPlayers(openRegions, plainsTerrain) -- get the furthest region's index
						local regionTooCloseToPlayer = false -- set this bool to false before checking if the region is too close to another player
						local potentialRegion = nil -- set up variable to hold potential region

						if(potentialRegionIndex == nil) then -- check if no region was available (we ran out of regions in the open list)
							potentialRegionIndex = GetUnoccupiedRegionFurthestFromPlayers(regions, plainsTerrain) -- select a region from previously rejected regions
							potentialRegion = GetRegionByID(regions[potentialRegionIndex].regionID, regions) -- get the ID of the region from the near region list
							goto placeRegion -- skip distance checking as we have no more regions far enough from other players
						else -- set the potential region knowing we have one									
							potentialRegion = GetRegionByID(openRegions[potentialRegionIndex].regionID, openRegions) -- get the region from the open list to check against main region list
						end
						
						for k = 1, #regions do -- cycle through all the regions					
							print("Comparing region: " ..regions[k].regionID .." to region: " ..potentialRegion.regionID)							
							if(regions[k].occupied == true) then -- measure distance from this occupied region								
								local startRegionCoords = potentialRegion.regionCenter
								local endRegionCoords = regions[k].regionCenter								
								local distance = GetPathDistanceTiles(startRegionCoords, endRegionCoords, regions, plainsTerrain)
								
								if(distance == nil) then
									print("Removing invalid region: " ..potentialRegion.regionID .." at index " ..potentialRegionIndex)
									regionTooCloseToPlayer = true
									table.remove(openRegions, potentialRegionIndex)							
								elseif(distance <= minPlayerDistance) then -- invalid placement as this region is too close to another player
									print("Removing close region: " ..potentialRegion.regionID .." at index " ..potentialRegionIndex)
									regionTooCloseToPlayer = true
									table.remove(openRegions, potentialRegionIndex)
									break
								end	
							end
						end					
												
						:: placeRegion :: -- used to skip near distance check when there ar no more regions to choose that exceed min distance
						
						if(regionTooCloseToPlayer == false) then
							
							for l = 1, #regions do -- cycle through the main regions table to find the open table region we've selected
								if(regions[l].regionID == potentialRegion.regionID) then -- check each region ID to see if it matches the selected one							
									local row = regions[l].regionCenter[1]
									local col = regions[l].regionCenter[2]
									table.insert(playerStartLocations, {row = row, col = col, playerID = teamMappingTable[i].players[j].playerID - 1}) -- add this regions center position and the current player ID to the stat locations table								
									regions[l].occupied = true -- set occupation status
									table.insert(teamStartRegionIndexes, l)
								end
							end

							playerPlaced = true
						end
						
						count = count - 1
						print("Random Placement Count: " ..count ..", Num Open Regions: " ..#openRegions ..", Player Placed: " ..tostring(playerPlaced))
					end
				end			
			end		
		end
	end
end


if(#playerStartLocations < worldPlayerCount) then
	print("We are short " ..worldPlayerCount - #playerStartLocations .." player starts!")
end

print("Num Player Starts: " ..#playerStartLocations)
-- set player terrain type and player id
for i = 1, #playerStartLocations do
	local row = playerStartLocations[i].row
	local col = playerStartLocations[i].col
	terrainLayoutResult[row][col].terrainType = playerStartTerrain
	terrainLayoutResult[row][col].playerIndex = playerStartLocations[i].playerID
end

-------------------------------------------------------------------------------------------------------

if(drawRooms == true)then
	-- fill in blank terrain
	for row = 1, gridSize do
		for col = 1, gridSize do
			if(terrainLayoutResult[row][col].terrainType == nullTerrain) then
				terrainLayoutResult[row][col].terrainType = cliffTerrain[worldTerrainWidth]
			end
		end
	end
	
	-- ensure proper room exits for free for all (or large number of teams)
	if(#teamMappingTable > 4) then
		-- cycle through each player
		for i = 1, #playerStartLocations do
			local row = playerStartLocations[i].row
			local col = playerStartLocations[i].col
			
			local searchLength = minRoomSize[worldTerrainWidth] + searchBuffer
			
			-- search in each cardinal direction for exit passages and create one if missing
			-- search up
			for r = row - searchLength, row do
				if(r > 0 and r <= gridSize) then
					if(terrainLayoutResult[r][col].terrainType == cliffTerrain[worldTerrainWidth] or terrainLayoutResult[r][col].terrainType == cliffTerrainHigh[worldTerrainWidth]) then
						terrainLayoutResult[r][col].terrainType = plainsTerrain
					end
				end
			end
			
			-- search down
			for r = row, row + searchLength do
				if(r > 0 and r <= gridSize) then
					if(terrainLayoutResult[r][col].terrainType == cliffTerrain[worldTerrainWidth] or terrainLayoutResult[r][col].terrainType == cliffTerrainHigh[worldTerrainWidth]) then
						terrainLayoutResult[r][col].terrainType = plainsTerrain
					end
				end
			end
			
			-- search left
			for c = col - searchLength, col do
				if(c > 0 and c <= gridSize) then
					if(terrainLayoutResult[row][c].terrainType == cliffTerrain[worldTerrainWidth] or terrainLayoutResult[row][c].terrainType == cliffTerrainHigh[worldTerrainWidth]) then
						terrainLayoutResult[row][c].terrainType = plainsTerrain
					end
				end
			end
			
			-- search right
			for c = col, col + searchLength do
				if(c > 0 and c <= gridSize) then
					if(terrainLayoutResult[row][c].terrainType == cliffTerrain[worldTerrainWidth] or terrainLayoutResult[row][c].terrainType == cliffTerrainHigh[worldTerrainWidth]) then
						terrainLayoutResult[row][c].terrainType = plainsTerrain
					end
				end
			end
		end
		
	end
	
	-- set isolated cliffs to high cliffs
	for row = 1, gridSize do
		for col = 1, gridSize do
			if(terrainLayoutResult[row][col].terrainType == cliffTerrain[worldTerrainWidth] and GetScore(row, col, {cliffTerrain[worldTerrainWidth], nullTerrain}) <2) then
				terrainLayoutResult[row][col].terrainType = cliffTerrainHigh[worldTerrainWidth]
			end
		end
	end


	-- mark regions with no players unoccpied
	for i = 1, #regions do
		if(regions[i].occupied == true) then
			local row = regions[i].regionCenter[1]
			local col = regions[i].regionCenter[2]
			if(terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) then
				regions[i].occupied = false
			end
		end
	end

	validPlacementSquares = {}
	for row = 1, #terrainLayoutResult do
		for col = 1, #terrainLayoutResult do
			if(terrainLayoutResult[row][col].terrainType == plainsTerrain)then
				table.insert(validPlacementSquares, {row, col})
			end
		end
	end

	cornerRegions = GetUnoccupiedRegionsClosestToCorners(validPlacementSquares, regions)
	print("Num Corner Regions: " ..#cornerRegions)
	settlementLocations = {}
	placedSettlements = 0

	for i = 1, #cornerRegions do
		if(cornerRegions[i].occupied == false) then
			local centerRow = cornerRegions[i].regionCenter[1]
			local centerCol = cornerRegions[i].regionCenter[2]
			local row, col, squareIndex = GetFurthestSquare(centerRow, centerCol, cornerRegions[i].regionSquares)
			if(row < 1) then
				row = 1
			elseif(row > gridSize) then 
				row = gridSize
			end
			
			if(col < 1) then
				col = 1
			elseif(col > gridSize) then 
				col = gridSize
			end
			
			table.insert(settlementLocations, {row, col})
			placedSettlements = placedSettlements + 1
									
			if(placedSettlements >= 2) then
				break
			end
		end
	end

	print("Placed Settlements: " ..placedSettlements)
	
	-- place sacred sites ---------------------------

	sacredSiteLocations = {}
	-- center sacred site
	centerRegionIndex, centerSacredRegion = GetCenterRegion(regions)
	-- find the furthest unnocupied square in the region
	local centerRow = centerSacredRegion.regionCenter[1]
	local centerCol = centerSacredRegion.regionCenter[2]
	local neighbors = GetNeighbors(centerRow, centerCol, terrainLayoutResult)	
	local neighborSquare = GetRandomElement(neighbors)
	local row = neighborSquare.x
	local col = neighborSquare.y

	table.insert(sacredSiteLocations, {row, col})
	centerSacredRegion.occupied = true -- set room to occupied to facilitate other placements. Will be set back to false later.

	-- remaining sacred sites
	sacredIndex01 = GetFurthestUnoccupiedRegion(centerSacredRegion, regions, plainsTerrain)
	if(sacredIndex01 ~= nil) then
		local centerRow = regions[sacredIndex01].regionCenter[1]
		local centerCol = regions[sacredIndex01].regionCenter[2]
		local neighbors = GetNeighbors(centerRow, centerCol, terrainLayoutResult)	
		local neighborSquare = GetRandomElement(neighbors)
		local row = neighborSquare.x
		local col = neighborSquare.y

		regions[sacredIndex01].occupied = true -- set room to occupied to facilitate other placements. Will be set back to false later.
		table.insert(sacredSiteLocations, {row, col})
	end

	sacredIndex02 = GetFurthestUnoccupiedRegion(centerSacredRegion, regions, plainsTerrain)
	if(sacredIndex02 ~= nil) then
		local centerRow = regions[sacredIndex02].regionCenter[1]
		local centerCol = regions[sacredIndex02].regionCenter[2]
		local neighbors = GetNeighbors(centerRow, centerCol, terrainLayoutResult)	
		local neighborSquare = GetRandomElement(neighbors)
		local row = neighborSquare.x
		local col = neighborSquare.y

		table.insert(sacredSiteLocations, {row, col})
	end

	centerSacredRegion.occupied = false
	regions[sacredIndex01].occupied = false -- set back to false to facilitate other resource placement
	
	if(#sacredSiteLocations < 3) then
		-- fallback sacred placement procedure
		PlaceSacredSiteFallback(playerStartLocations, sacredSiteLocations)
	end
	
	-- PLACE RESOURCES IN ROOMS ------------------------------------------------
	
	--- POI ---
	local poiOpenRegions = DeepCopy(regions)
	poiLocations = {}
	startLocations = {} -- create new start locations table formatted for distance checks
	local poiBufferReduction = 0
	
	if(randomPositions == true) then poiBufferReduction = 4 end -- reduce buffer when players more spread out from random placement
	
	print("Number of Regions Including Occupied:" ..#poiOpenRegions)
	for i = #poiOpenRegions, 1, -1 do
		if(poiOpenRegions[i].occupied == true) then
			table.insert(startLocations, {poiOpenRegions[i].regionCenter[1], poiOpenRegions[i].regionCenter[2]})
			print("Removing occupied region...")
			table.remove(poiOpenRegions, i)
		end
	end
	print("Number of Remaining Regions:" ..#poiOpenRegions)
	
	for i = 1, numPoi[worldTerrainWidth] do
		local regionIndex = nil
		local regionFound = false
		
		while(regionFound == false and #poiOpenRegions > 0) do
			regionIndex = GetRandomUnoccupiedRegionIndex(poiOpenRegions)
			
			if(SquaresFarEnoughApart(poiOpenRegions[regionIndex].regionCenter[1], poiOpenRegions[regionIndex].regionCenter[2], poiBufferPlayers[worldTerrainWidth] - poiBufferReduction, startLocations, gridSize) == true) then
				regionFound = true
			else
				table.remove(poiOpenRegions, regionIndex)
			end
		end
		
		if(regionIndex ~= nil and #poiOpenRegions > 0) then
			local placementSquares = poiOpenRegions[regionIndex].regionSquares
			local poiPlaced = false
			while (poiPlaced == false and #placementSquares > 0) do
				local sIndex = GetRandomIndex(placementSquares)
				local row = placementSquares[sIndex][1]
				local col = placementSquares[sIndex][2]
				
				if(terrainLayoutResult[row][col].terrainType == plainsTerrain) then
					table.insert(poiLocations, {row, col})
					poiPlaced = true
				end
				
				table.remove(placementSquares, sIndex)
			end
		end
		
		table.remove(poiOpenRegions, regionIndex)
	end
	
	--- GOLD ---
	--goldIndex = GetUnoccupiedRegionFurthestFromPlayers(regions, plainsTerrain)
	print("Num Team Regions: " ..#teamStartRegionIndexes)
	if(randomPlacement == false) then -- find the furthest room
		goldIndex = GetUnoccupiedRegionFurthestFromTeams(teamStartRegionIndexes, regions, plainsTerrain)
	else
		goldIndex = centerRegionIndex -- place gold in the center room for optimal placement when players spread out from random placement
	end
	
	potentialGoldSquares = regions[goldIndex].regionSquares
	goldRoomPlaced = false
	goldCount = 50
	
	while(#potentialGoldSquares > 0 and goldRoomPlaced == false and goldCount > 0) do
		local squareIndex = GetRandomIndex(potentialGoldSquares)
		
		local row = potentialGoldSquares[squareIndex][1]
		local col = potentialGoldSquares[squareIndex][2]
		
		if (terrainLayoutResult[row][col].terrainType == plainsTerrain) then
			print("Placing Gold At Row: " ..row ..", Col: " ..col)
			terrainLayoutResult[row][col].terrainType = goldTerrain		
			goldRoomPlaced = true
		end
		
		table.remove(potentialGoldSquares, squareIndex)
		goldCount = goldCount - 1
		--print("Gold Count: " ..goldCount)
	end
	
	--- WOOD ---
	woodLocations = {}
	for i = 1, #teamStartRegionIndexes do
		local teamRegionIndex = teamStartRegionIndexes[i]
		local woodRegionIndex = GetClosestUnoccupiedRegion(regions[teamRegionIndex], regions, plainsTerrain)
		
		if(woodRegionIndex ~= nil) then
			local row = regions[woodRegionIndex].regionCenter[1]
			local col = regions[woodRegionIndex].regionCenter[2]
			
			if(terrainLayoutResult[row][col].terrainType == plainsTerrain) then	
				table.insert(woodLocations, {row, col})
			else
				local neighbors = GetNeighborsOfType(row, col, {plainsTerrain}, terrainLayoutResult)
				
				for j = 1, #neighbors do
					row = neighbors[j].x
					col = neighbors[j].y				
					table.insert(woodLocations, {row, col})
					break
				end
			end
			
			regions[woodRegionIndex].occupied = true
		end
		
		if(i > maxWoodRooms[worldTerrainWidth]) then break end -- exit the loop if we have too many teams to give each one a wood room
	end
	
	--- STONE ---
	stoneLocations = {}
	for i = 1, #teamStartRegionIndexes do
		local teamRegionIndex = teamStartRegionIndexes[i]
		local stoneRegionIndex = GetClosestUnoccupiedRegion(regions[teamRegionIndex], regions, plainsTerrain)
		if(stoneRegionIndex ~= nil) then
			local squareIndex = GetRandomIndex(regions[stoneRegionIndex].regionSquares)
			local row = regions[stoneRegionIndex].regionSquares[squareIndex][1]
			local col = regions[stoneRegionIndex].regionSquares[squareIndex][2]
			table.insert(stoneLocations, {row, col})
			regions[stoneRegionIndex].occupied = true
			if(i > maxStoneRooms[worldTerrainWidth]) then break end -- exit the loop if we have too many teams to give each one a stone room
		end
	end
	
	smallGoldLocations = {}
	if(#teamMappingTable > maxStoneRooms[worldTerrainWidth]) then
		local unoccupiedRegions = {}
		
		for i = 1, #regions do
			if(regions[i].occupied == false) then
				table.insert(unoccupiedRegions, regions[i])
			end
		end
		
		if(#unoccupiedRegions > 0) then
			for i = 1, #unoccupiedRegions do
				if(worldGetRandom() < 0.4) then
					-- place a small gold room
					local roomPlaced = false
					local openSquares = unoccupiedRegions[i].regionSquares
					
					while(roomPlaced == false and #openSquares > 0) do
						local squareIndex = GetRandomIndex(unoccupiedRegions[i].regionSquares)
						local row = unoccupiedRegions[i].regionSquares[squareIndex][1]
						local col = unoccupiedRegions[i].regionSquares[squareIndex][2]
						
						if(terrainLayoutResult[row][col].terrainType == plainsTerrain) then
							table.insert(smallGoldLocations, {row, col})
							roomPlaced = true
						end
						
						table.remove(openSquares, squareIndex)						
					end
				else
					-- place a wood room
					local roomPlaced = false
					local openSquares = unoccupiedRegions[i].regionSquares
					
					while(roomPlaced == false and #openSquares > 0) do
						local squareIndex = GetRandomIndex(unoccupiedRegions[i].regionSquares)
						local row = unoccupiedRegions[i].regionSquares[squareIndex][1]
						local col = unoccupiedRegions[i].regionSquares[squareIndex][2]
						
						if(terrainLayoutResult[row][col].terrainType == plainsTerrain) then
							table.insert(woodLocations, {row, col})
							roomPlaced = true
						end
						
						table.remove(openSquares, squareIndex)						
					end
				end
			end
		end
	end
	
	--- SET TERRAIN TYPES for resource, sacred and settlement squares (terrain type affects path finding so setting these after all distance checks complete)
	
	-- settlements
	for i = 1, #settlementLocations do
		local row = settlementLocations[i][1]
		local col = settlementLocations[i][2]
		terrainLayoutResult[row][col].terrainType = settlementTerrain
	end
	
	-- wood
	for i = 1, #woodLocations do
		local row = woodLocations[i][1]
		local col = woodLocations[i][2]
		terrainLayoutResult[row][col].terrainType = woodTerrain
	end
	
	-- stone
	for i = 1, #stoneLocations do
		local row = stoneLocations[i][1]
		local col = stoneLocations[i][2]
		terrainLayoutResult[row][col].terrainType = stoneTerrain
	end
	
	-- small gold
	for i = 1, #smallGoldLocations do
		local row = smallGoldLocations[i][1]
		local col = smallGoldLocations[i][2]
		terrainLayoutResult[row][col].terrainType = smallGoldTerrain
	end
	
	-- poi
	for i = 1, #poiLocations do
		local row = poiLocations[i][1]
		local col = poiLocations[i][2]
		terrainLayoutResult[row][col].terrainType = poiRandomTerrain
	end
	
	-- sacred sites
	print("Num sacred terrain: " ..#sacredSiteLocations)
	for i = 1, #sacredSiteLocations do
		local row = sacredSiteLocations[i][1]
		local col = sacredSiteLocations[i][2]
		
		if(terrainLayoutResult[row][col].terrainType == plainsTerrain) then
			terrainLayoutResult[row][col].terrainType = sacredTerrain
		else
			print("Move sacred site to avoid preplaced terrain")
			local sacredNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			
			for snIndex = 1, #sacredNeighbors do
				local sRow = sacredNeighbors[snIndex].x
				local sCol = sacredNeighbors[snIndex].y
				
				if (terrainLayoutResult[sRow][sCol].terrainType == plainsTerrain) then
					terrainLayoutResult[sRow][sCol].terrainType = sacredTerrain
					break
				end
			end
		end
	end
	
	local spawnBlockers = {} -- table to hold spawn blocking squares
	
	-- set the terrain of the connecting lines to plains blocker to prevent distributions from clogging narrow passages
	for i = 1, #connectionLines do
		
		for j = 1, #connectionLines[i] do
			x = connectionLines[i][j][1]
			y = connectionLines[i][j][2]
			
			if(terrainLayoutResult[x][y].terrainType ~= centerPositionTerrain and terrainLayoutResult[x][y].terrainType ~= playerStartTerrain and GetScore(x, y, {cliffTerrain[worldTerrainWidth], cliffTerrainHigh[worldTerrainWidth]}) >= 2)then
				terrainLayoutResult[x][y].terrainType = plainsBlockerTerrain
				table.insert(spawnBlockers, {x, y})
			end
		end
	end
	
	for i = 1, #spawnBlockers do
		local sRow = spawnBlockers[i][1]
		local sCol = spawnBlockers[i][2]
		
		local neighbors = GetNeighborsOfType(sRow, sCol, {plainsTerrain}, terrainLayoutResult)
		for j = 1, #neighbors do
			local nRow = neighbors[j].x
			local nCol = neighbors[j].y
			terrainLayoutResult[nRow][nCol].terrainType = plainsBlockerTerrain
		end
	end
end


if(drawRooms == true) then
	occupiedRegions = 0
	for i = 1, #regions do
		if(regions[i].occupied == true) then
			occupiedRegions = occupiedRegions + 1
		end
	end

	print("MAP SIZE: " ..worldTerrainWidth ..", TOTAL ROOMS: " ..#regions ..", OCCUPIED ROOMS: " ..occupiedRegions ..", FREE ROOMS: " ..#regions - occupiedRegions)
end


print("END OF DUNGEON LUA SCRIPT")