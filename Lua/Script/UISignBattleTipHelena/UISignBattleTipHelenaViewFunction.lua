local View = require("UISignBattleTipHelena/UISignBattleTipHelenaView")
local DataModel = require("UISignBattleTipHelena/UISignBattleTipHelenaDataModel")
local ViewFunction = {
  SignBattleTipHelena_Video_Main_Skip_Click = function(btn, str)
  end,
  SignBattleTipHelena_Btn_Gacha_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    if DataModel.isGoback == true then
      UIManager:GoBack()
    else
      UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipHelena")
    end
    local t = {}
    t.poolId = 80500248
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  SignBattleTipHelena_Btn_Activity_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipHelena")
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end
}
return ViewFunction
