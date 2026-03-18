-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING FOUR LAKES")

-- variables containing terrain types to be used in map
n = tt_none  -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

s = tt_player_start_plains
p = tt_plains

m = tt_mountains
i = tt_impasse_mountains
b = tt_plateau_low
h = tt_hills_gentle_rolling
t = tt_trees_plains_stealth_large
v = tt_valley_shallow
l = tt_lake_shallow
L = tt_lake_deep


-- MAP/GAME SET UP ------------------------------------------------------------------------
gridHeight, gridWidth, gridSize = SetCoarseGrid() -- sets the coarse dimensions using the function found in map_setup lua file in the library folder

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid for terrain types and other data using default function found in map_setup lua in library folder
terrainLayoutresult = {} -- the grid for all terrain data (must use this name)
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)
closeStarts = false

teamMappingTable = CreateTeamMappingTable()
	
minPlayerDistance = 2.5
minTeamDistance = gridSize
edgeBuffer = 2
if(worldTerrainHeight >= 768) then
	edgeBuffer = 3
end

spawnBlockers = {}
table.insert(spawnBlockers, tt_impasse_mountains)
table.insert(spawnBlockers, tt_mountains)
table.insert(spawnBlockers, tt_settlement_hills)
table.insert(spawnBlockers, tt_plateau_low)
table.insert(spawnBlockers, tt_lake_shallow)
table.insert(spawnBlockers, tt_ocean)
table.insert(spawnBlockers, tt_ocean_shore)
table.insert(spawnBlockers, tt_ocean_deepwater_fish)
table.insert(spawnBlockers, tt_ocean_deepwater_fish_single)
table.insert(spawnBlockers, tt_lake_deep)

basicTerrain = {}
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_none)

mapEighthSize = math.ceil(gridSize/8)
cornerThreshold = 2

playerStartTerrain = tt_player_start_four_lakes -- classic mode start


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

-- PLACE TERRAIN FEATURES

-- place mountain or cliff areas around player starts
numImpasseSquares = 1

impasseTerrainTypes = {b, b, b, v, v, v, h, h, h} -- table holding the types of terrain used for impasse area. Multiple entries used for weighting

-- cycle through each player start
for pIndex = 1, #startLocationPositions do
	pX = startLocationPositions[pIndex][1]
	pY = startLocationPositions[pIndex][2]
	
	potentialImpasseSquares = GetAllSquaresInRingAroundSquare(pX, pY, 3, 1, terrainLayoutResult)
	-- remove any squares that are on the map border
	for index = #potentialImpasseSquares, 1, -1 do
		x = potentialImpasseSquares[index][1]
		y = potentialImpasseSquares[index][2]
		
		if (x == 1 or x == gridHeight or y == 1 or y == gridWidth) then
			table.remove(potentialImpasseSquares, index)
		end
	end
	
	-- randomly determine terrain type from impasse terrain table and place it
	for sIndex = 1, numImpasseSquares do
		squareIndex = GetRandomIndex(potentialImpasseSquares)
		x = potentialImpasseSquares[squareIndex][1]
		y = potentialImpasseSquares[squareIndex][2]
		--terrainLayoutResult[x][y].terrainType = GetRandomElement(impasseTerrainTypes)
		table.remove(potentialImpasseSquares, squareIndex)
	end
	
end

