local SignBattleLevelDataModel = require("UIActivitySignBattleLevel/UIActivitySignBattleLevelDataModel")
local DataModel = {}

function DataModel:Init(id)
  DataModel.dropList = {}
  DataModel.openIndex = nil
  DataModel.chooseLevelData = {}
  DataModel.activityCA = PlayerData:GetFactoryData(id)
  DataModel.signBattleLevelList = DataModel.activityCA.signLevelList
  local initConfig = PlayerData:GetFactoryData(99900007, "ConfigFactory")
  DataModel.maxEnergy = PlayerData:GetUserInfo().max_energy or initConfig.energyMax
  DataModel.listCount = #DataModel.activityCA.signLevelList + 2
  DataModel.imgPath = "UI/Activity/ActivitySignBattle/Images/index_"
  DataModel.imgPathFinish = "UI/Activity/ActivitySignBattle/Images/indexFinish_"
end

function DataModel.GetBattleData(id)
  DataModel.signBattleData = SignBattleLevelDataModel.signBattleData
  if id then
    DataModel.activityCA = PlayerData:GetFactoryData(id)
  end
  local cs_activity = DataModel.signBattleData
  local data = cs_activity[tostring(DataModel.activityCA.id)]
  return data
end

function DataModel.GetCurrentIndex()
  local data = DataModel.GetBattleData()
  if data == nil then
    return 0
  end
  if #data.pass_level_index < #DataModel.activityCA.signLevelList then
    return math.min(DataModel.GetUnlockIndex(), #data.pass_level_index)
  end
  return #DataModel.activityCA.signLevelList
end

function DataModel.GetUnlockIndex()
  local data = DataModel.GetBattleData()
  if data and data.unlock_level_max_index ~= nil then
    return data.unlock_level_max_index
  end
  return 0
end

function DataModel.GetFinishIndex(index)
  local data = DataModel.GetBattleData()
  if data and data.pass_level_index[index] ~= nil then
    return true
  end
  return false
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

function DataModel:GetRedState(id)
  local data = DataModel.GetBattleData(id)
  if data == nil then
    return false
  end
  if DataModel.GetUnlockIndex() + 1 > #data.pass_level_index and #DataModel.activityCA.signLevelList > #data.pass_level_index then
    return true
  end
  local ActivitySignBattleLevelDataModel = require("UIActivitySignBattleLevel/UIActivitySignBattleLevelDataModel")
  local state = ActivitySignBattleLevelDataModel:GetRewardButtonIsActive(id)
  if state == ActivitySignBattleLevelDataModel.BtnEnm.finish then
    return true
  end
  return false
end

function DataModel:GetFinish(id)
  local data = DataModel.GetBattleData(id)
  if data == nil then
    return true
  end
  if data.reward == true then
    return true
  end
  return false
end

return DataModel
