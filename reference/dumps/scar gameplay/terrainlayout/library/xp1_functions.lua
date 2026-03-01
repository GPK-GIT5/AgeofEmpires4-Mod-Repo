-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment

function MapDivisions()
	mapCentre = math.ceil(mapScope/2)
	mapThird = math.ceil(mapScope/3)
	mapFourth = math.ceil(mapScope/4)
	mapFifth = math.ceil(mapScope/5)
	mapSixth = math.ceil(mapScope/6)
	mapSeventh = math.ceil(mapScope/7)
	mapEighth = math.ceil(mapScope/8)
 end

 function TableContainCoordinates(theTable, value)
	 local doesContain = false
	 
	 for tableIndex, information in ipairs(theTable) do
		 if (information[1] == value[1] and information[2] == value[2]) then
			 return true
		 end
	 end
	 
	 return doesContain
 end
 
 function DistanceFromEdge(sourceRow, sourceColumn, edgeDistance)
	 if ((sourceRow - edgeDistance) > 0) and ((sourceRow + edgeDistance) <= mapScope) then
		 if ((sourceColumn - edgeDistance) > 0) and ((sourceColumn + edgeDistance) <= mapScope) then
			 return true
		 end
	 end
 
	 -- Returns false if the source is outside of the legal area.
	 return false
 end
 
 function WeightedSelection(selectionTable)
	local sumWeight = 0
	for selectionTableIndex, information in ipairs(selectionTable) do
	  sumWeight = sumWeight + information[2]
	  print(sumWeight)
	end
 
	local randomValue = worldGetRandom() * sumWeight
	local chosenSelection = nil
 
	for selectionTableIndex, information in pairs(selectionTable) do
	  if randomValue < information[2] then
 
		 chosenSelection = information[1]
		 break
	  else
		 randomValue = randomValue - information[2]
	  end
	end
 
	return chosenSelection
 end

 function ReturnProximity(originRow, originColumn, detectionRadius, returnShape)		
	 local neighbourContainer_Internal = {}
	 MapGen_ReturnProximity_Internal(originRow, originColumn, detectionRadius, returnShape, mapScope, neighbourContainer_Internal)
	 return neighbourContainer_Internal
 end
 
 function ToDecimal(conversionValue)
	 if (type(conversionValue) ~= "number") or (conversionValue == 0) then
		 print("ERROR (ToDecimal): The conversion value must be a number and must not be zero.")
		 return
	 end
 
	 return (conversionValue / 100)
 end
 
 function PercentageSize(percentage)
	 reformed = Round(mapCentre * (percentage / 100))
	 return reformed
 end
 
 function IncludeScaling()
	baseMapSize = 416
	tinyMapSize = 416 -- Tiny Map / 2 Players
	smallMapSize = 512 -- Small Map / 3 Players
	mediumMapSize = 640 -- Medium Map / 4 Players
	largeMapSize = 768 -- Large Map / 6 Players
	hugeMapSize = 896 -- Huge Map / 8 Players
 
	-- Checks what map size is being used.
	if (worldTerrainHeight == tinyMapSize) or (worldTerrainWidth == tinyMapSize) then
	  isTinyMap = true
	  mapSizeName = "Tiny"
	  mapTotal = tinyMapSize * tinyMapSize
	  mapScale = tinyMapSize / baseMapSize
	  mapRatio = mapTotal / (baseMapSize * baseMapSize)
	elseif (worldTerrainHeight == smallMapSize) or (worldTerrainWidth == smallMapSize) then
	  isSmallMap = true
	  mapSizeName = "Small"
	  mapTotal = smallMapSize * smallMapSize
	  mapScale = smallMapSize / baseMapSize
	  mapRatio = mapTotal / (baseMapSize * baseMapSize)
	elseif (worldTerrainHeight == mediumMapSize) or (worldTerrainWidth == mediumMapSize) then
	  isMediumMap = true
	  mapSizeName = "Medium"
	  mapTotal = mediumMapSize * mediumMapSize
	  mapScale = mediumMapSize / baseMapSize
	  mapRatio = mapTotal / (baseMapSize * baseMapSize)
	elseif (worldTerrainHeight == largeMapSize) or (worldTerrainWidth == largeMapSize) then
	  isLargeMap = true
	  mapSizeName = "Large"
	  mapTotal = largeMapSize * largeMapSize
	  mapScale = largeMapSize / baseMapSize
	  mapRatio = mapTotal / (baseMapSize * baseMapSize)
	 elseif (worldTerrainHeight == hugeMapSize) or (worldTerrainWidth == hugeMapSize) then
		 isHugeMap = true
		 mapSizeName = "Huge"
		 mapTotal = hugeMapSize * hugeMapSize
		 mapScale = hugeMapSize / baseMapSize
		 mapRatio = mapTotal / (baseMapSize * baseMapSize)
	 else
		 if (enableDebugging == true) then
			 print("Map size could not be retrieved, something is wrong!")
		 end
	end
 
	 function ScaleByMapSize(theValue, scaleMethod, enableRounding)
		 if (scaleMethod == true) then
			scaleType = mapScale
		 else
			scaleType = mapRatio
		 end
	  
		 if (enableRounding == true) then
			return Round(theValue * scaleType)
		 else
			return theValue * scaleType
		 end
	 end
	 
	 playerCount = worldPlayerCount
 
	-- Checks what player count the game has.
	if (playerCount == nil) then
	  if (enableDebugging == true) then
		 print("Player number could not be retrieved, something is wrong!")
	  end
	elseif (playerCount < 1) then
	  isZeroPlayerGame = true
	elseif (playerCount == 1) then
	  isOnePlayerGame = true
	elseif (playerCount == 2) then
	  isTwoPlayerGame = true
	elseif (playerCount == 3) then
	  isThreePlayerGame = true
	elseif (playerCount == 4) then
	  isFourPlayerGame = true
	elseif (playerCount == 5) then
	  isFivePlayerGame = true
	elseif (playerCount == 6) then
	  isSixPlayerGame = true
	elseif (playerCount == 7) then
	  isSevenPlayerGame = true
	elseif (playerCount == 8) then
	  isEightPlayerGame = true
	else
	  print("Too many players selected.")
	end
 
	function ScaleByPlayerNumber(input, reverse, round)
	  if (reverse == true) then
		 output = input / playerCount
	  else
		 output = input * playerCount
	  end
 
	  if (round == true) then
		 return Round(output)
	  else
		 return output
	  end
	end
 end
 
 -- Obsolete
 function GetNeighborsIndex(xLocation, yLocation, terrainGrid)
 
	 mapScope = #terrainGrid
	 neighborContainer = {}
	 
	 -- Get above neighbor, unless it's on the first row.
	 if(yLocation > 0) and (yLocation < mapScope) then
		 currentRow = xLocation
		 currentColumn = yLocation + 1
		 terrainType = terrainGrid[currentRow][currentColumn].terrainType
 
		 currentInfo = {}
		 currentInfo = {currentRow, currentColumn, terrainType}
		 table.insert(neighborContainer, currentInfo)
	 end
	 
	 -- Get left neighbor, unless it's on the first row.
	 if(xLocation > 1) and (xLocation <= mapScope) then
		 currentRow = xLocation - 1
		 currentColumn = yLocation
		 terrainType = terrainGrid[currentRow][currentColumn].terrainType
 
		 currentInfo = {}
		 currentInfo = {currentRow, currentColumn, terrainType}
		 table.insert(neighborContainer, currentInfo)
	 end
	 
	 -- Get right neighbor, unless it's on the first row.
	 if(xLocation < mapScope) and (xLocation > 0) then
		 currentRow = xLocation + 1
		 currentColumn = yLocation
		 terrainType = terrainGrid[currentRow][currentColumn].terrainType
 
		 currentInfo = {}
		 currentInfo = {currentRow, currentColumn, terrainType}
		 table.insert(neighborContainer, currentInfo)
	 end
	 
	 -- Get below neighbor, unless it's on the first row.
	 if(yLocation <= mapScope) and (yLocation > 1) then
		 currentRow = xLocation
		 currentColumn = yLocation - 1
		 terrainType = terrainGrid[currentRow][currentColumn].terrainType
 
		 currentInfo = {}
		 currentInfo = {currentRow, currentColumn, terrainType}
		 table.insert(neighborContainer, currentInfo)
	 end
	 
	 return neighborContainer
 end
 
 function BucketTool(sourceRow, sourceColumn, sourceTerrain, allowLeakage)
	 if (allowLeakage == true) then
		 detectionMethod = "square"
	 else
		 detectionMethod = "cross"
	 end
 
	 local openingTerrain = terrainGrid[sourceRow][sourceColumn].terrainType
	 terrainGrid[sourceRow][sourceColumn].terrainType = sourceTerrain
	 local tileFlow = {}
	 local tileInformation = {}
	 local tileInformation = {sourceRow, sourceColumn}
	 table.insert(tileFlow, tileInformation)
 
	 while (#tileFlow > 0) do
		 local expansionFlow = {}
 
		 for tileFlowIndex, tileInformation in ipairs(tileFlow) do
			 tileFlowRow, tileFlowColumn = table.unpack(tileInformation)
 
			 local tileProximity = ReturnProximity(tileFlowRow, tileFlowColumn, 1, detectionMethod)
 
			 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
				 tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
 
				 local examineTerrain = terrainGrid[tileProximityRow][tileProximityColumn].terrainType
 
				 if (examineTerrain == openingTerrain) then
					 local tileInformation = {}
					 local tileInformation = {tileProximityRow, tileProximityColumn}
					 table.insert(expansionFlow, tileInformation)
				 end
			 end
		 end
 
		 tileFlow = {}
		 if (#expansionFlow > 0) then
			 for expansionFlowIndex, tileInformation in ipairs(expansionFlow) do
				 expansionFlowRow, expansionFlowColumn = table.unpack(tileInformation)
 
				 local tileInformation = {}
				 local tileInformation = {expansionFlowRow, expansionFlowColumn}
				 table.insert(tileFlow, tileInformation)
 
				 terrainGrid[expansionFlowRow][expansionFlowColumn].terrainType = sourceTerrain
			 end
		 end
	 end
 end
 
 -- Obsolete
 function CreateCornerLand(cornerPosition, cornerSize, cornerTerrain, cornerVariance, cornerIterations)
	 masterLand = {}
	 masterEdge = {}
 
	 for currentRow = 1, mapScope do
		 for currentColumn = 1, mapScope do
			 -- Checks for what corner to start the land generation.
			 if(cornerPosition == "top") then
				 currentDistance = GetDistance(1, 1, currentRow, currentColumn, 2)
			 elseif(cornerPosition == "left") then
				 currentDistance = GetDistance(1, (mapScope), currentRow, currentColumn, 2)
			 elseif(cornerPosition == "right") then
				 currentDistance = GetDistance((mapScope), 1, currentRow, currentColumn, 2)
			 elseif(cornerPosition == "bottom") then
				 currentDistance = GetDistance((mapScope), (mapScope), currentRow, currentColumn, 2)
			 end
			 
			 -- Locates all tiles within the radius/size.
			 if(currentDistance <= PercentageSize(cornerSize)) then
				 tileInformation = {}
				 tileInformation = {currentRow, currentColumn}
				 table.insert(masterLand, tileInformation)
			 end
		 end
	 end
 
	 -- If variance is defined, then look for all the tiles that are at the edge of the master land.
	 if(cornerVariance > 0) then
		 for masterLandIndex, coordinates in ipairs(masterLand) do
			 masterRow, masterColumn = table.unpack(coordinates)
 
			 masterNeighbors = {}
			 masterNeighbors = GetNeighborsIndex(masterRow, masterColumn, terrainLayoutResult)
 
			 -- Go through all the neighbors of the tiles.
			 for masterNeighborsIndex, coordinate in ipairs(masterNeighbors) do
				 masterNeighborRow, masterNeighborColumn = table.unpack(coordinate)
 
				 currentInfo = {}
				 currentInfo = {masterNeighborRow, masterNeighborColumn}
 
				 -- If the neighbor is not in the master land, it must be immediately adjacent to it - save it.
				 if (Table_ContainsCoordinateIndex(masterLand, currentInfo) == false) then
					 currentCoordinates = {}
					 currentCoordinates = {masterNeighborRow, masterNeighborColumn}
					 table.insert(masterEdge, currentCoordinates)
				 end
			 end
		 end
	 end
 
	 -- If variance is defined, go through each of the tiles in master edge.
	 -- Depending on the variance chance, add it to the master land and expand the master edge.
	 -- Repeat this as many times as defined in iterations.
	 if (cornerVariance > 0) then
		 while (cornerIterations > 0) do
			 temporaryEdge = {}
			 invalid = {} 
 
			 for masterEdgeIndex, coordinates in ipairs(masterEdge) do
				 masterEdgeRow, masterEdgeColumn = table.unpack(coordinates)
				 
				 if(worldGetRandom() < (cornerVariance/100)) then
					 currentInfo = {}
					 currentInfo = {masterEdgeRow, masterEdgeColumn}
					 table.insert(masterLand, currentInfo)
 
					 newNeighbors = {}
					 newNeighbors = GetNeighborsIndex(masterEdgeRow, masterEdgeColumn, terrainLayoutResult)
 
					 for newNeighborsIndex, coordinates in ipairs(newNeighbors) do
						 edgeNeighborRow, edgeNeighborColumn = table.unpack(coordinates)
		 
						 currentInfo = {}
						 currentInfo = {edgeNeighborRow, edgeNeighborColumn}
		 
						 -- If the neighbor is not in the master land, it must be immediately adjacent to it - save it.
						 if (Table_ContainsCoordinateIndex(masterLand, currentInfo) == false) and (Table_ContainsCoordinateIndex(masterEdge, currentInfo) == false) and (Table_ContainsCoordinateIndex(invalid, currentInfo) == false) then
							 currentInfo = {}
							 currentInfo = {edgeNeighborRow, edgeNeighborColumn}
							 table.insert(temporaryEdge, currentInfo)
							 table.insert(invalid, currentInfo)
						 end
					 end
				 end
			 end
		 
			 for temporaryEdgeIndex, coordinates in ipairs(temporaryEdge) do
				 temporaryEdgeRow, temporaryEdgeColumn = table.unpack(coordinates)
		 
				 currentInfo = {}
				 currentInfo = {temporaryEdgeRow, temporaryEdgeColumn}
		 
				 table.insert(masterEdge, currentInfo)
			 end
 
			 cornerIterations = cornerIterations - 1
		 end
	 end
 
	 -- Changes all tiles to the defined terrain.
	 for masterLandIndex, coordinate in ipairs(masterLand) do
		 masterRow = coordinate[1] 
		 masterColumn = coordinate[2]
		 terrainLayoutResult[masterRow][masterColumn].terrainType = cornerTerrain
	 end
 end
 
 function CreateTerrainClumps(newTerrain, sourceTerrain, generationChance, breakingChance, minimumDistance, separationDistance, avoidanceDistance, edgeAvoidance, scopePrecision, clumpRadius, clumpShape)
 
	 -- Lots of error handling for wrong inputs.
	 if (type(newTerrain) == "nil") and (type(newTerrain) ~= "table") then
		 print("ERROR: The terrain being applied must be a single terrain or a table with sub-tables, including the terrains and generation weight.")
		 return
	 end
 
	 if (type(newTerrain) == "table") then
		 for newTerrainIndex, information in ipairs(newTerrain) do
			 if (type(information) ~= "table") then
				 print("ERROR: When using multiple terrains, each terrain must be in a sub-table with the terrain name and the weight of the terrain.")
				 return
			 else
				 if (#information ~= 2) then
					 print("ERROR: The sub-table must only contain a terrain name and a generation weight.")
					 return
				 end
 
				 terrainType, terrainWeight = table.unpack(information)
				 if (type(terrainType) == "nil") or (type(terrainWeight) ~= "number") then
					 print("ERROR: One or more terrains are not valid or have does not have a valid weight.")
					 return
				 end
			 end
		 end
	 end
 
	 if (type(sourceTerrain) == "nil") then
		 print("ERROR: The source terrain being is not defined correctly.")
		 return
	 end
 
	 if (type(generationChance) ~= "number") or (generationChance < 0) or (generationChance > 100) then
		 print("ERROR: The generation chance must be an integer and must be between 0 and 100.")
		 return
	 end
 
	 if (type(breakingChance) ~= "number") or (generationChance < 0) or (generationChance > 100) then
		 print("ERROR: The breaking chance must be an integer and must be between 0 and 100.")
		 return
	 end
 
	 if (type(separationDistance) ~= "number") or (generationChance < 0) then
		 print("ERROR: The minimum distance must be an integer and must at least zero or above.")
		 return
	 end
 
	 if (type(avoidanceDistance) ~= "number") or (generationChance < 0) then
		 print("ERROR: The avoidance distance must be an integer and must be at least zero or above.")
		 return
	 end
 
	 if (type(scopePrecision) ~= "number") or (generationChance < 0) then
		 print("ERROR: The scope precision must be an integer and must be at least zero or above.")
		 return
	 end
 
	 -- Finds and stores all tiles that are not to be altered.
	 local forbiddenTerrains = {}
	 for currentRow = 1, mapScope do
		 for currentColumn = 1, mapScope do
			 if (terrainLayoutResult[currentRow][currentColumn].terrainType ~= sourceTerrain) then
				 currentInformation = {}
				 currentInformation = {currentRow, currentColumn}
				 table.insert(forbiddenTerrains, currentInformation)
			 end
		 end
	 end
 
	local clumpTable = {}
 
	 local currentRow = 1
	 while (currentRow <= mapScope) do
		 local currentColumn = 1
		 while (currentColumn <= mapScope) do
			 
			 -- Checks for the edge restrictions before running more comprehensive checks.
			 if (DistanceFromEdge(currentRow, currentColumn, edgeAvoidance) == true) then
 
				 -- Checks for the random generation chance before running more comprehensive checks.
				 if (worldGetRandom() < ToDecimal(generationChance)) then
					 local allowGeneration = true
					 local overrideGeneration = false
 
					 if (minimumDistance > 0) then
						 if (isZeroPlayerGame ~= true) then
							 for spawnPositionsIndex, tileInformation in ipairs(spawnPositions) do
								 local spawnPositionsRow, spawnPositionsColumn = table.unpack(tileInformation)
								 
								 local inDistance = GetDistance(currentRow, currentColumn, spawnPositionsRow, spawnPositionsColumn, 2)
								 
								 if (inDistance <= minimumDistance) then
									 allowGeneration = false
								 end
							 end
						 end
					 end
 
					 -- Checks if there is any clumps around the current tile, according to the minimum distance.
					 -- If there is any nearby clumps, it will not allow another one to generate.
					 for clumpTableIndex, information in ipairs(clumpTable) do
						 clumpTableRow, clumpTableColumn = table.unpack(information)
						 local inDistance = GetDistance(currentRow, currentColumn, clumpTableRow, clumpTableColumn, 2)
 
						 if (inDistance <= separationDistance) then
							 allowGeneration = false
						 end
					 end
 
					 -- Runs the breaking chance to create illigal variance where clumps would normally not be allowed to generate.
					 -- This only overrides the minimum distance - the generation chance and source terrain are still adhered to.
					 if (worldGetRandom() > ToDecimal(breakingChance)) then
						 overrideGeneration = true
					 end
 
					 -- If all previous checks are valid, then check whether any illigal terrains are nearby.
					 if (allowGeneration == true) or (overrideGeneration == true) then
						 local nearRestrictions = false
 
						 -- Runs through all the illigal terrains and checks if any one of them are in the avoidance range.
						 for forbiddenTerrainsIndex, information in ipairs(forbiddenTerrains) do
							 forbiddenTerrainsRow, forbiddenTerrainsColumn = table.unpack(information)
							 local inDistance = GetDistance(currentRow, currentColumn, forbiddenTerrainsRow, forbiddenTerrainsColumn, 2)
 
							 if (inDistance <= avoidanceDistance) then
								 nearRestrictions = true
							 end
						 end
						 
						 -- If all previous checks are valid, then check whether the terrain is placed on the source terrain.
						 if (nearRestrictions == false) and (terrainLayoutResult[currentRow][currentColumn].terrainType == sourceTerrain) then
							 local currentInformation = {}
							 local currentInformation = {currentRow, currentColumn}
							 table.insert(clumpTable, currentInformation)
						 end
					 end
				 end
			 end
			 currentColumn = currentColumn + scopePrecision
		 end
		 currentRow = currentRow + scopePrecision
	 end
 
	 function GenerateTerrain(sourceRow, sourceColumn, sourceTerrain)
		 if (type(sourceTerrain) == "table") then
			 terrainLayoutResult[sourceRow][sourceColumn].terrainType = WeightedSelection(sourceTerrain)
		 else
			 terrainLayoutResult[sourceRow][sourceColumn].terrainType = sourceTerrain
		 end
	 end
 
	 -- Finalise and paints all aforementioned tiles.
	 for clumpTableIndex, information in ipairs(clumpTable) do
		 clumpTableRow, clumpTableColumn = table.unpack(information)
 
			 -- If a clump radius have been defined, finds all the tiles around the origin tile.
		 if (clumpRadius > 0) then
			 local tileProximity = ReturnProximity(clumpTableRow, clumpTableColumn, clumpRadius, clumpShape)
			 for tileProximityIndex, information in ipairs(tileProximity) do
				 tileProximityRow, tileProximityColumn = table.unpack(information)
 
				 GenerateTerrain(tileProximityRow, tileProximityColumn, newTerrain)
			 end
		 else
			 GenerateTerrain(clumpTableRow, clumpTableColumn, newTerrain)
		 end
	 end
 end
 
 function RangeLimiter(input, min, max)
	 if (input < min) then
		 return min
	 elseif (input > max) then
		 return max
	 else
		 return input
	 end
 end
 
 function DetermineParity(number)
	 if (number % 2 == 0) then
		 return "even"
	 else
		 return "odd"
	 end
 end
 
 function RandomBetween(min, max)
	 return Normalize(worldGetRandom(), min, max)
 end
 
 function Rounding(input)
	 return (math.floor(input+0.5))
 end
 
 function DefineMapScope(base, min, max)
	 -- Scales the map scope according to map size.
	 local scopeValue = base * mapScale
 
	 -- Stops the map grid from exceeding an unreasonably high number on large map sizes.
	 local newScope = RangeLimiter(scopeValue, min, max)
	 
	 -- Rounds the map scope to a whole number.
	 local wholeScope = Rounding(newScope)
 
	 -- Forces the map scope to be an uneven number.
	 if (DetermineParity(wholeScope) == "even") then
		 return wholeScope + 1
	 else
		 return wholeScope
	 end
 end
 
 function PlayerSetup(originTerrain, ringRadius, positionVariance, rotationSetting, mirrorGeneration)
	 print("PLAYER SETUP ATTEMPTING TO INITIATE.")
 
	 if (type(ringRadius) ~= "number") then
		 print("ERROR: The specified ring radius must be a number.")
		 return
	 end
 
	 if (ringRadius < 0) or (ringRadius > 100) then
		 print("ERROR: The ring radius must be a value between 0 and 100.")
		 return
	 end
 
	 if (type(positionVariance) ~= "number") then
		 print("ERROR: The specified ring radius must be a number.")
		 return
	 end
 
	 if (type(rotationSetting) ~= "number") and (type(rotationSetting) ~= "boolean") then
		 print("ERROR: The rotation setting must be a specific number or a boolean set to either true or false.")
		 return
	 end
 
	 if (playerCount < 1) then
		 print("ERROR: No players found.")
		 return
	 end
		 
	 -- Setting up preliminary settings.
	 spawnPositions = {}
	 local baseNumber = 1
	 local playerCount = worldPlayerCount
	 local teamMappingTable = CreateTeamMappingTable()
 
	 if (type(rotationSetting) == "boolean") then
		 if (rotationSetting == true) then
			 rotationAmount = RandomBetween(0, 359)
		 else
			 rotationAmount = 0
		 end
	 elseif (type(rotationSetting) == "number") then
		 rotationAmount = rotationSetting
	 end
 
	 if (enableDebugging == true) then
		 if (rotationSetting == true) then
			 print("Rotation is enabled and set to " .. rotationAmount .. ".")
		 else
			 print("Rotation is disabled.")
		 end
	 end
	 
	 repeat
		 if (enableDebugging == true) then
			 print("Setting up position number " .. baseNumber .. ".")
		 end
 
		 -- Setting up positions.
		 local cosineCalculation = math.cos(2*math.pi*baseNumber/playerCount)
		 local sineCalculation = math.sin(2*math.pi*baseNumber/playerCount)
 
		 if (cosineCalculation == nil) or (sineCalculation == nil) then
			 print("ERROR: Positional calculations failed.")
			 return
		 else
			 if (enableDebugging == true) then
				 print("Consine Calulation: " .. cosineCalculation)
				 print("Sine Calulation: " .. sineCalculation)
			 end
		 end
 
		 if (mirrorGeneration == false) and (isTwoPlayerGame == true) then
			 trueRotation = rotationAmount
			 trueRotation = trueRotation + RandomBetween(-30, 30)
		 else
			 trueRotation = rotationAmount
		 end
 
		 -- Adds a random rotation to the circle.
		 local xRotation = sineCalculation*math.sin(trueRotation*math.pi/180)+cosineCalculation*math.cos(trueRotation*math.pi/180)
		 local yRotation = cosineCalculation*math.sin(trueRotation*math.pi/180)-sineCalculation*math.cos(trueRotation*math.pi/180)
 
		 if (xRotation == nil) or (yRotation == nil) then
			 print("ERROR: Rotational calculations failed.")
			 return
		 else
			 if (enableDebugging == true) then
				 print("Rotational Matrix X: " .. xRotation)
				 print("Rotational Matrix Y: " .. yRotation)
			 end
		 end
 
		 -- Corrects radius and have it scale relative to map size.
		 local xAbsolute = ((ringRadius/2)*(mapScope/100))*xRotation
		 local yAbsolute = ((ringRadius/2)*(mapScope/100))*yRotation
 
		 if (xAbsolute == nil) or (yAbsolute == nil) then
			 print("ERROR: Scaling calculations failed.")
			 return
		 else
			 if (enableDebugging == true) then
				 print("Scaled X: " .. xAbsolute)
				 print("Scaled Y: " .. yAbsolute)
			 end
		 end
 
		 -- Translating the positions relative to map size.
		 local xTranslate = xAbsolute+(mapScope/2)+0.5
		 local yTranslate = yAbsolute+(mapScope/2)+0.5
 
		 if (xTranslate == nil) or (yTranslate == nil) then
			 print("ERROR: Translational calculations failed.")
			 return
		 else
			 if (enableDebugging == true) then
				 print("Translation X: " .. xTranslate)
				 print("Translation Y: " .. yTranslate)
			 end
		 end
 
		 -- Creates random variance in the player positions.
		 local randomVariance = RandomBetween(-positionVariance, positionVariance)
		 local xCoordinate = Rounding(xTranslate+randomVariance)
		 local yCoordinate = Rounding(yTranslate+randomVariance)
 
		 if (enableDebugging == true) then
			 if (positionVariance < 0) then
				 print("Positional variance must be zero or a positive number. Terminating player placement!")
			 elseif (positionVariance > 0) then
				 print("Positional variance is enabled. The original position is " .. Rounding(xTranslate) .. "," .. Rounding(yTranslate))
			 else
				 print("Positional variation is set to zero and therefore disabled.")
			 end
		 end
 
		 local currentInfo = {}
		 local currentInfo = {xCoordinate, yCoordinate}
		 table.insert(spawnPositions, currentInfo)
 
		 -- Iteration and player.
		 baseNumber = baseNumber + 1
 
		 if (enableDebugging == true) then
			 print("Creating valid spawn location at position " .. xCoordinate .. "," .. yCoordinate)
		 end
	 until(baseNumber == playerCount + 1)
 
	 usablePositions = {}
	 for spawnPositionsIndex, spawnInformation in ipairs(spawnPositions) do
		 table.insert(usablePositions, spawnInformation)
	 end	
 
	 -- Assigning all players.
	 -- Checking whether the game has any teams at all.
	 if (#teamMappingTable > 0) then
		 local currentPlayerCount = 1
		 local teamCount = #teamMappingTable
 
		 -- Looping through all the teams.
		 for teamIndex = 1, teamCount do
			 local randomSelection = math.ceil(worldGetRandom() * #teamMappingTable)
			 print("Placing all players for team " .. randomSelection .. ".")
 
			 -- Checks if there are any players in currently selected team.
			 if (teamMappingTable[randomSelection].playerCount > 0) then
 
				 -- Looping through all the players on the currently selected team.
				 for playerIndex = 1, #teamMappingTable[randomSelection].players do
 
					 -- Unpacks next available position in the spawn positions array.
					 if (randomPositions == true) then
						 randomPosition = math.ceil(worldGetRandom() * #usablePositions)
						 availableRow, availableColoumn = table.unpack(usablePositions[randomPosition])
					 else
						 availableRow, availableColoumn = table.unpack(usablePositions[currentPlayerCount])
					 end
 
					 currentPlayerID = teamMappingTable[randomSelection].players[playerIndex].playerID
					 terrainGrid[availableRow][availableColoumn].terrainType = originTerrain
					 terrainGrid[availableRow][availableColoumn].playerIndex = currentPlayerID - 1
					 teamMappingTable[randomSelection].players[playerIndex].startRow = availableRow
					 teamMappingTable[randomSelection].players[playerIndex].startCol = availableColoumn
 
					 print("Placing relative team-player " .. playerIndex .. " from team " .. randomSelection .. " at " .. availableRow .. "," .. availableColoumn .. ".")
 
					 if (randomPositions == true) then
						 table.remove(usablePositions, randomPosition)
					 else
						 currentPlayerCount = currentPlayerCount + 1
					 end
				 end
			 end
 
			 table.remove(teamMappingTable, randomSelection)
		 end
	 end
 
	 playerSetupCompleted = true
	 print("PLAYER SETUP CONCLUDED SUCCESSFULLY.")
 end
 
 function CreateConnection(openingRow, openingColumn, closingRow, closingColumn, replaceTerrain, connectionTerrain, connectionWidth, enableMeander)
	 if (meander == true) then
		 meanderValue = 0.5
	 else
		 meanderValue = 2
	 end
 
	 local currentRow = openingRow
	 local currentColumn = openingColumn
	 
	 while (currentRow ~= closingRow) or (currentColumn ~= closingColumn) do
		 if (currentRow < closingRow) then
			 if (worldGetRandom() < meanderValue) then
 
				 currentRow = currentRow + 1
			 end
		 elseif (currentRow > closingRow) then
			 if (worldGetRandom() < meanderValue) then
 
				 currentRow = currentRow - 1
			 end
		 end
 
		 if (currentColumn < closingColumn) then
			 if (worldGetRandom() < meanderValue) then
 
				 currentColumn = currentColumn + 1
			 end
		 elseif (currentColumn > closingColumn) then
			 if (worldGetRandom() < meanderValue) then
 
				 currentColumn = currentColumn - 1
			 end
		 end
 
		 if (connectionWidth > 0) then
			 local tileProximity = ReturnProximity(currentRow, currentColumn, connectionWidth, "square")
			 for tileProximityIndex, information in ipairs(tileProximity) do
				 tileProximityRow, tileProximityColumn = table.unpack(information)
 
				 for replaceTerrainIndex, currentTerrain in ipairs(replaceTerrain) do
					 if (terrainGrid[tileProximityRow][tileProximityColumn].terrainType == currentTerrain) then
						 terrainLayoutResult[tileProximityRow][tileProximityColumn].terrainType = connectionTerrain
					 end
				 end
			 end
		 else
			 for replaceTerrainIndex, currentTerrain in ipairs(replaceTerrain) do
				 if (terrainGrid[currentRow][currentColumn].terrainType == currentTerrain) then
					 terrainLayoutResult[currentRow][currentColumn].terrainType = connectionTerrain
				 end
			 end
		 end
	 end
 end
 
 -- Obsolete
 function ModifyEdge(originTerrain, edgeTerrain, generationChance)
	 edgeTable = {}
	 
	 for currentRow = 1, mapScope do
		 for currentColumn = 1, mapScope do
			 allowGeneration = false
 
			 if (terrainLayoutResult[currentRow][currentColumn].terrainType == originTerrain) then
				 local tileProximity = ReturnProximity(currentRow, currentColumn, 1, "square")
 
				 for tileProximityIndex, information in ipairs(tileProximity) do
					 tileProximityRow, tileProximityColumn = table.unpack(information)
 
					 if (terrainLayoutResult[tileProximityRow][tileProximityColumn].terrainType == baseTerrain) then
						 allowGeneration = true
					 end
				 end
			 end
 
			 if (allowGeneration == true) then
				 if (worldGetRandom() > (generationChance/100)) then
					 terrainLayoutResult[currentRow][currentColumn].terrainType = edgeTerrain
				 end
			 end
		 end
	 end
 end
 
 function CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)
	 baseTable = {}
	 additionTable = {}
	 edgeTable = {}
	 startingTerrain = terrainGrid[originRow][originColumn].terrainType
 
	 for theRow = 1, mapScope do
		 for theColumn = 1, mapScope do
			 local inRange = GetDistance(originRow, originColumn, theRow, theColumn, 2)
 
			 if (baseRatio == true) then
				 rangeCompare = PercentageSize(baseRadius)
			 else
				 rangeCompare = baseRadius
			 end
			 
			 -- Locates all tiles within the radius/size.
			 if(inRange <= rangeCompare) then
				 local allowGeneration = true
 
				 if (avoidanceDistance > 0) then
					 local tileProximity = ReturnProximity(theRow, theColumn, avoidanceDistance, "square")
 
					 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
						 local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
 
						 if (CheckTerrain(tileProximityRow, tileProximityColumn, startingTerrain) ~= true) and (CheckTerrain(tileProximityRow, tileProximityColumn, placeholderTerrain) ~= true) then
								 allowGeneration = false
						 end
					 end
				 end
 
				 if (edgeAvoidance > 0) then
					 if (DistanceFromEdge(theRow, theColumn, edgeAvoidance) == false) then
						 allowGeneration = false
					 end
				 end
 
				 if (allowGeneration == true) then
					 local tileInformation = {}
					 local tileInformation = {theRow, theColumn}
					 table.insert(baseTable, tileInformation)
				 end
			 end
		 end
	 end
 
	 if (tileAmount > 0) then
		 for baseTableIndex, tileInformation in ipairs(baseTable) do
			 local baseTableRow, baseTableColumn = table.unpack(tileInformation)
 
			 local tileProximity = ReturnProximity(baseTableRow, baseTableColumn, 1, "cross")
 
			 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
				 local additionRow, additionColumn = table.unpack(tileInformation)
				 
				 local examineTile = {}
				 local examineTile = {additionRow, additionColumn}
 
				 -- Locates all surrounding tiles and removes the chance of duplicate tiles saved.
				 if (TableContainCoordinates(baseTable, examineTile) == false) then
					 if (TableContainCoordinates(additionTable, examineTile) == false) then
						 local allowGeneration = true
 
						 if (avoidanceDistance > 0) then
							 local tileProximity = ReturnProximity(additionRow, additionColumn, avoidanceDistance, "circular")
		 
							 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
								 local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
		 
								 if (CheckTerrain(tileProximityRow, tileProximityColumn, startingTerrain) ~= true) and (CheckTerrain(tileProximityRow, tileProximityColumn, placeholderTerrain) ~= true) then
										 allowGeneration = false
								 end
							 end
						 end
 
						 if (edgeAvoidance > 0) then
							 if (DistanceFromEdge(additionRow, additionColumn, edgeAvoidance) == false) then
								 allowGeneration = false
							 end
						 end
		 
						 if (allowGeneration == true) then
							 table.insert(additionTable, examineTile)
						 end
					 end
				 end
			 end
		 end
 
		 while (tileAmount > 0) do
			 if (#additionTable < 1) then
				 break
			 else
				 local randomSelection = math.ceil(worldGetRandom() * #additionTable)
				 local chosenTile = additionTable[randomSelection]
				 local chosenTileRow, chosenTileColumn = table.unpack(chosenTile)
 
				 local chosenProximity = ReturnProximity(chosenTileRow, chosenTileColumn, 1, "cross")
		 
				 for chosenProximityIndex, tileInformation in ipairs(chosenProximity) do
					 local chosenProximityRow, chosenProximityColumn = table.unpack(tileInformation)
				 
					 local examineTile = {}
					 local examineTile = {chosenProximityRow, chosenProximityColumn}
 
					 if (TableContainCoordinates(baseTable, examineTile) == false) then
						 if (TableContainCoordinates(additionTable, examineTile) == false) then
							 local allowGeneration = true
 
							 if (avoidanceDistance > 0) then
								 local tileProximity = ReturnProximity(chosenProximityRow, chosenProximityColumn, avoidanceDistance, "circular")
			 
								 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
									 local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
			 
									 if (CheckTerrain(tileProximityRow, tileProximityColumn, startingTerrain) ~= true) and (CheckTerrain(tileProximityRow, tileProximityColumn, placeholderTerrain) ~= true) then
										 allowGeneration = false
									 end
								 end
							 end
 
							 if (edgeAvoidance > 0) then
								 if (DistanceFromEdge(chosenProximityRow, chosenProximityColumn, edgeAvoidance) == false) then
									 allowGeneration = false
								 end
							 end
			 
							 if (allowGeneration == true) then
								 table.insert(additionTable, examineTile)
							 end
						 end
					 end
				 end
 
				 table.insert(baseTable, chosenTile)
				 table.remove(additionTable, randomSelection)
			 end
 
			 tileAmount = tileAmount - 1
		 end
	 end
 
	 for baseTableIndex, tileInformation in ipairs(baseTable) do
		 local baseTableRow, baseTableColumn = table.unpack(tileInformation)
		 terrainGrid[baseTableRow][baseTableColumn].terrainType = terrainType
	 end
 
	 for additionTableIndex, tileInformation in ipairs(additionTable) do
		 local additionTableRow, additionTableColumn = table.unpack(tileInformation)
		 terrainGrid[additionTableRow][additionTableColumn].terrainType = terrainType
	 end
 end
 
 function InsideMap(sourceRow, sourceColumn)
	return MapGen_InsideMap_Internal(sourceRow, sourceColumn, mapScope)
 end
 
 function CheckTerrain(sourceRow, sourceColumn, terrainCheck)
	 if (terrainGrid[sourceRow][sourceColumn].terrainType == terrainCheck) then
		 return true
	 else
		 return false
	 end
 end
 
function LocateClosest(sourceRow, sourceColumn, sourceTerrain, locateNumber, separationDistance, minimumDistance, maximumDistance, avoidanceDistance, edgeAvoidance, searchMethod)
	local returnTable = {}

	local function SearchCircle(sourceRow, sourceColumn, searchRadius)
		local neighborContainer = {}
		local openingRow = sourceRow - searchRadius
		local openingColumn = sourceColumn - searchRadius
		local rangeSize = searchRadius * 2

		for sizeRow = 0, rangeSize do
			for sizeColumn = 0, rangeSize do
				local rangeRow = sizeRow + openingRow
				local rangeColumn = sizeColumn + openingColumn

				if (InsideMap(rangeRow, rangeColumn) == true) then
					local currentDistance = GetDistance(sourceRow, sourceColumn, rangeRow, rangeColumn, 2)

					if (currentDistance <= searchRadius) and (currentDistance >= (searchRadius - 1)) then
						local currentInformation = {}
						local currentInformation = {rangeRow, rangeColumn}
						table.insert(neighborContainer, currentInformation)
					end
				end
			end
		end

		return neighborContainer
	end

	::DecreaseRestrictions::

	local searchRadius = minimumDistance
	local loopingCount = 1
	while (#returnTable < locateNumber) do
		if (searchRadius >= maximumDistance) then
			separationDistance = separationDistance - 1
			goto DecreaseRestrictions
		end
		

		local availableInRing = {}
		local circleTiles = SearchCircle(sourceRow, sourceColumn, searchRadius)
		searchRadius = searchRadius + 1


		for circleTilesIndex, tileInformation in ipairs(circleTiles) do
			circleTilesRow, circleTilesColumn = table.unpack(tileInformation)


			if (CheckTerrain(circleTilesRow, circleTilesColumn, sourceTerrain) == true) then


				local tileInformation = {}
				local tileInformation = {circleTilesRow, circleTilesColumn}
				table.insert(availableInRing, tileInformation)
			end
		end

		
		while (#availableInRing > 1) do


			if (#returnTable < locateNumber) then
				local allowGeneration = true
				local randomSelection = math.ceil(worldGetRandom() * #availableInRing)
				local conslusiveTile = availableInRing[randomSelection]
				local conslusiveRow, conslusiveColumn = table.unpack(conslusiveTile)
				local tileProximity = ReturnProximity(conslusiveRow, conslusiveColumn, separationDistance, "circular")

				for tileProximityIndex, tileInformation in ipairs(tileProximity) do

					if (TableContainCoordinates(returnTable, tileInformation) == true) then

						allowGeneration = false
						break
					end
				end

				if (ReviewAvoidanceDistance(conslusiveRow, conslusiveColumn, sourceTerrain, avoidanceDistance) == false) then

					allowGeneration = false
				end

				if (edgeAvoidance > 0) then
					if (DistanceFromEdge(conslusiveRow, conslusiveColumn, edgeAvoidance) == false) then

						allowGeneration = false
					end
				end

				if (allowGeneration == true) then


					table.insert(returnTable, conslusiveTile)
				end

				table.remove(availableInRing, randomSelection)
			else

				break
			end
		end

		loopingCount = loopingCount + 1
		if (loopingCount > (mapScope * 2)) then


			break
		end


	end

	return returnTable
end
 
 function BetweenPlayerGeneration(ringRadius, areaCount)
	 -- Setting up preliminary settings.
	 betweenPositions = {}
	 local baseNumber = 0
 
	 singleRotation = 360 / (playerCount * (areaCount + 1))
 
	 repeat
		 print("Checking Once" .. baseNumber)
		 areaIteration = 1
 
		 while (areaIteration < (areaCount + 1)) do
			 print("Checking Twice" .. areaIteration)
			 -- Setting up positions.
			 local cosineCalculation = math.cos(2*math.pi*baseNumber/playerCount)
			 local sineCalculation = math.sin(2*math.pi*baseNumber/playerCount)
 
			 if (cosineCalculation == nil) or (sineCalculation == nil) then
				 print("ERROR: Positional calculations failed.")
				 return
			 else
				 if (enableDebugging == true) then
					 print("Consine Calulation: " .. cosineCalculation)
					 print("Sine Calulation: " .. sineCalculation)
				 end
			 end
 
			 if (mirrorGeneration == false) and (isTwoPlayerGame == true) then
				 trueRotation = rotationAmount
				 trueRotation = trueRotation + RandomBetween(-30, 30)
			 else
				 trueRotation = rotationAmount
			 end
 
			 -- Adds a random rotation to the circle.
			 local xRotation = sineCalculation*math.sin((trueRotation + (singleRotation * areaIteration))*math.pi/180)+cosineCalculation*math.cos((trueRotation + (singleRotation * areaIteration))*math.pi/180)
			 local yRotation = cosineCalculation*math.sin((trueRotation + (singleRotation * areaIteration))*math.pi/180)-sineCalculation*math.cos((trueRotation + (singleRotation * areaIteration))*math.pi/180)
 
			 if (xRotation == nil) or (yRotation == nil) then
				 print("ERROR: Rotational calculations failed.")
				 return
			 else
				 if (enableDebugging == true) then
					 print("Rotational Matrix X: " .. xRotation)
					 print("Rotational Matrix Y: " .. yRotation)
				 end
			 end
 
			 -- Corrects radius and have it scale relative to map size.
			 local xAbsolute = ((ringRadius/2)*(mapScope/100))*xRotation
			 local yAbsolute = ((ringRadius/2)*(mapScope/100))*yRotation
 
			 if (xAbsolute == nil) or (yAbsolute == nil) then
				 print("ERROR: Scaling calculations failed.")
				 return
			 else
				 if (enableDebugging == true) then
					 print("Scaled X: " .. xAbsolute)
					 print("Scaled Y: " .. yAbsolute)
				 end
			 end
 
			 -- Translating the positions relative to map size.
			 local xTranslate = xAbsolute+(mapScope/2)+0.5
			 local yTranslate = yAbsolute+(mapScope/2)+0.5
 
			 if (xTranslate == nil) or (yTranslate == nil) then
				 print("ERROR: Translational calculations failed.")
				 return
			 else
				 if (enableDebugging == true) then
					 print("Translation X: " .. xTranslate)
					 print("Translation Y: " .. yTranslate)
				 end
			 end
 
			 local xCoordinate = Rounding(xTranslate)
			 local yCoordinate = Rounding(yTranslate)
 
 
			 local theInformation = {}
			 local theInformation = {xCoordinate, yCoordinate}
			 table.insert(betweenPositions, theInformation)
 
 
 
			 if (enableDebugging == true) then
				 print("Creating valid spawn-between location at position " .. xCoordinate .. "," .. yCoordinate)
			 end
 
			 areaIteration = areaIteration + 1
		 end
 
		 -- Iteration and player.
		 baseNumber = baseNumber + 1
	 until(baseNumber == playerCount)
 
	 return betweenPositions
 end
 
 function CreateSimultaneousLand(creationProperties)
	 creationTables = {}

	 for creationNumber = 1, #creationProperties do
		 noInformation = {}
		 table.insert(creationTables, noInformation)
 
		 local iterationTables = 3
		 for iterationNumber = 1, iterationTables do
			 noInformation = {}
			 table.insert(creationTables[creationNumber], noInformation)
		 end
	 end

	 for creationNumber = 1, #creationProperties do
		 baseTable = {}
		 enclosingTable = {}
		 chosenTable = {}

		 local terrainType = creationProperties[creationNumber][1]
		 local originRow = creationProperties[creationNumber][2]
		 local originColumn = creationProperties[creationNumber][3]
		 local tileAmount = creationProperties[creationNumber][4]
		 local tileRatio = creationProperties[creationNumber][5]
		 local baseRadius = creationProperties[creationNumber][6]
		 local baseRatio = creationProperties[creationNumber][7]
		 local edgeAvoidance = creationProperties[creationNumber][9]
		 local centreAvoidance = creationProperties[creationNumber][11]
		
		 if (tileRatio == true) then
			 conversionRatio = tileAmount / 100
			 conversionNumber = mapTotal * conversionRatio
			 creationProperties[creationNumber][4] = conversionNumber
		 end

		 if (baseRatio == true) then
			 rangeComparison = PercentageSize(baseRadius)
		 else
			 rangeComparison = baseRadius
		 end

		 scaleCentreAvoidance = PercentageSize(centreAvoidance)
		 creationProperties[creationNumber][11] = scaleCentreAvoidance
		 local centreAvoidance = scaleCentreAvoidance
 
		 startingTerrain = terrainGrid[originRow][originColumn].terrainType
 
		 if (startingTerrain == originTerrain) then
			 startingTerrain = baseTerrain
		 end
 
		 table.insert(creationProperties[creationNumber], startingTerrain)
 
		 tileAmountFixed = tileAmount
		 table.insert(creationProperties[creationNumber], tileAmountFixed)
 
 
		 local baseTable = {}
		 for theRow = 1, mapScope do
			 for theColumn = 1, mapScope do
				 local inRange = GetDistance(originRow, originColumn, theRow, theColumn, 2)
					 
				 -- Locates all tiles within the radius/size.
				 if(inRange <= rangeComparison) then
					 local allowGeneration = true
	 
					  --[[ Revisit if tiles missed should be placed later
					 if (avoidanceDistance > 0) then
						 local tileProximity = ReturnProximity(theRow, theColumn, avoidanceDistance, "square")
	 
						 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
							 local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
	 
							 if (CheckTerrain(tileProximityRow, tileProximityColumn, startingTerrain) ~= true) and (CheckTerrain(tileProximityRow, tileProximityColumn, placeholderTerrain) ~= true) then
									 allowGeneration = false
							 end
						 end
					 end --]]
					 
					 if (CheckTerrain(theRow, theColumn, originTerrain) == true) then
						 allowGeneration = false
					 end
	 
					 if (edgeAvoidance > 0) then
						 if (DistanceFromEdge(theRow, theColumn, edgeAvoidance) == false) then
							 allowGeneration = false
						 end
					 end
					 
					 --if (ReviewCentreAvoidance(theRow, theColumn, centreAvoidance) == false) then
					 --	allowGeneration = false
					 --end
	 
					 if (allowGeneration == true) then
						 local tileInformation = {}
						 local tileInformation = {theRow, theColumn}
						 table.insert(baseTable, tileInformation)
					 end
				 end
			 end
		 end
 
		 for baseTableIndex, baseTableInformation in ipairs(baseTable) do
			 local baseTableRow, baseTableColumn = table.unpack(baseTableInformation)
			 table.insert(creationTables[creationNumber][1], baseTableInformation)
 
			 local tileProximity = ReturnProximity(baseTableRow, baseTableColumn, 1, "cross")
 
			 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
				 local enclosingRow, enclosingColumn = table.unpack(tileInformation)
				 
				 if (TableContainCoordinates(baseTable, tileInformation) == false) then
					 if (TableContainCoordinates(enclosingTable, tileInformation) == false) then
						 local allowGeneration = true
 
						 if (edgeAvoidance > 0) then
							 if (DistanceFromEdge(enclosingRow, enclosingColumn, edgeAvoidance) ~= true) then
								 allowGeneration = false
							 end
						 end
 
						 if (ReviewCentreAvoidance(enclosingRow, enclosingColumn, centreAvoidance) == false) then
							 allowGeneration = false
						 end
		 
						 if (allowGeneration == true) then
							 table.insert(creationTables[creationNumber][2], tileInformation)
						 end
					 end
				 end
			 end
		 end
	 end
 
	 if (enableDebugging == true) then
		 for creationNumber = 1, #creationProperties do
			 print("Land Number: " .. creationNumber)
			 print("Base Length: " .. #creationTables[creationNumber][1])
			 print("Enclosing Length: " .. #creationTables[creationNumber][2])
			 print("Chosen Length: " .. #creationTables[creationNumber][3])
			 print("-------")
		 end
	 end
 

	 tilesRemaining = true
	 availableTiles = true
	 creationNumber = 0
	 
	 while (tilesRemaining == true) and (availableTiles == true) do
		 creationNumber = creationNumber + 1
 
		 local tileAmount = creationProperties[creationNumber][4]
		 local tileRatio = creationProperties[creationNumber][5]
		 local avoidanceDistance = creationProperties[creationNumber][8]
		 local edgeAvoidance = creationProperties[creationNumber][9]
		 local borderRadius = creationProperties[creationNumber][10]
		 local centreAvoidance = creationProperties[creationNumber][11]
		 local clumpingFactor = creationProperties[creationNumber][12]
		 local startingTerrain = creationProperties[creationNumber][13]
		 local tileTarget = creationProperties[creationNumber][143]
 
		 repeat
			 if (#creationTables[creationNumber][2] < 1) or (#creationTables[creationNumber][2] == nil) then
				 print("ABORT!")
				 break
			 end
 
			 -- A random tile from the enclosing table will be selected.
			 tileFound = false
			 local randomSelection = math.ceil(worldGetRandom() * #creationTables[creationNumber][2])
			 local chosenTile = creationTables[creationNumber][2][randomSelection]
			 local chosenTileRow, chosenTileColumn = table.unpack(chosenTile)
 
			 -- In case different lands have overlapped, check if the chosen tile is already in another table.
			 local inTable = false
			 for tableNumber = 1, #creationTables do
 
				 -- No need to check its own tables.
				 -- As soon as the tile has been found in another table, break out of the loop.
				 if (tableNumber ~= creationNumber) then
 
					 -- Checking the base table of other lands.
					 if (TableContainCoordinates(creationTables[tableNumber][1], chosenTile) == true) then
						 inTable = true
						 break
					 end
 
					 -- Checking the chosen table of other lands.
					 if (TableContainCoordinates(creationTables[tableNumber][3], chosenTile) == true) then
						 inTable = true
						 break
					 end
				 end
			 end
 
			 -- If the chosen tile was not found in any tables, other checks will commence.
			 if (inTable == false) then
				 allowGeneration = true
 
				 -- Find and store all tiles with a radius of the avoidance distance around the chosen tile.
				 local tileProximity = ReturnProximity(chosenTileRow, chosenTileColumn, avoidanceDistance, "circular")
 
				 -- Goes through each tile surrounding the chosen tile.
				 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
					 local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
 
					 -- If the selected tile is not the same terrain as the origin terrain, then do not allow tile to generate.
					 if (CheckTerrain(tileProximityRow, tileProximityColumn, startingTerrain) == false) and (CheckTerrain(tileProximityRow, tileProximityColumn, originTerrain) == false) then
						 allowGeneration = false
						 break
					 end
 
					 -- Checks if the selected tile is already in another table.
					 -- As soon as the tile has been found in another table, break out of the loop.
					 for tableNumber = 1, #creationTables do
 
						 if (tableNumber ~= creationNumber) then
						 -- Checking the base table of other lands.
							 if (TableContainCoordinates(creationTables[tableNumber][1], tileInformation) == true) then
								 allowGeneration = false
								 break
							 end
			 
							 -- Checking the base table of other lands.
							 if (TableContainCoordinates(creationTables[tableNumber][3], tileInformation) == true) then
								 allowGeneration = false
								 break
							 end
						 end
					 end
				 end
 
				 -- If rounded corners are enabled, check for all four corners.
				 if (borderRadius > 0) then
					 local circularProximity = ReturnProximity(mapCentre, mapCentre, borderRadius, "circular")
	 
					 if (TableContainCoordinates(circularProximity, chosenTile) == false) then
						 allowGeneration = false
					 end
				 end
 
				 if (worldGetRandom() < (clumpingFactor/100)) then
					 local tileProximity = ReturnProximity(chosenTileRow, chosenTileColumn, 1, "cross")
					 local clumpingTiles = 0
 
					 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
						 allowGeneration = false
						 
						 if (TableContainCoordinates(creationTables[creationNumber][1], tileInformation) == true) then
							 clumpingTiles = clumpingTiles + 1
 
							 if (clumpingTiles >= 2) then
								 allowGeneration = true
								 break
							 end
						 end
					 
						 if (TableContainCoordinates(creationTables[creationNumber][3], tileInformation) == true) then
							 clumpingTiles = clumpingTiles + 1
 
							 if (clumpingTiles >= 2) then
								 allowGeneration = true
								 break
							 end
						 end
					 end
 
					 if (clumpingTiles >= 2) then
						 clumpingSkip = true
					 end
				 end
	 
				 -- Checks if the chosen tile is inside the map.
				 if (edgeAvoidance > 0) then
					 if (DistanceFromEdge(chosenTileRow, chosenTileColumn, edgeAvoidance) ~= true) then
						 allowGeneration = false
					 end
				 end
			 
				 if (CheckTerrain(chosenTileRow, chosenTileColumn, originTerrain) == true) then
					 allowGeneration = false
				 end
 
				 if (ReviewCentreAvoidance(chosenTileRow, chosenTileColumn, centreAvoidance) == false) then
					 allowGeneration = false
				 end
			 end
 
			 -- If no checks failed, proceed to create the tile.
			 if (allowGeneration == true) then
				 tileFound = true
 
				 -- Stores the remaining tiles to be placed in the properties.
				 tileAmount = tileAmount - 1
				 creationProperties[creationNumber][4] = tileAmount
 
				 -- Inserts the tile in the chosen table and removes it from the enclosing table.
				 print("Tile placed for land number " .. creationNumber .. ".")
				 print("Position " .. chosenTileRow .. ", " .. chosenTileColumn .. ".")
				 table.insert(creationTables[creationNumber][3], chosenTile)
				 table.remove(creationTables[creationNumber][2], randomSelection)
 
				 -- Checks all tiles around the chosen tile, in a cross pattern.
				 local tileProximity = ReturnProximity(chosenTileRow, chosenTileColumn, 1, "cross")
 
				 -- Goes through each tile surrounding the chosen tile.
				 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
					 local inTable = false
 
					 -- Checks if the selected tile is already inside one of the tables.
					 for tableNumber = 1, #creationTables do
						 if (TableContainCoordinates(creationTables[tableNumber][1], tileInformation) == true) then
							 inTable = true
							 break
						 end
	 
						 if (TableContainCoordinates(creationTables[tableNumber][2], tileInformation) == true) then
							 inTable = true
							 break
						 end
	 
						 if (TableContainCoordinates(creationTables[tableNumber][3], tileInformation) == true) then
							 inTable = true
							 break
						 end
					 end
					 
					 -- If it's not in any of the tables, then save it as a new enclosing tile.
					 if (inTable == false) then
						 table.insert(creationTables[creationNumber][2], tileInformation)
					 end
				 end
			 else
				 print("The selected tile for land number " .. creationNumber .. " did not meet the requirements and is removed.")
				 table.remove(creationTables[creationNumber][2], randomSelection)
			 end
 
			 print("Remaining tiles to be placed: " .. creationProperties[creationNumber][4])
			 -- Repeat until a tile has been found or until there are no more available spots.
		 until (tileFound == true) or (#creationTables[creationNumber][2] < 1)
 
		 -- Once the number of lands has been reached, do it over again.
		 if (creationNumber >= #creationProperties) then
			 creationNumber = 0
		 end
 
		 tilesRemaining = false
		 for numberRemaining = 1, #creationProperties do
			 if (creationProperties[numberRemaining][4] > 0) then
 
				 print("Tiles remaining for land " .. numberRemaining .. " is " .. creationProperties[numberRemaining][4] .. ".")
				 tilesRemaining = true
			 end
		 end
 
		 availableTiles = false
		 for numberRemaining = 1, #creationProperties do
			 if (#creationTables[numberRemaining][2] > 0) then
 
				 print("Number of available spots remaing for land " .. numberRemaining .. " is " .. #creationTables[numberRemaining][2] .. ".")
				 availableTiles = true
			 end
		 end
 
	 end
 
	 if (enableDebugging == true) then
		 for creationNumber = 1, #creationTables do
			 print("Land Number: " .. creationNumber)
			 print("Base Length: " .. #creationTables[creationNumber][1])
			 print("Enclosing Length: " .. #creationTables[creationNumber][2])
			 print("Chosen Length: " .. #creationTables[creationNumber][3])
		 end
	 end
 
	 for creationNumber = 1, #creationTables do
		 for baseTableIndex, tileInformation in ipairs(creationTables[creationNumber][1]) do
			 local baseTableRow, baseTableColumn = table.unpack(tileInformation)
			 terrainGrid[baseTableRow][baseTableColumn].terrainType = creationProperties[creationNumber][1]
		 end
	 end
 
	 for creationNumber = 1, #creationTables do
		 for baseTableIndex, tileInformation in ipairs(creationTables[creationNumber][3]) do
			 local baseTableRow, baseTableColumn = table.unpack(tileInformation)
			 terrainGrid[baseTableRow][baseTableColumn].terrainType = creationProperties[creationNumber][1]
		 end
	 end
 end
 
 function OppositeNumber(theNumber)
	 return (mapScope - theNumber) + 1
 end
 
 function GenerateFromTable(tableName, terrainType)
	 for tableGenerationIndex, tileInformation in ipairs(tableName) do
		 local tableGenerationRow, tableGenerationColumn = table.unpack(tileInformation)
		 terrainGrid[tableGenerationRow][tableGenerationColumn].terrainType = terrainType
	 end
 end
 
 function SmoothTransition(locateTerrain, requireTerrain, transitionTerrains, terrainAmount, seperationDistance)
	 local transitionTable = {}
	 for terrainNumber = 1, #transitionTerrains do
		 noInformation = {}
		 table.insert(transitionTable, noInformation)
	 end
 
	 for theRow = 1, mapScope do
		 for theColumn = 1, mapScope do
			 if (CheckTerrain(theRow, theColumn, locateTerrain) == true) then
				 if (ReviewTable(transitionTable[1], theRow, theColumn, seperationDistance, "circular") == false) then
					 local allowGeneration = false
					 local tileProximity = ReturnProximity(theRow, theColumn, 1, "cross")
 
					 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
						 local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
 
						 if (CheckTerrain(tileProximityRow, tileProximityColumn, requireTerrain) == true) then
							 allowGeneration = true
							 break
						 end
					 end
 
					 if (allowGeneration == true) then
						 tileInformation = {}
						 tileInformation = {theRow, theColumn}
						 table.insert(transitionTable[1], tileInformation)
 
						 local neighboringTable = {}
						 local tileProximity = ReturnProximity(theRow, theColumn, 1, "square")
 
						 for tileProximityIndex, encloseInformation in ipairs(tileProximity) do
							 local encloseRow, encloseColumn = table.unpack(encloseInformation)
	 
							 if (CheckTerrain(encloseRow, encloseColumn, locateTerrain) == true) then
								 tileInformation = {}
								 tileInformation = {encloseRow, encloseColumn}
								 table.insert(transitionTable[2], tileInformation)
							 end
						 end
					 end
				 end
			 end
		 end
	 end
 
	 GenerateFromTable(transitionTable[2], transitionTerrains[2])
	 GenerateFromTable(transitionTable[1], transitionTerrains[1])
 end
 
 function CreateStraightConnection(startingRow, startingColumn, endingRow, endingColumn, connectionTerrain, tableOutput)
	 returnTable = {}
 
	 rowDifference = math.abs(endingRow - startingRow)
	 columnDifference = math.abs(endingColumn - startingColumn)
 
	 print("Row difference is " .. rowDifference)
	 print("Column difference is " .. columnDifference)
 
	 if(rowDifference > columnDifference) then
		 maximumDifference = rowDifference
	 else
		 maximumDifference = columnDifference
	 end
 
	 print("Maximum difference is " .. maximumDifference)
	 
	 rowIncrementation = rowDifference / maximumDifference
	 columnIncrementation = columnDifference / maximumDifference
 
	 print("Row incrementation is " .. rowIncrementation)
	 print("Column incrementation is " .. columnIncrementation)
 
	 theRow = startingRow
	 theColumn = startingColumn
	 
	 if (tableOutput == false) then
		 terrainGrid[theRow][theColumn].terrainType = connectionTerrain
	 end
 
	 for iterationCount = 1, maximumDifference do
		 if (startingColumn > endingColumn) then
			 theColumn = theColumn - columnIncrementation
		 else
			 theColumn = theColumn + columnIncrementation
		 end
 
		 if (startingRow > endingRow) then
			 theRow = theRow - rowIncrementation
		 else
			 theRow = theRow + rowIncrementation
		 end
 
 
		 if (tableOutput == true) then
			 tileInformation = {Round(theRow, 0), Round(theColumn, 0)}
			 table.insert(returnTable, tileInformation)
		 else
			 terrainGrid[Round(theRow, 0)][Round(theColumn, 0)].terrainType = connectionTerrain
		 end
	 end
 
	 if (tableOutput == true) then
		 return returnTable
	 end
 end
 
 function CreateScopeTable()
	 scopeTable = {}
 
	 for theRow = 1, mapScope do
		 for theColumn = 1, mapScope do
			 local theInformation = {}
			 local theInformation = {theRow, theColumn}
			 table.insert(scopeTable, theInformation)
		 end
	 end
 end
 
 function ChooseRandomTile(theTable)
	 local randomIndex = math.ceil(RandomBetween(1, #theTable))
	 local theCoordinates = theTable[randomIndex]
 
 
	 table.remove(theTable, randomIndex)
	 return theCoordinates
 end
 
 function CreateRandomClumps(sourceTerrain, creationChance, violationConstraint, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance)
	 local returnTable = {}
 
	 ::RedoLoop::
	 for theTile = 1, #scopeTable do
		 local tileInformation = ChooseRandomTile(scopeTable)
		 local theRow, theColumn = table.unpack(tileInformation)
 
		 -- Checks whether the terrain is an acceptable placement.
		 if (ReviewTerrain(theRow, theColumn, sourceTerrain) == false) then
			 goto RedoLoop
		 end
 
		 -- Checks whether the creation chance allows for placement.
		 if (RandomBetween(1,100) > creationChance) then
			 goto RedoLoop
		 end
 
		 -- Checks whether there are another clump nearby.
		 if (separationDistance > 0) then
			 for returnTableIndex, returnInformation in ipairs(returnTable) do
				 local returnTableRow, returnTableColumn = table.unpack(returnInformation)
				 local inDistance = GetDistance(theRow, theColumn, returnTableRow, returnTableColumn, 2)
 
				 if (inDistance <= separationDistance) then
					 goto RedoLoop
				 end
			 end
		 end
 
		 if (ReviewAvoidanceDistance(theRow, theColumn, sourceTerrain, avoidanceDistance) == false) then
			 goto RedoLoop
		 end
	 
		 if (ReviewMinimumDistance(theRow, theColumn, minimumDistance) == false) then
			 goto RedoLoop
		 end
 
		 if (ReviewEdgeAvoidance(theRow, theColumn, edgeAvoidance) == false) then
			 goto RedoLoop
		 end
 
		 print("Inserting into table!")
		 table.insert(returnTable, tileInformation)
	 end
 
	 CreateScopeTable()
	 return returnTable
 end
 
 function PreliminarySetup()
 
 
	 IncludeScaling()
	 mapScope = DefineMapScope(baseMapScope, minimumMapScope, maximumMapScope)
 
	 teamMappingTable = CreateTeamMappingTable()
	 terrainLayoutResult = SetUpGrid(mapScope, baseTerrain, terrainLayoutResult)
	 terrainGrid = terrainLayoutResult
		 
		 mapArea = mapScope * mapScope
 
		 if (enableDebugging == true) then
			 print("The base grid size set to " .. baseMapScope)
			 print("The scaled grid size is set to " .. mapScope)
		 end
	 CreateScopeTable()
	 MapDivisions()
 
 end
 
 function LocateNeighboringTiles(sourceTerrain, neighborTerrain, detectionRadius, returnShape)
	 local returnTable = {}
 
	 for theRow = 1, mapScope do
		 for theColumn = 1, mapScope do
			 if (ReviewTerrain(theRow, theColumn, sourceTerrain) == true) then
				 local tileProximity = ReturnProximity(theRow, theColumn, detectionRadius, returnShape)
 
				 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
					 tileProximityRow, tileProximityColumn = table.unpack(tileInformation)
		 
					 if (ReviewTerrain(tileProximityRow, tileProximityColumn, neighborTerrain) == true) then
						 table.insert(returnTable, tileInformation)
					 end
				 end
			 end
		 end
	 end
 
	 return returnTable
 end
 
 function ReviewTerrainTable(theTable, theTerrain)
	 local inTable = false
	 for theTableIndex, theInformation in ipairs(theTable) do
		 if (theInformation == theTerrain) then
			 inTable = true
			 break
		 end
	 end
 
	 return inTable
 end
 
 function RetrieveTerrain(theRow, theColumn)
	 return terrainGrid[theRow][theColumn].terrainType
 end
 
 function DefineSpawnZones(avoidanceTable, zoneDistance, maximumDeviation)
	 if (isZeroPlayerGame == true) then
		 print("No players detected. Aborting DefineSpawnZones() with no zones stored.")
	 else
		 print("Player zoning has been successfully initiated.")
 
		 local endingLap = 1
		 local backupTable = {}
 
		 ::RedefineZones::
		 if (refineZones == true) then
			 endingLap = endingLap + 1
		 end
 
		 local spawnZones = {}
		 local encloseTable = {}
 
		 for spawnIndex = 1, #spawnPositions do
			 table.insert(spawnZones, {})
			 table.insert(encloseTable, {})
		 end
 
		 for spawnPositionsIndex, spawnInformation in ipairs(spawnPositions) do
			 table.insert(encloseTable[spawnPositionsIndex], spawnInformation)
		 end
 
		 local creationNumber = 1
		 local tilesRemaining = true
 
		 repeat
			 -- Resets the tile found variable.
			 local tileFound = false
 
			 while (#encloseTable[creationNumber] > 0) do
				 tileFound = true
				 local encloseSelection = ChooseRandomTile(encloseTable[creationNumber])
				 local encloseRow, encloseColumn = table.unpack(encloseSelection)
 
				 -- Skips checks if this is the origin tile.
				 if (spawnPositions[creationNumber] ~= encloseSelection) then
 
					 -- Check if the tile is in the avoidance table.
					 -- If only one avoidance terrain is needed, allow a non-table input.
					 if (type(avoidanceTable) == "table") then
						 local encloseTerrain = RetrieveTerrain(encloseRow, encloseColumn)
 
						 if (ReviewTerrainTable(avoidanceTable, encloseTerrain) == true) then
							 tileFound = false
							 goto LoopBreak
						 end
					 else
						 if (ReviewTerrain(encloseRow, encloseColumn, avoidanceTable) == true) then
							 tileFound = false
							 goto LoopBreak
						 end
					 end
 
					 -- Check if this tile is too close to other zones.
					 local zoneProximity = ReturnProximity(encloseRow, encloseColumn, zoneDistance, "circular")
					 for zoneProximityIndex, zoneInformation in ipairs(zoneProximity) do
 
						 for spawnIndex = 1, #spawnPositions do
							 if (spawnIndex ~= creationNumber) then
								 if (TableContainCoordinates(spawnZones[spawnIndex], zoneInformation) == true) then
									 tileFound = false
									 goto LoopBreak
								 end
							 end
						 end
					 end
				 end
 
				 ::LoopBreak::
				 if (tileFound == true) then
					 table.insert(spawnZones[creationNumber], encloseSelection)
 
					 -- Checks all tiles around the chosen tile, in a cross pattern.
					 local tileProximity = ReturnProximity(encloseRow, encloseColumn, 1, "cross")
 
					 -- Goes through each tile surrounding the chosen tile.
					 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
						 local inTable = false
 
						 if (TableContainCoordinates(spawnZones[creationNumber], tileInformation) == true) then
							 inTable = true
							 goto TableBreak
						 end
	 
						 if (TableContainCoordinates(encloseTable[creationNumber], tileInformation) == true) then
							 inTable = true
							 goto TableBreak
						 end
						 
						 ::TableBreak::
						 -- If it's not in any of the tables, then save it as a new enclose tile.
						 if (inTable == false) then
							 table.insert(encloseTable[creationNumber], tileInformation)
						 end
					 end
 
					 break
				 end
			 end
 
			 -- Checks if there are more available tiles anywhere on the map.
			 local tilesRemaining = true
			 local tileCheck = 0
			 for spawnIndex = 1, #spawnPositions do
				 if (#encloseTable[spawnIndex] <= 0) then
					 tileCheck = tileCheck + 1
				 end
			 end
 
			 if (tileCheck == #spawnPositions) then
				 tilesRemaining = false
			 end
 
			 -- Resets the player iterator and goes back to the first player.
			 if (creationNumber >= #spawnPositions) then
				 creationNumber = 1
			 else
				 creationNumber = creationNumber + 1
			 end
		 until (tilesRemaining == false)
 
		 -- Checks if zones have been distributed evenly.
		 local function ReturnTableValue(theTable, returnType)
			 for theTableIndex, subTable in ipairs(theTable) do
				 local tableLength = #subTable
				 
				 if (theTableIndex == 1) then
					 returnValue = tableLength
				 else
					 if (returnType == "maximum") then
						 if (returnValue < tableLength) then
							 returnValue = tableLength
						 end
					 elseif (returnType == "minimum") then
						 if (returnValue > tableLength) then
							 returnValue = tableLength
						 end
					 end
				 end
			 end
		 
			 return returnValue
		 end
 
		 local minimumValue = ReturnTableValue(spawnZones, "minimum")
		 local maximumValue = ReturnTableValue(spawnZones, "maximum")
 
		 local zoneDifference = math.abs(minimumValue - maximumValue)
		 if (zoneDifference > maximumDeviation) then
			 local backupInformation = {DeepCopy(spawnZones), zoneDifference, endingLap}
			 table.insert(backupTable, backupInformation)
 
			 refineZones = true
			 if (endingLap < 10) then
				 goto RedefineZones
			 else
				 for backupTableIndex, subTable in ipairs(backupTable) do
					 if (backupTableIndex == 1) then
						 spawnZones = subTable[1]
						 minimumValue = subTable[2]
						 minimumIndex = subTable[3]
					 else
						 if (minimumValue > subTable[2]) then
							 spawnZones = subTable[1]
							 minimumValue = subTable[2]
							 minimumIndex = subTable[3]
						 end
					 end
				 end
			 end
		 end
 
		 if (endingLap >= 10) then
			 print("WARNING: Player zones did not meet the deviation requirement (" .. maximumDeviation .. ") after the maximum of " .. endingLap .. " tries. Out of all the attempts, the most suitable minimumIndex table is selected with a deviation of minimumValue.")
		 elseif (endingLap > 1) then
			 print("WARNING: Player zones ran " .. endingLap .. " times before meeting the deviation requirement (" .. maximumDeviation .. ") with a deviation value of " .. zoneDifference .. ".")
		 else
			 print("Player zoning was successfully completed abiding by the deviation requirement (" .. maximumDeviation .. ") with a deviation value of " .. zoneDifference .. ".")
		 end
 
		 return spawnZones
	 end
 end
 
-- Saves a number of coordinates using various preferences within a zone or sizeable predefined area saved within a table. For example, all tiles of a large plateau have been saved into a table; this function allows you to save randomly dotted coordinates within this table to be used for placing forests, resource deposits and so on.

-- theTable: the source table on which the clumps are created.
-- acceptanceTerrain: the only acceptable terrain or terrains that the clumps may form on, within the input table.
-- avoidanceTerrain: one or more terrains that the clumps will stay away from.
-- locateNumber: the number of clumps to be created, relative to the distribution type.
-- distributionType: determines how many clumps are created in relation to the locateNumber. Possible inputs are "player", "map", "relative", "absolute" and "fixed". The "player" input will scale the number of clumps by the number of players in the game. The "map" input will scale the number of clumps by the map size. The "relative" input will scale the number of clumps relative to the input table size. The "absolute" input will scale the number of clumps relative to the map grid. The "fixed" is a fixed number and will always stay consistent. No input will result in "fixed" being used.
-- separationDistance: the minimum distance between clumps. If the function can't find enough spaces for the clumps to be created, this value will automatically decrease by one until all clumps are placed.
-- avoidanceDistance: the minimum distance between the clumps and the terrains in the avoidanceTerrain table.
-- minimumDistance: the minimum distance to the players. In order to use this, the players must have been placed and the player terrain must be referred to as originTerrain.
-- edgeAvoidance: the minimum distance that the clumps are to be placed away from the map border.
-- forceEquality: used in conjunction with EnsureProportionateDistribution(theTable) when using the function to place an equal number of objects for all players, even if the player zones are slightly varied in size. Ask for further details.
 function CreateClumpsFromTable(theTable, acceptanceTerrain, avoidanceTerrain, locateNumber, distributionType, separationDistance, avoidanceDistance, minimumDistance, edgeAvoidance, forceEquality)
	if (type(forceEquality) == "number") then
		tableLength = forceEquality
	else
		tableLength = #theTable
	end

	local baseValue = locateNumber

	local separationValue = separationDistance

	if (distributionType == "player") then
		locateNumber = ScaleByPlayerNumber(locateNumber, false, true)
		print("Clumps created from " .. tostring(theTable) .. " have a base value of " .. baseValue .. " and are scaled by players. The conclusive value is " .. locateNumber .. ".")
	elseif (distributionType == "map") then
		locateNumber = ScaleByMapSize(locateNumber, true, true)
		print("Clumps created from " .. tostring(theTable) .. " have a base value of " .. baseValue .. " and are scaled by map size. The conclusive value is " .. locateNumber .. ".")
	elseif (distributionType == "relative") then
		locateNumber = math.ceil(tableLength * (locateNumber / 100))
		print("Clumps created from " .. tostring(theTable) .. " have a percentage coverage of " .. baseValue .. " and is relative to the table size. The conclusive value is " .. locateNumber .. ".")
	elseif (distributionType == "absolute") then
		locateNumber = math.ceil(scopeArea * (locateNumber / 100))
		print("Clumps created from " .. tostring(theTable) .. " have a percentage coverage of " .. baseValue .. " and is relative to the total map scope area. The conclusive value is " .. locateNumber .. ".")
	elseif (distributionType == "fixed") or (distributionType == nil) then
		print("Clumps created from " .. tostring(theTable) .. " will remain a fixed value. The conclusive value is " .. locateNumber .. ".")
	end
	
	-- filter out the tiles that don't stand a chance anyway, only need to be iterated once, even if restrictions are decreased, they won't become a valid tile.
	-- so don't need to evaluate these tiles multiple times.
	local filteredTable = {}
	for index, information in ipairs(theTable) do
		
		tileSelectionRow, tileSelectionColumn = table.unpack(information)

		-- Checking if the selected tile is an accepted terrain.
		if (type(acceptanceTerrain) == "table") then
			local selectionTerrain = RetrieveTerrain(tileSelectionRow, tileSelectionColumn)

			if (ReviewTerrainTable(acceptanceTerrain, selectionTerrain) == false) then
				goto Continue
			end
		else
			if (ReviewTerrain(tileSelectionRow, tileSelectionColumn, acceptanceTerrain) == false) then
				goto Continue
			end
		end

		-- Checking if the selected tile is an avoidance terrain and whether it's appropriately far away from it.
		-- If an avoidance distance is set, it will override ALL terrain-specific distances.
		if (avoidanceDistance == "individual") then
			for avoidanceTerrainIndex, terrainIteration in ipairs(avoidanceTerrain) do
				local terrainType, specificAvoidanceDistance = table.unpack(terrainIteration)

				local tileProximity = ReturnProximity(tileSelectionRow, tileSelectionColumn, specificAvoidanceDistance, "circular")

				for tileProximityIndex, tileInformation in ipairs(tileProximity) do
					local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)

					if (ReviewTerrain(tileProximityRow, tileProximityColumn, terrainType) == true) then
						goto Continue
					end
				end
			end
		elseif (avoidanceDistance > 0) then
			local tileProximity = ReturnProximity(tileSelectionRow, tileSelectionColumn, avoidanceDistance, "circular")

			for tileProximityIndex, tileInformation in ipairs(tileProximity) do
				local tileProximityRow, tileProximityColumn = table.unpack(tileInformation)

				if (type(avoidanceTerrain) == "table") then
					local selectionTerrain = RetrieveTerrain(tileProximityRow, tileProximityColumn)
		
					if (ReviewTerrainTable(avoidanceTerrain, selectionTerrain) == true) then
						goto Continue
					end
				else
					if (ReviewTerrain(tileProximityRow, tileProximityColumn, avoidanceTerrain) == true) then
						goto Continue
					end
				end
			end
		else
			if (type(avoidanceTerrain) == "table") then
				local selectionTerrain = RetrieveTerrain(tileSelectionRow, tileSelectionColumn)
	
				if (ReviewTerrainTable(avoidanceTerrain, selectionTerrain) == true) then
					goto Continue
				end
			else
				if (ReviewTerrain(tileSelectionRow, tileSelectionColumn, avoidanceTerrain) == true) then
					goto Continue
				end
			end
		end

		if (ReviewMinimumDistance(tileSelectionRow, tileSelectionColumn, minimumDistance) == false) then
			goto Continue
		end

		if (ReviewEdgeAvoidance(tileSelectionRow, tileSelectionColumn, edgeAvoidance) == false) then
			goto Continue
		end

		table.insert(filteredTable,information)

		::Continue::
	end

	local clumpTable = {}

	-- if no tiles survive at this point, no will be found. forcereturn.
	if (#filteredTable == 0) then
		forceReturn = true
		goto ForceReturn
	end

	::DecreaseRestrictions::
	if (decreaseRestrictions == true) then
		if (separationValue <= 0) then
			forceReturn = true
			goto ForceReturn
		else
			separationValue = separationValue - 1
		end
	end

	do
		local disposableTable = DeepCopy(filteredTable)
		local separationValueSquared = separationValue * separationValue

		::RedoLoop::
		while (#clumpTable ~= locateNumber) do
			if (#disposableTable > 0) then
				tileSelection = ChooseRandomTile(disposableTable)
				tileSelectionRow, tileSelectionColumn = table.unpack(tileSelection)
			else
				decreaseRestrictions = true
				goto DecreaseRestrictions
			end

			-- Checking whether other clumps of the same time is nearby.
			if (separationValue > 0) then

				for clumpIndex, clumpInformation in ipairs(clumpTable) do
					clumpRow, clumpColumn = table.unpack(clumpInformation)
					local rowDiff = clumpRow - tileSelectionRow
					local columnDiff = clumpColumn - tileSelectionColumn
					local distanceSquared = rowDiff * rowDiff + columnDiff * columnDiff

					if (distanceSquared <= separationValueSquared) then
						goto RedoLoop
					end
				end
			end
		
			table.insert(clumpTable, tileSelection)
		end

		local timesRepeated = separationDistance - separationValue
		if (decreaseRestrictions == true) then
			print("WARNING: Clumps created from a table was unable to find enough spots (" .. locateNumber .. ") without decreasing the separation distance " .. timesRepeated .. " " .. (timesRepeated == 1 and "time" or "times") .. " - going from " .. separationDistance .. " to " .. separationValue .. ".")
		end
	end

	::ForceReturn::
	if (forceReturn == true) then
		print("WARNING: Unable to find enough clump positions. Consider decreasing restrictions.")
	end

	return clumpTable
end
 
 function GenerateTerrainsFromTable(tableName, terrainTable)
	 for tableGenerationIndex, tileInformation in ipairs(tableName) do
		 local tableGenerationRow, tableGenerationColumn = table.unpack(tileInformation)
 
		 if (type(terrainTable) == "table") then
			 terrainLayoutResult[tableGenerationRow][tableGenerationColumn].terrainType = WeightedSelection(terrainTable)
		 else
			 terrainLayoutResult[tableGenerationRow][tableGenerationColumn].terrainType = terrainTable
		 end
	 end
 end
 
 function EnsureProportionateDistribution(theTable)
	 for tableIndex = 1, #theTable do
		 if (tableIndex == 1) then
			 maximumValue = #theTable[tableIndex]
		 else
			 if (maximumValue < #theTable[tableIndex]) then
				 maximumValue = #theTable[tableIndex]
			 end
		 end
	 end
 
	 return maximumValue
 end
 
 function SetZoneOrigin(zoneRow, zoneColumn)
	 if (zoneOriginTable == nil) then
		 zoneOriginTable = {}
	 end
 
	 local zoneInformation = {zoneRow, zoneColumn}
	 table.insert(zoneOriginTable, zoneInformation)
 end
 
 function DefineOtherZones(avoidanceTable, zoneDistance, maximumDeviation)
 
		 print("Zoning has been successfully initiated.")
 
		 local endingLap = 1
		 local backupTable = {}
 
		 ::RedefineZones::
		 if (refineZones == true) then
			 endingLap = endingLap + 1
		 end
 
		 local otherZones = {}
		 local encloseTable = {}
 
		 for spawnIndex = 1, #zoneOriginTable do
			 table.insert(otherZones, {})
			 table.insert(encloseTable, {})
		 end
 
		 for zoneOriginTableIndex, spawnInformation in ipairs(zoneOriginTable) do
			 table.insert(encloseTable[zoneOriginTableIndex], spawnInformation)
		 end
 
		 local creationNumber = 1
		 local tilesRemaining = true
 
		 repeat
			 -- Resets the tile found variable.
			 local tileFound = false
 
			 while (#encloseTable[creationNumber] > 0) do
				 tileFound = true
				 local encloseSelection = ChooseRandomTile(encloseTable[creationNumber])
				 local encloseRow, encloseColumn = table.unpack(encloseSelection)
 
				 -- Skips checks if this is the origin tile.
				 if (zoneOriginTable[creationNumber] ~= encloseSelection) then
 
					 -- Check if the tile is in the avoidance table.
					 -- If only one avoidance terrain is needed, allow a non-table input.
					 if (type(avoidanceTable) == "table") then
						 local encloseTerrain = RetrieveTerrain(encloseRow, encloseColumn)
 
						 if (ReviewTerrainTable(avoidanceTable, encloseTerrain) == true) then
							 tileFound = false
							 goto LoopBreak
						 end
					 else
						 if (ReviewTerrain(encloseRow, encloseColumn, avoidanceTable) == true) then
							 tileFound = false
							 goto LoopBreak
						 end
					 end
 
					 -- Check if this tile is too close to other zones.
					 local zoneProximity = ReturnProximity(encloseRow, encloseColumn, zoneDistance, "circular")
					 for zoneProximityIndex, zoneInformation in ipairs(zoneProximity) do
 
						 for spawnIndex = 1, #zoneOriginTable do
							 if (spawnIndex ~= creationNumber) then
								 if (TableContainCoordinates(otherZones[spawnIndex], zoneInformation) == true) then
									 tileFound = false
									 goto LoopBreak
								 end
							 end
						 end
					 end
				 end
 
				 ::LoopBreak::
				 if (tileFound == true) then
					 table.insert(otherZones[creationNumber], encloseSelection)
 
					 -- Checks all tiles around the chosen tile, in a cross pattern.
					 local tileProximity = ReturnProximity(encloseRow, encloseColumn, 1, "cross")
 
					 -- Goes through each tile surrounding the chosen tile.
					 for tileProximityIndex, tileInformation in ipairs(tileProximity) do
						 local inTable = false
 
						 if (TableContainCoordinates(otherZones[creationNumber], tileInformation) == true) then
							 inTable = true
							 goto TableBreak
						 end
	 
						 if (TableContainCoordinates(encloseTable[creationNumber], tileInformation) == true) then
							 inTable = true
							 goto TableBreak
						 end
						 
						 ::TableBreak::
						 -- If it's not in any of the tables, then save it as a new enclose tile.
						 if (inTable == false) then
							 table.insert(encloseTable[creationNumber], tileInformation)
						 end
					 end
 
					 break
				 end
			 end
 
			 -- Checks if there are more available tiles anywhere on the map.
			 local tilesRemaining = true
			 local tileCheck = 0
			 for spawnIndex = 1, #zoneOriginTable do
				 if (#encloseTable[spawnIndex] <= 0) then
					 tileCheck = tileCheck + 1
				 end
			 end
 
			 if (tileCheck == #zoneOriginTable) then
				 tilesRemaining = false
			 end
 
			 -- Resets the player iterator and goes back to the first player.
			 if (creationNumber >= #zoneOriginTable) then
				 creationNumber = 1
			 else
				 creationNumber = creationNumber + 1
			 end
		 until (tilesRemaining == false)
 
		 -- Checks if zones have been distributed evenly.
		 local function ReturnTableValue(theTable, returnType)
			 for theTableIndex, subTable in ipairs(theTable) do
				 local tableLength = #subTable
				 
				 if (theTableIndex == 1) then
					 returnValue = tableLength
				 else
					 if (returnType == "maximum") then
						 if (returnValue < tableLength) then
							 returnValue = tableLength
						 end
					 elseif (returnType == "minimum") then
						 if (returnValue > tableLength) then
							 returnValue = tableLength
						 end
					 end
				 end
			 end
		 
			 return returnValue
		 end
 
		 local minimumValue = ReturnTableValue(otherZones, "minimum")
		 local maximumValue = ReturnTableValue(otherZones, "maximum")
 
		 local zoneDifference = math.abs(minimumValue - maximumValue)
		 if (zoneDifference > maximumDeviation) then
			 local backupInformation = {DeepCopy(otherZones), zoneDifference, endingLap}
			 table.insert(backupTable, backupInformation)
 
			 refineZones = true
			 if (endingLap < 10) then
				 goto RedefineZones
			 else
				 for backupTableIndex, subTable in ipairs(backupTable) do
					 if (backupTableIndex == 1) then
						 otherZones = subTable[1]
						 minimumValue = subTable[2]
						 minimumIndex = subTable[3]
					 else
						 if (minimumValue > subTable[2]) then
							 otherZones = subTable[1]
							 minimumValue = subTable[2]
							 minimumIndex = subTable[3]
						 end
					 end
				 end
			 end
		 end
 
		 if (endingLap >= 10) then
			 print("WARNING: Player zones did not meet the deviation requirement (" .. maximumDeviation .. ") after the maximum of " .. endingLap .. " tries. Out of all the attempts, the most suitable (" .. minimumIndex .. ") table is selected with a deviation of " .. minimumValue .. ".")
		 elseif (endingLap > 1) then
			 print("WARNING: Player zones ran " .. endingLap .. " times before meeting the deviation requirement (" .. maximumDeviation .. ") with a deviation value of " .. zoneDifference .. ".")
		 else
			 print("Player zoning was successfully completed abiding by the deviation requirement (" .. maximumDeviation .. ") with a deviation value of " .. zoneDifference .. ".")
		 end
 
		 zoneOriginTable = nil
		 return otherZones
 
 end
 
 function CreateCircularClumps(locateNumber, ringRadius, positionVariance, rotationSetting)
	 clumpPositions = {}
	 local baseNumber = 1
 
	 if (type(rotationSetting) == "boolean") then
		 if (rotationSetting == true) then
			 rotationAmount = RandomBetween(0, 359)
		 else
			 rotationAmount = 0
		 end
	 elseif (type(rotationSetting) == "number") then
		 rotationAmount = rotationSetting
	 end
 
	 repeat
		 -- Calculating and setting up the circular positions.
		 local cosineCalculation = math.cos(2*math.pi*baseNumber/locateNumber)
		 local sineCalculation = math.sin(2*math.pi*baseNumber/locateNumber)
		 local trueRotation = rotationAmount
 
		 -- Adds a random rotation to the circle.
		 local xRotation = sineCalculation*math.sin(trueRotation*math.pi/180)+cosineCalculation*math.cos(trueRotation*math.pi/180)
		 local yRotation = cosineCalculation*math.sin(trueRotation*math.pi/180)-sineCalculation*math.cos(trueRotation*math.pi/180)
 
		 -- Corrects radius and have it scale relative to map size.
		 local xAbsolute = ((ringRadius/2)*(mapScope/100))*xRotation
		 local yAbsolute = ((ringRadius/2)*(mapScope/100))*yRotation
 
		 -- Translating the positions relative to map size.
		 local xTranslate = xAbsolute+(mapScope/2)+0.5
		 local yTranslate = yAbsolute+(mapScope/2)+0.5
 
		 -- Creates random variance in the player positions.
		 local randomVariance = RandomBetween(-positionVariance, positionVariance)
		 local xCoordinate = Rounding(xTranslate+randomVariance)
		 local yCoordinate = Rounding(yTranslate+randomVariance)
 
		 -- Stores the position.
		 local theInformation = {}
		 local theInformation = {xCoordinate, yCoordinate}
		 table.insert(clumpPositions, theInformation)
 
		 baseNumber = baseNumber + 1
 
	 until(baseNumber == locateNumber + 1)
 
	 return clumpPositions
 end
 
 function PlaceInCircle(theTerrain, sourceTerrain, centreDistance)
	 for theRow = 1, mapScope do
		 for theColumn = 1, mapScope do
			 if (ReviewTerrain(theRow, theColumn, sourceTerrain) == true) then
				 if (ReviewCentreAvoidance(theRow, theColumn, PercentageSize(centreDistance)) == true) then
					 terrainGrid[theRow][theColumn].terrainType = theTerrain
				 end
			 end
		 end
	 end
 end