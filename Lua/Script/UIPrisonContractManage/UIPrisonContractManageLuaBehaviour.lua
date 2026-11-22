local View = require("UIPrisonContractManage/UIPrisonContractManageView")
local DataModel = require("UIPrisonContractManage/UIPrisonContractManageDataModel")
local ViewFunction = require("UIPrisonContractManage/UIPrisonContractManageViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
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
