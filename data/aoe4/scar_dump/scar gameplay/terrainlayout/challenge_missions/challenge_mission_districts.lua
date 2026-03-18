-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
print("GENERATING FRNECH PASS")

n = tt_none

h = tt_hills_med_rolling
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_low_rolling
o = tt_ocean
p = tt_plains
f = tt_flatland
s = tt_player_start_nomad_hills
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains
pl = tt_plateau_low
v = tt_valley
vs = tt_valley_shallow

f1 = tt_impasse_trees_plains
c = tt_trees_plains_clearing


terrainLayoutResult = {}    -- set up initial table for coarse map grid
--set up resource pockets for nomad start
pocketResources1 = {}
pocketResources2 = {}
pocketResources3 = {}

--create groups of pocket resources that will equal out to balanced resources
--players will randomly get one set of these
pocketResourceList = {}
table.insert(pocketResourceList, pocketResources1)
table.insert(pocketResourceList, pocketResources2)
table.insert(pocketResourceList, pocketResources3)

psa = tt_pocket_stone_a
psb = tt_pocket_stone_b
psc = tt_pocket_stone_c
pga = tt_pocket_gold_a
pgb = tt_pocket_gold_b
pgc = tt_pocket_gold_c
pwa = tt_pocket_wood_a
pwb = tt_pocket_wood_b
pwc = tt_pocket_wood_c

table.insert(pocketResources1, psa)
table.insert(pocketResources1, pgb)
table.insert(pocketResources1, pwc)
table.insert(pocketResources2, psb)
table.insert(pocketResources2, pgc)
table.insert(pocketResources2, pwa)
table.insert(pocketResources3, psc)
table.insert(pocketResources3, pga)
table.insert(pocketResources3, pwb)

-- create a list of tactical regions to choose from
-- gold tactical regions
tga = tt_tactical_region_gold_plains_a


-- MAP/GAME SET UP ------------------------------------------------------------------------
gridHeight, gridWidth, gridSize = SetCoarseGrid()

nomadStart = false
if (winConditionOptions.section_starting_conditions and winConditionOptions.section_starting_conditions.option_age_start) then
	nomadStart = (winConditionOptions.section_starting_conditions.option_age_start.enum_value == winConditionOptions.section_starting_conditions.option_age_start.enum_items.nomad_start)
	print("NOMAD START CONDITION IS: " ..winConditionOptions.section_starting_conditions.option_age_start.enum_value.." ("..tostring(nomadStart)..")")
else
	print("NOMAD START CONDITION IS NOT SET (FALSE)")
end

print("WORLD TERRAIN WIDTH IS " ..worldTerrainWidth)
print("NUMBER OF PLAYERS IS " ..worldPlayerCount)
print("GRID HEIGHT IS " ..gridHeight .." GRID WIDTH IS " ..gridWidth .." GRID SIZE IS " ..gridSize)

playerStarts = worldPlayerCount

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--set chance to kill a mountain to thin out the ridge
mountainKillChance = 0.2
valleyDepreciateChance = 0.3

--set number of extra mountains on the sides of the ridge
extraSideMountains = 8
numOfPlateaus = 2

--set map size specific scaling options
if(worldTerrainWidth <= 513) then
	
	--lane width is how wide the space between the 2 central ridges is
	laneWidth = 2
	--this is the percentage chance that spaces beside the ridges will reamin plains
	mountainRangeThicknessChance = 0.6
	--this is the number of times the central ridge can expand per row
	extraMountainLimit = 1	
	
	extraSideMountains = 4
	
--	i = tt_mountains
end

if(worldTerrainWidth <= 769 and worldTerrainWidth > 513) then
	laneWidth = 2
	mountainRangeThicknessChance = 0.5
	extraMountainLimit = 2	
	extraSideMountains = 6
end

if(worldTerrainWidth <= 1025 and worldTerrainWidth > 769) then
	laneWidth = 3
	mountainRangeThicknessChance = 0.2
	extraMountainLimit = 7	
end

print("grid width is " .. gridSize)


-- draw first mountain pass
--DrawLineOfTerrain((mapQuarterSize + mapEighthSize), (mapQuarterSize + mapEighthSize), (mapQuarterSize + mapEighthSize), (mapHalfSize + mapEighthSize), m, false, gridSize)
DrawLineOfTerrain((mapHalfSize - laneWidth), (mapQuarterSize), (mapHalfSize - laneWidth), (mapHalfSize + mapQuarterSize), i, false, gridSize)
print("First Line --- StartRow: " ..(mapHalfSize - laneWidth) .." EndRow: " ..(mapQuarterSize) .." StartCol: " ..(mapHalfSize - laneWidth) .. "EndCol: " ..(mapHalfSize + mapQuarterSize))

