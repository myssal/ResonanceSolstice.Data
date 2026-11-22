local View = require("UISignBattleTipAnethum/UISignBattleTipAnethumView")
local DataModel = require("UISignBattleTipAnethum/UISignBattleTipAnethumDataModel")
local ViewFunction = {
  SignBattleTipAnethum_Video_Main_Skip_Click = function(btn, str)
  end,
  SignBattleTipAnethum_Btn_Gacha_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    if DataModel.isGoback == true then
      UIManager:GoBack()
    else
      UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipAnethum")
    end
    local t = {}
    t.poolId = 80500283
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  SignBattleTipAnethum_Btn_Activity_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipAnethum")
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end
}
return ViewFunction
