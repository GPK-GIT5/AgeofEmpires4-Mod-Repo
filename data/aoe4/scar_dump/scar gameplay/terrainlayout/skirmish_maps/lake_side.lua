-- Developed by Forgotten Empires
print("initiating Lakeside Script")
	terrainLayoutResult = {}    -- set up initial table for coarse map grid
	gridHeight, gridWidth, gridSize = SetCoarseGrid()

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end
	gridSize = gridWidth 

--setting the number of players. this info is grabbed from the lobby
	playerAmount = worldPlayerCount

--BASIC MAP SETUP-------------------------------------------------------------------------------------------------
-- adding gen scaling variables
mapSizeModifier = 0
if (worldTerrainWidth >= 512) then
	mapSizeModifier = 1
	gridSize = gridSize + 4 --Will apply for larger map sizes > micro
end 
if (worldTerrainWidth >= 640) then
	mapSizeModifier = 2
end
if (worldTerrainWidth >= 768) then
	mapSizeModifier = 3
end
if (worldTerrainWidth >= 896) then
	mapSizeModifier = 4
end

-- setting up the map grid
	terrainLayoutResult = SetUpGrid(gridSize, tt_hills_gentle_rolling, terrainLayoutResult)
	baseGridSize = 13

--set a few more useful values to use in creating specific types of map features
	mapHalfSize = math.ceil(gridSize/2)

-- local terrain vars
	playerStartTerrain = tt_player_start_lake_side

-- creating a lower parts to access water and close by fish
for row = 1, gridSize do
	for col = 1, gridSize do
		if(  col >= (mapHalfSize + 2)) then
			if (row >= (mapHalfSize - 2) and row <= (mapHalfSize + 2)) then
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
		end
	end
end

-- creating the "bay"
	local baseLakeTerrain = tt_lake_shallow
	local bayW = 2 + math.floor(mapSizeModifier/2) -- bay width
	local bayL = 5 + mapSizeModifier -- bay length
for row = 1, gridSize do
	for col = 1, gridSize do
		-- creating pond
		if( col > (gridSize - bayL)) then
			if (row >= (mapHalfSize - bayW) and row <= (mapHalfSize + bayW)) then
				terrainLayoutResult[row][col].terrainType = baseLakeTerrain
			end
		end
	end
end

-- generating a base layout
for row = 1, gridSize do
	terrainLayoutResult[row][4].terrainType = tt_stealth_natural_small
end

 -- creating "belt" impasse
for row = 1, gridSize do
	terrainLayoutResult[row][1].terrainType = tt_lake_side_impasse_mountains
end

 -- creating "belt" of stone & gold
for beltIterations = 0, (1 + mapSizeModifier) do
	terrainLayoutResult[mapHalfSize - (beltIterations*2) - 1][2].terrainType = tt_gold_large
	terrainLayoutResult[mapHalfSize + (beltIterations*2) + 1][2].terrainType = tt_gold_large
end

