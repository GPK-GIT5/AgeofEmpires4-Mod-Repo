-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--- MakeStartPosition
-- makes a start area which defines an ID, start and end row and column (to define a box within whixch the start position appears)
-- connections is a list of the IDs of start positions that are neighbours to the start position (for placing teams together)
function MakeStartArea(startID, startRow, endRow, startCol, endCol, connectedStartIDs)
	
	if (type(connectedStartIDs) ~= "table") then
		print("ERROR: No viable connections. Connections parameter must be a table. Converting connections to empty table")	
		connectedStartIDs = {}
	end
	
	print("There are " ..#connectedStartIDs .." starts connected to this one.")
	for index = 1, #connectedStartIDs do
		print("Connected to start ID " ..connectedStartIDs[index])
	end
	
	return {startID = startID, startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol, connections = connectedStartIDs}

end

--- MakePlayerStartPosition
function MakePlayerStartPosition(startIndex, playerIndex, row, column)

	if(playerIndex == nil) then
		print("ERROR: Missing playerIndex. Aborting function.")
		return
	end
	
	return {startID = startIndex, playerID = playerIndex, team = playerTeams[playerIndex], startRow = row, startCol = column}

end

function SelectStartPosition(theStartPositions)

	-- select a start area from the open positions
	local startIndex = Round(worldGetRandom() * (#theStartPositions - 1), 0) + 1
	
	-- set start/end row/column for the start ara 
	startRow = theStartPositions[startIndex].startRow
	endRow = theStartPositions[startIndex].endRow
	startCol = theStartPositions[startIndex].startCol
	endCol = theStartPositions[startIndex].endCol
	startID = theStartPositions[startIndex].startID

	-- select the final coordinates for the sart position
	finalRow, finalCol = GetSquareInBox (startRow, endRow, startCol, endCol, gridSize)
	
	return startIndex, finalRow, finalCol, startID

end

function SelectStartPositionDivided(theStartPositions)

	-- select a start area from the open positions
	local startIndex = Round(worldGetRandom() * (Round(#theStartPositions / 2, 0) - 1), 0) + 1
	
	-- set start/end row/column for the start ara 
	startRow = theStartPositions[startIndex].startRow
	endRow = theStartPositions[startIndex].endRow
	startCol = theStartPositions[startIndex].startCol
	endCol = theStartPositions[startIndex].endCol
	startID = theStartPositions[startIndex].startID
	
	-- select the final coordinates for the sart position
	finalRow, finalCol = GetSquareInBox (startRow, endRow, startCol, endCol, gridSize)
	
	return startIndex, finalRow, finalCol, startID

end

--- SET UP TEAMS
function SetUpTeams()
	--find teams
	local teamTable = {}
	local playersPerTeam = {}	
	print("------------ SETTING UP TEAMS ---------------")
	
	-- assign team numbers to players set to "no team"
	currentNoTeamIndex = 9
	
	for index = 1, #playerTeams do
		print("Checking team assigment for player " ..index .." Team: " ..playerTeams[index])
		if(playerTeams[index] == 10002) then
			print("Assigning No Team Player to Team " ..currentNoTeamIndex)
			playerTeams[index] = currentNoTeamIndex
			currentNoTeamIndex = currentNoTeamIndex + 1
		end
	end
	
	for index = 1, #playerTeams do -- loop through every player in the player teams table
		
		if (#teamTable < 1) then -- if the teams table is empty, add the current player's team
			table.insert(teamTable, playerTeams[index])
		else 
		
			for teamIndex = 1, #teamTable do -- loop through each team in the team table and set foundTeam to true if this players team is already accounted for		
				foundTeam = false
				
				if (playerTeams[index] == teamTable[teamIndex]) then
					foundTeam = true
				end
				
			end
			
			if(foundTeam == false) then -- if the current players team isn't in the team table, add it
				table.insert(teamTable, playerTeams[index])
			end	
			
		end				
	
	end
	
	for tIndex = 1, #teamTable do
		
		count = 0		
		for pIndex = 1, #playerTeams do
			
			if (playerTeams[pIndex] == teamTable[tIndex]) then
				count = count + 1
			end
			
		end
		
		table.insert(playersPerTeam, tIndex, count)
		
	end
	
	-- debug team info
	print("TOTAL TEAMS = " ..#teamTable)
	for index = 1, #teamTable do
		print("Team " ..index .." is teamID " ..teamTable[index])
	end
	
	print("MEMBERS PER TEAM: ")
	for index = 1, #playersPerTeam do
		print("Team " ..index ..", teamID " .. teamTable[index] .." has "..playersPerTeam[index] .." members.")
	end
	
	return teamTable, playersPerTeam

end

function SelectStartPositionByTableIndex(theStartPositions, positionTableIndex)	
	
		-- set start/end row/column for the start ara 
		startRow = theStartPositions[positionTableIndex].startRow
		endRow = theStartPositions[positionTableIndex].endRow
		startCol = theStartPositions[positionTableIndex].startCol
		endCol = theStartPositions[positionTableIndex].endCol
		
		startIndex = theStartPositions[positionTableIndex].startID
		
		-- select the final coordinates for the sart position
		finalRow, finalCol = GetSquareInBox (startRow, endRow, startCol, endCol, gridSize)
		
		return startIndex, finalRow, finalCol

end

function GetStartPositionsTeamsApart(openStartPositions)
	print("GET START LOCATIONS TEAMS APART")
	local startLocationPositions = {}
	-- select start positions
	for playerIndex = 0, (worldPlayerCount - 1) do
		
		startIndex, row, col, startID = SelectStartPosition(openStartPositions)
		-- create the data table for the player's start location
		tempPlayer = MakePlayerStartPosition(startID, math.floor(playerIndex), math.floor(row), math.floor(col)) -- flooring the index to avoid a weird code assert 
		print("PlayerID is: " ..tempPlayer.playerID .." Start ID is: " ..tempPlayer.startID)
		table.insert(startLocationPositions, (playerIndex + 1), tempPlayer)
		
		-- remove this start area from the open list
		table.remove(openStartPositions, startIndex)
	
	end
	
	return startLocationPositions
	
end

function GetStartPositionsTeamsApartDividedMap(openStartPositions)
	print("GET START LOCATIONS TEAMS APART DIVIDED")
	openPositionsTop = {}
	openPositionsBottom = {}
	
	for index = 1, #openStartPositions do
		
		if (index <= #openStartPositions / 2) then
			table.insert(openPositionsTop, openStartPositions[index])
		else
			table.insert(openPositionsBottom, openStartPositions[index])
		end
		
	end

	local startLocationPositions = {}
	-- select start positions
	for playerIndex = 0, (worldPlayerCount - 1) do
		
		if (playerIndex % 2 == 0) then		
			print("Picking start from top.")
			topIndex, row, col, startID = SelectStartPosition(openPositionsTop)
			startIndex = openPositionsTop[topIndex].startID
		else
			print("Picking start from bottom.")
			bottomIndex, row, col, startID = SelectStartPosition(openPositionsBottom)
			startIndex = openPositionsBottom[topIndex].startID
		end
		
		-- create the data table for the player's start location
		tempPlayer = MakePlayerStartPosition(startID, math.floor(playerIndex), math.floor(row), math.floor(col)) -- flooring the index to avoid a weird code assert 
		print("PlayerID is: " ..tempPlayer.playerID)
		print("Start row is " ..row .." start col is " ..col .." Player start start row is " ..tempPlayer.startRow .." col is " ..tempPlayer.startCol)
		--print("Corresponding open list: Row is " ..openStartPositions[startIndex].startRow ..", Col is " ..openStartPositions[startIndex].startCol)
		table.insert(startLocationPositions, (playerIndex + 1), tempPlayer)
		
		-- remove this start area from the open list
		if (playerIndex % 2 == 0) then					
			table.remove(openPositionsTop, topIndex)
		else
			table.remove(openPositionsBottom, bottomIndex)
		end			
	
	end
	
	return startLocationPositions
	
end

function GetTeammateStartPosition(theTeams, teamIndex, teamStartingPoint, playerIndex, openStartPositions, masterStartPositions, dividedMap)	
		
	print("Attempting to place player " ..playerIndex)
	print("On team " ..teamIndex)
	print(" team start point is " ..tostring(teamStartingPoint))				
	
	if (teamStartingPoint == nil) then -- pick a start location for the team from which teammates will be placed adjacent
		print("TEAM STARTING POINT: Selecting Team Starting point for team " ..teamIndex)
		if(dividedMap == true) then
			startIndex, row, col, startID = SelectStartPositionDivided(openStartPositions) -- select random start as team start point
		else
			startIndex, row, col, startID = SelectStartPosition(openStartPositions) -- select random start as team start point
		end
		
		-- create the data table for the player's start location
		tempPlayer = MakePlayerStartPosition(openStartPositions[startIndex].startID, math.floor(playerIndex), math.floor(row), math.floor(col)) -- flooring the index to avoid a weird code assert 
		print("PlayerID is: " ..tempPlayer.playerID .." Index is " ..(playerIndex + 1))
		print("--- PLAYER PLACED!  PlayerID is: " ..tempPlayer.playerID .. " Start ID is: " ..tempPlayer.startID .." Row: " ..tempPlayer.startRow .. " Col: " ..tempPlayer.startCol)
		--table.insert(startLocationPositions, (playerIndex + 1), tempPlayer)
		teamStartingPoint = tempPlayer.startID			
							
		-- remove this start area from the open list
		table.remove(openStartPositions, startIndex)
		print("TEAM STARTING POINT Start ID is " ..teamStartingPoint)					
		
	else -- pick an adjacent start position for each teammate
		print("---------- FINDING NEIGHBORS...")
		neighborStarts = {}
		print("Master N1: " ..masterStartPositions[teamStartingPoint].connections[1] .." Master N2: " ..masterStartPositions[teamStartingPoint].connections[2])
		neighbor01_ID = masterStartPositions[teamStartingPoint].connections[1]
		neighbor02_ID = masterStartPositions[teamStartingPoint].connections[2]
		
		print("N1 = " ..neighbor01_ID .." N2 = " ..neighbor02_ID)
		
		for index = 1, #openStartPositions do
			print("N1 Start ID: " ..neighbor01_ID .." OP Table index: " ..index .." Start ID: " ..openStartPositions[index].startID)
			print("N2 Start ID: " ..neighbor02_ID .." OP Table index: " ..index .." Start ID: " ..openStartPositions[index].startID)
			if (neighbor01_ID == openStartPositions[index].startID) then							
				table.insert(neighborStarts, neighbor01_ID)
			end
			
			if (neighbor02_ID == openStartPositions[index].startID) then
				table.insert(neighborStarts, neighbor02_ID)
			end
			
		end
		
		print("NEIGHBORS (pass one) = " ..#neighborStarts)
		
		if (#neighborStarts < 1) then
			print("neighborStarts pass one has no entries.")
			tempStartID_01 = neighbor01_ID
			tempStartID_02 = neighbor02_ID
			
			neighbor01_ID = masterStartPositions[tempStartID_01].connections[1]
			neighbor02_ID = masterStartPositions[tempStartID_01].connections[2]
			
			neighbor03_ID = masterStartPositions[tempStartID_02].connections[1]
			neighbor04_ID = masterStartPositions[tempStartID_02].connections[2]

			print("N1 = " ..neighbor01_ID .." N2 = " ..neighbor02_ID .." N3 = " ..neighbor03_ID .." N4 = " ..neighbor04_ID)

		end
		
		for index = 1, #openStartPositions do
			print("OL " ..index .." Start Position ID: " ..openStartPositions[index].startID)
			if (neighbor01_ID == openStartPositions[index].startID) then
				print("N1: " ..neighbor01_ID .."is in the open list. Adding")
				table.insert(neighborStarts, neighbor01_ID)
			end
			
			if (neighbor02_ID == openStartPositions[index].startID) then
				print("N2: " ..neighbor02_ID .." is in the open list. Adding")
				table.insert(neighborStarts, neighbor02_ID)
			end
			
			if (neighbor03_ID == openStartPositions[index].startID) then
				print("N3: " ..neighbor03_ID .." is in the open list. Adding")
				table.insert(neighborStarts, neighbor03_ID)
			end
			
			if (neighbor04_ID == openStartPositions[index].startID) then
				print("N4: " ..neighbor04_ID .." is in the open list. Adding")
				table.insert(neighborStarts, neighbor04_ID)
			end
			
			for nIndex = 1, #neighborStarts do
				print("Neighbor " ..nIndex .." StartID is " ..neighborStarts[nIndex])
			end
			
		end
		
		print("NEIGHBORS (pass two) = " ..#neighborStarts)
		
		if (#neighborStarts < 1) then
			print("neighborStarts pass two has no entries.")
			tempStartID_01 = neighbor01_ID
			tempStartID_02 = neighbor02_ID
			tempStartID_03 = neighbor03_ID
			tempStartID_04 = neighbor04_ID
			
			neighbor01_ID = masterStartPositions[tempStartID_01].connections[1]
			neighbor02_ID = masterStartPositions[tempStartID_01].connections[2]
			
			neighbor03_ID = masterStartPositions[tempStartID_02].connections[1]
			neighbor04_ID = masterStartPositions[tempStartID_02].connections[2]
			
			neighbor05_ID = masterStartPositions[tempStartID_03].connections[1]
			neighbor06_ID = masterStartPositions[tempStartID_03].connections[2]
			
			neighbor07_ID = masterStartPositions[tempStartID_04].connections[1]
			neighbor08_ID = masterStartPositions[tempStartID_04].connections[2]

			print("N1 = " ..neighbor01_ID .." N2 = " ..neighbor02_ID .." N3 = " ..neighbor03_ID .." N4 = " ..neighbor04_ID .." N5 = " ..neighbor05_ID .." N6 = " ..neighbor06_ID .." N7 = " ..neighbor07_ID .." N8 = " ..neighbor08_ID)

		end
		
		for index = 1, #openStartPositions do
			print("OL " ..index .." Start Position ID: " ..openStartPositions[index].startID)
			if (neighbor01_ID == openStartPositions[index].startID) then
				print("N1: " ..neighbor01_ID .."is in the open list. Adding")
				table.insert(neighborStarts, neighbor01_ID)
			end
			
			if (neighbor02_ID == openStartPositions[index].startID) then
				print("N2: " ..neighbor02_ID .." is in the open list. Adding")
				table.insert(neighborStarts, neighbor02_ID)
			end
			
			if (neighbor03_ID == openStartPositions[index].startID) then
				print("N3: " ..neighbor03_ID .." is in the open list. Adding")
				table.insert(neighborStarts, neighbor03_ID)
			end
			
			if (neighbor04_ID == openStartPositions[index].startID) then
				print("N4: " ..neighbor04_ID .." is in the open list. Adding")
				table.insert(neighborStarts, neighbor04_ID)
			end
			
			if (neighbor05_ID == openStartPositions[index].startID) then
				print("N4: " ..neighbor05_ID .." is in the open list. Adding")
				table.insert(neighborStarts, neighbor05_ID)
			end
			
			if (neighbor06_ID == openStartPositions[index].startID) then
				print("N4: " ..neighbor06_ID .." is in the open list. Adding")
				table.insert(neighborStarts, neighbor06_ID)
			end
			
			if (neighbor07_ID == openStartPositions[index].startID) then
				print("N4: " ..neighbor07_ID .." is in the open list. Adding")
				table.insert(neighborStarts, neighbor07_ID)
			end
			
			if (neighbor08_ID == openStartPositions[index].startID) then
				print("N4: " ..neighbor08_ID .." is in the open list. Adding")
				table.insert(neighborStarts, neighbor08_ID)
			end
			
			for nIndex = 1, #neighborStarts do
				print("Neighbor " ..nIndex .." StartID is " ..neighborStarts[nIndex])
			end
			
		end
		
		print("------------- CHOOSING FROM NEIGHBORS")
		
		for nIndex = 1, #neighborStarts do
			print("NeighborStart ID " ..nIndex .." is " ..neighborStarts[nIndex])
		end
		
		if(#neighborStarts > 0) then						
			neighborStartPositionID = GetRandomElement(neighborStarts)
			print("Neighbor ID is " ..neighborStartPositionID)						
			for index = 1, #openStartPositions do
				print("Open Table index: " ..index .." StartID: " ..openStartPositions[index].startID)
				if (neighborStartPositionID == openStartPositions[index].startID) then
					startTableIndex = index
				end
			end
			
			startID, row, col = SelectStartPositionByTableIndex(openStartPositions, startTableIndex)
			
			-- create the data table for the player's start location
			tempPlayer = MakePlayerStartPosition(startID, math.floor(playerIndex), math.floor(row), math.floor(col)) -- flooring the index to avoid a weird code assert 
			print("--- NEIGHBOR PLAYER PLACED!  PlayerID is: " ..tempPlayer.playerID .. " Start ID is: " ..tempPlayer.startID .." Row: " ..tempPlayer.startRow .. " Col: " ..tempPlayer.startCol)
			--table.insert(startLocationPositions, (playerIndex + 1), tempPlayer)
			teamStartingPoint = tempPlayer.startID

			-- remove this start area from the open list
			table.remove(openStartPositions, startTableIndex)
			neighborStarts = {}
		end
		
	end
	
	return tempPlayer, teamStartingPoint

end

function GetStartPositionsTeamsTogether(openStartPositions, masterStartPositions)
	print("GET START POSITIONS TEAMS TOGETHER")
	local startLocationPositions = {}
	local theTeams = {}
	local membersPerTeam = {}
	
	-- Set up the teams
	theTeams, membersPerTeam = SetUpTeams()
	
	-- select start positions in groups based on teams
	for teamIndex = 1, #theTeams do
		print("------------ PLACING PLAYERS FOR TEAM " ..teamIndex)
		
		---- Determine team starting point
		if (worldPlayerCount > 6 and teamIndex > 1 and teamIndex ~= #theTeams) then					
			-- use previous team's last placement as this team's team start point to avoid isolated start points 
			tempTeamPoint_01 = startLocationPositions[#startLocationPositions].startID			
			
			-- use the first placement for the previous team as an alternate start point
			print("Previous team number of players is " ..membersPerTeam[teamIndex - 1])
			otherStartIndex = #startLocationPositions - membersPerTeam[teamIndex - 1] + 1
			
			print("Other start Index = " ..otherStartIndex)
			tempTeamPoint_02 = startLocationPositions[otherStartIndex].startID
			
			-- choose between the two start points
			if (worldGetRandom() < .5) then
				teamStartingPoint = tempTeamPoint_01
			else
				teamStartingPoint = tempTeamPoint_02
			end
			
			print("Setting team " ..teamIndex .." starting point to previous team's last start point.")
		else
			teamStartingPoint = nil
		end
		---- Team starting point determined
		
		---- Cycle through players and place if they are on the current team
		for playerIndex = 0, (worldPlayerCount - 1) do 
			print("CHECKING PLAYER " ..playerIndex .." FOR TEAM AFFILIATION.")
			if (playerTeams[playerIndex + 1] == theTeams[teamIndex]) then -- check if this player is on the current team
				-- get a valid player starting point for each teammate
				playerPlacement, teamStartingPoint = GetTeammateStartPosition(theTeams, teamIndex, teamStartingPoint, playerIndex, openStartPositions, masterStartPositions, false)
				
				if (playerPlacement ~= nil) then
					table.insert(startLocationPositions, (playerIndex + 1), tempPlayer)
				end
				
			else
				print("PLAYER " ..playerIndex .." NOT ON TEAM " ..teamIndex)			
			end

		end 
	
	end
	
	return startLocationPositions

end

function GetStartPositionsTeamsTogetherDividedMap(masterStartPositions)	
	print("GET START POSITIONS TEAMS TOGETHER")
	local theStartLocationPositions = {}
	local openPositionsTop = {} -- the first 4 positions in the master list must be on the same side of the map ("top")
	local openPositionsBottom = {} -- the last 4 positions in the master list must be on the same side of the map ("bottom")
	local theTeams = {}
	local membersPerTeam = {}
	
	-- set up open lists
	for index = 1, 4 do
		table.insert(openPositionsTop, masterStartPositions[index])
		table.insert(openPositionsBottom, masterStartPositions[index + 4])
	end
	
	if (worldPlayerCount < 5) then -- remove middle start positions			
		table.remove(openPositionsTop, 4)
		table.remove(openPositionsTop, 3)
		table.remove(openPositionsBottom, 4)
		table.remove(openPositionsBottom, 3)			
	end	
	
	-- Set up the teams
	theTeams, membersPerTeam = SetUpTeams()
	
	-- sort the teams in descending order based on the number of team members
	local teamsByMembers = {}
	for index = 1, #membersPerTeam do
		table.insert(teamsByMembers, index, {team = theTeams[index], members = membersPerTeam[index]})
	end
	
	for index = 1, #teamsByMembers do
		print("Team: " ..teamsByMembers[index].team .." Members: " ..teamsByMembers[index].members)
	end	

	table.sort(teamsByMembers, function(a, b) return a.members > b.members end)
	
	print("AfterSorting:")
	for index = 1, #teamsByMembers do
		print("Team: " ..teamsByMembers[index].team .." Members: " ..teamsByMembers[index].members)
	end

	-- cycle through each team in order from largest to smallest
	for mIndex = 1, #teamsByMembers do		
		print("mIndex is " ..mIndex)	
		if (mIndex % 2 == 0) then
			if (#openPositionsTop > 0) then
				currentOpenPositions = openPositionsTop
				teamStartingPoint = nil
			else
				currentOpenPositions = openPositionsBottom
			end
		else
			if (#openPositionsBottom > 0) then
				currentOpenPositions = openPositionsBottom
				teamStartingPoint = nil
			else
				currentOpenPositions = openPositionsTop
			end
		end
		
		
		print("Current Open = " ..#currentOpenPositions .." Open Top = " ..#openPositionsTop .." Open Bottom = " ..#openPositionsBottom)
		--[[if (#currentOpenPositions < 0) then -- add point from map bottom if no more spots on top available
				
			if (mIndex % 2 == 0) then
				tempPoint01 = masterStartPositions[4].connections[1]
				tempPoint02 = masterStartPositions[4].connections[2]
			else
				tempPoint01 = masterStartPositions[8].connections[1]
				tempPoint02 = masterStartPositions[8].connections[2]
			end
	
			for index = 1, #theStartLocationPositions do
			
				if (tempPoint01.startID == theStartLocationPositions[index]) then
					tempPoint01 = nil
				end
				
				if (tempPoint02.startID == theStartLocationPositions[index]) then
					tempPoint02 = nil
				end							
			
			end
			
			if (tempPoint01 ~= nil) then
				table.insert(currentOpenPositions, tempPoint01)
			end
			
			if (tempPoint02 ~= nil) then
				table.insert(currentOpenPositions, tempPoint02)
			end
		
		end -- end map half check	]]	
		
		-- check each player for team affiliation and place them if they are on the current team		
		for playerIndex = 1, #playerTeams do			
			print("Player " ..playerIndex .." current team Index: " ..teamsByMembers[mIndex].team)
			-- get a valid player starting point for each teammate
			if (playerTeams[playerIndex] == teamsByMembers[mIndex].team) then
				print("Now Placing Player " ..playerIndex .." from team " ..playerTeams[playerIndex])
				playerPlacement, teamStartingPoint = GetTeammateStartPosition(theTeams, teamsByMembers[mIndex].team, teamStartingPoint, (playerIndex - 1), currentOpenPositions, masterStartPositions, true)
				
				if (playerPlacement ~= nil) then
					print("Inserting player " ..playerIndex - 1 .." into starting locations")
					table.insert(theStartLocationPositions, playerPlacement)
					print("CURRENT NUMBER OF START POSITIONS = " ..#theStartLocationPositions)
				end	
			
			end	
		
		end -- end player for loop
	
	end -- end team for loop
	
	print("TOTAL NUMBER OF START POSITIONS GENERATED: " ..#theStartLocationPositions)
	return theStartLocationPositions
	
end

--- MAKE START POSITIONS TABLE
-- creates a basic set of default start positions ringing the map
function MakeStartPositionsTable(gridWidth, gridHeight, gridSize)
	
	-- tunables
	local baseGrid = 13
	local rowBorder = 1
	local boxHeight = 2
	local colBorder = 1
	local boxWidth = 2
	local middleWidth = 1
	local middleHeight = 1
	
	-- top left corner start
	startRow = Round(1 + rowBorder / baseGrid * gridSize, 0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = Round(1 + colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox01 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 1 (top left):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- bottom right corner start
	startRow = Round(gridHeight - boxHeight / baseGrid * gridSize + 1 - rowBorder / baseGrid * gridSize, 0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = Round(gridWidth - boxWidth / baseGrid * gridSize + 1 - colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox02 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 2 (bottom right):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- bottom left corner start
	startRow = Round(gridHeight - boxHeight / baseGrid * gridSize + 1 - rowBorder / baseGrid * gridSize, 0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = Round(1 + colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox03 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 3 (bottom left):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- top right corner start
	startRow = Round(1 + rowBorder / baseGrid * gridSize,0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = Round(gridWidth - boxWidth / baseGrid * gridSize + 1 - colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox04 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 4 (top right):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- top middle start
	startRow = Round(1 + rowBorder / baseGrid * gridSize, 0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = math.ceil(gridWidth / 2 - middleWidth / baseGrid * gridSize + 1)
	endCol = math.ceil(gridWidth / 2 + middleWidth / baseGrid * gridSize - 1)
	startBox05 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 5 (top middle):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- bottom middle start
	startRow = Round(gridHeight - boxHeight / baseGrid * gridSize + 1 - rowBorder / baseGrid * gridSize, 0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = math.ceil(gridWidth / 2 - middleWidth / baseGrid * gridSize + 1)
	endCol = math.ceil(gridWidth / 2 + middleWidth / baseGrid * gridSize - 1)
	startBox06 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 6 (bottom middle):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- left middle start
	startRow = math.ceil(gridHeight / 2 - middleHeight / baseGrid * gridSize + 1)
	endRow = math.ceil(gridHeight / 2 + middleHeight / baseGrid * gridSize - 1)
	startCol = Round(1 + colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox07 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 7 (left middle):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- right middle start
	startRow = math.ceil(gridHeight / 2 - middleHeight / baseGrid * gridSize + 1)
	endRow = math.ceil(gridHeight / 2 + middleHeight / baseGrid * gridSize - 1)
	startCol = Round(gridWidth - boxWidth / baseGrid * gridSize + 1 - colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox08 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 8 (right middle):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- DEFINE START LOCATIONS
	startPosition01 = MakeStartArea(1, startBox01.startRow, startBox01.endRow, startBox01.startCol, startBox01.endCol, {5, 7})
	startPosition02 = MakeStartArea(2, startBox02.startRow, startBox02.endRow, startBox02.startCol, startBox02.endCol, {6, 8})
	startPosition03 = MakeStartArea(3, startBox03.startRow, startBox03.endRow, startBox03.startCol, startBox03.endCol, {6, 7})
	startPosition04 = MakeStartArea(4, startBox04.startRow, startBox04.endRow, startBox04.startCol, startBox04.endCol, {5, 8})
	startPosition05 = MakeStartArea(5, startBox05.startRow, startBox05.endRow, startBox05.startCol, startBox05.endCol, {1, 4})
	startPosition06 = MakeStartArea(6, startBox06.startRow, startBox06.endRow, startBox06.startCol, startBox06.endCol, {2, 3})
	startPosition07 = MakeStartArea(7, startBox07.startRow, startBox07.endRow, startBox07.startCol, startBox07.endCol, {1, 3})
	startPosition08 = MakeStartArea(8, startBox08.startRow, startBox08.endRow, startBox08.startCol, startBox08.endCol, {2, 4})
	
	local startPositionsTable = {startPosition01, startPosition02, startPosition03, startPosition04, startPosition05, startPosition06, startPosition07, startPosition08}
	
	return startPositionsTable
	
end

--- MAKE START POSITIONS TABLE CLOSE
-- creates start positions that are closer together than the defualt ring of positions for players preferring aggressive play
function MakeStartPositionsTableClose(gridWidth, gridHeight, gridSize)
	
	-- tunables
	local baseGrid = 13
	local rowBorder = 2
	local boxHeight = 2
	local colBorder = 2
	local boxWidth = 2
	local middleWidth = 1
	local middleHeight = 1
	
	-- top left corner start
	startRow = Round(1 + rowBorder / baseGrid * gridSize, 0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = Round(1 + colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox01 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 1 (top left):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- bottom right corner start
	startRow = Round(gridHeight - boxHeight / baseGrid * gridSize + 1 - rowBorder / baseGrid * gridSize, 0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = Round(gridWidth - boxWidth / baseGrid * gridSize + 1 - colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox02 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 2 (bottom right):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- bottom left corner start
	startRow = Round(gridHeight - boxHeight / baseGrid * gridSize + 1 - rowBorder / baseGrid * gridSize, 0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = Round(1 + colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox03 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 3 (bottom left):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- top right corner start
	startRow = Round(1 + rowBorder / baseGrid * gridSize,0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = Round(gridWidth - boxWidth / baseGrid * gridSize + 1 - colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox04 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 4 (top right):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- top middle start
	startRow = Round(1 + rowBorder / baseGrid * gridSize, 0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = math.ceil(gridWidth / 2 - middleWidth / baseGrid * gridSize + 1)
	endCol = math.ceil(gridWidth / 2 + middleWidth / baseGrid * gridSize - 1)
	startBox05 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 5 (top middle):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- bottom middle start
	startRow = Round(gridHeight - boxHeight / baseGrid * gridSize + 1 - rowBorder / baseGrid * gridSize, 0)
	endRow = Round(startRow + boxHeight / baseGrid * gridSize - 1, 0)
	startCol = math.ceil(gridWidth / 2 - middleWidth / baseGrid * gridSize + 1)
	endCol = math.ceil(gridWidth / 2 + middleWidth / baseGrid * gridSize - 1)
	startBox06 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 6 (bottom middle):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- left middle start
	startRow = math.ceil(gridHeight / 2 - middleHeight / baseGrid * gridSize + 1)
	endRow = math.ceil(gridHeight / 2 + middleHeight / baseGrid * gridSize - 1)
	startCol = Round(1 + colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox07 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 7 (left middle):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- right middle start
	startRow = math.ceil(gridHeight / 2 - middleHeight / baseGrid * gridSize + 1)
	endRow = math.ceil(gridHeight / 2 + middleHeight / baseGrid * gridSize - 1)
	startCol = Round(gridWidth - boxWidth / baseGrid * gridSize + 1 - colBorder / baseGrid * gridSize, 0)
	endCol = Round(startCol + boxWidth / baseGrid * gridSize - 1, 0)
	startBox08 = { startRow = startRow, endRow = endRow, startCol = startCol, endCol = endCol}
	print("START BOX 8 (right middle):  start row: " ..startRow .." end row: " ..endRow .." start col: " ..startCol .." end col: " ..endCol)
	
	-- DEFINE START LOCATIONS
	startPosition01 = MakeStartArea(1, startBox01.startRow, startBox01.endRow, startBox01.startCol, startBox01.endCol, {5, 7})
	startPosition02 = MakeStartArea(2, startBox02.startRow, startBox02.endRow, startBox02.startCol, startBox02.endCol, {6, 8})
	startPosition03 = MakeStartArea(3, startBox03.startRow, startBox03.endRow, startBox03.startCol, startBox03.endCol, {6, 7})
	startPosition04 = MakeStartArea(4, startBox04.startRow, startBox04.endRow, startBox04.startCol, startBox04.endCol, {5, 8})
	startPosition05 = MakeStartArea(5, startBox05.startRow, startBox05.endRow, startBox05.startCol, startBox05.endCol, {1, 4})
	startPosition06 = MakeStartArea(6, startBox06.startRow, startBox06.endRow, startBox06.startCol, startBox06.endCol, {2, 3})
	startPosition07 = MakeStartArea(7, startBox07.startRow, startBox07.endRow, startBox07.startCol, startBox07.endCol, {1, 3})
	startPosition08 = MakeStartArea(8, startBox08.startRow, startBox08.endRow, startBox08.startCol, startBox08.endCol, {2, 4})
	
	local startPositionsTable = {startPosition01, startPosition02, startPosition03, startPosition04, startPosition05, startPosition06, startPosition07, startPosition08}
	
	return startPositionsTable
	
end




