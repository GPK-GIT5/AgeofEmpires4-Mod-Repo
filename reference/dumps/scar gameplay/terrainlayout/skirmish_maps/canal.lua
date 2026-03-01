-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

terrainLayoutResult = {}    -- set up initial table for coarse map grid
print("Canal MAPGEN script starting")

gridHeight, gridWidth, gridSize = SetCoarseGrid()

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = 13 -- set resolution of coarse map


--set the number of players. this info is grabbed from the lobby
playerStarts = worldPlayerCount

-- MAP SETUP
--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

baseGridSize = 13
mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8) -- 
mapTenthSize = math.floor(gridSize/10) -- in this case we want a lower number so we floor instead of ceil

--do map specific stuff around here
baseTerrain = tt_plains_clearing
highTerrain = tt_plateau_med


-- Team 1
for i = 1, 5 do
	for j = 1, (6-i) do
		terrainLayoutResult[j][i].terrainType = baseTerrain
	end
end
terrainLayoutResult[3][4].terrainType = baseTerrain
terrainLayoutResult[4][3].terrainType = baseTerrain
-- Team 2
for i = 1, 5 do
	for j = 1, (6-i) do
		terrainLayoutResult[1+gridSize-j][1+gridSize-i].terrainType = baseTerrain
	end
end
terrainLayoutResult[10][11].terrainType = baseTerrain
terrainLayoutResult[11][10].terrainType = baseTerrain

sp = 3 -- startpoint of river spxsp



-- Central clearing
for i=1, 5 do
	for j=1, 5 do
		terrainLayoutResult[4+i][4+j].terrainType = tt_plains_clearing
	end
end

-- Sacred sites and extra wood
if worldGetRandom() > 0.5 then
	
	terrainLayoutResult[4][7].terrainType = tt_holy_site
	terrainLayoutResult[10][7].terrainType = tt_holy_site
	
	terrainLayoutResult[7][3].terrainType = tt_forest_circular_large
	terrainLayoutResult[7][11].terrainType = tt_forest_circular_large
	
else
	terrainLayoutResult[7][4].terrainType = tt_holy_site
	terrainLayoutResult[7][10].terrainType = tt_holy_site
	
	terrainLayoutResult[3][7].terrainType = tt_forest_circular_large
	terrainLayoutResult[11][7].terrainType = tt_forest_circular_large
end

-- hills in the 1st corner
for row = gridSize - 2, gridSize do
	for col =1, 3 do
		terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
	end
end

-- hills in the 2nd corner
for row = 1, 3 do
	for col = gridSize - 2, gridSize do
		terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
	end
end

-- sacred sites and nearby market in corners
terrainLayoutResult[gridSize][1].terrainType = tt_holy_site_hill_low
terrainLayoutResult[1][gridSize].terrainType = tt_holy_site_hill_low

terrainLayoutResult[gridSize-2][3].terrainType = tt_settlement_plateau
terrainLayoutResult[3][gridSize-2].terrainType = tt_settlement_plateau

--markets
--[[
if worldGetRandom() > 0.5 then
	terrainLayoutResult[gridSize][3].terrainType = tt_settlement
	terrainLayoutResult[3][gridSize].terrainType = tt_settlement
else
	terrainLayoutResult[gridSize-2][1].terrainType = tt_settlement
	terrainLayoutResult[1][gridSize-2].terrainType = tt_settlement
end
--]]

-- large mineral deposits

depoA = tt_tactical_region_gold_plains_a
depoB = tt_tactical_region_stone_plains_a

if worldGetRandom() > 0.5 then
	terrainLayoutResult[9][2].terrainType = depoA
	terrainLayoutResult[12][5].terrainType = depoB
	
	terrainLayoutResult[2][9].terrainType = depoB
	terrainLayoutResult[5][12].terrainType = depoA
else
	terrainLayoutResult[9][2].terrainType = depoB
	terrainLayoutResult[12][5].terrainType = depoA
	
	terrainLayoutResult[2][9].terrainType = depoA
	terrainLayoutResult[5][12].terrainType = depoB
end

-- more wood
terrainLayoutResult[mapHalfSize-1][mapHalfSize+1].terrainType = tt_forest_circular_medium
terrainLayoutResult[mapHalfSize+1][mapHalfSize-1].terrainType = tt_forest_circular_medium

 -- Setting the distance of rivers from the edge corner of the map, set to scale with map size.
riverEdgeDistance = mapQuarterSize 
if (worldPlayerCount > 2) then
	riverEdgeDistance = riverEdgeDistance + 2
end
-- West river generation
westRiverPoints = DrawLineOfTerrainNoDiagonal(1 + riverEdgeDistance, 1, 1, 1 + riverEdgeDistance, true, tt_river, gridSize, terrainLayoutResult)
westRiverTable = {} -- temp table to hold riverpoints.
for riverPointIndex = 1, #westRiverPoints do
	table.insert(westRiverTable, westRiverPoints[riverPointIndex])
end
riverResult = {} -- river result, GLOBAL var can't be renamed.
--table.insert(riverResult, 1, westRiverTable)

