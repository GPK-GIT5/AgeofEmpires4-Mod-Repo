-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--- Sets up the number of coarse grid squares scaled for map size

function SetCoarseGrid()
	
	local metersPerSquare = 40

	local mapHeight
	local mapWidth
	local mapSize
	
	local minimumRes = 13
	
	mapHeight = Round(worldTerrainHeight / metersPerSquare, 0) -- set resolution of coarse map rows
	mapWidth = Round(worldTerrainWidth / metersPerSquare, 0) -- set resolution of coarse map columns
	
	if (mapHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
		mapHeight = mapHeight - 1
	end

	if (mapWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
		mapWidth = mapWidth - 1
	end
	
	mapSize = mapWidth -- set resolution of coarse map
	
	if(mapHeight < minimumRes) then
		mapHeight = minimumRes
	end
	
	if(mapWidth < minimumRes) then
		mapWidth = minimumRes
	end
	
	if(mapSize < minimumRes) then
		mapSize = minimumRes
	end
	
	return mapHeight, mapWidth, mapSize

end

--sets the map grid to be a custom dimension
--NOTE: this will make all terrain features relatively smaller. Be careful using grids of too high a resolution
function SetCustomCoarseGrid(metersPerSquare)

	local mapHeight
	local mapWidth
	local mapSize
	
	mapHeight = Round(worldTerrainHeight / metersPerSquare, 0) -- set resolution of coarse map rows
	mapWidth = Round(worldTerrainWidth / metersPerSquare, 0) -- set resolution of coarse map columns
	
	if (mapHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
		mapHeight = mapHeight - 1
	end

	if (mapWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
		mapWidth = mapWidth - 1
	end
	
	mapSize = mapWidth -- set resolution of coarse map
	
	return mapHeight, mapWidth, mapSize

end


function ShuffleTable(table)
	
	for i = 1, #table do
		
		j = math.ceil(worldGetRandom() * #table)
		
		table[i], table[j] = table[j], table[i]
	end
	
end

function SwapTable(table, swapIndexTable)
	
	for i = 1, #table do
		for swapIndex = 1, #swapIndexTable do
			if(i + 1 > #table) then
				table[i][swapIndexTable[swapIndex]], table[1][swapIndexTable[swapIndex]] = table[1][swapIndexTable[swapIndex]], table[i][swapIndexTable[swapIndex]]
			else
				table[i][swapIndexTable[swapIndex]], table[i+1][swapIndexTable[swapIndex]] = table[i+1][swapIndexTable[swapIndex]], table[i][swapIndexTable[swapIndex]]
			end
		end
	end
	
end

--Sets all edge squares to a given terrian type
function SetEdgeStyle(edgeTerrain, gridSize, spawnChance, terrainGrid)
	
	for row = 1, gridSize do
		
		for col = 1, gridSize do
			
			if(row == 1 or row == gridSize or col == 1 or col == gridSize) then
				if(worldGetRandom() < spawnChance) then
					terrainGrid[row][col].terrainType = edgeTerrain
				end
			end
		end
	end
	
end

--set of functions to set various edges to a specific terrain
function SetTopEdgeStyle(gridSize, terrainStyle, spawnChance, terrainGrid)
	for row = 1, gridSize do
		
		for col = 1, gridSize do
			
			if(row == 1) then
				if(worldGetRandom() < spawnChance) then
					terrainGrid[row][col].terrainType = terrainStyle
				end
			end
		end
	end
end

function SetBottomEdgeStyle(gridSize, terrainStyle, spawnChance, terrainGrid)
	for row = 1, gridSize do
		
		for col = 1, gridSize do
			
			if(row == gridSize) then
				if(worldGetRandom() < spawnChance) then
					terrainGrid[row][col].terrainType = terrainStyle
				end
			end
		end
	end
end

function SetLeftEdgeStyle(gridSize, terrainStyle, spawnChance, terrainGrid)
	for row = 1, gridSize do
		
		for col = 1, gridSize do
			
			if(col == 1) then
				if(worldGetRandom() < spawnChance) then
					terrainGrid[row][col].terrainType = terrainStyle
				end
			end
		end
	end
end

function SetRightEdgeStyle(gridSize, terrainStyle, spawnChance, terrainGrid)
	for row = 1, gridSize do
		
		for col = 1, gridSize do
			
			if(col == gridSize) then
				if(worldGetRandom() < spawnChance) then
					terrainGrid[row][col].terrainType = terrainStyle
				end
			end
		end
	end
end


--set of functions to randomly set terrain in a given row or column to a terrain type specified
--works well to gradually expand one edge of terrain with a specific terrain type
function ExpandTopEdge(layerIn, chanceToExpand, edgeTerrain, gridSize, terrainGrid)
	if(layerIn <= gridSize and layerIn > 0) then
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				if(row == layerIn) then
					expandRoll = worldGetRandom()
					if(expandRoll < chanceToExpand) then
						terrainGrid[row][col].terrainType = edgeTerrain
					end
				end
			end
		end
	end
end

function ExpandBottomEdge(layerIn, chanceToExpand, edgeTerrain, gridSize, terrainGrid)
	if(layerIn <= gridSize and layerIn > 0) then
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				if(row == (gridSize - (layerIn - 1))) then
					expandRoll = worldGetRandom()
					if(expandRoll < chanceToExpand) then
						terrainGrid[row][col].terrainType = edgeTerrain
					end
				end
			end
		end
	end
end

function ExpandLeftEdge(layerIn, chanceToExpand, edgeTerrain, gridSize, terrainGrid)
	if(layerIn <= gridSize and layerIn > 0) then
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				if(col == layerIn) then
					expandRoll = worldGetRandom()
					if(expandRoll < chanceToExpand) then
						terrainGrid[row][col].terrainType = edgeTerrain
					end
				end
			end
		end
	end
end

function ExpandRightEdge(layerIn, chanceToExpand, edgeTerrain, gridSize, terrainGrid)
	if(layerIn <= gridSize and layerIn > 0) then
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				if(col == (gridSize - (layerIn - 1))) then
					expandRoll = worldGetRandom()
					if(expandRoll < chanceToExpand) then
						terrainGrid[row][col].terrainType = edgeTerrain
					end
				end
			end
		end
	end
end

--creates a relatively open map with no big defining impasse patterns
function CreateOpenMap(basicTerrain, impasseTerrain, impasseChance, terrainGrid)
	
	print("creating open land map")
	
	gridSize = #terrainGrid
	
	--fill the terrain with a random amount of impasse
	for row = 1, gridSize do
		for col = 1, gridSize do 
			if(terrainGrid[row][col].terrainType == tt_none and worldGetRandom() < impasseChance) then
				terrainRoll = math.ceil(worldGetRandom() * #impasseTerrain)
				currentTerrain = impasseTerrain[terrainRoll]
				terrainGrid[row][col].terrainType = currentTerrain
			end
		end
	end
	
	--fill the rest of the terrain with basic elevation
	for row = 1, gridSize do
		for col = 1, gridSize do 
			if(terrainGrid[row][col].terrainType == tt_none) then
				terrainRoll = math.ceil(worldGetRandom() * #basicTerrain)
				currentTerrain = basicTerrain[terrainRoll]
				terrainGrid[row][col].terrainType = currentTerrain
			end
		end
	end
	
	
end

--crates a style of map with a number of lines of impasse. Has variable number of choke points in the impasse line.
function CreateChokeMap(basicTerrain, impasseTerrain, impasseLines, minGaps, maxGaps, minEdge, maxEdge, terrainGrid)
	
	--draw lines of impasse-----------------------------
	impasseLineTable = {}
	for impasseLineNum = 1, impasseLines do
		
		--select a direction for this line of impasse
		if(worldGetRandom() < 0.5) then
			--create a horizontal line
			startingRow = math.ceil(GetRandomInRange(minEdge, maxEdge))
			endingRow = math.ceil(GetRandomInRange(minEdge, maxEdge))
			
			impasseRoll = math.ceil(worldGetRandom() * #impasseTerrain)
			currentImpasseTerrain = impasseTerrain[impasseRoll]
			
			currentLine = DrawLineOfTerrainNoDiagonalReturn(startingRow, 1, endingRow, #terrainGrid, true, currentImpasseTerrain, #terrainGrid, terrainGrid)
			table.insert(impasseLineTable, currentLine)
			currentGaps = math.ceil(GetRandomInRange(minGaps, maxGaps))
			
			--create gaps in the line
			for gap = 1, currentGaps do
				
				currentGapIndex = math.ceil(GetRandomInRange(2, (#currentLine - 1)))
				--make plains around this opening to ensure a gap
				terrainGrid[currentLine[currentGapIndex][1]][currentLine[currentGapIndex][2]].terrainType = tt_plains
				terrainGrid[currentLine[currentGapIndex-1][1]][currentLine[currentGapIndex-1][2]].terrainType = tt_plains
				terrainGrid[currentLine[currentGapIndex+1][1]][currentLine[currentGapIndex+1][2]].terrainType = tt_plains
			end
			
		else
			--create a vertical line
			startingCol = math.ceil(GetRandomInRange(minEdge, maxEdge))
			endingCol = math.ceil(GetRandomInRange(minEdge, maxEdge))
			
			impasseRoll = math.ceil(worldGetRandom() * #impasseTerrain)
			currentImpasseTerrain = impasseTerrain[impasseRoll]
			print("selected terrain index for line of impasse is " .. impasseRoll)
			print("number of elements in the impasse table is " .. #impasseTerrain)
			currentLine = DrawLineOfTerrainNoDiagonalReturn(1, startingCol, #terrainGrid, endingCol, true, currentImpasseTerrain, #terrainGrid, terrainGrid)
			table.insert(impasseLineTable, currentLine)
			currentGaps = math.ceil(GetRandomInRange(minGaps, maxGaps))
			
			--create gaps in the line
			for gap = 1, currentGaps do
				
				currentGapIndex = math.ceil(GetRandomInRange(2, (#currentLine - 1)))
				--make plains around this opening to ensure a gap
				terrainGrid[currentLine[currentGapIndex][1]][currentLine[currentGapIndex][2]].terrainType = tt_plains
				terrainGrid[currentLine[currentGapIndex-1][1]][currentLine[currentGapIndex-1][2]].terrainType = tt_plains
				terrainGrid[currentLine[currentGapIndex+1][1]][currentLine[currentGapIndex+1][2]].terrainType = tt_plains
			end
		end
		
	end
	
	--go through all lines and check for intersections. Create gaps at intersections to ensure map playability
	for lineIndex = 1, #impasseLineTable do
		for linePointIndex = 1, #impasseLineTable[lineIndex] do
			currentRow = impasseLineTable[lineIndex][linePointIndex][1]
			currentCol = impasseLineTable[lineIndex][linePointIndex][2]
			
			currentPoint = {currentRow, currentCol}
			
			--check if this point is in any other line
			for testLineIndex = 1, #impasseLineTable do
				
				if(testLineIndex ~= lineIndex) then
					--check other lines for this point
					if(Table_ContainsCoordinateIndex(impasseLineTable[testLineIndex], currentPoint) == true) then
						
						--make a flat space around this point
						terrainGrid[currentRow][currentCol].terrainType = tt_plains
						currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
						
						for neighborIndex, neighbor in ipairs(currentNeighbors) do
							
							currentNeighborRow = neighbor.x 
							currentNeighborCol = neighbor.y 
							
							terrainGrid[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
						end
					end
				end
			end
			
			
		end
	end
	
	--fill map with base terrain elevation features randomly from selected terrain styles
	for row = 1, gridSize do
		for col = 1, gridSize do
		
			if(terrainGrid[row][col].terrainType == tt_none) then
				terrainRoll = math.ceil(worldGetRandom() * #basicTerrain)
				currentTerrainType = basicTerrain[terrainRoll]
				terrainGrid[row][col].terrainType = currentTerrainType
			end
		end
	end
	
	thinningList = {tt_impasse_mountains, tt_mountains}
	ThinTerrain(tt_impasse_mountains, 2, thinningList, tt_mountains, false, terrainGrid)
	print("creating choke point map")
	
end

--creates map consisting of pockets of open terrain separated by impasse.
function CreateMazeMap(basicTerrain, impasseTerrain, colGap, terrainGrid)
	
	--fill map with impasse first
	for row = 1, #terrainGrid do
		for col = 1, #terrainGrid do
		
			if(terrainGrid[row][col].terrainType == tt_none) then
				terrainRoll = math.ceil(worldGetRandom() * #impasseTerrain)
				currentTerrain = impasseTerrain[terrainRoll]
				terrainGrid[row][col].terrainType = currentTerrain
			end
			
		end
	end
	
	--quick local function to shuffle a table
	local function shuffleTable(table)
		
		for i = 1, #table do
		
			j = math.ceil(worldGetRandom() * #table)
			
			table[i], table[j] = table[j], table[i]
		end
		
	end
		
	--save a list of points from each column
	randomPoints = {}
	
	lowerColThreshold = 2
	upperColThreshold = #terrainGrid - 1
	--base case, grab the first point (not on the edge of the map)
	randomCol = math.ceil(GetRandomInRange(lowerColThreshold, #terrainGrid-(lowerColThreshold - 1)))
	
	--save the point in the list
	table.insert(randomPoints, {lowerColThreshold, randomCol})
	previousCol = randomCol
	
	--loop through all rows and pick a column square for each one
	for currentRow = lowerColThreshold, upperColThreshold do
		
		--grab a random column
		randomCol = math.ceil(GetRandomInRange(lowerColThreshold, #terrainGrid-(lowerColThreshold - 1)))
		currentColGap = math.abs(previousCol - randomCol)
		
		--search for a column gap large enough
		while(currentColGap <= colGap) do
			randomCol = math.ceil(GetRandomInRange(lowerColThreshold, #terrainGrid-(lowerColThreshold - 1)))
			currentColGap = math.abs(previousCol - randomCol)
		end
		
		previousCol = randomCol
		
		--save the point
		table.insert(randomPoints, {currentRow, randomCol})
		
	end
	
	unshuffledTable = DeepCopy(randomPoints)
	shuffleTable(randomPoints)
	
	--iterate through shuffled points in sequence, adding playable space around each one
	
	--base case to save the data for the first iteration
	currentRow = randomPoints[1][1]
	currentCol = randomPoints[1][2]
	
	currentPointNeighbors = Get12Neighbors(currentRow, currentCol, terrainLayoutResult)
	for neighborIndex, neighbor in ipairs(currentPointNeighbors) do
		currentNeighborRow = neighbor.x 
		currentNeighborCol = neighbor.y 
		
		terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
	
	end
	
		
	previousRow = currentRow
	previousCol = currentCol
	
	--the chance to create a line between the points
	mazeLineChance = 0.75
	
	--loop through all other points
	for rowIndex = 2, #randomPoints do
		
		currentRow = randomPoints[rowIndex][1]
		currentCol = randomPoints[rowIndex][2]
		
		currentPointNeighbors = Get12Neighbors(currentRow, currentCol, terrainLayoutResult)
		for neighborIndex, neighbor in ipairs(currentPointNeighbors) do
			currentNeighborRow = neighbor.x 
			currentNeighborCol = neighbor.y 
			
			terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
		
		end
		
		--draw a line of passable terrain between this point and the previous
		if(worldGetRandom() < mazeLineChance) then
			DrawLineOfTerrainNoDiagonalReturn(currentRow, currentCol, previousRow, previousCol, true, tt_plains, #terrainGrid, terrainGrid)
		end
		
		previousRow = currentRow
		previousCol = currentCol 
	end
	
	--thin out mountains
	thinningList = {tt_impasse_mountains, tt_mountains}
	ThinTerrain(tt_impasse_mountains, 1, thinningList, tt_hills_low_rolling, false, terrainLayoutResult)
	ThinTerrain(tt_mountains, 5, thinningList, tt_plateau_low, true, terrainLayoutResult)
	
	--ensure plateaus created have entrances
	for row = 1, #terrainGrid do
		for col = 1, #terrainGrid do
			
			if(terrainGrid[row][col].terrainType == tt_plateau_low) then
				--grab neighbors
				currentPlateauNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
				hasNeighborPlains = false
				for neighborIndex, neighbor in ipairs(currentPlateauNeighbors) do
					currentNeighborRow = neighbor.x 
					currentNeighborCol = neighbor.y 
					
					currentNeighborTerrain = terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType
					
					--see if the current neighbor terrain is plains
					if(currentNeighborTerrain == tt_plains) then
						hasNeighborPlains = true
					end
					
				end
				
				if(hasNeighborPlains == true) then
					terrainGrid[row][col].terrainType = tt_hills_low_rolling
				end
			end
		end
	end
		
	print("creating maze map")
	
end

--creates a map that contains one or more central defendable areas containing resources
function CreateCentreMap(basicTerrain, impasseTerrain, centreFeatureNum, minFeatureRadius, maxFeatureRadius, impasseChance, terrainGrid)
	
	if(centreFeatureNum == 1) then
		minCentreArea = math.ceil(#terrainGrid * 0.475)
		maxCentreArea = math.ceil(#terrainGrid * 0.525)
	else
		minCentreArea = math.ceil(#terrainGrid * 0.3)
		maxCentreArea = math.ceil(#terrainGrid * 0.7)
	end
	centreDif = Round(((maxCentreArea - minCentreArea)/2), 0)
	centrePoint = Round((#terrainGrid / 2), 0)
	
	--loop and place each centre feature
	for featureIndex = 1, centreFeatureNum do
		
		--grab a point to be the focus of the circle
		randomRow, randomCol = GetSquareInBox(centrePoint - centreDif, centrePoint + centreDif, centrePoint - centreDif, centrePoint + centreDif, #terrainGrid)
		currentFeatureRadius = math.ceil(GetRandomInRange(minFeatureRadius, maxFeatureRadius))
		
		currentFeatureSquares = GetAllSquaresInRingAroundSquare(randomRow, randomCol, currentFeatureRadius, currentFeatureRadius-1, terrainGrid)
		currentInnerFeatureSquares = GetAllSquaresInRingAroundSquare(randomRow, randomCol, currentFeatureRadius-1, 1, terrainGrid)
		
		--set chance for resources to spawn in the centre feature
		resourceChance = 0.35
		
		for index = 1, #currentInnerFeatureSquares do
			
			currentRow = currentInnerFeatureSquares[index][1]
			currentCol = currentInnerFeatureSquares[index][2]
			
			if(worldGetRandom() < resourceChance) then
				--spawn a gold deposit in the feature
				terrainGrid[currentRow][currentCol].terrainType = tt_pocket_gold_food
			else
				terrainGrid[currentRow][currentCol].terrainType = tt_plains
			end
			
		end
		
		--set type of impasse creating the ring
		impasseRoll = math.ceil(worldGetRandom() * #impasseTerrain)
		currentImpasseTerrain = impasseTerrain[impasseRoll]
		
		--set the ring
		for index = 1, #currentFeatureSquares do
			
			currentRow = currentFeatureSquares[index][1]
			currentCol = currentFeatureSquares[index][2]
			
			terrainGrid[currentRow][currentCol].terrainType = currentImpasseTerrain
		end
		
		--create an opening in the ring, not at the beginning or end of the list
		randomOpeningIndex = math.ceil(GetRandomInRange(2, (#currentFeatureSquares - 1)))
		openingRow1 = currentFeatureSquares[randomOpeningIndex][1]
		openingCol1 = currentFeatureSquares[randomOpeningIndex][2]
		openingRow2 = currentFeatureSquares[randomOpeningIndex+1][1]
		openingCol2 = currentFeatureSquares[randomOpeningIndex+1][2]
		openingRow3 = currentFeatureSquares[randomOpeningIndex-1][1]
		openingCol3 = currentFeatureSquares[randomOpeningIndex-1][2]
		
		terrainGrid[openingRow1][openingCol1].terrainType = tt_plains
		terrainGrid[openingRow2][openingCol2].terrainType = tt_plains
		terrainGrid[openingRow3][openingCol3].terrainType = tt_plains
		
		--open the opposite end also
		oppositeOpeningIndex = #currentFeatureSquares - randomOpeningIndex + 1
		if(oppositeOpeningIndex < 2) then
			oppositeOpeningIndex = 2
		end
		if(oppositeOpeningIndex > #currentFeatureSquares - 1) then
			oppositeOpeningIndex = #currentFeatureSquares - 1
		end
		oppositeRow1 = currentFeatureSquares[oppositeOpeningIndex][1]
		oppositeCol1 = currentFeatureSquares[oppositeOpeningIndex][2]
		oppositeRow2 = currentFeatureSquares[oppositeOpeningIndex+1][1]
		oppositeCol2 = currentFeatureSquares[oppositeOpeningIndex+1][2]
		oppositeRow3 = currentFeatureSquares[oppositeOpeningIndex-1][1]
		oppositeCol3 = currentFeatureSquares[oppositeOpeningIndex-1][2]
		
		terrainGrid[oppositeRow1][oppositeCol1].terrainType = tt_plains
		terrainGrid[oppositeRow2][oppositeCol2].terrainType = tt_plains
		terrainGrid[oppositeRow3][oppositeCol3].terrainType = tt_plains
		
	end
	
	--add additional random impasse
	for row = 1, #terrainGrid do
		for col = 1, #terrainGrid do
		
			if(terrainGrid[row][col].terrainType == tt_none) then
				if(worldGetRandom() < impasseChance) then
					terrainRoll = math.ceil(worldGetRandom() * # impasseTerrain)
					currentImpasseTerrain = impasseTerrain[terrainRoll]
					terrainGrid[row][col].terrainType = currentImpasseTerrain
				end
			end
		end
	end
		
	--fill the rest of the map with basic elevation
	for row = 1, #terrainGrid do
		for col = 1, #terrainGrid do
		
			if(terrainGrid[row][col].terrainType == tt_none) then
				
				terrainRoll = math.ceil(worldGetRandom() * # basicTerrain)
				currentBasicTerrain = basicTerrain[terrainRoll]
				terrainGrid[row][col].terrainType = currentBasicTerrain
			end
			
		end
	end
	
	print("creating centre feature map")
	
end

--this function sets up a water map with teams of players placed on their own islands
--weightTable is a table of values that hold the islands that will be created and their weight values. A higher weighted island will have a larger chance of being expanded in size as the map is built
--land coverage is a value from 0 to 1 and specifies the percentage of the map to be covered in land. eg a map with 0.75 landCoverage will have 75% of the grid squares consist of land terrain types
--distanceBetweenIslands is how far apart initial island seeding points are
--edgeGap is the number of squares around the edge of the map that island land squares cannot occupy
--islandGap is the number of spaces between island shores
--the teamMappingTable (created with the CreateTeamMappingTable function) holds which players are on which teams and sets up islands appropriately
--playerStartTerrain is whatever type of terrain you are using to spawn your starting resources
--cliffChance denotes the likelihood of a cliff spawning on the shore of an island (gives a non-landable beach)
--inlandTerrainChance is a number from 0 to 1 denoting the chance to change a square of island land terrain into one of the other types passed in
--inlandTerrain is a table of terrain types that can be chosen to replace basic plains on islands (based on the inlandTerrainChance parameter)
function CreateIslandsTeamsTogether(weightTable, equalIslandNum, equalIslandLandPercent, landCoverage, distanceBetweenIslands, edgeGap, islandGap, teamMappingTable, playerStartTerrain, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, terrainGrid)

	--generate table of points that are viable for seeding island points
	gridSize = #terrainGrid
	innerBuffer = math.ceil(gridSize * 0.25)
	outerBuffer = math.ceil(gridSize * 0.75)
	terrainGridCopy = DeepCopy(terrainGrid)
	triedLooseInlandPoints = false
	::restartIslandGen::
	
	openList = {}
	for row = 1, gridSize do
		for col = 1, gridSize do
		
			if((  (row > edgeGap and row <= innerBuffer) or (row > outerBuffer and row < (gridSize - (edgeGap - 1))) ) and ((col > edgeGap and col <= innerBuffer) or (col > outerBuffer and col < (gridSize - (edgeGap - 1))) )  ) then
				
				currentPoint = {}
				currentPoint = {row, col}
				table.insert(openList, currentPoint)
			end
		end
	end
	
	repeat
		islandStartingPoints = GetSetOfSquaresDistanceApart(#weightTable, distanceBetweenIslands, openList, terrainGrid)
		
		if(#islandStartingPoints < #weightTable) then
			islandStartingPoints = {}
			distanceBetweenIslands = distanceBetweenIslands - 1
		end
	until (#islandStartingPoints == #weightTable)
		
	ShuffleTable(islandStartingPoints)
	islandPoints = {}
--	islandPoints = CreateIslandsWeighted(islandStartingPoints, weightTable, landCoverage, islandGap, edgeGap, terrainGrid)
	islandPoints = CreateIslandsWeightedEven(islandStartingPoints, equalIslandNum, equalIslandLandPercent, weightTable, landCoverage, islandGap, edgeGap, terrainGrid)
	--iterate through generated island points and put down land
	for islandIndex = 1, #islandPoints do
		
		--iterate through points on the island
		for islandPointIndex = 1, #islandPoints[islandIndex] do
			
			--grab this point and set the terrain
			currentRow = islandPoints[islandIndex][islandPointIndex][1]
			currentCol = islandPoints[islandIndex][islandPointIndex][2]
			
			--set the terrain
			terrainGrid[currentRow][currentCol].terrainType = tt_island_plains
			
		end
		
	end
	
	--loop through and smooth the islands to eliminate any ocean holes
	landSmoothingThreshold = 6
	
	for row = 1, gridSize do
		for col = 1, gridSize do
		
			if(terrainGrid[row][col].terrainType == tt_ocean) then
				
				--check the neighbors
				currentNeighbors = Get8Neighbors(row, col, terrainGrid)
				
				currentLandNeighbors = 0
				--iterate through neighbors of this point
				for neighborIndex, neighbor in ipairs(currentNeighbors) do
					
					--check the terrain types of all neighbors, check for ocean terrain type
					currentNeighborRow = neighbor.x 
					currentNeighborCol = neighbor.y 
					
					if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_island_plains) then
						currentLandNeighbors = currentLandNeighbors + 1
					end
				end
				
				if(currentLandNeighbors >= landSmoothingThreshold) then
					terrainGrid[row][col].terrainType = tt_island_plains
				end
			end
		end
	end
	
	--go through islands and set any terrain touching ocean to a beach
	for islandIndex = 1, #islandPoints do
		
		--iterate through points on the island
		for islandPointIndex = 1, #islandPoints[islandIndex] do
			
			--grab this point
			currentRow = islandPoints[islandIndex][islandPointIndex][1]
			currentCol = islandPoints[islandIndex][islandPointIndex][2]
			
			--check the neighbors
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
			
			hasOceanNeighbor = false
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				--check the terrain types of all neighbors, check for ocean terrain type
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
					hasOceanNeighbor = true
				end
			end
			
			--if there was at least one ocean neighbor, turn this square into a beach
			beachChance = 0.7
			if(hasOceanNeighbor == true) then
				if(worldGetRandom() < beachChance) then
					terrainGrid[currentRow][currentCol].terrainType = tt_beach
				end
			end
			
		end
		
	end
	
	--go back through islands and set anything inland to regular plains terrain
	--inland defined as squares that don't touch an ocean but are adjacent to a beach or island plains
	for islandIndex = 1, #islandPoints do
		
		--iterate through points on the island
		for islandPointIndex = 1, #islandPoints[islandIndex] do
			
			--grab this point
			currentRow = islandPoints[islandIndex][islandPointIndex][1]
			currentCol = islandPoints[islandIndex][islandPointIndex][2]
			
			--check the neighbors
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
			
			hasOceanNeighbor = false
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				--check the terrain types of all neighbors, check for ocean terrain type
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
					hasOceanNeighbor = true
				end
			end
			
			if(hasOceanNeighbor == false) then
				terrainGrid[currentRow][currentCol].terrainType = tt_plains
			end
			
		end
		
	end
	
	--find largest islands, put spawns on them
	islandSizes = {}
	for islandIndex = 1, #islandPoints do
		
		currentIslandSquares = #islandPoints[islandIndex]
		currentData = {
			islandNum = islandIndex,
			islandSquares = currentIslandSquares
		}
		
		table.insert(islandSizes, currentData)
		
	end
	
	--sort islands based on their size
	table.sort(islandSizes, function(a,b) return a.islandSquares > b.islandSquares end)
	
	
	for teamIndex = 1, #teamMappingTable do
		
		--find the middle of each island (or square closest to the middle)
		averageRow = 0
		averageCol = 0
		
		currentTeam = teamMappingTable[teamIndex]
		currentTeamPlayers = currentTeam.playerCount
		
		currentIsland = islandSizes[teamIndex].islandNum
		
		--create subset of island points that are inland so players do not spawn on the beach
		
		--TODO THIS CODE HERE
		
		--get subset of island points that are not adjacent to ocean
		inlandPoints = {}
		for islandPointIndex = 1, #islandPoints[currentIsland] do
			
			currentRow = islandPoints[currentIsland][islandPointIndex][1]
			currentCol = islandPoints[currentIsland][islandPointIndex][2]
			
			currentNeighbors = {}
			currentNeighbors = Get20Neighbors(currentRow, currentCol, terrainLayoutResult)
			
			currentOceanNeighbors = 0
			for neighborIndex, islandNeighbor in ipairs(currentNeighbors) do
				
				currentNeighborRow = islandNeighbor.x
				currentNeighborCol = islandNeighbor.y 
				if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
					currentOceanNeighbors = currentOceanNeighbors + 1
				end
			end
			
			--this point is inland and away from the map edge
			if(currentOceanNeighbors == 0 and (currentRow >= 3 and currentRow <= gridSize - 2 and currentCol >= 3 and currentCol <= gridSize - 2)) then
				inlandPoint = {}
				inlandPoint = {currentRow, currentCol}
				
				table.insert(inlandPoints, inlandPoint)
			end
			
		end
		
		if(#inlandPoints < currentTeamPlayers) then
			::looseInlandPoints::
			inlandPoints = {}
			for islandPointIndex = 1, #islandPoints[currentIsland] do
				
				currentRow = islandPoints[currentIsland][islandPointIndex][1]
				currentCol = islandPoints[currentIsland][islandPointIndex][2]
				
				currentNeighbors = {}
				currentNeighbors = Get12Neighbors(currentRow, currentCol, terrainLayoutResult)
				
				currentOceanNeighbors = 0
				for neighborIndex, islandNeighbor in ipairs(currentNeighbors) do
					
					currentNeighborRow = islandNeighbor.x
					currentNeighborCol = islandNeighbor.y 
					if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
						currentOceanNeighbors = currentOceanNeighbors + 1
					end
				end
				
				--this point is inland
				if(currentOceanNeighbors == 0) then
					inlandPoint = {}
					inlandPoint = {currentRow, currentCol}
					
					table.insert(inlandPoints, inlandPoint)
				end
				
			end
			triedLooseInlandPoints = true
		end
		
		--find appropriate number of squares on the island
		currentPlayerDistance = 25
		currentPlacedPlayers = 0
		while(currentPlacedPlayers < currentTeamPlayers) do
			
			currentIslandPlayerPoints = GetSetOfSquaresDistanceApart(currentTeamPlayers, currentPlayerDistance, inlandPoints, terrainGrid)
			currentPlacedPlayers = #currentIslandPlayerPoints
			
			if(currentPlacedPlayers < currentTeamPlayers) then
				currentPlayerDistance = currentPlayerDistance - 1
				print("player distance is now " .. currentPlayerDistance)
				if(currentPlayerDistance < 3) then
				
					currentPlayerDistance = 25
					inlandPoints = {}
					for islandPointIndex = 1, #islandPoints[currentIsland] do
						
						currentRow = islandPoints[currentIsland][islandPointIndex][1]
						currentCol = islandPoints[currentIsland][islandPointIndex][2]
						
						currentNeighbors = {}
						currentNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
						
						currentOceanNeighbors = 0
						for neighborIndex, islandNeighbor in ipairs(currentNeighbors) do
							
							currentNeighborRow = islandNeighbor.x
							currentNeighborCol = islandNeighbor.y 
							if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
								currentOceanNeighbors = currentOceanNeighbors + 1
							end
						end
						
						--this point is inland
						if(currentOceanNeighbors == 0) then
							inlandPoint = {}
							inlandPoint = {currentRow, currentCol}
							
							table.insert(inlandPoints, inlandPoint)
						end
						
					end
					
				end
			end
		end
		--loop through each player on this team
		for pIndex = 1, #currentIslandPlayerPoints do
		
			currentRow = currentIslandPlayerPoints[pIndex][1]
			currentCol = currentIslandPlayerPoints[pIndex][2]
			
			currentPlayerID = currentTeam.players[pIndex].playerID
			
			terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
			terrainGrid[currentRow][currentCol].playerIndex = (currentPlayerID - 1) --you must assign player IDs to the starting squares, starting at player 0 (matches the game setup screen)
			
			--add buffer terrain around the player start to make sure the players don't have their capital on the coastline
			bufferSquares = GetAllSquaresInRingAroundSquare(currentRow, currentCol, 2, 2, terrainGrid)
			for bIndex = 1, #bufferSquares do
				row = bufferSquares[bIndex][1]
				col = bufferSquares[bIndex][2]
				
				if (terrainGrid[row][col].terrainType ~= playerStartTerrain) then
					terrainGrid[row][col].terrainType = tt_plains_smooth
				end
				
			end
			
		end
		
		
	end
	
	--loop through and add cliffs to the edge of islands based on the cliffChance parameter
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if(terrainGrid[row][col].terrainType == tt_beach) then
				currentPlayerNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 2, 2, {playerStartTerrain}, terrainGrid)
				
				if(#currentPlayerNeighbors == 0 and worldGetRandom() < cliffChance) then
					--add in some cliffs on top of beach squares to make areas of cliffs going into the ocean for island defence 
					terrainGrid[row][col].terrainType = tt_plateau_low
					currentFlatNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 1, 1, {tt_plains}, terrainGrid)
					currentBeachNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 1, 1, {tt_beach}, terrainGrid)
					if(#currentFlatNeighbors > 0) then
						chosenIndex = math.ceil(worldGetRandom() * #currentFlatNeighbors)
						--put a rolling hill beside the cliff to be able to get up from the island interior
						terrainGrid[currentFlatNeighbors[chosenIndex][1]][currentFlatNeighbors[chosenIndex][2]].terrainType = tt_hills_med_rolling
					end
					
					if(#currentBeachNeighbors > 0) then
						chosenIndex = math.ceil(worldGetRandom() * #currentBeachNeighbors)
						
						terrainGrid[currentBeachNeighbors[chosenIndex][1]][currentBeachNeighbors[chosenIndex][2]].terrainType = tt_plateau_low
					end
				end
			end
		end
	end
	
	--fill inland with interesting terrain
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if(terrainGrid[row][col].terrainType == tt_plains) then
				currentPlayerNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, 2, 2, {playerStartTerrain}, terrainGrid)
				--randomly add in some mountains on the islands
				if(#currentPlayerNeighbors == 0 and worldGetRandom() < inlandTerrainChance) then
					terrainRoll = math.ceil(worldGetRandom() * #inlandTerrain)
					currentTerrain = inlandTerrain[terrainRoll]
					terrainGrid[row][col].terrainType = currentTerrain
					
				elseif(#currentPlayerNeighbors == 0 and worldGetRandom() < forestChance) then
					terrainGrid[row][col].terrainType = tt_impasse_trees_plains_naval
				end
			end
			
			if(terrainGrid[row][col].terrainType == tt_island_plains) then
				terrainGrid[row][col].terrainType = tt_beach
			end
			
		end
	end
	
	print("creating islands with teams together")
end

--this function creates a water map consisting of islands where each player gets their own island
--weightTable is a table of values that hold the islands that will be created and their weight values. A higher weighted island will have a larger chance of being expanded in size as the map is built
--land coverage is a value from 0 to 1 and specifies the percentage of the map to be covered in land. eg a map with 0.75 landCoverage will have 75% of the grid squares consist of land terrain types
--distanceBetweenIslands is how far apart initial island seeding points are
--edgeGap is the number of squares around the edge of the map that island land squares cannot occupy
--islandGap is the number of spaces between island shores
--the teamMappingTable (created with the CreateTeamMappingTable function) holds which players are on which teams and sets up islands appropriately
--playerStartTerrain is whatever type of terrain you are using to spawn your starting resources
--cliffChance denotes the likelihood of a cliff spawning on the shore of an island (gives a non-landable beach)
--inlandTerrainChance is a number from 0 to 1 denoting the chance to change a square of island land terrain into one of the other types passed in
--inlandTerrain is a table of terrain types that can be chosen to replace basic plains on islands (based on the inlandTerrainChance parameter)
function CreateIslandsTeamsApart(weightTable, landCoverage, equalIslandLandPercent, equalIslandNum, distanceBetweenIslands, edgeGap, islandGap, teamMappingTable, playerStartTerrain, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, terrainGrid)

	--generate table of points that are viable for seeding island points
	gridSize = #terrainGrid
	innerBuffer = math.ceil(gridSize * 0.25)
	outerBuffer = math.ceil(gridSize * 0.75)
	openList = {}
	print("edge gap is " .. edgeGap)
	print("innerBuffer is " .. innerBuffer)
	print("outerBuffer is " .. outerBuffer)
	for row = 1, gridSize do
		for col = 1, gridSize do
			print("looking at point " .. row .. ", " .. col)
			if((  (row > edgeGap and row <= innerBuffer) or (row > outerBuffer and row < (gridSize - (edgeGap - 1))) ) and ((col > edgeGap and col <= innerBuffer) or (col > outerBuffer and col < (gridSize - (edgeGap - 1))) )  ) then
				print("putting this point in the open list")
				currentPoint = {}
				currentPoint = {row, col}
				table.insert(openList, currentPoint)
			end
		end
	end
	
	repeat
		islandStartingPoints = GetSetOfSquaresDistanceApart(#weightTable, distanceBetweenIslands, openList, terrainGrid)
		
		if(#islandStartingPoints < #weightTable) then
			islandStartingPoints = {}
			distanceBetweenIslands = distanceBetweenIslands - 1
		end
	until (#islandStartingPoints == #weightTable)
	
	islandPoints = {}
	--islandPoints = CreateIslandsWeighted(islandStartingPoints, weightTable, landCoverage, islandGap, edgeGap, terrainGrid)
	islandPoints = CreateIslandsWeightedEven(islandStartingPoints, equalIslandNum, equalIslandLandPercent, weightTable, landCoverage, islandGap, edgeGap, terrainGrid)
	
	--iterate through generated island points and put down land
	for islandIndex = 1, #islandPoints do
		
		--iterate through points on the island
		for islandPointIndex = 1, #islandPoints[islandIndex] do
			
			--grab this point and set the terrain
			currentRow = islandPoints[islandIndex][islandPointIndex][1]
			currentCol = islandPoints[islandIndex][islandPointIndex][2]
			
			--set the terrain
			terrainGrid[currentRow][currentCol].terrainType = tt_island_plains
			
		end
		
	end
	
	
	--loop through and smooth the islands to eliminate any ocean holes
	landSmoothingThreshold = 6
	
	for row = 1, gridSize do
		for col = 1, gridSize do
		
			if(terrainGrid[row][col].terrainType == tt_ocean) then
				
				--check the neighbors
				currentNeighbors = Get8Neighbors(row, col, terrainGrid)
				
				currentLandNeighbors = 0
				--iterate through neighbors of this point
				for neighborIndex, neighbor in ipairs(currentNeighbors) do
					
					--check the terrain types of all neighbors, check for ocean terrain type
					currentNeighborRow = neighbor.x 
					currentNeighborCol = neighbor.y 
					
					if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_island_plains) then
						currentLandNeighbors = currentLandNeighbors + 1
					end
				end
				
				if(currentLandNeighbors >= landSmoothingThreshold) then
					terrainGrid[row][col].terrainType = tt_island_plains
				end
			end
		end
	end
	
	--go through islands and set any terrain touching ocean to a beach
	for islandIndex = 1, #islandPoints do
		
		--iterate through points on the island
		for islandPointIndex = 1, #islandPoints[islandIndex] do
			
			--grab this point
			currentRow = islandPoints[islandIndex][islandPointIndex][1]
			currentCol = islandPoints[islandIndex][islandPointIndex][2]
			
			--check the neighbors
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
			
			hasOceanNeighbor = false
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				--check the terrain types of all neighbors, check for ocean terrain type
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
					hasOceanNeighbor = true
				end
			end
			
			--if there was at least one ocean neighbor, turn this square into a beach
			beachChance = 0.7
			if(hasOceanNeighbor == true) then
				if(worldGetRandom() < beachChance) then
					terrainGrid[currentRow][currentCol].terrainType = tt_beach
				end
			end
			
		end
		
	end
	
	--go back through islands and set anything inland to regular plains terrain
	--inland defined as squares that don't touch an ocean but are adjacent to a beach or island plains
	for islandIndex = 1, #islandPoints do
		
		--iterate through points on the island
		for islandPointIndex = 1, #islandPoints[islandIndex] do
			
			--grab this point
			currentRow = islandPoints[islandIndex][islandPointIndex][1]
			currentCol = islandPoints[islandIndex][islandPointIndex][2]
			
			--check the neighbors
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
			
			hasOceanNeighbor = false
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				--check the terrain types of all neighbors, check for ocean terrain type
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
					hasOceanNeighbor = true
				end
			end
			
			if(hasOceanNeighbor == false) then
				terrainGrid[currentRow][currentCol].terrainType = tt_plains
			end
			
		end
		
	end
	
	
	
	inlandPointTable = {}
	for islandIndex = 1, #islandPoints do
		
		inlandPoints = {}
		for islandPointIndex = 1, #islandPoints[islandIndex] do
			
			currentRow = islandPoints[islandIndex][islandPointIndex][1]
			currentCol = islandPoints[islandIndex][islandPointIndex][2]
			
			currentNeighbors = {}
			currentNeighbors = Get12Neighbors(currentRow, currentCol, terrainLayoutResult)
			
			currentOceanNeighbors = 0
			for neighborIndex, islandNeighbor in ipairs(currentNeighbors) do
				
				currentNeighborRow = islandNeighbor.x
				currentNeighborCol = islandNeighbor.y 
				if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
					currentOceanNeighbors = currentOceanNeighbors + 1
				end
			end
			
			--this point is inland
			if(currentOceanNeighbors == 0) then
				inlandPoint = {}
				inlandPoint = {currentRow, currentCol}
				
				table.insert(inlandPoints, inlandPoint)
			end
			
		end
		print("island " .. islandIndex .. " has " .. #inlandPoints .. " inland points")
		table.insert(inlandPointTable, inlandPoints)
		
	end
	
	--find largest islands, put spawns on them
	islandSizes = {}
	for islandIndex = 1, #islandPoints do
		
		currentIslandSquares = #inlandPointTable[islandIndex]
		currentData = {
			islandNum = islandIndex,
			islandSquares = currentIslandSquares
		}
		
		table.insert(islandSizes, currentData)
		
	end
	
	--sort islands based on their size
	table.sort(islandSizes, function(a,b) return a.islandSquares > b.islandSquares end)
	
	--loop through for each player and find / assign island spawns
	for playerNum = 1, worldPlayerCount do
		
		--find the middle of each island (or square closest to the middle)
		averageRow = 0
		averageCol = 0
		
		currentIsland = islandSizes[playerNum].islandNum
		
		for islandPointIndex = 1, #islandPoints[currentIsland] do
			currentRow = islandPoints[currentIsland][islandPointIndex][1]
			currentCol = islandPoints[currentIsland][islandPointIndex][2]
			
			averageRow = averageRow + currentRow
			averageCol = averageCol + currentCol
			
		end
		
		averageRow = math.ceil(averageRow / #islandPoints[currentIsland])
		averageCol = math.ceil(averageCol / #islandPoints[currentIsland])
		
		
		
			
		--this function will find the closest square from a table of squares.
		--function found in the engine folder, under scar/terrainlayout/library/getsquaresfunctions
		middleRow, middleCol, middleSquareIndex = GetClosestSquare(averageRow, averageCol, inlandPointTable[currentIsland])
		
		currentPlayerID = playerNum - 1
		
		terrainGrid[middleRow][middleCol].terrainType = playerStartTerrain
		terrainGrid[middleRow][middleCol].playerIndex = currentPlayerID --you must assign player IDs to the starting squares, starting at player 0 (matches the game setup screen)
		print("player " .. currentPlayerID .. " placed at " .. middleRow .. ", " .. middleCol)
		--add buffer terrain around the player start to make sure the players don't have their capital on the coastline
		bufferSquares = GetAllSquaresInRingAroundSquare(middleRow, middleCol, 2, 2, terrainGrid)
		for bIndex = 1, #bufferSquares do
			row = bufferSquares[bIndex][1]
			col = bufferSquares[bIndex][2]
			
			if (terrainGrid[row][col].terrainType ~= playerStartTerrain) then
				terrainGrid[row][col].terrainType = tt_plains_smooth
			end
			
		end
			
		
		
	end
	
	--change beach squares into cliffs based on the cliffChance parameter
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if(terrainGrid[row][col].terrainType == tt_beach) then
				currentPlayerNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 2, 2, {playerStartTerrain}, terrainGrid)
				
				if(#currentPlayerNeighbors == 0 and worldGetRandom() < cliffChance) then
					--add in some cliffs on top of beach squares to make areas of cliffs going into the ocean for island defence 
					terrainGrid[row][col].terrainType = tt_plateau_low
					currentFlatNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 1, 1, {tt_plains}, terrainGrid)
					currentBeachNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 1, 1, {tt_beach}, terrainGrid)
					if(#currentFlatNeighbors > 0) then
						chosenIndex = math.ceil(worldGetRandom() * #currentFlatNeighbors)
						--put a rolling hill beside the cliff to be able to get up from the island interior
						terrainGrid[currentFlatNeighbors[chosenIndex][1]][currentFlatNeighbors[chosenIndex][2]].terrainType = tt_hills_med_rolling
					end
					
					if(#currentBeachNeighbors > 0) then
						chosenIndex = math.ceil(worldGetRandom() * #currentBeachNeighbors)
						
						terrainGrid[currentBeachNeighbors[chosenIndex][1]][currentBeachNeighbors[chosenIndex][2]].terrainType = tt_plateau_low
					end
				end
			end
		end
	end
	
	--fill inland with interesting terrain
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if(terrainGrid[row][col].terrainType == tt_plains) then
				currentPlayerNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 2, 2, {playerStartTerrain}, terrainGrid)
				--randomly add in some mountains on the islands
				if(#currentPlayerNeighbors == 0 and worldGetRandom() < inlandTerrainChance) then
					terrainRoll = math.ceil(worldGetRandom() * #inlandTerrain)
					currentTerrain = inlandTerrain[terrainRoll]
					terrainGrid[row][col].terrainType = currentTerrain
				elseif(#currentPlayerNeighbors == 0 and worldGetRandom() < forestChance) then
					terrainGrid[row][col].terrainType = tt_impasse_trees_plains_naval
				end
			end
			
			if(terrainGrid[row][col].terrainType == tt_island_plains) then
				terrainGrid[row][col].terrainType = tt_beach
			end
		end
	end
	print("creating islands with teams apart")
end


function CreateIslandsTeamsTogetherEven(islandSizePerPlayer, equalIslandNum, totalIslandNum, distanceBetweenIslands, edgeBuffer, innerExclusion, inlandRadius, islandGap, teamMappingTable, playerStartTerrain, startBufferRadius, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, minTeamDistance, minPlayerDistance, impasseTypes, impasseDistance, topSelectionThreshold, playerEdgeGap, terrainGrid)

	--find island starting points according to teams
	teamMappingTable = GetStartLocations(teamMappingTable, minTeamDistance, minPlayerDistance, playerEdgeGap, innerExclusion, impasseTypes, impasseDistance, topSelectionThreshold, terrainGrid)
	
	
	--fill all equal islands
	islandPoints = {}
	
	local function Table_ContainsCoordinate(table, value)

		tableHasCoord = false
		
		for index, val in ipairs(table) do
			if (val[1] == value[1] and val[2] == value[2]) then
				tableHasCoord = true
			end
		end
		
		return tableHasCoord
	end
	
	--calculate how many max iterations of land expansion to do
	gridSize = #terrainGrid
	totalGridSquares = gridSize * gridSize
	islandSquaresAdded = 0
	
	halfInnerExclusion = innerExclusion / 2
	halfGridSize = Round(#terrainGrid / 2, 0)
	minInnerExclusion = Round(((0.5 - halfInnerExclusion) * #terrainGrid), 0)
	maxInnerExclusion = Round(((0.5 + halfInnerExclusion) * #terrainGrid), 0)
	
	
	--set up open and closed lists for each equal island
	openLists = {}
	closedLists = {}
	
	--make a list of all starting points
	startingPoints = {}
	for teamIndex = 1, #teamMappingTable do
		
		currentRow = teamMappingTable[teamIndex].teamLocation[1]
		currentCol = teamMappingTable[teamIndex].teamLocation[2]
		currentData = {}
		currentData = {currentRow, currentCol}
		table.insert(startingPoints, currentData)
		
	end
	
	for i = 1, equalIslandNum do
		openLists[i] = {}
		closedLists[i] = {}
		
		--add starting points into each island's openList
		currentPoint = {startingPoints[i][1], startingPoints[i][2], 0}
		table.insert(openLists[i], currentPoint)
	end
	
	--base case: place initial island points and create their starting open lists
	for i = 1, equalIslandNum do
		
		--add each island's starting point to their respective closed lists, and remove it from the island's openList
		currentStartPoint = openLists[i][1]
		print("placing island " .. i .. "'s start point at " .. currentStartPoint[1] .. ", " .. currentStartPoint[2])
		table.insert(closedLists[i], currentStartPoint)
		table.remove(openLists[i], 1)
	end
		
	--base case (cont'd):
	--go back and use the single closed list point to generate potential starting neighbors for each island's initial openList
	--constrained so that each entry in the open list is within the constraints of island and edge proximity
	for i = 1, equalIslandNum do
		
		currentOpenSquare = closedLists[i][1]
		
		currentRow = currentOpenSquare[1]
		currentCol = currentOpenSquare[2]
		print("generating potential neighbors of " .. currentRow .. ", " .. currentCol)
		--get the neighbors of this current square
		currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
		
		--iterate through neighbors of this point
		for neighborIndex, neighbor in ipairs(currentNeighbors) do
			
			isInBounds = false
			currentNeighborRow = neighbor.x 
			currentNeighborCol = neighbor.y 
			print("current neighbor " .. neighborIndex .. " of " .. currentRow .. ", " .. currentCol .. " is " .. currentNeighborRow .. ", " .. currentNeighborCol)
			closestIslandDistance = 10000
			--check the current neighbors for proximity constraints
			--if they are within parameters, add them to the open list
			--check for edge proximity
			if((currentNeighborRow > edgeBuffer and currentNeighborRow <= (gridSize - edgeBuffer)) and (currentNeighborCol > edgeBuffer and currentNeighborCol <= (gridSize - edgeBuffer))) then
				
				--check for other island proximity
				--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
				--also make sure there is more than 1 island
				if(equalIslandNum > 1) then
					for islandIndex = 1, equalIslandNum do
						--don't search the current island
						if(islandIndex ~= i) then
							
							--make sure this island has a closed list with any elements
							if(#closedLists[islandIndex] > 0) then
								
								--loop through this island's closed list and calculate distances to the current potential openList neighbor
								for closedListIndex = 1, #closedLists[islandIndex] do
									
									currentClosedRow = closedLists[islandIndex][closedListIndex][1]
									currentClosedCol = closedLists[islandIndex][closedListIndex][2]
									
									currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
									print("current closed distance check is " .. currentClosedDistance)
									--see if this distance is the new smallest distance
									if(currentClosedDistance < closestIslandDistance) then
										closestIslandDistance = currentClosedDistance
									end
								end
							end
						end
					end
				end
				
				--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
				if(closestIslandDistance >= distanceBetweenIslands) then
					isInBounds = true
				end
				
			else
				print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is out of accepted bounds")
			end
			
			
			--check if the neighbor is within bounding box
			if(((currentNeighborRow > minInnerExclusion) and (currentNeighborRow <= maxInnerExclusion)) and ((currentNeighborCol > minInnerExclusion) and (currentNeighborCol <= maxInnerExclusion))) then
				print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is within the exclusion zone")
				isInBounds = false
			elseif((currentNeighborRow < 1+edgeBuffer or currentNeighborRow > (#terrainGrid - edgeBuffer)) or (currentNeighborCol < 1+edgeBuffer or currentNeighborCol > (#terrainGrid - edgeBuffer))) then
				print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is outside the ring of acceptable starting donut terrain")
				isInBounds = false
			end
			
			--check to ensure there is no impasse within impasse distance
			currentImpasseNeighbors = GetAllSquaresInRadius(currentNeighborRow, currentNeighborCol, impasseDistance, terrainGrid)
			
			for neighborIndex, neighbor in ipairs(currentImpasseNeighbors) do
				currentImpasseNeighborRow = neighbor[1] 
				currentImpasseNeighborCol = neighbor[2]
				isImpasse = false
				for impasseTypeIndex = 1, #impasseTypes do
					
					if(terrainGrid[currentImpasseNeighborRow][currentImpasseNeighborCol].terrainType == impasseTypes[impasseTypeIndex]) then
						isImpasse = true
					end
				end
				if isImpasse == true then
					isInBounds = false
				end
			end
				
			
			--if the neighbor is within constraints, add it to the openList
			if(isInBounds == true) then
				currentDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentRow, currentCol, 4)
				currentPoint = {currentNeighborRow, currentNeighborCol, currentDistance}
				print("adding neighbor to openList at " .. currentNeighborRow .. ", " .. currentNeighborCol)
				table.insert(openLists[i], currentPoint)
			end
		end
	end
	
	
	
	
	currentIsland = 1
	
	topSelectionWeight = 0.05
	
	--place number of land squares based on overall land coverage calculated
	
	for islandIndex = 1, equalIslandNum do
		
		currentIslandSize = islandSizePerPlayer * #teamMappingTable[islandIndex].players
		for i = 1, currentIslandSize do
			foundSquare = false 
			
				--check to make sure there is an entry in the open list for this island
				if(#openLists[islandIndex] > 0) then
					
					--constrained so that each entry in the open list is within the constraints of island and edge proximity
					currentOpenSquareNum = math.ceil(worldGetRandom() * (#openLists[islandIndex] * topSelectionWeight))
					currentOpenSquare = openLists[islandIndex][currentOpenSquareNum]
					
					currentRow = currentOpenSquare[1]
					currentCol = currentOpenSquare[2]
					
					--get the neighbors of this current square
					currentNeighbors = GetNeighbors(currentOpenSquare[1], currentOpenSquare[2], terrainGrid)
					
					--remove the current open square from the open list and add it to the closed list
					table.remove(openLists[islandIndex], currentOpenSquareNum)
					table.insert(closedLists[islandIndex], currentOpenSquare)
					
					
					--iterate through neighbors of this point
					for neighborIndex, neighbor in ipairs(currentNeighbors) do
						
						isInBounds = false
						currentNeighborRow = neighbor.x 
						currentNeighborCol = neighbor.y 
						
						closestIslandDistance = 10000
						--check the current neighbors for proximity constraints
						--if they are within parameters, add them to the open list
						--check for edge proximity
						if((currentNeighborRow > edgeBuffer and currentNeighborRow <= (gridSize - edgeBuffer)) and (currentNeighborCol > edgeBuffer and currentNeighborCol <= (gridSize - edgeBuffer))) then
							
							--check for other island proximity
							--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
							--also make sure there is more than 1 island
							if(equalIslandNum > 1) then
								for islandCheckIndex = 1, equalIslandNum do
									--don't search the current island
									if(islandCheckIndex ~= islandIndex) then
										
										--make sure this island has a closed list with any elements
										if(#closedLists[islandCheckIndex] > 0) then
											
											--loop through this island's closed list and calculate distances to the current potential openList neighbor
											for closedListIndex = 1, #closedLists[islandCheckIndex] do
												
												currentClosedRow = closedLists[islandCheckIndex][closedListIndex][1]
												currentClosedCol = closedLists[islandCheckIndex][closedListIndex][2]
												
												currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
												
												--see if this distance is the new smallest distance
												if(currentClosedDistance < closestIslandDistance) then
													closestIslandDistance = currentClosedDistance
												end
											end
										end
									end
								end
							end
							
							--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
							if(closestIslandDistance >= distanceBetweenIslands) then
								--make sure the element is not already in the open or closed list
								if(Table_ContainsCoordinate(closedLists[islandIndex], {currentNeighborRow, currentNeighborCol}) == false and Table_ContainsCoordinate(openLists[islandIndex], {currentNeighborRow, currentNeighborCol}) == false) then
									isInBounds = true
								end
							end
							
						end
						
						--check if the neighbor is within bounding box
						if(((currentNeighborRow > minInnerExclusion) and (currentNeighborRow <= maxInnerExclusion)) and ((currentNeighborCol > minInnerExclusion) and (currentNeighborCol <= maxInnerExclusion))) then
							print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is within the exclusion zone")
							isInBounds = false
						elseif((currentNeighborRow < 1+edgeBuffer or currentNeighborRow > (#terrainGrid - edgeBuffer)) or (currentNeighborCol < 1+edgeBuffer or currentNeighborCol > (#terrainGrid - edgeBuffer))) then
							print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is outside the ring of acceptable starting donut terrain")
							isInBounds = false
						end
					
						--check to ensure there is no impasse within impasse distance
						currentImpasseNeighbors = GetAllSquaresInRadius(currentNeighborRow, currentNeighborCol, impasseDistance, terrainGrid)
						
						for neighborIndex, neighbor in ipairs(currentImpasseNeighbors) do
							currentImpasseNeighborRow = neighbor[1] 
							currentImpasseNeighborCol = neighbor[2]
							isImpasse = false
							for impasseTypeIndex = 1, #impasseTypes do
								
								if(terrainGrid[currentImpasseNeighborRow][currentImpasseNeighborCol].terrainType == impasseTypes[impasseTypeIndex]) then
									isImpasse = true
								end
							end
							if isImpasse == true then
								isInBounds = false
							end
						end
						
						--if the neighbor is within constraints, add it to the openList
						if(isInBounds == true) then
							
							currentDistance = GetDistance(currentNeighborRow, currentNeighborCol, closedLists[islandIndex][1][1], closedLists[islandIndex][1][2], 4)
							currentPoint = {currentNeighborRow, currentNeighborCol, currentDistance}
							table.insert(openLists[islandIndex], currentPoint)
							foundSquare = true
							islandSquaresAdded = islandSquaresAdded + 1
						
						--sort openList with new addition
						table.sort(openLists[islandIndex], function(a, b) return a[3] < b[3] end)
						end
					end
				end
				
				
			
			
		end
	end
	print("added " .. islandSquaresAdded .. " squares of land in this islands map")
	
	
	--loop through islands and set their terrain
	--iterate through generated island points and put down land
	for islandIndex = 1, #closedLists do
		
		--iterate through points on the island
		for islandPointIndex = 1, #closedLists[islandIndex] do
			
			--grab this point and set the terrain
			currentRow = closedLists[islandIndex][islandPointIndex][1]
			currentCol = closedLists[islandIndex][islandPointIndex][2]
			print("placing island " .. islandIndex .. " land square at " .. currentRow .. ", " .. currentCol)
			--set the terrain
			terrainGrid[currentRow][currentCol].terrainType = tt_island_plains
			
		end
		
	end
	
	
	--loop through and smooth the islands to eliminate any ocean holes
	landSmoothingThreshold = 6
	
	for row = 1, gridSize do
		for col = 1, gridSize do
		
			if(terrainGrid[row][col].terrainType == tt_ocean) then
				
				--check the neighbors
				currentNeighbors = Get8Neighbors(row, col, terrainGrid)
				
				currentLandNeighbors = 0
				--iterate through neighbors of this point
				for neighborIndex, neighbor in ipairs(currentNeighbors) do
					
					--check the terrain types of all neighbors, check for ocean terrain type
					currentNeighborRow = neighbor.x 
					currentNeighborCol = neighbor.y 
					
					if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_island_plains) then
						currentLandNeighbors = currentLandNeighbors + 1
					end
				end
				
				if(currentLandNeighbors >= landSmoothingThreshold) then
					terrainGrid[row][col].terrainType = tt_island_plains
				end
			end
		end
	end
	
	--go through islands and set any terrain touching ocean to a beach
	for islandIndex = 1, #closedLists do
		
		--iterate through points on the island
		for islandPointIndex = 1, #closedLists[islandIndex] do
			
			--grab this point
			currentRow = closedLists[islandIndex][islandPointIndex][1]
			currentCol = closedLists[islandIndex][islandPointIndex][2]
			
			--check the neighbors
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
			
			hasOceanNeighbor = false
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				--check the terrain types of all neighbors, check for ocean terrain type
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
					hasOceanNeighbor = true
				end
			end
			
			--if there was at least one ocean neighbor, turn this square into a beach
			beachChance = 0.7
			if(hasOceanNeighbor == true) then
				if(worldGetRandom() < beachChance) then
					terrainGrid[currentRow][currentCol].terrainType = tt_beach
				end
			end
			
		end
		
	end
	
	--go back through islands and set anything inland to regular plains terrain
	--inland defined as squares that don't touch an ocean but are adjacent to a beach or island plains
	inlandPoints = {}
	for islandIndex = 1, #closedLists do
		inlandPoints[islandIndex] = {}
		--iterate through points on the island
		for islandPointIndex = 1, #closedLists[islandIndex] do
			
			--grab this point
			currentRow = closedLists[islandIndex][islandPointIndex][1]
			currentCol = closedLists[islandIndex][islandPointIndex][2]
			
			--check the neighbors
			
			currentNeighbors = GetAllSquaresInRadius(currentRow, currentCol, inlandRadius, terrainGrid)
			
			hasOceanNeighbor = false
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				--check the terrain types of all neighbors, check for ocean terrain type
				currentNeighborRow = neighbor[1] 
				currentNeighborCol = neighbor[2] 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
					hasOceanNeighbor = true
				end
			end
			
			if(hasOceanNeighbor == false) then
				
				if((currentRow > 1+playerEdgeGap and currentRow < (#terrainGrid - playerEdgeGap)) and (currentCol > 1+playerEdgeGap and currentCol < (#terrainGrid - playerEdgeGap))) then

					inlandPoint = {}
					inlandPoint = {currentRow, currentCol}
					
					table.insert(inlandPoints[islandIndex], inlandPoint)
				end
				
				--terrainGrid[currentRow][currentCol].terrainType = tt_plains
			end
			
			--make beaches only the outer island edge
			currentNeighbors = GetAllSquaresInRadius(currentRow, currentCol, 1.75, terrainGrid)
			
			hasOceanNeighbor = false
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				--check the terrain types of all neighbors, check for ocean terrain type
				currentNeighborRow = neighbor[1] 
				currentNeighborCol = neighbor[2] 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
					hasOceanNeighbor = true
				end
			end
			
			if(hasOceanNeighbor == false) then
				terrainGrid[currentRow][currentCol].terrainType = tt_plains
			end
			
		end
		
	end
	
	
	--change beach squares into cliffs based on the cliffChance parameter
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if(terrainGrid[row][col].terrainType == tt_beach) then
				currentPlayerNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, 2, 2, {playerStartTerrain}, terrainGrid)
				
				if(#currentPlayerNeighbors == 0 and worldGetRandom() < cliffChance) then
					--add in some cliffs on top of beach squares to make areas of cliffs going into the ocean for island defence 
					terrainGrid[row][col].terrainType = tt_plateau_low
					currentFlatNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_plains}, terrainGrid)
					currentBeachNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_beach}, terrainGrid)
					if(#currentFlatNeighbors > 0) then
						chosenIndex = math.ceil(worldGetRandom() * #currentFlatNeighbors)
						--put a rolling hill beside the cliff to be able to get up from the island interior
						terrainGrid[currentFlatNeighbors[chosenIndex][1]][currentFlatNeighbors[chosenIndex][2]].terrainType = tt_hills_med_rolling
					end
					
					if(#currentBeachNeighbors > 0) then
						chosenIndex = math.ceil(worldGetRandom() * #currentBeachNeighbors)
						
						terrainGrid[currentBeachNeighbors[chosenIndex][1]][currentBeachNeighbors[chosenIndex][2]].terrainType = tt_plateau_low
					end
				end
			end
		end
	end
	
	
	--loop through and place player starts
	
	
	--find furthest points for each team per island
	islandPlayerStarts = {}
	
	--loop through and assign starts
	for teamIndex = 1, #teamMappingTable do
		print("for team " .. teamIndex .. ", there are " .. #inlandPoints[teamIndex] .. " inland island points")
		islandPlayerStarts = GetFurthestStarts(#teamMappingTable[teamIndex].players, minPlayerDistance, inlandPoints[teamIndex], terrainGrid)
		for teamPlayerIndex = 1, #teamMappingTable[teamIndex].players do
			currentRow = islandPlayerStarts[teamPlayerIndex][1]
			currentCol = islandPlayerStarts[teamPlayerIndex][2]
			terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
			currentPlayerID = teamMappingTable[teamIndex].players[teamPlayerIndex].playerID
			terrainGrid[currentRow][currentCol].playerIndex = currentPlayerID - 1
			--you must assign player IDs to the starting squares, starting at player 0 (matches the game setup screen)
			print("player " .. currentPlayerID .. " placed at " .. currentRow .. ", " .. currentCol)
			--add buffer terrain around the player start to make sure the players don't have their capital on the coastline
			bufferSquares = GetAllSquaresInRingAroundSquare(currentRow, currentCol, startBufferRadius, startBufferRadius, terrainGrid)
			for bIndex = 1, #bufferSquares do
				row = bufferSquares[bIndex][1]
				col = bufferSquares[bIndex][2]
				
				if (terrainGrid[row][col].terrainType ~= playerStartTerrain) then
					
					--check the neighbors
					currentNeighbors = GetNeighbors(row, col, terrainGrid)
					
					hasOceanNeighbor = false
					--iterate through neighbors of this point
					for neighborIndex, neighbor in ipairs(currentNeighbors) do
						
						--check the terrain types of all neighbors, check for ocean terrain type
						currentNeighborRow = neighbor.x 
						currentNeighborCol = neighbor.y 
						
						if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
							hasOceanNeighbor = true
						end
					end
					
				--	if(hasOceanNeighbor == true) then
				--		terrainGrid[row][col].terrainType = tt_beach
				--	else
						terrainGrid[row][col].terrainType = tt_hills_gentle_rolling
				--	end
					
					
					
				end
				
			end
			
		end
		
	end

	
	--fill inland with interesting terrain
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if(terrainGrid[row][col].terrainType == tt_plains) then
				currentPlayerNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, 4, 4, {playerStartTerrain}, terrainGrid)
				--randomly add in some mountains on the islands
				if(#currentPlayerNeighbors == 0 and worldGetRandom() < inlandTerrainChance) then
					terrainRoll = math.ceil(worldGetRandom() * #inlandTerrain)
					currentTerrain = inlandTerrain[terrainRoll]
					terrainGrid[row][col].terrainType = currentTerrain
			--	elseif(#currentPlayerNeighbors == 0 and worldGetRandom() < forestChance) then
				elseif(#currentPlayerNeighbors == 0) then
					terrainGrid[row][col].terrainType = tt_impasse_trees_plains_naval
				end
			end
			
			if(terrainGrid[row][col].terrainType == tt_island_plains) then
				terrainGrid[row][col].terrainType = tt_beach
			end
		end
	end
end

-- @param teamTable is a teamMappingTable variable
-- the functions shuffles the indexes of players within a specific team.
-- this function can be used to randomise positions of players in a team if called before another function that places players based on their indexes.
-- Fisher-Yates shuffle method
function ShuffleTeamIndexes(teamTable)
	for i = #teamTable.players, 2, -1 do
		local j = math.ceil(worldGetRandom() * i)
		teamTable.players[i], teamTable.players[j] = teamTable.players[j], teamTable.players[i]
	end
end

-- this function shuffles player indexes across all teams.
function ShuffleAllTeamsIndexes(teamMappingTable)
	for i = 1, #teamMappingTable do
		ShuffleTeamIndexes(teamMappingTable[i])
	end
end

-- this funtion shuffles player start positions 
function ShuffleStartPositions(terrainGrid, playerSpawnPositionLists)
  for i = #playerSpawnPositionLists, 2, -1 do
    local j = math.ceil(worldGetRandom() * i)
	rowI = playerSpawnPositionLists[i][1]
	colI = playerSpawnPositionLists[i][2]
	rowJ = playerSpawnPositionLists[j][1]
	colJ = playerSpawnPositionLists[j][2]
	terrainGrid[rowI][colI], terrainGrid[rowJ][colJ] = terrainGrid[rowJ][colJ], terrainGrid[rowI][colI]
  end
end

--this function creates a series of equally sized islands, with island grouping done by the standard player spawn algorithm
function CreateIslandsTeamsApartEven(islandSize, equalIslandNum, totalIslandNum, distanceBetweenIslands, edgeBuffer, innerExclusion, inlandRadius, islandGap, teamMappingTable, playerStartTerrain, startBufferRadius, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, minTeamDistance, minPlayerDistance, impasseTypes, impasseDistance, topSelectionThreshold, playerEdgeGap, terrainGrid, randomSpawnLocations)
	
	--find island starting points according to teams
	teamMappingTable = GetStartLocations(teamMappingTable, minTeamDistance, minPlayerDistance, playerEdgeGap, innerExclusion, impasseTypes, impasseDistance, topSelectionThreshold, terrainGrid)
	
	-- shuffling all player indexes to guarantee random positions
	ShuffleAllTeamsIndexes(teamMappingTable)
	
	--create a list of all viable start locations
	openList = {}
	
	currentMinPlayerDistance = minPlayerDistance
	currentMinTeamDistance = minTeamDistance
	
	playerSpaceShrinking = 0.2
	teamSpaceShrinking = 0.2
	
	halfInnerExclusion = innerExclusion / 2
	halfGridSize = Round(#terrainGrid / 2, 0)
	minInnerExclusion = Round(((0.5 - halfInnerExclusion) * #terrainGrid), 0)
	maxInnerExclusion = Round(((0.5 + halfInnerExclusion) * #terrainGrid), 0)
	
	print("inner exclusion zone from " .. minInnerExclusion .. " to " .. maxInnerExclusion)
	
	
	preStartTerrainTable = DeepCopy(terrainGrid)
	
	::restartPlayerPlacement::
	
	if(currentMinPlayerDistance < 0) then
		currentMinPlayerDistance = minPlayerDistance	
	end
	
	if(currentMinTeamDistance < 0) then
		currentMinTeamDistance = minTeamDistance + 1
	end
	
	print("current min player distance: " .. currentMinPlayerDistance .. ", current min team distance: " .. currentMinTeamDistance)
	
	--fill the open list
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			--check if the current terrain square is a valid square (not impasse)
			isValidTerrain = true
	--		print("checking row " .. row .. ", col " .. col)
			--check for in bounds of edgeBuffer and inner exclusion
			if(((row > minInnerExclusion) and (row <= maxInnerExclusion)) and ((col > minInnerExclusion) and (col <= maxInnerExclusion))) then
				print("coordinate " .. row .. ", " .. col .. " is within the exclusion zone")
				isValidTerrain = false
			elseif((row < 1+edgeBuffer or row > (#terrainGrid - edgeBuffer)) or (col < 1+edgeBuffer or col > (#terrainGrid - edgeBuffer))) then
				print("coordinate " .. row .. ", " .. col .. " is outside the ring of acceptable starting donut terrain")
				isValidTerrain = false
			end
			
			for impasseCheckRow = 1, gridSize do
				for impasseCheckCol = 1, gridSize do
					--check to see if this square is within impasseDistance
					currentDistance = GetDistance(row, col, impasseCheckRow, impasseCheckCol, 2)
					if(currentDistance <= impasseDistance) then
						currentTerrainType = terrainGrid[impasseCheckRow][impasseCheckCol].terrainType
						for terrainTypeIndex = 1, #impasseTypes do
							if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
								isValidTerrain = false
							end
						end
					end
					
				end
			end
			
			--if the current square is not impasse, add it to the list
			currentInfo = {}
			if(isValidTerrain == true) then
				currentInfo = {row, col}
				table.insert(openList, currentInfo)
			end
		end
	end
	
	--find evenly spaced out players
	closedSquares = {}
		
	closedSquares = GetEvenlySpacedSquares(openList, worldPlayerCount, currentMinPlayerDistance)
	
	--fill teamMappingTable from even squares
	currentClosedIndex = 1
	for teamIndex = 1, #teamMappingTable do
		for playerIndex = 1, #teamMappingTable[teamIndex].players do
		
			currentClosedRow = closedSquares[currentClosedIndex][1]
			currentClosedCol = closedSquares[currentClosedIndex][2]
			
			teamMappingTable[teamIndex].players[playerIndex].startRow = currentClosedRow
			teamMappingTable[teamIndex].players[playerIndex].startCol = currentClosedCol
			
			currentClosedIndex = currentClosedIndex + 1
		end
	end
	
	--fill all equal islands
	islandPoints = {}
	
	local function Table_ContainsCoordinate(table, value)

		tableHasCoord = false
		
		for index, val in ipairs(table) do
			if (val[1] == value[1] and val[2] == value[2]) then
				tableHasCoord = true
			end
		end
		
		return tableHasCoord
	end
	
	--calculate how many max iterations of land expansion to do
	gridSize = #terrainGrid
	totalGridSquares = gridSize * gridSize
	islandSquaresAdded = 0
	
	halfInnerExclusion = innerExclusion / 2
	halfGridSize = Round(#terrainGrid / 2, 0)
	minInnerExclusion = Round(((0.5 - halfInnerExclusion) * #terrainGrid), 0)
	maxInnerExclusion = Round(((0.5 + halfInnerExclusion) * #terrainGrid), 0)
	
	--set up open and closed lists for each equal island
	openLists = {}
	closedLists = {}
	
	--make a list of all starting points
	startingPoints = {}
	for teamIndex = 1, #teamMappingTable do
		
		for teamPlayerIndex = 1, #teamMappingTable[teamIndex].players do
			currentRow = teamMappingTable[teamIndex].players[teamPlayerIndex].startRow
			currentCol = teamMappingTable[teamIndex].players[teamPlayerIndex].startCol
			currentData = {}
			currentData = {currentRow, currentCol}
			table.insert(startingPoints, currentData)
		end
		
	end
	
	for i = 1, equalIslandNum do
		openLists[i] = {}
		closedLists[i] = {}
		
		--add starting points into each island's openList
		currentPoint = {startingPoints[i][1], startingPoints[i][2]}
		table.insert(openLists[i], currentPoint)
	end
	
	--base case: place initial island points and create their starting open lists
	for i = 1, equalIslandNum do
		
		--add each island's starting point to their respective closed lists, and remove it from the island's openList
		currentStartPoint = openLists[i][1]
		print("placing island " .. i .. "'s start point at " .. currentStartPoint[1] .. ", " .. currentStartPoint[2])
		table.insert(closedLists[i], currentStartPoint)
		table.remove(openLists[i], 1)
	end
		
	--base case (cont'd):
	--go back and use the single closed list point to generate potential starting neighbors for each island's initial openList
	--constrained so that each entry in the open list is within the constraints of island and edge proximity
	for i = 1, equalIslandNum do
		
		currentOpenSquare = closedLists[i][1]
		
		currentRow = currentOpenSquare[1]
		currentCol = currentOpenSquare[2]
		print("generating potential neighbors of " .. currentRow .. ", " .. currentCol)
		--get the neighbors of this current square
		currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
		
		--iterate through neighbors of this point
		for neighborIndex, neighbor in ipairs(currentNeighbors) do
			
			isInBounds = false
			currentNeighborRow = neighbor.x 
			currentNeighborCol = neighbor.y 
			print("current neighbor " .. neighborIndex .. " of " .. currentRow .. ", " .. currentCol .. " is " .. currentNeighborRow .. ", " .. currentNeighborCol)
			closestIslandDistance = 10000
			--check the current neighbors for proximity constraints
			--if they are within parameters, add them to the open list
			--check for edge proximity
			if((currentNeighborRow > edgeBuffer and currentNeighborRow <= (gridSize - edgeBuffer)) and (currentNeighborCol > edgeBuffer and currentNeighborCol <= (gridSize - edgeBuffer))) then
				
				--check for other island proximity
				--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
				--also make sure there is more than 1 island
				if(equalIslandNum > 1) then
					for islandIndex = 1, equalIslandNum do
						--don't search the current island
						if(islandIndex ~= i) then
							
							--make sure this island has a closed list with any elements
							if(#closedLists[islandIndex] > 0) then
								
								--loop through this island's closed list and calculate distances to the current potential openList neighbor
								for closedListIndex = 1, #closedLists[islandIndex] do
									
									currentClosedRow = closedLists[islandIndex][closedListIndex][1]
									currentClosedCol = closedLists[islandIndex][closedListIndex][2]
									
									currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
									print("current closed distance check is " .. currentClosedDistance)
									--see if this distance is the new smallest distance
									if(currentClosedDistance < closestIslandDistance) then
										closestIslandDistance = currentClosedDistance
									end
								end
							end
						end
					end
				end
				
				--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
				if(closestIslandDistance >= distanceBetweenIslands) then
					isInBounds = true
				end
				
			else
				print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is out of accepted bounds")
			end
			
			
			--check if the neighbor is within bounding box
			if(((currentNeighborRow > minInnerExclusion) and (currentNeighborRow <= maxInnerExclusion)) and ((currentNeighborCol > minInnerExclusion) and (currentNeighborCol <= maxInnerExclusion))) then
				print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is within the exclusion zone")
				isInBounds = false
			elseif((currentNeighborRow < 1+edgeBuffer or currentNeighborRow > (#terrainGrid - edgeBuffer)) or (currentNeighborCol < 1+edgeBuffer or currentNeighborCol > (#terrainGrid - edgeBuffer))) then
				print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is outside the ring of acceptable starting donut terrain")
				isInBounds = false
			end
			
			--check to ensure there is no impasse within impasse distance
			currentImpasseNeighbors = GetAllSquaresInRadius(currentNeighborRow, currentNeighborCol, impasseDistance, terrainGrid)
			
			for neighborIndex, neighbor in ipairs(currentImpasseNeighbors) do
				currentImpasseNeighborRow = neighbor[1] 
				currentImpasseNeighborCol = neighbor[2]
				isImpasse = false
				for impasseTypeIndex = 1, #impasseTypes do
					
					if(terrainGrid[currentImpasseNeighborRow][currentImpasseNeighborCol].terrainType == impasseTypes[impasseTypeIndex]) then
						isImpasse = true
					end
				end
				if isImpasse == true then
					isInBounds = false
				end
			end
			
			--if the neighbor is within constraints, add it to the openList
			if(isInBounds == true) then
				currentPoint = {currentNeighborRow, currentNeighborCol}
				print("adding neighbor to openList at " .. currentNeighborRow .. ", " .. currentNeighborCol)
				table.insert(openLists[i], currentPoint)
			end
		end
	end
	
	
	currentIsland = 1
	
	--place number of land squares based on overall land coverage calculated
	for i = 1, islandSize do
		for islandIndex = 1, equalIslandNum do
			foundSquare = false 
			
				--check to make sure there is an entry in the open list for this island
				if(#openLists[islandIndex] > 0) then
					
					--constrained so that each entry in the open list is within the constraints of island and edge proximity
					currentOpenSquareNum = math.ceil(worldGetRandom() * #openLists[islandIndex])
					currentOpenSquare = openLists[islandIndex][currentOpenSquareNum]
					
					currentRow = currentOpenSquare[1]
					currentCol = currentOpenSquare[2]
					
					--get the neighbors of this current square
					currentNeighbors = GetNeighbors(currentOpenSquare[1], currentOpenSquare[2], terrainGrid)
					
					--remove the current open square from the open list and add it to the closed list
					table.remove(openLists[islandIndex], currentOpenSquareNum)
					table.insert(closedLists[islandIndex], currentOpenSquare)
					
					
					--iterate through neighbors of this point
					for neighborIndex, neighbor in ipairs(currentNeighbors) do
						
						isInBounds = false
						currentNeighborRow = neighbor.x 
						currentNeighborCol = neighbor.y 
						
						closestIslandDistance = 10000
						--check the current neighbors for proximity constraints
						--if they are within parameters, add them to the open list
						--check for edge proximity
						if((currentNeighborRow > edgeBuffer and currentNeighborRow <= (gridSize - edgeBuffer)) and (currentNeighborCol > edgeBuffer and currentNeighborCol <= (gridSize - edgeBuffer))) then
							
							--check for other island proximity
							--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
							--also make sure there is more than 1 island
							if(equalIslandNum > 1) then
								for islandCheckIndex = 1, equalIslandNum do
									--don't search the current island
									if(islandCheckIndex ~= islandIndex) then
										
										--make sure this island has a closed list with any elements
										if(#closedLists[islandCheckIndex] > 0) then
											
											--loop through this island's closed list and calculate distances to the current potential openList neighbor
											for closedListIndex = 1, #closedLists[islandCheckIndex] do
												
												currentClosedRow = closedLists[islandCheckIndex][closedListIndex][1]
												currentClosedCol = closedLists[islandCheckIndex][closedListIndex][2]
												
												currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
												
												--see if this distance is the new smallest distance
												if(currentClosedDistance < closestIslandDistance) then
													closestIslandDistance = currentClosedDistance
												end
											end
										end
									end
								end
							end
							
							--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
							if(closestIslandDistance >= distanceBetweenIslands) then
								--make sure the element is not already in the open or closed list
								if(Table_ContainsCoordinate(closedLists[islandIndex], {currentNeighborRow, currentNeighborCol}) == false and Table_ContainsCoordinate(openLists[islandIndex], {currentNeighborRow, currentNeighborCol}) == false) then
									isInBounds = true
								end
							end
							
						end
						
						--check if the neighbor is within bounding box
						if(((currentNeighborRow > minInnerExclusion) and (currentNeighborRow <= maxInnerExclusion)) and ((currentNeighborCol > minInnerExclusion) and (currentNeighborCol <= maxInnerExclusion))) then
							print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is within the exclusion zone")
							isInBounds = false
						elseif((currentNeighborRow < 1+edgeBuffer or currentNeighborRow > (#terrainGrid - edgeBuffer)) or (currentNeighborCol < 1+edgeBuffer or currentNeighborCol > (#terrainGrid - edgeBuffer))) then
							print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is outside the ring of acceptable starting donut terrain")
							isInBounds = false
						end
					
						--check to ensure there is no impasse within impasse distance
						currentImpasseNeighbors = GetAllSquaresInRadius(currentNeighborRow, currentNeighborCol, impasseDistance, terrainGrid)
						
						for neighborIndex, neighbor in ipairs(currentImpasseNeighbors) do
							currentImpasseNeighborRow = neighbor[1] 
							currentImpasseNeighborCol = neighbor[2]
							isImpasse = false
							for impasseTypeIndex = 1, #impasseTypes do
								
								if(terrainGrid[currentImpasseNeighborRow][currentImpasseNeighborCol].terrainType == impasseTypes[impasseTypeIndex]) then
									isImpasse = true
								end
							end
							if isImpasse == true then
								isInBounds = false
							end
						end
						
						--if the neighbor is within constraints, add it to the openList
						if(isInBounds == true) then
							currentPoint = {currentNeighborRow, currentNeighborCol}
							table.insert(openLists[islandIndex], currentPoint)
							foundSquare = true
							islandSquaresAdded = islandSquaresAdded + 1
						end
					end
				end
				
				
			
		end
	end
	print("added " .. islandSquaresAdded .. " squares of land in this islands map")
	
	
	--loop through islands and set their terrain
	--iterate through generated island points and put down land
	for islandIndex = 1, #closedLists do
		
		--iterate through points on the island
		for islandPointIndex = 1, #closedLists[islandIndex] do
			
			--grab this point and set the terrain
			currentRow = closedLists[islandIndex][islandPointIndex][1]
			currentCol = closedLists[islandIndex][islandPointIndex][2]
			print("placing island land square at " .. currentRow .. ", " .. currentCol)
			--set the terrain
			terrainGrid[currentRow][currentCol].terrainType = tt_island_plains
			
		end
		
	end
	
	
	--loop through and smooth the islands to eliminate any ocean holes
	landSmoothingThreshold = 6
	
	for row = 1, gridSize do
		for col = 1, gridSize do
		
			if(terrainGrid[row][col].terrainType == tt_ocean) then
				
				--check the neighbors
				currentNeighbors = Get8Neighbors(row, col, terrainGrid)
				
				currentLandNeighbors = 0
				--iterate through neighbors of this point
				for neighborIndex, neighbor in ipairs(currentNeighbors) do
					
					--check the terrain types of all neighbors, check for ocean terrain type
					currentNeighborRow = neighbor.x 
					currentNeighborCol = neighbor.y 
					
					if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_island_plains) then
						currentLandNeighbors = currentLandNeighbors + 1
					end
				end
				
				if(currentLandNeighbors >= landSmoothingThreshold) then
					terrainGrid[row][col].terrainType = tt_island_plains
				end
			end
		end
	end
	
	--go through islands and set any terrain touching ocean to a beach
	for islandIndex = 1, #closedLists do
		
		--iterate through points on the island
		for islandPointIndex = 1, #closedLists[islandIndex] do
			
			--grab this point
			currentRow = closedLists[islandIndex][islandPointIndex][1]
			currentCol = closedLists[islandIndex][islandPointIndex][2]
			
			--check the neighbors
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
			
			hasOceanNeighbor = false
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				--check the terrain types of all neighbors, check for ocean terrain type
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
					hasOceanNeighbor = true
				end
			end
			
			--if there was at least one ocean neighbor, turn this square into a beach
			beachChance = 0.7
			if(hasOceanNeighbor == true) then
				if(worldGetRandom() < beachChance) then
					terrainGrid[currentRow][currentCol].terrainType = tt_beach
				end
			end
			
		end
		
	end
	
	--go back through islands and set anything inland to regular plains terrain
	--inland defined as squares that don't touch an ocean but are adjacent to a beach or island plains
	for islandIndex = 1, #closedLists do
		
		--iterate through points on the island
		for islandPointIndex = 1, #closedLists[islandIndex] do
			
			--grab this point
			currentRow = closedLists[islandIndex][islandPointIndex][1]
			currentCol = closedLists[islandIndex][islandPointIndex][2]
			
			--check the neighbors
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
			
			hasOceanNeighbor = false
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				--check the terrain types of all neighbors, check for ocean terrain type
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean or terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean_deep) then
					hasOceanNeighbor = true
				end
			end
			
			if(hasOceanNeighbor == false) then
				terrainGrid[currentRow][currentCol].terrainType = tt_plains
			end
			
		end
		
	end
	
	inlandPoints = {}
	for islandIndex = 1, #closedLists do
		inlandPoints[islandIndex] = {}
		--iterate through points on the island
		for islandPointIndex = 1, #closedLists[islandIndex] do
			
			--grab this point
			currentRow = closedLists[islandIndex][islandPointIndex][1]
			currentCol = closedLists[islandIndex][islandPointIndex][2]
			
			--check the neighbors
			
			currentNeighbors = GetAllSquaresInRadius(currentRow, currentCol, inlandRadius, terrainGrid)
			
			hasOceanNeighbor = false
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				--check the terrain types of all neighbors, check for ocean terrain type
				currentNeighborRow = neighbor[1] 
				currentNeighborCol = neighbor[2] 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean or terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean_deep) then
					hasOceanNeighbor = true
				end
			end
			
			if(hasOceanNeighbor == false) then
				
				if((currentRow > 1+playerEdgeGap and currentRow < (#terrainGrid - playerEdgeGap)) and (currentCol > 1+playerEdgeGap and currentCol < (#terrainGrid - playerEdgeGap))) then

					inlandPoint = {}
					inlandPoint = {currentRow, currentCol}
					
					table.insert(inlandPoints[islandIndex], inlandPoint)
				end
				
			end
			
			
		end
		
	end
	
	
	
	--change beach squares into cliffs based on the cliffChance parameter
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if(terrainGrid[row][col].terrainType == tt_beach) then
				currentPlayerNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, 2, 2, {playerStartTerrain}, terrainGrid)
				
				if(#currentPlayerNeighbors == 0 and worldGetRandom() < cliffChance) then
					--add in some cliffs on top of beach squares to make areas of cliffs going into the ocean for island defence 
					terrainGrid[row][col].terrainType = tt_plateau_low
					currentFlatNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_plains}, terrainGrid)
					currentBeachNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_beach}, terrainGrid)
					if(#currentFlatNeighbors > 0) then
						chosenIndex = math.ceil(worldGetRandom() * #currentFlatNeighbors)
						--put a rolling hill beside the cliff to be able to get up from the island interior
						terrainGrid[currentFlatNeighbors[chosenIndex][1]][currentFlatNeighbors[chosenIndex][2]].terrainType = tt_hills_med_rolling
					end
					
					if(#currentBeachNeighbors > 0) then
						chosenIndex = math.ceil(worldGetRandom() * #currentBeachNeighbors)
						
						terrainGrid[currentBeachNeighbors[chosenIndex][1]][currentBeachNeighbors[chosenIndex][2]].terrainType = tt_plateau_low
					end
				end
			end
		end
	end
	
	--players start positions
	playerSpawnPositionLists = {}
	
	currentIsland = 1
	--loop through and place player starts
	for teamIndex = 1, #teamMappingTable do
		
		for teamPlayerIndex = 1, #teamMappingTable[teamIndex].players do
			print("number of inland points on island " .. currentIsland .. " is " .. #inlandPoints[currentIsland])
			--[[
			if(#inlandPoints[currentIsland] > 0) then
				print("number of inland points on island " .. currentIsland .. " is " .. #inlandPoints[currentIsland])
				randomIndex = math.ceil(worldGetRandom() * #inlandPoints[currentIsland])
				currentRow = inlandPoints[currentIsland][randomIndex][1]
				currentCol = inlandPoints[currentIsland][randomIndex][2]
			else
				print("no inland island points")
				currentRow = teamMappingTable[teamIndex].players[teamPlayerIndex].startRow
				currentCol = teamMappingTable[teamIndex].players[teamPlayerIndex].startCol
				
			end
			--]]
			--find average island point
			rowTotal = 0
			colTotal = 0
			for islandPoint = 1, #closedLists[currentIsland] do
				
				--grab this point
				currentRow = closedLists[currentIsland][islandPoint][1]
				currentCol = closedLists[currentIsland][islandPoint][2]
				
				rowTotal = rowTotal + currentRow
				colTotal = colTotal + currentCol
			end
			
			rowTotal = Round((rowTotal / #closedLists[currentIsland]), 0)
			colTotal = Round((colTotal / #closedLists[currentIsland]), 0)
			print("average row: " .. rowTotal .. ", average col: " .. colTotal)
			currentRow = rowTotal
			currentCol = colTotal
			currentIsland = currentIsland + 1
			terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
			currentPlayerID = teamMappingTable[teamIndex].players[teamPlayerIndex].playerID
			newPlayerIndex = currentPlayerID - 1
			terrainGrid[currentRow][currentCol].playerIndex = newPlayerIndex
			--store player start positions
			currentPoint = {currentRow, currentCol}
			table.insert(playerSpawnPositionLists, currentPoint)
			--you must assign player IDs to the starting squares, starting at player 0 (matches the game setup screen)
			print("player " .. currentPlayerID .. " placed at " .. currentRow .. ", " .. currentCol)
			--add buffer terrain around the player start to make sure the players don't have their capital on the coastline
			bufferSquares = GetAllSquaresInRingAroundSquare(currentRow, currentCol, startBufferRadius, startBufferRadius, terrainGrid)
			for bIndex = 1, #bufferSquares do
				row = bufferSquares[bIndex][1]
				col = bufferSquares[bIndex][2]
				
				if (terrainGrid[row][col].terrainType ~= playerStartTerrain) then
					
					--check the neighbors
					currentNeighbors = GetNeighbors(row, col, terrainGrid)
					
					hasOceanNeighbor = false
					--iterate through neighbors of this point
					for neighborIndex, neighbor in ipairs(currentNeighbors) do
						
						--check the terrain types of all neighbors, check for ocean terrain type
						currentNeighborRow = neighbor.x 
						currentNeighborCol = neighbor.y 
						
						if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
							hasOceanNeighbor = true
						end
					end
					
				--	if(hasOceanNeighbor == true) then
				--		terrainGrid[row][col].terrainType = tt_beach
				--	else
						terrainGrid[row][col].terrainType = tt_plains_smooth
				--	end
					
					
					
				end
				
			end
			
		end
		
	end

	if (randomSpawnLocations == true) then
		ShuffleStartPositions(terrainGrid, playerSpawnPositionLists)
	end
	
	--fill inland with interesting terrain
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if(terrainGrid[row][col].terrainType == tt_plains) then
				currentPlayerNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, 4, 4, {playerStartTerrain}, terrainGrid)
				--randomly add in some mountains on the islands
				if(#currentPlayerNeighbors == 0 and worldGetRandom() < inlandTerrainChance) then
					terrainRoll = math.ceil(worldGetRandom() * #inlandTerrain)
					currentTerrain = inlandTerrain[terrainRoll]
					terrainGrid[row][col].terrainType = currentTerrain
			--	elseif(#currentPlayerNeighbors == 0 and worldGetRandom() < forestChance) then
				elseif(#currentPlayerNeighbors == 0) then
					terrainGrid[row][col].terrainType = tt_impasse_trees_plains_naval
				end
			end
			
			if(terrainGrid[row][col].terrainType == tt_island_plains) then
				terrainGrid[row][col].terrainType = tt_beach
			end
		end
	end
end


--this function will fill an ocean map with islands, avoiding already placed land
function FillWithIslands(islandSize, equalIslands, totalIslandNum, distanceBetweenIslands, startingEdgeBuffer, edgeBuffer, innerExclusion, islandGap, cliffChance, forestChance, inlandTerrainChance, inlandTerrain, impasseTypes, impasseDistance, specialTerrain, playerStartTerrain, terrainGrid)
	
	
	local function Table_ContainsCoordinate(table, value)

		tableHasCoord = false
		
		for index, val in ipairs(table) do
			if (val[1] == value[1] and val[2] == value[2]) then
				tableHasCoord = true
			end
		end
		
		return tableHasCoord
	end
	
	--calculate how many max iterations of land expansion to do
	gridSize = #terrainGrid
	totalGridSquares = gridSize * gridSize
	islandSquaresAdded = 0
	
	halfInnerExclusion = innerExclusion / 2
	halfGridSize = Round(#terrainGrid / 2, 0)
	minInnerExclusion = Round(((0.5 - halfInnerExclusion) * #terrainGrid), 0)
	maxInnerExclusion = Round(((0.5 + halfInnerExclusion) * #terrainGrid), 0)
	
	islandClosedLists = {}
	
	originalIslandSize = islandSize
	
	specialIslandPoints = {}
	
	for row = 1, gridSize do
		for col = 1, gridSize do
		
			if(terrainGrid[row][col].terrainType == playerStartTerrain) then
				currentPoint = {}
				currentPoint = {row, col}
				table.insert(specialIslandPoints, currentPoint)
			end
			
		end
	end
	
	for islandIndex = 1, totalIslandNum do
		
		openList = {}
		beachSquares = {}
		
		
		--part of the script where we grab a snapshot of the current grid and record the beach squares that exist
		--grab every second square for optimization
		canRecordSquare = true
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				if(terrainGrid[row][col].terrainType == tt_beach) then
					currentPoint = {}
					currentPoint = {row, col}
					table.insert(beachSquares, currentPoint)
				end
				
				if(canRecordSquare == true) then
					
					isInBounds = false
					
					
					--check if the neighbor is within bounding box
					if(((row > minInnerExclusion) and (row <= maxInnerExclusion)) and ((col > minInnerExclusion) and (col <= maxInnerExclusion))) then
						print("coordinate " .. row .. ", " .. col .. " is within the exclusion zone")
						isInBounds = false
					elseif((row < 1+startingEdgeBuffer or row > (#terrainGrid - startingEdgeBuffer)) or (col < 1+startingEdgeBuffer or col > (#terrainGrid - startingEdgeBuffer))) then
						print("coordinate " .. row .. ", " .. col .. " is outside the ring of acceptable starting donut terrain")
						isInBounds = false
						
					else
						
						--grab all squares within radius of the distanceBetweenIslands and make sure there isn't any land tiles 
						
						currentNeighbors = GetAllSquaresInRadius(row, col, distanceBetweenIslands + 1, terrainGrid)
						
						landNeighbors = 0
						for neighborIndex, neighbor in ipairs(currentNeighbors) do
							
							currentNeighborRow = neighbor[1]
							currentNeighborCol = neighbor[2] 
							--		print("looking at neighbor row " .. currentNeighborRow)
							--		print("looking at neighbor column " .. currentNeighborCol)
							if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType ~= tt_ocean and terrainGrid[currentNeighborRow][currentNeighborCol].terrainType ~= tt_ocean_deep) then
								landNeighbors = landNeighbors + 1
							end
						end
						
						if(landNeighbors == 0) then
							isInBounds = true
						end
					end
					
					if(isInBounds == true) then				
						currentPoint = {}
						currentPoint = {row, col}
						table.insert(openList, currentPoint)
					end
					canRecordSquare = false
					
				else
					canRecordSquare = true
				end
				
			end
		end
		
		print("number of beach squares for starting island " .. islandIndex .. " is " .. #beachSquares .. " and the size of the openList is " .. #openList)
		
		--checks for beach squares, and gets the furthest point, out of available ocean squares, away from all current island edges
		islandStartingPoint = {}
		if(#openList > 0) then
			islandStartingPoint = GetFurthestSquareFromSquares(openList, specialIslandPoints)
			print("new island square, the furthest square from beach squares, found at " .. islandStartingPoint[1] .. ", " .. islandStartingPoint[2])
			table.insert(beachSquares, islandStartingPoint)
			
			
			
			islandOpenList = {}
			islandClosedList = {}
			
			
			--add starting point into island's openList
			currentPoint = {}
			currentPoint = {islandStartingPoint[1], islandStartingPoint[2]}
			table.insert(islandOpenList, currentPoint)
			
			
			--base case: place initial island points and create the starting open list
			
			--add the island's starting point to the respective closed list, and remove it from the island's openList
			currentStartPoint = islandOpenList[1]
			print("placing island " .. islandIndex .. "'s start point at " .. currentStartPoint[1] .. ", " .. currentStartPoint[2])
			table.insert(islandClosedList, currentStartPoint)
			table.remove(islandOpenList, 1)
			
			
			--base case (cont'd):
			--go back and use the single closed list point to generate potential starting neighbors for the island's initial openList
			--constrained so that each entry in the open list is within the constraints of island and edge proximity
			
			currentOpenSquare = islandClosedList[1]
			
			currentRow = currentOpenSquare[1]
			currentCol = currentOpenSquare[2]
			--	print("generating potential neighbors of " .. currentRow .. ", " .. currentCol)
			--get the neighbors of this current square
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
			
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				isInBounds = false
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				--	print("current neighbor " .. neighborIndex .. " of " .. currentRow .. ", " .. currentCol .. " is " .. currentNeighborRow .. ", " .. currentNeighborCol)
				closestIslandDistance = 10000
				--check the current neighbors for proximity constraints
				--if they are within parameters, add them to the open list
				--check for edge proximity
				if((currentNeighborRow > edgeBuffer and currentNeighborRow <= (gridSize - edgeBuffer)) and (currentNeighborCol > edgeBuffer and currentNeighborCol <= (gridSize - edgeBuffer))) then
					
					--check for other island proximity
					
					currentCheckNeighbors = GetAllSquaresInRadius(currentNeighborRow, currentNeighborCol, distanceBetweenIslands, terrainGrid)
					
					landNeighbors = 0
					for neighborIndex, checkNeighbor in ipairs(currentCheckNeighbors) do
						
						currentCheckNeighborRow = checkNeighbor[1] 
						currentCheckNeighborCol = checkNeighbor[2] 
						
						if(terrainGrid[currentCheckNeighborRow][currentCheckNeighborCol].terrainType ~= tt_ocean and terrainGrid[currentCheckNeighborRow][currentCheckNeighborCol].terrainType ~= tt_ocean_deep) then
							landNeighbors = landNeighbors + 1
						end
					end
					
					--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
					if(landNeighbors == 0) then
						isInBounds = true
					end
					
				else
					print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is out of accepted bounds")
				end
				
				
				--check if the neighbor is within bounding box
				if(((currentNeighborRow > minInnerExclusion) and (currentNeighborRow <= maxInnerExclusion)) and ((currentNeighborCol > minInnerExclusion) and (currentNeighborCol <= maxInnerExclusion))) then
					print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is within the exclusion zone")
					isInBounds = false
				elseif((currentNeighborRow < 1+edgeBuffer or currentNeighborRow > (#terrainGrid - edgeBuffer)) or (currentNeighborCol < 1+edgeBuffer or currentNeighborCol > (#terrainGrid - edgeBuffer))) then
					print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is outside the ring of acceptable starting donut terrain")
					isInBounds = false
				end
				
				--if the neighbor is within constraints, add it to the openList
				if(isInBounds == true) then
					currentPoint = {currentNeighborRow, currentNeighborCol}
					print("adding neighbor to openList at " .. currentNeighborRow .. ", " .. currentNeighborCol)
					table.insert(islandOpenList, currentPoint)
				end
			end
			
			
			
			currentIsland = 1
			
			
			--place number of land squares based on overall land coverage calculated
			if(equalIslands == true) then
				
				print("extra island " .. islandIndex .. " size is " .. islandSize)
				for i = 1, islandSize do
					
					foundSquare = false 
					
					--check to make sure there is an entry in the open list for this island
					if(#islandOpenList > 0) then
						
						--constrained so that each entry in the open list is within the constraints of island and edge proximity
						currentOpenSquareNum = math.ceil(worldGetRandom() * #islandOpenList)
						currentOpenSquare = islandOpenList[currentOpenSquareNum]
						
						currentRow = currentOpenSquare[1]
						currentCol = currentOpenSquare[2]
						
						--get the neighbors of this current square
						currentNeighbors = GetNeighbors(currentOpenSquare[1], currentOpenSquare[2], terrainGrid)
						
						--remove the current open square from the open list and add it to the closed list
						table.remove(islandOpenList, currentOpenSquareNum)
						table.insert(islandClosedList, currentOpenSquare)
						
						
						--iterate through neighbors of this point
						for neighborIndex, neighbor in ipairs(currentNeighbors) do
							
							isInBounds = false
							currentNeighborRow = neighbor.x 
							currentNeighborCol = neighbor.y 
							
							closestIslandDistance = 10000
							--check the current neighbors for proximity constraints
							--if they are within parameters, add them to the open list
							
							currentCheckNeighbors = GetAllSquaresInRadius(currentNeighborRow, currentNeighborCol, distanceBetweenIslands, terrainGrid)
							
							landNeighbors = 0
							for neighborIndex, checkNeighbor in ipairs(currentCheckNeighbors) do
								
								currentCheckNeighborRow = checkNeighbor[1] 
								currentCheckNeighborCol = checkNeighbor[2] 
								
								if(terrainGrid[currentCheckNeighborRow][currentCheckNeighborCol].terrainType ~= tt_ocean and terrainGrid[currentCheckNeighborRow][currentCheckNeighborCol].terrainType ~= tt_ocean_deep) then
									
									--ensure that this non-ocean square is not part of the current closed list
									if(Table_ContainsCoordinate(islandClosedList, checkNeighbor)) == false then
										landNeighbors = landNeighbors + 1
									end
									
								end
							end
							
							--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
							if(landNeighbors == 0) then
								if(Table_ContainsCoordinate(islandClosedList, {currentNeighborRow, currentNeighborCol}) == false and Table_ContainsCoordinate(islandOpenList, {currentNeighborRow, currentNeighborCol}) == false) then
									isInBounds = true
								end
							end
							
							--check if the neighbor is within bounding box
							if(((currentNeighborRow > minInnerExclusion) and (currentNeighborRow <= maxInnerExclusion)) and ((currentNeighborCol > minInnerExclusion) and (currentNeighborCol <= maxInnerExclusion))) then
								print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is within the exclusion zone")
								isInBounds = false
							elseif((currentNeighborRow < 1+edgeBuffer or currentNeighborRow > (#terrainGrid - edgeBuffer)) or (currentNeighborCol < 1+edgeBuffer or currentNeighborCol > (#terrainGrid - edgeBuffer))) then
								print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is outside the ring of acceptable starting donut terrain")
								isInBounds = false
							end
							
							--if the neighbor is within constraints, add it to the openList
							if(isInBounds == true) then
								currentPoint = {currentNeighborRow, currentNeighborCol}
								table.insert(islandOpenList, currentPoint)
								foundSquare = true
								islandSquaresAdded = islandSquaresAdded + 1
							end
						end
					end
					
					
					
				end
			else
				
				
				minIslandSize = math.ceil(originalIslandSize * 0.65)
				maxIslandSize = math.ceil(originalIslandSize * 1.25)
				
				islandSize = originalIslandSize
				islandSize = math.ceil(GetRandomInRange(minIslandSize, maxIslandSize))
				
				print("extra island " .. islandIndex .. " size is " .. islandSize)
				for i = 1, islandSize do
					
					foundSquare = false 
					
					--check to make sure there is an entry in the open list for this island
					if(#islandOpenList > 0) then
						
						--constrained so that each entry in the open list is within the constraints of island and edge proximity
						currentOpenSquareNum = math.ceil(worldGetRandom() * #islandOpenList)
						currentOpenSquare = islandOpenList[currentOpenSquareNum]
						
						currentRow = currentOpenSquare[1]
						currentCol = currentOpenSquare[2]
						
						--get the neighbors of this current square
						currentNeighbors = GetNeighbors(currentOpenSquare[1], currentOpenSquare[2], terrainGrid)
						
						--remove the current open square from the open list and add it to the closed list
						table.remove(islandOpenList, currentOpenSquareNum)
						table.insert(islandClosedList, currentOpenSquare)
						
						
						--iterate through neighbors of this point
						for neighborIndex, neighbor in ipairs(currentNeighbors) do
							
							isInBounds = false
							currentNeighborRow = neighbor.x 
							currentNeighborCol = neighbor.y 
							
							closestIslandDistance = 10000
							--check the current neighbors for proximity constraints
							--if they are within parameters, add them to the open list
							
							currentCheckNeighbors = GetAllSquaresInRadius(currentNeighborRow, currentNeighborCol, distanceBetweenIslands, terrainGrid)
							
							landNeighbors = 0
							for neighborIndex, checkNeighbor in ipairs(currentCheckNeighbors) do
								
								currentCheckNeighborRow = checkNeighbor[1] 
								currentCheckNeighborCol = checkNeighbor[2] 
								
								if(terrainGrid[currentCheckNeighborRow][currentCheckNeighborCol].terrainType ~= tt_ocean and terrainGrid[currentCheckNeighborRow][currentCheckNeighborCol].terrainType ~= tt_ocean_deep) then
									
									--ensure that this non-ocean square is not part of the current closed list
									if(Table_ContainsCoordinate(islandClosedList, checkNeighbor)) == false then
										landNeighbors = landNeighbors + 1
									end
									
								end
							end
							
							--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
							if(landNeighbors == 0) then
								if(Table_ContainsCoordinate(islandClosedList, {currentNeighborRow, currentNeighborCol}) == false and Table_ContainsCoordinate(islandOpenList, {currentNeighborRow, currentNeighborCol}) == false) then
									isInBounds = true
								end
							end
							
							--check if the neighbor is within bounding box
							if(((currentNeighborRow > minInnerExclusion) and (currentNeighborRow <= maxInnerExclusion)) and ((currentNeighborCol > minInnerExclusion) and (currentNeighborCol <= maxInnerExclusion))) then
								print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is within the exclusion zone")
								isInBounds = false
							elseif((currentNeighborRow < 1+edgeBuffer or currentNeighborRow > (#terrainGrid - edgeBuffer)) or (currentNeighborCol < 1+edgeBuffer or currentNeighborCol > (#terrainGrid - edgeBuffer))) then
								print("coordinate " .. currentNeighborRow .. ", " .. currentNeighborCol .. " is outside the ring of acceptable starting donut terrain")
								isInBounds = false
							end
							
							--if the neighbor is within constraints, add it to the openList
							if(isInBounds == true) then
								currentPoint = {currentNeighborRow, currentNeighborCol}
								table.insert(islandOpenList, currentPoint)
								foundSquare = true
								islandSquaresAdded = islandSquaresAdded + 1
							end
						end
					end
					
					
					
				end
				
				
			end
			print("added " .. islandSquaresAdded .. " squares of land in this islands map")
			
			
			--loop through island and set the terrain
			
			--iterate through points on the island
			for islandPointIndex = 1, #islandClosedList do
				
				--grab this point and set the terrain
				currentRow = islandClosedList[islandPointIndex][1]
				currentCol = islandClosedList[islandPointIndex][2]
				print("placing island land square at " .. currentRow .. ", " .. currentCol)
				--set the terrain
				terrainGrid[currentRow][currentCol].terrainType = tt_island_plains
				
			end
			
			--loop through the island points and get the average island position to add to specialIslandPoints
			avgRow = 0
			avgCol = 0
			for islandPointIndex = 1, #islandClosedList do
				
				--grab this point 
				currentRow = islandClosedList[islandPointIndex][1]
				currentCol = islandClosedList[islandPointIndex][2]
				--add points
				avgRow = avgRow + currentRow
				avgCol = avgCol + currentCol
			end
			
			avgRow = math.ceil(avgRow / #islandClosedList)
			avgCol = math.ceil(avgCol / #islandClosedList)
			print("this island's average position is " .. avgRow .. ", " .. avgCol)
			newInfo = {}
			newInfo = {avgRow, avgCol}
			table.insert(specialIslandPoints, newInfo)
			
			
			--loop through and smooth the islands to eliminate any ocean holes
			landSmoothingThreshold = 5
			
			for row = 1, gridSize do
				for col = 1, gridSize do
					
					if(terrainGrid[row][col].terrainType == tt_ocean) then
						
						--check the neighbors
						currentNeighbors = Get8Neighbors(row, col, terrainGrid)
						
						currentLandNeighbors = 0
						--iterate through neighbors of this point
						for neighborIndex, neighbor in ipairs(currentNeighbors) do
							
							--check the terrain types of all neighbors, check for ocean terrain type
							currentNeighborRow = neighbor.x 
							currentNeighborCol = neighbor.y 
							
							if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_island_plains) then
								currentLandNeighbors = currentLandNeighbors + 1
							end
						end
						
						if(currentLandNeighbors >= landSmoothingThreshold) then
							terrainGrid[row][col].terrainType = tt_island_plains
						end
					end
				end
			end
			
			--iterate through points on the island and set beach terrain
			for islandPointIndex = 1, #islandClosedList do
				
				--grab this point
				currentRow = islandClosedList[islandPointIndex][1]
				currentCol = islandClosedList[islandPointIndex][2]
				
				--check the neighbors
				currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
				
				hasOceanNeighbor = false
				--iterate through neighbors of this point
				for neighborIndex, neighbor in ipairs(currentNeighbors) do
					
					--check the terrain types of all neighbors, check for ocean terrain type
					currentNeighborRow = neighbor.x 
					currentNeighborCol = neighbor.y 
					
					if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
						hasOceanNeighbor = true
					end
				end
				
				--if there was at least one ocean neighbor, turn this square into a beach
				if(hasOceanNeighbor == true) then
					terrainGrid[currentRow][currentCol].terrainType = tt_beach
					
				end
				
			end
			
			
			
			--go back through islands and set anything inland to regular plains terrain
			--inland defined as squares that don't touch an ocean but are adjacent to a beach or island plains
			
			--iterate through points on the island
			for islandPointIndex = 1, #islandClosedList do
				
				--grab this point
				currentRow = islandClosedList[islandPointIndex][1]
				currentCol = islandClosedList[islandPointIndex][2]
				
				--check the neighbors
				currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
				
				hasOceanNeighbor = false
				--iterate through neighbors of this point
				for neighborIndex, neighbor in ipairs(currentNeighbors) do
					
					--check the terrain types of all neighbors, check for ocean terrain type
					currentNeighborRow = neighbor.x 
					currentNeighborCol = neighbor.y 
					
					if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == tt_ocean) then
						hasOceanNeighbor = true
					end
				end
				
				if(hasOceanNeighbor == false) then
					terrainGrid[currentRow][currentCol].terrainType = tt_plains
				end
				
			end
			
			
			
			--change beach squares into cliffs based on the cliffChance parameter
			for row = 1, gridSize do
				for col = 1, gridSize do
					
					if(terrainGrid[row][col].terrainType == tt_beach) then
						currentPlayerNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 2, 2, {playerStartTerrain}, terrainGrid)
						
						if(#currentPlayerNeighbors == 0 and worldGetRandom() < cliffChance) then
							--add in some cliffs on top of beach squares to make areas of cliffs going into the ocean for island defence 
							terrainGrid[row][col].terrainType = tt_plateau_low
							currentFlatNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 1, 1, {tt_plains}, terrainGrid)
							currentBeachNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 1, 1, {tt_beach}, terrainGrid)
							if(#currentFlatNeighbors > 0) then
								chosenIndex = math.ceil(worldGetRandom() * #currentFlatNeighbors)
								--put a rolling hill beside the cliff to be able to get up from the island interior
								terrainGrid[currentFlatNeighbors[chosenIndex][1]][currentFlatNeighbors[chosenIndex][2]].terrainType = tt_hills_med_rolling
							end
							
							if(#currentBeachNeighbors > 0) then
								chosenIndex = math.ceil(worldGetRandom() * #currentBeachNeighbors)
								
								terrainGrid[currentBeachNeighbors[chosenIndex][1]][currentBeachNeighbors[chosenIndex][2]].terrainType = tt_plateau_low
							end
						end
					end
				end
			end
			
			--fill inland with interesting terrain
			for row = 1, gridSize do
				for col = 1, gridSize do
					
					if(terrainGrid[row][col].terrainType == tt_plains) then
						currentPlayerNeighbors = GetAllSquaresOfTypeInRingAroundSquare(currentRow, currentCol, 4, 4, {playerStartTerrain}, terrainGrid)
						--randomly add in some mountains on the islands
						if(#currentPlayerNeighbors == 0 and worldGetRandom() < inlandTerrainChance) then
							terrainRoll = math.ceil(worldGetRandom() * #inlandTerrain)
							currentTerrain = inlandTerrain[terrainRoll]
							terrainGrid[row][col].terrainType = currentTerrain
						elseif(#currentPlayerNeighbors == 0 and worldGetRandom() < forestChance) then
							terrainGrid[row][col].terrainType = tt_impasse_trees_plains_naval
						end
					end
					
					if(terrainGrid[row][col].terrainType == tt_island_plains) then
						terrainGrid[row][col].terrainType = tt_beach
					end
				end
			end
			
			--iterate through generated island points and ensure that there is a feature on the island
			
			--grab this point and set the terrain
			currentRow = islandClosedList[1][1]
			currentCol = islandClosedList[1][2]
			print("placing special land square at " .. currentRow .. ", " .. currentCol)
			
			if(#specialTerrain > 0) then
				specialTerrainChoiceIndex = math.ceil(worldGetRandom() * #specialTerrain)
				specialTerrainChoice = specialTerrain[specialTerrainChoiceIndex]
				print("chose special terrain index " .. specialTerrainChoiceIndex)
				
				terrainGrid[currentRow][currentCol].terrainType = specialTerrainChoice
			end
			
			table.insert(islandClosedLists, islandClosedList)
		end
		
	end
	
	return islandClosedLists
	
end


--returns teamMappingTable. You need this to use in conjunction with the placePlayerStarts function
--teamMappingTable is a table containing lists of all teams, with the players assigned to them and their player IDs 
function CreateTeamMappingTable()
	
	--grab team information
	teamsList, playersPerTeam = SetUpTeams()
	
	teamMappingTable = {}

	--playersPerTeam is a list containing how many players are on each team
	numTeams = #teamsList
	
	
	for i = 1, numTeams do
	   teamMappingTable[i] = {}
	   teamMappingTable[i].teamID = teamsList[i]
	   teamMappingTable[i].players = {}
	end
	
	--alright, alright, alright, let's see what we've got
	--Players. Bring a keyboard.
	highestTeam = 0
	for index = 1, #playerTeams do
		print("player " .. index .. " is on team " .. playerTeams[index] .. " in playerTeams")
		
		--loop through teamMappingTable and add this player to the player table on the appropriate team
		for i = 1, #teamMappingTable do
			
			if(teamMappingTable[i].teamID == playerTeams[index]) then
				currentPlayer = {}
				currentPlayer.playerID = index 
				table.insert(teamMappingTable[i].players, currentPlayer)
			end
		end
		if(playerTeams[index] > highestTeam) then
			highestTeam = playerTeams[index]
		end
	end
	
	--teamMappingTable should now have all players and their playerIDs on the correct teams
	--loop and print teamMappingTable
	for teamIndex = 1, #teamMappingTable do
		for playerIndex = 1, #teamMappingTable[teamIndex].players do
			
			print("playerID " .. teamMappingTable[teamIndex].players[playerIndex].playerID .. " is on team " ..  teamMappingTable[teamIndex].teamID)
		end
		
		teamMappingTable[teamIndex].playerCount = #teamMappingTable[teamIndex].players
	end
	
	
	--sort teamMappingTable on how large the teams are
	
	
	highestTeam = highestTeam + 1
	
	teamIndexTable = {}
	--make an empty table for each team
	for index = 1, highestTeam do
		teamIndexTable[index] = {}
	end
	
	
	--now loop through all players and add them to the correct team tables
	for index = 1, #playerTeams do -- loop through every player in the player teams table
		
		currentPlayerTeam = playerTeams[index]+1
		table.insert(teamIndexTable[currentPlayerTeam], index)
	end
	
	--loop and debug output the teamIndexTable
	for i = 1, #teamIndexTable do
		print("looking at team " .. i)
		for j = 1, #teamIndexTable[i] do
			currentPlayer = teamIndexTable[i][j]
			print("team index table: index " .. i .. ": player " .. currentPlayer)
			teamIndexTable[i].playerCount = #teamIndexTable[i]
		end
	end
	
	for i = #teamIndexTable, 1, -1 do
		if #teamIndexTable[i] == 0 then
			table.remove(teamIndexTable, i)
		end
	end
	
	--sorts the teamIndexTable based on size of teams
	table.sort(teamIndexTable, function(a,b) return a.playerCount > b.playerCount end)
	
	for i = 1, #teamIndexTable do
		for j = 1, #teamIndexTable[i] do
			currentPlayer = teamIndexTable[i][j]
			print("after sort, team index table: index " .. i .. ": player " .. currentPlayer)
		end
	end
	
	
	--check player index and team after sort
	print("after sort:")
	for teamIndex = 1, #teamMappingTable do
		for playerIndex = 1, #teamMappingTable[teamIndex].players do
			
			print("playerID " .. teamMappingTable[teamIndex].players[playerIndex].playerID .. " is on team " ..  teamMappingTable[teamIndex].teamID)
		end
		
		teamMappingTable[teamIndex].playerCount = #teamMappingTable[teamIndex].players
	end
	
	
	
	return teamMappingTable
end

--finds viable places for player spawns
--get the teamMappingTable from CreateTeamMappingTable() 
--minTeamDistance is how far any player must be from any member of an opposing team
--minPlayerDistance is how far any given potential start position must be from any other
--edgeBuffer is how many squares around the edge of the map are not viable places for player starts
--impasseTypes is a table of terrain types that this function will ensure to avoid placing players on or next to
--openTypes is a table of terrain types that are viable for putting players on. Must contain at least one terrain type or players will not spawn anywhere
--playerStartTerrain is the terrainType used to spawn starting resources
function PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, impasseTypes, openTypes, playerStartTerrain, terrainGrid)
	
	--ensure that there is at least tt_none in openTypes
	if(#openTypes == 0) then
		table.insert(openTypes, tt_none)
	end
	
	--create a list of all viable start locations
	openList = {}
	
	playerSpaceShrinking = 0.2
	teamSpaceShrinking = 0.2
	
	preStartTerrainTable = DeepCopy(terrainGrid)
	
	::restartPlayerPlacement::
	
	print("min player distance: " .. minPlayerDistance .. ", min team distance: " .. minTeamDistance)
	
	--fill the open list
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			--check if the current terrain square is a valid square (not impasse)
			isValidTerrain = false
			currentTerrainType = terrainGrid[row][col].terrainType
			for terrainTypeIndex = 1, #openTypes do
				if(currentTerrainType == openTypes[terrainTypeIndex]) then
					if(row >= 1+edgeBuffer and row <= (#terrainGrid - edgeBuffer) and col >= 1+edgeBuffer and col <= (#terrainGrid - edgeBuffer)) then
						isValidTerrain = true
					end
				end
			end
			
			--check for neighboring impasse
			testNeighbors = Get12Neighbors(row, col, terrainGrid)
			
			for testNeighborIndex, testNeighbor in ipairs(testNeighbors) do
				
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainGrid[testNeighborRow][testNeighborCol].terrainType
				for terrainTypeIndex = 1, #impasseTypes do
					if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
						isValidTerrain = false
					end
				end
			end
			
			--if the current square is not impasse, add it to the list
			currentInfo = {}
			if(isValidTerrain == true) then
				currentInfo = {row, col}
				table.insert(openList, currentInfo)
			end
		end
	end
	
	--prune the openList to be spots at least minPlayerDistance apart from one another-----------------------------------
	
	--find the average position of all squares in the open list
	averageRow = 0
	averageCol = 0
	for openIndex = 1, #openList do
		
		currentRow = openList[openIndex][1]
		currentCol = openList[openIndex][2]
		
		averageRow = averageRow + currentRow
		averageCol = averageCol + currentCol
		
	end
	
	--do the base case, get the first and second elements into the list
	print("openList members: " .. #openList)
	averageRow = math.ceil(averageRow / #openList)
	averageCol = math.ceil(averageCol / #openList)
	print("average openList row: " .. averageRow .. ", col: " .. averageCol)
	--from the average, find the furthest visable square
	furthestRow, furthestCol, furthestIndex = GetFurthestSquare(averageRow, averageCol, openList)
	
	--get a random place in a ring around the rough outer edge of the map
	ringRadius = math.ceil(#terrainGrid / 3)
	ringWidth = math.ceil(#terrainGrid / 4)
	randomRow, randomCol = GetSquareInRingAroundSquare(averageRow, averageCol, ringRadius, ringWidth, impasseTypes, terrainGrid)
	closestRow, closestCol, closestIndex = GetClosestSquare(randomRow, randomCol, openList)
	
	--create a closedList to hold chosen spots
	closedList = {}
	currentInfo = {}
	currentInfo = {closestRow, closestCol}
	table.insert(closedList, currentInfo)
	table.remove(openList, closestIndex)
	
	--iterate through open list and remove any spot that is too close to the elements in the closed list
	for openIndex = #openList, 1, -1 do
		
		closestDistance = 10000
		
		currentOpenRow = openList[openIndex][1]
		currentOpenCol = openList[openIndex][2]
		
		--iterate through closedList and find the smallest distance between this element and all elements of the closedList
		for closedIndex = 1, #closedList do
			currentClosedRow = closedList[closedIndex][1]
			currentClosedCol = closedList[closedIndex][2]
			currentDistance = GetDistance(currentOpenRow, currentOpenCol, currentClosedRow, currentClosedCol, 3)
			if(currentDistance < closestDistance) then
				closestDistance = currentDistance
			end
		end
		
		--if the closest distance is smaller than the minPlayerDistance, this means that this spot is too close to a chosen start location, so cull it from the open list so it isn't chosen
		if(closestDistance < minPlayerDistance) then
			table.remove(openList, openIndex)
		end
	end
	
	print("after pruning for minPlayerDistance, there are " .. #openList .. " entries in the openList to choose from")
	--loop through the openList until it is exhausted
	while(#openList > 0) do
		
		--find the square in the openList furthest from all squares in the closed list
		minimumDistances = {}
		
		for openIndex = 1, #openList do
				
			openListRow = openList[openIndex][1]
			openListCol = openList[openIndex][2]
			
			--get distances for all points in open list from each point in the solution set, and save the lowest
			currentDistances = {}
			--iterate over solution set
			for closedIndex = 1, #closedList do
				
				closedListRow = closedList[closedIndex][1]
				closedListCol = closedList[closedIndex][2]
				
				currentDistance = GetDistance(openListRow, openListCol, closedListRow, closedListCol, 4)
				table.insert(currentDistances, currentDistance)
			end
			
			--find minimum of this open list element to every point in the solution set
			currentMin = currentDistances[1]
			
			for i = 1, #currentDistances do
				if(currentDistances[i] < currentMin) then
					currentMin = currentDistances[i]
				end
			end
			
			--now we have the minimum distance of this element of the open list to all elements of the solution set
			--add this index's min distance to the list to see if it is the max distance
			table.insert(minimumDistances, {currentMin, openIndex})
			
		end
		
		--find max distance out of all collected minimum distances
		currentMax = minimumDistances[1][1]
		currentMaxIndex = minimumDistances[1][2]
		for i = 1, #minimumDistances do
			if(minimumDistances[i][1] > currentMax) then
				currentMax = minimumDistances[i][1]
				currentMaxIndex = minimumDistances[i][2]
			end
		end
		
		--put point with highest distance to all other chosen points into closedList
		table.insert(closedList, openList[currentMaxIndex])
		table.remove(openList, currentMaxIndex)
		
		
		--like above, iterate through openList and prune any points that are too close to closedList entries
		--iterate through open list and remove any spot that is too close to the elements in the closed list
		for openIndex = #openList, 1, -1 do
			
			closestDistance = 10000
			
			currentOpenRow = openList[openIndex][1]
			currentOpenCol = openList[openIndex][2]
			
			--iterate through closedList and find the smallest distance between this element and all elements of the closedList
			for closedIndex = 1, #closedList do
				currentClosedRow = closedList[closedIndex][1]
				currentClosedCol = closedList[closedIndex][2]
				currentDistance = GetDistance(currentOpenRow, currentOpenCol, currentClosedRow, currentClosedCol, 3)
				if(currentDistance < closestDistance) then
					closestDistance = currentDistance
				end
			end
			
			--if the closest distance is smaller than the minTeamDistance, this means that this spot is too close to a chosen start location, so cull it from the open list so it isn't chosen
			if(closestDistance < minPlayerDistance) then
				table.remove(openList, openIndex)
			end
		end
		
	end
	
	--uncomment this if you need to debug where all the potential start locations were before they were chosen
	--[[
	for closedIndex = 1, #closedList do
		currentRow = closedList[closedIndex][1]
		currentCol = closedList[closedIndex][2]
		terrainGrid[currentRow][currentCol].terrainType = tt_plateau_spike
	end
	]]--
	print("before choosing teams, there are " .. #closedList .. " entries in the closed list to choose from. Need at least " .. worldPlayerCount .. ", as that many players need a spawn location")
	
	--ensure there are enough spaces in the closed list to place players
	if(#closedList < worldPlayerCount) then
		minTeamDistance = minTeamDistance - teamSpaceShrinking
		minPlayerDistance = minPlayerDistance - playerSpaceShrinking
		terrainGrid = DeepCopy(preStartTerrainTable)
		goto restartPlayerPlacement
	end
	--now should have a closedList full of positions that are all at least minTeamDistance apart
	
	--do different spawning algorithms based on if teams are together or apart
	--THIS SHOULD BE FALSE TO BE CORRECT
	if(randomPositions == false) then
		print("placing players teams together")
		--this is Teams Together, so spawn players in clusters of closed list entries
		--place the first player and cluster their team near them
		
		--grab the first player from the closedList
		currentRow = closedList[1][1]
		currentCol = closedList[1][2]
		
		--get the playerID of the first player on the largest team
		currentPlayerID = teamMappingTable[1].players[1].playerID
		print("placing teamPlayerIndex 1 from team 1 at " .. currentRow .. ", " .. currentCol)
		terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
		terrainGrid[currentRow][currentCol].playerIndex = currentPlayerID - 1
		teamMappingTable[1].players[1].startRow = currentRow
		teamMappingTable[1].players[1].startCol = currentCol
		--create a list of the chosen positions
		chosenList = {}
		--add the initial player to the chosenList
		table.insert(chosenList, closedList[1])
		table.remove(closedList, 1)
		
		teamAverageRow = currentRow
		teamAverageCol = currentCol
		teamTotalRow = currentRow
		teamTotalCol = currentCol
		
		--do the first team
		if(worldPlayerCount > 1) then
			if(teamMappingTable[1].playerCount > 1) then
				
				currentDistances = {}
				--loop through the closedList and find the closest points to the team's average position
				for closedListIndex = 1, #closedList do
					closedListRow = closedList[closedListIndex][1]
					closedListCol = closedList[closedListIndex][2]
					
					currentDistance = GetDistance(closedListRow, closedListCol, teamAverageRow, teamAverageCol, 4)
					table.insert(currentDistances, {currentDistance, closedListIndex})
				end
				
				--sort currentDistances by it's calculated distance
				table.sort(currentDistances, function(a,b) return a[1] < b[1] end)
				
				toRemove = {}
				
				--place players according to the closest positions from the team's starting player
				for teamPlayerIndex = 2, teamMappingTable[1].playerCount do
					
					currentClosedListIndex = currentDistances[teamPlayerIndex-1][2]
					currentRow = closedList[currentClosedListIndex][1]
					currentCol = closedList[currentClosedListIndex][2]
					
					currentPlayerID = teamMappingTable[1].players[teamPlayerIndex].playerID
					print("placing teamPlayerIndex " .. teamPlayerIndex .. " from team 1 at "  .. currentRow .. ", " .. currentCol)
					terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
					terrainGrid[currentRow][currentCol].playerIndex = currentPlayerID -1
					teamMappingTable[1].players[teamPlayerIndex].startRow = currentRow
					teamMappingTable[1].players[teamPlayerIndex].startCol = currentCol
					
					teamTotalRow = teamTotalRow + currentRow
					teamTotalCol = teamTotalCol + currentCol
					
					teamAverageRow = (teamTotalRow / teamPlayerIndex)
					teamAverageCol = (teamTotalCol / teamPlayerIndex)
					
					table.insert(chosenList, closedList[currentClosedListIndex])
					table.insert(toRemove, currentClosedListIndex)
				end
				
				--loop through closedList backwards and remove any elements that were put in toRemove
				for closedIndex = #closedList, 1, -1 do
					
					for removalIndex = 1, #toRemove do
						
						currentRemovalIndex = toRemove[removalIndex]
						if(closedIndex == currentRemovalIndex) then
							table.remove(closedList, closedIndex)
						end
					end
				end
			end
		end
		
		--make sure there is more than 1 team to loop through
		if(#teamMappingTable > 1) then
			
			for teamIndex = 2, #teamMappingTable do
				--make sure there are players on this team
				if(teamMappingTable[teamIndex].playerCount > 0) then
					
					
					
					--find furthest square from all squares in chosen list
					minimumDistances = {}
					for closedListIndex = 1, #closedList do
						
						closedListRow = closedList[closedListIndex][1]
						closedListCol = closedList[closedListIndex][2]
						
						currentDistances = {}
						--iterate over solution set
						for chosenIndex = 1, #chosenList do
							
							chosenListRow = chosenList[chosenIndex][1]
							chosenListCol = chosenList[chosenIndex][2]
							currentDistance = GetDistance(closedListRow, closedListCol, chosenListRow, chosenListCol, 4)
							table.insert(currentDistances, currentDistance)
						end
						
						--find minimum of this closed list element to every point in the solution set
						currentMin = currentDistances[1]
						
						for i = 1, #currentDistances do
							if(currentDistances[i] < currentMin) then
								currentMin = currentDistances[i]
							end
						end
						
						--now we have the minimum distance of this element of the open list to all elements of the solution set
						--add this index's min distance to the list to see if it is the max distance
						table.insert(minimumDistances, {currentMin, closedListIndex})
						
					end 
					
					table.sort(minimumDistances, function(a,b) return a[1] > b[1] end)
					
					--find the maximum of all minimum distances to determine which start is furthest from all others
					currentMax = minimumDistances[1][1]
					currentMaxIndex = minimumDistances[1][2]
					for i = 1, #minimumDistances do
						print("minimum distances element " .. i .. " is " .. minimumDistances[i][1] .. " for point at " .. closedList[minimumDistances[i][2]][1] .. ", " .. closedList[minimumDistances[i][2]][2])
						if(minimumDistances[i][1] > currentMax) then
							currentMax = minimumDistances[i][1]
							--currentMaxIndex = minimumDistances[currentRandomTeamStartIndex][2]
							--currentRandomTeamStartIndex = minimumDistances[i][2]
						end
					end
					print("current max of all minimum distances is " .. currentMax .. " while the first entry in the sorted minimum distances is " .. minimumDistances[1][1])
					--grab a random point in the top percent
					distancePercentThreshold = 0.1
					currentRandomTeamStartIndex = math.ceil(GetRandomInRange(1, (math.ceil(#minimumDistances * distancePercentThreshold))))
					print("currentRandomTeamStartIndex is " .. currentRandomTeamStartIndex)
					--assign the maximum of all min distances to be the starting point for this team
					teamStartRow = closedList[minimumDistances[currentRandomTeamStartIndex][2]][1]
					teamStartCol = closedList[minimumDistances[currentRandomTeamStartIndex][2]][2]
					
					teamAverageRow = teamStartRow
					teamAverageCol = teamStartCol
					
					teamTotalRow = teamStartRow
					teamTotalCol = teamStartCol
					
					--grab first player on this team's info
					currentPlayerID = teamMappingTable[teamIndex].players[1].playerID
					print("placing teamPlayerIndex 1 from team " .. teamIndex .. " at " .. teamStartRow .. ", " .. teamStartCol)
					terrainGrid[teamStartRow][teamStartCol].terrainType = playerStartTerrain
					terrainGrid[teamStartRow][teamStartCol].playerIndex = currentPlayerID - 1
					teamMappingTable[teamIndex].players[1].startRow = teamStartRow
					teamMappingTable[teamIndex].players[1].startCol = teamStartCol
					table.insert(chosenList, closedList[minimumDistances[currentRandomTeamStartIndex][2]])
					table.remove(closedList, minimumDistances[currentRandomTeamStartIndex][2])
					
					--get a list of the closest remaining points to this chosen start location from the closedList
					currentDistances = {}
					--loop through the closedList and find the closest points to the first player on the team
					for closedListIndex = 1, #closedList do
						closedListRow = closedList[closedListIndex][1]
						closedListCol = closedList[closedListIndex][2]
						
						--only add points to the list if they are at least minTeamDistance away from all other chosen players
						
						currentDistance = GetDistance(closedListRow, closedListCol, teamAverageRow, teamAverageCol, 4)
						
						minOtherTeamDistance = 10000
						for chosenListIndex = 1, #chosenList do
							--ensure we are not comparing to this team's start
							if(chosenList[chosenListIndex][1] ~= teamStartRow and chosenList[chosenListIndex][2] ~= teamStartCol) then
								
								currentChosenListRow = chosenList[chosenListIndex][1]
								currentChosenListCol = chosenList[chosenListIndex][2]
								currentOtherTeamDistance = GetDistance(closedListRow, closedListCol, currentChosenListRow, currentChosenListCol, 4)
								print("current other team distance is " .. currentOtherTeamDistance)
								if(currentOtherTeamDistance < minOtherTeamDistance) then
									minOtherTeamDistance = currentOtherTeamDistance
								end
							end
							
						end
						
						if(minOtherTeamDistance > minTeamDistance) then
							table.insert(currentDistances, {currentDistance, closedListIndex})
						end
					end
					
					print("currentDistances table entries: " .. #currentDistances)
					--make sure there are at least enough squares to place this team's players that are far enough from enemy teams
					if(#currentDistances < teamMappingTable[teamIndex].playerCount) then
			
						minTeamDistance = minTeamDistance - teamSpaceShrinking
						minPlayerDistance = minPlayerDistance - playerSpaceShrinking
						terrainGrid = DeepCopy(preStartTerrainTable)
						goto restartPlayerPlacement
					end
					
					--sort currentDistances by it's calculated distance
					table.sort(currentDistances, function(a,b) return a[1] < b[1] end)
					
					toRemove = {}
					
					--place players according to the closest positions from the team's starting player
					for teamPlayerIndex = 2, teamMappingTable[teamIndex].playerCount do
						
						currentClosedListIndex = currentDistances[teamPlayerIndex-1][2]
						currentRow = closedList[currentClosedListIndex][1]
						currentCol = closedList[currentClosedListIndex][2]
						print("placing teamPlayerIndex " .. teamPlayerIndex .. " from team " .. teamIndex .. " at "  .. currentRow .. ", " .. currentCol)
						currentPlayerID = teamMappingTable[teamIndex].players[teamPlayerIndex].playerID
						teamMappingTable[teamIndex].players[teamPlayerIndex].startRow = currentRow
						teamMappingTable[teamIndex].players[teamPlayerIndex].startCol = currentCol
						terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
						terrainGrid[currentRow][currentCol].playerIndex = currentPlayerID - 1
						
						teamTotalRow = teamTotalRow + currentRow
						teamTotalCol = teamTotalCol + currentCol
						
						teamAverageRow = (teamTotalRow / teamPlayerIndex)
						teamAverageCol = (teamTotalCol / teamPlayerIndex)
						
						table.insert(chosenList, closedList[currentClosedListIndex])
						table.insert(toRemove, currentClosedListIndex)
					end
					
					--loop through closedList backwards and remove any elements that were put in toRemove
					for closedIndex = #closedList, 1, -1 do
						
						for removalIndex = 1, #toRemove do
							
							currentRemovalIndex = toRemove[removalIndex]
							if(closedIndex == currentRemovalIndex) then
								table.remove(closedList, closedIndex)
							end
						end
					end
					
				end
			end
		end
		
		
		
	else
		--this is Teams Apart, so spawn players in the furthest closedList entries from each other
		--place the first player
		print("placing players teams apart")
		randomPlayerStartIndex = math.ceil(worldGetRandom() * #closedList)
		
		currentRow = closedList[randomPlayerStartIndex][1]
		currentCol = closedList[randomPlayerStartIndex][2]
		
		currentPlayerID = 0
		
		terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
		terrainGrid[currentRow][currentCol].playerIndex = currentPlayerID
		
		--create a list of the chosen positions
		chosenList = {}
		table.insert(chosenList, closedList[randomPlayerStartIndex])
		table.remove(closedList, randomPlayerStartIndex)
		
		if(worldPlayerCount > 1) then
			for playerIndex = 2, worldPlayerCount do
				minimumDistances = {}
				for closedListIndex = 1, #closedList do
					
					closedListRow = closedList[closedListIndex][1]
					closedListCol = closedList[closedListIndex][2]
					
					currentDistances = {}
					--iterate over solution set
					for chosenIndex = 1, #chosenList do
						
						chosenListRow = chosenList[chosenIndex][1]
						chosenListCol = chosenList[chosenIndex][2]
						currentDistance = GetDistance(closedListRow, closedListCol, chosenListRow, chosenListCol, 4)
						table.insert(currentDistances, currentDistance)
					end
					
					--find minimum of this closed list element to every point in the solution set
					currentMin = currentDistances[1]
					
					for i = 1, #currentDistances do
						if(currentDistances[i] < currentMin) then
							currentMin = currentDistances[i]
						end
					end
					
					--now we have the minimum distance of this element of the open list to all elements of the solution set
					--add this index's min distance to the list to see if it is the max distance
					table.insert(minimumDistances, {currentMin, closedListIndex})
					
				end 
				
				--find the maximum of all minimum distances to determine which start is furthest from all others
				currentMax = minimumDistances[1][1]
				currentMaxIndex = minimumDistances[1][2]
				for i = 1, #minimumDistances do
					if(minimumDistances[i][1] > currentMax) then
						currentMax = minimumDistances[i][1]
						currentMaxIndex = minimumDistances[i][2]
					end
				end
				
				--assign the maximum distance square as a player start and remove it from the closedList and add it to the chosenList
				currentChosenRow = closedList[currentMaxIndex][1]
				currentChosenCol = closedList[currentMaxIndex][2]
				terrainGrid[currentChosenRow][currentChosenCol].terrainType = playerStartTerrain
				terrainGrid[currentChosenRow][currentChosenCol].playerIndex = playerIndex - 1
				table.insert(chosenList, closedList[currentMaxIndex])
				table.remove(closedList, currentMaxIndex)
				
				
			end
			
		end
		
		--check for ensuring number of players in lobby is equal to number of starts placed
		if(#chosenList < worldPlayerCount) then
			
			minTeamDistance = minTeamDistance - teamSpaceShrinking
			minPlayerDistance = minPlayerDistance - playerSpaceShrinking
			terrainGrid = DeepCopy(preStartTerrainTable)
			goto restartPlayerPlacement
		end
		
	end
	
	--[[
	::reducePlayerSpacing::
	--check for ensuring number of players in lobby is equal to number of starts placed
	if(worldPlayerCount ~= #chosenList) then
		
		minTeamDistance = minTeamDistance - 0.2
		minPlayerDistance = minPlayerDistance - 0.5
		terrainGrid = DeepCopy(preStartTerrainTable)
		goto restartPlayerPlacement
	end
	]]--
	--iterate through chosen list and add buffer terrain around start positions
	--also add start position info back into TeamMappingTable
	for startIndex = 1, #chosenList do
		currentRow = chosenList[startIndex][1]
		currentCol = chosenList[startIndex][2]
		
		--find the correct player according to teams
		startIndexCounter = 0
		for currentTeamIndex = 1, #teamMappingTable do
			teamIndex = currentTeamIndex
			
			for currentPlayerIndex = 1, #teamMappingTable[teamIndex].players do
				teamPlayerIndex = currentPlayerIndex
				startIndexCounter = startIndexCounter + 1
				
				if(startIndexCounter == startIndex) then
					goto mapPlayerLocation
				end
				
			end
			
		end
			
			
		::mapPlayerLocation::
		
		teamMappingTable[teamIndex].players[teamPlayerIndex].startRow = currentRow
		teamMappingTable[teamIndex].players[teamPlayerIndex].startCol = currentCol
		--check the neighbors
		currentNeighbors = Get12Neighbors(currentRow, currentCol, terrainLayoutResult)
		
		--iterate through neighbors of this point
		for neighborIndex, neighbor in ipairs(currentNeighbors) do
			
			--add buffers around player starts for flat buildable land
			currentNeighborRow = neighbor.x 
			currentNeighborCol = neighbor.y 
			
			if (terrainGrid[currentNeighborRow][currentNeighborCol].terrainType ~= playerStartTerrain) then
				terrainGrid[currentNeighborRow][currentNeighborCol].terrainType = tt_plains_smooth
			end
		end
		
		
	end
	
	resourceChance = 0.25
	
	
	
	--iterate through and replace the temp start position terrain
	--[[
	for row = 1, #terrainGrid do
		for col = 1, #terrainGrid do
			
			if(terrainGrid[row][col].terrainType == tt_plateau_spike) then
				if(worldGetRandom() < resourceChance) then
					terrainGrid[row][col].terrainType = tt_pocket_gold_food
				else
					terrainGrid[row][col].terrainType = tt_plains
				end
			end
		end
	end
	--]]
	return terrainGrid
end

--This function places all players in a ring around the edge of the map, with a variable amount of the centre of the map unavailable for spawn locations
--The teamMappingTable holds player IDs and team compositions, gotten from the CreateTeamMappingTable function.
--minTeamDistance is how far apart the "team locations" must be. A "team location" is a central spot around which players from that team will be placed. This is a distance relative to the course grid squares.
--minPlayerDistance determines how far each player must be from another player. When using "Teams Apart", this determines how far opposite teams can be from one another also.
--edgeuffer determines how many squares around a grid's perimeter players cannot spawn
--innerExclusion is a value between 0 and 1 that determines the percentage of the interior of the grid to block from player spawning. eg on a 20x20 grid, a 0.5 innerExclusion would black out the centre 10x10
--impasseTypes are the terrain types that are avoided
--impasseDistance is how far away all potential player spawns must be from any squares that have an impasseTypes grid type.
--topSelectionThreshold is how variable the selection of starts around the selected team location can be, on a scale from 0 to 1. 0.05 will give only the top 5% of spaces, resulting in a tightly grouped team.
--playerStartTerrain is the terrain that gets put down at a chosen player spawning position
--startBufferTerrain is the terrain that gets put down around player starts
--terrainGrid is the terrainLayoutResult from the map layout
function PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeBufferTerrain, terrainGrid)
	
	
	
	-- shuffling all player indexes to guarantee random positions
	ShuffleAllTeamsIndexes(teamMappingTable)
	
	--create a list of all viable start locations
	openList = {}
	
	currentMinPlayerDistance = minPlayerDistance
	currentMinTeamDistance = minTeamDistance
	
	playerSpaceShrinking = 0.2
	teamSpaceShrinking = 0.2
	
	halfInnerExclusion = innerExclusion / 2
	halfGridSize = Round(#terrainGrid / 2, 0)
	minInnerExclusion = Round(((0.5 - halfInnerExclusion) * #terrainGrid), 0)
	maxInnerExclusion = Round(((0.5 + halfInnerExclusion) * #terrainGrid), 0)
	print("halfInnerExclusion is " .. halfInnerExclusion)
	print("terrain grid size is " .. #terrainGrid)
	print("0.5 - halfInnerExclusion is " .. 0.5 - halfInnerExclusion)
	print("inner exclusion zone from " .. minInnerExclusion .. " to " .. maxInnerExclusion)
	
	
	preStartTerrainTable = DeepCopy(terrainGrid)
	
	::restartPlayerPlacement::
	
	if(currentMinPlayerDistance < 0) then
		currentMinPlayerDistance = minPlayerDistance	
	end
	
	if(currentMinTeamDistance < 0) then
		currentMinTeamDistance = minTeamDistance + 1
	end
	
	print("current min player distance: " .. currentMinPlayerDistance .. ", current min team distance: " .. currentMinTeamDistance)
	
	--fill the open list
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			--check if the current terrain square is a valid square (not impasse)
			isValidTerrain = true
	--		print("checking row " .. row .. ", col " .. col)
			--check for in bounds of edgeBuffer and inner exclusion
			if(((row > minInnerExclusion) and (row <= maxInnerExclusion)) and ((col > minInnerExclusion) and (col <= maxInnerExclusion))) then
				print("coordinate " .. row .. ", " .. col .. " is within the exclusion zone")
				isValidTerrain = false
			elseif((row < 1+edgeBuffer or row > (#terrainGrid - edgeBuffer)) or (col < 1+edgeBuffer or col > (#terrainGrid - edgeBuffer))) then
				print("coordinate " .. row .. ", " .. col .. " is outside the ring of acceptable starting donut terrain")
				isValidTerrain = false
			--[[	
				--check for corners of outer donut
			elseif( (row == edgeBuffer+1 and col == edgeBuffer + 2) or (row == edgeBuffer + 2 and col == edgeBuffer+1) or (row == edgeBuffer+1 and col == edgeBuffer + 1) or
					(row == #terrainGrid - edgeBuffer and col == edgeBuffer + 1) or (row == #terrainGrid - edgeBuffer - 1 and col == edgeBuffer + 1) or (row == #terrainGrid - edgeBuffer and col == edgeBuffer + 2) or
					(row == edgeBuffer+1 and col == #terrainGrid - edgeBuffer) or (row == edgeBuffer+2 and col == #terrainGrid - edgeBuffer) or (row == edgeBuffer+1 and col == #terrainGrid - edgeBuffer - 1) or
					(row == #terrainGrid - edgeBuffer and col == #terrainGrid - edgeBuffer) or (row == #terrainGrid - edgeBuffer - 1 and col == #terrainGrid - edgeBuffer) or (row == #terrainGrid - edgeBuffer and col == #terrainGrid - edgeBuffer - 1)
					) then
				]]--
			elseif( (row <= edgeBuffer + cornerThreshold + 1 and col <= edgeBuffer + cornerThreshold) or (row <= edgeBuffer + cornerThreshold and col <= edgeBuffer+ cornerThreshold + 1) or (row <= edgeBuffer + cornerThreshold +1 and col <= edgeBuffer + cornerThreshold +1) or
				(row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - 1 and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or
				(row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer + cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or
				(row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold)
				) then
				print("coordinate " .. row .. ", " .. col .. " is in the corner of the acceptable donut, removing")
				isValidTerrain = false
			end
				
			
			
			
			--check for neighboring impasse
			
			--loop through all squares and find those that are closer than impasseDistance. If any of these are one of the impasse types then set isValidTerrain to false
			--[[
			testNeighbors = Get12Neighbors(row, col, terrainGrid)
			
			for testNeighborIndex, testNeighbor in ipairs(testNeighbors) do
				
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainGrid[testNeighborRow][testNeighborCol].terrainType
				for terrainTypeIndex = 1, #impasseTypes do
					if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
						isValidTerrain = false
					end
				end
			end
			]]--
			for impasseCheckRow = 1, gridSize do
				for impasseCheckCol = 1, gridSize do
					--check to see if this square is within impasseDistance
					currentDistance = GetDistance(row, col, impasseCheckRow, impasseCheckCol, 2)
					if(currentDistance <= impasseDistance) then
						currentTerrainType = terrainGrid[impasseCheckRow][impasseCheckCol].terrainType
						for terrainTypeIndex = 1, #impasseTypes do
							if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
								isValidTerrain = false
								print("coordinate " .. row .. ", " .. col .. " is in the too close to impasse, removing")
							end
						end
					end
					
				end
			end
			
			--if the current square is not impasse, add it to the list
			currentInfo = {}
			if(isValidTerrain == true) then
				currentInfo = {row, col}
				table.insert(openList, currentInfo)
			end
		end
	end
	
	--create a copy of the openList
	openListPlayers = {}
	openListPlayers = DeepCopy(openList)
	
	
	--do the base case, get the first and second elements into the list
	print("openList members: " .. #openList)
	teamLocations = {}
	teamsPlaced = 0
	currentAttemptsAtTeamDistance = 0
	attemptThreshold = 10
	
	currentTeamIndex = 1
	--do different spawning algorithms based on if teams are together or apart
	--THIS SHOULD BE FALSE TO BE CORRECT
	--THIS IS TEAMS TOGETHER
	if(randomPositions == false) then
		
		
		
		repeat
			
			--check and make sure there are still places in the openList
			if(#openList > 0) then
				--pick a random spot for the first team and assign to the teamLocations table
				--get a random place in a ring around the rough outer edge of the map
				randomIndex = math.ceil(worldGetRandom() * #openList)
				randomRow = openList[randomIndex][1]
				randomCol = openList[randomIndex][2]
				
				teamSizeModifier = 3
				print("looking at the number of players on team " .. currentTeamIndex)
				currentTeamPlayers = teamMappingTable[currentTeamIndex].playerCount
				modifiedMinTeamDistance = minTeamDistance + (teamSizeModifier * currentTeamPlayers) 
				if(modifiedMinTeamDistance > (gridSize * 0.75)) then
					modifiedMinTeamDistance = gridSize * 0.75
				end
				--create a teamLocations list to hold chosen spots
				
				currentInfo = {}
				currentInfo = {randomRow, randomCol}
				table.insert(teamLocations, currentInfo)
				table.remove(openList, randomIndex)
				
				entriesToRemove = {}
				--remove any openList locations that are closer than minTeamDistance away
				--loop through openList
				for openIndex = 1, #openList do
					currentRow = openList[openIndex][1]
					currentCol = openList[openIndex][2]
					
					--get the distance from the current point to the selected random point
					currentDistance = GetDistance(currentRow, currentCol, randomRow, randomCol, 2)
					
					--if this point is closer than the minTeamDistance, then it is not valid for selecting another teamLocation
					--add it to the entriesToRemove list
					if(currentDistance < modifiedMinTeamDistance) then
						table.insert(entriesToRemove, openIndex)
					end
				end
				
				--iterate backwards through the openList and remove all entries found to be too close to this new teamLocation
				for openRemovalIndex = #openList, 1, -1 do
					
					--loop through entriesToRemove and see if this index matches any element
					matchesRemovalIndex = false
					for entriesIndex = 1, #entriesToRemove do
						if(entriesToRemove[entriesIndex] == openRemovalIndex) then
							
							matchesRemovalIndex = true
						end
					end
					--if a match was found, remove this index
					if(matchesRemovalIndex == true) then
						table.remove(openList, openRemovalIndex)
					end
					
				end
				
				--iterate necessary variables to find the next team
				teamsPlaced = teamsPlaced + 1
				currentTeamIndex = currentTeamIndex + 1
				print("placed location for team " .. teamsPlaced .. " at " .. randomRow .. ", " .. randomCol)
				
			--if there is no more spaces in the openList then restart the search
			else
				
				--reset the openList
				openList = {}
				openList = DeepCopy(openListPlayers)
				currentAttemptsAtTeamDistance = currentAttemptsAtTeamDistance + 1
				teamsPlaced = 0
				teamLocations = {}
				currentTeamIndex = 1
				print("reset " .. currentAttemptsAtTeamDistance .. " at teamDistance " .. minTeamDistance)
			end
			
			
			
			--ensure all team locations are placed. If not, try x amount of times, then reduce minTeamDistance slightly and try again
			if(currentAttemptsAtTeamDistance > attemptThreshold) then
				minTeamDistance = minTeamDistance - teamSpaceShrinking
				currentAttemptsAtTeamDistance = 0
				teamsPlaced = 0
				currentTeamIndex = 1
				teamLocations = {}
			end
			
		until (teamsPlaced == #teamMappingTable)
		
		
		--debug loop through and print out the openListPlayers
		--loop through openList
		for openIndex = 1, #openListPlayers do
			currentRow = openListPlayers[openIndex][1]
			currentCol = openListPlayers[openIndex][2]
			
			print("current openListPlayer point: " .. currentRow .. ", " .. currentCol)
		end
		
		--now, all teams should have a teamLocations entry
		--using the copy of the openList with all possible squares, place all players from a team starting at the teamLocations entry.
		--valid locations of players should be a combination of how close they are to their teamLocations entry and how far from opponents they are
		
		openListCopy = {}
		openListCopy = DeepCopy(openListPlayers)
		
		--make sure there is more than 1 team to loop through
		if(#teamMappingTable >= 1) then
			
			--loop through this until all players are placed
			playersPlaced = 0
			repeat
				
				--place the players at the team locations first
				for teamIndex = 1, #teamMappingTable do
					
					print("placing the first player from team " .. teamIndex)
					if(teamMappingTable[teamIndex].playerCount > 0) then
						
						--put the first player on the team in the current teamLocation
						
						teamStartRow = teamLocations[teamIndex][1]
						teamStartCol = teamLocations[teamIndex][2]
						
						
						--grab first player on this team's info
						currentPlayerID = teamMappingTable[teamIndex].players[1].playerID
						print("placing teamPlayerIndex 1 from team " .. teamIndex .. " at " .. teamStartRow .. ", " .. teamStartCol)
						terrainGrid[teamStartRow][teamStartCol].terrainType = playerStartTerrain
						terrainGrid[teamStartRow][teamStartCol].playerIndex = currentPlayerID - 1
						teamMappingTable[teamIndex].players[1].startRow = teamStartRow
						teamMappingTable[teamIndex].players[1].startCol = teamStartCol
						
						playersPlaced = playersPlaced + 1
						--remove any squares directly around this location
						entriesToRemove = {}
						--loop through openList
						for openIndex = 1, #openListPlayers do
							currentRow = openListPlayers[openIndex][1]
							currentCol = openListPlayers[openIndex][2]
							
							--get the distance from the current point to the selected random point
							currentDistance = GetDistance(currentRow, currentCol, teamStartRow, teamStartCol, 2)
							
							--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teammate
							--add it to the entriesToRemove list
							if(currentDistance < minPlayerDistance) then
								table.insert(entriesToRemove, openIndex)
							end
						end
						--iterate backwards through the openList and remove all entries found to be too close to this new player location
						for openRemovalIndex = #openListPlayers, 1, -1 do
							
							--loop through entriesToRemove and see if this index matches any element
							matchesRemovalIndex = false
							for entriesIndex = 1, #entriesToRemove do
								if(entriesToRemove[entriesIndex] == openRemovalIndex) then
									
									matchesRemovalIndex = true
								end
							end
							--if a match was found, remove this index
							if(matchesRemovalIndex == true) then
									print("removing openListPlayers entry " .. openRemovalIndex .. " around start location at " .. openListPlayers[openRemovalIndex][1] .. ", " .. openListPlayers[openRemovalIndex][2])
								table.remove(openListPlayers, openRemovalIndex)
							end
							
						end
					end
				end
				
				
				for teamIndex = 1, #teamMappingTable do
					--make sure there are players on this team
					print("plcing players from TEAM " .. teamIndex)
					if(teamMappingTable[teamIndex].playerCount > 0) then
						
						--put the first player on the team in the current teamLocation
						
						teamStartRow = teamLocations[teamIndex][1]
						teamStartCol = teamLocations[teamIndex][2]
						
						--place players according to the closest positions from the team's starting point
						if(teamMappingTable[teamIndex].playerCount >= 2) then
							for teamPlayerIndex = 2, teamMappingTable[teamIndex].playerCount do
								
								--[[
							currentDistances = {}
							--loop through openListPlayers and record the distance of each remaining point to this teamStartingPoint
							for openPlayerIndex = 1, #openListPlayers do
								
								currentRow = openListPlayers[openPlayerIndex][1]
								currentCol = openListPlayers[openPlayerIndex][2]
								
								currentDistance = GetDistance(currentRow, currentCol, teamStartRow, teamStartCol, 2)
								
								currentInfo = {}
								currentInfo = {currentDistance, openPlayerIndex}
								table.insert(currentDistances, currentInfo)
							end
							
							--sort currentDistances so that the closest distances are first
							table.sort(currentDistances, function(a,b) return a[1] < b[1] end)
							
							--grab one of the top elements in the sorted list and assign a player there
							
							topSelectionThreshold = 0.15
							maxRandomSelection = math.ceil(#currentDistances * topSelectionThreshold)
							
							currentRandomSelection = math.ceil(worldGetRandom() * maxRandomSelection)
							
							
							selectedOpenListIndex = currentDistances[currentRandomSelection][2]
							currentRow = openListPlayers[selectedOpenListIndex][1]
							currentCol = openListPlayers[selectedOpenListIndex][2]
							--]]
								
								--make a list of all points and their distances relative to each team position
								currentDistances = {}
								for teamDistanceIndex = 1, #teamMappingTable do
									
									currentTeamStartRow = teamLocations[teamDistanceIndex][1]
									currentTeamStartCol = teamLocations[teamDistanceIndex][2]
									currentDistances[teamDistanceIndex] = {}
									for openPlayerIndex = 1, #openListPlayers do
										
										currentRow = openListPlayers[openPlayerIndex][1]
										currentCol = openListPlayers[openPlayerIndex][2]
										
										currentDistance = GetDistance(currentRow, currentCol, currentTeamStartRow, currentTeamStartCol, 3)
										
										currentInfo = {}
										currentInfo = {currentDistance, openPlayerIndex}
										table.insert(currentDistances[teamDistanceIndex], currentInfo)
									end
								end
								
								--sort each team's currentDistances so highest distances are at the top of the list
								for distancesIndex = 1, #currentDistances do
									table.sort(currentDistances[distancesIndex], function(a,b) return a[1] > b[1] end)
								end
								
								positionScores = {}
								opponentDistanceMultiplier = 0.5
								--loop through each point and tally up scores for the current team
								--[[
								for playerScoreIndex = 1, #openListPlayers do
									
									currentScore = 0
									currentRow = openListPlayers[playerScoreIndex][1]
									currentCol = openListPlayers[playerScoreIndex][2]
									--loop through each currentDistances team table
									for distanceTeamIndex = 1, #currentDistances do
										for distancePointIndex = 1, #currentDistances[distanceTeamIndex] do
											
											--	print("on team " .. distanceTeamIndex .. " at point " .. distancePointIndex .. " looking to match point index " .. currentDistances[distanceTeamIndex][distancePointIndex][2] .. " to base index " .. playerScoreIndex)
											--if looking at the current team, add this positional score
											if(distanceTeamIndex == teamIndex) then
												--check if the current point is the correct index

												if(playerScoreIndex == currentDistances[distanceTeamIndex][distancePointIndex][2]) then
													--	print("indices matched on correct team at index " .. playerScoreIndex .. ", adding " .. distancePointIndex .. " with a distance of " .. currentDistances[distanceTeamIndex][distancePointIndex][1])
													currentScore = currentScore + distancePointIndex
													--currentScore = currentScore + currentDistances[distanceTeamIndex][distancePointIndex][1]
												end
												
												--if this is an opposing team, subtract the score
											else
												
												--check if the current point is the correct index
												if(playerScoreIndex == currentDistances[distanceTeamIndex][distancePointIndex][2]) then
													--	print("indices matched on opposing team at index " .. playerScoreIndex .. ", subtracting " .. distancePointIndex .. " with a distance of " .. currentDistances[distanceTeamIndex][distancePointIndex][1])
												--	currentScore = currentScore / (distancePointIndex * opponentDistanceMultiplier)
													currentDivisor = 0
													--loop through every opposing team and check for player location details to subtract further score for enemy proximity
													for currentTeamIndex = 1, #teamMappingTable do
														if(currentTeamIndex ~= teamIndex) then
															print("looking at player locations on team " .. currentTeamIndex)
															for currentPlayerIndex = 1, #teamMappingTable[currentTeamIndex].players do
																
																if(teamMappingTable[teamIndex].players[currentPlayerIndex].startRow ~= nil) then
																	currentStartRow = teamMappingTable[teamIndex].players[currentPlayerIndex].startRow
																	currentStartCol = teamMappingTable[teamIndex].players[currentPlayerIndex].startCol
																	
																	currentPlayerDistance = GetDistance(currentRow, currentCol, currentStartRow, currentStartCol, 2)
																	currentDivisor = currentDivisor + currentPlayerDistance
																	currentSubtraction = currentScore / (currentPlayerDistance * opponentDistanceMultiplier)
																	print("current divisor: " .. currentDivisor .. " from current score " .. currentScore .. " from player " .. currentPlayerIndex .. " at " .. currentStartRow .. ", " .. currentStartCol)
																--	currentScore = currentScore / (currentPlayerDistance * opponentDistanceMultiplier)
																	
																end
															end
														end
													end
													
													if(currentDivisor > 0) then
														currentScore = currentScore / currentDivisor	
													end
													
													
													--currentScore = currentScore - (currentDistances[distanceTeamIndex][distancePointIndex][1] * opponentDistanceMultiplier)
												end
												
											end
										end
										
									end
									
									currentInfo = {currentScore, currentRow, currentCol}
									--	print("score of point " .. currentRow .. ", " .. currentCol .. " is " .. currentScore)
									table.insert(positionScores, currentInfo)
									
								end
								--]]
								
								for playerScoreIndex = 1, #openListPlayers do
									
									currentScore = 0
									currentDivisor = 0
									currentAddition = 0
									currentRow = openListPlayers[playerScoreIndex][1]
									currentCol = openListPlayers[playerScoreIndex][2]
									print("CURRENT SQUARE: " .. currentRow .. ", " .. currentCol)
									for currentTeamIndex = 1, #teamMappingTable do
										if(currentTeamIndex == teamIndex) then
											print("looking at player locations on team " .. currentTeamIndex)
											for currentPlayerIndex = 1, #teamMappingTable[currentTeamIndex].players do
												
												if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
													currentStartRow = teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow
													currentStartCol = teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol
													
													currentPlayerDistance = GetDistance(currentRow, currentCol, currentStartRow, currentStartCol, 2)
													currentAddition = #terrainGrid - currentPlayerDistance
													print("current score addition: " .. currentAddition .. " to current score " .. currentScore .. " from player " .. currentPlayerIndex .. " at " .. currentStartRow .. ", " .. currentStartCol)
													currentScore = currentScore + currentAddition
													
												end
											end
											
										--this is an opposing team
										else
											print("looking at player locations on team " .. currentTeamIndex)
											for currentPlayerIndex = 1, #teamMappingTable[currentTeamIndex].players do
												
												if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
													currentStartRow = teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow
													currentStartCol = teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol
													
													currentPlayerDistance = GetDistance(currentRow, currentCol, currentStartRow, currentStartCol, 2)
													currentDivisor = currentDivisor + (#terrainGrid - currentPlayerDistance)
													print("current divisor: " .. currentDivisor .. " from current score " .. currentScore .. " from player " .. currentPlayerIndex .. " at " .. currentStartRow .. ", " .. currentStartCol)
													
												end
											end
										end
										
									end
									
									if(currentDivisor > 0) then
									--	currentDivisor = currentDivisor * opponentDistanceMultiplier
									--	currentDivisor = 1
										currentScore = currentScore / currentDivisor / currentDivisor
									end
									
									currentInfo = {}
									currentInfo = {currentScore, currentRow, currentCol}
									table.insert(positionScores, currentInfo)
									
								end
								
								if(#positionScores < (worldPlayerCount - playersPlaced)) then
									print("insufficient position scores, only " .. #positionScores .. " score entries")
									break
								end
								
								table.sort(positionScores, function(a,b) return a[1] > b[1] end)
								--grab one of the top elements in the sorted list and assign a player there
								
								maxRandomSelection = math.ceil(#openListPlayers * topSelectionThreshold)
								
								print("printing all options for this player:")
								for topOptionIndex = 1, #openListPlayers do
									currentTopScore = positionScores[topOptionIndex][1]
									currentTopRow = positionScores[topOptionIndex][2]
									currentTopCol = positionScores[topOptionIndex][3]
									print("top option " .. topOptionIndex .. ": row " .. currentTopRow .. ", col " .. currentTopCol .. " with score of " .. currentTopScore)
								end
								
								print("printing top options for this player:")
								for topOptionIndex = 1, maxRandomSelection do
									currentTopScore = positionScores[topOptionIndex][1]
									currentTopRow = positionScores[topOptionIndex][2]
									currentTopCol = positionScores[topOptionIndex][3]
									print("top option " .. topOptionIndex .. ": row " .. currentTopRow .. ", col " .. currentTopCol .. " with score of " .. currentTopScore)
								end
								
								currentRandomSelection = math.ceil(worldGetRandom() * maxRandomSelection)
								
								currentRow = positionScores[currentRandomSelection][2]
								currentCol = positionScores[currentRandomSelection][3]
								
								print("out of " .. maxRandomSelection .. " top entries, choosing index " .. currentRandomSelection .. " at " .. currentRow .. ", " .. currentCol .. " with a score of " .. positionScores[currentRandomSelection][1])
								
								print("placing teamPlayerIndex " .. teamPlayerIndex .. " from team " .. teamIndex .. " at "  .. currentRow .. ", " .. currentCol)
								currentPlayerID = teamMappingTable[teamIndex].players[teamPlayerIndex].playerID
								teamMappingTable[teamIndex].players[teamPlayerIndex].startRow = currentRow
								teamMappingTable[teamIndex].players[teamPlayerIndex].startCol = currentCol
								terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
								terrainGrid[currentRow][currentCol].playerIndex = currentPlayerID - 1
								
								playersPlaced = playersPlaced + 1
								print("players placed: " .. playersPlaced)
								--loop through and remove openList elements close to this point
								entriesToRemove = {}
								
								--loop through openList
								for openIndex = 1, #openListPlayers do
									currentCheckRow = openListPlayers[openIndex][1]
									currentCheckCol = openListPlayers[openIndex][2]
									
									--get the distance from the current point to the selected random point
									currentDistance = GetDistance(currentRow, currentCol, currentCheckRow, currentCheckCol, 2)
									
									--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teammate
									--add it to the entriesToRemove list
									if(currentDistance < minPlayerDistance) then
										table.insert(entriesToRemove, openIndex)
									end
								end
								
								
								--loop through openListPlayers backwards and remove any elements that were put in entriesToRemove
								for closedIndex = #openListPlayers, 1, -1 do
									
									for removalIndex = 1, #entriesToRemove do
										
										currentRemovalIndex = entriesToRemove[removalIndex]
										if(closedIndex == currentRemovalIndex) then
											print("removing openListPlayers entry " .. currentRemovalIndex .. " around player location at " .. openListPlayers[currentRemovalIndex][1] .. ", " .. openListPlayers[currentRemovalIndex][2])
											table.remove(openListPlayers, closedIndex)
										end
									end
								end
								--[[
								--check and ensure that there are still more entries in the open list to search through.
								if(#openListPlayers < worldPlayerCount) then
									
									--reset the search
									terrainGrid = {}
									terrainGrid = DeepCopy(preStartTerrainTable)
									openListPlayers = {}
									openListPlayers = DeepCopy(openListCopy)
									playersPlaced = 0
									minPlayerDistance = minPlayerDistance - playerSpaceShrinking
									print("player distance: " .. minPlayerDistance)
									print("SHRINKING PLAYER SPACING")
									break
								end
								]]--
							end
						end
						
					end
				end
				
				
						
			if(playersPlaced < worldPlayerCount) then
									
				--reset the search
				terrainGrid = {}
				terrainGrid = DeepCopy(preStartTerrainTable)
				openListPlayers = {}
				openListPlayers = DeepCopy(openListCopy)
				playersPlaced = 0
				minPlayerDistance = minPlayerDistance - playerSpaceShrinking
				for currentTeamIndex = 1, #teamMappingTable do
					for currentPlayerIndex = 1, #teamMappingTable[currentTeamIndex].players do
						print("reseting row and col info for player " .. currentPlayerIndex)
						if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
							teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow = nil
						end
						if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol ~= nil) then
							teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol = nil
						end
							
					end
				end
				print("player distance: " .. minPlayerDistance)
				print("SHRINKING PLAYER SPACING - END OF LOOP")
				
			end
				
			until playersPlaced == worldPlayerCount
		end
		
		
	--THIS IS TEAMS APART
	else
		
		playerLocations = {}
		playersPlaced = 0
		
		repeat
			
			--check and make sure there are still places in the openList
			if(#openList > 0) then
				--pick a random spot for the first team and assign to the playerLocations table
				--get a random place in a ring around the rough outer edge of the map
				randomIndex = math.ceil(worldGetRandom() * #openList)
				randomRow = openList[randomIndex][1]
				randomCol = openList[randomIndex][2]
				
				--create a playerLocations list to hold chosen spots
				
				currentInfo = {}
				currentInfo = {randomRow, randomCol}
				table.insert(playerLocations, currentInfo)
				table.remove(openList, randomIndex)
				
				entriesToRemove = {}
				--remove any openList locations that are closer than minPlayerDistance away
				--loop through openList
				for openIndex = 1, #openList do
					currentRow = openList[openIndex][1]
					currentCol = openList[openIndex][2]
					
					--get the distance from the current point to the selected random point
					currentDistance = GetDistance(currentRow, currentCol, randomRow, randomCol, 2)
					
					--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teamLocation
					--add it to the entriesToRemove list
					if(currentDistance < minPlayerDistance) then
						table.insert(entriesToRemove, openIndex)
					end
				end
				
				--iterate backwards through the openList and remove all entries found to be too close to this new teamLocation
				for openRemovalIndex = #openList, 1, -1 do
					
					--loop through entriesToRemove and see if this index matches any element
					matchesRemovalIndex = false
					for entriesIndex = 1, #entriesToRemove do
						if(entriesToRemove[entriesIndex] == openRemovalIndex) then
							
							matchesRemovalIndex = true
						end
					end
					--if a match was found, remove this index
					if(matchesRemovalIndex == true) then
						table.remove(openList, openRemovalIndex)
					end
					
				end
				
				--iterate necessary variables to find the next team
				playersPlaced = playersPlaced + 1
				print("placed location for player " .. playersPlaced .. " at " .. randomRow .. ", " .. randomCol)
				
			--if there is no more spaces in the openList then restart the search
			else
				
				--reset the openList
				openList = {}
				openList = DeepCopy(openListPlayers)
				currentAttemptsAtTeamDistance = currentAttemptsAtTeamDistance + 1
				playersPlaced = 0
				playerLocations = {}
				for currentTeamIndex = 1, #teamMappingTable do
					for currentPlayerIndex = 1, #teamMappingTable[currentTeamIndex].players do
						print("reseting row and col info for player " .. currentPlayerIndex)
						if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
							teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow = nil
						end
						if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol ~= nil) then
							teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol = nil
						end
							
					end
				end
				print("reset " .. currentAttemptsAtTeamDistance .. " at playerDistance " .. minPlayerDistance)
			end
			
			
			
			--ensure all team locations are placed. If not, try x amount of times, then reduce minPlayerDistance slightly and try again
			if(currentAttemptsAtTeamDistance > attemptThreshold) then
				minPlayerDistance = minPlayerDistance - playerSpaceShrinking
				currentAttemptsAtTeamDistance = 0
				playersPlaced = 0
				currentTeamIndex = 1
				playerLocations = {}
			end
			
		until (playersPlaced == worldPlayerCount)
		
		
		ShuffleTable(playerLocations)
		
		--place players randomly in the playerPositions that were found
		if(#teamMappingTable >= 1) then
			currentPlayerCount = 1
			for teamIndex = 1, #teamMappingTable do
				--make sure there are players on this team
				print("placing players from TEAM " .. teamIndex)
				if(teamMappingTable[teamIndex].playerCount > 0) then
					for currentTeamPlayerIndex = 1, #teamMappingTable[teamIndex].players do
						
						--put the first player on the team in the current teamLocation
						
						playerStartRow = playerLocations[currentPlayerCount][1]
						playerStartCol = playerLocations[currentPlayerCount][2]
						
						
						--grab first player on this team's info
						currentPlayerID = teamMappingTable[teamIndex].players[currentTeamPlayerIndex].playerID
						print("placing teamPlayerIndex " .. currentTeamPlayerIndex .. " from team " .. teamIndex .. " at " .. playerStartRow .. ", " .. playerStartCol)
						terrainGrid[playerStartRow][playerStartCol].terrainType = playerStartTerrain
						terrainGrid[playerStartRow][playerStartCol].playerIndex = currentPlayerID - 1
						teamMappingTable[teamIndex].players[currentTeamPlayerIndex].startRow = playerStartRow
						teamMappingTable[teamIndex].players[currentTeamPlayerIndex].startCol = playerStartCol
						
						currentPlayerCount = currentPlayerCount + 1
					end
				end
			end
		end
		
		
	end
	
	
	if(placeBufferTerrain == true) then
		--set buffer terrain according to parameters
		for row = 1, #terrainGrid do
			for col = 1, #terrainGrid do
				
				--get all squares in correct radius around the start positions
				if(terrainGrid[row][col].terrainType == playerStartTerrain) then
					bufferSquares = GetAllSquaresInRadius(row, col, startBufferRadius, terrainGrid)
					for bIndex = 1, #bufferSquares do
						bufrow = bufferSquares[bIndex][1]
						bufcol = bufferSquares[bIndex][2]
						
						if (terrainGrid[bufrow][bufcol].terrainType ~= playerStartTerrain) then
							terrainGrid[bufrow][bufcol].terrainType = startBufferTerrain
						end
						
					end
				end
			end
		end
	end
	

	return terrainGrid


end

function PlacePlayerStartsTogetherRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeBufferTerrain, terrainGrid)
	
	
	
	
	--create a list of all viable start locations
	openList = {}
	
	currentMinPlayerDistance = minPlayerDistance
	currentMinTeamDistance = minTeamDistance
	
	playerSpaceShrinking = 0.2
	teamSpaceShrinking = 0.2
	
	halfInnerExclusion = innerExclusion / 2
	halfGridSize = Round(#terrainGrid / 2, 0)
	minInnerExclusion = Round(((0.5 - halfInnerExclusion) * #terrainGrid), 0)
	maxInnerExclusion = Round(((0.5 + halfInnerExclusion) * #terrainGrid), 0)
	
	print("inner exclusion zone from " .. minInnerExclusion .. " to " .. maxInnerExclusion)
	
	
	preStartTerrainTable = DeepCopy(terrainGrid)
	
	::restartPlayerPlacement::
	
	if(currentMinPlayerDistance < 0) then
		currentMinPlayerDistance = minPlayerDistance	
	end
	
	if(currentMinTeamDistance < 0) then
		currentMinTeamDistance = minTeamDistance + 1
	end
	
	print("current min player distance: " .. currentMinPlayerDistance .. ", current min team distance: " .. currentMinTeamDistance)
	
	--fill the open list
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			--check if the current terrain square is a valid square (not impasse)
			isValidTerrain = true
	--		print("checking row " .. row .. ", col " .. col)
			--check for in bounds of edgeBuffer and inner exclusion
			if(((row > minInnerExclusion) and (row <= maxInnerExclusion)) and ((col > minInnerExclusion) and (col <= maxInnerExclusion))) then
				print("coordinate " .. row .. ", " .. col .. " is within the exclusion zone")
				isValidTerrain = false
			elseif((row < 1+edgeBuffer or row > (#terrainGrid - edgeBuffer)) or (col < 1+edgeBuffer or col > (#terrainGrid - edgeBuffer))) then
				print("coordinate " .. row .. ", " .. col .. " is outside the ring of acceptable starting donut terrain")
				isValidTerrain = false
			--[[	
				--check for corners of outer donut
			elseif( (row == edgeBuffer+1 and col == edgeBuffer + 2) or (row == edgeBuffer + 2 and col == edgeBuffer+1) or (row == edgeBuffer+1 and col == edgeBuffer + 1) or
					(row == #terrainGrid - edgeBuffer and col == edgeBuffer + 1) or (row == #terrainGrid - edgeBuffer - 1 and col == edgeBuffer + 1) or (row == #terrainGrid - edgeBuffer and col == edgeBuffer + 2) or
					(row == edgeBuffer+1 and col == #terrainGrid - edgeBuffer) or (row == edgeBuffer+2 and col == #terrainGrid - edgeBuffer) or (row == edgeBuffer+1 and col == #terrainGrid - edgeBuffer - 1) or
					(row == #terrainGrid - edgeBuffer and col == #terrainGrid - edgeBuffer) or (row == #terrainGrid - edgeBuffer - 1 and col == #terrainGrid - edgeBuffer) or (row == #terrainGrid - edgeBuffer and col == #terrainGrid - edgeBuffer - 1)
					) then
				]]--
			elseif( (row <= edgeBuffer + cornerThreshold + 1 and col <= edgeBuffer + cornerThreshold) or (row <= edgeBuffer + cornerThreshold and col <= edgeBuffer+ cornerThreshold + 1) or (row <= edgeBuffer + cornerThreshold +1 and col <= edgeBuffer + cornerThreshold +1) or
				(row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - 1 and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or
				(row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer + cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or
				(row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold)
				) then
				print("coordinate " .. row .. ", " .. col .. " is in the corner of the acceptable donut, removing")
				isValidTerrain = false
			end
				
			
			
			
			--check for neighboring impasse
			
			--loop through all squares and find those that are closer than impasseDistance. If any of these are one of the impasse types then set isValidTerrain to false
			--[[
			testNeighbors = Get12Neighbors(row, col, terrainGrid)
			
			for testNeighborIndex, testNeighbor in ipairs(testNeighbors) do
				
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainGrid[testNeighborRow][testNeighborCol].terrainType
				for terrainTypeIndex = 1, #impasseTypes do
					if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
						isValidTerrain = false
					end
				end
			end
			]]--
			for impasseCheckRow = 1, gridSize do
				for impasseCheckCol = 1, gridSize do
					--check to see if this square is within impasseDistance
					currentDistance = GetDistance(row, col, impasseCheckRow, impasseCheckCol, 2)
					if(currentDistance <= impasseDistance) then
						currentTerrainType = terrainGrid[impasseCheckRow][impasseCheckCol].terrainType
						for terrainTypeIndex = 1, #impasseTypes do
							if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
								isValidTerrain = false
								print("coordinate " .. row .. ", " .. col .. " is in the too close to impasse, removing")
							end
						end
					end
					
				end
			end
			
			--if the current square is not impasse, add it to the list
			currentInfo = {}
			if(isValidTerrain == true) then
				currentInfo = {row, col}
				table.insert(openList, currentInfo)
			end
		end
	end
	
	--create a copy of the openList
	openListPlayers = {}
	openListPlayers = DeepCopy(openList)
	
	
	--do the base case, get the first and second elements into the list
	print("openList members: " .. #openList)
	teamLocations = {}
	teamsPlaced = 0
	currentAttemptsAtTeamDistance = 0
	attemptThreshold = 10
	
	currentTeamIndex = 1
	--do different spawning algorithms based on if teams are together or apart
	--THIS SHOULD BE FALSE TO BE CORRECT
	--THIS IS TEAMS TOGETHER
	if(randomPositions == false) then
		
		
		
		repeat
			
			--check and make sure there are still places in the openList
			if(#openList > 0) then
				--pick a random spot for the first team and assign to the teamLocations table
				--get a random place in a ring around the rough outer edge of the map
				randomIndex = math.ceil(worldGetRandom() * #openList)
				randomRow = openList[randomIndex][1]
				randomCol = openList[randomIndex][2]
				
				teamSizeModifier = 3
				print("looking at the number of players on team " .. currentTeamIndex)
				currentTeamPlayers = teamMappingTable[currentTeamIndex].playerCount
				modifiedMinTeamDistance = minTeamDistance + (teamSizeModifier * currentTeamPlayers) 
				if(modifiedMinTeamDistance > (gridSize * 0.75)) then
					modifiedMinTeamDistance = gridSize * 0.75
				end
				--create a teamLocations list to hold chosen spots
				
				currentInfo = {}
				currentInfo = {randomRow, randomCol}
				table.insert(teamLocations, currentInfo)
				table.remove(openList, randomIndex)
				
				entriesToRemove = {}
				--remove any openList locations that are closer than minTeamDistance away
				--loop through openList
				for openIndex = 1, #openList do
					currentRow = openList[openIndex][1]
					currentCol = openList[openIndex][2]
					
					--get the distance from the current point to the selected random point
					currentDistance = GetDistance(currentRow, currentCol, randomRow, randomCol, 2)
					
					--if this point is closer than the minTeamDistance, then it is not valid for selecting another teamLocation
					--add it to the entriesToRemove list
					if(currentDistance < modifiedMinTeamDistance) then
						table.insert(entriesToRemove, openIndex)
					end
				end
				
				--iterate backwards through the openList and remove all entries found to be too close to this new teamLocation
				for openRemovalIndex = #openList, 1, -1 do
					
					--loop through entriesToRemove and see if this index matches any element
					matchesRemovalIndex = false
					for entriesIndex = 1, #entriesToRemove do
						if(entriesToRemove[entriesIndex] == openRemovalIndex) then
							
							matchesRemovalIndex = true
						end
					end
					--if a match was found, remove this index
					if(matchesRemovalIndex == true) then
						table.remove(openList, openRemovalIndex)
					end
					
				end
				
				--iterate necessary variables to find the next team
				teamsPlaced = teamsPlaced + 1
				currentTeamIndex = currentTeamIndex + 1
				print("placed location for team " .. teamsPlaced .. " at " .. randomRow .. ", " .. randomCol)
				
			--if there is no more spaces in the openList then restart the search
			else
				
				--reset the openList
				openList = {}
				openList = DeepCopy(openListPlayers)
				currentAttemptsAtTeamDistance = currentAttemptsAtTeamDistance + 1
				teamsPlaced = 0
				teamLocations = {}
				currentTeamIndex = 1
				print("reset " .. currentAttemptsAtTeamDistance .. " at teamDistance " .. minTeamDistance)
			end
			
			
			
			--ensure all team locations are placed. If not, try x amount of times, then reduce minTeamDistance slightly and try again
			if(currentAttemptsAtTeamDistance > attemptThreshold) then
				minTeamDistance = minTeamDistance - teamSpaceShrinking
				currentAttemptsAtTeamDistance = 0
				teamsPlaced = 0
				currentTeamIndex = 1
				teamLocations = {}
			end
			
		until (teamsPlaced == #teamMappingTable)
		
		
		--debug loop through and print out the openListPlayers
		--loop through openList
		for openIndex = 1, #openListPlayers do
			currentRow = openListPlayers[openIndex][1]
			currentCol = openListPlayers[openIndex][2]
			
			print("current openListPlayer point: " .. currentRow .. ", " .. currentCol)
		end
		
		print("minPlayerDistance is " .. minPlayerDistance)
		--now, all teams should have a teamLocations entry
		--using the copy of the openList with all possible squares, place all players from a team starting at the teamLocations entry.
		--valid locations of players should be a combination of how close they are to their teamLocations entry and how far from opponents they are
		
		openListCopy = {}
		openListCopy = DeepCopy(openListPlayers)
		
		--make sure there is more than 1 team to loop through
		if(#teamMappingTable >= 1) then
			
			--loop through this until all players are placed
			playersPlaced = 0
			repeat
				
				--place the players at the team locations first
				for teamIndex = 1, #teamMappingTable do
					
					print("placing the first player from team " .. teamIndex)
					if(teamMappingTable[teamIndex].playerCount > 0) then
						
						--put the first player on the team in the current teamLocation
						
						teamStartRow = teamLocations[teamIndex][1]
						teamStartCol = teamLocations[teamIndex][2]
						
						
						--grab first player on this team's info
						currentPlayerID = teamMappingTable[teamIndex].players[1].playerID
						print("placing teamPlayerIndex 1 from team " .. teamIndex .. " at " .. teamStartRow .. ", " .. teamStartCol)
						terrainGrid[teamStartRow][teamStartCol].terrainType = playerStartTerrain
						terrainGrid[teamStartRow][teamStartCol].playerIndex = currentPlayerID - 1
						teamMappingTable[teamIndex].players[1].startRow = teamStartRow
						teamMappingTable[teamIndex].players[1].startCol = teamStartCol
						
						playersPlaced = playersPlaced + 1
						--remove any squares directly around this location
						entriesToRemove = {}
						--loop through openList
						for openIndex = 1, #openListPlayers do
							currentRow = openListPlayers[openIndex][1]
							currentCol = openListPlayers[openIndex][2]
							
							--get the distance from the current point to the selected random point
							currentDistance = GetDistance(currentRow, currentCol, teamStartRow, teamStartCol, 2)
							
							--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teammate
							--add it to the entriesToRemove list
							if(currentDistance < minPlayerDistance) then
								table.insert(entriesToRemove, openIndex)
							end
						end
						--iterate backwards through the openList and remove all entries found to be too close to this new player location
						for openRemovalIndex = #openListPlayers, 1, -1 do
							
							--loop through entriesToRemove and see if this index matches any element
							matchesRemovalIndex = false
							for entriesIndex = 1, #entriesToRemove do
								if(entriesToRemove[entriesIndex] == openRemovalIndex) then
									
									matchesRemovalIndex = true
								end
							end
							--if a match was found, remove this index
							if(matchesRemovalIndex == true) then
									print("removing openListPlayers entry " .. openRemovalIndex .. " around start location at " .. openListPlayers[openRemovalIndex][1] .. ", " .. openListPlayers[openRemovalIndex][2])
								removalDistance = GetDistance(openListPlayers[openRemovalIndex][1], openListPlayers[openRemovalIndex][2], teamStartRow, teamStartCol, 2)
									print("the distance was " .. removalDistance)
								table.remove(openListPlayers, openRemovalIndex)
							end
							
						end
					end
				end
				
				
				for teamIndex = 1, #teamMappingTable do
					--make sure there are players on this team
					print("plcing players from TEAM " .. teamIndex)
					if(teamMappingTable[teamIndex].playerCount > 0) then
						
						--put the first player on the team in the current teamLocation
						
						teamStartRow = teamLocations[teamIndex][1]
						teamStartCol = teamLocations[teamIndex][2]
						
						--place players according to the closest positions from the team's starting point
						if(teamMappingTable[teamIndex].playerCount >= 2) then
							for teamPlayerIndex = 2, teamMappingTable[teamIndex].playerCount do
								
								--[[
							currentDistances = {}
							--loop through openListPlayers and record the distance of each remaining point to this teamStartingPoint
							for openPlayerIndex = 1, #openListPlayers do
								
								currentRow = openListPlayers[openPlayerIndex][1]
								currentCol = openListPlayers[openPlayerIndex][2]
								
								currentDistance = GetDistance(currentRow, currentCol, teamStartRow, teamStartCol, 2)
								
								currentInfo = {}
								currentInfo = {currentDistance, openPlayerIndex}
								table.insert(currentDistances, currentInfo)
							end
							
							--sort currentDistances so that the closest distances are first
							table.sort(currentDistances, function(a,b) return a[1] < b[1] end)
							
							--grab one of the top elements in the sorted list and assign a player there
							
							topSelectionThreshold = 0.15
							maxRandomSelection = math.ceil(#currentDistances * topSelectionThreshold)
							
							currentRandomSelection = math.ceil(worldGetRandom() * maxRandomSelection)
							
							
							selectedOpenListIndex = currentDistances[currentRandomSelection][2]
							currentRow = openListPlayers[selectedOpenListIndex][1]
							currentCol = openListPlayers[selectedOpenListIndex][2]
							--]]
								
								--make a list of all points and their distances relative to each team position
								currentDistances = {}
								for teamDistanceIndex = 1, #teamMappingTable do
									
									currentTeamStartRow = teamLocations[teamDistanceIndex][1]
									currentTeamStartCol = teamLocations[teamDistanceIndex][2]
									currentDistances[teamDistanceIndex] = {}
									for openPlayerIndex = 1, #openListPlayers do
										
										currentRow = openListPlayers[openPlayerIndex][1]
										currentCol = openListPlayers[openPlayerIndex][2]
										
										currentDistance = GetDistance(currentRow, currentCol, currentTeamStartRow, currentTeamStartCol, 3)
										
										currentInfo = {}
										currentInfo = {currentDistance, openPlayerIndex}
										table.insert(currentDistances[teamDistanceIndex], currentInfo)
									end
								end
								
								--sort each team's currentDistances so highest distances are at the top of the list
								for distancesIndex = 1, #currentDistances do
									table.sort(currentDistances[distancesIndex], function(a,b) return a[1] > b[1] end)
								end
								
								positionScores = {}
								opponentDistanceMultiplier = 0.5
								--loop through each point and tally up scores for the current team
								--[[
								for playerScoreIndex = 1, #openListPlayers do
									
									currentScore = 0
									currentRow = openListPlayers[playerScoreIndex][1]
									currentCol = openListPlayers[playerScoreIndex][2]
									--loop through each currentDistances team table
									for distanceTeamIndex = 1, #currentDistances do
										for distancePointIndex = 1, #currentDistances[distanceTeamIndex] do
											
											--	print("on team " .. distanceTeamIndex .. " at point " .. distancePointIndex .. " looking to match point index " .. currentDistances[distanceTeamIndex][distancePointIndex][2] .. " to base index " .. playerScoreIndex)
											--if looking at the current team, add this positional score
											if(distanceTeamIndex == teamIndex) then
												--check if the current point is the correct index

												if(playerScoreIndex == currentDistances[distanceTeamIndex][distancePointIndex][2]) then
													--	print("indices matched on correct team at index " .. playerScoreIndex .. ", adding " .. distancePointIndex .. " with a distance of " .. currentDistances[distanceTeamIndex][distancePointIndex][1])
													currentScore = currentScore + distancePointIndex
													--currentScore = currentScore + currentDistances[distanceTeamIndex][distancePointIndex][1]
												end
												
												--if this is an opposing team, subtract the score
											else
												
												--check if the current point is the correct index
												if(playerScoreIndex == currentDistances[distanceTeamIndex][distancePointIndex][2]) then
													--	print("indices matched on opposing team at index " .. playerScoreIndex .. ", subtracting " .. distancePointIndex .. " with a distance of " .. currentDistances[distanceTeamIndex][distancePointIndex][1])
												--	currentScore = currentScore / (distancePointIndex * opponentDistanceMultiplier)
													currentDivisor = 0
													--loop through every opposing team and check for player location details to subtract further score for enemy proximity
													for currentTeamIndex = 1, #teamMappingTable do
														if(currentTeamIndex ~= teamIndex) then
															print("looking at player locations on team " .. currentTeamIndex)
															for currentPlayerIndex = 1, #teamMappingTable[currentTeamIndex].players do
																
																if(teamMappingTable[teamIndex].players[currentPlayerIndex].startRow ~= nil) then
																	currentStartRow = teamMappingTable[teamIndex].players[currentPlayerIndex].startRow
																	currentStartCol = teamMappingTable[teamIndex].players[currentPlayerIndex].startCol
																	
																	currentPlayerDistance = GetDistance(currentRow, currentCol, currentStartRow, currentStartCol, 2)
																	currentDivisor = currentDivisor + currentPlayerDistance
																	currentSubtraction = currentScore / (currentPlayerDistance * opponentDistanceMultiplier)
																	print("current divisor: " .. currentDivisor .. " from current score " .. currentScore .. " from player " .. currentPlayerIndex .. " at " .. currentStartRow .. ", " .. currentStartCol)
																--	currentScore = currentScore / (currentPlayerDistance * opponentDistanceMultiplier)
																	
																end
															end
														end
													end
													
													if(currentDivisor > 0) then
														currentScore = currentScore / currentDivisor	
													end
													
													
													--currentScore = currentScore - (currentDistances[distanceTeamIndex][distancePointIndex][1] * opponentDistanceMultiplier)
												end
												
											end
										end
										
									end
									
									currentInfo = {currentScore, currentRow, currentCol}
									--	print("score of point " .. currentRow .. ", " .. currentCol .. " is " .. currentScore)
									table.insert(positionScores, currentInfo)
									
								end
								--]]
								
								for playerScoreIndex = 1, #openListPlayers do
									
									currentScore = 0
									currentDivisor = 0
									currentAddition = 0
									currentRow = openListPlayers[playerScoreIndex][1]
									currentCol = openListPlayers[playerScoreIndex][2]
									lowestPlayerDistance = 10000
									print("CURRENT SQUARE: " .. currentRow .. ", " .. currentCol)
									for currentTeamIndex = 1, #teamMappingTable do
										if(currentTeamIndex == teamIndex) then
											print("looking at player locations on team " .. currentTeamIndex)
											for currentPlayerIndex = 1, #teamMappingTable[currentTeamIndex].players do
												
												if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
													currentStartRow = teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow
													currentStartCol = teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol
													
													currentPlayerDistance = GetDistance(currentRow, currentCol, currentStartRow, currentStartCol, 2)
													
													print("current score addition: " .. currentAddition .. " to current score " .. currentScore .. " from player " .. currentPlayerIndex .. " at " .. currentStartRow .. ", " .. currentStartCol)
													if(currentPlayerDistance < lowestPlayerDistance) then
														currentScore = currentPlayerDistance
														lowestPlayerDistance = currentPlayerDistance
													end
												end
											end
										end
									end
									
									currentInfo = {}
									currentInfo = {currentScore, currentRow, currentCol}
									table.insert(positionScores, currentInfo)
									
								end
								
								if(#positionScores < (worldPlayerCount - playersPlaced)) then
									print("insufficient position scores, only " .. #positionScores .. " score entries")
									break
								end
								
								table.sort(positionScores, function(a,b) return a[1] < b[1] end)
								--grab one of the top elements in the sorted list and assign a player there
								
								maxRandomSelection = math.ceil(#openListPlayers * topSelectionThreshold)
								
								print("printing all options for this player:")
								for topOptionIndex = 1, #openListPlayers do
									currentTopScore = positionScores[topOptionIndex][1]
									currentTopRow = positionScores[topOptionIndex][2]
									currentTopCol = positionScores[topOptionIndex][3]
									print("top option " .. topOptionIndex .. ": row " .. currentTopRow .. ", col " .. currentTopCol .. " with score of " .. currentTopScore)
								end
								
								print("printing top options for this player:")
								for topOptionIndex = 1, maxRandomSelection do
									currentTopScore = positionScores[topOptionIndex][1]
									currentTopRow = positionScores[topOptionIndex][2]
									currentTopCol = positionScores[topOptionIndex][3]
									print("top option " .. topOptionIndex .. ": row " .. currentTopRow .. ", col " .. currentTopCol .. " with score of " .. currentTopScore)
								end
								
								currentRandomSelection = math.ceil(worldGetRandom() * maxRandomSelection)
								
								currentRow = positionScores[currentRandomSelection][2]
								currentCol = positionScores[currentRandomSelection][3]
								
								print("out of " .. maxRandomSelection .. " top entries, choosing index " .. currentRandomSelection .. " at " .. currentRow .. ", " .. currentCol .. " with a score of " .. positionScores[currentRandomSelection][1])
								
								print("placing teamPlayerIndex " .. teamPlayerIndex .. " from team " .. teamIndex .. " at "  .. currentRow .. ", " .. currentCol)
								currentPlayerID = teamMappingTable[teamIndex].players[teamPlayerIndex].playerID
								teamMappingTable[teamIndex].players[teamPlayerIndex].startRow = currentRow
								teamMappingTable[teamIndex].players[teamPlayerIndex].startCol = currentCol
								terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
								terrainGrid[currentRow][currentCol].playerIndex = currentPlayerID - 1
								
								playersPlaced = playersPlaced + 1
								print("players placed: " .. playersPlaced)
								--loop through and remove openList elements close to this point
								entriesToRemove = {}
								
								--loop through openList
								for openIndex = 1, #openListPlayers do
									currentCheckRow = openListPlayers[openIndex][1]
									currentCheckCol = openListPlayers[openIndex][2]
									
									--get the distance from the current point to the selected random point
									currentDistance = GetDistance(currentRow, currentCol, currentCheckRow, currentCheckCol, 2)
									
									--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teammate
									--add it to the entriesToRemove list
									if(currentDistance < minPlayerDistance) then
										table.insert(entriesToRemove, openIndex)
									end
								end
								
								
								--loop through openListPlayers backwards and remove any elements that were put in entriesToRemove
								for closedIndex = #openListPlayers, 1, -1 do
									
									for removalIndex = 1, #entriesToRemove do
										
										currentRemovalIndex = entriesToRemove[removalIndex]
										if(closedIndex == currentRemovalIndex) then
											print("removing openListPlayers entry " .. currentRemovalIndex .. " around player location at " .. openListPlayers[currentRemovalIndex][1] .. ", " .. openListPlayers[currentRemovalIndex][2])
											table.remove(openListPlayers, closedIndex)
										end
									end
								end
								--[[
								--check and ensure that there are still more entries in the open list to search through.
								if(#openListPlayers < worldPlayerCount) then
									
									--reset the search
									terrainGrid = {}
									terrainGrid = DeepCopy(preStartTerrainTable)
									openListPlayers = {}
									openListPlayers = DeepCopy(openListCopy)
									playersPlaced = 0
									minPlayerDistance = minPlayerDistance - playerSpaceShrinking
									print("player distance: " .. minPlayerDistance)
									print("SHRINKING PLAYER SPACING")
									break
								end
								]]--
							end
						end
						
					end
				end
				
				
						
			if(playersPlaced < worldPlayerCount) then
									
				--reset the search
				terrainGrid = {}
				terrainGrid = DeepCopy(preStartTerrainTable)
				openListPlayers = {}
				openListPlayers = DeepCopy(openListCopy)
				playersPlaced = 0
				minPlayerDistance = minPlayerDistance - playerSpaceShrinking
				print("player distance: " .. minPlayerDistance)
				print("SHRINKING PLAYER SPACING - END OF LOOP")
					
				print("reseting start row and start col of mapping table")
				for currentTeamIndex = 1, #teamMappingTable do
					for currentPlayerIndex = 1, #teamMappingTable[currentTeamIndex].players do
						print("reseting row and col info for player " .. currentPlayerIndex)
						if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
							teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow = nil
						end
						if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol ~= nil) then
							teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol = nil
						end
							
					end
				end
				
			end
				
			until playersPlaced == worldPlayerCount
		end
		
		
	--THIS IS TEAMS APART
	else
		
		playerLocations = {}
		playersPlaced = 0
		
		repeat
			
			--check and make sure there are still places in the openList
			if(#openList > 0) then
				--pick a random spot for the first team and assign to the playerLocations table
				--get a random place in a ring around the rough outer edge of the map
				randomIndex = math.ceil(worldGetRandom() * #openList)
				randomRow = openList[randomIndex][1]
				randomCol = openList[randomIndex][2]
				
				--create a playerLocations list to hold chosen spots
				
				currentInfo = {}
				currentInfo = {randomRow, randomCol}
				table.insert(playerLocations, currentInfo)
				table.remove(openList, randomIndex)
				
				entriesToRemove = {}
				--remove any openList locations that are closer than minPlayerDistance away
				--loop through openList
				for openIndex = 1, #openList do
					currentRow = openList[openIndex][1]
					currentCol = openList[openIndex][2]
					
					--get the distance from the current point to the selected random point
					currentDistance = GetDistance(currentRow, currentCol, randomRow, randomCol, 2)
					
					--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teamLocation
					--add it to the entriesToRemove list
					if(currentDistance < minPlayerDistance) then
						table.insert(entriesToRemove, openIndex)
					end
				end
				
				--iterate backwards through the openList and remove all entries found to be too close to this new teamLocation
				for openRemovalIndex = #openList, 1, -1 do
					
					--loop through entriesToRemove and see if this index matches any element
					matchesRemovalIndex = false
					for entriesIndex = 1, #entriesToRemove do
						if(entriesToRemove[entriesIndex] == openRemovalIndex) then
							
							matchesRemovalIndex = true
						end
					end
					--if a match was found, remove this index
					if(matchesRemovalIndex == true) then
						table.remove(openList, openRemovalIndex)
					end
					
				end
				
				--iterate necessary variables to find the next team
				playersPlaced = playersPlaced + 1
				print("placed location for player " .. playersPlaced .. " at " .. randomRow .. ", " .. randomCol)
				
			--if there is no more spaces in the openList then restart the search
			else
				
				--reset the openList
				openList = {}
				openList = DeepCopy(openListPlayers)
				currentAttemptsAtTeamDistance = currentAttemptsAtTeamDistance + 1
				playersPlaced = 0
				playerLocations = {}
				print("reset " .. currentAttemptsAtTeamDistance .. " at playerDistance " .. minPlayerDistance)
			end
			
			
			
			--ensure all team locations are placed. If not, try x amount of times, then reduce minPlayerDistance slightly and try again
			if(currentAttemptsAtTeamDistance > attemptThreshold) then
				minPlayerDistance = minPlayerDistance - playerSpaceShrinking
				currentAttemptsAtTeamDistance = 0
				playersPlaced = 0
				currentTeamIndex = 1
				playerLocations = {}
			end
			
		until (playersPlaced == worldPlayerCount)
		
		
		ShuffleTable(playerLocations)
		
		--place players randomly in the playerPositions that were found
		if(#teamMappingTable >= 1) then
			currentPlayerCount = 1
			for teamIndex = 1, #teamMappingTable do
				--make sure there are players on this team
				print("placing players from TEAM " .. teamIndex)
				if(teamMappingTable[teamIndex].playerCount > 0) then
					for currentTeamPlayerIndex = 1, #teamMappingTable[teamIndex].players do
						
						--put the first player on the team in the current teamLocation
						
						playerStartRow = playerLocations[currentPlayerCount][1]
						playerStartCol = playerLocations[currentPlayerCount][2]
						
						
						--grab first player on this team's info
						currentPlayerID = teamMappingTable[teamIndex].players[currentTeamPlayerIndex].playerID
						print("placing teamPlayerIndex " .. currentTeamPlayerIndex .. " from team " .. teamIndex .. " at " .. playerStartRow .. ", " .. playerStartCol)
						terrainGrid[playerStartRow][playerStartCol].terrainType = playerStartTerrain
						terrainGrid[playerStartRow][playerStartCol].playerIndex = currentPlayerID - 1
						teamMappingTable[teamIndex].players[currentTeamPlayerIndex].startRow = playerStartRow
						teamMappingTable[teamIndex].players[currentTeamPlayerIndex].startCol = playerStartCol
						
						currentPlayerCount = currentPlayerCount + 1
					end
				end
			end
		end
		
		
	end
	
	
	if(placeBufferTerrain == true) then
		--set buffer terrain according to parameters
		for row = 1, #terrainGrid do
			for col = 1, #terrainGrid do
				
				--get all squares in correct radius around the start positions
				if(terrainGrid[row][col].terrainType == playerStartTerrain) then
					bufferSquares = GetAllSquaresInRadius(row, col, startBufferRadius, terrainGrid)
					for bIndex = 1, #bufferSquares do
						bufrow = bufferSquares[bIndex][1]
						bufcol = bufferSquares[bIndex][2]
						
						if (terrainGrid[bufrow][bufcol].terrainType ~= playerStartTerrain) then
							terrainGrid[bufrow][bufcol].terrainType = startBufferTerrain
						end
						
					end
				end
			end
		end
	end
	

	return terrainGrid


end


--This function places two teams of players in two horizontal or vertical bands
--The teamMappingTable holds player IDs and team compositions, gotten from the CreateTeamMappingTable function.
--minTeamDistance is how far apart the "team locations" must be. A "team location" is a central spot around which players from that team will be placed. This is a distance relative to the course grid squares.
--minPlayerDistance determines how far each player must be from another player. When using "Teams Apart", this determines how far opposite teams can be from one another also.
--edgeuffer determines how many squares around a grid's perimeter players cannot spawn
--innerExclusion is a value between 0 and 1 that determines the percentage of the interior of the grid to block from player spawning. eg on a 20x20 grid, a 0.5 innerExclusion would black out the centre 10x10
--impasseTypes are the terrain types that are avoided
--impasseDistance is how far away all potential player spawns must be from any squares that have an impasseTypes grid type.
--topSelectionThreshold is how variable the selection of starts around the selected team location can be, on a scale from 0 to 1. 0.05 will give only the top 5% of spaces, resulting in a tightly grouped team.
--playerStartTerrain is the terrain that gets put down at a chosen player spawning position
--startBufferTerrain is the terrain that gets put down around player starts
--terrainGrid is the terrainLayoutResult from the map layout
function PlacePlayerStartsDivided(localMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, isVertical, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, placeBufferTerrain, terrainGrid)
	
	
	
	
	local originalTeamMappingTable = {}
	originalTeamMappingTable = DeepCopy(localMappingTable)
	
	--create a list of all viable start locations
	openList1 = {}
	openList2 = {}
	
	currentMinPlayerDistance = minPlayerDistance
	currentMinTeamDistance = minTeamDistance
	
	playerSpaceShrinking = 0.2
	teamSpaceShrinking = 0.2
	
	halfInnerExclusion = innerExclusion / 2
	halfGridSize = Round(#terrainGrid / 2, 0)
	minInnerExclusion = Round(((0.5 - halfInnerExclusion) * #terrainGrid), 0)
	maxInnerExclusion = Round(((0.5 + halfInnerExclusion) * #terrainGrid), 0)
	
	print("inner exclusion zone from " .. minInnerExclusion .. " to " .. maxInnerExclusion)
	
	
	preStartTerrainTable = DeepCopy(terrainGrid)
	
	::restartPlayerPlacement::
	
	if(currentMinPlayerDistance < 0) then
		currentMinPlayerDistance = minPlayerDistance	
	end
	
	if(currentMinTeamDistance < 0) then
		currentMinTeamDistance = minTeamDistance + 1
	end
	
	print("current min player distance: " .. currentMinPlayerDistance .. ", current min team distance: " .. currentMinTeamDistance)
	print("placing players DIVIDED")
	if(isVertical == true) then
		
		--fill the first open list
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				--check if the current terrain square is a valid square (not impasse)
				isValidTerrain = true
				--		print("checking row " .. row .. ", col " .. col)
				--check for in bounds of edgeBuffer and inner exclusion
				if(col > minInnerExclusion) then
					print("coordinate " .. row .. ", " .. col .. " is within the first exclusion zone")
					isValidTerrain = false
				elseif((row < 1+edgeBuffer or row > (#terrainGrid - edgeBuffer)) or (col < 1+edgeBuffer or col > (#terrainGrid - edgeBuffer))) then
					print("coordinate " .. row .. ", " .. col .. " is outside the ring of acceptable starting donut terrain")
					isValidTerrain = false
					
				elseif( (row <= edgeBuffer + cornerThreshold + 1 and col <= edgeBuffer + cornerThreshold) or (row <= edgeBuffer + cornerThreshold and col <= edgeBuffer+ cornerThreshold + 1) or (row <= edgeBuffer + cornerThreshold +1 and col <= edgeBuffer + cornerThreshold +1) or
					(row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - 1 and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or
					(row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer + cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or
					(row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold)
					) then
					print("coordinate " .. row .. ", " .. col .. " is in the corner of the acceptable donut, removing")
					isValidTerrain = false
				end
				
				for impasseCheckRow = 1, gridSize do
					for impasseCheckCol = 1, gridSize do
						--check to see if this square is within impasseDistance
						currentDistance = GetDistance(row, col, impasseCheckRow, impasseCheckCol, 2)
						if(currentDistance <= impasseDistance) then
							currentTerrainType = terrainGrid[impasseCheckRow][impasseCheckCol].terrainType
							for terrainTypeIndex = 1, #impasseTypes do
								if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
									isValidTerrain = false
								end
							end
						end
						
					end
				end
				
				--if the current square is not impasse, add it to the list
				currentInfo = {}
				if(isValidTerrain == true) then
					currentInfo = {row, col}
					table.insert(openList1, currentInfo)
				end
			end
		end
		
		
		--fill the second open list
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				--check if the current terrain square is a valid square (not impasse)
				isValidTerrain = true
				--		print("checking row " .. row .. ", col " .. col)
				--check for in bounds of edgeBuffer and inner exclusion
				if(col <= maxInnerExclusion) then
					print("coordinate " .. row .. ", " .. col .. " is within the second exclusion zone")
					isValidTerrain = false
				elseif((row < 1+edgeBuffer or row > (#terrainGrid - edgeBuffer)) or (col < 1+edgeBuffer or col > (#terrainGrid - edgeBuffer))) then
					print("coordinate " .. row .. ", " .. col .. " is outside the ring of acceptable starting donut terrain")
					isValidTerrain = false
					
				elseif( (row <= edgeBuffer + cornerThreshold + 1 and col <= edgeBuffer + cornerThreshold) or (row <= edgeBuffer + cornerThreshold and col <= edgeBuffer+ cornerThreshold + 1) or (row <= edgeBuffer + cornerThreshold +1 and col <= edgeBuffer + cornerThreshold +1) or
					(row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - 1 and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or
					(row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer + cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or
					(row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold)
					) then
					print("coordinate " .. row .. ", " .. col .. " is in the corner of the acceptable donut, removing")
					isValidTerrain = false
				end
				
				for impasseCheckRow = 1, gridSize do
					for impasseCheckCol = 1, gridSize do
						--check to see if this square is within impasseDistance
						currentDistance = GetDistance(row, col, impasseCheckRow, impasseCheckCol, 2)
						if(currentDistance <= impasseDistance) then
							currentTerrainType = terrainGrid[impasseCheckRow][impasseCheckCol].terrainType
							for terrainTypeIndex = 1, #impasseTypes do
								if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
									isValidTerrain = false
								end
							end
						end
						
					end
				end
				
				--if the current square is not impasse, add it to the list
				currentInfo = {}
				if(isValidTerrain == true) then
					currentInfo = {row, col}
					table.insert(openList2, currentInfo)
				end
			end
		end
		
	--split teams horizontally
	else
		
		--fill the first open list
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				--check if the current terrain square is a valid square (not impasse)
				isValidTerrain = true
				--		print("checking row " .. row .. ", col " .. col)
				--check for in bounds of edgeBuffer and inner exclusion
				if(row > minInnerExclusion) then
					print("coordinate " .. row .. ", " .. col .. " is within the exclusion zone")
					isValidTerrain = false
				elseif((row < 1+edgeBuffer or row > (#terrainGrid - edgeBuffer)) or (col < 1+edgeBuffer or col > (#terrainGrid - edgeBuffer))) then
					print("coordinate " .. row .. ", " .. col .. " is outside the ring of acceptable starting donut terrain")
					isValidTerrain = false
					
				elseif( (row <= edgeBuffer + cornerThreshold + 1 and col <= edgeBuffer + cornerThreshold) or (row <= edgeBuffer + cornerThreshold and col <= edgeBuffer+ cornerThreshold + 1) or (row <= edgeBuffer + cornerThreshold +1 and col <= edgeBuffer + cornerThreshold +1) or
					(row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - 1 and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or
					(row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer + cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or
					(row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold)
					) then
					print("coordinate " .. row .. ", " .. col .. " is in the corner of the acceptable donut, removing")
					isValidTerrain = false
				end
				
				for impasseCheckRow = 1, gridSize do
					for impasseCheckCol = 1, gridSize do
						--check to see if this square is within impasseDistance
						currentDistance = GetDistance(row, col, impasseCheckRow, impasseCheckCol, 2)
						if(currentDistance <= impasseDistance) then
							currentTerrainType = terrainGrid[impasseCheckRow][impasseCheckCol].terrainType
							for terrainTypeIndex = 1, #impasseTypes do
								if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
									isValidTerrain = false
								end
							end
						end
						
					end
				end
				
				--if the current square is not impasse, add it to the list
				currentInfo = {}
				if(isValidTerrain == true) then
					currentInfo = {row, col}
					table.insert(openList1, currentInfo)
				end
			end
		end
		
		
		--fill the second open list
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				--check if the current terrain square is a valid square (not impasse)
				isValidTerrain = true
				--		print("checking row " .. row .. ", col " .. col)
				--check for in bounds of edgeBuffer and inner exclusion
				if(row <= maxInnerExclusion) then
					print("coordinate " .. row .. ", " .. col .. " is within the exclusion zone")
					isValidTerrain = false
				elseif((row < 1+edgeBuffer or row > (#terrainGrid - edgeBuffer)) or (col < 1+edgeBuffer or col > (#terrainGrid - edgeBuffer))) then
					print("coordinate " .. row .. ", " .. col .. " is outside the ring of acceptable starting donut terrain")
					isValidTerrain = false
					
				elseif( (row <= edgeBuffer + cornerThreshold + 1 and col <= edgeBuffer + cornerThreshold) or (row <= edgeBuffer + cornerThreshold and col <= edgeBuffer+ cornerThreshold + 1) or (row <= edgeBuffer + cornerThreshold +1 and col <= edgeBuffer + cornerThreshold +1) or
					(row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - 1 and col <= edgeBuffer + cornerThreshold +1) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col <= edgeBuffer + cornerThreshold +1) or
					(row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer + cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row <= edgeBuffer+cornerThreshold +1 and col >= #terrainGrid - edgeBuffer - cornerThreshold) or
					(row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer) or (row >= #terrainGrid - edgeBuffer - cornerThreshold and col >= #terrainGrid - edgeBuffer - cornerThreshold)
					) then
					print("coordinate " .. row .. ", " .. col .. " is in the corner of the acceptable donut, removing")
					isValidTerrain = false
				end
				
				for impasseCheckRow = 1, gridSize do
					for impasseCheckCol = 1, gridSize do
						--check to see if this square is within impasseDistance
						currentDistance = GetDistance(row, col, impasseCheckRow, impasseCheckCol, 2)
						if(currentDistance <= impasseDistance) then
							currentTerrainType = terrainGrid[impasseCheckRow][impasseCheckCol].terrainType
							for terrainTypeIndex = 1, #impasseTypes do
								if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
									isValidTerrain = false
								end
							end
						end
						
					end
				end
				
				--if the current square is not impasse, add it to the list
				currentInfo = {}
				if(isValidTerrain == true) then
					currentInfo = {row, col}
					table.insert(openList2, currentInfo)
				end
			end
		end
		
	end
	--create a copy of the openList
	openList1Players = {}
	openList1Players = DeepCopy(openList1)
	
	openList2Players = {}
	openList2Players = DeepCopy(openList2)
	
	
	--do the base case, get the first and second elements into the list
	print("openList1 members: " .. #openList1)
	print("openList2 members: " .. #openList2)
	teamLocations = {}
	teamsPlaced = 0
	currentAttemptsAtTeamDistance = 0
	attemptThreshold = 10
	
	currentTeamIndex = 1

	
	--place team start points randomly on each side
	--randomPoint1 = Round((worldGetRandom() * #openList1 * 0.2), 0)
	randomPoint1 = 1
	if(randomPoint1 == 0) then
		randomPoint1 = 1
	end
	print("random index 1: " .. randomPoint1)
	currentRow = openList1[randomPoint1][1]
	currentCol = openList1[randomPoint1][2]
	currentInfo = {}
	currentInfo = {currentRow, currentCol}
	table.insert(teamLocations, currentInfo)
	
	randomPoint2 = (#openList2 - randomPoint1)
	if(randomPoint2 == 0) then
		randomPoint2 = 1
	end
	randomPoint2 = #openList2
	print("random index 2: " .. randomPoint2)
	currentRow = openList2[randomPoint2][1]
	currentCol = openList2[randomPoint2][2]
	currentInfo = {}
	currentInfo = {currentRow, currentCol}
	table.insert(teamLocations, currentInfo)
	
	--debug loop through and print out the openListPlayers
	--loop through openList
	for openIndex = 1, #openList1Players do
		currentRow = openList1Players[openIndex][1]
		currentCol = openList1Players[openIndex][2]
		
		print("current openList1Player point: " .. currentRow .. ", " .. currentCol)
	end
	
	--debug loop through and print out the openListPlayers
	--loop through openList
	for openIndex = 1, #openList2Players do
		currentRow = openList2Players[openIndex][1]
		currentCol = openList2Players[openIndex][2]
		
		print("current openList2Player point: " .. currentRow .. ", " .. currentCol)
	end
		
		--now, all teams should have a teamLocations entry
		--using the copy of the openList with all possible squares, place all players from a team starting at the teamLocations entry.
		--valid locations of players should be a combination of how close they are to their teamLocations entry and how far from opponents they are
		
	
	--make sure there is more than 1 team to loop through
	if(#localMappingTable >= 1) then
		
		--loop through this until all players are placed
        
        repeat
		playersPlaced = 0
			print("debug test for teamMappingTable right at reset point")
			for currentTeamIndex = 1, #localMappingTable do
				print("looking at player locations on team " .. currentTeamIndex)
				for currentPlayerIndex = 1, #localMappingTable[currentTeamIndex].players do
					print("looking at initial current locations for player " .. currentPlayerIndex)
					if(localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
						currentStartRow = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow
						currentStartCol = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol
						
						print("current player start row: " .. currentStartRow .. ", start col: " .. currentStartCol)
						
					end
				end
			end
			
		for teamIndex = 1, #localMappingTable do
		
			--make sure there are players on this team
			print("placing players from TEAM " .. teamIndex)
			if(localMappingTable[teamIndex].playerCount > 0) then
				
				--put the first player on the team in the current teamLocation
				if(teamIndex == 1) then
						
						print("openList1Players count is " .. #openList1Players)
						
							teamStartRow = teamLocations[teamIndex][1]
							teamStartCol = teamLocations[teamIndex][2]
							
							
							--grab first player on this team's info
							currentPlayerID = localMappingTable[teamIndex].players[1].playerID
							print("placing teamPlayerIndex 1 from team " .. teamIndex .. " at " .. teamStartRow .. ", " .. teamStartCol)
							terrainGrid[teamStartRow][teamStartCol].terrainType = playerStartTerrain
							terrainGrid[teamStartRow][teamStartCol].playerIndex = currentPlayerID - 1
							localMappingTable[teamIndex].players[1].startRow = teamStartRow
							localMappingTable[teamIndex].players[1].startCol = teamStartCol
							
							playersPlaced = playersPlaced + 1
							--remove any squares directly around this location
							entriesToRemove = {}
							--loop through openList1
							for openIndex = 1, #openList1Players do
								currentRow = openList1Players[openIndex][1]
								currentCol = openList1Players[openIndex][2]
								
								--get the distance from the current point to the selected random point
								currentDistance = GetDistance(currentRow, currentCol, teamStartRow, teamStartCol, 2)
								
								--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teammate
								--add it to the entriesToRemove list
								if(currentDistance < minPlayerDistance) then
									table.insert(entriesToRemove, openIndex)
								end
							end
							
							--iterate backwards through the openList1 and remove all entries found to be too close to this new player location
							for openRemovalIndex = #openList1Players, 1, -1 do
								
								--loop through entriesToRemove and see if this index matches any element
								matchesRemovalIndex = false
								for entriesIndex = 1, #entriesToRemove do
									if(entriesToRemove[entriesIndex] == openRemovalIndex) then
										
										matchesRemovalIndex = true
									end
								end
								--if a match was found, remove this index
								if(matchesRemovalIndex == true) then
									--	print("removing openList1Players entry " .. openRemovalIndex .. " around start location at " .. openList1Players[openRemovalIndex][1] .. ", " .. openList1Players[openRemovalIndex][2])
									table.remove(openList1Players, openRemovalIndex)
								end
								
							end
							
							--place players according to the closest positions from the team's starting point
							if(localMappingTable[teamIndex].playerCount >= 2) then
								for teamPlayerIndex = 2, localMappingTable[teamIndex].playerCount do
									
									--make a list of all points and their distances relative to each team position
									currentDistances = {}
									for teamDistanceIndex = 1, #localMappingTable do
										
										currentTeamStartRow = teamLocations[teamDistanceIndex][1]
										currentTeamStartCol = teamLocations[teamDistanceIndex][2]
										currentDistances[teamDistanceIndex] = {}
										for openPlayerIndex = 1, #openList1Players do
											
											currentRow = openList1Players[openPlayerIndex][1]
											currentCol = openList1Players[openPlayerIndex][2]
											
											currentDistance = GetDistance(currentRow, currentCol, currentTeamStartRow, currentTeamStartCol, 3)
											
											currentInfo = {}
											currentInfo = {currentDistance, openPlayerIndex}
											table.insert(currentDistances[teamDistanceIndex], currentInfo)
										end
									end
									
									--sort each team's currentDistances so highest distances are at the top of the list
									for distancesIndex = 1, #currentDistances do
										table.sort(currentDistances[distancesIndex], function(a,b) return a[1] < b[1] end)
									end
									
									positionScores = {}
									opponentDistanceMultiplier = 2.5
									--loop through each point and tally up scores for the current team
								--[[
									for playerScoreIndex = 1, #openList1Players do
										
										currentScore = 0
										currentRow = openList1Players[playerScoreIndex][1]
										currentCol = openList1Players[playerScoreIndex][2]
										--loop through each currentDistances team table
										for distanceTeamIndex = 1, #currentDistances do
											for distancePointIndex = 1, #currentDistances[distanceTeamIndex] do
												
												--	print("on team " .. distanceTeamIndex .. " at point " .. distancePointIndex .. " looking to match point index " .. currentDistances[distanceTeamIndex][distancePointIndex][2] .. " to base index " .. playerScoreIndex)
												--if looking at the current team, add this positional score
												if(distanceTeamIndex == teamIndex) then
													--check if the current point is the correct index

													if(playerScoreIndex == currentDistances[distanceTeamIndex][distancePointIndex][2]) then
														--	print("indices matched on correct team at index " .. playerScoreIndex .. ", adding " .. distancePointIndex .. " with a distance of " .. currentDistances[distanceTeamIndex][distancePointIndex][1])
														currentScore = currentScore + distancePointIndex
														--currentScore = currentScore + currentDistances[distanceTeamIndex][distancePointIndex][1]
													end
													
													--if this is an opposing team, subtract the score
												else
													
													--check if the current point is the correct index
													if(playerScoreIndex == currentDistances[distanceTeamIndex][distancePointIndex][2]) then
															print("indices matched on opposing team at index " .. playerScoreIndex .. ", subtracting " .. distancePointIndex .. " with a distance of " .. currentDistances[distanceTeamIndex][distancePointIndex][1])
														currentScore = currentScore - (distancePointIndex * opponentDistanceMultiplier)
														--currentScore = currentScore - (currentDistances[distanceTeamIndex][distancePointIndex][1] * opponentDistanceMultiplier)
													end
												end
											end
											
										end
										
										currentInfo = {currentScore, currentRow, currentCol}
										--	print("score of point " .. currentRow .. ", " .. currentCol .. " is " .. currentScore)
										table.insert(positionScores, currentInfo)
										
									end
									]]--
								
									for playerScoreIndex = 1, #openList1Players do
										
										currentScore = 0
										currentDivisor = 0
										currentAddition = 0
										currentRow = openList1Players[playerScoreIndex][1]
										currentCol = openList1Players[playerScoreIndex][2]
										print("CURRENT SQUARE: " .. currentRow .. ", " .. currentCol)
										for currentTeamIndex = 1, #localMappingTable do
											if(currentTeamIndex == teamIndex) then
												print("looking at player locations on team " .. currentTeamIndex)
												for currentPlayerIndex = 1, #localMappingTable[currentTeamIndex].players do
													
													if(localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
														currentStartRow = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow
														currentStartCol = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol
														
														currentPlayerDistance = GetDistance(currentRow, currentCol, currentStartRow, currentStartCol, 2)
													--	currentAddition = #terrainGrid - currentPlayerDistance
														currentAddition = currentPlayerDistance
														print("current score addition: " .. currentAddition .. " to current score " .. currentScore .. " from player " .. currentPlayerIndex .. " at " .. currentStartRow .. ", " .. currentStartCol)
														currentScore = currentScore + currentAddition
														
													end
												end
												
											--this is an opposing team
											else
												print("looking at player locations on team " .. currentTeamIndex)
												for currentPlayerIndex = 1, #localMappingTable[currentTeamIndex].players do
													
													if(localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
														currentStartRow = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow
														currentStartCol = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol
														
														currentPlayerDistance = GetDistance(currentRow, currentCol, currentStartRow, currentStartCol, 2)
														currentDivisor = currentDivisor + (#terrainGrid - currentPlayerDistance)
														print("current divisor: " .. currentDivisor .. " from current score " .. currentScore .. " from player " .. currentPlayerIndex .. " at " .. currentStartRow .. ", " .. currentStartCol)
														
													end
												end
											end
											
										end
										
										if(currentDivisor > 0) then
										--	currentDivisor = currentDivisor * opponentDistanceMultiplier
											currentDivisor = 1
											currentScore = currentScore / currentDivisor / currentDivisor
										end
										
										currentInfo = {}
										currentInfo = {currentScore, currentRow, currentCol}
										table.insert(positionScores, currentInfo)
										
									end
									
									-- break if there are less cells left than players to place.
									teamPlayersPlaced = teamPlayerIndex - 1
									if (#positionScores < localMappingTable[teamIndex].playerCount - teamPlayersPlaced) then
										break
									end
								
									table.sort(positionScores, function(a,b) return a[1] > b[1] end)
									--grab one of the top elements in the sorted list and assign a player there
									
									maxRandomSelection = math.ceil(#openList1Players * topSelectionThreshold)
									print("maxRandomSelection is " .. maxRandomSelection)
									
									print("printing top options for this player:")
									for topOptionIndex = 1, maxRandomSelection do
										currentTopScore = positionScores[topOptionIndex][1]
										currentTopRow = positionScores[topOptionIndex][2]
										currentTopCol = positionScores[topOptionIndex][3]
										print("top option " .. topOptionIndex .. ": row " .. currentTopRow .. ", col " .. currentTopCol .. " with score of " .. currentTopScore)
									end
									
									currentRandomSelection = math.ceil(worldGetRandom() * maxRandomSelection)
									print("currentRandomSelection is " .. currentRandomSelection)
									
									currentRow = positionScores[currentRandomSelection][2]
									currentCol = positionScores[currentRandomSelection][3]
									
									print("out of " .. maxRandomSelection .. " top entries, choosing index " .. currentRandomSelection .. " at " .. currentRow .. ", " .. currentCol .. " with a score of " .. positionScores[currentRandomSelection][1])
									
									print("placing teamPlayerIndex " .. teamPlayerIndex .. " from team " .. teamIndex .. " at "  .. currentRow .. ", " .. currentCol)
									currentPlayerID = localMappingTable[teamIndex].players[teamPlayerIndex].playerID
									localMappingTable[teamIndex].players[teamPlayerIndex].startRow = currentRow
									localMappingTable[teamIndex].players[teamPlayerIndex].startCol = currentCol
									terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
									terrainGrid[currentRow][currentCol].playerIndex = currentPlayerID - 1
									
									playersPlaced = playersPlaced + 1
									print("team 1 loop, total players placed: " .. playersPlaced)
									
									--loop through and remove openList1 elements close to this point
									entriesToRemove = {}
									
									--loop through openList1
									for openIndex = 1, #openList1Players do
										currentCheckRow = openList1Players[openIndex][1]
										currentCheckCol = openList1Players[openIndex][2]
										
										--get the distance from the current point to the selected random point
										currentDistance = GetDistance(currentRow, currentCol, currentCheckRow, currentCheckCol, 2)
										
										--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teammate
										--add it to the entriesToRemove list
										if(currentDistance < minPlayerDistance) then
											table.insert(entriesToRemove, openIndex)
										end
									end
									
									
									--loop through openList1Players backwards and remove any elements that were put in entriesToRemove
									for closedIndex = #openList1Players, 1, -1 do
										
										for removalIndex = 1, #entriesToRemove do
											
											currentRemovalIndex = entriesToRemove[removalIndex]
											if(closedIndex == currentRemovalIndex) then
												print("removing openList1Players entry " .. currentRemovalIndex .. " around player location at " .. openList1Players[currentRemovalIndex][1] .. ", " .. openList1Players[currentRemovalIndex][2])
												table.remove(openList1Players, closedIndex)
											end
										end
									end
									
								end
								
							end
							
							--TODO pending optimization: combine the loops more intelligently?
						
				else
						
						if (#openList2Players>=localMappingTable[teamIndex].playerCount) then
							
							
							
							print("placing the second team")
							teamStartRow = teamLocations[teamIndex][1]
							teamStartCol = teamLocations[teamIndex][2]
							
							
							--grab first player on this team's info
							currentPlayerID = localMappingTable[teamIndex].players[1].playerID
							print("placing teamPlayerIndex 1 from team " .. teamIndex .. " at " .. teamStartRow .. ", " .. teamStartCol)
							terrainGrid[teamStartRow][teamStartCol].terrainType = playerStartTerrain
							terrainGrid[teamStartRow][teamStartCol].playerIndex = currentPlayerID - 1
							localMappingTable[teamIndex].players[1].startRow = teamStartRow
							localMappingTable[teamIndex].players[1].startCol = teamStartCol
							
							playersPlaced = playersPlaced + 1
							--remove any squares directly around this location
							entriesToRemove = {}
							--loop through openList2
							for openIndex = 1, #openList2Players do
								currentRow = openList2Players[openIndex][1]
								currentCol = openList2Players[openIndex][2]
								
								--get the distance from the current point to the selected random point
								currentDistance = GetDistance(currentRow, currentCol, teamStartRow, teamStartCol, 2)
								
								--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teammate
								--add it to the entriesToRemove list
								if(currentDistance < minPlayerDistance) then
									table.insert(entriesToRemove, openIndex)
								end
							end
							
							--iterate backwards through the openList2 and remove all entries found to be too close to this new player location
							for openRemovalIndex = #openList2Players, 1, -1 do
								
								--loop through entriesToRemove and see if this index matches any element
								matchesRemovalIndex = false
								for entriesIndex = 1, #entriesToRemove do
									if(entriesToRemove[entriesIndex] == openRemovalIndex) then
										
										matchesRemovalIndex = true
									end
								end
								--if a match was found, remove this index
								if(matchesRemovalIndex == true) then
									--	print("removing openList2Players entry " .. openRemovalIndex .. " around start location at " .. openList2Players[openRemovalIndex][1] .. ", " .. openList2Players[openRemovalIndex][2])
									table.remove(openList2Players, openRemovalIndex)
								end
								
							end
							
							--place players according to the closest positions from the team's starting point
							if(localMappingTable[teamIndex].playerCount >= 2) then
								for teamPlayerIndex = 2, localMappingTable[teamIndex].playerCount do
									
									--make a list of all points and their distances relative to each team position
									currentDistances = {}
									for teamDistanceIndex = 1, #localMappingTable do
										
										currentTeamStartRow = teamLocations[teamDistanceIndex][1]
										currentTeamStartCol = teamLocations[teamDistanceIndex][2]
										currentDistances[teamDistanceIndex] = {}
										for openPlayerIndex = 1, #openList2Players do
											
											currentRow = openList2Players[openPlayerIndex][1]
											currentCol = openList2Players[openPlayerIndex][2]
											
											currentDistance = GetDistance(currentRow, currentCol, currentTeamStartRow, currentTeamStartCol, 3)
											
											currentInfo = {}
											currentInfo = {currentDistance, openPlayerIndex}
											table.insert(currentDistances[teamDistanceIndex], currentInfo)
										end
									end
									
									--sort each team's currentDistances so highest distances are at the top of the list
									for distancesIndex = 1, #currentDistances do
										table.sort(currentDistances[distancesIndex], function(a,b) return a[1] > b[1] end)
									end
									
									positionScores = {}
									opponentDistanceMultiplier = 2.5
									--loop through each point and tally up scores for the current team
									--[[
									for playerScoreIndex = 1, #openList2Players do
										
										currentScore = 0
										currentRow = openList2Players[playerScoreIndex][1]
										currentCol = openList2Players[playerScoreIndex][2]
										--loop through each currentDistances team table
										for distanceTeamIndex = 1, #currentDistances do
											for distancePointIndex = 1, #currentDistances[distanceTeamIndex] do
												
												--	print("on team " .. distanceTeamIndex .. " at point " .. distancePointIndex .. " looking to match point index " .. currentDistances[distanceTeamIndex][distancePointIndex][2] .. " to base index " .. playerScoreIndex)
												--if looking at the current team, add this positional score
												if(distanceTeamIndex == teamIndex) then
													--check if the current point is the correct index
													
													if(playerScoreIndex == currentDistances[distanceTeamIndex][distancePointIndex][2]) then
														--	print("indices matched on correct team at index " .. playerScoreIndex .. ", adding " .. distancePointIndex .. " with a distance of " .. currentDistances[distanceTeamIndex][distancePointIndex][1])
														currentScore = currentScore + distancePointIndex
														--currentScore = currentScore + currentDistances[distanceTeamIndex][distancePointIndex][1]
													end
													
													--if this is an opposing team, subtract the score
												else
													
													--check if the current point is the correct index
													if(playerScoreIndex == currentDistances[distanceTeamIndex][distancePointIndex][2]) then
														--	print("indices matched on opposing team at index " .. playerScoreIndex .. ", subtracting " .. distancePointIndex .. " with a distance of " .. currentDistances[distanceTeamIndex][distancePointIndex][1])
														currentScore = currentScore - (distancePointIndex * opponentDistanceMultiplier)
														--currentScore = currentScore - (currentDistances[distanceTeamIndex][distancePointIndex][1] * opponentDistanceMultiplier)
													end
												end
											end
											
										end
										
										currentInfo = {currentScore, currentRow, currentCol}
										--	print("score of point " .. currentRow .. ", " .. currentCol .. " is " .. currentScore)
										table.insert(positionScores, currentInfo)
										
									end
									]]--
									
									for playerScoreIndex = 1, #openList2Players do
									
										currentScore = 0
										currentDivisor = 0
										currentAddition = 0
										currentRow = openList2Players[playerScoreIndex][1]
										currentCol = openList2Players[playerScoreIndex][2]
										print("CURRENT SQUARE: " .. currentRow .. ", " .. currentCol)
										for currentTeamIndex = 1, #localMappingTable do
											if(currentTeamIndex == teamIndex) then
												print("looking at player locations on team " .. currentTeamIndex)
												for currentPlayerIndex = 1, #localMappingTable[currentTeamIndex].players do
													
													if(localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
														currentStartRow = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow
														currentStartCol = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol
														
														currentPlayerDistance = GetDistance(currentRow, currentCol, currentStartRow, currentStartCol, 2)
												--		currentAddition = #terrainGrid - currentPlayerDistance
														currentAddition = currentPlayerDistance
														print("current score addition: " .. currentAddition .. " to current score " .. currentScore .. " from player " .. currentPlayerIndex .. " at " .. currentStartRow .. ", " .. currentStartCol)
														currentScore = currentScore + currentAddition
														
													end
												end
												
											--this is an opposing team
											else
												print("looking at player locations on team " .. currentTeamIndex)
												for currentPlayerIndex = 1, #localMappingTable[currentTeamIndex].players do
													
													if(localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
														currentStartRow = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow
														currentStartCol = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol
														
														currentPlayerDistance = GetDistance(currentRow, currentCol, currentStartRow, currentStartCol, 2)
														currentDivisor = currentDivisor + (#terrainGrid - currentPlayerDistance)
														print("current divisor: " .. currentDivisor .. " from current score " .. currentScore .. " from player " .. currentPlayerIndex .. " at " .. currentStartRow .. ", " .. currentStartCol)
														
													end
												end
											end
											
										end
										
										if(currentDivisor > 0) then
										--	currentDivisor = currentDivisor * opponentDistanceMultiplier
											currentDivisor = 1
											currentScore = currentScore / currentDivisor / currentDivisor
										end
										
										currentInfo = {}
										currentInfo = {currentScore, currentRow, currentCol}
										table.insert(positionScores, currentInfo)
										
									end
									
									-- break if there are less cells left than players to place.
									teamPlayersPlaced = teamPlayerIndex - 1
									if (#positionScores < localMappingTable[teamIndex].playerCount - teamPlayersPlaced) then
										break
									end
									
									table.sort(positionScores, function(a,b) return a[1] > b[1] end)
									--grab one of the top elements in the sorted list and assign a player there
									
									maxRandomSelection = math.ceil(#openList2Players * topSelectionThreshold)
									
									print("printing top options for this player:")
									for topOptionIndex = 1, maxRandomSelection do
										currentTopScore = positionScores[topOptionIndex][1]
										currentTopRow = positionScores[topOptionIndex][2]
										currentTopCol = positionScores[topOptionIndex][3]
										print("top option " .. topOptionIndex .. ": row " .. currentTopRow .. ", col " .. currentTopCol .. " with score of " .. currentTopScore)
									end
									
									currentRandomSelection = math.ceil(worldGetRandom() * maxRandomSelection)
									
									currentRow = positionScores[currentRandomSelection][2]
									currentCol = positionScores[currentRandomSelection][3]
									
									print("out of " .. maxRandomSelection .. " top entries, choosing index " .. currentRandomSelection .. " at " .. currentRow .. ", " .. currentCol .. " with a score of " .. positionScores[currentRandomSelection][1])
									
									print("placing teamPlayerIndex " .. teamPlayerIndex .. " from team " .. teamIndex .. " at "  .. currentRow .. ", " .. currentCol)
									currentPlayerID = localMappingTable[teamIndex].players[teamPlayerIndex].playerID
									localMappingTable[teamIndex].players[teamPlayerIndex].startRow = currentRow
									localMappingTable[teamIndex].players[teamPlayerIndex].startCol = currentCol
									terrainGrid[currentRow][currentCol].terrainType = playerStartTerrain
									terrainGrid[currentRow][currentCol].playerIndex = currentPlayerID - 1
									
									playersPlaced = playersPlaced + 1
									print("team 2 loop, total players placed: " .. playersPlaced)
									
									--loop through and remove openList2 elements close to this point
									entriesToRemove = {}
									
									--loop through openList2
									for openIndex = 1, #openList2Players do
										currentCheckRow = openList2Players[openIndex][1]
										currentCheckCol = openList2Players[openIndex][2]
										
										--get the distance from the current point to the selected random point
										currentDistance = GetDistance(currentRow, currentCol, currentCheckRow, currentCheckCol, 2)
										
										--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teammate
										--add it to the entriesToRemove list
										if(currentDistance < minPlayerDistance) then
											table.insert(entriesToRemove, openIndex)
										end
									end
									
									
									--loop through openList2Players backwards and remove any elements that were put in entriesToRemove
									for closedIndex = #openList2Players, 1, -1 do
										
										for removalIndex = 1, #entriesToRemove do
											
											currentRemovalIndex = entriesToRemove[removalIndex]
											if(closedIndex == currentRemovalIndex) then
												print("removing openList2Players entry " .. currentRemovalIndex .. " around player location at " .. openList2Players[currentRemovalIndex][1] .. ", " .. openList2Players[currentRemovalIndex][2])
												table.remove(openList2Players, closedIndex)
											end
										end
									end
									
								end	
							end
							
							
						end
						
						
						
						
						
				end
			end
		end
			print("players placed at the end of this loop: " .. playersPlaced .. " out of " .. worldPlayerCount)
	    if(playersPlaced < worldPlayerCount) then
	                            
	        --reset the search
	        terrainGrid = {}
	        terrainGrid = DeepCopy(preStartTerrainTable)
		--	localMappingTable = {}
		--	print("tableID for teamMappingTable before deepcopy is " .. tostring(localMappingTable))
		--	localMappingTable = DeepCopy(originalTeamMappingTable)
			print("tableID for teamMappingTable after deepcopy is " .. tostring(localMappingTable))
	        openList1Players = {}
	        openList1Players = DeepCopy(openList1)
	        openList2Players = {}
	        openList2Players = DeepCopy(openList2)				
	        playersPlaced = 0
	        minPlayerDistance = minPlayerDistance - playerSpaceShrinking
	        print("player distance: " .. minPlayerDistance)
	        print("SHRINKING PLAYER SPACING - END OF LOOP")
	        
			print("reseting start row and start col of mapping table")
			for currentTeamIndex = 1, #localMappingTable do
				for currentPlayerIndex = 1, #localMappingTable[currentTeamIndex].players do
					print("reseting row and col info for player " .. currentPlayerIndex)
					if(localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
						localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow = nil
					end
					if(localMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol ~= nil) then
						localMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol = nil
					end
						
				end
			end
	    end
	        
	    until playersPlaced == worldPlayerCount	
	end
	
	for currentTeamIndex = 1, #localMappingTable do
		print("looking at player locations on team " .. currentTeamIndex)
		for currentPlayerIndex = 1, #localMappingTable[currentTeamIndex].players do
			print("looking at final locations for player " .. currentPlayerIndex)
			if(localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
				currentStartRow = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow
				currentStartCol = localMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol
				
				print("current player start row: " .. currentStartRow .. ", start col: " .. currentStartCol)
				
			end
		end
	end
	
	print("tableID for teamMappingTable inside spawn function is " .. tostring(localMappingTable))
	
	print("printing originalMappingTable")
	for currentTeamIndex = 1, #originalTeamMappingTable do
		print("looking at player locations on team " .. currentTeamIndex)
		for currentPlayerIndex = 1, #originalTeamMappingTable[currentTeamIndex].players do
			print("looking at final locations for player " .. currentPlayerIndex)
			if(originalTeamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
				currentStartRow = originalTeamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow
				currentStartCol = originalTeamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol
				
				print("current player start row: " .. currentStartRow .. ", start col: " .. currentStartCol)
				
			end
		end
	end
	
		
	
	if(placeBufferTerrain == true) then
        --set buffer terrain according to parameters
        for row = 1, #terrainGrid do
            for col = 1, #terrainGrid do
                
                --get all squares in correct radius around the start positions
                if(terrainGrid[row][col].terrainType == playerStartTerrain) then
                    bufferSquares = GetAllSquaresInRadius(row, col, startBufferRadius, terrainGrid)
                    for bIndex = 1, #bufferSquares do
                        bufrow = bufferSquares[bIndex][1]
                        bufcol = bufferSquares[bIndex][2]
                        
                        if (terrainGrid[bufrow][bufcol].terrainType ~= playerStartTerrain) then
                            terrainGrid[bufrow][bufcol].terrainType = startBufferTerrain
                        end
                        
                    end
                end
            end
        end
    end
	print("end player placement")
	return terrainGrid

end



function GetStartLocations(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, impasseTypes, impasseDistance, topSelectionThreshold, terrainGrid)
	
	
	--create a list of all viable start locations
	openList = {}
	
	currentMinPlayerDistance = minPlayerDistance
	currentMinTeamDistance = minTeamDistance
	
	playerSpaceShrinking = 0.2
	teamSpaceShrinking = 0.2
	
	halfInnerExclusion = innerExclusion / 2
	halfGridSize = Round(#terrainGrid / 2, 0)
	minInnerExclusion = Round(((0.5 - halfInnerExclusion) * #terrainGrid), 0)
	maxInnerExclusion = Round(((0.5 + halfInnerExclusion) * #terrainGrid), 0)
	
	print("inner exclusion zone from " .. minInnerExclusion .. " to " .. maxInnerExclusion)
	
	
	preStartTerrainTable = DeepCopy(terrainGrid)
	
	::restartPlayerPlacement::
	
	if(currentMinPlayerDistance < 0) then
		currentMinPlayerDistance = minPlayerDistance	
	end
	
	if(currentMinTeamDistance < 0) then
		currentMinTeamDistance = minTeamDistance + 1
	end
	
	print("current min player distance: " .. currentMinPlayerDistance .. ", current min team distance: " .. currentMinTeamDistance)
	
	--fill the open list
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			--check if the current terrain square is a valid square (not impasse)
			isValidTerrain = true
	--		print("checking row " .. row .. ", col " .. col)
			--check for in bounds of edgeBuffer and inner exclusion
			if(((row > minInnerExclusion) and (row <= maxInnerExclusion)) and ((col > minInnerExclusion) and (col <= maxInnerExclusion))) then
				print("coordinate " .. row .. ", " .. col .. " is within the exclusion zone")
				isValidTerrain = false
			elseif((row < 1+edgeBuffer or row > (#terrainGrid - edgeBuffer)) or (col < 1+edgeBuffer or col > (#terrainGrid - edgeBuffer))) then
				print("coordinate " .. row .. ", " .. col .. " is outside the ring of acceptable starting donut terrain")
				isValidTerrain = false
			end
				
			
			
			
			--check for neighboring impasse
			
			--loop through all squares and find those that are closer than impasseDistance. If any of these are one of the impasse types then set isValidTerrain to false
			--[[
			testNeighbors = Get12Neighbors(row, col, terrainGrid)
			
			for testNeighborIndex, testNeighbor in ipairs(testNeighbors) do
				
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainGrid[testNeighborRow][testNeighborCol].terrainType
				for terrainTypeIndex = 1, #impasseTypes do
					if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
						isValidTerrain = false
					end
				end
			end
			]]--
			for impasseCheckRow = 1, gridSize do
				for impasseCheckCol = 1, gridSize do
					--check to see if this square is within impasseDistance
					currentDistance = GetDistance(row, col, impasseCheckRow, impasseCheckCol, 2)
					if(currentDistance <= impasseDistance) then
						currentTerrainType = terrainGrid[impasseCheckRow][impasseCheckCol].terrainType
						for terrainTypeIndex = 1, #impasseTypes do
							if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
								isValidTerrain = false
							end
						end
					end
					
				end
			end
			
			--if the current square is not impasse, add it to the list
			currentInfo = {}
			if(isValidTerrain == true) then
				currentInfo = {row, col}
				table.insert(openList, currentInfo)
			end
		end
	end
	
	--create a copy of the openList
	openListPlayers = {}
	openListPlayers = DeepCopy(openList)
	
	
	--do the base case, get the first and second elements into the list
	print("openList members: " .. #openList)
	teamLocations = {}
	teamsPlaced = 0
	currentAttemptsAtTeamDistance = 0
	attemptThreshold = 10
	
	currentTeamIndex = 1
	--do different spawning algorithms based on if teams are together or apart
	--THIS SHOULD BE FALSE TO BE CORRECT
	--THIS IS TEAMS TOGETHER
	if(randomPositions == false) then
		
		currentTeam = 1
		
		repeat
			
			--check and make sure there are still places in the openList
			if(#openList > 0) then
				--pick a random spot for the first team and assign to the teamLocations table
				--get a random place in a ring around the rough outer edge of the map
				randomIndex = math.ceil(worldGetRandom() * #openList)
				randomRow = openList[randomIndex][1]
				randomCol = openList[randomIndex][2]
				
				--create a teamLocations list to hold chosen spots
				
				print("looking at team " .. currentTeam)
				
				currentInfo = {}
				currentInfo = {randomRow, randomCol}
				table.insert(teamLocations, currentInfo)
				teamMappingTable[currentTeam].teamLocation = {}
				teamMappingTable[currentTeam].teamLocation = currentInfo
				table.remove(openList, randomIndex)
				
				entriesToRemove = {}
				--remove any openList locations that are closer than minTeamDistance away
				--loop through openList
				for openIndex = 1, #openList do
					currentRow = openList[openIndex][1]
					currentCol = openList[openIndex][2]
					
					--get the distance from the current point to the selected random point
					currentDistance = GetDistance(currentRow, currentCol, randomRow, randomCol, 2)
					
					--if this point is closer than the minTeamDistance, then it is not valid for selecting another teamLocation
					--add it to the entriesToRemove list
					if(currentDistance < minTeamDistance) then
						table.insert(entriesToRemove, openIndex)
					end
				end
				
				--iterate backwards through the openList and remove all entries found to be too close to this new teamLocation
				for openRemovalIndex = #openList, 1, -1 do
					
					--loop through entriesToRemove and see if this index matches any element
					matchesRemovalIndex = false
					for entriesIndex = 1, #entriesToRemove do
						if(entriesToRemove[entriesIndex] == openRemovalIndex) then
							
							matchesRemovalIndex = true
						end
					end
					--if a match was found, remove this index
					if(matchesRemovalIndex == true) then
						table.remove(openList, openRemovalIndex)
					end
					
				end
				
				--iterate necessary variables to find the next team
				teamsPlaced = teamsPlaced + 1
				currentTeam = currentTeam + 1
				print("placed location for team " .. teamsPlaced .. " at " .. randomRow .. ", " .. randomCol)
				
			--if there is no more spaces in the openList then restart the search
			else
				
				--reset the openList
				openList = {}
				openList = DeepCopy(openListPlayers)
				currentAttemptsAtTeamDistance = currentAttemptsAtTeamDistance + 1
				teamsPlaced = 0
				teamLocations = {}
				print("reset " .. currentAttemptsAtTeamDistance .. " at teamDistance " .. minTeamDistance)
				currentTeam = 1
			end
			
			
			
			--ensure all team locations are placed. If not, try x amount of times, then reduce minTeamDistance slightly and try again
			if(currentAttemptsAtTeamDistance > attemptThreshold) then
				minTeamDistance = minTeamDistance - teamSpaceShrinking
				currentAttemptsAtTeamDistance = 0
				teamsPlaced = 0
				currentTeamIndex = 1
				teamLocations = {}
			end
			
		until (teamsPlaced == #teamMappingTable)
		
		
		--debug loop through and print out the openListPlayers
		--loop through openList
		for openIndex = 1, #openListPlayers do
			currentRow = openListPlayers[openIndex][1]
			currentCol = openListPlayers[openIndex][2]
			
		--	print("current openListPlayer point: " .. currentRow .. ", " .. currentCol)
		end
		
		--now, all teams should have a teamLocations entry
		--using the copy of the openList with all possible squares, place all players from a team starting at the teamLocations entry.
		--valid locations of players should be a combination of how close they are to their teamLocations entry and how far from opponents they are
		
		openListCopy = {}
		openListCopy = DeepCopy(openListPlayers)
		
		--make sure there is more than 1 team to loop through
		if(#teamMappingTable >= 1) then
			
			--loop through this until all players are placed
			playersPlaced = 0
			repeat
				
				
				for teamIndex = 1, #teamMappingTable do
					--make sure there are players on this team
					print("plcing players from TEAM " .. teamIndex)
					if(teamMappingTable[teamIndex].playerCount > 0) then
						
						--put the first player on the team in the current teamLocation
						
						teamStartRow = teamLocations[teamIndex][1]
						teamStartCol = teamLocations[teamIndex][2]
						
						
						--grab first player on this team's info
						currentPlayerID = teamMappingTable[teamIndex].players[1].playerID
						print("placing teamPlayerIndex 1 from team " .. teamIndex .. " at " .. teamStartRow .. ", " .. teamStartCol)
						teamMappingTable[teamIndex].players[1].startRow = teamStartRow
						teamMappingTable[teamIndex].players[1].startCol = teamStartCol
						
						playersPlaced = playersPlaced + 1
						--remove any squares directly around this location
						entriesToRemove = {}
						--loop through openList
						for openIndex = 1, #openListPlayers do
							currentRow = openListPlayers[openIndex][1]
							currentCol = openListPlayers[openIndex][2]
							
							--get the distance from the current point to the selected random point
							currentDistance = GetDistance(currentRow, currentCol, teamStartRow, teamStartCol, 2)
							
							--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teammate
							--add it to the entriesToRemove list
							if(currentDistance < minPlayerDistance) then
								table.insert(entriesToRemove, openIndex)
							end
						end
						
						--iterate backwards through the openList and remove all entries found to be too close to this new player location
						for openRemovalIndex = #openListPlayers, 1, -1 do
							
							--loop through entriesToRemove and see if this index matches any element
							matchesRemovalIndex = false
							for entriesIndex = 1, #entriesToRemove do
								if(entriesToRemove[entriesIndex] == openRemovalIndex) then
									
									matchesRemovalIndex = true
								end
							end
							--if a match was found, remove this index
							if(matchesRemovalIndex == true) then
								--	print("removing openListPlayers entry " .. openRemovalIndex .. " around start location at " .. openListPlayers[openRemovalIndex][1] .. ", " .. openListPlayers[openRemovalIndex][2])
								table.remove(openListPlayers, openRemovalIndex)
							end
							
						end
						
						--place players according to the closest positions from the team's starting point
						if(teamMappingTable[teamIndex].playerCount >= 2) then
							for teamPlayerIndex = 2, teamMappingTable[teamIndex].playerCount do
								
								--[[
							currentDistances = {}
							--loop through openListPlayers and record the distance of each remaining point to this teamStartingPoint
							for openPlayerIndex = 1, #openListPlayers do
								
								currentRow = openListPlayers[openPlayerIndex][1]
								currentCol = openListPlayers[openPlayerIndex][2]
								
								currentDistance = GetDistance(currentRow, currentCol, teamStartRow, teamStartCol, 2)
								
								currentInfo = {}
								currentInfo = {currentDistance, openPlayerIndex}
								table.insert(currentDistances, currentInfo)
							end
							
							--sort currentDistances so that the closest distances are first
							table.sort(currentDistances, function(a,b) return a[1] < b[1] end)
							
							--grab one of the top elements in the sorted list and assign a player there
							
							topSelectionThreshold = 0.15
							maxRandomSelection = math.ceil(#currentDistances * topSelectionThreshold)
							
							currentRandomSelection = math.ceil(worldGetRandom() * maxRandomSelection)
							
							
							selectedOpenListIndex = currentDistances[currentRandomSelection][2]
							currentRow = openListPlayers[selectedOpenListIndex][1]
							currentCol = openListPlayers[selectedOpenListIndex][2]
							--]]
								
								--make a list of all points and their distances relative to each team position
								currentDistances = {}
								for teamDistanceIndex = 1, #teamMappingTable do
									
									currentTeamStartRow = teamLocations[teamDistanceIndex][1]
									currentTeamStartCol = teamLocations[teamDistanceIndex][2]
									currentDistances[teamDistanceIndex] = {}
									for openPlayerIndex = 1, #openListPlayers do
										
										currentRow = openListPlayers[openPlayerIndex][1]
										currentCol = openListPlayers[openPlayerIndex][2]
										
										currentDistance = GetDistance(currentRow, currentCol, currentTeamStartRow, currentTeamStartCol, 3)
										
										currentInfo = {}
										currentInfo = {currentDistance, openPlayerIndex}
										table.insert(currentDistances[teamDistanceIndex], currentInfo)
									end
								end
								
								--sort each team's currentDistances so highest distances are at the top of the list
								for distancesIndex = 1, #currentDistances do
									table.sort(currentDistances[distancesIndex], function(a,b) return a[1] > b[1] end)
								end
								
								positionScores = {}
								opponentDistanceMultiplier = 2.5
								--loop through each point and tally up scores for the current team
								for playerScoreIndex = 1, #openListPlayers do
									
									currentScore = 0
									currentRow = openListPlayers[playerScoreIndex][1]
									currentCol = openListPlayers[playerScoreIndex][2]
									
									lowestPlayerDistance = 10000
									--loop through each currentDistances team table
									
									for testTeamIndex = 1, #teamMappingTable do
										if(testTeamIndex == teamIndex) then
											
											print("looking at player locations on team " .. teamIndex)
											for currentTestPlayerIndex = 1, #teamMappingTable[testTeamIndex].players do
												if(teamMappingTable[testTeamIndex].players[currentTestPlayerIndex].startRow ~= nil) then
													currentTestRow = teamMappingTable[testTeamIndex].players[currentTestPlayerIndex].startRow
													currentTestCol = teamMappingTable[testTeamIndex].players[currentTestPlayerIndex].startCol
													
													currentTestDistance = GetDistance(currentTestRow, currentTestCol, currentRow, currentCol, 2)
													
													if(currentTestDistance < lowestPlayerDistance) then
														currentScore = currentTestDistance
														lowestPlayerDistance = currentTestDistance
													end
												end
											end
										end
									end
									
									currentInfo = {currentScore, currentRow, currentCol}
									--	print("score of point " .. currentRow .. ", " .. currentCol .. " is " .. currentScore)
									table.insert(positionScores, currentInfo)
									
								end
								
								if(#positionScores < worldPlayerCount) then
									print("insufficient position scores, only " .. #positionScores .. " score entries")
									break
								end
								
								table.sort(positionScores, function(a,b) return a[1] < b[1] end)
								--grab one of the top elements in the sorted list and assign a player there
								
								maxRandomSelection = math.ceil(#openListPlayers * topSelectionThreshold)
								
								print("printing top options for this player:")
								for topOptionIndex = 1, maxRandomSelection do
									currentTopScore = positionScores[topOptionIndex][1]
									currentTopRow = positionScores[topOptionIndex][2]
									currentTopCol = positionScores[topOptionIndex][3]
									print("top option " .. topOptionIndex .. ": row " .. currentTopRow .. ", col " .. currentTopCol .. " with score of " .. currentTopScore)
								end
								
								currentRandomSelection = math.ceil(worldGetRandom() * maxRandomSelection)
								
								currentRow = positionScores[currentRandomSelection][2]
								currentCol = positionScores[currentRandomSelection][3]
								
								print("out of " .. maxRandomSelection .. " top entries, choosing index " .. currentRandomSelection .. " at " .. currentRow .. ", " .. currentCol .. " with a score of " .. positionScores[currentRandomSelection][1])
								
								print("placing teamPlayerIndex " .. teamPlayerIndex .. " from team " .. teamIndex .. " at "  .. currentRow .. ", " .. currentCol)
								currentPlayerID = teamMappingTable[teamIndex].players[teamPlayerIndex].playerID
								teamMappingTable[teamIndex].players[teamPlayerIndex].startRow = currentRow
								teamMappingTable[teamIndex].players[teamPlayerIndex].startCol = currentCol
								
								playersPlaced = playersPlaced + 1
								print("players placed: " .. playersPlaced)
								--loop through and remove openList elements close to this point
								entriesToRemove = {}
								
								--loop through openList
								for openIndex = 1, #openListPlayers do
									currentCheckRow = openListPlayers[openIndex][1]
									currentCheckCol = openListPlayers[openIndex][2]
									
									--get the distance from the current point to the selected random point
									currentDistance = GetDistance(currentRow, currentCol, currentCheckRow, currentCheckCol, 2)
									
									--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teammate
									--add it to the entriesToRemove list
									if(currentDistance < minPlayerDistance) then
										table.insert(entriesToRemove, openIndex)
									end
								end
								
								
								--loop through openListPlayers backwards and remove any elements that were put in entriesToRemove
								for closedIndex = #openListPlayers, 1, -1 do
									
									for removalIndex = 1, #entriesToRemove do
										
										currentRemovalIndex = entriesToRemove[removalIndex]
										if(closedIndex == currentRemovalIndex) then
											print("removing openListPlayers entry " .. currentRemovalIndex .. " around player location at " .. openListPlayers[currentRemovalIndex][1] .. ", " .. openListPlayers[currentRemovalIndex][2])
											table.remove(openListPlayers, closedIndex)
										end
									end
								end
								--[[
								--check and ensure that there are still more entries in the open list to search through.
								if(#openListPlayers < worldPlayerCount) then
									
									--reset the search
									terrainGrid = {}
									terrainGrid = DeepCopy(preStartTerrainTable)
									openListPlayers = {}
									openListPlayers = DeepCopy(openListCopy)
									playersPlaced = 0
									minPlayerDistance = minPlayerDistance - playerSpaceShrinking
									print("player distance: " .. minPlayerDistance)
									print("SHRINKING PLAYER SPACING")
									break
								end
								]]--
							end
						end
						
					end
				end
				
				
						
			if(playersPlaced < worldPlayerCount) then
									
				--reset the search
				terrainGrid = {}
				terrainGrid = DeepCopy(preStartTerrainTable)
				openListPlayers = {}
				openListPlayers = DeepCopy(openListCopy)
				playersPlaced = 0
				minPlayerDistance = minPlayerDistance - playerSpaceShrinking
				print("player distance: " .. minPlayerDistance)
				print("SHRINKING PLAYER SPACING - END OF LOOP")
				
				for currentTeamIndex = 1, #teamMappingTable do
					for currentPlayerIndex = 1, #teamMappingTable[currentTeamIndex].players do
						print("reseting row and col info for player " .. currentPlayerIndex)
						if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow ~= nil) then
							teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startRow = nil
						end
						if(teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol ~= nil) then
							teamMappingTable[currentTeamIndex].players[currentPlayerIndex].startCol = nil
						end
							
					end
				end
			    
			end
				
			until playersPlaced == worldPlayerCount
		end
		
		
	--THIS IS TEAMS APART
	else
		
		playerLocations = {}
		playersPlaced = 0
		
		repeat
			
			--check and make sure there are still places in the openList
			if(#openList > 0) then
				--pick a random spot for the first team and assign to the playerLocations table
				--get a random place in a ring around the rough outer edge of the map
				randomIndex = math.ceil(worldGetRandom() * #openList)
				randomRow = openList[randomIndex][1]
				randomCol = openList[randomIndex][2]
				
				--create a playerLocations list to hold chosen spots
				
				currentInfo = {}
				currentInfo = {randomRow, randomCol}
				table.insert(playerLocations, currentInfo)
				table.remove(openList, randomIndex)
				
				entriesToRemove = {}
				--remove any openList locations that are closer than minPlayerDistance away
				--loop through openList
				for openIndex = 1, #openList do
					currentRow = openList[openIndex][1]
					currentCol = openList[openIndex][2]
					
					--get the distance from the current point to the selected random point
					currentDistance = GetDistance(currentRow, currentCol, randomRow, randomCol, 2)
					
					--if this point is closer than the minPlayerDistance, then it is not valid for selecting another teamLocation
					--add it to the entriesToRemove list
					if(currentDistance < minPlayerDistance) then
						table.insert(entriesToRemove, openIndex)
					end
				end
				
				--iterate backwards through the openList and remove all entries found to be too close to this new teamLocation
				for openRemovalIndex = #openList, 1, -1 do
					
					--loop through entriesToRemove and see if this index matches any element
					matchesRemovalIndex = false
					for entriesIndex = 1, #entriesToRemove do
						if(entriesToRemove[entriesIndex] == openRemovalIndex) then
							
							matchesRemovalIndex = true
						end
					end
					--if a match was found, remove this index
					if(matchesRemovalIndex == true) then
						table.remove(openList, openRemovalIndex)
					end
					
				end
				
				--iterate necessary variables to find the next team
				playersPlaced = playersPlaced + 1
				print("placed location for player " .. playersPlaced .. " at " .. randomRow .. ", " .. randomCol)
				
			--if there is no more spaces in the openList then restart the search
			else
				
				--reset the openList
				openList = {}
				openList = DeepCopy(openListPlayers)
				currentAttemptsAtTeamDistance = currentAttemptsAtTeamDistance + 1
				playersPlaced = 0
				playerLocations = {}
				print("reset " .. currentAttemptsAtTeamDistance .. " at playerDistance " .. minPlayerDistance)
			end
			
			
			
			--ensure all team locations are placed. If not, try x amount of times, then reduce minPlayerDistance slightly and try again
			if(currentAttemptsAtTeamDistance > attemptThreshold) then
				minPlayerDistance = minPlayerDistance - playerSpaceShrinking
				currentAttemptsAtTeamDistance = 0
				playersPlaced = 0
				currentTeamIndex = 1
				playerLocations = {}
			end
			
		until (playersPlaced == worldPlayerCount)
		
		
		swapIndexTable = {}
		if(worldPlayerCount > 7) then
			swapIndexTable = {2, 4}
		else
			swapIndexTable = {2}
		end
		
	--	SwapTable(playerLocations, swapIndexTable)
	--	ShuffleTable(playerLocations)
		
		--place players randomly in the playerPositions that were found
		if(#teamMappingTable >= 1) then
			currentPlayerCount = 1
			for teamIndex = 1, #teamMappingTable do
				--make sure there are players on this team
				print("placing players from TEAM " .. teamIndex)
				if(teamMappingTable[teamIndex].playerCount > 0) then
					for currentTeamPlayerIndex = 1, #teamMappingTable[teamIndex].players do
						
						--put the first player on the team in the current teamLocation
						
						playerStartRow = playerLocations[currentPlayerCount][1]
						playerStartCol = playerLocations[currentPlayerCount][2]
						
						
						--grab first player on this team's info
						currentPlayerID = teamMappingTable[teamIndex].players[currentTeamPlayerIndex].playerID
						print("placing teamPlayerIndex " .. currentTeamPlayerIndex .. " from team " .. teamIndex .. " at " .. playerStartRow .. ", " .. playerStartCol)
						teamMappingTable[teamIndex].players[currentTeamPlayerIndex].startRow = playerStartRow
						teamMappingTable[teamIndex].players[currentTeamPlayerIndex].startCol = playerStartCol
						
						currentPlayerCount = currentPlayerCount + 1
					end
				end
			end
		end
		
		
	end
	

	return teamMappingTable


end


--simple wrapper function that calls the lake function based on how many lakes are requested
function CreateLakes(minLakeNum, maxLakeNum, minLakeSize, maxLakeSize, impasseTerrain, openTerrain, maxLakeCoverage, terrainGrid)
	
	--create some lakes
	
	lakeNum = minLakeNum + (math.ceil(worldGetRandom() * (maxLakeNum - minLakeNum)))
	lakeRadius = minLakeSize + (math.ceil(worldGetRandom() * (maxLakeSize - lakeNum)))
	availableLakeSquares = maxLakeCoverage
	--loop to make the requested amount of lakes
	for lakeIndex = 1, lakeNum do
		
		chosenLakeSize = CreateLake(maxLakeSize, minLakeSize, impasseTerrain, openTerrain, tt_lake_shallow, lakeNum, availableLakeSquares, terrainGrid)
		availableLakeSquares = availableLakeSquares - chosenLakeSize
	end
	
end

--CreateRivers function will put a specified number of rivers into your map with river path being dictated by the parameters
--riverNum is the overall number of main (eg map edge to map edge) rivers you want to see in the map
--tributaryNum is the number of tributaries (eg rivers that start or end on another river instead of the map edge) to spawn in the map
--pathVariation is a value from 0 to 1 that determines how much the river either stays as a straight line across the map (0) or deviates in either direction (1)
--directionRandomness is a value from 0 to 1 that determines how windy the river is along its path - 0 will result in a fairly straight river, 1 will be very windy
function CreateRivers(riverNum, tributaryNum, pathVariation, directionRandomness, placeBridges, terrainGrid)
	
	local function isCoordOnRiver(targetRiver, coord)
		testRow = coord[1]
		testCol = coord[2]
		
		isOnRiver = false
			
		for index = 1, #targetRiver do
			currentRow = targetRiver[index][1]
			currentCol = targetRiver[index][2]
			
			if(testRow == currentRow and testCol == currentCol) then
				print(testRow .. ", " .. testCol .. " is the point passed in, found on target river at " .. currentRow .. ", " .. currentCol)
				isOnRiver = true
			end
			
		end
			
		return isOnRiver
	end
	
	riverResult = {}
	fordResults = {}
	woodBridgeResults = {}
	stoneBridgeResults = {}
	
	pathVariation = math.ceil(#terrainGrid * pathVariation)
	directionRandomness = math.ceil(#terrainGrid * directionRandomness)
	--to ensure rivers don't start or end in corners, which can cause issues
	minEdge = 2
	maxEdge = #terrainGrid - 1
	
	--the main table to hold sections of river needings to be crossable
	riverSegments = {}
	
	--main river loop
	for riverIndex = 1, riverNum do
		::restartRiverLoop::
		print("STARTING RIVER " .. riverIndex)
		pathedRiver = {}
		--choose which edge to start the river on
		startingEdge = math.ceil(worldGetRandom() * 4)
		if(startingEdge == 1) then
			--start on the bottom
			startRow = 1
			startCol = math.ceil(GetRandomInRange(minEdge, maxEdge))
			
			endVariance = math.ceil(GetRandomInRange((-1 * pathVariation), pathVariation))
			endCol = #terrainGrid - startCol + endVariance
			
			endRow = #terrainGrid
			--any overflow goes down the sides
			if(endCol > #terrainGrid) then
				overflow = endCol - #terrainGrid
				endCol = #terrainGrid
				endRow = #terrainGrid - overflow 
				
			elseif(endCol < 1) then
				overflow = (endCol * - 1) + 1
				endCol = 1
				endRow = #terrainGrid - overflow
				
			end
			
			
		elseif(startingEdge == 2) then
			--start on the left
			startCol = 1
			startRow = math.ceil(GetRandomInRange(minEdge, maxEdge))
			
			endVariance = math.ceil(GetRandomInRange((-1 * pathVariation), pathVariation))
			endRow = #terrainGrid - startRow + endVariance
			
			endCol = #terrainGrid
			--any overflow goes down the sides
			if(endRow > #terrainGrid) then
				overflow = endRow - #terrainGrid
				endRow = #terrainGrid
				endCol = #terrainGrid - overflow 
				
			elseif(endRow < 1) then
				overflow = (endRow * - 1) + 1
				endRow = 1
				endCol = #terrainGrid - overflow
				
			end
			
		elseif(startingEdge == 3) then
			--start on the top
			startRow = #terrainGrid
			startCol = math.ceil(GetRandomInRange(minEdge, maxEdge))
			
			endVariance = math.ceil(GetRandomInRange((-1 * pathVariation), pathVariation))
			endCol = #terrainGrid - startCol + endVariance
			
			endRow = 1
			--any overflow goes down the sides
			if(endCol > #terrainGrid) then
				overflow = endCol - #terrainGrid
				endCol = #terrainGrid
				endRow = 1 + overflow 
				
			elseif(endCol < 1) then
				overflow = (endCol * - 1) + 1
				endCol = 1
				endRow = 1 + overflow
				
			end
		else 
			--start on the right
			startCol = #terrainGrid
			startRow = math.ceil(GetRandomInRange(minEdge, maxEdge))
			
			endVariance = math.ceil(GetRandomInRange((-1 * pathVariation), pathVariation))
			endRow = #terrainGrid - startRow + endVariance
			
			endCol = 1
			--any overflow goes down the sides
			if(endRow > #terrainGrid) then
				overflow = endRow - #terrainGrid
				endRow = #terrainGrid
				endCol = 1 + overflow 
				
			elseif(endRow < 1) then
				overflow = (endRow * - 1) + 1
				endRow = 1
				endCol = 1 + overflow
				
			end
		end
		
		--draw an initial line from the start coordinate to the end coordinate
		initialLine = DrawLineOfTerrainNoDiagonalReturn(startRow, startCol, endRow, endCol, false, tt_river, #terrainGrid, terrainGrid)
		
		--subdivide the line based on the randomness factor
		lineLength = #initialLine
		
		--pathVariation 
		--randomness works like this:
		--max randomness is 1.0, and will produce a variation every 3rd river square
		--min randomness is 0.0 and will produce a single variation in the middle of the line (lineLength / 2)
		if((lineLength/2) > 3 and lineLength > 6) then
			squaresApart = Round(Normalize(pathVariation, 3, lineLength/2), 0)
		end
		
		--alter position of subdivided points by the path variation
		
		--loop through line points based on squaresApart
		linePointTable = {}
		table.insert(linePointTable, {startRow, startCol})
		for lineIndex = squaresApart, lineLength, squaresApart do
			
			currentLineRow = initialLine[lineIndex][1]
			currentLineCol = initialLine[lineIndex][2]
			
			
			pathDelta = math.ceil(GetRandomInRange(directionRandomness*-1, directionRandomness))
			
			if(startingEdge == 1 or startingEdge == 3) then
				
				currentLineCol = currentLineCol + pathDelta
				if(currentLineCol < 2) then
					currentLineCol = 2
				end
				if(currentLineCol > #terrainGrid - 1) then
					currentLineCol = #terrainGrid - 1
				end
			else
				
				currentLineRow = currentLineRow + pathDelta
				if(currentLineRow < 2) then
					currentLineRow = 2
				end
				if(currentLineRow > #terrainGrid - 1) then
					currentLineRow = #terrainGrid - 1
				end
			end
			currentPoint = {currentLineRow, currentLineCol}
		end
		table.insert(linePointTable, {endRow, endCol})
		
		--start the new river line with the starting point to the first path delta point
		currentRiverPoints = {}
		currentStartRow = linePointTable[1][1]
		currentStartCol = linePointTable[1][2]
		currentEndRow = linePointTable[2][1]
		currentEndCol = linePointTable[2][2]
		currentSegment = DrawLineOfTerrainNoDiagonalReturn(currentStartRow, currentStartCol, currentEndRow, currentEndCol, false, tt_river, #terrainGrid, terrainGrid)
		
		--loop through this segment and make sure it is not intersecting with another river anywhere
		
		
		--loop through this new segment and check for overlaps in any other river data
		for segmentIndex = 1, #currentSegment do
			
			currentSegmentRow = currentSegment[segmentIndex][1]
			currentSegmentCol = currentSegment[segmentIndex][2]
			
			
			isOnAnotherRiver = false
			--check this point against each river
			for riverCheckIndex = 1, #riverResult do
		--		if(riverCheckIndex ~= riverIndex) then
					currentCheckRiver = riverResult[riverCheckIndex]
					isOnAnotherRiver = isCoordOnRiver(currentCheckRiver, {currentSegmentRow, currentSegmentCol}) 
				if(isOnAnotherRiver == true) then
					break
				end
	--			end
			end
			
			table.insert(currentRiverPoints, {currentSegmentRow, currentSegmentCol})
			
			if(isOnAnotherRiver == true) then
				
				if(#currentRiverPoints <= 5) then
					print("river is too short, making another river")
					goto restartRiverLoop
				else
					print("skipping to end of river in initial line section")
					goto endOfRiver
				end
			end
		end
		
		
		--make sure the river hasn't ended on another river
		print("in linePointTable, there are " .. #linePointTable .. " points. Subtracting one gives " .. #linePointTable-1)
		linePointEndTotal = #linePointTable-1
		--continue the river from the end of the previous segment
		for pointIndex = 2, linePointEndTotal do
			print("current point index: " .. pointIndex .. " out of " .. #linePointTable)
			currentStartRow = linePointTable[pointIndex][1]
			currentStartCol = linePointTable[pointIndex][2]
			currentEndRow = linePointTable[pointIndex+1][1]
			currentEndCol = linePointTable[pointIndex+1][2]
			
			currentSegment = DrawLineOfTerrainNoDiagonalReturn(currentStartRow, currentStartCol, currentEndRow, currentEndCol, false, tt_river, #terrainGrid, terrainGrid)
			
			--loop through this new segment and check for overlaps in any other river data
			--start at the second segment index to not have a duplicate coordinate entry in currentRiverPoints
			for segmentIndex = 2, #currentSegment do
				
				currentSegmentRow = currentSegment[segmentIndex][1]
				currentSegmentCol = currentSegment[segmentIndex][2]
				
				
				isOnAnotherRiver = false
				--check this point against each river
				for riverCheckIndex = 1, #riverResult do
				--	if(riverCheckIndex ~= riverIndex) then
						currentCheckRiver = riverResult[riverCheckIndex]
						isOnAnotherRiver = isCoordOnRiver(currentCheckRiver, {currentSegmentRow, currentSegmentCol}) 
					if(isOnAnotherRiver == true) then
						break
					end
			--		end
				end
				
				table.insert(currentRiverPoints, {currentSegmentRow, currentSegmentCol})
				
				if(isOnAnotherRiver == true) then
					if(#currentRiverPoints <= 5) then
						print("river is too short, making another river")
						goto restartRiverLoop
					else
						print("skipping to end of river in initial line section")
						goto endOfRiver
					end
				end
			end
			
		end
		::endOfRiver::
		--put the recorded river points in the riverResult as a full river
		if(#currentRiverPoints > 5) then
			print("recording river " .. riverIndex .. " with " .. #currentRiverPoints .. " points")
			table.insert(riverResult, currentRiverPoints)
			table.insert(riverSegments, currentRiverPoints)
		end
		
	end
	
	
	--tributary loop
	if(tributaryNum > 0) then
		for tributaryIndex = 1, tributaryNum do
			::restartTributaryLoop::
			--choose an existing river to branch off of
			selectedRiverNum = math.ceil(worldGetRandom() * #riverResult)
			selectedRiver = riverResult[selectedRiverNum]
			
			if(#selectedRiver < 5) then
				goto restartTributaryLoop
			end
			
			minTributaryIndex = 3
			maxTributaryIndex = #selectedRiver - 2
			
			--start on selected river, pick a point on the river to extend from
			chosenRiverIndex = math.ceil(GetRandomInRange(minTributaryIndex, maxTributaryIndex))
			print("branching off of river " .. selectedRiverNum .. " at point " .. chosenRiverIndex .. " out of " .. #selectedRiver)
			startRow = selectedRiver[chosenRiverIndex][1]
			startCol = selectedRiver[chosenRiverIndex][2]
			
			
			
			--find a non-river edge of the map to connect to
			endingEdge = math.ceil(worldGetRandom() * 4)
			if(endingEdge == 1) then
				--end on the bottom
				endCol = math.ceil(GetRandomInRange(3, #terrainGrid - 2))
				
				endRow = 1
				
			elseif(endingEdge == 2) then
				--end on the left
				endRow = math.ceil(GetRandomInRange(3, #terrainGrid - 2))
				
				endCol = 1
				
			elseif(endingEdge == 3) then
				--end on the top
				endCol = math.ceil(GetRandomInRange(3, #terrainGrid - 2))
				
				endRow = #terrainGrid
			else 
				--end on the right
				endRow = math.ceil(GetRandomInRange(3, #terrainGrid - 2))
				
				endCol = #terrainGrid
			end
			
			--draw an initial line from the start coordinate to the end coordinate
			initialTrib = DrawLineOfTerrainNoDiagonalReturn(startRow, startCol, endRow, endCol, false, tt_river, #terrainGrid, terrainGrid)
			
			--get the length of the line
			lineLength = #initialTrib
			print("initialTrib line length is " .. lineLength)
			if(lineLength < 5) then
				goto restartTributaryLoop
			end
			
			pathedTrib = {}
			
			table.insert(pathedTrib, {startRow, startCol})
			--loop through this new segment and check for overlaps in any other river data
			--start at the second segment index to not have a duplicate coordinate entry in currentRiverPoints
			for tribIndex = 2, #initialTrib do
				
				currentTribRow = initialTrib[tribIndex][1]
				currentTribCol = initialTrib[tribIndex][2]
				
				
				isOnAnotherRiver = false
				--check this point against each river
				for riverCheckIndex = 1, #riverResult do
					currentCheckRiver = riverResult[riverCheckIndex]
					isOnAnotherRiver = isCoordOnRiver(currentCheckRiver, {currentTribRow, currentTribCol}) 
					if(isOnAnotherRiver == true) then
						break
					end
				end
				
				table.insert(pathedTrib, {currentTribRow, currentTribCol})
				
				if(isOnAnotherRiver == true) then
					if(#pathedTrib < 5) then
						print("tributary is too short, making another river")
						goto restartTributaryLoop
					else
						print("skipping to end of tributary, the line is long enough")
						goto endOfTrib
					end
				end
			end
			
			if(#pathedTrib < 5) then
				print("tributary is too short, making another river")
				goto restartTributaryLoop
			end
			::endOfTrib::
			--put the recorded trib points in the riverResult as a full river
			print("pathedTrib that is getting recorded has " .. #pathedTrib .. " river points")
			table.insert(riverResult, pathedTrib)
			
			
		end
	end
	
	--loop through and add crossings to each river segment
	--chart rivers for sanity
	for i = 1, #riverResult do
		for pointIndex = 1, #riverResult[i] do
			print("river " .. i .. " point " .. pointIndex .. ": row " .. riverResult[i][pointIndex][1] .. ", col " .. riverResult[i][pointIndex][2])
		end
	end
	
	local function IsDuplicateCrossing(crossingCoordTable, newRow, newCol)
				
		isDuplicate = false
		for testRiverIndex = 1, #crossingCoordTable do
			if(#crossingCoordTable[testRiverIndex] > 0) then
				for potentialCrossingIndex = 1, #crossingCoordTable[testRiverIndex] do
					--	print("new row: " .. newRow .. " new col: " .. newCol)
					testRow = crossingCoordTable[testRiverIndex][potentialCrossingIndex][1]
					testCol = crossingCoordTable[testRiverIndex][potentialCrossingIndex][2]
					--	print(" currentRow: " .. crossingCoordTable[testRiverIndex][potentialCrossingIndex][1] .. ", current col: " .. crossingCoordTable[testRiverIndex][potentialCrossingIndex][2])
					if(testRow == newRow and testCol == newCol) then
						print("new row: " .. newRow .. " new col: " .. newCol .. " currentRow: " .. testRow .. ", current col: " .. testCol)
						isDuplicate = true
						print("found a duplicate crossing")
					end
				end
			end
		end
		
		return isDuplicate
		
	end
		
	local function IsAlreadyChosenCrossingCoord(tempCrossingTable, newRow, newCol)
		
		isDuplicate = false
		if(#tempCrossingTable > 0) then
			for potentialCrossingIndex = 1, #tempCrossingTable do
				--	print("new row: " .. newRow .. " new col: " .. newCol)
				testRow = tempCrossingTable[potentialCrossingIndex][1]
				testCol = tempCrossingTable[potentialCrossingIndex][2]
				--	print(" currentRow: " .. crossingCoordTable[testRiverIndex][potentialCrossingIndex][1] .. ", current col: " .. crossingCoordTable[testRiverIndex][potentialCrossingIndex][2])
				if(testRow == newRow and testCol == newCol) then
					print("new row: " .. newRow .. " new col: " .. newCol .. " currentRow: " .. testRow .. ", current col: " .. testCol)
					isDuplicate = true
					print("found a duplicate crossing")
				end
			end
		end
		
		return isDuplicate
		
	end
	
	minCrossings = 2
	maxCrossings = 4
	
	for riverSegmentIndex = 1, #riverResult do
		currentFords = {}
		currentWoodBridges = {}
		currentStoneBridges = {}
		crossingNum = Round(GetRandomInRange(minCrossings, maxCrossings), 0)
		
		squaresApart = math.ceil(#riverResult[riverSegmentIndex]/crossingNum)
		
		for crossingIndex = 1, crossingNum do
			
			baseIndex = (crossingIndex - 1) * squaresApart
			baseIndex = baseIndex + math.ceil(worldGetRandom() * squaresApart)
			
			if(baseIndex > #riverResult[riverSegmentIndex]) then
				if(#riverResult[riverSegmentIndex] > 3) then
					baseIndex = #riverResult[riverSegmentIndex] - 2
				else
					baseIndex = #riverResult[riverSegmentIndex] - 1
				end
			end
			
			if(baseIndex <= 1) then
				if(#riverResult[riverSegmentIndex] > 3) then
					baseIndex = 3
				else
					if(#riverResult[riverSegmentIndex] >= 2) then
						baseIndex = 2
					end
				end
			end
			print("base index for this crossing is " .. baseIndex .. " when the number of squares on river " .. riverSegmentIndex .. " is " .. #riverResult[riverSegmentIndex])
			crossingType = math.ceil(worldGetRandom() * 3)
			print("placing a crossing at " .. riverResult[riverSegmentIndex][baseIndex][1] .. ", " .. riverResult[riverSegmentIndex][baseIndex][2])
			
			--check to make sure this crossing isn't on another river
			isOnAnotherRiver = false
			--check this point against each river
			for riverCheckIndex = 1, #riverResult do
				if(riverCheckIndex ~= riverSegmentIndex) then
					currentCheckRiver = riverResult[riverCheckIndex]
					isOnAnotherRiver = isCoordOnRiver(currentCheckRiver, {riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]}) 
					if(isOnAnotherRiver == true) then
						break
					end
				end
			end
				
				
			if(isOnAnotherRiver == false) then
				
				if(placeBridges == false) then
					
					print("placing a ford on river " .. riverSegmentIndex .. " at " ..  riverResult[riverSegmentIndex][baseIndex][1] .. ", " .. riverResult[riverSegmentIndex][baseIndex][2])
					table.insert(currentFords, riverResult[riverSegmentIndex][baseIndex])
				else
					if(crossingType == 1) then
						--place a ford
						if(IsDuplicateCrossing(fordResults, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false 
								and IsDuplicateCrossing(woodBridgeResults, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false
								and IsDuplicateCrossing(stoneBridgeResults, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false
								and IsAlreadyChosenCrossingCoord(currentFords, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false 
								and IsAlreadyChosenCrossingCoord(currentWoodBridges, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false
								and IsAlreadyChosenCrossingCoord(currentStoneBridges, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false) then
							print("placing a ford on river " .. riverSegmentIndex .. " at " ..  riverResult[riverSegmentIndex][baseIndex][1] .. ", " .. riverResult[riverSegmentIndex][baseIndex][2])
							table.insert(currentFords, riverResult[riverSegmentIndex][baseIndex])
						end
						
					elseif(crossingType == 2) then
						--place a wood bridge
						if(IsDuplicateCrossing(fordResults, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false 
								and IsDuplicateCrossing(woodBridgeResults, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false
								and IsDuplicateCrossing(stoneBridgeResults, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false
								and IsAlreadyChosenCrossingCoord(currentFords, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false 
								and IsAlreadyChosenCrossingCoord(currentWoodBridges, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false
								and IsAlreadyChosenCrossingCoord(currentStoneBridges, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false) then
							print("placing a wood bridge on river " .. riverSegmentIndex .. " at " ..  riverResult[riverSegmentIndex][baseIndex][1] .. ", " .. riverResult[riverSegmentIndex][baseIndex][2])
							table.insert(currentWoodBridges, riverResult[riverSegmentIndex][baseIndex])
						end
						
					else
						--place a stone bridge
						if(IsDuplicateCrossing(fordResults, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false 
								and IsDuplicateCrossing(woodBridgeResults, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false
								and IsDuplicateCrossing(stoneBridgeResults, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false
								and IsAlreadyChosenCrossingCoord(currentFords, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false 
								and IsAlreadyChosenCrossingCoord(currentWoodBridges, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false
								and IsAlreadyChosenCrossingCoord(currentStoneBridges, riverResult[riverSegmentIndex][baseIndex][1], riverResult[riverSegmentIndex][baseIndex][2]) == false) then
							print("placing a stone bridge on river " .. riverSegmentIndex .. " at " ..  riverResult[riverSegmentIndex][baseIndex][1] .. ", " .. riverResult[riverSegmentIndex][baseIndex][2])
							table.insert(currentStoneBridges, riverResult[riverSegmentIndex][baseIndex])
						end
						
					end
				end
			end
		end
		
		if(#currentFords == 0) then
			table.insert(fordResults, {})
		elseif(#currentFords > 0) then
			table.insert(fordResults, currentFords)
		end
		
		if(#currentWoodBridges == 0) then
			table.insert(woodBridgeResults, {})
		elseif(#currentWoodBridges > 0) then
			table.insert(woodBridgeResults, currentWoodBridges)
		end
		
		if(#currentStoneBridges == 0) then
			table.insert(stoneBridgeResults, {})
		elseif(#currentStoneBridges > 0) then
			table.insert(stoneBridgeResults, currentStoneBridges)
		end
		
		--loop through rivers and set on-river terrain
		for riverPointIndex = 1, #riverResult[riverSegmentIndex] do
			currentRow = riverResult[riverSegmentIndex][riverPointIndex][1]
			currentCol = riverResult[riverSegmentIndex][riverPointIndex][2]
			
			terrainGrid[currentRow][currentCol].terrainType = tt_river
		end 
		
		--loop through again and find all non-river neighbors, and set to plains
		for riverPointIndex = 1, #riverResult[riverSegmentIndex] do
			currentRow = riverResult[riverSegmentIndex][riverPointIndex][1]
			currentCol = riverResult[riverSegmentIndex][riverPointIndex][2]
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainGrid)
			
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType ~= tt_river) then
					terrainGrid[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
				end
				
			end
		end 
		
	end
	
	return riverResult, fordResults, woodBridgeResults, stoneBridgeResults
end

--This function was created to cull out large clusters of mountains in map layouts.
--Large blobs of mountains grow too large, and can obstruct the camera. Using the thinning function to thin out these
--blobs helps with these camera issues
function ThinTerrain(terrainToThin, numNeighborsAllowed, disallowedNeighbors, replacementTerrain, countDiagonals, terrainGrid)
	--iterate through terrain layout
	for row = 1, #terrainGrid do
	
		for col = 1, #terrainGrid do
	
			if(terrainGrid[row][col].terrainType == terrainToThin) then
				
				matchingNeighborNum = 0
				--grab neighbors of offending terrain
				
				--check if we want to count diagonals or not
				if(countDiagonals == true) then
					currentNeighbors = Get8Neighbors(row, col, terrainGrid)
				else
					currentNeighbors = GetNeighbors(row, col, terrainGrid)
				end
				for neighborIndex, neighbor in ipairs(currentNeighbors) do
					currentNeighborRow = neighbor.x 
					currentNeighborCol = neighbor.y 
					
					for disallowedIndex = 1, #disallowedNeighbors do
						currentDisallowedTerrain = disallowedNeighbors[disallowedIndex]
						if(terrainGrid[currentNeighborRow][currentNeighborCol].terrainType == currentDisallowedTerrain) then
							matchingNeighborNum = matchingNeighborNum + 1
						end
					end
				end
				
				--see how many matching neighbors existed
				if(matchingNeighborNum > numNeighborsAllowed) then
					terrainGrid[row][col].terrainType = replacementTerrain
				end
				
			end
			
		end
	end
end


--this function will expand an area of terrain within provided constraints.
function GrowRandomTerrainArea(startRow, startCol, growthChance, numPasses, terrainToChange, terrainToPlace, terrainGrid)	
	
	local areaSquares = {}
	
	table.insert(areaSquares, 1, {startRow, startCol})
	for index = 1, numPasses do
		if (index == 1) then
			row = startRow
			col = startCol

		else
			square = GetRandomElement(areaSquares)
			row = square[1]
			col = square[2]
		end
		
		tempSquares = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, terrainToChange, terrainGrid)
		
		for sIndex = 1, #tempSquares do
			x = tempSquares[sIndex][1]
			y = tempSquares[sIndex][2]
			
			if (worldGetRandom() <= growthChance) then
				terrainGrid[x][y].terrainType = terrainToPlace
				table.insert(areaSquares, #areaSquares + 1, {x, y})
			end
			
		end
		
	end
	
	return areaSquares
	
end


--this function will expand an area of terrain by the specified number of squares
function GrowTerrainAreaToSize(startRow, startCol, numPasses, terrainToChange, terrainToPlace, terrainGrid)	
	
	print("starting terrain growth from " .. startRow .. ", " .. startCol)
	local openSquares = {}
	local closedSquares = {}
	
	table.insert(openSquares, 1, {startRow, startCol})
	for index = 1, numPasses do
		if (index == 1) then
			row = startRow
			col = startCol
			randomIndex = 1
		else
			if(#openSquares > 0) then
				randomIndex = math.ceil(worldGetRandom() * #openSquares)
				square = openSquares[randomIndex]
				row = square[1]
				col = square[2]
			else
				return areaSquares
			end
		end
		print("growing terrain to " .. row .. ", " .. col)
		--assign terrain on chosen square
		terrainGrid[row][col].terrainType = terrainToPlace
		table.insert(closedSquares, {row, col})
		
		--remove the chosen square from openSquares
		table.remove(openSquares, randomIndex)
		
		tempSquares = GetNeighborsOfType(row, col, terrainToChange, terrainGrid)
		for sIndex = 1, #tempSquares do
			x = tempSquares[sIndex].x
			y = tempSquares[sIndex].y
			
			--make sure this square hasn't already been added to either the closed or open list
			alreadyExpanded = false
			if(Table_ContainsCoordinateIndex(openSquares, {x, y}) == false and Table_ContainsCoordinateIndex(closedSquares, {x, y}) == false) then
				table.insert(openSquares, {x, y})
			end
			
		end
		print("end of grow terrain area to size pass " .. index)
	end
	
	return areaSquares
	
end

function GrowTerrainAreaToSizeWeighted(startRow, startCol, numPasses, terrainToChange, terrainToPlace, topSelectionWeight, terrainGrid)
	
	print("starting terrain growth from " .. startRow .. ", " .. startCol)
	local openSquares = {}
	local closedSquares = {}
	
	table.insert(openSquares, 1, {startRow, startCol, 0})
	for index = 1, numPasses do
		if (index == 1) then
			row = startRow
			col = startCol
			randomIndex = 1
		else
			if(#openSquares > 0) then
				print("number of openSquares is currently " .. #openSquares)
				randomIndex = math.ceil(worldGetRandom() * (#openSquares * topSelectionWeight))
				print("random index selected is " .. randomIndex)
				square = openSquares[randomIndex]
				row = square[1]
				col = square[2]
			else
				return areaSquares
			end
		end
		print("growing terrain to " .. row .. ", " .. col)
		--assign terrain on chosen square
		terrainGrid[row][col].terrainType = terrainToPlace
		table.insert(closedSquares, {row, col})
		
		--remove the chosen square from openSquares
		table.remove(openSquares, randomIndex)
		
		tempSquares = GetNeighborsOfType(row, col, terrainToChange, terrainGrid)
		for sIndex = 1, #tempSquares do
			x = tempSquares[sIndex].x
			y = tempSquares[sIndex].y
			
			--make sure this square hasn't already been added to either the closed or open list
			alreadyExpanded = false
			if(Table_ContainsCoordinateIndex(openSquares, {x, y}) == false and Table_ContainsCoordinateIndex(closedSquares, {x, y}) == false) then
				
				--get distance from starting square
				currentDistance = GetDistance(startRow, startCol, x, y, 4)
				table.insert(openSquares, {x, y, currentDistance})
			end
			
		end
		
		--sort openList for closest elements at the top of the list
		table.sort(openSquares, function(a, b) return a[3] < b[3] end)
		
		print("end of grow terrain area to size pass " .. index)
	end
	
	return areaSquares
end

--this function will expand an area of terrain by the specified number of squares
function GrowTerrainAreaToSizeKeepStartTerrain(startRow, startCol, numPasses, startTerrainType, terrainToChange, terrainToPlace, terrainGrid)	
	
	local areaSquares = {}
	
	print("numpasses for terrain growth is " .. numPasses)
	print("starting terrain growth from " .. startRow .. ", " .. startCol)
	local openSquares = {}
	local closedSquares = {}
	
	table.insert(openSquares, 1, {startRow, startCol})
	for index = 1, numPasses do
		
		::restartCurrentLoop::
		print("current pass number is " .. index)
		print("number of opensquares is currently " .. #openSquares)
		if (index == 1) then
			row = startRow
			col = startCol
			randomIndex = 1
		else
			if(#openSquares > 0) then
				randomIndex = math.ceil(worldGetRandom() * #openSquares)
				square = openSquares[randomIndex]
				row = square[1]
				col = square[2]
			else
				print("ending function due to lack of opensquares")
				return areaSquares
			end
		end
		oldTerrain = terrainGrid[row][col].terrainType
		if index == 1 then
			print("growing terrain to " .. row .. ", " .. col)
			--assign terrain on chosen square
			terrainGrid[row][col].terrainType = startTerrainType	
			print("player start terrain reset")			
		else
			print("growing terrain to " .. row .. ", " .. col)
			--assign terrain on chosen square
			terrainGrid[row][col].terrainType = terrainToPlace	
		end 
		
		table.insert(closedSquares, {row, col})
		table.insert(areaSquares, {row, col})
		
		--remove the chosen square from openSquares
		table.remove(openSquares, randomIndex)
		
		tempSquares = GetNeighborsOfType(row, col, terrainToChange, terrainGrid)
		print("number of tempSquares is " .. #tempSquares)
		
		for sIndex = 1, #tempSquares do
			x = tempSquares[sIndex].x
			y = tempSquares[sIndex].y
			
			--make sure this square hasn't already been added to either the closed or open list
			alreadyExpanded = false
			if(Table_ContainsCoordinateIndex(openSquares, {x, y}) == false and Table_ContainsCoordinateIndex(closedSquares, {x, y}) == false) then
				table.insert(openSquares, {x, y})
			end
			
		end
		
		if(oldTerrain == terrainToPlace) then
			print("restarting current loop")
			goto restartCurrentLoop
		end
		print("end of grow terrain area to size pass " .. index)
	end
	
	return areaSquares
	
end

--this function will expand an area of terrain by the specified number of squares towards a specific point
function GrowTerrainAreaToSizeDirectional(startRow, startCol, endRow, endCol, numPasses, terrainToChange, terrainToPlace, terrainGrid)	
	
	print("starting terrain growth from " .. startRow .. ", " .. startCol)
	local openSquares = {}
	local closedSquares = {}
	
	targetReached = false 	--bool that flags when the target has been reached successfully
	
	print("StartRow is " .. startRow .. " startCol is " .. startCol)
	print("EndRow is " .. endRow .. " endCol is " .. endCol)
	print("There are " .. numPasses .. " passes total")	
	
	table.insert(openSquares, 1, {startRow, startCol})
		for index = 1, numPasses do
			if (index == 1) then --the first pass of this loop, it automatically assigns it to the starting square
				row = startRow
				col = startCol
				randomIndex = 1				
			else --and if it isn't the first pass, then
				print("OpenSquares table currently contains " .. #openSquares .. " items")
			
				if(#openSquares > 0) then  --it first checks to see whether or not there is anything in the opensquares table
					if targetReached == false then --then it checks if the target has been reached or not - if not it'll sort the items in the opensquares table and choose the closest square to fill
						closestSquares = {}
					
						for checkDistanceIndex = 1, #openSquares do	
							currentEntry = {}
							currentRow = openSquares[checkDistanceIndex][1]
							currentCol = openSquares[checkDistanceIndex][2]
							currentDistance = GetDistanceDecimal(currentRow, currentCol, endRow, endCol, 4) --function GetDistance(row1, col1, row2, col2, sigFigs)
							currentEntry = {checkDistanceIndex, currentDistance}
							
							print("checkDistanceIndex is " .. checkDistanceIndex )
							print("currentRow is " .. currentRow .. " currentCol is " .. currentCol .. " distance is " .. currentDistance)
							table.insert(closestSquares, currentEntry)	
						end 
					
						table.sort(closestSquares, function(a, b) return a[2] < b[2] end)					
					
						--find closest neighbor and assigns it to "randomIndex" 
						
						randomIndex = closestSquares[1][1]
						square = openSquares[randomIndex]
						row = square[1]
						col = square[2]		
					
						if (row == endRow and col == endCol) then
							targetReached = true
							print("Target has been reached! We are now at row " .. row .. " col " .. col)
						end
					
					else --if the target has been reached, then it will randomly select a square from whatever's left in the open squares table
						randomIndex = math.ceil(worldGetRandom() * #openSquares) --goes to do the random selection
						square = openSquares[randomIndex]
						row = square[1]
						col = square[2]		
					end
				else
					return areaSquares
				end
			end

			print("growing terrain to " .. row .. ", " .. col)
			
			terrainGrid[row][col].terrainType = terrainToPlace --assign terrain on chosen square (randomIndex)
			table.insert(closedSquares, {row, col}) -- adds the square to the closedsquares table
			table.remove(openSquares, randomIndex) --remove the chosen square from openSquares
			
			tempSquares = GetNeighborsOfType(row, col, terrainToChange, terrainGrid) 
		
			for sIndex = 1, #tempSquares do
					x = tempSquares[sIndex].x
					y = tempSquares[sIndex].y
					
					--make sure this square hasn't already been added to either the closed or open list
					alreadyExpanded = false
					if(Table_ContainsCoordinateIndex(openSquares, {x, y}) == false and Table_ContainsCoordinateIndex(closedSquares, {x, y}) == false) then	
						table.insert(openSquares, {x, y})
					end
					
			end
			print("end of grow terrain area to size pass " .. index)
	end
		
	return areaSquares
	
end

--this function will expand an area of terrain by the specified number of squares towards a specific point
function GrowTerrainAreaToSizeDirectionalWeighted(startRow, startCol, endRow, endCol, numPasses, terrainToChange, terrainToPlace, terrainGrid)	
	
	print("starting terrain growth from " .. startRow .. ", " .. startCol)
	local openSquares = {}
	local closedSquares = {}
	
	targetReached = false 	--bool that flags when the target has been reached successfully
	
	print("StartRow is " .. startRow .. " startCol is " .. startCol)
	print("EndRow is " .. endRow .. " endCol is " .. endCol)
	print("There are " .. numPasses .. " passes total")	
	
	table.insert(openSquares, 1, {startRow, startCol})
		for index = 1, numPasses do
			if (index == 1) then --the first pass of this loop, it automatically assigns it to the starting square
				row = startRow
				col = startCol
				randomIndex = 1				
			else --and if it isn't the first pass, then
				print("OpenSquares table currently contains " .. #openSquares .. " items")
			
				if(#openSquares > 0) then  --it first checks to see whether or not there is anything in the opensquares table
					if targetReached == false then --then it checks if the target has been reached or not - if not it'll sort the items in the opensquares table and choose the closest square to fill
						closestSquares = {}
					
						for checkDistanceIndex = 1, #openSquares do	
							currentEntry = {}
							currentRow = openSquares[checkDistanceIndex][1]
							currentCol = openSquares[checkDistanceIndex][2]
							currentDistance = GetDistanceDecimal(currentRow, currentCol, endRow, endCol, 4) --function GetDistance(row1, col1, row2, col2, sigFigs)
							currentEntry = {checkDistanceIndex, currentDistance}
							
							print("checkDistanceIndex is " .. checkDistanceIndex )
							print("currentRow is " .. currentRow .. " currentCol is " .. currentCol .. " distance is " .. currentDistance)
							table.insert(closestSquares, currentEntry)	
						end 
					
						table.sort(closestSquares, function(a, b) return a[2] < b[2] end)					
					
						--find closest neighbor and assigns it to "randomIndex" 
						
						randomIndex = closestSquares[1][1]
						square = openSquares[randomIndex]
						row = square[1]
						col = square[2]		
					
						if (row == endRow and col == endCol) then
							targetReached = true
							print("Target has been reached! We are now at row " .. row .. " col " .. col)
						end
					
					else --if the target has been reached, then it will take the earliest added squares to fill out sequentially
						square = openSquares[1]
						row = square[1]
						col = square[2]		
					end
				else
					return areaSquares
				end
			end

			print("growing terrain to " .. row .. ", " .. col)
			
			terrainGrid[row][col].terrainType = terrainToPlace --assign terrain on chosen square
			table.insert(closedSquares, {row, col}) -- adds the square to the closedsquares table
			if(targetReached == true) then
				table.remove(openSquares, 1) --remove the chosen square from openSquares
			else
				table.remove(openSquares, randomIndex) --remove the chosen square from openSquares
			end
		
			tempSquares = GetNeighborsOfType(row, col, terrainToChange, terrainGrid) 
		
			for sIndex = 1, #tempSquares do
					x = tempSquares[sIndex].x
					y = tempSquares[sIndex].y
					
					--make sure this square hasn't already been added to either the closed or open list
					alreadyExpanded = false
					if(Table_ContainsCoordinateIndex(openSquares, {x, y}) == false and Table_ContainsCoordinateIndex(closedSquares, {x, y}) == false) then	
						table.insert(openSquares, {x, y})
					end
					
			end
			print("end of grow terrain area to size pass " .. index)
	end
		
	return areaSquares
	
end

function FloodFill(startRow, startCol, terrainToFind)
	
	local openSquares = {}
	local closedSquares = {}
	
	table.insert(openSquares, {startRow, startCol})
	local squaresPlaced = 0
	
	square = openSquares[1]
	row = square[1]
	col = square[2]
	
	
	tempSquares = GetNeighbors(row, col, terrainLayoutResult)
	table.insert(closedSquares, square)
	print("placing " .. row .. ", " .. col .. " in closed list")
	table.remove(openSquares, 1)
	
	for sIndex = 1, #tempSquares do
		x = tempSquares[sIndex].x
		y = tempSquares[sIndex].y
		
		if(containsSquare(closedSquares, x, y) == false and containsSquare(openSquares, x, y) == false) then
			if(terrainLayoutResult[x][y].terrainType == terrainToFind) then
				table.insert(openSquares, {x, y})
				
				squaresPlaced = squaresPlaced + 1
			end
		else
			print("this square at " .. x .. ", " .. y .. " has already been found")
			
		end
		
	end
	
	while(#openSquares > 0) do
		
		square = openSquares[1]
		row = square[1]
		col = square[2]
		
		
		tempSquares = GetNeighbors(row, col, terrainLayoutResult)
		table.insert(closedSquares, square)
		print("placing " .. row .. ", " .. col .. " in closed list")
		table.remove(openSquares, 1)
		
		for sIndex = 1, #tempSquares do
			x = tempSquares[sIndex].x
			y = tempSquares[sIndex].y
			
			if(containsSquare(closedSquares, x, y) == false and containsSquare(openSquares, x, y) == false) then
				if(terrainLayoutResult[x][y].terrainType == terrainToFind) then
					table.insert(openSquares, {x, y})
					squaresPlaced = squaresPlaced + 1
				end
			else
			--	print("this square at " .. x .. ", " .. y .. " has already been found")
				
			end
				
			
		end
		
	end
	
	return closedSquares
	
end

--This function acts as a opposite flood fill in that it finds all of an area that is not the specified terrain. Used for finding islands
function FloodFillIslands(startRow, startCol, terrainToAvoid)
	
	local openSquares = {}
	local closedSquares = {}
	
	table.insert(openSquares, {startRow, startCol})
	local squaresPlaced = 0
	
	square = openSquares[1]
	row = square[1]
	col = square[2]
	
	
	tempSquares = GetNeighbors(row, col, terrainLayoutResult)
	table.insert(closedSquares, square)
	print("placing " .. row .. ", " .. col .. " in closed list")
	table.remove(openSquares, 1)
	
	for sIndex = 1, #tempSquares do
		x = tempSquares[sIndex].x
		y = tempSquares[sIndex].y
		
		if(containsSquare(closedSquares, x, y) == false and containsSquare(openSquares, x, y) == false) then
			if(terrainLayoutResult[x][y].terrainType ~= terrainToAvoid) then
				table.insert(openSquares, {x, y})
				
				squaresPlaced = squaresPlaced + 1
			end
		else
			print("this square at " .. x .. ", " .. y .. " has already been found")
			
		end
		
	end
	
	while(#openSquares > 0) do
		
		square = openSquares[1]
		row = square[1]
		col = square[2]
		
		
		tempSquares = GetNeighbors(row, col, terrainLayoutResult)
		table.insert(closedSquares, square)
		print("placing " .. row .. ", " .. col .. " in closed list")
		table.remove(openSquares, 1)
		
		for sIndex = 1, #tempSquares do
			x = tempSquares[sIndex].x
			y = tempSquares[sIndex].y
			
			if(containsSquare(closedSquares, x, y) == false and containsSquare(openSquares, x, y) == false) then
				if(terrainLayoutResult[x][y].terrainType ~= terrainToAvoid) then
					table.insert(openSquares, {x, y})
					squaresPlaced = squaresPlaced + 1
				end
			else
			--	print("this square at " .. x .. ", " .. y .. " has already been found")
				
			end
				
			
		end
		
	end
	
	return closedSquares
	
end

function containsSquare(tableToCheck, newRow, newCol)

	doesContainSquare = false
	
	for index, val in ipairs(tableToCheck) do
		if (val[1] == newRow and val[2] == newCol) then
			doesContainSquare = true
		end
	end
	
	return doesContainSquare
end


function CopyMappingTable(orig, destination)
	
	for i, v in pairs(destination) do
		
		destination[i] = nil
	end
	
	
    local orig_type = type(orig)
    if orig_type == 'table' then
        
        for orig_key, orig_value in next, orig, nil do
            destination[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
        setmetatable(orig, destination)
    else -- number, string, boolean, etc
        destination = orig
    end
end
