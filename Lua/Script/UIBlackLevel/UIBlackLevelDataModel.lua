local DataModel = {}

function DataModel:Init(id)
  DataModel.dropList = {}
  DataModel.openIndex = nil
  DataModel.chooseLevelData = {}
  DataModel.activityCA = PlayerData:GetFactoryData(id)
  DataModel.blackLevelList = DataModel.activityCA.blackLevelList
  local initConfig = PlayerData:GetFactoryData(99900007, "ConfigFactory")
  DataModel.maxEnergy = PlayerData:GetUserInfo().max_energy or initConfig.energyMax
  DataModel.constAutoBattleTime = 3
  DataModel.blackLevelAutoBattleTime = 3
  DataModel.blackLevelAutoBattle = false
end

function DataModel.GetEnergy()
  return PlayerData:GetGoodsById(11400006).num
end

function DataModel:SetDropList(levelCA)
  DataModel.dropList = {}
  local isReceived = PlayerData:GetLevelFirstRewardsReceived(levelCA.id)
  local firstPassAward = levelCA.firstPassAward
  for i = 1, #firstPassAward do
    table.insert(DataModel.dropList, {
      num = firstPassAward[i].num,
      id = firstPassAward[i].itemId,
      type = 1,
      isFinish = isReceived,
      index = #DataModel.dropList
    })
  end
  local dropListNew = PlayerData:GetLevelDropList(levelCA)
  for i = 1, #dropListNew do
    table.insert(DataModel.dropList, {
      num = dropListNew[i].num,
      id = dropListNew[i].id,
      type = 2,
      index = #DataModel.dropList
    })
  end
  if isReceived == true then
    table.sort(DataModel.dropList, function(a, b)
      if a.type == b.type then
        return a.index < b.index
      end
      return a.type > b.type
    end)
  else
    table.sort(DataModel.dropList, function(a, b)
      if a.type == b.type then
        return a.index < b.index
      end
      return a.type < b.type
    end)
  end
end

return DataModel
