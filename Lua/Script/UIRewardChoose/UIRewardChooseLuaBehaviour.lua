local View = require("UIRewardChoose/UIRewardChooseView")
local DataModel = require("UIRewardChoose/UIRewardChooseDataModel")
local ViewFunction = require("UIRewardChoose/UIRewardChooseViewFunction")
local Controller = require("UIRewardChoose/UIRewardChooseController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      Controller:Init(Json.decode(initParams))
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
