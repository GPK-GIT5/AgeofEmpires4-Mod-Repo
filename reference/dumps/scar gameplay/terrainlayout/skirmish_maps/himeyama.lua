-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

print('--------- BEGIN: HIMEYAMA ---------')

-------------------------------------------------
--
--
--	GLOBAL AND SCALING VARS
--
--	
-------------------------------------------------

playerHillScale = 25
playerHillSelectionWeight = 0.4

--micro
if (worldTerrainWidth <= 416) then
	centerRegionScale = 45
	centerRegionSelectionWeight = 0.1
	lakeScale = 1
--small
elseif (worldTerrainWidth <= 512) then
	centerRegionScale = 80
	centerRegionSelectionWeight = 0.1
	lakeScale = 2
--medium
elseif (worldTerrainWidth <= 640) then
	centerRegionScale = 100
	centerRegionSelectionWeight = 0.1
	lakeScale = 2
--large
elseif (worldTerrainWidth <= 768) then
	centerRegionScale = 25
	centerRegionSelectionWeight = 0.1
	lakeScale = 3
--gigantic
elseif (worldTerrainWidth <= 896) then
	centerRegionScale = 25
	centerRegionSelectionWeight = 0.1
	lakeScale = 3
end




-------------------------------------------------
--
--
--	TERRAIN TYPES
--
--	
-------------------------------------------------

playerStartTerrain = tt_himeyama_player_start
startBufferTerrain = tt_plateau_med

plateauTerrain = tt_plateau_med
hillTerrain = tt_hills_med
lakeTerrain = tt_lake_shallow
hillsRollingTerrain = tt_hills_low_rolling

settlementTerrain = tt_settlement_plains




-------------------------------------------------
--
--
--	GRID SETUP
--	
--	
-------------------------------------------------

terrainLayoutResult = {}
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(24)

if (gridHeight % 2 == 0) then
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then
	gridWidth = gridWidth - 1
end

gridSize = gridWidth

terrainLayoutResult = SetUpGrid(gridSize, tt_none, terrainLayoutResult)




-------------------------------------------------
--
--
--	MEASUREMENTS
--
--	
-------------------------------------------------

mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)




-------------------------------------------------
--
--
--	SETUP PLAYER STARTS
--	
--	
-------------------------------------------------

impasseTypes = { }
placeStartBuffer = true
playerStarts = worldPlayerCount
startBufferRadius = 2

teamMappingTable = CreateTeamMappingTable()

--micro
if (worldTerrainWidth <= 416) then

    cornerThreshold = 1
    edgeBuffer = 3
    impasseDistance = 0
    innerExclusion = 0.45
    minPlayerDistance = 5
    minTeamDistance = 12
    topSelectionThreshold = 0.02

--small
elseif (worldTerrainWidth <= 512) then
	
    cornerThreshold = 3
    edgeBuffer = 3
    impasseDistance = 0
    innerExclusion = 0.4
    minPlayerDistance = 10
    minTeamDistance = 12
    topSelectionThreshold = 0.02

