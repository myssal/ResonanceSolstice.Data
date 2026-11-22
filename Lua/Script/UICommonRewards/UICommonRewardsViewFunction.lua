local View = require("UICommonRewards/UICommonRewardsView")
local DataModel = require("UICommonRewards/UICommonRewardsDataModel")
local Controller = require("UICommonRewards/UICommonRewardsController")
local ViewFunction = {
  CommonRewards_ScrollGrid_LevelList_SetGrid = function(element, elementIndex)
    Controller.RefreshLvElement(element, elementIndex)
  end,
  CommonRewards_ScrollGrid_LevelList_Group_Item_Btn_Rewards_Click = function(btn, str)
  end,
  CommonRewards_ScrollGrid_LevelList_Group_Item_Btn_ClaimAll_Click = function(btn, str)
  end,
  CommonRewards_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
    View.self:Confirm()
  end,
  CommonRewards_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  CommonRewards_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  CommonRewards_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
