-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

print("Starting Rocky River Script")

terrainLayoutResult = {}    -- set up initial table for coarse map grid



--will work as intended. Terrain types have been tuned at the default 40m resolution. 
gridHeight, gridWidth, gridSize = SetCoarseGrid()


if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map
gridSize = gridSize * 2
--BASIC MAP SETUP-------------------------------------------------------------------------------------------------

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
basicElevation = tt_hidden_valley_plains_clearing
terrainLayoutResult = SetUpGrid(gridSize, basicElevation, terrainLayoutResult)

mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--do map specific stuff around here

hillEdgeDistance = mapEighthSize + 1 -- distance of hills from the edge of the map 
-- Creating hills to get to the sides of the map
print("DEBUG >>> PLACING HILLS")
for row = 1 + hillEdgeDistance, gridSize - hillEdgeDistance do
	for col = 1, gridSize do
	terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
	end
end

-- Creating plateau on the sides
print("DEBUG >>> PLACING PLATEAU")
distanceFromHills = 3 
for row = 1 + hillEdgeDistance + distanceFromHills, gridSize - hillEdgeDistance - distanceFromHills do
	for col = 1, gridSize do
	terrainLayoutResult[row][col].terrainType = tt_plateau_med
	end
end

centralGap = 1 -- 3 grid tiles from center goes both left and right (so 6 overall). goes until the edge
-- Creating plains through the center
print("DEBUG >>> PLACING PLAINS")
for row = 1 + hillEdgeDistance, gridSize - hillEdgeDistance  do
	for col = mapHalfSize - centralGap, mapHalfSize + centralGap do
	terrainLayoutResult[row][col].terrainType = basicElevation
	end
end

-- Creating forest impasse line
print("DEBUG >>> PLACING FOREST BLOCKADE")
-- initiating vars used for forest generation
upperRow = 1 + hillEdgeDistance + distanceFromHills
lowerRow = gridSize - hillEdgeDistance - distanceFromHills
for col = 1, gridSize do
	if terrainLayoutResult[lowerRow][col].terrainType == basicElevation 
		then
		terrainLayoutResult[lowerRow][col].terrainType = tt_hidden_valley_forest_impasse
	end
	if terrainLayoutResult[upperRow][col].terrainType == basicElevation
		then
		terrainLayoutResult[upperRow][col].terrainType = tt_hidden_valley_forest_impasse
	end
end

--central lane hills 

--terrainLayoutResult[gridSize - hillEdgeDistance - distanceFromHills][mapHalfSize].terrainType = tt_hills_low_rolling
--terrainLayoutResult[hillEdgeDistance + distanceFromHills][mapHalfSize].terrainType = tt_hills_low_rolling

-- Creating large deposits at the center

depoType = math.ceil(worldGetRandom() * 2)
for deposit = 1, math.ceil(worldPlayerCount/2) do
	
	if((deposit + depoType) % 2 == 0) then
		-- variation 1
		terrainLayoutResult[1 + hillEdgeDistance + distanceFromHills][math.ceil(deposit*3)].terrainType = tt_hidden_valley_plateau_stone
		terrainLayoutResult[1 + hillEdgeDistance + distanceFromHills][gridSize - math.ceil(deposit*3)].terrainType = tt_hidden_valley_plateau_gold
		terrainLayoutResult[gridSize - hillEdgeDistance - distanceFromHills][math.ceil(deposit*3)].terrainType = tt_hidden_valley_plateau_stone
		terrainLayoutResult[gridSize - hillEdgeDistance - distanceFromHills][gridSize - math.ceil(deposit*3)].terrainType = tt_hidden_valley_plateau_gold	
	else
		--variation 2
		terrainLayoutResult[1 + hillEdgeDistance + distanceFromHills][math.ceil(deposit*3)].terrainType = tt_hidden_valley_plateau_gold
		terrainLayoutResult[1 + hillEdgeDistance + distanceFromHills][gridSize - math.ceil(deposit*3)].terrainType = tt_hidden_valley_plateau_stone
		terrainLayoutResult[gridSize - hillEdgeDistance - distanceFromHills][math.ceil(deposit*3)].terrainType = tt_hidden_valley_plateau_gold
		terrainLayoutResult[gridSize - hillEdgeDistance - distanceFromHills][gridSize - math.ceil(deposit*3)].terrainType = tt_hidden_valley_plateau_stone	
	end
	
