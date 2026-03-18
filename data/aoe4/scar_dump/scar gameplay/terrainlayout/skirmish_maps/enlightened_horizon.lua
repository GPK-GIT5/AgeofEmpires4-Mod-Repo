-- Copyright 2025 SEGA Corporation, Developed by Relic Entertainment
terrainLayoutResult = {}    -- set up initial table for coarse map grid

-- Players base terrain
playerStartTerrain = tt_player_start_enlightened_horizon

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

gridSize = gridSize + 2 -- Base grid size slightly larger to allow for better resolutions
-- normalizing grid for larger maps to leave room for contested areas
if (worldTerrainWidth >= 512) then
	gridSize = gridSize + 4 --Will apply for larger map sizes > micro
end 

--BASIC MAP SETUP-------------------------------------------------------------------------------------------------

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

baseGridSize = 13
mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.floor(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)


-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------
teamsList, playersPerTeam = SetUpTeams()

--teamMappingTable[teamIndex].players[playerIndex].playerID
teamMappingTable = CreateTeamMappingTable()
	

--Making this number larger will give more space between every player, even those on the same team.
minPlayerDistance = 3.5
if(worldPlayerCount > 5) then
	minTeamDistance = 4.5
end
--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.

minTeamDistance = 6.5
if(worldPlayerCount > 5) then
	minTeamDistance = 5.5
end

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
table.insert(impasseTypes, tt_settlement_plains)
table.insert(impasseTypes, tt_enlightened_horizon_holy_site)
table.insert(impasseTypes, tt_rock_spire)
table.insert(impasseTypes, tt_plateau_spire)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 3.5

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_hills_high_rolling

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 1

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = true

--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)

function isInBounds(x, y)
    return x >= 1 and y >= 1 and x <= gridSize and y <= gridSize
end

function clampToBounds(x, y)
    if x < 1 then x = 1 elseif x > gridSize then x = gridSize end
    if y < 1 then y = 1 elseif y > gridSize then y = gridSize end
    return x, y
end

function SafeSetTerrainLayout(x, y, value)
	-- bring the point inside the bounds to avoid game crash!
	x, y = clampToBounds(x, y)
	
	-- check if the chosen tile is not already set
	if terrainLayoutResult[x][y].terrainType == 0 then
		
		-- all good we can set and return
		terrainLayoutResult[x][y].terrainType = value
		return
	else
		-- we need to find a non-zero point close by
		-- to keep code simply just try 8 positions nearby
		local tryPositions = {{-1, 0}, {-1, -1}, {0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}}
		
		for _, dir in ipairs(tryPositions) do
			local nx = x + dir[1]
			local ny = y + dir[2]
			
			if isInBounds(nx, ny) and terrainLayoutResult[nx][ny].terrainType == 0 then
				terrainLayoutResult[nx][ny].terrainType = value
				return
			end				
		end
		
		--if for failed there is no solution
		
	end
end

function ResourceNode(xRow, yCol)
	SafeSetTerrainLayout(xRow, yCol, tt_eo_forest_circular_medium_clearing)
	
	-- placing golds further from midpoint
	if (yCol > mapHalfSize) then
		SafeSetTerrainLayout(xRow, yCol + 1, tt_gold_tiny)
		SafeSetTerrainLayout(xRow, yCol - 1, tt_stone_small_single)
	else
		SafeSetTerrainLayout(xRow, yCol - 1, tt_gold_tiny)
		SafeSetTerrainLayout(xRow, yCol + 1, tt_stone_small_single)
	end
	
	-- deer and berries
	SafeSetTerrainLayout(xRow - 1, yCol, tt_deer_herd_large)

	if (yCol > mapHalfSize) then 
		SafeSetTerrainLayout(xRow - 2, yCol + 1, tt_berries_small_single)
	else 
		SafeSetTerrainLayout(xRow - 2, yCol - 1, tt_berries_small_single)
	end
	
	SafeSetTerrainLayout(xRow + 1, yCol, tt_berries_small_single)
end

