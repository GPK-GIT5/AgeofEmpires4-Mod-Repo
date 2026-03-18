
n = tt_none

h = tt_hills
ht = tt_hills_high_test
hr = tt_hills_rocky
m = tt_mountains
i = tt_impasse_mountains
k = tt_mountains_small
b = tt_hills_high_rolling
o = tt_ocean
u = tt_plains
f = tt_flatland
s = tt_player_start_classic_hills_high_rolling
bb = tt_bounty_berries_flatland
p = tt_hills_plateau
pt = tt_hills_plateau_test
v = tt_valley
vs = tt_valley_shallow
bg = tt_bounty_gold_plains
c = tt_plains_clearing

f1 = tt_impasse_trees_plains
f2 = tt_impasse_trees_hills_low_rolling
f3 = tt_impasse_trees_hills_high_rolling

cc = tt_city_centre
cf = tt_city_farming
cm = tt_city_military
cl = tt_city_lumbercamp
cs = tt_city_stonecamp
cg = tt_city_goldcamp

terrainLayoutResult = {}    -- set up initial table for coarse map grid

gridHeight = Round(worldTerrainHeight / 46.5, 0) -- set resolution of coarse map rows
gridWidth = Round(worldTerrainWidth / 46.5, 0) -- set resolution of coarse map columns

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end

gridSize = gridWidth -- set resolution of coarse map




--Whole terrain combo tests
-- setting up the map grid

--[[
terrainLayoutResult = 
{ {n, m, n, n, m, n, n, n, n, n, n}
, {n, m, m, m, m, n, m, n, n, m, n}
, {n, n, m, n, n, n, n, m, m, n, n}
, {n, n, m, n, n, m, n, n, n, n, n}
, {n, h, m, n, n, n, p, n, n, n, n}
, {n, m, h, m, n, n, b, n, n, n, n}
, {n, m, n, n, n, n, n, n, m, m, n}
, {n, n, n, p, p, b, n, n, m, n, n}
, {n, m, b, p, n, v, m, n, h, n, n}
, {n, n, n, n, m, m, m, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}
]]--

--[[
--plateau tests
terrainLayoutResult = 
{ {n, n, n, n, n, n, f, f, f, f, n}
, {n, p, n, n, n, n, f, p, p, p, n}
, {n, n, n, n, n, n, f, v, v, v, n}
, {n, n, n, n, p, n, n, n, n, n, n}
, {n, n, n, p, p, p, n, n, n, n, n}
, {n, n, n, v, p, p, n, n, n, n, n}
, {n, n, v, v, v, p, n, n, n, n, n}
, {n, n, n, v, v, p, n, b, p, n, n}
, {n, p, b, v, v, v, n, n, b, n, n}
, {n, p, n, n, v, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}
]]--

--[[
--mountain testing
--testing map feature layouts
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, m, n, n, n, n, n, n, n, n}
, {n, m, m, n, n, n, v, m, m, n, n}
, {n, m, h, n, n, n, f, h, f, n, n}
, {n, n, n, n, n, n, m, m, m, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, m, v, m, n, n, n, n, n, n, n}
, {n, f, h, m, n, n, n, n, m, n, n}
, {n, m, f, h, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}
]]--



--[[
-- testing different hill heights
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n}
, {n, h, n, n, b, n, n, n, n, v, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, b, b, n, n, n, n, n}
, {n, h, h, n, n, n, n, n, v, v, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, h, h, n, b, b, n, n, v, v, n}
, {n, n, h, n, b, b, n, n, v, v, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}
]]--

--[[
--plains testing
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n}
, {n, u, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, u, u, n, n, n, u, u, n, n, n}
, {n, u, n, n, n, n, u, u, n, n, n}
, {n, u, n, n, n, n, n, n, n, n, n}
, {n, u, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}
]]--


--[[
--hills testing
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n}
, {n, h, n, n, b, n, n, s, b, b, n}
, {n, n, n, n, n, n, n, n, n, b, n}
, {n, n, n, n, n, n, n, n, n, b, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, h, h, n, n, n, b, b, n, n, n}
, {n, h, n, n, n, n, b, b, n, n, n}
, {n, h, n, n, n, n, n, n, n, n, n}
, {n, s, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, b, b, b, b, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}
]]--

