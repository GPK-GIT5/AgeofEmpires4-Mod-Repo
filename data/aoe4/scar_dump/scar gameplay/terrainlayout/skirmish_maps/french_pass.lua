-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING FRNECH PASS")

n = tt_none

h = tt_hills_med_rolling
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_low_rolling
o = tt_ocean
p = tt_plains
f = tt_flatland
s = tt_player_start_nomad_hills
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains
pl = tt_plateau_low
v = tt_valley
vs = tt_valley_shallow

f1 = tt_impasse_trees_plains
c = tt_trees_plains_clearing

playerStartTerrain = tt_player_start_classic_hills


terrainLayoutResult = {}    -- set up initial table for coarse map grid
--set up resource pockets for nomad start
nomadPocketResources1 = {}
nomadPocketResources2 = {}
nomadPocketResources3 = {}

--create groups of pocket resources that will equal out to balanced resources
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

-- create a list of tactical regions to choose from
-- gold tactical regions that are used for placing the gold in the centre of the map
tga = tt_tactical_region_gold_plains_a


-- MAP/GAME SET UP ------------------------------------------------------------------------
--call the standard function to set up our grid using standard dimensions/square
--function found in scar/terrainlayout/library/map_setup
--use this function if creating a map with standard resolution and dimension (most maps)
--see the island maps for examples of non-standard resolutions
gridHeight, gridWidth, gridSize = SetCoarseGrid()

nomadStart = false
if (winConditionOptions.section_starting_conditions and winConditionOptions.section_starting_conditions.option_age_start) then
	nomadStart = (winConditionOptions.section_starting_conditions.option_age_start.enum_value == winConditionOptions.section_starting_conditions.option_age_start.enum_items.nomad_start)
	print("NOMAD START CONDITION IS: " ..winConditionOptions.section_starting_conditions.option_age_start.enum_value.." ("..tostring(nomadStart)..")")
else
	print("NOMAD START CONDITION IS NOT SET (FALSE)")
end
--these values are values received specifically to let the script know information about map dimensions
--the number of players is grabbed from the map setup menu screen and includes both human and AI players
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

--grab the number of players from the match setup screen
playerStarts = worldPlayerCount

-- setting up the map grid with correct fields and terrain type info
-- you need to use this function when creating a new map
-- found in the engine library under scar/terrainlayout/library/setsquaresfunctions
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--set chance to kill a mountain to thin out the ridge
mountainKillChance = 0.2
valleyDepreciateChance = 0.3

--set number of extra mountains on the sides of the ridge
extraSideMountains = 8
numOfPlateaus = 2

--set map size specific scaling options
if(worldTerrainWidth <= 417) then
	laneWidth = 2
	mountainRangeThicknessChance = 0.3
	--this is the number of times the central ridge can expand per row
	extraMountainLimit = 0	
	numOfPlateaus = 0
	extraSideMountains = 0
end

if(worldTerrainWidth <= 513 and worldTerrainWidth > 417) then
	
	--lane width is how wide the space between the 2 central ridges is
	laneWidth = 2
	--this is the percentage chance that spaces beside the ridges will reamin plains
	mountainRangeThicknessChance = 0.6
	--this is the number of times the central ridge can expand per row
	extraMountainLimit = 0	
	
	extraSideMountains = 0
--	i = tt_mountains
end

if(worldTerrainWidth <= 769 and worldTerrainWidth > 513) then
	laneWidth = 2
	mountainRangeThicknessChance = 0.5
	extraMountainLimit = 2	
	extraSideMountains = 4
end

if(worldTerrainWidth <= 1025 and worldTerrainWidth > 769) then
	laneWidth = 3
	mountainRangeThicknessChance = 0.2
	extraMountainLimit = 7	
	
end

print("grid width is " .. gridSize)

if(worldTerrainWidth <= 416) then --for micro maps
	mountainLengthVariableLeft = 1
	mountainLengthVariableRight = 2
elseif(worldTerrainWidth <= 512) then --for tiny maps
	mountainLengthVariableLeft = 1
	mountainLengthVariableRight = 2
elseif(worldTerrainWidth <= 640) then  --for small maps
	mountainLengthVariableLeft = 1
	mountainLengthVariableRight = 1
