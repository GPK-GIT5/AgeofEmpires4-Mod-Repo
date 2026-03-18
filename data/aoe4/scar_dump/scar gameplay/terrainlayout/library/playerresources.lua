-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
-- This script contains functions for placing resource squares in maps for Cardinal

-- this function generates locations for pocket resources to support nomad mode starting resources
-- startLocations is a list of player start locations (formatted as per the functions in player_start: MakePlayerStartPosition)
-- numberOfResourcePockets is the number of reosurce pockets desired for each start
-- radiusFromStartLocation is the radius of hte ring around the start location in squares
-- terrainTypeForRing is a list of valid terrain types to select in the ring around the player start (all other terrain types will be ignored)
-- coarseGridLayout is the terrain layout grid (terrainLayoutresult)
-- minPocketSeparation is the distance in squares the pockets must be apart
-- pocketTerrainTypes is the list of terrain types per player that will be assigned to that player's resource pockets
-- coarseGridSize is the size of the grid (may be updated to width and height later if we have rectangular maps)
function PlaceNomadResourcePockets(startLocations, numberOfResourcePockets, radiusFromStartLocation, ringAroundStartWidth, terrainTypeForRing, coarseGridLayout, minPocketSeparation, pocketTerrainTypes, coarseGridSize)
	print("PLACE NOMAD RESOURCE POCKETS.")
	
	-- error checking
	if ((#startLocations) < 1) then
		print("ERROR: no player start locations found in startLocationsList. Aborting Function")
		return
	end
	
	if ((#startLocations) ~= worldPlayerCount) then
		print("WARNING: startLocations list does not match number of players. Not all players will get resource pocket locations.")
	end	
	
	-- set up tables for the resource locations and potential resource locations (a set of three locations per player)
	resourceLocations = {}
	
	for index = 1, (#startLocations) do
		
		print ("Getting Squares in ring around start location " ..index)
		table.insert(resourceLocations, index, {})
		potentialSquares = {}
		potentialSquares = GetAllSquaresOfTypeInRingAroundSquare(startLocations[index].startRow, startLocations[index].startCol, radiusFromStartLocation, ringAroundStartWidth, terrainTypeForRing, coarseGridLayout)
		
		print("There are " ..(#potentialSquares) .." potential resource squares.")
		
		if ((#potentialSquares) < numberOfResourcePockets) then
			print("Error: not enough available squares to add resource pockets. Aborting function.")
			return
		end
			
		-- get a valid square for each pocket
		for pIndex = 1, numberOfResourcePockets do
		
			squareSelected = false
			
			while (squareSelected == false and (#potentialSquares) >= 1) do
				print("Potential pocket squares remaining: " ..(#potentialSquares))
				selectionIndex = Round((worldGetRandom() - 1E-10) * ((#potentialSquares) - 1), 0) + 1 
				print("Selection Index: " ..selectionIndex)
				print(" Square at row " ..potentialSquares[selectionIndex][1] ..", col " ..potentialSquares[selectionIndex][2])
				
				-- place the first square without doing a distance check as the list will be empty (nothing to check against)
				if ((#resourceLocations[index]) < 1) then
					print("Placing Pocket " ..pIndex .." at row " ..potentialSquares[selectionIndex][1] ..", col " ..potentialSquares[selectionIndex][2])
					table.insert(resourceLocations[index], {potentialSquares[selectionIndex][1], potentialSquares[selectionIndex][2]})
					squareSelected = true				
				-- check that the square is at min distance apart from other pockets 
				elseif (SquaresFarEnoughApart(potentialSquares[selectionIndex][1], potentialSquares[selectionIndex][2], minPocketSeparation, resourceLocations[index], coarseGridSize) == true) then
					print("Placing Pocket " ..pIndex .." at row " ..potentialSquares[selectionIndex][1] ..", col " ..potentialSquares[selectionIndex][2])
					table.insert(resourceLocations[index], {potentialSquares[selectionIndex][1], potentialSquares[selectionIndex][2]})
					squareSelected = true		
				else
					squareSelected = false
				end
				
				table.remove(potentialSquares, selectionIndex)
				
			end
		
		end
	
	end
	
	-- select the terrain type for each pocket from the passed in list and set the correct square in the grid 
	for index = 1, (#startLocations) do
		
		for pIndex = 1, (#resourceLocations[index]) do
			print("startLocations Size: " ..(#startLocations) .." pocketTerrainTypes Size: " ..(#pocketTerrainTypes[index]) .." resourceLocations Size: " ..(#resourceLocations[index]))
			print("Index: " ..index .." pIndex: " ..pIndex)
			x = resourceLocations[index][pIndex][1]
			y = resourceLocations[index][pIndex][2]
			print("Player " ..index .." resource pocket " ..pIndex .." is terrain type " ..pocketTerrainTypes[index][pIndex])
			print("Location is Row, " ..x ..", Column " ..y)
			pocketTerrainType = pocketTerrainTypes[index][pIndex]
			coarseGridLayout[x][y].terrainType = pocketTerrainType
		end
		
	end
	
end

function GetSquaresForTacticalRegions(baseDistanceFromPlayers, distanceFromSettlements, thePlayerLocationPositions, theSettlementLocationPositions, terrainTypesForRegions, debugShowRegionSquares, debugRegionVisType)
	
	local distanceFromPlayers = math.floor(baseDistanceFromPlayers / math.sqrt(1024 ^ 2) * math.sqrt(worldTerrainWidth * worldTerrainHeight))
	distanceFromPlayers = math.floor(distanceFromPlayers * math.sqrt(4) / math.sqrt(worldPlayerCount))
	print("Min Distance From Players is " ..distanceFromPlayers)
	validSquares = {}
	
	if ((#terrainTypesForRegions) > 0) then
		
		for index = 1, (#terrainTypesForRegions) do
			
			theSquares = GetSquaresOfType(terrainTypesForRegions[index], gridSize, terrainLayoutResult)
			
			for sIndex = 1, (#theSquares) do
				table.insert(validSquares, theSquares[sIndex])
			end
			
		end
		
	else
		print("ERROR: No terrain types in terrainTypesForRegions. Aborting Function.")
		return
	end
	
	for tIndex = (#validSquares), 1, -1  do
		print("Index: " ..tIndex)
		x = validSquares[tIndex][1]
		y = validSquares[tIndex][2]
		print("Row: " ..x .." Col: " ..y)
		print("Checking distance to player starts...")
		if (SquaresFarEnoughApartEuclidian(x, y, distanceFromPlayers, thePlayerLocationPositions, gridSize) == false) then
			print("------------------- Removing square at index " .. tIndex)
			table.remove(validSquares, tIndex)
		end
		
		if (theSettlementLocationPositions ~= nil) then
			print("Checking distance to settlements...")
			if (SquaresFarEnoughApartEuclidian(x, y, distanceFromSettlements, theSettlementLocationPositions, gridSize) == false) then			
				print("------------------- Removing square at index " .. tIndex)
				table.remove(validSquares, tIndex)
			end
			
		end
		
	end
	
	if (debugShowRegionSquares == true) then
		for index = 1, (#validSquares) do	
			x = validSquares[index][1]
			y = validSquares[index][2]
			terrainLayoutResult[x][y].terrainType = debugRegionVisType
		end
		
	end
	
	print("Found " ..(#validSquares) .." squares available for tactical region placement.")
	return validSquares

end

--- Function to place terrain types in map that have local distributions for gold and stone (settlements are considered a tactical region but placed seperately)
-- baseGoldAmountSquareKM is the amount of gold that will scale based on map size (bigger for maps over 1024 and smaller for maps under 1024)
-- baseGoldAmount is the base amount of gold to place in the map (added to gold per square km)
-- baseStoneAmountSquareKM is the amount of stone that will scale based on map size (bigger for maps over 1024 and smaller for maps under 1024)
-- baseStoneAmount is the base amount of stone to place in the map (added to gold per square km)
-- base distance from regions is the distance the regions must be from each other (in coarse grid squares)
-- regionSquaresList is the list of potential places the regions can go.
-- terrainTypesForRegions is a table containing the terrain types that can be used to placed regions (i.e. can a region replace this terrain type?)
function PlaceTacticalRegions(baseGoldAmountSquareKM, baseGoldAmount, baseStoneAmountSquareKM, baseStoneAmount, baseDistanceFromRegions, regionSquaresList, terrainTypesForRegions, regionTypeList)
	
	print("PLACE TACTICAL REGIONS CALLED")
	
	local distanceFromRegions = math.floor(baseDistanceFromRegions / math.sqrt(1024 ^ 2) * math.sqrt(worldTerrainWidth * worldTerrainHeight))
	distanceFromRegions = math.floor(distanceFromRegions * math.sqrt(4) / math.sqrt(worldPlayerCount))
	print("Min Distance From Regions is " ..distanceFromRegions)
	
	-- placing tactical regions
	-- set resource amount numbers
	local goldPerSquareKM = Round(baseGoldAmountSquareKM / 1024^2 * (worldTerrainWidth * worldTerrainHeight), 0)
	print("Total KM gold is " ..goldPerSquareKM)
	local stonePerSquareKM = Round(baseStoneAmountSquareKM / 1024^2 * (worldTerrainWidth * worldTerrainHeight), 0)
	print("Total KM stone is " ..stonePerSquareKM)
	local tacticalGoldSectors = baseGoldAmount + goldPerSquareKM
	print("Total map gold is " ..tacticalGoldSectors)
	local tacticalStoneSectors = baseStoneAmount + stonePerSquareKM
	print("Total map stone is " ..tacticalStoneSectors)
	local goldSectorsRemaining  = tacticalGoldSectors
	local stoneSectorsRemaining = tacticalStoneSectors
	local totalGoldPlaced = 0
	local totalStonePlaced = 0
	
	-- setting up squares for GOLD tactical regions
	-- create a temp table to hold region locations for testing distance. The regionSquaresList will need to be preserved for further distance checks
	currentValidGoldSquares = {}
	for index = 1, (#regionSquaresList) do
		x = regionSquaresList[index][1]
		y = regionSquaresList[index][2]
	
		if ((#terrainTypesForRegions) > 0) then
		
			-- check to see the square in question matches one of the terrain types designated as ok to place regions
			for tIndex = 1, (#terrainTypesForRegions) do
			
				if (terrainLayoutResult[x][y].terrainType == terrainTypesForRegions[tIndex]) then
					table.insert(currentValidGoldSquares, regionSquaresList[index])
				end
				
			end
			
		else
			print("ERROR: There are no valid terrain types in the table in which to place regions. Aborting function.")
			return
		end
				
	end
	
	print((#currentValidGoldSquares) .." squares are currently available to place gold tactical regions.")
	tacticalResourcePositions = {}
	tacticalRegionLocations = {}
	
	print("PLACING GOLD TACTICAL REGIONS...")
	print("GOLD REMAINING: " ..goldSectorsRemaining .." STONE REMAINING: " ..stoneSectorsRemaining)
	while (goldSectorsRemaining > 0 and (#currentValidGoldSquares) > 0) do
	
		pickedRegionType = false
		
		while (pickedRegionType == false) do
			regionChosen = GetRandomElement(regionTypeList)
			print("Gold in region chosen is " ..regionChosen.numGold .." Gold remaining is " ..goldSectorsRemaining)
			
			if (regionChosen.numGold > 0) then
				if (regionChosen.numGold <= goldSectorsRemaining) then
					print("There is enough gold remaining to cover the chosen region.")
					pickedRegionType = true
				else
					print("Too much gold in region type. Picking another region type...")
					pickedRegionType = false
				end
				
			else
				print("This is not a gold region type. Picking another region type...")
				pickedRegionType = false
			end
			
		end
		
		pickedRegionSquare = false
		
		while (pickedRegionSquare == false and (#currentValidGoldSquares) > 0) do
		
			index = Round((worldGetRandom() - 1E-10) * ((#currentValidGoldSquares) - 1), 0) + 1
			location = currentValidGoldSquares[index]
			x = location[1]
			y = location[2]
			print("There are currently " ..(#tacticalResourcePositions) .." region locations in the list to check distance on")
			if ((#tacticalResourcePositions) < 1) then
				table.insert(tacticalResourcePositions, {x, y})
				terrainLayoutResult[x][y].terrainType = regionChosen.tt
				totalGoldPlaced = totalGoldPlaced + regionChosen.numGold
				totalStonePlaced = totalStonePlaced + regionChosen.numStone
				goldSectorsRemaining = goldSectorsRemaining - regionChosen.numGold
				stoneSectorsRemaining = stoneSectorsRemaining - regionChosen.numStone
				print("Region placed at " ..x ..", " ..y ..". Gold remaining: " ..goldSectorsRemaining .." Stone remaining: " ..stoneSectorsRemaining)
				print("Adding tactical resource square at " ..x ..", " ..y)
				
				-- re-set the valid squares for next region placement
				currentValidGoldSquares = {}
				for index = 1, (#regionSquaresList) do
					x = regionSquaresList[index][1]
					y = regionSquaresList[index][2]
					
					if ((#terrainTypesForRegions) > 0) then
							
						for tIndex = 1, (#terrainTypesForRegions) do
						
							if (terrainLayoutResult[x][y].terrainType == terrainTypesForRegions[tIndex]) then
								table.insert(currentValidGoldSquares, regionSquaresList[index])
							end
							
						end
						
					else
						print("ERROR: There are no valid terrain types in the table in which to place regions. Aborting function.")
						return
					end
					
				end
						
				print("GOLD SQUARES UPDATE - there are " ..(#currentValidGoldSquares) .." squares available for " ..goldSectorsRemaining .." gold.")
				pickedRegionSquare = true
				
			elseif (SquaresFarEnoughApartEuclidian(x, y, distanceFromRegions, tacticalResourcePositions, gridSize) == true) then
				table.insert(tacticalResourcePositions, {x, y})
				terrainLayoutResult[x][y].terrainType = regionChosen.tt
				totalGoldPlaced = totalGoldPlaced + regionChosen.numGold
				totalStonePlaced = totalStonePlaced + regionChosen.numStone
				goldSectorsRemaining = goldSectorsRemaining - regionChosen.numGold
				stoneSectorsRemaining = stoneSectorsRemaining - regionChosen.numStone
				print("Region placed at " ..x ..", " ..y ..". Gold remaining: " ..goldSectorsRemaining .." Stone remaining: " ..stoneSectorsRemaining)
				print("Adding tactical resource square at " ..x ..", " ..y)
				
				-- re-set the valid squares for next region placement
				currentValidGoldSquares = {}
				for index = 1, (#regionSquaresList) do
					x = regionSquaresList[index][1]
					y = regionSquaresList[index][2]
					
					if ((#terrainTypesForRegions) > 0) then
							
						for tIndex = 1, (#terrainTypesForRegions) do
						
							if (terrainLayoutResult[x][y].terrainType == terrainTypesForRegions[tIndex]) then
								table.insert(currentValidGoldSquares, regionSquaresList[index])
							end
							
						end
						
					end
					
				end
								
				print("GOLD SQUARES UPDATE - there are " ..(#currentValidGoldSquares) .." squares available for " ..goldSectorsRemaining .." gold.")
				pickedRegionSquare = true
				
			else
				print("NO REGIONS PLACED THIS PASS")
				table.remove(currentValidGoldSquares, index)
				print("GOLD SQUARES UPDATE - there are " ..(#currentValidGoldSquares) .." squares available for " ..goldSectorsRemaining .." gold.")
				pickedRegionSquare = false
			end
			
		end
		
	end
	
	-- setting up squares for STONE tactical regions
	-- create a temp table to hold region locations for testing distance. The regionSquaresList will need to be preserved for further distance checks
	currentValidStoneSquares = {}
	for index = 1, (#regionSquaresList) do
		x = regionSquaresList[index][1]
		y = regionSquaresList[index][2]
		
		if ((#terrainTypesForRegions) > 0) then
							
			for tIndex = 1, (#terrainTypesForRegions) do
			
				if (terrainLayoutResult[x][y].terrainType == terrainTypesForRegions[tIndex]) then
					table.insert(currentValidStoneSquares, regionSquaresList[index])
				end
				
			end
			
		else
			print("ERROR: There are no valid terrain types in the table in which to place regions. Aborting function.")
			return
		end
		
	end
	print((#currentValidStoneSquares) .." are currently available to place tactical regions.")
	
	print("PLACING STONE TACTICAL REGIONS...")
	print("GOLD REMAINING: " ..goldSectorsRemaining .." STONE REMAINING: " ..stoneSectorsRemaining)
	while (stoneSectorsRemaining > 0 and (#currentValidStoneSquares) > 0) do
	
		pickedRegionType = false
		
		while (pickedRegionType == false) do
			regionChosen = GetRandomElement(regionTypeList)
			print("Stone in region chosen is " ..regionChosen.numStone .." Stone remaining is " ..stoneSectorsRemaining)
			
			if (regionChosen.numStone > 0 and regionChosen.numGold < 1) then
			
				if (regionChosen.numStone <= stoneSectorsRemaining) then
					print("There is enough stone remaining to cover the chosen region.")
					pickedRegionType = true
				else
					print("Too much stone in region type. Picking another region type...")
					pickedRegionType = false
				end
				
			else
				print("Region chosen is not a stone tactical region. Choosing another region type.")
				pickedRegionType = false
			end
			
		end
		
		pickedRegionSquare = false
		
		while (pickedRegionSquare == false and (#currentValidStoneSquares) > 0) do
		
			index = Round((worldGetRandom() - 1E-10) * ((#currentValidStoneSquares) - 1), 0) + 1
			location = currentValidStoneSquares[index]
			x = location[1]
			y = location[2]
			print("There are currently " ..(#tacticalResourcePositions) .." region locations in the list to check distance on")
			if ((#tacticalResourcePositions) < 1) then
				table.insert(tacticalResourcePositions, {x, y})
				terrainLayoutResult[x][y].terrainType = regionChosen.tt
				totalStonePlaced = totalStonePlaced + regionChosen.numStone
				stoneSectorsRemaining = stoneSectorsRemaining - regionChosen.numStone
				print("Region placed at " ..x ..", " ..y .." Stone remaining: " ..stoneSectorsRemaining)
				print("Adding tactical resource square at " ..x ..", " ..y)
				
				-- re-set the valid squares for next region placement
				currentValidStoneSquares = {}
				for index = 1, (#regionSquaresList) do
					x = regionSquaresList[index][1]
					y = regionSquaresList[index][2]
					
					if ((#terrainTypesForRegions) > 0) then
								
						for tIndex = 1, (#terrainTypesForRegions) do
						
							if (terrainLayoutResult[x][y].terrainType == terrainTypesForRegions[tIndex]) then
								table.insert(currentValidStoneSquares, regionSquaresList[index])
							end
							
						end
						
					else
						print("ERROR: There are no valid terrain types in the table in which to place regions. Aborting function.")
						return
					end
			
				end
								
				print("STONE SQUARES UPDATE - there are " ..(#currentValidStoneSquares) .." squares available for " ..stoneSectorsRemaining .." stone.")
				pickedRegionSquare = true
				
			elseif (SquaresFarEnoughApartEuclidian(x, y, distanceFromRegions, tacticalResourcePositions, gridSize) == true) then
				table.insert(tacticalResourcePositions, {x, y})
				terrainLayoutResult[x][y].terrainType = regionChosen.tt
				totalStonePlaced = totalStonePlaced + regionChosen.numStone
				stoneSectorsRemaining = stoneSectorsRemaining - regionChosen.numStone
				print("Region placed at " ..x ..", " ..y ..". Gold remaining: " ..goldSectorsRemaining .." Stone remaining: " ..stoneSectorsRemaining)
				print("Adding tactical resource square at " ..x ..", " ..y)
				
				-- re-set the valid squares for next region placement
				currentValidStoneSquares = {}
				for index = 1, (#regionSquaresList) do
					x = regionSquaresList[index][1]
					y = regionSquaresList[index][2]
					
					if ((#terrainTypesForRegions) > 0) then
								
						for tIndex = 1, (#terrainTypesForRegions) do
						
							if (terrainLayoutResult[x][y].terrainType == terrainTypesForRegions[tIndex]) then
								table.insert(currentValidStoneSquares, regionSquaresList[index])
							end
							
						end
						
					else
						print("ERROR: There are no valid terrain types in the table in which to place regions. Aborting function.")
						return
					end
					
				end
				
				print("STONE SQUARES UPDATE - there are " ..(#currentValidStoneSquares) .." squares available for " ..stoneSectorsRemaining .." stone.")
				pickedRegionSquare = true
				
			else
				print("NO REGIONS PLACED THIS PASS")
				table.remove(currentValidStoneSquares, index)
				print("STONE SQUARES UPDATE - there are " ..(#currentValidStoneSquares) .." squares available for " ..stoneSectorsRemaining .." stone.")
				pickedRegionSquare = false
			end
			
		end
		
	end
	
	print("TOTAL GOLD PLACED: " ..totalGoldPlaced .." TOTAL STONE PLACED: " ..totalStonePlaced)

end
