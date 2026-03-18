-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--MEGARANDOM Map Script
print("generating MegaRandom")


--main function, makes high level map decision then calls supporting functions
local function main() 
	
	--create the course grid. This is the table that holds the terrain types that will be used to generate the map in a 2D grid
	terrainLayoutResult = {}    -- set up initial table for coarse map grid


	--High Level Decision: Are we playing on a land, water, or special map?
	highLevelWeightTable = {}

	--tuning data for weight of high level choices
	landWeight = 1.0
	waterWeight = 0.02
	specialWeight = 0.0025

	--create empty data point for cumulative weight also
	cumulativeWeightTable = {}

	--insert entries into this weight table containing our choices
	table.insert(highLevelWeightTable, {"land", landWeight, CreateLandMap})
	table.insert(highLevelWeightTable, {"water", waterWeight, CreateWaterMap})
	table.insert(highLevelWeightTable, {"special", specialWeight, CreateSpecialMap})


	--choose a style from the weighted table---------------------

	--total up the table weight in order to correctly be able to get a weighted selection
	totalHighLevelWeight = 0
	for index, weightedElement in ipairs(highLevelWeightTable) do
		cumulativeWeightTable[index] = totalHighLevelWeight + weightedElement[2]
		totalHighLevelWeight = totalHighLevelWeight + weightedElement[2]
	end

	--make a weighted selection

	currentWeight = worldGetRandom() * totalHighLevelWeight
	currentSelection = 0

	--loop through however many times based on number of elements in the selection list
	for index = 1, #highLevelWeightTable do
		
		--loop through cumulative weights until we find the correct value range
		if(currentWeight < cumulativeWeightTable[index]) then
			currentSelection = index
			break
		end
	end

	--execute the function of the chosen index
	highLevelWeightTable[currentSelection][3]()

end

-------------------------------------------------------------------------
-------------------------------------------------------------------------

--functions for high-level map archetypes

