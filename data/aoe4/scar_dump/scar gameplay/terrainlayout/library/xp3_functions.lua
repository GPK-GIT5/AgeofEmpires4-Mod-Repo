-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

--RemoveNearbyOpenCoords() adds new candidates to the closedCoordList table where neighbor tiles are off limits and within the openCoordList
--row (int) the row coordinate
--col (int) the col coordinate
--closedCoordList (table) list of closed coordinates i.e. coordinates that are no longer considered
--openCoordList (table) list of open coordinates to work with
function RemoveNearbyOpenCoords(row, col, closedCoordList, openCoordList)
	
	coords = {}
	table.insert(coords, { y = row, x = col })
	neighborsTooClose = GetNeighbors(row, col, terrainLayoutResult)
	
	for i, v in ipairs(neighborsTooClose) do
		currentRow = v.x
		currentCol = v.y
		
		neighborTileIndex = GetIndexFromTableCoord(currentRow, currentCol, openCoordList)
		if (neighborTileIndex ~= nil) then
		    table.insert(coords, { y = currentRow, x = currentCol })
		end
		
	end
    
	for i, v in ipairs(coords) do
		table.insert(closedCoordList, { y = v.y, x = v.x })
	end
	
	return closedCoordList
	
end



--GetRandomFromOpenCoordList() returns a random row and a random col from a table
--openCoordList (table) list of coordinates to pick randomly
function GetRandomFromOpenCoordList(openCoordList)
	
	randomIndex = math.ceil(worldGetRandom() * #openCoordList)
	
	if (randomIndex == 0) then
		return
	end
	
	randomRow = openCoordList[randomIndex].y
	randomCol = openCoordList[randomIndex].x
	
	return randomRow, randomCol
	
end



--GetNextFromOpenCoordList() returns the next row and col from a table
--openCoordList (table) list of coordinates
function GetNextFromOpenCoordList(openCoordList)
	
	nextIndex = next(openCoordList, nil)
	
	if (nextIndex == nil) then
		return
	end
	
	nextRow = openCoordList[nextIndex].y
	nextCol = openCoordList[nextIndex].x
	
	return nextRow, nextCol

end



--GetRightAngleDirections() returns the two random directions to draw a right angle from the startRow and startCol coords and where it can draw based on length parameters
--startRow (int) the starting row coordinate
--startCol (int) the starting col coordinate
--height (int) up/down drawn length
--width (int) left/right drawn length
--openCoordList (table) the table where we want to draw right angles
function GetRightAngleDirections(startRow, startCol, height, width, openCoordList)
	
	--Which direction can we go first? Random 4 directions: up (1), right (2), down (3), left (4)
	--Which direction can we go second? Random 2 directions based on first direction
		
	--If Y is 1,3 (up or down), determine X 2,4 (right or left)
	--If X is 2,4 (right or left), determine Y 1,3 (up or down)
		
	--If first or second direction fails, retry a new coordinate and start over
	
	firstDirectionCandidates = {
		[1] = { direction = 1, length = height },
		[2] = { direction = 2, length = width },
		[3] = { direction = 3, length = height },
		[4] = { direction = 4, length = width }
	}
	
	::determineFirstDirection::
	
	--unable to find a first direction for this coordinate, exit
	if (next(firstDirectionCandidates) == nil) then
		return nil
	end
	
	--prep directional keys for random selection
	firstDirectionKeys = {}
	for k, v in pairs(firstDirectionCandidates) do
		table.insert(firstDirectionKeys, k)
	end
	
	firstDirection = GetRandomElement(firstDirectionKeys)
	
	--conditionals below determines if the direction can be drawn based on set length
	--if it cannot draw in direction, we lower the length minus one and try again
	
	--up
	if (firstDirection == 1) then
		for row = startRow, startRow - firstDirectionCandidates[firstDirection].length, -1 do
			if (Table_ContainsCoordinate(openCoordList, { y = row, x = startCol }) == false) then
				--try smaller length
				firstDirectionCandidates[firstDirection].length = firstDirectionCandidates[firstDirection].length - 1
				
				--remove direction candidate if too small
				if (firstDirectionCandidates[firstDirection].length < 1) then
					firstDirectionCandidates[firstDirection] = nil
				end
				
				goto determineFirstDirection
				break
			end
			
			--the last coord for first direction, set the starting second direction coord
			if (row == startRow - firstDirectionCandidates[firstDirection].length) then
				secondDirectionStartRow = row
				secondDirectionStartCol = startCol
			end
			
		end
	--right
	elseif (firstDirection == 2) then
		for col = startCol, startCol + firstDirectionCandidates[firstDirection].length, 1 do
			if (Table_ContainsCoordinate(openCoordList, { y = startRow, x = col }) == false) then
				--try smaller length
				firstDirectionCandidates[firstDirection].length = firstDirectionCandidates[firstDirection].length - 1
				
				if (firstDirectionCandidates[firstDirection].length < 1) then
					firstDirectionCandidates[firstDirection] = nil
				end
				
				goto determineFirstDirection
				break
			end
			
			if (col == startCol + firstDirectionCandidates[firstDirection].length) then
				secondDirectionStartRow = startRow
				secondDirectionStartCol = col
			end
			
		end
	--down
	elseif (firstDirection == 3) then
		for row = startRow, startRow + firstDirectionCandidates[firstDirection].length, 1 do
			if (Table_ContainsCoordinate(openCoordList, { y = row, x = startCol }) == false) then
				--try smaller length
				firstDirectionCandidates[firstDirection].length = firstDirectionCandidates[firstDirection].length - 1
				
				if (firstDirectionCandidates[firstDirection].length < 1) then
					firstDirectionCandidates[firstDirection] = nil
				end
				
				goto determineFirstDirection
				break
			end
			
			if (row == startRow + firstDirectionCandidates[firstDirection].length) then
				secondDirectionStartRow = row
				secondDirectionStartCol = startCol
			end
			
		end
	--left
	elseif (firstDirection == 4) then
		for col = startCol, startCol - firstDirectionCandidates[firstDirection].length, -1 do
			if (Table_ContainsCoordinate(openCoordList, { y = startRow, x = col }) == false) then
				firstDirectionCandidates[firstDirection].length = firstDirectionCandidates[firstDirection].length - 1
				
				if (firstDirectionCandidates[firstDirection].length < 1) then
					firstDirectionCandidates[firstDirection] = nil
				end			
				
				goto determineFirstDirection
				break
			end
			
			if (col == startCol - firstDirectionCandidates[firstDirection].length) then
				secondDirectionStartRow = startRow
				secondDirectionStartCol = col
			end
			
		end
	end
	
	--determine second direction candidates based off first direction
	secondDirectionCandidates = {}
	--if first direction is up or down, left and right are second directions
	if (firstDirection == 1 or firstDirection == 3) then
		secondDirectionCandidates = {
			[2] = { direction = 2, length = width },
			[4] = { direction = 4, length = width }
		}
	end
	
	--if first direction is right or left, up and down are second directions
	if (firstDirection == 2 or firstDirection == 4) then
		secondDirectionCandidates = {
			[1] = { direction = 1, length = height },
			[3] = { direction = 3, length = height }
		}
	end
	
	::determineSecondDirection::
	
	--unable to find a second direction under selected first direction, try a new first direction
	if (next(secondDirectionCandidates) == nil) then
		firstDirectionCandidates[firstDirection] = nil
		goto determineFirstDirection
	end
	
	--prep directional keys for random selection
	secondDirectionKeys = {}
	for k, v in pairs(secondDirectionCandidates) do
		table.insert(secondDirectionKeys, k)
	end
	
	secondDirection = GetRandomElement(secondDirectionKeys)
	
	--conditionals below determine if the second direction can draw based on set length
	--if it cannot draw in direction, we lower the length minus one and try again
	
	--up
	if (secondDirection == 1) then
		for row = secondDirectionStartRow, secondDirectionStartRow - secondDirectionCandidates[secondDirection].length, -1 do
			if (Table_ContainsCoordinate(openCoordList, { y = row, x = secondDirectionStartCol }) == false) then
				--try smaller length
				secondDirectionCandidates[secondDirection].length = secondDirectionCandidates[secondDirection].length - 1
				
				--remove direction candidate if too small
				if (secondDirectionCandidates[secondDirection].length < 1) then
					secondDirectionCandidates[secondDirection] = nil
				end
				
				goto determineSecondDirection
				break
			end
		end
	--right
	elseif (secondDirection == 2) then
		for col = secondDirectionStartCol, secondDirectionStartCol + secondDirectionCandidates[secondDirection].length, 1 do
			if (Table_ContainsCoordinate(openCoordList, { y = secondDirectionStartRow, x = col }) == false) then
				
				secondDirectionCandidates[secondDirection].length = secondDirectionCandidates[secondDirection].length - 1
				
				if (secondDirectionCandidates[secondDirection].length < 1) then
					secondDirectionCandidates[secondDirection] = nil
				end
				
				goto determineSecondDirection
				break
			end
		end
	--down
	elseif (secondDirection == 3) then
		for row = secondDirectionStartRow, secondDirectionStartRow + secondDirectionCandidates[secondDirection].length, 1 do
			if (Table_ContainsCoordinate(openCoordList, { y = row, x = secondDirectionStartCol }) == false) then

				secondDirectionCandidates[secondDirection].length = secondDirectionCandidates[secondDirection].length - 1
				
				if (secondDirectionCandidates[secondDirection].length < 1) then
					secondDirectionCandidates[secondDirection] = nil
				end

				goto determineSecondDirection
				break
			end
		end
	--left
	elseif (secondDirection == 4) then
		for col = secondDirectionStartCol, secondDirectionStartCol - secondDirectionCandidates[secondDirection].length, -1 do
			if (Table_ContainsCoordinate(openCoordList, { y = secondDirectionStartRow, x = col }) == false) then
				
				secondDirectionCandidates[secondDirection].length = secondDirectionCandidates[secondDirection].length - 1
				
				if (secondDirectionCandidates[secondDirection].length < 1) then
					secondDirectionCandidates[secondDirection] = nil
				end
				
				goto determineSecondDirection
				break
			end
		end
	end
	
	return firstDirectionCandidates[firstDirection], secondDirectionCandidates[secondDirection]
	
end



--CreateRightAngle() draws the right angle within the openCoordList
--lengths (table) first index is up/down length, and second index is right/left length e.g. { 2, 4 } (2 up/down length, 4 right/left length)
--startingCoords (table) first index is starting row, and second index is starting col e.g. { 2, 1 } (2 row, 1 col)
--directions (table) first index is first direction, and second index is second direction e.g. { 2, 3 } (right and down)
--angleAgletTerrain (tt) terrainType at both ends of the right angle e.g. a hill for example that meets with a plateau terrain
--angleTerrain (tt) terrainType of the right angle
--additionalAglet (bool) true/false to add an additional aglet near the starting second direction to create less chokepoints
--openCoordList (table) coords that are available to make an attempt to draw the right angle
function CreateRightAngle(lengths, startingCoords, directions, angleAgletTerrain, angleTerrain, additionalAglet, openCoordList)
	
	if (#lengths ~= 2) then
		print('CreateRightAngle() - invalid lengths param - exit')
		return
	end
	
	--up/down height
	height = lengths[1]
	
	--right/left width
	width = lengths[2]
	
	if (#startingCoords ~= 2) then
		print('CreateRightAngle() - invalid startingCoords param - exit')
		return
	end
	
	--the starting coordinates
	startRow = startingCoords[1]
	startCol = startingCoords[2]
	
	if (#directions ~= 2) then
		print('CreateRightAngle() - invalid directions param - exit')
		return
	end
	
	firstDirection = directions[1]
	secondDirection = directions[2]
	
	if (firstDirection == nil or secondDirection == nil) then
		return
	end
	
	--first direction
	
	--up
	if (firstDirection == 1) then
		endRow = startRow - height
		endCol = startCol
		incrementRow= -1
	end
	
	--right
	if (firstDirection == 2) then
		endRow = startRow
		endCol = startCol + height
		incrementCol = 1
	end
	
	--down
	if (firstDirection == 3) then
		endRow = startRow + height
		endCol = startCol
		incrementRow = 1
	end
	
	--left
	if (firstDirection == 4) then
		endRow = startRow
		endCol = startCol - height
		incrementCol = -1
	end
	
	--second directions, starts from the end of the first direction
	
	--up
	if (secondDirection == 1) then
		secondDirectionEndRow = endRow - width
		secondDirectionIncrementRow = -1
	end
	
	--right
	if (secondDirection == 2) then
		secondDirectionEndCol = endCol + width
		secondDirectionIncrementCol = 1
	end
	
	--down
	if (secondDirection == 3) then
		secondDirectionEndRow = endRow + width
		secondDirectionIncrementRow = 1
	end
	
	--left
	if (secondDirection == 4) then
		secondDirectionEndCol = endCol - width
		secondDirectionIncrementCol = -1
	end
	
	--store the closed coordinates, after drawing the right angle, closedCoordList is returned in this function
	closedCoordList = {}
		
	--first direction up/down
	if (firstDirection == 1 or firstDirection == 3) then
		for row = startRow, endRow, incrementRow do
			if (Table_ContainsCoordinate(openCoordList, { y = row, x = startCol })) then
				if (row == startRow) then
					terrainLayoutResult[row][startCol].terrainType = angleAgletTerrain
				else
					terrainLayoutResult[row][startCol].terrainType = angleTerrain
				end
				
				--adds coordinate to closedCoordList
				RemoveNearbyOpenCoords(row, startCol, closedCoordList, openCoordList)
				
			end
		end
		
		--second direction starts from the end of the first direction
		if (Table_ContainsCoordinate(openCoordList, { y = endRow, x = startCol })) then
			secondDirectionStartRow = endRow
			secondDirectionStartCol = startCol
		end
		
	end
	
	--first direction left/right
	if (firstDirection == 2 or firstDirection == 4) then
		for col = startCol, endCol, incrementCol do
			if (Table_ContainsCoordinate(openCoordList, { y = startRow, x = col })) then
				if (col == startCol) then
					terrainLayoutResult[startRow][col].terrainType = angleAgletTerrain
				else
					terrainLayoutResult[startRow][col].terrainType = angleTerrain
				end
				
				--adds coordinate to closedCoordList
				RemoveNearbyOpenCoords(startRow, col, closedCoordList, openCoordList)
				
			end
		end
		
		--second direction starts from the end of the first direction
		if (Table_ContainsCoordinate(openCoordList, { y = startRow, x = endCol })) then
			secondDirectionStartRow = startRow
			secondDirectionStartCol = endCol
		end
		
	end
	
	--second direction picks up where first direction left off
	
	--second direction up/down
	if (secondDirectionStartRow ~= nil and (secondDirection == 1 or secondDirection == 3)) then
		for row = secondDirectionStartRow, secondDirectionEndRow, secondDirectionIncrementRow do
			if (Table_ContainsCoordinate(openCoordList, { y = row, x = secondDirectionStartCol })) then
				if (row == secondDirectionEndRow) then
					terrainLayoutResult[row][secondDirectionStartCol].terrainType = angleAgletTerrain
				else
					terrainLayoutResult[row][secondDirectionStartCol].terrainType = angleTerrain
				end
				
				--adds coordinate to closedCoordList
				RemoveNearbyOpenCoords(row, secondDirectionStartCol, closedCoordList, openCoordList)
				
			end
		end
	end
	
	--second direction left/right
	if (secondDirectionStartCol ~= nil and (secondDirection == 2 or secondDirection == 4)) then
		for col = secondDirectionStartCol, secondDirectionEndCol, secondDirectionIncrementCol do
			if (Table_ContainsCoordinate(openCoordList, { y = secondDirectionStartRow, x = col })) then
				if (col == secondDirectionEndCol) then
					terrainLayoutResult[secondDirectionStartRow][col].terrainType = angleAgletTerrain
				else
					terrainLayoutResult[secondDirectionStartRow][col].terrainType = angleTerrain
				end
				
				--adds coordinate to closedCoordList
				RemoveNearbyOpenCoords(secondDirectionStartRow, col, closedCoordList, openCoordList)
				
			end
		end
	end
	
	--additional aglet terrain tile added on the outside corner of the right angle
	--useful in using a hill that meets a plateau to make a map be more open and be less closed off
	if (additionalAglet == true and secondDirectionStartRow ~= nil and secondDirectionStartCol ~= nil) then
		
		--get potential aglet positions from the second direction starting coordinate
		potentialAglets = GetNeighbors(secondDirectionStartRow, secondDirectionStartCol, terrainLayoutResult)
		
		for i, v in ipairs(potentialAglets) do
			currentRow = v.x
			currentCol = v.y
			currentTerrainType = terrainLayoutResult[currentRow][currentCol].terrainType
			--don't draw aglet on existing terrain
			if (currentTerrainType ~= angleTerrain and currentTerrainType ~= angleAgletTerrain) then
				agletRow = currentRow
				agletCol = currentCol
			end
		end
		
		if (agletRow ~= nil and agletCol ~= nil) then
			terrainLayoutResult[agletRow][agletCol].terrainType = angleAgletTerrain
			--adds coordinate to closedCoordList
			RemoveNearbyOpenCoords(agletRow, agletCol, closedCoordList, openCoordList)
		end
		
	end
	
	return closedCoordList
	
end



--CreateMultipleRightAngles() a function that draws as many random right angles as possible in a openCoordList
--minLength (int) minimum length of drawn right angle
--maxLength (int) maximum length of drawn right angle
--count (int) the number of right angles to attempt to draw
--angleAgletTerrain (tt) terrainType at both ends of the right angle e.g. a hill ramp that connects to a plateau terrain
--angleTerrain (tt) terrainType of the right angle e.g. a plateau terrain
--additionalAglet (bool) true/false to add an additional aglet near the second direction starting point of the longest right angles to create less chokepoints
--getRandom (bool) if true, right angle coordinates are picked randomly within an open list, if false the next coord in the openCoordList is used
--openCoordList (table) coords that are available to draw the right angle
function CreateMultipleRightAngles(minLength, maxLength, count, angleAgletTerrain, angleTerrain, additionalAglet, getRandom, openCoordList)
	
	closedCoordList = {}
	
	while(#openCoordList > 0) do
		
		::attemptRightAngleRestart::
		
		--draw length random between min and max
		--up/down height
		height = math.floor(worldGetRandom() * (maxLength - minLength + 1) + minLength) - 1
		
		--left/right width
		width = math.floor(worldGetRandom() * (maxLength - minLength + 1) + minLength) - 1
		
		--get the next starting coordinate from openCoordList
		if (getRandom == true) then
			startRow, startCol = GetRandomFromOpenCoordList(openCoordList)
		else
			startRow, startCol = GetNextFromOpenCoordList(openCoordList)
		end
		
		--unable to retrieve random starting coordinate from openCoordList, exit
		if (startRow == nil or startCol == nil) then
			return
		end
		
		--find first and second directions the right angle can be drawn
		firstDirectionCandidates, secondDirectionCandidates = GetRightAngleDirections(startRow, startCol, height, width, openCoordList)
		
		--cannot find a first or second direction candidate, remove coord from the openCoordList
		if (firstDirectionCandidates == nil or secondDirectionCandidates == nil) then
			closedIndex = GetIndexFromTableCoord(startRow, startCol, openCoordList)
			if (closedIndex ~= nil) then
				table.remove(openCoordList, closedIndex)
			end
			goto attemptRightAngleRestart
		end
		
		--only adds aglet if true, and any of the two directions are max length
		agletMaxLength = maxLength - 1
		if (additionalAglet == true and (firstDirectionCandidates.length == agletMaxLength or secondDirectionCandidates.length == agletMaxLength)) then
			createAdditionalAglet = true
		else
			createAdditionalAglet = false
		end
		
		closedCoordList = CreateRightAngle({ firstDirectionCandidates.length, secondDirectionCandidates.length }, { startRow, startCol }, { firstDirectionCandidates.direction, secondDirectionCandidates.direction }, angleAgletTerrain, angleTerrain, createAdditionalAglet, openCoordList)
		
		--remove the coords in closedCoordList from openCoordList
		for i, v in ipairs(closedCoordList) do
			closedIndex = GetIndexFromTableCoord(v.y, v.x, openCoordList)
			if (closedIndex ~= nil) then
				table.remove(openCoordList, closedIndex)
			end
		end
		
	end
	
end

--GetPointsInCircularRadius() returns a table of coords that are evenly spaced in a circle pattern
--centerRow (int) row coordinate that is the center of the circle
--centerCol (int) col coordinate that is the center of the circle
--numberOfPoints (int) how many coordinates to return
--radius (float) the radius of the circle
--rotation (float) the degrees in which to rotate the circle
--terrainGrid (table) the map table you are working within
function GetPointsInCircularRadius(centerRow, centerCol, numberOfPoints, radius, rotation, terrainGrid)
	
	local points = {}
	local center = { y = centerRow, x = centerCol }
	local angleStep = (2 * math.pi) / numberOfPoints
	
	for i = 1, numberOfPoints do
		
		local angle = ((i - 1) * angleStep) + rotation
		local rowCoord = Round(center.y + radius * math.sin(angle))
		local colCoord = Round(center.x + radius * math.cos(angle))
		
		--only return points that are within terrainGrid
		if ((rowCoord > 0 and #terrainGrid >= rowCoord) and (colCoord > 0 and #terrainGrid[1] >= colCoord)) then
			table.insert(points, { y = rowCoord, x = colCoord })
		end
		
	end
	
	return points
	
end


--VoronoiDistance() returns the distance between 2 coords. Option to chose Euclidean or Manhattan distance
--coordA (table) first coordinate { y = row, x = col }
--coordB (table) second coordinate { y = row, x = col }
--useEuclidean (bool) true returns Euclidean distance, false returns Manhattan distance
function VoronoiDistance(coordA, coordB, useEuclidean)
	local distanceRow = coordB.y - coordA.y
	local distanceCol = coordB.x - coordA.x
	
	if (useEuclidean == true) then
		return math.sqrt(distanceCol * distanceCol + distanceRow * distanceRow) --Euclidean Distance
	else
		return math.abs(distanceCol) + math.abs(distanceRow) --Manhattan Distance
	end
end


--CreateVoronoiDiagram() pass a list of points that returns a table of Voronoi cell regions associated with each point e.g. voronoiPoints[i].cells
--voronoiPoints (table) a list point coordinates { y = row, x = col }
--terrainGrid (table) { row, col }
--useEuclidean (bool) true returns Euclidean distance, false returns Manhattan distance
function CreateVoronoiDiagram(voronoiPoints, terrainGrid, useEuclidean)
	
	--each point aka voronoi site
	for i, siteCoords in ipairs(voronoiPoints) do
		
		local site = {}
		voronoiPoints[i].site = siteCoords
		
		--init the cells/squares belonging to a site
		voronoiPoints[i].cells = {}
		
		--iterate every coord in terrainGrid to determine which cell/square belongs to which point
		for j, terrainCoord in ipairs(terrainGrid) do
			
			local row = terrainCoord[1]
			local col = terrainCoord[2]
			
			local currentCoord = { y = row, x = col }
			
			--to keep track of closest site to coordinate
			site[row] = {
				[col] = {
					site = nil
				}
			}
			
			--find the closest site to the current square
			local closestSite = nil
			local closestDistance = 1000
			
			for k, distantCoord in ipairs(voronoiPoints) do
				local distance = VoronoiDistance(currentCoord, distantCoord, useEuclidean)
				
				if (distance < closestDistance) then
					closestSite = distantCoord
					closestDistance = distance
				end
			end
			
			--add the current coord to the cells list if it belongs to the current site and distance
			if (closestSite == siteCoords) and
			(site[row][col].site == nil or closestDistance < VoronoiDistance(currentCoord, site[row][col].site)) then
				
				site[row][col].site = siteCoords
				table.insert(voronoiPoints[i].cells, { y = row, x = col })
				
			end
			
		end
	
	end
	
	return voronoiPoints
	
end