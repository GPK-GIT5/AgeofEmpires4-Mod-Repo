-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING BOULDER BAY")

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
s = tt_mountains_small
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_low_rolling
mr = tt_hills_med_rolling
hr = tt_hills_high_rolling
low = tt_plateau_low
med = tt_plateau_med
high = tt_plateau_high
c = tt_plateau_standard
c_l = tt_plateau_low
c_m = tt_plateau_med
p = tt_plains
t = tt_impasse_trees_plains
v = tt_valley
r = tt_river
o = tt_ocean

-- setting up the map terrain using the function in the map_setup lua file in the library folder
terrainLayoutResult = SetUpGrid(gridSize, p, terrainLayoutResult)


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


-----------
--OCEAN TYPE
-----------

--roll to see what orientation the map should be
--High Level Decision: what direction is the ocean flowing in?
oceanDirectionTable = {}

-- tuning data for weight of river orientation
northOcean = 1
westOcean = 1
southOcean = 1
eastOcean = 1

--create empty data point for cumulative weight also
cumulativeWeightOceanDirectionTable = {}

--insert entries into this weight table containing our choices
table.insert(oceanDirectionTable, {"nw_se", northOcean})
table.insert(oceanDirectionTable, {"ne_sw", westOcean})
table.insert(oceanDirectionTable, {"sw_ne", southOcean})
table.insert(oceanDirectionTable, {"se_nw", eastOcean})

--total up the table weight in order to correctly be able to get a weighted selection
totalDirectionWeight = 0
for index, weightedElement in ipairs(oceanDirectionTable) do
	cumulativeWeightOceanDirectionTable[index] = totalDirectionWeight + weightedElement[2]
	totalDirectionWeight = totalDirectionWeight + weightedElement[2]
end

--make a weighted selection
currentWeightOceanDirection = worldGetRandom() * totalDirectionWeight
oceanDirection = 0

--loop through however many times based on number of elements in the selection list
for index = 1, #oceanDirectionTable do
	--loop through cumulative weights until we find the correct value range
	if(currentWeightOceanDirection < cumulativeWeightOceanDirectionTable[index]) then
		oceanDirection = index
		break
	end
end

print("Current Ocean Direction is " .. oceanDirectionTable[oceanDirection][1])

--------
--NUM OCEAN TILES BASED ON MAP SIZE
--------

cornerThreshold = 0
if(worldTerrainWidth <= 416) then --for micro maps
	minGulfSize = 14
	maxGulfSize = 16
	minPlayerDistance = 5
	minTeamDistance = gridSize - 5
	impasseBuffer = 4
	islandBuffer = 2
	targetModifier = 1
elseif(worldTerrainWidth <= 512) then --for tiny maps
	minGulfSize = 24
	maxGulfSize = 27
	minPlayerDistance = 2.5
	minTeamDistance = gridSize + 2
	impasseBuffer = 3
	islandBuffer = 2
	cornerThreshold = 1
	targetModifier = 1
elseif(worldTerrainWidth <= 640) then  --for small maps
	minGulfSize = 35
	maxGulfSize = 39
	minPlayerDistance = 2.5
	minTeamDistance = gridSize + 4
	impasseBuffer = 4
	islandBuffer = 3
	cornerThreshold = 1
	targetModifier = 2
elseif(worldTerrainWidth <= 768) then  --for medium maps
	minGulfSize = 41
	maxGulfSize = 44
	minPlayerDistance = 3
	minTeamDistance = gridSize + 2
	impasseBuffer = 4
	islandBuffer = 4
	cornerThreshold = 2
	targetModifier = 2
elseif(worldTerrainWidth <= 896) then  --for large maps
	minGulfSize = 48
	maxGulfSize = 52	
	minPlayerDistance = 3.5
	minTeamDistance = gridSize + 2
	impasseBuffer = 5
	islandBuffer = 5
	cornerThreshold = 1
	targetModifier = 2
