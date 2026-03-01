-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

-- FALSE: Disallow generation.
-- TRUE: Allow generation.


function ReviewTerrain(reviewRow, reviewColumn, terrainCheck)
	if (terrainGrid[reviewRow][reviewColumn].terrainType == terrainCheck) then
		return true
	end
	
	return false
end

function ReviewEdgeAvoidance(reviewRow, reviewColumn, edgeAvoidance)
	if (edgeAvoidance > 0) then
		if (DistanceFromEdge(reviewRow, reviewColumn, edgeAvoidance) == false) then
			return false
		end
	end

	return true
end

function ReviewAvoidanceDistance(reviewRow, reviewColumn, cleanTerrain, avoidanceDistance)
	local tileProximity = ReturnProximity(reviewRow, reviewColumn, avoidanceDistance, "circular")

	for tileProximityIndex, tileInformation in ipairs(tileProximity) do
		local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)

		if (ReviewTerrain(tileProximityRow, tileProximityColumn, cleanTerrain) == false) and (ReviewTerrain(tileProximityRow, tileProximityColumn, originTerrain) == false) then
			return false
		end
	end

	return true
end

function ReviewMinimumDistance(reviewRow, reviewColumn, minimumDistance)
	if (isZeroPlayerGame ~= true) and (minimumDistance > 0) then
		for spawnPositionsIndex, tileInformation in ipairs(spawnPositions) do
			local spawnPositionsRow, spawnPositionsColumn = table.unpack(tileInformation)
			local theDistance = GetDistance(reviewRow, reviewColumn, spawnPositionsRow, spawnPositionsColumn, 2)

			if (theDistance <= minimumDistance) then
				return false
			end
		end
	end

	return true
end

function ReviewCentreAvoidance(reviewRow, reviewColumn, centreAvoidance)
	if (centreAvoidance > 0) then
		local theDistance = GetDistance(reviewRow, reviewColumn, mapCentre, mapCentre, 2)

		if (theDistance <= centreAvoidance) then
			return false
		end
	end

	return true
end

function ReviewTable(tableName, reviewRow, reviewColumn, reviewRadius, searchType)
	local reviewTile = {}
	local reviewTile = {reviewRow, reviewColumn}

	if (TableContainCoordinates(tableName, reviewTile) == true) then
		return true
	end

	if (reviewRadius > 0) then
		local tileProximity = ReturnProximity(reviewRow, reviewColumn, reviewRadius, searchType)

		for tileProximityIndex, tileInformation in ipairs(tileProximity) do

			if (TableContainCoordinates(tableName, tileInformation) == true) then
				return true
			end
		end
	end

	return false
end