--function to set up generating any regular land-based map
CreateLandMap = function()
	
	print("created land map!")
	minRes = 24
	maxRes = 30
	mapRes = math.ceil(GetRandomInRange(minRes, maxRes, 0))
	
	--[[
	if(worldTerrainWidth <= 513) then
		mapRes = 28
	elseif(worldTerrainWidth <= 769) then
		mapRes = 28
	else
		mapRes = 28
	end
	--]]
	--set terrain dimensions for a standard land map
	gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(mapRes)
	--gridHeight, gridWidth, gridSize = SetCoarseGrid()
	
	terrainLayoutResult = SetUpGrid(gridSize, tt_none, terrainLayoutResult)
	
	--TERRAIN TYPES------------------------------------------------
	--create a table for the basic terrain types to use
	basicTerrain = {}
	
	--create a table for the impasse terrain types to use
	impasseTerrain = {}
	
	--tuning data for the different types of terrain to use
	
	maxTerrainChoices = 3
	currentTerrainChoices = 0
	
	--basic terrain
	plainsWeight = 0.9
	hillsGentleWeight = 0.4
	hillsLowWeight = 0.35
	valleyWeight = 0.35
	plateauLowWeight = 0.35
	plateauStandardWeight = 0.25
	stealthForestWeight = 0.2
	swampWeight = 0.25
	denseForestsWeight = 0.2
	
	--impasse terrain
	mountainsWeight = 0.75
	impasseMountainsWeight = 0.25
	lakeWeight = 0.5
	oceanWeight = 0.75
	
	--go through terrain types and add them based on their probability
	local function fillTerrainTables()
		
		--fill the basic terrain type table
		
		table.insert(basicTerrain, tt_plains)
	
		if(worldGetRandom() < hillsGentleWeight) then
			table.insert(basicTerrain, tt_hills_gentle_rolling)
		end
		
		if(worldGetRandom() < hillsLowWeight) then
			table.insert(basicTerrain, tt_hills_low_rolling)
		end
		
		
		if(worldGetRandom() < valleyWeight) then
			table.insert(basicTerrain, tt_valley_shallow)
		end
		
		
		
		if(worldGetRandom() < swampWeight) then
			table.insert(basicTerrain, tt_swamp)
		end
		
		if(worldGetRandom() < stealthForestWeight) then
			table.insert(basicTerrain, tt_trees_plains_stealth_large)
		end
		
		
		--fill the impasse terrain type table
		
		table.insert(impasseTerrain, tt_impasse_trees_plains)
		
		
		
		
	--	if(worldGetRandom() < impasseMountainsWeight) then
	--		table.insert(impasseTerrain, tt_impasse_mountains)
	--	end
		
		
		if(worldGetRandom() < plateauLowWeight) then
			table.insert(impasseTerrain, tt_plateau_low)
		end
		
		if(worldGetRandom() < plateauStandardWeight) then
			table.insert(impasseTerrain, tt_plateau_standard_small)
		end
		
		
		if(worldGetRandom() < lakeWeight) then
			table.insert(impasseTerrain, tt_lake_shallow)
		end
		
		if(worldGetRandom() < oceanWeight) then
			table.insert(impasseTerrain, tt_ocean)
		end
	end
	
	fillTerrainTables()
	
	playerStartTerrain = tt_player_start_classic_plains
	
	--EDGE STYLE---------------------------------------------------
	--create a weight table for the edge styles
	edgeStyleWeightTable = {}
	
	--tuning data for edge weight style
	oneEdgeWeight = 1
	twoEdgeWeight = 1.5
	if(worldTerrainHeight <= 513) then
		fourEdgeWeight = 0.0
	else
		fourEdgeWeight = 1.5
	end
	
	--create empty data point for cumulative weight also
	cumulativeWeightTable = {}
	
	table.insert(edgeStyleWeightTable, {"single edge", oneEdgeWeight, SetOneEdgeStyle})
	table.insert(edgeStyleWeightTable, {"two edges", twoEdgeWeight, SetTwoEdgeStyle})
	table.insert(edgeStyleWeightTable, {"four edges", fourEdgeWeight, SetFourEdgeStyle})
	
	
	--choose a style from the weighted table---------------------

	--total up the table weight in order to correctly be able to get a weighted selection
	totalEdgeStyleWeight = 0
	for index, weightedElement in ipairs(edgeStyleWeightTable) do
		cumulativeWeightTable[index] = totalEdgeStyleWeight + weightedElement[2]
		totalEdgeStyleWeight = totalEdgeStyleWeight + weightedElement[2]
	end
	
	--make a weighted selection

	currentWeight = worldGetRandom() * totalEdgeStyleWeight
	currentSelection = 0

	--loop through however many times based on number of elements in the selection list
	for index = 1, #edgeStyleWeightTable do
		
		--loop through cumulative weights until we find the correct value range
		if(currentWeight < cumulativeWeightTable[index]) then
			currentSelection = index
			break
		end
	end

	
	--execute the function of the chosen index. Edge styles should be impasse features to be interesting
	
	--set the spawn chance of edge features
	edgeSpawnChanceMin = 0.5
	edgeSpawnChanceMax = 1.0
	edgeSpawnChance = Normalize(worldGetRandom(), edgeSpawnChanceMin, edgeSpawnChanceMax)
	
	edgeStyleWeightTable[currentSelection][3](impasseTerrain, edgeSpawnChance, terrainLayoutResult)
	
	
	--remove ocean from the impasse table, as ocean should not go inland
	table.remove(impasseTerrain, #impasseTerrain)
	
	--add impasse mountains back in after edge terrain is chosen
	table.insert(impasseTerrain, tt_mountains_small)
	
	if(worldGetRandom() < mountainsWeight) then
		table.insert(impasseTerrain, tt_mountains)
	end
	
	--MAP STYLE----------------------------------------------------
	--create a weight table for the style of land map
	mapStyleWeightTable = {}
	
	--tuning data for land map styles
	openMapWeight = 0.65
	chokeMapWeight = 0.7
	mazeMapWeight = 1.1
	centreMapWeight = 0.2
	
	cumulativeWeightTable = {}
	
	table.insert(mapStyleWeightTable, {"open", openMapWeight, SetupOpenMap})
	table.insert(mapStyleWeightTable, {"choke", chokeMapWeight, SetupChokeMap})
	table.insert(mapStyleWeightTable, {"maze", mazeMapWeight, SetupMazeMap})
	table.insert(mapStyleWeightTable, {"centre", centreMapWeight, SetupCentreMap})
	
	--choose a style from the weighted table---------------------

	--total up the table weight in order to correctly be able to get a weighted selection
	totalMapStyleWeight = 0
	for index, weightedElement in ipairs(mapStyleWeightTable) do
		cumulativeWeightTable[index] = totalMapStyleWeight + weightedElement[2]
		totalMapStyleWeight = totalMapStyleWeight + weightedElement[2]
	end
	
	--make a weighted selection

	currentWeight = worldGetRandom() * totalMapStyleWeight
	currentSelection = 0

	--loop through however many times based on number of elements in the selection list
	for index = 1, #mapStyleWeightTable do
		
		--loop through cumulative weights until we find the correct value range
		if(currentWeight < cumulativeWeightTable[index]) then
			currentSelection = index
			break
		end
	end
	
	
	
	print("chose map style: " .. mapStyleWeightTable[currentSelection][1])
	mapStyleWeightTable[currentSelection][3]()
	
	
	--do rivers
	riverResult = {}
	fordResults = {}
	woodBridgeResults = {}
	stoneBridgeResults = {}
	
	--set river variables
	minRiverNum = -3
	maxRiverNum = 2
	
	minTributaryNum = 0
	maxTributaryNum = 2
	
	minPathVariation = 0.2
	maxPathVariation = 0.95
	
	minDirectionRandomness = 0.15
	maxDirectionRandomness = 0.95
	
	riverNum = Round(Normalize(worldGetRandom(), minRiverNum, maxRiverNum), 0)
	if(riverNum < 0) then
		riverNum = 0
	end
	tributaryNum = Round(Normalize(worldGetRandom(), 0, riverNum), 0)
	pathVariation = Normalize(worldGetRandom(), minPathVariation, maxPathVariation)
	directionRandomness = Normalize(worldGetRandom(), minDirectionRandomness, maxDirectionRandomness)
	
	bridgeChance = 0
	placeBridges = false
	if(worldGetRandom() < bridgeChance) then
		placeBridges = true
	end
	
	riverResult, fordResults, woodBridgeResults, stoneBridgeResults = CreateRivers(riverNum, tributaryNum, pathVariation, directionRandomness, placeBridges, terrainLayoutResult)
	
	if(riverNum > 0) then
		
		--check for fords
		if(#fordResults > 0) then
			for riverIndex = 1, riverNum do
				for index, currentFordPoint in ipairs(fordResults[riverIndex]) do
					
					currentRow = currentFordPoint[1]
					currentCol = currentFordPoint[2]
					
					currentFordNeighbors = Get12Neighbors(currentRow, currentCol, terrainLayoutResult)
					
					for neighborIndex, fordNeighbor in ipairs(currentFordNeighbors) do	
						currentNeighborRow = fordNeighbor.x
						currentNeighborCol = fordNeighbor.y
						
						if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_river and terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= playerStartTerrain) then
							terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
						end
					end
				end
			end
			
		end
		
		--check for bridges
		if(#woodBridgeResults > 0) then
			for bridgeIndex = 1, riverNum do
				for index, currentBridgePoint in ipairs(woodBridgeResults[bridgeIndex]) do
					
					currentRow = currentBridgePoint[1]
					currentCol = currentBridgePoint[2]
					
					currentBridgeNeighbors = Get12Neighbors(currentRow, currentCol, terrainLayoutResult)
					
					for neighborIndex, BridgeNeighbor in ipairs(currentBridgeNeighbors) do	
						currentNeighborRow = BridgeNeighbor.x
						currentNeighborCol = BridgeNeighbor.y
						
						if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_river and terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= playerStartTerrain) then
							terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
						end
					end
				end
			end
			
		end
		
		if(#stoneBridgeResults > 0) then
			for bridgeIndex = 1, riverNum do
				for index, currentBridgePoint in ipairs(stoneBridgeResults[bridgeIndex]) do
					
					currentRow = currentBridgePoint[1]
					currentCol = currentBridgePoint[2]
					
					currentBridgeNeighbors = Get12Neighbors(currentRow, currentCol, terrainLayoutResult)
					
					for neighborIndex, BridgeNeighbor in ipairs(currentBridgeNeighbors) do	
						currentNeighborRow = BridgeNeighbor.x
						currentNeighborCol = BridgeNeighbor.y
						
						if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_river and terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= playerStartTerrain) then
							terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
						end
					end
				end
			end
			
		end
	end
	
	--do player starts
	teamMappingTable = CreateTeamMappingTable()
	
	minTeamDistance = gridSize * 1.2
	minPlayerDistance = math.ceil(gridSize * 0.3)
	edgeBuffer = 2
	lakeSizeMod = 1.0
	if(worldTerrainWidth <= 417) then
		edgeBuffer = 1
		innerExclusion = 0.35
		topSelectionThreshold = 0.001
		impasseDistance = 1.5
	elseif(worldTerrainWidth <= 513) then
		edgeBuffer = 1
		innerExclusion = 0.35
		topSelectionThreshold = 0.001
		impasseDistance = 1.5
		if(worldPlayerCount > 2) then
			lakeSizeMod = 0.65
		end
		
	elseif(worldTerrainWidth <= 641) then
		edgeBuffer = 2
		innerExclusion = 0.375
		topSelectionThreshold = 0.001
		impasseDistance = 1.5
		if(worldPlayerCount > 2) then
			lakeSizeMod = 0.65
		end
	elseif(worldTerrainWidth <= 769) then
		edgeBuffer = 2
		innerExclusion = 0.4
		topSelectionThreshold = 0.001
		impasseDistance = 1.5
		if(worldPlayerCount > 4) then
			lakeSizeMod = 0.65
		end
	else
		edgeBuffer = 2
		innerExclusion = 0.45
		topSelectionThreshold = 0.001
		impasseDistance = 1.5
		if(worldPlayerCount > 5) then
			lakeSizeMod = 0.5
		end
	end
	
	startBufferTerrain = tt_plains_smooth
	startBufferRadius = math.ceil(gridSize / 12)
	
	--check for maze map settings
	if(currentSelection == 3) then
		minTeamDistance = gridSize * 1.2
		minPlayerDistance = math.ceil(gridSize * 0.35)
	end
	
	table.insert(impasseTerrain, tt_ocean)
	
	cornerThreshold = 1
	
	spawnBlockers = {}
	table.insert(spawnBlockers, tt_impasse_mountains)
	table.insert(spawnBlockers, tt_mountains)
	table.insert(spawnBlockers, tt_plateau_med)
	table.insert(spawnBlockers, tt_ocean)
	table.insert(spawnBlockers, tt_river)
--	terrainLayoutResult = PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, {}, basicTerrain, playerStartTerrain, terrainLayoutResult)
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)

	print("finished player placement, moving on to lakes")
	
	lakeChance = 0.75
	
	if(worldGetRandom() < lakeChance and riverNum == 0) then
		
		--do lakes
		minExtraLakes = 0
		maxExtraLakes = 3
		
		--min lake size 10% land coverage
		minLakeSize = math.ceil(((gridSize * gridSize) * 0.015) / maxExtraLakes)
		--max lake size 20% land coverage
		maxLakeSize = math.ceil(((gridSize * gridSize) * 0.15) / maxExtraLakes)
		maxLakeCoverage = math.ceil(((gridSize * gridSize) * 0.2) * lakeSizeMod)
		--if an open map, allow more lakes that can be larger
		if(currentSelection == 1) then
			minExtraLakes = 0
			maxExtraLakes = 5
		
			--min lake size 15% land coverage
			minLakeSize = math.ceil(((gridSize * gridSize) * 0.015) / maxExtraLakes)
			--max lake size 35% land coverage
			maxLakeSize = math.ceil(((gridSize * gridSize) * 0.2) / maxExtraLakes)
			maxLakeCoverage = math.ceil(((gridSize * gridSize) * 0.275) * lakeSizeMod)
		end
		
		
		print("min lake size calculated is " .. minLakeSize .. " and maxLakeSize is " .. maxLakeSize)
		--now fill out real lakes
		lakeBlockers = {}
		table.insert(lakeBlockers, tt_impasse_mountains)
		table.insert(lakeBlockers, tt_mountains)
		table.insert(lakeBlockers, tt_mountains_small)
		table.insert(lakeBlockers, tt_plateau_med)
		table.insert(lakeBlockers, tt_plateau_standard_small)
		table.insert(lakeBlockers, tt_plateau_low)
		table.insert(lakeBlockers, tt_ocean)
		table.insert(lakeBlockers, tt_river)
		table.insert(lakeBlockers, tt_player_start_classic_plains)
		table.insert(lakeBlockers, tt_plains_smooth)
		table.insert(lakeBlockers, tt_lake_shallow)
		
		lakeImpasse = {}
		table.insert(lakeImpasse, tt_impasse_mountains)
		table.insert(lakeImpasse, tt_mountains)
		table.insert(lakeImpasse, tt_mountains_small)
		table.insert(lakeImpasse, tt_plateau_med)
		table.insert(lakeImpasse, tt_plateau_standard_small)
		table.insert(lakeImpasse, tt_plateau_low)
		
		
		CreateLakes(minExtraLakes, maxExtraLakes, minLakeSize, maxLakeSize, lakeBlockers, basicTerrain, maxLakeCoverage, terrainLayoutResult)
		
		--do a smoothing pass on larger lakes to fill in gaps of what would be a contiguous lake
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				adjLakes = {}
				adjLakeNum = 0
				--do a check to ensure adjacency checks are in bounds
				if(IsInMap (row, col, gridSize, gridSize)) then
					--check to see if the current square is a spire
					adjLakes = Get8Neighbors(row, col, terrainLayoutResult)
					
					
					for testNeighborIndex, testNeighbor in ipairs(adjLakes) do
						testNeighborRow = testNeighbor.x
						testNeighborCol = testNeighbor.y
						currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
						
						if(currentTerrainType == tt_lake_shallow) then
							adjLakeNum = adjLakeNum + 1
						end
					end
					
					--check to see if the majority of neighbors are lakes. If so, we want to fill in this square to make a contiguous lake for better terrain blending
					if(adjLakeNum > 4) then
						
						print("found a square to fill for a larger contiguous lake")
						terrainLayoutResult[row][col].terrainType = tt_lake_shallow	
					end
				end
			end
		end
		
		--make a pass to make inner lake squares deep
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				adjLakes = {}
				adjImpasse = 0
				--do a check to ensure adjacency checks are in bounds
				--function found in the engine folder, under scar/terrainlayout/library/calculationfunctions
				if(IsInMap (row, col, gridSize, gridSize)) then
					--check to see if the current square is a lake
					if(terrainLayoutResult[row][col].terrainType == tt_lake_shallow) then
						
						
						--GetNeighbors looks at the terrain grid and returns a table containing the squares above, below, and to the left and right of the specified square
						--function found in scar/terrainlayout/library/template_functions
						adjLakes = GetNeighbors(row, col, terrainLayoutResult)
						
						--loop through neighbors of the current square to look for lakes or impasse
						for testNeighborIndex, testNeighbor in ipairs(adjLakes) do
							testNeighborRow = testNeighbor.x
							testNeighborCol = testNeighbor.y
							currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
							isImpasse = false
							for impasseIndex = 1, #lakeBlockers do
								if(currentTerrainType == lakeBlockers[impasseIndex]) then
									isImpasse = true
								end
							end
							if(currentTerrainType == tt_lake_shallow or currentTerrainType == tt_lake_deep or isImpasse == true) then
								adjImpasse = adjImpasse + 1
							end
						end
						
						--check to see if it found any adjacent impasse
						if(adjImpasse > 3) then
							
							print("found an inner lake square")
							--if it found an inner lake square, set it to be deep
						--	terrainLayoutResult[row][col].terrainType = tt_lake_deep
						
						end
						
						
					end
					
					
					if(terrainLayoutResult[row][col].terrainType == tt_lake_deep) then
						
						
						--GetNeighbors looks at the terrain grid and returns a table containing the squares above, below, and to the left and right of the specified square
						--function found in scar/terrainlayout/library/template_functions
						adjLakes = GetNeighbors(row, col, terrainLayoutResult)
						
						--loop through neighbors of the current square to look for lakes or impasse
						for testNeighborIndex, testNeighbor in ipairs(adjLakes) do
							testNeighborRow = testNeighbor.x
							testNeighborCol = testNeighbor.y
							currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
							isImpasse = false
							for impasseIndex = 1, #lakeBlockers do
								if(currentTerrainType == lakeBlockers[impasseIndex]) then
									isImpasse = true
								end
							end
							if(currentTerrainType == tt_lake_shallow or currentTerrainType == tt_lake_deep or isImpasse == true) then
								adjImpasse = adjImpasse + 1
							end
							if(isImpasse == false and currentTerrainType ~= tt_lake_deep) then
								terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_lake_shallow
							end
						end
						
						--check to see if it found any adjacent impasse
						if(adjImpasse == 0) then
							
							print("found a lone lake square")
							--if it found an inner lake square, set it to be deep
							for testNeighborIndex, testNeighbor in ipairs(adjLakes) do
								testNeighborRow = testNeighbor.x
								testNeighborCol = testNeighbor.y
								terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_lake_shallow
							end
							
						end
					end
					
				end
			end
		end
		
		
		--smooth land around lakes to make them accessible
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				adjLakes = {}
				adjImpasse = 0
				--do a check to ensure adjacency checks are in bounds
				--function found in the engine folder, under scar/terrainlayout/library/calculationfunctions
				if(IsInMap (row, col, gridSize, gridSize)) then
					--check to see if the current square is a lake
					if(terrainLayoutResult[row][col].terrainType == tt_lake_shallow) then
						
						
						--GetNeighbors looks at the terrain grid and returns a table containing the squares above, below, and to the left and right of the specified square
						--function found in scar/terrainlayout/library/template_functions
						adjLakes = Get8Neighbors(row, col, terrainLayoutResult)
						isThirdValley = 1
						--loop through neighbors of the current square to look for lakes or impasse
						for testNeighborIndex, testNeighbor in ipairs(adjLakes) do
							testNeighborRow = testNeighbor.x
							testNeighborCol = testNeighbor.y
							currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
							isImpasse = false
							for impasseIndex = 1, #lakeImpasse do
								if(currentTerrainType == lakeImpasse[impasseIndex]) then
									isImpasse = true
								end
							end
							if(isImpasse == false and currentTerrainType ~= tt_lake_shallow and currentTerrainType ~= tt_lake_deep and currentTerrainType ~= tt_impasse_trees_plains) then
								if(isThirdValley == 3) then
									if(worldGetRandom() > 0.5) then
										terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_valley_shallow
									else
										terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_swamp
									end
									isThirdValley = 1
								else
									terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_plains
									isThirdValley = isThirdValley + 1
								end
							elseif(isImpasse == true and currentTerrainType ~= tt_lake_shallow and currentTerrainType ~= tt_lake_deep and currentTerrainType ~= tt_impasse_trees_plains) then
								if(isThirdValley == 3) then
									terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_hills_low_rolling
									isThirdValley = 1
								else
									terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_hills_gentle_rolling
									isThirdValley = isThirdValley + 1
								end
							end
						end
						
					end
				end
				
			end
		end
	end
	
	for row = 1, gridSize do
		for col = 1, gridSize do
			if((terrainLayoutResult[row][col].terrainType == tt_mountains or terrainLayoutResult[row][col].terrainType == tt_impasse_mountains) and (row == 1 or row == gridSize or col == 1 or col == gridSize)) then
				terrainLayoutResult[row][col].terrainType = tt_mountains_small
			end
		end
	end
	
	--reduce corner mountains
	for row = 1, gridSize do
		for col = 1, gridSize do
			if((terrainLayoutResult[row][col].terrainType == tt_mountains or terrainLayoutResult[row][col].terrainType == tt_impasse_mountains) and 
					((row == 1 and col == 1) or (row == gridSize and col == gridSize) or (row == gridSize and col == 1) or (row == 1 and col == gridSize))) then
				terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
			end
		end
	end
	
	--reduce adjacent large mountains
	adjThreshold = 3
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			adjMountains = {}
			adjImpasse = 0
			--do a check to ensure adjacency checks are in bounds
			--function found in the engine folder, under scar/terrainlayout/library/calculationfunctions
			if(IsInMap (row, col, gridSize, gridSize)) then
				--check to see if the current square is a lake
				if(terrainLayoutResult[row][col].terrainType == tt_mountains) then
					
					
					--GetNeighbors looks at the terrain grid and returns a table containing the squares above, below, and to the left and right of the specified square
					--function found in scar/terrainlayout/library/template_functions
					adjMountains = Get8Neighbors(row, col, terrainLayoutResult)
					
					--loop through neighbors of the current square to look for impasse
					for testNeighborIndex, testNeighbor in ipairs(adjMountains) do
						testNeighborRow = testNeighbor.x
						testNeighborCol = testNeighbor.y
						currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
						
						if(currentTerrainType == tt_mountains) then
							adjImpasse = adjImpasse + 1
						end
						
					end
					if(adjImpasse >= adjThreshold and currentTerrainType ~= tt_holy_site_hill) then
						
						terrainLayoutResult[row][col].terrainType = tt_mountains_small
					end
					
				end
			end
			
		end
	end
	
	--eliminate bodies of water on river maps
	if(riverNum > 0) then
		for row = 1, gridSize do
			for col = 1, gridSize do
				if(riverNum ~= 0) then
					if(terrainLayoutResult[row][col].terrainType == tt_ocean or terrainLayoutResult[row][col].terrainType == tt_lake_deep or terrainLayoutResult[row][col].terrainType == tt_lake_shallow) then
						terrainLayoutResult[row][col].terrainType = tt_swamp
					end
				end
			end
		end
	end
	
	
	--remove trees and water around start positions
	for row = 1, gridSize do
		for col = 1, gridSize do
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				
				adjSquares = GetAllSquaresInRadius(row, col, 4, terrainLayoutResult)
						
				--loop through neighbors of the current square to look for trees
				for testNeighborIndex, testNeighbor in ipairs(adjSquares) do
					testNeighborRow = testNeighbor[1]
					testNeighborCol = testNeighbor[2]
					currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
					if(currentTerrainType == tt_impasse_trees_plains or currentTerrainType == tt_ocean or currentTerrainType == tt_lake_shallow or currentTerrainType == tt_lake_deep or currentTerrainType == tt_valley_shallow) then
						terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_plains
					end
				end
				
				adjSquares = GetAllSquaresInRadius(row, col, 2, terrainLayoutResult)
						
				--loop through neighbors of the current square to look for mountains
				for testNeighborIndex, testNeighbor in ipairs(adjSquares) do
					testNeighborRow = testNeighbor[1]
					testNeighborCol = testNeighbor[2]
					currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
					if(currentTerrainType == tt_mountains_small) then
						terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_plains
					end
				end
				
				--make sure there is a line towards the centre of the map that is clear of valleys to eliminate chance of solitary island spawns
				lineToMid = {}
				lineToMid = DrawLineOfTerrainNoDiagonalReturn(row, col, math.ceil(#terrainLayoutResult / 2), math.ceil(#terrainLayoutResult / 2), false, tt_plains, #terrainLayoutResult, terrainLayoutResult)
					
				for lineIndex = 1, #lineToMid do
					
					lineRow = lineToMid[lineIndex][1]
					lineCol = lineToMid[lineIndex][2]
					
					adjSquares = GetNeighbors(lineRow, lineCol, terrainLayoutResult)
					
					if(terrainLayoutResult[lineRow][lineCol].terrainType == tt_valley_shallow) then
						terrainLayoutResult[lineRow][lineCol].terrainType = tt_plains
					end
					
					for testNeighborIndex, testNeighbor in ipairs(adjSquares) do
						testNeighborRow = testNeighbor.x
						testNeighborCol = testNeighbor.y
						currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
						if(currentTerrainType == tt_valley_shallow) then
							terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_plains
						end
					end
				end
				
					
			end
		end
	end
	
	--do extra resources
	halfMap = math.ceil(#terrainLayoutResult / 2)
	terrainLayoutResult[halfMap][halfMap].terrainType = tt_holy_site_hill
	sacredSiteNeighbors = {}
	sacredSiteNeighbors = GetNeighbors(halfMap, halfMap, terrainLayoutResult)
		
	for neighborIndex, sacredSiteNeighbor in ipairs(sacredSiteNeighbors) do
		row = sacredSiteNeighbor.x
		col = sacredSiteNeighbor.y
		
		terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth
		
	end
	
	richMapChance = 0.015
	if(worldGetRandom() < richMapChance) then
		print("generating a RICH map")
		--gather up all plains squares
		plainsSquares = {}
		for row = 1, #terrainLayoutResult do
			for col = 1, #terrainLayoutResult do
			
				if(terrainLayoutResult[row][col].terrainType == tt_plains) then
					newInfo = {}
					newInfo = {row, col}
					table.insert(plainsSquares, newInfo)
				end
			end
		end
		
		--tuning data for rich resource styles
		berriesWeight = 0.65
		deerWeight = 0.45
		boarWeight = 0.35
		wolfWeight = 0.25
		stoneWeight = 1.75
		goldWeight = 1.25
		
		cumulativeWeightTable = {}
		resourceWeightTable = {}
		table.insert(resourceWeightTable, {"berries", berriesWeight, tt_pocket_berries})
		table.insert(resourceWeightTable, {"deer", deerWeight, tt_deer_spawner})
		table.insert(resourceWeightTable, {"boar", boarWeight, tt_deer_spawner})
		table.insert(resourceWeightTable, {"wolf", wolfWeight, tt_wolf_spawner})
		table.insert(resourceWeightTable, {"stone", stoneWeight, tt_tactical_region_stone_plains_a})
		table.insert(resourceWeightTable, {"gold", goldWeight, tt_tactical_region_gold_plains_a})
		
		--choose a style from the weighted table---------------------
	
		--total up the table weight in order to correctly be able to get a weighted selection
		totalMapStyleWeight = 0
		for index, weightedElement in ipairs(resourceWeightTable) do
			cumulativeWeightTable[index] = totalMapStyleWeight + weightedElement[2]
			totalMapStyleWeight = totalMapStyleWeight + weightedElement[2]
		end
		
		--make a weighted selection
	
		currentWeight = worldGetRandom() * totalMapStyleWeight
		currentSelection = 0
	
		--loop through however many times based on number of elements in the selection list
		for index = 1, #resourceWeightTable do
			
			--loop through cumulative weights until we find the correct value range
			if(currentWeight < cumulativeWeightTable[index]) then
				currentSelection = index
				break
			end
		end
		
		chosenTerrain = resourceWeightTable[currentSelection][3]
		chosenString = resourceWeightTable[currentSelection][1]
		print("rich resource type chosen was " .. chosenString)
		minRichSquares = math.ceil((#terrainLayoutResult * #terrainLayoutResult) / 25)
		maxRichSquares = math.ceil((#terrainLayoutResult * #terrainLayoutResult) / 12)
		chosenRichSquares = math.ceil(GetRandomInRange(minRichSquares, maxRichSquares))
		if(#plainsSquares > 0) then
			
			if(chosenRichSquares > #plainsSquares) then
				chosenRichSquares = #plainsSquares
			end
			
			for squareIndex = 1, chosenRichSquares do
				
				randomIndex = math.ceil(worldGetRandom() * #plainsSquares)
				randomRow = plainsSquares[randomIndex][1]
				randomCol = plainsSquares[randomIndex][2]
				
				terrainLayoutResult[randomRow][randomCol].terrainType = chosenTerrain
				
				table.remove(plainsSquares, randomIndex)
			end
		end
		
		
	end
end



SetupOpenMap = function()
	
	--set chance for impasse terrain to spawn
	minImpasseChance = 0.05
	maxImpasseChance = 0.15
	impasseChance = Normalize(worldGetRandom(), minImpasseChance, maxImpasseChance)
	
	CreateOpenMap(basicTerrain, impasseTerrain, impasseChance, terrainLayoutResult)
end

SetupChokeMap = function()
	
	--setup tuning data for the choke point style maps
	
	minImpasseLines = 1
	maxImpasseLines = 4
	impasseLines = math.ceil(Normalize(worldGetRandom(), minImpasseLines, maxImpasseLines))
	
	minGaps = 1
	maxGaps = 3
	
	minEdge = math.ceil(gridSize * 0.2)
	maxEdge = math.ceil(gridSize * 0.8)
	
	CreateChokeMap(basicTerrain, impasseTerrain, impasseLines, minGaps, maxGaps, minEdge, maxEdge, terrainLayoutResult)
	
	
end

SetupMazeMap = function()
	
	colGapMin = 2
	colGapMax = 4
	columnGap = math.ceil(Normalize(worldGetRandom(), colGapMin, colGapMax))
	CreateMazeMap(basicTerrain, impasseTerrain, columnGap, terrainLayoutResult)
	
	
end

SetupCentreMap = function()
	
	--tuning values for centre feature map
	if(worldTerrainWidth <= 417) then
		minCentreFeatures = 1
		maxCentreFeatures = 1
	elseif(worldTerrainWidth <= 513) then
		minCentreFeatures = 1
		maxCentreFeatures = 1
	elseif(worldTerrainWidth <= 641) then
		minCentreFeatures = 1
		maxCentreFeatures = 2
	elseif(worldTerrainWidth <= 769) then
		minCentreFeatures = 1
		maxCentreFeatures = 3
	else
		minCentreFeatures = 1
		maxCentreFeatures = 4
	end
	

	centreFeatureNum = math.ceil(Normalize(worldGetRandom(), minCentreFeatures, maxCentreFeatures))
	
	minFeatureRadius = 1 
	maxFeatureRadius = 2
	
	--chance of extra impasse spawning
	impasseChance = 0.065
	
	CreateCentreMap(basicTerrain, impasseTerrain, centreFeatureNum, minFeatureRadius, maxFeatureRadius, impasseChance, terrainLayoutResult)
end

--function to set up any water map
CreateWaterMap = function()
	
	print("created water map!")
	
	mapRes = 15
	
	--create the map grid with appropriate resolution for island maps
	if(worldTerrainWidth <= 513) then
		mapRes = 15
	elseif(worldTerrainWidth <= 769) then
		mapRes = 20
	else
		mapRes = 22
	end
	
	--set up the coarse grid and set the initial map to be full of ocean
	gridWidth, gridHeight, gridSize = SetCustomCoarseGrid(mapRes)
	
	terrainLayoutResult = SetUpGrid(gridSize, tt_ocean, terrainLayoutResult)
	
	playerStartTerrain = tt_player_start_classic_plains_naval
	
	--start setting up all the island variables---------------------------------------------------
	
	--set the potential gap along the edge of the map
	
	
	teamMappingTable = CreateTeamMappingTable()
	numTeams = #teamMappingTable
	
	--check to see if teams together or apart was selected in the front end
	if(randomPositions == false) then
		--this is Teams Together, so make fewer, larger islands
		
		minEdgeGap = 0
		minLandCoverage = 0.775
		maxLandCoverage = 0.9
		
		--set variables per map size
		if(worldTerrainWidth <= 417) then
			playerEdgeGap = 1
			maxEdgeGap = 0
			distanceBetweenIslands = 4
			distanceBetweenIslandsExtra = 3.5
			islandSize = 124
			islandGap = 3
			minIslandGap = 3
			maxIslandGap = 3
			mapRes = 15
			minIslandNum = worldPlayerCount + 2
			maxIslandNum = 5
			islandVariance = 2
			landCoverage = 0.95
			equalIslandLandPercent = 0.25
			innerExclusion = 0.495
			inlandRadius = 3
			startBufferRadius = 2
			impasseDistance = 2
			extraIslandSize = 84
		--	distanceBetweenIslands = math.ceil(mapRes * 0.95)
			
			minTeamDistance = math.ceil(mapRes * 1.4)
			minPlayerDistance = 10
			
			impasseTypes = {}
			table.insert(impasseTypes, tt_impasse_mountains)
			table.insert(impasseTypes, tt_mountains)
			table.insert(impasseTypes, tt_plateau_med)
			table.insert(impasseTypes, tt_plateau_low)
		
		
		elseif(worldTerrainWidth <= 513) then
			distanceBetweenIslandStarts = 3
			minIslandNum = numTeams + 1
			maxIslandNum = math.floor((numTeams * 2) + 4)
			minIslandGap = 3
			maxIslandGap = 4
			minLandCoverage = 0.775
			maxLandCoverage = 0.9
			maxEdgeGap = 0
		elseif(worldTerrainWidth <= 769) then
			distanceBetweenIslandStarts = 4
			minIslandNum = numTeams + 1
			maxIslandNum = math.floor((numTeams * 2) + 5)
			minIslandGap = 3
			maxIslandGap = 4
			minLandCoverage = 0.75
			maxLandCoverage = 0.85
			maxEdgeGap = 1
		else
			distanceBetweenIslandStarts = 7
			minIslandNum = numTeams + 1
			maxIslandNum = math.floor((numTeams * 1.75) + 6)
			minIslandGap = 3
			maxIslandGap = 4
			minLandCoverage = 0.75
			maxLandCoverage = 0.9
			maxEdgeGap = 2
		end
		
		
		
		edgeGap = Round(Normalize(worldGetRandom(), minEdgeGap, maxEdgeGap), 0)
		
		numIslands = math.ceil(Normalize(worldGetRandom(), minIslandNum, maxIslandNum))
		islandGap = math.ceil(Normalize(worldGetRandom(), minIslandGap, maxIslandGap))
		landCoverage = Normalize(worldGetRandom(), minLandCoverage, maxLandCoverage)
		
		print("num of islands is " .. numIslands)
		print("island gap is " .. islandGap)
		print("land coverage is " .. landCoverage)
		
		--create island weight table
		weightTable = {}
		minExtraIslandWeight = 0.5
		maxExtraIslandWeight = 0.8
		for i = 1, numIslands do
			currentData = {}
			currentIslandWeight = 0
			if(i <= numTeams) then
				currentIslandWeight = 1
			else
				currentIslandWeight = Normalize(worldGetRandom(), minExtraIslandWeight, maxExtraIslandWeight)
			end
			currentData = {
				i,
				currentIslandWeight
			}
			table.insert(weightTable, currentData)
			
		end
		
		cliffChanceMin = 0.0075
		cliffChanceMax = 0.075
		cliffChance = Normalize(worldGetRandom(), cliffChanceMin, cliffChanceMax)
		
		inlandTerrainChanceMin = 0.05
		inlandTerrainChanceMax = 0.1
		inlandTerrainChance = Normalize(worldGetRandom(), inlandTerrainChanceMin, inlandTerrainChanceMax)
		
		inlandTerrain = {}
		table.insert(inlandTerrain, tt_mountains)
		table.insert(inlandTerrain, tt_hills_med_rolling)
		table.insert(inlandTerrain, tt_hills_low_rolling)
		table.insert(inlandTerrain, tt_plateau_standard_small)
	--	table.insert(inlandTerrain, tt_swamp)
		
		equalIslandLandPercentMin = 0.2
		equalIslandLandPercentMax = 0.55
		
		
		islandNumMin = 3
		islandNumMax = 12
		
		if(numIslands > islandNumMax) then
			numIslands = islandNumMax
		end
		
		teamsApartThreshold = 6
		
		islandNumToNormalize = ((numIslands - islandNumMin) / (islandNumMax - islandNumMin))
		print("islandNumToNormalize: " .. islandNumToNormalize)
		equalIslandLandPercent = Normalize((1 - (Normalize(islandNumToNormalize, equalIslandLandPercentMin, equalIslandLandPercentMax) - equalIslandLandPercentMin) / (equalIslandLandPercentMax - equalIslandLandPercentMin)), equalIslandLandPercentMin, equalIslandLandPercentMax)
		
		print("equal island percentage is " .. equalIslandLandPercent)
		forestChance = 0.025
		
		startingIslandCount = 2
		if(worldPlayerCount < 2) then
			startingIslandCount = 1
		end
		
		
		--CreateIslandsTeamsTogether(weightTable, landCoverage, distanceBetweenIslandStarts, edgeGap, islandGap, teamMappingTable, playerStartTerrain, cliffChance, inlandTerrainChance, inlandTerrain, terrainLayoutResult)
		if(worldTerrainWidth > 417) then
			CreateIslandsTeamsTogether(weightTable, numTeams, equalIslandLandPercent, landCoverage, distanceBetweenIslandStarts, edgeGap, islandGap, teamMappingTable, playerStartTerrain, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, terrainLayoutResult)
		else
			CreateIslandsTeamsApartEven(islandSize, startingIslandCount, numIslands, distanceBetweenIslands, edgeGap, innerExclusion, inlandRadius, islandGap, teamMappingTable, playerStartTerrain, startBufferRadius, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, minTeamDistance, minPlayerDistance, impasseTypes, impasseDistance, 0.01, playerEdgeGap, terrainLayoutResult, randomPositions)
			
			specialTerrain = {}
			specialTerrain = {tt_bounty_gold_plains, tt_bounty_stone_plains}
			
			extraIslands = {}
			totalIslandMin = 1
			totalIslandMax = 3
			totalIslandNum = math.ceil(Normalize(worldGetRandom(), totalIslandMin, totalIslandMax))
			
			equalIslands = false
			extraIslands = FillWithIslands(extraIslandSize, equalIslands, totalIslandNum, distanceBetweenIslandsExtra, 2, 0, 0, islandGap, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, impasseTypes, impasseDistance, specialTerrain, playerStartTerrain, terrainLayoutResult)

		end
	else
		--this is teams apart, so make more, smaller islands
		--set variables per map size
		if(worldTerrainWidth <= 417) then
			playerEdgeGap = 1
			distanceBetweenIslands = 4
			distanceBetweenIslandsExtra = 3.5
			islandSize = 94
			islandGap = 3
			mapRes = 15
			minIslandNum = worldPlayerCount + 2
			maxIslandNum = 5
			islandVariance = 2
			landCoverage = 0.95
			equalIslandLandPercent = 0.25
			innerExclusion = 0.495
			
			extraIslandSize = 68
		--	distanceBetweenIslands = math.ceil(mapRes * 0.95)
			
			--THIS IS TEAMS TOGETHER
			if(randomPositions == false) then
				minTeamDistance = math.ceil(mapRes * 1.4)
				minPlayerDistance = 10
			else
				minTeamDistance = math.ceil(mapRes * 1.4)
				minPlayerDistance = math.ceil(mapRes * 1.4)
			end
			
		elseif(worldTerrainWidth <= 513) then
			playerEdgeGap = 2
			distanceBetweenIslands = 4
			distanceBetweenIslandsExtra = 3.5
			islandSize = 104
			islandGap = 3
			mapRes = 15
			minIslandNum = worldPlayerCount + 2
			maxIslandNum = 7
			islandVariance = 2
			landCoverage = 0.95
			equalIslandLandPercent = 0.275
			innerExclusion = 0.495
			
			extraIslandSize = 66
		--	distanceBetweenIslands = math.ceil(mapRes * 0.85)
			
			if(randomPositions == false) then
				minTeamDistance = math.ceil(mapRes * 1.2)
				minPlayerDistance = 12
			else
				minTeamDistance = math.ceil(mapRes * 1.2)
				minPlayerDistance = math.ceil(mapRes * 1.2)
			end
			
			
		elseif(worldTerrainWidth <= 641) then
			playerEdgeGap = 2
			distanceBetweenIslands = 4
			distanceBetweenIslandsExtra = 3.5
			islandSize = 108
			islandGap = 3
			mapRes = 20
			minIslandNum = worldPlayerCount + 2
			if(minIslandNum < 5) then
				minIslandNum = 5
			end
			maxIslandNum = 9
			islandVariance = 6
			landCoverage = 0.95
			equalIslandLandPercent = 0.3
			innerExclusion = 0.495
			
			extraIslandSize = 66
		--	distanceBetweenIslands = math.ceil(mapRes * 0.85)
			
			if(randomPositions == false) then
				minTeamDistance = math.ceil(mapRes * 1.2)
				minPlayerDistance = 12
			else
				minTeamDistance = math.ceil(mapRes * 1.2)
				minPlayerDistance = math.ceil(mapRes * 1.2)
			end
			
			
		elseif(worldTerrainWidth <= 769) then
			playerEdgeGap = 3
			distanceBetweenIslands = 4
			distanceBetweenIslandsExtra = 3.5
			islandSize = 112
			islandGap = 3
			mapRes = 20
			minIslandNum = worldPlayerCount + 2
			if(minIslandNum < 7) then
				minIslandNum = 7
			end
			maxIslandNum = 10
			islandVariance = 6
			landCoverage = 0.9
			equalIslandLandPercent = 0.3
			innerExclusion = 0.525
			
			extraIslandSize = 66
		--	distanceBetweenIslands = math.ceil(mapRes * 0.85)
			
			if(randomPositions == false) then
				minTeamDistance = math.ceil(mapRes * 1.2)
				minPlayerDistance = 12
			else
				minTeamDistance = math.ceil(mapRes * 1.2)
				minPlayerDistance = math.ceil(mapRes * 1.2)
			end
			
		else
			playerEdgeGap = 3
			distanceBetweenIslands = 4
			distanceBetweenIslandsExtra = 3.5
			islandSize = 116
			islandGap = 3
			mapRes = 20
			minIslandNum = worldPlayerCount + 4
			if(minIslandNum < 9) then
				minIslandNum = 9
			end
			maxIslandNum = 14
			islandVariance = 7
			landCoverage = 0.95
			equalIslandLandPercent = 0.3
			innerExclusion = 0.625
			
			extraIslandSize = 66
		--	distanceBetweenIslands = math.ceil(mapRes * 0.85)
			
			if(randomPositions == false) then
				minTeamDistance = math.ceil(mapRes * 1.2)
				minPlayerDistance = 14
			else
				minTeamDistance = math.ceil(mapRes * 1.2)
				minPlayerDistance = math.ceil(mapRes * 1.2)
			end
			
		end

		
		numIslands = math.ceil(Normalize(worldGetRandom(), minIslandNum, maxIslandNum))
		edgeGap = Round(worldGetRandom() * 2, 0)
		--create island weight table
		weightTable = {}
		
		minExtraIslandWeight = 0.5
		maxExtraIslandWeight = 0.8
		for i = 1, numIslands do
			currentData = {}
			currentIslandWeight = 0
			if(i <= worldPlayerCount) then
				currentIslandWeight = 1
			else
				currentIslandWeight = Normalize(worldGetRandom(), minExtraIslandWeight, maxExtraIslandWeight)
			end
			currentData = {
				i,
				currentIslandWeight
			}
			table.insert(weightTable, currentData)
			
		end
		
		cliffChanceMin = 0.005
		cliffChanceMax = 0.075
		cliffChance = Normalize(worldGetRandom(), cliffChanceMin, cliffChanceMax)
		
		inlandTerrainChanceMin = 0.05
		inlandTerrainChanceMax = 0.225
		inlandTerrainChance = Normalize(worldGetRandom(), inlandTerrainChanceMin, inlandTerrainChanceMax)
		
		inlandTerrain = {}
		table.insert(inlandTerrain, tt_impasse_mountains)
		table.insert(inlandTerrain, tt_mountains)
		table.insert(inlandTerrain, tt_hills_med_rolling)
		table.insert(inlandTerrain, tt_hills_low_rolling)
		table.insert(inlandTerrain, tt_plateau_standard_small)
		
		impasseTypes = {}
		table.insert(impasseTypes, tt_impasse_mountains)
		table.insert(impasseTypes, tt_mountains)
		table.insert(impasseTypes, tt_plateau_med)
		table.insert(impasseTypes, tt_plateau_low)
		
		equalIslandLandPercentMin = 0.45
		equalIslandLandPercentMax = 0.7
		equalIslandLandPercent = Normalize(worldGetRandom(), equalIslandLandPercentMin, equalIslandLandPercentMax)
		
		forestChance = 0.025
		editedPlayerCount = worldPlayerCount
		totalIslandNum = math.ceil(Normalize(worldGetRandom(), minIslandNum, maxIslandNum)) - editedPlayerCount
		
		inlandRadius = 3
		impasseDistance = 1
		topSelectionThreshold = 0.01
		
		startBufferRadius = 2
		
		--CreateIslandsTeamsApart(weightTable, landCoverage, distanceBetweenIslandStarts, edgeGap, islandGap, teamMappingTable, playerStartTerrain, cliffChance, inlandTerrainChance, inlandTerrain, terrainLayoutResult)
		--CreateIslandsTeamsApart(weightTable, landCoverage, equalIslandLandPercent, worldPlayerCount, distanceBetweenIslandStarts, edgeGap, islandGap, teamMappingTable, playerStartTerrain, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, terrainLayoutResult)
	
		CreateIslandsTeamsApartEven(islandSize, worldPlayerCount, totalIslandNum, distanceBetweenIslands, edgeGap, innerExclusion, inlandRadius, islandGap, teamMappingTable, playerStartTerrain, startBufferRadius, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, minTeamDistance, minPlayerDistance, impasseTypes, impasseDistance, topSelectionThreshold, playerEdgeGap, terrainLayoutResult, randomPositions)

		specialTerrain = {}
		specialTerrain = {tt_bounty_gold_plains, tt_bounty_stone_plains}
		
		extraIslands = {}
		startingEdgeGap = 0
		equalIslands = false
		extraIslands = FillWithIslands(extraIslandSize, equalIslands, totalIslandNum, distanceBetweenIslandsExtra, startingEdgeGap, edgeGap, 0, islandGap, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, impasseTypes, impasseDistance, specialTerrain, playerStartTerrain, terrainLayoutResult)

	end
	
	--scan through islands for beaches that do not have player starts
	allIslands = {}
	nonPlayerIslands = {}
	playerIslands = {}
	tradePostMin = 1
	tradePostMax = 4
	navalTradePostCount = math.ceil(GetRandomInRange(tradePostMin, tradePostMax))
	
	for row = 1, #terrainLayoutResult do
		for col = 1, #terrainLayoutResult do
			
			currentCoord = {}
			currentCoord = {row, col}
		
			--check for a non-ocean square
			if(terrainLayoutResult[row][col].terrainType ~= tt_ocean) then
				alreadyExists = false
				--check to see if this square is already accounted for in the islands
				if(#allIslands > 0) then
					
					for islandIndex = 1, #allIslands do
						if(Table_ContainsCoordinateIndex(allIslands[islandIndex], currentCoord) == true) then
							print("found coordinate " .. row .. ", " .. col .. " already on an island")
							alreadyExists = true
						end
					end
				end
				
				if(alreadyExists == false) then
					currentIsland = {}
					print("flood filling for an island from " .. row .. ", " .. col)
					currentIsland = FloodFillIslands(row, col, tt_ocean)
					table.insert(allIslands, currentIsland)
					
					hasPlayerStart = false
					--check currentIsland for a player spawn
					for islandPointIndex = 1, #currentIsland do
						currentRow = currentIsland[islandPointIndex][1]
						currentCol = currentIsland[islandPointIndex][2]
						
						if(terrainLayoutResult[currentRow][currentCol].terrainType == playerStartTerrain) then
							hasPlayerStart = true	
						end
						
					end
					
					if(hasPlayerStart == false) then
						table.insert(nonPlayerIslands, currentIsland)
					else
						table.insert(playerIslands, currentIsland)
					end
				end
			end
		end
		
		
	end
	
	--ensure players have a path to the ocean on their island
	for row = 1, #terrainLayoutResult do
		for col = 1, #terrainLayoutResult do
			
			--check for a player start
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				--draw a line from the player start until it hits ocean
				centrePoint = math.ceil(#terrainLayoutResult/2)
				oceanPath = {}
				oceanPath = DrawLineOfTerrainNoDiagonalReturn(row, col, centrePoint, centrePoint, false, tt_plains, gridSize, terrainLayoutResult)
				
				--iterate through list
				for oceanIndex = 1, #oceanPath do
					currentRow = oceanPath[oceanIndex][1]
					currentCol = oceanPath[oceanIndex][2]
					if(terrainLayoutResult[currentRow][currentCol].terrainType ~= playerStartTerrain) then
						if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_ocean) then
							break
						else
							currentOceanPathNeighbors = {}
							currentOceanPathNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
							
							for neighborIndex, pathNeighbor in ipairs(currentOceanPathNeighbors) do
								--check if this bridge neighbor is a river tile
								currentNeighborRow = pathNeighbor.x
								currentNeighborCol = pathNeighbor.y 
								if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_ocean and terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= playerStartTerrain) then
									terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
								end
							end
							
						end
					end
				end
			end
		end
	end
	
		
	print("found " .. #nonPlayerIslands .. " non player islands")
	
	if(navalTradePostCount > #nonPlayerIslands) then
		navalTradePostCount = #nonPlayerIslands
	end
	print("naval trade post number is " .. navalTradePostCount)
	
	for tradePostIndex = 1, navalTradePostCount do
		--pick a random non-player island
		randomIslandIndex = math.ceil(worldGetRandom() * #nonPlayerIslands)
		
		randomIsland = nonPlayerIslands[randomIslandIndex]
		
		--find all beach squares on this island
		currentBeachSquares = {}
		for randomIslandSquareIndex = 1, #randomIsland do
			currentRandomRow = randomIsland[randomIslandSquareIndex][1]
			currentRandomCol = randomIsland[randomIslandSquareIndex][2]
			
			if(terrainLayoutResult[currentRandomRow][currentRandomCol].terrainType == tt_beach) then
				currentInfo = {}
				currentInfo = {currentRandomRow, currentRandomCol}
				table.insert(currentBeachSquares, currentInfo)
			end
		end
		
		--select a random beach square to spawn a trade post on
		if(#currentBeachSquares > 0) then
			randomBeachIndex = math.ceil(worldGetRandom() * #currentBeachSquares)
			currentBeachRow = currentBeachSquares[randomBeachIndex][1]
			currentBeachCol = currentBeachSquares[randomBeachIndex][2]
			print("assigning naval trade post at " .. currentBeachRow .. ", " .. currentBeachCol)
			terrainLayoutResult[currentBeachRow][currentBeachCol].terrainType = tt_settlement_naval
			
		end
	end
	
	--place holy sites on non player islands, if they exist
	if(#nonPlayerIslands == 1) then
		theIsland = nonPlayerIslands[1]
		randomIslandIndex = math.ceil(worldGetRandom() * #theIsland)
		currentRow = theIsland[randomIslandIndex][1]
		currentCol = theIsland[randomIslandIndex][2]
		
		terrainLayoutResult[currentRow][currentCol].terrainType = tt_holy_site_hill
		holyNeighbors = {}
		holyNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
		
		for testNeighborIndex, testNeighbor in ipairs(holyNeighbors) do
			testNeighborRow = testNeighbor.x
			testNeighborCol = testNeighbor.y
			currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
			if(currentTerrainType ~= playerStartTerrain) then
				terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_hills_gentle_rolling
			end
		end
		
		
	elseif(#nonPlayerIslands >= 2) then
		--pick 2 random islands and place holy sites on them
		islandIndex1 = math.ceil(worldGetRandom() * #nonPlayerIslands)
		islandIndex2 = math.ceil(worldGetRandom() * #nonPlayerIslands)
		
		if(islandIndex2 == islandIndex1 and islandIndex2 + 1 <= #nonPlayerIslands) then
			islandIndex2 = islandIndex2 + 1
		elseif(islandIndex2 == islandIndex1 and islandIndex2 - 1 > 0) then
			islandIndex2 = islandIndex2 - 1
		end
		
		print("island index 1: " .. islandIndex1)
		print("island index 2: " .. islandIndex2)
		
		island1 = nonPlayerIslands[islandIndex1]
		island2 = nonPlayerIslands[islandIndex2]
		
		randomSquareIndex1 = math.ceil(worldGetRandom() * #island1)
		randomSquareIndex2 = math.ceil(worldGetRandom() * #island2)
		
		currentRow1 = island1[randomSquareIndex1][1]
		currentCol1 = island1[randomSquareIndex1][2]
		
		currentRow2 = island2[randomSquareIndex2][1]
		currentCol2 = island2[randomSquareIndex2][2]
		
		terrainLayoutResult[currentRow1][currentCol1].terrainType = tt_holy_site_hill
		terrainLayoutResult[currentRow2][currentCol2].terrainType = tt_holy_site_hill
		
		holyNeighbors = {}
		holyNeighbors = Get8Neighbors(currentRow1, currentCol1, terrainLayoutResult)
		
		for testNeighborIndex, testNeighbor in ipairs(holyNeighbors) do
			testNeighborRow = testNeighbor.x
			testNeighborCol = testNeighbor.y
			currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
			if(currentTerrainType ~= playerStartTerrain) then
				terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_hills_gentle_rolling
			end
		end
		
		holyNeighbors = {}
		holyNeighbors = Get8Neighbors(currentRow2, currentCol2, terrainLayoutResult)
		
		for testNeighborIndex, testNeighbor in ipairs(holyNeighbors) do
			testNeighborRow = testNeighbor.x
			testNeighborCol = testNeighbor.y
			currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
			if(currentTerrainType ~= playerStartTerrain) then
				terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_hills_gentle_rolling
			end
		end
		
	else
		--place a holy site on 2 player team islands
		--find 2 largest islands
		if(#playerIslands >= 2) then
			islandSizeList = {}
			for islandIndex = 1, #playerIslands do
				currentIsland = playerIslands[islandIndex]
				currentSize = #currentIsland
				currentInfo = {}
				currentInfo = {islandIndex, currentSize}
				table.insert(islandSizeList, currentInfo)
			end
			
			--sort by island size
			table.sort(islandSizeList, function(a,b) return a[2] > b[2] end)
			
			--put a holy site on the 2 largest islands
			--first island
			--iterate through and grab non-starting squares
			holySiteOptions = {}
			for islandSquare = 1, #playerIslands[1] do
				
				currentRow = playerIslands[1][islandSquare][1]
				currentCol = playerIslands[1][islandSquare][2]
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType ~= playerStartTerrain) then
					currentInfo = {}
					currentInfo = {currentRow, currentCol}
					table.insert(holySiteOptions, currentInfo)
				end
			end
			
			--pick a random applicable square
			randomSquare = math.ceil(worldGetRandom() * #holySiteOptions)
			randomRow = playerIslands[1][randomSquare][1]
			randomCol = playerIslands[1][randomSquare][2]
			
			terrainLayoutResult[randomRow][randomCol].terrainType = tt_holy_site_hill
			
			holyNeighbors = {}
			holyNeighbors = Get8Neighbors(randomRow, randomCol, terrainLayoutResult)
			
			for testNeighborIndex, testNeighbor in ipairs(holyNeighbors) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
				if(currentTerrainType ~= playerStartTerrain) then
					terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_hills_gentle_rolling
				end
			end
			
			
			--second island
			--iterate through and grab non-starting squares
			holySiteOptions = {}
			for islandSquare = 1, #playerIslands[2] do
				
				currentRow = playerIslands[2][islandSquare][1]
				currentCol = playerIslands[2][islandSquare][2]
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType ~= playerStartTerrain) then
					currentInfo = {}
					currentInfo = {currentRow, currentCol}
					table.insert(holySiteOptions, currentInfo)
				end
			end
			
			--pick a random applicable square
			randomSquare = math.ceil(worldGetRandom() * #holySiteOptions)
			randomRow = playerIslands[2][randomSquare][1]
			randomCol = playerIslands[2][randomSquare][2]
			
			terrainLayoutResult[randomRow][randomCol].terrainType = tt_holy_site_hill
			
			holyNeighbors = {}
			holyNeighbors = Get8Neighbors(randomRow, randomCol, terrainLayoutResult)
			
			for testNeighborIndex, testNeighbor in ipairs(holyNeighbors) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
				if(currentTerrainType ~= playerStartTerrain) then
					terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_hills_gentle_rolling
				end
			end
		else
			--place one holy site on the island randomly
			--iterate through and grab non-starting squares
			holySiteOptions = {}
			for islandSquare = 1, #playerIslands[1] do
				
				currentRow = playerIslands[1][islandSquare][1]
				currentCol = playerIslands[1][islandSquare][2]
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType ~= playerStartTerrain) then
					currentInfo = {}
					currentInfo = {currentRow, currentCol}
					table.insert(holySiteOptions, currentInfo)
				end
			end
			
			--pick a random applicable square
			randomSquare = math.ceil(worldGetRandom() * #holySiteOptions)
			randomRow = playerIslands[1][randomSquare][1]
			randomCol = playerIslands[1][randomSquare][2]
			
			terrainLayoutResult[randomRow][randomCol].terrainType = tt_holy_site_hill
			holyNeighbors = {}
			holyNeighbors = Get8Neighbors(randomRow, randomCol, terrainLayoutResult)
			
			for testNeighborIndex, testNeighbor in ipairs(holyNeighbors) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
				if(currentTerrainType ~= playerStartTerrain) then
					terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_hills_gentle_rolling
				end
			end
		end
		
	end
	
end

--function to handle creating any of the special case maps
CreateSpecialMap = function()
	
	print("you have entered the MegaRandom WeirdZone")

	--CHECKERBOARD
	----------------------------------------------------------------------------------------------------
	
	--[[
	if(worldTerrainWidth <= 513) then
		mapRes = 28
	elseif(worldTerrainWidth <= 769) then
		mapRes = 28
	else
		mapRes = 28
	end
	--]]
	--set terrain dimensions for a standard land map
	
	mapRes = 28
	gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(mapRes)
	--gridHeight, gridWidth, gridSize = SetCoarseGrid()
	
	terrainLayoutResult = SetUpGrid(gridSize, tt_none, terrainLayoutResult)
	
	playerStartTerrain = tt_player_start_classic_plains
	
	isTwoTeams = false
	teamMappingTable = CreateTeamMappingTable()
	if(#teamMappingTable == 2) then
		isTwoTeams = true
	end
	
	if(isTwoTeams == true) then
		weirdZoneRoll = worldGetRandom()
	else
		weirdZoneRoll = worldGetRandom() * 0.74
	end
	
	--do checkerboard
	if(weirdZoneRoll < 0.75) then
		
		
		currentIteration = 1
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				if(worldGetRandom() < 0.25) then
					iterationGap = 4
					if(math.fmod(currentIteration, iterationGap) == 0) then
						--	terrainRoll = math.ceil(worldGetRandom() * #impasseFeatureTable)
						--	currentTerrainType = impasseFeatureTable[terrainRoll]
						currentTerrainType = tt_hills_gentle_rolling
						terrainLayoutResult[row][col].terrainType = currentTerrainType
						print("placing checkerboard pattern terrain at " .. row .. " ," .. col)
						
					else
						currentTerrainType = tt_lake_shallow
						terrainLayoutResult[row][col].terrainType = currentTerrainType
					end
					currentIteration = currentIteration + 1
					
				else
					iterationGap = 4 
					pillarChance = 0.8
					if(math.fmod(currentIteration, iterationGap) == 0) then
						--	terrainRoll = math.ceil(worldGetRandom() * #impasseFeatureTable)
						--	currentTerrainType = impasseFeatureTable[terrainRoll]
						if(worldGetRandom() < pillarChance) then
							currentTerrainType = tt_rock_pillar
							terrainLayoutResult[row][col].terrainType = currentTerrainType
							print("placing checkerboard pattern terrain at " .. row .. " ," .. col)
						else
							currentTerrainType = tt_plains
							terrainLayoutResult[row][col].terrainType = currentTerrainType
						end
					else
						currentTerrainType = tt_plains
						terrainLayoutResult[row][col].terrainType = currentTerrainType
					end
					currentIteration = currentIteration + 1
				end
				
			end
		end
		
		for row = 1, gridSize do
			for col = 1, gridSize do
				if(row == 1 or col == 1 or row == gridSize or col == gridSize) then
					terrainLayoutResult[row][col].terrainType = tt_plains
				end
			end
		end
		
		
		--do player starts
		teamMappingTable = CreateTeamMappingTable()
		
		minTeamDistance = gridSize * 1.2
		minPlayerDistance = math.ceil(gridSize * 0.65)
		edgeBuffer = 2
		if(worldTerrainWidth <= 417) then
			edgeBuffer = 1
			innerExclusion = 0.35
			topSelectionThreshold = 0.001
			impasseDistance = 1.5
		elseif(worldTerrainWidth <= 513) then
			edgeBuffer = 1
			innerExclusion = 0.35
			topSelectionThreshold = 0.001
			impasseDistance = 1.5
			
		elseif(worldTerrainWidth <= 641) then
			edgeBuffer = 2
			innerExclusion = 0.35
			topSelectionThreshold = 0.001
			impasseDistance = 1.5
		elseif(worldTerrainWidth <= 769) then
			edgeBuffer = 2
			innerExclusion = 0.35
			topSelectionThreshold = 0.001
			impasseDistance = 1.5
		else
			edgeBuffer = 2
			innerExclusion = 0.35
			topSelectionThreshold = 0.001
			impasseDistance = 1.5
		end
		
		startBufferTerrain = tt_plains_smooth
		startBufferRadius = math.ceil(gridSize / 8)
		
		
		cornerThreshold = 1
		
		spawnBlockers = {}	
		
		terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)

		halfMap = math.ceil(#terrainLayoutResult / 2)
		terrainLayoutResult[halfMap][halfMap].terrainType = tt_holy_site_hill
		
	--do Gulch
	elseif(weirdZoneRoll >= 0.75) then
		
		for row = 1, gridSize do
			for col = 1, gridSize do
				if(row <= (#terrainLayoutResult * 0.2) or row > (#terrainLayoutResult * 0.8)) then
					if(terrainLayoutResult[row][col].terrainType == tt_none) then
						terrainLayoutResult[row][col].terrainType = tt_plateau_high
					end
					
				end
				
			end
		end
		
		for row = 1, gridSize do
			for col = 1, gridSize do	
				--place holy sites
				if(row == Round((#terrainLayoutResult * 0.2), 0) + 1 and col == Round(#terrainLayoutResult/2, 0)) then
					terrainLayoutResult[row][col].terrainType = tt_holy_site_hill
					
					surroundingSquares = {}
					--surroundingSquares = GetAllSquaresInRadius(row, col, 2, terrainLayoutResult)
					surroundingSquares = GetAllSquaresInRingAroundSquare(row, col, 2, 2, terrainLayoutResult)
					
					for testNeighborIndex, testNeighbor in ipairs(surroundingSquares) do
						testNeighborRow = testNeighbor[1]
						testNeighborCol = testNeighbor[2]
						currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
						if(currentTerrainType ~= tt_plateau_med and currentTerrainType ~= tt_holy_site_hill) then
							terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_plateau_low
						end
					end
					
					terrainLayoutResult[row][col-3].terrainType = tt_hills_low_rolling
					terrainLayoutResult[row+1][col-3].terrainType = tt_hills_low_rolling
					terrainLayoutResult[row][col+3].terrainType = tt_hills_low_rolling
					terrainLayoutResult[row+1][col+3].terrainType = tt_hills_low_rolling
				end
				
				if(row == Round((#terrainLayoutResult * 0.8), 0) - 1 and col == Round(#terrainLayoutResult/2, 0)) then
					terrainLayoutResult[row][col].terrainType = tt_holy_site_hill
					
					surroundingSquares = {}
					--surroundingSquares = GetAllSquaresInRadius(row, col, 2, terrainLayoutResult)
					surroundingSquares = GetAllSquaresInRingAroundSquare(row, col, 2, 2, terrainLayoutResult)
					
					for testNeighborIndex, testNeighbor in ipairs(surroundingSquares) do
						testNeighborRow = testNeighbor[1]
						testNeighborCol = testNeighbor[2]
						currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
						if(currentTerrainType ~= tt_plateau_med and currentTerrainType ~= tt_holy_site_hill) then
							terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_plateau_low
						end
					end
					
					terrainLayoutResult[row][col-3].terrainType = tt_hills_low_rolling
					terrainLayoutResult[row-1][col-3].terrainType = tt_hills_low_rolling
					terrainLayoutResult[row][col+3].terrainType = tt_hills_low_rolling
					terrainLayoutResult[row-1][col+3].terrainType = tt_hills_low_rolling
				end
				
				
			end
		end
		
		
		
		
		
		minTeamDistance = gridSize * 1.2
		minPlayerDistance = math.ceil(gridSize * 0.65)
		edgeBuffer = 2
		if(worldTerrainWidth <= 417) then
			edgeBuffer = 1
			innerExclusion = 0.38
			topSelectionThreshold = 0.001
			impasseDistance = 2.5
			stealthRadius = 2
		elseif(worldTerrainWidth <= 513) then
			edgeBuffer = 1
			innerExclusion = 0.4
			topSelectionThreshold = 0.001
			impasseDistance = 2.5
			stealthRadius = 2
			
		elseif(worldTerrainWidth <= 641) then
			edgeBuffer = 2
			innerExclusion = 0.42
			topSelectionThreshold = 0.001
			impasseDistance = 2.5
			stealthRadius = 3
		elseif(worldTerrainWidth <= 769) then
			edgeBuffer = 2
			innerExclusion = 0.45
			topSelectionThreshold = 0.001
			impasseDistance = 2.5
			stealthRadius = 4
		else
			edgeBuffer = 2
			innerExclusion = 0.5
			topSelectionThreshold = 0.001
			impasseDistance = 2.5
			stealthRadius = 5
		end
		
		--make central stealth woods
		halfMap = math.ceil(#terrainLayoutResult / 2)
		terrainLayoutResult[halfMap][halfMap].terrainType = tt_trees_plains_stealth
		stealthSquares = {}
		stealthSquares = GetAllSquaresInRingAroundSquare(halfMap, halfMap, stealthRadius, stealthRadius, terrainLayoutResult)
					
		for testNeighborIndex, testNeighbor in ipairs(stealthSquares) do
			testNeighborRow = testNeighbor[1]
			testNeighborCol = testNeighbor[2]
			currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
			if(currentTerrainType ~= tt_plateau_med and currentTerrainType ~= tt_holy_site_hill) then
				terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_trees_plains_stealth
			end
		end
		
				
		startBufferTerrain = tt_plains_smooth
		startBufferRadius = math.ceil(gridSize / 12)
		
		
		cornerThreshold = 1
		
		spawnBlockers = {tt_plateau_med, tt_plateau_low, tt_plateau_high, tt_river}	
		
	--	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)
		terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, true, spawnBlockers, impasseDistance, 0.01, playerStartTerrain, tt_plains_smooth, startBufferRadius, true, terrainLayoutResult)

		
	end
		
	
	
	print("created special map!")
end

-------------------------------------------------------------------------
-------------------------------------------------------------------------

--utility functions

SetOneEdgeStyle = function(terrainChoices, spawnChance, terrainGrid)
	
	gridSize = #terrainGrid
	--select one of the passed in terrain types
	terrainChoiceIndex = math.ceil(worldGetRandom() * #terrainChoices)
	terrainChoice = terrainChoices[terrainChoiceIndex]
	
	edgeChoice = math.ceil(worldGetRandom() * 4)
	
	--decide how many layers to expand
	maxExpansions = 3
	
	expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
	
	--top edge
	if(edgeChoice == 1) then
		SetTopEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
		expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
		if(expansionLayers > 0) then
			tempSpawnChance = spawnChance
			for i = 1, expansionLayers do
				tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
				ExpandTopEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
			end
		end
		
	--bottom edge
	elseif(edgeChoice == 2) then
		SetBottomEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
		expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
		if(expansionLayers > 0) then
			tempSpawnChance = spawnChance
			for i = 1, expansionLayers do
				tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
				ExpandBottomEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
			end
		end
		
	--left edge
	elseif(edgeChoice == 3) then
		SetLeftEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
		expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
		if(expansionLayers > 0) then
			tempSpawnChance = spawnChance
			for i = 1, expansionLayers do
				tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
				ExpandLeftEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
			end
		end
		
	--right edge
	else
		SetRightEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
		expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
		if(expansionLayers > 0) then
			tempSpawnChance = spawnChance
			for i = 1, expansionLayers do
				tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
				ExpandRightEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
			end
		end
	end
	
end

SetTwoEdgeStyle = function(terrainChoices, spawnChance, terrainGrid)
	
	gridSize = #terrainGrid
	--select one of the passed in terrain types
	terrainChoiceIndex = math.ceil(worldGetRandom() * #terrainChoices)
	terrainChoice = terrainChoices[terrainChoiceIndex]
	
	edgeChoice = math.ceil(worldGetRandom() * 2)
	
	--decide how many layers to expand
	maxExpansions = 2
	
	expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
	
	--top and bottom
	if(edgeChoice == 1) then
		if(worldGetRandom() < 0.5) then
			SetTopEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
			
			expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
			if(expansionLayers > 0) then
				tempSpawnChance = spawnChance
				for i = 1, expansionLayers do
					tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
					ExpandTopEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
				end
			end
			
			
			SetBottomEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
			expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
			if(expansionLayers > 0) then
				tempSpawnChance = spawnChance
				for i = 1, expansionLayers do
					tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
					ExpandBottomEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
				end
			end
			
		else
			SetLeftEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
			expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
			if(expansionLayers > 0) then
				tempSpawnChance = spawnChance
				for i = 1, expansionLayers do
					tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
					ExpandLeftEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
				end
			end
			
			SetRightEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
			expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
			if(expansionLayers > 0) then
				tempSpawnChance = spawnChance
				for i = 1, expansionLayers do
					tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
					ExpandRightEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
				end
			end
		end
	--corner
	else
		if(worldGetRandom() < 0.5) then
			SetTopEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
			expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
			if(expansionLayers > 0) then
				tempSpawnChance = spawnChance
				for i = 1, expansionLayers do
					tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
					ExpandTopEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
				end
			end
			
			SetRightEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
			expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
			if(expansionLayers > 0) then
				tempSpawnChance = spawnChance
				for i = 1, expansionLayers do
					tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
					ExpandRightEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
				end
			end
		else
			SetBottomEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
			expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
			if(expansionLayers > 0) then
				tempSpawnChance = spawnChance
				for i = 1, expansionLayers do
					tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
					ExpandBottomEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
				end
			end
			
			SetLeftEdgeStyle(gridSize, terrainChoice, spawnChance, terrainGrid)
			expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
			if(expansionLayers > 0) then
				tempSpawnChance = spawnChance
				for i = 1, expansionLayers do
					tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
					ExpandLeftEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
				end
			end
		end
		
	end
	
end

SetFourEdgeStyle = function(terrainChoices, spawnChance, terrainGrid)
	
	gridSize = #terrainGrid
	--select one of the passed in terrain types
	terrainChoiceIndex = math.ceil(worldGetRandom() * #terrainChoices)
	terrainChoice = terrainChoices[terrainChoiceIndex]
	
	--decide how many layers to expand
	maxExpansions = 2
	
	expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
	
	SetEdgeStyle(terrainChoice, gridSize, spawnChance, terrainGrid)
	
	expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
	if(expansionLayers > 0) then
		tempSpawnChance = spawnChance
		for i = 1, expansionLayers do
			tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
			ExpandLeftEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
		end
	end
	
	expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
	if(expansionLayers > 0) then
		tempSpawnChance = spawnChance
		for i = 1, expansionLayers do
			tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
			ExpandRightEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
		end
	end
	
	expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
	if(expansionLayers > 0) then
		tempSpawnChance = spawnChance
		for i = 1, expansionLayers do
			tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
			ExpandTopEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
		end
	end
	
	expansionLayers = Round((worldGetRandom() * maxExpansions), 0)
	if(expansionLayers > 0) then
		tempSpawnChance = spawnChance
		for i = 1, expansionLayers do
			tempSpawnChance = tempSpawnChance - (Normalize(worldGetRandom(), 0, spawnChance))
			ExpandBottomEdge(i, tempSpawnChance, terrainChoice, gridSize, terrainGrid)
		end
	end
end
-------------------------------------------------------------------------
-------------------------------------------------------------------------

--main executable loop

main()
