-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING THE PIT")

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

h = tt_hills
m = tt_mountains_small
b = tt_hills_gentle_rolling
l = tt_plateau_low
p = tt_plains


playerStartTerrain = tt_player_start_classic_plains_low_trees_pit -- classic mode start low trees
--playerStartTerrain = tt_player_start_classic_plains_no_tertiary_wood  -- classic mode start

startTerrainBuffer = tt_plains

-- COARSE GRID SET UP
terrainLayoutResult = {}    -- set up initial table for coarse map grid. Must be named this.
mapRes = 28
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(mapRes)

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

baseGridSize = 13 -- used for reference when scaling map features

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

-- PLACE PLAYER STARTS
-- set offsets for player starts scaled by map size
heightOffset = Round(2 / baseGridSize * gridHeight, 0)
widthOffset = Round(2 / baseGridSize * gridWidth, 0)

startLocationPositions = {} -- the table holding the data for each player location

-- set the start radius for the terrain buffer around the start locations
if (worldTerrainHeight > 513) then
	startRadius = 2
else
	startRadius = 1
end

mapHalfSize = math.ceil(gridSize/2)

--scale map features for all map sizes
if(worldTerrainWidth <= 417) then
	tradeHillSize1 = 1
	tradeHillSize2 = 1
	tradeHillSize3 = 1
	
	tradeHillWidth1 = 1
	tradeHillWidth2 = 2
	tradeHillWidth3 = 3
	
	sacredHillSize1 = 1
	sacredHillSize2 = 1
	sacredHillSize3 = 1
	
	sacredHillWidth1 = 1
	sacredHillWidth2 = 2
	sacredHillWidth3 = 3
	
	pitHeight = 2
	pitWidth = 2
	pitSize = 2
	
elseif(worldTerrainWidth <= 513) then
	tradeHillSize1 = 1
	tradeHillSize2 = 1
	tradeHillSize3 = 1
	
	tradeHillWidth1 = 1
	tradeHillWidth2 = 2
	tradeHillWidth3 = 3
	
	sacredHillSize1 = 1
	sacredHillSize2 = 1
	sacredHillSize3 = 1
	
	sacredHillWidth1 = 1
	sacredHillWidth2 = 2
	sacredHillWidth3 = 3
	
	pitHeight = 3
	pitWidth = 2
	pitSize = 3
elseif(worldTerrainWidth <= 641) then
	tradeHillSize1 = 1
	tradeHillSize2 = 1
	tradeHillSize3 = 1
	
	tradeHillWidth1 = 1
	tradeHillWidth2 = 2
	tradeHillWidth3 = 3
	
	sacredHillSize1 = 2
	sacredHillSize2 = 2
	sacredHillSize3 = 2
	
	sacredHillWidth1 = 2
	sacredHillWidth2 = 3
	sacredHillWidth3 = 4
	
	pitHeight = 3
	pitWidth = 2
	pitSize = 3
elseif(worldTerrainWidth <= 769) then
	tradeHillSize1 = 2
	tradeHillSize2 = 2
	tradeHillSize3 = 2
	
	tradeHillWidth1 = 2
	tradeHillWidth2 = 3
	tradeHillWidth3 = 4
	
	sacredHillSize1 = 2
	sacredHillSize2 = 2
	sacredHillSize3 = 2
	
	sacredHillWidth1 = 2
	sacredHillWidth2 = 3
	sacredHillWidth3 = 4
	
	pitHeight = 4
	pitWidth = 3
	pitSize = 4
else
	tradeHillSize1 = 2
	tradeHillSize2 = 2
	tradeHillSize3 = 2
	
	tradeHillWidth1 = 2
	tradeHillWidth2 = 3
	tradeHillWidth3 = 4
	
	sacredHillSize1 = 2
	sacredHillSize2 = 2
	sacredHillSize3 = 2
	
	sacredHillWidth1 = 2
	sacredHillWidth2 = 3
	sacredHillWidth3 = 4
	
	pitHeight = 5
	pitWidth = 4
	pitSize = 5
