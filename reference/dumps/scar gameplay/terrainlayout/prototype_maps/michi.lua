n = tt_none

h = tt_hills
m = tt_mountains
i = tt_impasse_mountains
b = tt_hills_high_rolling
o = tt_ocean
p = tt_plains
f = tt_flatland
s = tt_player_start_hills
bb = tt_bounty_berries_flatland
bg = tt_bounty_gold_plains
pl = tt_hills_plateau
f = tt_impasse_trees_plains
cc = tt_city_centre
cf = tt_city_farming
cm = tt_city_military
cl = tt_city_lumbercamp
cs = tt_city_stonecamp
cg = tt_city_goldcamp

sp = tt_settlement_plains
sh = tt_settlement_hills
seb = tt_settlement_hills_high_rolling


--[[
nnn = tt_none

ths = tt_hills
tmn = tt_mountains
tmi = tt_impasse_mountains
thl = tt_hills_high_rolling
tpn = tt_plains
tfn = tt_flatland
shn = tt_player_start_nomad_hills
rfnf = tt_bounty_berries_flatland
rpng = tt_bounty_gold_plains
tbn = tt_hills_plateau
tpf = tt_impasse_trees_plains
tvn = tt_valley

ccc = tt_city_centre
cfc = tt_city_farming
cmc = tt_city_military
clc = tt_city_lumbercamp
csc = tt_city_stonecamp
cgc = tt_city_goldcamp

--]]

terrainLayoutResult = {}    -- set up initial table for coarse map grid

gridHeight = Round(worldTerrainHeight / 46.5, 0) -- set resolution of coarse map rows
gridWidth = Round(worldTerrainWidth / 46.5, 0) -- set resolution of coarse map columns

if (gridHeight % 2 == 0) then -- height is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridHeight = gridHeight - 1
end

if (gridWidth % 2 == 0) then -- width is even so subtract 1 (we want odd numbered grid sizes so that there is a center line in map)
	gridWidth = gridWidth - 1
end


gridSize = gridWidth -- set resolution of coarse map

playerStarts = worldPlayerCount

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

forestChance = 0.5
mountainChance = 1 - forestChance


--set map size specific scaling options
if(gridSize == 11) then
	
	numberOfSettlements = 0
end

if(gridSize == 17) then
	
	numberOfSettlements = 0
end

if(gridSize >= 21) then
	
	numberOfSettlements = 0
end


-- MAP SPECIFIC STUFF

for y = 1, gridSize do
	for x = 1, gridSize do
	
		--generate a line of trees through the centre of the map
		--[[
		if(x == mapHalfSize) then
			terrainLayoutResult[x][y] = f
		end
		--]]
		if((x == mapHalfSize)) then
			terrainLayoutResult[x][y] = f
		
			--[[
			if(worldGetRandom() < forestChance) then
				terrainLayoutResult[x][y] = f
			else
				terrainLayoutResult[x][y] = m
			end
			--]]
			
		end
		--generate either more trees or mountains surrounding the forest
		
	end
end

terrainLayoutResult[mapHalfSize][mapHalfSize] = sp
terrainLayoutResult[mapQuarterSize][mapHalfSize] = sp
terrainLayoutResult[mapHalfSize + mapQuarterSize][mapHalfSize] = sp

terrainLayoutResult[mapHalfSize-1][mapHalfSize-1] = f
terrainLayoutResult[mapHalfSize+1][mapHalfSize+1] = f
terrainLayoutResult[mapHalfSize+1][mapHalfSize-1] = f
terrainLayoutResult[mapHalfSize-1][mapHalfSize+1] = f
terrainLayoutResult[mapHalfSize-2][mapHalfSize] = f
terrainLayoutResult[mapHalfSize+2][mapHalfSize] = f
terrainLayoutResult[mapHalfSize][mapHalfSize-2] = f
terrainLayoutResult[mapHalfSize][mapHalfSize+2] = f
terrainLayoutResult[mapHalfSize-2][mapHalfSize+1] = f
terrainLayoutResult[mapHalfSize+2][mapHalfSize+1] = f
terrainLayoutResult[mapHalfSize-2][mapHalfSize-1] = f
terrainLayoutResult[mapHalfSize+2][mapHalfSize-1] = f

terrainLayoutResult[mapHalfSize-1][mapHalfSize+2] = f
terrainLayoutResult[mapHalfSize+1][mapHalfSize+2] = f
terrainLayoutResult[mapHalfSize-1][mapHalfSize-2] = f
terrainLayoutResult[mapHalfSize+1][mapHalfSize-2] = f





