-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

terrainLayoutResult = {}    -- set up initial table for coarse map grid
print("Golden Heights MAPGEN script starting")
gridSize = 11 + (worldPlayerCount*4)
gridHeight = gridSize
gridWidth = gridSize


if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth 

playerStarts = worldPlayerCount


--Setting Terrain Layout
terrainLayoutResult = SetUpGrid(gridSize, p, terrainLayoutResult)

--baseGridSize = 13 -- DEPRECATED. currently commenting this out as the game spawns on 1v1 & equal teams without it. But not having this may crash the game on FFAs. Will be further tested later. 

mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--do map specific stuff around here

--Here's a basic loop that will iterate through all squares in your map
for row = 1, gridSize do
	for col = 1, gridSize do
	--filling grid with hills
	terrainLayoutResult[row][col].terrainType = tt_plateau_golden_heights
	end
end


-- Creating lower area connecting the players
startPlainsWidth = math.ceil(4 + (worldPlayerCount/2))

for row = 1, startPlainsWidth do
	for col = 1, gridSize do
		
		if row == startPlainsWidth and col > mapHalfSize then
			-- creating hills leading to the center from player's area
			terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
		else
			terrainLayoutResult[row][col].terrainType = tt_trees_plains_clearing_golden_heights
		end	
	end
end

for col = 1, startPlainsWidth do
	for row = 1, gridSize do
		if col == startPlainsWidth and row > mapHalfSize then
			terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
		else
			terrainLayoutResult[row][col].terrainType = tt_trees_plains_clearing_golden_heights
		end	
	end
end




--------------
-- SPAWNING CENTRAL STEALTH and SACRED SITE
--------------

terrainLayoutResult[mapHalfSize - 1][mapHalfSize - 1].terrainType = tt_holy_site_plateau_low
terrainLayoutResult[mapEighthSize][mapEighthSize].terrainType = tt_holy_site

----------
-- SPAWNING LAKE AT THE EDGE
----------

-- Deeper edge part
lakeSize = math.floor((worldPlayerCount/2) + 2 )-- spread distance of lake from the edge
hillSurround = lakeSize + 2 -- amount of space around the lake


for row = gridSize - hillSurround, gridSize do
	for col = gridSize - hillSurround, gridSize do
		terrainLayoutResult[row][col].terrainType = tt_valley
	end
end

for row = gridSize - hillSurround - 1, gridSize do
	for col = gridSize - hillSurround - 1, gridSize do
		terrainLayoutResult[row][col].terrainType = tt_plains
	end
end

for row = gridSize - hillSurround - 2, gridSize do
	for col = gridSize - hillSurround - 2, gridSize do
		terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
	end
end

for row = (gridSize - lakeSize), gridSize do
	for col = (gridSize - lakeSize), gridSize do
		if row == (gridSize - lakeSize) + 1  and col == (gridSize - lakeSize) + 1 then
			terrainLayoutResult[row][col].terrainType = tt_lake_medium_fish_single
			if worldPlayerCount > 2 then 
				terrainLayoutResult[row][col].terrainType = tt_lake_hill_fish
			end
		elseif row == (gridSize - lakeSize) + 2  and col == (gridSize - lakeSize) +2 then
			terrainLayoutResult[row][col].terrainType = tt_lake_hill_fish
		else
			terrainLayoutResult[row][col].terrainType = tt_lake_shallow
		end
	end
end
-- extra fish for high player count games
if (worldPlayerCount > 4) then 
		terrainLayoutResult[gridSize][gridSize].terrainType = tt_lake_medium_fish_single
	if(worldPlayerCount >= 8) then
			terrainLayoutResult[gridSize][gridSize].terrainType = tt_lake_hill_fish
	end
end




-- SETUP PLAYER STARTS-

teamsList, playersPerTeam = SetUpTeams()

teamMappingTable = CreateTeamMappingTable()
	
--Making this number larger will give more space between every player, even those on the same team.
minPlayerDistance = 3.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.
minTeamDistance = 8.5

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = math.floor((worldPlayerCount/2) + 2)

innerExclusion = 0.4

cornerThreshold = 2


--impasseTypes is a list of terrain types that the spawning function will avoid when placing players.