end

-- CENTRAL SITE SPAWN
terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = tt_holy_site

-- Extra sites
terrainLayoutResult[mapHalfSize][mapHalfSize-centralGap-2].terrainType = tt_holy_site_plateau_med
terrainLayoutResult[mapHalfSize][mapHalfSize+centralGap+2].terrainType = tt_holy_site_plateau_med

-- Trade Posts
if(worldGetRandom() > 0.5) then
	terrainLayoutResult[mapHalfSize - 2][gridSize - 3].terrainType = tt_hidden_valley_plateau_settlement
	terrainLayoutResult[mapHalfSize + 2][3].terrainType = tt_hidden_valley_plateau_settlement
	
else
	terrainLayoutResult[mapHalfSize + 2][gridSize - 3].terrainType = tt_hidden_valley_plateau_settlement
	terrainLayoutResult[mapHalfSize - 2][3].terrainType = tt_hidden_valley_plateau_settlement
end

-- corner  3x3 tiles that are not clearings
-- @param row and col refer to starting row and column
-- the function will fill 2 below and to the right from the starting point
local function FillCorners(row, col)
	for currentRow = row, row+2 do
		for currentCol = col, col+2 do
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
		end
	end
end
		

--filling with non clearing around the edges
FillCorners(1, 1)
FillCorners(gridSize-2, gridSize-2)
FillCorners(1, gridSize-2)
FillCorners(gridSize-2, 1)


--corner wood
terrainLayoutResult[gridSize-1][gridSize-1].terrainType = tt_forest_circular_medium
terrainLayoutResult[gridSize-1][2].terrainType = tt_forest_circular_medium
terrainLayoutResult[2][gridSize-1].terrainType = tt_forest_circular_medium
terrainLayoutResult[2][2].terrainType = tt_forest_circular_medium

-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------

print("DEBUG >>> PLACING PLAYERS")
teamsList, playersPerTeam = SetUpTeams()

--The Team Mapping Table is created from the info in the lobby. It is a table containing each team and which players make them up.
teamMappingTable = CreateTeamMappingTable()
	
--the following are variables that control player spawn distances using the PlacePlayerStarts function.
minPlayerDistance = 5.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.
minTeamDistance = 9.5
if(worldPlayerCount > 2) then
	minTeamDistance = 5.5
