--Cardinal Map Generation Quick-Start Template


--Set up variables for each of the terrain types you plan to use in the course grid layout.

--more terrain types can be added as needed / created



--create the course grid. This is the table that holds the terrain types that will be used to generate the map in a 2D grid
--In order for the mapgen system to pick up your layout, you MUST have a table called terrainLayoutResult
--terrainLayoutResult is formatted for you using our SetUpGrid function. Each square can have a few parameters in dot notation:
--terrainLayoutResult[row][col].terrainType    <-- specifies the terrain at that grid square to generate
--terrainLayoutResult[row][col].playerIndex    <-- spawns the specified player index from the lobby on that square.
--We have several functions that act to sort out the player indices and their team assignments. The TeamMappingTable (created in the player starts section)
--holds all this info in an organized way.
terrainLayoutResult = {}    -- set up initial table for coarse map grid

--setting useful variables to reference world dimensions. This sets the map to our defualt resolution of 40m per grid square, which is reccommended.
--when generating our maps, each square on the grid is represented by a terrain type (hills, mountain, plains, etc) whose height is determined
--by a height/width calculation. When you change grid resolution, this calculation is affected. For example, with a higher resolution grid
--(for example 25m vs the standard 40m), all terrain features will be generated smaller, which in the case of things like mountains, can
--affect their ability to create impasse on the map. Use a custom resolution at your own discretion, but do not expect that all terrain
--will work as intended. Terrain types have been tuned at the default 40m resolution. 
gridHeight, gridWidth, gridSize = SetCoarseGrid()

--If you wish to set a custom resolution, use the following function. A higher resolution, keeping the caveats in mind, is often useful for making
--things like island maps, or maze-like maps where you need higher granularity in your terrain features.
--gridRes = 25
--gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(gridRes)

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map
--NOTE: AoE4 MapGen is designed to generate square maps. The grid you will be working with will always need to have gridWidth = gridHeight

--set the number of players. this info is grabbed from the lobby
playerStarts = worldPlayerCount

--uncomment the following section if you want to use the grid to layout a specific map style

n = { terrainType = tt_none  }
p = { terrainType = tt_plains  }
g = { terrainType = tt_hills_gentle_rolling }

h = { terrainType = tt_hills_med_rolling}

m = { terrainType = tt_mountains }

o = { terrainType = tt_ocean }
ob = { terrainType = tt_beach }

-- resource-related cells
b = { terrainType = tt_player_start_classic_plains }
d = { terrainType = tt_deer_spawner }
f = { terrainType = tt_pocket_wood_food }
i = { terrainType = tt_pocket_gold_a } 
ho = { terrainType = tt_holy_site }
s = { terrainType = tt_tactical_region_stone_plains_c }
ts = { terrainType = tt_settlement_hills }



s0 = { terrainType = tt_plains, playerIndex = 0 }
s1 = { terrainType = tt_plains, playerIndex = 1 }
s2 = { terrainType = tt_plains, playerIndex = 2 }
s3 = { terrainType = tt_plains, playerIndex = 3 }

--forests
--use these to spawn dense tree areas
j = { terrainType = tt_impasse_trees_plains }
jj = { terrainType = tt_trees_plains }
jc = { terrainType = tt_pocket_wood }
js = { terrainType = tt_trees_plains_stealth }
k = { terrainType = tt_impasse_trees_hills_low_rolling }



--define river-related data
--each of these defines a separate river to use on the grid layout
--feel free to add more if necessary
r1 = { terrainType = tt_river }


--these tables hold necessary information about water features for mapgen
riverResult = {}
fordResults = {}
woodBridgeResults = {}
stoneBridgeResults = {}


--fill in this grid with defined terrain types to get the layout looking how you want
--this default grid is filled with plains

--NOTE:
--use only one of these grids. Feel free to delete the ones you are not using
--if more than one "terrainLayoutResult" exists, only the final one will be used for map generation

--512 map grid
terrainLayoutResult =
{ {n, n, g, g,r1, m, m, j, n, n, m, ho, ts}
, {n,s1, n, p,r1, p, g, g, n, n, n, s3, g}
, {j, n, n, p,r1, g, j, j, n, n, n, g, h}
, {p, p, s, g,r1, g, d, j, g, p, p, p, g}
, {jj, p, i, n,r1, h, js, h, g, p, p, o, o}
, {h, g, p, n,r1, n, g, j, js, p, o, o, o}
, {js, p, p, g,r1, g, n, js, js, g, o, o, o}
, {j, g, h, n,r1, f, g, n, p, g, o, o, o}
, {m, j, g, n,r1, n, h, n, s, p, o, o, o}
, {h, p, n, j,r1, g, n, n, n, b, p, ob, m}
, {g, n, b, n,r1, g, f, n, p, p, n, n, g} 
, {p,s2, n, d,r1, p, p, js, j, b, n,s0, n}
, {p, n, n, s,r1, m, n, n, j, p, n, n, n}
}

ChartRiver(r1, {1,5}, terrainLayoutResult)

--riverIndex specifies the symbol you are using for the river on the grid. r1, r2, etc.

--startingCoordinateTable is a grid coordinate pair that states the starting point in {row, column}
--eg {1, 6} would be at the top of the grid, around the middle of a tiny map.

--terrainLayoutResult is your terrain table. Don't change it's name, that is the specific table
--the map generator looks at for map data.


table.insert(stoneBridgeResults, { riverResult[1][10], riverResult[1][3]  })