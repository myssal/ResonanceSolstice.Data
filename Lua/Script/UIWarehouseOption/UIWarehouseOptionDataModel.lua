local DataModel = {
  initParams = {},
  remainBuySpace = 0,
  expandInfo = {
    isUnlock = false,
    repLock = 0,
    numLock = 0,
    expandNum = 0
  },
  EnumType = {
    Buy = 1,
    Expand = 2,
    Transport = 3
  }
}

function DataModel.RefreshRemainStationSpace()
  local homeCommon = require("Common/HomeCommon")
  local repData = homeCommon.GetCurLvRepData(DataModel.initParams.stationId)
  local maxNum = repData.wareNum
  local strStationId = tostring(DataModel.initParams.stationId)
  local stations = PlayerData:GetHomeInfo().stations[strStationId]
  local extraWarehouseList = PlayerData:GetFactoryData(DataModel.initParams.stationId).extraWarehouseList
  local ws_info = stations.ws_info or {}
  if ws_info then
    for i, num in ipairs(ws_info) do
      maxNum = maxNum + extraWarehouseList[i].addNum * num
    end
  end
  local curNum = stations.max_goods_space or 0
  DataModel.remainBuySpace = maxNum - curNum
end

function DataModel.RefreshExpandInfo()
  local extraWarehouseList = PlayerData:GetFactoryData(DataModel.initParams.stationId).extraWarehouseList
  local strStationId = tostring(DataModel.initParams.stationId)
  local stations = PlayerData:GetHomeInfo().stations[strStationId]
  local ws_info = stations.ws_info or {}
  DataModel.expandInfo = {
    isUnlock = false,
    repLock = 0,
    numLock = 0,
    expandNum = 0
  }
  if ws_info then
    local homeCommon = require("Common/HomeCommon")
    local repLv = homeCommon.GetRepLv(DataModel.initParams.stationId)
    local curBuyNum = stations.max_goods_space or 0
    for i, v in ipairs(extraWarehouseList) do
      if repLv < v.reputation or curBuyNum < v.buyNum then
        DataModel.expandInfo.isUnlock = false
        DataModel.expandInfo.repLock = v.reputation
        DataModel.expandInfo.numLock = v.buyNum
        break
      end
      DataModel.expandInfo.isUnlock = true
      local curExpandCount = ws_info[i] or 0
      if curExpandCount < v.useNum then
        DataModel.expandInfo.expandNum = (v.useNum - curExpandCount) * v.addNum
        break
      end
    end
  end
end

return DataModel
