local View = require("UIRewardFinish/UIRewardFinishView")
local DataModel = require("UIRewardFinish/UIRewardFinishDataModel")
local ViewFunction = require("UIRewardFinish/UIRewardFinishViewFunction")
local Controller = require("UIRewardFinish/UIRewardFinishController")
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
