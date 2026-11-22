local module = {}
local listener = {}

local function isQuestChildQuest(id)
  id = tonumber(id)
  if id and 0 < id then
    local questCA = PlayerData:GetFactoryData(id)
    if questCA.parentQuest and 0 < questCA.parentQuest then
      return true
    end
  end
  return false
end

local function isCanSetQuestTrace(id)
  id = tonumber(id)
  if id and 0 < id then
    local questCA = PlayerData:GetFactoryData(id)
    if questCA.dontShowMain then
      return false
    else
      return true
    end
  end
  return false
end

function module.CheckCanSetQuestTrace(questId)
  return QuestProcess.CheckQuestTime(questId) and QuestProcess.CheckQuestPreConditionComplete(questId) and not isQuestChildQuest(questId) and isCanSetQuestTrace(questId)
end

function module.CheckQuestEnd()
  local questTraceInfo = PlayerData:GetQuestTrace()
  if questTraceInfo[1] ~= nil then
    local info = questTraceInfo[1]
    local curTime = TimeUtil:GetServerTimeStamp()
    if info.endTime ~= -1 and curTime >= info.endTime or not QuestProcess.CheckQuestTime(info.id) then
      PlayerData:RemoveQuestTrace()
      return nil
    end
    local questCA = PlayerData:GetFactoryData(info.id, "QuestFactory")
    if questCA and questCA.questType == "Home" then
      local stations = PlayerData:GetHomeInfo().stations
      if stations ~= nil then
        local quests = stations[tostring(questCA.startStation)].quests
        if quests ~= nil then
          for k, v in pairs(quests) do
            local v1 = v[tostring(info.id)]
            if v1 and v1.time ~= -1 then
              return info.id
            end
          end
        end
      end
      PlayerData:RemoveQuestTrace()
      return nil
    else
      local quests = PlayerData.ServerData.quests
      for k, v in pairs(quests) do
        if k == "mq_quests" or k == "branch_quests" then
          local v1 = v[tostring(info.id)]
          if v1 and v1.recv == 0 then
            return info.id
          end
        elseif k == "mark_order" then
          for k1, v1 in pairs(v) do
            for k2, v2 in pairs(v1) do
              if tonumber(v2) == info.id then
                return info.id
              end
            end
          end
        end
      end
    end
  end
  return nil
end

local cacheQuestConfigIdx = {}

function module.InitCacheQuestConfigIdx()
  local ca = PlayerData:GetFactoryData(99900116, "ConfigFactory")
  for idx, v in ipairs(ca.questList) do
    cacheQuestConfigIdx[v.id] = idx
  end
end

local cacheQuestIng = {}

function module.InitCacheQuestIng()
  cacheQuestIng = {}
  
  local function addToCache(questCA, endTime)
    if cacheQuestConfigIdx[questCA.id] then
      if cacheQuestIng[cacheQuestConfigIdx[questCA.id]] == nil then
        cacheQuestIng[cacheQuestConfigIdx[questCA.id]] = {}
      end
      local t = {}
      t.id = questCA.id
      t.endTime = endTime
      table.insert(cacheQuestIng[cacheQuestConfigIdx[questCA.id]], t)
    end
  end
  
  for k, v in pairs(PlayerData.ServerData.quests) do
    if k == "station_quests" then
      for k1, v1 in pairs(v) do
        for k2, v2 in pairs(v1) do
          if v2.time ~= -1 then
            local id = tonumber(k2)
            local questCA = PlayerData:GetFactoryData(id, "QuestFactory")
            if not questCA.dontShowMain then
              local endTime = -1
              if questCA.timeLimit ~= nil and questCA.timeLimit ~= -1 then
                endTime = v2.time + questCA.timeLimit * 3600
              else
                endTime = -1
              end
              addToCache(questCA, endTime)
            end
          end
        end
      end
    elseif k == "mq_quests" or k == "branch_quests" then
      for k1, v1 in pairs(v) do
        local id = tonumber(k1)
        local questCA = PlayerData:GetFactoryData(id, "QuestFactory")
        if questCA == nil then
          error("\228\187\187\229\138\161id:" .. id .. "\228\184\141\229\173\152\229\156\168\230\156\172\229\156\176\233\133\141\231\189\174\232\161\168,\232\175\183\230\163\128\230\159\165\233\133\141\231\189\174")
        end
        if QuestProcess.CheckQuestShow(id) and questCA.parentQuest == -1 and v1.recv == 0 and v1.unlock == 1 then
          addToCache(questCA, -1)
        end
      end
    end
  end
  ListenerManager.AddListener(ListenerManager.Enum.AcceptQuest, "CacheQuestIng", function(id)
    local questCA = PlayerData:GetFactoryData(id)
    if (questCA.questType == "Main" or questCA.questType == "Side" or questCA.questType == "Home") and QuestTrace.CheckCanSetQuestTrace(id) then
      local endTime = -1
      if questCA.questType == "Home" and questCA.timeLimit > 0 then
        endTime = TimeUtil:GetServerTimeStamp() + questCA.timeLimit * 3600
      end
      addToCache(questCA, endTime)
    end
  end)
  ListenerManager.AddListener(ListenerManager.Enum.CompleteQuest, "CacheQuestIng", function(ids)
    for _, id in ipairs(ids) do
      local questCA = PlayerData:GetFactoryData(id)
      if cacheQuestConfigIdx[id] and (questCA.questType == "Main" or questCA.questType == "Side" or questCA.questType == "Home") and QuestTrace.CheckCanSetQuestTrace(id) then
        local t = cacheQuestIng[cacheQuestConfigIdx[id]] or {}
        for idx, info in ipairs(t) do
          if info.id == id then
            table.remove(t, idx)
            if #t == 0 then
              cacheQuestIng[cacheQuestConfigIdx[id]] = nil
            end
            break
          end
        end
      end
    end
  end)
