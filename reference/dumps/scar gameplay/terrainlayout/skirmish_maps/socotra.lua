print ("TESTING SOCOTRA LUA")
terrainLayoutResult = {}    -- set up initial table for coarse map grid
baseGridSize = 13 -- DO NOT CHANGE
mapSize = 13 -- chnage according to your map size, increases the amount of tt squares yet NOT meters!
mapSizeMultiplier = mapSize / baseGridSize -- relative size to normal map. 0.5 = 50%, 2 = 200%, 2.4 = 240%
gridRes = mapSize
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(gridRes)

gridSize = mapSize
gridWidth = mapSize
gridHeight = mapSize

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end

--set the number of players. this info is grabbed from the lobby
playerStarts = worldPlayerCount

gridSize = gridWidth

if(worldTerrainHeight  > 416) then
		gridSize = gridSize + 4
		
	if(worldTerrainHeight  > 512) then
		gridSize = gridSize + 2
	end
		
	if(worldTerrainHeight  > 640) then
		gridSize = gridSize + 2
	end
		
	if(worldTerrainHeight  > 768) then
		gridSize = gridSize + 2
	end
		
end 
-- MAP SETUP-------------------------------------------------------------------------------------------------

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

mapMidPoint = math.ceil(gridSize / 2)


--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

baseTerrainLayout = tt_hills_gentle_rolling
waterTerrainType = tt_ocean
-- generating a base layout
for row = 1, gridSize do
	for col = 1, gridSize do
		terrainLayoutResult[row][col].terrainType = baseTerrainLayout
		--small chance to stealth
		if worldGetRandom() < 0.4 then
			terrainLayoutResult[row][col].terrainType = tt_socotra_stealth_natural_small
		end
	end
end

--setting the distance the island and tree ring starts from the edge
enclosureSize = (2 * mapSizeMultiplier)
if(worldTerrainHeight  > 512) then
	enclosureSize = enclosureSize + 1
end
if(worldTerrainHeight  > 640) then
	enclosureSize = enclosureSize + 1
end
waterdistance = mapHalfSize - math.floor(enclosureSize) -- distance from the center of the island to the water
--Here's a basic loop that will iterate through all squares in your map
for row = 1, gridSize do
	for col = 1, gridSize do
	
	--surrounding  outer tiles with water
		if(col <= enclosureSize or col > (gridSize-enclosureSize) or row <= enclosureSize or row > (gridSize -enclosureSize)) then
				terrainLayoutResult[row][col].terrainType = waterTerrainType
		end
		
	end
end
-- central relics
terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = tt_socotra_boar --tt_relics_valley_danger

-- central forests
	terrainLayoutResult[mapHalfSize ][mapHalfSize - 1].terrainType = tt_forest_circular_large
	terrainLayoutResult[mapHalfSize ][mapHalfSize + 1].terrainType = tt_forest_circular_large
--[[
if worldGetRandom() > 0.5 then
	terrainLayoutResult[mapHalfSize + 1][mapHalfSize + 2].terrainType = tt_forest_circular_large
	terrainLayoutResult[mapHalfSize - 1][mapHalfSize - 2].terrainType = tt_forest_circular_large
else
	terrainLayoutResult[mapHalfSize + 1][mapHalfSize - 2].terrainType = tt_forest_circular_large
	terrainLayoutResult[mapHalfSize - 1][mapHalfSize + 2].terrainType = tt_forest_circular_large
end
--]]
-- deer
if worldGetRandom() > 0.5 then
	terrainLayoutResult[mapHalfSize + 1][mapHalfSize - 2].terrainType = tt_plains_deer_large_single
	terrainLayoutResult[mapHalfSize - 1][mapHalfSize + 2].terrainType = tt_plains_deer_large_single
	
	terrainLayoutResult[mapHalfSize + 2][mapHalfSize + 2].terrainType = tt_plains_deer_small_single
	terrainLayoutResult[mapHalfSize - 2][mapHalfSize - 2].terrainType = tt_plains_deer_small_single
else
	terrainLayoutResult[mapHalfSize + 1][mapHalfSize + 2].terrainType = tt_plains_deer_large_single
	terrainLayoutResult[mapHalfSize - 1][mapHalfSize - 2].terrainType = tt_plains_deer_large_single
	
	terrainLayoutResult[mapHalfSize + 2][mapHalfSize - 2].terrainType = tt_plains_deer_small_single
	terrainLayoutResult[mapHalfSize - 2][mapHalfSize + 2].terrainType = tt_plains_deer_small_single
end
	

-- central sites and nearby relics
terrainLayoutResult[mapHalfSize][mapHalfSize + 3].terrainType = tt_holy_site_hill_low
terrainLayoutResult[mapHalfSize][mapHalfSize - 3].terrainType = tt_holy_site_hill_low