else --for gigantic maps
	minGulfSize = 50
	maxGulfSize = 54
	minPlayerDistance = 3.5
	minTeamDistance = gridSize + 5
	impasseBuffer = 5
	targetModifier = 2
end

------------
--OCEAN GEN
------------

--variable declaration
cornerSquareRow = 1
cornerSquareCol = 1
oppositeCornerSquareRow = 1
oppositeCornerSquareCol = 1
targetCentreSquareRow = 1
targetCentreSquareCol = 1

--variables are set according to ocean direction
if oceanDirection == 1 then --direction: nw_se
	cornerSquareRow = 1
	cornerSquareCol = 1
	oppositeCornerSquareRow = gridSize
	oppositeCornerSquareCol = gridSize
	targetCentreSquareRow = mapHalfSize + mapEighthSize - targetModifier
	targetCentreSquareCol = mapHalfSize + mapEighthSize - targetModifier
	plateauSquareRow = mapHalfSize + mapQuarterSize
	plateauSquareCol = mapHalfSize + mapQuarterSize
	
elseif oceanDirection == 2 then --direction: ne_sw
	cornerSquareRow = 1
	cornerSquareCol = gridSize
	oppositeCornerSquareRow = gridSize
	oppositeCornerSquareCol = 1		
	targetCentreSquareRow = mapHalfSize + mapEighthSize - targetModifier
	targetCentreSquareCol = mapQuarterSize + mapEighthSize + targetModifier
	plateauSquareRow = mapHalfSize + mapQuarterSize
	plateauSquareCol = mapQuarterSize
elseif oceanDirection == 3 then --direction: sw_ne
	cornerSquareRow = gridSize
	cornerSquareCol = 1
	oppositeCornerSquareRow = 1
	oppositeCornerSquareCol = gridSize
	targetCentreSquareRow =  mapQuarterSize + mapEighthSize + targetModifier
	targetCentreSquareCol = mapHalfSize + mapEighthSize - targetModifier
	plateauSquareRow = mapQuarterSize
	plateauSquareCol = mapHalfSize + mapQuarterSize
else --direction: se_nw
	cornerSquareRow = gridSize
	cornerSquareCol = gridSize	
	oppositeCornerSquareRow = 1
	oppositeCornerSquareCol = 1	
	targetCentreSquareRow = mapQuarterSize + mapEighthSize + targetModifier
	targetCentreSquareCol = mapQuarterSize + mapEighthSize + targetModifier
	plateauSquareRow = mapQuarterSize
	plateauSquareCol = mapQuarterSize
end


--set the tiles to ocean
oceanSize = math.ceil(GetRandomInRange(minGulfSize, maxGulfSize))
print("oceanSize is set to " .. oceanSize)
GrowTerrainAreaToSizeDirectionalWeighted(cornerSquareRow, cornerSquareCol, targetCentreSquareRow, targetCentreSquareCol, oceanSize, {tt_plains}, tt_ocean, terrainLayoutResult)

--smooths out any empty "holes" caused by the growterrain function
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == tt_plains) then
			adjOcean = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_ocean}, terrainLayoutResult)
			
			--check to see if it found any adjacent ocean, if there are more than 5 then set to ocean as well
			if(#adjOcean >= 5) then
				print("found " .. #adjOcean .. " plateau adjacent to " .. row .. ", " .. col)
				if (terrainLayoutResult[row][col].terrainType ~= tt_player_start_classic_plains) then
					terrainLayoutResult[row][col].terrainType = tt_ocean	
					print("set adjacent plains to ocean")
				end
			end
		end
	end
end	

for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == tt_ocean) then
			adjOcean = GetNeighbors(row, col, terrainLayoutResult)
			
			--check for any plains neighbors
			for index, neighbor in ipairs(adjOcean) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				-- if the tile is a plains tile
				if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_plains) then					
					--set to beach
					terrainLayoutResult[tempRow][tempCol].terrainType = tt_beach
				end
			end
		end
	end
