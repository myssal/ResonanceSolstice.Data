local View = require("UISignBattleTipTistar/UISignBattleTipTistarView")
local DataModel = require("UISignBattleTipTistar/UISignBattleTipTistarDataModel")
local ViewFunction = {
  SignBattleTipTistar_Video_Main_Skip_Click = function(btn, str)
  end,
  SignBattleTipTistar_Btn_Gacha_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    if DataModel.isGoback == true then
      UIManager:GoBack()
    else
      UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipTistar")
    end
    local t = {}
    t.poolId = 80500327
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  SignBattleTipTistar_Btn_Activity_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipTistar")
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end
}
return ViewFunction
