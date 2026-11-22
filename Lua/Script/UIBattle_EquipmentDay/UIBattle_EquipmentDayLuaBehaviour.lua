local View = require("UIBattle_EquipmentDay/UIBattle_EquipmentDayView")
local DataModel = require("UIBattle_EquipmentDay/UIBattle_EquipmentDayDataModel")
local ViewFunction = require("UIBattle_EquipmentDay/UIBattle_EquipmentDayViewFunction")
local Controller = require("UIBattle_EquipmentDay/UIBattle_EquipmentDayController")
local params
local Luabehaviour = {
  serialize = function()
    return params
  end,
  deserialize = function(initParams)
    params = initParams
    DataModel:Init(initParams)
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
