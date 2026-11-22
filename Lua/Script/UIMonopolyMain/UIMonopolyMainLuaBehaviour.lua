local View = require("UIMonopolyMain/UIMonopolyMainView")
local DataModel = require("UIMonopolyMain/UIMonopolyMainDataModel")
local ViewFunction = require("UIMonopolyMain/UIMonopolyMainViewFunction")
local Manager = require("UIMonopolyMain/UIMonopolyMainManager")

local function DayRefreshOrderPanel()
  if TimeUtil:GetServerTimeStamp() > DataModel.nextRefreshTime then
    DataModel.InitDayRefreshTime()
    Manager.ReqMpyInfo()
  end
  if TimeUtil:GetServerTimeStamp() > DataModel.nextRefreshTime_night then
    DataModel.InitDayRefreshTime_Night()
    Manager.ReqMpyInfo()
  end
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Manager.Init()
    DataModel.InitDayRefreshTime()
    DataModel.InitDayRefreshTime_Night()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    DayRefreshOrderPanel()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
