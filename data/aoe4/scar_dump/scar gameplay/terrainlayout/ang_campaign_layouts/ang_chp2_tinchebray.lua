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




gridSize = gridWidth -- set resolution of coarse map

--set the number of qayers
playerStarts = worldplayerCount


--these are terrain types that define specific geographic features

--base terrain types
p = { terrainType = tt_plains  }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_flattop }
m = { terrainType = tt_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley_shallow }

s = { terrainType = tt_hills_plateau }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }

q = { terrainType = tt_plateau_low }
w = { terrainType = tt_plateau_med }
z = { terrainType = tt_plateau_high} --high rolling

--water
r = { terrainType = tt_river }
river = tt_plains

-- initialize the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)


terrainLayoutResult =
{ {d, g, d, d, p, g, p, p, p, p, p, p, p, g, d, d, d}
, {g, p, p, g, g, g, p, g, p, p, p, p, p, p, g, d, q}
, {p, p, p, p, p, g, p, p, p, d, p, p, p, p, p, q, q}
, {p, p, g, p, g, p, p, p, p, d, d, p, p, p, p, g, g}
, {p, p, p, p, g, p, p, p, g, p, p, p, p, p, p, p, p}
, {h, h, p, g, p, p, p, p, g, g, p, p, p, p, p, p, p}
, {d, d, d, g, p, p, p, p, g, g, p, p, p, p, p, p, d}
, {p, p, p, p, p, p, g, q, q, q, g, p, p, d, d, d, q}
, {p, g, g, g, p, p, g, q, q, q, p, p, p, p, d, d, q}
, {p, p, p, g, p, p, p, g, d, g, g, p, p, g, p, d, q}
, {p, p, p, p, p, p, p, p, g, g, p, p, h, p, p, p, d}
, {g, p, p, p, p, p, p, p, p, p, d, d, h, p, d, d, d}
, {g, g, g, g, p, d, q, d, g, p, p, p, p, p, g, q, q}
, {d, d, p, g, p, q, q, d, q, d, p, d, p, p, q, q, q}
, {d, q, p, p, d, q, q, h, q, d, q, q, d, p, p, p, p}
, {q, d, p, p, p, d, q, q, q, q, q, q, g, g, p, g, p}
, {q, d, p, p, p, d, q, q, q, q, q, q, d, p, p, d, h}
}


for row = 1, #terrainLayoutResult do

	for col = 1, #terrainLayoutResult do
	
		if(terrainLayoutResult[row][col].terrainType == tt_river) then
			terrainLayoutResult[row][col].terrainType = tt_plains	
		end
	
	end

end