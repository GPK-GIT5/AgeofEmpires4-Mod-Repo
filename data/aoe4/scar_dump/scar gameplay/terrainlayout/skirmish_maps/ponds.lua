-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "Wetlands"

-- Defining terrains for the map.
originTerrain = tt_ponds_player_start
spawnTerrain = tt_plains

lakeTerrain = tt_ponds_lake
lakeForageTerrain = tt_ponds_lake_forage

baseTerrain = tt_plains
baseForestOne = tt_forest_natural_small
baseForestTwo = tt_forest_natural_small
baseForestThree = tt_forest_natural_medium

stealthForestOne = tt_stealth_natural_small
stealthForestTwo = tt_stealth_natural_medium
stealthForestThree = tt_stealth_natural_large

baseVariationOne = tt_hills_gentle_rolling
baseVariationTwo = tt_hills_low_rolling
baseVariationThree = tt_flatland

relicTerrain = tt_ponds_relic
holyTerrain = tt_ponds_holy_site
tradeTerrain = tt_ponds_settlement

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 20
minimumMapScope = 20
maximumMapScope = 512
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------

print("Start of Script - " .. mapName .. ".")

if (isZeroPlayerGame ~= true) then
	if (isTinyMap == true) then
		ringRadius = 64
		positionVariance = 0
	elseif (isSmallMap == true) then
		ringRadius = 65
		positionVariance = 1
	elseif (isMediumMap == true) then
		ringRadius = 67
		positionVariance = 1
	elseif (isLargeMap == true) then
		ringRadius = 70
		positionVariance = 1
	elseif (isHugeMap == true) then
		ringRadius = 72
		positionVariance = 1
	end

	local rotationSetting = true
	local mirrorGeneration = false

	-- Placing players on the map using the parameters above.
	PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)

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
		
		-- Defining two safe starting ponds for the players.
		local theTable = tableInformation
		local acceptanceTerrain = baseTerrain
		local avoidanceTerrain = waterTerrain
		local locateNumber = 2
		local distributionType = "fixed"
		local separationDistance = 1
		local avoidanceDistance = 1
		local minimumDistance = 0
		local edgeAvoidance = 0
		local spawnForestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
		
		-- Generating two safe ponds.
		local tableName = spawnForestTable
		local terrainTable = lakeForageTerrain
		GenerateTerrainsFromTable(tableName, terrainTable)
	end
end

-- Making sure there's room for holy sites and settlements to generate.
clearAsset = ReturnProximity(mapCentre, mapCentre, 1, "square")
local tableName = clearAsset
local terrainTable = tt_plains_smooth
GenerateTerrainsFromTable(tableName, terrainTable)

clearAsset = ReturnProximity(2, 2, 1, "square")
local tableName = clearAsset
local terrainTable = tt_plains_smooth
GenerateTerrainsFromTable(tableName, terrainTable)

clearAsset = ReturnProximity(2, (mapScope - 1), 1, "square")
local tableName = clearAsset
local terrainTable = tt_plains_smooth
GenerateTerrainsFromTable(tableName, terrainTable)

clearAsset = ReturnProximity((mapScope - 1), 2, 1, "square")
local tableName = clearAsset
local terrainTable = tt_plains_smooth
GenerateTerrainsFromTable(tableName, terrainTable)

clearAsset = ReturnProximity((mapScope - 1), (mapScope - 1), 1, "square")
local tableName = clearAsset
local terrainTable = tt_plains_smooth
GenerateTerrainsFromTable(tableName, terrainTable)

-- Creating a central holy site.
terrainGrid[mapCentre][mapCentre].terrainType = holyTerrain

