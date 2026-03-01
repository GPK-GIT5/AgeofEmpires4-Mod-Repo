-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING TURTLE")

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout
f = tt_flatland -- flatland will not be used in the map. This is just to set a square to "random"

h = tt_hills
m = tt_mountains
b = tt_hills_low_rolling
l = tt_plateau_low
p = tt_plains
i = tt_impasse_mountains
v = tt_valley

nomadStart = false
if (winConditionOptions.section_starting_conditions and winConditionOptions.section_starting_conditions.option_age_start) then
	nomadStart = (winConditionOptions.section_starting_conditions.option_age_start.enum_value == winConditionOptions.section_starting_conditions.option_age_start.enum_items.nomad_start)
	print("NOMAD START CONDITION IS: " ..winConditionOptions.section_starting_conditions.option_age_start.enum_value.." ("..tostring(nomadStart)..")")
else
	print("NOMAD START CONDITION IS NOT SET (FALSE)")
end

if(nomadStart) then
	playerStartTerrain = tt_player_start_nomad_plains -- nomad mode start
else
	playerStartTerrain = tt_player_start_classic_plains -- classic mode start	
end

--set up nomad resource pockets
nomadPocketResources1 = {}
nomadPocketResources2 = {}
nomadPocketResources3 = {}

--create groups of pocket resources that will equal out to balanced resources
--players will randomly get one set of these
pocketResourceList = {}
table.insert(pocketResourceList, nomadPocketResources1)
table.insert(pocketResourceList, nomadPocketResources2)
table.insert(pocketResourceList, nomadPocketResources3)

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

-- COARSE GRID SET UP
terrainLayoutResult = {}    -- set up initial table for coarse map grid

gridHeight, gridWidth, gridSize = SetCoarseGrid()

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

baseGridSize = 13

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)


-- place scattered mountains
percentMountains = 0.03
numMountains = math.floor(gridWidth * gridHeight * percentMountains)
rowCenter = math.ceil(gridWidth / 2)
colCenter = math.ceil(gridHeight / 2)
squaresForMountains = GetSquaresOfType(n, gridSize, terrainLayoutResult)
minMountainDistance = 2

