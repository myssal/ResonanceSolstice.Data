local View = require("UIBattle_EquipmentWeek/UIBattle_EquipmentWeekView")
local DataModel = require("UIBattle_EquipmentWeek/UIBattle_EquipmentWeekDataModel")
local ViewFunction = require("UIBattle_EquipmentWeek/UIBattle_EquipmentWeekViewFunction")
local Controller = require("UIBattle_EquipmentWeek/UIBattle_EquipmentWeekController")
local params = {}
local Luabehaviour = {
  serialize = function()
    params.leftIndex = DataModel.LeftIndex
    return Json.encode(params)
  end,
  deserialize = function(initParams)
    params = Json.decode(initParams)
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
