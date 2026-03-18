# AoE4 SCAR Function Index

Auto-generated on 2026-02-23 19:36. Total functions: **8989**

- **campaign**: 6668 functions across 389 files
- **gameplay**: 2321 functions across 130 files

## campaign

### scenarios\campaign\abbasid\abb_bonus\abb_bonus_attack.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `AbbBonus_SetupAttackersData` | — | public |
| 18 | `AbbBonus_StartAttackersP2` | — | public |
| 27 | `AbbBonus_StopAttackersP2` | — | public |
| 35 | `AbbBonus_InitVillagerCountP2` | — | public |
| 44 | `AbbBonus_UpdateEcon` | `context, data` | public |
| 72 | `AbbBonus_UpdateConstraints` | `context, data` | public |
| 140 | `AbbBonus_MonitorAttackers` | `context, data` | public |
| 225 | `AbbBonus_GetUnitDataByName` | `name, unitTable` | public |
| 234 | `AbbBonus_OnAttackSgroupRemoved` | `context, data` | public |

### scenarios\campaign\abbasid\abb_bonus\abb_bonus_capture.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `AbbBonus_Capture_Init` | — | public |
| 27 | `AbbBonus_Capture_InitTemplars` | — | public |
| 82 | `AbbBonus_Capture_InitTeutons` | — | public |
| 138 | `AbbBonus_Capture_InitHospitallers` | — | public |
| 193 | `AbbBonus_Capture_MergeTemplars` | — | public |
| 198 | `AbbBonus_Capture_MergeTeutons` | — | public |
| 203 | `AbbBonus_Capture_MergeHospitallers` | — | public |

### scenarios\campaign\abbasid\abb_bonus\abb_bonus_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `AbbBonus_InitData` | — | public |
| 29 | `GetRecipe` | — | public |
| 224 | `AbbBonus_SetupPatrols` | — | public |
| 251 | `AbbBonus_SetupRaiders` | — | public |
| 371 | `AbbBonus_SetupUnitTables` | — | public |
| 529 | `AbbBonus_SetupTechData` | — | public |
| 563 | `AbbBonus_SetupAttackersP2` | — | public |

### scenarios\campaign\abbasid\abb_bonus\abb_bonus_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `AbbBonus_SetObjectiveConstants` | — | public |
| 8 | `AbbBonus_RegisterObjectives` | — | public |
| 106 | `AbbBonus_StartDocksObjective` | — | public |
| 111 | `AbbBonus_CheckDocks` | — | public |

### scenarios\campaign\abbasid\abb_bonus\abb_bonus_patrol.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `AbbBonus_CreatePatrol` | `player, unitTable, sgroupName, markerStem, numMarkers` | public |
| 27 | `AbbBonus_MonitorPatrol` | `context, data` | public |

### scenarios\campaign\abbasid\abb_bonus\abb_bonus_raid.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `AbbBonus_StartRaidersP2` | — | public |
| 11 | `AbbBonus_StartNavalRaiders` | — | public |
| 17 | `AbbBonus_StopRaidersP2` | — | public |
| 21 | `AbbBonus_StopRaidersP5` | — | public |
| 27 | `AbbBonus_MonitorRaiders` | `context, data` | public |
| 136 | `AbbBonus_OnRaidSgroupRemoved` | `context, data` | public |

### scenarios\campaign\abbasid\abb_bonus\abb_bonus_reinforce.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `AbbBonus_Reinforce_Init` | — | public |
| 60 | `AbbBonus_Reinforce_Callback` | `player, id` | public |
| 84 | `AbbBonus_ShowEventCue` | `message` | public |

### scenarios\campaign\abbasid\abb_bonus\abb_bonus_units.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `AbbBonus_SetUnitTables` | — | public |
| 24 | `AbbBonus_SpawnInitUnits` | — | public |
| 69 | `AbbBonus_SetupHolyOrders` | — | public |
| 86 | `AbbBonus_StartSubdueHolyOrders` | — | public |
| 91 | `AbbBonus_SpawnUnitSequence` | `player, unitType, sbpType, markerStem, numMarkers, sgroup` | public |
| 115 | `AbbBonus_SpawnWallDefenders` | `player, spawnMarker, unitType, markerStem, numMarkers, unitsPerMarker` | public |
| 128 | `AbbBonus_SpawnBastionDefendersP2` | — | public |
| 149 | `AbbBonus_GarrisonOutposts` | `player, egroup, unitType, unitNum` | public |

### scenarios\campaign\abbasid\abb_bonus\abb_bonus_util.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `AbbBonus_GetMarkers` | `markerStem, numMarkers` | public |
| 16 | `AbbBonus_GetSiegeCount` | `sgroup` | public |

### scenarios\campaign\abbasid\abb_bonus\abb_bonus.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 16 | `Mission_SetupPlayers` | — | public |
| 126 | `Mission_SetupVariables` | — | public |
| 144 | `Mission_Preset` | — | public |
| 207 | `AbbBonus_OnConstructionComplete` | `context` | public |
| 223 | `Mission_PreStart` | — | public |
| 229 | `Mission_Start` | — | public |
| 266 | `MonitorLandmarks` | `context, data` | public |
| 285 | `UpdateTech` | `context, data` | public |

### scenarios\campaign\abbasid\abb_m1_tyre\abb_m1_tyre_ambush.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Ambushes_SpawnAlliedMonks` | — | public |
| 14 | `Ambushes_Init` | — | public |
| 55 | `Ambush_DestinationIsTriggered` | `ambush` | public |
| 65 | `Ambushes_Monitor` | — | public |

### scenarios\campaign\abbasid\abb_m1_tyre\abb_m1_tyre_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `AutoTest_OnInit` | — | public |
| 36 | `AutomatedTyre_RegisterCheckpoints` | — | public |
| 52 | `AutoTest_SkipAndStart` | — | public |
| 61 | `AutoTest_PlayIntro` | — | public |
| 75 | `AutomatedMission_Start` | — | public |
| 100 | `AutomatedTyre_MonitorRaiders` | — | public |
| 140 | `AutomatedTyre_InitBuildUp` | — | public |
| 171 | `AutomatedTyre_BuildHouseOfWisdom` | — | public |
| 183 | `AutomatedTyre_OnConstructionComplete` | `context` | public |
| 190 | `AutomatedTyre_BuildWingDelayed` | — | public |
| 196 | `AutomatedTyre_MonitorBuildUp` | — | public |
| 230 | `AutomatedTyre_InitDestroyRam` | — | public |
| 263 | `AutomatedTyre_RedirectBaseDefenders` | — | public |
| 272 | `AutomatedTyre_MonitorDestroyRam` | — | public |
| 288 | `AutomatedTyre_SpawnAttackers` | `numSpear, numArcher, numHorse` | public |
| 307 | `AutomatedTyre_Phase0_CheckPlayStart` | — | public |
| 316 | `AutomatedTyre_Phase1_Setup` | — | public |
| 321 | `AutomatedTyre_Phase1_Monitor` | — | public |
| 333 | `AutomatedTyre_Phase2_Monitor` | — | public |
| 344 | `AutomatedTyre_Phase3_Monitor` | — | public |

### scenarios\campaign\abbasid\abb_m1_tyre\abb_m1_tyre_camps.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Camps_Init` | — | public |
| 199 | `Camps_AddUI` | — | public |
| 206 | `Camps_UpdateUI` | — | public |
| 262 | `Camp_ShowClearEvent` | — | public |
| 270 | `Camp_CreateVillagers` | `group` | public |
| 282 | `Camp_AssignWork` | `group` | public |
| 305 | `Camps_MonitorEntry` | `context, data` | public |
| 321 | `Camps_DoRandomMoves` | `_group` | public |
| 334 | `Camps_CheckAttackConditions` | `sgroup, target` | public |
| 352 | `Camps_MoveVillager` | `context, data` | public |
| 380 | `Camps_GatherResources` | — | public |
| 396 | `Camps_RetreatAll` | — | public |
| 417 | `Camps_MonitorVillagers` | `context, data` | public |
| 489 | `Camp_Init` | `camp` | public |

### scenarios\campaign\abbasid\abb_m1_tyre\abb_m1_tyre_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Tyre_InitData1` | — | public |
| 125 | `GetRecipe` | — | public |
| 429 | `Tyre_InitData2` | — | public |
| 441 | `Tyre_GetMarkers` | `markerStem, numMarkers` | public |

### scenarios\campaign\abbasid\abb_m1_tyre\abb_m1_tyre_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Tyre_RegisterObjectives` | — | public |
| 398 | `Tyre_MonitorResources` | — | public |
| 415 | `Tyre_CheckDestroyRamStart` | — | public |
| 422 | `Tyre_StartDefendMole` | — | public |
| 428 | `Tyre_StartAgeUpObjective` | `context, data` | public |
| 433 | `Tyre_HouseOfWisdomComplete` | `context, data` | public |
| 453 | `Tyre_WingStarted` | `context, data` | public |
| 466 | `Tyre_WingComplete` | `context, data` | public |

### scenarios\campaign\abbasid\abb_m1_tyre\abb_m1_tyre_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 10 | `Training_Tyre_GeneralAura` | — | public |
| 51 | `Predicate_UserHasSelectedTughtekin` | `goal` | public |
| 57 | `Predicate_UserHasLookedAtTughtekinAbility` | `goal` | public |
| 63 | `Predicate_TughtekinExists` | `goalSequence` | public |
| 71 | `Training_Tyre_LeaderTent` | — | public |
| 103 | `Predicate_UserHasSelectedLeaderTent` | `goal` | public |
| 109 | `Predicate_TughtekinHasDied` | `goalSequence` | public |
| 118 | `Training_Tyre_BuildFishingBoat` | — | public |
| 140 | `UserHasDockSelected` | `goal` | public |
| 144 | `UserHasDockOnScreen` | `goalSequence` | public |
| 158 | `Training_Tyre_ProduceVillagers` | — | public |
| 184 | `UserHasTCSelected` | `goal` | public |
| 188 | `Tyre_MonitorVillagerProduction` | — | public |
| 197 | `UserShouldProduceVillagers` | `goalSequence` | public |
| 226 | `Training_Tyre_BuildWing` | — | public |
| 253 | `UserHasHoWSelected` | `goal` | public |
| 260 | `UserHasStartedWing` | `goal` | public |
| 264 | `UserCanBuildWing` | `goalSequence` | public |

### scenarios\campaign\abbasid\abb_m1_tyre\abb_m1_tyre.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupPlayers` | — | public |
| 74 | `Mission_SetupVariables` | — | public |
| 80 | `Mission_Preset` | — | public |
| 172 | `Mission_PreStart` | — | public |
| 178 | `Mission_Start` | — | public |
| 196 | `Tyre_CheckOutpostHint1` | — | public |
| 214 | `Tyre_CheckOutpostHint2` | — | public |
| 231 | `Tyre_RemoveOutpostHint1` | — | public |
| 238 | `Tyre_RemoveOutpostHint2` | — | public |
| 244 | `Tyre_MonitorHorseArcherCount` | — | public |
| 259 | `Tyre_MonitorTughtekin` | — | public |
| 280 | `Tyre_StartBasePhase` | — | public |
| 316 | `Tyre_SpawnTransport` | — | public |
| 325 | `Tyre_MoveTransportToDest` | — | public |
| 331 | `Tyre_CheckTransportArrival` | — | public |
| 347 | `Tyre_MoveP1InitArmy` | — | public |
| 352 | `Tyre_MoveTransportFinal` | — | public |
| 357 | `Tyre_SpawnScatteredUnits` | `player, markerName, unitTable` | public |
| 369 | `Tyre_SpawnAllyDefenders` | — | public |
| 375 | `Tyre_CheckStartPreparing` | — | public |
| 384 | `Tyre_StartPreparing` | — | public |
| 395 | `Tyre_SpawnWallArchers` | `markerStem, numMarkers` | public |
| 408 | `Tyre_MoveWallArchersLoop` | — | public |
| 434 | `Tyre_InitAllySkirmishArmy` | — | public |
| 460 | `Tyre_MonitorAllySkirmishing` | `context, data` | public |
| 522 | `Tyre_InitSkirmishArmy` | — | public |
| 592 | `Tyre_MonitorSkirmishing` | `context, data` | public |
| 664 | `Tyre_StartFinalRetreat` | — | public |
| 682 | `Tyre_CompleteFinalRetreat` | — | public |
| 690 | `Tyre_InitRamArmy` | — | public |
| 730 | `Tyre_SpawnEscorts` | — | public |
| 756 | `Tyre_ReinforceEscorts` | — | public |
| 787 | `Tyre_SpawnRamBuilders` | — | public |
| 813 | `Tyre_ConstructRamTower` | — | public |
| 828 | `Tyre_FindSiegeTower` | — | public |
| 848 | `Tyre_RamTowerComplete` | `context, data` | public |
| 865 | `Tyre_SpawnRam` | — | public |
| 893 | `Tyre_SpawnRamGarrison` | — | public |
| 916 | `Tyre_ModifyRamHealth` | — | public |
| 927 | `Tyre_LaunchRam` | — | public |
| 952 | `Tyre_CheckMoleTrigger1` | — | public |
| 967 | `Tyre_CheckMoleTrigger2` | — | public |
| 982 | `Tyre_CheckRamTrigger` | — | public |
| 996 | `Tyre_MonitorRam` | `context, data` | public |
| 1091 | `Tyre_MergeRamUnits` | `context, data` | public |
| 1102 | `TyreDebug_SkipFranksGathering` | — | public |
| 1120 | `TyreDebug_SkipEconPhase` | — | public |
| 1124 | `TyreDebug_SkipArmyCountdown` | — | public |
| 1137 | `OnUpgradeStart` | `context, data` | public |
| 1151 | `OnUpgradeCancelled` | `context, data` | public |
| 1165 | `RemoveFeudalWings` | — | public |

### scenarios\campaign\abbasid\abb_m2_egypt\abb_m2_egypt_armycontrol.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Distribute_Enemy_Army` | `sgroup` | public |
| 40 | `onQuestComplete` | `army` | public |
| 44 | `SpawnTypedEnemySquads` | — | public |
| 78 | `Egypt_CleanArmyTable` | — | public |
| 86 | `Egypt_GetOldestWaitingArmy` | — | public |
| 102 | `AssignOldestWaitingArmyToBestTarget` | — | public |
| 154 | `Egypt_ReinforcementWave` | `player` | public |
| 210 | `Egypt_GetReinforcementWaveSize` | `player` | public |
| 230 | `Egypt_GetHeldPoints` | `player` | public |
| 245 | `ApplyCaptureModifier` | `sgroup` | public |

### scenarios\campaign\abbasid\abb_m2_egypt\abb_m2_egypt_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 41 | `AutoTest_OnInit` | — | public |
| 74 | `AutomatedEgypt_RegisterCheckpoints` | — | public |
| 96 | `AutoTest_SkipAndStart` | — | public |
| 105 | `AutoTest_PlayIntro` | — | public |
| 120 | `AutomatedMission_Start` | — | public |
| 125 | `AutomatedEgypt_Phase0_CheckPlayStart` | — | public |
| 138 | `AutomatedEgypt_Phase1_SetUpPhase1` | — | public |
| 171 | `AutomatedEgypt_Phase1_QueryControlPoints` | — | public |
| 180 | `AutomatedEgypt_Phase1_PlayerAttacks` | — | public |
| 216 | `_GetEnemyControlPoints` | `gid, index, eid` | private |
| 224 | `AutomatedEgypt_ProtectHome` | — | public |
| 236 | `AutomatedEgypt_UseAbilities` | — | public |
| 252 | `AutomatedEgypt_Phase2_QueryCrusaderDefeat` | — | public |
| 262 | `AutomatedEgypt_Phase3_QueryMissionComplete` | — | public |

### scenarios\campaign\abbasid\abb_m2_egypt\abb_m2_egypt_controlpoints.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `Egypt_InitControlPointSystem` | — | public |
| 21 | `ControlPoint_GetID` | — | public |
| 27 | `ControlPoint_Init` | `eid` | public |
| 86 | `_Egypt_ControlPoint_Monitor` | — | private |
| 112 | `Egypt_ControlPoint_MissionStart` | — | public |
| 164 | `Kill_VillLife` | `name` | public |
| 181 | `SaveVillageLayout` | `controlPoint, defered_owner` | public |
| 232 | `Rebuild_Location` | `controlPoint` | public |
| 265 | `_Update_LocationData` | `context, data` | private |
| 274 | `_DelayedRebuild` | `context, data` | private |
| 285 | `Query_NeedsRebuilding` | `entityID` | public |
| 297 | `SpawnNewGarrison` | `controlPoint, defered_owner` | public |
| 335 | `_SpawnGarrisonOverTime` | `context, data` | private |
| 349 | `SpawnGarrisonMember` | `controlPointEntity, unitType, defered_owner, army, spawnLocation, moveLocation` | public |
| 367 | `Init_Garrison` | `controlPoint, defered_owner` | public |
| 393 | `Convert_Location_VillLife` | `controlPoint` | public |
| 425 | `Get_DeferedOwner` | `player` | public |

### scenarios\campaign\abbasid\abb_m2_egypt\abb_m2_egypt_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Init_Egypt_Difficulty` | — | public |
| 58 | `Init_Egypt_Data` | — | public |
| 95 | `SGroup_MakeOrClear` | `name` | public |

### scenarios\campaign\abbasid\abb_m2_egypt\abb_m2_egypt_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Egypt_InitObjectives` | — | public |
| 151 | `Egypt_GetControlBalance` | — | public |
| 171 | `Egypt_GetControlTrend` | — | public |
| 184 | `Egypt_RaiseStakesSlow` | — | public |
| 190 | `Egypt_RaiseStakesFast` | — | public |
| 209 | `Egypt_AddTemplars` | — | public |
| 224 | `_Egypt_ReinforcementWaves` | — | private |

### scenarios\campaign\abbasid\abb_m2_egypt\abb_m2_egypt_quadrants.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Quadrant_GetNewID` | — | public |
| 10 | `Quadrant_Init` | `controlPoint` | public |
| 41 | `_Monitor_ControlPointAttackValues` | `context, data` | private |
| 152 | `Get_BestControlPointTarget_ForArmy` | `army` | public |
| 203 | `Quadrant_GetSlot` | `quadrant` | public |
| 214 | `Quadrant_ReleaseSlot` | `quadrant, layer, offset` | public |
| 218 | `Quadrant_GetPositionFromLayerAndSlot` | `quadrant, layer, offset` | public |
| 228 | `Quadrants_Init` | — | public |

### scenarios\campaign\abbasid\abb_m2_egypt\abb_m2_egypt.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupPlayers` | — | public |
| 108 | `Mission_SetupVariables` | — | public |
| 123 | `Mission_SetDifficulty` | — | public |
| 129 | `Mission_SetRestrictions` | — | public |
| 146 | `Mission_Preset` | — | public |
| 216 | `Mission_PreStart` | — | public |
| 228 | `Mission_Start` | — | public |
| 261 | `WallKill` | — | public |
| 279 | `Egypt_AutoSaveInterval` | — | public |
| 283 | `Delete_Phys` | — | public |
| 287 | `GetRecipe` | — | public |
| 311 | `Debug_SkipMissionComplete` | — | public |

### scenarios\campaign\abbasid\abb_m3_redsea\abb_m3_redsea_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 38 | `AutoTest_OnInit` | — | public |
| 67 | `AutoTest_SkipAndStart` | — | public |
| 76 | `AutoTest_PlayIntro` | — | public |
| 91 | `AutomatedMission_Start` | — | public |
| 100 | `Automated_RegisterCheckpoints` | — | public |
| 126 | `AutomatedRedSea_CheckTutorialStart` | `context, data` | public |
| 143 | `AutomatedRedSea_QueueStartingShips` | `context, data` | public |
| 164 | `AutomatedRedSea_ManageTutorialShips` | `context, data` | public |
| 197 | `AutomatedRedSea_CheckPlayStart` | `context, data` | public |
| 213 | `AutomatedRedSea_StartPirateHunt` | `context, data` | public |
| 231 | `AutomatedRedSea_PlayerHuntFranks` | `context, data` | public |
| 252 | `AutomatedRedSea_PlayerDefendBase` | `context, data` | public |
| 283 | `AutomatedRedSea_PlayerDefendAlly` | `context, data` | public |
| 306 | `AutomatedRedSea_PlayerHuntPirates` | `context, data` | public |
| 347 | `AutomatedRedSea_CheckMissionComplete` | `context, data` | public |

### scenarios\campaign\abbasid\abb_m3_redsea\abb_m3_redsea_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `RedSea_InitData` | — | public |
| 270 | `GetBundle` | `id` | public |
| 281 | `GetLandingPartyIndex` | — | public |
| 287 | `GetRaiderIndex` | — | public |
| 293 | `GetRaiderUnits` | — | public |
| 302 | `GetRaiderTargets` | — | public |
| 311 | `GetRecipe` | — | public |

### scenarios\campaign\abbasid\abb_m3_redsea\abb_m3_redsea_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `RedSea_RegisterObjectives` | — | public |
| 596 | `Debug_ForceWave` | — | public |
| 602 | `Debug_BumpUnrest` | — | public |
| 607 | `MonitorTeamGold` | `context, data` | public |
| 615 | `TallyTeamGoldDuringObjective` | `onlyAllies` | public |
| 631 | `RedSea_TrackPlayerEarnedGold` | `context, data` | public |
| 642 | `ModifyCivilUnrest` | `amount, kickerPos` | public |
| 722 | `_RedSea_LogBatchedUnrest` | `context, data` | private |

### scenarios\campaign\abbasid\abb_m3_redsea\abb_m3_redsea_pirates.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Pirates_Init` | — | public |
| 60 | `Pirates_Start` | — | public |
| 74 | `Pirates_CheckForCampAttack` | — | public |
| 95 | `Pirates_EnablePlayerBaseDriveby` | `context, data` | public |
| 99 | `Pirates_CheckForPlayerSighting` | — | public |
| 115 | `Pirates_Monitor` | — | public |
| 176 | `Pirates_RebuildDock` | — | public |
| 210 | `Pirates_CommenceConstruction` | — | public |
| 236 | `Pirates_MaintainReconstruction` | — | public |
| 270 | `Pirates_MaintainReconstruction_B` | — | public |
| 282 | `Pirates_Spawn` | `isHunter` | public |
| 334 | `Pirates_OnComplete` | `army` | public |
| 345 | `Pirates_OnDeath` | `army` | public |

### scenarios\campaign\abbasid\abb_m3_redsea\abb_m3_redsea_raid.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Raids_Init` | — | public |
| 23 | `Debug_ForceRaidStart` | — | public |
| 30 | `Raids_HandleIntroShips` | `context, data` | public |
| 60 | `Raids_GetRandomSpawnPoint` | — | public |
| 68 | `Raids_LaunchRaiderWave` | — | public |
| 171 | `Raiders_TriggerPreFinaleRetreat` | — | public |
| 192 | `Raids_LaunchFinalRaiderWave` | — | public |
| 224 | `Raids_ValidateFinalWave` | `context, data` | public |
| 244 | `Debug_ShoreRaid` | — | public |
| 248 | `Raids_Monitor` | — | public |
| 270 | `Raid_SpawnFleet` | `spawnPoint, attackBuildings` | public |
| 292 | `Raids_GetTargetConvoyRoute` | `referencePos` | public |
| 309 | `Raids_FleetOnComplete` | `army` | public |
| 316 | `Raids_FleetOnDeath` | `army` | public |
| 324 | `Raid_SpawnBlockaders` | `spawnPoint` | public |
| 350 | `Raid_SpawnNetFleets` | `netFleetUnitTables` | public |
| 425 | `Raid_NetManager` | `context, data` | public |
| 479 | `Raid_PlayerHasDocks` | — | public |
| 485 | `Raid_CheckNetPosition` | `fleet` | public |
| 489 | `Raid_UpdateNetPosition` | `fleet` | public |
| 501 | `Raid_SpawnMarines` | `spawnPoint, landPoint` | public |
| 534 | `_Raids_TransitionToLand` | `army` | private |
| 548 | `Raids_SpawnMarinesEscort` | `targetList` | public |
| 568 | `Raid_SpawnDemolishers` | `spawnPoint, optWaypoint` | public |
| 594 | `Raids_DemolishersConfigureUI` | `context, data` | public |
| 608 | `Raids_DemolishersOnDeath` | `army` | public |

### scenarios\campaign\abbasid\abb_m3_redsea\abb_m3_redsea_trade_convoys.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `TradeConvoys_Init` | — | public |
| 21 | `TradeConvoys_SendHome` | — | public |
| 53 | `_TradeConvoys_Launch` | — | private |
| 89 | `_TradeConvoys_PlanRoute` | `homeMarker` | private |
| 98 | `_TradeConvoys_Manager` | `context, data` | private |
| 146 | `_TradeConvoys_IncrementRouteIndex` | `currentIdx, route` | private |

### scenarios\campaign\abbasid\abb_m3_redsea\abb_m3_redsea_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `MissionTutorial_Init` | — | public |
| 15 | `_Predicate_CompletedBannerHint` | `goal` | private |
| 19 | `_Predicate_TriggerBanner` | `goalSequence` | private |
| 28 | `MissionTutorial_AddHintToAlliedBanners` | — | public |
| 61 | `MissionTutorial_Patrol` | — | public |
| 102 | `DhowsArePatrolling` | `goal` | public |
| 115 | `UserHasDhowsOnScreen` | `goalSequence` | public |
| 145 | `Predicate_DhowsSelected` | `goal` | public |
| 153 | `IgnorePredicate_PatrolUsed` | `goalSequence` | public |
| 161 | `_Predicate_CompletedSeaOutpostHint` | `goal` | private |
| 165 | `_Predicate_TriggerSeaOutpost` | `goalSequence` | private |
| 174 | `MissionTutorial_AddHintToSeaOutpost` | — | public |
| 204 | `MissionTutorial_TagDock` | — | public |
| 225 | `MissionTutorial_UntagDock` | — | public |

### scenarios\campaign\abbasid\abb_m3_redsea\abb_m3_redsea.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 16 | `Mission_SetupPlayers` | — | public |
| 78 | `Mission_SetupVariables` | — | public |
| 83 | `Mission_Preset` | — | public |
| 158 | `Mission_PreStart` | — | public |
| 197 | `Mission_Start` | — | public |
| 213 | `CheckSquadDeath` | `context` | public |
| 267 | `ActivateDockMegavision` | — | public |
| 275 | `RedSea_CheckForAchievement` | `context, data` | public |

### scenarios\campaign\abbasid\abb_m4_hattin\abb_m4_hattin_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 38 | `AutoTest_OnInit` | — | public |
| 66 | `AutoTest_SkipAndStart` | — | public |
| 75 | `AutoTest_PlayIntro` | — | public |
| 89 | `AutomatedMission_Start` | — | public |
| 99 | `Automated_RegisterCheckpoints` | — | public |
| 121 | `AutomatedHattin_CheckPlayStart` | `context, data` | public |
| 132 | `AutomatedHattin_CheckTutorialComplete` | `context, data` | public |
| 146 | `AutomatedHattin_CheckMissionComplete` | `context, data` | public |
| 154 | `AutomatedHattin_PlayerTutorial` | `context, data` | public |
| 199 | `AutomatedHattin_PlayerBurnFields` | `context, data` | public |
| 244 | `AutomatedHattin_PlayerDefendRoad` | `context, data` | public |
| 280 | `AutomatedHattin_NilPings` | `context, data` | public |

### scenarios\campaign\abbasid\abb_m4_hattin\abb_m4_hattin_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Hattin_InitData` | — | public |

### scenarios\campaign\abbasid\abb_m4_hattin\abb_m4_hattin.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 16 | `Mission_SetupPlayers` | — | public |
| 252 | `Mission_SetupVariables` | — | public |
| 348 | `Mission_SetDifficulty` | — | public |
| 352 | `Mission_SetRestrictions` | — | public |
| 358 | `Mission_Preset` | — | public |
| 430 | `Mission_PreStart` | — | public |
| 437 | `Mission_Start` | — | public |
| 446 | `Mission_ExploreMap` | — | public |
| 450 | `Mission_ExploreMap_PartB` | — | public |
| 454 | `Mission_CheckEndConditions` | — | public |
| 471 | `GetRecipe` | — | public |
| 585 | `Hattin_SpawnBarricadeAllies` | — | public |
| 625 | `EGroup_CountEntitiesNearMarker` | `egroup, pos, range` | public |
| 653 | `SGroup_CountSquadsNearMarker` | `sgroup, pos, range` | public |
| 680 | `Hattin_ReinforceAsNeeded` | `context, data` | public |

### scenarios\campaign\abbasid\abb_m4_hattin\obj_burningfields.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 19 | `BurnableFields_Init` | — | public |
| 65 | `BurnableFields_InitField` | `field` | public |
| 98 | `BurnableFields_WatchForSuddenDeath` | `context, data` | public |
| 123 | `BurnableFields_Deactivate` | `field` | public |
| 140 | `BurnableFields_Activate` | `field` | public |
| 163 | `BurnableFields_GetField` | `name` | public |
| 171 | `BurnableFields_UpdateHint` | `field, newHint` | public |
| 180 | `BurnableFields_Manager` | — | public |
| 286 | `BurnableFields_Terminate` | `field, killEntities` | public |
| 313 | `BurnableFields_AddBlocker` | `eid, field` | public |
| 323 | `BurnableFields_RemoveBlocker` | `context, data` | public |
| 331 | `BurnableFields_GetOnFirePercentage` | `field` | public |
| 337 | `BurnableFields_CountFields` | `field` | public |
| 341 | `BurnableFields_CountFieldsOnFire` | `field` | public |
| 345 | `BurnableFields_GetFireStrength` | `field` | public |
| 349 | `BurnableFields_HasBeenBurned` | `field` | public |
| 353 | `BurnableFields_TriggerCough` | `field` | public |
| 363 | `BurnableFields_TriggerCough_RemoveHintpoint` | `context, data` | public |
| 367 | `BurnableFields_TriggerDebuffs` | `field` | public |
| 408 | `BurnableFields_ReleaseUnits` | `context, data` | public |
| 421 | `Debug_DebuffAllVFX` | — | public |
| 434 | `BurnableFields_PickRandomUnitAtLocation` | `field, resultsGroup` | public |
| 448 | `Monitor_TiberiasRoadApproach` | `context, data` | public |

### scenarios\campaign\abbasid\abb_m4_hattin\obj_crusaders.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Crusaders_InitObjectives` | — | public |
| 1050 | `Debug_Crusaders` | `strID` | public |
| 1070 | `Crusaders_GetGroup` | `id` | public |
| 1078 | `Crusaders_GetLocation` | `id` | public |
| 1087 | `Crusaders_Start` | — | public |
| 1100 | `Debug_NextWave` | — | public |
| 1117 | `_Crusaters_PreSpawn` | `context, data` | private |
| 1125 | `Crusaders_SpawnUnits` | `context, data` | public |
| 1281 | `Crusaders_CatchStragglersOnSpawn` | `context, data` | public |
| 1291 | `Crusaders_CatchStragglersOngoing` | `context, data` | public |
| 1315 | `Crusaders_GetLocation` | `locationID` | public |
| 1326 | `Crusaders_UpdateLocationWaitTime` | `locationID, newWaitTime` | public |
| 1332 | `Crusaders_ForceMarchNext` | `locationID` | public |
| 1349 | `Crusaders_AddGroupToLocation` | `group, location` | public |
| 1365 | `Crusaders_RemoveGroupFromLocation` | `group, location` | public |
| 1385 | `Crusaders_GetTarget_Route` | `group, newLocation, oldLocation, pathName` | public |
| 1437 | `Crusaders_GetPathName` | `oldLocation, newLocation` | public |
| 1448 | `Crusaders_AddMinimapPathIcons` | `pathName` | public |
| 1469 | `Crusaders_ClearAllMinimapPaths` | — | public |
| 1485 | `Crusaders_ChartFullMinimapPath` | `startLocation` | public |
| 1538 | `Crusaders_StartManager` | — | public |
| 1545 | `Crusaders_StopManager` | — | public |
| 1552 | `Crusaders_SwitchToPhase` | `entry, newPhase` | public |
| 1571 | `Crusaders_HoldForWrapUp` | `entry` | public |
| 1576 | `Crusaders_ReleaseHold` | `entry` | public |
| 1581 | `Crusaders_StartNewPhase` | `entry` | public |
| 1600 | `Crusaders_Manager` | — | public |
| 1660 | `Crusaders_ManageEntry` | `context, data` | public |
| 1743 | `Crusaders_UpdateFullPath` | `entry, newPath` | public |
| 1755 | `_Crusaders_IssuePathOrders` | `entry` | private |
| 1792 | `Crusaders_MoveToLocation_Start` | `entry, source` | public |
| 1848 | `Crusaders_MoveToLocation_Update` | `entry` | public |
| 1878 | `Crusaders_MoveToLocation_End` | `entry` | public |
| 1886 | `Crusaders_WaitAtEncampment_Start` | `entry` | public |
| 1895 | `Crusaders_WaitAtEncampment_Update` | `entry` | public |
| 1921 | `Crusaders_WaitAtEncampment_End` | `entry` | public |
| 1935 | `Crusaders_ChooseNextLocation` | `location` | public |
| 1987 | `Crusaders_ChooseNextLocation_ScoreFires` | `nextLocation` | public |

### scenarios\campaign\abbasid\abb_m4_hattin\obj_tutorial.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `BurnTutorial_InitObjectives` | — | public |
| 329 | `Tutorial_StartSecondLocation` | — | public |
| 333 | `Tutorial_MoveRangedIntoPosition` | — | public |
| 339 | `Tutorial_CheckForQueueGuidanceStart` | `context, data` | public |
| 347 | `Tutorial_HasPlayerRetreated` | — | public |
| 360 | `Tutorial_WarnIdlePlayer` | `context, data` | public |
| 379 | `BurnTutorial_Start` | — | public |
| 385 | `BurnTutorial_WatchForBurn` | `context, data` | public |
| 408 | `MissionTutorial_WaitForDebuff` | `context, data` | public |
| 416 | `MissionTutorial_RemoveDebuffHint` | `context, data` | public |
| 423 | `BurnTutorial_SpawnUnits` | `spawnIndex` | public |
| 470 | `Scouts1_Killed` | `entry` | public |
| 497 | `Scouts1_Killed_B` | `context, data` | public |
| 502 | `Tutorial_DelayedFieldTerminate` | `context, data` | public |
| 507 | `Scouts2_Killed` | `entry` | public |
| 512 | `MissionTutorial_ManageFailure` | — | public |
| 533 | `MissionTutorial_TagField` | — | public |
| 551 | `MissionTutorial_UntagField` | — | public |
| 562 | `MissionTutorial_HintStandGround` | `context, data` | public |
| 569 | `MissionTutorial_TriggerStandGroundHint` | `goalSequence` | public |

### scenarios\campaign\abbasid\abb_m5_mansurah\abb_m5_mansurah_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `AutoTest_OnInit` | — | public |
| 37 | `Automated_RegisterCheckpoints` | — | public |
| 51 | `AutoTest_SkipAndStart` | — | public |
| 61 | `AutoTest_PlayIntro` | — | public |
| 75 | `AutomatedMission_Start` | — | public |
| 82 | `Automated_WarpSpies` | `context, data` | public |
| 86 | `Automated_Phase1_Setup` | — | public |
| 91 | `Automated_Phase1_Monitor` | — | public |
| 100 | `Automated_Phase2_Setup` | — | public |
| 106 | `Automated_CheckForTransitionComplete` | — | public |
| 119 | `Automated_CreateArmy` | `context, data` | public |
| 136 | `Automated_Phase2_Monitor` | — | public |

### scenarios\campaign\abbasid\abb_m5_mansurah\abb_m5_mansurah_camp.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Camp_Init` | — | public |
| 169 | `Camp_Monitor` | `context, data` | public |
| 176 | `Camp_SpawnUnitsIntoPools` | `cohort_id, units, sgroup` | public |
| 186 | `Camp_SpawnUnitsFromBuildings` | `cohort_id, units, delay` | public |
| 194 | `Camp_OnUnitSpawnedFromBuilding` | `context, data` | public |
| 212 | `Camp_SpawnUnitsFromMapEdge` | `cohort_id, units, delay, sgroup, onComplete, should_walk` | public |
| 220 | `Camp_OnUnitSpawnedFromMapEdge` | `context, data` | public |
| 243 | `Camp_AddMaster` | `holy_order` | public |
| 253 | `Camp_SpawnUnitsIntoMuster` | `cohort_id, units, sgroup` | public |
| 257 | `Camp_MusterCohort` | `cohort_id, sgroup` | public |
| 264 | `Camp_StardardizeUnits` | `units` | public |
| 272 | `Camp_AssignPools` | `units` | public |
| 290 | `Camp_GetUnitRowReplacements` | `unitRow, possible_pools` | public |
| 306 | `Pool_Init` | `pool` | public |
| 320 | `Pool_SpawnUnits` | `pool, units, cohort_id, sgroup` | public |
| 347 | `Pool_Monitor` | `pool` | public |
| 365 | `Pool_AddMemberToIdle` | `pool, member` | public |
| 375 | `Pool_ReleaseMembers` | `pool, cohort_id, sgroup` | public |
| 415 | `Pool_CountMembers` | `pool` | public |
| 428 | `Pool_MonitorFollowers` | `pool` | public |
| 481 | `Pool_CountPotentialLighthouseMembers` | `pool` | public |
| 494 | `Wander_Init` | `markers` | public |
| 515 | `Wander_Monitor` | `context, data` | public |
| 533 | `Wander_AddMember` | `wander, member, skip_commands` | public |
| 541 | `Wander_ReleaseMembers` | `wander, released_members, cohort_id` | public |
| 555 | `Lighthouse_Init` | `name, mkr_entry, arrival_markers, discharge_markers, queue_markers` | public |
| 579 | `Lighthouse_AddMember` | `lighthouse, member` | public |
| 592 | `Lighthouse_MonitorEnrouteMember` | `context, data` | public |
| 611 | `Lighthouse_GetBestSlot` | `lighthouse` | public |
| 624 | `Lighthouse_MemberArrived` | `lighthouse, member` | public |
| 634 | `Lighthouse_SendMemberIn` | `lighthouse, member` | public |
| 641 | `Lighthouse_MonitorEnteringMember` | `context, data` | public |
| 660 | `Lighthouse_MemberEnters` | `lighthouse, member` | public |
| 672 | `Lighthouse_MemberExits` | `context, data` | public |
| 694 | `Lighthouse_MoveMemberToSlot` | `lighthouse, member, slot` | public |
| 700 | `Lighthouse_Monitor` | `context, data` | public |
| 721 | `Lighthouse_ValidateMembers` | `lighthouse` | public |
| 737 | `Lighthouse_FindHole` | `lighthouse` | public |
| 754 | `Lighthouse_ReleaseMembers` | `lighthouse, released_members, cohort_id` | public |
| 799 | `Rest_Init` | `name, markers, master_only, stay_time_min, stay_time_max, chance` | public |
| 819 | `Rest_HasSpace` | `rest` | public |
| 823 | `Rest_Monitor` | `context, data` | public |
| 843 | `Rest_AddMember` | `rest, member` | public |
| 864 | `Rest_ReleaseMembers` | `rest, released_members, cohort_id` | public |
| 878 | `Patrol_Init` | `name_of_markers, reverse` | public |
| 891 | `Patrol_AddMember` | `patrol, member` | public |
| 899 | `Patol_Monitor` | `context, data` | public |
| 915 | `Patrol_ReleaseMembers` | `patrol, released_members, cohort_id` | public |
| 930 | `Member_NewID` | — | public |
| 936 | `Member_Init` | `squad, sbp, pool, cohort_id` | public |
| 966 | `Member_IsAlive` | `member` | public |
| 979 | `Member_FromSquad` | `squad` | public |
| 985 | `Member_AssignNewActivity` | `member` | public |
| 1016 | `Member_FindAvailablePatrol` | `member, chance_floor, rand` | public |
| 1037 | `Member_FindAvailableLighthouse` | `member, chance_floor, rand` | public |
| 1057 | `Member_FindAvailableRest` | `member, chance_floor, rand` | public |
| 1084 | `CreateMarkersAroundFires` | `eg_fires` | public |
| 1094 | `CreateMarkerCircle` | `central_position, radius, slot_count` | public |
| 1112 | `GetRandomMarkerFromAreas` | `areas` | public |

### scenarios\campaign\abbasid\abb_m5_mansurah\abb_m5_mansurah_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `InitData1` | — | public |
| 505 | `GetRecipe` | — | public |
| 523 | `InitData2` | — | public |

### scenarios\campaign\abbasid\abb_m5_mansurah\abb_m5_mansurah_invasion.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `SpawnCampInvaders` | — | public |
| 19 | `GetNextRound` | — | public |
| 28 | `Invasion_Init` | — | public |
| 42 | `Invasion_CreateArmyFromSGroup` | `invasion` | public |
| 56 | `Invasion_QueueAndLaunch` | — | public |
| 78 | `UnitTable_GetNonSiegeResourceCost` | `units, player` | public |
| 96 | `Invasion_LimitMaxUnits` | `units` | public |
| 138 | `Invasion_Muster` | — | public |
| 145 | `Invasion_Launch` | `invasion` | public |
| 153 | `Invasion_AddTargets` | `context, data` | public |
| 160 | `Invasion_MonitorIncomingInvasion` | `context, data` | public |
| 183 | `Invasion_OnArmyBlocked` | `army` | public |
| 203 | `Invasion_MonitorRetreatingInvasion` | `context, data` | public |
| 218 | `Invasion_RetreatComplete` | `invasion` | public |
| 224 | `Invasion_AdjustFormation` | `context, data` | public |
| 234 | `Invasion_GetLane` | — | public |

### scenarios\campaign\abbasid\abb_m5_mansurah\abb_m5_mansurah_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Man_RegisterObjectives` | — | public |
| 126 | `StartInitialObjectives` | — | public |
| 133 | `OnEntityKilled` | `context, data` | public |
| 141 | `OnSquadKilled` | `context, data` | public |

### scenarios\campaign\abbasid\abb_m5_mansurah\abb_m5_mansurah_singles.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `SpawnSingles` | — | public |
| 148 | `Multiple_Init` | `multiple` | public |
| 153 | `Multiple_Change` | — | public |
| 160 | `Single_NewID` | — | public |
| 166 | `Single_Init` | `sgroup, markers, useAI, config` | public |
| 188 | `Single_InitPatrol` | `single, config` | public |
| 205 | `Single_InitStationary` | `single, config` | public |
| 209 | `Single_InitWithAI` | `single, config` | public |
| 225 | `Singles_Monitor` | `context, data` | public |
| 236 | `Single_Monitor` | `single` | public |
| 249 | `Single_MonitorStationary` | `single` | public |
| 264 | `Single_MonitorPatrol` | `single` | public |
| 289 | `Fire_Init` | `fire` | public |
| 302 | `IndexToString` | `index` | public |
| 310 | `GetNextSingle` | — | public |
| 319 | `UpdateTargetIndex` | `single` | public |
| 337 | `FindConfig` | `unitName, unitIndex` | public |
| 345 | `RemoveScoutBlocker` | — | public |

### scenarios\campaign\abbasid\abb_m5_mansurah\abb_m5_mansurah_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Tutorials_Init` | — | public |
| 18 | `SpyTutorial_Init` | — | public |
| 38 | `SpyTutorial_Enable` | — | public |
| 43 | `SpyTutorial_Trigger` | `goalSequence` | public |
| 54 | `SpyTutorial_Ignore` | `goalSequence` | public |
| 68 | `StealthStrikeTutorial_Init` | — | public |
| 90 | `StealthStrikeTutorial_Enable` | — | public |
| 95 | `StealthStrikeTutorial_Trigger` | `goalSequence` | public |
| 106 | `StealthStrikeTutorial_Ignore` | `goalSequence` | public |
| 120 | `PickupTutorial_Init` | — | public |
| 142 | `PickupTutorial_Enable` | — | public |
| 147 | `PickupTutorial_Trigger` | `goalSequence` | public |
| 158 | `PickupTutorial_Ignore` | `goalSequence` | public |
| 173 | `FarmhouseTutorial_Init` | — | public |
| 193 | `FarmhouseTutorial_Enable` | — | public |
| 198 | `FarmhouseTutorial_Trigger` | `goalSequence` | public |
| 207 | `FarmhouseTutorial_Ignore` | `goalSequence` | public |
| 222 | `AppointSpyTutorial_Init` | — | public |
| 265 | `AppointSpyTutorial_Enable` | — | public |
| 273 | `AppointSpyTutorial_Trigger` | `goalSequence` | public |
| 284 | `AppointSpyTutorial_Ignore` | `goalSequence` | public |
| 324 | `AppointSpyTutorial_ShajarIsSelected` | `goal` | public |
| 328 | `OpenShajarRadialMenu` | `goal` | public |
| 334 | `UsedAppointSpy` | `goal` | public |
| 346 | `PlacingSpyMonitor` | `blueprint, phase` | public |
| 363 | `ReturnFalse` | — | public |
| 367 | `PlayerIsSelectingShajar` | — | public |

### scenarios\campaign\abbasid\abb_m5_mansurah\abb_m5_mansurah_transition.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Transition_MonitorSpy` | `context, data` | public |
| 14 | `Transition_SpyArrived` | — | public |
| 24 | `Transition_ResumeGameplay` | — | public |
| 93 | `WarpCavalry_A` | — | public |
| 109 | `Transition_ResumeGameplay_Objetives` | — | public |
| 116 | `Transition_ResumeGameplay_HelpSoon` | — | public |
| 120 | `Transition_ResumeGameplay_Autosave` | — | public |
| 125 | `Transition_ResumeGameplay_SpyHint` | — | public |

### scenarios\campaign\abbasid\abb_m5_mansurah\abb_m5_mansurah.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `Mission_SetupPlayers` | — | public |
| 46 | `Mission_SetupVariables` | — | public |
| 51 | `Mission_Preset` | — | public |
| 195 | `Mission_PreStart` | — | public |
| 214 | `Mission_Start` | — | public |
| 233 | `RemoveGatherSpeedModifications` | — | public |
| 244 | `StartMonitoringResources` | — | public |
| 250 | `MonitorResources` | `context, data` | public |
| 264 | `Ambush_Spawn` | — | public |
| 292 | `Ambush_Monitor` | `context, data` | public |
| 301 | `Ambush_Trigger` | — | public |
| 321 | `Ambush_Reveal` | `context, data` | public |
| 328 | `Ambush_ShowHint` | `context, data` | public |
| 332 | `SpawnCampFollowers` | — | public |
| 336 | `SpawnHolyOrders` | — | public |
| 352 | `HolyOrder_Flee` | `holy_order` | public |
| 376 | `HolyOrder_SingleMemberFlees` | `context, data` | public |
| 394 | `SpawnDefendingArmies` | — | public |
| 400 | `BaybarsArrives` | — | public |
| 429 | `BaybarsArrives_B` | `context, data` | public |
| 449 | `VOCue_BaybarsSelected` | — | public |
| 459 | `OnAbilityExecuted` | `context, data` | public |
| 472 | `PrintReport` | — | public |
| 523 | `tag` | — | public |
| 533 | `untag` | — | public |
| 538 | `skipBaybarsTimer` | — | public |

### scenarios\campaign\abbasid\abb_m6_aynjalut\abb_m6_aynjalut_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `AutoTest_OnInit` | — | public |
| 36 | `Automated_RegisterCheckpoints` | — | public |
| 50 | `AutoTest_SkipAndStart` | — | public |
| 60 | `AutoTest_PlayIntro` | — | public |
| 74 | `AutomatedMission_Start` | — | public |
| 109 | `Automated_MonitorDefenders` | — | public |
| 121 | `Automated_MonitorReinforcements` | `context, data` | public |
| 130 | `Automated_Phase1_Setup` | — | public |
| 135 | `Automated_Phase1_Monitor` | — | public |
| 144 | `Automated_Phase2_Setup` | — | public |
| 149 | `Automated_Phase2_Monitor` | — | public |

### scenarios\campaign\abbasid\abb_m6_aynjalut\abb_m6_aynjalut_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `AynJalut_InitData1` | — | public |
| 1052 | `CreateLane` | `lane_name, min, max` | public |
| 1073 | `CreateSlots` | `area_name` | public |
| 1089 | `GetRecipe` | — | public |
| 1110 | `AynJalut_InitData2` | — | public |

### scenarios\campaign\abbasid\abb_m6_aynjalut\abb_m6_aynjalut_forces.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Round_Init` | `round` | public |
| 26 | `Cohort_Init` | `cohort` | public |
| 42 | `Force_Init` | `force` | public |
| 103 | `QueueCohorts` | — | public |
| 118 | `Cohort_Arrives` | `context, data` | public |
| 128 | `Cohort_Signal` | `context, data` | public |
| 140 | `Force_Spawn` | `context, data` | public |
| 157 | `Force_SpawnInRank` | `context, data` | public |
| 187 | `Round_HasFinishedSpawning` | `round` | public |
| 196 | `Force_SpawnNotInRank` | `force` | public |
| 219 | `Force_ExecuteOrders` | `context, data` | public |
| 250 | `Force_ExecuteOrderWaitForDuration` | `context, data` | public |
| 261 | `Force_ExecuteOrderWaitForArrival` | `context, data` | public |
| 283 | `Force_ExecuteOrderRun` | `force, command, orders` | public |
| 302 | `Force_ExecuteOrderWalk` | `force, command, orders` | public |
| 320 | `Force_ExecuteOrderAttackLane` | `force, command, orders, order` | public |
| 336 | `Force_AddLaneTargetsWithAI` | `force, lane, enable_ai` | public |
| 354 | `Force_AddLaneTargetsWithoutAI` | `force, lane` | public |
| 361 | `Force_ExecuteOrderAttackSlot` | `force, command, orders, order` | public |
| 379 | `Force_AttackSlotWithAI` | `force, slot, enable_ai` | public |
| 396 | `Force_AttackSlotWithoutAI` | `force, slot` | public |
| 402 | `Force_FinishAfula` | `force, command, orders, order` | public |
| 414 | `Force_FinishAfulaWithAI` | `force, command, orders, order` | public |
| 419 | `Force_FinishAfulaWithoutAI` | `force, command, orders, order` | public |
| 427 | `Force_OnArmyComplete` | `army` | public |
| 436 | `Force_CreateArmy` | `force, spawn, targets` | public |
| 448 | `Force_ChooseAfulaTargets` | `force` | public |

### scenarios\campaign\abbasid\abb_m6_aynjalut\abb_m6_aynjalut_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `AynJalut_InitObjectives` | — | public |
| 130 | `UpdateAfulaVillagerCount` | — | public |
| 141 | `StartInitialObjectives` | — | public |
| 147 | `StartMainObjective` | — | public |

### scenarios\campaign\abbasid\abb_m6_aynjalut\abb_m6_aynjalut.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `Mission_SetupPlayers` | — | public |
| 33 | `Mission_SetupVariables` | — | public |
| 37 | `Mission_Preset` | — | public |
| 86 | `Mission_PreStart` | — | public |
| 91 | `Mission_Start` | — | public |
| 115 | `PerSecond` | `context, data` | public |
| 123 | `SpawnAllyVillagers` | — | public |
| 167 | `ModifyVision` | — | public |
| 178 | `InitResources` | — | public |
| 190 | `SpawnEnemyScout` | `context, data` | public |
| 200 | `ScoutCTA` | `context, data` | public |
| 207 | `AdvanceScout` | `context, data` | public |
| 214 | `OnSquadDeath` | `context, data` | public |
| 246 | `OnEntityDamaged` | `context, data` | public |
| 255 | `AfulaVillagerAttacked` | `squad` | public |
| 274 | `RemoveAlert` | `context, data` | public |
| 278 | `StartTrackingForwardVillagers` | `sgroup` | public |
| 294 | `MonitorForwardVillagers` | — | public |
| 323 | `VillagerFlee` | `villager, is_left` | public |
| 346 | `MonitorFleeingVillagers` | — | public |
| 361 | `VillagerStopFleeing` | `villager` | public |
| 368 | `debug_kill` | `context, data` | public |
| 379 | `MakeAllyBuildingsAttackable` | — | public |
| 384 | `MakeAllyBuildingsImmune` | — | public |
| 393 | `Reinforcement_Init` | `reinforcement` | public |
| 409 | `Reinforcement_Queue` | `reinforcement` | public |
| 423 | `Battalion_Queue` | `context, data` | public |
| 472 | `MakeEGroupAttackable` | `context, data` | public |
| 486 | `ShowMinimapPath` | — | public |
| 496 | `Minimap_AnimateArrowPath` | `context, data` | public |
| 520 | `Minimap_AnimateArrowPath_AddBlip` | `context, data` | public |
| 546 | `Minimap_AnimateArrowPath_RemoveBlip` | `context, data` | public |
| 555 | `Healers_Init` | — | public |
| 566 | `Healers_Monitor` | `context, data` | public |
| 580 | `PrintReport` | `prefix` | public |
| 586 | `GetReinforcementRatio` | — | public |
| 598 | `Math_Round` | `float` | public |

### scenarios\campaign\abbasid\abb_m7_acre\abb_m7_acre_attackcycle.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `COUNTER_ATTACK` | — | public |
| 45 | `_Monitor_Barrage_Used` | `context, data` | private |
| 56 | `_Monitor_Barrage_Refreshed` | — | private |
| 62 | `Loop_EnemyReinforcementSpawn` | `timesToLoop` | public |

### scenarios\campaign\abbasid\abb_m7_acre\abb_m7_acre_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 38 | `AutoTest_OnInit` | — | public |
| 73 | `AutoTest_SkipAndStart` | — | public |
| 82 | `AutoTest_PlayIntro` | — | public |
| 97 | `AutomatedMission_Start` | — | public |
| 104 | `AutomatedAcre_RegisterCheckpoints` | — | public |
| 117 | `AutomatedAcre_Phase1_CheckPlayStart` | — | public |
| 130 | `AutomatedAcre_MissionComplete` | — | public |
| 152 | `Player_RovingArmy` | — | public |
| 191 | `Sort_EnemyKeeps` | — | public |
| 201 | `Barrage_Activate` | — | public |
| 205 | `RF_ED` | — | public |
| 209 | `RocksFall` | — | public |

### scenarios\campaign\abbasid\abb_m7_acre\abb_m7_acre_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Init_Acre_Difficulty` | — | public |
| 68 | `Acre_InitTuningValues` | — | public |
| 91 | `Acre_MarkerData` | — | public |
| 126 | `Acre_InitMarkerArmies` | — | public |
| 293 | `Compare_Army_Distance` | `armyA, armyB` | public |
| 297 | `Compare_Navy_Distance` | `navyA, navyB` | public |
| 301 | `Sort_Enemy_Tables_Distances` | — | public |
| 316 | `_Amoritize_EnemySpawns` | `context, data` | private |
| 342 | `Acre_LaunchAttack` | — | public |
| 463 | `AllyTargetClosestKeep` | `army` | public |
| 469 | `Init_GenoeseAttack` | — | public |
| 548 | `_GenoeseAttack_TransitionToLand` | `army` | private |
| 566 | `Acre_InitPlayerUnits` | — | public |
| 615 | `Acre_InitAlliedUnits` | — | public |
| 659 | `Replace_Allied_Units` | — | public |
| 692 | `Init_StoryModeItems` | — | public |
| 699 | `_Monitor_WaterRuins` | — | private |
| 714 | `_Monitor_NavyTransports` | — | private |
| 732 | `SpawnEnemy_FrankishMarines` | — | public |
| 772 | `_RuinsAttack_TransitionToLand` | `army` | private |
| 787 | `Flank_Warning` | — | public |
| 809 | `Flank_Warning_Cooldown` | — | public |
| 814 | `Difficulty_Split` | `lowerDiff, lower, higher` | public |

### scenarios\campaign\abbasid\abb_m7_acre\abb_m7_acre_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Acre_InitObjectives` | — | public |
| 99 | `_Monitor_Genoese_Timer` | — | private |
| 117 | `Update_KeepMarkers` | — | public |
| 134 | `Monitor_KeepVisbility` | — | public |
| 143 | `AddKeepUIMarker` | `entity` | public |
| 153 | `_KeepIsVisible` | `context, data` | private |
| 161 | `_KeepIsDead` | `context, data` | private |
| 171 | `_Monitor_SiegeCampHealth` | — | private |

### scenarios\campaign\abbasid\abb_m7_acre\abb_m7_acre_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `Acre_Tutorials_Init` | — | public |
| 19 | `StayOnGoal` | — | public |
| 27 | `MissionTutorial_Relic` | — | public |
| 58 | `Relic_TutorialTrigger` | `goalSequence` | public |
| 69 | `Relic_IgnoreTrigger` | `goalSequence` | public |
| 96 | `MissionTutorial_SiegeCamp` | — | public |
| 126 | `SiegeCamp_TutorialTrigger` | `goalSequence` | public |
| 136 | `SiegeCamp__IgnoreTrigger` | `goalSequence` | public |

### scenarios\campaign\abbasid\abb_m7_acre\abb_m7_acre.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `Mission_SetupPlayers` | — | public |
| 51 | `Mission_SetupVariables` | — | public |
| 113 | `Mission_SetDifficulty` | — | public |
| 117 | `Mission_SetRestrictions` | — | public |
| 191 | `Mission_Preset` | — | public |
| 215 | `Mission_Start` | — | public |
| 269 | `_Control_AlliedArmy` | `context, data` | private |
| 280 | `_MonitorAllyArmy` | `context, data` | private |
| 289 | `_Monitor_Enemy_Replacements` | — | private |
| 315 | `_Monitor_Enemy_Naval_Replacements` | — | private |
| 341 | `Mission_TrickleResources` | — | public |
| 351 | `_Monitor_Ship_Resource_Drops` | `context, data` | private |
| 364 | `_Monitor_Land_Resource_Drops` | `context, data` | private |
| 379 | `Get_ValidEnemySpawn` | — | public |
| 387 | `Get_ValidEnemySpawn_Naval` | — | public |
| 395 | `Acre_AutoSaveInterval` | — | public |
| 399 | `GetRecipe` | — | public |
| 425 | `Debug_SkipToGenoese` | — | public |
| 429 | `Debug_SkipMissionComplete` | — | public |

### scenarios\campaign\abbasid\abb_m8_cyprus\abb_m8_cyprus_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 19 | `AutoTest_OnInit` | — | public |
| 44 | `AutomatedCyprus_RegisterCheckpoints` | — | public |
| 64 | `AutoTest_SkipAndStart` | — | public |
| 73 | `AutoTest_PlayIntro` | — | public |
| 87 | `AutomatedMission_Start` | — | public |
| 95 | `AutomatedCyprus_Phase1_CheckPlayStart` | — | public |
| 127 | `AutomatedCyprus_Phase2_LimassolIsComplete` | — | public |
| 142 | `AutomatedCyprus_CheckVillagers` | — | public |
| 151 | `AutomatedCyprus_CheckArmySpawn` | — | public |
| 189 | `AutomatedCyprus_MoveArmy` | — | public |
| 194 | `AutomatedCyprus_AttackFamagustaDock` | — | public |
| 201 | `AutomatedCyprus_Phase3_CheckNicosiaIsGettingAttacked` | — | public |
| 215 | `AutomatedCyprus_Phase4_NicosiaDestroyed_TC` | — | public |
| 226 | `AutomatedCyprus_Phase4_NicosiaDestroyed_Keeps` | — | public |

### scenarios\campaign\abbasid\abb_m8_cyprus\abb_m8_cyprus_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Init_Cyprus_Difficulty` | — | public |
| 255 | `Cyprus_SetupData` | — | public |
| 491 | `Cyprus_EnemyMarkerData` | — | public |
| 510 | `GetRecipe` | — | public |

### scenarios\campaign\abbasid\abb_m8_cyprus\abb_m8_cyprus_defenders.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Init_Nicosia` | — | public |
| 34 | `Cyprus_GarrisonNicosiaKeeps` | — | public |
| 39 | `Cyprus_UnGarrisonNicosiaKeeps` | — | public |
| 45 | `Cyprus_MonitorNicosiaKeepHealth` | — | public |
| 53 | `Cyprus_MergeNicosiaGarrisons` | — | public |
| 68 | `Cyprus_SpawnStandAloneSiege` | `player, marker_stem, unitType, target_stem, amount, sgroup` | public |
| 82 | `Cyprus_SpawnScatteredDefenders` | `player, unitType, blueprint, marker_name, sgroup` | public |
| 96 | `Cyprus_SpawnWallLines` | `player, unit_table, spawn_stem, dest_stem, numLines, sgroup` | public |
| 106 | `Cyprus_SpawnWallLine` | `player, unit_table, spawn, dest_name, sgroup` | public |
| 134 | `Cyprus_StopNicosiaSiege` | — | public |
| 138 | `Cyprus_StopFamagustaSiege` | — | public |
| 145 | `Init_Famagusta_Navy` | — | public |
| 185 | `Init_Famagusta` | — | public |
| 200 | `Init_Limassol` | — | public |
| 240 | `Amortise_EnemySpawns` | `context, data` | public |

### scenarios\campaign\abbasid\abb_m8_cyprus\abb_m8_cyprus_encounters.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Monitor_Player_Nicosia_Prox` | `context, data` | public |
| 28 | `Monitor_Player_Famagusta_Prox` | `context, data` | public |
| 40 | `Cyprus_StartFamagustaObjective` | — | public |
| 47 | `Monitor_Player_Kyrenia_Prox` | `context, data` | public |
| 60 | `Monitor_Player_Kyrenia_NearProx` | `context, data` | public |
| 68 | `Cyprus_StartKyreniaDelayed` | — | public |
| 80 | `Cyprus_ObjectiveTargetKilled` | `context` | public |
| 131 | `Cyprus_StopNavalRaids` | — | public |
| 140 | `Cyprus_NavalRetreat` | — | public |
| 147 | `Cyprus_KyreniaDissolveArmies` | — | public |
| 164 | `Cyprus_KyreniaRetreat` | — | public |
| 170 | `Cyprus_CheckNicosiaFinale` | — | public |

### scenarios\campaign\abbasid\abb_m8_cyprus\abb_m8_cyprus_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Cyprus_Init_Objectives` | — | public |
| 203 | `Monitor_Player_Prisons_Prox` | — | public |
| 211 | `Init_LimassolCapture` | — | public |
| 343 | `Cyprus_CheckBuildHoWStart` | — | public |

### scenarios\campaign\abbasid\abb_m8_cyprus\abb_m8_cyprus_prison_logic.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `Init_Prisons` | — | public |
| 53 | `Prisoner_Init` | `prison` | public |
| 76 | `Prisons_Monitor` | `context, data` | public |
| 114 | `Prisons_RefreshResources` | `context, data` | public |
| 123 | `Gold_Camp_Monitor` | — | public |
| 130 | `Wood_Camp_Monitor` | — | public |
| 137 | `AllPrisonersRescued` | — | public |

### scenarios\campaign\abbasid\abb_m8_cyprus\abb_m8_cyprus.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 10 | `Mission_SetupPlayers` | — | public |
| 138 | `Mission_SetupVariables` | — | public |
| 186 | `Mission_SetDifficulty` | — | public |
| 190 | `Mission_SetRestrictions` | — | public |
| 197 | `Mission_Preset` | — | public |
| 283 | `Mission_PreStart` | — | public |
| 308 | `Mission_Start` | — | public |
| 332 | `Cyprus_InitNavalRaid` | — | public |
| 344 | `Cyprus_MoveInitNavalRaid` | — | public |
| 348 | `Cyprus_LaunchInitNavalRaid` | — | public |
| 352 | `Cyprus_LaunchInitKyreniaRaid` | — | public |
| 362 | `Cyprus_CheckKyreniaRaidProx` | — | public |
| 372 | `Cyprus_DissolveKyreniaRaid` | — | public |
| 378 | `Kyrenia_RetreatAttackers` | — | public |
| 384 | `Cyprus_StartShipAttackCheck` | — | public |
| 388 | `Cyprus_CheckPlayerShipAttacked` | — | public |
| 419 | `Cyprus_Ship_Built` | `context` | public |
| 434 | `Cyprus_HoW_Started` | `context` | public |
| 440 | `Cyprus_HoW_Constructed` | `context` | public |
| 449 | `Cyprus_BuildWings` | — | public |
| 458 | `Cyprus_AutoSaveInterval` | — | public |
| 466 | `Tradeship_Timer` | — | public |
| 480 | `Monitor_Nicosia_Attacks_Start` | `context, data` | public |
| 496 | `Nicosia_Monitor_InitRaid` | `context, data` | public |
| 505 | `Cyprus_StartFamagustaRaids` | — | public |
| 521 | `Monitor_Kyrenia_Reinforcements` | — | public |
| 544 | `Cyprus_GetSequentialMarkers` | `marker_stem, num` | public |
| 561 | `Nicosia_Attacks` | — | public |
| 585 | `Nicosia_OnSpawn` | `context, data` | public |
| 597 | `Nicosia_OnComplete` | `context, data` | public |
| 603 | `Nicosia_Launch_Attack` | `context, data` | public |
| 634 | `Nicosia_Attack_Blocked` | `army` | public |
| 645 | `Nicosia_Monitor_Attack` | `context, data` | public |
| 660 | `Nicosia_RetreatAttackers` | — | public |
| 669 | `Init_Famagusta_Patrols` | — | public |
| 686 | `Spawn_Navy_Raids` | — | public |
| 692 | `Famagusta_Navy_Raids_OnSpawn` | `context, data` | public |
| 697 | `Famagusta_Navy_Raids_OnComplete` | `context, data` | public |
| 703 | `Famagusta_Navy_Raids_Launch_Attack` | `context, data` | public |
| 721 | `Cyprus_CheckSquadDeath` | `context` | public |
| 753 | `CyprusDebug_CaptureLimassol` | — | public |
| 758 | `CyprusDebug_DestroyFamagusta` | — | public |
| 768 | `CyprusDebug_DestroyKyrenia` | — | public |
| 781 | `CyprusDebug_DestroyNicosia` | — | public |
| 790 | `CyprusDebug_AccelerateEnemyAttacks` | — | public |

### scenarios\campaign\angevin\ang_chp0_intro\ang_chp0_intro.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 21 | `Mission_SetupPlayers` | — | public |
| 60 | `Mission_SetupVariables` | — | public |
| 200 | `Mission_SetRestrictions` | — | public |
| 205 | `Mission_Preset` | — | public |
| 323 | `Mission_PreStart` | — | public |
| 328 | `Mission_Start` | — | public |
| 351 | `GetRecipe` | — | public |
| 499 | `Villagers_StartingUnits` | — | public |
| 510 | `EconDarkAge_OnConstructionComplete` | `context` | public |
| 553 | `MilitaryFeudal_OnConstructionComplete` | `context` | public |
| 638 | `ChangeBuildTimes` | — | public |
| 662 | `FindGoldDeposit_Monitor` | — | public |
| 682 | `ApproachingMaxPop_Monitor` | — | public |
| 699 | `Cheat_Explore_DarkAge` | — | public |
| 743 | `Cheat_Progress_Feudalage` | — | public |
| 771 | `Cheat_FeudalMilitary` | — | public |
| 800 | `Cheat_AttackCavalry` | — | public |
| 830 | `Cheat_AttackArchery` | — | public |
| 840 | `Cheat_AttackInfantry` | — | public |
| 852 | `Cheat_Progress_Castleage` | — | public |

### scenarios\campaign\angevin\ang_chp0_intro\obj_attack_enemyarchery.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `IntroAttackArchery_InitObjectives` | — | public |
| 132 | `SOBJ_BuildStables_UI` | — | public |
| 143 | `SOBJ_BuildStables_Start` | — | public |
| 152 | `PostCTAStables` | — | public |
| 156 | `StablesHint` | — | public |
| 163 | `SOBJ_BuildStables_OnComplete` | — | public |
| 167 | `ProduceHorsemen_UI` | — | public |
| 173 | `ProduceHorsemen_Start` | — | public |
| 183 | `ProduceHorsementTip` | — | public |
| 189 | `ProduceHorsemen_Monitor` | — | public |
| 205 | `ProduceHorsemen_OnComplete` | — | public |
| 212 | `StartDelayedObjArcheryBuildings` | — | public |
| 217 | `KillArchers_UI` | — | public |
| 223 | `KillArchers_Start` | — | public |
| 232 | `CombatArcheryTip` | — | public |
| 239 | `EnemyKilledArcheryEncampment` | `context` | public |
| 261 | `KillArchers_OnComplete` | — | public |
| 264 | `DestroyTheArcheryEncampment_UI` | — | public |
| 270 | `DestroyTheArcheryEncampment_Start` | — | public |
| 286 | `DestroyTheArcheryRange_Monitor` | — | public |
| 297 | `DestroyTheArcheryEncampment_OnComplete` | — | public |
| 301 | `AttackArchersEncampment_OnComplete` | — | public |

### scenarios\campaign\angevin\ang_chp0_intro\obj_attack_enemyinfantry.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `IntroAttackInfantry_InitObjectives` | — | public |
| 155 | `SOBJ_BuildArcheryRange_UI` | — | public |
| 166 | `SOBJ_BuildArcheryRange_Start` | — | public |
| 176 | `PostCTAArcheryRange` | — | public |
| 181 | `AddArcheryRangeHintObj` | — | public |
| 188 | `SOBJ_BuildArcheryRange_OnComplete` | — | public |
| 192 | `ProduceArchers_UI` | — | public |
| 199 | `ProduceArchers_Start` | — | public |
| 206 | `ProduceArchersTip` | — | public |
| 213 | `ProduceArchers_Monitor` | — | public |
| 235 | `ProduceArchers_OnComplete` | — | public |
| 241 | `SetupLongbowmenCliff_UI` | — | public |
| 245 | `SetupLongbowmenCliff_Start` | — | public |
| 259 | `SetupArchersTip` | — | public |
| 266 | `SpearmanDeadMonitor` | — | public |
| 276 | `BarrackDestroyedMonitor` | — | public |
| 287 | `LongbowmenOnCliff_Monitor` | — | public |
| 304 | `SetupLongbowmenCliff_OnComplete` | — | public |
| 328 | `KillSpearman_UI` | — | public |
| 334 | `KillSpearman_Start` | — | public |
| 352 | `SendSpearmanToAttackPlayer` | — | public |
| 362 | `EnemyKilledSpearmanEncampment` | `context` | public |
| 384 | `KillSpearman_OnComplete` | — | public |
| 395 | `DestroyTheInfantryEncampment_UI` | — | public |
| 402 | `DestroyTheInfantryEncampment_Start` | — | public |
| 409 | `DestroyInfantryCamp_Monitor` | — | public |
| 428 | `CheckObjectivesInfantryObjDone_Monitor` | — | public |
| 434 | `DestroyTheInfantryEncampment_OnComplete` | — | public |
| 442 | `AttackInfantryEncampment_OnComplete` | — | public |
| 447 | `MissionZero_ForceVillagersToFlee` | `targetVillagerLife` | public |

### scenarios\campaign\angevin\ang_chp0_intro\obj_attackenemycavalry.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `IntroAttackCavalry_InitObjectives` | — | public |
| 113 | `SOBJ_AttackMove_UI` | — | public |
| 118 | `SOBJ_AttackMove_PreStart` | — | public |
| 127 | `SOBJ_AttackMove_Start` | — | public |
| 137 | `AttackMove_Monitor` | — | public |
| 154 | `LonelyUnit_Monitor` | — | public |
| 169 | `SpawnAnotherLonelyUnit` | — | public |
| 180 | `MoveUnitAttackMove` | — | public |
| 187 | `AttachIconOnUnit` | — | public |
| 194 | `SOBJ_AttackMove_OnComplete` | — | public |
| 204 | `KillHorsemen_UI` | — | public |
| 212 | `KillHorsemen_Start` | — | public |
| 220 | `CavalryCombatTip` | — | public |
| 226 | `CavalryEncampmentDeathEvent` | `context` | public |
| 252 | `Horsemen_CompletionMonitor` | — | public |
| 263 | `KillHorsemen_OnComplete` | — | public |
| 267 | `DestroyTheStables_UI` | — | public |
| 274 | `DestroyTheStables_Start` | — | public |
| 279 | `DestroyTheStables_Monitor` | — | public |
| 298 | `DestroyTheStables_OnComplete` | — | public |
| 301 | `AttackCavalryEncampment_OnComplete` | — | public |

### scenarios\campaign\angevin\ang_chp0_intro\obj_economy_darkage.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `IntroEconomyDarkAge_InitObjectives` | — | public |
| 239 | `GatherFood_Start` | — | public |
| 246 | `StartFoodTip` | — | public |
| 251 | `GatherFood_Monitor` | — | public |
| 272 | `GatherFood_UI` | — | public |
| 280 | `GatherFood_OnComplete` | — | public |
| 290 | `ProduceVillagers_Start` | — | public |
| 300 | `ProduceVillagers_UI` | — | public |
| 306 | `ProduceVillagers_Monitor` | — | public |
| 329 | `ProduceVillagers_OnComplete` | — | public |
| 335 | `BuildMill_UI` | — | public |
| 339 | `BuildMill_Start` | — | public |
| 344 | `BuildMill_OnComplete` | — | public |
| 351 | `BuildLumberCamp_UI` | — | public |
| 355 | `BuildLumberCamp_Start` | — | public |
| 360 | `StartTipLumberCamp` | — | public |
| 366 | `BuildLumberCamp_OnComplete` | — | public |
| 372 | `BuildFarms_UI` | — | public |
| 376 | `BuildFarms_Start` | — | public |
| 383 | `MonitorNumberFarms` | — | public |
| 424 | `StartTip_BuildFarms` | — | public |
| 431 | `BuildFarms_OnComplete` | — | public |
| 436 | `GatherWood_UI` | — | public |
| 442 | `GatherWood_Start` | — | public |
| 449 | `WoodHint` | — | public |
| 455 | `GatherWood_Monitor` | — | public |
| 475 | `GatherWood_OnComplete` | — | public |
| 480 | `BuildHouses_UI` | — | public |
| 484 | `BuildHouses_Start` | — | public |
| 490 | `BuildHouses_OnComplete` | — | public |
| 499 | `IntroEconomy_OnComplete` | — | public |

### scenarios\campaign\angevin\ang_chp0_intro\obj_explore_darkage.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `IntroExploreDarkAge_InitObjectives` | — | public |
| 145 | `ProduceScout_UI` | — | public |
| 149 | `ProduceScout_Start` | — | public |
| 155 | `ScoutHint` | — | public |
| 162 | `ProduceScout_Monitor` | — | public |
| 185 | `ProduceScout_OnComplete` | — | public |
| 190 | `FindGoldDeposit_UI` | — | public |
| 194 | `FindGoldDeposit_Start` | — | public |
| 198 | `FindGoldTip` | — | public |
| 204 | `FindGoldDeposit_OnComplete` | — | public |
| 208 | `BuildMine_UI` | — | public |
| 212 | `BuildMine_Start` | — | public |
| 220 | `StartTip_BuildMine` | — | public |
| 224 | `BuildMine_OnComplete` | — | public |
| 230 | `GatherGold_UI` | — | public |
| 236 | `GatherGold_Start` | — | public |
| 243 | `GatherGold_Monitor` | — | public |
| 262 | `GoldTip` | — | public |
| 271 | `GatherGold_OnComplete` | — | public |
| 278 | `IntroExploring_OnComplete` | — | public |

### scenarios\campaign\angevin\ang_chp0_intro\obj_military_feudal.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `IntroLearnSpearman_InitObjectives` | — | public |
| 136 | `BuildBarrack_UI` | — | public |
| 140 | `BuildBarrack_Start` | — | public |
| 147 | `BarracksTip` | — | public |
| 163 | `Monitor_AmountVillagers` | — | public |
| 173 | `BuildBarrack_OnComplete` | — | public |
| 177 | `ProduceSpearmen_UI` | — | public |
| 183 | `ProduceSpearmen_Start` | — | public |
| 188 | `SpearmenTip` | — | public |
| 195 | `ProduceSpearmen_Monitor` | — | public |
| 217 | `ProduceSpearmen_OnComplete` | — | public |
| 227 | `DestroyThePallisade_UI` | — | public |
| 233 | `DestroyPallisade_EntityKill` | `context` | public |
| 247 | `SeePalisade_Monitor` | — | public |
| 261 | `DestroyThePallisade_OnComplete` | — | public |
| 267 | `IntroLearnSpearman_OnComplete` | — | public |
| 274 | `WaitBeforeStartNextAttackObj` | — | public |

### scenarios\campaign\angevin\ang_chp0_intro\obj_progress_castleage.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `IntroProgressCastleAge_InitObjectives` | — | public |
| 71 | `AgeUpCastle_UI` | — | public |
| 75 | `AgeUpCastle_Start` | — | public |
| 82 | `CastleAgeTip` | — | public |
| 89 | `AgeUpCastle_Monitor` | — | public |
| 102 | `AgeUpCastle_OnComplete` | — | public |
| 107 | `IntroProgressToCastleAge_OnComplete` | — | public |
| 112 | `ProgressAgeCastle_OnConstructionStart` | `context` | public |
| 137 | `ProgressAgeCastle_OnConstructionCancelled` | `context` | public |

### scenarios\campaign\angevin\ang_chp0_intro\obj_progress_feudalage.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `IntroProgressFeudalAge_InitObjectives` | — | public |
| 69 | `AgeUpFeudal_UI` | — | public |
| 73 | `AgeUpFeudal_Start` | — | public |
| 82 | `MonitorFood` | — | public |
| 100 | `MonitorWood` | — | public |
| 119 | `AgeUpFeudal_Monitor` | — | public |
| 129 | `AgeUpFeudal_OnComplete` | — | public |
| 136 | `IntroProgressToFeudalAge_OnComplete` | — | public |
| 142 | `AddLandmarkHintpoint` | — | public |
| 146 | `ProgressAgeFeudal_OnConstructionStart` | `context` | public |
| 171 | `ProgressAgeFeudal_OnConstructionCancelled` | `context` | public |

### scenarios\campaign\angevin\ang_chp0_intro\obj_tip_darkage.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `IntroTipsDarkAge_InitObjectives` | — | public |
| 142 | `TipBuildFarms_OnComplete` | — | public |
| 146 | `TipGatherFood_OnComplete` | — | public |
| 150 | `TipBuildHouses_OnComplete` | — | public |
| 154 | `TipBuildMiningCamp_OnComplete` | — | public |
| 158 | `TipGatherGold_OnComplete` | — | public |
| 162 | `TipBuildMill_OnComplete` | — | public |
| 166 | `TipAgeUpFeudal_OnComplete` | — | public |
| 170 | `TipAgeUpFeudalMoreVillagers_OnComplete` | — | public |
| 174 | `StartTipMill` | — | public |
| 182 | `TipBuildLumberCamp_OnComplete` | — | public |

### scenarios\campaign\angevin\ang_chp0_intro\obj_tip_feudal.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `IntroTipsFeudal_InitObjectives` | — | public |
| 187 | `TipNotEnoughFood_OnComplete` | — | public |
| 191 | `TipNotEnoughWood_OnComplete` | — | public |
| 195 | `TipDoubleClickSelect_OnComplete` | — | public |
| 199 | `TipMakeMoreVillagers_OnComplete` | — | public |
| 203 | `TipAttackPalisade_OnComplete` | — | public |
| 207 | `TipBuildBarracks_OnComplete` | — | public |
| 211 | `TipProduceSpearmen_OnComplete` | — | public |
| 215 | `Tip_AttackMove_OnComplete` | — | public |
| 219 | `TipBuildStables_OnComplete` | — | public |
| 223 | `TipBuildArcheryRange_OnComplete` | — | public |
| 227 | `TipBuildMultipleStables_OnComplete` | — | public |

### scenarios\campaign\angevin\ang_chp0_intro\training_missionzero.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 44 | `Disable_CoreTutorials_MinusExceptions` | — | public |
| 113 | `Tutorials_MissionZero_GatherFood` | — | public |
| 155 | `MissionZero_GatherFoodTrigger` | `goalSequence` | public |
| 166 | `Predicate_AVillagerIsGatheringFood` | `goal` | public |
| 170 | `IgnorePredicate_FoodGathered` | `goalSequence` | public |
| 178 | `Tutorials_MissionZero_SelectDragUnits` | — | public |
| 205 | `MissionZero_BandboxTrigger` | `goalSequence` | public |
| 238 | `MissionZero_UserHasMultiselected` | `goal` | public |
| 246 | `Tutorials_MissionZero_HighlightVillagers` | — | public |
| 287 | `MissionZero_VillagerLessonTrigger` | `goalSequence` | public |
| 297 | `Predicate_VillagersBuilt` | `goal` | public |
| 304 | `IgnorePredicate_VillagersBuilt` | `goalSequence` | public |
| 324 | `Tutorials_MissionZero_IdleVillagers` | — | public |
| 366 | `MissionZero_IdleLessonTrigger` | `goalSequence` | public |
| 381 | `Predicate_IdleVillagerSelected` | `goal` | public |
| 411 | `Predicate_SelectedVillagerNotIdle` | `goal` | public |
| 423 | `Tutorials_MissionZero_HighlightMill` | — | public |
| 476 | `MissionZero_MillLessonTrigger` | `goalSequence` | public |
| 486 | `Predicate_MillPlaced` | `goal` | public |
| 492 | `IgnorePredicate_MillBuilt` | `goalSequence` | public |
| 511 | `Tutorials_MissionZero_GatherWood` | — | public |
| 553 | `MissionZero_GatherWoodTrigger` | `goalSequence` | public |
| 564 | `Predicate_AVillagerIsGatheringWood` | `goal` | public |
| 568 | `IgnorePredicate_WoodGathered` | `goalSequence` | public |
| 578 | `Tutorials_MissionZero_HighlightLumberCamp` | — | public |
| 629 | `MissionZero_LumberLessonTrigger` | `goalSequence` | public |
| 640 | `Predicate_LumberCampPlaced` | `goal` | public |
| 647 | `IgnorePredicate_LumberBuilt` | `goalSequence` | public |
| 665 | `Tutorials_MissionZero_HighlightHouses` | — | public |
| 718 | `MissionZero_HouseLessonTrigger` | `goalSequence` | public |
| 728 | `Predicate_HousePlaced` | `goal` | public |
| 739 | `IgnorePredicate_HousesBuilt` | `goalSequence` | public |
| 760 | `Tutorials_MissionZero_HighlightFarm` | — | public |
| 811 | `MissionZero_FarmLessonTrigger` | `goalSequence` | public |
| 860 | `Predicate_FarmPlaced` | `goal` | public |
| 867 | `IgnorePredicate_FarmsBuilt` | `goalSequence` | public |
| 887 | `Tutorials_MissionZero_BuildHouseIncreasePopCap` | — | public |
| 939 | `MissionZero_PopCapTrigger` | `goalSequence` | public |
| 965 | `Predicate_HasEnoughPopCap` | `goal` | public |
| 976 | `IgnorePredicate_PopCapLessonLearned` | `goalSequence` | public |
| 987 | `Tutorials_MissionZero_HighlightScout` | — | public |
| 1028 | `MissionZero_ScoutLessonTrigger` | `goalSequence` | public |
| 1038 | `Predicate_ScoutBuilt` | `goal` | public |
| 1045 | `IgnorePredicate_ScoutBuilt` | `goalSequence` | public |
| 1063 | `Tutorials_MissionZero_HighlightMine` | — | public |
| 1114 | `MissionZero_MineLessonTrigger` | `goalSequence` | public |
| 1125 | `Predicate_MinePlaced` | `goal` | public |
| 1133 | `IgnorePredicate_MineBuilt` | `goalSequence` | public |
| 1150 | `Tutorials_MissionZero_GatherGold` | — | public |
| 1192 | `MissionZero_GatherGoldTrigger` | `goalSequence` | public |
| 1203 | `Predicate_AVillagerIsGatheringGold` | `goal` | public |
| 1207 | `IgnorePredicate_GoldGathered` | `goalSequence` | public |
| 1215 | `Tutorials_MissionZero_HighlightAgeUp` | — | public |
| 1268 | `MissionZero_AgeUpFeudalTrigger` | `goalSequence` | public |
| 1278 | `Predicate_FeudalLandmarkBeingPlaced` | `goal` | public |
| 1286 | `Predicate_FeudalLandmarkPlaced` | `goal` | public |
| 1293 | `IgnorePredicate_AgeUpFeudalBuilt` | `goalSequence` | public |
| 1305 | `Tutorials_MissionZero_HighlightBarracks` | — | public |
| 1335 | `UserHasSelectedAVillagerBarracks_MissionZero` | `goalSequence` | public |
| 1347 | `Predicate_BarracksBuilt` | `goal` | public |
| 1354 | `IgnorePredicate_BarracksBuilt` | `goalSequence` | public |
| 1369 | `Tutorials_MissionZero_HighlightSpearman` | — | public |
| 1404 | `UserHasSelectedTCForSpearman_MissionZero` | `goalSequence` | public |
| 1415 | `Predicate_BarracksSelected` | `goal` | public |
| 1419 | `Predicate_SpearmanBuilt` | `goal` | public |
| 1426 | `IgnorePredicate_SpearmanBuilt` | `goalSequence` | public |
| 1442 | `Tutorials_MissionZero_ControlGroups` | — | public |
| 1505 | `MissionZero_ControlGroups_Trigger` | `goalSequence` | public |
| 1557 | `MissionZero_ControlGroupSelectedCallback` | `controlGroupIndex` | public |
| 1569 | `Predicate_ControlGroup1IsPopulated` | `goal` | public |
| 1573 | `Predicate_ControlGroup1Clicked` | `goal` | public |
| 1577 | `IgnorePredicate_ControlGroupsLessonComplete` | `goalSequence` | public |
| 1588 | `MissionZero_DoesUserHaveControlGroup` | `index` | public |
| 1618 | `Tutorials_MissionZero_AttackPalisade` | — | public |
| 1664 | `MissionZero_AttackLessonTrigger` | `goalSequence` | public |
| 1693 | `ListenForAttack` | `context` | public |
| 1702 | `Predicate_SpearmanSelected` | `goal` | public |
| 1709 | `Predicate_SpearmanAttacking` | `goal` | public |
| 1714 | `IgnorePredicate_AttackUsed` | `goalSequence` | public |
| 1738 | `Tutorials_MissionZero_AttackMove` | — | public |
| 1806 | `SpearmenAreAttackMoving` | `goal` | public |
| 1827 | `UserHasSpearmenOnScreen` | `goalSequence` | public |
| 1862 | `Predicate_SpearmenSelected` | `goal` | public |
| 1870 | `IgnorePredicate_AttackMoveUsed` | `goalSequence` | public |
| 1893 | `Tutorials_MissionZero_HighlightStables` | — | public |
| 1923 | `UserHasSelectedAVillagerStables_MissionZero` | `goalSequence` | public |
| 1934 | `Predicate_StablesBuilt` | `goal` | public |
| 1947 | `IgnorePredicate_StablesBuilt` | `goalSequence` | public |
| 1962 | `Tutorials_MissionZero_BuildCavalry` | — | public |
| 2021 | `UserHasStablesSelected` | `goal` | public |
| 2026 | `ListenForRallyPoint` | `context` | public |
| 2036 | `UserHasSetRallyPoint` | `goal` | public |
| 2043 | `UserHasQueuedAcrossStables` | `goal` | public |
| 2050 | `UserHasStablesOnScreen` | `goalSequence` | public |
| 2069 | `IgnoreAllHorsemenBuilt` | `goalSequence` | public |
| 2086 | `Tutorials_MissionZero_HighlightArcheryRange` | — | public |
| 2116 | `UserHasSelectedAVillagerArcheryRange_MissionZero` | `goalSequence` | public |
| 2127 | `Predicate_ArcheryRangeBuilt` | `goal` | public |
| 2140 | `IgnorePredicate_ArcheryRangeBuilt` | `goalSequence` | public |
| 2154 | `Tutorials_MissionZero_Highlightlongbowmen` | — | public |
| 2190 | `UserHasSelectedForlongbowmen_MissionZero` | `goalSequence` | public |
| 2200 | `Predicate_SelectArcheryRange` | `goal` | public |
| 2204 | `Predicate_longbowmenBuilt` | `goal` | public |
| 2211 | `IgnorePredicate_longbowmenBuilt` | `goalSequence` | public |
| 2225 | `Tutorials_MissionZero_HighlightAgeUpCastle` | — | public |
| 2255 | `UserHasSelectedAVillagerAgeUpCastle_MissionZero` | `goalSequence` | public |
| 2265 | `Predicate_AgeUpCastleBuilt` | `goal` | public |
| 2271 | `IgnorePredicate_AgeUpCastleBuilt` | `goalSequence` | public |
| 2288 | `MissionZero_Predicate_VillagerSelected` | `goal` | public |
| 2298 | `MissionZero_TrainingContructionCallback` | `blueprint, phase, queueCount` | public |
| 2331 | `MissionZero_PickConvenientVillager` | `mustBeIdle` | public |
| 2363 | `Predicate_KeyEntityBeingPlaced` | `goal` | public |
| 2375 | `Predicate_UserHasSelectedTC` | `goal` | public |
| 2382 | `MissionZero_ObjectiveIsActive` | `objective` | public |
| 2390 | `Entity_IsSelected` | `entityType` | public |
| 2417 | `Squad_IsSelected` | `squadType` | public |
| 2444 | `Player_IsConstructingEntity` | `string_entityType` | public |
| 2457 | `Player_IsProducingSquad` | `string_squadType` | public |

### scenarios\campaign\angevin\ang_chp1_hastings\ang_chp1_hastings.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 18 | `Mission_SetupPlayers` | — | public |
| 104 | `Mission_SetupVariables` | — | public |
| 237 | `Mission_SetDifficulty` | — | public |
| 256 | `Mission_Preset` | — | public |
| 307 | `Mission_Preset_PartB` | — | public |
| 352 | `Mission_Start` | — | public |
| 373 | `Mission_Start_PartB` | — | public |
| 381 | `Mission_CheckForFail` | — | public |
| 416 | `GetRecipe` | — | public |
| 842 | `Hastings_PassControlOfUnitsToPlayer` | `item, options` | public |
| 873 | `Mission_PrepOutro` | — | public |
| 952 | `Mission_OnLeaveGameMatchRequested` | — | public |
| 967 | `Hastings_MoveHarold` | — | public |
| 980 | `Hastings_ClearGameplayCorpses` | — | public |
| 1033 | `Hastings_SpreadUnitsAlongSpline` | `sgroup, markerTable, facing, sgroupSpecialUnits, staggerOddAndEven` | public |
| 1123 | `Hastings_ForceAttackWilliam` | — | public |

### scenarios\campaign\angevin\ang_chp1_hastings\obj_defeatsaxons.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `DefeatSaxons_InitObjectives` | — | public |
| 132 | `DefeatSaxons_InitReinforcementCounterObjective` | — | public |
| 169 | `DefeatSaxons_StartObjective` | — | public |
| 231 | `DefeatSaxons_Phase2_PreStart` | — | public |
| 240 | `DefeatSaxons_Phase2_OnStart` | — | public |
| 245 | `DefeatSaxons_Phase2_Complete` | — | public |
| 266 | `DefeatSaxons_Phase2_CleanUp` | — | public |
| 294 | `DefeatSaxons_Phase3_Start` | — | public |
| 309 | `DefeatSaxons_Phase3_Start_PartB` | — | public |
| 313 | `DefeatSaxons_Phase3_PreStart` | — | public |
| 330 | `DefeatSaxons_Phase3_OnStart` | — | public |
| 377 | `DefeatSaxons_Phase3_SetArchersUnlocked` | — | public |
| 384 | `DefeatSaxons_Phase3_NoMoreEnemyReinforcements` | — | public |
| 387 | `DefeatSaxons_Phase3_Complete` | — | public |
| 405 | `DefeatSaxons_Phase3_CleanUp` | — | public |
| 431 | `DefeatSaxons_Phase4_PreStart` | — | public |
| 455 | `DefeatSaxons_Phase4_OnStart` | — | public |
| 490 | `DefeatSaxons_Phase4_EnemySpearmenUnlocked` | — | public |
| 496 | `DefeatSaxons_Phase4_NoMoreEnemyReinforcements` | — | public |
| 499 | `DefeatSaxons_Phase4_Complete` | — | public |
| 520 | `DefeatSaxons_Phase4_CleanUp` | — | public |
| 543 | `DefeatSaxons_ActivateEnemyArchers` | `context, data` | public |
| 571 | `DefeatSaxons_ActivateEnemyArchers_DelayedHoldPosition` | `context, data` | public |
| 579 | `DefeatSaxons_Phase5_PreStart` | — | public |
| 601 | `DefeatSaxons_Phase5_OnStart` | — | public |
| 608 | `DefeatSaxons_Phase5_SetCavalryUnlocked` | — | public |
| 618 | `DefeatSaxons_Phase5_Complete` | — | public |
| 636 | `DefeatSaxons_Phase5_CleanUp` | — | public |
| 665 | `DefeatSaxons_MoveForwardAndPassControl` | `context, data` | public |
| 678 | `DefeatSaxons_PassControlWhenUnitStops` | `context, data` | public |
| 699 | `DefeatSaxons_UpdateHillDefendModules` | `context, data` | public |
| 782 | `DefeatSaxons_InitPlayerReinforcements` | — | public |
| 803 | `DefeatSaxons_SetPlayerReinforcementFocus` | `focus` | public |
| 859 | `DefeatSaxons_StartPlayerReinforcements` | — | public |
| 866 | `DefeatSaxons_PlayerReinforcements` | — | public |
| 960 | `DefeatSaxons_PlayerReinforcements_Create` | `reinforcementData` | public |
| 1069 | `DefeatSaxons_PlayerReinforcements_PassControl` | `context, data` | public |
| 1099 | `DefeatSaxons_PlayerReinforcements_MonitorForCommands` | `context, data` | public |
| 1134 | `DefeatSaxons_PlayerReinforcements_EventCueCallback` | `id` | public |
| 1150 | `SGroup_SetTargetingType` | `sgroup, targetingType` | public |
| 1166 | `DefeatSaxons_ReleaseSpearmen` | `context, data` | public |
| 1185 | `DefeatSaxons_ReleaseSpearmen_AddToModule` | `context, data` | public |
| 1213 | `DefeatSaxons_UpdateKillCounts` | `context, data` | public |
| 1238 | `DefeatSaxons_EnemyReinforcements` | `context, data` | public |
| 1416 | `DefeatSaxons_UpdateActiveUnitCounts` | — | public |
| 1432 | `BoostRPS_Add` | `player, unitType, weaponDamage, receivedDamage` | public |
| 1460 | `BoostRPS_Remove` | `boostToRemove` | public |
| 1485 | `BoostRPS_RemoveAll` | — | public |
| 1495 | `BoostRPS_Manager` | — | public |
| 1503 | `BoostRPS_Apply` | `boost` | public |

### scenarios\campaign\angevin\ang_chp1_hastings\obj_feign.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Feign_InitObjectives` | — | public |
| 71 | `Feign_StartObjective` | — | public |
| 78 | `Feign_MonitorShieldWallEngagers` | — | public |
| 85 | `Feign_HasPlayerRetreated` | — | public |
| 139 | `Feign_TriggerShieldWallBreak` | `wall, feignOrigin` | public |
| 194 | `Feign_BreakShieldWall` | `context, data` | public |
| 243 | `Feign_PlayerUnitsRunDownHill` | `context, data` | public |
| 263 | `Feign_PlayerUnitsRunDownHill_PartB` | `context, data` | public |
| 278 | `Feign_PlayerUnitsRunDownHill_PartC` | `context, data` | public |
| 285 | `Feign_BreakShieldWall_WilliamSecondLineReaction` | `context, data` | public |
| 300 | `Feign_BreakShieldWall_WilliamSecondLineReaction_SwapPlayerOwner` | `context, data` | public |
| 308 | `Feign_Complete` | — | public |
| 322 | `Feign_Complete_PartB` | — | public |

### scenarios\campaign\angevin\ang_chp1_hastings\obj_initialattack.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `InitialAttack_InitObjectives` | — | public |
| 40 | `InitialAttack_WaitForPlayerToIssueCommand` | — | public |
| 81 | `InitialAttack_WaitForPlayerToIssueCommand_PartB` | — | public |
| 87 | `InitialAttack_MoveFlanksUpHill` | `context, data` | public |
| 96 | `Hastings_StaggeredAttack` | `group, target, options` | public |
| 117 | `Hastings_StaggeredAttack_Manager` | `context, data` | public |
| 170 | `InitialAttack_MoveWilliamUpHill` | `context, data` | public |
| 177 | `InitialAttack_MoveWilliamUpHill_PartB` | `context, data` | public |
| 184 | `InitialAttack_PassControlOfUnitsToPlayer` | `context, data` | public |
| 195 | `InitialAttack_UnitsAtTopOfHill` | — | public |
| 220 | `InitialAttack_UnitsAtTopOfHill_PartB` | — | public |
| 230 | `InitialAttack_ShieldWallUnitsKilled` | — | public |
| 244 | `InitialAttack_ShieldWallUnitKilled` | — | public |
| 252 | `InitialAttack_EnableWilliamsArchers` | — | public |
| 266 | `InitialAttack_EnableWilliamsArchers_FirstVolley` | `group, target` | public |
| 276 | `InitialAttack_EnableWilliamsArchers_StopAgain` | `context, data` | public |
| 283 | `InitialAttack_EnableWilliamsArchers_Stagger` | `context, data` | public |
| 313 | `InitialAttack_StartReinforcements` | — | public |
| 383 | `InitialAttack_ReinforceShieldWall` | `context, data` | public |
| 419 | `InitialAttack_ReinforcePlayer` | `context, data` | public |
| 491 | `InitialAttack_ReinforcePlayer_SwapPlayerOwner` | `context, data` | public |
| 509 | `InitialAttack_ReinforcePlayer_SpawnReplacementUnits` | `context, data` | public |
| 532 | `UI_LaunchAttackButton_CreateUI` | — | public |
| 576 | `UI_LaunchAttackButton_SetVisible` | `visible` | public |
| 587 | `UI_LaunchAttackButton_ButtonCallback` | `parameter` | public |

### scenarios\campaign\angevin\ang_chp1_hastings\obj_killharold.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `KillHarold_InitObjectives` | — | public |
| 104 | `KillHarold_Init` | — | public |
| 131 | `KingHarold_RejoinEntourage` | — | public |
| 147 | `KingHarold_RejoinEntourage_PartB` | — | public |
| 158 | `KingHarold_SpawnLastLines` | — | public |
| 226 | `KillHarold_StartObjective` | — | public |
| 275 | `KingHarold_PreStart` | — | public |
| 363 | `KingHarold_ManageStrikers` | — | public |
| 491 | `KillHarold_MonitorModules` | — | public |
| 523 | `KillHarold_CloseInOnHarold` | — | public |
| 592 | `KillHarold_Killed` | — | public |
| 652 | `KillHarold_StartEpilogue` | — | public |
| 659 | `KillHarold_RunAway` | — | public |
| 737 | `KillHarold_MissionEnd` | — | public |

### scenarios\campaign\angevin\ang_chp1_hastings\shieldwall_hastings.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 24 | `ShieldWall_Create` | `posA, posB, units, specialUnitsPerRow, immediate, name` | public |
| 218 | `ShieldWall_Release` | `data` | public |
| 240 | `ShieldWall_AddSGroup` | `data, sgroup` | public |
| 271 | `ShieldWall_WallUnitInPositon` | `context, data` | public |
| 319 | `ShieldWall_WallUnitKilled` | `context, data` | public |
| 424 | `ShieldWall_WallUnit_HoldGround` | `unit` | public |
| 456 | `ShieldWall_WallUnit_HoldGround_Release` | `unit` | public |

### scenarios\campaign\angevin\ang_chp1_hastings\training_hastings.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `MissionTutorial_Init` | — | public |
| 36 | `MissionTutorial_AddHintToLeaderAbility_Xbox` | — | public |
| 88 | `MissionTutorial_AddHintToLeaderAbility` | — | public |
| 129 | `Predicate_UserHasSelectedWilliam` | `goal` | public |
| 136 | `Predicate_UserHasLookedAtWilliamsAbility` | `goal` | public |
| 143 | `Predicate_UserHasNotActivatedWilliamsLeaderAbilityRecently` | `goalSequence` | public |
| 155 | `MissionTutorial_AddHintToLeaderRevive` | — | public |
| 187 | `Predicate_WilliamHasBeenRevived` | `goal` | public |
| 194 | `Predicate_WilliamHasBeenInjured` | `goalSequence` | public |
| 211 | `MissionTutorial_AddHintToSelectAll` | — | public |
| 238 | `Predicate_UserHasAllOnScreenUnitsSelected` | — | public |
| 285 | `Predicate_UserDoesNotHaveAllOnScreenUnitsSelected` | `goalSequence` | public |
| 308 | `MissionTutorial_AddHintToArchers` | — | public |
| 349 | `Predicate_UserHasAnyArchersSelected` | `goal` | public |
| 352 | `Predicate_AreArchersAttackMoving` | `goal` | public |
| 363 | `Predicate_UserHasNotSelectedArchersRecently` | `goalSequence` | public |
| 374 | `Predicate_IsTaggedArcherStillAlive` | `goalSequence` | public |
| 392 | `MissionTutorial_AddHintToEnemySpearmen` | — | public |
| 424 | `Predicate_EnemySpearmenAreOnTheField` | `goalSequence` | public |
| 439 | `MissionTutorial_AddHintToCavalry` | — | public |
| 471 | `Predicate_UserHasAnyCavalrySelected` | `goal` | public |
| 474 | `Predicate_UserHasNotSelectedCavalryRecently` | `goalSequence` | public |

### scenarios\campaign\angevin\ang_chp1_york\ang_chp1_york_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `York_Data_Init` | — | public |
| 301 | `GetRecipe` | — | public |

### scenarios\campaign\angevin\ang_chp1_york\ang_chp1_york.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 21 | `Mission_SetupPlayers` | — | public |
| 102 | `Mission_PreInit` | — | public |
| 107 | `Mission_SetupVariables` | — | public |
| 112 | `Mission_SetRestrictions` | — | public |
| 166 | `Mission_SetDifficulty` | — | public |
| 192 | `Mission_Preset` | — | public |
| 260 | `Mission_Start` | — | public |
| 291 | `York_TransitionOutroLight` | — | public |
| 296 | `Mission_OnTributeSent` | `tribute` | public |
| 320 | `York_SetPopulationCapVisibility` | `visibility` | public |
| 330 | `York_InitPlayerUnits` | — | public |
| 338 | `York_InitEnemyUnits` | — | public |
| 367 | `York_DeployOuterGuard` | `player, unitType, numSquads, marker, sgroup, sgroupMaster` | public |
| 373 | `York_MoveStartingUnits` | — | public |
| 402 | `York_CheckMissionFail` | — | public |
| 428 | `York_OnConstructionComplete` | `context` | public |
| 501 | `York_FindPalisadeBastion` | — | public |
| 525 | `York_AddPatrolTargets` | — | public |
| 538 | `York_DefendTheKeep` | — | public |
| 550 | `York_UpdatePatrolTargets` | — | public |
| 569 | `York_AddFinalRebelTargets` | — | public |
| 596 | `York_OnRiverWithdraw` | — | public |
| 603 | `York_StopEarlyRaiders` | — | public |
| 613 | `York_SpawnEarlyRaiders` | — | public |
| 658 | `York_SpawnDaneGold` | — | public |
| 682 | `York_SetDaneGoldValue` | `egroup, value` | public |
| 690 | `York_SpawnDaneRaiders` | — | public |
| 725 | `York_TriggerDaneTravel` | — | public |
| 744 | `York_StartCheckInitDaneRaid` | — | public |
| 750 | `York_CheckInitDaneRaid` | — | public |
| 765 | `York_CheckFulfordTC` | — | public |
| 786 | `York_TestDisableWeaponOnTC` | — | public |
| 803 | `York_TestMiddlethorpe` | — | public |
| 812 | `York_TestFulford` | — | public |
| 820 | `York_TestDanes` | — | public |
| 827 | `York_StartInitialDaneRaid` | — | public |
| 841 | `York_SpawnDaneAttackers1` | — | public |
| 849 | `York_SpawnDaneAttackers2` | — | public |
| 857 | `York_SpawnDaneAttackers3` | — | public |
| 865 | `York_CheckDaneArrival` | — | public |
| 896 | `York_TriggerDaneWithdraw` | — | public |
| 912 | `York_CheckDaneWithdraw` | — | public |
| 929 | `York_SetControlGroup` | `data, index` | public |
| 950 | `York_OnEntityKilled` | `context` | public |
| 969 | `York_CompleteInitialDaneRaid` | — | public |
| 989 | `York_AddPalisadeTraining` | — | public |
| 993 | `York_CheckDaneCampReveal` | — | public |
| 1012 | `York_CheckDaneCampLooted` | — | public |
| 1023 | `York_MergeDaneLine1` | — | public |
| 1027 | `York_CheckDaneCampEntry` | — | public |
| 1037 | `York_PlayerInDaneCamp` | — | public |
| 1046 | `York_RaidersInDaneCamp` | — | public |
| 1056 | `York_CheckBridgeTriggers` | — | public |
| 1070 | `York_CheckMiddlethorpeTrigger` | — | public |
| 1087 | `York_MergeMiddlethorpeOuterGuard` | — | public |
| 1091 | `York_CheckFulfordTrigger` | — | public |
| 1112 | `York_MergeFulfordOuterGuard` | — | public |
| 1116 | `York_CheckKeepTrigger` | — | public |
| 1141 | `York_CheckKeepDefendTrigger` | — | public |
| 1170 | `York_CheckReactionScout` | — | public |
| 1177 | `York_TriggerReactionScout` | — | public |
| 1181 | `York_ShowTributeMenu` | — | public |
| 1194 | `York_HideTributeMenu` | — | public |
| 1200 | `York_SpawnReinforcements` | `units, sgroup, spawn, destination, onClickEvent` | public |
| 1230 | `York_DisplayPopcapCue` | — | public |
| 1235 | `York_MoveReinforcements` | `context, data` | public |
| 1242 | `York_PlayCheerWhenReinforcementsAreSeen` | `context, data` | public |
| 1249 | `York_PlayWallaCelebrate` | `sgroup` | public |
| 1265 | `York_PlayWallaFear` | `sgroup` | public |
| 1281 | `York_PlayWallaEngage` | `sgroup` | public |
| 1298 | `York_PauseMusic` | `delay, restartFunction` | public |
| 1304 | `York_RestartMusic` | — | public |
| 1310 | `York_RestartMusicNoMin` | — | public |
| 1315 | `York_CheckKeepRepair` | — | public |
| 1343 | `York_StopRebels` | — | public |
| 1352 | `York_ReinforceRebels` | — | public |
| 1369 | `York_CheckWave` | `wave, data` | public |
| 1396 | `York_GetRebelVillagerCount` | — | public |
| 1405 | `York_SetUpOutro` | — | public |

### scenarios\campaign\angevin\ang_chp1_york\diplomacy_chp1_york.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Diplomacy_DiplomacyEnabled` | `is_enabled` | public |
| 118 | `Diplomacy_TributeEnabled` | `is_enabled` | public |
| 126 | `Diplomacy_OnInit` | — | public |
| 133 | `Diplomacy_Start` | — | public |
| 155 | `Diplomacy_OnGameOver` | — | public |
| 163 | `Diplomacy_OnGameRestore` | — | public |
| 174 | `Diplomacy_ToggleDiplomacyUI` | — | public |
| 193 | `Diplomacy_ShowDiplomacyUI` | `show` | public |
| 200 | `Diplomacy_HideDiplomacyUI` | `context` | public |
| 208 | `Diplomacy_ChangeRelation` | `parameter` | public |
| 214 | `Diplomacy_IncreaseTribute` | `parameter` | public |
| 225 | `Diplomacy_DecreaseTribute` | `parameter` | public |
| 236 | `Diplomacy_ClearTribute` | — | public |
| 249 | `Diplomacy_SendTribute` | — | public |
| 268 | `Diplomacy_ShowUI` | `show` | public |
| 282 | `Diplomacy_OnRelationshipChanged` | `observerPlayerID, targetPlayerID, show_notification` | public |
| 325 | `Diplomacy_OnConstructionComplete` | `context` | public |
| 341 | `Diplomacy_OnPlayerDefeated` | `player, reason` | public |
| 365 | `Diplomacy_OnPlayerNameChanged` | `context` | public |
| 377 | `Diplomacy_OnUpgradeComplete` | `context` | public |
| 398 | `Diplomacy_UpdateDataContext` | — | public |
| 495 | `Diplomacy_UpdateNameColours` | — | public |
| 511 | `Diplomacy_OverridePlayerSettings` | `playerID, is_player_visible, is_tribute_visible, is_food_enabled, is_wood_enabled, is_gold_enabled, is_stone_enabled` | public |
| 529 | `Diplomacy_OverrideSettings` | `is_tribute_enabled, is_subtotal_visible, is_score_visible, is_team_visible` | public |
| 540 | `Diplomacy_RelationConverter` | `relation` | public |
| 562 | `Diplomacy_RelationToTooltipConverter` | `observer, target` | public |
| 586 | `Diplomacy_GetTaxRate` | `playerID` | public |
| 592 | `Diplomacy_SetTaxRate` | `playerID, tax_rate` | public |
| 599 | `Diplomacy_AddTribute` | `player_index, resource_index, amount` | public |
| 635 | `Diplomacy_CreateDataContext` | — | public |
| 716 | `Diplomacy_FormatTeamNumber` | `team_number` | public |
| 725 | `Diplomacy_SortDataContext` | — | public |
| 738 | `Diplomacy_CreateUI` | — | public |
| 1125 | `Diplomacy_RemoveUI` | — | public |
| 1134 | `Diplomacy_UpdateUI` | — | public |
| 1141 | `Rule_Diplomacy_UpdateUI` | — | public |
| 1148 | `Diplomacy_Restart` | — | public |
| 1155 | `Diplomacy_ShowEventCue` | `tribute` | public |
| 1183 | `Diplomacy_ChangeRelationNtw` | `playerID, data` | public |
| 1198 | `Diplomacy_SendTributeNtw` | `playerID, data` | public |

### scenarios\campaign\angevin\ang_chp1_york\obj_capture_locations.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `CaptureLocations_InitMiddlethorpe` | — | public |
| 68 | `CaptureLocations_InitFulford` | — | public |

### scenarios\campaign\angevin\ang_chp1_york\obj_defeat_danes.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `RepelAttack_TimerComplete` | — | public |
| 14 | `DefeatDanes_InitObjectives` | — | public |
| 129 | `DefeatDanes_OnSquadKilled` | `context` | public |
| 152 | `StopDaneRaids_Complete` | — | public |
| 162 | `PayTribute_Start` | — | public |
| 172 | `PayTribute_Complete` | — | public |
| 189 | `DefeatDanes_CheckBuildings` | — | public |
| 221 | `York_PlayDaneRaidSounds` | — | public |

### scenarios\campaign\angevin\ang_chp1_york\obj_develop.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Develop_InitObjectives` | — | public |
| 66 | `Develop_StartFulford` | — | public |
| 71 | `Develop_CheckGathering` | — | public |

### scenarios\campaign\angevin\ang_chp1_york\obj_reclaim.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Reclaim_InitObjectives` | — | public |
| 54 | `ReclaimYork_PreStart` | — | public |
| 59 | `ReclaimYork_Start` | — | public |
| 63 | `BreachGates_Complete` | — | public |
| 73 | `BreachGates_Start` | — | public |
| 82 | `DestroyKeep_Start` | — | public |
| 92 | `Reclaim_OnEntityKilled` | `context` | public |
| 106 | `Reclaim_CheckKeep` | — | public |
| 118 | `Reclaim_Complete` | — | public |
| 136 | `Reclaim_StartOutro` | — | public |
| 140 | `Reclaim_DestroyKeep` | — | public |

### scenarios\campaign\angevin\ang_chp1_york\obj_strengthen.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Strengthen_InitObjectives` | — | public |

### scenarios\campaign\angevin\ang_chp1_york\training_york.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 26 | `TrainingGoal_EnableCampaignEconGoals` | — | public |
| 32 | `TrainingGoal_DisableCampaignEconGoals` | — | public |
| 38 | `UserHasEnoughVillagersGatheringFood` | `goal` | public |
| 43 | `ShouldPromptUserToGatherMoreFood` | `goalSequence` | public |
| 65 | `FoodTargetValid` | `goalSequence` | public |
| 82 | `ShouldContinuePromptingUserToGatherMoreFood` | `goalSequence` | public |
| 87 | `UserHasEnoughBarracks` | `goalSequence` | public |
| 93 | `UserShouldBuildPalisade` | `goalSequence` | public |
| 111 | `UserShouldBuildMoreBarracks_Xbox` | `goalSequence` | public |
| 136 | `UserShouldBuildMoreBarracks` | `goalSequence` | public |
| 160 | `UserShouldBuildMoreBarracksAndTimeHasPassed` | `goalSequence` | public |
| 168 | `TrainingGoal_AddStopAttacking` | — | public |
| 185 | `BuildingAttacked` | `goalSequence` | public |
| 216 | `AttackTargetIsInvalid` | `goalSequence` | public |
| 248 | `UserHasAnEntitySelected` | `goal` | public |
| 253 | `UserHasStoppedAttacking` | `goal` | public |
| 273 | `TrainingGoal_AddGatherFood` | — | public |
| 289 | `TrainingGoal_AddBuildPalisade` | — | public |
| 306 | `TrainingGoal_AddBuildBarracks_Xbox` | — | public |
| 359 | `TrainingGoal_AddBuildBarracks` | — | public |
| 382 | `TrainingGoal_AddBuildWonder_Xbox` | — | public |
| 425 | `York_LM_openRadialIsComplete` | `goal` | public |
| 432 | `TrainingGoal_AddBuildWonder` | — | public |
| 455 | `UserIsBuildingOrHasBuiltBarracks` | — | public |
| 462 | `UserCannotBuildAWonder` | `goalSequence` | public |
| 478 | `UserHasBuiltPalisade` | `goalSequence` | public |
| 485 | `UserHasBuiltPalisadeOrTimeHasPassed` | `goalSequence` | public |
| 492 | `TargetNotValid` | `goalSequence` | public |
| 511 | `UserCannotBuildABarracks` | `goalSequence` | public |
| 530 | `TrainingGoal_EnableBuildLandmark` | — | public |
| 534 | `TrainingGoal_EnableBuildPalisade` | — | public |
| 538 | `TrainingGoal_DisableBuildPalisade` | — | public |
| 542 | `TrainingGoal_EnableBuildBarracks` | — | public |
| 546 | `TrainingGoal_DisableBuildBarracks` | — | public |
| 550 | `UserHasOpenedTheDiplomacyMenu` | — | public |
| 557 | `ShouldPromptUserToSendGold` | `goalSequence` | public |
| 573 | `TrainingGoal_AddSendGold` | — | public |
| 588 | `TrainingGoal_EnableSendGold` | — | public |
| 592 | `TrainingGoal_DisableSendGold` | — | public |

### scenarios\campaign\angevin\ang_chp2_bayeux\ang_chp2_bayeux.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupPlayers` | — | public |
| 54 | `Mission_SetupVariables` | — | public |
| 181 | `Mission_SetDifficulty` | — | public |
| 214 | `Mission_SetRestrictions` | — | public |
| 242 | `Mission_Preset` | — | public |
| 291 | `Mission_PreStart` | — | public |
| 297 | `Mission_Start` | — | public |
| 328 | `GetRecipe` | — | public |
| 470 | `HintPoint_Cavalry` | — | public |
| 493 | `Reinforce_Archers` | `markerSpawn, markerDestination, cta_bool` | public |
| 532 | `Cavalry_Cleared` | — | public |
| 543 | `UpdateCavalry` | — | public |
| 549 | `Init_Cavalry_Attackwave` | — | public |
| 574 | `Init_Cavalry_Defenders` | — | public |
| 609 | `Init_Archer_Defenders` | — | public |
| 633 | `ClearArchers` | — | public |
| 647 | `Init_Infantry_Defenders` | — | public |
| 672 | `Init_Infantry_Extra_Defenders` | — | public |
| 710 | `Clear_ExtraDefenders` | — | public |
| 742 | `Advance_OnEntityKilled` | `context` | public |
| 771 | `Advance_OnEntityDamage` | `context` | public |
| 809 | `Dissolve_WithdrawnCavalry` | — | public |
| 822 | `resetDefenders` | — | public |
| 826 | `BayeuxBurning` | — | public |
| 840 | `PushWhenNeeded` | — | public |
| 856 | `DissolveInArchers` | — | public |
| 887 | `WallDie` | — | public |
| 894 | `PlayerDeath_PreTown` | — | public |
| 903 | `PlayerDeath_PostTown` | — | public |
| 913 | `IdleAttack` | — | public |
| 952 | `NewAtackerGroup` | `target` | public |
| 980 | `IdlePoke_IsDead` | `context, data` | public |
| 992 | `IdleAttack_DeadIntel` | — | public |
| 996 | `PushAttack` | — | public |
| 1027 | `PlayerRush` | — | public |
| 1042 | `VillagerFlee` | — | public |
| 1057 | `TowerDeathAudio` | — | public |
| 1070 | `AudOnFromPoint` | `player, pos, audString` | public |
| 1094 | `CleanUp_Cavalry` | — | public |
| 1107 | `ShowBayeuxHealth` | — | public |

### scenarios\campaign\angevin\ang_chp2_bayeux\obj_capturewood.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `CaptureVillage_InitObjectives` | — | public |
| 61 | `CaptureVillage_Start` | — | public |
| 65 | `CaptureVillage_PreStart` | — | public |
| 70 | `DefeatHamletRebels_PreStart` | — | public |
| 76 | `CaptureVillage_IsComplete` | — | public |
| 85 | `CaptureVillage_PreComplete` | — | public |
| 95 | `CaptureVillage_OnComplete` | — | public |
| 141 | `CaptureVillage_IsFailed` | — | public |
| 150 | `CaptureVillage_OnFail` | — | public |

### scenarios\campaign\angevin\ang_chp2_bayeux\obj_controlgroups.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `ControlGroup_InitObjectives` | — | public |
| 49 | `ControlGroup_Check` | — | public |
| 60 | `ControlGroups_IsComplete` | — | public |
| 64 | `CGArchers_IsComplete` | — | public |
| 78 | `CGSpears_IsComplete` | — | public |

### scenarios\campaign\angevin\ang_chp2_bayeux\obj_destroy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Destroy_InitObjectives` | — | public |
| 226 | `Destroy_OnStart` | — | public |
| 245 | `Destroy_IsComplete` | — | public |
| 251 | `Destroy_OnComplete` | — | public |
| 255 | `Defenders_SetupUI` | — | public |
| 266 | `Rams_OnStart` | — | public |
| 270 | `Blacksmith_IsComplete` | — | public |
| 277 | `Blacksmith_OnComplete` | — | public |
| 282 | `SiegeEngineer_OnStart` | — | public |
| 290 | `SiegeEngineer_IsComplete` | — | public |
| 294 | `SiegeEngineer_OnComplete` | — | public |
| 299 | `BuildSiege_OnStart` | — | public |
| 303 | `BuildSiege_IsComplete` | — | public |
| 332 | `Rams_IsComplete` | — | public |
| 338 | `Rams_OnComplete` | — | public |
| 347 | `Breach_SetupUI` | — | public |
| 351 | `Breach_OnComplete` | — | public |
| 355 | `Bayeux_Walls_Spotted` | — | public |
| 365 | `Bayeux_Gate_Spotted` | — | public |
| 373 | `Defenders_Track` | — | public |

### scenarios\campaign\angevin\ang_chp2_bayeux\training_bayeux.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 22 | `MissionTutorial_Init` | — | public |
| 27 | `Ram_TutorialBranch` | — | public |
| 55 | `MissionTutorial_Palings` | — | public |
| 65 | `Palings_TriggerPredicate` | `goalSequence` | public |
| 83 | `Palings_BypassPredicate` | `goalSequence` | public |
| 87 | `Palings_ArcherIsSelected` | `goal` | public |
| 98 | `Palings_PalingsUsed` | `goal` | public |
| 153 | `MissionTutorial_AttackMove` | — | public |
| 163 | `AttackMove_TriggerPredicate` | `goalSequence` | public |
| 178 | `AttackMove_UnitsSelected` | `goal` | public |
| 193 | `Query_AttackMoving` | `gid, index, sid` | public |
| 199 | `AttackMove_AttackMoveUsed` | `goal` | public |
| 211 | `MissionTutorial_HeightAdvantage` | — | public |
| 240 | `Predicate_UserIsNotUsingHeightInCombat` | `goalSequence` | public |
| 270 | `MissionTutorial_Blacksmith` | — | public |
| 322 | `Blacksmith_TriggerPredicate` | `goalSequence` | public |
| 336 | `Blacksmith_VillagerIsSelected` | `goal` | public |
| 346 | `Blacksmith_UserHasOpenedContextualRadial` | `goal` | public |
| 351 | `Blacksmith_UserHasOpenedDPadRightRadial` | `goal` | public |
| 356 | `Blacksmith_PlayerIsGoingToBuild` | `goal` | public |
| 360 | `Blacksmith_IsBuilt` | `goal` | public |
| 366 | `Blacksmith_BlacksmithExists` | `goalSequence` | public |
| 375 | `MissionTutorial_SiegeEngineer_Xbox` | — | public |
| 421 | `MissionTutorial_SiegeEngineer` | — | public |
| 433 | `SiegeEngineer_UserHasOpenedBlacksmithRadial` | `goal` | public |
| 444 | `SiegeEngineer_TriggerPredicate_Xbox` | `goalSequence` | public |
| 460 | `SiegeEngineer_TriggerPredicate` | `goalSequence` | public |
| 475 | `SiegeEngineer_BlacksmithIsSelected` | `goal` | public |
| 485 | `SiegeEngineer_HasUpgrade` | `goal` | public |
| 508 | `SiegeEngineer_BypassPredicate` | `goalSequence` | public |
| 515 | `MissionTutorial_Ram` | — | public |
| 556 | `Rams_TriggerPredicate` | `goalSequence` | public |
| 569 | `Rams_UnitsSelected` | `goal` | public |
| 581 | `Rams_RamsBuilt` | `goal` | public |
| 588 | `IsRadialOpen` | `goal` | public |
| 595 | `IsMilitaryPageOpen` | `goal` | public |

### scenarios\campaign\angevin\ang_chp2_bremule\ang_chp2_bremule.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 21 | `Mission_SetupPlayers` | — | public |
| 68 | `Mission_SetupVariables` | — | public |
| 159 | `Mission_SetDifficulty` | — | public |
| 211 | `Mission_SetRestrictions` | — | public |
| 219 | `Mission_Preset` | — | public |
| 252 | `Mission_Start` | — | public |
| 271 | `GetRecipe` | — | public |
| 434 | `Init_Hunting_RovingArmy` | — | public |
| 457 | `Init_FrenchWaves` | — | public |
| 478 | `ThreatArrow_SpottedHuntingArmy` | — | public |
| 502 | `HuntingArrow_On` | — | public |
| 510 | `HuntingArrow_Off` | — | public |
| 517 | `UpdateWaveTarget` | — | public |
| 596 | `Set_HuntingReinforcements` | — | public |
| 606 | `Spawn_HuntingReinforcements` | — | public |
| 622 | `Reset_HuntingTargets` | — | public |
| 630 | `Hunting_Intel` | — | public |
| 637 | `RovingLastPosition` | — | public |
| 648 | `Init_Ram_RovingArmy` | — | public |
| 671 | `StartRamTimer` | — | public |
| 675 | `SiegeCamp_TimerMod` | — | public |
| 683 | `ConstructWave` | — | public |
| 734 | `Reset_RamWave` | — | public |
| 749 | `Siege_LaunchPoint` | — | public |
| 762 | `Siege_Targets` | — | public |
| 787 | `NewScoutsDescriptor` | — | public |
| 793 | `NewScoutGroup` | — | public |
| 833 | `Delay_ScoutSpawn` | — | public |
| 838 | `NewSingleScout` | — | public |
| 876 | `Init_FrenchAssault` | — | public |
| 1006 | `Init_FrenchBackfill` | — | public |
| 1043 | `AmbushSpawn` | — | public |
| 1072 | `SetPriorityTargets` | — | public |
| 1084 | `EnglishPushBack` | — | public |
| 1092 | `VillagersReinforce` | `amount, area` | public |
| 1099 | `LockAllUpgrades` | `player` | public |
| 1113 | `Build_LocationTable` | `egroup` | public |
| 1131 | `Rebuild_Location` | `locationTable, rebuilderGroup, locationToRebuild` | public |
| 1135 | `Rebuild_Location_Delayed` | `context, data` | public |
| 1180 | `ConstructCamp` | — | public |
| 1187 | `LiquidateLouisArmy` | — | public |
| 1199 | `EnsureCampArrival` | — | public |
| 1208 | `Pre_BreakForCamp` | — | public |
| 1213 | `DelaySetUpTent` | — | public |
| 1223 | `SetUpTent` | — | public |
| 1284 | `PatrolCamp` | `context, data` | public |
| 1297 | `CombatWatch` | — | public |
| 1310 | `RestartCamp` | — | public |
| 1325 | `CampShutDown` | `modifier, sgroupTable, rule` | public |
| 1340 | `HangOut` | `sgroup, marker` | public |
| 1360 | `Init_Camp_Defense_Encounter` | — | public |
| 1376 | `Reset_Camp` | — | public |
| 1382 | `AmbushCamp` | — | public |
| 1393 | `VillagerSetup` | — | public |
| 1423 | `Init_VillagerLife_Cressenville` | — | public |
| 1431 | `Init_VillagerLife_Grainville` | — | public |
| 1441 | `AudOnFromPoint` | `player, pos, audString` | public |
| 1464 | `Louis_Weakened` | — | public |
| 1474 | `Grainville_Loot` | — | public |
| 1485 | `Cressenville_Loot` | — | public |
| 1496 | `StandPretty` | `idleSgroup` | public |
| 1503 | `Toggle_BuildingCombatOn_Cressenville` | — | public |
| 1507 | `Toggle_BuildingCombatOn_Grainville` | — | public |
| 1515 | `Bremule_Intro_Parade` | — | public |
| 1576 | `Bremule_SkippedIntro` | — | public |
| 1601 | `French_IntroSpawn` | — | public |
| 1698 | `French_Louis_Move` | — | public |
| 1710 | `Spearmen_Move` | — | public |
| 1722 | `Scout_Move` | — | public |
| 1728 | `Louis_Speech` | — | public |
| 1739 | `PlayerDeath` | — | public |
| 1774 | `GameOver` | — | public |
| 1786 | `Unusual_Discovery` | — | public |
| 1795 | `Discovery_Result` | — | public |

### scenarios\campaign\angevin\ang_chp2_bremule\obj_defeatthefrench.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `DefeatTheFrench_InitObjectives` | — | public |
| 34 | `DeafeattheFrench_Start` | — | public |
| 44 | `DeafeattheFrench_IsComplete` | — | public |
| 52 | `DeafeattheFrench_Complete` | — | public |
| 62 | `CountFrench` | — | public |

### scenarios\campaign\angevin\ang_chp2_bremule\obj_frenchadvance.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `FrenchAdvance_InitObjectives` | — | public |
| 87 | `FrenchAdvance_IsComplete` | — | public |
| 102 | `FrenchAdvance_OnStart` | — | public |
| 116 | `FrenchAdvance_OnComplete` | — | public |
| 141 | `HoldingFleury_OnStart` | — | public |
| 145 | `ClearFleury_IsComplete` | — | public |
| 160 | `ClearFleury_PreComplete` | — | public |
| 164 | `FleuryObjective_InitialUpdate` | — | public |
| 175 | `IsFlueryClear` | — | public |
| 188 | `FrenchArrival` | `context, data` | public |
| 230 | `Check_GroupsArrived` | — | public |
| 237 | `Rules_Delay` | — | public |
| 245 | `Transfer_Defenders` | `transferFrom, transferTo, transferPercent, exceptionSgroup` | public |
| 276 | `SpinUp_CounterAttack` | `name, target, percent` | public |
| 312 | `KingHenry_Reinforcements` | — | public |
| 346 | `FrenchNotify` | — | public |
| 353 | `CheckCaptures` | — | public |
| 377 | `RecapturesComplete` | — | public |
| 386 | `RecaptureEvent` | — | public |
| 397 | `Music_SetIntense` | — | public |
| 402 | `GateBreach` | — | public |
| 419 | `OnCapture_CancelProductionQueue` | `townMarker` | public |
| 433 | `Bremule_ChangeBurningFarmsteadOwnership` | — | public |

### scenarios\campaign\angevin\ang_chp2_bremule\obj_funckeys.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `FuncKeys_InitObjectives_Xbox` | — | public |
| 44 | `FuncKeys_InitObjectives` | — | public |
| 92 | `FuncKeys_IsComplete` | — | public |
| 96 | `Egroup_FuncGroupSelected` | `buildingType` | public |
| 106 | `F1_IsComplete` | — | public |
| 110 | `F2_IsComplete` | — | public |
| 114 | `F3_IsComplete` | — | public |
| 118 | `F4_IsComplete` | — | public |

### scenarios\campaign\angevin\ang_chp2_bremule\obj_recaptures.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `Recapture_InitObjectives` | — | public |

### scenarios\campaign\angevin\ang_chp2_bremule\obj_retakecressenville.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `CaptureCressenville_InitObjectives` | — | public |
| 39 | `CaptureCressenville_Start` | — | public |
| 45 | `CaptureCressenville_PreComplete` | — | public |
| 54 | `CaptureCressenville_Complete` | — | public |
| 76 | `Cressenville_Delayed_Counterattack` | — | public |
| 80 | `DefeatCressenvilleRebels_Start` | — | public |

### scenarios\campaign\angevin\ang_chp2_bremule\obj_retakegrainville.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `CaptureGrainville_InitObjectives` | — | public |
| 37 | `CaptureGrainville_Start` | — | public |
| 42 | `CaptureGrainville_PreComplete` | — | public |
| 51 | `CaptureGrainville_Complete` | — | public |
| 71 | `Grainville_Delayed_Counterattack` | — | public |
| 75 | `DefeatGrainvilleRebels_Start` | — | public |

### scenarios\campaign\angevin\ang_chp2_bremule\training_bremule.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 18 | `Bremule_Tutorials_Init` | — | public |
| 24 | `MissionTutorial_Init` | — | public |
| 41 | `MissionTutorial_Blacksmith` | — | public |
| 52 | `Blacksmith_TriggerPredicate` | `goalSequence` | public |
| 67 | `Blacksmith_BypassPredicate` | `goalSequence` | public |
| 86 | `UserHasViewedBlacksmithBuilding` | `goal` | public |
| 104 | `MissionTutorial_UnitUpgrade` | — | public |
| 115 | `UnitUpgrade_TriggerPredicate` | `goalSequence` | public |
| 129 | `UnitUpgrade_BypassPredicate` | `goalSequence` | public |
| 148 | `UserHasViewedBarracksBuilding` | `goal` | public |
| 165 | `Healing_TriggerPredicate` | `goalSequence` | public |
| 182 | `Healing_MonkIsSelected` | `goal` | public |
| 192 | `Healing_UseHeal` | `goal` | public |
| 196 | `Healing_TargetWounded` | `goal` | public |
| 206 | `FindWounded` | — | public |

### scenarios\campaign\angevin\ang_chp2_tinchebray\ang_chp2_tinchebray_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `Tinchebray_Data_Init` | — | public |
| 224 | `GetRecipe` | — | public |

### scenarios\campaign\angevin\ang_chp2_tinchebray\ang_chp2_tinchebray_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `UserHasOpenedTheDiplomacyMenu` | — | public |
| 14 | `ShouldPromptUserToSendGold` | `goalSequence` | public |
| 22 | `UserHasGold` | `goalSequence` | public |
| 33 | `UserHasGoldOrReinforcements` | `goalSequence` | public |
| 40 | `NoGoldPickupsRemain` | — | public |
| 54 | `HasGoldInSight` | `goalSequence` | public |
| 73 | `TrainingGoal_AddPickupGold` | — | public |
| 89 | `TrainingGoal_EnablePickupGold` | — | public |
| 93 | `TrainingGoal_AddSendGold` | — | public |
| 108 | `TrainingGoal_EnableSendGold` | — | public |
| 112 | `TrainingGoal_DisableSendGold` | — | public |

### scenarios\campaign\angevin\ang_chp2_tinchebray\ang_chp2_tinchebray.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupPlayers` | — | public |
| 65 | `Mission_SetupVariables` | — | public |
| 79 | `Mission_SetRestrictions` | — | public |
| 83 | `Mission_SetDifficulty` | — | public |
| 97 | `Mission_PreInit` | — | public |
| 101 | `Mission_Preset` | — | public |
| 148 | `Mission_Start` | — | public |
| 166 | `Mission_Start_Delayed` | — | public |
| 174 | `Mission_OnTributeSent` | `tribute` | public |
| 198 | `Tinchebray_IntroduceDiplomacyUI` | — | public |
| 206 | `Tinchebray_CheckDiplomacyReminder` | — | public |
| 217 | `Tinchebray_ShowTributeMenu` | — | public |
| 226 | `Tinchebray_AddSendGoldDelayed` | — | public |
| 231 | `Tinchebray_HideTributeMenu` | — | public |
| 243 | `Tinchebray_SetPopulationCapVisibility` | `visibility` | public |
| 253 | `Tinchebray_InitDebugObjective` | — | public |
| 270 | `Tinchebray_CheckMissionFail` | — | public |
| 281 | `Tinchebray_InitCastle` | — | public |
| 300 | `Tinchebray_TestOutro` | — | public |
| 307 | `Tinchebray_TriggerOutro` | — | public |
| 441 | `Tinchebray_UpdateArmyCount` | — | public |
| 445 | `Tinchebray_SallyOut` | — | public |
| 471 | `Tinchebray_RobertCallToAction` | — | public |
| 483 | `Tinchebray_CheckArmyState` | — | public |
| 537 | `Tinchebray_ProcessArmyTargets` | — | public |
| 567 | `Tinchebray_ProcessArmyTarget` | `index` | public |
| 600 | `Tinchebray_CheckReinforcementState` | — | public |
| 620 | `Tinchebray_PlayCelebrateAtPosition` | `pos` | public |
| 626 | `Tinchebray_PlayCelebrateUnitsOnScreen` | — | public |
| 645 | `Tinchebray_ReinforcementAWalla` | — | public |
| 649 | `Tinchebray_SpawnUnitLine` | `markerName, lineLength, numPerMarker, unitType, masterSgroup` | public |
| 660 | `Tinchebray_InitStartingUnits` | — | public |
| 677 | `Tinchebray_Spawn_Henry_Army` | — | public |
| 688 | `Tinchebray_SpawnIntroRam` | — | public |
| 697 | `Tinchebray_SpawnIntroGroupsA` | — | public |
| 705 | `Tinchebray_SpawnIntroGroupsB` | — | public |
| 713 | `Tinchebray_SpawnIntroGroupsC` | — | public |
| 721 | `Tinchebray_MoveMainArmy` | — | public |
| 735 | `Tinchebray_SpawnIntroGroup` | `wave, index` | public |
| 754 | `Tinchebray_InitVillages` | — | public |
| 796 | `Tinchebray_OnReliefWithdraw` | — | public |
| 808 | `Tinchebray_CheckReliefRemove` | — | public |
| 820 | `Tinchebray_SetArmyToAttack` | — | public |
| 826 | `Tinchebray_SetDefaultArmyTargets` | — | public |
| 840 | `Tinchebray_CheckReliefArmyProx` | — | public |
| 881 | `Tinchebray_CheckReinforceTrigger` | — | public |
| 894 | `Tinchebray_CheckMartignyProx` | — | public |
| 910 | `Tinchebray_CheckFrenesProx` | — | public |
| 926 | `Tinchebray_MergeMartignyArchers` | — | public |
| 931 | `Tinchebray_MergeFrenesArchers` | — | public |
| 936 | `Tinchebray_CheckVillages` | — | public |
| 1020 | `Tinchebray_SpawnEnemyReinforcements` | — | public |
| 1034 | `Tinchebray_RevealEnemyReinforcements` | — | public |
| 1039 | `Tinchebray_NewScoutDescriptor` | — | public |
| 1043 | `Tinchebray_SpawnScout` | — | public |
| 1079 | `Tribute_Intel` | — | public |

### scenarios\campaign\angevin\ang_chp2_tinchebray\diplomacy_chp2_tinchebray.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Diplomacy_DiplomacyEnabled` | `is_enabled` | public |
| 126 | `Diplomacy_TributeEnabled` | `is_enabled` | public |
| 134 | `Diplomacy_OnInit` | — | public |
| 141 | `Diplomacy_Start` | — | public |
| 163 | `Diplomacy_OnGameOver` | — | public |
| 171 | `Diplomacy_OnGameRestore` | — | public |
| 182 | `Diplomacy_ToggleDiplomacyUI` | — | public |
| 197 | `Diplomacy_ShowDiplomacyUI` | `show` | public |
| 207 | `Diplomacy_IsExpanded` | — | public |
| 213 | `Diplomacy_ChangeRelation` | `parameter` | public |
| 219 | `Diplomacy_IncreaseTribute` | `parameter` | public |
| 230 | `Diplomacy_DecreaseTribute` | `parameter` | public |
| 241 | `Diplomacy_ClearTribute` | — | public |
| 254 | `Diplomacy_SendTribute` | — | public |
| 273 | `Diplomacy_ShowUI` | `show` | public |
| 286 | `Diplomacy_OnConstructionComplete` | `context` | public |
| 302 | `Diplomacy_OnPlayerDefeated` | `player, reason` | public |
| 326 | `Diplomacy_OnPlayerNameChanged` | `context` | public |
| 338 | `Diplomacy_OnUpgradeComplete` | `context` | public |
| 359 | `Diplomacy_UpdateDataContext` | — | public |
| 448 | `Diplomacy_OverridePlayerSettings` | `playerID, is_player_visible, is_tribute_visible, is_food_enabled, is_wood_enabled, is_gold_enabled, is_stone_enabled` | public |
| 465 | `Diplomacy_OverrideSettings` | `is_tribute_enabled, is_subtotal_visible, is_score_visible, is_team_visible` | public |
| 474 | `Diplomacy_GetTaxRate` | `playerID` | public |
| 479 | `Diplomacy_SetTaxRate` | `playerID, tax_rate` | public |
| 486 | `Diplomacy_AddTribute` | `player_index, resource_index, amount` | public |
| 522 | `Diplomacy_CreateDataContext` | — | public |
| 592 | `Diplomacy_FormatTeamNumber` | `team_number` | public |
| 601 | `Diplomacy_SortDataContext` | — | public |
| 614 | `Diplomacy_CreateUI` | — | public |
| 865 | `Diplomacy_RemoveUI` | — | public |
| 873 | `Diplomacy_UpdateUI` | — | public |
| 880 | `Rule_Diplomacy_UpdateUI` | — | public |
| 887 | `Diplomacy_Restart` | — | public |
| 894 | `Diplomacy_ShowEventCue` | `tribute` | public |
| 921 | `Diplomacy_SendTributeNtw` | `playerID, data` | public |

### scenarios\campaign\angevin\ang_chp2_tinchebray\obj_defeat.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Defeat_InitObjectives` | — | public |

### scenarios\campaign\angevin\ang_chp2_tinchebray\obj_reinforce.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `UI_ReinforcePanel_UpdateData` | — | public |
| 77 | `UI_RequestAid_ButtonCallback` | `parameter` | public |
| 126 | `UI_RequestAid_EventCue` | — | public |
| 133 | `UI_RequestAid_MoveCamera` | — | public |
| 139 | `Start_IntelCooldown` | `target, reserve` | public |
| 153 | `ReinforceIntel_Cooldown` | — | public |

### scenarios\campaign\angevin\ang_chp3_lincoln\ang_chp3_lincoln_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `Lincoln_Data_Init` | — | public |
| 292 | `GetRecipe` | — | public |

### scenarios\campaign\angevin\ang_chp3_lincoln\ang_chp3_lincoln_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `TrainingGoal_EnableCampaignStealthGoals` | — | public |
| 23 | `Lincoln_InitTraining` | — | public |
| 72 | `AlliesHaveArrived` | `goalSequence` | public |
| 93 | `TimerORIgnore_UserCannotSeeSquadKey` | `goalSequence` | public |
| 101 | `TimerORIgnore_UserHasNoUnitSelected` | `goalSequence` | public |
| 110 | `UserHasViewedAlliesTraining` | `goal` | public |
| 124 | `HasScoutInSight` | `goalSequence` | public |
| 147 | `UserHasAScoutSelectedPredicate` | `goalSequence` | public |

### scenarios\campaign\angevin\ang_chp3_lincoln\ang_chp3_lincoln.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupPlayers` | — | public |
| 110 | `Mission_SetupVariables` | — | public |
| 119 | `Mission_SetRestrictions` | — | public |
| 127 | `Mission_SetDifficulty` | — | public |
| 142 | `Mission_Preset` | — | public |
| 207 | `Lincoln_SetPopulationCapVisibility` | `visibility` | public |
| 217 | `Lincoln_PlayWallaAtPosition` | `pos, includeAllies` | public |
| 234 | `Mission_Start` | — | public |
| 257 | `Lincoln_CheckStealthForestProx` | — | public |
| 282 | `Lincoln_CheckHoldPosition` | — | public |
| 316 | `Lincoln_AddStealthLabels` | — | public |
| 326 | `Lincoln_CheckMissionFail` | — | public |
| 337 | `Lincoln_UpgradeTowers` | — | public |
| 349 | `Lincoln_InitBesiegers` | — | public |
| 367 | `Lincoln_InitWallArchers` | — | public |
| 384 | `Lincoln_InitStartingUnits` | — | public |
| 418 | `Lincoln_InitSiegeCamps` | — | public |
| 448 | `Lincoln_MoveStartingUnits` | — | public |
| 463 | `Lincoln_Fail` | — | public |
| 467 | `Lincoln_Complete` | — | public |
| 482 | `Lincoln_CheckFieldArmy` | — | public |
| 502 | `Lincoln_SpawnEnemyReinforcements` | `index, useEdgeSpawn` | public |
| 578 | `Lincoln_SetErgTargets1` | — | public |
| 585 | `Lincoln_SetErgTargets2` | — | public |
| 592 | `Lincoln_SetErgTargets3` | — | public |
| 599 | `Lincoln_CheckEnemyReinforcements` | — | public |
| 631 | `Lincoln_CheckEnemyReinforcementGroup` | `objective, index, showCompleteTitle` | public |
| 663 | `Lincoln_MoveToMarket` | `context, data` | public |
| 674 | `Lincoln_MergeToMarket` | `context, data` | public |
| 684 | `Lincoln_CheckBridgeTrigger` | — | public |
| 693 | `Lincoln_StartWelshPhase` | — | public |
| 702 | `Lincoln_CheckTradePostProx` | — | public |
| 711 | `Lincoln_CheckEastPatrolProx` | — | public |
| 728 | `Lincoln_CheckCityGateProx` | — | public |
| 771 | `Lincoln_CheckFieldTrigger` | — | public |
| 787 | `Lincoln_PrepFieldArmy` | — | public |
| 798 | `Lincoln_CheckFieldTriggerFinal` | — | public |
| 809 | `Lincoln_SpawnContinuousUnitLine` | `markerName, lineLength, unitType, masterSgroup, deployPalings` | public |
| 834 | `Lincoln_SpawnUnitLine` | `markerName, lineLength, numPerMarker, unitType, masterSgroup` | public |
| 853 | `Lincoln_InitFlankGuards` | — | public |
| 866 | `Lincoln_ReinforceFlankAttackers` | — | public |
| 911 | `Lincoln_SpawnFlankUnits` | `moduleName, markerSpawn, markerDest, units` | public |
| 923 | `Lincoln_SpawnWelsh` | — | public |
| 942 | `Lincoln_StartTradePost` | — | public |
| 947 | `Lincoln_SpawnReinforcements1` | — | public |
| 969 | `Lincoln_SpawnReinforcements2` | — | public |
| 997 | `Lincoln_StartRendezvous` | — | public |
| 1002 | `Lincoln_FinalAttackRetreat` | — | public |
| 1016 | `Lincoln_BeginEndStage` | — | public |
| 1027 | `Lincoln_LaunchFinalAttack` | — | public |
| 1048 | `Lincoln_CheckRoyalGuard` | — | public |
| 1066 | `Lincoln_CheckFinalAttackTrigger` | — | public |
| 1082 | `Lincoln_CheckKeep` | — | public |
| 1103 | `Lincoln_OnEntityKilled` | `context` | public |
| 1137 | `Lincoln_TriggerBreachAlert` | — | public |
| 1155 | `Lincoln_StartDefendKeep` | — | public |
| 1160 | `Achievement_OnDamage` | `context` | public |
| 1169 | `Lincoln_SetAdvanceWelshTargets` | — | public |
| 1185 | `Lincoln_SetFinalWelshTargets` | — | public |
| 1198 | `Lincoln_CheckWelshCastleTrigger` | — | public |
| 1209 | `Lincoln_DisbandWelsh` | — | public |
| 1228 | `Lincoln_GetWelshArchers` | — | public |
| 1247 | `Lincoln_MoveWelshArchers` | — | public |
| 1268 | `Lincoln_ReformWelshSpearmen` | — | public |
| 1275 | `Lincoln_ReinforceAssault` | — | public |
| 1380 | `Lincoln_AddSiegeWeapon` | `units` | public |

### scenarios\campaign\angevin\ang_chp3_lincoln\obj_defeat.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Defeat_InitObjectives` | — | public |
| 368 | `DefeatArmy_Start` | — | public |
| 373 | `DefeatArmy_StartCamps` | — | public |
| 399 | `DefeatArmy_CheckCamps` | — | public |
| 415 | `DefeatArmy_CheckCamp` | `data` | public |
| 469 | `DestroyTradePost_Check` | — | public |
| 497 | `DefeatStephen_OnSquadKilled` | `context` | public |

### scenarios\campaign\angevin\ang_chp3_lincoln\obj_defend.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Defend_InitObjectives` | — | public |
| 22 | `DefendKeep_Start` | — | public |
| 29 | `DefendKeep_Fail` | — | public |
| 34 | `DefendKeep_Check` | — | public |

### scenarios\campaign\angevin\ang_chp3_lincoln\obj_welsh.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Welsh_InitObjectives` | — | public |
| 58 | `Rendezvous_HelpCheck` | — | public |
| 82 | `Rendezvous_Check` | — | public |
| 137 | `Rendezvous_SpawnWelshReinforcements` | `moduleName, destMarker` | public |

### scenarios\campaign\angevin\ang_chp3_wallingford\ang_chp3_wallingford_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `Wallingford_InitData1` | — | public |
| 67 | `Wallingford_InitData2` | — | public |
| 123 | `Wallingford_LoadUnitTables` | — | public |
| 390 | `GetRecipe` | — | public |
| 808 | `SetupWaves` | — | public |

### scenarios\campaign\angevin\ang_chp3_wallingford\ang_chp3_wallingford_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `Wallingford_InitObjectives` | — | public |
| 100 | `HenryOnLook` | — | public |
| 108 | `MonitorHenry` | `context, data` | public |
| 117 | `HenryReminder` | `context, data` | public |
| 125 | `GetSpawnCount` | — | public |
| 130 | `SpawnReinforcements` | — | public |
| 148 | `UpdateCampsRemaining` | — | public |
| 175 | `UpdateUnitsRemaining` | `trigger_final_attack` | public |

### scenarios\campaign\angevin\ang_chp3_wallingford\ang_chp3_wallingford.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Mission_SetupPlayers` | — | public |
| 26 | `Mission_SetupVariables` | — | public |
| 30 | `Mission_Preset` | — | public |
| 75 | `Mission_Start` | — | public |
| 135 | `Wallingford_ReinforcementsArrive` | `context` | public |
| 144 | `Wallingford_LaunchIntroWave` | `context, data` | public |
| 157 | `Wallingford_TryPrepare` | `context, data` | public |
| 174 | `Wallingford_PrepareWave` | `lane, units` | public |
| 189 | `ChooseLane` | `lanes` | public |
| 227 | `Wallingford_GetWaveUnits` | — | public |
| 235 | `Wallingford_OnLaunch` | `module` | public |
| 244 | `Wallingford_OnComplete` | `module` | public |
| 251 | `Wallingford_MonitorWave` | `context, data` | public |
| 325 | `Wallingford_MonitorEnemyReinforcements` | `context` | public |
| 345 | `GetReinforcementSource` | `round` | public |
| 350 | `ReinforceFirst` | — | public |
| 367 | `ReinforceSecond` | — | public |
| 382 | `CompareLanes` | `lane_a, lane_b` | public |
| 386 | `WallsBreached` | `context` | public |
| 394 | `DoneWaiting` | — | public |
| 398 | `Wallingford_Mainloop` | — | public |
| 402 | `Wallingford_StartOutpostObjective` | `context` | public |
| 406 | `Wallingford_ReinforcementsAlmostHere` | `context` | public |

### scenarios\campaign\angevin\ang_chp3_wallingford\obj_defend.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `Defend_InitObjectives` | — | public |
| 12 | `Defend_IsFailed` | — | public |
| 19 | `Defend_OnFail` | — | public |

### scenarios\campaign\angevin\ang_chp3_wallingford\obj_eliminate_waves.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `EliminateWaves_InitObjectives` | — | public |
| 23 | `UnitsRemaining_SetupUI` | — | public |
| 28 | `UnitsRemaining_UpdateCount` | — | public |
| 64 | `UnitsRemaining_IsComplete` | — | public |
| 70 | `UnitsRemaining_OnComplete` | — | public |

### scenarios\campaign\angevin\ang_chp3_wallingford\obj_eliminate.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `Eliminate_InitObjectives` | — | public |
| 56 | `Defenders_SetupUI` | — | public |
| 65 | `Defenders_UpdateCount` | — | public |
| 79 | `Defenders_IsComplete` | — | public |
| 84 | `Defenders_OnComplete` | — | public |

### scenarios\campaign\angevin\ang_chp3_wallingford\obj_survive.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 10 | `Survive_InitObjectives` | — | public |
| 21 | `Survive_OnComplete` | — | public |
| 27 | `Survive_PreComplete` | — | public |

### scenarios\campaign\angevin\ang_chp3_wallingford\training_wallingford.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Wallingford_AddHintToRepair` | — | public |
| 30 | `CheckIgnore` | `goalSequence` | public |
| 44 | `BuildingIsDamaged` | `goalSequence` | public |
| 66 | `UserIsRepairing` | `goal` | public |
| 76 | `RepairBypass` | `goalSequence` | public |
| 96 | `Wallingford_AddHintToBuildTower` | — | public |
| 118 | `BuildTowerCriteraMet` | `goalSequence` | public |
| 135 | `Wallingford_AddHintToGarrisonWall` | — | public |
| 156 | `GarrisonWallTrigger` | `goalSequence` | public |
| 172 | `Wallingford_AddHintIncendiaryArrows` | — | public |
| 197 | `ResearchFireArrowsTrigger` | `goalSequence` | public |
| 211 | `ReasearchFireArrowsIgnore` | `goalSequence` | public |
| 218 | `PlayerResearchingIncendiary` | — | public |
| 238 | `UserIsSelectingArsenal` | `goal` | public |
| 242 | `PlayerIsResearchingIncendiary` | `goal` | public |
| 267 | `Wallingford_AddHintToKeep` | — | public |
| 288 | `KeepTrigger` | `goalSequence` | public |
| 305 | `Wallingford_FindArcher` | — | public |
| 322 | `Wallingford_FindEntityOnScreen` | `scar_type` | public |
| 336 | `PlayerInCombat` | — | public |
| 341 | `DelayTimeElapsed` | `goal` | public |
| 349 | `UserIsSelectingBuilding` | `building` | public |

### scenarios\campaign\angevin\ang_chp4_dover\ang_chp4_dover_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Dover_Data_Init` | — | public |
| 202 | `Dover_InitWaveData` | — | public |
| 266 | `GetRecipe` | — | public |

### scenarios\campaign\angevin\ang_chp4_dover\ang_chp4_dover.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupVariables` | — | public |
| 27 | `Mission_SetupPlayers` | — | public |
| 155 | `Mission_SetRestrictions` | — | public |
| 165 | `Mission_SetDifficulty` | — | public |
| 185 | `Mission_Preset` | — | public |
| 227 | `Mission_Start` | — | public |
| 236 | `Dover_SetPalisadeTargeting` | — | public |
| 244 | `Dover_InitEnemyUnits` | — | public |
| 316 | `Dover_WeakenPalisadeGates` | — | public |
| 326 | `Dover_InitPlayerUnits` | — | public |
| 347 | `Dover_StartWillikinPhase` | — | public |
| 374 | `Dover_MoveWillikinUnits` | — | public |
| 388 | `Dover_CheckWoodVillagerProx` | — | public |
| 396 | `Dover_AssignStartingUnits` | — | public |
| 414 | `Dover_SendWallArchers` | — | public |
| 430 | `Dover_WallArchersHoldPosition` | — | public |
| 459 | `Dover_SendIntroUnits` | `context, data` | public |
| 476 | `Dover_SpawnWave` | `table, index, moduleName, sourceMarker, targetMarker` | public |
| 485 | `Dover_SpawnRangedSiegeNorth` | — | public |
| 494 | `Dover_SpawnRangedSiegeSouth` | — | public |
| 503 | `Dover_CheckFrenchCampStatus` | — | public |
| 517 | `Dover_CheckFailCondition` | — | public |

### scenarios\campaign\angevin\ang_chp4_dover\obj_disruptfrench.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `DisruptFrench_InitObjectives` | — | public |
| 177 | `Dover_StartTraderObjective` | — | public |
| 181 | `Dover_OnSquadBuilt` | `context` | public |
| 199 | `Dover_AssignWillikinVillagers` | — | public |
| 204 | `Dover_SetPlayerOwner` | `sgroup, player` | public |
| 222 | `Dover_DisplayPopcapCue` | — | public |
| 227 | `Dover_CheckArcherRecruitDover` | — | public |
| 240 | `Dover_CheckArcherRecruitNorth` | — | public |
| 256 | `Dover_CheckSiegeCampReinforcement` | — | public |
| 274 | `Dover_CheckEdgeReinforcement` | — | public |
| 292 | `Dover_CheckArcherRecruitWest` | — | public |
| 309 | `Dover_OnSquadKilled` | `context` | public |
| 334 | `Dover_EvaluateActivePaths` | — | public |
| 375 | `Dover_AddSiegeUI` | `sgroup` | public |
| 383 | `Modify_SetUnitMaxSpeed` | `group, newSpeed, duration` | public |
| 403 | `Dover_StartSupplyTrains` | — | public |
| 415 | `Dover_SendSupplyTrain` | — | public |
| 545 | `Dover_OnSupplyArrival` | `moduleName, siegeSgroup` | public |
| 552 | `Dover_TickSupplyCaravans` | — | public |
| 558 | `Dover_GenerateSupplyRoute` | — | public |
| 632 | `Dover_SpawnRandomForestPatrol` | — | public |
| 657 | `Dover_SpawnRoadPatrol` | — | public |
| 678 | `Dover_CheckForestCamp` | — | public |
| 686 | `Dover_CheckSouthAmbush` | — | public |
| 699 | `Dover_RevealSouthAmbush` | — | public |
| 703 | `Dover_RecruitForestCamp` | — | public |
| 725 | `Dover_RecruitSouthAmbush` | — | public |
| 748 | `Dover_SpawnSouthAmbush` | — | public |
| 761 | `Dover_GroupWillikinArchers` | — | public |
| 769 | `Dover_WillikinCheer` | — | public |
| 774 | `Dover_SpawnForestGroup` | `unitType, unitNum, marker` | public |
| 784 | `Dover_CheckForestAllyObjective` | — | public |
| 799 | `Dover_SpawnForestCamp` | — | public |
| 809 | `Dover_SpawnWillikinExtras` | — | public |
| 838 | `Dover_MonitorEscortSGroups` | — | public |

### scenarios\campaign\angevin\ang_chp4_dover\obj_holdoffsiege.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `HoldOffSiege_InitObjectives` | — | public |
| 103 | `Dover_OnEntityKilled` | `context` | public |
| 162 | `Dover_StartInitialAttack` | — | public |
| 175 | `Dover_ReleaseSiegeUnits_Wave1` | — | public |
| 182 | `Dover_ReleaseSiegeUnits_Wave2` | — | public |
| 188 | `Dover_Retreat_Initial` | — | public |
| 204 | `Dover_Retreat_Final` | — | public |

### scenarios\campaign\angevin\ang_chp4_dover\obj_siegewaves.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `SiegeWaves_InitObjectives` | — | public |
| 155 | `SiegeWaves_StartWave1` | — | public |
| 164 | `SiegeWaves_CompleteWave1` | — | public |
| 169 | `SiegeWaves_StartWave2` | — | public |
| 176 | `SiegeWaves_CompleteWave2` | — | public |
| 181 | `SiegeWaves_StartWave3` | — | public |
| 188 | `SiegeWaves_CompleteWave3` | — | public |
| 193 | `Dover_Timer1Complete` | — | public |
| 199 | `Dover_Timer2Complete` | — | public |
| 205 | `Dover_Timer3Complete` | — | public |
| 210 | `Dover_SiegeFallbackDelay` | — | public |
| 218 | `Dover_GenerateSiegeRoute` | — | public |
| 243 | `Dover_ResetCartKillCount` | — | public |
| 248 | `Dover_IncrementCartKillCount` | — | public |
| 254 | `Dover_UpdateCartCount` | — | public |
| 259 | `Dover_SpawnFromCart` | — | public |
| 319 | `Dover_SpawnSiegeTowerWave1` | — | public |
| 325 | `Dover_SpawnSiegeTowerWave2` | — | public |
| 331 | `Dover_SpawnSiegeTowerWave3` | — | public |
| 342 | `Dover_SiegeAttack` | — | public |
| 430 | `Dover_SiegeAttackFinal` | — | public |
| 437 | `Dover_SiegeAttackFinal2` | — | public |
| 444 | `Dover_CheckRoadPatrols` | — | public |
| 513 | `Dover_SiegeFallbackIfLosing` | — | public |
| 570 | `Dover_ReleaseReservesIfFull` | — | public |
| 591 | `Dover_SiegeRetreat` | — | public |
| 602 | `Dover_PlayEngageWallaAtCastle` | — | public |
| 617 | `Dover_MissionOutro` | — | public |
| 621 | `Dover_SiegeVOLine` | — | public |
| 649 | `Dover_SkipIntro` | — | public |
| 679 | `Dover_InitOutro` | — | public |

### scenarios\campaign\angevin\ang_chp4_dover\training_dover.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `MissionTutorial_DoverLeaderAura` | — | public |
| 30 | `_HasWillikinOnScreen` | `goalSequence` | private |
| 57 | `_OnHoverOrTimeElapsed` | `goal` | private |
| 77 | `MissionTutorial_DoverTraders` | — | public |
| 96 | `_HasTraderOnScreen` | `goalSequence` | private |

### scenarios\campaign\angevin\ang_chp4_lincoln\ang_chp4_lincoln_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Lincoln2_Data_Init` | — | public |
| 326 | `GetRecipe` | — | public |

### scenarios\campaign\angevin\ang_chp4_lincoln\ang_chp4_lincoln_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Lincoln2_AddKeepUpgradesGoal` | — | public |
| 24 | `ShouldPromptUpgradesHint` | `goalSequence` | public |
| 47 | `UserHasViewedUpgradeTraining` | `goal` | public |
| 67 | `UserHasSelectedAKeep` | — | public |

### scenarios\campaign\angevin\ang_chp4_lincoln\ang_chp4_lincoln.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 18 | `Mission_SetupPlayers` | — | public |
| 96 | `Mission_SetupVariables` | — | public |
| 102 | `Mission_SetDifficulty` | — | public |
| 119 | `Mission_SetRestrictions` | — | public |
| 180 | `Mission_Preset` | — | public |
| 233 | `Lincoln2_SetManualTargeting` | — | public |
| 241 | `Lincoln2_InitCollapsedWalls` | — | public |
| 263 | `Mission_Start` | — | public |
| 318 | `Lincoln2_GarrisonOutposts` | — | public |
| 342 | `Lincoln2_CheckMissionFail` | — | public |
| 352 | `Lincoln2_CheckMissionWin` | — | public |
| 361 | `Lincoln2_SpawnUnitLine` | `markerName, endIndex, numPerMarker, unitType, startIndex` | public |
| 372 | `Lincoln2_CheckFrenchArrival` | — | public |
| 389 | `Lincoln2_StartDefeatFrench` | — | public |
| 396 | `Lincoln2_CheckFrenchFirstAttack` | — | public |
| 405 | `Lincoln2_CheckRebelBuildingProx` | — | public |
| 424 | `Lincoln2_TrackMilitaryBuildings` | — | public |
| 448 | `Lincoln2_ClearIntroUnits` | — | public |
| 456 | `Lincoln2_InitRebels` | — | public |
| 468 | `Lincoln2_InitStartingUnits` | — | public |
| 505 | `Lincoln2_TriggerOutro` | — | public |
| 522 | `Lincoln2_OutroSetup` | — | public |
| 549 | `Lincoln2_CheckFrenchSightTrigger` | — | public |
| 561 | `Lincoln2_CheckStoweTrigger` | — | public |
| 594 | `Lincoln2_StoweCTA` | — | public |
| 604 | `Lincoln2_SpawnReinforcements1` | — | public |
| 619 | `Lincoln2_WilliamMarshalCTA` | — | public |
| 628 | `Lincoln2_WilliamMarshalCheer` | — | public |
| 633 | `Lincoln2_WillaimMarshalCheerDelayed` | — | public |
| 639 | `Lincoln2_MoveReinforcements1` | — | public |
| 648 | `Lincoln2_PlayReinforceWalla` | — | public |
| 658 | `Lincoln2_PlayCelebrateAtPosition` | `pos, range` | public |
| 664 | `Lincoln2_PlayEngageAtPosition` | `player, pos, range` | public |
| 671 | `Lincoln2_SetupFrenchForts` | — | public |
| 685 | `Lincoln2_InitFrenchAttack` | — | public |
| 698 | `Lincoln2_InitFrenchActivity` | — | public |
| 706 | `Lincoln2_ActivateFortA` | — | public |
| 719 | `Lincoln2_ActivateFortB` | — | public |
| 728 | `Lincoln2_CheckRebelWaves` | — | public |
| 749 | `Lincoln2_CheckFrenchWaveA` | — | public |
| 757 | `Lincoln2_CheckFrenchWaveB` | — | public |
| 764 | `Lincoln2_GetFrenchWaveTargets` | — | public |
| 777 | `Lincoln2_CheckRebelWave` | `wave, data` | public |
| 807 | `Lincoln2_CheckFrenchWave` | `wave, data, targets` | public |
| 845 | `Lincoln2_CheckRebelPrematureAttack` | — | public |
| 883 | `Lincoln2_CheckFortProxA` | — | public |
| 901 | `Lincoln2_CheckFortProxB` | — | public |
| 919 | `Lincoln2_SpawnUnitCluster` | `player, markerName, numPerMarker, unitType, masterSgroup` | public |
| 926 | `Lincoln2_CheckStrongpoints` | — | public |
| 979 | `Lincoln2_OnEntityKilled` | `context` | public |
| 1113 | `Lincoln2_CheckKeep` | — | public |
| 1134 | `Lincoln2_InitDebugComplete` | — | public |

### scenarios\campaign\angevin\ang_chp4_lincoln\obj_defeat_french.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `DefeatFrench_InitObjectives` | — | public |
| 75 | `FortWestOnWallDown` | `context` | public |
| 85 | `FortEastOnWallDown` | `context` | public |

### scenarios\campaign\angevin\ang_chp4_lincoln\obj_defeat_rebels.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `DefeatRebels_InitObjectives` | — | public |

### scenarios\campaign\angevin\ang_chp4_lincoln\obj_defend_keep.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `DefendKeep_InitObjectives` | — | public |

### scenarios\campaign\angevin\ang_chp4_lincoln\obj_reinforcements.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Reinforcements_InitObjectives` | — | public |
| 30 | `Reinforce1_TimerComplete` | — | public |

### scenarios\campaign\angevin\ang_chp4_rochester\ang_chp4_rochester_recipe.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `GetRecipe` | — | public |

### scenarios\campaign\angevin\ang_chp4_rochester\ang_chp4_rochester.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `missionstart_OnInit` | — | public |
| 15 | `Mission_SetupPlayers` | — | public |
| 77 | `Mission_SetupVariables` | — | public |
| 191 | `Mission_SetDifficulty` | — | public |
| 209 | `Mission_SetRestrictions` | — | public |
| 225 | `Mission_Preset` | — | public |
| 296 | `Mission_Start` | — | public |
| 323 | `Init_AttackWaves` | — | public |
| 363 | `ResetAttackWave_OnComplete` | — | public |
| 376 | `ConstructWave` | — | public |
| 450 | `QueueAttackWaves` | — | public |
| 459 | `PrepAttackWaves` | — | public |
| 471 | `SendPoke` | — | public |
| 502 | `DefendCountryside` | — | public |
| 524 | `DefendTraderoute` | — | public |
| 545 | `Init_EnemyTrade` | — | public |
| 588 | `Init_DefendRochester` | — | public |
| 617 | `BesiegeRochester_EntityKilled` | `context` | public |
| 650 | `InnerRochester_EntityKilled` | `context` | public |
| 683 | `Halt_ExtraActivities` | — | public |
| 699 | `KeepReveal` | — | public |
| 709 | `SiegeCounter_OnDamageReceived` | `context` | public |
| 725 | `CounterSiegeHunt` | — | public |
| 741 | `Init_FallenWallDefense` | — | public |
| 764 | `PushAttack` | — | public |
| 790 | `CounterMonks` | — | public |
| 830 | `SetUp_Fishing` | — | public |
| 837 | `Cycle_Fish` | — | public |
| 851 | `SiegeEntropy` | — | public |
| 906 | `RealTime_CTATargeting` | — | public |
| 914 | `SurrenderEnsure` | — | public |
| 926 | `Rochester_Intro_Movement` | — | public |
| 948 | `Delay_Detection` | — | public |
| 959 | `Reset_Detection` | — | public |
| 973 | `Misc_PlayerUnitsOnScreen` | `player` | public |
| 992 | `WallaSize` | `unitCount` | public |
| 1003 | `AudOnFromPoint` | `player, pos, audString` | public |
| 1027 | `AudOnScreen` | `player, audString` | public |
| 1063 | `EntropyCTA` | — | public |
| 1079 | `SetupOutro` | — | public |
| 1104 | `AttackWave_Intel` | — | public |

### scenarios\campaign\angevin\ang_chp4_rochester\obj_capturevillage.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `CaptureVillage_InitObjectives` | — | public |
| 62 | `CaptureVillage_Start` | — | public |
| 66 | `CaptureVillage_PreStart` | — | public |
| 70 | `DefeatHamletRebels_PreStart` | — | public |
| 86 | `CaptureVillage_PreComplete` | — | public |
| 104 | `CaptureVillage_OnComplete` | — | public |
| 121 | `CaptureVillage_IsFailed` | — | public |
| 131 | `CaptureVillage_OnFail` | — | public |
| 135 | `VillageRepopulate` | — | public |

### scenarios\campaign\angevin\ang_chp4_rochester\obj_destroyrochester.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `DestroyRochester_InitObjectives` | — | public |
| 32 | `DestroyRochester_PreStart` | — | public |
| 38 | `DestroyRochester_OnStart` | — | public |
| 51 | `DestroyRochester_IsComplete` | — | public |
| 60 | `DestroyRochester_OnComplete` | — | public |
| 65 | `DestroyRochester_IsFailed` | — | public |
| 75 | `DestroyRochester_OnFail` | — | public |

### scenarios\campaign\angevin\ang_chp4_rochester\obj_siegetutorial.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `SiegeTut_InitObjectives` | — | public |
| 48 | `SiegeTut_IsComplete` | — | public |
| 52 | `AgeUp_IsComplete` | — | public |
| 56 | `AgeUp_OnComplete` | — | public |
| 61 | `SiegeWorkshop_IsComplete` | — | public |
| 72 | `Trebuchets_OnStart` | — | public |
| 76 | `Trebuchets_IsComplete` | — | public |
| 103 | `_Hint_SiegeSetup` | — | private |
| 115 | `_RemoveHint_SiegeSetup` | — | private |

### scenarios\campaign\angevin\ang_chp4_rochester\obj_stopeconomy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `RochesterSupply_InitObjectives` | — | public |
| 39 | `RochesterSupply_SetupUI` | — | public |
| 43 | `RochesterSupply_OnStart` | — | public |
| 47 | `RochesterSupply_Init` | — | public |
| 64 | `RochesterSupply_IsComplete` | — | public |
| 73 | `DiscoverFarms` | — | public |
| 88 | `Rochester_GetMills` | — | public |
| 99 | `RochesterSupply_Update` | — | public |
| 131 | `DiscoverWagons` | — | public |
| 147 | `Trader_ObjectiveUI` | — | public |
| 155 | `Create_TraderMinimapPath` | — | public |
| 161 | `Rochester_DisplayMinimapPath` | `context, data` | public |
| 168 | `TraderArrivedPing` | — | public |
| 172 | `WagonKilled_SquadKilled` | `context` | public |
| 211 | `Init_TradeDefenders` | `traders` | public |
| 262 | `RochesterSupply_EntropyIfFirst` | — | public |
| 271 | `StMargaretsMonitor` | — | public |

### scenarios\campaign\angevin\ang_chp4_rochester\training_rochester.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 22 | `Rochester_Tutorials_Init` | — | public |
| 38 | `MissionTutorial_Init` | — | public |
| 55 | `MissionTutorial_Healing_Xbox` | — | public |
| 69 | `MissionTutorial_Healing` | — | public |
| 86 | `Healing_TriggerPredicate_Xbox` | `goalSequence` | public |
| 102 | `Healing_TriggerPredicate` | `goalSequence` | public |
| 119 | `Healing_MonkIsSelected` | `goal` | public |
| 129 | `Healing_UseHeal` | `goal` | public |
| 140 | `Healing_TargetWounded` | `goal` | public |
| 156 | `FindWounded` | — | public |
| 180 | `MissionTutorial_HolySite` | — | public |
| 202 | `HolySite_TriggerPredicate` | `goalSequence` | public |
| 222 | `HolySite_BypassPredicate` | `goalSequence` | public |
| 236 | `MonkIsSelected` | `goal` | public |
| 246 | `MonkIsAtSite` | `goal` | public |
| 341 | `MissionTutorial_Market` | — | public |
| 367 | `MissionTutorial_Market_Xbox` | — | public |
| 389 | `Market_TriggerPredicate` | `goalSequence` | public |
| 401 | `Market_VillagerIsSelected` | `goal` | public |
| 411 | `Market_VillagerIsSelectedAndRadialOpen` | `goal` | public |
| 421 | `Market_EconRadialOpen` | `goal` | public |
| 432 | `Market_PlayerIsGoingToBuild` | `goal` | public |
| 436 | `Market_IsBuilt` | `goal` | public |
| 442 | `Market_MarketExists` | `goalSequence` | public |
| 454 | `MissionTutorial_BuySell` | — | public |
| 493 | `BuySell_TriggerPredicate` | `goalSequence` | public |
| 550 | `BuySell_MarketIsSelected` | `goal` | public |
| 560 | `BuySell_ResourceIsHovered` | `goal` | public |
| 567 | `MissionTutorial_ProduceTrader` | — | public |
| 585 | `ProduceTrader_TriggerPredicate` | `goalSequence` | public |
| 598 | `ProduceTrader_BypassPredicate` | `goalSequence` | public |
| 606 | `ProduceTrader_MarketIsSelected` | `goal` | public |
| 616 | `ProduceTrader_TraderIsBuilding` | `goal` | public |
| 633 | `MissionTutorial_AssignTrader` | — | public |
| 651 | `AssignTrader_TriggerPredicate` | `goalSequence` | public |
| 661 | `AssignTrader_BypassPredicate` | `goalSequence` | public |
| 667 | `AssignTrader_TraderIsSelected` | `goal` | public |
| 677 | `AssignTrader_TraderIsAssigned` | `goal` | public |
| 682 | `AnyTradersTrading` | `player` | public |

### scenarios\campaign\hundred\hun_chp1_combat30\diplomacy_hun_chp1_combat30.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Diplomacy_DiplomacyEnabled` | `is_enabled` | public |
| 125 | `Diplomacy_TributeEnabled` | `is_enabled` | public |
| 133 | `Diplomacy_OnInit` | — | public |
| 140 | `Diplomacy_Start` | — | public |
| 162 | `Diplomacy_OnGameOver` | — | public |
| 170 | `Diplomacy_OnGameRestore` | — | public |
| 182 | `Diplomacy_ToggleDiplomacyUI` | — | public |
| 197 | `Diplomacy_ShowDiplomacyUI` | `show` | public |
| 209 | `Diplomacy_ChangeRelation` | `parameter` | public |
| 215 | `Diplomacy_IncreaseTribute` | `parameter` | public |
| 226 | `Diplomacy_DecreaseTribute` | `parameter` | public |
| 237 | `Diplomacy_ClearTribute` | — | public |
| 250 | `Diplomacy_SendTribute` | — | public |
| 269 | `Diplomacy_ShowUI` | `show` | public |
| 283 | `Diplomacy_OnRelationshipChanged` | `observerPlayerID, targetPlayerID, show_notification` | public |
| 326 | `Diplomacy_OnConstructionComplete` | `context` | public |
| 342 | `Diplomacy_OnPlayerDefeated` | `player, reason` | public |
| 366 | `Diplomacy_OnPlayerNameChanged` | `context` | public |
| 378 | `Diplomacy_OnUpgradeComplete` | `context` | public |
| 399 | `Diplomacy_UpdateDataContext` | — | public |
| 488 | `Diplomacy_OverridePlayerSettings` | `playerID, is_player_visible, is_tribute_visible, is_food_enabled, is_wood_enabled, is_gold_enabled, is_stone_enabled` | public |
| 505 | `Diplomacy_OverrideSettings` | `is_tribute_enabled, is_subtotal_visible, is_score_visible, is_team_visible` | public |
| 514 | `Diplomacy_GetTaxRate` | `playerID` | public |
| 519 | `Diplomacy_SetTaxRate` | `playerID, tax_rate` | public |
| 526 | `Diplomacy_AddTribute` | `player_index, resource_index, amount` | public |
| 562 | `Diplomacy_CreateDataContext` | — | public |
| 632 | `Diplomacy_FormatTeamNumber` | `team_number` | public |
| 641 | `Diplomacy_SortDataContext` | — | public |
| 654 | `Diplomacy_CreateUI` | — | public |
| 910 | `Diplomacy_RemoveUI` | — | public |
| 918 | `Diplomacy_UpdateUI` | — | public |
| 925 | `Rule_Diplomacy_UpdateUI` | — | public |
| 932 | `Diplomacy_Restart` | — | public |
| 939 | `Diplomacy_ShowEventCue` | `tribute` | public |
| 966 | `Diplomacy_SendTributeNtw` | `playerID, data` | public |

### scenarios\campaign\hundred\hun_chp1_combat30\hun_chp1_combat30.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Mission_SetupVariables` | — | public |
| 308 | `Mission_SetupPlayers` | — | public |
| 416 | `Mission_SetRestrictions` | — | public |
| 451 | `Mission_PreInit` | — | public |
| 455 | `Mission_Preset` | — | public |
| 498 | `Mission_Start` | — | public |
| 510 | `GetRecipe` | — | public |
| 708 | `Combat30_SendIntroUnits` | `context, data` | public |
| 726 | `Combat30_CleanUpIntro` | — | public |
| 735 | `Combat30_InitIntroUnits_Proto` | — | public |
| 797 | `Combat30_SkipIntro` | — | public |
| 817 | `Combat30_VillagersToWork` | — | public |
| 831 | `Combat30_AssignSomeVillagers` | — | public |
| 865 | `Combat30_UpdateFollowerTargets` | — | public |
| 879 | `Combat30_SpawnFollowers` | `sgroup, num, scar_type, marker` | public |
| 894 | `Combat30_AchievementTracker` | `context` | public |
| 917 | `Combat30_GrantAchievement` | — | public |

### scenarios\campaign\hundred\hun_chp1_combat30\obj_approach.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `MoveToAndRespectFacing` | `sgroup, marker, queued` | public |
| 9 | `Approach_InitObjectives` | — | public |
| 322 | `Recruit1_Trigger` | — | public |
| 334 | `Recruit1_PreStart` | `objective, parent_objective, is_optional` | public |
| 355 | `Recruit1_MidBanner` | — | public |
| 359 | `Recruit1_OnStart` | `objective, parent_objective, is_optional` | public |
| 371 | `Recruit1_PreComplete` | `objective, parent_objective, is_optional` | public |
| 408 | `Recruit1_OnComplete` | `objective, parent_objective, is_optional` | public |
| 416 | `Recruit1_PreFail` | `objective, parent_objective, is_optional` | public |
| 422 | `Recruit1_OnFail` | `objective, parent_objective, is_optional` | public |
| 428 | `Recruit2_Trigger` | — | public |
| 440 | `Recruit2_PreStart` | `objective, parent_objective, is_optional` | public |
| 451 | `Recruit2_MidBanner1` | — | public |
| 456 | `Recruit2_MidBanner2` | — | public |
| 465 | `Recruit2_OnStart` | `objective, parent_objective, is_optional` | public |
| 475 | `Recruit2_PreComplete` | `objective, parent_objective, is_optional` | public |
| 489 | `Recruit2_OnComplete` | `objective, parent_objective, is_optional` | public |
| 496 | `Recruit2_PreFail` | `objective, parent_objective, is_optional` | public |
| 506 | `Recruit2_OnFail` | `objective, parent_objective, is_optional` | public |
| 512 | `Recruit3_Trigger` | — | public |
| 524 | `Recruit3_Trigger_Inner` | — | public |
| 536 | `Recruit3_PreStart` | `objective, parent_objective, is_optional` | public |
| 554 | `Recruit3_OnStart` | `objective, parent_objective, is_optional` | public |
| 573 | `Recruit3_PreComplete` | `objective, parent_objective, is_optional` | public |
| 599 | `Recruit3_OnComplete` | `objective, parent_objective, is_optional` | public |
| 606 | `Recruit3_PreFail` | `objective, parent_objective, is_optional` | public |
| 618 | `Recruit3_OnFail` | `objective, parent_objective, is_optional` | public |
| 623 | `Recruit4_Trigger` | — | public |
| 637 | `Recruit4_PreStart` | `objective, parent_objective, is_optional` | public |
| 653 | `Recruit4_MidBanner` | — | public |
| 664 | `Recruit4_OnStart` | `objective, parent_objective, is_optional` | public |
| 675 | `Recruit4_PreComplete` | `objective, parent_objective, is_optional` | public |
| 690 | `Recruit4_OnComplete` | `objective, parent_objective, is_optional` | public |
| 697 | `Recruit4_PreFail` | `objective, parent_objective, is_optional` | public |
| 710 | `Recruit4_OnFail` | `objective, parent_objective, is_optional` | public |
| 716 | `Combat30_IncrementChampionCounter` | — | public |
| 723 | `Combat30_SpawnChampions` | — | public |
| 744 | `Recruit1_SpawnWolves` | — | public |
| 767 | `Recruit1_CheckWolvesDead` | — | public |
| 785 | `Recruit2_SpawnEnglishRaid1` | — | public |
| 794 | `Recruit2_SpawnEnglishRaid2` | — | public |
| 808 | `Recruit2_CheckEnglishDead` | — | public |
| 827 | `Recruit3_SpawnDuel` | — | public |
| 838 | `Recruit3_CheckDuelComplete` | — | public |
| 858 | `Recruit3_CatchTravellers` | — | public |
| 869 | `Recruit3_ResumeTravellers` | — | public |
| 898 | `Recruit3_PostDuelRelationships` | — | public |
| 909 | `Recruit4_SpawnEnglishArchers` | — | public |
| 916 | `Recruit4_CheckEnglishDead` | — | public |
| 925 | `Recruit4_SpawnEnglishWaves` | — | public |
| 946 | `Recruit4_TowerDefended` | — | public |
| 952 | `Recruit4_SpawnRandomWave` | — | public |
| 989 | `Recruit4_CheckTowerAlive` | — | public |
| 1016 | `Combat30_RecruitSGroup` | `sgroup` | public |
| 1043 | `Combat30_UnrecruitSGroup` | `sgroup` | public |
| 1049 | `Combat30_RetreatSGroup` | `sgroup` | public |
| 1056 | `Combat30_Recruit_BoundaryCheck` | `context, options` | public |
| 1101 | `Combat30_Recruit3_BoundaryCheck` | — | public |
| 1126 | `Combat30_AddOptionToRecruitPanel` | `recruitNumber` | public |
| 1136 | `Combat30_SpawnChampionsAtBase` | — | public |
| 1169 | `Combat30_SpawnCrowd` | — | public |
| 1184 | `Combat30_CheerFrench` | — | public |
| 1188 | `Combat30_CheerEnglish` | — | public |
| 1192 | `Combat30_CheerBoth` | — | public |
| 1197 | `Combat30_StartTravellers` | — | public |
| 1202 | `Combat30_SendTraveller` | — | public |
| 1237 | `Combat30_RetreatRecruitSGroup` | `sgroup` | public |
| 1243 | `Combat30_FailCheck` | — | public |
| 1256 | `Combat30_ToggleBeaumanoirSlow` | `slow` | public |
| 1266 | `Combat30_LastChampionVO` | — | public |
| 1278 | `Combat30_BeaumanoirLowHealth` | — | public |
| 1292 | `Refresh_Crowns` | — | public |
| 1308 | `Cleanup_CrownGroups` | `context, data` | public |

### scenarios\campaign\hundred\hun_chp1_combat30\obj_combat.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Combat_InitObjectives` | — | public |
| 179 | `Combat1_EnteredArena` | — | public |
| 187 | `Combat_LockGate` | — | public |
| 211 | `Combat_UnlockGate` | — | public |
| 215 | `Combat1_PlayerSeesEnemy` | — | public |
| 222 | `Combat1_ReturnedToBase` | — | public |
| 238 | `Combat1_ReturnedToField` | — | public |
| 247 | `Combat30_CompleteBreak` | — | public |
| 251 | `Combat30_UnitCountUpdate` | — | public |
| 265 | `Combat30_ChooseBreakVO` | — | public |
| 278 | `Combat30_ReturnToBase` | — | public |
| 287 | `Combat30_FrenchReturntoBaseLoop` | — | public |
| 296 | `Combat30_RemoveProduction` | — | public |
| 300 | `Combat30_ReaddProduction` | — | public |
| 304 | `Combat30_ReturnToField` | — | public |
| 312 | `Combat30_TransferEnglishToAttack` | — | public |
| 321 | `Combat30_OnSquadKilled` | `context` | public |
| 340 | `Combat30_OnSquadBuilt` | `context` | public |
| 348 | `Combat30_EliminationCheck` | — | public |
| 365 | `Combat30_ReinforceRovingArmy` | — | public |
| 374 | `Combat30_RebuildToCounter` | — | public |
| 435 | `Combat30_SpawnDebugOutroUnits` | — | public |
| 451 | `Combat30_InitOutro` | — | public |
| 505 | `Combat30_Outro_Scout` | — | public |
| 515 | `Combat30_Outro_Parade` | — | public |
| 576 | `Combat30_AssignToGroup` | `sgroupid, squadindex, squadid` | public |
| 589 | `Combat30_OnSeeEnglishAudioStinger` | — | public |
| 601 | `Combat30_RetreatAllUnselectedChampions` | — | public |
| 625 | `Combat30_SelectArmyPath` | — | public |
| 629 | `Combat30_FirstRoundComplete` | — | public |

### scenarios\campaign\hundred\hun_chp1_combat30\obj_preround.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `PreRound_InitObjectives` | — | public |
| 130 | `PreRound_OnSquadBuilt` | `context` | public |
| 145 | `Combat30_CombatStart` | — | public |
| 149 | `PreRound_SpawnEnglish` | — | public |
| 168 | `BuffLandsknecht` | — | public |
| 180 | `Debug_SpawnPlayerChampions` | — | public |
| 184 | `Combat30_ShowTributeMenu` | — | public |
| 192 | `Combat30_HideTributeMenu` | — | public |
| 203 | `UI_ReinforcePanel_UpdateData` | — | public |
| 274 | `GetAidDestination` | — | public |
| 281 | `UI_RequestAid_ButtonCallback` | `parameter` | public |
| 312 | `Combat30_SpawnPlayerUnitsFromSelection` | `context, options` | public |
| 318 | `Start_CTACooldown` | `target` | public |
| 332 | `ReinforceCTA_Cooldown` | — | public |

### scenarios\campaign\hundred\hun_chp1_combat30\training_combat30.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `_DelayTimeElapsed` | `goal` | private |
| 24 | `MissionTutorial_BeaumanoirAura_Xbox` | — | public |
| 78 | `MissionTutorial_BeaumanoirAura` | — | public |
| 121 | `Predicate_UserHasSelectedJean` | `goal` | public |
| 128 | `Predicate_UserHasLookedAtJeanAbility` | `goal` | public |
| 135 | `Predicate_UserHasNotActivatedJeanLeaderAbilityRecently` | `goalSequence` | public |
| 145 | `MissionTutorial_ArrelAura_Xbox` | — | public |
| 199 | `MissionTutorial_ArrelAura` | — | public |
| 242 | `Predicate_UserHasSelectedArrel` | `goal` | public |
| 249 | `Predicate_UserHasLookedAtArrelAbility` | `goal` | public |
| 256 | `Predicate_UserHasNotActivatedArrelLeaderAbilityRecently` | `goalSequence` | public |
| 262 | `Arrel_TimeoutOrNotPlayerOwned` | `goalSequence` | public |
| 272 | `MissionTutorial_RochefortAura_Xbox` | — | public |
| 326 | `MissionTutorial_RochefortAura` | — | public |
| 369 | `Predicate_UserHasSelectedRochefort` | `goal` | public |
| 376 | `Predicate_UserHasLookedAtRochefortAbility` | `goal` | public |
| 383 | `Predicate_UserHasNotActivatedRochefortLeaderAbilityRecently` | `goalSequence` | public |
| 389 | `Rochefort_TimeoutOrNotPlayerOwned` | `goalSequence` | public |
| 399 | `MissionTutorial_BloisAura_Xbox` | — | public |
| 453 | `MissionTutorial_BloisAura` | — | public |
| 496 | `Predicate_UserHasSelectedBlois` | `goal` | public |
| 503 | `Predicate_UserHasLookedAtBloisAbility` | `goal` | public |
| 510 | `Predicate_UserHasNotActivatedBloisLeaderAbilityRecently` | `goalSequence` | public |
| 516 | `Blois_TimeoutOrNotPlayerOwned` | `goalSequence` | public |
| 526 | `MissionTutorial_CharruelAura_Xbox` | — | public |
| 580 | `MissionTutorial_CharruelAura` | — | public |
| 623 | `Predicate_UserHasSelectedCharruel` | `goal` | public |
| 630 | `Predicate_UserHasLookedAtCharruelAbility` | `goal` | public |
| 637 | `Predicate_UserHasNotActivatedCharruelLeaderAbilityRecently` | `goalSequence` | public |
| 643 | `Charruel_TimeoutOrNotPlayerOwned` | `goalSequence` | public |
| 654 | `MissionTutorial_Combat30Blacksmith` | — | public |
| 673 | `_HasBlacksmithOnScreen` | `goalSequence` | private |

### scenarios\campaign\hundred\hun_chp1_paris\hun_chp1_paris_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `Paris_InitData1` | — | public |
| 130 | `Paris_InitData2` | — | public |
| 171 | `LoadUnitTables` | — | public |
| 501 | `GetRecipe` | — | public |
| 1156 | `Paris_SetupWaves` | — | public |

### scenarios\campaign\hundred\hun_chp1_paris\hun_chp1_paris_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Paris_InitObjectives` | — | public |
| 75 | `Wallingford_RetreatDeath` | — | public |

### scenarios\campaign\hundred\hun_chp1_paris\hun_chp1_paris_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Paris_AddHintIncendiaryArrows` | — | public |
| 33 | `ResearchFireArrowsTrigger` | `goalSequence` | public |
| 47 | `ReasearchFireArrowsIgnore` | `goalSequence` | public |
| 54 | `PlayerResearchingIncendiary` | — | public |
| 74 | `UserIsSelectingArsenal` | `goal` | public |
| 80 | `PlayerIsResearchingIncendiary` | `goal` | public |
| 102 | `FindEntityOnScreen` | `scar_type` | public |
| 116 | `UserIsSelectingBuilding` | `building` | public |
| 131 | `Paris_AddHintToRepair` | — | public |
| 152 | `CheckIgnore` | `goalSequence` | public |
| 164 | `BuildingIsDamaged` | `goalSequence` | public |
| 188 | `UserIsRepairing` | `goal` | public |
| 198 | `RepairBypass` | `goalSequence` | public |

### scenarios\campaign\hundred\hun_chp1_paris\hun_chp1_paris.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Mission_SetupPlayers` | — | public |
| 29 | `Mission_SetupVariables` | — | public |
| 33 | `Mission_Preset` | — | public |
| 79 | `Mission_Start` | — | public |
| 116 | `Paris_MainLoop` | `context` | public |
| 120 | `Paris_StrongerInvaders` | `context` | public |
| 127 | `Paris_InvasionStart` | `context` | public |
| 138 | `Paris_InvasionStartLane` | `context, data` | public |
| 152 | `Paris_InvasionStartStone` | `context` | public |
| 159 | `Paris_InvasionStartGold` | `context` | public |
| 166 | `Paris_LaneHalfComplete` | `lane` | public |
| 196 | `Paris_StartReinforcingStandby` | `context, data` | public |
| 204 | `Paris_SpawnDefender` | `context, data` | public |
| 210 | `Paris_PrepareIntroWave` | `context, data` | public |
| 228 | `Paris_LaneComplete` | `lane` | public |
| 236 | `Paris_InvasionComplete` | — | public |
| 249 | `Paris_MoveUpDefenders` | — | public |
| 258 | `Paris_MoveUpStaging` | — | public |
| 269 | `Paris_StartNewObjective` | `context` | public |
| 273 | `Paris_StartSiege` | — | public |
| 317 | `Paris_Prepare` | `context, data` | public |
| 353 | `Paris_PrepareBonus` | `bonus_index, bonus_lane` | public |
| 362 | `Paris_Launch` | `context, data` | public |
| 394 | `Paris_AutoSave` | `context, data` | public |
| 398 | `Paris_LaunchBonus` | `lane` | public |
| 412 | `Paris_MonitorWaves` | `context, data` | public |
| 439 | `Paris_CalculateUnitsKilled` | — | public |
| 453 | `Paris_MonitorReinforcements` | — | public |
| 468 | `Paris_ContainsRams` | `units` | public |
| 478 | `Paris_ReinforceFromMapEdge` | `module, threshold` | public |
| 509 | `Paris_OnCompleteMapEdgeReinforcements` | `reinforcements` | public |
| 518 | `Paris_OnDeathMapEdgeReinforcements` | `reinforcements` | public |
| 528 | `Paris_ReinforceDynamically` | `module, threshold` | public |
| 601 | `MonitorDynamicReinforcements` | `context, data` | public |
| 628 | `Paris_OnCompleteDynamicReinforcements` | `reinforcements` | public |
| 657 | `Paris_OnDeathDynamicReinforcements` | `reinforcements` | public |
| 669 | `Paris_PreVictoryInvader` | `module` | public |
| 691 | `Paris_OnCompleteInvader` | `module` | public |
| 700 | `Paris_OnCompleteStone` | `module` | public |
| 705 | `Paris_OnCompleteGold` | `module` | public |
| 710 | `Paris_OnCompleteStaging` | `module` | public |
| 718 | `Paris_GetWaveUnits` | `wave_number` | public |
| 722 | `Paris_GetWaveUnitsBonus` | `wave_number, index` | public |
| 726 | `Paris_GetDefenderTargets` | `lane, defend_number` | public |
| 732 | `Paris_MoveIntroUnits` | — | public |
| 765 | `Paris_MoveGateArchers` | — | public |
| 773 | `Paris_InitOutro` | — | public |
| 844 | `Paris_AddWaveUI` | `context, data` | public |
| 851 | `WallsBreached` | `context` | public |
| 859 | `LandmarkUnderAttack` | `context` | public |

### scenarios\campaign\hundred\hun_chp2_cocherel\diplomacy_chp2_cocherel.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Diplomacy_DiplomacyEnabled` | `is_enabled` | public |
| 118 | `Diplomacy_TributeEnabled` | `is_enabled` | public |
| 126 | `Diplomacy_OnInit` | — | public |
| 133 | `Diplomacy_Start` | — | public |
| 155 | `Diplomacy_OnGameOver` | — | public |
| 163 | `Diplomacy_OnGameRestore` | — | public |
| 176 | `Diplomacy_ToggleDiplomacyUI` | — | public |
| 194 | `Diplomacy_ShowDiplomacyUI` | `show` | public |
| 201 | `Diplomacy_HideDiplomacyUI` | `context` | public |
| 209 | `Diplomacy_ChangeRelation` | `parameter` | public |
| 215 | `Diplomacy_IncreaseTribute` | `parameter` | public |
| 226 | `Diplomacy_DecreaseTribute` | `parameter` | public |
| 237 | `Diplomacy_ClearTribute` | — | public |
| 250 | `Diplomacy_SendTribute` | — | public |
| 269 | `Diplomacy_ShowUI` | `show` | public |
| 283 | `Diplomacy_OnRelationshipChanged` | `observerPlayerID, targetPlayerID, show_notification` | public |
| 326 | `Diplomacy_OnConstructionComplete` | `context` | public |
| 342 | `Diplomacy_OnPlayerDefeated` | `player, reason` | public |
| 366 | `Diplomacy_OnPlayerNameChanged` | `context` | public |
| 378 | `Diplomacy_OnUpgradeComplete` | `context` | public |
| 399 | `Diplomacy_UpdateDataContext` | — | public |
| 496 | `Diplomacy_UpdateNameColours` | — | public |
| 512 | `Diplomacy_OverridePlayerSettings` | `playerID, is_player_visible, is_tribute_visible, is_food_enabled, is_wood_enabled, is_gold_enabled, is_stone_enabled` | public |
| 530 | `Diplomacy_OverrideSettings` | `is_tribute_enabled, is_subtotal_visible, is_score_visible, is_team_visible` | public |
| 541 | `Diplomacy_RelationConverter` | `relation` | public |
| 563 | `Diplomacy_RelationToTooltipConverter` | `observer, target` | public |
| 587 | `Diplomacy_GetTaxRate` | `playerID` | public |
| 593 | `Diplomacy_SetTaxRate` | `playerID, tax_rate` | public |
| 600 | `Diplomacy_AddTribute` | `player_index, resource_index, amount` | public |
| 636 | `Diplomacy_CreateDataContext` | — | public |
| 717 | `Diplomacy_FormatTeamNumber` | `team_number` | public |
| 726 | `Diplomacy_SortDataContext` | — | public |
| 739 | `Diplomacy_CreateUI` | — | public |
| 1172 | `Diplomacy_RemoveUI` | — | public |
| 1181 | `Diplomacy_UpdateUI` | — | public |
| 1188 | `Rule_Diplomacy_UpdateUI` | — | public |
| 1195 | `Diplomacy_Restart` | — | public |
| 1202 | `Diplomacy_ShowEventCue` | `tribute` | public |
| 1230 | `Diplomacy_ChangeRelationNtw` | `playerID, data` | public |
| 1245 | `Diplomacy_SendTributeNtw` | `playerID, data` | public |

### scenarios\campaign\hundred\hun_chp2_cocherel\hun_chp2_cocherel.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 19 | `Mission_OnGameSetup` | — | public |
| 33 | `Mission_SetupPlayers` | — | public |
| 71 | `Mission_PreInit` | — | public |
| 75 | `Mission_SetupVariables` | — | public |
| 214 | `Mission_SetRestrictions` | — | public |
| 219 | `Mission_Preset` | — | public |
| 285 | `Mission_SetDifficulty` | — | public |
| 315 | `Mission_PreInit` | — | public |
| 322 | `Mission_Start` | — | public |
| 377 | `Cocherel_Mainloop` | — | public |
| 381 | `GetRecipe` | — | public |
| 1330 | `FoundCocherelCamp` | — | public |
| 1339 | `FoundRoutiersCamp` | — | public |
| 1352 | `FoundCroisyCamp` | — | public |
| 1360 | `Villagers_a_attack` | — | public |
| 1366 | `Villagers_b_attack` | — | public |
| 1372 | `Villagers_c_attack` | — | public |
| 1384 | `FranceChaos_MoveStartingUnits` | — | public |
| 1422 | `Mission_CheckTC` | — | public |
| 1433 | `Routiers_ShowTributeMenu` | — | public |
| 1446 | `Routiers_HideTributeMenu` | — | public |
| 1452 | `RebuildTC_Villagers` | — | public |
| 1479 | `MoveRoutiersIntroOut` | — | public |
| 1484 | `MoveRoutiersIntroOut_PartB` | — | public |
| 1490 | `MonitorRoutiersIntro` | — | public |
| 1498 | `Rebuildvillage` | — | public |
| 1519 | `CleanIntroSkipped` | — | public |
| 1552 | `CheckRepairStatusTC` | — | public |
| 1565 | `CheckRepairStatusHouse` | — | public |
| 1585 | `CounterMonks` | — | public |
| 1629 | `MoveJouyUnit01` | — | public |
| 1647 | `MoveJouyUnit02` | — | public |
| 1665 | `MoveCroisyUnit01` | — | public |
| 1681 | `MoveCroisyUnit02` | — | public |
| 1697 | `MoveCocherelUnits01` | — | public |
| 1715 | `MoveRoutiersKnights` | — | public |
| 1731 | `SetupAttackWaves` | — | public |
| 1926 | `Monitor_PlayerFoundSecret` | — | public |
| 1950 | `CheckRoutierslooted` | — | public |

### scenarios\campaign\hundred\hun_chp2_cocherel\obj_capture_frenchtowns.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `CaptureFrenchVillages_InitStemRebel` | — | public |
| 21 | `CaptureFrenchVillages_InitJouy` | — | public |
| 66 | `CaptureFrenchVillages_InitCroisy` | — | public |
| 113 | `CaptureFrenchVillages_InitCocherel` | — | public |
| 151 | `StemRebel_OnComplete` | — | public |
| 159 | `CaptureJouy_OnComplete` | — | public |
| 182 | `CaptureCroisy_OnComplete` | — | public |
| 204 | `StartAttacks_CocherelToJouyOrCroisy` | — | public |
| 211 | `PrepareWave_CocherelToJouyOrCroisy` | — | public |
| 243 | `CaptureCocherel_OnComplete` | — | public |
| 294 | `StartAttacks_JouyOrCroisyToCocherel` | — | public |
| 302 | `PrepareWave_JouyOrCroisyToCocherel` | — | public |
| 324 | `DestroyWallCocherel_EntityKill` | `context` | public |
| 338 | `MonitorRebelsAttackJouyOrCroisy` | — | public |

### scenarios\campaign\hundred\hun_chp2_cocherel\obj_find_relics.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `FindRelics_InitObjectives` | — | public |
| 46 | `Findrelics_SetUI` | — | public |
| 52 | `Findrelics_Start` | — | public |
| 63 | `FindRelics_OnAbilityExecuted` | `context` | public |
| 88 | `Findrelics_Monitor` | — | public |
| 102 | `Findrelics_OnComplete` | — | public |

### scenarios\campaign\hundred\hun_chp2_cocherel\obj_kill_charlesarmy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `DefeatCharlesBadArmy_InitObjectives` | — | public |
| 52 | `DefeatCharlesBadArmy_InitObjectives_PartB` | — | public |
| 60 | `DefeatCharlesBadArmy_OnStart` | — | public |
| 104 | `SendNavarreArchersFormation` | — | public |
| 108 | `EnemyKilledCharlesEvent` | `context` | public |
| 126 | `DefeatCharlesBad_MusicChange` | — | public |
| 131 | `StartCharlesAttacks` | — | public |
| 137 | `PrepareCharlesWaveToCocherel` | — | public |
| 158 | `DefeatCharlesBadArmy_IsComplete` | — | public |
| 188 | `LetObjectiveComplete` | — | public |
| 192 | `SendOutroCharlesArmy` | — | public |
| 223 | `French_celebrateMove` | `context, data` | public |
| 234 | `DiscoverCharlesCamp_Monitor` | — | public |
| 249 | `DiscoverCharlesCamp` | `revealTime, speechEvent` | public |
| 257 | `DiscoverCharlesCamp_MusicChange` | — | public |
| 262 | `DefeatCharlesBadArmy_ObjectiveCheat` | — | public |

### scenarios\campaign\hundred\hun_chp2_cocherel\obj_optional_killroutiers.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `DefeatRoutiers_InitObjectives` | — | public |
| 56 | `Routiers_AttackInit` | — | public |
| 64 | `StartRoutiers` | — | public |
| 71 | `PrepareWave_RoutiersToPlayerBase` | — | public |
| 114 | `CheckRoutiersSquadSent` | — | public |
| 126 | `StartRoutierAttacksOnCocherel` | — | public |
| 132 | `PrepareWave_RoutiersToCocherel` | — | public |
| 149 | `RepelRoutiersAttackComplete` | — | public |
| 158 | `PayTributeRoutiers_SetupUI` | — | public |
| 164 | `PayTributeRoutiers_Complete` | — | public |
| 182 | `Routiers_SpawnGivenGold` | `amount` | public |
| 196 | `SendGoldRoutiers_Start` | — | public |
| 205 | `KillRoutiers_UI` | — | public |
| 212 | `KillRoutiers_Start` | — | public |
| 218 | `RoutiersKilledEvent` | `context` | public |
| 240 | `DestroyRoutiersBuildings_UI` | — | public |
| 248 | `DestroyRoutiersBuildings_Start` | — | public |
| 252 | `DefeatRoutiersBuildings_OnEntityKilled` | `context` | public |
| 277 | `DestroyRoutiersBuildings_OnComplete` | — | public |
| 295 | `Mission_OnTributeSent` | `tribute` | public |

### scenarios\campaign\hundred\hun_chp2_cocherel\obj_protect_monastery.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `ProtectMonastery_InitObjectives` | — | public |
| 38 | `ProtectMonastery_IsComplete` | — | public |
| 42 | `ProtectMonastery_OnComplete` | — | public |
| 47 | `ProtectMonastery_Start` | — | public |
| 53 | `StartProtectMonastery_Obj` | — | public |
| 57 | `CheckMonasteryIsAttacked` | — | public |
| 65 | `ProtectMonastery_UI` | — | public |
| 71 | `ProtectMonastery_IsFailed` | — | public |
| 81 | `ProtectMonastery_OnFail` | — | public |

### scenarios\campaign\hundred\hun_chp2_pontvallain\hun_chp2_pontvallain_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `Pontvallain_InitData1` | — | public |
| 147 | `Pontvallain_InitData2` | — | public |
| 173 | `GetRecipe` | — | public |
| 326 | `Pontvallain_SetupWaves` | — | public |

### scenarios\campaign\hundred\hun_chp2_pontvallain\hun_chp2_pontvallain_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `Pontvallain_InitObjectives` | — | public |

### scenarios\campaign\hundred\hun_chp2_pontvallain\hun_chp2_pontvallain_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Pontvallain_AddHintTrade` | — | public |
| 33 | `TradeTrigger` | `goalSequence` | public |
| 49 | `TradeIgnore` | `goalSequence` | public |
| 53 | `UserIsSelectingTrader` | `goal` | public |
| 58 | `UserIsTrading` | `goal` | public |
| 67 | `FindSquadOnScreen` | `scar_type` | public |
| 79 | `UserIsSelectingSquadType` | `squadType` | public |

### scenarios\campaign\hundred\hun_chp2_pontvallain\hun_chp2_pontvallain.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Mission_SetupPlayers` | — | public |
| 40 | `Mission_SetupVariables` | — | public |
| 45 | `Mission_SetRestrictions` | — | public |
| 55 | `Mission_Preset` | — | public |
| 123 | `Pontvallain_IntroMoveScout` | — | public |
| 137 | `Pontvallain_IntroMoveScout_2` | — | public |
| 142 | `Mission_Start` | — | public |
| 187 | `Pontvallain_EnemyArrives` | `context, data` | public |
| 195 | `Pontvallain_MoveEnglish` | `i` | public |
| 204 | `Pontvallain_StartObjective` | — | public |
| 208 | `Pontvallain_StartRaid` | `context, data` | public |
| 232 | `Pontvallain_MonitorRaid` | `context, data` | public |
| 243 | `Pontvallain_RaidDead` | `module` | public |
| 268 | `Pontvallain_StartArmies` | — | public |
| 276 | `Pontvallain_StartArmy` | `context, data` | public |
| 294 | `Pontvallain_MonitorArmy` | `context, data` | public |
| 305 | `Pontvallain_ArmyDead` | `module` | public |
| 343 | `Pontvallain_SetMusicTense` | — | public |
| 348 | `FindBandits` | — | public |
| 355 | `Pontvallain_RemovePath` | `context, data` | public |
| 360 | `Pontvallain_OnConstructionComplete` | `context` | public |
| 376 | `Pontvallain_ShowBuildObjective` | `context` | public |
| 387 | `SpawnOutroUnits` | — | public |
| 426 | `SpawnOutroRiders` | — | public |

### scenarios\campaign\hundred\hun_chp2_pontvallain\hun_chp2_pontvallain\obj_destroy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Destroy_InitObjectives` | — | public |

### scenarios\campaign\hundred\hun_chp3_orleans\hun_chp3_orleans_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `Orleans_InitData1` | — | public |
| 172 | `Orleans_InitData2` | — | public |
| 200 | `GetRecipe` | — | public |
| 963 | `Orleans_SetupWaves` | — | public |

### scenarios\campaign\hundred\hun_chp3_orleans\hun_chp3_orleans_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `Orleans_InitObjectives` | — | public |

### scenarios\campaign\hundred\hun_chp3_orleans\hun_chp3_orleans_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Orleans_AddJoanAbilityHint_Xbox` | — | public |
| 40 | `Orleans_AddJoanAbilityHint` | — | public |
| 65 | `UserHasSelectedJoan` | `goal` | public |
| 70 | `Predicate_UserHasLookedAtJoansAbility` | `goal` | public |
| 76 | `Predicate_JoanIsAlive` | `goalSequence` | public |

### scenarios\campaign\hundred\hun_chp3_orleans\hun_chp3_orleans.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Mission_SetupPlayers` | — | public |
| 51 | `Mission_SetupVariables` | — | public |
| 56 | `Mission_Preset` | — | public |
| 91 | `Mission_Start` | — | public |
| 145 | `Orleans_MainLoop` | — | public |
| 149 | `Orleans_ManualWaveLaunch` | `context, data` | public |
| 157 | `Orleans_StartObjectiveTourelles` | `context, data` | public |
| 161 | `Orleans_TryWavePrepare` | `context, data` | public |
| 183 | `Orleans_PrepareLane` | `lane, units` | public |
| 189 | `Orleans_ChooseLane` | `lanes` | public |
| 229 | `Orleans_StartTradeCycle` | — | public |
| 235 | `Orleans_PrepareRaidAndQueueTraders` | — | public |
| 246 | `Orleans_StartObjectiveTrade` | `context, data` | public |
| 253 | `Orleans_PrepareTradeAmbush` | — | public |
| 276 | `Orleans_SpawnTradeCart` | — | public |
| 286 | `Orleans_AmbushDead` | — | public |
| 294 | `Orleans_CheckDespawn` | — | public |
| 329 | `Orleans_TradersGoHome` | `group_id, item_index, item_id` | public |
| 334 | `Orleans_ClearMarkerPath` | — | public |
| 342 | `Orleans_CheckNorthForts` | `context` | public |
| 364 | `Orleans_CheckSouthForts` | `context` | public |
| 385 | `Orleans_CheckTourelles` | `context` | public |
| 392 | `Orleans_CheckBridge` | `context` | public |
| 399 | `Orleans_KeepUnderAttack` | `context` | public |
| 407 | `Orleans_MoveIntroUnits` | — | public |
| 414 | `TourellesIntro` | — | public |
| 421 | `MoveIntroCrossbow3` | — | public |
| 427 | `MoveIntroCrossbow4` | — | public |
| 432 | `MoveIntroCrossbow6` | — | public |
| 437 | `MoveIntroCrossbow7` | — | public |
| 442 | `MoveJoan` | — | public |
| 464 | `Orleans_GetPower` | `seconds` | public |
| 475 | `Orleans_GetWaveUnits` | `categories, power_max, lane` | public |
| 589 | `Orleans_PickUnitType` | `unit_types, weight_table, max_power, forced_pick` | public |
| 613 | `Orleans_OnLaunch` | `queue_wave, wave` | public |
| 618 | `Orleans_OnLaunchAmbush` | `queue_wave, wave` | public |
| 622 | `RemoveTownCenterFromCategories` | `categories` | public |
| 630 | `Orleans_Autosave` | `context, data` | public |
| 634 | `Orleans_GetWaveInterval` | — | public |

### scenarios\campaign\hundred\hun_chp3_patay\diplomacy_chp3_patay.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Diplomacy_DiplomacyEnabled` | `is_enabled` | public |
| 126 | `Diplomacy_TributeEnabled` | `is_enabled` | public |
| 134 | `Diplomacy_OnInit` | — | public |
| 141 | `Diplomacy_Start` | — | public |
| 163 | `Diplomacy_OnGameOver` | — | public |
| 171 | `Diplomacy_OnGameRestore` | — | public |
| 182 | `Diplomacy_ToggleDiplomacyUI` | — | public |
| 197 | `Diplomacy_ShowDiplomacyUI` | `show` | public |
| 209 | `Diplomacy_ChangeRelation` | `parameter` | public |
| 215 | `Diplomacy_IncreaseTribute` | `parameter` | public |
| 226 | `Diplomacy_DecreaseTribute` | `parameter` | public |
| 237 | `Diplomacy_ClearTribute` | — | public |
| 250 | `Diplomacy_SendTribute` | — | public |
| 269 | `Diplomacy_ShowUI` | `show` | public |
| 280 | `Diplomacy_IsExpanded` | — | public |
| 286 | `Diplomacy_OnConstructionComplete` | `context` | public |
| 302 | `Diplomacy_OnPlayerDefeated` | `player, reason` | public |
| 326 | `Diplomacy_OnPlayerNameChanged` | `context` | public |
| 338 | `Diplomacy_OnUpgradeComplete` | `context` | public |
| 359 | `Diplomacy_UpdateDataContext` | — | public |
| 448 | `Diplomacy_OverridePlayerSettings` | `playerID, is_player_visible, is_tribute_visible, is_food_enabled, is_wood_enabled, is_gold_enabled, is_stone_enabled` | public |
| 465 | `Diplomacy_OverrideSettings` | `is_tribute_enabled, is_subtotal_visible, is_score_visible, is_team_visible` | public |
| 474 | `Diplomacy_GetTaxRate` | `playerID` | public |
| 479 | `Diplomacy_SetTaxRate` | `playerID, tax_rate` | public |
| 486 | `Diplomacy_AddTribute` | `player_index, resource_index, amount` | public |
| 522 | `Diplomacy_CreateDataContext` | — | public |
| 592 | `Diplomacy_FormatTeamNumber` | `team_number` | public |
| 601 | `Diplomacy_SortDataContext` | — | public |
| 614 | `Diplomacy_CreateUI` | — | public |
| 865 | `Diplomacy_RemoveUI` | — | public |
| 873 | `Diplomacy_UpdateUI` | — | public |
| 880 | `Rule_Diplomacy_UpdateUI` | — | public |
| 887 | `Diplomacy_Restart` | — | public |
| 894 | `Diplomacy_ShowEventCue` | `tribute` | public |
| 921 | `Diplomacy_SendTributeNtw` | `playerID, data` | public |

### scenarios\campaign\hundred\hun_chp3_patay\hun_chp3_patay_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `Patay_Data_Init` | — | public |
| 336 | `GetRecipe` | — | public |

### scenarios\campaign\hundred\hun_chp3_patay\hun_chp3_patay_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 10 | `UserHasOpenedTheDiplomacyMenu` | — | public |
| 17 | `UserHasZeroGold` | — | public |
| 24 | `ShouldRemindToSendGold` | `goalSequence` | public |
| 33 | `ShouldPromptUserToSendGold` | `goalSequence` | public |
| 46 | `TrainingGoal_AddSendGold` | — | public |
| 61 | `TrainingGoal_EnableSendGold` | — | public |
| 65 | `TrainingGoal_DisableSendGold` | — | public |

### scenarios\campaign\hundred\hun_chp3_patay\hun_chp3_patay.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `Mission_SetupPlayers` | — | public |
| 78 | `Mission_SetupVariables` | — | public |
| 85 | `Mission_SetRestrictions` | — | public |
| 95 | `Mission_SetDifficulty` | — | public |
| 106 | `Mission_PreInit` | — | public |
| 110 | `Patay_ShowTributeMenu` | — | public |
| 114 | `Patay_SetPopulationCapVisibility` | `visibility` | public |
| 124 | `Patay_HideTributeMenu` | — | public |
| 130 | `Patay_CheckReinforcePanel` | — | public |
| 149 | `Patay_CheckDiplomacyReminder` | — | public |
| 162 | `Patay_EnableSendGoldHint` | — | public |
| 169 | `Mission_Preset` | — | public |
| 212 | `Mission_Start` | — | public |
| 238 | `Patay_CheckMissionFail` | — | public |
| 257 | `Patay_CombatIntensityIntro` | — | public |
| 261 | `Patay_StartRearguardPursuit` | — | public |
| 273 | `Patay_DisbandRearguard` | — | public |
| 287 | `Patay_CheckHasLeftAmbushArea` | — | public |
| 299 | `Patay_CheckRearguardDespawn` | — | public |
| 313 | `Patay_CheckSigmundTrigger` | — | public |
| 322 | `Patay_CheckPatayTrigger` | — | public |
| 335 | `Patay_CheckClearRoadTrigger` | — | public |
| 344 | `Patay_CheckAmbushTrigger` | — | public |
| 373 | `Patay_CheckStSigmundTrigger` | — | public |
| 383 | `Patay_CheckMainBattleTrigger` | — | public |
| 395 | `Patay_CheckMainBattleStartTrigger` | — | public |
| 410 | `Patay_CheckSigmundFail` | — | public |
| 430 | `Patay_StartRoadPatrol` | — | public |
| 437 | `Patay_CheckRoadPatrol` | — | public |
| 444 | `Patay_MergeRoadPatrol` | — | public |
| 449 | `Patay_AddArmyTarget` | `moduleName, sgroup, target` | public |
| 455 | `Patay_AddArmyTargets` | `moduleName, sgroup, targets` | public |
| 481 | `Patay_JoanCav_Cheer` | — | public |
| 490 | `Patay_CheckDepartTrigger` | — | public |
| 499 | `Patay_CheckPatayDefendTrigger` | — | public |
| 514 | `Patay_CheckSigmundRetreatTrigger` | — | public |
| 528 | `Patay_MergeRetreatIntoRegiment1` | — | public |
| 541 | `Patay_SetGoldValue` | — | public |
| 549 | `Patay_InitStartingUnits` | — | public |
| 559 | `Patay_SpawnTestArcher` | — | public |
| 566 | `Patay_SpawnJoanCav` | — | public |
| 593 | `Patay_SpawnSigmundReserve` | — | public |
| 610 | `Patay_SpawnAmbush` | — | public |
| 624 | `Patay_SpawnUnitCluster` | `markerName, numPerMarker, unitType, masterSgroup` | public |
| 632 | `Patay_StartDefeatArmy` | — | public |
| 638 | `Patay_SetRegimentUnitData` | — | public |
| 659 | `Patay_BeginMainBattle` | — | public |
| 682 | `Patay_SpawnRegiment` | `context, data` | public |
| 712 | `Patay_SetBattleProgress` | `initCount, currentCount, threshold` | public |
| 726 | `Patay_ProcessMainBattle` | — | public |
| 768 | `Patay_CheckBattleGroup` | `num` | public |
| 794 | `Patay_StartClearRegiments` | — | public |
| 798 | `Patay_InitPatay` | — | public |
| 817 | `Patay_CheckAllyFlee` | — | public |
| 855 | `Patay_TakeControlOfPatay` | — | public |
| 902 | `Patay_BeginChasePhase` | — | public |
| 946 | `Patay_CheckScatterGroups` | — | public |
| 979 | `Patay_CheckRegiments` | — | public |
| 987 | `Patay_CheckRegiment` | `objective, data` | public |
| 1036 | `Patay_CheerRegiment1` | `context,data` | public |
| 1048 | `Patay_CheerRegiment2` | `context,data` | public |
| 1060 | `Patay_CheerRegiment3` | `context,data` | public |
| 1072 | `Patay_WakeRegiment1` | — | public |
| 1078 | `Patay_WakeRegiment2` | — | public |
| 1083 | `Patay_WakeRegiment3` | — | public |
| 1088 | `Patay_ActivateRegiment` | `data` | public |
| 1097 | `Patay_MergeRegiment` | `data` | public |
| 1117 | `Patay_MoveStartingUnits1` | — | public |
| 1139 | `Patay_MoveStartingUnits2` | — | public |
| 1162 | `Patay_ReverseSpeedMod` | — | public |
| 1178 | `Patay_TriggerOutro` | — | public |
| 1182 | `Patay_RestartMusic` | — | public |
| 1187 | `Patay_RestartMusicCombat` | — | public |
| 1194 | `Patay_SetUpOutro` | — | public |
| 1212 | `Patay_MergeReserveIntoSigmund` | — | public |
| 1219 | `Patay_MergeIntoSigmund` | — | public |
| 1228 | `Patay_OnSquadKilled` | `context` | public |
| 1302 | `Tribute_Intel` | — | public |
| 1317 | `Patay_InitDebug` | — | public |
| 1338 | `Patay_CheckGoldPickupsLooted` | — | public |

### scenarios\campaign\hundred\hun_chp3_patay\obj_defeat_english.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `DefeatEnglish_InitObjectives` | — | public |
| 206 | `DefeatEnglish_StartStSigmund` | — | public |

### scenarios\campaign\hundred\hun_chp3_patay\obj_reinforcements.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `UI_ReinforcePanel_UpdateData` | — | public |
| 77 | `UI_RequestAid_ButtonCallback` | `parameter` | public |
| 109 | `UI_RequestAid_EventCue` | — | public |
| 117 | `UI_RequestAid_MoveCamera` | — | public |
| 123 | `Start_IntelCooldown` | `target, reserve` | public |
| 139 | `ReinforceIntel_Cooldown` | — | public |

### scenarios\campaign\hundred\hun_chp4_formigny\hun_chp4_formigny_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `Formigny_InitData1` | — | public |
| 192 | `Formigny_InitData2` | — | public |
| 290 | `GetRecipe` | — | public |

### scenarios\campaign\hundred\hun_chp4_formigny\hun_chp4_formigny.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `Mission_SetupPlayers` | — | public |
| 56 | `Mission_SetupVariables` | — | public |
| 60 | `Mission_SetRestrictions` | — | public |
| 64 | `Mission_Preset` | — | public |
| 124 | `Mission_SetDifficulty` | — | public |
| 127 | `Mission_Start` | — | public |
| 152 | `SetupIntroUnitsEnemy` | — | public |
| 205 | `SpawnUnitsAndMoveAlongPath` | `player, units, sgroup, path_marker_name, path_start_index, path_index_end` | public |
| 216 | `StartIntroSkipped` | — | public |
| 238 | `WarpSgroupToPathMarker` | `sgroup, path_marker_name, negative_index` | public |
| 244 | `IntroMovePlayerUnits` | — | public |
| 252 | `PutEnemiesIntoModules` | — | public |
| 259 | `FindNewTargetForModule` | `module` | public |
| 269 | `SpawnPlayerArmy` | — | public |
| 274 | `Transition` | — | public |
| 288 | `SpawnEnemyArmy` | — | public |
| 310 | `SpawnValognesUnits` | — | public |
| 324 | `GiveEnemyAmbushVision` | — | public |
| 334 | `SpawnRemainingUnits` | `modules, units_remaining, unit_type, add_to_group` | public |
| 360 | `SetPailingsArchers` | — | public |
| 369 | `FranceMoveOnFormigny` | — | public |
| 420 | `Achievement_OnCannonDeath` | `context` | public |
| 432 | `CheckAchievementCompletion` | — | public |

### scenarios\campaign\hundred\hun_chp4_formigny\obj_captureformigny.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `InitObjectives_CaptureFormigny` | — | public |
| 68 | `CheckForFinalFight` | — | public |

### scenarios\campaign\hundred\hun_chp4_formigny\obj_clearnormandy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `InitObjectives_ClearNormandy` | — | public |
| 102 | `MonitorBattlefield` | — | public |
| 150 | `SpawnCannons` | — | public |
| 171 | `StartFrenzy` | — | public |
| 181 | `StartFrenzyForModule` | `module` | public |
| 187 | `EndFrenzy` | — | public |
| 200 | `EndFrenzyForModule` | `module` | public |
| 209 | `BretonsCanBeSpawned` | — | public |
| 213 | `SpawnBretons` | — | public |
| 236 | `Pivot` | — | public |
| 263 | `Retreat` | — | public |
| 296 | `CheckForBattle` | — | public |
| 320 | `CheckForBattleFrenzy` | — | public |
| 340 | `CheckForBattlePivot` | — | public |
| 360 | `MicroArmy` | `modules, sg_opponent_in_zone` | public |
| 371 | `SendArmyBack` | `modules` | public |
| 380 | `SendArmyBackFrenzy` | `modules` | public |
| 389 | `SendArmyBackPivot` | `modules` | public |
| 398 | `SetModuleAggression` | `module, attackMoveEnRoute, largeRange` | public |
| 418 | `Monitor_PlayerFoundSecret` | — | public |
| 436 | `Monitor_BricQuebecVillage` | — | public |
| 445 | `Monitor_StSauveurVillage` | — | public |
| 453 | `Monitor_MonasteryTown` | — | public |
| 462 | `Monitor_ReachedFormignyArea` | — | public |
| 469 | `CheckCannonArrival` | — | public |
| 477 | `CheckForEnemyCrossingRiver` | — | public |
| 485 | `Monitor_Player1Dead` | — | public |
| 497 | `DestroyWallTown02_EntityKill` | `context` | public |
| 509 | `DestroyWallFormigny_EntityKill` | `context` | public |
| 524 | `RemoveBlipWhenNearMarker` | `context, data` | public |
| 531 | `StartObj_KillKyriellArmy` | — | public |
| 535 | `ChangeMusic_KillKyriellArmy` | — | public |
| 540 | `StartFormignyCapture` | — | public |
| 546 | `CaptureFormigny_music_change` | — | public |

### scenarios\campaign\hundred\hun_chp4_formigny\obj_opt_save_village.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `InitObjectives_SaveValognes` | — | public |
| 69 | `Monitor_ValognesApproach` | — | public |
| 78 | `StartValogneObjective` | — | public |
| 82 | `UnRevealValogne` | — | public |

### scenarios\campaign\hundred\hun_chp4_formigny\obj_stopthem.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `InitObjectives_IntroObjectives` | — | public |

### scenarios\campaign\hundred\hun_chp4_formigny\training_formigny.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Tutorials_formigny_SellResources` | — | public |
| 35 | `Predicate_setKeySellResources` | `goalSequence` | public |
| 46 | `Predicate_sellResources` | `goal` | public |

### scenarios\campaign\hundred\hun_chp4_rouen\diplomacy_rouen.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Diplomacy_DiplomacyEnabled` | `is_enabled` | public |
| 131 | `Diplomacy_TributeEnabled` | `is_enabled` | public |
| 139 | `Diplomacy_OnInit` | — | public |
| 146 | `Diplomacy_Start` | — | public |
| 168 | `Diplomacy_OnGameOver` | — | public |
| 176 | `Diplomacy_OnGameRestore` | — | public |
| 188 | `Diplomacy_ToggleDiplomacyUI` | — | public |
| 203 | `Diplomacy_ShowDiplomacyUI` | `show` | public |
| 215 | `Diplomacy_ChangeRelation` | `parameter` | public |
| 221 | `Diplomacy_IncreaseTribute` | `parameter` | public |
| 232 | `Diplomacy_DecreaseTribute` | `parameter` | public |
| 243 | `Diplomacy_ClearTribute` | — | public |
| 256 | `Diplomacy_SendTribute` | — | public |
| 275 | `Diplomacy_ShowUI` | `show` | public |
| 289 | `Diplomacy_OnRelationshipChanged` | `observerPlayerID, targetPlayerID, show_notification` | public |
| 332 | `Diplomacy_OnConstructionComplete` | `context` | public |
| 348 | `Diplomacy_OnPlayerDefeated` | `player, reason` | public |
| 372 | `Diplomacy_OnPlayerNameChanged` | `context` | public |
| 384 | `Diplomacy_OnUpgradeComplete` | `context` | public |
| 404 | `Diplomacy_UpdateDataContext` | — | public |
| 495 | `Diplomacy_OverridePlayerSettings` | `playerID, is_player_visible, is_tribute_visible, is_food_enabled, is_wood_enabled, is_gold_enabled, is_stone_enabled` | public |
| 513 | `Diplomacy_OverrideSettings` | `is_tribute_enabled, is_subtotal_visible, is_score_visible, is_team_visible` | public |
| 524 | `Diplomacy_RelationConverter` | `relation` | public |
| 546 | `Diplomacy_RelationToTooltipConverter` | `observer, target` | public |
| 570 | `Diplomacy_GetTaxRate` | `playerID` | public |
| 576 | `Diplomacy_SetTaxRate` | `playerID, tax_rate` | public |
| 583 | `Diplomacy_AddTribute` | `player_index, resource_index, amount` | public |
| 619 | `Diplomacy_CreateDataContext` | — | public |
| 700 | `Diplomacy_FormatTeamNumber` | `team_number` | public |
| 709 | `Diplomacy_SortDataContext` | — | public |
| 721 | `Diplomacy_CycleRefreshUI` | — | public |
| 727 | `Diplomacy_CreateUI` | — | public |
| 1014 | `Diplomacy_RemoveUI` | — | public |
| 1022 | `Diplomacy_UpdateUI` | — | public |
| 1029 | `Rule_Diplomacy_UpdateUI` | — | public |
| 1036 | `Diplomacy_Restart` | — | public |
| 1043 | `Diplomacy_ShowEventCue` | `tribute` | public |
| 1071 | `Diplomacy_ChangeRelationNtw` | `playerID, data` | public |
| 1086 | `Diplomacy_SendTributeNtw` | `playerID, data` | public |
| 1147 | `Init_RouenWorkshopUI` | — | public |
| 1210 | `UI_ReinforcePanel_UpdateData` | — | public |
| 1288 | `UI_CameraSnap_ButtonCallback` | `parameter` | public |

### scenarios\campaign\hundred\hun_chp4_rouen\hun_chp4_rouen.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 16 | `Mission_SetupPlayers` | — | public |
| 75 | `Mission_SetupVariables` | — | public |
| 174 | `Mission_SetRestrictions` | — | public |
| 212 | `Mission_PreInit` | — | public |
| 219 | `Mission_Preset` | — | public |
| 284 | `Mission_SetDifficulty` | — | public |
| 308 | `Mission_Start` | — | public |
| 343 | `Monitor_landmarks` | — | public |
| 354 | `Monitor_BBWorkshop` | — | public |
| 361 | `GetRecipe` | — | public |
| 747 | `Init_AttackWaves` | — | public |
| 997 | `ConstructWave` | `waveType, powerMod, siegeOn` | public |
| 1092 | `Send_NorthWave` | `randTime` | public |
| 1110 | `Send_CentralWave` | `randTime` | public |
| 1129 | `Send_SouthWave` | `randTime` | public |
| 1161 | `Manage_AttackWaves` | — | public |
| 1188 | `GetMissionFail` | — | public |
| 1193 | `RetakeNormandy_MoveStartingUnits` | — | public |
| 1209 | `PlayerSkippedIntro_PlaceUnits` | — | public |
| 1214 | `Monitor_TC` | — | public |
| 1222 | `CounterMonks` | — | public |
| 1262 | `GameOver_EarlyDeath` | — | public |
| 1269 | `ApplyPressure_Wave1` | — | public |
| 1276 | `ApplyPressure_Wave2` | — | public |
| 1283 | `ApplyPressure_Wave3` | — | public |
| 1290 | `Anti_Ram` | — | public |
| 1318 | `CelebrateOnPosition` | `pos, range` | public |
| 1327 | `DestroyFieldWall_EntityKill` | `context` | public |
| 1339 | `Achievement_ProduceUpgradedCannon` | `context` | public |

### scenarios\campaign\hundred\hun_chp4_rouen\obj_bbsurvive.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `BBSurvive_InitObjectives` | — | public |

### scenarios\campaign\hundred\hun_chp4_rouen\obj_destroy_rouen.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `RetakeNormandy_InitObjectives` | — | public |
| 96 | `GetCannons_SetUI` | — | public |
| 102 | `GetCannons_Start` | — | public |
| 108 | `GetCannons_Complete` | — | public |
| 113 | `GetCannons_Monitor` | — | public |
| 148 | `Intel_CannonUpgrade` | — | public |
| 157 | `DestroyWalls_UI` | — | public |
| 163 | `DestroyWalls_Start` | — | public |
| 168 | `AddUnitsToDefendRouen` | — | public |
| 204 | `MonitorTown02` | — | public |
| 216 | `SendTown02UnitsOff` | — | public |
| 231 | `MonitorTown03` | — | public |
| 241 | `SendTown03UnitsOff` | — | public |
| 256 | `MonitorTown04` | — | public |
| 267 | `SendTown04UnitsOff` | — | public |
| 284 | `MonitorTown05` | — | public |
| 308 | `SendVillagersDefend05_ToBuildProdBuild` | — | public |
| 322 | `MonitorConstructionDefend5` | — | public |
| 363 | `SendTown05UnitsOff` | — | public |
| 378 | `MonitorTown06` | — | public |
| 390 | `SendTown06UnitsOff` | — | public |
| 406 | `GetNearRouen_Monitor` | — | public |
| 420 | `PlayerGetsInsideRouenNoDestruction` | — | public |
| 438 | `DestroyWallRouen_EntityKill` | `context` | public |
| 476 | `DestroyWalls_OnComplete` | — | public |
| 503 | `StartDestroyLandmarkObj` | — | public |
| 508 | `DestroyLandmarks_UI` | — | public |
| 525 | `DestroyRouenLandmark_EntityKill` | `context` | public |
| 552 | `DestroyLandmarks_OnComplete` | — | public |
| 559 | `RetakeNormandy_OnComplete` | — | public |
| 565 | `WaitFirstSendArmy` | — | public |
| 570 | `MonitorFirstAttackers` | — | public |
| 581 | `ChooseWhereToSendUnitsToPlayer` | — | public |
| 606 | `PrepareWaves` | — | public |
| 830 | `StartNextWave` | — | public |
| 854 | `retrySendingUnitsWaves` | — | public |
| 860 | `FrenchMovesOnTown` | — | public |

### scenarios\campaign\hundred\hun_chp4_rouen\obj_optionals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `ConditionalInit_OptionalObjectives` | — | public |
| 98 | `AssistBrothers_OnStart` | — | public |
| 109 | `AssistBrothers_IsComplete` | — | public |
| 118 | `Intel_AllBonusResearchComplete` | — | public |
| 130 | `CaptureTradeRoute_Optional_Start` | — | public |
| 135 | `TradeRoute_Step1_PlayerProximity_Optional` | — | public |
| 155 | `TradeRoute_Step2_ClearDefenders_Optional` | — | public |
| 176 | `TradeRoute_Step3_AssignTraders_Optional` | — | public |
| 205 | `CaptureTheRiverPort_Optional_Start` | — | public |
| 210 | `RiverPort_Step1_PlayerProximity_Optional` | — | public |
| 224 | `RiverPort_Step2_BurnBuildings_Optional` | — | public |
| 256 | `MineCapture_PlayerProx` | — | public |
| 266 | `StartMain_IfNotStarted` | — | public |
| 272 | `StartTradeRoute_IfNotStarted` | — | public |
| 278 | `StartRiverPort_IfNotStarted` | — | public |
| 284 | `StartMineCap_IfNotStarted` | — | public |
| 290 | `StartOptionals_IfNotStarted` | — | public |

### scenarios\campaign\hundred\hun_chp4_rouen\obj_research.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `RetakeNormandy_Init_ResearchObjectives` | — | public |
| 76 | `CannonResearch_SetupUI` | — | public |
| 84 | `CannonResearch_Start` | — | public |
| 98 | `CannonResearch_IsComplete` | — | public |
| 104 | `CannonResearch_OnComplete` | — | public |
| 121 | `DelayDiplomacyPanel` | — | public |
| 132 | `BuildLandmark_IsComplete` | — | public |

### scenarios\campaign\hundred\hun_chp4_rouen\obj_uni_capture.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `CaptureLocations_InitUniTown` | — | public |

### scenarios\campaign\hundred\hun_chp4_rouen\sobj_capture_mine.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `CaptureLocations_InitRouenMine_Optional` | — | public |

### scenarios\campaign\mongol\mon_chp1_juyong\mon_chp1_juyong.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `Mission_SetupPlayers` | — | public |
| 62 | `Mission_SetupVariables` | — | public |
| 181 | `Mission_SetRestrictions` | — | public |
| 202 | `Mission_Preset` | — | public |
| 306 | `Mission_Start` | — | public |
| 328 | `GetRecipe` | — | public |
| 1155 | `Juyong_OnConstructionComplete` | `context` | public |
| 1171 | `Juyong_SpecialChecks` | `context` | public |
| 1202 | `Init_Waves` | — | public |
| 1360 | `Juyong_InitPlayerUnits` | — | public |
| 1395 | `Juyong_InitEnemyUnits` | — | public |
| 1401 | `Juyong_SendIntroUnits` | `context, data` | public |
| 1418 | `Juyong_CheckJuyongKeepDestroyed` | — | public |
| 1431 | `Juyong_SkipIntro` | — | public |
| 1437 | `Juyong_CleanUpIntro` | — | public |
| 1446 | `Juyong_CheckTotalFailure` | `context` | public |
| 1459 | `Achievement_ScoutDiesAtFrontGate` | `context` | public |

### scenarios\campaign\mongol\mon_chp1_juyong\obj_juyong_phase1.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `Juyong_InitObjectives_Phase1` | — | public |
| 72 | `Juyong_CheckScoutsAlive` | — | public |
| 81 | `Juyong_CheckMountainRouteFound` | — | public |
| 91 | `Juyong_CheckZGateFound` | — | public |
| 101 | `Juyong_MongolPatrolFound` | — | public |
| 110 | `Juyong_SpawnMongolArmy` | — | public |

### scenarios\campaign\mongol\mon_chp1_juyong\obj_juyong_phase2.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `Juyong_InitObjectives_Phase2` | — | public |
| 88 | `Juyong_MongolReinforcementOnClick` | — | public |
| 96 | `Juyong_BurnZhangjiakou` | — | public |
| 131 | `Juyong_CheckZhangjiakouEntered` | — | public |
| 151 | `Juyong_RetreatZhangjiakou` | — | public |

### scenarios\campaign\mongol\mon_chp1_juyong\obj_juyong_phase3.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `Juyong_InitObjectives_Phase3` | — | public |
| 247 | `Juyong_StartYanqingWaves` | — | public |
| 252 | `Juyong_StartNorthWaves` | — | public |
| 257 | `Juyong_StartSouth1Waves` | — | public |
| 262 | `Juyong_StartSouth2Waves` | — | public |
| 268 | `Juyong_SupplyCaravanOnClick` | — | public |
| 272 | `Juyong_MoveBuildingsHint` | `context, data` | public |
| 284 | `Juyong_GetBurnableList` | — | public |
| 300 | `Juyong_IsBurnableBurning` | — | public |
| 351 | `Juyong_RecallAllJinSoldiers` | `context` | public |
| 388 | `Juyong_SendToJuyong` | `moduleName, newModule` | public |
| 422 | `Juyong_PlayVillageWaveVOAndObj` | — | public |
| 430 | `Juyong_YanqingWave` | — | public |
| 440 | `Juyong_NorthWave` | — | public |
| 451 | `Juyong_South1Wave` | — | public |
| 462 | `Juyong_South2Wave` | — | public |
| 473 | `Juyong_JuyongWave` | — | public |
| 478 | `Juyong_SendWave` | `wave` | public |
| 487 | `Juyong_OnBuildingBurned` | `context` | public |
| 491 | `Juyong_OnEntityDestroyed` | `context` | public |
| 524 | `Juyong_CheckPlayerApproachVillage1` | — | public |
| 532 | `Juyong_CheckPlayerApproachVillage2` | — | public |
| 540 | `Juyong_CheckPlayerApproachVillage3` | — | public |
| 548 | `Juyong_CheckPlayerApproachYanqing` | — | public |
| 557 | `Juyong_FirstVillageDestroyed` | — | public |
| 564 | `Juyong_CheckMongolTCDestroyed` | — | public |
| 568 | `Juyong_UpdateMonTC` | — | public |
| 613 | `Juyong_RetreatOffMap` | — | public |

### scenarios\campaign\mongol\mon_chp1_juyong\obj_juyong_phase4.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `Juyong_InitObjectives_Phase4` | — | public |
| 114 | `Juyong_GroupWallsForObjectives` | — | public |
| 124 | `Juyong_ApproachGreatWall` | — | public |
| 133 | `Juyong_CheckGreatWallBreached` | — | public |
| 149 | `Juyong_ShowGreatWall` | — | public |
| 161 | `Juyong_InitOutro` | — | public |
| 312 | `Juyong_SendOutroUnits` | `context, data` | public |
| 329 | `Modify_SetUnitMaxSpeed` | `group, newSpeed, duration` | public |
| 357 | `Joyong_CheatToObjective` | — | public |
| 443 | `Module_StopAndDelete` | `name` | public |
| 459 | `VillagerLife_Stop` | `name` | public |
| 471 | `Capture_Location` | `name` | public |

### scenarios\campaign\mongol\mon_chp1_juyong\training_juyong.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `_DelayTimeElapsed` | `goal` | private |
| 25 | `MissionTutorial_JuyongLeaderAura_Xbox` | — | public |
| 79 | `MissionTutorial_JuyongLeaderAura` | — | public |
| 122 | `Predicate_UserHasSelectedGenghis` | `goal` | public |
| 129 | `Predicate_UserHasLookedAtGenghisAbility` | `goal` | public |
| 136 | `Predicate_UserHasNotActivatedGenghisLeaderAbilityRecently` | `goalSequence` | public |
| 147 | `MissionTutorial_JuyongRaiding` | — | public |
| 165 | `_HasEnemyBuildingOnScreen` | `goalSequence` | private |
| 192 | `UserCannotSeeEntityKey` | `goalSequence` | public |
| 213 | `_BuildingIsBurning` | `goal` | private |
| 224 | `MissionTutorial_JuyongGer` | — | public |
| 243 | `_HasGerOnScreen` | `goalSequence` | private |
| 275 | `MissionTutorial_JuyongPasture_Entity` | — | public |
| 294 | `_HasPastureOnScreen_Entity` | `goalSequence` | private |
| 319 | `_CancelIfEntity` | — | private |
| 323 | `MissionTutorial_JuyongPasture_Squad` | — | public |
| 342 | `_HasPastureOnScreen_Squad` | `goalSequence` | private |
| 367 | `_CancelIfSquad` | — | private |
| 375 | `MissionTutorial_JuyongMovingBuildings` | — | public |
| 395 | `_HasUnpackedBuildingOnScreen` | `goalSequence` | private |
| 424 | `_HasPackedAnyBuilding` | `goalSequence` | private |
| 442 | `MissionTutorial_JuyongUnpackBuildings` | — | public |
| 461 | `_HasZhangOnScreen` | `goalSequence` | private |
| 476 | `MissionTutorial_JuyongOvoo` | — | public |
| 495 | `Predicate_UserHasOvoo` | `goal` | public |
| 501 | `Predicate_IsStoneOnscreen` | `goalSequence` | public |
| 525 | `MissionTutorial_ImprovedRaiding` | — | public |
| 539 | `ImprovedRaiding_TriggerPredicate` | `goalSequence` | public |
| 554 | `ImprovedRaiding_OutpostIsSelected` | `goal` | public |
| 564 | `ImprovedRaiding_HasUpgrade` | `goal` | public |
| 586 | `ImprovedRaiding_BypassPredicate` | `goalSequence` | public |
| 593 | `MissionTutorial_Blacksmith` | — | public |
| 610 | `Blacksmith_TriggerPredicate` | `goalSequence` | public |
| 625 | `Blacksmith_VillagerIsSelected` | `goal` | public |
| 635 | `Blacksmith_PlayerIsGoingToBuild` | `goal` | public |
| 639 | `Blacksmith_IsBuilt` | `goal` | public |
| 645 | `Blacksmith_BlacksmithExists` | `goalSequence` | public |
| 654 | `MissionTutorial_SiegeEngineer_Xbox` | — | public |
| 701 | `MissionTutorial_SiegeEngineer` | — | public |
| 715 | `SiegeEngineer_TriggerPredicate_Xbox` | `goalSequence` | public |
| 731 | `SiegeEngineer_TriggerPredicate` | `goalSequence` | public |
| 746 | `SiegeEngineer_BlacksmithIsSelected` | `goal` | public |
| 756 | `SiegeEngineer_HasUpgrade` | `goal` | public |
| 779 | `SiegeEngineer_BypassPredicate` | `goalSequence` | public |
| 786 | `MissionTutorial_Ram` | — | public |
| 806 | `Rams_TriggerPredicate` | `goalSequence` | public |
| 826 | `Rams_UnitsSelected` | `goal` | public |
| 838 | `Rams_RamsBuilt` | `goal` | public |

### scenarios\campaign\mongol\mon_chp1_kalka_river\mon_chp1_kalka_river.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 16 | `Mission_SetupPlayers` | — | public |
| 46 | `Mission_SetupVariables` | — | public |
| 192 | `Mission_SetRestrictions` | — | public |
| 204 | `Mission_Preset` | — | public |
| 249 | `Mission_SetDifficulty` | — | public |
| 256 | `Tutorials_Start_ControlGroup` | — | public |
| 261 | `Mission_Start` | — | public |
| 277 | `StartKhanAbilityTuto` | — | public |
| 290 | `GetRecipe` | — | public |
| 956 | `Kalka_MoveStartingUnits` | — | public |
| 990 | `Monitor_scoutsForAmbush` | — | public |
| 1006 | `waitScoutinMiddle` | — | public |
| 1015 | `intro_setvulnerable` | — | public |
| 1021 | `MonitorScoutDeath` | — | public |
| 1041 | `MoveSubutaiAcrossRiver` | — | public |
| 1047 | `Kalka_UnlockCavalryUpgrades` | — | public |
| 1065 | `StartNewParade` | — | public |
| 1071 | `ParadeArmy` | — | public |
| 1110 | `makeLeaderCheer` | — | public |
| 1116 | `KnightFirstPhaseShowOff_Phase01` | — | public |
| 1122 | `TriggerCheeringNearKnight` | `context, data` | public |
| 1159 | `CheckUnitsLeftKalka` | — | public |
| 1169 | `Achievement_OnSquadKilled` | `context` | public |

### scenarios\campaign\mongol\mon_chp1_kalka_river\obj_ambushattack.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `AmbushAttack_InitObjectives` | — | public |
| 36 | `Kalka_DelayedAmbushVictoryWalla` | `context, data` | public |
| 44 | `AmbushAttack_OnStart` | — | public |
| 50 | `KillAllRusAmbushPt_UI` | — | public |
| 55 | `KillAllRusAmbushPt_Start` | — | public |
| 73 | `Kalka_InitRusArmyCount` | — | public |
| 83 | `KillAllRusAmbushPt_Monitor` | — | public |
| 132 | `Kalka_CheckAllReinforcements` | — | public |
| 147 | `Kalka_CheckReinforcements` | `moduleName` | public |
| 182 | `KillAllRusAmbushPt_OnComplete` | — | public |
| 191 | `ObjectiveStartNextObj_Enclosed` | — | public |
| 196 | `spawnLateUnits_toRetreat` | — | public |
| 212 | `make_units_retreat` | — | public |

### scenarios\campaign\mongol\mon_chp1_kalka_river\obj_defeat_enclosedrus.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `DefeatEnclosedRus_InitObjectives` | — | public |
| 50 | `KillAllEnclosedRus_UI` | — | public |
| 59 | `KillAllEnclosedRus_PreStart` | — | public |
| 63 | `KillAllEnclosedRus_Start` | — | public |
| 96 | `CheckMongolApproaching` | — | public |
| 109 | `constructWall` | — | public |
| 124 | `EnemyKilledStockadeDefEvent` | `context` | public |
| 143 | `KillAllEnclosedRus_Monitor` | — | public |
| 159 | `KillAllEnclosedRus_OnComplete` | — | public |
| 172 | `Mongol_prepare_outro` | — | public |
| 219 | `delayedSpawnedOutroCam` | — | public |
| 225 | `Mongol_StartOutroMovement` | `context, data` | public |
| 235 | `Khan_OutroMovement` | — | public |
| 242 | `KhanHenchmen01_OutroMovement` | — | public |
| 249 | `KhanHenchmen02_OutroMovement` | — | public |

### scenarios\campaign\mongol\mon_chp1_kalka_river\obj_gettoambushpoint.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `GetToAmbushPoint_InitObjectives` | — | public |
| 43 | `GetToAmbushPoint_UI` | — | public |
| 49 | `GetToAmbushPoint_Start` | — | public |
| 56 | `GetToAmbushPointMonitor` | — | public |
| 66 | `GetToAmbushPoint_OnComplete` | — | public |

### scenarios\campaign\mongol\mon_chp1_kalka_river\obj_setupambush.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `SetupTheRusAmbush_InitObjectives` | — | public |
| 96 | `Kalka_DelayedInteractivityChange` | `context, data` | public |
| 100 | `RusArrivalTimer_Start` | — | public |
| 104 | `RusArrivalTimer_Monitor` | — | public |
| 111 | `setup_Ambush_Start` | — | public |
| 120 | `kalka_OnAbilityExecuted` | `context` | public |
| 137 | `GetSquadsToAmbushPt_UI` | — | public |
| 141 | `GetSquadsToAmbushPt_Start` | — | public |
| 146 | `GetSquadsToAmbushPt_Monitor` | — | public |
| 153 | `GetSquadsToAmbushPt_OnComplete` | — | public |
| 161 | `GetSquadToPositionA_UI` | — | public |
| 170 | `GetSquadToAmbushPositionA_Start` | — | public |
| 175 | `GetSquadProgressA_Monitor` | — | public |
| 196 | `GetSquadToPositionA_OnComplete` | — | public |
| 202 | `GetSquadToPositionB_UI` | — | public |
| 212 | `GetSquadToPositionB_Start` | — | public |
| 217 | `GetSquadProgressB_Monitor` | — | public |
| 237 | `GetSquadToPositionB_OnComplete` | — | public |
| 243 | `GetSquadToPositionC_UI` | — | public |
| 252 | `GetSquadToPositionC_Start` | — | public |
| 258 | `GetSquadProgressC_Monitor` | — | public |
| 277 | `GetSquadToPositionC_OnComplete` | — | public |
| 285 | `SetupTheRusAmbush_OnComplete` | — | public |

### scenarios\campaign\mongol\mon_chp1_kalka_river\obj_slowdowntherus.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `LureTheRusToAmbush_InitObjectives` | — | public |
| 73 | `ReDestroyTheRus_preStart` | — | public |
| 77 | `ReDestroyTheRus_start` | — | public |
| 83 | `Start_Tutorial_MoveShoot` | — | public |
| 87 | `DestroyTheRusUltimate_IsFailed` | — | public |
| 99 | `DestroyTheRusUltimate_OnFailed` | — | public |
| 103 | `MeetTheRus_UI` | — | public |
| 109 | `MeetTheRus_Start` | — | public |
| 163 | `Kalka_ModifyRusSpeed` | `value` | public |
| 169 | `SpawnUnitsRus02` | — | public |
| 209 | `SpawnUnitsRus03` | — | public |
| 249 | `MeetTheRusMonitor` | — | public |
| 313 | `MeetTheRus_OnComplete` | — | public |
| 328 | `GetRusToAmbushPt_UI` | — | public |
| 334 | `GetRusToAmbushPt_Start` | — | public |
| 340 | `CheckifAllRusKilledEarlyMonitor` | — | public |
| 354 | `GetRusToAmbush_Failed` | — | public |
| 363 | `GetToAmbushPointMonitor` | — | public |
| 374 | `GetRusToAmbushPt_OnComplete` | — | public |
| 388 | `DefeatRusUltimate_OnComplete` | — | public |

### scenarios\campaign\mongol\mon_chp1_kalka_river\training_kalkariver.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Tutorials_Kalka_ControlGroups` | — | public |
| 51 | `Tutorials_Kalka_KhanAbility_Xbox` | — | public |
| 90 | `Tutorials_Kalka_KhanAbility` | — | public |
| 129 | `TimerORIgnore_UserCannotSeeSquadKey` | `goalSequence` | public |
| 137 | `UserHasNoUnitSelectedKalka` | `goalSequence` | public |
| 144 | `UserIsMovingAnySelectedUnitKalka` | `goalSequence` | public |
| 159 | `UserIsMovingSpecifiedSelectedUnitKalka` | `goal` | public |
| 178 | `UserHasSelectedAMangudai_Kalka` | `goal` | public |
| 193 | `kalka_OnAbilityExecutedRightTime` | `context` | public |
| 209 | `Predicate_UserHasLookedAtKhanAbility` | `goal` | public |
| 226 | `UserHasUsedKhanAbility` | `goal` | public |
| 235 | `UserHasNotMovedASelectedVisibleUnitRecentlyKalka` | `goalSequence` | public |
| 245 | `HasIdleKhanOnScreen_Xbox` | `goalSequence` | public |
| 278 | `HasIdleKhanOnScreen` | `goalSequence` | public |
| 312 | `Tutorials_kalkariver_MoveShoot` | — | public |
| 334 | `Predicate_HasMoveShoot` | `goal` | public |
| 345 | `Predicate_setKeyMoveShoot` | `goalSequence` | public |

### scenarios\campaign\mongol\mon_chp1_zhongdu\mon_chp1_zhongdu.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupPlayers` | — | public |
| 56 | `Mission_SetupVariables` | — | public |
| 197 | `Zhongdu_Intro_Parade` | — | public |
| 296 | `Mission_SetRestrictions` | — | public |
| 369 | `Mission_Preset` | — | public |
| 471 | `GenghisMove_Intro` | — | public |
| 478 | `Mission_Start` | — | public |
| 510 | `GetRecipe` | — | public |
| 832 | `Zhongdu_OnAbilityExecuted` | `context` | public |
| 853 | `Zhongdu_OnSquadKilled` | `context, data` | public |
| 893 | `Zhongdu_DebugRaidTiming` | `causeString` | public |
| 902 | `Zhongdu_OnEntityKilled` | `context, data` | public |
| 949 | `Zhongdu_OutroParade` | — | public |
| 1049 | `Zhongdu_GrowRaidSize` | `context, data` | public |
| 1063 | `Zhongdu_OnPlayerBreach` | — | public |
| 1095 | `Zhongdu_AttackPlayerBase` | `context, data` | public |
| 1119 | `Zhongdu_OnIdleRaiders` | — | public |
| 1139 | `Zhongdu_DelayScouting` | `context, data` | public |
| 1147 | `Zhongdu_WarnAgainstCity` | `context, data` | public |
| 1158 | `Zhongdu_WatchForAgeUp_Xbox` | `context, data` | public |
| 1171 | `Zhongdu_WatchForAgeUp` | `context, data` | public |
| 1185 | `Zhongdu_WatchForBlacksmith_Xbox` | `context, data` | public |
| 1200 | `Zhongdu_WatchForBlacksmith` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp1_zhongdu\obj_zhongdu_phase1.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 18 | `Zhongdu_InitObjectives_Phase1` | — | public |
| 376 | `Zhongdu_UpdateDefences` | `defenseStrength` | public |
| 450 | `Zhongdu_OnVillageDestroyed` | `villageName` | public |
| 516 | `Zhongdu_OnmapCaravan` | `context, data` | public |
| 570 | `Zhongdu_TickSupplyCaravans` | `squadID, callbackData` | public |
| 594 | `Zhongdu_ExtraCleanup` | `squadID, callbackData` | public |
| 613 | `Zhongdu_SnapCamera` | `id` | public |
| 620 | `Zhongdu_DisplayMinimapPath` | `context, data` | public |
| 628 | `Zhongdu_EntryVO` | `context, data` | public |
| 641 | `Zhongdu_PlaceSallyThreatArrow` | `context, data` | public |
| 650 | `Zhongdu_OnSallyDeathVO` | — | public |
| 662 | `Zhongdu_SetupMinimapPath` | `markerStart, markerPath` | public |

### scenarios\campaign\mongol\mon_chp1_zhongdu\obj_zhongdu_phase2.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `Zhongdu_InitObjectives_Phase2` | — | public |
| 226 | `Zhongdu_MonitorSkirmishers` | `context, data` | public |
| 264 | `Zhongdu_StagedVoLandmarks` | — | public |

### scenarios\campaign\mongol\mon_chp1_zhongdu\obj_zhongdu_secondary.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `ZhongduRaid_InitObjectives` | — | public |
| 153 | `Zhongdu_SpawnReinforcements` | — | public |

### scenarios\campaign\mongol\mon_chp1_zhongdu\training_zhongdu.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `MissionTutorial_Init` | — | public |
| 17 | `Zhongdu_SetupSheepRallyHint` | — | public |
| 55 | `Zhongdu_TriggerPastureOnScreen` | `goalSequence` | public |
| 81 | `Zhongdu_ListenForRallyPoint` | `context` | public |
| 89 | `Zhongdu_RallyPointSet` | `goal` | public |
| 98 | `Zhongdu_TriggerGenghisHint_Xbox` | `goalSequence` | public |
| 127 | `Zhongdu_TriggerGenghisHint` | `goalSequence` | public |
| 155 | `Predicate_UserHasSelectedGenghis` | `goal` | public |
| 161 | `Predicate_UserHasLookedAtGenghisAbility` | `goal` | public |
| 167 | `Predicate_UserHasNotActivatedGenghisLeaderAbilityRecently` | `goalSequence` | public |
| 176 | `Zhongdu_TriggerSiegeEngineersHint_Xbox` | `goalSequence` | public |
| 207 | `Zhongdu_TriggerSiegeEngineersHint` | `goalSequence` | public |

### scenarios\campaign\mongol\mon_chp2_kiev\mon_chp2_kiev.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 16 | `Mission_SetupPlayers` | — | public |
| 77 | `Mission_SetupVariables` | — | public |
| 153 | `Mission_SetDifficulty` | — | public |
| 174 | `Mission_SetRestrictions` | — | public |
| 209 | `Mission_Preset` | — | public |
| 282 | `Mission_Start` | — | public |
| 320 | `GetRecipe` | — | public |
| 554 | `Kiev_CheckGateDamage` | `context, data` | public |
| 572 | `Kiev_CheckDefenderStatus` | `context, data` | public |
| 592 | `Kiev_SpawnResistance` | `context, data` | public |
| 612 | `Kiev_SpawnTraders` | `trader_amount, spawn_delay` | public |
| 630 | `Kiev_StartTrading` | `unit, deployment` | public |
| 637 | `Kiev_GateTracking` | `context, data` | public |
| 663 | `MongkeCall` | `context, data` | public |
| 693 | `Kiev_InitializeTrainingHints` | — | public |
| 703 | `Kiev_WaitForArsenalHint` | — | public |
| 716 | `Kiev_WaitForIncendiaryHint` | — | public |
| 723 | `Kiev_WaitForLeaderHint` | — | public |
| 742 | `Kiev_CheckGroupsForFire` | `context, data` | public |
| 761 | `Kiev_StructureFireSpread` | `context, data` | public |
| 773 | `Kiev_IgniteEGroup` | `gid, idx, eid` | public |
| 814 | `Kiev_WeakenStructures` | — | public |
| 826 | `Kiev_UpdateBurningAtmospherics` | — | public |
| 838 | `Kiev_SpawnAttackWave2` | — | public |
| 877 | `Kiev_SpawnSprawlAttackWave` | `context, data` | public |
| 889 | `Kiev_CheckTraderKilled` | `context, data` | public |
| 904 | `Kiev_SpawnFirstGateDefenders` | — | public |
| 924 | `Kiev_SetupSprawlProxChecking` | — | public |
| 936 | `Kiev_SprawlProxCheck` | `context, data` | public |
| 962 | `Kiev_SpawnIndustrialDistrictUnits` | — | public |
| 978 | `Kiev_SpawnOuterDistrictUnits` | — | public |
| 1027 | `Kiev_SpawnOuterDistrictWallDefenders` | — | public |
| 1045 | `Kiev_SpawnInnerDistrictUnits` | — | public |
| 1091 | `Kiev_SpawnInnerDistrictWallDefenders` | — | public |
| 1157 | `Kiev_SpawnIntroUnits` | `spawn_at_destination` | public |

### scenarios\campaign\mongol\mon_chp2_kiev\obj_destroygate.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `DestroyGate_InitObjectives` | — | public |
| 81 | `DestroyGate_EntityKilled` | `context` | public |

### scenarios\campaign\mongol\mon_chp2_kiev\obj_destroykiev.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `DestroyKiev_InitObjectives` | — | public |
| 207 | `DestroyKiev_PreStart` | — | public |
| 211 | `DestroyKiev_AssignGateReferences` | — | public |
| 250 | `DestroyKiev_Complete` | — | public |
| 292 | `TroopMovement` | — | public |
| 299 | `DestroyKiev_SetupWaveData` | — | public |
| 372 | `DestroyKiev_SetupSprawlWaveData` | — | public |
| 452 | `DestroyKiev_SurvivorCallout` | `context, data` | public |
| 466 | `DestroyKiev_CheckEntityMarker` | `context, data` | public |
| 486 | `DestroyKiev_PlayDestructionWalla` | `marker_location` | public |

### scenarios\campaign\mongol\mon_chp2_kiev\obj_forwardbase.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `ForwardBase_InitObjectives` | — | public |
| 49 | `ForwardBase_PreStart` | — | public |
| 77 | `ForwardBase_SpawnPlayerStructures` | — | public |
| 111 | `ForwardBase_CheckForStructuresDropped` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp2_kiev\training_kiev.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `Kiev_InitializeArsenalTrainingHints` | — | public |
| 26 | `Kiev_InitializeIncendiaryWeaponTrainingHints` | — | public |
| 58 | `Kiev_InitializeLeaderTrainingHints_Xbox` | — | public |
| 104 | `Kiev_InitializeLeaderTrainingHints` | — | public |
| 128 | `Kiev_SkipTraining` | `goalSequence` | public |
| 137 | `Kiev_PlayerHasArsenal` | `goalSequence` | public |
| 163 | `Kiev_PlayerIsSelectingArsenal` | `goal` | public |
| 180 | `Kiev_PlayerIsResearchingUpgrade` | `goal` | public |
| 217 | `Kiev_PlayerHasIncendiaryUpgrade` | `goalSequence` | public |
| 238 | `Kiev_PlayerHasSelectedUnitWithIncendiaryUpgrade` | `goal` | public |
| 256 | `Kiev_PlayerHasAttackedStructuresWithArrows` | `goal` | public |
| 284 | `Structure_AttackedByArchers` | `context` | public |
| 301 | `Kiev_LeaderAndStructuresExist_Xbox` | `goalSequence` | public |
| 311 | `Kiev_LeaderAndStructuresExist` | `goalSequence` | public |
| 321 | `Kiev_PlayerHasSelectedRanged` | `goal` | public |
| 342 | `Kiev_PlayerHasSelectedLeader` | `goal` | public |
| 348 | `Kiev_LeaderIsNearStructures` | `goal` | public |

### scenarios\campaign\mongol\mon_chp2_liegnitz\mon_chp2_liegnitz.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `Mission_SetupPlayers` | — | public |
| 88 | `Mission_SetupVariables` | — | public |
| 149 | `Mission_SetRestrictions` | — | public |
| 184 | `Mission_SetDifficulty` | — | public |
| 190 | `Mission_Preset` | — | public |
| 239 | `Mission_Start` | — | public |
| 302 | `GetRecipe` | — | public |
| 711 | `Liegnitz_FirstGroupIsEngaged` | — | public |
| 728 | `Liegnitz_StaggerAttackerEngagement` | `groups` | public |
| 762 | `Liegnitz_StaggerAttackerEngagement_Delayed` | `context, data` | public |
| 782 | `Liegnitz_ValleyGroupAggro` | — | public |
| 807 | `Liegnitz_AssignSquadsToControlGroups` | — | public |
| 843 | `Liegnitz_AssignWallsToEGroups` | — | public |
| 854 | `Liegnitz_BreachWallCharge` | `context, data` | public |
| 876 | `Liegnitz_FieldWithdrawCelebrate` | — | public |
| 889 | `Liegnitz_RidgeWithdrawCelebrate` | — | public |
| 902 | `Liegnitz_ValleyWithdrawCelebrate` | — | public |
| 917 | `Liegnitz_RovingWithdrawCelebrate` | — | public |
| 923 | `Liegnitz_BohemianWithdrawCelebrate` | — | public |
| 929 | `Liegnitz_WithdrawCleanup` | `module_list, objective, b_playGroupDefeatedVO, playIntelEvent` | public |
| 980 | `Liegnitz_IntroMovement` | — | public |
| 1038 | `Liegnitz_SkippedIntro` | — | public |
| 1056 | `Liegnitz_OutroMovement` | — | public |
| 1134 | `Outro_ScoutMove` | — | public |

### scenarios\campaign\mongol\mon_chp2_liegnitz\obj_destroypoles.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `DestroyPoles_InitObjectives` | — | public |
| 382 | `DestroyPoles_CheckPlayerStatus` | — | public |
| 406 | `DestroyPoles_UpdateObjectiveProgress` | `objectiveID, modules` | public |
| 425 | `DestroyPoles_CanPlayerSeeSGroups` | `context, data` | public |
| 437 | `DestroyPoles_UpdateObjectiveCounter` | `objectiveID` | public |
| 458 | `DestroyPoles_UpdateHintpoints` | `context, data` | public |
| 489 | `DestroyPoles_StartKnightsOBJ` | — | public |
| 493 | `DestroyPoles_BohemiaAttack` | — | public |
| 504 | `DestroyPoles_DelayStartBohemianArmyUI` | — | public |
| 509 | `DestroyPoles_BohemiaWarningTimer` | — | public |
| 518 | `DestroyPoles_OnSquadKilled` | `context` | public |
| 528 | `DestroyPoles_BurnFieldsReminder` | `context` | public |
| 535 | `DestroyPoles_FarmAttacked` | `context` | public |
| 546 | `DestroyPoles_BeesReminder` | `context` | public |
| 555 | `DestroyPoles_BeesAttackCheck` | `context` | public |
| 569 | `DestroyPoles_AddDelayedUIElement` | `context, data` | public |
| 573 | `DestroyPoles_FindHiddenStables` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp2_liegnitz\training_liegnitz.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `Liegnitz_InitializeBeesTrainingHints` | — | public |
| 25 | `Liegnitz_BeesAreAlive` | `goalSequence` | public |
| 38 | `Liegnitz_IgnoreBeesDead` | `goalSequence` | public |
| 49 | `Liegnitz_SkipBeesTip` | `goalSequence` | public |
| 53 | `Liegnitz_BeesComplete` | `goal` | public |
| 59 | `Liegnitz_DamageCheck` | `context` | public |

### scenarios\campaign\mongol\mon_chp2_mohi\mon_chp2_mohi.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `Mission_SetupPlayers` | — | public |
| 123 | `Mission_SetupVariables` | — | public |
| 214 | `Mission_SetRestrictions` | — | public |
| 226 | `Mission_Preset` | — | public |
| 245 | `Mission_Start` | — | public |
| 313 | `GetRecipe` | — | public |
| 850 | `Mohi_AddPlayerResources` | — | public |
| 857 | `Mohi_FordNotify` | — | public |
| 867 | `Mohi_BridgeNotify` | — | public |
| 887 | `Mohi_BridgeRepaired` | — | public |
| 903 | `DelayIntel` | `context, data` | public |
| 907 | `Mohi_ApplyKhanBuffs` | — | public |
| 918 | `Mohi_IsPlayerEconomyLocked` | — | public |
| 968 | `Mohi_RefreshBatuMods` | — | public |
| 990 | `Mohi_HealAmbushers` | — | public |
| 1018 | `Mohi_SpawnIntroUnits` | — | public |
| 1037 | `Mohi_SkippedIntroSpawning` | — | public |
| 1061 | `Mohi_OutroUnitMovement` | — | public |
| 1109 | `Mohi_OutroBurnStart` | — | public |
| 1128 | `Mohi_OutroBurnMiddle` | — | public |
| 1143 | `Mohi_OutroBurnEnd` | — | public |
| 1157 | `Mohi_OutroDeadBodies` | — | public |
| 1170 | `Achievement_TrackArmyKills` | `context` | public |

### scenarios\campaign\mongol\mon_chp2_mohi\obj_hungarianarmy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `HungarianArmy_InitObjectives` | — | public |
| 234 | `HungarianArmy_CheckRout` | `context, data` | public |
| 263 | `HungarianArmy_DelayedComplete` | — | public |
| 267 | `HungarianArmy_SpawnCamp` | — | public |
| 321 | `HungarianArmy_CheckWherePlayerAttacking` | `context, data` | public |
| 387 | `HungarianArmy_MonitorSquadToStopReinforcements` | `context, data` | public |
| 396 | `HungarianArmy_WaitForPlayerToAssaultCamp` | `context, data` | public |
| 405 | `HungarianArmy_MonitorTentsToStopReinforcements` | `context, data` | public |
| 414 | `HungarianArmy_BotherPlayerIfTheyAreIdleAgain` | `context, data` | public |
| 451 | `HungarianArmy_ReinforceExistingModules` | `context, data` | public |
| 464 | `Check_Completion_Time` | — | public |

### scenarios\campaign\mongol\mon_chp2_mohi\obj_scoutbridge.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `ScoutBridge_InitObjectives` | — | public |
| 373 | `ScoutBridge_CanPlayerSeeAmbushUnits` | — | public |
| 420 | `ScoutBridge_SpawnStructures` | — | public |
| 438 | `ScoutBridge_BatuWarning` | — | public |
| 448 | `ScoutBridge_DelayDrums` | — | public |
| 452 | `ScoutBridge_AmbushWalla` | — | public |
| 458 | `ScoutBridge_BotherPlayerIfIdle` | `context, data` | public |
| 503 | `ScoutBridge_StopReinforcingAmbushers` | `context, data` | public |
| 532 | `ScoutBridge_SpawnFlankAmbushers` | — | public |
| 561 | `ScoutBridge_DelayedPursuerTargetUpdate` | — | public |
| 566 | `ScoutBridge_HasPlayerSeenCavalryRecently` | — | public |

### scenarios\campaign\mongol\mon_chp3_lumen_shan\mon_chp3_lumen_shan_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 38 | `AutoTest_OnInit` | — | public |
| 68 | `AutoTest_SkipAndStart` | — | public |
| 77 | `AutoTest_PlayIntro` | — | public |
| 92 | `AutomatedMission_Start` | — | public |
| 100 | `AutomatedLumen_RegisterCheckpoints` | — | public |
| 124 | `AutomatedLumen_Phase1_CheckPlayStart` | — | public |
| 138 | `AutomatedLumen_Phase2_MovePlayerArmy` | — | public |
| 156 | `AutomatedLumen_Phase2_QueryIsComplete` | — | public |
| 171 | `AutomatedLumen_Phase3_BuildWall_1` | — | public |
| 189 | `AutomatedLumen_Phase3_QueryBohekouStarted` | — | public |
| 204 | `AutomatedLumen_Phase3_QueryBohekouCompleted` | — | public |
| 216 | `AutomatedLumen_Phase3_BuildWall_2` | — | public |
| 230 | `AutomatedLumen_Phase3_QueryWallsComplete` | — | public |
| 241 | `AutomatedLumen_Phase4_DefenseComplete` | — | public |
| 250 | `_AutomatedLumen_UnitReplenish` | `context, data` | private |
| 276 | `Player_RovingArmy` | — | public |

### scenarios\campaign\mongol\mon_chp3_lumen_shan\mon_chp3_lumen_shan.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `Mission_SetupPlayers` | — | public |
| 72 | `Mission_SetupVariables` | — | public |
| 239 | `Mission_SetRestrictions` | — | public |
| 308 | `Mission_Preset` | — | public |
| 389 | `Mission_Start` | — | public |
| 406 | `GetRecipe` | — | public |
| 577 | `Lumen_OnConstructionStart` | `context` | public |
| 595 | `Lumen_LaunchSongSally` | — | public |
| 637 | `Lumen_CheckForExit` | — | public |
| 716 | `Lumen_StartIntro` | — | public |
| 729 | `Lumen_StartOutro` | — | public |
| 792 | `Lumen_GetValidPath` | — | public |
| 842 | `Lumen_SpawnPickups` | — | public |
| 867 | `Lumen_ResendMongolBuildings` | `context, data` | public |
| 908 | `Lumen_OnEntityKilled` | `context, data` | public |
| 940 | `Lumen_WatchForBridges` | `context, data` | public |
| 964 | `Lumen_WatchIdleScouts` | `context, data` | public |
| 1016 | `Lumen_CheatDeleteEnemies` | — | public |

### scenarios\campaign\mongol\mon_chp3_lumen_shan\obj_lumen_phase1.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `LumenShan_InitObjectives_Phase1` | — | public |
| 138 | `Lumen_WatchPlayerPassage` | `context, data` | public |
| 150 | `Lumen_WatchPlayerBreach` | `context, data` | public |
| 162 | `Lumen_CheckLossLumen` | `context, data` | public |
| 176 | `Lumen_DisbandStartingAmbushers` | — | public |
| 217 | `Lumen_RevealAroundLumen` | — | public |

### scenarios\campaign\mongol\mon_chp3_lumen_shan\obj_lumen_phase2.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `LumenShan_InitObjectives_Phase2` | — | public |
| 177 | `Lumen_SetupLeaderHint_Xbox` | — | public |
| 186 | `Lumen_SetupLeaderHint` | — | public |
| 199 | `Lumen_CheckChineseLoss` | — | public |
| 213 | `Lumen_UpdateCachedPath` | — | public |
| 233 | `Lumen_EvaluateBlockade` | — | public |
| 357 | `Lumen_ManageRaiders` | `context, data` | public |
| 445 | `Lumen_RetreatBlockedRaiders` | `module` | public |
| 513 | `Lumen_VanishBlockedRaiders` | `module` | public |
| 548 | `Lumen_NewScout` | — | public |
| 558 | `Lumen_DelayedHalfBlockedVO` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp3_lumen_shan\obj_lumen_phase3.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `LumenShan_InitObjectives_Phase3` | — | public |
| 174 | `Lumen_UpdatePathDisplay` | `context, data` | public |
| 187 | `Lumen_RecallExistingUnits` | — | public |
| 212 | `Lumen_MaintainSallies` | — | public |
| 263 | `Lumen_SpawnWallbreakers` | — | public |
| 382 | `Lumen_WarnPlayer` | `context, data` | public |
| 414 | `Lumen_IncrementStoppedSong` | — | public |
| 425 | `Lumen_OnWallDamage` | `context, data` | public |
| 438 | `Lumen_OnWallDestroyed` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp3_lumen_shan\obj_lumen_phase4.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `LumenShan_InitObjectives_Phase4` | — | public |
| 116 | `Lumen_SecretCleanup` | — | public |
| 129 | `Lumen_RedirectRemainingUnits` | `context, data` | public |
| 174 | `Lumen_SetupStragglerModules` | — | public |
| 204 | `Lumen_ManageStragglerModules` | `context, data` | public |
| 321 | `Lumen_DelayedAssignStragglersLumen` | `context, data` | public |
| 325 | `Lumen_DelayedAssignStragglersBohekou` | `context, data` | public |
| 330 | `Lumen_AssignStragglers` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp3_lumen_shan\obj_lumen_secondary.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `LumenShan_InitObjectivesSecondary` | — | public |
| 119 | `Lumen_StartBohekou` | `context, data` | public |
| 124 | `Lumen_CheckLossBohekou` | `context, data` | public |
| 138 | `Lumen_RevealAroundBohekou` | — | public |

### scenarios\campaign\mongol\mon_chp3_lumen_shan\training_lumen.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `MissionTutorial_Init` | — | public |
| 28 | `_Predicate_CompletedBridgeHint` | `goal` | private |
| 42 | `_Predicate_UserHasNotSeenBridgeRecently` | `goalSequence` | private |
| 63 | `MissionTutorial_AddHintToIntactBridges` | — | public |
| 96 | `_Predicate_UserSelectedDestroyedBridge` | `goal` | private |
| 110 | `_Predicate_UserHasNotSeenDestroyedBridgeRecently` | `goalSequence` | private |
| 131 | `MissionTutorial_AddHintToBrokenBridge` | — | public |
| 164 | `Lumen_TriggerZhengHint_Xbox` | `goalSequence` | public |
| 193 | `Lumen_TriggerZhengHint` | `goalSequence` | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1267\mon_chp3_xiangyang_1267.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupPlayers` | — | public |
| 68 | `Mission_SetupVariables` | — | public |
| 227 | `Mission_SetRestrictions` | — | public |
| 311 | `Mission_Preset` | — | public |
| 420 | `Mission_Start` | — | public |
| 455 | `GetRecipe` | — | public |
| 745 | `Xiangyang1267_SpawnPickups` | — | public |
| 770 | `Xiangyang1267_OnSquadKilled` | `context` | public |
| 785 | `Xiangyang1267_RunOutro` | — | public |
| 893 | `Xiangyang_BoostDefences` | — | public |
| 945 | `Xiangyang1267_OnDamageReceived` | `context, data` | public |
| 965 | `Xiangyang1267_SpawnRoadPatrol` | `context, data` | public |
| 1010 | `Xiangyang1267_WaitForBribe` | `context, data` | public |
| 1044 | `Xiangyang1267_WaitForRefugees` | `context, data` | public |
| 1066 | `Xiangyang1267_SpawnAllies` | — | public |
| 1122 | `Xiangyang1267_ScoutSpotting` | `context, data` | public |
| 1175 | `Xiangyang1267_CheatDeleteOutlyingUnits` | `stage` | public |
| 1246 | `Xiangyang1267_WatchSallyBridge` | `context, data` | public |
| 1270 | `Xiangyang1267_BlastSallyBridge` | — | public |
| 1280 | `Xiangyang1267_OnBreachFirst` | `context, data` | public |
| 1298 | `Xiangyang1267_OnBreachSecond` | `context, data` | public |
| 1316 | `Xiangyang1267_VillagerFearWallas` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1267\obj_xiangyang1_phase1.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 19 | `Xiangyang1267_InitObjectives_Phase1` | — | public |
| 331 | `Xiangyang_WatchForTemple` | `context, data` | public |
| 341 | `Xiangyang_WatchForCamp` | `context, data` | public |
| 361 | `Xiangyang1267_CheckMongolAdvance_Logic` | — | public |
| 377 | `Xiangyang1267_WatchRiverPostVO` | `context, data` | public |
| 391 | `Xiangyang1267_CheckMongolAdvance_Proximity` | — | public |
| 406 | `Xiangyang_SpawnNorthernArmy` | — | public |
| 434 | `Xiangyang1267_TopUpWithAllies` | — | public |
| 444 | `Xiangyang_CampFlanks` | `context, data` | public |
| 580 | `Xiangyang1267_WithdrawOutlyingSoldiers` | — | public |
| 616 | `Xiangyang1267_WithdrawOutlyingSoldiers_Retry` | — | public |
| 654 | `Xiangyang1267_AlliedAttackWavePeelOff` | `context, data` | public |
| 688 | `Xiangyang1267_AlliedAttackWaveGo` | `context, data` | public |
| 701 | `Xiangyang_HandleLeftovers` | — | public |
| 750 | `Xiangyang1267_DelayedAllyHandling` | `context, data` | public |
| 781 | `Xiangyang1267_NudgeAlliesAway` | `context, data` | public |
| 816 | `Xiangyang1267_SecondMopupAttempt` | `context, data` | public |
| 824 | `Xiangyang1267_ToModuleOnArrival` | `context, data` | public |
| 850 | `Xiangyang_MopUpPlayer` | `context, data` | public |
| 911 | `Xiangyang_AlliesToModules` | `context, data` | public |
| 924 | `Xiangyang1267_IsBridgeDestroyed` | `exact` | public |
| 936 | `Xiangyang1267_LaunchAlliedAttack` | `context, data` | public |
| 951 | `Xiangyang1267_LaunchBreadcrumbers` | `context, data` | public |
| 973 | `Xiangyang1267_LaunchSwarmerArmy` | `context, data` | public |
| 1023 | `Xiangyang1267_WatchAfterWoodenPost` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1267\obj_xiangyang1_phase2.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `Xiangyang1267_InitObjectives_Phase2` | — | public |
| 323 | `Xiangyang1267_MonitorBridgeheadVO` | `context, data` | public |
| 368 | `Xiangyang1267_SpawnAllCamps` | — | public |
| 483 | `Xiangyang1267_CalcSpawns` | `spawnsAfterThis, buildingCount` | public |
| 505 | `Xiangyang1267_SmallPokeAttack` | `context, data` | public |
| 526 | `Xiangyang1267_RevealWoods` | `context, data` | public |
| 534 | `Xiangyang1267_BridgeheadRatioWest` | `bigRange, includeAllies` | public |
| 558 | `Xiangyang1267_BridgeheadRatioNorth` | `bigRange, includeAllies` | public |
| 582 | `Xiangyang1267_BridgeheadRatioSouth` | `bigRange, includeAllies, minimumRatio` | public |
| 606 | `Xiangyang1267_TriggerWarningSally` | — | public |
| 618 | `Xiangyang1267_InitFinalSally` | — | public |
| 831 | `Xiangyang1267_LaunchFinaleWave` | `context, data` | public |
| 915 | `Xiangyang1267_DelayedReveal` | `context, data` | public |
| 929 | `Xiangyang1267_FinalWaveAreaComplete` | `rovingArmy` | public |
| 955 | `Xiangyang1267_FinalWaveDeath` | — | public |
| 964 | `Xiangyang1267_CheckPlayerDefeat` | — | public |
| 1072 | `Xiangyang1267_StartBridgeRepair` | `context, data` | public |
| 1110 | `Xiangyang1267_BridgeRepairWorkaround` | `context, data` | public |
| 1124 | `Xiangyang1267_WatchForSetup` | `context, data` | public |
| 1155 | `Xiangyang1267_WarnAboutBridgehead` | `warningLoc` | public |
| 1172 | `Xiangyang1267_DelayedAutoSave` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1267\obj_xiangyang1_secondary.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `VisitPagoda_InitObjectives` | — | public |
| 44 | `Xiangyang1267_MonkLeashing` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1267\training_xiangyang1.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `MissionTutorial_Init` | — | public |
| 22 | `Predicate_UserHasAnyOutpostSelected` | `goal` | public |
| 29 | `Predicate_UserHasNotSelectedOutpostsRecently` | `goalSequence` | public |
| 42 | `MissionTutorial_AddHintToOutposts` | — | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1273\mon_chp3_xiangyang_1273.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 16 | `Mission_SetupPlayers` | — | public |
| 78 | `Mission_SetupVariables` | — | public |
| 249 | `Mission_SetRestrictions` | — | public |
| 303 | `Mission_Preset` | — | public |
| 459 | `Mission_Start` | — | public |
| 499 | `GetRecipe` | — | public |
| 735 | `Xiangyang1273_OnConstructionComplete` | `context` | public |
| 750 | `Xiangyang1273_OnSquadBuilt` | `context` | public |
| 760 | `Xiangyang1273_WatchFalcons` | `context, data` | public |
| 778 | `Xiangyang1273_UpgradeBridges` | `context` | public |
| 797 | `Xiangyang1273_OutroParade` | — | public |
| 853 | `Xiangyang_BoostDefences` | — | public |
| 971 | `Xiangyang1273_RemoveHealthMods` | — | public |
| 983 | `Xiangyang1273_ManageRaiders` | `context, data` | public |
| 1105 | `Xiangyang1273_VanishRaiders` | `module` | public |
| 1118 | `Xiangyang1273_OnEntityKilled` | `context` | public |
| 1166 | `Xiangyang1273_OnDamageReceived` | `context, data` | public |
| 1183 | `Xiangyang1273_IsFailed` | — | public |
| 1199 | `Xiangyang1273_ListenForWallDestruction` | `context, data` | public |
| 1210 | `Xiangyang1273_WatchForMissingStone` | `context, data` | public |
| 1241 | `Xiangyang1273_SetupSilkRoadHint_Xbox` | — | public |
| 1250 | `Xiangyang1273_SetupSilkRoadHint` | — | public |
| 1260 | `Xiangyang1273_HandlePrematureBridgeConstruction` | `context, data` | public |
| 1310 | `Xiangyang1273_OnSquadKilled` | `context, data` | public |
| 1335 | `Xiangyang1273_DelayedHint_Xbox` | `context, data` | public |
| 1342 | `Xiangyang1273_DelayedHint` | `context, data` | public |
| 1350 | `Achievement_CheckHuiHuiPaoDestroyed` | `context` | public |
| 1365 | `Xiangyang1273_Unreveal` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1273\obj_xiangyang2_phase1.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `Xiangyang1273_InitObjectives_Phase1` | — | public |
| 105 | `Xiangyang1273_CheckTraders` | `context, data` | public |
| 124 | `Xiangyang1273_SilkRoadReminder` | — | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1273\obj_xiangyang2_phase2.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `Xiangyang1273_InitObjectives_Phase2` | — | public |
| 305 | `Xiangyang1273_SetupInfantryRepairHint_Xbox` | — | public |
| 313 | `Xiangyang1273_SetupInfantryRepairHint` | — | public |
| 322 | `Xiangyang1273_ShiftFanchengGarrison` | `context` | public |
| 444 | `Xiangyang1273_CollapseDefense` | — | public |
| 498 | `Xiangyang1273_MonitorInnerDefense` | `context, data` | public |
| 514 | `Xiangyang1273_ArrangeInnerDefense` | — | public |
| 579 | `Xiangyang1273_AddToSGroupOnArrival` | `context, data` | public |
| 597 | `Xiangyang1273_WatchForHuihuipaoAttack` | `context, data` | public |
| 617 | `Xiangyang1273_SpawnXiangyangGuards` | — | public |
| 668 | `Xiangyang1273_BurnCentralBridge` | — | public |
| 680 | `Xiangyang1273_BridgeReminder` | — | public |
| 696 | `Xiangyang1273_DelayLiuZhengHint_Xbox` | `context, data` | public |
| 703 | `Xiangyang1273_DelayLiuZhengHint` | `context, data` | public |
| 710 | `Xiangyang1273_WatchForBarbicanBypass` | `context, data` | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1273\obj_xiangyang2_phase3.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `Xiangyang1273_InitObjectives_Phase3` | — | public |
| 187 | `Xiangyang1273_WatchForKeepAttack` | `context, data` | public |
| 220 | `Xiangyang1273_KeepAvengers` | `context, data` | public |
| 236 | `Xiangyang1273_TrackCooldown` | `context, data` | public |
| 244 | `Xiangyang1273_WatchForStorm` | `context, data` | public |
| 274 | `Xiangyang1273_SpawnFinalRush` | `targetSGroup, waveIdx` | public |
| 288 | `Xiangyang1273_Retaliation` | `context, data` | public |
| 333 | `Xiangyang1273_CheckInCity` | — | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1273\obj_xiangyang2_secondary.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Xiangyang1273_InitObjectivesSecondary` | — | public |

### scenarios\campaign\mongol\mon_chp3_xiangyang_1273\training_xiangyang2.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `MissionTutorial_Init` | — | public |
| 15 | `Xiangyang1273_TriggerIsmailHint_Xbox` | `goalSequence` | public |
| 44 | `Xiangyang1273_TriggerIsmailHint` | `goalSequence` | public |
| 72 | `Xiangyang1273_TriggerInfantryRepairHint_Xbox` | `goalSequence` | public |
| 102 | `Xiangyang1273_TriggerInfantryRepairHint` | `goalSequence` | public |
| 131 | `Xiangyang1273_TriggerLiuZhengHint_Xbox` | `goalSequence` | public |
| 159 | `Xiangyang1273_TriggerLiuZhengHint` | `goalSequence` | public |
| 190 | `Xiangyang1273_TriggerSilkRoadHint_Xbox` | `goalSequence` | public |
| 219 | `Xiangyang1273_TriggerSilkRoadHint` | `goalSequence` | public |

### scenarios\campaign\russia\gdm_chp1_moscow\gdm_chp1_moscow.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 20 | `Mission_SetupPlayers` | — | public |
| 90 | `Mission_SetupVariables` | — | public |
| 180 | `Mission_SetDifficulty` | — | public |
| 207 | `Mission_SetRestrictions` | — | public |
| 215 | `Mission_Preset` | — | public |
| 249 | `GetRecipe` | — | public |
| 516 | `Mission_Start` | — | public |
| 532 | `MissionStart_SetMoscowOnFire` | — | public |
| 589 | `MissionStart_SetMoscowOnFire_PartB` | — | public |
| 602 | `Mission_CheckForFail` | — | public |
| 623 | `MissionStart_SetMoscowOnFire_PartC` | — | public |
| 641 | `Mission_AddMoreWolves` | — | public |
| 686 | `Mission_AdjustPlayerMaxPopCap` | `player, adjustment` | public |
| 716 | `Mission_SetupCheatForOutroCamera` | — | public |
| 732 | `Mission_PrepareForOutro` | — | public |

### scenarios\campaign\russia\gdm_chp1_moscow\obj_builddefences.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `BuildDefences_InitObjectives` | — | public |
| 60 | `BuildDefences_TriggerObjective` | — | public |
| 73 | `BuildDefences_Start` | — | public |
| 80 | `BuildDefences_Complete` | — | public |
| 94 | `BuildDefensiveStructures_SetupUI` | — | public |
| 105 | `BuildDefensiveStructures_PartB` | — | public |
| 120 | `BuildDefensiveStructures_Complete` | `context, data` | public |
| 139 | `BuildMilitaryUnits_SetupUI` | — | public |
| 167 | `BuildMilitaryUnits_Start` | — | public |
| 175 | `BuildMilitaryUnits_Monitor` | — | public |

### scenarios\campaign\russia\gdm_chp1_moscow\obj_expandmoscow.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `ExpandMoscow_InitObjectives` | — | public |
| 77 | `ExpandMoscow_TriggerObjective` | — | public |
| 95 | `BuildLandmark_SetupUI` | `context, data` | public |
| 110 | `BuildLandmark_PartB` | `context, data` | public |
| 126 | `BuildLandmark_CheckBuildingFinished` | `context, data` | public |
| 152 | `BuildMarket_SetupUI` | `context, data` | public |
| 160 | `BuildMarket_PartB` | `context, data` | public |
| 176 | `BuildMarket_CheckBuildingFinished` | `context, data` | public |
| 192 | `BuildArchery_SetupUI` | `context, data` | public |
| 200 | `BuildArchery_PartB` | `context, data` | public |
| 216 | `BuildArchery_CheckBuildingFinished` | `context, data` | public |

### scenarios\campaign\russia\gdm_chp1_moscow\obj_findvillagers.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `FindVillagers_InitObjectives` | — | public |
| 57 | `FindVillagers_MakeVillagersRunAway` | — | public |
| 98 | `FindVillagers_MakeVillagersRunAway_TriggerScream` | `context, data` | public |
| 105 | `FindVillagers_StartIfNotAlreadyStarted` | — | public |
| 122 | `FindVillagers_Monitor` | — | public |

### scenarios\campaign\russia\gdm_chp1_moscow\obj_mongolattacks.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `MongolCountdown_InitObjectives` | — | public |
| 35 | `MongolAttacks_InitObjectives` | — | public |
| 71 | `MongolCountdown_TriggerObjective` | — | public |
| 77 | `MongolCountdown_SetupUI` | — | public |
| 85 | `MongolCountdown_Start` | — | public |
| 95 | `MongolCountdown_StartProbingAttacks` | — | public |
| 113 | `MongolCountdown_CreateProbingAttack` | — | public |
| 124 | `MongolCountdown_CreateProbingAttack_Delayed` | — | public |
| 213 | `MongolCountdown_MonitorProbingAttacks` | — | public |
| 243 | `MongolAttacks_SetupUI` | — | public |
| 269 | `MongolAttacks_Start` | — | public |
| 298 | `MongolAttacks_StartAttacks_PartB` | — | public |
| 531 | `MongolAttacks_AttackSpotted` | — | public |
| 561 | `MongolAttacks_Monitor` | — | public |
| 618 | `MongolAttacks_SpawnUnits` | `context, data` | public |
| 646 | `MongolAttacks_PreComplete` | — | public |
| 652 | `MongolAttacks_Complete` | — | public |
| 662 | `MongolAttacks_Fail` | — | public |

### scenarios\campaign\russia\gdm_chp1_moscow\obj_protectmoscow.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `ProtectMoscow_InitObjectives` | — | public |
| 106 | `ChaseOffMongols_Init` | — | public |
| 149 | `ChaseOffMongols_Monitor` | — | public |
| 261 | `ChaseOffMongols_RunAway` | `entry, index, sid` | public |
| 274 | `ChaseOffMongols_ChangeTarget` | `entry, index, sid` | public |
| 291 | `ChaseOffMongols_Retaliate` | `entry, index, sid` | public |
| 323 | `ChaseOffMongols_UpdateGradBuildingGroups` | — | public |
| 382 | `ChaseOffMongols_ChooseBuildingToAttack` | — | public |
| 418 | `PutOutFires_SetupUI` | — | public |
| 429 | `PutOutFires_Start` | — | public |
| 436 | `PutOutFires_Monitor` | — | public |
| 494 | `PutOutFires_Complete` | — | public |
| 526 | `PutOutFires_Fail` | — | public |
| 533 | `Villager_FearWalla` | — | public |

### scenarios\campaign\russia\gdm_chp1_moscow\obj_rebuildmoscow.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `RebuildMoscow_InitObjectives` | — | public |
| 122 | `RebuildMoscow_BuildConstructionManifest` | `egroup, list, rebuildFlag` | public |
| 141 | `RebuildMoscow_TriggerObjective` | — | public |
| 154 | `RebuildMoscow_PreStart` | — | public |
| 160 | `RebuildMoscow_Start` | — | public |
| 167 | `RebuildMoscow_AddDropoffHint` | — | public |
| 178 | `RebuildStructures_SetupUI` | — | public |
| 224 | `RebuildStructures_CheckRebuildingFinished` | `context, data` | public |
| 239 | `RebuildStructure_OnConstructionComplete` | `context` | public |
| 293 | `BuildStructures_RememberPositionsOfBuildings` | `egroup, useRebuildPhrasing` | public |
| 316 | `BuildStructures_MonitorConstructionProgress` | `list, data` | public |
| 434 | `BuildStructures_MonitorConstructionProgress_Check` | `context, data` | public |
| 528 | `BuildStructures_FilterManifest` | `manifest` | public |
| 546 | `BuildStructures_IsManifestComplete` | `manifest` | public |
| 567 | `GatherWood_SetupUI` | — | public |
| 578 | `GatherWood_RemoveHint` | — | public |
| 591 | `GatherWood_Start` | — | public |
| 598 | `GatherWood_Monitor` | — | public |
| 618 | `GatherWood_PlayerVenturedIntoForest` | `context, data` | public |
| 646 | `GatherWood_PlayerVenturedIntoForest_ShowBountyHint` | — | public |
| 661 | `GatherPeople_SetupUI` | — | public |
| 671 | `GatherPeople_Start` | — | public |
| 677 | `GatherPeople_Monitor` | — | public |
| 713 | `RebuildMoscow_OnComplete` | — | public |
| 740 | `RebuildMoscow_GetConstructionHintPointText` | `ebp, useRebuildPhrasing` | public |
| 780 | `RebuildMoscow_GetBuildingHeightOffset` | `ebp, hpid_type` | public |

### scenarios\campaign\russia\gdm_chp1_moscow\training_moscow.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `MissionTutorial_Init` | — | public |
| 32 | `MissionTutorial_AddHintToPutOutFire` | — | public |
| 61 | `Trigger_PutOutFire` | `goalSequence` | public |
| 97 | `Ignore_PutOutFire` | `goalSequence` | public |
| 106 | `Predicate_BuildingIsNotOnFire` | `goal` | public |
| 110 | `Bypass_AreAnyVillagersRepairing` | `goalSequence` | public |
| 124 | `MissionTutorial_AddHintToHuntingBounties` | — | public |
| 162 | `Trigger_WolfIsOnScreen` | `goalSequence` | public |
| 187 | `Predicate_UserHasKilledWildAnimal` | `goal` | public |
| 204 | `Predicate_UserHasViewedHuntingBounty` | `goal` | public |
| 227 | `MissionTutorial_AddHintForWoodenFortressLumberCampBonus` | — | public |
| 256 | `Trigger_LumberCampIsOnScreen` | `goalSequence` | public |
| 287 | `Predicate_UserHasStartedBuildingWoodenFortressNearLumberCamp` | `goal` | public |
| 302 | `MissionTutorial_AddHintToDropoffHuntingCabins` | — | public |
| 336 | `Trigger_DropoffHuntingCabinIsOnScreen` | `goalSequence` | public |
| 346 | `Predicate_UserHasSelectedDropoffHuntingCabin` | `goal` | public |
| 355 | `MissionTutorial_AddHintToGoldGenHuntingCabins` | — | public |
| 385 | `Trigger_GoldGenHuntingCabinIsOnScreen` | `goalSequence` | public |
| 411 | `Predicate_UserHasSelectedGoldGenHuntingCabin` | `goal` | public |
| 422 | `MissionTutorial_AddHintToBuildScouts` | — | public |
| 456 | `Trigger_ScoutProductionBuildingIsOnScreen` | `goalSequence` | public |
| 482 | `Predicate_UserHasSelectedScoutProductionBuilding` | `goal` | public |
| 500 | `MissionTutorial_AddHintToGarrisonOutposts` | — | public |
| 530 | `Trigger_OutpostAndUnitIsOnScreen` | `goalSequence` | public |
| 570 | `Predicate_UserHasGarrisonedOutpost` | `goal` | public |

### scenarios\campaign\russia\gdm_chp2_kulikovo\gdm_chp2_kulikovo.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 24 | `Mission_SetupPlayers` | — | public |
| 120 | `Mission_SetupVariables` | — | public |
| 246 | `Mission_SetRestrictions` | — | public |
| 261 | `Mission_Preset` | — | public |
| 304 | `Mission_Start` | — | public |
| 350 | `GetRecipe` | — | public |
| 459 | `Kulikovo_TransitionToEvening` | — | public |
| 463 | `Kulikovo_IncrementWave` | — | public |
| 468 | `Kulikovo_CountMarker` | `player, marker` | public |
| 475 | `Skip` | — | public |
| 487 | `_SkipWarp` | `context, data` | private |
| 495 | `Warp_Fords` | — | public |
| 503 | `Warp_Hill` | — | public |
| 511 | `Warp_Don` | — | public |
| 520 | `Support_SpawnMainlineReinforcements` | — | public |
| 535 | `Support_SpawnLastlineReinforcements` | — | public |
| 550 | `Kulikovo_SpawnWithinPopcap` | `scarType, _numSquads, _destination` | public |
| 556 | `Kulikovo_AddToSpawnTable` | `units, destinationUnitTable, isMainline` | public |
| 582 | `Kulikovo_RefillAmount` | — | public |
| 588 | `Kulikovo_DebugKillAllVillagers` | — | public |
| 597 | `Kulikovo_CheckPlayerArmyDead` | — | public |
| 602 | `Kulikovo_CheckPlayerIsWithinPopCap` | — | public |
| 611 | `Mongol_OnStart` | — | public |
| 619 | `Mongol_SpawnVillageRaid` | `context, data` | public |
| 655 | `Kulikovo_MoveAll` | `marker_name` | public |
| 661 | `Kulikovo_SetQueuedMove` | `lane_name` | public |
| 669 | `Kulikovo_SpawnStartingUnits` | — | public |
| 718 | `Kulikovo_SpawnVillagers` | — | public |
| 727 | `Kulikovo_SkippedIntro` | — | public |
| 744 | `Kulikovo_SpawnRoutingUnits` | — | public |
| 805 | `Outro_DmitryMove` | — | public |
| 811 | `Outro_KnightsMove` | — | public |
| 821 | `Outro_MonkMove` | — | public |
| 831 | `debugprint` | `print_string` | public |
| 834 | `CollectMeat_Kulikovo` | — | public |
| 855 | `Cleanup_MeatCollectors` | — | public |

### scenarios\campaign\russia\gdm_chp2_kulikovo\kulikovotraininggoals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `TrainingGoal_AddVisitVillages` | — | public |
| 26 | `PlayerHasUnitNearKey` | — | public |

### scenarios\campaign\russia\gdm_chp2_kulikovo\obj_cavdetachment.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `CavDetachment_InitObjectives` | — | public |
| 53 | `CavDetachment_StartCavalry` | — | public |
| 65 | `ObjectiveStart_CavDetachment` | — | public |
| 71 | `CavDetachment_ShowCavalryUI` | — | public |
| 150 | `Mission_OnGameRestore` | — | public |
| 160 | `CavDetachment_CavalryButtonClicked` | — | public |
| 170 | `CavDetachment_SpawnCavalryUnits` | `context, data` | public |
| 188 | `CavDetachment_ConvertCavalryToPlayer` | — | public |
| 233 | `CavDetachment_UpdateCavalryText` | — | public |
| 256 | `CavDetachment_ShowXboxCavalryUI` | — | public |

### scenarios\campaign\russia\gdm_chp2_kulikovo\obj_defenselines.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `DefenseLines_InitObjectives` | — | public |
| 346 | `DefenseLines_IsMarkerLost` | `objective, marker, ratio` | public |
| 359 | `DefenseLines_ReinforceTimedBypass` | `context, data` | public |
| 364 | `DefenseLines_UpdateHoldStatus` | `context, data` | public |
| 380 | `DefenseLines_CheckMarkerForUnits` | `marker, minimum, threshold, offset` | public |
| 390 | `_DefenseLines_IsLineSecured` | `data` | private |
| 400 | `_DefenseLines_CanStillHold` | `context, data` | private |
| 432 | `DefenseLines_UpdateStrengthUI` | `context, data` | public |
| 444 | `DefenseLines_UpdateSmolkaFordsUI` | — | public |
| 456 | `DefenseLines_CompareUnitCount` | `marker, threshold, offset` | public |
| 476 | `DefenseLines_MainlineForts` | — | public |
| 489 | `DefenseLines_LastlineForts` | — | public |
| 504 | `DefenseLines_DelayedMainlineSpawn` | — | public |
| 514 | `DefenseLines_DelayedLastlineSpawn` | — | public |
| 526 | `DefenseLines_MainlineCTA` | — | public |
| 532 | `DefenseLines_LastLineCTA` | — | public |
| 538 | `DefenseLines_CheckConstructionComplete` | `context, data` | public |
| 572 | `DefenseLines_CountBuiltStructures` | `marker` | public |
| 583 | `DefenseLines_ReplenishModule` | `module, sgroup, marker` | public |

### scenarios\campaign\russia\gdm_chp2_kulikovo\obj_mongolwaves.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `MongolWaves_InitObjectives` | — | public |
| 362 | `MongolWaves_SetupWave` | `data` | public |
| 395 | `MongolWaves_SpawnWave` | `context, data` | public |
| 436 | `MongolWaves_GenerateModule` | `data` | public |
| 488 | `MongolWaves_CountAlive` | `context, data` | public |
| 508 | `MongolWaves_GenerateThreatArrow` | `sgroup` | public |
| 531 | `MongolWaves_GenerateMinimapBlip` | `opt_leftLane, opt_centerLane, opt_rightLane` | public |
| 567 | `MongolWaves_MonitorDefenselineStatus` | — | public |
| 578 | `MongolWaves_StartNextWave` | — | public |
| 586 | `MongolWaves_GenerateRowOfTargets` | `targets, lane_name, defense_line` | public |
| 604 | `MongolWaves_InitializeWaveStats` | — | public |
| 627 | `MongolWaves_UpdateModuleTargets` | — | public |
| 670 | `MongolWaves_TimedDelayCTA` | `context, data` | public |

### scenarios\campaign\russia\gdm_chp2_kulikovo\obj_preparearmy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `PrepareArmy_InitObjectives` | — | public |
| 275 | `PrepareArmy_FindHiddenVillage` | — | public |
| 285 | `PrepareArmy_RevealFord` | `context, data` | public |
| 297 | `PrepareArmy_CheckNearArmy` | `context, data` | public |
| 329 | `PrepareArmy_CheckCaptured` | `context, data` | public |
| 360 | `PrepareArmy_DelayedMoveArmy` | `context, data` | public |
| 364 | `PrepareArmy_HillContext` | `context, data` | public |
| 385 | `PrepareArmy_DelayedMusicReset` | `context, data` | public |
| 391 | `PrepareArmy_PlayerGoldPickup` | `context, data` | public |

### scenarios\campaign\russia\gdm_chp2_kulikovo\training_kulikovo.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Kulikovo_InitializeCavalryTrainingHints` | — | public |
| 44 | `Kulikovo_CavalryIsAssembled` | `goalSequence` | public |
| 48 | `Kulikovo_CavalryIsCalled` | `goal` | public |
| 57 | `MissionTutorial_AddHintToHuntingBounties` | — | public |
| 86 | `Trigger_WolfIsOnScreen` | `goalSequence` | public |
| 92 | `Predicate_UserHasViewedHuntingAbility` | `goal` | public |
| 110 | `MissionTutorial_Blacksmith` | — | public |
| 121 | `Blacksmith_TriggerPredicate` | `goalSequence` | public |
| 134 | `Blacksmith_BypassPredicate` | `goalSequence` | public |
| 142 | `Blacksmith_BlacksmithIsSelected` | `goal` | public |
| 153 | `UserHasViewedBlacksmithBuilding` | `goal` | public |

### scenarios\campaign\russia\gdm_chp2_tribute\diplomacy_tribute.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Diplomacy_DiplomacyEnabled` | `is_enabled` | public |
| 130 | `Diplomacy_TributeEnabled` | `is_enabled` | public |
| 138 | `Diplomacy_OnInit` | — | public |
| 145 | `Diplomacy_Start` | — | public |
| 167 | `Diplomacy_OnGameOver` | — | public |
| 175 | `Diplomacy_OnGameRestore` | — | public |
| 188 | `Diplomacy_ToggleDiplomacyUI` | — | public |
| 202 | `Diplomacy_ShowDiplomacyUI` | `show` | public |
| 212 | `Diplomacy_IsPanelOpen` | — | public |
| 218 | `Diplomacy_ChangeRelation` | `parameter` | public |
| 224 | `Diplomacy_IncreaseTribute` | `parameter` | public |
| 235 | `Diplomacy_DecreaseTribute` | `parameter` | public |
| 246 | `Diplomacy_ClearTribute` | — | public |
| 259 | `Diplomacy_SendTribute` | — | public |
| 278 | `Diplomacy_ShowUI` | `show` | public |
| 292 | `Diplomacy_OnRelationshipChanged` | `observerPlayerID, targetPlayerID, show_notification` | public |
| 335 | `Diplomacy_OnConstructionComplete` | `context` | public |
| 351 | `Diplomacy_OnPlayerDefeated` | `player, reason` | public |
| 375 | `Diplomacy_OnPlayerNameChanged` | `context` | public |
| 387 | `Diplomacy_OnUpgradeComplete` | `context` | public |
| 408 | `Diplomacy_UpdateDataContext` | — | public |
| 508 | `Diplomacy_OverridePlayerSettings` | `playerID, is_player_visible, is_tribute_visible, is_food_enabled, is_wood_enabled, is_gold_enabled, is_stone_enabled` | public |
| 526 | `Diplomacy_OverrideSettings` | `is_tribute_enabled, is_subtotal_visible, is_score_visible, is_team_visible` | public |
| 537 | `Diplomacy_RelationConverter` | `relation` | public |
| 559 | `Diplomacy_RelationToTooltipConverter` | `observer, target` | public |
| 583 | `Diplomacy_GetTaxRate` | `playerID` | public |
| 589 | `Diplomacy_SetTaxRate` | `playerID, tax_rate` | public |
| 596 | `Diplomacy_AddTribute` | `player_index, resource_index, amount` | public |
| 632 | `Diplomacy_CreateDataContext` | — | public |
| 713 | `Diplomacy_FormatTeamNumber` | `team_number` | public |
| 722 | `Diplomacy_SortDataContext` | — | public |
| 735 | `Diplomacy_CreateUI` | — | public |
| 1400 | `Diplomacy_RemoveUI` | — | public |
| 1408 | `Diplomacy_UpdateUI` | — | public |
| 1415 | `Rule_Diplomacy_UpdateUI` | — | public |
| 1422 | `Diplomacy_Restart` | — | public |
| 1429 | `Diplomacy_ShowEventCue` | `tribute` | public |
| 1457 | `Diplomacy_ChangeRelationNtw` | `playerID, data` | public |
| 1472 | `Diplomacy_SendTributeNtw` | `playerID, data` | public |

### scenarios\campaign\russia\gdm_chp2_tribute\gdm_chp2_tribute.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 19 | `Mission_OnGameSetup` | — | public |
| 33 | `Mission_SetupPlayers` | — | public |
| 104 | `Mission_SetupVariables` | — | public |
| 169 | `Mission_SetDifficulty` | — | public |
| 202 | `Mission_PreInit` | — | public |
| 210 | `Mission_OnInit` | — | public |
| 218 | `Mission_Preset` | — | public |
| 285 | `AssignTradeCartToSettlement` | `tradecart, settlement` | public |
| 292 | `GetRecipe` | — | public |
| 397 | `Mission_Start` | — | public |
| 426 | `Mission_Start_PartB` | — | public |
| 440 | `Mission_CheckForFail` | — | public |
| 460 | `Mission_AdjustPlayerMaxPopCap` | `player, adjustment` | public |
| 493 | `Mission_PrepareForOutro` | — | public |
| 543 | `Mission_SendIntroTradeCart` | — | public |
| 562 | `IntroShenanigans` | — | public |
| 570 | `TributeIntro_FakeTradeCartDropOffGold` | — | public |
| 585 | `Tribute_FancyAtmosphere` | `context, data` | public |

### scenarios\campaign\russia\gdm_chp2_tribute\obj_banditcamps.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `BanditCamps_InitObjectives` | — | public |
| 121 | `BanditCamps_Init` | — | public |
| 203 | `BanditCamps_SetupUI` | — | public |
| 208 | `BanditCamps_Monitor` | — | public |
| 293 | `BanditCamps_CampEntityDestroyed` | `context` | public |

### scenarios\campaign\russia\gdm_chp2_tribute\obj_buildcabins.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `BuildCabins_InitObjectives` | — | public |
| 33 | `BuildCabins_TriggerObjective` | — | public |
| 42 | `BuildCabins_SetupUI` | — | public |
| 49 | `BuildCabins_Start` | — | public |
| 56 | `BuildCabins_Monitor` | — | public |
| 84 | `BuildCabins_NewCabinBuilt` | `context, data` | public |
| 132 | `BuildCabins_ClearHintPoint` | `context, data` | public |

### scenarios\campaign\russia\gdm_chp2_tribute\obj_buysettlements.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `BuySettlements_InitObjectives` | — | public |
| 160 | `BuySettlements_Start` | — | public |
| 170 | `BuySettlements_SetupUI` | — | public |
| 181 | `BuySettlements_OnStart` | — | public |
| 190 | `BuySettlements_OnTradeEvent` | `context` | public |
| 203 | `BuySettlements_Monitor` | — | public |
| 295 | `BuySettlements_TradeCartKilled_EventCue` | `cart` | public |
| 324 | `BuySettlements_TradeCartKilled_EventCueCallback` | `id` | public |
| 336 | `BuySettlements_FindSettlement` | `item` | public |
| 358 | `BuySettlements_Purchase` | `settlement` | public |
| 478 | `BuySettlements_Purchase_BuildTower` | `context, data` | public |
| 493 | `BuySettlements_FirstPurchase_MonitorForConstruction` | `context, data` | public |
| 509 | `BuySettlements_StartFindMoreSettlementsObjective` | — | public |
| 521 | `BuySettlements_CollectIncome` | — | public |
| 542 | `BuySettlements_OnComplete` | — | public |
| 551 | `BuySettlements_TellPlayerTheyNeedMoreTrade` | — | public |
| 573 | `BuySettlements_TellPlayerTheyNeedMoreTrade_Complete` | — | public |
| 589 | `BuySettlements_GetActiveTraderCount` | `settlement` | public |
| 604 | `UI_BuySettlementsPanel_UpdateData` | — | public |
| 721 | `UI_BuySettlementsPanel_ViewButtonCallback` | `parameter` | public |
| 733 | `UI_BuySettlementsPanel_BuyButtonCallback` | `parameter` | public |

### scenarios\campaign\russia\gdm_chp2_tribute\obj_collecttaxes.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `CollectTaxes_InitObjectives` | — | public |
| 73 | `CollectTaxes_Start` | — | public |
| 88 | `CollectTaxes_DiscoverNewSettlements` | — | public |
| 141 | `CollectTaxes_MarkSettlementAsSeen` | `settlement` | public |
| 169 | `CollectTaxes_NewSettlementsIntro` | — | public |
| 175 | `CollectTaxes_RemindPlayerToSearchForSettlements` | — | public |
| 186 | `CollectTaxes_MonitorBanditsSpotted` | — | public |
| 203 | `CollectTaxes_TriggerTraderHint` | — | public |
| 235 | `Bandits_Init` | — | public |
| 534 | `Bandits_Start` | — | public |
| 545 | `Bandits_Monitor` | — | public |
| 624 | `Bandits_PauseWhileCombatIsHappening` | — | public |
| 668 | `Bandits_LeaveTheMapPlease` | `context, data` | public |
| 686 | `Bandits_GetDesiredBanditData` | `zone` | public |
| 709 | `Bandits_GetDesiredBanditDataForSettlement` | `settlement` | public |
| 732 | `Bandits_GetDesiredBanditDataForWanderers` | `settlementsPurchased` | public |
| 748 | `Bandits_ChooseLoadout` | `desiredBandits, currentGroups` | public |
| 782 | `Bandits_CreateNewGroup` | `context, data` | public |
| 832 | `Bandits_IsMarketNearSettlement` | `settlement` | public |
| 843 | `Bandits_AddExtraWandererMarkers` | — | public |
| 884 | `Bandits_GetUniqueDescriptor` | `zone` | public |
| 905 | `Bandits_ChooseSpawnLocation` | `destination` | public |

### scenarios\campaign\russia\gdm_chp2_tribute\obj_paythemongols.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `PayTheMongols_InitObjectives` | — | public |
| 80 | `PayTheMongols_StartObjective` | — | public |
| 141 | `PayTheMongols_SetupUI` | — | public |
| 144 | `PayTheMongols_GoldAmount_SetupUI` | — | public |
| 149 | `PayTheMongols_OnStart` | — | public |
| 168 | `PayTheMongols_Monitor` | — | public |
| 252 | `PayTheMongols_AttemptAutoPay` | — | public |
| 278 | `PayTheMongols_OnCallToActionClicked` | — | public |
| 285 | `Mission_OnTributeSent` | `tribute` | public |
| 300 | `PayTheMongols_TriggerMarketHint` | — | public |
| 322 | `MongolArmy_Start` | — | public |
| 328 | `MongolArmy_Start_PartB` | — | public |
| 437 | `MongolArmy_Spawn` | `context, data` | public |
| 487 | `MongolArmy_GetUniqueDescriptor` | — | public |
| 500 | `MongolArmy_Finish` | — | public |

### scenarios\campaign\russia\gdm_chp2_tribute\training_tribute.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 16 | `MissionTutorial_Init` | — | public |
| 30 | `Predicate_UserHasOpenedTheDiplomacyMenu` | — | public |
| 38 | `Predicate_UserHasSelectedAMarket` | — | public |
| 44 | `Predicate_UserHasLookedAtMarketBuySellButtons` | `goal` | public |
| 60 | `Predicate_UserHasLookedAtBuildTraderButton` | `goal` | public |
| 74 | `Ignore_IfMarketIsDestroyed` | `goalSequence` | public |
| 93 | `MissionTutorial_AddHintToDmitry_Xbox` | — | public |
| 146 | `MissionTutorial_AddHintToDmitry` | — | public |
| 189 | `Predicate_UserHasSelectedDmitry` | `goal` | public |
| 195 | `Predicate_UserHasLookedAtDmitryAbility` | `goal` | public |
| 201 | `Predicate_UserHasNotActivatedDmitryLeaderAbilityRecently` | `goalSequence` | public |
| 208 | `MissionTutorial_AddHintToPayMongols` | — | public |
| 238 | `Predicate_ShouldHighlightTributeButton` | `goalSequence` | public |
| 246 | `MissionTutorial_AddHintToBuySettlements` | — | public |
| 277 | `MissionTutorial_AddHintToBuildTraders_Xbox` | — | public |
| 336 | `MissionTutorial_AddHintToBuildTraders` | — | public |
| 386 | `MissionTutorial_AddHintToUseMarket_Xbox` | — | public |
| 445 | `MissionTutorial_AddHintToUseMarket` | — | public |
| 499 | `MissionTutorial_AddHintToBuildDefencesAroundSettlement` | `settlement` | public |
| 530 | `Predicate_UserHasBuiltDefences` | — | public |
| 543 | `Tips_InitObjectives` | — | public |

### scenarios\campaign\russia\gdm_chp3_moscow\diplomacy_chp3_moscow.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Diplomacy_DiplomacyEnabled` | `is_enabled` | public |
| 126 | `Diplomacy_TributeEnabled` | `is_enabled` | public |
| 134 | `Diplomacy_OnInit` | — | public |
| 141 | `Diplomacy_Start` | — | public |
| 163 | `Diplomacy_OnGameOver` | — | public |
| 171 | `Diplomacy_OnGameRestore` | — | public |
| 183 | `Diplomacy_ToggleDiplomacyUI` | — | public |
| 198 | `Diplomacy_ShowDiplomacyUI` | `show` | public |
| 210 | `Diplomacy_ChangeRelation` | `parameter` | public |
| 216 | `Diplomacy_IncreaseTribute` | `parameter` | public |
| 227 | `Diplomacy_DecreaseTribute` | `parameter` | public |
| 238 | `Diplomacy_ClearTribute` | — | public |
| 251 | `Diplomacy_SendTribute` | — | public |
| 270 | `Diplomacy_ShowUI` | `show` | public |
| 284 | `Diplomacy_OnRelationshipChanged` | `observerPlayerID, targetPlayerID, show_notification` | public |
| 327 | `Diplomacy_OnConstructionComplete` | `context` | public |
| 343 | `Diplomacy_OnPlayerDefeated` | `player, reason` | public |
| 367 | `Diplomacy_OnPlayerNameChanged` | `context` | public |
| 379 | `Diplomacy_OnUpgradeComplete` | `context` | public |
| 400 | `Diplomacy_UpdateDataContext` | — | public |
| 491 | `Diplomacy_OverridePlayerSettings` | `playerID, is_player_visible, is_tribute_visible, is_food_enabled, is_wood_enabled, is_gold_enabled, is_stone_enabled` | public |
| 509 | `Diplomacy_OverrideSettings` | `is_tribute_enabled, is_subtotal_visible, is_score_visible, is_team_visible` | public |
| 520 | `Diplomacy_RelationConverter` | `relation` | public |
| 542 | `Diplomacy_RelationToTooltipConverter` | `observer, target` | public |
| 566 | `Diplomacy_GetTaxRate` | `playerID` | public |
| 572 | `Diplomacy_SetTaxRate` | `playerID, tax_rate` | public |
| 579 | `Diplomacy_AddTribute` | `player_index, resource_index, amount` | public |
| 615 | `Diplomacy_CreateDataContext` | — | public |
| 696 | `Diplomacy_FormatTeamNumber` | `team_number` | public |
| 705 | `Diplomacy_SortDataContext` | — | public |
| 718 | `Diplomacy_CreateUI` | — | public |
| 973 | `Diplomacy_RemoveUI` | — | public |
| 981 | `Diplomacy_UpdateUI` | — | public |
| 988 | `Rule_Diplomacy_UpdateUI` | — | public |
| 995 | `Diplomacy_Restart` | — | public |
| 1002 | `Diplomacy_ShowEventCue` | `tribute` | public |
| 1030 | `Diplomacy_ChangeRelationNtw` | `playerID, data` | public |
| 1045 | `Diplomacy_SendTributeNtw` | `playerID, data` | public |

### scenarios\campaign\russia\gdm_chp3_moscow\gdm_chp3_moscow.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupPlayers` | — | public |
| 87 | `Mission_SetupVariables` | — | public |
| 153 | `Mission_SetDifficulty` | — | public |
| 183 | `Mission_PreInit` | — | public |
| 191 | `Mission_SetRestrictions` | — | public |
| 211 | `Mission_Preset` | — | public |
| 238 | `Mission_Start` | — | public |
| 258 | `GetRecipe` | — | public |
| 365 | `Mission_VillagerSetup` | — | public |
| 397 | `Mission_TrickleResources` | — | public |
| 407 | `Init_MongolInvasion` | — | public |
| 498 | `NewMongolWave` | — | public |
| 506 | `NewMongolArmy` | — | public |
| 612 | `ResetDrums` | — | public |
| 616 | `Get_MongolUnits` | `mongolCount` | public |
| 674 | `Get_MongolUnitsStory` | `mongolCount` | public |
| 718 | `Emergency_Cleanup` | — | public |
| 738 | `GetOutsideTarget` | `rovingArmy` | public |
| 785 | `UpdateWoodArmy` | — | public |
| 798 | `UpdateStoneArmy` | — | public |
| 811 | `OnWoodArmyDeath` | — | public |
| 815 | `NewWoodArmy` | — | public |
| 830 | `PositionArchers` | — | public |
| 850 | `Trebuchet_Intel` | — | public |
| 857 | `Tribute_Intel` | — | public |
| 864 | `Reinforcement_Intel` | — | public |
| 872 | `Reinforcement_Intel_Cooldown` | — | public |
| 876 | `MongolAttack_FleeingCitizens` | — | public |
| 935 | `Wispness` | — | public |

### scenarios\campaign\russia\gdm_chp3_moscow\obj_mongolattacks.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `MongolAttacks_InitializeObjectives` | — | public |
| 33 | `MongolAttacks_OnStart` | — | public |
| 51 | `MongolAttacks_OuterCityBreached` | — | public |
| 77 | `Dip_Remind` | — | public |
| 93 | `MongolAttacks_OuterCityBreached_PartB` | — | public |
| 104 | `MongolAttacks_OuterCityDestroyed` | — | public |
| 115 | `MongolAttacks_CheckLastWaveFinished` | — | public |
| 132 | `MongolAttacks_HalfwayThere` | — | public |
| 139 | `MongolRetreat` | — | public |
| 143 | `Mongols_CTA` | — | public |
| 156 | `DeclareFinalMongols` | — | public |
| 179 | `FinalMongols` | — | public |
| 205 | `Infinite_Mongols` | — | public |
| 225 | `BeginTheEnd` | — | public |
| 239 | `Init_KhansArmy` | — | public |
| 279 | `Sgroup_FilterUnfinishedRams` | `targetSgroup` | public |

### scenarios\campaign\russia\gdm_chp3_moscow\obj_moscowdefense.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `MoscowDefense_InitializeObjectives` | — | public |
| 39 | `MoscowDefense_OnStart` | — | public |
| 45 | `MongolAttacks_CountBuildingsInOuterCity` | — | public |
| 54 | `MongolAttacks_BreachedUnits` | — | public |
| 83 | `MongolAttacks_StartCountdownToFailure` | — | public |
| 94 | `MongolAttacks_CountdownToFailure` | — | public |
| 103 | `MongolAttacks_StopCountdownToFailure` | — | public |
| 113 | `MongolsInsideCTA` | — | public |
| 130 | `ResetMongolsInsideCTA` | — | public |

### scenarios\campaign\russia\gdm_chp3_moscow\obj_prepare.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Prepare_InitObjectives` | — | public |
| 143 | `Prepare_OnStart` | — | public |
| 147 | `Prepare_OnComplete` | — | public |
| 154 | `Attack_OnStart` | — | public |
| 160 | `StartRefugees` | — | public |
| 165 | `StartMongols` | — | public |
| 175 | `UI_ReinforcePanel_UpdateData` | — | public |
| 251 | `UI_RequestAid_ButtonCallback` | `parameter` | public |
| 270 | `Start_CTACooldown` | `target` | public |
| 289 | `ReinforceCTA_Cooldown` | — | public |

### scenarios\campaign\russia\gdm_chp3_moscow\obj_refugees.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Refugees_InitObjectives` | — | public |
| 47 | `Refugees_PreStart` | — | public |
| 51 | `Refugees_OnStart` | — | public |
| 73 | `RefugeesIntro` | — | public |
| 99 | `HelpStuckRefugees` | `sg_refstuck` | public |
| 111 | `Refugees_CTA` | — | public |
| 130 | `Refugee_FearWalla` | — | public |
| 144 | `Refugee_CTA_Activate` | — | public |
| 154 | `RefugeesOutro` | — | public |
| 190 | `Track_RefugeeCount` | — | public |
| 216 | `RefugeesRemaining` | `context` | public |
| 223 | `RampUpEndingDanger` | — | public |
| 237 | `EnsureFleeing` | — | public |

### scenarios\campaign\russia\gdm_chp3_moscow\training_moscow3.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 19 | `Moscow3_Tutorials_Init` | — | public |
| 25 | `MissionTutorial_Init` | — | public |
| 38 | `_DelayShortTimeElapsed` | `goal` | private |
| 50 | `MissionTutorial_Reinforce` | — | public |
| 60 | `Predicate_UserHasOpenedTheDiplomacyMenu` | `goalSequence` | public |
| 71 | `MissionTutorial_WoodTower` | — | public |
| 85 | `WoodTower_TriggerPredicate` | `goalSequence` | public |
| 112 | `WoodTower_BypassPredicate` | `goalSequence` | public |
| 127 | `WoodTower_VillagerIsSelected` | `goal` | public |
| 141 | `WoodTower_TowerIsGarrisoned` | `goal` | public |
| 163 | `MissionTutorial_SelectAll` | — | public |
| 173 | `SelectAll_PredicateStart` | `goalSequence` | public |
| 177 | `SelectAll_UserHasSelectedAll` | `goal` | public |

### scenarios\campaign\russia\gdm_chp3_novgorod\gdm_chp3_novgorod.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupPlayers` | — | public |
| 78 | `Mission_SetupVariables` | — | public |
| 210 | `Mission_SetRestrictions` | — | public |
| 214 | `Mission_Preset` | — | public |
| 270 | `Mission_SetDifficulty` | — | public |
| 302 | `Mission_Start` | — | public |
| 334 | `GetRecipe` | — | public |
| 662 | `CheckPlayerReachedSkirino` | — | public |
| 673 | `Novgorod_SpawnStartingUnits` | — | public |
| 699 | `Novgorod_MoveStartingUnits` | — | public |
| 793 | `Intro_RoutVillagers` | — | public |
| 799 | `Move_ScoutIntro` | — | public |
| 810 | `SetIntroScoutDefend` | — | public |
| 816 | `AttackPlayerCloseFort` | — | public |
| 823 | `Mission_AddMoreWolvesNovgorod` | — | public |
| 861 | `Mission_SpawnDeersStartArea` | — | public |
| 878 | `ShootDeers` | — | public |
| 882 | `Mission_AddMoreAnimalsNovgorod` | — | public |
| 911 | `Mission_AddMoreAnimalsNovgorodTown01` | — | public |
| 939 | `SetupAttackWaves` | — | public |
| 1080 | `Novgorod_AreSGroupsDestroyed` | `sgroup_table` | public |
| 1091 | `Novgorod_CountSGroups` | `sgroup_table` | public |
| 1104 | `Novgorod_SoltsyWallWalla` | `context` | public |
| 1111 | `Novgorod_SkirinoWallWalla` | `context` | public |
| 1119 | `Novgorod_NovgorodOuterWallWalla` | `context` | public |
| 1126 | `Novgorod_NovgorodInnerWallWalla` | `context` | public |
| 1133 | `Novgorod_DelayedAudioStinger` | `context, data` | public |
| 1147 | `Novgorod_ProxFunctionCall` | `context, data` | public |
| 1154 | `Novgorod_SkirinoVillagerLife` | — | public |
| 1174 | `Novgorod_NovgorodVillagerLife` | — | public |
| 1206 | `Novgorod_OutroSequence` | — | public |
| 1229 | `IvanMovesOnTown` | — | public |
| 1274 | `Ivan_SendOutroCav` | `context, data` | public |

### scenarios\campaign\russia\gdm_chp3_novgorod\obj_capture_village.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `CaptureLocations_Initkuklino` | — | public |
| 137 | `CaptureLocations_Initsoltsy` | — | public |
| 217 | `CaptureLocations_InitOptionalObjectives` | — | public |
| 335 | `CaptureVillage_DelayedMiddleBattleStart` | — | public |
| 340 | `Monitor_HolySites` | — | public |
| 357 | `MonitorPlayerGold` | — | public |
| 376 | `CaptureVillage_KuklinoProximityStinger` | — | public |
| 384 | `CaptureVillage_SoltsyProximityVO` | — | public |
| 390 | `CaptureVillage_KuklinoWood` | — | public |
| 396 | `Mission_CheckTC` | — | public |
| 406 | `SendVillagers_Farm_soltsy` | — | public |
| 426 | `PreparekuklinoWaveTosoltsy` | — | public |
| 472 | `CaptureVillagesNov_OnComplete` | — | public |
| 477 | `PreparesoltsyWaveTokuklino` | — | public |
| 523 | `Start_SkorinoWaves` | — | public |
| 530 | `SkorinoForcesApproachTown_Monitor` | — | public |
| 544 | `PrepareSkirinoWave` | — | public |
| 589 | `Start_NovgorodWaves` | — | public |
| 595 | `PrepareNovgorodWave` | — | public |
| 647 | `Delayed_MilitiaAddition` | — | public |
| 654 | `Delayed_MilitiaAddition_DelayedAdd` | — | public |

### scenarios\campaign\russia\gdm_chp3_novgorod\obj_destroy_novgorod.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `DestroyNovgorod_InitObjectives` | — | public |
| 103 | `NovgorodProvePower_IntensityMusicChange` | — | public |
| 108 | `FindVecheBell_Monitor` | — | public |
| 120 | `VecheBell_VOThresholdTrigger` | — | public |
| 139 | `DestroyVecheBell_OnComplete` | — | public |
| 145 | `DestroyTheKremlin_UI` | — | public |
| 150 | `DestroyTheKremlin_Start` | — | public |
| 155 | `DestroyTheKremlin_Monitor` | — | public |
| 164 | `DestroyTheKremlin_OnComplete` | — | public |
| 171 | `DestroyUniversity_UI` | — | public |
| 175 | `DestroyUniversity_Start` | — | public |
| 181 | `DestroyUniversity_Monitor` | — | public |
| 189 | `DestroyUniversity_OnComplete` | — | public |

### scenarios\campaign\russia\gdm_chp3_novgorod\obj_getthroughnovgorod.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `GetThroughNovgorodDefences_InitObjectives` | — | public |
| 107 | `NovgorodMarchThrough_SetMusic` | — | public |
| 112 | `ResetMusicRegularEnterNov` | — | public |

### scenarios\campaign\russia\gdm_chp3_novgorod\obj_middle_battle.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `middle_battle_InitObjectives` | — | public |
| 131 | `CountEnemiesKilledFortShelon` | — | public |
| 148 | `EnemyKilledFortShelonDefEvent` | `context` | public |
| 164 | `MiddleBattle_OnCompleteTimer` | — | public |

### scenarios\campaign\russia\gdm_chp3_novgorod\training_novgorod.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Training_InitNov` | — | public |
| 41 | `TimerORIgnore_UserCannotSeeSquadKey` | `goalSequence` | public |
| 49 | `Tutorials_novgorod_HintHuntingBounty` | — | public |
| 90 | `Tutorials_novgorod_HintCabin_Xbox` | — | public |
| 130 | `Tutorials_novgorod_HintCabin` | — | public |
| 158 | `Tutorials_novgorod_HintHolySite` | — | public |
| 188 | `novgorod_OnAbilityExecutedRightTime` | `context` | public |
| 203 | `HasIdleVillagerCabinOnScreenNov_Xbox` | `goalSequence` | public |
| 234 | `HasIdleVillagerCabinOnScreenNov` | `goalSequence` | public |
| 274 | `Nov_CabinEconRadialOpen` | `goal` | public |
| 279 | `UserHasStartedToBuildAHuntingCabinNov` | `goal` | public |
| 283 | `UserIsGoingToBuildAHuntingCabinNov` | `goal` | public |
| 287 | `UserHasRelicNov` | `goal` | public |
| 300 | `UserHasBuiltCabinNov` | `goalSequence` | public |
| 316 | `UserHasViewedHuntingCabinNov` | `goal` | public |
| 330 | `UserHasViewedHuntingAbilityNov` | `goal` | public |
| 344 | `UserHasSelectedAVillagerNov` | `goal` | public |
| 360 | `HasHolySiteOnScreenNov` | `goalSequence` | public |
| 396 | `UserHasCapturedHolySite_Nov` | `goal` | public |
| 421 | `UserHasSelectedIvanNov` | `goal` | public |
| 436 | `UserHasSelectedAMonkNov` | `goal` | public |
| 453 | `HasIdleVillagerOnScreenNov` | `goalSequence` | public |
| 484 | `Predicate_UserHasViewedHuntingAbility` | `goal` | public |
| 502 | `_DelayTimeElapsed` | `goal` | private |
| 515 | `MissionTutorial_IvanLeaderAura_XBox` | — | public |
| 569 | `MissionTutorial_IvanLeaderAura` | — | public |
| 612 | `Predicate_UserHasSelectedIvan` | `goal` | public |
| 619 | `Predicate_UserHasLookedAtIvanAbility` | `goal` | public |
| 626 | `Predicate_UserHasNotActivatedIvanLeaderAbilityRecently` | `goalSequence` | public |
| 635 | `Nov_PickConvenientVillager` | — | public |

### scenarios\campaign\russia\gdm_chp3_ugra\gdm_chp3_ugra_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 41 | `AutoTest_OnInit` | — | public |
| 71 | `AutomatedUgra_RegisterCheckpoints` | — | public |
| 97 | `AutoTest_SkipAndStart` | — | public |
| 106 | `AutoTest_PlayIntro` | — | public |
| 121 | `AutomatedMission_Start` | — | public |
| 126 | `AutomatedUgra_Phase0_CheckPlayStart` | — | public |
| 136 | `AutomatedUgra_Phase1_SetUpPhase1` | — | public |
| 192 | `_AutomatedUgra_Delay_TowerBuild` | `context, data` | private |
| 201 | `AutomatedUgra_Phase1_QueryFordsStocked` | — | public |
| 214 | `AutomatedUgra_Phase2_QueryRepelCompletion` | — | public |
| 224 | `AutomatedUgra_Optional_EliminateReinforcments` | — | public |
| 247 | `AutomatedUgra_Phase3_QueryFordsHeld` | — | public |
| 259 | `AutomatedUgra_Phase4_QueryMissionVictory` | — | public |
| 270 | `_AutomatedUgra_UnitReplenish` | `context, data` | private |
| 306 | `AutomatedUgra_VillagerWalls_Init` | — | public |
| 328 | `_AutomatedUgra_VillagerWalls_Monitor_North` | — | private |
| 340 | `_AutomatedUgra_VillagerWalls_Monitor_South` | — | private |
| 354 | `Player_RovingArmy` | — | public |

### scenarios\campaign\russia\gdm_chp3_ugra\gdm_chp3_ugra.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 10 | `Mission_SetupVariables` | — | public |
| 121 | `Mission_SetupPlayers` | — | public |
| 159 | `Mission_Preset` | — | public |
| 193 | `Mission_Start` | — | public |
| 247 | `GetRecipe` | — | public |
| 797 | `Ugra_InitEnemyUnits` | — | public |
| 858 | `Ugra_InitPlayerUnits` | — | public |
| 918 | `Ugra_AddVillagersToCheer` | `context, data` | public |
| 931 | `Ugra_SendIvanCheck` | — | public |
| 942 | `Ugra_AssignStartingMonUnits` | — | public |
| 954 | `Ugra_BackupFordCombat` | — | public |
| 958 | `Ugra_SendIntroUnits` | `sgroup, delay, markerList, finalDestination, warpToFinalPosOnSkip` | public |
| 982 | `Ugra_SendIntroUnits_Delayed` | `context, data` | public |
| 995 | `Ugra_GatherSheep` | — | public |
| 1008 | `Achievement_OnEntityKilled` | `context` | public |
| 1042 | `Ugra_SkipIntro` | — | public |
| 1063 | `Ugra_CheckMissionEndCondition` | — | public |

### scenarios\campaign\russia\gdm_chp3_ugra\obj_attackmongols.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `AttackMongols_InitObjectives` | — | public |
| 71 | `AttackMongols_Start` | — | public |
| 74 | `Ugra_CheckTownCenterDestroyed` | — | public |
| 83 | `Ugra_OnEntityKilled` | `context` | public |
| 98 | `Ugra_ConvoyRetreat` | — | public |
| 105 | `Ugra_DelayRetreat` | — | public |
| 109 | `Ugra_DefendersRetreatOnEngage` | — | public |
| 125 | `Ugra_SGroupRetreatFraction` | `module, numToOne` | public |
| 141 | `Ugra_PackUpBuildings` | — | public |
| 190 | `Ugra_InitOutro` | — | public |
| 256 | `Late_Cav_Outro` | — | public |
| 286 | `Cannon_Fire_Outro` | — | public |
| 298 | `Cannon_Fire_Stop` | — | public |
| 304 | `Outro_Ivan_Parade` | — | public |
| 321 | `Ugra_GetRandomRetreatPoint` | — | public |
| 335 | `Ugra_SpawnExtraMongols` | — | public |

### scenarios\campaign\russia\gdm_chp3_ugra\obj_holdfords.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `HoldFords_InitObjectives` | — | public |
| 151 | `Ugra_OnSquadKilled` | `context` | public |
| 167 | `Ugra_SplitAndFallback` | — | public |
| 242 | `Ugra_TimerComplete` | — | public |
| 248 | `Ugra_UpdateForceCount` | — | public |
| 338 | `Ugra_NorthFordDelayedLaunch` | — | public |
| 361 | `Ugra_SouthFordDelayedLaunch` | — | public |
| 385 | `Ugra_EvaluateForceValue` | `sgroup` | public |
| 402 | `Ugra_BuildNewMongolProduction` | — | public |
| 408 | `Ugra_Phase2` | — | public |
| 429 | `Ugra_Phase3` | — | public |
| 450 | `Ugra_Phase4` | — | public |
| 471 | `Ugra_ReinforceFords` | — | public |
| 478 | `Ugra_NorthAttackCooldown` | — | public |
| 482 | `Ugra_SouthAttackCooldown` | — | public |
| 486 | `Ugra_FordStartGraceDelay` | — | public |
| 490 | `Ugra_ReinforceDelay` | — | public |
| 495 | `Ugra_SplitModule` | `module, moduleList` | public |
| 538 | `Ugra_PlayerHasWalls` | — | public |
| 545 | `Ugra_ProbeFord` | — | public |
| 624 | `Ugra_MongolDrumDelay` | — | public |
| 629 | `Ugra_ReinforcementTrain` | — | public |
| 670 | `Ugra_SouthernReinforcementsCheck` | — | public |
| 680 | `Ugra_ReleaseReinforcements` | — | public |
| 704 | `Ugra_UnpackSouthernReinforcements` | — | public |
| 716 | `Ugra_WarnPlayerIfTheyCrossTheFords` | — | public |

### scenarios\campaign\russia\gdm_chp3_ugra\obj_mongolwaves.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `MongolWaves_InitObjectives` | — | public |
| 170 | `MongolWaves_CheckPrepareCompletion` | — | public |
| 180 | `MongolWaves_CheckMoveUnitStart` | — | public |
| 192 | `RepelWave1_Start` | — | public |
| 196 | `RepelWave2_Start` | — | public |
| 215 | `Ugra_PrepareTimerComplete` | — | public |

### scenarios\campaign\russia\gdm_chp3_ugra\training_ugra.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `_DelayTimeElapsed` | `goal` | private |
| 23 | `MissionTutorial_IvanLeaderAura_XBox` | — | public |
| 77 | `MissionTutorial_IvanLeaderAura` | — | public |
| 120 | `Predicate_UserHasSelectedIvan` | `goal` | public |
| 127 | `Predicate_UserHasLookedAtIvanAbility` | `goal` | public |
| 134 | `Predicate_UserHasNotActivatedIvanLeaderAbilityRecently` | `goalSequence` | public |

### scenarios\campaign\russia\gdm_chp3_ugra\ugra_combatvalue.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 26 | `Ugra_InitializeUnitValues` | — | public |

### scenarios\campaign\russia\gdm_chp4_kazan\gdm_chp4_kazan.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Mission_SetupVariables` | — | public |
| 125 | `Mission_SetupPlayers` | — | public |
| 180 | `Mission_SetRestrictions` | — | public |
| 199 | `Mission_Preset` | — | public |
| 242 | `Mission_Start` | — | public |
| 257 | `GetRecipe` | — | public |
| 1164 | `Kazan_InitStartingUnits` | — | public |
| 1195 | `Kazan_WeakenTatarSettlement` | — | public |
| 1204 | `Kazan_MoveStartingUnits_Archers` | — | public |
| 1210 | `Kazan_MoveStartingUnits_Cavalry` | — | public |
| 1221 | `Kazan_RetreatScouts` | — | public |
| 1229 | `Kazan_MoveStartingUnits_Infantry` | — | public |
| 1254 | `Kazan_PositionArchersAndCav` | — | public |
| 1271 | `Kazan_GroupWallsForObjectives` | — | public |
| 1288 | `Kazan_SpawnCavAttackWave` | `context, options` | public |
| 1552 | `Kazan_SetIntensity` | `newIntensity, context` | public |
| 1561 | `Kazan_SkipIntro` | — | public |
| 1601 | `Kazan_CheckFailure` | — | public |
| 1627 | `Achievement_CheckAnnihilation` | — | public |
| 1651 | `TriggerContextObjective` | — | public |

### scenarios\campaign\russia\gdm_chp4_kazan\kazan_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `_DelayTimeElapsed` | `goal` | private |
| 24 | `MissionTutorial_KazanLeaderAura_Xbox` | — | public |
| 78 | `MissionTutorial_KazanLeaderAura` | — | public |
| 121 | `Predicate_UserHasSelectedIvan` | `goal` | public |
| 128 | `Predicate_UserHasLookedAtIvanAbility` | `goal` | public |
| 135 | `Predicate_UserHasNotActivatedIvanLeaderAbilityRecently` | `goalSequence` | public |

### scenarios\campaign\russia\gdm_chp4_kazan\obj_clearwestford.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `ClearFordBase_InitObjectives` | — | public |
| 59 | `WestFordApproached` | — | public |

### scenarios\campaign\russia\gdm_chp4_kazan\obj_securefort.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `SecureFort_InitObjectives` | — | public |
| 147 | `Kazan_OnEntityDestroyed` | `context` | public |
| 176 | `Kazan_AddMissionFailureCheckLoop` | — | public |
| 180 | `Kazan_IntensityCheck` | — | public |
| 195 | `Kazan_SpawnVillagers` | — | public |
| 231 | `Kazan_MoveTransport` | — | public |
| 238 | `Kazan_UnloadVillagers` | — | public |
| 246 | `Kazan_ToggleMonkHeal` | — | public |
| 260 | `Kazan_DespawnTransport` | — | public |
| 274 | `Kazan_AddCavLoop` | — | public |
| 280 | `Kazan_VaryCavSpawn` | — | public |
| 303 | `Kazan_WestFordLoop` | — | public |
| 322 | `PreventMultiple_TC` | — | public |

### scenarios\campaign\russia\gdm_chp4_kazan\obj_siegekazan.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `SiegeKazan_InitObjectives` | — | public |
| 155 | `Kazan_OuterWallBreached` | `context` | public |
| 173 | `Kazan_InnerWallBreached` | `context` | public |
| 200 | `Kazan_GuardSpotted` | — | public |
| 211 | `CheckMarkerForUnits` | `marker` | public |
| 220 | `Kazan_CheckDefendNorthOutpostKilled` | — | public |
| 227 | `Kazan_CheckDefendFieldGateKilled` | — | public |
| 234 | `Kazan_InitOutro` | — | public |
| 274 | `Kazan_OutroCavLoop` | — | public |
| 285 | `Kazan_SendOutroCav` | `context, data` | public |
| 307 | `Kazan_HasPlayerReachedCity` | — | public |
| 316 | `Kazan_SpawnKazanDefenders` | — | public |
| 395 | `Kazan_SpawnWallDefend` | — | public |
| 531 | `Kazan_WallFormations` | — | public |
| 552 | `Kazan_WallMove` | — | public |
| 573 | `Kazan_FallbackToInnerDefense` | — | public |
| 641 | `Kazan_AutoSaveLoop` | — | public |
| 646 | `Kazan_ProxForSpeech` | — | public |

### scenarios\campaign\russia\gdm_chp4_smolensk\gdm_chp4_smolensk.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `Mission_SetupPlayers` | — | public |
| 65 | `Mission_SetupVariables` | — | public |
| 170 | `Mission_SetRestrictions` | — | public |
| 227 | `Mission_Preset` | — | public |
| 269 | `Mission_Start` | — | public |
| 315 | `GetRecipe` | — | public |
| 619 | `Smolensk_IsPlayerEconomyTrapped` | — | public |
| 625 | `Smolensk_KillVillages` | — | public |
| 631 | `Smolensk_AddResources` | — | public |
| 638 | `Smolensk_KrasnyProximityChecker` | — | public |
| 651 | `Smolensk_ProximitySpawner` | `context, data` | public |
| 670 | `Smolensk_OverrideBuildTimes` | — | public |
| 684 | `Smolensk_OutpostCaptureCheck` | `context, data` | public |
| 735 | `Smolensk_GetTimeScaledAmount` | `min, max` | public |
| 752 | `Smolensk_CheckWestOutpostTrigger` | — | public |
| 764 | `Smolensk_CheckNearWestOutpost` | — | public |
| 803 | `Smolensk_CheckNearEastOutpost` | — | public |
| 819 | `Smolensk_DelayedAudioStinger` | `context, data` | public |
| 836 | `Smolensk_ProximityCallFunction` | `context, data` | public |
| 843 | `Smolensk_SpawnSmolenskVillagerLife` | — | public |
| 859 | `Smolensk_SpawnKrasnyVillagerLife` | — | public |
| 880 | `Smolensk_SendAttack` | `units, sourceMarker, targetMarkers, spawn_area, staging` | public |
| 920 | `Smolensk_IntroSpawner` | — | public |
| 970 | `Smolensk_SkippedIntro` | — | public |
| 999 | `Smolensk_OutroSpawner` | — | public |

### scenarios\campaign\russia\gdm_chp4_smolensk\obj_besiegesmolensk.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `BesiegeSmolensk_InitObjectives` | — | public |
| 286 | `BesiegeSmolensk_InitKrasny` | — | public |
| 366 | `BesiegeSmolensk_SpawnWallDefenders` | — | public |
| 384 | `BesiegeSmolensk_DelayKrasnyStart` | — | public |
| 391 | `BesiegeSmolensk_CheckNearbyKrasny` | — | public |
| 420 | `BesiegeSmolensk_EntityKilled` | `context` | public |
| 437 | `BesiegeSmolensk_DelayedObjectiveCall` | — | public |
| 442 | `BesiegeSmolensk_UpdateSupplyUI` | — | public |
| 453 | `BesiegeSmolensk_RevealTraderPath` | — | public |
| 466 | `BesiegeSmolensk_PathReveal` | `context, data` | public |
| 477 | `BesiegeSmolensk_SpawnCaravan` | — | public |
| 529 | `Caravan_ReachedDestination` | `data` | public |
| 608 | `BesiegeSmolensk_TrackCaravanDeath` | `context, data` | public |
| 667 | `BesiegeSmolensk_SpawnWaveAttack` | `wave, first_attack` | public |
| 693 | `BesiegeSmolensk_SetUpWaves` | — | public |
| 794 | `BesiegeSmolensk_TimeScaleUnitTable` | `table` | public |

### scenarios\campaign\russia\gdm_chp4_smolensk\obj_capturevillages.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `CaptureVillages_Init` | — | public |
| 73 | `CaptureVillages_InitRoslavl` | — | public |
| 144 | `CaptureVillages_InitYelnya` | — | public |
| 217 | `CaptureVillages_InitVyazma` | — | public |
| 289 | `CaptureVillages_InitLandmarks` | — | public |
| 319 | `CaptureVillages_ReinforceVillages` | — | public |
| 347 | `CaptureVillages_OnComplete` | `village_marker, villager_destination, sgroup` | public |
| 413 | `CaptureVillages_ContinueObjectiveFlow` | `marker` | public |
| 422 | `CaptureVillages_PlayIntel` | — | public |
| 434 | `CaptureVillages_TrackLandmarks` | `context, data` | public |
| 455 | `CaptureVillages_WatchForPlayerLandmarks` | `context, data` | public |
| 471 | `CaptureVillages_Roslavl` | `context, data` | public |
| 535 | `CaptureVillages_Yelnya` | `context, data` | public |
| 601 | `CaptureVillages_Vyazma` | `context, data` | public |
| 668 | `CaptureVillages_Breach` | `context` | public |
| 691 | `CaptureVillages_OutpostBreach` | `context` | public |
| 711 | `ConvertVillagers_OnCapture` | `villagerLife, maxBonusVillagers` | public |

### scenarios\campaign\russia\gdm_chp4_smolensk\obj_surrenderui.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `SurrenderUI_CreateGizmo` | — | public |
| 38 | `SurrenderUI_AcceptSurrender` | — | public |
| 43 | `SurrenderUI_RefuseSurrender` | — | public |

### scenarios\campaign\salisbury\sal_chp1_rebellion\obj_investigate.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Investigate_InitObjectives` | — | public |
| 97 | `MoveCameraToLumber_UI` | — | public |
| 102 | `MoveCameraToLumber_Start` | — | public |
| 108 | `MoveCameraToLumber_Monitor` | — | public |
| 118 | `MoveCameraToRocks_UI` | — | public |
| 123 | `MoveCameraToRocks_Start` | — | public |
| 128 | `MoveCameraToRocks_Monitor` | — | public |
| 137 | `IsOverRocks` | — | public |
| 143 | `RotateCamera_UI` | — | public |
| 148 | `RotateCamera_Start` | — | public |
| 154 | `RotateCamera_Monitor` | — | public |
| 162 | `HasRotatedCamera` | — | public |
| 177 | `ZoomCamera_UI` | — | public |
| 182 | `ZoomCamera_Start` | — | public |
| 188 | `ZoomCamera_Monitor` | — | public |
| 196 | `HasZoomedCamera` | — | public |
| 204 | `ResetCamera_Start` | — | public |
| 210 | `ResetCamera_Monitor` | — | public |

### scenarios\campaign\salisbury\sal_chp1_rebellion\obj_spearmen.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Spearmen_InitObjectives` | — | public |
| 71 | `SelectWilliam_Start` | — | public |
| 79 | `SelectWilliam_Monitor` | — | public |
| 90 | `MoveWilliam_UI` | — | public |
| 97 | `MoveWilliam_Start` | — | public |
| 104 | `MoveWilliam_Monitor` | — | public |
| 116 | `FollowMarkers_UI` | — | public |
| 120 | `FollowMarkers_Start` | — | public |
| 139 | `FollowMarkersA_Monitor` | — | public |
| 153 | `FollowMarkersB_Monitor` | — | public |
| 169 | `FollowMarkersC_Monitor` | — | public |

### scenarios\campaign\salisbury\sal_chp1_rebellion\sal_chp1_rebellion.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Mission_OnGameSetup` | — | public |
| 20 | `Mission_OnInit` | — | public |
| 38 | `Mission_SetupVariables` | — | public |
| 50 | `Mission_SetRestrictions` | — | public |
| 67 | `Mission_Preset` | — | public |
| 91 | `Mission_Start` | — | public |
| 99 | `Mission_Start_WaitForSpeechToFinish` | — | public |
| 109 | `GetRecipe` | — | public |
| 130 | `WilliamIntroMove` | — | public |
| 151 | `Intro_WilliamResetSpeed` | — | public |

### scenarios\campaign\salisbury\sal_chp1_rebellion\training_sal_chp1_rebellion.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Goals_PanCameraLumber` | — | public |
| 38 | `PanCameraLumber_CompletePredicate` | `goal` | public |
| 43 | `PanCameraLumber_Trigger` | `goalSequence` | public |
| 48 | `PanCameraLumber_IgnorePredicate` | `goalSequence` | public |
| 58 | `Goals_PanCameraRock` | — | public |
| 90 | `RockPanCamera_CompletePredicate` | `goal` | public |
| 95 | `PanCameraRock_Trigger` | `goalSequence` | public |
| 100 | `PanCameraRock_IgnorePredicate` | `goalSequence` | public |
| 110 | `Goals_RotateCamera` | — | public |
| 141 | `RotateCamera_CompletePredicate` | `goal` | public |
| 146 | `RotateCamera_Trigger` | `goalSequence` | public |
| 151 | `RotateCamera_IgnorePredicate` | `goalSequence` | public |
| 159 | `Goals_ZoomCamera` | — | public |
| 190 | `ZoomCamera_CompletePredicate` | `goal` | public |
| 195 | `ZoomCamera_Trigger` | `goalSequence` | public |
| 200 | `ZoomCamera_IgnorePredicate` | `goalSequence` | public |
| 208 | `Goals_ResetCamera` | — | public |
| 239 | `ResetCamera_CompletePredicate` | `goal` | public |
| 244 | `ResetCamera_Trigger` | `goalSequence` | public |
| 249 | `ResetCamera_IgnorePredicate` | `goalSequence` | public |
| 257 | `Goals_SelectWilliam` | — | public |
| 288 | `SelectWilliam_CompletePredicate` | `goal` | public |
| 293 | `SelectWilliam_Trigger` | `goalSequence` | public |
| 298 | `SelectWilliam_IgnorePredicate` | `goalSequence` | public |
| 306 | `Goals_MoveWilliam` | — | public |
| 348 | `SelectWilliam_CompletePredicate2` | `goal` | public |
| 352 | `MoveWilliam_CompletePredicate` | `goal` | public |
| 357 | `MoveWilliam_Trigger` | `goalSequence` | public |
| 362 | `MoveWilliam_IgnorePredicate` | `goalSequence` | public |
| 375 | `Goals_FOW` | — | public |
| 406 | `FOW_CompletePredicate` | `goal` | public |
| 411 | `FOW_Trigger` | `goalSequence` | public |
| 416 | `FOW_IgnorePredicate` | `goalSequence` | public |

### scenarios\campaign\salisbury\sal_chp1_valesdun\obj_archers.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `CommandArchers_InitObjectives` | — | public |
| 53 | `PositionAmbush_UI` | — | public |
| 66 | `PositionAmbush_Start` | — | public |
| 76 | `PositionAmbush_Monitor` | — | public |
| 87 | `AmbushSpearmen_UI` | — | public |
| 93 | `AmbushSpearmen_Start` | — | public |
| 104 | `SpearmanDefeatedTracker` | `context` | public |
| 144 | `CommandArchers_PreComplete` | — | public |

### scenarios\campaign\salisbury\sal_chp1_valesdun\obj_defeat.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `DefeatGuy_InitObjectives` | — | public |
| 83 | `DefeatGuy_Start` | — | public |
| 95 | `HenryMove_Monitor` | — | public |
| 110 | `DefeatGuyGetReady_UI` | — | public |
| 115 | `DefeatGuyGetReady_Start` | — | public |
| 121 | `DefeatGuyGetReady_PreComplete` | — | public |
| 134 | `ReachedBattle_Monitor` | — | public |
| 149 | `StartBattle_Monitor` | — | public |
| 172 | `UnitHighlight_Monitor` | — | public |
| 193 | `Reinforcement_Monitor` | — | public |
| 209 | `RemoveHintTimer` | — | public |
| 215 | `DefeatGuyCavalry_UI` | — | public |
| 221 | `DefeatGuyCavalry_Start` | — | public |
| 226 | `DefeatGuyArchers_UI` | — | public |
| 232 | `DefeatGuyArchers_Start` | — | public |
| 237 | `DefeatGuySpearmen_UI` | — | public |
| 243 | `DefeatGuySpearmen_Start` | — | public |
| 248 | `EnemyDefeatedTracker` | `context` | public |
| 310 | `HeroAbility_UI` | — | public |
| 314 | `HeroAbility_Start` | — | public |
| 322 | `HeroAbility_Monitor` | `context` | public |
| 329 | `RemoveAllUIElements` | `objTable` | public |
| 408 | `Cheat_DefeatGuy` | — | public |

### scenarios\campaign\salisbury\sal_chp1_valesdun\obj_horsemen.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `CommandHorsemen_InitObjectives` | — | public |
| 34 | `DefeatArchers_PreStart` | — | public |
| 41 | `DefeatArchers_Start` | — | public |
| 46 | `ArcherDefeatedTracker` | `context` | public |
| 84 | `DefeatArchers_Complete` | — | public |
| 106 | `ArcherProx_Monitor` | — | public |
| 120 | `Cheat_CommandHorsemen` | — | public |

### scenarios\campaign\salisbury\sal_chp1_valesdun\obj_locate.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `LocateArchers_InitObjectives` | — | public |
| 48 | `SelectExpandedArmy_Start` | — | public |
| 52 | `SelectExpandedArmy_IsComplete` | — | public |
| 56 | `SelectExpandedArmy_Complete` | — | public |
| 63 | `MoveAmbush_UI` | — | public |
| 70 | `MoveAmbush_Start` | — | public |
| 84 | `MoveAmbush_Monitor` | — | public |

### scenarios\campaign\salisbury\sal_chp1_valesdun\obj_muster.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `MusterForces_InitObjectives` | — | public |
| 111 | `SelectAll_UI` | — | public |
| 115 | `SelectAll_Start` | — | public |
| 119 | `SelectAll_Monitor` | — | public |
| 128 | `Search_UI` | — | public |
| 132 | `Search_Start` | — | public |
| 141 | `Search1_Monitor` | — | public |
| 155 | `Search2_Monitor` | — | public |
| 165 | `DestroyPalisade_PreStart` | — | public |
| 173 | `DestroyPalisade_Start` | — | public |
| 177 | `DestroyPalisade_Monitor` | `context` | public |
| 190 | `DefeatHorseman_UI` | — | public |
| 194 | `DefeatHorseman_PreStart` | — | public |
| 201 | `DefeatHorseman_Start` | — | public |
| 214 | `FirstHorsePositioned` | — | public |
| 222 | `AttackMove_Monitor` | — | public |
| 238 | `DefeatHorseman_Monitor` | — | public |
| 253 | `SpawnAnotherLonelyUnit` | `shouldMoveUnits` | public |
| 267 | `MoveUnitAttackMove` | — | public |
| 275 | `FollowMarkers_UI` | — | public |
| 279 | `FollowMarkers_Start` | — | public |
| 298 | `FollowMarkers1_Monitor` | — | public |
| 319 | `MoveToHorsemenAfterAudio` | — | public |

### scenarios\campaign\salisbury\sal_chp1_valesdun\obj_organise.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `OrganiseSpearmen_InitObjectives` | — | public |
| 66 | `SelectSpearmen_UI` | — | public |
| 70 | `SelectSpearmen_Start` | — | public |
| 76 | `SelectSpearmen_Monitor` | — | public |
| 86 | `MoveSpearmen_UI` | — | public |
| 91 | `MoveSpearmen_Start` | — | public |
| 97 | `MoveSpearmen_Monitor` | — | public |
| 107 | `CreateRegiment_UI` | — | public |
| 111 | `CreateRegiment_Start` | — | public |
| 118 | `CreateRegiment_Monitor` | — | public |

### scenarios\campaign\salisbury\sal_chp1_valesdun\obj_prepare.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `PrepareForBattle_InitObjectives` | — | public |
| 54 | `PrepareForBattle_Start` | — | public |
| 60 | `SelectEntireArmy_UI` | — | public |
| 64 | `SelectEntireArmy_Start` | — | public |
| 74 | `SelectEntireArmy_Monitor` | — | public |
| 90 | `FollowToHenry_UI` | — | public |
| 131 | `FollowToHenry_Start` | — | public |
| 140 | `FollowToHenry_Monitor` | — | public |
| 180 | `FollowToHenry_Waypoint1_Monitor` | — | public |
| 193 | `FollowToHenry_Waypoint2_Monitor` | — | public |
| 208 | `PrepareForBattle_PreComplete` | — | public |
| 233 | `SpawnGuyArmy` | — | public |
| 268 | `AnyNearMarker` | `marker, radius` | public |
| 276 | `AllNearMarker` | `marker, radius` | public |

### scenarios\campaign\salisbury\sal_chp1_valesdun\sal_chp1_valesdun.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_OnGameSetup` | — | public |
| 35 | `Mission_OnInit` | — | public |
| 72 | `Mission_SetupVariables` | — | public |
| 137 | `Mission_SetRestrictions` | — | public |
| 158 | `Mission_Preset` | — | public |
| 197 | `Mission_Start` | — | public |
| 228 | `Mission_Start_WaitForSpeechToFinish` | — | public |
| 258 | `GetRecipe` | — | public |
| 279 | `SpearmenCelebrate` | — | public |
| 285 | `SetSquadControlGroup` | `sgroup, control_group_index` | public |
| 292 | `SpawnOutro` | — | public |
| 416 | `InitOutro` | — | public |
| 454 | `OutroPart2` | — | public |
| 487 | `OutroPart3` | — | public |
| 497 | `RecordControlGroups` | — | public |
| 513 | `RestoreControlGroups` | `sgroup_for_first_empty` | public |

### scenarios\campaign\salisbury\sal_chp1_valesdun\training_sal_chp1_valesdun.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 24 | `Goals_SelectAllSpearmen` | — | public |
| 65 | `SelectAllSpearmen_AreAllOnScreenSelected` | `goal` | public |
| 76 | `SelectAllSpearmen_CompletePredicate` | `goal` | public |
| 95 | `SelectAllSpearmen_GetOffScreenUnit` | — | public |
| 107 | `SelectAllSpearmen_Trigger` | `goalSequence` | public |
| 112 | `SelectAllSpearmen_IgnorePredicate` | `goalSequence` | public |
| 121 | `Goals_MoveSpearmen` | — | public |
| 162 | `SelectAllSpearmenAgain_CompletePredicate` | `goal` | public |
| 171 | `MoveSpearmen_CompletePredicate` | `goal` | public |
| 176 | `MoveSpearmen_Trigger` | `goalSequence` | public |
| 181 | `MoveSpearmen_IgnorePredicate` | `goalSequence` | public |
| 191 | `Goals_CreateRegiment` | — | public |
| 251 | `CreateRegiment_CompletePredicate` | `goal` | public |
| 256 | `AddUnits_CompletePredicate` | `goal` | public |
| 261 | `CloseMenu_CompletePredicate` | `goal` | public |
| 266 | `SeeRegiments_CompletePredicate` | `goal` | public |
| 271 | `CreateRegiment_Trigger` | `goalSequence` | public |
| 276 | `CreateRegiment_IgnorePredicate` | `goalSequence` | public |
| 286 | `Goals_UseMarquee` | — | public |
| 333 | `UseMarquee_IsMarqueeActive` | `goal` | public |
| 348 | `UseMarquee_IsOverSpearmen` | `goal` | public |
| 357 | `UseMarquee_IsOverGuillaume` | `goal` | public |
| 368 | `UseMarquee_IgnorePredicate` | `goalSequence` | public |
| 379 | `Goals_SnapTo` | — | public |
| 409 | `SnapToSelected_CompletePredicate` | `goal` | public |
| 422 | `SnapTo_Trigger` | `goalSequence` | public |
| 433 | `SnapTo_IgnorePredicate` | `goalSequence` | public |
| 443 | `Goals_AttackStructure` | — | public |
| 483 | `HighlightPalisade_CompletePredicate` | `goal` | public |
| 488 | `AttackPalisade_CompletePredicate` | `goal` | public |
| 493 | `AttackStructure_Trigger` | `goalSequence` | public |
| 498 | `AttackStructure_IgnorePredicate` | `goalSequence` | public |
| 507 | `Goals_AttackMove` | — | public |
| 557 | `AttackMoveSpearmen_CompletePredicate` | `goal` | public |
| 562 | `ActivateAttackMove_CompletePredicate` | `goal` | public |
| 567 | `AttackMoveInfo_CompletePredicate` | `goal` | public |
| 573 | `AttackMove_Trigger` | `goalSequence` | public |
| 578 | `AttackMove_IgnorePredicate` | `goalSequence` | public |
| 587 | `Goals_CavalryVSArchers` | — | public |
| 633 | `CavalryVSArchers_IsSelectionComplete` | `goal` | public |
| 638 | `AttackMoveHorsemen_CompletePredicate` | `goal` | public |
| 643 | `CavalryVSArchers_IgnorePredicate` | `goalSequence` | public |
| 652 | `Goals_ExploreSelection` | — | public |
| 704 | `ExploreSelection_AreSomeSelected` | `goal` | public |
| 712 | `ExploreSelection_AreAllSelected` | `goal` | public |
| 718 | `ExploreSelection_CompletePredicate` | `goal` | public |
| 725 | `ExploreSelection_IgnorePredicate` | `goalSequence` | public |
| 734 | `Goals_TerrainAdvantage` | — | public |
| 764 | `TerrainInfo_CompletePredicate` | `goal` | public |
| 769 | `TerrainAdvantage_Trigger` | `goalSequence` | public |
| 774 | `TerrainAdvantage_IgnorePredicate` | `goalSequence` | public |
| 783 | `Goals_DPadUse` | — | public |
| 813 | `DPadAllMilitary_CompletePredicate` | `goal` | public |
| 818 | `DPadUse_Trigger` | `goalSequence` | public |
| 823 | `DPadUse_IgnorePredicate` | `goalSequence` | public |
| 833 | `Goals_DPadUseReminder` | — | public |
| 864 | `DPadUseReminder_IgnorePredicate` | `goalSequence` | public |
| 875 | `Goals_BattleHelp` | — | public |
| 905 | `BattleHelp_CompletePredicate` | `goal` | public |
| 910 | `BattleHelp_Trigger` | `goalSequence` | public |
| 915 | `BattleHelp_IgnorePredicate` | `goalSequence` | public |
| 925 | `Goals_HeroAbility` | — | public |
| 965 | `HeroAbility_CompletePredicate` | `goal` | public |
| 969 | `HeroAbilityActivate_CompletePredicate` | `goal` | public |
| 974 | `HeroAbility_Trigger` | `goalSequence` | public |
| 979 | `HeroAbility_IgnorePredicate` | `goalSequence` | public |
| 990 | `ReturnFalse` | `goal` | public |
| 996 | `ReturnTrue` | `goalSequence` | public |

### scenarios\campaign\salisbury\sal_chp2_dinan\obj_capture.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Capture_InitObjectives` | — | public |
| 66 | `March_UI` | — | public |
| 72 | `March_Start` | — | public |
| 87 | `SpawnEnemies` | — | public |
| 126 | `StartPatrols` | — | public |
| 177 | `SelectAll_Monitor` | — | public |
| 185 | `March_Monitor` | — | public |
| 195 | `HeroAbility_StartMonitor` | — | public |
| 205 | `HeroAbility_Start` | — | public |
| 213 | `HeroAbility_Monitor` | `context` | public |
| 218 | `HeroAbilityFail_Monitor` | — | public |
| 231 | `Destroy_UI` | — | public |
| 236 | `Destroy_Start` | — | public |
| 247 | `Destroy_Monitor` | — | public |
| 257 | `KeepAttacked` | — | public |
| 268 | `Reinforcement_Setup` | — | public |
| 278 | `Reinforcement_Monitor` | — | public |

### scenarios\campaign\salisbury\sal_chp2_dinan\obj_expand.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Expand_InitObjectives` | — | public |
| 219 | `SetMilitaryPreset_Start` | — | public |
| 225 | `SetMilitaryPreset_Monitor` | — | public |
| 238 | `HandleBuildHousesObjective` | — | public |
| 252 | `Build2Houses_PreStart` | — | public |
| 264 | `Build2Houses_Start` | — | public |
| 271 | `BuildHousesStart_Monitor` | `context` | public |
| 283 | `PlacingHousesMonitor` | `blueprint, phase` | public |
| 297 | `BuildBarracks_UI` | — | public |
| 301 | `BuildBarracks_PreStart` | — | public |
| 312 | `BuildBarracks_Start` | — | public |
| 318 | `PlacingBarracksMonitor` | `blueprint, phase` | public |
| 326 | `SetRally_UI` | — | public |
| 330 | `SetRally_Start` | — | public |
| 341 | `OnRallyPoint` | `context` | public |
| 351 | `Make10Spearmen_UI` | — | public |
| 355 | `Make10Spearmen_PreStart` | — | public |
| 364 | `Make10Spearmen_Start` | — | public |
| 371 | `BuildStables_UI` | — | public |
| 375 | `BuildStables_PreStart` | — | public |
| 386 | `BuildStables_Start` | — | public |
| 392 | `PlacingStablesMonitor` | `blueprint, phase` | public |
| 400 | `HorsemenRaid_UI` | — | public |
| 415 | `HorsemenRaid_Start` | — | public |
| 438 | `HorsemenRaid_Monitor` | — | public |
| 447 | `Make10Horsemen_UI` | — | public |
| 451 | `Make10Horsemen_PreStart` | — | public |
| 467 | `Make10Horsemen_Start` | — | public |
| 474 | `BuildArchery_UI` | — | public |
| 478 | `BuildArchery_PreStart` | — | public |
| 489 | `BuildArchery_Start` | — | public |
| 495 | `PlacingArcheryMonitor` | `blueprint, phase` | public |
| 503 | `ArchersRaid_UI` | — | public |
| 516 | `ArchersRaid_Start` | — | public |
| 538 | `ArchersRaid_Monitor` | — | public |
| 547 | `Make10Archers_UI` | — | public |
| 551 | `Make10Archers_PreStart` | — | public |
| 560 | `Make10Archers_Start` | — | public |

### scenarios\campaign\salisbury\sal_chp2_dinan\obj_upgrade.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `UpgradeUnits_InitObjectives` | — | public |
| 65 | `Hardened_UI` | — | public |
| 70 | `Hardened_Start` | — | public |
| 84 | `Hardened_Monitor` | — | public |
| 99 | `BuildBlacksmith_UI` | — | public |
| 103 | `BuildBlacksmith_Start` | — | public |
| 112 | `Research_UI` | — | public |
| 117 | `Research_Start` | — | public |
| 129 | `Research_Monitor` | — | public |

### scenarios\campaign\salisbury\sal_chp2_dinan\sal_chp2_dinan.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `Mission_OnGameSetup` | — | public |
| 25 | `Mission_OnInit` | — | public |
| 54 | `Mission_SetupVariables` | — | public |
| 104 | `Mission_SetDifficulty` | — | public |
| 109 | `Mission_SetRestrictions` | — | public |
| 197 | `Mission_Preset` | — | public |
| 214 | `Mission_PreStart` | — | public |
| 229 | `Mission_Start` | — | public |
| 250 | `Mission_Start_WaitForSpeechToFinish` | — | public |
| 268 | `SpawnDinanCheatArmy` | — | public |
| 282 | `GetRecipe` | — | public |
| 305 | `GivePlayerRequired` | `unit, count` | public |
| 328 | `ProduceBuildingsObjectiveTracker` | `context, data` | public |
| 339 | `ProduceBuildings_Monitor` | `context, data` | public |
| 364 | `ProduceUnitsObjectiveTracker` | `context, data` | public |
| 378 | `ProduceUnits_Monitor` | `context, data` | public |
| 408 | `Spawn_Corpses` | — | public |
| 476 | `Destroy_Buildings` | — | public |
| 489 | `Shot_01` | — | public |
| 511 | `Shot_02` | — | public |
| 559 | `Shot_03` | — | public |

### scenarios\campaign\salisbury\sal_chp2_dinan\training_sal_chp2_dinan.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Goals_VillagerPriorities` | — | public |
| 66 | `OpenMenu_CompletePredicate` | `goal` | public |
| 71 | `VillagerPriorities_CompletePredicate` | `goal` | public |
| 76 | `CloseVPS_CompletePredicate` | `goal` | public |
| 81 | `ShowMoreVillagers_CompletePredicate` | `goal` | public |
| 87 | `VillagerPriorities_Trigger` | `goalSequence` | public |
| 92 | `VillagerPriorities_IgnorePredicate` | `goalSequence` | public |
| 102 | `Goals_Build2Houses` | — | public |
| 152 | `HousesNoRadial_CompletePredicate` | `goal` | public |
| 157 | `HousesRadial_CompletePredicate` | `goal` | public |
| 162 | `Build2Houses_CompletePredicate` | `goal` | public |
| 167 | `Build2Houses_Trigger` | `goalSequence` | public |
| 172 | `Build2Houses_IgnorePredicate` | `goalSequence` | public |
| 182 | `Goals_BuildBarracks` | — | public |
| 232 | `OpenVillagerRadial_CompletePredicate` | `goal` | public |
| 237 | `OpenMilitaryPage_CompletePredicate` | `goal` | public |
| 242 | `HighlightBarracks_CompletePredicate` | `goal` | public |
| 247 | `BuildBarracks_Trigger` | `goalSequence` | public |
| 252 | `BuildBarracks_IgnorePredicate` | `goalSequence` | public |
| 262 | `Goals_RallyPoint` | — | public |
| 302 | `SelectBarracks_CompletePredicate` | `goal` | public |
| 307 | `SetRallyPoint_CompletePredicate` | `goal` | public |
| 312 | `RallyPoint_Trigger` | `goalSequence` | public |
| 317 | `RallyPoint_IgnorePredicate` | `goalSequence` | public |
| 327 | `Goals_Make10Spearmen` | — | public |
| 369 | `OpenBarracksRadial_CompletePredicate` | `goal` | public |
| 374 | `CreateSpearmen_CompletePredicate` | `goal` | public |
| 379 | `Goals_Make10Spearmen_Trigger` | `goalSequence` | public |
| 384 | `Goals_Make10Spearmen_IgnorePredicate` | `goalSequence` | public |
| 394 | `Goals_BuildStables` | — | public |
| 444 | `OpenVillagerRadialStables_CompletePredicate` | `goal` | public |
| 449 | `OpenMilitaryPageStables_CompletePredicate` | `goal` | public |
| 454 | `HighlightStables_CompletePredicate` | `goal` | public |
| 459 | `BuildStables_Trigger` | `goalSequence` | public |
| 464 | `BuildStables_IgnorePredicate` | `goalSequence` | public |
| 474 | `Goals_HorsemenRaid` | — | public |
| 534 | `HoldLTSpearmen_CompletePredicate` | `goal` | public |
| 539 | `SelectAllSpearmen_CompletePredicate` | `goal` | public |
| 544 | `AttackMoveSpearmen_CompletePredicate` | `goal` | public |
| 553 | `SpearmenMatchup_CompletePredicate` | `goal` | public |
| 558 | `HorsemenRaid_Trigger` | `goalSequence` | public |
| 563 | `HorsemenRaid_IgnorePredicate` | `goalSequence` | public |
| 573 | `Goals_ProduceMultipleSources` | — | public |
| 625 | `SelectStables_CompletePredicate` | `goal` | public |
| 630 | `SpreadProduction_CompletePredicate` | `goal` | public |
| 635 | `ProductionFaster_CompletePredicate` | `goal` | public |
| 640 | `ProduceMultipleSources_Trigger` | `goalSequence` | public |
| 645 | `ProduceMultipleSources_IgnorePredicate` | `goalSequence` | public |
| 655 | `Goals_BuildArchery` | — | public |
| 705 | `BuildArchery_CompletePredicate` | `goal` | public |
| 710 | `BuildArcheryDPad_CompletePredicate` | `goal` | public |
| 715 | `BuildArcheryMenu_CompletePredicate` | `goal` | public |
| 720 | `BuildArchery_Trigger` | `goalSequence` | public |
| 725 | `BuildArchery_IgnorePredicate` | `goalSequence` | public |
| 735 | `Goals_ArchersRaid` | — | public |
| 785 | `ArchersRaidHoldLT_CompletePredicate` | `goal` | public |
| 790 | `SelectAllCavalry_CompletePredicate` | `goal` | public |
| 795 | `AttackMoveArchersRaid_CompletePredicate` | `goal` | public |
| 800 | `ArchersRaid_Trigger` | `goalSequence` | public |
| 805 | `ArchersRaid_IgnorePredicate` | `goalSequence` | public |
| 815 | `Goals_Make10Archers` | — | public |
| 887 | `OpenFindMenu_CompletePredicate` | `goal` | public |
| 892 | `FindBuildingsPage_CompletePredicate` | `goal` | public |
| 897 | `FindArcheryRange_CompletePredicate` | `goal` | public |
| 904 | `OpenArcheryRadial_CompletePredicate` | `goal` | public |
| 909 | `Make10Archers_CompletePredicate` | `goal` | public |
| 914 | `Make10Archers_Trigger` | `goalSequence` | public |
| 919 | `Make10Archers_IgnorePredicate` | `goalSequence` | public |
| 929 | `Goals_SelectDPad` | — | public |
| 970 | `SelectDPad_CompletePredicate` | `goal` | public |
| 978 | `AttackMoveArmy_CompletePredicate` | `goal` | public |
| 987 | `SelectDPad_Trigger` | `goalSequence` | public |
| 992 | `SelectDPad_IgnorePredicate` | `goalSequence` | public |
| 1002 | `Goals_HeroAbility` | — | public |
| 1042 | `HeroAbility_CompletePredicate` | `goal` | public |
| 1047 | `HeroAbilityActivate_CompletePredicate` | `goal` | public |
| 1052 | `HeroAbility_Trigger` | `goalSequence` | public |
| 1057 | `HeroAbility_IgnorePredicate` | `goalSequence` | public |
| 1066 | `Goals_Destroy` | — | public |
| 1096 | `Destroy_CompletePredicate` | `goal` | public |
| 1101 | `Destroy_Trigger` | `goalSequence` | public |
| 1106 | `Destroy_IgnorePredicate` | `goalSequence` | public |

### scenarios\campaign\salisbury\sal_chp2_township\obj_landmark.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `BuildLandmark_InitObjectives` | — | public |
| 86 | `BuildLandmark_Start` | — | public |
| 97 | `StartGatherObjectives` | — | public |
| 104 | `HasResources_Monitor` | — | public |
| 113 | `GatherFood_UI` | — | public |
| 120 | `GatherFood_Start` | — | public |
| 126 | `GatherFood_Monitor` | — | public |
| 140 | `GatherGold_UI` | — | public |
| 147 | `GatherGold_Start` | — | public |
| 153 | `GatherGold_Monitor` | — | public |
| 167 | `PlaceLandmark_UI` | — | public |
| 172 | `PlaceLandmark_Start` | — | public |
| 178 | `LandmarkHint_WaitForSpeechToFinish` | — | public |
| 187 | `PlaceLandmark_Monitor` | — | public |
| 200 | `Make3Villagers_UI` | — | public |
| 205 | `Make3Villagers_Start` | — | public |
| 213 | `WaitFinish_UI` | — | public |
| 218 | `WaitFinish_Start` | — | public |
| 224 | `WaitFinish_Monitor` | — | public |

### scenarios\campaign\salisbury\sal_chp2_township\obj_research.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `ResearchTech_InitObjectives` | — | public |
| 52 | `Horticulture_UI` | — | public |
| 56 | `Horticulture_Start` | — | public |
| 63 | `Horticulture_Monitor` | — | public |
| 74 | `BroadAxe_UI` | — | public |
| 78 | `BroadAxe_Start` | — | public |
| 84 | `BroadAxe_Monitor` | — | public |

### scenarios\campaign\salisbury\sal_chp2_township\sal_chp2_township.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 10 | `Mission_OnGameSetup` | — | public |
| 18 | `Mission_OnInit` | — | public |
| 28 | `Mission_SetupVariables` | — | public |
| 48 | `Mission_SetDifficulty` | — | public |
| 53 | `Mission_SetRestrictions` | — | public |
| 103 | `Mission_Preset` | — | public |
| 121 | `Mission_PreStart` | — | public |
| 126 | `Mission_Start` | — | public |
| 134 | `Mission_Start_WaitForSpeechToFinish` | — | public |
| 143 | `ProduceUnitsObjectiveTracker` | `context, data` | public |
| 154 | `ProduceUnits_Monitor` | `context, data` | public |
| 178 | `GetRecipe` | — | public |

### scenarios\campaign\salisbury\sal_chp2_township\training_sal_chp2_township.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Goals_BuildLandmark` | — | public |
| 45 | `IdleVillager_CompletePredicate` | `goal` | public |
| 50 | `LandmarkSelected_CompletePredicate` | `goal` | public |
| 55 | `BuildLandmark_Trigger` | `goalSequence` | public |
| 60 | `BuildLandmark_IgnorePredicate` | `goalSequence` | public |
| 70 | `Goals_FasterLandmark` | — | public |
| 120 | `StartedConstruction_CompletePredicate` | `goal` | public |
| 125 | `MoreVillagers_CompletePredicate` | `goal` | public |
| 130 | `AgingUp_CompletePredicate` | `goal` | public |
| 135 | `FasterLandmark_Trigger` | `goalSequence` | public |
| 140 | `FasterLandmark_IgnorePredicate` | `goalSequence` | public |
| 150 | `Goals_Research` | — | public |
| 210 | `NewTech_CompletePredicate` | `goal` | public |
| 216 | `ResearchBonus_CompletePredicate` | `goal` | public |
| 221 | `SelectMill_CompletePredicate` | `goal` | public |
| 226 | `StartResearch_CompletePredicate` | `goal` | public |
| 237 | `Research_Trigger` | `goalSequence` | public |
| 242 | `Research_IgnorePredicate` | `goalSequence` | public |
| 252 | `Goals_ResearchLumber` | — | public |
| 292 | `SelectLumber_CompletePredicate` | `goal` | public |
| 298 | `StartLumberResearch_CompletePredicate` | `goal` | public |
| 309 | `ResearchLumber_Trigger` | `goalSequence` | public |
| 314 | `ResearchLumber_IgnorePredicate` | `goalSequence` | public |

### scenarios\campaign\salisbury\sal_chp2_womanswork\obj_grow.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `GrowTown_InitObjectives` | — | public |
| 114 | `BuildMine_PreStart` | — | public |
| 122 | `BuildMine_UI` | — | public |
| 130 | `BuildMine_Start` | — | public |
| 135 | `BuildMine_Monitor` | `context` | public |
| 148 | `BuildMineStarted_Monitor` | `context` | public |
| 162 | `BuildFarms_PreStart` | — | public |
| 171 | `BuildFarms_UI` | — | public |
| 177 | `BuildFarms_Start` | — | public |
| 182 | `BuildFarms_Monitor` | `context` | public |
| 202 | `BuildFarmsStarted_Monitor` | `context` | public |
| 217 | `Salisbury3_StartAssign` | — | public |
| 231 | `AssignVillagers_UI` | — | public |
| 234 | `AssignVillagers_PreStart` | — | public |
| 240 | `AssignVillagers_Monitor` | `context` | public |
| 273 | `Salisbury3_GetWorkedFarms` | — | public |
| 292 | `PlaceLandmark_PreStart` | — | public |
| 300 | `PlaceLandmark_UI` | — | public |
| 306 | `PlaceLandmark_Start` | — | public |
| 312 | `PlaceLandmark_Monitor` | — | public |
| 326 | `PlacingLandmarkMonitor` | `blueprint, phase` | public |
| 340 | `WaitFinish_UI` | — | public |
| 345 | `WaitFinish_PreStart` | — | public |
| 351 | `WaitFinish_Monitor` | — | public |
| 367 | `Cheat_Grow` | — | public |

### scenarios\campaign\salisbury\sal_chp2_womanswork\obj_officials.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `CommandOfficials_InitObjectives` | — | public |
| 54 | `SetBalanced_PreStart` | — | public |
| 60 | `SetBalanced_Start` | — | public |
| 65 | `SetBalanced_Monitor` | — | public |
| 79 | `Salisbury3_MonitorResearchObjStart` | — | public |
| 92 | `Research_PreStart` | — | public |
| 100 | `Research_Start` | — | public |
| 106 | `Research_Monitor` | `context` | public |

### scenarios\campaign\salisbury\sal_chp2_womanswork\obj_scout.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Scout_InitObjectives` | — | public |
| 72 | `FindSheep_UI` | — | public |
| 76 | `FindSheep_Start` | — | public |
| 83 | `FindSheep_Monitor` | — | public |
| 93 | `HerdSheep_UI` | — | public |
| 97 | `HerdSheep_PreStart` | — | public |
| 102 | `HerdSheep_Start` | — | public |
| 108 | `HerdSheep_Monitor` | — | public |
| 121 | `HarvestSheep_UI` | — | public |
| 125 | `HarvestSheep_Start` | — | public |
| 134 | `HarvestSheep_Monitor` | — | public |
| 149 | `Cheat_Scout` | — | public |

### scenarios\campaign\salisbury\sal_chp2_womanswork\obj_villagers.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `VillagersWork_InitObjectives` | — | public |
| 144 | `SelectVillager_UI` | — | public |
| 148 | `SelectVillager_PreStart` | — | public |
| 157 | `SelectVillager_Monitor` | — | public |
| 167 | `GatherFood_UI` | — | public |
| 171 | `GatherFood_PreStart` | — | public |
| 176 | `GatherFood_Start` | — | public |
| 180 | `GatherFood_Monitor` | — | public |
| 194 | `VillagerCommand_UI` | — | public |
| 199 | `VillagerCommand_PreStart` | — | public |
| 207 | `VillagerCommand_Start` | — | public |
| 214 | `Villagers_OnSquadBuilt` | `context` | public |
| 263 | `Make2Villagers_CheckTrainingUI` | — | public |
| 280 | `BuildMill_UI` | — | public |
| 289 | `BuildMill_PreStart` | — | public |
| 296 | `BuildMill_Start` | — | public |
| 305 | `BuildMillStarted_Monitor` | `context` | public |
| 322 | `BuildMill_Monitor` | `context` | public |
| 338 | `BuildLumber_UI` | — | public |
| 347 | `BuildLumber_PreStart` | — | public |
| 354 | `BuildLumber_Start` | — | public |
| 358 | `BuildLumber_Monitor` | `context` | public |
| 372 | `BuildLumberStarted_Monitor` | `context` | public |
| 384 | `Make5Villagers_PreStart` | — | public |
| 389 | `Make5Villagers_Start` | — | public |
| 393 | `Make5Villagers_CheckTrainingUI` | — | public |
| 412 | `BuildHouses_UI` | — | public |
| 419 | `BuildHouses_PreStart` | — | public |
| 428 | `BuildHouses_Start` | — | public |
| 432 | `BuildHouses_Monitor` | `context` | public |
| 446 | `BuildHousesStart_Monitor` | `context` | public |
| 458 | `VillagersWork_CheckForNextObjective` | — | public |

### scenarios\campaign\salisbury\sal_chp2_womanswork\sal_chp2_womanswork.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 10 | `Mission_OnGameSetup` | — | public |
| 20 | `Mission_OnInit` | — | public |
| 29 | `Mission_SetupVariables` | — | public |
| 101 | `Mission_SetRestrictions` | — | public |
| 154 | `Mission_Preset` | — | public |
| 172 | `Mission_Start` | — | public |
| 189 | `Mission_Start_WaitForSpeechToFinish` | — | public |
| 206 | `GetRecipe` | — | public |
| 228 | `Spawn_Intro` | — | public |
| 264 | `Intro_Parade` | — | public |
| 277 | `Intro_Villager_Cheer` | — | public |
| 283 | `Intro_Scout_Move` | — | public |
| 290 | `Intro_Villagers_Move` | — | public |
| 299 | `Intro_Destroy_Squads` | — | public |
| 308 | `Intro_Skip` | — | public |
| 325 | `ChangeBuildTimes` | — | public |

### scenarios\campaign\salisbury\sal_chp2_womanswork\training_sal_chp2_womanswork.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 29 | `Goals_SelectVillager` | — | public |
| 60 | `SelectVillager_Trigger` | `goalSequence` | public |
| 65 | `SelectVillager_IgnorePredicate` | `goalSequence` | public |
| 75 | `Goals_GatherFood` | — | public |
| 115 | `GatherFood_CompletePredicate` | `goal` | public |
| 120 | `ResourceDisplay_CompletePredicate` | `goal` | public |
| 125 | `GatherFood_Trigger` | `goalSequence` | public |
| 130 | `GatherFood_IgnorePredicate` | `goalSequence` | public |
| 140 | `Goals_BuildMill` | — | public |
| 203 | `HighlightMill_CompletePredicate` | `goal` | public |
| 208 | `BuildMill_Trigger` | `goalSequence` | public |
| 213 | `BuildMill_IgnorePredicate` | `goalSequence` | public |
| 223 | `Goals_BuildLumber` | — | public |
| 285 | `HighlightLumber_CompletePredicate` | `goal` | public |
| 290 | `BuildLumber_Trigger` | `goalSequence` | public |
| 295 | `BuildLumber_IgnorePredicate` | `goalSequence` | public |
| 305 | `Goals_BuildMine` | — | public |
| 351 | `BuildMine_IgnorePredicate` | `goalSequence` | public |
| 360 | `BuildMine_IsHoveringOverGold` | `goal` | public |
| 365 | `BuildMine_IsPlacingMine` | `goal` | public |
| 372 | `Goals_VillagerCommand` | — | public |
| 422 | `SelectTC_CompletePredicate` | `goal` | public |
| 427 | `VillagerCommand_Trigger` | `goalSequence` | public |
| 432 | `VillagerCommand_IgnorePredicate` | `goalSequence` | public |
| 442 | `Goals_Make5Villagers` | — | public |
| 513 | `SelectTC5Villagers_CompletePredicate` | `goal` | public |
| 518 | `OpenRadial5Villagers_CompletePredicate` | `goal` | public |
| 523 | `QueueModifier_CompletePredicate` | `goal` | public |
| 528 | `Make5Villagers_CompletePredicate` | `goal` | public |
| 533 | `Make5Villagers_Trigger` | `goalSequence` | public |
| 538 | `Make5Villagers_IgnorePredicate` | `goalSequence` | public |
| 549 | `Goals_BuildHouses` | — | public |
| 610 | `HousingLimit_CompletePredicate` | `goal` | public |
| 614 | `HighlightHouses_CompletePredicate` | `goal` | public |
| 620 | `BuildHouses_IsHoldingLT` | `goal` | public |
| 624 | `BuildHouses_Trigger` | `goalSequence` | public |
| 629 | `BuildHouses_IgnorePredicate` | `goalSequence` | public |
| 639 | `Goals_Scouting` | — | public |
| 679 | `Goals_ScoutingHerd` | — | public |
| 709 | `Goals_ScoutingSecond` | — | public |
| 749 | `SelectScout_CompletePredicate` | `goal` | public |
| 754 | `Scouting_Trigger` | `goalSequence` | public |
| 759 | `Scouting_IgnorePredicate` | `goalSequence` | public |
| 769 | `ScoutingHerd_Trigger` | `goalSequence` | public |
| 774 | `ScoutingHerd_IgnorePredicate` | `goalSequence` | public |
| 783 | `HarvestSheep_CompletePredicate` | `goal` | public |
| 789 | `ScoutingSecond_Trigger` | `goalSequence` | public |
| 794 | `ScoutingSecond_IgnorePredicate` | `goalSequence` | public |
| 805 | `Goals_BuildFarms` | — | public |
| 851 | `BuildFarms_IsHoveringOverMill` | `goal` | public |
| 856 | `BuildFarm_IsPlacingFarm` | `goal` | public |
| 861 | `BuildFarms_IgnorePredicate` | `goalSequence` | public |
| 875 | `Goals_SetBalanced` | — | public |
| 925 | `OpenMenu_CompletePredicate` | `goal` | public |
| 930 | `SetBalanced_CompletePredicate` | `goal` | public |
| 935 | `SetBalanced_Trigger` | `goalSequence` | public |
| 940 | `SetBalanced_IgnorePredicate` | `goalSequence` | public |
| 951 | `Goals_Research` | — | public |
| 1041 | `OpenFind_CompletePredicate` | `goal` | public |
| 1046 | `FindBuildingsPage_CompletePredicate` | `goal` | public |
| 1051 | `SelectMill_CompletePredicate` | `goal` | public |
| 1060 | `CloseFindPage_CompletePredicate` | `goal` | public |
| 1065 | `OpenMillRadial_CompletePredicate` | `goal` | public |
| 1070 | `ResearchWheelbarrow_CompletePredicate` | `goal` | public |
| 1085 | `Research_Trigger` | `goalSequence` | public |
| 1090 | `Research_IgnorePredicate` | `goalSequence` | public |
| 1102 | `Goals_BuildLandmark` | — | public |
| 1152 | `IdleVillager_CompletePredicate` | `goal` | public |
| 1157 | `LandmarkMenuOpen_CompletePredicate` | `goal` | public |
| 1162 | `SelectLandmark_CompletePredicate` | `goal` | public |
| 1167 | `BuildLandmark_Trigger` | `goalSequence` | public |
| 1172 | `BuildLandmark_IgnorePredicate` | `goalSequence` | public |
| 1186 | `Goals_WaitFinish` | — | public |
| 1226 | `MoreVillagersLandmark_CompletePredicate` | `goal` | public |
| 1231 | `NextAge_CompletePredicate` | `goal` | public |
| 1236 | `WaitFinish_Trigger` | `goalSequence` | public |
| 1241 | `WaitFinish_IgnorePredicate` | `goalSequence` | public |
| 1254 | `ReturnFalse` | `goal` | public |
| 1260 | `ReturnTrue` | `goalSequence` | public |
| 1266 | `OpenRadial_CompletePredicate` | `goal` | public |
| 1272 | `IsSelectionEmpty` | `goal` | public |
| 1280 | `IsSMSOpen` | `goal` | public |
| 1286 | `IsSelectionOnlyVillagers` | `goal` | public |
| 1299 | `PickConvenientVillager` | — | public |
| 1326 | `Salisbury3_TrainingContructionCallback` | `blueprint, phase, queueCount` | public |

### scenarios\campaign\salisbury\sal_chp3_brokenpromise\obj_build.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `BuildInvasionForce_InitObjectives` | — | public |
| 96 | `Build2Barracks_UI` | — | public |
| 101 | `Build2Barracks_Start` | — | public |
| 108 | `Build2Archery_UI` | — | public |
| 113 | `Build2Archery_Start` | — | public |
| 119 | `Build2Stables_UI` | — | public |
| 124 | `Build2Stables_Start` | — | public |
| 130 | `Make40Spearmen_UI` | — | public |
| 135 | `Make40Spearmen_Start` | — | public |
| 143 | `Make30Horsemen_UI` | — | public |
| 148 | `Make30Horsemen_Start` | — | public |
| 154 | `Make30Archers_UI` | — | public |
| 159 | `Make30Archers_Start` | — | public |

### scenarios\campaign\salisbury\sal_chp3_brokenpromise\obj_fleet.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `BuildFleet_InitObjectives` | — | public |
| 68 | `Build2Docks_UI` | — | public |
| 73 | `Build2Docks_PreStart` | — | public |
| 81 | `Build2Docks_Start` | — | public |
| 94 | `Build3TransportShips_UI` | — | public |
| 99 | `Build3TransportShips_Start` | — | public |
| 107 | `LoadTroops_UI` | — | public |
| 112 | `LoadTroops_Start` | — | public |
| 119 | `LoadTroops_Monitor` | — | public |

### scenarios\campaign\salisbury\sal_chp3_brokenpromise\obj_gather.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Gather_InitObjectives` | — | public |
| 68 | `GatherFood_UI` | — | public |
| 73 | `GatherFood_Start` | — | public |
| 79 | `GatherFood_Monitor` | — | public |
| 94 | `GatherWood_UI` | — | public |
| 99 | `GatherWood_Start` | — | public |
| 104 | `GatherWood_Monitor` | — | public |
| 118 | `GatherGold_UI` | — | public |
| 123 | `GatherGold_Start` | — | public |
| 128 | `GatherGold_Monitor` | — | public |

### scenarios\campaign\salisbury\sal_chp3_brokenpromise\obj_invade.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `BeginInvasion_InitObjectives` | — | public |
| 137 | `SetSail_UI` | — | public |
| 144 | `SetSail_PreStart` | — | public |
| 150 | `SetSail_Start` | — | public |
| 158 | `SetSail_Monitor` | — | public |
| 181 | `SetSail_DialogueMonitor` | — | public |
| 193 | `UnloadArmy_UI` | — | public |
| 201 | `UnloadArmy_PreStart` | — | public |
| 213 | `UnloadArmy_Start` | — | public |
| 219 | `UnloadArmy_Monitor` | — | public |
| 246 | `ShipsMaintainPosition_Monitor` | — | public |
| 269 | `BeachAmbush_UI` | — | public |
| 277 | `BeachAmbush_PreStart` | — | public |
| 284 | `BeachAmbush_StartSurviveAmbush` | — | public |
| 297 | `BeachAmbush_HasSurvivedAmbush` | — | public |
| 303 | `BeachAmbush_Monitor` | — | public |
| 318 | `TakePevensey_UI` | — | public |
| 324 | `TakePevensey_Start` | — | public |
| 337 | `TakePevensey_Monitor` | — | public |
| 351 | `ApplyProductionPromptMarkers` | — | public |
| 374 | `LocateHastings_UI` | — | public |
| 378 | `LocateHastings_Start` | — | public |
| 404 | `LocateHastings_SpawnScout` | — | public |
| 420 | `LocateHastings_Monitor` | — | public |
| 438 | `ClearAngloSaxons_UI` | — | public |
| 443 | `ClearAngloSaxons_Start` | — | public |
| 449 | `ClearAngloSaxons_Monitor` | — | public |
| 464 | `DestroyTC_UI` | — | public |
| 469 | `DestroyTC_Start` | — | public |
| 475 | `DestroyHastingsGate` | `context` | public |
| 480 | `DestroyTC_Monitor` | — | public |
| 490 | `PlayerNearTarget` | — | public |
| 501 | `Spawn_HastingsReinforcement` | — | public |

### scenarios\campaign\salisbury\sal_chp3_brokenpromise\sal_chp3_brokenpromise.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `Mission_OnGameSetup` | — | public |
| 28 | `Mission_OnInit` | — | public |
| 64 | `Mission_SetupVariables` | — | public |
| 157 | `Mission_SetDifficulty` | — | public |
| 162 | `Mission_SetRestrictions` | — | public |
| 261 | `Mission_Preset` | — | public |
| 272 | `Mission_PreStart` | — | public |
| 313 | `Mission_Start` | — | public |
| 334 | `Mission_Start_WaitForSpeechToFinish` | — | public |
| 358 | `SpawnEnemies` | — | public |
| 365 | `SpawnLandingAmbush` | — | public |
| 379 | `GetTroopsEmbarked` | `holder` | public |
| 394 | `MonitorPlayerShips` | — | public |
| 412 | `SpawnCheatArmy` | — | public |
| 430 | `SpawnCheatShips` | — | public |
| 436 | `GetRecipe` | — | public |
| 457 | `Init_HastingsDefenders` | — | public |
| 717 | `Init_PevenseyDefenders` | — | public |
| 810 | `ProduceBuildingsObjectiveTracker` | `context, data` | public |
| 816 | `ProduceBuildings_Monitor` | `context, data` | public |
| 838 | `ProduceUnitsObjectiveTracker` | `context, data` | public |
| 844 | `ProduceUnits_Monitor` | `context, data` | public |
| 866 | `Spawn_Intro` | — | public |
| 923 | `Reset_Intro` | — | public |
| 931 | `Skip_Intro` | — | public |
| 965 | `Destroy_Hastings_Outro` | — | public |
| 971 | `HastingsSideSwitch_Outro` | — | public |
| 979 | `WilliamMove_Outro` | — | public |
| 1044 | `Spawn_Outro` | — | public |
| 1072 | `RestoreHastings_Outro` | — | public |

### scenarios\campaign\salisbury\sal_chp3_brokenpromise\training_sal_chp3_brokenpromise.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `MissionTutorial_Init` | — | public |
| 21 | `Goals_Docks` | — | public |
| 85 | `VillagerMenu_CompletePredicate` | `goal` | public |
| 90 | `VillagerMenuMilitary_CompletePredicate` | `goal` | public |
| 95 | `SelectDockEBP_CompletePredicate` | `goal` | public |
| 104 | `PlaceDocks_CompletePredicate` | `goal` | public |
| 109 | `Docks_Trigger` | `goalSequence` | public |
| 114 | `Docks_IgnorePredicate` | `goalSequence` | public |
| 130 | `Goals_TransportShips` | — | public |
| 185 | `TransportShipsSelectDocks_CompletePredicate` | `goal` | public |
| 190 | `TransportShipsMenu_CompletePredicate` | `goal` | public |
| 195 | `Misc_IsEntityProducing` | `entity` | public |
| 199 | `TransportShipsProduce_CompletePredicate` | `goal` | public |
| 204 | `TransportShips_Trigger` | `goalSequence` | public |
| 209 | `TransportShips_IgnorePredicate` | `goalSequence` | public |
| 220 | `Goals_LoadTroops` | — | public |
| 270 | `SelectMilitary_CompletePredicate` | `goal` | public |
| 275 | `BoardShip_CompletePredicate` | `goal` | public |
| 280 | `AllBoard_CompletePredicate` | `goal` | public |
| 285 | `LoadTroops_Trigger` | `goalSequence` | public |
| 290 | `LoadTroops_IgnorePredicate` | `goalSequence` | public |
| 312 | `LoadTroops_GetNonFullShip` | — | public |
| 336 | `Goals_Minimap` | — | public |
| 396 | `SelectShips_CompletePredicate` | `goal` | public |
| 401 | `OpenFocus_CompletePredicate` | `goal` | public |
| 406 | `LeftStick_CompletePredicate` | `goal` | public |
| 428 | `CloseMinimap_CompletePredicate` | `goal` | public |
| 438 | `Minimap_Trigger` | `goalSequence` | public |
| 443 | `Minimap_IgnorePredicate` | `goalSequence` | public |
| 453 | `Goals_UnloadTroops` | — | public |
| 503 | `OpenShipsRadial_CompletePredicate` | `goal` | public |
| 508 | `StartUnload_CompletePredicate` | `goal` | public |
| 515 | `Unload_CompletePredicate` | `goal` | public |
| 520 | `UnloadTroops_Trigger` | `goalSequence` | public |
| 525 | `UnloadTroops_IgnorePredicate` | `goalSequence` | public |
| 535 | `Goals_SurviveAmbush` | — | public |
| 566 | `PanicSelect_CompletePredicate` | `goal` | public |
| 570 | `SurviveAmbush_Trigger` | `goalSequence` | public |
| 575 | `SurviveAmbush_IgnorePredicate` | `goalSequence` | public |
| 584 | `Goals_MarchHastings` | — | public |
| 625 | `MoveScouts_CompletePredicate` | `goal` | public |
| 630 | `ScoutsWaypoints_CompletePredicate` | `goal` | public |
| 637 | `MarchHastings_Trigger` | `goalSequence` | public |
| 642 | `MarchHastings_IgnorePredicate` | `goalSequence` | public |

### scenarios\cdn_challenge_missions\challenge_mission_advancedcombat\challenge_mission_advancedcombat_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 39 | `OnInit` | — | public |
| 48 | `Smoketest_Debug` | — | public |
| 58 | `AutomatedMission_Start` | — | public |
| 71 | `AutomatedMission_SetupCheckpoints` | — | public |
| 111 | `AutomatedMission_Update` | — | public |
| 149 | `AutomatedMission_UpdateCheckpoints` | — | public |
| 181 | `AutomatedMission_AttackStart` | — | public |
| 185 | `AutomatedMission_Attack` | — | public |
| 212 | `AutomatedMission_FormationMove` | — | public |
| 228 | `AutomatedMission_Spawn_Wave1` | — | public |
| 242 | `AutomatedMission_Spawn_Wave2` | — | public |
| 256 | `AutomatedMission_Spawn_Wave3` | — | public |
| 270 | `AutomatedMission_Spawn_Wave4` | — | public |
| 280 | `AutomatedMission_Spawn_Wave4_2` | — | public |
| 293 | `AutomatedMission_Spawn_Wave5` | — | public |
| 303 | `AutomatedMission_Spawn_Wave5_2` | — | public |
| 316 | `AutomatedMission_Spawn_Wave6` | — | public |
| 326 | `AutomatedMission_Spawn_Wave6_2` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_advancedcombat\challenge_mission_advancedcombat_preintro.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `AdvancedCombat_PreIntro_Setup_Scenes` | — | public |
| 71 | `AdvancedCombat_PreIntro_Shot01_Units` | — | public |
| 116 | `EarlySiege_PreIntro_Shot01_Move_Crossbowmen` | — | public |
| 129 | `EarlySiege_PreIntro_Shot01_Move_Crossbowmen2` | — | public |
| 139 | `EarlySiege_PreIntro_Shot01_Build_MenAtArms` | — | public |
| 152 | `EarlySiege_PreIntro_Shot01_Build_Knights` | — | public |
| 171 | `EarlySiege_PreIntro_Shot01_Turn_Knights` | — | public |
| 184 | `EarlySiege_PreIntro_Shot01_Turn_Knights_2` | — | public |
| 195 | `EarlySiege_PreIntro_Shot01_Move_Knights` | — | public |
| 206 | `EarlySiege_PreIntro_Shot01_SpeedUp_Knights` | — | public |
| 220 | `EarlySiege_PreIntro_Shot01_Turn_Knights2` | — | public |
| 233 | `EarlySiege_PreIntro_Shot01_Turn_Knights2_2` | — | public |
| 244 | `EarlySiege_PreIntro_Shot01_Move_Knights2` | — | public |
| 255 | `EarlySiege_PreIntro_Shot01_SpeedUp_Knights2` | — | public |
| 269 | `EarlySiege_PreIntro_Shot01_Move_MenAtArms` | — | public |
| 283 | `EarlySiege_PreIntro_Shot01_Move_MenAtArms2` | — | public |
| 296 | `AdvancedCombat_PreIntro_Shot01_Cleanup` | — | public |
| 345 | `AdvancedCombat_PreIntro_Shot02_Units` | — | public |
| 398 | `AdvancedCombat_PreIntro_Shot02_ArcherMove` | — | public |
| 402 | `AdvancedCombat_PreIntro_Shot02_ArcherAttack` | — | public |
| 407 | `AdvancedCombat_PreIntro_Shot02_Cleanup` | — | public |
| 432 | `AdvancedCombat_PreIntro_Shot03_Units` | — | public |
| 459 | `AdvancedCombat_PreIntro_Shot03_Start` | — | public |
| 475 | `AdvancedCombat_PreIntro_Shot03_SplitCrossbowmen` | — | public |
| 485 | `AdvancedCombat_PreIntro_Shot03_MenAtArms_SwitchTarget` | — | public |
| 491 | `AdvancedCombat_PreIntro_Shot03_CrossbowmenUpper_Retreat` | — | public |
| 506 | `AdvancedCombat_PreIntro_Shot03_Retreat_Crossbows_Start` | — | public |
| 520 | `AdvancedCombat_PreIntro_Shot03_Retreat_Crossbows` | — | public |
| 608 | `AdvancedCombat_PreIntro_Shot03_Move_Crossbows` | — | public |
| 613 | `AdvancedCombat_PreIntro_Shot03_Attack_Crossbows` | — | public |
| 654 | `AdvancedCombat_PreIntro_Shot03_Cleanup` | — | public |
| 682 | `AdvancedCombat_PreIntro_Shot04_Units` | — | public |
| 705 | `AdvancedCombat_PreIntro_Shot04_Retreat_Right_Crossbowmen` | — | public |
| 725 | `AdvancedCombat_PreIntro_Shot04_Retreat_Crossbowmen` | — | public |
| 745 | `AdvancedCombat_PreIntro_Shot04_EndHoldPosition` | — | public |
| 755 | `AdvancedCombat_PreIntro_Shot04_Retreat_Crossbowmen2` | — | public |
| 785 | `AdvancedCombat_PreIntro_Shot04_Attack_Spearmen` | — | public |
| 797 | `AdvancedCombat_PreIntro_Shot04_Hold_Spearmen` | — | public |
| 819 | `AdvancedCombat_PreIntro_Shot04_Attack_Spearmen2` | — | public |
| 829 | `AdvancedCombat_PreIntro_Shot04_Attack_Crossbowmen` | — | public |
| 837 | `AdvancedCombat_PreIntro_Shot04_Cleanup` | — | public |
| 862 | `AdvancedCombat_PreIntro_Shot05_Units` | — | public |
| 912 | `AdvancedCombat_PreIntro_Shot05_Formation` | — | public |
| 919 | `AdvancedCombat_PreIntro_Shot05_Cleanup` | — | public |
| 942 | `AdvancedCombat_PreIntro_Shot06_Units` | — | public |
| 977 | `AdvancedCombat_PreIntro_Shot06_Attack_Start` | — | public |
| 998 | `AdvancedCombat_PreIntro_Shot06_Knight_Attack_Start` | — | public |
| 1009 | `AdvancedCombat_PreIntro_Shot06_Cheer` | — | public |
| 1019 | `AdvancedCombat_PreIntro_Shot06_Hold` | — | public |
| 1045 | `AdvancedCombat_PreIntro_Shot06_Retreat_Crossbows_Start` | — | public |
| 1062 | `AdvancedCombat_PreIntro_Shot06_Retreat_Crossbows` | — | public |
| 1082 | `AdvancedCombat_PreIntro_Shot06_Attack_Crossbows` | — | public |
| 1090 | `AdvancedCombat_PreIntro_Shot06_Crossbows_Line` | — | public |
| 1101 | `AdvancedCombat_PreIntro_Shot06_Spearmen_Middle` | — | public |
| 1137 | `AdvancedCombat_PreIntro_Shot06_Spearmen_HoldMiddle` | — | public |
| 1153 | `AdvancedCombat_PreIntro_Shot06_Attack_Spearmen` | — | public |
| 1167 | `AdvancedCombat_PreIntro_Shot06_Attack_Knights` | — | public |
| 1174 | `AdvancedCombat_PreIntro_Shot06_Attack_Knights2` | — | public |
| 1184 | `AdvancedCombat_PreIntro_Shot06_Cleanup` | — | public |
| 1236 | `AdvancedCombat_PreIntro_Clean_Scenes` | — | public |
| 1254 | `Destroy` | `gid, idx, sid` | public |
| 1259 | `DestroyEntity` | `gid, idx, eid` | public |

### scenarios\cdn_challenge_missions\challenge_mission_advancedcombat\challenge_mission_advancedcombat.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 133 | `Mission_OnInit` | — | public |
| 175 | `Mission_Preset` | — | public |
| 184 | `Mission_PreStart` | — | public |
| 204 | `Mission_Start` | — | public |
| 245 | `GetRecipe` | — | public |
| 253 | `ChallengeMission_SetupDiplomacy` | — | public |
| 272 | `ChallengeMission_SetupChallengePlayers` | — | public |
| 322 | `ChallengeMission_SetupChallenge` | — | public |
| 345 | `ChallengeMission_InitStartingUnits` | — | public |
| 388 | `ChallengeMission_InitializeObjectives` | — | public |
| 551 | `AdvancedCombat_Intro_Units` | — | public |
| 565 | `AdvancedCombat_Intro_Cleanup` | — | public |
| 574 | `Mission_PreStart_IntroNISFinished` | — | public |
| 584 | `ChallengeMissionDeployDummyUnits` | — | public |
| 622 | `ChallengeMission_InitializeWave` | — | public |
| 698 | `ChallengeMission_RemindPlayer` | — | public |
| 705 | `ChallengeMission_FirstWave` | — | public |
| 734 | `ChallengeMission_SecondWave` | — | public |
| 765 | `ChallengeMission_StealthForestHint` | — | public |
| 772 | `ChallengeMission_ThirdWave` | — | public |
| 801 | `ChallengeMission_FourthWave` | — | public |
| 838 | `ChallengeMission_FifthWave` | — | public |
| 872 | `ChallengeMission_CliffsHint` | — | public |
| 879 | `ChallengeMission_SixthWave` | — | public |
| 917 | `ChallengeMission_SixthWave_Split` | — | public |
| 930 | `ChallengeMission_SendWave` | — | public |
| 961 | `ChallengeMission_NextWave` | — | public |
| 986 | `ChallengeMission_CleanUpWave` | — | public |
| 1002 | `ChallengeMission_IsDefenseSetup` | — | public |
| 1029 | `ChallengeMission_DefenseGroupsRemaining` | — | public |
| 1062 | `ChallengeMission_CleanUpDefense` | — | public |
| 1066 | `ChallengeMission_RemoveProductionUI` | `inBuildingType` | public |
| 1117 | `ArcherLeaderSelected` | — | public |
| 1141 | `CrossbowmanLeaderSelected` | — | public |
| 1166 | `SpearmanLeaderSelected` | — | public |
| 1190 | `ManatarmsLeaderSelected` | — | public |
| 1215 | `HorsemanLeaderSelected` | — | public |
| 1239 | `KnightLeaderSelected` | — | public |
| 1264 | `ChallengeMission_IncreaseBuildingVulnerability` | — | public |
| 1280 | `ChallengeMission_RespondToPlayerAttack` | — | public |
| 1346 | `ChallengeMission_UpdateMedals` | — | public |
| 1373 | `ChallengeMission_WaveWon` | — | public |
| 1378 | `ChallengeMission_WaveLost` | — | public |
| 1422 | `ChallengeMission_UpdateBuildingSpawner` | `inUnitType` | public |
| 1481 | `ChallengeMission_UpdateProductionObjective` | — | public |
| 1503 | `ChallengeMission_Update` | — | public |
| 1555 | `ChallengeMission_OnDestruction` | `context` | public |
| 1607 | `ChallengeMission_BuildingLost` | — | public |
| 1626 | `ChallengeMission_CheckVictory` | — | public |
| 1645 | `ChallengeMission_EndChallenge` | — | public |
| 1653 | `ArcFormation` | `startPos, endPos, inGroup, curveStrength, inQueued, inOffset` | public |

### scenarios\cdn_challenge_missions\challenge_mission_basiccombat\challenge_mission_basiccombat_preintro.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `BasicCombat_PreIntro_Setup_Scenes` | — | public |
| 44 | `BasicCombat_PreIntro_Shot01_Units` | — | public |
| 69 | `BasicCombat_PreIntro_Shot01_Train_Archer` | — | public |
| 75 | `BasicCombat_PreIntro_Shot02_Units` | — | public |
| 91 | `BasicCombat_PreIntro_Shot02_Cavalry_Charge` | — | public |
| 101 | `BasicCombat_PreIntro_Shot03_Units` | — | public |
| 115 | `BasicCombat_PreIntro_Shot03_Archer_Ambush` | — | public |
| 122 | `BasicCombat_PreIntro_Shot03_Archer_Retreat` | — | public |
| 169 | `BasicCombat_PreIntro_Shot04_Units` | — | public |
| 196 | `BasicCombat_PreIntro_Shot04_Archer_Attack` | — | public |
| 200 | `BasicCombat_PreIntro_Shot04_Cavalry_Charge` | — | public |
| 206 | `BasicCombat_PreIntro_Shot05_Units` | — | public |
| 216 | `BasicCombat_PreIntro_Clean_Scenes` | — | public |
| 235 | `BasicCombat_PreIntro_Shot01_Clean_Up` | — | public |
| 240 | `BasicCombat_PreIntro_Shot02_Clean_Up` | — | public |
| 245 | `EarlyEconomy_PreIntro_Shot03_Clean_Up` | — | public |
| 250 | `EarlyEconomy_PreIntro_Shot04_Clean_Up` | — | public |
| 255 | `EarlyEconomy_PreIntro_Shot05_Clean_Up` | — | public |
| 265 | `Destroy` | `gid, idx, sid` | public |
| 270 | `DestroyEntity` | `gid, idx, eid` | public |

### scenarios\cdn_challenge_missions\challenge_mission_basiccombat\challenge_mission_basiccombat_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 19 | `TrainingGoal_EnableBasicCombatGoals` | — | public |
| 25 | `TrainingGoal_DisableBasicCombatGoals` | — | public |
| 31 | `BasicCombatTrainingGoals_OnInit` | — | public |
| 63 | `UserHasSpearmenAndArchers` | `goalSequence` | public |
| 79 | `UserHasSelectedUnits` | `goal` | public |

### scenarios\cdn_challenge_missions\challenge_mission_basiccombat\challenge_mission_basiccombat.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 106 | `Mission_OnInit` | — | public |
| 144 | `Mission_OnGameSetup` | — | public |
| 154 | `Mission_Preset` | — | public |
| 165 | `Mission_PreStart` | — | public |
| 188 | `Mission_Start` | — | public |
| 211 | `GetRecipe` | — | public |
| 218 | `ChallengeMission_SetupDiplomacy` | — | public |
| 232 | `ChallengeMission_SetupChallengePlayers` | — | public |
| 252 | `ChallengeMission_SetupChallenge` | — | public |
| 284 | `ChallengeMission_InitStartingUnits` | — | public |
| 314 | `ChallengeMission_Intro_RallyScout` | — | public |
| 325 | `ChallengeMission_Intro_Clean_Up` | — | public |
| 331 | `ChallengeMission_InitializeObjectives` | — | public |
| 453 | `Mission_PreStart_IntroNISFinished` | — | public |
| 462 | `ChallengeMission_InitializeWave` | — | public |
| 510 | `ChallengeMission_RemindPlayer` | — | public |
| 517 | `ChallengeMission_FirstWave` | — | public |
| 542 | `ChallengeMission_SecondWave` | — | public |
| 570 | `ChallengeMission_SecondWaveHint` | — | public |
| 579 | `ChallengeMission_ThirdWave` | — | public |
| 608 | `ChallengeMission_FourthWave` | — | public |
| 638 | `ChallengeMission_FourthWaveHint` | — | public |
| 645 | `ChallengeMission_FifthWave` | — | public |
| 682 | `ChallengeMission_FifthWaveHint` | — | public |
| 691 | `ChallengeMission_SendWave` | — | public |
| 709 | `ChallengeMission_NextWave` | — | public |
| 734 | `ChallengeMission_CheckWave4Idle` | — | public |
| 749 | `ChallengeMission_CleanUpWave` | — | public |
| 756 | `ChallengeMission_ExtinguishFires` | — | public |
| 766 | `ChallengeMission_IsDefenseSetup` | — | public |
| 784 | `ChallengeMission_CleanUpDefense` | — | public |
| 795 | `ArcherLeaderSelected` | — | public |
| 814 | `InfantryLeaderSelected` | — | public |
| 833 | `CavalryLeaderSelected` | — | public |
| 852 | `ChallengeMission_UpdateMedals` | — | public |
| 877 | `ChallengeMission_WaveWon` | — | public |
| 883 | `ChallengeMission_WaveLost` | — | public |
| 923 | `ChallengeMission_RespondToPlayerAttack` | — | public |
| 981 | `ChallengeMission_Update` | — | public |
| 1015 | `ChallengeMission_OnDestruction` | `context` | public |
| 1125 | `ChallengeMission_CheckVictory` | — | public |
| 1152 | `ChallengeMission_EndChallenge` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_earlyeconomy\challenge_mission_earlyeconomy_preintro.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `EarlyEconomy_PreIntro_Setup_Scenes` | — | public |
| 57 | `EarlyEconomy_PreIntro_Shot01_Units` | — | public |
| 86 | `EarlyEconomy_PreIntro_Shot01_ButcherSheep` | — | public |
| 91 | `EarlyEconomy_PreIntro_Shot01_TrainVillager` | — | public |
| 97 | `EarlyEconomy_PreIntro_Shot02_Units` | — | public |
| 110 | `EarlyEconomy_PreIntro_Shot02_ScoutMoves` | — | public |
| 116 | `EarlyEconomy_PreIntro_Shot02_HaltSheep` | — | public |
| 127 | `EarlyEconomy_PreIntro_Shot03_Units` | — | public |
| 152 | `EarlyEconomy_PreIntro_Shot04_Units` | — | public |
| 169 | `EarlyEconomy_PreIntro_Shot05_Units` | — | public |
| 194 | `EarlyEconomy_PreIntro_Shot06_Units` | — | public |
| 200 | `EarlyEconomy_PreIntro_Shot06_Cheer` | — | public |
| 211 | `EarlyEconomy_PreIntro_Clean_Scenes` | — | public |
| 240 | `EarlyEconomy_PreIntro_Shot01_Clean_Up` | — | public |
| 244 | `EarlyEconomy_PreIntro_Shot02_Clean_Up` | — | public |
| 260 | `EarlyEconomy_PreIntro_Shot03_Clean_Up` | — | public |
| 272 | `EarlyEconomy_PreIntro_Shot04_Clean_Up` | — | public |
| 295 | `EarlyEconomy_PreIntro_Shot05_Clean_Up` | — | public |
| 300 | `EarlyEconomy_PreIntro_Shot06_Clean_Up` | — | public |
| 309 | `Destroy` | `gid, idx, eid` | public |
| 314 | `DestroyEntity` | `gid, idx, eid` | public |
| 318 | `DespawnCarcasses` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_earlyeconomy\challenge_mission_earlyeconomy_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 44 | `TrainingGoal_EnableEarlyEconomyGoals` | — | public |
| 50 | `TrainingGoal_DisableEarlyEconomyGoals` | — | public |
| 56 | `EarlyEconomyTrainingGoals_InitVillagerTraining_Xbox` | — | public |
| 82 | `EarlyEconomyTrainingGoals_InitVillagerTraining` | — | public |
| 104 | `EarlyEconomyTrainingGoals_OnInit` | — | public |
| 156 | `UserHasIdleTownCenter_Xbox` | `goalSequence` | public |
| 213 | `UserHasIdleTownCenter` | `goalSequence` | public |
| 270 | `UserIsTrainingVillager` | `goalSequence` | public |
| 291 | `UserHasSelectedTownCenter` | `goal` | public |
| 304 | `TCHasStartedToTrainAVillager` | `goal` | public |
| 319 | `SelectNextIdleIfVillagersIdle` | `goalSequence` | public |
| 377 | `UserHasIdleScout` | `goalSequence` | public |
| 434 | `EnoughMarkersExplored` | `goalSequence` | public |

### scenarios\cdn_challenge_missions\challenge_mission_earlyeconomy\challenge_mission_earlyeconomy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 80 | `Mission_OnInit` | — | public |
| 268 | `Mission_Preset` | — | public |
| 282 | `Mission_PreStart` | — | public |
| 309 | `Mission_PreStart_PreIntroNISFinished` | — | public |
| 325 | `Mission_PreStart_IntroNISFinished` | — | public |
| 352 | `Mission_Start` | — | public |
| 404 | `ChallengeMission_FindAllResources` | — | public |
| 423 | `ChallengeMission_InitStartingUnits` | — | public |
| 458 | `ChallengeMission_SpawnDeer` | — | public |
| 474 | `ChallengeMission_PositionStartingUnits` | — | public |
| 501 | `ChallengeMission_RallyStartingScout` | — | public |
| 516 | `ChallengeMission_SetupChallenge` | — | public |
| 584 | `ChallengeMission_OnGameSetup` | — | public |
| 592 | `ChallengeMission_SetRestrictions` | — | public |
| 638 | `ChallengeMission_SetupPlayer` | — | public |
| 648 | `ChallengeMission_InitializeObjectives` | — | public |
| 775 | `ChallengeMission_Update` | — | public |
| 1041 | `ChallengeMission_MissedGold` | — | public |
| 1047 | `ChallengeMission_MissedSilver` | — | public |
| 1053 | `ChallengeMission_MissedBronze` | — | public |
| 1060 | `GetTableLength` | `T` | public |
| 1079 | `ChallengeMission_TrackScore` | — | public |
| 1113 | `ChallengeMission_OnConstructionStart` | `context` | public |
| 1199 | `ChallengeMission_OnConstructionComplete` | `context` | public |
| 1272 | `ChallengeMission_OnBuildItemComplete` | `context` | public |
| 1361 | `ChallengeMission_OnUpgradeComplete` | `context` | public |
| 1378 | `ChallengeMission_OnDestruction` | `context` | public |
| 1400 | `ChallengeMission_CheckVillagers` | — | public |
| 1414 | `ChallengeMission_HintWhenMiningStone` | — | public |
| 1425 | `GetNumGatheringSquadsStone` | — | public |
| 1433 | `ChallengeMission_ConstructLandmark` | — | public |
| 1460 | `ChallengeMission_ExploredSouth` | — | public |
| 1473 | `ChallengeMission_DeerExplored` | — | public |
| 1484 | `ChallengeMission_GatherSheep` | — | public |
| 1517 | `ChallengeMission_IdleScout` | — | public |
| 1551 | `ChallengeMission_IdleTC` | — | public |
| 1591 | `ChallengeMission_RemindMill` | — | public |
| 1649 | `ChallengeMission_OnComplete` | — | public |
| 1661 | `ChallengeMission_EndChallenge` | — | public |
| 1670 | `Outro_Landmark_Construct` | — | public |
| 1702 | `Mission_SetupCheatMenu` | — | public |
| 1722 | `Mission_ActivateMenuItem` | `mode, value` | public |
| 1733 | `Mission_Cheat_ViewRecipe` | — | public |
| 1740 | `Mission_Cheat_Win` | — | public |
| 1772 | `Mission_Cheat_Lose` | — | public |
| 1801 | `Mission_Cheat_Complete_Obj` | — | public |
| 1843 | `Mission_Cheat_Fail_Obj` | — | public |
| 1883 | `Mission_SetupCheatForOutroCamera` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_earlysiege\challenge_mission_earlysiege_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 36 | `TrainingGoal_EnableEarlySiegeGoals` | — | public |
| 42 | `TrainingGoal_DisableEarlySiegeGoals` | — | public |
| 48 | `EarlySiegeTrainingGoals_InitRamHint_Xbox` | — | public |
| 77 | `EarlySiegeTrainingGoals_InitRamHint` | — | public |
| 99 | `EarlySiegeTrainingGoals_OnInit` | — | public |
| 224 | `UserHasIdleSiegeEngineers_Xbox` | `goalSequence` | public |
| 335 | `UserHasIdleSiegeEngineers` | `goalSequence` | public |
| 445 | `UserHasSelectedSiegeEngineer` | `goal` | public |
| 501 | `UserIsBuildingBatteringRam` | `goalSequence` | public |
| 592 | `UserHasBuiltBatteringRam` | `goalSequence` | public |
| 646 | `RamStartedIgnorePredicate` | `goalSequence` | public |
| 674 | `RamBuiltPredicate` | `goalSequence` | public |
| 732 | `UserHasSelectedBatteringRam` | `goal` | public |
| 769 | `SpringaldBuiltPredicate` | `goalSequence` | public |
| 802 | `UserHasSelectedSpringald` | `goal` | public |
| 835 | `MangonelBuiltPredicate` | `goalSequence` | public |
| 870 | `UserHasSelectedMangonelIntro` | `goal` | public |
| 903 | `SiegeTowerBuiltPredicate` | `goalSequence` | public |
| 943 | `UserHasSelectedSiegeTower` | `goal` | public |

### scenarios\cdn_challenge_missions\challenge_mission_earlysiege\challenge_mission_earlysiege.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 94 | `Mission_OnInit` | — | public |
| 230 | `Mission_OnGameSetup` | — | public |
| 240 | `Mission_Preset` | — | public |
| 250 | `Mission_PreStart` | — | public |
| 270 | `Mission_Start` | — | public |
| 308 | `Mission_PreStart_IntroNISFinished` | — | public |
| 319 | `EarlySiegeTrainingHelper` | — | public |
| 332 | `ChallengeMission_SetupChallengePlayers` | — | public |
| 345 | `GetRecipe` | — | public |
| 499 | `ChallengeMission_SetupChallenge` | — | public |
| 566 | `ChallengeMission_InitStartingUnits` | — | public |
| 637 | `WallArchersReset` | — | public |
| 658 | `WallArchersRetreat` | — | public |
| 691 | `ChallengeMission_InitStartingUpgrades` | — | public |
| 725 | `ChallengeMission_SetRestrictions` | — | public |
| 805 | `ChallengeMission_FindAllResources` | — | public |
| 824 | `ChallengeMission_InitTownLifeModules` | — | public |
| 835 | `ChallengeMission_InitFisherman` | — | public |
| 856 | `ChallengeMission_InitCombatModules` | — | public |
| 871 | `ChallengeMission_SetSlowUnitSpeed` | — | public |
| 881 | `ChallengeMission_SetStandardUnitSpeed` | — | public |
| 891 | `ChallengeMission_RallySpearmen` | — | public |
| 901 | `ChallengeMission_RallyMenAtArms` | — | public |
| 910 | `ChallengeMission_RallyWallArchers` | — | public |
| 927 | `ChallengeMission_RallyArchers` | — | public |
| 936 | `ChallengeMission_RallySpringalds` | — | public |
| 947 | `ChallengeMission_RallyMilitary` | — | public |
| 958 | `ChallengeMission_InitializeObjectives` | — | public |
| 1035 | `ChallengeMission_Update` | — | public |
| 1240 | `ChallengeMission_MissedGold` | — | public |
| 1246 | `ChallengeMission_MissedSilver` | — | public |
| 1252 | `ChallengeMission_MissedBronze` | — | public |
| 1259 | `ChallengeMission_MusicCheck` | — | public |
| 1273 | `ChallengeMission_OnDestruction` | `context` | public |
| 1449 | `ChallengeMission_CheckAnnihilation` | `context` | public |
| 1489 | `CheckEarlySiegeAnnihiliation` | — | public |
| 1593 | `EarlySiegeReinforcements` | — | public |
| 1634 | `GetTableLength` | `T` | public |
| 1653 | `ChallengeMission_CheckVictory` | — | public |
| 1695 | `ChallengeMission_InitializeOutro` | — | public |
| 1719 | `ChallengeMission_CheckCheer` | — | public |
| 1746 | `ChallengeMission_SetBuildingsOnFire` | — | public |
| 1799 | `ChallengeMission_EndChallenge` | — | public |
| 1809 | `ChallengeMission_DefeatPresentation` | `playerID` | public |
| 1835 | `SetVillagersToHunt` | — | public |
| 1886 | `PutOutFires` | — | public |
| 1895 | `MenAtArmsPatrolLeft` | — | public |
| 1906 | `MenAtArmsPatrolCenter` | — | public |
| 1920 | `MenAtArmsPatrolRight` | — | public |
| 1932 | `EnemyPatrolDetectedPlayer` | — | public |
| 1953 | `EnemyPatrolAttackPlayer` | — | public |
| 1987 | `EnemyGarrisonWoodFort` | — | public |
| 2005 | `Mission_SetupCheatMenu` | — | public |
| 2025 | `Mission_ActivateMenuItem` | `mode, value` | public |
| 2036 | `Mission_Cheat_ViewRecipe` | — | public |
| 2043 | `Mission_Cheat_Win` | — | public |
| 2075 | `Mission_Cheat_Lose` | — | public |
| 2104 | `Mission_Cheat_Complete_Obj` | — | public |
| 2146 | `Mission_Cheat_Fail_Obj` | — | public |
| 2186 | `Mission_SetupCheatForOutroCamera` | — | public |
| 2202 | `DefendWithArchers` | — | public |
| 2242 | `DefendWithMenAtArms` | — | public |
| 2284 | `PositionEnemySpearmen` | — | public |
| 2297 | `DefendWithSpearmen` | — | public |
| 2338 | `DefendWithSpringalds` | — | public |
| 2379 | `ArcFormation` | `startPos, endPos, inGroup, curveStrength, inQueued, inOffset` | public |
| 2419 | `ScriptScatterUnits` | `inGroup, inDistToMove, inUseGroupCenter, inCenter, inFaceUnits, inFacingMarker, inQueued` | public |

### scenarios\cdn_challenge_missions\challenge_mission_lateeconomy\challenge_mission_lateeconomy_preintro.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 26 | `EarlyEconomy_PreIntro_Setup_Scenes` | — | public |
| 53 | `EarlyEconomy_PreIntro_Shot01_Units` | — | public |
| 99 | `EarlyEconomy_PreIntro_Shot02_Units` | — | public |
| 127 | `EarlyEconomy_PreIntro_Shot02_SpawnFarmerAtTownCenter` | — | public |
| 138 | `EarlyEconomy_PreIntro_Shot02_SpawnTraderAtMarket` | — | public |
| 148 | `EarlyEconomy_PreIntro_Shot03_Units` | — | public |
| 162 | `EarlyEconomy_PreIntro_Shot03_ConstructTownCenter` | — | public |
| 193 | `EarlyEconomy_PreIntro_Shot04_Units` | — | public |
| 219 | `EarlyEconomy_PreIntro_Shot05_Units` | — | public |
| 238 | `EarlyEconomy_PreIntro_Clean_Scenes` | — | public |
| 276 | `EarlyEconomy_PreIntro_Shot01_Clean_Up` | — | public |
| 278 | `EarlyEconomy_PreIntro_Shot02_Clean_Up` | — | public |
| 280 | `EarlyEconomy_PreIntro_Shot03_Clean_Up` | — | public |
| 282 | `EarlyEconomy_PreIntro_Shot04_Clean_Up` | — | public |
| 284 | `EarlyEconomy_PreIntro_Shot05_Clean_Up` | — | public |
| 291 | `Despawn` | `gid, idx, sid` | public |
| 298 | `DespawnEntity` | `gid, idx, sid` | public |
| 305 | `Kill` | `gid, idx, sid` | public |
| 312 | `DespawnCarcasses` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_lateeconomy\challenge_mission_lateeconomy_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 53 | `TrainingGoal_EnableLateEconomyGoals` | — | public |
| 59 | `TrainingGoal_DisableLateEconomyGoals` | — | public |
| 65 | `LateEconomyTrainingGoals_InitVillagerTraining_Xbox` | — | public |
| 91 | `LateEconomyTrainingGoals_InitVillagerTraining` | — | public |
| 113 | `LateEconomyTrainingGoals_InitTraderTraining_Xbox` | — | public |
| 138 | `LateEconomyTrainingGoals_InitTraderTraining` | — | public |
| 157 | `LateEconomyTrainingGoals_OnInit` | — | public |
| 228 | `UserHasIdleTownCenter_Xbox` | `goalSequence` | public |
| 285 | `UserHasIdleTownCenter` | `goalSequence` | public |
| 350 | `UserIsTrainingVillager` | `goalSequence` | public |
| 371 | `UserHasSelectedTownCenter` | `goal` | public |
| 390 | `TCHasStartedToTrainAVillager` | `goal` | public |
| 412 | `UserHasNoMeansTownCenter` | `goal` | public |
| 428 | `UserHasIdleMarket_Xbox` | `goalSequence` | public |
| 500 | `UserHasIdleMarket` | `goalSequence` | public |
| 571 | `UserIsTrainingTrader` | `goalSequence` | public |
| 591 | `UserHasSelectedMarket` | `goal` | public |
| 610 | `MarketHasStartedToTrainATrader` | `goal` | public |
| 632 | `UserHasNoMeansMarket` | `goal` | public |
| 649 | `SelectNextIdleIfVillagersIdle` | `goalSequence` | public |
| 705 | `SelectNextIdleIfTradersIdle` | `goalSequence` | public |
| 759 | `UserHasSelectedAnIdleTrader` | `goal` | public |
| 798 | `UserHasIdleScout` | `goalSequence` | public |
| 855 | `EnoughMarkersExplored` | `goalSequence` | public |

### scenarios\cdn_challenge_missions\challenge_mission_lateeconomy\challenge_mission_lateeconomy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 97 | `Mission_OnInit` | — | public |
| 298 | `Mission_Preset` | — | public |
| 318 | `Mission_PreStart` | — | public |
| 337 | `Mission_Start` | — | public |
| 375 | `Mission_PreStart_IntroNISFinished` | — | public |
| 400 | `ChallengeMission_OnGameSetup` | — | public |
| 408 | `ChallengeMission_SetupPlayer` | — | public |
| 420 | `ChallengeMission_SetRestrictions` | — | public |
| 466 | `ChallengeMission_InitStartingUpgrades` | — | public |
| 473 | `ChallengeMission_FindAllResources` | — | public |
| 492 | `ChallengeMission_InitStartingUnits` | — | public |
| 539 | `ChallengeMission_AssignUnitsToResources` | — | public |
| 680 | `ChallengeMission_PositionStartingUnits` | — | public |
| 703 | `ChallengeMission_RallyStartingUnits` | — | public |
| 712 | `ChallengeMission_AssignTrader` | — | public |
| 721 | `ChallengeMission_SetupChallenge` | — | public |
| 775 | `ChallengeMission_InitializeObjectives` | — | public |
| 884 | `ChallengeMission_OnUpgradeComplete` | `context` | public |
| 914 | `ChallengeMission_OnConstructionComplete` | `context` | public |
| 1002 | `ChallengeMission_Update` | — | public |
| 1259 | `ChallengeMission_MissedGold` | — | public |
| 1265 | `ChallengeMission_MissedSilver` | — | public |
| 1271 | `ChallengeMission_MissedBronze` | — | public |
| 1278 | `ChallengeMission_OnDestruction` | `context` | public |
| 1297 | `ChallengeMission_CheckAgingUp` | — | public |
| 1324 | `ChallengeMission_CheckUnitCount` | — | public |
| 1338 | `ChallengeMission_NarrativeHintSecondTownCenter` | — | public |
| 1366 | `ChallengeMission_NarrativeHintMarkets` | — | public |
| 1393 | `ChallengeMission_NarrativeHintHouses` | — | public |
| 1426 | `ChallengeMission_NarrativeHintFarms` | — | public |
| 1463 | `ChallengeMission_NarrativeHintTechnologies` | — | public |
| 1486 | `ChallengeMission_CheckAnnihilation` | `context` | public |
| 1577 | `ChallengeMission_OnComplete` | — | public |
| 1594 | `ChallengeMission_EndChallenge` | — | public |
| 1604 | `ChallengeMission_DefeatPresentation` | `playerID` | public |

### scenarios\cdn_challenge_missions\challenge_mission_latesiege\challenge_mission_latesiege_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 34 | `TrainingGoal_EnableLateSiegeGoals` | — | public |
| 40 | `TrainingGoal_DisableLateSiegeGoals` | — | public |
| 46 | `LateSiegeTrainingGoals_InitBuildSiegeTowerHint_Xbox` | — | public |
| 71 | `LateSiegeTrainingGoals_InitBuildSiegeTowerHint` | — | public |
| 102 | `LateSiegeTrainingGoals_OnInit` | — | public |
| 289 | `CanBuildSiegeTowerPredicate_Xbox` | `goalSequence` | public |
| 345 | `CanBuildSiegeTowerPredicate` | `goalSequence` | public |
| 406 | `UserHasSelectedSiegeEngineer` | `goal` | public |
| 454 | `UserIsBuildingSiegeTower` | `goalSequence` | public |
| 494 | `UserHasBuiltSiegeTower` | `goalSequence` | public |
| 554 | `HasSiegeTowerPredicateForGarrison` | `goalSequence` | public |
| 624 | `UserHasSelectedSiegeTowerForGarrison` | `goal` | public |
| 646 | `UserHasSelectedMilitaryUnitsForGarrison` | `goal` | public |
| 670 | `UserHasGarrisonedSiegeTower` | `goal` | public |
| 729 | `UserHasSelectedSiegeTowerForUnload` | — | public |
| 755 | `HasGarrisonedSiegeTowerNearWallPredicate` | `goalSequence` | public |
| 838 | `UserHasUnloadedSiegeTower` | `goal` | public |
| 904 | `RamBuiltPredicate` | `goalSequence` | public |
| 964 | `UserHasSelectedBatteringRam` | `goal` | public |
| 1002 | `SpringaldBuiltPredicate` | `goalSequence` | public |
| 1035 | `UserHasSelectedSpringald` | `goal` | public |
| 1069 | `MangonelBuiltPredicate` | `goalSequence` | public |
| 1102 | `UserHasSelectedMangonel` | `goal` | public |
| 1136 | `TrebuchetBuiltPredicate` | `goalSequence` | public |
| 1181 | `UserHasSelectedTrebuchet` | `goal` | public |
| 1224 | `BombardBuiltPredicate` | `goalSequence` | public |
| 1257 | `UserHasSelectedBombard` | `goal` | public |

### scenarios\cdn_challenge_missions\challenge_mission_latesiege\challenge_mission_latesiege.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 93 | `Mission_OnInit` | — | public |
| 222 | `Mission_OnGameSetup` | — | public |
| 232 | `Mission_Preset` | — | public |
| 242 | `Mission_PreStart` | — | public |
| 258 | `Mission_Start` | — | public |
| 292 | `Mission_PreStart_IntroNISFinished` | — | public |
| 311 | `ChallengeMission_SetupChallengePlayers` | — | public |
| 324 | `ChallengeMission_SetRestrictions` | — | public |
| 339 | `GetRecipe` | — | public |
| 421 | `ChallengeMission_SetupChallenge` | — | public |
| 503 | `ChallengeMission_InitStartingUnits` | — | public |
| 601 | `ChallengeMission_InitStartingUpgrades` | — | public |
| 625 | `ChallengeMission_InitCombatModules` | — | public |
| 634 | `ChallengeMission_SetSlowUnitSpeed` | — | public |
| 646 | `ChallengeMission_SetStandardUnitSpeed` | — | public |
| 658 | `ChallengeMission_RallyEnemyArchers` | — | public |
| 702 | `ChallengeMission_RallyEnemyMilitary` | — | public |
| 712 | `ChallengeMission_RallyPlayerMilitary` | — | public |
| 731 | `ChallengeMission_PatrolEnemyKnights` | — | public |
| 745 | `ChallengeMission_PatrolEnemyKnights1` | — | public |
| 780 | `ChallengeMission_PatrolEnemyKnights2` | — | public |
| 829 | `ChallengeMission_PatrolEnemyKnights3` | — | public |
| 867 | `ChallengeMission_InitializeObjectives` | — | public |
| 1023 | `ChallengeMission_Update` | — | public |
| 1239 | `ChallengeMission_MissedGold` | — | public |
| 1245 | `ChallengeMission_MissedSilver` | — | public |
| 1251 | `ChallengeMission_MissedBronze` | — | public |
| 1258 | `ChallengeMission_GateUnderAttack` | — | public |
| 1315 | `ChallengeMission_DefendAfterSallyForth` | — | public |
| 1353 | `ChallengeMission_ProximityInner` | — | public |
| 1371 | `ChallengeMission_ProximityGate` | — | public |
| 1422 | `ChallengeMission_ProximityWest` | — | public |
| 1442 | `ChallengeMission_ProximityFlank` | — | public |
| 1464 | `ChallengeMission_DefendFlank` | — | public |
| 1489 | `ChallengeMission_AttackRams` | — | public |
| 1512 | `ChallengeMission_OnDestruction` | `context` | public |
| 1717 | `ChallengeMission_CheckAnnihilation` | `context` | public |
| 1755 | `CheckLateSiegeAnnihiliation` | — | public |
| 1873 | `CalculateLateSiegeStartingResources` | — | public |
| 1902 | `LateSiegeReinforcements` | — | public |
| 1959 | `ChallengeMission_CheckVictory` | — | public |
| 2001 | `ChallengeMission_InitializeOutro` | — | public |
| 2025 | `ChallengeMission_CheckCheer` | — | public |
| 2052 | `ChallengeMission_SetBuildingsOnFire` | — | public |
| 2105 | `ChallengeMission_EndChallenge` | — | public |
| 2114 | `ChallengeMission_DefeatPresentation` | `playerID` | public |
| 2144 | `UserHasUnloadedSiegeTowerNarration` | — | public |
| 2190 | `DefendAgainstSiege` | — | public |
| 2254 | `CheckIfSiegeBuildingsSelected` | — | public |
| 2300 | `RetreatArchers` | — | public |
| 2318 | `EnemyGarrisonTownCenter` | — | public |
| 2337 | `ArcFormation` | `startPos, endPos, inGroup, curveStrength, inQueued, inOffset` | public |
| 2377 | `ScriptScatterUnits` | `inGroup, inDistToMove, inUseGroupCenter, inCenter, inFaceUnits, inFacingMarker, inQueued` | public |

### scenarios\cdn_challenge_missions\challenge_mission_malian\challenge_mission_malian_diplomacy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Diplomacy_DiplomacyEnabled` | `is_enabled` | public |
| 125 | `Diplomacy_TributeEnabled` | `is_enabled` | public |
| 133 | `Diplomacy_OnInit` | — | public |
| 140 | `Diplomacy_Start` | — | public |
| 162 | `Diplomacy_OnGameOver` | — | public |
| 170 | `Diplomacy_OnGameRestore` | — | public |
| 181 | `Diplomacy_ToggleDiplomacyUI` | — | public |
| 195 | `Diplomacy_ShowDiplomacyUI` | `show` | public |
| 205 | `Diplomacy_IsExpanded` | — | public |
| 211 | `Diplomacy_ChangeRelation` | `parameter` | public |
| 217 | `Diplomacy_IncreaseTribute` | `parameter` | public |
| 228 | `Diplomacy_DecreaseTribute` | `parameter` | public |
| 239 | `Diplomacy_ClearTribute` | — | public |
| 252 | `Diplomacy_SendTribute` | — | public |
| 271 | `Diplomacy_ShowUI` | `show` | public |
| 284 | `Diplomacy_OnConstructionComplete` | `context` | public |
| 300 | `Diplomacy_OnPlayerDefeated` | `player, reason` | public |
| 324 | `Diplomacy_OnPlayerNameChanged` | `context` | public |
| 336 | `Diplomacy_OnUpgradeComplete` | `context` | public |
| 357 | `Diplomacy_UpdateDataContext` | — | public |
| 446 | `Diplomacy_OverridePlayerSettings` | `playerID, is_player_visible, is_tribute_visible, is_food_enabled, is_wood_enabled, is_gold_enabled, is_stone_enabled` | public |
| 463 | `Diplomacy_OverrideSettings` | `is_tribute_enabled, is_subtotal_visible, is_score_visible, is_team_visible` | public |
| 472 | `Diplomacy_GetTaxRate` | `playerID` | public |
| 477 | `Diplomacy_SetTaxRate` | `playerID, tax_rate` | public |
| 484 | `Diplomacy_AddTribute` | `player_index, resource_index, amount` | public |
| 520 | `Diplomacy_CreateDataContext` | — | public |
| 590 | `Diplomacy_FormatTeamNumber` | `team_number` | public |
| 599 | `Diplomacy_SortDataContext` | — | public |
| 612 | `Diplomacy_CreateUI` | — | public |
| 873 | `Diplomacy_RemoveUI` | — | public |
| 881 | `Diplomacy_UpdateUI` | — | public |
| 888 | `Rule_Diplomacy_UpdateUI` | — | public |
| 895 | `Diplomacy_Restart` | — | public |
| 902 | `Diplomacy_ShowEventCue` | `tribute` | public |
| 929 | `Diplomacy_SendTributeNtw` | `playerID, data` | public |

### scenarios\cdn_challenge_missions\challenge_mission_malian\challenge_mission_malian_preintro.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Malian_PreIntro_Setup_Scenes` | — | public |
| 31 | `Malian_PreIntro_Shot01_Units` | — | public |
| 134 | `Malian_PreIntro_Shot01_Turn_Elephant` | — | public |
| 149 | `Malian_PreIntro_Shot01_Turn_Elephant2` | — | public |
| 162 | `Malian_PreIntro_Shot01_MenAtArms_Attack` | — | public |
| 168 | `Malian_PreIntro_Shot01_MenAtArms_Attack2` | — | public |
| 174 | `Malian_PreIntro_Shot01_Archer_Retreat` | — | public |
| 181 | `Malian_PreIntro_Shot01_Musofadi_Hold` | — | public |
| 197 | `Malian_PreIntro_Shot01_Musofadi_Attack` | — | public |
| 205 | `Malian_PreIntro_Shot01_Javelin_Attack` | — | public |
| 212 | `Malian_PreIntro_Shot01_Gunner_Attack` | — | public |
| 220 | `Malian_PreIntro_Shot02_Units` | — | public |
| 279 | `Malian_PreIntro_Shot02_Move` | — | public |
| 318 | `Malian_PreIntro_Shot02_Move2` | — | public |
| 348 | `Malian_PreIntro_Shot02_Hold` | — | public |
| 431 | `Malian_PreIntro_Shot02_Attack` | — | public |
| 505 | `Malian_PreIntro_Shot02_EnemyAttack` | — | public |
| 547 | `Malian_PreIntro_AttackInDirection` | `inSquad` | public |
| 596 | `Malian_PreIntro_Shot03_Units` | — | public |
| 633 | `Malian_PreIntro_Shot03_DonsoAttack` | — | public |
| 658 | `Malian_PreIntro_Shot03_DonsoAttack2` | — | public |
| 682 | `Malian_PreIntro_Shot04_Units` | — | public |
| 717 | `Malian_PreIntro_Shot04_ManAtArms_Attack` | — | public |
| 722 | `Malian_PreIntro_Shot04_Archer_Attack` | — | public |
| 751 | `Malian_PreIntro_Shot04_Archer_Retreat` | — | public |
| 759 | `Malian_PreIntro_Shot04_Enemy_Archer_Chase` | — | public |
| 797 | `Malian_Intro_Shot_Units` | — | public |
| 809 | `Malian_PreIntro_Clean_Scenes` | — | public |
| 818 | `Malian_PreIntro_Shot01_Clean_Up` | — | public |
| 875 | `Malian_PreIntro_Shot02_Clean_Up` | — | public |
| 913 | `Malian_PreIntro_Shot03_Clean_Up` | — | public |
| 932 | `Malian_PreIntro_Shot04_Clean_Up` | — | public |
| 952 | `Malian_PreIntro_Shot05_Clean_Up` | — | public |
| 962 | `Destroy` | `gid, idx, eid` | public |
| 967 | `DestroyEntity` | `gid, idx, eid` | public |
| 971 | `DespawnCarcasses` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_malian\challenge_mission_malian_reinforce.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `UI_ReinforcePanel_UpdateData` | — | public |
| 79 | `UI_RequestAid_ButtonCallback` | `parameter` | public |
| 130 | `UI_RequestAid_EventCue` | — | public |
| 137 | `UI_RequestAid_MoveCamera` | — | public |
| 143 | `Start_IntelCooldown` | `target, reserve` | public |
| 153 | `ReinforceIntel_Cooldown` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_malian\challenge_mission_malian_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 18 | `TrainingGoal_EnableMalianGoals` | — | public |
| 24 | `TrainingGoal_DisableMalianGoals` | — | public |
| 30 | `MalianTrainingGoals_InitMusofadiHint_Xbox` | — | public |
| 55 | `MalianTrainingGoals_InitMusofadiHint` | — | public |
| 74 | `MalianTrainingGoals_OnInit` | — | public |
| 95 | `MalianTrainingGoals_DelayMusofadiHint` | — | public |
| 114 | `CanActivateStealthPredicate_Xbox` | `goalSequence` | public |
| 159 | `CanActivateStealthPredicate` | `goalSequence` | public |
| 204 | `UserHasSelectedMusofadiUnit` | `goal` | public |
| 244 | `UserActivatedStealth` | `goalSequence` | public |
| 290 | `UserHasCompletedStealth` | `goalSequence` | public |
| 351 | `MalianTrainingGoals_AddDiplomacyPanelHint` | — | public |
| 370 | `UserHasOpenedTheDiplomacyMenu` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_malian\challenge_mission_malian.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 54 | `Mission_OnInit` | — | public |
| 76 | `Mission_SetupVariables` | — | public |
| 343 | `ChallengeMission_SetupDiplomacy` | — | public |
| 379 | `ChallengeMission_GetWaveUnitCount` | `waveUnitPercent, waveUnitBP` | public |
| 394 | `ChallengeMission_AddNewWave` | — | public |
| 509 | `Mission_SetupPlayers` | — | public |
| 532 | `Mission_SetRestrictions` | — | public |
| 537 | `Mission_PreInit` | — | public |
| 542 | `Mission_Preset` | — | public |
| 563 | `Mission_Start` | — | public |
| 662 | `GetRecipe` | — | public |
| 700 | `ChallengeMission_InitializeObjectives` | — | public |
| 807 | `ChallengeMission_PathSetupObjectives` | — | public |
| 897 | `ChallengeMission_CheckPathSetupObjectives` | — | public |
| 1055 | `ChallengeMission_CapturePath1` | — | public |
| 1087 | `ChallengeMission_CapturePath2` | — | public |
| 1123 | `ChallengeMission_UpdateMedals` | — | public |
| 1151 | `ChallengeMission_CheckVictory` | — | public |
| 1173 | `ChallengeMission_EndChallenge` | — | public |
| 1192 | `ChallengeMission_OnGameSetup` | — | public |
| 1204 | `ChallengeMission_SpawnPlayerUnits` | — | public |
| 1241 | `ChallengeMission_SetupGbetoScouts` | — | public |
| 1425 | `ChallengeMission_SetupGbetoScouts2` | — | public |
| 1434 | `ChallengeMission_SetPlayerUpgrades` | — | public |
| 1489 | `ChallengeMission_Update` | — | public |
| 1566 | `ChallengeMission_GrantExtraGoldIncome` | — | public |
| 1572 | `ChallengeMission_PulseThreatBlip` | — | public |
| 1590 | `ChallengeMission_SendWave` | `sendWaveIndex` | public |
| 1657 | `ChallengeMission_GuideWaves` | — | public |
| 1783 | `ChallengeMission_DespawnRelic` | `relicPos` | public |
| 1801 | `ChallengeMission_OrderConverts` | — | public |
| 1850 | `ChallengeMission_CheckForIdleWaves` | — | public |
| 1888 | `ChallengeMission_PickUpRelic` | `context, data` | public |
| 1914 | `ChallengeMission_GuideWaveAttack` | `context, data` | public |
| 1928 | `Malian_Wave_SpawnRelic` | `context, data` | public |
| 1941 | `Malian_Wave_Convert` | `context, data` | public |
| 1949 | `ChallengeMission_CheckNodeInUse` | `checkWaveObject, checkPathIndex, checkNodeIndex` | public |
| 1966 | `ChallengeMission_SwitchTarget` | — | public |
| 2050 | `ChallengeMission_TargetMines` | — | public |
| 2108 | `ChallengeMission_OnSquadKilled` | `context` | public |
| 2152 | `ChallengeMission_CheckLaneActive` | `laneIndex` | public |
| 2185 | `ChallengeMission_OnDestruction` | `context` | public |
| 2237 | `ChallengeMission_SetupMinimapPath` | `markerPath, pathIndex, waveIndex` | public |
| 2267 | `ChallengeMission_ScoutHoldPos` | `context, data` | public |
| 2296 | `ChallengeMission_ScoutHoldGround` | `unit` | public |
| 2323 | `ChallengeMission_UpdateTorches` | — | public |
| 2366 | `ChallengeMission_SetupMinimapNode` | `context, data` | public |
| 2388 | `ChallengeMission_IntroduceDiplomacyUI` | — | public |
| 2395 | `ChallengeMission_CheckDiplomacyReminder` | — | public |
| 2414 | `ChallengeMission_ShowTributeMenu` | — | public |
| 2422 | `ChallengeMission_HideTributeMenu` | — | public |
| 2430 | `ArcFormation` | `startPos, endPos, inGroup, curveStrength, inQueued, inOffset` | public |

### scenarios\cdn_challenge_missions\challenge_mission_ottoman\challenge_mission_ottoman_automated.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 18 | `AutoTest_OnInit` | — | public |
| 41 | `AutomatedOttoman_RegisterCheckpoints` | — | public |
| 59 | `AutoTest_SkipAndStart` | — | public |
| 68 | `AutoTest_PlayIntro` | — | public |
| 82 | `AutomatedMission_Start` | — | public |
| 119 | `AutomatedOttoman_AfterStart` | — | public |
| 124 | `AutomatedOttoman_MonitorDefenders` | — | public |
| 138 | `AutomatedOttoman_MonitorReinforcements` | `context, data` | public |
| 148 | `AutomatedOttoman_Phase0_CheckPlayStart` | — | public |
| 157 | `AutomatedOttoman_Phase1_Setup` | — | public |
| 162 | `AutomatedOttoman_Phase1_Monitor` | — | public |
| 171 | `AutomatedOttoman_Phase2_Setup` | — | public |
| 176 | `AutomatedOttoman_Phase2_Monitor` | — | public |
| 185 | `AutomatedOttoman_Phase3_Setup` | — | public |
| 190 | `AutomatedOttoman_Phase3_Monitor` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_ottoman\challenge_mission_ottoman_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Ottoman_InitData1` | — | public |
| 1368 | `Ottoman_InitData2` | — | public |
| 1372 | `CreateAssaultModule` | `spawn, targets, attackBuildings` | public |
| 1404 | `GetRoundCost` | `round` | public |
| 1413 | `CalculateArrivalTime` | `isNextRound` | public |
| 1424 | `GetMetaRoundString` | `metaRound` | public |
| 1428 | `GetSlowestUnitSpeed` | `unitTable` | public |
| 1447 | `GetUnitTypeFromUnitRow` | `unitRow` | public |

### scenarios\cdn_challenge_missions\challenge_mission_ottoman\challenge_mission_ottoman_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Ottoman_InitObjectives` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_ottoman\challenge_mission_ottoman.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `Mission_SetupPlayers` | — | public |
| 24 | `Mission_SetupVariables` | — | public |
| 29 | `Mission_Preset` | — | public |
| 112 | `Mission_PreStart` | — | public |
| 125 | `Mission_Start` | — | public |
| 139 | `CheckForAkinji` | — | public |
| 148 | `CheckForUnpause` | — | public |
| 164 | `Mission_Unpause` | — | public |
| 184 | `GetRecipe` | — | public |
| 196 | `PerTic` | — | public |
| 213 | `PerSecond` | `context, data` | public |
| 248 | `SpawnAttack` | `round` | public |
| 265 | `LaunchAttack` | `context, data` | public |
| 271 | `LaunchAttackUI` | `context, data` | public |
| 279 | `MonitorAttack` | `context, data` | public |
| 288 | `GetPlayerReport` | — | public |
| 309 | `SpawnVillagersAndAssign` | `marker_table, gatherFunction` | public |

### scenarios\cdn_challenge_missions\challenge_mission_walldefense\challenge_mission_walldefense_preintro.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `WallD_PreIntro_Shot01_Units` | — | public |
| 67 | `WallD_PreIntro_Shot01_CleanUp` | — | public |
| 74 | `WallD_PreIntro_Shot02_Units` | — | public |
| 104 | `WallD_PreIntro_Shot02_AttackTower` | — | public |
| 115 | `WallD_PreIntro_Shot01b_HoldPosition` | — | public |
| 120 | `WallD_PreIntro_Shot01b` | — | public |
| 125 | `WallD_PreIntro_Shot02_CleanUp` | — | public |
| 134 | `WallD_PreIntro_Shot03_Units` | — | public |
| 146 | `WallD_PreIntro_Shot03_CavalryCharge` | — | public |
| 152 | `WallD_PreIntro_Shot03_CleanUp` | — | public |
| 160 | `WallD_PreIntro_Shot04_Units` | — | public |
| 174 | `WallD_PreIntro_Shot04_b` | — | public |
| 184 | `WallD_PreIntro_Shot04_c` | — | public |
| 189 | `WallD_PreIntro_Shot04_CleanUp` | — | public |
| 200 | `WallD_PreIntro_Shot05_Units` | — | public |
| 254 | `WallD_PreIntro_Shot05_CleanUp` | — | public |
| 268 | `WallD_PreIntro_Shot06_Units` | — | public |
| 301 | `WallD_PreIntro_Shot06_CleanUp` | — | public |
| 315 | `WallD_Intro_Spawn` | — | public |

### scenarios\cdn_challenge_missions\challenge_mission_walldefense\challenge_mission_walldefense.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `Mission_SetupVariables` | — | public |
| 341 | `Mission_SetupPlayers` | — | public |
| 365 | `Mission_SetRestrictions` | — | public |
| 370 | `Mission_PreInit` | — | public |
| 374 | `Mission_Preset` | — | public |
| 473 | `MissionOMatic_PreStart_IntroNISFinished` | — | public |
| 484 | `Walld_Disable_Tax` | — | public |
| 491 | `Mission_Start` | — | public |
| 519 | `GetRecipe` | — | public |
| 548 | `WallD_InitObjectives` | — | public |
| 632 | `WallD_SpawnPlayerUnits` | — | public |
| 644 | `WallD_SpawnWaves` | `unitList` | public |
| 688 | `WallD_SendWave` | — | public |
| 810 | `WallD_PatrolWaves` | — | public |
| 857 | `WallD_RangedWaves` | — | public |
| 910 | `WallD_CheckRangedName` | `currentArmyName` | public |
| 923 | `WallD_CheckArchersBlocked` | — | public |
| 986 | `WallD_CheckIdleRanged` | — | public |
| 1093 | `WallD_ArchersBlocked` | `module` | public |
| 1107 | `WallD_TimerComplete` | — | public |
| 1111 | `WallD_WonderTimerComplete` | — | public |
| 1115 | `WallD_AwardResources` | — | public |
| 1123 | `WallD_StartBronze` | — | public |
| 1132 | `WallD_StartSilver` | — | public |
| 1136 | `WallD_StartGold` | — | public |
| 1141 | `WallD_BronzeComplete` | — | public |
| 1151 | `WallD_SilverComplete` | — | public |
| 1161 | `WallD_HealWalls` | — | public |
| 1178 | `WallD_WallsDamagedCheck` | — | public |
| 1190 | `WallD_ApproachingWaveContains` | `bp` | public |
| 1203 | `WallD_TrickleResources` | — | public |
| 1211 | `_WallD_QueueVillagerRespawn` | `context, data` | private |
| 1215 | `WallD_VillagerRespawn` | — | public |
| 1238 | `WallD_SpawnUnspawnedVillagers` | — | public |
| 1262 | `WallD_ResetVillagerCTA` | — | public |
| 1266 | `WallD_TraderLoop` | — | public |
| 1273 | `_WallD_DelayTraderDepart` | `context, data` | private |
| 1283 | `WallD_RamCheck` | — | public |
| 1295 | `WallD_TowerCheck` | — | public |
| 1307 | `WallD_MangonelCheck` | — | public |
| 1319 | `WallD_TrebuchetCheck` | — | public |
| 1331 | `WallD_SpendResources1` | — | public |
| 1346 | `WallD_SpendResources2` | — | public |

### scenarios\historical_challenges\challenge_agincourt\challenge_agincourt_counterattack.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `HC_Agincourt_StartCounterAttacks` | — | public |
| 24 | `HC_Agincourt_PulseThreatBlip` | — | public |
| 37 | `HC_Agincourt_SpawnMainCounterAttack` | — | public |
| 72 | `HC_Agincourt_SpawnAgincourtRaid` | — | public |
| 94 | `HC_Agincourt_SpawnTramecourtRaid` | — | public |

### scenarios\historical_challenges\challenge_agincourt\challenge_agincourt_obj.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `HC_Agincourt_InitObjectives` | — | public |
| 380 | `HC_Agincourt_InitObjectiveUI` | — | public |
| 387 | `HC_Agincourt_InitObjectiveUI2` | — | public |
| 395 | `HC_Agincourt_UpdateObjectiveUI` | — | public |
| 494 | `HC_Agincourt_CheckWave1Ended` | — | public |
| 506 | `HC_Agincourt_FinishWave1Attack` | — | public |
| 541 | `HC_Agincourt_CheckWave2Ended` | — | public |
| 552 | `HC_Agincourt_CompleteWave2` | — | public |
| 575 | `HC_Agincourt_LaunchWave3Attack` | — | public |
| 589 | `HC_Agincourt_CheckWave3Ended` | — | public |

### scenarios\historical_challenges\challenge_agincourt\challenge_agincourt_wave1.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 10 | `HC_Agincourt_SpawnFrenchWave1` | — | public |
| 64 | `HC_Agincourt_Wave1_SpawnUnits` | — | public |
| 113 | `HC_Agincourt_Wave1_PreStart` | — | public |
| 155 | `HC_Agincourt_Wave1_PreUpdate` | — | public |
| 416 | `HC_Agincourt_Wave1_CheckCenter` | — | public |
| 497 | `HC_Agincourt_Wave1_Start` | — | public |
| 529 | `HC_Agincourt_Wave1_Update` | — | public |
| 597 | `HC_Agincourt_Wave1_UpdateLeaderReticule` | — | public |
| 631 | `HC_Agincourt_Wave1_GatherAroundLeader` | — | public |
| 731 | `HC_Agincourt_Wave1_UpdateLeaderCombat` | — | public |
| 810 | `HC_Agincourt_Wave1_UpdateLeader` | — | public |
| 897 | `HC_Agincourt_Wave1_CheckProgress` | — | public |
| 1120 | `HC_Agincourt_Wave1_ResumeLanes` | — | public |
| 1150 | `HC_Agincourt_Wave1_SendBackToLane` | `sg_LaneSGroup, in_laneNumber, in_avgProgress, in_UseFormation, in_UseAttackMove` | public |
| 1203 | `HC_Agincourt_Wave1_CheckLaneProgress` | `in_Position, in_laneNumber, in_Objective` | public |
| 1242 | `HC_Agincourt_GetPointOnLane` | `inPA, inPB, inPC` | public |

### scenarios\historical_challenges\challenge_agincourt\challenge_agincourt_wave2.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `HC_Agincourt_SpawnFrenchWave2` | — | public |
| 73 | `HC_Agincourt_Wave2_SpawnUnits` | — | public |
| 123 | `HC_Agincourt_RevealFrenchWave2` | — | public |
| 161 | `HC_Agincourt_Wave2_Start` | — | public |
| 233 | `HC_Agincourt_Wave2_Update` | — | public |
| 299 | `HC_Agincourt_Wave2_BreakOffGroup` | `inSubGroup` | public |
| 397 | `HC_Agincourt_Wave2_CheckCenter` | — | public |
| 473 | `HC_Agincourt_Wave2_UpdateLeader` | — | public |
| 576 | `HC_Agincourt_Wave2_UpdateLeader2` | — | public |
| 708 | `HC_Agincourt_Wave2HealingAbilities` | — | public |
| 738 | `HC_Agincourt_Wave2DamageAbilities` | — | public |
| 772 | `HC_Agincourt_Wave2_Begin_AoE` | — | public |
| 802 | `HC_Agincourt_Wave2_UpdateLeaderReticule` | — | public |
| 834 | `HC_Agincourt_Wave2_Apply_AoE` | — | public |
| 865 | `HC_Agincourt_Wave2_End_AoE` | — | public |
| 876 | `HC_Agincourt_Wave2_CheckFit` | — | public |
| 930 | `HC_Agincourt_Wave2_SendBackToLane` | `sg_LaneSGroup, in_laneNumber, in_avgProgress, in_UseFormation, in_UseAttackMove` | public |
| 1010 | `HC_Agincourt_Wave2_CheckLaneFit` | `in_Position, in_laneNumber, in_Objective` | public |

### scenarios\historical_challenges\challenge_agincourt\challenge_agincourt_wave3.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `HC_Agincourt_SpawnFrenchWave3` | — | public |
| 32 | `HC_Agincourt_Wave3_SpawnUnits` | — | public |
| 98 | `HC_Agincourt_RevealFrenchWave3` | — | public |
| 116 | `HC_Agincourt_Wave3_Start` | — | public |
| 189 | `HC_Agincourt_Wave3_Lane1Attack` | — | public |
| 203 | `HC_Agincourt_Wave3_Lane3Attack` | — | public |
| 217 | `HC_Agincourt_Wave3_Lane5Attack` | — | public |
| 231 | `HC_Agincourt_Wave3_BeginLaneAdvance` | `context, data` | public |
| 264 | `HC_Agincourt_Wave3_Update` | — | public |
| 515 | `HC_Agincourt_Wave3_UpdateLeader` | — | public |
| 633 | `HC_Agincourt_Wave3_CheckFit` | — | public |
| 865 | `HC_Agincourt_Wave3_CheckLaneFit` | `in_Position, in_laneNumber, in_Objective` | public |
| 899 | `HC_Agincourt_Wave3_UpdateLeaderReticule` | — | public |
| 933 | `HC_Agincourt_Wave3_GatherAroundLeader` | — | public |
| 982 | `HC_Agincourt_Wave3_StartLeaderPromotion` | — | public |
| 988 | `HC_Agincourt_Wave3_UpdateLeaderCombat` | — | public |

### scenarios\historical_challenges\challenge_agincourt\challenge_agincourt.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `Mission_SetupVariables` | — | public |
| 55 | `Mission_SetupPlayers` | — | public |
| 90 | `Mission_SetRestrictions` | — | public |
| 114 | `ChallengeMission_SetupDiplomacy` | — | public |
| 143 | `Mission_PreInit` | — | public |
| 154 | `Mission_Preset` | — | public |
| 161 | `Mission_Start` | — | public |
| 212 | `test_destroyWave1` | — | public |
| 217 | `test_destroyWave2` | — | public |
| 224 | `GetRecipe` | — | public |
| 255 | `HC_Agincourt_Update` | — | public |
| 371 | `HC_Agincourt_SpawnFrenchArmy` | — | public |
| 472 | `HC_Agincourt_SpawnPlayerUnits` | — | public |
| 533 | `HC_Agincourt_SpawnGaiaUnits` | — | public |
| 551 | `HC_Agincourt_OnSquadKilled` | `context` | public |
| 569 | `HC_Agincourt_RespawnHenry` | `context` | public |
| 587 | `HC_Agincourt_OnDestruction` | `context` | public |
| 599 | `HC_Agincourt_OnProjectileFired` | `context` | public |
| 677 | `HC_Agincourt_SpawnCannonHitEffect` | `context, data` | public |
| 715 | `HC_Agincourt_SpawnBounceHitEffect` | `context, data` | public |
| 740 | `HC_Agincourt_OnAbilityExecuted` | `context, data` | public |
| 748 | `HC_Agincourt_ResetAbility` | — | public |
| 755 | `HC_Agincourt_EndChallenge` | — | public |
| 776 | `HC_Agincourt_IntroSetup` | — | public |
| 855 | `HC_Agincourt_IntroSetup2` | — | public |
| 871 | `HC_Agincourt_IntroSetup_enemy_cheer` | — | public |
| 879 | `HC_Agincourt_IntroSetup3` | — | public |
| 894 | `HC_Agincourt_IntroSetup4` | — | public |
| 936 | `HC_Agincourt_IntroSetupShot2` | — | public |
| 962 | `HC_Agincourt_IntroSetupShot2_yeomen` | — | public |
| 974 | `HC_Agincourt_IntroSetupShot2_yeomen2` | — | public |
| 985 | `HC_Agincourt_IntroSetupShot2_spearmen_cheer` | — | public |
| 990 | `HC_Agincourt_IntroSetupShot2_yeomen_cheer` | — | public |
| 997 | `HC_Agincourt_IntroTeardown` | — | public |

### scenarios\historical_challenges\challenge_montgisard\challenge_montgisard_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Montgisard_InitData` | — | public |
| 318 | `Montgisard_SetupLocations` | — | public |
| 330 | `Montgisard_InitPatrolPaths` | — | public |
| 444 | `Montgisard_AttackGroupsData` | — | public |
| 458 | `Montgisard_SetupDiplomacy` | — | public |
| 489 | `Montgisard_GetCurrentSites` | `player, counter` | public |
| 560 | `Montgisard_SetupModifiers` | — | public |

### scenarios\historical_challenges\challenge_montgisard\challenge_montgisard_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Montgisard_InitObjectives` | — | public |

### scenarios\historical_challenges\challenge_montgisard\challenge_montgisard_reinforcements.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `Montgisard_ReinforceData` | `reinforce_n, conqueror_mode` | public |
| 60 | `Montgisard_GetConquerorUnits` | `unitTable` | public |
| 123 | `Montgisard_AddPingAndSound` | — | public |
| 145 | `Montgisard_RemovePing` | `context, data` | public |
| 150 | `Montgisard_GetAttackUnitBP` | `unitType, attackNumber, attackOrigin` | public |
| 222 | `Montgisard_GetAttackUnitSpawnPoint` | `unitType, attackOrigin` | public |
| 298 | `Montgisard_GetAttackUnitStrength` | `unitType, attackNumber, attackOrigin, attackTarget` | public |
| 499 | `Montgisard_GetAttackPath` | `pathType, pathStart, pathEnd` | public |
| 573 | `Montgisard_InitReinforceGroups` | — | public |
| 598 | `Montgisard_InitReinforceData` | — | public |
| 779 | `Montgisard_CreatePatrol` | `units, sgroup, path, pathReverse, size1, size2` | public |
| 815 | `Montgisard_TrackPatrol` | `context, data` | public |
| 840 | `Montgisard_BonusUnitsOnAgeUp` | `context, data` | public |
| 883 | `Montgisard_GetUnitSBP` | `unitType` | public |
| 948 | `Montgisard_SetSacredSiteBonuses` | — | public |
| 961 | `Montgisard_SacredSitesUnits` | `context, data` | public |
| 1014 | `Montgisard_UpdateSacredSitesBonuses` | — | public |

### scenarios\historical_challenges\challenge_montgisard\challenge_montgisard.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `Mission_SetupVariables` | — | public |
| 26 | `Mission_SetupPlayers` | — | public |
| 56 | `Mission_SetRestrictions` | — | public |
| 70 | `Mission_PreInit` | — | public |
| 76 | `Mission_Preset` | — | public |
| 83 | `Mission_Start` | — | public |
| 107 | `Montgisard_SpawnPointsOfInterest` | — | public |
| 231 | `Montgisard_ConquerorTriggerSite` | — | public |
| 267 | `Montgisard_UpdatePointsOfInterest` | — | public |
| 473 | `Montgisard_RewardPointsOfInterest` | — | public |
| 525 | `Montgisard_SpawnAllyArmy` | `context, data` | public |
| 536 | `Montgisard_LaunchAllyArmy` | `context, data` | public |
| 547 | `Montgisard_Test` | — | public |
| 552 | `Montgisard_SpawnNeutralVills` | — | public |
| 580 | `Montgisard_OnEnemyBuildingDamage` | `context` | public |
| 609 | `Montgisard_FocusTrebs` | `buildingPosition, trebuchetPosition` | public |
| 671 | `Montgisard_StartingUnits` | — | public |
| 708 | `Montgisard_EnemyUnits` | — | public |
| 821 | `Montgisard_EnemyReinforcements` | — | public |
| 1004 | `Montgisard_EnemyPatrols` | — | public |
| 1022 | `Montgisard_DisplayMinimapPath` | `path` | public |
| 1028 | `Montgisard_RemoveMinimapPath` | — | public |
| 1033 | `Montgisard_EnemyAttacks` | — | public |
| 1070 | `Montgisard_RecaptureVoiceline` | — | public |
| 1075 | `Montgisard_GetInFormation` | `siteRecaptured` | public |
| 1132 | `Montgisard_LaunchAttack` | — | public |
| 1238 | `Montgisard_AttackTarget` | `target` | public |
| 1301 | `Montgisard_SetupAttackRuleForConqueror` | — | public |
| 1307 | `Montgisard_SetupReinforceRuleForConqueror` | — | public |
| 1313 | `Montgisard_AttackWarning` | `origin` | public |
| 1356 | `Montgisard_AttackWarningUpdate` | `context, data` | public |
| 1407 | `Montgisard_CheckForRams` | — | public |
| 1428 | `GetRecipe` | — | public |
| 1456 | `Montgisard_UpdateSacredSitesUI` | — | public |
| 1551 | `Montgisard_TrackSacredSites` | — | public |
| 1895 | `Montgisard_CheckForIdleAroundSS` | — | public |
| 1923 | `Montgisard_GetAvailableSiteForAttack` | — | public |
| 1969 | `HC_Montgisard_IntroSetup` | — | public |
| 2022 | `HC_Montgisard_IntroTeardown` | — | public |

### scenarios\historical_challenges\challenge_safed\challenge_safed_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Safed_Init_ESG_Data` | — | public |
| 503 | `Safed_On_Launch_Wave` | `wg, wave, my_marker, delay, wave_count` | public |
| 547 | `_Safed_Rotate_Spawns` | `markers` | private |
| 560 | `Safed_Cancel_Wave` | — | public |
| 573 | `Safed_Init_Player_Starting_Units` | — | public |
| 588 | `Safed_Init_Enemy_Encounters` | — | public |
| 631 | `Safed_Trigger_Town_Attack_Wave` | `data, markerID` | public |
| 656 | `_Safed_Wave_Respawn` | `context, data` | private |
| 664 | `Safed_Init_Save_Villagers` | — | public |
| 696 | `Safed_Monitor_Save_Villagers` | `context, data` | public |
| 723 | `Safed_Init_Enemy_Siege_Camp_Units` | — | public |
| 805 | `Safed_Init_Pickups` | — | public |

### scenarios\historical_challenges\challenge_safed\challenge_safed_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Safed_Init_Objectives` | — | public |
| 195 | `Safed_Update_Fortress_ProgressBar` | `context, data` | public |
| 210 | `Safed_Init_Siege_Camp` | `location` | public |
| 255 | `Safed_Siege_Camp_Monitor` | `context, instance` | public |
| 286 | `Safed_Siege_Camp_Count` | `instance` | public |
| 315 | `Safed_Siege_Camp_Set_Target` | — | public |
| 353 | `Safed_Unit_Cost_Init` | — | public |
| 379 | `Safed_Player_Can_Afford_Units` | — | public |
| 401 | `Safed_Monitor_Player_Can_Afford` | — | public |

### scenarios\historical_challenges\challenge_safed\challenge_safed_ram_attack.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Safed_Init_Enemy_Rams` | — | public |
| 52 | `Safed_Enemy_Ram_Attack_Monitor` | `context, data` | public |

### scenarios\historical_challenges\challenge_safed\challenge_safed_training.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Safed_Training_Hint_Save_Vills` | — | public |
| 36 | `Safed_Training_Trigger_Save_Vills` | `goalSequence` | public |
| 51 | `Safed_Training_Completed_Save_Vills` | `goal` | public |

### scenarios\historical_challenges\challenge_safed\challenge_safed_treb_attack.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Safed_Init_Treb_Attack` | `spawn_points, move_points, sgroup_prefix` | public |
| 57 | `Safed_Treb_Spawn` | `context, data` | public |
| 110 | `Safed_Treb_Arrived` | `context, data` | public |
| 161 | `Safed_Treb_Attack_Begin` | `context, data` | public |

### scenarios\historical_challenges\challenge_safed\challenge_safed_villagerlife.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 10 | `Safed_VillagerLife_Create` | `player, name, sg_roaming, sg_wood, sg_food, sg_stone, sg_gold, mkr_home` | public |
| 53 | `Safed_VillagerLife_Init` | `data` | public |
| 136 | `Safed_VillagerLife_Find` | `name` | public |
| 149 | `Safed_VillagerLife_AddSGroup` | `instance, sgroup, job` | public |
| 175 | `Safed_VillagerLife_GoToWork` | `instance` | public |
| 199 | `Safed_VillagerLife_Monitor` | `context, data` | public |
| 257 | `Safed_VillagerLife_SetWander` | `context, data` | public |
| 280 | `Safed_VillagerLife_Wander` | `instance, squad` | public |
| 295 | `Safed_Init_Villager_Life` | — | public |
| 304 | `Safed_Villager_Life_Create` | `mkr_prefix, villager_locations` | public |

### scenarios\historical_challenges\challenge_safed\challenge_safed.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `Mission_SetupPlayers` | — | public |
| 67 | `Mission_SetupVariables` | — | public |
| 137 | `GetRecipe` | — | public |
| 193 | `Mission_SetRestrictions` | — | public |
| 365 | `Mission_Preset` | — | public |
| 438 | `Mission_PreStart` | — | public |
| 471 | `Mission_Start` | — | public |
| 507 | `Safed_Modify_Villager_Rates` | — | public |
| 543 | `Safed_Modify_Stone_Node_Amounts` | — | public |
| 563 | `Safed_Modify_Fortress` | — | public |
| 613 | `Safed_Fortress_Empathy_Damage` | — | public |
| 651 | `Safed_Fortress_Health_Update` | — | public |
| 707 | `Safed_Fortress_Repair` | — | public |
| 750 | `Safed_Modify_Stone_Gather_Rates` | — | public |
| 793 | `Safed_Arrival_At_Town` | `context, data` | public |
| 831 | `Safed_Monitor_Stone_Resource_Depleted` | — | public |
| 906 | `Safed_Stone_Depleted` | `EGroup, currentMarkerID, player, nextLocation, giftedResources` | public |
| 970 | `Safed_Gift_Villagers` | — | public |
| 1000 | `Safed_Change_Nearby_Entities_Owner` | `EGroup, markerID, playerId` | public |
| 1076 | `Safed_Reveal_Stone` | `location` | public |
| 1123 | `Safed_Monitor_Player_Stone` | — | public |
| 1159 | `Safed_Modify_Safed_City` | — | public |
| 1238 | `Safed_Modify_Enemy_Tents` | — | public |
| 1265 | `Safed_Show_Event_Cue` | `options` | public |
| 1291 | `Safed_Music` | — | public |
| 1325 | `Safed_Music_Fortress` | — | public |
| 1354 | `Safed_CM_Activate` | — | public |
| 1388 | `Safed_CM_Notifier` | — | public |
| 1419 | `Safed_CM_Modify_Unit_Count` | — | public |
| 1478 | `HC_Safed_IntroSetup` | — | public |
| 1523 | `HC_Safed_Intro_Purge_Physics` | — | public |
| 1530 | `HC_Safed_Intro_Intermission` | — | public |
| 1539 | `HC_Safed_IntroTeardown` | — | public |
| 1556 | `HC_Safed_IntroTeardown_Delayed` | — | public |
| 1570 | `cheatlast` | — | public |
| 1596 | `cheatgive` | — | public |

### scenarios\historical_challenges\challenge_towton\challenge_towton_obj.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `HC_Towton_InitObjectives` | — | public |
| 377 | `HC_Towton_InitStartingAttackUI` | — | public |
| 386 | `HC_Towton_InitStartingAttackUI2` | — | public |
| 399 | `HC_Towton_InitObjectiveUI` | — | public |
| 416 | `HC_Towton_BeginNewPhase` | `inPhase` | public |
| 538 | `HC_Towton_EndOldPhase` | `inPhase` | public |
| 612 | `HC_Towton_UpdateObjectiveUI` | — | public |
| 640 | `HC_Towton_PulseReinforcementsBlipNW` | — | public |
| 649 | `HC_Towton_PulseReinforcementsBlipNE` | — | public |
| 658 | `HC_Towton_PulseReinforcementsBlipSW` | — | public |
| 667 | `HC_Towton_PulseReinforcementsBlipSE` | — | public |

### scenarios\historical_challenges\challenge_towton\challenge_towton_towns.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `HC_Towton_InitTowns` | — | public |
| 228 | `HC_Towton_InitDefensiveOutposts` | — | public |
| 250 | `HC_Towton_InitBeacon` | `townIndex` | public |
| 270 | `HC_Towton_UpdateTowns` | — | public |
| 330 | `HC_Towton_UpdateTownDefenders` | — | public |
| 373 | `HC_Towton_ManorDestroyed` | `manorPosition` | public |
| 399 | `HC_Towton_LightBeacon` | `townIndex` | public |
| 469 | `HC_Towton_LightTower` | `context, data` | public |
| 490 | `HC_Towton_RevealTowerFire` | `context, data` | public |
| 508 | `HC_Towton_SpawnAlliedShip` | — | public |
| 521 | `HC_Towton_SpawnAlliedReinforcements` | `context, data` | public |
| 732 | `HC_Towton_ChangeReinforcementsOwnerSE` | — | public |
| 758 | `HC_Towton_ChangeReinforcementsOwnerSW` | — | public |
| 785 | `HC_Towton_ChangeReinforcementsOwnerS` | — | public |
| 812 | `HC_Towton_StartUnloadAlliedTransportsNW` | — | public |
| 819 | `HC_Towton_UnloadAlliedTransportsNW` | — | public |
| 850 | `HC_Towton_StartUnloadAlliedTransportsNE` | — | public |
| 857 | `HC_Towton_UnloadAlliedTransportsNE` | — | public |

### scenarios\historical_challenges\challenge_towton\challenge_towton_waves.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `HC_Towton_InitEnemyWaves` | — | public |
| 547 | `HC_Towton_DelayedStartUpdates1` | — | public |
| 553 | `HC_Towton_DelayedStartUpdates2` | — | public |
| 560 | `HC_Towton_UpdateWaveSiege` | — | public |
| 604 | `HC_Towton_UpdateWaveRaiders` | — | public |
| 756 | `HC_Towton_UpdateWaveSiegeEast` | — | public |
| 781 | `HC_Towton_UpdateWaveSiegeWest` | — | public |
| 798 | `HC_Towton_UpdateWaves` | — | public |
| 809 | `HC_Towton_PulseThreatBlip` | — | public |
| 828 | `HC_Towton_AddNewWave` | `inWaveIndex` | public |
| 1010 | `HC_Towton_AnnounceNewWave` | `context, data` | public |
| 1035 | `HC_Towton_RevealNewWave` | `context, data` | public |

### scenarios\historical_challenges\challenge_towton\challenge_towton.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_SetupVariables` | — | public |
| 65 | `Mission_SetupPlayers` | — | public |
| 95 | `Mission_SetRestrictions` | — | public |
| 100 | `ChallengeMission_SetupDiplomacy` | — | public |
| 124 | `Mission_PreInit` | — | public |
| 132 | `Mission_Preset` | — | public |
| 140 | `Mission_Start` | — | public |
| 190 | `GetRecipe` | — | public |
| 220 | `HC_Towton_SetProduction` | — | public |
| 236 | `HC_Towton_Update` | — | public |
| 434 | `HC_Towton_UpdateAgeUpHint` | — | public |
| 471 | `HC_Towton_UpdateProductionHint` | — | public |
| 499 | `HC_Towton_RevealTrebuchet` | — | public |
| 507 | `HC_Towton_UpdateEnemyWood` | — | public |
| 513 | `HC_Towton_HiddenVillagers` | — | public |
| 524 | `HC_Towton_RevealNorthBeacon` | — | public |
| 533 | `HC_Towton_RevealSouthBeacon` | — | public |
| 550 | `HC_Towton_InitStartingScouts` | — | public |
| 573 | `HC_Towton_RetreatStartingScouts` | — | public |
| 584 | `HC_Towton_RetreatStartingScouts2` | — | public |
| 596 | `HC_Towton_BlipStartingScouts` | — | public |
| 610 | `HC_Towton_RetreatLeader` | — | public |
| 618 | `HC_Towton_RetreatLeader2` | — | public |
| 625 | `HC_Towton_SpawnEnemyUnits` | — | public |
| 648 | `HC_Towton_SpawnPlayerUnits` | — | public |
| 710 | `HC_Towton_SpawnGaiaUnits` | — | public |
| 718 | `HC_Towton_OnDestruction` | `context` | public |
| 858 | `HC_Towton_OnDamaged` | `context` | public |
| 898 | `HC_Towton_OnConstructionComplete` | `context` | public |
| 915 | `HC_Towton_EndChallenge` | — | public |
| 936 | `HC_Towton_IntroSetup` | — | public |
| 956 | `HC_Towton_IntroTeardown` | — | public |

### scenarios\rogue\rogue_coastline\rogue_coastline_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `GetRecipe` | — | public |
| 22 | `Rogue_Coastline_GetCustomUnitData` | `budget, unit_types` | public |
| 30 | `Rogue_Coastline_InitUnitTables` | — | public |
| 49 | `Rogue_Coastline_SetPOIData` | — | public |

### scenarios\rogue\rogue_coastline\rogue_coastline_pirates.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Pirates_SetNavalSpawnDelay` | — | public |
| 9 | `Pirates_InitNavalRaidArmy` | — | public |
| 27 | `Pirates_InitNavalTransports` | — | public |
| 32 | `Pirates_SpawnShip` | `context, data` | public |
| 45 | `Pirates_SpawnTransportShip` | `context, data` | public |
| 61 | `Pirates_TestNavalLanding` | — | public |

### scenarios\rogue\rogue_coastline\rogue_coastline.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Rogue_Coastline_OnLoading` | — | public |
| 12 | `Rogue_Coastline_Poi_Precache` | — | public |
| 23 | `Mission_PreInit` | — | public |
| 34 | `Mission_SetupPlayers` | — | public |
| 47 | `Mission_SetupVariables` | — | public |
| 52 | `Mission_Preset` | — | public |
| 141 | `Mission_Start` | — | public |
| 146 | `Mission_Unpause` | — | public |
| 161 | `Rogue_Coastline_SpawnRelics` | — | public |
| 174 | `Rogue_Coastline_StartNavalRaids` | — | public |
| 178 | `Rogue_Coastline_SpawnFish` | — | public |
| 191 | `Rogue_Coastline_SetupSideBases` | — | public |
| 200 | `Rogue_Coastline_SetupSideBase` | `base_index` | public |
| 221 | `Rogue_Coastline_CreateBaseArmy` | `index, unit_data, marker` | public |
| 234 | `Rogue_Coastline_TestCliff` | `enemy_unit_data` | public |

### scenarios\rogue\rogue_forest\rogue_forest_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `GetRecipe` | — | public |
| 32 | `Rogue_Forest_SetPOIData` | — | public |

### scenarios\rogue\rogue_forest\rogue_forest.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Mission_PreInit` | — | public |
| 15 | `Mission_SetupPlayers` | — | public |
| 28 | `Mission_SetupVariables` | — | public |
| 32 | `Mission_Preset` | — | public |
| 119 | `Mission_Start` | — | public |
| 124 | `Mission_Unpause` | — | public |
| 128 | `Rogue_Forest_SpawnBanditCamps` | — | public |
| 163 | `Rogue_Forest_SpawnRelics` | — | public |
| 176 | `Rogue_Forest_DisableNaval` | — | public |
| 212 | `Rogue_Forest_SetupSideBases` | — | public |
| 221 | `Rogue_Forest_SetupSideBase` | `base_index` | public |
| 243 | `Rogue_Forest_CreateBaseArmy` | `index, unit_data, marker` | public |

### scenarios\rogue\rogue_japanese_daimyo\rogue_japanese_daimyo.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Mission_PreInit` | — | public |
| 15 | `Mission_SetupPlayers` | — | public |
| 28 | `Mission_Preset` | — | public |
| 84 | `Mission_PreStart` | — | public |
| 94 | `Mission_Start` | — | public |
| 100 | `Mission_Unpause` | — | public |
| 108 | `Daimyo_SpawnPickups` | `markerTable` | public |
| 120 | `Daimyo_InitUniquePOIs` | — | public |
| 142 | `InitAbandonedVillage` | `poi_instance` | public |
| 184 | `TrackAbandonedVillageCompletion` | `poi_instance` | public |
| 190 | `_trackAbandonedVillageTrap` | `context, data` | private |
| 232 | `_UpdateShinobiTargets` | `army` | private |
| 244 | `_Atmo_TransitionTo` | `context, data` | private |
| 257 | `SpawnSites` | — | public |
| 331 | `ValidateOnlyCavalry` | `wave_template` | public |
| 346 | `ValidateOnlyMeleeInfantry` | `wave_template` | public |
| 362 | `ValidateOnlyRangedInfantry` | `wave_template` | public |
| 375 | `ShinobiShrine` | — | public |
| 384 | `_monitorShinobiSecrets` | — | private |
| 405 | `_monitorSecretShinobi` | — | private |
| 420 | `_staySecret` | — | private |
| 426 | `Spawn_Shinobi` | — | public |
| 455 | `GetRecipe` | — | public |

### scenarios\rogue\rogue_mongol_steppe\rogue_mongol_steppe_raiders.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Steppe_InitializeRaiders` | — | public |
| 79 | `Steppe_UnpauseRaiders` | — | public |
| 89 | `Steppe_MonitorRaiders` | — | public |
| 101 | `Steppe_SpawnRaider` | — | public |
| 124 | `Steppe_RegroupRaidAttackers` | — | public |
| 131 | `Steppe_RegroupRaidDefenders` | — | public |
| 138 | `Steppe_Attack` | — | public |
| 154 | `Steppe_GetRaidTargets` | — | public |
| 181 | `Steppe_WarnAboutRaiders` | `context, data` | public |
| 194 | `Steppe_MonitorRaidUI` | `context, data` | public |
| 214 | `Steppe_CheckForIdleRaiders` | — | public |
| 224 | `Steppe_RecoverIdleRaiders` | — | public |

### scenarios\rogue\rogue_mongol_steppe\rogue_mongol_steppe.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Mission_PreInit` | — | public |
| 15 | `Mission_SetupPlayers` | — | public |
| 28 | `Mission_Preset` | — | public |
| 63 | `Mission_Start` | — | public |
| 67 | `Mission_Unpause` | — | public |
| 72 | `GetRecipe` | — | public |
| 92 | `SortMarkersByDistance` | `mkr_1, mkr_2` | public |
| 98 | `Steppe_SpawnSites` | — | public |
| 203 | `Steppe_DeleteSheep` | — | public |
| 219 | `Steppe_SpawnGuards` | — | public |
| 232 | `Steppe_SpawnGuard` | `name, targetOrder` | public |
| 246 | `Steppe_GetGuardUnits` | — | public |
| 263 | `ValidateContainsCavalry` | `wave_template` | public |

### scenarios\rogue\rogue_stamps\rogue_stamps.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Mission_PreInit` | — | public |
| 14 | `Mission_SetupPlayers` | — | public |
| 27 | `Mission_Preset` | — | public |
| 35 | `Mission_PreStart` | — | public |
| 39 | `Mission_Start` | — | public |
| 48 | `Mission_Unpause` | — | public |
| 52 | `SpawnSites` | — | public |
| 74 | `GetRecipe` | — | public |

### scenarios\rogue\rogue_system_test\rogue_system_test_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `GetRecipe` | — | public |
| 18 | `RogueTest_InitChampionData` | — | public |
| 32 | `RogueTest_InitBossData` | — | public |

### scenarios\rogue\rogue_system_test\rogue_system_test.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Mission_PreInit` | — | public |
| 15 | `Mission_SetupPlayers` | — | public |
| 28 | `Mission_Preset` | — | public |
| 47 | `Mission_Start` | — | public |
| 55 | `Mission_Unpause` | — | public |
| 60 | `KillEnemyUnits` | — | public |
| 66 | `KillUnitsNearWonder` | `context, data` | public |
| 73 | `SpawnSites` | — | public |
| 95 | `RogueTest_SpawnChampions` | `name1, name2, custom_units1, custom_units2` | public |
| 126 | `RogueTest_SpawnAllChampions` | — | public |
| 135 | `RogueTest_SpawnBoss` | `shortname, set_player_army, unit_count_multiplier, custom_enemy_units` | public |
| 188 | `RogueTest_SpawnAllBosses` | — | public |

### scenarios\ugc_map\obj_capture_town.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Capture_EnemiesTownInit` | — | public |
| 50 | `CaptureTown_OnComplete` | — | public |
| 54 | `ObjectiveCompleteNow` | — | public |

### scenarios\ugc_map\obj_destroy_town.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `DestroyTown_InitObjectives` | — | public |
| 20 | `DestroyBuildings_UI` | — | public |
| 31 | `DestroyBuildings_Start` | — | public |
| 38 | `DefeatBuildings_OnEntityKilled` | `context` | public |
| 60 | `DestroyBuildings_OnComplete` | — | public |
| 66 | `MissionCompleteDelayed` | — | public |

### scenarios\ugc_map\ugc_map.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `Mission_SetupPlayers` | — | public |
| 38 | `Mission_SetupVariables` | — | public |
| 52 | `Mission_SetRestrictions` | — | public |
| 60 | `Mission_Preset` | — | public |
| 77 | `Mission_Start` | — | public |
| 85 | `GetRecipe` | — | public |

## gameplay

### ai\ai_encounter_util.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `AIFormationPhaseEncounter_EndReason_ToString` | `reason` | public |
| 32 | `AIFormationPhaseEncounter_NotificationType_ToString` | `notification_type` | public |

### ai\army_encounter.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `army_encounter_fatal` | `msg` | public |
| 11 | `ArmyEncounter_InitSystem` | — | public |
| 26 | `ArmyEncounterChild:new` | `o, encounterID, callbackID` | public |
| 55 | `ArmyEncounterFamily:new` | `o, army, stateModels` | public |
| 74 | `ArmyEncounterFamily:start` | — | public |
| 94 | `ArmyEncounterFamily:getIdentifier` | — | public |
| 98 | `ArmyEncounterFamily:addChild` | `encounterID` | public |
| 103 | `ArmyEncounterFamily:removeChild` | `childIdx` | public |
| 109 | `ArmyEncounterFamily:areAllDone` | — | public |
| 113 | `ArmyEncounterFamily:findChild` | `callbackID` | public |
| 125 | `ArmyEncounterFamily:promoteChild` | — | public |
| 141 | `ArmyEncounterFamily:markDone` | `callbackID` | public |
| 153 | `ArmyEncounterFamily:stop` | — | public |
| 175 | `ArmyEncounterFamily:stopSingleEncounter` | `player, encounterID` | public |
| 201 | `ArmyEncounterFamily:addAndTriggerParentOrChild` | `isChild, squadsToUse` | public |
| 252 | `ArmyEncounterFamily:cleanUpTemporaryGlobalData` | — | public |
| 275 | `ArmyEncounterFamily.GetID` | — | public |
| 283 | `ArmyEncounterFamily.FindFamilyAndEncounterID` | `callbackID` | public |
| 298 | `ArmyEncounterFamily_NotificationFromStateTree` | `context` | public |

### ai\army.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `army_fatal` | `msg` | public |
| 17 | `Army_InitSystem` | — | public |
| 145 | `Army_FindFromName` | `name` | public |
| 153 | `Army_FindArmyFromSquad` | `squad` | public |
| 165 | `NavalArmy_Init` | `army_params` | public |
| 216 | `Army_Init` | `army_params` | public |
| 336 | `Army_Dissolve` | `army, returned_sgroup` | public |
| 370 | `Army_AddSGroup` | `army, sgroup` | public |
| 395 | `Army_RemoveSGroup` | `army, sgroup, callback, data` | public |
| 423 | `Army_GetMissingUnits` | `army` | public |
| 433 | `Army_GetSGroup` | `army` | public |
| 441 | `Army_GetSquads` | `army, sgroup` | public |
| 452 | `Army_GetTargetIndex` | `army` | public |
| 456 | `Army_GetTarget` | `army` | public |
| 462 | `Army_SetTarget` | `army, target` | public |
| 487 | `Army_SetTargets` | `army, targets` | public |
| 502 | `Army_AddTarget` | `army, target` | public |
| 528 | `Army_AddTargets` | `army, targets` | public |
| 538 | `Army_IsComplete` | `army` | public |
| 544 | `Army_IsDead` | `army` | public |
| 550 | `Army_IsAttacking` | `army` | public |
| 556 | `Army_IsDefending` | `army` | public |
| 562 | `Army_IsBlocked` | `army` | public |
| 570 | `_Army_GenerateID` | — | private |
| 576 | `_Army_InitializeEnRouteAndAtTargetParams` | `army_or_combat_arena` | private |
| 588 | `_Army_MoveCombatArenaParamsIntoSubTable` | `army` | private |
| 605 | `_Army_GetDefaultValues` | `army` | private |
| 620 | `_Army_InitializeTargets` | `army` | private |
| 644 | `_Army_ResolveCombatArena` | `army, combat_arena` | private |
| 680 | `_Army_ValidateCombatArena` | `army, combatArena` | private |
| 685 | `_Army_GetCombatArenaString` | `combatArena` | private |
| 698 | `_Army_CheckIfDead` | `army` | private |
| 706 | `_Army_Death` | `army` | private |
| 741 | `_Army_Revive` | `army` | private |
| 762 | `_Army_Blocked` | `army` | private |
| 776 | `_Army_Victory` | `army` | private |
| 803 | `_Army_Complete` | `army` | private |
| 835 | `_Army_GetNextTargetIndex` | `army, currentTargetIndex` | private |
| 868 | `_Army_GetRandomTargetIndex` | `army, currentTargetIndex` | private |
| 885 | `_Army_UpdateStatus` | `army` | private |
| 915 | `_Army_DefendSpawn` | `army` | private |
| 930 | `_Army_DefendTarget` | `army, targetIndex` | private |
| 946 | `_Army_DefendCurrentPosition` | `army` | private |
| 962 | `_Army_NavalTransport` | `army, targetIndex` | private |
| 998 | `_Army_DefendCombatArena` | `army, combatArena` | private |
| 1035 | `_Army_AttackTarget` | `army, targetIndex` | private |
| 1083 | `_Army_CreateCommonStateModels` | `army, target, branchName` | private |
| 1197 | `_Army_RestartEncounterFamily` | `army` | private |
| 1218 | `_Army_NotificationFromEncounterFamily` | `army, notificationType, encounterStage` | private |
| 1305 | `_Army_NewVariableAssignment` | `army, variable, value` | private |
| 1319 | `_Army_VariableLookupFailed` | `t, k` | private |
| 1323 | `_Army_CombatArenaParamLookupFailed` | `t, k` | private |

### ai\combat_fitness_util.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `notify` | `contextDataTable` | public |
| 9 | `LaunchEncounter` | `player, squads, position` | public |
| 88 | `LaunchSimpleAttackMove` | `player, squads, position` | public |
| 92 | `LaunchSimpleAbility` | `squads, ability, target` | public |
| 96 | `LaunchFireShipAbility` | `squads, target` | public |
| 113 | `EGroup_GetTotalHealthFromCanBeDamagedOnly` | `egroupid` | public |
| 128 | `TotalHealthOfPlayer` | `player` | public |
| 143 | `FightIsFinished` | `player1, player2, healthHistory, damageTimeout` | public |
| 166 | `AppendHealthHistory` | `player, history` | public |
| 171 | `HistoryLength` | `healthHistory` | public |
| 184 | `DamagedInLastPeriod` | `period, healthHistory, currentHealth` | public |
| 201 | `SGroup_CanTargetSGroup` | `attackGroup, targetGroup` | public |
| 223 | `SGroup_CanTargetEGroup` | `attackGroup, targetGroup` | public |
| 245 | `ComputeScore` | `initialA, initialB, finalA, finalB` | public |
| 263 | `ContainsAnyFilterWord` | `word, filterList` | public |
| 273 | `ContainsAllFilterWord` | `word, filterList` | public |
| 283 | `CreateSpawnCombination` | `spawnPossibilities, onlyOneAllowedWords, spawnSize, chunkLimit, onlyOneUnitType, distribution` | public |
| 339 | `PrintSpawnCombination` | `label, combination, printFunc` | public |
| 424 | `CreateBuildingCombination` | `player, maxNumBuildings` | public |
| 440 | `PrintBuildingCombination` | `combination, printFunc` | public |
| 450 | `SpawnBuildings` | `player, buildingCombination, buildingPositions, damagedChance1In, optionalTowardsPosition` | public |
| 479 | `CreateAndSpawnSquad` | `pbg, player, pos, posToward, loadedPBGNames` | public |
| 493 | `SpawnCombination` | `player, pos, combination, damagedChance1In, loadedPBGNames` | public |
| 521 | `GenUpgradeCombination` | `potentialUpgrades, numUpgrades, unitCombination, buildingCombination` | public |
| 671 | `ApplyPlayerUpgrades` | `player, upgrades` | public |
| 677 | `GetAllBPs` | `BPType, filter` | public |
| 700 | `GenerateBPOptions` | `BPType, allowedRaces, filterWords, chosenWords` | public |
| 755 | `FilterBPOptions` | `spawnPossibilities, requiredWords` | public |
| 772 | `GenerateArchetypeMapping` | `spawnPossibilities` | public |
| 844 | `SelectArchetypeMapping` | `archetypeMap, archetypeFilterWords` | public |
| 857 | `CleanupPlayer` | `player` | public |
| 871 | `Cleanup` | `player1, player2` | public |
| 878 | `CalcOneVOneSquadFitness` | `teamAPlayer, teamBPlayer, teamAPBGName, teamBPBGName` | public |
| 886 | `CalcNVNSquadFitness` | `teamAPlayer, teamBPlayer, teamAPBGName, teamANum, teamBPBGName, teamBNum` | public |
| 900 | `TestCharacterization` | `player1, player2, filterList, stdPrint, failurePrint` | public |

### ai\wave_generator.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `WaveGenerator_InitSystem` | — | public |
| 59 | `WaveGenerator_OverrideUnitBuildTime` | `type, time` | public |
| 67 | `WaveGenerator_OverrideBuildingSpawnType` | `building_type, categories` | public |
| 74 | `WaveGenerator_MonitorAll` | — | public |
| 80 | `WaveGenerator_FindWave` | `name` | public |
| 104 | `WaveGenerator_Init` | `data` | public |
| 166 | `WaveGenerator_SetUnits` | `wg, units` | public |
| 176 | `WaveGenerator_SetSpawn` | `wg, spawn` | public |
| 186 | `WaveGenerator_Pause` | `wg` | public |
| 190 | `WaveGenerator_Unpause` | `wg` | public |
| 197 | `WaveGenerator_AddUnits` | `wg, units` | public |
| 218 | `WaveGenerator_Prepare` | `wg, sg_custom, data` | public |
| 284 | `WaveGenerator_Launch` | `wg, index` | public |
| 318 | `WaveGenerator_LaunchOneShot` | `context, data` | public |
| 334 | `WaveGenerator_Monitor` | `wg` | public |
| 377 | `WaveGenerator_SpawnUnits` | `wg, spawn` | public |
| 399 | `WaveGenerator_GetUnitRowForSpawn` | `wg, spawn, wave` | public |
| 410 | `WaveGenerator_UpdateSpawnAndUnitRow` | `wg, spawn, unit_row, row_position_index, wave_index` | public |
| 422 | `WaveGenerator_AnyUnitNeedsTraining` | `wg` | public |
| 443 | `WaveGenerator_GetSpawnableCategories` | `wg` | public |
| 457 | `WaveGenerator_SpawnUnitsIntoArmy` | `wg, units, army, spawnLocation, sg_staging, sg_custom, spawningIntoStagingArmy` | public |
| 485 | `ArrayContainsValue` | `array, value` | public |
| 493 | `WaveGenerator_ValidateSpawns` | `wg` | public |
| 502 | `WaveGenerator_ValidateWave` | `wg, wave_index` | public |
| 509 | `WaveGenerator_InitSpawns` | `wg` | public |
| 529 | `WaveGenerator_RefreshSpawns` | `wg` | public |
| 562 | `WaveGenerator_AddBuildings` | `wg, egroup` | public |
| 584 | `WaveGenerator_FilterUnitsByDifficulty` | `units` | public |
| 602 | `WaveGenerator_GetUnitTypeFromUnitRow` | `unitRow` | public |

### autotest.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 41 | `Autotest_SpawnFromTable` | `player, spawnTable, sgroup, spawnPoint, moveDest, isAttackMove` | public |
| 53 | `Autotest_SpawnSingleSquad` | `player, sgroup, bluePrint, spawnPoints, moveDests, isAttackMove` | public |

### campaignpanel.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 19 | `CampaignPanel_Init` | — | public |
| 116 | `TributePanel_Init` | `callbackFunction` | public |
| 128 | `TributePanel_Create` | `owner, recipientPlayers, allowedResourceTypes, taxRate` | public |
| 186 | `TributePanel_Enable` | `owner` | public |
| 208 | `TributePanel_Disable` | `owner` | public |
| 235 | `TributePanel_IsEnabled` | — | public |
| 245 | `TributePanel_Open` | `owner` | public |
| 261 | `TributePanel_Close` | `owner` | public |
| 278 | `TributePanel_IsOpen` | — | public |
| 293 | `TributePanel_AddRecipient` | `owner, recipient, allowedResourceTypes` | public |
| 343 | `TributePanel_RemoveRecipient` | `owner, recipient` | public |
| 374 | `TributePanel_EnableResourceType` | `owner, recipient, resourceType` | public |
| 418 | `TributePanel_DisableResourceType` | `owner, recipient, resourceType, reason` | public |
| 469 | `TributePanel_SetSortFunction` | `owner, newSortFunction` | public |
| 484 | `_TributePanel_SortItems` | — | private |
| 492 | `_TributePanel_DefaultSortFunction` | `a, b` | private |
| 501 | `_TributePanel_CreateRecipientPlayerData` | `player, allowedResourceTypes` | private |
| 551 | `_TributePanel_IncreaseTribute_ButtonCallback` | `commandParameter` | private |
| 595 | `_TributePanel_DecreaseTribute_ButtonCallback` | `commandParameter` | private |
| 624 | `_TributePanel_UpdateTotals` | — | private |
| 646 | `_TributePanel_Send_ButtonCallback` | — | private |
| 707 | `_TributePanel_Send_ReceieveNetworkMessage` | `sendingPlayer, message` | private |
| 791 | `_TributePanel_Clear_ButtonCallback` | — | private |
| 807 | `_TributePanel_TransferResources` | `sendingPlayer, receivingPlayer, resourceType, amount, taxRate` | private |
| 825 | `_TributePanel_ShowEventCue` | `message` | private |
| 851 | `ReinforcementPanel_Init` | `callbackFunction` | public |
| 863 | `ReinforcementPanel_Create` | `owner, panelData` | public |
| 910 | `ReinforcementPanel_Enable` | `owner` | public |
| 933 | `ReinforcementPanel_Disable` | `owner` | public |
| 960 | `ReinforcementPanel_IsEnabled` | — | public |
| 971 | `ReinforcementPanel_Open` | `owner` | public |
| 988 | `ReinforcementPanel_Close` | `owner` | public |
| 1005 | `ReinforcementPanel_IsOpen` | — | public |
| 1020 | `ReinforcementPanel_AddItem` | `owner, newItem` | public |
| 1056 | `ReinforcementPanel_RemoveItem` | `owner, id` | public |
| 1077 | `ReinforcementPanel_Update` | `owner, updateData` | public |
| 1094 | `ReinforcementPanel_UpdateItem` | `owner, id, updateData` | public |
| 1116 | `_ReinforcementPanel_ApplyUpdates` | `oldData, newData` | private |
| 1131 | `ReinforcementPanel_DisableItem` | `owner, id, reason` | public |
| 1155 | `ReinforcementPanel_EnableItem` | `owner, id` | public |
| 1180 | `ReinforcementPanel_SetSortFunction` | `owner, newSortFunction` | public |
| 1195 | `_ReinforcementPanel_SortItems` | — | private |
| 1203 | `_ReinforcementPanel_DefaultSortFunction` | `a, b` | private |
| 1223 | `_ReinforcementPanel_BuyItem_ButtonCallback` | `id` | private |
| 1268 | `_ReinforcementPanel_BuyItem_ReceieveNetworkMessage` | `sendingPlayer, message` | private |
| 1337 | `_CampaignPanel_IsLocalPlayer` | `player` | private |
| 1356 | `_CampaignPanel_Toggle` | — | private |
| 1367 | `_CampaignPanel_SetToggleButtonTooltip` | — | private |
| 1385 | `_CampaignPanel_OnUpgradeComplete` | `context` | private |
| 1410 | `_CampaignPanel_OnPlayerNameChanged` | `context` | private |
| 1425 | `_CampaignPanel_OnGameRestore` | — | private |
| 1439 | `_CampaignPanel_LocalizeAllStrings` | `data` | private |
| 1455 | `_CampaignPanel_SetValue` | `table, key, newValue` | private |
| 1473 | `_CampaignPanel_SetDirty` | `forceUpdateNow` | private |
| 1485 | `_CampaignPanel_Manager` | — | private |
| 1584 | `_CampaignPanel_UpdateDataContext` | `force` | private |
| 1597 | `_CampaignPanel_CreateUI` | — | private |
| 1613 | `_CampaignPanel_CreateUI_PC` | — | private |
| 2397 | `_CampaignPanel_CreateUI_Xbox` | — | private |

### cardinal_encounter.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 19 | `cardinal_encounter_fatal` | `msg` | public |
| 35 | `EncounterFamily:new` | `o, parentID, callbackID` | public |
| 42 | `EncounterChild:new` | `o, childEnc, callback` | public |
| 49 | `EncounterFamily:addChild` | `encounterID` | public |
| 54 | `EncounterFamily:removeChild` | `childIdx` | public |
| 60 | `EncounterFamily:areAllDone` | — | public |
| 64 | `EncounterFamily:findChild` | `callbackID` | public |
| 76 | `EncounterFamily:promoteChild` | — | public |
| 95 | `EncounterFamily:markDone` | `callbackID` | public |
| 109 | `EncounterFamily:hasCallbackID` | `callbackID` | public |
| 124 | `_CardinalEncounter_AINotificationCallback` | `context` | private |
| 317 | `_CardinalEncounter_AddAndTriggerChildToExistingFamily` | `refCallbackID, squadsToUse` | private |
| 513 | `Cardinal_CleanupAIEncounter` | `encounter` | public |
| 550 | `_Cardinal_CleanUpTemporaryGlobalDataForEncounterFamily` | `family` | private |

### cardinal_narrative.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `SGroup_EnableCheering` | `sgroup, enable, duration, walla, audioDelay` | public |
| 59 | `_CheerTimeOut` | `context, data` | private |
| 67 | `_CheerTriggerWalla` | `context, data` | private |
| 74 | `_CheerGetInterval` | `walla` | private |
| 90 | `_CheerStop` | `sgroup` | private |
| 116 | `SGroup_EnableLeaderCrown` | `sgroup, enable` | public |
| 123 | `_EnableCrown` | `context, data` | private |
| 146 | `_QuickDelay` | `seconds` | private |
| 153 | `_QuickShowAll` | — | private |
| 159 | `_QuickHideAll` | — | private |
| 175 | `Mission_EnableAbilities` | `data, enable` | public |
| 249 | `MissionOMatic_ShowTitleCard` | — | public |
| 272 | `Action_SkipNIS` | — | public |
| 279 | `Action_SkipNIS_Outro` | — | public |
| 291 | `Util_UnitParade` | `marker_table, unit_table, parade_sgroup, delay, player` | public |
| 328 | `__SendParadeUnits` | `context, data` | private |
| 353 | `AddVectorToPosition` | `position, vector` | public |
| 357 | `MultiplyVectorByFloat` | `vector, float` | public |
| 361 | `ReverseVector` | `vector` | public |
| 369 | `GenerateSpacialDataForRows` | `marker, row_count, row_spacing, direction` | public |
| 399 | `Util_UnitParadeGrid` | `spawn, targets, unit_type, column_count, row_count, row_spacing, sgroup, delay, player` | public |
| 465 | `Util_UnitParadeGrid_Delay` | `context, data` | public |
| 481 | `Util_EnableCardinalCinematicMode` | `enable, camera_type, Keep_gampelayunits_forOutro, fowUnRevealDelay, shouldKeepXboxHidden` | public |
| 563 | `__UnRevealEntities` | — | private |
| 572 | `SGroup_PlaySpeech` | `sgroup, filepath` | public |
| 586 | `Util_ClearSquadsForCine` | — | public |
| 661 | `Util_CorpseField` | `units_table, spawnlocation, cleanlocation` | public |
| 725 | `Util_ApplyNarrativeHorseSpeedModifiers` | `enable` | public |
| 818 | `Util_PlayCameras` | `cameraData, optCamType` | public |
| 936 | `Util_AdjustCaptureCameraPanToEndAtDefault` | `spline, pos` | public |
| 984 | `SGroup_ReynaldFallToKnees` | `sgroup` | public |

### cardinal.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 320 | `Objective_MapOldStyleToNewStyle` | `oldStyle` | public |
| 350 | `cardinal_alert` | `msg` | public |
| 388 | `DebugMessageUI_ButtonClicked` | `button` | public |
| 415 | `Project_OnGameSetup` | — | public |
| 421 | `Project_Preset` | — | public |
| 427 | `Project_InitComplete` | — | public |
| 461 | `Project_Start` | — | public |
| 486 | `Project_ActivateMenuItem` | `mode, value` | public |
| 501 | `Project_StartWithCheat` | `mode, value` | public |
| 522 | `OnReplayStingerEnded` | `stingerId` | public |
| 531 | `Project_PreGameOver` | `reason` | public |
| 545 | `Project_OnGameOver` | — | public |
| 549 | `OnStingerEnded` | `stingerId` | public |
| 555 | `_gameOver_message` | `id, data` | private |
| 609 | `Player_GetCurrentAge` | `playerID` | public |
| 626 | `Player_SetCurrentAge` | `playerID, age` | public |
| 673 | `Player_SetMaximumAge` | `playerID, maximumAge` | public |
| 809 | `Player_GetMaximumAge` | `playerID` | public |
| 818 | `Player_SetMutualRelationships` | `players, relationshipStatus` | public |
| 857 | `Cmd_FormationMove` | `sgroup, destination, queued, deleteOnArrival, facingPosition` | public |
| 889 | `Cmd_FormationStop` | `sgroup` | public |
| 907 | `Cmd_FormationMoveToAndDestroy` | `sgroupid, markerid, queued, facingPosition, callback, callbackData` | public |
| 925 | `Cmd_FormationAttackMove` | `sgroupid, destination, queued, deleteOnArrival, deleteCallback, deleteCallbackData` | public |
| 959 | `Setup_BroadcastInit` | — | public |
| 970 | `Setup_ListenForBroadcast` | — | public |
| 981 | `Setup_BroadcastMessageToAll` | `message` | public |
| 989 | `Setup_BroadcastMessageToAllExceptPlayer` | `message, exceptPlayer` | public |
| 999 | `Setup_BroadcastMessageToAllExceptTeam` | `message, exceptTeam` | public |
| 1009 | `Setup_BroadcastMessageToAllExceptTeams` | `message, exceptTeams` | public |
| 1021 | `Setup_BroadcastMessageToPlayer` | `player, message` | public |
| 1031 | `Setup_BroadcastMessageToTeam` | `team, message` | public |
| 1039 | `Setup_BroadcastMessageToTeamExceptPlayer` | `team, message, exceptPlayer` | public |
| 1060 | `Project_UnitEntry_PreprocessDeployment` | `deployment` | public |
| 1122 | `Project_UnitEntry_StartDeployment` | `deployment` | public |
| 1190 | `Project_UnitEntry_SpawnUnit` | `unit, deployment` | public |
| 1204 | `Project_UnitEntry_SpawnUnit_Finish` | `unit, deployment` | public |
| 1216 | `Project_UnitEntry_EndDeployment` | `deployment` | public |
| 1278 | `_EndDeployment_DelayedMove` | `context, data` | private |
| 1299 | `SGroup_FormationWarpToMarker` | `sgroup, marker, facing` | public |
| 1312 | `SGroup_FormationWarpToPos` | `sgroup, pos, facing` | public |
| 1346 | `Cardinal_ConvertTypeToSquadBlueprint` | `typeList, player, returnAsTable` | public |
| 1416 | `Cardinal_ConvertTypeToEntityBlueprint` | `typeList, player, returnAsTable` | public |
| 1484 | `Cardinal_TypeToBlueprint_Init` | — | public |
| 1550 | `Cardinal_TypeToBlueprint_CacheSquadBlueprints` | `unitTypes` | public |
| 1634 | `Cardinal_TypeToBlueprint_CacheEntityBlueprints` | `unitTypes` | public |
| 1720 | `Cardinal_TypeToBlueprint_GenerateTypeIndexString` | `unitTypes` | public |
| 1739 | `Cardinal_TypeToBlueprint_GetAgeData` | `item` | public |
| 1777 | `Cardinal_TypeToBlueprint_GetCivData` | `item` | public |
| 1821 | `Cardinal_EnablePartialXboxUI` | `b_enable, t_flagsToIgnore` | public |
| 1883 | `printColumns` | `items` | public |

### core_encounter.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Project_RegisterEncounterPlans` | — | public |
| 48 | `Encounter_Init` | — | public |
| 72 | `Encounter_Init_PartB` | — | public |
| 78 | `Encounter_RestartAll` | — | public |
| 101 | `Encounter_EnableDebug` | `enable` | public |
| 113 | `Encounter_Create` | `player, group, goal, debugName` | public |
| 199 | `_ResetID` | `encounter` | private |
| 217 | `Encounter_GetSGroup` | `encounter` | public |
| 229 | `Encounter_AddSquad` | `encounter, squad, restartIfNecessary` | public |
| 238 | `Encounter_AddSGroup` | `encounter, sgroup, restartIfNecessary` | public |
| 274 | `Encounter_RemoveSquad` | `encounter, squad` | public |
| 282 | `Encounter_RemoveAllSquads` | `encounter` | public |
| 288 | `Encounter_RemoveSGroup` | `encounter, sgroup` | public |
| 316 | `Encounter_SetGoalData` | `encounter, newGoal` | public |
| 350 | `Encounter_GetGoalData` | `encounter` | public |
| 359 | `Encounter_Stop` | `encounter, giveStopCommandToUnits` | public |
| 374 | `Encounter_Start` | `encounter` | public |
| 386 | `Encounter_Restart` | `encounter` | public |
| 401 | `Encounter_IsActive` | `encounter` | public |
| 412 | `Encounter_GetAIEncounter` | `encounter` | public |
| 422 | `Encounter_DoAction` | — | public |
| 439 | `Encounter_FindAssociatedEncounter` | `item` | public |
| 482 | `Encounter_RegisterPlan` | `plan` | public |
| 520 | `_Encounter_BeginStartPhase` | `encounter` | private |
| 548 | `_CheckForSquads` | `context, data` | private |
| 559 | `_Encounter_TransitionToPhase` | `encounter, newPhase, options` | private |
| 577 | `_Encounter_Finish` | `encounter, giveStopCommandToUnits, callbackName, callbackData` | private |
| 606 | `_Encounter_EndCurrentPhase` | `encounter` | private |
| 635 | `Encounter_BeginNewPhase` | `encounter, newPhase, options` | public |
| 658 | `_Encounter_RestartCurrentPhase` | `encounter` | private |
| 666 | `_Encounter_GetCurrentPhase` | `encounter` | private |
| 674 | `_Encounter_AINotificationCallback` | `context` | private |
| 730 | `_Encounter_FindPlan` | `name` | private |
| 743 | `_Encounter_TriggerCallback` | `encounter, callbackName, callbackData` | private |
| 754 | `_MergeGoalData` | `data, defaults, errorList, prefix, encName` | private |
| 789 | `AIEncounter_TargetGuidance_SetTarget` | `aiEncounter, thing, closestTo` | public |
| 827 | `CoreEncounter_DebugEncounter` | `item` | public |
| 849 | `CoreEncounter_DebugAIModule` | `item` | public |
| 871 | `CoreEncounter_GetVerboseDebugName` | `scarEncounter` | public |

### designerlib.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 23 | `Table_GetRandomItem` | `thistable, num` | public |
| 66 | `Table_GetRandomItemWeighted` | `thistable` | public |
| 91 | `Table_GetRandomItemWeighted_Deterministic` | `thistable` | public |
| 114 | `Table_Contains` | `table_id, item` | public |
| 137 | `Table_Copy` | `temp` | public |
| 157 | `Table_MakeReadOnly` | `table, recursive, errorMessage` | public |
| 183 | `Player_GetSquadsOnscreen` | `player, sgroup` | public |
| 204 | `Player_GetProductionQueueSize` | `player` | public |
| 222 | `Resources_Disable` | `player` | public |
| 247 | `Resources_Enable` | `player` | public |
| 272 | `Are_Resources_Disabled` | `player` | public |
| 289 | `Debug_ScartypeToString` | `object` | public |
| 333 | `EGroup_SetOnFire` | `egroup` | public |
| 346 | `EGroup_SetStayBurningWhileInvulnerable` | `egroup, stayBurning` | public |
| 356 | `SGroup_Split` | `sourceSGroup, numNewSGroups` | public |
| 392 | `SGroup_SplitIntoExistingSGroups` | `sourceSGroup, sgroupTable, clearSGroups` | public |
| 413 | `SGroup_SplitUnderCap` | `sourceSGroup, maxSGroupSize` | public |
| 428 | `SGroup_GetClosestSquads` | `sgroup, count, position` | public |
| 469 | `SGroup_SetTargetingType` | `sgroup, targetingType` | public |
| 488 | `Squad_IsPatrolling` | `squad` | public |
| 501 | `Position_GetAverage` | `positionTable` | public |

### encounterplans\plan_attack.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `AttackPlan_RegisterPlan` | — | public |
| 41 | `AttackPlan_ProcessGoalData` | `goal, encounter` | public |
| 72 | `AttackPlan_MainPhase_Start` | `encounter, options` | public |
| 253 | `AttackPlan_MainPhase_Notification` | `encounter, context` | public |
| 378 | `AttackPlan_MainPhase_End` | `encounter` | public |

### encounterplans\plan_defend.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `DefendPlan_RegisterPlan` | — | public |
| 52 | `DefendPlan_ProcessGoalData` | `goal, encounter` | public |
| 74 | `DefendPlan_Start` | `encounter` | public |
| 87 | `DefendPlan_IdlePhase_Start` | `encounter, options` | public |
| 99 | `DefendPlan_IdlePhase_SpottedPlayer` | `data` | public |
| 105 | `DefendPlan_IdlePhase_Monitor` | `context, data` | public |
| 129 | `DefendPlan_IdlePhase_DelayedReaction` | `context, data` | public |
| 146 | `DefendPlan_IdlePhase_End` | `encounter` | public |
| 160 | `DefendPlan_MainPhase_Start` | `encounter, options` | public |
| 330 | `DefendPlan_MainPhase_Notification` | `encounter, context` | public |
| 493 | `DefendPlan_MainPhase_End` | `encounter` | public |

### encounterplans\plan_donothing.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `DoNothingPlan_RegisterPlan` | — | public |
| 40 | `DoNothingPlan_MainPhase_Start` | `encounter, options` | public |
| 48 | `DoNothingPlan_MainPhase_End` | `encounter` | public |

### encounterplans\plan_move.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `MovePlan_RegisterPlan` | — | public |
| 54 | `MovePlan_ProcessGoalData` | `goal, encounter` | public |
| 77 | `MovePlan_Start` | `encounter` | public |
| 108 | `MovePlan_FormUpPhase_Start` | `encounter, options` | public |
| 147 | `MovePlan_FormUpPhase_Notification` | `encounter, context` | public |
| 161 | `MovePlan_FormUpPhase_End` | `encounter` | public |
| 175 | `MovePlan_MovePhase_Start` | `encounter, options` | public |
| 222 | `MovePlan_MovePhase_Notification` | `encounter, context` | public |
| 274 | `MovePlan_MovePhase_End` | `encounter` | public |
| 293 | `MovePlan_InterceptPhase_Start` | `encounter, options` | public |
| 340 | `MovePlan_InterceptPhase_Notification` | `encounter, context` | public |
| 355 | `MovePlan_InterceptPhase_End` | `encounter` | public |

### encounterplans\plan_townlife.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `TownLifePlan_RegisterPlan` | — | public |
| 45 | `TownLifePlan_MainPhase_Start` | `encounter, options` | public |
| 71 | `TownLifePlan_MainPhase_End` | `encounter` | public |

### game_modifiers.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 64 | `Modifier_InitGame` | — | public |
| 87 | `Modify_FoodGatherRate` | `group, factor, usage` | public |
| 113 | `Modify_WoodGatherRate` | `group, factor, usage` | public |
| 139 | `Modify_GoldGatherRate` | `group, factor, usage` | public |
| 165 | `Modify_StoneGatherRate` | `group, factor, usage` | public |
| 191 | `Modify_FoodCarryCapacity` | `group, factor, usage` | public |
| 217 | `Modify_WoodCarryCapacity` | `group, factor, usage` | public |
| 243 | `Modify_GoldCarryCapacity` | `group, factor, usage` | public |
| 269 | `Modify_StoneCarryCapacity` | `group, factor, usage` | public |
| 298 | `Modify_PlayerPopCap` | `player, amount, usage` | public |
| 314 | `Modify_UnitSpeedWhenNotInCombat` | `sgroup, factor, usage` | public |
| 340 | `Remove_UnitSpeedInCombatModifier` | `sgroup` | public |
| 353 | `UnitSpeedNotInCombat_Manager` | `context, data` | public |
| 388 | `Modify_UnitSpeedUntilInCombat` | `sgroup, factor, usage` | public |
| 419 | `UnitSpeedUntilInCombat_Manager` | `context, data` | public |
| 461 | `UnitSpeedUntilInCombat_Exit` | `group_data` | public |
| 471 | `Remove_UnitSpeedUntilInCombatModifier` | `sgroup` | public |
| 487 | `Modify_PlayerMaxPopCap` | `player, amount, usage` | public |

### gamefunctions.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 2 | `_Game_Init` | — | private |
| 52 | `Util_CinematicKill` | `killer, target, melee` | public |
| 57 | `_cinematicKill` | `id, data` | private |
| 100 | `_idleBehaviour_queue` | `squadTable` | private |
| 108 | `_idleBehaviour_start` | `id, dataTable` | private |
| 159 | `_idleBehaviour_stop` | `data` | private |
| 169 | `RegisterHintPopup` | `HUDFeature, text, icon, duration` | public |
| 184 | `UnRegisterHintPopup` | — | public |
| 193 | `_MonitorHintPopup` | — | private |
| 209 | `SpeechBubble_AlliedHack` | `sgroup` | public |
| 296 | `SpeechBubble_AlliedHack_End` | — | public |

### gamemodes\chaotic_climate_mode.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 50 | `INTERVAL_FROM_MINUTES` | `minutes` | public |
| 131 | `ChaoticClimate_OnGameSetup` | — | public |
| 183 | `ChaoticClimate_PreInit` | — | public |
| 188 | `ChaoticClimate_OnInit` | — | public |
| 268 | `ChaoticClimate_Start` | — | public |
| 302 | `ChaoticClimate_OnPlayerDefeated` | `player, reason` | public |
| 307 | `ChaoticClimate_OnGameOver` | — | public |
| 312 | `LoadAtmospheres` | — | public |
| 324 | `ChaoticClimate_OnConstructionComplete` | `context` | public |
| 347 | `ChaoticClimate_SetSpeed` | `speed` | public |
| 390 | `ChaoticClimate_SendSeasonStartingNotification` | — | public |
| 404 | `ChaoticClimate_SendSeasonEndingNotification` | — | public |
| 418 | `ChaoticClimate_GrantedBuffDetailsNotification` | — | public |
| 432 | `ChaoticClimate_SetInitialGaiaSpawnData` | — | public |
| 470 | `ChaoticClimate_SpawnGaia` | — | public |
| 488 | `ChaoticClimate_KillGaia` | — | public |
| 519 | `GetPercentageFromCount` | `percentage, count` | public |
| 523 | `SpawnIndividualGaiaType` | `blueprint, spawn_count, positions` | public |
| 531 | `KillRandomGaiaType` | `count, entities` | public |
| 544 | `ChaoticClimate_StartPositiveSummer` | — | public |
| 559 | `ChaoticClimate_EndSeason` | — | public |
| 573 | `ChaoticClimate_StartNextSeason` | — | public |
| 588 | `ChaoticClimate_UpdateUI` | — | public |
| 606 | `SelectInitialBuff` | — | public |
| 612 | `SelectCurrentSeasonBuff` | — | public |
| 675 | `RunOnAllPlayers` | `func, player_list` | public |
| 681 | `GrantActualBuff` | `player` | public |
| 685 | `RemoveActualBuff` | `player` | public |
| 693 | `CheckHUDReloads` | — | public |
| 706 | `ChaoticClimate_CreateWidget` | — | public |
| 719 | `ChaoticClimate_CreateWidgetPC` | — | public |
| 1077 | `ChaoticClimate_CreateWidgetXbox` | — | public |
| 1372 | `ChaoticClimate_CreateWidgetCaster` | — | public |

### gamemodes\chart_a_course.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 52 | `INTERVAL_FROM_MINUTES` | `minutes` | public |
| 107 | `ChartACourse_OnGameSetup` | — | public |
| 162 | `ChartACourse_OnInit` | — | public |
| 250 | `ChartACourse_Start` | — | public |
| 282 | `ChartACourse_OnPlayerDefeated` | `player, reason` | public |
| 289 | `ChartACourse_OnGameOver` | — | public |
| 297 | `ChartACourse_OnConstructionComplete` | `context` | public |
| 321 | `ChartACourse_SetSpeed` | `speed` | public |
| 365 | `ChartACourse_OnGameRestore` | — | public |
| 386 | `ChartACourse_PrepareUpgradeCandidatesForPlayers` | — | public |
| 410 | `ChartACourse_UpgradeSelectionForAIPlayers` | — | public |
| 423 | `ChartACourse_SelectUpgradeForAIPlayer` | `upgradeSelectionIndex, aiPlayerIndex` | public |
| 428 | `ChartACourse_SelectUpgradeForPlayer` | `upgradeSelectionIndex` | public |
| 434 | `ChartACourse_SelectUpgradeNtw` | `sendingPlayer, data` | public |
| 459 | `ChartACourse_UpdateUI` | — | public |
| 478 | `ChartACourse_DetermineUpgradeTier` | — | public |
| 506 | `ChartACourse_RestoreUpgradeTier` | — | public |
| 537 | `ChartACourse_AutoSelectForLocalPlayer` | — | public |
| 547 | `ChartACourse_UpdateUpgradeChoiceRestoreCallback` | — | public |
| 572 | `ChartACourse_RestorePlayersUpgradeChoice` | `player_selections_table` | public |
| 592 | `ChartACourse_CreateBuffSelectionUIForPC` | — | public |
| 845 | `ChartACourse_CreateBuffSelectionUIForXbox` | — | public |
| 1129 | `ChartACourse_MakeUpgradeMenuVisible` | — | public |
| 1134 | `ChartACourse_CloseUpgradeMenu` | — | public |
| 1139 | `ChartACourse_RemoveSelectionUI` | — | public |
| 1148 | `ChartACourse_SelectBuffCommand` | `parameter` | public |
| 1159 | `ChartACourse_SelectUpgrade0` | — | public |
| 1163 | `ChartACourse_SelectUpgrade1` | — | public |
| 1167 | `ChartACourse_SelectUpgrade2` | — | public |
| 1171 | `ChartACourse_CheatGrantUpgradeChoice` | — | public |
| 1175 | `ChartACourse_GrantUpgradeChoiceNtw` | `player,data` | public |

### gamemodes\combat_mode.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 228 | `CombatMode_OnInit` | — | public |
| 325 | `CombatMode_PostInit` | — | public |
| 426 | `CombatMode_Start` | — | public |
| 459 | `CombatMode_OnGameOver` | — | public |
| 469 | `CombatMode_OnItemComplete` | `context` | public |
| 479 | `CombatMode_OnEntityKilled` | `context` | public |
| 509 | `CombatMode_CheckObjective` | — | public |
| 583 | `CombatMode_RoundTimer` | `context, data` | public |
| 604 | `CombatMode_BuyPeriod` | — | public |
| 704 | `CombatMode_AddMatchObjective` | — | public |
| 726 | `CombatMode_UpdateMatchObjective` | — | public |
| 735 | `CombatMode_UpdateBuyTimer` | — | public |
| 756 | `CombatMode_AddRoundObjective` | — | public |
| 783 | `CombatMode_RemoveRoundObjective` | — | public |
| 791 | `CombatMode_WinnerPresentation` | `playerID` | public |
| 804 | `CombatMode_LoserPresentation` | `playerID` | public |
| 816 | `CombatMode_FinalCountDown` | — | public |
| 837 | `CombatMode_SetTeamLineOfSight` | — | public |
| 849 | `CombatMode_RemoveUnusedEntities` | — | public |
| 875 | `CombatMode_StartRound` | — | public |
| 885 | `CombatMode_EndRound` | — | public |
| 961 | `CombatMode_ShowEndOfRoundUI` | — | public |
| 1091 | `CombatMode_CheckStartRound` | `context, data` | public |
| 1123 | `CombatMode_ShowSurrenderUI` | — | public |
| 1146 | `CombatMode_HideSurrenderUI` | — | public |
| 1151 | `CombatMode_EnableSurrenderUI` | `enabled` | public |
| 1158 | `CombatMode_SurrenderButtonClicked` | `elementName, eventName` | public |
| 1166 | `CombatMode_Surrender` | `player, data` | public |
| 1183 | `CombatMode_EnableProduction` | `playerID, enable` | public |
| 1208 | `CombatMode_CreateDataContext` | — | public |
| 1275 | `CombatMode_CreateStatsUI` | — | public |
| 1443 | `CombatMode_UpdateStatsUI` | — | public |
| 1486 | `CombatMode_ShowStatsUI` | `showStats` | public |

### gamemodes\full_moon_mode.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 55 | `INTERVAL_FROM_MINUTES` | `minutes` | public |
| 108 | `FullMoon_OnGameSetup` | — | public |
| 162 | `FullMoon_PreInit` | — | public |
| 167 | `FullMoon_OnInit` | — | public |
| 245 | `FullMoon_Start` | — | public |
| 277 | `FullMoon_OnPlayerDefeated` | `player, reason` | public |
| 282 | `FullMoon_OnGameOver` | — | public |
| 287 | `FullMoon_OnConstructionComplete` | `context` | public |
| 311 | `FullMoon_SetSpeed` | `speed` | public |
| 359 | `FullMoon_MarkerFilter` | `marker_entity, context_data` | public |
| 389 | `FullMoon_FindSpawnPoints` | — | public |
| 452 | `FullMoon_RemoveNormalWolves` | — | public |
| 463 | `FullMoon_SpawnBackUpWaveForPlayer` | `context, data` | public |
| 514 | `FullMoon_SpawnWave` | — | public |
| 600 | `OneShot_EndCurrentMoonRush` | — | public |

### gamemodes\king_of_the_hill_mode.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 53 | `INTERVAL_FROM_MINUTES` | `minutes` | public |
| 141 | `AddVectorToPosition` | `position, vector` | public |
| 145 | `MultiplyVectorByFloat` | `vector, float` | public |
| 154 | `KingOfTheHill_OnGameSetup` | — | public |
| 202 | `KingOfTheHill_PreInit` | — | public |
| 207 | `KingOfTheHill_OnInit` | — | public |
| 308 | `KingOfTheHill_Start` | — | public |
| 342 | `KingOfTheHill_OnPlayerDefeated` | `player, reason` | public |
| 347 | `KingOfTheHill_OnGameOver` | — | public |
| 356 | `KingOfTheHill_NotifyHillSpawn` | — | public |
| 375 | `KingOfTheHill_OnConstructionComplete` | `context` | public |
| 398 | `KingOfTheHill_SetSpeed` | `speed` | public |
| 445 | `KingOfTheHill_FindSpawnPoints` | — | public |
| 457 | `SortByClosestToCenter` | `markerA, markerB` | public |
| 505 | `SortByClosestToCenter` | `positionA, positionB` | public |
| 518 | `KingOfTheHill_SpawnHill` | — | public |
| 552 | `KingOfTheHill_TrySpawnHillAtCentre` | — | public |
| 611 | `KingOfTheHill_OnCapturePointChange` | `context` | public |
| 879 | `KingOfTheHill_OnLocalPlayerChanged` | `context` | public |
| 885 | `KingOfTheHill_RewardPoints` | — | public |

### gamemodes\map_monsters_mode.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 47 | `INTERVAL_FROM_MINUTES` | `minutes` | public |
| 102 | `MapMonsters_OnGameSetup` | — | public |
| 159 | `MapMonsters_PreInit` | — | public |
| 167 | `MapMonsters_OnInit` | — | public |
| 242 | `MapMonsters_Start` | — | public |
| 286 | `MapMonsters_OnPlayerDefeated` | `player, reason` | public |
| 291 | `MapMonsters_OnGameOver` | — | public |
| 296 | `MapMonsters_OnConstructionComplete` | `context` | public |
| 318 | `MapMonsters_SpawnMarkerFilter` | `marker_entity, context_data` | public |
| 352 | `MapMonsters_TryFindSpawnPoints` | — | public |
| 379 | `MapMonsters_FindSpawnPointsUsingOldSystem` | — | public |
| 550 | `MapMonsters_SpawnMonster` | `context, data` | public |
| 611 | `MapMonsters_SetSpeed` | `speed` | public |
| 655 | `MapMonsters_ShouldUseDynamicSpawning` | — | public |

### gamemodes\none_mode.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 42 | `None_OnGameSetup` | — | public |
| 59 | `None_OnInit` | — | public |
| 95 | `None_Start` | — | public |

### gamemodes\sandbox_mode.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 58 | `Sandbox_OnGameSetup` | — | public |
| 76 | `Sandbox_OnInit` | — | public |
| 115 | `Sandbox_Start` | — | public |

### gamemodes\seasons_feast_mode.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 51 | `INTERVAL_FROM_MINUTES` | `minutes` | public |
| 106 | `SeasonsFeast_OnGameSetup` | — | public |
| 154 | `SeasonsFeast_PreInit` | — | public |
| 159 | `SeasonsFeast_OnInit` | — | public |
| 256 | `SeasonsFeast_Start` | — | public |
| 295 | `SeasonsFeast_OnPlayerDefeated` | `player, reason` | public |
| 300 | `SeasonsFeast_OnGameOver` | — | public |
| 310 | `SeasonsFeast_OnConstructionComplete` | `context` | public |
| 333 | `SeasonsFeast_SetSpeed` | `speed` | public |
| 376 | `SeasonsFeast_EventStartNotification` | — | public |
| 390 | `SeasonsFeast_GiftSpawnedTrainingTrigger` | `goalSequence` | public |
| 421 | `SeasonsFeast_GiftSpawnedTrainingComplete` | `goal` | public |
| 433 | `SeasonsFeast_FindSpawnPoints` | — | public |
| 478 | `SeasonsFeast_StartGiftSpawning` | — | public |
| 484 | `SeasonsFeast_SpawnGifts` | — | public |

### gamemodes\standard_mode.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 85 | `StandardMode_OnGameSetup` | — | public |
| 136 | `StandardMode_OnInit` | — | public |
| 210 | `StandardMode_Start` | — | public |
| 239 | `StandardMode_OnGameOver` | — | public |
| 245 | `StandardMode_OnConstructionComplete` | `context` | public |
| 269 | `StandardMode_SetSpeed` | `speed` | public |

### gameplay\chatcheats.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1 | `CheatConvertSelectedUnits` | `player, squads` | public |
| 119 | `CheatReplaceSheepWithWolves` | `player` | public |
| 148 | `ResourcesCheatFood` | `player` | public |
| 153 | `ResourcesCheatGold` | `player` | public |
| 158 | `ResourcesCheatWood` | `player` | public |
| 163 | `ResourcesCheatStone` | `player` | public |
| 168 | `ResourcesCheatOil` | `player` | public |
| 175 | `ResourcesCheatAllBasic` | `player` | public |
| 187 | `CheatSetCurrentPopCapToMax` | `player` | public |
| 191 | `DestroyAllInEGroup` | `context, data` | public |
| 200 | `CheatKillAllGaia` | `player` | public |
| 229 | `CheatHideAllUIExceptForChat` | `player` | public |
| 258 | `CheatExploredAll` | `player` | public |
| 273 | `SpawnUnitBPForPlayer` | `unit, player, pos, needsLoad` | public |
| 305 | `CheatSpawnCoreUnits` | `player, pos` | public |
| 331 | `GetTownCentrePosition` | `player` | public |
| 351 | `SpawnCheatArmy` | `player` | public |
| 362 | `SpawnCheatPhotonMan` | `player` | public |
| 371 | `CheatSwapAOEAlarmSound` | — | public |
| 375 | `ManageTheFires` | `context, data` | public |
| 419 | `CheatSetFireToBuildings` | `player, buildings` | public |
| 473 | `ChatCheatFOW` | `player` | public |
| 491 | `ChatCheatInstantBuildAndGather` | `player` | public |
| 566 | `ChatCheatAgeUpMultiplayer` | `player` | public |
| 576 | `ChatCheatDestroySelected` | `playerID, entities` | public |
| 591 | `ChatCheatInvulnerable` | `player` | public |
| 629 | `CheatTurbo` | `player` | public |
| 641 | `CheatSlow` | `player` | public |
| 653 | `CheatTeleportSelectedSquads` | `player, squads, cursorPos` | public |
| 681 | `CheatLoseInstantly` | `player` | public |

### gameplay\cheat.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `CheatAgeUpMultiplayer` | `playerID,data` | public |
| 19 | `CheatEconomy` | `playerID,data` | public |
| 27 | `CheatFoW` | `playerID,data` | public |
| 45 | `CheatInvulnerable` | `playerID,data` | public |
| 86 | `CheatInstantBuildAndGather` | `playerID,data` | public |
| 119 | `CheatDestroySelected` | `playerID,data` | public |
| 122 | `CheatTeleportSelected` | `playerID,data` | public |
| 141 | `Cheat_Init` | — | public |
| 156 | `Cheat_Callback` | `data` | public |

### gameplay\chi\current_dynasty_ui.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 207 | `CreateCostData` | `entityName` | public |
| 242 | `DynastyUI_OnInit` | — | public |
| 268 | `DynastyUI_Start` | — | public |
| 284 | `DynastyUI_OnGameOver` | — | public |
| 292 | `DynastyUI_OnGameRestore` | — | public |
| 299 | `DynastyUI_OnConstructionComplete` | `context` | public |
| 308 | `DynastyUI_OnEntityKilled` | `context` | public |
| 320 | `DynastyUI_OnPlayerDefeated` | `player, reason` | public |
| 327 | `DynastyUI_OnLocalPlayerChanged` | `context` | public |
| 335 | `DynastyUI_OnUpgradeComplete` | `context` | public |
| 348 | `DynastyUI_Show` | `show_ui` | public |
| 356 | `DynastyUI_CreateUI` | — | public |
| 374 | `DynastyUI_SetCivData` | `raceName` | public |
| 428 | `DynastyUI_ToggleDropdown` | `context` | public |
| 442 | `DynastyUI_HideDropdown` | `context` | public |
| 449 | `DynastyUI_CreateDataContext` | — | public |
| 512 | `DynastyUI_Update` | — | public |
| 574 | `DynastyUI_CreateXboxUI` | — | public |

### gameplay\currentageui.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 22 | `CurrentAgeUI_OnInit` | — | public |
| 28 | `CurrentAge_UpdatePlayerStats` | `player, scarModel` | public |

### gameplay\diplomacy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `Diplomacy_DiplomacyEnabled` | `is_enabled` | public |
| 110 | `Diplomacy_TributeEnabled` | `is_enabled` | public |
| 118 | `Diplomacy_OnInit` | — | public |
| 147 | `Diplomacy_OnGameOver` | — | public |
| 158 | `Diplomacy_OnGameRestore` | — | public |
| 170 | `Diplomacy_ToggleDiplomacyUI` | — | public |
| 190 | `Diplomacy_ShowDiplomacyUI` | `show` | public |
| 197 | `Diplomacy_HideDiplomacyUI` | `context` | public |
| 205 | `Diplomacy_ChangeRelation` | `parameter` | public |
| 211 | `Diplomacy_IncreaseTribute` | `parameter` | public |
| 222 | `Diplomacy_DecreaseTribute` | `parameter` | public |
| 233 | `Diplomacy_ClearTribute` | — | public |
| 244 | `PlayerHasEnoughToTribute` | `playerID, subtotal` | public |
| 253 | `Diplomacy_SendTribute` | — | public |
| 287 | `Diplomacy_ShowUI` | `show` | public |
| 301 | `Diplomacy_OnRelationshipChanged` | `observerPlayerID, targetPlayerID, show_notification` | public |
| 344 | `Diplomacy_OnPlayerAddResource` | `player, resources` | public |
| 350 | `Diplomacy_OnConstructionComplete` | `context` | public |
| 366 | `Diplomacy_OnPlayerDefeated` | `player, reason` | public |
| 390 | `Diplomacy_OnPlayerNameChanged` | `context` | public |
| 402 | `Diplomacy_OnUpgradeComplete` | `context` | public |
| 422 | `Diplomacy_UpdateDataContext` | — | public |
| 522 | `Diplomacy_UpdateNameColours` | — | public |
| 538 | `Diplomacy_OverridePlayerSettings` | `playerID, is_player_visible, is_tribute_visible, is_food_enabled, is_wood_enabled, is_gold_enabled, is_stone_enabled` | public |
| 556 | `Diplomacy_OverrideSettings` | `is_tribute_enabled, is_subtotal_visible, is_score_visible, is_team_visible` | public |
| 567 | `Diplomacy_RelationConverter` | `relation` | public |
| 589 | `Diplomacy_RelationToTooltipConverter` | `observer, target` | public |
| 613 | `Diplomacy_GetTaxRate` | `playerID` | public |
| 619 | `Diplomacy_SetTaxRate` | `playerID, tax_rate` | public |
| 626 | `Diplomacy_AddTribute` | `player_index, resource_index, amount` | public |
| 663 | `Diplomacy_CreateDataContext` | — | public |
| 740 | `Diplomacy_FormatTeamNumber` | `team_number` | public |
| 749 | `Diplomacy_SortDataContext` | — | public |
| 762 | `Diplomacy_CreateUI` | — | public |
| 1255 | `Diplomacy_RemoveUI` | — | public |
| 1264 | `Diplomacy_UpdateUI` | — | public |
| 1271 | `Rule_Diplomacy_UpdateUI` | — | public |
| 1278 | `Diplomacy_Restart` | — | public |
| 1285 | `Diplomacy_ShowEventCue` | `tribute` | public |
| 1313 | `Diplomacy_ChangeRelationNtw` | `playerID, data` | public |
| 1328 | `Diplomacy_SendTributeNtw` | `playerID, data` | public |

### gameplay\dynamic_spawning.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 18 | `DynamicSpawning_IsEnabled` | — | public |
| 23 | `DynamicSpawning_FilterByPlayerStartDistance` | `marker_entity, context_data` | public |
| 51 | `DynamicSpawning_GatherAllSpawnMarkers` | `output_table, filter_function_cb, context_data` | public |
| 73 | `DynamicSpawning_GatherLandSpawnMarkers` | `output_table, filter_function_cb, context_data` | public |
| 101 | `DynamicSpawning_GatherWaterSpawnMarkers` | `output_table, filter_function_cb, context_data` | public |
| 129 | `DynamicSpawning_DebugSetMarkerVisibility` | `marker_table, visibility` | public |
| 139 | `DynamicSpawning_DebugSetMarkerVisibilityAll` | `visibility` | public |

### gameplay\event_cues.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 136 | `EventCues_Start` | — | public |
| 157 | `EventCues_OnGameOver` | — | public |
| 168 | `EventCues_OnPlayerDefeated` | `player, reason` | public |
| 177 | `EventCues_OnUpgradeComplete` | `context` | public |
| 223 | `EventCues_OnAbilityExecuted` | `context` | public |
| 243 | `EventCues_OnItemComplete` | `context` | public |
| 265 | `EventCues_Register` | — | public |
| 274 | `EventCues_Enable` | `enable` | public |
| 279 | `EventCues_NotifyAgeUp` | `player, selfTitle, otherTitle` | public |
| 294 | `_ReturnLocVersion` | `item` | private |
| 308 | `_IsIntelEvent` | `func` | private |
| 330 | `EventCues_HighPriority` | `text, description` | public |
| 342 | `EventCues_CallToAction` | `text, cta_type, onTriggerIntel, onClickFunction, pos, duration, customImage, customStinger` | public |
| 448 | `EventCues_ClearCallToAction` | — | public |
| 476 | `CallToAction_OnEventCueClicked` | `id` | public |
| 532 | `CallToAction_FadeOut` | `context, data` | public |
| 542 | `CallToAction_Clear` | `context, data` | public |
| 554 | `CallToAction_ClearOnLook` | `context, data` | public |

### gameplay\score.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 70 | `Score_OnInit` | — | public |
| 93 | `Score_DiplomacyEnabled` | `is_enabled` | public |
| 99 | `Score_Start` | — | public |
| 119 | `Score_OnRelationshipChanged` | `observer_id, target_id` | public |
| 138 | `Score_OnPlayerDefeated` | `player, reason` | public |
| 151 | `Score_OnGameOver` | — | public |
| 161 | `Score_OnConstructionComplete` | `context` | public |
| 217 | `Score_OnItemComplete` | `context` | public |
| 233 | `Score_OnEntityKilled` | `context` | public |
| 286 | `Score_OnUpgradeStart` | `context` | public |
| 313 | `Score_OnUpgradeComplete` | `context` | public |
| 360 | `Score_UpdatePlayerStats` | `player, scarModel` | public |
| 371 | `Score_GetCurrentAge` | `playerID` | public |
| 386 | `Score_ModifyEconomicScore` | `playerID, cost` | public |
| 408 | `Score_ModifyMilitaryScore` | `playerID, cost` | public |
| 425 | `Score_ModifySocietyScore` | `playerID, cost` | public |
| 443 | `Score_ModifyTechnologyScore` | `playerID, cost` | public |
| 460 | `Score_TotalCost` | `cost` | public |
| 465 | `Score_GetPlayerDataContext` | `player_index` | public |
| 478 | `Score_CreateDataContext` | — | public |

### gameplay\templar\templar_age_up_ui.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 96 | `TemplarAgeUpUI_OnInit` | — | public |
| 111 | `TemplarAgeUpUI_OnGameRestore` | — | public |
| 119 | `TemplarAgeUpUI_CreateDataContext` | — | public |

### gameplay\vision.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 33 | `Vision_OnGameSetup` | — | public |
| 48 | `Vision_Start` | — | public |
| 65 | `Vision_OnGameOver` | — | public |
| 72 | `Vision_OnConstructionComplete` | `context` | public |
| 86 | `Vision_OnPlayerJoinedTeam` | `player` | public |
| 94 | `Vision_OnRelationshipChanged` | `observer_id, target_id` | public |
| 104 | `Vision_UpdateVisionBetweenPlayers` | `playerA, playerB` | public |
| 116 | `Vision_UpdateVisionForPlayer` | `player` | public |

### gameplay\xbox_diplomacy_menus.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 19 | `DiplomacyMenus_UpdateGameplayControl` | — | public |
| 29 | `DiplomacyMenus_DisableGameplayControl` | — | public |
| 35 | `DiplomacyMenus_EnableGameplayControl` | — | public |
| 41 | `DiplomacyMenus_EnableMultiplier` | — | public |
| 48 | `DiplomacyMenus_DisableMultiplier` | — | public |
| 55 | `DiplomacyMenus_Open` | — | public |
| 62 | `DiplomacyMenus_Close` | — | public |
| 69 | `DiplomacyMenus_UpdateNameColours` | — | public |
| 88 | `DiplomacyMenus_CreateXboxRequestAidUI` | — | public |
| 274 | `DiplomacyMenus_CreateXboxTributeAndSettlementUI` | — | public |
| 504 | `DiplomacyMenus_CreateXboxTributeUI` | — | public |
| 694 | `DiplomacyMenus_CreateXboxRecruitChampionsUI` | — | public |
| 864 | `DiplomacyMenus_CreateXboxResourceLocationsUI` | — | public |

### gamescarutil.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 29 | `World_GetHiddenPositionOnPath` | `playerid, origin, dest, checktype` | public |
| 53 | `Entity_BuildStructureOnHex` | `player, blueprint, pos, egroup` | public |
| 95 | `Game_HasOnlySelectedEntitiesOfType` | `unit_type` | public |
| 113 | `KillAllLandmarks` | `player` | public |

### gamesetup.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 52 | `OnGameSetup` | — | public |
| 63 | `OnGameRestore` | — | public |
| 75 | `PreInit` | — | public |
| 82 | `OnInit` | — | public |
| 170 | `_PostOpeningMovie` | — | private |
| 178 | `_RunPlayNISOrMissionStart` | — | private |
| 197 | `_PostOpeningNIS` | — | private |
| 210 | `_collectPlayerHQ` | — | private |
| 219 | `_spawnCampaignEliteDeploymentObject` | — | private |
| 231 | `_InitNIS` | — | private |
| 264 | `_InitializeObjectives` | — | private |
| 315 | `_ShowDebugMenu` | — | private |
| 325 | `_DebugMenuSelect` | `button` | private |
| 340 | `_StartMission` | — | private |
| 376 | `_StartMission_Cheat` | — | private |
| 413 | `_DisplayTitleCards` | — | private |
| 444 | `Mission_Complete` | — | public |
| 456 | `__Mission_Complete_Internal` | — | private |
| 487 | `Mission_PlayOutroMovie` | — | public |
| 497 | `Mission_Win` | — | public |
| 510 | `Mission_PreFail` | `panTarget` | public |
| 522 | `Mission_Fail` | — | public |
| 534 | `__Mission_Fail_Internal` | — | private |
| 607 | `Mission_IsDebug` | — | public |
| 611 | `Mission_SetDebug` | `debugVal` | public |
| 619 | `Mission_ApplyDifficultyUpgrades` | `difficulty, playerlist` | public |
| 631 | `Mission_CheatWin` | `successLevel` | public |
| 659 | `Mission_CheatLose` | — | public |
| 689 | `CheatMenu_SetValues` | `mode, value` | public |
| 697 | `CheatMenu_GetValues` | — | public |
| 719 | `_CheatMenu_GetValues_Reciever` | `mode, value` | private |
| 727 | `CheatMenu_ClearValues` | — | public |
| 734 | `CheatMenu_RestartGame` | — | public |
| 745 | `CheatMenu_AddMenuItem` | `title, mode, value` | public |
| 755 | `CheatMenu_ActivateMenuItem` | `mode, value` | public |
| 763 | `CheatMenu_IsSet` | — | public |
| 776 | `CheatMenu_RegisterCheatFunction` | `func, title` | public |

### gathering_utility.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 52 | `Gathering_FindAllSheep` | `out_eg_allSheep` | public |
| 73 | `Gathering_FindAllDeer` | `out_eg_allDeer` | public |
| 91 | `Gathering_FindAllDeepFish` | `out_eg_allDeepFish` | public |
| 109 | `Gathering_FindAllCattle` | `out_eg_allCattle` | public |
| 129 | `Gathering_FindAllFarms` | `player` | public |
| 141 | `VillagerGatherFromEntityDeposit` | `player, villager, entity_deposit` | public |
| 152 | `VillagerGatherFromSquadDeposit` | `player, villager, squad_deposit` | public |
| 167 | `Gathering_AssignVillagersToGather` | `sg_villagers, resourceDeposits, dropoff_types, search_from_dropoff, one_villager_per_deposit` | public |
| 249 | `Gathering_AssignVillagersToGold` | `sg_villagers, eg_goldDeposits, search_from_dropoff, one_villager_per_mine` | public |
| 262 | `Gathering_AssignVillagersToStone` | `sg_villagers, eg_stoneDeposits, search_from_dropoff, one_villager_per_mine` | public |
| 275 | `Gathering_AssignVillagersToWood` | `sg_villagers, eg_woodDeposits, search_from_dropoff, one_villager_per_tree` | public |
| 288 | `Gathering_AssignVillagersToBerries` | `sg_villagers, eg_berryDeposits, search_from_dropoff, one_villager_per_bush` | public |
| 301 | `Gathering_AssignVillagersToFish` | `sg_villagers, eg_fishDeposits, search_from_dropoff, one_villager_per_fish` | public |
| 314 | `Gathering_AssignVillagersToFarms` | `sg_villagers, eg_farms, search_from_dropoff, one_villager_per_farm` | public |
| 326 | `Gathering_AssignVillagersToSheep` | `sg_villagers, eg_sheep, search_from_dropoff, one_villager_per_sheep` | public |
| 338 | `Gathering_AssignVillagersToDeer` | `sg_villagers, eg_deer, search_from_dropoff, one_villager_per_deer` | public |
| 350 | `Gathering_AssignVillagersToCattle` | `sg_villagers, eg_cattle, search_from_dropoff, one_villager_per_cattle` | public |

### markerpaths.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `MarkerPaths_MoveSGroupAlongPath` | `sgroup, markerName, opt_markerType, opt_startMarker, opt_endMarker` | public |
| 30 | `MarkerPaths_AttackMoveSGroupAlongPath` | `sgroup, markerName, opt_markerType` | public |
| 45 | `MarkerPaths_GenerateIcons` | `pathName, pointList, iconName, spacing, iconScale` | public |
| 153 | `MarkerPaths_ClearIcons` | `pathName, removePath` | public |
| 179 | `MarkerPaths_RepeatAnimateArrowPath` | `path, iterations, interval` | public |
| 185 | `_IterateArrowPath` | `context, data` | private |
| 190 | `MarkerPaths_AnimateArrowPath` | `path` | public |
| 213 | `_MarkerPaths_AnimateArrowPath_AddBlip` | `context, data` | private |
| 239 | `_MarkerPaths_AnimateArrowPath_RemoveBlip` | `context, data` | private |

### mission.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `Mission_Complete` | — | public |
| 30 | `__Mission_Complete_Internal` | — | private |
| 62 | `Mission_CompleteSkipOutro` | — | public |
| 73 | `__Mission_Complete_SkipOutro_Internal` | — | private |
| 80 | `__Mission_Complete_SplashScreen` | — | private |
| 113 | `__Mission_Complete_PlayOutroMovie` | — | private |
| 135 | `__Mission_Complete_Finish` | — | private |
| 164 | `Mission_PreFail` | `panTarget` | public |
| 177 | `Mission_Fail` | — | public |
| 190 | `__Mission_Fail_SplashScreen` | — | private |
| 220 | `__Mission_Fail_Internal` | — | private |

### missionomatic\missionomatic_actionlist.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 18 | `ActionList_Init` | `list` | public |
| 36 | `ActionList_PlayActions` | `list, context, callback, callbackData` | public |
| 67 | `ActionList_GetNewID` | — | public |
| 80 | `ActionList_Manager` | — | public |
| 133 | `Action_Do` | `action, context` | public |
| 170 | `Action_Finish` | `context` | public |
| 188 | `Action_StartObjective_Do` | `action, context` | public |
| 210 | `Action_CompleteObjective_Do` | `action, context` | public |
| 223 | `Action_FailObjective_Do` | `action, context` | public |
| 241 | `Action_StartObjectiveTimer_Do` | `action, context` | public |
| 250 | `Action_StartObjectiveCounter_Do` | `action, context` | public |
| 262 | `Action_StartObjectiveCounter_Update` | `context, data` | public |
| 300 | `Action_SetObjectiveVisible_Do` | `action, context` | public |
| 316 | `Action_SetObjectiveProgressVisible_Do` | `action, context` | public |
| 331 | `Action_SetObjectiveProgress_Do` | `action, context` | public |
| 352 | `Action_Wait_Do` | `action, context` | public |
| 360 | `Action_Wait_Complete` | `context, data` | public |
| 368 | `Action_CallScarFunction_Do` | `action, context` | public |
| 387 | `Action_NotifyPlayer_Do` | `action, context` | public |
| 437 | `Action_PlaySpeechEvent_Do` | `action, context` | public |
| 459 | `Action_PlaySpeechEvent_Complete` | `context, data` | public |
| 467 | `Action_Play3DSound_Do` | `action, context` | public |
| 478 | `Action_SetPlayerOwner_Do` | `action, context` | public |
| 500 | `Action_CompleteUpgrade_Do` | `action, context` | public |
| 519 | `Action_EnableReligiousVictory_Do` | `action, context` | public |
| 534 | `Action_BookmarkTime_Do` | `action, context` | public |
| 562 | `Action_MissionComplete_Do` | `action, context` | public |
| 572 | `Action_MissionFail_Do` | `action, context` | public |
| 586 | `Action_SetMusicIntensity_Do` | `action, context` | public |
| 613 | `Action_PlayMusicStinger_Do` | `action, context` | public |
| 625 | `Action_Loop_Do` | `action, context` | public |
| 664 | `Action_ModuleDoAction_Do` | `action, context` | public |
| 678 | `Action_StartModule_Do` | `action, context` | public |
| 692 | `Action_StopModule_Do` | `action, context` | public |
| 710 | `Action_SetInteractionStage_Do` | `action, context` | public |
| 741 | `Action_ExpositionCamera_Do` | `action, context` | public |
| 772 | `Action_ExpositionCamera_Complete` | `context, data` | public |
| 785 | `Action_SnapCamera_Do` | `action, context` | public |
| 806 | `Action_ConvertPlayerBuildings_Do` | `action, context` | public |
| 833 | `Action_SetLocationOwner_Do` | `action, context` | public |
| 848 | `Action_CaptureLocation_Do` | `action, context` | public |
| 857 | `Action_SetLocationCapturable_Do` | `action, context` | public |
| 872 | `Action_SetInvulnerable_Do` | `action, context` | public |
| 892 | `Action_DeployVillager_Do` | `action, context` | public |
| 903 | `Action_LoadScenario_Do` | `action, context` | public |
| 910 | `Action_Print_Do` | `action, context` | public |
| 916 | `Action_RevealDestination_Do` | `action, context` | public |
| 935 | `Action_RevealUnits_Do` | `action, context` | public |
| 947 | `Action_AddObjectiveHintpoint_Do` | `action, context` | public |
| 972 | `Action_MoveUnits_Do` | `action, context` | public |
| 983 | `Action_SpawnBuilding_Do` | `action, context` | public |
| 994 | `Action_SpawnUnits_Do` | `action, context` | public |
| 1013 | `Action_SpawnUnitsToModule_Do` | `action, context` | public |
| 1020 | `Action_AddBattalionToModule_Do` | `action, context` | public |
| 1043 | `Action_DissolveModule_Do` | `action, context` | public |
| 1052 | `Action_DissolveModuleIntoModule_Do` | `action, context` | public |
| 1058 | `Action_EnableModule_Do` | `action, context` | public |
| 1064 | `Action_DisableModule_Do` | `action, context` | public |
| 1070 | `Action_ModuleAction_Do` | `action, context` | public |
| 1083 | `Action_AddResources_Do` | `action, context` | public |
| 1098 | `Action_SetResources_Do` | `action, context` | public |

### missionomatic\missionomatic_allybanners.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Init_AlliedBanner` | `bannerEgroup, alliedPlayer, mkrSpawn, armyComposition, unitMinimum` | public |
| 67 | `_ControlAlliedArmy` | `context, data` | private |
| 79 | `_MonitorAllyArmy` | `context, data` | private |

### missionomatic\missionomatic_artofwar.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 22 | `Missionomatic_ChallengeInit` | `challengeData` | public |
| 256 | `ChallengeMission_TrackScore` | — | public |
| 327 | `ChallengeMission_Timed_Update` | — | public |
| 486 | `ChallengeMission_UnitsLost_EntityKilled` | `context` | public |
| 499 | `ChallengeMission_UnitsLost_UpdateMedals` | — | public |
| 529 | `ChallengeMission_CountDown_Update` | — | public |

### missionomatic\missionomatic_audiotrigger.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 17 | `AudioTrigger_InitAreaTrigger` | `initData` | public |
| 83 | `AudioTrigger_InitConditionalTrigger` | `initData` | public |
| 126 | `_AudioTrigger_InitCore` | `triggerData` | private |
| 157 | `_AudioTrigger_ComposeError` | `stringName, value` | private |
| 166 | `AudioTrigger_CheckArea` | `context, triggerData` | public |
| 209 | `AudioTrigger_CheckConditional` | `context, triggerData` | public |
| 234 | `AudioTrigger_CanPlay` | `triggerData` | public |
| 242 | `AudioTrigger_Activate` | `triggerData` | public |
| 262 | `AudioTrigger_Deactivate` | `triggerData, playExit` | public |
| 286 | `AudioTrigger_Remove` | `triggerData` | public |

### missionomatic\missionomatic_battalions.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `MissionOMatic_InitializeBattalion` | `battalion` | public |
| 23 | `MissionOMatic_SpawnBattalion` | `context, data` | public |
| 133 | `MissionOMatic_AddSGroupToModule` | `sgroup, battalion` | public |
| 148 | `MissionOMatic_SpawnTestGeneral` | — | public |
| 162 | `MissionOMatic_SpawnGeneral` | `data` | public |
| 175 | `MissionOMatic_InitializeGeneral` | `context, data` | public |
| 202 | `MissionOMatic_InitializeGuards` | `context, data` | public |
| 208 | `MissionOMatic_GeneralKilled` | `context, data` | public |
| 232 | `MissionOMatic_FindBattalion` | `identifier` | public |
| 251 | `BATTALION` | `item` | public |
| 273 | `Battalion_GetSGroup` | `battalion` | public |
| 281 | `Battalion_GetUnits` | `battalion` | public |
| 289 | `_CreateOffsetsTable` | `number` | private |
| 329 | `_ApplyOffsetToPosition` | `offset, position, direction` | private |

### missionomatic\missionomatic_conditionlist.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 16 | `ConditionList_Init` | `list` | public |
| 33 | `ConditionList_CheckList` | `list, context` | public |
| 62 | `ConditionList_CheckItem` | `item, context` | public |
| 94 | `Condition_Boolean_Check` | `condition, context` | public |
| 149 | `Condition_GameTime_Check` | `condition, context` | public |
| 183 | `Condition_HasReachedAge_Check` | `condition, context` | public |
| 197 | `Condition_HasResources_Check` | `condition, context` | public |
| 211 | `Condition_HasBuildings_Check` | `condition, context` | public |
| 228 | `Condition_IsOutnumbered_Check` | `condition, context` | public |
| 250 | `Condition_HasUnits_Check` | `condition, context` | public |
| 298 | `Condition_LocationIsHidden_Check` | `condition, context` | public |
| 319 | `Condition_LocationKilled_Check` | `condition, context` | public |
| 326 | `Condition_LocationRazed_Check` | `condition, context` | public |
| 333 | `Condition_LocationCaptured_Check` | `condition, context` | public |
| 345 | `Condition_ModuleDefeated_Check` | `condition, context` | public |
| 367 | `Condition_AskScarFunction_Check` | `condition, context` | public |
| 383 | `Condition_UnitsSpotted_Check` | `condition, context` | public |
| 412 | `Condition_BuildingsSpotted_Check` | `condition, context` | public |
| 430 | `Condition_UnitsKilled_Check` | `condition, context` | public |
| 445 | `Condition_UpgradeResearched_Check` | `condition, context` | public |
| 449 | `Condition_AgeReached_Check` | `condition, context` | public |
| 458 | `Condition_ObjectiveIsComplete_Check` | `condition, context` | public |
| 465 | `Condition_ObjectiveIsNotComplete_Check` | `condition, context` | public |
| 472 | `Condition_ObjectiveIsStarted_Check` | `condition, context` | public |
| 479 | `Condition_ObjectiveIsNotStarted_Check` | `condition, context` | public |
| 486 | `Condition_SubobjectivesAreComplete_Check` | `condition, context` | public |
| 510 | `Condition_ObjectiveCounter_Check` | `condition, context` | public |
| 535 | `Condition_ObjectiveTimer_Check` | `condition, context` | public |
| 566 | `Condition_UnitAtLocation_Check` | `condition, context` | public |
| 635 | `Condition_TaggedUnitAtLocation_Check` | `condition, context` | public |
| 679 | `Condition_EGroupEmpty_Check` | `condition, context` | public |
| 696 | `NumberComparison` | `number, comparison, value` | public |
| 735 | `CountBuildings` | `params` | public |

### missionomatic\missionomatic_custommetrics.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 35 | `MissionOMatic_InitializeCustomMetric` | `metric` | public |
| 53 | `MissionOMatic_CalculateCustomMetrics` | — | public |
| 92 | `Metric_GetResource_Calculate` | `metric` | public |

### missionomatic\missionomatic_leader.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `Missionomatic_InitializeLeader` | `initData` | public |
| 108 | `Missionomatic_CheckLeader` | `context, data` | public |
| 189 | `Missionomatic_LeaderSurrender` | `leaderData` | public |
| 261 | `Missionomatic_LeaderRecovery` | `leaderData` | public |
| 309 | `Missionomatic_CountLeadersInDownedState` | — | public |
| 324 | `Missionomatic_OnLeaderBridged` | `context, data` | public |
| 351 | `Missionomatic_RespawnLeader` | `context, data` | public |
| 379 | `Missionomatic_FlipLeader` | `squadID` | public |

### missionomatic\missionomatic_leadertent.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `LeaderTent_InitSystem` | — | public |
| 25 | `LeaderTent_InitTentForPlayer` | `playerID` | public |
| 44 | `LeaderTent_UpdatePlayerOwner` | `fromPlayer, toPlayer` | public |
| 53 | `LeaderTent_RegisterLeader` | `leader` | public |
| 58 | `_LeaderTent_OnLeaderDeath` | `context, data` | private |
| 74 | `_LeaderTent_CountDown` | `context, data` | private |
| 90 | `_LeaderTent_GetRespawnData` | `leaderSBP` | private |
| 112 | `_LeaderTent_ReviveLeader` | `context, data` | private |

### missionomatic\missionomatic_location.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Location_Init` | `data` | public |
| 78 | `LOCATION` | `identifier` | public |
| 129 | `Location_FromDescriptor` | `descriptor` | public |
| 144 | `Location_GetPosition` | `data` | public |
| 151 | `Location_GetSGroup` | `data` | public |
| 158 | `Location_GetEGroup` | `data` | public |
| 168 | `Location_AddSGroup` | `data, sgroup` | public |
| 231 | `Location_GetPlayerOwner` | `data` | public |
| 238 | `Location_SetPlayerOwner` | `data, newPlayer` | public |
| 250 | `Location_AddModule` | `data, module` | public |
| 257 | `Location_SetBuildingAssociation` | `data, isOn` | public |
| 262 | `Location_GetVillagerCount` | `data` | public |
| 280 | `Location_Monitor` | `context, data` | public |
| 330 | `Location_Stop` | `data` | public |
| 347 | `Location_SetCapturable` | `data, enable` | public |
| 452 | `Location_SetCapturableFalse_Delayed` | `context, data` | public |
| 472 | `LocationCapture_CountDefenders` | `data` | public |
| 526 | `MissionOMatic_CaptureLocation_Monitor` | — | public |
| 587 | `Location_SetTownCenterInvulnerable` | `data, enable` | public |
| 608 | `Location_Capture` | `data, newPlayer` | public |
| 761 | `Location_Capture_AddReticule` | `context, data` | public |
| 774 | `Location_Capture_RemoveReticule` | `context, data` | public |
| 780 | `Location_HasBeenKilled` | `data` | public |
| 787 | `Location_HasBeenRazed` | `data` | public |
| 794 | `Location_HasBeenCaptured` | `data` | public |
| 813 | `MissionOMatic_InitializeLocationMonitoring` | — | public |
| 866 | `MissionOMatic_LocationMonitoring_EntityConstructedCallback` | `context, data` | public |
| 875 | `MissionOMatic_AssociateEntityWithNearbyLocation` | `entity, duringInitialization` | public |
| 935 | `MissionOMatic_AssociateEntityToLocation` | `entity, location, duringInitialization` | public |
| 960 | `MissionOMatic_AssociateOrphanBuildings` | — | public |
| 1004 | `MissionOMatic_LocationAcceptsEntity` | `location, eid` | public |

### missionomatic\missionomatic_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `MissionOMatic_InitializeObjective` | `objective` | public |
| 114 | `MissionOMatic_TriggerStartingObjectives` | — | public |
| 134 | `MissionOMatic_FindObjective` | `id` | public |
| 156 | `Recipe_AddObjectives` | `recipe, objectives` | public |
| 181 | `MissionOMatic_ObjectiveCallback_PreStart` | `objective` | public |
| 192 | `MissionOMatic_ObjectiveCallback_OnStart` | `objective` | public |
| 219 | `MissionOMatic_ObjectiveCallback_CheckForComplete` | `objective` | public |
| 232 | `MissionOMatic_ObjectiveCallback_PreComplete` | `objective` | public |
| 244 | `MissionOMatic_ObjectiveCallback_OnComplete` | `objective` | public |
| 261 | `MissionOMatic_ObjectiveCallback_CheckForFail` | `objective` | public |
| 274 | `MissionOMatic_ObjectiveCallback_PreFail` | `objective` | public |
| 285 | `MissionOMatic_ObjectiveCallback_OnFail` | `objective` | public |
| 302 | `MissionOMatic_ObjectiveCallback_SetupUI` | `objective` | public |
| 318 | `MissionOMatic_Objective_SetupHintpoints` | `objTable, hintpointTable` | public |
| 365 | `Objective_TransitionTo` | `objTable, voList` | public |

### missionomatic\missionomatic_playbills.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 16 | `Playbill_Start` | `playbillTable, context` | public |
| 69 | `Playbill_Stop` | `id` | public |
| 98 | `Playbill_GenerateID` | — | public |
| 110 | `Playbill_Manager` | `context, data` | public |
| 160 | `Playbill_Manager_ActionsFinished` | `data` | public |

### missionomatic\missionomatic_raiding.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Raiding_Init` | `initData` | public |
| 60 | `Raiding_Activate` | — | public |
| 69 | `Raiding_Dectivate` | — | public |
| 78 | `Raiding_IsTimerValid` | — | public |
| 85 | `Raiding_CountParties` | — | public |
| 90 | `Raiding_RemoveParty` | `module` | public |
| 105 | `Raiding_PruneParties` | — | public |
| 121 | `Raiding_TriggerRaid` | `raidPos, ignoreExclusions, customComposition, forceNew` | public |
| 273 | `Raiding_SetPartyLimit` | `value` | public |
| 281 | `Raiding_SetScouting` | `value` | public |
| 290 | `_Raiding_InitRaid` | `raidParty, raidPos, customComposition` | private |
| 340 | `Raiding_TriggerProbe` | `probeDestination, attackMove, overrideSpawn` | public |
| 366 | `Raiding_ExtractAllSquads` | — | public |
| 379 | `_Raiding_Monitor` | `context, data` | private |
| 421 | `Raiding_UpdateComposition` | `newComposition` | public |
| 433 | `_Raiding_GenerateUnitList` | `customComposition` | private |
| 464 | `Raiding_AddSpawnLocation` | `newSpawn` | public |
| 473 | `_Raiding_GetSpawnLocation` | `closeToPos` | private |
| 484 | `_Raiding_ResetScoutTimer` | — | private |
| 491 | `_Raiding_ResetRaidTimer` | — | private |
| 498 | `Raiding_CountIdleRaiders` | — | public |
| 506 | `_Raiding_FindIdleRaiders` | — | private |

### missionomatic\missionomatic_reporting.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `MissionOMatic_GenerateMissionReport` | `win` | public |
| 29 | `MissionOMatic_GenerateMissionReport_Location` | — | public |
| 39 | `MissionOMatic_GenerateMissionReport_Battalions` | — | public |
| 89 | `MissionOMatic_GenerateExcessUnitList` | — | public |
| 129 | `MissionOMatic_GenerateMissionReport_Objectives` | — | public |

### missionomatic\missionomatic_unitrequests.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 18 | `MissionOMatic_RequestUnits` | `requestingModule, requestData, sources` | public |
| 150 | `MissionOMatic_RequestComplete` | `requestData, sgroup` | public |
| 190 | `MissionOMatic_RequestComplete_InTransitManager` | `context, data` | public |
| 244 | `MissionOMatic_FindUnitRequest` | `item` | public |
| 273 | `Reinforcement_UpdateIdealComposition` | `module` | public |
| 314 | `Reinforcement_SubtractSGroupFromIdealComposition` | `module, sgroup` | public |
| 369 | `Reinforcement_SetIdealComposition` | `module, units` | public |
| 384 | `Reinforcement_AreReinforcementsNeeded` | `module` | public |
| 439 | `Reinforcement_GetAllUnitsInRequestQueue` | `module` | public |
| 471 | `Reinforcement_RequestHasBeenTriggered` | `module, requestData, skipAdjustments` | public |
| 562 | `Reinforcement_GenerateReplacementUnitList` | `module, idealComposition` | public |
| 615 | `UnitProvider_CanModuleProvideUnits` | `module, requestData` | public |
| 678 | `UnitProvider_SelectUnitsFromModule` | `module, requestData, returnSGroup` | public |

### missionomatic\missionomatic_upgrades.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 1117 | `PlayerUpgrades_Auto` | `playerID, includeCurrentAge, exceptions, race` | public |
| 1179 | `PlayerUpgrades_ApplyHealthBonuses` | `player` | public |
| 1202 | `PlayerUpgrades_LearnAllUnits` | `playerID, desiredAge, exceptions, race` | public |
| 1219 | `PlayerUpgrades_LearnAllResearch` | `playerID, desiredAge, exceptions, race` | public |
| 1236 | `PlayerUpgrades_LockAllUpgrades` | `playerID, maxAge, race` | public |
| 1251 | `PlayerUpgrades_HideAllUpgrades` | `playerID, maxAge, race` | public |
| 1264 | `_PlayerUpgrades_UpgradeByRaceAndAge` | `playerID, raceName, age, table, exceptions` | private |
| 1280 | `_PlayerUpgrades_LockByRaceAndAge` | `playerID, raceName, age, table, exceptions` | private |
| 1301 | `_PlayerUpgrades_LockExceptions` | `playerID, exceptions` | private |
| 1309 | `_PlayerUpgrades_HideByRaceAndAge` | `playerID, raceName, age` | private |
| 1333 | `PlayerUpgrades_HideAgeUpAbilities` | `playerID, desiredAge` | public |
| 1346 | `_PlayerUpgrades_GetRaceName` | `playerID` | private |
| 1360 | `has_value` | `tab, val` | public |
| 1388 | `TechTree_GiveAllUpgrades_ByAge` | `playerID, age, includeTiered, optExclusionList` | public |
| 1403 | `TechTree_GiveEconUpgrades` | `playerID, age, includeTiered, optExclusionList` | public |
| 1434 | `TechTree_GiveMilitaryUpgrades` | `playerID, age, includeTiered, optExclusionList` | public |
| 1465 | `TechTree_GiveUnitUpgrades` | `playerID, age, includeTiered, optExclusionList` | public |
| 1491 | `TechTree_EnableDebugPrinting` | — | public |
| 1496 | `_TechTree_DebugPrintUpgrade` | `upgrade` | private |
| 1503 | `_TechTree_ConstructUpgradeTable` | `playerID, age, upgradeTypes` | private |
| 1527 | `_GetPlayerRaceNameType` | `playerID` | private |
| 1581 | `TechTree_HideProductionByAge_UsingTypes` | `playerID, playerMaxAge` | public |
| 1599 | `_TechTree_HideUpgradesByType` | `playerID, stringType` | private |
| 1606 | `_TechTree_HideEntityByType` | `playerID, stringType` | private |
| 1615 | `_TechTree_HideSquadByType` | `playerID, stringType` | private |
| 1624 | `_ParseExclusionList` | `optExclusionList` | private |
| 1641 | `FoodReserves_Init` | — | public |
| 1645 | `FoodReserves_OnUpgrade` | `context, data` | public |
| 1654 | `FoodReserves_Monitor` | `context, data` | public |

### missionomatic\missionomatic_utility.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 15 | `MissionOMatic_InitCommonData` | — | public |
| 76 | `AddPendingDissolve` | `targetModule, sourceSGroup, updateIdealComposition, pause` | public |
| 86 | `RemovePendingDissolve` | `targetModule, sourceSGroup` | public |
| 96 | `PlayECAM` | `eventName` | public |
| 107 | `PlaySpeech` | `eventName` | public |
| 131 | `UnitTable_GenerateFromSGroup` | `sgroup` | public |
| 149 | `UnitTable_GetSlowestUnitSpeed` | `unitTable, player` | public |
| 174 | `UnitTable_CountUnits` | `unitTable` | public |
| 188 | `UnitTable_RowsHaveSameType` | `unitRowA, unitRowB` | public |
| 200 | `UnitTable_AddUnitsByType` | `unitTable, unitType, number, tag` | public |
| 214 | `UnitTable_AddUnitsBySBP` | `unitTable, sbp, number, tag` | public |
| 228 | `UnitTable_RemoveUnitsByType` | `unitTable, unitType, number` | public |
| 245 | `UnitTable_RemoveUnitsBySBP` | `unitTable, sbp, number` | public |
| 261 | `UnitTable_AddUnits` | `unitTable, unitsToAdd` | public |
| 274 | `UnitTable_RemoveUnits` | `unitTable, unitsToRemove` | public |
| 284 | `UnitTable_GetSingleUnit` | `unitTable` | public |
| 293 | `UnitTable_PopSingleUnit` | `unitTable` | public |
| 310 | `UnitTable_GetSubsetByCount` | `unitTable, count, b_removeFromOriginal` | public |
| 338 | `UnitTable_CountUnitsOfType` | `unitTable, unitType` | public |
| 350 | `UnitTable_CountUnitsOfSBP` | `unitTable, sbp` | public |
| 361 | `UnitTable_AddUnitsWithCustomData` | `unitTable, unitsToAdd` | public |
| 367 | `UnitTable_AddUnitRowWithCustomData` | `unitTable, unitRowToAdd` | public |
| 380 | `UnitRows_AreMatching` | `unitRowA, unitRowB` | public |
| 389 | `UnitTable_GetResourceCost` | `units, player` | public |
| 420 | `AngleToCardinalDirection` | `angle` | public |
| 447 | `GetMarkerWithDirection` | `markerName, markerDir` | public |
| 465 | `ResolveSpawnLocation` | `where` | public |
| 488 | `Table_SerializeToString` | `data, indent_level` | public |
| 539 | `MissionOMatic_GetTypeForBlueprint` | `bp` | public |
| 554 | `DissolveModuleIntoModule` | `sourceModuleName, targetModuleName, updateIdealComposition, pause` | public |
| 571 | `DissolveModuleIntoModule_B` | `context, data` | public |
| 581 | `VerifyAllDissolves` | — | public |
| 599 | `TransferModuleIntoModule` | `sourceModuleName, targetModuleName, pause` | public |
| 615 | `TransferArmyIntoArmy` | `sourceArmy, targetArmy` | public |
| 626 | `SpawnUnitGroups` | `player, sgroupName, unitsTable, markerName, destroyFirst` | public |
| 649 | `SpawnUnitsToModule` | `units, module, spawnLocation, pause` | public |
| 672 | `AssignTradecartsToTrade` | `sg_trade_carts, eg_building` | public |
| 691 | `AssignVillagersToGold` | `sg_villagers, search_from_dropoff, one_villager_per_mine` | public |
| 702 | `AssignVillagersToStone` | `sg_villagers, search_from_dropoff, one_villager_per_mine` | public |
| 713 | `AssignVillagersToWood` | `sg_villagers, search_from_dropoff, one_villager_per_tree` | public |
| 724 | `AssignVillagersToBerries` | `sg_villagers, search_from_dropoff, one_villager_per_bush` | public |
| 735 | `AssignVillagersToFish` | `sg_villagers, search_from_dropoff, one_villager_per_fish` | public |
| 746 | `AssignVillagersToFarms` | `sg_villagers, search_from_dropoff, one_villager_per_farm` | public |
| 759 | `AssignVillagersToSheep` | `sg_villagers, search_from_dropoff, one_villager_per_sheep` | public |
| 773 | `AssignVillagersToDeer` | `sg_villagers, search_from_dropoff, one_villager_per_deer` | public |
| 787 | `AssignFishingBoatsToDeepFish` | `sg_fishing_boats, search_from_dropoff, one_boat_per_fish` | public |
| 800 | `AssignVillagersToConstructBuilding` | `sg_villagers, ebp, pos` | public |
| 811 | `IdleVillagers_MakeBusy` | `context, data` | public |
| 869 | `SGroup_GetAvgPosition` | `sgroup` | public |
| 892 | `SGroup_DisableHold` | `sgroup` | public |
| 901 | `SendReinforceNotification` | `where, text, intel` | public |
| 908 | `PositionWithOffset` | `position, x_offset, z_offset` | public |
| 921 | `NormalizeTable` | `input` | public |
| 935 | `MissionOMatic_SGroupCommandDelayed` | `sgroup, destination, attackMove, delay, destroyOnArrive, onDestroyCallback` | public |
| 964 | `MissionOMatic_SGroupCommandDelayed_B` | `context, data` | public |
| 1011 | `MissionOMatic_RevealMovingSGroup` | `sgroupToReveal` | public |
| 1035 | `Missionomatic_DisableTrainingByGoalKey` | `searchKey` | public |
| 1064 | `MissionOMatic_HintOnSquadSelect` | `stringEnglish, locID, goalSequenceString, squadFilter, extraCheckBool` | public |
| 1128 | `MissionOMatic_HintOnHover_Xbox` | `funcTrigger, stringEnglish, locID, goalSequenceString` | public |
| 1223 | `MissionOMatic_HintOnHover` | `funcTrigger, stringEnglish, locID, goalSequenceString` | public |
| 1307 | `_Missionomatic_Hint_UserHasTimedOut` | `goalSequence` | private |
| 1320 | `_Missionomatic_SequencePredicate_HoveredOverBP` | `goalSequence` | private |
| 1344 | `_Missionomatic_GoalPredicate_HoveredOverBP` | `goal` | private |
| 1389 | `_MissionOMatic_IsUpgrading` | `bp` | private |
| 1418 | `_Missionomatic_TrainingPredicate_IgnoreHover` | `goalSequence` | private |
| 1434 | `_MissionOMatic_WatchForAbility` | `context, data` | private |
| 1446 | `MissionOMatic_HintOnAbilityUsed` | `stringEnglish, locID, goalSequenceString, abilityString, leftClick` | public |
| 1515 | `MissionOMatic_RevealMovingTarget_Rule` | — | public |
| 1540 | `log` | `string` | public |
| 1546 | `World_GetGameTimeFormatted` | — | public |
| 1562 | `FormatSeconds` | `seconds` | public |
| 1578 | `Missionomatic_SpawnPickup` | `position, resource, value` | public |
| 1607 | `Missionomatic_SetGateLock` | `egroup, locked` | public |
| 1634 | `Missionomatic_SetGateLock_B` | `context, data` | public |
| 1652 | `Missionomatic_InitPlayer` | `playerSlot, playerData` | public |
| 1672 | `Sound_PlayWallaChargeOnSGroup` | `sgroup` | public |
| 1686 | `Sound_PlayWallaCelebrateOnSGroup` | `sgroup` | public |
| 1699 | `Sound_PlayWallaEngageOnSGroup` | `sgroup` | public |
| 1713 | `Sound_PlayWallaFearOnSGroup` | `sgroup` | public |
| 1727 | `Sound_PlayWallaSpearwallOnSGroup` | `sgroup` | public |
| 1741 | `TrackTradeCartsForPlayers` | `players` | public |
| 1748 | `CheckIfTradeCart` | `context` | public |
| 1759 | `SpawnGarrisonsIntoEGroup` | `egroup, player, opt_scarType, opt_count` | public |
| 1779 | `ClearProductionQueueForEGroup` | `egroup` | public |
| 1785 | `ClearProductionQueueForEntity` | `entity` | public |
| 1794 | `EnableProductionForEGroup` | `egroup, enable` | public |
| 1803 | `GetSpacialData` | `position, direction, facing, usePosAsFallbackIfMarker, useDefault` | public |
| 1836 | `CreateUnits` | `player, units, position, sgroup, direction, facing` | public |
| 1866 | `CreateUnitsWithFormation` | `player, units, position, formation, sgroup, direction, facing` | public |
| 1888 | `Entity_GetHoldSlotsAvailable` | `entity` | public |
| 1892 | `Squad_GetHoldSlotsAvailable` | `squad` | public |
| 1897 | `EGroup_GetHoldSlotsAvailable` | `egroup` | public |
| 1906 | `EGroup_CountActiveLandmarks` | `eg_landmarks` | public |
| 1917 | `SGroup_GetHoldSlotsAvailable` | `sgroup` | public |
| 1926 | `SGroup_GetResourceCost` | `sgroup` | public |
| 1937 | `TotalCost` | `cost_table` | public |
| 1944 | `CreateUnitsInsideEGroup` | `player, units, eg_holds, sgroup` | public |
| 1970 | `CreateUnitsInsideSGroup` | `player, units, sg_holds, sgroup` | public |
| 1996 | `CreateUnitsInsideEntity` | `player, units, entity_hold, sgroup` | public |
| 2024 | `CreateUnitsInsideSquad` | `player, units, squad_hold, sgroup` | public |
| 2060 | `CreateEntity` | `player, ebp, position, egroup, direction, facing, isConstructing` | public |
| 2100 | `SGroup_Move` | `sgroup, position, queued` | public |
| 2120 | `SGroup_MoveToAndDestroy` | `sgroup, position, queued, distance` | public |
| 2135 | `SGroup_MoveAndFace` | `sgroup, position, direction, facing, queued` | public |
| 2156 | `SGroup_AttackMove` | `sgroup, position, queued` | public |
| 2174 | `SGroup_AttackEntity` | `sgroup, targetEntity, queued` | public |
| 2193 | `SGroup_AttackNearestEntityInEGroup` | `sgroup, targetEGroup, queued` | public |
| 2212 | `SGroup_AttackNearestEntitiesInEGroup` | `sgroup, targetEGroup, queued` | public |
| 2227 | `SGroup_AttackSquad` | `sgroup, targetSquad, queued` | public |
| 2246 | `SGroup_AttackNearestSquadInSGroup` | `sgroup, targetSGroup, queued` | public |
| 2265 | `SGroup_AttackNearestSquadsInSGroup` | `sgroup, targetSGroup, queued` | public |
| 2280 | `DestroySquadsWhenArrived` | `sgroup, where, distance` | public |
| 2315 | `Building_GetSpawnPosition` | `building, offset` | public |
| 2337 | `_MonitorSquadsAndDestroyWhenArrived` | `context, data` | private |

### missionomatic\missionomatic_wave.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `_Wave_Init` | — | private |
| 54 | `Wave_OverrideUnitBuildTime` | `type, time` | public |
| 62 | `Wave_OverrideBuildingSpawnType` | `building_type, categories` | public |
| 69 | `Wave_MonitorAllWaves` | — | public |
| 75 | `Wave_FindWave` | `descriptor` | public |
| 90 | `Wave_New` | `wave_data` | public |
| 143 | `Wave_SetUnits` | `wave, units` | public |
| 153 | `Wave_SetSpawn` | `wave, spawn` | public |
| 163 | `Wave_Pause` | `wave` | public |
| 167 | `Wave_Unpause` | `wave` | public |
| 174 | `Wave_AddUnits` | `wave, units` | public |
| 195 | `Wave_Prepare` | `wave, sg_custom, data` | public |
| 259 | `Wave_Launch` | `wave, index` | public |
| 293 | `Wave_LaunchOneShot` | `context, data` | public |
| 303 | `Wave_Monitor` | `wave` | public |
| 342 | `Wave_SpawnUnits` | `wave, spawn` | public |
| 364 | `Wave_GetUnitRowForSpawn` | `wave, spawn, queued_wave` | public |
| 375 | `Wave_UpdateSpawnAndUnitRow` | `wave, spawn, unit_row, row_position_index, queued_wave_index` | public |
| 387 | `Wave_AnyUnitNeedsTraining` | `wave` | public |
| 408 | `Wave_GetSpawnableCategories` | `wave` | public |
| 422 | `Wave_SpawnUnitsIntoModule` | `wave, units, module, spawnLocation, sg_staging, sg_custom, spawningIntoStagingModule` | public |
| 450 | `ArrayContainsValue` | `array, value` | public |
| 458 | `Wave_ValidateSpawns` | `wave` | public |
| 467 | `Wave_ValidateQueuedWave` | `wave, queued_wave_index` | public |
| 474 | `Wave_InitSpawns` | `wave` | public |
| 494 | `Wave_RefreshSpawns` | `wave` | public |
| 528 | `Wave_AddBuildings` | `wave, egroup` | public |
| 550 | `Wave_FilterUnitsByDifficulty` | `units` | public |
| 568 | `Wave_GetUnitTypeFromUnitRow` | `unitRow` | public |

### missionomatic\missionomatic.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 59 | `MissionOMatic_OnInit` | — | public |
| 154 | `MissionOMatic_Preset` | — | public |
| 208 | `MissionOMatic_PreStart` | — | public |
| 237 | `MissionOMatic_PreStart_IntroNISFinished` | — | public |
| 244 | `MissionOMatic_PreStart_Done` | — | public |
| 249 | `MissionOMatic_PlayTitleCard` | `location, date, icon` | public |
| 262 | `MissionOMatic_Start` | — | public |
| 316 | `MissionOMatic_InitializeLocation` | `location` | public |
| 326 | `MissionOMatic_InitializeRovingArmy` | `rovingArmy` | public |
| 336 | `MissionOMatic_InitializeSiege` | `siege` | public |
| 346 | `MissionOMatic_SetupPlayer` | `player` | public |
| 373 | `MissionOMatic_InitializePlayers` | — | public |
| 381 | `MissionOMatic_InitializePlayer` | `player` | public |
| 445 | `MissionOMatic_InitializeTeams` | — | public |
| 507 | `MissionOMatic_GetRelationship` | `p1, p2` | public |
| 520 | `MissionOMatic_GetPlayer` | `identifier` | public |
| 562 | `MissionOMatic_InitializeModule` | `module` | public |
| 579 | `MissionOMatic_FindModule` | `descriptor, context` | public |
| 610 | `MissionOMatic_FindLocation` | `descriptor, context` | public |
| 629 | `MissionOMatic_StartPlaybill` | — | public |
| 641 | `SpawnUnits` | `player, list, location, sgroup` | public |
| 649 | `MissionOMatic_SpawnUnits` | `units, where, sgroup, options` | public |
| 654 | `MissionOMatic_SpawnCompanies` | `companies, where, sgroup, options` | public |
| 661 | `MissionOMatic_EndMission` | `win` | public |
| 703 | `MissionOMatic_InitMusicSettings` | — | public |
| 716 | `MissionOMatic_GetSGroupForTaggedUnit` | `tag` | public |
| 735 | `MissionOMatic_GetEntryForTaggedUnit` | `tag` | public |
| 754 | `MissionOMatic_TagUnit` | `squad, tag` | public |
| 774 | `MissionOMatic_SquadHasTag` | `squad, tag` | public |
| 785 | `MissionOMatic_UntagUnit` | `squad, tag` | public |
| 811 | `MissionOMatic_ClearTag` | `tag` | public |
| 827 | `MissionOMatic_CreateTag` | `tag` | public |
| 857 | `MissionOMatic_UnitEntry_CreateUnit` | `unit, deployment` | public |
| 869 | `MissionOMatic_UnitEntry_SpawnUnit` | `unit, deployment` | public |
| 884 | `MissionOMatic_OnLeaveGameMatchRequested` | — | public |
| 904 | `MissionOMatic_SetupCheatMenu` | — | public |
| 924 | `MissionOMatic_ActivateMenuItem` | `mode, value` | public |
| 935 | `MissionOMatic_Cheat_ViewRecipe` | — | public |
| 942 | `MissionOMatic_Cheat_Win` | — | public |
| 974 | `MissionOMatic_Cheat_Lose` | — | public |
| 1003 | `MissionOMatic_Cheat_Complete_Obj` | — | public |
| 1045 | `MissionOMatic_Cheat_Fail_Obj` | — | public |
| 1087 | `MissionOMatic_UpdateHolyOrderFlags` | — | public |

### missionomatic\modules\module_attack.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `Attack_Init` | `data` | public |
| 118 | `Attack_ConnectSupportModules` | `context, data` | public |
| 129 | `Attack_OnSuccess` | `encounter` | public |
| 144 | `Attack_OnFailure` | `encounter` | public |
| 154 | `Attack_OnTransition` | `encounter` | public |
| 160 | `Attack_Monitor` | `context, moduleData` | public |
| 196 | `Attack_GetPosition` | `moduleData` | public |
| 213 | `Attack_Stop` | `data` | public |
| 230 | `Attack_Disband` | `moduleData, returned_sgroup` | public |
| 265 | `Attack_GetSGroup` | `data` | public |
| 275 | `Attack_AddSGroup` | `moduleData, sgroup, updateComposition` | public |
| 298 | `Attack_RemoveSGroup` | `moduleData, sgroupToRemove, updateComposition` | public |
| 319 | `Attack_IsDefeated` | `moduleData` | public |
| 331 | `Attack_UpdateTargetLocation` | `moduleData, newTarget, attackMove` | public |
| 370 | `Attack_FindModuleByEncounterID` | `encounter` | public |
| 383 | `Attack_GetHighestUnitCount` | `moduleData` | public |
| 391 | `Attack_GetRemainingUnitRatio` | `moduleData` | public |
| 400 | `Attack_GetUnitChangeFromStart` | `moduleData` | public |
| 416 | `Attack_UnitRequest_ProvideEstimate` | `module, requestData` | public |
| 430 | `Attack_UnitRequest_Start` | `module, requestData` | public |

### missionomatic\modules\module_common.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 29 | `AI_Module_ResolveCombatArea` | `module, t, combatRange, leashRange, direction, idlePosition, useCustomDirection` | public |
| 124 | `AI_Module_ConvertLocationToCombatArea` | `module, location, combatRange, leashRange, direction, idlePosition, useCustomDirection` | public |
| 147 | `AI_Module_FindAssociatedModule` | `item` | public |
| 166 | `AI_Module_FindModuleFromScarEncounter` | `scarEncounter` | public |

### missionomatic\modules\module_defend.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `Defend_Init` | `data` | public |
| 127 | `Defend_InitializeTarget` | `module` | public |
| 151 | `Defend_SetPlayerOwner` | `data, newPlayer` | public |
| 156 | `Defend_GetPosition` | `data` | public |
| 164 | `Defend_GetSGroup` | `moduleData` | public |
| 175 | `Defend_CreateEncounter` | `moduleData` | public |
| 219 | `Defend_OnSuccess` | `encounter` | public |
| 229 | `Defend_OnFailure` | `encounter` | public |
| 235 | `Defend_OnTransition` | `encounter` | public |
| 242 | `Defend_Monitor` | `context, moduleData` | public |
| 328 | `Defend_Stop` | `data, giveStopCommandToUnits` | public |
| 346 | `Defend_AddSGroup` | `moduleData, newSGroup, updateComposition` | public |
| 371 | `Defend_RemoveSGroup` | `moduleData, sgroupToRemove, updateComposition` | public |
| 392 | `Defend_Disband` | `moduleData, returned_sgroup` | public |
| 420 | `Defend_IsDefeated` | `moduleData` | public |
| 426 | `Defend_FindModuleByEncounterID` | `encounter` | public |
| 434 | `Defend_GetModuleName` | `module` | public |
| 442 | `Defend_UpdateRange` | `moduleData, combatRange, leashRange` | public |
| 456 | `Defend_GetHighestUnitCount` | `moduleData` | public |
| 462 | `Defend_GetRemainingUnitRatio` | `moduleData` | public |
| 469 | `Defend_GetUnitChangeFromStart` | `moduleData` | public |
| 478 | `Defend_UpdateTargetLocation` | `moduleData, newTarget` | public |
| 504 | `Defend_UnitRequest_ProvideEstimate` | `module, requestData` | public |
| 516 | `Defend_UnitRequest_Start` | `module, requestData` | public |
| 545 | `Defend_RequestUnits` | `moduleData, units, unitSources, priority` | public |

### missionomatic\modules\module_rovingarmy.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 32 | `RovingArmy_Init` | `moduleData` | public |
| 168 | `_RovingArmy_InitializeTargets` | `moduleData` | private |
| 203 | `RovingArmy_Reset` | `moduleData` | public |
| 211 | `_RovingArmy_InitializeFallbacks` | `moduleData` | private |
| 228 | `RovingArmy_Disband` | `moduleData, returned_sgroup` | public |
| 272 | `RovingArmy_AddSGroup` | `moduleData, sgroup, updateComposition` | public |
| 313 | `RovingArmy_RemoveSGroup` | `rovingArmy, sgroup, updateComposition` | public |
| 332 | `RovingArmy_GetSGroup` | `moduleData` | public |
| 340 | `RovingArmy_SetTarget` | `moduleData, target, combatRange, leashRange, skipTransition` | public |
| 366 | `RovingArmy_SetTargetTransition` | `moduleData` | public |
| 385 | `RovingArmy_AddTarget` | `moduleData, target, combatRange, leashRange, skipTransition` | public |
| 427 | `RovingArmy_AddTargets` | `moduleData, targets` | public |
| 439 | `RovingArmy_SetTargets` | `moduleData, targets` | public |
| 462 | `RovingArmy_GetTarget` | `moduleData` | public |
| 475 | `RovingArmy_GetTargets` | `moduleData` | public |
| 484 | `RovingArmy_ClearTargets` | `moduleData` | public |
| 499 | `_RovingArmy_GetFallback` | `moduleData` | private |
| 510 | `RovingArmy_Pause` | `moduleData, pause` | public |
| 544 | `_RovingArmy_Monitor` | `context, moduleData` | private |
| 588 | `_RovingArmy_UpdateEmptyStatus` | `moduleData` | private |
| 604 | `_RovingArmy_CreateAttackEncounter` | `moduleData` | private |
| 668 | `_RovingArmy_TargetIsNotFinal` | `rovingArmy` | private |
| 674 | `_RovingArmy_CreateDefendEncounter` | `moduleData, target` | private |
| 713 | `_RovingArmy_MoveToDissolvePoint` | `moduleData` | private |
| 750 | `_RovingArmy_DissolveAtFallback` | `encounter` | private |
| 756 | `_RovingArmy_DissolveBeforeFallback` | `encounter` | private |
| 764 | `_RovingArmy_OnEncounterSuccessAttack` | `encounter` | private |
| 808 | `_RovingArmy_OnEncounterBlocked` | `encounter` | private |
| 826 | `_RovingArmy_Death` | `moduleData, forceDissolve` | private |
| 855 | `_RovingArmy_Fail` | `moduleData` | private |
| 866 | `_RovingArmy_Complete` | `moduleData` | private |
| 894 | `RovingArmy_ForceStart` | `moduleData` | public |
| 903 | `RovingArmy_Start` | `moduleData` | public |
| 915 | `_RovingArmy_AttackTarget` | `moduleData` | private |
| 925 | `_RovingArmy_StopAttacking` | `moduleData` | private |
| 940 | `_RovingArmy_DefendSpawnLocation` | `moduleData` | private |
| 956 | `_RovingArmy_DefendPreviousTarget` | `moduleData` | private |
| 977 | `_RovingArmy_DefendCurrentTarget` | `moduleData` | private |
| 1000 | `_RovingArmy_DefendCurrentPosition` | `moduleData` | private |
| 1012 | `_RovingArmy_DefendFallbackOrSpawn` | `moduleData` | private |
| 1033 | `_RovingArmy_StopDefending` | `moduleData` | private |
| 1044 | `RovingArmy_HasUnits` | `moduleData` | public |
| 1052 | `_RovingArmy_HasValidTarget` | `moduleData` | private |
| 1060 | `_RovingArmy_HasValidFallback` | `moduleData` | private |
| 1068 | `RovingArmy_IsDefeated` | `moduleData` | public |
| 1079 | `_RovingArmy_BelowThreshold` | `moduleData` | private |
| 1110 | `_RovingArmy_AboveThreshold` | `moduleData` | private |
| 1122 | `_RovingArmy_IsAboveThreshold` | `moduleData` | private |
| 1129 | `_RovingArmy_IsBelowThreshold` | `moduleData` | private |
| 1138 | `_RovingArmy_FindModuleByEncounterID` | `encounter` | private |
| 1149 | `_RovingArmy_UpdateTarget` | `moduleData` | private |
| 1214 | `_RovingArmy_UpdateFallback` | `moduleData` | private |
| 1244 | `_RovingArmy_GetRandomTargetIndex` | `moduleData` | private |
| 1264 | `RovingArmy_SetWithdrawThreshold` | `moduleData, newThreshold` | public |
| 1270 | `RovingArmy_CountUnvisitedTargets` | `moduleData` | public |
| 1285 | `_RovingArmy_GetProximityTargetIndex` | `moduleData` | private |
| 1316 | `_RovingArmy_GetMeanderingTargetIndex` | `moduleData` | private |
| 1358 | `RovingArmy_GetRemainingUnitRatio` | `moduleData` | public |
| 1366 | `RovingArmy_GetUnitChangeFromStart` | `moduleData` | public |
| 1374 | `RovingArmy_UnitRequest_ProvideEstimate` | `moduleData, requestData` | public |
| 1384 | `RovingArmy_UnitRequest_Start` | `moduleData, requestData` | public |
| 1417 | `RovingArmy_GetNearestSeen` | `moduleData, huntedGroup` | public |
| 1470 | `RovingArmy_GetPosition` | `moduleData` | public |
| 1486 | `RovingArmy_RequestUnits` | `moduleData, units, unitSources, priority` | public |
| 1510 | `RovingArmy_GetRendezvousPosition` | `moduleData` | public |
| 1530 | `RovingArmy_IsDead` | `moduleData` | public |
| 1538 | `RovingArmy_IsEmpty` | `moduleData` | public |
| 1546 | `_RovingArmy_HasDefendReason` | `moduleData` | private |

### missionomatic\modules\module_siege.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `Siege_Init` | `data` | public |
| 87 | `Siege_CreateEncounters` | `moduleData` | public |
| 143 | `Siege_Monitor` | `context, moduleData` | public |
| 153 | `Siege_Stop` | `moduleData` | public |
| 184 | `Siege_Disband` | `moduleData` | public |
| 226 | `Siege_GetSGroup` | `data` | public |
| 234 | `Siege_GetPosition` | `data` | public |
| 253 | `Siege_RequestReinforcements` | `moduleData, unitTypes, requestSize` | public |
| 288 | `Siege_RequestAid` | `moduleData` | public |
| 320 | `Siege_CanAid` | `moduleData` | public |
| 330 | `Siege_RenderAid` | `moduleData, target` | public |
| 345 | `Siege_AddSGroup` | `moduleData, sgroup` | public |
| 386 | `Siege_UnderAttackTest` | `moduleData` | public |
| 406 | `Siege_TriggerUnderAttack` | `moduleData` | public |
| 422 | `Siege_TriggerAttackOver` | `moduleData` | public |
| 439 | `Siege_IsDefeated` | `moduleData` | public |

### missionomatic\modules\module_townlife.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `TownLife_Init` | `data` | public |
| 93 | `TownLife_GetPosition` | `data` | public |
| 102 | `TownLife_RequestUnits` | `moduleData, units, unitSources, priority` | public |
| 125 | `TownLife_Monitor` | `context, moduleData` | public |
| 156 | `TownLife_Stop` | `moduleData` | public |
| 193 | `TownLife_Disband` | `moduleData, return_sgroup` | public |
| 223 | `TownLife_GetSGroup` | `moduleData` | public |
| 232 | `TownLife_AddSGroup` | `moduleData, sgroup` | public |
| 245 | `TownLife_GetEGroup` | `moduleData` | public |
| 258 | `TownLife_UnderAttackTest` | `data` | public |
| 268 | `TownLife_TriggerUnderAttack` | `data` | public |
| 288 | `TownLife_UnderAttackManager` | `context, data` | public |
| 333 | `TownLife_TriggerAttackOver` | `data` | public |
| 358 | `TownLife_IsUnderAttack` | `data` | public |
| 367 | `TownLife_IsDefeated` | `moduleData` | public |
| 376 | `TownLife_SetPlayerOwner` | `data, newPlayer` | public |
| 389 | `TownLife_UnitRequest_ProvideEstimate` | `module, requestData` | public |
| 434 | `TownLife_UnitRequest_Start` | `module, requestData` | public |
| 491 | `TownLife_UnitRequest_WaveComplete` | `wave` | public |

### missionomatic\modules\module_unitspawner.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `UnitSpawner_Init` | `data` | public |
| 57 | `UnitSpawner_GetPosition` | `data` | public |
| 65 | `UnitSpawner_GetSGroup` | `data` | public |
| 74 | `UnitSpawner_IsDefeated` | `moduleData` | public |
| 82 | `UnitSpawner_Stop` | `moduleData` | public |
| 99 | `UnitSpawner_UnitRequest_ProvideEstimate` | `module, requestData` | public |
| 124 | `UnitSpawner_UnitRequest_Start` | `module, requestData` | public |
| 136 | `UnitSpawner_UnitRequest_Complete` | `context, data` | public |
| 170 | `_UnitSpawner_GetTimeEstimate` | `instance, requestData` | private |

### network.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `Network_Init` | — | public |
| 17 | `Network_RegisterEvent` | `eventFunction` | public |
| 25 | `Network_RemoveEvent` | `eventFunction` | public |
| 29 | `Network_CallEvent` | `eventType, message` | public |
| 34 | `Network_Callback` | `data` | public |

### objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 57 | `Objective_Init` | — | public |
| 70 | `__ObjectiveNothing` | — | private |
| 91 | `Objective_Register` | `objTable, owner` | public |
| 230 | `Objective_Start` | `obj, showTitle, playIntel` | public |
| 259 | `Objective_Complete` | `obj, showTitle, playIntel` | public |
| 293 | `Objective_Fail` | `obj, showTitle, playIntel` | public |
| 322 | `Objective_Stop` | `obj` | public |
| 344 | `Objective_Show` | `objTable, show, bShowTitle` | public |
| 362 | `Objective_UpdateText` | `objTable, new_title, new_description, showTitle, immediate` | public |
| 394 | `Objective_TriggerTitleCard` | — | public |
| 418 | `Obj_CreateMusicStinger` | — | public |
| 467 | `Objective_IsComplete` | `objTable` | public |
| 480 | `Objective_GetSubObjectives` | `objTable` | public |
| 499 | `Objective_AreSubObjectivesComplete` | `objTable, all` | public |
| 522 | `Objective_AreSubObjectivesFailed` | `objTable, all` | public |
| 545 | `Objective_IsFailed` | `objTable` | public |
| 558 | `Objective_IsStarted` | `objTable` | public |
| 571 | `Objective_IsVisible` | `objTable` | public |
| 585 | `Objective_AreAllPrimaryObjectivesComplete` | — | public |
| 628 | `Objective_TogglePings` | `objTable, boolean` | public |
| 638 | `Objective_AddAreaHighlight` | `objTable, pos, areaType, scale, colour, alpha` | public |
| 694 | `Objective_AddUIElements` | `objTable, pos, ping, hintpointText, worldArrow, objectiveArrowOffset, objectiveArrowFacing, actionType, iconName, template` | public |
| 815 | `Objective_RemoveUIElements` | `objTable, elementID` | public |
| 902 | `Objective_BlinkUIElements` | `objTable, elementID` | public |
| 918 | `__Objective_BlinkUIElements_Off` | `context, data` | private |
| 962 | `__Objective_BlinkUIElements_On` | `context, data` | private |
| 1008 | `Objective_AddPing` | `objTable, pos` | public |
| 1037 | `Objective_RemovePing` | `objTable, pingID` | public |
| 1058 | `Objective_AddGroundReticule` | `objTable, pos, size, reticuleBP` | public |
| 1086 | `Objective_RemoveGroundReticule` | `objTable, reticuleID` | public |
| 1107 | `Objective_AddHealthBar` | `objTable, barIndex, group, name, onlyWhenDamaged` | public |
| 1180 | `Objective_AddTimerBar` | `objTable, barIndex, text` | public |
| 1214 | `Objective_RemoveHealthBar` | `objTable, index` | public |
| 1227 | `Objective_RemoveTimerBar` | `objTable, index` | public |
| 1248 | `Objective_StartTimer` | `objTable, direction, initialTime, flashThreshold` | public |
| 1283 | `Objective_PauseTimer` | `objTable` | public |
| 1295 | `Objective_ResumeTimer` | `objTable` | public |
| 1307 | `Objective_StopTimer` | `objTable` | public |
| 1320 | `Objective_GetTimerSeconds` | `objTable` | public |
| 1339 | `Objective_IsTimerSet` | `objTable` | public |
| 1351 | `Objective_SetCounter` | `objTable, current, maximum` | public |
| 1371 | `Objective_IncreaseCounter` | `objTable, amount` | public |
| 1383 | `Objective_StopCounter` | `objTable` | public |
| 1395 | `Objective_GetCounter` | `objTable` | public |
| 1408 | `Objective_IsCounterSet` | `objTable` | public |
| 1418 | `Objective_ShowProgressBar` | `objTable, fraction, flashing` | public |
| 1434 | `Objective_HideProgressBar` | `objTable` | public |
| 1454 | `Objective_SetAlwaysShowDetails` | `objTable, title, hud_arrow, hintpoints` | public |
| 1496 | `Objective_Manager` | — | public |
| 1603 | `__Objective_ProcessUpdateQueue` | — | private |
| 1646 | `__Objective_UpdateFinished` | — | private |
| 1664 | `Objective_Manager_StartingObjective` | `context, data` | public |
| 1734 | `Objective_Manager_CompletingObjective` | `context, data` | public |
| 1799 | `Objective_Manager_FailingObjective` | `context, data` | public |
| 1860 | `Objective_Manager_UpdatingObjective` | `context, data` | public |
| 1902 | `Objective_Manager_StoppingObjective` | `context, data` | public |
| 1921 | `__ObjectiveSpeechEvent` | — | private |
| 1945 | `__Objective_PlayIntelEvent` | `speechevent, update` | private |
| 1961 | `__Objective_GetTitleCardText` | `update` | private |
| 2002 | `__Objective_UpdateObjectiveList` | `update` | private |
| 2079 | `__Objective_RemoveAssociatedUI` | `objective` | private |
| 2113 | `__ObjectiveOnShowCallback` | `id` | private |
| 2136 | `__ObjectiveOnSelectCallback` | `id` | private |
| 2140 | `__ObjectiveOnActivateCallback` | `id` | private |
| 2147 | `__ObjectiveLuaTableQueryCallback` | `id, arg1` | private |
| 2165 | `__FindObjectiveTable` | `id` | private |
| 2180 | `__GetBlipType` | `objTable` | private |
| 2197 | `__ShowSingleBlip` | `objTable, ping, bShow` | private |
| 2219 | `__ShowObjectiveBlips` | `objTable, bShow` | private |
| 2229 | `__ShowSingleReticule` | `objTable, reticule, bShow` | private |
| 2251 | `__ShowObjectiveReticules` | `objTable, bShow` | private |
| 2259 | `__HighlightEntity` | `objID, elementTable, entity, hintpoint, arrow, arrowOffset, arrowFacing, actionType, iconName, template` | private |
| 2297 | `__HighlightSquad` | `objID, elementTable, squad, hintpoint, arrow, arrowOffset, arrowFacing, actionType, iconName, template` | private |
| 2337 | `__HighlightPosition` | `objID, elementTable, pos, hintpoint, arrow, arrowOffset, arrowFacing, actionType, iconName, template` | private |
| 2372 | `__Objective_updateHealthBar` | `id, data` | private |
| 2446 | `__Objective_updateTimerBar` | `id, data` | private |
| 2494 | `__Objective_Reminder` | `id, data` | private |

### prefabs\schemas\canseetrigger.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `canseetrigger_Init` | `data` | public |
| 41 | `canseetrigger_Stop` | `data` | public |
| 51 | `pcanseetrigger_Activate` | `data` | public |
| 66 | `canseetrigger_Test` | `instance` | public |
| 82 | `canseetrigger_Check` | `context, data` | public |
| 99 | `canseetrigger_Trigger` | `data` | public |
| 198 | `canseetrigger_GetTriggerCount` | `data` | public |
| 208 | `canseetrigger_TriggerExited` | `data` | public |
| 227 | `canseetrigger_RegisterExternalInterest` | `data, params` | public |
| 247 | `canseetrigger_TriggerExternalInterest` | `context, data` | public |
| 255 | `canseetrigger_TriggerScarFunction` | `context, data` | public |
| 268 | `canseetrigger_TriggerPrefab` | `context, data` | public |
| 275 | `canseetrigger_TriggerIntelEvent` | `context, data` | public |

### prefabs\schemas\exclusionarea.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `exclusionarea_Init` | `data` | public |
| 27 | `exclusionarea_Enable` | `data` | public |
| 36 | `exclusionarea_Disable` | `data` | public |

### prefabs\schemas\healthtrigger.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `healthtrigger_Init` | `data` | public |
| 30 | `healthtrigger_check` | `id, data` | public |
| 101 | `healthtrigger_Activate` | `data` | public |
| 117 | `healthtrigger_Trigger` | `data` | public |
| 164 | `healthtrigger_RegisterExternalInterest` | `data, params` | public |
| 180 | `healthtrigger_TriggerExternalInterest` | `id, data` | public |
| 188 | `healthtrigger_TriggerScarFunction` | `id, data` | public |
| 200 | `healthtrigger_TriggerIntelTable` | `id, data` | public |
| 211 | `healthtrigger_TriggerPrefab` | `id, data` | public |

### prefabs\schemas\momobjective_schema.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 10 | `PrefabSchema_ConditionList` | `name, description` | public |
| 84 | `PrefabSchema_ComparisonOptions` | — | public |

### prefabs\schemas\momobjective.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `momobjective_Init` | `data` | public |

### prefabs\schemas\pickups.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 14 | `pickups_Init` | `data` | public |
| 22 | `pickups_SpawnAllPickups` | `data` | public |

### prefabs\schemas\playertrigger.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `playertrigger_Init` | `data` | public |
| 38 | `playertrigger_Stop` | `data` | public |
| 48 | `playertrigger_Activate` | `data` | public |
| 58 | `playertrigger_Trigger` | `data` | public |
| 146 | `playertrigger_GetTriggerCount` | `data` | public |
| 156 | `playertrigger_TriggerExited` | `id, data` | public |
| 197 | `playertrigger_RegisterExternalInterest` | `data, params` | public |
| 213 | `playertrigger_TriggerExternalInterest` | `id, data` | public |
| 221 | `playertrigger_TriggerScarFunction` | `id, data` | public |
| 234 | `playertrigger_TriggerPrefab` | `id, data` | public |

### prefabs\schemas\villagerlife.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `VillagerLife_Create` | `player, name, sg_roaming, sg_wood, sg_food, sg_stone, sg_gold, villager_response, mkr_home, mkr_flee, b_require_garrison, mkr_flee_backup` | public |
| 52 | `villagerlife_Init` | `data` | public |
| 140 | `VillagerLife_Find` | `name` | public |
| 150 | `VillagerLife_AddSGroup` | `instance, sgroup, job` | public |
| 173 | `VillagerLife_OnFail` | `encounterID` | public |
| 180 | `VillagerLife_OnSuccess` | `encounterID` | public |
| 190 | `VillagerLife_GoToWork` | `instance` | public |
| 203 | `VillagerLife_Monitor` | `context, data` | public |
| 263 | `VillagerLife_Attack` | `instance` | public |
| 288 | `VillagerLife_Wander` | `instance, squad` | public |
| 300 | `VillagerLife_GarrisonIsNearby` | `instance` | public |
| 310 | `VillagerLife_DestroyIfNearPosition` | `sgroup, position` | public |

### replay\replaystatviewer.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 39 | `ReplayStatViewer_PopulateReplayStatTabs` | `dataTemplates` | public |
| 59 | `ReplayStatViewer_RegisterDataContextUpdater` | `callback` | public |
| 68 | `ReplayStatViewer_RegisterPlayerDataContextUpdater` | `callback` | public |
| 75 | `ReplayStatViewer_OnInit` | — | public |
| 96 | `ReplayStatViewer_Start` | — | public |
| 104 | `ReplayStatViewer_OnGameOver` | — | public |
| 147 | `ReplayStatViewer_UpdatePlayerDataContexts` | — | public |

### rogue\rogue_boons.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Boons_OnInit` | — | public |
| 15 | `Boons_FirstSelection` | — | public |
| 20 | `Boons_Monitor` | — | public |
| 33 | `Boons_OnUpgradeComplete` | `context` | public |
| 97 | `Boon_GoldenParachute` | `executer` | public |
| 104 | `Boon_SticksAndStones` | `executer` | public |
| 108 | `Boon_FruitsOfLabor` | `executer` | public |
| 118 | `Boons_OnUnitKilled` | `context` | public |
| 127 | `Boon_CacheConverters` | `executer` | public |
| 136 | `Boon_UpgradeRoulette` | `executer` | public |

### rogue\rogue_data.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `RogueData_Init` | — | public |
| 233 | `RogueData_GenerateScalingDifficultyScores` | `initial_value, multiplier` | public |
| 243 | `RogueData_Cheat_Playtime` | `seconds` | public |

### rogue\rogue_events.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 22 | `Event_InitStartGathering` | `time` | public |
| 32 | `Event_InitRoundSpawn` | `time, round` | public |
| 42 | `Event_InitSubwaveLaunch` | `time, subwave` | public |
| 53 | `Event_InitRoundArrive` | `time, round` | public |
| 65 | `Event_InitAgeUp` | `time` | public |
| 76 | `Event_InitIncreaseMinLanes` | `time` | public |
| 87 | `Event_InitIncreaseMaxLanes` | `time` | public |
| 98 | `Event_InitUnlockLane` | `time, lane_name` | public |
| 110 | `Event_InitGrantCombatUpgrades` | `time, age` | public |
| 122 | `Event_InitSpawnRoamers` | `time, value` | public |
| 138 | `Events_InsertEventAtCorrectTime` | `events, event` | public |
| 147 | `Events_OnSecond` | `context, data` | public |
| 206 | `Events_GetCurrentEvent` | `state` | public |
| 219 | `Events_ProcessEvent` | `state, event` | public |
| 275 | `Events_GrantEnemyUpgrade` | `age_index` | public |

### rogue\rogue_factions.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Rogue_SetupPlayers_A` | — | public |
| 7 | `Rogue_AddHumanPlayer` | `player_index, color` | public |
| 30 | `Rogue_AddEnemyWavePlayer` | `player_index, name, color` | public |
| 48 | `Rogue_AddAllyPlayer` | `player_index, name, color` | public |
| 66 | `Rogue_AddEnemyAllyPlayer` | `player_index, name, color` | public |
| 84 | `Rogue_AddEnemyRaiderPlayer` | `player_index, name, color` | public |
| 102 | `Rogue_AddNeutralPlayer` | `player_index, name, color` | public |
| 120 | `Rogue_SetupPlayers_B` | `player_index` | public |
| 147 | `Rogue_SetupPlayers_C` | `player_index` | public |
| 155 | `Factions_Init` | — | public |
| 194 | `Faction_FromPlayer` | `player` | public |

### rogue\rogue_favors.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `Favors_ApplyFavors` | — | public |
| 42 | `_apply_forward_outposts` | `player, level` | private |
| 83 | `_apply_township` | `player, level` | private |
| 158 | `_apply_township_place_worker_elephant` | `player, marker` | private |
| 165 | `_apply_township_place_buildings` | `player, marker, building` | private |

### rogue\rogue_lanes.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Lanes_Init` | — | public |
| 9 | `Lane_Init` | `name, is_locked, wave_template_validator, boss_sbp` | public |
| 74 | `Sublane_Init` | `lane, name` | public |
| 119 | `Lanes_Choose` | `state, number_of_lanes, boss_sbp` | public |
| 165 | `Lanes_ChooseOverride` | `state, lane_names` | public |
| 175 | `Lanes_IdentifyAllyLane` | — | public |

### rogue\rogue_misc.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 8 | `GetIntegerInExponentialRange` | `story, absurd` | public |
| 31 | `GetFloatInExponentialRange` | `story, absurd` | public |
| 49 | `GetNumSquadsFromValue` | `player, unit_type, value` | public |
| 60 | `Rogue_OttomanVizierFix` | — | public |
| 71 | `AllMarkers_FromNameNearPosition` | `name, position, distance` | public |
| 87 | `AllMarkers_InSequence` | `prefix` | public |
| 106 | `ValidateInteger` | `number` | public |
| 112 | `Debug_PrintUnitCounts` | — | public |

### rogue\rogue_objectives.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 4 | `Rogue_Objectives_Precache` | — | public |
| 27 | `OnEndlessModeStingerStopped` | `stingerId` | public |
| 36 | `OnGoldMedalAquired` | — | public |
| 46 | `Rogue_InitObjectives` | — | public |
| 858 | `Rogue_ApplyForcedObjectives` | — | public |
| 868 | `Rogue_ChooseObjectives` | — | public |
| 924 | `Rogue_StartObjectives` | — | public |
| 934 | `Rogue_MonitorWaveWarningUI` | — | public |
| 953 | `Rogue_StartSideObjective` | — | public |
| 969 | `Rogue_GetObjectiveWithName` | `name` | public |
| 982 | `Nook_Init` | `marker` | public |
| 990 | `Nook_CreateEntitiesAtMarkers` | `nook, player, ebp, marker_name, egroup, delay, is_ghost, set_invulnerable` | public |
| 1031 | `Nook_CleanArea` | `nook` | public |
| 1043 | `Nook_CreateGhost` | `context, data` | public |
| 1063 | `Nook_CreateEntity` | `context, data` | public |
| 1081 | `Nook_GetMarkersWithName` | `nook, marker_name` | public |
| 1094 | `Nook_SpawnArmy` | `nook, player, unit_table, marker_name, target_order, sgroup, idleTime, ignore_buildings, onComplete` | public |
| 1139 | `College_Init` | `objTable` | public |
| 1152 | `College_ObjectiveUI_Reminder` | `context, data` | public |
| 1160 | `_College_OnAbilityUsed` | `context, data` | private |
| 1168 | `College_Countdown` | `context, data` | public |
| 1185 | `College_AddUnit` | `squad` | public |
| 1194 | `College_ReleaseUnit` | `unit_in_training` | public |
| 1202 | `DestroyBuildingsObjective_Start` | `objTable` | public |
| 1239 | `DestroyBuildingsObjective_OnKill` | `context, data` | public |
| 1277 | `SaveAlly_PreComplete` | `objTable` | public |
| 1295 | `SaveAlly_Monitor` | `context, data` | public |
| 1341 | `SaveAlly_Reform` | — | public |
| 1346 | `MonitorBonfire` | `context, data` | public |
| 1360 | `Rogue_MonitorTrebuchetAttacks` | `context, data` | public |
| 1436 | `_Rogue_SetTrebFacing` | `context, data` | private |
| 1448 | `Rogue_StopEnemyTrebFiring` | `context, data` | public |
| 1452 | `Rogue_MonitorTrebAttackTimer` | `context, data` | public |
| 1478 | `Rogue_GetTrebNextShotDelay` | — | public |
| 1494 | `Rogue_MonitorEnemyTrebHealth` | `context, data` | public |

### rogue\rogue_outlaws.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 6 | `Outlaws_SetUnitTypes` | `unit_types` | public |
| 10 | `Outlaws_GetUnitDataSplit` | `budget_total` | public |
| 23 | `Outlaws_GetUnitByScore` | — | public |
| 45 | `Outlaws_SetDefaultDifficultyTuning` | — | public |
| 58 | `Outlaws_SetIncome` | `amount` | public |
| 63 | `Outlaws_IncrementIncome` | — | public |
| 73 | `Outlaws_SetKidnapGoal` | `count` | public |
| 78 | `Outlaws_SetRaidStartTime` | `time` | public |
| 83 | `Outlaws_SetRaidDelay` | `delay` | public |
| 88 | `Outlaws_SetRaidUnitCountMin` | `min` | public |
| 93 | `Outlaws_SetRaidUnitCountMax` | `max` | public |
| 97 | `Outlaws_InitData` | `player_neutral, player_enemy, kidnap, hint_text, alert_text` | public |
| 117 | `Outlaws_FinalizeData` | `marker_name_raid, marker_name_defend, camp_count, eg_spawn_name` | public |
| 195 | `Outlaws_SetLandingRoute` | `table` | public |
| 200 | `Outlaws_SetCampTargets` | `camp_index, targets` | public |
| 205 | `Outlaws_InitRaiding` | — | public |
| 224 | `Outlaws_StartRaids` | — | public |
| 233 | `Outlaws_CheckRaidCamps` | — | public |
| 354 | `Outlaws_CheckRaidCamp` | `camp` | public |
| 500 | `Outlaws_AttackVillagers` | `raiders` | public |
| 520 | `Outlaws_GetLandingSite` | — | public |
| 562 | `Outlaws_LaunchNavalLanding` | — | public |
| 570 | `Outlaws_CheckBoardingCompletion` | — | public |
| 582 | `Outlaws_StartLandingJourney` | — | public |
| 595 | `Outlaws_CheckLandingArrival` | — | public |
| 618 | `Outlaws_CheckTransportUnload` | — | public |
| 644 | `Outlaws_WithdrawTransport` | — | public |
| 659 | `Outlaws_OnSquadKilled` | `context` | public |
| 733 | `Outlaws_RemoveKidnapKicker` | — | public |
| 737 | `Outlaws_FindCamp` | `raid_position` | public |
| 751 | `Outlaws_InitObjectives` | — | public |

### rogue\rogue_poi.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Rogue_Poi_Precache` | — | public |
| 45 | `Rogue_POI_Init` | `enemy_player, custom_unit_types, extra_poi_types, count_used_t1, count_used_t2` | public |
| 64 | `Rogue_POI_InitUnitTables` | — | public |
| 287 | `Rogue_POI_GetFavoredChampion` | — | public |
| 303 | `Rogue_POI_GetRandomChampion` | — | public |
| 309 | `Rogue_POI_GetFavoredSiege` | — | public |
| 325 | `Rogue_POI_GetRandomSiege` | — | public |
| 331 | `Rogue_POI_GetSiegeByName` | `siege_name` | public |
| 341 | `Rogue_POI_GetChampionByName` | `champion_name` | public |
| 351 | `Rogue_POI_GetFavoredNaval` | — | public |
| 369 | `Rogue_POI_GetUnitTypesByCiv` | — | public |
| 382 | `Rogue_POI_GetFavoredTypesByCiv` | — | public |
| 395 | `Rogue_POI_GetSpecialUnitByCiv` | — | public |
| 408 | `Rogue_POI_GetRandomUnitDataByCiv` | `budget` | public |
| 415 | `Rogue_POI_GetUnitDataByType` | `unit_type, budget` | public |
| 428 | `Rogue_POI_GetAllyUnitsByValue` | `units, budget` | public |
| 455 | `Rogue_POI_InitData` | `custom_unit_types, extra_poi_types` | public |
| 816 | `Rogue_POI_SetSgroupOwner` | `sgroup, player` | public |
| 830 | `Rogue_POI_SetDefaults` | `poi_table` | public |
| 871 | `Rogue_POI_Includes` | `type_data, entity_type` | public |
| 886 | `Rogue_POI_GetUnitData` | `budget_total, tier` | public |
| 911 | `Rogue_POI_GetRandomUnitType` | `tier` | public |
| 938 | `Rogue_POI_GetRandomPointType` | `tier` | public |
| 1005 | `Rogue_POI_GetRandomDirection` | — | public |
| 1010 | `Rogue_POI_SetRadii` | `marker_name` | public |
| 1019 | `Rogue_POI_Spawn` | `marker_name, custom_poi_types, tier, count_used` | public |
| 1471 | `Rogue_POI_StartTracking` | — | public |
| 1475 | `Rogue_POI_Track` | — | public |
| 1557 | `Rogue_POI_SetOwnerDelayed` | — | public |

### rogue\rogue_resource_spots.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `ResourceSpots_InitData` | `resource_weights` | public |
| 100 | `ResourceSpots_SpawnWolves` | `marker_name, spawn_chance, max_wolves` | public |
| 126 | `ResourceSpots_Init` | `marker_name, resource_type, count_used` | public |
| 195 | `ResourceSpots_GetType` | `target_class` | public |
| 223 | `ResourceSpots_CanPlayersHuntBoar` | `players` | public |
| 232 | `ResourceSpots_CanPlayerHuntBoar` | `player` | public |

### rogue\rogue_roamers.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 9 | `Roamers_Init` | — | public |
| 36 | `Roamers_AddAdditionalNodes` | `node_markers, marker_name` | public |
| 43 | `Roamers_Monitor` | `context, data` | public |
| 58 | `Roamers_RefreshTargets` | — | public |
| 70 | `Roamer_Spawn` | `state, value` | public |
| 86 | `Roamer_Init` | `value` | public |
| 107 | `Roamer_Monitor` | `roamer` | public |
| 147 | `Roamer_AttackNextNode` | `roamer` | public |
| 160 | `Roamer_AttackEnemyPosition` | `roamer, enemy_position` | public |
| 169 | `Roamer_GetEnemyPosition` | `roamer` | public |
| 190 | `Roamers_PrintDebug` | — | public |
| 201 | `Network_Init` | `node_markers, spawner_markers` | public |
| 235 | `Node_Init` | `marker, is_spawner` | public |
| 250 | `Node_AddNeighbor` | `node, neighboring_node, distance` | public |
| 257 | `Node_GetLeastVisitedNeighbor` | `node` | public |
| 273 | `Network_GetLeastUsedSpawn` | — | public |

### rogue\rogue_rounds.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 7 | `Round_Init` | `arrive_at, reserve_usage, infinite_interval` | public |
| 25 | `Round_Arrive` | `state, round, is_boss_round` | public |
| 99 | `Wave_Init` | `round, lane, desired_value, is_boss_wave` | public |
| 160 | `Subwave_Init` | `wave, sublane, subwave_template, is_boss_subwave` | public |
| 263 | `Round_Spawn` | `state, round` | public |
| 324 | `Wave_Spawn` | `state, wave, is_super_ram_wave, wave_spawn_ratio` | public |
| 351 | `Subwave_Spawn` | `state, subwave, is_super_ram_subwave, wave_spawn_ratio, is_last_subwave` | public |
| 408 | `SpawnManager_Update` | — | public |
| 419 | `SpawnManager_AddSpawn` | `state, subwave, is_super_ram_subwave, wave_spawn_ratio, is_last_subwave` | public |
| 423 | `UnitTable_Multiply` | `unit_table, ratio` | public |
| 440 | `AddHeldSquadsToArmyRecursively` | `context, data` | public |
| 488 | `CheckForHoldUnload` | `context, data` | public |
| 499 | `Subwave_Launch` | `state, subwave` | public |
| 522 | `Round_PrintSimSchedule` | `state, round` | public |
| 552 | `Round_PrintGameSchedule` | `round` | public |
| 576 | `Rounds_IdentifyWarningPosition` | — | public |
| 592 | `Rogue_CheckForIdleAttackers` | — | public |
| 604 | `Rogue_RecoverIdleAttackers` | `context, currentIdleAttackers` | public |
| 660 | `Rogue_GetAllIdleAttackers` | `sgroup` | public |
| 672 | `Rogue_IsSquadIdle` | `squad` | public |

### rogue\rogue_sites.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `Sites_Init` | `unit_name_a, unit_name_b, unit_name_c` | public |
| 37 | `Sites_Debug` | — | public |
| 44 | `Site_CreatePickup` | `marker` | public |
| 51 | `Sites_CreateRelics` | `marker_name, count_used` | public |
| 67 | `Site_CreateRelic` | `marker` | public |
| 74 | `Site_CreateCampSmall` | `marker` | public |
| 105 | `Site_CreateCampLarge` | `marker` | public |
| 131 | `Site_AddArmy` | `position, army_index, unit_table` | public |
| 153 | `Site_GetUnits` | `unit_name, value` | public |

### rogue\rogue_tech_tree.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `TechTree_Init` | — | public |
| 196 | `TechTree_GetSBP` | `unit_name` | public |
| 200 | `TechTree_GetMaxValueForRaceUnitType` | `race_unit_type` | public |
| 204 | `TechTree_GetRoamerUnits` | `value` | public |
| 247 | `TechTree_GetUpgrades` | `player, ages, include_types, exclude_types, exclude_upgrades, naval, improved_mongol` | public |
| 301 | `TechTree_GrantStartingUpgrades` | — | public |
| 351 | `TechTree_GrantCombatUpgrades` | `state, age` | public |
| 371 | `TechTree_PrintCombatUpgrades` | — | public |
| 389 | `TechTree_PrintUpgrade` | `upgrade` | public |

### rogue\rogue_wave_templates.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 3 | `WaveTemplates_Init` | — | public |
| 13 | `WaveTemplates_AutoGenerate` | — | public |
| 113 | `WaveTemplate_ComboIsValid` | `subwave_templates` | public |
| 157 | `SubwaveTemplates_AutoGenerate` | — | public |
| 181 | `SubwaveTemplate_ComboIsValid` | `unit_name_1, unit_name_2` | public |
| 209 | `SubwaveTemplate_Init` | `chosen_names` | public |
| 246 | `WaveTemplate_Init` | `subwave_templates` | public |
| 311 | `WaveTemplate_SortSubwaveTemplates` | `wave_template` | public |
| 330 | `WaveTemplate_WaveFactionCanTrain` | `wave_template` | public |
| 340 | `WaveTemplate_Choose` | `lane, faction, value, boss_archtype_name, is_first_wave` | public |
| 368 | `WaveTemplate_IsWithinValueRange` | `wave_template, faction, value` | public |
| 375 | `WaveTemplate_GenerateMinValue` | `wave_template` | public |
| 388 | `WaveTemplate_GenerateMaxValue` | `wave_template` | public |
| 425 | `ValidateOkayVsBuildings` | `wave_template` | public |

### rogue\rogue.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 24 | `Rogue_OnLoading` | — | public |
| 34 | `Rogue_OnInit` | — | public |
| 57 | `Rogue_Init_Delayed` | — | public |
| 64 | `Rogue_SimulateEvents` | — | public |
| 84 | `Rogue_Start` | — | public |
| 100 | `Rogue_Unpause` | — | public |
| 111 | `Rogue_ApplyConquerorModeStressors` | — | public |
| 135 | `Rogue_AddLane` | `name, is_locked, wave_template_validator, boss_sbp` | public |
| 144 | `Rogue_StartGatheringAt` | `time` | public |
| 151 | `Rogue_AddRoundAt` | `arrive_at, reserve_usage` | public |
| 160 | `Rogue_AgeUpAt` | `time` | public |
| 169 | `Rogue_GrantUpgrades` | `time, age` | public |
| 176 | `Rogue_IncreaseMaxLanes` | `time` | public |
| 183 | `Rogue_IncreaseMinLanes` | `time` | public |
| 188 | `Rogue_UnlockLane` | `lane_name, time` | public |
| 195 | `Rogue_AddBossWaveBefore` | `time` | public |
| 199 | `Rogue_SuperRamsEnabled` | `start, interval` | public |
| 205 | `Rogue_SpawnRoamers` | `time, value` | public |
| 209 | `Rogue_UseDefaultSchedule` | `include_boss_waves, unlock_lanes_from_start, interval_modifier` | public |
| 323 | `Rogue_AddRoundsAtDecreasingIntervals` | `first_wave_time, initial_interval, final_interval, include_boss_waves` | public |
| 396 | `Rogue_AddRepeatingRoundAt` | `first_arrival_at, interval, reserve_usage, rounds_since_break` | public |
| 430 | `Rogue_PrintIntervalString` | `round_time, is_infinite, after_boss` | public |
| 447 | `Rule_Surrender` | — | public |
| 457 | `Rogue_OnSurrenderMatchRequested` | — | public |
| 462 | `Rogue_DisableSiegeTowers` | — | public |
| 468 | `Rogue_HideWallHealthBars` | — | public |

### shieldwall.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 23 | `ShieldWall_Create` | `posA, posB, units, specialUnitsPerRow, immediate, name` | public |
| 198 | `ShieldWall_Release` | `data` | public |
| 220 | `ShieldWall_AddSGroup` | `data, sgroup` | public |
| 251 | `ShieldWall_WallUnitInPositon` | `context, data` | public |
| 299 | `ShieldWall_WallUnitKilled` | `context, data` | public |
| 404 | `ShieldWall_WallUnit_HoldGround` | `unit` | public |
| 436 | `ShieldWall_WallUnit_HoldGround_Release` | `unit` | public |

### startconditions\classic_start.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 74 | `ClassicStart_OnInit` | — | public |
| 78 | `ClassicStart_PostInit` | — | public |
| 138 | `ClassicStart_NomadRemoveAllWolves` | — | public |

### team.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 11 | `__Team_Init` | — | private |
| 72 | `Team_DefineAllies` | — | public |
| 106 | `Team_DefineEnemies` | — | public |
| 140 | `Team_CountPlayers` | `teamid` | public |
| 151 | `Team_SetTechTreeByYear` | `teamid, year` | public |
| 166 | `Team_IsAlive` | `teamid` | public |
| 178 | `Team_IsSurrendered` | `teamid, any` | public |
| 193 | `Team_HasBuilding` | `team, ebplist, any` | public |
| 207 | `Team_HasHuman` | `team, any` | public |
| 222 | `Team_HasBuildingsExcept` | `team, exceptions, any` | public |
| 237 | `Team_HasBuildingUnderConstruction` | `player, ebplist, any` | public |
| 252 | `Team_GetBuildingID` | `team, ebplist, any` | public |
| 268 | `Team_GetBuildingsCount` | `team` | public |
| 279 | `Team_GetBuildingsCountExcept` | `player, exceptions` | public |
| 290 | `Team_GetBuildingsCountOnly` | `player, ebplist` | public |
| 301 | `Team_AddResource` | `team, resource, value` | public |
| 312 | `Team_AddSquadsToSGroup` | `playerId, squadgroupName` | public |
| 325 | `Team_GetAll` | `...` | public |
| 386 | `Team_GetEntitiesFromType` | `team, unitType` | public |
| 407 | `Team_GetAllSquadsNearMarker` | `team, sgroupid, pos, range` | public |
| 427 | `Team_GetAllEntitiesNearMarker` | `team, egroupid, pos, range` | public |
| 445 | `Team_CanSee` | `teamid, itemToSee, all` | public |
| 483 | `Team_SetMaxPopulation` | `team, captype, value` | public |
| 496 | `Team_SetMaxCapPopulation` | `team, captype, value` | public |
| 508 | `Team_RestrictAddOnList` | `team, list` | public |
| 518 | `Team_RestrictBuildingList` | `team, list` | public |
| 529 | `Team_RestrictResearchList` | `team, list` | public |
| 538 | `Team_OwnsEGroup` | `team, egroupID, any` | public |
| 554 | `Team_OwnsEntity` | `team, entityID` | public |
| 569 | `Team_OwnsSGroup` | `team, sgroupID, all` | public |
| 585 | `Team_OwnsSquad` | `team, squadID` | public |
| 600 | `Team_AreSquadsNearMarker` | `team, markerID` | public |
| 612 | `Team_ClearArea` | `...` | public |
| 646 | `Team_SetUpgradeCost` | `team, upgrade, food, wood, stone, gold` | public |
| 659 | `Team_SetUpgradeAvailability` | `team, bp, availability, reason` | public |
| 667 | `Team_SetAbilityAvailability` | `team, bp, availability, reason` | public |
| 675 | `Team_SetSquadProductionAvailability` | `team, bp, availability, reason` | public |
| 683 | `Team_SetEntityProductionAvailability` | `team, bp, availability, reason` | public |
| 691 | `Team_SetCommandAvailability` | `team, command, availability, reason` | public |
| 699 | `Team_SetConstructionMenuAvailability` | `team, menu, availability, reason` | public |
| 748 | `Team_ForEachAllOrAny` | `team, all, func` | public |
| 767 | `Team_GetPlayers` | `team` | public |
| 786 | `Team_ForEachAllOrAny_LEGACY` | `team, all, func` | public |
| 807 | `Team_FindByRace` | `...` | public |
| 834 | `Team_GetEnemyTeam` | `team` | public |

### training\abbasidtrainingconditions.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `UserCannotSeeEntityKey` | `goalSequence` | public |
| 34 | `TimeHasPassedWithoutBuildingAHouseOfWisdom` | `goalSequence` | public |
| 69 | `UserIsGoingToBuildAHouseOfWisdom` | `goal` | public |
| 74 | `UserHasStartedToBuildAHouseOfWisdom` | `goal` | public |
| 83 | `TimeHasPassedAndUserCanAgeUp` | `goalSequence` | public |
| 141 | `UserHasSelectedHouseOfWisdom` | `goal` | public |
| 174 | `UserHasHouseOfWisdomCommandsCardTabOpen` | `goal` | public |
| 179 | `UserHasBegunWingUpgrade` | `goalSequence` | public |
| 200 | `UserCanBuildHouseOfWisdom` | `goalSequence` | public |
| 252 | `TimeHasPassedAndUserHasHouseOfWisdom` | `goalSequence` | public |
| 285 | `UserHasOpenedGoldenAgeMenu` | `goalSequence` | public |
| 290 | `UserHasViewedGoldenAge` | `goalSequence` | public |
| 294 | `UserHasClosedGoldenAgeMenu` | `goalSequence` | public |
| 298 | `UserHasOpenedEconomyRadialPage` | `goal` | public |

### training\abbasidtraininggoals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 27 | `AbbasidTrainingGoals_OnInit` | — | public |
| 210 | `AbbasidTrainingGoals_OnGameOver` | — | public |

### training\campaigntraininggoals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 18 | `CampaignTrainingGoals_OnInit` | — | public |
| 45 | `CampaignTrainingGoals_OnGameOver` | — | public |
| 54 | `TrainingGoal_AddLeaderRecovery` | — | public |
| 70 | `LeaderDown` | `goalSequence` | public |
| 85 | `UserIsMovingToLeader` | `goal` | public |
| 112 | `CampaignTraining_TimeoutIgnorePredicate` | `goalSequence` | public |
| 142 | `CampaignTraining_AddDiplomacyPanelHint` | `message, sequence_id` | public |
| 163 | `CampaignTraining_UserHasOpenedTheDiplomacyMenu` | — | public |
| 174 | `PredicateHelper_HasUserHoveredOverBP` | `goal, bp` | public |
| 206 | `TrainingContructionCallback` | `blueprint, phase, queueCount` | public |
| 243 | `IsEntityBeingPlacedOrBuilt` | `blueprint` | public |

### training\chinesetrainingconditions.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `UserCannotSeeEntityKey` | `goalSequence` | public |
| 29 | `HasTownCenterNoOfficial` | `goalSequence` | public |
| 71 | `UserHasSelectedTownCenter` | `goal` | public |
| 86 | `UserHasViewedOfficial` | `goal` | public |
| 101 | `UserHasBuiltOfficial` | `goal` | public |
| 126 | `UserHasBuildingWithTooMuchTax` | `goalSequence` | public |
| 151 | `UserHasSelectedBuildingWithTooMuchTax` | `goal` | public |
| 168 | `UserHasViewedFloatingBuilding` | `goal` | public |
| 190 | `UserCanAffordSecondLandmark` | `goalSequence` | public |
| 226 | `Player_CanAffordEntity` | `player, entitybp` | public |
| 241 | `UserHasSelectedVillager` | `goal` | public |
| 260 | `UserHasViewedLandmark` | `goal` | public |
| 278 | `UserHasPagodaAndIdleMonk` | `goalSequence` | public |
| 306 | `UserHasGarrisonedPagodaBypass` | `goal` | public |
| 330 | `UserGarrisonedPagoda` | `goal` | public |
| 343 | `UserHasBuiltGranary` | `goalSequence` | public |
| 370 | `UserHasBuiltFarmNearGranary` | `goal` | public |

### training\chinesetraininggoals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 33 | `ChineseTrainingGoals_OnInit` | — | public |
| 135 | `ChineseTrainingGoals_OnGameOver` | — | public |

### training\coretrainingconditions.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 25 | `GetNumGatheringSquadsAny` | — | public |
| 34 | `GetNumGatheringSquadsFood` | — | public |
| 41 | `FindVillagerInSight` | — | public |
| 57 | `FindFoodGatheringVillagerInSight` | — | public |
| 77 | `FindDecorableFoodDepositInSight` | — | public |
| 108 | `UserHasASquadSelected` | `goal` | public |
| 113 | `UserCannotSeeSquadKey` | `goalSequence` | public |
| 124 | `UserHasAUnitSelectedPredicate` | `goalSequence` | public |
| 133 | `UserHasNotSelectedAUnitRecentlyPredicate` | `goalSequence` | public |
| 150 | `UserIsMovingAnySelectedUnit` | `goalSequence` | public |
| 165 | `UserIsMovingSpecifiedSelectedUnit` | `goal` | public |
| 174 | `UserHasNotMovedASelectedVisibleUnitRecently` | `goalSequence` | public |
| 195 | `UserHasNoUnitSelected` | `goalSequence` | public |
| 202 | `ABriefPeriodOfTimeHasPassed` | `goalSequence` | public |
| 207 | `ASlightPeriodOfTimeHasPassed` | `goalSequence` | public |
| 211 | `AShortPeriodOfTimeHasPassed` | `goalSequence` | public |
| 215 | `AModeratePeriodOfTimeHasPassed` | `goalSequence` | public |
| 219 | `ALongPeriodOfTimeHasPassed` | `goalSequence` | public |
| 224 | `UserHasPannedCamera` | `goal` | public |
| 239 | `UserIsGathering` | `goalSequence` | public |
| 246 | `UserIsGatheringFood` | `goalSequence` | public |
| 253 | `AnyGoalKeysAreInvalid` | `goalSequence` | public |
| 280 | `DistanceBetweenWorldGoalsIsLong` | `goalSequence` | public |
| 307 | `GatherGoalsAreInvalid` | `goalSequence` | public |
| 312 | `TimeHasPassedWithoutGathering` | `goalSequence` | public |
| 445 | `UserHasSelectedAVillager` | `goal` | public |
| 458 | `UserHasSelectedAScout` | `goal` | public |
| 471 | `UserHasIssuedAGather` | `goal` | public |
| 492 | `UserIsBuildingAVillager` | `goalSequence` | public |
| 512 | `TimeHasPassedWithoutBuildingAVillager` | `goalSequence` | public |
| 545 | `UserHasOnlyTownCenterSelected` | `goal` | public |
| 557 | `SelectedTCHasStartedToBuildAVillager` | `goal` | public |
| 569 | `TimeHasPassedWithoutBuildingAHouse` | `goalSequence` | public |
| 601 | `UserIsGoingToBuildBuildingType` | `typeString` | public |
| 613 | `UserHasStartedToBuildABuilding` | `typeString` | public |
| 624 | `UserIsGoingToBuildAHouse` | `goal` | public |
| 628 | `UserIsGoingToBuildAFarm` | `goal` | public |
| 636 | `UserIsGoingToBuildPalisade` | `goal` | public |
| 640 | `UserIsGoingToBuildABarracks` | `goal` | public |
| 644 | `UserIsGoingToBuildDropOff` | `goal` | public |
| 656 | `UserHasStartedToBuildDropOff` | `goal` | public |
| 678 | `UserHasStartedToBuildAHouse` | `goal` | public |
| 683 | `UserHasStartedToBuildAFarm` | `goal` | public |
| 700 | `UserHasStartedToBuildPalisade` | `goal` | public |
| 704 | `UserHasStartedToBuildABarracks` | `goal` | public |
| 708 | `OnConstructionPhaseChange` | `blueprint, phase, queueCount` | public |
| 722 | `OnAbilityPhaseChange` | `blueprint, phase, queueCount` | public |
| 737 | `OnHoverChange` | `blueprint` | public |
| 741 | `UserCanBuildAWonder` | `goalSequence` | public |
| 754 | `TimeHasPassedAndUserCannotBuildAWonder` | `goalSequence` | public |
| 780 | `UserHasLookedAtWonderRequirements` | `goal` | public |
| 803 | `TimeHasPassedAndUserCanBuildAWonder_Xbox` | `goalSequence` | public |
| 828 | `TimeHasPassedAndUserCanBuildAWonder` | `goalSequence` | public |
| 863 | `HasAttachedScoutAndDropOffTownCenter` | `goalSequence` | public |
| 914 | `UserIsGoingToBuildAWonder` | `goal` | public |
| 928 | `UserIsBuildingAWonder` | `goal` | public |
| 942 | `UserHasAgedUp` | — | public |
| 946 | `UserKnowsHowToBuildWonders` | `goal` | public |
| 950 | `UserDropOffIssued` | `goal` | public |
| 954 | `UserHasIssuedADropOff` | `goalSequence` | public |
| 972 | `ScoutReturnsSheepGoalsAreInvalid` | `goalSequence` | public |
| 986 | `ShouldBuildDropOff` | `goalSequence` | public |
| 1048 | `HasScoutCarryingFoodAndDropOffTownCenter` | `goalSequence` | public |
| 1101 | `UserHasIssuedADeerDropOff` | `goalSequence` | public |
| 1109 | `DeerDropOffIssued` | `goal` | public |
| 1135 | `UserHasSelectedAnIdleVillager` | `goal` | public |
| 1171 | `SelectNextIdleIfVillagersIdle` | `goalSequence` | public |
| 1208 | `AddTagsToElements` | `elements` | public |
| 1214 | `RemoveTagsFromElements` | `elements` | public |
| 1220 | `NoIdleVillagers` | `goalSequence` | public |
| 1318 | `HasUnAttachedScoutAndDeerInSight` | `goalSequence` | public |
| 1355 | `FindDeerInSightIfNoneUnderAttack` | — | public |
| 1386 | `UserHasIssuedAttack` | `goal` | public |
| 1409 | `AnySquadKeyInvalidOrOffscreen` | `goalSequence` | public |
| 1425 | `AnySquadKeyInvalid` | `goalSequence` | public |
| 1441 | `SuggestBuildFarmCriteriaMet` | `goalSequence` | public |
| 1568 | `UserHasMultipleUnitsOnScreen` | `goalSequence` | public |
| 1611 | `UserHasMultipleUnitsForCtrlGroupOnScreen` | `goalSequence` | public |
| 1657 | `UserHasSelectedMultipleMilitaryUnits` | `goal` | public |
| 1689 | `UserHasSelectedMultipleMilitaryUnitsPredicate` | `goalSequence` | public |
| 1728 | `UserHasCreatedControlGroup` | `goal` | public |
| 2044 | `HasSiegeUnitPredicate` | `goalSequence` | public |
| 2080 | `UserHasSelectedAnIdleSiegeUnit` | `goal` | public |
| 2103 | `UserHasSetupSiegeUnit` | `goal` | public |
| 2134 | `UserHasSetupSiegeUnitInSight` | `goal` | public |
| 2175 | `UserHasRotatedCamera` | `goal` | public |
| 2265 | `UserHasControlGroup` | `goalSequence` | public |
| 2291 | `ControlGroupSelectedCallback` | `controlGroupIndex` | public |
| 2302 | `OnControlGroupSelectedComplete` | `completeReason` | public |
| 2309 | `UserHasSelectedControlGroup` | `goal` | public |
| 2319 | `ControlGroupDoesNotExist` | — | public |
| 2335 | `UserHasCreatedAnyControlGroup` | `goal` | public |
| 2358 | `UserCannotBuildDropoff` | `goal` | public |
| 2387 | `UserHasOpenedContextualRadial` | `goal` | public |
| 2391 | `UserHasClosedContextualRadial` | `goal` | public |
| 2395 | `UserHasOpenedDPadRightRadial` | `goal` | public |
| 2402 | `UserHasOpenedLandmarkRadial` | `goal` | public |
| 2408 | `ReturnCursorOrReticle` | — | public |
| 2416 | `UserHasCommandsCommandCardTabOpen` | `goal` | public |
| 2420 | `UserHasEconomicCommandCardTabOpen` | `goal` | public |
| 2424 | `UserHasMilitaryCommandCardTabOpen` | `goal` | public |
| 2428 | `UserHasVillagerCommandsCardTabOpen` | `goal` | public |
| 2432 | `UserHasVillagerEconomicCardTabOpen` | `goal` | public |
| 2436 | `UserHasVillagerMilitaryCardTabOpen` | `goal` | public |

### training\coretraininggoals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 76 | `TrainingGoal_EnableCoreControlGoals` | — | public |
| 82 | `TrainingGoal_DisableCoreControlGoals` | — | public |
| 88 | `TrainingGoal_EnableCoreEconGoals` | — | public |
| 94 | `TrainingGoal_DisableCoreEconGoals` | — | public |
| 100 | `TrainingGoal_EnableAgeUpGoals` | — | public |
| 106 | `TrainingGoal_DisableAgeUpGoals` | — | public |
| 112 | `CoreTrainingGoals_OnInit` | — | public |
| 870 | `CoreTrainingGoals_Start` | — | public |
| 878 | `CoreTrainingGoals_OnGameOver` | — | public |

### training\englishtrainingconditions.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `UserHasSelectedALongbow` | `goal` | public |
| 24 | `UserHasUsedPalingsAbility` | `goal` | public |
| 39 | `HasIdleLongbowPalingsOnScreen` | `goalSequence` | public |
| 70 | `UserIsDeployingPalingsSelectedUnit` | `goalSequence` | public |
| 87 | `HasIdleLongbowSetupCampOnScreen` | `goalSequence` | public |
| 126 | `UserHasUsedSetupCampAbility` | `goal` | public |
| 142 | `UserIsDeployingSetupCampSelectedUnit` | `goalSequence` | public |
| 158 | `HasIdleVillagerEnclosureOnScreen` | `goalSequence` | public |
| 193 | `UserHasSelectedVillager` | `goal` | public |
| 206 | `FarmHasGather` | `goal` | public |

### training\englishtraininggoals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 26 | `EnglishTrainingGoals_OnInit` | — | public |
| 96 | `EnglishTrainingGoals_OnGameOver` | — | public |

### training\frenchtraininggoals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 22 | `TrainingGoal_EnableFrenchGoals` | — | public |
| 28 | `TrainingGoal_DisableFrenchGoals` | — | public |
| 34 | `FrenchTrainingGoals_OnInit` | — | public |
| 37 | `FrenchTrainingGoals_OnGameOver` | — | public |

### training\mongoltrainingconditions.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `UserIsGoingToBuildAnOutpost` | `goal` | public |
| 17 | `UserHasStartedToBuildAnOutpost` | `goal` | public |
| 21 | `UserIsBuildingAnOutpost` | `goalSequence` | public |
| 38 | `NotUserIsBuildingAnOutpost` | `goalSequence` | public |
| 45 | `TimeHasPassedWithoutBuildingAnOutpost` | `goalSequence` | public |
| 65 | `OnConstructionPhaseChange` | `blueprint, phase, queueCount` | public |
| 81 | `UserIsGoingToBuildAnOvoo` | `goal` | public |
| 94 | `UserHasStartedToBuildAnOvoo` | `goal` | public |
| 106 | `TimeHasPassedWithoutBuildingAnOvoo` | `goalSequence` | public |
| 151 | `OvooHasDepletedAllStone` | `goalSequence` | public |
| 174 | `TimeHasPassedSinceLessonStarted` | `goal` | public |
| 185 | `KhanHasDied` | `goalSequence` | public |
| 197 | `KhanHasRespawned` | `goal` | public |
| 207 | `OvooWithoutBuildingsBuilt` | `goalSequence` | public |
| 227 | `OvooHasNearbyBuildings` | `goal` | public |
| 241 | `UserHasSelectedKhan` | `goal` | public |
| 256 | `UserCannotBuildOvoo` | `goalSequence` | public |
| 284 | `Controller_TimeHasPassedWithoutBuildingAnOvoo` | `goalSequence` | public |
| 324 | `MongolTraining_GetSelectedVillager` | — | public |
| 340 | `Controller_UserCannotBuildOvoo` | `goalSequence` | public |

### training\mongoltraininggoals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 29 | `TrainingGoal_EnableMongolGoals` | — | public |
| 35 | `TrainingGoal_DisableMongolGoals` | — | public |
| 41 | `MongolTrainingGoals_OnInit` | — | public |
| 201 | `CoreTrainingGoals_OnGameOver` | — | public |

### training\rustrainingconditions.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 12 | `UserHasSelectedAScout` | `goal` | public |
| 25 | `UserHasViewedHuntingAbility` | `goal` | public |
| 39 | `HasIdleScoutHuntingOnScreen` | `goalSequence` | public |
| 70 | `UserHasHunted` | `goalSequence` | public |
| 79 | `UserHasSelectedAVillager` | `goal` | public |
| 92 | `UserHasViewedHuntingCabin` | `goal` | public |
| 106 | `HasIdleVillagerCabinOnScreen` | `goalSequence` | public |
| 145 | `UserHasBuiltCabin` | `goalSequence` | public |
| 158 | `UserHasSelectedATradeCart` | `goal` | public |
| 171 | `HasIdleTradeCartCabinOnScreen` | `goalSequence` | public |

### training\rustraininggoals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 24 | `RusTrainingGoals_OnInit` | — | public |
| 77 | `RusTrainingGoals_OnGameOver` | — | public |

### training\sultanatetrainingconditions.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 13 | `HasActiveUpgradeWithLowScholarCount` | `goalSequence` | public |
| 44 | `UserHasSelectedMosque` | `goal` | public |
| 58 | `UserHasViewedScholar` | `goal` | public |
| 72 | `HasActiveUpgradeWithNoScholarCount` | `goalSequence` | public |
| 103 | `HasIdleScholarWithMosque` | `goalSequence` | public |
| 142 | `UserHasSelectedScholar` | `goal` | public |
| 155 | `UserHasIssuedGarrison` | `goal` | public |
| 169 | `HasIdleScholarWithMilitaryBuilding` | `goalSequence` | public |
| 217 | `HasIdleVillagerWithoutGristmill` | `goalSequence` | public |
| 255 | `UserHasViewedGristmill` | `goal` | public |

### training\sultanatetraininggoals.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 31 | `SultanateTrainingGoals_OnInit` | — | public |
| 139 | `SultanateTrainingGoals_OnGameOver` | — | public |

### ui\vizierui.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 22 | `VizierUI_OnInit` | — | public |
| 27 | `VizierUI_OnGameOver` | — | public |
| 32 | `VizierUI_Update` | — | public |

### unit_trainer.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 5 | `_UnitTrainer_InitSystem` | — | private |
| 62 | `UnitTrainer_OverrideBuildTime` | `unitTrainer, unitType, newTime` | public |
| 70 | `_UnitTrainer_Init` | `player` | private |
| 82 | `_UnitTrainer_InitPlayer` | `player` | private |
| 98 | `_UnitTrainer_NewRequestID` | — | private |
| 104 | `_UnitTrainer_CreateRequest` | `trainer, units, delay, onSpawn, onComplete, data` | private |
| 139 | `_UnitTrainer_PullUnitFromQueue` | `trainer, source, ignore_type, custom_build_time` | private |
| 160 | `_UnitTrainer_SpawnUnit` | `trainer, source, ignore_validation` | private |
| 182 | `_UnitTrainer_CompleteRequests` | `trainer` | private |
| 200 | `BuildingTrainer_Init` | `eg_buildings` | public |
| 213 | `_BuildingTrainer_InitBuildingTypes` | `buildingTrainer, eg_buildings` | private |
| 243 | `BuildingTrainer_TrainUnits` | `buildingTrainer, units, delay, onSpawn, onComplete, data` | public |
| 248 | `_UnitTrainer_ProcessDelayedRequests` | `trainer` | private |
| 258 | `_BuildingTrainer_Monitor` | `context, data` | private |
| 275 | `MapEdgeTrainer_Init` | `player, spawn, spawn_interval` | public |
| 296 | `MapEdgeTrainer_TrainUnits` | `mapEdgeTrainer, units, delay, onSpawn, onComplete, data` | public |
| 301 | `_MapEdgeTrainer_Monitor` | `context, data` | private |
| 311 | `UnitTable_Clone` | `units` | public |

### unitentry.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 224 | `UnitEntry_Spawn` | `id, dataTable` | public |
| 517 | `UnitEntry_CompleteAllImmediately` | — | public |
| 537 | `UnitEntry_CompleteImmediately` | `index` | public |
| 597 | `Util_DeploySquads` | `spawntype, player, sgroup, location, squadlist, stagger, callback, ignorepathfindinggroup, ignorepathfindingpos, ignoreformation` | public |
| 685 | `Util_RemoveValueFromArray` | `array, value` | public |
| 696 | `Util_RemoveValueFromInProcessSpawns` | `array, value` | public |

### unitexit.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 22 | `Util_ExitSquads` | `squads, exitType, contextDataTable, staggered` | public |
| 92 | `UnitExit_Manager` | — | public |
| 141 | `_UnitExit_Despawn` | `data` | private |
| 154 | `_UnitExit_DespawnNearLocation` | `data` | private |
| 182 | `_UnitExit_DespawnThing_PartB` | `id, data` | private |
| 187 | `_UnitExit_DespawnThing` | `thing, data` | private |
| 211 | `_UnitExit_CheckDone` | `data` | private |
| 234 | `UnitExit_CompleteAllImmediately` | — | public |
| 262 | `UnitEntry_NoType_StartFunc` | `data` | public |
| 273 | `UnitExit_MoveToAndDespawn_StartFunc` | `data` | public |

### winconditions\annihilation.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 63 | `Annihilation_DiplomacyEnabled` | `is_enabled` | public |
| 70 | `Annihilation_TributeEnabled` | `is_enabled` | public |
| 75 | `Annihilation_OnInit` | — | public |
| 91 | `Annihilation_Start` | — | public |
| 101 | `Annihilation_OnGameOver` | — | public |
| 110 | `Annihilation_OnConstructionComplete` | `context` | public |
| 127 | `Annihilation_OnLandmarkDestroyed` | `context` | public |
| 133 | `Annihilation_OnEntityKilled` | `context` | public |
| 138 | `Annihilation_CheckAnnihilationCondition` | `victimOwner` | public |
| 286 | `Annihilation_OnPlayerDefeated` | `player, reason` | public |
| 305 | `Annihilation_CheckVictory` | — | public |
| 360 | `Annihilation_GetActiveEnemyCount` | `player` | public |
| 380 | `Annihilation_IsACapital` | `entity` | public |
| 385 | `Annihilation_IsALandmark` | `entity` | public |
| 390 | `Annihilation_PlayerCanReceiveTribute` | `player_id` | public |
| 413 | `Annihilation_WinnerPresentation` | `playerID` | public |
| 431 | `Annihilation_LoserPresentation` | `playerID` | public |

### winconditions\conquest.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 85 | `Conquest_DiplomacyEnabled` | `isEnabled` | public |
| 91 | `Conquest_OnInit` | — | public |
| 164 | `Conquest_Start` | — | public |
| 177 | `Conquest_OnGameOver` | — | public |
| 189 | `Conquest_OnPlayerJoinedTeam` | `playerData` | public |
| 197 | `Conquest_OnConstructionComplete` | `context` | public |
| 207 | `Conquest_PostConstructionComplete` | `context, data` | public |
| 243 | `Conquest_OnDamageReceived` | `context` | public |
| 331 | `Conquest_OnPlayerDefeated` | `defeatedPlayer, reason` | public |
| 351 | `Conquest_OnLocalPlayerChanged` | `context` | public |
| 358 | `Conquest_UpdatePlayerStats` | `player, scarModel` | public |
| 378 | `Conquest_CheckElimination` | — | public |
| 548 | `Conquest_CheckVictory` | — | public |
| 603 | `Conquest_IsACapital` | `entity` | public |
| 608 | `Conquest_IsALandmark` | `entity` | public |
| 613 | `Conquest_GetPlayerLandmarkCount` | `player` | public |
| 642 | `Conquest_GetAllyLandmarkCount` | `player` | public |
| 681 | `Conquest_GetEnemyLandmarkCount` | `player` | public |
| 720 | `Conquest_GetActiveEnemyCount` | `player` | public |
| 741 | `Conquest_DestroyLandmarks` | `player` | public |
| 756 | `Conquest_AddObjective` | — | public |
| 780 | `Conquest_UpdateObjective` | — | public |
| 794 | `Conquest_RemoveObjective` | — | public |
| 802 | `Conquest_CreateEventCue` | `context, data` | public |
| 822 | `Conquest_SetPlayerDefeated` | `context, data` | public |
| 829 | `Conquest_WinnerPresentation` | `playerID` | public |
| 835 | `Conquest_DelayedWinnerPresentation` | `context, data` | public |
| 859 | `Conquest_LoserPresentation` | `playerID` | public |
| 865 | `_Conquest_RevealUI` | — | private |
| 869 | `Conquest_SetupFailStinger` | — | public |
| 877 | `Conquest_DelayedLoserPresentation` | `context, data` | public |

### winconditions\elimination.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 47 | `Elimination_DiplomacyEnabled` | `isEnabled` | public |
| 54 | `Elimination_OnPlayerAITakeover` | `context` | public |
| 81 | `Elimination_OnPlayerDefeated` | `player, reason` | public |
| 101 | `Elimination_CheckVictory` | `eliminatedPlayerId` | public |
| 154 | `Elimination_GetActiveEnemyCount` | `player` | public |
| 175 | `Elimination_WinnerPresentation` | `playerID` | public |
| 191 | `Elimination_LoserPresentation` | `playerID` | public |

### winconditions\empirewars.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 34 | `EmpireWars_OnGameSetup` | — | public |
| 44 | `EmpireWars_PreInit` | — | public |
| 54 | `EmpireWars_OnInit` | — | public |
| 90 | `EmpireWars_Start` | — | public |
| 104 | `EmpireWars_OnPlayerDefeated` | `player,reason` | public |
| 109 | `EmpireWars_OnGameOver` | — | public |
| 119 | `EmpireWars_FindBuildings` | `player` | public |
| 143 | `EmpireWars_FindTownCenter` | `player` | public |
| 166 | `EmpireWars_FindFoodMill` | `player` | public |
| 189 | `EmpireWars_FindLumberMill` | `player` | public |
| 212 | `EmpireWars_FindMiningCamp` | `player` | public |
| 235 | `EmpireWars_FindGers` | `player` | public |
| 261 | `EmpireWars_FindMosque` | `player` | public |
| 285 | `EmpireWars_FindStoneMine` | `player` | public |
| 309 | `EmpireWars_FindFarmhouse` | `player` | public |
| 336 | `EmpireWars_SpawnVillagers` | `player` | public |
| 579 | `EmpireWars_IdleHelper` | `player, villager_count, villager_bp` | public |
| 594 | `EmpireWars_BerryTaskHelper` | `player, villager_count, villager_bp` | public |
| 616 | `EmpireWars_SheepTaskHelper` | `player, villager_count, villager_bp` | public |
| 636 | `EmpireWars_CattleTaskHelper` | `player, villager_count, villager_bp` | public |
| 652 | `EmpireWars_FarmTaskHelper` | `player, villager_count, villager_bp` | public |
| 672 | `EmpireWars_WoodTaskHelper` | `player, villager_count, villager_bp` | public |
| 695 | `EmpireWars_GoldTaskHelper` | `player, villager_count, villager_bp` | public |
| 717 | `EmpireWars_StoneTaskHelper` | `player, villager_count, villager_bp` | public |
| 736 | `EmpireWars_SpawnSheep` | `player` | public |
| 755 | `EmpireWars_SpawnPrelates` | `player` | public |
| 785 | `EmpireWars_SpawnImperialOfficers` | `player` | public |
| 832 | `EmpireWars_SpawnScholars` | `player` | public |
| 850 | `EmpireWars_SpawnJoan` | `player` | public |
| 872 | `EmpireWars_QueueVillagers` | `player` | public |
| 891 | `EmpireWars_GrantVizierExp` | `player` | public |
| 902 | `EmpireWars_SetPastureRallyPoints` | `player` | public |
| 923 | `EmpireWars_GrantUpgrades` | `player` | public |
| 945 | `EmpireWars_QueueUpgrades` | `player` | public |
| 968 | `EmpireWars_SetUpStartingArea` | `player` | public |
| 975 | `EmpireWars_MaliMineSwitch` | `player` | public |
| 1004 | `EmpireWars_Temp_CountUnits` | `unitTable` | public |
| 1015 | `EmpireWars_Temp_CreateUnitsInsideEntity` | `player, units, entity_hold, sgroup` | public |
| 1053 | `EmpireWars_FindMatchingBuildings` | `player, townID, spawnSetID, structureGroupID` | public |

### winconditions\regicide.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 59 | `Regicide_OnInit` | — | public |
| 85 | `Regicide_Start` | — | public |
| 91 | `Regicide_UpdateEntityKilled` | `context` | public |
| 120 | `Regicide_UpdatePlayerKilled` | `context` | public |
| 127 | `Regicide_OnPlayerDefeated` | `player, reason` | public |
| 149 | `Regicide_SpawnKings` | — | public |
| 174 | `Regicide_SetupObjective` | — | public |
| 208 | `Regicide_UpdateObjective` | — | public |
| 224 | `Regicide_KilledKingBonus` | `player` | public |
| 242 | `Regicide_LoserPresentation` | `playerID` | public |
| 248 | `Regicide_WinnerPresentation` | `playerID` | public |
| 258 | `Regicide_GetKingSpawnPosition` | `player` | public |
| 285 | `Regicide_CheckWinner` | — | public |
| 321 | `Regicide_GetEnemyKingCount` | `player` | public |
| 341 | `Regicide_GetSquad` | `civName, entityName` | public |
| 416 | `Regicide_ConstructPresentation` | `playerID, presentationData` | public |

### winconditions\religious.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 82 | `Religious_DiplomacyEnabled` | `is_enabled` | public |
| 87 | `Religious_OnInit` | — | public |
| 127 | `Religious_Start` | — | public |
| 147 | `Religious_OnPlayerDefeated` | `player, reason` | public |
| 166 | `Religious_OnGameOver` | — | public |
| 179 | `Religious_UpdatePlayerStats` | `player, scarModel` | public |
| 188 | `Religious_Update` | — | public |
| 247 | `Religious_OnHolySiteChange` | `context` | public |
| 739 | `Religious_OnLocalPlayerChanged` | `context` | public |
| 750 | `Religious_SitesOwnedByPlayer` | `player` | public |
| 769 | `Religious_AllSitesControlled` | — | public |
| 824 | `Religious_AddObjective` | — | public |
| 880 | `Religious_UpdateObjectiveState` | — | public |
| 1136 | `Religious_UpdateObjectiveCounter` | — | public |
| 1171 | `Religious_DelayedNewObjective` | `context, data` | public |
| 1181 | `Religious_RemoveObjectives` | — | public |
| 1191 | `Religious_HolySiteMinimapBlips` | — | public |
| 1217 | `Religious_FlashAllHolySites` | — | public |
| 1261 | `Religious_WinnerPresentation` | `playerID` | public |
| 1293 | `Religious_LoserPresentation` | `playerID` | public |
| 1324 | `Religious_StopMusic` | — | public |

### winconditions\surrender.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 45 | `Surrender_DiplomacyEnabled` | `isEnabled` | public |
| 50 | `Surrender_Start` | — | public |
| 61 | `Surrender_OnSurrenderMatchRequested` | — | public |
| 71 | `Surrender_OnPlayerDefeated` | `defeatedPlayer, reason` | public |
| 95 | `Surrender_CheckVictory` | `surrenderingPlayerId` | public |
| 152 | `Surrender_GetActiveEnemyCount` | `player` | public |
| 176 | `Surrender_Notify` | `playerID` | public |
| 201 | `Surrender_WinnerPresentation` | `playerID` | public |
| 216 | `Surrender_LoserPresentation` | `playerID` | public |

### winconditions\wonder.scar

| Line | Function | Params | Visibility |
|------|----------|--------|------------|
| 102 | `Wonder_DiplomacyEnabled` | `isEnabled` | public |
| 108 | `Wonder_OnInit` | — | public |
| 160 | `Wonder_Start` | — | public |
| 191 | `Wonder_UpdatePlayerStats` | `player, scarModel` | public |
| 209 | `Wonder_OnPlayerDefeated` | `player, reason` | public |
| 222 | `Wonder_OnGameOver` | — | public |
| 244 | `Wonder_OnConstructionStart` | `context` | public |
| 295 | `Wonder_OnConstructionComplete` | `context` | public |
| 315 | `Wonder_OnConstructionCancelled` | `context` | public |
| 329 | `Wonder_OnConstructionWorkerStart` | `context` | public |
| 345 | `Wonder_OnEntityKilled` | `context` | public |
| 531 | `Wonder_OnDamageReceived` | `context` | public |
| 602 | `Wonder_OnLocalPlayerChanged` | `context` | public |
| 613 | `Wonder_Update` | — | public |
| 864 | `Wonder_CheckVictory` | — | public |
| 906 | `Wonder_AddObjective1` | `player` | public |
| 930 | `Wonder_AddObjective2` | `ownerID, wonder_entity` | public |
| 958 | `Wonder_EndWonderVictoryTimer` | `player_owner` | public |
| 969 | `Wonder_RemoveObjective2` | `player_owner` | public |
| 997 | `Wonder_RemoveObjectives` | — | public |
| 1009 | `Wonder_CreateEventCue` | `context, data` | public |
| 1027 | `Wonder_WinnerPresentation` | `playerID` | public |
| 1063 | `Wonder_LoserPresentation` | `playerID` | public |