--[[
--impasse testing
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, i, n}
, {n, n, i, n, n, n, n, i, i, i, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, i, n, n, n, n, n, n, n}
, {n, n, n, i, i, n, n, n, n, n, n}
, {n, i, n, n, n, n, n, n, i, n, n}
, {n, i, n, n, n, n, n, i, i, n, n}
, {n, n, n, n, n, n, n, n, i, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}


--choke point testing
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, vs, n, m, n, n, n}
, {n, n, n, n, k, vs, k, n, n, n, n}
, {n, n, n, m, m, v, m, n, n, n, n}
, {n, n, n, n, k, vs, k, n, n, n, n}
, {n, n, n, n, n, vs, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}

--plateau feature testing
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, p, n, n, n, n, pt, b, n, n}
, {n, p, b, b, n, n, b, p, b, n, n}
, {n, p, h, n, n, n, b, pt, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, p, n, n, n, n, n, n, n, n}
, {n, b, b, p, n, n, n, n, n, n, n}
, {n, b, h, p, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}


--valley feature tests
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n}
, {n, v, v, v, n, n, n, h, v, b, n}
, {n, vs, v, vs, n, n, n, b, v, h, n}
, {n, n, m, n, n, n, n, h, v, h, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}


--resource corner tests
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n}
, {n, k, m, b, n, n, n, n, n, n, n}
, {n, v, bg, m, n, n, n, n, n, n, n}
, {n, n, v, m, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}


--mountain city test
terrainLayoutResult = 
{ {s, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, k, k, k, v, k, n, n, n}
, {n, n, n, k, cf, n, n, k, n, n, n}
, {n, n, n, k, h, cc, cm, k, n, n, n}
, {n, n, n, k, cg, b, n, k, n, n, n}
, {n, n, n, k, k, k, h, v, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, s}
}



--plains city test
terrainLayoutResult = 
{ {s, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, b, b, b, v, b, n, n, n}
, {n, n, n, b, cf, n, n, b, n, n, n}
, {n, n, n, b, h, cc, cm, b, n, n, n}
, {n, n, n, b, cg, b, n, b, n, n, n}
, {n, n, n, b, b, b, h, v, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, s}
}


--forest area testing
terrainLayoutResult = 
{ {s, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, v, n, c, n, n, n, n, m, n, n}
, {n, n, f1, c, f1, v, n, n, n, n, n}
, {n, n, f1, c, f1, v, n, n, f1, v, n}
, {n, n, n, c, n, v, n, n, v, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, m, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, m, n, n, n, n, n}
, {n, n, n, n, n, n, v, n, n, s, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}
]]--

