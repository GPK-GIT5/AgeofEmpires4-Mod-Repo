--cool stuff here
--the "none" type will be randomly filled by your AE data temqate
n = tt_none


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

function Table_ContainsCoordinate(table, value)

	tableHasCoord = false
	
	for index, val in ipairs(table) do
		if (val.x == value.x and val.y == value.y) then
			tableHasCoord = true
		end
	end
	
	return tableHasCoord
end

--This function returns a boolean true if the supplied xy coordinate is on the grid border
function IsCoordOnMapEdge(xLoc, yLoc, gridSize)

	isOnEdge = false
	
	if(xLoc == 1 or xLoc == gridSize or yLoc == 1 or yLoc == gridSize) then
	
		isOnEdge = true
	
	end
	
	return isOnEdge
end


--GetNeighbors returns a list of all directly adjacent cells in a 2D array-style table
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


--this function returns whether or not the neighbors passed in have a river square that is not on the edge of the grid
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


--this function returns a boolean saying whether or not this map has river metadata
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


--this function takes a list of directly adjacent neighbors, and the previous square,
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
	
	highestEdgePoint = riverEdgePoints[1]
	highestEdgeIndex = 1
	
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

gridSize = gridWidth -- set resolution of coarse map

--set the number of qayers
playerStarts = worldplayerCount


--these are terrain types that define specific geographic features

--base terrain types
p = { terrainType = tt_plains  }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_hills_plateau }
u = { terrainType = tt_flatland }
v = { terrainType = tt_valley }
o = { terrainType = tt_ocean }

--cliff terrain types
p0 = { terrainType = tt_plains_cliff }
p1 = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_med }
p3 = { terrainType = tt_plateau_high }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
f = { terrainType = tt_hills_light_forest }
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }

--water
r = { terrainType = tt_river }
river = tt_plains

-- initialize the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)


terrainLayoutResult =
{ { d,  d,  h,  h,  h,  d,  d,  d,  d,  d,  d,  d,  f,  d,  d,  d ,  d }
, { d,  d,  f,  d,  m,  d,  d,  d,  d,  d,  d,  d,  d,  d,  d,  f ,  f }
, { d,  d,  p,  p,  p,  f,  p,  p,  f,  d,  d,  d,  d,  d,  d,  d ,  d }
, { r,  r,  p,  p,  p,  p,  p,  p,  h,  h,  d,  d,  h,  h,  d,  d ,  d }
, { p,  r,  r,  p,  p,  p,  p,  f,  m,  p,  p,  d,  h,  h,  h,  d ,  d }
, { d,  p,  r,  p,  p,  p,  p,  p,  p,  p,  p,  d,  h,  h,  h,  h ,  h }
, { d,  d,  r,  d,  f,  p,  p,  p,  p,  p,  p,  d,  d,  h,  h,  h ,  h }
, { d,  d,  r,  r,  d,  r,  r,  r,  d,  f,  d,  d,  d,  d,  h,  h ,  h }
, { f,  f,  d,  r,  r,  r,  p,  r,  d,  p,  d,  d,  d,  d,  h,  h ,  h }
, { d,  u,  u,  p,  p,  p,  p,  r,  r,  p,  p,  d,  d,  d,  h,  h ,  h }
, { p,  p,  f,  d,  d,  p,  p,  p,  r,  p,  p,  d,  h,  h,  h,  f ,  h }
, { d,  d,  d,  f,  u,  u,  d,  d,  r,  r,  d,  h,  h,  h,  h,  h ,  p2}
, { d,  d,  p,  u,  u,  d,  f,  d,  p,  r,  r,  r,  p2, h,  h,  p2,  o }
, { p,  p,  u,  p,  p,  d,  d,  f,  u,  p,  p,  r,  p2, p2, p2, o ,  o }
, { p,  p,  p,  f,  p,  f,  d,  u,  u,  p,  p,  r,  r,  o,  o,  o ,  o }
, { p,  p,  f,  d,  d,  p,  p,  u,  f,  f,  p,  o,  r,  o,  o,  o ,  o }
, { p,  d,  d,  d,  d,  p,  p,  d,  d,  o,  o,  o,  r,  o,  o,  o ,  o }
}

-- generate river result table for river generation
riverResult = {}
fordResults = {}

--create list of river points
riverPoints = {}

--create list of temporary points to add to the list, out of the line drawing function

riverPoints = CampaignMap_ChartRiver(terrainLayoutResult)

--ford either at point 5 or point 26
tempCoord = {
	3, 
	13
	}

--add the ordered pair list into a single river
table.insert(riverResult, 1, riverPoints)

table.insert(fordResults, { riverResult[1][4] })


for row = 1, #terrainLayoutResult do

	for col = 1, #terrainLayoutResult do
	
		if(terrainLayoutResult[row][col].terrainType == tt_river) then
			terrainLayoutResult[row][col].terrainType = tt_plains	
		end
	
	end

end