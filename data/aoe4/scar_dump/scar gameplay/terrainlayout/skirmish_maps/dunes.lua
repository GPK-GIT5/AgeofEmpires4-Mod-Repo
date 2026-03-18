-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

mapName = "Prairie/Dunes"

-- Defining terrains for the map.
originTerrain = tt_dunes_player_start
spawnTerrain = tt_hills_low_rolling_clearing

baseTerrain = tt_plains
baseElevationLow = tt_hills_low_rolling
baseElevationMedium = tt_hills_med_rolling
baseElevationHigh = tt_hills_high_rolling

baseForest = tt_forest_circular_tiny
baseForestVariation = tt_forest_natural_tiny

holyTerrain = nil
tradeTerrain = tt_waterholes_settlement -- May need replacing

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 20
minimumMapScope = 20
maximumMapScope = 80
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
		ringRadius = 66
		positionVariance = 1
	elseif (isMediumMap == true) then
		ringRadius = 68
		positionVariance = 1
	elseif (isLargeMap == true) then
		ringRadius = 72
		positionVariance = 1
	elseif (isHugeMap == true) then
		ringRadius = 74
		positionVariance = 1
	end

	local rotationSetting = true
	local mirrorGeneration = 
	
	-- Placing players on the map using the parameters above.
	PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)
	
	local tileAmount = 4
	local tileRatio = false
	local baseRadius = 2
	local baseRatio = false
	local avoidanceDistance = 2
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

-- Randomising the placement of settlements and holy sites.
if (worldGetRandom() > 0.5) then
	changeLocation = true
end

-- Creating small forests scattered around the map.
local sourceTerrain = baseTerrain
local creationChance = 35
local violationConstraint = 100
local separationDistance = 1
local avoidanceDistance = 1
local minimumDistance = 2
local edgeAvoidance = 1

local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = baseForest
	end
end

-- Creating small forests scattered around the map.
local sourceTerrain = baseTerrain
local creationChance = 75
local violationConstraint = 100
local separationDistance = 4
local avoidanceDistance = 1
local minimumDistance = 3
local edgeAvoidance = 1

local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = baseForestVariation
	end
end

-- Placing scattered gold mines around the middle.
local sourceTerrain = baseTerrain
local creationChance = 50
local violationConstraint = 100
local separationDistance = 5
local avoidanceDistance = 0
local minimumDistance = 4
local edgeAvoidance = 1

local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = tt_dunes_gold
	end
end

-- Placing scattered stone mines around the middle.
local sourceTerrain = baseTerrain
local creationChance = 50
local violationConstraint = 100
local separationDistance = 5
local avoidanceDistance = 0
local minimumDistance = 4
local edgeAvoidance = 1

local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = tt_dunes_stone
	end
end

-- Placing scattered forage bush clusters around the middle.
local sourceTerrain = baseTerrain
local creationChance = 50
local violationConstraint = 100
local separationDistance = 5
local avoidanceDistance = 0
local minimumDistance = 4
local edgeAvoidance = 1

local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = tt_dunes_forage_bush
	end
end

-- Placing ungulate around the middle.
local sourceTerrain = baseTerrain
local creationChance = 50
local violationConstraint = 100
local separationDistance = 5
local avoidanceDistance = 0
local minimumDistance = 4
local edgeAvoidance = 1

local randomClumps = CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)

if (#randomClumps > 0) then
	for randomClumpsIndex, tileInformation in ipairs(randomClumps) do
		local randomClumpsRow, randomClumpsColumn = table.unpack(tileInformation)
		
		terrainGrid[randomClumpsRow][randomClumpsColumn].terrainType = tt_dunes_ungulate
	end
end

-- Creates various terrain variation.
local newTerrain = {
	{baseElevationLow, 4},
	{baseElevationMedium, 2},
	{baseElevationHigh, 1}
}
local sourceTerrain = baseTerrain
local generationChance = 50
local breakingChance = 80
local minimumDistance = 1
local separationDistance = 1
local avoidanceDistance = 0
local edgeAvoidance = 1
local scopePrecision = 1
local clumpRadius = 0
local clumpShape = "square"
CreateTerrainClumps(newTerrain, sourceTerrain, generationChance, breakingChance, minimumDistance, separationDistance, avoidanceDistance, edgeAvoidance, scopePrecision, clumpRadius, clumpShape)

-- Creates rougher terrain around the edge of the map.
local waterTerrain = tt_mountains
local waterEdgeDistance = 3
local waterGenerationChance = 90
for currentRow = 1, mapScope do
	for currentColumn = 1, mapScope do
		if (currentRow <= waterEdgeDistance) or (currentRow >= (mapScope - waterEdgeDistance)) or (currentColumn <= waterEdgeDistance) or (currentColumn >= (mapScope - waterEdgeDistance)) then
			if (worldGetRandom() > ToDecimal(waterGenerationChance)) then
				if (DistanceFromEdge(currentRow, currentColumn, 1) == true) then
					terrainLayoutResult[currentRow][currentColumn].terrainType = waterTerrain
				end
			end
		end
	end
end

for spawnPositionsIndex, coordinates in ipairs(spawnPositions) do
	local spawnPositionRow, spawnPositionColumn = table.unpack(coordinates)
	terrainLayoutResult[spawnPositionRow][spawnPositionColumn].terrainType = originTerrain	
end


-- Placing settlements in opposite corners.
theRow = ScaleByMapSize(1, false, true)

if (changeLocation == true) then
	theColumn = OppositeNumber(ScaleByMapSize(1, false, true))
else
	theColumn = ScaleByMapSize(1, false, true)
end

-- Clearing the area around the settlement.
local tileProximity = ReturnProximity(theRow, theColumn, 1, "square")
for tileProximityIndex, tileInformation in ipairs(tileProximity) do
	local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
	
	terrainGrid[tileProximityRow][tileProximityColumn].terrainType = baseElevationLow
end

terrainGrid[theRow][theColumn].terrainType = tradeTerrain

oppositeRow = OppositeNumber(theRow)
oppositeColumn = OppositeNumber(theColumn)

-- Clearing the area around the settlement.
local tileProximity = ReturnProximity(oppositeRow, oppositeColumn, 1, "square")
for tileProximityIndex, tileInformation in ipairs(tileProximity) do
	local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
	
	terrainGrid[tileProximityRow][tileProximityColumn].terrainType = baseElevationLow
end

terrainGrid[oppositeRow][oppositeColumn].terrainType = tradeTerrain


print("End of Script - " .. mapName .. ".")