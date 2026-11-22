local View = require("UIWitchesTeaBuff/UIWitchesTeaBuffView")
local DataModel = require("UIWitchesTeaBuff/UIWitchesTeaBuffDataModel")
local ViewFunction = {
  WitchesTeaBuff_StaticGrid_BuffList_SetGrid = function(element, elementIndex)
    local skillId = tonumber(DataModel.selectInfo[elementIndex])
    local info
    local eventCA = PlayerData:GetFactoryData(DataModel.eventId, "MonopolyEventFactory")
    for i, v in ipairs(eventCA.buffList) do
      if v.id == skillId then
        info = v
        break
      end
    end
    if not info then
      return
    end
    element.Img_Item:SetSprite(info.teaBuffIcon)
    local skillCA = PlayerData:GetFactoryData(info.id, "SkillFactory")
    element.Txt_Name:SetText(skillCA.name)
    element.Txt_Des:SetText(skillCA.description)
    element.Btn_Buy:SetClickParam(elementIndex)
  end,
  WitchesTeaBuff_StaticGrid_BuffList_Group_TeaBuff_Btn_Buy_Click = function(btn, str)
    local index = tonumber(str)
    WitchData.ReqSelectResetBuff(index)
    View.self:CloseUI(true)
  end
}
return ViewFunction
