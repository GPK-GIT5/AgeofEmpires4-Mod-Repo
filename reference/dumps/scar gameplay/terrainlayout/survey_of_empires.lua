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
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

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

--these are terrain types that define specific geographic features

--base terrain types
p = { terrainType = tt_plains  }
x = { terrainType = tt_plains_cliff }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_plateau_low}
b = { terrainType = tt_hills_high_rolling }
k = { terrainType = tt_hills_med_rolling }
t = { terrainType = tt_plateau_med }
a = { terrainType = tt_plateau_standard }
q = { terrainType = tt_plateau_high }
m = { terrainType = tt_mountains }
i = { terrainType = tt_impasse_mountains }
y = { terrainType = tt_mountains_small }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }
c = { terrainType = tt_trees_plains_clearing}

--s = { terrainType = tt_hills_plateau, playerIndex = 0 }
s = { terrainType = tt_hills_high_rolling, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
j = { terrainType = tt_impasse_trees_plains }
--k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }

--water
r = { terrainType = tt_river }
w = { terrainType = tt_river }
z = { terrainType = tt_river }
o = { terrainType = tt_river }
river = tt_plains

-- initialize the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

--here are blank map grids of the correct sizes. Delete the ones you don't need for any given map
--replace all instances of "n" with the terrain types you actually want. All remaining "n"
--squares will be autofilled with terrain types from the map_gen_layout weighted_terrain_type data table


terrainLayoutResult =
{ {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {w, w, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, w, w, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, w, p, p, r, r, r, p, p, p, p, p, p, p, p}
, {p, p, p, r, r, r, r, r, p, p, p, r, r, p, p, p, p, p, p}
, {p, p, r, p, p, p, p, o, p, p, p, p, p, r, p, p, p, p, p}
, {r, r, p, p, p, o, o, p, p, p, p, p, p, p, r, r, p, p, p}
, {p, p, p, p, o, p, p, p, p, p, p, p, p, p, p, r, p, p, p}
, {p, p, p, p, p, o, p, p, p, p, p, p, p, p, p, r, r, r, r}
, {p, p, p, p, p, o, o, p, p, p, p, p, p, p, p, p, p, p, p}
, {p, p, p, p, p, p, o, p, p, p, p, p, p, p, p, p, p, p, p}
}

-- generate river result table for river generation
riverResult = {}
fordResults = {}
woodBridgeResults = {}


ChartRiver(r, {15, 1}, terrainLayoutResult)
ChartRiver(w, {9, 1}, terrainLayoutResult)
--ChartRiver(z, {18, 1}, terrainLayoutResult)
ChartRiver(o, {19, 7}, terrainLayoutResult)

table.insert(fordResults, { riverResult[1][5], riverResult[1][15]})

table.insert(fordResults, { riverResult[2][6]})

table.insert(woodBridgeResults, { riverResult[1][7], riverResult[1][23]})


--SMALL map grid
terrainLayoutResult =
{ {m, p, m, m, m, h, m, d, d, m, m, m, p, p, p, p, p, p, p}
, {m, p, m, h, h, h, d, m, p, p, p, m, p, p, p, p, p, p, p}
, {m, p, p, m, b, q, d, m, p, m, p, p, p, p, p, p, p, p, p}
, {m, m, b, m, q, m, d, p, p, m, p, p, p, p, p, p, p, p, p}
, {m, h, b, h, b, q, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {b, i, m, i, m, q, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {q, m, d, b, b, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {q, q, d, d, d, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {q, q, d, b, d, p, p, p, k, h, a, a, p, p, p, p, p, p, p}
, {q, q, t, w, p, p, g, g, g, g, d, a, p, p, p, p, p, p, p}
, {t, b, d, p, w, c, g, g, g, h, h, a, p, p, p, p, p, p, p}
, {m, h, p, p, p, w, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {m, d, p, c, r, r, p, p, p, r, p, r, r, p, p, p, p, p, p}
, {p, h, d, r, p, p, p, p, m, a, r, m, i, r, p, p, p, p, p}
, {r, r, r, p, p, p, p, d, a, a, i, i, p, p, r, r, p, p, p}
, {m, m, p, p, p, p, p, d, a, a, p, p, p, p, p, r, p, p, p}
, {y, g, g, p, p, p, p, p, m, a, p, p, p, p, p, r, r, r, r}
, {b, d, d, p, p, m, q, m, a, m, p, p, p, p, p, p, p, p, p}
, {i, m, i, p, m, q, q, q, m, i, p, p, p, p, p, p, p, p, p}
}





--ChartRiver(r, {12, 19}, terrainLayoutResult)
--put a ford at the nth square along river 1
--eg, if the river is 17 squares long (from one edge, along the path of the river, to the other end), then
--putting a ford on square 11 will have the 11th square downstream from the head of the river be a ford


