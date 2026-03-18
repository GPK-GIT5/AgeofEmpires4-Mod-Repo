-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
terrainLayoutResult = {}    -- set up initial table for coarse map grid

-- Players base terrain
playerStartTerrain = tt_player_start_dunes

--setting useful variables to reference world dimensions. 
gridHeight, gridWidth, gridSize = SetCoarseGrid()


if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map

--set the number of players. this info is grabbed from the lobby
playerStarts = worldPlayerCount

--BASIC MAP SETUP-------------------------------------------------------------------------------------------------
-- setting up the map grid

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

baseGridSize = 13
mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.floor(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--do map specific stuff around here
--Forests generation

 treeScarcity = 3 -- how often do trees spawn, higher number = scarcer spawn
 forestTerrain = tt_forest_circular_small
if (worldPlayerCount > 4) then
	 treeScarcity = 5 -- how often do trees spawn, higher number = scarcer spawn
 	forestTerrain = tt_forest_circular_medium
end

for row = 1, gridSize do
	for col = 1, gridSize do
		
		--if(worldGetRandom() < 0.5) then
		if((row+col) % treeScarcity == 0) then
			terrainLayoutResult[row][col].terrainType = forestTerrain
		end
	end
end

--Here's a basic loop that will iterate through all squares in your map
for row = mapHalfSize - mapQuarterSize, mapHalfSize + mapQuarterSize do
	for col = mapHalfSize - mapQuarterSize, mapHalfSize + mapQuarterSize do
		-- Adding hills leading up to the plateau
		if (row == (mapHalfSize - mapQuarterSize) or (row == (mapHalfSize + mapQuarterSize)) ) 
			or (col == (mapHalfSize - mapQuarterSize) or (col == (mapHalfSize + mapQuarterSize)) ) then
			
			terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
		else
			terrainLayoutResult[row][col].terrainType = tt_plateau_low	
		end
		-- plateau terrain
		
	end
end


-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------
teamsList, playersPerTeam = SetUpTeams()

--teamMappingTable[teamIndex].players[playerIndex].playerID
teamMappingTable = CreateTeamMappingTable()

-- Adding fixed trades on larger map
if (#teamMappingTable > 4) then
	-- in an FFA with 5 teams or more, only one sacred site
	terrainLayoutResult[mapHalfSize - mapQuarterSize][mapHalfSize - mapQuarterSize].terrainType = tt_settlement_plateau
	terrainLayoutResult[mapHalfSize + mapQuarterSize][mapHalfSize - mapQuarterSize].terrainType = tt_settlement_plateau
	terrainLayoutResult[mapHalfSize + mapQuarterSize][mapHalfSize + mapQuarterSize].terrainType = tt_settlement_plateau
	terrainLayoutResult[mapHalfSize - mapQuarterSize][mapHalfSize + mapQuarterSize].terrainType = tt_settlement_plateau
elseif ( worldGetRandom() > 0.5) then
	terrainLayoutResult[mapHalfSize - mapQuarterSize][mapHalfSize - mapQuarterSize].terrainType = tt_holy_site_plateau_low
	terrainLayoutResult[mapHalfSize + mapQuarterSize][mapHalfSize - mapQuarterSize].terrainType = tt_settlement_plateau
	terrainLayoutResult[mapHalfSize + mapQuarterSize][mapHalfSize + mapQuarterSize].terrainType = tt_holy_site_plateau_low
	terrainLayoutResult[mapHalfSize - mapQuarterSize][mapHalfSize + mapQuarterSize].terrainType = tt_settlement_plateau
else
	terrainLayoutResult[mapHalfSize - mapQuarterSize][mapHalfSize - mapQuarterSize].terrainType = tt_settlement_plateau
	terrainLayoutResult[mapHalfSize + mapQuarterSize][mapHalfSize - mapQuarterSize].terrainType = tt_holy_site_plateau_low
	terrainLayoutResult[mapHalfSize + mapQuarterSize][mapHalfSize + mapQuarterSize].terrainType = tt_settlement_plateau
	terrainLayoutResult[mapHalfSize - mapQuarterSize][mapHalfSize + mapQuarterSize].terrainType = tt_holy_site_plateau_low
end

-- Adding central holy site
terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = tt_holy_site_plateau_low

	

--Making this number larger will give more space between every player, even those on the same team.
minPlayerDistance = 3.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.
minTeamDistance = 8.5

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = 2

--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
--setting this to 0.4 will mean that the middle 40% of squares will not be eligable for spawning (so imagine the centre point, and 20% of the map size in all directions)
innerExclusion = 0.4

--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 2


--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. It will ensure that players are not placed on or
--adjacent to squares in this list
impasseTypes = {}
table.insert(impasseTypes, tt_plateau_low)
table.insert(impasseTypes, tt_mountains)
table.insert(impasseTypes, tt_plateau_med)
table.insert(impasseTypes, tt_ocean)
table.insert(impasseTypes, tt_river)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 1.5

if(#teamMappingTable > 4) then
	impasseDistance = 3.5
	cornerThreshold = 1
	edgeBuffer = 1
elseif (worldPlayerCount > 6) then
	impasseDistance = 1.5
	edgeBuffer = 4
	elseif (worldPlayerCount > 4) then
	impasseDistance = 1.5
	edgeBuffer = 3
	elseif (worldPlayerCount > 2) then
	impasseDistance = 1.5
	edgeBuffer = 2
end
--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
--locations will expand, and further locations may be chosen. I like to keep this number very small, as in the case of 0.02, it will take the top 2% of spawn options only.
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_plains

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 1

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = true

terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)