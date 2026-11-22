local View = require("UIActivityRechargeMist/UIActivityRechargeMistView")
local DataModel = require("UIActivityRechargeMist/UIActivityRechargeMistDataModel")
local Controller = require("UIActivityRechargeMist/UIActivityRechargeMistController")
local ViewFunction = {
  ActivityRechargeMist_StaticGrid_RewardsList_SetGrid = function(element, elementIndex)
    Controller:SetElement(element, elementIndex)
  end,
  ActivityRechargeMist_StaticGrid_RewardsList_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:OnClick(tonumber(str))
  end,
  ActivityRechargeMist_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(80306628)
  end,
  ActivityRechargeMist_Group_Diamond_Btn_Add_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end,
  ActivityRechargeMist_Group_Diamond_Btn_Icon_Click = function(btn, str)
  end
}
return ViewFunction