-- place a stealth wood roughly between all players combined. a
-- calculate mid point
if(#startLocationPositions > 1) then -- only place the forest if there is more than one player
	
	-- add up start location row and column values to calculate average
	xTotal = 0
	yTotal = 0
	for index = 1, #startLocationPositions do
		x = startLocationPositions[index][1]
		y = startLocationPositions[index][2]
		xTotal = xTotal + x
		yTotal = yTotal + y
	end
	
	-- place forest terrain center at average position between players
	forestCenterX = math.floor(xTotal / #startLocationPositions)
	forestCenterY = math.floor(yTotal / #startLocationPositions)
	
	-- place stealth forest
	baseNumForests = 3 -- base number of forests (after the initial 1st forest placement)
	numForests = math.floor(baseNumForests / 13 * gridSize) -- number of forests after scaling for # of players and map size
	print("Number of stealth forests is " ..numForests)
	terrainLayoutResult[forestCenterX][forestCenterY].terrainType = t
	
	forestRingRadius = 1
	forestRingWidth = 1
	
	-- increase the radius of hte forest area as large maps will have more forest squares
	if numForests > 8 then
		forestRingRadius = 2
		forestRingWidth = 2
	end
	
	-- pick a random square around the forest center and set it to forest terrain
	for index = 1, numForests do
		x,y = GetSquareInRingAroundSquare(forestCenterX, forestCenterY, 1, 1, {playerStartTerrain, t}, terrainLayoutResult)
		
		if (x~= nil and y ~= nil) then
			terrainLayoutResult[x][y].terrainType = t
		end
		
	end
	
end

--------------------------------
-- CLEANUP
--------------------------------

--checks for any large patches of inaccessible terrain and breaks it up
	for row = 1, gridSize do
		for col = 1, gridSize do
			if (terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) then
				adjMountain = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_mountains}, terrainLayoutResult)
				adjPlateau = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_plateau_low}, terrainLayoutResult)
				totalImpasse = #adjMountain + #adjPlateau
				--check to see if it found too many adjacent plateaus or mountains, then this tile gets set to a gentle hill to allow a way up
				if(totalImpasse >= 3) then
					print("tile found surrounded by impasse")
					print("found " .. #adjMountain .. " mountain adjacent to " .. row .. ", " .. col)
					print("found " .. #adjPlateau .. " plateau adjacent to " .. row .. ", " .. col)
					terrainLayoutResult[row][col].terrainType = tt_plains
					print("set terrain surrounded by impasse to hill")
				end
			end
		end
	end	

--placing landmas terrain
for row = 1, gridSize do
	for col = 1, gridSize do
		
			terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
		
	end
end

--placing hills on the rim of the map
for row = 1, gridSize do
	for col = 1, gridSize do
		if(  (row == 1 or row == gridSize or col == 1 or col == gridSize)) then
			terrainLayoutResult[row][col].terrainType = tt_hills_low_rolling
		end
	end
end

--do a pass around all player starts to ensure flat build space
for pIndex = 1, #startLocationPositions do
	pX = startLocationPositions[pIndex][1]
	pY = startLocationPositions[pIndex][2]
	
	startNeighbors = Get20Neighbors(pX, pY, terrainLayoutResult)
	for neighborIndex, startNeighbor in ipairs(startNeighbors) do
		currentNeighborRow = startNeighbor.x
		currentNeighborCol = startNeighbor.y 
		terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_hills_gentle_rolling
	end
	
end

function addCornersTerrain(_terrain)
	-- NW
	terrainLayoutResult[1][2].terrainType = _terrain
	terrainLayoutResult[2][1].terrainType = _terrain
	terrainLayoutResult[2][2].terrainType = _terrain
	--SW
	terrainLayoutResult[gridSize][2].terrainType = _terrain
	terrainLayoutResult[gridSize-1][1].terrainType = _terrain
	terrainLayoutResult[gridSize-1][2].terrainType = _terrain
	--NE
	terrainLayoutResult[1][gridSize-1].terrainType = _terrain
	terrainLayoutResult[2][gridSize].terrainType = _terrain
	terrainLayoutResult[2][gridSize-1].terrainType = _terrain
	--SE
	terrainLayoutResult[gridSize][gridSize-1].terrainType = _terrain
	terrainLayoutResult[gridSize-1][gridSize].terrainType = _terrain
	terrainLayoutResult[gridSize-1][gridSize-1].terrainType = _terrain
end



-- set up lakes emerging from the corners
local function CheckLakeSpawn(x1, y1, x2, y2, lakeSize, terrainLayoutResult)
	-- check row/col distance from corner
	local dx = x1 - x2
	local dy = y1 - y2
    local distance = math.sqrt ( dx * dx + dy * dy )
	
	if(distance < lakeSize) then
		terrainLayoutResult[x1][y1].terrainType = tt_ocean
	end
end

local function CheckFishSpawn(x1, y1, x2, y2, lakeSize, terrainLayoutResult)
	-- check row/col distance from corner
	local dx = x1 - x2
	local dy = y1 - y2
    local distance = math.sqrt ( dx * dx + dy * dy )
	
	if(distance < lakeSize) and (distance >= 2) then
		if (worldPlayerCount>2) then
			terrainLayoutResult[x1][y1].terrainType = tt_lake_medium_fish_single_precise
		elseif ((x1+y1)%2 == 0) then
			-- reducing spawns by 1/2 for 1v1 near shore, adding spawn around island
			terrainLayoutResult[x1][y1].terrainType = tt_lake_medium_fish_single_precise
			terrainLayoutResult[x2][y2].terrainType = tt_lake_medium_fish_single_precise
		elseif ( (x1+y1)%2 == 1) then
			-- water without fish
			terrainLayoutResult[x1][y1].terrainType = tt_lake_medium
		end
	end
end

local function addShoreLine(x1, y1, x2, y2, lakeSize, terrainLayoutResult)
	-- check row/col distance from corner
	local dx = x1 - x2
	local dy = y1 - y2
    local distance = math.sqrt ( dx * dx + dy * dy )
	
	if(distance == lakeSize) then
		terrainLayoutResult[x1][y1].terrainType =  tt_ocean_shore
	end
end

local function addHillSurround(x1, y1, x2, y2, lakeSize, terrainLayoutResult)
	-- check row/col distance from corner
	local dx = x1 - x2
	local dy = y1 - y2
    local distance = math.sqrt ( dx * dx + dy * dy )
	
	if(distance == lakeSize) then
		terrainLayoutResult[x1][y1].terrainType = tt_hills_low_rolling
	end
end

-- How far from the corner the lake should spread
lakeRadius = mapEighthSize + 2-- 4

for x1 = 1, gridSize do
	for y1 = 1, gridSize do
		-- Left Corner
		x2 = 1
		y2 = 1
		CheckLakeSpawn(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
		
		-- RightCorner
		x2 = gridWidth
		y2 = 1
		CheckLakeSpawn(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
		
		-- Top Corner
		x2 = 1
		y2 = gridHeight
		CheckLakeSpawn(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
		
		-- Bottom Corner
		x2 = gridWidth
		y2 = gridHeight
		CheckLakeSpawn(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
	end
end

-- Spawning Fish points

lakeRadius = mapEighthSize + 1 --3

for x1 = 1, gridSize do
	for y1 = 1, gridSize do
		-- Left Corner
		x2 = 1
		y2 = 1
		CheckFishSpawn(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
		
		-- RightCorner
		x2 = gridWidth
		y2 = 1
		CheckFishSpawn(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
		
		-- Top Corner
		x2 = 1
		y2 = gridHeight
		CheckFishSpawn(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
		
		-- Bottom Corner
		x2 = gridWidth
		y2 = gridHeight
		CheckFishSpawn(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
	end
end



-- Adding Shore

lakeRadius = mapEighthSize + 2 --4
if (worldPlayerCount > 2) then
	
	for x1 = 1, gridSize do
		for y1 = 1, gridSize do
			-- Left Corner
			x2 = 1
			y2 = 1
			addShoreLine(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
			
			-- RightCorner
			x2 = gridWidth
			y2 = 1
			addShoreLine(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
			
			-- Top Corner
			x2 = 1
			y2 = gridHeight
			addShoreLine(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
			
			-- Bottom Corner
			x2 = gridWidth
			y2 = gridHeight
			addShoreLine(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
		end
	end


	-- Adding hills over the shore

	lakeRadius = mapEighthSize + 3 -- 5

	for x1 = 1, gridSize do
		for y1 = 1, gridSize do
			-- Left Corner
			x2 = 1
			y2 = 1
			addHillSurround(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
			
			-- RightCorner
			x2 = gridWidth
			y2 = 1
			addHillSurround(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
			
			-- Top Corner
			x2 = 1
			y2 = gridHeight
			addHillSurround(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
			
			-- Bottom Corner
			x2 = gridWidth
			y2 = gridHeight
			addHillSurround(x1, y1, x2, y2, lakeRadius, terrainLayoutResult)
		end
	end

	-- adding more landmass around corners in large playernumber game
	if worldPlayerCount > 1 then
		addCornersTerrain(tt_plains)
	end

	-- Sacred Sites at the corners of the lakes
	terrainLayoutResult[1][1].terrainType = tt_holy_site_hill_low
	terrainLayoutResult[gridSize][1].terrainType = tt_holy_site_hill_low
	terrainLayoutResult[gridSize][gridSize].terrainType = tt_holy_site_hill_low
	terrainLayoutResult[1][gridSize].terrainType = tt_holy_site_hill_low

	--adding unique resources to each island gold / stone
	depositA = tt_four_lakes_stone_small
	depositB = tt_four_lakes_gold_small
	if (worldPlayerCount > 2) then
		depositA = tt_four_lakes_stone
		depositB = tt_four_lakes_gold
	end
	if (worldGetRandom() > 0.5) then
		terrainLayoutResult[2][2].terrainType =  depositB 
		terrainLayoutResult[gridSize-1][2].terrainType =  depositA
		terrainLayoutResult[gridSize-1][gridSize-1].terrainType =   depositB
		terrainLayoutResult[2][gridSize-1].terrainType =  depositA
	else
		terrainLayoutResult[2][2].terrainType =  depositA 
		terrainLayoutResult[gridSize-1][2].terrainType =  depositB
		terrainLayoutResult[gridSize-1][gridSize-1].terrainType =   depositA
		terrainLayoutResult[2][gridSize-1].terrainType =  depositB
	end
end

-- small "safe" forests between the lakes near the edge
mapHalfSize = math.ceil(gridSize/2)
-- Forest size depends on players count
backForestTerrain = tt_forest_plateau_low_circular_small
if (worldPlayerCount > 4) then
	backForestTerrain = tt_forest_plateau_low_circular_large
elseif (worldPlayerCount > 2) then
	backForestTerrain = tt_forest_plateau_low_circular_medium
end
terrainLayoutResult[1][mapHalfSize].terrainType =   backForestTerrain -- N
terrainLayoutResult[gridSize][mapHalfSize].terrainType =   backForestTerrain -- S
terrainLayoutResult[mapHalfSize][gridSize].terrainType =   backForestTerrain
terrainLayoutResult[mapHalfSize][1].terrainType =   backForestTerrain

-- adding settlements
if(worldGetRandom() > 0.5) then
	terrainLayoutResult[mapHalfSize][2].terrainType = tt_settlement_hills
	terrainLayoutResult[mapHalfSize][gridSize - 1].terrainType = tt_settlement_hills
	-- adding holy sites if <=2)
	if(worldPlayerCount <= 2) then
		terrainLayoutResult[mapHalfSize][gridSize - 3].terrainType = tt_holy_site_hill
		terrainLayoutResult[mapHalfSize][4].terrainType = tt_holy_site_hill
	end
else
	terrainLayoutResult[2][mapHalfSize].terrainType = tt_settlement_hills
	terrainLayoutResult[gridSize - 1][mapHalfSize].terrainType = tt_settlement_hills
	if(worldPlayerCount <= 2) then
		terrainLayoutResult[gridSize - 3][mapHalfSize].terrainType = tt_holy_site_hill
		terrainLayoutResult[4][mapHalfSize].terrainType = tt_holy_site_hill
	end
end

-- radius around spawnBlocker terrains that prevents players from spawning in those location
blockerRadius = 1
if(worldPlayerCount <= 2) then
	blockerRadius = 2
end

terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, 0.4, cornerThreshold, spawnBlockers, blockerRadius, 0.05, playerStartTerrain, tt_plateau_low, 1, false, terrainLayoutResult)


print("END OF FOUR LAKES LUA SCRIPT")
