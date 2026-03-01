print("GENERATING TEST MAP BALANCED ARABIA")

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

h = tt_hills
m = tt_mountains_small
b = tt_hills_low_rolling
l = tt_plateau_low
p = tt_plains

playerStartTerrain = tt_player_start_classic_plains_balance 

-- FUNCTIONS

--- RANDOM PLAINS FILL TERRAIN RING
-- changes the designated terrain types of squares in a ring (square ring) of terrain around the designated starting square, out to a designated radius, to plains
-- row, col designates center - radius designates number of squares out from center - thickness designates thickness (in squares) of ring - terrainTypes is list of terrain to choose from to convert to plains - fillChance is the chance that a square will be changed to plains
local function RandomPlainsFillTerrainRing(row, col, radius, thickness, terrainTypes, fillChance)
	-- select all the squares that match the passed in terrain types
	local ringSquares = GetAllSquaresOfTypeInRingAroundSquare(row, col, radius, thickness, terrainTypes, terrainLayoutResult)
	
	-- cycle through the selected squares and change terrain to plains if less than fill chance
	for index = 1, #ringSquares do
		if (worldGetRandom() < fillChance) then
			local x = ringSquares[index][1]
			local y = ringSquares[index][2]
			terrainLayoutResult[x][y].terrainType = p
		end
		
	end
	
end

