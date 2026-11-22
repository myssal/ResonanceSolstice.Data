local View = require("UIBattle_Abyss/UIBattle_AbyssView")
local DataModel = require("UIBattle_Abyss/UIBattle_AbyssDataModel")
local Controller = require("UIBattle_Abyss/UIBattle_AbyssController")
local ViewFunction = {
  Battle_Abyss_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.isBattleReturn and DataModel.activityId then
      UIManager:Open("UI/Activity/ActivityMain", Json.encode({
        id = DataModel.activityId,
        backToHome = true
      }))
    else
      local ActivityMainController = require("UIActivityMain/UIActivityMainController")
      ActivityMainController:RefreshLeftRedState()
      UIManager:GoBack()
    end
  end,
  Battle_Abyss_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Battle_Abyss_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Battle_Abyss_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Battle_Abyss_Group_BuffList_Btn_Close_Click = function(btn, str)
  end,
  Battle_Abyss_Img_Mask_ScrollView_TV_Viewport_Content_Img_Bg_Group_Abyss_Group_Abyss1_Btn_Abyss_Click = function(btn, str)
    Controller:OpenTeam(1)
  end,
  Battle_Abyss_Img_Mask_ScrollView_TV_Viewport_Content_Img_Bg_Group_Abyss_Group_Abyss2_Btn_Abyss_Click = function(btn, str)
    Controller:OpenTeam(2)
  end,
  Battle_Abyss_Img_Mask_ScrollView_TV_Viewport_Content_Img_Bg_Group_Abyss_Group_Abyss3_Btn_Abyss_Click = function(btn, str)
    Controller:OpenTeam(3)
  end,
  Battle_Abyss_Img_Mask_ScrollView_TV_Viewport_Content_Img_Bg_Group_Abyss_Group_Abyss4_Btn_Abyss_Click = function(btn, str)
    Controller:OpenTeam(4)
  end,
  Battle_Abyss_Group_Star_Btn_Star_Click = function(btn, str)
    Controller:OpenStarRewards()
  end,
  Battle_Abyss_Group_StarReward_Btn_Close_Click = function(btn, str)
    View.Group_StarReward:SetActive(false)
  end,
  Battle_Abyss_Group_StarReward_ScrollGrid_Level_SetGrid = function(element, elementIndex)
    Controller:SetStarRewardGrid(element, elementIndex)
  end,
  Battle_Abyss_Group_StarReward_ScrollGrid_Level_Group_Item_Group_Can_Btn_Click_Click = function(btn, str)
    Controller:TryClaimStarReward(str)
  end,
  Battle_Abyss_Group_StarReward_ScrollGrid_Level_Group_Item_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetStarRewardsItemGrid(element, elementIndex)
  end,
  Battle_Abyss_Group_StarReward_ScrollGrid_Level_Group_Item_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    if str == nil then
      return
    end
    CommonTips.OpenPreRewardDetailTips(str, nil, true)
  end
}
return ViewFunction
