local DataModel = {
  ActivityId = nil,
  TurntableCA = nil,
  StationId = nil,
  BatterInfo = {},
  TurntableList = {},
  SelectIndex = nil,
  IsCityMapIn = false,
  CallBackParms = nil,
  LevelGridList = {},
  TowerScore = 0,
  IsBossBattle = false
}

function DataModel:Init(parms)
  DataModel.TurntableCA = PlayerData:GetFactoryData(parms.turntableId)
  DataModel.StationId = parms.stationId
  DataModel.SelectIndex = parms.index
  DataModel.IsCityMapIn = parms.isCityMapIn
  DataModel.IsBossBattle = parms.isBossBattle
  DataModel.ActivityId = parms.activityId
  DataModel.CallBackParms = parms.callBack
  DataModel.TurntableList = {}
  DataModel.LevelGridList = {}
  DataModel.BatterInfo = parms.batterInfo
  DataModel.TowerScore = parms.towerScore
end

function DataModel:SetData()
  for k, v in ipairs(DataModel.TurntableCA.levelBossList) do
    local index = k
    local data = DataModel.TurntableCA.levelBossList[index]
    local row = {}
    row.data = data
    row.id = data.id
    row.count = data.count
    row.star = data.star
    row.bossName = data.bossName
    row.buffId = data.buffId
    local levelList = PlayerData:GetFactoryData(row.id).levelList
    local ca = DataModel:GetCurrentLevelListData(levelList, index - 1)
    row.name = ca.levelName
    row.description = ca.description
    row.dropTableList = ca.dropTableList
    row.levelId = ca.id
    row.itemCost = ca.itemCost
    row.energyEnd = ca.energyEnd
    row.recomGrade = ca.recomGrade
    row.timeReward = ca.timeReward
    row.isEnemyLvEquilsPlayer = ca.isEnemyLvEquilsPlayer
    row.firstPassAwardS = ca.firstPassAwardS
    row.dropTableList = ca.dropTableList
    row.index = index
    row.levelCountMax = table.count(levelList)
    row.isCan = DataModel:GetBattleIsBattle(index)
    table.insert(DataModel.TurntableList, row)
  end
end

function DataModel:GetCurrentLevelListData(levelList, index)
  local count = table.count(levelList)
  local ca = PlayerData:GetFactoryData(levelList[1].id)
  local currentInfo = DataModel.BatterInfo[tostring(index)]
  if currentInfo then
    if count <= currentInfo.cnt then
      ca = PlayerData:GetFactoryData(levelList[count].id)
    elseif levelList[currentInfo.cnt + 1] then
      ca = PlayerData:GetFactoryData(levelList[currentInfo.cnt + 1].id)
    end
  end
  return ca
end

function DataModel:GetBattleIsBattle(index)
  if table.count(DataModel.BatterInfo) == table.count(DataModel.TurntableCA.levelBossList) then
    return true
  end
  if table.count(DataModel.BatterInfo) > index - 1 then
    return true
  end
  return false
end

function DataModel:GetCurrentLevelData(index, max)
  local count = 0
  local currentInfo = DataModel.BatterInfo[tostring(index)]
  if currentInfo then
    count = currentInfo.cnt
  end
  return max < count and max or count
end

function DataModel:GetMechanismNum(index)
  local list = {
    [1] = "\226\133\160",
    [2] = "\226\133\161",
    [3] = "\226\133\162",
    [4] = "\226\133\163",
    [5] = "\226\133\164"
  }
  local txt = list[index] == nil and list[#list] or list[index]
  return txt
end

function DataModel:GetBuffImg(type)
  local img_buff = "UI/Chapter/Battle_Boss/BattleBoss_buff_bg0"
  local img_ordinal = "UI/Chapter/Battle_Boss/BattleBoss_buff_circle0"
  if type then
    img_buff = "UI/Chapter/Battle_Boss/BattleBoss_buff_bg1"
    img_ordinal = "UI/Chapter/Battle_Boss/BattleBoss_buff_circle1"
  end
  return img_buff, img_ordinal
end

return DataModel
