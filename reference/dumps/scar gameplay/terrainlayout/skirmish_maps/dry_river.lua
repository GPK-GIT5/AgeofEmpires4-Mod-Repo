-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

terrainLayoutResult = {}    -- set up initial table for coarse map grid


gridHeight, gridWidth, gridSize = SetCoarseGrid()


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
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)
valleyWidth = 2

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.floor(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

-- Base map elevation is a plateau
for row = 1, gridSize do
	for col = 1, gridSize do
		terrainLayoutResult[row][col].terrainType = tt_dry_river_plateau
	end
end

--Creating a central Valley between the players
for row = mapHalfSize-valleyWidth, mapHalfSize+valleyWidth do
	for col = 1, gridSize do
		if row == mapHalfSize or row == mapHalfSize - 1 or row == mapHalfSize + 1 then
			terrainLayoutResult[row][col].terrainType = tt_plains_clearing
		else
			terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
		end
	end
end

-- base tree type
treeType = tt_forest_plateau_low_circular_small
if(worldPlayerCount > 4) then
	treeType = tt_forest_plateau_low_circular_medium
end
-- adding trees near the edge of the valley
print("> DEBUG Trying to add trees general")
for row = mapHalfSize-valleyWidth-1 , mapHalfSize+valleyWidth+1 do
	for col = 1, gridSize do
		if (row == mapHalfSize-valleyWidth-1) or (row == mapHalfSize+valleyWidth+1) then
			treeOffset = math.floor(worldGetRandom() * 2)
			if (col % 2 == 0) then
				if (row > mapHalfSize) then
					terrainLayoutResult[row][col].terrainType = treeType
				else
					terrainLayoutResult[row][col].terrainType = treeType
				end
			end
		end
	end
end



--Central stripe with a mix of stone and berries
valleyResStart = 1 --math.ceil(worldGetRandom() * 2)
for col = 1, gridSize do
	--  chance for small stealth to spawn 
	if worldGetRandom() > 0.3 then
				terrainLayoutResult[mapHalfSize-1][col].terrainType = tt_valley_smooth_stealth
	end
	if worldGetRandom() > 0.3 then
				terrainLayoutResult[mapHalfSize+1][col].terrainType = tt_valley_smooth_stealth
	end
	
end

-- Dry River Gen 5 - 2 (3)
midRiverPoint = math.ceil((mapHalfSize - 2) / 2)
for col = 2, (mapHalfSize-1) do
	terrainLayoutResult[mapHalfSize][col].terrainType = tt_dry_river_pond
end
for col = (mapHalfSize+1), (gridSize-1) do
	terrainLayoutResult[mapHalfSize][col].terrainType = tt_dry_river_pond
end
-- breaking the river at 1/4 and 3/4 of the map with plains
terrainLayoutResult[mapHalfSize][mapHalfSize + midRiverPoint].terrainType = tt_plains_clearing
terrainLayoutResult[mapHalfSize][mapHalfSize - midRiverPoint].terrainType = tt_plains_clearing


-- Adding Sacred Sites beside the Gulch
scaredOffSet = math.ceil(worldGetRandom() * 2) + 3
if worldGetRandom() > 0.5 then
	terrainLayoutResult[mapHalfSize - 2][mapHalfSize - scaredOffSet].terrainType = tt_dry_river_plateau_holy_site
	terrainLayoutResult[mapHalfSize + 2][mapHalfSize + scaredOffSet].terrainType = tt_dry_river_plateau_holy_site
else
	terrainLayoutResult[mapHalfSize + 2][mapHalfSize - scaredOffSet].terrainType = tt_dry_river_plateau_holy_site
	terrainLayoutResult[mapHalfSize - 2][mapHalfSize + scaredOffSet].terrainType = tt_dry_river_plateau_holy_site
end
terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = tt_holy_site

-- adding corner trees
terrainLayoutResult[gridSize-1][gridSize-1].terrainType = treeType
terrainLayoutResult[2][gridSize-1].terrainType = treeType
terrainLayoutResult[gridSize-1][2].terrainType = treeType
terrainLayoutResult[2][2].terrainType = treeType

-- Adding side gold and market
if worldGetRandom() > 0.5 then
	
	-- Markets
	terrainLayoutResult[mapHalfSize - 3][gridSize].terrainType = tt_dry_river_settlement_hills
	terrainLayoutResult[mapHalfSize + 3][1].terrainType = tt_dry_river_settlement_hills
	
	-- Large Gold
	terrainLayoutResult[mapHalfSize - 3][1].terrainType = tt_tactical_region_gold_plateau_low_a
	terrainLayoutResult[mapHalfSize + 3][gridSize].terrainType = tt_tactical_region_gold_plateau_low_a
	
else
	-- 2nd Variation
	-- Markets
	terrainLayoutResult[mapHalfSize - 3][1].terrainType = tt_dry_river_settlement_hills
	terrainLayoutResult[mapHalfSize + 3][gridSize].terrainType = tt_dry_river_settlement_hills
	
	-- Large Gold
	terrainLayoutResult[mapHalfSize - 3][gridSize].terrainType = tt_tactical_region_gold_plateau_low_a
	terrainLayoutResult[mapHalfSize + 3][1].terrainType = tt_tactical_region_gold_plateau_low_a
end


-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------


teamsList, playersPerTeam = SetUpTeams()

--The Team Mapping Table is created from the info in the lobby. It is a table containing each team and which players make them up.
--Formatted as follows if you need to use it for something in your map:
--teamMappingTable[teamIndex].players[playerIndex].playerID
teamMappingTable = CreateTeamMappingTable()
	
--Making this number larger will give more space between every player, even those on the same team.
minPlayerDistance = 2.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.
minTeamDistance = 10.5

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = 1

--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
--setting this to 0.4 will mean that the middle 40% of squares will not be eligable for spawning (so imagine the centre point, and 20% of the map size in all directions)
innerExclusion = 0.4

--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 2

--playerStartTerrain is the terrain type containing the standard distribution of starting resources. If you make a custom set of starting resources, 
--and have them set as a local distribution on your own terrain type, use that here
playerStartTerrain = tt_player_start_dry_river

--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. It will ensure that players are not placed on or
--adjacent to squares in this list
impasseTypes = {}
table.insert(impasseTypes, tt_dry_river_settlement_hills)
table.insert(impasseTypes, tt_tactical_region_gold_plateau_low_a)
table.insert(impasseTypes, tt_dry_river_pond)
table.insert(impasseTypes, tt_dry_river_plateau_holy_site)
table.insert(impasseTypes, tt_plains)
table.insert(impasseTypes, tt_valley_smooth_stealth)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 3.5

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
--locations will expand, and further locations may be chosen. I like to keep this number very small, as in the case of 0.02, it will take the top 2% of spawn options only.
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_plateau_low

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 1

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = true

--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)