end	

------------
--PLATEAU
------------
-- checks direction type, and based on that elevates an area of the map

print("Generating plateau")
tempNeighborList = {}

terrainLayoutResult[plateauSquareRow][plateauSquareCol].terrainType = tt_plateau_low

if oceanDirection == 1 then

	--ensures the edges away from the bay are still plains (since the grow terrain script can spread to the edge of the map and turn it into oceans
	for row = mapHalfSize, gridSize do
		col = gridSize
		-- east edge set to plains
		terrainLayoutResult[row][col].terrainType = tt_plains		
	end
	
	for col = mapHalfSize, gridSize do
		row = gridSize
		-- south edge set to plains
		terrainLayoutResult[row][col].terrainType = tt_plains		
	end		
	print("Edges set to plains")	
	
	--sets the opposite corner to plateau
	for row = plateauSquareRow, oppositeCornerSquareRow do
		for col = plateauSquareCol, oppositeCornerSquareCol do
			terrainLayoutResult[row][col].terrainType = tt_plateau_low
		end
	end

	print("Opposite quadrant all plateaus")	
	
	--adds hills to create a way up
	for row = 1, gridSize do
		for col = 1, gridSize do
			if (terrainLayoutResult[row][col].terrainType == tt_plateau_low ) then
				-- if plateau, then find all the neighbors
				tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
				
				--second loop, checks the neighbor tiles
				for index, neighbor in ipairs(tempNeighborList) do
					
					tempRow = neighbor.x
					tempCol = neighbor.y
					
					-- if the tile is a plains tile
					if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_plains) then					
						--set to hills
						terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_low_rolling
					end
				end
			end		
		end
	end
	print("Hill pathway generated")			
elseif oceanDirection == 2 then
		
		--ensures the edges away from the bay are still plains (since the grow terrain script can spread to the edge of the map and turn it into oceans
		for row = mapHalfSize, gridSize do
			col = 1
			-- west edge set to plains
			terrainLayoutResult[row][col].terrainType = tt_plains		
		end
		
		for col = 1, mapHalfSize do
			row = gridSize
			-- south edge set to plains
			terrainLayoutResult[row][col].terrainType = tt_plains		
		end		
		print("Edges set to plains")	
		
		--sets the opposite corner to plateau
		for row = plateauSquareRow, oppositeCornerSquareRow do
			for col = oppositeCornerSquareCol, plateauSquareCol do
				terrainLayoutResult[row][col].terrainType = tt_plateau_low						
			end
		end
		print("Opposite quadrant all plateaus")	
		
		--adds hills to create a way up		
		for row = 1, gridSize do
			for col = 1, gridSize do
				
				if (terrainLayoutResult[row][col].terrainType == tt_plateau_low ) then
					-- if plateau, then find all the neighbors
					tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
					
					--second loop, checks the neighbor tiles
					for index, neighbor in ipairs(tempNeighborList) do
						
						tempRow = neighbor.x
						tempCol = neighbor.y
						
						-- if the tile is a plains tile
						if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_plains) then					
							--set to hills
							terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_low_rolling
						end
					end
				end		
			end
		end
		print("Hill pathway generated")			
