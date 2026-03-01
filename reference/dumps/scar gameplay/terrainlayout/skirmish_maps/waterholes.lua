-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "Waterholes"

-- Defining terrains for the map.
originTerrain = tt_waterholes_player_start
spawnTerrain = nil

baseForest = tt_forest_natural_small
baseTerrain = tt_plains
baseVariationOne = tt_hills_gentle_rolling
baseVariationTwo = tt_hills_low_rolling
baseVariationThree = tt_flatland

waterTerrain = tt_waterholes_lake
aquaticTerrain = tt_waterholes_aquatic

holyTerrain = tt_waterholes_holy_site
tradeTerrain = tt_waterholes_settlement

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 21
minimumMapScope = 20
maximumMapScope = 80
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------

print("Start of Script - " .. mapName .. ".")

-- Placing a holy site in the centre of the map.
terrainGrid[mapCentre][mapCentre].terrainType = holyTerrain

-- Creating player positions and placing players on the map.
if (isZeroPlayerGame ~= true) then
	ringRadius = 68
	positionVariance = 0
	rotationSetting = true
	mirrorGeneration = true
	PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)

	-- Placing one lake per player.
	if (isTinyMap == true) then
		betweenPositions = BetweenPlayerGeneration(60, 1)
	else
		betweenPositions = BetweenPlayerGeneration(65, 1)
	end

	for betweenPositionsIndex, tileInformation in ipairs(betweenPositions) do
		betweenPositionsRow, betweenPositionsColumn = table.unpack(tileInformation)
		
		terrainType = waterTerrain
		originRow = betweenPositionsRow
		originColumn = betweenPositionsColumn
		
		if (isSmallMap == true) and (isFourPlayerGame == true) then
			tileAmount = 6
		else
			tileAmount = 8
		end

		tileRatio = false
		baseRadius = 1
		baseRatio = false
		avoidanceDistance = 3
		edgeAvoidance = 2
		CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)
	end

	-- Creating swim swims!
	for betweenPositionsIndex, tileInformation in ipairs(betweenPositions) do
		betweenPositionsRow, betweenPositionsColumn = table.unpack(tileInformation)
		
		terrainGrid[betweenPositionsRow][betweenPositionsColumn].terrainType = aquaticTerrain
	end
end

-- Randomising the placement of settlements and holy sites.
if (worldGetRandom() > 0.5) then
	changeLocation = true
end

-- Placing holy sites in opposite corners.
theRow = ScaleByMapSize(1, false, true)

if (changeLocation == true) then
	theColumn = ScaleByMapSize(1, false, true)
else
	theColumn = OppositeNumber(ScaleByMapSize(1, false, true))
end

terrainGrid[theRow][theColumn].terrainType = holyTerrain

oppositeRow = OppositeNumber(theRow)
oppositeColumn = OppositeNumber(theColumn)
terrainGrid[oppositeRow][oppositeColumn].terrainType = holyTerrain

-- Placing settlements in opposite corners.
theRow = ScaleByMapSize(1, false, true)

if (changeLocation == true) then
	theColumn = OppositeNumber(ScaleByMapSize(1, false, true))
else
	theColumn = ScaleByMapSize(1, false, true)
end

terrainGrid[theRow][theColumn].terrainType = tradeTerrain

oppositeRow = OppositeNumber(theRow)
oppositeColumn = OppositeNumber(theColumn)
terrainGrid[oppositeRow][oppositeColumn].terrainType = tradeTerrain

