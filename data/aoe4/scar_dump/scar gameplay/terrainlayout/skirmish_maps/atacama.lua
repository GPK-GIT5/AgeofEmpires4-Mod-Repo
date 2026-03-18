-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "Atacama"

-- Defining terrains for the map.
originTerrain = tt_atacama_player_start
spawnTerrain = tt_plains

baseTerrain = tt_plains
baseVariationOne = tt_hills_low_rolling
baseVariationTwo = tt_hills_med_rolling
baseVariationThree = tt_hills_high_rolling

middleTerrain = tt_flatland
middleForest = tt_forest_natural_small

outsideForest = tt_forest_natural_grove
oasisTerrain = tt_atacama_oasis

divineTerrain = tt_atacama_holy_site
tradeTerrain = tt_atacama_settlement

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 25
minimumMapScope = 10
maximumMapScope = 120
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------

	print("Start of Script - " .. mapName .. ".")

	-- Creating a vast flat area in the centre of the map for the middle forests.
	local terrainType = middleTerrain
	local originRow = mapCentre
	local originColumn = mapCentre
	
	if (isTinyMap == true) then
		tileAmount = 6
		baseRadius = 20
	elseif (isSmallMap == true) then
		tileAmount = 4
		baseRadius = 26
	elseif (isMediumMap == true) then
		tileAmount = 10
		baseRadius = 31
	elseif (isLargeMap == true) then
		tileAmount = 16
		baseRadius = 36
	elseif (isHugeMap == true) then
		tileAmount = 128
		baseRadius = 42
	end
	
	local tileRatio = true
	local baseRatio = true
	local avoidanceDistance = ScaleByMapSize(4, true, true)
	local edgeAvoidance = ScaleByMapSize(4, true, true)
	CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

	-- Setting neutral zoning origin, in this case, the central area.
	SetZoneOrigin(mapCentre, mapCentre)
	
	-- Executing the zoning with the variables below.
	local avoidanceTable = baseTerrain
	local zoneDistance = 0
	local maximumDeviation = 5
	local otherZones = DefineOtherZones(avoidanceTable, zoneDistance, maximumDeviation)

	-- Defining the forests clumps for the central area and saving them in a table.
	local theTable = otherZones[1]
	local acceptanceTerrain = middleTerrain
	local avoidanceTerrain = baseTerrain
	local locateNumber = 40
	local distributionType = "relative"
	local separationDistance = 0
	local avoidanceDistance = 1
	local minimumDistance = 0
	local edgeAvoidance = 1
	local middleForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	
	-- Generating the actual forests on the central area.
	local tableName = middleForestTable
	local terrainTable = middleForest
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Running the player setup and placement, unless there's no players present.
	if (isZeroPlayerGame ~= true) then
		local ringRadius = 75
		local positionVariance = 0
		local rotationSetting = true
		local mirrorGeneration = false
		PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)
	
		-- Defining the size and shape of the player areas.
		local tileAmount = 6
		local tileRatio = false
		local baseRadius = 3
		local baseRatio = false
		local avoidanceDistance = 8
		local edgeAvoidance = 1
		local borderRadius = 0
		local centreAvoidance = 50
		local clumpingFactor = 50
	
		local creationProperties = {}
		for spawnPositionsIndex, spawnInformation in ipairs(spawnPositions) do
			local spawnInformationRow, spawnInformationColumn = table.unpack(spawnInformation)
	
			local noInformation = {}
			table.insert(creationProperties, noInformation)
	
			table.insert(creationProperties[spawnPositionsIndex], spawnTerrain)
			table.insert(creationProperties[spawnPositionsIndex], spawnInformationRow)
			table.insert(creationProperties[spawnPositionsIndex], spawnInformationColumn)
			table.insert(creationProperties[spawnPositionsIndex], tileAmount)
			table.insert(creationProperties[spawnPositionsIndex], tileRatio)
			table.insert(creationProperties[spawnPositionsIndex], baseRadius)
			table.insert(creationProperties[spawnPositionsIndex], baseRatio)
			table.insert(creationProperties[spawnPositionsIndex], avoidanceDistance)
			table.insert(creationProperties[spawnPositionsIndex], edgeAvoidance)
			table.insert(creationProperties[spawnPositionsIndex], borderRadius)
			table.insert(creationProperties[spawnPositionsIndex], centreAvoidance)
			table.insert(creationProperties[spawnPositionsIndex], clumpingFactor)
		end
		
		-- Creating all player areas simultaneously.
		CreateSimultaneousLand(creationProperties)
	end

	-- Placing player forests, if players are present.
	if (isZeroPlayerGame ~= true) then
		for spawnPositionsIndex, spawnInformation in ipairs(spawnPositions) do
			local spawnInformationRow, spawnInformationColumn = table.unpack(spawnInformation)
			
			local sourceRow = spawnInformationRow
			local sourceColumn = spawnInformationColumn
			local sourceTerrain = baseTerrain
			local locateNumber = 2
			local separationDistance = 3
			local minimumDistance = 3
			local maximumDistance = 8
			local avoidanceDistance = 0
			local edgeAvoidance = 1
			local searchMethod = false
			local returnTable = LocateClosest(sourceRow, sourceColumn, sourceTerrain, locateNumber, separationDistance, minimumDistance, maximumDistance, avoidanceDistance, edgeAvoidance, searchMethod)
			
			local tableName = returnTable
			local terrainTable = tt_forest_natural_tiny
			GenerateTerrainsFromTable(tableName, terrainTable)
		end
	end

	-- Grabs all the tiles outside of the middle area.
	local baseZone = {}
	for theRow = 1, mapScope do
		for theColumn = 1, mapScope do
			if (ReviewTerrain(theRow, theColumn, baseTerrain) == true) then
				local theInformation = {}
				local theInformation = {theRow, theColumn}
				table.insert(baseZone, theInformation)
			end
		end
	end

	-- Defining the small forests clumps for the outside area and saving them in a table.
	local theTable = baseZone
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = middleTerrain
	local locateNumber = 10
	local distributionType = "relative"
	local separationDistance = 4
	local avoidanceDistance = 2
	local minimumDistance = 1
	local edgeAvoidance = 1
	local outsideForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	
	-- Generating the actual small forests on the outside area.
	local tableName = outsideForestTable
	local terrainTable = outsideForest
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral gold clumps for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{middleTerrain, 2}
	}
	local locateNumber = 0.5
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual gold deposits on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_atacama_gold_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral stone clumps for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{middleTerrain, 2},
		{tt_atacama_gold_neutral, 2}
	}
	local locateNumber = 0.5
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual stone deposits on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_atacama_stone_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral forage bush clusters for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{middleTerrain, 2},
		{tt_atacama_gold_neutral, 1},
		{tt_atacama_stone_neutral, 1}
	}
	local locateNumber = 0.5
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual forage bush clusters on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_atacama_forage_bush_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral herdable clumps for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{middleTerrain, 2}
	}
	local locateNumber = 0.5
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual herdable on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_atacama_herdable_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral huntable herds for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{middleTerrain, 2}
	}
	local locateNumber = 0.5
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual huntable herds on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_atacama_huntable_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining the oasis clumps for the outside area and saving them in a table.
	local theTable = baseZone
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{middleTerrain, 2},
		{tt_atacama_gold_neutral, 2},
		{tt_atacama_stone_neutral, 2},
		{tt_atacama_forage_bush_neutral, 2},
		{tt_atacama_herdable_neutral, 1},
		{tt_atacama_huntable_neutral, 1}
	}
	local locateNumber = 0.35
	local distributionType = "relative"
	local separationDistance = 14
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local oasisTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	
	-- Generating the actual oasis on the outside area.
	local tableName = oasisTable
	local terrainTable = oasisTerrain
	GenerateTerrainsFromTable(tableName, terrainTable)


	-- Defining clumps for varied map elevation.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = middleTerrain
	local locateNumber = 15
	local distributionType = "relative"
	local separationDistance = 4
	local avoidanceDistance = 1
	local minimumDistance = 2
	local edgeAvoidance = 1
	local theTable = baseZone
	local elevationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual elevation on the map.
	local tableName = elevationTable
	local terrainTable = {
	    {baseVariationOne, 1},
	    {baseVariationTwo, 2},
	    {baseVariationThree, 3}
	}
	GenerateTerrainsFromTable(tableName, terrainTable)


	local settleTile = Round(RandomBetween(10,(mapScope - 10)))
	terrainGrid[settleTile][1].terrainType = tt_atacama_settlement

	local settleTile = Round(RandomBetween((mapScope - 10),10))
	terrainGrid[settleTile][mapScope].terrainType = tt_atacama_settlement



	print("End of Script - " .. mapName .. ".") 
	