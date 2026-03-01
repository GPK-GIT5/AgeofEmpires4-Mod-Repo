-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING PLAINS")

n = tt_none

s = tt_player_start_plains
p = tt_plains
v = tt_valley

-- check to see if nomad start is active and set bool accordignly
nomadStart = false -- initialize bool as false
if (winConditionOptions.section_starting_conditions and winConditionOptions.section_starting_conditions.option_age_start) then
	nomadStart = (winConditionOptions.section_starting_conditions.option_age_start.enum_value == winConditionOptions.section_starting_conditions.option_age_start.enum_items.nomad_start)
	print("NOMAD START CONDITION IS: " ..winConditionOptions.section_starting_conditions.option_age_start.enum_value.." ("..tostring(nomadStart)..")")
else
	print("NOMAD START CONDITION IS NOT SET (FALSE)")
end

-- set player start location terrain types (for spawning starting resources) according to momad setting
if(nomadStart) then
	playerStartTerrain = tt_player_start_nomad_plains -- nomad mode start
else
	playerStartTerrain = tt_player_start_classic_plains -- classic mode start	
end

--set up resource pockets
nomadPocketResources1 = {}
nomadPocketResources2 = {}
nomadPocketResources3 = {}

--create groups of pocket resources that will be spawned for nomad mode
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

-- MAP/GAME SET UP ------------------------------------------------------------------------
terrainLayoutResult = {}    -- set up initial table for coarse map grid

gridHeight, gridWidth, gridSize = SetCoarseGrid() -- set up coarse grid using function found in map_setup lua file in library folder

-- debug output for grid
print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

baseGridSize = 25 -- use this grid size for scaling map feautres by map size

-- setting up the map terrain using function found in map_setup lua file in library folder
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

-- set up start area data using function found in player_starts lua file in library folder
masterStartPositionsTable = MakeStartPositionsTableClose(gridWidth, gridHeight, gridSize)
-- copy master table to open table that will be used to select player start locations
openStartPositions = DeepCopy(masterStartPositionsTable)

for index = 1, #openStartPositions do
	print("OSP ID " ..index .." is " ..openStartPositions[index].startID .." Number of connections is: " ..#openStartPositions[index].connections)	 
end

-- PLACE PLAYER START POSITIONS -----------------------------------------------------
startLocationPositions = {} -- table to hold the rdata for each player location

print("RANDOM POSITIONS IS " ..tostring(randomPositions))
-- find a start location for each player

if (worldPlayerCount <=4) then -- reduce start positions options to 4 to keep players far enough apart
		
		if (worldGetRandom() < 0.49) then -- remove start positions on edges
			
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
	
		-- select start positions
		startLocationPositions = GetStartPositionsTeamsTogether(openStartPositions, masterStartPositionsTable)
	
	end

	-- place the start positions on the coarse grid
	for index = 1, #startLocationPositions do
		x = startLocationPositions[index].startRow
		y = startLocationPositions[index].startCol
		print("Player " ..index .." is at row " ..x ..", col "..y)
		terrainLayoutResult[x][y].terrainType = playerStartTerrain -- place terrain type for player start position that will spawn hte starting resources
		terrainLayoutResult[x][y].playerIndex = startLocationPositions[index].playerID -- player ID must be set to make this a valid player start
		print("Setting PlayerID in terrain layout to " ..startLocationPositions[index].playerID)
	end

-- check nomad status for nomad starting resources
if(nomadStart) then
	--place nomad resources
	print("PLACING NOMAD RESOURCES...")
	playerResourcePocketSets = {}
	
	-- assign a resource pocket set to each player
	for index = 1, #(startLocationPositions) do
		table.insert(playerResourcePocketSets, index, GetRandomElement(nomadPocketResourceList))	
	end
	
	PlaceNomadResourcePockets(startLocationPositions, 3, 2, 1, {n, p}, terrainLayoutResult, 2, playerResourcePocketSets, gridSize)	-- function places three seperate resource pockets for hte player to choose from when placing their initial TC. Found in playerresources lua file in library folder 
end

print("END OF PLAINS LUA SCRIPT")
