local View = require("UIPrisonWorkshopContract/UIPrisonWorkshopContractView")
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
  DataModel.prisonCA = prisonCA
end

function DataModel.RefreshOnShow()
  local moneyCost = DataModel.costList[11400001] or 0
  View.Group_Gold.Txt_Num:SetText(moneyCost)
  View.Txt_Yifang:SetText(string.format(GetText(80607160), PlayerData:GetUserInfo().role_name))
end

return DataModel
