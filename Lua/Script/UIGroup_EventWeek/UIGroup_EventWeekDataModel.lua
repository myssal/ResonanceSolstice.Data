local DataModel = {}

function DataModel.Init()
  DataModel.acitityId = 86000010
  DataModel.nowActivityEvent = tonumber(PlayerData.ServerData.server_resident["86000010"].id)
  local activityIdCfg = PlayerData:GetFactoryData(DataModel.acitityId)
  DataModel.npcId = activityIdCfg.npcId
  local cfg = PlayerData:GetFactoryData(DataModel.nowActivityEvent)
  DataModel.cityName = PlayerData:GetFactoryData(cfg.city).name
  local eventCfg = {}
  for i, v in ipairs(activityIdCfg.eventRandomWeek) do
    if v.id == DataModel.nowActivityEvent then
      eventCfg = v
      break
    end
  end
  DataModel.nowInterviewNpcId = eventCfg.npcId
  DataModel.nowInterviewBg = eventCfg.bgPng
  DataModel.tvBgPng = eventCfg.tvBgPng
  DataModel.nowTitle = eventCfg.titleText
  DataModel.nowcircleText = eventCfg.circleText
  DataModel.eventText = eventCfg.eventText
  DataModel.helpId = activityIdCfg.helpId
  DataModel.nowTradList = {}
  DataModel.nowQueatList = {}
  DataModel.nowManufactureList = {}
  DataModel.nowOrderList = {}
end

function DataModel.GetTradData()
  if next(DataModel.nowTradList) == nil then
    local activityListCfg = PlayerData:GetFactoryData(DataModel.nowActivityEvent)
    for i, v in ipairs(activityListCfg.goodsList) do
      table.insert(DataModel.nowTradList, {
        goodsId = v.goodsId
      })
    end
    for i, v in ipairs(activityListCfg.RareTradeData) do
      local tradeConfig = PlayerData:GetFactoryData(v.RareTradeInterval)
      table.insert(DataModel.nowTradList, {
        goodsId = v.id,
        buy_price = {
          min_quota = tradeConfig.rareGoodsQuotationMin,
          max_quota = tradeConfig.rareGoodsQuotationMax
        }
      })
    end
  end
  return DataModel.nowTradList
end

function DataModel.GetQueatData()
  if next(DataModel.nowQueatList) == nil then
    local activityListCfg = PlayerData:GetFactoryData(DataModel.nowActivityEvent)
    DataModel.nowQueatList = Clone(activityListCfg.activityPassengerList)
    local cfg = PlayerData:GetFactoryData(activityListCfg.activityLeafletNum) or {}
    if next(cfg) then
      local desc = cfg.desc
      table.insert(DataModel.nowQueatList, {desc = desc})
    end
    local data = activityListCfg.activityGradeList
    for i, v in ipairs(data) do
      table.insert(DataModel.nowQueatList, {
        id = v.id,
        showIcon = true,
        desc = ""
      })
    end
    local desc = GetText(80607267) .. DataModel.cityName
    local data = activityListCfg.priceSeatList
    for i, v in ipairs(data) do
      table.insert(DataModel.nowQueatList, {
        id = v.id,
        showIcon = true,
        desc = desc
      })
    end
    local data = activityListCfg.gradeIncomeList
    for i, v in ipairs(data) do
      table.insert(DataModel.nowQueatList, {
        id = v.id,
        showIcon = true,
        desc = desc
      })
    end
  end
  return DataModel.nowQueatList
end

function DataModel.GetManufactureData()
  if next(DataModel.nowManufactureList) == nil then
    local activityListCfg = PlayerData:GetFactoryData(DataModel.nowActivityEvent)
    local data = activityListCfg.recycleCityList
    local ownList = {}
    for i, v in ipairs(data) do
      local cfg = PlayerData:GetFactoryData(v.materialList)
      for i1, v1 in ipairs(cfg.materialList) do
        if ownList[v1.id] == nil then
          local cfg = PlayerData:GetFactoryData(v1.id)
          local basePrice = cfg.rewardList[1].num
          table.insert(DataModel.nowManufactureList, {
            id = v1.id,
            highCoefficient = v.highCoefficient,
            basePrice = basePrice
          })
        end
        ownList[v1.id] = 1
      end
    end
  end
  return DataModel.nowManufactureList
end

function DataModel.GetOrderData()
  DataModel.nowOrderList = {}
  local requireItemRecord = {}
  local activityListCfg = PlayerData:GetFactoryData(DataModel.nowActivityEvent)
  for i, v in ipairs(activityListCfg.orderUpList) do
    local cfg = PlayerData:GetFactoryData(v.id)
    if requireItemRecord[cfg.requireItemList[1].id] == nil then
      requireItemRecord[cfg.requireItemList[1].id] = 1
      table.insert(DataModel.nowOrderList, {
        id = cfg.id,
        param = v.param
      })
    end
  end
  return DataModel.nowOrderList
end

function DataModel.GetRedDotStatus()
  local refreshTime = PlayerData:GetPlayerPrefs("int", "RefreshTime")
  local serverTime = TimeUtil:GetServerTimeStamp()
  return refreshTime < serverTime
end

return DataModel
