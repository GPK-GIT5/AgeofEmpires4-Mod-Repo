
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
--bs = tt_bounty_stone_plains
pl = tt_hills_plateau

sp = tt_settlement_plains
sh = tt_settlement_hills
seb = tt_settlement_hills_high_rolling

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


testTrig = math.atan(7/5)
print("The trig output for the TESTTRIG var is " .. testTrig)
	

-- setting up the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)

mapHalfSize = math.ceil(gridSize/2)
mapQuarterSize = math.ceil(gridSize/4)
mapEighthSize = math.ceil(gridSize/8)

--set map size specific scaling options

numberOfSettlements = 1

if(gridSize == 11) then
	numberOfSettlements = 1
end

if(gridSize == 17) then
	numberOfSettlements = 3
end

if(gridSize >= 21) then
	numberOfSettlements = 3
end


--set the circle of plateaus
--top to right
DrawLineOfTerrain(mapHalfSize, (mapHalfSize+mapQuarterSize), (mapHalfSize+mapQuarterSize), mapHalfSize, pl, true, gridSize)
--right to bottom
DrawLineOfTerrain((mapHalfSize+mapQuarterSize), mapHalfSize, mapHalfSize, mapQuarterSize, pl, true, gridSize)
--bottom to left
DrawLineOfTerrain(mapHalfSize, mapQuarterSize, mapQuarterSize, mapHalfSize, pl, true, gridSize)
--left to top
DrawLineOfTerrain(mapQuarterSize, mapHalfSize, mapHalfSize, (mapHalfSize+mapQuarterSize), pl, true, gridSize)


--bisect central crater
--DrawLineOfTerrain(mapHalfSize, mapQuarterSize, mapHalfSize, (mapHalfSize + mapQuarterSize), m, false, gridSize)


mountainChance = 0.75
hillChance = 1 - mountainChance
spokeCount = 2
firstQuad = "none"


--set centre square to be a mountain
terrainLayoutResult[mapHalfSize][mapHalfSize] = m


--find the mountains
mountainRing = GetSquaresOfType(pl, gridSize, terrainLayoutResult)


endX = gridSize
endY = gridSize

