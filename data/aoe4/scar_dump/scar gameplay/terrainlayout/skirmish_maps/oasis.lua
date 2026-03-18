-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--OASIS MAP LAYOUT--------------------------------

print("Generating OASIS map")

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout
r = tt_flatland -- flatland will not be used in the map. This is just to set a square to "random"

h = tt_hills
s = tt_mountains_small
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_low_rolling
mr = tt_hills_med_rolling
hr = tt_hills_high_rolling
low = tt_plateau_low
med = tt_plateau_med
high = tt_plateau_high
p = tt_plains
t = tt_impasse_trees_plains
sh = tt_pocket_sheep_a
v = tt_valley

x = tt_pocket_berries

f = tt_trees_plains
c = tt_trees_plains_clearing
bf = tt_trees_hills_high_rolling_clearing

playerStartTerrain = tt_player_start_classic_plains_low_trees_oasis -- classic mode start
treeTerrain = tt_impasse_trees_small_plains_oasis

-- COARSE GRID SET UP
terrainLayoutResult = {}    -- set up initial table for coarse map grid

--call the standard function to set up our grid using standard dimensions/square
--function found in scar/terrainlayout/library/map_setup
--use this function if creating a map with standard resolution and dimension (most maps)
--see the island maps for examples of non-standard resolutions
gridRes = 18
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(gridRes)

--these values are values received specifically to let the script know information about map dimensions
--the number of players is grabbed from the map setup menu screen and includes both human and AI players
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
-- you need to use this function when creating a new map
-- found in the engine library under scar/terrainlayout/library/setsquaresfunctions
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

-- PLACE TERRAIN FEATURES
baseGridSize = 13
outerRadius = 3.5 / baseGridSize * gridSize
middleRadius = 2.5 / baseGridSize * gridSize
innerRadius = 1.25 / baseGridSize * gridSize
mapMidPoint = math.ceil(gridSize / 2)


--OVERALL TERRAIN STUFF----------------------------------------------------------------

--make outer rings of gradually reducing hills--------------------------

--deal with outer ring of medium rolling hills

maxLakes = 1
forestRadius = 3
lakeExpansions = 3
lakeBuffer = 5
--

if(worldTerrainHeight <= 417) then
	outerHillRadius = 2
	innerHillRadius = 2
	forestRadius = 2
	maxLakes = 1
	lakeExpansions = 8
	lakeBuffer = 0
	heightOffset = 1
	widthOffset = 1
	lakeRadius = 2
elseif(worldTerrainHeight <= 513) then
	outerHillRadius = 2
	innerHillRadius = 2
	forestRadius = 2
	maxLakes = 1
	lakeExpansions = 8
	lakeBuffer = 0
	heightOffset = 1
	widthOffset = 1
	lakeRadius = 2
elseif(worldTerrainHeight <= 641) then
	outerHillRadius = 3
	innerHillRadius = 3
	forestRadius = 2
	maxLakes = 1
	lakeExpansions = 12
	lakeBuffer = 0
	heightOffset = 1
	widthOffset = 1
	lakeRadius = 4
elseif(worldTerrainHeight <= 769) then
	outerHillRadius = 3
	innerHillRadius = 5
	forestRadius = 3
	maxLakes = 1
	lakeExpansions = 128
	lakeBuffer = 0
	heightOffset = 2
	widthOffset = 2
	lakeRadius = 6
elseif(worldTerrainHeight <= 897) then
	outerHillRadius = 4
	innerHillRadius = 8
	lakeExpansions = 150
	lakeBuffer = 1
	heightOffset = 3
	widthOffset = 3
	lakeRadius = 6
end



hillChance = 0.3

--along the outside of the map (defined as outside the outerHillRadius) randomly place various heights of cliff squares
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType ~= playerStartTerrain and terrainLayoutResult[row][col].terrainType ~= tt_flatland) then
			if(row <= outerHillRadius or row > (gridSize - outerHillRadius) or col <= outerHillRadius or col > (gridSize - outerHillRadius)) then
				terrainLayoutResult[row][col].terrainType = tt_plains
				if(worldGetRandom() < hillChance) then
					terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
					
				elseif(worldGetRandom() < (hillChance* 0.5)) then
					terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
				end
			end
		end
		
	end		
end

--make flat inner area

--pick places for lake origins----------------------------------------

--lakeBuffer is the # squares between the hills and the box that lakes can form in

--calculate inner box size

lakeBoxStart = mapMidPoint - lakeBuffer
lakeBoxEnd = mapMidPoint + lakeBuffer
print("lake box start: " .. lakeBoxStart .. ", lake box end: " .. lakeBoxEnd)