end

--place trade posts on hills in corners
tradePost1Row = 1
tradePost1Col = 1

neighbors1 = GetAllSquaresInRingAroundSquare(tradePost1Row, tradePost1Col, tradeHillWidth1, tradeHillSize1, terrainLayoutResult)
neighbors2 = GetAllSquaresInRingAroundSquare(tradePost1Row, tradePost1Col, tradeHillWidth2, tradeHillSize2, terrainLayoutResult)
neighbors3 = GetAllSquaresInRingAroundSquare(tradePost1Row, tradePost1Col, tradeHillWidth3, tradeHillSize3, terrainLayoutResult)

for hillRingIndex, coord in ipairs(neighbors1) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
	end
end

for hillRingIndex, coord in ipairs(neighbors2) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
	end
end

for hillRingIndex, coord in ipairs(neighbors3) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling_clearing
	end
end

terrainLayoutResult[tradePost1Row][tradePost1Col].terrainType = tt_settlement_hills_high_rolling
if(worldTerrainWidth <= 513) then
	terrainLayoutResult[tradePost1Row+1][tradePost1Col+1].terrainType = tt_bounty_stone_hills
else
	terrainLayoutResult[tradePost1Row+2][tradePost1Col+2].terrainType = tt_bounty_stone_hills_large
end


tradePost2Row = gridSize
tradePost2Col = gridSize

neighbors1 = GetAllSquaresInRingAroundSquare(tradePost2Row, tradePost2Col, tradeHillWidth1, tradeHillSize1, terrainLayoutResult)
neighbors2 = GetAllSquaresInRingAroundSquare(tradePost2Row, tradePost2Col, tradeHillWidth2, tradeHillSize2, terrainLayoutResult)
neighbors3 = GetAllSquaresInRingAroundSquare(tradePost2Row, tradePost2Col, tradeHillWidth3, tradeHillSize3, terrainLayoutResult)

for hillRingIndex, coord in ipairs(neighbors1) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
	end
end

for hillRingIndex, coord in ipairs(neighbors2) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
	end
	
end

for hillRingIndex, coord in ipairs(neighbors3) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling_clearing
	end
	
end

terrainLayoutResult[tradePost2Row][tradePost2Col].terrainType = tt_settlement_hills_high_rolling
if(worldTerrainWidth <= 513) then
	terrainLayoutResult[tradePost2Row-1][tradePost2Col-1].terrainType = tt_bounty_stone_hills
else
	terrainLayoutResult[tradePost2Row-2][tradePost2Col-2].terrainType = tt_bounty_stone_hills_large
end


--create cliff site locations
centralValleySquares = {}
if(worldTerrainWidth <= 417) then
	centralValleySquares = GetNeighbors(mapHalfSize, mapHalfSize, terrainLayoutResult)
else
	centralValleySquares = Get8Neighbors(mapHalfSize, mapHalfSize, terrainLayoutResult)
end
for pitRingIndex, coord in ipairs(centralValleySquares) do
			
	row = coord.x
	col = coord.y
	terrainLayoutResult[row][col].terrainType = tt_valley_shallow_smooth
end

