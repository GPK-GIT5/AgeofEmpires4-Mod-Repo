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
p = { terrainType = tt_plains }
h = { terrainType = tt_hills }
x = { terrainType = tt_hills_rough }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
m = { terrainType = tt_hills_med_rolling }
H = { terrainType = tt_hills_high_rolling }
b = { terrainType = tt_hills_high_flattop }
n = { terrainType = tt_mountains_small }
N = { terrainType = tt_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

c = { terrainType = tt_plateau_low }
C = { terrainType = tt_plateau_med }

--water
--feel free to add more if necessary
r = { terrainType = tt_river }
--r2 = { terrainType = tt_river }

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

--SMALL map grid
terrainLayoutResult =
{ {C, n, n, c, c, n, C, n, p, p, h, c, m, C, C, N, C, N, C}
, {n, c, c, c, n, n, n, p, p, p, c, c, x, x, m, m, C, C, N}
, {d, c, c, c, c, c, x, p, p, x, c, p, p, p, x, m, C, N, C}
, {c, c, c, c, c, c, p, p, p, p, p, p, p, p, p, x, m, C, N}
, {n, c, c, c, g, p, p, p, c, x, p, g, c, c, p, p, p, c, C}
, {C, n, x, p, p, p, p, x, c, p, x, c, c, c, x, p, p, c, m}
, {C, n, x, p, p, p, p, x, c, p, x, c, c, c, c, x, p, x, p}
, {n, h, h, p, p, x, p, p, x, p, x, c, c, c, c, x, p, r, r}
, {p, p, p, p, x, n, x, r, r, r, p, x, g, g, g, h, r, p, x}
, {x, c, g, h, p, p, r, p, p, h, r, x, p, x, p, r, p, x, c}
, {c, c, c, c, p, r, h, c, g, p, x, r, r, r, r, p, x, c, c}
, {c, c, c, x, p, r, c, c, g, c, g, x, c, x, p, p, p, p, g}
, {n, g, c, g, r, x, g, g, g, p, p, p, h, c, p, p, c, c, g}
, {x, p, p, r, r, g, p, h, g, x, c, h, p, p, p, g, c, c, m}
, {r, r, r, g, g, p, p, x, p, c, n, c, p, x, c, c, c, c, n}
, {x, c, c, c, x, p, x, c, p, x, x, h, p, x, c, c, c, c, C}
, {c, x, p, p, p, p, p, c, g, c, g, p, p, p, c, c, c, m, C}
, {p, p, p, x, c, c, g, g, g, g, g, c, x, p, g, c, n, C, C}
, {x, c, c, c, c, g, g, g, g, g, g, g, c, p, x, c, m, C, N}	
}

ChartRiver(r,  {15, 1}, terrainLayoutResult)
--ChartRiver(r2, {8, 18}, terrainLayoutResult)

table.insert(fordResults, { riverResult[1][5], riverResult[1][10] })
table.insert(stoneBridgeResults, { riverResult[1][18] })


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

