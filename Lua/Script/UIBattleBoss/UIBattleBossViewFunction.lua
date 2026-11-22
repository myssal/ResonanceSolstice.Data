local View = require("UIBattleBoss/UIBattleBossView")
local Controller = require("UIBattleBoss/UIBattleBossController")
local DataModel = require("UIBattleBoss/UIBattleBossDataModel")
local ViewFunction = {
  BattleBoss_Group_Right_Group_Title_Btn_Mechanism_Click = function(btn, str)
    Controller:BuffListSwitch(true)
  end,
  BattleBoss_Group_Right_Group_Drop_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    Controller:RefreshReward(element, elementIndex)
  end,
  BattleBoss_Group_Right_Group_Drop_ScrollGrid_Item_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  BattleBoss_Group_Right_Group_Fight_Btn_StartFight_Click = function(btn, str)
    Controller:ClickBattle()
  end,
  BattleBoss_Group_Best_Btn_Check_Click = function(btn, str)
    Controller:ClickBestBtn(str)
  end,
  BattleBoss_Group_Best_Btn_Reward_Click = function(btn, str)
    Controller:OpenTimeRewardPage(str)
  end,
  BattleBoss_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:CloseUI()
  end,
  BattleBoss_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  BattleBoss_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  BattleBoss_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  BattleBoss_Group_TimeReward_Btn_Close_Click = function(btn, str)
    View.Group_TimeReward.self:SetActive(false)
  end,
  BattleBoss_Group_TimeReward_ScrollGrid_Level_SetGrid = function(element, elementIndex)
    Controller:SetRewradParentGrid(element, elementIndex)
  end,
  BattleBoss_Group_TimeReward_ScrollGrid_Level_Group_Item_Group_Can_Btn_Click_Click = function(btn, str)
    Controller:ClickClaimBtn(str)
  end,
  BattleBoss_Group_TimeReward_ScrollGrid_Level_Group_Item_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetRewradGrid(element, elementIndex)
  end,
  BattleBoss_Group_TimeReward_ScrollGrid_Level_Group_Item_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  BattleBoss_Group_BuffList_Btn_Close_Click = function(btn, str)
    Controller:BuffListSwitch(false)
  end,
  BattleBoss_Group_CommomBottomLeft_Btn_Rank_Click = function(btn, str)
    Controller:OpenRank()
  end,
  BattleBoss_Btn_Abyss_Click = function(btn, str)
  end,
  BattleBoss_ScrollGrid_LevelList_SetGrid = function(element, elementIndex)
    Controller:SetElement(element, tonumber(elementIndex))
  end,
  BattleBoss_ScrollGrid_LevelList_Group_Level_Btn_Select_Click = function(btn, str)
    Controller:ClickLevelBtn(tonumber(str))
  end,
  BattleBoss_NewScrollGrid_LevelList_SetGrid = function(element, elementIndex)
    Controller:SetElement(element, tonumber(elementIndex))
  end,
  BattleBoss_NewScrollGrid_LevelList_Group_Level_Btn_Select_Click = function(btn, str)
    Controller:ClickLevelBtn(tonumber(str))
  end
}
return ViewFunction
