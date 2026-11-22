local View = require("UIBattleBossTip/UIBattleBossTipView")
local DataModel = require("UIBattleBossTip/UIBattleBossTipDataModel")
local ViewFunction = {
  BattleBossTip_Btn_BG_Click = function(btn, str)
    UIManager:CloseSpecialUI("UI/Chapter/Battle_Boss/BattleBossTip/BattleBossTip")
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({id = 86000005}))
  end,
  BattleBossTip_Btn_Open_Click = function(btn, str)
    UIManager:CloseSpecialUI("UI/Chapter/Battle_Boss/BattleBossTip/BattleBossTip")
    PlayerData:SetPlayerPrefs("int", "ActivityTip" .. DataModel.activityId .. DataModel.index, 1)
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end
}
return ViewFunction
