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
c = { terrainType = tt_plains_cliff }
--c = { terrainType = tt_plateau_low }
--c = { terrainType = tt_plateau_med }
p2 = { terrainType = tt_plateau_standard }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }

--water
--feel free to add more if necessary
r = { terrainType = tt_river }
z = { terrainType = tt_river }
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
	{ {o, o, c, h, h, p, d, p, p, d, p, d, d}	
	, {o, o, c, p, d, d, p, p, p, d, d, d, d}
	, {o, o, c, p, p, p, p, p, p, p, p, p, h}
	, {o, o, c, d, p, p, p, p, p, p, p, p, h}
	, {o, o, c, p, p, p, p, p, p, p, p, p, d}
	, {z, z, z, z, z, z, p, p, p, p, p, p, p}
	, {o, o, c, p, p, p, z, z, z, p, p, p, p}
	, {o, o, c, d, p, p, p, p, p, z, z, z, z}
	, {o, o, c, g, p, p, p, p, p, p, p, p, d}
	, {o, o, p, d, p, p, p, p, p, p, r, r, r}
	, {r, o, p, d, p, p, r, r, r, r, p, p, p}
	, {o, r, r, r, r, r, r, p, p, p, d, p, p}
	, {o, o, c, p, p, p, p, p, p, d, g, d, p}
}

-- Set up the rivers
ChartRiver(r, {10, 13}, terrainLayoutResult)
ChartRiver(z, {8, 13}, terrainLayoutResult)

 --table.insert(fordResults, { riverResult[1][5] })
 --table.insert(fordResults, { riverResult[2][7] })

