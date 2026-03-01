-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

--create the course grid. This is the table that holds the terrain types that will be used to generate the map in a 2D grid
terrainLayoutResult = {}    -- set up initial table for coarse map grid

--NOTE: AoE4 MapGen is designed to generate square maps. The grid you will be working with will always need to have gridWidth = gridHeight
--]]
--set the number of players
playerStarts = worldPlayerCount


n = tt_none

--these are terrain types that define specific geographic features
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
p = tt_plains
t = tt_impasse_trees_plains
v = tt_valley

--bounty squares are used to populate an area of the map with extra resources
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains

--the following are markers used to determine player and settlement spawn points
playerStartTerrain = tt_player_start_classic_plains
s = tt_player_start_hills
sp = tt_settlement_plains
sh = tt_settlement_hills
seb = tt_settlement_hills_high_rolling


--set up resource pockets
nomadPocketResources1 = {}
nomadPocketResources2 = {}
nomadPocketResources3 = {}

--players will randomly get one set of these in nomad mode
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

-- setting up the map grid
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(25)

--this code block checks for if the players have selected the "Nomad" start conditions.
--This affects map generation due to needing additional viable resource starting points without a town centre to cluster things around.
--The following code checks data from the game setup menu and passes that information into this script for later use.
nomadStart = false
if (winConditionOptions.section_starting_conditions and winConditionOptions.section_starting_conditions.option_age_start) then
	nomadStart = (winConditionOptions.section_starting_conditions.option_age_start.enum_value == winConditionOptions.section_starting_conditions.option_age_start.enum_items.nomad_start)
	print("NOMAD START CONDITION IS: " ..winConditionOptions.section_starting_conditions.option_age_start.enum_value.." ("..tostring(nomadStart)..")")
else
	print("NOMAD START CONDITION IS NOT SET (FALSE)")
end

if(nomadStart) then
	playerStartTerrain = tt_player_start_nomad_plains -- nomad mode start
else
	playerStartTerrain = tt_player_start_classic_plains -- classic mode start	
end




--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, tt_none, terrainLayoutResult)

baseGridSize = 25
outerRadius = 3.5 / baseGridSize * gridSize
middleRadius = 2.5 / baseGridSize * gridSize
innerRadius = 1.25 / baseGridSize * gridSize
mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

startPositionsTable = {}

teamsList, playersPerTeam = SetUpTeams()


--do map specific stuff around here



if (worldTerrainHeight > 513) then
	startRadius = 2
else
	startRadius = 1
end


startLocationPositions = {}

teamMappingTable = CreateTeamMappingTable()
	
minPlayerDistance = 4
minTeamDistance = 8
edgeBuffer = 2


spawnBlockers = {}
table.insert(spawnBlockers, tt_mountains)

basicTerrain = {}
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_none)


terrainLayoutResult = PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, spawnBlockers, basicTerrain, playerStartTerrain, terrainLayoutResult)


--loop through and record the start locaiton positions
startLocationPositions = {}
--loop through and find all the start positions to add to the startLocationPositions table
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			table.insert(startLocationPositions, {row, col})
		end
	end
end



--loop through and fill with forests
for row = 1, gridSize do
	for col = 1, gridSize do
		if(terrainLayoutResult[row][col].terrainType == tt_none) then
			terrainLayoutResult[row][col].terrainType = tt_impasse_trees_plains
		end
	end
end


clearingExpansions = 1
--find average point of each team, grow a clearing from there

