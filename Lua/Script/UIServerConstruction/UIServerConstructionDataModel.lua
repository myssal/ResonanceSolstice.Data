local CardPackDataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
local DataModel = {
  allStage = {},
  isAll = true,
  activityCA = {},
  gridTextId = 80606885,
  gridIcon = "UI/Activity/Construction/AnitaRocketBase/Quest/icon_onereward",
  listState = {
    notFinish = 1,
    finish = 2,
    recv = 3
  },
  serverRed = false,
  personalRed = false
}

function DataModel.InitData()
  DataModel.allStage = {}
  DataModel.activityCA = PlayerData:GetFactoryData(DataModel.activityId, "ActivityFactory")
  local allStage = {}
  if DataModel.isAll then
    allStage = DataModel.activityCA.allConstructionList
    DataModel.gridTextId = "80606886"
    DataModel.gridIcon = "UI/Activity/Construction/AnitaRocketBase/Quest/icon_allreward"
  else
    allStage = DataModel.activityCA.personalConstructionList
    DataModel.gridTextId = "80606885"
    DataModel.gridIcon = "UI/Activity/Construction/AnitaRocketBase/Quest/icon_onereward"
  end
  DataModel.serverRed = DataModel:GetRedPointState("all", DataModel.activityCA.id)
  DataModel.personalRed = DataModel:GetRedPointState("one", DataModel.activityCA.id)
  for k, v in ipairs(allStage) do
    local row = Clone(v)
    row.max_num = 0
    row.now_num = 0
    row.isRecv_index = 0
    row.isFinish = false
    row.limit = v.limit
    row.state = DataModel.listState.notFinish
    if DataModel.isAll then
      row.max_num = v.construction
      row.now_num = PlayerData:GetActivityServerConstructionCstNum(DataModel.activityCA.id)
      row.isFinish = row.now_num >= row.max_num and true or false
      row.isRecv_index = PlayerData:GetActivityServerConstructionPerRewardState(DataModel.activityCA.id, k - 1) == true and 1 or 0
    else
      row.max_num = v.construction
      row.now_num = PlayerData:GetActivityPersonalConstructionCstNum(DataModel.activityCA.id)
      row.isFinish = row.now_num >= row.max_num and true or false
      row.isRecv_index = PlayerData:GetActivityPersonalConstructionPerRewardState(DataModel.activityCA.id, k - 1) == true and 1 or 0
    end
    if row.isFinish == false and row.isRecv_index == 0 then
      row.state = DataModel.listState.notFinish
    end
    if row.isFinish and row.isRecv_index == 0 then
      if row.limit and 0 < row.limit then
        local per_maxNum = DataModel.activityCA.personalConstructionList[row.limit].construction
        local per_nowNum = PlayerData:GetActivityPersonalConstructionCstNum(DataModel.activityCA.id)
        local per_finish = per_maxNum <= per_nowNum and true or false
        if per_finish then
          row.state = DataModel.listState.finish
        end
      else
        row.state = DataModel.listState.finish
      end
    end
    if row.isRecv_index == 1 then
      row.state = DataModel.listState.recv
    end
    row.index = k
    row.rewardList = PlayerData:GetFactoryData(v.id).rewardList
    table.insert(DataModel.allStage, row)
  end
  table.sort(DataModel.allStage, function(a, b)
    if a.isRecv_index == b.isRecv_index then
      return a.index < b.index
    end
    return a.isRecv_index < b.isRecv_index
  end)
end

function DataModel:GetRedPointState(type, activityId)
  if activityId == nil then
    return false
  end
  local allStage = {}
  local activityCA = PlayerData:GetFactoryData(activityId)
  local isAll = type == "all"
  if isAll then
    allStage = activityCA.allConstructionList
  else
    allStage = activityCA.personalConstructionList
  end
  for k, v in ipairs(allStage) do
    local row = Clone(v)
    row.max_num = 0
    row.now_num = 0
    row.isRecv_index = 0
    row.isFinish = false
    if isAll then
      row.max_num = v.construction
      row.now_num = PlayerData:GetActivityServerConstructionCstNum(activityCA.id)
      row.isFinish = row.now_num >= row.max_num and true or false
      row.isRecv_index = PlayerData:GetActivityServerConstructionPerRewardState(activityCA.id, k - 1) == true and 1 or 0
    else
      row.max_num = v.construction
      row.now_num = PlayerData:GetActivityPersonalConstructionCstNum(activityCA.id)
      row.isFinish = row.now_num >= row.max_num and true or false
      row.isRecv_index = PlayerData:GetActivityPersonalConstructionPerRewardState(activityCA.id, k - 1) == true and 1 or 0
    end
    if row.isFinish and row.isRecv_index == 0 then
      if row.limit and 0 < row.limit then
        local per_maxNum = activityCA.personalConstructionList[row.limit].construction
        local per_nowNum = PlayerData:GetActivityPersonalConstructionCstNum(activityCA.id)
        local per_finish = per_maxNum <= per_nowNum and true or false
        if per_finish then
          return true
        end
      else
        return true
      end
    end
  end
  return false
end

function DataModel:GetStageType()
  local type = "person"
  if DataModel.isAll then
    type = "server"
  end
  return type
end

function DataModel:GetConstructionIsFinish(activityId)
  if activityId == nil then
    return false
  end
  local activityCA = PlayerData:GetFactoryData(activityId)
  local card_isFinish = false
  local personal_isFinish = false
  local server_isFinish = false
  if activityCA.activityCardPack > 0 then
    local cardPackInfo = CardPackDataModel.GetCardPackInfo(activityCA.activityCardPack)
    if cardPackInfo.extraCardStatus == 2 and cardPackInfo.allCount == cardPackInfo.ownCount then
      card_isFinish = true
    end
  end
  local personalConstructionList = activityCA.personalConstructionList
  local personalAllCount = table.count(personalConstructionList)
  local personalCount = 0
  for k, v in ipairs(personalConstructionList) do
    local row = Clone(v)
    row.max_num = 0
    row.now_num = 0
    row.isRecv_index = 0
    row.isFinish = false
    row.max_num = v.construction
    row.now_num = PlayerData:GetActivityPersonalConstructionCstNum(activityCA.id)
    row.isFinish = row.now_num >= row.max_num and true or false
    row.isRecv_index = PlayerData:GetActivityPersonalConstructionPerRewardState(activityCA.id, k - 1) == true and 1 or 0
    if row.isRecv_index == 1 then
      personalCount = personalCount + 1
    end
  end
  if personalAllCount == personalCount then
    personal_isFinish = true
  end
  local allConstructionList = activityCA.allConstructionList
  local serverAllCount = table.count(allConstructionList)
  local serverCount = 0
  for k, v in ipairs(allConstructionList) do
    local row = Clone(v)
    row.max_num = 0
    row.now_num = 0
    row.isRecv_index = 0
    row.isFinish = false
    row.max_num = v.construction
    row.now_num = PlayerData:GetActivityServerConstructionCstNum(activityCA.id)
    row.isFinish = row.now_num >= row.max_num and true or false
    row.isRecv_index = PlayerData:GetActivityServerConstructionPerRewardState(activityCA.id, k - 1) == true and 1 or 0
    if row.isRecv_index == 1 then
      serverCount = serverCount + 1
    end
  end
  if serverAllCount == serverCount then
    server_isFinish = true
  end
  if card_isFinish and personal_isFinish and server_isFinish then
    return true
  end
  return false
end

return DataModel
