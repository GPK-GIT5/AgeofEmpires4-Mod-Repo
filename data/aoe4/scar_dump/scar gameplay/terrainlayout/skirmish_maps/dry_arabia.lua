-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING DRY ARABIA")

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

h = tt_hills
m = tt_mountains_small
b = tt_hills_gentle_rolling
l = tt_plateau_low
p = tt_plains


--playerStartTerrain = tt_player_start_classic_plains_low_trees -- classic mode start low trees
playerStartTerrain = tt_player_start_dry_arabia  -- classic mode start

startTerrainBuffer = tt_plains

-- COARSE GRID SET UP
terrainLayoutResult = {}    -- set up initial table for coarse map grid. Must be named this.

gridHeight, gridWidth, gridSize = SetCoarseGrid() -- function to set up the coarse grid. Found in map_setup lua file in library folder

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

-- set the start radius for hte terrain buffer around hte start locations
if (worldTerrainHeight > 513) then
	startRadius = 2
else
	startRadius = 1
end

-- PLACE PLAYER START POSITIONS -----------------------------------------------------
print("RANDOM POSITIONS IS " ..tostring(randomPositions))
	
--should be true to be correct!
if (randomPositions == true) then -- place players without regard to grouping teams together		
	
	--Start Position Stuff---------------------------------------------------------------------------------
	
	if(worldTerrainWidth <= 417) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2
		innerExclusion = 0.45
		topSelectionThreshold = 0.1
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 1
	elseif(worldTerrainWidth <= 513) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2
		innerExclusion = 0.45
		topSelectionThreshold = 0.033
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 1
	elseif(worldTerrainWidth <= 641) then
		minTeamDistance = Round((#terrainLayoutResult * 1.2))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 2
		innerExclusion = 0.5
		topSelectionThreshold = 0.05
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 2
	elseif(worldTerrainWidth <= 769) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 3
		innerExclusion = 0.5
		topSelectionThreshold = 0.05
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 3
	else
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.6))
		edgeBuffer = 3
		innerExclusion = 0.5
		topSelectionThreshold = 0.1
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 3
	end
	
	startBufferRadius = 3
	startBufferTerrain = tt_plains
	
	teamMappingTable = CreateTeamMappingTable()
	
	
	impasseTypes = {tt_mountains_small}
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
	
	if(worldTerrainWidth <= 417) then
		minTeamDistance = Round((#terrainLayoutResult * 1.2))
		minPlayerDistance = 5
		edgeBuffer = 2
		innerExclusion = 0.45
		topSelectionThreshold = 0.1
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 1
	elseif(worldTerrainWidth <= 513) then
		minTeamDistance = Round((#terrainLayoutResult * 1.2))
		minPlayerDistance = 3.75
		edgeBuffer = 2
		innerExclusion = 0.45
		topSelectionThreshold = 0.033
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 1
	elseif(worldTerrainWidth <= 641) then
		minTeamDistance = Round((#terrainLayoutResult * 1.2))
		minPlayerDistance = 5
		edgeBuffer = 2
		innerExclusion = 0.5
		topSelectionThreshold = 0.075
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 2
	elseif(worldTerrainWidth <= 769) then
		minTeamDistance = Round((#terrainLayoutResult * 1.2))
		minPlayerDistance = 4
		edgeBuffer = 3
		innerExclusion = 0.55
		topSelectionThreshold = 0.075
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 3
	else
		minTeamDistance = Round((#terrainLayoutResult * 1.2))
		minPlayerDistance = 5
		edgeBuffer = 3
		innerExclusion = 0.55
		topSelectionThreshold = 0.1
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
		cornerThreshold = 3
	end
	
	startBufferRadius = 3
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

end

--ensure that the edge of the map is flat
for row = 1, gridSize do
	for col = 1, gridSize do
		if((terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) and (row == 1 or row == gridSize or col == 1 or col == gridSize)) then
			terrainLayoutResult[row][col].terrainType = tt_plains
		end
	end
end

--pick a spot on the edge of the map
randomFirstCoord = math.ceil(worldGetRandom() * #terrainLayoutResult)
randomSecondCoord = #terrainLayoutResult - randomFirstCoord

if(randomSecondCoord < 1) then
	randomSecondCoord = 1
end
tradePostCoord1 = {}
tradePostCoord2 = {}
if(worldGetRandom() > 0.5) then
	tradePostCoord1 = {1, randomFirstCoord}
	tradePostCoord2 = {#terrainLayoutResult, randomSecondCoord}
else
	tradePostCoord1 = {randomFirstCoord, 1}
	tradePostCoord2 = {randomSecondCoord, #terrainLayoutResult}
end



terrainLayoutResult[tradePostCoord1[1]][tradePostCoord1[2]].terrainType = tt_settlement_plains
terrainLayoutResult[tradePostCoord2[1]][tradePostCoord2[2]].terrainType = tt_settlement_plains


print("END OF DRY ARABIA LUA SCRIPT")
