local View = require("UIActivityRecharge/UIActivityRechargeView")
local DataModel = require("UIActivityRecharge/UIActivityRechargeDataModel")
local Controller = require("UIActivityRecharge/UIActivityRechargeController")
local ViewFunction = {
  ActivityRecharge_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(80306628)
  end,
  ActivityRecharge_Group_Diamond_Btn_Add_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end,
  ActivityRecharge_Group_Diamond_Btn_Icon_Click = function(btn, str)
  end,
  ActivityRecharge_StaticGrid_RewardsList_SetGrid = function(element, elementIndex)
    Controller:SetElement(element, elementIndex)
  end,
  ActivityRecharge_StaticGrid_RewardsList_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:OnClick(tonumber(str))
  end
}
return ViewFunction