end

function module.SetQuestTrace(element, showState)
  local questId = module.CheckQuestEnd()
  local showNav = true
  if questId == nil then
    showNav = false
    if PlayerData.ServerData.quests and PlayerData.ServerData.quests.mq_quests then
      for k1, v1 in pairs(PlayerData.ServerData.quests.mq_quests) do
        local id = tonumber(k1)
        local questCA = PlayerData:GetFactoryData(id, "QuestFactory")
        if questCA == nil then
          error("\228\187\187\229\138\161id:" .. id .. "\228\184\141\229\173\152\229\156\168\230\156\172\229\156\176\233\133\141\231\189\174\232\161\168,\232\175\183\230\163\128\230\159\165\233\133\141\231\189\174")
        end
        if v1.recv == 0 and v1.unlock == 1 and QuestProcess.CheckQuestShow(id) and questCA.parentQuest == -1 and not questCA.isTBC then
          questId = id
          break
        end
      end
    end
  end
  local isShow = questId ~= nil
  
  local function setToInnerNavigation(navigationElement, questCA, showImgNav)
    if questCA then
      if questCA.startLevel and questCA.startLevel > PlayerData:GetPlayerLevel() then
        navigationElement.Txt_Target:SetActive(true)
        navigationElement.Txt_Target:SetText(string.format(GetText(80611102), questCA.startLevel))
        navigationElement.Txt_Desc:SetText(GetText(80611100))
      else
        if questCA.questType == "Home" then
          local stations = PlayerData:GetHomeInfo().stations
          local targetName = questCA.endStationList[1].id
          local sQuestId = tostring(questId)
          for k, v in pairs(stations) do
            local isFind = false
            local quests = v.quests
            if quests ~= nil then
              for k1, v1 in pairs(quests) do
                if v1[sQuestId] ~= nil and v1[sQuestId].sid ~= nil then
                  local stationCA = PlayerData:GetFactoryData(v1[sQuestId].sid, "HomeStationFactory")
                  targetName = stationCA.name
                  isFind = true
                  break
                end
              end
            end
            if isFind then
              break
            end
          end
          local showText = ""
          if questCA.cocQuestType == "Buy" and questCA.isShowProgress then
            local serverData
            local stationInfo = PlayerData:GetHomeInfo().stations[tostring(questCA.startStation)]
            if stationInfo ~= nil and stationInfo.quests.Buy ~= nil and stationInfo.quests.Buy[tostring(questCA.id)] ~= nil then
              serverData = stationInfo.quests.Buy[tostring(questCA.id)].info
            end
            local curNum = 0
            if serverData ~= nil then
              curNum = serverData[tostring(questCA.goodsList[1].id)] or 0
            end
            local maxNum = questCA.goodsList[1].num
            showText = string.format(GetText(80600776), curNum, maxNum)
          end
          navigationElement.Txt_Desc:SetText(string.format(questCA.describeNew, targetName) .. showText)
        else
          local showText = ""
          if questCA.isShowProgress then
            local curNum = 0
            local serverKey = ""
            if questCA.questType == "Main" then
              serverKey = "mq_quests"
            elseif questCA.questType == "Side" then
              serverKey = "branch_quests"
            end
            if serverKey ~= "" then
              local serverData = PlayerData.ServerData.quests[serverKey]
              if serverData and serverData[tostring(questCA.id)] then
                curNum = serverData[tostring(questCA.id)].pcnt or 0
              end
            end
            local maxNum = questCA.num
            if questCA.isFURNQuest then
              local roomData = CommonCoachData.GetRoomData(-1, true)
              local totalScoreInfo = {
                pet = 0,
                fish = 0,
                comfort = 0,
                plant = 0,
                food = 0,
                play = 0,
                medical = 0
              }
              for i, v in ipairs(roomData) do
                for i1, v1 in ipairs(v.location) do
                  local scoreInfo = PlayerData.GetFurScoreWithAllBuff(v1.id, 12601230)
                  totalScoreInfo.pet = totalScoreInfo.pet + scoreInfo.pet
                  totalScoreInfo.fish = totalScoreInfo.fish + scoreInfo.fish
                  totalScoreInfo.comfort = totalScoreInfo.comfort + scoreInfo.comfort
                  totalScoreInfo.plant = totalScoreInfo.plant + scoreInfo.plant
                  totalScoreInfo.food = totalScoreInfo.food + scoreInfo.food
                  totalScoreInfo.play = totalScoreInfo.play + scoreInfo.play
                  totalScoreInfo.medical = totalScoreInfo.medical + scoreInfo.medical
                end
              end
              for i1, condition in ipairs(questCA.conditionList) do
                local val = tonumber(condition.val)
                if condition.key == "groundId" then
                elseif condition.key == "comfortScores" then
                  curNum = totalScoreInfo.comfort
                elseif condition.key == "foodScores" then
                  curNum = totalScoreInfo.food
                elseif condition.key == "playScores" then
                  curNum = totalScoreInfo.play
                elseif condition.key == "plantScores" then
                  curNum = totalScoreInfo.plant
                elseif condition.key == "fishScores" then
                  curNum = totalScoreInfo.fish
                elseif condition.key == "petScores" then
                  curNum = totalScoreInfo.pet
                end
                curNum = math.floor(curNum)
                maxNum = val
                break
              end
            end
            showText = string.format(GetText(80600776), curNum, maxNum)
          end
          navigationElement.Txt_Desc:SetText(questCA.describeNew .. showText)
        end
        local stop_info = PlayerData:GetHomeInfo().station_info.stop_info
        local stationId = -1
        if stop_info ~= nil and stop_info[2] == -1 then
          stationId = tonumber(stop_info[1])
        end
        local showTarget = tonumber(questCA.target) == 0 and "" or questCA.target
        if 0 < stationId and #questCA.endStationList > 0 and stationId == questCA.endStationList[1].id then
          if showState == 1 then
            if not string.nilorempty(questCA.targetMain) then
              showTarget = tonumber(questCA.targetMain) == 0 and "" or questCA.targetMain
            end
          elseif showState == 2 then
            if not string.nilorempty(questCA.targetCity) then
              showTarget = tonumber(questCA.targetCity) == 0 and "" or questCA.targetCity
            elseif not string.nilorempty(questCA.targetMain) then
              showTarget = tonumber(questCA.targetMain) == 0 and "" or questCA.targetMain
            end
          end
        end
        if string.nilorempty(showTarget) then
          navigationElement.Txt_Target:SetActive(false)
        else
          navigationElement.Txt_Target:SetActive(true)
          navigationElement.Txt_Target:SetText(showTarget)
        end
      end
      local tagCA = PlayerData:GetFactoryData(questCA.typeIcon)
      navigationElement.Txt_Desc.Img_NotNav:SetSprite(tagCA and tagCA.icon)
    end
  end
  
  if isShow then
    PlayerData.TempCache.showQuest1 = questId
    local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
    setToInnerNavigation(element.Group_QuestList.Btn_Navigation, questCA, showNav)
    element.Group_QuestList.Btn_Navigation:SetActive(true)
    if QuestProcess.CheckShowRecommendLevel(questId) then
      element.Group_QuestList.Btn_Navigation.Txt_LV:SetActive(true)
      element.Group_QuestList.Btn_Navigation.Txt_LV:SetText(string.format(GetText(80609995), questCA.recommendLevel))
    else
      element.Group_QuestList.Btn_Navigation.Txt_LV:SetActive(false)
    end
  else
    element.Group_QuestList.Btn_Navigation:SetActive(false)
    element.Txt_LV:SetActive(false)
    PlayerData.TempCache.showQuest2 = -1
  end
  element.Btn_Quest.Txt_Name.Img_New:SetActive(RedpointTree:GetRedpointCnt(RedpointTree.NodeNames.Quest) > 0)
  local showId
  local defaultConfig = PlayerData:GetFactoryData(99900001)
  local state = PlayerData.GetQuestState(defaultConfig.questREC)
  if state == EnumDefine.EQuestState.Receive then
    local recWeight, info = next(cacheQuestIng)
    local nextRecWeight = recWeight
    local nextInfo = info
    while nextRecWeight ~= nil do
      nextRecWeight, nextInfo = next(cacheQuestIng, nextRecWeight)
      if nextRecWeight and recWeight > nextRecWeight then
        recWeight = nextRecWeight
        info = nextInfo
      end
    end
    if info and 0 < #info then
      showId = info[1].id
      if showId == questId and PlayerData.ServerData.quests and PlayerData.ServerData.quests.mq_quests then
        for k1, v1 in pairs(PlayerData.ServerData.quests.mq_quests) do
          local id = tonumber(k1)
          local questCA = PlayerData:GetFactoryData(id, "QuestFactory")
          if questCA == nil then
            error("\228\187\187\229\138\161id:" .. id .. "\228\184\141\229\173\152\229\156\168\230\156\172\229\156\176\233\133\141\231\189\174\232\161\168,\232\175\183\230\163\128\230\159\165\233\133\141\231\189\174")
          end
          if v1.recv == 0 and v1.unlock == 1 then
            if QuestProcess.CheckQuestShow(id) and questCA.parentQuest == -1 and not questCA.isTBC then
              showId = id
              break
            end
            showId = nil
            break
          end
        end
      end
    end
  end
  if showId and 0 < showId then
    PlayerData.TempCache.showQuest2 = showId
    local questCA = PlayerData:GetFactoryData(showId, "QuestFactory")
    setToInnerNavigation(element.Group_QuestList.Btn_Navigation2, questCA, false)
    element.Group_QuestList.Btn_Navigation2:SetActive(true)
    if QuestProcess.CheckShowRecommendLevel(showId) then
      element.Group_QuestList.Btn_Navigation2.Txt_LV:SetActive(true)
      element.Group_QuestList.Btn_Navigation2.Txt_LV:SetText(string.format(GetText(80609995), questCA.recommendLevel))
    else
      element.Group_QuestList.Btn_Navigation2.Txt_LV:SetActive(false)
    end
  else
    element.Group_QuestList.Btn_Navigation2:SetActive(false)
    PlayerData.TempCache.showQuest2 = -1
  end
