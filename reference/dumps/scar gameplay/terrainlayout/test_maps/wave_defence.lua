--WAVE DEFENCE MODE MAP LAYOUT

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
--NOTE: AoE4 MapGen is designed to generate square maps. The grid you will be working with will always need to have gridWidth = gridHeight

--set the number of players
playerStarts = worldPlayerCount


--IF YOU ARE CREATING A CUSTOM LAYOUT----------------------------------------------------------

--uncomment the following section if you want to use the grid to layout a specific map style

p = { terrainType = tt_plains  }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_impasse_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

--cliff terrain types
p0 = { terrainType = tt_plains_cliff }
p1 = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_med }
p3 = { terrainType = tt_plateau_high }

s = { terrainType = tt_plains, playerIndex = 0 }
e = { terrainType = tt_plains, playerIndex = 1 }

--forests
--use these to spawn dense tree areas
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }


--define river-related data
--each of these defines a separate river to use on the grid layout
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

--SMALL map grid
terrainLayoutResult =
{ {p, p, p, r1,p, p, p, p, p, p, p, p, p, p, p, p, p, p2,p2}
, {p, p, p, r1,p, p, p, p, p, p, p, p, p, p, p, p, p, p2,p2}
, {p, p, p, r1,r1,r1,p, p, p, p, p, p, p, p, p, p, r3,r3,r3}
, {p, p, p, r2,p, r1,r1,r1,r1,r1,r1,p, m, m, p, p, r3,p2,p2}
, {p, p, p, r2,p, p, p, p, p2,p2,r1,r1,r1,m, m, p, r3,p, h}
, {p, p, r2,r2,p, p, p, p, h, p2,p2,h, r1,r1,r1,p, r3,p, p}
, {p, p, r2,p, p, p, m, p, p, p, p, p, p2,p2,r1,r3,r3,p, p}
, {r2,r2,r2,p, p, p, m, d, p, p, p, p, p2,p2,r1,p, p, p, p}
, {p, p, p, p, p, p, m, m, m, p, p, p, p, h, r1,p, p, p, p}
, {p, p, p, p, p, m, m, d, p, p, p, p, p, p, r1,p, p, p, p}
, {p, p, p, p, p, p, p2,p, p, p, p, p, p, d, r1,p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p1,r1,p, h, p, p}
, {p2,p, p, p, p, m, m, m, m, p, h, p1,p, p, r1,p, p, p, h}
, {r4,r4,r4,r4,m, m, p, p, m, m, p2,p2,p2,p2,r1,p, p, p, p}
, {p2,p, p, r4,r4,p, p, h, p, p, p, p, h, p1,r1,h, p, p, p}
, {p, p, m, m, r4,p, p, p, p, d, p, p, p, p, r1,p2,p, p, h}
, {p, p, m, p, r4,r4,r4,p, p, p, b, p, p, p, r1,p2,p, p, p2}
, {m, p, p, p, p, p, r4,p, p, p, p, p, p, p, r1,p2,p, p, p2}
, {m, p, p, p, p, p, r4,p, p, p, p, p, b, p, r1,p2,p, p, p2}	
}


--the following add river crossing points. 
--use fordResults, woodBridgeResults or stoneBridgeResults to add the corresponding crossing type
--the crossing will spawn on the river square denoted by the pair of numbers after riverResult
--the first index is the river number (first river, second river, etc)
--the second index is the nth square along the river (so [1][5] would be the 5th square along the first river)

--if adding multiple crossings on a single river of the same type, make sure they are all added in a single table, like the following fordResults example

ChartRiver(r1, {1, 4}, terrainLayoutResult)
ChartRiver(r2, {3, 4}, terrainLayoutResult)
ChartRiver(r3, {3, 19}, terrainLayoutResult)
ChartRiver(r4, {14, 1}, terrainLayoutResult)

table.insert(fordResults, { riverResult[1][2], riverResult[1][8] })
table.insert(fordResults, { riverResult[2][8]})
table.insert(fordResults, { riverResult[3][2], riverResult[3][8] })
table.insert(fordResults, { riverResult[4][3], riverResult[4][11] })
--table.insert(woodBridgeResults, { riverResult[2][3] })
--table.insert(stoneBridgeResults, { riverResult[3][3]  })


terrainLayoutResult =
{ {p, p, p, r1,p, p, p, p, p, p, p, p, p, p, p, p, p, p2,p2}
, {p, p, p, r1,p, p, p, p, p, p, p, p, p, p, p, p, p, p2,p2}
, {p, p, p, r1,r1,r1,p, p, p, p, p, p, p, p, p, p, r3,p2,p2}
, {p, p, p, r2,p, r1,r1,r1,r1,r1,r1,p, m, m, p, p, r3,p2,p2}
, {p, p, p, r2,p, p, p, p, p2,p2,r1,r1,r1,m, m, p, r3,p, h}
, {p, p, r2,r2,p, p, p, p, h, p2,p2,h, r1,r1,r1,p, r3,p, p}
, {p, p, r2,p, p, p, m, p, p, p, p, p, p2,p2,r1,r3,r3,p, p}
, {r2,r2,r2,p, p, p, m, d, p, p, p, p, p2,p2,r1,p, p, p, p}
, {p, p, p, p, p, p, m, m, m, p, p, p, p, h, r1,p, p, p, p}
, {p, p, p, p, p, m, m, d, p, p, p, p, p, p, r1,p, p, p, p}
, {p, p, p, p, p, p, p2,p, p, p, p, p, p, d, r1,p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p1,r1,p, h, p, p}
, {p2,p, p, p, p, m, m, m, m, p, h, p1,p, p, r1,p, p, p, h}
, {p2,r4,r4,r4,m, m, p, p, m, m, p2,p2,p2,p2,r1,p, p, p, p}
, {p2,p, p, r4,r4,p, p, h, p, p, p, p, h, p1,r1,h, p, p, p}
, {p, p, m, m, r4,p, p, p, p, d, p, p, p, p, r1,p2,p, p, h}
, {p, p, m, p, r4,r4,r4,p, p, p, b, p, p, p, r1,p2,p, p, p2}
, {m, p, p, p, p, p, r4,p, p, p, p, p, p, p, r1,p2,p, p, p2}
, {m, p, p, p, p, p, r4,p, p, p, p, p, b, p, r1,p2,p, p, p2}	
}


--END OF WAVE DEFENCE MAP LAYOUT
