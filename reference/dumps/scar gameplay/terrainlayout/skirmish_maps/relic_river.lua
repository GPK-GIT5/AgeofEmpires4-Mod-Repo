print('--------- BEGIN: RELIC RIVER ---------')

-------------------------------------------------
--
--
--	MAP SIZES
--
--	
-------------------------------------------------

local mapMicroSize = 416
local mapSmallSize = 512
local mapMediumSize = 640
local mapLargeSize = 768
local mapGiganticSize = 896


-------------------------------------------------
--
--
--	TERRAIN TYPES
--
--	
-------------------------------------------------

local plainsTerrain = tt_plains
local stealthTerrain = tt_relic_river_trees_stealth
local holySiteTerrain = tt_relic_river_holy_site

local plateauLowTerrain = tt_relic_river_plateau_low
local plateauLowForestTerrain = tt_relic_river_plateau_low_forest_dense

local plateauMediumTerrain = tt_relic_river_plateau_med
local plateauMediumForestTerrain = tt_relic_river_plateau_med_forest_dense
local plateauMediumHolySiteTerrain = tt_relic_river_plateau_med_holy_site
local plateauMediumSettlementTerrain = tt_relic_river_plateau_med_settlement

local plateauHighTerrain = tt_relic_river_plateau_high

local plateauHighHolySiteTerrain = tt_relic_river_plateau_high_holy_site
local plateauHighForestTerrain = tt_relic_river_plateau_high_forest_dense

local hillLowTerrain = tt_relic_river_hills_low
local hillMediumTerrain = tt_relic_river_hills_med
local hillHighTerrain = tt_relic_river_hills_high

local playerStartTerrain = tt_relic_river_player_start
local playerStartMaskAvoidanceTerrain = tt_ocean
local startBufferTerrain = tt_relic_river_hills_low

--bounty terrains, high elevated bounty scales per player
--medium/large bounty needed more control on amounts
--micro
if (worldTerrainWidth <= mapMicroSize) then
	plateauMediumBountyTerrain = tt_relic_river_plateau_med_bounty_micro
	plateauHighBountyTerrain = tt_relic_river_plateau_high_bounty_micro
--small
elseif (worldTerrainWidth <= mapSmallSize) then
	plateauMediumBountyTerrain = tt_relic_river_plateau_med_bounty_small
	plateauHighBountyTerrain = tt_relic_river_plateau_high_bounty_small
--medium
elseif (worldTerrainWidth <= mapMediumSize) then
	plateauMediumBountyTerrain = tt_relic_river_plateau_med_bounty_medium
	plateauHighBountyTerrain = tt_relic_river_plateau_high_bounty_medium
--large/gigantic
elseif (worldTerrainWidth > mapMediumSize) then
	plateauMediumBountyTerrain = tt_relic_river_plateau_med_bounty_large
	plateauHighBountyTerrain = tt_relic_river_plateau_high_bounty_large
end




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

terrainLayoutResult = SetUpGrid(gridSize, plainsTerrain, terrainLayoutResult)




-------------------------------------------------
--
--
--	MEASUREMENTS
--
--	
-------------------------------------------------

local mapHalfSize = math.ceil(gridSize/2)
local mapQuarterSize = math.ceil(gridSize/4)
local mapEighthSize = math.ceil(gridSize/8)




-------------------------------------------------
--
--
--	GLOBAL AND SCALING VARS
--
--	
-------------------------------------------------

--micro
if (worldTerrainWidth <= mapMicroSize) then
    cliffEdgeSize = 1
    cliffMiddleSize = 2
    plateauSizeLow = gridSize - mapQuarterSize - 1
    plateauSizeMedium = mapHalfSize - 1
    plateauSizeHigh = mapQuarterSize - 1
--small
elseif (worldTerrainWidth <= mapSmallSize) then
    cliffEdgeSize = 1
    cliffMiddleSize = 2
    plateauSizeLow = gridSize - mapQuarterSize - 1
    plateauSizeMedium = mapHalfSize - 1
    plateauSizeHigh = mapQuarterSize - 1
--medium
elseif (worldTerrainWidth <= mapMediumSize) then
    cliffEdgeSize = 2
    cliffMiddleSize = 3
    plateauSizeLow = gridSize - mapQuarterSize - 1
    plateauSizeMedium = mapHalfSize
    plateauSizeHigh = mapQuarterSize + 1 
