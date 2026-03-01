-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--START SCRIPT Mediterranean

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

lakeTerrain = tt_lake_medium_mediterranean

--set up resource pockets
pocketResources1 = {}
pocketResources2 = {}
pocketResources3 = {}

--create groups of pocket resources that will equal out to balanced resources
--players will randomly get one set of these
pocketResourceList = {}
table.insert(pocketResourceList, pocketResources1)
table.insert(pocketResourceList, pocketResources2)
table.insert(pocketResourceList, pocketResources3)

psa = tt_pocket_stone_a
psb = tt_pocket_stone_b
psc = tt_pocket_stone_c
pga = tt_pocket_gold_a
pgb = tt_pocket_gold_b
pgc = tt_pocket_gold_c
pwa = tt_pocket_wood_a
pwb = tt_pocket_wood_b
pwc = tt_pocket_wood_c

table.insert(pocketResources1, psa)
table.insert(pocketResources1, pgb)
table.insert(pocketResources1, pwc)
table.insert(pocketResources2, psb)
table.insert(pocketResources2, pgc)
table.insert(pocketResources2, pwa)
table.insert(pocketResources3, psc)
table.insert(pocketResources3, pga)
table.insert(pocketResources3, pwb)


-- FUNCTIONS

local function Normalize(value, min, max)
	
	return ((value * (max - min)) + min)
end

--this function returns a table of all squares within a given radius of an origin point provided
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

--simple function to check if a table contains a matching element in the format we use for grid coordinates
local function Table_ContainsCoordinate(table, value)

	tableHasCoord = false
	
	for index, val in ipairs(table) do
		if (val[1] == value[1] and val[2] == value[2]) then
			tableHasCoord = true
		end
	end
	
	return tableHasCoord
end

--this function will expand an area of terrain within provided constraints.
function GrowTerrainArea(startRow, startCol, numPasses, terrainToChange, terrainToPlace)	
	
	local areaSquares = {}
	local growthChance = 0.95
	
	table.insert(areaSquares, 1, {startRow, startCol})
	for index = 1, numPasses do
		if (index == 1) then
			row = startRow
			col = startCol
			squareNum = 1
		else
			squareNum = math.ceil(worldGetRandom() * #areaSquares)
			square = areaSquares[squareNum]
			row = square[1]
			col = square[2]
		end
		
		tempSquares = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, terrainToChange, terrainLayoutResult)
		
		for sIndex = 1, #tempSquares do
			x = tempSquares[sIndex][1]
			y = tempSquares[sIndex][2]
			
			if (worldGetRandom() <= growthChance and Table_ContainsCoordinate(areaSquares, tempSquares[sIndex]) == false) then
				terrainLayoutResult[x][y].terrainType = terrainToPlace
				table.insert(areaSquares, #areaSquares + 1, {x, y})
			end
			
		end
		
		table.remove(areaSquares, squareNum)
		
	end
	
	return areaSquares
	
end


-- COARSE GRID SET UP
terrainLayoutResult = {}    -- set up initial table for coarse map grid

--call the standard function to set up our grid using standard dimensions/square
--function found in scar/terrainlayout/library/map_setup
--use this function if creating a map with standard resolution and dimension (most maps)
--see the island maps for examples of non-standard resolutions
gridRes = 25
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(gridRes)

--these values are values received specifically to let the script know information about map dimensions
--the number of players is grabbed from the map setup menu screen and includes both human and AI players
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid

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

teamMappingTable = CreateTeamMappingTable()
	
minPlayerDistance = 24
minTeamDistance = 36
edgeBuffer = 4

playerStartTerrain = tt_mediterranean_player_start

spawnBlockers = {}
table.insert(spawnBlockers, tt_holy_site_hill_low_loose)
--table.insert(spawnBlockers, lakeTerrain)

basicTerrain = {}
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_plains_clearing)
table.insert(basicTerrain, tt_flatland)
table.insert(basicTerrain, tt_plateau_low)
table.insert(basicTerrain, tt_none)

startBufferRadius = 3
startBufferTerrain = tt_flatland


if(worldTerrainWidth <= 417) then
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.4))
	edgeBuffer = 2
	innerExclusion = 0.475
	topSelectionThreshold = 0.01
	impasseTypes = {tt_holy_site}
	impasseDistance = 6.5
	cornerThreshold = 1
	startBufferRadius = 3
elseif(worldTerrainWidth <= 513) then
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.3))
	edgeBuffer = 2
	innerExclusion = 0.65
	topSelectionThreshold = 0.01
	impasseTypes = {tt_mountains_small}
	impasseDistance = 6.5
	cornerThreshold = 1
	startBufferRadius = 3.8
