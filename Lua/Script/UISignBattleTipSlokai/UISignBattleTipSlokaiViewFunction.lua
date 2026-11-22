local View = require("UISignBattleTipSlokai/UISignBattleTipSlokaiView")
local DataModel = require("UISignBattleTipSlokai/UISignBattleTipSlokaiDataModel")
local ViewFunction = {
  SignBattleTipSlokai_Video_Main_Skip_Click = function(btn, str)
  end,
  SignBattleTipSlokai_Btn_Gacha_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    if DataModel.isGoback == true then
      UIManager:GoBack()
    else
      UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipIkara")
    end
    local poolId
    local actCa = PlayerData:GetFactoryData(86000067)
    if actCa and actCa.bannerList and actCa.bannerList[1] then
      poolId = actCa.bannerList[1].id
    end
    local t = {}
    t.poolId = poolId
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  SignBattleTipSlokai_Btn_Activity_Click = function(btn, str)
    View.SpineAnimation_Player:SetActive(false)
    UIManager:CloseSpecialUI("UI/Activity/ActivitySignBattle/SignBattleTipIkara")
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end
}
return ViewFunction