--large
elseif (worldTerrainWidth <= mapLargeSize) then
    cliffEdgeSize = 2
    cliffMiddleSize = 3
    plateauSizeLow = gridSize - mapQuarterSize - 1
    plateauSizeMedium = mapHalfSize
    plateauSizeHigh = mapQuarterSize + 1
--gigantic
else
    cliffEdgeSize = 2
    cliffMiddleSize = 3
    plateauSizeLow = gridSize - mapQuarterSize
    plateauSizeMedium = mapHalfSize + 1
    plateauSizeHigh = mapQuarterSize + 2
end




-------------------------------------------------
--
--
--	PLAYER START PLACEMENT MASK
--  Creates a mask for more control of player start placements with the impasseType
--  This is then reset/removed once the players are placed
--	To view mask, set playerStartDebugMask to true
--	
-------------------------------------------------

--playerStartDebugMask = true
local playerStartDebugMask = false

local playerStarts = worldPlayerCount
local teamMappingTable = CreateTeamMappingTable()
local numberOfTeams = #teamMappingTable

--
-- 2 teams or less
--
if (numberOfTeams <= 2) then
    
    --micro
    if (worldTerrainWidth <= mapMicroSize) then
        offLimitsDiagonalWidth = 10
        offLimitsPlateauSize = plateauSizeLow + 1
        offLimitsMapEdgeTopSize = 5
        offLimitsMapEdgeBottomSize = 2
    --small
    elseif (worldTerrainWidth <= mapSmallSize) then
        offLimitsDiagonalWidth = 10
        offLimitsPlateauSize = plateauSizeMedium + 5
        offLimitsMapEdgeTopSize = 4
        offLimitsMapEdgeBottomSize = 3
    --medium
    elseif (worldTerrainWidth <= mapMediumSize) then
        offLimitsDiagonalWidth = 13
        offLimitsPlateauSize = plateauSizeMedium + 6
        offLimitsMapEdgeTopSize = 4
        offLimitsMapEdgeBottomSize = 3
    --large
    elseif (worldTerrainWidth <= mapLargeSize) then
        offLimitsDiagonalWidth = 13
        offLimitsPlateauSize = plateauSizeMedium + 7
        offLimitsMapEdgeTopSize = 4
        offLimitsMapEdgeBottomSize = 4
    --gigantic
    elseif (worldTerrainWidth <= mapGiganticSize) then
        offLimitsDiagonalWidth = 13
        offLimitsPlateauSize = plateauSizeMedium + 8
        offLimitsMapEdgeTopSize = 6
        offLimitsMapEdgeBottomSize = 4
    end

--
-- greater than 2 teams
--
else

    if (worldTerrainWidth <= mapSmallSize) then
        offLimitsDiagonalWidth = 10
        offLimitsPlateauSize = plateauSizeMedium + 1
        offLimitsMapEdgeTopSize = 4
        offLimitsMapEdgeBottomSize = 3
    --medium
    elseif (worldTerrainWidth <= mapMediumSize) then
        offLimitsDiagonalWidth = 13
        offLimitsPlateauSize = plateauSizeMedium + 1
        offLimitsMapEdgeTopSize = 4
        offLimitsMapEdgeBottomSize = 3
    --large
    elseif (worldTerrainWidth <= mapLargeSize) then
        offLimitsDiagonalWidth = 13
        offLimitsPlateauSize = plateauSizeMedium + 1
        offLimitsMapEdgeTopSize = 4
        offLimitsMapEdgeBottomSize = 4
    --gigantic
    elseif (worldTerrainWidth <= mapGiganticSize) then
        offLimitsDiagonalWidth = 13
        offLimitsPlateauSize = plateauSizeMedium + 1
        offLimitsMapEdgeTopSize = 6
        offLimitsMapEdgeBottomSize = 4
    end
    
end

--off limits diagonal band top right corner to bottom left
for row = 1, gridSize do
    for col = 1, gridSize do
        local distanceFromCenter = math.abs(col + row - gridSize - 1)
        if (distanceFromCenter < offLimitsDiagonalWidth / 2 + 0.5) then
            terrainLayoutResult[row][col].terrainType = playerStartMaskAvoidanceTerrain
        end
    end
end

