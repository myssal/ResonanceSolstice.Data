local View = require("UIDiceDay/UIDiceDayView")
local DataModel = require("UIDiceDay/UIDiceDayDataModel")
local Controller = require("UIDiceDay/UIDiceDayController")
local ViewFunction = {
  DiceDay_Btn_Close_Click = function(btn, str)
    Controller.OnQuitBtnClick()
  end,
  DiceDay_Group_Reward_Group_Afternoon_Btn_Icon_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  DiceDay_Group_Reward_Group_Afternoon_Btn_Get_Click = function(btn, str)
    Controller.ReqGetSubsidy(0)
  end,
  DiceDay_Group_Reward_Group_Night_Btn_Icon_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  DiceDay_Group_Reward_Group_Night_Btn_Get_Click = function(btn, str)
    Controller.ReqGetSubsidy(1)
  end,
  DiceDay_Group_Shop_Img_SuperDice_Img_Icon_Btn_Check_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  DiceDay_Group_Shop_Img_SuperDice_Btn_Buy_Click = function(btn, str)
  end,
  DiceDay_Group_Shop_Img_Dice_Img_Icon_Btn_Check_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  DiceDay_Group_Shop_Img_Dice_Btn_Buy_Click = function(btn, str)
  end,
  DiceDay_Group_SwitchButton_Btn_Shop_Click = function(btn, str)
    Controller.OnShopBtnClick()
  end,
  DiceDay_Group_SwitchButton_Btn_Reward_Click = function(btn, str)
    Controller.OnRewardBtnClick()
  end
}
return ViewFunction
