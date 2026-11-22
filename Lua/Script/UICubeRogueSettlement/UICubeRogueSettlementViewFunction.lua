local View = require("UICubeRogueSettlement/UICubeRogueSettlementView")
local DataModel = require("UICubeRogueSettlement/UICubeRogueSettlementDataModel")
local Controller = require("UICubeRogueSettlement/UICubeRogueSettlementController")
local ViewFunction = {
  CubeRogueSettlement_Group_Process_1_Btn_Off_Click = function(btn, str)
    Controller.ShowPanel2()
  end,
  CubeRogueSettlement_Group_Process_2_ScrollView_Process_2_Viewport_Content_Img_Equipment_Btn_Bag_Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/CubeWarehouse/CubeWarehouse", Json.encode({index = 2}))
  end,
  CubeRogueSettlement_Group_Process_2_ScrollView_Process_2_Viewport_Content_Img_BuffTitle_Btn_Bag_Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/CubeWarehouse/CubeWarehouse", Json.encode({index = 1}))
  end,
  CubeRogueSettlement_Group_Process_2_ScrollView_Process_2_Viewport_Content_Group_Character_ScrollGrid_Character_SetGrid = function(element, elementIndex)
    local data = DataModel.allRole[elementIndex]
    element.Group_Lv.Txt_Num:SetText(data.lv)
    element.Img_Face.Img_Face:SetSprite(data.facePath)
    local quality1 = "UI/CubeRogue/QualityBG/Character/Small/" .. Controller.Enum_RoleQuality[data.qualityInt + 1]
    element.Img_Quality:SetSprite(quality1)
    local quality2 = quality1 .. "_Mask"
    element.Img_Mask:SetSprite(quality2)
  end,
  CubeRogueSettlement_Group_Process_2_ScrollView_Process_2_Viewport_Content_Group_Equipment_ScrollGrid_Equipment_SetGrid = function(element, elementIndex)
    local data = DataModel.allEquip[elementIndex]
    local cfg = PlayerData:GetFactoryData(data.id, "RogueEquipmentFactory")
    element.Img_Bg_Active:SetActive(not cfg.isNegative)
    element.Img_Bg_Negative:SetActive(cfg.isNegative)
    element.Img_TacticIcon:SetSprite(cfg.iconPath)
  end,
  CubeRogueSettlement_Group_Process_2_ScrollView_Process_2_Viewport_Content_Group_Buff_ScrollGrid_TacticBuff_SetGrid = function(element, elementIndex)
    local data = DataModel.allTeam[elementIndex]
    local cfg = PlayerData:GetFactoryData(data.id, "RogueTeamFactory")
    element.Img_TacticIcon:SetSprite(cfg.cardIconPath)
    element.Txt_BuffNum:SetText(data.num)
  end,
  CubeRogueSettlement_Group_Process_2_Group_Btn_Btn_Confirm_Click = function(btn, str)
    Controller.OnConfirmClick()
  end,
  CubeRogueSettlement_Group_Process_2_Group_Btn_Btn_ConfirmNot_Click = function(btn, str)
    Controller.OnConfirmClick()
  end
}
return ViewFunction