elseif(worldTerrainWidth <= 768) then  --for medium maps
	mountainLengthVariableLeft = 1
	mountainLengthVariableRight = 1
elseif(worldTerrainWidth <= 896) then  --for large maps
	mountainLengthVariableLeft = 1
	mountainLengthVariableRight = 1
end

-- draw first mountain pass
--DrawLineOfTerrain((mapQuarterSize + mapEighthSize), (mapQuarterSize + mapEighthSize), (mapQuarterSize + mapEighthSize), (mapHalfSize + mapEighthSize), m, false, gridSize)
DrawLineOfTerrain((mapHalfSize - laneWidth), (mapQuarterSize + mountainLengthVariableLeft), (mapHalfSize - laneWidth), (mapHalfSize + mapQuarterSize - mountainLengthVariableRight), i, false, gridSize)
print("First Line --- StartRow: " ..(mapHalfSize - laneWidth) .." EndRow: " ..(mapQuarterSize) .." StartCol: " ..(mapHalfSize - laneWidth) .. "EndCol: " ..(mapHalfSize + mapQuarterSize))

--draw second mountain ridge
DrawLineOfTerrain(mapHalfSize + laneWidth, mapQuarterSize + mountainLengthVariableLeft, mapHalfSize + laneWidth, mapHalfSize + mapQuarterSize - mountainLengthVariableRight, i, false, gridSize)
print("Second Line --- StartRow: " ..(mapHalfSize + laneWidth) .." EndRow: " ..(mapQuarterSize))

print("map eighth size and times 1.5: " .. mapEighthSize .. ", " .. mapEighthSize*1.5)
--create list of squares that are between the mountain ranges and away from the map edges
passSquares = {}
for row = 1, gridSize do
	for col = 1 , gridSize do
	
		if((row > (mapHalfSize - laneWidth) and row < (mapHalfSize + laneWidth)) and ((col > (mapEighthSize * 1.5) and (col <= (gridSize - (mapEighthSize * 1.5) + 1))))) then
			print("adding pass square at " .. row .. ", " .. col)
			table.insert(passSquares, {row, col})
		end
	end
end

--iterate through map and create iterative features

for y = 1, gridSize do
	extraMountains = 0 
	for x = 1, gridSize do
	
	
	--add gold bounty squares through the middle
	if((x == gridHalfSize) and (y > (mapQuarterSize)) and (y < (gridSize - mapQuarterSize))) then 
		--add gold every second square through the middle
		if(y % 2 == 0) then
			terrainLayoutResult[x][y].terrainType = bg
		else
			terrainLayoutResult[x][y].terrainType = p
			
		end
			
	-- set the outer ring to a terrain type that isn't mountains at outer array locations
		if((x == 1) or (x == gridSize) or (y == 1) or (y == gridSize)) then
			RNG = worldGetRandom()
			if(RNG <= 1) then
				terrainLayoutResult[x][y].terrainType = p
			end
			if(RNG <= 0.66) then
				terrainLayoutResult[x][y].terrainType = h
			end
			if(RNG <= 0.33) then
				terrainLayoutResult[x][y].terrainType = b
			end
			
		end
	
	end
	end
end


startLocationPositions = {} -- set up list to store all player locations

print("RANDOM POSITIONS IS " ..tostring(randomPositions))
-- find a start location for each player

minTeamDistance = gridSize * 1.2
minPlayerDistance = math.ceil(gridSize * 0.65)
edgeBuffer = 2
cornerThreshold = 1
spawnBlockers = {}
table.insert(spawnBlockers, tt_mountain_range)
table.insert(spawnBlockers, tt_mountains)
table.insert(spawnBlockers, tt_mountains_small)
table.insert(spawnBlockers, tt_impasse_mountains)
		
teamMappingTable = CreateTeamMappingTable()

if(worldTerrainWidth <= 416) then --for micro maps
	innerExclusion = 0.38
elseif(worldTerrainWidth <= 512) then --for tiny maps
	innerExclusion = 0.4
elseif(worldTerrainWidth <= 640) then  --for small maps
	innerExclusion = 0.42
	if(worldPlayerCount > 4) then
		cornerThreshold = 0
	end
elseif(worldTerrainWidth <= 768) then  --for medium maps
	innerExclusion = 0.44
	if(worldPlayerCount > 6) then
		cornerThreshold = 0
	end
