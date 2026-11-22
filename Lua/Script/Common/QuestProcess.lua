local module = {}
local cacheQuest = {}
local questCallBack = {}
local cachedCompleted = false

local function InvokeQuestCallBack(id)
  local curUrl = UIManager:GetCurrentPanelURL()
  if questCallBack[curUrl] then
    questCallBack[curUrl]()
  end
end

function module.AcceptQuest(id)
  if cacheQuest[id] == nil then
    local questCA = PlayerData:GetFactoryData(id)
    local questServer = PlayerData.ServerData.quests
    if questCA.questType == "Main" then
      questServer = questServer.mq_quests[tostring(id)]
    elseif questCA.questType == "Side" then
      questServer = questServer.branch_quests[tostring(id)]
    end
    if questServer then
      local t = {}
      t.id = id
      t.endTime = -1
      cacheQuest[id] = t
    end
  end
end

function module.CancelQuest(id)
  cacheQuest[id] = nil
  InvokeQuestCallBack(id)
end

function module.CompleteQuest(id)
  cacheQuest[id] = nil
  InvokeQuestCallBack(id)
end

function module.UpdateCacheQuest(force)
  if not force and cachedCompleted then
    return
  end
  cachedCompleted = true
  cacheQuest = {}
  for k, v in pairs(PlayerData.ServerData.quests) do
    if k == "mq_quests" or k == "branch_quests" then
      for k1, v1 in pairs(v) do
        local id = tonumber(k1)
        local questCA = PlayerData:GetFactoryData(id, "QuestFactory")
        if questCA == nil then
          error("\228\187\187\229\138\161id:" .. id .. "\228\184\141\229\173\152\229\156\168\230\156\172\229\156\176\233\133\141\231\189\174\232\161\168,\232\175\183\230\163\128\230\159\165\233\133\141\231\189\174")
        end
        if v1.recv == 0 and v1.unlock == 1 then
          local t = {}
          t.id = id
          t.endTime = -1
          cacheQuest[id] = t
        end
      end
    end
  end
end

local function detailDoCheck(selfInfo)
  if not module.CheckQuestTime(selfInfo.questId) then
    CommonTips.OpenTips(80602659)
    return false
  end
  if selfInfo.url ~= nil and selfInfo.url ~= "" and UIManager:GetCurrentPanelURL() ~= selfInfo.url then
    return false
  end
  return true
end

local function ActionToDialog(selfInfo)
  if not detailDoCheck(selfInfo) then
    return false
  end
  if UIManager:IsPanelOpened(UIPath.UIDialog) then
    return false
  end
  local NPCDialog = require("Common/NPCDialog")
  NPCDialog.ClearAllSound()
  UIManager:Open(UIPath.UIDialog, Json.encode({
    id = selfInfo.eventId
  }))
  return true
end

local function ActionToLevel(selfInfo)
  if not detailDoCheck(selfInfo) then
    return false
  end
  if UIManager:IsPanelOpened("UI/Squads/Squads") then
    return false
  end
  local status = selfInfo.status
  if status == nil then
    status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false
    }
  end
  PlayerData.Last_Chapter_Parms = nil
  PlayerData.BattleInfo.battleStageId = selfInfo.eventId
  PlayerData.BattleCallBackPage = selfInfo.url
  UIManager:Open("UI/Squads/Squads", Json.encode(status))
  return true
end

local function ActionToDungeon(selfInfo)
  if not detailDoCheck(selfInfo) then
    return false
  end
  local status = {}
  status.chapterId = selfInfo.eventId
  status.startNew = true
  status.GoBackUI = selfInfo.url
  if selfInfo.status and selfInfo.status.extraUIParamData then
    status.GoBackUIParam = Json.encode(selfInfo.status.extraUIParamData)
    status.scene = selfInfo.status.extraUIParamData.scene
  end
  PlayerData.Last_Chapter_Parms = status
  PlayerData.BattleCallBackPage = "UI/InsZone/InsZone"
  UIManager:Open("UI/InsZone/InsZone", Json.encode(status))
  return true
end

local function MainAction(selfInfo)
  local isOk = false
  if selfInfo.eventType == "Dialog" then
    isOk = ActionToDialog(selfInfo)
  elseif selfInfo.eventType == "Level" then
    isOk = ActionToLevel(selfInfo)
  elseif selfInfo.eventType == "Dungeon" then
    isOk = ActionToDungeon(selfInfo)
  end
  if isOk then
    PlayerData.TempCache.AutoQuestEvent[selfInfo.eventId] = 1
  end
  return isOk