--off limits plateau areas
offLimitsPlateauSquares = GetAllSquaresOfTypeInRingAroundSquare(1, gridSize, offLimitsPlateauSize, offLimitsPlateauSize, { plainsTerrain }, terrainLayoutResult)

for k, plateauCoord in ipairs(offLimitsPlateauSquares) do
	local offLimitsRow = plateauCoord[1]
	local offLimitsCol = plateauCoord[2]
	terrainLayoutResult[offLimitsRow][offLimitsCol].terrainType = playerStartMaskAvoidanceTerrain
end

--off limits map edges
--top/right share same size
--bottom/left share same size
for row = 1, gridSize do
    for col = 1, gridSize do
        
        --top
        if (row <= offLimitsMapEdgeTopSize) then
            terrainLayoutResult[row][col].terrainType = playerStartMaskAvoidanceTerrain
        end
        
        --right
        if (col >= gridSize - offLimitsMapEdgeTopSize + 1) then
            terrainLayoutResult[row][col].terrainType = playerStartMaskAvoidanceTerrain
        end
        
        --left
        if (col <= offLimitsMapEdgeBottomSize) then
            terrainLayoutResult[row][col].terrainType = playerStartMaskAvoidanceTerrain
        end
        
        --bottom
        if (row >= gridSize - offLimitsMapEdgeBottomSize + 1) then
            terrainLayoutResult[row][col].terrainType = playerStartMaskAvoidanceTerrain
        end
    end
end




-------------------------------------------------
--
--
--	PLAYER STARTS
--
--	
-------------------------------------------------

local startBufferRadius = 0
local placeStartBuffer = false

local edgeBuffer = 0
local innerExclusion = 0.0
local cornerThreshold = 3
local impasseDistance = 0
local topSelectionThreshold = 0.01

--
-- 2 teams or less
--
if (numberOfTeams <= 2) then
    
    --micro
    if (worldTerrainWidth <= mapMicroSize) then
        minPlayerDistance = 12
        minTeamDistance = 12
    --small
    elseif (worldTerrainWidth <= mapSmallSize) then
        minPlayerDistance = 6
        minTeamDistance = 8
    --medium
    elseif (worldTerrainWidth <= mapMediumSize) then
        minPlayerDistance = 6
        minTeamDistance = 12
    --large
    elseif (worldTerrainWidth <= mapLargeSize) then
        minPlayerDistance = 5
        minTeamDistance = 12
    --gigantic
    elseif (worldTerrainWidth <= mapGiganticSize) then
        minPlayerDistance = 6
        minTeamDistance = 12
    end

--
-- greater than 2 teams
-- 
else
    
    --small
    if (worldTerrainWidth <= mapSmallSize) then
        minPlayerDistance = 6
        minTeamDistance = 8
    --medium
    elseif (worldTerrainWidth <= mapMediumSize) then
        minPlayerDistance = 5
        minTeamDistance = 10
    --large
    elseif (worldTerrainWidth <= mapLargeSize) then
        minPlayerDistance = 5
        minTeamDistance = 12
    --gigantic
    elseif (worldTerrainWidth <= mapGiganticSize) then
        minPlayerDistance = 5
        minTeamDistance = 7
    end
    
end

--ensure player doesn't spawn on the following terrains
impasseTypes = {}

--player start impasse mask
table.insert(impasseTypes, tt_ocean)

terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeStartBuffer, terrainLayoutResult)

if (playerStartDebugMask ~= true) then
    --resets terrain
    for row = 1, gridSize do
        for col = 1, gridSize do
            if (terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) then
                terrainLayoutResult[row][col].terrainType = plainsTerrain 
            end
        end
    end
end

--if player start mask is true, IT STOPS HERE, everything below will not run
if (playerStartDebugMask == true) then
	return
end




-------------------------------------------------
--
--
--	PLATEAU TERRAIN
--
--	
-------------------------------------------------

--
--low plateau
--
local lowPlateauSquares = GetAllSquaresOfTypeInRingAroundSquare(1, gridSize, plateauSizeLow, plateauSizeLow, { plainsTerrain }, terrainLayoutResult)

for k, plateauCoord in ipairs(lowPlateauSquares) do
	local plateauRow = plateauCoord[1]
	local plateauCol = plateauCoord[2]
	terrainLayoutResult[plateauRow][plateauCol].terrainType = plateauLowTerrain
end

