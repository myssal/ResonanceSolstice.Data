local View = require("UIActivityRecharge/UIActivityRechargeView")
local DataModel = require("UIActivityRecharge/UIActivityRechargeDataModel")
local ViewFunction = require("UIActivityRecharge/UIActivityRechargeViewFunction")
local Controller = require("UIActivityRecharge/UIActivityRechargeController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      DataModel.id = data.activityId
    end
    Controller:InitData(DataModel.id)
    Controller:InitView()
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