end

function module.IsHaveEventOpen(id)
  id = tonumber(id)
  if not cachedCompleted then
    module.UpdateCacheQuest()
  end
  if 0 < id then
    local ca = PlayerData:GetFactoryData(id)
    if ca == nil then
      return false
    end
    for i, v in ipairs(ca.eventList) do
      if cacheQuest[v.questId] and module.CheckQuestTime(v.questId) and module.CheckQuestPreConditionComplete(v.questId) and module.CheckQuestStartLevel(v.questId) then
        return true
      end
    end
  end
  return false
end

local cacheEventOpen = {}

function module.GetCacheEventList()
  return cacheEventOpen
end

function module.CheckEventOpen(id, params)
  cacheEventOpen = {}
  id = tonumber(id)
  if not cachedCompleted then
    module.UpdateCacheQuest()
  end
  if 0 < id then
    local ca = PlayerData:GetFactoryData(id)
    if ca == nil then
      return {}
    end
    local returnTable = {}
    
    local function addToReturn(addInfo, addTable, param)
      local t = {}
      for k, v in pairs(addInfo) do
        t[k] = v
      end
      if param ~= nil then
        for k, v in pairs(param) do
          t[k] = v
        end
      end
      t.action = MainAction
      table.insert(addTable, t)
    end
    
    for i, v in ipairs(ca.eventList) do
      if cacheQuest[v.questId] and module.CheckQuestTime(v.questId) and module.CheckQuestPreConditionComplete(v.questId) and module.CheckQuestStartLevel(v.questId) then
        addToReturn(v, returnTable, params)
      end
    end
    local tempAutoEvent
    for i, v in ipairs(returnTable) do
      if v.isAuto and PlayerData.TempCache.AutoQuestEvent[v.eventId] == nil then
        tempAutoEvent = v
        break
      end
    end
    if tempAutoEvent and not GuideHelper.HasGuide() and tempAutoEvent:action() then
      return {}
    end
    cacheEventOpen = returnTable
    return returnTable
  end
  return {}
end

function module.CheckQuestTime(questId)
  questId = tonumber(questId)
  if questId and 0 < questId then
    local questCA = PlayerData:GetFactoryData(questId)
    if questCA == nil then
      return false
    end
    return module.CheckTime(questCA.activityId, questCA.startTime, questCA.endTime)
  end
  return false
end

function module.CheckQuestPreConditionComplete(questId)
  questId = tonumber(questId)
  if questId and 0 < questId then
    local questCA = PlayerData:GetFactoryData(questId)
    if questCA == nil then
      return false
    end
    if PlayerData:GetPlayerLevel() < (questCA.preLv or 0) then
      return false
    end
    if (questCA.questType == "Main" or questCA.questType == "Side") and questCA.preQuestId and 0 < questCA.preQuestId then
      local strPreId = tostring(questCA.preQuestId)
      local mainQuest = PlayerData.ServerData.quests.mq_quests
      local preQuestInfo = mainQuest[strPreId]
      if preQuestInfo == nil then
        local branchQuest = PlayerData.ServerData.quests.branch_quests
        preQuestInfo = branchQuest[strPreId]
      end
      if preQuestInfo == nil or 0 >= preQuestInfo.recv then
        return false
      end
    end
    return true
  end
  return false
end

function module.CheckQuestStartLevel(questId)
  questId = tonumber(questId)
  if questId and 0 < questId then
    local questCA = PlayerData:GetFactoryData(questId)
    if questCA == nil then
      return false
    end
    return questCA.startLevel and PlayerData:GetPlayerLevel() >= questCA.startLevel
  end
  return false
end

function module.GetQuestEndTime(questId)
  if 0 < questId then
    local questCA = PlayerData:GetFactoryData(questId)
    local endTimeStr = ""
    if questCA.activityId and 0 < questCA.activityId then
      local activityCA = PlayerData:GetFactoryData(questCA.activityId)
      if activityCA.isTime then
        endTimeStr = activityCA.endTime
      end
    else
      endTimeStr = questCA.endTime
    end
    if endTimeStr ~= "" then
      return TimeUtil:TimeStamp(endTimeStr)
    end
  end
  return -1
end

