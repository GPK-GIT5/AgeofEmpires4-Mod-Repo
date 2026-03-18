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
o = { terrainType = tt_ocean }

--cliff terrain types
a = { terrainType = tt_plains_cliff }
c = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_med }
p3 = { terrainType = tt_plateau_high }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }


--water
--feel free to add more if necessary
r = { terrainType = tt_river }
l = { terrainType = tt_river }
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

-- initialize the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

--here are blank map grids of the correct sizes. Delete the ones you don't need for any given map
--replace all instances of "n" with the terrain types you actually want. All remaining "n"
--squares will be autofilled with terrain types from the map_gen_layout weighted_terrain_type data table

----TINY map grid
--terrainLayoutResult =
--{ {p, r, p, p, p, p, p, p, p}
--, {p, r, p, p, p, p, p, p, p}
--, {p, p, r, p, p, p, p, p, p}
--, {p, p, p, r, r, r, p, p, p}
--, {p, p, p, p, p, r, r, p, p}
--, {p, p, p, p, p, p, r, p, p}
--, {p, p, p, p, p, p, p, r, r}
--, {p, p, p, p, p, p, p, p, p}
--, {p, p, p, p, p, p, p, p, p}
--}

--SMALL map grid
terrainLayoutResult =
{ {p, p, o, o, z, o, o, o, r, p, p, p, p, p, p, g, l, g, g}
, {p, p, o, o, z, o, o, o, r, p, p, p, p, p, p, g, l, g, g}
, {p, p, p, o, z, o, o, r, p, p, p, p, p, p, p, g, l, g, g}
, {p, p, p, p, z, p, p, r, p, p, p, p, p, p, g, l, g, g, g}
, {p, p, p, z, p, p, p, r, p, p, p, p, p, p, g, l, g, g, g}
, {p, p, p, z, p, p, p, r, p, p, p, p, p, p, g, l, g, g, g}
, {p, p, z, p, p, p, p, p, r, r, r, p, p, g, g, l, p, p, p}
, {p, p, z, p, p, p, p, p, p, p, r, d, p, d, d, d, l, p, p}
, {p, z, p, p, g, g, g, p, p, p, r, r, r, r, r, r, l, p, p}
, {z, p, p, p, g, g, g, p, b, p, p, p, p, p, p, p, r, p, p}
, {p, p, p, p, g, g, g, p, b, p, p, p, p, p, p, p, r, r, r}
, {p, p, p, p, p, p, p, p, p, b, p, p, p, p, p, p, p, p, g}
, {p, p, p, p, p, p, p, p, p, h, b, p, p, p, p, p, p, p, p}
, {g, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {g, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, g, g, g}
, {g, g, p, p, p, p, p, p, p, p, p, p, p, p, p, p, g, d, d}
, {g, g, p, p, p, p, p, p, p, p, p, p, p, p, p, p, d, d, d}
, {g, g, g, g, g, p, p, p, p, p, p, p, p, p, p, p, d, d, d}
, {g, g, g, d, d, p, p, p, p, p, p, g, g, g, g, g, d, d, d}	
}






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
ChartRiver(r, {1, 9}, terrainLayoutResult)
ChartRiver(z, {1, 5}, terrainLayoutResult)
ChartRiver(l, {10,17}, terrainLayoutResult)
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

table.insert(fordResults, { riverResult[1][18]})
table.insert(fordResults, { riverResult[2][5]})
--table.insert(fordResults, { riverResult[3][6]})

--fords on rivers 2 and 3
--table.insert(fordResults, { riverResult[2][3] })
--table.insert(fordResults, { riverResult[3][4] })

woodBridgeResults = {{}, {}, {}}
table.insert(woodBridgeResults[3], riverResult[3][6])
table.insert(woodBridgeResults[3], riverResult[3][9])

table.insert(stoneBridgeResults, { riverResult[1][6], riverResult[1][13] })
--table.insert(stoneBridgeResults, { riverResult[3][6] })

