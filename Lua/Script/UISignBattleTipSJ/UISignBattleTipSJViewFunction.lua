local View = require("UISignBattleTipSJ/UISignBattleTipSJView")
local DataModel = require("UISignBattleTipSJ/UISignBattleTipSJDataModel")
local ViewFunction = {
  SignBattleTipSJ_Video_Main_Skip_Click = function(btn, str)
  end,
  SignBattleTipSJ_Btn_Gacha_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    if DataModel.isGoback == true then
      UIManager:GoBack()
    else
      UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipShana")
    end
    local poolId
    local actCa = DataModel.activityCA
    if actCa and actCa.signBattleExtract then
      poolId = actCa.signBattleExtract
    end
    local t = {}
    t.poolId = poolId
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  SignBattleTipSJ_Btn_Activity_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipSJ")
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end
}
return ViewFunction
