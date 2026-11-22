local DataModel = {
  Top = {
    {id = 11400007, isSpecial = false},
    {
      id = 11400005,
      isSpecial = true,
      key = "bm_rock"
    }
  },
  CardPool = {
    [1] = {},
    [2] = {}
  },
  Index = 1,
  anecdoteQuestId = -1,
  TabIndex = 1,
  GachaType = 1,
  DataID = "",
  MoneyId = 0,
  CommodityId = 0,
  ItemLimitTime = -1,
  TabType = {
    Activaty = 1,
    Plot = 2,
    Permanent = 3
  }
}

function DataModel:GetCardPool()
  for i, v in pairs(self.CardPool) do
    for i1, v1 in pairs(v) do
      if v1.detail.timeFunc ~= nil then
        EventManager:RemoveOnSecondEvent(v1.detail.timeFunc)
        v1.detail.timeFunc = nil
      end
      if v1.detail.timeFunc1 ~= nil then
        EventManager:RemoveOnSecondEvent(v1.detail.timeFunc1)
        v1.detail.timeFunc1 = nil
      end
    end
  end
  self.CardPool = {}
  for i, v in pairs(DataModel.TabType) do
    self.CardPool[v] = {}
  end
  self.TabIndex = 0
  local factoryData = PlayerData:GetCardGacha()
  for i, v in pairs(factoryData) do
    if v.id and DataModel:GetLocalBannerConfig(v.id) then
      local gacheCA = PlayerData:GetFactoryData(v.id)
      if (v.deadline == "" and v.start_ts == "" or v.deadline ~= "" and v.deadline > -1 and v.deadline > TimeUtil:GetServerTimeStamp() and v.start_ts < TimeUtil:GetServerTimeStamp()) and gacheCA.questId and (0 > gacheCA.questId or PlayerData.IsQuestComplete(gacheCA.questId)) then
        local poolNum = 0
        local poolData = PlayerData.ServerData.cards[tostring(gacheCA.id)]
        if poolData ~= nil then
          poolNum = poolData.pool_num or 0
        end
        if gacheCA.closeNum == nil then
          error("\229\141\161\230\177\160id: " .. gacheCA.id .. " \233\133\141\231\189\174\231\188\186\229\176\145\229\173\151\230\174\181'closeNum'")
        end
        if gacheCA.closeNum == -1 or poolNum < gacheCA.closeNum then
          local item = {
            data = gacheCA,
            server = PlayerData.ServerData.cards[tostring(gacheCA.id)] or {},
            detail = {},
            gachaServer = v
          }
          local tabType = gacheCA.groupInt + 1
          table.insert(self.CardPool[tabType], item)
          if self.TabIndex == 0 then
            self.TabIndex = tabType
          end
          if gacheCA.isActBanner then
            item.red = DataModel:GetCardGachaRed(v.id, 1)
          else
            item.red = DataModel.NowCardPoolIsRedPoint(gacheCA.id)
          end
        end
      end
    end
  end
end

function DataModel.NowCardPoolIsRedPoint(poolId)
  local data = PlayerData:GetFactoryData(poolId)
  if data.isRedPoint == false then
    return false
  end
  local lastSaveTs = PlayerData:GetPlayerPrefs("int", poolId)
  local poolEndTs = 1
  if data.endTime and data.endTime ~= "" then
    poolEndTs = TimeUtil:TimeStamp(data.endTime)
  end
  return lastSaveTs < poolEndTs
end

function DataModel.SavePoolRedPoint(tabIndex, index)
  local poolData = DataModel.CardPool[tabIndex][index]
  if poolData == nil then
    return
  end
  local poolId = poolData.data.id
  local data = PlayerData:GetFactoryData(poolId)
  local poolEndTs = 9999
  if data.endTime and data.endTime ~= "" then
    poolEndTs = TimeUtil:TimeStamp(data.endTime)
  end
  PlayerData:SetPlayerPrefs("int", poolId, poolEndTs)
  poolData.red = false
end

