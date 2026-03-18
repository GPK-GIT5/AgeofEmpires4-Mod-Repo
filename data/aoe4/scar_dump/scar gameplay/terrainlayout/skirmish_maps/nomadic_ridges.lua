print("GENERATING NOMADIC RIDGES...")

--------------------------------------------------
--TERRAIN TYPES
--------------------------------------------------

-- variables containing terrain types to be used in map
nullTerrain = tt_none  -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

plainsTerrain = tt_plains

riverTerrain = tt_river
riverTerrainResources = tt_river_resources_nomadic_ridges

hillGentleTerrain = tt_hills_gentle_rolling_nomadic_ridges
hillLowTerrain = tt_hills_low_rolling_nomadic_ridges
hillMedTerrain = tt_hills_med_rolling_nomadic_ridges
hillHighTerrain = tt_hills_high_rolling_nomadic_ridges
hillHighEdgeTerrain = tt_hills_high_rolling_edge_nomadic_ridges

cliffLowTerrain = tt_plateau_low
cliffMedTerrain = tt_plateau_med
cliffHighTerrain = tt_plateau_high_nomadic_ridges
cliffHighTerrain_416 = tt_plateau_high -- use this for micro maps as the other cliff is too high
cliffSoaringTerrain = tt_plateau_soaring_nomadic_ridges

playerStartTerrain = tt_none
playerStartNomadTerrain = tt_player_start_nomad_plains_nomadic_ridges -- has no starting resources for nomad mode
playerStartClassicTerrain = tt_player_start_classic_plains_nomadic_ridges -- has starting resources for classic mode

settlementTerrain = tt_settlement_hills_high_rolling_nomadic_ridges