if (isZeroPlayerGame ~= true) then
	-- Finding tiles surrounding player starts.
	function ReturnStartProximity()
		returnTable = {}
	
		for spawnPositionsIndex, tileInformation in ipairs(spawnPositions) do
			local spawnPositionsRow, spawnPositionsColumn = table.unpack(tileInformation)
			local temporaryTable = {}
	
			table.insert(temporaryTable, {(spawnPositionsRow - 2), (spawnPositionsColumn - 1)})
			table.insert(temporaryTable, {(spawnPositionsRow - 2), spawnPositionsColumn})
			table.insert(temporaryTable, {(spawnPositionsRow - 2), (spawnPositionsColumn + 1)})
	
			table.insert(temporaryTable, {(spawnPositionsRow - 1), (spawnPositionsColumn - 2)})
			table.insert(temporaryTable, {spawnPositionsRow, (spawnPositionsColumn - 2)})
			table.insert(temporaryTable, {(spawnPositionsRow + 1), (spawnPositionsColumn - 2)})
	
			table.insert(temporaryTable, {(spawnPositionsRow - 1), (spawnPositionsColumn + 2)})
			table.insert(temporaryTable, {spawnPositionsRow, (spawnPositionsColumn + 2)})
			table.insert(temporaryTable, {(spawnPositionsRow + 1), (spawnPositionsColumn + 2)})
	
			table.insert(temporaryTable, {(spawnPositionsRow + 2), (spawnPositionsColumn - 1)})
			table.insert(temporaryTable, {(spawnPositionsRow + 2), spawnPositionsColumn})
			table.insert(temporaryTable, {(spawnPositionsRow + 2), (spawnPositionsColumn + 1)})
			
			table.insert(returnTable, temporaryTable)
		end
	
		return returnTable
	end
	
	forestPositions = ReturnStartProximity()
	
	for forestPositionsIndex, tableInformation in ipairs(forestPositions) do
		local forestPositionsRow, forestPositionsColumn = table.unpack(tableInformation)
		
		-- Defining two safe starting forests for the players.
		local theTable = tableInformation
		local acceptanceTerrain = baseTerrain
		local avoidanceTerrain = waterTerrain
		local locateNumber = 2
		local distributionType = "fixed"
		local separationDistance = 2
		local avoidanceDistance = 1
		local minimumDistance = 0
		local edgeAvoidance = 0
		local spawnForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
		
		-- Generating two safe forests.
		local tableName = spawnForestTable
		local terrainTable = tt_forest_natural_tiny
		GenerateTerrainsFromTable(tableName, terrainTable)
	end
	
	-- Defining player zones.
	local avoidanceTable = {waterTerrain, holyTerrain, tradeTerrain}
	local zoneDistance = 2
	local maximumDeviation = 5
	spawnZones = DefineSpawnZones(avoidanceTable, zoneDistance, maximumDeviation)

	-- Defining forest clumps for each zone.
	local acceptanceTerrain = {baseTerrain}
	local avoidanceTerrain = {waterTerrain}
	local locateNumber = 5
	local distributionType = "relative"
	local separationDistance = 4
	local avoidanceDistance = 2
	local minimumDistance = 3
	local edgeAvoidance = 1
	local forceEquality = EnsureProportionateDistribution(spawnZones)

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local spawnForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

		-- Generating the actual forests on the clumps.
		local tableName = spawnForestTable
		local terrainTable = baseForest
		GenerateTerrainsFromTable(tableName, terrainTable)
	end
end

-- Creates the origin spawn for the neutral resources.
betweenPositions = BetweenPlayerGeneration(90, 1)

for betweenPositionsIndex, tileInformation in ipairs(betweenPositions) do
	betweenPositionsRow, betweenPositionsColumn = table.unpack(tileInformation)
	terrainGrid[betweenPositionsRow][betweenPositionsColumn].terrainType = tt_waterholes_neutral_resources
end

-- Creates terrain variance and elevation across the base terrain.
if (isZeroPlayerGame ~= true) then
	-- Defining forest clumps for each zone.
	local acceptanceTerrain = {baseTerrain}
	local avoidanceTerrain = {waterTerrain}
	local locateNumber = 20
	local distributionType = "relative"
	local separationDistance = 1
	local avoidanceDistance = 2
	local minimumDistance = 1
	local edgeAvoidance = 1

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local elevationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

		-- Generating the actual elevation on the clumps.
		local tableName = elevationTable
		local terrainTable = {
			{baseVariationOne, 2},
			{baseVariationTwo, 4},
			{baseVariationThree, 1}
		}

		GenerateTerrainsFromTable(tableName, terrainTable)
	end
end

print("End of Script - " .. mapName .. ".")