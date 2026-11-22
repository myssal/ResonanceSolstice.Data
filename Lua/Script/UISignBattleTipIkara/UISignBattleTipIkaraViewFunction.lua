local View = require("UISignBattleTipIkara/UISignBattleTipIkaraView")
local DataModel = require("UISignBattleTipIkara/UISignBattleTipIkaraDataModel")
local ViewFunction = {
  SignBattleTipIkara_Video_Main_Skip_Click = function(btn, str)
  end,
  SignBattleTipIkara_Btn_Gacha_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    if DataModel.isGoback == true then
      UIManager:GoBack()
    else
      UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipIkara")
    end
    local t = {}
    t.poolId = 80500209
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  SignBattleTipIkara_Btn_Activity_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipIkara")
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end
}
return ViewFunction
