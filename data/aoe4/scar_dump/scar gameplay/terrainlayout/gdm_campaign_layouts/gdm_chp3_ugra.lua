--the "none" type will be randomly filled by your AE data temqate
n = { tt_none }


--create the course grid. This is the table that holds the terrain types that will be used to generate the map in a 2D grid
terrainLayoutResult = {}    -- set up initial table for coarse map grid

--setting useful variables to reference world dimensions
gridHeight = Round(worldTerrainHeight / 46.5, 0) -- set resolution of coarse map rows
gridWidth = Round(worldTerrainWidth / 46.5, 0) -- set resolution of coarse map columns

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end

gridSize = gridWidth -- set resolution of coarse map

--set the number of qayers
playerStarts = worldplayerCount

--these are terrain types that define specific geographic features

--base terrain types
p = { terrainType = tt_plains  }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

--cliff terrain types
p0 = { terrainType = tt_plains_cliff }
p1 = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_med }
p3 = { terrainType = tt_plateau_high }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }

--water
--feel free to add more if necessary
r1 = { terrainType = tt_river }
r2 = { terrainType = tt_river }
r3 = { terrainType = tt_river }
r4 = { terrainType = tt_river }
r5 = { terrainType = tt_river }
r6 = { terrainType = tt_river }
r7 = { terrainType = tt_river }
r8 = { terrainType = tt_river }
r9 = { terrainType = tt_river }

--these tables hold necessary information about water features for mapgen
riverResult = {}
fordResults = {}
woodBridgeResults = {}
stoneBridgeResults = {}

-- initialize the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)


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


--function HasNonEdgeRiverNeighbor returns whether or not the neighbors passed in have a river square that is not on the edge of the grid
function HasNonEdgeRiverNeighbor(neighborTable, grid)

	hasNonEdgeRiverNeighbor = false
	gridSize = #grid
	
	for index, neighbor in ipairs(neighborTable) do
	
		--check to see if current neighbor is on the edge of the map
		currentIsOnMapEdge = IsCoordOnMapEdge(neighbor.x, neighbor.y, gridSize)
		--does the neighbor have a river, AND is it not on the edge of the map?
		if(neighbor.terrainType == tt_river and currentIsOnMapEdge == false) then
			hasNonEdgeRiverNeighbor = true
		end
	
	end
	
	return hasNonEdgeRiverNeighbor
end


--function MetaMap_MapContainsRiver returns a boolean saying whether or not this map has river metadata
function MetaMap_MapContainsRiver(metaTable)

	hasRiver = false
	
	for i = 1, #metaTable do
		for j = 1, #metaTable do
		
			--try to find a square that contains a river
			if(metaTable[i][j].isRiver == true) then
				hasRiver = true
			end
					
		end
	end

	return hasRiver
end

--OLD VERSION
--function MetaMap_GetNextRiverSquare takes a list of directly adjacent neighbors, and the previous square,
--and finds the next square in the river
function MetaMap_GetNextRiverSquare(neighborList, previousSquare)

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

--function MetaMap_GetNextRiverSquare takes a list of directly adjacent neighbors, the river index and the previous square,
--and finds the next square in the river
function CampaignMap_GetNextRiverSquare(neighborList, rIndex, previousSquare, terrainGrid)
	
	nextSquare = nil
	
	--from neighbor list, find the next river square, ignoring the previous river square
	for index, neighbor in ipairs(neighborList) do
		
		--check for next river square with each neighbor
		if(terrainGrid[neighbor.x][neighbor.y] == rIndex) then
		
			--check to make sure this neighbor is not the previous square
			if(neighbor.x ~= previousSquare.x or neighbor.y ~= previousSquare.y) then
		
				nextSquare = neighbor
				
			end
		end
	end
	
	return nextSquare
end