-- East river generation 
eastRiverTable = {} -- temp table to hold riverpoints.
eastRiverPoints = DrawLineOfTerrainNoDiagonal(gridSize-riverEdgeDistance, gridSize, gridSize, gridSize-riverEdgeDistance, true, tt_river, gridSize, terrainLayoutResult)
for riverPointIndex = 1, #eastRiverPoints do
	table.insert(eastRiverTable, eastRiverPoints[riverPointIndex])
end
--table.insert(riverResult, 2, eastRiverTable)

-- Central river generation
centralRiverTable = {} -- temp table to hold riverpoints.
centralRiverPoints = DrawLineOfTerrainNoDiagonal(1 + math.floor( riverEdgeDistance / 2),1 +  math.floor( riverEdgeDistance / 2), gridSize - math.floor( riverEdgeDistance / 2), gridSize - math.floor( riverEdgeDistance / 2),  true, tt_river, gridSize, terrainLayoutResult)
print(">> Debug: central river points are "..1 + math.floor( riverEdgeDistance / 2)..","..1 + math.floor( riverEdgeDistance / 2).." & "..gridSize - math.floor( riverEdgeDistance / 2)..""..gridSize - math.floor( riverEdgeDistance / 2).."")

for riverPointIndex = 1, #centralRiverPoints do
	table.insert(centralRiverTable, centralRiverPoints[riverPointIndex])
end

print(">> Debug: Central river points are "..(1 + math.floor(riverEdgeDistance / 2) ).." & "..(gridSize-math.floor(riverEdgeDistance / 2)).."")

print(">> Debug: other rivers start / end at "..(1 + riverEdgeDistance).." / "..(gridSize-riverEdgeDistance).."")

-- Setting central river as a diagonal line that latches between the two rivers
centralRiverPoints = {}
for i = (1 + math.floor(riverEdgeDistance / 2)), (gridSize-math.floor(riverEdgeDistance / 2)) do
	table.insert(centralRiverPoints, {i,i,})
	-- adding fish
	if ( i > (1 + math.floor(riverEdgeDistance / 2)) and i < (gridSize-math.floor(riverEdgeDistance / 2))) then
		terrainLayoutResult[i][i].terrainType = tt_river_fish
	end
end
	
-- Generating rivers results
riverResult =  
{
	-- River WEST.
	westRiverPoints, 
	-- River EAST.
	eastRiverPoints,
	-- River CENTRAL
	centralRiverPoints
}

-- River splines generation
riverSplines =  
{
	-- Western spline 
	{{riverEdgeDistance,1,},{1,riverEdgeDistance,},}
	-- Eastern spline 
	, {{gridSize,gridSize-riverEdgeDistance,}, {gridSize-riverEdgeDistance,gridSize,},} 
	-- Central spline 
	, {{1 + math.ceil( riverEdgeDistance / 2), 1 + math.ceil(riverEdgeDistance / 2),},{gridSize - math.ceil(riverEdgeDistance / 2), gridSize - math.ceil(riverEdgeDistance / 2),},},	
}

fordResults =  
{
	-- Creating a ford at the center of the map
	{}, {}, {{mapHalfSize, mapHalfSize},},
}



-- SETUP PLAYER STARTS-------------------------------------------------------------------------------------------------

print(">>DEBUG: Setting up teams")
teamsList, playersPerTeam = SetUpTeams()


teamMappingTable = CreateTeamMappingTable()

minPlayerDistance = 2.5

