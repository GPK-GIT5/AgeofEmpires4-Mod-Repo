-- Copyright 2022 SEGA Corporation, Developed by Relic Entertainment
terrainLayoutResult = {}
metersPerSquare = 25
gridHeight, gridWidth, gridSize = SetCustomCoarseGrid(metersPerSquare)

if (gridHeight % 2 == 0) then
	gridHeight = gridHeight -1
end

if (gridWidth % 2 == 0) then
	gridWidth = gridWidth -1
end

gridSize = gridWidth

playerStarts = worldPlayerCount

n = tt_none
h = tt_hills
s = tt_mountains_small
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_low_rolling
mr = tt_hills_med_rolling
hr = tt_hills_high_rolling
low = tt_plateau_low
med = tt_plateau_med
high = tt_plateau_high
p = tt_plains
t = tt_impasse_trees_plains
v = tt_valley
r = tt_river
o = tt_ocean

-- setting up the map terrain using the function in the map_setup lua file in the library folder
terrainLayoutResult = SetUpGrid(gridSize, p, terrainLayoutResult)

playerStartTerrainHill = tt_player_start_classic_hills_low_rolling -- classic mode start
playerStartTerrainPlain = tt_player_start_classic_plains

------------------------
--REFERENCE VALUES
------------------------

--bounty squares are used to populate an area of the map with extra resources
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains

--the following are markers used to determine player and settlement spawn points
s = tt_player_start_hills
sp = tt_settlement_plains
sh = tt_settlement_hills
seb = tt_settlement_hills_high_rolling

--reference values
baseGridSize = 13
outerRadius = 3.5 / baseGridSize * gridSize
middleRadius = 2.5 / baseGridSize * gridSize
innerRadius = 1.25 / baseGridSize * gridSize
mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

------------------------
--RIVERS
------------------------

--High Level Decision: Is the river vertical or horizontal?
orientationWeightTable = {}

-- tuning data for weight of river orientation
verticalWeight = 1
horizontalWeight = 1

--create empty data point for cumulative weight also
cumulativeWeightRiverTypeTable = {}

--insert entries into this weight table containing our choices
table.insert(orientationWeightTable, {"vertical", verticalWeight})
table.insert(orientationWeightTable, {"horizontal", horizontalWeight})

--total up the table weight in order to correctly be able to get a weighted selection
totalOrientationWeight = 0
for index, weightedElement in ipairs(orientationWeightTable) do
	cumulativeWeightRiverTypeTable[index] = totalOrientationWeight + weightedElement[2]
	totalOrientationWeight = totalOrientationWeight + weightedElement[2]
end

--make a weighted selection
currentWeightRiverType = worldGetRandom() * totalOrientationWeight
riverType = 0

--loop through however many times based on number of elements in the selection list
for index = 1, #orientationWeightTable do
	--loop through cumulative weights until we find the correct value range
	if(currentWeightRiverType < cumulativeWeightRiverTypeTable[index]) then
		riverType = index
		break
	end
end

print("Current river selection type is " .. orientationWeightTable[riverType][1])

--sets up start/end points for rivers based on the orientation
riverPoints = {}


--vertical
if riverType == 1 then
	if(worldTerrainWidth > 513) then
		riverRow1 = 1
		riverCol1 = math.ceil(GetRandomInRange(mapHalfSize-1, mapHalfSize+1))
		riverRow2 = gridSize
		riverCol2 = math.ceil(GetRandomInRange(mapHalfSize-1, mapHalfSize+1))
		
	else
		riverRow1 = 1
		riverCol1 = mapHalfSize
		riverRow2 = gridSize
		riverCol2 = mapHalfSize
	end
	
	riverPoints = DrawLineOfTerrainNoDiagonal(riverRow1, riverCol1, riverRow2, riverCol2, true, r, gridSize, terrainLayoutResult)
	--riverPoints = DrawLineOfTerrainNoNeighbors(riverRow1, riverCol1, riverRow2, riverCol2, true, r, gridSize, terrainLayoutResult)
	terrainLayoutResult[riverRow1][riverCol1].terrainType = tt_river --ensures that the first point is a river tile
	

end

--horizontal
if riverType == 2 then
	if(worldTerrainWidth > 513) then
		riverRow1 = math.ceil(GetRandomInRange(mapHalfSize-1, mapHalfSize+1))
		riverCol1 = 1
		riverRow2 = math.ceil(GetRandomInRange(mapHalfSize-1, mapHalfSize+1))
		riverCol2 = gridSize
	else
		riverRow1 = mapHalfSize
		riverCol1 = 1
		riverRow2 = mapHalfSize
		riverCol2 = gridSize
	end
	riverPoints = DrawLineOfTerrainNoDiagonal(riverRow1, riverCol1, riverRow2, riverCol2, true, r, gridSize, terrainLayoutResult)
--	riverPoints = DrawLineOfTerrainNoNeighbors(riverRow1, riverCol1, riverRow2, riverCol2, true, r, gridSize, terrainLayoutResult)
	terrainLayoutResult[riverRow1][riverCol1].terrainType = tt_river --ensures that the first point is a river tile
	
end

-- generate river result table for river generation
riverResult = {} -- river result table must be named this to create rivers
table.insert(riverResult, 1, riverPoints)

-- debug output of river results
for index = 1, #riverResult do

	for pIndex = 1, #riverResult[index] do
		x = riverResult[index][pIndex][1]
		y = riverResult[index][pIndex][2]
		print("** River " ..index .." Point " ..pIndex .." Row " ..x ..", Column " ..y)
	end

end

-- generate ford result table for ford generation
fordResults = {}
woodBridgeResults = {} -- must be named this to place fords
woodBridgeTable = {} -- temp place to hold main river ford points
stoneBridgeResults = {} -- must be named this to place stone bridges
stoneBridgeTable = {} -- temp place to hold stone bridge points

--create a table that'll hold the crossing weights so that it can randomly select one
crossingCountWeightTable = {}
-- tuning data for weight for number of crossings on main river
fourCrossings = 0.40
fiveCrossings = 0.50
sixCrossings = 0.10

--create empty data point for cumulative weight also
cumulativeWeightTableRiverCrossings = {}

--insert entries into this weight table containing our choices
table.insert(crossingCountWeightTable, {4, fourCrossings})
table.insert(crossingCountWeightTable, {5, fiveCrossings})
table.insert(crossingCountWeightTable, {6, sixCrossings})

--total up the table weight in order to correctly be able to get a weighted selection
totalCrossingCountWeight = 0

