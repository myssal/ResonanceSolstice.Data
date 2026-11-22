local View = require("UIGuKaChoose/UIGuKaChooseView")
local DataModel = require("UIGuKaChoose/UIGuKaChooseDataModel")
local ViewFunction = require("UIGuKaChoose/UIGuKaChooseViewFunction")
local Controller = require("UIGuKaChoose/UIGuKaChooseController")
local Luabehaviour = {
  serialize = function()
    return DataModel.initParams
  end,
  deserialize = function(initParams)
    DataModel.initParams = initParams
    local witchesData = WitchData.GetWitchesData()
    local eventStrInfo
    if witchesData.end_events and table.count(witchesData.end_events) > 0 then
      eventStrInfo = witchesData.end_events[table.count(witchesData.end_events)]
    else
      eventStrInfo = witchesData.start_id
    end
    local splitT = string.split(eventStrInfo, ":")
    local eventId = splitT[1]
    local gridEventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
    DataModel.IsOptional = gridEventCA.isOptional
    DataModel.IsRefresh = gridEventCA.isRefresh
    local param = Json.decode(initParams)
    local rewardType = param.rewardType
    DataModel.rewardType = rewardType
    local rewardSelect = WitchData.GetRewardSelectList()
    DataModel.GuKaList = rewardSelect[rewardType]
    Controller:Init()
    local DataController = require("UIWitchMain/UIWitchMainDataController")
    DataController:SetCameraActive(false)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    local DataController = require("UIWitchMain/UIWitchMainDataController")
    DataController:SetCameraActive(true)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
