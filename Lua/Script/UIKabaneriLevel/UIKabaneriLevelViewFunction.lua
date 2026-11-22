local View = require("UIKabaneriLevel/UIKabaneriLevelView")
local DataModel = require("UIKabaneriLevel/UIKabaneriLevelDataModel")
local Controller = require("UIKabaneriLevel/UIKabaneriLevelController")
local ViewFunction = {
  KabaneriLevel_Btn_Close_Click = function(btn, str)
    Controller:CancelLevelClick()
  end,
  KabaneriLevel_Group_BG_Group_1_Group_Level_Group_Level1_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_1_Group_Level_Group_Level2_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_1_Group_Level_Group_Level3_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_1_Group_Level_Group_Level4_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_1_Group_Level_Group_Level5_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_1_Group_Level_Group_Level6_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_1_Group_Level_Group_Level7_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_2_Group_Level_Group_Level1_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_2_Group_Level_Group_Level2_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_2_Group_Level_Group_Level3_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_2_Group_Level_Group_Level4_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_2_Group_Level_Group_Level5_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_2_Group_Level_Group_Level6_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Group_BG_Group_2_Group_Level_Group_Level7_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  KabaneriLevel_Btn_Store_Click = function(btn, str)
    Controller:BtnStoreClick()
  end,
  KabaneriLevel_Group_ShiftBtn_Btn_Out_Click = function(btn, str)
    Controller:BtnOutClick()
  end,
  KabaneriLevel_Group_ShiftBtn_Btn_In_Click = function(btn, str)
    Controller:BtnInClick()
  end,
  KabaneriLevel_Group_LevelDetails_Img_Deco_Group_Level_Btn_Level_Click = function(btn, str)
  end,
  KabaneriLevel_Group_LevelDetails_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  KabaneriLevel_Group_LevelDetails_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(str)
  end,
  KabaneriLevel_Group_LevelDetails_Group_Ding_Btn_Energy_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  KabaneriLevel_Group_LevelDetails_Group_Ding_Btn_Energy_Btn_Add_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  KabaneriLevel_Group_LevelDetails_Btn_Fight_Click = function(btn, str)
    Controller:ClickStartBattle()
  end,
  KabaneriLevel_Group_LevelDetails_Group_Auto_Btn_Auto_Click = function(btn, str)
    Controller:AutoBattleClick()
  end,
  KabaneriLevel_Group_SpLevelDetails_Img_Deco_Group_Level_Btn_Level_Click = function(btn, str)
  end,
  KabaneriLevel_Group_SpLevelDetails_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  KabaneriLevel_Group_SpLevelDetails_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(str)
  end,
  KabaneriLevel_Group_SpLevelDetails_Group_Ding_Btn_Energy_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  KabaneriLevel_Group_SpLevelDetails_Group_Ding_Btn_Energy_Btn_Add_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  KabaneriLevel_Group_SpLevelDetails_Btn_Fight_Click = function(btn, str)
    Controller:ClickStartBattle()
  end,
  KabaneriLevel_Group_SpLevelDetails_Group_Lock_Btn_Lock_Click = function(btn, str)
    Controller:LockDiffClick(not DataModel.isLockDiff)
  end,
  KabaneriLevel_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  KabaneriLevel_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:Home()
  end,
  KabaneriLevel_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  KabaneriLevel_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