--draw second mountain ridge
DrawLineOfTerrain(mapHalfSize + laneWidth, mapQuarterSize, mapHalfSize + laneWidth, mapHalfSize + mapQuarterSize, i, false, gridSize)
print("Second Line --- StartRow: " ..(mapHalfSize + laneWidth) .." EndRow: " ..(mapQuarterSize))

-- set rows and columns to avoid placing settlements in
settlementAvoidRowTop1 = mapHalfSize + laneWidth + 1
settlementAvoidRowTop2 = mapHalfSize + laneWidth - 1
settlementAvoidRowBottom1 = mapHalfSize - laneWidth - 1
settlementAvoidRowBottom2 = mapHalfSize - laneWidth + 1

settlementAvoidColLeft = (mapHalfSize - laneWidth) - 1
settlementAvoidColRight = (mapHalfSize + mapQuarterSize) + 1


--draw second mountain ridge
--DrawLineOfTerrain(mapHalfSize + 2, mapQuarterSize, mapHalfSize + 2, mapHalfSize + mapQuarterSize, m, false, gridSize)

--iterate through map and create iterative features

for y = 1, gridSize do
	extraMountains = 0 
	for x = 1, gridSize do
	
	
	--add gold bounty squares through the middle
	if((x == gridHalfSize) and (y > (mapQuarterSize)) and (y < (gridSize - mapQuarterSize))) then 
		--add gold every second square through the middle
		if(y % 2 == 0) then
			terrainLayoutResult[x][y].terrainType = bg
		else
			terrainLayoutResult[x][y].terrainType = p
			
		end
	
	--bulge the ridge randomly
	if(terrainLayoutResult[x][y].terrainType == i and (y > mapQuarterSize and y < mapHalfSize + mapQuarterSize)) then
		if(worldGetRandom() >= mountainRangeThicknessChance and extraMountains < extraMountainLimit) then
			if(worldGetRandom() >= 0.5) then
				terrainLayoutResult[x+1][y].terrainType = i
			else
				terrainLayoutResult[x-1][y].terrainType = m
			end
			extraMountains = extraMountains + 1
			
		end
	end
	
	
	
	
				
	-- set the outer ring to a terrain type that isn't mountains at outer array locations
		if((x == 1) or (x == gridSize) or (y == 1) or (y == gridSize)) then
			RNG = worldGetRandom()
			if(RNG <= 1) then
				terrainLayoutResult[x][y].terrainType = p
			end
			if(RNG <= 0.66) then
				terrainLayoutResult[x][y].terrainType = h
			end
			if(RNG <= 0.33) then
				terrainLayoutResult[x][y].terrainType = b
			end
			
		end
	
	end
	end
end



--add in more random mountains on the edges
for index = 1, extraSideMountains do

	newMountainX, newMountainY = GetSquareInBox(mapEighthSize-1, mapQuarterSize+1, mapEighthSize, gridSize - mapEighthSize, gridSize)
	terrainLayoutResult[newMountainX][newMountainY].terrainType = i
	
	newMountainX2, newMountainY2 = GetSquareInBox(mapHalfSize+mapQuarterSize-1, gridSize - mapEighthSize +1, mapEighthSize, gridSize - mapEighthSize, gridSize)
	terrainLayoutResult[newMountainX2][newMountainY2].terrainType = i

end
	
	
	
--set player start locations
playerStart1x = 3
playerStart1y = 3

playerStart2x = gridSize - 2
playerStart2y = gridSize - 2

--for games of 4 or more people
playerStart3x = gridSize - 2
playerStart3y = 3

--for games of exactly 3
playerStart3xb = mapHalfSize
playerStart3yb = mapHalfSize

playerStart4x = 3
playerStart4y = gridSize - 2

playerStart5x = 3
playerStart5y = mapHalfSize

playerStart6x = gridSize - 2
playerStart6y = mapHalfSize

playerStart7x = mapHalfSize 
playerStart7y = mapEighthSize

playerStart8x = mapHalfSize
playerStart8y = gridSize - mapEighthSize

