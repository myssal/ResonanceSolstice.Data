local View = require("UIIronSagaMission/UIIronSagaMissionView")
local DataModel = require("UIIronSagaMission/UIIronSagaMissionDataModel")
local ViewFunction = require("UIIronSagaMission/UIIronSagaMissionViewFunction")
local Controller = require("UIIronSagaMission/UIIronSagaMissionController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Group_Title.Img_Title:SetSprite((GetResPath(88300272)))
    DataModel.initParams = initParams
    DataModel.decodeParams = Json.decode(initParams)
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
