print("GENERATING OCEAN GATEWAY...")

--------------------------------------------------
--TERRAIN TYPES
--------------------------------------------------

-- variables containing terrain types to be used in map
noneTerrain = tt_none  -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

plainsTerrain = tt_plains
impasseTerrain = tt_mountains
oceanTerrain = tt_ocean_deep_gateway
deepFishTerrain = tt_ocean_deep_fish_gateway
shallowTerrain = tt_ocean_shore_fish_ocean_gateway
beachTerrain = tt_beach
settlementTerrain = tt_settlement_naval_ocean_gateway
sacredTerrain = tt_holy_site


playerStartTerrain = tt_player_start_plains_ocean_gateway

--------------------------------------------------
--TUNABLES
--------------------------------------------------

playerStartBuffer = 4
--startAngleOffset = 45 -- works for 2, 4, 6 player games use 5 for 7, 15 for 8
startAngleTable = {45, 45, 20, 45, 30, 15, 0, 15}

sacredEdgeBuffer = {[416] = 5, [512] = 5, [640] = 6, [768] = 7, [896] = 8} -- one entry per map size
sacredAngleAmount = {90, 90, 80, 45, 20, 30, 35, 25}
--sacredAngleAmount = 20


--------------------------------------------------
--FUNCTIONS
--------------------------------------------------

--- PLACE PLAYER STARTS
 -- places player positions in a regular circle to facilitate dividing the map between teams. Handles both random and teams together placement.
 -- randomPlacement is the passed in variable to check if the player has chosen random placement or teams together
 -- teamTable is the teamMappingTable created below
 -- numPlayers is the total number of players in thhe match
 -- size is the map size
 -- midPoint is the center of the coarse grid
 -- edgeBuffer is the rough distance from the map edge that will help define the radius of the player placement circle
 -- startTT is the player start terrain type
 -- terrain layout is the terrainLayoutResult table that stores terrain and player start info
function PlacePlayerStarts(randomPlacement, teamTable, numPlayers, size, midPoint, angleOffset, edgeBuffer, startTT, terrainLayout)	
	print("!!! PLACE PLAYER STARTS")
	-- place positions in a circle around the map
	local positions = {} -- holds the row and column of the start positions
	
	local radius = midPoint - edgeBuffer -- calculate the radius of the circle
	local increment = Round(360 / numPlayers, 0) -- calculate the angle increment based on thhe number of players	
	
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

--- PLACE SACRED SITES
function PlaceSacredSites(playerAngleOffset, sacredAngleOffset, numSites, size, midPoint, edgeBuffer, sacredTT, terrainLayout)
	-- place positions in a circle around the map
	local positions = {} -- holds the row and column of the start positions
	
	local radius = midPoint - edgeBuffer -- calculate the radius of the circle
	local increment = Round(360 / numSites, 0) -- calculate the angle increment based on thhe number of sacred sites	
	
	-- calculate row and column values for the circle of positions
	for index = 1, numSites do
		local angle = index * increment + playerAngleOffset + sacredAngleOffset
		local row = Round(radius * math.cos(angle * math.pi / 180), 0)
		local col = Round(radius * math.sin(angle * math.pi / 180), 0)
		
		row = row + midPoint
		col = col + midPoint
		
		table.insert(positions, {row, col})
	end
	
	for index = 1, #positions do
		local row = positions[index][1]
		local col = positions[index][2]
		
		terrainLayout[row][col].terrainType = sacredTT
	end
end

--- PLACE SACRED SITES COMPETITIVE
function PlaceSacredSitesCompetitive()
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
terrainLayoutResult = SetUpGrid(gridSize, noneTerrain, terrainLayoutResult)

-- OCEAN AND MOUNTAIN SETUP ---------------------------------------------------------------

