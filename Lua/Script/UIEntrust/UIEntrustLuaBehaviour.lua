local View = require("UIEntrust/UIEntrustView")
local DataModel = require("UIEntrust/UIEntrustDataModel")
local Controller = require("UIEntrust/UIEntrustController")
local ViewFunction = require("UIEntrust/UIEntrustViewFunction")
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
    if DataModel.updateLayout and DataModel.recommendLayout then
      DataModel.updateLayout = false
      DataModel.recommendLayout.enabled = false
      DataModel.recommendLayout.enabled = true
    end
    if DataModel.timer then
      DataModel.timer:Update()
    end
    Controller:UpdateRoleMove()
    Controller:UpdateRefreshRewardUp()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    DataModel.recommendLayout = nil
    DataModel.updateLayout = false
    if DataModel.timer then
      DataModel.timer:Stop()
      DataModel.timer = nil
    end
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
