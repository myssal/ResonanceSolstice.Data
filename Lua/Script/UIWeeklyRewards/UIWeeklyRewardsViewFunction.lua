local View = require("UIWeeklyRewards/UIWeeklyRewardsView")
local DataModel = require("UIWeeklyRewards/UIWeeklyRewardsDataModel")
local Controller = require("UIWeeklyRewards/UIWeeklyRewardController")
local ViewFunction = {
  WeeklyRewards_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
    View.self:Confirm()
  end,
  WeeklyRewards_ScrollView_RewardList_Viewport_Content_Group_Item_Btn_Rewards_Click = function(btn, str)
  end,
  WeeklyRewards_ScrollView_RewardList_Viewport_Content_Group_Item_Btn_ClaimAll_Click = function(btn, str)
  end,
  WeeklyRewards_ScrollView_RewardList_Viewport_Content_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller.RefreshRewardElement(element, elementIndex)
  end,
  WeeklyRewards_ScrollView_RewardList_Viewport_Content_StaticGrid_List_Group_Item_Btn_Rewards_Click = function(btn, str)
  end,
  WeeklyRewards_ScrollView_RewardList_Viewport_Content_StaticGrid_List_Group_Item_Btn_ClaimAll_Click = function(btn, str)
  end
}
return ViewFunction
