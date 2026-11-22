local View = require("UIUpgradeSuccess/UIUpgradeSuccessView")
local DataModel = require("UIUpgradeSuccess/UIUpgradeSuccessDataModel")
local ViewFunction = require("UIUpgradeSuccess/UIUpgradeSuccessViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local params = Json.decode(initParams)
    local isPrisonMachine = params.isPrison
    View.Group_FurnitureUpgradeSuccess:SetActive(not isPrisonMachine)
    View.Group_PrisonUpgradeSuccess:SetActive(isPrisonMachine)
    local ctr = isPrisonMachine and View.Group_PrisonUpgradeSuccess or View.Group_FurnitureUpgradeSuccess
    ctr.Group_LvBefore.Txt_Num:SetText(params.beforeNum)
    ctr.Group_LvAfter.Txt_Num:SetText(params.afterNum)
    ctr.Txt_Tip:SetText(GetText(80601188))
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