end
--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = hillEdgeDistance - 1
if (#teamMappingTable ~= 2) then
	edgeBuffer = 2
end
--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
innerExclusion = 0.4

--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 6
if(worldPlayerCount > 2) then
	cornerThreshold = 4
elseif (worldPlayerCount == 1) then
	cornerThreshold = 3
end


--playerStartTerrain is the terrain type containing the standard distribution of starting resources. If you make a custom set of starting resources, 
playerStartTerrain = tt_player_start_hidden_valley

--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. It will ensure that players are not placed on or
--adjacent to squares in this list
impasseTypes = {}
table.insert(impasseTypes, tt_hidden_valley_plateau_settlement)
table.insert(impasseTypes, tt_holy_site_plateau_med)
table.insert(impasseTypes, tt_impasse_trees_plains_forest)
table.insert(impasseTypes, tt_hidden_valley_forest_impasse)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 2
if (#teamMappingTable > 2) or (#teamMappingTable == 1)then
	impasseDistance = 1
	
elseif (worldPlayerCount > 2) then
	impasseDistance = 2
end

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
--locations will expand, and further locations may be chosen. I like to keep this number very small, as in the case of 0.02, it will take the top 2% of spawn options only.
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_plains

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 2

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = false

--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)

print("DEBUG >>> Script HIDDEN VALLEY fin")



local function PlaceTeamStarts()
	print(">> DEBUG: entering PlaceTeamStarts Function")
	ShuffleAllTeamsIndexes(teamMappingTable) -- shuffling indexes for randomization
	spawnVariation = math.ceil(worldGetRandom() * 2)
	teamPlayerDistance = 5
	
	if(spawnVariation == 1) then
		team1Point = mapHalfSize + (#teamMappingTable[1].players * 2)
		team2Point = mapHalfSize - (#teamMappingTable[2].players * 2)
	else
		team1Point = mapHalfSize - (#teamMappingTable[1].players * 2)
		team2Point = mapHalfSize + (#teamMappingTable[2].players * 2)
	end
	
	-- iterates once for every player in both teams (i=2 means 2nd player in both teams)
	for i = 1, #teamMappingTable[1].players do
		-- placing the player with a bit of variance on the X axis
		
		 -- player's position on the column
		playerCol = mapHalfSize
		
		if(spawnVariation == 1 )then
			playerCol = team1Point - ((i-1)*teamPlayerDistance)
		else
			playerCol = team1Point + ((i-1)*teamPlayerDistance)
		end
		playerRow = gridSize + 1 - edgeBuffer 
		-- if there is only 1 player, placing it at the center of the map
		if (#teamMappingTable[1].players == 1)then
			playerCol = mapHalfSize
		end
		terrainLayoutResult[playerRow][playerCol].playerIndex = teamMappingTable[1].players[i].playerID - 1
		
		
			-- using generic start terrain if there is only 1 player on the team.
			terrainLayoutResult[playerRow][playerCol].terrainType = playerStartTerrain
			print(">> DEBUG: setting additional players location in team 1. row = "..mapHalfSize..", col = "..playerCol..".")
		
		if (worldGetRandom() > 0.5) and i ~= 1 then
				terrainLayoutResult[playerRow][playerCol - 2].terrainType = tt_forest_circular_small --small gold behind the player
			else
				terrainLayoutResult[playerRow][playerCol + 2].terrainType = tt_forest_circular_small --small gold behind the player
			end
				
			terrainLayoutResult[playerRow][playerCol].terrainType = playerStartTerrain
			
	end
	-- 2nd team
	for i = 1, #teamMappingTable[2].players do
		-- placing the player with a bit of variance on the X axis
		-- row =mapHalfSize and col = 1 or col = gridSize  is the first player spawn of each team
		
		-- inverse vector from team 1
		if(spawnVariation == 1 )then
			playerCol = team2Point + ((i-1)*teamPlayerDistance)
		else
			playerCol = team2Point - ((i-1)*teamPlayerDistance)
		end
		-- if there is only 1 player, placing it at the center of the map
		if (#teamMappingTable[2].players == 1)then
			playerCol = mapHalfSize
		end
		
		playerRow =  edgeBuffer 
		
		terrainLayoutResult[playerRow][playerCol].playerIndex = teamMappingTable[2].players[i].playerID - 1
		
		
		print(">> DEBUG: setting additional players location in team 2. row = "..mapHalfSize..", col = "..playerCol..".")
		--spawning side forests beside the player
		if (worldGetRandom() > 0.5) and i ~= 1 then
			terrainLayoutResult[playerRow][playerCol - 2].terrainType = tt_forest_circular_small
		else
			terrainLayoutResult[playerRow][playerCol + 2].terrainType = tt_forest_circular_small 
		end
		
		terrainLayoutResult[playerRow][playerCol].terrainType = playerStartTerrain
			
		
	end
end

-- placing players across a lane, if it is a 2 teams game
if  (#teamMappingTable == 2) then 
	print(">>DEBUG: 2 teams are in the game")
	
	PlaceTeamStarts()
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
end