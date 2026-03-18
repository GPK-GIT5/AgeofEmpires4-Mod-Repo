--Cardinal Map Generation Quick-Start Template


--Set up variables for each of the terrain types you plan to use in the course grid layout.

--more terrain types can be added as needed / created



--IF YOU ARE CREATING A TOTALLY PROCEDURAL MAP LAYOUT------------------------------------------

--IF YOU ARE CREATING A CUSTOM LAYOUT----------------------------------------------------------

--uncomment the following section if you want to use the grid to layout a specific map style

--p = { terrainType = tt_plains  }
P = { terrainType = tt_player_start_classic_plains }
g = { terrainType = tt_hills_gentle_rolling }
G = { terrainType = tt_hills_high_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
p1 = { terrainType = tt_island_plains, playerIndex = 0 }
p2 = { terrainType = tt_island_plains, playerIndex = 1 }
p3 = { terrainType = tt_island_plains, playerIndex = 2 }
p4 = { terrainType = tt_island_plains, playerIndex = 3 }
p5 = { terrainType = tt_island_plains, playerIndex = 4 }
p6 = { terrainType = tt_island_plains, playerIndex = 5 }
p7 = { terrainType = tt_island_plains, playerIndex = 6 }
p8 = { terrainType = tt_island_plains, playerIndex = 7 }

ph = { terrainType = tt_plateau_high}
pm = { terrainType = tt_plateau_med }
pl = { terrainType = tt_plateau_low }

m = { terrainType = tt_mountains }
i = { terrainType = tt_impasse_mountains }


--forests
--use these to spawn dense tree areas
j = { terrainType = tt_impasse_trees_plains }
s = { terrainType = tt_trees_plains_stealth }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }

-- water
b = { terrainType = tt_beach }
p = { terrainType = tt_island_plains }
L = { terrainType = tt_lake_deep }
H = { terrainType = tt_lake_hill }
F = { terrainType = tt_lake_shallow_starting_fish }
o = { terrainType = tt_ocean }
O = { terrainType = tt_ocean_deep }
s = { terrainType = tt_ocean_deep_local_stealth }
S = { terrainType = tt_ocean_shore }
r = { terrainType = tt_river }
w = { terrainType = tt_swamp }


--game

H = { terrainType = tt_player_start_classic_plains }

--fill in this grid with defined terrain types to get the layout looking how you want
--this default grid is filled with plains

--NOTE:
--use only one of these grids. Feel free to delete the ones you are not using

-- Coarse Grids, about 40m each
-- THE MAPS ARE ROTATED 45 DEGREES CCW! <-

terrainLayoutResult =
{ {O, o, o, o, o, o, o, o, O, O, O, O, O, O, O, O, o, O, O, O, O, O, O, O, O}
, {O, o, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, o, O}
, {O, g,p1, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g,p8, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, G, G, G, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g,p2, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g,p7, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, g, G, g, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, G, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g,p3, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g,p6, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, b, G, G, G, b, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, b, o, b, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g,p4, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g,p5, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, g, g, g, g, g, g, O, O, O, O, O, O, O, O, O, O, O, g, g, g, g, g, g, O}
, {O, O, o, b, o, o, o, o, o, O, O, O, O, O, O, O, O, o, o, o, o, b, o, O, O}
}

--[[

terrainLayoutResult =
{ {O, o, o, o, o, o, o, o, O, O, O, O, O, O, O, O, o, O, O, O, O, O, O, O, O}
, {O, o, o, o, o, o, g, o, o, o, o, O, O, O, o, o, o, o, o, o, o, o, o, o, O}
, {O, o, g, g, g, g, g, g, g, g, o, o, o, o, o, b, g, g, g, g, g, g, g, o, O}
, {O, o, g, g, g,p4, g, g, g, g, o, o, o, o, o, b, g, g, g, g,p5, g, g, o, O}
, {O, o, g,p3, g, g, g, g, g, g, o, o, o, o, o, b, g, g, g, g, g, g,p6, o, O}
, {O, o, g, g, g, o, b, b, b, b, o, o, o, o, o, b, b, b, b, o, g, g, g, o, O}
, {O, o, g, g, g, o, b, o, o, o, o, o, o, O, O, O, o, o, b, g, g, g, g, o, O}
, {O, o, g,p2, g, b, o, o, o, o, o, o, o, o, O, O, O, O, O, o, g, g,p7, O, O}
, {O, o, g, g, g, b, o, o, o, o, o, g, g, g, o, O, O, g, o, b, g, g, g, O, O}
, {O, o, g, g, g, b, o, o, o, o, g, g, g, g, g, o, O, O, O, o, g, g, g, O, O}
, {O, o, g,p1, g, b, o, o, o, o, g, g, g, g, g, g, O, O, O, o, g, g,p8, O, O}
, {O, o, g, g, g, b, o, o, o, o, g, g, g, g, g, o, O, O, O, b, g, g, g, o, O}
, {O, o, o, o, o, o, o, o, o, o, o, g, g, g, g, o, O, O, O, o, o, o, o, o, O}
, {O, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, O, O, O, o, o, o, o, o, O}
, {O, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, O, O, O, O, o, o, o, O, O}
, {o, o, b, b, g, g, g, g, g, g, g, g, g, g, g, g, g, g, g, g, g, o, o, o, o}
, {O, O, o, g, k, k, k, k, k, k, k, k, k, k, k, k, k, k, k, k, b, g, o, O, O}
, {O, O, o, g, k, b, o, o, o, O, O, O, O, O, O, O, O, o, g, o, k, g, o, O, O}
, {O, O, o, g, k, b, o, o, o, O, O, O, O, O, O, O, O, O, o, o, b, g, o, O, O}
, {O, O, O, g, k, o, b, b, b, O, O, O, O, O, O, O, o, o, o, o, b, g, o, O, O}
, {O, o, O, g, k, o, o, o, o, O, O, O, O, O, O, O, o, o, o, o, b, g, g, o, O}
, {O, O, O, g, k, o, o, o, o, O, O, O, O, O, O, O, o, o, o, o, b, g, g, o, O}
, {O, O, O, g, k, O, O, O, O, O, O, O, H, O, O, O, O, O, O, o, k, g, g, o, O}
, {O, O, O, o, o, O, O, O, O, O, O, O, O, O, O, O, O, O, O, O, o, o, o, o, O}
, {O, O, O, o, o, o, o, o, o, O, O, O, O, O, O, O, o, o, o, o, o, o, O, O, O}
}
]]--


