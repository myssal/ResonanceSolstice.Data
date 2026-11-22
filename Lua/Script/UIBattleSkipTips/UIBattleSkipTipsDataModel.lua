local DataModel = {
  Enum = {
    MainUI = "MainUI",
    Chapter = "Chapter",
    College = "College",
    LevelChain = "LevelChain",
    Monopoly = "Monopoly"
  },
  Current = nil,
  curSquadIndex = 1,
  curSquad = {},
  curLevelId = 0,
  hasLevelRole = false,
  curRefreshElement = nil,
  curDetailIndex = 1,
  curSelectIndex = 1,
  SquadEquip = {},
  Equipments = {},
  LastRoleIndex = nil,
  InitRoleList = {},
  TopColumn = 1,
  ttbSid = nil,
  ttbIndex = nil,
  ttbId = nil,
  dialogId = 0,
  friendId = 0,
  gridId = 0
}

function DataModel:Init(status)
  if status == nil then
    return nil
  end
  DataModel.Current = status.Current
  DataModel.RoleData = nil
  DataModel.curLevelId = nil
  DataModel.isHighChallenge = nil
  if status.Current ~= "MainUI" then
    DataModel.curLevelId = PlayerData.BattleInfo.battleStageId
  end
  DataModel.curDetailIndex = status.curDetailIndex or 1
  DataModel.curSquadIndex = status.curSquadIndex or 1
  if status.squadIndex ~= nil then
    DataModel.curSquadIndex = status.squadIndex
  end
  if DataModel.curSquadIndex == 0 then
    DataModel.curSquadIndex = 1
  end
  DataModel.curSquad = PlayerData.ServerData.squad[DataModel.curSquadIndex]
  if status.hasOpenThreeView ~= nil then
    DataModel.hasOpenThreeView = status.hasOpenThreeView
  end
  DataModel.eventId = status.eventId
  DataModel.level_key = status.level_key
  DataModel.minEnemyLevel = status.minEnemyLevel or 1
  DataModel.difficulty = status.difficulty or 1
  DataModel.bgId = status.bgId
  DataModel.enemyLevel = status.enemyLevel
  DataModel.enemyRn = status.enemyRn
  DataModel.lineWeatherIdList = status.lineWeatherIdList
  DataModel.lineWeatherRateSN = status.lineWeatherRateSN
  DataModel.areaId = status.areaId
  DataModel.enemy_ids = status.enemy_ids
  DataModel.enemyLevelOffset = status.enemyLevelOffset
  DataModel.secondWeatherList = status.secondWeatherList
  DataModel.trainWeaponSkill = status.trainWeaponSkill
  DataModel.headerExtraSkill = status.headerExtraSkill
  DataModel.ttbSid = status.ttbSid
  DataModel.ttbIndex = status.ttbIndex
  DataModel.ttbId = status.ttbId
  DataModel.isLockDiff = status.isLockDiff
  DataModel.serverIdx = status.serverIdx
  DataModel.canArrestEnemy = nil
end

return DataModel