if (isZeroPlayerGame ~= true) then
	-- Defining player zones.
	local avoidanceTable = {lakeTerrain, holyTerrain, tradeTerrain}
	local zoneDistance = 1
	local maximumDeviation = 5
	spawnZones = DefineSpawnZones(avoidanceTable, zoneDistance, maximumDeviation)

	-- Defining large forest clumps for each zone.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {lakeTerrain, holyTerrain, tradeTerrain}
	local locateNumber = 2
	local distributionType = "relative"
	local separationDistance = 6
	local avoidanceDistance = 1
	local minimumDistance = 3
	local edgeAvoidance = 1

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

		-- Generating the actual forests on the clumps.
		local tableName = forestTable
		local terrainTable = baseForestThree

		GenerateTerrainsFromTable(tableName, terrainTable)
	end

	-- Defining medium forest clumps for each zone.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {lakeTerrain, baseForestThree, holyTerrain, tradeTerrain}
	local locateNumber = 2
	local distributionType = "relative"
	local separationDistance = 5
	local avoidanceDistance = 1
	local minimumDistance = 3
	local edgeAvoidance = 1

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

		-- Generating the actual forests on the clumps.
		local tableName = forestTable
		local terrainTable = baseForestTwo

		GenerateTerrainsFromTable(tableName, terrainTable)
	end

	-- Defining small forest clumps for each zone.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {lakeTerrain, baseForestTwo, baseForestThree, holyTerrain, tradeTerrain}
	local locateNumber = 3
	local distributionType = "relative"
	local separationDistance = 4
	local avoidanceDistance = 1
	local minimumDistance = 3
	local edgeAvoidance = 1

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

		-- Generating the actual forests on the clumps.
		local tableName = forestTable
		local terrainTable = baseForestOne

		GenerateTerrainsFromTable(tableName, terrainTable)
	end

	-- Defining extra pond clumps for each zone.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {baseForestOne, baseForestTwo, baseForestThree, holyTerrain, tradeTerrain}
	local locateNumber = 3
	local distributionType = "relative"
	local separationDistance = 3
	local avoidanceDistance = 1
	local minimumDistance = 4
	local edgeAvoidance = 1

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local lakeTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

		-- Generating the actual ponds on the clumps.
		local tableName = lakeTable
		local terrainTable = {
			{lakeTerrain, 1},
			{lakeForageTerrain, 1}
		}

		GenerateTerrainsFromTable(tableName, terrainTable)
	end

	-- Defining stealth forest clumps for each zone.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = {holyTerrain, tradeTerrain}
	local locateNumber = 1
	local distributionType = "relative"
	local separationDistance = 8
	local avoidanceDistance = 1
	local minimumDistance = 6
	local edgeAvoidance = 1

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local stealthTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

		-- Generating the actual stealth forests on the clumps.
		local tableName = stealthTable
		local terrainTable = {
			{stealthForestOne, 1},
			{stealthForestTwo, 1},
			{stealthForestThree, 1}
		}

		GenerateTerrainsFromTable(tableName, terrainTable)
	end
end

-- Sets neutral zone covering the entire map.
SetZoneOrigin(mapCentre, mapCentre)

-- Executes the zoning.
local avoidanceTable = {
	holyTerrain,
	tradeTerrain,
	lakeForageTerrain,
	tt_plains_smooth,
	lakeTerrain
}

local zoneDistance = 0
local maximumDeviation = 100
otherZones = DefineOtherZones(avoidanceTable, zoneDistance, maximumDeviation)

-- Defining relic positions on the map.
local theTable = otherZones[1]
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = {
	baseForestThree,
	baseForestTwo,
	baseForestOne,
	stealthForestThree,
	stealthForestTwo,
	stealthForestOne,
	lakeTerrain,
	lakeForageTerrain,
	holyTerrain,
	tradeTerrain
}

--[[
local locateNumber = 5
local distributionType = "map"
local separationDistance = 10
local avoidanceDistance = 0
local minimumDistance = 6
local edgeAvoidance = 1
local relicTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

-- Generating the relics on the predefined positions.
local tableName = relicTable
local terrainTable = relicTerrain
GenerateTerrainsFromTable(tableName, terrainTable) --]]

if (isZeroPlayerGame ~= true) then
	-- Defining elevation variation clumps for each zone.
	local acceptanceTerrain = baseTerrain
	local avoidanceTerrain = lakeTerrain
	local locateNumber = 8
	local distributionType = "relative"
	local separationDistance = 3
	local avoidanceDistance = 1
	local minimumDistance = 3
	local edgeAvoidance = 1

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local variationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

		-- Generating the elevation variation on the clumps.
		local tableName = variationTable
		local terrainTable = {
			{baseVariationOne, 2},
			{baseVariationTwo, 1},
			{baseVariationThree, 1}
		}

		GenerateTerrainsFromTable(tableName, terrainTable)
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

print("End of Script - " .. mapName .. ".")