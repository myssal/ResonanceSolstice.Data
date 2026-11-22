local View = require("UIDepthSelection/UIDepthSelectionView")
local DataModel = require("UIDepthSelection/UIDepthSelectionDataModel")
local ViewFunction = require("UIDepthSelection/UIDepthSelectionViewFunction")
local Controller = require("UIDepthSelection/UIDepthSelectionController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.cubeId = data.id
      DataModel.initIndex = data.initIndex
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
