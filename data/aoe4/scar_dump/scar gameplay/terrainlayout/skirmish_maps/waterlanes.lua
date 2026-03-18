-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
terrainLayoutResult = {}    -- set up initial table for coarse map grid


gridHeight, gridWidth, gridSize = SetCoarseGrid()

gridRes = 15
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(gridRes)

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map

playerStarts = worldPlayerCount

--BASIC MAP SETUP-------------------------------------------------------------------------------------------------
-- setting up the map grid

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

baseGridSize = 13
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(15)

mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--making a "smooth" terrain for the map
for row = 1, gridSize do
	for col = 1, gridSize do
	terrainLayoutResult[row][col].terrainType = tt_plains_smooth
	end
end

-- adding back trees
for row = 1, gridSize do
	terrainLayoutResult[row][1].terrainType = tt_waterlanes_forest_edge
	terrainLayoutResult[row][gridSize].terrainType = tt_waterlanes_forest_edge
end

-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------


teamsList, playersPerTeam = SetUpTeams()

teamMappingTable = CreateTeamMappingTable()
	
--the following are variables that control player spawn distances using the PlacePlayerStarts function.
minPlayerDistance = 3.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.
minTeamDistance = 8.5

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = 5
if(worldPlayerCount > 4) then
 edgeBuffer = edgeBuffer + 1
	if(worldPlayerCount > 6) then
	 edgeBuffer = edgeBuffer + 1
	end
end


--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
--setting this to 0.4 will mean that the middle 40% of squares will not be eligable for spawning (so imagine the centre point, and 20% of the map size in all directions)
innerExclusion = 0.4

--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 2

--playerStartTerrain is the terrain type containing the standard distribution of starting resources. If you make a custom set of starting resources, 
--and have them set as a local distribution on your own terrain type, use that here
playerStartTerrain = tt_player_start_waterlanes

--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. It will ensure that players are not placed on or
--adjacent to squares in this list
impasseTypes = {}
table.insert(impasseTypes, tt_impasse_mountains)
table.insert(impasseTypes, tt_mountains)
table.insert(impasseTypes, tt_waterlanes_holy)
table.insert(impasseTypes, tt_waterlanes_lake)
table.insert(impasseTypes, tt_river)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 1.5

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
--locations will expand, and further locations may be chosen. I like to keep this number very small, as in the case of 0.02, it will take the top 2% of spawn options only.
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_plains

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 0

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = false

--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)

--@param xLoc is the row used for the lane
-- this function places all resoucres across an entire column on a specific row 
local function resourceLane(_xLoc)
	
	
	-- random minerals
	mineralB = tt_waterlanes_plains_gold
	mineralA = tt_waterlanes_plains_stone
	if worldGetRandom() < 0.5 then
		mineralA = tt_waterlanes_plains_gold
		mineralB = tt_waterlanes_plains_stone
	end
		terrainLayoutResult[_xLoc][mapQuarterSize + 1].terrainType = mineralA
		terrainLayoutResult[_xLoc][gridSize - 1 - mapQuarterSize].terrainType = mineralA
	
	terrainLayoutResult[_xLoc][mapHalfSize].terrainType = tt_waterlanes_holy

		terrainLayoutResult[_xLoc][mapHalfSize + 3].terrainType = mineralB
		terrainLayoutResult[_xLoc][mapHalfSize - 3].terrainType = mineralB
		
end

function waterLane (_xLoc)
	print(">> DEBUG: waterLane() func debug")
	for col = 1 , gridSize do
		if col == 1 or col == gridSize then
			terrainLayoutResult[_xLoc+1][col].terrainType = tt_waterlanes_lake
			terrainLayoutResult[_xLoc-1][col].terrainType = tt_waterlanes_lake
			terrainLayoutResult[_xLoc][col].terrainType = tt_waterlanes_lake
		else
			terrainLayoutResult[_xLoc+1][col].terrainType = tt_waterlanes_lake
			terrainLayoutResult[_xLoc-1][col].terrainType = tt_waterlanes_lake
			terrainLayoutResult[_xLoc][col].terrainType = tt_waterlanes_lake
		end
		
		
	end
	-- adding a tradepost at the edge of the lane
	print(">> DEBUG: edge of lane creation")
	if(worldGetRandom() > 0.5) then
			terrainLayoutResult[_xLoc-1][1].terrainType = tt_waterlanes_settlement
			terrainLayoutResult[_xLoc+1][gridSize].terrainType = tt_waterlanes_settlement
		else
			terrainLayoutResult[_xLoc+1][1].terrainType = tt_waterlanes_settlement
			terrainLayoutResult[_xLoc-1][gridSize].terrainType = tt_waterlanes_settlement
	end
	print(">> DEBUG: fin waterlanes")
end

spawnTypes = 2
if worldPlayerCount > 4 then
	-- adding additional player spawn position type for 3v3 games and above
	spawnTypes = 3
end
spawnType = math.ceil(worldGetRandom() * spawnTypes)
spawnTypeT2 = math.ceil(worldGetRandom() * spawnTypes) -- for the 2nd team, used to not mirror lobby placements.

-- creating FFA or 1v1 unique terrains
if(#teamMappingTable[1].players == 1 or #teamMappingTable ~=2 ) then
	print(">> DEBUG: Creating FFA config")
	resourceLane(2)
	resourceLane(gridSize - 1)
	waterLane(mapQuarterSize)
	waterLane(gridSize - mapQuarterSize)
	print(">> DEBUG: fin FFA config")
end
	

laneSize = math.ceil(gridSize / (worldPlayerCount / 2))
-- Placing players on different sides of the map, keeping them the same distance 
local function PlaceMirroredTeamStarts()
    -- At this point we know there are exactly two teams of equal size.
	print(">> DEBUG: placing mirrored teams")
	ShuffleAllTeamsIndexes(teamMappingTable) -- shuffling indexes for randomization
	
    for i = 1, #teamMappingTable[1].players do
		-- placing the player on the X axis
		
		x = laneSize - math.floor(laneSize/2)
		y = edgeBuffer
		
		-- spawning additional team players
		if(i > 1) then
			-- setting current player position
			
				x = (laneSize * i) - math.floor(laneSize/2)
        		y = edgeBuffer
		end
		-- distributing only if its not a 1v1 config
		if(#teamMappingTable[1].players > 1) then
			resourceLane(x)
		end
		if laneSize * i < gridSize-1 then
			waterLane(laneSize * i)
		end
		
        terrainLayoutResult[x][y].terrainType = tt_player_start_waterlanes
		terrainLayoutResult[x][y].playerIndex = teamMappingTable[1].players[i].playerID - 1
	
		print(">> DEBUG: First team placed")
		-- Creating other player's spawn. It will be either mirrored or flipped to the enemy player from the other team
			targetX =  x --  mirrored
			targetY = gridSize - y + 1  -- 
		
        terrainLayoutResult[targetX][targetY].terrainType = tt_player_start_waterlanes
		terrainLayoutResult[targetX][targetY].playerIndex = teamMappingTable[2].players[i].playerID - 1
       
    end
end
if(#teamMappingTable ~= 2) then
	print(">> DEBUG: team table ~=2")
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)
else
	if (#teamMappingTable[1].players ~= #teamMappingTable[2].players) then
		-- uneven teams
		resourceLane(2)
		resourceLane(gridSize - 1)
		waterLane(mapQuarterSize)
		waterLane(gridSize - mapQuarterSize)
		terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)
	else
		print(">> DEBUG: 2 teams setup")
		PlaceMirroredTeamStarts()
	end
end
print(">> DEBUG: fin Waterlanes LUA script")
