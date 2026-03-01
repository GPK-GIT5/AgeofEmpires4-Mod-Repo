
print("GENERATING NOMADIC TARNS...")

--------------------------------------------------
--TERRAIN TYPES
--------------------------------------------------

-- variables containing terrain types to be used in map
nullTerrain = tt_none  -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

plainsTerrain = tt_plains
mountainTerrain = tt_mountains
tarnMountainTerrain = tt_mountain_tall_nomadic_tarns
tarnMountainResourcesTerrain = tt_mountain_tall_resources_nomadic_tarns
tarnMountainExtraResourcesTerrain = tt_mountain_tall_extra_resources_nomadic_tarns
plainsResourceTerrain = tt_plains_resources_nomadic_tarns
tarnTerrain = tt_lake_medium_nomadic_tarns
tarnShallowTerrain = tt_lake_shallow_nomadic_tarns
tradeTerrain = tt_settlement_plains
sacredTerrain = tt_holy_site_nomadic_tarns

classicStartTerrain = tt_player_start_classic_plains_nomadic_tarns -- classic mode start
nomadStartTerrain = tt_plains_player_start_nomad_nomadic_tarns -- nomad mode start
playerStartTerrain = tt_none -- set this to the appropriate terrain for nomad vs classic mode

--------------------------------------------------
--TUNABLES
--------------------------------------------------

playerStartBuffer = 2
numCentralTarns = 4

--------------------------------------------------
--FUNCTIONS
--------------------------------------------------

--- PLACE TERRAIN IN CIRCLE
 -- places terrain, including player positions, in a regular circle to facilitate dividing the map between teams. Handles both random and teams together placement.
 -- randomPlacement is if the player has chosen random placement or teams together
 -- teamTable is the teamMappingTable created below
 -- numPlayers is the total number of players in thhe match
 -- size is the map size
 -- midPoint is the center of the coarse grid
 -- angleOffset is added to the starting angle (set to zero for consistent player placement or randomize to make the first placement inconsistent)
 -- edgeBuffer is the rough distance from the map edge that will help define the radius of the player placement circle
 -- adjustMountains is a bool which, if true, nudges the mountain positions so they are not in a perfect circle
 -- mountainTerrain is the terrain type for the mountains
 -- plainsTerrain is the plains terrain between mountains and player starts
 -- playerTerrain is the player start terrain type
 -- terrain layout is the terrainLayoutResult table that stores terrain and player start info
