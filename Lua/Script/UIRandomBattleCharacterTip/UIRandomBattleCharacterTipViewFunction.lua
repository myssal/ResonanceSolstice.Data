local View = require("UIRandomBattleCharacterTip/UIRandomBattleCharacterTipView")
local DataModel = require("UICharacterTips/UICharacterTipsDataModel")
local ViewFunction = {
  RandomBattleCharacterTip_Group_Information_Group_Equipment_Group_Equipment_Group_Have_Btn_Item_Click = function(btn, str)
  end,
  RandomBattleCharacterTip_Group_Information_Group_Equipment_StaticGrid_Equipment_SetGrid = function(element, elementIndex)
    DataModel:OnSetEquipGrid(element, elementIndex)
  end,
  RandomBattleCharacterTip_Group_Information_Group_Equipment_StaticGrid_Equipment_Group_Equipment_Group_Have_Btn_Item_Click = function(btn, str)
    local idx = tonumber(str)
    local equipData = DataModel.RoleData.equips[idx]
    if equipData and next(equipData) ~= nil then
      CommonTips.OpenRandomBattleEquipmentTips(equipData)
    end
  end,
  RandomBattleCharacterTip_Img_PageBg_Btn_1_Click = function(btn, str)
    DataModel:ClickRightTop(1)
  end,
  RandomBattleCharacterTip_Img_PageBg_Btn_2_Click = function(btn, str)
    DataModel:ClickRightTop(2)
  end,
  RandomBattleCharacterTip_Img_PageBg_Btn_3_Click = function(btn, str)
    DataModel:ClickRightTop(3)
  end,
  RandomBattleCharacterTip_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.self:Confirm()
    UIManager:GoBack(false)
    DataModel:Clear()
  end,
  RandomBattleCharacterTip_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  RandomBattleCharacterTip_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  RandomBattleCharacterTip_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