--[[
terrainLayoutResult = 
{ {s, f1, f1, f1, f1, f1, f1, f1, f1, f1, f1}
, {f1, f1, f1, f1, f1, f1, f1, f1, f1, f1, f1}
, {f1, f1, f1, f1, f1, f1, f1, f1, f1, f1, f1}
, {f1, f1, f1, f1, f1, f1, f1, f1, f1, f1, f1}
, {f1, f1, f1, f1, f1, f1, f1, f1, f1, f1, f1}
, {f1, f1, f1, f1, f1, f1, f1, f1, f1, f1, f1}
, {f1, f1, f1, f1, f1, f1, f1, f1, f1, f1, f1}
, {f1, f1, f1, f1, f1, f1, f1, f1, f1, f1, f1}
, {f1, f1, f1, f1, f1, f1, f1, f1, f1, f1, f1}
, {f1, f1, f1, f1, f1, f1, f1, f1, f1, f1, f1}
, {f1, f1, f1, f1, f1, f1, f1, f1, f1, f1, s}
}


terrainLayoutResult = 
{ {s, c, c, f1, c, c, c, f1, c, c, s}
, {c, c, c, c, c, c, c, c, c, c, c}
, {c, c, c, f1, c, c, c, f1, c, c, c}
, {f1, c, c, f1, f1, f1, f1, c, c, c, c}
, {c, f1, c, c, c, c, c, c, c, c, c}
, {c, c, f1, c, c, c, c, c, c, c, c}
, {c, c, f1, c, c, c, c, c, f1, c, c}
, {c, c, c, c, c, c, c, c, c, f1, f1}
, {c, c, c, c, f1, f1, f1, c, c, c, c}
, {c, c, c, c, c, c, c, c, c, c, c}
, {s, c, c, f1, c, c, c, f1, c, c, s}
}


terrainLayoutResult = 
{ {s, n, n, n, n, n, n, n, m, m, n}
, {n, n, n, n, n, n, n, n, m, n, n}
, {m, n, n, n, n, n, n, m, n, n, n}
, {n, m, n, n, n, n, n, m, n, n, n}
, {n, m, f1, f1, c, f1, f1, n, n, n, n}
, {n, n, f1, f1, c, f1, f1, n, n, n, n}
, {n, n, f1, f1, c, f1, f1, n, n, n, n}
, {n, n, f1, f1, c, f1, f1, n, n, n, n}
, {n, m, f1, f1, c, f1, f1, m, m, m, n}
, {n, m, m, n, n, n, n, n, n, m, n}
, {n, m, n, n, n, n, n, n, n, n, s}
}


terrainLayoutResult = 
{ {s, n, n, n, n, n, n, n, n, n, s}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, k, k, n, n, n, n, n, k, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, k, n, n, n, n, n, n, n}
, {n, n, k, n, n, n, n, n, n, n, n}
, {n, k, k, n, n, n, n, k, k, k, n}
, {n, k, k, n, n, n, n, k, k, k, n}
, {n, k, n, n, n, n, n, n, k, k, n}
, {s, n, n, n, n, n, n, n, n, n, s}
}


terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, i, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, v, h, n, k, k, i, i, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, v, n, n, n, n, k, k, k, n, n, n}
, {n, n, n, n, k, n, n, n, n, n, v, n, n, n, n, n, k, k, n, b, n}
, {n, n, n, h, n, n, n, n, b, n, v, n, n, n, n, n, n, k, n, n, n}
, {n, n, n, n, v, n, n, n, n, v, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, k, i, n, v, v, v, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, k, k, n, n, i, n, n, k, n, n, b, n, n, h, n, n, n}
, {n, n, n, k, n, n, n, n, n, n, n, n, n, n, b, b, n, n, v, n, n}
, {n, i, k, n, n, n, n, n, n, n, n, n, n, k, n, n, n, n, v, n, n}
, {n, v, k, n, n, b, n, h, n, n, n, n, n, n, n, n, n, v, v, n, n}
, {n, v, n, n, n, n, n, n, h, n, n, n, n, n, n, n, n, v, n, n, n}
, {n, v, v, b, n, n, n, n, b, n, n, k, n, n, n, n, n, n, n, n, n}
, {n, h, v, b, n, n, h, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, k, i, b, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, k, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, v, n, n, n, v, v, n, n, n, n, n}
, {n, n, n, n, n, n, n, b, n, n, i, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
}

terrainLayoutResult[1][1].playerIndex = 0
terrainLayoutResult[1][1].terrainType = s
terrainLayoutResult[gridSize-1][gridSize-1].playerIndex = 1
terrainLayoutResult[gridSize-1][gridSize-1].terrainType = s
]]--



s1 = "0"
	

s2 = "1"
	

n = { terrainType = tt_none }

f1 = "forest"

terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

p1 = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_med }
p3 = { terrainType = tt_plateau_high }
t = { terrainType = tt_hills_plateau }
g = { terrainType = tt_hills_gentle_rolling }
h = { terrainType = tt_hills_high_rolling }
l = { terrainType = tt_hills_low_rolling }
w = { terrainType = tt_hills_med_rolling }
u = { terrainType = tt_valley_shallow }
m = { terrainType = tt_mountains }
k = { terrainType = tt_mountains_small }
i = { terrainType = tt_rock_spire }
v = { terrainType = tt_valley }