function PlaceTerrainInCircle(randomPlacement, teamTable, numPlayers, size, midPoint, angleOffset, edgeBuffer, adjustMountains, mountainTerrain, plainsTerrain, playerTerrain, terrainLayout)
	local positions = {} -- holds the row and column of the start positions
	
	local radius = midPoint - edgeBuffer -- calculate the radius of the circle
	local numIncrements = 0
	local count = 0
	
	if(numPlayers <= 4)then
		numIncrements = numPlayers * 3
		count = 2
	else
		numIncrements = numPlayers * 2
		count = 1
	end
	
	local increment = Round(360 / numIncrements, 0) -- calculate the angle increment for number of players plus resource slots placements
	
	
	-- calculate row and column values for the circle of positions
	for index = 1, numIncrements do
		local angle = index * increment + angleOffset
		row = Round(radius * math.cos(angle * math.pi / 180), 0)
		col = Round(radius * math.sin(angle * math.pi / 180), 0)
		row = row + midPoint
		col = col + midPoint
		
		table.insert(positions, {row, col})
	end

	local currentCount = 0
	local playerPositions = {}
	local mountainPositions = {}
	
	-- place terrain
	for index = 1, numIncrements do
		if(currentCount == 0) then
			terrainLayout[positions[index][1]][positions[index][2]].terrainType = playerTerrain
			table.insert(playerPositions, {positions[index][1], positions[index][2]})			
		elseif(currentCount > 0 and currentCount < 2) then
			if(adjustMountains == false) then -- place the terrain now if we are not adjusting mountain position
				terrainLayout[positions[index][1]][positions[index][2]].terrainType = mountainTerrain
			end
			
			table.insert(mountainPositions, {positions[index][1], positions[index][2]})
		else
			terrainLayout[positions[index][1]][positions[index][2]].terrainType = plainsTerrain
		end
		
		currentCount = currentCount + 1
		
		if (currentCount > count) then
			currentCount = 0
		end
	end
	
	-- adjust mountain positions so they are not always in a perfect circle
	if(adjustMountains == true) then
		for mIndex = 1, #mountainPositions do
			local row = mountainPositions[mIndex][1]
			local col = mountainPositions[mIndex][2]
			
			local neighbors = GetNeighbors(row, col, terrainLayout)
			
			for nIndex = #neighbors, 1, -1 do
				local nRow = neighbors[nIndex].x
				local nCol = neighbors[nIndex].y
				if(terrainLayout[nRow][nCol].terrainType == playerTerrain) then
					table.remove(neighbors, nIndex)
				end								
			end
			
			if(worldGetRandom() < 0.5) then -- only adjust roughly half the mountains
				local newSquareIndex = GetRandomIndex(neighbors)
				local newRow = neighbors[newSquareIndex].x
				local newCol = neighbors[newSquareIndex].y
				
				terrainLayout[newRow][newCol].terrainType = mountainTerrain -- place mountain in new location
				mountainPositions[mIndex] = {newRow, newCol} -- set new location in positions table
			else
				terrainLayout[mountainPositions[mIndex][1]][mountainPositions[mIndex][2]].terrainType = mountainTerrain -- place mountain in original positions
			end			
		end
	end
	
	-- assign players to player start terrain
	if(randomPlacement == true) then -- assign players to locations randomly
		for tIndex = 1, #teamTable do
			for pIndex = 1, #teamTable[tIndex].players do
				print("Team Index: " ..tIndex .." Player Index: " ..pIndex)
				posIndex = GetRandomIndex(playerPositions)
				--terrainLayout[playerPositions[posIndex][1]][playerPositions[posIndex][2]].terrainType = startTT
				terrainLayout[playerPositions[posIndex][1]][playerPositions[posIndex][2]].playerIndex = teamTable[tIndex].players[pIndex].playerID - 1
				table.remove(playerPositions, posIndex)
			end
		end
	else -- assign players grouped together with their team
		local posIndex = 1
		
		for tIndex = 1, #teamTable do
			for pIndex = 1, #teamTable[tIndex].players do
				print("Team Index: " ..tIndex .." Player Index: " ..pIndex)
				--terrainLayout[playerPositions[posIndex][1]][playerPositions[posIndex][2]].terrainType = startTT
				terrainLayout[playerPositions[posIndex][1]][playerPositions[posIndex][2]].playerIndex = teamTable[tIndex].players[pIndex].playerID - 1
				print("Team " ..teamTable[tIndex].teamID ..", Player " ..teamTable[tIndex].players[pIndex].playerID - 1 ..", Row " ..playerPositions[posIndex][1] ..", Col " ..playerPositions[posIndex][2])
				posIndex = posIndex + 1
			end
		end
	end
	
	return mountainPositions
end

function GetDistanceFromPlayers(targetRow, targetCol, playerStartsTable)
	
	local distance = 0
	
	for pIndex = 1, #playerStartsTable do
		local row = playerStartsTable[pIndex][1]
		local col = playerStartsTable[pIndex][2]
		local playerDistance = Round(math.sqrt((targetRow - row)^2 + (targetCol - col)^2), 4)
		distance = distance + playerDistance
	end
	
	print("Distance from Players: " ..distance)
	return distance
	
end

function PlaceSacredSites(numSites, size, midPoint, angleOffset, edgeBuffer, sacredTerrain, terrainLayout)
	local positions = {} -- holds the row and column of the start positions
	
	local radius = midPoint - edgeBuffer -- calculate the radius of the circle
	local count = 0
	
	local increment = Round(360 / numSites, 0) -- calculate the angle increment for number of sites
	
	
	-- calculate row and column values for the circle of positions
	for index = 1, numSites do
		local angle = index * increment + angleOffset
		row = Round(radius * math.cos(angle * math.pi / 180), 0)
		col = Round(radius * math.sin(angle * math.pi / 180), 0)
		row = row + midPoint
		col = col + midPoint
		
		table.insert(positions, {row, col})
	end
	
	return positions
end

--- TARN HAS NEIGHBOR
 -- returns true if the tarn square being checked has any type of tarn terrain in the tarnTT table for a neihgbor
function TarnHasNeighbor(checkRow, checkCol, tarnTT, terrainLayout)
	local neighbors = GetNeighbors(checkRow, checkCol, terrainLayout)
	
	for index = 1, #neighbors do
		local row = neighbors[index].x
		local col = neighbors[index].y
		
		for tIndex = 1, #tarnTT do
			if(terrainLayout[row][col].terrainType == tarnTT[tIndex])then
				return true
			end
		end
	end
	
	return false
end

--------------------------------------------------
--MAIN MAP SCRIPT
--------------------------------------------------

-- check to see if nomad start is active and set bool accordignly
nomadStart = false -- initialize bool as false
if (winCondition == "nomad") then
	nomadStart = true
	print("NOMAD START CONDITION IS: " ..winCondition)
	playerStartTerrain = nomadStartTerrain
