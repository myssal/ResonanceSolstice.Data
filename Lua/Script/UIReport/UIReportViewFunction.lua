local View = require("UIReport/UIReportView")
local DataModel = require("UIReport/UIReportDataModel")
local Controller = require("UIReport/UIReportController")
local ViewFunction = {
  Report_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshElement(element, elementIndex)
  end,
  Report_ScrollGrid_List_Group_Item_Group_Item_StaticGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:RefreshRoleElement(element, elementIndex)
  end,
  Report_ScrollGrid_List_Group_Item_Group_Item_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  Report_ScrollGrid_List_Group_Item_Group_Item_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(str)
  end,
  Report_Btn_Close_Click = function(btn, str)
    Controller:Close()
  end,
  Report_Btn_Again_Click = function(btn, str)
    Controller:AgainEntrust()
  end
}
return ViewFunction
