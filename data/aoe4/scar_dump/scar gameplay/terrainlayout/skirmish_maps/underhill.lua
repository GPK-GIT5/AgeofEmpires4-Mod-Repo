-- Copyright 2024 SEGA Corporation, Developed by Relic Entertainment
terrainLayoutResult = {}    -- set up initial table for coarse map grid

--setting useful variables to reference world dimensions. 
gridHeight, gridWidth, gridSize = SetCoarseGrid()


if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map


-- setting up team table
teamsList, playersPerTeam = SetUpTeams()

--teamMappingTable[teamIndex].players[playerIndex].playerID
teamMappingTable = CreateTeamMappingTable()

--set the number of players. this info is grabbed from the lobby
playerStarts = worldPlayerCount

--BASIC MAP SETUP-------------------------------------------------------------------------------------------------
-- setting up the map grid



-- Setting scalable map variables
mapSizeModifier = 1
plainsDistance = 1
if(worldTerrainHeight  > 416) then
		gridSize = gridSize + 6

		mapSizeModifier = 1
	if(worldTerrainHeight  > 512) then
		gridSize = gridSize + 2
		
		mapSizeModifier = 2
	end
		
	if(worldTerrainHeight  > 640) then
		gridSize = gridSize 
		
		mapSizeModifier = 3
	end
		
	if(worldTerrainHeight  > 768) then
		gridSize = gridSize 
		
		mapSizeModifier = 4
	end
		
