local View = require("UISignBattleTipChenshuxian/UISignBattleTipChenshuxianView")
local DataModel = require("UISignBattleTipChenshuxian/UISignBattleTipChenshuxianDataModel")
local ViewFunction = {
  SignBattleTipChenshuxian_Video_Main_Skip_Click = function(btn, str)
  end,
  SignBattleTipChenshuxian_Btn_Gacha_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    if DataModel.isGoback == true then
      UIManager:GoBack()
    else
      UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipChenshuxian")
    end
    if DataModel.activityCA then
      local t = {}
      t.poolId = DataModel.activityCA.signBattleExtract
      UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
    end
  end,
  SignBattleTipChenshuxian_Btn_Activity_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipChenshuxian")
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end
}
return ViewFunction
