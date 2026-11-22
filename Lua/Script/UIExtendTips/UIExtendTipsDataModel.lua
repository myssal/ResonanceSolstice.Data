local DataModel = {
  initParams = {},
  itemId = 0,
  canUseNum = 0,
  oneAddNum = 0,
  hadNum = 0,
  curUseNum = 1,
  expandIndex = 0
}

function DataModel.Init()
  DataModel.curUseNum = 1
  local tradeCA = PlayerData:GetFactoryData(99900062)
  DataModel.itemId = tradeCA.extraWarehouse
  DataModel.hadNum = PlayerData:GetGoodsById(DataModel.itemId).num
  local strStationId = tostring(DataModel.initParams.stationId)
  local stations = PlayerData:GetHomeInfo().stations[strStationId]
  local extraWarehouseList = PlayerData:GetFactoryData(DataModel.initParams.stationId).extraWarehouseList
  local ws_info = stations.ws_info or {}
  if ws_info then
    for i, v in ipairs(extraWarehouseList) do
      local curUseNum = ws_info[i] or 0
      if curUseNum < v.addNum then
        DataModel.canUseNum = v.useNum - curUseNum
        DataModel.oneAddNum = v.addNum
        DataModel.expandIndex = i - 1
        break
      end
    end
  end
end

return DataModel
