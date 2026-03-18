--the "none" type will be randomly filled by your AE data template
n = tt_none

--these are terrain types that define specific geographic features
p = tt_plains
h = tt_hills_gentle_rolling






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

--set the number of players
playerStarts = worldPlayerCount



terrainLayoutResult = { 
	{h, h, h, h, h, h, h, h, h, h, h, h, h},
	{p, h, h, h, h, h, h, h, h, h, h, h, h},
	{p, p, h, h, h, h, h, h, h, h, h, h, h},
	{p, p, p, h, h, h, h, h, h, h, h, h, h},
	{p, p, p, p, p, h, h, h, h, h, h, h, h},
	{p, p, p, p, p, p, h, h, h, h, h, h, h},
	{p, p, p, p, p, p, p, h, h, h, h, h, h},
	{p, p, p, p, p, p, p, p, h, h, h, h, h},
	{p, p, p, p, p, p, p, p, p, h, h, h, h},
	{p, p, p, p, p, p, p, p, p, p, h, h, h},
	{p, p, p, p, p, p, p, p, p, p, h, h, h},
	{p, p, p, p, p, p, p, p, p, p, p, h, h},
	{p, p, p, p, p, p, p, p, p, p, p, p, h},
}





