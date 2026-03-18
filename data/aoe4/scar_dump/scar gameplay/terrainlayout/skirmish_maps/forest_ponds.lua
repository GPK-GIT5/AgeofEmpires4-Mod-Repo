-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "Forest Ponds"

-- Defining terrains for the map.
originTerrain = tt_forest_ponds_player_start
spawnTerrain = tt_plains_smooth

baseTerrain = tt_plains
baseForest = tt_forest_natural_small

baseVariationOne = tt_hills_gentle_rolling
baseVariationTwo = tt_hills_low_rolling
baseVariationThree = tt_flatland

middleTerrain = tt_forest_natural_small

oceanBeach = tt_beach
oceanShallow = tt_ocean
oceanDeep = tt_ocean_deep

holyTerrain = tt_forest_ponds_holy_site
tradeTerrain = tt_forest_ponds_market

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 21
minimumMapScope = 20
maximumMapScope = 100
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------

print("Start of Script - " .. mapName .. ".")

-- Creating four ponds, one in each corner.
local cornerTerrain = oceanBeach
local cornerSize = 45
local cornerVariance = 50
local cornerIterations = ScaleByMapSize(1, true, true)
CreateCornerLand("top", cornerSize, cornerTerrain, cornerVariance, cornerIterations)
CreateCornerLand("left", cornerSize, cornerTerrain, cornerVariance, cornerIterations)
CreateCornerLand("right", cornerSize, cornerTerrain, cornerVariance, cornerIterations)
CreateCornerLand("bottom", cornerSize, cornerTerrain, cornerVariance, cornerIterations)

-- Creating a vast forest located in the centre of the map.
local terrainType = middleTerrain
local originRow = mapCentre
local originColumn = mapCentre

if (isTinyMap == true) then
	tileAmount = 6
	baseRadius = 20
elseif (isSmallMap == true) then
	tileAmount = 4
	baseRadius = 22
elseif (isMediumMap == true) then
	tileAmount = 10
	baseRadius = 26
elseif (isLargeMap == true) then
	tileAmount = 16
	baseRadius = 30
elseif (isHugeMap == true) then
	tileAmount = 128
	baseRadius = 34
end

local tileRatio = true
local baseRatio = true
local avoidanceDistance = ScaleByMapSize(4, true, true)
local edgeAvoidance = ScaleByMapSize(4, true, true)
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

-- Creating shallow water on top of the beach.
local newTerrain = oceanShallow
local sourceTerrain = oceanBeach
local generationChance = 100
local breakingChance = 100
local minimumDistance = 0
local separationDistance = 0
local avoidanceDistance = 1
local edgeAvoidance = 0
local scopePrecision = 1
local clumpRadius = 0
local clumpShape = "square"
CreateTerrainClumps(newTerrain, sourceTerrain, generationChance, breakingChance, minimumDistance, separationDistance, avoidanceDistance, edgeAvoidance, scopePrecision, clumpRadius, clumpShape)

-- Creating deep water on top of the shallow water.
local newTerrain = oceanDeep
local sourceTerrain = oceanShallow
local generationChance = 100
local breakingChance = 100
local minimumDistance = 0
local separationDistance = 0
local avoidanceDistance = 2
local edgeAvoidance = 0
local scopePrecision = 1
local clumpRadius = 0
local clumpShape = "square"
CreateTerrainClumps(newTerrain, sourceTerrain, generationChance, breakingChance, minimumDistance, separationDistance, avoidanceDistance, edgeAvoidance, scopePrecision, clumpRadius, clumpShape)