-- NEW START LOCATION FORMAT
startPosition01 = MakeStartArea(1, playerStart1x, playerStart1x, playerStart1y, playerStart1y, {5, 7})
startPosition02 = MakeStartArea(2, playerStart2x, playerStart2x, playerStart2y, playerStart2y, {6, 8}) 
startPosition03 = MakeStartArea(3, playerStart3x, playerStart3x, playerStart3y, playerStart3y, {6, 7})
startPosition04 = MakeStartArea(4, playerStart4x, playerStart4x, playerStart4y, playerStart4y, {5, 8})
startPosition05 = MakeStartArea(5, playerStart5x, playerStart5x, playerStart5y, playerStart5y, {1, 4})
startPosition06 = MakeStartArea(6, playerStart6x, playerStart6x, playerStart6y, playerStart6y, {2, 3})
startPosition07 = MakeStartArea(7, playerStart7x, playerStart7x, playerStart7y, playerStart7y, {1, 3})
startPosition08 = MakeStartArea(8, playerStart8x, playerStart8x, playerStart8y, playerStart8y, {2, 4})

masterStartPositionsTable = {startPosition01, startPosition02, startPosition03, startPosition04, startPosition05, startPosition06, startPosition07, startPosition08}
openStartPositions = {}

for i = 1, #masterStartPositionsTable do
	print("Start Position " ..i .." is at row: " ..masterStartPositionsTable[i].startRow ..", Col: " ..masterStartPositionsTable[i].startCol)
end

-- add start areas to the open list
for index = 1, #masterStartPositionsTable do
	tempStartPosition = masterStartPositionsTable[index]
	table.insert(openStartPositions, index, tempStartPosition)
end

