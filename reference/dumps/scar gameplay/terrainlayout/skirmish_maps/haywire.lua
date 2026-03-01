-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "Haywire"

-- Defining terrains for the map.
originTerrain = tt_haywire_player_start
spawnTerrain = tt_flatland

baseTerrain = tt_plains
baseVariationOne = tt_valley
baseVariationTwo = tt_hills_low_rolling
baseVariationThree = tt_hills_med_rolling

ringTerrain = tt_forest_natural_small
outsideForest = tt_forest_natural_grove


middleTerrain = tt_flatland
middleVariationOne = tt_valley
middleVariationTwo = tt_hills_low_rolling
middleVariationThree = tt_hills_med_rolling
middleForest = tt_forest_natural_grove

divineTerrain = tt_glade_holy_site
tradeTerrain = tt_glade_settlement

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 27
minimumMapScope = 20
maximumMapScope = 100
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------

	print("Start of Script - " .. mapName .. ".")




	-- Creating the large forest in the centre of the map.
	local terrainType = ringTerrain
	local originRow = mapCentre
	local originColumn = mapCentre
	local tileAmount = 16

	if (isTinyMap == true) then
		baseRadius = 50
	elseif (isSmallMap == true) then
		baseRadius = 52
	elseif (isMediumMap == true) then
		baseRadius = 56
	elseif (isLargeMap == true) then
		baseRadius = 60
	elseif (isHugeMap == true) then
		baseRadius = 64
	end

	local tileRatio = true
	local baseRatio = true
	local avoidanceDistance = 1
	local edgeAvoidance = 5
	CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

	-- Setting neutral zoning origin, in this case, the central area.
	SetZoneOrigin(mapCentre, mapCentre)
	
	-- Executing the zoning with the variables below.
	local avoidanceTable = baseTerrain
	local zoneDistance = 0
	local maximumDeviation = 5
	local otherZones = DefineOtherZones(avoidanceTable, zoneDistance, maximumDeviation)
	
	-- Defining the small forests clumps for the outside area and saving them in a table.
	local theTable = otherZones[1]
	local acceptanceTerrain = ringTerrain
	local avoidanceTerrain = baseTerrain
	local locateNumber = 100
	local distributionType = "relative"
	local separationDistance = 0

	if (isTinyMap == true) then
		avoidanceDistance = 1
	elseif (isSmallMap == true) then
		avoidanceDistance = 1
	elseif (isMediumMap == true) then
		avoidanceDistance = 2
	elseif (isLargeMap == true) then
		avoidanceDistance = 2
	elseif (isHugeMap == true) then
		avoidanceDistance = 3
	end

	local minimumDistance = 0
	local edgeAvoidance = 1
	local outsideForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	
	-- Generating the actual small forests on the outside area.
	local tableName = outsideForestTable
	local terrainTable = middleTerrain
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Running the player setup and placement, unless there's no players present.
	if (isZeroPlayerGame ~= true) then
		if (isTinyMap == true) then
			ringRadius = 24
		elseif (isSmallMap == true) then
			ringRadius = 34
		elseif (isMediumMap == true) then
			ringRadius = 38
		elseif (isLargeMap == true) then
			ringRadius = 42
		elseif (isHugeMap == true) then
			ringRadius = 44
		end
	
		local positionVariance = 0
		local rotationSetting = true
		local mirrorGeneration = true
		PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)
	
		betweenPositions = BetweenPlayerGeneration(90, 1)
	
		for spawnPositionsIndex, coordinates in ipairs(spawnPositions) do
			local spawnPositionRow, spawnPositionColumn = table.unpack(coordinates)
			local startingRow = spawnPositionRow
			local startingColumn = spawnPositionColumn
			local endingRow = betweenPositions[spawnPositionsIndex][1]
			local endingColumn = betweenPositions[spawnPositionsIndex][2]
			local connectionTerrain = tt_plains_smooth
			local tableOutput = true
			local connectionTable = CreateStraightConnection(startingRow, startingColumn, endingRow, endingColumn, connectionTerrain, tableOutput)
		
			for connectionTableIndex, tileInformation in ipairs(connectionTable) do
				local connectionTableRow, connectionTableColumn = table.unpack(tileInformation)
				
				local tileProximity = ReturnProximity(connectionTableRow, connectionTableColumn, 2, "circular")
				for tileProximityIndex, tileInformation in ipairs(tileProximity) do
					local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
					
					if (CheckTerrain(tileProximityRow, tileProximityColumn, ringTerrain) == true) then
						terrainGrid[tileProximityRow][tileProximityColumn].terrainType = tt_plains_smooth
					end
				end
			end
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
	local avoidanceTerrain = ringTerrain
	local locateNumber = 2
	local distributionType = "relative"
	local separationDistance = 14
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
		{ringTerrain, 2}
	}
	local locateNumber = 2
	local distributionType = "relative"
	local separationDistance = 8
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual gold deposits on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_haywire_gold_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral stone clumps for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{ringTerrain, 2},
		{tt_haywire_gold_neutral, 2}
	}
	local locateNumber = 2
	local distributionType = "relative"
	local separationDistance = 8
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual stone deposits on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_haywire_stone_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining neutral forage bush clusters for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{ringTerrain, 2},
		{tt_haywire_gold_neutral, 1},
		{tt_haywire_stone_neutral, 1}
	}
	local locateNumber = 1.5
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual forage bush clusters on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_haywire_forage_bush_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)
--[[
	-- Defining relic positions for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{ringTerrain, 1},
		{tt_haywire_gold_neutral, 1},
		{tt_haywire_stone_neutral, 1},
		{tt_haywire_forage_bush_neutral, 1}
	}
	local locateNumber = 0.75
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 4
	local edgeAvoidance = 1
	local theTable = baseZone
	local relicTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

	-- Generating the relics on the neutral outside area.
	local tableName = relicTable
	local terrainTable = tt_haywire_relic
	GenerateTerrainsFromTable(tableName, terrainTable)
--]]
	-- Defining neutral huntable herds for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{ringTerrain, 2}
	}
	local locateNumber = 1.5
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual huntable herds on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_haywire_huntable_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)


	-- Defining neutral huntable herds for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{ringTerrain, 2}
	}
	local locateNumber = 0.75
	local distributionType = "relative"
	local separationDistance = 24
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local resourceTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual huntable herds on the neutral outside area.
	local tableName = resourceTable
	local terrainTable = tt_haywire_hostile_hunt_neutral
	GenerateTerrainsFromTable(tableName, terrainTable)


	-- Defining predator locations for the neutral outside area of the map.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {
		{ringTerrain, 2}
	}
	local locateNumber = 1
	local distributionType = "relative"
	local separationDistance = 16
	local avoidanceDistance = "individual"
	local minimumDistance = 8
	local edgeAvoidance = 1
	local theTable = baseZone
	local predatorTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual predatory animals on the neutral outside area.
	local tableName = predatorTable
	local terrainTable = tt_haywire_predator
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining clumps for varied map elevation.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = ringTerrain
	local locateNumber = 10
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
	    {baseVariationTwo, 1},
	    {baseVariationThree, 1}
	}
	GenerateTerrainsFromTable(tableName, terrainTable)


	-- Defining the small forests clumps for the outside area and saving them in a table.
	local theTable = otherZones[1]
	local acceptanceTerrain = spawnTerrain
	local avoidanceTerrain = ringTerrain
	local locateNumber = 3
	local distributionType = "relative"
	local separationDistance = 6
	local avoidanceDistance = 1
	local minimumDistance = 2
	local edgeAvoidance = 1
	local insideForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	
	-- Generating the actual small forests on the outside area.
	local tableName = insideForestTable
	local terrainTable = tt_forest_natural_tiny
	GenerateTerrainsFromTable(tableName, terrainTable)


	print("End of Script - " .. mapName .. ".") 
