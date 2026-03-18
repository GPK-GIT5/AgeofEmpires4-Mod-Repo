-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "River Madness"
print("Start of Script - " .. mapName .. ".")

-- Defining terrains for the map.
originTerrain = tt_pond_island_player_start
baseTerrain = tt_mountains
oceanDeep = tt_ocean_deep

spawnTerrain = tt_plains
middleTerrain = tt_pond_island_middle

middleSlope = tt_sacred_crest_middle_slope
centreTerrain = tt_plateau_med
middleElevationOne = tt_hills_med_rolling
middleElevationTwo = tt_hills_high_rolling
middleElevationThree = tt_plateau_med

slopeFlat = tt_plains
slopeRolling = tt_hills_gentle_rolling

middleGold = tt_migration_middle_gold
middleStone = tt_migration_middle_stone

divineTerrain = tt_waterholes_holy_site
tradeTerrain = tt_waterholes_settlement

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 23
minimumMapScope = 20
maximumMapScope = 100
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------

	print("Start of Script - " .. mapName .. ".")

	-- Creating spawn positions.
	if (isZeroPlayerGame ~= true) then	
		local	ringRadius = 85
		local positionVariance = 0
		local rotationSetting = true
		local mirrorGeneration = true
		PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)
	end

	-- Creating the central landmass.
	local terrainType = middleTerrain
	local originRow = mapCentre
	local originColumn = mapCentre

	if (isTinyMap == true) then
		tileAmount = 6
	elseif (isSmallMap == true) then
		tileAmount = 4
	elseif (isMediumMap == true) then
		tileAmount = 8
	elseif (isLargeMap == true) then
		tileAmount = 12
	elseif (isHugeMap == true) then
		tileAmount = 16
	end

	baseRadius = 30
	local tileRatio = true
	local baseRatio = true
	local avoidanceDistance = 1
	local edgeAvoidance = ScaleByMapSize(6, true, true)
	CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

	-- Executes the player zoning and creates the underlying spawn terrain, creating dividing rivers out of base terrain.
	local avoidanceTable = middleTerrain
	local zoneDistance = 3
	local maximumDeviation = 5
	local spawnZones = DefineSpawnZones(avoidanceTable, zoneDistance, maximumDeviation)

	for tableIndex = 1, #spawnZones do
		local tableName = spawnZones
		local terrainTable = tt_plains
		GenerateTerrainsFromTable(spawnZones[tableIndex], terrainTable)
	end

	-- Sets neutral middle zone.
	SetZoneOrigin(mapCentre, mapCentre)

	-- Executes the zoning.
	local avoidanceTable = {
		baseTerrain,
		middleSlope,
		spawnTerrain
	}
	local zoneDistance = 3
	local maximumDeviation = 5
	otherZones = DefineOtherZones(avoidanceTable, zoneDistance, maximumDeviation)

	-- Places the central holy site.
	terrainGrid[mapCentre][mapCentre].terrainType = tt_sacred_crest_holy_site

	-- Places random elevation on the central pleatue.
	local theTable = otherZones[1]
	local acceptanceTerrain = {middleTerrain}
	local avoidanceTerrain = {
		baseTerrain,
		spawnTerrain
	}
	local locateNumber = 8
	local distributionType = "map"
	local separationDistance = 6
	local avoidanceDistance = ScaleByMapSize(1, true, true)
	local minimumDistance = 2
	local edgeAvoidance = 1

	-- Places relics on the plateau that scales with the map size.
	local slopeTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	local tableName = slopeTable
	local terrainTable = tt_sacred_crest_plateau_relic
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Creates neutral golds on the plateau that scales with the map size.
	local locateNumber = 3
	local slopeTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	local tableName = slopeTable
	local terrainTable = tt_sacred_crest_gold_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Creates neutral stones on the plateau that scales with the map size.
	local locateNumber = 3
	local slopeTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	local tableName = slopeTable
	local terrainTable = tt_sacred_crest_stone_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Creates forests for each spawn zone.
	local acceptanceTerrain = {
		spawnTerrain,
	}
	
	local avoidanceTerrain = {
		baseTerrain,
		middleTerrain
	}
	local locateNumber = 5
	local distributionType = "relative"
	local separationDistance = 6
	local avoidanceDistance = 2
	local minimumDistance = 3
	local edgeAvoidance = 1
	local forceEquality = EnsureProportionateDistribution(spawnZones)
	
	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local spawnForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
		local tableName = spawnForestTable
		local terrainTable = tt_forest_natural_small
		GenerateTerrainsFromTable(tableName, terrainTable)
	end

	-- Placing gold deposits for each player.
	local locateNumber = 2
	local distributionType = "fixed"
	local separationDistance = 6
	local avoidanceDistance = 2
	local minimumDistance = 4

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
		local tableName = resourceTable
		local terrainTable = tt_sacred_crest_gold
		GenerateTerrainsFromTable(tableName, terrainTable)
	end

	-- Placing stone deposits for each player.
	local locateNumber = 2
	local distributionType = "fixed"
	local separationDistance = 6
	local avoidanceDistance = 2
	local minimumDistance = 4

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
		local tableName = resourceTable
		local terrainTable = tt_sacred_crest_stone
		GenerateTerrainsFromTable(tableName, terrainTable)
	end
	
	-- Placing forage bush clusters for each player.
	local locateNumber = 2
	local distributionType = "fixed"
	local separationDistance = 6
	local avoidanceDistance = 2
	local minimumDistance = 4

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
		local tableName = resourceTable
		local terrainTable = tt_sacred_crest_forage_bush
		GenerateTerrainsFromTable(tableName, terrainTable)
	end