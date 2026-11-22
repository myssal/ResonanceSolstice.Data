local View = require("UIAnniversaryLevel/UIAnniversaryLevelView")
local DataModel = require("UIAnniversaryLevel/UIAnniversaryLevelDataModel")
local Controller = require("UIAnniversaryLevel/UIAnniversaryLevelController")
local ViewFunction = {
  AnniversaryLevel_Btn_Close_Click = function(btn, str)
    Controller:CancelLevelClick()
  end,
  AnniversaryLevel_Group_BG_Group_1_Group_Level1_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  AnniversaryLevel_Group_BG_Group_1_Group_Level2_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  AnniversaryLevel_Group_BG_Group_1_Group_Level3_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  AnniversaryLevel_Group_BG_Group_1_Group_Level4_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  AnniversaryLevel_Group_BG_Group_1_Group_Level5_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  AnniversaryLevel_Btn_Store_Click = function(btn, str)
    Controller:BtnStoreClick()
  end,
  AnniversaryLevel_Group_Gold_Btn__Click = function(btn, str)
    Controller:ClickGoldBtn()
  end,
  AnniversaryLevel_Group_LevelDetails_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  AnniversaryLevel_Group_LevelDetails_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(str)
  end,
  AnniversaryLevel_Group_LevelDetails_Group_Ding_Btn_Energy_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  AnniversaryLevel_Group_LevelDetails_Group_Ding_Btn_Energy_Btn_Add_Click = function(btn, str)
    Controller:ClickEnergy()
  end,
  AnniversaryLevel_Group_LevelDetails_Btn_Fight_Click = function(btn, str)
    Controller:ClickStartBattle()
  end,
  AnniversaryLevel_Group_LevelDetails_Group_PickDifficult_Group_Pick_Btn_Difficult1_Click = function(btn, str)
    Controller:ClickSelectDifficulty()
  end,
  AnniversaryLevel_Group_LevelDetails_Group_PickDifficult_Group_Pick_Btn_Difficult2_Click = function(btn, str)
    Controller:ClickSelectDifficulty()
  end,
  AnniversaryLevel_Group_LevelDetails_Group_PickDifficult_Group_Pick_Btn_Difficult3_Click = function(btn, str)
    Controller:ClickSelectDifficulty()
  end,
  AnniversaryLevel_Group_LevelDetails_Group_PickDifficult_Group_All_Btn_Difficult1_Click = function(btn, str)
    Controller:ClickIdxDifficulty(1)
  end,
  AnniversaryLevel_Group_LevelDetails_Group_PickDifficult_Group_All_Btn_Difficult2_Click = function(btn, str)
    Controller:ClickIdxDifficulty(2)
  end,
  AnniversaryLevel_Group_LevelDetails_Group_PickDifficult_Group_All_Btn_Difficult3_Click = function(btn, str)
    Controller:ClickIdxDifficulty(3)
  end,
  AnniversaryLevel_Group_LevelDetails_Group_Auto_Btn_Auto_Click = function(btn, str)
    Controller:AutoBattleClick()
  end,
  AnniversaryLevel_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  AnniversaryLevel_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:Home()
  end,
  AnniversaryLevel_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  AnniversaryLevel_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  AnniversaryLevel_Group_BG_Group_1_ScrollView_LevelList_Viewport_Content_Group_Level1_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  AnniversaryLevel_Group_BG_Group_1_ScrollView_LevelList_Viewport_Content_Group_Level2_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  AnniversaryLevel_Group_BG_Group_1_ScrollView_LevelList_Viewport_Content_Group_Level3_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  AnniversaryLevel_Group_BG_Group_1_ScrollView_LevelList_Viewport_Content_Group_Level4_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end,
  AnniversaryLevel_Group_BG_Group_1_ScrollView_LevelList_Viewport_Content_Group_Level5_Btn_Level_Click = function(btn, str)
    Controller:ClickLevelBtn(str)
  end
}
return ViewFunction
