

mapScope = 24


mapName = "Sacred Crest"
print("Start of Script - " .. mapName .. ".")

-- Defining terrains for the map.
originTerrain = tt_sacred_crest_player_start
baseTerrain = tt_plains
oceanDeep = tt_ocean_deep

spawnTerrain = tt_plains
middleTerrain = tt_stealth_natural_plateau_tiny
middleSlope = tt_sacred_crest_middle_slope
centreTerrain = tt_plateau_med
middleElevationOne = tt_hills_med_rolling
middleElevationTwo = tt_hills_high_rolling
middleElevationThree = tt_plateau_med

slopeFlat = tt_plains
slopeRolling = tt_hills_gentle_rolling

middleGold = tt_migration_middle_gold
middleStone = tt_migration_middle_stone

divineTerrain = tt_waterholes_holy_site
tradeTerrain = tt_waterholes_settlement

-- Setting up preliminary map preferences.
enableDebugging = true
IncludeScaling()

baseMapScope = 24
minimumMapScope = 6
maximumMapScope = 100
PreliminarySetup()

terrainType = tt_elevation_level_16
originRow = 1
originColumn = 1
tileAmount = 0
tileRatio = true
baseRadius = 6
baseRatio = false
avoidanceDistance = 1
edgeAvoidance = 0
CreateOriginLand(terrainType, originRow, originColumn, tileAmount, tileRatio, baseRadius, baseRatio, avoidanceDistance, edgeAvoidance)

terrainGrid[7][1] = tt_elevation_level_16
terrainGrid[8][1] = tt_elevation_level_15
terrainGrid[9][1] = tt_elevation_level_14
terrainGrid[10][1] = tt_elevation_level_13

terrainGrid[11][1] = tt_elevation_level_12
terrainGrid[12][1] = tt_elevation_level_11
terrainGrid[13][1] = tt_elevation_level_10
terrainGrid[14][1] = tt_elevation_level_9

terrainGrid[15][1] = tt_elevation_level_8
terrainGrid[16][1] = tt_elevation_level_7
terrainGrid[17][1] = tt_elevation_level_6
terrainGrid[18][1] = tt_elevation_level_5

terrainGrid[19][1] = tt_elevation_level_4
terrainGrid[20][1] = tt_elevation_level_3
terrainGrid[21][1] = tt_elevation_level_2
terrainGrid[22][1] = tt_elevation_level_1


terrainGrid[7][2] = tt_elevation_level_16
terrainGrid[8][2] = tt_elevation_level_15
terrainGrid[9][2] = tt_elevation_level_14
terrainGrid[10][2] = tt_elevation_level_13

terrainGrid[11][2] = tt_elevation_level_12
terrainGrid[12][2] = tt_elevation_level_11
terrainGrid[13][2] = tt_elevation_level_10
terrainGrid[14][2] = tt_elevation_level_9

terrainGrid[15][2] = tt_elevation_level_8
terrainGrid[16][2] = tt_elevation_level_7
terrainGrid[17][2] = tt_elevation_level_6
terrainGrid[18][2] = tt_elevation_level_5

terrainGrid[19][2] = tt_elevation_level_4
terrainGrid[20][2] = tt_elevation_level_3
terrainGrid[21][2] = tt_elevation_level_2
terrainGrid[22][2] = tt_elevation_level_1


terrainGrid[7][3] = tt_elevation_level_16
terrainGrid[8][3] = tt_elevation_level_15
terrainGrid[9][3] = tt_elevation_level_14
terrainGrid[10][3] = tt_elevation_level_13

terrainGrid[11][3] = tt_elevation_level_12
terrainGrid[12][3] = tt_elevation_level_11
terrainGrid[13][3] = tt_elevation_level_10
terrainGrid[14][3] = tt_elevation_level_9

terrainGrid[15][3] = tt_elevation_level_8
terrainGrid[16][3] = tt_elevation_level_7
terrainGrid[17][3] = tt_elevation_level_6
terrainGrid[18][3] = tt_elevation_level_5

