-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "Hideout"

-- Defining terrains for the map.
baseTerrain = tt_plains
spawnTerrain = tt_flatland

middleForest = tt_forest_natural_small

holyTerrain = tt_waterholes_holy_site
tradeTerrain = tt_waterholes_settlement

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 20
minimumMapScope = 20
maximumMapScope = 100
PreliminarySetup()

-- 38: None
-- 40: Medium
-- 43: Large
-- 46: Huge
-- 50: Colossal

if (isZeroPlayerGame ~= true) then
	if (isTinyMap == true) then
		originTerrain = tt_hideout_player_start -- None, Tiny Map
	elseif (isSmallMap == true) then
		if (isThreePlayerGame == true) then
			originTerrain = tt_hideout_player_start -- None, Small Map
		elseif (isFourPlayerGame == true) then
			originTerrain = tt_hideout_player_start_medium -- Medium, Small Map
		else
			originTerrain = tt_hideout_player_start -- None, Small Map
		end
	elseif (isMediumMap == true) then
		if (isFourPlayerGame == true) then
			originTerrain = tt_hideout_player_start_medium -- Medium, Medium Map
		elseif (isFivePlayerGame == true) then
			originTerrain = tt_hideout_player_start_large -- Large, Medium Map
		elseif (isSixPlayerGame == true) then
			originTerrain = tt_hideout_player_start_huge -- Huge, Medium Map
		else
			originTerrain = tt_hideout_player_start_medium -- Medium, Medium Map
		end
	elseif (isLargeMap == true) then
		if (isSixPlayerGame == true) then
			originTerrain = tt_hideout_player_start_large -- Large, Large Map
		elseif (isSevenPlayerGame == true) then
			originTerrain = tt_hideout_player_start_huge -- Huge, Large Map
		elseif (isEightPlayerGame == true) then
			originTerrain = tt_hideout_player_start_colossal -- Colossal, Large Map
		else
			originTerrain = tt_hideout_player_start_large -- Large, Large Map
		end
	elseif (isHugeMap == true) then
		originTerrain = tt_hideout_player_start_colossal -- Colossal, Huge Map
	end
end

-----------------------------
---- Map Script Starting ----
-----------------------------

print("Start of Script - " .. mapName .. ".")

-- Only running player setup if there are players present.
if (isZeroPlayerGame ~= true) then	
	if (isTinyMap == true) then
		ringRadius = 38
	elseif (isSmallMap == true) then
		if (isThreePlayerGame == true) then
			ringRadius = 38 -- Small Map, Three Players, Default
		elseif (isFourPlayerGame == true) then
			ringRadius = 40 -- Small Map, Four Players
		else
			ringRadius = 38 -- Small Map, Fewer Players
		end
	elseif (isMediumMap == true) then
		if (isFourPlayerGame == true) then
			ringRadius = 40 -- Medium Map, Four Players, Default
		elseif (isFivePlayerGame == true) then
			ringRadius = 43 -- Medium Map, Five Players
		elseif (isSixPlayerGame == true) then
			ringRadius = 46 -- Medium Map, Six Players
		else
			ringRadius = 40 -- Medium Map, Fewer Players
		end
	elseif (isLargeMap == true) then
		if (isSixPlayerGame == true) then
			ringRadius = 43 -- Large Map, Six Players, Default
		elseif (isSevenPlayerGame == true) then
			ringRadius = 46 -- Large Map, Seven Players
		elseif (isEightPlayerGame == true) then
			ringRadius = 51 -- Large Map, Eight Players
		else
			ringRadius = 43 -- Large Map, Fewer Players
		end
	elseif (isHugeMap == true) then
		ringRadius = 51 -- Huge Map, Any Players, Default
	end

	local positionVariance = 0
	local rotationSetting = true
	local mirrorGeneration = true
	
	-- Placing players on the map using the parameters above.
	PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)

	local tileAmount = 0
	local tileRatio = false
	local baseRadius = 1
	local baseRatio = false
	local avoidanceDistance = 2
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
	
	CreateSimultaneousLand(creationProperties)
end

-- Creates the vast forest in the centre of the map.
local terrainType = middleForest
local originRow = mapCentre
local originColumn = mapCentre

if (isTinyMap == true) then
	tileAmount = 0
	baseRadius = 47
