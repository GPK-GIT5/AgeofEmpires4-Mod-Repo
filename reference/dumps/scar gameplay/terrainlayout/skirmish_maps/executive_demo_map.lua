-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
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
h = { terrainType = tt_hills_med}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains }
i = { terrainType = tt_impasse_mountains}
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

--cliff terrain types
p0 = { terrainType = tt_plains_cliff }
p1 = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_standard_clear }
p3 = { terrainType = tt_plateau_med }

s = { terrainType = tt_player_start_classic_plains, playerIndex = 0}
e = { terrainType = tt_player_start_classic_plains, playerIndex = 1}

--forests
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }
f = { terrainType = tt_trees_plains_stealth}
c = { terrainType = tt_trees_plains_clearing}

ls = { terrainType = tt_lake_shallow}
ld = { terrainType = tt_lake_deep}


--resources
sb = { terrainType = tt_tactical_region_stone_plains_a}
gb = { terrainType = tt_tactical_region_gold_plains_a}
sp = { terrainType = tt_settlement_plains }
pg = { terrainType = tt_tactical_region_gold_plateau_med_c}


--water
--feel free to add more if necessary
r = { terrainType = tt_river }
z = { terrainType = tt_river }
x = { terrainType = tt_river }
y = { terrainType = tt_river }
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

--here are blank map grids of the correct sizes. Delete the ones you don't need for any given map
--replace all instances of "n" with the terrain types you actually want. All remaining "n"
--squares will be autofilled with terrain types from the map_gen_layout weighted_terrain_type data table

--TINY map grid
terrainLayoutResult =
{ {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {z, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, z, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, z, z, z, z, z, z, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, z, z, z, z, z, z, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, z, z, z, z, z}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}	
}


--RIVER CODE---------------------------------------------------------------------
--Un comment the following lines if you are placing a river on the map
---------------------------------------------------------------------------------


--chart each separate river you've placed on the layout
--Args are as follows:
ChartRiver(z, {12, 19}, terrainLayoutResult)
--ChartRiver(x, {19, 11}, terrainLayoutResult)
--ChartRiver(y, {1, 9}, terrainLayoutResult)

table.insert(fordResults, { riverResult[1][16]  })
table.insert(woodBridgeResults, { riverResult[1][4], riverResult[1][10] })
--The ChartRiver function does not care what type of river you are making (main river or tributary)
--It also allows you to specify subsequent river points diagonally.

--[[
terrainLayoutResult =
{ {m, m, p, p, p, p, p, p, p, p, p, p, p}
, {m, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, d, d}
, {p, p, p, p, p, p, p, p, p, p, d, d, d}
, {p, p, p, p, p, p, p, p1,h, p, b, b, b}
, {p, p, p, p, p, p, x, p, p, h, h, h, h}
, {p, p, p, p, p, p, x, p, h, p, b, p, d}
, {p, p, p, p, p, p, p, x, p, p2,p2,p, d}
, {p, p, p, p, p, p, p, x, b, p2,p2,p, b}
, {p, p, p, p, p, p, p, x, d, p, p, k, k}
, {p, p, p, p, p, p, p, p, x, d, b, k, b}	
}
]]--

terrainLayoutResult =
{ {ls,ls,ls,u, p, p2,m, m, p, p, p, p2,p2,p2,p, p, p, p, f}
, {ls,ls,ls,u, p, p2,p, p, p, p, p, p2,p2,p2,p, p, p, p, p}
, {ls,ls,u, c, p, p2,h, p, p, p, p, p2,p2,p2,p, p, s, p, p}
, {u, u, c, i, p, p, p, f, b, p, p, p2,p2,p2,h, p, p, p, p}
, {p, p, p, i, p, p, p, p, b, p, p, h, p2,p2,h, p, c, p, p}
, {p2,h, c, p, p, p, p, p, f, p, p, f, h, p2,p2,p2,c, p, h}
, {pg,p2,p, p, p, p, p, p, p, c, b, p, b, p, p, p, c, h, h}
, {c, c, p, p, p, p, p, p, h, c, c, p, p, p, p, c, p, p2,p2}
, {p2,c, c, c, p, p, f, p, c, c, c, p, p, p, p, p, p, p2,p2}
, {p2,m, c, c, p, p, p, p, c, c, c, p, f, c, p, f, p, p2,p2}
, {p2,p2,c, c, c, c, c, p, p, c, c, p, p, p, p, c, p, p2,p2}
, {p2,p2,p, p, f, p, c, c, c, c, c, c, p, p, p, c, p, p, p}
, {h, p2,p, p, p, p, c, p, c, p, p, p, f, p, p, c, p, p2,pg}
, {h, h, p, p2,p2,p2,h, f, p, c, c, p, h, p, p, p, p, p2,p2}
, {p, p, p, p, h, p2,p2,h, p, c, p, h, p, p, p, i, c, h, h}
, {p, p, p, p, h, p2,p2,p2,p, c, c, p, f, p, p, i, p, u, p}
, {p, p, e, p, p, p2,p2,p2,p, c, c, p, h, p2,p, c, u, ls,ls}
, {p, p, p, p, p, p2,p2,p2,p, p, c, c, p, p2,p, u, ls,ls,ls}
, {f, p, p, p, p, p2,p2,p2,p, c, c, m, m, p2,p, u, ls,ls,ls}	
}
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

