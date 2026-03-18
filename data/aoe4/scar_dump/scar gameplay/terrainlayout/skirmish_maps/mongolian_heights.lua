-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING MONGOLIAN HEIGHTS")

n = tt_none

h = tt_hills_low_rolling
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_med_rolling
p = tt_plains
f = tt_flatland
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains
pl = tt_plateau_low
p2 = tt_plateau_standard
p3 = tt_plateau_high
f = tt_impasse_trees_plains
v = tt_valley
r = tt_river

teamMappingTable = CreateTeamMappingTable()


--set up resource pockets
--[[
s = tt_player_start_nomad_hills
nomadPocketResources1 = {}
nomadPocketResources2 = {}
nomadPocketResources3 = {}

--create groups of pocket resources that will equal out to balanced resources
--players will randomly get one set of these
nomadPocketResourceList = {}
table.insert(nomadPocketResourceList, nomadPocketResources1)
table.insert(nomadPocketResourceList, nomadPocketResources2)
table.insert(nomadPocketResourceList, nomadPocketResources3)

psa = tt_pocket_stone_a
psb = tt_pocket_stone_b
psc = tt_pocket_stone_c
pga = tt_pocket_gold_a
pgb = tt_pocket_gold_b
pgc = tt_pocket_gold_c
pwa = tt_pocket_wood_a
pwb = tt_pocket_wood_b
pwc = tt_pocket_wood_c

table.insert(nomadPocketResources1, psa)
table.insert(nomadPocketResources1, pgb)
table.insert(nomadPocketResources1, pwc)
table.insert(nomadPocketResources2, psb)
table.insert(nomadPocketResources2, pgc)
table.insert(nomadPocketResources2, pwa)
table.insert(nomadPocketResources3, psc)
table.insert(nomadPocketResources3, pga)
table.insert(nomadPocketResources3, pwb)

nomadStart = false
if (winConditionOptions.section_starting_conditions and winConditionOptions.section_starting_conditions.option_age_start) then
	nomadStart = (winConditionOptions.section_starting_conditions.option_age_start.enum_value == winConditionOptions.section_starting_conditions.option_age_start.enum_items.nomad_start)
	print("NOMAD START CONDITION IS: " ..winConditionOptions.section_starting_conditions.option_age_start.enum_value.." ("..tostring(nomadStart)..")")
else
	print("NOMAD START CONDITION IS NOT SET (FALSE)")
end
]]

-- MAP/GAME SET UP ------------------------------------------------------------------------
--call the standard function to set up our grid using standard dimensions/square
--function found in scar/terrainlayout/library/map_setup
--use this function if creating a map with standard resolution and dimension (most maps)
--see the island maps for examples of non-standard resolutions
terrainLayoutResult = {}    -- set up initial table for coarse map grid
--gridHeight, gridWidth, gridSize = SetCoarseGrid()
mapRes = 33
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(mapRes)



--these values are values received specifically to let the script know information about map dimensions
--the number of players is grabbed from the map setup menu screen and includes both human and AI players
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

--grab the number of players from the match setup screen
playerStarts = worldPlayerCount


-- setting up the map grid with correct fields and terrain type info
-- you need to use this function when creating a new map
-- found in the engine library under scar/terrainlayout/library/setsquaresfunctions
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

mapHalfSize = math.ceil(gridSize/2)
print("---------------- map half size is " ..mapHalfSize)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)


--set player start locations on the map
startLocationPositions = {}
actualStartPositions = {}

--this function creates a set of default start positions ringing the edge of the map
--function found in scar/terrainlayout/library/player_starts
masterStartPositionsTable = MakeStartPositionsTable(gridSize, gridSize, gridSize) 
openStartPositions = {}

for i = 1, #masterStartPositionsTable do
	print("Start Position " ..i .." is at row: " ..masterStartPositionsTable[i].startRow ..", Col: " ..masterStartPositionsTable[i].startCol)
end

-- add start areas to the open list
for index = 1, #masterStartPositionsTable do
	tempStartPosition = masterStartPositionsTable[index]
	table.insert(openStartPositions, index, tempStartPosition)
end