elseif(worldTerrainWidth <= 896) then  --for large maps
	innerExclusion = 0.5
end

if(#teamMappingTable == 2) then
	terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, false, spawnBlockers, 1, 0.01, playerStartTerrain, tt_plains_smooth, 2, false, terrainLayoutResult)
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, 1, 0.01, playerStartTerrain, tt_plains_smooth, 2, false, terrainLayoutResult)
end

--find the player spawns and add them to startLocationPositions
for row = 1, gridSize do
	for col = 1, gridSize do
		
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			
			newInfo = {}
			newInfo = {startRow = row, startCol = col}
			table.insert(startLocationPositions, newInfo)
			
			
		end
		
	end
end



--carve guaranteed pass through the middle
--this function simply draws a line of terrain on the map from the first to the second supplied coordinate
--function found in scar/terrainlayout/library/drawlinesfunctions
DrawLineOfTerrain(mapHalfSize, (mapEighthSize), mapHalfSize, (gridSize - mapEighthSize - 1), f, false, gridSize)
if(worldTerrainWidth > 513) then
	DrawLineOfTerrain(mapHalfSize+1, (mapEighthSize), mapHalfSize+1, (gridSize - mapEighthSize - 1), b, false, gridSize)
	DrawLineOfTerrain(mapHalfSize-1, (mapEighthSize), mapHalfSize-1, (gridSize - mapEighthSize - 1), b, false, gridSize)
end

for y = 1, gridSize do
	for x = 1, gridSize do
	
	--random valley depreciating
	if(terrainLayoutResult[x][y].terrainType == b and worldGetRandom() < valleyDepreciateChance) then
		terrainLayoutResult[x][y].terrainType = h
	end
	
	
	end
end


--make valley go randomly from player start to anywhere between 1/8 and 1/2 the way through the middle of the map
randomY1 = worldGetRandom() * (mapHalfSize - mapEighthSize)
randomY2 = worldGetRandom() * (mapHalfSize - mapEighthSize)
randomY3 = worldGetRandom() * (mapHalfSize - mapEighthSize)
randomY4 = worldGetRandom() * (mapHalfSize - mapEighthSize)

corner1x = 3
corner1y = 3

corner2x = gridSize - 2
corner2y = gridSize - 2

corner3x = 3
corner3y = gridSize - 2

corner4x = gridSize - 2
corner4y = 3

cliffChance = 0.85

--place plateau ridges on opposite sides of the map
if(worldTerrainWidth > 417) then
	for i = 1, numOfPlateaus do
		plat1x, plat1y = GetSquareInBox((mapEighthSize), (mapQuarterSize), (mapQuarterSize), (gridSize - mapQuarterSize), gridSize)
		plat2x, plat2y = GetSquareInBox((mapHalfSize + mapQuarterSize), (gridSize - mapEighthSize), (mapHalfSize - mapQuarterSize), (gridSize - mapQuarterSize), gridSize)

		if(terrainLayoutResult[plat1x][plat1y].terrainType ~= i and worldGetRandom() < cliffChance) then
			terrainLayoutResult[plat1x][plat1y].terrainType = pl
		end
		
		if(terrainLayoutResult[plat1x-1][plat1y].terrainType ~= i and worldGetRandom() < cliffChance) then
			terrainLayoutResult[plat1x-1][plat1y].terrainType = pl
		end
		
		if(terrainLayoutResult[plat1x-1][plat1y-1].terrainType ~= i and worldGetRandom() < cliffChance) then
			terrainLayoutResult[plat1x-1][plat1y-1].terrainType = pl
		end

		if(terrainLayoutResult[plat2x][plat2y].terrainType ~= i and worldGetRandom() < cliffChance) then
			terrainLayoutResult[plat2x][plat2y].terrainType = pl
		end
		
		if(terrainLayoutResult[plat2x+1][plat2y].terrainType ~= i and worldGetRandom() < cliffChance) then
			terrainLayoutResult[plat2x+1][plat2y].terrainType = pl
		end
		
		if(terrainLayoutResult[plat2x+1][plat2y+1].terrainType ~= i and worldGetRandom() < cliffChance) then
			terrainLayoutResult[plat2x+1][plat2y+1].terrainType = pl
		end
	end
