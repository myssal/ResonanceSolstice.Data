local View = require("UIPrisonerEscape/UIPrisonerEscapeView")
local DataModel = require("UIPrisonerEscape/UIPrisonerEscapeDataModel")
local ViewFunction = {
  PrisonerEscape_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end,
  PrisonerEscape_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local info = DataModel.escapePrisoners[elementIndex]
    local data = info.data
    local escape = info.escape
    element.Group_Success:SetActive(escape)
    element.Group_Failure:SetActive(not escape)
    element.Group_Success.Txt_ID:SetText(string.format("%06d", data.clint_num))
    element.Group_Failure.Txt_ID:SetText(string.format("%06d", data.clint_num))
    local prisonCA = PlayerData:GetFactoryData(data.prisoner_id, "PrisonerFactory")
    element.Txt_Name:SetText(prisonCA.prisonerName)
    element.Img_Prisoner:SetSprite(prisonCA.prisonerIconPath)
    local tagCA = PlayerData:GetFactoryData(prisonCA.prisonerSide, "TagFactory")
    element.Img_Side.Img_:SetSprite(tagCA.iconPath)
  end
}
return ViewFunction
