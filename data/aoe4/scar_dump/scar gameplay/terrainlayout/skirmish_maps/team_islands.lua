-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

terrainLayoutResult = {}    -- set up initial table for coarse map grid

-- Players base terrain
playerStartTerrain = tt_player_start_classic_plains_naval_warring_islands

--setting useful variables to reference world dimensions. 
gridHeight, gridWidth, gridSize = SetCoarseGrid()


if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map

--BASIC MAP SETUP-------------------------------------------------------------------------------------------------
-- setting up the map grid

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, tt_lake_medium_fish_single, terrainLayoutResult)

baseGridSize = 13
mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.floor(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

-- getting the amount of players from the lobby
playerStarts = worldPlayerCount

--init values
islandsDistance = 0
islandGenPos = 0

-- creating an island to host the players at
--@param islandWidthStart the Row point the island begins forming from
--@param islandWidthEnd the Row point the island stops forming
local function CreateIsland(islandWidthStart, islandWidthEnd)
	variance = math.ceil(worldGetRandom() * 3 ) - 2
	islandStartPoint = mapQuarterSize + variance
	islandEndPoint = gridSize - mapQuarterSize + variance
	
	for row = islandWidthStart+1, islandWidthEnd+1 do
		for col = islandStartPoint+1, islandEndPoint+1 do
			-- creating the main island
			terrainLayoutResult[row][col].terrainType = tt_plains --tt_lake_medium_fish_single --tt_lake_shallow_hill_fish
			print(">DEBUG: Loop in islandWidth?")
		end
	end	
	
	for row = islandWidthStart, islandWidthEnd do
		for col = islandStartPoint, islandEndPoint do
			-- creating the main island
			print(">DEBUG: Loop in islandWidth 2 ?")
			if(worldGetRandom() > 0.3) then
				terrainLayoutResult[row][col].terrainType = tt_plains
			elseif (worldGetRandom() > 0.4) then
				terrainLayoutResult[row][col].terrainType = tt_plains --tt_hills_gentle_rolling -- adding hill variation
			else  
				terrainLayoutResult[row][col].terrainType = tt_flatland -- adding flat terrain
			end
		end	
		-- adding a mountain at the side of the island for aesthetics
	end
	if (worldGetRandom() > 0.5) then
		if (worldGetRandom() > 0.5) then
			terrainLayoutResult[islandWidthEnd][islandEndPoint].terrainType = tt_mountains_small
		else
			terrainLayoutResult[islandWidthEnd][islandStartPoint].terrainType = tt_mountains_small
		end
		
	else
		if (worldGetRandom() > 0.5) then
			terrainLayoutResult[islandWidthStart][islandEndPoint].terrainType = tt_mountains_small	
		else
			terrainLayoutResult[islandWidthStart][islandEndPoint].terrainType = tt_mountains_small		
		end
	end
	
	-- removing tiles on each side of the island to make it look natural. More tiles the more players there are on the map
	for removals = 1, playerStarts do
		removeTileFront = math.ceil(worldGetRandom() * (islandEndPoint-islandStartPoint) ) + islandStartPoint
		removeTileBack = math.ceil(worldGetRandom() * (islandEndPoint-islandStartPoint) ) + islandStartPoint
		
		terrainLayoutResult[islandWidthStart][removeTileFront].terrainType = tt_lake_shallow_hill_fish
		terrainLayoutResult[islandWidthEnd][removeTileBack].terrainType = tt_lake_shallow_hill_fish 
	end
	
end

-- calling the func to generate the 2 main islands
CreateIsland(2,mapHalfSize-2)
CreateIsland(mapHalfSize+2,gridSize-1)

-- adding ring of water
for row = 1, gridSize do
	for col = 1, gridSize do
		
		if  row == 1 or row == gridSize   
			or col == 1 or col == gridSize  then
			
			terrainLayoutResult[row][col].terrainType = tt_warring_islands_lake_medium_fish_single--tt_lake_medium_fish_single
		end
		
	end
end

-- Central Island
--@param startPoint refers to the central point from which the island is generated around.
--@param tradePos determines the amount of offset the naval trade will spawn at from the center of the island, and its direction (in column grid tiles)
local function createCentralIsland(startPoint, tradePos)

	
-- surrounding the island in water
for row = mapHalfSize-2, mapHalfSize+2 do
	for col = startPoint-2, startPoint+2 do
		
			terrainLayoutResult[row][col].terrainType = tt_warring_islands_lake_medium_fish_single
		
	end
end
	
-- Creating central Mass
for row = mapHalfSize-1, mapHalfSize+1 do
	for col = startPoint-1, startPoint+1 do
			terrainLayoutResult[row][col].terrainType = tt_plains_smooth
	end
end
	
-- adding a mountain in a random position of the central island lane (because it looks cool)
	mountainPos = math.ceil(worldGetRandom() * 3) -2
	terrainLayoutResult[mapHalfSize][startPoint+mountainPos].terrainType = tt_mountains_small
	
-- adding trade post
	terrainLayoutResult[mapHalfSize+tradePos][startPoint].terrainType = tt_settlement_naval_lake
end

createCentralIsland(mapQuarterSize, 1)
createCentralIsland((gridSize-mapQuarterSize), -1)

--[[
islandsDistance = math.ceil(worldGetRandom() * 3) + mapQuaerterSize -- the distance of the islands start point from each other
islandGenPos = math.ceil(worldGetRandom() * mapQurterSize) -- the point islands begin generating from

-- calling func to generate the neutral islands
if (worldGetRandom() > 0.5) then
	createCentralIsland(mapHalfSize - islandGenPos, 1)
	createCentralIsland(gridSize - mapQuarterSize - islandGenPos, -1)
else
	createCentralIsland(mapHalfSize - islandGenPos, -1)
	createCentralIsland(gridSize - mapQuarterSize - islandGenPos, 1)
end
--]]
-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------
teamsList, playersPerTeam = SetUpTeams()

--teamMappingTable[teamIndex].players[playerIndex].playerID
teamMappingTable = CreateTeamMappingTable()
	

--Making this number larger will give more space between every player, even those on the same team.
minPlayerDistance = 2.5
if(#teamMappingTable > 2) then
	minPlayerDistance = 1.5
end


--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.

minTeamDistance = 6.5
if(#teamMappingTable > 2) then
	minTeamDistance = 3.5
	
end

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = 2

--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
--setting this to 0.4 will mean that the middle 40% of squares will not be eligable for spawning (so imagine the centre point, and 20% of the map size in all directions)
innerExclusion = 0.3


--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 2


--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. It will ensure that players are not placed on or
--adjacent to squares in this list
impasseTypes = {}
table.insert(impasseTypes, tt_lake_shallow_hill_fish)
table.insert(impasseTypes, tt_settlement_naval_lake)
table.insert(impasseTypes, tt_lake_medium_fish_single)
table.insert(impasseTypes, tt_ocean)
table.insert(impasseTypes, tt_plains_smooth)
table.insert(impasseTypes, tt_mountains_small)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 1

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_hills_gentle_rolling

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 1

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = false

if(worldTerrainHeight <= 513 and worldPlayerCount >=4) then
	minTeamDistance = 2.5
	edgeBuffer = 1
	minPlayerDistance = 0.5
end

terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)