--[[
--testing terrain library functions
stamp1 = GetMountainCityFeature()
stamp2 = GetMountainCityFeature()
--stamp3 = GetPlateauFeature()

print("Stamp 1: PRE ROTATE")
for i = table.getn(stamp1[1]), 1, -1 do
		currentString = ""
		for j = 1, table.getn(stamp1[1]) do
			currentString = currentString .. (stamp1[i][j] .. ", ")
		end
		print(currentString)
	end


stamp2 = RotateStamp(stamp2, 270)

--print the stamp
print("Stamp 1:")
for i = table.getn(stamp1[1]), 1, -1 do
		currentString = ""
		for j = 1, table.getn(stamp1[1]) do
			currentString = currentString .. (stamp1[i][j] .. ", ")
		end
		print(currentString)
	end
	
print("--------------------------------")
print("Stamp 2:")

for i = table.getn(stamp2[1]), 1, -1 do
		currentString = ""
		for j = 1, table.getn(stamp2[1]) do
			currentString = currentString .. (stamp2[i][j] .. ", ")
		end
		print(currentString)
	end


terrainLayoutResult = ReplaceTerrain(terrainLayoutResult, mapHalfSize, mapHalfSize-5, stamp1)

terrainLayoutResult = ReplaceTerrain(terrainLayoutResult, mapHalfSize-7, mapHalfSize, stamp2)

--terrainLayoutResult = ReplaceTerrain(terrainLayoutResult, mapHalfSize+5, mapHalfSize+2, stamp3)

--]]


--set player start locations
playerStart1x = 3
playerStart1y = 3

playerStart2x = gridSize - 2
playerStart2y = gridSize - 2

--for games of 4 or more people
playerStart3x = gridSize - 2
playerStart3y = 3

playerStart4x = 3
playerStart4y = gridSize - 2

playerStart5x = 3
playerStart5y = mapHalfSize

playerStart6x = gridSize - 2
playerStart6y = mapHalfSize

playerStart7x = mapHalfSize 
playerStart7y = mapEighthSize - 1

playerStart8x = mapHalfSize
playerStart8y = ((gridSize - mapEighthSize) + 1)


--set player start locations on the map
startLocationPositions = {}

table.insert(startLocationPositions, {playerStart1x, playerStart1y})
table.insert(startLocationPositions, {playerStart2x, playerStart2y})
table.insert(startLocationPositions, {playerStart3x, playerStart3y})
table.insert(startLocationPositions, {playerStart4x, playerStart4y})
table.insert(startLocationPositions, {playerStart5x, playerStart5y})
table.insert(startLocationPositions, {playerStart6x, playerStart6y})
table.insert(startLocationPositions, {playerStart7x, playerStart7y})
table.insert(startLocationPositions, {playerStart8x, playerStart8y})


--2 players
if(playerStarts >= 2) then
-- set the starting areas to be elevated hills
	--player 1
	terrainLayoutResult[playerStart1x][playerStart1y] = s
	terrainLayoutResult[playerStart1x+1][playerStart1y] = h
	terrainLayoutResult[playerStart1x][playerStart1y+1] = b
	terrainLayoutResult[playerStart1x][playerStart1y-1] = b
	terrainLayoutResult[playerStart1x+1][playerStart1y+2] = h
	print("player 1 location placed")
	
	
	--player 2
	terrainLayoutResult[playerStart2x][playerStart2y] = s
	terrainLayoutResult[playerStart2x-1][playerStart2y] = b
	terrainLayoutResult[playerStart2x][playerStart2y+1] = h
	terrainLayoutResult[playerStart2x][playerStart2y-1] = b
	terrainLayoutResult[playerStart2x-1][playerStart2y-2] = h
	print("player 2 location placed")
	
	
end

--4 or more players
if(playerStarts >= 4) then
	--player 3
	terrainLayoutResult[playerStart3x][playerStart3y] = s
	terrainLayoutResult[playerStart3x-1][playerStart3y] = b
	terrainLayoutResult[playerStart3x][playerStart3y+1] = b
	terrainLayoutResult[playerStart3x][playerStart3y-1] = h
	terrainLayoutResult[playerStart3x-1][playerStart3y+2] = h
	print("player 3 location placed")
	
	
	--player 4
	terrainLayoutResult[playerStart4x][playerStart4y] = s
	terrainLayoutResult[playerStart4x-1][playerStart4y] = cc
	terrainLayoutResult[playerStart4x][playerStart4y+2] = cf
	terrainLayoutResult[playerStart4x][playerStart4y-2] = cm
	terrainLayoutResult[playerStart4x+1][playerStart4y-3] = cl
	terrainLayoutResult[playerStart4x+2][playerStart4y-4] = cs
	terrainLayoutResult[playerStart4x][playerStart4y-3] = cg
	print("player 4 location placed")
	

end

--5 players
if(playerStarts >= 5) then
	--player 5
	terrainLayoutResult[playerStart5x][playerStart5y] = s
	terrainLayoutResult[playerStart5x-1][playerStart5y] = b
	terrainLayoutResult[playerStart5x][playerStart5y+1] = b
	terrainLayoutResult[playerStart5x][playerStart5y-1] = b
	terrainLayoutResult[playerStart5x+1][playerStart5y] = m
	print("player 5 location placed")
	
	end
	

--player 6
if(playerStarts >= 6) then
	terrainLayoutResult[playerStart6x][playerStart6y] = s
	terrainLayoutResult[playerStart6x-1][playerStart6y] = m
	terrainLayoutResult[playerStart6x][playerStart6y+1] = b
	terrainLayoutResult[playerStart6x][playerStart6y-1] = b
	print("player 6 location placed")
	