--draw low hills around low plateau
DrawOuterStroke(plateauLowTerrain, plainsTerrain, hillLowTerrain, terrainLayoutResult)

--draw low cliffs at maps edges
lowCliffEdgeSquares = GetAllSquaresOfTypeInRingAroundSquare(mapHalfSize, mapHalfSize, gridSize - 1, cliffEdgeSize, { hillLowTerrain }, terrainLayoutResult)

for k, plateauCoord in ipairs(lowCliffEdgeSquares) do
	local plateauRow = plateauCoord[1]
	local plateauCol = plateauCoord[2]
	terrainLayoutResult[plateauRow][plateauCol].terrainType = plateauLowTerrain
end


--
--medium plateau
--
local mediumPlateauSquares = GetAllSquaresOfTypeInRingAroundSquare(1, gridSize, plateauSizeMedium, plateauSizeMedium, { plateauLowTerrain }, terrainLayoutResult)

for k, plateauCoord in ipairs(mediumPlateauSquares) do
	local plateauRow = plateauCoord[1]
	local plateauCol = plateauCoord[2]
	terrainLayoutResult[plateauRow][plateauCol].terrainType = plateauMediumTerrain
end

--draw medium hills around medium plateau
DrawOuterStroke(plateauMediumTerrain, plateauLowTerrain, hillMediumTerrain, terrainLayoutResult)

--draw medium cliffs at maps edges
mediumCliffEdgeSquares = GetAllSquaresOfTypeInRingAroundSquare(mapHalfSize, mapHalfSize, gridSize - 1, cliffEdgeSize, { hillMediumTerrain }, terrainLayoutResult)

for k, plateauCoord in ipairs(mediumCliffEdgeSquares) do
	local plateauRow = plateauCoord[1]
	local plateauCol = plateauCoord[2]
	terrainLayoutResult[plateauRow][plateauCol].terrainType = plateauMediumTerrain
end


--
--high plateau
--
local highPlateauSquares = GetAllSquaresOfTypeInRingAroundSquare(1, gridSize, plateauSizeHigh, plateauSizeHigh, { plateauMediumTerrain }, terrainLayoutResult)

for k, plateauCoord in ipairs(highPlateauSquares) do
	local plateauRow = plateauCoord[1]
	local plateauCol = plateauCoord[2]
	terrainLayoutResult[plateauRow][plateauCol].terrainType = plateauHighTerrain
end

--draw high hills around high plateau
DrawOuterStroke(plateauHighTerrain, plateauMediumTerrain, hillHighTerrain, terrainLayoutResult)




-------------------------------------------------
--
--
--	PLATEAU WATER FALLS
--
--	
-------------------------------------------------
    
if (worldTerrainWidth <= mapMicroSize) then
    relic_riverPointCoords = {
        { gridSize - mapQuarterSize + 1, mapQuarterSize },
        { mapHalfSize + 1, mapHalfSize - 1 },
        { mapQuarterSize + 1, gridSize - mapQuarterSize }
    }
elseif (worldTerrainWidth <= mapSmallSize) then
    relic_riverPointCoords = {
        { gridSize - mapQuarterSize + 1, mapQuarterSize },
        { mapHalfSize + 1, mapHalfSize - 1 },
        { mapQuarterSize + 1, gridSize - mapQuarterSize }
    }
elseif (worldTerrainWidth <= mapMediumSize) then
    relic_riverPointCoords = {
        { gridSize - mapQuarterSize + 1, mapQuarterSize },
        { mapHalfSize + 2, mapHalfSize - 2 },
        { mapQuarterSize + 3, mapHalfSize + 4 }
    }
elseif (worldTerrainWidth <= mapLargeSize) then
    relic_riverPointCoords = {
        { gridSize - mapQuarterSize + 1, mapQuarterSize },
        { mapHalfSize + 2, mapHalfSize - 2 },
        { mapQuarterSize + 3, gridSize - mapQuarterSize - 2 }
    }
elseif (worldTerrainWidth <= mapGiganticSize) then
    relic_riverPointCoords = {
        { gridSize - mapQuarterSize + 2, mapQuarterSize - 1 },
        { mapHalfSize + 3, mapHalfSize - 3 },
        { mapQuarterSize + 4, gridSize - mapQuarterSize - 3 }
    }
end

--
--low waterfall
--
local relic_riverPointRow = relic_riverPointCoords[1][1]
local relic_riverPointCol = relic_riverPointCoords[1][2]

