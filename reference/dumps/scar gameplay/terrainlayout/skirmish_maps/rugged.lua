-- Developed by Forgotten Empires 2024

mapName = "Rugged"

-- Defining terrains for the map.
originTerrain = tt_rugged_player_start
spawnTerrain = tt_plains_smooth

baseTerrain = tt_plains
middleTerrain = tt_shadow_lake_water

baseVariationOne = tt_hills_gentle_rolling
baseVariationTwo = tt_hills_low_rolling
baseVariationThree = tt_hills_med_rolling

outsideForest = tt_forest_natural_small

holyTerrain = nil
tradeTerrain = nil

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

-- Only running player setup if there are players present.
if (isZeroPlayerGame ~= true) then
	if (isTinyMap == true) then
		ringRadius = 77
		positionVariance = 0
	elseif (isSmallMap == true) then
		ringRadius = 75
		positionVariance = 0
	elseif (isMediumMap == true) then
		ringRadius = 73
		positionVariance = 1
	elseif (isLargeMap == true) then
		ringRadius = 71
		positionVariance = 1
	elseif (isHugeMap == true) then
		ringRadius = 69
		positionVariance = 1
	end

	local rotationSetting = true
	local mirrorGeneration = false

	-- Placing players on the map using the parameters above.
	PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)

	local tileAmount = 15
	local tileRatio = false
	local baseRadius = 5
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
	
	-- Creating the starting lands.
	CreateSimultaneousLand(creationProperties)

	-- Defining player zones.
	local avoidanceTable = {baseTerrain}
	local zoneDistance = 2
	local maximumDeviation = 5
	spawnZones = DefineSpawnZones(avoidanceTable, zoneDistance, maximumDeviation)
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


	-- Defining clumps for various forets to generate.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = middleTerrain
	local locateNumber = 16
	local distributionType = "relative"
	local separationDistance = 8
	local avoidanceDistance = 1
	local minimumDistance = 1
	local edgeAvoidance = 0
	local theTable = baseZone
	local elevationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual forests on the map.
	local tableName = elevationTable
	local terrainTable = {
	    {tt_forest_natural_medium, 1},
	    {tt_forest_natural_small, 2},
	    {tt_forest_natural_tiny, 3},
	    {tt_forest_plateau_low_natural_medium, 1},
	    {tt_forest_plateau_low_natural_small, 2},
	    {tt_forest_plateau_low_natural_tiny, 3},
	    {tt_forest_plateau_medium_natural_medium, 2},
	    {tt_forest_plateau_medium_natural_small, 4},
	    {tt_forest_plateau_medium_natural_tiny, 6}
	}
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining clumps for varied map elevation - creating hills and plateaus.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = middleTerrain
	local locateNumber = 120
	local distributionType = "relative"
	local separationDistance = 1
	local avoidanceDistance = 1
	local minimumDistance = 1
	local edgeAvoidance = 0
	local theTable = baseZone
	local elevationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual elevation on the map.
	local tableName = elevationTable
	local terrainTable = {
	    {tt_plateau_med, 2},
	    {tt_plains, 1},
	    {tt_hills_low_rolling, 1}
	}
	GenerateTerrainsFromTable(tableName, terrainTable)

-- Creates safe forests surrounding the players.
if (isZeroPlayerGame ~= true) then
	local acceptanceTerrain = {spawnTerrain}
	local avoidanceTerrain = {middleTerrain}
	local locateNumber = 4
	local distributionType = "fixed"
	local separationDistance = 4
	local avoidanceDistance = 1
	local minimumDistance = 2
	local edgeAvoidance = 0
	local forceEquality = EnsureProportionateDistribution(spawnZones)

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local spawnForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

		local tableName = spawnForestTable
		local terrainTable = tt_forest_natural_tiny
		print(#tableName)
		GenerateTerrainsFromTable(tableName, terrainTable)
	end
end

print("End of Script - " .. mapName .. ".")