local View = require("UITransitCenter/UITransitCenterView")
local DataModel = require("UITransitCenter/UITransitCenterDataModel")
local ViewFunction = require("UITransitCenter/UITransitCenterViewFunction")
local Controller = require("UITransitCenter/UITransitCenterController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:Init()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    for i, v in pairs(DataModel.FleetCountDownHandler) do
      local totalTime = v.finishTimeStamp - v.startTime
      local remainTime = v.finishTimeStamp - TimeUtil:GetServerTimeStamp()
      if -1 < remainTime then
        local timeTable = {
          min = remainTime // 60,
          sec = remainTime % 60
        }
        v.timeStrCtr:SetText(string.format("%02d:%02d", timeTable.min, timeTable.sec))
        v.timeFillCtr:SetFilledImgAmount((totalTime - remainTime) / totalTime)
      else
        table.remove(DataModel.FleetCountDownHandler, i)
        Net:SendProto("prison.refresh", function(json)
          if json.user_prison_info then
            PlayerData.ServerData.user_prison_info = json.user_prison_info
          end
          DataModel.InitCarryingPrisonerData()
          DataModel.InitFleetData()
          Controller:RefreshFleetPanel()
          Controller:InitUI()
        end)
      end
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    DataModel.FleetCountDownHandler = {}
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