--for i = 1, spokeCount do

	
	--choose one randomly
	chosenIndex = Round(worldGetRandom() * table.getn(mountainRing))
	chosenMountain = mountainRing[chosenIndex]
	mountainX, mountainY = chosenMountain[1], chosenMountain[2]
	table.remove(mountainRing, chosenIndex)
	
	
	print("Chosen mountain X: " .. mountainX)
	print("Chosen mountain Y: " .. mountainY)
	--choose spoke to create based on location of chosen mountain
	
	--let's do some MATH
	
	--get distances to either side of the map on the X axis
	distL = mountainX
	distR = gridSize - mountainX
	
	--get distances on the Y axis
	distD = mountainY
	distU = gridSize - mountainY
	
	leftClose = false
	rightclose = false
	upClose = false
	downClose = false
	
	print("distance left: " .. distL)
	print("distance right: " .. distR)
	print("distance down: " .. distD)
	print("distance up: " .. distU)
	
	--set some bools to determine quadrant
	
	
	if(distL < distR) then
		leftClose = true
		rightClose = false
	else
		leftClose = false
		rightClose = true
	end
	
	if(distD < distU) then
		downClose = true
		upClsoe = false
	else
		downClose = false
		upClose = true
	end
	
	--let's get into the 4 quadrant cases
	
	--BOTTOM LEFT
	if(downClose == true and leftClose == true) then
		
		firstQuad = "bottomLeft"
		print("STARTING THE BOTTOM LEFT QUADRANT CALCULATIONS")
		--closer to the left than the bottom
		if(distL < distD) then
			triX = math.abs(mapHalfSize - distL)
			triY = math.abs(mapHalfSize - distD)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triY / triX))
			print("angle: " .. angle)
			
			endX = 1
			endY = Round((1 - (angle / 45)) * mapHalfSize)
			print("angle / 45: " .. angle/45)
			
		--closer to the bottom than the left
		else
			triX = math.abs(mapHalfSize - distL)
			triY = math.abs(mapHalfSize - distD)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triX / triY))
			print("angle: " .. angle)
			endX = Round((1 - (angle / 45)) * mapHalfSize)
			endY = 1
			print("angle / 45: " .. angle/45)
		end
	end
	
	--TOP LEFT
	if(upClose == true and leftClose == true) then
	
		firstQuad = "topLeft"
		print("STARTING THE TOP LEFT QUADRANT CALCULATIONS")
		--closer to the left than the top
		if(distL < distU) then
			triX = math.abs(mapHalfSize - distL)
			triY = math.abs(mapHalfSize - distU)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triY / triX))
			print("angle: " .. angle)
			endX = 1
			endY = Round((1 - (angle / 45)) * mapHalfSize) + mapHalfSize
			print("angle / 45: " .. angle/45)
		--closer to the top than the left
		else
			triX = math.abs(mapHalfSize - distL)
			triY = math.abs(mapHalfSize - distU)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triX / triY))
			
			endX = Round((1 - (angle / 45)) * mapHalfSize)
			endY = gridSize
			print("angle / 45: " .. angle/45)
		end
	end
	
	--TOP RIGHT
	if(upClose == true and rightClose == true) then
	
		firstQuad = "topRight"
		print("STARTING THE TOP RIGHT QUADRANT CALCULATIONS")
		--closer to the right than the top
		if(distR < distU) then
			triX = math.abs(mapHalfSize - distR)
			triY = math.abs(mapHalfSize - distU)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triY / triX))
			print("angle: " .. angle)
			endX = gridSize
			endY = Round((1 - (angle / 45)) * mapHalfSize) + mapHalfSize
			print("angle / 45: " .. angle/45)
		--closer to the top than the right
		else
			triX = math.abs(mapHalfSize - distR)
			triY = math.abs(mapHalfSize - distU)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triX / triY))
			print("angle: " .. angle)
			endX = Round((1 - (angle / 45)) * mapHalfSize) + mapHalfSize
			endY = gridSize
			print("angle / 45: " .. angle/45)
		end
	end
	
	--BOTTOM RIGHT
	if(downClose == true and rightClose == true) then
	
		firstQuad = "bottomRight"
		print("STARTING THE BOTTOM RIGHT QUADRANT CALCULATIONS")
		--closer to the right than the bottom
		if(distR < distD) then
			triX = math.abs(mapHalfSize - distR)
			triY = math.abs(mapHalfSize - distD)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triY / triX))
			print("angle: " .. angle)
			endX = gridSize
			endY = Round((1 - (angle / 45)) * mapHalfSize)
			print("angle / 45: " .. angle/45)
		--closer to the bottom than the right
		else
			triX = math.abs(mapHalfSize - distR)
			triY = math.abs(mapHalfSize - distD)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triX / triY))
			print("angle: " .. angle)
			endX = Round((1 - (angle / 45)) * mapHalfSize) + mapHalfSize
			endY = 1
			print("angle / 45: " .. angle/45)
		end
	end
	
	print("End X value: " .. endX)
	print("End Y value: " .. endY)
	
	DrawLineOfTerrain(mountainY, mountainX, endY, endX, m, false, gridSize)
	
	mountain1X = mountainX
	mountain1Y = mountainY
	
	--[[
	--noob method
	if(mountainX <= mapHalfSize) then
		DrawLineToLeftEdge(mountainX, mountainY, m, gridSize, worldGetRandom(), 1)

	else
		DrawLineToRightEdge(mountainX, mountainY, m, gridSize, worldGetRandom(), 1)
	end
	--]]
	
--end

--Draw second spoke
secondQuad = "none"

