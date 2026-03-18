-- Copyright 2024 SEGA Corporation, Developed by Relic Entertainment

mapName = "Wasteland"


-- Defining terrains for the map.
originTerrain = tt_the_divide_player_start
spawnTerrain = tt_plains

baseTerrain = tt_stealth_natural_tiny
middleTerrain = tt_plains_smooth

outsideForest = tt_forest_natural_small

baseVariationOne = tt_hills_gentle_rolling
baseVariationTwo = tt_hills_low_rolling
baseVariationThree = tt_hills_med_rolling
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
		ringRadius = 77
		positionVariance = 0
	elseif (isMediumMap == true) then
		ringRadius = 78
		positionVariance = 1
	elseif (isLargeMap == true) then
		ringRadius = 79
		positionVariance = 1
	elseif (isHugeMap == true) then
		ringRadius = 81
		positionVariance = 1
	end

	local rotationSetting = true
	local mirrorGeneration = false

	-- Placing players on the map using the parameters above.
	PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)

	local tileAmount = 8
	local tileRatio = false
	local baseRadius = 3
	local baseRatio = false
	local avoidanceDistance = 4
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
	
	-- Creating the starting islands.
	CreateSimultaneousLand(creationProperties)

	-- Defining player zones.
	local avoidanceTable = {baseTerrain}
	local zoneDistance = 2
	local maximumDeviation = 5
	spawnZones = DefineSpawnZones(avoidanceTable, zoneDistance, maximumDeviation)
end

