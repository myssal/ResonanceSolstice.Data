local View = require("UIPrisonWorkshopContract/UIPrisonWorkshopContractView")
local DataModel = require("UIPrisonWorkshopContract/UIPrisonWorkshopContractDataModel")
local ViewFunction = require("UIPrisonWorkshopContract/UIPrisonWorkshopContractViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
  end,
  awake = function()
    DataModel.InitData()
    DataModel.RefreshOnShow()
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