elseif oceanDirection == 3 then
			
			--ensures the edges away from the bay are still plains (since the grow terrain script can spread to the edge of the map and turn it into oceans
			for row = 1, mapHalfSize do
				col = gridSize
				-- east edge set to plains
				terrainLayoutResult[row][col].terrainType = tt_plains		
			end
			
			for col = mapHalfSize, gridSize do
				row = 1	
				-- north edge set to plains
				terrainLayoutResult[row][col].terrainType = tt_plains		
			end		
			print("Edges set to plains")		
			
			--sets the opposite corner to plateau	
			for row = oppositeCornerSquareRow, plateauSquareRow do
				for col = plateauSquareCol, oppositeCornerSquareCol do
					terrainLayoutResult[row][col].terrainType = tt_plateau_low
				end
			end
			print("Opposite quadrant all plateaus")	
			
			--adds hills to create a way up		
			for row = 1, gridSize do
				for col = 1, gridSize do
					
					if (terrainLayoutResult[row][col].terrainType == tt_plateau_low ) then
						-- if plateau, then find all the neighbors
						tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
						
						--second loop, checks the neighbor tiles
						for index, neighbor in ipairs(tempNeighborList) do
							
							tempRow = neighbor.x
							tempCol = neighbor.y
							
							-- if the tile is a plains tile
							if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_plains) then					
								--set to hills
								terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_low_rolling
							end
						end
					end		
				end
			end
			print("Hill pathway generated")			
else
	--ensures the edges away from the bay are still plains (since the grow terrain script can spread to the edge of the map and turn it into oceans
	for row = 1, mapHalfSize do
		col = 1		
		-- west edge set to plains
		terrainLayoutResult[row][col].terrainType = tt_plains		
	end
	
	for col = 1, mapHalfSize do
		row = 1		
		-- north edge set to plains
		terrainLayoutResult[row][col].terrainType = tt_plains		
	end			
	print("Edges set to plains")		
	
	--sets the opposite corner to plateau
		for row = oppositeCornerSquareRow, plateauSquareRow do
			for col = oppositeCornerSquareCol, plateauSquareCol do
					terrainLayoutResult[row][col].terrainType = tt_plateau_low
			end
		end
	print("Opposite quadrant all plateaus")	
		
	
	--adds hills to create a way up		
		for row = 1, gridSize do
			for col = 1, gridSize do
				
					if (terrainLayoutResult[row][col].terrainType == tt_plateau_low ) then
						-- if plateau, then find all the neighbors
						tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
						
						--second loop, checks the neighbor tiles
						for index, neighbor in ipairs(tempNeighborList) do
							
							tempRow = neighbor.x
							tempCol = neighbor.y
							
							-- if the tile is a plains tile
							if(terrainLayoutResult[tempRow][tempCol].terrainType == tt_plains) then					
								--set to hills
								terrainLayoutResult[tempRow][tempCol].terrainType = tt_hills_low_rolling
							end
						end
				end		
			end
		end
	print("Hill pathway generated")			
end


------------
--HOLY SITES
------------

--create holy site island in the corner of the bay
terrainLayoutResult[cornerSquareRow][cornerSquareCol].terrainType = tt_holy_site_hill
holySiteNeighbors = GetNeighbors(cornerSquareRow, cornerSquareCol, terrainLayoutResult)

for testNeighborIndex, testNeighbor in ipairs(holySiteNeighbors) do
	testNeighborRow = testNeighbor.x
	testNeighborCol = testNeighbor.y
	
	--make sure there is a large ocean buffer here
	oceanNeighbors = GetAllSquaresInRadius(testNeighborRow, testNeighborCol, islandBuffer, terrainLayoutResult)
	for oceanNeighborIndex, oceanNeighbor in ipairs(oceanNeighbors) do
		oceanNeighborRow = oceanNeighbor[1]
		oceanNeighborCol = oceanNeighbor[2]
		currentTerrainType = terrainLayoutResult[oceanNeighborRow][oceanNeighborCol].terrainType
		if(currentTerrainType ~= tt_island_plains and currentTerrainType ~= tt_settlement_naval and currentTerrainType ~= tt_holy_site_hill) then
			terrainLayoutResult[oceanNeighborRow][oceanNeighborCol].terrainType = tt_ocean
		end
	end
	terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_island_plains
	if(testNeighborIndex == 2) then
		terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_settlement_naval
	end
	
end





------------------------
-- PLAYER STARTS SETUP
------------------------
teamsList, playersPerTeam = SetUpTeams()

teamMappingTable = CreateTeamMappingTable()

edgeBuffer = 1


playerStartTerrain = tt_player_start_classic_plains_naval_hybrid

if(#teamMappingTable > 2) then
	spawnBlockers = {}
	table.insert(spawnBlockers, tt_ocean)
	table.insert(spawnBlockers, tt_ocean_shore)
	table.insert(spawnBlockers, tt_river)

	basicTerrain = {}
	table.insert(basicTerrain, tt_none)
	table.insert(basicTerrain, tt_plains)
	table.insert(basicTerrain, tt_plains_clearing)
	table.insert(basicTerrain, tt_flatland)
	--table.insert(spawnBlockers, tt_plateau_low)
	--table.insert(spawnBlockers, tt_hills_low_rolling)
else
	

	spawnBlockers = {}
	table.insert(spawnBlockers, tt_impasse_mountains)
	table.insert(spawnBlockers, tt_mountains)
	table.insert(spawnBlockers, tt_plateau_med)
	table.insert(spawnBlockers, tt_ocean)
	table.insert(spawnBlockers, tt_ocean_shore)
	table.insert(spawnBlockers, tt_river)
	table.insert(spawnBlockers, tt_plateau_low)
	table.insert(spawnBlockers, tt_hills_low_rolling)
--	table.insert(spawnBlockers, tt_beach)

	basicTerrain = {}
	table.insert(basicTerrain, tt_none)
	table.insert(basicTerrain, tt_plains)
	table.insert(basicTerrain, tt_plains_clearing)
	table.insert(basicTerrain, tt_flatland)
end

if (randomPositions == true) then 
	minPlayerDistance = minTeamDistance
end

--terrainLayoutResult = PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, spawnBlockers, basicTerrain, playerStartTerrain, terrainLayoutResult)
--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .1, spawnBlockers, impasseBuffer, 0.05, playerStartTerrain, tt_plains, terrainLayoutResult)
--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .001, cornerThreshold, spawnBlockers, impasseBuffer, 0.01, playerStartTerrain, tt_hills_gentle_rolling, 2, true, terrainLayoutResult)

