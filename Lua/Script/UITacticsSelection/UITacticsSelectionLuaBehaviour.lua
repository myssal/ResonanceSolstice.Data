local View = require("UITacticsSelection/UITacticsSelectionView")
local DataModel = require("UITacticsSelection/UITacticsSelectionDataModel")
local ViewFunction = require("UITacticsSelection/UITacticsSelectionViewFunction")
local Controller = require("UITacticsSelection/UITacticsSelectionController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.cubeId = data.id
    end
    Controller:Init()
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
