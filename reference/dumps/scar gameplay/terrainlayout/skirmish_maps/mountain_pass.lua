-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING MOUNTAIN PASS")

-- this script creates a random line of impasse mountains across the map, broken by a single choke point
-- other terrain types could be used to different effect using the same script

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

h = tt_hills
m = tt_mountains
t = tt_mountains_small
i = tt_mountain_range
p = tt_plains
f = tt_plains
v = tt_valley
b = tt_hills_high_rolling
pl = tt_hills_plateau


print("Start mode is CLASSIC")
playerStartTerrain = tt_player_start_classic_hills_mountain_pass -- classic mode start
	


-- terrain types for settlements
sp = tt_settlement_plains
sh = tt_settlement_hills
sb = tt_settlement_hills_high_rolling
sv = tt_settlement_valley

-- create table for settlement type to choose from later (excluding valley as it will be specially placed on its own)
settlementTypes = {sp, sh, sb}

-- MAP/GAME SET UP ------------------------------------------------------------------------

gridHeight, gridWidth, gridSize = SetCoarseGrid() -- sets up map grid for generation using function in map_setup lua file in library folder 

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

teamsList, playersPerTeam = SetUpTeams()

teamMappingTable = CreateTeamMappingTable()

-- create choke point through the mountain wall
-- variables to define a box in the center of the map within which the choke point is randomly placed
boxSide = math.floor(gridSize / 2)

if (boxSide % 2 == 0) then -- if the box side is even add one to make a box that's centered
	boxSide = boxSide + 1
end

-- shrink box if playing with more than 6 players to make room for players 7 & 8
if (worldPlayerCount > 6) then
	boxSide = boxSide - 2
end

print("BOX SIDE IS " ..boxSide)

boxRowMin = math.floor((gridSize - boxSide) / 2 + 1) + 1

-- shrink the box more on a tiny map to make more room for players 7 & 8
if (worldPlayerCount > 6 and worldTerrainHeight > 640) then
	boxRowMin = boxRowMin + 2
end 

print("BOX ROW MIN IS " ..boxRowMin)
boxRowMax = math.floor(gridSize - (gridSize - boxSide) / 2) - 1

if (worldPlayerCount > 6 and worldTerrainHeight > 640) then
	boxRowMax = boxRowMax - 2
end 

print("BOX ROW MAX IS " ..boxRowMax)

-- scale box size by map size
boxColMin = math.floor((gridSize - boxSide) / 2 + 1)
print("BOX COL MIN IS " ..boxColMin)
boxColMax = math.floor(gridSize - (gridSize - boxSide) / 2)
print("BOX COL MAX IS " ..boxColMax)

-- setting up the map grid
terrainLayoutResult = {}    -- set up initial table for coarse map grid. Must be named this.
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult) -- sets all terrain types to n in hte coarse grid using function in setsquaresfunctions lua file in engine library folder
impasseChance = 0.4
gapCount = 1
minPlayerDistance = math.ceil(gridSize * 0.4)
--set variables for the player start box locations within which to randomly place the start position for each map size
if (worldTerrainHeight <= 417) then -- distance from edge/corner = 2, start box size = 2 squares

	-- set the limit of how close to the edge or the map the mountain range can go
	impasseEdgeLimit = 1
	impasseChance = 0.35
	gapCount = 1
	chokeSizeMod = 0
	minPlayerDistance = math.ceil(gridSize * 0.8)

elseif (worldTerrainHeight <= 513 and worldTerrainHeight > 416) then -- distance from edge/corner = 2, start box size = 1 square	

	
	-- set the limit of how close to the edge or the map the mountain range can go
	impasseEdgeLimit = 2
	impasseChance = 0.35
	gapCount = 1
	chokeSizeMod = 1
	minPlayerDistance = math.ceil(gridSize * 0.6)
	
elseif (worldTerrainHeight <= 641 and worldTerrainHeight > 512) then -- distance from edge/corner = 2, start box size = 2 squares

	
	-- set the limit of how close to the edge or the map the mountain range can go
	impasseEdgeLimit = 2
	impasseChance = 0.35
	gapCount = 1
	chokeSizeMod = 2
	minPlayerDistance = math.ceil(gridSize * 0.5)
	
