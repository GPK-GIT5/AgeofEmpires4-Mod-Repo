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
l = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_impasse_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

--cliff terrain types
c = { terrainType = tt_plains_cliff }
x = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_med }
p3 = { terrainType = tt_plateau_high }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--water
--feel free to add more if necessary
r = { terrainType = tt_river }
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

terrainLayoutResult =
{ {g, p, r, p, p, p, p, p, g, g, g, p, g, g, g, g, p, p, p}
, {g, p, r, p, p, p, p, p, p, p, p, p, g, p, g, p, p, p, p}
, {g, p, r, r, r, r, r, r, r, r, r, r, p, p, p, p, p, p, g}
, {g, p, p, p, p, p, p, p, p, p, p, r, r, r, r, r, r, p, p}
, {g, g, g, p, p, p, p, p, p, p, p, p, p, p, p, p, r, r, r}
, {g, g, g, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {g, g, g, p, p, p, p, g, g, l, l, p, p, p, p, p, p, p, g}
, {g, g, g, g, g, g, p, g, g, g, g, l, l, p, p, p, p, p, g}
, {g, g, g, g, g, g, g, g, g, g, g, g, g, p, p, p, p, p, l}
, {p, p, p, p, g, g, g, g, g, g, g, g, g, p, p, l, l, l, h}
, {p, p, p, p, g, g, g, g, g, g, g, g, g, g, g, g, l, l, p}
, {x, x, x, g, l, l, l, g, g, g, g, g, g, g, g, g, g, g, g}
, {l, l, l, l, l, l, g, g, g, g, g, g, g, g, g, g, g, g, g}
, {l, l, l, l, l, l, l, g, g, g, g, g, g, g, g, g, g, g, g}
, {l, l, l, l, l, l, l, g, l, g, g, g, g, g, l, l, l, l, l}
, {l, l, l, l, l, l, l, g, g, g, g, g, g, g, l, l, l, l, l}
, {l, h, h, h, l, l, l, g, g, g, g, g, g, g, l, l, l, l, l}
, {h, h, h, h, h, h, h, l, g, g, g, g, g, g, l, l, l, l, l}
, {h, h, h, h, h, h, h, h, h, g, g, g, g, l, l, l, l, l, l}
}



--RIVER CODE---------------------------------------------------------------------
--Un comment the following lines if you are placing a river on the map
---------------------------------------------------------------------------------


--chart each separate river you've placed on the layout
--Args are as follows:
ChartRiver(r, {1,3}, terrainLayoutResult)
table.insert(fordResults, { riverResult[1][5], riverResult[1][8], riverResult[1][15], riverResult[1][17], riverResult[1][18], riverResult[1][19] })


