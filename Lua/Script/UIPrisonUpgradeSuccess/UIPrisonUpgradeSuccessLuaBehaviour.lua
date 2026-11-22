local View = require("UIPrisonUpgradeSuccess/UIPrisonUpgradeSuccessView")
local DataModel = require("UIPrisonUpgradeSuccess/UIPrisonUpgradeSuccessDataModel")
local ViewFunction = require("UIPrisonUpgradeSuccess/UIPrisonUpgradeSuccessViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local params = Json.decode(initParams)
    local level = params.level
    View.Txt_TipLV:SetText(level)
    View.self:PlayAnimOnce("In")
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
