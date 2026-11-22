local View = require("UIMonsterLevel/UIMonsterLevelView")
local DataModel = require("UIMonsterLevel/UIMonsterLevelDataModel")
local Controller = require("UIMonsterLevel/UIMonsterLevelController")
local ViewFunction = {
  MonsterLevel_Group_BG_Group_1_Group_Level1_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_1_Group_Level2_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_1_Group_Level3_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_1_Group_Level4_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_1_Group_Level5_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_1_Group_Level6_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_1_Group_Level7_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_1_Group_Level8_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_2_Group_Level1_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_2_Group_Level2_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_2_Group_Level3_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_2_Group_Level6_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_2_Group_Level4_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_2_Group_Level5_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_2_Group_Level8_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Group_BG_Group_2_Group_Level7_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  MonsterLevel_Btn_Store_Click = function(btn, str)
    Controller:BtnStoreClick()
  end,
  MonsterLevel_Group_ShiftBtn_Btn_Out_Click = function(btn, str)
    Controller:BtnOutClick()
  end,
  MonsterLevel_Group_ShiftBtn_Btn_In_Click = function(btn, str)
    Controller:BtnInClick()
  end,
  MonsterLevel_Group_LevelDetails_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  MonsterLevel_Group_LevelDetails_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(str)
  end,
  MonsterLevel_Group_LevelDetails_Btn_Fight_Click = function(btn, str)
    Controller:ClickStartBattle()
  end,
  MonsterLevel_Group_LevelDetails_Group_Auto_Btn_Auto_Click = function(btn, str)
    Controller:AutoBattleClick()
  end,
  MonsterLevel_Group_LevelDetails_Group_Ding_Btn_Energy_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  MonsterLevel_Group_LevelDetails_Group_Ding_Btn_Energy_Btn_Add_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  MonsterLevel_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  MonsterLevel_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:Home()
  end,
  MonsterLevel_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  MonsterLevel_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  MonsterLevel_Btn_Close_Click = function(btn, str)
    Controller:CancelLevelClick()
  end,
  MonsterLevel_Group_SpLevelDetails_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  MonsterLevel_Group_SpLevelDetails_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(str)
  end,
  MonsterLevel_Group_SpLevelDetails_Btn_Fight_Click = function(btn, str)
    Controller:ClickStartBattle()
  end,
  MonsterLevel_Group_SpLevelDetails_Group_Lock_Btn_Lock_Click = function(btn, str)
    Controller:LockDiffClick(not DataModel.isLockDiff)
  end,
  MonsterLevel_Group_SpLevelDetails_Group_Ding_Btn_Energy_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  MonsterLevel_Group_SpLevelDetails_Group_Ding_Btn_Energy_Btn_Add_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  MonsterLevel_Group_LevelDetails_Group_Skip_Btn_Skip_Click = function(btn, str)
    Controller:ClickSkipWin()
  end,
  MonsterLevel_Group_LevelDetails_Group_Skip_Btn_Fight_Click = function(btn, str)
    Controller:ClickStartBattle()
  end
}
return ViewFunction