local relic_riverCliffCoords = GetAllSquaresOfTypeInRingAroundSquare(relic_riverPointRow, relic_riverPointCol, cliffMiddleSize, cliffMiddleSize, { hillLowTerrain }, terrainLayoutResult)

for i, j in ipairs(relic_riverCliffCoords) do
    local currentRow = j[1]
    local currentCol = j[2]
    terrainLayoutResult[currentRow][currentCol].terrainType = plainsTerrain
end

--
--mid waterfall
--
local relic_riverPointRow = relic_riverPointCoords[2][1]
local relic_riverPointCol = relic_riverPointCoords[2][2]

local relic_riverCliffCoords = GetAllSquaresOfTypeInRingAroundSquare(relic_riverPointRow, relic_riverPointCol, cliffMiddleSize, cliffMiddleSize, { hillMediumTerrain }, terrainLayoutResult)

for i, j in ipairs(relic_riverCliffCoords) do
    local currentRow = j[1]
    local currentCol = j[2]
    terrainLayoutResult[currentRow][currentCol].terrainType = plateauLowTerrain
end


--
--high waterfall
--
local relic_riverPointRow = relic_riverPointCoords[3][1]
local relic_riverPointCol = relic_riverPointCoords[3][2]

local relic_riverCliffCoords = GetAllSquaresOfTypeInRingAroundSquare(relic_riverPointRow, relic_riverPointCol, cliffMiddleSize, cliffMiddleSize, { hillHighTerrain }, terrainLayoutResult)

for i, j in ipairs(relic_riverCliffCoords) do
    local currentRow = j[1]
    local currentCol = j[2]
    terrainLayoutResult[currentRow][currentCol].terrainType = plateauMediumTerrain
end




-------------------------------------------------
--
--
--	HIGHER ELEVATED BOUNTY
--
--	
-------------------------------------------------

--micro
if (worldTerrainWidth <= mapMicroSize) then
	
    midBounty = {
        { mapEighthSize + 1, mapHalfSize },
        { mapHalfSize, gridSize - mapEighthSize }
    }
    
    highBounty = {
        { 2, gridSize - 1 }
    }

--small
elseif (worldTerrainWidth <= mapSmallSize) then

    midBounty = {
        { mapEighthSize + 1, mapHalfSize },
        { mapHalfSize, gridSize - mapEighthSize }
    }
    
    highBounty = {
        { 3, gridSize - mapEighthSize + 1 }
    }

--medium
elseif (worldTerrainWidth <= mapMediumSize) then
	
	midBounty = {
		{ mapEighthSize, mapHalfSize },
		{ mapHalfSize, gridSize - mapEighthSize + 1 },
		{ mapQuarterSize + 1, mapHalfSize },
		{ mapHalfSize, gridSize - mapQuarterSize }
	}
    
    highBounty = {
        { 3, gridSize - mapEighthSize - 2 },
        { mapQuarterSize, gridSize - 2 }
    }
    
--large
elseif (worldTerrainWidth <= mapLargeSize) then
    
    midBounty = {
    	{ mapEighthSize, mapHalfSize - 1 },
    	{ mapHalfSize + 1, gridSize - mapEighthSize + 1 },
    	{ mapQuarterSize + 1, mapHalfSize - 1 },
    	{ mapHalfSize + 1, gridSize - mapQuarterSize }
    }
    
    highBounty = {
        { 3, gridSize - mapEighthSize - 2 },
        { mapQuarterSize, gridSize - 2 }
    }
    
--gigantic
elseif (worldTerrainWidth <= mapGiganticSize) then
    midBounty = {
    	{ mapEighthSize, mapHalfSize - 2 },
    	{ mapHalfSize + 2, gridSize - mapEighthSize + 1 },
    	{ mapQuarterSize + 1, mapHalfSize - 2 },
    	{ mapHalfSize + 2, gridSize - mapQuarterSize }
    }
    
    highBounty = {
        { 3, gridSize - mapEighthSize - 2 },
        { mapQuarterSize, gridSize - 2 }
    }
end

--medium bounty loop
for i, midBountyCoords in pairs(midBounty) do
    local midBountyRow = midBountyCoords[1]
    local midBountyCol = midBountyCoords[2]
    terrainLayoutResult[midBountyRow][midBountyCol].terrainType = plateauMediumBountyTerrain