--grow clearing as a team for teams together
if(randomPositions == false) then
	for teamIndex = 1, #teamMappingTable do
		
		currentAverageRow = 0	
		currentAverageCol = 0
		for playerIndex = 1, #teamMappingTable[teamIndex].players do
			
			currentRow = teamMappingTable[teamIndex].players[playerIndex].startRow
			currentCol = teamMappingTable[teamIndex].players[playerIndex].startCol
			
			currentAverageRow = currentAverageRow + currentRow
			currentAverageCol = currentAverageCol + currentCol
			
		end
		
		currentAverageRow = Round((currentAverageRow / #teamMappingTable[teamIndex].players), 0)
		currentAverageCol = Round((currentAverageCol / #teamMappingTable[teamIndex].players), 0)
		
		print("team " .. teamIndex .. " average position is: " .. currentAverageRow .. ", " .. currentAverageCol)
		terrainGrowthChance = 0.75
		GrowRandomTerrainArea(currentAverageRow, currentAverageCol, terrainGrowthChance, clearingExpansions, {tt_impasse_trees_plains}, tt_plains_smooth, terrainLayoutResult)
	end
	
--grow each player's individual clearing
else

	for teamIndex = 1, #teamMappingTable do
		
		for playerIndex = 1, #teamMappingTable[teamIndex].players do
			
			currentRow = teamMappingTable[teamIndex].players[playerIndex].startRow
			currentCol = teamMappingTable[teamIndex].players[playerIndex].startCol
			
			terrainGrowthChance = 0.75
			GrowRandomTerrainArea(currentRow, currentCol, terrainGrowthChance, clearingExpansions, {tt_impasse_trees_plains}, tt_plains_smooth, terrainLayoutResult)
		end
	end
end

--CELL EXPANSION-------------------------------

--functions

--returns true if the passed in square exists in the passed in table
function containsSquare(tableToCheck, newRow, newCol)

	doesContainSquare = false
	
	for index, val in ipairs(tableToCheck) do
		if (val.x == newRow and val.y == newCol) then
			doesContainSquare = true
		end
	end
	
	return doesContainSquare
end

--checks a square to see if it exists in another team list already
--returns true if the square is in another team's area
function isInAnotherTeamArea(myTeam, teamGrid, row, col)
	
	inAnotherArea = false
	
	--check the provided position on the grid and check the team
	if(teamGrid[row][col].team ~= nil and teamGrid[row][col].team ~= myTeam) then
		inAnotherArea = true
	end
	
	return inAnotherArea
end


--this returns how many members are in the open list across all teams
function getOpenListMembersNum(openList)
	
	currentMembers = 0
	for teamIndex = 1, #openList do
		currentMembers = currentMembers + #openList[teamIndex]
	end
	
	return currentMembers
end

function GetAllSquaresInRingAroundSquareTeams(squareRow, squareColumn, ringRadius, ringWidth, terrainLayout)
	
	--print("GETTING ALL SQUARES IN RING AROUND SQUARE")
	
	coarseGridSize = (#terrainLayout)

	-- error checking
	if (coarseGridSize < 1) then
		print("ERROR: Invalid grid size. Grid must be at least one square. Aborting function.")
		return nil,nil
	end
	
	if (ringWidth > ringRadius) then
		print("ERROR: ring width is greater than radius. Setting width to radius.")
		ringWidth = ringRadius
	end

-- set ring in which to select square
	ringSquares = {}
	startRow = squareRow - ringRadius
	endRow = squareRow + ringRadius
	
	if (startRow < 1) then
		startRow = 1
	end
	
	if (endRow > coarseGridSize) then
		endRow = coarseGridSize
	end
	
	startColumn = squareColumn - ringRadius
	endColumn = squareColumn + ringRadius
	
	if (startColumn < 1) then
		startColumn = 1
	end
	
	if (endColumn > coarseGridSize) then
		endColumn = coarseGridSize
	end
	
	index = 1
	
	for iRow = startRow, endRow do
	
		for iCol = startColumn, endColumn do
			
			newData = {
				x = iRow,
				y = iCol, 
				terrainType = terrainLayout[iRow][iCol].terrainType,
				team = terrainLayout[iRow][iCol].team
				}
			if (iRow == startRow and iCol == startCol) then
--				print("Square at " ..iRow ..", " ..iCol .." is the start square.")
			elseif (iRow >= startRow and iRow < startRow + ringWidth) then
--				print("Adding Square at " ..iRow ..", " ..iCol)
				table.insert(ringSquares, index, newData)
				index = index + 1
			elseif (iRow <= endRow and iRow > endRow - ringWidth) then
--				print("Adding Square at " ..iRow ..", " ..iCol)
				table.insert(ringSquares, index, newData)
				index = index + 1
			elseif (iCol >= startColumn and iCol < startColumn + ringWidth) then
--				print("Adding Square at " ..iRow ..", " ..iCol)
				table.insert(ringSquares, index, newData)
				index = index + 1
			elseif (iCol <= endColumn and iCol > endColumn - ringWidth) then
--				print("Adding Square at " ..iRow ..", " ..iCol)
				table.insert(ringSquares, index, newData)
				index = index + 1
			else
	--			print("Square at " ..iRow ..", " ..iCol .." is not in ring.")
			end

		end
		
	end
	
	return ringSquares

end

--***********tree line width**************
if(#teamsList > 3) then
	treeLineWidth = 3
else
	treeLineWidth = 4
end
--****************************************



--create openList for each team containing all clearing squares

if(randomPositions == false) then
	print("setting up clearings for teams together")
	openTeamList = {}
	closedTeamList = {}
	teamGrid = DeepCopy(terrainLayoutResult)
	for teamIndex = 1, #teamsList do
		openTeamList[teamIndex] = {}
		closedTeamList[teamIndex] = {}
		print("creating openList for team " .. teamIndex)
		--grab this team's start position data
		teamRow = teamMappingTable[teamIndex].players[1].startRow
		teamCol = teamMappingTable[teamIndex].players[1].startCol
		
		firstEntry = {
			x = teamRow,
			y = teamCol,
			terrainType = terrainLayoutResult[row][col].terrainType,
			team = teamIndex
		}
		
		--base case, get initial info into the correct lists for this team and get the ball rolling
		
		--insert team information into the copy of the grid
		teamGrid[teamRow][teamCol].team = teamIndex
		
		--get initial team start location neighbors to start constructing the openList
		initialNeighbors = GetNeighbors(teamRow, teamCol, terrainLayoutResult)
		
		--make sure the neighbors are either clearing or a player start, then add them to the openList
		for index, neighbor in ipairs(initialNeighbors) do
			
			if(terrainLayoutResult[neighbor.x][neighbor.y].terrainType == tt_plains_smooth or terrainLayoutResult[neighbor.x][neighbor.y].terrainType == playerStartTerrain) then
				listEntry = {
					x = neighbor.x,
					y = neighbor.y,
					terrainType = terrainLayoutResult[neighbor.x][neighbor.y].terrainType,
					team = teamIndex
				}
				
				--set the team for the open square on the teamGrid
				table.insert(openTeamList[teamIndex], listEntry)
				teamGrid[neighbor.x][neighbor.y].team = teamIndex
			end
		end
		
		--put initial location in the closed list
		table.insert(closedTeamList[teamIndex], firstEntry)
		
		
		--loop until the openList is empty
		while(#openTeamList[teamIndex] > 0) do
			
			currentSquare = openTeamList[teamIndex][1]
			currentRow = currentSquare.x
			currentCol = currentSquare.y 
			
			--get neighbors of current openList member
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
			
			--look through all neighbors for clearing squares
			for index, neighbor in ipairs(currentNeighbors) do
				
				--check to see if the neighbor is either a clearing or player start
				if(terrainLayoutResult[neighbor.x][neighbor.y].terrainType == tt_plains_smooth or terrainLayoutResult[neighbor.x][neighbor.y].terrainType == playerStartTerrain) then
					
					--check to see if this clering square is already in the closed or open list
					if(containsSquare(closedTeamList[teamIndex], neighbor.x, neighbor.y) == false and containsSquare(openTeamList[teamIndex], neighbor.x, neighbor.y) == false and isInAnotherTeamArea(teamIndex, teamGrid, neighbor.x, neighbor.y) == false) then
						listEntry = {
							x = neighbor.x,
							y = neighbor.y,
							terrainType = terrainLayoutResult[neighbor.x][neighbor.y].terrainType,
							team = teamIndex
						}
						
						--set the team for the open square on the teamGrid
						print("inserting square at " .. neighbor.x .. ", " .. neighbor.y .. " into openList")
						table.insert(openTeamList[teamIndex], listEntry)
						teamGrid[neighbor.x][neighbor.y].team = teamIndex
					end
				end
			end
			
			--remove the current square from the open list and put it in the closed list
			table.remove(openTeamList[teamIndex], 1)
			table.insert(closedTeamList[teamIndex], currentSquare)
			
		end
		
	end

	--prune closedLists to ensure only live squares remain
	--a live square is a square with at least one direct forest neighbor

	--refresh openTeamList
	openTeamList = {}
	for teamIndex = 1, #teamsList do
		openTeamList[teamIndex] = {}
		
		--loop through closed list for each team until the close list is empty
		while(#closedTeamList[teamIndex] > 0) do
			
			currentSquare = closedTeamList[teamIndex][1]
			currentRow = currentSquare.x 
			currentCol = currentSquare.y 
			
			
			
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
			
			--create a tally of live neighbors
			currentForestNeighbors = 0
			
			--look through all neighbors for live squares to put back in the openList
			--a live square has at least one neighboring forest square
			for index, neighbor in ipairs(currentNeighbors) do
				
				if(terrainLayoutResult[neighbor.x][neighbor.y].terrainType == tt_impasse_trees_plains) then
					
					currentForestNeighbors = currentForestNeighbors + 1
					print("found a forest neighbor")
				end
				
			end
			
			print("the square at " .. currentRow .. ", " .. currentCol .. " has " .. currentForestNeighbors .. " current forest neighbors")
			
			--if there is at least one forest neighbor, this is a live square and should go into the openList, as it is an edge square of the area
			if(currentForestNeighbors > 0) then
				
				--now check to see if there is an opposing team square within range. If so, this square is dead
				currentRingSquares = GetAllSquaresInRingAroundSquareTeams(currentRow, currentCol, treeLineWidth, treeLineWidth, teamGrid)
				
				isInAnotherArea = false
				
				for index, ringSquare in ipairs(currentRingSquares) do
					
					if(isInAnotherTeamArea(teamIndex, teamGrid, ringSquare.x, ringSquare.y) == true) then
						isInAnotherArea = true
					end
				end
				
				--check to see if the check found a square within the radius that is in another team's area
				if(isInAnotherArea == false) then
					print("the square at " .. currentRow .. ", " .. currentCol .. " is a live square")
					table.insert(openTeamList[teamIndex], currentSquare)
				else
					print("the square at " .. currentRow .. ", " .. currentCol .. " is too close to another area, therefore is dead")
				end
			end
			
			--remove the current square from the closedList now that it has been pruned for being an edge square
			table.remove(closedTeamList[teamIndex], 1)
			
		end
	end

	--openLists should now only be valid edge squares viable for expansion

	--loop while there are elements in the openList across all teams
	currentTeam = 1

	while(getOpenListMembersNum(openTeamList) > 0) do
		--rotate through teams, pick a random element of openList
		
		--ensure there are still openList entries for this team
		if(#openTeamList[currentTeam] > 0) then
			
			currentTeamRandomElementIndex = math.ceil(worldGetRandom() * #openTeamList[currentTeam])
			print("chosen random element from this team's open list is " .. currentTeamRandomElementIndex .. " out of " .. #openTeamList[currentTeam])
			--get all neighbors of chosen member and randomly pick a forest square from valid neighbors
			currentSquare = openTeamList[currentTeam][currentTeamRandomElementIndex]
			currentRow = currentSquare.x 
			currentCol = currentSquare.y 
			
			print("current square from the open list: " .. currentRow .. ", " .. currentCol)
			
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
			
			--get only forest neighbors
			forestNeighbors = {}
			for index, neighbor in ipairs(currentNeighbors) do
				
				if(terrainLayoutResult[neighbor.x][neighbor.y].terrainType == tt_impasse_trees_plains) then
					if(containsSquare(openTeamList[currentTeam], neighbor.x, neighbor.y) == false) then
						table.insert(forestNeighbors, neighbor)
						print("found a forest neighbor that is not already in the open list for team " .. currentTeam .. " at " .. neighbor.x .. ", " .. neighbor.y)
					end
				end
			end
			
			
			if(#forestNeighbors > 0) then
				
				--choose a random forest neighbor, if any exist
				chosenForestNeighborIndex = math.ceil(worldGetRandom() * #forestNeighbors)
				print("chosen forest neighbor index is " .. chosenForestNeighborIndex)
				chosenForestSquare = forestNeighbors[chosenForestNeighborIndex]
				
				--set chosen neighbor as clearing. add the team info on team grid
				--	terrainLayoutResult[chosenForestSquare.row][chosenForestSquare.col].terrainType = tt_trees_plains_clearing
				--	teamGrid[chosenForestSquare.row][chosenForestSquare.col].terrainType = tt_trees_plains_clearing
				terrainLayoutResult[chosenForestSquare.x][chosenForestSquare.y].terrainType = tt_plains
				teamGrid[chosenForestSquare.x][chosenForestSquare.y].terrainType = tt_plains
				teamGrid[chosenForestSquare.x][chosenForestSquare.y].team = currentTeam
				
				
				--check if chosen forest square is live or dead
				currentRingSquares = GetAllSquaresInRingAroundSquareTeams(chosenForestSquare.x, chosenForestSquare.y, treeLineWidth, treeLineWidth, teamGrid)
				
				isInAnotherArea = false
				
				for index, ringSquare in ipairs(currentRingSquares) do
					
					if(isInAnotherTeamArea(currentTeam, teamGrid, ringSquare.x, ringSquare.y) == true) then
						print("this square is in another team's area!")
						isInAnotherArea = true
					end
				end
				
				--check to see if the check found a square within the radius that is in another team's area
				if(isInAnotherArea == false) then
					print("the formerly forest square at " .. chosenForestSquare.x .. ", " .. chosenForestSquare.y .. " is a live square")
					table.insert(openTeamList[currentTeam], chosenForestSquare)
				else
					print("the square at " .. currentRow .. ", " .. currentCol .. " is too close to another area, therefore is dead")
				end
			end
			
			--remove current square from the openList if it only had 1 forest neighbor
			if(#forestNeighbors <= 1) then
				table.remove(openTeamList[currentTeam], currentTeamRandomElementIndex)
			end
			
			totalOpenList = getOpenListMembersNum(openTeamList)
			print("members in all open lists is " .. totalOpenList)
		end
		--iterate through teams
		currentTeam = currentTeam + 1
		if(currentTeam > #teamsList) then
			currentTeam = 1
		end

	end
else
	--teams apart, so make each player in their own individual clearing ----------------------------------------
	print("setting up clearings for teams apart")
	openPlayerList = {}
	closedPlayerList = {}
	teamGrid = DeepCopy(terrainLayoutResult)
	for playerIndex = 1, #startLocationPositions do
		openPlayerList[playerIndex] = {}
		closedPlayerList[playerIndex] = {}
		print("creating openList for player " .. playerIndex)
		--grab this team's start position data
		playerRow = startLocationPositions[playerIndex][1]
		playerCol = startLocationPositions[playerIndex][2]
		
		firstEntry = {
			x = playerRow,
			y = playerCol,
			terrainType = terrainLayoutResult[row][col].terrainType,
			team = playerIndex
		}
		
		--base case, get initial info into the correct lists for this team and get the ball rolling
		
		--insert team information into the copy of the grid
		teamGrid[playerRow][playerCol].team = playerIndex
		
		--get initial team start location neighbors to start constructing the openList
		initialNeighbors = GetNeighbors(playerRow, playerCol, terrainLayoutResult)
		
		--make sure the neighbors are either clearing or a player start, then add them to the openList
		for index, neighbor in ipairs(initialNeighbors) do
			
			if(terrainLayoutResult[neighbor.x][neighbor.y].terrainType == tt_plains_smooth or terrainLayoutResult[neighbor.x][neighbor.y].terrainType == playerStartTerrain) then
				listEntry = {
					x = neighbor.x,
					y = neighbor.y,
					terrainType = terrainLayoutResult[neighbor.x][neighbor.y].terrainType,
					team = playerIndex
				}
				
				--set the team for the open square on the teamGrid
				table.insert(openPlayerList[playerIndex], listEntry)
				teamGrid[neighbor.x][neighbor.y].team = playerIndex
			end
		end
		
		--put initial location in the closed list
		table.insert(closedPlayerList[playerIndex], firstEntry)
		
		
		--loop until the openList is empty
		while(#openPlayerList[playerIndex] > 0) do
			
			currentSquare = openPlayerList[playerIndex][1]
			currentRow = currentSquare.x
			currentCol = currentSquare.y 
			
			--get neighbors of current openList member
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
			
			--look through all neighbors for clearing squares
			for index, neighbor in ipairs(currentNeighbors) do
				
				--check to see if the neighbor is either a clearing or player start
				if(terrainLayoutResult[neighbor.x][neighbor.y].terrainType == tt_plains_smooth or terrainLayoutResult[neighbor.x][neighbor.y].terrainType == playerStartTerrain) then
					
					--check to see if this clering square is already in the closed or open list
					if(containsSquare(closedPlayerList[playerIndex], neighbor.x, neighbor.y) == false and containsSquare(openPlayerList[playerIndex], neighbor.x, neighbor.y) == false and isInAnotherTeamArea(teamIndex, teamGrid, neighbor.x, neighbor.y) == false) then
						listEntry = {
							x = neighbor.x,
							y = neighbor.y,
							terrainType = terrainLayoutResult[neighbor.x][neighbor.y].terrainType,
							team = playerIndex
						}
						
						--set the team for the open square on the teamGrid
						print("inserting square at " .. neighbor.x .. ", " .. neighbor.y .. " into openList")
						table.insert(openPlayerList[playerIndex], listEntry)
						teamGrid[neighbor.x][neighbor.y].team = playerIndex
					end
				end
			end
			
			--remove the current square from the open list and put it in the closed list
			table.remove(openPlayerList[playerIndex], 1)
			table.insert(closedPlayerList[playerIndex], currentSquare)
			
		end
		
	end

	--prune closedLists to ensure only live squares remain
	--a live square is a square with at least one direct forest neighbor

	--refresh openPlayerList
	openPlayerList = {}
	for playerIndex = 1, #startLocationPositions do
		openPlayerList[playerIndex] = {}
		
		--loop through closed list for each team until the close list is empty
		while(#closedPlayerList[playerIndex] > 0) do
			
			currentSquare = closedPlayerList[playerIndex][1]
			currentRow = currentSquare.x 
			currentCol = currentSquare.y 
			
			
			
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
			
			--create a tally of live neighbors
			currentForestNeighbors = 0
			
			--look through all neighbors for live squares to put back in the openList
			--a live square has at least one neighboring forest square
			for index, neighbor in ipairs(currentNeighbors) do
				
				if(terrainLayoutResult[neighbor.x][neighbor.y].terrainType == tt_impasse_trees_plains) then
					
					currentForestNeighbors = currentForestNeighbors + 1
					print("found a forest neighbor")
				end
				
			end
			
			print("the square at " .. currentRow .. ", " .. currentCol .. " has " .. currentForestNeighbors .. " current forest neighbors")
			
			--if there is at least one forest neighbor, this is a live square and should go into the openList, as it is an edge square of the area
			if(currentForestNeighbors > 0) then
				
				--now check to see if there is an opposing team square within range. If so, this square is dead
				currentRingSquares = GetAllSquaresInRingAroundSquareTeams(currentRow, currentCol, treeLineWidth, treeLineWidth, teamGrid)
				
				isInAnotherArea = false
				
				for index, ringSquare in ipairs(currentRingSquares) do
					
					if(isInAnotherTeamArea(playerIndex, teamGrid, ringSquare.x, ringSquare.y) == true) then
						isInAnotherArea = true
					end
				end
				
				--check to see if the check found a square within the radius that is in another team's area
				if(isInAnotherArea == false) then
					print("the square at " .. currentRow .. ", " .. currentCol .. " is a live square")
					table.insert(openPlayerList[playerIndex], currentSquare)
				else
					print("the square at " .. currentRow .. ", " .. currentCol .. " is too close to another area, therefore is dead")
				end
			end
			
			--remove the current square from the closedList now that it has been pruned for being an edge square
			table.remove(closedPlayerList[playerIndex], 1)
			
		end
	end

	--openLists should now only be valid edge squares viable for expansion

	--loop while there are elements in the openList across all teams
	currentPlayer = 1

	while(getOpenListMembersNum(openPlayerList) > 0) do
		--rotate through teams, pick a random element of openList
		
		--ensure there are still openList entries for this team
		if(#openPlayerList[currentPlayer] > 0) then
			
			currentPlayerRandomElementIndex = math.ceil(worldGetRandom() * #openPlayerList[currentPlayer])
			print("chosen random element from this team's open list is " .. currentPlayerRandomElementIndex .. " out of " .. #openPlayerList[currentPlayer])
			--get all neighbors of chosen member and randomly pick a forest square from valid neighbors
			currentSquare = openPlayerList[currentPlayer][currentPlayerRandomElementIndex]
			currentRow = currentSquare.x 
			currentCol = currentSquare.y 
			
			print("current square from the open list: " .. currentRow .. ", " .. currentCol)
			
			currentNeighbors = GetNeighbors(currentRow, currentCol, terrainLayoutResult)
			
			--get only forest neighbors
			forestNeighbors = {}
			for index, neighbor in ipairs(currentNeighbors) do
				
				if(terrainLayoutResult[neighbor.x][neighbor.y].terrainType == tt_impasse_trees_plains) then
					if(containsSquare(openPlayerList[currentPlayer], neighbor.x, neighbor.y) == false) then
						table.insert(forestNeighbors, neighbor)
						print("found a forest neighbor that is not already in the open list for player " .. currentPlayer .. " at " .. neighbor.x .. ", " .. neighbor.y)
					end
				end
			end
			
			
			if(#forestNeighbors > 0) then
				
				--choose a random forest neighbor, if any exist
				chosenForestNeighborIndex = math.ceil(worldGetRandom() * #forestNeighbors)
				print("chosen forest neighbor index is " .. chosenForestNeighborIndex)
				chosenForestSquare = forestNeighbors[chosenForestNeighborIndex]
				
				--set chosen neighbor as clearing. add the team info on team grid
				--	terrainLayoutResult[chosenForestSquare.row][chosenForestSquare.col].terrainType = tt_trees_plains_clearing
				--	teamGrid[chosenForestSquare.row][chosenForestSquare.col].terrainType = tt_trees_plains_clearing
				terrainLayoutResult[chosenForestSquare.x][chosenForestSquare.y].terrainType = tt_plains
				teamGrid[chosenForestSquare.x][chosenForestSquare.y].terrainType = tt_plains
				teamGrid[chosenForestSquare.x][chosenForestSquare.y].team = currentPlayer
				
				
				--check if chosen forest square is live or dead
				currentRingSquares = GetAllSquaresInRingAroundSquareTeams(chosenForestSquare.x, chosenForestSquare.y, treeLineWidth, treeLineWidth, teamGrid)
				
				isInAnotherArea = false
				
				for index, ringSquare in ipairs(currentRingSquares) do
					
					if(isInAnotherTeamArea(currentPlayer, teamGrid, ringSquare.x, ringSquare.y) == true) then
						print("this square is in another team's area!")
						isInAnotherArea = true
					end
				end
				
				--check to see if the check found a square within the radius that is in another team's area
				if(isInAnotherArea == false) then
					print("the formerly forest square at " .. chosenForestSquare.x .. ", " .. chosenForestSquare.y .. " is a live square")
					table.insert(openPlayerList[currentPlayer], chosenForestSquare)
				else
					print("the square at " .. currentRow .. ", " .. currentCol .. " is too close to another area, therefore is dead")
				end
			end
			
			--remove current square from the openList if it only had 1 forest neighbor
			if(#forestNeighbors <= 1) then
				table.remove(openPlayerList[currentPlayer], currentPlayerRandomElementIndex)
			end
			
			totalOpenList = getOpenListMembersNum(openPlayerList)
			print("members in all open lists is " .. totalOpenList)
		end
		--iterate through teams
		currentPlayer = currentPlayer + 1
		if(currentPlayer > #startLocationPositions) then
			currentPlayer = 1
		end

	end
	
end

--loop through plains and add weighted terrain interest
--chance to spawn a mountain on the grid
mountainChance = 0.05

--loop through the map and distribute mountains
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--get chance to place mountains
		if(worldGetRandom() < mountainChance) then
			if(terrainLayoutResult[row][col].terrainType == tt_plains) then
				currentNeighbors = GetNeighbors(row, col, terrainLayoutResult)
				
				for index, neighbor in ipairs(currentNeighbors) do
					if(terrainLayoutResult[neighbor.x][neighbor.y].terrainType == tt_plains) then
						terrainLayoutResult[neighbor.x][neighbor.y].terrainType = tt_mountains
					end
				end
				terrainLayoutResult[row][col].terrainType = tt_mountains
			end
		end
	end
end

for startIndex = 1, #startLocationPositions do
	
	startNeighborMountains = GetAllSquaresOfTypeInRingAroundSquare(startLocationPositions[startIndex][1], startLocationPositions[startIndex][2], 4, 4, {tt_mountains}, terrainLayoutResult)
	
	if(#startNeighborMountains > 0) then
		for mountainIndex = 1, #startNeighborMountains do
			currentRow = startNeighborMountains[mountainIndex][1]
			currentCol = startNeighborMountains[mountainIndex][2]
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
			
		end
	end

end

terrainStyleWeightTable = {}
plainsWeight = 0.6
denseWoodsWeight = 0.2
stealthWoodsWeight = 0.35
plateauLowWeight = 0.3
plateauStandardWeight = 0.15
hillsLowRollingWeight = 0.2
hillsMedRollingWeight = 0.1

cumulativeWeightTable = {}
table.insert(terrainStyleWeightTable, {"plains", plainsWeight, tt_plains})
table.insert(terrainStyleWeightTable, {"dense woods", denseWoodsWeight, tt_impasse_trees_plains})
table.insert(terrainStyleWeightTable, {"stealth woods", stealthWoodsWeight, tt_trees_plains_stealth})
table.insert(terrainStyleWeightTable, {"plateau low", plateauLowWeight, tt_plateau_low})
table.insert(terrainStyleWeightTable, {"plateau standard", plateauStandardWeight, tt_plateau_standard})
table.insert(terrainStyleWeightTable, {"hills low rolling", hillsLowRollingWeight, tt_hills_low_rolling})
table.insert(terrainStyleWeightTable, {"hills med rolling", hillsMedRollingWeight, tt_hills_med_rolling})

--choose a style from the weighted table---------------------

--total up the table weight in order to correctly be able to get a weighted selection
totalMapStyleWeight = 0
for index, weightedElement in ipairs(terrainStyleWeightTable) do
	cumulativeWeightTable[index] = totalMapStyleWeight + weightedElement[2]
	totalMapStyleWeight = totalMapStyleWeight + weightedElement[2]
end

for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
		
		if(terrainLayoutResult[row][col].terrainType == tt_plains) then
			
			--make a weighted selection

			currentWeight = worldGetRandom() * totalMapStyleWeight
			currentSelection = 0
			
			--loop through however many times based on number of elements in the selection list
			for index = 1, #terrainStyleWeightTable do
				
				--loop through cumulative weights until we find the correct value range
				if(currentWeight < cumulativeWeightTable[index]) then
					currentSelection = index
					break
				end
			end
			
			terrainLayoutResult[row][col].terrainType = terrainStyleWeightTable[currentSelection][3]
			
		end
		
	end
end											
										