end

function module.AcceptQuest(questId)
  questId = questId and tonumber(questId)
  QuestProcess.AcceptQuest(questId)
  local questTraceInfo = PlayerData:GetQuestTrace()
  local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
  if questCA.isAutoTrace or questTraceInfo == nil or #questTraceInfo == 0 then
    PlayerData:DeletePlayerPrefs("QuestRed" .. questId)
    module.AddRedNodeData(questId)
    local t = {}
    t.id = questId
    if questCA.parentQuest and 0 < questCA.parentQuest then
      return
    end
    if (questCA.questType == "Main" or questCA.questType == "Side" or questCA.questType == "Home") and (QuestTrace.CheckCanSetQuestTrace(questId) or questCA.isAutoTrace) then
      if questCA.questType == "Home" and 0 < questCA.timeLimit then
        t.endTime = TimeUtil:GetServerTimeStamp() + questCA.timeLimit * 3600
      else
        t.endTime = -1
      end
      if questCA.questType == "Home" then
        local stations = PlayerData:GetHomeInfo().stations
        if stations ~= nil then
          local quests = stations[tostring(questCA.startStation)].quests
          if quests ~= nil then
            for k, v in pairs(quests) do
              local strQuestId = tostring(questId)
              if v[strQuestId] and v[strQuestId].sid then
                t.endStation = tonumber(v[strQuestId].sid)
                break
              end
            end
          end
        end
      end
      PlayerData:SetQuestTrace({
        [1] = t
      })
    end
  elseif questTraceInfo[1].id ~= questId then
    PlayerData:DeletePlayerPrefs("QuestRed" .. questId)
    module.AddRedNodeData(questId)
  end
  ListenerManager.Broadcast(ListenerManager.Enum.AcceptQuest, questId)
