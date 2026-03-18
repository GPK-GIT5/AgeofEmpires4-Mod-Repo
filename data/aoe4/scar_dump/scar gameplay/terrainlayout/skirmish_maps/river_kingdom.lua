-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING RIVER KINGDOM")

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout
o = tt_flatland -- flatland will not be used in the map. This is just to set a square to "random"

h = tt_hills
m = tt_mountains_small
b = tt_hills_low_rolling
l = tt_plateau_low
p = tt_plains
i = tt_impasse_mountains
v = tt_valley
r = tt_river

f = tt_trees_plains
c = tt_trees_plains_clearing
bf = tt_trees_hills_high_rolling_clearing

-- check nomad start status and set start location terrain types appropriately
nomadStart = false
if (winConditionOptions.section_starting_conditions and winConditionOptions.section_starting_conditions.option_age_start) then
	nomadStart = (winConditionOptions.section_starting_conditions.option_age_start.enum_value == winConditionOptions.section_starting_conditions.option_age_start.enum_items.nomad_start)
	print("NOMAD START CONDITION IS: " ..winConditionOptions.section_starting_conditions.option_age_start.enum_value.." ("..tostring(nomadStart)..")")
else
	print("NOMAD START CONDITION IS NOT SET (FALSE)")
end

-- set appropriate start location terrain type based on nomad start status
if(nomadStart) then
	playerStartTerrain = tt_player_start_nomad_plains -- nomad mode start
else
	playerStartTerrain = tt_player_start_classic_plains -- classic mode start	
end

--set up resource pockets
nomadPocketResources1 = {}
nomadPocketResources2 = {}
nomadPocketResources3 = {}

--create groups of nomad pocket resources for use in momad mode
--players will randomly get one set of these
nomadPocketResourceList = {}
table.insert(nomadPocketResourceList, nomadPocketResources1)
table.insert(nomadPocketResourceList, nomadPocketResources2)
table.insert(nomadPocketResourceList, nomadPocketResources3)

psa = tt_pocket_stone_a
psb = tt_pocket_stone_b
psc = tt_pocket_stone_c
pga = tt_pocket_gold_a
pgb = tt_pocket_gold_b
pgc = tt_pocket_gold_c
pwa = tt_pocket_wood_a
pwb = tt_pocket_wood_b
pwc = tt_pocket_wood_c

table.insert(nomadPocketResources1, psa)
table.insert(nomadPocketResources1, pgb)
table.insert(nomadPocketResources1, pwc)
table.insert(nomadPocketResources2, psb)
table.insert(nomadPocketResources2, pgc)
table.insert(nomadPocketResources2, pwa)
table.insert(nomadPocketResources3, psc)
table.insert(nomadPocketResources3, pga)
table.insert(nomadPocketResources3, pwb)

-- FUNCTIONS ---------------------------