end

--player 7
if(playerStarts >= 7) then
	terrainLayoutResult[playerStart7x][playerStart7y] = s
	terrainLayoutResult[playerStart7x-1][playerStart7y] = b
	terrainLayoutResult[playerStart7x][playerStart7y+1] = b
	terrainLayoutResult[playerStart7x][playerStart7y-1] = b
	print("player 7 location placed")
	
end


--player 8
if(playerStarts == 8) then
	terrainLayoutResult[playerStart8x][playerStart8y] = s
	terrainLayoutResult[playerStart8x-1][playerStart8y] = b
	terrainLayoutResult[playerStart8x][playerStart8y+1] = b
	terrainLayoutResult[playerStart8x][playerStart8y-1] = b
	print("player 8 location placed")
	

end




--Settlement placing
-- place settlements


if(gridSize > 11) then


settlementLocations = {}
--minimumSettlementDistance = Round(2 / 11 * gridSize, 0)
minimumSettlementDistance = 2
print("MinimumSettlement Distance = " ..minimumSettlementDistance)

-- find a place to put the settlement
print("PLACING " ..numberOfSettlements .." SETTLEMENTS")

-- find all hte null squares remaining on the coarse grid for settlement placement
validSquareList = GetSquaresOfType(n, gridSize, terrainLayoutResult)

-- remove any null squares on the outside rows and columns of the coarse grid to keep settlements away from the edges
for index = table.getn(validSquareList), 1, -1 do	
	print ("Row: " ..validSquareList[index][1] ..", Col: " ..validSquareList[index][2] .." Index: " ..index)
	
	if (validSquareList[index][1] == 1 or validSquareList[index][1] == gridSize) then
		print("Removing because row")
		table.remove(validSquareList, index)
	elseif (validSquareList[index][2] == 1 or validSquareList[index][2] == gridSize) then
		print("Removing because col")
		table.remove(validSquareList, index)
	end
	
end

-- cycle through each settlement and attempt to place one while making sure they are not too close to players and other settlements	
for index = 1, numberOfSettlements do
	settlementPlaced = false
	print("FINDING LOCATION OF SETTLEMENT " ..index)

	while (settlementPlaced == false and table.getn(validSquareList) > 0) do
		squareChoice = {}
		squareIndex = (Round((worldGetRandom() - 1E-10) * (table.getn(validSquareList) - 1), 0)) + 1
		squareChoice = validSquareList[squareIndex]
		print("Square at row "  ..squareChoice[1] ..", coloumn " ..squareChoice[2])
		
		x, y = squareChoice[1], squareChoice[2]
		farEnoughFromPlayers = false
		farEnoughFromSettlements = false
		print("----- Squares remaining: " ..table.getn(validSquareList) .." -----------------")
		print("CHECKING DISTANCE FROM PLAYER...")
		
		if (SquaresFarEnoughApart(x, y, minimumSettlementDistance, startLocationPositions, gridSize) == true) then
			print("**********  FAR ENOUGH AWAY **********")
			print("VALID PLAYER START DISTANCE")
			farEnoughFromPlayers = true
		else
			print("**********  TOO CLOSE **********")
			print("TOO CLOSE TO PLAYER START LOCATION ")
			farEnoughFromPlayers = false
			table.remove(validSquareList, squareIndex)
		end

		if (farEnoughFromPlayers == true) then
			
			if (table.getn(settlementLocations) > 0) then
				print("CHECKING SETTLEMENT DISTANCE")	
				
				if (SquaresFarEnoughApart(x, y, (minimumSettlementDistance + 2), settlementLocations, gridSize) == true) then
					print("**********  FAR ENOUGH AWAY **********")
					print("VALID SETTLEMENT DISTANCE")
					farEnoughFromSettlements = true
				else
					print("**********  TOO CLOSE **********")
					print("TOO CLOSE TO SETTLEMENT LOCATION")
					farEnoughFromSettlements = false
					table.remove(validSquareList, squareIndex)
				end
				
			else
				print("FIRST SETTLEMENT. SETTLEMENT DISTANCE CHECK NOT REQUIRED.")
				farEnoughFromSettlements = true
			end
			
		end
		
		if (farEnoughFromPlayers == true and farEnoughFromSettlements == true) then
			table.insert(settlementLocations,{x, y})
			table.remove(validSquareList, squareIndex)
			print("SETTLEMENT " ..table.getn(settlementLocations) .." PLACED AT: " ..x ..", " ..y)
			settlementPlaced = true	
		end
		
	end
	
end

for index, value in ipairs(settlementLocations) do
	
	if (worldGetRandom() < .55) then
		terrainLayoutResult[value[1]][value[2]] = sp
	else
		terrainLayoutResult[value[1]][value[2]] = sh
	end
	
end

else
	terrainLayoutResult[mapHalfSize][mapHalfSize] = sp
end