--choose one randomly
	chosenIndex = Round(worldGetRandom() * table.getn(mountainRing))
	chosenMountain = mountainRing[chosenIndex]
	mountainX, mountainY = chosenMountain[1], chosenMountain[2]
	table.remove(mountainRing, chosenIndex)
	
	
	print("Chosen mountain X: " .. mountainX)
	print("Chosen mountain Y: " .. mountainY)
	--choose spoke to create based on location of chosen mountain
	
	--let's do some MATH
	
	--get distances to either side of the map on the X axis
	distL = mountainX
	distR = gridSize - mountainX
	
	--get distances on the Y axis
	distD = mountainY
	distU = gridSize - mountainY
	
	leftClose = false
	rightclose = false
	upClose = false
	downClose = false
	
	print("distance left: " .. distL)
	print("distance right: " .. distR)
	print("distance down: " .. distD)
	print("distance up: " .. distU)
	
	--set some bools to determine quadrant
	
	
	if(distL < distR) then
		leftClose = true
		rightClose = false
	else
		leftClose = false
		rightClose = true
	end
	
	if(distD < distU) then
		downClose = true
		upClsoe = false
	else
		downClose = false
		upClose = true
	end
	
	--let's get into the 4 quadrant cases
	
	--BOTTOM LEFT
	if(downClose == true and leftClose == true) then
		secondQuad = "bottomLeft"
	end
	
	--TOP LEFT
	if(upClose == true and leftClose == true) then
		secondQuad = "topLeft"
	end
	
	--TOP RIGHT
	if(upClose == true and rightClose == true) then
		secondQuad = "topRight"
	end
	
	--BOTTOM RIGHT
	if(downClose == true and rightClose == true) then
		secondQuad = "bottomRight"
	end
	
	while(firstQuad == secondQuad) do
		--choose one randomly
		chosenIndex = Round(worldGetRandom() * table.getn(mountainRing))
		chosenMountain = mountainRing[chosenIndex]
		mountainX, mountainY = chosenMountain[1], chosenMountain[2]
		table.remove(mountainRing, chosenIndex)
		
		
		print("Chosen mountain X: " .. mountainX)
		print("Chosen mountain Y: " .. mountainY)
		--choose spoke to create based on location of chosen mountain
		
		--let's do some MATH
		
		--get distances to either side of the map on the X axis
		distL = mountainX
		distR = gridSize - mountainX
		
		--get distances on the Y axis
		distD = mountainY
		distU = gridSize - mountainY
		
		leftClose = false
		rightclose = false
		upClose = false
		downClose = false
		
		print("distance left: " .. distL)
		print("distance right: " .. distR)
		print("distance down: " .. distD)
		print("distance up: " .. distU)
		
		--set some bools to determine quadrant
		
		
		if(distL < distR) then
			leftClose = true
			rightClose = false
		else
			leftClose = false
			rightClose = true
		end
		
		if(distD < distU) then
			downClose = true
			upClsoe = false
		else
			downClose = false
			upClose = true
		end
		
		--let's get into the 4 quadrant cases
		
		--BOTTOM LEFT
		if(downClose == true and leftClose == true) then
			secondQuad = "bottomLeft"
		end
		
		--TOP LEFT
		if(upClose == true and leftClose == true) then
			secondQuad = "topLeft"
		end
		
		--TOP RIGHT
		if(upClose == true and rightClose == true) then
			secondQuad = "topRight"
		end
		
		--BOTTOM RIGHT
		if(downClose == true and rightClose == true) then
			secondQuad = "bottomRight"
		end
	end
	
--should now have 2 different quadrants

