local View = require("UIRandomBattleEquipmentTip/UIRandomBattleEquipmentTipView")
local DataModel = require("UIRandomBattleEquipmentTip/UIRandomBattleEquipmentTipDataModel")
local ViewFunction = {
  RandomBattleEquipmentTip_Btn_Black_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  RandomBattleEquipmentTip_ScrollView_Content_Viewport_Content_Btn_Tips1_Click = function(btn, str)
  end
}
return ViewFunction