elseif (worldTerrainHeight <= 769 and worldTerrainHeight > 640) then -- distance from edge/corner = 2, start box size = 2 squares

	
	impasseEdgeLimit = 3
	impasseChance = 0.35
	gapCount = 1
	chokeSizeMod = 3
	
elseif (worldTerrainHeight <= 896 and worldTerrainHeight > 768) then -- distance from edge/corner = 2, start box size = 9 squares

	
	impasseEdgeLimit = 3
	impasseChance = 0.35
	gapCount = 2
	chokeSizeMod = 3
else -- only remaining option is 1024 -- distance from edge/corner = 2, start box size = 64 squares
	
	impasseEdgeLimit = 5
	impasseChance = 0.35
	gapCount = 2
	chokeSizeMod = 4
end
	
chokeLocation = {}
-- use tt_impasse_mountains to create a line of impasse across the map, broken by the choke point (set to tt_flatland)
bendWeightPower = 4

if (worldPlayerCount > 6) then
	bendWeightPower = 2
end

impasseEdgeOffset = math.ceil(worldGetRandom() * impasseEdgeLimit)

if(worldGetRandom() < 0.5) then
	startRow = Round(((gridSize / 2) + impasseEdgeOffset), 0)
else
	startRow = Round(((gridSize / 2) - impasseEdgeOffset), 0)
end
startCol = 1

endRow = gridSize - startRow + 1
endCol = gridSize

--DrawLineOfTerrain(startRow, startCol, endRow, endCol, i, true, gridSize)
print("impasse line being drawn from " .. startRow .. ", " .. startCol .. " to " .. endRow .. ", " .. endCol)
DrawStraightLine(startRow, startCol, endRow, endCol, true, m, gridSize, terrainLayoutResult)

--chance to make larger mountains
largeMountainChance = 0.075
for row = 1, gridSize do
	for col = 1, gridSize do
		
		if(terrainLayoutResult[row][col].terrainType == m and worldGetRandom() > largeMountainChance) then
			terrainLayoutResult[row][col].terrainType = i
		end
	end
end

-- note the row of each impasse square for each column
impasseRows = {}
for mapCol = 1, gridSize do
	
	for mapRow = 1, gridSize do
		--[[
		print("Checking column for impasse row at column " ..mapCol .. " row " ..mapRow)
		if (mapRow == chokeLocation[1] and mapCol == chokeLocation[2]) then
			print("Choke Point row at " ..mapRow .." for column " ..mapCol)
			table.insert(impasseRows, mapCol, mapRow)
			break
			--]]
		if (terrainLayoutResult[mapRow][mapCol].terrainType == i or terrainLayoutResult[mapRow][mapCol].terrainType == m) then
			--print("Impasse row at " ..mapRow .." for column " ..mapCol)
			table.insert(impasseRows, mapCol, mapRow)
			break
		end
		
	end
	
end


for index = 1, (#impasseRows) do
	print("Column " ..index .." has impasse at row " ..impasseRows[index])
end

-- find the choke point and replace the impasse mountain touching it with regular mountains
-- for a more gradual descent to the choke point "canyon"
if(worldTerrainHeight <= 513) then
	chokeCol = math.ceil(GetRandomInRange(Round((gridSize * 0.45), 0), Round((gridSize * 0.55), 0)))
else
	chokeCol = math.ceil(GetRandomInRange(Round((gridSize * 0.4), 0), Round((gridSize * 0.6), 0)))
end
print("chosen choke point column is " .. chokeCol)
y = chokeCol
x = impasseRows[chokeCol]

--terrainLayoutResult[x][y].terrainType = tt_hills_gentle_rolling

chokeLocation[1] = x
chokeLocation[2] = y

print("Impasse at " ..x ..", " ..y)
xEnd = x + 2
yEnd = y + 2
terrainLayoutResult[x][y].terrainType = tt_plains
chokeNeighbors = GetAllSquaresInRadius(x, y, chokeSizeMod, terrainLayoutResult)
chokeHills = 0
mountainNeighbors = {}
for chokeNeighborIndex, neighbor in ipairs(chokeNeighbors) do
							
	currentNeighborRow = neighbor[1]
	currentNeighborCol = neighbor[2]
	
	terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
	
end

mountainNeighbors = {}
chokeNeighbors = {}
chokeNeighbors = Get8Neighbors(x, y, terrainLayoutResult)
for chokeNeighborIndex, neighbor in ipairs(chokeNeighbors) do
							
	currentNeighborRow = neighbor.x
	currentNeighborCol = neighbor.y
	
	if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == i or terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == m) then
		currentInfo = {}
		currentInfo = {currentNeighborRow, currentNeighborCol}
		table.insert(mountainNeighbors, currentInfo)
	end
	
