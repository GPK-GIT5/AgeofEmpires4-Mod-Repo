-- Copyright 2024 SEGA Corporation, Developed by Relic Entertainment

mapName = "Highwoods"

-- Defining terrains for the map.
originTerrain = tt_forest_mountain_player_start
spawnTerrain = tt_plains_clearing

tinyForest = tt_forest_natural_tiny
middleTerrain = tt_hills_med_rolling
clearTerrain = tt_hills_low_rolling

baseTerrain = tt_plains
baseForest = tt_forest_natural_tiny

baseVariationOne = tt_hills_gentle_rolling
baseVariationTwo = tt_hills_low_rolling
baseVariationThree = tt_hills_med_rolling

holyTerrain = tt_savannah_island
tradeTerrain = tt_savannah_settlement

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 24
minimumMapScope = 20
maximumMapScope = 512
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------

print("Start of Script - " .. mapName .. ".")

-- Creating a hill in the middle of the map.
local terrainType = clearTerrain
local originRow = mapCentre
local originColumn = mapCentre
local tileAmount = 4
local baseRadius = 4
local tileRatio = true
local baseRatio = true
local avoidanceDistance = 3
local edgeAvoidance = ScaleByMapSize(3, true, true)
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

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

	local tileAmount = 20
	local tileRatio = false
	local baseRadius = 4
	local baseRatio = false
	local avoidanceDistance = 3
	local edgeAvoidance = 1
	local borderRadius = 0
	local centreAvoidance = 0
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
	
	CreateSimultaneousLand(creationProperties)
end

if (isZeroPlayerGame ~= true) then
	-- Defining player zones.
	local avoidanceTable = {baseTerrain, tinyForest, middleTerrain}
	local zoneDistance = 1
	local maximumDeviation = 256
	spawnZones = DefineSpawnZones(avoidanceTable, zoneDistance, maximumDeviation)

	-- Defining medium forest clumps for each zone.
	local acceptanceTerrain = spawnTerrain
	local avoidanceTerrain = {baseTerrain, tinyForest, middleTerrain}
	local locateNumber = 3
	local distributionType = "fixed"
	local separationDistance = 4
	local avoidanceDistance = 1
	local minimumDistance = 3
	local edgeAvoidance = 1

	for tableIndex = 1, #spawnZones do
		local theTable = spawnZones[tableIndex]
		local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

		-- Generating the actual forests on the clumps.
		local tableName = forestTable
		local terrainTable = tt_forest_natural_small

		GenerateTerrainsFromTable(tableName, terrainTable)
	end
end

-- Randomising the placement of settlements and holy sites.
if (worldGetRandom() > 0.5) then
	changeLocation = true
end

-- Placing holy sites in opposite corners.
theRow = ScaleByMapSize(2, false, true)

if (changeLocation == true) then
	theColumn = ScaleByMapSize(2, false, true)
else
	theColumn = OppositeNumber(ScaleByMapSize(2, false, true))
end

terrainGrid[theRow][theColumn].terrainType = holyTerrain

oppositeRow = OppositeNumber(theRow)
oppositeColumn = OppositeNumber(theColumn)
terrainGrid[oppositeRow][oppositeColumn].terrainType = holyTerrain

-- Placing settlements in opposite corners.
theRow = ScaleByMapSize(2, false, true)

if (changeLocation == true) then
	theColumn = OppositeNumber(ScaleByMapSize(2, false, true))
else
	theColumn = ScaleByMapSize(2, false, true)
end

terrainGrid[theRow][theColumn].terrainType = tradeTerrain

oppositeRow = OppositeNumber(theRow)
oppositeColumn = OppositeNumber(theColumn)
terrainGrid[oppositeRow][oppositeColumn].terrainType = tradeTerrain

-- Zoning all untouched base land.
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

-- Zoning all untouched base land.
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



-- Defining extra dense small forest clumps for the base zone.
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = {spawnTerrain, tinyForest, middleTerrain}
local locateNumber = 14
local distributionType = "relative"
local separationDistance = 8
local avoidanceDistance = 1
local minimumDistance = 1
local edgeAvoidance = 1
local theTable = baseZone
local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual forests on the clumps.
local tableName = forestTable
local terrainTable = tt_forest_natural_tiny
GenerateTerrainsFromTable(tableName, terrainTable)


