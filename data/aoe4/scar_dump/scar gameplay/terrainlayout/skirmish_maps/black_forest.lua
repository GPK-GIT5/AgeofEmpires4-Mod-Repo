-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING BLACK FOREST")

--------------------------
--MAP SIZE SPECIFIC VALUES
--------------------------



terrainLayoutResult = {}
mapRes = 34
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(mapRes)
--gridHeight, gridWidth, gridSize = SetCoarseGrid()

if (gridHeight % 2 == 0) then
	gridHeight = gridHeight -1
end

if (gridWidth % 2 == 0) then
	gridWidth = gridWidth -1
end

gridSize = gridWidth

playerStarts = worldPlayerCount

-- setting up the map terrain using the function in the map_setup lua file in the library folder
terrainLayoutResult = SetUpGrid(gridSize, tt_impasse_trees_plains_forest, terrainLayoutResult)

-- variables containing terrain types to be used in map
n = tt_none -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

p = tt_plains

-- impasse tree terrain types place local distributions of dense woods
t = tt_impasse_trees_plains_forest
g = tt_impasse_trees_plains_gaps

h = tt_hills
b = tt_hills_high_rolling
f = tt_flatland
i = tt_impasse_mountains

sep = tt_settlement_plains
seh = tt_settlement_hills
seb = tt_settlement_hills_high_rolling

------------------------
--REFERENCE VALUES
------------------------
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
print("row mid point and col mid point are " .. rowMidPoint .. ", " .. colMidPoint)
extraPathCount = 0
forestCheckRadius = 2
innerExclusion = 0.6
if(worldTerrainWidth <= 416) then --for micro maps
	largeClearing = 2
	mapRes = 34
	lakeSize = 3
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.85))
	edgeBuffer = 1
	extraPathCount = 0
	forestCheckRadius = 2
	innerExclusion = 0.4
	clearingRadius = 1
	cornerThreshold = 0
elseif(worldTerrainWidth <= 512) then --for tiny maps
	largeClearing = 1
	mapRes = 34
	lakeSize = 3
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.4))
	edgeBuffer = 2
	extraPathCount = 0
	forestCheckRadius = 1
	innerExclusion = 0.6
	clearingRadius = 1
	cornerThreshold = 0
elseif(worldTerrainWidth <= 640) then  --for small maps
	largeClearing = 2
	mapRes = 34
	lakeSize = 3
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.4))
	edgeBuffer = 2
	extraPathCount = 1
	forestCheckRadius = 1.5
	clearingRadius = 1
	cornerThreshold = 2
elseif(worldTerrainWidth <= 768) then  --for medium maps
	largeClearing = 9
	mapRes = 35
	lakeSize = 5
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.4))
	edgeBuffer = 2
	extraPathCount = 2
	forestCheckRadius = 1.5
	clearingRadius = 1
	cornerThreshold = 2
elseif(worldTerrainWidth <= 896) then  --for large maps
	largeClearing = 11
	mapRes = 35
	lakeSize = 6
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.4))
	edgeBuffer = 2
	extraPathCount = 3
	forestCheckRadius = 1.5
	clearingRadius = 1
	cornerThreshold = 3
else --for 1024+ maps
	largeClearing = 20
	mapRes = 35
	lakeSize = 6
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.4))
	edgeBuffer = 2
end
--------------------------
--FUNCTIONS
--------------------------
local function ExpandStartClearing(startRow, startCol, clearingSize)
	