for index, weightedElement in ipairs(crossingCountWeightTable) do
	cumulativeWeightTableRiverCrossings[index] = totalCrossingCountWeight + weightedElement[2]
	totalCrossingCountWeight = totalCrossingCountWeight + weightedElement[2]
end

--make a weighted selection
currentCrossingWeight = worldGetRandom() * totalCrossingCountWeight
currentCrossingCount = 0

--loop through however many times based on number of elements in the selection list
for crossingIndex = 1, #crossingCountWeightTable do
	--loop through cumulative weights until we find the correct value range
	if(currentCrossingWeight < cumulativeWeightTableRiverCrossings[crossingIndex]) then
		currentCrossingCount = crossingIndex
		break
	end
end

numChunks = (crossingCountWeightTable[currentCrossingCount][1])

print("Number of chunks on main river is " .. numChunks)

--create a table that will hold all the valid points for crossings and tributaries
riverCrossingTable = {}
--handy counter variable
tempRiverCounter = #riverPoints

-- divide the river into [x] parts depending on currentCrossingCount
riverChunks = {}

--create subtables equal to number of chunks
for index = 1, numChunks do
	riverChunks[index] = {}
	
	print("successfully generated main river chunk # " .. index )
end

--populate each chunk with the coordinates (copied from the original river table)
	
-- find out how many tiles belong in each chunk
numTilesInChunk = math.ceil(tempRiverCounter / numChunks)
print("numTilesInChunk is " .. numTilesInChunk)
	
-- create temp variables to hold the information when the loop starts
firstTileIndex = 1
lastTileIndex = numTilesInChunk
	
--for the 1st chunk, copy coordinates from the other river table
for tileIndex = 1, numTilesInChunk do
	newInfo = {}
	newRow = riverResult[1][tileIndex][1]
	newCol = riverResult[1][tileIndex][2]
	newInfo = {newRow,newCol}
		
	table.insert(riverChunks[1],1,newInfo)
end
		
--do the same thing for all other chunks
for chunkNumber = 2, numChunks do
	
	--extrapolate the first/last tile of every chunk by multiplying the number of tiles with numChunks
	firstTileIndex = lastTileIndex +1
	lastTileIndex = (numTilesInChunk * chunkNumber) -1
	
	if lastTileIndex > tempRiverCounter then 
		break
	end
		
	--copy coordinates from the other river table
	for tileIndex = firstTileIndex, lastTileIndex do
		print ("current tileIndex for copying is " .. tileIndex)
		newInfo = {}
		newRow = riverResult[1][tileIndex][1]
		newCol = riverResult[1][tileIndex][2]
		newInfo = {newRow,newCol}
		
		table.insert(riverChunks[chunkNumber],newInfo)
	end		
end	

--for chunk 1: clean up the invalid river points (first and last tile of every chunk) and select a crossing point

currentChunkLength = #riverChunks[1] -- temp variable that just holds the length of each river chunk

print("currentchunklength is equal to " .. currentChunkLength)

--randomly select an index from remaining options and add the chosen crossing point to riverCrossingTable
chunkIndexMin = 2
chunkIndexMax = currentChunkLength - 1

print("For chunk 1 the chunkindexmin is " .. chunkIndexMin .. " and the chunkindexmax is " .. chunkIndexMax)

fordIndex = math.ceil(GetRandomInRange(chunkIndexMin, chunkIndexMax)) -- chooses a point with the buffers in mind

print("The chosen fordIndex is " .. fordIndex)
	
newInfo = {}
newRow = riverResult[1][fordIndex][1]
newCol = riverResult[1][fordIndex][2]
newInfo = {newRow,newCol}

table.insert(riverCrossingTable, newInfo) -- insert chosen point into the riverCrossingTable
print("newRow is " .. newRow .. " newCol is " .. newCol)
print("There is a crossing in Main River Index " .. fordIndex)


runningTotalRiverTiles = currentChunkLength
print("For chunk 1 the chunkindexmin is " .. chunkIndexMin .. " and the chunkindexmax is " .. chunkIndexMax)
print("the runningTotalRiverTiles is now " .. runningTotalRiverTiles)

--loop through the rest of the river chunks and clean up the first/last points, then add the chosen crossing points to riverCrossingTable
for tempIndex = 2, #riverChunks do
	
	currentChunkLength = #riverChunks[tempIndex] -- this is reset with every loop because we are removing entries from the riverChunk table
	print("currentChunkLength is equal to " .. currentChunkLength)
	
	--randomly select an index from remaining options 
	chunkIndexMin = 2
	chunkIndexMax = currentChunkLength - 1

	if chunkIndexMax <= 0 then
		chunkIndexMax = currentChunkLength
	end
	
	if(chunkIndexMax < chunkIndexMin) then
		chunkIndexMax = chunkIndexMin
	end
	
	print("For chunk " .. tempIndex .. " the chunkindexmin is " .. chunkIndexMin .. " and the chunkindexmax is " .. chunkIndexMax)
			
	fordIndexInFullRiver = runningTotalRiverTiles + math.ceil(GetRandomInRange(chunkIndexMin, chunkIndexMax)) -- translates the chosen point in the context of the full river	

	if fordIndexInFullRiver > #riverPoints then
		fordIndexInFullRiver = #riverPoints
	end
	
	print("The chosen fordIndexInFullRiver is " .. fordIndexInFullRiver)
		
	
	newInfo = {}
	newRow = riverResult[1][fordIndexInFullRiver][1]
	newCol = riverResult[1][fordIndexInFullRiver][2]
	newInfo = {newRow,newCol}
		
	print("newRow is " .. newRow .. " newCol is " .. newCol)
	--insert chosen point into riverCrossingTable
	table.insert(riverCrossingTable, newInfo)
	print("There is a crossing in Main River Index " .. fordIndexInFullRiver)
	
	runningTotalRiverTiles = runningTotalRiverTiles + currentChunkLength
	print("the runningTotalRiverTiles is now " .. runningTotalRiverTiles)	
end

-- print out the results of the river crossing table
for indexOfRiverCrossingTable = 1, #riverCrossingTable do
	print("riverCrossingTable at index " .. indexOfRiverCrossingTable .. " results in row " .. riverCrossingTable[indexOfRiverCrossingTable][1] .. " col " .. riverCrossingTable[indexOfRiverCrossingTable][2])
end

--create a table to hold onto the trib points
trib01Points = {} 
trib02Points = {} 

