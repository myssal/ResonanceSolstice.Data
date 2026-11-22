local View = require("UIPrisonWarehouseOption/UIPrisonWarehouseOptionView")
local DataModel = require("UIPrisonWarehouseOption/UIPrisonWarehouseOptionDataModel")
local Controller = {}

function Controller:Init()
  Controller:SetElement(DataModel.EnumType.Buy)
  Controller:SetElement(DataModel.EnumType.Expand)
end

function Controller:SetElement(elementType)
  local element
  if elementType == DataModel.EnumType.Buy then
    element = View.Group_Buy
    DataModel.RefreshRemainStationSpace()
    local total = DataModel.GoldMaxSpace + DataModel.DiamondMaxSpace
    element.Group_Num.Txt_Num:SetText(total)
    element.Group_Empty:SetActive(total == 0)
  end
end

function Controller:ClickElement(elementType)
  if elementType == DataModel.EnumType.Buy then
    if DataModel.GoldMaxSpace + DataModel.DiamondMaxSpace == 0 then
      CommonTips.OpenTips(80607526)
    else
      local t = Clone(DataModel.initParams)
      t.buyType = DataModel.initParams.type
      t.goldMaxSpace = DataModel.GoldMaxSpace
      t.diamondMaxSpace = DataModel.DiamondMaxSpace
      UIManager:Open("UI/Prison/PrisonWarehouse/WarehouseNew/PrisonWarehouseBuy", Json.encode(t))
    end
  elseif elementType == DataModel.EnumType.Expand then
    UIManager:Open("UI/Prison/PrisonWarehouse/WarehouseNew/PrisonExtendTips", Json.encode(DataModel.initParams))
  end
end

function Controller:Return()
  UIManager:GoBack()
end

return Controller