--- GENERATE TRIBUTARY
-- generates a tributary that connects with the closest river
function GenerateTributary(startRow, startCol, connectionSquares)
	
	endRow, endCol = GetClosestSquare(startRow, startCol, connectionSquares)
	print("*** Generating Tributary at start row " ..startRow ..", start col " ..startCol .." end row " ..endRow ..", end col " ..endCol)
	local tempTribPoints = DrawLineOfTerrainNoDiagonal(startRow, startCol, endRow, endCol, false, r, gridSize, terrainLayoutResult)
	
	local indexCutoff = 10000
	local shouldBreak = false -- bool to set that breaks us out of the loop when the desired index is found
	
	-- draw line function may intersect the target river sooner than the designated end point. Find that river index so we can remove extra river squares
	-- folow the river square by square and check for intersection
	for index = 1, (#tempTribPoints - 1) do
		row = tempTribPoints[index][1]
		col = tempTribPoints[index][2]
		print("Checking river index " ..index)
		for rIndex = 1, #connectionSquares do
			rRow = connectionSquares[rIndex][1]
			rCol = connectionSquares[rIndex][2]
			if (row == rRow and col == rCol) then			
				indexCutoff = index
				print("Tributary joins a river square at row " ..row ..", col " ..col ..", index " ..indexCutoff)
				shouldBreak = true
				break
			end
		end
		
		if (shouldBreak == true) then break end
		
	end
	
	-- remove extra unneccessary river squares
	for index = #tempTribPoints, 1, -1 do	
		if (index > indexCutoff) then table.remove(tempTribPoints, index) end
	end
	
	return (tempTribPoints)
	
end

--- DRAW RIVER TERRAIN
-- set all river squares ot the river terrain type
function DrawRiverTerrain(riverPoints)
	
	for index = #riverPoints, 1, -1 do
		row = riverPoints[index][1]
		col = riverPoints[index][2]
		terrainLayoutResult[row][col].terrainType = r		
	end
	
end

--- DEBUG PRINT RIVER SQUARES
-- print each square location to the terrain-lua-log file
function DebugPrintRiverSquares(riverPoints)	
	print("Debug Print RiverSquares ---------------")
	
	for index = 1, #riverPoints do
		row = riverPoints[index][1]
		col = riverPoints[index][2]
		print("River Square " ..index .." at row " ..row ..", col " ..col)
	end
	
end

-- GENERATE RIVER ISLAND
-- creates an island in the designated river where player starts will be placed.
-- riverIndex is the index of the river in the riverResults table (the chosen river)
-- riverSquareIndex is the index of the chosen river where the player start was designated (the chosen square along the river)
function GenerateRiverIsland(riverIndex, riverSquareIndex, playerID, newPlayerStartTerrain)
	local indexBuffer = 4 -- how many squares along the river on either side of the start position from which to form the island

	-- place river points of selected river in temp table
	tempRiverTable = riverResult[riverIndex]
	
	startLocationRow = tempRiverTable[riverSquareIndex][1]
	startLocationCol = tempRiverTable[riverSquareIndex][2]
	
	-- get the river squares where the tributary forming the island will begin and end
	branchStartIndex = riverSquareIndex - indexBuffer
	branchEndIndex = riverSquareIndex + indexBuffer - 1
	
	-- make sure the index doesn't go out of range
	if (branchStartIndex < 1) then branchStartIndex = 1 end
	if (branchEndIndex > #tempRiverTable) then branchEndIndex = #tempRiverTable end
	
	local startRow = tempRiverTable[branchStartIndex][1]
	local startCol = tempRiverTable[branchStartIndex][2]
	
	local endRow = tempRiverTable[branchEndIndex][1]
	local endCol = tempRiverTable[branchEndIndex][2]
	
	print("Player start at row " ..startLocationRow ..", col " ..startLocationCol .." Island start at row " ..startRow ..", col " ..startCol .." Island end at row " ..endRow ..", col " ..endCol)
			
	-- check to see if player-river overlap resolved. Move player if not.
	if (startRow == startLocationRow or startCol == startLocationCol or endRow == startLocationRow or endCol == startLocationCol) then
		newPlayerStartRow = math.floor((startRow + endRow) / 2)
		newPlayerStartCol = math.floor((startCol + endCol) / 2)
		terrainLayoutResult[startLocationRow][startLocationCol].playerIndex = nil
		terrainLayoutResult[startLocationRow][startLocationCol].terrainType = p
		terrainLayoutResult[newPlayerStartRow][newPlayerStartCol].playerIndex = playerID
		terrainLayoutResult[newPlayerStartRow][newPlayerStartCol].terrainType = newPlayerStartTerrain
	end
	
	-- generate squares for main river diversion
	local diversionMidRow = endRow
	local diversionMidCol = startCol
	
	print("*-* Diversion Mid Row: " ..diversionMidRow .." Diverson Mid Col: " ..diversionMidCol)
	
	-- create the path of the river diversion that will form one side of hte island
	local diversionSquares01 = DrawLineOfTerrainNoDiagonal(startRow, startCol, diversionMidRow, diversionMidCol, false, r, gridSize, terrainLayoutResult)
	local diversionSquares02 = DrawLineOfTerrainNoDiagonal(diversionMidRow, diversionMidCol, endRow, endCol, false, r, gridSize, terrainLayoutResult)
	
	diversionSquares = DeepCopy(diversionSquares01)
	
	for index = 2, #diversionSquares02 do
		table.insert(diversionSquares, (#diversionSquares + 1), diversionSquares02[index])
	end
	
	table.remove(diversionSquares, #diversionSquares)
	table.remove(diversionSquares, 1)
	
	for index = #tempRiverTable, 1, -1 do
		if (index < branchEndIndex and index > branchStartIndex) then
			table.remove(tempRiverTable, index)
		end
	end
	
	-- add in the diversion squares
	for index = 1, #diversionSquares do
		insertIndex = branchStartIndex + index
		table.insert(tempRiverTable, insertIndex, diversionSquares[index])
	end
	
	-- generate squares for tributary
	local shortTribMidRow = startRow
	local shortTribMidCol = endCol
	
	print("*-* Short Trib Mid Row: " ..shortTribMidRow .." Short Trib Mid Col: " ..shortTribMidCol)
	
	-- draw the tirbutary lines
	local shortTribSquares01 = DrawLineOfTerrainNoDiagonal(startRow, startCol, shortTribMidRow, shortTribMidCol, false, r, gridSize, terrainLayoutResult)
	local shortTribSquares02 = DrawLineOfTerrainNoDiagonal(shortTribMidRow, shortTribMidCol, endRow, endCol, false, r, gridSize, terrainLayoutResult)
	
	-- copy the first tributary table so it can be joined to the second to create one tributary
	shortTribSquares = DeepCopy(shortTribSquares01)
	
	-- join the tables
	for index = 2, #shortTribSquares02 do
		table.insert(shortTribSquares, (#shortTribSquares + 1), shortTribSquares02[index])
	end
	
	-- update the main river tables
	table.insert(riverResult, (#riverResult + 1), shortTribSquares)
	table.insert(finalRiverIndexes, (#finalRiverIndexes + 1), #riverResult)
	
end

--- REMOVE DUPLICATE RIVER SQUARES
-- checks to see if any river squares have been duplicated and removes them
function RemoveDuplicateRiverSquares(riverTable)
	
	duplicateIndeces = {}
	
	-- cycle through each river square
	for index = 1, #riverTable do		
		x1 = riverTable[index][1]
		y1 = riverTable[index][2]
		
		-- cycle through again and compare squares that share row and column, but not index number
		for rIndex = index, #riverTable do
			x2 = riverTable[rIndex][1]
			y2 = riverTable[rIndex][2]
			
			-- store duplicate indexes for later removal
			if (x1 == x2 and y1 == y2 and index ~= rIndex) then
				table.insert(duplicateIndeces, #duplicateIndeces + 1, index)
			end
			
		end
		
	end
	
	-- sort the duplicate indeces
	table.sort(duplicateIndeces, function(a, b) return a > b end)

	 -- remove duplicate indeces
	for index = 1, #duplicateIndeces do
		print("Remove square at index " ..duplicateIndeces[index])
		table.remove(riverTable, duplicateIndeces[index])
	end
	
end

--- TRIM RIVER
-- after moving rivers to form islands, removes extra, unneccessary river squares
function TrimRiver(riverIndex)
	
	riverToTrim = riverResult[riverIndex]
	local trimIndex = -1 -- initialize the trim index
	
	-- check squares for duplicate data to determine where the river joins and set the trim index accordingly
	for index = (riverIndex - 1), 1, -1 do
		joiningRiver = riverResult[index]
		
		for tIndex = 2, #riverToTrim do
			x1 = riverToTrim[tIndex][1]
			y1 = riverToTrim[tIndex][2]
			
			for jIndex = 1, #joiningRiver do
				x2 = joiningRiver[jIndex][1]
				y2 = joiningRiver[jIndex][2]
				
				if (x1== x2 and y1 == y2 and tIndex < #riverToTrim) then trimIndex = tIndex + 1 break end

			end
			
			if (trimIndex > 0) then break end
			
		end
		
		if (trimIndex > 0) then break end
		
	end
	
	if (trimIndex > 0) then
		
		for index = #riverToTrim, trimIndex, -1 do
			print("Trimming river " ..riverIndex .." at index " ..index)
			table.remove(riverToTrim, index) 
		end
		
	else 
		print("River " ..riverIndex .." does not need trimming")
	end
	
end


-- COARSE GRID SET UP
terrainLayoutResult = {}    -- set up initial table for coarse map grid

gridHeight, gridWidth, gridSize = SetCoarseGrid() -- default grid set up. Found in map_setup lua file in library folder.

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

baseGridSize = 13 -- use this as base for scaling for map size
gridCenterRow = math.ceil(gridHeight / 2)
gridCenterCol = math.ceil(gridWidth / 2)
gridEdgeRadius = math.floor(gridSize / 2)
print("GRID CENTER  ROW IS " ..gridCenterRow .." GRID CENTER COLUMN IS " ..gridCenterCol .." GRID EDGE RADIUS IS " ..gridEdgeRadius)

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

-- DRAW RIVERS (Part One) -----
-- CREATE MAIN RIVER. There is always at least one river in the map
baseOffset = 1 -- this offset is used to create a range of grid squares  to make random start and end points for rivers.
edgeOffset = Round(baseOffset / baseGridSize * gridSize, 0)

if (worldGetRandom() < 0.5) then
	-- start river along first column
	riverStartRow = 1 + math.floor(worldGetRandom() * edgeOffset)
	riverStartCol = 1
else
	-- start river along first row
	riverStartRow = 1
	riverStartCol = 1 + math.floor(worldGetRandom() * edgeOffset)
end

if (worldGetRandom() < 0.5) then
	-- start river along first column
	riverEndRow = gridHeight - math.floor(worldGetRandom() * edgeOffset)
	riverEndCol = gridWidth
else
	-- start river along first row
	riverEndRow = gridHeight
	riverEndCol = gridWidth - math.floor(worldGetRandom() * edgeOffset)
end

-- hold points in temp table
print("River starts at row " ..riverStartRow ..", col " ..riverStartCol)
tempRiverPoints = DrawLineOfTerrainNoDiagonal(riverStartRow, riverStartCol, riverEndRow, riverEndCol, false, r, gridSize, terrainLayoutResult)

-- find the index for where we can begin looking to start placing islands
for index = 1, #tempRiverPoints do
	x = tempRiverPoints[index][1]
	y = tempRiverPoints[index][2]
	print("TempRiver point row: " ..x .." col: " ..y)
	
	if (x == gridHeight or y == gridWidth) then
		print("Cutting off index...")
		indexCutOff = index
		break
	end
	
end

print("Index Cut Off: " ..indexCutOff .." Table Entries: " ..#tempRiverPoints)

-- remove river points above the index. Log the squares removed for debug purposes.
for index = #tempRiverPoints, 1, -1 do
	
	if (index > indexCutOff) then
		table.remove(tempRiverPoints, index)
	end
	
end

-- create final river table (must be riverResult) and add main river
riverResult = {}
table.insert(riverResult, 1, tempRiverPoints)

-- create the first 2 start areas. Start areas are created based on hte river positions rather than pregenerated as in other maps.
riverEdgeIndexBuffer = 6 -- determines how far down the river the start position is placed.

if (worldPlayerCount > 2 and worldTerrainHeight < 514) then riverEdgeIndexBuffer = 5 end
	
riverEdgeIndexRange = 2 -- determines the max range beyond the buffer the player start will be placed

rangeRoll = math.floor(worldGetRandom() * riverEdgeIndexRange)
start01RiverSquareIndex = 1 + riverEdgeIndexBuffer + rangeRoll
start02RiverSquareIndex = #tempRiverPoints - riverEdgeIndexBuffer - rangeRoll

x1 = tempRiverPoints[start01RiverSquareIndex][1]
y1 = tempRiverPoints[start01RiverSquareIndex][2]

x2 = tempRiverPoints[start02RiverSquareIndex][1]
y2 = tempRiverPoints[start02RiverSquareIndex][2]

print("Start01 at row " ..x1 ..", col " ..y1 .." Start02 at row " ..x2 ..", col " ..y2)

-- make the start positions using the function in player_starts lua in the library folder
startPosition01 = MakeStartArea(1, x1, x1, y1, y1, {5, 7}) --top left
startPosition02 = MakeStartArea(2, x2, x2, y2, y2, {6, 8}) -- bottom right
-- record the river index for creating tributaries
start01RiverIndex = 1
start02RiverIndex = 1

-- create tributaries for all other potential players. Only rivers with players on them will get drawn in final map.
-- TRIBUTARY 01 (bottom left) ----
if (worldGetRandom() < 0.5) then
	-- start river along first column
	trib01StartRow = gridHeight - math.floor(worldGetRandom() * edgeOffset)
	trib01StartCol = 1
else
	-- start river along bottom row
	trib01StartRow = gridHeight
	trib01StartCol = 1 + math.floor(worldGetRandom() * edgeOffset)
end

-- create a list of all river points for later reference
conglomeratedRiverPoints = DeepCopy(tempRiverPoints)

tempTrib01Points = GenerateTributary(trib01StartRow, trib01StartCol, conglomeratedRiverPoints)
--DrawRiverTerrain(tempTrib01Points)
DebugPrintRiverSquares(tempTrib01Points)
table.insert(riverResult, 2, tempTrib01Points)

-- generate start position along tributary
rangeRoll = math.floor(worldGetRandom() * riverEdgeIndexRange)
start03RiverSquareIndex = 1 + riverEdgeIndexBuffer + rangeRoll

if (start03RiverSquareIndex < 1) then start03RiverSquareIndex = 1 end
if (start03RiverSquareIndex > #tempTrib01Points) then start03RiverSquareIndex = #tempTrib01Points end

x3 = tempTrib01Points[start03RiverSquareIndex][1]
y3 = tempTrib01Points[start03RiverSquareIndex][2]

print("Start03 at row " ..x3 ..", col " ..y3)

startPosition03 = MakeStartArea(3, x3, x3, y3, y3, {6, 7}) --bottom left
start03RiverIndex = 2

-- TRIBUTARY 02 (top right) ----
if (worldGetRandom() < 0.5) then
	-- start river along last column
	trib02StartRow = 1 + math.floor(worldGetRandom() * edgeOffset)
	trib02StartCol = gridWidth
else
	-- start river along first row
	trib02StartRow = 1
	trib02StartCol = gridWidth - math.floor(worldGetRandom() * edgeOffset)
end

-- add previous river points to conglomerated list
for index = 1, #tempTrib01Points do
	table.insert(conglomeratedRiverPoints, (#conglomeratedRiverPoints + 1), tempTrib01Points[index])
end
	
tempTrib02Points = GenerateTributary(trib02StartRow, trib02StartCol, conglomeratedRiverPoints)
--DrawRiverTerrain(tempTrib02Points)
table.insert(riverResult, 3, tempTrib02Points)

-- generate start position along tributary
rangeRoll = math.floor(worldGetRandom() * riverEdgeIndexRange)
start04RiverSquareIndex = 1 + riverEdgeIndexBuffer + rangeRoll

if (start04RiverSquareIndex < 1) then start04RiverSquareIndex = 1 end
if (start04RiverSquareIndex > #tempTrib02Points) then start04RiverSquareIndex = #tempTrib02Points end

x4 = tempTrib02Points[start04RiverSquareIndex][1]
y4 = tempTrib02Points[start04RiverSquareIndex][2]

print("Start04 at row " ..x4 ..", col " ..y4)

startPosition04 = MakeStartArea(4, x4, x4, y4, y4, {5, 8}) --top right
start04RiverIndex = 3

-- TRIBUTARY 03 (top middle) ----
-- start river along top row
trib03StartRow = 1 
trib03StartCol = gridCenterCol - Round(edgeOffset / 2, 0) + math.floor(worldGetRandom() * edgeOffset)

-- add previous river points to conglomerated list
for index = 1, #tempTrib02Points do
	table.insert(conglomeratedRiverPoints, (#conglomeratedRiverPoints + 1), tempTrib02Points[index])
end
	
tempTrib03Points = GenerateTributary(trib03StartRow, trib03StartCol, conglomeratedRiverPoints)
--DrawRiverTerrain(tempTrib03Points)
table.insert(riverResult, 4, tempTrib03Points)

-- generate start position along tributary
rangeRoll = math.floor(worldGetRandom() * riverEdgeIndexRange)
start05RiverSquareIndex = 1 + riverEdgeIndexBuffer + rangeRoll

if (start05RiverSquareIndex < 1) then start05RiverSquareIndex = 1 end
if (start05RiverSquareIndex > #tempTrib03Points) then start05RiverSquareIndex = #tempTrib03Points end

x5 = tempTrib03Points[start05RiverSquareIndex][1]
y5 = tempTrib03Points[start05RiverSquareIndex][2]

print("Start05 at row " ..x5 ..", col " ..y5)

startPosition05 = MakeStartArea(5, x5, x5, y5, y5, {1, 4}) --top middle
start05RiverIndex = 4

-- TRIBUTARY 04 (bottom middle) ----
-- start river along top row
trib04StartRow = gridHeight 
trib04StartCol = gridCenterCol - Round(edgeOffset / 2, 0) + math.floor(worldGetRandom() * edgeOffset)

-- add previous river points to conglomerated list
for index = 1, #tempTrib03Points do
	table.insert(conglomeratedRiverPoints, (#conglomeratedRiverPoints + 1), tempTrib03Points[index])
end
	
tempTrib04Points = GenerateTributary(trib04StartRow, trib04StartCol, conglomeratedRiverPoints)
--DrawRiverTerrain(tempTrib04Points)
table.insert(riverResult, 5, tempTrib04Points)

-- generate start position along tributary
rangeRoll = math.floor(worldGetRandom() * riverEdgeIndexRange)
start06RiverSquareIndex = 1 + riverEdgeIndexBuffer + rangeRoll

if (start06RiverSquareIndex < 1) then start06RiverSquareIndex = 1 end
if (start06RiverSquareIndex > #tempTrib04Points) then start06RiverSquareIndex = #tempTrib04Points end

x6 = tempTrib04Points[start06RiverSquareIndex][1]
y6 = tempTrib04Points[start06RiverSquareIndex][2]

print("Start06 at row " ..x6 ..", col " ..y6)

startPosition06 = MakeStartArea(6, x6, x6, y6, y6, {2, 3}) --bottom middle
start06RiverIndex = 5

-- TRIBUTARY 05 (left middle) ----
-- start river along top row
trib05StartRow = gridCenterRow - Round(edgeOffset / 2, 0) + math.floor(worldGetRandom() * edgeOffset) 
trib05StartCol = 1

-- add previous river points to conglomerated list
for index = 1, #tempTrib04Points do
	table.insert(conglomeratedRiverPoints, (#conglomeratedRiverPoints + 1), tempTrib04Points[index])
end
	
tempTrib05Points = GenerateTributary(trib05StartRow, trib05StartCol, conglomeratedRiverPoints)
table.insert(riverResult, 6, tempTrib05Points)

-- generate start position along tributary
rangeRoll = math.floor(worldGetRandom() * riverEdgeIndexRange)
start07RiverSquareIndex = 1 + riverEdgeIndexBuffer + rangeRoll

if (start07RiverSquareIndex < 1) then start07RiverSquareIndex = 1 end
if (start07RiverSquareIndex > #tempTrib05Points) then start07RiverSquareIndex = #tempTrib05Points end

x7 = tempTrib05Points[start07RiverSquareIndex][1]
y7 = tempTrib05Points[start07RiverSquareIndex][2]

print("Start07 at row " ..x7 ..", col " ..y7)

startPosition07 = MakeStartArea(7, x7, x7, y7, y7, {1, 3}) --left middle
start07RiverIndex = 6

-- TRIBUTARY 06 (right middle) ----
trib06StartRow = gridCenterRow - Round(edgeOffset / 2, 0) + math.floor(worldGetRandom() * edgeOffset) 
trib06StartCol = gridWidth

-- add previous river points to conglomerated list
for index = 1, #tempTrib05Points do
	table.insert(conglomeratedRiverPoints, (#conglomeratedRiverPoints + 1), tempTrib05Points[index])
end
	
tempTrib06Points = GenerateTributary(trib06StartRow, trib06StartCol, conglomeratedRiverPoints)
--DrawRiverTerrain(tempTrib06Points)
table.insert(riverResult, 7, tempTrib06Points)

-- generate start position along tributary
rangeRoll = math.floor(worldGetRandom() * riverEdgeIndexRange)
start08RiverSquareIndex = 1 + riverEdgeIndexBuffer + rangeRoll

if (start08RiverSquareIndex < 1) then start08RiverSquareIndex = 1 end
if (start08RiverSquareIndex > #tempTrib06Points) then start08RiverSquareIndex = #tempTrib06Points end

x8 = tempTrib06Points[start08RiverSquareIndex][1]
y8 = tempTrib06Points[start08RiverSquareIndex][2]

print("Start07 at row " ..x8 ..", col " ..y8)

startPosition08 = MakeStartArea(8, x8, x8, y8, y8, {2, 4}) --right middle
start08RiverIndex = 7

masterStartPositionsTable = {startPosition01, startPosition02, startPosition03, startPosition04, startPosition05, startPosition06, startPosition07, startPosition08}
openStartPositions = {}

for l = 1, #masterStartPositionsTable do
	print("Start Position " ..l .." is at row: " ..masterStartPositionsTable[l].startRow ..", Col: " ..masterStartPositionsTable[l].startCol)
end

-- add start areas to the open list
for index = 1, #masterStartPositionsTable do
	tempStartPosition = masterStartPositionsTable[index]
	table.insert(openStartPositions, index, tempStartPosition)
end

for index = 1, #openStartPositions do
	print("OSP ID " ..index .." is " ..openStartPositions[index].startID .." Number of connections is: " ..#openStartPositions[index].connections)	 
end

startLocationPositions = {} -- the row and column for each player location


if (worldTerrainHeight > 513) then
	startRadius = 2
else
	startRadius = 1
end

-- PLACE PLAYER START POSITIONS -----------------------------------------------------
print("RANDOM POSITIONS IS " ..tostring(randomPositions))
-- set up team list
teamList = SetUpTeams()

if (worldPlayerCount <=4) then -- reduce start positions options to 4 to keep players far enough apart
				
	for index = 8, 5, -1 do
		table.remove(openStartPositions, index)
	end
		
end
		
if (randomPositions == true) then -- place players without regard to grouping teams together		
	
	-- select start positions
	startLocationPositions = GetStartPositionsTeamsApart(openStartPositions)

else -- place players from the same team grouped together

	-- select start positions
	startLocationPositions = GetStartPositionsTeamsTogether(openStartPositions, masterStartPositionsTable)

end

if(nomadStart) then
	--place nomad resources
	print("PLACING NOMAD RESOURCES...")
	playerResourcePocketSets = {}
	
	-- assign a resource pocket set to each player
	for index = 1, #(startLocationPositions) do
		table.insert(playerResourcePocketSets, index, GetRandomElement(nomadPocketResourceList))	
	end
	
	PlaceNomadResourcePockets(startLocationPositions, 3, 2, 1, {n, p}, terrainLayoutResult, 2, playerResourcePocketSets, gridSize)	
end

-- PLACE PLAYER START TERRAIN TYPES
-- place the start positions on the coarse grid
for index = 1, #startLocationPositions do
	x = startLocationPositions[index].startRow
	y = startLocationPositions[index].startCol
	print("Player " ..index .." is at row " ..x ..", col "..y)
	terrainLayoutResult[x][y].terrainType = playerStartTerrain -- will revisit this again after rivers are drawn
	terrainLayoutResult[x][y].playerIndex = startLocationPositions[index].playerID
	print("Setting PlayerID in terrain layout to " ..startLocationPositions[index].playerID)
end

-- place buffer terrain around start locations to provide flat open building area for players
for index = 1, #startLocationPositions do
	startBufferSquares = GetAllSquaresOfTypeInRingAroundSquare(startLocationPositions[index].startRow, startLocationPositions[index].startCol, startRadius, startRadius, {n, p}, terrainLayoutResult)					
	
	for index = 1, #startBufferSquares do
		x = startBufferSquares[index][1]
		y = startBufferSquares[index][2]
		terrainLayoutResult[x][y].terrainType = p
	end

end

-- DRAW RIVERS (Part Two) -----
-- Create Islands around each placed start position
finalRiverIndexes = {}
for index = 1, #startLocationPositions do
	if (startLocationPositions[index].startID == 1) then
		print("Placing Island for start ID 1")
		-- insert river index into final river index table with all the currently used river indexes
		table.insert(finalRiverIndexes, (#finalRiverIndexes + 1), start01RiverIndex)
		GenerateRiverIsland(start01RiverIndex, start01RiverSquareIndex, startLocationPositions[index].playerID, playerStartTerrain)
	elseif (startLocationPositions[index].startID == 2) then
		print("Placing Island for start ID 2")
		table.insert(finalRiverIndexes, (#finalRiverIndexes + 1), start02RiverIndex)
		GenerateRiverIsland(start02RiverIndex, start02RiverSquareIndex, startLocationPositions[index].playerID, playerStartTerrain)
	elseif (startLocationPositions[index].startID == 3) then
		print("Placing Island for start ID 3")
		table.insert(finalRiverIndexes, (#finalRiverIndexes + 1), start03RiverIndex)
		GenerateRiverIsland(start03RiverIndex, start03RiverSquareIndex, startLocationPositions[index].playerID, playerStartTerrain)
	elseif (startLocationPositions[index].startID == 4) then
		print("Placing Island for start ID 4")
		table.insert(finalRiverIndexes, (#finalRiverIndexes + 1), start04RiverIndex)
		GenerateRiverIsland(start04RiverIndex, start04RiverSquareIndex, startLocationPositions[index].playerID, playerStartTerrain)
	elseif (startLocationPositions[index].startID == 5) then
		print("Placing Island for start ID 5")
		table.insert(finalRiverIndexes, (#finalRiverIndexes + 1), start05RiverIndex)
		GenerateRiverIsland(start05RiverIndex, start05RiverSquareIndex, startLocationPositions[index].playerID, playerStartTerrain)
	elseif (startLocationPositions[index].startID == 6) then
		print("Placing Island for start ID 6")
		table.insert(finalRiverIndexes, (#finalRiverIndexes + 1), start06RiverIndex)
		GenerateRiverIsland(start06RiverIndex, start06RiverSquareIndex, startLocationPositions[index].playerID, playerStartTerrain)
	elseif (startLocationPositions[index].startID == 7) then
		print("Placing Island for start ID 7")
		table.insert(finalRiverIndexes, (#finalRiverIndexes + 1), start07RiverIndex)
		GenerateRiverIsland(start07RiverIndex, start07RiverSquareIndex, startLocationPositions[index].playerID, playerStartTerrain)
	elseif (startLocationPositions[index].startID == 8) then
		print("Placing Island for start ID 8")
		table.insert(finalRiverIndexes, (#finalRiverIndexes + 1), start08RiverIndex)
		GenerateRiverIsland(start08RiverIndex, start08RiverSquareIndex, startLocationPositions[index].playerID, playerStartTerrain)
	else
		print("ERROR: Invalid start location ID")
	end
end

-- remove extra rivers/tributaries that are not used
for index = #riverResult, 2, -1 do	
	
	removeIndex = true
	
	for fIndex = 1, #finalRiverIndexes do
		
		if (index == finalRiverIndexes[fIndex]) then
			removeIndex = false
		end
		
	end
	
	if (removeIndex == true) then table.remove(riverResult, index) end
	
end

-- validate river end points and correct if htere is a shortfall or an overlap
for index = 1, #riverResult do
	
	tempRiverTable = riverResult[index]
	x = tempRiverTable[#tempRiverTable][1]
	y = tempRiverTable[#tempRiverTable][2]
	
	if(index > 1) then
		previousRiverTable = riverResult[index - 1]
		endsOnValidRiver = false
		for pIndex = 1, #previousRiverTable do
			x2 = previousRiverTable[pIndex][1]
			y2 = previousRiverTable[pIndex][2]
			
			if(x == x2 and y == y2) then
				endsOnValidRiver = true
				break
			end
		end
		
		if(endsOnValidRiver == false) then
			print("River " ..index .." does not end on valid river square.")
			cRow, cCol = GetClosestSquare(x, y, previousRiverTable)
			
			if (GetDistance(x, y, cRow, cCol, 0) <= 1) then
				print("Last river square within one square of valid river square")
				table.insert(tempRiverTable, #tempRiverTable + 1, {cRow, cCol})
			else
				print("Last river square furhter than one square from valid conenction. Drawing line...")
				connectionSquares = DrawLineOfTerrainNoDiagonal(x, y, cRow, cCol, false, r, gridSize, terrainLayoutResult)
			end
			
		end
	end
	
end

-- trim overlapping river points
for index = 2, #riverResult do
	TrimRiver(index)
end

-- set terrain to river on all river squares
for index = 1, #riverResult do
	
	DrawRiverTerrain(riverResult[index])

end

-- add fords
fordResults = {}
minEdgeBuffer = math.floor(2 / baseGridSize * gridSize)
maxEdgeBuffer =  math.floor(4 / baseGridSize * gridSize)

-- determine squares on rivers to place fords
for index = 1, #riverResult do	
	fordTable = {} -- create a table for the fords
	fordIndex = Round(#riverResult[index] / 2, 0)
	table.insert(fordTable, (#fordTable + 1), riverResult[index][fordIndex])
	if(index == 1) then
		bufferRoll = Round(worldGetRandom() * (maxEdgeBuffer - minEdgeBuffer), 0) + minEdgeBuffer
		table.insert(fordTable, (#fordTable + 1), riverResult[index][1 + bufferRoll])
		bufferRoll = Round(worldGetRandom() * (maxEdgeBuffer - minEdgeBuffer), 0) + minEdgeBuffer
		table.insert(fordTable, (#fordTable + 1), riverResult[index][#riverResult[index] - bufferRoll])
	else
		fordIndex = 1 + riverEdgeIndexBuffer
		
		if (fordIndex > #riverResult[index]) then fordIndex = #riverResult[index] - 1 end
		
		table.insert(fordTable, (#fordTable + 1), riverResult[index][fordIndex])
	end
	
	table.insert(fordResults, index, fordTable) -- add the ford squares to the ford table (final ford table must use this name)
end

-- print river results
for index = 1, #riverResult do

	for pIndex = 1, #riverResult[index] do
		x = riverResult[index][pIndex][1]
		y = riverResult[index][pIndex][2]
		print("**Debug River " ..index .." Point " ..pIndex .." Row " ..x ..", Column " ..y)
	end

end

print("END OF RIVER KINGDOM LUA SCRIPT.")
