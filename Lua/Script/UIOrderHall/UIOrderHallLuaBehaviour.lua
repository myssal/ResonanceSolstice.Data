local View = require("UIOrderHall/UIOrderHallView")
local DataModel = require("UIOrderHall/UIOrderHallDataModel")
local ViewFunction = require("UIOrderHall/UIOrderHallViewFunction")
local Controller = require("UIOrderHall/UIOrderHallController")
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
  perupdate = function()
  end,
  update = function()
    if DataModel.CurOrderEndTime > 0 then
      Controller:UpdateOrderRemainTime()
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