end

function module.CancelQuest(questId)
  QuestProcess.CancelQuest(questId)
  questId = tonumber(questId)
  local questTraceInfo = PlayerData:GetQuestTrace()
  if questTraceInfo[1] ~= nil then
    local info = questTraceInfo[1]
    if info.id == questId then
      PlayerData:RemoveQuestTrace()
    end
  end
  PlayerData:DeletePlayerPrefs("QuestRed" .. questId)
  module.DeleteRedNodeData(questId)
end

local function findMainQuest()
  local quests = PlayerData.ServerData.quests.mq_quests
  for k, v in pairs(quests) do
    local id = tonumber(k)
    local questCA = PlayerData:GetFactoryData(id)
    if v.recv == 0 and v.unlock == 1 and QuestTrace.CheckCanSetQuestTrace(id) and not questCA.isTBC then
      local t = {}
      t.id = id
      t.endTime = -1
      return t
    end
  end
  return nil
end

local function findSideQuest()
  local quests = PlayerData.ServerData.quests.branch_quests
  for k, v in pairs(quests) do
    local id = tonumber(k)
    if v.recv == 0 and v.unlock == 1 and QuestTrace.CheckCanSetQuestTrace(id) then
      local t = {}
      t.id = id
      t.endTime = -1
      return t
    end
  end
  return nil
end

local function findHomeQuest(stationId)
  local function findQuest(quests)
    if quests ~= nil then
      for k, v in pairs(quests) do
        for k1, v1 in pairs(v) do
          if v1.time ~= -1 then
            local t = {}
            
            t.id = tonumber(k1)
            local questCA = PlayerData:GetFactoryData(t.id, "QuestFactory")
            if questCA.timeLimit ~= nil and questCA.timeLimit ~= -1 then
              t.endTime = v1.time + questCA.timeLimit * 3600
            else
              t.endTime = -1
            end
            t.endStation = v1.sid and tonumber(v1.sid) or questCA.endStationList[1].id
            return t
          end
        end
      end
    end
    return nil
  end
  
  local stations = PlayerData:GetHomeInfo().stations
  if stationId == nil then
    local station_info = PlayerData:GetHomeInfo().station_info
    if station_info ~= nil then
      local stop_info = station_info.stop_info
      if stop_info ~= nil and stop_info[2] == -1 then
        local curStayId = tonumber(stop_info[1])
        stationId = curStayId
      end
    end
  end
  local t
  if stationId ~= nil then
    local quests = stations[tostring(stationId)].quests
    t = findQuest(quests)
    if t ~= nil then
      return t
    end
  end
  for sId, sValue in pairs(stations) do
    if tonumber(sId) ~= stationId then
      local quests = sValue.quests
      t = findQuest(quests)
      if t ~= nil then
        return t
      end
    end
  end
  return t
end

local function AutoSetQuestTrace(questId)
  local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
  local toTraceQuestId
  if questCA.nextQuest ~= nil and #questCA.nextQuest > 0 then
    for i, v in ipairs(questCA.nextQuest) do
      if QuestTrace.CheckCanSetQuestTrace(v.id) then
        toTraceQuestId = v.id
        break
      end
    end
  end
  if toTraceQuestId then
    local t = {}
    t.id = toTraceQuestId
    t.endTime = -1
    return t
  else
    local t
    local findFunc = {}
    if questCA.questType == "Main" then
      t = findMainQuest()
      if t ~= nil then
        return t
      end
      findFunc[1] = findSideQuest
      findFunc[2] = findHomeQuest
    elseif questCA.questType == "Side" then
      t = findSideQuest()
      if t ~= nil then
        return t
      end
      findFunc[1] = findMainQuest
      findFunc[2] = findHomeQuest
    elseif questCA.questType == "Home" then
      t = findHomeQuest(questCA.startStation)
      if t ~= nil then
        return t
      end
      findFunc[1] = findMainQuest
      findFunc[2] = findSideQuest
    end
    for k, v in pairs(findFunc) do
      t = v()
      if t ~= nil then
        return t
      end
    end
  end
  return nil
end

local function IsChildQuest(parentQuestId, childQuestId)
  local questCA = PlayerData:GetFactoryData(childQuestId, "QuestFactory")
  if questCA and questCA.parentQuest == parentQuestId then
    return true
  end
  return false
end

