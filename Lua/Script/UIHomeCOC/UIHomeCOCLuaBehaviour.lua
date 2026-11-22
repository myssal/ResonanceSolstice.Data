local View = require("UIHomeCOC/UIHomeCOCView")
local DataModel = require("UIHomeCOC/UIHomeCOCDataModel")
local Controller = require("UIHomeCOC/UIHomeCOCController")
local ViewFunction = require("UIHomeCOC/UIHomeCOCViewFunction")
local Luabehaviour = {
  serialize = function()
    local t = {}
    t = DataModel.decodeParams
    t.noInit = true
    if View.Group_Quest.self.IsActive then
      t.backQuest = true
    end
    return Json.encode(t)
  end,
  deserialize = function(initParams)
    DataModel.IsHomeReturn = false
    DataModel.IsCityMapIn = false
    if initParams ~= nil then
      local t = Json.decode(initParams)
      DataModel.decodeParams = t
      DataModel.StationId = t.stationId
      DataModel.BuildingId = t.buildingId
      DataModel.NpcId = t.npcId
      DataModel.BgPath = t.bgPath
      DataModel.BgColor = t.bgColor or "FFFFFF"
      DataModel.IsCityMapIn = t.isCityMapIn ~= nil and t.isCityMapIn or false
      local stationCA = PlayerData:GetFactoryData(t.stationId)
      if stationCA ~= nil then
        DataModel.ExchangeId = stationCA.cocExchangeBuildId
        local exchangeCA = PlayerData:GetFactoryData(stationCA.cocExchangeBuildId)
        if exchangeCA ~= nil then
          DataModel.ExchangeLevelLimt = exchangeCA.playerLevel
        end
      end
      if t.noInit then
        Controller:BackInit()
        if t.backQuest == true then
          Controller:ClickQuestTab(true)
        end
      else
        Controller:Init()
      end
      View.Group_COCReputation:SetActive(false)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if View.Group_Quest.self.IsActive then
      Controller:DayRefreshOrderPanel()
    end
  end,
  ondestroy = function()
    local npcDialog = require("Common/NPCDialog")
    npcDialog.ClearAll()
  end,
  enable = function()
  end,
  disenable = function()
    QuestProcess.RemoveQuestCallBack(View.self.url)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
