-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING KING OF THE HILL")

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

h = tt_hills
s = tt_mountains_small
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_low_rolling
mr = tt_hills_med_rolling
hr = tt_hills_high_rolling
low = tt_plateau_standard_small
med = tt_plateau_med
high = tt_plateau_high
p = tt_plains
t = tt_impasse_trees_plains

f = tt_trees_plains
c = tt_trees_plains_clearing
bf = tt_trees_hills_high_rolling_clearing


playerStartTerrain = tt_player_start_classic_plains_low_trees_koth -- classic mode start	

-- create a list of tactical regions to choose from
-- gold tactical regions
tga = tt_tactical_region_gold_plateau_low_a


tga2 = tt_tactical_region_gold_plateau_med_a

goldTop = tt_tactical_region_gold_plateau_high_a

-- stone tactical regions
tsa = tt_tactical_region_stone_plateau_low_a
tsa2 = tt_tactical_region_stone_plateau_med_a


-- FUNCTIONS
-- this function gets squares qithin the specified radius from the designated position
-- radius can be fractions in order to better tune the circle in the coarse grid
local function GetSquaresInRadius(centerRow, centerColumn, mapHeight, mapWidth, radius)
	
	local squares = {}
	for row = 1, mapHeight do
		
		for col = 1, mapWidth do
			local euclidianDistance = math.sqrt((row - centerRow)^2 + (col - centerColumn)^2)
			if(euclidianDistance < radius) then
				table.insert(squares, {row, col})
			end
		end
		
	end
	
	return squares
end

-- COARSE GRID SET UP
terrainLayoutResult = {}    -- set up initial table for coarse map grid. Must be named this
mapRes = 24
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(mapRes)

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

-- PLACE TERRAIN FEATURES

-- define circles of cliff and hill terrain to create the raised section in hte center of the map
baseGridSize = 13
outerRadius = 3.5 / baseGridSize * gridSize
middleRadius = 2 / baseGridSize * gridSize
innerRadius = 1.25 / baseGridSize * gridSize
mapMidPoint = math.ceil(gridSize/2)
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

print("hill outer radius: " .. outerRadius)
print("hill mid radius: " .. middleRadius)
print("hill inner radius: " .. innerRadius)

-- define multiple radii to make concentric rings of terrain that get higher towards the middle
squaresToChange = GetSquaresInRadius(mapMidPoint, mapMidPoint, gridHeight, gridWidth, outerRadius)

for index = 1, #squaresToChange do
	x = squaresToChange[index][1]
	y = squaresToChange[index][2]
	terrainLayoutResult[x][y].terrainType = low
