local View = require("UIAquarium/UIAquariumView")
local DataModel = require("UIAquarium/UIAquariumDataModel")
local ViewFunction = require("UIAquarium/UIAquariumViewFunction")
local Controller = require("UIAquarium/UIAquariumController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local t = Json.decode(initParams)
      DataModel.NpcId = t.npcId
      DataModel.StationId = t.stationId
      DataModel.BuildingId = t.buildingId
      Controller:Init()
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
