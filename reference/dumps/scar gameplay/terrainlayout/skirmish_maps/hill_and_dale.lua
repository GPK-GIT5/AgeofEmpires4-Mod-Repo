-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING HILL AND DALE")

terrainLayoutResult = {}

if(worldTerrainWidth <= 513) then --for small maps
	gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(35)
elseif(worldTerrainWidth <= 769) then  --for medium maps
	gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(35)
else --for sizes larger than 768
	gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(35)
end


if (gridHeight % 2 == 0) then
	gridHeight = gridHeight -1
end

if (gridWidth % 2 == 0) then
	gridWidth = gridWidth -1
end

gridSize = gridWidth

playerStarts = worldPlayerCount

n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout
r = tt_flatland -- flatland will not be used in the map. This is just to set a square to "random"

m = tt_mountains_small
b = tt_hills_low_rolling
l = tt_plateau_standard_small
i = tt_impasse_mountains
p = tt_plains

c = tt_trees_plains_clearing
bf = tt_trees_hills_high_rolling_clearing

-- setting up the map terrain using the function in the map_setup lua file in the library folder
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)

------------------------
--REFERENCE VALUES
------------------------

--bounty squares are used to populate an area of the map with extra resources
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains

--the following are markers used to determine player and settlement spawn points
s = tt_player_start_hills
sp = tt_settlement_plains
sh = tt_settlement_hills
seb = tt_settlement_hills_high_rolling

--reference values
baseGridSize = 13
outerRadius = 3.5 / baseGridSize * gridSize
middleRadius = 2.5 / baseGridSize * gridSize
innerRadius = 1.25 / baseGridSize * gridSize
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

rowMidPoint = Round(gridHeight / 2, 0)
colMidPoint = Round(gridWidth / 2, 0)

------------------------
--RESOURCES
------------------------

--set up resource pockets for both defensive and econ starts
defensivePocketResources1 = {}
defensivePocketResources2 = {}
defensivePocketResources3 = {}

econPocketResources1 = {}
econPocketResources2 = {}
econPocketResources3 = {}

--create groups of pocket resources that will equal out to balanced resources
--players will randomly get one set of these

-- DEFENSIVE RESOURCES
defensivePocketResourceList = {}
table.insert(defensivePocketResourceList, defensivePocketResources1)
table.insert(defensivePocketResourceList, defensivePocketResources2)
table.insert(defensivePocketResourceList, defensivePocketResources3)

psa = tt_pocket_stone_a
print("Stone pocket a is " ..psa)
psb = tt_pocket_stone_b
print("Stone pocket b is " ..psb)
psc = tt_pocket_stone_c
print("Stone pocket c is " ..psc)
pwa = tt_pocket_wood_a
print("Wood pocket a is " ..pwa)
pwb = tt_pocket_wood_b
print("Wood pocket b is " ..pwa)
pwc = tt_pocket_wood_c
print("Wood pocket c is " ..pwa)

table.insert(defensivePocketResources1, psa)
table.insert(defensivePocketResources1, pgb)
--table.insert(defensivePocketResources1, pwc)
table.insert(defensivePocketResources2, psb)
table.insert(defensivePocketResources2, pgc)
--table.insert(defensivePocketResources2, pwa)
table.insert(defensivePocketResources3, psc)
table.insert(defensivePocketResources3, pga)
--table.insert(defensivePocketResources3, pwb)

-- ECON RESOURCES
-- local distributions of resources added for the economic start position
econPocketResourceList = {}
table.insert(econPocketResourceList, econPocketResources1)
table.insert(econPocketResourceList, econPocketResources2)
table.insert(econPocketResourceList, econPocketResources3)

esa = tt_pocket_stone_food
print("Econ Stone pocket a is " ..esa)
esc = tt_pocket_stone_wood
print("Econ Stone pocket c is " ..esc)
ewa = tt_pocket_wood_food
print("Econ Wood pocket a is " ..ewa)

table.insert(econPocketResources1, esa)
table.insert(econPocketResources1, esb)
table.insert(econPocketResources1, esc)
table.insert(econPocketResources1, ewa)
table.insert(econPocketResources2, esb)
table.insert(econPocketResources2, ega)
table.insert(econPocketResources2, egb)
table.insert(econPocketResources2, ewa)
table.insert(econPocketResources3, esc)
table.insert(econPocketResources3, egb)
table.insert(econPocketResources3, ewa)
table.insert(econPocketResources3, ewa)


