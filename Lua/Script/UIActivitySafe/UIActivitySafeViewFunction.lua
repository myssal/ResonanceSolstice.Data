local View = require("UIActivitySafe/UIActivitySafeView")
local DataModel = require("UIActivitySafe/UIActivitySafeDataModel")
local Controller = require("UIActivitySafe/UIActivitySafeController")
local ViewFunction = {
  ActivitySafe_Group_NPC_Btn__Click = function(btn, str)
    Controller.OnNPCBtnClick()
  end,
  ActivitySafe_Group_Reward_Btn__Click = function(btn, str)
    Controller.OnRewardBtnClick()
  end,
  ActivitySafe_Group_Safe_Btn__Click = function(btn, str)
    Controller.OnSafeBtnClick()
  end,
  ActivitySafe_Group_Battle_Btn__Click = function(btn, str)
    Controller.OnBattleBtnClick()
  end,
  ActivitySafe_Group_Top_Btn_Entrust_Click = function(btn, str)
    UIManager:Open("UI/Entrust/Entrust")
  end
}
return ViewFunction
