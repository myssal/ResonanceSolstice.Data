local View = require("UIRandomBattleEquipmentTip/UIRandomBattleEquipmentTipView")
local DataModel = require("UIGroup_EquipmentItem/UIGroup_EquipmentItemDataModel")
local ViewFunction = require("UIRandomBattleEquipmentTip/UIRandomBattleEquipmentTipViewFunction")

local function init(parms)
  CA = PlayerData:GetFactoryData(parms.id)
  View.Img_Equipment:SetSprite(parms.tipsPath)
  View.Txt_Color:SetText(UIConfig.ColorText[tonumber(parms.qualityInt + 1)])
  View.Txt_Color:SetColor(UIConfig.RandomBattleQualityColor[tonumber(parms.qualityInt)])
  View.Txt_Color.Txt_EquipmentName:SetText(parms.name)
  View.Txt_EquipmentLevel:SetText("LV " .. parms.server.lv)
  local index = PlayerData:GetTypeInt("enumEquipTypeList", DataModel.equipCA.equipTagId)
  View.Group_Type.Img_1:SetActive(index == 1)
  View.Group_Type.Img_2:SetActive(index == 2)
  View.Group_Type.Img_3:SetActive(index == 3)
  DataModel:RefreshRightContent()
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel:SetUIScript("UIRandomBattleEquipmentTip/UIRandomBattleEquipmentTipView")
    if initParams then
      local data = Json.decode(initParams)
      DataModel.params = data
      DataModel.isChangeLock = false
      DataModel.eid = data.eid
      DataModel.itemId = data.id
      DataModel.equipCA = PlayerData:GetFactoryData(data.id)
      DataModel.EquipFactory = PlayerData:GetFactoryData(99900027)
      DataModel.Max_Affix_Num = PlayerData:GetFactoryData(DataModel.equipCA.equipTagId).typeName
      init(data)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
