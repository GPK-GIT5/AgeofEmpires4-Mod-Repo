-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--TEMPLATE FUNCTIONS

--The following are functions that are used in the UGC Map Template in order to accomodate various
--procedural functionality

--------------------------------------------------------------------------------------------------------------------

--function Table_ContainsCoordinate checks a table to see if an x, y pair exists within the table already
function Table_ContainsCoordinate(table, value)

	tableHasCoord = false
	
	for index, val in ipairs(table) do
		if (val.x == value.x and val.y == value.y) then
			tableHasCoord = true
		end
	end
	
	return tableHasCoord
end

function Table_ContainsCoordinateIndex(table, value)

	tableHasCoord = false
	
	for index, val in ipairs(table) do
		if (val[1] == value[1] and val[2] == value[2]) then
			tableHasCoord = true
		end
	end
	
	return tableHasCoord
end

--function IsCoordOnMapEdge returns a boolean true if the supplied xy coordinate is on the grid border
function IsCoordOnMapEdge(xLoc, yLoc, gridSize)

	isOnEdge = false
	
	if(xLoc == 1 or xLoc == gridSize or yLoc == 1 or yLoc == gridSize) then
	
		isOnEdge = true
	
	end
	
	return isOnEdge
end

--function GetNeighbors returns a list of all directly adjacent cells in a 2D array-style table
function GetNeighbors(xLoc, yLoc, terrainGrid)

	gridSize = #terrainGrid
	neighbors = {}
	neighborData = {}
	
	--get neighbor above, if not on top row
	if(yLoc < gridSize and yLoc > 0) then
		neighborData = {
		x = xLoc,
		y = yLoc + 1, 
		terrainType = terrainGrid[xLoc][yLoc+1].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	--get neighbor to the right, if not in final column
	if(xLoc < gridSize and xLoc > 0) then
		neighborData = {
		x = xLoc + 1,
		y = yLoc, 
		terrainType = terrainGrid[xLoc+1][yLoc].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	--get neighbor below, if not on bottom row
	if(yLoc > 1 and yLoc <= gridSize) then
		neighborData = {
		x = xLoc,
		y = yLoc - 1, 
		terrainType = terrainGrid[xLoc][yLoc-1].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	--get neighbor to the left, if not in first column
	if(xLoc > 1 and xLoc <= gridSize) then
		neighborData = {
		x = xLoc - 1,
		y = yLoc, 
		terrainType = terrainGrid[xLoc-1][yLoc].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	return neighbors

end

--function GetNeighbors returns a list of all directly adjacent cells in a 2D array-style table
function GetNeighborsOfType(xLoc, yLoc, checkTerrainTypes, terrainGrid)

	gridSize = #terrainGrid
	neighbors = {}
	neighborData = {}
	
	--get neighbor above, if not on top row
	if(xLoc < gridSize and xLoc > 0) then
		neighborData = {
		x = xLoc + 1,
		y = yLoc, 
		terrainType = terrainGrid[xLoc+1][yLoc].terrainType
		}
		matchesType = false
		for terrainIndex = 1, #checkTerrainTypes do
			if(terrainGrid[xLoc+1][yLoc].terrainType == checkTerrainTypes[terrainIndex]) then
				matchesType = true
				break
			end
		end
		if(matchesType == true) then
			table.insert(neighbors, neighborData)
		end
		
	end
	
	--get neighbor to the right, if not in final column
	if(yLoc < gridSize and yLoc > 0) then
		neighborData = {
		x = xLoc,
		y = yLoc + 1, 
		terrainType = terrainGrid[xLoc][yLoc+1].terrainType
		}
		matchesType = false
		for terrainIndex = 1, #checkTerrainTypes do
			if(terrainGrid[xLoc][yLoc+1].terrainType == checkTerrainTypes[terrainIndex]) then
				matchesType = true
				break
			end
		end
		if(matchesType == true) then
			table.insert(neighbors, neighborData)
		end
	end
	
	--get neighbor below, if not on bottom row
	if(xLoc > 1 and xLoc <= gridSize) then
		neighborData = {
		x = xLoc - 1,
		y = yLoc, 
		terrainType = terrainGrid[xLoc-1][yLoc].terrainType
		}
		matchesType = false
		for terrainIndex = 1, #checkTerrainTypes do
			if(terrainGrid[xLoc-1][yLoc].terrainType == checkTerrainTypes[terrainIndex]) then
				matchesType = true
				break
			end
		end
		if(matchesType == true) then
			table.insert(neighbors, neighborData)
		end
	end
	
	--get neighbor to the left, if not in first column
	if(yLoc > 1 and yLoc <= gridSize) then
		neighborData = {
		x = xLoc,
		y = yLoc - 1, 
		terrainType = terrainGrid[xLoc][yLoc-1].terrainType
		}
		matchesType = false
		for terrainIndex = 1, #checkTerrainTypes do
			if(terrainGrid[xLoc][yLoc-1].terrainType == checkTerrainTypes[terrainIndex]) then
				matchesType = true
				break
			end
		end
		if(matchesType == true) then
			table.insert(neighbors, neighborData)
		end
	end
	
	return neighbors

end

--returns the adjacent and diagonally adjacent points to the target point passed in
function Get8Neighbors(xLoc, yLoc, terrainGrid)
	
	gridSize = #terrainGrid
	neighbors = {}
	neighborData = {}
	
	
	--get neighbor above, if not on top row
	if(yLoc < gridSize and yLoc > 0) then
		neighborData = {
		x = xLoc,
		y = yLoc + 1, 
		terrainType = terrainGrid[xLoc][yLoc+1].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	--get neighbor to the right, if not in final column
	if(xLoc < gridSize and xLoc > 0) then
		neighborData = {
		x = xLoc + 1,
		y = yLoc, 
		terrainType = terrainGrid[xLoc+1][yLoc].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	--get neighbor below, if not on bottom row
	if(yLoc > 1 and yLoc <= gridSize) then
		neighborData = {
		x = xLoc,
		y = yLoc - 1, 
		terrainType = terrainGrid[xLoc][yLoc-1].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	--get neighbor to the left, if not in first column
	if(xLoc > 1 and xLoc <= gridSize) then
		neighborData = {
		x = xLoc - 1,
		y = yLoc, 
		terrainType = terrainGrid[xLoc-1][yLoc].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	--get neighbor above to the right, if not on top row or in final column
	if(yLoc < gridSize and yLoc > 0 and xLoc < gridSize and xLoc > 0) then
		neighborData = {
		x = xLoc + 1,
		y = yLoc + 1, 
		terrainType = terrainGrid[xLoc+1][yLoc+1].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	--get neighbor down to the right, if not in final column or bottom row
	if(xLoc < gridSize and xLoc > 0 and yLoc > 1 and yLoc <= gridSize) then
		neighborData = {
		x = xLoc + 1,
		y = yLoc - 1, 
		terrainType = terrainGrid[xLoc+1][yLoc-1].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	--get neighbor down to the left, if not on bottom row or first column
	if(yLoc > 1 and yLoc <= gridSize and xLoc > 1 and xLoc <= gridSize) then
		neighborData = {
		x = xLoc - 1,
		y = yLoc - 1, 
		terrainType = terrainGrid[xLoc-1][yLoc-1].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	--get neighbor up to the left, if not in first column or top row
	if(xLoc > 1 and xLoc <= gridSize and yLoc < gridSize and yLoc > 0) then
		neighborData = {
		x = xLoc - 1,
		y = yLoc + 1, 
		terrainType = terrainGrid[xLoc-1][yLoc+1].terrainType
		}
		table.insert(neighbors, neighborData)
	end
	
	return neighbors
end


function isPointOnRiver(riverPoints, newRow, newCol)
	
	isOnRiver = false
	
	for index = 1, #riverPoints do
	
		currentRow = riverPoints[index][1]
		currentCol = riverPoints[index][2] 
		
		if(newRow == currentRow and newCol == currentCol) then
			isOnRiver = true		
		end
	end
	
	return isOnRiver
end
	

--function GetNextRiverSquare takes a list of directly adjacent neighbors, the river index and the previous square,
--and finds the next square in the river
function GetNextRiverSquare(neighborList, rIndex, riverList, terrainGrid)
	
	nextSquare = nil
	
	--from neighbor list, find the next river square, ignoring the previous river square
	for index, neighbor in ipairs(neighborList) do
		
		--check for next river square with each neighbor
		if(terrainGrid[neighbor.x][neighbor.y] == rIndex) then
			print("square at " .. neighbor.x .. ", " .. neighbor.y .. " matches river index")
			--check to make sure this neighbor is not the previous square
			if(isPointOnRiver(riverList, neighbor.x, neighbor.y) == false) then
				print("square at " .. neighbor.x .. ", " .. neighbor.y .. " is not already in the river list")
				nextSquare = neighbor
				
			end
		end
	end
	
	return nextSquare
end

function GetNextTerrainSquare(neighborList, rIndex, terrainList, terrainGrid)
	
	nextSquare = nil
	nextSquaresNum = 0
	
	--from neighbor list, find the next river square, ignoring the previous river square
	for index, neighbor in ipairs(neighborList) do
		
		--check for next river square with each neighbor
		if(terrainGrid[neighbor.x][neighbor.y].terrainType == rIndex) then
			print("square at " .. neighbor.x .. ", " .. neighbor.y .. " matches river index")
			--check to make sure this neighbor is not the previous square
			if(isPointOnRiver(terrainList, neighbor.x, neighbor.y) == false) then
				print("square at " .. neighbor.x .. ", " .. neighbor.y .. " is not already in the river list")
				nextSquare = neighbor
				nextSquaresNum = nextSquaresNum + 1
			end
		end
	end
	
	return nextSquare, nextSquaresNum
end

function GetNextTerrainSquares(neighborList, rIndex, terrainList, terrainGrid)
	
	nextSquares = {}
	
	--from neighbor list, find the next river square, ignoring the previous river square
	for index, neighbor in ipairs(neighborList) do
		
		--check for next river square with each neighbor
		if(terrainGrid[neighbor.x][neighbor.y].terrainType == rIndex) then
			print("square at " .. neighbor.x .. ", " .. neighbor.y .. " matches river index")
			--check to make sure this neighbor is not the previous square
			if(isPointOnRiver(terrainList, neighbor.x, neighbor.y) == false) then
				print("square at " .. neighbor.x .. ", " .. neighbor.y .. " is not already in the river list")
				table.insert(nextSquares, neighbor)
			end
		end
	end
	
	return nextSquares
end

--function GetNextRiverSquare takes a list of directly adjacent neighbors, and the previous square,
--and finds the next square in the river
function GetNextRiverSquareNoIndex(neighborList, previousSquare)

	nextSquare = nil
	
	--from neighbor list, find the next river square, ignoring the previous river square
	for index, neighbor in ipairs(neighborList) do
		
		--check for next river square with each neighbor
		if(neighbor.terrainType == tt_river) then
		
			--check to make sure this neighbor is not the previous square
			if(neighbor.x ~= previousSquare.x or neighbor.y ~= previousSquare.y) then
			--Table_ContainsCoordinate(neighbor, previousSquare) == false)
		
				nextSquare = neighbor
			end
		end
	end
	
	return nextSquare
end

--function ChartRiver will find the specified river from the coarse grid and record its path
--for the map generation system. 
function ChartRiver(tributaryIndex, startingCoord, terrainTable)
	
	--define table to save river points
	riverPoints = {}
	
	startRow = startingCoord[1]
	startCol = startingCoord[2]
	
	--assign the first river square to the start of the river points list
	table.insert(riverPoints, {startRow, startCol})
	
	--start at first edge point, find neighbors
	startingNeighbors = GetNeighbors(startRow, startCol, terrainTable)
	
	currentRiverSquare = nil
	previousRiverSquare = {
	x = startRow, 
	y = startCol
	}
	
	--from neighbor list, find the next river square, ignoring the previous river square
	for index, neighbor in ipairs(startingNeighbors) do
		
		--check for next river square with each neighbor, ensuring that it is the river with the same index
		if(terrainTable[neighbor.x][neighbor.y] == tributaryIndex) then
			currentRiverSquare = neighbor
		end
	end
	
	--search diagonals if it doesn't find an adjacent river square
	if(currentRiverSquare == nil) then
		startingNeighbors = Get8Neighbors(startRow, startCol, terrainTable)
		
		for index, neighbor in ipairs(startingNeighbors) do
		
			--check for next river square with each neighbor, ensuring that it is the river with the same index
			if(terrainTable[neighbor.x][neighbor.y] == tributaryIndex) then
				currentRiverSquare = neighbor
			end
		end
	end
	
	tempCoord = {
	currentRiverSquare.x, 
	currentRiverSquare.y
	}
	table.insert(riverPoints, tempCoord)
	print("before main loop, previous square is set to " .. previousRiverSquare.x .. ", " .. previousRiverSquare.y)
	print("before main loop, first starting point away from map edge is " .. tempCoord[1] .. ", " .. tempCoord[2])
	
	--loop through rest of river until edge point or other river square is reached
	while(currentRiverSquare ~= nil) do
	
		--get neighbors from current square
		oldRiverSquare = {}
		oldRiverSquare.x = currentRiverSquare.x
		oldRiverSquare.y = currentRiverSquare.y
		currentNeighbors = GetNeighbors(currentRiverSquare.x, currentRiverSquare.y, terrainTable)
		
		--temporarily save the current square to be reassigned as previous later
		tempSquare = currentRiverSquare
		
		--set current to be the next square in the river
		currentRiverSquare = GetNextRiverSquare(currentNeighbors, tributaryIndex, riverPoints, terrainTable)
		
		
		--if you can't find a directly adjacent square, check the diagonals
		if(currentRiverSquare == nil) then
			print("no adjacent neighbor river squares, checking diagonals")
			diagonalNeighbors = Get8Neighbors(oldRiverSquare.x, oldRiverSquare.y, terrainTable)
			
			
			
			--set current to be the next square in the river
			currentRiverSquare = GetNextRiverSquare(diagonalNeighbors, tributaryIndex, riverPoints, terrainTable)
			
			if(currentRiverSquare ~= nil) then
				print("found diagonal river neighbor")
				--temporarily save the current square to be reassigned as previous later
				tempSquare = currentRiverSquare
			end
			
		end
		
		--if the indexed river has no next point, see if there is a square from another river to join with
		if(currentRiverSquare == nil) then
			print("current river square is nil")
			currentRiverSquare = GetNextRiverSquareNoIndex(currentNeighbors, previousRiverSquare)
			
			if(currentRiverSquare ~= nil) then
				print("found another river square on a different river")
				if( terrainTable[currentRiverSquare.x][currentRiverSquare.y] ~= tributaryIndex) then
					--put the coordinates of the current river square in the river point list
					tempCoord = {
					currentRiverSquare.x, 
					currentRiverSquare.y
					}
					table.insert(riverPoints, tempCoord)
					
					print("inserted final square river coord at " .. tempCoord[1] .. ", " .. tempCoord[2])
				end
				
			--check diagonals
			else
				currentRiverSquare = GetNextRiverSquareNoIndex(diagonalNeighbors, previousRiverSquare)
				
				if(currentRiverSquare ~= nil) then
					print("found another river square on a different river")
					if( terrainTable[currentRiverSquare.x][currentRiverSquare.y] ~= tributaryIndex) then
						--put the coordinates of the current river square in the river point list
						tempCoord = {
						currentRiverSquare.x, 
						currentRiverSquare.y
						}
						table.insert(riverPoints, tempCoord)
						
						print("inserted final square river coord at " .. tempCoord[1] .. ", " .. tempCoord[2])
					end
				end
			end
			break
		end
		
		
		--reassign previous square as old current
		previousRiverSquare = tempSquare
		if(previousRiverSquare ~= nil) then
			print("previous river square is now " .. previousRiverSquare.x .. ", " .. previousRiverSquare.y)
		end
		
		
		--make sure that the next square exists
		if(currentRiverSquare ~= nil) then
			--put the coordinates of the current river square in the river point list
			tempCoord = {
			currentRiverSquare.x, 
			currentRiverSquare.y
			}
			table.insert(riverPoints, tempCoord)
			
			print("inserted current square river coord at " .. tempCoord[1] .. ", " .. tempCoord[2])
		
		end
		
		if(currentRiverSquare ~= nil) then
		--check to see if the current river square is the end of the tributary (eg a point on another river)
			if(terrainTable[currentRiverSquare.x][currentRiverSquare.y] ~= tributaryIndex) then
				print("end of tributary found, joining another river")
				currentRiverSquare = nil
			end
		end
		
		
	end
	
	--add this river to the river table to be given to mapgen
	table.insert(riverResult, riverPoints)
	
end


function ChartTerrain(terrainToChart, startingCoord, terrainTable)
	
	--define table to save Terrain points
	terrainPoints = {}
	
	startRow = startingCoord[1]
	startCol = startingCoord[2]
	
	--assign the first Terrain square to the start of the Terrain points list
	table.insert(terrainPoints, {startRow, startCol})
	
	--start at first edge point, find neighbors
	startingNeighbors = GetNeighbors(startRow, startCol, terrainTable)
	
	currentTerrainSquare = nil
	previousTerrainSquare = {
	x = startRow, 
	y = startCol
	}
	
	--from neighbor list, find the next Terrain square, ignoring the previous Terrain square
	for index, neighbor in ipairs(startingNeighbors) do
		
		--check for next Terrain square with each neighbor, ensuring that it is the Terrain with the same index
		if(terrainTable[neighbor.x][neighbor.y].terrainType == terrainToChart) then
			currentTerrainSquare = neighbor
		end
	end
	
	--search diagonals if it doesn't find an adjacent Terrain square
	if(currentTerrainSquare == nil) then
		startingNeighbors = Get8Neighbors(startRow, startCol, terrainTable)
		
		for index, neighbor in ipairs(startingNeighbors) do
		
			--check for next Terrain square with each neighbor, ensuring that it is the Terrain with the same index
			if(terrainTable[neighbor.x][neighbor.y].terrainType == terrainToChart) then
				currentTerrainSquare = neighbor
			end
		end
	end
	
	tempCoord = {
	currentTerrainSquare.x, 
	currentTerrainSquare.y
	}
	table.insert(terrainPoints, tempCoord)
	print("before main loop, previous square is set to " .. previousTerrainSquare.x .. ", " .. previousTerrainSquare.y)
	print("before main loop, first starting point away from map edge is " .. tempCoord[1] .. ", " .. tempCoord[2])
	
	--loop through rest of Terrain until edge point or other Terrain square is reached
	while(currentTerrainSquare ~= nil) do
	
		--get neighbors from current square
		oldTerrainSquare = {}
		oldTerrainSquare.x = currentTerrainSquare.x
		oldTerrainSquare.y = currentTerrainSquare.y
		currentNeighbors = GetNeighbors(currentTerrainSquare.x, currentTerrainSquare.y, terrainTable)
		
		--temporarily save the current square to be reassigned as previous later
		tempSquare = currentTerrainSquare
		
		--set current to be the next square in the Terrain
		currentTerrainSquare = GetNextTerrainSquare(currentNeighbors, terrainToChart, terrainPoints, terrainTable)
		
		
		--if you can't find a directly adjacent square, check the diagonals
		if(currentTerrainSquare == nil) then
			print("no adjacent neighbor Terrain squares, checking diagonals")
			diagonalNeighbors = Get8Neighbors(oldTerrainSquare.x, oldTerrainSquare.y, terrainTable)
			
			
			
			--set current to be the next square in the Terrain
			currentTerrainSquare, nextPotentialSquaresNum = GetNextTerrainSquare(diagonalNeighbors, terrainToChart, terrainPoints, terrainTable)
			
			if(nextPotentialSquaresNum > 1) then
				print("potential next squares: " .. nextPotentialSquaresNum)
				potentialNeighbors = {}
				potentialNeighbors = GetNextTerrainSquares(diagonalNeighbors, terrainToChart, terrainPoints, terrainTable)
				
				for neighborIndex, neighbor in ipairs(potentialNeighbors) do
					
					futureSquares = 0
					currentRow = neighbor.x 
					currentCol = neighbor.y 
					tempDiagonalNeighbors = Get8Neighbors(currentRow, currentCol, terrainTable)
					testPoints = {}
					testPoints = DeepCopy(terrainPoints)
					table.insert(testPoints, {x = currentRow, y = currentCol})
					tempTerrainSquare, futureSquares = GetNextTerrainSquare(tempDiagonalNeighbors, terrainToChart, testPoints, terrainTable)
					
					if(futureSquares > 0) then
						print("future squares: " .. futureSquares)
						currentTerrainSquare = neighbor
					end
					
				end
			end
			
			if(currentTerrainSquare ~= nil) then
				print("found diagonal Terrain neighbor")
				--temporarily save the current square to be reassigned as previous later
				tempSquare = currentTerrainSquare
			end
			
		end
		
		--if the indexed Terrain has no next point, see if there is a square from another Terrain to join with
		if(currentTerrainSquare == nil) then
			print("current Terrain square is nil")
			currentTerrainSquare = GetNextRiverSquareNoIndex(currentNeighbors, previousTerrainSquare)
			
			if(currentTerrainSquare ~= nil) then
				print("found another Terrain square on a different Terrain")
				if( terrainTable[currentTerrainSquare.x][currentTerrainSquare.y].terrainType ~= terrainToChart) then
					--put the coordinates of the current Terrain square in the Terrain point list
					tempCoord = {
					currentTerrainSquare.x, 
					currentTerrainSquare.y
					}
					table.insert(terrainPoints, tempCoord)
					
					print("inserted final square Terrain coord at " .. tempCoord[1] .. ", " .. tempCoord[2])
				end
				
			--check diagonals
			else
				currentTerrainSquare = GetNextRiverSquareNoIndex(diagonalNeighbors, previousTerrainSquare)
				
				if(currentTerrainSquare ~= nil) then
					print("found another Terrain square on a different Terrain")
					if( terrainTable[currentTerrainSquare.x][currentTerrainSquare.y].terrainType ~= terrainToChart) then
						--put the coordinates of the current Terrain square in the Terrain point list
						tempCoord = {
						currentTerrainSquare.x, 
						currentTerrainSquare.y
						}
						table.insert(terrainPoints, tempCoord)
						
						print("inserted final square Terrain coord at " .. tempCoord[1] .. ", " .. tempCoord[2])
					end
				end
			end
			break
		end
		
		
		--reassign previous square as old current
		previousTerrainSquare = tempSquare
		if(previousTerrainSquare ~= nil) then
			print("previous Terrain square is now " .. previousTerrainSquare.x .. ", " .. previousTerrainSquare.y)
		end
		
		
		--make sure that the next square exists
		if(currentTerrainSquare ~= nil) then
			--put the coordinates of the current Terrain square in the Terrain point list
			tempCoord = {
			currentTerrainSquare.x, 
			currentTerrainSquare.y
			}
			table.insert(terrainPoints, tempCoord)
			
			print("inserted current square Terrain coord at " .. tempCoord[1] .. ", " .. tempCoord[2])
		
		end
		
		if(currentTerrainSquare ~= nil) then
		--check to see if the current Terrain square is the end of the tributary (eg a point on another Terrain)
			if(terrainTable[currentTerrainSquare.x][currentTerrainSquare.y].terrainType ~= terrainToChart) then
				print("end of tributary found, joining another Terrain")
				currentTerrainSquare = nil
			end
		end
		
		
	end
	
	return terrainPoints
	
end

--Function GetSetOfSquaresDistanceApart returns a set of squares that are all a minimum distance away from each other
--numOfSquares is how many squares to find and return
--distanceBetweenSquares is how far apart each square needs to be from each other
--squaresToUse is the list of squares to search through
--terrainTable is the terrainLayoutResult
function GetSetOfSquaresDistanceApart(numOfSquares, distanceBetweenSquares, squaresToUse, terrainTable)

	resets = 0
	
--	repeat
		openList = {}
		for i = 1, #squaresToUse do
			table.insert(openList, squaresToUse[i])
		end
		
		startingPointIndex = math.ceil(worldGetRandom() * #squaresToUse)
		startingPoint = squaresToUse[startingPointIndex]
		
		closedList = {}
		
		table.insert(closedList, startingPoint)
		table.remove(openList, startingPointIndex)
		
		
		chosenSquares = 1
		--[[
		attempts = 0
		maxAttempts = #openList * 10
		while(chosenSquares < numOfSquares and #openList > 0 and attempts < maxAttempts) do
			
			currentPointIndex = math.ceil(worldGetRandom() * #openList)
			currentPoint = openList[currentPointIndex]
			
			if(SquaresFarEnoughApartEuclidian(currentPoint[1], currentPoint[2], distanceBetweenSquares, closedList, #terrainTable) == true) then
				table.insert(closedList, currentPoint)
				table.remove(openList, currentPointIndex)
				chosenSquares = chosenSquares + 1
			end
			
			if(chosenSquares == numOfSquares) then
				return closedList
			end
			attempts = attempts + 1
			print("attempt #" .. attempts)
		end
		--]]
		
		--look through squares sequentially, find the furthest square and add it to the list if it is further away then required threshold
	if(numOfSquares >= 2) then
		for numOfSquaresIndex = 2, numOfSquares do
			
			
			
			--create table to hold the minimum distances for all points to any closed list point.
			--select the largest of these values to add to the closed list if above min distance threshold
			currentMinDistances = {}
			
			--go through each point in the openlist to find the point furthest from all closed list points for this index
			for openIndex = 1, #openList do
				
				closestDistance = 10000
				
				currentOpenPoint = openList[openIndex]
				for closedIndex = 1, #closedList do
					
					--get the distance from the current openList member to this closedPoint
					currentClosedPoint = closedList[closedIndex]
					currentDistance = GetDistance(currentOpenPoint[1], currentOpenPoint[2], currentClosedPoint[1], currentClosedPoint[2], 4)
					
					if(currentDistance < closestDistance) then
						currentFurthestIndex = openIndex
						closestDistance = currentDistance
					end
				end
				currentInfo = {}
				currentInfo = {closestDistance, currentFurthestIndex}
				print("inserting distance of " .. closestDistance .. " to currentMinDistances")
				table.insert(currentMinDistances, currentInfo)
				
			end
			print("number of squares in currentMinDistances is " .. #currentMinDistances)
			--sort currentMinDistances by distance, largest first
			table.sort(currentMinDistances, function(a,b) return a[1] > b[1] end)
			
			--check to see if largest distance is greater than the required threshold
			
			if(#currentMinDistances > 0) then
				print("highest min distance after sort is " .. currentMinDistances[1][1])
				if(currentMinDistances[1][1] >= distanceBetweenSquares) then
					--add this point to the closed list
					chosenPointIndex = currentMinDistances[1][2]
					chosenPoint = openList[chosenPointIndex]
					table.insert(closedList, chosenPoint)
					table.remove(openList, chosenPointIndex)
					chosenSquares = chosenSquares + 1
				end
			end
			
		end
		
		--	until resets > 20
	end

	return closedList
end


--Function GetSetOfSquaresDistanceApartFromTable returns a set of squares that are all a minimum distance away from each other, but it uses a table that is already partially filled with valid squares
--The results are also appended to the original table and returned
--numOfSquares is how many squares to find and return
--distanceBetweenSquares is how far apart each square needs to be from each other
--alreadyValid is the table sent with a list of points already considered valid (and it'll append the chosen squares to this table before returning)
--squaresToUse is the list of squares to search through 
--terrainTable is the terrainLayoutResult
function GetSetOfSquaresDistanceApartFromTable(numOfSquares, distanceBetweenSquares, alreadyValid, squaresToUse, terrainTable)

	openList = {}
	closedList = {}
	
	--[[for row = 1, #terrainTable do --cycles through all rows
		for col = 1, #terrainTable do -- cycles through all cols
			if (Table_ContainsCoordinateIndex(squaresToUse, {row, col})) == false then --if it doesn't match a coordinate that already exists
				table.insert(openList, terrainTable[i]) -- then add this as a valid openlist entry
			end 
		end
	end]]

	for i = 1, #squaresToUse do
		row = squaresToUse[i][1]
		col = squaresToUse[i][2]
		print("row is set to " .. row)
		print("col is set to " .. col)
		if (Table_ContainsCoordinateIndex(alreadyValid, {row, col})) == false then --if it doesn't match a coordinate that already exists
			table.insert(openList, squaresToUse[i]) -- then add this as a valid openlist entry
		end 
	end	
	
	for i = 1, #alreadyValid do
		validPoint = alreadyValid[i]
		table.insert(closedList, validPoint) --enters all the squaresToUse into the closed list
	end

	print("the openList contains " .. #openList)
	print("the closedList contains " .. #closedList)
	
	chosenSquares = #alreadyValid
	attempts = 0
	maxAttempts = #openList * 20
	while(chosenSquares < numOfSquares and #openList > 0 and attempts < maxAttempts) do
		
		currentPointIndex = math.ceil(GetRandomInRange(1, #openList))
		currentPoint = openList[currentPointIndex]
		
		print("the currentPointIndex is " .. currentPointIndex)
		print("current point row is " .. openList[currentPointIndex][1])
		print("current point col is " .. currentPoint[2])
		print("terrain table size is " .. #terrainTable)
		
		if(SquaresFarEnoughApartEuclidian(currentPoint[1], currentPoint[2], distanceBetweenSquares, closedList, #terrainTable) == true) then
			table.insert(closedList, currentPoint)
			table.remove(openList, currentPointIndex)
			chosenSquares = chosenSquares + 1
		end
		attempts = attempts + 1
		print("attempt #" .. attempts)
	end

	return closedList
end


function GetSetOfExtraSquaresDistanceApartFromTable(numOfSquares, distanceBetweenSquares, alreadyValid, squaresToUse, terrainTable)

	openList = {}
	closedList = {}
	
	for i = 1, #squaresToUse do
		row = squaresToUse[i][1]
		col = squaresToUse[i][2]
		print("row is set to " .. row)
		print("col is set to " .. col)
		if (Table_ContainsCoordinateIndex(alreadyValid, {row, col})) == false then --if it doesn't match a coordinate that already exists
			table.insert(openList, squaresToUse[i]) -- then add this as a valid openlist entry
		end 
	end	
	
	for i = 1, #alreadyValid do
		validPoint = alreadyValid[i]
		table.insert(closedList, validPoint) --enters all the squaresToUse into the closed list
	end

	print("the openList contains " .. #openList)
	print("the closedList contains " .. #closedList)
	
	chosenSquares = #alreadyValid
	remainingSquares = numOfSquares
	attempts = 0
	maxAttempts = #openList * 20
	while(remainingSquares > 0 and #openList > 0 and attempts < maxAttempts) do
		
		currentPointIndex = math.ceil(GetRandomInRange(1, #openList))
		currentPoint = openList[currentPointIndex]
		
		print("the currentPointIndex is " .. currentPointIndex)
		print("current point row is " .. openList[currentPointIndex][1])
		print("current point col is " .. currentPoint[2])
		print("terrain table size is " .. #terrainTable)
		
		if(SquaresFarEnoughApartEuclidian(currentPoint[1], currentPoint[2], distanceBetweenSquares, closedList, #terrainTable) == true) then
			table.insert(closedList, currentPoint)
			table.remove(openList, currentPointIndex)
			chosenSquares = chosenSquares + 1
			remainingSquares = remainingSquares - 1
		end
		attempts = attempts + 1
		print("attempt #" .. attempts)
	end

	return closedList
end


--The Create Islands function will create a network of islands on an ocean map

--startingPoints are the points that the islands start spreading from. This is a table, and determines the number of islands to create
--pass in a table of {row, col} pairs

--isEqualSize is a bool that controls whether all islands will grow equally. If false, islands can end up varying in size

--land coverage is a float between 0 and 1 saying how much of the map you want covered in land (as opposed to ocean). 1 means that the map will fill as much as it can
--still taking into account the distance between islands and the distance away from the edge that is specified

--distanceBetweenIslands is how many spaces you want to be between island shores

--distance to edge is how much water around the edge of the map you want 

--terrainTable is the passed in terrainLayoutResult
function CreateIslands(startingPoints, isEqualSize, landCoverage, distanceBetweenIslands, distanceToEdge, terrainTable)
	
	islandPoints = {}
	
	numIslands = #startingPoints
	
	local function Table_ContainsCoordinate(table, value)

		tableHasCoord = false
		
		for index, val in ipairs(table) do
			if (val[1] == value[1] and val[2] == value[2]) then
				tableHasCoord = true
			end
		end
		
		return tableHasCoord
	end
	
	--calculate how many max iterations of land expansion to do
	gridSize = #terrainTable
	totalGridSquares = gridSize * gridSize
	landCoverageSquares = math.ceil(landCoverage * totalGridSquares)
	if(landCoverageSquares > totalGridSquares) then
		landCoverageSquares = totalGridSquares
	end
	print("out of " .. totalGridSquares .. " squares, " .. landCoverageSquares .. " will be island squares")
	islandSquaresAdded = 0
	--set up open and closed lists for each island
	openLists = {}
	closedLists = {}
	
	for i = 1, numIslands do
		openLists[i] = {}
		closedLists[i] = {}
		
		--add starting points into each island's openList
		currentPoint = {startingPoints[i][1], startingPoints[i][2]}
		table.insert(openLists[i], currentPoint)
	end
	
	--base case: place initial island points and create their starting open lists
	for i = 1, numIslands do
		
		--add each island's starting point to their respective closed lists, and remove it from the island's openList
		currentStartPoint = openLists[i][1]
		table.insert(closedLists[i], currentStartPoint)
		table.remove(openLists[i], 1)
	end
		
	--base case (cont'd):
	--go back and use the single closed list point to generate potential starting neighbors for each island's initial openList
	--constrained so that each entry in the open list is within the constraints of island and edge proximity
	for i = 1, numIslands do
		
		currentOpenSquare = closedLists[i][1]
		
		currentRow = currentOpenSquare[1]
		currentCol = currentOpenSquare[2]
		
		--get the neighbors of this current square
		currentNeighbors = GetNeighbors(currentOpenSquare[1], currentOpenSquare[2], terrainTable)
		
		--iterate through neighbors of this point
		for neighborIndex, neighbor in ipairs(currentNeighbors) do
			
			isInBounds = false
			currentNeighborRow = neighbor.x 
			currentNeighborCol = neighbor.y 
			
			closestIslandDistance = 10000
			--check the current neighbors for proximity constraints
			--if they are within parameters, add them to the open list
			--check for edge proximity
			if((currentNeighborRow > distanceToEdge and currentNeighborRow <= (gridSize - distanceToEdge)) and (currentNeighborCol > distanceToEdge and currentNeighborCol <= (gridSize - distanceToEdge))) then
				
				--check for other island proximity
				--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
				--also make sure there is more than 1 island
				if(numIslands > 1) then
					for islandIndex = 1, numIslands do
						--don't search the current island
						if(islandIndex ~= i) then
							
							--make sure this island has a closed list with any elements
							if(#closedLists[islandIndex] > 0) then
								
								--loop through this island's closed list and calculate distances to the current potential openList neighbor
								for closedListIndex = 1, #closedLists[islandIndex] do
									
									currentClosedRow = closedLists[islandIndex][closedListIndex][1]
									currentClosedCol = closedLists[islandIndex][closedListIndex][2]
									
									currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
									
									--see if this distance is the new smallest distance
									if(currentClosedDistance < closestIslandDistance) then
										closestIslandDistance = currentClosedDistance
									end
								end
							end
						end
					end
				end
				
				--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
				if(closestIslandDistance >= distanceBetweenIslands) then
					isInBounds = true
				end
				
			end
			
			
			--if the neighbor is within constraints, add it to the openList
			if(isInBounds == true) then
				currentPoint = {currentNeighborRow, currentNeighborCol}
				table.insert(openLists[i], currentPoint)
			end
		end
	end
	
	
	currentIsland = 1
		
	--place number of land squares based on overall land coverage calculated
	for i = 1, landCoverageSquares do
		
		foundSquare = false 
		
		--check to make sure there is an entry in the open list for this island
		if(#openLists[currentIsland] > 0) then
			
			--constrained so that each entry in the open list is within the constraints of island and edge proximity
			currentOpenSquareNum = math.ceil(worldGetRandom() * #openLists[currentIsland])
			currentOpenSquare = openLists[currentIsland][currentOpenSquareNum]
			
			currentRow = currentOpenSquare[1]
			currentCol = currentOpenSquare[2]
			
			--get the neighbors of this current square
			currentNeighbors = GetNeighbors(currentOpenSquare[1], currentOpenSquare[2], terrainTable)
			
			--remove the current open square from the open list and add it to the closed list
			table.remove(openLists[currentIsland], currentOpenSquareNum)
			table.insert(closedLists[currentIsland], currentOpenSquare)
			
			
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				isInBounds = false
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				closestIslandDistance = 10000
				--check the current neighbors for proximity constraints
				--if they are within parameters, add them to the open list
				--check for edge proximity
				if((currentNeighborRow > distanceToEdge and currentNeighborRow <= (gridSize - distanceToEdge)) and (currentNeighborCol > distanceToEdge and currentNeighborCol <= (gridSize - distanceToEdge))) then
					
					--check for other island proximity
					--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
					--also make sure there is more than 1 island
					if(numIslands > 1) then
						for islandIndex = 1, numIslands do
							--don't search the current island
							if(islandIndex ~= currentIsland) then
								
								--make sure this island has a closed list with any elements
								if(#closedLists[islandIndex] > 0) then
									
									--loop through this island's closed list and calculate distances to the current potential openList neighbor
									for closedListIndex = 1, #closedLists[islandIndex] do
										
										currentClosedRow = closedLists[islandIndex][closedListIndex][1]
										currentClosedCol = closedLists[islandIndex][closedListIndex][2]
										
										currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
										
										--see if this distance is the new smallest distance
										if(currentClosedDistance < closestIslandDistance) then
											closestIslandDistance = currentClosedDistance
										end
									end
								end
							end
						end
					end
					
					--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
					if(closestIslandDistance >= distanceBetweenIslands) then
						--make sure the element is not already in the open or closed list
						if(Table_ContainsCoordinate(closedLists[currentIsland], {currentNeighborRow, currentNeighborCol}) == false and Table_ContainsCoordinate(openLists[currentIsland], {currentNeighborRow, currentNeighborCol}) == false) then
							isInBounds = true
						end
					end
					
				end
				
				
				--if the neighbor is within constraints, add it to the openList
				if(isInBounds == true) then
					currentPoint = {currentNeighborRow, currentNeighborCol}
					table.insert(openLists[currentIsland], currentPoint)
					foundSquare = true
					islandSquaresAdded = islandSquaresAdded + 1
				end
			end
		end
		
		
		--create equally sized islands
		if(isEqualSize == true) then
			
			--iterate to next island after land is placed
			currentIsland = currentIsland + 1
			if(currentIsland > numIslands) then
				currentIsland = 1
			end
			
		--create differently sized islands
		else
			--get a random next island to work with
			currentIsland = math.ceil(worldGetRandom() * numIslands)
			
		end
		
		--CHECK THIS LATER: **********************
		--if no land placed, do we redo this iteration? if not, less land than requested will be placed overall
	
		if(foundSquare == false) then
			i = i - 1
		end
	end
	
	print("added " .. islandSquaresAdded .. " squares of land in this islands map")
	
	return closedLists
end


--Function CreateIslandsWeighted creates a network of islands with some having more expansion weight than others, based on a list passed in
--islandData needs to be a table with 2 entries: row, column
--WeightTable is a table of pairs: island # and weight
--Weight is how likely the island is to be picked for expansion
function CreateIslandsWeighted(islandData, weightTable, landCoverage, distanceBetweenIslands, distanceToEdge, terrainTable)
	
	islandPoints = {}
	
	numIslands = #islandData
	
	local function Table_ContainsCoordinate(table, value)

		tableHasCoord = false
		
		for index, val in ipairs(table) do
			if (val[1] == value[1] and val[2] == value[2]) then
				tableHasCoord = true
			end
		end
		
		return tableHasCoord
	end
	
	--calculate how many max iterations of land expansion to do
	gridSize = #terrainTable
	totalGridSquares = gridSize * gridSize
	landCoverageSquares = math.ceil(landCoverage * totalGridSquares)
	if(landCoverageSquares > totalGridSquares) then
		landCoverageSquares = totalGridSquares
	end
	print("out of " .. totalGridSquares .. " squares, " .. landCoverageSquares .. " will be island squares")
	islandSquaresAdded = 0
	--set up open and closed lists for each island
	openLists = {}
	closedLists = {}
	
	for i = 1, numIslands do
		openLists[i] = {}
		closedLists[i] = {}
		
		--add starting points into each island's openList
		currentPoint = {islandData[i][1], islandData[i][2]}
		table.insert(openLists[i], currentPoint)
	end
	
	--base case: place initial island points and create their starting open lists
	for i = 1, numIslands do
		
		--add each island's starting point to their respective closed lists, and remove it from the island's openList
		currentStartPoint = openLists[i][1]
		table.insert(closedLists[i], currentStartPoint)
		table.remove(openLists[i], 1)
	end
		
	--base case (cont'd):
	--go back and use the single closed list point to generate potential starting neighbors for each island's initial openList
	--constrained so that each entry in the open list is within the constraints of island and edge proximity
	for i = 1, numIslands do
		
		currentOpenSquare = closedLists[i][1]
		
		currentRow = currentOpenSquare[1]
		currentCol = currentOpenSquare[2]
		
		--get the neighbors of this current square
		currentNeighbors = GetNeighbors(currentRow, currentCol, terrainTable)
		
		--iterate through neighbors of this point
		for neighborIndex, neighbor in ipairs(currentNeighbors) do
			
			isInBounds = false
			currentNeighborRow = neighbor.x 
			currentNeighborCol = neighbor.y 
			
			closestIslandDistance = 10000
			--check the current neighbors for proximity constraints
			--if they are within parameters, add them to the open list
			--check for edge proximity
			if((currentNeighborRow > distanceToEdge and currentNeighborRow <= (gridSize - distanceToEdge)) and (currentNeighborCol > distanceToEdge and currentNeighborCol <= (gridSize - distanceToEdge))) then
				
				--check for other island proximity
				--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
				--also make sure there is more than 1 island
				if(numIslands > 1) then
					for islandIndex = 1, numIslands do
						--don't search the current island
						if(islandIndex ~= i) then
							
							--make sure this island has a closed list with any elements
							if(#closedLists[islandIndex] > 0) then
								
								--loop through this island's closed list and calculate distances to the current potential openList neighbor
								for closedListIndex = 1, #closedLists[islandIndex] do
									
									currentClosedRow = closedLists[islandIndex][closedListIndex][1]
									currentClosedCol = closedLists[islandIndex][closedListIndex][2]
									
									currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
									
									--see if this distance is the new smallest distance
									if(currentClosedDistance < closestIslandDistance) then
										closestIslandDistance = currentClosedDistance
									end
								end
							end
						end
					end
				end
				
				--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
				if(closestIslandDistance >= distanceBetweenIslands) then
					isInBounds = true
				end
				
			end
			
			
			--if the neighbor is within constraints, add it to the openList
			if(isInBounds == true) then
				currentPoint = {currentNeighborRow, currentNeighborCol}
				table.insert(openLists[i], currentPoint)
			end
		end
	end
	
	
	currentIsland = 1
	
	--set up weighted selection data
	totalWeight = 0
	for i = 1, numIslands do
		
		totalWeight = totalWeight + weightTable[i][2]
	end
		
	--place number of land squares based on overall land coverage calculated
	for i = 1, landCoverageSquares do
		
		foundSquare = false 
		
		--check to make sure there is an entry in the open list for this island
		if(#openLists[currentIsland] > 0) then
			
			--constrained so that each entry in the open list is within the constraints of island and edge proximity
			
			--find the square in the openList to choose to expand to
			
			--rank each member of the current island by distance to the origin
			currentIslandCopy = {}
			for currentIslandPointIndex = 1, #openLists[currentIsland] do
				
				currentInfo = {}
				currentRow = openLists[currentIsland][currentIslandPointIndex][1]
				currentCol = openLists[currentIsland][currentIslandPointIndex][2]
				currentDistance = GetDistance(currentRow, currentCol, closedLists[currentIsland][1][1], closedLists[currentIsland][1][2], 3)
				currentIndex = currentIslandPointIndex
				currentInfo = {currentRow, currentCol, currentDistance, currentIndex}
				
				table.insert(currentIslandCopy, currentInfo)
			end
			
			--sort the island info for smallest distance
			table.sort(currentIslandCopy, function(a,b) return a[3] < b[3] end)
			
			topSelectionThreshold = 0.02
			
			maxRandomSelection = math.ceil(#currentIslandCopy * topSelectionThreshold)
			currentRandomSelection = math.ceil(worldGetRandom() * maxRandomSelection)
			
			currentOpenSquareNum = currentIslandCopy[currentRandomSelection][4]
			--currentOpenSquareNum = math.ceil(worldGetRandom() * #openLists[currentIsland])
			currentOpenSquare = openLists[currentIsland][currentOpenSquareNum]
			
			currentRow = currentOpenSquare[1]
			currentCol = currentOpenSquare[2]
			
			--get the neighbors of this current square
			currentNeighbors = GetNeighbors(currentOpenSquare[1], currentOpenSquare[2], terrainTable)
			
			--remove the current open square from the open list and add it to the closed list
			table.remove(openLists[currentIsland], currentOpenSquareNum)
			table.insert(closedLists[currentIsland], currentOpenSquare)
			
			
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				isInBounds = false
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				closestIslandDistance = 10000
				--check the current neighbors for proximity constraints
				--if they are within parameters, add them to the open list
				--check for edge proximity
				if((currentNeighborRow > distanceToEdge and currentNeighborRow <= (gridSize - distanceToEdge)) and (currentNeighborCol > distanceToEdge and currentNeighborCol <= (gridSize - distanceToEdge))) then
					
					--check for other island proximity
					--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
					--also make sure there is more than 1 island
					if(numIslands > 1) then
						for islandIndex = 1, numIslands do
							--don't search the current island
							if(islandIndex ~= currentIsland) then
								
								--make sure this island has a closed list with any elements
								if(#closedLists[islandIndex] > 0) then
									
									--loop through this island's closed list and calculate distances to the current potential openList neighbor
									for closedListIndex = 1, #closedLists[islandIndex] do
										
										currentClosedRow = closedLists[islandIndex][closedListIndex][1]
										currentClosedCol = closedLists[islandIndex][closedListIndex][2]
										
										currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
										
										--see if this distance is the new smallest distance
										if(currentClosedDistance < closestIslandDistance) then
											closestIslandDistance = currentClosedDistance
										end
									end
								end
							end
						end
					end
					
					--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
					if(closestIslandDistance >= distanceBetweenIslands) then
						--make sure the element is not already in the open or closed list
						if(Table_ContainsCoordinate(closedLists[currentIsland], {currentNeighborRow, currentNeighborCol}) == false and Table_ContainsCoordinate(openLists[currentIsland], {currentNeighborRow, currentNeighborCol}) == false) then
							isInBounds = true
						end
					end
					
				end
				
				
				--if the neighbor is within constraints, add it to the openList
				if(isInBounds == true) then
					currentPoint = {currentNeighborRow, currentNeighborCol}
					table.insert(openLists[currentIsland], currentPoint)
					foundSquare = true
					islandSquaresAdded = islandSquaresAdded + 1
				end
			end
		end
		
		
		--make weighted island selection
		currentWeight = worldGetRandom() * totalWeight
		
		currentSelection = 0
		
		for islandNum = 1, numIslands do
			
			currentSelection = currentSelection + weightTable[islandNum][2]
			
			if(currentWeight < currentSelection) then
				currentIsland = islandNum
				break 
			end
			
		end
		
	
		if(foundSquare == false) then
			i = i - 1
		end
	end
	
	print("added " .. islandSquaresAdded .. " squares of land in this islands map")
	
	return closedLists
end



function CreateIslandsWeightedEven(islandData, equalIslandNum, equalIslandLandPercent, weightTable, landCoverage, distanceBetweenIslands, distanceToEdge, terrainTable)
	
	islandPoints = {}
	
	numIslands = #islandData
	
	local function Table_ContainsCoordinate(table, value)

		tableHasCoord = false
		
		for index, val in ipairs(table) do
			if (val[1] == value[1] and val[2] == value[2]) then
				tableHasCoord = true
			end
		end
		
		return tableHasCoord
	end
	
	--calculate how many max iterations of land expansion to do
	gridSize = #terrainTable
	totalGridSquares = gridSize * gridSize
	landCoverageSquares = math.ceil(landCoverage * totalGridSquares)
	if(landCoverageSquares > totalGridSquares) then
		landCoverageSquares = totalGridSquares
	end
	
	equalLandCoverageSquares = math.ceil(equalIslandLandPercent * landCoverageSquares)
	extraLandCoverageSquares = landCoverageSquares - equalLandCoverageSquares
	print("out of " .. totalGridSquares .. " squares, " .. equalLandCoverageSquares .. " will be player island squares and " .. extraLandCoverageSquares .. " will be extra island squares")
	islandSquaresAdded = 0
	
	extraIslandNum = numIslands - equalIslandNum
	
	--set up open and closed lists for each equal island
	openLists = {}
	closedLists = {}
	
	for i = 1, equalIslandNum do
		openLists[i] = {}
		closedLists[i] = {}
		
		--add starting points into each island's openList
		currentPoint = {islandData[i][1], islandData[i][2]}
		table.insert(openLists[i], currentPoint)
	end
	
	--base case: place initial island points and create their starting open lists
	for i = 1, equalIslandNum do
		
		--add each island's starting point to their respective closed lists, and remove it from the island's openList
		currentStartPoint = openLists[i][1]
		print("placing island " .. i .. "'s start point at " .. currentStartPoint[1] .. ", " .. currentStartPoint[2])
		table.insert(closedLists[i], currentStartPoint)
		table.remove(openLists[i], 1)
	end
		
	--base case (cont'd):
	--go back and use the single closed list point to generate potential starting neighbors for each island's initial openList
	--constrained so that each entry in the open list is within the constraints of island and edge proximity
	for i = 1, equalIslandNum do
		
		currentOpenSquare = closedLists[i][1]
		
		currentRow = currentOpenSquare[1]
		currentCol = currentOpenSquare[2]
		
		--get the neighbors of this current square
		currentNeighbors = GetNeighbors(currentRow, currentCol, terrainTable)
		
		--iterate through neighbors of this point
		for neighborIndex, neighbor in ipairs(currentNeighbors) do
			
			isInBounds = false
			currentNeighborRow = neighbor.x 
			currentNeighborCol = neighbor.y 
			
			closestIslandDistance = 10000
			--check the current neighbors for proximity constraints
			--if they are within parameters, add them to the open list
			--check for edge proximity
			if((currentNeighborRow > distanceToEdge and currentNeighborRow <= (gridSize - distanceToEdge)) and (currentNeighborCol > distanceToEdge and currentNeighborCol <= (gridSize - distanceToEdge))) then
				
				--check for other island proximity
				--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
				--also make sure there is more than 1 island
				if(equalIslandNum > 1) then
					for islandIndex = 1, equalIslandNum do
						--don't search the current island
						if(islandIndex ~= i) then
							
							--make sure this island has a closed list with any elements
							if(#closedLists[islandIndex] > 0) then
								
								--loop through this island's closed list and calculate distances to the current potential openList neighbor
								for closedListIndex = 1, #closedLists[islandIndex] do
									
									currentClosedRow = closedLists[islandIndex][closedListIndex][1]
									currentClosedCol = closedLists[islandIndex][closedListIndex][2]
									
									currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
									
									--see if this distance is the new smallest distance
									if(currentClosedDistance < closestIslandDistance) then
										closestIslandDistance = currentClosedDistance
									end
								end
							end
						end
					end
				end
				
				--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
				if(closestIslandDistance >= distanceBetweenIslands) then
					isInBounds = true
				end
				
			end
			
			
			--if the neighbor is within constraints, add it to the openList
			if(isInBounds == true) then
				currentPoint = {currentNeighborRow, currentNeighborCol}
				table.insert(openLists[i], currentPoint)
			end
		end
	end
	
	
	currentIsland = 1
	
	--set up weighted selection data
	--remove weight elements of original islands, as we want them to be even
	
	for i = equalIslandNum, 1, -1 do
		
		table.remove(weightTable, i)
	end
	totalWeight = 0
	if(#weightTable > 0) then
		for i = 1, extraIslandNum do
			
			totalWeight = totalWeight + weightTable[i][2]
		end
	end
	
	--place number of land squares based on overall land coverage calculated
	for i = 1, equalLandCoverageSquares do
		
		foundSquare = false 
		
		--check to make sure there is an entry in the open list for this island
		if(#openLists[currentIsland] > 0) then
			
			--constrained so that each entry in the open list is within the constraints of island and edge proximity
			currentOpenSquareNum = math.ceil(worldGetRandom() * #openLists[currentIsland])
			currentOpenSquare = openLists[currentIsland][currentOpenSquareNum]
			
			currentRow = currentOpenSquare[1]
			currentCol = currentOpenSquare[2]
			
			--get the neighbors of this current square
			currentNeighbors = GetNeighbors(currentOpenSquare[1], currentOpenSquare[2], terrainTable)
			
			--remove the current open square from the open list and add it to the closed list
			table.remove(openLists[currentIsland], currentOpenSquareNum)
			table.insert(closedLists[currentIsland], currentOpenSquare)
			
			
			--iterate through neighbors of this point
			for neighborIndex, neighbor in ipairs(currentNeighbors) do
				
				isInBounds = false
				currentNeighborRow = neighbor.x 
				currentNeighborCol = neighbor.y 
				
				closestIslandDistance = 10000
				--check the current neighbors for proximity constraints
				--if they are within parameters, add them to the open list
				--check for edge proximity
				if((currentNeighborRow > distanceToEdge and currentNeighborRow <= (gridSize - distanceToEdge)) and (currentNeighborCol > distanceToEdge and currentNeighborCol <= (gridSize - distanceToEdge))) then
					
					--check for other island proximity
					--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
					--also make sure there is more than 1 island
					if(equalIslandNum > 1) then
						for islandIndex = 1, equalIslandNum do
							--don't search the current island
							if(islandIndex ~= currentIsland) then
								
								--make sure this island has a closed list with any elements
								if(#closedLists[islandIndex] > 0) then
									
									--loop through this island's closed list and calculate distances to the current potential openList neighbor
									for closedListIndex = 1, #closedLists[islandIndex] do
										
										currentClosedRow = closedLists[islandIndex][closedListIndex][1]
										currentClosedCol = closedLists[islandIndex][closedListIndex][2]
										
										currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
										
										--see if this distance is the new smallest distance
										if(currentClosedDistance < closestIslandDistance) then
											closestIslandDistance = currentClosedDistance
										end
									end
								end
							end
						end
					end
					
					--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
					if(closestIslandDistance >= distanceBetweenIslands) then
						--make sure the element is not already in the open or closed list
						if(Table_ContainsCoordinate(closedLists[currentIsland], {currentNeighborRow, currentNeighborCol}) == false and Table_ContainsCoordinate(openLists[currentIsland], {currentNeighborRow, currentNeighborCol}) == false) then
							isInBounds = true
						end
					end
					
				end
				
				
				--if the neighbor is within constraints, add it to the openList
				if(isInBounds == true) then
					currentPoint = {currentNeighborRow, currentNeighborCol}
					table.insert(openLists[currentIsland], currentPoint)
					foundSquare = true
					islandSquaresAdded = islandSquaresAdded + 1
				end
			end
		end
		
		
		--until the equalIsland squares are chosen, sequentially add to the islands equally
		if(i < equalLandCoverageSquares) then
			
			--iterate to next island after land is placed
			currentIsland = currentIsland + 1
			if(currentIsland > equalIslandNum) then
				currentIsland = 1
			end
		
		end
	
		if(foundSquare == false) then
			i = i - 1
		end
	end
	
	print("added " .. islandSquaresAdded .. " squares of land in this islands map")
	
	print("creating list of reminaing valid open water squares for extra islands")
	--loop around and find areas to place the remaining extra islands
	if(extraIslandNum > 0) then
		--create list of remaining open water areas to start islands
		extraOpenSquares = {}
		for openRow = 1, #terrainTable do
			for openCol = 1, #terrainTable do
				
				print("checking square " .. openRow .. ", " .. openCol)
				currentSquare = {}
				currentSquare = {openRow, openCol}
				isValid = true
				closestIslandDistance = 10000
				
				--check for inclusion in an already chosen island
				for equalIslandIndex = 1, equalIslandNum do
					if(Table_ContainsCoordinate(closedLists[equalIslandIndex], {openRow, openCol}) == true) then
						isValid = false
					end
				end
				
				--check for edge proximity
				if(isValid == true) then
					if((openRow > distanceToEdge and openRow <= (gridSize - distanceToEdge)) and (openCol > distanceToEdge and openCol <= (gridSize - distanceToEdge))) then
						
						--check for distance to any other island square
						if(equalIslandNum > 1) then
							--loop through existing islands
							for islandIndex = 1, equalIslandNum do
								
								--make sure this island has a closed list with any elements
								if(#closedLists[islandIndex] > 0) then
									
									--loop through this island's closed list and calculate distances to the current potential openList neighbor
									for closedListIndex = 1, #closedLists[islandIndex] do
										
										currentClosedRow = closedLists[islandIndex][closedListIndex][1]
										currentClosedCol = closedLists[islandIndex][closedListIndex][2]
										
										currentClosedDistance = GetDistance(openRow, openCol, currentClosedRow, currentClosedCol, 3)
										
										--see if this distance is the new smallest distance
										if(currentClosedDistance < closestIslandDistance) then
											closestIslandDistance = currentClosedDistance
										end
									end
								end
							end
							
						end
						
						--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
						if(closestIslandDistance >= distanceBetweenIslands) then
							--make sure the element is not already in the open or closed list
							if(Table_ContainsCoordinate(extraOpenSquares, {openRow, openCol}) == true) then
								isValid = false
							end
						end
						
					else
						isValid = false
					end
					
				end
					
				--if isValid is true, then it got through all the checks and is a valid location to put the start of an extra island
				if(isValid == true) then
					table.insert(extraOpenSquares, currentSquare)
					print("valid square found at " .. currentSquare[1] .. ", " .. currentSquare[2])
				end
				
			end
		end
		
		--out of new extraOpenSquares list, pick spots to place extra islands
		for extraIslandIndex = 1, extraIslandNum do
			
			islandAttempts = 0
			
			::retryIsland::
			
			randomSquareIndex = math.ceil(worldGetRandom() * #extraOpenSquares)
			randomSquare = extraOpenSquares[randomSquareIndex]
			currentRandomRow = randomSquare[1]
			currentRandomCol = randomSquare[2]
			newIslandData = {}
			closestIslandDistance = 10000
			--loop through existing islands to check for minimum distance and seed start locations
			for islandIndex = 1, #closedLists do
				
				--make sure this island has a closed list with any elements
				if(#closedLists[islandIndex] > 0) then
					
					--loop through this island's closed list and calculate distances to the current potential openList neighbor
					for closedListIndex = 1, #closedLists[islandIndex] do
						
						currentClosedRow = closedLists[islandIndex][closedListIndex][1]
						currentClosedCol = closedLists[islandIndex][closedListIndex][2]
						
						currentClosedDistance = GetDistance(currentRandomRow, currentRandomCol, currentClosedRow, currentClosedCol, 3)
						
						--see if this distance is the new smallest distance
						if(currentClosedDistance < closestIslandDistance) then
							closestIslandDistance = currentClosedDistance
						end
					end
				end
			end
			
			--if the closest island is still further away than the distance between islands threshold, this square is good to be the start of a new island
			if(closestIslandDistance >= distanceBetweenIslands) then
				
				--add this point to the closed list of islands
				closedLists[#closedLists + 1] = {}
				openLists[#openLists + 1] = {}
				table.insert(closedLists[#closedLists], randomSquare)
				table.insert(openLists[#openLists], randomSquare)
				table.remove(extraOpenSquares, randomSquareIndex)
				print("adding extra island start point at " .. currentRandomRow .. ", " .. currentRandomCol)
			else
				--select a different random point to check distances for
				if(islandAttempts <= 50) then
					islandAttempts = islandAttempts + 1
					table.remove(extraOpenSquares, randomSquareIndex)
					goto retryIsland
				end
			end
			
			
			
		end
		
		--remove the island start points
		--if ((randomPositions == false) and  then 
			--set currentIsland to the island after the equal islands
			currentIsland = equalIslandNum + 1
			print("open squares in first extra island list: " .. #openLists[currentIsland])
			for i = 1, extraLandCoverageSquares do
				
				foundSquare = false 
				
				--check to make sure there is an entry in the open list for this island
				if(openLists[currentIsland] ~= null and #openLists[currentIsland] > 0) then
					
					--constrained so that each entry in the open list is within the constraints of island and edge proximity
					currentOpenSquareNum = math.ceil(worldGetRandom() * #openLists[currentIsland])
					currentOpenSquare = openLists[currentIsland][currentOpenSquareNum]
					
					currentRow = currentOpenSquare[1]
					currentCol = currentOpenSquare[2]
					
					--get the neighbors of this current square
					currentNeighbors = GetNeighbors(currentOpenSquare[1], currentOpenSquare[2], terrainTable)
					
					--remove the current open square from the open list and add it to the closed list
					table.remove(openLists[currentIsland], currentOpenSquareNum)
					if(Table_ContainsCoordinate(closedLists[currentIsland], {currentRow, currentCol}) == false) then
						print("adding point " .. currentRow .. ", " .. currentCol .. " to island " .. currentIsland)
						table.insert(closedLists[currentIsland], currentOpenSquare)
					end
					
					--iterate through neighbors of this point
					for neighborIndex, neighbor in ipairs(currentNeighbors) do
						
						isInBounds = false
						currentNeighborRow = neighbor.x 
						currentNeighborCol = neighbor.y 
						
						closestIslandDistance = 10000
						--check the current neighbors for proximity constraints
						--if they are within parameters, add them to the open list
						--check for edge proximity
						if((currentNeighborRow > distanceToEdge and currentNeighborRow <= (gridSize - distanceToEdge)) and (currentNeighborCol > distanceToEdge and currentNeighborCol <= (gridSize - distanceToEdge))) then
							
							--check for other island proximity
							--loop through other island closed lists and find the shortest distance and make sure it is greater than the distance threshold
							--also make sure there is more than 1 island
							if(equalIslandNum > 1) then
								for islandIndex = 1, #closedLists do
									--don't search the current island
									if(islandIndex ~= currentIsland) then
										
										--make sure this island has a closed list with any elements
										if(#closedLists[islandIndex] > 0) then
											
											--loop through this island's closed list and calculate distances to the current potential openList neighbor
											for closedListIndex = 1, #closedLists[islandIndex] do
												
												currentClosedRow = closedLists[islandIndex][closedListIndex][1]
												currentClosedCol = closedLists[islandIndex][closedListIndex][2]
												
												currentClosedDistance = GetDistance(currentNeighborRow, currentNeighborCol, currentClosedRow, currentClosedCol, 3)
												
												--see if this distance is the new smallest distance
												if(currentClosedDistance < closestIslandDistance) then
													closestIslandDistance = currentClosedDistance
												end
											end
										end
									end
								end
							end
							
							--if the closest island is still further away than the distance between islands threshold, this square is good to go in the open list
							if(closestIslandDistance >= distanceBetweenIslands) then
								--make sure the element is not already in the open or closed list
								if(Table_ContainsCoordinate(closedLists[currentIsland], {currentNeighborRow, currentNeighborCol}) == false and Table_ContainsCoordinate(openLists[currentIsland], {currentNeighborRow, currentNeighborCol}) == false) then
									isInBounds = true
								end
							end
							
						end
						
						
						--if the neighbor is within constraints, add it to the openList
						if(isInBounds == true) then
							print("inBounds is true for point " .. currentNeighborRow .. ", " .. currentNeighborCol .. ": closestIslandDistance was " .. closestIslandDistance)
							currentPoint = {currentNeighborRow, currentNeighborCol}
							table.insert(openLists[currentIsland], currentPoint)
							foundSquare = true
							islandSquaresAdded = islandSquaresAdded + 1
						end
					end
				end
				
				
				--until the equalIsland squares are chosen, sequentially add to the islands equally
				if(i < extraLandCoverageSquares) then
					
					--make weighted island selection
					currentWeight = worldGetRandom() * totalWeight
					
					currentSelection = 0
					
					for islandNum = 1, #weightTable do
						
						currentSelection = currentSelection + weightTable[islandNum][2]
						
						if(currentWeight < currentSelection) then
							currentIsland = islandNum + equalIslandNum
							print("slected island " .. currentIsland .. " for extra land expansion")
							break 
						end
						
					end
				end
				
				if(foundSquare == false) then
					i = i - 1
				end
			end
	--	end
	end
	
	
	return closedLists
end


--function CreateLake will find the largest open space on the map within a size constraint and create a lake there
function CreateLake(maxLakeSize, minLakeSize, impasseTypes, openTypes, lakeTerrain, numOfLakes, maxLakeCoverage, terrainTable)
	
	local gridSize = #terrainTable
	--lakeTable will hold the squares that the lake occupies
	local lakeTable = {}
	
	-- availableSquares is a map of every non-impasse square on the map
	local availableSquares = {}
	
	--fill availableSquares
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			--check if the current terrain square is a valid square (not impasse)
			isValidTerrain = true
			currentTerrainType = terrainTable[row][col].terrainType
			for terrainTypeIndex = 1, #impasseTypes do
				if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
					isValidTerrain = false
					--				print("terrain invalid due to this square being impasse")
				end
			end
			
			--check for neighboring impasse
			testNeighbors = GetNeighbors(row, col, terrainTable)
			
			for testNeighborIndex, testNeighbor in ipairs(testNeighbors) do
				
				testNeighborRow = testNeighbor.x
				testNeighborCol = testNeighbor.y
				currentTerrainType = terrainTable[testNeighborRow][testNeighborCol].terrainType
				for terrainTypeIndex = 1, #impasseTypes do
					if(currentTerrainType == impasseTypes[terrainTypeIndex]) then
						isValidTerrain = false
						--					print("terrain invalid because this square's neighbors are impasse")
					end
				end
				
			end
			
			--if the current square is not impasse, add it to the list
			currentInfo = {}
			if(isValidTerrain == true) then
				currentInfo = {row, col}
				
				currentKey = table.concat(currentInfo, ",")
				availableSquares[currentKey] = currentInfo
			end
		end
	end
	
	local function Evaluate(ogRow, ogCol, currRow, currCol, doneMap, currentMap, nextMap, radius)
		local inverseThreshold = -2
		if currRow > 0 and currRow <= gridSize and currCol > 0 and currCol <= gridSize then
			local currentKey = table.concat({currRow, currCol}, ",")
			local isValidTerrain = availableSquares[currentKey] ~= nil
			if(isValidTerrain == true and doneMap[currentKey] == nil and currentMap[currentKey] == nil) then
				local currentDistance = GetDistance(ogRow, ogCol, currRow, currCol, 2)
				if(currentDistance <= radius) then
					nextMap[currentKey] = {currRow, currCol}
					doneMap[currentKey] = {currRow, currCol}
					return inverseThreshold + currentDistance
				end
			end
		end
		return 0
	end
	
	local function GetScore(row, col, radius)
		local score = 0
		local currentMap = {}
		local nextMap = {}
		local doneMap = {}
		
		--search grid, add to openMap if distance to origin < maxRadius AND no impasse neighbors
		--score this square by inverse distance of all found points (or distance if long lakes wanted)
		local startCoords = {row, col}
		local startKey = table.concat(startCoords, ",")
		nextMap[startKey] = startCoords
		while (next(nextMap) ~= nil) do
			currentMap, nextMap = nextMap, currentMap
			for key, coords in pairs(currentMap) do
				-- evaluate neighbors, queue them for next iteration
				score = score + Evaluate(row, col, coords[1] + 1, coords[2], doneMap, currentMap, nextMap, radius)
				score = score + Evaluate(row, col, coords[1] - 1, coords[2], doneMap, currentMap, nextMap, radius)
				score = score + Evaluate(row, col, coords[1], coords[2] + 1, doneMap, currentMap, nextMap, radius)		
				score = score + Evaluate(row, col, coords[1], coords[2] - 1, doneMap, currentMap, nextMap, radius)
				currentMap[key] = nil
			end
		end
		
		return score
	end
	
	--loop through the available squares and find the square with the highest score
	--this will be the most open place for a lake
	local bestScore = math.mininteger
	local bestSquare = {}
 
	for key, coords in pairs(availableSquares) do
		local currentRow = coords[1]
		local currentCol = coords[2]

		local currentScore = GetScore(currentRow, currentCol, maxLakeSize)
		
		if(currentScore > bestScore) then
			bestScore = currentScore
			bestSquare = {currentRow, currentCol}
		end
	end

	--	print("there are " .. #availableSquares .. " available squares")
	--	print(" the best square is " .. bestSquare)

	local bestRow = bestSquare[1]
	local bestCol = bestSquare[2]
	
	local lakeSize = math.ceil(GetRandomInRange(minLakeSize, maxLakeSize))
	
	remainingLakeSquares = maxLakeCoverage
	if(lakeSize > remainingLakeSquares) then
		lakeSize = remainingLakeSquares
	end
	print("chosen lake size: " .. lakeSize)
	terrainTable[bestRow][bestCol].terrainType = tt_none
	GrowTerrainAreaToSize(bestRow, bestCol, lakeSize, openTypes, tt_lake_shallow, terrainTable)
	--GrowTerrainAreaToSizeKeepStartTerrain(bestRow, bestCol, lakeSize, tt_lake_shallow_starting_fish, {tt_none}, tt_lake_shallow, terrainTable)
	return lakeSize
end

--GetFurthestStarts will search the 'terrainToSearch' table for points that are the maximum distance from each other
--if the radius is too large and it cannot find enough points that distance away, it restarts the search with a smaller distance until points are found
function GetFurthestStarts(numOfPlayers, maxDistance, terrainToSearch, terrainTable)
	
	initialDistance = maxDistance
	foundLocations = {}
	for distance = initialDistance, 1, -1 do
		
		foundLocations = {}
		print("SEARCHING DISTANCE " .. distance .. " ")
		foundLocations = GetSetOfSquaresDistanceApart(numOfPlayers, distance, terrainToSearch, terrainTable)
		print("finding players with distance apart of " .. distance)
		if(#foundLocations == numOfPlayers) then
			break
		end
	end
	
	return foundLocations
end