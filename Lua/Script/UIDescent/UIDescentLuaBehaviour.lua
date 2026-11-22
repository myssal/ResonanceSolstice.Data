local View = require("UIDescent/UIDescentView")
local DataModel = require("UIDescent/UIDescentDataModel")
local ViewFunction = require("UIDescent/UIDescentViewFunction")
local Controller = require("UIDescent/UIDescentController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      DataModel.cubeId = data.cubeId
    end
    Controller:Init()
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