centralValleySquares = {}
centralValleySquares = GetSquaresInBox(mapHalfSize - pitHeight, mapHalfSize - pitWidth, mapHalfSize + pitHeight, mapHalfSize + pitWidth, #terrainLayoutResult, terrainLayoutResult)
--centralValleySquares = GetAllSquaresInRingAroundSquare(mapHalfSize, mapHalfSize, pitSize, pitSize, terrainLayoutResult)
for pitRingIndex, coord in ipairs(centralValleySquares) do
			
	row = coord[1]
	col = coord[2]
	print("looking at pit coordinate " .. row .. ", " .. col)
	if(terrainLayoutResult[row][col].terrainType ~= tt_valley_shallow_smooth) then
		terrainLayoutResult[row][col].terrainType = tt_valley_smooth_stealth
	end
end

terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = tt_holy_site_valley
if(worldTerrainWidth >= 639) then
	terrainLayoutResult[mapHalfSize-1][mapHalfSize].terrainType = tt_bounty_gold_valley
	terrainLayoutResult[mapHalfSize+1][mapHalfSize].terrainType = tt_bounty_gold_valley
	terrainLayoutResult[mapHalfSize][mapHalfSize-3].terrainType = tt_bounty_gold_valley
	terrainLayoutResult[mapHalfSize][mapHalfSize+3].terrainType = tt_bounty_gold_valley
else
	terrainLayoutResult[mapHalfSize][mapHalfSize-1].terrainType = tt_bounty_gold_valley
	terrainLayoutResult[mapHalfSize][mapHalfSize+1].terrainType = tt_bounty_gold_valley
end


--make cliffs on the top and bottom of the pit
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
	
		if(row == mapHalfSize - pitHeight or row == mapHalfSize + pitHeight) then
			if(terrainLayoutResult[row][col].terrainType == tt_valley_smooth_stealth) then
				terrainLayoutResult[row][col].terrainType = tt_plains_cliff	
			end
		end
	end
end



--do cliff corners
cliff1Row = 2
cliff1Col = gridSize - 1

cliff2Row = gridSize - 1
cliff2Col = 2

neighbors1 = GetAllSquaresInRingAroundSquare(cliff1Row, cliff1Col, sacredHillWidth1, sacredHillSize1, terrainLayoutResult)
neighbors2 = GetAllSquaresInRingAroundSquare(cliff1Row, cliff1Col, sacredHillWidth2, sacredHillSize2, terrainLayoutResult)
neighbors3 = GetAllSquaresInRingAroundSquare(cliff1Row, cliff1Col, sacredHillWidth3, sacredHillSize3, terrainLayoutResult)

for hillRingIndex, coord in ipairs(neighbors1) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
	end
end

for hillRingIndex, coord in ipairs(neighbors2) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling_clearing
	end
	
end

for hillRingIndex, coord in ipairs(neighbors3) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_plains
	end
	
end

terrainLayoutResult[cliff1Row][cliff1Col - sacredHillWidth1].terrainType = tt_plateau_low
terrainLayoutResult[cliff1Row + sacredHillWidth1][cliff1Col - sacredHillWidth1].terrainType = tt_plateau_low
terrainLayoutResult[cliff1Row + sacredHillWidth1][cliff1Col].terrainType = tt_plateau_low

terrainLayoutResult[cliff1Row][cliff1Col - 3].terrainType = tt_hills_gentle_rolling_clearing
terrainLayoutResult[cliff1Row + 3][cliff1Col].terrainType = tt_hills_gentle_rolling_clearing

if(worldTerrainWidth <= 513) then
	terrainLayoutResult[cliff1Row][cliff1Col].terrainType = tt_plateau_low_large_gold_small_stone
else
	terrainLayoutResult[cliff1Row][cliff1Col].terrainType = tt_plateau_low_large_gold_small_stone
	terrainLayoutResult[cliff1Row+1][cliff1Col-1].terrainType = tt_plateau_low_large_gold_small_stone
end



--------

neighbors1 = GetAllSquaresInRingAroundSquare(cliff2Row, cliff2Col, sacredHillWidth1, sacredHillSize1, terrainLayoutResult)
neighbors2 = GetAllSquaresInRingAroundSquare(cliff2Row, cliff2Col, sacredHillWidth2, sacredHillSize2, terrainLayoutResult)
neighbors3 = GetAllSquaresInRingAroundSquare(cliff2Row, cliff2Col, sacredHillWidth3, sacredHillSize3, terrainLayoutResult)

for hillRingIndex, coord in ipairs(neighbors1) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
	end
end

for hillRingIndex, coord in ipairs(neighbors2) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling_clearing
	end
	
end

for hillRingIndex, coord in ipairs(neighbors3) do
			
	row = coord[1]
	col = coord[2]
	if terrainLayoutResult[row][col].terrainType == tt_none then
		terrainLayoutResult[row][col].terrainType = tt_plains
	end
	
end

terrainLayoutResult[cliff2Row][cliff2Col + sacredHillWidth1].terrainType = tt_plateau_low
terrainLayoutResult[cliff2Row - sacredHillWidth1][cliff2Col + sacredHillWidth1].terrainType = tt_plateau_low
terrainLayoutResult[cliff2Row - sacredHillWidth1][cliff2Col].terrainType = tt_plateau_low

terrainLayoutResult[cliff2Row - 3][cliff2Col].terrainType = tt_hills_gentle_rolling_clearing
terrainLayoutResult[cliff2Row][cliff2Col + 3].terrainType = tt_hills_gentle_rolling_clearing

if(worldTerrainWidth <= 513) then
	terrainLayoutResult[cliff2Row][cliff2Col].terrainType = tt_plateau_low_large_gold_small_stone
else
	terrainLayoutResult[cliff2Row][cliff2Col].terrainType = tt_plateau_low_large_gold_small_stone
	terrainLayoutResult[cliff2Row-1][cliff2Col+1].terrainType = tt_plateau_low_large_gold_small_stone
end

--place sacred sites in the lanes above the cliffs
sacredRow1 = math.ceil(gridSize * 0.2)
sacredRow2 = math.ceil(gridSize * 0.8)
terrainLayoutResult[sacredRow1][mapHalfSize].terrainType = tt_holy_site
terrainLayoutResult[sacredRow2][mapHalfSize].terrainType = tt_holy_site


-- PLACE PLAYER START POSITIONS -----------------------------------------------------
print("RANDOM POSITIONS IS " ..tostring(randomPositions))
	
--should be true to be correct!
if (randomPositions == true) then -- place players without regard to grouping teams together		
	
	--Start Position Stuff---------------------------------------------------------------------------------
	
	impasseTypes = {tt_plateau_low, tt_plains_cliff, tt_holy_site}
	
	if(worldTerrainWidth <= 417) then
		minTeamDistance = Round((#terrainLayoutResult * 0.5))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 3
		innerExclusion = 0.45
		topSelectionThreshold = 0.1
		
		impasseDistance = 2
		cornerThreshold = 1
	elseif(worldTerrainWidth <= 513) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 3
		innerExclusion = 0.55
		topSelectionThreshold = 0.033
		impasseDistance = 2.5
		cornerThreshold = 1
		impasseTypes = {tt_plateau_low, tt_hills_gentle_rolling, tt_plains_cliff, tt_holy_site}
	elseif(worldTerrainWidth <= 641) then
		minTeamDistance = Round((#terrainLayoutResult * 1.2))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 3
		innerExclusion = 0.625
		topSelectionThreshold = 0.05
		impasseDistance = 2.5
		cornerThreshold = 2
		impasseTypes = {tt_plateau_low, tt_hills_gentle_rolling, tt_plains_cliff, tt_holy_site}
	elseif(worldTerrainWidth <= 769) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 4
		innerExclusion = 0.6
		topSelectionThreshold = 0.05
		impasseDistance = 3
		cornerThreshold = 2
		impasseTypes = {tt_plateau_low, tt_hills_gentle_rolling, tt_plains_cliff, tt_holy_site}
	else
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 4
		innerExclusion = 0.6
		topSelectionThreshold = 0.01
		impasseDistance = 3
		cornerThreshold = 2
		impasseTypes = {tt_plateau_low, tt_hills_gentle_rolling, tt_plains_cliff, tt_holy_site}
	end
	
	startBufferRadius = 2
	startBufferTerrain = tt_plains
	
	teamMappingTable = CreateTeamMappingTable()
	
	
	openTypes = {tt_plains, tt_hills_low_rolling, tt_hills_med_rolling, tt_hills_high_rolling, tt_none, tt_flatland}
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)

	startLocationPositions = {}
	
	--loop through and record player starts
	for row = 1, #terrainLayoutResult do
		for col = 1, #terrainLayoutResult do
			
			currentData = {}
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				currentData = {row, col}
				table.insert(startLocationPositions, currentData)
			end
			
		end
	end

else -- place players from the same team grouped together

	--Start Position Stuff---------------------------------------------------------------------------------
	
	impasseTypes = {tt_plateau_low, tt_plains_cliff}
	
	if(worldTerrainWidth <= 417) then
		minTeamDistance = Round((#terrainLayoutResult * 0.5))
		minPlayerDistance = 5
		edgeBuffer = 3
		innerExclusion = 0.45
		topSelectionThreshold = 0.2
		impasseDistance = 2
		cornerThreshold = 1
	elseif(worldTerrainWidth <= 513) then
		minTeamDistance = Round((#terrainLayoutResult * 0.7))
		minPlayerDistance = 4.5
		edgeBuffer = 3
		innerExclusion = 0.45
		topSelectionThreshold = 0.015
		impasseDistance = 2
		cornerThreshold = 1
		impasseTypes = {tt_plateau_low, tt_hills_gentle_rolling, tt_plains_cliff}
	elseif(worldTerrainWidth <= 641) then
		minTeamDistance = Round((#terrainLayoutResult * 0.7))
		minPlayerDistance = 4
		edgeBuffer = 3
		innerExclusion = 0.475
		topSelectionThreshold = 0.015
		impasseDistance = 2.5
		cornerThreshold = 2
		impasseTypes = {tt_plateau_low, tt_hills_gentle_rolling, tt_plains_cliff}
	elseif(worldTerrainWidth <= 769) then
		minTeamDistance = Round((#terrainLayoutResult * 0.7))
		minPlayerDistance = 4.5
		edgeBuffer = 5
		innerExclusion = 0.4
		topSelectionThreshold = 0.015
		impasseDistance = 2.5
		cornerThreshold = 1
		impasseTypes = {tt_plateau_low, tt_hills_gentle_rolling, tt_plains_cliff}
	else
		minTeamDistance = Round((#terrainLayoutResult * 0.7))
		minPlayerDistance = 7
		edgeBuffer = 5
		innerExclusion = 0.45
		topSelectionThreshold = 0.01
		impasseDistance = 2.5
		cornerThreshold = 1
		impasseTypes = {tt_plateau_low, tt_hills_gentle_rolling, tt_plains_cliff}
	end
	
	startBufferRadius = 1.7
	startBufferTerrain = tt_plains
	
	teamMappingTable = CreateTeamMappingTable()
	
	openTypes = {tt_plains, tt_hills_low_rolling, tt_hills_med_rolling, tt_hills_high_rolling, tt_none, tt_flatland}
	
	
--	terrainLayoutResult = PlacePlayerStartsTogetherRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)

	if(#teamMappingTable == 2) then
		terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, true, impasseTypes, impasseDistance, 0.01, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)
	else
		terrainLayoutResult = PlacePlayerStartsTogetherRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, 0.01, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)
	end
	startLocationPositions = {}
	
	--loop through and record player starts
	for row = 1, #terrainLayoutResult do
		for col = 1, #terrainLayoutResult do
			
			currentData = {}
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				currentData = {row, col}
				table.insert(startLocationPositions, currentData)
			end
			
		end
	end

end

--put forests around the outside of the map not on hills
for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(worldTerrainHeight <= 641) then
			if(row == 1 or row == gridSize or col == 1 or col == gridSize) then
				if(terrainLayoutResult[row][col].terrainType == tt_none) then
					terrainLayoutResult[row][col].terrainType = tt_impasse_trees_plains_forest
				end
			end
		else
			if(row <= 2 or row >= gridSize-1 or col <= 2 or col >= gridSize-1) then
				if(terrainLayoutResult[row][col].terrainType == tt_none) then
					terrainLayoutResult[row][col].terrainType = tt_impasse_trees_plains_forest
				end
			end
		end
	end
end

print("END OF THE PIT LUA SCRIPT")
