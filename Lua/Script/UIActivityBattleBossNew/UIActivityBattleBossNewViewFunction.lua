local View = require("UIActivityBattleBossNew/UIActivityBattleBossNewView")
local Controller = require("UIActivityBattleBossNew/UIActivityBattleBossNewController")
local DataModel = require("UIActivityBattleBossNew/UIActivityBattleBossNewDataModel")
local ViewFunction = {
  ActivityBattleBossNew_Group_Main_Group_Tower_Btn_Open_Click = function(btn, str)
    Controller:OpenBattleBoss()
  end,
  ActivityBattleBossNew_Group_Main_Group_Tower_Btn_Plot_Click = function(btn, str)
    Controller:PlayDialog()
  end,
  ActivityBattleBossNew_Group_Main_Group_Depth_Btn_Open_Click = function(btn, str)
    Controller:TryOpenAbyssPanel()
  end,
  ActivityBattleBossNew_Group_Main_Group_Singularity_Btn_Open_Click = function(btn, str)
  end,
  ActivityBattleBossNew_Group_Main_Group_Shop_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RewardSetElemnt(element, tonumber(elementIndex))
  end,
  ActivityBattleBossNew_Group_Main_Group_Shop_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:RewardClickElemnt(str)
  end,
  ActivityBattleBossNew_Group_Main_Group_Shop_Btn_Shop_Click = function(btn, str)
    Controller:OpenBattleBossStore()
  end
}
return ViewFunction
