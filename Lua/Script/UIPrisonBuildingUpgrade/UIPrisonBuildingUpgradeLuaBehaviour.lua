local View = require("UIPrisonBuildingUpgrade/UIPrisonBuildingUpgradeView")
local DataModel = require("UIPrisonBuildingUpgrade/UIPrisonBuildingUpgradeDataModel")
local ViewFunction = require("UIPrisonBuildingUpgrade/UIPrisonBuildingUpgradeViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
    local isPowerRoom = DataModel.IsPowerRoom(DataModel.buildType)
    if isPowerRoom then
      View.self:PlayAnimOnce("Main_Power_In")
    else
      View.self:PlayAnimOnce("Main_In")
    end
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
