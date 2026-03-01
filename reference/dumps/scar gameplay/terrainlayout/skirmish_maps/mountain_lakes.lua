-- Developed by Forgotten Empires 2024

mapName = "Mountain Lakes"

-- Defining terrains for the map.
originTerrain = tt_mountain_lakes_player_start
spawnTerrain = tt_plains_smooth

baseTerrain = tt_plains
baseElevation = tt_hills_low_rolling
baseForest = tt_forest_natural_medium

middleForage = tt_mountain_lakes_forage_bush_neutral
middleGold = tt_mountain_lakes_gold_neutral
middleStone = tt_mountain_lakes_stone_neutral
middleResources = tt_mountain_lakes_resources_neutral

mountainTerrain = tt_mountains
lakeTerrain = tt_lake_shallow
boulderTerrain = tt_plateau_low

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 25
minimumMapScope = 20
maximumMapScope = 100
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------
	
	print("Start of Script - " .. mapName .. ".")

	if (isZeroPlayerGame ~= true) then

		if (isTinyMap == true) then
			ringRadius = 70
			positionVariance = 0
		elseif (isSmallMap == true) then
			ringRadius = 71
			positionVariance = 0
		elseif (isMediumMap == true) then
			ringRadius = 72
			positionVariance = 1
		elseif (isLargeMap == true) then
			ringRadius = 73
			positionVariance = 2
		elseif (isHugeMap == true) then
			ringRadius = 75
			positionVariance = 3
		end

		local rotationSetting = true
		local mirrorGeneration = false
		PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)

		local tileAmount = 4
		local tileRatio = false
		local baseRadius = 1
		local baseRatio = false
		local avoidanceDistance = 4
		local edgeAvoidance = 1
		local borderRadius = 0
		local centreAvoidance = 35
		local clumpingFactor = 100

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
		
		CreateSimultaneousLand(creationProperties)
	end

	-- Grabs all the base tiles.
	local baseZone = {}
	for theRow = 1, mapScope do
		for theColumn = 1, mapScope do
			if (ReviewTerrain(theRow, theColumn, baseTerrain) == true) then
				local theInformation = {theRow, theColumn}
				table.insert(baseZone, theInformation)
			end
		end
	end

	-- Defining clumps for lakes.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = mountainTerrain
	local locateNumber = 0.5
	local distributionType = "relative"
	local separationDistance = 14
	local avoidanceDistance = 3
	local minimumDistance = 3
	local edgeAvoidance = 3
	local theTable = baseZone
	local randomClumps = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

	local tileAmount = 6
	local tileRatio = false
	local baseRadius = 1
	local baseRatio = false
	local avoidanceDistance = 3
	local edgeAvoidance = 1
	local borderRadius = 0
	local centreAvoidance = 0
	local clumpingFactor = 0
	local creationProperties = {}

	if (#randomClumps > 0) then
		for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
			local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)

			local noInformation = {}
			table.insert(creationProperties, noInformation)

			table.insert(creationProperties[randomClumpsIndex], lakeTerrain)
			table.insert(creationProperties[randomClumpsIndex], randomClumpsRow)
			table.insert(creationProperties[randomClumpsIndex], randomClumpsColumn)
			table.insert(creationProperties[randomClumpsIndex], tileAmount)
			table.insert(creationProperties[randomClumpsIndex], tileRatio)
			table.insert(creationProperties[randomClumpsIndex], baseRadius)
			table.insert(creationProperties[randomClumpsIndex], baseRatio)
			table.insert(creationProperties[randomClumpsIndex], avoidanceDistance)
			table.insert(creationProperties[randomClumpsIndex], edgeAvoidance)
			table.insert(creationProperties[randomClumpsIndex], borderRadius)
			table.insert(creationProperties[randomClumpsIndex], centreAvoidance)
			table.insert(creationProperties[randomClumpsIndex], clumpingFactor)
		end

		CreateSimultaneousLand(creationProperties)
		
	end

	-- Grabs all the base tiles.
	local mountainArea = {}
	for theRow = 1, mapScope do
		for theColumn = 1, mapScope do
			if (ReviewTerrain(theRow, theColumn, baseTerrain) == true) then
				local theInformation = {theRow, theColumn}
				table.insert(mountainArea, theInformation)
			end
		end
	end


	-- Defining clumps for mountains.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = lakeTerrain
	local locateNumber = 0.5
	local distributionType = "relative"
	local separationDistance = 12
	local avoidanceDistance = 2
	local minimumDistance = 3
	local edgeAvoidance = 3
	local theTable = mountainArea
	local randomClumps = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

	local tileAmount = 6
	local tileRatio = false
	local baseRadius = 1
	local baseRatio = false
	local avoidanceDistance = 3
	local edgeAvoidance = 1
	local borderRadius = 0
	local centreAvoidance = 0
	local clumpingFactor = 0
	local creationProperties = {}

	if (#randomClumps > 0) then
		for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
			local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
			
			local noInformation = {}
			table.insert(creationProperties, noInformation)
		
			table.insert(creationProperties[randomClumpsIndex], mountainTerrain)
			table.insert(creationProperties[randomClumpsIndex], randomClumpsRow)
			table.insert(creationProperties[randomClumpsIndex], randomClumpsColumn)
			table.insert(creationProperties[randomClumpsIndex], tileAmount)
			table.insert(creationProperties[randomClumpsIndex], tileRatio)
			table.insert(creationProperties[randomClumpsIndex], baseRadius)
			table.insert(creationProperties[randomClumpsIndex], baseRatio)
			table.insert(creationProperties[randomClumpsIndex], avoidanceDistance)
			table.insert(creationProperties[randomClumpsIndex], edgeAvoidance)
			table.insert(creationProperties[randomClumpsIndex], borderRadius)
			table.insert(creationProperties[randomClumpsIndex], centreAvoidance)
			table.insert(creationProperties[randomClumpsIndex], clumpingFactor)
		end
		
		CreateSimultaneousLand(creationProperties)
	end



	-- Defining clumps for small forests to generate.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = lakeTerrain
	local locateNumber = 6
	local distributionType = "relative"
	local separationDistance = 8
	local avoidanceDistance = 1
	local minimumDistance = 3
	local edgeAvoidance = 0
	local theTable = baseZone
	local clumpTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual forests on the map.
	local tableName = clumpTable
	local terrainTable = tt_forest_natural_small
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Defining clumps for medium forests to generate.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = lakeTerrain
	local locateNumber = 0.6
	local distributionType = "relative"
	local separationDistance = 14
	local avoidanceDistance = 2
	local minimumDistance = 4
	local edgeAvoidance = 0
	local theTable = baseZone
	local clumpTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual forests on the map.
	local tableName = clumpTable
	local terrainTable = tt_forest_natural_medium
	GenerateTerrainsFromTable(tableName, terrainTable)

	-- Creates small boulders across the map.
	local sourceTerrain = baseTerrain
	local creationChance = 20
	local violationConstraint = 100
	local separationDistance = 5
	local avoidanceDistance = 0
	local minimumDistance = 2
	local edgeAvoidance = 1
	local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

	if (#randomClumps > 0) then
		for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
			local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
			
			terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = boulderTerrain
		end
	end

	-- Creates more boulders on the map.
	local sourceTerrain = baseTerrain
	local creationChance = 10
	local violationConstraint = 100
	local separationDistance = 3
	local avoidanceDistance = 1
	local minimumDistance = 2
	local edgeAvoidance = 1
	local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

	if (#randomClumps > 0) then
		for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
			local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
			
			terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = boulderTerrain
		end
	end

	-- Creates elevation on the map to connect with mountains and boulders.
	local sourceTerrain = baseTerrain
	local creationChance = 15
	local violationConstraint = 100
	local separationDistance = 0
	local avoidanceDistance = 1
	local minimumDistance = 1
	local edgeAvoidance = 1
	local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

	if (#randomClumps > 0) then
		for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
			local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
			
			terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = baseElevation
		end
	end

	-- Defining clumps for small forests to generate.
	local acceptanceTerrain = lakeTerrain
	local avoidanceTerrain = baseTerrain
	local locateNumber = 0.5
	local distributionType = "relative"
	local separationDistance = 10
	local avoidanceDistance = 1
	local minimumDistance = 0
	local edgeAvoidance = 0
	local theTable = baseZone
	local clumpTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	
	-- Generating the actual forests on the map.
	local tableName = clumpTable
	local terrainTable = tt_waterholes_aquatic
	GenerateTerrainsFromTable(tableName, terrainTable)

