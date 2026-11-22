local View = require("UIPrisonContract/UIPrisonContractView")
local DataModel = require("UIPrisonContract/UIPrisonContractDataModel")
local ViewFunction = require("UIPrisonContract/UIPrisonContractViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
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