end


--fill the centre of the map with the gold pile
--[[
terrainLayoutResult[mapHalfSize+1][mapHalfSize].terrainType = tga
terrainLayoutResult[mapHalfSize-1][mapHalfSize].terrainType = tga
terrainLayoutResult[mapHalfSize][mapHalfSize+1].terrainType = tga
terrainLayoutResult[mapHalfSize][mapHalfSize-1].terrainType = tga
terrainLayoutResult[mapHalfSize+1][mapHalfSize+1].terrainType = tga
terrainLayoutResult[mapHalfSize-1][mapHalfSize-1].terrainType = tga
terrainLayoutResult[mapHalfSize+1][mapHalfSize-1].terrainType = tga
terrainLayoutResult[mapHalfSize-1][mapHalfSize+1].terrainType = tga
]]--

--grab random squares from passSquares to put gold in

--loop through pass squares and set to gentle hills
for passSquareIndex = 1, #passSquares do
	
	currentRow = passSquares[passSquareIndex][1]
	currentCol = passSquares[passSquareIndex][2]
	terrainLayoutResult[currentRow][currentCol].terrainType = tt_hills_gentle_rolling
end

goldToPlace = 10

print("number of squares in passSquares is " .. #passSquares)
for goldIteration = 1, goldToPlace do
	
	currentGoldNum = #passSquares
	if(currentGoldNum < 1) then
		break
	end
	
	currentSquareIndex = math.ceil(worldGetRandom() * currentGoldNum)
	
	currentRow = passSquares[currentSquareIndex][1]
	currentCol = passSquares[currentSquareIndex][2]
	terrainLayoutResult[currentRow][currentCol].terrainType = tga
	table.remove(passSquares, currentSquareIndex)
end

for row = 1, gridSize do
	for col = 1 , gridSize do
	
		if((row > (mapHalfSize - laneWidth) and row < (mapHalfSize + laneWidth)) and terrainLayoutResult[row][col].terrainType == tt_none) then
			print("adding gentle hill at " .. row .. ", " .. col)
			terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
		end
	end
end


--thin mountainous terrain to not have blobs of impasse mountains
ThinTerrain(tt_impasse_mountains, 1, {tt_impasse_mountains}, tt_mountain_range, false, terrainLayoutResult)

mountainConversionChance = 0.35
for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(terrainLayoutResult[row][col].terrainType == tt_mountains) then
			if(worldGetRandom() < mountainConversionChance) then
		--		terrainLayoutResult[row][col].terrainType = tt_mountains_small
			end
		end
		
	end
end

--[[
--place one Holy Site in the centre of the map
holySiteSquares = {}
holySiteSquares = Get8Neighbors(mapHalfSize, mapHalfSize, terrainLayoutResult)

randomIndex = math.ceil(worldGetRandom() * #holySiteSquares)
randomRow = holySiteSquares[randomIndex].x
randomCol = holySiteSquares[randomIndex].y
--]]

--place two holy sites, one on each side of the pass
if(worldTerrainWidth > 769) then
	terrainLayoutResult[mapHalfSize][mapQuarterSize + mapEighthSize - 1].terrainType = tt_holy_site
	terrainLayoutResult[mapHalfSize][mapHalfSize + mapEighthSize].terrainType = tt_holy_site
elseif(worldTerrainWidth > 639) then
	terrainLayoutResult[mapHalfSize][mapQuarterSize + mapEighthSize - 1].terrainType = tt_holy_site
	terrainLayoutResult[mapHalfSize][mapHalfSize + mapEighthSize + 1].terrainType = tt_holy_site
else
	terrainLayoutResult[mapHalfSize][mapQuarterSize + mapEighthSize - 2].terrainType = tt_holy_site
	terrainLayoutResult[mapHalfSize][mapHalfSize + mapEighthSize + 1].terrainType = tt_holy_site
end


--set player start buffer
for startIndex = 1, #startLocationPositions do
	
	currentStartRow = startLocationPositions[startIndex].startRow
	currentStartCol = startLocationPositions[startIndex].startCol
	
	terrainLayoutResult[currentStartRow][currentStartCol].terrainType = playerStartTerrain
	
	startNeighbors = Get8Neighbors(currentStartRow, currentStartCol, terrainLayoutResult)
			
	for startNeighborIndex, startNeighbor in ipairs(startNeighbors) do
		currentStartNeighborRow = startNeighbor.x
		currentStartNeighborCol = startNeighbor.y 
		if(terrainLayoutResult[currentStartNeighborRow][currentStartNeighborCol].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[currentStartNeighborRow][currentStartNeighborCol].terrainType = tt_hills_low_rolling
		end
		
	end
				
	
	startNeighbors = Get20Neighbors(currentStartRow, currentStartCol, terrainLayoutResult)
	
	--check all the neighbors of this plains tile for mountains
	for startNeighborIndex, startNeighbor in ipairs(startNeighbors) do
		currentStartNeighborRow = startNeighbor.x
		currentStartNeighborCol = startNeighbor.y 
		
		if(terrainLayoutResult[currentStartNeighborRow][currentStartNeighborCol].terrainType ~= tt_player_start_classic_hills and 
				terrainLayoutResult[currentStartNeighborRow][currentStartNeighborCol].terrainType ~= tt_impasse_mountains and 
				terrainLayoutResult[currentStartNeighborRow][currentStartNeighborCol].terrainType ~= tt_mountain_range and
				terrainLayoutResult[currentStartNeighborRow][currentStartNeighborCol].terrainType ~= tt_holy_site and
				terrainLayoutResult[currentStartNeighborRow][currentStartNeighborCol].terrainType ~= tt_hills_low_rolling) then
			terrainLayoutResult[currentStartNeighborRow][currentStartNeighborCol].terrainType = tt_hills_gentle_rolling
		end
	end
end


--redraw main mountains
DrawLineOfTerrain((mapHalfSize - laneWidth), (mapQuarterSize + mountainLengthVariableLeft), (mapHalfSize - laneWidth), (mapHalfSize + mapQuarterSize - mountainLengthVariableRight), i, false, gridSize)
print("First Line --- StartRow: " ..(mapHalfSize - laneWidth) .." EndRow: " ..(mapQuarterSize) .." StartCol: " ..(mapHalfSize - laneWidth) .. "EndCol: " ..(mapHalfSize + mapQuarterSize))

--draw second mountain ridge
DrawLineOfTerrain(mapHalfSize + laneWidth, mapQuarterSize + mountainLengthVariableLeft, mapHalfSize + laneWidth, mapHalfSize + mapQuarterSize - mountainLengthVariableRight, i, false, gridSize)
print("Second Line --- StartRow: " ..(mapHalfSize + laneWidth) .." EndRow: " ..(mapQuarterSize))

--make plateaus not hit the edge of the world for balance
for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(row == 1 or col == 1 or row == gridSize or col == gridSize) then
			
			terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
			
		end
	end
end

--place trade posts in the corners
terrainLayoutResult[1][1].terrainType = tt_settlement_plains
terrainLayoutResult[2][1].terrainType = tt_hills_gentle_rolling
terrainLayoutResult[1][2].terrainType = tt_hills_gentle_rolling
terrainLayoutResult[2][2].terrainType = tt_hills_gentle_rolling

terrainLayoutResult[1][gridSize].terrainType = tt_settlement_plains
terrainLayoutResult[2][gridSize].terrainType = tt_hills_gentle_rolling
terrainLayoutResult[1][gridSize-1].terrainType = tt_hills_gentle_rolling
terrainLayoutResult[2][gridSize-1].terrainType = tt_hills_gentle_rolling

terrainLayoutResult[gridSize][1].terrainType = tt_settlement_plains
terrainLayoutResult[gridSize][2].terrainType = tt_hills_gentle_rolling
terrainLayoutResult[gridSize-1][1].terrainType = tt_hills_gentle_rolling
terrainLayoutResult[gridSize-1][2].terrainType = tt_hills_gentle_rolling

terrainLayoutResult[gridSize][gridSize].terrainType = tt_settlement_plains
terrainLayoutResult[gridSize][gridSize-1].terrainType = tt_hills_gentle_rolling
terrainLayoutResult[gridSize-1][gridSize].terrainType = tt_hills_gentle_rolling
terrainLayoutResult[gridSize-1][gridSize-1].terrainType = tt_hills_gentle_rolling


print("END OF FRENCH PASS LUA SCRIPT")