--BOTTOM LEFT
	if(downClose == true and leftClose == true) then
		
		print("STARTING THE BOTTOM LEFT QUADRANT CALCULATIONS")
		--closer to the left than the bottom
		if(distL < distD) then
			triX = math.abs(mapHalfSize - distL)
			triY = math.abs(mapHalfSize - distD)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triY / triX))
			print("angle: " .. angle)
			
			endX = 1
			endY = Round((1 - (angle / 45)) * mapHalfSize)
			print("angle / 45: " .. angle/45)
			
		--closer to the bottom than the left
		else
			triX = math.abs(mapHalfSize - distL)
			triY = math.abs(mapHalfSize - distD)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triX / triY))
			print("angle: " .. angle)
			endX = Round((1 - (angle / 45)) * mapHalfSize)
			endY = 1
			print("angle / 45: " .. angle/45)
		end
	end
	
	--TOP LEFT
	if(upClose == true and leftClose == true) then
	
		print("STARTING THE TOP LEFT QUADRANT CALCULATIONS")
		--closer to the left than the top
		if(distL < distU) then
			triX = math.abs(mapHalfSize - distL)
			triY = math.abs(mapHalfSize - distU)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triY / triX))
			print("angle: " .. angle)
			endX = 1
			endY = Round((1 - (angle / 45)) * mapHalfSize) + mapHalfSize
			print("angle / 45: " .. angle/45)
		--closer to the top than the left
		else
			triX = math.abs(mapHalfSize - distL)
			triY = math.abs(mapHalfSize - distU)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triX / triY))
			
			endX = Round((1 - (angle / 45)) * mapHalfSize)
			endY = gridSize
			print("angle / 45: " .. angle/45)
		end
	end
	
	--TOP RIGHT
	if(upClose == true and rightClose == true) then
	
		print("STARTING THE TOP RIGHT QUADRANT CALCULATIONS")
		--closer to the right than the top
		if(distR < distU) then
			triX = math.abs(mapHalfSize - distR)
			triY = math.abs(mapHalfSize - distU)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triY / triX))
			print("angle: " .. angle)
			endX = gridSize
			endY = Round((1 - (angle / 45)) * mapHalfSize) + mapHalfSize
			print("angle / 45: " .. angle/45)
		--closer to the top than the right
		else
			triX = math.abs(mapHalfSize - distR)
			triY = math.abs(mapHalfSize - distU)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triX / triY))
			print("angle: " .. angle)
			endX = Round((1 - (angle / 45)) * mapHalfSize) + mapHalfSize
			endY = gridSize
			print("angle / 45: " .. angle/45)
		end
	end
	
	--BOTTOM RIGHT
	if(downClose == true and rightClose == true) then
	
		print("STARTING THE BOTTOM RIGHT QUADRANT CALCULATIONS")
		--closer to the right than the bottom
		if(distR < distD) then
			triX = math.abs(mapHalfSize - distR)
			triY = math.abs(mapHalfSize - distD)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triY / triX))
			print("angle: " .. angle)
			endX = gridSize
			endY = Round((1 - (angle / 45)) * mapHalfSize)
			print("angle / 45: " .. angle/45)
		--closer to the bottom than the right
		else
			triX = math.abs(mapHalfSize - distR)
			triY = math.abs(mapHalfSize - distD)
			print("triX: " .. triX .. "     triY: " .. triY)
			angle = math.deg(math.atan(triX / triY))
			print("angle: " .. angle)
			endX = Round((1 - (angle / 45)) * mapHalfSize) + mapHalfSize
			endY = 1
			print("angle / 45: " .. angle/45)
		end
	end
	
	print("End X value: " .. endX)
	print("End Y value: " .. endY)
	
	DrawLineOfTerrain(mountainY, mountainX, endY, endX, m, false, gridSize)
	
	mountain2X = mountainX
	mountain2Y = mountainY
	
	--draw a line of flat ground in between the 2 spoke starting mountains
	DrawLineOfTerrain(mountain2Y, mountain2X, mountain1Y, mountain1X, p, false, gridSize)
	
	terrainLayoutResult[mountain1Y][mountain1X] = p
	terrainLayoutResult[mountain1Y+1][mountain1X] = p
	terrainLayoutResult[mountain1Y][mountain1X+1] = p
	terrainLayoutResult[mountain1Y-1][mountain1X] = p
	terrainLayoutResult[mountain1Y][mountain1X-1] = p
	
	terrainLayoutResult[mountain2Y][mountain2X] = p
	terrainLayoutResult[mountain2Y+1][mountain2X] = p
	terrainLayoutResult[mountain2Y][mountain2X+1] = p
	terrainLayoutResult[mountain2Y-1][mountain2X] = p
	terrainLayoutResult[mountain2Y][mountain2X-1] = p



