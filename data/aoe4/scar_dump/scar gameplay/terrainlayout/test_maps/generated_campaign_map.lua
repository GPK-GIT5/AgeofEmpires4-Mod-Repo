--load the specific lua file path

--load in terrain types to match data output from coarse map analysis script


--[[
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end



local filePath = "MetaMap/MetaMap_RTSMapGen.scar"

--local fileExists = file_exists(filePath)

--print("does the file exist? " .. fileExists)

loadedData = io.open("MetaMap/MetaMap_RTSMapGen.scar", "r")

--]]

--parse the loaded data and put it into a terrain layout result format
dofile("C:/Users/TaylorN/Documents/My Games/Cardinal/MetaMap/MetaMap_RTSMapGen.scar")
--dofile("MetaMap/MetaMap_RTSMapGen.scar")
--loadedData = {}

loadedData = MapGenData.coarseMap

biome = ""
biome = biome .. MapGenData.biome

hasCity = false
hasCity = MapGenData.mapHasCity

print("the biome is: " .. biome)

if(loadedData[1][1] == "test") then
	print("TEST IS THE TEST! I'M LOADING TEST!!")
end



----------------------------------------------------
--list of terrain types

n = tt_none

h = tt_hills
m = tt_mountains
i = tt_impasse_mountains
k = tt_mountains_small
b = tt_hills_high_rolling
o = tt_ocean
u = tt_plains
f = tt_flatland
s = tt_campaign_starting_pos
bb = tt_bounty_berries_flatland
p = tt_hills_plateau
pt = tt_hills_plateau_test
v = tt_valley
vs = tt_valley_shallow
bg = tt_bounty_gold_plains
c = tt_plains_clearing

f1 = tt_impasse_trees_plains
f2 = tt_impasse_trees_hills_low_rolling
f3 = tt_impasse_trees_hills_high_rolling

cc = tt_city_centre
cf = tt_city_farming
cm = tt_city_military
cl = tt_city_lumbercamp
cs = tt_city_stonecamp
cg = tt_city_goldcamp

---------------------------------------------------


gridSize = (#loadedData)

print("grid size: " .. gridSize)

--set up coarse map grid
terrainLayoutResult = {}

-- initialize the map grid
terrainLayoutResult = SetUpGrid(gridSize, n, terrainLayoutResult)


--important data to give the map generation system:
--[[

distributions
terrain undulations
weighted terrain types

map size

biome



]]--

cityLocationX = 0
cityLocationY = 0

for i = 1, (#loadedData) do
	for j = 1, (#loadedData) do
	
		--iterate through loaded data and convert to terrain types
		
		--a bunch of if statements, one for each terrain type
		if(loadedData[i][j] == "~") then
			terrainLayoutResult[i][j] = o
		end
		
		if(loadedData[i][j] == "h") then
			terrainLayoutResult[i][j] = b
		end
		
		if(loadedData[i][j] == "^") then
			terrainLayoutResult[i][j] = k
		end
		
		if(loadedData[i][j] == "s") then
			terrainLayoutResult[i][j] = s
		end
		
		if(loadedData[i][j] == "n") then
			terrainLayoutResult[i][j] = h
		end
		
		if(loadedData[i][j] == "/") then
			terrainLayoutResult[i][j] = i
		end
		
		if(loadedData[i][j] == "A") then
			terrainLayoutResult[i][j] = m
		end
		
		if(loadedData[i][j] == "-") then
			terrainLayoutResult[i][j] = u
		end
		
		if(loadedData[i][j] == "_") then
			terrainLayoutResult[i][j] = v
		end
		
		if(loadedData[i][j] == "c") then
		
			cityLocationX = i
			cityLocationY = j
		
		end
		
		--etc etc
	
	end
end

if(hasCity == true) then
	print("placing city!")
	terrainLayoutResult[cityLocationX][cityLocationY] = cc
	terrainLayoutResult[cityLocationX][cityLocationY+1] = cm
	terrainLayoutResult[cityLocationX+1][cityLocationY] = cf
	
end


print("AT THE END OF GENERATED CAMPAIGN MAP SCRIPT")