s = { terrainType = tt_hills_high_rolling, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

-- blank map grid
--[[
terrainLayoutResult = 
{ {n, n, n, n, n, n, n, n, p1, n, n}
, {n, n, n, m, n, n, n, p2, p1, l, n}
, {n, n, h, p3, n, n, n, n, p1, n, n}
, {n, n, p1, p2, n, n, n, n, n, n, n}
, {n, n, n, m, p2, n, n, n, n, n, n}
, {n, n, n, p1, k, p3, n, n, p1, p2, n}
, {n, n, n, p2, h, h, n, n, l, u, n}
, {n, n, n, p1, p2, p3, n, n, n, n, n}
, {n, n, u, n, n, h, k, n, p2, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n}
}
]]--

terrainLayoutResult =
{ {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, g, p1, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, p1, n, n, n, n, l, p1, n, n, n, n, l, l, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, p2, n, n, n, n, w, p2, n, n, n, n, w, w, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, p3, n, n, n, n, h, p3, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, n, v, n, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, v, v, v, n, n, n, h, h, n, n, n}
, {n, n, n, i, n, n, n, v, v, i, v, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, v, v, v, n, n, n, n, n, n, n, n}
, {n, n, n, n, n, n, n, n, v, n, n, n, n, n, n, n, n, n, n}	
}

--[[

for i = 1, #terrainLayout[1] do
	for j = 1, #terrainLayout[1] do
		
		if(terrainLayout[i][j] == "forest") then
			terrainLayoutResult[i][j].terrainType = tt_impasse_trees_plains
		end
		
		if(terrainLayout[i][j] == "0") then
			terrainLayoutResult[i][j].terrainType = tt_plains
			terrainLayoutResult[i][j].playerIndex = 0
		end
		
		if(terrainLayout[i][j] == "1") then
			terrainLayoutResult[i][j].terrainType = tt_plains
			terrainLayoutResult[i][j].playerIndex = 1
		end
		
	end
end



terrainLayoutResult[1][1].playerIndex = 0
--terrainLayoutResult[1][1].terrainType = u
--terrainLayoutResult[gridSize-1][gridSize-1].playerIndex = 1
terrainLayoutResult[gridSize-1][gridSize-1].terrainType = u


for i = 1, gridSize do
	for j = 1, gridSize do
	
	--world height gradient testing
	--Quarry layout?
	--[[
	terrainLayoutResult[i][j].terrainType = u
	terrainLayoutResult[i][j].heightOverWidthOverride = ((i + j) / 7.5)
	
	if((i == j or i == j-1 or i == j+1 or i == j-2 or i == j+2)and i < (gridSize / 2 + gridSize / 8)) then
		terrainLayoutResult[i][j].heightOverWidthOverride = (0.2)
	end
	
	--]]
	
	--Sheltered Pass from AoEO
	--[[
	terrainLayoutResult[i][j].terrainType = u
	terrainLayoutResult[i][j].heightOverWidthOverride = 2.2
	if(i == math.floor(gridSize / 2) or j == math.floor(gridSize / 2)) then
		terrainLayoutResult[i][j].heightOverWidthOverride = 0.2
	end
	
	--rocky hills testing
	
		terrainLayoutResult[i][j].heightOverWidthOverride = 1
		if(worldGetRandom() > 0.5) then
			terrainLayoutResult[i][j].terrainType = v
			terrainLayoutResult[i][j].heightOverWidthOverride = 1 - (0.6 * worldGetRandom())
		else
			terrainLayoutResult[i][j].terrainType = h
			terrainLayoutResult[i][j].heightOverWidthOverride = 1.3 + (0.5 * worldGetRandom())
		end
		
		
		
		
	end
end

]]

--[[
--MARKER TESTING
for i = 1, gridSize do
	for j = 1, gridSize do
	
	--ensure that each cell has a marker table
		terrainLayoutResult[i][j].markers = {}
		terrainLayoutResult[i][j].markers[1] = {}
		terrainLayoutResult[i][j].markers.name = nil
		terrainLayoutResult[i][j].markers.faceTowardsCenter = nil
		terrainLayoutResult[i][j].markers.radius = nil
		terrainLayoutResult[i][j].markers.markerType = nil
	
	end
end

hasCity = true
cityLocationX =  math.floor(gridSize/2)
cityLocationY =  math.floor(gridSize/2)
cityNum = 0
for i = 1, gridSize do
	for j = 1, gridSize do
	
		if(i == cityLocationX and j == cityLocationY) then
			
				markerName = "mkr_centre"
				terrainLayoutResult[i][j].markers[1].name = markerName
				terrainLayoutResult[i][j].markers[1].faceTowardsCenter = false
				terrainLayoutResult[i][j].markers[1].radius = 10
				terrainLayoutResult[i][j].markers[1].markerType = "Player Spawn"
				
				if(hasCity == true) then
					
					terrainLayoutResult[i][j].markers[2] = {}
					markerName = "mkr_city" .. cityNum
					terrainLayoutResult[i][j].markers[2].name = markerName
					terrainLayoutResult[i][j].markers[2].faceTowardsCenter = false
					terrainLayoutResult[i][j].markers[2].radius = 10
					terrainLayoutResult[i][j].markers[2].markerType = "Player Spawn"
					
					
				end
				
				
				--local heightFromMap = heightMap[i][j]
				--local heightScaled = (heightFromMap - 10) * heightMultiplier
				
				-- local currentHeight = (heightMap[i][j] - 10) * heightMultiplier
				--terrainLayoutResult[i][j].heightOverWidthOverride = heightScaled
				
				if(hasCity == true) then
					--ensure that the city has flat ground around the centre location
					--also place defense and attack markers all around the city
					print("placing city!")
					
					cityEGroupName = "eg_city" .. cityNum
					
					
					--place city centre on centre marker location
					terrainLayoutResult[cityLocationX][cityLocationY].terrainType = cs
					terrainLayoutResult[cityLocationX][cityLocationY].playerIndex = 1
					terrainLayoutResult[cityLocationX][cityLocationY].groupName = cityEGroupName
					
					--Check North
					---------------------------------------------------------------------------------
					terrainLayoutResult[cityLocationX][cityLocationY+1].terrainType = u
					terrainLayoutResult[cityLocationX][cityLocationY+2].terrainType = u
					
					--check if square has a marker
					if(terrainLayoutResult[cityLocationX][cityLocationY+1].markers[1].name == nil) then
						print("no existing marker north of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_n"
						terrainLayoutResult[cityLocationX][cityLocationY+1].markers[1].name = markerName
						terrainLayoutResult[cityLocationX][cityLocationY+1].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX][cityLocationY+1].markers[1].radius = 10
						terrainLayoutResult[cityLocationX][cityLocationY+1].markers[1].markerType = "Player Spawn"
						
					else
						print("there is an existing marker north of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_n"
						terrainLayoutResult[cityLocationX][cityLocationY+1].markers[2] = {}
						terrainLayoutResult[cityLocationX][cityLocationY+1].markers[2].name = markerName
						terrainLayoutResult[cityLocationX][cityLocationY+1].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX][cityLocationY+1].markers[2].radius = 10
						terrainLayoutResult[cityLocationX][cityLocationY+1].markers[2].markerType = "Player Spawn"
					
					end
					
					if(terrainLayoutResult[cityLocationX][cityLocationY+2].markers[1].name == nil) then
						print("no existing marker north of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_n"
						terrainLayoutResult[cityLocationX][cityLocationY+2].markers[1].name = markerName
						terrainLayoutResult[cityLocationX][cityLocationY+2].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX][cityLocationY+2].markers[1].radius = 10
						terrainLayoutResult[cityLocationX][cityLocationY+2].markers[1].markerType = "Player Spawn"
						
					else
						print("there is an existing marker north of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_n"
						terrainLayoutResult[cityLocationX][cityLocationY+2].markers[2] = {}
						terrainLayoutResult[cityLocationX][cityLocationY+2].markers[2].name = markerName
						terrainLayoutResult[cityLocationX][cityLocationY+2].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX][cityLocationY+2].markers[2].radius = 10
						terrainLayoutResult[cityLocationX][cityLocationY+2].markers[2].markerType = "Player Spawn"
					
					end
					
					
					--Check Northeast
					---------------------------------------------------------------------------------
					terrainLayoutResult[cityLocationX+1][cityLocationY+1].terrainType = cm
					terrainLayoutResult[cityLocationX+1][cityLocationY+1].playerIndex = 1
					terrainLayoutResult[cityLocationX+1][cityLocationY+1].groupName = cityEGroupName
					
					terrainLayoutResult[cityLocationX+2][cityLocationY+2].terrainType = u
					
					--check if square has a marker
					if(terrainLayoutResult[cityLocationX+1][cityLocationY+1].markers[1].name == nil) then
						print("no existing marker northeast of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_ne"
						terrainLayoutResult[cityLocationX+1][cityLocationY+1].markers[1].name = markerName
						terrainLayoutResult[cityLocationX+1][cityLocationY+1].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+1][cityLocationY+1].markers[1].radius = 10
						terrainLayoutResult[cityLocationX+1][cityLocationY+1].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker northeast of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_ne"
						terrainLayoutResult[cityLocationX+1][cityLocationY+1].markers[2] = {}
						terrainLayoutResult[cityLocationX+1][cityLocationY+1].markers[2].name = markerName
						terrainLayoutResult[cityLocationX+1][cityLocationY+1].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+1][cityLocationY+1].markers[2].radius = 10
						terrainLayoutResult[cityLocationX+1][cityLocationY+1].markers[2].markerType = "Player Spawn"
					end
					
					if(terrainLayoutResult[cityLocationX+2][cityLocationY+2].markers[1].name == nil) then
						print("no existing marker northeast of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_ne"
						terrainLayoutResult[cityLocationX+2][cityLocationY+2].markers[1].name = markerName
						terrainLayoutResult[cityLocationX+2][cityLocationY+2].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+2][cityLocationY+2].markers[1].radius = 10
						terrainLayoutResult[cityLocationX+2][cityLocationY+2].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker northeast of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_ne"
						terrainLayoutResult[cityLocationX+2][cityLocationY+2].markers[2] = {}
						terrainLayoutResult[cityLocationX+2][cityLocationY+2].markers[2].name = markerName
						terrainLayoutResult[cityLocationX+2][cityLocationY+2].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+2][cityLocationY+2].markers[2].radius = 10
						terrainLayoutResult[cityLocationX+2][cityLocationY+2].markers[2].markerType = "Player Spawn"
					end
					
					--Check East
					---------------------------------------------------------------------------------
					terrainLayoutResult[cityLocationX+1][cityLocationY].terrainType = cf
					terrainLayoutResult[cityLocationX+1][cityLocationY].playerIndex = 1
					terrainLayoutResult[cityLocationX+1][cityLocationY].groupName = cityEGroupName
					
					
					terrainLayoutResult[cityLocationX+2][cityLocationY].terrainType = u
					
					--check if square has a marker
					if(terrainLayoutResult[cityLocationX+1][cityLocationY].markers[1].name == nil) then
						print("no existing marker east of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_e"
						terrainLayoutResult[cityLocationX+1][cityLocationY].markers[1].name = markerName
						terrainLayoutResult[cityLocationX+1][cityLocationY].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+1][cityLocationY].markers[1].radius = 10
						terrainLayoutResult[cityLocationX+1][cityLocationY].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker east of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_e"
						terrainLayoutResult[cityLocationX+1][cityLocationY].markers[2] = {}
						terrainLayoutResult[cityLocationX+1][cityLocationY].markers[2].name = markerName
						terrainLayoutResult[cityLocationX+1][cityLocationY].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+1][cityLocationY].markers[2].radius = 10
						terrainLayoutResult[cityLocationX+1][cityLocationY].markers[2].markerType = "Player Spawn"
					end
					
					if(terrainLayoutResult[cityLocationX+2][cityLocationY].markers[1].name == nil) then
						print("no existing marker east of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_e"
						terrainLayoutResult[cityLocationX+2][cityLocationY].markers[1].name = markerName
						terrainLayoutResult[cityLocationX+2][cityLocationY].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+2][cityLocationY].markers[1].radius = 10
						terrainLayoutResult[cityLocationX+2][cityLocationY].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker east of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_e"
						terrainLayoutResult[cityLocationX+2][cityLocationY].markers[2] = {}
						terrainLayoutResult[cityLocationX+2][cityLocationY].markers[2].name = markerName
						terrainLayoutResult[cityLocationX+2][cityLocationY].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+2][cityLocationY].markers[2].radius = 10
						terrainLayoutResult[cityLocationX+2][cityLocationY].markers[2].markerType = "Player Spawn"
					end
					
					--Check Southeast
					---------------------------------------------------------------------------------
					terrainLayoutResult[cityLocationX+1][cityLocationY-1].terrainType = u
					terrainLayoutResult[cityLocationX+2][cityLocationY-2].terrainType = u
					
					--check if square has a marker
					if(terrainLayoutResult[cityLocationX+1][cityLocationY-1].markers[1].name == nil) then
						print("no existing marker southeast of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_se"
						terrainLayoutResult[cityLocationX+1][cityLocationY-1].markers[1].name = markerName
						terrainLayoutResult[cityLocationX+1][cityLocationY-1].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+1][cityLocationY-1].markers[1].radius = 10
						terrainLayoutResult[cityLocationX+1][cityLocationY-1].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker southeast of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_se"
						terrainLayoutResult[cityLocationX+1][cityLocationY-1].markers[2] = {}
						terrainLayoutResult[cityLocationX+1][cityLocationY-1].markers[2].name = markerName
						terrainLayoutResult[cityLocationX+1][cityLocationY-1].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+1][cityLocationY-1].markers[2].radius = 10
						terrainLayoutResult[cityLocationX+1][cityLocationY-1].markers[2].markerType = "Player Spawn"
					end
					
					if(terrainLayoutResult[cityLocationX+2][cityLocationY-2].markers[1].name == nil) then
						print("no existing marker southeast of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_se"
						terrainLayoutResult[cityLocationX+2][cityLocationY-2].markers[1].name = markerName
						terrainLayoutResult[cityLocationX+2][cityLocationY-2].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+2][cityLocationY-2].markers[1].radius = 10
						terrainLayoutResult[cityLocationX+2][cityLocationY-2].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker southeast of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_se"
						terrainLayoutResult[cityLocationX+2][cityLocationY-2].markers[2] = {}
						terrainLayoutResult[cityLocationX+2][cityLocationY-2].markers[2].name = markerName
						terrainLayoutResult[cityLocationX+2][cityLocationY-2].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX+2][cityLocationY-2].markers[2].radius = 10
						terrainLayoutResult[cityLocationX+2][cityLocationY-2].markers[2].markerType = "Player Spawn"
					end
					
					--Check South
					---------------------------------------------------------------------------------
					terrainLayoutResult[cityLocationX][cityLocationY-1].terrainType = u
					terrainLayoutResult[cityLocationX][cityLocationY-2].terrainType = u
					
					--check if square has a marker
					if(terrainLayoutResult[cityLocationX][cityLocationY-1].markers[1].name == nil) then
						print("no existing marker south of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_s"
						terrainLayoutResult[cityLocationX][cityLocationY-1].markers[1].name = markerName
						terrainLayoutResult[cityLocationX][cityLocationY-1].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX][cityLocationY-1].markers[1].radius = 10
						terrainLayoutResult[cityLocationX][cityLocationY-1].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker south of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_s"
						terrainLayoutResult[cityLocationX][cityLocationY-1].markers[2] = {}
						terrainLayoutResult[cityLocationX][cityLocationY-1].markers[2].name = markerName
						terrainLayoutResult[cityLocationX][cityLocationY-1].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX][cityLocationY-1].markers[2].radius = 10
						terrainLayoutResult[cityLocationX][cityLocationY-1].markers[2].markerType = "Player Spawn"
					end
					
					if(terrainLayoutResult[cityLocationX][cityLocationY-2].markers[1].name == nil) then
						print("no existing marker south of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_s"
						terrainLayoutResult[cityLocationX][cityLocationY-2].markers[1].name = markerName
						terrainLayoutResult[cityLocationX][cityLocationY-2].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX][cityLocationY-2].markers[1].radius = 10
						terrainLayoutResult[cityLocationX][cityLocationY-2].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker south of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_s"
						terrainLayoutResult[cityLocationX][cityLocationY-2].markers[2] = {}
						terrainLayoutResult[cityLocationX][cityLocationY-2].markers[2].name = markerName
						terrainLayoutResult[cityLocationX][cityLocationY-2].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX][cityLocationY-2].markers[2].radius = 10
						terrainLayoutResult[cityLocationX][cityLocationY-2].markers[2].markerType = "Player Spawn"
					end
					
					--Check Southwest
					---------------------------------------------------------------------------------
					terrainLayoutResult[cityLocationX-1][cityLocationY-1].terrainType = u
					terrainLayoutResult[cityLocationX-2][cityLocationY-2].terrainType = u
					
					--check if square has a marker
					if(terrainLayoutResult[cityLocationX-1][cityLocationY-1].markers[1].name == nil) then
						print("no existing marker southwest of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_sw"
						terrainLayoutResult[cityLocationX-1][cityLocationY-1].markers[1].name = markerName
						terrainLayoutResult[cityLocationX-1][cityLocationY-1].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-1][cityLocationY-1].markers[1].radius = 10
						terrainLayoutResult[cityLocationX-1][cityLocationY-1].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker southwest of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_sw"
						terrainLayoutResult[cityLocationX-1][cityLocationY-1].markers[2] = {}
						terrainLayoutResult[cityLocationX-1][cityLocationY-1].markers[2].name = markerName
						terrainLayoutResult[cityLocationX-1][cityLocationY-1].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-1][cityLocationY-1].markers[2].radius = 10
						terrainLayoutResult[cityLocationX-1][cityLocationY-1].markers[2].markerType = "Player Spawn"
					end
					
					if(terrainLayoutResult[cityLocationX-2][cityLocationY-2].markers[1].name == nil) then
						print("no existing marker southwest of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_sw"
						terrainLayoutResult[cityLocationX-2][cityLocationY-2].markers[1].name = markerName
						terrainLayoutResult[cityLocationX-2][cityLocationY-2].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-2][cityLocationY-2].markers[1].radius = 10
						terrainLayoutResult[cityLocationX-2][cityLocationY-2].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker southwest of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_sw"
						terrainLayoutResult[cityLocationX-2][cityLocationY-2].markers[2] = {}
						terrainLayoutResult[cityLocationX-2][cityLocationY-2].markers[2].name = markerName
						terrainLayoutResult[cityLocationX-2][cityLocationY-2].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-2][cityLocationY-2].markers[2].radius = 10
						terrainLayoutResult[cityLocationX-2][cityLocationY-2].markers[2].markerType = "Player Spawn"
					end
					
					--Check West
					---------------------------------------------------------------------------------
					terrainLayoutResult[cityLocationX-1][cityLocationY].terrainType = u
					terrainLayoutResult[cityLocationX-2][cityLocationY].terrainType = u
					
					--check if square has a marker
					if(terrainLayoutResult[cityLocationX-1][cityLocationY].markers[1].name == nil) then
						print("no existing marker west of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_w"
						terrainLayoutResult[cityLocationX-1][cityLocationY].markers[1].name = markerName
						terrainLayoutResult[cityLocationX-1][cityLocationY].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-1][cityLocationY].markers[1].radius = 10
						terrainLayoutResult[cityLocationX-1][cityLocationY].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker west of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_w"
						terrainLayoutResult[cityLocationX-1][cityLocationY].markers[2] = {}
						terrainLayoutResult[cityLocationX-1][cityLocationY].markers[2].name = markerName
						terrainLayoutResult[cityLocationX-1][cityLocationY].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-1][cityLocationY].markers[2].radius = 10
						terrainLayoutResult[cityLocationX-1][cityLocationY].markers[2].markerType = "Player Spawn"
					end
					
					if(terrainLayoutResult[cityLocationX-2][cityLocationY].markers[1].name == nil) then
						print("no existing marker west of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_w"
						terrainLayoutResult[cityLocationX-2][cityLocationY].markers[1].name = markerName
						terrainLayoutResult[cityLocationX-2][cityLocationY].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-2][cityLocationY].markers[1].radius = 10
						terrainLayoutResult[cityLocationX-2][cityLocationY].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker west of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_w"
						terrainLayoutResult[cityLocationX-2][cityLocationY].markers[2] = {}
						terrainLayoutResult[cityLocationX-2][cityLocationY].markers[2].name = markerName
						terrainLayoutResult[cityLocationX-2][cityLocationY].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-2][cityLocationY].markers[2].radius = 10
						terrainLayoutResult[cityLocationX-2][cityLocationY].markers[2].markerType = "Player Spawn"
					end
					
					--Check Northwest
					---------------------------------------------------------------------------------
					terrainLayoutResult[cityLocationX-1][cityLocationY+1].terrainType = u
					terrainLayoutResult[cityLocationX-2][cityLocationY+2].terrainType = u
					
					--check if square has a marker
					if(terrainLayoutResult[cityLocationX-1][cityLocationY+1].markers[1].name == nil) then
						print("no existing marker northwest of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_nw"
						terrainLayoutResult[cityLocationX-1][cityLocationY+1].markers[1].name = markerName
						terrainLayoutResult[cityLocationX-1][cityLocationY+1].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-1][cityLocationY+1].markers[1].radius = 10
						terrainLayoutResult[cityLocationX-1][cityLocationY+1].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker northwest of the city")
						markerName = "mkr_city" .. cityNum .. "_defend_nw"
						terrainLayoutResult[cityLocationX-1][cityLocationY+1].markers[2] = {}
						terrainLayoutResult[cityLocationX-1][cityLocationY+1].markers[2].name = markerName
						terrainLayoutResult[cityLocationX-1][cityLocationY+1].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-1][cityLocationY+1].markers[2].radius = 10
						terrainLayoutResult[cityLocationX-1][cityLocationY+1].markers[2].markerType = "Player Spawn"
					end
					
					if(terrainLayoutResult[cityLocationX-2][cityLocationY+2].markers[1].name == nil) then
						print("no existing marker northwest of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_nw"
						terrainLayoutResult[cityLocationX-2][cityLocationY+2].markers[1].name = markerName
						terrainLayoutResult[cityLocationX-2][cityLocationY+2].markers[1].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-2][cityLocationY+2].markers[1].radius = 10
						terrainLayoutResult[cityLocationX-2][cityLocationY+2].markers[1].markerType = "Player Spawn"
					else
						print("there is an existing marker northwest of the city")
						markerName = "mkr_city" .. cityNum .. "_attack_nw"
						terrainLayoutResult[cityLocationX-2][cityLocationY+2].markers[2] = {}
						terrainLayoutResult[cityLocationX-2][cityLocationY+2].markers[2].name = markerName
						terrainLayoutResult[cityLocationX-2][cityLocationY+2].markers[2].faceTowardsCenter = false
						terrainLayoutResult[cityLocationX-2][cityLocationY+2].markers[2].radius = 10
						terrainLayoutResult[cityLocationX-2][cityLocationY+2].markers[2].markerType = "Player Spawn"
					end
	
			end
		end


	end
end

]]
