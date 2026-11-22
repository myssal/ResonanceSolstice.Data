local View = require("UICollectionReward/UICollectionRewardView")
local DataModel = require("UICollectionReward/UICollectionRewardDataModel")
local ViewFunction = require("UICollectionReward/UICollectionRewardViewFunction")
local Controller = require("UICollectionReward/UICollectionRewardController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      DataModel.bookId = Json.decode(initParams).bookId
      Controller.Init()
    end
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
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