for index = 1, #openStartPositions do
	print("OSP ID " ..index .." is " ..openStartPositions[index].startID .." Number of connections is: " ..#openStartPositions[index].connections)	 
end



--carve guaranteed pass through the middle
DrawLineOfTerrain(mapHalfSize, (mapEighthSize), mapHalfSize, (gridSize - mapEighthSize), f, false, gridSize)
if(worldTerrainWidth > 513) then
	DrawLineOfTerrain(mapHalfSize+1, (mapEighthSize), mapHalfSize+1, (gridSize - mapEighthSize), b, false, gridSize)
	DrawLineOfTerrain(mapHalfSize-1, (mapEighthSize), mapHalfSize-1, (gridSize - mapEighthSize), b, false, gridSize)
end

for y = 1, gridSize do
	for x = 1, gridSize do
	
	--random valley depreciating
	if(terrainLayoutResult[x][y].terrainType == b and worldGetRandom() < valleyDepreciateChance) then
		terrainLayoutResult[x][y].terrainType = h
	end
	
	
	end
end


--make valley go randomly from player start to anywhere between 1/8 and 1/2 the way through the middle of the map
randomY1 = worldGetRandom() * (mapHalfSize - mapEighthSize)
randomY2 = worldGetRandom() * (mapHalfSize - mapEighthSize)
randomY3 = worldGetRandom() * (mapHalfSize - mapEighthSize)
randomY4 = worldGetRandom() * (mapHalfSize - mapEighthSize)


--draw guaranteed line of passable terrain from player start to mountain range entrance
DrawLineOfTerrain(playerStart1x, playerStart1y, mapHalfSize, math.floor(mapEighthSize + randomY1), f, true, gridSize)
DrawLineOfTerrain(playerStart2x, playerStart2y, mapHalfSize, math.floor(gridSize - mapEighthSize - randomY2), f, true, gridSize)

DrawLineOfTerrain(playerStart3x, playerStart3y, mapHalfSize, math.floor(mapEighthSize + randomY3), f, true, gridSize)
DrawLineOfTerrain(playerStart4x, playerStart4y, mapHalfSize, math.floor(gridSize - mapEighthSize - randomY4), f, true, gridSize)


--place plateau ridges on opposite sides of the map
for i = 1, numOfPlateaus do
	plat1x, plat1y = GetSquareInBox((mapEighthSize), (mapQuarterSize), (mapQuarterSize), (gridSize - mapQuarterSize), gridSize)
	plat2x, plat2y = GetSquareInBox((mapHalfSize + mapQuarterSize), (gridSize - mapEighthSize), (mapHalfSize - mapQuarterSize), (gridSize - mapQuarterSize), gridSize)

	if(terrainLayoutResult[plat1x][plat1y].terrainType ~= i) then
		terrainLayoutResult[plat1x][plat1y].terrainType = pl
	end
	
	if(terrainLayoutResult[plat1x-1][plat1y].terrainType ~= i) then
		terrainLayoutResult[plat1x-1][plat1y].terrainType = pl
	end
	
	if(terrainLayoutResult[plat1x-1][plat1y-1].terrainType ~= i) then
		terrainLayoutResult[plat1x-1][plat1y-1].terrainType = pl
	end

	if(terrainLayoutResult[plat2x][plat2y].terrainType ~= i) then
		terrainLayoutResult[plat2x][plat2y].terrainType = pl
	end
	
	if(terrainLayoutResult[plat2x+1][plat2y].terrainType ~= i) then
		terrainLayoutResult[plat2x+1][plat2y].terrainType = pl
	end
	
	if(terrainLayoutResult[plat2x+1][plat2y+1].terrainType ~= i) then
		terrainLayoutResult[plat2x+1][plat2y+1].terrainType = pl
	end
end

--DrawLineOfTerrain(mapHalfSize, (mapEighthSize + math.ceil(mapEighthSize/2) + 1), mapHalfSize, (gridSize - (mapEighthSize + math.ceil(mapEighthSize/2)) - 1), bg, false, gridSize)
terrainLayoutResult[mapHalfSize+1][mapHalfSize].terrainType = tga
terrainLayoutResult[mapHalfSize-1][mapHalfSize].terrainType = tga
terrainLayoutResult[mapHalfSize][mapHalfSize+1].terrainType = tga
terrainLayoutResult[mapHalfSize][mapHalfSize-1].terrainType = tga
--if(gridSize > 13) then
	terrainLayoutResult[mapHalfSize+1][mapHalfSize+1].terrainType = tga
	terrainLayoutResult[mapHalfSize-1][mapHalfSize-1].terrainType = tga
	terrainLayoutResult[mapHalfSize+1][mapHalfSize-1].terrainType = tga
	terrainLayoutResult[mapHalfSize-1][mapHalfSize+1].terrainType = tga
--end


startingAreaCount = 0

centerBoundMin = 5 --gridSize * 0.3
centerBoundMax = 9 --gridSize * 0.7

-- Clear center of Map for Challenge Mission starting position
for y = 1, gridSize do
	
	for x = 1, gridSize do
		
		-- If tile is in center of map
		if(x >= centerBoundMin and x <= centerBoundMax and y >= centerBoundMin and y <= centerBoundMax) then
			
			-- Set to plain
			terrainLayoutResult[x][y].terrainType = p
			
			-- If map center
			if (x == 7 and y == 7) then
				
				-- Set to flatland
				terrainLayoutResult[x][y].terrainType = f
				print("center set")
			end
			
			-- Increment count
			startingAreaCount = startingAreaCount + 1
			
		end
	
	end
end


--set player start locations on the map
startLocationPositions = {}

-- PLACE PLAYER START POSITIONS -----------------------------------------------------
print("RANDOM POSITIONS IS " ..tostring(randomPositions))
-- find a start location for each player

if (worldPlayerCount <=4) then -- reduce start positions options to 4 to keep players far enough apart
		
	--	if (worldGetRandom() < 0.49 and worldTerrainHeight > 513) then -- remove start positions on edges
			
		--	for index = 4, 1, -1 do
		--		table.remove(openStartPositions, index)
		--	end
			
	--	else -- remove start positions on corners				
			
			for index = 8, 5, -1 do
				table.remove(openStartPositions, index)
			end
			
	--	end	

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
		terrainLayoutResult[x][y].playerIndex = startLocationPositions[index].playerID
		terrainLayoutResult[x+1][y].terrainType = p
		terrainLayoutResult[x][y+1].terrainType = p
		terrainLayoutResult[x][y-1].terrainType = p
		terrainLayoutResult[x+1][y+1].terrainType = m
		print("Setting PlayerID in terrain layout to " ..startLocationPositions[index].playerID)
	end



--set starting conditions
function SetStartConditions(nomadStart)

	if(nomadStart) then
	
		print("setting NOMAD start conditions")
		--place nomad resources
		playerResourcePocketSets = {}
		
		-- assign a resource pocket set to each player (may refine this later to be more deterministic)
		for index = 1, playerStarts do
			table.insert(playerResourcePocketSets, index, GetRandomElement(pocketResourceList))	
		end
		
		PlaceNomadResourcePockets(startLocationPositions, 3, 2, 1, {b, i, n, p, pl}, terrainLayoutResult, 2, playerResourcePocketSets, gridSize)
		
	else
	
		s = tt_player_start_classic_hills
		print("setting CLASSIC start conditions")
	
	end	
	
	
	for i = 1, (#startLocationPositions) do
	
		terrainLayoutResult[startLocationPositions[i].startRow][startLocationPositions[i].startCol].terrainType = s
	
	end

end

SetStartConditions(nomadStart)




print("END OF FRENCH PASS LUA SCRIPT")
