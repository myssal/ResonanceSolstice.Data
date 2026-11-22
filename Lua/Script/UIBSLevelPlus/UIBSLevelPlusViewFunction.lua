local View = require("UIBSLevelPlus/UIBSLevelPlusView")
local DataModel = require("UIBSLevelPlus/UIBSLevelPlusDataModel")
local Controller = require("UIBSLevelPlus/UIBSLevelPlusController")
local ViewFunction = {
  BSLevelPlus_Btn_Close_Click = function(btn, str)
    Controller:CancelLevelClick()
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level1_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level2_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level3_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level4_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level5_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level6_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level7_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level8_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_LevelDetails_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  BSLevelPlus_Group_LevelDetails_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(str)
  end,
  BSLevelPlus_Group_LevelDetails_Group_Ding_Btn_Energy_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  BSLevelPlus_Group_LevelDetails_Group_Ding_Btn_Energy_Btn_Add_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  BSLevelPlus_Group_LevelDetails_Btn_Fight_Click = function(btn, str)
    Controller:ClickStartBattle()
  end,
  BSLevelPlus_Group_LevelDetails_Group_Auto_Btn_Auto_Click = function(btn, str)
    Controller:AutoBattleClick()
  end,
  BSLevelPlus_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  BSLevelPlus_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:Home()
  end,
  BSLevelPlus_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  BSLevelPlus_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  BSLevelPlus_Group_SpLevelDetails_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  BSLevelPlus_Group_SpLevelDetails_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(str)
  end,
  BSLevelPlus_Group_SpLevelDetails_Group_Ding_Btn_Energy_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  BSLevelPlus_Group_SpLevelDetails_Group_Ding_Btn_Energy_Btn_Add_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  BSLevelPlus_Group_SpLevelDetails_Btn_Fight_Click = function(btn, str)
    Controller:ClickStartBattle()
  end,
  BSLevelPlus_Group_SpLevelDetails_Group_Lock_Btn_Lock_Click = function(btn, str)
    Controller:LockDiffClick(not DataModel.isLockDiff)
  end,
  BSLevelPlus_Group_SpLevelDetails_Group_Auto_Btn_Auto_Click = function(btn, str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level9_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level10_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level11_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level12_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level13_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level14_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  BSLevelPlus_Group_BG_Group_1_ScrollView__Viewport_Content_Group_Level15_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end
}
return ViewFunction
