local View = require("UIDiceReward/UIDiceRewardView")
local DataModel = require("UIDiceReward/UIDiceRewardDataModel")
local ViewFunction = require("UIDiceReward/UIDiceRewardViewFunction")
local Controller = require("UIDiceReward/UIDiceRewardController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      local diceNum = Json.decode(initParams).diceNum
      local itemId = Json.decode(initParams).itemId
      Controller.Init(diceNum, itemId)
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
