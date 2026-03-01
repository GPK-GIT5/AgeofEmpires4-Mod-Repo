-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

terrainLayoutResult = {}    -- set up initial table for coarse map grid

-- Players base terrain
playerStartTerrain = tt_moats_player_start

--setting useful variables to reference world dimensions. 
gridHeight, gridWidth, gridSize = SetCoarseGrid()


if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map

gridSize = gridSize * 2

--set the number of players. this info is grabbed from the lobby
playerStarts = worldPlayerCount

if(worldPlayerCount > 2) then
	gridSize = gridSize - 4
end
--BASIC MAP SETUP-------------------------------------------------------------------------------------------------
-- setting up the map grid.

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
baseTerrain = tt_flatland

terrainLayoutResult = SetUpGrid(gridSize, tt_flatland, terrainLayoutResult)

mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.floor(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

-- adding small forest patches scattered around the map
forestSpawn = math.ceil(worldGetRandom() * 11) -- int countdown to spawn a new forest
for row = 1, gridSize do
	for col = 1, gridSize do
		forestSpawn = forestSpawn -1 --countdown
		if (forestSpawn==0) then
			-- spawning a new forest
			terrainLayoutResult[row][col].terrainType = tt_forest_circular_small
			forestSpawn = math.ceil(worldGetRandom() * 5) + 10 -- re initiating var for the next countdown
		end
	end
end

-- adding central market
--terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = tt_settlement_plains

-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------
teamsList, playersPerTeam = SetUpTeams()

--teamMappingTable[teamIndex].players[playerIndex].playerID
teamMappingTable = CreateTeamMappingTable()
	

--Making this number larger will give more space between every player, even those on the same team.
minPlayerDistance = 7.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.

minTeamDistance = 11.5

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = 5

--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
--setting this to 0.4 will mean that the middle 40% of squares will not be eligable for spawning (so imagine the centre point, and 20% of the map size in all directions)
innerExclusion = 0.3


--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 1


--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. It will ensure that players are not placed on or
--adjacent to squares in this list
impasseTypes = {}
table.insert(impasseTypes, tt_forest_natural_large)
table.insert(impasseTypes, tt_plateau_med)
table.insert(impasseTypes, tt_ocean)
table.insert(impasseTypes, tt_river)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. All squares closer than the impasseDistance will
--be removed from the list of squares players can spawn on.
impasseDistance = 1.5

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. If you make this number larger, the list of closest spawn
topSelectionThreshold = 0.02

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_hills_gentle_rolling

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 1

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = false


-- Variables to manipulate players start location
surroundDistance = 3
maxVariance = gridSize - 1 - (surroundDistance * 2) -- Larger number makes the player potentially spawn further from the center between the lakes
xVariance = (worldGetRandom() * maxVariance)
yVariance = (worldGetRandom() * maxVariance)
mapType = math.ceil(worldGetRandom() * 2)

-- Placing players on different sides of the ponds, keeping them the same distance from both ponds / "giving" 1 pond to each
local function PlaceMirroredTeamStarts()
    -- At this point we know there are exactly two teams of equal size.


    for i = 1, #teamMappingTable[1].players do
		-- placing the player with a bit of variance on the X axis
		if(mapType == 1) then
			x = mapHalfSize + math.floor(xVariance) - (math.floor(maxVariance/2))
	        y = gridSize - edgeBuffer
		end
		-- placing the player with a bit of variance on the Y axis
        if(mapType == 2) then
			x =  gridSize - edgeBuffer
	        y = mapHalfSize + math.floor(yVariance) - (math.floor(maxVariance/2))
		end

		if(worldPlayerCount > 2) then
			x = math.ceil(worldGetRandom() * (halfSize - 2))
        	y = math.ceil(worldGetRandom() * (gridSize - 1))
		end
		
        terrainLayoutResult[x][y].terrainType = playerStartTerrain
        terrainLayoutResult[x][y].playerIndex = teamMappingTable[1].players[i].playerID - 1

		-- Creating other player's spawn. It will be either mirrored or flipped
		targetX = gridSize - x + 1  -- flipped
		if worldGetRandom() > 0.5 and mapType == 1 then
			targetX =  x --  mirrored
		end

		targetY = gridSize - y + 1  -- flipped
		if worldGetRandom() > 0.5 and mapType == 2 then
			targetY = y --  mirrored
		end

        terrainLayoutResult[targetX][targetY].terrainType = playerStartTerrain
        terrainLayoutResult[targetX][targetY].playerIndex = teamMappingTable[2].players[i].playerID - 1
    end
end


if(worldPlayerCount == 2) then
	PlaceMirroredTeamStarts()
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)	
end

-- creating unique terrain around the player

for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			print("DEBUG creating terrain around the player")
			for inRow =row-surroundDistance, row+surroundDistance do
				for inCol = col-surroundDistance, col+surroundDistance do
					-- Adding moat
					if  (inRow == (row-surroundDistance) or inRow == (row+surroundDistance)  
							or inCol == (col-surroundDistance) or inCol == (col+surroundDistance))  then
						terrainLayoutResult[inRow][inCol].terrainType = tt_lake_deep
					end
				end
			end
			
			--adding corner forests for the base
			woodPlacement = surroundDistance-2
			terrainLayoutResult[row+woodPlacement][col+woodPlacement].terrainType = tt_moats_forest_natural_tiny
			terrainLayoutResult[row-woodPlacement][col+woodPlacement].terrainType = tt_moats_forest_natural_tiny
			terrainLayoutResult[row+woodPlacement][col-woodPlacement].terrainType = tt_moats_forest_natural_tiny
			terrainLayoutResult[row-woodPlacement][col-woodPlacement].terrainType = tt_moats_forest_natural_tiny
			
			-- adding entrances
			terrainLayoutResult[row+surroundDistance][col].terrainType = tt_stealth_natural_small
			terrainLayoutResult[row-surroundDistance][col].terrainType = tt_stealth_natural_small
			terrainLayoutResult[row][col+surroundDistance].terrainType = tt_stealth_natural_small
			terrainLayoutResult[row][col-surroundDistance].terrainType = tt_stealth_natural_small
			
		end
	end
end
	