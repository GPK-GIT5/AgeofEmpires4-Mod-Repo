-- Copyright 2024 World's Edge___ TBD
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
stealthWidth = 2
plainsDistance = 1
if(worldTerrainHeight  > 416) then
		gridSize = gridSize + 4

		stealthWidth = 2
	if(worldTerrainHeight  > 512) then
		gridSize = gridSize + 2
		
		stealthWidth = 3
	end
		
	if(worldTerrainHeight  > 640) then
		gridSize = gridSize + 2
		
		stealthWidth = 4
	end
		
	if(worldTerrainHeight  > 768) then
		gridSize = gridSize + 2
		
		stealthWidth = 5
	end
		
end 

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

baseGridSize = 13
mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.floor(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

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

-- Adding non fixed Hills and Mountains on larger maps
if(#teamMappingTable  ~= 2 or #teamMappingTable[1].players ~= #teamMappingTable[2].players) then
	-- FFA SETUP
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
		terrainLayoutResult[row + randomCliffRow][col + randomCliffCol].terrainType = tt_forest_natural_small
		if (worldGetRandom() > 0.5 ) then
			terrainLayoutResult[row - randomCliffRow][col].terrainType = tt_hills_low_rolling
			terrainLayoutResult[row][col].terrainType = tt_plateau_low
		else
			terrainLayoutResult[row][col - randomCliffRow].terrainType = tt_hills_low_rolling
			terrainLayoutResult[row][col].terrainType = tt_plateau_low
		end
			
		-- chance for more hills
		if worldGetRandom() > 0.5 then
			terrainLayoutResult[row - randomCliffRow][col - randomCliffRow].terrainType = tt_hills_low_rolling
		end
	end
	-- Side sites
	terrainLayoutResult[mapHalfSize][mapHalfSize + 2].terrainType = tt_holy_site_hill
	terrainLayoutResult[mapHalfSize][mapHalfSize - 2].terrainType = tt_holy_site_hill
	terrainLayoutResult[mapHalfSize + 2][mapHalfSize].terrainType = tt_holy_site_hill
	terrainLayoutResult[mapHalfSize - 2][mapHalfSize].terrainType = tt_holy_site_hill
	
-- random forests for smaller maps 
	for iteration = 1, (worldTerrainHeight / 32) do
		-- finding a spawn location
		row = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
		col = math.ceil(worldGetRandom() * (gridSize -2) ) + 1
		
		-- ensuring we can't spawn on already designated terrain types
		while terrainLayoutResult[row][col].terrainType == tt_hills_low_rolling
			or terrainLayoutResult[row][col].terrainType == tt_mountains_low
			or terrainLayoutResult[row][col].terrainType == tt_forest_natural_small
		do 
			RerollCoords() 
		end
		
		
		randomCliffRow = math.ceil(worldGetRandom() * 3) - 2 
		randomCliffCol = math.ceil(worldGetRandom() * 3) - 2 
		terrainLayoutResult[row + randomCliffRow][col + randomCliffCol].terrainType = tt_forest_natural_small
	end
		
	-- adding stealth flanks FFA
	stealthWidth = 1
	for row = 1, gridSize do
		for col = 1, gridSize do
			-- Adding plains across stealth.
			
			if  row <= (stealthWidth+1) or row >= gridSize - stealthWidth   
				or col <= (stealthWidth+1) or col >= gridSize - stealthWidth  then
				
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
			-- adding stealth
			if col == 0 + stealthWidth or col == gridSize+1 - stealthWidth 
				or row == 0 + stealthWidth or row == gridSize+1 - stealthWidth then
				
				terrainLayoutResult[row][col].terrainType = tt_sacred_mountains_stealth_circular_large
			end
			
		end
	end
	
		else 
	-- NON FFA SETUP (Team VS Team)
	-- Side Resources
	--1
	terrainLayoutResult[mapHalfSize][gridSize - stealthWidth - 2].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize+1][gridSize - stealthWidth - 2].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize-1][gridSize - stealthWidth - 2].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize+1][gridSize - stealthWidth - 1].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize-1][gridSize - stealthWidth - 1].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize + 2][gridSize - stealthWidth - 2].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize - 2][gridSize - stealthWidth - 2].terrainType = tt_hills_low_rolling_clear
	--[[ gold and stone plateau
	if worldGetRandom() > 0.5 then
		terrainLayoutResult[mapHalfSize + 2][gridSize - stealthWidth - 1].terrainType = tt_sacred_mountains_gold_plateau_med
		terrainLayoutResult[mapHalfSize - 2][gridSize - stealthWidth - 1].terrainType = tt_sacred_mountains_stone_plateau_med
		else
		terrainLayoutResult[mapHalfSize + 2][gridSize - stealthWidth - 1].terrainType = tt_sacred_mountains_stone_plateau_med
		terrainLayoutResult[mapHalfSize - 2][gridSize - stealthWidth - 1].terrainType = tt_sacred_mountains_gold_plateau_med
	end
	--]]
	--2
	terrainLayoutResult[mapHalfSize][3 + stealthWidth].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize+1][3 + stealthWidth].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize-1][3 + stealthWidth].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize - 1][2 + stealthWidth].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize + 1][2 + stealthWidth].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize + 2][3 + stealthWidth].terrainType = tt_hills_low_rolling_clear
	terrainLayoutResult[mapHalfSize - 2][3 + stealthWidth].terrainType = tt_hills_low_rolling_clear
	
	-- adding gold stone in corner of the plateaus
	if worldGetRandom() > 0.5 then
		-- east
		terrainLayoutResult[mapHalfSize + 2][gridSize - stealthWidth - 1].terrainType = tt_sacred_mountains_gold_plateau_med
		terrainLayoutResult[mapHalfSize - 2][gridSize - stealthWidth - 1].terrainType = tt_sacred_mountains_stone_plateau_med
		-- west
		terrainLayoutResult[mapHalfSize - 2][2 + stealthWidth].terrainType = tt_sacred_mountains_gold_plateau_med
		terrainLayoutResult[mapHalfSize + 2][2 + stealthWidth].terrainType = tt_sacred_mountains_stone_plateau_med
		else
		-- east
		terrainLayoutResult[mapHalfSize + 2][gridSize - stealthWidth - 1].terrainType = tt_sacred_mountains_stone_plateau_med
		terrainLayoutResult[mapHalfSize - 2][gridSize - stealthWidth - 1].terrainType = tt_sacred_mountains_gold_plateau_med
		-- west
		terrainLayoutResult[mapHalfSize - 2][2 + stealthWidth].terrainType = tt_sacred_mountains_stone_plateau_med
		terrainLayoutResult[mapHalfSize + 2][2 + stealthWidth].terrainType = tt_sacred_mountains_gold_plateau_med
	end
	-- wood beneath cliff
	terrainLayoutResult[2][gridSize - stealthWidth - 2].terrainType = tt_forest_natural_medium
	terrainLayoutResult[gridSize - 1][gridSize - stealthWidth - 2].terrainType = tt_forest_natural_medium
	terrainLayoutResult[2][3 + stealthWidth].terrainType = tt_forest_natural_medium
	terrainLayoutResult[gridSize - 1][3 + stealthWidth].terrainType = tt_forest_natural_medium
			
	-- Sacred Sites 
	--1
	terrainLayoutResult[mapHalfSize][gridSize - stealthWidth - 1].terrainType = tt_holy_site_plateau_med
	--2
	terrainLayoutResult[mapHalfSize][2 + stealthWidth].terrainType = tt_holy_site_plateau_med
	
		-- adding stealth flanks
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			-- adding stealth
			if col <= 0 + stealthWidth or col >= gridSize+1 - stealthWidth  then
				
				terrainLayoutResult[row][col].terrainType = tt_sacred_mountains_stealth_circular_large
			end
			
		end
	end
		
