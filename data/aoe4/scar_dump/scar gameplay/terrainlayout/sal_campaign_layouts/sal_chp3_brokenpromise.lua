-- Campaign Map Generation Quick-Start Template

-- ////// NOT IMPORTANT TO YOU ////////////////////////////////////////////////////////////////////////////////////////////////////

-- Create the course grid. This is the table that holds the terrain types that will be used to generate the map in a 2D grid
terrainLayoutResult = {}    -- set up initial table for coarse map grid

-- Setting useful variables to reference world dimensions
gridHeight, gridWidth, gridSize = SetCoarseGrid()

if (gridHeight % 2 == 0) then -- Height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- Width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end

gridSize = gridWidth -- Set resolution of coarse map
-- NOTE: AoE4 MapGen is designed to generate square maps. The grid you will be working with will always need to have gridWidth = gridHeight

-- Set the number of players
playerStarts = worldPlayerCount

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



-- ////// THIS IS WHAT YOU WANT //////////////////////////////////////////////////////////////////////////////////////////////////

-- Ground tile types
p = { terrainType = tt_plains  }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains }
i = { terrainType = tt_impasse_mountains }
u = { terrainType = tt_valley_shallow }
f = { terrainType = tt_flatland }
v = { terrainType = tt_valley }

-- Cliff terrain types
p0 = { terrainType = tt_plains_cliff }
p1 = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_med }
p3 = { terrainType = tt_plateau_high }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

-- Forests
-- Use these to spawn dense tree areas
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }


-- Define river-related data
-- Each of these defines a separate river to use on the grid layout
-- Feel free to add more if necessary
r1 = { terrainType = tt_river }
r2 = { terrainType = tt_river }
r3 = { terrainType = tt_river }
r4 = { terrainType = tt_river }
r5 = { terrainType = tt_river }
r6 = { terrainType = tt_river }
r7 = { terrainType = tt_river }
r8 = { terrainType = tt_river }
r9 = { terrainType = tt_river }
o =  { terrainType = tt_ocean }

-- These tables hold necessary information about water features for mapgen
riverResult = {}
fordResults = {}
woodBridgeResults = {}
stoneBridgeResults = {}

--640 map grid
terrainLayoutResult =
{ {p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p}
, {p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p}
, {p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p}
, {p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p}
, {f,  p,  p,  p,  p,  p,  p,  p,  f,  p,  p,  f,  f,  f,  p,  p}
, {o,  f,  f,  p,  p,  p,  f,  f,  o,  f,  f,  o,  o,  o,  f,  p}
, {o,  o,  o,  f,  f,  f,  o,  o,  o,  o,  o,  o,  o,  o,  o,  f}
, {o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o}
, {o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o}
, {o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o,  o}
, {f,  o,  o,  o,  o,  o,  o,  f,  f,  f,  o,  o,  o,  o,  o,  f}
, {f,  f,  o,  o,  f,  f,  f,  f,  p,  f,  f,  f,  o,  o,  f,  f}
, {p,  f,  f,  f,  f,  p,  p,  p,  p,  p,  p,  p,  f,  f,  f,  p}
, {p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p}
, {p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p}
, {p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p}
}

-- Init Rivers
--ChartRiver(r1, {1, 9}, terrainLayoutResult)
--ChartRiver(r2, {16, 11}, terrainLayoutResult)

-- Insert Fords
--table.insert(fordResults, { riverResult[1][3] })