terrainGrid[19][3] = tt_elevation_level_4
terrainGrid[20][3] = tt_elevation_level_3
terrainGrid[21][3] = tt_elevation_level_2
terrainGrid[22][3] = tt_elevation_level_1

--[[

terrainGrid[mapFifth][mapFifth] = tt_elevation_level_1
terrainGrid[mapFifth][mapFifth + mapFifth] = tt_elevation_level_2
terrainGrid[mapFifth][mapFifth + mapFifth + mapFifth] = tt_elevation_level_3
terrainGrid[mapFifth][mapFifth + mapFifth + mapFifth + mapFifth] = tt_elevation_level_4

terrainGrid[mapFifth + mapFifth][mapFifth] = tt_elevation_level_5
terrainGrid[mapFifth + mapFifth][mapFifth + mapFifth] = tt_elevation_level_6
terrainGrid[mapFifth + mapFifth][mapFifth + mapFifth + mapFifth] = tt_elevation_level_7
terrainGrid[mapFifth + mapFifth][mapFifth + mapFifth + mapFifth + mapFifth] = tt_elevation_level_8

terrainGrid[mapFifth + mapFifth + mapFifth][mapFifth] = tt_elevation_level_9
terrainGrid[mapFifth + mapFifth + mapFifth][mapFifth + mapFifth] = tt_elevation_level_10
terrainGrid[mapFifth + mapFifth + mapFifth][mapFifth + mapFifth + mapFifth] = tt_elevation_level_11
terrainGrid[mapFifth + mapFifth + mapFifth][mapFifth + mapFifth + mapFifth + mapFifth] = tt_elevation_level_12

terrainGrid[mapFifth + mapFifth + mapFifth + mapFifth][mapFifth] = tt_elevation_level_13
terrainGrid[mapFifth + mapFifth + mapFifth + mapFifth][mapFifth + mapFifth] = tt_elevation_level_14
terrainGrid[mapFifth + mapFifth + mapFifth + mapFifth][mapFifth + mapFifth + mapFifth] = tt_elevation_level_15
terrainGrid[mapFifth + mapFifth + mapFifth + mapFifth][mapFifth + mapFifth + mapFifth + mapFifth] = tt_elevation_level_16

--]]

