-- vivid's big island
-- made by vividlyplain, September 2021

print("bonjour")
print("a map by vividlyplain, September 2021")
print("special thanks to Nick Taylor for the map tutorials")
print("special thanks to Chrazini for the DistanceFromEdge function")

-- terrain strings
n = tt_none

-- bounty strings

-- marker strings
playerStartTerrain = tt_00_start_bigisland

-- setting up the map grid
mapRes = 14
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(mapRes)

-- terrainLayoutResult table
terrainLayoutResult = SetUpGrid(gridSize, tt_ocean, terrainLayoutResult)

-- grid definitions
mapMidPoint = math.ceil(gridSize/2)
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapThreeQuarterSize = math.ceil(3*gridSize/4)
mapEighthSize = math.ceil(gridSize/8)
mapAcross = math.ceil(gridSize-2)

-- draw lines of water on edges to stop island from connecting to edge
    -- left side
    startRow = 2
    startCol = 3
    endRow = mapAcross
    endCol = 3
    DrawLineOfTerrainNoNeighbors(startRow, startCol, endRow, endCol, true, tt_ocean_deep, gridSize, terrainLayoutResult)

    -- right side
    startRow = 2
    startCol = mapAcross
    endRow = mapAcross
    endCol = mapAcross
    DrawLineOfTerrainNoNeighbors(startRow, startCol, endRow, endCol, true, tt_ocean_deep, gridSize, terrainLayoutResult)

    -- top
    startRow = 3
    startCol = 3
    endRow = 3
    endCol = mapAcross
    DrawLineOfTerrainNoNeighbors(startRow, startCol, endRow, endCol, true, tt_ocean_deep, gridSize, terrainLayoutResult)

    -- bottom
    startRow = mapAcross
    startCol = 3
    endRow = mapAcross
    endCol = mapAcross
    DrawLineOfTerrainNoNeighbors(startRow, startCol, endRow, endCol, true, tt_ocean_deep, gridSize, terrainLayoutResult)

-- central large island
startRow = mapHalfSize
startCol = mapHalfSize

numPasses = 81*worldTerrainWidth/100
terrainToChange = {tt_ocean}
terrainToPlace = tt_00_actuallyhighenoughtonotspawnunderwater
GrowTerrainAreaToSizeKeepStartTerrain(startRow, startCol, numPasses, startTerrainType, terrainToChange, terrainToPlace, terrainLayoutResult)

-- central plain
terrainLayoutResult[mapHalfSize][mapHalfSize].terrainType = tt_island_plains

for row = 1, gridSize do
	for col = 1, gridSize do

		--check for the terrain type you had chosen before
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
		print("found playerstartterrain at" .. row .. ", " .. col)
			startNeighbors = {}
			startNeighbors = Get20Neighbors(row, col, terrainLayoutResult)
			--loop through neighbors of the current square
			for testNeighborIndex, testNeighbor in ipairs(startNeighbors) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				if(terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType ~= playerStartTerrain) then
					terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_00_actuallyhighenoughtonotspawnunderwater
				end
			end
        end
	
		if(terrainLayoutResult[row][col].terrainType == tt_00_actuallyhighenoughtonotspawnunderwater or terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			thyNeighbors = {}
			thyNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			--loop through neighbors of the current square
			for testNeighborIndex, testNeighbor in ipairs(thyNeighbors) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
				if(currentTerrainType == tt_ocean) then
					terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_beach
				end
			end
		end

		if(terrainLayoutResult[row][col].terrainType == tt_ocean_deep) then
			waterNeighbors = {}
			waterNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			--loop through neighbors of the current square
			for testNeighborIndex, testNeighbor in ipairs(waterNeighbors) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
				if(currentTerrainType == tt_00_actuallyhighenoughtonotspawnunderwater) then
					terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_beach
				end
			end
		end
    end
end

-- player start stuff
minTeamDistance = Round((#terrainLayoutResult * 0.75)) 
minPlayerDistance = Round((#terrainLayoutResult * 0.25))
edgeBuffer = 5
innerExclusion = 0.45
topSelectionThreshold = 0.001
impasseTypes = {}
impasseTypes = {tt_ocean, tt_ocean_deep}
impasseDistance = 2
cornerThreshold = 4
startBufferRadius = 4
startBufferTerrain = tt_island_plains
teamMappingTable = CreateTeamMappingTable()

openTypes = {tt_island_plains, tt_00_actuallyhighenoughtonotspawnunderwater, tt_hills_low_rolling, tt_hills_med_rolling, tt_hills_high_rolling, tt_none, tt_flatland}
terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, 	startBufferRadius, false, terrainLayoutResult)