elseif (isSmallMap == true) then
	if (isThreePlayerGame == true) then
		baseRadius = 47 -- Small Map, Three Players, Default
	elseif (isFourPlayerGame == true) then
		baseRadius = 49 -- Small Map, Four Players
	else
		baseRadius = 47 -- Small Map, Fewer Players
	end
elseif (isMediumMap == true) then
	if (isFourPlayerGame == true) then
		baseRadius = 49 -- Medium Map, Four Players, Default
	elseif (isFivePlayerGame == true) then
		baseRadius = 52 -- Medium Map, Five Players
	elseif (isSixPlayerGame == true) then
		baseRadius = 55 -- Medium Map, Six Players
	else
		baseRadius = 49 -- Medium Map, Fewer Players
	end
elseif (isLargeMap == true) then
	if (isSixPlayerGame == true) then
		baseRadius = 52 -- Large Map, Six Players, Default
	elseif (isSevenPlayerGame == true) then
		baseRadius = 55 -- Large Map, Seven Players
	elseif (isEightPlayerGame == true) then
		baseRadius = 57 -- Large Map, Eight Players
	else
		baseRadius = 52 -- Large Map, Fewer Players
	end
elseif (isHugeMap == true) then
	baseRadius = 57 -- Huge Map, Any Players, Default
end

local tileAmount = 0
local tileRatio = true
local baseRatio = true
local avoidanceDistance = 1
local edgeAvoidance = ScaleByMapSize(3, true, true)
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

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


-- Placing neutral gold deposits along the edge of the map.
local sourceTerrain = baseTerrain
local creationChance = 50
local violationConstraint = 100
local separationDistance = 8
local avoidanceDistance = 3
local minimumDistance = 6
local edgeAvoidance = 0
local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = tt_hideout_gold
	end
end

-- Placing neutral stone deposits along the edge of the map.
local sourceTerrain = baseTerrain
local creationChance = 50
local violationConstraint = 100
local separationDistance = 7
local avoidanceDistance = 2
local minimumDistance = 6
local edgeAvoidance = 0
local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = tt_hideout_stone
	end
end

-- Placing neutral forage bush clusters along the edge of the map.
local sourceTerrain = baseTerrain
local creationChance = 50
local violationConstraint = 100
local separationDistance = 7
local avoidanceDistance = 2
local minimumDistance = 6
local edgeAvoidance = 0
local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = tt_hideout_forage_bush
	end
end

-- Placing positive assets along the edge of the map.
local sourceTerrain = baseTerrain
local creationChance = 50
local violationConstraint = 100
local separationDistance = 5
local avoidanceDistance = 2
local minimumDistance = 6
local edgeAvoidance = 0

local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = tt_hideout_kind
	end
end

-- Placing negative assets along the edge of the map.
local sourceTerrain = baseTerrain
local creationChance = 50
local violationConstraint = 100
local separationDistance = 9
local avoidanceDistance = 2
local minimumDistance = 8
local edgeAvoidance = 0

local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = tt_hideout_mean
	end
end

-- Placing extra forests scattered around the map.
local sourceTerrain = baseTerrain
local creationChance = 60
local violationConstraint = 100
local separationDistance = 5
local avoidanceDistance = 2
local minimumDistance = 6
local edgeAvoidance = 0

local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = tt_forest_natural_small
	end
end

-- Grabs all the middle forest tiles.
local middleZone = {}
for theRow = 1, mapScope do
	for theColumn = 1, mapScope do
		if (ReviewTerrain(theRow, theColumn, middleForest) == true) then
			local theInformation = {}
			local theInformation = {theRow, theColumn}
			table.insert(middleZone, theInformation)
		end
	end
end

-- Adding stealth forest to the centre of the map for optimisation and pathfinding reasons.
local acceptanceTerrain = middleForest
local avoidanceTerrain = {
	{baseTerrain, 2}
}
local locateNumber = 35
local distributionType = "relative"
local separationDistance = 1
local avoidanceDistance = "individual"
local minimumDistance = 1
local edgeAvoidance = 1
local theTable = middleZone
local optimisationTable = CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)

-- Generating the stealth forests in the middle of the map.
local tableName = optimisationTable
local terrainTable = tt_stealth_natural_small
GenerateTerrainsFromTable(tableName, terrainTable)

print("End of Script - " .. mapName .. ".")