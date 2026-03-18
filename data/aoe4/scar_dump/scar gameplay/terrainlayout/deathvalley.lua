

n = { terrainType = tt_none }

p = { terrainType = tt_flatland  }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_high_rolling }
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }

--water
r = { terrainType = tt_river }

terrainLayoutResult = {}    -- set up initial table for coarse map grid

gridHeight, gridWidth, gridSize = SetCoarseGrid()

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


-- setting up the map grid
terrainLayoutResult = SetUpGrid(19, n, terrainLayoutResult)

mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)

print("map half size is " .. mapHalfSize)


--create river head mountain zone
riverHeadX = mapHalfSize
riverHeadY = mapQuarterSize
	
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, r, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, r, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, r, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, r, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, r, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, r, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, r, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, m, r, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, m, m, n, n, r, r, r, r, r, n, n, n, n, n, n}
, {n, n, n, n, n, m, n, n, n, n, n, n, n, r, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, r, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, r, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, r, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, r, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, r, r, n, n, r, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, r, n, r, n, n, r, n, n, n, n}
, {n, n, n, n, n, n, n, n, m, r, m, n, r, r, r, n, n, n, n}
, {n, n, n, n, n, n, n, n, m, r, m, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, m, r, m, n, n, n, n, n, n, n, n}
}
 
 
 riverPoints = {}
 
 
 riverTurnPoints = {
 	{10, 1}, 
 	{10, 5}, 
 	{15, 3}, 
 	{15, 10}, 
 	{9, 10}, 
 	{7, 12}, 
 	{10, 15},
 	{10, 19}
 }
 
 --add first point of river
 tempX = riverTurnPoints[1][1]
 tempY = riverTurnPoints[1][2]
 table.insert(riverPoints, 1, {tempX, tempY})
 
 tempRiverPoints = {}
 
 --loop through points and draw lines between each set
 for pointIndex = 1, #riverTurnPoints do
 
 	--check and make sure that it does not try to connect the final point to a null
 	if(riverTurnPoints[pointIndex + 1] ~= null) then
 	
 		
 		
 	end
 
 end
 
 
-- generate river result table for river generation
riverResult = {}

tempRiverPoints = {}
	tempRiverPoints = DrawLineOfTerrainNoNeighbors(x1, y1, x2, y2, true, r, gridSize, terrainLayoutResult)
	
	for rIndex = 2, #tempRiverPoints do		
		x = tempRiverPoints[rIndex][1]
		y = tempRiverPoints[rIndex][2]
		print("RIVER POINTS: Row " ..x .." Col " ..y)
		table.insert(riverPoints, #riverPoints + 1, {x, y})
	end


 -- iterate through to set features
for y = 1, (#terrainLayoutResult) do
	for x = 1, (#terrainLayoutResult) do
	
		if(terrainLayoutResult[x][y].terrainType == tt_river) then
		
			terrainLayoutResult[x][y] = p
			terrainLayoutResult[x][y].riverID = 1
			print("setting river ID at square " .. x .. ", " .. y)
		
		end
	
	
	
	end
end