--cleanup for tt_plains_smooth (which is causing unwanted elevation by ocean if the playerstart is nearby)	
for row = 1, gridSize do
	for col = 1, gridSize do
		if (terrainLayoutResult[row][col].terrainType == tt_plains_smooth ) then
			terrainLayoutResult[row][col].terrainType = tt_plains
		end		
	end
end

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



terrainLayoutResult[oppositeCornerSquareRow][oppositeCornerSquareCol].terrainType = tt_settlement_plateau

terrainLayoutResult[targetCentreSquareRow][targetCentreSquareCol].terrainType = tt_holy_site
holySiteNeighbors = GetNeighbors(targetCentreSquareRow, targetCentreSquareCol, terrainLayoutResult)

for testNeighborIndex, testNeighbor in ipairs(holySiteNeighbors) do
	testNeighborRow = testNeighbor.x
	testNeighborCol = testNeighbor.y
	
	if(terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType == tt_ocean) then
	
		terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_beach
	end
	
end

terrainLayoutResult[plateauSquareRow][plateauSquareCol].terrainType = tt_plateau_low
plateauCornerNeighbors = Get8Neighbors(plateauSquareRow, plateauSquareCol, terrainLayoutResult)
for testNeighborIndex, testNeighbor in ipairs(plateauCornerNeighbors) do
	testNeighborRow = testNeighbor.x
	testNeighborCol = testNeighbor.y
	
	if(terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType == tt_plains) then
	
		terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_plateau_low
	end
	
end

terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .001, cornerThreshold, spawnBlockers, impasseBuffer, 0.01, playerStartTerrain, tt_hills_gentle_rolling, 2, true, terrainLayoutResult)

print("END OF BOULDERBAY LUA SCRIPT")