--	print("replacing choke neighbor mountain with less impassable terrain at " .. currentNeighborRow .. ", " .. currentNeighborCol)
--	terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_hills_gentle_rolling
end

if(#mountainNeighbors > 0) then
	randomIndex = math.ceil(worldGetRandom() * #mountainNeighbors)
	
	randomRow = mountainNeighbors[randomIndex][1]
	randomCol = mountainNeighbors[randomIndex][2]
	
	terrainLayoutResult[randomRow][randomCol].terrainType = tt_plains
end
chokeNeighbors = {}
chokeNeighbors = Get8Neighbors(x, y, terrainLayoutResult)
chokeHills = 0
for chokeNeighborIndex, neighbor in ipairs(chokeNeighbors) do
							
	currentNeighborRow = neighbor.x 
	currentNeighborCol = neighbor.y 
	
	if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_none) then
		
		if(worldGetRandom() < 0.5) then
			terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_hills_gentle_rolling
		else
			terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
		end
		
	end
	
end

for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == i or terrainLayoutResult[row][col].terrainType == m) then
			currentNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			
			for mtnNeighborIndex, neighbor in ipairs(currentNeighbors) do
							
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_none) then
					
					if(worldGetRandom() < 0.05) then
						terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_hills_low_rolling
					elseif(worldGetRandom() < 0.15) then
						terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_hills_gentle_rolling
					else
						terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
					end
					
				end
				
			end
		end
		
	end
end
	

currentGaps = 0
for mapCol = 1, gridSize do
	
	for mapRow = 1, gridSize do
		if (terrainLayoutResult[mapRow][mapCol].terrainType == i and worldGetRandom() < impasseChance and currentGaps < gapCount) then
			
			chokeNeighbors = Get8Neighbors(x, y, terrainLayoutResult)

			hillNeighbors = 0
			for chokeNeighborIndex, neighbor in ipairs(chokeNeighbors) do
										
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_hills_gentle_rolling) then
					hillNeighbors = hillNeighbors + 1
				end
				
			end
			
			if(hillNeighbors == 0) then
			--	terrainLayoutResult[mapRow][mapCol].terrainType = tt_hills_gentle_rolling
				currentGaps = currentGaps + 1
			end
			
		end
		
	end
	
end

--largeImpasseChance = 0.675
for mapCol = 1, gridSize do
	
	for mapRow = 1, gridSize do
		if (terrainLayoutResult[mapRow][mapCol].terrainType == i) then
		--if (terrainLayoutResult[mapRow][mapCol].terrainType == m) then
			terrainLayoutResult[mapRow][mapCol].terrainType = tt_impasse_mountains
		end
	end
end



-- START LOCATION FORMAT

startLocationPositions = {} -- set up list to store all player locations

print("RANDOM POSITIONS IS " ..tostring(randomPositions))
-- find a start location for each player

minTeamDistance = gridSize * 1.2
edgeBuffer = 1
cornerThreshold = 0
spawnBlockers = {}
table.insert(spawnBlockers, tt_mountain_range)
table.insert(spawnBlockers, tt_mountains)
table.insert(spawnBlockers, tt_mountains_small)
innerExclusion = 0.7

if(#teamMappingTable == 2) then
	terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, false, spawnBlockers, 2, 0.05, playerStartTerrain, tt_plains_smooth, 2, false, terrainLayoutResult)
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, 0.38, cornerThreshold, spawnBlockers, 2, 0.05, playerStartTerrain, tt_plains_smooth, 2, false, terrainLayoutResult)
end

