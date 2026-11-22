local MapNeedleData = {}
local this = MapNeedleData
MapNeedleData.CompletedNeedleList = {}
MapNeedleData.GlobalNeedleList = {}
MapNeedleData.ChildNeedleList = {}

function MapNeedleData.SetNeedleData()
  this.ChildNeedleList = {}
  this.GlobalNeedleList = {}
  local completedNeedleList = PlayerData:GetHomeInfo().disposable_pointer
  for i, id in pairs(completedNeedleList) do
    this.AddCompletedNeedle(id)
  end
  for lineId, lineData in pairs(PlayerData:GetHomeInfo().home_lines) do
    local lineCA = PlayerData:GetFactoryData(lineId, "HomeLineFactory")
    for _, v in pairs(lineCA.mapNeedleList) do
      local needleCA = PlayerData:GetFactoryData(v.id, "MapNeedleFactory")
      if not needleCA.justOnce then
        this.SetGlobalNeedle(v.id)
      elseif this.IsOnceNeedleCompleted(v.id) then
        this.AddCompletedNeedle(v.id)
      else
        this.SetGlobalNeedle(v.id)
      end
    end
  end
end

function MapNeedleData.SetGlobalNeedle(mapNeedleId, remove)
  mapNeedleId = tonumber(mapNeedleId)
  if remove then
    this.GlobalNeedleList[mapNeedleId] = nil
  else
    this.GlobalNeedleList[mapNeedleId] = 1
  end
end

function MapNeedleData.SetChildNeedle(mapNeedleId, remove)
  mapNeedleId = tonumber(mapNeedleId)
  if remove then
    this.ChildNeedleList[mapNeedleId] = nil
  else
    this.ChildNeedleList[mapNeedleId] = 1
  end
end

function MapNeedleData.ResetData()
  this.CompletedNeedleList = {}
  this.GlobalNeedleList = {}
  this.ChildNeedleList = {}
end

function MapNeedleData.CheckQuest(questId)
  local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
  if questCA.activityId and questCA.activityId > 0 then
    local activityCfg = PlayerData:GetFactoryData(questCA.activityId, "ActivityFactory")
    if not TimeUtil:IsActive(activityCfg.startTime, activityCfg.endTime) then
      return false
    end
  end
  local questState = PlayerData.GetQuestState(questId)
  return questState == EnumDefine.EQuestState.UnFinish
end

function MapNeedleData.CheckLevel(levelId)
  return PlayerData.IsLevelFinished(levelId)
end

function MapNeedleData.ParagraphCompletedCheck(paragraphCondition)
  if paragraphCondition then
    for i, v in ipairs(paragraphCondition) do
      local find = false
      for _, id in pairs(PlayerData.plot_paragraph) do
        if tonumber(id) == v.id then
          find = true
          break
        end
      end
      if not find then
        return false
      end
    end
  end
  return true
end

function MapNeedleData.LevelCompletedCheck(levelCondition)
  if levelCondition then
    for i, v in ipairs(levelCondition) do
      if not this.CheckLevel(v.id) then
        return false
      end
    end
  end
  return true
end

function MapNeedleData.IsOnceNeedleCompleted(mapNeedleId)
  local needleCA = PlayerData:GetFactoryData(mapNeedleId, "MapNeedleFactory")
  if needleCA.justOnce then
    return this.ParagraphCompletedCheck(needleCA.ParagraphBefore) and this.LevelCompletedCheck(needleCA.LevelBefore)
  end
  return false
end

function MapNeedleData.CheckNeedleUnLock(mapNeedleId)
  local needleCA = PlayerData:GetFactoryData(mapNeedleId, "MapNeedleFactory")
  if table.count(needleCA.LevelConditions) > 0 then
    for i, v in ipairs(needleCA.LevelConditions) do
      if not this.CheckLevel(v.id) then
        return false
      end
    end
  end
  if 0 < table.count(needleCA.QuestConditions) then
    for i, v in ipairs(needleCA.QuestConditions) do
      if not this.CheckQuest(v.id) then
        return false
      end
    end
  end
  return true
end

function MapNeedleData.AddCompletedNeedle(mapNeedleId)
  mapNeedleId = tonumber(mapNeedleId)
  this.CompletedNeedleList[mapNeedleId] = 1
end

function MapNeedleData.NeedleCompletedSendServer()
  for mapNeedleId, v in pairs(this.GlobalNeedleList) do
    if not this.CompletedNeedleList[tonumber(mapNeedleId)] and this.IsOnceNeedleCompleted(mapNeedleId) then
      Net:SendProto("station.note_pointer", function(json)
        if json.rc == "" then
          this.AddCompletedNeedle(mapNeedleId)
          this.SetGlobalNeedle(mapNeedleId, true)
        end
      end, mapNeedleId)
    end
  end
  for mapNeedleId, v in pairs(this.ChildNeedleList) do
    if not this.CompletedNeedleList[tonumber(mapNeedleId)] and this.IsOnceNeedleCompleted(mapNeedleId) then
      Net:SendProto("station.note_pointer", function(json)
        if json.rc == "" then
          this.AddCompletedNeedle(mapNeedleId)
          this.SetChildNeedle(mapNeedleId, true)
        end
      end, mapNeedleId)
    end
  end
end

function MapNeedleData.CheckNeedleShow(mapNeedleId)
  local needleCA = PlayerData:GetFactoryData(mapNeedleId, "MapNeedleFactory")
  local unLock = this.CheckNeedleUnLock(mapNeedleId)
  if unLock then
    if not needleCA.justOnce then
      return true
    else
      return not this.IsOnceNeedleCompleted(mapNeedleId)
    end
  end
  return false
end

function MapNeedleData.NeedClickCheck(mapNeedleId)
  PlayerData.BattleCallBackPage = ""
  PlayerData.Last_Chapter_Parms = nil
  mapNeedleId = tonumber(mapNeedleId)
  if this.IsOnceNeedleCompleted(mapNeedleId) then
    Net:SendProto("station.note_pointer", function(json)
      if json.rc == "" then
        this.AddCompletedNeedle(mapNeedleId)
        this.SetGlobalNeedle(mapNeedleId, true)
      end
    end, mapNeedleId)
  end
  local UIMainUIController = require("UIMainUI/UIMainUIController")
  UIMainUIController.Stop()
end

function MapNeedleData.GoHome()
  if MapSessionManager.currentSession then
    local MainController = require("UIMainUI/UIMainUIController")
    MainController.SetCamera(PlayerData.FreeCameraIndex)
    MapSessionManager:GobackToMainScene()
  else
    UIManager:GoHome()
  end
end

function MapNeedleData.GoBack()
  if MapSessionManager.currentSession then
    local MainController = require("UIMainUI/UIMainUIController")
    MainController.SetCamera(PlayerData.FreeCameraIndex)
    MapSessionManager:Goback()
  else
    UIManager:GoBack()
  end
end

return MapNeedleData