--- RANDOM PLATEAU
-- creates an area of plateau on the map. looks for terrain that is not already set to a specific terrain type to make plateaus
-- row, col is the center of the plateau region - plateau squares are the number of squares for the plateau area - hill squares is the number of hill squares
local function RandomPlateau(row, col, plateauSquares, hillSquares)
	print("Try to place " ..plateauSquares .." plateau squares and " ..hillSquares .."hill squares.")
	local potentialPlateauSquares = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {n}, terrainLayoutResult)
	print(#potentialPlateauSquares .." total potential plateau squares")
	
	-- place set amount of plateaus 
	print("Placing Plateaus...")
	if(#potentialPlateauSquares < plateauSquares) then
		plateauSquares = #potentialPlateauSquares
	end
	for index = 1, plateauSquares do
		local plateauIndex = GetRandomIndex(potentialPlateauSquares)
		local x = potentialPlateauSquares[plateauIndex][1]
		local y = potentialPlateauSquares[plateauIndex][2]
		terrainLayoutResult[x][y].terrainType = l -- change terrain to plateau
		table.remove(potentialPlateauSquares, plateauIndex) -- remove from future consideration
	end
	
	-- place set number of hills (in same area of plataeus to create cliffs and ramps up to the cliffs)
	local potentialHillSquares = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {n}, terrainLayoutResult)
	print(#potentialHillSquares .." total potential hill squares")
	print("Placing Hills...")
	if(#potentialHillSquares < hillSquares) then
		hillSquares = #potentialHillSquares
	end
	for index = 1, hillSquares do
		if (#potentialHillSquares > 0) then
			local hillIndex = GetRandomIndex(potentialHillSquares)
			local x = potentialHillSquares[hillIndex][1]
			local y = potentialHillSquares[hillIndex][2]
			terrainLayoutResult[x][y].terrainType = b -- change terrain to hill
			table.remove(potentialHillSquares, hillIndex) -- remove from future consideration
		end
	end
	
end

-- COARSE GRID SET UP
terrainLayoutResult = {}    -- set up initial table for coarse map grid. Must be named this.

gridHeight, gridWidth, gridSize = SetCoarseGrid() -- function to set up the coarse grid. Found in map_setup lua file in library folder

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

baseGridSize = 13 -- used for reference when scaling map features

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

-- PLACE TERRAIN FEATURES
numberOfSmallMountains = gridHeight * gridWidth * 0.025
numberOfPlateaus = gridHeight * gridWidth * 0.025

-- sprinkles mountains around the map and places plains around them to avoid mountains bunching together
for index = 1, numberOfSmallMountains do
	print("Placing small mountain #" ..index)
	potentialMountainSquares = {}
	potentialMountainSquares = GetSquaresOfTypeInBox(2, 2, gridHeight - 1, gridWidth - 1, n, gridSize, terrainLayoutResult) -- gets squares that do not have terrain set yet or are on the map edge
	if(#potentialMountainSquares > 0) then
		square = {}
		square = GetRandomElement(potentialMountainSquares) -- randomly pick square from list using function from calculationfunctions lua script in engine library folder
		x = square[1]
		y = square[2]
		terrainLayoutResult[x][y].terrainType = m	
		RandomPlainsFillTerrainRing(x, y, 1, 1, {n}, 0.5)
	end
	
	potentialMountainSquares = nil -- clear out squares for next pass
end

-- sprinkles plateaus around the map and places plains around them to avoid mountains bunching together
for index = 1, numberOfPlateaus do
	print("Placing plateau # " ..index)
	potentialPlateauSquares = {}
	potentialPlateauSquares = GetSquaresOfTypeInBox(4, 4, gridHeight - 3, gridWidth - 3, n, gridSize, terrainLayoutResult) -- gets squares that do not have terrain set yet or are on the map edge
	if(#potentialPlateauSquares > 0) then
		square = {}
		square = GetRandomElement(potentialPlateauSquares)
		x = square[1]
		y = square[2]
		terrainLayoutResult[x][y].terrainType = l
		numPlateauSquares = math.ceil(worldGetRandom() * 2, 0)
		numHillSquares = math.ceil(worldGetRandom() * 2, 0) + 1
		RandomPlateau(x, y, numPlateauSquares, numHillSquares) -- randomly pick square from list using function from calculationfunctions lua script in engine library folder
		RandomPlainsFillTerrainRing(x, y, 1, 1, {n}, 0.5)
	end
	
	potentialPlateauSquares = nil  -- clear out squares for next pass
end

-- PLACE PLAYER STARTS
-- set offsets for player starts scaled by map size
heightOffset = Round(2 / baseGridSize * gridHeight, 0)
widthOffset = Round(2 / baseGridSize * gridWidth, 0)

-- START LOCATION FORMAT
-- use function from player_starts lua file found in library folder to create start areas
startPosition01 = MakeStartArea(1, 1 + heightOffset, 1 + heightOffset, 1 + widthOffset, 1 + widthOffset,{5, 7})
startPosition02 = MakeStartArea(2, gridHeight - heightOffset, gridHeight - heightOffset, gridWidth - widthOffset, gridWidth - widthOffset, {6, 8}) 
startPosition03 = MakeStartArea(3, gridHeight - heightOffset, gridHeight - heightOffset, 1 + widthOffset, 1 + widthOffset, {6, 7})
startPosition04 = MakeStartArea(4, 1 + heightOffset, 1 + heightOffset, gridWidth - widthOffset, gridWidth - widthOffset, {5, 8})
startPosition05 = MakeStartArea(5, 1 + heightOffset, 1 + heightOffset, Round(gridWidth / 2, 0), Round(gridWidth / 2, 0), {1, 4})
startPosition06 = MakeStartArea(6, gridHeight - heightOffset, gridHeight - heightOffset, Round(gridWidth / 2, 0), Round(gridWidth / 2, 0), {2, 3})
startPosition07 = MakeStartArea(7, Round(gridHeight / 2, 0), Round(gridHeight / 2, 0), 1 + widthOffset, 1 + widthOffset, {1, 3})
startPosition08 = MakeStartArea(8, Round(gridHeight / 2, 0), Round(gridHeight / 2, 0), gridWidth - widthOffset, gridWidth - widthOffset, {2, 4})

-- create the master start area table for selecting player start locations
masterStartPositionsTable = {startPosition01, startPosition02, startPosition03, startPosition04, startPosition05, startPosition06, startPosition07, startPosition08}
openStartPositions = {}

-- debug output for start areas
for l = 1, #masterStartPositionsTable do
	print("Start Position " ..l .." is at row: " ..masterStartPositionsTable[l].startRow ..", Col: " ..masterStartPositionsTable[l].startCol)
end

-- add start areas to the open list
openStartPositions = DeepCopy(masterStartPositionsTable)

for index = 1, #openStartPositions do
	print("OSP ID " ..index .." is " ..openStartPositions[index].startID .." Number of connections is: " ..#openStartPositions[index].connections)	 
end

startLocationPositions = {} -- the table holding the data for each player location

-- set the start radius for hte terrain buffer around hte start locations
if (worldTerrainHeight > 513) then
	startRadius = 2
else
	startRadius = 1
end

-- PLACE PLAYER START POSITIONS -----------------------------------------------------
print("RANDOM POSITIONS IS " ..tostring(randomPositions))
-- find a start location for each player

if (worldPlayerCount <=4 and worldTerrainWidth < 513) then -- reduce start positions options to 4  on smaller maps to keep players far enough apart
		
	if (worldGetRandom() < 0.49 and worldTerrainHeight > 513) then -- remove start positions on edges
		
		for index = 4, 1, -1 do
			table.remove(openStartPositions, index)
		end
		
	else -- remove start positions on corners				
		
		for index = 8, 5, -1 do
			table.remove(openStartPositions, index)
		end
		
	end	

end
	
--should be true to be correct!
if (randomPositions == true) then -- place players without regard to grouping teams together		
	
	-- select start positions
	startLocationPositions = GetStartPositionsTeamsApart(openStartPositions)
	--Start Position Stuff---------------------------------------------------------------------------------
	
	if(worldTerrainWidth <= 417) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.45))
		edgeBuffer = 1
		innerExclusion = 0.4
		topSelectionThreshold = 0.1
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
	elseif(worldTerrainWidth <= 513) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.45))
		edgeBuffer = 1
		innerExclusion = 0.5
		topSelectionThreshold = 0.033
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
	elseif(worldTerrainWidth <= 641) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.45))
		edgeBuffer = 1
		innerExclusion = 0.45
		topSelectionThreshold = 0.05
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
	elseif(worldTerrainWidth <= 769) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.35))
		edgeBuffer = 1
		innerExclusion = 0.4
		topSelectionThreshold = 0.05
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
	else
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = Round((#terrainLayoutResult * 0.45))
		edgeBuffer = 1
		innerExclusion = 0.4
		topSelectionThreshold = 0.1
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
	end
	
	startBufferRadius = 3
	startBufferTerrain = tt_plains
	
	teamMappingTable = CreateTeamMappingTable()
	
	
	impasseTypes = {tt_mountains_small}
	openTypes = {tt_plains, tt_hills_low_rolling, tt_hills_med_rolling, tt_hills_high_rolling, tt_none, tt_flatland}
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)

	startLocationPositions = {}
	
	--loop through and record player starts
	for row = 1, #terrainLayoutResult do
		for col = 1, #terrainLayoutResult do
			
			currentData = {}
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				currentData = {row, col}
				table.insert(startLocationPositions, currentData)
			end
			
		end
	end

else -- place players from the same team grouped together

	-- select start positions
	startLocationPositions = GetStartPositionsTeamsTogether(openStartPositions, masterStartPositionsTable)
	--Start Position Stuff---------------------------------------------------------------------------------
	
	if(worldTerrainWidth <= 417) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = 5
		edgeBuffer = 1
		innerExclusion = 0.4
		topSelectionThreshold = 0.1
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
	elseif(worldTerrainWidth <= 513) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = 3.75
		edgeBuffer = 1
		innerExclusion = 0.45
		topSelectionThreshold = 0.033
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
	elseif(worldTerrainWidth <= 641) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = 5
		edgeBuffer = 1
		innerExclusion = 0.4
		topSelectionThreshold = 0.075
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
	elseif(worldTerrainWidth <= 769) then
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = 4
		edgeBuffer = 1
		innerExclusion = 0.4
		topSelectionThreshold = 0.1
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
	else
		minTeamDistance = Round((#terrainLayoutResult * 0.85))
		minPlayerDistance = 7
		edgeBuffer = 1
		innerExclusion = 0.4
		topSelectionThreshold = 0.2
		impasseTypes = {tt_mountains_small}
		impasseDistance = 1.5
	end
	
	startBufferRadius = 3
	startBufferTerrain = tt_plains
	
	teamMappingTable = CreateTeamMappingTable()
	
	openTypes = {tt_plains, tt_hills_low_rolling, tt_hills_med_rolling, tt_hills_high_rolling, tt_none, tt_flatland}

	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)

	startLocationPositions = {}
	
	--loop through and record player starts
	for row = 1, #terrainLayoutResult do
		for col = 1, #terrainLayoutResult do
			
			currentData = {}
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				currentData = {row, col}
				table.insert(startLocationPositions, currentData)
			end
			
		end
	end

end

print("END OF TEST MAP BALANCED ARABIA LUA SCRIPT")
