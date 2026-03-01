print("GENERATING RIVERS TEST MAP")

--Cardinal Map Generation Quick-Start Template


--Set up variables for each of the terrain types you plan to use in the course grid layout.

--more terrain types can be added as needed / created



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
m = { terrainType = tt_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

--cliff terrain types
p0 = { terrainType = tt_plains_cliff }
q = { terrainType = tt_plateau_low }
w = { terrainType = tt_plateau_med }
e = { terrainType = tt_plateau_high }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
t = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
--use these to spawn dense tree areas
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }


--define river-related data
--each of these defines a separate river to use on the grid layout
--feel free to add more if necessary
x = { terrainType = tt_river }
y = { terrainType = tt_river }
z = { terrainType = tt_river }
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
{ {p, p, p, p, p, x, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, x, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, x, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, x, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, x, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, x, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, x, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, x, p, p, p, p, p, p, x, x, p, p, p, p}
, {p, p, p, p, p, p, p, x, p, p, p, p, x, p, p, x, p, p, p}
, {y, y, y, p, y, y, p, x, p, p, p, p, x, p, p, x, p, p, p}
, {p, p, p, y, p, p, y, x, p, p, p, p, x, p, p, x, p, p, p}
, {p, p, p, p, p, p, p, p, x, x, x, x, p, p, p, x, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, z, p, p, x, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, z, p, p, x, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, z, p, p, x, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, z, p, p, x, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, z, p, x, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, x, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, x, p, p, p, p, p}	
}

ChartRiver(x, {1, 6}, terrainLayoutResult)
ChartRiver(y, {10, 1}, terrainLayoutResult)
ChartRiver(z, {12, 12}, terrainLayoutResult)

table.insert(fordResults, { riverResult[1][7], riverResult[1][15]  })
table.insert(fordResults, { riverResult[2][6]  })
table.insert(fordResults, { riverResult[3][4]  })
table.insert(woodBridgeResults, { riverResult[1][17] })
table.insert(stoneBridgeResults, { riverResult[1][24]  })

terrainLayoutResult =
{ {p, p, p, p, w, w, w, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, t, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, b, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {b, p, b, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {h, h, p, p, h, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {h, b, p, h, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {h, p, h, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, b, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, s, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}	
}