function EnlightenedSpire(xRow, yCol, ffa)
	terrainLayoutResult[xRow][yCol].terrainType = tt_enlightened_ofek_spire
	if (ffa == false) then
		terrainLayoutResult[xRow + 1][yCol].terrainType = tt_mountains 
		terrainLayoutResult[xRow + 2][yCol].terrainType = tt_poi_ronin_hills_high 
		terrainLayoutResult[xRow + 3][yCol].terrainType = tt_hills_low_rolling
		
		-- sites
		terrainLayoutResult[xRow][yCol + 1].terrainType = tt_enlightened_horizon_holy_site
		terrainLayoutResult[xRow][yCol - 1].terrainType = tt_enlightened_horizon_holy_site
		terrainLayoutResult[xRow - 2][yCol].terrainType = tt_enlightened_horizon_holy_site_top
	else
		terrainLayoutResult[xRow + 1][yCol].terrainType = tt_enlightened_horizon_holy_site
		terrainLayoutResult[xRow][yCol + 1].terrainType = tt_enlightened_horizon_holy_site
		terrainLayoutResult[xRow][yCol - 1].terrainType = tt_enlightened_horizon_holy_site
		terrainLayoutResult[xRow - 1][yCol].terrainType = tt_enlightened_horizon_holy_site
	end
	
		
	
end

-- Function may only be called in non FFA scenarios
local function GoldHeap(xRow, yCol)
	
	if (xRow < 1) or (xRow + 3 > gridSize) then 
		return
	end
	
	if (yCol < mapHalfSize) then
		-- Upper golds
		for row = xRow, xRow + 2 do
			for col = 1, 3 do
				terrainLayoutResult[row][col].terrainType = tt_hills_med_rolling
			end
		end
		terrainLayoutResult[xRow + 1][2].terrainType = tt_gold_large_single
		terrainLayoutResult[xRow + 2][3].terrainType = tt_plateau_med
		terrainLayoutResult[xRow + 2][4].terrainType = tt_settlement_plains
		terrainLayoutResult[xRow + 3][4].terrainType = tt_poi_wolf_den
		
		else
		-- Upper golds
	for row = xRow, xRow + 2 do
		for col = 0, 2 do
			terrainLayoutResult[row][gridSize - col].terrainType = tt_hills_med_rolling
		end
	end
	terrainLayoutResult[xRow + 1][gridSize - 1].terrainType = tt_gold_large_single
	terrainLayoutResult[xRow + 2][gridSize - 2].terrainType = tt_plateau_med
	terrainLayoutResult[xRow + 2][gridSize - 3].terrainType = tt_settlement_plains
	terrainLayoutResult[xRow + 3][gridSize - 3].terrainType = tt_poi_wolf_den
		
	end
end

