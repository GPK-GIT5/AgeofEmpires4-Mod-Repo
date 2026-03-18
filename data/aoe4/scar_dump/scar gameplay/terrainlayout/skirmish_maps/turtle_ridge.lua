-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

print('--------- BEGIN: TURTLE RIDGE ---------')

-------------------------------------------------
--
--
--	GLOBAL AND SCALING VARS
--
--	
-------------------------------------------------

voronoiSiteRotation = worldGetRandom() * 360

--micro
if (worldTerrainWidth <= 416) then
	
	gridMps = 12
	useEuclidean = true --argument used with createVoronoiDiagram(). true is Euclidean Distance, false is Manhattan Distance
	numberOfRegions = 4
	circlePlayerStartRadius = 12
	
	voronoiCanvasRadius = 25 --circular canvas where the voronoi regions are drawn
	voronoiSiteRadius = 9 --modifies the size of the voronoi regions, this includes the center region
	
	centerRegionScale = 4.5 --the shallow valley center region
	
	forestEdgeThickness = 1
	forestCircleSize = voronoiCanvasRadius
	forestHollowCircleSize = forestCircleSize - 5
	
	
--small
elseif (worldTerrainWidth <= 512) then
	
	gridMps = 15
	useEuclidean = true
	numberOfRegions = 4
	circlePlayerStartRadius = 12
	
	voronoiCanvasRadius = 25
	voronoiSiteRadius = 9
	
	centerRegionScale = 4.5
	
	forestEdgeThickness = 1
	forestCircleSize = voronoiCanvasRadius
	forestHollowCircleSize = forestCircleSize - 6
	
--medium
elseif (worldTerrainWidth <= 640) then
	
	gridMps = 15
	useEuclidean = false
	numberOfRegions = 6
	circlePlayerStartRadius = 15
	
	voronoiCanvasRadius = 24
	voronoiSiteRadius = 12
	
	centerRegionScale = 5.5
	
	forestEdgeThickness = 2
	forestCircleSize = voronoiCanvasRadius
	forestHollowCircleSize = forestCircleSize - 2
	
--large
elseif (worldTerrainWidth <= 768) then
	
	gridMps = 15
	useEuclidean = false
	numberOfRegions = 8
	circlePlayerStartRadius = 18
	
	voronoiCanvasRadius = 28
	voronoiSiteRadius = 18
	
	centerRegionScale = 8.2
	
	forestEdgeThickness = 4
	forestCircleSize = voronoiCanvasRadius
	forestHollowCircleSize = forestCircleSize - 1.5
	
--gigantic
elseif (worldTerrainWidth <= 896) then
	
	gridMps = 18
	useEuclidean = false
	numberOfRegions = 8
	circlePlayerStartRadius = 17
	
	voronoiCanvasRadius = 27
	voronoiSiteRadius = 16
	
	centerRegionScale = 7.5
	
	forestEdgeThickness = 4
	forestCircleSize = voronoiCanvasRadius
	forestHollowCircleSize = forestCircleSize - 1.5
	
end




-------------------------------------------------
--
--
--	TERRAIN TYPES
--
--	
-------------------------------------------------

playerStartTerrain = tt_turtle_ridge_player_start

regionWallTerrain = tt_impasse_mountains

stealthTerrain = tt_trees_plains_stealth
forestTerrain = tt_turtle_ridge_forest_plains

smallHillTerrain = tt_hills_low_rolling
centerRegionTerrain = tt_valley_shallow

mapBoundaryTerrain = tt_plateau_high




-------------------------------------------------
--
--
--	GRID SETUP
--	
--	
-------------------------------------------------

terrainLayoutResult = {}
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(gridMps)

if (gridHeight % 2 == 0) then
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then
	gridWidth = gridWidth - 1
end

gridSize = gridWidth

terrainLayoutResult = SetUpGrid(gridSize, mapBoundaryTerrain, terrainLayoutResult)




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
--	PLAYER REGIONS AROUND CENTER REGION
--
--	
-------------------------------------------------

--voronoi points in a circular radius. Used to create regions
voronoiPoints = GetPointsInCircularRadius(mapHalfSize, mapHalfSize, numberOfRegions, voronoiSiteRadius, voronoiSiteRotation, terrainLayoutResult)