--minTeamDistance is the closest any members of different teams can spawn. Making this number larger will push teams further apart.
minTeamDistance = 6.5
if(#teamMappingTable > 4) then
	minTeamDistance = 4.5
end

--edgeBuffer controls how many grid squares need to be between the player spawns and the edge of the map.
edgeBuffer = 2

--innerExclusion defines what percentage out from the centre of the map is "off limits" from spawning players.
innerExclusion = 0.3

--cornerThreshold is used for making players not spawn directly in corners. It describes the number of squares away from the corner that are blocked from spawns.
cornerThreshold = 1

--playerStartTerrain is the terrain type containing the standard distribution of starting resources. 
playerStartTerrain = tt_player_start_canal_inner_base

--impasseTypes is a list of terrain types that the spawning function will avoid when placing players. 
impasseTypes = {}
table.insert(impasseTypes, tt_holy_site)
table.insert(impasseTypes, tt_mountains)
table.insert(impasseTypes, tt_plateau_med)
table.insert(impasseTypes, tt_holy_site_hill_low)
table.insert(impasseTypes, tt_river_fish)
table.insert(impasseTypes, tt_river)

--impasseDistance is the distance away from any of the impasseTypes that a viable player start needs to be. 
impasseDistance = 2
if(#teamMappingTable > 2) then
	impasseDistance = 1
	edgeBuffer = 1
end

--topSelectionThreshold is how strict you want to be on allies being grouped as closely as possible together. 
topSelectionThreshold = 0.03

--startBufferTerrain is the terrain that can get placced around player spawns. This terrain will stomp over other terrain. We use this to guarantee building space around player starts.
startBufferTerrain = tt_plains

--startBufferRadius is the radius in which we place the startBufferTerrain around each player start
startBufferRadius = 0.5

--placeStartBuffer is a boolean (either true or false) that we use to tell the function to place the start buffer terrain or not. True will place the terrain, false will not.
placeStartBuffer = false

--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)



baseEdge = math.floor(riverEdgeDistance / 2) -- the distance where the base ends and river begins
rndLocation = worldGetRandom() -- will be used as a random figure to determine player location in teams around the base
local function PlaceMirroredTeamStarts()
    -- At this point we know there are exactly two teams of equal size.
	ShuffleAllTeamsIndexes(teamMappingTable) -- shuffling indexes for randomization
    print(">> DEBUG: Placing teams")
	local maxPlayersInTeam = #teamMappingTable[1].players
	if(#teamMappingTable[1].players < #teamMappingTable[2].players) then
		maxPlayersInTeam = #teamMappingTable[2].players
	end
    for i = 1, maxPlayersInTeam do
    
        -- Don't place players completely in the corner, and not directly next to the
        -- middle (since that would imply two enemies would spawn very close together).
		if (i == 1) then
			
			if rndLocation > 0.5 then
				x = gridSize-mapTenthSize
				y = gridSize
			else
				x = gridSize
				y = gridSize-mapTenthSize
			end
			playerStartTerrain = tt_player_start_canal_inner_base
			print(">> DEBUG: P1 Location is "..gridSize.."n1, "..(gridSize-mapTenthSize).." n2. mapTenthSize = "..mapTenthSize)
		end
		
		--player #2 OUTSIDE base
		if (i == 2) then
			if rndLocation > 0.5 then
				x = gridSize-mapQuarterSize+1 --gridSize - baseEdge + 1
				y = gridSize --gridSize - baseEdge - 2
			else
				x =  gridSize --gridSize - baseEdge - 2
				y =  gridSize-mapQuarterSize+1 --gridSize - baseEdge + 1
			end
			 playerStartTerrain = tt_player_start_canal_outer_base
			print(">> DEBUG: P2 Location is "..(gridSize - baseEdge).."n1, "..(gridSize - baseEdge-2).." n2")
			
		end
		-- player #3 inverse location of player 1 inside the base
		if (i == 3) then
			if rndLocation > 0.5 then
				x = gridSize
				y = gridSize-mapTenthSize
			else
				x = gridSize-mapTenthSize
				y = gridSize
			end
			playerStartTerrain = tt_player_start_canal_inner_base
		end
		-- player #4 inverse of player 2 outside base
		if (i == 4) then
			if rndLocation > 0.5 then
				x = gridSize--gridSize - baseEdge - 2
				y = gridSize-mapQuarterSize+1 --gridSize - baseEdge  + 1
			else
				x = gridSize-mapQuarterSize+1 --gridSize - baseEdge + 1
				y = gridSize --gridSize - baseEdge - 2
			end
			playerStartTerrain = tt_player_start_canal_outer_base
		end
		-- Ensuring the script does not go out of the team limit bound
		if(#teamMappingTable[1].players >= i) then
			terrainLayoutResult[x][y].terrainType = playerStartTerrain
        	terrainLayoutResult[x][y].playerIndex = teamMappingTable[1].players[i].playerID - 1
		end
		
        -- Make sure that at least one tile towards the middle is unobstructed.
        
	-- Creating mirrored team
        targetX = gridSize - x + 1
        targetY = gridSize - y + 1
		
		-- Ensuring the script does not go out of the team limit bound
		if(#teamMappingTable[2].players >= i) then
			terrainLayoutResult[targetX][targetY].terrainType = playerStartTerrain
	        terrainLayoutResult[targetX][targetY].playerIndex = teamMappingTable[2].players[i].playerID - 1	
		end
    end
end

-- adding large golds at player's base
if(worldPlayerCount>2) then
	terrainLayoutResult[1+mapTenthSize][1+mapTenthSize].terrainType = tt_gold_large
	terrainLayoutResult[gridSize-mapTenthSize][gridSize-mapTenthSize].terrainType = tt_gold_large
	
	if(worldPlayerCount>6) then
		terrainLayoutResult[mapTenthSize+2][mapTenthSize+2].terrainType = tt_gold_large
		terrainLayoutResult[gridSize-mapTenthSize-1][gridSize-mapTenthSize-1].terrainType = tt_gold_large
	end
end

-- checking if the map spawns with 2 teams or not, using different spawn methods for different amount of teams

if (#teamMappingTable ~= 2 or #teamMappingTable[1].players > 4 or #teamMappingTable[2].players > 4 ) then
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
else
	PlaceMirroredTeamStarts()
end


-- wood start at the corner of the inner base
edgeWood = tt_forest_circular_medium
if (worldPlayerCount > 2) then
	-- increasing wood size in a larger team games
	edgeWood = tt_forest_circular_large
end
	
terrainLayoutResult[1][1].terrainType = edgeWood
terrainLayoutResult[gridSize][gridSize].terrainType = edgeWood


print("Canal map script END")