-- Creates safe forests surrounding the players.
if (isZeroPlayerGame ~= true) then
	local acceptanceTerrain = {spawnTerrain}
	local avoidanceTerrain = {baseTerrain}
	local locateNumber = 3
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
		local terrainTable = tt_forest_natural_small
		print(#tableName)
		GenerateTerrainsFromTable(tableName, terrainTable)
	end
end

-- Creates an empty area in the middle of the map.
local terrainType = middleTerrain
local originRow = mapCentre
local originColumn = mapCentre

if (isTinyMap == true) then
	tileAmount = 60
	baseRadius = 35
elseif (isSmallMap == true) then
	tileAmount = 56
	baseRadius = 37
elseif (isMediumMap == true) then
	tileAmount = 68
	baseRadius = 43
elseif (isLargeMap == true) then
	tileAmount = 76
	baseRadius = 47
elseif (isHugeMap == true) then
	tileAmount = 84 
	baseRadius = 51
end

local tileRatio = true
local baseRatio = true
local avoidanceDistance = 1
local edgeAvoidance = ScaleByMapSize(3, true, true)
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

-- Setting up the central zoning origins.
SetZoneOrigin(mapCentre, mapCentre)

-- Zoning the central area.
local avoidanceTable = baseTerrain
local zoneDistance = 2
local maximumDeviation = 5
local otherZones = DefineOtherZones(avoidanceTable, zoneDistance, maximumDeviation)

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

-- Creates an open area on the outside of the map, creating the line is stealth forests around the lake.
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = middleTerrain
local locateNumber = 120
local distributionType = "relative"
local separationDistance = 1
local avoidanceDistance = 1
local minimumDistance = 1
local edgeAvoidance = 0
local theTable = outsideZone
local aquaticTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the terrain clumps.
local tableName = aquaticTable
local terrainTable = tt_hills_gentle_rolling
GenerateTerrainsFromTable(tableName, terrainTable)

-- Creates the forest positions on the outside of the map.
local acceptanceTerrain = tt_hills_gentle_rolling
local avoidanceTerrain = baseTerrain
local locateNumber = 8
local distributionType = "relative"
local separationDistance = 4
local avoidanceDistance = 2
local minimumDistance = 2
local edgeAvoidance = 0
local theTable = outsideZone
local aquaticTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual forest terrain on the clumps.
local tableName = aquaticTable
local terrainTable = tt_forest_natural_small
GenerateTerrainsFromTable(tableName, terrainTable)

-- ----------------------------------------------
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = middleTerrain
local locateNumber = 100
local distributionType = "relative"
local separationDistance = 0
local avoidanceDistance = 3
local minimumDistance = 1
local edgeAvoidance = 0
local theTable = outsideZone
local aquaticTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

local tableName = aquaticTable
local terrainTable = tt_hills_gentle_rolling
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining neutral stone clumps for the middle zone.
local theTable = otherZones[1]
local acceptanceTerrain = middleTerrain
local avoidanceTerrain = baseTerrain
local locateNumber = 4
local distributionType = "relative"
local separationDistance = 14
local avoidanceDistance = 2
local minimumDistance = 1
local edgeAvoidance = 1
local middleStoneTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

-- Generating the actual stone deposits on the clumps.
local tableName = middleStoneTable
local terrainTable = tt_the_divide_stone
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining neutral chonker clumps for the base zone.
local theTable = otherZones[1]
local acceptanceTerrain = middleTerrain
local avoidanceTerrain = baseTerrain
local locateNumber = 2
local distributionType = "relative"
local separationDistance = 14
local avoidanceDistance = 3
local minimumDistance = 1
local edgeAvoidance = 1
local chonkerTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

-- Generating the actual chonkers on the clumps.
local tableName = chonkerTable
local terrainTable = tt_the_divide_hostile_hunt
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining neutral gold clumps for the base zone.
local acceptanceTerrain = tt_hills_gentle_rolling
local avoidanceTerrain = baseTerrain

if (isTwoPlayerGame ~= true) then
	locateNumber = 4
else
	locateNumber = 3
end

local distributionType = "player"
local separationDistance = 12
local avoidanceDistance = 1
local minimumDistance = 5
local edgeAvoidance = 1
local theTable = outsideZone
local goldTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual gold deposits on the clumps.
local tableName = goldTable
local terrainTable = tt_the_divide_gold
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining neutral herdable clumps for the base zone.
local acceptanceTerrain = tt_hills_gentle_rolling
local avoidanceTerrain = baseTerrain
local locateNumber = 2
local distributionType = "player"
local separationDistance = 10
local avoidanceDistance = 1
local minimumDistance = 6
local edgeAvoidance = 1
local theTable = outsideZone
local herdableTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual herdable on the clumps.
local tableName = herdableTable
local terrainTable = tt_shadow_lake_herdable
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining neutral ungulate clumps for the base zone.
local acceptanceTerrain = tt_hills_gentle_rolling
local avoidanceTerrain = baseTerrain
local locateNumber = 4
local distributionType = "player"
local separationDistance = 10
local avoidanceDistance = 1
local minimumDistance = 4
local edgeAvoidance = 1
local theTable = outsideZone
local ungulateTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual ungulate on the clumps.
local tableName = ungulateTable
local terrainTable = tt_the_divide_hunt
GenerateTerrainsFromTable(tableName, terrainTable)

for theRow = 1, mapScope do
	for theColumn = 1, mapScope do
		if (ReviewTerrain(theRow, theColumn, baseTerrain) == true) then
			if (worldGetRandom() > 0.5) then
				terrainLayoutResult[theRow][theColumn].terrainType = middleTerrain
			end
		end
	end
end

-- Defining elevation clumps for the base zone.
local acceptanceTerrain = tt_hills_gentle_rolling
local avoidanceTerrain = baseTerrain
local locateNumber = 10
local distributionType = "relative"
local separationDistance = 2
local avoidanceDistance = 0
local minimumDistance = 3
local edgeAvoidance = 0
local theTable = outsideZone
local elevationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual elevation on the clumps.
local tableName = elevationTable
local terrainTable = {
	{tt_plains, 1},
	{baseVariationOne, 3},
	{baseVariationTwo, 2},
	{baseVariationThree, 1}
}
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining elevation clumps for the base zone.
local acceptanceTerrain = middleTerrain
local avoidanceTerrain = baseTerrain
local locateNumber = 10
local distributionType = "relative"
local separationDistance = 2
local avoidanceDistance = 0
local minimumDistance = 3
local edgeAvoidance = 0
local theTable = otherZones[1]
local elevationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual elevation on the clumps.
local tableName = elevationTable
local terrainTable = {
	{tt_plains, 1},
	{baseVariationOne, 6},
	{baseVariationTwo, 3},
	{baseVariationThree, 1}
}
GenerateTerrainsFromTable(tableName, terrainTable)

local stealthZone = {}
for theRow = 1, mapScope do
	for theColumn = 1, mapScope do
		if (ReviewTerrain(theRow, theColumn, baseTerrain) == true) then
			local theInformation = {}
			local theInformation = {theRow, theColumn}
			table.insert(stealthZone, theInformation)
		end
	end
end

-- Defining elevation clumps for the base zone.
local acceptanceTerrain = baseTerrain
local avoidanceTerrain = spawnTerrain
local locateNumber = 20
local distributionType = "relative"
local separationDistance = 3
local avoidanceDistance = 0
local minimumDistance = 0
local edgeAvoidance = 0
local theTable = stealthZone
local elevationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual elevation on the clumps.
local tableName = elevationTable
local terrainTable = {
	{tt_plains, 1},
	{baseVariationOne, 3},
	{baseVariationTwo, 2},
	{baseVariationThree, 1}
}
GenerateTerrainsFromTable(tableName, terrainTable)

print("End of Script - " .. mapName .. ".")