--find the player spawns and add them to startLocationPositions
for row = 1, gridSize do
	for col = 1, gridSize do
		
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			
			newInfo = {}
			newInfo = {startRow = row, startCol = col}
			table.insert(startLocationPositions, newInfo)
			startNeighbors = {}
			startNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			
			for index, neighbor in ipairs(startNeighbors) do
					
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_none) then
					terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains_smooth
				end
			end
		end
		
	end
end

--place trade posts
trade1Row = startRow
if(trade1Row <= gridSize / 2) then
	rowDiff = Round((trade1Row / 2), 0)
	trade1Row = rowDiff
else
	rowDiff = Round(((gridSize - trade1Row) / 2), 0)
	trade1Row = trade1Row + rowDiff
end

trade2Row = endRow
if(trade2Row <= gridSize / 2) then
	rowDiff = Round((trade2Row / 2), 0)
	trade2Row = rowDiff
else
	rowDiff = Round(((gridSize - trade2Row) / 2), 0)
	trade2Row = trade2Row + rowDiff
end

terrainLayoutResult[trade1Row][endCol].terrainType = tt_settlement_plains

settlementNeighbors = {}
settlementNeighbors = GetNeighbors(trade1Row, endCol, terrainLayoutResult)

for index, neighbor in ipairs(settlementNeighbors) do
		
	tempRow = neighbor.x
	tempCol = neighbor.y
	
	if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_none) then
		terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
	end
end

terrainLayoutResult[trade2Row][startCol].terrainType = tt_settlement_plains

settlementNeighbors = {}
settlementNeighbors = GetNeighbors(trade2Row, startCol, terrainLayoutResult)

for index, neighbor in ipairs(settlementNeighbors) do
		
	tempRow = neighbor.x
	tempCol = neighbor.y
	
	if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_none) then
		terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
	end
end

-- PLACE HOLY SITES -------------------------------------
-- placing holy sites in script rather than using balance distribtuion to accomodate a divided map of this type
numberOfHolySites = 2 -- this is the maximum; the actual number may be less depending on arrangement and player count.

-- variables for placing holy sites scaling to map size
print("holy sites TO PLACE: " ..numberOfHolySites)
playerDistanceBase = 3.0 -- the base distance for holy sites from player starts
holySiteDistanceBase = 5.0 -- base distance holy sites must be apart from each other
minimumHolySiteDistancePlayer = Round(playerDistanceBase / 13.0 * gridSize * 1.2, 0)
minimumHolySiteDistancePlayer = math.ceil(minimumHolySiteDistancePlayer * 2 / worldPlayerCount)
print("minimumHolySiteDistancePlayer = " ..minimumHolySiteDistancePlayer)
minimumHolySiteDistanceHolySites = Round(holySiteDistanceBase / 13.0 * gridSize * 1.2, 0)
minimumHolySiteDistanceHolySites = math.ceil(minimumHolySiteDistanceHolySites * 2 / worldPlayerCount)
print("minimumHolySiteDistanceHolySites = " ..minimumHolySiteDistanceHolySites)

if(worldPlayerCount == 1) then
	minimumHolySiteDistancePlayer = 1.0
end

::placeHolySites::

holySiteLocations = {} -- tyable to hold holy site locations

-- find a place to put the holy site
print("PLACING " ..numberOfHolySites .." holy sites")

-- find all the null squares remaining on the coarse grid for holy site placement
validSquareList = GetSquaresOfType(n, gridSize, terrainLayoutResult)
validSquareListTop = GetSquaresOfType(n, gridSize, terrainLayoutResult)
validSquareListBottom = GetSquaresOfType(n, gridSize, terrainLayoutResult)