--ensures that the direct ring around the playerstart tile is set to plains
startRing = {}
startRing = Get12Neighbors(startRow, startCol, terrainLayoutResult)
print("startRing has " .. #startRing .. " tiles")
	
for startRingIndex, coord in ipairs(startRing) do
			
	row = coord.x
	col = coord.y
		
	if (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
		terrainLayoutResult[row][col].terrainType = tt_plains
		print("startRing set to plain")
	end
end	
	
--organically grow a clearing around the playerstart	
GrowTerrainAreaToSizeKeepStartTerrain(startRow, startCol, clearingSize, playerStartTerrain, {tt_impasse_trees_plains_forest, tt_impasse_trees_plains_gaps, tt_plains, tt_plains_smooth}, tt_plains, terrainLayoutResult)
	
--smooths out the plateaus to fill in any empty "holes" caused by the growterrain function
	for row = 1, gridSize do
		for col = 1, gridSize do
			if(terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
				adjPlains = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_plains}, terrainLayoutResult)
				
				--check to see if it found any adjacent plains, if there are more than 4 then set to plains as well
				if(#adjPlains >= 4) then
					print("found " .. #adjPlains .. " plains adjacent to " .. row .. ", " .. col)
					if (terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) then
						terrainLayoutResult[row][col].terrainType = tt_plains
						print("set adjacent forest to plains")
					end
				end
			end
		end
	end
	
	
	--resets the start buffer
	startRingReset = {}
	startRingReset = Get12Neighbors(startRow, startCol, terrainLayoutResult)
	print("startRingReset has " .. #startRingReset .. " tiles")
	
	for startRingIndex, coord in ipairs(startRingReset) do
				
		row = coord.x
		col = coord.y
		
		if(terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) then
			terrainLayoutResult[row][col].terrainType = tt_plains_smooth
			print("startRingReset at index " .. startRingIndex .. " set to tt_plains_smooth")
		end
		
	end	
	
end

local function CreateLake(startRow, startCol, lakeSize)

--ensures that the direct ring around the chosen point is set to lake_deep
lakeRing = {}
lakeRing = Get8Neighbors(startRow, startCol, terrainLayoutResult)
print("lakeRing has " .. #lakeRing .. " tiles")

for startRingIndex, coord in ipairs(lakeRing) do
			
	row = coord.x
	col = coord.y
		
	if (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) or (terrainLayoutResult[row][col].terrainType == tt_plains) or (terrainLayoutResult[row][col].terrainType == tt_plains_clearing) then
		terrainLayoutResult[row][col].terrainType = tt_lake_shallow_low
		print("lakeRing set to lake")
	end
end	
	
	
--organically grow a lake
GrowTerrainAreaToSize(startRow, startCol, lakeSize, {tt_impasse_trees_plains_forest, tt_plains, tt_plains_clearing, tt_lake_shallow_low}, tt_lake_shallow_low, terrainLayoutResult)

	--smooths out the lake to fill in any empty "holes" caused by the growterrain function
	for row = 1, gridSize do
		for col = 1, gridSize do
			if(terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) or (terrainLayoutResult[row][col].terrainType == tt_plains) or (terrainLayoutResult[row][col].terrainType == tt_plains_clearing) then
				adjLake = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {tt_lake_shallow_low}, terrainLayoutResult)
				
				--check to see if it found any adjacent lake, if there are more than 4 then set to lake as well
				if(#adjLake >= 3) then
					print("found " .. #adjLake .. " lake adjacent to " .. row .. ", " .. col)
					terrainLayoutResult[row][col].terrainType = tt_lake_shallow_low
					print("set tile to lake")
				end
			end
		end
	end
	--[[
	--ring of shallow lake around the deeper lake
	for row = 1, gridSize do
		for col = 1, gridSize do
		
			--check for deep lake terrain
			if(terrainLayoutResult[row][col].terrainType == tt_lake_deep) then
				
				--grab neighbors, check for anything not also deep lake
				currentNeighbors = GetNeighbors(row, col, terrainLayoutResult)
				hasLandNeighbor = false
				for neighborIndex, neighbor in ipairs(currentNeighbors) do
					currentNeighborRow = neighbor.x 
					currentNeighborCol = neighbor.y 
					if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_lake_deep and terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_lake_shallow_low) then
						hasLandNeighbor = true
					end
				end
				
				if(hasLandNeighbor == true) then
					terrainLayoutResult[row][col].terrainType = tt_lake_shallow_low
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

playerStartTerrain = tt_player_start_black_forest

spawnBlockers = {}
table.insert(spawnBlockers, tt_mountains)
table.insert(spawnBlockers, tt_mountains_small)
table.insert(spawnBlockers, tt_plateau_low)

basicTerrain = {}
table.insert(basicTerrain, tt_impasse_trees_plains_forest)
table.insert(basicTerrain, tt_plains)

isVertical = false
randomSacredSites = false
if (#teamMappingTable == 2) and (randomPositions == false) and (worldPlayerCount > 1) then
	spawnOrientation = worldGetRandom()	
	if (spawnOrientation <= 0.5) then --horizontal orientation
		terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, false, spawnBlockers, 2, 0.05, playerStartTerrain, tt_plains_smooth, clearingRadius, true, terrainLayoutResult)
	else --vertical orientation
		terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, true, spawnBlockers, 2, 0.05, playerStartTerrain, tt_plains_smooth, clearingRadius, true, terrainLayoutResult)
		isVertical = true
	end
else
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, 2, 0.05, playerStartTerrain, tt_plains_smooth, clearingRadius, true, terrainLayoutResult)
	if(worldPlayerCount > 2) then
		randomSacredSites = true
	end
	
end

--terrainLayoutResult = PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, spawnBlockers, basicTerrain, tt_player_start_classic_plains_no_trees, terrainLayoutResult)


--add all start positions to a table
startLocationPositions = {}
print("number of start locations is equal to " .. #startLocationPositions)

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

--grow clearings for player starts
for index = 1, #startLocationPositions do
	print("drawing clearings " .. index)
	startRow = startLocationPositions[index][1]
	startCol = startLocationPositions[index][2]
	ExpandStartClearing(startRow, startCol, largeClearing)
end

------------------------
--PATHS
------------------------
-------------------------------------------------- 
-- draw paths between players on the same team
-------------------------------------------------- 	
print("Drawing team paths")

playerCoordTable = {}
numTeams = #teamMappingTable
print("numTeams is " .. numTeams)
for teamIndex = 1, numTeams do
	
	numPlayersInTeam = #teamMappingTable[teamIndex].players
	print("numPlayersInTeam for team " .. teamIndex .. " is " .. numPlayersInTeam)
	for playerIndex = 1, numPlayersInTeam do
		print("looking at player " .. playerIndex)
		tempRow = teamMappingTable[teamIndex].players[playerIndex].startRow
		print("player " .. playerIndex .. " row: " .. tempRow)
		tempCol = teamMappingTable[teamIndex].players[playerIndex].startCol
		print("player " .. playerIndex .. " col: " .. tempCol)
		
		teamCoord = {tempRow, tempCol}
		table.insert(playerCoordTable, teamCoord)
		print("adding a coord at " .. tempRow .. ", " .. tempCol .. " to playerCoordTable")
	end
end
	

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
					if terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest then
						terrainLayoutResult[row][col].terrainType = tt_plains
					end
				end
				
				--optional: make the path thicker between teammates when teams together
				if (randomPositions == false) then
					print("pathPointsTable has " .. #pathPointsTable .. " points")
					print("making paths thicker")
					for pathIndex = 1, #pathPointsTable do
						
						pathPoints = GetNeighbors(pathPointsTable[pathIndex][1], pathPointsTable[pathIndex][2], terrainLayoutResult)
						
						for pathIndex, coord in ipairs(pathPoints) do
							
							row = coord.x
							col = coord.y
							if (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
								terrainLayoutResult[row][col].terrainType = tt_plains
								print("path set to plain")
							end
						end	
					end
				end	
			
		end 
	end	
end


-------------------------------------------------- 
-- draw paths between players on opposing teams
--------------------------------------------------  
--records the number of players on each team and sorts a table by most players to least number of players
teamSortPlayerCountTable = {}

print("Sorting team playercount tables")
for teamIndex = 1, numTeams do
	numPlayersInTeam = #teamMappingTable[teamIndex].players
	playerSizeInfo = {numPlayersInTeam, teamIndex}
	table.insert(teamSortPlayerCountTable, playerSizeInfo)
	
	table.sort(teamSortPlayerCountTable, function(a,b) return a[1] > b[1] end)
end

--draw paths to players on other teams
minPathCount = 2
minOpenPoints = 6
pointsToAdd = minPathCount + extraPathCount
if(worldPlayerCount == 1) then
	pointsToAdd = pointsToAdd * 2
end
print("will add extra points, adding " .. pointsToAdd)
--first, populate a table containing all forest squares
openListCopy = DeepCopy(playerCoordTable)
extraPoints = {}



print("Drawing paths to opponents")
for teamIndex = 1, numTeams do
	print("Current teamIndex is " .. teamIndex)
	
	numPlayersInTeam = #teamMappingTable[teamIndex].players
	
	openList = {}
	closedList = {}
	maxPaths = 4

	--records all the team player coordinates into a new table (easier management)
	teamCoordTable = {}
	print("Copying player coordinates into the teamCoordTable")
	for playerIndex = 1, numPlayersInTeam do
		tempRow = teamMappingTable[teamIndex].players[playerIndex].startRow
		tempCol = teamMappingTable[teamIndex].players[playerIndex].startCol
		
		teamCoord = {tempRow, tempCol}
		table.insert(teamCoordTable, teamCoord)	
	end
	
	print("teamCoordTable contains " .. #teamCoordTable .. " items ")
	
	--records all the opponent coordinates into a new table
	print("Copying opponent coordinates into the openList")
	for opponentTeamIndex = 1, numTeams do
		if teamIndex ~= opponentTeamIndex then --team isnt looking at itself
			numPlayersInOpponentTeam = #teamMappingTable[opponentTeamIndex].players

			for opponentIndex = 1, numPlayersInOpponentTeam do
				tempRow = teamMappingTable[opponentTeamIndex].players[opponentIndex].startRow
				tempCol = teamMappingTable[opponentTeamIndex].players[opponentIndex].startCol
				
				opponentCoord = {tempRow, tempCol}
				table.insert(openList, opponentCoord)	
			end
		end
	end

	print("openList contains " .. #openList .. " items ")
	
	
	
	-- compares and records the start location distance between players, only do this for team1 which will draw to closest opponent (other teams will pick a random opponent to path to)
	if (teamIndex == 1 and worldPlayerCount > 1 and #teamMappingTable > 1) then
		closestOpponentTable = {}
		print("Recording start location distances")
		for firstPlayerIndex = 1, numPlayersInTeam do
			for opponentTeamIndex = 2, numTeams do
				currentDistanceTable = {}
				numPlayersInOpponentTeam = #teamMappingTable[opponentTeamIndex].players
				
				for nextPlayerIndex = 1, numPlayersInOpponentTeam do
					
					print("Comparing firstPlayerIndex " .. firstPlayerIndex .. " to nextPlayerIndex " .. nextPlayerIndex)
					aRow = teamCoordTable[firstPlayerIndex][1]
					aCol = teamCoordTable[firstPlayerIndex][2]
					
					bRow = openList[nextPlayerIndex][1]
					bCol = openList[nextPlayerIndex][2]
					
					currentDistanceValue = GetDistanceDecimal(aRow, aCol, bRow, bCol, 4)
					indexInfo = {currentDistanceValue, firstPlayerIndex, nextPlayerIndex}
					table.insert(currentDistanceTable, indexInfo) -- inserts all the distance information into the currentDistanceTable
					
				end
				
				print("currentDistanceTable has " .. #currentDistanceTable .. " entries")
				
				--sorts the distance information to find closest neighbor
				print("Sorting distance tables")
				table.sort(currentDistanceTable, function(a,b) return a[1] < b[1] end)
				
				closestOpponentIndex = {currentDistanceTable[1][2], currentDistanceTable[1][3]}
				table.insert(closestOpponentTable, closestOpponentIndex)
			end	
			
			print("Number of items in closestNeighborTable is " .. #closestNeighborTable)
			
			-- for each player in a team, draw the paths to the closest player
			for index = 1, #closestOpponentTable do
				print("Drawing paths, pass # " .. index)
				firstPlayerIndex = closestOpponentTable[index][1]
				firstPlayerStartRow = teamCoordTable[firstPlayerIndex][1]
				firstPlayerStartCol = teamCoordTable[firstPlayerIndex][2]
				
				nextPlayerIndex = closestOpponentTable[index][2]
				nextPlayerStartRow = openList[nextPlayerIndex][1]
				nextPlayerStartCol = openList[nextPlayerIndex][2]
				
				--draw the path line
				pathPointsTable = {}
				pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(firstPlayerStartRow, firstPlayerStartCol, nextPlayerStartRow, nextPlayerStartCol, false, p, gridSize, terrainLayoutResult)	
				
				for index = 1, #pathPointsTable do
					row = pathPointsTable[index][1] 
					col = pathPointsTable[index][2] 
					if terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest then
						terrainLayoutResult[row][col].terrainType = tt_plains_clearing
					end
				end
				
				
				--thicken
				print("making p1 opponent path thicker")
				for pathIndex = 1, #pathPointsTable do
					if (isVertical == true) then
						row = pathPointsTable[pathIndex][1] -1
						col = pathPointsTable[pathIndex][2]
						
						if (row < 0) then
							row = 0					
						end
						
						if (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
							terrainLayoutResult[row][col].terrainType = tt_plains_clearing
							print("path set to plain")
						end
					else
						row = pathPointsTable[pathIndex][1]
						col = pathPointsTable[pathIndex][2] -1
						
						if (col < 0) then
							col = 0					
						end	
						
						if (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
							terrainLayoutResult[row][col].terrainType = tt_plains_clearing
							print("path set to plain")
						end						
					end
					
				end	
			end
		end
	else
		--draw paths to opponents (team 2 and onwards)
		for pathIndex = 1, numPlayersInTeam do
			print("Pathing index " .. pathIndex)
			while (pathIndex <= maxPaths) and (pathIndex <= #teamCoordTable) and (#openList >= 1) do
				if pathIndex ~= #teamCoordTable then
					randomPlayerIndex = math.ceil(GetRandomInRange(1, #teamCoordTable))
				else 
					randomPlayerIndex = 1
				end
				
				aRow = teamCoordTable[randomPlayerIndex][1]
				aCol = teamCoordTable[randomPlayerIndex][2]
				table.remove(teamCoordTable, randomPlayerIndex)
				
				randomOpponentIndex = math.ceil(GetRandomInRange(1, #openList))
				bRow = openList[randomOpponentIndex][1]
				bCol = openList[randomOpponentIndex][2]
				
				table.remove(openList, randomOpponentIndex)
	
				--find the direct path line
				pathPointsTable = {}
				pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(aRow, aCol, bRow, bCol, false, p, gridSize, terrainLayoutResult)
				
				--grab a large radius around the midpoint of the direct path, will randomly choose a point from this radius to path towards
				pathPointMid = math.ceil(#pathPointsTable/2)
				midPointRow = pathPointsTable[pathPointMid][1]
				midPointCol = pathPointsTable[pathPointMid][1]
				midPointClearingTable = {}
				midPointClearingTable = Get20Neighbors(midPointRow, midPointCol, terrainLayoutResult)
				
				randomMidPointIndex = math.ceil(GetRandomInRange(1, #midPointClearingTable))
				randomMidPointRow = midPointClearingTable[randomMidPointIndex].x
				randomMidPointCol = midPointClearingTable[randomMidPointIndex].y
				
				newPathFirstPlayer = {}
				newPathFirstPlayer = DrawLineOfTerrainNoDiagonalReturn(aRow, aCol, randomMidPointRow, randomMidPointCol, false, p, gridSize, terrainLayoutResult)
				
				newPathSecondPlayer = {}
				newPathSecondPlayer = DrawLineOfTerrainNoDiagonalReturn(bRow, bCol, randomMidPointRow, randomMidPointCol, false, p, gridSize, terrainLayoutResult)
				
				--draw line from p1 to selected point
				for index = 1, #newPathFirstPlayer do
					print("newPathFirstPlayer drawn with " .. #newPathFirstPlayer .. " points in the line")
					row = newPathFirstPlayer[index][1] 
					col = newPathFirstPlayer[index][2] 
					print("current row / col is " .. row .. ", " .. col)
					if terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest then
						terrainLayoutResult[row][col].terrainType = tt_plains_clearing
					end
				end
				--[[
				--thicken
				for pathIndex = 1, #newPathFirstPlayer do
					print("on path index " .. pathIndex)
					if (isVertical == true) then
						row = newPathFirstPlayer[pathIndex][1] -1
						col = newPathFirstPlayer[pathIndex][2]
						print("current row / col is " .. row .. ", " .. col)
						if (row < 1) then
							row = newPathFirstPlayer[pathIndex][1] + 1	--indicates that the path is right by the edge, so we thicken in the other direction instead				
						end
						
						if (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
							terrainLayoutResult[row][col].terrainType = tt_plains_clearing
							print("path set to plain")
						end
					else
						row = newPathFirstPlayer[pathIndex][1]
						col = newPathFirstPlayer[pathIndex][2] -1
						print("current row / col is " .. row .. ", " .. col)
						if (col < 1) then
							col = newPathFirstPlayer[pathIndex][2] + 1 --indicates that the path is right by the edge, so we thicken in the other direction instead					
						end	
						
						if (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
							terrainLayoutResult[row][col].terrainType = tt_plains_clearing
							print("path set to plain")
						end						
					end
				end						
					--]]
				--draw line from p2 to selected point
				for index = 1, #newPathSecondPlayer do
					print("newPathSecondPlayer drawn")
					
					row = newPathSecondPlayer[index][1] 
					col = newPathSecondPlayer[index][2] 
					if terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest then
						terrainLayoutResult[row][col].terrainType = tt_plains_clearing
					end
				end
				
				--thicken
				--[[
				for pathIndex = 1, #newPathSecondPlayer do
					if (isVertical == true) then
						row = newPathSecondPlayer[pathIndex][1] -1
						col = newPathSecondPlayer[pathIndex][2]
						
						if (row < 1) then
							row = newPathSecondPlayer[pathIndex][1] + 1	--indicates that the path is right by the edge, so we thicken in the other direction instead
						end
						
						if (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
							terrainLayoutResult[row][col].terrainType = tt_plains_clearing
							print("path set to plain")
						end
					else
						row = newPathSecondPlayer[pathIndex][1]
						col = newPathSecondPlayer[pathIndex][2] -1
						
						if (col < 1) then
							col = newPathSecondPlayer[pathIndex][2] + 1	--indicates that the path is right by the edge, so we thicken in the other direction instead	
						end	
						
						if (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
							terrainLayoutResult[row][col].terrainType = tt_plains_clearing
							print("path set to plain")
						end						
					end
					
				end		
				--]]
				--end of random path drawing
				
				print("Path drawn between team " .. teamIndex ..  " player " .. randomPlayerIndex .. " and randomOpponent " .. randomOpponentIndex)
				
				table.remove(teamCoordTable, randomPlayerIndex)
				print("Removed index " .. randomPlayerIndex .. " from teamCoordTable")
				table.remove(openList, randomOpponentIndex)
				print("Removed index " .. randomOpponentIndex .. " from openList")
				
			end
		end
	end
	
end


forestThreshold = 20

forestStartDistance = Round((#terrainLayoutResult / 3), 0)
for openAddIndex = 1, pointsToAdd do
	forestSquares = {}
	for row = 1, #terrainLayoutResult do
		for col = 1, #terrainLayoutResult do
			if(terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
				newInfo = {}
				newInfo = {row, col}
				table.insert(forestSquares, newInfo)
			end
		end
	end
	
	--audit forest squares to only be interior forests
	for forestIndex = #forestSquares, 1, -1 do
		removeSquare = false
		currentRow = forestSquares[forestIndex][1]
		currentCol = forestSquares[forestIndex][2]
		
		currentForestNeighbors = GetAllSquaresInRadius(currentRow, currentCol, forestCheckRadius, terrainLayoutResult)
		currentForestNeighborCount = 0
		for testNeighborIndex, testNeighbor in ipairs(currentForestNeighbors) do
			testNeighborRow = testNeighbor[1]
			testNeighborCol = testNeighbor[2]
			currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
			
			if(currentTerrainType ~= tt_impasse_trees_plains_forest) then
				currentForestNeighborCount = currentForestNeighborCount + 1
			end
		end
		
		--make sure this forest square is far enough away from player starts, loop through playerCoordTable
		for playerIndex = 1, #playerCoordTable do
			
			currentPlayerRow = playerCoordTable[playerIndex][1]
			currentPlayerCol = playerCoordTable[playerIndex][2]
			
			currentDistance = GetDistance(currentPlayerRow, currentPlayerCol, currentRow, currentCol, 4)
			if(currentDistance < forestStartDistance) then
				removeSquare = true
			end
		end
		
		if(currentForestNeighborCount > 0) then
			removeSquare = true
		end
		
		if(removeSquare == true) then
			table.remove(forestSquares, forestIndex)
		end
	end
	
	if(#forestSquares > 0) then
		
		--grab a viable forest square
		--newFarSquare = GetFurthestSquareFromSquares(forestSquares, openListCopy)
		newFarSquareIndex = math.ceil(worldGetRandom() * #forestSquares)
		newFarSquare = forestSquares[newFarSquareIndex]
		table.insert(openListCopy, newFarSquare)
		table.insert(extraPoints, newFarSquare)
		print("added extra new far square at " .. newFarSquare[1] .. ", " .. newFarSquare[2])
		terrainLayoutResult[newFarSquare[1]][newFarSquare[2]].terrainType = tt_mountains
		currentMountainNeighbors = GetNeighbors(newFarSquare[1], newFarSquare[2], terrainLayoutResult)
		
		for testNeighborIndex, testNeighbor in ipairs(currentMountainNeighbors) do
			testNeighborRow = testNeighbor.x
			testNeighborCol = testNeighbor.y
			currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
			
			if(currentTerrainType == tt_impasse_trees_plains_forest) then
				terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_plains_clearing
			end
		end
	end
end

--draw extra lines for this team
print("creating " .. #extraPoints .. " extra points for this team")
for teamIndex = 1, numTeams do
	for extraPathIndex = 1, #extraPoints do
		if(#extraPoints > 0) then
			--pick a random extra point
			currentChosenPointIndex = math.ceil(GetRandomInRange(1, #extraPoints))
			currentChosenPoint = extraPoints[currentChosenPointIndex]
			currentChosenPointRow = currentChosenPoint[1]
			currentChosenPointCol = currentChosenPoint[2]
			
			print("random chosen point " .. currentChosenPointIndex .. " is at " .. currentChosenPointRow .. ", " .. currentChosenPointCol)
			--pick two players to draw towards
			
			--grab a random player from this team
			currentTeamPlayerIndex = math.ceil(worldGetRandom() * #teamMappingTable[teamIndex].players)
			aRow = teamMappingTable[teamIndex].players[currentTeamPlayerIndex].startRow
			aCol = teamMappingTable[teamIndex].players[currentTeamPlayerIndex].startCol
			
			pathPointsTable = {}
			pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(aRow, aCol, currentChosenPointRow, currentChosenPointCol, false, p, gridSize, terrainLayoutResult)
			
			--iterate through this line and set it's points, and the surrounding points, to clearing
			for firstLineIndex = 1, #pathPointsTable do
				row = pathPointsTable[firstLineIndex][1] 
				col = pathPointsTable[firstLineIndex][2] 
				print("current row / col is " .. row .. ", " .. col)
				if terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest then
					terrainLayoutResult[row][col].terrainType = tt_plains
				end
				
				--at each point, thicken the line
				currentNeighbors = GetNeighbors(row, col, terrainLayoutResult)
				
				--loop through neighbors of the current square to thicken clearing
				for testNeighborIndex, testNeighbor in ipairs(currentNeighbors) do
					testNeighborRow = testNeighbor.x
					testNeighborCol = testNeighbor.y
					currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
					
					if(currentTerrainType == tt_impasse_trees_plains_forest) then
					--	terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_plains_clearing
					end
				end
			end
			
			--grab a point of a player on a different team, if there is more than 1 team
			if(#teamMappingTable > 1) then
				randomTeamIndex = math.ceil(worldGetRandom() * #teamMappingTable)
				if(randomTeamIndex == teamIndex) then
					repeat 
						randomTeamIndex = math.ceil(worldGetRandom() * #teamMappingTable)
					until(randomTeamIndex ~= teamIndex)
				end
				
				randomPlayerIndex = math.ceil(worldGetRandom() * #teamMappingTable[randomTeamIndex].players)
				bRow = teamMappingTable[randomTeamIndex].players[randomPlayerIndex].startRow
				bCol = teamMappingTable[randomTeamIndex].players[randomPlayerIndex].startCol
				
				--do the path to this player
				pathPointsTable = {}
				pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(bRow, bCol, currentChosenPointRow, currentChosenPointCol, false, p, gridSize, terrainLayoutResult)
				
				--iterate through this line and set it's points, and the surrounding points, to clearing
				for firstLineIndex = 1, #pathPointsTable do
					row = pathPointsTable[firstLineIndex][1] 
					col = pathPointsTable[firstLineIndex][2] 
					print("current row / col is " .. row .. ", " .. col)
					if terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest then
						terrainLayoutResult[row][col].terrainType = tt_plains_clearing
					end
					
					--at each point, thicken the line
					currentNeighbors = GetNeighbors(row, col, terrainLayoutResult)
					
					--loop through neighbors of the current square to thicken clearing
					if(worldGetRandom() < 0.5) then
						clearingPlacement = true
					else
						clearingPlacement = false
					end
					for testNeighborIndex, testNeighbor in ipairs(currentNeighbors) do
						if(clearingPlacement == true) then
							testNeighborRow = testNeighbor.x
							testNeighborCol = testNeighbor.y
							currentTerrainType = terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType
							
							if(currentTerrainType == tt_impasse_trees_plains_forest) then
								terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType = tt_plains_clearing
							end
							
							clearingPlacement = false
						else
							clearingPlacement = true
						end
					end
				end
			end
			
			table.remove(extraPoints, currentChosenPointIndex)
		end
	end

end
--put forests in clearings that are too large

plainsForestChance = 0.85
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
	
		if(terrainLayoutResult[row][col].terrainType == tt_plains_clearing or (terrainLayoutResult[row][col].terrainType == tt_plains and (worldGetRandom() < plainsForestChance))) then
			
			currentClearingNeighbors = {}
			currentClearingNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			
			clearingNeighborTotal = 0
			for testNeighborIndex, testNeighbor in ipairs(currentClearingNeighbors) do
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				
				if(terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType == tt_plains_clearing or terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType == tt_plains or terrainLayoutResult[testNeighborRow][testNeighborCol].terrainType == tt_plains_smooth) then
					clearingNeighborTotal = clearingNeighborTotal + 1
				end
			end
			
			if(clearingNeighborTotal >= 7) then
				terrainLayoutResult[row][col].terrainType = tt_impasse_trees_plains_forest
			end
		end
	end
end


------------------------
--LAKES/POND
------------------------

--Teams are together. For this map, that means each team having a pond
--SET TO FALSE FOR DEFAULT
if (randomPositions == false) then 
	print("Forming lakes")
	
	for index = 1, numTeams do

		numPlayersInTeam = #teamMappingTable[index].players
		print("Team index is currently" .. index .. " numPlayersInTeam is " .. numPlayersInTeam)
		
		teamCoordTable = {}
		chosenPlayerLake = 1
		
		rowSum = 0
		colSum = 0
		--records all the player coordinates into a new table (easier management)
		print("Copying player coordinates into the teamCoordTable")
		for playerIndex = 1, numPlayersInTeam do
			tempRow = teamMappingTable[index].players[playerIndex].startRow
			tempCol = teamMappingTable[index].players[playerIndex].startCol
			
			rowSum = rowSum + tempRow
			colSum = colSum + tempCol
			teamCoord = {tempRow, tempCol}
			table.insert(teamCoordTable, teamCoord)	
		end
		print("teamCoordTable contains " .. #teamCoordTable .. " players")
		
		--get average position of team
		avgRow = Round((rowSum / numPlayersInTeam), 0)
		avgCol = Round((colSum / numPlayersInTeam), 0)

		--find closest edge square
		if(avgRow > (#terrainLayoutResult / 2)) then
			closeRow = (#terrainLayoutResult - avgRow)
		else
			closeRow = avgRow
		end
		
		if(avgCol > (#terrainLayoutResult / 2)) then
			closeCol = (#terrainLayoutResult - avgCol)
		else
			closeCol = avgCol
		end
		
		--if the row is closer to an edge, set the row to the close edge and save the column
		if(closeRow < closeCol) then
			if(avgRow > (#terrainLayoutResult / 2)) then
				chosenRow = #terrainLayoutResult
				chosenCol = avgCol
			else
				chosenRow = 1
				chosenCol = avgCol
			end
			--the chosen column is closer to an edge, set the col to the clsoe edge and save the row
		else
			if(avgCol > (#terrainLayoutResult / 2)) then
				chosenCol = #terrainLayoutResult
				chosenRow = avgRow
			else
				chosenCol = 1
				chosenRow = avgRow
			end
		end
		--grabs 20 neighbors and looks for plains and impasse forest tiles
		startRadius = math.ceil(#terrainLayoutResult / 4)
		startRing = {}
		startRing = GetAllSquaresInRadius(avgRow, avgCol, startRadius, terrainLayoutResult)
		eligibleLakeSquares = {}
		
		for startRingIndex, coord in ipairs(startRing) do
			row = coord[1]
			col = coord[2]
			
			if(row == 1 or col == 1 or row == #terrainLayoutResult or col == #terrainLayoutResult) then
				
				if (terrainLayoutResult[row][col].terrainType == tt_plains) or (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) or (terrainLayoutResult[row][col].terrainType == tt_plains_clearing or terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
					eligibleCoord = {row, col}
					table.insert(eligibleLakeSquares, eligibleCoord)
					print("coordinate added to eligibleLakeSquares" )
				end
			end
			
		end	
		
		print("number of tiles in eligibleLakeSquares is " .. #eligibleLakeSquares)
		
		--randomly selects an eligible tile to be the start of the lake
		--lakeStartIndex = math.ceil(GetRandomInRange(1, #eligibleLakeSquares))
		--lakeStartRow = eligibleLakeSquares[lakeStartIndex][1]
		--lakeStartCol = eligibleLakeSquares[lakeStartIndex][2]
		lakeStartRow = chosenRow
		lakeStartCol = chosenCol
		--draw lake
		--CreateLake(lakeStartRow, lakeStartCol, lakeSize)
		terrainLayoutResult[lakeStartRow][lakeStartCol].terrainType = tt_lake_shallow_starting_fish
		lakeNeighbors = GetNeighbors(lakeStartRow, lakeStartCol, terrainLayoutResult)
		for lakeIndex, lakeNeighbor in ipairs(lakeNeighbors) do
			row = lakeNeighbor.x
			col = lakeNeighbor.y
			
			if ((terrainLayoutResult[row][col].terrainType == tt_plains) or (terrainLayoutResult[row][col].terrainType == tt_plains_smooth) or (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) or (terrainLayoutResult[row][col].terrainType == tt_plains_clearing)) then
				terrainLayoutResult[row][col].terrainType = tt_lake_shallow_low
			end
			
			
		end
		
		--make a path to every player on this team's start location
		for playerIndex = 1, #teamMappingTable[index].players do
			
			tempRow = teamMappingTable[index].players[playerIndex].startRow
			tempCol = teamMappingTable[index].players[playerIndex].startCol 
			
			pathPointsTable = {}
			pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(lakeStartRow, lakeStartCol, tempRow, tempCol, false, p, gridSize, terrainLayoutResult)
			
			for firstLineIndex = 1, #pathPointsTable do
				row = pathPointsTable[firstLineIndex][1] 
				col = pathPointsTable[firstLineIndex][2] 
				print("current row / col of lake path is " .. row .. ", " .. col)
				if terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest then
					terrainLayoutResult[row][col].terrainType = tt_plains_clearing
				end
			end
			
		end
	end
else
	
	for index = 1, numTeams do

		numPlayersInTeam = #teamMappingTable[index].players
		print("Team index is currently" .. index .. " numPlayersInTeam is " .. numPlayersInTeam)
		
		teamCoordTable = {}
		chosenPlayerLake = 1
		
		rowSum = 0
		colSum = 0
		--records all the player coordinates into a new table (easier management)
		print("Copying player coordinates into the teamCoordTable")
		for playerIndex = 1, numPlayersInTeam do
			avgRow = teamMappingTable[index].players[playerIndex].startRow
			avgCol = teamMappingTable[index].players[playerIndex].startCol
			
			teamCoord = {avgRow, avgCol}
			table.insert(teamCoordTable, teamCoord)	
			

			--find closest edge square
			if(avgRow > (#terrainLayoutResult / 2)) then
				closeRow = (#terrainLayoutResult - avgRow)
			else
				closeRow = avgRow
			end
			
			if(avgCol > (#terrainLayoutResult / 2)) then
				closeCol = (#terrainLayoutResult - avgCol)
			else
				closeCol = avgCol
			end
			
			--if the row is closer to an edge, set the row to the close edge and save the column
			if(closeRow < closeCol) then
				if(avgRow > (#terrainLayoutResult / 2)) then
					chosenRow = #terrainLayoutResult
					chosenCol = avgCol
				else
					chosenRow = 1
					chosenCol = avgCol
				end
				--the chosen column is closer to an edge, set the col to the clsoe edge and save the row
			else
				if(avgCol > (#terrainLayoutResult / 2)) then
					chosenCol = #terrainLayoutResult
					chosenRow = avgRow
				else
					chosenCol = 1
					chosenRow = avgRow
				end
			end
			
			lakeStartRow = chosenRow
			lakeStartCol = chosenCol
			--draw lake
			terrainLayoutResult[lakeStartRow][lakeStartCol].terrainType = tt_lake_shallow_starting_fish
			lakeNeighbors = GetNeighbors(lakeStartRow, lakeStartCol, terrainLayoutResult)
			for lakeIndex, lakeNeighbor in ipairs(lakeNeighbors) do
				row = lakeNeighbor.x
				col = lakeNeighbor.y
				
				if ((terrainLayoutResult[row][col].terrainType == tt_plains) or (terrainLayoutResult[row][col].terrainType == tt_plains_smooth) or (terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) or (terrainLayoutResult[row][col].terrainType == tt_plains_clearing)) then
					terrainLayoutResult[row][col].terrainType = tt_lake_shallow_low
				end
				
				
			end
			
			pathPointsTable = {}
			pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(lakeStartRow, lakeStartCol, avgRow, avgCol, false, p, gridSize, terrainLayoutResult)
			
			for firstLineIndex = 1, #pathPointsTable do
				row = pathPointsTable[firstLineIndex][1] 
				col = pathPointsTable[firstLineIndex][2] 
				print("current row / col of lake path is " .. row .. ", " .. col)
				if terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest then
					terrainLayoutResult[row][col].terrainType = tt_plains_clearing
				end
			end
		end
		
	end
end
if(worldTerrainWidth <= 416) then --for micro maps
	ringSize = 1
	locationDistanceFromStarts = 6
	startingClearingRadius = 2
elseif(worldTerrainWidth <= 512) then --for tiny maps
	ringSize = 1
	locationDistanceFromStarts = 4
	startingClearingRadius = 0.5
elseif(worldTerrainWidth <= 640) then  --for small maps
	ringSize = 1
	locationDistanceFromStarts = 5
	startingClearingRadius = 2
elseif(worldTerrainWidth <= 768) then  --for medium maps
	ringSize = 1
	locationDistanceFromStarts = 6
	startingClearingRadius = 3
elseif(worldTerrainWidth <= 896) then  --for large maps
	ringSize = 1
	locationDistanceFromStarts = 7
	startingClearingRadius = 3
end


--grab player start locations
playerStartLocations = {}
clearingSquares = {}
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			newInfo = {}
			newInfo = {row, col}
			table.insert(playerStartLocations, newInfo)
			
		elseif(terrainLayoutResult[row][col].terrainType == tt_plains_clearing) then
			newInfo = {}
			newInfo = {row, col}
			table.insert(clearingSquares, newInfo)
		end
		
	end
end

--clear forests too close to the player starts
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
	
		if(terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
			
			smallestDistance = 10000
			--measure distance to all player starts
			for playerStartIndex = 1, #playerStartLocations do
			
				currentPlayerRow = playerStartLocations[playerStartIndex][1]
				currentPlayerCol = playerStartLocations[playerStartIndex][2]
				
				currentDistance = GetDistance(row, col, currentPlayerRow, currentPlayerCol, 3)
				
				if(currentDistance < smallestDistance) then
					smallestDistance = currentDistance
				end
				
			end
			
			if(smallestDistance <= startingClearingRadius) then
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
		end
	end
end

print("PLACING TRADE POST")
	
--find a clearing roughly in the centre and place a trade post

tradePostClearings = GetAllSquaresOfTypeInRingAroundSquare(rowMidPoint, colMidPoint, ringSize, ringSize, {tt_plains_clearing}, terrainLayoutResult)

tradePostRow = rowMidPoint
tradePostCol = rowMidPoint
print("number of trade post clearings is " .. #tradePostClearings)
if(#tradePostClearings > 0 and randomSacredSites == false and worldTerrainHeight >= 641) then
	
	--pick a random square to turn into a trade post
	randomIndex = math.ceil(worldGetRandom() * #tradePostClearings)
	tradePostRow = tradePostClearings[randomIndex][1]
	tradePostCol = tradePostClearings[randomIndex][2]
	print("trade post row: " .. tradePostRow .. ", trade post col: " .. tradePostCol)
	terrainLayoutResult[tradePostRow][tradePostCol].terrainType = tt_settlement_plains
	
	tradePostNeighbors = GetNeighbors(tradePostRow, tradePostCol, terrainLayoutResult)
	tradePostBlockers = 0
	for neighborIndex, tradePostNeighbor in ipairs(tradePostNeighbors) do
		row = tradePostNeighbor.x
		col = tradePostNeighbor.y
		
		if(terrainLayoutResult[row][col].terrainType ~= tt_plains_clearing) then
			tradePostBlockers = tradePostBlockers + 1
			
			if(tradePostBlockers >= 2) then
				terrainLayoutResult[row][col].terrainType = tt_plains_clearing
			end
		end
		
	end
else
	print("no space for trade post, making clearing")
	terrainLayoutResult[rowMidPoint][colMidPoint].terrainType = tt_settlement_plains
	tradePostNeighbors = GetNeighbors(rowMidPoint, colMidPoint, terrainLayoutResult)
	
	for neighborIndex, tradePostNeighbor in ipairs(tradePostNeighbors) do
		row = tradePostNeighbor.x
		col = tradePostNeighbor.y
		
		terrainLayoutResult[row][col].terrainType = tt_plains_clearing
		
	end
end

if(randomSacredSites == false) then
	
--find a spot on the centre line on each side to place a sacred site

	print("PLACING sacred site")
	--top sacred site
	quarterSize = math.ceil(rowMidPoint / 2)

	if(isVertical == false) then
		topSacredClearings = GetAllSquaresOfTypeInRingAroundSquare(rowMidPoint, quarterSize, ringSize, ringSize, {tt_plains_clearing}, terrainLayoutResult)
		bottomSacredClearings = GetAllSquaresOfTypeInRingAroundSquare(rowMidPoint, (quarterSize + rowMidPoint), ringSize, ringSize, {tt_plains_clearing}, terrainLayoutResult)
	else
		topSacredClearings = GetAllSquaresOfTypeInRingAroundSquare(quarterSize, rowMidPoint, ringSize, ringSize, {tt_plains_clearing}, terrainLayoutResult)
		bottomSacredClearings = GetAllSquaresOfTypeInRingAroundSquare((quarterSize + rowMidPoint), rowMidPoint, ringSize, ringSize, {tt_plains_clearing}, terrainLayoutResult)
	end
	--place top sacred site
	if(#topSacredClearings > 0) then
		
		--pick a random square to turn into a trade post
		randomIndex = math.ceil(worldGetRandom() * #topSacredClearings)
		randomRow = topSacredClearings[randomIndex][1]
		randomCol = topSacredClearings[randomIndex][2]
		
		terrainLayoutResult[randomRow][randomCol].terrainType = tt_holy_site
		
		sacredSiteNeighbors = GetNeighbors(randomRow, randomCol, terrainLayoutResult)
		
		for neighborIndex, sacredSiteNeighbor in ipairs(sacredSiteNeighbors) do
			row = sacredSiteNeighbor.x
			col = sacredSiteNeighbor.y
			
			if(terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains and worldTerrainWidth > 513) then
				terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth
			end
		end
		
	else

		if(isVertical == false) then
			terrainLayoutResult[rowMidPoint][quarterSize].terrainType = tt_holy_site
			sacredSiteNeighbors = GetNeighbors(rowMidPoint, quarterSize, terrainLayoutResult)
		else
			terrainLayoutResult[quarterSize][rowMidPoint].terrainType = tt_holy_site
			sacredSiteNeighbors = GetNeighbors(quarterSize, rowMidPoint, terrainLayoutResult)
		end
		for neighborIndex, sacredSiteNeighbor in ipairs(sacredSiteNeighbors) do
			row = sacredSiteNeighbor.x
			col = sacredSiteNeighbor.y
			
			if(terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains and worldTerrainWidth > 513) then
				terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth
			end
			
		end
		
		--draw a line towards the centre until another clearing is hit
		pathPointsTable = {}
		if(isVertical == false) then
			pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(rowMidPoint, quarterSize, tradePostRow, tradePostCol, false, p, gridSize, terrainLayoutResult)
		else
			pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(quarterSize, rowMidPoint, tradePostRow, tradePostCol, false, p, gridSize, terrainLayoutResult)
		end
		--iterate through this line and set it's points, and the surrounding points, to clearing
		for firstLineIndex = 1, #pathPointsTable do
			row = pathPointsTable[firstLineIndex][1] 
			col = pathPointsTable[firstLineIndex][2] 
			print("current row / col is " .. row .. ", " .. col)
			if terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest then
				terrainLayoutResult[row][col].terrainType = tt_plains_clearing
				
				--stop making the line if a clearing is reached
			elseif terrainLayoutResult[row][col].terrainType == tt_plains_clearing then
				break
			end
		end
		
	end

	--place bottom sacred site
	if(#bottomSacredClearings > 0) then
		
		--pick a random square to turn into a trade post
		randomIndex = math.ceil(worldGetRandom() * #bottomSacredClearings)
		randomRow = bottomSacredClearings[randomIndex][1]
		randomCol = bottomSacredClearings[randomIndex][2]
		
		terrainLayoutResult[randomRow][randomCol].terrainType = tt_holy_site
		
		sacredSiteNeighbors = GetNeighbors(randomRow, randomCol, terrainLayoutResult)
		
		for neighborIndex, sacredSiteNeighbor in ipairs(sacredSiteNeighbors) do
			row = sacredSiteNeighbor.x
			col = sacredSiteNeighbor.y
			
			if(terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains and worldTerrainWidth > 513) then
				terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth
			end
		end
	else

		if(isVertical == false) then
			terrainLayoutResult[rowMidPoint][quarterSize + rowMidPoint].terrainType = tt_holy_site
			sacredSiteNeighbors = GetNeighbors(rowMidPoint, (quarterSize + rowMidPoint), terrainLayoutResult)
		else
			terrainLayoutResult[quarterSize + rowMidPoint][rowMidPoint].terrainType = tt_holy_site
			sacredSiteNeighbors = GetNeighbors((quarterSize + rowMidPoint), rowMidPoint, terrainLayoutResult)
		end
		for neighborIndex, sacredSiteNeighbor in ipairs(sacredSiteNeighbors) do
			row = sacredSiteNeighbor.x
			col = sacredSiteNeighbor.y
			
			if(terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains and worldTerrainWidth > 513) then
				terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth
			end
			
		end
		
		--draw a line towards the centre until another clearing is hit
		pathPointsTable = {}
		if(isVertical == false) then
			pathPointsTable = DrawLineOfTerrainNoDiagonalReturn(rowMidPoint, (quarterSize + rowMidPoint), tradePostRow, tradePostCol, false, p, gridSize, terrainLayoutResult)
		else
			pathPointsTable = DrawLineOfTerrainNoDiagonalReturn((quarterSize + rowMidPoint), rowMidPoint, tradePostRow, tradePostCol, false, p, gridSize, terrainLayoutResult)
		end
		--iterate through this line and set it's points, and the surrounding points, to clearing
		for firstLineIndex = 1, #pathPointsTable do
			row = pathPointsTable[firstLineIndex][1] 
			col = pathPointsTable[firstLineIndex][2] 
			print("current row / col is " .. row .. ", " .. col)
			if terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest then
				terrainLayoutResult[row][col].terrainType = tt_plains_clearing
				
				--stop making the line if a clearing is reached
			elseif terrainLayoutResult[row][col].terrainType == tt_plains_clearing then
			break
		end
	end
	
end

--random sacred sites
else
	
	--grab player start locations
	playerStartLocations = {}
	clearingSquares = {}
	for row = 1, #terrainLayoutResult do
		for col = 1, #terrainLayoutResult do
			if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
				newInfo = {}
				newInfo = {row, col}
				table.insert(playerStartLocations, newInfo)
				
			elseif(terrainLayoutResult[row][col].terrainType == tt_plains_clearing) then
				newInfo = {}
				newInfo = {row, col}
				table.insert(clearingSquares, newInfo)
			end
			
		end
	end
	
	--remove clearing squares too close to starts
	for clearingIndex = #clearingSquares, 1, -1 do
		
		--find smallest distance from this clearing square to all player starts
		smallestDistance = 10000
		currentRow = clearingSquares[clearingIndex][1]
		currentCol = clearingSquares[clearingIndex][2]
		
		for startIndex = 1, #playerStartLocations do
			currentPlayerRow = playerStartLocations[startIndex][1]
			currentPlayerCol = playerStartLocations[startIndex][2]
			
			currentDistance = GetDistance(currentPlayerRow, currentPlayerCol, currentRow, currentCol, 3)
			if(currentDistance < smallestDistance) then
				smallestDistance = currentDistance
			end
		end
		
		if(smallestDistance < locationDistanceFromStarts) then
			table.remove(clearingSquares, clearingIndex)	
		end
	end
	
	--find clearing square that is furthest from all starts for first gold deposit
	firstSacredLocation = GetFurthestSquareFromSquares(clearingSquares, playerStartLocations)
	
	firstRow = firstSacredLocation[1]
	firstCol = firstSacredLocation[2]
	
	terrainLayoutResult[firstRow][firstCol].terrainType = tt_holy_site
		
	sacredSiteNeighbors = GetNeighbors(firstRow, firstCol, terrainLayoutResult)
	
	for neighborIndex, sacredSiteNeighbor in ipairs(sacredSiteNeighbors) do
		row = sacredSiteNeighbor.x
		col = sacredSiteNeighbor.y
		
		if(terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains and terrainLayoutResult[row][col].terrainType ~= playerStartTerrain and worldTerrainWidth > 513) then
			terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth
		end
	end
	
	
	--find clearing furthest from settlement and first sacred site for second gold deposit
	table.insert(playerStartLocations, firstSacredLocation)
	secondSacredLocation = GetFurthestSquareFromSquares(clearingSquares, playerStartLocations)
	secondRow = secondSacredLocation[1]
	secondCol = secondSacredLocation[2]
	
	terrainLayoutResult[secondRow][secondCol].terrainType = tt_holy_site
		
	sacredSiteNeighbors = GetNeighbors(secondRow, secondCol, terrainLayoutResult)
	
	for neighborIndex, sacredSiteNeighbor in ipairs(sacredSiteNeighbors) do
		row = sacredSiteNeighbor.x
		col = sacredSiteNeighbor.y
		
		if(terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains and terrainLayoutResult[row][col].terrainType ~= playerStartTerrain and worldTerrainWidth > 513) then
			terrainLayoutResult[row][col].terrainType = tt_trees_plains_stealth
		end
	end
	
end



--find large areas of nothing but trees and place swamps
swampTiles = {}
for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(terrainLayoutResult[row][col].terrainType == tt_impasse_trees_plains_forest) then
			currentNeighbors = GetAllSquaresInRadius(row, col, 2.3, terrainLayoutResult)
		--	currentNeighbors = Get20Neighbors(row, col, terrainLayoutResult)
			isInDenseWoods = true
			for neighborIndex, forestNeighbor in ipairs(currentNeighbors) do
				currentRow = forestNeighbor[1]
				currentCol = forestNeighbor[2]
				
				if(terrainLayoutResult[currentRow][currentCol].terrainType ~= tt_impasse_trees_plains_forest) then
					isInDenseWoods = false
				end
			end
			if(isInDenseWoods == true) then
				newInfo = {}
				newInfo = {row, col}
				table.insert(swampTiles, newInfo)
			end
			
		end
		
	end
end

if(#swampTiles > 0) then
	for swampIndex = 1, #swampTiles do
	
		currentRow = swampTiles[swampIndex][1]
		currentCol = swampTiles[swampIndex][2]
		
		terrainLayoutResult[currentRow][currentCol].terrainType = tt_swamp
	end
end
	

print("END OF BLACK FOREST LUA SCRIPT")
