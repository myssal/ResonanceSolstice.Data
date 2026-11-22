local View = require("UIActivityRecharge04/UIActivityRecharge04View")
local DataModel = require("UIActivityRecharge04/UIActivityRecharge04DataModel")
local ViewFunction = require("UIActivityRecharge04/UIActivityRecharge04ViewFunction")
local Controller = require("UIActivityRecharge04/UIActivityRecharge04Controller")
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
