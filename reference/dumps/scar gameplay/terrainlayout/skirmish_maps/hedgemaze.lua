-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

terrainLayoutResult = {}    -- set up initial table for coarse map grid
print("Gorge MAPGEN script starting")
gridSize = 11 + (worldPlayerCount*2)
gridHeight = gridSize
gridWidth = gridSize


--gridHeight, gridWidth, gridSize = SetCoarseGrid()

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map
--NOTE: AoE4 MapGen is designed to generate square maps. The grid you will be working with will always need to have gridWidth = gridHeight

--set the number of players. this info is grabbed from the lobby
playerStarts = worldPlayerCount


--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
baseTerrain = tt_trees_plains_clearing_large
hedgemazeForest = tt_hedgemaze_forest
playerStartTerrain = tt_player_start_hedgemaze
-- adding gen scaling variables
mapSizeModifier = 0
gridSize = 25 -- 25 is set as an "hardcoded" base map gridsize
if (worldTerrainWidth >= 512) then
	mapSizeModifier = 1
	gridSize = gridSize + 8 --Will apply for larger map sizes > micro
end 
if (worldTerrainWidth >= 640) then
	mapSizeModifier = 2
	gridSize = gridSize + 8
	
end
if (worldTerrainWidth >= 768) then
	mapSizeModifier = 3
	gridSize = gridSize + 8
end
if (worldTerrainWidth >= 896) then
	mapSizeModifier = 4
	gridSize = gridSize + 8
end

terrainLayoutResult = SetUpGrid(gridSize, baseTerrain, terrainLayoutResult)

mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--setting hedgemaze variables
mazeLength = mapHalfSize - 1

-- setting the base layout of the terrain
for row = 1, gridSize do
	for col = 1, gridSize do
		terrainLayoutResult[row][col].terrainType = baseTerrain
	end
end
-- "Boxing" the map with cliffs
for col = 1, gridSize do
		--terrainLayoutResult[gridSize][col].terrainType = tt_plateau_low
		terrainLayoutResult[1][col].terrainType = tt_plateau_low
end
for row = 1, gridSize do
		terrainLayoutResult[row][1].terrainType = tt_plateau_low
		terrainLayoutResult[row][gridSize].terrainType = tt_plateau_low
end
-- placing a "box" of trees within hedgemaze boundaries
-- horizontal lines
	for col = 1, gridSize - 1 do
		terrainLayoutResult[mazeLength][col].terrainType = hedgemazeForest
		terrainLayoutResult[2][col].terrainType = hedgemazeForest
	end

-- vertical sides
	for row = 1, gridSize - 1 do
		terrainLayoutResult[row][2].terrainType = hedgemazeForest
		terrainLayoutResult[row][gridSize - 1].terrainType = hedgemazeForest
	end
-- Entry points
terrainLayoutResult[mazeLength][3].terrainType = baseTerrain
terrainLayoutResult[mazeLength][4].terrainType = baseTerrain 
terrainLayoutResult[mazeLength][gridSize - 2].terrainType = baseTerrain
terrainLayoutResult[mazeLength][gridSize - 3].terrainType = baseTerrain 

-- Creating "Zigzag Hedge Lanes" 
maxLanes = 2 + mapSizeModifier
mazeDirection = (mapSizeModifier+1)%2 --math.floor((worldGetRandom()) * 2) -- if the lanes will start pointing up or down
for lane = 1, maxLanes do
	if (lane % 2 == mazeDirection) then -- deciding if the lane should go bottom to top or top to bottom 
		col = mapHalfSize - (lane*4)
		for row = 2, mazeLength - 3 do
			terrainLayoutResult[row][col].terrainType = hedgemazeForest
		end
		-- adding a ruin at the lane entry
		terrainLayoutResult[mazeLength - 1][col].terrainType = tt_poi_ruins
		
		-- lanes pointing "down" spawn gold
		terrainLayoutResult[math.ceil(mazeLength/2)][col + 2].terrainType = tt_gold_large_single
		terrainLayoutResult[math.ceil(mazeLength/2) - 2][col + 2].terrainType = tt_gold_tiny
		terrainLayoutResult[math.ceil(mazeLength/2) - 2][col + 2].terrainType = tt_berries_small_single
		terrainLayoutResult[math.ceil(mazeLength/2) + 2][col + 2].terrainType = tt_deer_herd_large
		col = mapHalfSize + (lane*4)
		for row = 2, mazeLength - 3 do
			terrainLayoutResult[row][col].terrainType = hedgemazeForest
		end
		-- adding a ruin at the lane entry
		terrainLayoutResult[mazeLength - 1][col].terrainType = tt_poi_ruins
		
		-- lanes pointing "down" spawn gold
		terrainLayoutResult[math.ceil(mazeLength/2)][col - 2].terrainType = tt_gold_large_single
		terrainLayoutResult[math.ceil(mazeLength/2) - 2][col - 2].terrainType = tt_berries_small_single
		terrainLayoutResult[math.ceil(mazeLength/2) + 2][col - 2].terrainType = tt_deer_herd_large
	else
		col = mapHalfSize - (lane*4)
		for row = mazeLength - 1, 5, -1 do
			terrainLayoutResult[row][col].terrainType = hedgemazeForest
		end
		-- adding a ruin at the lane entry
		terrainLayoutResult[2][col].terrainType = tt_poi_ruins
		
		-- lanes pointing "up" spawn stone
		terrainLayoutResult[math.ceil(mazeLength/2)][col + 2].terrainType = tt_stone_large --tt_berries_small_single
		terrainLayoutResult[math.ceil(mazeLength/2) - 2][col + 2].terrainType = tt_berries_small_single
		terrainLayoutResult[math.ceil(mazeLength/2) + 2][col + 2].terrainType = tt_deer_herd_large
		col = mapHalfSize + (lane*4)
		for row = mazeLength - 1, 5, -1 do
			terrainLayoutResult[row][col].terrainType = hedgemazeForest
		end
		-- adding a ruin at the lane entry
		terrainLayoutResult[2][col].terrainType = tt_poi_ruins
		
		-- lanes pointing "up" spawn stone
		terrainLayoutResult[math.ceil(mazeLength/2)][col - 2].terrainType = tt_stone_large
		terrainLayoutResult[math.ceil(mazeLength/2) - 2][col - 2].terrainType = tt_berries_small_single
		terrainLayoutResult[math.ceil(mazeLength/2) + 2][col - 2].terrainType = tt_deer_herd_large
	end