lakeTerrain = tt_lake_shallow_oasis
	
--function to get a random square within a box set by the given constraints
--found in the engine folder at scar/terrainlayout/library/getsquaresfunctions
currentRow, currentCol = GetSquareInBox (lakeBoxStart, lakeBoxEnd, lakeBoxStart, lakeBoxEnd, gridSize)
currentLakeStart = {currentRow, currentCol}

print("current lake row: " .. currentRow .. ", current lake col: " .. currentCol)

--do lake expansion
firstExpansionChance = 0.95
secondExpansionChance = 0.75
thirdExpansionChance = 0.45

lakeSquares = {}
currentLakeRow = currentLakeStart[1]
currentLakeCol = currentLakeStart[2]
terrainLayoutResult[currentLakeRow][currentLakeCol].terrainType = tt_hills_gentle_rolling
nearbySquares = GetAllSquaresInRadius(currentLakeRow, currentLakeCol, lakeRadius, terrainLayoutResult)

for lakeCheckIndex, lakeCheckNeighbor in ipairs(nearbySquares) do	
	currentLakeCheckNeighborRow = lakeCheckNeighbor[1]
	currentLakeCheckNeighborCol = lakeCheckNeighbor[2]
	
	terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType = lakeTerrain
end
--resource stuff
--put woods and food around the central lakes

--grab all the clearing squares in a table to place 2 holy sites
clearingSquares = {}


--find the lake squares and put a layer of forests around them
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around lake squares 
		if(terrainLayoutResult[row][col].terrainType == lakeTerrain) then
			lakeNeighbors = {}
			lakeNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT ~= lakeTerrain and currentLakeCheckTT ~= tt_lake_shallow_hill_fish) then
					newInfo = {}
					newInfo = {currentLakeCheckNeighborRow, currentLakeCheckNeighborCol}
					table.insert(clearingSquares, newInfo)
				end
			end
		end
	end
end

--find the lake squares and put a layer of forests around them
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around lake squares 
		if(terrainLayoutResult[row][col].terrainType == lakeTerrain) then
			lakeNeighbors = {}
			lakeNeighbors = Get20Neighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT ~= lakeTerrain and currentLakeCheckTT ~= tt_lake_shallow_hill_fish) then
					terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType = tt_trees_plains_clearing
					
				end
			end
		end
	end
end

--make a second clearing layer



for treeRow = 1, gridSize do
	for treeCol = 1, gridSize do
		
		--buffer around clearing squares 
		if(terrainLayoutResult[treeRow][treeCol].terrainType == tt_trees_plains_clearing) then
			treeNeighbors = {}
			treeNeighbors = Get20Neighbors(treeRow, treeCol, terrainLayoutResult)
			for treeCheckIndex, treeCheckNeighbor in ipairs(treeNeighbors) do	
				currentTreeCheckNeighborRow = treeCheckNeighbor.x
				currentTreeCheckNeighborCol = treeCheckNeighbor.y
				
				currentTreeCheckTT = terrainLayoutResult[currentTreeCheckNeighborRow][currentTreeCheckNeighborCol].terrainType
				if(currentTreeCheckTT ~= lakeTerrain and currentTreeCheckTT ~= tt_trees_plains_clearing) then
					terrainLayoutResult[currentTreeCheckNeighborRow][currentTreeCheckNeighborCol].terrainType = treeTerrain
					print("changing " .. currentTreeCheckNeighborRow .. ", " .. currentTreeCheckNeighborCol .. " to a tree terrain")
					
				end
			end
		end
	end
end


for row = 1, gridSize do
	for col = 1, gridSize do
		isOuterTree = false
		if(terrainLayoutResult[row][col].terrainType == treeTerrain) then
			
			treeNeighbors = {}
			treeNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for treeCheckIndex, treeCheckNeighbor in ipairs(treeNeighbors) do	
				currentTreeCheckNeighborRow = treeCheckNeighbor.x
				currentTreeCheckNeighborCol = treeCheckNeighbor.y
				
				currentTreeCheckTT = terrainLayoutResult[currentTreeCheckNeighborRow][currentTreeCheckNeighborCol].terrainType
				if(currentTreeCheckTT == tt_none) then
					isOuterTree = true
				end
			end
		end
		
		if(isOuterTree == true) then
		--	terrainLayoutResult[row][col].terrainType = tt_impasse_trees_plains
			terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth
		end
	end
end