print(firstQuad .. " , " .. secondQuad)


--add stone bounty in middle of the map
terrainLayoutResult[mapHalfSize+1][mapHalfSize] = bg
terrainLayoutResult[mapHalfSize+1][mapHalfSize+1] = bg
terrainLayoutResult[mapHalfSize-1][mapHalfSize] = bg
terrainLayoutResult[mapHalfSize-1][mapHalfSize-1] = bg
terrainLayoutResult[mapHalfSize][mapHalfSize+1] = bg
terrainLayoutResult[mapHalfSize][mapHalfSize-1] = bg


-- iterate through to set features
for y = 1, gridSize do
	for x = 1, gridSize do

	--set plateaus to change into mountains or hills on a random distribution
	if(terrainLayoutResult[x][y] == pl) then
		if(worldGetRandom() < mountainChance) then
			terrainLayoutResult[x][y] = m
		else
			terrainLayoutResult[x][y] = b
		end
		end

	end
end
	


--set player start positions
roll = worldGetRandom()

if(roll >= 0.5) then

	playerStart1x = Round(worldGetRandom() * gridSize)
	playerStart1y = 3
	
else
	
	playerStart1x = 3
	playerStart1y = Round(worldGetRandom() * gridSize)


end


if(roll >= 0.5) then

	playerStart2x = gridSize - playerStart1x
	playerStart2y = gridSize - 2
else

	playerStart2x = gridSize - 2
	playerStart2y = gridSize - playerStart1y

end


--for games of 4 or more people
playerStart3x, playerStart3y = GetSquareInBox(mapHalfSize - mapEighthSize, mapHalfSize + mapEighthSize, mapHalfSize - mapEighthSize, mapHalfSize + mapEighthSize, gridSize)


playerStart4x = gridSize - playerStart3x
playerStart4y = gridSize - playerStart3y

--set player start locations on the map
startLocationPositions = {}
	
--2 players
if(playerStarts >= 2) then
-- set the starting areas to be elevated hills
	--player 1
	terrainLayoutResult[playerStart1x][playerStart1y] = s
	terrainLayoutResult[playerStart1x+1][playerStart1y] = b
	terrainLayoutResult[playerStart1x][playerStart1y+1] = b
	terrainLayoutResult[playerStart1x][playerStart1y-1] = b
	terrainLayoutResult[playerStart1x+1][playerStart1y+1] = m
	print("player 1 location placed")
	table.insert(startLocationPositions, {playerStart1x, playerStart1y})
	
	--player 2
	terrainLayoutResult[playerStart2x][playerStart2y] = s
	terrainLayoutResult[playerStart2x-1][playerStart2y] = b
	terrainLayoutResult[playerStart2x][playerStart2y+1] = b
	terrainLayoutResult[playerStart2x][playerStart2y-1] = b
	terrainLayoutResult[playerStart2x-1][playerStart2y-1] = m
	print("player 2 location placed")
	table.insert(startLocationPositions, {playerStart2x, playerStart2y})
	
end

--4 or more players
if(playerStarts >= 4) then
	--player 3
	terrainLayoutResult[playerStart3x][playerStart3y] = s
	terrainLayoutResult[playerStart3x-1][playerStart3y] = b
	terrainLayoutResult[playerStart3x][playerStart3y+1] = b
	terrainLayoutResult[playerStart3x][playerStart3y-1] = b
	terrainLayoutResult[playerStart3x-1][playerStart3y+1] = m
	print("player 3 location placed")
	table.insert(startLocationPositions, {playerStart3x, playerStart3y})
	
	--player 4
	terrainLayoutResult[playerStart4x][playerStart4y] = s
	terrainLayoutResult[playerStart4x-1][playerStart4y] = b
	terrainLayoutResult[playerStart4x][playerStart4y+1] = b
	terrainLayoutResult[playerStart4x][playerStart4y-1] = b
	terrainLayoutResult[playerStart4x+1][playerStart4y-1] = m
	print("player 4 location placed")
	table.insert(startLocationPositions, {playerStart4x, playerStart4y})

