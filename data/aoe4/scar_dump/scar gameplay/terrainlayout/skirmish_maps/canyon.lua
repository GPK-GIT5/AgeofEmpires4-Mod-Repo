-- Copyright 2024 Developed by Relic Entertainment
print("GENERATING CANYON...")

--------------------------------------------------
--TERRAIN TYPES
--------------------------------------------------
-- variables containing terrain types to be used in map
nullTerrain = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout

gentleHillTerrain = tt_hills_gentle_rolling_canyon
lowHillTerrain = tt_hills_low_rolling_canyon
mediumHillTerrain = tt_hills_med_rolling_canyon
mainPlateau = tt_plateau_medium_canyon
plainsTerrain = tt_plains_canyon
riverTerrain = tt_river_canyon
sacredTerrain = tt_holy_site_plateau_medium_canyon
settlementTerrain = tt_hills_settlement_med_rolling_canyon

playerStartTerrain = tt_player_start_plateau_medium_canyon

--------------------------------------------------
--TUNABLES
--------------------------------------------------

-- debug
printDebugInfo = true -- set to true to see more debug info sent to the lua log file in map gen debug

-- grid setup
squareSize = 25

-- player start variables
--baseMapSize = 640 -- baseline map size to scale map features
baseMapSize = 416 -- baseline map size to scale map features
startsEdgeBuffer = 1 -- how far from the edge of the maps start positions must be placed

-- river variables
turnChance = 0.5 -- chance the river will turn (bigger the number the greater the chance of turning)
--turnThreshold = 4 -- the number the "just turned" variable gets set to after a turn. This number gets decremented as each sqaure of river gets placed. The higher the number the fewer times the river turns.
turnThreshold = 5 -- the number the "just turned" variable gets set to after a turn. This number gets decremented as each sqaure of river gets placed. The higher the number the fewer times the river turns.

-- number of fords
maxFords = 4
minFords = 3

-- establish the distance apart fords can be
--minFordDistance = 2 -- how far fords must be from other fords
--minPlayerDistance = 2 -- how far fords must be from players
minFordDistance = 4 -- how far fords must be from other fords
minPlayerDistance = 3 -- how far fords must be from players

--------------------------------------------------
--FUNCTIONS
--------------------------------------------------
--- FORDS FAR ENOUGH
 -- checks to ensure fords are not placed too close to either players or other fords (checking only the row values)
 -- fordRow is the row for the potential ford placement
 -- placedPositions is a table holding the positions of the already placed fords or player starts
 -- minDistance is the minimim number of coarse grid squares the fords must be apart from either other fords or players
function FordsFarEnough(fordRow, placedPositions, minDistance)
	local farEnough = false
	
	for index = 1, #placedPositions do		
		local checkRow = placedPositions[index][1]
		local checkCol = placedPositions[index][2]
		
		-- check to ensure the placed position is one of the original start positions or a ford, and not an extra position created for large team sizes
		if(terrainLayoutResult[checkRow][checkCol + 1].terrainType == riverTerrain or terrainLayoutResult[checkRow][checkCol - 1].terrainType == riverTerrain 
				or terrainLayoutResult[checkRow][checkCol].terrainType == riverTerrain) then			
			-- check the distance for a valid ford or start position
			if(fordRow <= checkRow - minDistance or fordRow >= checkRow + minDistance) then
				farEnough = true
			else
				return false
			end		
		end
	end

	return farEnough
end

--- GET RANDOM PLAYER POSITION
 -- returns the index of the selected position after checking a table of indexes containing already selected indexes
 -- startPositions is a table holding the potential start positions to choose from
 -- usedPositionIndexes is a table holding the indexes of positions that have already been placed
function GetRandomPlayerPosition(startPositions, usedPositionIndexes)
	local selectedIndex = 0
	local selectionMade = false
	
	while(selectionMade == false) do
		selectedIndex = GetRandomIndex(startPositions)
		if(tableContainsAny(usedPositionIndexes, selectedIndex) == false)then
			selectionMade = true
		end
	end
	
	return selectedIndex
end

--- CREATE NEW PLAYER LOCATIONS
 -- creates start positions behind allies when there are more than 4 players on a team (as we try to keep teams across the canyon from each other). Only gets used if teamsTogether is true
 -- numLocations is the number of start positions that must be created (it will be the number of players on the team that remain to be placed)
 -- placedStartPositions is the table containing the already placed start locations
 -- team is the table holding the player info
 -- placeLeft is a bool to determine if hte new positions are to be created on the left side of the canyon (true) or the right side (false)
 -- mapSize is the size of the coarse grid