--medium
elseif (worldTerrainWidth <= 640) then
    
	--medium 2 teams or FFA
    if (#teamMappingTable <= 2 or #teamMappingTable == 6) then
        cornerThreshold = 4
        edgeBuffer = 3
        impasseDistance = 0
        innerExclusion = 0.5
        minPlayerDistance = 11
        minTeamDistance = 12
        topSelectionThreshold = 0.02
    --medium more than 2 teams
	else
        cornerThreshold = 4
        edgeBuffer = 3
        impasseDistance = 0
        innerExclusion = 0.5
        minPlayerDistance = 7
        minTeamDistance = 8
        topSelectionThreshold = 0.02
    end
	
--large
elseif (worldTerrainWidth <= 768) then
    
	--large 2 teams or FFA
    if (#teamMappingTable <= 2 or #teamMappingTable == 8) then
        cornerThreshold = 4
        edgeBuffer = 5
        impasseDistance = 0
        innerExclusion = 0.5
        minPlayerDistance = 7
        minTeamDistance = 8
        topSelectionThreshold = 0.02   
    --large more than 2 teams
	else
        cornerThreshold = 5
        edgeBuffer = 5
        impasseDistance = 0
        innerExclusion = 0.4
        minPlayerDistance = 5
        minTeamDistance = 8
        topSelectionThreshold = 0.02
    end

--gigantic
elseif (worldTerrainWidth <= 896) then
    
	--gigantic 2 teams or FFA
    if (#teamMappingTable <= 2 or #teamMappingTable == 8) then
        cornerThreshold = 4
        edgeBuffer = 6
        impasseDistance = 0
        innerExclusion = 0.5
        minPlayerDistance = 7
        minTeamDistance = 8
        topSelectionThreshold = 0.02
    --gigantic more than 2 teams
	else
        cornerThreshold = 4
        edgeBuffer = 6
        impasseDistance = 0
        innerExclusion = 0.5
        minPlayerDistance = 6 
        minTeamDistance = 8
        topSelectionThreshold = 0.02
    end

end

--1v1 micro uses PlacePlayerStartsDivided over ring, for finer control with settlement positions
if (worldGetRandom() > 0.5) then
	playerDividedVertical = true
else
	playerDividedVertical = false
end

if (worldPlayerCount <= 2 and worldTerrainWidth <= 416) then
	terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, playerDividedVertical, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)
end
	
--player starting coords
playerStartCoords = {}
for row = 1, gridSize do
	for col = 1, gridSize do
		if (terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			table.insert(playerStartCoords, { y = row, x = col })
		end
	end
end



-------------------------------------------------
--
--
--	PLAYER HILL
--	
--	
-------------------------------------------------


for row = 1, gridSize do
	for col = 1, gridSize do
		terrainLayoutResult[row][col].terrainType = tt_none	
	end
end

--hill for each player
for k, v in ipairs(playerStartCoords) do
	playerStartRow = v.y
	playerStartCol = v.x
	
	GrowTerrainAreaToSizeWeighted(playerStartRow, playerStartCol, playerHillScale, { tt_none }, plateauTerrain, playerHillSelectionWeight, terrainLayoutResult)
	--place player start terrain again as it's overwritten by GrowTerrainAreaToSizeWeighted()
	terrainLayoutResult[playerStartRow][playerStartCol].terrainType = playerStartTerrain
	
end

--patch holes that may appear with GrowTerrainAreaToSizeWeighted()
PatchAreaHoleTiles(tt_none, plateauTerrain)




-------------------------------------------------
--
--
--	CENTER ERASE PLATEAU REGIONS
--	Area that erases plateau terrain that may be too close to the center of the map
--	
-------------------------------------------------

GrowTerrainAreaToSizeWeighted(mapHalfSize, mapHalfSize, centerRegionScale, { plateauTerrain, tt_none }, tt_placeholder, centerRegionSelectionWeight, terrainLayoutResult)

--switches tt_placeholder terrain to tt_none as GrowTerrainAreaToSizeWeighted() does not draw with tt_none
for row = 1, gridSize do
	for col = 1, gridSize do
		if (terrainLayoutResult[row][col].terrainType == tt_placeholder) then
			terrainLayoutResult[row][col].terrainType = tt_none
		end
	end
end

--draw hills around plateau terrain
DrawOuterStroke(plateauTerrain, tt_none, hillTerrain, terrainLayoutResult)
--draw plains clearing around hills
DrawOuterStroke(hillTerrain, tt_none, tt_plains_clearing, terrainLayoutResult)



-------------------------------------------------
--
--
--	CENTER LAKE
--	
--	
-------------------------------------------------

GrowTerrainAreaToSizeWeighted(mapHalfSize, mapHalfSize, lakeScale, { tt_none }, lakeTerrain, 0.3, terrainLayoutResult)




-------------------------------------------------
--
--
--	SETTLEMENTS
--	
--	
-------------------------------------------------

--micro
if (worldTerrainWidth <= 416) then
	if (playerDividedVertical == true) then
		settlementCoords = {
			{ 5, gridSize - 1 }, --top right
			{ gridSize - 4, 2 }, --bottom left
		}
	else
		settlementCoords = {
			{ 2, gridSize - 4 }, --top right
			{ gridSize - 1, 5 }, --bottom left
		}
	end
--small
elseif (worldTerrainWidth <= 512) then
	settlementCoords = {
		{ 2, 2 },
		{ 2, gridSize - 1 },
		{ gridSize - 1, 2 },
		{ gridSize - 1, gridSize - 1 }
	}
--medium
elseif (worldTerrainWidth <= 640) then
	settlementCoords = {
		{ 3, 3 },
		{ 3, gridSize - 2 },
		{ gridSize - 2, 3 },
		{ gridSize - 2, gridSize - 2 }
	}
--large
elseif (worldTerrainWidth <= 768) then
	settlementCoords = {
		{ 3, 3 },
		{ 3, gridSize - 2 },
		{ gridSize - 2, 3 },
		{ gridSize - 2, gridSize - 2 }
	}
--gigantic	
elseif (worldTerrainWidth > 768) then
	settlementCoords = {
		{ 4, 4 },
		{ 4, gridSize - 3 },
		{ gridSize - 3, 4 },
		{ gridSize - 3, gridSize - 3 }
	}
end

for k, v in ipairs(settlementCoords) do
	settlementRow = v[1]
	settlementCol = v[2]
	if (terrainLayoutResult[settlementRow][settlementCol].terrainType == tt_none) then
		terrainLayoutResult[settlementRow][settlementCol].terrainType = settlementTerrain
	end
end




-------------------------------------------------
--
--
--	VALLEY TERRAIN VARIATION
--	
--	
-------------------------------------------------

for row = 1, gridSize do
	for col = 1, gridSize do
		if (terrainLayoutResult[row][col].terrainType == tt_none) then
			if (worldGetRandom() < 0.05) then
				terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
			end
		end
	end
end




print('--------- END OF: HIMEYAMA ---------')