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
i = { terrainType = tt_impasse_mountains }

--cliff terrain types
--c = { terrainType = tt_plains_cliff }
c = { terrainType = tt_plateau_low }
j = { terrainType = tt_plateau_med }
p3 = { terrainType = tt_plateau_high }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--water
--feel free to add more if necessary
r = { terrainType = tt_river }
z = { terrainType = tt_river }
x = { terrainType = tt_river }
y = { terrainType = tt_river }
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




--MEDIUM map grid
terrainLayoutResult =
{ {p, p, p, p, p, r, g, d, d, c, p, p, c, d, p, d, g, g, g, d, d, g, g, d, d, g} --1
, {p, p, p, p, r, g, d, d, d, c, p, p, c, d, d, g, d, d, d, d, p, d, d, d, d, d} --2
, {p, p, p, p, r, g, d, d, c, c, p, p, c, d, d, d, d, g, g, d, d, c, c, c, c, c} --3
, {p, p, p, p, r, g, d, d, c, p, p, p, c, d, g, g, d, d, d, d, c, p, p, p, p, p} --4
, {p, p, p, r, g, d, d, d, c, p, p, p, c, d, d, d, d, c, c, c, p, p, p, p, p, p} --5
, {p, p, p, r, g, d, d, d, c, p, p, p, c, d, d, m, c, p, p, p, p, p, p, p, p, p} --6
, {p, p, r, p, z, c, c, c, p, p, p, p, p, c, d, c, p, p, p, p, p, p, p, p, p, p} --7
, {p, r, p, p, z, p, p, p, p, p, p, p, p, c, c, p, p, p, p, p, p, p, p, p, p, p} --8
, {p, r, y, y, z, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p} --9
, {p, r, p, p, z, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, g, g, g, g, g} --10
, {p, r, p, p, z, p, p, p, p, p, p, p, p, p, p, p, g, g, g, g, g, g, g, g, g, g} --11
, {p, r, x, x, z, p, p, p, p, p, p, p, p, p, p, g, g, g, g, g, g, g, g, d, d, d} --12
, {p, r, p, p, z, p, p, p, p, p, p, p, p, p, p, g, g, g, g, g, g, g, d, d, d, d} --13
, {p, r, p, p, z, p, p, p, p, p, p, p, p, p, p, g, g, g, g, g, g, g, d, d, d, d} --14
, {p, r, p, p, z, p, p, p, p, p, p, p, p, p, g, h, h, g, g, g, g, g, g, g, d, d} --15
, {p, r, p, p, z, p, p, p, p, p, p, p, p, p, g, h, h, g, g, g, g, p, p, g, g, d} --16
, {p, r, p, p, z, p, p, p, p, p, p, p, p, g, g, g, g, g, g, g, p, p, p, p, g, g} --17
, {p, r, p, p, z, p, p, p, p, p, p, p, p, g, g, p, p, p, p, p, p, p, p, p, p, p} --18
, {p, r, p, p, z, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p} --19
, {p, p, r, p, z, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p} --20
, {p, p, p, r, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p, p} --21
, {p, p, p, r, p, p, p, p, p, p, p, p, p, p, p, p, c, c, c, p, p, p, p, p, p, p} --22
, {p, p, p, p, r, p, p, p, p, p, p, p, p, p, p, c, d, d, d, c, p, p, p, p, p, p} --23
, {p, p, p, p, r, p, p, p, p, p, p, p, p, c, c, d, d, d, d, d, c, c, c, p, p, p} --24
, {p, p, p, p, p, r, p, p, c, c, c, c, c, d, d, d, d, d, d, d, d, d, d, c, p, p} --25
, {p, p, p, p, p, p, r, c, d, d, d, d, d, d, d, g, g, g, d, d, g, g, d, d, c, p} --26
}--1           5              10             15             20             25             30             35



--RIVER CODE---------------------------------------------------------------------
--Un comment the following lines if you are placing a river on the map
---------------------------------------------------------------------------------


--chart each separate river you've placed on the layout
--Args are as follows:
--ChartRiver(riverIndex, startingCoordinateTable, terrainLayoutResult)

--The ChartRiver function does not care what type of river you are making (main river or tributary)
--It also allows you to specify subsequent river points diagonally.

--little chart
ChartRiver(r, {26, 7}, terrainLayoutResult)
ChartRiver(z, {21, 4}, terrainLayoutResult)
ChartRiver(x, {13, 2}, terrainLayoutResult)
ChartRiver(y, {10, 2}, terrainLayoutResult)


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