end
-- adding "welcoming" wolf dens at the entry passage to the maze
	terrainLayoutResult[mazeLength][3].terrainType = tt_poi_wolf_den
	terrainLayoutResult[mazeLength][gridSize - 2].terrainType = tt_poi_wolf_den
-- Creating Center 
	-- Holy Sites spawn
	terrainLayoutResult[mazeLength - 3][mapHalfSize].terrainType = tt_holy_site
	terrainLayoutResult[4][mapHalfSize].terrainType = tt_holy_site
	-- Adding wolf den and a ruin between sacred sites
	wolfDenPosition = math.ceil((4 + mazeLength - 3)/2 )
	terrainLayoutResult[wolfDenPosition - 1][mapHalfSize].terrainType = tt_poi_ruins
	terrainLayoutResult[wolfDenPosition][mapHalfSize].terrainType = tt_poi_wolf_den

-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------


teamsList, playersPerTeam = SetUpTeams()

--The Team Mapping Table is created from the info in the lobby. It is a table containing each team and which players make them up.
teamMappingTable = CreateTeamMappingTable()

minPlayerDistance = 2.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.
minTeamDistance = 7.5

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = 4

--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
innerExclusion = 0.4

--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 2

--playerStartTerrain is the terrain type containing the standard distribution of starting resources.
playerStartTerrain = tt_player_start_hedgemaze

--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. 
impasseTypes = {}
table.insert(impasseTypes, tt_impasse_mountains)
table.insert(impasseTypes, tt_mountains)
table.insert(impasseTypes, hedgemazeForest)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be.
impasseDistance = 4.5

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. 
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns.
startBufferTerrain = tt_trees_plains_clearing_large

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 1

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = false --