--[[

terrainGrid[mapFifth][mapFifth] = tt_elevation_level_1
terrainGrid[mapFifth][mapFifth + mapFifth] = tt_elevation_level_2
terrainGrid[mapFifth][mapFifth + mapFifth + mapFifth] = tt_elevation_level_3
terrainGrid[mapFifth][mapFifth + mapFifth + mapFifth + mapFifth] = tt_elevation_level_4

terrainGrid[mapFifth + mapFifth][mapFifth] = tt_elevation_level_5
terrainGrid[mapFifth + mapFifth][mapFifth + mapFifth] = tt_elevation_level_6
terrainGrid[mapFifth + mapFifth][mapFifth + mapFifth + mapFifth] = tt_elevation_level_7
terrainGrid[mapFifth + mapFifth][mapFifth + mapFifth + mapFifth + mapFifth] = tt_elevation_level_8

terrainGrid[mapFifth + mapFifth + mapFifth][mapFifth] = tt_elevation_level_9
terrainGrid[mapFifth + mapFifth + mapFifth][mapFifth + mapFifth] = tt_elevation_level_10
terrainGrid[mapFifth + mapFifth + mapFifth][mapFifth + mapFifth + mapFifth] = tt_elevation_level_11
terrainGrid[mapFifth + mapFifth + mapFifth][mapFifth + mapFifth + mapFifth + mapFifth] = tt_elevation_level_12

terrainGrid[mapFifth + mapFifth + mapFifth + mapFifth][mapFifth] = tt_elevation_level_13
terrainGrid[mapFifth + mapFifth + mapFifth + mapFifth][mapFifth + mapFifth] = tt_elevation_level_14
terrainGrid[mapFifth + mapFifth + mapFifth + mapFifth][mapFifth + mapFifth + mapFifth] = tt_elevation_level_15
terrainGrid[mapFifth + mapFifth + mapFifth + mapFifth][mapFifth + mapFifth + mapFifth + mapFifth] = tt_elevation_level_16


terrainGrid[1][5] = tt_elevation_level_1
terrainGrid[2][5] = tt_elevation_level_2
terrainGrid[3][5] = tt_elevation_level_3
terrainGrid[4][5] = tt_elevation_level_4

terrainGrid[5][5] = tt_elevation_level_5
terrainGrid[6][5] = tt_elevation_level_6
terrainGrid[7][5] = tt_elevation_level_7
terrainGrid[8][5] = tt_elevation_level_8

terrainGrid[9][5] = tt_elevation_level_9
terrainGrid[10][5] = tt_elevation_level_10
terrainGrid[11][5] = tt_elevation_level_11
terrainGrid[12][5] = tt_elevation_level_12

terrainGrid[13][5] = tt_elevation_level_13
terrainGrid[14][5] = tt_elevation_level_14
terrainGrid[15][5] = tt_elevation_level_15
terrainGrid[16][5] = tt_elevation_level_16


terrainGrid[1][4] = tt_elevation_level_1
terrainGrid[2][4] = tt_elevation_level_2
terrainGrid[3][4] = tt_elevation_level_3
terrainGrid[4][4] = tt_elevation_level_4

terrainGrid[5][4] = tt_elevation_level_5
terrainGrid[6][4] = tt_elevation_level_6
terrainGrid[7][4] = tt_elevation_level_7
terrainGrid[8][4] = tt_elevation_level_8

terrainGrid[9][4] = tt_elevation_level_9
terrainGrid[10][4] = tt_elevation_level_10
terrainGrid[11][4] = tt_elevation_level_11
terrainGrid[12][4] = tt_elevation_level_12

terrainGrid[13][4] = tt_elevation_level_13
terrainGrid[14][4] = tt_elevation_level_14
terrainGrid[15][4] = tt_elevation_level_15
terrainGrid[16][4] = tt_elevation_level_16






terrainGrid[16][6] = tt_elevation_level_1
terrainGrid[15][6] = tt_elevation_level_2
terrainGrid[14][6] = tt_elevation_level_3
terrainGrid[13][6] = tt_elevation_level_4

terrainGrid[12][6] = tt_elevation_level_5
terrainGrid[11][6] = tt_elevation_level_6
terrainGrid[10][6] = tt_elevation_level_7
terrainGrid[9][6] = tt_elevation_level_8

terrainGrid[8][6] = tt_elevation_level_9
terrainGrid[7][6] = tt_elevation_level_10
terrainGrid[6][6] = tt_elevation_level_11
terrainGrid[5][6] = tt_elevation_level_12

terrainGrid[4][6] = tt_elevation_level_13
terrainGrid[3][6] = tt_elevation_level_14
terrainGrid[2][6] = tt_elevation_level_15
terrainGrid[1][6] = tt_elevation_level_16


terrainGrid[16][7] = tt_elevation_level_1
terrainGrid[15][7] = tt_elevation_level_2
terrainGrid[14][7] = tt_elevation_level_3
terrainGrid[13][7] = tt_elevation_level_4

terrainGrid[12][7] = tt_elevation_level_5
terrainGrid[11][7] = tt_elevation_level_6
terrainGrid[10][7] = tt_elevation_level_7
terrainGrid[9][7] = tt_elevation_level_8

terrainGrid[8][7] = tt_elevation_level_9
terrainGrid[7][7] = tt_elevation_level_10
terrainGrid[6][7] = tt_elevation_level_11
terrainGrid[5][7] = tt_elevation_level_12

terrainGrid[4][7] = tt_elevation_level_13
terrainGrid[3][7] = tt_elevation_level_14
terrainGrid[2][7] = tt_elevation_level_15
terrainGrid[1][7] = tt_elevation_level_16
--]]