print("There are " ..#squaresForMountains .." potential mountain squares to place " ..numMountains .." mountains.")
mountainSquares = {}
while(numMountains > 0 and #squaresForMountains > 0) do
	
	index = GetRandomIndex(squaresForMountains)
	square = squaresForMountains[index]
	x = square[1]
	y = square[2]
	print ("Checking square at row " .. x ..", column " ..y)
	if(#mountainSquares < 1)then
		
		if(IsCoordOnMapEdge(x, y, gridSize) == true) then
			table.remove(squaresForMountains, index)
			print("Not a valid square for placement. Continuing the search...")
		else			
			table.insert(mountainSquares, {x, y})
			table.remove(squaresForMountains, index)
			numMountains = numMountains - 1
			print("Valid square at row " ..x ..", column " ..y ..". Adding to mountains table.")
		end
		
	else
		if(IsCoordOnMapEdge(x, y, gridSize) == false and SquaresFarEnoughApart(x, y, minMountainDistance, mountainSquares, gridSize) == true) then
			table.insert(mountainSquares, {x, y})
			table.remove(squaresForMountains, index)
			numMountains = numMountains - 1
			print("Valid square at row " ..x ..", column " ..y ..". Adding to mountains table.")
		else
			table.remove(squaresForMountains, index)
			print("Not a valid square for placement. Continuing the search...")
		end
		
	end
	
	print("There are " ..#squaresForMountains .." potential squares left and " ..numMountains .. " left to place.")
end

print("placing " .. #mountainSquares .. " mountain squares")

for index = 1, #mountainSquares do
	x = mountainSquares[index][1]
	y = mountainSquares[index][2]
	print("Placing mountain at row " ..x ..", column " ..y)
	terrainLayoutResult[x][y].terrainType = i
end

-- PLACE PLAYER STARTS
teamMappingTable = CreateTeamMappingTable()
minTeamDistance = 6
minPlayerDistance = 3
edgeBuffer = 1
impasseTypes = {i}
openTypes = {n}
terrainLayoutResult = PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, impasseTypes, openTypes, playerStartTerrain, terrainLayoutResult)

-- start area terrain generation
--this should be TRUE to be correct
if (randomPositions == true) then
	-- create individual turtling areas for each player
	
	print("CREATE INDIVIDUAL TURTLE ZONES ------")
	-- how far from the player the mountain range must be
	if(worldTerrainWidth <= 513) then
		turtleSquareBuffer = 3
	elseif(worldTerrainWidth <= 769) then
		turtleSquareBuffer = 4
	else
		turtleSquareBuffer = 5
	end
	teamCenterPositions = {}
	teamSquares = {}
	
	--loop through each player
	for tIndex = 1, #teamMappingTable do
		for pIndex = 1, #teamMappingTable[tIndex].players do
			
			--for each player, grab the squares around them within the turtleSquareBuffer radius
			currentRow = teamMappingTable[tIndex].players[pIndex].startRow
			currentCol = teamMappingTable[tIndex].players[pIndex].startCol
			
			table.insert(teamCenterPositions, {currentRow, currentCol})
			
			-- set the terrain for the playable area inside the turtle zone and the line of terrain for the mountains
			turtleSquares = {} -- flat terrain for the players to build in
			barrierSquares = {} -- the ring of mountains around the turtle zone
			
			
			allSquares = GetSquaresOfTypes({n, p}, gridSize, terrainLayoutResult) -- create a table with all null squares in the map
		
			plainsSquares = {}
			mountainSquares = {}
			
			for sIndex = 1, #allSquares do
				
				row = allSquares[sIndex][1]
				col = allSquares[sIndex][2]
				
				if (SquaresCloseEnoughTogetherEuclidian(row, col, turtleSquareBuffer, {{currentRow, currentCol}}, gridSize)) then
					table.insert(turtleSquares, 1, {row, col})
				end
				
				if (SquaresCloseEnoughTogetherEuclidian(row, col, turtleSquareBuffer + 1, {{currentRow, currentCol}}, gridSize)) then
					table.insert(barrierSquares, 1, {row, col})
				end
				
			end
			
			print("For player " ..pIndex .." on team " .. tIndex .. ": # Turtle squares: " ..#turtleSquares .."  # Mountain squares: " ..#barrierSquares)
			
			
			--go through barrier squares and assign them to mountains
			impasseChance = 0.75
			for sIndex = 1, #barrierSquares do
				x = barrierSquares[sIndex][1]
				y = barrierSquares[sIndex][2]
				
				if(IsCoordOnMapEdge(x, y, gridSize)) then
					terrainLayoutResult[x][y].terrainType = p
				else
					if(worldGetRandom() < impasseChance) then
						terrainLayoutResult[x][y].terrainType = i
					else
						terrainLayoutResult[x][y].terrainType = m
					end
				end
				
			end
			
			
			--go through and assign turtle squares to flat terrain
			for sIndex = 1, #turtleSquares do
				x = turtleSquares[sIndex][1]
				y = turtleSquares[sIndex][2]
				terrainLayoutResult[x][y].terrainType = p
			end
			
		end
	end
	
	
else
	-- create turtling zone for each team
	print("CREATE TEAM TURTLE ZONE ------")
	
	-- how far from the outermost team member the mountain range must be
	if(worldTerrainWidth <= 513) then
		turtleSquareBuffer = 2
	elseif(worldTerrainWidth <= 769) then
		turtleSquareBuffer = 3
	else
		turtleSquareBuffer = 4
	end
	
	teamCenterPositions = {}
	teamSquares = {}
	maxPlayersOnOneTeam = 0
	-- loop through each team, get position (row and column) for all its members and find the average position (center point) and add it to a table
	for tIndex = 1, #teamMappingTable do -- loop through teams
		-- variables to hold sum of all player coordinates
		totalX = 0
		totalY = 0		
		playerCoords = {}
		
		if(#teamMappingTable[tIndex].players > maxPlayersOnOneTeam) then
			maxPlayersOnOneTeam = #teamMappingTable[tIndex].players
		end
		
		for pIndex = 1, #teamMappingTable[tIndex].players do -- loop through players
			-- add current player coordinates to sum
			x = teamMappingTable[tIndex].players[pIndex].startRow
			y = teamMappingTable[tIndex].players[pIndex].startCol
			print("Player " ..pIndex .." on team " ..tIndex .." is at row " ..x ..", col " ..y)
			totalX = totalX + x
			totalY = totalY + y
			table.insert(playerCoords, pIndex, {x, y})
			print("Player ID " ..teamMappingTable[tIndex].players[pIndex].playerID .." is at row " ..x ..", column " ..y)
		end
		
		table.insert(teamSquares, tIndex, playerCoords)
		
		-- calculate average position of all teammates (center position)
		averageX = math.ceil(totalX / #teamMappingTable[tIndex].players)
		averageY = math.ceil(totalY / #teamMappingTable[tIndex].players)
		print("Center of team " ..tIndex .." is at row " ..averageX ..", column " ..averageY)
		table.insert(teamCenterPositions, tIndex, {averageX, averageY})
	end
	
	if(maxPlayersOnOneTeam == 1) then
		turtleSquareBuffer = turtleSquareBuffer + 1
	end
	
	-- set the terrain for the playable area inside the turtle zone and the line of terrain for the mountains
	turtleSquares = {} -- flat terrain for the players to build in
	barrierSquares = {} -- the ring of mountains around the turtle zone
	
	print("PRINTING TEAM SQUARES")
	
	for teamSquareIndex = 1, #teamSquares do
		for teamSquarePlayerIndex = 1, #teamSquares[teamSquareIndex] do
			print("in team " .. teamSquareIndex .. "'s player index " .. teamSquarePlayerIndex .. " spot, row: " .. teamSquares[teamSquareIndex][teamSquarePlayerIndex][1] .. ", col: " .. teamSquares[teamSquareIndex][teamSquarePlayerIndex][2])
		end
	end
	
	for teamIndex = 1, #teamCenterPositions do
		centerRow = teamCenterPositions[teamIndex][1]
		centerCol = teamCenterPositions[teamIndex][2]
		print("centre row and col for team " .. teamIndex .. " is row: " .. centerRow .. ", col: " .. centerCol)
		-- get the radius for the zone
		farSquareRow, farSquareCol, farSquareIndex = GetFurthestSquare(centerRow, centerCol, teamSquares[teamIndex])
		print("For team " ..teamIndex ..": farSquareRow = " ..farSquareRow ..", farSquareCol = " ..farSquareCol .. " and the index of the far square was " .. farSquareIndex .. " which in the table is " .. teamSquares[teamIndex][farSquareIndex][1] .. ", " .. teamSquares[teamIndex][farSquareIndex][2])
		turtleRadius = math.ceil(math.sqrt((farSquareRow - centerRow)^2 + (farSquareCol - centerCol)^2), 0) + turtleSquareBuffer
		print("Turtle radius for team .." ..teamIndex .." is " ..turtleRadius)
		allSquares = GetSquaresOfTypes({n, p}, gridSize, terrainLayoutResult) -- create a table with all null squares in the map
		
		plainsSquares = {}
		mountainSquares = {}
		
		for sIndex = 1, #allSquares do
			
			row = allSquares[sIndex][1]
			col = allSquares[sIndex][2]
			
			if (SquaresCloseEnoughTogetherEuclidian(row, col, turtleRadius, {{centerRow, centerCol}}, gridSize)) then
				table.insert(plainsSquares, 1, {row, col})
			end
			
			if (SquaresCloseEnoughTogetherEuclidian(row, col, turtleRadius + 1, {{centerRow, centerCol}}, gridSize)) then
				table.insert(mountainSquares, 1, {row, col})
			end
			
		end
		
		print("For team " ..teamIndex ..": # Turtle squares: " ..#turtleSquares .."  # Mountain squares: " ..#mountainSquares)
		-- insert the squares tables into a larger table for each team for later iteration by team
		table.insert(turtleSquares, teamIndex, plainsSquares)
		table.insert(barrierSquares, teamIndex, mountainSquares)
	end
	impasseChance = 0.75
	print ("Number of turtle tables = " ..#turtleSquares)
	for tIndex = 1, #teamCenterPositions do
		
		print("Total Turtle Squares: " ..#turtleSquares[tIndex] .." Total Barrier Squares: " ..#barrierSquares[tIndex])
		for sIndex = 1, #barrierSquares[tIndex] do
			x = barrierSquares[tIndex][sIndex][1]
			y = barrierSquares[tIndex][sIndex][2]
			
			if(IsCoordOnMapEdge(x, y, gridSize)) then
				terrainLayoutResult[x][y].terrainType = p
			else
				if(worldGetRandom() < impasseChance) then
					terrainLayoutResult[x][y].terrainType = i
				else
					terrainLayoutResult[x][y].terrainType = m
				end
			end
			
		end
		
		for sIndex = 1, #turtleSquares[tIndex] do
			x = turtleSquares[tIndex][sIndex][1]
			y = turtleSquares[tIndex][sIndex][2]
			terrainLayoutResult[x][y].terrainType = p
		end
		
	end

			
end

-- draw line of flat terrain to center of map
centerRow = math.ceil(gridHeight / 2)
centerCol = math.ceil(gridWidth / 2)

for index = 1, #teamCenterPositions do
	teamRow = teamCenterPositions[index][1]
	teamCol = teamCenterPositions[index][2]
	lineSquares = {}
	lineSquares = DrawLineOfTerrainNoDiagonalReturn(teamRow, teamCol, centerRow, centerCol, false, f, gridSize, terrainLayoutResult)
	
	for lIndex = 1, #lineSquares do
		x = lineSquares[lIndex][1]
		y = lineSquares[lIndex][2]
		
		if(terrainLayoutResult[x][y].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[x][y].terrainType = p
		end
		
		lineNeighbors = GetNeighbors(x, y, terrainLayoutResult)
		
		for testNeighborIndex, testNeighbor in ipairs(lineNeighbors) do
			testNeighborRow = testNeighbor.x
			testNeighborCol = testNeighbor.y
			--if you find a mountain directly beside the line, replace it with hills to ensure passage to the centre of the map
			if(terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType == tt_impasse_mountains or terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType == tt_mountains) then
				terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_hills_med_rolling
			end
		end
	end
	
end

--ring the map with plains
for row = 1, gridSize do
	for col = 1, gridSize do
		--check if the current square is on the edge of the map
		if(row == 1 or row == gridSize or col == 1 or col == gridSize) then
			terrainLayoutResult[row][col].terrainType = tt_plains
		end
	end
end

--thin the mountain ridges
ThinTerrain(i, 1, {i}, tt_mountains, false, terrainLayoutResult)

ThinTerrain(i, 3, {i, m}, tt_tt_hills_gentle_rolling, true, terrainLayoutResult)


print("END OF TURTLE LUA SCRIPT")