--voronoi center point region
table.insert(voronoiPoints, { y = mapHalfSize, x = mapHalfSize })

--a circular canvas to work within
voronoiCanvas = GetAllSquaresInRadius(mapHalfSize, mapHalfSize, voronoiCanvasRadius, terrainLayoutResult)

--create voronoi regions with our voronoiPoints and within the boundaries of voronoiCanvas
myVoronoiDiagram = CreateVoronoiDiagram(voronoiPoints, voronoiCanvas, useEuclidean)

--each voronoi region
for k, region in ipairs(myVoronoiDiagram) do
	
	--coordinates within each region
	for i, cellCoord in ipairs(region.cells) do
		
		--get neighbors of each coordinate in voronoi region
		cellNeighbors = GetAllSquaresInRingAroundSquare(cellCoord.y, cellCoord.x, 1, 1, terrainLayoutResult)
		
		--each neighbor coordinate from a cell coord
		for j, neighborCoord in ipairs(cellNeighbors) do
			
			neighborRow = neighborCoord[1]
			neighborCol = neighborCoord[2]
			
			--creates walls separating players/regions from one another
			--the neighbor coord is outside the voronoi region which is our wall coordinate and is not a mapBoundaryTerrain
			if (Table_ContainsCoordinate(region.cells, { y = neighborRow, x = neighborCol }) == false and
			terrainLayoutResult[neighborRow][neighborCol].terrainType ~= mapBoundaryTerrain) then
				terrainLayoutResult[neighborRow][neighborCol].terrainType = regionWallTerrain
			end
			
		end
		
		terrainLayoutResult[cellCoord.y][cellCoord.x].terrainType = tt_none
		
		--the last region is the center region, fill with stealth terrain
		if (k == #myVoronoiDiagram) then
			terrainLayoutResult[cellCoord.y][cellCoord.x].terrainType = stealthTerrain
		end
		
	end
	
end




-------------------------------------------------
--
--
--	CENTER REGION
--
--	
-------------------------------------------------

--circlular terrain
centerRegion = GetAllSquaresInRadius(mapHalfSize, mapHalfSize, centerRegionScale, terrainLayoutResult)

for k, centerRadiusCoords in ipairs(centerRegion) do
	centerRadiusRow = centerRadiusCoords[1]
	centerRadiusCol = centerRadiusCoords[2]
	
	terrainLayoutResult[centerRadiusRow][centerRadiusCol].terrainType = centerRegionTerrain
end

--creates player passage to center region
for k, region in ipairs(myVoronoiDiagram) do
	
	--from region point, draw line to center of map
	playerPassageCoords = DrawLineOfTerrainNoDiagonalReturn(region.site.y, region.site.x, mapHalfSize, mapHalfSize, false, tt_none, gridSize, terrainLayoutResult)
	
	--cut hole with a passage so player can access the center from their region
	for k, passageCoord in ipairs(playerPassageCoords) do
		playerPassageRow = passageCoord[1]
		playerPassageCol = passageCoord[2]
		
		currentTerrain = terrainLayoutResult[playerPassageRow][playerPassageCol].terrainType
		
		if (currentTerrain == regionWallTerrain) then
			
			terrainLayoutResult[playerPassageRow][playerPassageCol].terrainType = stealthTerrain
			
			--widen passage
			nearbyWallNeighbors = Get8Neighbors(playerPassageRow, playerPassageCol, terrainLayoutResult)
			for i, wallNeighbor in ipairs(nearbyWallNeighbors) do
				wallNeighborRow = wallNeighbor.x
				wallNeighborCol = wallNeighbor.y
				currentTerrain = terrainLayoutResult[wallNeighborRow][wallNeighborCol].terrainType
				if (currentTerrain == regionWallTerrain) then
					terrainLayoutResult[wallNeighborRow][wallNeighborCol].terrainType = stealthTerrain
				end
			end
		
		end
	end
	
end




-------------------------------------------------
--
--
--	FOREST RING
--
--	
-------------------------------------------------

--creates a forest circle where coord is set to tt_none
--this is a curved forest for corner regions
forestCircle = GetAllSquaresInRadius(mapHalfSize, mapHalfSize, forestCircleSize, terrainLayoutResult)

for k, forestCoord in ipairs(forestCircle) do
	forestRow = forestCoord[1]
	forestCol = forestCoord[2]
	
	if (terrainLayoutResult[forestRow][forestCol].terrainType == tt_none) then
		terrainLayoutResult[forestRow][forestCol].terrainType = forestTerrain
	end
end

--hollow out the center of the forest with a smaller radius to create a forest outline of curved corners
forestCircleInner = GetAllSquaresInRadius(mapHalfSize, mapHalfSize, forestHollowCircleSize, terrainLayoutResult)

for k, forestHollowCoord in ipairs(forestCircleInner) do
	forestHollowRow = forestHollowCoord[1]
	forestHollowCol = forestHollowCoord[2]
	
	if (terrainLayoutResult[forestHollowRow][forestHollowCol].terrainType == forestTerrain) then
		terrainLayoutResult[forestHollowRow][forestHollowCol].terrainType = tt_none
	end
end

--map edges set to forest, perpendicular lines
for row = 1, gridSize do
	for col = 1, gridSize do
		currentTerrainType = terrainLayoutResult[row][col].terrainType
		--top edge
		if (row <= forestEdgeThickness and currentTerrainType == tt_none) then
			terrainLayoutResult[row][col].terrainType = forestTerrain
		end
		--right edge
		if (col >= (gridSize + 1) - forestEdgeThickness and currentTerrainType == tt_none) then
			terrainLayoutResult[row][col].terrainType = forestTerrain
		end
		--bottom edge
		if (row >= (gridSize + 1) - forestEdgeThickness and currentTerrainType == tt_none) then
			terrainLayoutResult[row][col].terrainType = forestTerrain
		end
		--left edge
		if (col <= forestEdgeThickness and currentTerrainType == tt_none) then
			terrainLayoutResult[row][col].terrainType = forestTerrain
		end
	end
end




-------------------------------------------------
--
--
--	SMALL CENTER HILL TERRAIN
--
--	
-------------------------------------------------

--small hill in center of map
smallHillSquares = GetAllSquaresInRadius(mapHalfSize, mapHalfSize, 1.5, terrainLayoutResult)
for k, v in ipairs(smallHillSquares) do
	smallHillRow = v[1]
	smallHillCol = v[2]
	terrainLayoutResult[smallHillRow][smallHillCol].terrainType = smallHillTerrain
end




-------------------------------------------------
--
--
--	PLAYER STARTS
--
--	
-------------------------------------------------

teamMappingTable = CreateTeamMappingTable()

--player start coords
playerStartCoords = GetPointsInCircularRadius(mapHalfSize, mapHalfSize, numberOfRegions, circlePlayerStartRadius, voronoiSiteRotation, terrainLayoutResult)

--random locations
if (randomPositions == true) then
	ShuffleTable(playerStartCoords)
end

--place player start terrains
for k, playerTerrainCoord in ipairs(playerStartCoords) do
	playerRow = playerTerrainCoord.y
	playerCol = playerTerrainCoord.x
	terrainLayoutResult[playerRow][playerCol].terrainType = playerStartTerrain
end

--region skip so opponent players have empty regions between if there are less players than total regions
totalSkipRegions = 0
if (worldPlayerCount < numberOfRegions) then
	totalSkipRegions = numberOfRegions - worldPlayerCount
end

if (totalSkipRegions >= 6) then
	regionSkip = 3
elseif (totalSkipRegions >= 3 and totalSkipRegions <= 5 and #teamMappingTable <= 2) then
	regionSkip = 2
else
	regionSkip = 1
end

--assign players to coords
playerRegionSkip = 0
for teamNum = 1, #teamMappingTable do
	
	--region skip exists after first team
	if (totalSkipRegions > 0 and teamNum > 1) then
		playerRegionSkip = playerRegionSkip + regionSkip
		totalSkipRegions = totalSkipRegions - 1
	end
	
	for i = 1, #teamMappingTable[teamNum].players do
		
		playerRegionSkip = playerRegionSkip + 1
		
		playerStartRow = playerStartCoords[playerRegionSkip].y
		playerStartCol = playerStartCoords[playerRegionSkip].x
		terrainLayoutResult[playerStartRow][playerStartCol].playerIndex = teamMappingTable[teamNum].players[i].playerID - 1
	end
end




print('--------- END OF: TURTLE RIDGE ---------')