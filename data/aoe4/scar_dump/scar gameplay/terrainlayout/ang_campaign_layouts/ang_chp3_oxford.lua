--the "none" type will be randomly filled by your AE data temqate
n = tt_none


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
p = { terrainType = tt_flatland  }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_high_rolling }
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_hills_plateau }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }

--water
r = { terrainType = tt_valley }


-- initialize the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)


terrainLayoutResult =
{ {p, j, r, p, p, p, p, p, d, d, d, d, j, p, p, p, p}
, {p, p, p, p, p, p, p, p, h, h, d, j, p, p, p, p, p}
, {d, p, r, d, j, p, p, j, h, h, p, p, p, p, p, p, p}
, {p, p, r, d, p, p, p, p, p, p, p, p, p, p, p, p, p}
, {j, d, r, p, d, p, m, d, d, d, d, p, p, p, p, p, p}
, {p, p, d, r, p, p, m, d, d, d, e, m, p, p, p, j, p}
, {r, r, p, r, r, p, p, d, d, d, d, d, m, p, p, p, p}
, {p, p, p, j, r, r, p, d, d, d, d, d, d, p, p, p, j}
, {p, j, r, p, p, p, p, d, d, d, d, d, d, p, p, p, p}
, {p, p, r, p, p, r, p, p, m, d, d, d, d, p, p, j, p}
, {p, p, p, r, d, r, p, p, p, m, d, d, p, p, p, u, u}
, {j, p, p, r, d, r, j, p, p, p, p, p, p, u, u, u, p}
, {d, p, p, r, p, r, j, p, p, p, p, p, u, u, d, d, p}
, {d, j, p, p, p, r, p, p, p, p, p, p, u, d, h, h, p}
, {d, d, p, p, p, r, j, j, p, p, p, j, u, d, h, s, d}
, {d, d, j, p, p, p, d, p, p, p, p, u, u, j, p, d, d}
, {h, h, h, p, p, p, r, d, p, j, p, u, p, p, p, p, p}
}