--replace outer layer with more small trees to ensure centre is fully enclosed
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == tt_trees_plains_stealth) then
			
			terrainLayoutResult[row][col].terrainType = treeTerrain
		--	terrainLayoutResult[row][col].terrainType = tt_plains
		end
		
	end
end

square1 = {}
square2 = {}

randomIndex1 = math.ceil(worldGetRandom() * #clearingSquares)
print("random index is at " .. randomIndex1 .. " out of " .. #clearingSquares)
square1 = clearingSquares[randomIndex1]
square1Row = square1[1]
square1Col = square1[2]
square2Row, square2Col = GetFurthestSquare(square1[1], square1[2], clearingSquares)

print("square 1 found at " .. square1Row .. ", " .. square1Col)
print("square 2 found at " .. square2Row .. ", " .. square2Col)
terrainLayoutResult[square1Row][square1Col].terrainType = tt_holy_site_loose_oasis
terrainLayoutResult[square2Row][square2Col].terrainType = tt_holy_site_loose_oasis



--spawn 2 boar on opposite sides of the lake
clearingSquares = {}
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around lake squares 
		if(terrainLayoutResult[row][col].terrainType == lakeTerrain) then
			lakeNeighbors = {}
			lakeNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT ~= lakeTerrain and currentLakeCheckTT ~= tt_lake_shallow_hill_fish and currentLakeCheckTT ~= tt_holy_site_loose_oasis) then
					newInfo = {}
					newInfo = {currentLakeCheckNeighborRow, currentLakeCheckNeighborCol}
					table.insert(clearingSquares, newInfo)
				end
			end
		end
	end
end

square1 = {}
square2 = {}

randomIndex1 = math.ceil(worldGetRandom() * #clearingSquares)
print("random index is at " .. randomIndex1 .. " out of " .. #clearingSquares)
square1 = clearingSquares[randomIndex1]
square1Row = square1[1]
square1Col = square1[2]
square2Row, square2Col = GetFurthestSquare(square1[1], square1[2], clearingSquares)

print("square 1 found at " .. square1Row .. ", " .. square1Col)
print("square 2 found at " .. square2Row .. ", " .. square2Col)
terrainLayoutResult[square1Row][square1Col].terrainType = tt_boar_spawner_single
terrainLayoutResult[square2Row][square2Col].terrainType = tt_boar_spawner_single



--Start Position Stuff---------------------------------------------------------------------------------
teamMappingTable = CreateTeamMappingTable()
	
minPlayerDistance = 24
minTeamDistance = 36
edgeBuffer = 4

playerStartTerrain = tt_player_start_classic_plains_low_trees_oasis

spawnBlockers = {}
table.insert(spawnBlockers, tt_rock_pillar)
table.insert(spawnBlockers, lakeTerrain)

basicTerrain = {}
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_plains_clearing)
table.insert(basicTerrain, tt_flatland)
table.insert(basicTerrain, tt_plateau_low)
table.insert(basicTerrain, tt_none)

startBufferRadius = 2
startBufferTerrain = tt_flatland

impasseTypes = {treeTerrain, tt_settlement_plains}
if(worldTerrainWidth <= 417) then
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 1.2))
	edgeBuffer = 2
	innerExclusion = 0.52
	topSelectionThreshold = 0.001
	
	impasseDistance = 2.5
	cornerThreshold = 1
elseif(worldTerrainWidth <= 513) then
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.25))
	edgeBuffer = 3
	innerExclusion = 0.495
	topSelectionThreshold = 0.01
	impasseDistance = 3
	cornerThreshold = 3
elseif(worldTerrainWidth <= 641) then
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.25))
	edgeBuffer = 4
	innerExclusion = 0.58
	topSelectionThreshold = 0.01
	impasseDistance = 4.5
	cornerThreshold = 4
elseif(worldTerrainWidth <= 769) then
	minTeamDistance = Round((#terrainLayoutResult * 0.9))
	minPlayerDistance = Round((#terrainLayoutResult * 0.25))
	edgeBuffer = 5
	innerExclusion = 0.55
	topSelectionThreshold = 0.01
	impasseDistance = 4.5
	cornerThreshold = 5
else
	minTeamDistance = Round((#terrainLayoutResult * 0.9))
	minPlayerDistance = Round((#terrainLayoutResult * 0.3))
	edgeBuffer = 5
	innerExclusion = 0.55
	topSelectionThreshold = 0.01
	impasseDistance = 4.5
	cornerThreshold = 5
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


-- SETUP PLAYER STARTS
terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)




print("end of OASIS script")
--END OF SCRIPT

