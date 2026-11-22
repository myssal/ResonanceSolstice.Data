local View = require("UIHYOrderStation/UIHYOrderStationView")
local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
local DataModel = {}
DataModel.StationId = nil
DataModel.MenuTab = {
  None = 0,
  Order = 1,
  WeekOrder = 2
}
DataModel.curMenuTab = nil
DataModel.buildCA = nil

function DataModel.InitData()
  DataModel.StationId = TradeDataModel.CurStayCity
  DataModel.buildCA = PlayerData:GetFactoryData(84400137, "PrisonFactory")
  DataModel.curMenuTab = DataModel.MenuTab.None
end

function DataModel.SetJsonData(json)
  if not json then
    DataModel.curMenuTab = DataModel.MenuTab.None
    return
  end
  local data = Json.decode(json)
  DataModel.curMenuTab = data.curMenuTab or DataModel.MenuTab.None
end

function DataModel.GetManufactureRedPoint()
  local fursData = PlayerData:GetFurniture()
  for ufid, v in pairs(fursData) do
    local furCA = PlayerData:GetFactoryData(v.id, "HomeFurnitureFactory")
    local manufactureType = furCA.manufactureType
    if manufactureType == 12601174 then
      local machiningData = require("UIHome_MachiningMenu/UIHome_MachiningMenuDataModel")
      return machiningData.GetFormulaRedState(v.id)
    end
  end
  return false
end

return DataModel