end




--Settlement placing
-- place settlements

settlementLocations = {}
minimumSettlementDistance = Round(2 / 11 * gridSize, 0)
--print("MinimumSettlement Distance = " ..minimumSettlementDistance)

-- find a place to put the settlement
--print("PLACING " ..numberOfSettlements .." SETTLEMENTS")

-- find all hte null squares remaining on the coarse grid for settlement placement
validSquareList = GetSquaresOfType(n, gridSize, terrainLayoutResult)

-- remove any null squares on the outside rows and columns of the coarse grid to keep settlements away from the edges
for index = table.getn(validSquareList), 1, -1 do	
	--print ("Row: " ..validSquareList[index][1] ..", Col: " ..validSquareList[index][2] .." Index: " ..index)
	
	if (validSquareList[index][1] == 1 or validSquareList[index][1] == gridSize) then
		--print("Removing because row")
		table.remove(validSquareList, index)
	elseif (validSquareList[index][2] == 1 or validSquareList[index][2] == gridSize) then
		--print("Removing because col")
		table.remove(validSquareList, index)
	end
	
end

-- cycle through each settlement and attempt to place one while making sure they are not too close to players and other settlements	
for index = 1, numberOfSettlements do
	settlementPlaced = false
	--print("FINDING LOCATION OF SETTLEMENT " ..index)

	while (settlementPlaced == false and table.getn(validSquareList) > 0) do
		squareChoice = {}
		squareIndex = (Round((worldGetRandom() - 1E-10) * (table.getn(validSquareList) - 1), 0)) + 1
		squareChoice = validSquareList[squareIndex]
		--print("Square at row "  ..squareChoice[1] ..", coloumn " ..squareChoice[2])
		
		x, y = squareChoice[1], squareChoice[2]
		farEnoughFromPlayers = false
		farEnoughFromSettlements = false
		--print("----- Squares remaining: " ..table.getn(validSquareList) .." -----------------")
		--print("CHECKING DISTANCE FROM PLAYER...")
		
		if (SquaresFarEnoughApart(x, y, minimumSettlementDistance, startLocationPositions, gridSize) == true) then
			--print("**********  FAR ENOUGH AWAY **********")
			--print("VALID PLAYER START DISTANCE")
			farEnoughFromPlayers = true
		else
			--print("**********  TOO CLOSE **********")
			--print("TOO CLOSE TO PLAYER START LOCATION ")
			farEnoughFromPlayers = false
			table.remove(validSquareList, squareIndex)
		end

		if (farEnoughFromPlayers == true) then
			
			if (table.getn(settlementLocations) > 0) then
				--print("CHECKING SETTLEMENT DISTANCE")	
				
				if (SquaresFarEnoughApart(x, y, (minimumSettlementDistance + 2), settlementLocations, gridSize) == true) then
					--print("**********  FAR ENOUGH AWAY **********")
					--print("VALID SETTLEMENT DISTANCE")
					farEnoughFromSettlements = true
				else
					--print("**********  TOO CLOSE **********")
					--print("TOO CLOSE TO SETTLEMENT LOCATION")
					farEnoughFromSettlements = false
					table.remove(validSquareList, squareIndex)
				end
				
			else
				--print("FIRST SETTLEMENT. SETTLEMENT DISTANCE CHECK NOT REQUIRED.")
				farEnoughFromSettlements = true
			end
			
		end
		
		if (farEnoughFromPlayers == true and farEnoughFromSettlements == true) then
			table.insert(settlementLocations,{x, y})
			table.remove(validSquareList, squareIndex)
			--print("SETTLEMENT " ..table.getn(settlementLocations) .." PLACED AT: " ..x ..", " ..y)
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