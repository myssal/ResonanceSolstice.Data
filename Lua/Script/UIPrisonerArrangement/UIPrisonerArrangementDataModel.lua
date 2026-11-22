local View = require("UIPrisonerArrangement/UIPrisonerArrangementView")
local DataModel = {}

function DataModel:Init()
  View.Txt_Title:SetText(string.format(GetText(80607255), #DataModel.uidList))
  View.ScrollGrid_.grid.self:SetDataCount(#DataModel.uidList)
  View.ScrollGrid_.grid.self:RefreshAllElement()
  View.ScrollGrid_.grid.self:MoveToTop()
end

function DataModel:SetPrisonerGrid(element, elementIndex)
  local uid = DataModel.uidList[elementIndex]
  local prisonerData = PlayerData.ServerData.user_prison_info.prison_backpack[uid]
  local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id)
  element.Txt_Name:SetText(prisonerCA.prisonerName)
  local personalityCA = PlayerData:GetFactoryData(prisonerData.personality_id)
  element.Group_Personality.Txt_:SetText(personalityCA.prisonerPersonalityName)
  if personalityCA.icon ~= nil and personalityCA.icon ~= "" then
    element.Group_Personality.Img_:SetSprite(personalityCA.icon)
  end
  local specialityCA = PlayerData:GetFactoryData(prisonerData.speciality_id)
  if specialityCA then
    element.Group_GoodAt.Txt_:SetText(specialityCA.prisonerSpeciality)
    element.Group_GoodAt.Img_:SetSprite(specialityCA.icon)
  end
  element.Img_Prisoner:SetSprite(prisonerCA.prisonerIconPath)
  local rarityCA = PlayerData:GetFactoryData(prisonerCA.prisonerRarity)
  element.Img_Rarity:SetSprite(rarityCA.prisonerRarity)
  local sideCA = PlayerData:GetFactoryData(prisonerCA.prisonerSide)
  if sideCA then
    element.Img_Side:SetSprite(sideCA.iconPath)
  end
  local client_num
  if prisonerData.clint_num then
    local zeroCount = 6 - string.len(prisonerData.clint_num)
    client_num = prisonerData.clint_num
    for i = 1, zeroCount do
      client_num = 0 .. client_num
    end
  else
    client_num = "XXXXXX"
  end
  element.Txt_ID:SetText(string.format(GetText(80607161), client_num))
  element.Group_Time.Txt_:SetText(string.format(GetText(80607165), prisonerData.days))
end

return DataModel
