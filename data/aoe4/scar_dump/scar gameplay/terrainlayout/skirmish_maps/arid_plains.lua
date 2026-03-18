-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
terrainLayoutResult = {}    -- set up initial table for coarse map grid

-- Players base terrain
playerStartTerrain = tt_player_start_arid_plains

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

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

baseGridSize = 13
mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.floor(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--Forests generation

 treeScarcity = 3 -- how often do trees spawn, higher number = scarcer spawn
 forestTerrain = tt_forest_circular_tiny


for row = 1, gridSize do
	for col = 1, gridSize do
		
		--if(worldGetRandom() < 0.5) then
		if((row+col) % treeScarcity == 0 and worldGetRandom() < 0.4) then
			terrainLayoutResult[row][col].terrainType = forestTerrain
		end
	end
end

-- central stealth
terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = tt_stealth_natural_large

-- rock spire, market and valleys around
if(worldGetRandom() < 0.5) then
	for row = 1, 3 do
		for col = 1, 3 do
			terrainLayoutResult[row][col].terrainType = tt_valley_smooth
			terrainLayoutResult[gridSize - row + 1][gridSize-col + 1].terrainType = tt_valley_smooth
		end
	end
	terrainLayoutResult[2][2].terrainType = tt_arid_plains_food_valley
	terrainLayoutResult[gridSize-1][gridSize-1].terrainType = tt_arid_plains_food_valley
	terrainLayoutResult[3][3].terrainType = tt_mountains
	terrainLayoutResult[gridSize-2][gridSize-2].terrainType = tt_mountains
	terrainLayoutResult[4][4].terrainType = tt_settlement_hills
	terrainLayoutResult[gridSize-3][gridSize-3].terrainType = tt_settlement_hills
else
	for row = 1, 3 do
		for col = 1, 3 do
			terrainLayoutResult[gridSize - row + 1][col].terrainType = tt_valley_smooth
			terrainLayoutResult[row][gridSize - col + 1].terrainType = tt_valley_smooth
		end
	end
	terrainLayoutResult[2][gridSize-1].terrainType = tt_arid_plains_food_valley
	terrainLayoutResult[gridSize-1][2].terrainType = tt_arid_plains_food_valley
	terrainLayoutResult[gridSize-2][3].terrainType = tt_mountains
	terrainLayoutResult[3][gridSize-2].terrainType = tt_mountains
	terrainLayoutResult[gridSize-3][4].terrainType = tt_settlement_hills
	terrainLayoutResult[4][gridSize-3].terrainType = tt_settlement_hills
end


-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------
teamsList, playersPerTeam = SetUpTeams()

--teamMappingTable[teamIndex].players[playerIndex].playerID
teamMappingTable = CreateTeamMappingTable()
	

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
table.insert(impasseTypes, tt_settlement_hills)
table.insert(impasseTypes, tt_mountains)
table.insert(impasseTypes, tt_rock_spire)
table.insert(impasseTypes, tt_plateau_spire)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 3.5

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_valley

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 1

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = true

terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)

function AddBackWood()
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
					terrainLayoutResult[row][gridSize].terrainType = tt_forest_circular_large
				elseif(row > mapHalfSize + 3) then
					terrainLayoutResult[gridSize][col].terrainType = tt_forest_circular_large
				elseif(col < mapHalfSize- 3) then
					terrainLayoutResult[row][1].terrainType = tt_forest_circular_large
				elseif(row < mapHalfSize - 3) then
					terrainLayoutResult[1][col].terrainType = tt_forest_circular_large
				end
			end
		end
	end
	
end

AddBackWood()