for set = 1, (#defensivePocketResourceList) do
	
	for pocket = 1, (#defensivePocketResourceList[set]) do
		print("Tactical Set " ..set .." pocket resource " ..pocket .." is " ..defensivePocketResourceList[set][pocket])
	end
	
end

for set = 1, (#econPocketResourceList) do
	
	for pocket = 1, (#econPocketResourceList[set]) do
		print("Econ Set " ..set .." pocket resource " ..pocket .." is " ..econPocketResourceList[set][pocket])
	end
	
end


--------------------------
--MAP SIZE SPECIFIC VALUES
--------------------------

if(worldTerrainWidth <= 416) then --for micro maps
	minNumHills = 1
	maxNumHills = 2
	stampSize = 0
	numTotalPositions = worldPlayerCount
	numPassages = 1	
--	numHills = math.ceil(GetRandomInRange(minNumHills, maxNumHills))	 --determine how many hills will spawn on the map, always at least one
	numHills = worldPlayerCount
	numDales = 2
	minPlayerDistance = 11
	minTeamDistance = gridSize * 1.5
	edgeBuffer = 1		
	startRadius = 2.75
	pathRadius = 2.75
	featureDistance = math.ceil(gridSize / 4)
	innerExclusion = 0.42
	maxSpaces = 2
	cornerThreshold = 2
	spawnBlockDistance = 4.5
	tradeRadius = 2
elseif(worldTerrainWidth <= 512) then --for tiny maps
	minNumHills = 1
	maxNumHills = 2
	stampSize = 13
	numTotalPositions = worldPlayerCount
	numPassages = 1	
--	numHills = 2 -- straight overwrite for this map size for ideal layout
	numHills = worldPlayerCount
	numDales = 2
	minPlayerDistance = 4
	minTeamDistance = gridSize * 1.2
	edgeBuffer = 2	
	startRadius = 2.3
	pathRadius = 2
	featureDistance = math.ceil(gridSize / 5)
	innerExclusion = 0.45
	maxSpaces = 4
	cornerThreshold = 2
	spawnBlockDistance = 4.5
	tradeRadius = 2
elseif(worldTerrainWidth <= 640) then  --for small maps
	minNumHills = 1
	maxNumHills = 2
	stampSize = 16
	numTotalPositions = worldPlayerCount	
	numPassages = 1	
--	numHills = 2
	numHills = worldPlayerCount
	numDales = 2
	minPlayerDistance = 4
	minTeamDistance = gridSize * 1.2
	edgeBuffer = 2		
	startRadius = 2.3
	pathRadius = 2.3
	featureDistance = math.ceil(gridSize / 6)
	innerExclusion = 0.48
	maxSpaces = 4
	cornerThreshold = 2
	spawnBlockDistance = 4.5
	tradeRadius = 2.5
elseif(worldTerrainWidth <= 768) then  --for medium maps
	minNumHills = 2
	maxNumHills = 3
	stampSize = 19
	numTotalPositions = worldPlayerCount	
	numPassages = 1	
--	numHills = 3	--currently forcing numhills to be half the size of numpositions for fairness sake
	numHills = worldPlayerCount 
	numDales = 2
	minPlayerDistance = 4
	minTeamDistance = gridSize * 1.2
	edgeBuffer = 2	
	startRadius = 3.3
	pathRadius = 2.5
	featureDistance = math.ceil(gridSize / 7)
	innerExclusion = 0.68
	maxSpaces = 6
	cornerThreshold = 0
	spawnBlockDistance = 4
	tradeRadius = 2.5
elseif(worldTerrainWidth <= 896) then  --for large maps
	minNumHills = 2
	maxNumHills = 4
	stampSize = 25
	numTotalPositions = worldPlayerCount	
	numPassages = 1	
--	numHills = 4	
	numHills = worldPlayerCount
	numDales = 3
	minPlayerDistance = 4
	minTeamDistance = gridSize * 1.2
	edgeBuffer = 3		
	startRadius = 4
	pathRadius = 2.5
	featureDistance = math.ceil(gridSize / 8)
	innerExclusion = 0.58
	maxSpaces = 8
	cornerThreshold = 0
	spawnBlockDistance = 3.5
	tradeRadius = 3
end



if(worldPlayerCount <= 2 or randomPositions == true) then
	if(startRadius <= 2 and worldTerrainWidth > 417) then
		startRadius = 3
	end
end

if(randomPositions == true and worldTerrainWidth > 641) then
	startRadius = 2.8
end


if(randomPositions == true) then
	minPlayerDistance = minTeamDistance
	cornerThreshold = 0
--	edgeBuffer = 2
	stampSize = math.ceil(1 + ((maxSpaces - worldPlayerCount) * 2.25))
	if(stampSize < 0) then
		stampSize = 0
	end
--	stampSize = stampSize - math.ceil(worldPlayerCount * 2.25)
else
	stampSize = stampSize - math.ceil(worldPlayerCount * 3)
end

print("numHills is equal to " .. numHills)

--------------------------
--FUNCTIONS
--------------------------
local function CreateDefensiveHill(startRow, startCol, startRadius)
	
--ensures that the direct ring around the playerstart tile is set to low plateaus as well
	startRing = {}
	startRing = GetAllSquaresInRadius(startRow, startCol, startRadius, terrainLayoutResult)
	print("startRing has " .. #startRing .. " tiles")
		
	for startRingIndex, coord in ipairs(startRing) do
				
		row = coord[1]
		col = coord[2]
			
		if (terrainLayoutResult[row][col].terrainType == tt_plains) or (terrainLayoutResult[row][col].terrainType == tt_plains_smooth) then
			terrainLayoutResult[row][col].terrainType = tt_plateau_standard_small	
			print("startRing set to plateau")
		end
	end	

	
--organically grow a plateau around the playerstart	
	plateauSquares = {}
--	plateauSquares = GrowTerrainAreaToSizeKeepStartTerrain(startRow, startCol, stampSize, tt_player_start_hill_and_dale, {tt_plains_smooth, tt_plains, tt_plateau_standard_small}, tt_plateau_standard_small, terrainLayoutResult)
		
	print("number of plateau tiles equals " .. #plateauSquares)	
	
--smooths out the plateaus to fill in any empty "holes" caused by the growterrain function
	--[[
	if(randomPositions == false) then
		for row = 1, gridSize do
			for col = 1, gridSize do
				if(terrainLayoutResult[row][col].terrainType == tt_plains) then
					adjPlateau = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_plateau_standard_small}, terrainLayoutResult)
					
					--check to see if it found any adjacent plateaus, if there are more than 4 then set to plateau as well
					if(#adjPlateau >= 4) then
						print("found " .. #adjPlateau .. " plateau adjacent to " .. row .. ", " .. col)
						if (terrainLayoutResult[row][col].terrainType ~= tt_player_start_hill_and_dale) and (terrainLayoutResult[row][col].terrainType ~= tt_player_start_classic_plains) then
						--	terrainLayoutResult[row][col].terrainType = tt_plateau_standard_small	
							print("set adjacent plains to plateau")
						end
					end
				end
			end
		end	
	end
	--]]
end



------------------------
-- PLAYER STARTS SETUP
------------------------
teamsList, playersPerTeam = SetUpTeams()

teamMappingTable = CreateTeamMappingTable()

playerStartTerrain = tt_player_start_hill_and_dale --tt_player_start_classic_plains

spawnBlockers = {}
table.insert(spawnBlockers, tt_impasse_mountains)
table.insert(spawnBlockers, tt_mountains)
table.insert(spawnBlockers, tt_mountains_small)
table.insert(spawnBlockers, tt_plateau_standard_small)
table.insert(spawnBlockers, tt_settlement_plains)

basicTerrain = {}
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_none)
table.insert(basicTerrain, tt_hills_gentle_rolling)



terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, spawnBlockDistance, 0.05, playerStartTerrain, tt_plains, 1, false, terrainLayoutResult)

--add all start positions to a table
startLocationPositions = {}

--loop through and record player starts
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
		
		currentData = {}
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			currentData = {row, col}
			table.insert(startLocationPositions, currentData)
			print("Chosen start location - Row: " .. row .. " Col " .. col)
		end
		
	end
end

--------------------------------
--DEFENSIVE HILL SETUP
--------------------------------

numPositionsNeeded = numHills + numDales - worldPlayerCount
hillPositions = {}

print("numPositionsNeeded is set to " .. numPositionsNeeded)

fullGrid = {}
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
		if(row > 2 and row <= gridSize - 2 and col > 2 and col <= gridSize - 2) then
			coordinates = {row, col}
			table.insert(fullGrid, coordinates)
		end
		
	end
end

if numPositionsNeeded >= 1 then --if we need additional positions, then we find more eligible squares 
	hillPositions = GetSetOfExtraSquaresDistanceApartFromTable(numPositionsNeeded, featureDistance, startLocationPositions, fullGrid, terrainLayoutResult)
else --- otherwise we already have the positions from the playerstart list and dont need more
	hillPositions = DeepCopy(startLocationPositions)
end

numTeams = #teamMappingTable

if(randomPositions == false) then

	for index = 1, numTeams do

		numPlayersInTeam = #teamMappingTable[index].players
		print("Team index is currently" .. index .. " numPlayersInTeam is " .. numPlayersInTeam)
		
		teamCoordTable = {}
		closestNeighborTable = {}
		
		if(numPlayersInTeam > 1) then
			--records all the player coordinates into a new table (easier management)
			print("Copying player coordinates into the teamCoordTable")
			for playerIndex = 1, numPlayersInTeam do
				tempRow = teamMappingTable[index].players[playerIndex].startRow
				tempCol = teamMappingTable[index].players[playerIndex].startCol
				
				teamCoord = {tempRow, tempCol}
				table.insert(teamCoordTable, teamCoord)	
			end
			
			-- compares and records the start location distance between players
			print("Recording start location distances")
			for firstPlayerIndex = 1, numPlayersInTeam do
				currentDistanceTable = {}
				
				for nextPlayerIndex = 1, numPlayersInTeam do
					if(firstPlayerIndex ~= nextPlayerIndex) then -- ensures player isnt comparing distance against itself
						print("Comparing firstPlayerIndex " .. firstPlayerIndex .. " to nextPlayerIndex " .. nextPlayerIndex)
						aRow = teamCoordTable[firstPlayerIndex][1]
						aCol = teamCoordTable[firstPlayerIndex][2]
						
						bRow = teamCoordTable[nextPlayerIndex][1]
						bCol = teamCoordTable[nextPlayerIndex][2]
						
						currentDistanceValue = GetDistanceDecimal(aRow, aCol, bRow, bCol, 4)
						indexInfo = {currentDistanceValue, firstPlayerIndex, nextPlayerIndex}
						table.insert(currentDistanceTable, indexInfo) -- inserts all the distance information into the currentDistanceTable
					end
				end
				
				print("currentDistanceTable has " .. #currentDistanceTable .. " entries")
				
				--sorts the distance information to find closest neighbor
				print("Sorting distance tables")
				table.sort(currentDistanceTable, function(a,b) return a[1] < b[1] end)
				
				closestNeighborIndex = {currentDistanceTable[1][2], currentDistanceTable[1][3]}
				table.insert(closestNeighborTable, closestNeighborIndex)
			end	
			
			print("Number of items in closestNeighborTable is " .. #closestNeighborTable)
			
			-- for each player in a team, draw the paths to the closest player
			for index = 1, #closestNeighborTable do
				print("Drawing paths, pass # " .. index)
				firstPlayerIndex = closestNeighborTable[index][1]
				firstPlayerStartRow = teamCoordTable[firstPlayerIndex][1]
				firstPlayerStartCol = teamCoordTable[firstPlayerIndex][2]
				
				nextPlayerIndex = closestNeighborTable[index][2]
				nextPlayerStartRow = teamCoordTable[nextPlayerIndex][1]
				nextPlayerStartCol = teamCoordTable[nextPlayerIndex][2]
				
				--draw the path line
				pathPointsTable = {}
				pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(firstPlayerStartRow, firstPlayerStartCol, nextPlayerStartRow, nextPlayerStartCol, false, p, gridSize, terrainLayoutResult)	
				
				for index = 1, #pathPointsTable do
					row = pathPointsTable[index][1] 
					col = pathPointsTable[index][2] 
					if terrainLayoutResult[row][col].terrainType == tt_plains then
						terrainLayoutResult[row][col].terrainType = tt_plateau_standard_small
					end
					pathRing = {}
					pathRing = GetAllSquaresInRadius(row, col, pathRadius, terrainLayoutResult)
					
					for pathRingIndex, coord in ipairs(pathRing) do
				
						row = coord[1]
						col = coord[2]
							
						if (terrainLayoutResult[row][col].terrainType == tt_plains) or (terrainLayoutResult[row][col].terrainType == tt_plains_smooth) then
							terrainLayoutResult[row][col].terrainType = tt_plateau_standard_small	
							print("pathRing set to plateau")
						end
					end
				end
				
			end 
		end	
	end
	
end

print("number of hills to generate is " .. numHills .. " and the hillPositions table has " .. #hillPositions .. " entries")

for index = 1, (numHills + numDales) do
	
	if(index <= numHills) then
		print("in hill generation loop " .. index)
		hillRow = hillPositions[index][1]
		hillCol = hillPositions[index][2]

		CreateDefensiveHill(hillRow, hillCol, startRadius)
	else
		if(index <= #hillPositions) then
			print("in dale generation loop " .. index)
			daleRow = hillPositions[index][1]
			daleCol = hillPositions[index][2]
		end
	--	terrainLayoutResult[daleRow][daleCol].terrainType = tt_player_start_plains
	end
	
end


--ensures there is a way up to the plateau from the edge of the map to prevent inaccessible terrain (creates a line of low rolling hills)
print("checking the map edge/corner tiles for inaccessible terrain")
for row = 1, gridSize do
	for col = 1, gridSize do
		if(row == 1 or row == gridSize or col == 1 or col == gridSize) then
			
			edgeNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			
			for index, neighbor in ipairs(edgeNeighbors) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				-- if the neighboring tiles are low_plateaus
				if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_plateau_standard_small) then					
					--set the playerstart tile to the plains type
					terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
					print("A map edge/corner tile has been changed to hill at " .. row .. " col " .. col)
				end
			end
				
							
		end
	end
end

--loop through hill positions and make sure any that are not start locations don't have extra starting resources
for hillIndex = 1, numHills do
	hillRow = hillPositions[hillIndex][1]
	hillCol = hillPositions[hillIndex][2]
	
	isStartPos = false
	print("looking at hill location " .. hillIndex .. " at " .. hillRow .. ", " .. hillCol)
	for startIndex = 1, #startLocationPositions do
		startRow = startLocationPositions[startIndex][1]
		startCol = startLocationPositions[startIndex][2]
		
		print("looking at start location " .. startIndex .. " at " .. startRow .. ", " .. startCol)
		
		if(startRow == hillRow and startCol == hillCol) then
			print("found matching hill and start")
			isStartPos = true
		end
		
	end
	
	if(isStartPos == false) then
		terrainLayoutResult[hillRow][hillCol].terrainType = tt_hills_low_rolling
	end
	
	if(isStartPos == true) then
		plateauSquares = FloodFill(hillRow, hillCol, tt_plateau_standard_small)

		-- find all the edges of the plateau (defined as a plateau bordering plains) and add them to the edgeofHillTable
		edgeOfHillTable = {}
		for index = 1, #plateauSquares do
			
			tempRow = plateauSquares[index][1]
			tempCol = plateauSquares[index][2]
			
			print("current index is " .. index)
			print("Looking for hill edge - temprow is equal to " .. tempRow)
			print("Looking for hill edge - tempCol is equal to " .. tempCol)
			
			currentNeighbors = {} 
			
			currentNeighbors = GetNeighbors(tempRow, tempCol, terrainLayoutResult)
				
			for edgeIndex, neighborCoord in ipairs(currentNeighbors) do
				
				edgeRow = neighborCoord.x
				edgeCol = neighborCoord.y
				
				if (terrainLayoutResult[edgeRow][edgeCol].terrainType == tt_plains and (edgeRow > 3 and edgeRow < gridSize-2 and edgeCol > 3 and edgeCol < gridSize-2)) then
					table.insert(edgeOfHillTable, {tempRow,tempCol})
					print("An edge tile has been found " .. tempRow .. " col " .. tempCol)
				end
			end	
		end
	
		print("The number of items in edgeOfHillTable is " .. #edgeOfHillTable)
			
		print("numPassages is currently set to " .. numPassages)
			
		if (numPassages > #edgeOfHillTable) then
			numPassages = #edgeOfHillTable
		end
		
		--randomly select indexes in edgeOfHillTable to become guaranteed passages
		for index = 1, numPassages do
			currentTries = 0
			::chooseAgain::
			randomIndex = math.ceil(GetRandomInRange(1,#edgeOfHillTable))
			print("new passage at edge of hill index " .. randomIndex)
			passageRow = edgeOfHillTable[randomIndex][1]
			passageCol = edgeOfHillTable[randomIndex][2]
			
			passageNeighbors = Get20Neighbors(passageRow, passageCol, terrainLayoutResult)
			passageHillNeighbors = 0
			for neighborIndex, neighborCoord in ipairs(passageNeighbors) do
				
				edgeRow = neighborCoord.x
				edgeCol = neighborCoord.y
				
				if (terrainLayoutResult[edgeRow][edgeCol].terrainType == tt_hills_low_rolling_clearing or terrainLayoutResult[edgeRow][edgeCol].terrainType == tt_hills_low_rolling) then
					passageHillNeighbors = passageHillNeighbors + 1
				end
			end
			
			if(((passageRow == 1 or passageRow == gridSize or passageCol == 1 or passageCol == gridSize) or passageHillNeighbors > 0) and currentTries < 100) then
				currentTries = currentTries + 1
				goto chooseAgain
			end
			
			print("The chosen passage will be on row " .. passageRow .. " and col " .. passageCol)
			terrainLayoutResult[passageRow][passageCol].terrainType = tt_hills_low_rolling_clearing
			
			passageRing = {}
			passageCliffs = {}
			passageRing = GetNeighbors(passageRow, passageCol, terrainLayoutResult)
			
			for pathRingIndex, coord in ipairs(passageRing) do
		
				row = coord.x
				col = coord.y
				
				currentPlainsNeighbors = 0
				testNeighbors = {}
				testNeighbors = GetNeighbors(row, col, terrainLayoutResult)
				
				for testNeighborIndex, testCoord in ipairs(testNeighbors) do
					testRow = testCoord.x 
					testCol = testCoord.y 
					
					if(terrainLayoutResult[testRow][testCol].terrainType == tt_plains) then
						currentPlainsNeighbors = currentPlainsNeighbors + 1
					end
				end
					
				if (terrainLayoutResult[row][col].terrainType == tt_plateau_standard_small and currentPlainsNeighbors > 0) then
					newInfo = {}
					newInfo = {row, col}
					table.insert(passageCliffs, newInfo)	
				end
			end
			
			if(#passageCliffs > 0) then
				randomChosenIndex = math.ceil(worldGetRandom() * #passageCliffs)
				passageRow = passageCliffs[randomChosenIndex][1]
				passageCol = passageCliffs[randomChosenIndex][2]
				
			end
						
			print("The adjacent passage will be on row " .. passageRow .. " and col " .. passageCol)
			terrainLayoutResult[passageRow][passageCol].terrainType = tt_hills_low_rolling_clearing
			
			table.remove(edgeOfHillTable, randomIndex)
			
			currentTries = 0
		end
		
		print("The number of items remaining in edgeOfHillTable is " .. #edgeOfHillTable)
	end
	
end
--------------------------------
-- DALES
--------------------------------


for daleIndex = 1 + numHills, numHills + numDales do
	if(daleIndex <= #hillPositions) then
		x = hillPositions[daleIndex][1]
		y = hillPositions[daleIndex][2]
		
		print("Dale index is " .. daleIndex  .. " and will exist in row " .. x .. " and col " .. y)
		
		terrainLayoutResult[x][y].terrainType = tt_dale_resources
		
	end
	
	--[[
	tempNeighborList = Get8Neighbors(x, y, terrainLayoutResult)
			
	for index, neighbor in ipairs(tempNeighborList) do
		
		tempRow = neighbor.x
		tempCol = neighbor.y
		
		terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_gentle_rolling					
		
	end
--]]
end 	


--------------------------------
-- CLEANUP
--------------------------------
--checks to see if a player start tile is surrounded by plains, if so set player start terrain to the plains type
for row = 1, gridSize do
	for col = 1, gridSize do
		if (terrainLayoutResult[row][col].terrainType == tt_player_start_hill_and_dale) then
			-- if plateau, then find all the neighbors
			plainsNeighbors = 0
			tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
			
			print("Found a playerstart! Now examining to see if it should be set to plains")
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				-- if the neighboring tiles are low_plateaus
				if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_plains) then					
					--set the playerstart tile to the plains type
					plainsNeighbors = plainsNeighbors + 1
					
				end
			end
			
			if(plainsNeighbors > 3) then
				terrainLayoutResult[row][col].terrainType = tt_player_start_classic_plains
				print("The playerstart in row " .. row .. " and col " .. col .. " is surrounded by plains and has been set to a plains start")
			end
		end		
	end
end

--place trade posts on opposite sides of the map on non-hill ground
validSquares = {}
for row = 1, gridSize do
	for col = 1, gridSize do
		if(row == 1 or row == gridSize or col == 1 or col == gridSize) then
			
			--find all neighbors within radius to check for player owned hills
			isValid = true
			tradeNeighbors = {}
			tradeNeighbors = GetAllSquaresInRadius(row, col, tradeRadius, terrainLayoutResult)
			
			for tradeNeighborIndex = 1, #tradeNeighbors do
			
				currentRow = tradeNeighbors[tradeNeighborIndex][1]
				currentCol = tradeNeighbors[tradeNeighborIndex][2]
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_hills_low_rolling or terrainLayoutResult[currentRow][currentCol].terrainType == tt_plateau_standard_small
						or terrainLayoutResult[currentRow][currentCol].terrainType == tt_hills_low_rolling_clearing) then
					isValid = false
				end
			end
			
			if(isValid == true) then
				table.insert(validSquares, {row, col})
			end
		end
	end
end

--place opposing trade posts
--pick a spot on the edge of the map

if(#validSquares > 0) then

	randomFirstCoordIndex = math.ceil(worldGetRandom() * #validSquares)
	randomFirstRow = validSquares[randomFirstCoordIndex][1]
	randomFirstCol = validSquares[randomFirstCoordIndex][2]

	print("number of squares in the valid square list for trade posts is " .. #validSquares)


	--terrainLayoutResult[randomFirstRow][randomFirstCol].terrainType = tt_settlement_plains

	--find the furthest square in the valid squares list
	randomSecondRow, randomSecondCol = GetFurthestSquare(randomFirstRow, randomFirstCol, validSquares)
	if(randomSecondRow == 1) then 
		randomSecondRow = 3
	end
	if(randomSecondRow == gridSize) then 
		randomSecondRow = gridSize - 2
	end
	terrainLayoutResult[randomSecondRow][randomSecondCol].terrainType = tt_settlement_plains

	--do a double far selection to ensure that one team doesn't have a more easily accessible trade post
	randomFirstRow, randomFirstCol = GetFurthestSquare(randomSecondRow, randomSecondCol, validSquares)
	if(randomFirstRow == 1) then 
		randomFirstRow = 3
	end
	if(randomFirstRow == gridSize) then 
		randomFirstRow = gridSize - 2
	end
	terrainLayoutResult[randomFirstRow][randomFirstCol].terrainType = tt_settlement_plains

	print("random first row / col: " .. randomFirstRow .. ", " .. randomFirstCol)
	print("random second row / col: " .. randomSecondRow .. ", " .. randomSecondCol)
	
end

--[[
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

--]]

--terrainLayoutResult[tradePostCoord1[1]][tradePostCoord1[2]].terrainType = tt_settlement_plains
--terrainLayoutResult[tradePostCoord2[1]][tradePostCoord2[2]].terrainType = tt_settlement_plains

--terrainLayoutResult[tradePostCoord1[1]][tradePostCoord1[2]].terrainType = tt_settlement_plains
--terrainLayoutResult[tradePostCoord2[1]][tradePostCoord2[2]].terrainType = tt_settlement_plains

print("END OF HILL AND DALE LUA SCRIPT")
