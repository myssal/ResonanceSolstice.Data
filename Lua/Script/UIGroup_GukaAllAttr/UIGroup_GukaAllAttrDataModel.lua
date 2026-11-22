local View = require("UIGroup_GukaAllAttr/UIGroup_GukaAllAttrView")
local DataModel = {
  GuKaEffectList = {},
  IsInGuKaView = false
}

function DataModel.Init()
  DataModel.GuKaEffectList = {}
  local gukaDataModel = require("UIGuKa/UIGuKaDataModel")
  DataModel.GuKaEffectList = Clone(gukaDataModel.CollectGuKaEffects(DataModel.IsInGuKaView))
  View.ScrollGrid_.grid.self:SetDataCount(#DataModel.GuKaEffectList)
  View.ScrollGrid_.grid.self:RefreshAllElement()
end

function DataModel.SetEffectElement(element, elementIndex)
  local data = DataModel.GuKaEffectList[elementIndex]
  local effectCfg
  if data.skillId then
    effectCfg = PlayerData:GetFactoryData(data.skillId)
  end
  local gukaCfg = PlayerData:GetFactoryData(data.gukaId)
  element.Img_GuKaIcon:SetSprite(gukaCfg.iconPath)
  element.Img_GuKaName.Txt_Name:SetText(gukaCfg.name)
  element.Txt_GuKaLevel:SetText(data.gukaLv .. "/10")
  if effectCfg then
    if effectCfg.isPercent then
      local value = effectCfg.minAttrSN + effectCfg.digitSN * (data.gukaLv - 1)
      value = value * 100
      element.Group_Entry.Txt_Entry_1:SetText(string.format(effectCfg.description, value .. "%"))
    else
      element.Group_Entry.Txt_Entry_1:SetText(string.format(effectCfg.description, effectCfg.minAttrSN + (data.gukaLv - 1) * effectCfg.digitSN))
    end
  end
end

return DataModel
