local View = require("UIPrisonAccommodationContract/UIPrisonAccommodationContractView")
local DataModel = {}
DataModel.costList = {}
DataModel.prisonCA = nil

function DataModel.InitData()
  DataModel.costList = {}
  local prisonCA = PlayerData:GetFactoryData(86800014, "PrisonFactory")
  for i, v in pairs(prisonCA.buyWorkshopPrice) do
    if not DataModel.costList[v.id] then
      DataModel.costList[v.id] = v.num
    else
      DataModel.costList[v.id] = DataModel.costList[v.id] + v.num
    end
  end
  for roomTypeId, roomIndex in pairs(PrisonData.CellRoomTypeIdToRoomIndexMap) do
    if roomIndex == PrisonData.roomIndex then
      DataModel.roomTypeId = roomTypeId
      break
    end
  end
  DataModel.prisonCA = prisonCA
end

function DataModel.RefreshOnShow()
  View.Txt_Yifang:SetText(string.format(GetText(80607160), PlayerData:GetUserInfo().role_name))
  local prisonCA = DataModel.prisonCA
  local goldCostCfg
  for i, v in ipairs(prisonCA.buyWorkshopPrice) do
    if v.id == 11400001 then
      goldCostCfg = v
      break
    end
  end
  if goldCostCfg then
    View.Group_Gold.Txt_Num:SetText(goldCostCfg.num)
    local costItem = PlayerData:GetFactoryData(goldCostCfg.id)
    View.Group_Gold.Img_:SetSprite(costItem.buyPath)
  end
  local powerCost = prisonCA.initialRoomNum * prisonCA.cellSpaceOccupyPower
  View.Group_Power.Txt_Num:SetText(powerCost)
end

return DataModel
