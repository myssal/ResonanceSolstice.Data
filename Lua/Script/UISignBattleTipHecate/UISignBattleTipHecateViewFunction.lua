local View = require("UISignBattleTipHecate/UISignBattleTipHecateView")
local DataModel = require("UISignBattleTipHecate/UISignBattleTipHecateDataModel")
local ViewFunction = {
  SignBattleTipHecate_Video_Main_Skip_Click = function(btn, str)
  end,
  SignBattleTipHecate_Btn_Gacha_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    if DataModel.isGoback == true then
      UIManager:GoBack()
    else
      UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipHecate")
    end
    local t = {}
    t.poolId = 80500290
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  SignBattleTipHecate_Btn_Activity_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipHecate")
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end
}
return ViewFunction
