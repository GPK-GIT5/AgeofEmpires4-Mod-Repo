-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--HIGHVIEW START
print("GENERATING HIGHVIEW")

terrainLayoutResult = {}

gridHeight, gridWidth, gridSize = SetCoarseGrid()

if (gridHeight % 2 == 0) then
	gridHeight = gridHeight -1
end

if (gridWidth % 2 == 0) then
	gridWidth = gridWidth -1
end

gridSize = gridWidth

playerStarts = worldPlayerCount

n = tt_none
h = tt_hills
s = tt_trees_plains_stealth
sl = tt_trees_plains_stealth_large
m = tt_mountains
b = tt_hills_low_rolling
mr = tt_hills_med_rolling
hr = tt_hills_high_rolling
low = tt_plateau_low
med = tt_plateau_med
high = tt_plateau_high
p = tt_plains
v = tt_valley

-- setting up the map terrain using the function in the map_setup lua file in the library folder
terrainLayoutResult = SetUpGrid(gridSize, tt_plains, terrainLayoutResult)
mapHalfSize = math.ceil(gridSize/2)
------------------------
--MAP SPECIFIC VALUES
------------------------
if(worldTerrainWidth <= 416) then --for micro maps
	stealthTiles = 40
	minPlayerDistance = 6.5
	minTeamDistance = gridSize
	edgeBuffer = 2	
	cornerThreshold = 2
elseif(worldTerrainWidth <= 512) then --for tiny maps
	stealthTiles = 60
	minPlayerDistance = 5
	minTeamDistance = gridSize
	edgeBuffer = 2		
	cornerThreshold = 2
elseif(worldTerrainWidth <= 640) then  --for small maps
	stealthTiles = 85
	minPlayerDistance = 5
	minTeamDistance = gridSize
	edgeBuffer = 1	
cornerThreshold = 2	
elseif(worldTerrainWidth <= 768) then  --for medium maps
	stealthTiles = 105
	minPlayerDistance = 5
	minTeamDistance = gridSize
	edgeBuffer = 1		
	cornerThreshold = 2
elseif(worldTerrainWidth <= 896) then  --for large maps
	stealthTiles = 135
	minPlayerDistance = 6
	minTeamDistance = gridSize
	edgeBuffer = 2		
	cornerThreshold = 2
else --for 1024+ maps
	stealthTiles = 130
	minPlayerDistance = 6
	minTeamDistance = gridSize
	edgeBuffer = 2
	cornerThreshold = 2
end

playerStartTerrainHill = tt_player_start_classic_hills_low_rolling -- classic mode start
playerStartTerrainPlain = tt_player_start_classic_plains

------------------------
-- PLAYER STARTS SETUP
------------------------
teamsList, playersPerTeam = SetUpTeams()

teamMappingTable = CreateTeamMappingTable()

playerStartTerrain = tt_player_start_classic_hills_high_rolling


---------------------
-- SETS ALL TILES NEXT TO PLAYERSTARTS INTO HILLS
---------------------

tempNeighborList = {}

for row = 1, gridSize do
	for col = 1, gridSize do
		-- first loop that checks if the tile is a playerstart
		if (terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
	
			print("PlayerStart Terrain found!")
			
			-- if playerstart, then find all the neighbors
			tempNeighborList = Get20Neighbors(row, col, terrainLayoutResult)
			
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				print("Neighbor tile coordinate row " .. tempRow .. " col " .. tempCol)
				
				if (terrainLayoutResult[tempRow][tempCol].terrainType ~= playerStartTerrain) then
					--set to hills
					--terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_low_rolling
					terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_gentle_rolling
					print("Neighbor has been set to low hill")
				end
			end
		end
	end
end

------------------------
--STEALTH FOREST GENERATION
------------------------

plainTiles = {}
for row = 1, gridSize do
	for col = 1, gridSize do
		--check for any plains tiles
		if(terrainLayoutResult[row][col].terrainType == tt_plains ) then
			plainCoord = {row, col}
			table.insert(plainTiles, plainCoord)
		end
	end
end

print("Number of Plains tiles in the map is " .. #plainTiles)

for index = 1, stealthTiles do
	numPlains = #plainTiles		
	if index <= numPlains then
		randomTileIndex = math.ceil(GetRandomInRange(1,numPlains))
		print("Index is " .. index .. " and the randomTileIndex chosen is " .. randomTileIndex)
		row = plainTiles[randomTileIndex][1]
		col = plainTiles[randomTileIndex][2]
		terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth_large
		table.remove(plainTiles, randomTileIndex)
	else
		print("Run out of plains to turn into stealth forest!")
		break
	end
end

-- place central stealth line
for i = 1, gridSize do
	terrainLayoutResult[mapHalfSize][i].terrainType = tt_trees_plains_stealth_large
end

--place holy sites and their outposts
terrainLayoutResult[mapHalfSize][2].terrainType = tt_holy_site_hill_danger_lite
terrainLayoutResult[mapHalfSize][3].terrainType = tt_poi_abandoned_outpost

terrainLayoutResult[mapHalfSize][gridSize - 1].terrainType = tt_holy_site_hill_danger_lite
terrainLayoutResult[mapHalfSize][gridSize - 2].terrainType = tt_poi_abandoned_outpost

terrainLayoutResult[math.ceil(gridSize / 2)][math.ceil(gridSize / 2)].terrainType = tt_holy_site
adjSquares = GetNeighbors(math.ceil(gridSize / 2), math.ceil(gridSize / 2), terrainLayoutResult)
	
--place two settlements 
if (worldGetRandom() < 0.1) then
	terrainLayoutResult[mapHalfSize - 1][gridSize].terrainType = tt_settlement_plains	
	terrainLayoutResult[mapHalfSize + 1][1].terrainType = tt_settlement_plains
else
	terrainLayoutResult[mapHalfSize + 1][gridSize].terrainType = tt_settlement_plains	
	terrainLayoutResult[mapHalfSize - 1][1].terrainType = tt_settlement_plains
end

-- place corner outposts on larger player games
if(worldPlayerCount > 2) then
	terrainLayoutResult[1][1].terrainType = tt_poi_abandoned_outpost
	terrainLayoutResult[gridSize][1].terrainType = tt_poi_abandoned_outpost
	terrainLayoutResult[gridSize][gridSize].terrainType = tt_poi_abandoned_outpost
	terrainLayoutResult[1][gridSize].terrainType = tt_poi_abandoned_outpost
end
spawnBlockers = {}
table.insert(spawnBlockers, tt_impasse_mountains)
table.insert(spawnBlockers, tt_mountains)
table.insert(spawnBlockers, tt_holy_site_hill_danger_lite)

basicTerrain = {}
table.insert(basicTerrain, tt_none)
table.insert(basicTerrain, tt_plains)

terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .4, cornerThreshold, spawnBlockers, 4, 0.05, playerStartTerrain, tt_hills_low_rolling, 1, true, terrainLayoutResult)

print("END OF HIGHVIEW LUA SCRIPT")