function module.CheckTime(activityId, startTime, endTime)
  local function innerCheckTime(innerStartTime, innerEndTime)
    local curTime = TimeUtil:GetServerTimeStamp()
    
    if innerStartTime ~= nil and innerStartTime ~= "" then
      local startTimeStamp = TimeUtil:TimeStamp(innerStartTime)
      if curTime < startTimeStamp then
        return false
      end
    end
    if innerEndTime == nil or innerEndTime == "" then
      return true
    else
      local endTimeStamp = TimeUtil:TimeStamp(innerEndTime)
      return curTime <= endTimeStamp
    end
  end
  
  if activityId and 0 < activityId then
    local activityCA = PlayerData:GetFactoryData(activityId)
    if activityCA.isJoin then
      local res = PlayerData:GetActivityAct(activityId)
      if not res then
        return false
      end
    end
    if activityCA.isTriggerTime and PlayerData:GetActivityAct(activityId) then
      local curTime = TimeUtil:GetServerTimeStamp()
      local activityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
      local timeList = activityMainDataModel.IsActiveNewTimeOpen(activityId)
      if timeList then
        local check = true
        if timeList.acEndTime and type(timeList.acEndTime) == "number" and 0 < timeList.acEndTime then
          check = check and false
        end
        return check
      end
    end
    if activityCA.isTime then
      local res = innerCheckTime(activityCA.startTime, activityCA.endTime)
      if res then
        return res
      end
    else
      return true
    end
  elseif startTime ~= "" or endTime ~= "" then
    local res = innerCheckTime(startTime, endTime)
    if res then
      return res
    end
  else
    return true
  end
  return false
end

function module.CheckOnlyTime(activityId, startTime, endTime)
  local function innerCheckTime(innerStartTime, innerEndTime)
    local curTime = TimeUtil:GetServerTimeStamp()
    
    if innerStartTime ~= nil and innerStartTime ~= "" then
      local startTimeStamp = TimeUtil:TimeStamp(innerStartTime)
      if curTime < startTimeStamp then
        return false
      end
    end
    if innerEndTime == nil or innerEndTime == "" then
      return true
    else
      local endTimeStamp = TimeUtil:TimeStamp(innerEndTime)
      return curTime <= endTimeStamp
    end
  end
  
  if activityId and 0 < activityId then
    local activityCA = PlayerData:GetFactoryData(activityId)
    if activityCA.isTriggerTime then
      local curTime = TimeUtil:GetServerTimeStamp()
      local activityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
      local timeList = activityMainDataModel.IsActiveNewTimeOpen(activityId)
      if timeList then
        local check = true
        if timeList.startTime and type(timeList.startTime) == "number" and 0 < timeList.startTime then
          check = check and curTime >= timeList.startTime
        end
        if timeList.acEndTime and type(timeList.acEndTime) == "number" and 0 < timeList.acEndTime then
          check = check and false
        end
        return check
      end
    end
    if activityCA.isTime then
      local res = innerCheckTime(activityCA.startTime, activityCA.endTime)
      if res then
        return res
      end
    else
      return true
    end
  elseif startTime ~= "" or endTime ~= "" then
    local res = innerCheckTime(startTime, endTime)
    if res then
      return res
    end
  else
    return true
  end
  return false
end

function module.CheckTalkDo(eventList, parentView, buildingId, returnDo)
  local count = #eventList
  if 0 < count then
    if count == 1 then
      if not eventList[1]:action() then
        eventList[1] = nil
      else
        return 1
      end
    elseif parentView ~= nil then
      UIManager:Open(UIPath.TalkPlus, nil, returnDo)
      local childController = require("UITalkPlus/UITalkPlusController")
      childController:BindParentInfo(parentView, eventList, buildingId)
      return 2
    end
  end
  return false
end

function module.CheckQuestShow(id)
  local questCA = PlayerData:GetFactoryData(id, "QuestFactory")
  if questCA.dontShowMain then
    return false
  end
  if questCA.parentQuest and questCA.parentQuest > 0 then
    return false
  end
  if not QuestProcess.CheckQuestTime(id) then
    return false
  end
  if not QuestProcess.CheckQuestPreConditionComplete(id) then
    return false
  end
  return true
end

function module.CheckShowRecommendLevel(id)
  local questCA = PlayerData:GetFactoryData(id)
  if questCA.recommendLevel > 0 and PlayerData:GetPlayerLevel() >= questCA.startLevel and not questCA.isTBC then
    return true
  end
  return false
end

function module.Clear()
  cacheQuest = {}
  questCallBack = {}
  cachedCompleted = false
end

function module.AddQuestCallBack(key, callBack)
  questCallBack[key] = callBack
end

function module.RemoveQuestCallBack(key)
  questCallBack[key] = nil
end

return module