--OLD VERSION
--function CampaignMap_ChartRiver finds the specified river paths from your terrain layout and maps out the points
--provide an index of the edge-to-edge river to chart, and a table containing the coordinates of the river's starting point
--[[
function CampaignMap_ChartRiver(terrainTable)

	riverPoints = {}
	
	riverEdgePoints = {}
	
	--find river start points on edge of the map
	for i = 1, #terrainTable do
		for j = 1, #terrainTable do

			--check each edge of the map
			
			if(i == 1 and terrainTable[i][j].terrainType == tt_river) then
				tempCoord = {
				x = 1, 
				y = j
				}
				
				--make sure there is no duplicates
				if(Table_ContainsCoordinate(riverEdgePoints, tempCoord) == false) then
					table.insert(riverEdgePoints, tempCoord)
				end
			
			
			elseif(i == (#terrainTable) and terrainTable[i][j].terrainType == tt_river) then
				tempCoord = {
				x = (#terrainTable), 
				y = j
				}
				--make sure there is no duplicates
				if(Table_ContainsCoordinate(riverEdgePoints, tempCoord) == false) then
					table.insert(riverEdgePoints, tempCoord)
				end
			
			
			elseif(j == 1 and terrainTable[i][j].terrainType == tt_river) then
				tempCoord = {
				x = i, 
				y = 1
				}
				--make sure there is no duplicates
				if(Table_ContainsCoordinate(riverEdgePoints, tempCoord) == false) then
					table.insert(riverEdgePoints, tempCoord)
				end
			
			
			elseif(j == (#terrainTable) and terrainTable[i][j].terrainType == tt_river) then
				tempCoord = {
				x = i, 
				y = (#terrainTable)
				}
				--make sure there is no duplicates
				if(Table_ContainsCoordinate(riverEdgePoints, tempCoord) == false) then
					table.insert(riverEdgePoints, tempCoord)
				end
			end

		end	
	end
	
	
	
	
	--check through all river edge points, eliminate them if they are a dangling edge segment
	for index, edgePoint in ipairs(riverEdgePoints) do
		
		--grab current river edge cell's neighbor cells
		currentNeighbors = GetNeighbors(edgePoint.x, edgePoint.y, terrainTable)
		
		--check if any of those neighbors are a non-edge river cell
		if(HasNonEdgeRiverNeighbor(currentNeighbors, terrainTable) == false) then
		
			--remove this river edge point, as it does not contain a river neighbor that extends into the map
			table.remove(riverEdgePoints, index)
		end
	end
	
	--riverEdgePoints should now only contain points on the river that extend into the map, not run along the edge
	
	
	if(#(riverEdgePoints) == 0) then
		print("dangling edge river removed, ending river search")
		return 
	end
	
	--check which river edge point has the highest starting height AND has a non-edge connected river square
	--Change these from 1 to 2 to change river direction if generation is failing 
	highestEdgePoint = riverEdgePoints[2]
	highestEdgeIndex = 2
	
	--assign the first river edge to the start of the river points list, remove it from river edge points
	table.insert(riverPoints, {highestEdgePoint.x, highestEdgePoint.y})
	table.remove(riverEdgePoints, highestEdgeIndex)
	
	--start at first edge point, find neighbors
	startingNeighbors = GetNeighbors(highestEdgePoint.x, highestEdgePoint.y, terrainTable)
	
	currentRiverSquare = nil
	previousRiverSquare = {
	x = highestEdgePoint.x, 
	y = highestEdgePoint.y
	}
	
	--from neighbor list, find the next river square, ignoring the previous river square
	for index, neighbor in ipairs(startingNeighbors) do
		
		--check for next river square with each neighbor, ensuring that river is extending into the map
		if(neighbor.terrainType == tt_river and IsCoordOnMapEdge(neighbor.x, neighbor.y, #terrainTable) == false) then
			currentRiverSquare = neighbor
		end
	end
	
	tempCoord = {
	currentRiverSquare.x, 
	currentRiverSquare.y
	}
	table.insert(riverPoints, tempCoord)
	print("before main loop, previous square is set to " .. previousRiverSquare.x .. ", " .. previousRiverSquare.y)
	print("before main loop, first starting point away from map edge is " .. tempCoord[1] .. ", " .. tempCoord[2])
	
	--loop through rest of river until edge point is reached
	while(currentRiverSquare ~= nil and Table_ContainsCoordinate(riverEdgePoints, currentRiverSquare) == false) do
	
		--get neighbors from current square
		currentNeighbors = GetNeighbors(currentRiverSquare.x, currentRiverSquare.y, terrainTable)
		
		--temporarily save the current square to be reassigned as previous later
		tempSquare = currentRiverSquare
		
		--set current to be the next square in the river
		currentRiverSquare = MetaMap_GetNextRiverSquare(currentNeighbors, previousRiverSquare)
		
		--reassign previous square as old current
		previousRiverSquare = tempSquare
		
		print("previous river square is now " .. previousRiverSquare.x .. ", " .. previousRiverSquare.y)
		
		
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
	end
	
	
	
	return riverPoints

end

--]]

--function CampaignMap_ChartRiver finds the specified river paths from your terrain layout and maps out the points 
--provide an index of the edge-to-edge river to chart, and a table containing the coordinates of the river's starting point
function CampaignMap_ChartRiver(riverIndex, startingCoord, terrainTable)
	
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
		if(terrainTable[neighbor.x][neighbor.y] == riverIndex) then
			currentRiverSquare = neighbor
		end
	end
	
	tempCoord = {
	currentRiverSquare.x, 
	currentRiverSquare.y
	}
	table.insert(riverPoints, tempCoord)
	print("before main loop, previous square is set to " .. previousRiverSquare.x .. ", " .. previousRiverSquare.y)
	print("before main loop, first starting point away from map edge is " .. tempCoord[1] .. ", " .. tempCoord[2])
	
	--loop through rest of river until edge point is reached
	while(currentRiverSquare ~= nil) do
	
		--get neighbors from current square
		currentNeighbors = GetNeighbors(currentRiverSquare.x, currentRiverSquare.y, terrainTable)
		
		--temporarily save the current square to be reassigned as previous later
		tempSquare = currentRiverSquare
		
		--set current to be the next square in the river
		currentRiverSquare = CampaignMap_GetNextRiverSquare(currentNeighbors, riverIndex, previousRiverSquare, terrainTable)
		
		--reassign previous square as old current
		previousRiverSquare = tempSquare
		
		print("previous river square is now " .. previousRiverSquare.x .. ", " .. previousRiverSquare.y)
		
		
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
	end
	
	--add this river to the river table to be given to mapgen
	table.insert(riverResult, riverPoints)
end

--function CampaignMap_ChartTributary will find the specified tributary that extends or joins the specified river.
--In this case, a tributary is defined as any river segment that either begins or ends on another river.
--The startingCoord must be either a square on the edge of the map or a square of the starting river.
function CampaignMap_ChartTributary(tributaryIndex, startingCoord, terrainTable)
	
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
		currentNeighbors = GetNeighbors(currentRiverSquare.x, currentRiverSquare.y, terrainTable)
		
		--temporarily save the current square to be reassigned as previous later
		tempSquare = currentRiverSquare
		
		--set current to be the next square in the river
		--Using old function, as it disregards river index - necessary as tributaries go from the tributary index to a different river index
		currentRiverSquare = MetaMap_GetNextRiverSquare(currentNeighbors, previousRiverSquare)
		
		--reassign previous square as old current
		previousRiverSquare = tempSquare
		
		print("previous river square is now " .. previousRiverSquare.x .. ", " .. previousRiverSquare.y)
		
		
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
		
		--check to see if the current river square is the end of the tributary (eg a point on another river)
		if(terrainTable[currentRiverSquare.x][currentRiverSquare.y] ~= tributaryIndex) then
			print("end of tributary found, joining another river")
			currentRiverSquare = nil
		end
	end
	
	--add this river to the river table to be given to mapgen
	table.insert(riverResult, riverPoints)
	
end

--here are blank map grids of the correct sizes. Delete the ones you don't need for any given map
--replace all instances of "n" with the terrain types you actually want. All remaining "n"
--squares will be autofilled with terrain types from the map_gen_layout weighted_terrain_type data table

--TINY map grid
terrainLayoutResult =
{ { p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p }
, { p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p }
, { p,  p,  p,  p,  p,  p,  p,  r1, r1, r1, r1, r1, r1}
, { g,  p,  p,  p,  p,  p,  r1, r1, p,  p,  p,  p,  p }
, { g,  p,  p,  p,  p,  p,  r1, p,  p,  p,  p,  p,  p }
, { p,  g,  p,  p,  p,  p,  r1, p,  p,  p,  p,  p,  p }
, { g,  g,  p,  p,  p,  p,  r1, p,  p,  p,  p,  p,  p }
, { g,  g,  p,  p,  p,  p,  r1, p,  p,  p,  p,  g,  g }
, { g,  g,  p,  p,  p,  p,  r1, r1, p,  p,  g,  g,  g }
, { g,  p,  p,  p,  p,  p,  p,  r1, p,  p,  g,  g,  g }
, { p,  p,  p,  p,  p,  r1, r1, r1, p,  p,  p,  g,  g }
, { p,  p,  p,  p,  r1, p,  p,  p,  p,  p,  p,  g,  g }
, { p,  p,  p,  p,  r1, p,  p,  p,  p,  p,  p,  g,  g }	
}


--RIVER CODE---------------------------------------------------------------------
--Un comment the following lines if you are placing a river on the map
---------------------------------------------------------------------------------


--chart each separate river you've placed on the layout
--Args are as follows:
--CampaignMap_ChartRiver(riverIndex, startingCoordinateTable, terrainLayoutResult)

--NOTE: you are now specifying a starting point, so river direction is not ambiguous.

--Here is a sample map with some river functionality:
--[[
terrainLayoutResult =
{ {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, r1, r1, r1, r1, p, p, p, p}
, {p, p, p, p, r2, p, p, p, r1, p, p, p, p}
, {r3, r3, p, p, r2, p, p, p, r1, p, p, p, p}
, {p, r3, p, p, r2, p, p, p, r1, p, p, p, p}
, {p, r3, p, p, r2, p, p, p, r1, p, p, p, p}
, {p, r3, p, p, r2, r2, r2, r2, r1, r1, p, p, p}
, {p, r3, p, p, p, p, p, p, p, r1, p, p, p}
, {p, r3, p, p, p, p, p, p, p, r1, p, p, p}	
}
--]]

--a few examples of how to use the functions:
--CampaignMap_ChartRiver(r1, {1, 5}, terrainLayoutResult)

--ChartTributary works the same as ChartRiver, but can start or end on another river spot.
--If starting on a river, make sure that your starting coordinate is a point on the river you are branching from.
--In the above example, the tributary starts on the corner square of river1
--CampaignMap_ChartTributary(r2, {6, 5}, terrainLayoutResult)

--CampaignMap_ChartRiver(r3, {8, 1}, terrainLayoutResult)


ChartRiver(r1, {2, 13}, terrainLayoutResult)


--put a ford at the nth square along river 1
--eg, if the river is 17 squares long (from one edge, along the path of the river, to the other end), then
--putting a ford on square 11 will have the 11th square downstream from the head of the river be a ford
--bridges are used in the exact same way. NOTE: bridges cannot be on the same square as a ford!

--NOTE: keep sets of fords and bridges together, per river. So, for each river, make a new insert of the crossing type.
--The first index in riverResult corresponds to the river number in the table.

--fords on river 1, at the 4th and 7th square along the river
table.insert(fordResults, { riverResult[1][8], riverResult[1][13] })

--fords on river 2
--table.insert(fordResults, { riverResult[2][3] })


--table.insert(woodBridgeResults, { riverResult[2][2], riverResult[2][4] })
--table.insert(stoneBridgeResults, { riverResult[1][n], riverResult[1][n] })

--table.insert(woodBridgeResults, { riverResult[2][6], riverResult[2][10] })

--iterate through, replace temp river squares with plains
for row = 1, #terrainLayoutResult do

	for col = 1, #terrainLayoutResult do
	
		if(terrainLayoutResult[row][col].terrainType == tt_river) then
			terrainLayoutResult[row][col].terrainType = tt_plains	
		end
	
	end

end