-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
------------------------------------------------------
--GRID BASED MAP GENERATION
------------------------------------------------------
--This is a sample map that shows off how generation is done using the grid-based system
--Unlike a fully generated/scripted map, this grid-based system allows for quick turnaround time and instantaneous results

------------------------------------------------------
--General Setup
------------------------------------------------------
--This section should be included in every Map LUA script

-- creates the table for the coarse grid that'll hold all the terrain data
terrainLayoutResult = {}

--useful reference variables
gridHeight = Round(worldTerrainHeight / 46.5, 0) -- resolution of coarse map rows
gridWidth = Round(worldTerrainWidth / 46.5, 0) -- resolution of coarse map columns
gridSize = gridWidth

if (gridHeight % 2 == 0) then
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then
	gridWidth = gridWidth - 1
end

--sets the number of players
playerStarts = worldPlayerCount

------------------------------------------------------
--Terrain Types
------------------------------------------------------
--This section maps each of the terrain types to a shorter alphanumeric key to make the grid manageable
--These terrain types (and more) can be found in the following directory in the Attribute Editor: mapgen\map_gen_terrain_type

-- base terrain types
p = { terrainType = tt_plains }
h = { terrainType = tt_hills }
g = { terrainType = tt_hills_gentle_rolling }
h = { terrainType = tt_hills_low_rolling}
d = { terrainType = tt_hills_med_rolling }
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains}
i = { terrainType = tt_impasse_mountains}
c = { terrainType = tt_plateau_standard }
cl = { terrainType = tt_plateau_low }
ch = { terrainType = tt_plateau_high }
v = { terrainType = tt_valley }
vs = { terrainType = tt_valley_shallow }

--forests
s = { terrainType = tt_trees_plains_stealth }
j = { terrainType = tt_impasse_trees_plains }
kl = { terrainType = tt_impasse_trees_hills_low_rolling }
kh = { terrainType = tt_impasse_trees_hills_high_rolling }

--lakes and oceans
o = { terrainType = tt_ocean } 
r = { terrainType = tt_river }
l = { terrainType = tt_lake_deep }
ls = { terrainType = tt_lake_shallow }

--rivers
--each river needs to be defined individually 
--a branch in a river requires its own entry
r1 = { terrainType = tt_river } --main river
r2 = { terrainType = tt_river } --branching river

--playerstarts
--each player needs to be defined individually
q0 = { terrainType = tt_player_start_classic_plains, playerIndex = 0 }
q1 = { terrainType = tt_player_start_classic_plains, playerIndex = 1 }
q2 = { terrainType = tt_player_start_classic_hills_low_rolling, playerIndex = 2 }
q3 = { terrainType = tt_player_start_classic_hills_low_rolling, playerIndex = 3 }
q4 = { terrainType = tt_player_start_classic_plateau_med, playerIndex = 4 }
q5 = { terrainType = tt_player_start_classic_hills, playerIndex = 5 }
q6 = { terrainType = tt_player_start_classic_plains, playerIndex = 6 }
q7 = { terrainType = tt_player_start_classic_plains, playerIndex = 7 }

--resources
yg = { terrainType = tt_tactical_region_gold_plains_a }
ygc = { terrainType = tt_tactical_region_gold_plateau_high_a }
ys = { terrainType = tt_tactical_region_stone_plains_a }
ysc = { terrainType = tt_tactical_region_stone_plateau_low_a }


--the special "none" terrain type fills in randomly based on the AE data template and parameters/probability defined
n = tt_none

------------------------------------------------------
--Map Grid
------------------------------------------------------
--This section is where the grid and its contents are defined
--The grid must be square in shape (equal number of rows and columns)
--The grid resolution dictates the size of the terrain features in the map, however you can still play on different map sizes
--For example, a single mountain tile on a high resolution grid will look smaller in game, compared to the same tile
--on a smaller resolution grid

