local View = require("UIDiceReward/UIDiceRewardView")
local DataModel = require("UIDiceReward/UIDiceRewardDataModel")
local MonopolyManager = require("UIMonopoly/LuaMonopolyManager")
local ViewFunction = {
  DiceReward_Btn_Close_Click = function(btn, str)
    UIManager:ClosePanel()
  end,
  DiceReward_Group_Reward_Btn_Icon_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  DiceReward_Group_Reward_Btn_Get_Click = function(btn, str)
    UIManager:ClosePanel()
  end
}
return ViewFunction
