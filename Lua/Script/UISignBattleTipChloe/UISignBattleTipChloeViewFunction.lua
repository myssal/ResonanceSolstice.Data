local View = require("UISignBattleTipChloe/UISignBattleTipChloeView")
local DataModel = require("UISignBattleTipChloe/UISignBattleTipChloeDataModel")
local ViewFunction = {
  SignBattleTipChloe_Video_Main_Skip_Click = function(btn, str)
  end,
  SignBattleTipChloe_Btn_Gacha_Click = function(btn, str)
    View.Spine_Player:SetActive(false)
    if DataModel.isGoback == true then
      UIManager:GoBack()
    else
      UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipChloe")
    end
    local t = {}
    t.poolId = 80500174
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  SignBattleTipChloe_Btn_Activity_Click = function(btn, str)
    View.Spine_Player:SetActive(false)
    UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipChloe")
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end
}
return ViewFunction
