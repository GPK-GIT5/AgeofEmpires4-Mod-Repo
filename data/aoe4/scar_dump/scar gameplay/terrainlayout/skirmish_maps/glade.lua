-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "Glade"

-- Defining terrains for the map.
originTerrain = tt_glade_player_start
spawnTerrain = tt_flatland

baseTerrain = tt_forest_natural_small
baseStealth = tt_stealth_natural_small

middleTerrain = tt_plains
middleVariationOne = tt_valley
middleVariationTwo = tt_hills_low_rolling
middleVariationThree = tt_hills_med_rolling
middleForest = tt_forest_natural_grove

divineTerrain = tt_glade_holy_site
tradeTerrain = tt_glade_settlement

-- adjusting to high player count game
if(isLargeMap == true  or isHugeMap == true) then
	baseTerrain = tt_impasse_trees_plains_forest
	middleForest = tt_forest_natural_grove_large
elseif (isMediumMap == true) then
	middleForest = tt_forest_natural_grove_large
end
-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 27
minimumMapScope = 20
maximumMapScope = 200
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------

	print("Start of Script - " .. mapName .. ".")

	-- Running the player setup and placement, unless there's no players present.
	if (isZeroPlayerGame ~= true) then
		if (isTinyMap == true) then
			ringRadius = 64
			positionVariance = 0
		elseif (isSmallMap == true) then
			ringRadius = 66
			positionVariance = 1
		elseif (isMediumMap == true) then
			ringRadius = 68
			positionVariance = 1
		elseif (isLargeMap == true) then
			ringRadius = 72
			positionVariance = 1
		elseif (isHugeMap == true) then
			ringRadius = 74
			positionVariance = 1
		end
	
		local positionVariance = 0
		local rotationSetting = true
		local mirrorGeneration = false
		PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)
	
		-- Defining the size and shape of the player areas.
		local tileAmount = 4
		local tileRatio = false
		local baseRadius = 4
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

	-- Creating the large central forest clearing in the centre of the map.
	local terrainType = middleTerrain
	local originRow = mapCentre
	local originColumn = mapCentre
	
	if (isTinyMap == true) then
		tileAmount = 100
		baseRadius = 50
	elseif (isSmallMap == true) then
		if (isOnePlayerGame == true) or (isTwoPlayerGame == true) then
			tileAmount = 60
			baseRadius = 58
		elseif (isThreePlayerGame == true) then
			tileAmount = 85
			baseRadius = 55
		else
			tileAmount = 100
			baseRadius = 50
		end
	elseif (isMediumMap == true) then
		if (isOnePlayerGame == true) or (isTwoPlayerGame == true) then
			tileAmount = 120
			baseRadius = 60
		elseif (isThreePlayerGame == true) then
			tileAmount = 100
			baseRadius = 62
		elseif (isFourPlayerGame == true) then
			tileAmount = 85
			baseRadius = 62
		elseif (isFivePlayerGame == true) then
			tileAmount = 60
			baseRadius = 66
		else
			tileAmount = 20
			baseRadius = 70
		end
	elseif (isLargeMap == true) then
		if (isOnePlayerGame == true) or (isTwoPlayerGame == true) then
			tileAmount = 140
			baseRadius = 64
		elseif (isThreePlayerGame == true) then
			tileAmount = 120
			baseRadius = 66
		elseif (isFourPlayerGame == true) then
			tileAmount = 100
			baseRadius = 68
		elseif (isFivePlayerGame == true) then
			tileAmount = 80
			baseRadius = 70
		elseif (isSixPlayerGame == true) then
			tileAmount = 80
			baseRadius = 72
		elseif (isSevenPlayerGame == true) then
			tileAmount = 20
			baseRadius = 73
		else
			tileAmount = 20
			baseRadius = 76
		end
	elseif (isHugeMap == true) then
		if (isOnePlayerGame == true) or (isTwoPlayerGame == true) then
			tileAmount = 140
			baseRadius = 66
		elseif (isThreePlayerGame == true) then
			tileAmount = 120
			baseRadius = 68
		elseif (isFourPlayerGame == true) then
			tileAmount = 100
			baseRadius = 70
		elseif (isFivePlayerGame == true) then
			tileAmount = 80
			baseRadius = 72
		elseif (isSixPlayerGame == true) then
			tileAmount = 80
			baseRadius = 74
		elseif (isSevenPlayerGame == true) then
			tileAmount = 20
			baseRadius = 75
		else
			tileAmount = 20
			baseRadius = 78
		end
	end
	
	local tileRatio = true
	local baseRatio = true
	local avoidanceDistance = 1
	local edgeAvoidance = 2
	CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

	-- Creating slopes from the spawns to the middle plateau.
	for spawnPositionsIndex, coordinates in ipairs(spawnPositions) do
		local spawnPositionRow, spawnPositionColumn = table.unpack(coordinates)
		local startingRow = spawnPositionRow
		local startingColumn = spawnPositionColumn
		local endingRow = mapCentre
		local endingColumn = mapCentre
		local connectionTerrain = middleTerrain
		local tableOutput = true
		local connectionTable = CreateStraightConnection(startingRow, startingColumn, endingRow, endingColumn, connectionTerrain, tableOutput)
	
		for connectionTableIndex, tileInformation in ipairs(connectionTable) do
			local connectionTableRow, connectionTableColumn = table.unpack(tileInformation)
			
			local tileProximity = ReturnProximity(connectionTableRow, connectionTableColumn, 1, "square")
			for tileProximityIndex, tileInformation in ipairs(tileProximity) do
				local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
				
				terrainGrid[tileProximityRow][tileProximityColumn].terrainType = middleTerrain
			end
		end
	end

	-- Placing origin terrains to ensure proper player resource generation.
	for spawnPositionsIndex, spawnInformation in ipairs(spawnPositions) do
		local spawnInformationRow, spawnInformationColumn = table.unpack(spawnInformation)
		
		terrainGrid[spawnInformationRow][spawnInformationColumn].terrainType = originTerrain
	end

	-- Setting neutral zoning origin, in this case, the central area.
	SetZoneOrigin(mapCentre, mapCentre)
	
	-- Executing the zoning with the variables below.
	local avoidanceTable = {spawnTerrain, baseTerrain}
	local zoneDistance = 0
	local maximumDeviation = 5
	local otherZones = DefineOtherZones(avoidanceTable, zoneDistance, maximumDeviation)

	-- Defining the small forests clumps for the outside area and saving them in a table.
	local theTable = otherZones[1]
	local acceptanceTerrain = middleTerrain
	local avoidanceTerrain = {spawnTerrain, baseTerrain}
	local locateNumber = 4
	local distributionType = "relative"
	local separationDistance = 4
	local avoidanceDistance = 2
	local minimumDistance = 6
	local edgeAvoidance = 1
	local outsideForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	
	-- Generating the actual small forests on the outside area.
	local tableName = outsideForestTable
	local terrainTable = middleForest
	
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral gold clumps for the neutral outside area of the map.
	local acceptanceTerrain = middleTerrain
	local avoidanceTerrain = {
		{baseTerrain, 2}
	}
	local locateNumber = 1.5
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = otherZones[1]
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual gold deposits on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_glade_gold_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral stone clumps for the neutral outside area of the map.
	local acceptanceTerrain = middleTerrain
	local avoidanceTerrain = {
		{baseTerrain, 2},
		{tt_glade_gold_neutral, 2}
	}
	local locateNumber = 1.5
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = otherZones[1]
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual stone deposits on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_glade_stone_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral forage bush clusters for the neutral outside area of the map.
	local acceptanceTerrain = middleTerrain
	local avoidanceTerrain = {
		{baseTerrain, 2},
		{tt_glade_gold_neutral, 1},
		{tt_glade_stone_neutral, 1}
	}
	local locateNumber = 1
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = otherZones[1]
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual forage bush clusters on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_glade_forage_bush_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral herdable clumps for the neutral outside area of the map.
	local acceptanceTerrain = middleTerrain
	local avoidanceTerrain = {
		{baseTerrain, 2}
	}
	local locateNumber = 1
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = otherZones[1]
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual herdable on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_glade_herdable_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral huntable herds for the neutral outside area of the map.
	local acceptanceTerrain = middleTerrain
	local avoidanceTerrain = {
		{baseTerrain, 2}
	}
	local locateNumber = 1
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = otherZones[1]
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual huntable herds on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_glade_huntable_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining clumps for varied map elevation.
	local acceptanceTerrain = middleTerrain
	local avoidanceTerrain = baseTerrain
	local locateNumber = 8
	local distributionType = "relative"
	local separationDistance = 4
	local avoidanceDistance = 1
	local minimumDistance = 2
	local edgeAvoidance = 1
	local theTable = otherZones[1]
	local elevationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual elevation on the map.
	local tableName = elevationTable
	local terrainTable = {
	    {middleVariationOne, 1},
	    {middleVariationTwo, 1},
	    {middleVariationThree, 1}
	}
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Saving all base forest tiles into one table.
	local outsideZone = {}
	for theRow = 1, mapScope do
		for theColumn = 1, mapScope do
			if (ReviewTerrain(theRow, theColumn, baseTerrain) == true) then
				local theInformation = {}
				local theInformation = {theRow, theColumn}
				table.insert(outsideZone, theInformation)
			end
		end
	end

	-- Defining the small forests clumps for the outside area and saving them in a table.
	local theTable = outsideZone
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {middleTerrain, spawnTerrain}
	local locateNumber = 60
	local distributionType = "relative"
	local separationDistance = 4
	local avoidanceDistance = 2
	local minimumDistance = 6
	local edgeAvoidance = 0
	local outsideForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	
	-- Generating the actual small forests on the outside area.
	local tableName = outsideForestTable
	local terrainTable = baseStealth
	GenerateTerrainsFromTable(tableName, terrainTable)

	print("End of Script - " .. mapName .. ".")