-- place outer ocean and mountain ring
for row = 1, gridSize do
	for col = 1, gridSize do
		if(row == 2 or row == gridSize -1 or col == 2 or col == gridSize - 1) then
			if((row > mapMidPoint - 1 and row < mapMidPoint + 1) or (col > (mapMidPoint - 1) and col < (mapMidPoint + 1))) then
				terrainLayoutResult[row][col].terrainType = beachTerrain
			else
				terrainLayoutResult[row][col].terrainType = impasseTerrain
			end
		end
		
		if(row == 1 or row == gridSize or col == 1 or col == gridSize) then
			if(row == mapMidPoint or col == mapMidPoint) then
				terrainLayoutResult[row][col].terrainType = shallowTerrain
			else
				terrainLayoutResult[row][col].terrainType = oceanTerrain
			end
		end				
	end
end

-- place deep water fish terrain
farSquare = math.floor(4 / 416 * worldTerrainWidth)

terrainLayoutResult[1][mapMidPoint + 2].terrainType = deepFishTerrain
terrainLayoutResult[1][mapMidPoint - 2].terrainType = deepFishTerrain
terrainLayoutResult[1][mapMidPoint + farSquare].terrainType = deepFishTerrain
terrainLayoutResult[1][mapMidPoint - farSquare].terrainType = deepFishTerrain

terrainLayoutResult[gridSize][mapMidPoint + 2].terrainType = deepFishTerrain
terrainLayoutResult[gridSize][mapMidPoint - 2].terrainType = deepFishTerrain
terrainLayoutResult[gridSize][mapMidPoint + farSquare].terrainType = deepFishTerrain
terrainLayoutResult[gridSize][mapMidPoint - farSquare].terrainType = deepFishTerrain

terrainLayoutResult[mapMidPoint + 2][1].terrainType = deepFishTerrain
terrainLayoutResult[mapMidPoint - 2][1].terrainType = deepFishTerrain
terrainLayoutResult[mapMidPoint + farSquare][1].terrainType = deepFishTerrain
terrainLayoutResult[mapMidPoint - farSquare][1].terrainType = deepFishTerrain

terrainLayoutResult[mapMidPoint + 2][gridSize].terrainType = deepFishTerrain
terrainLayoutResult[mapMidPoint - 2][gridSize].terrainType = deepFishTerrain
terrainLayoutResult[mapMidPoint + farSquare][gridSize].terrainType = deepFishTerrain
terrainLayoutResult[mapMidPoint - farSquare][gridSize].terrainType = deepFishTerrain

-- place plains to connect mountain openings
for col = 1, gridSize do
	if(terrainLayoutResult[mapMidPoint][col].terrainType == noneTerrain) then
		terrainLayoutResult[mapMidPoint][col].terrainType = plainsTerrain
	end
end

for row = 1, gridSize do
	if(terrainLayoutResult[row][mapMidPoint].terrainType == noneTerrain) then
		terrainLayoutResult[row][mapMidPoint].terrainType = plainsTerrain
	end
end

-- PLAYER SETUP ---------------------------------------------------------------------------

if(worldTerrainWidth <= 513) then
	playerStartBuffer = 3
end
	
if(worldPlayerCount > 0) then
	teamMappingTable = CreateTeamMappingTable()
	PlacePlayerStarts(randomPositions, teamMappingTable, worldPlayerCount, gridSize, mapMidPoint, startAngleTable[worldPlayerCount], playerStartBuffer, playerStartTerrain, terrainLayoutResult)
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

-- place settlements
if(worldGetRandom() < 0.5) then
	terrainLayoutResult[1][1].terrainType = settlementTerrain
	terrainLayoutResult[gridSize][gridSize].terrainType = settlementTerrain
else
	terrainLayoutResult[1][gridSize].terrainType = settlementTerrain
	terrainLayoutResult[gridSize][1].terrainType = settlementTerrain
end

-- place sacred sites
sacredPositions = PlaceSacredSites(startAngleTable[worldPlayerCount], sacredAngleAmount[worldPlayerCount], 2, gridSize, mapMidPoint, 2, sacredTerrain, terrainLayoutResult)


print("END OF OCEAN GATEWAY LUA SCRIPT")
