local View = require("UIChangeSealEvent/UIChangeSealEventView")
local DataModel = require("UIChangeSealEvent/UIChangeSealEventDataModel")
local Controller = {}

function Controller:Init()
  local isGetMulti = DataModel.sealEventType == "refreshSealToFull"
  View.Group_GetMulti:SetActive(isGetMulti)
  View.Group_Copy:SetActive(not isGetMulti)
  if isGetMulti then
    View.Group_GetMulti.Group_Deal.StaticGrid_Seal.grid.self:SetDataCount(#DataModel.sealList)
    View.Group_GetMulti.Group_Deal.StaticGrid_Seal.grid.self:RefreshAllElement()
  else
    View.Group_Copy.Group_Deal.StaticGrid_Seal.grid.self:SetDataCount(#DataModel.sealList)
    View.Group_Copy.Group_Deal.StaticGrid_Seal.grid.self:RefreshAllElement()
  end
end

local function setSealInfo(element, sealId)
  local sealCA = PlayerData:GetFactoryData(sealId)
  element.Img_Seal:SetSprite(sealCA.iconPath)
  element.Txt_Seal:SetText(sealCA.name)
end

function Controller:SetGetMultiSealElement(element, elementIndex)
  setSealInfo(element, DataModel.sealList[elementIndex])
end

function Controller:SetCopySealElement(element, elementIndex)
  local sealId = DataModel.sealList[elementIndex]
  local isSelect = DataModel.selectIndex == elementIndex
  element.Group_Empty:SetActive(not isSelect)
  element.Group_Pick:SetActive(isSelect)
  element.Btn_Instead:SetClickParam(elementIndex)
  setSealInfo(element, sealId)
end

function Controller:SelectSeal(elementIndex)
  if DataModel.selectIndex == elementIndex then
    return
  end
  DataModel.selectIndex = elementIndex
  View.Group_Copy.Group_Deal.StaticGrid_Seal.grid.self:RefreshAllElement()
end

function Controller:CloseAndContinue()
  local eventCA = PlayerData:GetFactoryData(DataModel.eventId, "MonopolyEventFactory")
  UIManager:GoBack()
  if eventCA.sucid and eventCA.sucid > 0 then
    local EventDataModel = require("UIWitchesEvent/UIWitchesEventDataModel")
    EventDataModel.DealEvent(eventCA.sucid)
  end
end

function Controller:ConfirmCopy()
  if DataModel.isSubmitting or DataModel.selectIndex <= 0 then
    return
  end
  DataModel.isSubmitting = true
  local sealId = DataModel.sealList[DataModel.selectIndex]
  local eventCA = PlayerData:GetFactoryData(DataModel.eventId, "MonopolyEventFactory")
  WitchData.ReqDealEvent(DataModel.eventId, function(json)
    DataModel.isSubmitting = false
    for _, costInfo in ipairs(eventCA.CostList or {}) do
      WitchData.RefreshUseItems({
        [costInfo.id] = costInfo.num
      })
    end
    WitchData.GetWitchesData().other_seal = json.other_seal or {}
    WitchData.GetWitchesData().user_seal = json.user_seal or {}
    UIManager:GoBack()
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Main/Seal"), Json.encode({
      witchEventNextId = eventCA.sucid
    }))
  end, sealId)
end

return Controller