function CreateNewPlayerLocations(numLocations, placedStartPositions, team, placeLeft, mapSize)
	local newStartPositions = DeepCopy(placedStartPositions)
	
	local teamID = team.teamID
	local placedPlayers = #team.players - numLocations -- the number of players already placed
	local startIndex = placedPlayers + 1 -- the starting index for the players on the team left to place
	local indexRange = placedPlayers / numLocations -- used to calculate an average row position for extra players (the index range of player positions to average)
	
	if (numLocations == 3) then indexRange = 2 end -- for a team of 7 the last player is placed behind the first 2 players this function will place
	
	-- get the teammate positions only
	local teammatePositions = {}
	for pIndex = 1, #placedStartPositions do
		if(placedStartPositions[pIndex].teamID == team.teamID) then
			table.insert(teammatePositions, placedStartPositions[pIndex])
		end
	end

	table.sort(teammatePositions, function(a,b) return a.startRow < b.startRow end) -- sort the table from smallest row to highest
	
	--generate the new positions
	local tempPositions = {} -- holds positions of the players placed in this function in case an extra player needs placement behind them
	local currentIndex = 1
	local currentIndexRange = indexRange
	
	local placementRow = 0
	local placementCol = 0
	
	for index = 1, numLocations do
		if (index < 3) then -- place the first players by taking an average row position from teammates and setting the new start back from that
			
			local rowTotal = 0
			local colTotal = 0
			
			--place the first extra player
			for tIndex = currentIndex, currentIndexRange do
				rowTotal = rowTotal + teammatePositions[tIndex].startRow
				colTotal = colTotal + teammatePositions[tIndex].startCol
			end
			
			placementRow = Round(rowTotal / indexRange, 0)
			placementCol = Round(colTotal / indexRange, 0)
			if(placeLeft == true) then
				placementCol = placementCol - 3
			else
				placementCol = placementCol + 3
			end
			print("Placing Player ID: " ..team.players[index + placedPlayers].playerID - 1)
			table.insert(newStartPositions, { playerID = team.players[index + placedPlayers].playerID - 1, startCol = placementCol, 
					startRow = placementRow, startIndex = #newStartPositions + 1, teamID = team.teamID })
			
			currentIndex = indexRange + 1
			currentIndexRange = currentIndexRange + indexRange
			
		else -- set the final player back from the 2 we just placed near the middle of the map edge
			placementRow = math.ceil(mapSize / 2)
			if(placeLeft == true) then
				placementCol = placementCol - 2
			else
				placementCol = placementCol + 2
			end
			print("Placing Player ID: " ..team.players[index + placedPlayers].playerID - 1)
			table.insert(newStartPositions, { playerID = team.players[index + placedPlayers].playerID - 1, startCol = placementCol, 
					startRow = placementRow, startIndex = #newStartPositions + 1, teamID = team.teamID })
		end
	end
		
	return newStartPositions
end

--- SET MIRRORED STARTS TEAMS TOGETHER
 -- sets players across from each other across the canyon. NOTE: Use only for 2, or fewer, teams and "teams together" set to true. Returns a table with the placed player data
 -- startLocations is a table holding the potential locations to place players
 -- teamMap is the table containing all the team data (teams, player count, players etc.
 -- mapSize is the coarse grid size
function SetMirroredStartsTeamsTogether(startLocations, teamMap, mapSize)
	local startPositions = {} -- table holding the start positions to be returned
	
	-- separate the starts (index 1-4 on left, 4-8 on right)
	local leftStarts = {}
	local rightStarts = {}
	--local remainingLeftStarts = 4
	--local remainingRightStarts = 4
	
	for index = 1, 4 do
		table.insert(leftStarts, startLocations[index]) -- first 4 starts on left
	end
	
	for index = 5, 8 do
		table.insert(rightStarts, startLocations[index]) -- last 4 starts on right
	end
	
	local placedStartsLeft = {} -- table holds the indexes of the open start positions that have been placed
	local placedStartsRight = {} -- table holds the indexes of the open start positions that have been placed
	
	local remainingPlayersLeft = #teamMap[1].players
	local playerCountLeft = 0 -- variable to hold remaining players
	
	if remainingPlayersLeft > 4 then
		playerCountLeft = 4
	else
		playerCountLeft = remainingPlayersLeft
	end
	
	-- TEAM 1
	-- place the first team	
	for pIndex = 1, playerCountLeft do		
		local positionIndex = GetRandomPlayerPosition(leftStarts, placedStartsLeft) -- randomly choose a start location
		table.insert(placedStartsLeft, positionIndex) -- add location to the list of placed locations to remove it from consideration
		table.insert(startPositions, {playerID = teamMap[1].players[pIndex].playerID - 1, startCol = leftStarts[positionIndex].startCol, 
				startRow = leftStarts[positionIndex].startRow, startIndex = positionIndex, teamID = teamMap[1].teamID})
		remainingPlayersLeft = remainingPlayersLeft - 1
	end
	
	if(remainingPlayersLeft > 0) then -- create new start positions for any leftover players from teams larger than 4
		startPositions = CreateNewPlayerLocations(remainingPlayersLeft, startPositions, teamMap[1], false, mapSize)
	end
	
	-- TEAM 2
	-- place the second team (if it exists) as mirrored starts
	if(#teamMap > 1) then -- make sure we have a second team
		local remainingPlayersRight = #teamMap[2].players
		local playerCountRight = 0 -- variable to hold remaining players
		
		if remainingPlayersRight > 4 then
			playerCountRight = 4
		else
			playerCountRight = remainingPlayersRight
		end
		
		if (#placedStartsLeft >= playerCountRight) then -- place all of the second team
			for pIndex = 1, playerCountRight do
				local positionIndex = placedStartsLeft[pIndex]
				table.insert(placedStartsRight, positionIndex) -- add location to the list of placed locations to remove it from consideration
				table.insert(startPositions, {playerID = teamMap[2].players[pIndex].playerID -1, startCol = rightStarts[positionIndex].startCol, 
						startRow = rightStarts[positionIndex].startRow, startIndex = positionIndex, teamID = teamMap[2].teamID})
				remainingPlayersRight = remainingPlayersRight - 1
			end		
		else -- mirror all the team one starts then place remaining team 2 randomly
			for pIndex = 1, #placedStartsLeft do -- cycle through the placed starts on the left and mirror them
				local positionIndex = placedStartsLeft[pIndex]
				table.insert(placedStartsRight, positionIndex) -- add location to the list of placed locations to remove it from consideration
				table.insert(startPositions, {playerID = teamMap[2].players[pIndex].playerID - 1, startCol = rightStarts[positionIndex].startCol, 
						startRow = rightStarts[positionIndex].startRow, startIndex = positionIndex, teamID = teamMap[2].teamID})
				remainingPlayersRight = remainingPlayersRight - 1				
			end
			-- check to see if we still have room on the right side for more players
			if (remainingPlayersRight > 0 and #placedStartsRight < 4) then 
				local startingIndex = #placedStartsRight + 1  -- randomly place players on the remaining initial start locations
				for pIndex = startingIndex, #rightStarts do -- loop through the players that have not been placed yet (no more than 4)
					local positionIndex = GetRandomPlayerPosition(rightStarts, placedStartsRight) -- randomly choose a start location
					table.insert(placedStartsRight, positionIndex) -- add location to the list of placed locations to remove it from consideration
					table.insert(startPositions, {playerID = teamMap[2].players[pIndex].playerID - 1, startCol = rightStarts[positionIndex].startCol, 
						startRow = rightStarts[positionIndex].startRow, startIndex = positionIndex, teamID = teamMap[2].teamID})
					remainingPlayersRight = remainingPlayersRight - 1
					if(remainingPlayersRight < 1) then break end
				end
			end
		end
		
		if(remainingPlayersRight > 0) then -- create new start positions for any leftover players from teams larger than 4
			startPositions = CreateNewPlayerLocations(remainingPlayersRight, startPositions, teamMap[2], false, mapSize)
		end

	end
	
	return startPositions
end

--- SET PLAYER STARTS TEAMS TOGETHER
 -- sets up player starts when there are more than 2 teams and returns a table with the placed player positions and data
 -- startLocations is a table holding the potential locations to place players
 -- teamMap is the table containing all the team data (teams, player count, players etc.
 -- mapSize is the coarse grid size
function SetPlayerStartsTeamsTogether(startLocations, teamMap, mapSize)
	local startPositions = {} -- table holding the star positions to be returned
	local tempTeamMap = DeepCopy(teamMap) -- use a temp team map to set up the starts
	local remainingStartsLeft = 4
	local remainingStartsRight = 4
	
	-- separate the starts (index 1-4 on left, 4-8 on right)
	local leftStarts = {}
	local rightStarts = {}

	for index = 1, 4 do
		table.insert(leftStarts, startLocations[index]) -- first 4 starts on left
	end
	
	for index = 5, 8 do
		table.insert(rightStarts, startLocations[index]) -- last 4 starts on right
	end
	
	local placedStartsLeft = {} -- table holds the indexes of the open start positions that have been placed
	local placedStartsRight = {} -- table holds the indexes of the open start positions that have been placed
	local currentStartIndexLeft = 1
	local currentStartIndexRight = 1
	
	-- sort the teams by team size largest to smallest
	table.sort(tempTeamMap, function(a,b) return a.playerCount > b.playerCount end)

	-- start on the left side with the largest team
	for tIndex = 1, #tempTeamMap do		
		if(tIndex == 1) then -- place the first team on the LEFT
			local remainingPlayersLeft = #tempTeamMap[tIndex].players
			
			local remainingPlayersLeft = #tempTeamMap[1].players
			local playerCountLeft = 0 -- variable to hold remaining players
			
			if remainingPlayersLeft > 4 then
				playerCountLeft = 4
			else
				playerCountLeft = remainingPlayersLeft
			end
			
			for pIndex = 1, playerCountLeft do		
				table.insert(placedStartsLeft, currentStartIndexLeft) -- add location to the list of placed locations to remove it from consideration
				table.insert(startPositions, {playerID = tempTeamMap[1].players[pIndex].playerID - 1, startCol = leftStarts[currentStartIndexLeft].startCol, 
					startRow = leftStarts[currentStartIndexLeft].startRow, startIndex = currentStartIndexLeft, teamID = tempTeamMap[1].teamID})
				remainingPlayersLeft = remainingPlayersLeft - 1
				remainingStartsLeft = remainingStartsLeft - 1
				currentStartIndexLeft = currentStartIndexLeft + 1
			end
			
			if(remainingPlayersLeft > 0) then -- create new start positions for any leftover players from teams larger than 4
				startPositions = CreateNewPlayerLocations(remainingPlayersLeft, startPositions, tempTeamMap[1], true, mapSize)
				remainingStartsLeft = 0
			end
			
		elseif(tIndex == 2) then -- place the next team on the RIGHT
			local remainingPlayersRight = #tempTeamMap[tIndex].players
			local playerCountRight = tempTeamMap[2].playerCount -- variable to hold remaining players
			
			if(remainingPlayersRight > 2) then -- place this team on the right, but with expanded start positions (we know this team has to have 3 players)
				for pIndex = 1, playerCountRight - 1 do -- only place the first 2 players					
					table.insert(placedStartsRight, currentStartIndexRight) -- add location to the list of placed locations to remove it from consideration
					table.insert(startPositions, {playerID = tempTeamMap[2].players[pIndex].playerID - 1, startCol = rightStarts[currentStartIndexRight].startCol, 
						startRow = rightStarts[currentStartIndexRight].startRow, startIndex = currentStartIndexRight, teamID = tempTeamMap[2].teamID})
					remainingPlayersRight = remainingPlayersRight - 1
					remainingStartsRight = remainingStartsRight - 1
					currentStartIndexRight = currentStartIndexRight + 1
				end
				
				if(remainingPlayersRight > 0) then -- create new start positions for any leftover players
					startPositions = CreateNewPlayerLocations(remainingPlayersRight, startPositions, tempTeamMap[2], false, mapSize)
				end
				
			else
				for pIndex = 1, playerCountRight do
					table.insert(placedStartsRight, currentStartIndexRight) -- add location to the list of placed locations to remove it from consideration
					table.insert(startPositions, {playerID = tempTeamMap[2].players[pIndex].playerID - 1, startCol = rightStarts[currentStartIndexRight].startCol, 
						startRow = rightStarts[currentStartIndexRight].startRow, startIndex = currentStartIndexRight, teamID = tempTeamMap[2].teamID})
					remainingPlayersRight = remainingPlayersRight - 1
					remainingStartsRight = remainingStartsRight - 1	
					currentStartIndexRight = currentStartIndexRight + 1
				end
			end
			
		else
			-- place teams left or right based on the number of starts
			local remainingPlayers = #tempTeamMap[tIndex].players
			
			if(remainingStartsLeft >= remainingPlayers) then
				-- place players on the LEFT side
				local playerCountLeft = remainingPlayers -- variable to hold remaining players
				
				for pIndex = 1, playerCountLeft do		
					table.insert(placedStartsLeft, currentStartIndexLeft) -- add location to the list of placed locations to remove it from consideration
					table.insert(startPositions, {playerID = tempTeamMap[tIndex].players[pIndex].playerID - 1, startCol = leftStarts[currentStartIndexLeft].startCol, 
						startRow = leftStarts[currentStartIndexLeft].startRow, startIndex = currentStartIndexLeft, teamID = tempTeamMap[tIndex].teamID})
					remainingPlayers = remainingPlayers - 1
					remainingStartsLeft = remainingStartsLeft - 1
					currentStartIndexLeft = currentStartIndexLeft + 1
				end
					
			else
				-- place players on the RIGHT side
				local playerCountRight = remainingPlayers -- variable to hold remaining players
				
				for pIndex = 1, playerCountRight do
					table.insert(placedStartsRight, currentStartIndexRight) -- add location to the list of placed locations to remove it from consideration
					table.insert(startPositions, {playerID = tempTeamMap[tIndex].players[pIndex].playerID - 1, startCol = rightStarts[currentStartIndexRight].startCol, 
						startRow = rightStarts[currentStartIndexRight].startRow, startIndex = currentStartIndexRight, teamID = tempTeamMap[tIndex].teamID})
					remainingPlayers = remainingPlayers - 1
					remainingStartsRight = remainingStartsRight - 1	
					currentStartIndexRight = currentStartIndexRight + 1
				end
			end
		end
	end
	
	return startPositions
end

--- SET PLAYER STARTS TEAMS APART
 -- places player starts randomly when teams together is not selected. Returns a table with start position data.
 -- startLocations is a table holding the potential locations to place players
 -- teamMap is the table containing all the team data (teams, player count, players etc.
function SetPlayerStartsTeamsApart(startLocations, teamMap)
	local startPositions = {} -- table holding the star positions to be returned
	
	-- separate the starts (index 1-4 on left, 4-8 on right)
	local leftStarts = {}
	local rightStarts = {}

	for index = 1, 4 do
		table.insert(leftStarts, startLocations[index]) -- first 4 starts on left
	end
	
	for index = 5, 8 do
		table.insert(rightStarts, startLocations[index]) -- last 4 starts on right
	end
	
	local placedStartsLeft = {} -- table holds the indexes of the open start positions that have been placed
	local placedStartsRight = {} -- table holds the indexes of the open start positions that have been placed
	
	local playerNumber = 0 -- a running tab of the players placed, used to alternate sides of map
	local currentLeftIndex = 0
			
	for tIndex = 1, #teamMap do		
		for pIndex = 1, #teamMap[tIndex].players do
			print("!!! Player Number: " ..playerNumber)
			if(playerNumber % 2 == 0) then
				-- place this player on the left
				print("Placing on the left.")
				local positionIndex = GetRandomPlayerPosition(leftStarts, placedStartsLeft)
				currentLeftIndex = positionIndex
				table.insert(startPositions, {playerID = teamMap[tIndex].players[pIndex].playerID - 1, startCol = leftStarts[positionIndex].startCol, 
					startRow = leftStarts[positionIndex].startRow, startIndex = positionIndex, teamID = teamMap[tIndex].teamID})
				table.insert(placedStartsLeft, positionIndex)
				playerNumber = playerNumber + 1				
			else
				-- place this player on the right
				print("Placing on the right.")
				local positionIndex = 0 -- set up the index variable
				if(currentLeftIndex <= 0) then -- ensure there is a player placed on the left (0 means no)
					positionIndex = GetRandomPlayerPosition(leftStarts, placedStartsRight) -- place randomly if there's no player on the left
				else
					positionIndex = currentLeftIndex -- mirror the player on the left
				end
				table.insert(startPositions, {playerID = teamMap[tIndex].players[pIndex].playerID - 1, startCol = rightStarts[positionIndex].startCol, 
					startRow = rightStarts[positionIndex].startRow, startIndex = positionIndex, teamID = teamMap[tIndex].teamID})
				table.insert(placedStartsRight, positionIndex)
				playerNumber = playerNumber + 1				
			end				
		end
	end				
	
	return startPositions
end

--- GET PLAYER STARTS CENTER
 -- calculates a square that is the centroid of player start positions on the left and right side of the canyon
 -- startPositions is the starting locations table for all players
 -- mapMid is the mid point of the map used for determining if a player is to the left or right of the canyon
function GetPlayerStartsCenter(startPositions, mapMid, riverTT)
	local leftStarts = {}
	local rightStarts = {}
	for index = 1, #startPositions do
		-- check if player start is to the left or right of the river (player starts right in the middle check if the terrain immediatly to the right is a river)
		if(startPositions[index].startCol < mapMid or terrainLayoutResult[startPositions[index].startRow][startPositions[index].startCol + 1].terrainType == riverTT) then
			table.insert(leftStarts, {startPositions[index].startRow, startPositions[index].startCol})
		else
			table.insert(rightStarts, {startPositions[index].startRow, startPositions[index].startCol})
		end
	end
	
	local leftCenter = {}
	local rightCenter = {}
	
	local rowSum = 0
	local colSum = 0
	
	for index = 1, #leftStarts do
		rowSum = rowSum + leftStarts[index][1]
		colSum = colSum + leftStarts[index][2]				
	end
	
	local rowCenter = Round(rowSum/#leftStarts, 0)
	local colCenter = Round(colSum/#leftStarts, 0)
	
	table.insert(leftCenter, {rowCenter, colCenter})
	
	-- reset the sum variables to calcualte the right side
	rowSum = 0
	colSum = 0
	
	for index = 1, #rightStarts do
		rowSum = rowSum + rightStarts[index][1]
		colSum = colSum + rightStarts[index][2]				
	end
	
	rowCenter = Round(rowSum/#rightStarts, 0)
	colCenter = Round(colSum/#rightStarts, 0)
	
	table.insert(rightCenter, {rowCenter, colCenter})
	
	return leftCenter, rightCenter
		
end


--------------------------------------------------
--MAIN MAP SCRIPT
--------------------------------------------------

-- MAP/GAME SET UP ------------------------------------------------------------------------
terrainLayoutResult = {}    -- set up initial table for coarse map grid. Must be named this

--gridHeight, gridWidth, gridSize = SetCoarseGrid() -- set up the map grid using function found in map_setup lua in the library folder
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(squareSize)
mapMidPoint = math.ceil(gridSize / 2)

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, nullTerrain, terrainLayoutResult) -- set up the layout table using the function found in map_setup in hte library folder

-- generate main river that runs through the middle of the map
riverStartCol = Round(gridWidth / 2, 0)
--turnChance = 0.5
row = 0
col = riverStartCol
riverPoints = {}
justTurned = 0

riverIndex = 1
-- create while loop that checks to ensure the river course doesn't double back on itself too much so that there is lots of room for fords and player starts. River should have enough straight sections for these placements
while row < gridHeight do
	if (worldGetRandom() < turnChance and row > 1 and justTurned < 1) then -- only turn if random value is below the turn chance, we are not on the first row and we have not turned recently
		
		-- determine turn based on what side of the center of the map we are to ensure the river goes down the middle
		if (col > riverStartCol) then
			col = col - 1
		elseif (col < riverStartCol) then
			col = col + 1
		else
			-- determine turn direction randomly
			if (worldGetRandom() < 0.5) then
				col = col + 1
			else
				col = col - 1
			end
			
		end
		terrainLayoutResult[row][col].terrainType = riverTerrain
		table.insert(riverPoints, riverIndex, {row, col})
		justTurned = turnThreshold -- set just turned to ensure the river goes straight for the number of squares the variable is set to (see Tunables section)
	else
		row = row + 1
		terrainLayoutResult[row][col].terrainType = riverTerrain
		table.insert(riverPoints, riverIndex, {row, col})
		justTurned = justTurned - 1 -- reduce the just turned amount
	end

	riverIndex = riverIndex + 1
end

-- place main canyon and log these squares for potential player starts
potentialStartsRight = {} -- table to hold player start locations on the right side of the map
potentialStartsLeft = {} -- table to hold player start locations on hte left side of the map
lIndex = 1
rIndex = 1

--place cliff terrain along the river
for index = 1, #riverPoints do
	row = riverPoints[index][1]
	col = riverPoints[index][2]
	
	-- right side
	if (terrainLayoutResult[row][col + 1].terrainType == nullTerrain) then
		terrainLayoutResult[row][col + 1].terrainType = mainPlateau
		table.insert(potentialStartsRight, lIndex, {row, col + 1})
		lIndex = lIndex + 1
	end
	
	-- left side
	if (terrainLayoutResult[row][col - 1].terrainType == nullTerrain) then
		terrainLayoutResult[row][col - 1].terrainType = mainPlateau
		table.insert(potentialStartsLeft, rIndex, {row, col - 1})
		rIndex = rIndex + 1
	end

end

-- generate river result table for river generation
riverResult = {} -- table must be named this to generate rivers
table.insert(riverResult, 1, riverPoints)

-- PLAYER SET UP  ------------------------------------------------------------------------
teamMappingTable = CreateTeamMappingTable() -- creates the player data for teams
	
-- set a starting location for each player
-- create start locations along cliffs use start position locations to keep fords as far from players as possible
playerSeparation = math.floor((gridSize - startsEdgeBuffer * 2) / 4) -- separation value to evenly distribute 4 starts per side (regardless of number of players)
startIndex = 1
startSquaresLeft = {} -- table for holding start areas for left side of map
startSquaresRight = {} -- table for holding start areas for right side of map

-- select squares along the canyon for potential player starts
for index = 1, #potentialStartsLeft do
	rowLeft = potentialStartsLeft[index][1]
	colLeft = potentialStartsLeft[index][2]
	rowRight = potentialStartsRight[index][1]
	colRight = potentialStartsRight[index][2]
	
	-- cycle through the potential start squares and add them to the startSquares tables using the player seperation distance
	if (rowLeft > 1 and rowLeft < gridHeight) then
		if (#startSquaresLeft < 1) then -- if the start position table is empty, place the first starts
			table.insert(startSquaresLeft, startIndex, {rowLeft, colLeft})
			table.insert(startSquaresRight, startIndex, {rowRight, colRight})
			startIndex = startIndex + 1
		else
			if ((rowLeft - playerSeparation) > startSquaresLeft[startIndex - 1][1]) then -- add to the table using player seperation value
				table.insert(startSquaresLeft, startIndex, {rowLeft, colLeft})
				table.insert(startSquaresRight, startIndex, {rowRight, colRight})
				startIndex = startIndex + 1
			end
		end
	end

end

for index = 1, #startSquaresLeft do
	print("Start " ..index ..": row " ..startSquaresLeft[index][1] .." col " ..startSquaresLeft[index][2])
end

for index = 1, #startSquaresRight do
	print("Start " ..index + 4 ..": row " ..startSquaresRight[index][1] .." col " ..startSquaresRight[index][2])
end

-- START LOCATION FORMAT
-- create start areas using data generated above and the function found in player_starts found in library folder
startPosition01 = MakeStartArea(1, startSquaresLeft[1][1], startSquaresLeft[1][1], startSquaresLeft[1][2], startSquaresLeft[1][2], {2, 3})
startPosition02 = MakeStartArea(2, startSquaresLeft[2][1], startSquaresLeft[2][1], startSquaresLeft[2][2], startSquaresLeft[2][2], {1, 3})
startPosition03 = MakeStartArea(3, startSquaresLeft[3][1], startSquaresLeft[3][1], startSquaresLeft[3][2], startSquaresLeft[3][2], {2, 4})
startPosition04 = MakeStartArea(4, startSquaresLeft[4][1], startSquaresLeft[4][1], startSquaresLeft[4][2], startSquaresLeft[4][2], {3, 8})
startPosition05 = MakeStartArea(5, startSquaresRight[1][1], startSquaresRight[1][1], startSquaresRight[1][2], startSquaresRight[1][2], {6, 7})
startPosition06 = MakeStartArea(6, startSquaresRight[2][1], startSquaresRight[2][1], startSquaresRight[2][2], startSquaresRight[2][2], {5, 7})
startPosition07 = MakeStartArea(7, startSquaresRight[3][1], startSquaresRight[3][1], startSquaresRight[3][2], startSquaresRight[3][2], {6, 8})
startPosition08 = MakeStartArea(8, startSquaresRight[4][1], startSquaresRight[4][1], startSquaresRight[4][2], startSquaresRight[4][2], {4, 7})

-- create the start areas table using function in player_starts in the library folder
masterStartPositionsTable = {startPosition01, startPosition02, startPosition03, startPosition04, startPosition05, startPosition06, startPosition07, startPosition08}

startLocationPositions = {} -- set up list to store all player locations

-- PLAYER PLACEMENT
if(randomPositions == true or #teamMappingTable == worldPlayerCount) then -- account for random placement and free-for-all
	startLocationPositions = SetPlayerStartsTeamsApart(masterStartPositionsTable, teamMappingTable)
else -- place players from the same team grouped together
	if(#teamMappingTable <= 2) then -- use the mirrored locations function
		startLocationPositions = SetMirroredStartsTeamsTogether(masterStartPositionsTable, teamMappingTable, gridSize)
	else
		startLocationPositions = SetPlayerStartsTeamsTogether(masterStartPositionsTable, teamMappingTable, gridSize) -- use the teams together function
	end
end

playerCoordinates = {} -- need a table formatted to work in local function(s)

-- place the start positions on the coarse grid
for index = 1, #startLocationPositions do
	x = startLocationPositions[index].startRow
	y = startLocationPositions[index].startCol
	terrainLayoutResult[x][y].terrainType = playerStartTerrain -- this terrain type spawns the player's starting resources
	terrainLayoutResult[x][y].playerIndex = startLocationPositions[index].playerID -- player ID must be set in the table in order to place player starts
	table.insert(playerCoordinates, {x,y}) -- format for {{row1, col1}, {row2, col2}...} as some functions require this format
end

-- PLACE FORDS
baseNumPlayers = 2.1

fordUpstreamSquareMargin = 0 -- margin away from the top edge of the map
fordDownstreamSquareMargin = 0 -- margin away from the bottom edge of the map
fordLocations = {}
fordIndeces = {}

-- determine where the fords are placed and mark the river index where they occur
for rIndex = 1, #riverResult do -- loop through each river
	--print("Adding indeces for river " ..rIndex)
	table.insert(fordIndeces, rIndex, {}) -- add a table to hold all the ford indeces for each river
	--print("There are " ..#riverResult[rIndex] .." river squares in river " ..rIndex) 
	for sIndex = 1, #riverResult[rIndex] do -- loop through each square in the river and add it's index if it is in the correct range		
		if (sIndex > fordUpstreamSquareMargin and sIndex < #riverResult[rIndex] - fordDownstreamSquareMargin) then
			--print("Adding index " ..sIndex .." to fordIndeces table.")
			table.insert(fordIndeces[rIndex], sIndex)
		else
			--print("Discarding index " ..sIndex .." as it is outside the defined range.")
		end
		
	end
	
end

-- remove river corner squares from ford consideration (greater reliability if fords cross straight sections of river)
for rIndex = 1, #fordIndeces do
	
	for fIndex = (#fordIndeces[rIndex]), 1, -1  do
		riverSquare = riverResult[rIndex][fIndex]
		row = riverSquare[1]
		col = riverSquare[2]
		--print("Checking if river sqaare is a corner at row " ..row ..", col " ..col)
		
		if(row > 1 and row < gridHeight) then
			
			if (terrainLayoutResult[row - 1][col].terrainType ~= riverTerrain or terrainLayoutResult[row + 1][col].terrainType ~= riverTerrain) then
				--print("Removing river corner square from ford consideration at index " ..fIndex)
				table.remove(fordIndeces[rIndex], fIndex)
			end
		end
		
	end
	
end

-- add fords to a temporary table that will be copied onto fordLocations
for rIndex = 1, #riverResult do --loop through each river
	fordIndexTable = {} -- table to hold the ford indexes
	fordCoordinates = {} -- table to hold the row and column of the fords
	baseNumberOfFords = Round(worldGetRandom() * (maxFords - minFords), 0) + minFords
	numberOfFords = math.floor((baseNumberOfFords / baseMapSize) * worldTerrainWidth)
	if(numberOfFords < 2) then numberOfFords = 2 end -- make sure there are always at least 2 fords on the smaller maps
	
	if(printDebugInfo == true) then
		print("Number of attempted *fords for river " ..rIndex ..": " ..numberOfFords)
	end
	
	fordsRemaining = numberOfFords
	
	-- loop through potential ford squares to find fords that are random, but constrained to minimum seperation distances
	while (fordsRemaining > 0 and #fordIndeces[rIndex] > 0) do
		roll = Round(worldGetRandom() * (#fordIndeces[rIndex] - 1), 0) + 1 -- generate a random ford index index to check for ford placement
		--print("River ford index roll: " ..roll)
		fordIndex = fordIndeces[rIndex][roll]
		--print("River result index is " ..fordIndex)	
		placeFord = false
		
		
		if (#fordIndexTable > 0) then -- check to see if we have placed fords to compare distance to
			--There are some fords already
			row = riverResult[rIndex][fordIndex][1]
			col = riverResult[rIndex][fordIndex][2]

			--print("Checking row " ..row ..", col " ..col .." as potential ford")
			if(FordsFarEnough(row, fordCoordinates, minFordDistance) and FordsFarEnough(row, playerCoordinates, minPlayerDistance)) then							
				placeFord = true -- this index will be used below
			else
				table.remove(fordIndeces[rIndex], roll)
				placeFord = false -- remove bad index from future consideration
			end
		
		else -- try to place the first ford if we have none (check only distance from player starts)
			row = riverResult[rIndex][fordIndex][1]
			col = riverResult[rIndex][fordIndex][2]
			--print("Checking row " ..row ..", col " ..col .." as potential ford")
			--print("No fords yet...")
			if (FordsFarEnough(row, playerCoordinates, minPlayerDistance)) then -- place the first ford if it's far enough from players							
				placeFord = true
			else
				table.remove(fordIndeces[rIndex], roll) -- remove bad index from future consideration
				placeFord = false
			end
			
		end
		
		-- Place the ford into the correct tables
		if (placeFord == true) then
			--print("Placing ford at row " ..row ..", col " ..col)
			table.insert(fordIndexTable, fordIndex)
			table.remove(fordIndeces[rIndex], roll) -- remove this index from future consideration
			table.insert(fordCoordinates, {row, col})
			fordsRemaining = fordsRemaining - 1
		end
		
	end
	
	-- expand width of fords
	for fIndex = 1, #fordIndexTable do
		local riverIndex = fordIndexTable[fIndex]
		local rRow = riverResult[1][riverIndex][1]
		local rCol = riverResult[1][riverIndex][2]
		
		print("Goody! River Row: " ..rRow ..", River Col: " ..rCol)
		
		-- variables to hold potential for squares to widen fords
		local upRow = 0
		local upCol = 0
		local downRow = 0
		local downCol = 0
		
		-- get the upstream river square 
		if(riverIndex > 1) then
			upRow = riverResult[1][riverIndex - 1][1]
			upCol = riverResult[1][riverIndex - 1][2]
		end
		
		-- get the downstream river square
		if(riverIndex < #riverResult[1]) then
			downRow = riverResult[1][riverIndex + 1][1]
			downCol = riverResult[1][riverIndex + 1][2]
		end
		
		-- check if the upstream square is next to a river turn and exlude if it is
		if(upRow > 0) then	
			if(riverIndex > 2) then
				if(upCol ~= riverResult[1][riverIndex - 2][2]) then
					upRow = 0
					upCol = 0
				end
			end
		end
		
		-- check if the downstream square is next to a river turn and exlude if it is
		if(downRow > 0) then
			if(riverIndex <= gridSize - 2) then
				if(downCol ~= riverResult[1][riverIndex + 2][2]) then
					downRow = 0
					downCol = 0					
				end
			end
		end
		
		-- select a square for the ford widening
		if(upRow > 0 and downRow == 0) then
			-- upstream is chosen
			table.insert(fordIndexTable, (riverIndex - 1))
		elseif(upRow == 0 and downRow > 0) then
			-- downstream is chosen
			table.insert(fordIndexTable, (riverIndex + 1))
		elseif(upRow > 0 and downRow > 0) then
			-- randomly choose square
			if(worldGetRandom() > 0.5) then
				-- upstream is chosen
				table.insert(fordIndexTable, (riverIndex - 1))
			else
				-- downstream is chosen
				table.insert(fordIndexTable, (riverIndex + 1))
			end
		else
			print("Error: There was no valid up or down stream square to choose from.")
		end		
	end
	
	--print("Number of indeces for river " ..rIndex .." is " ..#fordIndexTable)
	
	-- insert riverresult data into temp table
	for rIndex = 1, #riverResult do
		fordTable = {}		
		for fIndex = 1, #fordIndexTable do
			table.insert(fordTable, riverResult[rIndex][fordIndexTable[fIndex]])		
		end
		
		-- insert temp table into fordLocations
		table.insert(fordLocations, rIndex, DeepCopy(fordTable))
		
	end

end

adjacentFordSquare = {}


-- make sure there is a passable lane of terrain to the ford
fordLaneSquares = {} -- table to hold ford sqaures in lane for later smoothing/expansion
for rIndex = 1, #fordLocations do
	
	for sIndex = 1, #fordLocations[rIndex] do
		row = fordLocations[rIndex][sIndex][1]
		col = fordLocations[rIndex][sIndex][2]
		
		terrainLayoutResult[row][col - 1].terrainType = plainsTerrain		
		table.insert(fordLaneSquares, {row, col - 1}) -- add to table to expand/smooth entrance/exits
		terrainLayoutResult[row][col - 2].terrainType = gentleHillTerrain
		table.insert(fordLaneSquares, {row, col - 2})
		terrainLayoutResult[row][col - 3].terrainType = lowHillTerrain		
		table.insert(fordLaneSquares, {row, col - 3})
		terrainLayoutResult[row][col + 1].terrainType = plainsTerrain		
		table.insert(fordLaneSquares, {row, col + 1})
		terrainLayoutResult[row][col + 2].terrainType = gentleHillTerrain
		table.insert(fordLaneSquares, {row, col + 2})
		terrainLayoutResult[row][col + 3].terrainType = lowHillTerrain
		table.insert(fordLaneSquares, {row, col + 3})
	end
	
end


-- smooth the ford entrances/exits
for index = 1, #fordLaneSquares do
	nullSquares = {}
	row = fordLaneSquares[index][1]
	col = fordLaneSquares[index][2]
	--print("smooth square at row " ..row .." col " ..col)
	nullSquares = GetAllSquaresOfTypeInRingAroundSquare(row, col, 1, 1, {nullTerrain}, terrainLayoutResult)
	
	if(#nullSquares > 0) then
		
		for nIndex = 1, #nullSquares do
			nRow = nullSquares[nIndex][1]
			nCol = nullSquares[nIndex][2]
			terrainLayoutResult[nRow][nCol].terrainType = mediumHillTerrain
		end
		
	end

end

-- place buffer squares around player starts
for index = 1, #startLocationPositions do
	x = startLocationPositions[index].startRow
	y = startLocationPositions[index].startCol
	
	bufferSquares = GetAllSquaresOfTypeInRingAroundSquare(x, y, 1, 1, {nullTerrain}, terrainLayoutResult)
	
	for bIndex = 1, #bufferSquares do
		row = bufferSquares[bIndex][1]
		col = bufferSquares[bIndex][2]
		terrainLayoutResult[row][col].terrainType = mediumHillTerrain
	end
end

-- place sacred sites (only two sacred sites on this map)
-- place a sacred site on one side of the canyon
if(worldGetRandom() < 0.5) then
	terrainLayoutResult[2][2].terrainType = sacredTerrain
	-- mirror the sacred site on the other side of the canyon
	terrainLayoutResult[2][gridSize - 1].terrainType = sacredTerrain	
else
	terrainLayoutResult[gridSize - 1][2].terrainType = sacredTerrain
	-- mirror the sacred site on the other side of the canyon
	terrainLayoutResult[gridSize - 1][gridSize - 1].terrainType = sacredTerrain	
end

-- place neutral trade settlements
potentialTradeSquaresLeft = {} -- squares along the left side of the map away from the canyon
potentialTradeSquaresRight = {} -- squares along the right side of the map away from the canyon

for index = 1, gridSize do
	table.insert(potentialTradeSquaresLeft, {index, 1})
	table.insert(potentialTradeSquaresRight, {index, gridSize})
end

-- find the centroid of the player positions to place the trade post as far from that as possible
playerCenterLeft = {}
playerCenterRight = {}
playerCenterLeft, playerCenterRight = GetPlayerStartsCenter(startLocationPositions, mapMidPoint, riverTerrain) -- get the centroid grid square of starting positions on each side of the canyon

leftRow, leftCol, leftSquareIndex = GetFurthestSquare(playerCenterLeft[1][1], playerCenterLeft[1][2], potentialTradeSquaresLeft)
rightRow, rightCol, rightSquareIndex = GetFurthestSquare(playerCenterRight[1][1], playerCenterRight[1][2], potentialTradeSquaresRight)

terrainLayoutResult[leftRow][leftCol].terrainType = settlementTerrain
terrainLayoutResult[rightRow][rightCol].terrainType = settlementTerrain

-- debug output
if(printDebugInfo == true) then
	print("MAP GEN SUMMARY:")
	-- player start debug output
	print("Total Players: " ..#startLocationPositions)
	for index = 1, #startLocationPositions do
		print("Player ID " ..startLocationPositions[index].playerID .." start position at row " ..startLocationPositions[index].startRow ..", col " ..startLocationPositions[index].startCol)
		terrainLayoutResult[startLocationPositions[index].startRow][startLocationPositions[index].startCol].terrainType = playerStartTerrain
		terrainLayoutResult[startLocationPositions[index].startRow][startLocationPositions[index].startCol].playerIndex = startLocationPositions[index].playerID
	end

	-- river and ford debug output
	if(#riverResult > 0) then
		for rIndex = 1, #riverResult do
			--print("River " ..rIndex .." coordinates:")
			local riverTable = DeepCopy(riverResult[rIndex])
			-- river squares		
			for cIndex = 1, #riverTable do
				x = riverTable[cIndex][1]
				y = riverTable[cIndex][2]
				--print("River square at row " ..x ..", col " ..y)
			end
			-- ford squares
			if (#fordLocations > 0) then
				for fIndex = 1, #fordLocations do
					print("Ford " ..fIndex .." coordinates:")
					local fordTable = DeepCopy(fordLocations[fIndex])
					
					for cIndex = 1, #fordTable do
						x = fordTable[cIndex][1]
						y = fordTable[cIndex][2]
						print("Ford square at row " ..x ..", col " ..y)
					end
					
				end
			end		
			---------------		
		end
		
	end
end

print("END OF CANYON LUA SCRIPT")