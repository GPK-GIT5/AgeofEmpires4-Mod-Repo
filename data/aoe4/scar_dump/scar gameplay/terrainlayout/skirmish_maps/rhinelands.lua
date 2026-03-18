-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--RHINELANDS map layout script

print("Generating RHINELANDS map")

-- variables containing terrain types to be used in map
n = tt_none   -- terrain type "none" will use terrain types randomly chosen based on weights in map_gen_layout
r = tt_flatland -- flatland will not be used in the map. This is just to set a square to "random"

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
sh = tt_pocket_sheep_a
v = tt_valley

x = tt_pocket_berries

f = tt_trees_plains
c = tt_trees_plains_clearing
bf = tt_trees_hills_high_rolling_clearing


playerStartTerrain = tt_player_start_classic_plains -- classic mode start

--[[
nomadStart = false
if (winConditionOptions.section_starting_conditions and winConditionOptions.section_starting_conditions.option_age_start) then
	nomadStart = (winConditionOptions.section_starting_conditions.option_age_start.enum_value == winConditionOptions.section_starting_conditions.option_age_start.enum_items.nomad_start)
	print("NOMAD START CONDITION IS: " ..winConditionOptions.section_starting_conditions.option_age_start.enum_value.." ("..tostring(nomadStart)..")")
else
	print("NOMAD START CONDITION IS NOT SET (FALSE)")
end

if(nomadStart) then
	playerStartTerrain = tt_player_start_nomad_plains -- nomad mode start
else
	playerStartTerrain = tt_player_start_classic_plains -- classic mode start	
end

--set up resource pockets
nomadPocketResources1 = {}
nomadPocketResources2 = {}
nomadPocketResources3 = {}

--create groups of pocket resources that will equal out to balanced resources
--players will randomly get one set of these
nomadPocketResourceList = {}
table.insert(nomadPocketResourceList, nomadPocketResources1)
table.insert(nomadPocketResourceList, nomadPocketResources2)
table.insert(nomadPocketResourceList, nomadPocketResources3)

psa = tt_pocket_stone_a
psb = tt_pocket_stone_b
psc = tt_pocket_stone_c
pga = tt_pocket_gold_a
pgb = tt_pocket_gold_b
pgc = tt_pocket_gold_c
pwa = tt_pocket_wood_a
pwb = tt_pocket_wood_b
pwc = tt_pocket_wood_c

table.insert(nomadPocketResources1, psa)
table.insert(nomadPocketResources1, pgb)
table.insert(nomadPocketResources1, pwc)
table.insert(nomadPocketResources2, psb)
table.insert(nomadPocketResources2, pgc)
table.insert(nomadPocketResources2, pwa)
table.insert(nomadPocketResources3, psc)
table.insert(nomadPocketResources3, pga)
table.insert(nomadPocketResources3, pwb)
]]

--------------------------
--MAP SIZE SPECIFIC VALUES
--------------------------
if(worldTerrainWidth <= 416) then --for micro maps
	minRivers = 3
	maxRivers = 4
	maxMainRivers = 2
	numTributaries = 0
elseif(worldTerrainWidth <= 512) then --for tiny maps
	minRivers = 3
	maxRivers = 5
	maxMainRivers = 2
	numTributaries = 0
elseif(worldTerrainWidth <= 640) then  --for small maps
	minRivers = 3
	maxRivers = 5
	maxMainRivers = 2
	numTributaries = 0
elseif(worldTerrainWidth <= 768) then  --for medium maps
	minRivers = 4
	maxRivers = 6
	maxMainRivers = 2
	numTributaries = 0
elseif(worldTerrainWidth <= 896) then  --for large maps
	minRivers = 4
	maxRivers = 7
	maxMainRivers = 3
	numTributaries = 0
else --for 1024+ maps
	minRivers = 4
	maxRivers = 7
	maxMainRivers = 3
	numTributaries = 0
end


-- FUNCTIONS

local function Normalize(value, min, max)
	
	return ((value * (max - min)) + min)
end

--this function returns a table of all squares within a given radius of an origin point provided
local function GetSquaresInRadius(centerRow, centerColumn, mapHeight, mapWidth, radius)
	
	local squares = {}
	for row = 1, mapHeight do
		
		for col = 1, mapWidth do
			local euclidianDistance = math.sqrt((row - centerRow)^2 + (col - centerColumn)^2)
			if(euclidianDistance < radius) then
				table.insert(squares, {row, col})
			end
		end
		
	end
	
	return squares
end

--reverseRiver function takes a table of river coordinates and reverses the direction
local function reverseRiver(riverTable)
	
	reversedRiver = {}
	
	for index = #riverTable, 1, -1 do
		currentCoord = riverTable[index]
		table.insert(reversedRiver, currentCoord)
	end
	
	return reversedRiver
end


-- COARSE GRID SET UP
terrainLayoutResult = {}    -- set up initial table for coarse map grid

