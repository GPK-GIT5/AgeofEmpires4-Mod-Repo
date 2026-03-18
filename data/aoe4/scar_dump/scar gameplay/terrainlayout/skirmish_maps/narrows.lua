-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING NARROWS")

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout
r = tt_flatland -- flatland will not be used in the map. This is just to set a square to "random"

h = tt_hills
m = tt_mountains_small
b = tt_hills_gentle_rolling
d = tt_hills_lowlands
l = tt_plateau_low
p = tt_plains
i = tt_hills_high_rolling
v = tt_valley
x = tt_impasse_mountains
o = tt_ocean

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

if(nomadStart) then
	playerStartTerrain = tt_player_start_nomad_hills_low_rolling -- nomad mode start
else
	playerStartTerrain = tt_player_start_classic_hills_low_rolling -- classic mode start	
end

--set up resource pockets for nomad starts
nomadPocketResources1 = {}
nomadPocketResources2 = {}
nomadPocketResources3 = {}

--create groups of pocket resources that will be used for nomad start
--players will randomly get one set of these
pocketResourceList = {} -- table to hold pockets
table.insert(pocketResourceList, nomadPocketResources1)
table.insert(pocketResourceList, nomadPocketResources2)
table.insert(pocketResourceList, nomadPocketResources3)

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

----- FUNCTIONS 

--- GROW TERRAIN AREAS
-- Increases an area of terrain given a starting square in the coarse grid
-- row and col designate the starting square
-- numPasses is an integer for how many times to grow the area
-- terrainToChange is a table holding terrain types that can be changed. If a terrain type is not included in this table it will not be selected for changing
-- terrainToPlace is the designated terrain to change hte square to
function GrowTerrainArea(startRow, startCol, numPasses, terrainToChange, terrainToPlace)	
	
	local areaSquares = {} -- table to hold the squares designated as the area
	local growthChance = 0.75 -- tunable growth chance to get a more random result 0 = no growth beyond starting square, 1 = always add terrain on each pass
	
	table.insert(areaSquares, 1, {startRow, startCol}) -- start the area by adding the starting square
	for index = 1, numPasses do -- cycle through each pass
		if (index == 1) then
			row = startRow
			col = startCol

		else
			square = GetRandomElement(areaSquares) -- select a random square from the areaSquares table (on first pass this will be the passed in starting square)
			-- designate row and column
			row = square[1]
			col = square[2]
		end
		
		tempSquares = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, terrainToChange, terrainLayoutResult) -- gets all squares of the designated type around the current target square
		
		-- loop through all the selected squares to see if it should be added to the areaSquares table and have its terrain type changed
		for sIndex = 1, #tempSquares do
			x = tempSquares[sIndex][1]
			y = tempSquares[sIndex][2]
			
			-- if the random roll (0 - 0.9999) is less than the growthChance
			if (worldGetRandom() <= growthChance) then
				terrainLayoutResult[x][y].terrainType = terrainToPlace -- change the terrain to the designated terrain
				table.insert(areaSquares, #areaSquares + 1, {x, y})-- add the current square to the areaSquaresTable
			end
			
		end
		
	end
	
	return areaSquares -- returns the squares for further use
	
end

----- END OF FUNCTIONS SECTION

-- COARSE GRID SET UP
terrainLayoutResult = {}    -- set up initial table for coarse map grid. Must be named this.

gridHeight, gridWidth, gridSize = SetCoarseGrid() -- set up the coarse grid with function found in map_setup lua file in the library folder

-- debug out put for grid  setup
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

baseGridSize = 13 -- used for scaling map feautres by map size

mapCenter = math.ceil(gridSize / 2)

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult) -- sets up the terrain layout using function found in map_setup lua file in the library folder

