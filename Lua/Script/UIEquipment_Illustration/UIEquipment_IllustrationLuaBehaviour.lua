local View = require("UIEquipment_Illustration/UIEquipment_IllustrationView")
local DataModel = require("UIEquipment_Illustration/UIEquipment_IllustrationDataModel")
local ViewFunction = require("UIEquipment_Illustration/UIEquipment_IllustrationViewFunction")
local Controller = require("UIEquipment_Illustration/UIEquipment_IllustrationController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      DataModel.bookName = Json.decode(initParams).bookName
      Controller.Init()
    end
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
    Controller.Release()
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