gridHeight, gridWidth, gridSize = SetCoarseGrid()

--these values are values received specifically to let the script know information about map dimensions
--the number of players is grabbed from the map setup menu screen and includes both human and AI players
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

-- PLACE TERRAIN FEATURES
baseGridSize = 13
outerRadius = 3.5 / baseGridSize * gridSize
middleRadius = 2.5 / baseGridSize * gridSize
innerRadius = 1.25 / baseGridSize * gridSize
mapMidPoint = math.ceil(gridSize / 2)


--DO RIVER STUFF-------------------------------------------------------------------------------
	
riverResult = {}
fordResults = {}
woodBridgeResults = {}
stoneBridgeResults = {}

riverSegments = {}

--set number of rivers in map
numRivers = math.ceil(worldGetRandom() * maxRivers)
print("number of rivers chosen is " .. numRivers)

if(numRivers < minRivers) then
	numRivers = minRivers	
end

--if more than 1 river, split up numRivers into rivers and tributaries
if(numRivers > 1) then
	numTributaries = math.ceil(worldGetRandom() * (numRivers - 1))
	numRivers = numRivers - numTributaries
	
	--cap the number of main rivers and rebalance to make tributaries
	if(numRivers > maxMainRivers) then
	
		remainder = numRivers - maxMainRivers
		numRivers = maxMainRivers
		numTributaries = numTributaries + remainder
	end
	
	print("there are " .. numRivers .. " rivers and " .. numTributaries .. " tributaries on this map.")

end

--split the map up into regions to have the rivers be able to live in without overlapping
mapSplit = math.ceil(gridSize / numRivers)

--make rivers
pathVariation = GetRandomInRange(0.2, 0.35)
directionRandomness = GetRandomInRange(0.4, 0.6)
print("generating rivers with pathVariation of " .. pathVariation .. " and directionRandomness of " .. directionRandomness)
riverResult, fordResults, woodBridgeResults, stoneBridgeResults = CreateRivers(numRivers, numTributaries, pathVariation, directionRandomness, false, terrainLayoutResult)


--resource stuff
--Yucatan was a resource-dense map, so too will be Rhinelands

--distribute lots of berries and other food
foodChance = 0.2
maxFoodCount = gridSize + 10

--loop for how many times to place a food square
for foodIndex = 1, maxFoodCount do
	
	--get a list of all available squares to potentially place a food square
	openSpaces = {}
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if(terrainLayoutResult[row][col].terrainType == tt_none or terrainLayoutResult[row][col].terrainType == tt_plains) then
				table.insert(openSpaces, {row, col})
			end
		end
	end
	
	--now pick a random spot out of the list of open spaces
	chosenFoodIndex = math.ceil(worldGetRandom() * #openSpaces)
	chosenRow = openSpaces[chosenFoodIndex][1]
	chosenCol = openSpaces[chosenFoodIndex][2]
	print("placing food at " .. chosenRow .. ", " .. chosenCol)
	--pick between several food options
	foodRoll = worldGetRandom()
	
	if(foodRoll < 0.1) then
		print("placing a wolf spawner")
		terrainLayoutResult[chosenRow][chosenCol].terrainType = tt_wolf_spawner
	elseif(foodRoll < 0.2) then
		print("placing a deer spawner")
		terrainLayoutResult[chosenRow][chosenCol].terrainType = tt_deer_spawner
	elseif(foodRoll < 0.5) then
		print("placing a gold and berry spawner")
		terrainLayoutResult[chosenRow][chosenCol].terrainType = tt_berries_gold_small
	elseif(foodRoll < 0.8) then
		print("placing a stone and berry spawner")
		terrainLayoutResult[chosenRow][chosenCol].terrainType = tt_berries_stone_small
	else
		print("placing berries")
		terrainLayoutResult[chosenRow][chosenCol].terrainType = tt_pocket_berries
	end
end

--Start Position Stuff---------------------------------------------------------------------------------
teamMappingTable = CreateTeamMappingTable()
minTeamDistance = Round((#terrainLayoutResult / 3))
minPlayerDistance = 6.5
edgeBuffer = 1
impasseTypes = {tt_river, tt_mountains}
openTypes = {tt_plains, tt_hills_low_rolling, tt_hills_med_rolling, tt_hills_high_rolling, tt_none, tt_flatland}

--terrainLayoutResult = PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, impasseTypes, openTypes, playerStartTerrain, terrainLayoutResult)
--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .35, impasseTypes, 1, 0.05, playerStartTerrain, tt_plains_smooth, terrainLayoutResult)
terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, .3, impasseTypes, 1, 0.05, playerStartTerrain, tt_plains, 1, false, terrainLayoutResult)

startLocationPositions = {}

--loop through and record player starts
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
		
		currentData = {}
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			currentData = {row, col}
			table.insert(startLocationPositions, currentData)
		end
		
	end
end


print("end of RHINELANDS script")
--END OF SCRIPT