end

--high bounty loop
for i, highBountyCoords in pairs(highBounty) do
    local highBountyRow = highBountyCoords[1]
    local highBountyCol = highBountyCoords[2]
    terrainLayoutResult[highBountyRow][highBountyCol].terrainType = plateauHighBountyTerrain
end





-------------------------------------------------
--
--
--	LOWER VALLEY PLAINS
--
--	
-------------------------------------------------

--map edges
local lowerPlainsSquares = GetAllSquaresOfTypeInRingAroundSquare(mapHalfSize, mapHalfSize, gridSize, 2, { plainsTerrain }, terrainLayoutResult)

for k, v in ipairs(lowerPlainsSquares) do
    local plainsRow = v[1]
    local plainsCol = v[2]
    terrainLayoutResult[plainsRow][plainsCol].terrainType = plainsTerrain
end




-------------------------------------------------
--
--
--	FOREST MAP EDGES
--
--	
-------------------------------------------------
    
--micro
if (worldTerrainWidth <= mapMicroSize) then
    
    lowForest = {
        { 1, mapQuarterSize },
        { gridSize - mapEighthSize - 1, gridSize }
    }
    
    midForest = {
        { 1, mapHalfSize - 1 },
        { mapHalfSize + 1, gridSize }
    }

--small
elseif (worldTerrainWidth <= mapSmallSize) then
    
    lowForest = {
        { 1, mapQuarterSize },
        { gridSize - mapQuarterSize + 1, gridSize }
    }
    
    midForest = {
        { 1, mapHalfSize - 1 },
        { mapHalfSize + 1, gridSize }
    }
    
--medium
elseif (worldTerrainWidth <= mapMediumSize) then
    
    lowForest = {
        { 1, mapQuarterSize },
        { 1, mapQuarterSize + 1 },
        { gridSize - mapQuarterSize + 1, gridSize },
        { gridSize - mapQuarterSize, gridSize }
    }
    
    midForest = {
        { 1, mapHalfSize - 2 },
        { 1, mapHalfSize - 1 },
        { mapHalfSize + 2, gridSize },
        { mapHalfSize + 1, gridSize }
    }
    
--large
elseif (worldTerrainWidth <= mapLargeSize) then

    lowForest = {
        { 1, mapQuarterSize },
        { 1, mapQuarterSize + 1 },
        { 2, mapQuarterSize },
        { gridSize - mapQuarterSize + 1, gridSize - 1 },
        { gridSize - mapQuarterSize + 1, gridSize },
        { gridSize - mapQuarterSize, gridSize }
    }
    
    midForest = {
        { 1, mapHalfSize - 2 },
        { 1, mapHalfSize - 1 },
        { mapHalfSize + 2, gridSize },
        { mapHalfSize + 1, gridSize }
    }

--gigantic
elseif (worldTerrainWidth <= mapGiganticSize) then
    
    lowForest = {
        { 1, mapQuarterSize - 1 },
        { 1, mapQuarterSize },
        { 2, mapQuarterSize - 1 },
        { gridSize - mapQuarterSize + 2, gridSize - 1 },
        { gridSize - mapQuarterSize + 2, gridSize },
        { gridSize - mapQuarterSize + 1, gridSize }
    }
    
    midForest = {
        { 1, mapHalfSize - 3 },
        { 1, mapHalfSize - 2 },
        { mapHalfSize + 3, gridSize },
        { mapHalfSize + 2, gridSize }
    }
    
end

--low elevated forest loop
for i, lowForestCoords in pairs(lowForest) do
    local lowForestRow = lowForestCoords[1]
    local lowForestCol = lowForestCoords[2]
    terrainLayoutResult[lowForestRow][lowForestCol].terrainType = plateauLowForestTerrain
end

--medium elevated forest loop
for i, midForestCoords in pairs(midForest) do
    local midForestRow = midForestCoords[1]
    local midForestCol = midForestCoords[2]
    terrainLayoutResult[midForestRow][midForestCol].terrainType = plateauMediumForestTerrain
end
    

--highest forest in corner
if (worldTerrainWidth <= mapMicroSize) then
    highForestScale = 2
--small
elseif (worldTerrainWidth <= mapSmallSize) then
    highForestScale = 3
--medium
elseif (worldTerrainWidth <= mapMediumSize) then
    highForestScale = 4