-- PLACE PLAYER STARTS
-- variables for extablishing arrangement of player starts that scales with map size
topRowOffset = Round(2 / baseGridSize * gridHeight, 0)
bottomRowOffset = Round(3.45 / baseGridSize * gridHeight, 0)
midRowOffset = math.floor(bottomRowOffset / 2 - topRowOffset / 2)
leftColOffset = Round(2 / baseGridSize * gridHeight, 0)
rightColOffset = Round(3.45 / baseGridSize * gridHeight, 0)
midColOffset = math.floor(rightColOffset / 2 - leftColOffset / 2)

-- debug info for start location offsets
print ("Top row offset: " ..topRowOffset .." Bottom row offset: " ..bottomRowOffset .." Mid row offset: " ..midRowOffset)
print ("Left col offset: " ..leftColOffset .." Right col offset: " ..rightColOffset .." Mid col offset: " ..midColOffset)

-- START LOCATION FORMAT
-- format data for start areas using function found in player_starts lua file in the library folder
startPosition01 = MakeStartArea(1, 1 + topRowOffset, 1 + bottomRowOffset, 1 + leftColOffset, 1 + rightColOffset,{5, 7}) --top left
startPosition02 = MakeStartArea(2, gridHeight - bottomRowOffset, gridHeight - topRowOffset, gridWidth - rightColOffset, gridWidth - leftColOffset, {6, 8}) -- bottom right
startPosition03 = MakeStartArea(3, gridHeight - bottomRowOffset, gridHeight - topRowOffset, 1 + leftColOffset, 1 + rightColOffset, {6, 7}) --bottom left
startPosition04 = MakeStartArea(4, 1 + topRowOffset, 1 + bottomRowOffset, gridWidth - rightColOffset, gridWidth - leftColOffset, {5, 8}) -- top right
startPosition05 = MakeStartArea(5, 1 + topRowOffset, 1 + bottomRowOffset, Round(gridWidth / 2, 0) - midColOffset, Round(gridWidth / 2, 0) + midColOffset, {1, 4}) -- top middle 
startPosition06 = MakeStartArea(6, gridHeight - bottomRowOffset, gridHeight - topRowOffset, Round(gridWidth / 2, 0) - midColOffset, Round(gridWidth / 2, 0) + midColOffset, {2, 3}) -- bottom middle
startPosition07 = MakeStartArea(7, Round(gridHeight / 2, 0) - midRowOffset, Round(gridHeight / 2, 0) + midRowOffset, 1 + leftColOffset, 1 + rightColOffset, {1, 3}) -- middle left
startPosition08 = MakeStartArea(8, Round(gridHeight / 2, 0) - midRowOffset, Round(gridHeight / 2, 0) + midRowOffset, gridWidth - rightColOffset, gridWidth - leftColOffset, {2, 4}) -- middle right

-- add start areas to master table
masterStartPositionsTable = {startPosition01, startPosition02, startPosition03, startPosition04, startPosition05, startPosition06, startPosition07, startPosition08}
openStartPositions = {} -- table to hold start areas that will be modified during start location selection

-- copy the start positions table to an open list
openStartPositions = DeepCopy(masterStartPositionsTable)

