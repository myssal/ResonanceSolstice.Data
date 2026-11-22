local View = require("UIActivityRecharge04/UIActivityRecharge04View")
local DataModel = require("UIActivityRecharge04/UIActivityRecharge04DataModel")
local Controller = require("UIActivityRecharge04/UIActivityRecharge04Controller")
local ViewFunction = {
  ActivityRecharge04_StaticGrid_RewardsList_SetGrid = function(element, elementIndex)
    Controller:SetElement(element, elementIndex)
  end,
  ActivityRecharge04_StaticGrid_RewardsList_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:OnClick(tonumber(str))
  end,
  ActivityRecharge04_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(80306628)
  end,
  ActivityRecharge04_Group_Diamond_Btn_Add_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end,
  ActivityRecharge04_Group_Diamond_Btn_Icon_Click = function(btn, str)
  end
}
return ViewFunction
