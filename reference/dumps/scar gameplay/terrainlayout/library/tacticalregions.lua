-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
--- Make Region Function
-- creates a dot notation table for a region
-- terrain type is the terrain type variable for teh coarse map
-- goldAmount is the number of gold sectors in the region
-- stoneAmount is the number of stone sectors in the region
-- settlementAmount is the number of settlements in the region (should only ever be 0 or 1 and region should probably contain no gold or stone)
function MakeRegion(regionTerrainType, goldAmount, stoneAmount, settlementAmount)
	
	return {
		tt = regionTerrainType, numGold = goldAmount, numStone = stoneAmount, numSettlement = settlementAmount
	}
	
end

--- Player Score Function
-- this function generates scores for each player based on the position of tactical regions and determines which players need a tactical advantage
-- regionTypeList is the list of region types that contains their data on gold, stone, settlement and other score relevant values
function GetPlayerScores(regionTypeList, playerLocationsList, regionLocationsList, terrainGrid)

	local baseScoreConstant = 20 -- score that will be modified by gold modifier and distance from player
	local goldScoreModifier = 1.5 -- multiplier for relative value of resource
	local stoneScoreModifier = 1 -- multiplier for relative value of resource
	local settlementModifier = 2 -- multiplier for relative value of settlements
	local enemyModifier = 4 -- multiplier for relative value of enemy player proximity

	local playerScores = {} -- each player's score ranking based on proximity and type of tactical regions
	local closestRegion = {}
	local meanScore = 0
	
	for pIndex  = 1, #playerLocationsList do
		
		playerScores[pIndex] = 0
		local shortestDistance = 10000
	
		table.insert(closestRegion, pIndex, {0,0})
		
		-- cycle through each player and add to their score based contents and distance of each region
		for rIndex = 1, (#regionLocationsList) do	
			distance = Round(math.sqrt((regionLocationsList[rIndex][1] - playerLocationsList[pIndex].startRow)^2 + (regionLocationsList[rIndex][2] - playerLocationsList[pIndex].startCol)^2), 0)
			tempScore = 0
			
			-- generate score values for the tactical regions
			for grIndex = 1, (#regionTypeList) do
				
				if (terrainLayoutResult[regionLocationsList[rIndex][1]][regionLocationsList[rIndex][2]].terrainType == regionTypeList[grIndex].tt) then
					tempScore = baseScoreConstant * ((regionTypeList[grIndex].numGold * goldScoreModifier) + (regionTypeList[grIndex].numStone * stoneScoreModifier) + (regionTypeList[grIndex].numSettlement * settlementModifier)) / distance				
				end
				
			end
			
			print("Distance for region " ..rIndex .." is " ..distance)
			print("score for region is " ..tempScore)
			playerScores[pIndex] = playerScores[pIndex] + tempScore
			
			-- add the region closest to the player to the list
			if (distance < shortestDistance) then
				shortestDistance = distance
				closestRegion[pIndex][1] = regionLocationsList[rIndex][1]
				closestRegion[pIndex][2] = regionLocationsList[rIndex][2]
			end
			
		end
	
		-- calculate score adjustment for enemy proximity	
		print("ADJUSTING SCORE FOR ENEMY PROXIMITY")
		playerX = playerLocationsList[pIndex].startRow
		playerY = playerLocationsList[pIndex].startCol
		tempEnemyScore = 0
		
		for eIndex = 1, #playerLocationsList do
			
			if (eIndex ~= pIndex) then
				local otherPlayerX = playerLocationsList[eIndex].startRow
				local otherPlayerY = playerLocationsList[eIndex].startCol
				local distance = Round(math.sqrt((otherPlayerX - playerX)^2 + (otherPlayerY - playerY)^2), 0)

				local isOtherPlayerEnemy = (terrainGrid[playerX][playerY].playerIndex % 2) ~= (terrainGrid[otherPlayerX][otherPlayerY].playerIndex % 2)
		
				if (isOtherPlayerEnemy) then
					tempEnemyScore = tempEnemyScore + (baseScoreConstant * enemyModifier) / distance^3
				end
				
			end
			
		end
		
		print("Unmodified enemy score: " ..tempEnemyScore)
		print("Modified enemy score: " ..(tempEnemyScore * 10)^3)
		print("Current player score: " ..playerScores[pIndex])
		playerScores[pIndex] = playerScores[pIndex] - (tempEnemyScore * 10)^3
		print("Enemy modified player score: " ..playerScores[pIndex])
	
	end
	
	-- add up all scores and calculate the mean score
	local totalScores = 0
	
	for pIndex  = 1, (#playerLocationsList) do
		playerScores[pIndex] = Round(playerScores[pIndex], 0)
		totalScores = totalScores + playerScores[pIndex]
		print("----- SCORES -----")
		print("Player " .. pIndex .."'s score is " ..playerScores[pIndex] .." at row " ..playerLocationsList[pIndex].startRow .." column " ..playerLocationsList[pIndex].startCol)
		print("Player " ..pIndex .."'s index is " ..terrainGrid[playerLocationsList[pIndex].startRow][playerLocationsList[pIndex].startCol].playerIndex)
		print("Player " .. pIndex .."'s closest region is at row " ..closestRegion[pIndex][1] .." column " ..closestRegion[pIndex][2])
	end
	
	meanScore = Round(totalScores / (#playerLocationsList), 0)
	print ("Average score: " ..meanScore)
	
	return playerScores, closestRegion, meanScore

end