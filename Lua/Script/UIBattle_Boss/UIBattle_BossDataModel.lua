local DataModel = {
  IsCityMapIn = false,
  TurntableCA = nil,
  StationId = nil,
  SelectIndex = nil,
  BatterInfo = {},
  TurntableList = {},
  TargetTransform = nil,
  OffestNum = 360,
  SpeedNum = 360,
  CallBackParms = nil,
  IsAcivity = false,
  ActivityId = nil,
  isBattleEnd = false,
  LastLevelId = nil,
  ListVerticalLayout = nil,
  constTime = 1,
  remainTime = 1
}

function DataModel:Init(parms)
  DataModel.TurntableCA = PlayerData:GetFactoryData(parms.turntableId)
  DataModel.StationId = parms.stationId
  DataModel.SelectIndex = parms.index
  DataModel.TargetTransform = nil
  DataModel.IsCityMapIn = parms.isCityMapIn
  DataModel.IsAcivity = parms.isActivity
  DataModel.ActivityId = parms.activityId
  DataModel.CallBackParms = parms.callBack
  DataModel.isBattleEnd = parms.levelId ~= nil
  DataModel.LastLevelId = parms.levelId
end

function DataModel:GetRedDotStatus()
  local activeCA = PlayerData:GetFactoryData(86000005)
  local stationCA = PlayerData:GetFactoryData(activeCA.correspondingCity[1].id)
  local turntableBattleCA = PlayerData:GetFactoryData(stationCA.turntableId)
  if PlayerData:GetUserInfo().lv < turntableBattleCA.openLv then
    return false
  end
  return PlayerData.plot_paragraph[tostring(turntableBattleCA.FirstParagraphid)] == nil
end

function DataModel:GetPlayerLvAvailable(index, unlockLv)
  return unlockLv <= PlayerData:GetPlayerLevel()
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

function DataModel:GetLevelIdIndex(levelId)
  local count = 1
  if levelId == nil then
    return count
  end
  for k, v in pairs(DataModel.TurntableList) do
    if v.levelId == levelId then
      count = k
    end
  end
  return count
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

function DataModel:SetData(element, index)
  element.self:SetActive(true)
  local data = DataModel.TurntableCA.levelBossList[index]
  if data == nil then
    element.Group_Off.self:SetActive(false)
    element.Group_On.self:SetActive(false)
    element.Group_Lock.self:SetActive(false)
    element.Group_No.self:SetActive(true)
    element.Img_Select:SetActive(false)
    return
  end
  local row = {}
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
  element.Group_On.self:SetActive(row.isCan)
  element.Group_On.Btn_Select:SetClickParam(index)
  element.Img_Select:SetActive(false)
  local levelProgress = PlayerData:GetPreciseDecimalFloor(DataModel:GetCurrentLevelData(index - 1, row.levelCountMax) / row.levelCountMax * 100, 1)
  element.Group_On.Txt_Progress:SetText(levelProgress .. "%")
  if row.isCan then
    local bossId = ca.bossId
    local bossCA = PlayerData:GetFactoryData(bossId, "UnitFactory")
    local viewId = bossCA.viewId
    local viewCA = PlayerData:GetFactoryData(viewId, "UnitViewFactory")
    element.Group_On.Img_Mask.Spine_Head:SetData(viewCA.resDir)
    element.Group_On.Img_Mask.Spine_Head:SetAnchoredPosition(Vector2(data.spineX, data.spineY))
    element.Group_On.Img_Mask.Spine_Head:SetLocalScale(Vector3.one * data.spineScale)
  end
  row.levelsPlayerLvLimit = DataModel:GetPlayerLvLimit(levelList)
  local unlockLv = 0
  if next(row.levelsPlayerLvLimit) then
    unlockLv = row.levelsPlayerLvLimit[1]
  end
  local isLvAvailable = DataModel:GetPlayerLvAvailable(index, unlockLv)
  row.playerLvAvailable = isLvAvailable
  element.Group_Lock:SetActive(not isLvAvailable)
  element.Group_Off.self:SetActive(not row.isCan and isLvAvailable)
  if not isLvAvailable then
    element.Group_Lock.Txt_Lv:SetText(string.format(GetText(80611292), unlockLv))
  end
end

function DataModel:GetPlayerLvLimit(levelList)
  local lvLimitList = {}
  for i = 1, #levelList do
    local ca = PlayerData:GetFactoryData(levelList[i].id)
    if next(ca) then
      table.insert(lvLimitList, ca.playerLevel)
    end
  end
  return lvLimitList
end

function DataModel:GetCurrentLevelData(index, max)
  local count = 0
  local currentInfo = DataModel.BatterInfo[tostring(index)]
  if currentInfo then
    count = currentInfo.cnt
  end
  return max < count and max or count
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
