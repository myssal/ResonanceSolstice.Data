local View = require("UITacticsSelection_New/UITacticsSelection_NewView")
local DataModel = require("UITacticsSelection_New/UITacticsSelection_NewDataModel")
local ViewFunction = require("UITacticsSelection_New/UITacticsSelection_NewViewFunction")
local Controller = require("UITacticsSelection_New/UITacticsSelection_NewController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.hasPrePanel = data.hasPrePanel
      DataModel.cubeId = data.id
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
