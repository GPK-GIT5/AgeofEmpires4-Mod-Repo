-- Copyright 2023 SEGA Corporation, Developed by Relic Entertainment

--CreatePointedLine() returns a table of individual points that are plotted in a horizontal or vertical line.
--startRow (int) row coord
--startCol (int) col coord
--numberOfCoords (int) the number of points/coordinates in the line
--coordSpacing (int) the spacing between the number of coordinates
--offsetShift (int) changes the randomness with each coordinate to be offset between zero and offsetShift
--vertical (bool) is the drawn line horizontal or vertical?
--gridSize (int) the size of the table you are working within e.g. gridSize
function CreatePointedLine(startRow, startCol, numberOfCoords, coordSpacing, offsetShift, vertical, gridSize)
	
	local pointedLineCoords = {}
	
	for i = 1,(coordSpacing + 1) * numberOfCoords, coordSpacing + 1 do
		
		--offets each coordinate to be random
		offsetShiftRandom = math.floor(GetRandomInRange(0, offsetShift + 1))
		
		--horizontal line
		if (vertical == false and IsInMap(startRow, startCol + i - 1 + offsetShiftRandom, gridSize, gridSize)) then
			table.insert(pointedLineCoords, { startRow, startCol + i - 1 + offsetShiftRandom })
		end
		
		--vertical line
		if (vertical == true and IsInMap(startRow + i - 1 + offsetShiftRandom, startCol, gridSize, gridSize)) then
			table.insert(pointedLineCoords, { startRow + i - 1 + offsetShiftRandom, startCol })
		end
		
	end
	
	return pointedLineCoords
	
end



--PatchAreaHoleTiles() patches holes that may appear when using GrowTerrainAreaToSizeWeighted.
--If the holeTerrain is surrounded by 3 or more tiles with pickedTerrain, change to the pickedTerrain
--holeTerrain (tt) the terrain of the hole that is appearing
--pickedTerrain (tt) the surrounding neighbors terrain to check against
function PatchAreaHoleTiles(holeTerrain, pickedTerrain)
	
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if (terrainLayoutResult[row][col].terrainType == holeTerrain) then
				
				currentNeighbors = GetNeighbors(row, col, terrainLayoutResult)
				neighborTerrainCount = 0
				
				for i, v in ipairs(currentNeighbors) do
					
					neighborRow = v.x
					neighborCol = v.y
					
					if (terrainLayoutResult[neighborRow][neighborCol].terrainType == pickedTerrain) then
						neighborTerrainCount = neighborTerrainCount + 1
					end
					
				end
				
				--3 neighboring tiles is pickedTerrain, patch the hole
				if (neighborTerrainCount > 2) then
					terrainLayoutResult[row][col].terrainType = pickedTerrain
				end
				
			end
			
		end
	end
	
end



--DrawOuterStroke() draws a terrainType border/stroke around an area of a specific terrain
--pickedTerrain (tt) the area of terrain you want to target
--terrainToReplace (tt) the terrain you want to replace
--borderTerrainType (tt) the terrain you want to draw the border/stroke around the picked terrain
--myTable (table) the table you are working within e.g. terrainLayoutResult
function DrawOuterStroke(pickedTerrain, terrainToReplace, borderTerrainType, myTable)
	
	for row = 1, gridSize do
		for col = 1, gridSize do
			
			if (terrainLayoutResult[row][col].terrainType == pickedTerrain) then
				
				islandNeighbors = GetNeighbors(row, col, myTable)
				
				for i, v in ipairs(islandNeighbors) do
					currentRow = v.x
					currentCol = v.y
					
					if (terrainLayoutResult[currentRow][currentCol].terrainType == terrainToReplace) then
						terrainLayoutResult[currentRow][currentCol].terrainType = borderTerrainType
					end
					
				end
			
			end
			
		end
	end	
end



--getIndexFromTableCoord() returns the table index containing both the row and col values, returns nil if not found
--row (int) the row coordinate
--col (int) the col coordinate
--myTable (table) contains a list of coordinates with y and x indices { y = row, x = col }
function GetIndexFromTableCoord(row, col, myTable)
    index = nil
	for i, coord in ipairs(myTable) do
		if (coord.y == row and coord.x == col) then
			index = i
			break
		end
	end
	return index
end