local function PlaceTeamStarts()
	print(">> DEBUG: entering PlaceTeamStarts Function")
	ShuffleAllTeamsIndexes(teamMappingTable) -- shuffling indexes for randomization
	-- iterates once for every player in both teams (i=2 means 2nd player in both teams)
	for i = 1, #teamMappingTable[1].players do
		-- placing the player with a bit of variance 
		
		playerColPos = mapHalfSize - 3 - ((i-1)*1)
		playerRowPos = gridSize - math.ceil(worldPlayerCount/2) - ((i-1)*4)
		
		playerRowPos, playerColPos = clampToBounds(playerRowPos, playerColPos)
		
		-- back resources for non FFA
		ResourceNode(playerRowPos, playerColPos - 3)
		
		if(i == #teamMappingTable[1].players) then
			SafeSetTerrainLayout(playerRowPos - 3, playerColPos, tt_poi_merchant)
		else
			SafeSetTerrainLayout(playerRowPos - 2, playerColPos + 1, tt_poi_merchant)
		end
		
		-- init player index and terrain
		terrainLayoutResult[playerRowPos][playerColPos].playerIndex = teamMappingTable[1].players[i].playerID - 1
		terrainLayoutResult[playerRowPos][playerColPos].terrainType = playerStartTerrain
			
	end
	-- 2nd team
	for i = 1, #teamMappingTable[2].players do
		-- placing the player with a bit of variance on the X axis
		-- row =mapHalfSize and col = 1 or col = gridSize  is the first player spawn of each team
		playerColPos = mapHalfSize + 3 + ((i-1)*1)
		playerRowPos = gridSize - math.ceil(worldPlayerCount/2) - ((i-1)*4)
		
		playerRowPos, playerColPos = clampToBounds(playerRowPos, playerColPos)
		
		-- back resources for non FFA
		ResourceNode(playerRowPos, playerColPos + 3)
		
		if(i == #teamMappingTable[2].players) then
			SafeSetTerrainLayout(playerRowPos - 3, playerColPos, tt_poi_merchant)
		else
			SafeSetTerrainLayout(playerRowPos - 2, playerColPos - 1, tt_poi_merchant)
		end
		
		-- init player index and terrain
		terrainLayoutResult[playerRowPos][playerColPos].playerIndex = teamMappingTable[2].players[i].playerID - 1
		terrainLayoutResult[playerRowPos][playerColPos].terrainType = playerStartTerrain
		
		-- relics between players
		SafeSetTerrainLayout(playerRowPos, mapHalfSize, tt_plains_wrelic)
		SafeSetTerrainLayout(playerRowPos - 1, mapHalfSize, tt_plains_wrelic)
	end
	-- extra golds if player count is high
	if(worldPlayerCount >= 2) then
		GoldHeap(1,1)
		GoldHeap(1,gridSize - 2)
	end
	if(worldPlayerCount >= 6) then
		GoldHeap(4,1)
		GoldHeap(4,gridSize - 2)
	end
	--outpost
	terrainLayoutResult[gridSize][mapHalfSize].terrainType = tt_poi_abandoned_outpost
	
end

-- placing players using 2 functions depending on FFA / team vs team
if  (#teamMappingTable == 2 ) then 
	print(">>DEBUG: 2 teams are in the game")
	
	EnlightenedSpire(4, mapHalfSize, false)
	PlaceTeamStarts()
else
	EnlightenedSpire(mapHalfSize, mapHalfSize, true)
	playerStartTerrain = tt_player_start_enlightened_horizon_ffa
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
	
end

function AddTcStart()
	-- Getting players starting locations and spawning res behind them when using generic start terrain
	
	startLocationPositions = {}
	for row = 1, gridSize do
		for col = 1, gridSize do
			currentData = {}
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				currentData = { x = row, y = col}
				table.insert(startLocationPositions, currentData)
				
				basePlateau = tt_plateau_med
				baseForest = tt_forest_circular_medium
				-- surrounding player base with hills
				for i = 1, 3 do
					for j = 1, 3 do
						terrainLayoutResult[row - 2 + i][col - 2 + j].terrainType = tt_hills_med_rolling
					end
				end
				terrainLayoutResult[row][col].terrainType = playerStartTerrain
				
				-- adding markets behind the players
				if(col > mapHalfSize and row <= mapHalfSize) then
					terrainLayoutResult[row][col - 1].terrainType = basePlateau
					terrainLayoutResult[row + 1][col - 1].terrainType = basePlateau
					terrainLayoutResult[row + 1][col].terrainType = basePlateau
					
					terrainLayoutResult[row - 1][col + 1].terrainType = baseForest
					terrainLayoutResult[row + 2][col].terrainType = baseForest
				end
				if(row > mapHalfSize and col > mapHalfSize) then
					terrainLayoutResult[row - 1][col].terrainType = basePlateau
					terrainLayoutResult[row - 1][col - 1].terrainType = basePlateau
					terrainLayoutResult[row][col - 1].terrainType = basePlateau
					
					terrainLayoutResult[row + 1][col + 1].terrainType = baseForest
					terrainLayoutResult[row - 2][col].terrainType = baseForest
				end
				if(col <= mapHalfSize and row > mapHalfSize) then
					terrainLayoutResult[row][col + 1].terrainType = basePlateau
					terrainLayoutResult[row - 1][col + 1].terrainType = basePlateau
					terrainLayoutResult[row - 1][col].terrainType = basePlateau
					
					terrainLayoutResult[row + 1][col - 1].terrainType = baseForest
					terrainLayoutResult[row - 2][col].terrainType = baseForest
				end
				if(row <= mapHalfSize and col <= mapHalfSize) then
					terrainLayoutResult[row + 1][col].terrainType = basePlateau
					terrainLayoutResult[row + 1][col + 1].terrainType = basePlateau
					terrainLayoutResult[row][col + 1].terrainType = basePlateau
					
					terrainLayoutResult[row - 1][col - 1].terrainType = baseForest
					terrainLayoutResult[row + 2][col].terrainType = baseForest
				end
			end
		end
	end
	
end

AddTcStart()