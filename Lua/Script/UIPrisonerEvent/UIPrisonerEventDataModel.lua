local View = require("UIPrisonerEvent/UIPrisonerEventView")
local DataModel = {}
DataModel.eventCA = PlayerData:GetFactoryData(88000001, "PrisonerEventFactory")
DataModel.cellIndex = nil
DataModel.roomIndex = nil
DataModel.productData = nil

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.cellIndex = data.cellIndex
end

function DataModel.InitData()
  DataModel.roomIndex = PrisonData.roomIndex
  if DataModel.cellIndex then
    local allProducts = PrisonData.GetRoomProducts(DataModel.roomIndex)
    DataModel.productData = allProducts and allProducts[tostring(DataModel.cellIndex)]
    local eventCfg = PrisonData.GetAccidentCfg(DataModel.roomIndex, DataModel.cellIndex)
    if not eventCfg then
      eventCfg = DataModel.eventCA.personalityFetterList[1] or DataModel.eventCA.haloFetterList[1]
      if not eventCfg then
        return
      end
    end
    DataModel.eventCfg = eventCfg
  end
end

function DataModel.RefreshOnShow()
  local productData = DataModel.productData
  if productData then
    local eventCfg = DataModel.eventCfg
    local prisonerData = PrisonData.GetPrisoner(productData.u_pid)
    local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id, "PrisonerFactory")
    local characterCA = PlayerData:GetFactoryData(prisonerCA.PrisonerAnimation, "HomeCharacterFactory")
    local fetterId = eventCfg and eventCfg.fetterId
    local tagCA = PlayerData:GetFactoryData(fetterId, "TagFactory")
    View.Group_Detail.Txt_Name:SetText(tagCA.prisonerPersonalityFetterName)
    View.Group_Detail.Txt_Des:SetText(tagCA.prisonerPersonalityFetterDesc)
    View.Group_Spine.Group_Two:SetActive(productData.event_trammels and eventCfg.combinationAcotionSpinePath == "")
    if View.Group_Spine.Group_Two.IsActive and tagCA.prisonerEvent[1] then
      local animName = tagCA.prisonerEvent[1].actionName
      View.Group_Spine.Group_Two.SpineAnimation_First:SetData(characterCA.resDir)
      View.Group_Spine.Group_Two.SpineAnimation_First:SetActionWithoutMix(animName, true, true)
      local otherCellIndex = productData.event_trammels.other
      local prisonerList = PrisonData.GetPlacedPrisonerList(PrisonData.roomIndex)
      local otherU_pid = prisonerList[otherCellIndex]
      local otherPrisonerData = PrisonData.GetPrisoner(otherU_pid)
      local otherPrisonerCA = PlayerData:GetFactoryData(otherPrisonerData.prisoner_id, "PrisonerFactory")
      local otherCharacterCA = PlayerData:GetFactoryData(otherPrisonerCA.PrisonerAnimation, "HomeCharacterFactory")
      View.Group_Spine.Group_Two.SpineAnimation_Second:SetData(otherCharacterCA.resDir)
      View.Group_Spine.Group_Two.SpineAnimation_Second:SetActionWithoutMix(animName, true, true)
    end
    View.Group_Spine.Group_Combine:SetActive(productData.event_trammels and eventCfg.combinationAcotionSpinePath ~= "")
    if View.Group_Spine.Group_Combine.IsActive then
      local animName = tagCA.prisonerEventCombinationAcotionName
      View.Group_Spine.Group_Combine.SpineAnimation_:SetData(tagCA.prisonerEventCombinationAcotionSpinePath)
      View.Group_Spine.Group_Combine.SpineAnimation_:SetActionWithoutMix(animName, true, true)
    end
    View.Group_Spine.Group_One:SetActive(not productData.event_trammels)
    if View.Group_Spine.Group_One.IsActive and tagCA.prisonerEvent[1] then
      local animName = tagCA.prisonerEvent[1].actionName
      View.Group_Spine.Group_One.SpineAnimation_:SetData(characterCA.resDir)
      View.Group_Spine.Group_One.SpineAnimation_:SetActionWithoutMix(animName, true, true)
    end
  end
  View.Btn_Dispose:SetActive(true)
  View.Btn_NoDispose:SetActive(true)
end

return DataModel