impasseTypes = {}
table.insert(impasseTypes, tt_holy_site)
table.insert(impasseTypes, tt_trees_plains_clearing_golden_heights)
table.insert(impasseTypes, tt_lake_shallow)
table.insert(impasseTypes, tt_plateau_med)
table.insert(impasseTypes, tt_ocean)
table.insert(impasseTypes, tt_river)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. 
impasseDistance = 2.5
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_hills_low_rolling

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 2

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = true

--playerStartTerrain is the terrain type containing the standard distribution of starting resources. 
playerStartTerrain =  tt_player_start_classic_plains_low_trees

--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)

maxVar = startPlainsWidth
treeVariance = math.ceil(worldGetRandom() * (maxVar-1))
treeDistance = math.floor(worldPlayerCount / 4)
spawnTypes = 2
if worldPlayerCount > 4 then
	-- adding additional player spawn position type for 3v3 games and above
	spawnTypes = 3
end
spawnType = math.ceil(worldGetRandom() * spawnTypes)
spawnTypeT2 = math.ceil(worldGetRandom() * spawnTypes) -- for the 2nd team, used to not mirror lobby placements.
-- placing both teams on different sides 
local function PlaceTeamStarts()
	
	-- iterates once for every player in both teams (i=2 means 2nd player in both teams)
    for i = 1, #teamMappingTable[1].players do
		-- placing the player with a bit of variance on the X axis
		
		
		
		teamDist = 9 - #teamMappingTable[1].players
		x = edgeBuffer
    	y = mapHalfSize + 2 - worldPlayerCount  + ((i-1)*teamDist) 
		
		if i==1 then
			-- placing trees next to cliffs between players
			print("DEBUG: trying to place trees at "..(maxVar + math.floor(maxVar/2) - treeVariance).."x OR "..treeVariance)
			terrainLayoutResult[treeVariance][y - 3 - treeDistance].terrainType = tt_impasse_trees_plains_forest
			terrainLayoutResult[1][y + 3].terrainType = tt_impasse_trees_plains_forest
		elseif i==2 then
			x = gridSize - lakeSize - 9 
			y = gridSize - edgeBuffer 
			playerStartTerrain = tt_player_start_classic_hills
			--terrainLayoutResult[x][y + 3].terrainType = tt_impasse_trees_hills
		elseif i==3 then
			x = mapQuarterSize 
			y =  gridSize - mapQuarterSize + (#teamMappingTable[1].players - 1) 
		elseif i==4 then
			x = mapQuarterSize +  (#teamMappingTable[1].players - 1) + 2
			y = gridSize - mapQuarterSize - 2
		end
		
		-- creating a swappable player start position that is semi-random
        terrainLayoutResult[x][y].terrainType = playerStartTerrain
		if spawnType ==1 then
			terrainLayoutResult[x][y].playerIndex = teamMappingTable[1].players[i].playerID - 1
		elseif spawnType == 2 then
			terrainLayoutResult[x][y].playerIndex = teamMappingTable[1].players[#teamMappingTable[1].players].playerID - i
		elseif spawnType == 3 then
			if i==1 and worldPlayerCount > 4 then
				terrainLayoutResult[x][y].playerIndex = teamMappingTable[1].players[i+1].playerID - 1
			elseif i==2 and worldPlayerCount > 4 then
				terrainLayoutResult[x][y].playerIndex = teamMappingTable[1].players[i-1].playerID - 1
			else
				--print("DEBUG: message should only appear on player count < 4")
				-- player count is less than 4, which means spawn type for 3v3 players isn't applicable. Resuming the mirror players method.
				terrainLayoutResult[x][y].playerIndex = teamMappingTable[1].players[i].playerID - 1
				-- NOTE: This should NEVER even happen since spawn type 3 isn't accesible in 2v2 or smaller games
			end
		end
        print("DEBUG: Player "..teamMappingTable[1].players[i].playerID.." (Team 1) in "..x.."x,"..y.."y")
		
		-- Creating other player's spawn. It will be either mirrored or flipped
		
		teamDist = 9 - #teamMappingTable[2].players
		targetX = mapHalfSize + 2 - worldPlayerCount + ((i-1)*teamDist)
    	targetY = edgeBuffer
	
		if i==1 then
			-- placing trees next to cliffs between players
			terrainLayoutResult[targetX - 3 - treeDistance][treeVariance].terrainType = tt_impasse_trees_plains_forest
			terrainLayoutResult[targetX + 3][1].terrainType = tt_impasse_trees_plains_forest
		elseif i >=2 then
			targetX = y
    		targetY = x
			--terrainLayoutResult[x + 3][y].terrainType = tt_impasse_trees_hills
		end
		
			terrainLayoutResult[targetX][targetY].terrainType = playerStartTerrain
       	 	-- creating a swappable player start position that is semi-random
		if spawnTypeT2 == 1 then
			terrainLayoutResult[targetX][targetY].playerIndex = teamMappingTable[2].players[i].playerID - 1
		elseif spawnTypeT2 == 2 then
			terrainLayoutResult[targetX][targetY].playerIndex = teamMappingTable[2].players[#teamMappingTable[1].players].playerID - i
		elseif spawnTypeT2 == 3 then
			if i==1 and worldPlayerCount > 4 then
				terrainLayoutResult[targetX][targetY].playerIndex = teamMappingTable[2].players[i+1].playerID - 1
			elseif i==2 and worldPlayerCount > 4 then
				terrainLayoutResult[targetX][targetY].playerIndex = teamMappingTable[2].players[i-1].playerID - 1
			else
				-- player count is less than 2, which means spawn type for 3 players isn't applicable. Resuming the 2 players method.
				terrainLayoutResult[targetX][targetY].playerIndex = teamMappingTable[2].players[i].playerID - 1
			end
		end
		print("DEBUG: Player "..teamMappingTable[1].players[i].playerID.." (Team 2) in "..targetX.."x,"..targetY.."y")
    end
end



-- checking which method the players should spawn in ( ring, or custom function for equal teams size.)
if (#teamMappingTable > 1 and  #teamMappingTable[1].players ~=  #teamMappingTable[2].players) or (#teamMappingTable > 2 or #teamMappingTable == 1 or randomPositions == true) then
	print("DEBUG: using PlacePlayerStartsRing method to spawn an uneven teams game")
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
else
	PlaceTeamStarts()
end

---------
-- SPAWNING FORESTS NEAR PLAYERS
---------
-- Getting players starting locations and spawning res nearby
startLocationPositions = {}
for row = 1, gridSize do
    for col = 1, gridSize do
        currentData = {}
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			currentData = { x = row, y = col}
			table.insert(startLocationPositions, currentData)
			
			
			-- Placing trees in the valley towards the other player valley and trees safe behind
			if col >= mapHalfSize - worldPlayerCount then
				--terrainLayoutResult[1][col + 3].terrainType = tt_impasse_trees_plains_forest
				
			elseif row >= mapHalfSize - worldPlayerCount then
				--terrainLayoutResult[row + 3][1].terrainType = tt_impasse_trees_plains_forest
			end
		end
    end
end
-- Placing trees near the cliff
--terrainLayoutResult[3 + math.floor(maxVar/2) - treeVariance][mapHalfSize - 3].terrainType = tt_impasse_trees_plains_forest
--terrainLayoutResult[mapHalfSize - 3][3 + math.floor(maxVar/2) - treeVariance].terrainType = tt_impasse_trees_plains_forest

-- Placing forests at the edge of the map
--terrainLayoutResult[1 + treeVariance][gridSize - 1].terrainType = tt_impasse_trees_plains_forest
--terrainLayoutResult[gridSize - 1][1 + treeVariance].terrainType = tt_impasse_trees_plains_forest

-- trees near the lake
maxLakeTreeVar = 5
lakeTreeVariance = math.floor(worldGetRandom() * maxLakeTreeVar)

if worldPlayerCount <=2 then
	terrainLayoutResult[gridSize - hillSurround - 5 + lakeTreeVariance][gridSize - 1].terrainType = tt_impasse_trees_hills_low_rolling
	terrainLayoutResult[gridSize - 1][gridSize - hillSurround - 5 + lakeTreeVariance].terrainType = tt_impasse_trees_hills_low_rolling
end

-- Trees near the corners on larger players games
if worldPlayerCount >2 then
	terrainLayoutResult[gridSize][1].terrainType = tt_impasse_trees_plains_forest
	terrainLayoutResult[1][gridSize].terrainType = tt_impasse_trees_plains_forest
end

-- placing side market
terrainLayoutResult[1][1].terrainType = tt_settlement_plains




print("Golden Heights MAPGEN script END")