--[[
--TINY map grid, good for 512x512
terrainLayoutResult =
{ {p, p, p, p, p, s, s, s, p, p, p, p, p}
, {p, p, p, p, p, s, s, s, p, p, p, p, p}
, {p, p, p, p, p, j, j, j, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p}
, {s, s, j, j, p, p, p, p, p, j, j, s, s}
, {s, s, j, j, j, j, j, j, j, j, j, s, s}
, {s, s, j, j, p, p, p, p, p, j, j, s, s}
, {p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, j, j, j, p, p, p, p, p}
, {p, p, p, p, p, s, s, s, p, p, p, p, p}
, {p, p, p, p, p, s, s, s, p, p, p, p, p}
}]]--

-- ChartRiver(riverIndex, startingCoord{Y, X}, terrainTable)
--ChartRiver(r, {7, 1}, terrainLayoutResult)
--ChartRiver(t, {7, 4}, terrainLayoutResult)
--table.insert(fordResults, { riverResult[1][8]  })
--table.insert(fordResults, { riverResult[2][3]  })

--[[
--SMALL map grid
terrainLayoutResult =
{ {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}	
}

--MEDIUM map grid
terrainLayoutResult =
{ {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
}
--]]
---------------------------------------------------------------------------------------------------------------------------------------------------------------

--RIVER NOTES

--uncomment the following section (along with the regular custom layout section) to generate a simple map with a few rivers


--If you are placing rivers on your map via the grid, you must call a function that saves the river
--information and direction for each distinct river you are creating.

--Without calling this function, the map generator will not know where the river should go.

--The function is as follows:
--ChartRiver(riverIndex, startingCoordinateTable, terrainLayoutResult)

	--riverIndex specifies the symbol you are using for the river on the grid. r1, r2, etc.

	--startingCoordinateTable is a grid coordinate pair that states the starting point in {row, column}
	--eg {1, 6} would be at the top of the grid, around the middle of a tiny map.
	
	--terrainLayoutResult is your terrain table. Don't change it's name, that is the specific table
	--the map generator looks at for map data.


--[[
terrainLayoutResult = {}

terrainLayoutResult =
{ {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, b, b, b, p, p, p}
, {p, p, p, p, r1, p, b, b, m, m, m, p, p}
, {p, p, p, p, p, r1,r1,r1, p, m, p, p, p}
, {p, p, p, p, r2,p, b, m, r1, m, m, p, p}
, {r3,p, p, p, r2,b, m, m, r1, m, m, p, p}
, {p, r3,p, p, r2,b, m, m, r1, m, m, p, p}
, {p, p,r3, p, r2,b, m, m, r1, m, p, p, p}
, {p, p,r3, p, p, r2,r2,r2,r1, p, p, p, p}
, {p, r3,p, p, p, p, p, p, p, r1, p, p, p}
, {r3, p,p, p, p, p, p, p, p, r1, p, p, p}	
}

-- for each river legend (r1, r2, etc) we need to call these functions. 
-- Must be before end of script but after the grid itself.
ChartRiver(r1, {1, 5}, terrainLayoutResult)
ChartRiver(r2, {6, 6}, terrainLayoutResult)
ChartRiver(r3, {8, 1}, terrainLayoutResult)
]]--
--the following add river crossing points. 
--use fordResults, woodBridgeResults or stoneBridgeResults to add the corresponding crossing type
--the crossing will spawn on the river square denoted by the pair of numbers after riverResult
--the first index is the river number (first river, second river, etc)
--the second index is the nth square along the river (so [1][5] would be the 5th square along the first river)

--if adding multiple crossings on a single river of the same type, make sure they are all added in a single table, like the following fordResults example

--table.insert(fordResults, { riverResult[1][4], riverResult[1][7]  })
--table.insert(woodBridgeResults, { riverResult[2][3] })
--table.insert(stoneBridgeResults, { riverResult[3][3]  })