end
print("total low squares: " .. #squaresToChange)

squaresToChange = GetSquaresInRadius(mapMidPoint, mapMidPoint, gridHeight, gridWidth, middleRadius)

for index = 1, #squaresToChange do
	x = squaresToChange[index][1]
	y = squaresToChange[index][2]
	terrainLayoutResult[x][y].terrainType = med
end
print("total med squares: " .. #squaresToChange)

squaresToChange = GetSquaresInRadius(mapMidPoint, mapMidPoint, gridHeight, gridWidth, innerRadius)

for index = 1, #squaresToChange do
	x = squaresToChange[index][1]
	y = squaresToChange[index][2]
	terrainLayoutResult[x][y].terrainType = high
end
print("total high squares: " .. #squaresToChange)

squaresToChange = GetSquaresOfType(low, gridSize, terrainLayoutResult)

numSquares = Round(#squaresToChange * 0.3 , 0)
for index = 1, numSquares do
	square = GetRandomElement(squaresToChange)
	x = square[1]
	y = square[2]
--	terrainLayoutResult[x][y].terrainType = b
end

squaresToChange = GetSquaresOfType(med, gridSize, terrainLayoutResult)

numSquares = Round(#squaresToChange * 0.2 , 0)
for index = 1, numSquares do
	square = GetRandomElement(squaresToChange)
	x = square[1]
	y = square[2]
--	terrainLayoutResult[x][y].terrainType = mr
end

squaresToChange = GetSquaresOfType(med, gridSize, terrainLayoutResult)

numSquares = Round(#squaresToChange * 0.2 , 0)
for index = 1, numSquares do
	square = GetRandomElement(squaresToChange)
	x = square[1]
	y = square[2]
--	terrainLayoutResult[x][y].terrainType = hr
end

-- hill buffer around lower layer to ensure entry points to the center area
squaresToChange = GetSquaresOfType(med, gridSize, terrainLayoutResult)

for index = 1, #squaresToChange do
	square = squaresToChange[index]
	x = square[1]
	y = square[2]
	conversionSquares = GetAllSquaresOfTypeInRingAroundSquare(x, y, 1, 1, {n}, terrainLayoutResult)
	
		for cIndex = 1, #conversionSquares do
			cSquare =  conversionSquares[cIndex]
			row = cSquare[1]
			col = cSquare[2]
		--	terrainLayoutResult[row][col].terrainType = b
		end
end

--place shallow valley around outer ring of hill
for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(terrainLayoutResult[row][col].terrainType == low) then
			lowNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			
			for neighborIndex, lowNeighbor in ipairs(lowNeighbors) do
				currentRow = lowNeighbor.x
				currentCol = lowNeighbor.y
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_plains or terrainLayoutResult[currentRow][currentCol].terrainType == tt_none) then
					terrainLayoutResult[currentRow][currentCol].terrainType = tt_valley_shallow
				end
			end
		end
	end
end

-- PLACE PLAYER STARTS

if(worldTerrainWidth <= 417) then
	minTeamDistance = Round((#terrainLayoutResult * 0.85))
	minPlayerDistance = Round((#terrainLayoutResult * 0.9))
	edgeBuffer = 3
	innerExclusion = 0.45
	topSelectionThreshold = 0.1
	impasseTypes = {tt_mountains_small}
	impasseDistance = 1.5
	cornerThreshold = 0
	spawnBlockDistance = 1.5
	spawnBlockers = {tt_mountains, tt_plateau_low}
elseif(worldTerrainWidth <= 513) then
	minTeamDistance = Round((#terrainLayoutResult * 0.85))
	minPlayerDistance = Round((#terrainLayoutResult * 0.6))
	edgeBuffer = 3
	innerExclusion = 0.5
	topSelectionThreshold = 0.01
	impasseTypes = {tt_mountains_small}
	impasseDistance = 1.5
	cornerThreshold = 0
	spawnBlockDistance = 2.5
	spawnBlockers = {tt_mountains, tt_plateau_low, tt_valley_shallow}
elseif(worldTerrainWidth <= 641) then
	minTeamDistance = Round((#terrainLayoutResult * 0.85))
	minPlayerDistance = Round((#terrainLayoutResult * 0.6))
	edgeBuffer = 3
	innerExclusion = 0.55
	topSelectionThreshold = 0.01
	impasseTypes = {tt_mountains_small}
	impasseDistance = 1.5
	cornerThreshold = 1
	spawnBlockDistance = 2
	spawnBlockers = {tt_mountains, tt_plateau_low, tt_valley_shallow}
elseif(worldTerrainWidth <= 769) then
	minTeamDistance = Round((#terrainLayoutResult * 0.85))
	minPlayerDistance = Round((#terrainLayoutResult * 0.6))
	edgeBuffer = 3
	innerExclusion = 0.6
	topSelectionThreshold = 0.01
	impasseTypes = {tt_mountains_small}
	impasseDistance = 1.5
	cornerThreshold = 1
	spawnBlockDistance = 2
	spawnBlockers = {tt_mountains, tt_plateau_low, tt_valley_shallow}
else
	minTeamDistance = Round((#terrainLayoutResult * 0.85))
	minPlayerDistance = Round((#terrainLayoutResult * 0.6))
	edgeBuffer = 3
	innerExclusion = 0.75
	topSelectionThreshold = 0.01
	impasseTypes = {tt_mountains_small}
	impasseDistance = 1.5
	cornerThreshold = 2
	spawnBlockDistance = 2
	spawnBlockers = {tt_mountains, tt_plateau_low, tt_valley_shallow}
end

teamMappingTable = CreateTeamMappingTable()
spawnBlockers = {}

startLocationPositions = {}
terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, spawnBlockDistance, 0.02, playerStartTerrain, tt_plains_smooth, 2, true, terrainLayoutResult)

--find the player spawns and add them to startLocationPositions
for row = 1, gridSize do
	for col = 1, gridSize do
		
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			
			newInfo = {}
			newInfo = {startRow = row, startCol = col}
			table.insert(startLocationPositions, newInfo)
		end
		
	end
end


-- place perimeter terrain elements (extra trees and food animals around the edge of the map)
-- all variables scale for map size
terrainToPlace = {s, m, i, t, t, t, t }
numberOfElements = Round(12 / 13 * gridSize, 0)
mapCenterRow = math.ceil(gridHeight / 2)
mapCenterCol = math.ceil(gridWidth / 2)
ringRadius = mapCenterRow - 1
ringWidth = Round(2 / 13 * gridSize, 0)




------------
--HOLY SITES
------------
-- grab all the center squares, since that'll be the optimum place to put the site
sacredSiteNeighbors = {}
sacredSiteNeighbors = Get8Neighbors(mapHalfSize, mapHalfSize, terrainLayoutResult)

for neighborIndex, sacredSiteNeighbor in ipairs(sacredSiteNeighbors) do
	row = sacredSiteNeighbor.x
	col = sacredSiteNeighbor.y
	
	if(terrainLayoutResult[row][col].terrainType ~= tga and terrainLayoutResult[row][col].terrainType ~= tsa) then
		terrainLayoutResult[row][col].terrainType = tt_hills_med_rolling
	end
end

terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = tt_holy_site_hill


--draw lines of pathable terrain from player starts to the top of the hill
for teamIndex = 1, #teamMappingTable do
	for playerIndex = 1, #teamMappingTable[teamIndex].players do
	
		currentRow = teamMappingTable[teamIndex].players[playerIndex].startRow
		currentCol = teamMappingTable[teamIndex].players[playerIndex].startCol
		print("drawing line from player " .. playerIndex .. " on team " .. teamIndex .. " at " .. currentRow .. ", " .. currentCol)
		
		playerLine = DrawLineOfTerrainNoDiagonalReturn(currentRow, currentCol, mapHalfSize, mapHalfSize, false, p, gridSize, terrainLayoutResult)	
		
		for index = 1, #playerLine do
			row = playerLine[index][1] 
			col = playerLine[index][2] 
			if terrainLayoutResult[row][col].terrainType == low or terrainLayoutResult[row][col].terrainType == tt_valley_shallow then
				terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
			elseif terrainLayoutResult[row][col].terrainType == med then
				terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
			elseif terrainLayoutResult[row][col].terrainType == high then
				terrainLayoutResult[row][col].terrainType = tt_hills_med_rolling
			end
		end
	end
end

--place additional path to top and mid levels of hill
--find all edge mid level plateaus
midEdgeSquares = {}
lowEdgeSquares = {}

for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(terrainLayoutResult[row][col].terrainType == med) then
			isLowNeighbor = false
			medNeighbors = {}
			medNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for neighborIndex, medNeighbor in ipairs(medNeighbors) do
				currentRow = medNeighbor.x
				currentCol = medNeighbor.y
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType == low) then
					isLowNeighbor = true
				end
			end
			
			--make sure to not select square where neighboring square is already a ramp
			medCheckNeighbors = {}
			medCheckNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			for neighborIndex, medNeighbor in ipairs(medCheckNeighbors) do
				currentRow = medNeighbor.x
				currentCol = medNeighbor.y
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_hills_low_rolling or terrainLayoutResult[currentRow][currentCol].terrainType == tt_hills_gentle_rolling) then
					isLowNeighbor = false
				end
			end
			
			if(isLowNeighbor == true) then
				newInfo = {}
				newInfo = {row, col}
				table.insert(midEdgeSquares, newInfo)
			end
		end
		
		if(terrainLayoutResult[row][col].terrainType == low) then
			isValleyNeighbor = false
			lowNeighbors = {}
			lowNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for neighborIndex, lowNeighbor in ipairs(lowNeighbors) do
				currentRow = lowNeighbor.x
				currentCol = lowNeighbor.y
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_valley_shallow) then
					isValleyNeighbor = true
				end
			end
			
			--make sure to not select square where neighboring square is already a ramp
			lowCheckNeighbors = {}
			lowCheckNeighbors = Get20Neighbors(row, col, terrainLayoutResult)
			for neighborIndex, lowNeighbor in ipairs(lowCheckNeighbors) do
				currentRow = lowNeighbor.x
				currentCol = lowNeighbor.y
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_hills_gentle_rolling or terrainLayoutResult[currentRow][currentCol].terrainType == tt_plains_smooth) then
					isValleyNeighbor = false
				end
			end
			
			if(isValleyNeighbor == true) then
				newInfo = {}
				newInfo = {row, col}
				table.insert(lowEdgeSquares, newInfo)
				print("recording low edge square at " .. currentRow .. ", " .. currentCol)
			end
		end
	end
end

midEdgeIndex = math.ceil(worldGetRandom() * #midEdgeSquares)
print("number of mid edge squares is " .. #midEdgeSquares)
print("chosen mid edge index is " .. midEdgeIndex)
if(#midEdgeSquares > 0) then
	chosenMidRow = midEdgeSquares[midEdgeIndex][1]
	chosenMidCol = midEdgeSquares[midEdgeIndex][2]
	terrainLayoutResult[chosenMidRow][chosenMidCol].terrainType = tt_hills_low_rolling
	print("placing mid ramp at chosen point " .. chosenMidRow .. ", " .. chosenMidCol)
	oppositeMidRow = gridSize - chosenMidRow + 1
	oppositeMidCol = gridSize - chosenMidCol + 1
	terrainLayoutResult[oppositeMidRow][oppositeMidCol].terrainType = tt_hills_low_rolling
	print("placing mid ramp at opposite point " .. oppositeMidRow .. ", " .. oppositeMidCol)
end


lowEdgeIndex = math.ceil(worldGetRandom() * #lowEdgeSquares)
if(#lowEdgeSquares > 0) then
	chosenLowRow = lowEdgeSquares[lowEdgeIndex][1]
	chosenLowCol = lowEdgeSquares[lowEdgeIndex][2]
	terrainLayoutResult[chosenLowRow][chosenLowCol].terrainType = tt_hills_gentle_rolling
	print("placing low ramp at chosen point " .. chosenLowRow .. ", " .. chosenLowCol)
	--make neighboring valley squares into plains
	lowNeighbors = {}
	lowNeighbors = GetNeighbors(chosenLowRow, chosenLowCol, terrainLayoutResult)
	for neighborIndex, lowNeighbor in ipairs(lowNeighbors) do
		currentRow = lowNeighbor.x
		currentCol = lowNeighbor.y
		
		if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_valley_shallow) then
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_hills_gentle_rolling
		end
	end

	oppositeLowRow = gridSize - chosenLowRow + 1
	oppositeLowCol = gridSize - chosenLowCol + 1
	terrainLayoutResult[oppositeLowRow][oppositeLowCol].terrainType = tt_hills_gentle_rolling
	print("placing low ramp at opposite point " .. oppositeLowRow .. ", " .. oppositeLowCol)
	lowNeighbors = {}
	lowNeighbors = GetNeighbors(oppositeLowRow, oppositeLowCol, terrainLayoutResult)
	for neighborIndex, lowNeighbor in ipairs(lowNeighbors) do
		currentRow = lowNeighbor.x
		currentCol = lowNeighbor.y
		
		if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_valley_shallow) then
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_hills_gentle_rolling
		end
	end

end
	
--place resources on the hill

medResTerrain = tt_tactical_region_gold_plateau_med_a
medResStoneTerrain = tt_tactical_region_stone_plateau_med_a
lowResTerrain = tt_tactical_region_gold_plateau_low_a
lowResStoneTerrain = tt_tactical_region_stone_plateau_low_a
medResSquares = {}
lowResSquares = {}
if(worldTerrainWidth <= 417) then
	numLowResSquares = 1
	numMedResSquares = 2
elseif(worldTerrainWidth <= 513) then
	numLowResSquares = 2
	numMedResSquares = 3
elseif(worldTerrainWidth <= 641) then
	numLowResSquares = 3
	numMedResSquares = 4
elseif(worldTerrainWidth <= 769) then
	numLowResSquares = 5
	numMedResSquares = 5
else
	numLowResSquares = 6
	numMedResSquares = 6
end

for row = 1, gridSize do
	for col = 1, gridSize do
		
		--record medium squares for res
		if(terrainLayoutResult[row][col].terrainType == med or terrainLayoutResult[row][col].terrainType == high or terrainLayoutResult[row][col].terrainType == tt_hills_med_rolling) then
			newInfo = {}
			newInfo = {row, col}
			table.insert(medResSquares, newInfo)
		end
		
		--record squares that are away from the edge for res
		if(terrainLayoutResult[row][col].terrainType == low) then
			isValleyNeighbor = true
			lowCheckNeighbors = {}
			lowCheckNeighbors = Get12Neighbors(row, col, terrainLayoutResult)
			for neighborIndex, lowNeighbor in ipairs(lowCheckNeighbors) do
				currentRow = lowNeighbor.x
				currentCol = lowNeighbor.y
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_hills_gentle_rolling or terrainLayoutResult[currentRow][currentCol].terrainType == tt_plains_smooth) then
					isValleyNeighbor = false
				end
			end
			
			if(isValleyNeighbor == true) then
				newInfo = {}
				newInfo = {row, col}
				table.insert(lowResSquares, newInfo)
				print("recording low edge res square at " .. currentRow .. ", " .. currentCol)
			end
			
		end
	end
end

placeGold = true
for medResIndex = 1, numMedResSquares do
	
	if(medResIndex <= #medResSquares) then
		
		
		
		--choose a random mid res square to use as a resource node
		randomMedResIndex = math.ceil(worldGetRandom() * #medResSquares)
		currentMedResRow = medResSquares[randomMedResIndex][1]
		currentMedResCol = medResSquares[randomMedResIndex][2]
		
		
		--grab the opposing square to mirror the res
		oppositeMedResRow = gridSize - currentMedResRow + 1
		oppositeMedResCol = gridSize - currentMedResCol + 1
		
		if(placeGold == true) then
			terrainLayoutResult[currentMedResRow][currentMedResCol].terrainType = medResTerrain
			terrainLayoutResult[oppositeMedResRow][oppositeMedResCol].terrainType = medResTerrain
			
			placeGold = false
		else
			terrainLayoutResult[currentMedResRow][currentMedResCol].terrainType = medResStoneTerrain
			terrainLayoutResult[oppositeMedResRow][oppositeMedResCol].terrainType = medResStoneTerrain
			
			placeGold = true
		end
		
		print("placed res at mid points " .. currentMedResRow .. ", " .. currentMedResCol .. " and " .. oppositeMedResRow .. ", " .. oppositeMedResCol)
		table.remove(medResSquares, randomMedResIndex)
		
		--search for opposite square in res squares to remove
		for resIndex = 1, #medResSquares do
			currentSearchRow = medResSquares[resIndex][1]
			currentSearchCol = medResSquares[resIndex][2]
			
			if(oppositeMedResRow == currentSearchRow and oppositeMedResCol == currentSearchCol) then
				print("removing opposite resource square at " .. oppositeMedResRow .. ", " .. oppositeMedResCol)
				table.remove(medResSquares, resIndex)
				break
			end
		end
	end
end

placeGold = true
for lowResIndex = 1, numLowResSquares do
	
	if(lowResIndex <= #lowResSquares) then
		
		--choose a random mid res square to use as a resource node
		randomLowResIndex = math.ceil(worldGetRandom() * #lowResSquares)
		currentLowResRow = lowResSquares[randomLowResIndex][1]
		currentLowResCol = lowResSquares[randomLowResIndex][2]
		
		
		--grab the opposing square to mirror the res
		oppositeLowResRow = gridSize - currentLowResRow + 1
		oppositeLowResCol = gridSize - currentLowResCol + 1
		
		if(placeGold == true) then
			terrainLayoutResult[currentLowResRow][currentLowResCol].terrainType = lowResTerrain
			terrainLayoutResult[oppositeLowResRow][oppositeLowResCol].terrainType = lowResTerrain
			
			placeGold = false
		else
			terrainLayoutResult[currentLowResRow][currentLowResCol].terrainType = lowResStoneTerrain
			terrainLayoutResult[oppositeLowResRow][oppositeLowResCol].terrainType = lowResStoneTerrain
			
			placeGold = true
		end
		
		print("placed res at low points " .. currentLowResRow .. ", " .. currentLowResCol .. " and " .. oppositeLowResRow .. ", " .. oppositeLowResCol)
		table.remove(lowResSquares, randomLowResIndex)
		
		--search for opposite square in res squares to remove
		for resIndex = 1, #lowResSquares do
			currentSearchRow = lowResSquares[resIndex][1]
			currentSearchCol = lowResSquares[resIndex][2]
			
			if(oppositeLowResRow == currentSearchRow and oppositeLowResCol == currentSearchCol) then
				print("removing opposite resource square at " .. oppositeLowResRow .. ", " .. oppositeLowResCol)
				table.remove(lowResSquares, resIndex)
				break
			end
		end
	end
end


--fill the outer ring of the map with trees
for row = 1, gridSize do
	for col = 1, gridSize do
		
		if(row == 1 or row == gridSize or col == 1 or col == gridSize) then
			terrainLayoutResult[row][col].terrainType = tt_impasse_trees_plains_forest
		end
	end
end

print("END OF KING OF THE HILL LUA SCRIPT")