--choose which point is the trib point from riverCrossingsTable
--only choose one of the middle points available (ignore the first and last chunk/point so there is no risk of a useless tributary)
tribMinChunk = math.ceil(#riverResult[1] * 0.43)
tribMaxChunk = math.ceil(#riverResult[1] * 0.48)
trib01Index = math.ceil(GetRandomInRange(tribMinChunk, tribMaxChunk))

--trib1 start coords
trib01StartRow = riverResult[1][trib01Index][1]
trib01StartColumn = riverResult[1][trib01Index][2]
--table.remove(riverCrossingTable, trib01Index) -- remove trib1 point from crossing table to make it ineligible


---trib 2 roll
tribMinChunk = math.ceil(#riverResult[1] * 0.52)
tribMaxChunk = math.ceil(#riverResult[1] * 0.57)
trib02Index = math.ceil(GetRandomInRange(tribMinChunk, tribMaxChunk))


--trib2 start coords
trib02StartRow = riverResult[1][trib02Index][1]
trib02StartColumn = riverResult[1][trib02Index][2] 

--table.remove(riverCrossingTable, trib02Index)

--[[
while trib01Index == trib02Index do
	trib01Index = math.ceil(GetRandomInRange(tribMinChunk, tribMaxChunk))
	trib02Index = math.ceil(GetRandomInRange(tribMinChunk, tribMaxChunk))
	print("Looping through potential trib points")
end

print("trib 01 index is " .. trib01Index)
print("trib 02 index is " .. trib01Index)

--trib1 start coords
trib01StartRow = riverCrossingTable[trib01Index][1]
trib01StartColumn = riverCrossingTable[trib01Index][2]

--trib2 start coords
trib02StartRow = riverCrossingTable[trib02Index][1]
trib02StartColumn = riverCrossingTable[trib02Index][2] 
]]




--trib direction and drawing -- this is based on the direction of the main river
	
--vertical main river


if riverType == 1 then
	trib01EndRow = trib01StartRow
	trib01EndColumn = 1
	trib02EndRow = trib02StartRow
	trib02EndColumn = gridSize
	
	print("Trib 01 Start Row is " .. trib01StartRow .. " Trib  01 StartColumn is " .. trib01StartColumn)
	print("Trib 01 End Row is " .. trib01EndRow .. " Trib 01 End Column is " .. trib01EndColumn)
	
	print("Trib 02 Start Row is " .. trib02StartRow .. " Trib  02 StartColumn is " .. trib02StartColumn)
	print("Trib 02 End Row is " .. trib02EndRow .. " Trib 02 End Column is " .. trib02EndColumn)
	
--	trib01Points = DrawLineOfTerrainReturn(trib01StartRow, trib01StartColumn, trib01EndRow, trib01EndColumn, tt_river, true, gridSize)
--	trib02Points = DrawLineOfTerrainReturn(trib02StartRow, trib02StartColumn, trib02EndRow, trib02EndColumn, tt_river, true, gridSize)	
	
	trib01Points = DrawLineOfTerrainNoDiagonalReturn(trib01StartRow, trib01StartColumn, trib01EndRow, trib01EndColumn, true, tt_river, gridSize, terrainLayoutResult)
	trib02Points = DrawLineOfTerrainNoDiagonalReturn(trib02StartRow, trib02StartColumn, trib02EndRow, trib02EndColumn, true, tt_river, gridSize, terrainLayoutResult)
	
	
end
	
print("Number of tiles in tributary 01 is " .. #trib01Points)
print("Number of tiles in tributary 02 is " .. #trib02Points)


--horizontal main river
if riverType == 2 then
	
	trib01EndRow = 1
	trib01EndColumn = trib01StartColumn
	trib02EndRow = gridSize
	trib02EndColumn = trib02StartColumn
	
	print("Trib 01 Start Row is " .. trib01StartRow .. " Trib  01 StartColumn is " .. trib01StartColumn)
	print("Trib 01 End Row is " .. trib01EndRow .. " Trib 01 End Column is " .. trib01EndColumn)
	
	print("Trib 02 Start Row is " .. trib02StartRow .. " Trib  02 StartColumn is " .. trib02StartColumn)
	print("Trib 02 End Row is " .. trib02EndRow .. " Trib 02 End Column is " .. trib02EndColumn)
	
--	trib01Points = DrawLineOfTerrainReturn(trib01StartRow, trib01StartColumn, trib01EndRow, trib01EndColumn, tt_river, true, gridSize)		
--	trib02Points = DrawLineOfTerrainReturn(trib02StartRow, trib02StartColumn, trib02EndRow, trib02EndColumn, tt_river, true, gridSize)	

	trib01Points = DrawLineOfTerrainNoDiagonalReturn(trib01StartRow, trib01StartColumn, trib01EndRow, trib01EndColumn, true, tt_river, gridSize, terrainLayoutResult)
	trib02Points = DrawLineOfTerrainNoDiagonalReturn(trib02StartRow, trib02StartColumn, trib02EndRow, trib02EndColumn, true, tt_river, gridSize, terrainLayoutResult)	
end
	
--put all land points into their quarters
landQuarters = {}
landQuarter1 = {}
landQuarter2 = {}
landQuarter3 = {}
landQuarter4 = {}
landQuarter1 = FloodFill(1, 1, tt_plains)
landQuarter2 = FloodFill(1, #terrainLayoutResult, tt_plains)
landQuarter3 = FloodFill(#terrainLayoutResult, 1, tt_plains)
landQuarter4 = FloodFill(#terrainLayoutResult, #terrainLayoutResult, tt_plains)
table.insert(landQuarters, landQuarter1)
table.insert(landQuarters, landQuarter2)
table.insert(landQuarters, landQuarter3)
table.insert(landQuarters, landQuarter4)



--after the trib is generated, remove the point from the riverCrossingsTable so it can't turn into a bridge or ford
--table.remove(riverCrossingTable, trib01Index)
--table.remove(riverCrossingTable, trib02Index)

-- inserts the tributary river into riverResults so that it can generate
table.insert(riverResult, 2, trib01Points) 
table.insert(riverResult, 3, trib02Points) 

print("riverCrossingTable contains " .. #riverCrossingTable .. " items")

--for all the remaining points in the riverCrossingTable, roll to see if it is a ford or a stone bridge

numFords = 0 --counters that just keep track of how many fords and bridges there are total
numStoneBridges = 0

--[[

print("printing out the river crossing table")
for crossingTableIndex = 1, #riverCrossingTable do
	
	currentRow = riverCrossingTable[crossingTableIndex][1]
	currentCol = riverCrossingTable[crossingTableIndex][2]
	
	print("index " .. crossingTableIndex .. " of the crossing table is " .. currentRow .. " ," .. currentCol)
end

for numCrossingsIndex = 1, #riverCrossingTable do

	--rolls fordOrBridge to determine which one it is
	fordOrBridge = worldGetRandom()
	bridgeChance = 0.5
	
	newInfo = {}
	newRow = riverCrossingTable[numCrossingsIndex][1]
	newCol = riverCrossingTable[numCrossingsIndex][2]
	newInfo = {newRow,newCol}
	
	print("setting up fordOrBridge and the numCrossingsIndex is " .. numCrossingsIndex .. " newRow contains " .. newRow .. " newCol contains " .. newCol)
	
	if (fordOrBridge <= bridgeChance) then -- 50% chance that it'll be a stone bridge instead of a Ford
		table.insert(stoneBridgeTable, newInfo)
		numStoneBridges = numStoneBridges + 1	
	else
		table.insert(fordTable, newInfo)
		numFords = numFords + 1
	end

end

print("The main river has a total of " .. numFords .. " fords")
print("The main river has a total of " .. numStoneBridges .. " stone bridges")

--for the main river, insert the fordTable into fordResults to generate fords / bridges
table.insert(fordResults, fordTable)

--if there are any stonebridges, add them to the stonebridgetable to generate stone bridges
if (#stoneBridgeTable > 0) then
	table.insert(stoneBridgeResults, stoneBridgeTable)
end

--ensure no stone bridge exists on a ford
for stoneIndex = 1, #stoneBridgeResults do
	
	currentStoneRow = stoneBridgeResults[stoneIndex][1]
	currentStoneCol = stoneBridgeResults[stoneIndex][2]
	for fordIndex = #fordResults, 1, -1 do
		currentFordRow = fordResults[fordIndex][1]
		currentFordCol = fordResults[fordIndex][2]
		
		if(currentStoneRow == currentFordRow and currentStoneCol == currentFordCol) then
			
			--get rid of the current ford
			table.remove(fordResults, fordIndex)
		end
	end
end

-- trib crossings need to happen after the main river crossings 
trib01FordTable = {}
trib02FordTable = {}
trib01TileCounter = #trib01Points
trib02TileCounter = #trib02Points
numCrossingsPerTrib = 1

if(worldTerrainWidth <= 417) then
		numCrossingsPerTrib = 1
	elseif(worldTerrainWidth <= 513) then
		numCrossingsPerTrib = 1
	elseif(worldTerrainWidth <= 641) then
		numCrossingsPerTrib = 2
	elseif(worldTerrainWidth <= 769) then
		numCrossingsPerTrib = 2
	else
	numCrossingsPerTrib = 2
	end

print("trib01TileCounter is currently equal to " .. trib01TileCounter)
print("trib02TileCounter is currently equal to " .. trib02TileCounter)

--fords for trib01
for multipleTribCrossingIndex = 1, numCrossingsPerTrib do
	
	--randomly select an index from remaining options 
	tribCrossingMin =  math.ceil(trib01TileCounter * 0.2)
	tribCrossingMax = trib01TileCounter - 1

	tribCrossingIndex = math.ceil(GetRandomInRange(tribCrossingMin, tribCrossingMax))

	print("tribCrossingMin is currently equal to " .. tribCrossingMin .. " and tribCrossingMax is equal to " .. tribCrossingMax)
	print("TribCrossingIndex is " .. tribCrossingIndex)

	--turn that randomly chosen index into a ford

	newInfo = {}
	newRow = riverResult[2][tribCrossingIndex][1]
	newCol = riverResult[2][tribCrossingIndex][2]
	newInfo = {newRow,newCol}

	table.insert(trib01FordTable, newInfo)
end

--fords for trib02
for multipleTribCrossingIndex = 1, numCrossingsPerTrib do
	
	--randomly select an index from remaining options 
	tribCrossingMin = math.ceil(trib02TileCounter * 0.2)
	tribCrossingMax = trib02TileCounter - 1

	tribCrossingIndex = math.ceil(GetRandomInRange(tribCrossingMin, tribCrossingMax))

	print("tribCrossingMin is currently equal to " .. tribCrossingMin .. " and tribCrossingMax is equal to " .. tribCrossingMax)
	print("TribCrossingIndex is " .. tribCrossingIndex)

	--turn that randomly chosen index into a ford

	newInfo = {}
	newRow = riverResult[3][tribCrossingIndex][1]
	newCol = riverResult[3][tribCrossingIndex][2]
	newInfo = {newRow,newCol}

	table.insert(trib02FordTable, newInfo)
end

table.insert(fordResults, 2, trib01FordTable)
table.insert(fordResults, 3, trib02FordTable)

for riverIndex = 1, #riverResult do
	for riverPointIndex = 1, #riverResult[riverIndex] do
	
		currentRow = riverResult[riverIndex][riverPointIndex][1]
		currentCol = riverResult[riverIndex][riverPointIndex][2]
		
		print("river " .. riverIndex .. " index " .. riverPointIndex .. " is at " .. currentRow .. ", " .. currentCol)
	end
end

--check each crossing for a given river
for riverIndex = 1, #fordResults do
	for crossingIndex = 1, #fordResults[riverIndex] do
		print("Looping print thing riverIndex " .. riverIndex)
		print("crossingIndex " .. crossingIndex) 
		print("row " .. fordResults[riverIndex][crossingIndex][1])
		print("col " .. fordResults[riverIndex][crossingIndex][2])
		
		currentRow = fordResults[riverIndex][crossingIndex][1]
		currentCol = fordResults[riverIndex][crossingIndex][2]
		
		--check for any matching point on another river
		for checkRiverIndex = 1, #riverResult do
			
			--only look at other rivers
			if(riverIndex ~= checkRiverIndex) then
				for riverPointIndex = 1, #riverResult[checkRiverIndex] do
					
					currentCheckRow = riverResult[checkRiverIndex][riverPointIndex][1]
					currentCheckCol = riverResult[checkRiverIndex][riverPointIndex][2]
					
					--see if the crossing overlaps a point on another river
					if(currentRow == currentCheckRow and currentCol == currentCheckCol) then
						
						--move the crossing down the river, if the point exists
						
						--find the point on the current river
						for indexToFind = 1, #riverResult[riverIndex] do
							
							rowToFind = riverResult[riverIndex][indexToFind][1]
							colToFind = riverResult[riverIndex][indexToFind][2]
							
							--check to see if the current index of the search equals the crossing index that had an overlapping point on another river
							if(rowToFind == currentRow and colToFind == currentCol) then
								
								--set the crossing to be down the river one index
								if(#riverResult[riverIndex] >= indexToFind + 1) then
									newRow = riverResult[riverIndex][indexToFind + 1][1]
									newCol = riverResult[riverIndex][indexToFind + 1][2]
									
									fordResults[riverIndex][crossingIndex][1] = newRow
									fordResults[riverIndex][crossingIndex][2] = newCol
									print("setting the river index of the crossing at " .. currentRow .. ", " .. currentCol .. " to be one index down the river at " .. newRow .. ", " .. newCol)
								elseif(indexToFind >= 2) then
									newRow = riverResult[riverIndex][indexToFind - 1][1]
									newCol = riverResult[riverIndex][indexToFind - 1][2]
									
									fordResults[riverIndex][crossingIndex][1] = newRow
									fordResults[riverIndex][crossingIndex][2] = newCol
									print("setting the river index of the crossing at " .. currentRow .. ", " .. currentCol .. " to be one index up the river at " .. newRow .. ", " .. newCol)
								end
							end
						end
						
					end
				end
			end
		end
	end
end

--]]

fordResults[1] = {}
fordResults[2] = {}
fordResults[3] = {}

woodBridgeResults = {}
woodBridgeResults[1] = {}
woodBridgeResults[2] = {}
woodBridgeResults[3] = {}

stoneBridgeResults[1] = {}
stoneBridgeResults[2] = {}
stoneBridgeResults[3] = {}

crossingCoordTable = {}


--place 2 crossings in the main river (one for each quadrant)
mainRiverCrossing1Min = 0.05
mainRiverCrossing1Max = 0.09
mainRiverCrossing1Mod = GetRandomInRange(mainRiverCrossing1Min, mainRiverCrossing1Max)

mainRiverBridge1Min = 0.3
mainRiverBridge1Max = 0.35
mainRiverBridge1Mod = GetRandomInRange(mainRiverBridge1Min, mainRiverBridge1Max)

mainRiverCrossing2Min = 0.91
mainRiverCrossing2Max = 0.95
mainRiverCrossing2Mod = GetRandomInRange(mainRiverCrossing2Min, mainRiverCrossing2Max)

mainRiverBridge2Min = 0.65
mainRiverBridge2Max = 0.7
mainRiverBridge2Mod = GetRandomInRange(mainRiverBridge2Min, mainRiverBridge2Max)

mainRiverCrossingIndex1 = math.ceil(#riverResult[1] * mainRiverCrossing1Mod)
mainRiverCrossingIndex2 = math.ceil(#riverResult[1] * mainRiverCrossing2Mod)

mainRiverBridgeIndex1 = math.ceil(#riverResult[1] * mainRiverBridge1Mod)
print("bridge 1 index: " .. mainRiverBridgeIndex1)
mainRiverBridgeIndex2 = math.ceil(#riverResult[1] * mainRiverBridge2Mod)
print("bridge 2 index: " .. mainRiverBridgeIndex2)

crossing1Info = {}
crossing1Row = riverResult[1][mainRiverCrossingIndex1][1]
crossing1Col = riverResult[1][mainRiverCrossingIndex1][2]
crossing1Info = {crossing1Row, crossing1Col}

print("main river crossing 1 at " .. crossing1Row .. ", " .. crossing1Col)

crossing2Info = {}
crossing2Row = riverResult[1][mainRiverCrossingIndex2][1]
crossing2Col = riverResult[1][mainRiverCrossingIndex2][2]
crossing2Info = {crossing2Row, crossing2Col}

print("main river crossing 2 at " .. crossing2Row .. ", " .. crossing2Col)

bridge1Info = {}
bridge1Row = riverResult[1][mainRiverBridgeIndex1][1]
bridge1Col = riverResult[1][mainRiverBridgeIndex1][2]
bridge1Info = {bridge1Row, bridge1Col}
print("bridge 1 row, col: " .. bridge1Row .. ", " .. bridge1Col)

bridge2Info = {}
bridge2Row = riverResult[1][mainRiverBridgeIndex2][1]
bridge2Col = riverResult[1][mainRiverBridgeIndex2][2]
bridge2Info = {bridge2Row, bridge2Col}
print("bridge 2 row, col: " .. bridge2Row .. ", " .. bridge2Col)

river1Fords = {}
river1Bridges = {}

--make crossing 1 ford
table.insert(river1Fords, crossing1Info)

--insert first bridge
table.insert(river1Bridges, bridge1Info)


--make crossing 2 ford
table.insert(river1Fords, crossing2Info)

--insert second bridge
table.insert(river1Bridges, bridge2Info)

table.insert(crossingCoordTable, crossing1Info)
table.insert(crossingCoordTable, bridge1Info)
table.insert(crossingCoordTable, crossing2Info)
table.insert(crossingCoordTable, bridge2Info)


if(#river1Fords > 0) then
	table.insert(fordResults, 1, river1Fords)
end

if(#river1Bridges > 0) then
	table.insert(stoneBridgeResults, 1, river1Bridges)
end

trib1Fords = {}
trib1Bridges = {}

trib2Fords = {}
trib2Bridges = {}

--place a crossing on each of the tributary rivers
trib1CrossingMin = 0.9
trib1CrossingMax = 0.95
trib1CrossingMod = GetRandomInRange(trib1CrossingMin, trib1CrossingMax)

trib1BridgeMin = 0.15
trib1BridgeMax = 0.25
trib1BridgeMod = GetRandomInRange(trib1BridgeMin, trib1BridgeMax)

trib2CrossingMin = 0.9
trib2CrossingMax = 0.95
trib2CrossingMod = GetRandomInRange(trib2CrossingMin, trib2CrossingMax)

trib2BridgeMin = 0.15
trib2BridgeMax = 0.25
trib2BridgeMod = GetRandomInRange(trib2BridgeMin, trib2BridgeMax)

trib1CrossingIndex = math.ceil(#riverResult[2] * trib1CrossingMod)
print("chose trib 1 crossing index of " .. trib1CrossingIndex)

trib1BridgeIndex = math.ceil(#riverResult[2] * trib1BridgeMod)

if(trib1BridgeIndex <= 3) then
	trib1BridgeIndex = 3
end
print("trib 1 bridge index: " .. trib1BridgeIndex)

trib2CrossingIndex = math.ceil(#riverResult[3] * trib2CrossingMod)
print("chose trib 2 crossing index of " .. trib2CrossingIndex)

trib2BridgeIndex = math.ceil(#riverResult[3] * trib2BridgeMod)

if(trib2BridgeIndex <= 3) then
	trib2BridgeIndex = 3
end
print("trib 2 bridge index: " .. trib2BridgeIndex)

if(trib1CrossingIndex < 5 and #riverResult[2] > 5) then
--	print("setting trib 1 crossing index to 5")
--	trib1CrossingIndex = 5
end

if(trib2CrossingIndex < 5 and #riverResult[3] > 5) then
--	trib2CrossingIndex = 5
--	print("setting trib 2 crossing index to 5")
end

trib1CrossingInfo = {}
trib1CrossingRow = riverResult[2][trib1CrossingIndex][1]
trib1CrossingCol = riverResult[2][trib1CrossingIndex][2]
trib1CrossingInfo = {trib1CrossingRow, trib1CrossingCol}

print("trib 1 crossing at " .. trib1CrossingRow .. ", " .. trib1CrossingCol)

trib1BridgeInfo = {}
trib1BridgeRow = riverResult[2][trib1BridgeIndex][1]
trib1BridgeCol = riverResult[2][trib1BridgeIndex][2]

bridgeNeighbors = {}
riverNeighborCount = 0
bridgeNeighbors = GetNeighbors(trib1BridgeRow, trib1BridgeCol, terrainLayoutResult)

for neighborIndex, bridgeNeighbor in ipairs(bridgeNeighbors) do
	--check if this bridge neighbor is a river tile
	currentNeighborRow = bridgeNeighbor.x
	currentNeighborCol = bridgeNeighbor.y 
	if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_river) then
		riverNeighborCount = riverNeighborCount + 1
	end
end

if(riverNeighborCount >= 3) then
	trib1BridgeIndex = trib1BridgeIndex + 1
	trib1BridgeRow = riverResult[2][trib1BridgeIndex][1]
	trib1BridgeCol = riverResult[2][trib1BridgeIndex][2]
end

trib1BridgeInfo = {trib1BridgeRow, trib1BridgeCol}

print("trib 1 bridge at " .. trib1BridgeRow .. ", " .. trib1BridgeCol)

trib2CrossingInfo = {}
trib2CrossingRow = riverResult[3][trib2CrossingIndex][1]
trib2CrossingCol = riverResult[3][trib2CrossingIndex][2]
trib2CrossingInfo = {trib2CrossingRow, trib2CrossingCol}

print("trib 2 crossing at " .. trib2CrossingRow .. ", " .. trib2CrossingCol)

trib2BridgeInfo = {}
trib2BridgeRow = riverResult[3][trib2BridgeIndex][1]
trib2BridgeCol = riverResult[3][trib2BridgeIndex][2]

bridgeNeighbors = {}
riverNeighborCount = 0
bridgeNeighbors = GetNeighbors(trib2BridgeRow, trib2BridgeCol, terrainLayoutResult)

for neighborIndex, bridgeNeighbor in ipairs(bridgeNeighbors) do
	--check if this bridge neighbor is a river tile
	currentNeighborRow = bridgeNeighbor.x
	currentNeighborCol = bridgeNeighbor.y 
	if(terrainLayoutResult[currentNeighborRow][currentNeighborCol].terrainType == tt_river) then
		riverNeighborCount = riverNeighborCount + 1
	end
end

if(riverNeighborCount >= 3) then
	trib2BridgeIndex = trib2BridgeIndex + 1
	trib2BridgeRow = riverResult[3][trib2BridgeIndex][1]
	trib2BridgeCol = riverResult[3][trib2BridgeIndex][2]
end

trib2BridgeInfo = {trib2BridgeRow, trib2BridgeCol}

print("trib 2 bridge at " .. trib2BridgeRow .. ", " .. trib2BridgeCol)

--make trib 1 crossing 1 a ford
table.insert(trib1Fords, trib1CrossingInfo)

--make trib 1 crossing 2 a bridge
table.insert(trib1Bridges, trib1BridgeInfo)


--make trib 2 crossing 2 a ford
table.insert(trib2Fords, trib2CrossingInfo)

--make trib 2 crossing 1 a bridge
table.insert(trib2Bridges, trib2BridgeInfo)

table.insert(crossingCoordTable, trib1CrossingInfo)
table.insert(crossingCoordTable, trib1BridgeInfo)
table.insert(crossingCoordTable, trib2CrossingInfo)
table.insert(crossingCoordTable, trib2BridgeInfo)


if(#trib1Fords > 0) then
	table.insert(fordResults, 2, trib1Fords)
end

if(#trib1Bridges > 0) then
	table.insert(stoneBridgeResults, 2, trib1Bridges)
end

if(#trib2Fords > 0) then
	table.insert(fordResults, 3, trib2Fords)
end

if(#trib2Bridges > 0) then
	table.insert(stoneBridgeResults, 3, trib2Bridges)
end


---------------------
-- SETS ALL TILES NEXT TO RIVERS INTO PLAINS
---------------------

--GetNeighbors(xLoc, yLoc, terrainGrid)

-- loop through grid
-- if riverpoint, get neighbor (returns a table)
-- loop through returned table and check if river
-- if not river set to plains

tempNeighborList = {}

for row = 1, gridSize do
	for col = 1, gridSize do
		-- first loop that checks if the tile is a river
		if (terrainLayoutResult[row][col].terrainType == tt_river) then
			-- if river, then find all the neighbors
			tempNeighborList = GetNeighbors(row, col, terrainLayoutResult)
			
			--second loop, checks the neighbor tiles
			for index, neighbor in ipairs(tempNeighborList) do
				
				tempRow = neighbor.x
				tempCol = neighbor.y
				
				-- if the tile is not a river tile, then
				if(terrainLayoutResult[tempRow][tempCol].terrainType ~= tt_river) then					
					--set to plains
					terrainLayoutResult[tempRow][tempCol].terrainType = tt_plains
				end
			end			
		end
	end
end


--place holy sites specifically in the corners of the confluence
--do vertical main river
if riverType == 1 then
	print("placing holy sites with vertical main river")
	
	holy1Row = trib01StartRow - 3
	holy1Col = trib01StartColumn - 3
	
	holy2Row = trib01StartRow + 3
	holy2Col = trib01StartColumn - 3
	
	holy3Row = trib02StartRow + 3
	holy3Col = trib02StartColumn + 3
	
	holy4Row = trib02StartRow - 3
	holy4Col = trib02StartColumn + 3
		

	
	
--else it's a horizontal main river
else
	print("placing holy sites with horizontal main river")
	
	holy1Row = trib01StartRow - 3
	holy1Col = trib01StartColumn - 3
	
	holy2Row = trib01StartRow - 3
	holy2Col = trib01StartColumn + 3
	
	holy3Row = trib02StartRow + 3
	holy3Col = trib02StartColumn - 3
	
	holy4Row = trib02StartRow + 3
	holy4Col = trib02StartColumn + 3


end

terrainLayoutResult[holy1Row][holy1Col].terrainType = tt_confluence_holy_site
terrainLayoutResult[holy2Row][holy2Col].terrainType = tt_confluence_holy_site
	
terrainLayoutResult[holy3Row][holy3Col].terrainType = tt_confluence_holy_site
terrainLayoutResult[holy4Row][holy4Col].terrainType = tt_confluence_holy_site

print("placing holy site at " .. holy1Row .. ", " .. holy1Col)
print("placing holy site at " .. holy2Row .. ", " .. holy2Col)
print("placing holy site at " .. holy3Row .. ", " .. holy3Col)
print("placing holy site at " .. holy4Row .. ", " .. holy4Col)


------------------------
-- PLAYER STARTS SETUP
------------------------
teamsList, playersPerTeam = SetUpTeams()

teamMappingTable = CreateTeamMappingTable()

innerExclusion = 0.35

if(worldTerrainWidth <= 417) then
		riverRadius = 2
		playerRadius = 2
		minPlayerDistance = 9
		minTeamDistance = math.ceil(#terrainLayoutResult * 1.2)
		forestCountPerQuarter = 4
	spawnBlockDistance = 3
	cornerThreshold = 0
	innerExclusion = 0.35
	elseif(worldTerrainWidth <= 513) then
		riverRadius = 2
		playerRadius = 2
		minPlayerDistance = 8
		minTeamDistance = math.ceil(#terrainLayoutResult * 0.75)
		forestCountPerQuarter = 5
	spawnBlockDistance = 3
	cornerThreshold = 0
	innerExclusion = 0.36
	elseif(worldTerrainWidth <= 641) then
		riverRadius = 2
		playerRadius = 3
		minPlayerDistance = 8
		minTeamDistance = math.ceil(#terrainLayoutResult * 0.75)
		forestCountPerQuarter = 6
	spawnBlockDistance = 3
	cornerThreshold = 0
	innerExclusion = 0.385
	elseif(worldTerrainWidth <= 769) then
		riverRadius = 3
		playerRadius = 4
		minPlayerDistance = 8
		minTeamDistance = math.ceil(#terrainLayoutResult * 0.75)
		forestCountPerQuarter = 7
	spawnBlockDistance = 4
	cornerThreshold = 1
	innerExclusion = 0.425
	else
		riverRadius = 4
		playerRadius = 4
		minPlayerDistance = 10
		minTeamDistance = math.ceil(#terrainLayoutResult * 0.75)
		forestCountPerQuarter = 8
	spawnBlockDistance = 4
	cornerThreshold = 1
	innerExclusion = 0.525
	end


edgeBuffer = 1

playerStartTerrain = tt_player_start_classic_plains

spawnBlockers = {}
table.insert(spawnBlockers, tt_impasse_mountains)
table.insert(spawnBlockers, tt_mountains)
table.insert(spawnBlockers, tt_plateau_med)
table.insert(spawnBlockers, tt_ocean)
table.insert(spawnBlockers, tt_river)
table.insert(spawnBlockers, tt_confluence_holy_site)

basicTerrain = {}
table.insert(basicTerrain, tt_none)
table.insert(basicTerrain, tt_plains)
table.insert(basicTerrain, tt_plains_clearing)
table.insert(basicTerrain, tt_flatland)
table.insert(basicTerrain, tt_plateau_low)

if(randomPositions == true) then
	terrainLayoutResult = PlacePlayerStartsRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, 1, spawnBlockers, spawnBlockDistance, 0.01, playerStartTerrain, tt_plains_smooth, 3, true, terrainLayoutResult)
else
	
	--use divided map spawn if 2 teams
	if(#teamMappingTable == 2 and worldPlayerCount > 2) then
		if(worldGetRandom() < 0.5) then
			terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, false, spawnBlockers, spawnBlockDistance, 0.01, playerStartTerrain, tt_plains_smooth, 3, true, terrainLayoutResult)
		else
			terrainLayoutResult = PlacePlayerStartsDivided(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, true, spawnBlockers, spawnBlockDistance, 0.01, playerStartTerrain, tt_plains_smooth, 3, true, terrainLayoutResult)
		end
	else
		if(worldTerrainWidth <= 417) then
			minPlayerDistance = 3.5
		elseif(worldTerrainWidth <= 513) then
			minPlayerDistance = 4.5
		elseif(worldTerrainWidth <= 641) then
			minPlayerDistance = 4.5
		elseif(worldTerrainWidth <= 769) then
			minPlayerDistance = 5.5
		else
			minPlayerDistance = 6.5
		end
		--else use ring spawn
		innerExclusion = 0.45
	--	spawnBlockDistance = spawnBlockDistance + 1
		terrainLayoutResult = PlacePlayerStartsTogetherRing(teamMappingTable, minTeamDistance, minPlayerDistance, edgeBuffer, innerExclusion, cornerThreshold, spawnBlockers, spawnBlockDistance, 0.01, playerStartTerrain, tt_plains_smooth, 3, true, terrainLayoutResult)
	end
	
end



--loop through all quarters and remove squares that aren't near the river, or are near player starts or holy sites
for quarterIndex = 1, 4 do
	currentQuarter = landQuarters[quarterIndex]
	
	--loop through this current quarter
	for currentQuarterIndex = #currentQuarter, 1, -1 do
	
		removeSquare = false
		--check for river proximity	
		riverNeighbors = 0
		currentRiverNeighbors = GetAllSquaresInRadius(currentQuarter[currentQuarterIndex][1], currentQuarter[currentQuarterIndex][2], riverRadius, terrainLayoutResult)
		for neighborIndex, riverNeighbor in ipairs(currentRiverNeighbors) do
			currentRow = riverNeighbor[1]
			currentCol = riverNeighbor[2]
			if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_river) then
				riverNeighbors = riverNeighbors + 1
			end
		end
		
		--check for start or holy site proximity
		startNeighbors = 0
		currentStartNeighbors = GetAllSquaresInRadius(currentQuarter[currentQuarterIndex][1], currentQuarter[currentQuarterIndex][2], playerRadius, terrainLayoutResult)
		for neighborIndex, startNeighbor in ipairs(currentStartNeighbors) do
			currentRow = startNeighbor[1]
			currentCol = startNeighbor[2]
			if(terrainLayoutResult[currentRow][currentCol].terrainType == playerStartTerrain or terrainLayoutResult[currentRow][currentCol].terrainType == tt_confluence_holy_site) then
				startNeighbors = startNeighbors + 1
			end
		end
		
		--check for crossing neighbors
		crossingNeighbors = 0
		currentRiverNeighbors = GetAllSquaresInRadius(currentQuarter[currentQuarterIndex][1], currentQuarter[currentQuarterIndex][2], riverRadius, terrainLayoutResult)
		for neighborIndex, riverNeighbor in ipairs(currentRiverNeighbors) do
			currentRow = riverNeighbor[1]
			currentCol = riverNeighbor[2]
			
			--loop through and check for a match in the crossing table
			for crossingCoordIndex = 1, #crossingCoordTable do
				currentCrossingRow = crossingCoordTable[crossingCoordIndex][1]
				currentCrossingCol = crossingCoordTable[crossingCoordIndex][2]
				
				if(currentRow == currentCrossingRow and currentCol == currentCrossingCol) then
					crossingNeighbors = crossingNeighbors + 1
				end
			end
		end
		
		if(riverNeighbors == 0 or startNeighbors > 0 or crossingNeighbors > 0) then
			table.remove(landQuarters[quarterIndex], currentQuarterIndex)
		end
		
	end
	
end

print("after removals, land quarter 1 has " .. #landQuarter1 .. " squares")
print("after removals, land quarter 2 has " .. #landQuarter2 .. " squares")
print("after removals, land quarter 3 has " .. #landQuarter3 .. " squares")
print("after removals, land quarter 4 has " .. #landQuarter4 .. " squares")

--quarters should now be only squares close to rivers and away from player starts

tradePostRoll = worldGetRandom()
print("trade post roll: " .. tradePostRoll)



for quarterIndex = 1, 4 do
	currentQuarter = landQuarters[quarterIndex]
	
	
	
	currentQuarterRandomSquareIndex = math.ceil(worldGetRandom() * #currentQuarter)
	currentRow = currentQuarter[currentQuarterRandomSquareIndex][1]
	currentCol = currentQuarter[currentQuarterRandomSquareIndex][2]
	
--	terrainLayoutResult[currentRow][currentCol].terrainType = tt_confluence_holy_site
--	print("placing holy site at " .. currentRow .. ", " .. currentCol)
--	table.remove(landQuarters[quarterIndex], currentQuarterRandomSquareIndex)
	
	if(tradePostRoll > 0.5) then
		if (quarterIndex == 1 or quarterIndex == 4) then
			currentQuarterRandomSquareIndex = math.ceil(worldGetRandom() * #currentQuarter)
			currentRow = currentQuarter[currentQuarterRandomSquareIndex][1]
			currentCol = currentQuarter[currentQuarterRandomSquareIndex][2]
			print("placing trade post at " .. currentRow .. ", " .. currentCol)
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_settlement_plains
		end
	else
		if(quarterIndex == 2 or quarterIndex == 3) then
			currentQuarterRandomSquareIndex = math.ceil(worldGetRandom() * #currentQuarter)
			currentRow = currentQuarter[currentQuarterRandomSquareIndex][1]
			currentCol = currentQuarter[currentQuarterRandomSquareIndex][2]
			print("placing trade post at " .. currentRow .. ", " .. currentCol)
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_settlement_plains
		end
	end
	
	
end

--add in forests per quarter, remove river-adjacent squares to make sure forests don't overlap crossings
--[[
for quarterIndex = 1, 4 do
	currentQuarter = landQuarters[quarterIndex]
	
	--loop through this current quarter
	for currentQuarterIndex = #currentQuarter, 1, -1 do
	
		removeSquare = false
		--check for river adjacency	
		riverNeighbors = 0
		currentRiverNeighbors = GetAllSquaresInRadius(currentQuarter[currentQuarterIndex][1], currentQuarter[currentQuarterIndex][2], 1.75, terrainLayoutResult)
		for neighborIndex, riverNeighbor in ipairs(currentRiverNeighbors) do
			currentRow = riverNeighbor[1]
			currentCol = riverNeighbor[2]
			if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_river) then
				riverNeighbors = riverNeighbors + 1
			end
		end
		
		
		if(riverNeighbors > 0) then
			table.remove(landQuarters[quarterIndex], currentQuarterIndex)
		end
		
	end
	
end

for quarterIndex = 1, 4 do
	currentQuarter = landQuarters[quarterIndex]
	
	currentForestsPlaced = 0
	for currentQuarterIndex = 1, #landQuarters[quarterIndex] do
		
		currentQuarterRandomSquareIndex = math.ceil(worldGetRandom() * #currentQuarter)
		currentRow = currentQuarter[currentQuarterRandomSquareIndex][1]
		currentCol = currentQuarter[currentQuarterRandomSquareIndex][2]
		
		if(currentForestsPlaced < forestCountPerQuarter) then
			terrainLayoutResult[currentRow][currentCol].terrainType = tt_impasse_trees_plains_gaps
			currentForestsPlaced = currentForestsPlaced + 1
			table.remove(landQuarters[quarterIndex], currentQuarterRandomSquareIndex)
		end
		
	end
end
--]]

for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
	
		if(terrainLayoutResult[row][col].terrainType == tt_settlement_plains or terrainLayoutResult[row][col].terrainType == tt_confluence_holy_site or terrainLayoutResult[row][col].terrainType == tt_river or terrainLayoutResult[row][col].terrainType == playerStartTerrain) then
			
			--check for proximity	
			currentNonPlainNeighbors = GetNeighbors(row, col, terrainLayoutResult)
			for neighborIndex, nonPlainNeighbor in ipairs(currentNonPlainNeighbors) do
				currentRow = nonPlainNeighbor.x
				currentCol = nonPlainNeighbor.y
				if(terrainLayoutResult[currentRow][currentCol].terrainType == tt_plains) then
					terrainLayoutResult[currentRow][currentCol].terrainType = tt_plains_smooth
				end
				
			end
			
		end
		
	end
end

--set all terrain squares away from the river and player starts to tt_none
for row = 1, #terrainLayoutResult do
	for col = 1, #terrainLayoutResult do
	
		if(terrainLayoutResult[row][col].terrainType == tt_plains) then
			
			terrainLayoutResult[row][col].terrainType = tt_none
		end
		
	end
end

--ensure that holy sites are not overwritten
terrainLayoutResult[holy1Row][holy1Col].terrainType = tt_confluence_holy_site
terrainLayoutResult[holy2Row][holy2Col].terrainType = tt_confluence_holy_site
	
terrainLayoutResult[holy3Row][holy3Col].terrainType = tt_confluence_holy_site
terrainLayoutResult[holy4Row][holy4Col].terrainType = tt_confluence_holy_site






print("END OF CONFLUENCE LUA SCRIPT")