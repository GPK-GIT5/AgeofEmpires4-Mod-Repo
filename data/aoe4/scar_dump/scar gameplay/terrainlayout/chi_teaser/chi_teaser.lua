--the "none" type will be randomly filled by your AE data temqate
n = { tt_none }


--create the course grid. This is the table that holds the terrain types that will be used to generate the map in a 2D grid
terrainLayoutResult = {}    -- set up initial table for coarse map grid

--setting useful variables to reference world dimensions
gridHeight, gridWidth, gridSize = SetCoarseGrid()

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end

gridSize = gridWidth -- set resolution of coarse map

--set the number of players
playerStarts = worldPlayerCount

--these are terrain types that define specific geographic features

--base terrain types
p = { terrainType = tt_plains }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

w = { terrainType = tt_lake_deep }	--tt_lake_shallow	

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

--these tables hold necessary information about water features for mapgen
riverResult = {}
fordResults = {}
woodBridgeResults = {}
stoneBridgeResults = {}

-- initialize the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

--here are blank map grids of the correct sizes. Delete the ones you don't need for any given map
--replace all instances of "n" with the terrain types you actually want. All remaining "n"
--squares will be autofilled with terrain types from the map_gen_layout weighted_terrain_type data table

--TINY map grid
terrainLayoutResult =
{ {m,  m,  m,  p,  p,  p,  p,  p,  p,  d,  d,  d,  h}
, {m,  g,  g,  p,  p,  p,  p,  p,  p,  p,  p,  g,  d}
, {d,  p,  g,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p}
, {d,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p}
, {p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p}
, {p,  p,  g,  p,  p,  p,  p,  p,  p,  p,  p,  p,  g}
, {j,  p,  p,  g,  p,  p,  p,  p,  p,  p,  p,  r1, r1}
, {g,  p,  p,  p,  p,  p,  p,  p,  p,  r1, r1, p,  p}
, {p,  p,  p,  b,  p,  p,  p,  r1, r1, p,  g,  p,  p}
, {p,  p,  p,  p,  p,  p,  r1, p,  p,  p,  p,  p,  p}
, {p,  r2, r2, p,  r1, r1, p,  p,  p,  g,  g,  g,  p}
, {r2, p,  p,  r1,  p,  g,  g,  g,  g,  g,  p,  g,  p}
, {g,  p,  r1, r1, g,  p,  g,  d,  g,  d,  g,  h,  h}
}

ChartRiver(r1, {13, 3}, terrainLayoutResult)
ChartRiver(r2, {12, 1}, terrainLayoutResult)
table.insert(fordResults, { 
		riverResult[1][7],  
		riverResult[1][5],
		
})



--[[
--SMALL map grid
terrainLayoutResult =
{ {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, e, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, s, p, p, p, p, p, p, p, p, p}
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
]]



--RIVER CODE---------------------------------------------------------------------
--Un comment the following lines if you are placing a river on the map
---------------------------------------------------------------------------------


--chart each separate river you've placed on the layout
--Args are as follows:
--ChartRiver(riverIndex, startingCoordinateTable, terrainLayoutResult)

--The ChartRiver function does not care what type of river you are making (main river or tributary)
--It also allows you to specify subsequent river points diagonally.

--NOTE: you are now specifying a starting point, so river direction is not ambiguous.

--Here is a sample map with some river functionality (feel free to delete if you know how rivers work):
--[[
terrainLayoutResult =
{ {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, r1,r1,r1,r1,p, p, p, p}
, {p, p, p, p, r2,p, p, p, r1,p, p, p, p}
, {r3,p, p, p, r2,p, p, p, r1,p, p, p, p}
, {p, r3,p, p, r2,p, p, p, r1,p, p, p, p}
, {p, r3,p, p, r2,p, p, p, r1,p, p, p, p}
, {p, r3,p, p, r2,r2,r2,p, r1,r1, p, p, p}
, {p, r3,p, p, p, p, p, r2,p, r1, p, p, p}
, {p, r3,p, p, p, p, p, p, p, r1, p, p, p}	
}
]]--

--a few examples of how to use the functions:
--ChartRiver(r1, {1, 5}, terrainLayoutResult)
--ChartRiver(r2, {6, 6}, terrainLayoutResult)
--ChartRiver(r3, {8, 1}, terrainLayoutResult)


--put a ford at the nth square along river 1
--eg, if the river is 17 squares long (from one edge, along the path of the river, to the other end), then
--putting a ford on square 11 will have the 11th square downstream from the head of the river be a ford
--bridges are used in the exact same way. NOTE: bridges cannot be on the same square as a ford!

--NOTE: keep sets of fords and bridges together, per river. So, for each river, make a new insert of the crossing type.
--The first index in riverResult corresponds to the river number in the table.

--fords on river 1, at the 4th and 7th square along the river
--table.insert(fordResults, { riverResult[1][4], riverResult[1][7]  })

--fords on rivers 2 and 3
--table.insert(fordResults, { riverResult[2][3] })
--table.insert(fordResults, { riverResult[3][4] })


--table.insert(woodBridgeResults, { riverResult[1][n], riverResult[1][n] })
--table.insert(stoneBridgeResults, { riverResult[1][n], riverResult[1][n] })

