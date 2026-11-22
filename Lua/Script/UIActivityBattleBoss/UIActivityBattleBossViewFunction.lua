local View = require("UIActivityBattleBoss/UIActivityBattleBossView")
local DataModel = require("UIActivityBattleBoss/UIActivityBattleBossDataModel")
local Controller = require("UIActivityBattleBoss/UIActivityBattleBossController")
local ViewFunction = {
  ActivityBattleBoss_Group_Main_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RewardSetElemnt(element, tonumber(elementIndex))
  end,
  ActivityBattleBoss_Group_Main_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:RewardClickElemnt(str)
  end,
  ActivityBattleBoss_Group_Main_Btn_Open_Click = function(btn, str)
    Controller:OpenBattleBoss()
  end,
  ActivityBattleBoss_Group_Main_Btn_Plot_Click = function(btn, str)
    Controller:PlayDialog()
  end,
  ActivityBattleBoss_Group_Main_Btn_Shop_Click = function(btn, str)
    Controller:OpenBattleBossStore()
  end,
  ActivityBattleBoss_Group_Join_Group_Quest_Btn__Click = function(btn, str)
  end,
  ActivityBattleBoss_Group_Join_Group_Store_Btn__Click = function(btn, str)
  end,
  ActivityBattleBoss_Group_Join_Group_Card_Btn__Click = function(btn, str)
  end,
  ActivityBattleBoss_Group_Join_Group_Skip_Btn__Click = function(btn, str)
  end,
  ActivityBattleBoss_Group_Join_Group_Level_Btn__Click = function(btn, str)
  end,
  ActivityBattleBoss_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.ActivityCA.helpId)
  end
}
return ViewFunction
