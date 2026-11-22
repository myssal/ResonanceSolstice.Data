local View = require("UIActivityRechargeMist/UIActivityRechargeMistView")
local DataModel = require("UIActivityRechargeMist/UIActivityRechargeMistDataModel")
local ViewFunction = require("UIActivityRechargeMist/UIActivityRechargeMistViewFunction")
local Controller = require("UIActivityRechargeMist/UIActivityRechargeMistController")
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
