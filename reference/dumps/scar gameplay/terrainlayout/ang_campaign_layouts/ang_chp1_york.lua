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
--c = { terrainType = tt_plains_cliff }
q = { terrainType = tt_plateau_low }
--c = { terrainType = tt_plateau_med }
c = { terrainType = tt_plateau_high }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }

--water
--feel free to add more if necessary
r = { terrainType = tt_river }
z = { terrainType = tt_river }
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

terrainLayoutResult =
{ {p, p, d, q, q, d, q, g, p, p, p, p, p, p, p, r, p, p, p}
, {p, p, p, d, g, g, g, p, p, p, p, p, p, p, p, r, p, p, p}
, {d, p, p, p, p, p, p, p, p, p, p, p, p, p, p, r, p, p, p}
, {d, g, g, p, p, p, p, p, p, p, g, p, p, p, p, r, p, p, p}
, {d, d, d, p, p, p, g, p, p, g, g, g, p, p, r, r, p, p, p}
, {p, g, p, p, p, g, g, p, p, p, p, p, p, p, r, p, p, p, p}
, {g, p, g, p, p, p, p, p, r, r, r, r, r, r, r, p, p, p, p}
, {p, p, p, p, p, r, r, r, r, p, p, p, z, p, p, p, p, p, p}
, {p, p, p, p, p, r, p, p, p, p, p, p, z, z, z, z, p, p, p}
, {p, p, g, g, p, r, p, p, p, p, g, p, p, g, g, z, z, z, z}
, {p, p, p, p, p, r, p, p, p, g, p, p, p, p, g, p, p, p, p}
, {p, p, p, g, p, r, r, p, p, p, p, p, p, p, g, p, p, p, p}
, {p, g, p, g, p, p, r, p, p, p, p, g, g, g, g, d, p, p, p}
, {p, p, p, p, p, p, r, p, p, p, p, p, p, p, p, p, p, p, g}
, {p, p, p, p, p, p, r, p, p, g, p, p, p, g, g, p, p, p, g}
, {p, p, p, p, p, r, r, p, g, g, p, p, g, p, p, p, p, g, p}
, {p, p, p, p, r, r, p, p, p, g, p, p, p, p, p, p, p, d, d}
, {p, p, p, p, r, p, p, g, g, g, p, p, p, p, p, g, g, d, q}
, {p, p, p, p, r, p, p, g, g, g, p, p, p, p, g, g, d, q, q}
}


-- Set up the rivers
CampaignMap_ChartRiver(r, {1, 16}, terrainLayoutResult)
CampaignMap_ChartTributary(z, {10, 19}, terrainLayoutResult)

table.insert(fordResults, { riverResult[1][3], riverResult[1][26] })
--table.insert(fordResults, { riverResult[2][4] })


--iterate through, replace temp river squares with plains
for row = 1, #terrainLayoutResult do

	for col = 1, #terrainLayoutResult do
	
		if(terrainLayoutResult[row][col].terrainType == tt_river) then
			terrainLayoutResult[row][col].terrainType = tt_plains	
		end
	
	end

end