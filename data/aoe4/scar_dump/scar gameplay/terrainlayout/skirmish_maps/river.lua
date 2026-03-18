-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout
r = tt_flatland -- flatland will not be used in the map. This is just to set a square to "random"

h = tt_hills
m = tt_mountains_small
e = tt_hills_gentle_rolling
b = tt_hills_low_rolling
d = tt_hills_med_rolling
j = tt_hills_high_rolling
l = tt_plateau_low
g = tt_plateau_med
i = tt_mountains
p = tt_plains
r = tt_river
v = tt_valley_shallow

f = tt_trees_plains
c = tt_trees_plains_clearing
bf = tt_trees_hills_high_rolling_clearing

playerStartTerrainPlain = tt_player_start_classic_plains

nomadStart = false
if (winConditionOptions.section_starting_conditions and winConditionOptions.section_starting_conditions.option_age_start) then
	nomadStart = (winConditionOptions.section_starting_conditions.option_age_start.enum_value == winConditionOptions.section_starting_conditions.option_age_start.enum_items.nomad_start)
	print("NOMAD START CONDITION IS: " ..winConditionOptions.section_starting_conditions.option_age_start.enum_value.." ("..tostring(nomadStart)..")")
else
	print("NOMAD START CONDITION IS NOT SET (FALSE)")
end

if(nomadStart) then

	playerStartTerrainHill = tt_player_start_nomad_hills_low_rolling -- nomad mode start
	playerStartTerrainPlain = tt_player_start_nomad_plains
	
else

	playerStartTerrainHill = tt_player_start_classic_hills_low_rolling -- classic mode start
	playerStartTerrainPlain = tt_player_start_classic_plains

end

--set up resource pockets for nomad
--[[tacticalPocketResources1 = {}
tacticalPocketResources2 = {}
tacticalPocketResources3 = {}]]

nomadPocketResources1 = {}
nomadPocketResources2 = {}
nomadPocketResources3 = {}

-- NOMAD STARTING RESOURCES
nomadPocketResourceList = {}
table.insert(nomadPocketResourceList, nomadPocketResources1)
table.insert(nomadPocketResourceList, nomadPocketResources2)
table.insert(nomadPocketResourceList, nomadPocketResources3)

esa = tt_pocket_stone_food
print("Econ Stone pocket a is " ..esa)
esb = tt_pocket_stone_gold
print("Econ Stone pocket b is " ..esb)
esc = tt_pocket_stone_wood
print("Econ Stone pocket c is " ..esc)
ega = tt_pocket_gold_food
print("Econ Gold pocket a is " ..ega)
egb = tt_pocket_gold_wood
print("Econ Gold pocket b is " ..egb)
ewa = tt_pocket_wood_food
print("Econ Wood pocket a is " ..ewa)

table.insert(nomadPocketResources1, esa)
table.insert(nomadPocketResources1, esb)
table.insert(nomadPocketResources1, esc)
table.insert(nomadPocketResources1, ewa)
table.insert(nomadPocketResources2, esb)
table.insert(nomadPocketResources2, ega)
table.insert(nomadPocketResources2, egb)
table.insert(nomadPocketResources2, ewa)
table.insert(nomadPocketResources3, esc)
table.insert(nomadPocketResources3, egb)
table.insert(nomadPocketResources3, ewa)
table.insert(nomadPocketResources3, ewa)

-- debug output for nomad pockets
for set = 1, #nomadPocketResourceList do
	
	for pocket = 1, #nomadPocketResourceList[set] do
		print("Econ Set " ..set .." pocket resource " ..pocket .." is " ..nomadPocketResourceList[set][pocket])
	end
	
end

-- MAP/GAME SET UP ------------------------------------------------------------------------
terrainLayoutResult = {}    -- set up initial table for coarse map grid. Must be named this.

gridHeight, gridWidth, gridSize = SetCoarseGrid() -- sets up the coarse grid using the function in the map_setup lua file in the library folder

-- debug output for grid setup
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map terrain using the function in the map_setup lua file in the library folder
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

