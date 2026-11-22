local View = require("UIArrestSettlement/UIArrestSettlementView")
local DataModel = {}

function DataModel:SetView(view)
  View = view
end

function DataModel:Init(param)
  self.prisonerList = {}
  for k, v in pairs(param.prisonerDic) do
    self.prisonerList[#self.prisonerList + 1] = v
  end
  local prisonerCount = #self.prisonerList
  View.Txt_:SetText(string.format(GetText(80602028), prisonerCount))
  View.ScrollGrid_.self:SetActive(3 <= prisonerCount)
  View.ScrollGrid_Center.self:SetActive(prisonerCount < 3)
  if 3 <= prisonerCount then
    View.ScrollGrid_.grid.self:SetDataCount(prisonerCount)
    View.ScrollGrid_.grid.self:RefreshAllElement()
    View.ScrollGrid_.grid.self:MoveToTop()
  else
    View.ScrollGrid_Center.grid.self:SetDataCount(prisonerCount)
    View.ScrollGrid_Center.grid.self:RefreshAllElement()
    View.ScrollGrid_Center.grid.self:MoveToTop()
  end
  if View.Group_LeftDown then
    local totalPrisonerCount = table.count(PrisonData.GetPrisonerBag())
    local maxPrisonerCount = PrisonData.GetPrisonerBagMaxCapacity()
    View.Group_LeftDown.Img_BarUp:SetFilledImgAmount(totalPrisonerCount / maxPrisonerCount)
    View.Group_LeftDown.Txt_Num:SetText(string.format(GetText(80611830), totalPrisonerCount - prisonerCount, prisonerCount, maxPrisonerCount))
  end
end

function DataModel:OnPrisonerSetGrid(element, elementIndex)
  local prisonerData = DataModel.prisonerList[elementIndex]
  local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id)
  element.Txt_Name:SetText(prisonerCA.prisonerName)
  element.Img_Pic:SetSprite(prisonerCA.prisonerIconPath)
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
  local rarityCA = PlayerData:GetFactoryData(prisonerCA.prisonerRarity)
  element.Img_Rarity:SetSprite(rarityCA.prisonerRarity)
  local zeroNum = 3 - string.len(elementIndex)
  for i = 1, zeroNum do
    elementIndex = 0 .. elementIndex
  end
  element.Txt_Num:SetText(elementIndex)
end

return DataModel