-- this function places the players in a certain way in case there are exactly 2 teams


local function PlaceTeamStarts()
	print(">> DEBUG: entering PlaceTeamStarts Function")
	ShuffleAllTeamsIndexes(teamMappingTable) -- shuffling indexes for randomization
	spawnVariation = math.ceil(worldGetRandom() * 2)
	teamPlayerDistance = 3
	
	if(spawnVariation == 1) then
		team1Point = mapHalfSize + (#teamMappingTable[1].players )
		team2Point = mapHalfSize - (#teamMappingTable[2].players )
	else
		team1Point = mapHalfSize - (#teamMappingTable[1].players )
		team2Point = mapHalfSize + (#teamMappingTable[2].players )
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
		
		playerRow = gridSize - edgeBuffer
		if(#teamMappingTable[1].players > 3) then
			playerRow = gridSize - edgeBuffer - 1
		end
		
		if(i==1 and #teamMappingTable[1].players > 1 )then
			-- plaving the first player at the front 
			playerRow = playerRow - (#teamMappingTable[1].players-1)
		end
		terrainLayoutResult[playerRow][playerCol].playerIndex = teamMappingTable[1].players[i].playerID - 1
		
		-- using generic start terrain if there is only 1 player on the team.
		terrainLayoutResult[playerRow][playerCol].terrainType = playerStartTerrain
		print(">> DEBUG: setting additional players location in team 1. row = "..mapHalfSize..", col = "..playerCol..".")
		terrainLayoutResult[playerRow][playerCol].terrainType = playerStartTerrain
			
	end
	-- 2nd team
	for i = 1, #teamMappingTable[2].players do
		-- placing the player with a bit of variance on the X axis
		-- inverse vector from team 1
		if(spawnVariation == 1 )then
			playerCol = team2Point + ((i-1)*teamPlayerDistance)
		else
			playerCol = team2Point - ((i-1)*teamPlayerDistance)
		end
		
		playerRow =  edgeBuffer + 1
		if(#teamMappingTable[2].players > 3) then
			playerRow =  edgeBuffer + 2 
		end
		
		
		if(i==1 and #teamMappingTable[2].players > 1 )then
			-- plaving the first player at the front 
			playerRow = playerRow + (#teamMappingTable[2].players - 1)
		end
		terrainLayoutResult[playerRow][playerCol].playerIndex = teamMappingTable[2].players[i].playerID - 1
		
		print(">> DEBUG: setting additional players location in team 2. row = "..mapHalfSize..", col = "..playerCol..".")
		--spawning side forests beside the player
		terrainLayoutResult[playerRow][playerCol].terrainType = playerStartTerrain
			
		
	end
end

-- placing players across a lane, if it is a 2 teams game
if  #teamMappingTable == 2 --[[ and  #teamMappingTable[1].players > 1]] then 
	print(">>DEBUG: 2 teams are in the game")
	
	PlaceTeamStarts()
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
end