--Use the terrain types mapped above to create your terrain layout!
--This example shows a little bit of each terrain type
terrainLayoutResult =
{ {m, m, p, j, j, j, j, j, j, j, j, p, r1, 	p,  c, c, c, c, c, b, cl,cl,cl,cl}
, {m, m, p, p, j, j, j, j, j, j, p, p, r1, 	p,  c, c, c, c, c, b, cl,cl,cl,cl}
, {m, m, p, p, p, j, j, j, j, p, p, p, r1,  p,  c, c, c, c, c,cl, cl,cl,cl,cl} 
, {m, m, p, p, p, p, j, j, p, p, p, p, r1,  p,  c, c, c, c, c,cl, cl,cl,cl,cl}
, {p, m, m, m, p, p, p, p, p, p, p, p, r1,  p,  p, c, c, c, c,cl, h, h, p, p }
, {p, p, m, m, p, p, p, p, p, p, p, p, r1,  p,  p, p, p, p, c, h, h, h, p, p }
, {p, p, p, m, m, p, p, p, p, p, p, p, r1,  p,  p, p, p, p, h, h, h, p, o, o }
, {p, p, p, m, m, p, p, p, s, s, p, p, r1,  p,  p, p, p, p, p, p, p, p, o, o }
, {p, p, p, m, m, p, p, s, s, s, s, p, r1,  p,  p, p, p, p, p, p, p, o, o, o }
, {h, p, p, p, l, l, p, s, s, s, p, p, r1,  p,  p, p, p, p, p, p, o, o, o, o }
, {p, p, p, l, l, l, p, p, s, s, p, p, r1,  p,  p, p, p, s, p, p, o, o, o, o }
, {p, p, p, l, l, l, l, p, s, h, p, p, r1,  p,  p, p, s, s, p, o, o, o, o, o }
, {p, p, l, l, l, l, l, l, p, h, p, p, r1,  p,  p, p, s, s, o, o, o, o, o, o } 
, {p, p, l, l, l, l, l, l, p, p, p, r1, p, r2,  p, p, s, s, p, o, o, o, o, o }
, {p, p, l, l, l, l, l, p, p, p, p, r1,yg,  p, r2, p, p, p, p, p, p, p, o, o }
, {p, p, p, l, l, l, l, p, p, p, p, r1, p, ys, r2, p, p, p, p, p, p, p, p, o }
, {p, p, p, p, p, p, p, p, p, p, p, r1, p,  p, r2, p, p, p, p, p, p, p, p, o }
, {j, p, p, p, h, p, p, p, p, p, p, r1, p, yg, r2, p, p, p, p, q1,p, p, p, o }
, {j, p, p, h, h, h, p, p, p, p, p, r1, p,  p, p, r2, p, p, p, p, p, p, o, o }	
, {j, j, p, p, p, p, p, p, h, h, p, r1,yg,  p, p, r2, p, p, p, h, p, p, o, o }
, {j, j, p, p, p,q0, p, h, h, h, p, r1, p,  p, ys,r2, p, j, p, h, h, p, o, o }
, {j, j, p, p, p, p, h, h, h, h, p, r1, p,  p, p, r2, p, j, j, j, h, o, o, o }
, {j, p, p, p, h, p, p, p, p, h, p, r1, p,  p, p, r2, p, j, j, j, p, o, o, o }	
, {p, p, p, p, p, p, p, p, p, p, p, r1, p, yg, p, r2, p, j, j, j, p, o, o, o }	
}
--Some additional things to keep in mind:
--Oceans must always touch at least one edge or corner of the map
--Rivers must start or end along the map edge OR be touching another river that it branches from
--A branching river must be adjacent (vertically, horizontally or diagonally) to one tile in the main river that it connects to
--Rivers don't have to branch, and you can have multiple parallel rivers
--Rivers cannot cross each other and cannot intersect with oceans or lakes
--Plateaus require hills placed close by in order to access the elevated terrain (height of the plateau affects height of hill needed)
--Height values of terrain types are magnified when placed next to terrain with similar height properties (a mountain next to an impasse mountain is taller than a mountain next to a plain)
--You will need to ensure that there are enough playerstarts if the map will be played with more players (currently there are 2 players supported)

------------------------------------------------------
--River generation
------------------------------------------------------
--If a river is defined in the grid above, this step must be taken, otherwise DO NOT include this section in the script

--Generate river result tables for river generation, these tables need to be named exactly as shown
riverResult = {}
fordResults = {}
stoneBridgeResults = {}
woodBridgeResults = {}

--The function takes in the following parameters: ChartRiver(rivernumber, {x y coordinates for first river tile}, terrainLayoutResult)
--The first river tile coordinates specifies the "start" of the river -- it will always flow downstream from the first tile
ChartRiver(r1, {1,13}, terrainLayoutResult)
ChartRiver(r2, {13,13}, terrainLayoutResult)

--Each river must call and insert its crossings individually on a per-river basis, per crossing type
--Only one crossing can be present on a tile at a time
--You can have as many crossings in the river as you'd like otherwise
--Stone bridges cannot be destroyed via gameplay, however wooden bridges can be destroyed and repaired
--Add fords to the rivers by using the function: table.insert(fordResults, {riverResult[rivernumber][tilenumber]})
--Add stone bridges to the rivers by using the function: table.insert(stoneBridgeResults, {riverResult[rivernumber][tilenumber]})
--Add wooden bridges to the rivers by using the function: table.insert(woodBridgeResults, {riverResult[rivernumber][tilenumber]})

--These are the function calls to insert crossings on River1
table.insert(fordResults, {riverResult[1][4], riverResult[1][13], riverResult[1][20]})
table.insert(stoneBridgeResults, {riverResult[1][8]})

--This is the function calls to insert fords on River2 (river2 won't have bridges but it can)
table.insert(fordResults, {riverResult[2][4], riverResult[2][11]})
