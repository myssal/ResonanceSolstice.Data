local View = require("UIIllustration_Equipment/UIIllustration_EquipmentView")
local DataModel = require("UIIllustration_Equipment/UIIllustration_EquipmentDataModel")
local ViewFunction = require("UIIllustration_Equipment/UIIllustration_EquipmentViewFunction")
local Controller = require("UIIllustration_Equipment/UIIllustration_EquipmentController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
    Controller:ExitAffixBook()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
