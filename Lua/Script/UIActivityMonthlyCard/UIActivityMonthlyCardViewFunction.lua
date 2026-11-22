local View = require("UIActivityMonthlyCard/UIActivityMonthlyCardView")
local DataModel = require("UIActivityMonthlyCard/UIActivityMonthlyCardDataModel")
local Controller = require("UIActivityMonthlyCard/UIActivityMonthlyCardController")
local ViewFunction = {
  ActivityMonthlyCard_Btn_Help_Click = function(btn, str)
    Controller:ClickHelp()
  end,
  ActivityMonthlyCard_StaticGrid_Rewards_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  ActivityMonthlyCard_StaticGrid_Rewards_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:clickRewardItem(str)
  end,
  ActivityMonthlyCard_Btn_Claim_Click = function(btn, str)
    Controller:ClickClaim()
  end,
  ActivityMonthlyCard_Btn_Buy_Click = function(btn, str)
    Controller:ClickBuy()
  end
}
return ViewFunction