-- creating "belt" of cute deer (don't eat them please)
for beltIterations = 0, (1 + mapSizeModifier) do
	terrainLayoutResult[mapHalfSize - (beltIterations*2) - 1][3].terrainType = tt_deer_herd_small
	terrainLayoutResult[mapHalfSize - (beltIterations*2) - 2][3].terrainType = tt_deer_herd_small
	terrainLayoutResult[mapHalfSize + (beltIterations*2) + 1][3].terrainType = tt_deer_herd_small
	terrainLayoutResult[mapHalfSize + (beltIterations*2) + 2][3].terrainType = tt_deer_herd_small
end
-- large deer pack at the edges
terrainLayoutResult[mapHalfSize - ((1 + mapSizeModifier)*2) - 2][3].terrainType = tt_deer_herd_large
terrainLayoutResult[mapHalfSize + ((1 + mapSizeModifier)*2) + 2][3].terrainType = tt_deer_herd_large

-- Adding berries and trees
for i = 0, (math.floor(playerAmount/2) - 1) do
	terrainLayoutResult[1][5].terrainType = tt_forest_circular_medium
	terrainLayoutResult[2 + i][5].terrainType = tt_berries_small_single
	terrainLayoutResult[gridSize][5].terrainType = tt_forest_circular_medium
	terrainLayoutResult[gridSize - 1 - i][5].terrainType = tt_berries_small_single
end
-- corner side gold and stone
	terrainLayoutResult[1][2].terrainType = tt_stone_small_single
	terrainLayoutResult[2][2].terrainType = tt_gold_small_single
	terrainLayoutResult[gridSize][2].terrainType = tt_stone_small_single
	terrainLayoutResult[gridSize - 1][2].terrainType = tt_gold_small_single

-- creating corner trees
for row = 1, gridSize do
	for col = 1, gridSize do
		if( col == gridSize and row == gridSize or col == gridSize and row == 1) then
			terrainLayoutResult[row][col].terrainType = tt_impasse_trees_plains 
			-- adding 2ndry gold for a 1v1 match
			if (worldPlayerCount == 2) then
					terrainLayoutResult[row][col - 1].terrainType = tt_gold_tiny
			end
		end
	end
end



-- central stone
	terrainLayoutResult[mapHalfSize][4].terrainType = tt_lake_side_stone_large

-- adding cliffs in both sides
for col = gridSize - bayL + 1, (gridSize - 1) do
	terrainLayoutResult[mapHalfSize - bayW - 1][col].terrainType = tt_mountains_small
	terrainLayoutResult[mapHalfSize - bayW - 2][col].terrainType = tt_hills_low_rolling

	terrainLayoutResult[mapHalfSize + bayW + 1][col].terrainType = tt_mountains_small
	terrainLayoutResult[mapHalfSize + bayW + 2][col].terrainType = tt_hills_low_rolling
end

-- Adding cliff valley
for row = mapHalfSize - 2, mapHalfSize + 2 do
	terrainLayoutResult[row][2].terrainType = tt_valley_smooth
end

-- Adding fishable valley
for row = mapHalfSize - bayW, mapHalfSize + bayW do
	terrainLayoutResult[row][gridSize - bayL].terrainType = tt_lake_side_shore
end

-- adding "valley notches" at the bay entrance
	terrainLayoutResult[mapHalfSize + bayW + 1][gridSize].terrainType = tt_lake_side_base_shore
	terrainLayoutResult[mapHalfSize + bayW + 1][gridSize - 1].terrainType = tt_lake_side_base_shore
	terrainLayoutResult[mapHalfSize + bayW + 1][gridSize - 2].terrainType = tt_lake_medium_fish_single_precise
	terrainLayoutResult[mapHalfSize - bayW - 1][gridSize].terrainType = tt_lake_side_base_shore
	terrainLayoutResult[mapHalfSize - bayW - 1][gridSize - 1].terrainType = tt_lake_side_base_shore
	terrainLayoutResult[mapHalfSize - bayW - 1][gridSize - 2].terrainType = tt_lake_medium_fish_single_precise

-- adding sacred sites
	terrainLayoutResult[mapHalfSize][gridSize - bayL - 2 - mapSizeModifier].terrainType = tt_holy_site_hill_low
	terrainLayoutResult[mapHalfSize][2].terrainType = tt_lake_side_holy_site

-- naval settlement
	terrainLayoutResult[mapHalfSize][gridSize - bayL].terrainType = tt_lake_side_settlement
-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------
	teamsList, playersPerTeam = SetUpTeams()

--The Team Mapping Table 
	teamMappingTable = CreateTeamMappingTable()
	
-- minimal distance of same team mates from each other
minPlayerDistance = 3.5
if(playerAmount > 4 ) then
	minPlayerDistance = 2.5
end

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.
	minTeamDistance = 6

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
 	edgeBuffer = 0.5

--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
	innerExclusion = 0.4

--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
	cornerThreshold = 2

--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. It will ensure that players are not placed on or
--adjacent to squares in this list
	impasseTypes = {}
	table.insert(impasseTypes, tt_lake_side_impasse_mountains)
	table.insert(impasseTypes, baseLakeTerrain)
	table.insert(impasseTypes, tt_lake_side_holy_site)
	table.insert(impasseTypes, tt_holy_site_hill_low)


--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
	impasseDistance = 2

--topSelectionThreshold is how strict you want to be on allies being grouped as 
	topSelectionThreshold = 0.12

--startBufferTerrain is the terrain that can get placced around player spawns
	startBufferTerrain = tt_hills_low_rolling

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
	startBufferRadius = 2

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
	placeStartBuffer = false

--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)

local function PlaceTeamStarts()
	print(">> DEBUG: entering PlaceTeamStarts Function")
	local playerColPos
	local playerRowPos
	ShuffleAllTeamsIndexes(teamMappingTable) -- shuffling indexes for randomization
	-- iterates once for every player in both teams (i=2 means 2nd player in both teams)
	for i = 1, #teamMappingTable[1].players do
		playerColPos = gridSize - 5 + math.ceil(mapSizeModifier/2) - ((i-1)*3)
		playerRowPos = 2 + math.ceil(mapSizeModifier/2)
		if (i == #teamMappingTable[1].players) then
			playerRowPos = 3 + math.ceil(mapSizeModifier/2)
		end
		terrainLayoutResult[playerRowPos][playerColPos].playerIndex = teamMappingTable[1].players[i].playerID - 1
		
		-- using generic start terrain if there is only 1 player on the team.
		terrainLayoutResult[playerRowPos][playerColPos].terrainType = playerStartTerrain
		
	end
	-- 2nd team
	for i = 1, #teamMappingTable[2].players do
		-- placing the player with a bit of variance on the X axis
		-- row =mapHalfSize and col = 1 or col = gridSize  is the first player spawn of each team
		playerColPos = gridSize -  5 + math.ceil(mapSizeModifier/2) - ((i-1)*3)
		playerRowPos = gridSize - 1 - math.ceil(mapSizeModifier/2)
		if (i == #teamMappingTable[2].players) then
			playerRowPos = gridSize - 2 - math.ceil(mapSizeModifier/2)
		end
		terrainLayoutResult[playerRowPos][playerColPos].playerIndex = teamMappingTable[2].players[i].playerID - 1
		
		-- using generic start terrain if there is only 1 player on the team.
		terrainLayoutResult[playerRowPos][playerColPos].terrainType = playerStartTerrain
		
	end
end

-- placing players across a lane, if it is a 2 teams game. Otherwise placing them in a "ring" while avoiding certain terrain features.
if  (#teamMappingTable == 2 ) then 
	PlaceTeamStarts()
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
end

function AddTcRes()
	-- Getting players starting locations and spawning woodlines behind them when using generic start terrain.
	for row = 1, gridSize do
		for col = 1, gridSize do
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				if(row < mapHalfSize) then
					terrainLayoutResult[row - 1][col - 1].terrainType = tt_forest_circular_medium
					terrainLayoutResult[row][col - 1].terrainType = tt_gold_tiny
				else
					terrainLayoutResult[row + 1][col - 1].terrainType = tt_forest_circular_medium
					terrainLayoutResult[row][col - 1].terrainType = tt_gold_tiny
				end
			end
		end
	end
	
end

 AddTcRes()