local function PlaceTeamStarts()
	playerStartTerrain = tt_player_start_hedgemaze_lanes
	print(">> DEBUG: entering PlaceTeamStarts Function")
	ShuffleAllTeamsIndexes(teamMappingTable) -- shuffling indexes for randomization
	-- iterates once for every player in both teams (i=2 means 2nd player in both teams)
	for i = 1, #teamMappingTable[1].players do
		-- placing the player with a bit of variance on the X axis
		
		 -- player's position on the column
		playerColPos = 1+edgeBuffer+((i-1)*3)
		playerRowPos = mapHalfSize + (i*6)
		
		-- adding a line of trees above each opposing players
		for  col = 2, gridSize - 1 do
			terrainLayoutResult[playerRowPos - 3][col].terrainType = hedgemazeForest
		end
		-- entry point with a boar
		terrainLayoutResult[playerRowPos - 3][mapHalfSize].terrainType = tt_boar_spawner_single
		terrainLayoutResult[playerRowPos - 3][mapHalfSize - 1].terrainType = baseTerrain
		terrainLayoutResult[playerRowPos - 3][mapHalfSize + 1].terrainType = baseTerrain
		if(i == 1) then
		-- opening up the first line of trees
		terrainLayoutResult[playerRowPos - 3][mapHalfSize - 2].terrainType = baseTerrain
		terrainLayoutResult[playerRowPos - 3][mapHalfSize + 2].terrainType = baseTerrain
		end
		if(i ~= 1) then
		-- opening ally entrance from the back
		terrainLayoutResult[playerRowPos - 3][3].terrainType = tt_gold_small_single
		terrainLayoutResult[playerRowPos - 3][4].terrainType = baseTerrain
		terrainLayoutResult[playerRowPos - 3][gridSize - 2].terrainType = tt_gold_small_single
		terrainLayoutResult[playerRowPos - 3][gridSize - 3].terrainType = baseTerrain
		end
		
		terrainLayoutResult[playerRowPos][playerColPos].playerIndex = teamMappingTable[1].players[i].playerID - 1
		
		print(">> DEBUG: setting additional players location in team 1. row = "..mapHalfSize..", col = "..playerColPos..".")
			if (playerColPos < mapHalfSize)  then
				print("placing gold towards the edge - 1, "..playerColPos.." col, mapHalfSize = "..mapHalfSize.."")
				terrainLayoutResult[playerRowPos][playerColPos + 4].terrainType = tt_berries_small_single 
				terrainLayoutResult[playerRowPos][playerColPos + 2].terrainType = tt_gold_small_single --small player gold 
				terrainLayoutResult[playerRowPos][playerColPos + 6].terrainType = tt_stone_small_single --small player stone
				if(worldPlayerCount == 2) then
					-- 1v1 additional starting gold
					terrainLayoutResult[playerRowPos + 3][playerColPos - 1].terrainType = tt_gold_small_single
				end
			elseif (playerColPos >= mapHalfSize)  then
				print("placing gold towards the edge + 1, "..playerColPos.." col, mapHalfSize = "..mapHalfSize.."")
				terrainLayoutResult[playerRowPos][playerColPos - 4].terrainType = tt_berries_small_single
				terrainLayoutResult[playerRowPos][playerColPos - 2].terrainType = tt_gold_small_single --small player gold 
				terrainLayoutResult[playerRowPos][playerColPos - 6].terrainType = tt_stone_small_single --small player stone 
				if(worldPlayerCount == 2) then
					-- 1v1 additional starting gold
					terrainLayoutResult[playerRowPos + 3][playerColPos + 1].terrainType = tt_gold_small_single
				end
			end
		
		if i ==  1 and #teamMappingTable[1].players == 1 then
			-- using generic start terrain if there is only 1 player on the team.
			terrainLayoutResult[playerRowPos][playerColPos].terrainType = playerStartTerrain
		else
			
			terrainLayoutResult[playerRowPos][playerColPos].terrainType = playerStartTerrain
			
		end
	end
	-- 2nd team
	for i = 1, #teamMappingTable[2].players do
		-- placing the player with a bit of variance on the X axis
		-- row =mapHalfSize and col = 1 or col = gridSize  is the first player spawn of each team
		playerColPos = gridSize - edgeBuffer - ((i-1)*3)
		playerRowPos = mapHalfSize + (i*6)
		
		terrainLayoutResult[playerRowPos][playerColPos].playerIndex = teamMappingTable[2].players[i].playerID - 1
			--spawn around the players
			if (playerColPos < mapHalfSize) then
				terrainLayoutResult[playerRowPos][playerColPos + 4].terrainType = tt_berries_small_single
				terrainLayoutResult[playerRowPos][playerColPos + 2].terrainType = tt_gold_small_single --small gold 
				terrainLayoutResult[playerRowPos][playerColPos + 6].terrainType = tt_stone_small_single --small stone
				if(worldPlayerCount == 2) then
					-- 1v1 additional starting gold
					terrainLayoutResult[playerRowPos + 3][playerColPos - 1].terrainType = tt_gold_small_single
				end
			elseif playerColPos >= mapHalfSize then
				terrainLayoutResult[playerRowPos][playerColPos - 4].terrainType = tt_berries_small_single
				terrainLayoutResult[playerRowPos][playerColPos - 2].terrainType = tt_gold_small_single --small gold 
				terrainLayoutResult[playerRowPos][playerColPos - 6].terrainType = tt_stone_small_single --small stone 
				if(worldPlayerCount == 2) then
					-- 1v1 additional starting gold
					terrainLayoutResult[playerRowPos + 3][playerColPos + 1].terrainType = tt_gold_small_single
				end
			end
		
		if i ==  1 and #teamMappingTable[2].players == 1 then
			-- using generic start terrain if there is only 1 player on the team.
			terrainLayoutResult[playerRowPos][playerColPos].terrainType = playerStartTerrain
		else
			
			terrainLayoutResult[playerRowPos][playerColPos].terrainType = playerStartTerrain
			
		end
	end
end

-- placing players across a lane, if it is a 2 teams game
if  (#teamMappingTable == 2 and #teamMappingTable[1].players == #teamMappingTable[2].players ) then 
	print(">>DEBUG: 2 teams are in the game")
	
	PlaceTeamStarts()
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
end