if (isZeroPlayerGame ~= true) then
	if (isTinyMap == true) then
		ringRadius = 60
		positionVariance = 0
	elseif (isSmallMap == true) then
		ringRadius = 61
		positionVariance = 0
	elseif (isMediumMap == true) then
		ringRadius = 63
		positionVariance = 1
	elseif (isLargeMap == true) then
		ringRadius = 64
		positionVariance = 1
	elseif (isHugeMap == true) then
		ringRadius = 65
		positionVariance = 1
	end

	local rotationSetting = true
	local mirrorGeneration = false
	
	-- Placing players on the map using the parameters above.
	PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)

	-- Clearing the area around players, making sure they all have the same distance to the middle forest.
	local clearTerrain = spawnTerrain
	local clearRadius = 3.5
	local clearExceptions = {
		originTerrain,
		oceanBeach,
		oceanShallow,
		oceanDeep
	}

	for spawnPositionsIndex, coordinates in ipairs(spawnPositions) do
		local spawnPositionRow, spawnPositionColumn = table.unpack(coordinates)

		for currentRow = 1, mapScope do
			for currentColumn = 1, mapScope do
				local allowGeneration = true
				local theDistance = GetDistance(spawnPositionRow, spawnPositionColumn, currentRow, currentColumn, 2)

				if (theDistance < clearRadius) then
					for clearExceptionsIndex, currentTerrain in ipairs(clearExceptions) do
						if (terrainGrid[currentRow][currentColumn].terrainType == currentTerrain) then
							allowGeneration = false
						end
					end

					if (allowGeneration == true) then
						terrainLayoutResult[currentRow][currentColumn].terrainType = clearTerrain
					end
				end
			end
		end
	end
end

-- Creating first holy site on random map edge tile.
local availableTiles = {}
for edgeTile = 1, mapScope do
	if (CheckTerrain(edgeTile, 1, baseTerrain) == true) then
		local tileInformation = {}
		local tileInformation = {edgeTile, 1}
		table.insert(availableTiles, tileInformation)
	end
end