-- Defining extra dense forest clumps for the base zone.
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = {spawnTerrain, tinyForest, middleTerrain}
local locateNumber = 6
local distributionType = "relative"
local separationDistance = 8
local avoidanceDistance = 1
local minimumDistance = 1
local edgeAvoidance = 1
local theTable = baseZone
local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual forests on the clumps.
local tableName = forestTable
local terrainTable = tt_forest_natural_tiny
GenerateTerrainsFromTable(tableName, terrainTable)

-- Generating a holy site in the middle of the swamp.
terrainLayoutResult[mapCentre][mapCentre].terrainType = tt_forest_mountain_peak

-- Defining relic clumps for the base zone.
local acceptanceTerrain = tt_savannah_forest
local avoidanceTerrain = {spawnTerrain}
local locateNumber = 20
local distributionType = "relative"
local separationDistance = 2
local avoidanceDistance = 0
local minimumDistance = 6
local edgeAvoidance = 1
local theTable = baseZone
local elevationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)









-- Defining neutral gold clumps for the base zone.
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = spawnTerrain
local locateNumber = 2
local distributionType = "player"
local separationDistance = 12
local avoidanceDistance = 2
local minimumDistance = 8
local edgeAvoidance = 4
local theTable = baseZone
local goldTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual gold deposits on the clumps.
local tableName = goldTable
local terrainTable = tt_forest_mountain_gold
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining neutral stone clumps for the base zone.
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = spawnTerrain
local locateNumber = 2
local distributionType = "player"
local separationDistance = 12
local avoidanceDistance = 2
local minimumDistance = 8
local edgeAvoidance = 4
local theTable = baseZone
local stoneTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual stone deposits on the clumps.
local tableName = stoneTable
local terrainTable = tt_forest_mountain_stone
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining neutral chonker clumps for the base zone.
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = spawnTerrain
local locateNumber = 1
local distributionType = "player"
local separationDistance = 16
local avoidanceDistance = 2
local minimumDistance = 6
local edgeAvoidance = 1
local theTable = baseZone
local chonkerTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual chonkers on the clumps.
local tableName = chonkerTable
local terrainTable = tt_forest_mountain_hostile_hunt
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining neutral herdable clumps for the base zone.
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = spawnTerrain
local locateNumber = 2
local distributionType = "player"
local separationDistance = 10
local avoidanceDistance = 2
local minimumDistance = 6
local edgeAvoidance = 1
local theTable = baseZone
local herdableTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual herdable on the clumps.
local tableName = herdableTable
local terrainTable = tt_forest_mountain_herdable
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining neutral ungulate clumps for the base zone.
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = spawnTerrain
local locateNumber = 2
local distributionType = "player"
local separationDistance = 10
local avoidanceDistance = 2
local minimumDistance = 6
local edgeAvoidance = 1
local theTable = baseZone
local ungulateTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual ungulate on the clumps.
local tableName = ungulateTable
local terrainTable = tt_forest_mountain_hunt
GenerateTerrainsFromTable(tableName, terrainTable)





-- Defining stealth forest clumps for the base zone.
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = nil
local locateNumber = 8
local distributionType = "relative"
local separationDistance = 2
local avoidanceDistance = 1
local minimumDistance = 1
local edgeAvoidance = 0
local theTable = baseZone
local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual stealth forests on the clumps.
local tableName = forestTable
local terrainTable = tt_savannah_forest
GenerateTerrainsFromTable(tableName, terrainTable)

-- Generating the actual relics on the clumps.
local tableName = elevationTable
local terrainTable = {
	{tt_plains, 6},
	{baseVariationOne, 3},
	{baseVariationTwo, 2},
	{baseVariationThree, 1}
}
GenerateTerrainsFromTable(tableName, terrainTable)

print("End of Script - " .. mapName .. ".")