local View = require("UIChoseSkin/UIChoseSkinView")
local DataModel = require("UIChoseSkin/UIChoseSkinDataModel")
local Controller = require("UIChoseSkin/UIChoseSkinController")
local ViewFunction = require("UIChoseSkin/UIChoseSkinViewFunction")
local params
local Luabehaviour = {
  serialize = function()
    return Json.encode(params)
  end,
  deserialize = function(initParams)
    params = Json.decode(initParams)
    DataModel.ItemId = params.itemId
    DataModel.showSelectDetail = params.showSelectDetail and tonumber(params.showSelectDetail) or 0
    DataModel.ItemData = PlayerData:GetFactoryData(params.itemId)
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