end 

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.floor(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

-- terrain type keys
baseForest = tt_forest_natural_small
centralGoldTerrain = tt_hills_wgold

-- dostance of players from the center
playerSpawnDistance = mapHalfSize - 2
if(worldTerrainHeight  > 512) then
	playerSpawnDistance = mapHalfSize - 3
end
-- This function is randomizing row and col variables across the playable area (no edges)
function RerollCoords()
	row = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
	col = math.ceil(worldGetRandom() * (gridSize -2) ) + 1	
end

-- Adding non fixed Hills layer
-- random hills
for iteration = 1, (mapQuarterSize*mapHalfSize) do
	row = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
	col = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
	
	terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
end

-- random small mountains
for iteration = 1, (mapQuarterSize*mapHalfSize) do
	row = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
	col = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
	
	terrainLayoutResult[row][col].terrainType = tt_mountains_small
end

-- random mountains surrounded by hills
for iteration = 1, (mapHalfSize*mapHalfSize) do
	row = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
	col = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
	
	terrainLayoutResult[row][col].terrainType = tt_mountains
			
	randomCliffRow = math.ceil(worldGetRandom() * 3) - 2 
	randomCliffCol = math.ceil(worldGetRandom() * 3) - 2 
	terrainLayoutResult[row + randomCliffRow][col + randomCliffCol].terrainType = baseForest
	if (worldGetRandom() > 0.5 ) then
		terrainLayoutResult[row - randomCliffRow][col].terrainType = tt_hills_low_rolling
		if (worldGetRandom() > 0.4 ) then
			terrainLayoutResult[row][col].terrainType = tt_underhill_mountains
		else
			terrainLayoutResult[row][col].terrainType = tt_plateau_low
		end
	else
		terrainLayoutResult[row][col - randomCliffCol].terrainType = tt_hills_low_rolling
		if (worldGetRandom() > 0.4 ) then
			terrainLayoutResult[row][col].terrainType = tt_underhill_mountains
		else
			terrainLayoutResult[row][col].terrainType = tt_plateau_low
		end
	end
		
	-- chance for more hills around the mountain / cliff
	if worldGetRandom() > 0.6 then
		terrainLayoutResult[row - randomCliffRow][col - randomCliffRow].terrainType = tt_hills_gentle_rolling
	end
	if worldGetRandom() > 0.6 then
		terrainLayoutResult[row + randomCliffRow][col + randomCliffRow].terrainType = tt_hills_gentle_rolling
	end
end

-- random forests for smaller maps 
for iteration = 1, (worldTerrainHeight / 32) do
	-- finding a spawn location
	row = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
	col = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
	
	-- ensuring we can't spawn on already designated terrain types
	while terrainLayoutResult[row][col].terrainType == tt_hills_low_rolling
		or terrainLayoutResult[row][col].terrainType == tt_mountains
		or terrainLayoutResult[row][col].terrainType == baseForest 
		or terrainLayoutResult[row][col].terrainType == tt_mountains_small
		or terrainLayoutResult[row][col].terrainType == tt_hills_gentle_rolling
	do 
		RerollCoords() 
	end
	
	
	randomCliffRow = math.ceil(worldGetRandom() * 3) - 2 
	randomCliffCol = math.ceil(worldGetRandom() * 3) - 2 
	terrainLayoutResult[row + randomCliffRow][col + randomCliffCol].terrainType = baseForest
end
	
-- adding flat flank
for row = 1, gridSize do
	for col = 1, gridSize do
		-- Adding plains across stealth.
		
		if  row <= (mapSizeModifier+1) or row >= gridSize - mapSizeModifier   
			or col <= (mapSizeModifier+1) or col >= gridSize - mapSizeModifier  then
			
			terrainLayoutResult[row][col].terrainType = tt_plains
		end
		-- adding stealth
		if col == 0 + mapSizeModifier or col == gridSize+1 - mapSizeModifier 
			or row == 0 + mapSizeModifier or row == gridSize+1 - mapSizeModifier then
			
			terrainLayoutResult[row][col].terrainType = tt_plains
		end
	end
end

-- Add sacred sites
if (worldGetRandom() > 0.5 ) then
	terrainLayoutResult[gridSize - 1][2].terrainType = tt_holy_site
	terrainLayoutResult[2][gridSize - 1].terrainType = tt_holy_site
else
	terrainLayoutResult[2][2].terrainType = tt_holy_site
	terrainLayoutResult[gridSize - 1][gridSize - 1].terrainType = tt_holy_site
end

-- Central area (cleariing path between factions
for row = mapHalfSize-mapSizeModifier-1, mapHalfSize+mapSizeModifier+1 do
	for col = mapHalfSize - mapSizeModifier-1, mapHalfSize + mapSizeModifier + 1 do
		terrainLayoutResult[row][col].terrainType = tt_plains_clearing
	end
end

-- central gold
if(worldPlayerCount <=2) then
	--centralGoldTerrain = tt_gold_small
end
terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = centralGoldTerrain

-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------


	
-- assigning ffa / non ffa terrain to each player
playerStartTerrain = tt_underhill_player_start

--Making this number larger will give more space between every player, even those on the same team.
minPlayerDistance = 3.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.

if(#teamMappingTable  == 2) then
	minTeamDistance = 10.5
else
	minTeamDistance = 6.5
end

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = 2

--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
--setting this to 0.4 will mean that the middle 40% of squares will not be eligable for spawning (so imagine the centre point, and 20% of the map size in all directions)
if(#teamMappingTable  == 2) then
	innerExclusion = 0.6
else
	innerExclusion = 0.3
end


--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 1


--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. It will ensure that players are not placed on or
--adjacent to squares in this list
impasseTypes = {}
table.insert(impasseTypes, tt_holy_site)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 4.5 + mapSizeModifier

-- adjusting vars for FFA
if(#teamMappingTable > 6) then
	innerExclusion = 0.1
	minTeamDistance = 3.5
	impasseDistance = 2.5
	table.insert(impasseTypes, centralGoldTerrain)
elseif (#teamMappingTable > 4) then
	innerExclusion = 0.2
	minTeamDistance = 4.5
	impasseDistance = 3.5
	table.insert(impasseTypes, centralGoldTerrain)
end

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_hills_gentle_rolling

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 3

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = true
	
terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)


function AddBackMarkets()
	-- Getting players starting locations and spawning woodlines behind them when using generic start terrain
	
	startLocationPositions = {}
	for row = 1, gridSize do
		for col = 1, gridSize do
			currentData = {}
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				currentData = { x = row, y = col}
				table.insert(startLocationPositions, currentData)
				print("Chosen start location - Row: " .. row .. " Col " .. col)
				
				-- adding markets behind the players
				if(col > mapHalfSize + 3 ) then
					terrainLayoutResult[row][gridSize].terrainType = tt_settlement_plains
				elseif(row > mapHalfSize + 3) then
					terrainLayoutResult[gridSize][col].terrainType = tt_settlement_plains
				elseif(col < mapHalfSize- 3) then
					terrainLayoutResult[row][1].terrainType = tt_settlement_plains
				elseif(row < mapHalfSize - 3) then
					terrainLayoutResult[1][col].terrainType = tt_settlement_plains
				end
			end
		end
	end
	
end

AddBackMarkets()
