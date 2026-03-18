-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "Mountain Clearing"
mapVariation = 1

-- Defining terrains for the map.
originTerrain = tt_clearing_player_start
spawnTerrain = tt_plains

baseTerrain = tt_impasse_mountains

if (mapVariation == 1) then
	forestFoundation = tt_plains_smooth
else
	forestFoundation = tt_forest_natural_small
end

holyTerrain = tt_clearing_holy_site
tradeTerrain = tt_clearing_settlement

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 17
minimumMapScope = 20
maximumMapScope = 100
PreliminarySetup()

-----------------------------
---- Map Script Starting ----
-----------------------------

print("Start of Script - " .. mapName .. ".")

-- Creates a large clearing in the centre of the map.
local terrainType = spawnTerrain
local originRow = mapCentre
local originColumn = mapCentre
local tileAmount = ScaleByMapSize(32, false, true)
local baseRadius = 75
local tileRatio = true
local baseRatio = true
local avoidanceDistance = 1
local edgeAvoidance = ScaleByMapSize(1, true, true) --true: low, false: high
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

-- Creates the forest enclosing the players.
PlaceInCircle(forestFoundation, spawnTerrain, 50)

if (isZeroPlayerGame ~= true) then
	if (mapVariation == 1) then
		ringRadius = 45
	else
		ringRadius = 40
	end
	
	local positionVariance = 0
	local rotationSetting = true
	local mirrorGeneration = true

	-- Placing players on the map using the parameters above.
	PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)

	local tileAmount = 0
	local tileRatio = false
	local baseRadius = 2
	local baseRatio = false
	local avoidanceDistance = 0
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

-- Creating holy sites to be placed near the centre of the map.
if (isOnePlayerGame == true) then
	terrainGrid[mapCentre][mapCentre].terrainType = holyTerrain
elseif (isTwoPlayerGame == true) then
	terrainGrid[mapCentre][mapCentre].terrainType = holyTerrain
elseif (isThreePlayerGame == true) then
	terrainGrid[mapCentre][mapCentre].terrainType = holyTerrain
else
	if (isFourPlayerGame == true) then
		locateNumber = 2
		ringRadius = 8
	elseif (isFivePlayerGame == true) then
		locateNumber = 2
		ringRadius = 9
	elseif (isSixPlayerGame == true) then
		locateNumber = 3
		ringRadius = 10
	elseif (isSevenPlayerGame == true) then
		locateNumber = 3
		ringRadius = 11
	elseif (isEightPlayerGame == true) then
		locateNumber = 3
		ringRadius = 12
	end

	local positionVariance = 0
	local rotationSetting = true
	local tableName = CreateCircularClumps(locateNumber, ringRadius, positionVariance, rotationSetting)
	local terrainTable = holyTerrain
	GenerateTerrainsFromTable(tableName, terrainTable)
end

if (isZeroPlayerGame ~= true) then
	-- Creates the origin spawn for the neutral resources.
	if (isOnePlayerGame == true) or (isTwoPlayerGame == true) or (isThreePlayerGame == true) then
		betweenPositions = BetweenPlayerGeneration(40, 1)
	else
		betweenPositions = BetweenPlayerGeneration(20, 1)
	end

	-- Generating the actual assets on the origins.
	for betweenPositionsIndex, tileInformation in ipairs(betweenPositions) do
		betweenPositionsRow, betweenPositionsColumn = table.unpack(tileInformation)
		terrainGrid[betweenPositionsRow][betweenPositionsColumn].terrainType = tt_clearing_neutral
	end
end

if (mapVariation == 1) then
	local forestZone = {}
	for theRow = 1, mapScope do
		for theColumn = 1, mapScope do
			if (ReviewTerrain(theRow, theColumn, forestFoundation) == true) then
				local theInformation = {}
				local theInformation = {theRow, theColumn}
				table.insert(forestZone, theInformation)
			end
		end
	end

	-- Defining forest clumps for the foundation zone.
	local acceptanceTerrain = forestFoundation
	local avoidanceTerrain = baseTerrain
	
	if (isTinyMap == true) then
		locateNumber = 16
	elseif (isSmallMap == true) then
		locateNumber = 20
	elseif (isMediumMap == true) then
		locateNumber = 24
	elseif (isLargeMap == true) then
		locateNumber = 28
	elseif (isHugeMap == true) then
		locateNumber = 32
	end
	
	local distributionType = "relative"
	local separationDistance = 5
	local avoidanceDistance = 1
	local minimumDistance = 3
	local edgeAvoidance = 0
	local theTable = forestZone
	local forestTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

	-- Generating the forest terrains on the clumps.
	local tableName = forestTable
	local terrainTable = {
		{tt_forest_natural_small, 1},
		{tt_forest_natural_medium, 1}
	}
	GenerateTerrainsFromTable(tableName, terrainTable)
end

print("End of Script - " .. mapName .. ".")