function module.HaveMainQuest()
  local quests = PlayerData.ServerData.quests.mq_quests
  for k, v in pairs(quests) do
    local id = tonumber(k)
    local questCA = PlayerData:GetFactoryData(id)
    if v.recv == 0 and v.unlock == 1 and QuestTrace.CheckCanSetQuestTrace(id) and not questCA.isTBC and questCA.mod == "\229\159\186\231\161\128\228\187\187\229\138\161" then
      return id
    end
  end
  return 0
end

function module.CompleteQuestOne(questId)
  questId = tonumber(questId)
  QuestProcess.CompleteQuest(questId)
  local questTraceInfo = PlayerData:GetQuestTrace()
  local cacheTraceId
  if questTraceInfo[1] ~= nil then
    local info = questTraceInfo[1]
    if info.id == questId then
      local t = AutoSetQuestTrace(questId)
      cacheTraceId = questId
      if t ~= nil then
        PlayerData:SetQuestTrace({
          [1] = t
        })
      else
        PlayerData:RemoveQuestTrace()
      end
    elseif IsChildQuest(info.id, questId) then
      cacheTraceId = questId
    end
    SdkReporter.TrackTaskComplete({taskId = questId})
  end
  ListenerManager.Broadcast(ListenerManager.Enum.CompleteQuest, {questId})
  if cacheTraceId then
    ListenerManager.Broadcast(ListenerManager.Enum.CompleteQuestInQuestTrace, cacheTraceId)
  end
end

function module.CompleteQuest(questIds)
  local questTraceInfo = PlayerData:GetQuestTrace()
  local cacheTraceIds = {}
  if questTraceInfo[1] ~= nil then
    local info = questTraceInfo[1]
    for k, v in pairs(questIds) do
      local questId = tonumber(v)
      QuestProcess.CompleteQuest(questId)
      if info.id == questId then
        local t = AutoSetQuestTrace(questId)
        table.insert(cacheTraceIds, questId)
        if t ~= nil then
          PlayerData:SetQuestTrace({
            [1] = t
          })
        else
          PlayerData:RemoveQuestTrace()
        end
      elseif IsChildQuest(info.id, questId) then
        table.insert(cacheTraceIds, questId)
      end
      SdkReporter.TrackTaskComplete({taskId = questId})
    end
  end
  ListenerManager.Broadcast(ListenerManager.Enum.CompleteQuest, questIds)
  for k, v in ipairs(cacheTraceIds) do
    ListenerManager.Broadcast(ListenerManager.Enum.CompleteQuestInQuestTrace, v)
  end
end