else
	print("NOMAD START CONDITION IS NOT SET (FALSE)")
	playerStartTerrain = classicStartTerrain
end

print("Nomad Mode is " ..tostring(nomadStart))
print("Random Positions = " ..tostring(randomPositions))


-- MAP/GAME SET UP ------------------------------------------------------------------------
gridHeight, gridWidth, gridSize = SetCoarseGrid() -- sets the coarse dimensions using the function found in map_setup lua file in the library folder
mapMidPoint = math.ceil(gridSize / 2)

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid for terrain types and other data using default function found in map_setup lua in library folder
terrainLayoutResult = {} -- the grid for all terrain data (must use this name)
terrainLayoutResult = SetUpGrid(gridSize, nullTerrain, terrainLayoutResult)


-- PLAYER SETUP ---------------------------------------------------------------------------
mountainPositions = {} -- table to hold the positions of the mountains

resourceTerrain = tarnMountainResourcesTerrain -- terrain to place at the center of the map

if(worldTerrainWidth <= 417) then
	if (worldPlayerCount <= 1) then
		print("Placing extra Resources!!!")
		resourceTerrain = tarnMountainExtraResourcesTerrain
	end
elseif(worldTerrainWidth <= 513) then
	if (worldPlayerCount <= 2) then
		print("Placing extra Resources!!!")
		resourceTerrain = tarnMountainExtraResourcesTerrain
	end
elseif(worldTerrainWidth <= 641) then
	if (worldPlayerCount <= 4) then
		print("Placing extra Resources!!!")
		resourceTerrain = tarnMountainExtraResourcesTerrain
	end
else
	if (worldPlayerCount <= 6) then
		print("Placing extra Resources!!!")
		resourceTerrain = tarnMountainExtraResourcesTerrain
	end	
end

if(worldPlayerCount > 0) then -- ensure there is at least one player before setting player starts
	teamMappingTable = CreateTeamMappingTable()
	
	startAngleOffset = Round(GetRandomInRange(0, 4), 0) * 15 -- will add a random rotation to the player starts

	mountainPositions = PlaceTerrainInCircle(randomPositions, teamMappingTable, worldPlayerCount, gridSize, mapMidPoint, startAngleOffset, playerStartBuffer, true, tarnMountainTerrain, plainsTerrain, playerStartTerrain, terrainLayoutResult)
end

startLocationPositions = {} -- initialize table to hold start positions

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

-- Place Tarn Terrain
startIncrement = Round(360 / worldPlayerCount, 0) -- calculate the angle increment based on the number of players
mountainOffset = startAngleOffset + Round(startIncrement / 2, 0) -- adjust the mountain to be inbetween the player starts

tarnPositions = {}

for index = 1, #mountainPositions do
	local mRow = mountainPositions[index][1]
	local mCol = mountainPositions[index][2]
	
	local neighbors = Get8Neighbors(mRow, mCol, terrainLayoutResult)
	local formattedNeighbors = {}
	
	for nIndex = 1, #neighbors do
		local fRow = neighbors[nIndex].x
		local fCol = neighbors[nIndex].y
		table.insert(formattedNeighbors, {fRow, fCol})
	end

	local tRow, tCol, tIndex = GetClosestSquare(mapMidPoint, mapMidPoint, formattedNeighbors)
	table.insert(tarnPositions, {tRow, tCol})

end

for index = 1, #tarnPositions do
	local tRow = tarnPositions[index][1]
	local tCol = tarnPositions[index][2]
	
	terrainLayoutResult[tRow][tCol].terrainType = tarnTerrain
end

-- place central mountain and tarns (this mountain contains the local distribution that places resources)
terrainLayoutResult[mapMidPoint][mapMidPoint].terrainType = resourceTerrain

--centralNeighbors = Get8Neighbors(mapMidPoint, mapMidPoint, terrainLayoutResult)

-- randomly determine if tarns will be placed north/south or east/west
if(worldGetRandom() < 0.5) then
	-- place tarns north/south
	local rowTop = mapMidPoint - 1
	local rowBottom = mapMidPoint + 1
	
	terrainLayoutResult[rowTop][mapMidPoint].terrainType = tarnTerrain
	terrainLayoutResult[rowBottom][mapMidPoint].terrainType = tarnTerrain
	
	local colLeft = mapMidPoint - 1
	local colRight = mapMidPoint + 1
	
	-- add additional tarn squares to make each tarn 2 squares (randomly offset in one direction or its opposite)
	if(worldGetRandom() < 0.5) then
		-- left of top square right of bottom
		terrainLayoutResult[rowTop][colLeft].terrainType = tarnShallowTerrain
		terrainLayoutResult[rowBottom][colRight].terrainType = tarnShallowTerrain
	else
		-- right of top square left of bottom
		terrainLayoutResult[rowTop][colRight].terrainType = tarnShallowTerrain
		terrainLayoutResult[rowBottom][colLeft].terrainType = tarnShallowTerrain
	end
