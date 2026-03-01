-- vivid's ponds
-- made by vividlyplain, August 2021

print("bonjour")
print("a map by vividlyplain, August 2021")
print("special thanks to Nick Taylor for the map tutorials")

-- terrain strings
n = tt_none

-- bounty strings

-- marker strings
playerStartTerrain = tt_00_start_ponds

-- setting up the map grid
mapRes = 24
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(mapRes)

-- terrainLayoutResult table
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

-- grid definitions
mapMidPoint = math.ceil(gridSize/2)
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapThreeQuarterSize = math.ceil(3*gridSize/4)
mapEighthSize = math.ceil(gridSize/8)
mapAcross = math.ceil(gridSize-2)

-- central large pond
startRow = mapHalfSize
startCol = mapHalfSize

numPasses = 2+math.ceil(3*worldGetRandom())
terrainToChange = {tt_plains}
terrainToPlace = tt_00_pondfish -- tt_lake_shallow_plains_fish

GrowTerrainAreaToSizeKeepStartTerrain(startRow, startCol, numPasses, startTerrainType, terrainToChange, terrainToPlace, terrainLayoutResult)

-- player start stuff
minTeamDistance = Round((#terrainLayoutResult * 0.75)) 
minPlayerDistance = Round((#terrainLayoutResult * 0.25))
edgeBuffer = 3
innerExclusion = 0.45
topSelectionThreshold = 0.001
impasseTypes = {}
impasseTypes = {tt_00_pondfish}	-- tt_lake_shallow_plains_fish
impasseDistance = 4
cornerThreshold = 3
startBufferRadius = 1
startBufferTerrain = tt_flatland
teamMappingTable = CreateTeamMappingTable()

openTypes = {tt_plains, tt_hills_low_rolling, tt_hills_med_rolling, tt_hills_high_rolling, tt_none, tt_flatland}
terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, 	startBufferRadius, false, terrainLayoutResult)

-- randomize starting ponds
randPond = math.ceil(16*worldGetRandom())

for row = 1, gridSize do
	for col = 1, gridSize do

		--check for the terrain type you had chosen before
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
		print("found playerstartterrain at" .. row .. ", " .. col)
			plateauRamps = 0

			startNeighbors = {}
			startNeighbors = Get20Neighbors(row, col, terrainLayoutResult)

			--loop through neighbors of the current square to look for ramps
			for testNeighborIndex, testNeighbor in ipairs(startNeighbors) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				if(terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType ~= playerStartTerrain) then
					terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_flatland
				end
			end

			if (randPond == 1) then 
				terrainLayoutResult[row+1][col+1].terrainType = tt_00_pondfish
				terrainLayoutResult[row-1][col+1].terrainType = tt_00_pondfish
			end
			if (randPond == 2) then 
				terrainLayoutResult[row+1][col-1].terrainType = tt_00_pondfish	
				terrainLayoutResult[row-1][col+1].terrainType = tt_00_pondfish	
			end
			if (randPond == 3) then 
				terrainLayoutResult[row+1][col].terrainType = tt_00_pondfish	
				terrainLayoutResult[row-1][col].terrainType = tt_00_pondfish	
			end
			if (randPond == 4) then 
				terrainLayoutResult[row][col+1].terrainType = tt_00_pondfish	
				terrainLayoutResult[row][col-1].terrainType = tt_00_pondfish	
			end
			if (randPond == 5) then 
				terrainLayoutResult[row-1][col].terrainType = tt_00_pondfish	
				terrainLayoutResult[row-1][col+1].terrainType = tt_00_pondfish	
			end
			if (randPond == 6) then 
				terrainLayoutResult[row-1][col].terrainType = tt_00_pondfish	
				terrainLayoutResult[row-1][col+1].terrainType = tt_00_pondfish	
			end
			if (randPond == 7) then 
				terrainLayoutResult[row-1][col].terrainType = tt_00_pondfish
				terrainLayoutResult[row-1][col-1].terrainType = tt_00_pondfish
			end
			if (randPond == 8) then 
				terrainLayoutResult[row-1][col].terrainType = tt_00_pondfish	
				terrainLayoutResult[row-1][col-1].terrainType = tt_00_pondfish	
			end
			if (randPond == 9) then 
				terrainLayoutResult[row-1][col+1].terrainType = tt_00_pondfish	
				terrainLayoutResult[row-1][col-1].terrainType = tt_00_pondfish	
			end
			if (randPond == 10) then 
				terrainLayoutResult[row+1][col+1].terrainType = tt_00_pondfish	
				terrainLayoutResult[row+1][col-1].terrainType = tt_00_pondfish	
			end
			if (randPond == 11) then 
				terrainLayoutResult[row][col-1].terrainType = tt_00_pondfish	
				terrainLayoutResult[row-1][col-1].terrainType = tt_00_pondfish	
			end
			if (randPond == 12) then 
				terrainLayoutResult[row][col+1].terrainType = tt_00_pondfish	
				terrainLayoutResult[row+1][col+1].terrainType = tt_00_pondfish	
			end
			if (randPond == 13) then 
				terrainLayoutResult[row+1][col].terrainType = tt_00_pondfish
				terrainLayoutResult[row][col-1].terrainType = tt_00_pondfish
			end
			if (randPond == 14) then 
				terrainLayoutResult[row-1][col].terrainType = tt_00_pondfish	
				terrainLayoutResult[row][col+1].terrainType = tt_00_pondfish	
			end
			if (randPond == 15) then 
				terrainLayoutResult[row][col-1].terrainType = tt_00_pondfish	
				terrainLayoutResult[row+1][col-1].terrainType = tt_00_pondfish	
			end
			if (randPond == 16) then 
				terrainLayoutResult[row-1][col+1].terrainType = tt_00_pondfish	
				terrainLayoutResult[row][col+1].terrainType = tt_00_pondfish	
			end
		end
	end
end

-- terrain stuff

-- placing random ponds around the map
terrainChance = 0.10

for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType ~= startBufferTerrain and 
		terrainLayoutResult[row][col].terrainType ~= playerStartTerrain and 
		terrainLayoutResult[row][col].terrainType ~= tt_flatland and 
		terrainLayoutResult[row][col].terrainType ~= tt_00_pondfish and 
		terrainLayoutResult[row][col].terrainType ~= tt_swamp and 
		terrainLayoutResult[row][col].terrainType ~= tt_hills_low_rolling) then
			--get chance to place the feature
			if(worldGetRandom() < terrainChance) then
				terrainLayoutResult[row][col].terrainType = tt_00_pondfish
			end	
			mountainSquares = 0

		-- place swamp around each lake -- remove later
			for row = 1, gridSize do
				for col = 1, gridSize do		
					if(terrainLayoutResult[row][col].terrainType == tt_00_pondfish) then
		
						featureNeighbors = {}
						featureNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
		
						--loop through neighbors of the current square to look for lakes
						for testNeighborIndex, testNeighbor in ipairs(featureNeighbors) do
							testNeighborRow = testNeighbor.x
							testNeighborCol = testNeighbor.y
							currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
		
							if(currentTerrainType == tt_plains) then
								terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_swamp
							end
						end
					end
				end
			end
		end
	end
end

-- change swamp squares back to plains
plainsSquares = 0
TerrainChance3 = 1.00

for row = 1, gridSize do
	for col = 1, gridSize do
		--check for the terrain type you had chosen before
		if(terrainLayoutResult[row][col].terrainType == tt_swamp and worldGetRandom() < TerrainChance3) then
			--knowing that you are looking at the correct type of square, do something with it
			plainsSquares = plainsSquares + 1
			terrainLayoutResult[row][col].terrainType = tt_plains
		end
	end
end

-- print some results