--large/gigantic
elseif (worldTerrainWidth > mapMediumSize) then
    highForestScale = 6
end

GrowTerrainAreaToSizeWeighted(1, gridSize, highForestScale, { plateauHighTerrain }, plateauHighForestTerrain, 0.1, terrainLayoutResult)




-------------------------------------------------
--
--
--	HOLY SITES
--
--	
-------------------------------------------------

local holySiteLowCoords = { gridSize - mapEighthSize, mapEighthSize + 1 }
local holySiteMediumCoords = { mapHalfSize - 1, mapHalfSize + 1 }
local holySiteHighCoords = { mapQuarterSize - 1, gridSize - mapQuarterSize + 2 }

terrainLayoutResult[holySiteLowCoords[1]][holySiteLowCoords[2]].terrainType = holySiteTerrain
terrainLayoutResult[holySiteMediumCoords[1]][holySiteMediumCoords[2]].terrainType = plateauMediumHolySiteTerrain
terrainLayoutResult[holySiteHighCoords[1]][holySiteHighCoords[2]].terrainType = plateauHighHolySiteTerrain




-------------------------------------------------
--
--
--	SETTLEMENTS
--
--	
-------------------------------------------------

--micro
if (worldTerrainWidth <= mapMicroSize) then
    terrainLayoutResult[2][mapHalfSize + 1].terrainType = plateauMediumSettlementTerrain
    terrainLayoutResult[mapHalfSize - 1][gridSize - 1].terrainType = plateauMediumSettlementTerrain
--small
elseif (worldTerrainWidth <= mapSmallSize) then
    terrainLayoutResult[2][mapHalfSize + 2].terrainType = plateauMediumSettlementTerrain
    terrainLayoutResult[mapHalfSize - 2][gridSize - 1].terrainType = plateauMediumSettlementTerrain 
--medium
elseif (worldTerrainWidth <= mapMediumSize) then
    terrainLayoutResult[2][mapHalfSize + 2].terrainType = plateauMediumSettlementTerrain
    terrainLayoutResult[mapHalfSize - 2][gridSize - 1].terrainType = plateauMediumSettlementTerrain
--large
elseif (worldTerrainWidth <= mapLargeSize) then
    terrainLayoutResult[2][mapHalfSize + 3].terrainType = plateauMediumSettlementTerrain
    terrainLayoutResult[mapHalfSize - 3][gridSize - 1].terrainType = plateauMediumSettlementTerrain
--gigantic
elseif (worldTerrainWidth <= mapGiganticSize) then
    terrainLayoutResult[2][mapHalfSize + 3].terrainType = plateauMediumSettlementTerrain
    terrainLayoutResult[mapHalfSize - 3][gridSize - 1].terrainType = plateauMediumSettlementTerrain
end




-------------------------------------------------
--
--
--	STEALTH FOREST DIAGONAL LOWER REGION
--	Draws diagonal stealth forest in lowest region while avoiding river tile squares in the middle of the diagonal
--	Stealth forests that are positioned too close to river tiles will delete river fish
--	
-------------------------------------------------

local stealthDiagonalWidth = 6
local avoidMiddleWidth = 3

for row = 1, gridSize do
    for col = 1, gridSize do
        local distanceFromCenter = math.abs(col + row - gridSize - 1)
		local distanceFromDiagonal = math.abs(row + col - (gridSize + 1))
        local currentTerrain = terrainLayoutResult[row][col].terrainType
        if (distanceFromCenter < stealthDiagonalWidth / 2 + 0.5 and currentTerrain == plainsTerrain) and (distanceFromDiagonal > avoidMiddleWidth / 2) then
			terrainLayoutResult[row][col].terrainType = stealthTerrain
        end
    end
end




-------------------------------------------------
--
--
--	RIVER FEATURES
--
--	
-------------------------------------------------

riverResult = {}
fordResults = {}
woodBridgeResults = {}
stoneBridgeResults = {}

local riverStartRow = 1
local riverStartCol = gridSize
local riverEndRow = gridSize
local riverEndCol = 1

local tempRiverPoints = DrawStraightLineReturn(riverStartRow, riverStartCol, riverEndRow, riverEndCol, false, tt_river, gridSize, terrainLayoutResult)

--put river points into the river table
table.insert(riverResult, 1, tempRiverPoints)




print('--------- END OF: RELIC RIVER ---------')