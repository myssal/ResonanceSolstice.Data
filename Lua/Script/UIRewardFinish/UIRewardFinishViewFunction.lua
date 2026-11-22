local View = require("UIRewardFinish/UIRewardFinishView")
local DataModel = require("UIRewardFinish/UIRewardFinishDataModel")
local Controller = require("UIRewardFinish/UIRewardFinishController")
local ViewFunction = {
  RewardFinish_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:OnSetRewardGrid(element, elementIndex)
  end,
  RewardFinish_Group_Reward_StaticGrid_Reward_Group_Item_Btn_Reward_Click = function(btn, str)
    Controller:OnGetReward(str)
  end,
  RewardFinish_Group_Reward_StaticGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(str)
  end,
  RewardFinish_Group_Reward_Group_Item_Btn_Reward_Click = function(btn, str)
  end,
  RewardFinish_Group_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  RewardFinish_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:OnBtnBack()
  end,
  RewardFinish_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    PlayerData.ServerData.rb_id = ""
    UIManager:GoHome()
  end
}
return ViewFunction