function DataModel.GachaIsRedPoint()
  local factoryData = PlayerData:GetCardGacha()
  for i, v in pairs(factoryData) do
    if v.id and DataModel:GetLocalBannerConfig(v.id) then
      local gacheCA = PlayerData:GetFactoryData(v.id)
      if (v.deadline == "" and v.start_ts == "" or v.deadline ~= "" and v.deadline > -1 and v.deadline > TimeUtil:GetServerTimeStamp() and v.start_ts < TimeUtil:GetServerTimeStamp()) and gacheCA.questId and (gacheCA.questId < 0 or PlayerData.IsQuestComplete(gacheCA.questId)) then
        local questRed = DataModel:GetCardGachaRed(v.id, 1)
        if questRed then
          return questRed
        end
        if gacheCA.isActBanner then
          local isRed
          isRed = DataModel:GetCardGachaRed(v.id, 1)
          if isRed then
            return isRed
          end
        else
          local poolNum = 0
          local poolData = PlayerData.ServerData.cards[tostring(gacheCA.id)]
          if poolData ~= nil then
            poolNum = poolData.pool_num or 0
          end
          if gacheCA.closeNum == nil then
            return false
          end
          if gacheCA.closeNum == -1 or poolNum < gacheCA.closeNum then
            local red = DataModel.NowCardPoolIsRedPoint(gacheCA.id)
            if red then
              return true
            end
          end
        end
      end
    end
  end
  return false
end

function DataModel:RefreshCardGacha(id)
  if id == nil then
    return
  end
  local gachaData = PlayerData:GetCardGacha()
  for k, v in pairs(gachaData) do
    if v.id and DataModel:GetLocalBannerConfig(v.id) then
      local ca = PlayerData:GetFactoryData(v.id)
      if v.deadline == -1 and v.id == tostring(id) then
        local duration = ca.duration
        v.start_ts = TimeUtil:GetServerTimeStamp()
        v.deadline = v.start_ts + duration * 86400
        break
      end
    end
  end
end

function DataModel:SetActivityCardGacha(activityId)
  if activityId == nil or PlayerData:GetFactoryData(activityId) == nil then
    return
  end
  local bannerList = PlayerData:GetFactoryData(activityId).bannerList
  if bannerList == nil or table.count(bannerList) == 0 then
    return
  end
  for m, n in pairs(bannerList) do
    if DataModel:GetCardGachaRed(n.id, 10) == false then
      DataModel:SetCardGachaRed(n.id, 1)
      DataModel:RefreshCardGacha(n.id)
    end
  end
end

function DataModel:SetQuestCardGachaMain(quest)
  for k, v in pairs(quest) do
    if k == "mq_quests" or k == "branch_quests" then
      for c, d in pairs(v) do
        DataModel:SetQuestCardGacha(c, k)
      end
    end
  end
end

function DataModel:SetQuestCardGacha(questId, type)
  local questCA
  questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
  if questCA == nil then
    error("\228\187\187\229\138\161id:" .. questId .. "\228\184\141\229\173\152\229\156\168\230\156\172\229\156\176\233\133\141\231\189\174\232\161\168,\232\175\183\230\163\128\230\159\165\233\133\141\231\189\174")
  end
  local serverKey = type or ""
  if type == nil then
    if questCA.questType == "Main" then
      serverKey = "mq_quests"
    elseif questCA.questType == "Side" then
      serverKey = "branch_quests"
    end
  end
  if serverKey ~= "" and questCA.bannerList and table.count(questCA.bannerList) > 0 then
    for m, n in pairs(questCA.bannerList) do
      if DataModel:GetCardGachaRed(n.id, 10) == false then
        DataModel:SetCardGachaRed(n.id, 1)
        DataModel:RefreshCardGacha(n.id)
      end
    end
  end
end

function DataModel:GetCardGachaRed(id, value)
  if id then
    local isCan = PlayerData:GetPlayerPrefs("int", "CardGachaRed" .. id)
    if isCan == value then
      return true
    end
  end
  return false
end

function DataModel:SetCardGachaRed(id, value)
  if id then
    PlayerData:SetPlayerPrefs("int", "CardGachaRed" .. id, value)
  end
end

function DataModel:GetLocalBannerConfig(id)
  if id == nil then
    return false
  end
  local ExtractFactoryData = CacheAndGetFactory("ExtractFactory")
  return ExtractFactoryData[tonumber(id)]
end

return DataModel