-- debug output for start areas
for index = 1, #openStartPositions do
	print("OSP ID " ..index .." is " ..openStartPositions[index].startID .." Number of connections is: " ..#openStartPositions[index].connections)	 
end

startLocationPositions = {} -- the row and column for each player location

-- adjust the start radius for the buffer terrain around start locations based on map size
if (worldTerrainHeight > 513) then
	startRadius = 2
else
	startRadius = 1
end


-- PLACE PLAYER START POSITIONS -----------------------------------------------------
print("RANDOM POSITIONS IS " ..tostring(randomPositions))
-- set up team list
teamList = SetUpTeams() -- function to srt players into their respective teams and hold team data. Function is found in player_starts lua file in the library folder

-- find a start location for each player
if (worldPlayerCount <= 4) then -- reduce start positions options to 4 to keep players far enough apart
		print("Reducing number of player starts")
		if (worldGetRandom() < 0.49) then -- remove start positions on corners
			
			for index = 4, 1, -1 do
				table.remove(openStartPositions, index)
			end
			
		else -- remove start positions on edges				
			
			for index = 8, 5, -1 do
				table.remove(openStartPositions, index)
			end
			
		end	

	end
		
	if (randomPositions == true) then -- place players without regard to grouping teams together		
		
		-- select start positions
		startLocationPositions = GetStartPositionsTeamsApart(openStartPositions)
	
	else -- place players from the same team grouped together
	
		-- select start positions
		startLocationPositions = GetStartPositionsTeamsTogether(openStartPositions, masterStartPositionsTable)
	
	end

	-- place the start positions on the coarse grid
	for index = 1, #startLocationPositions do
		x = startLocationPositions[index].startRow
		y = startLocationPositions[index].startCol
		print("Player " ..index .." is at row " ..x ..", col "..y .." start location ID " ..startLocationPositions[index].startID)
		terrainLayoutResult[x][y].terrainType = playerStartTerrain -- place the start terrain type at hte start location to spawn starting resources
		terrainLayoutResult[x][y].playerIndex = startLocationPositions[index].playerID -- player IDs must be set for a player start locations
		-- debug output for player ID at this start location	
		print("Setting PlayerID in terrain layout to " ..startLocationPositions[index].playerID)
	end

-- check to see if nomad mode is selected and spawn starting resources appropriately
if(nomadStart) then
	--place nomad resources
	print("PLACING NOMAD RESOURCES...")
	playerResourcePocketSets = {} -- table to hold the resource pocket data. Each player will get a randomly determined set of resource pockets
	
	-- assign a resource pocket set to each player
	for index = 1, #(startLocationPositions) do
		table.insert(playerResourcePocketSets, index, GetRandomElement(pocketResourceList))	
	end
	
	PlaceNomadResourcePockets(startLocationPositions, 3, 2, 1, {n, p}, terrainLayoutResult, 2, playerResourcePocketSets, gridSize) -- this function places 3 terrain types that spawn resource pockets for the player to choose from when establishing their town center
end

------ LAND AREA GENERATION

-- generate outer ring of terrain
print("Generating outer ring of terrain...")
mapCenterRow = math.ceil(gridHeight / 2)
mapCenterCol = math.ceil(gridWidth / 2)
edgeSquares = GetAllSquaresOfTypeInRingAroundSquare(mapCenterRow, mapCenterCol, mapCenterCol - 1, 1, {n}, terrainLayoutResult)

percentOcean = .7 -- variable to how many of the outer ring squares are ocean

-- cycle through hte selected squares and set them to ocean or plains based on the percent ocean variable
for index = 1, #edgeSquares do
	x = edgeSquares[index][1]
	y = edgeSquares[index][2]
	
	if(worldGetRandom() <= 0.7) then
		terrainLayoutResult[x][y].terrainType = o
	else
		terrainLayoutResult[x][y].terrainType = p
	end
	
end

landMasses = {}
baseUnscaledNumLandmasses = 7 -- this number will be scaled based on map size. Bigger maps have more landmasses
baseNumLandmasses = math.ceil(baseUnscaledNumLandmasses / baseGridSize * gridSize)
basePasses = 6
numLandmasses = baseNumLandmasses - #startLocationPositions -- each player will get a landmass generated seperately. Get number of landmasses after player ones
print("Total land masses to place: " ..numLandmasses)
if (numLandmasses < 0) then numLandmasses = 0 end
landCenters = {}

-- create landmasses around player starts
for index = 1, #startLocationPositions do
	row = startLocationPositions[index].startRow
	col = startLocationPositions[index].startCol
	tempLandMass = GrowTerrainArea(row,col,basePasses,{n, p, b}, p)
	table.insert(landMasses, #landMasses + 1, tempLandMass)	
end

-- place buffer terrain around start locations to provide flat open building area for players
	for index = 1, #startLocationPositions do
		startBufferSquares = GetAllSquaresOfTypeInRingAroundSquare(startLocationPositions[index].startRow, startLocationPositions[index].startCol, startRadius, startRadius, {n, p, d}, terrainLayoutResult)					
		
		for index = 1, #startBufferSquares do
			x = startBufferSquares[index][1]
			y = startBufferSquares[index][2]
			terrainLayoutResult[x][y].terrainType = b
		end
	
	end

-- create any remaining landmasses ensuring they have a minimum seperation
minLandSeperation = 4

for index = 1, numLandmasses do
	squaresForLand = GetSquaresOfType(n, gridSize, terrainLayoutResult)
	print("Potential land center squares are " ..#squaresForLand)
	squareFound = false
	while (squareFound == false and (#squaresForLand) > 0) do
		squareIndex = GetRandomIndex(squaresForLand)
		print("Squares for land index is " ..squareIndex)
		
		theSquare = squaresForLand[squareIndex]
		row = theSquare[1]
		col = theSquare[2]
		
		if (#landCenters > 0) then
			
			if (SquaresFarEnoughApartEuclidian(row, col, minLandSeperation, landCenters, gridSize)) then			
				print("Placing landmass number " ..#landMasses + 1)
				terrainLayoutResult[row][col].terrainType = m
				table.insert(landCenters, {row, col})
				tempLandMass = GrowTerrainArea(row,col,basePasses,{n,p}, p)
				table.insert(landMasses, #landMasses + 1, tempLandMass)
				squareFound = true
			else
				table.remove(squaresForLand, squareIndex)
			end
			
		else			
			print("Placing landmass number " ..#landMasses + 1)
			terrainLayoutResult[row][col].terrainType = m
			table.insert(landCenters, {row, col})
			tempLandMass = GrowTerrainArea(row,col,basePasses,{n,p}, p)
			table.insert(landMasses, #landMasses + 1, tempLandMass)
			squareFound = true			
		end		
		
	end
	
end

-- debug landmass output
print("Number of landmasses: " ..#landMasses)
for index = 1, #landMasses do
	print("Number of squares in landmass " ..index .." is " ..#landMasses[index])
	tempLandmass = landMasses[index]
	for sIndex = 1, #tempLandmass do
		print("Row: " ..tempLandmass[sIndex][1] .." Col: " ..tempLandmass[sIndex][2])
	end
end

-- raise the height of land around the landmass centers
squaresToRaise = GetSquaresOfType(m, gridSize, terrainLayoutResult)

for index = 1, #squaresToRaise do
	row = squaresToRaise[index][1]
	col = squaresToRaise[index][2]
	squares = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {p}, terrainLayoutResult)
	
	for sIndex = 1, #squares do
		row = squares[sIndex][1]
		col = squares[sIndex][2]
		terrainLayoutResult[row][col].terrainType = b
	end
	
end

-- generate exclusive pairs of landmasses so that every landmass can be connected to another landmass by a land bridge
landMassPairs = {}
for aIndex = 1, #landMasses do
	
	for bIndex = aIndex, #landMasses do
		landMassA = landMasses[aIndex]
		landMassB = landMasses[bIndex]
		if (aIndex ~= bIndex) then
			squareA = landMassA[1]
			squareB = landMassB[1]
			print("Square A: row " ..squareA[1] ..", col " ..squareA[2] .." Square B: row " ..squareB[1] ..", col " ..squareB[2])
			table.insert(landMassPairs, #landMassPairs + 1, {squareA, squareB})
		end
	end
	
end

-- draw the connection
for index = 1, #landMassPairs do
	pair = landMassPairs[index]
	squareA = pair[1]
	squareB = pair[2]
	
	x1 = squareA[1]
	y1 = squareA[2]
	x2 = squareB[1]
	y2 = squareB[2]
	
	DrawLineOfTerrainExlusive(x1, y1, x2, y2, d, {m, b, playerStartTerrain}, true, gridSize) -- draws a line of terrain without overwriting the exluded set of terrain. Function gound in drawlinesfunctions lua file in the engine library folder
	
end


------ END OF LAND AREA GENERATION


print("END OF NARROWS LUA SCRIPT")