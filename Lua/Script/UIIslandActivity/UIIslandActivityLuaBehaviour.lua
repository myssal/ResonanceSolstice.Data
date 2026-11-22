local Timer = require("Common/Timer")
local View = require("UIIslandActivity/UIIslandActivityView")
local DataModel = require("UIIslandActivity/UIIslandActivityDataModel")
local Controller = require("UIIslandActivity/IslandActivityController")
local ViewFunction = require("UIIslandActivity/UIIslandActivityViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:Init(initParams)
    View.timer = Timer.New(1, function()
      DataModel.LevelLastTime = DataModel.LevelLastTime - 1
      local time = TimeUtil:SecondToTable(DataModel.LevelLastTime)
      View.Group_Join.Group_Level.Group_Time.Txt_Time:SetText(string.format(GetText(80607797), time.day, time.hour < 10 and "0" .. time.hour or time.hour, 10 > time.minute and "0" .. time.minute or time.minute))
      if DataModel.LevelLastTime < 0 then
        DataModel.LevelType = DataModel.BtnTypeList.TimeOut
        Controller:RefreshLevel()
        View.timer:Stop()
      end
    end)
    if DataModel.LevelLastTime and DataModel.LevelType and DataModel.LevelType ~= DataModel.BtnTypeList.TimeOut then
      View.timer:Start()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if View.timer then
      View.timer:Update()
    end
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