end


-- Central area (cleariing path between factions
for row = mapHalfSize-3, mapHalfSize+3 do
	for col = mapHalfSize-1, mapHalfSize+1 do
		terrainLayoutResult[row][col].terrainType = tt_plains_clearing
	end
end

-- central market
terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = tt_settlement_plains
-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------


	
-- assigning ffa / non ffa terrain to each player
if(#teamMappingTable  == 2) then
	playerStartTerrain = tt_sacred_mountains_player_start
else
	playerStartTerrain = tt_sacred_mountains_player_start_ffa
end

--Making this number larger will give more space between every player, even those on the same team.
minPlayerDistance = 3.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.

minTeamDistance = 6.5

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = 2

--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
--setting this to 0.4 will mean that the middle 40% of squares will not be eligable for spawning (so imagine the centre point, and 20% of the map size in all directions)
innerExclusion = 0.3


--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 1


--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. It will ensure that players are not placed on or
--adjacent to squares in this list
impasseTypes = {}
table.insert(impasseTypes, tt_forest_natural_large)
table.insert(impasseTypes, tt_settlement_plains)
table.insert(impasseTypes, tt_plateau_med)
table.insert(impasseTypes, tt_holy_site_hill)
table.insert(impasseTypes, tt_river)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 1.5

-- adjusting vars for FFA
if(#teamMappingTable > 6) then
	innerExclusion = 0.1
	minTeamDistance = 3.5
elseif (#teamMappingTable > 4) then
	innerExclusion = 0.2
	minTeamDistance = 4.5
end

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_hills_gentle_rolling

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 2

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = true


-- setting up team vs team function
function PlaceMirroredTeam()
	teamCount = #teamMappingTable[1].players -- distance between players of the same team
	for i = 1, teamCount do
		if(teamCount >= 3) then
			if(i == 1 or i == teamCount) then
				-- Flank civs
				offSetStart = 1
				if(i == teamCount) then 
					offSetStart = -1
				end
				terrainLayoutResult[mapHalfSize - playerSpawnDistance + teamCount + 1][mapHalfSize + offSetStart - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
				terrainLayoutResult[mapHalfSize - playerSpawnDistance + teamCount + 1][mapHalfSize + offSetStart - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[1].players[i].playerID - 1
				
				-- Team 2
				terrainLayoutResult[mapHalfSize + playerSpawnDistance - teamCount - 1][mapHalfSize + offSetStart - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
				terrainLayoutResult[mapHalfSize + playerSpawnDistance - teamCount - 1][mapHalfSize + offSetStart - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[2].players[i].playerID - 1
			else
			
				-- Pocket civs
				-- Team 1
				terrainLayoutResult[mapHalfSize - playerSpawnDistance + 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
				terrainLayoutResult[mapHalfSize - playerSpawnDistance + 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[1].players[i].playerID - 1
				
				-- Team 2
				terrainLayoutResult[mapHalfSize + playerSpawnDistance - 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
				terrainLayoutResult[mapHalfSize + playerSpawnDistance - 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[2].players[i].playerID - 1
			
			end
		else
			-- Team 1
			terrainLayoutResult[mapHalfSize - playerSpawnDistance + 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
			terrainLayoutResult[mapHalfSize - playerSpawnDistance + 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[1].players[i].playerID - 1
			
			-- Team 2
			terrainLayoutResult[mapHalfSize + playerSpawnDistance - 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
			terrainLayoutResult[mapHalfSize + playerSpawnDistance - 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[2].players[i].playerID - 1
				
		end
		
	end
end

if(#teamMappingTable ~= 2 or #teamMappingTable[1].players ~= #teamMappingTable[2].players) then
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
else
	PlaceMirroredTeam()
end

-- placing starting resources behind each player
for row = 1, gridSize do
	for col = 1, gridSize do
	--checking if grid tile is player start terrain
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain ) then
			-- checking which side of the island the player is on
			if(row < mapHalfSize) then
				--local res for player
				if(#teamMappingTable  == 2) then
					terrainLayoutResult[row - 1][col].terrainType = tt_gold_small_hills
					terrainLayoutResult[row - 2][col].terrainType = tt_stone_small_hills
					terrainLayoutResult[1][col].terrainType = tt_forest_circular_medium
					terrainLayoutResult[row - 1][col - 1].terrainType = tt_hills_low_rolling
					terrainLayoutResult[row - 1][col + 1].terrainType = tt_hills_low_rolling
					
				else
					-- starting terrain should contain FFA gold
				end
				
				-- 
					terrainLayoutResult[row + 1][col].terrainType = tt_forest_circular_medium
				
				--terrainLayoutResult[row + 1][col].terrainType = 
			else
				--back gold
				if(#teamMappingTable  == 2) then
					terrainLayoutResult[row + 1][col].terrainType = tt_gold_small_hills
					terrainLayoutResult[row + 2][col].terrainType = tt_stone_small_hills
					terrainLayoutResult[gridSize][col].terrainType = tt_forest_circular_medium
					terrainLayoutResult[row + 1][col - 1].terrainType = tt_hills_low_rolling_clear
					terrainLayoutResult[row + 1][col + 1].terrainType = tt_hills_low_rolling_clear
					
				else
					-- starting terrain should contain FFA gold
				end

				
				-- trees
					terrainLayoutResult[row - 1][col].terrainType = tt_forest_circular_medium --tt_sacred_mountains_forest_small_hills
				
					--terrainLayoutResult[row - 1][col].terrainType = tt_forest_circular_tiny
			end
		end
	end
end