elseif(worldTerrainWidth <= 641) then
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.25))
	edgeBuffer = 2
	innerExclusion = 0.75
	topSelectionThreshold = 0.01
	impasseTypes = {tt_mountains_small}
	impasseDistance = 6.5
	cornerThreshold = 2
	startBufferRadius = 4
elseif(worldTerrainWidth <= 769) then
	minTeamDistance = Round((#terrainLayoutResult * 0.9))
	minPlayerDistance = Round((#terrainLayoutResult * 0.25))
	edgeBuffer = 2
	innerExclusion = 0.8
	topSelectionThreshold = 0.01
	impasseTypes = {tt_mountains_small}
	impasseDistance = 6.5
	cornerThreshold = 1
	startBufferRadius = 4.5
else
	minTeamDistance = Round((#terrainLayoutResult * 0.9))
	minPlayerDistance = Round((#terrainLayoutResult * 0.25))
	edgeBuffer = 2
	innerExclusion = 0.8
	topSelectionThreshold = 0.01
	impasseTypes = {tt_mountains_small}
	impasseDistance = 6.5
	cornerThreshold = 1
	startBufferRadius = 5
end

maxLakes = 1
forestRadius = 3
lakeExpansions = 3
lakeBuffer = 5
--

if(worldTerrainHeight <= 417) then
	outerHillRadius = 3
	innerHillRadius = 4
	forestRadius = 2
	maxLakes = 1
	lakeExpansions = 65
	lakeBuffer = 0
	heightOffset = 1
	widthOffset = 1
elseif(worldTerrainHeight <= 513) then
	outerHillRadius = 3
	innerHillRadius = 3
	forestRadius = 2
	maxLakes = 1
	lakeExpansions = 98
	lakeBuffer = 0
	heightOffset = 1
	widthOffset = 1
elseif(worldTerrainHeight <= 641) then
	outerHillRadius = 2
	innerHillRadius = 2
	forestRadius = 2
	maxLakes = 1
	lakeExpansions = 136
	lakeBuffer = 0
	heightOffset = 1
	widthOffset = 1
elseif(worldTerrainHeight <= 769) then
	outerHillRadius = 3
	innerHillRadius = 5
	forestRadius = 3
	maxLakes = 1
	lakeExpansions = 248
	lakeBuffer = 0
	heightOffset = 2
	widthOffset = 2
elseif(worldTerrainHeight <= 897) then
	outerHillRadius = 4
	innerHillRadius = 8
	lakeExpansions = 290
	lakeBuffer = 1
	heightOffset = 3
	widthOffset = 3
end

print("width/height offset: " .. heightOffset)



--OVERALL TERRAIN STUFF----------------------------------------------------------------

cliffChance = 0.25

--along the outside of the map (defined as outside the outerHillRadius) randomly place various heights of hills
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType ~= playerStartTerrain and terrainLayoutResult[row][col].terrainType ~= tt_flatland) then
			if(row <= outerHillRadius or row > (gridSize - outerHillRadius) or col <= outerHillRadius or col > (gridSize - outerHillRadius)) then
				terrainLayoutResult[row][col].terrainType = tt_plains
				if(worldGetRandom() < cliffChance) then
					terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
					
				elseif(worldGetRandom() < (cliffChance* 0.5)) then
					terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
				end
			end
		end
		
	end		
end

--calculate inner box size

lakeBoxStart = mapMidPoint - lakeBuffer
lakeBoxEnd = mapMidPoint + lakeBuffer
print("lake box start: " .. lakeBoxStart .. ", lake box end: " .. lakeBoxEnd)
	
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
terrainLayoutResult[currentLakeRow][currentLakeCol].terrainType = lakeTerrain
GrowTerrainAreaToSize(currentLakeRow, currentLakeCol, lakeExpansions, {tt_none}, lakeTerrain, terrainLayoutResult)






--fill in lake squares
for row = 1, gridSize do
	for col = 1, gridSize do
		
		adjLakes = {}
		adjLakeNum = 0
		--do a check to ensure adjacency checks are in bounds
		--function found in the engine folder, under scar/terrainlayout/library/calculationfunctions
		if(IsInMap (row, col, gridSize, gridSize)) then
			--check to see if the current square is a spire
			if(terrainLayoutResult[row][col].terrainType == tt_none) then
				
				
				--GetNeighbors looks at the terrain grid and returns a table containing the squares above, below, and to the left and right of the specified square
				--function found in scar/terrainlayout/library/template_functions
				adjLakes = GetNeighbors(row, col, terrainLayoutResult)
					
				--loop through neighbors of the current square to look for lakes
				for testNeighborIndex, testNeighbor in ipairs(adjLakes) do
					testNeighborRow = testNeighbor.x
					testNeighborCol = testNeighbor.y
					currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
					
					if(currentTerrainType == lakeTerrain) then
						adjLakeNum = adjLakeNum + 1
					end
				end
			
				--check to see if it found any adjacent lakes
				if(adjLakeNum > 2) then
				
					terrainLayoutResult[row][col].terrainType = lakeTerrain	
				end
			end
		end
	end
end

--get rid of isolated squares
for row = 1, gridSize do
	for col = 1, gridSize do
		
		adjLakes = {}
		adjLakeNum = 0
		--do a check to ensure adjacency checks are in bounds
		--function found in the engine folder, under scar/terrainlayout/library/calculationfunctions
		if(IsInMap (row, col, gridSize, gridSize)) then
			--check to see if the current square is a spire
			if(terrainLayoutResult[row][col].terrainType == lakeTerrain) then
				
				
				--GetNeighbors looks at the terrain grid and returns a table containing the squares above, below, and to the left and right of the specified square
				--function found in scar/terrainlayout/library/template_functions
				adjLakes = GetNeighbors(row, col, terrainLayoutResult)
					
				--loop through neighbors of the current square to look for lakes
				for testNeighborIndex, testNeighbor in ipairs(adjLakes) do
					testNeighborRow = testNeighbor.x
					testNeighborCol = testNeighbor.y
					currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
					
					if(currentTerrainType == lakeTerrain) then
						adjLakeNum = adjLakeNum + 1
					end
				end
			
				--check to see if it found any adjacent lakes
				if(adjLakeNum == 0) then
				
					terrainLayoutResult[row][col].terrainType = tt_plains	
				end
			end
		end
	end
end

--put plains buffer around the lake
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around lake squares 
		if(terrainLayoutResult[row][col].terrainType == lakeTerrain) then
			lakeNeighbors = {}
			lakeNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT ~= tt_flatland and currentLakeCheckTT ~= playerStartTerrain and currentLakeCheckTT ~= lakeTerrain) then
					terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType = tt_beach
					
				end
			end
		end
	end
end

--thin the beach to ensure that it doesn't cut off thin parts of the lakes
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--get rid of beaches that should be lake 
		if(terrainLayoutResult[row][col].terrainType == tt_beach) then
			currentLakeCount = 0
			lakeNeighbors = {}
			lakeNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT == lakeTerrain) then
					currentLakeCount = currentLakeCount + 1
				end
			end
			if(currentLakeCount > 3) then
				terrainLayoutResult[row][col].terrainType = lakeTerrain
			end
		end
	end
end



-- SETUP PLAYER STARTS
terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, false, terrainLayoutResult)


--pad start areas
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around lake squares 
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			startNeighbors = {}
			startNeighbors = GetAllSquaresInRadius(row, col, startBufferRadius, terrainLayoutResult)
			for startCheckIndex, startCheckNeighbor in ipairs(startNeighbors) do	
				currentStartCheckNeighborRow = startCheckNeighbor[1]
				currentStartCheckNeighborCol = startCheckNeighbor[2]
				
				currentStartCheckTT = terrainLayoutResult[currentStartCheckNeighborRow][currentStartCheckNeighborCol].terrainType
				if(currentStartCheckTT ~= tt_holy_site_hill_low_loose and currentStartCheckTT ~= playerStartTerrain) then
					terrainLayoutResult[currentStartCheckNeighborRow][currentStartCheckNeighborCol].terrainType = tt_flatland
				end
			end
		end
	end
end

--grab a list of all edge lake squares
lakeEdgeSquares = {}
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around lake squares 
		if(terrainLayoutResult[row][col].terrainType == tt_beach or terrainLayoutResult[row][col].terrainType == tt_flatland) then
			lakeNeighbors = {}
			lakeNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				hasNearbyStartArea = false
				startCheckSquares = {}
				startCheckSquares = Get12Neighbors(currentLakeCheckNeighborRow, currentLakeCheckNeighborCol, terrainLayoutResult)
				
				for startCheckIndex, startCheckNeighbor in ipairs(startCheckSquares) do	
					currentStartCheckNeighborRow = startCheckNeighbor.x
					currentStartCheckNeighborCol = startCheckNeighbor.y
					
					if(terrainLayoutResult[currentStartCheckNeighborRow][currentStartCheckNeighborCol].terrainType == tt_flatland or terrainLayoutResult[currentStartCheckNeighborRow][currentStartCheckNeighborCol].terrainType == playerStartTerrain) then
						hasNearbyStartArea = true
					end
				end
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT == lakeTerrain or currentLakeCheckTT == tt_lake_medium_mediterranean) then
					if(Table_ContainsCoordinate(lakeEdgeSquares, lakeCheckNeighbor) == false) then
						if(hasNearbyStartArea == false) then
							newInfo = {}
							newInfo = {currentLakeCheckNeighborRow, currentLakeCheckNeighborCol}
							table.insert(lakeEdgeSquares, newInfo)
						end
					end
				end
			end
		end
	end
end

square1 = {}
square2 = {}

--to start the holy site selection, find the furthest lake edge square from all player starts
--this should be between teams

furthestDistance = 0
furthestIndex = 0

for edgeIndex = 1, #lakeEdgeSquares do
	currentEdgeRow = lakeEdgeSquares[edgeIndex][1]
	currentEdgeCol = lakeEdgeSquares[edgeIndex][2]
	
	currentDistance = 10000
	--loop through map and find player start terrains and measure the distance to them
	--here we are trying to find the closest player start
	for testRow = 1, #terrainLayoutResult do
		for testCol = 1, #terrainLayoutResult do
			
			if(terrainLayoutResult[testRow][testCol].terrainType == playerStartTerrain) then
				testDistance = GetDistance(currentEdgeRow, currentEdgeCol, testRow, testCol, 2)
				if (testDistance < currentDistance) then
					currentDistance = testDistance
				end
			end
		end
	end
	
	--see if this edge square has a farther min distance to a player
	if(currentDistance > furthestDistance) then
		furthestDistance = currentDistance
		furthestIndex = edgeIndex
	end
end

chosenIndex = furthestIndex

--find lake average point
lakeRow = 0
lakeCol = 0
lakeSquareCount = 0
for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(terrainLayoutResult[row][col].terrainType == lakeTerrain or terrainLayoutResult[row][col].terrainType == tt_lake_medium_mediterranean) then
			lakeRow = lakeRow + row
			lakeCol = lakeCol + col 
			lakeSquareCount = lakeSquareCount + 1
		end
	end
end

averageLakeRow = Round((lakeRow / lakeSquareCount), 0)
averageLakeCol = Round((lakeCol / lakeSquareCount), 0)

--randomIndex1 = math.ceil(worldGetRandom() * #lakeEdgeSquares)
--print("random index is at " .. randomIndex1 .. " out of " .. #lakeEdgeSquares)
square1 = lakeEdgeSquares[chosenIndex]
square1Row = square1[1]
square1Col = square1[2]

rowDiff = averageLakeRow - square1Row
colDiff = averageLakeCol - square1Col

if(math.abs(rowDiff) > math.abs(colDiff)) then
	maxDiff = rowDiff
else
	maxDiff = colDiff
end


if(maxDiff < 0) then
	maxDiff = maxDiff * -1
end

print("row diff: " .. rowDiff .. ", colDiff: " .. colDiff .. ", maxDiff: " .. maxDiff)

if(rowDiff > 0 or rowDiff < 0) then
	rowIncrement = rowDiff / maxDiff
else
	rowIncrement = 0
end
if(colDiff > 0 or colDiff < 0) then
	colIncrement = colDiff / maxDiff
else
	colIncrement = 0
end

print("row increment: " .. rowIncrement .. ", colIncrement: " .. colIncrement)

--draw line from centre of lake to other side, extending the line from the first holy site to the opposite shoreline

foundBank = false
currentRow = averageLakeRow
currentCol = averageLakeCol
repeat
	if(terrainLayoutResult[Round(currentRow, 0)][Round(currentCol, 0)].terrainType == lakeTerrain or terrainLayoutResult[Round(currentRow, 0)][Round(currentCol, 0)].terrainType == tt_lake_medium_mediterranean) then
		currentRow = currentRow + rowIncrement
		currentCol = currentCol + colIncrement
	else
		foundBank = true
	end
	
until(foundBank == true or currentRow >= gridSize or currentCol >= gridSize or currentRow <= 1 or currentCol <= 1)

currentRow = Round(currentRow, 0)
currentCol = Round(currentCol, 0)

for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around holy sites 
		if(terrainLayoutResult[row][col].terrainType == tt_holy_site_hill_low_loose) then
			holyNeighbors = {}
			holyNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			for holyCheckIndex, holyCheckNeighbor in ipairs(holyNeighbors) do	
				currentHolyCheckNeighborRow = holyCheckNeighbor.x
				currentHolyCheckNeighborCol = holyCheckNeighbor.y
				
				currentHolyCheckTT = terrainLayoutResult[currentHolyCheckNeighborRow][currentHolyCheckNeighborCol].terrainType
				if(currentHolyCheckTT == lakeTerrain) then
					terrainLayoutResult[currentHolyCheckNeighborRow][currentHolyCheckNeighborCol].terrainType = tt_hills_gentle_rolling
				end
			end
		end
	end
end


for row = 1, gridSize do
	for col = 1, gridSize do
		
		--eliminate single lake squares
		if(terrainLayoutResult[row][col].terrainType == lakeTerrain or terrainLayoutResult[row][col].terrainType == tt_lake_medium_mediterranean) then
			currentLakeNeighbors = 0
			lakeNeighbors = {}
			lakeNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT == lakeTerrain or currentLakeCheckTT == tt_lake_medium_mediterranean) then
					currentLakeNeighbors = currentLakeNeighbors + 1
				end
			end
			if(currentLakeNeighbors < 1) then
				terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
			end
		end
	end
end


--grab a list of all edge lake squares
lakeEdgeSquares = {}
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around lake squares 
		if(terrainLayoutResult[row][col].terrainType == tt_beach or terrainLayoutResult[row][col].terrainType == tt_flatland) then
			lakeNeighbors = {}
			lakeNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT == lakeTerrain or currentLakeCheckTT == tt_lake_medium_mediterranean) then
					if(Table_ContainsCoordinate(lakeEdgeSquares, lakeCheckNeighbor) == false) then
						newInfo = {}
						newInfo = {currentLakeCheckNeighborRow, currentLakeCheckNeighborCol}
						table.insert(lakeEdgeSquares, newInfo)
					end
				end
			end
		end
	end
end

square1 = {}
square2 = {}

randomIndex1 = math.ceil(worldGetRandom() * #lakeEdgeSquares)
print("random index is at " .. randomIndex1 .. " out of " .. #lakeEdgeSquares)
square1 = lakeEdgeSquares[randomIndex1]
square1Row = square1[1]
square1Col = square1[2]
square2Row = gridSize - square1Row
if(square2Row < 1) then 
	square2Row = 1
end
square2Col = gridSize - square1Col
if(square2Col < 1) then
	square2Col = 1
end

square2Row, square2Col = GetClosestSquare(square2Row, square2Col, lakeEdgeSquares)

print("square 1 found at " .. square1Row .. ", " .. square1Col)
print("square 2 found at " .. square2Row .. ", " .. square2Col)
terrainLayoutResult[square1Row][square1Col].terrainType = tt_settlement_naval_lake
terrainLayoutResult[square2Row][square2Col].terrainType = tt_settlement_naval_lake

--buffer lake depth around trade posts
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around lake squares 
		if(terrainLayoutResult[row][col].terrainType == tt_beach or terrainLayoutResult[row][col].terrainType == tt_settlement_naval_lake) then
			lakeNeighbors = {}
			lakeNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT == lakeTerrain) then
					terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType = tt_lake_medium_mediterranean
				end
			end
		end
	end
end

for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around lake squares 
		if(terrainLayoutResult[row][col].terrainType == lakeTerrain) then
			currentLakeNeighbors = 0
			lakeNeighbors = {}
			lakeNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT == lakeTerrain or currentLakeCheckTT == tt_lake_medium_mediterranean) then
					currentLakeNeighbors = currentLakeNeighbors + 1
				end
			end
			
			if(currentLakeNeighbors >= 8) then
				terrainLayoutResult[row][col].terrainType = tt_lake_medium_mediterranean
			end
			
			if(currentLakeNeighbors <= 2) then
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
		end
	end
end

--eliminate single lake squares
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--buffer around lake squares 
		if(terrainLayoutResult[row][col].terrainType == lakeTerrain or terrainLayoutResult[row][col].terrainType == tt_lake_medium_mediterranean) then
			currentLakeNeighbors = 0
			lakeNeighbors = {}
			lakeNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT == lakeTerrain or currentLakeCheckTT == tt_lake_medium_mediterranean) then
					currentLakeNeighbors = currentLakeNeighbors + 1
				end
			end
			
			if(currentLakeNeighbors <= 1) then
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
		end
	end
end

--place 2 land trade posts in corners
if(worldGetRandom() < 0.5) then
	terrainLayoutResult[1][1].terrainType = tt_settlement_plains
	terrainLayoutResult[gridSize][gridSize].terrainType = tt_settlement_plains
else
	terrainLayoutResult[1][gridSize].terrainType = tt_settlement_plains
	terrainLayoutResult[gridSize][1].terrainType = tt_settlement_plains
end



print("end of Mediterranean script")
--END OF MEDITERRANEAN SCRIPT-----------------------------