else
	-- place tarns east/west
	local colLeft = mapMidPoint - 1
	local colRight = mapMidPoint + 1
	
	terrainLayoutResult[mapMidPoint][colLeft].terrainType = tarnTerrain
	terrainLayoutResult[mapMidPoint][colRight].terrainType = tarnTerrain
	
	local rowTop = mapMidPoint - 1
	local rowBottom = mapMidPoint + 1
	
	-- add additional tarn squares to make each tarn 2 squares (randomly offset in one direction or its opposite)
	if(worldGetRandom() < 0.5) then
		-- left of top square right of bottom
		terrainLayoutResult[rowTop][colLeft].terrainType = tarnShallowTerrain
		terrainLayoutResult[rowBottom][colRight].terrainType = tarnShallowTerrain
	else
		-- right of top square left of bottom
		terrainLayoutResult[rowBottom][colLeft].terrainType = tarnShallowTerrain
		terrainLayoutResult[rowTop][colRight].terrainType = tarnShallowTerrain
	end
end

--[[
for index = 1, numCentralTarns do
	local nIndex = GetRandomIndex(centralNeighbors)
	
	local row = centralNeighbors[nIndex].x
	local col = centralNeighbors[nIndex].y
	
	if(TarnHasNeighbor(row, col, {tarnTerrain, tarnShallowTerrain}, terrainLayoutResult) == true) then
		print("HAS NEIGHBOR")
		terrainLayoutResult[row][col].terrainType = tarnShallowTerrain
	else
		print("NO NEIGHBOR")
		terrainLayoutResult[row][col].terrainType = tarnTerrain
	end
	
	table.remove(centralNeighbors, nIndex)
end
]]

-- place neutral settlements
cornerSquare01 = {1,1}
cornerSquare02 = {gridSize, gridSize}
cornerSquare03 = {1, gridSize}
cornerSquare04 = {gridSize, 1}

playerDistance01 = GetDistanceFromPlayers(cornerSquare01[1], cornerSquare01[2], startLocationPositions)
playerDistance02 = GetDistanceFromPlayers(cornerSquare02[1], cornerSquare02[2], startLocationPositions)
playerDistance03 = GetDistanceFromPlayers(cornerSquare03[1], cornerSquare03[2], startLocationPositions)
playerDistance04 = GetDistanceFromPlayers(cornerSquare04[1], cornerSquare04[2], startLocationPositions)

if(playerDistance01 + playerDistance02 > playerDistance03 + playerDistance04) then
	terrainLayoutResult[cornerSquare01[1]][cornerSquare01[2]].terrainType = tradeTerrain
	terrainLayoutResult[cornerSquare02[1]][cornerSquare02[2]].terrainType = tradeTerrain
elseif(playerDistance01 + playerDistance02 < playerDistance03 + playerDistance04) then
	terrainLayoutResult[cornerSquare03[1]][cornerSquare03[2]].terrainType = tradeTerrain
	terrainLayoutResult[cornerSquare04[1]][cornerSquare04[2]].terrainType = tradeTerrain
elseif(worldGetRandom() < 0.5) then
	terrainLayoutResult[cornerSquare01[1]][cornerSquare01[2]].terrainType = tradeTerrain
	terrainLayoutResult[cornerSquare02[1]][cornerSquare02[2]].terrainType = tradeTerrain
else
	terrainLayoutResult[cornerSquare03[1]][cornerSquare03[2]].terrainType = tradeTerrain
	terrainLayoutResult[cornerSquare04[1]][cornerSquare04[2]].terrainType = tradeTerrain
end

-- place sacred sites
offsetAngle = Round(GetRandomInRange(0, 4), 0) * 15 -- will add a random rotation to the sacred sites
offsetAngle = mountainOffset + 10
sacredBuffer = playerStartBuffer + 3

if(worldTerrainWidth > 640) then
	sacredBuffer = sacredBuffer + 1 -- scale for map size
end

sacredPositions = PlaceSacredSites(3, gridSize, mapMidPoint, offsetAngle, sacredBuffer, sacredTerrain, terrainLayoutResult)

for i = 1, #sacredPositions do
	local row = sacredPositions[i][1]
	local col = sacredPositions[i][2]
	
	terrainLayoutResult[row][col].terrainType = sacredTerrain
end


print("END OF CRATERS LUA SCRIPT")
