-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--ANCIENT SPIRES MAP

print("GENERATING ANCIENT SPIRES")


--the following is the list of terrain types (from the Attribute Editor) we use to populate the map grid.
--each terrain type contains associated height information, as well as settings for things like cliff formation and lake generation

--the 'none' terrain type is used to auto-fill with other terrain types randomly, as set in the Map Layout attribute editor data for this map
n = tt_none

h = tt_hills_low_rolling
m = tt_mountains
i = tt_rock_pillar
b = tt_hills_med_rolling
p = tt_plains_cliff
fl = tt_flatland
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains
pl = tt_plateau_low
p2 = tt_plateau_med
p3 = tt_plateau_high

f = tt_impasse_trees_plains
v = tt_lake_shallow
r = tt_river


s = tt_player_start_classic_plains

--this code block checks for if the players have selected the "Nomad" start conditions.
--This affects map generation due to needing additional viable resource starting points without a town centre to cluster things around.
--The following code checks data from the game setup menu and passes that information into this script for later use.
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

--players will randomly get one set of these in nomad mode
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


terrainLayoutResult = {}    -- set up initial table for coarse map grid

--this function sets how coarse the grid resolution for the map is.
--Ancient Spires requires a custom, higher-resolution grid in order to create the rock spires found on the map.
--This function sets the meters-per-grid ratio to 15m instead of the usual 40m. 
--when creating your own maps, use the library function that uses the standard size, found in scar/terrainlayout/library/map_setup
local function SetCoarseGrid()
	
	local metersPerSquare = 15

	local mapHeight
	local mapWidth
	local mapSize
	
	mapHeight = Round(worldTerrainHeight / metersPerSquare, 0) -- set resolution of coarse map rows
	mapWidth = Round(worldTerrainWidth / metersPerSquare, 0) -- set resolution of coarse map columns
	
	if (mapHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
		mapHeight = mapHeight - 1
	end

	if (mapWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
		mapWidth = mapWidth - 1
	end
	
	mapSize = mapWidth -- set resolution of coarse map
	
	return mapHeight, mapWidth, mapSize

end

-- MAP/GAME SET UP ------------------------------------------------------------------------
--SetCoarseGrid is a function that sets up your 2D grid to accept terrain types in the correct format.
--Found in the Engine folder under scar/terrainlayout/library/setsquaresfunctions

if(worldTerrainHeight < 417) then
	metersPerSquare = 12
elseif(worldTerrainHeight < 513) then
	metersPerSquare = 15
elseif(worldTerrainHeight < 641) then
	metersPerSquare = 15
elseif(worldTerrainHeight < 769) then
	metersPerSquare = 15
elseif(worldTerrainHeight < 897) then
	metersPerSquare = 18
else
	metersPerSquare = 18
end

gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(metersPerSquare)


--these values are values received specifically to let the script know information about map dimensions
--the number of players is grabbed from the map setup menu screen and includes both human and AI players
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

--setting a few values for the map grid that can be useful for determining common fractions of the map grid
baseGridSize = 25
mapHalfSize = Round(gridSize/2)
mapQuarterSize = Round(gridSize/4)

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

--this sets up a standard layout for player starts that is in a rough ring around the outside of the map
--within each rough position around the ring is some room for random variance, resulting in players being slightly
--closer or further from the edge of the map
--function found in scar/terrainlayout/library/player_starts
masterStartPositionsTable = MakeStartPositionsTable(gridWidth, gridHeight, gridSize)

--DeepCopy makes a copy of a table that will not be altered when you work with the original table
--function found in scar/terrainlayout/library/calculationfunctions
openStartPositions = DeepCopy(masterStartPositionsTable)

for index = 1, #openStartPositions do
	print("OSP ID " ..index .." is " ..openStartPositions[index].startID .." Number of connections is: " ..#openStartPositions[index].connections)	 
end

-- PLACE PLAYER START POSITIONS -----------------------------------------------------
startLocationPositions = {} -- the row and column for each player location

print("RANDOM POSITIONS IS " ..tostring(randomPositions))

--ANCIENT SPIRES TERRAIN FEATURES
-----------------------------------------------------------------------------------------

--spawn the 2 side holy sites
gridIndex = math.ceil(worldGetRandom() * gridSize / 2)

holyIndex1 = gridIndex
if(holyIndex1 <= 4) then
	holyIndex1 = 4	
end

print("holy index 1 is" .. holyIndex1)
holyIndex2 = math.ceil(gridIndex + (gridSize / 2))
if(holyIndex2 > gridSize) then
	holyIndex2 = gridSize
end
if(holyIndex2 > gridSize - 4) then
	holyIndex2 = gridSize - 4
end
print("holy index 2 is" .. holyIndex2)
--put a large valley in the centre
valleyNeighbors = {}
valleyNeighbors = Get20Neighbors(mapHalfSize, holyIndex1, terrainLayoutResult)

for neighborIndex, valleyNeighbor in ipairs(valleyNeighbors) do	
	currentNeighborRow = valleyNeighbor.x
	currentNeighborCol = valleyNeighbor.y
	
	terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_hills_lowlands
end

terrainLayoutResult[mapHalfSize][holyIndex1].terrainType = tt_holy_site


valleyNeighbors = {}
valleyNeighbors = Get20Neighbors(mapHalfSize, holyIndex2, terrainLayoutResult)

for neighborIndex, valleyNeighbor in ipairs(valleyNeighbors) do	
	currentNeighborRow = valleyNeighbor.x
	currentNeighborCol = valleyNeighbor.y
	
	terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_hills_lowlands
end

terrainLayoutResult[mapHalfSize][holyIndex2].terrainType = tt_holy_site


--chance to spawn a spire on the grid
spireChance = 0.056

--loop through the map and distribute spires
for row = 1, gridSize do
	for col = 1, gridSize do
		
		--get chance to place spires
		if(worldGetRandom() < spireChance) then
			--make sure we aren't replacing a lake
			if(terrainLayoutResult[row][col].terrainType == tt_none or terrainLayoutResult[row][col].terrainType == tt_lake_shallow) then
				terrainLayoutResult[row][col].terrainType = i
			end
		end
	end
end

--do a sweep and eliminate adjacent spires to eliminate monster rock spires from the map
--adjacent spires will glue together and be too large
for row = 1, gridSize do
	for col = 1, gridSize do
		
		adjSpires = {}
		--do a check to ensure adjacency checks are in bounds
		if(IsInMap (row, col, gridSize, gridSize)) then
			--check to see if the current square is a spire
			if(terrainLayoutResult[row][col].terrainType == i) then
				adjSpires = GetAllSquaresOfTypeInRingAroundSquare(row, col, 2, 2, {i}, terrainLayoutResult)
					
				--check to see if it found any adjacent spires
				if(#adjSpires >= 1) then
						
					print("found " .. #adjSpires .. " rock spires adjacent to " .. row .. ", " .. col)
					for index, foundSpire in ipairs(adjSpires) do
						terrainLayoutResult[foundSpire[1]][foundSpire[2]].terrainType = tt_none	
						print("set adjacent spire to none")
					end
				end
			end
		end
	end
end


teamMappingTable = CreateTeamMappingTable()
	
minPlayerDistance = 24
minTeamDistance = 36
edgeBuffer = 4

playerStartTerrain = tt_player_start_classic_hills_gentle_no_tertiary_wood

spawnBlockers = {}
table.insert(spawnBlockers, tt_rock_pillar)
table.insert(spawnBlockers, tt_lake_shallow)

basicTerrain = {}
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_plains_clearing)
table.insert(basicTerrain, tt_flatland)
table.insert(basicTerrain, tt_plateau_low)
table.insert(basicTerrain, tt_none)


if(worldTerrainWidth <= 417) then
	minTeamDistance = Round((#terrainLayoutResult * 0.9))
	minPlayerDistance = Round((#terrainLayoutResult * 0.4))
	edgeBuffer = 4
	innerExclusion = 0.4
	topSelectionThreshold = 0.1
	impasseTypes = {tt_mountains_small}
	impasseDistance = 3
	cornerThreshold = 4
elseif(worldTerrainWidth <= 513) then
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.3))
	edgeBuffer = 4
	innerExclusion = 0.4
	topSelectionThreshold = 0.033
	impasseTypes = {tt_mountains_small}
	impasseDistance = 3
	cornerThreshold = 3
elseif(worldTerrainWidth <= 641) then
	minTeamDistance = Round((#terrainLayoutResult * 1.2))
	minPlayerDistance = Round((#terrainLayoutResult * 0.3))
	edgeBuffer = 6
	innerExclusion = 0.375
	topSelectionThreshold = 0.05
	impasseTypes = {tt_mountains_small}
	impasseDistance = 3
	cornerThreshold = 3
elseif(worldTerrainWidth <= 769) then
	minTeamDistance = Round((#terrainLayoutResult * 0.9))
	minPlayerDistance = Round((#terrainLayoutResult * 0.3))
	edgeBuffer = 8
	innerExclusion = 0.375
	topSelectionThreshold = 0.05
	impasseTypes = {tt_mountains_small}
	impasseDistance = 3
	cornerThreshold = 3
else
	minTeamDistance = Round((#terrainLayoutResult * 0.9))
	minPlayerDistance = Round((#terrainLayoutResult * 0.4))
	edgeBuffer = 10
	innerExclusion = 0.4
	topSelectionThreshold = 0.01
	impasseTypes = {tt_mountains_small}
	impasseDistance = 3.5
	cornerThreshold = 2
end

--[[
if(worldPlayerCount <= 2) then
	minTeamDistance = Round((#terrainLayoutResult * 0.75))
	minPlayerDistance = Round((#terrainLayoutResult * 0.4))
elseif(worldPlayerCount <= 4) then
	minTeamDistance = Round((#terrainLayoutResult * 0.85))
	minPlayerDistance = Round((#terrainLayoutResult * 0.4))
elseif(worldPlayerCount <= 6) then	
	minTeamDistance = Round((#terrainLayoutResult * 0.9))
	minPlayerDistance = Round((#terrainLayoutResult * 0.325))
else
	minTeamDistance = Round((#terrainLayoutResult * 0.95))
	minPlayerDistance = Round((#terrainLayoutResult * 0.275))
end
]]--

teamMappingTable = CreateTeamMappingTable()


impasseTypes = {tt_lake_shallow, tt_holy_site}
openTypes = {tt_plains, tt_hills_low_rolling, tt_hills_med_rolling, tt_hills_high_rolling, tt_none, tt_flatland}
--terrainLayoutResult = PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, impasseTypes, openTypes, playerStartTerrain, terrainLayoutResult)


startBufferTerrain = tt_hills_gentle_rolling
startBufferRadius = 2

if(worldTerrainWidth <= 416) then --for micro maps
	innerExclusion = 0.38
elseif(worldTerrainWidth <= 512) then --for tiny maps
	innerExclusion = 0.4
elseif(worldTerrainWidth <= 640) then  --for small maps
--	innerExclusion = 0.42
elseif(worldTerrainWidth <= 768) then  --for medium maps
--	innerExclusion = 0.44
elseif(worldTerrainWidth <= 896) then  --for large maps
--	innerExclusion = 0.5
end

if(randomPositions == true) then
	minPlayerDistance = minTeamDistance
end

centralLake = false
if(#teamMappingTable == 2 and randomPositions == false) then
	terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, false, impasseTypes, impasseDistance, 0.01, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)
--	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)

	centralLake = false
	baseLakeNum = 2
else

	
	if(worldPlayerCount > 0) then
		--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, terrainLayoutResult)
		--terrainLayoutResult = PlacePlayerStarts(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, spawnBlockers, basicTerrain, playerStartTerrain, terrainLayoutResult)
		terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)
	--	centralLake = true
		baseLakeNum = 1
	end
end



--terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, impasseTypes, impasseDistance, topSelectionThreshold, playerStartTerrain, startBufferTerrain, startBufferRadius, true, terrainLayoutResult)


--place a large amount of lakes

--setting some baseline variables used to determine how many lakes to generate.
--these values will be used unless overridden based on size.
minLakeNum = 1
maxLakeNum = 1

playerStartSpace = 5

--set a few constraints on the randomly generated lakes
minLakeSize = 8
maxLakeSize = 9

landCoverage = 0.135
playerCountModMax = 0.08

--set some variables for number of generated lakes based on the map size
lakeAreaRadius = 2
if(worldTerrainHeight >= 511) then
	lakeAreaRadius = 3
	minLakeNum = 1
	maxLakeNum = 1
	minLakeSize = 8
	maxLakeSize = 9
	playerStartSpace = 5
	landCoverage = 0.16
	playerCountModMax = 0.06
end

if(worldTerrainHeight >= 639) then
	lakeAreaRadius = 4
	minLakeNum = 10
	maxLakeNum = 13
	minLakeSize = 38
	maxLakeSize = 48
	playerStartSpace = 5
	landCoverage = 0.16
	playerCountModMax = 0.07
end

if(worldTerrainHeight >= 767) then
	lakeAreaRadius = 4
	minLakeNum = 12
	maxLakeNum = 16
	minLakeSize = 50
	maxLakeSize = 60
	playerStartSpace = 6
	landCoverage = 0.19
	playerCountModMax = 0.08
end

if(worldTerrainHeight >= 895) then
	lakeAreaRadius = 4
	minLakeNum = 17
	maxLakeNum = 21
	minLakeSize = 50
	maxLakeSize = 60
	playerStartSpace = 6
	landCoverage = 0.19
	playerCountModMax = 0.1
end


startLocationPositions = {}
playerStartSpaceExpanded = math.ceil(playerStartSpace * 1.5)
--loop through and find all the start positions to add to the startLocationPositions table
--also ensure there are no pillars around the start positions
for row = 1, gridSize do
	for col = 1, gridSize do
		
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			table.insert(startLocationPositions, {row, col})
			
			startNeighbors = {}
			startNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, playerStartSpaceExpanded, playerStartSpaceExpanded, {tt_lake_shallow, tt_lake_deep, tt_none}, terrainLayoutResult)
			
			for pillarIndex = 1, #startNeighbors do
				currentRow = startNeighbors[pillarIndex][1]
				currentCol = startNeighbors[pillarIndex][2]
				terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains
				
			end
			
			
			startNeighbors = {}
			startNeighbors = GetAllSquaresOfTypeInRingAroundSquare(row, col, playerStartSpace, playerStartSpace, {tt_rock_pillar, tt_lake_shallow, tt_lake_deep}, terrainLayoutResult)
			
			for pillarIndex = 1, #startNeighbors do
				currentRow = startNeighbors[pillarIndex][1]
				currentCol = startNeighbors[pillarIndex][2]
				terrainLayoutResult[currentRow][currentCol].terrainType = tt_flatland
				
			end
			
			
			
		end
	end
end

for row = 1, gridSize do
	for col = 1, gridSize do
		
		if(terrainLayoutResult[row][col].terrainType == tt_plains_smooth) then
			smoothNeighbors = {}
			smoothNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			
			for neighborIndex, smoothNeighbor in ipairs(smoothNeighbors) do
				
				
				--check if this mountain neighbor is a plains tile
				currentNeighborRow = smoothNeighbor.x
				currentNeighborCol = smoothNeighbor.y 
				if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_flatland) then
					
					terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_plains
				end
			end
			
		end
	end
end

for row = 1, gridSize do
	for col = 1, gridSize do
		
		if(terrainLayoutResult[row][col].terrainType == tt_flatland) then
			
			terrainRoll = worldGetRandom()
			if(terrainRoll <= 0.5) then
				terrainLayoutResult[row][col].terrainType = tt_plains_smooth
			elseif(terrainRoll <= 0.75) then
				terrainLayoutResult[row][col].terrainType = tt_plains
			elseif(terrainRoll <= 0.90) then
				terrainLayoutResult[row][col].terrainType = tt_valley_shallow
			elseif(terrainRoll <= 0.985) then
				terrainLayoutResult[row][col].terrainType = tt_hills_gentle_rolling
			else
			--	terrainLayoutResult[row][col].terrainType = tt_rock_pillar
			end
			
		end
	end
end

--pick a spot on the edge of the map
randomFirstCoord = math.ceil(worldGetRandom() * #terrainLayoutResult)
randomSecondCoord = #terrainLayoutResult - randomFirstCoord

if(randomSecondCoord < 1) then
	randomSecondCoord = 1
end
tradePostCoord1 = {}
tradePostCoord2 = {}

if(#teamMappingTable == 2 and randomPositions == false) then
	tradePostCoord1 = {randomFirstCoord, 2}
	tradePostCoord2 = {randomSecondCoord, #terrainLayoutResult-1}
	
	if(terrainLayoutResult[tradePostCoord1[1]][tradePostCoord1[2]].terrainType == tt_holy_site) then 
		tradePostCoord1[1] = tradePostCoord1[1] - 1
	end
	
	if(terrainLayoutResult[tradePostCoord2[1]][tradePostCoord2[2]].terrainType == tt_holy_site) then 
		tradePostCoord2[1] = tradePostCoord2[1] - 1
	end
else
	if(worldGetRandom() > 0.5) then
		tradePostCoord1 = {2, randomFirstCoord}
		tradePostCoord2 = {#terrainLayoutResult-1, randomSecondCoord}
		
		if(terrainLayoutResult[tradePostCoord1[1]][tradePostCoord1[2]].terrainType == tt_holy_site) then 
			tradePostCoord1[2] = tradePostCoord1[2] - 1
		end
		
		if(terrainLayoutResult[tradePostCoord2[1]][tradePostCoord2[2]].terrainType == tt_holy_site) then 
			tradePostCoord2[2] = tradePostCoord2[2] - 1
		end
	else
		tradePostCoord1 = {randomFirstCoord, 2}
		tradePostCoord2 = {randomSecondCoord, #terrainLayoutResult-1}
		
		if(terrainLayoutResult[tradePostCoord1[1]][tradePostCoord1[2]].terrainType == tt_holy_site) then 
			tradePostCoord1[1] = tradePostCoord1[1] - 1
		end
		
		if(terrainLayoutResult[tradePostCoord2[1]][tradePostCoord2[2]].terrainType == tt_holy_site) then 
			tradePostCoord2[1] = tradePostCoord2[1] - 1
		end
	end
end



terrainLayoutResult[tradePostCoord1[1]][tradePostCoord1[2]].terrainType = tt_settlement_plains
tradeNeighbors = {}
tradeNeighbors = Get20Neighbors(tradePostCoord1[1], tradePostCoord1[2], terrainLayoutResult)

for neighborIndex, tradeNeighbor in ipairs(tradeNeighbors) do	
	currentNeighborRow = tradeNeighbor.x
	currentNeighborCol = tradeNeighbor.y
	
	if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_holy_site and terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= playerStartTerrain) then
		terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_hills_lowlands
	end
end

terrainLayoutResult[tradePostCoord2[1]][tradePostCoord2[2]].terrainType = tt_settlement_plains
tradeNeighbors = {}
tradeNeighbors = Get20Neighbors(tradePostCoord2[1], tradePostCoord2[2], terrainLayoutResult)

for neighborIndex, tradeNeighbor in ipairs(tradeNeighbors) do	
	currentNeighborRow = tradeNeighbor.x
	currentNeighborCol = tradeNeighbor.y
	
	if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_holy_site and terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= playerStartTerrain) then
		terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_hills_lowlands
	end
end

--ensure players have building space
for row = 1, gridSize do
	for col = 1, gridSize do
		
		if(terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			
			startNeighbors = {}
			startNeighbors = GetAllSquaresInRadius(row, col, playerStartSpace - 2, terrainLayoutResult)
			
			for pillarIndex = 1, #startNeighbors do
				currentRow = startNeighbors[pillarIndex][1]
				currentCol = startNeighbors[pillarIndex][2]
				if(terrainLayoutResult[currentRow][currentCol].terrainType ~= tt_holy_site and terrainLayoutResult[currentRow][currentCol].terrainType ~= tt_settlement_plains and terrainLayoutResult[currentRow][currentCol].terrainType ~= playerStartTerrain) then
					terrainLayoutResult[currentRow][currentCol].terrainType = startBufferTerrain
				end
			end
			
		end
	end
end

--make the outer ring of the map pathable
for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(row == 1 or col == 1 or row == gridSize or col == gridSize) then
			if(terrainLayoutResult[row][col].terrainType ~= tt_holy_site and terrainLayoutResult[row][col].terrainType ~= tt_settlement_plains and terrainLayoutResult[row][col].terrainType ~= playerStartTerrain) then
				
				terrainLayoutResult[row][col].terrainType = tt_plains
			end
		end
	end
end

--create lakes per team, with each team being given the same number of lakes at positions the same distance away from average team points

--create table of points holding all available squares and their distances between teams

--first, create table of points that are all away from team locations

--create table that holds distances to all points for each team
teamLocationDistances = {}

teamDistanceThreshold = 3
lakesPerTeam = 2
lakeRadius = 1
playerLakeRadius = 1
lakeAvoidRadius = 6
playerAvoidRadius = 3
holyAvoidRadius = 5
lakeEdgeBuffer = lakeRadius

if(worldTerrainWidth <= 417) then
	teamDistanceThreshold = 3
	lakesPerTeam = 2
	lakeRadius = 1
	playerLakeRadius = 1
	lakeAvoidRadius = 6
	playerAvoidRadius = 4
	holyAvoidRadius = 5
	lakeEdgeBuffer = lakeRadius + 1
	minLakeDistance = 0.35
	maxLakeDistance = 0.5
elseif(worldTerrainWidth <= 513) then
	teamDistanceThreshold = 2
	lakesPerTeam = 2
	lakeRadius = 1
	playerLakeRadius = 1
	lakeAvoidRadius = 3
	playerAvoidRadius = 4
	holyAvoidRadius = 4
	lakeEdgeBuffer = lakeRadius + 1
	minLakeDistance = 0.265
	maxLakeDistance = 0.675
elseif(worldTerrainWidth <= 641) then
	teamDistanceThreshold = 2
	lakesPerTeam = 3
	lakeRadius = 1
	playerLakeRadius = 1
	lakeAvoidRadius = 3
	playerAvoidRadius = 4
	holyAvoidRadius = 4
	lakeEdgeBuffer = lakeRadius + 1
	minLakeDistance = 0.25
	maxLakeDistance = 0.65
elseif(worldTerrainWidth <= 769) then
	teamDistanceThreshold = 2
	lakesPerTeam = 4
	lakeRadius = 1
	playerLakeRadius = 1
	lakeAvoidRadius = 3
	playerAvoidRadius = 4
	holyAvoidRadius = 4
	lakeEdgeBuffer = lakeRadius + 1
	minLakeDistance = 0.25
	maxLakeDistance = 0.65
else
	teamDistanceThreshold = 2
	lakesPerTeam = 5
	lakeRadius = 1
	playerLakeRadius = 1
	lakeAvoidRadius = 3
	playerAvoidRadius = 4
	holyAvoidRadius = 4
	lakeEdgeBuffer = lakeRadius + 1
	minLakeDistance = 0.25
	maxLakeDistance = 0.65
end

averageTeamPositions = {}
--first find average team positions and make a small lake near each player
for teamIndex = 1, #teamMappingTable do
		
	totalRow = 0
	totalCol = 0
	for teamPlayerIndex = 1, #teamMappingTable[teamIndex].players do
		currentRow = teamMappingTable[teamIndex].players[teamPlayerIndex].startRow
		currentCol = teamMappingTable[teamIndex].players[teamPlayerIndex].startCol
		
		totalRow = totalRow + currentRow
		totalCol = totalCol + currentCol
		
		--make a nearby small lake
		nearbyRadius = 5
		nearbySquares = {}
		validNearbySquares = {}
		nearbySquares = GetAllSquaresInRadius(currentRow, currentCol, nearbyRadius, terrainLayoutResult)
	--	nearbySquares = GetAllSquaresInRingAroundSquare(currentRow, currentCol, nearbyRadius, 1, terrainLayoutResult)
		--ensure that only squares away from the edge are considered
		for neighborIndex, lakeNeighbor in ipairs(nearbySquares) do	
			canPlace = true
			currentNeighborRow = lakeNeighbor[1]
			currentNeighborCol = lakeNeighbor[2]
			if((currentNeighborRow >= 1+lakeEdgeBuffer and currentNeighborRow < (#terrainLayoutResult - lakeEdgeBuffer)) and (currentNeighborCol >= 1+lakeEdgeBuffer and currentNeighborCol <= (#terrainLayoutResult - lakeEdgeBuffer))) then
				
				--check for nearby lakes
				lakeCheckSquares = {}
				lakeCheckSquares = GetAllSquaresInRadius(currentNeighborRow, currentNeighborCol, lakeAvoidRadius, terrainLayoutResult)
				for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeCheckSquares) do	
					currentLakeCheckNeighborRow = lakeCheckNeighbor[1]
					currentLakeCheckNeighborCol = lakeCheckNeighbor[2]
					
					currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
					if(currentLakeCheckTT == tt_lake_shallow or currentLakeCheckTT == tt_lake_shallow_hill_fish) then
						canPlace = false
					end
				end
				
				--check for nearby player starts and trade posts and holy sites
				lakeCheckSquares = {}
				lakeCheckSquares = GetAllSquaresInRadius(currentNeighborRow, currentNeighborCol, playerAvoidRadius, terrainLayoutResult)
				for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeCheckSquares) do	
					currentLakeCheckNeighborRow = lakeCheckNeighbor[1]
					currentLakeCheckNeighborCol = lakeCheckNeighbor[2]
					
					currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
					if(currentLakeCheckTT == playerStartTerrain or currentLakeCheckTT == tt_settlement_plains or currentLakeCheckTT == tt_holy_site) then
						canPlace = false
					end
				end
				
				--if canPlace is still true, there are no nearby lakes
				if(canPlace == true) then
					newInfo = {}
					newInfo = {currentNeighborRow, currentNeighborCol}
					table.insert(validNearbySquares, newInfo)
				end
			end
		end
		
		--pick a square from valid nearby squares for a small lake
		print("number of valid nearby squares for a small starting lake for player " .. teamPlayerIndex .. " on team " .. teamIndex .. " is " .. #validNearbySquares)
		
		randomLakeIndex = math.ceil(worldGetRandom() * #validNearbySquares)
		randomLakeRow = validNearbySquares[randomLakeIndex][1]
		randomLakeCol = validNearbySquares[randomLakeIndex][2]
		--make a small lake here
		newLakeSquares = {}
		newLakeSquares = GetAllSquaresInRadius(randomLakeRow, randomLakeCol, playerLakeRadius, terrainLayoutResult)
		print("number of lake squares in radius is " .. #newLakeSquares)
		for neighborIndex, lakeNeighbor in ipairs(newLakeSquares) do	
			currentNeighborRow = lakeNeighbor[1]
			currentNeighborCol = lakeNeighbor[2]
			print("looking at lake square " .. neighborIndex .. " in lakeSquares at " .. currentNeighborRow .. ", " .. currentNeighborCol .. " with terrain type " .. terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType)
			if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_hills_lowlands and
				terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_holy_site and 
				terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_settlement_plains and
				terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= startBufferTerrain) then
					terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_lake_shallow_starting
					print("setting terrain to lake at " .. currentNeighborRow .. ", " .. currentNeighborCol)
				end
			end
			terrainLayoutResult[randomLakeRow][randomLakeCol].terrainType = tt_lake_shallow_hill_fish
		end
	
	avgRow = math.ceil(totalRow / #teamMappingTable[teamIndex].players)
	avgCol = math.ceil(totalCol / #teamMappingTable[teamIndex].players)
	
	--find closest edge square
	if(avgRow > (#terrainLayoutResult / 2)) then
		closeRow = (#terrainLayoutResult - avgRow)
	else
		closeRow = avgRow
	end
	
	if(avgCol > (#terrainLayoutResult / 2)) then
		closeCol = (#terrainLayoutResult - avgCol)
	else
		closeCol = avgCol
	end
	
	--if the row is closer to an edge, set the row to the close edge and save the column
	if(closeRow < closeCol) then
		if(avgRow > (#terrainLayoutResult / 2)) then
			chosenRow = #terrainLayoutResult
			chosenCol = avgCol
		else
			chosenRow = 1
			chosenCol = avgCol
		end
		--the chosen column is closer to an edge, set the col to the clsoe edge and save the row
	else
		if(avgCol > (#terrainLayoutResult / 2)) then
			chosenCol = #terrainLayoutResult
			chosenRow = avgRow
		else
			chosenCol = 1
			chosenRow = avgRow
		end
	end
	
	newInfo = {}
	newInfo = {chosenRow, chosenCol}
	table.insert(averageTeamPositions, newInfo)
	print("team " .. teamIndex .. " average position is " .. chosenRow .. ", " .. chosenCol)
end

--now compute distances to each point for each team
for teamIndex = 1, #teamMappingTable do
	print("creating distance grid for team " .. teamIndex)
	currentAverageTeamRow = averageTeamPositions[teamIndex][1]
	currentAverageTeamCol = averageTeamPositions[teamIndex][2]
	
	--set up a grid copy for this team
	currentGrid = {}
	
	--loop through the terrainLayoutResult
	for row = 1, #terrainLayoutResult do
		for col = 1, #terrainLayoutResult do
			--filter for squares away from the edge
			if((row >= 1+lakeEdgeBuffer and row < (#terrainLayoutResult - lakeEdgeBuffer)) and (col >= 1+lakeEdgeBuffer and col <= (#terrainLayoutResult - lakeEdgeBuffer))) then
				--only add blank squares that are away from holy sites to this list
				if(terrainLayoutResult[row][col].terrainType == tt_none) then
					currentInfo = {}
					currentDistance = GetDistance(row, col, currentAverageTeamRow, currentAverageTeamCol, 2)
					currentInfo = {row, col, currentDistance}
					--	print("printing current grid: row " .. row .. ", col " .. col .. ", currentDistance " .. currentInfo[3])
					table.insert(currentGrid, currentInfo)
				end
			end
		end
	end
	table.insert(teamLocationDistances, currentGrid)
end


for teamIndex = 1, #teamMappingTable do
	print("number of entries in team " .. teamIndex .. "'s specific table is " .. #teamLocationDistances[teamIndex])
end

--loop per lake
for lakeIndex = 1, lakesPerTeam do
	
	--per lake, select a distance percentile
	lakeTries = 0
	maxLakeTries = 10
	::selectLakeDistance::
	currentLakeTargetDistanceMod = GetRandomInRange(minLakeDistance, maxLakeDistance, 2)
	print("current lake target distance is " .. currentLakeTargetDistanceMod)
	--loop through each team
	for teamIndex = 1, #teamMappingTable do
		
		currentMaxDistance = 0
		currentMinDistance = 100000
		
		--find min and max distances from table
		print("number of entries in the teamLocationDistances table is " .. #teamLocationDistances)
		print("number of entries in this team's specific table is " .. #teamLocationDistances[teamIndex])
		for tableIndex = 1, #teamLocationDistances[teamIndex] do
		--	print("trying team " .. teamIndex .. " row " .. teamLocationDistances[teamIndex][tableIndex][1] .. " col " .. teamLocationDistances[teamIndex][tableIndex][2])
			
			currentTableDistance = teamLocationDistances[teamIndex][tableIndex][3]
		--	print("current table distance at that coord is " .. currentTableDistance)
			if(currentTableDistance > currentMaxDistance) then
				currentMaxDistance = currentTableDistance
			end
			if(currentTableDistance < currentMinDistance) then
				currentMinDistance = currentTableDistance
			end
			
		end
		
		print("current min/max distances for team " .. teamIndex .. " table are " .. currentMinDistance .. ", " .. currentMaxDistance)
		currentTargetDistance = currentMaxDistance * currentLakeTargetDistanceMod
		print("current target distance is " .. currentTargetDistance)
		
		--loop through the table and get the current set of squares that fit within the correct distance band for this lake
		currentPossibleSquares = {}
		for tableIndex = 1, #teamLocationDistances[teamIndex] do
			
			currentTableDistance = teamLocationDistances[teamIndex][tableIndex][3]
			if(currentTableDistance < currentTargetDistance + teamDistanceThreshold and currentTableDistance > currentTargetDistance - teamDistanceThreshold) then
				newInfo = {}
				currentRow = teamLocationDistances[teamIndex][tableIndex][1]
				currentCol = teamLocationDistances[teamIndex][tableIndex][2]
				newInfo = {currentRow, currentCol}
				canPlace = true
				--check for nearby lakes
				lakeCheckSquares = {}
				lakeCheckSquares = GetAllSquaresInRadius(currentRow, currentCol, lakeAvoidRadius, terrainLayoutResult)
				for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeCheckSquares) do	
					currentLakeCheckNeighborRow = lakeCheckNeighbor[1]
					currentLakeCheckNeighborCol = lakeCheckNeighbor[2]
					
					currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
					if(currentLakeCheckTT == tt_lake_shallow or currentLakeCheckTT == tt_lake_shallow_hill_fish or currentLakeCheckTT == playerStartTerrain) then
						canPlace = false
					end
				end
				
				--check for holy sites and trade posts
				holyCheckSquares = {}
				holyCheckSquares = GetAllSquaresInRadius(currentRow, currentCol, holyAvoidRadius, terrainLayoutResult)
				for holyCheckIndex, holyCheckNeighbor in ipairs(holyCheckSquares) do	
					currentHolyCheckNeighborRow = holyCheckNeighbor[1]
					currentHolyCheckNeighborCol = holyCheckNeighbor[2]
					
					currentHolyCheckTT = terrainLayoutResult[currentHolyCheckNeighborRow][currentHolyCheckNeighborCol].terrainType
					if(currentHolyCheckTT == tt_holy_site or currentLakeCheckTT == tt_settlement_plains or currentLakeCheckTT == playerStartTerrain) then
						canPlace = false
					end
				end
				if(canPlace == true) then
					table.insert(currentPossibleSquares, newInfo)
				end
			end
			
		end
		print("number of current possible squares is " .. #currentPossibleSquares)
		--choose one of the valid squares to spawn a lake
		if(#currentPossibleSquares > 0) then
			randomLakeIndex = math.ceil(worldGetRandom() * #currentPossibleSquares)
			currentLakeRow = currentPossibleSquares[randomLakeIndex][1]
			currentLakeCol = currentPossibleSquares[randomLakeIndex][2]
			print("growing lake from coordinate " .. currentLakeRow .. ", " .. currentLakeCol)
			lakeSquares = {}
			lakeSquares = GetAllSquaresInRadius(currentLakeRow, currentLakeCol, lakeRadius, terrainLayoutResult)
			print("number of lake squares in radius is " .. #lakeSquares)
			for neighborIndex, lakeNeighbor in ipairs(lakeSquares) do	
				currentNeighborRow = lakeNeighbor[1]
				currentNeighborCol = lakeNeighbor[2]
				print("looking at lake square " .. neighborIndex .. " in lakeSquares at " .. currentNeighborRow .. ", " .. currentNeighborCol .. " with terrain type " .. terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType)
				if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_hills_gentle_rolling and
						terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_holy_site and 
						terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= tt_settlement_plains and
						terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType ~= startBufferTerrain) then
					terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType = tt_lake_shallow
					print("setting terrain to lake at " .. currentNeighborRow .. ", " .. currentNeighborCol)
				end
			end
			terrainLayoutResult[currentLakeRow][currentLakeCol].terrainType = tt_lake_shallow_hill_fish
			--	GrowTerrainAreaToSizeKeepStartTerrain(currentLakeRow, currentLakeCol, lakeSize, tt_lake_shallow_starting_fish, {tt_none}, tt_lake_shallow, terrainLayoutResult)
		else
			
			lakeTries = lakeTries + 1
			if(lakeTries <= maxLakeTries) then
				print("restarting lake try number " .. lakeTries)
				goto selectLakeDistance
			end
		end
		
		--go through all lists and remove squares that are now a lake
		for removeTeamIndex = 1, #teamMappingTable do
			for removeTableIndex = #teamLocationDistances[removeTeamIndex], 1, -1 do
				currentRow = teamLocationDistances[removeTeamIndex][removeTableIndex][1]
				currentCol = teamLocationDistances[removeTeamIndex][removeTableIndex][2]
				currentTerrainType = terrainLayoutResult[currentRow][currentCol].terrainType
				if(currentTerrainType ~= tt_none) then
					table.remove(teamLocationDistances[removeTeamIndex], removeTableIndex)
				--	print("removing index " .. removeTableIndex)
				end
				
			end
		end
	end
end

print("terrain type none is " .. tt_none)


--remove the larger buffer around starts that was made for lakes
for row = 1, gridSize do
	for col = 1, gridSize do
	
		if(terrainLayoutResult[row][col].terrainType == tt_plains) then
			terrainLayoutResult[row][col].terrainType = tt_none
		end
		
		--buffer around lake squares to ensure more consistent lake sizes
		if(terrainLayoutResult[row][col].terrainType == tt_lake_shallow or terrainLayoutResult[row][col].terrainType == tt_lake_shallow_starting) then
			isLakeNeighbor = false
			lakeNeighbors = {}
			lakeNeighbors = Get8Neighbors(row, col, terrainLayoutResult)
			for lakeCheckIndex, lakeCheckNeighbor in ipairs(lakeNeighbors) do	
				currentLakeCheckNeighborRow = lakeCheckNeighbor.x
				currentLakeCheckNeighborCol = lakeCheckNeighbor.y
				
				currentLakeCheckTT = terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType
				if(currentLakeCheckTT ~= tt_lake_shallow and currentLakeCheckTT ~= tt_lake_shallow_hill_fish and
				   currentLakeCheckTT ~= tt_holy_site and currentLakeCheckTT ~= tt_settlement_plains and currentLakeCheckTT ~= tt_lake_shallow_starting) then
					terrainLayoutResult[currentLakeCheckNeighborRow][currentLakeCheckNeighborCol].terrainType = tt_flatland
					
				end
			end
		end
	end
end



print("END OF ANCIENT SPIRES LUA SCRIPT")