-- remove any null squares on the outside rows and columns of the coarse grid to keep holy sites away from the edges
for index = (#validSquareList), 1, -1 do	
	print ("Row: " ..validSquareList[index][1] ..", Col: " ..validSquareList[index][2] .." Index: " ..index)
	
	if (validSquareList[index][1] == 1 or validSquareList[index][1] == gridSize) then
		print("Removing because row")
		table.remove(validSquareList, index)
		table.remove(validSquareListTop, index)
		table.remove(validSquareListBottom, index)
	elseif (validSquareList[index][2] == 1 or validSquareList[index][2] == gridSize) then
		print("Removing because col")
		table.remove(validSquareList, index)
		table.remove(validSquareListTop, index)
		table.remove(validSquareListBottom, index)
	end
	
end

-- remove squares that are below the line of impasse mountains for the top placement area
for index = (#validSquareListTop), 1, -1 do
	
	currentTopRow = validSquareListTop[index][1]
	currentTopCol = validSquareListTop[index][2]
	if (currentTopRow >= impasseRows[currentTopCol] - 1) then
		print("Index: " ..index .. " - Removing Square from top placement at row: " ..validSquareListTop[index][1] .." col: " ..validSquareListTop[index][2])
		table.remove(validSquareListTop, index)
	end
	
end

--print all what's left in the top list
for index = 1, #validSquareListTop do
	print("index " .. index .. " of ValidSquareListTop is " .. validSquareListTop[index][1] .. ", " .. validSquareListTop[index][2])
end

-- remove squares that are above the line of impasse mountains for the bottom placement area
for index = (#validSquareListBottom), 1, -1 do

--	print("looking at square from validSquareListBottom, index " .. index .. " at " .. validSquareListBottom[index][1] .. ", " .. validSquareListBottom[index][2])
	currentBottomRow = validSquareListBottom[index][1]
	currentBottomCol = validSquareListBottom[index][2]
	
--	print("current impasse row we are looking at is " .. impasseRows[currentBottomCol] .. " and that plus one is " .. impasseRows[currentBottomCol] + 1)
		if (currentBottomRow <= impasseRows[currentBottomCol] + 1 ) then
			print("Removing Square Removing Square from bottom placement at row: " ..validSquareListBottom[index][1] .." col: " ..validSquareListBottom[index][2])
			table.remove(validSquareListBottom, index)
		end
	
end

--print all what's left in the bottom list
for index = 1, #validSquareListBottom do
	print("index " .. index .. " of ValidSquareListBottom is " .. validSquareListBottom[index][1] .. ", " .. validSquareListBottom[index][2])
end

-- cycle through each holy site and attempt to place one while making sure they are not too close to players and other holy sites
x = chokeLocation[1]
y = chokeLocation[2]
centralHolySiteCoords = {}
--	print("Placing holy site in choke point at " .. x .. ", " .. y)
--	table.insert(holySiteLocations,{x, y})
table.insert(centralHolySiteCoords, {x, y})
holySitePlaced = true


for index = 1, numberOfHolySites do
	holySitePlaced = false
	print("FINDING LOCATION OF holy site " ..index)

	if (index % 2 == 0) then -- holy site is even numbered so place at top of map
		print("Attempting to place holy site at the TOP of the map...")
		
		while (holySitePlaced == false and (#validSquareListTop) > 0) do
			squareChoice = {}
			squareIndex = (Round((worldGetRandom() - 1E-10) * ((#validSquareListTop) - 1), 0)) + 1
			print("Square index is " ..squareIndex)
			squareChoice = validSquareListTop[squareIndex]
			
			x, y = squareChoice[1], squareChoice[2]
			farEnoughFromPlayers = false
			farEnoughFromHolySites = false
			print("----- Squares remaining: " ..(#validSquareListTop) .." -----------------")
			print("CHECKING DISTANCE FROM PLAYER...")
			
			if (SquaresFarEnoughApartEuclidian(x, y, minimumHolySiteDistancePlayer, startLocationPositions, gridSize) == true) then
				print("**********  FAR ENOUGH AWAY **********")
				print("VALID PLAYER START DISTANCE")
				farEnoughFromPlayers = true
			else
				print("**********  TOO CLOSE **********")
				print("TOO CLOSE TO PLAYER START LOCATION ")
				farEnoughFromPlayers = false
				table.remove(validSquareListTop, squareIndex)
			end
	
			if (farEnoughFromPlayers == true) then
				
				if ((#holySiteLocations) > 0) then
					print("CHECKING holy site DISTANCE")	
					
					if (SquaresFarEnoughApartEuclidian(x, y, minimumHolySiteDistanceHolySites, centralHolySiteCoords, gridSize) == true) then
						print("**********  FAR ENOUGH AWAY **********")
						print("VALID holy site DISTANCE")
						farEnoughFromHolySites = true
					else
						print("**********  TOO CLOSE **********")
						print("TOO CLOSE TO holy site LOCATION")
						farEnoughFromHolySites = false
						table.remove(validSquareListTop, squareIndex)
					end
					
				else
					print("FIRST holy site. holy site DISTANCE CHECK NOT REQUIRED.")
					farEnoughFromHolySites = true
				end
				
			end
			
			if (farEnoughFromPlayers == true and farEnoughFromHolySites == true) then
				table.insert(holySiteLocations,{x, y})
				table.remove(validSquareListTop, squareIndex)
				print("holy site " ..(#holySiteLocations) .." PLACED AT: " ..x ..", " ..y)
				holySitePlaced = true	
			end
			
		end
		
	else
		-- place a holy site at the bottom of the map
		print("Attempting to place holy site at the BOTTOM of the map...")
		
		while (holySitePlaced == false and (#validSquareListBottom) > 0) do
			squareChoice = {}
			squareIndex = (Round((worldGetRandom() - 1E-10) * ((#validSquareListBottom) - 1), 0)) + 1
			squareChoice = validSquareListBottom[squareIndex]
			print("Square at row "  ..squareChoice[1] ..", column " ..squareChoice[2])
			
			x, y = squareChoice[1], squareChoice[2]
			farEnoughFromPlayers = false
			farEnoughFromHolySites = false
			print("----- Squares remaining: " ..(#validSquareListBottom) .." -----------------")
			print("CHECKING DISTANCE FROM PLAYER...")

			if (SquaresFarEnoughApartEuclidian(x, y, minimumHolySiteDistancePlayer, startLocationPositions, gridSize) == true) then
				print("**********  FAR ENOUGH AWAY **********")
				print("VALID PLAYER START DISTANCE")
				farEnoughFromPlayers = true
			else
				print("**********  TOO CLOSE **********")
				print("TOO CLOSE TO PLAYER START LOCATION ")
				farEnoughFromPlayers = false
				table.remove(validSquareListBottom, squareIndex)
			end
	
			if (farEnoughFromPlayers == true) then
				
				if ((#holySiteLocations) > 0) then
					print("CHECKING holy site DISTANCE")	
					
					if (SquaresFarEnoughApartEuclidian(x, y, minimumHolySiteDistanceHolySites, centralHolySiteCoords, gridSize) == true) then
						print("**********  FAR ENOUGH AWAY **********")
						print("VALID holy site DISTANCE")
						farEnoughFromHolySites = true
					else
						print("**********  TOO CLOSE **********")
						print("TOO CLOSE TO holy site LOCATION")
						farEnoughFromHolySites = false
						table.remove(validSquareListBottom, squareIndex)
					end
					
				else
					print("FIRST holy site. holy site DISTANCE CHECK NOT REQUIRED.")
					farEnoughFromHolySites = true
				end
				
			end
			
			if (farEnoughFromPlayers == true and farEnoughFromHolySites == true) then
				table.insert(holySiteLocations,{x, y})
				table.remove(validSquareListBottom, squareIndex)
				print("holy site " ..(#holySiteLocations) .." PLACED AT: " ..x ..", " ..y)
				holySitePlaced = true	
			end
			
		end
		
	end
	
end

holySiteNum = #holySiteLocations
if(holySiteNum ~= 2) then
	minimumHolySiteDistanceHolySites = minimumHolySiteDistanceHolySites - 1
	if(minimumHolySiteDistanceHolySites < 1) then
		minimumHolySiteDistanceHolySites = 1
	end
	print("reducing holy site distance to " .. minimumHolySiteDistanceHolySites)
	goto placeHolySites
end

-- randomly select holy site type for each location and set terrain
for index, value in ipairs(holySiteLocations) do
	
	terrainLayoutResult[value[1]][value[2]].terrainType = tt_holy_site
	
	sacredSiteNeighbors = GetNeighbors(value[1], value[2], terrainLayoutResult)
		
	for neighborIndex, sacredSiteNeighbor in ipairs(sacredSiteNeighbors) do
		row = sacredSiteNeighbor.x
		col = sacredSiteNeighbor.y
		
		terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth
		
	end
end


print("END OF MOUNTAIN PASS LUA SCRIPT")

