-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "Continental"

-- Defining terrains for the map.
originTerrain = tt_continental_player_start
spawnTerrain = tt_plains
spawnForest = tt_forest_natural_tiny

baseTerrain = tt_continental_water
baseForest = tt_forest_natural_medium
baseForestSmall = tt_forest_natural_small
baseForestVariation = tt_stealth_natural_tiny

baseVariationOne = tt_hills_gentle_rolling
baseVariationTwo = tt_hills_low_rolling
baseVariationThree = tt_hills_med_rolling

middleTerrain = tt_mountains
cornerTerrain = tt_plains_smooth

aquaticTerrain = tt_continental_water_aquatic
waterTerrain = tt_continental_water_deep
waterVariation = tt_continental_water_stealth

holyTerrain = tt_continental_holy_site
tradeTerrain = tt_continental_settlement

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 30
minimumMapScope = 20
maximumMapScope = 512
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------

print("Start of Script - " .. mapName .. ".")

-- Creating an island in each corner of the map.
local terrainType = cornerTerrain

if (isTinyMap == true) then
	tileAmount = 3
	baseRadius = 0
elseif (isSmallMap == true) then
	tileAmount = 4
	baseRadius = 0
elseif (isMediumMap == true) then
	tileAmount = 6
	baseRadius = 0
elseif (isLargeMap == true) then
	tileAmount = 8
	baseRadius = 0
elseif (isHugeMap == true) then
	tileAmount = 8
	baseRadius = 0
end

local tileRatio = true
local baseRatio = false
local avoidanceDistance = 2
local edgeAvoidance = 0

local originRow = 1
local originColumn = 1
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

local originRow = 1
local originColumn = mapScope
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

local originRow = mapScope
local originColumn = 1
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

local originRow = mapScope
local originColumn = mapScope
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

if (isTinyMap == true) then
	oceanDistance = 3
elseif (isSmallMap == true) then
	oceanDistance = 3
elseif (isMediumMap == true) then
	oceanDistance = 3
elseif (isLargeMap == true) then
	oceanDistance = 4
elseif (isHugeMap == true) then
	oceanDistance = 5
end

terrainType = spawnTerrain
originRow = mapCentre
originColumn = mapCentre

if (isTinyMap == true) then
	tileAmount = 98
	baseRadius = 65
elseif (isSmallMap == true) then
	tileAmount = 124
	baseRadius = 70
elseif (isMediumMap == true) then
	tileAmount = 168
	baseRadius = 76
elseif (isLargeMap == true) then
	tileAmount = 186
	baseRadius = 78
elseif (isHugeMap == true) then
	tileAmount = 192
	baseRadius = 82
end

tileRatio = false
baseRatio = true
avoidanceDistance = 1
edgeAvoidance = oceanDistance
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

-- Creating the primary landmass.
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
	
	local tileAmount = 26
	local tileRatio = false
	local baseRadius = 3
	local baseRatio = false
	local avoidanceDistance = 4
	local edgeAvoidance = oceanDistance
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

	CreateSimultaneousLand(creationProperties)

	for spawnPositionsIndex, spawnInformation in ipairs(spawnPositions) do
		local sourceRow, sourceColumn = table.unpack(spawnInformation)
		local sourceTerrain = spawnTerrain
		local locateNumber = 1
		local separationDistance = 4
		local minimumDistance = 3
		local maximumDistance = 5
		local avoidanceDistance = 3
		local edgeAvoidance = 0
		local startingTable = LocateClosest(sourceRow, sourceColumn, sourceTerrain, locateNumber, separationDistance, minimumDistance, maximumDistance, avoidanceDistance, edgeAvoidance)

		local tableName = startingTable
		local terrainTable = spawnForest
		GenerateTerrainsFromTable(tableName, terrainTable)
	end
end

-- Sets neutral middle zone.
SetZoneOrigin(mapCentre, mapCentre)

-- Executes the zoning.
local avoidanceTable = baseTerrain
local zoneDistance = 0
local maximumDeviation = 5
otherZones = DefineOtherZones(avoidanceTable, zoneDistance, maximumDeviation)

local originDegrees = RandomBetween(0, 359)

-- Creating origin points for holy sites
local locateNumber = 3
local ringRadius = 95
local positionVariance = 0
local rotationSetting = originDegrees
local originTable = CreateCircularClumps(locateNumber, ringRadius, positionVariance, rotationSetting)

for originTableIndex, holyInformation in ipairs(originTable) do
	local sourceRow, sourceColumn = table.unpack(holyInformation)
	local sourceTerrain = spawnTerrain
	local locateNumber = 1
	local separationDistance = 1
	local minimumDistance = 1
	local maximumDistance = 20
	local avoidanceDistance = 0
	local edgeAvoidance = 0
	local holyTable = LocateClosest(sourceRow, sourceColumn, sourceTerrain, locateNumber, separationDistance, minimumDistance, maximumDistance, avoidanceDistance, edgeAvoidance)

	local tableName = holyTable
	local terrainTable = holyTerrain
	GenerateTerrainsFromTable(tableName, terrainTable)
