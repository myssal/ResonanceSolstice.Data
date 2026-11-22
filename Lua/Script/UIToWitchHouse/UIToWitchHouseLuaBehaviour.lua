local View = require("UIToWitchHouse/UIToWitchHouseView")
local DataModel = require("UIToWitchHouse/UIToWitchHouseDataModel")
local ViewFunction = require("UIToWitchHouse/UIToWitchHouseViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