local function GetViewNode(url, nodePathStr)
  if not UIManager:IsPanelOpened(url) then
    return nil
  end
  local index = string.lastIndexOf(url, "/")
  local viewPath = string.sub(url, index + 1)
  local View = require("UI" .. viewPath .. "/UI" .. viewPath .. "View")
  local node
  if View then
    local nodePath = {}
    local pattern = "[^" .. "%." .. "]+"
    for str in string.gmatch(nodePathStr, pattern) do
      table.insert(nodePath, str)
    end
    node = View
    local nextNum = false
    local idx = 1
    while nodePath[idx] ~= nil do
      local next
      local nodeName = nodePath[idx]
      if nextNum then
        local num = tonumber(string.sub(nodeName, #nodeName - 1))
        if num ~= nil then
          nextNum = false
          next = node[num + 1]
        end
      else
        next = node[nodeName]
      end
      if next then
        node = next
      elseif node.grid then
        node = node.grid
        nextNum = true
        if nodeName ~= "grid" and nodeName ~= "Grid" then
          idx = idx - 1
        end
      end
      idx = idx + 1
    end
  end
  return node
end

local function GetQuestStartStation(questId)
  local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
  return questCA.startStation or -1
end

local function GetQuestEndStation(questId)
  local quest = PlayerData:GetQuestTrace()
  for k, v in pairs(quest) do
    if questId == v.id and v.endStation and tonumber(v.endStation) > 0 then
      return v.endStation
    end
  end
  local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
  if questCA.endStationList and #questCA.endStationList == 1 then
    return questCA.endStationList[1].id
  end
  if questCA.questType == "Home" then
    local stations = PlayerData:GetHomeInfo().stations
    if stations ~= nil then
      local quests = stations[tostring(questCA.startStation)].quests
      if quests ~= nil then
        for k, v in pairs(quests) do
          local strQuestId = tostring(questId)
          if v[strQuestId] and v[strQuestId].sid then
            return tonumber(v[strQuestId].sid)
          end
        end
      end
    end
  end
  return -1
end

local function IsInStation(url, questId, intVal, stringVal, factoryVal)
  local station_info = PlayerData:GetHomeInfo().station_info
  if station_info ~= nil then
    local stop_info = station_info.stop_info
    if stop_info ~= nil and stop_info[2] == -1 then
      local curStayId = tonumber(stop_info[1])
      if curStayId == factoryVal then
        return true
      end
    end
  end
  return false
end

local function IsActivated(url, questId, intVal, stringVal, factoryVal)
  local node = GetViewNode(url, stringVal)
  if node then
    if node.self then
      node = node.self
    end
    return node.IsActive
  end
  return false
end

local function IsArrived(url, questId, intVal, stringVal, factoryVal)
  local isArrived = PlayerData:GetHomeInfo().station_info.is_arrived == 1
  local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
  if 0 < factoryVal then
    return isArrived and factoryVal == TradeDataModel.EndCity
  end
  return isArrived
end

local function IsEnoughGoods(url, questId, intVal, stringVal, factoryVal)
  local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
  local isEnough = false
  local serverQuestInfo = PlayerData:GetHomeInfo().stations[tostring(questCA.startStation)].quests.Buy[tostring(questId)]
  if serverQuestInfo then
    isEnough = true
    for k, v in pairs(questCA.goodsList) do
      local curNum = PlayerData:GetGoodsById(v.id).num
      local needNum = v.num
      local curPcnt = serverQuestInfo.info[tostring(v.id)] or 0
      isEnough = isEnough and curNum >= needNum - curPcnt
    end
  end
  return isEnough
end

local function IsInStartStation(url, questId, intVal, stringVal, factoryVal)
  local startStationId = GetQuestStartStation(questId)
  if 0 < startStationId then
    return IsInStation(url, questId, intVal, stringVal, startStationId)
  end
  return false
end

local function IsInEndStation(url, questId, intVal, stringVal, factoryVal)
  local endStationId = GetQuestEndStation(questId)
  if 0 < endStationId then
    return IsInStation(url, questId, intVal, stringVal, endStationId)
  end
  return false
end

local function IsArrivedStartStation(url, questId, intVal, stringVal, factoryVal)
  local startStationId = GetQuestStartStation(questId)
  if 0 < startStationId then
    return IsArrived(url, questId, intVal, stringVal, startStationId)
  end
  return false
end

local function IsArrivedEndStation(url, questId, intVal, stringVal, factoryVal)
  local endStationId = GetQuestEndStation(questId)
  if 0 < endStationId then
    return IsArrived(url, questId, intVal, stringVal, endStationId)
  end
  return false
end

local keyFuncList = {
  IsInStation = IsInStation,
  IsActivated = IsActivated,
  IsArrived = IsArrived,
  IsEnoughGoods = IsEnoughGoods,
  IsInStartStation = IsInStartStation,
  IsInEndStation = IsInEndStation,
  IsArrivedStartStation = IsArrivedStartStation,
  IsArrivedEndStation = IsArrivedEndStation
}
local cacheQuestIdsInfo = {}
local curQuestTrace = {}
local cacheCurUrl = ""

local function DynamicShowRedNode(quest, url, setExtraBtnClick, parentQuestId)
  if parentQuestId == nil then
    parentQuestId = 0
  end
  for k1, v1 in pairs(cacheQuestIdsInfo) do
    local redNode = v1.redNode
    if v1.isShow and redNode and not redNode:IsNull() then
      redNode:HideDynamicGameObject()
      v1.isShow = false
    end
  end
  local cacheRedNodePath = {}
  for k, v in pairs(quest) do
    local questCA = PlayerData:GetFactoryData(k)
    if not questCA.startLevel or not (questCA.startLevel > PlayerData:GetPlayerLevel()) then
      if questCA.childQuestList and 0 < #questCA.childQuestList then
        local t = {}
        for k1, v1 in pairs(questCA.childQuestList) do
          if PlayerData:IsHaveQuest(v1.id) and not PlayerData.IsQuestComplete(v1.id) then
            t[v1.id] = 0
          end
        end
        DynamicShowRedNode(t, url, true, k)
      else
        local traceId = 0
        local btnListId = 0
        local apiListId = 0
        for k1, v1 in pairs(questCA.traceList) do
          if v1.uiPath == url then
            traceId = v1.traceId
            btnListId = v1.btnListId
            apiListId = v1.apiListId
            if cacheQuestIdsInfo[k] == nil then
              cacheQuestIdsInfo[k] = {}
            end
            cacheQuestIdsInfo[k].url = v1.uiPath
            cacheQuestIdsInfo[k].parentQuestId = parentQuestId
            print_r("\228\187\187\229\138\161\232\191\189\232\184\170Log..." .. "\228\187\187\229\138\161Id : " .. k .. "  \232\191\189\232\184\170\233\133\141\231\189\174Id : " .. traceId)
            break
          end
        end
        if 0 < apiListId and cacheQuestIdsInfo[k].triggerProtocol == nil then
          local t = {}
          cacheQuestIdsInfo[k].triggerProtocol = t
          local listCA = PlayerData:GetFactoryData(apiListId, "ListFactory")
          for k1, v1 in pairs(listCA.apiList) do
            t[v1.api] = 0
          end
        end
        if setExtraBtnClick and 0 < btnListId then
          local listCA = PlayerData:GetFactoryData(btnListId, "ListFactory")
          
          local function extraClickFunc()
            DynamicShowRedNode(curQuestTrace, url, false)
          end
          
          for k1, v1 in pairs(listCA.btnList) do
            local node = GetViewNode(url, v1.btnPath)
            if node and node.self then
              node = node.self
            end
            if node and node.SetExtraBtnClick then
              node:SetExtraBtnClick(extraClickFunc)
            end
          end
        end
        if 0 < traceId then
          local listCA = PlayerData:GetFactoryData(traceId, "QuestTrackFactory")
          local state = 0
          for k1, v1 in pairs(listCA.keyList) do
            local getResult = 0
            if keyFuncList[v1.key](url, k, v1.intVal, v1.stringVal, v1.factoryVal) then
              getResult = MathEx.pow(2, k1 - 1)
            end
            state = state + getResult
          end
          print_r("\228\187\187\229\138\161\232\191\189\232\184\170Log..." .. "\229\189\147\229\137\141\231\138\182\230\128\129 : " .. state)
          for k1, v1 in pairs(listCA.stateList) do
            if v1.stateNo == state then
              local cache = cacheQuestIdsInfo[k]
              local nodePath = ""
              if v1.tipsType == "StartStation" then
                local startStationId = GetQuestStartStation(k)
                local stationCA = PlayerData:GetFactoryData(startStationId, "HomeStationFactory")
                if stationCA then
                  nodePath = stationCA.nodePath
                end
              elseif v1.tipsType == "EndStation" then
                local endStationId = GetQuestEndStation(k)
                local stationCA = PlayerData:GetFactoryData(endStationId, "HomeStationFactory")
                if stationCA then
                  nodePath = stationCA.nodePath
                end
              elseif v1.tipsType == "BubbleId" then
                local cityMapDataModel = require("UICityMap/UICityMapDataModel")
                for i, info in ipairs(cityMapDataModel.curShowBubbleList) do
                  if info.id == v1.mId then
                    nodePath = string.format(v1.nodePath, i)
                    break
                  end
                end
              elseif v1.tipsType == "BubbleType" then
                local cityMapDataModel = require("UICityMap/UICityMapDataModel")
                for i, info in ipairs(cityMapDataModel.curShowBubbleList) do
                  if v1.bubbleType == info.bubbleCA.btnType then
                    nodePath = string.format(v1.nodePath, i)
                    break
                  end
                end
              else
                nodePath = v1.nodePath
              end
              if nodePath ~= nil and nodePath ~= "" and cacheRedNodePath[nodePath] == nil then
                cacheRedNodePath[nodePath] = 0
                local node = GetViewNode(url, nodePath)
                if node then
                  if node.self then
                    node = node.self
                  end
                  local prefab = v1.prefab
                  if url == "UI/MainUI/MainUI" then
                    prefab = prefab .. "_Main"
                  end
                  node:SetDynamicGameObject(prefab, v1.offsetX, v1.offsetY)
                  cache.redNode = node
                  cache.isShow = true
                  break
                end
              end
            end
          end
        end
      end
    end
  end
end

local function QuestTraceUIShow(url, setExtraBtnClick)
  if setExtraBtnClick == nil then
    setExtraBtnClick = true
  end
  DynamicShowRedNode(curQuestTrace, url, setExtraBtnClick)
end

local cacheUrlTipOrPop = {
  ["UI/HomeUpgrade/HomeBubble"] = true,
  ["UI/HomeUpgrade/HomeBubblePet"] = true,
  ["UI/InsZone/InsZone"] = true,
  [UIPath.UIGuide] = true
}

local function ToOpenPanelCallback(url)
  if cacheUrlTipOrPop[url] then
    return
  elseif cacheUrlTipOrPop[url] == nil and GuideManager:IsPanelTipOrPop(url) then
    cacheUrlTipOrPop[url] = true
    return
  end
  cacheCurUrl = url
  cacheUrlTipOrPop[url] = false
  QuestTraceUIShow(url, true)
end

function module.ProtocolCallback(protocolName)
  for k, v in pairs(cacheQuestIdsInfo) do
    if v.triggerProtocol and v.triggerProtocol[protocolName] and UIManager:IsPanelOpened(v.url) then
      QuestTraceUIShow(v.url)
      break
    end
  end
end

local isAddEvent = false

local function CheckIsHomeQuest(questId)
  local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
  if questCA and questCA.startStation > 0 then
    local quests = PlayerData:GetHomeInfo().stations[tostring(questCA.startStation)].quests
    if quests ~= nil then
      local questType = questCA.cocQuestType
      local questServerInfo = quests[questType]
      if questServerInfo and questServerInfo[tostring(questId)] then
        questServerInfo = questServerInfo[tostring(questId)]
        local endTime = 0
        if questCA.timeLimit ~= nil and 0 < questCA.timeLimit then
          endTime = questServerInfo.time + questCA.timeLimit * 3600
        end
        return endTime < TimeUtil:GetServerTimeStamp()
      end
    end
  end
  return false
end

function module.AddOpenPanelCallBack()
  if not isAddEvent then
    isAddEvent = true
    EventManager:AddOpenPanelEvent(ToOpenPanelCallback)
  end
  module.InitCacheQuestConfigIdx()
  module.InitCacheQuestIng()
  cacheQuestIdsInfo = {}
  curQuestTrace = {}
  local questTrace = PlayerData:GetQuestTrace()
  if questTrace[1] ~= nil then
    local info = questTrace[1]
    local curTime = TimeUtil:GetServerTimeStamp()
    if info.endTime ~= -1 and curTime >= info.endTime or not QuestProcess.CheckQuestTime(info.id) then
      PlayerData:RemoveQuestTrace()
      questTrace = {}
    end
  end
  for k, v in pairs(questTrace) do
    local isOk = PlayerData:IsHaveQuest(v.id, {
      "mq_quests",
      "branch_quests"
    })
    isOk = isOk or CheckIsHomeQuest(v.id)
    if isOk then
      curQuestTrace[v.id] = 0
    end
  end
  ListenerManager.AddListener(ListenerManager.Enum.SetQuestTrace, "QuestTraceUIShow", function(id)
    curQuestTrace[id] = 0
    if cacheCurUrl ~= "" then
      DynamicShowRedNode(curQuestTrace, cacheCurUrl, true)
    end
    PlayerData:SetPlayerPrefs("int", "QuestRed" .. id, 1)
    module.DeleteRedNodeData(id)
  end)
  ListenerManager.AddListener(ListenerManager.Enum.CompleteQuestInQuestTrace, "QuestTraceUIShow", function(id)
    curQuestTrace[id] = nil
    
    local function func(param)
      if cacheQuestIdsInfo[param] then
        local redNode = cacheQuestIdsInfo[param].redNode
        if cacheQuestIdsInfo[param].isShow and not redNode:IsNull() then
          redNode:HideDynamicGameObject()
        end
      end
      cacheQuestIdsInfo[param] = nil
    end
    
    func(id)
    local questCA = PlayerData:GetFactoryData(id, "QuestFactory")
    if questCA.childQuestList then
      for k, v in pairs(questCA.childQuestList) do
        func(v.id)
      end
    end
    if cacheCurUrl ~= "" and questCA.parentQuest and questCA.parentQuest > 0 then
      DynamicShowRedNode({
        [questCA.parentQuest] = 0
      }, cacheCurUrl, true)
    end
  end)
  ListenerManager.AddListener(ListenerManager.Enum.RemoveQuestTrace, "QuestTraceUIShow", function(id)
    curQuestTrace[id] = nil
    local info = cacheQuestIdsInfo[id]
    if info then
      local redNode = info.redNode
      if info.isShow and redNode and not redNode:IsNull() then
        redNode:HideDynamicGameObject()
        info.isShow = false
      end
    end
    cacheQuestIdsInfo[id] = nil
    local questCA = PlayerData:GetFactoryData(id)
    if questCA and questCA.childQuestList then
      for k, v in pairs(questCA.childQuestList) do
        info = cacheQuestIdsInfo[v.id]
        if info then
          local redNode = info.redNode
          if info.isShow and redNode and not redNode:IsNull() then
            redNode:HideDynamicGameObject()
            info.isShow = false
          end
        end
        cacheQuestIdsInfo[v.id] = nil
      end
    end
  end)
  ListenerManager.AddListener(ListenerManager.Enum.CompleteQuest, "QuestTraceUIShow", function(ids)
    for i, questId in pairs(ids) do
      PlayerData:DeletePlayerPrefs("QuestRed" .. questId)
      module.DeleteRedNodeData(questId)
    end
  end)
  if table.count(curQuestTrace) == 0 then
    local findFunc = {}
    findFunc[1] = findMainQuest
    findFunc[2] = findSideQuest
    findFunc[3] = findHomeQuest
    for k, v in pairs(findFunc) do
      t = v()
      if t ~= nil then
        PlayerData:SetQuestTrace({
          [1] = t
        })
        break
      end
    end
  end
end

function module.RemoveOpenPanelCallBack()
  if isAddEvent then
    isAddEvent = false
    EventManager:RemoveOpenPanelEvent(ToOpenPanelCallback)
  end
end

function module.ClearQuestTraceInfo()
  module.RemoveOpenPanelCallBack()
  cacheQuestIdsInfo = {}
  curQuestTrace = {}
  cacheCurUrl = ""
end

function module.AddRedNodeData(questId)
  questId = tonumber(questId)
  if not QuestProcess.CheckQuestShow(questId) then
    return false
  end
  local questCA = PlayerData:GetFactoryData(questId)
  local redNodeName
  if questCA.questType == "Main" then
    redNodeName = RedpointTree.NodeNames.QuestMain
  elseif questCA.questType == "Side" then
    redNodeName = RedpointTree.NodeNames.QuestSide
  elseif questCA.questType == "Home" then
    redNodeName = RedpointTree.NodeNames.QuestHome
  elseif questCA.questType == "Order" then
    redNodeName = RedpointTree.NodeNames.QuestOrder
  end
  if redNodeName then
    local keyName = redNodeName .. "|" .. questId
    RedpointTree:InsertNode(keyName)
    RedpointTree:ChangeRedpointCnt(keyName, 1)
    return true
  end
  return false
end

function module.DeleteRedNodeData(questId)
  local redNodeName
  local questCA = PlayerData:GetFactoryData(questId)
  if questCA.questType == "Main" then
    redNodeName = RedpointTree.NodeNames.QuestMain
  elseif questCA.questType == "Side" then
    redNodeName = RedpointTree.NodeNames.QuestSide
  elseif questCA.questType == "Home" then
    redNodeName = RedpointTree.NodeNames.QuestHome
  elseif questCA.questType == "Order" then
    redNodeName = RedpointTree.NodeNames.QuestOrder
  end
  if redNodeName then
    local keyName = redNodeName .. "|" .. questId
    RedpointTree:ChangeRedpointCnt(keyName, -1)
    return RedpointTree:DeleteNode(keyName)
  end
  return false
end

function module.CheckQuestCanReceive()
  local homeCommon = require("Common/HomeCommon")
  local totalScoreInfo
  local branchQuests = PlayerData.ServerData.quests.branch_quests
  for k1, v1 in pairs(branchQuests) do
    local id = tonumber(k1)
    local questCA = PlayerData:GetFactoryData(id, "QuestFactory")
    if questCA == nil then
      error("\228\187\187\229\138\161id:" .. id .. "\228\184\141\229\173\152\229\156\168\230\156\172\229\156\176\233\133\141\231\189\174\232\161\168,\232\175\183\230\163\128\230\159\165\233\133\141\231\189\174")
    end
    if QuestProcess.CheckQuestShow(id) and questCA.parentQuest == -1 and v1.recv == 0 and v1.unlock == 1 then
      local pcnt = v1.pcnt
      if questCA.isFURNQuest then
        if totalScoreInfo == nil then
          totalScoreInfo = homeCommon.GetTotalFurScoreInfo(-1)
        end
        local checkOk, curNum, maxNum = homeCommon.CheckClientScoreQuest(totalScoreInfo, questCA)
        if checkOk then
          pcnt = questCA.num
        end
      end
      if questCA.isShowReceive and pcnt >= questCA.num then
        return true
      end
    end
  end
  return false
end

return module
