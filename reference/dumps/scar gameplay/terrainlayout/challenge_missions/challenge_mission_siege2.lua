-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--Cardinal Map Generation Quick-Start Template


--Set up variables for each of the terrain types you plan to use in the course grid layout.

--more terrain types can be added as needed / created



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
--NOTE: AoE4 MapGen is designed to generate square maps. The grid you will be working with will always need to have gridWidth = gridHeight

--set the number of players
playerStarts = worldPlayerCount


--[[

--IF YOU ARE CREATING A TOTALLY PROCEDURAL MAP LAYOUT------------------------------------------

--the "none" type will be randomly filled by your AE data template
n = tt_none

--these are terrain types that define specific geographic features
h = tt_hills
s = tt_mountains_small
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_low_rolling
mr = tt_hills_med_rolling
hr = tt_hills_high_rolling
low = tt_plateau_low
med = tt_plateau_med
high = tt_plateau_high
p = tt_plains
t = tt_impasse_trees_plains
v = tt_valley

--bounty squares are used to populate an area of the map with extra resources
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains

--the following are markers used to determine player and settlement spawn points
s = tt_player_start_hills
sp = tt_settlement_plains
sh = tt_settlement_hills
seb = tt_settlement_hills_high_rolling

-- setting up the map grid

--this sets up your terrainLayoutResult table correctly to be able to loop through and set new terrain squares
terrainLayoutResult = SetUpGrid(gridSize, p, terrainLayoutResult)

baseGridSize = 13
outerRadius = 3.5 / baseGridSize * gridSize
middleRadius = 2.5 / baseGridSize * gridSize
innerRadius = 1.25 / baseGridSize * gridSize
mapMidPoint = math.ceil(gridSize / 2)

--set a few more useful values to use in creating specific types of map features
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--do map specific stuff around here

--Here's a basic loop that will iterate through all squares in your map
for row = 1, gridSize do
	for col = 1, gridSize do
	
	--do stuff with the grid here
	
	end
end

-- SETUP PLAYER STARTS
--potentialStartLocations = {}
heightOffset = Round(2 / baseGridSize * gridHeight, 0)
widthOffset = Round(2 / baseGridSize * gridWidth, 0)

--Start Position Stuff---------------------------------------------------------------------------------

masterStartPositionsTable = MakeStartPositionsTable(gridWidth, gridHeight, gridSize)
openStartPositions = DeepCopy(masterStartPositionsTable)

teamsList, playersPerTeam = SetUpTeams()

for l = 1, #masterStartPositionsTable do
	print("Start Position " ..l .." is at row: " ..masterStartPositionsTable[l].startRow ..", Col: " ..masterStartPositionsTable[l].startCol)
end


for index = 1, #openStartPositions do
	print("OSP ID " ..index .." is " ..openStartPositions[index].startID .." Number of connections is: " ..#openStartPositions[index].connections)	 
end

startLocationPositions = {} -- the row and column for each player location

--set how much terrain is freed up around the start position based on map size
if (worldTerrainHeight > 513) then
	startRadius = 1
else
	startRadius = 2
end

print("RANDOM POSITIONS IS " ..tostring(randomPositions))
-- find a start location for each player

if (worldPlayerCount <=4) then -- reduce start positions options to 4 to keep players far enough apart
	
		if (worldGetRandom() < 0.49 and worldTerrainHeight > 513) then -- remove start positions on edges
				
			for index = 4, 1, -1 do
				table.remove(openStartPositions, index)
			end
				
		else -- remove start positions on corners				
				
			for index = 8, 5, -1 do
				table.remove(openStartPositions, index)
			end
				
		end	
	

end

if (randomPositions == true) then -- place players without regard to grouping teams together		
	
	-- select start positions
	startLocationPositions = GetStartPositionsTeamsApart(openStartPositions)

else -- place players from the same team grouped together

	print("grouping teams together")
	startLocationPositions = GetStartPositionsTeamsTogether(openStartPositions, masterStartPositionsTable)
end


-- place the start positions on the coarse grid
for index = 1, #startLocationPositions do
	x = startLocationPositions[index].startRow
	y = startLocationPositions[index].startCol
	playerID = (startLocationPositions[index].playerID)

	--make sure start position isn't on a river
	if(terrainLayoutResult[x][y].terrainType == tt_river) then
		x, y = GetSquareInRingAroundSquare(x, y, 2, 2, {tt_river}, terrainLayoutResult)
	
		startLocationPositions[index].startRow = x
		startLocationPositions[index].startCol = y
	end

	print("Player " ..index .." is at row " ..x ..", col "..y)
	terrainLayoutResult[x][y].terrainType = playerStartTerrain
	terrainLayoutResult[x][y].playerIndex = playerID
	print("Setting PlayerID in terrain layout to " .. playerID)
end

--]]

--IF YOU ARE CREATING A CUSTOM LAYOUT----------------------------------------------------------

--uncomment the following section if you want to use the grid to layout a specific map style

p = { terrainType = tt_plains  }
g = { terrainType = tt_hills_gentle_rolling }
d = { terrainType = tt_hills_low_rolling }
h = { terrainType = tt_hills_med_rolling}
b = { terrainType = tt_hills_high_rolling }
m = { terrainType = tt_mountains }
i = { terrainType = tt_impasse_mountains }
u = { terrainType = tt_valley_shallow }
v = { terrainType = tt_valley }

--cliff terrain types
p0 = { terrainType = tt_plains_cliff }
p1 = { terrainType = tt_plateau_low }
p2 = { terrainType = tt_plateau_med }
p3 = { terrainType = tt_plateau_high }

s = { terrainType = tt_hills_plateau, playerIndex = 0 }
e = { terrainType = tt_hills_high_rolling, playerIndex = 1 }

--forests - use these to spawn dense tree areas
j = { terrainType = tt_impasse_trees_plains }
k = { terrainType = tt_impasse_trees_hills_low_rolling }
l = { terrainType = tt_impasse_trees_hills_high_rolling }

--define river-related data - each defines a separate river in the grid layout
r1 = { terrainType = tt_river }
r2 = { terrainType = tt_river }


--these tables hold necessary information about water features for mapgen
riverResult = {}
fordResults = {}
woodBridgeResults = {}
stoneBridgeResults = {}

--TINY map grid --fill in this grid with defined terrain types to get the layout looking how you want
terrainLayoutResult =
{ { p,  p,  p,  p,  p,  i,  p,  p,  p,  p,  p,  p,  i}
, { p,  i,  i,  i,  i,  i,  g,  g,  g,  i,  i,  i,  p}
, { i,  m,  g,  g,  g,  p,  p,  p,  p,  g,  g,  i,  p}
, { i,  h,  g,  p,  g,  p,  g,  g,  g,  p,  d,  i,  i}
, { p,  d,  g,  p,  g,  g,  p,  p,  p,  p,  p,  p,  p}
, { i,  d,  g,  g,  g,  g,  g,  g,  g,  g, p1, p1, p1}
, { d,  i,  i,  g, p1, p1,  p, p1, p1, p1,  p,  p,  p}
, { p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p, r1, r1}
, { p,  p, r1, r1, r1,  p,  p,  p,  p, r1, r1,  p,  p}
, {r1, r1, r1,  p,  p, r1, r1, r1, r1,  p,  p,  p,  p}
, { p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  p,  g,  p}
, { p,  p,  p,  p,  p,  p,  p,  p,  p,  g,  g,  m,  p}
, { g,  g,  g,  g,  p,  p,  p,  p,  g,  g,  g,  p,  p}	
}

ChartRiver(r1, {8, 13}, terrainLayoutResult)

--table.insert(fordResults, { riverResult[1][4], riverResult[1][9]  })

table.insert(woodBridgeResults, { riverResult[1][8] })

---------------------------------------------------------------------------------------------------------------------------------------------------------------

--RIVER NOTES

--uncomment the following section (along with the regular custom layout section) to generate a simple map with a few rivers


--If you are placing rivers on your map via the grid, you must call a function that saves the river
--information and direction for each distinct river you are creating.

--Without calling this function, the map generator will not know where the river should go.

--The function is as follows:
--ChartRiver(riverIndex, startingCoordinateTable, terrainLayoutResult)

	--riverIndex specifies the symbol you are using for the river on the grid. r1, r2, etc.

	--startingCoordinateTable is a grid coordinate pair that states the starting point in {row, column}
	--eg {1, 6} would be at the top of the grid, around the middle of a tiny map.
	
	--terrainLayoutResult is your terrain table. Don't change it's name, that is the specific table
	--the map generator looks at for map data.


--[[
terrainLayoutResult = {}

terrainLayoutResult =
{ {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, p, p, p, p, p, p}
, {p, p, p, p, r1, p, p, b, b, b, p, p, p}
, {p, p, p, p, r1, p, b, b, m, m, m, p, p}
, {p, p, p, p, p, r1,r1,r1, p, m, p, p, p}
, {p, p, p, p, r2,p, b, m, r1, m, m, p, p}
, {r3,p, p, p, r2,b, m, m, r1, m, m, p, p}
, {p, r3,p, p, r2,b, m, m, r1, m, m, p, p}
, {p, p,r3, p, r2,b, m, m, r1, m, p, p, p}
, {p, p,r3, p, p, r2,r2,r2,r1, p, p, p, p}
, {p, r3,p, p, p, p, p, p, p, r1, p, p, p}
, {r3, p,p, p, p, p, p, p, p, r1, p, p, p}	
}

ChartRiver(r1, {1, 5}, terrainLayoutResult)
ChartRiver(r2, {6, 6}, terrainLayoutResult)
ChartRiver(r3, {8, 1}, terrainLayoutResult)
]]--
--the following add river crossing points. 
--use fordResults, woodBridgeResults or stoneBridgeResults to add the corresponding crossing type
--the crossing will spawn on the river square denoted by the pair of numbers after riverResult
--the first index is the river number (first river, second river, etc)
--the second index is the nth square along the river (so [1][5] would be the 5th square along the first river)

--if adding multiple crossings on a single river of the same type, make sure they are all added in a single table, like the following fordResults example

--table.insert(fordResults, { riverResult[1][4], riverResult[1][7]  })
--table.insert(woodBridgeResults, { riverResult[2][3] })
--table.insert(stoneBridgeResults, { riverResult[3][3]  })




