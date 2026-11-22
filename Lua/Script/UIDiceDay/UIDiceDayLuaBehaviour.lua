local View = require("UIDiceDay/UIDiceDayView")
local DataModel = require("UIDiceDay/UIDiceDayDataModel")
local ViewFunction = require("UIDiceDay/UIDiceDayViewFunction")
local Controller = require("UIDiceDay/UIDiceDayController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local subsidy = Json.decode(initParams).subsidy
      Controller.Init(subsidy)
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
    Controller.Release()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