--------------------------------------------------
--TUNABLES
--------------------------------------------------
minCliffHighDistance = 3
minPlayerDistance = 2
numHighCliffs = 5
minCliffMedDistance = 4
numMedCliffs = 4
maxCliffLength = 2
numSingleCliffs = 4

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
	
	--local numPlacements = numPlayers -- places 2 extra slots for the river to run through
	--if(numPlayers > 0) then numPlacements = numPlacements + 2 end
	
	local radius = midPoint - edgeBuffer -- calculate the radius of the circle
	local increment = Round(360 / numPlayers, 0) -- calculate the angle increment based on thhe number of placements (players + river squares)	
	local angleOffset = Round(GetRandomInRange(0, 4), 0) * 15 -- will add a random rotation to the player starts
	local riverCoords = {}
	
	
	--print("World Player Count: " ..worldPlayerCount)

	-- calculate row and column values for the circle of positions while reserving to spaces for river
	for index = 1, numPlayers do
		local angle = index * increment + angleOffset
		row = Round(radius * math.cos(angle * math.pi / 180), 0)
		col = Round(radius * math.sin(angle * math.pi / 180), 0)
		row = row + midPoint
		col = col + midPoint
		--print("Position " .. index .." is Row: " ..row ..", Col: " ..col)
		table.insert(positions, {row, col})
		
		local additionalOffset = 10 -- for 6 players: 0
		if(numPlayers == 6 or numPlayers == 8) then additionalOffset = 0 end -- need to adjust the river line differently for 6 or 8 players

		if(index == math.ceil(numPlayers / 2)) then
			angle = index * increment + math.floor(increment / 2) + angleOffset - additionalOffset
			row = Round((radius - 2) * math.cos(angle * math.pi / 180), 0)
			col = Round((radius - 2) * math.sin(angle * math.pi / 180), 0)
			row = row + midPoint
			col = col + midPoint
			--print("River Position 1 is Row: " ..row ..", Col: " ..col)
			table.insert(riverCoords, {row, col})
		elseif(index == numPlayers) then
			angle = index * increment + math.floor(increment / 2) + angleOffset - additionalOffset
			row = Round((radius - 2) * math.cos(angle * math.pi / 180), 0)
			col = Round((radius - 2) * math.sin(angle * math.pi / 180), 0)
			row = row + midPoint
			col = col + midPoint
			--print("River Position 2 is Row: " ..row ..", Col: " ..col)
			table.insert(riverCoords, {row, col})
		end
	end
	
	--print("Number of positions: " ..#positions)
	
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
	
	if(numPlayers <= 1) then -- single player games require a special case for river placement as there are not enough player starts to use as a reference for river placement
		riverCoords = {} -- clear out the coords created above
		
		-- set coords in case there are no players
		local pRow = 4
		local pCol = 6
		
		-- get the start position for the single player
		if(#positions > 0) then
			local pRow = positions[1][1]
			local pCol = positions[1][2]
		end
		
		-- determine river placement
		if (math.abs(pRow - midPoint) < math.abs(pCol - midPoint)) then -- draw river from top to bottom of map
			table.insert(riverCoords, {1, midPoint})
			table.insert(riverCoords, {size, midPoint})
		else -- draw river from left to right of map
			table.insert(riverCoords, {midPoint, 1})
			table.insert(riverCoords, {midPoint, size})
		end
	end
	
	return riverCoords
end

--- EXTRAPOLATE LINE
-- takes a line drawn between two points on the map to an outer point and extends it to the map edge (it requires two passes, one for each end of the line
-- mapMid is the mid point of the coarse grid
-- lineMidRow is the row of the center square of a line between two points (must be calculated before calling thhis function)
-- lineMidCol is the column of the center square of a line between two points (must be calculated before calling thhis function)
-- outerRow is the row of the outer point of the line
-- outer col is the column of the outer point of the line
-- mapSize is the map grid size
function ExtrapolateLineEnd(mapMid, lineMidRow, lineMidCol, outerRow, outerCol, mapSize)
	print("!!! EXTRAPOLATE LINE END")
	local finalRow = -1
	local finalCol = -1
	
	if(outerRow == mapMid) then -- line runs diagonally from middle of map to corner
		if(outerCol < mapMid) then
			finalRow = outerRow
			finalCol = 1
			return finalRow, finalCol
		else
			finalRow = outerRow
			finalCol = mapSize
			return finalRow, finalCol
		end
	elseif(outerCol == mapMid) then -- line runs diagonally from middle of map to corner
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
		if (outerRow <= outerCol and lineMidRow ~= outerRow) then -- solving for column
			m = (lineMidCol - outerCol) / (lineMidRow - outerRow)
			b = lineMidCol - (m * lineMidCol)
			
			finalRow = 1	
			finalCol = m * finalRow + b
		else -- solving for row
			m = (lineMidRow - outerRow) / (lineMidCol - outerCol)
			b = lineMidRow - (m * lineMidRow)
			
			finalCol = 1
			finalRow = m * finalCol + b
		end
	elseif(outerRow < mapMid and outerCol > mapMid) then -- top right map quadrant
		if(outerRow - 1 <= mapSize - outerCol and lineMidRow ~= outerRow) then  -- solving for column
			m = (lineMidCol - outerCol) / (lineMidRow - outerRow)
        	b = lineMidCol - (m * lineMidCol)
			
			finalRow = 1
			finalCol =  m * finalRow + b
		else -- solving for row
			m = (lineMidRow - outerRow) / (lineMidCol - outerCol)
        	b = lineMidRow - (m * lineMidRow)

			finalCol = mapSize
			finalRow = m * finalCol + b
		end		
	elseif(outerRow > mapMid and outerCol > mapMid) then -- bottom right map quadrant
		if(outerRow >= outerCol and lineMidRow ~= outerRow) then -- solving for column
			m = (lineMidCol - outerCol) / (lineMidRow - outerRow)
        	b = lineMidCol - m * lineMidCol
			
			finalRow = mapSize
			finalCol = m * finalRow + b
		else -- solving for row
			m = (lineMidRow - outerRow) / (lineMidCol - outerCol)
        	b = lineMidRow - (m * lineMidRow)
			
			finalCol = mapSize
			finalRow = m * finalCol + b
		end	
	elseif(outerRow > mapMid and outerCol < mapMid) then -- bottom left map quadrant
		if(mapSize - outerRow <= outerCol - 1 and lineMidRow ~= outerRow) then -- solving for column
			m = (lineMidCol - outerCol) / (lineMidRow - outerRow)
			b = lineMidCol - m * lineMidCol
			
			finalRow = mapSize 
			finalCol = m * finalRow + b
		else -- solving for row
			m = (lineMidRow - outerRow) / (lineMidCol - outerCol)
			b = lineMidRow - (m * lineMidRow)
			
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

--- GET CLIFF SQUARES
 -- finds hill terrain to convert to cliffs based on the hill terrain type passed in
function GetCliffSquares(squaresTable, startLocations, hillTerrain, cliffTerrain, maxCliffLength, minCliffDistance, minStartDistance, numPlacements)
	local openSquares = DeepCopy(squaresTable)
	local placedCliffs = {}
	local placements = 0
	
	while(#openSquares > 0 and placements < numPlacements) do
		local index = GetRandomIndex(openSquares)
		local numCliffs = 0
		
		if(SquaresFarEnoughApartEuclidian(openSquares[index][1], openSquares[index][2], minStartDistance, startLocations, gridSize) == true) then
			if(#placedCliffs > 0) then
				if(SquaresFarEnoughApartEuclidian(openSquares[index][1], openSquares[index][2], minCliffDistance, placedCliffs, gridSize) == true) then
					table.insert(placedCliffs, {openSquares[index][1], openSquares[index][2]})
					terrainLayoutResult[openSquares[index][1]][openSquares[index][2]].terrainType = cliffTerrain
					numCliffs = numCliffs + 1
					placements = placements + 1
					
					local neighbors = Get8Neighbors(openSquares[index][1], openSquares[index][2], terrainLayoutResult)
					
					for j = 1, #neighbors do
						local row = neighbors[j].x
						local col = neighbors[j].y
						if(terrainLayoutResult[row][col].terrainType == hillTerrain) then
							terrainLayoutResult[row][col].terrainType = cliffTerrain
							table.insert(placedCliffs, {row, col})
							numCliffs = numCliffs + 1
						end
						
						if(numCliffs >= maxCliffLength) then break end
					end
				end
			else
				table.insert(placedCliffs, {openSquares[index][1], openSquares[index][2]})
				placements = placements + 1
				numCliffs = numCliffs + 1
					
				local neighbors = Get8Neighbors(openSquares[index][1], openSquares[index][2], terrainLayoutResult)
				
				for j = 1, #neighbors do
					local row = neighbors[j].x
					local col = neighbors[j].y
					if(terrainLayoutResult[row][col].terrainType == hillTerrain) then
						terrainLayoutResult[row][col].terrainType = cliffTerrain
						table.insert(placedCliffs, {row, col})
						numCliffs = numCliffs + 1
					end
					
					if(numCliffs >= maxCliffLength) then break end
				end				
			end
		end
		
		table.remove(openSquares, index)
	end
	
	return placedCliffs
end

function GetRandomCliffSquare(squaresTable, startLocations, validTerrain, cliffTerrain, cliffTable, minPlacedCliffDistance, minSingleCliffDistance, minStartDistance, numPlacements)
	local newCliffSquares = {}
	local openSquares = DeepCopy(squaresTable)
	local placedCliffs = 0
	
	while(#openSquares > 0 and placedCliffs <= numPlacements) do
		local squareIndex = GetRandomIndex(openSquares)
		local row = openSquares[squareIndex][1]
		local col = openSquares[squareIndex][2]
		
		if(terrainLayoutResult[row][col].terrainType == validTerrain) then -- enxure this is a valid square
			if(#newCliffSquares > 0) then -- check proximity for single cliffs, previous cliffs and player starts
				if(SquaresFarEnoughApartEuclidian(row, col, minSingleCliffDistance, newCliffSquares, gridSize) == true) then
					if(SquaresFarEnoughApartEuclidian(row, col, minPlacedCliffDistance, cliffTable, gridSize) == true) then
						if(SquaresFarEnoughApartEuclidian(row, col, minStartDistance, startLocations, gridSize) == true) then
							table.insert(newCliffSquares, {row,col})
							placedCliffs = placedCliffs + 1
						end
					end
				end
			else -- skip check for single cliff proximity and check previous cliffs and player start proximity		
				if(SquaresFarEnoughApartEuclidian(row, col, minPlacedCliffDistance, cliffTable, gridSize) == true) then
					if(SquaresFarEnoughApartEuclidian(row, col, minStartDistance, startLocations, gridSize) == true) then
						table.insert(newCliffSquares, {row,col})
						placedCliffs = placedCliffs + 1
					end
				end			
			end
		end
		
		table.remove(openSquares, squareIndex)
	end
	
	return newCliffSquares
end

--------------------------------------------------
--MAIN MAP SCRIPT
--------------------------------------------------

-- MAP/GAME SET UP ------------------------------------------------------------------------
gridHeight, gridWidth, gridSize = SetCoarseGrid() -- sets the coarse dimensions using the function found in map_setup lua file in the library folder
mapMidPoint = math.ceil(gridSize / 2)

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize .." MAP MID POINT IS " ..mapMidPoint)

-- setting up the map grid for terrain types and other data using default function found in map_setup lua in library folder
terrainLayoutResult = {} -- the grid for all terrain data (must use this name)
terrainLayoutResult = SetUpGrid(gridSize, nullTerrain, terrainLayoutResult)

-- PLAYER SETUP ---------------------------------------------------------------------------
print("Random Positions = " ..tostring(randomPositions))
print("NOMAD START CONDITION IS: " ..winCondition)

if(winCondition == "nomad") then
	playerStartTerrain = playerStartNomadTerrain -- no starting resources for nomad mode
else
	playerStartTerrain = playerStartClassicTerrain
end

local riverSquares = {}
local startLocationPositions = {}

if(worldPlayerCount > 0) then -- ensure there is at least one player before setting player starts and placing terrain based on those starts
	teamMappingTable = CreateTeamMappingTable()
	
	riverSquares = PlacePlayerStarts(randomPositions, teamMappingTable, worldPlayerCount, gridSize, mapMidPoint, 2, playerStartTerrain, terrainLayoutResult)

 -- MAP SETUP -----------------------------------------------------------------------------
	
	if(worldTerrainWidth <= 416) then cliffHighTerrain = cliffHighTerrain_416 end -- use lower cliffs for this map size
	
	for row = 1, gridSize do
		for col = 1, gridSize do
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				table.insert(startLocationPositions, {row, col})
			end
		end
	end

	for index = 1, #riverSquares do
		row = riverSquares[index][1]
		col = riverSquares[index][2]
		terrainLayoutResult[row][col].terrainType = riverTerrain
	end

	local riverLine = {}
	local lines = {}
	local riverMidRow = Round((riverSquares[1][1] + riverSquares[2][1]) / 2, 0)
	local riverMidCol = Round((riverSquares[1][2] + riverSquares[2][2]) / 2, 0)
	
	print("Line Mid Row: " ..riverMidRow ..", Col: " ..riverMidCol)
	
	if(#riverSquares > 0) then
		local rLine = {}		
		local startRow, startCol = ExtrapolateLineEnd(mapMidPoint, riverMidRow, riverMidCol, riverSquares[1][1], riverSquares[1][2], gridSize)
		
		rLine = DrawLineOfTerrainReturn(startRow, startCol, riverMidRow, riverMidCol, riverTerrain, false, gridSize)
		
		for i = 1, #rLine do
			table.insert(riverLine, rLine[i])
		end

		startRow, startCol = ExtrapolateLineEnd(mapMidPoint,riverMidRow, riverMidCol, riverSquares[2][1], riverSquares[2][2], gridSize)
		rLine = DrawLineOfTerrainReturn(riverMidRow, riverMidCol, startRow, startCol, riverTerrain, false, gridSize)
		
		for i = 1, #rLine do
			table.insert(riverLine, rLine[i])
		end
	end

	for i = 1, #riverLine do
		if(riverLine[i][1] == riverMidRow and riverLine[i][2] == riverMidCol) then -- remove the duplicate river square that results from the line drawing above
			table.remove(riverLine, i)
			break
		end
	end

	for i = 1, #riverLine do
		print("River Row: " ..riverLine[i][1] ..", Col: " ..riverLine[i][2])
	end

	for i = 1, #riverLine do
		local row = riverLine[i][1]
		local col = riverLine[i][2]
		terrainLayoutResult[row][col].terrainType = riverTerrain
	end

	riverResult = {}
	table.insert(riverResult, 1, riverLine)
	
	local plainsSquares = {}
	local gentleSquares = {}
	local lowSquares = {}
	local medSquares = {}
	local highSquares = {}
	
	for i = 1, #riverLine do
		local neighborSquares = GetNeighbors(riverLine[i][1], riverLine[i][2], terrainLayoutResult)
		
		for j = 1, #neighborSquares do
			if(neighborSquares[j].terrainType == nullTerrain) then
				table.insert(plainsSquares, {neighborSquares[j].x, neighborSquares[j].y})
				terrainLayoutResult[neighborSquares[j].x][neighborSquares[j].y].terrainType = plainsTerrain
			end
		end
	end
	
	for i = 1, #plainsSquares do
		local neighborSquares = GetNeighbors(plainsSquares[i][1], plainsSquares[i][2], terrainLayoutResult)
		
		for j = 1, #neighborSquares do
			if(neighborSquares[j].terrainType == nullTerrain) then
				table.insert(gentleSquares, {neighborSquares[j].x, neighborSquares[j].y})
				terrainLayoutResult[neighborSquares[j].x][neighborSquares[j].y].terrainType = hillGentleTerrain
			end
		end
	end
	
	for i = 1, #gentleSquares do
		local neighborSquares = GetNeighbors(gentleSquares[i][1], gentleSquares[i][2], terrainLayoutResult)
		
		for j = 1, #neighborSquares do
			if(neighborSquares[j].terrainType == nullTerrain) then
				table.insert(lowSquares, {neighborSquares[j].x, neighborSquares[j].y})
				terrainLayoutResult[neighborSquares[j].x][neighborSquares[j].y].terrainType = hillLowTerrain
			end
		end
	end
	
	for i = 1, #lowSquares do
		local neighborSquares = GetNeighbors(lowSquares[i][1], lowSquares[i][2], terrainLayoutResult)
		
		for j = 1, #neighborSquares do
			if(neighborSquares[j].terrainType == nullTerrain) then
				table.insert(medSquares, {neighborSquares[j].x, neighborSquares[j].y})
				terrainLayoutResult[neighborSquares[j].x][neighborSquares[j].y].terrainType = hillMedTerrain
			end
		end
	end
	
	for i = 1, #medSquares do
		local neighborSquares = GetNeighbors(medSquares[i][1], medSquares[i][2], terrainLayoutResult)
		
		for j = 1, #neighborSquares do
			if(neighborSquares[j].terrainType == nullTerrain) then
				table.insert(highSquares, {neighborSquares[j].x, neighborSquares[j].y})
				terrainLayoutResult[neighborSquares[j].x][neighborSquares[j].y].terrainType = hillHighTerrain
			end
		end
	end
	
	-- select high squares for cliff
	local highCliffs = GetCliffSquares(highSquares, startLocationPositions, hillHighTerrain, cliffHighTerrain, maxCliffLength, minCliffHighDistance, minPlayerDistance, numHighCliffs)
	print("Num High Cliffs: " ..#highCliffs)
	for i = 1, #highCliffs do
		local row = highCliffs[i][1]
		local col = highCliffs[i][2]
		terrainLayoutResult[row][col].terrainType = cliffHighTerrain
	end
	
	-- select low squares for cliff
	local medCliffs = GetCliffSquares(lowSquares, startLocationPositions, hillLowTerrain, cliffMedTerrain, maxCliffLength, minCliffMedDistance, minPlayerDistance, numMedCliffs)
	print("Num High Cliffs: " ..#medCliffs)
	for i = 1, #medCliffs do
		local row = medCliffs[i][1]
		local col = medCliffs[i][2]
		terrainLayoutResult[row][col].terrainType = cliffMedTerrain
	end
	
	local allCliffs = {} -- table to hold positions of all previously placed cliffs
	
	-- insert the high cliffs
	for i = 1, #highCliffs do
		table.insert(allCliffs, highCliffs[i])		
	end
	
	-- insert the medium cliffs
	for i = 1, #medCliffs do
		table.insert(allCliffs, medCliffs[i])		
	end
	
	-- create a table to hold the squares to choose from for single cliffs
	local potentialSingleCliffSquares = {}
	
	for row = 1, gridSize - 1 do
		for col = 1, gridSize - 1 do
			if(row == 1 and col == 1) then
				-- do not select corner square
			elseif(row == gridSize and col == gridSize) then
				-- do not select corner square
			elseif(row == gridSize and col == 1) then
				-- do not select corner square
			elseif(row == 1 and col == gridSize) then
				-- do not select corner square
			else
				if(terrainLayoutResult[row][col].terrainType == nullTerrain) then
					table.insert(potentialSingleCliffSquares, {row, col})
				end
			end
		end
	end
	
	-- add single square cliffs in the high level terrain behind the main cliff placements (null terrain)
	local singleCliffs = {}
	singleCliffs = GetRandomCliffSquare(potentialSingleCliffSquares, startLocationPositions, nullTerrain, cliffSoaringTerrain, allCliffs, 2, 1, minPlayerDistance, 6)
	
	print("Num Single Cliffs: " ..#singleCliffs)
	
	for i = 1, #singleCliffs do
		local row = singleCliffs[i][1]
		local col = singleCliffs[i][2]
		terrainLayoutResult[row][col].terrainType = cliffSoaringTerrain	
	end
	
	-- find the high hills on the map edge and make them higher to balance blending with outside edge
	if(worldTerrainWidth > 416) then -- do not apply this to the micro map
		for row = 1, gridSize do
			for col = 1, gridSize do
				if(row == 1 or col == 1 or row == gridSize or col == gridSize) then
					if(terrainLayoutResult[row][col].terrainType == hillHighTerrain or terrainLayoutResult[row][col].terrainType == nullTerrain) then
						terrainLayoutResult[row][col].terrainType = hillHighEdgeTerrain
					end
				end
			end
		end
	end
	
	-- place settlement terrain
	settlementCheckTable = {{1,1}, {1, gridSize}, {gridSize, 1}, {gridSize, gridSize}}
	
	-- coordinate variables for the settlement squares
	local sRow01 = 0
	local sCol01 = 0
	local sRow02 = 0
	local sCol02 = 0
	
	-- coordinate variables for entry/exit squares of river
	local rRow01 = riverLine[1][1]
	local rCol01 = riverLine[1][2]
	local rRow02 = riverLine[#riverLine][1]
	local rCol02 = riverLine[#riverLine][2]
	
	local furthestDistance = 0
	local furthestIndex = 0
	
	-- do two passes through the potential settlement squares to get two swares as far from the river as possible
	for i = 1, #settlementCheckTable do		
		local cRow = settlementCheckTable[i][1]
		local cCol = settlementCheckTable[i][2]
		-- add the distance between the two river source squares and the potential settlement square
		local distance = GetDistance(cRow, cCol, rRow01, rCol01, 4) + GetDistance(cRow, cCol, rRow02, rCol02, 4)
		
		if(distance > furthestDistance) then
			sRow01 = cRow
			sCol01 = cCol
			furthestDistance = distance
			furthestIndex = i
		end
	end
	
	-- remove the square chosen from further consideration before running pass 2
	table.remove(settlementCheckTable, furthestIndex)
	
	-- reset distance variable
	furthestDistance = 0
	
	-- pass 2
	for i = 1, #settlementCheckTable do		
		local cRow = settlementCheckTable[i][1]
		local cCol = settlementCheckTable[i][2]
		-- add the distance between the two river source squares and the potential settlement square as well as the previously placed settlement square
		local distance = GetDistance(cRow, cCol, rRow01, rCol01, 4) + GetDistance(cRow, cCol, rRow02, rCol02, 4) + GetDistance(cRow, cCol, sRow01, sCol01, 4)
		
		if(distance > furthestDistance) then
			sRow02 = cRow
			sCol02 = cCol
			furthestDistance = distance
		end
	end
	
	terrainLayoutResult[sRow01][sCol01].terrainType = settlementTerrain
	terrainLayoutResult[sRow02][sCol02].terrainType = settlementTerrain
	
	-- place terrain for resource distribution
	terrainLayoutResult[mapMidPoint][mapMidPoint].terrainType = riverTerrainResources
end

print("END OF NOMADIC RIDGES LUA SCRIPT")