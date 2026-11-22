local View = require("UIWarehouseOption/UIWarehouseOptionView")
local DataModel = require("UIWarehouseOption/UIWarehouseOptionDataModel")
local Controller = {}

function Controller:Init()
  Controller:SetElement(DataModel.EnumType.Buy)
  Controller:SetElement(DataModel.EnumType.Expand)
  Controller:SetElement(DataModel.EnumType.Transport)
end

function Controller:SetElement(elementType)
  local element
  if elementType == DataModel.EnumType.Buy then
    element = View.Group_Buy
    DataModel.RefreshRemainStationSpace()
    element.Group_Num.Txt_Num:SetText(DataModel.remainBuySpace)
    element.Group_Empty:SetActive(DataModel.remainBuySpace == 0)
  elseif elementType == DataModel.EnumType.Expand then
    element = View.Group_Expand
    DataModel.RefreshExpandInfo()
    element.Group_Num:SetActive(DataModel.expandInfo.isUnlock)
    element.Group_Unlocked:SetActive(not DataModel.expandInfo.isUnlock)
    element.Group_Empty:SetActive(DataModel.expandInfo.isUnlock and DataModel.expandInfo.expandNum == 0)
    if DataModel.expandInfo.isUnlock then
      element.Group_Num.Txt_Num:SetText(DataModel.expandInfo.expandNum)
    else
      element.Group_Unlocked.Group_Condition.Txt_Rep:SetText(string.format(GetText(80607523), DataModel.expandInfo.repLock))
      element.Group_Unlocked.Group_Condition.Txt_BuyNum:SetActive(0 < DataModel.expandInfo.numLock)
      element.Group_Unlocked.Group_Condition.Txt_BuyNum:SetText(string.format(GetText(80607525), DataModel.expandInfo.numLock))
    end
  elseif elementType == DataModel.EnumType.Transport then
    element = View.Group_Transport
  end
end

function Controller:ClickElement(elementType)
  if elementType == DataModel.EnumType.Buy then
    if DataModel.remainBuySpace == 0 then
      CommonTips.OpenTips(80607526)
    else
      local t = Clone(DataModel.initParams)
      t.maxNum = DataModel.remainBuySpace
      UIManager:Open("UI/HomeTrade/WarehouseBuy", Json.encode(t))
    end
  elseif elementType == DataModel.EnumType.Expand then
    if DataModel.expandInfo.isUnlock then
      if DataModel.expandInfo.expandNum == 0 then
        CommonTips.OpenTips(80607529)
      else
        UIManager:Open("UI/HomeTrade/ExtendTips", Json.encode(DataModel.initParams))
      end
    else
      CommonTips.OpenTips(80607527)
    end
  elseif elementType == DataModel.EnumType.Transport then
    CommonTips.OpenTips(80607528)
  end
end

function Controller:Return()
  UIManager:GoBack()
end

return Controller