terrainLayoutResult[mapHalfSize + 1][mapHalfSize + 3].terrainType = tt_relic_spawner
terrainLayoutResult[mapHalfSize - 1][mapHalfSize + 3].terrainType = tt_relic_spawner
terrainLayoutResult[mapHalfSize - 1][mapHalfSize - 3].terrainType = tt_relic_spawner
terrainLayoutResult[mapHalfSize + 1][mapHalfSize - 3].terrainType = tt_relic_spawner
-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------

teamsList, playersPerTeam = SetUpTeams()

--The Team Mapping Table is created from the info in the lobby. It is a table containing each team and which players make them up.
teamMappingTable = CreateTeamMappingTable()

--condensing map features to fit more teams


--minPlayerDistance is the closest that any 2 players can be, in absolute distance based on the resolution of your grid.
minPlayerDistance = 1.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.
minTeamDistance = 3.5

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = 2

--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
--setting this to 0.4 will mean that the middle 40% of squares will not be eligable for spawning (so imagine the centre point, and 20% of the map size in all directions)
innerExclusion = 0.2

--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 2

--playerStartTerrain is the terrain type containing the standard distribution of starting resources. If you make a custom set of starting resources, 
--and have them set as a local distribution on your own terrain type, use that here

if(#teamMappingTable  == 2) then
	playerStartTerrain = tt_socotra_player_start
else
	playerStartTerrain = tt_socotra_player_start_ffa
end

--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. It will ensure that players are not placed on or
--adjacent to squares in this list
impasseTypes = {}
table.insert(impasseTypes, tt_ocean)
--table.insert(impasseTypes, tt_river)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 1

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
--locations will expand, and further locations may be chosen. I like to keep this number very small, as in the case of 0.02, it will take the top 2% of spawn options only.
topSelectionThreshold = 0.03 

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = baseTerrainLayout

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 1

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = false

	--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)

--[[
if(#teamMappingTable ~= 2 or #teamMappingTable[1].players ~= #teamMappingTable[2].players) then
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
else
	PlaceMirroredTeam()
end
--]]


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
				terrainLayoutResult[mapHalfSize - waterdistance + teamCount + 1][mapHalfSize + offSetStart - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
				terrainLayoutResult[mapHalfSize - waterdistance + teamCount + 1][mapHalfSize + offSetStart - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[1].players[i].playerID - 1
				
				-- Team 2
				terrainLayoutResult[mapHalfSize + waterdistance - teamCount - 1][mapHalfSize + offSetStart - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
				terrainLayoutResult[mapHalfSize + waterdistance - teamCount - 1][mapHalfSize + offSetStart - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[2].players[i].playerID - 1
			else
			
				-- Pocket civs
				-- Team 1
				terrainLayoutResult[mapHalfSize - waterdistance + 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
				terrainLayoutResult[mapHalfSize - waterdistance + 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[1].players[i].playerID - 1
				
				-- Team 2
				terrainLayoutResult[mapHalfSize + waterdistance - 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
				terrainLayoutResult[mapHalfSize + waterdistance - 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[2].players[i].playerID - 1
			
			end
		else
			-- Team 1
			terrainLayoutResult[mapHalfSize - waterdistance + 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
			terrainLayoutResult[mapHalfSize - waterdistance + 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[1].players[i].playerID - 1
			
			-- Team 2
			terrainLayoutResult[mapHalfSize + waterdistance - 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].terrainType = playerStartTerrain
			terrainLayoutResult[mapHalfSize + waterdistance - 2][mapHalfSize - ((teamCount-1)*2) + ((i-1)*4)].playerIndex = teamMappingTable[2].players[i].playerID - 1
				
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
				--back gold
				if(#teamMappingTable  == 2) then
					terrainLayoutResult[row - 1][col].terrainType = tt_socotra_gold_small
				else
					-- starting terrain should contain FFA gold
				end
				
				-- trees
				if worldGetRandom() > 0.5 then
					terrainLayoutResult[row][col + 1].terrainType = tt_forest_circular_medium
				else
					terrainLayoutResult[row][col - 1].terrainType = tt_forest_circular_medium
				end
				terrainLayoutResult[row + 1][col].terrainType = tt_forest_circular_small
			else
				--back gold
				if(#teamMappingTable  == 2) then
					terrainLayoutResult[row + 1][col].terrainType = tt_socotra_gold_small
				else
					-- starting terrain should contain FFA gold
				end

				-- trees
				if worldGetRandom() > 0.5 then
					terrainLayoutResult[row][col + 1].terrainType = tt_forest_circular_medium
				else
					terrainLayoutResult[row][col - 1].terrainType = tt_forest_circular_medium
				end
					terrainLayoutResult[row - 1][col].terrainType = tt_forest_circular_small
			end
		end
	end
end