if (#availableTiles > 0) then
	local randomSelection = math.ceil(worldGetRandom() * #availableTiles)
	local divineRow, divineColumn = table.unpack(availableTiles[randomSelection])
	terrainGrid[divineRow][divineColumn].terrainType = holyTerrain
end

-- Creating second holy site on random map edge tile.
local availableTiles = {}
for edgeTile = 1, mapScope do
	if (CheckTerrain(1, edgeTile, baseTerrain) == true) then
		local tileInformation = {}
		local tileInformation = {1, edgeTile}
		table.insert(availableTiles, tileInformation)
	end
end

if (#availableTiles > 0) then
	local randomSelection = math.ceil(worldGetRandom() * #availableTiles)
	local divineRow, divineColumn = table.unpack(availableTiles[randomSelection])
	terrainGrid[divineRow][divineColumn].terrainType = holyTerrain
end

-- Creating third holy site on random map edge tile.
local availableTiles = {}
for edgeTile = 1, mapScope do
	if (CheckTerrain(edgeTile, mapScope, baseTerrain) == true) then
		local tileInformation = {}
		local tileInformation = {edgeTile, mapScope}
		table.insert(availableTiles, tileInformation)
	end
end

if (#availableTiles > 0) then
	local randomSelection = math.ceil(worldGetRandom() * #availableTiles)
	local divineRow, divineColumn = table.unpack(availableTiles[randomSelection])
	terrainGrid[divineRow][divineColumn].terrainType = holyTerrain
end

-- Creating fourth holy site on random map edge tile.
local availableTiles = {}
for edgeTile = 1, mapScope do
	if (CheckTerrain(mapScope, edgeTile, baseTerrain) == true) then
		local tileInformation = {}
		local tileInformation = {mapScope, edgeTile}
		table.insert(availableTiles, tileInformation)
	end
end

if (#availableTiles > 0) then
	local randomSelection = math.ceil(worldGetRandom() * #availableTiles)
	local divineRow, divineColumn = table.unpack(availableTiles[randomSelection])
	terrainGrid[divineRow][divineColumn].terrainType = holyTerrain
end

-- Creating small forests scattered around the map.
local sourceTerrain = baseTerrain
local creationChance = 85
local violationConstraint = 100
local separationDistance = 5
local avoidanceDistance = 3
local minimumDistance = 6
local edgeAvoidance = 2
local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = baseForest
	end
end

-- Creates terrain variance and elevation across the base terrain.
local newTerrain = {
	{baseVariationOne, 4},
	{baseVariationTwo, 2},
	{baseVariationThree, 1}
}
local sourceTerrain = baseTerrain
local generationChance = 25
local breakingChance = 90
local minimumDistance = 1
local seperationDistance = 0
local avoidanceDistance = 1
local edgeAvoidance = 1
local scopePrecision = 1
local clumpRadius = 0
local clumpShape = "square"
CreateTerrainClumps(newTerrain, sourceTerrain, generationChance, breakingChance, minimumDistance, separationDistance, avoidanceDistance, edgeAvoidance, scopePrecision, clumpRadius, clumpShape)

-- Adding aquatic to all four corners of the map.
if (isTinyMap == true) then
	terrainLayoutResult[1][1].terrainType = tt_forest_ponds_aquatic_tiny
	terrainLayoutResult[1][mapScope].terrainType = tt_forest_ponds_aquatic_tiny
	terrainLayoutResult[mapScope][1].terrainType = tt_forest_ponds_aquatic_tiny
	terrainLayoutResult[mapScope][mapScope].terrainType = tt_forest_ponds_aquatic_tiny
elseif (isSmallMap == true) then
	terrainLayoutResult[1][1].terrainType = tt_forest_ponds_aquatic_small
	terrainLayoutResult[1][mapScope].terrainType = tt_forest_ponds_aquatic_small
	terrainLayoutResult[mapScope][1].terrainType = tt_forest_ponds_aquatic_small
	terrainLayoutResult[mapScope][mapScope].terrainType = tt_forest_ponds_aquatic_small
elseif (isMediumMap == true) then
	terrainLayoutResult[2][2].terrainType = tt_forest_ponds_aquatic_medium
	terrainLayoutResult[2][mapScope - 1].terrainType = tt_forest_ponds_aquatic_medium
	terrainLayoutResult[mapScope - 1][2].terrainType = tt_forest_ponds_aquatic_medium
	terrainLayoutResult[mapScope - 1][mapScope - 1].terrainType = tt_forest_ponds_aquatic_medium
elseif (isLargeMap == true) then
	terrainLayoutResult[3][3].terrainType = tt_forest_ponds_aquatic_large
	terrainLayoutResult[3][mapScope - 2].terrainType = tt_forest_ponds_aquatic_large
	terrainLayoutResult[mapScope - 2][3].terrainType = tt_forest_ponds_aquatic_large
	terrainLayoutResult[mapScope - 2][mapScope - 2].terrainType = tt_forest_ponds_aquatic_large
elseif (isHugeMap == true) then
	terrainLayoutResult[4][4].terrainType = tt_forest_ponds_aquatic_huge
	terrainLayoutResult[4][mapScope - 3].terrainType = tt_forest_ponds_aquatic_huge
	terrainLayoutResult[mapScope - 3][4].terrainType = tt_forest_ponds_aquatic_huge
	terrainLayoutResult[mapScope - 3][mapScope - 3].terrainType = tt_forest_ponds_aquatic_huge
end

-- Creating naval settlements in each pond.
local sourceRow = mapCentre
local sourceColumn = mapCentre
local sourceTerrain = oceanBeach
local locateNumber = 4
local separationDistance = 10
local minimumDistance = 4
local maximumDistance = mapScope * 2
local avoidanceDistance = 0
local edgeAvoidance = 1
local tradePositions = LocateClosest(sourceRow, sourceColumn, sourceTerrain, locateNumber, separationDistance, minimumDistance, maximumDistance, avoidanceDistance, edgeAvoidance)

for tradePositionsIndex, tileInformation in ipairs(tradePositions) do
	local tradePositionsRow, tradePositionsColumn = table.unpack(tileInformation)

	terrainLayoutResult[tradePositionsRow][tradePositionsColumn].terrainType = tradeTerrain
end

-- Creates terrain variance and elevation across the base terrain.
if (isZeroPlayerGame ~= true) then
	-- Defining player zones.
	local avoidanceTable = {oceanBeach, oceanShallow, oceanDeep, baseForest, middleTerrain, holyTerrain, tradeTerrain}
	local zoneDistance = 2
	local maximumDeviation = 5
	spawnZones = DefineSpawnZones(avoidanceTable, zoneDistance, maximumDeviation)

	-- Defining forest clumps for each zone.
	local acceptanceTerrain = {baseTerrain, spawnTerrain}
	local avoidanceTerrain = {oceanBeach, middleTerrain}
	local locateNumber = 20
	local distributionType = "relative"
	local separationDistance = 1
	local avoidanceDistance = 1
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