end

local alternativeOriginDegrees = originDegrees + RandomBetween(50, 70)

-- Creating origin points for settlements
local locateNumber = 3
local ringRadius = 95
local positionVariance = 0
local rotationSetting = alternativeOriginDegrees
local originTable = CreateCircularClumps(locateNumber, ringRadius, positionVariance, rotationSetting)

for originTableIndex, tradeInformation in ipairs(originTable) do
	local sourceRow, sourceColumn = table.unpack(tradeInformation)
	local sourceTerrain = spawnTerrain
	local locateNumber = 1
	local separationDistance = 1
	local minimumDistance = 1
	local maximumDistance = 20
	local avoidanceDistance = 0
	local edgeAvoidance = 0
	local tradeTable = LocateClosest(sourceRow, sourceColumn, sourceTerrain, locateNumber, separationDistance, minimumDistance, maximumDistance, avoidanceDistance, edgeAvoidance)

	local tableName = tradeTable
	local terrainTable = tradeTerrain
	GenerateTerrainsFromTable(tableName, terrainTable)
end

-- Creating central mountain impasse.
local terrainType = middleTerrain
local originRow = mapCentre
local originColumn = mapCentre

if (isTinyMap == true) then
	tileAmount = 3
	baseRadius = 0
elseif (isSmallMap == true) then
	tileAmount = 4
	baseRadius = 0
elseif (isMediumMap == true) then
	tileAmount = 6
	baseRadius = 0
elseif (isLargeMap == true) then
	tileAmount = 8
	baseRadius = 0
elseif (isHugeMap == true) then
	tileAmount = 8
	baseRadius = 0
end

local tileRatio = true
local baseRatio = false
local avoidanceDistance = 2
local edgeAvoidance = 1
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

-- Defining stealth forest clumps for the base zone.
local acceptanceTerrain = spawnTerrain
local avoidanceTerrain = {baseTerrain, holyTerrain, tradeTerrain, middleTerrain}
local locateNumber = 1
local distributionType = "relative"
local separationDistance = 6
local avoidanceDistance = 2
local minimumDistance = 6
local edgeAvoidance = 0
local theTable = otherZones[1]
local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual forests on the clumps.
local tableName = forestTable
local terrainTable = baseForest
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining stealth forest clumps for the base zone.
local acceptanceTerrain = spawnTerrain
local avoidanceTerrain = {baseTerrain, holyTerrain, tradeTerrain, middleTerrain}
local locateNumber = 1
local distributionType = "relative"
local separationDistance = 6
local avoidanceDistance = 3
local minimumDistance = 6
local edgeAvoidance = 0
local theTable = otherZones[1]
local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual forests on the clumps.
local tableName = forestTable
local terrainTable = baseForestSmall
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining stealth forest clumps for the base zone.
local acceptanceTerrain = spawnTerrain
local avoidanceTerrain = baseTerrain
local locateNumber = 1
local distributionType = "relative"
local separationDistance = 6
local avoidanceDistance = 3
local minimumDistance = 6
local edgeAvoidance = 0
local theTable = otherZones[1]
local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual forests on the clumps.
local tableName = forestTable
local terrainTable = baseForestVariation
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining stealth forest clumps for the base zone.
local acceptanceTerrain = spawnTerrain
local avoidanceTerrain = baseTerrain
local locateNumber = 1
local distributionType = "relative"
local separationDistance = 6
local avoidanceDistance = 3
local minimumDistance = 6
local edgeAvoidance = 0
local theTable = otherZones[1]
local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual forests on the clumps.
local tableName = forestTable
local terrainTable = stealthForest
GenerateTerrainsFromTable(tableName, terrainTable)

local waterZone = {}
for theRow = 1, mapScope do
	for theColumn = 1, mapScope do
		if (ReviewTerrain(theRow, theColumn, baseTerrain) == true) then
			local theInformation = {}
			local theInformation = {theRow, theColumn}
			table.insert(waterZone, theInformation)
		end
	end
end

local terrainType = waterTerrain
local tileAmount = 2000
local tileRatio = false
local baseRadius = 1
local baseRatio = false
local avoidanceDistance = 2
local edgeAvoidance = 0

local originRow = mapCentre
local originColumn = 1

if (ReviewTerrain(originRow, originColumn, baseTerrain) == true) then
	CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)
end

local originRow = 1
local originColumn = mapCentre

if (ReviewTerrain(originRow, originColumn, baseTerrain) == true) then
	CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)
end

local originRow = mapCentre
local originColumn = mapScope

if (ReviewTerrain(originRow, originColumn, baseTerrain) == true) then
	CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)
end

local originRow = mapScope
local originColumn = mapCentre

if (ReviewTerrain(originRow, originColumn, baseTerrain) == true) then
	CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)
end