for index = 1, #openStartPositions do
	print("OSP ID " ..index .." is " ..openStartPositions[index].startID .." Number of connections is: " ..#openStartPositions[index].connections)	 
end

--the Deep Copy function produces a copy of the table that will not be altered if you change the original
--function found in the engine folder at scar/terrainlayout/library/calculationfunctions
terrainStartPositions = DeepCopy(openStartPositions)



-- PLACE PLAYER START POSITIONS -----------------------------------------------------
print("RANDOM POSITIONS IS " ..tostring(randomPositions))
-- find a start location for each player

if (worldPlayerCount <=4) then -- reduce start positions options to 4 to keep players far enough apart
		
		if (worldGetRandom() < 0.49 and worldTerrainHeight > 513) then -- remove start positions on edges
			
			for index = 4, 1, -1 do
				table.remove(openStartPositions, index)
			end
			
		else -- remove start positions on corners				
			
			for index = 8, 5, -1 do
				table.remove(openStartPositions, index)
			end
			
		end	

	end
		
	if (randomPositions == true) then -- place players without regard to grouping teams together		
		
		-- select start positions
		--function found in scar/terrainlayout/library/player_starts
		actualStartPositions = GetStartPositionsTeamsApart(openStartPositions)
	
	else -- place players from the same team grouped together
	
		-- select start positions
		--function found in scar/terrainlayout/library/player_starts
		actualStartPositions = GetStartPositionsTeamsTogether(openStartPositions, masterStartPositionsTable)
	
	end

	-- place the start area on the coarse grid
	for index = 1, #actualStartPositions do
		x = actualStartPositions[index].startRow
		y = actualStartPositions[index].startCol
		print("Player " ..index .." is at row " ..x ..", col "..y)
	--	terrainLayoutResult[x+1][y].terrainType = p
	--	terrainLayoutResult[x][y+1].terrainType = p
	--	terrainLayoutResult[x][y-1].terrainType = p
	--	terrainLayoutResult[x][y].playerIndex = actualStartPositions[index].playerID --you must assign player IDs to the starting squares, starting at player 0 (matches the game setup screen)
	--	print("Setting PlayerID in terrain layout to " ..actualStartPositions[index].playerID)
	
		table.insert(startLocationPositions, {x, y})
	end



-- MONGOLIAN HEIGHTS TERRAIN FEATURES -----------------------------------------------

--grab half of the start positions for making the terrain layout
--if (worldGetRandom() < 0.49) then
--	for index = 4, 1, -1 do
--		table.remove(terrainStartPositions, index)
--	end
			
--	else -- remove start positions on corners				
	for index = 8, 5, -1 do
		table.remove(terrainStartPositions, index)
	end
--end

print("number of terrain start positions is: " .. #terrainStartPositions)

terrainStartOrder = {1, 4, 2, 3}

--around this point, grab a random square within a small random radius
if(worldTerrainWidth <= 513) then	
	randomVariance = 2
else
	randomVariance = 5
end

--list of start points and halfway points to connect later
connectionPoints = {}

--loop through actual start positions, record a table of halfway points
halfwayPoints = {}

currentPlayerNum = 1
for index = 1, #terrainStartPositions do
	
	if(index == #terrainStartPositions) then
		currentPlayerNum = 1
	else
		currentPlayerNum = index + 1
	end
	
	currentStartIndex = terrainStartOrder[index]
	currentEndIndex = terrainStartOrder[currentPlayerNum]
	
	currentStartPoint = terrainStartPositions[currentStartIndex]
	currentStartRow = currentStartPoint.startRow
	currentStartCol = currentStartPoint.startCol
	
	if(worldTerrainWidth > 513) then
		currentStartRow, currentStartCol = GetSquareInBox(currentStartRow - randomVariance, currentStartRow + randomVariance, currentStartCol - randomVariance, currentStartCol + randomVariance, gridSize)
	end
	tempCoord = {currentStartRow, currentStartCol}
	
	--insert starting point for this iteration into connection point list
	table.insert(connectionPoints, tempCoord)
	
	currentEndPoint =  terrainStartPositions[currentEndIndex]
	currentEndRow = currentEndPoint.startRow
	currentEndCol = currentEndPoint.startCol
	
	--compute midpoint between start and endpoint
	midCol = (currentStartCol + math.ceil((currentEndCol - currentStartCol) / 2))
	midRow = (currentStartRow + math.ceil((currentEndRow - currentStartRow) / 2))
	print("current midpoint between " .. currentStartRow .. ", " .. currentStartCol .. " and " .. currentEndRow .. ", " .. currentEndCol .. " is " .. midRow .. ", " .. midCol)
	
	
	
	randomMidRow, randomMidCol = GetSquareInBox(midRow - randomVariance, midRow + randomVariance, midCol - randomVariance, midCol + randomVariance, gridSize)
	tempCoord = {randomMidRow, randomMidCol}
	
	--assign the new midpoint to the connectionPoint list and the midpoint list
	table.insert(connectionPoints, tempCoord)
	table.insert(halfwayPoints, tempCoord)
	
	
end

--loop through all connection points and draw a line of plains cliff between them
currentConnectionNum = 1
for index = 1, #connectionPoints do

	if(index == #connectionPoints) then
		currentConnectionNum = 1
	else
		currentConnectionNum = index + 1
	end
	
	currentStartRow = connectionPoints[index][1]
	currentStartCol = connectionPoints[index][2]
	
	currentEndRow = connectionPoints[currentConnectionNum][1]
	currentEndCol = connectionPoints[currentConnectionNum][2]
	
	print("drawing line between points " .. index .. " and " .. currentConnectionNum)
	
	--draw a line of plains cliff terrain between the 2 connection points
	DrawLineOfTerrain(currentStartRow, currentStartCol, currentEndRow, currentEndCol, tt_plains, true, gridSize)
	
end

if(worldTerrainHeight > 513) then
	--connect start points directly also
	DrawLineOfTerrain(connectionPoints[1][1], connectionPoints[1][2], connectionPoints[3][1], connectionPoints[3][2], tt_plains, false, gridSize)
	DrawLineOfTerrain(connectionPoints[3][1], connectionPoints[3][2], connectionPoints[5][1], connectionPoints[5][2], tt_plains, false, gridSize)
	DrawLineOfTerrain(connectionPoints[5][1], connectionPoints[5][2], connectionPoints[7][1], connectionPoints[7][2], tt_plains, false, gridSize)
	DrawLineOfTerrain(connectionPoints[7][1], connectionPoints[7][2], connectionPoints[1][1], connectionPoints[1][2], tt_plains, false, gridSize)
end

--choose random halfway points and connect them as well
midPoint1a = halfwayPoints[math.ceil(worldGetRandom() * 4)]
midPoint1b = halfwayPoints[math.ceil(worldGetRandom() * 4)]
DrawLineOfTerrain(midPoint1a[1], midPoint1a[2], midPoint1b[1], midPoint1b[2], p, true, gridSize)

midPoint2a = halfwayPoints[math.ceil(worldGetRandom() * 4)]
midPoint2b = halfwayPoints[math.ceil(worldGetRandom() * 4)]
DrawLineOfTerrain(midPoint2a[1], midPoint2a[2], midPoint2b[1], midPoint2b[2], p, true, gridSize)

midPoint3a = halfwayPoints[math.ceil(worldGetRandom() * 4)]
midPoint3b = halfwayPoints[math.ceil(worldGetRandom() * 4)]
DrawLineOfTerrain(midPoint3a[1], midPoint3a[2], midPoint3b[1], midPoint3b[2], p, true, gridSize)

midPoint4a = halfwayPoints[math.ceil(worldGetRandom() * 4)]
midPoint4b = halfwayPoints[math.ceil(worldGetRandom() * 4)]
DrawLineOfTerrain(midPoint4a[1], midPoint4a[2], midPoint4b[1], midPoint4b[2], p, true, gridSize)


--draw the river, from one edge to the opposite edge

riverResult = {}
fordResults = {}

--set how far into the map from the corners the river can spawn
minEdge = math.ceil(gridSize * 0.42)
print("river min edge: " .. minEdge)
maxEdge = math.ceil(gridSize * 0.58)
print("river max edge: " .. maxEdge)

--find the starting points on the river
holySiteCoords = {}
isVerticalRiver = false
if(worldGetRandom() >= 0.5) then
	--vertical river
	isVerticalRiver = true
	riverStartRow = 1
	riverEndRow = gridSize
	riverStartCol = math.ceil(worldGetRandom() * gridSize)
	print("random river start column is: " .. riverStartCol)
	if(riverStartCol > maxEdge) then
		riverStartCol = maxEdge
	elseif(riverStartCol < minEdge) then
		riverStartCol = minEdge
	end
	
	riverEndCol = gridSize - riverStartCol + 1

		
else
	--horizontal river
	riverStartCol = 1
	riverEndCol = gridSize
	riverStartRow = math.ceil(worldGetRandom() * gridSize)
	print("random river start row is: " .. riverStartRow)
	if(riverStartRow > maxEdge) then
		riverStartRow = maxEdge
	elseif(riverStartRow < minEdge) then
		riverStartRow = minEdge
	end
	
	riverEndRow = gridSize - riverStartRow + 1
	
end

print("river start: " .. riverStartRow .. ", " .. riverStartCol)
print("river end: " .. riverEndRow .. ", " .. riverEndCol)

--get points for the river line
tempRiverPoints = {}
--this function draws a suitably straight line for the main river in Mongolian Heights
--function found in engine folder, at scar/terrainlayout/library/drawlinesfunctions
tempRiverPoints = DrawStraightLineReturn(riverStartRow, riverStartCol, riverEndRow, riverEndCol, false, tt_river, gridSize, terrainLayoutResult)
--tempRiverPoints = DrawLineOfTerrainNoNeighbors(riverStartRow, riverStartCol, riverEndRow, riverEndCol, false, tt_river, gridSize, terrainLayoutResult)

print("number of squares in the river is: " .. #tempRiverPoints)

--put river points into the river table
table.insert(riverResult, 1, tempRiverPoints)

--loop through river points, create 5 fords along river
fordTable = {}

ford1Min = math.ceil(#tempRiverPoints * 0.075)
ford1Max = math.ceil(#tempRiverPoints * 0.125)
ford1Index = math.ceil(GetRandomInRange(ford1Min, ford1Max))

print("placing ford 1 at river index " .. ford1Index)

ford2Min = math.ceil(#tempRiverPoints * 0.275)
ford2Max = math.ceil(#tempRiverPoints * 0.325)
ford2Index = math.ceil(GetRandomInRange(ford2Min, ford2Max))

print("placing ford 2 at river index " .. ford2Index)

ford3Index = Round((#tempRiverPoints / 2), 0)
print("placing ford 3 at river index " .. ford3Index)

ford4Min = math.ceil(#tempRiverPoints * 0.675)
ford4Max = math.ceil(#tempRiverPoints * 0.725)
ford4Index = math.ceil(GetRandomInRange(ford4Min, ford4Max))
print("placing ford 4 at river index " .. ford4Index)

ford5Min = math.ceil(#tempRiverPoints * 0.875)
ford5Max = math.ceil(#tempRiverPoints * 0.925)
ford5Index = math.ceil(GetRandomInRange(ford5Min, ford5Max))
print("placing ford 5 at river index " .. ford5Index)

table.insert(fordTable, riverResult[1][ford1Index])
table.insert(fordTable, riverResult[1][ford2Index])
table.insert(fordTable, riverResult[1][ford3Index])
table.insert(fordTable, riverResult[1][ford4Index])
table.insert(fordTable, riverResult[1][ford5Index])


--assign all river squares to be river terrain type for now
for index, currentRiverPoint in ipairs(tempRiverPoints) do
	
	terrainLayoutResult[currentRiverPoint[1]][currentRiverPoint[2]].terrainType = tt_river
	
end

settlementSquares = {}
holySiteSquares = {}

ford1Positive = false
if(worldGetRandom() > 0.5) then
	ford1Positive = true
end

holy1Positive = false
if(worldGetRandom() > 0.5) then
	holy1Positive = true
end

fordRadius = 3

for index, currentFordPoint in ipairs(fordTable) do
	
	currentRow = currentFordPoint[1]
	currentCol = currentFordPoint[2]
	
	
	currentFordNeighbors = GetAllSquaresInRadius(currentRow, currentCol, fordRadius, terrainLayoutResult)
	
	for neighborIndex, fordNeighbor in ipairs(currentFordNeighbors) do	
		currentNeighborRow = fordNeighbor[1]
		currentNeighborCol = fordNeighbor[2]
		
		if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_river) then
			terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
		end
		
		
	end
	
	currentFordNeighbors = Get8Neighbors(currentRow, currentCol, terrainLayoutResult)
	
	for neighborIndex, fordNeighbor in ipairs(currentFordNeighbors) do	
		currentNeighborRow = fordNeighbor.x
		currentNeighborCol = fordNeighbor.y
		
		if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_river) then
			terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
		end
	end
	
	
	--do trade posts
	
	if(index == 1 and ford1Positive == true) then
		if(isVerticalRiver == true) then
			newInfo = {}
			newInfo = {currentRow, currentCol + 2}
			table.insert(settlementSquares, newInfo)
		else
			newInfo = {}
			newInfo = {currentRow + 2, currentCol}
			table.insert(settlementSquares, newInfo)
		end
	end
	
	
	
	if(index == 1 and ford1Positive == false) then
		if(isVerticalRiver == true) then
			newInfo = {}
			newInfo = {currentRow, currentCol - 2}
			table.insert(settlementSquares, newInfo)
		else
			newInfo = {}
			newInfo = {currentRow - 2, currentCol}
			table.insert(settlementSquares, newInfo)
		end
	end
	
	
	if(index == 5 and ford1Positive == true) then
		if(isVerticalRiver == true) then
			newInfo = {}
			newInfo = {currentRow, currentCol - 2}
			table.insert(settlementSquares, newInfo)
		else
			newInfo = {}
			newInfo = {currentRow - 2, currentCol}
			table.insert(settlementSquares, newInfo)
		end
	end
	
	if(index == 5 and ford1Positive == false) then
		if(isVerticalRiver == true) then
			newInfo = {}
			newInfo = {currentRow, currentCol + 2}
			table.insert(settlementSquares, newInfo)
		else
			newInfo = {}
			newInfo = {currentRow + 2, currentCol}
			table.insert(settlementSquares, newInfo)
		end
	end
	
	--do holy sites
	if(index == 2 and holy1Positive == true) then
		if(isVerticalRiver == true) then
			newInfo = {}
			newInfo = {currentRow, currentCol + 2}
			table.insert(holySiteSquares, newInfo)
		else
			newInfo = {}
			newInfo = {currentRow + 2, currentCol}
			table.insert(holySiteSquares, newInfo)
		end
	end
	
	if(index == 2 and holy1Positive == false) then
		if(isVerticalRiver == true) then
			newInfo = {}
			newInfo = {currentRow, currentCol - 2}
			table.insert(holySiteSquares, newInfo)
		else
			newInfo = {}
			newInfo = {currentRow - 2, currentCol}
			table.insert(holySiteSquares, newInfo)
		end
	end
	
	if(index == 4 and holy1Positive == true) then
		if(isVerticalRiver == true) then
			newInfo = {}
			newInfo = {currentRow, currentCol - 2}
			table.insert(holySiteSquares, newInfo)
		else
			newInfo = {}
			newInfo = {currentRow - 2, currentCol}
			table.insert(holySiteSquares, newInfo)
		end
	end
	
	if(index == 4 and holy1Positive == false) then
		if(isVerticalRiver == true) then
			newInfo = {}
			newInfo = {currentRow, currentCol + 2}
			table.insert(holySiteSquares, newInfo)
		else
			newInfo = {}
			newInfo = {currentRow + 2, currentCol}
			table.insert(holySiteSquares, newInfo)
		end
	end
	
	
end


--widen small passages
--[[
for y = 1, gridSize do
	for x = 1, gridSize do
		if(x > 1 and y > 1 and x < gridSize and y < gridSize) then
			if(terrainLayoutResult[x][y].terrainType == p and ((terrainLayoutResult[x+1][y].terrainType == n and terrainLayoutResult[x-1][y].terrainType == n) or 
				(terrainLayoutResult[x][y+1].terrainType == n and terrainLayoutResult[x][y-1].terrainType == n) or (terrainLayoutResult[x+1][y+1].terrainType == n and terrainLayoutResult[x-1][y-1].terrainType == n) or
				(terrainLayoutResult[x-1][y+1].terrainType == n and terrainLayoutResult[x+1][y-1].terrainType == n))) then
				if(worldGetRandom() > 0.3) then
					terrainLayoutResult[x+1][y].terrainType = p1
					terrainLayoutResult[x][y+1].terrainType = p
					terrainLayoutResult[x+1][y+1].terrainType = p1
				else
					terrainLayoutResult[x-1][y].terrainType = h
					terrainLayoutResult[x][y-1].terrainType = b
					terrainLayoutResult[x-1][y-1].terrainType = p2
				end
			end
		end
	end
end
--]]
--[[
--replace river with plains
for y = 1, gridSize do
	for x = 1, gridSize do
		
		if(terrainLayoutResult[x][y].terrainType == tt_river) then
			print("replacing river with plains")
			terrainLayoutResult[x][y].terrainType = tt_flatland
		end
		
	end
end

--]]

for index, currentRiverPoint in ipairs(riverResult[1]) do
	
	currentRow = currentRiverPoint[1]
	currentCol = currentRiverPoint[2]
	
	terrainLayoutResult[currentRow][currentCol].terrainType = tt_river
	
	
end


---------------------
-- SETS ALL HILL TILES NEXT TO RIVERS INTO PLAINS (because rivers end up looking like they are climbing up a hill, which is silly)
---------------------

-- loop through grid
-- if riverpoint, get neighbor (returns a table)
-- loop through returned table and check if hill
-- if hill set to plains

tempNeighborList = {}

for row = 1, gridSize do
	for col = 1, gridSize do
		-- first loop that checks if the tile is a river
		if (terrainLayoutResult[row][col].terrainType == tt_river) then
			-- if river, then find all the neighbors
			tempNeighborList = Get12Neighbors(row, col, terrainLayoutResult)
			
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				-- if the tile is not a river tile, then
				if((terrainLayoutResult[tempRow][tempCol].terrainType == tt_hills_low_rolling) or (terrainLayoutResult[tempRow][tempCol].terrainType == tt_hills_med_rolling)) then
					print("Found a hill tile next to a river! Turning into a plain! Coordinates x " .. tempRow .. " y " .. tempCol)
					--set to plains
					terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
				end
			end			
		end
	end
end

s = tt_player_start_classic_hills
print("setting CLASSIC start conditions")
--[[
for i = 1, (#actualStartPositions) do
	
		terrainLayoutResult[actualStartPositions[i].startRow + 1][actualStartPositions[i].startCol].terrainType = tt_plains_clearing
		terrainLayoutResult[actualStartPositions[i].startRow - 1][actualStartPositions[i].startCol].terrainType = tt_plains_clearing
		terrainLayoutResult[actualStartPositions[i].startRow][actualStartPositions[i].startCol + 1].terrainType = tt_plains_clearing
		terrainLayoutResult[actualStartPositions[i].startRow][actualStartPositions[i].startCol - 1].terrainType = tt_plains_clearing
		
		terrainLayoutResult[actualStartPositions[i].startRow + 1][actualStartPositions[i].startCol + 1].terrainType = tt_hills_low_rolling
		terrainLayoutResult[actualStartPositions[i].startRow - 1][actualStartPositions[i].startCol - 1].terrainType = tt_plains_clearing
		terrainLayoutResult[actualStartPositions[i].startRow - 1][actualStartPositions[i].startCol + 1].terrainType = tt_plains_clearing
		terrainLayoutResult[actualStartPositions[i].startRow + 1][actualStartPositions[i].startCol - 1].terrainType = tt_plains_clearing
	
end
--]]
--terrainLayoutResult = RandomTerrainSwap({b}, v, terrainLayoutResult)


--place holy sites
for holyIndex = 1, #holySiteSquares do
	currentRow = holySiteSquares[holyIndex][1]
	currentCol = holySiteSquares[holyIndex][2]
	terrainLayoutResult[currentRow][currentCol].terrainType = tt_holy_site
	
	
	tempNeighborList = Get12Neighbors(currentRow, currentCol, terrainLayoutResult)
			
	--second loop, checks the neighbor tiles
	for index, neighbor in ipairs(tempNeighborList) do
		
		tempRow = neighbor.x
		tempCol = neighbor.y
		
		if(terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_river and terrainLayoutResult[tempRow][tempCol].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
		end
		
	end
	
	
	tempNeighborList = Get8Neighbors(currentRow, currentCol, terrainLayoutResult)
			
	--second loop, checks the neighbor tiles
	for index, neighbor in ipairs(tempNeighborList) do
		
		tempRow = neighbor.x
		tempCol = neighbor.y
		
		if(terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_river and terrainLayoutResult[tempRow][tempCol].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
		end
		
	end
end

for settlementIndex = 1, #settlementSquares do
	currentRow = settlementSquares[settlementIndex][1]
	currentCol = settlementSquares[settlementIndex][2]
	terrainLayoutResult[currentRow][currentCol].terrainType = tt_settlement_plains
	
	tempNeighborList = Get8Neighbors(currentRow, currentCol, terrainLayoutResult)
			
	--second loop, checks the neighbor tiles
	for index, neighbor in ipairs(tempNeighborList) do
		
		tempRow = neighbor.x
		tempCol = neighbor.y
		
		if(terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_river and terrainLayoutResult[tempRow][tempCol].terrainType ~= playerStartTerrain and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_holy_site) then
			terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
		end
		
	end
end

	
minPlayerDistance = 6
minTeamDistance = gridSize * 1.2
edgeBuffer = 2
cornerThreshold = 2

spawnBlockDistance = 3

playerStartTerrain = tt_player_start_classic_plains

spawnBlockers = {}
table.insert(spawnBlockers, tt_impasse_mountains)
table.insert(spawnBlockers, tt_mountains)
table.insert(spawnBlockers, tt_plateau_med)
table.insert(spawnBlockers, tt_ocean)
table.insert(spawnBlockers, tt_river)
table.insert(spawnBlockers, tt_settlement_plains)
table.insert(spawnBlockers, tt_holy_site)


basicTerrain = {}
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_plains_clearing)
table.insert(basicTerrain, tt_flatland)
table.insert(basicTerrain, tt_plateau_low)
--table.insert(basicTerrain, n)

if(worldTerrainWidth <= 416) then --for micro maps
	innerExclusion = 0.48
elseif(worldTerrainWidth <= 512) then --for tiny maps
	innerExclusion = 0.48
elseif(worldTerrainWidth <= 640) then  --for small maps
	innerExclusion = 0.48
elseif(worldTerrainWidth <= 768) then  --for medium maps
	innerExclusion = 0.48
elseif(worldTerrainWidth <= 896) then  --for large maps
	innerExclusion = 0.5
end


if(#teamMappingTable == 2 and randomPositions == false) then
	if(isVerticalRiver == false) then
		terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, false, spawnBlockers, spawnBlockDistance, 0.01, playerStartTerrain, tt_plains_smooth, 1, true, terrainLayoutResult)
	else
		terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, true, spawnBlockers, spawnBlockDistance, 0.01, playerStartTerrain, tt_plains_smooth, 1, true, terrainLayoutResult)
	end
	
else
	spawnBlockers = {}
	table.insert(spawnBlockers, tt_river)
	--terrainLayoutResult = PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, spawnBlockers, basicTerrain, playerStartTerrain, terrainLayoutResult)
	--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .4, spawnBlockers, 1, 0.05, playerStartTerrain, tt_plains_smooth, terrainLayoutResult)	
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, spawnBlockDistance, 0.05, playerStartTerrain, tt_plains_smooth, 1, true, terrainLayoutResult)
end


for i = 1, (#actualStartPositions) do
	
	--terrainLayoutResult[actualStartPositions[i].startRow][actualStartPositions[i].startCol].terrainType = s
	
end

--loop through teammates and connect their locations
for teamIndex = 1, #teamMappingTable do
	for playerIndex = 1, #teamMappingTable[teamIndex].players do
	
		if(#teamMappingTable[teamIndex].players >= 2) then
			
			currentPlayerRow = teamMappingTable[teamIndex].players[playerIndex].startRow
			currentPlayerCol = teamMappingTable[teamIndex].players[playerIndex].startCol
			
			if(playerIndex + 1 <= #teamMappingTable[teamIndex].players) then
			
				nextPlayerRow = teamMappingTable[teamIndex].players[playerIndex+1].startRow
				nextPlayerCol = teamMappingTable[teamIndex].players[playerIndex+1].startCol
				lineSquares = {}
				print("drawing line from player " .. playerIndex .. " to player " .. playerIndex + 1 .. " on team " .. teamIndex)
				lineSquares = DrawLineOfTerrainNoDiagonalReturn(currentPlayerRow, currentPlayerCol, nextPlayerRow, nextPlayerCol, false, tt_plains, gridSize, terrainLayoutResult)
				
				for lineIndex = 1, #lineSquares do
					currentRow = lineSquares[lineIndex][1]
					currentCol = lineSquares[lineIndex][2]
					
					if(terrainLayoutResult[currentRow][currentCol].terrainType ~= playerStartTerrain and terrainLayoutResult[currentRow][currentCol].terrainType ~= tt_settlement_plains
						and terrainLayoutResult[currentRow][currentCol].terrainType ~= tt_holy_site and terrainLayoutResult[currentRow][currentCol].terrainType ~= tt_river) then
						terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains_smooth
						print("setting line between player at " .. currentRow .. ", " .. currentCol)
					end
				end
			end
			
		end
	end
end

	
--- Checks to see if there are any river tiles near player start, and if so, add a crossing at that coordinate
tempNeighborList = {}

for row = 1, gridSize do
	for col = 1, gridSize do
		-- first loop that checks if the tile has a nearby river
		if (terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			--holds coordinates when river tiles are found
			tempRiverNeighborList = {}
			riverNeighborExists = false
			
			-- if river, then find all the neighbors
			tempNeighborList = Get12Neighbors(row, col, terrainLayoutResult)
			
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				tempCoord = {tempRow, tempCol}
				
				print("Playstart neighbor in row " .. tempRow .. " col " .. tempCol)
				
				-- if the tile is a river tile, find it
				
				--[[if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_river) then					
					print("River tile found near playerstart at row " .. tempRow .. " col " .. tempCol)
					
					--add the coordinate to a new table
					table.insert(tempRiverNeighborList, tempCoord)
					riverNeighborExists = true
				end
				]]
				
				for riverIndex = 1, #riverResult[1] do
					tempRiverRow = riverResult[1][riverIndex][1]
					tempRiverCol = riverResult[1][riverIndex][2]
					
					if (tempRow == tempRiverRow) and (tempCol == tempRiverCol) then
						print("River tile found near playerstart at row " .. tempRow .. " col " .. tempCol)
						
						--add the coordinate to a new table
						table.insert(tempRiverNeighborList, tempCoord)
						riverNeighborExists = true
					end					
					
				end
			end		
	
			print("The temp river neighbor list contains " .. #tempRiverNeighborList .. " river tiles")
			
			--if any of the neighbors are river tiles, we start to check if any of the river tiles are fords
			if riverNeighborExists == true then
				--bool that flags if a ford exists near playerstart
				fordPlayerStart = false
				
				--compare entries in tempRiverNeighborList to entries in fordTable
				--check if the coordinate and adjacent river tiles match with any tiles in the Fordtable
				for neighborIndex = 1, #tempRiverNeighborList do
					
					neighborRow = tempRiverNeighborList[neighborIndex][1]
					neighborCol = tempRiverNeighborList[neighborIndex][2]
					
					numFordsTemp = #fordTable
					
					print("The number of Fords in this river is " .. numFordsTemp)
					for fordIndex = 1, numFordsTemp do
						fordRow = fordTable[fordIndex][1]
						fordCol = fordTable[fordIndex][2]
						if (fordRow == neighborRow) and (fordCol == neighborCol) then
							--if there's a match, fordPlayerStart is set to true
							fordPlayerStart = true
							print("A ford already exists near player start")
						end
					end
				end
				
				--if fordPlayerStart is still false after the loops, then add a ford in one of the riverNeighbor tiles
				if fordPlayerStart == false then
					
					print("No existing ford was found near a player start")
					--randomly select an index from the available neighboring river tiles 
					numNeighbors = #tempRiverNeighborList
					
					if numNeighbors > 1 then 
						indexToMakeFord = math.ceil(GetRandomInRange(1, numNeighbors))
					else
						indexToMakeFord = 1
					end
					
					newFordRow = tempRiverNeighborList[indexToMakeFord][1]
					newFordCol = tempRiverNeighborList[indexToMakeFord][2]
					newFordCoord = {newFordRow, newFordCol}
					
					--insert to fordtable under river 1
				--	table.insert(fordTable, newFordCoord)
					
					print("A new crossing was inserted in row " .. newFordRow .. " col " .. newFordCol)
				end
			end
		end
	end
end

table.insert(fordResults, fordTable)

--------------------------------
-- CLEANUP
--------------------------------
--adds a ring of plains or hills around the map to prevent inaccessible plateau areas that are caused by random tt_none placement
for row = 1, gridSize do
	for col = 1, gridSize do
		if((terrainLayoutResult[row][col].terrainType ~= tt_river) and (terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) and (terrainLayoutResult[row][col].terrainType ~= tt_plains) and
				(row == 1 or row == gridSize or col == 1 or col == gridSize) and (terrainLayoutResult[row][col].terrainType ~= tt_holy_site) and (terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains)) then
		--	terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
			
			if (worldGetRandom() < 0.4) then
					terrainLayoutResult[row][col].terrainType = tt_plateau_standard
					print("A map edge/corner tile has been set to plains at " .. row .. " col " .. col)		
			else
					terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
					print("A map edge/corner tile has been set to low hill at " .. row .. " col " .. col)
			end	
			
		end
	end
end

--make sure there are hills around player starts to prevent cliffs cutting off resources
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == tt_plains_smooth) then
			tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
			
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				if(terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_river and terrainLayoutResult[tempRow][tempCol].terrainType ~= playerStartTerrain and terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_plains_smooth
						and (terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_holy_site) and (terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_settlement_plains)) then
					terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_low_rolling
				end
				
			end
		end
	end
end
				
--make current plains surrounded by cliff
cliffChance = 0.82
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == tt_plains) then
			tempNeighborList = Get8Neighbors(row, col, terrainLayoutResult)
			
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_none) then
					print("found empty terrain beside plains at " .. tempRow .. ", " .. tempCol .. ", changing to elevation")
					if(worldGetRandom() < cliffChance) then
						terrainLayoutResult[tempRow][tempCol].terrainType = tt_plateau_standard
					else
						terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_low_rolling
					end
				end
				
			end
		end
	end
end

--make large areas of none terrain turn into plains in the centre
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == tt_none) then
			tempNeighborList = Get8Neighbors(row, col, terrainLayoutResult)
			noneCounter = 0
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				
				if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_none or terrainLayoutResult[tempRow][tempCol].terrainType == tt_plains) then
					noneCounter = noneCounter + 1
				end
				
			end
			
			if(noneCounter >= 8) then
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
		end
	end
end

for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == tt_plains) then
			tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
			
			currentCliffs = 0
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_plateau_standard) then
					currentCliffs = currentCliffs + 1
				end
				
				
				if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_none) then
					print("found empty terrain beside plains at " .. tempRow .. ", " .. tempCol .. ", changing to elevation with currentCliffs at " .. currentCliffs)
					if(worldGetRandom() < cliffChance and currentCliffs < 2) then
						terrainLayoutResult[tempRow][tempCol].terrainType = tt_plateau_standard
						currentCliffs = currentCliffs + 1
					else
						terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_low_rolling
					end
				end
				
			end
		end
	end
end

--check for individual impasse pits
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == tt_plains) then
			tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
			
			currentCliffs = 0
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_plateau_standard) then
					currentCliffs = currentCliffs + 1
				end
				
			end
			
			--if a plains square is surrounded by cliff, pick one of the surrounding cliffs to be a hill
			if(currentCliffs > 3) then
				randomIndex = math.ceil(worldGetRandom() * 4)	
				chosenRow = tempNeighborList[randomIndex].x
				chosenCol = tempNeighborList[randomIndex].y 
				if (terrainLayoutResult[chosenRow][chosenCol].terrainType ~= tt_river and terrainLayoutResult[chosenRow][chosenCol].terrainType ~= playerStartTerrain
						and (terrainLayoutResult[chosenRow][chosenCol].terrainType ~= tt_holy_site) and (terrainLayoutResult[chosenRow][chosenCol].terrainType ~= tt_settlement_plains)) then
					terrainLayoutResult[chosenRow][chosenCol].terrainType = tt_hills_low_rolling
				end
				print("fixing an impasse pit by adding a hill at " .. chosenRow .. ", " .. chosenCol)
			end
		end
	end
end

--ensure there is a path to the centre straight from player starts
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			
			midPointRow = riverResult[1][ford3Index][1]
			midPointCol = riverResult[1][ford3Index][2]
			
			pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(row, col, midPointRow, midPointCol, false, p, gridSize, terrainLayoutResult)
			
			--iterate through this line and set it's points, and the surrounding points, to clearing
			for firstLineIndex = 1, #pathPointsTable do
				currentRow = pathPointsTable[firstLineIndex][1] 
				currentCol = pathPointsTable[firstLineIndex][2] 
				print("current row / col is " .. currentRow .. ", " .. currentCol)
				if (terrainLayoutResult[currentRow][currentCol].terrainType ~= tt_river and terrainLayoutResult[currentRow][currentCol].terrainType ~= playerStartTerrain
						and (terrainLayoutResult[currentRow][currentCol].terrainType ~= tt_holy_site) and (terrainLayoutResult[currentRow][currentCol].terrainType ~= tt_settlement_plains)) then
					terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
				end
			end
			
		end
	end
end




--ensure the edge of the map doesn't block in holy sites and trade posts
for row = 1, gridSize do
	for col = 1, gridSize do
		if(row == 1 or col == 1 or row == gridSize or col == gridSize) then
			
			if(terrainLayoutResult[row][col].terrainType == tt_plateau_standard) then
				terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
			end
			
		end
	end
end


print("END OF MONGOLIAN HEIGHTS LUA SCRIPT")
