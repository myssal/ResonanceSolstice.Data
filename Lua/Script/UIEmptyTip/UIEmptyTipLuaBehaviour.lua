local View = require("UIEmptyTip/UIEmptyTipView")
local DataModel = require("UIEmptyTip/UIEmptyTipDataModel")
local ViewFunction = require("UIEmptyTip/UIEmptyTipViewFunction")
local Controller = require("UIEmptyTip/UIEmptyTipController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.self:SetEnableAnimator(true)
    View.self:PlayAnimOnce("Animation_in")
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.hasLoadageEmpty = data.hasLoadageEmpty
      DataModel.hasPassengerEmpty = data.hasPassengerEmpty
      DataModel.curCityId = data.curCityId
      DataModel.notGoCity = data.notGoCity
      Controller:Init()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
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