-- Defining aquatic clumps for the water zone.
local acceptanceTerrain = waterTerrain
local avoidanceTerrain = spawnTerrain
local locateNumber = 10
local distributionType = "relative"
local separationDistance = 4
local avoidanceDistance = 2
local minimumDistance = 1
local edgeAvoidance = 0
local theTable = waterZone
local aquaticTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the aquatic terrain on the clumps.
local tableName = aquaticTable
local terrainTable = aquaticTerrain
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining aquatic clumps for the water zone.
local acceptanceTerrain = waterTerrain
local avoidanceTerrain = spawnTerrain
local locateNumber = 2
local distributionType = "relative"
local separationDistance = 10
local avoidanceDistance = 3
local minimumDistance = 1
local edgeAvoidance = 0
local theTable = waterZone
local aquaticTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the aquatic terrain on the clumps.
local tableName = aquaticTable
local terrainTable = waterVariation
GenerateTerrainsFromTable(tableName, terrainTable)

-- Defining aquatic clumps for the water zone.
local acceptanceTerrain = waterTerrain
local avoidanceTerrain = spawnTerrain
local locateNumber = 2
local distributionType = "relative"
local separationDistance = 10
local avoidanceDistance = 3
local minimumDistance = 1
local edgeAvoidance = 0
local theTable = waterZone
local aquaticTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the aquatic terrain on the clumps.
local tableName = aquaticTable
local terrainTable = waterVariation
GenerateTerrainsFromTable(tableName, terrainTable)

local shoreZone = {}
for theRow = 1, mapScope do
	for theColumn = 1, mapScope do
		if (ReviewTerrain(theRow, theColumn, spawnTerrain) == true) then
			allowGeneration = false
			local tileProximity = ReturnProximity(theRow, theColumn, 1, "cross")

			-- Goes through each tile surrounding the chosen tile.
			for tileProximityIndex, tileInformation in ipairs(tileProximity) do
				local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)

				-- If the selected tile is not the same terrain as the origin terrain, then do not allow tile to generate.
				if (CheckTerrain(tileProximityRow, tileProximityColumn, baseTerrain) == true) then
					allowGeneration = true
					break
				end
			end

			if (allowGeneration == true) then
				inTable = false
				theInformation = {}
				theInformation = {theRow, theColumn}

				if (TableContainCoordinates(shoreZone, theInformation) == true) then
					inTable = true
					break
				end
				
				if (inTable == false) then
					table.insert(shoreZone, theInformation)
				end
			end
		end
	end
end

-- Defining clumps for varied map elevation.
local acceptanceTerrain = spawnTerrain
local avoidanceTerrain = {baseTerrain, holyTerrain, tradeTerrain}
local locateNumber = 6
local distributionType = "relative"
local separationDistance = 10
local avoidanceDistance = 2
local minimumDistance = 6
local edgeAvoidance = 1
local theTable = otherZones[1]
local elevationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the actual elevation on the clumps.
local tableName = elevationTable
local terrainTable = {
	{baseVariationOne, 3},
	{baseVariationTwo, 2},
	{baseVariationThree, 1}
}
GenerateTerrainsFromTable(tableName, terrainTable)

-- Placing relics and random resources in the corners.
local randomValue = RandomBetween(0,2)
print(randomValue)
if (randomValue < 1) then
	terrainLayoutResult[1][1].terrainType = tt_continental_island_chonker
elseif (randomValue <= 2) then
	terrainLayoutResult[1][1].terrainType = tt_continental_island_ungulate
elseif (randomValue <= 3) then
	terrainLayoutResult[1][1].terrainType = tt_continental_island_herdable
end

local randomValue = RandomBetween(0,2)
print(randomValue)
if (randomValue < 1) then
	terrainLayoutResult[1][mapScope].terrainType = tt_continental_island_chonker
elseif (randomValue <= 2) then
	terrainLayoutResult[1][mapScope].terrainType = tt_continental_island_ungulate
elseif (randomValue <= 3) then
	terrainLayoutResult[1][mapScope].terrainType = tt_continental_island_herdable
end

local randomValue = RandomBetween(0,2)
print(randomValue)
if (randomValue < 1) then
	terrainLayoutResult[mapScope][1].terrainType = tt_continental_island_chonker
elseif (randomValue <= 2) then
	terrainLayoutResult[mapScope][1].terrainType = tt_continental_island_ungulate
elseif (randomValue <= 3) then
	terrainLayoutResult[mapScope][1].terrainType = tt_continental_island_herdable
end

local randomValue = RandomBetween(0,2)
print(randomValue)
if (randomValue < 1) then
	terrainLayoutResult[mapScope][mapScope].terrainType = tt_continental_island_chonker
elseif (randomValue <= 2) then
	terrainLayoutResult[mapScope][mapScope].terrainType = tt_continental_island_ungulate
elseif (randomValue <= 3) then
	terrainLayoutResult[mapScope][mapScope].terrainType = tt_continental_island_herdable
end

print("End of Script - " .. mapName .. ".")