--RIVER
-- set river points west to east
amplitude = 0
rowMidPoint = Round(gridHeight / 2, 0)
--turnColumns = {1,2,4,7,11,16,20}  -- commenting the old turnColoumn table to ensure a stright river for where we put the waterfall. We may reset this on later waterfall versions
turnColumns = {1,4,7,11,16,20} -- columns where the river will generate a turn point
baseDefaultRow = 11 -- variable for scaling turn points by map size
baseGridSize = 21 -- base grid size for scaling turn points by map size
baseAmplitudeMod = Round(2 * rowMidPoint / baseDefaultRow, 0) -- base amplitude (distance from center line
numberOfTurns = #turnColumns
riverTurnPoints = {} -- table to hold hte turn point locations

-- determine the turns in the river and generate points to connect with line drawing functions
-- each point will deviate more from a center line as they move across the map
for index = 1, numberOfTurns do
	print("------ Turn " ..index .." ------")
	range = amplitude * baseAmplitudeMod	-- calculate how far from the middle the turn point can be
	
	if (index > 1) then

		column01 = math.ceil(turnColumns[index] / baseGridSize * gridSize)
		column02 = math.ceil(turnColumns[index - 1] / baseGridSize * gridSize)
		
		print("This Column: " ..column01 .." Last Column: " ..column02)
		
	end
	
	roll = Round(worldGetRandom() * range, 0)
	row = rowMidPoint - Round(range / 2, 0) + roll -- randomly determine how far the turn point deviates based on the range calculation above
	print("Amplitude = " ..amplitude .." Range = " ..range .." Roll = " ..roll .." Row = " ..row)
	
	-- calculate exact turn column
	if (index == 1) then
		col = 1
	elseif (index == numberOfTurns) then
		col = gridWidth - 1
	else
		col = math.ceil(turnColumns[index] / baseGridSize * gridSize)	
	end
	print("Turn Column is " ..col)
	
	amplitude = amplitude + 1
	table.insert(riverTurnPoints, index, {row, col}) -- add turn point into table
	print("Turn Coordinate " ..index .." Row = " ..row .." Col = " ..col)
end

-- calculate the river points
riverPoints = {}
x = riverTurnPoints[1][1]
y = riverTurnPoints[1][2]
table.insert(riverPoints, 1, {x, y})
print(riverPoints[1][1])
for index = 1, #riverTurnPoints - 1 do
	x1 = math.floor(riverTurnPoints[index][1])
	x2 = math.floor(riverTurnPoints[index + 1][1])
	y1 = math.floor(riverTurnPoints[index][2])
	y2 = math.floor(riverTurnPoints[index + 1][2])
	
	y1 = y1 + 1
	
	if (y1 > gridWidth) then y1 = gridwidth - 1 end
	
	print("Line " ..index .." draw from " ..x1 .."," ..y1 .." to " ..x2 .."," ..y2)
	tempRiverPoints = {} -- table to hold the river points
	tempRiverPoints = DrawLineOfTerrainNoDiagonal(x1, y1, x2, y2, true, r, gridSize, terrainLayoutResult) -- draws the river and stores the points in the table using the function from the drawlinesfunctions lua file in hte engine library
	
	-- insert the temporary points into the river points table
	for rIndex = 1, #tempRiverPoints do		
		x = tempRiverPoints[rIndex][1]
		y = tempRiverPoints[rIndex][2]
		print("RIVER POINTS: Row " ..x .." Col " ..y)
		table.insert(riverPoints, #riverPoints + 1, {x, y})
	end

end

-- set the final river point and add it to the end of the table
x = riverTurnPoints[#riverTurnPoints][1]
y = riverTurnPoints[#riverTurnPoints][2] + 1
table.insert(riverPoints, #riverPoints + 1, {x, y})

print("NUMBER OF RIVER POINTS: " ..#riverPoints)

-- cycle through river points and set the terrain type
for index = 1, #riverPoints do
	x = math.floor(riverPoints[index][1])
	y = math.floor(riverPoints[index][2])
	print("River point " ..index .." at row " ..x .." col " ..y)
	terrainLayoutResult[x][y].terrainType = r	
end

-- set a series of terrain to create a cliff in order to form a waterfall
weightedTerrainTypes = {i,m,m,b,b} -- table to hold terrain types for random selection. repeated entries used for weighting
print("--- Start of terrain setting --------------------")
for row = 1, gridHeight do
	print("------ Now at row " ..row .." ------")
	if (terrainLayoutResult[row][1].terrainType ~= r) then
		terrainLayoutResult[row][1].terrainType = GetRandomElement(weightedTerrainTypes)
		print("Setting terrain at Row " ..row .." Col 1")
	end
	
end

-- repeat terrain placement moving away from the edge of the map
weightedTerrainTypes = {i,m,m,b,b,b,l}

colMinRange = 2
colMaxRange = math.floor(gridWidth * .2)
print("Col Min Range = " ..colMinRange .." Col Max Range = " ..colMaxRange)
for row = 1, gridHeight do
	print("------ Now at row " ..row .." ------")
	for col = colMinRange, colMaxRange do
		if (terrainLayoutResult[row][col].terrainType ~= r) then
			terrainLayoutResult[row][col].terrainType = GetRandomElement(weightedTerrainTypes)
			print("Setting terrain at Row " ..row .." Col " ..col)
		end
	end
	
end

-- continuing with terrain placement
weightedTerrainTypes = {m,b,b,b,h,l}

colMinRange = colMaxRange + 1
colMaxRange = math.floor(gridWidth * .4)
print("Col Min Range = " ..colMinRange .." Col Max Range = " ..colMaxRange)
for row = 1, gridHeight do
	print("------ Now at row " ..row .." ------")	
	for col = colMinRange, colMaxRange do
		if (terrainLayoutResult[row][col].terrainType ~= r) then
			terrainLayoutResult[row][col].terrainType = GetRandomElement(weightedTerrainTypes)
			print("Setting terrain at Row " ..row .." Col " ..col)
		end
	end
	
end

-- continuing with terrain placement
weightedTerrainTypes = {b,b,h,e,p,p,l}

colMinRange = colMaxRange + 1
colMaxRange = math.floor(gridWidth * .7)
print("Col Min Range = " ..colMinRange .." Col Max Range = " ..colMaxRange)
for row = 1, gridHeight do
	print("------ Now at row " ..row .." ------")	
	for col = colMinRange, colMaxRange do
		print("Row " ..row .." Col " ..col)
		if (terrainLayoutResult[row][col].terrainType ~= r) then
			terrainLayoutResult[row][col].terrainType = GetRandomElement(weightedTerrainTypes)
			print("Setting terrain at Row " ..row .." Col " ..col)
		end
	end
	
end

-- continuing with terrain placement
weightedTerrainTypes = {e,h,p,p,p}

colMinRange = colMaxRange + 1
colMaxRange = math.floor(gridWidth * .91)
print("Col Min Range = " ..colMinRange .." Col Max Range = " ..colMaxRange)
for row = 1, gridHeight do
	print("------ Now at row " ..row .." ------")	
	for col = colMinRange, colMaxRange do
		if (terrainLayoutResult[row][col].terrainType ~= r) then
			terrainLayoutResult[row][col].terrainType = GetRandomElement(weightedTerrainTypes)
			print("Setting terrain at Row " ..row .." Col " ..col)
		end
	end
	
end

-- place a row of plains to form the bottom of the waterfall
weightedTerrainTypes = {p}

colMinRange = colMaxRange + 1
colMaxRange = gridWidth
print("Col Min Range = " ..colMinRange .." Col Max Range = " ..colMaxRange)
for row = 1, gridHeight do
	print("------ Now at row " ..row .." ------")	
	for col = colMinRange, colMaxRange do
		if (terrainLayoutResult[row][col].terrainType ~= r and terrainLayoutResult[row][col].terrainType ~= v) then
			terrainLayoutResult[row][col].terrainType = GetRandomElement(weightedTerrainTypes)
			print("Setting terrain at Row " ..row .." Col " ..col)
		end
	end
	
end

-- make sure cliffs face the right way by adding plains below them
cliffSquares = GetSquaresOfType(l, gridSize, terrainLayoutResult)

for index = 1, #cliffSquares do
	row = cliffSquares[index][1]
	col = cliffSquares[index][2]
	
	terrainLayoutResult[row][col + 1].terrainType = p	
end

print("--- End of terrain setting --------------------")

-- create starting areas based on the course of the river (players will be seperated by the river)
startAreaTop = {} -- table to hold start area data above the river
startAreaBottom = {} -- table to hold start area data below the river
riverRowTop = {} -- table to hold the river row above the river (the river may flow top to bottom in places so store the first river square on this side of the river)
riverRowBottom = {} -- table to hold the river row below the river (the river may flow top to bottom in places so store the first river square on this side of the river)

-- find all the squares of the designated terrain types for potential start positions using function found in getsquaresfunctions lua file in the engine library folder
startAreaTop = GetSquaresOfTypes({e,b,p,h,n}, gridSize, terrainLayoutResult)
startAreaBottom = GetSquaresOfTypes({e,b,p,h,n}, gridSize, terrainLayoutResult)

-- cycle through all squares in grid from top to bottom and record the first row that is river
for col = 1, gridWidth do
	for row = 1, gridHeight do
		
		if (terrainLayoutResult[row][col].terrainType == r) then
			table.insert(riverRowTop, col, row) -- add river row to the table using its column as the index
			break
		end
		
	end
	
end

-- cycle through all squares in grid from bottom to top and record the first row that is river
for col = 1, gridWidth do
	for row = gridHeight, 1, -1 do
		
		if (terrainLayoutResult[row][col].terrainType == r) then
			table.insert(riverRowBottom, col, row) -- add river row to the table using its column as the index
			break
		end
		
	end
	
end

-- cycle through top squares and remove squares below the river row
for col = gridWidth, 1, -1 do
	
	for row = 1, gridHeight do
		
		if (row >= riverRowTop[col]) then
			table.remove(startAreaTop, col)
		end
		
	end
	
end

-- cycle through bottom squares and remove squares above the river row
for col = gridWidth, 1, -1 do
	
	for row = 1, gridHeight do
		
		if (row <= riverRowBottom[col]) then
			table.remove(startAreaBottom, col)
		end
		
	end
	
end

-- debug output for river row squares
for ii = 1, #riverRowTop do
	print("River Square Top at row " ..riverRowTop[ii] .." col " ..ii)
end

for ii = 1, #riverRowBottom do
	print("River Square Bottom at row " ..riverRowTop[ii] .." col " ..ii)
end
	
-- variables for spacing player start areas on the map
columnSeparation = math.floor((gridWidth) / 4) -- subdivide the map width to accomodate an 8 player game (4 players per side of river)
currentColumnTop = columnSeparation
currentColumnBottom = columnSeparation
rowRange = 3 -- range in squares from the river the start area can be
startSquares = {} -- table to hold the start squares data

-- create a start area for the max of 8 players to select from for start locations
for index = 1, 8 do		
		
	if (index <= 4) then -- top starts
		print("Current Column: " ..currentColumnTop)
		rowSpace = riverRowTop[currentColumnTop] - rowRange
		roll = Round(worldGetRandom() * rowSpace, 0) + 1
		row = riverRowTop[currentColumnTop] - 2 - roll
		
		if (row <= 1) then
			row = 2
		end
		
		col = currentColumnTop
		currentColumnTop = currentColumnTop + columnSeparation
		table.insert(startSquares, index, {row, col})
	
	else  -- bottom starts
		print("Current Column: " ..currentColumnBottom)
		rowSpace = gridHeight - riverRowBottom[currentColumnBottom] + rowRange
		roll = Round(worldGetRandom() * rowSpace, 0) + 1
		row = riverRowBottom[currentColumnBottom] + 2 + roll
		
		if (row >= gridHeight) then
			row = gridHeight - 1
		end
		
		col = currentColumnBottom
		table.insert(startSquares, index, {row, col})	
		currentColumnBottom = currentColumnBottom + columnSeparation
	end
	
end

for index = 1, #startSquares do
	print("Start Square " ..index .." at row " ..startSquares[index][1] .." column " ..startSquares[index][2])
end

-- START LOCATION FORMAT
-- note that the order of squares is rearranged compared to other maps to match the desired spawning pattern (starts in this map were made left to right)
-- uses the funtction found in player_starts lua file in the library folder
startPosition01 = MakeStartArea(1, startSquares[1][1], startSquares[1][1], startSquares[1][2], startSquares[1][2], {2, 3})
startPosition02 = MakeStartArea(2, startSquares[4][1], startSquares[4][1], startSquares[4][2], startSquares[4][2], {1, 3})
startPosition03 = MakeStartArea(3, startSquares[2][1], startSquares[2][1], startSquares[2][2], startSquares[2][2], {2, 4})
startPosition04 = MakeStartArea(4, startSquares[3][1], startSquares[3][1], startSquares[3][2], startSquares[4][2], {3, 8})
startPosition05 = MakeStartArea(5, startSquares[5][1], startSquares[5][1], startSquares[5][2], startSquares[5][2], {6, 7})
startPosition06 = MakeStartArea(6, startSquares[8][1], startSquares[8][1], startSquares[8][2], startSquares[8][2], {5, 7})
startPosition07 = MakeStartArea(7, startSquares[6][1], startSquares[6][1], startSquares[6][2], startSquares[6][2], {6, 8})
startPosition08 = MakeStartArea(8, startSquares[7][1], startSquares[7][1], startSquares[7][2], startSquares[7][2], {4, 7})

-- add start areas to the master table
masterStartPositionsTable = {startPosition01, startPosition02, startPosition03, startPosition04, startPosition05, startPosition06, startPosition07, startPosition08}
openStartPositions = {}

-- copy the start positions table to an open list for start location selection
openStartPositions = DeepCopy(masterStartPositionsTable)

-- debug output for start areas
for index = 1, #openStartPositions do
	print("OSP ID " ..index .." is " ..openStartPositions[index].startID .." Number of connections is: " ..#openStartPositions[index].connections)	 
end

startLocationPositions = {} -- set up table to store all player locations

print("RANDOM POSITIONS IS " ..tostring(randomPositions))

-- find a start location for each player

if (worldPlayerCount <=4) then -- reduce start positions options to 4 to keep players far enough apart		
		table.remove(openStartPositions, 8)
		table.remove(openStartPositions, 7)	
		table.remove(openStartPositions, 4)
		table.remove(openStartPositions, 3)
end

-- debug output for remaining start areas
for index = 1, #openStartPositions do
	print("Final Open List Start Position " ..openStartPositions[index].startID .." is at start row " ..openStartPositions[index].startRow ..", end row " ..openStartPositions[index].endRow ..", start col " ..openStartPositions[index].startCol ..", end Col " ..openStartPositions[index].endCol)
end

if (randomPositions == true) then -- place players without regard to grouping teams together		
	
	-- select start positions
	print("Placing players apart (randomly)")
	startLocationPositions = GetStartPositionsTeamsApartDividedMap(openStartPositions)	

else -- place players from the same team grouped together

	-- select start positions
	print("Placing players together.")
	for index = 1, #playerTeams do
		print("World Player Index " ..index .." is on team " ..playerTeams[index])
	end
	startLocationPositions = GetStartPositionsTeamsTogetherDividedMap(masterStartPositionsTable) -- uses function found in player_starts lua file in hte library folder (divided maps are maps where players are intended to be seperated by a map wide feature like a river or mountain range)

end

-- place the start positions on the coarse grid
print("-------- Placing Start Positions...")
print("There are " ..#startLocationPositions .." start location positions.")
for index = 1, #startLocationPositions do
	x = startLocationPositions[index].startRow
	y = startLocationPositions[index].startCol
	print("Player " ..startLocationPositions[index].playerID .." is at row " ..x ..", col "..y)
	terrainLayoutResult[x][y].terrainType = playerStartTerrainPlain -- places the terrain type that will spawn starting resources
	terrainLayoutResult[x][y].playerIndex = startLocationPositions[index].playerID -- player ID must be set for this square to properly set the player start
	print("Setting PlayerID in terrain layout to " ..startLocationPositions[index].playerID)
	
	if ((x-1) > 0) then
		-- set terain squares around town center for top of map
		if ((y-1) > 0 and y < 5) then -- make sure we're both on the grid and not overriting existing terrain
			terrainLayoutResult[x-1][y-1].terrainType = b
		elseif((y-1) > 0) then
			terrainLayoutResult[x-1][y-1].terrainType = p
		end
		
		if ((y+1) <= gridSize and y <  5) then
			terrainLayoutResult[x-1][y+1].terrainType = b
		elseif((y+1) <= gridSize) then
			terrainLayoutResult[x-1][y+1].terrainType = p
		end
		
		if (terrainLayoutResult[x-1][y].terrainType ~= r and y < 5) then -- do not overwrite river
			terrainLayoutResult[x-1][y].terrainType = b
		elseif (terrainLayoutResult[x-1][y].terrainType ~= r) then
			terrainLayoutResult[x-1][y].terrainType = p
		end
		
	end
	
	if ((x+1) <= gridSize) then
		-- set terain squares around town center for bottom of map
		if ((y-1) > 0 and y < 5) then
			terrainLayoutResult[x+1][y-1].terrainType = b
		elseif((y-1) > 0) then
			terrainLayoutResult[x+1][y-1].terrainType = p
		end
		
		if ((y+1) <= gridSize and y < 5) then
			terrainLayoutResult[x+1][y+1].terrainType = b
		elseif ((y+1) <= gridSize) then
			terrainLayoutResult[x+1][y+1].terrainType = p
		end
		
		if (terrainLayoutResult[x+1][y].terrainType ~= r and y < 5) then -- do not overwrite river
			terrainLayoutResult[x+1][y].terrainType = b
		elseif(terrainLayoutResult[x+1][y].terrainType ~= r) then
			terrainLayoutResult[x+1][y].terrainType = p
		end
		
	end
	
	if ((y-1) > 0 and y < 5) then  -- make sure we're both on the grid and not overriting existing terrain
		terrainLayoutResult[x][y-1].terrainType = b
	elseif ((y-1) > 0) then
		terrainLayoutResult[x][y-1].terrainType = p
	end
	
	if ((y+1) <= gridSize and y < 5) then -- make sure we're both on the grid and not overriting existing terrain
		terrainLayoutResult[x][y+1].terrainType = b
	elseif ((y+1) <= gridSize) then
		terrainLayoutResult[x][y+1].terrainType = p
	end
	
end	

-- check if start condition is nomad and if so place nomad resource pockets (classic resources get placed automatically with the classic start location)
if (nomadStart) then
	
	print("RIVER MAP IS PLACING NOMAD RESOURCES...")
	playerResourcePocketSets = {}
	
	-- assign a resource pocket set to each player (may refine this later to be more deterministic)
	for index = 1, (#startLocationPositions) do
		table.insert(playerResourcePocketSets, index, GetRandomElement(nomadPocketResourceList))	
	end
	
	PlaceNomadResourcePockets(startLocationPositions, 3, 2, 1, {n,p,h}, terrainLayoutResult, 2, playerResourcePocketSets, gridSize)	-- uses function from player
	
end

--- FINISH RIVER
-- replace river terrain type with terrain types that trend downward
for col = 1, gridWidth do

	for row = 1, gridHeight do
	
		if(terrainLayoutResult[row][col].terrainType == r) then
			
			if(col == 1) then
				--terrainLayoutResult[row][col].terrainType = b
				terrainLayoutResult[row][col].terrainType = p
			elseif(col < gridWidth / 3) then
				--terrainLayoutResult[row][col].terrainType = h
				terrainLayoutResult[row][col].terrainType = p
			elseif(col >= gridWidth / 3 and col < gridWidth - gridWidth / 3) then
				terrainLayoutResult[row][col].terrainType = p
			else
				terrainLayoutResult[row][col].terrainType = p
			end
			
			-- place buffer terrain around river to ensure no mountain blockers
			bufferSquares = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {i, m, b, h, p, l}, terrainLayoutResult)
		
			for sIndex = 1, #bufferSquares do
				x = bufferSquares[sIndex][1]			
				y = bufferSquares[sIndex][2]
				--terrainLayoutResult[x][y].terrainType = terrainLayoutResult[row][col].terrainType
				terrainLayoutResult[x][y].terrainType = p
			end

		end
		
	end

end

-- generate river result table for river generation
riverResult = {} -- river result table must be named this to create rivers
table.insert(riverResult, 1, riverPoints)

--- TRIBUTARIES
-- place simple tributary

placeTribs = false -- initialize bool to false for placement of a tributary
if (worldGetRandom < 0.5) then -- 50% chance to generate a tributary
	placeTribs = true
end

-- place tributary somewhare along the river while avoiding player starts
if (placeTribs) then
	tribMinRow = masterStartPositionsTable[1].startRow + 2
	tribMaxRow = rowMidPoint - 1
	
	if (worldGetRandom() > 0.5) then -- 50% chance to be placed relative to the start area above or below the fiver
		tribMinRow = masterStartPositionsTable[5].startRow - 1
		tribMaxRow = rowMidPoint - 1
	end
	
	tribRowRange = tribMaxRow - tribMinRow
	tribStartRow = Round(worldGetRandom() * tribRowRange, 0) + tribMinRow
	
	riverStartRow = riverResult[1][1][1]
	
	print("Unadjusted trib start row " ..tribStartRow)
	if (tribStartRow == riverStartRow) then
		
		if (worldGetRandom() < 0.5) then -- 50% chance to be above or below the river
			tribStartRow = riverStartRow - 2
		else
			tribStartRow = riverStartRow + 2
		end
	
	-- make sure tributary isn't joining to close to the start row
	elseif (tribStartRow == riverStartRow + 1) then
		tribStartRow = tribStartRow + 1
	elseif (tribStartRow == riverStartRow - 1) then
		tribStartRow = tribStartRow - 1
	end
	
	print("Adjusted trib start row " ..tribStartRow)
	
	tribRiverJoinSquare = {} -- table to hold where the tributary joins with the main river
	
	tribPoints = {} -- table to hold hte tributary points
	for index = 1, turnColumns[2] - 1 do
		table.insert(tribPoints, {tribStartRow, index})
	end
	
	joinSquareRange = 4 -- range along the river where the tributary can join
	joinSquareIndex = Round(worldGetRandom() * joinSquareRange, 0) + turnColumns[2] -- get a random square somewhere after the second river turn square
	joinSquare = riverResult[1][joinSquareIndex]
	
	-- get a line of squares that connect the end of the initial tributary path to an existing river square
	--tribEndSquares = DrawLineOfTerrainNoNeighbors(tribPoints[#tribPoints][1], tribPoints[#tribPoints][2], joinSquare[1], joinSquare[2], false, r, gridSize, terrainLayoutResult)
	tribEndSquares = DrawLineOfTerrainNoDiagonal(tribPoints[#tribPoints][1], tribPoints[#tribPoints][2], joinSquare[1], joinSquare[2], false, r, gridSize, terrainLayoutResult)
	table.remove(tribEndSquares, 1) -- remove the first square in the list as it's a duplicate of the last square in the tribPoints list
	
	-- join the two tributary points lists together
	startIndex = #tribPoints
	endIndex = startIndex + #tribEndSquares
	for index = startIndex, endIndex do
		table.insert(tribPoints, index + 1, tribEndSquares[index - startIndex + 1])
	end
	
	-- iterate through the list to see if the tributary intersects the main river before it hits the target river square
	tribIntersectIndex = -1
	for index = 1, (#tribPoints - 1) do
		row = tribPoints[index][1]
		col = tribPoints[index][2]
		
		for rIndex = 1, #riverResult[1] do
			
			if(row == riverResult[1][rIndex][1] and col == riverResult[1][rIndex][2]) then
				tribIntersectIndex = index
				print("Tributary actually reaches river at " ..row ..", " ..col .." index " ..tribIntersectIndex)
				break
			end
			
		end
		
		if(tribIntersectIndex > 0) then	
			break
		end
	
	end
	
	-- remove extra tributary squares if hte tributary intersected the river early
	if(tribIntersectIndex > 0) then	
		indexCutOff = tribIntersectIndex + 1
		
		for index = #tribPoints, indexCutOff, -1 do
			print("Removing trib square at index "  ..index)
			table.remove(tribPoints, index)
		end
		
	end
	
	-- debug list of tributary points
	for index = 1, #tribPoints do
		print("Tributary square " .. index .." at row " ..tribPoints[index][1] ..", col " ..tribPoints[index][2])
	end
	
	-- set terrain to avoid tributary flowing uphill
	tribTerrainTypes = {j, d, b, p}
	tribTTIndex = 1
	for index = 1, #tribPoints do
		row = tribPoints[index][1]
		col = tribPoints[index][2]
		terrainLayoutResult[row][col].terrainType = tribTerrainTypes[tribTTIndex]
		
		if index > 4 then tribTTIndex = tribTTIndex + 1 end
		
		if tribTTIndex > #tribTerrainTypes then tribTTIndex = #tribTerrainTypes end
	end
	
	-- add tributary squares to river result table
	index = #riverResult + 1
	table.insert(riverResult, index, DeepCopy(tribPoints))

end
--- END TRIBUTARIES -------------------------------


-- debug output of river results
for index = 1, #riverResult do

	for pIndex = 1, #riverResult[index] do
		x = riverResult[index][pIndex][1]
		y = riverResult[index][pIndex][2]
		print("** River " ..index .." Point " ..pIndex .." Row " ..x ..", Column " ..y)
	end

end

-- PLACE FORDS
maxFords = {4, 2} -- one value for each river
minFords = {2, 1} -- one value for each river

-- variables for how far up or down the river the fords can go
fordUpstreamSquareMargin = 4
fordDownstreamSquareMargin = 1
-- tables for holding the ford data (formatted the same as the riverresult table)
fordResults = {} -- must be named this to place fords
fordIndeces = {} -- table to hold the river table index for the ford location

woodBridgeResults = {} -- table to hold bridge results

-- add indeces for the river only if they conform to the constraints of margins
for rIndex = 1, #riverResult do -- loop through each river
	print("Adding indeces for river " ..rIndex)
	table.insert(fordIndeces, rIndex, {}) -- add a table to hold all the ford indeces for each river
	print("There are " ..#riverResult[rIndex] .." river squares in river " ..rIndex) 
	for sIndex = 1, #riverResult[rIndex] do -- loop through each square in the river and add it's index if it is in the correct range		
		if (sIndex > fordUpstreamSquareMargin and sIndex < #riverResult[rIndex] - fordDownstreamSquareMargin) then
			print("Adding index " ..sIndex .." to fordIndeces table.")
			table.insert(fordIndeces[rIndex], sIndex)
		else
			print("Discarding index " ..sIndex .." as it is outside the defined range.")
		end
		
	end
	
end

-- debug text for ford indeces
for rIndex = 1, #fordIndeces do
	print("There are " ..#fordIndeces[rIndex] .." indeces.")
	for sIndex = 1, #fordIndeces[rIndex] do
		print("River " ..rIndex .." square index " ..fordIndeces[rIndex][sIndex])
	end
	
end

-- add fords to a temporary table that will be copied onto fordResults
for rIndex = 1, #riverResult do --loop through each river
	fordIndexTable = {}
	numberOfFords = Round(worldGetRandom() * (maxFords[rIndex] - minFords[rIndex]), 0) + minFords[rIndex]
	print("Number of fords for river " ..rIndex ..": " ..numberOfFords)
	fordsRemaining = numberOfFords
	
	while (fordsRemaining > 0 and #fordIndeces[rIndex] > 0) do
		roll = Round(worldGetRandom() * (#fordIndeces[rIndex] - 1), 0) + 1
		print("River ford index roll: " ..roll)
		print("River result index is " ..fordIndeces[rIndex][roll])		
		table.insert(fordIndexTable, fordIndeces[rIndex][roll])
		table.remove(fordIndeces[rIndex], roll)
		fordsRemaining = fordsRemaining - 1
	end
	
	print("Number of indeces for river " ..rIndex .." is " ..#fordIndexTable)
	
	-- create a table for each set of fords per river
	fordTable = {}		
	for fIndex = 1, #fordIndexTable do
		table.insert(fordTable, riverResult[rIndex][fordIndexTable[fIndex]])		
	end
	
	-- insert temp table into fordResults
	table.insert(fordResults, rIndex, DeepCopy(fordTable))

end

-- add ford at start of main river
roll = math.floor(worldGetRandom() * 2) + 1 -- for a range of 1-2
print("Cliffside river ford index is " ..roll + 1)
x = riverResult[1][roll + 1][1]
y = riverResult[1][roll + 1][2]
table.insert(fordResults[1], {x, y})

numBridges = 1 -- number of bridges must not exceed or equal number of fords. There must always be at least one ford
if (numBridges >= #fordResults[1]) then
	numBridges = #fordResults[1] - 1
end

--replace fords with bridges up to the number of bridges
for index = 1, numBridges do	
	fordIndex = GetRandomIndex(fordResults[1])
	-- get the coordinates for the bridge and remove the bridge from the bridge table
	bridgeCoord = {fordResults[1][fordIndex][1], fordResults[1][fordIndex][2]}
	table.remove(fordResults[1], fordIndex)
	print("bridge chosen to be placed at index " ..fordIndex)
	print("bridge coordinates: " .. bridgeCoord[1] .. ", " .. bridgeCoord[2])
									
	table.insert(woodBridgeResults, { bridgeCoord })	
end					

-- debug info on ford placement
for rIndex = 1, #fordResults do
	print("River " ..rIndex .." has " ..#fordResults[rIndex] .." fords.")
	for sIndex = 1, #fordResults[rIndex] do
		print("River " ..rIndex .." ford " ..sIndex .." at row " ..fordResults[rIndex][sIndex][1] .." column " ..fordResults[rIndex][sIndex][2])
	end

end

-- set terrain around river course to match river heights to avoid strange rivers
for rIndex = 1, #fordResults do
	
	for sIndex = 1, #fordResults[rIndex] do
		row = fordResults[rIndex][sIndex][1]
		col = fordResults[rIndex][sIndex][2]
		
		tempTerrain = terrainLayoutResult[row][col].terrainType
		fordSquares = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {m,b,i,p,h}, terrainLayoutResult)
		
		for index = 1, #fordSquares do	
			fsRow = fordSquares[index][1]
			fsCol = fordSquares[index][2]
			terrainLayoutResult[fsRow][fsCol].terrainType = tempTerrain
		end
		
	end
	
end

--- PLACE WATERFALLS
-- places one ewaterfall, but is set up to accomodate multiple rivers
-- while this is set up to add waterfalls to each river, it is not robust enough for tributaries and operates on the assumption all rivers in the map run left to right
waterfallMaxCol = fordUpstreamSquareMargin - 1 -- ensure waterfalls don't get placed in low lying regions or where fords appear (make sure this matches fordUpstreamSquareMargin)
waterfallMinCol = 1 -- ensure waterfalls don't get placed too close to edge of map (column must be greater tahn this value
maxWaterfalls = 1 -- must be less than or equal to waterfallMaxCol, one value for each river
minWaterfalls = 1 -- one value for each river
waterFall_TT = {g, l} -- order the waterfall terrain from highest to lowest and make sure there is at least one entry for up to the max number of waterfalls
waterfallNeighbor_TT = {{j,d}, {d,b}} -- as above, make sure there's enough terrain type entries for the max number of waterfalls and theat thet are ordered highest to lowest (will choose randomly from the sub table)

-- determine number of waterfalls
numWaterfalls = Round(worldGetRandom() * (maxWaterfalls - minWaterfalls), 0) + minWaterfalls
print("Attempting to place " ..numWaterfalls .." waterfalls...")
waterfallCols = {}

for index = 1, waterfallMaxCol do
	table.insert(waterfallCols, index, index)
end

potentialFallSquares = {}
-- determine which river squares are waterfalls (if any) and add to table of waterfall squares for each river
for rIndex = 1, #riverResult do
	-- determine number of waterfalls
	numWaterfalls = Round(worldGetRandom() * (maxWaterfalls - minWaterfalls), 0) + minWaterfalls
	
	if rIndex > 1 then numWaterfalls = 0 end -- do not place waterfalls on tributaries
	print("Attempting to place " ..numWaterfalls .." waterfalls...")
	waterfallCols = {}
	
	waterfallSquares = {}
	riverSubTable = riverResult[rIndex]
	
	for sIndex = 1, #riverSubTable do
		x = riverSubTable[sIndex][1]
		y = riverSubTable[sIndex][2]
		
		if (y <= waterfallMaxCol and y > waterfallMinCol) then
			table.insert(potentialFallSquares, {row = x, col = y})
		end
		
	end
	
	-- pick a potential fall square for each waterfall
	for fIndex = 1, numWaterfalls do
		squareIndex = GetRandomIndex(potentialFallSquares)
		x = potentialFallSquares[squareIndex].row
		y = potentialFallSquares[squareIndex].col
		table.remove(potentialFallSquares, squareIndex)
		table.insert(waterfallSquares, {row = x, col = y})		
	end
	
	-- sort squares from lowest to highest column
	if (#waterfallSquares > 0) then
		table.sort(waterfallSquares, function(a, b) return a.col < b.col end)
	end

	
	-- sort squares from lowest to highest column
	if (#waterfallSquares > 0) then
		table.sort(waterfallSquares, function(a, b) return a.col < b.col end)
	end
	
	-- cycle through all waterfall squares and set terrain from edge of map to waterfall and from waterfall to waterfall to make proper height shelves
	for wIndex = 1, #waterfallSquares do
		if (wIndex == 1) then			
			for sIndex = 1, waterfallSquares[wIndex].col do
				x = riverSubTable[sIndex][1]
				y = riverSubTable[sIndex][2]
				if (y == waterfallSquares[wIndex].col) then
					terrainLayoutResult[x][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x - 1][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x + 1][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x - 2][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x + 2][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x - 3][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x + 3][y].terrainType = waterFall_TT[wIndex]
				else
					terrainLayoutResult[x][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x - 1][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x + 1][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x - 2][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x + 2][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x - 3][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x + 3][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])				
				end
			end			
		else		
			for sIndex = waterfallSquares[wIndex - 1].col, waterfallSquares[wIndex].col do
				x = riverSubTable[sIndex][1]
				y = riverSubTable[sIndex][2]
				if (y == waterfallSquares[wIndex].col) then
					terrainLayoutResult[x][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x - 1][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x + 1][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x - 2][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x + 2][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x - 3][y].terrainType = waterFall_TT[wIndex]
					terrainLayoutResult[x + 3][y].terrainType = waterFall_TT[wIndex]
				else
					terrainLayoutResult[x][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x - 1][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x + 1][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x - 2][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x + 2][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x - 3][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
					terrainLayoutResult[x + 3][y].terrainType = GetRandomElement(waterfallNeighbor_TT[wIndex])
				end
			end 			
		end
	end
	-- add a line of plains at the bottom of the last waterfall
	if(numWaterfalls > 0) then
		terrainLayoutResult[x][y + 1].terrainType = p
		terrainLayoutResult[x - 1][y + 1].terrainType = p
		terrainLayoutResult[x + 1][y + 1].terrainType = p
		terrainLayoutResult[x - 2][y + 1].terrainType = p
		terrainLayoutResult[x + 2][y + 1].terrainType = p	
		terrainLayoutResult[x - 3][y + 1].terrainType = p
		terrainLayoutResult[x + 3][y + 1].terrainType = p
	end
end

-- remove river table if it has insufficient number of squares
for index = #riverResult, 1, -1 do
	tempTable = riverResult[index]
	print("Number of river points " ..#tempTable)
	if (#tempTable < 2) then
		print("Removing river at index " ..index)
		table.remove(riverResult, index)
	end
end

-- ensure no impasse in the way of river
for index = 1, #riverResult do

	for pIndex = 1, #riverResult[index] do
		x = riverResult[index][pIndex][1]
		y = riverResult[index][pIndex][2]
		
		if (terrainLayoutResult[x][y].terrainType == m) then
			--terrainLayoutResult[x][y].terrainType = g
		elseif (terrainLayoutResult[x][y].terrainType == i) then
			--terrainLayoutResult[x][y].terrainType = l
		end
	end

end

-- print river results
for index = 1, #riverResult do

	for pIndex = 1, #riverResult[index] do
		x = riverResult[index][pIndex][1]
		y = riverResult[index][pIndex][2]
		print("**Debug River " ..index .." Point " ..pIndex .." Row " ..x ..", Column " ..y)
	end

end

print("END OF RIVER LUA SCRIPT.")


