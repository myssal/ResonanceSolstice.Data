local DataModel = {
  storeId = nil,
  storeCA = nil,
  npcId = 83700146,
  storeList = {},
  NPCDialogEnum = {
    enterText = "enterText",
    talkText = "talkText",
    buySuccessText = "buySuccessText",
    saleOutText = "saleOutText"
  }
}

function DataModel.Init(initParams)
  local params = Json.decode(initParams)
  DataModel.storeId = params.storeId
  DataModel.RefreshShopList()
end

function DataModel.RefreshShopList()
  DataModel.storeCA = PlayerData:GetFactoryData(DataModel.storeId)
  DataModel.storeList = {}
  DataModel.coinList = {}
  if #DataModel.storeCA.currencyShow > 1 then
    for i = 2, #DataModel.storeCA.currencyShow do
      table.insert(DataModel.coinList, DataModel.storeCA.currencyShow[i])
    end
  end
  local removeIdx = {}
  for k, v in pairs(DataModel.storeCA.shopList) do
    if v.id ~= "" then
      local row_c = {}
      local recharge = PlayerData.ServerData.shops[tostring(DataModel.storeId)]
      row_c.num = 0
      row_c.id = v.id
      local commoditData = PlayerData:GetFactoryData(v.id)
      row_c.endTime = commoditData.endTime
      local isMax_index = 1
      local index = k
      row_c.index = index
      row_c.isMax_index = isMax_index
      row_c.isMax = isMax_index == 2
      row_c.isRedState = 0 < RedpointTree:GetRedpointCnt(RedPointNodeStr.RedPointNodeStr.BarStoreShopCommodity .. "|" .. DataModel.storeId .. "|" .. row_c.id)
      row_c.itemId = commoditData.commodityItemList[1].id
      row_c.itemNum = commoditData.commodityNum
      local itemCA = PlayerData:GetFactoryData(row_c.itemId)
      row_c.storeType = commoditData.storeType
      row_c.shopId = DataModel.storeId
      row_c.name = itemCA.name
      row_c.qualityInt = itemCA.qualityInt
      row_c.iconPath = commoditData.commodityView
      row_c.currencyShow = Clone(commoditData.currencyShow)
      row_c.purchase = commoditData.purchase
      local StoreDataModel = require("UIStore/UIStoreDataModel")
      local maxNum = StoreDataModel:GetPurchaseNum(commoditData)
      row_c.purchaseNum = maxNum
      row_c.limitBuyType = commoditData.limitBuyType
      row_c.moneyList = commoditData.moneyList
      row_c.isChange = commoditData.isChange
      if recharge then
        row_c.server = recharge
        if DataModel.storeCA.storeType == "Random" then
          for k, v in pairs(recharge.items) do
            if k == row_c.idx and tonumber(v.id) == tonumber(row_c.id) then
              row_c.py_cnt = v.py_cnt
            end
          end
        else
          for k, v in pairs(recharge.items) do
            if tonumber(v.id) == tonumber(row_c.id) then
              row_c.py_cnt = v.py_cnt
              if v.last_auto_refresh and commoditData.isTriggerTime then
                row_c.endTime = v.last_auto_refresh + (commoditData.continueTime or 0)
                if TimeUtil:GetServerTimeStamp() >= row_c.endTime then
                  table.insert(removeIdx, k)
                end
              end
            end
          end
        end
      end
      row_c.residue = 100
      if commoditData.purchase and DataModel.PurchaseTypeList(commoditData.limitBuyType) ~= nil then
        row_c.residue = maxNum - (row_c.py_cnt or 0)
        if 0 > row_c.residue then
          row_c.residue = 0
        end
      end
      row_c.buyLimit = false
      row_c.limitRep = 0
      row_c.limitGrade = 0
      if commoditData.isBuyCondition then
        if 0 < commoditData.repGradeCondition then
          local stationId = DataModel.StationId
          if 0 < commoditData.stationCondition then
            stationId = commoditData.stationCondition
            local stationCA = PlayerData:GetFactoryData(stationId, "HomeStationFactory")
            if 0 < stationCA.attachedToCity then
              stationId = stationCA.attachedToCity
            end
          end
          local curRep = PlayerData:GetHomeInfo().stations[tostring(stationId)].rep_lv
          if curRep < commoditData.repGradeCondition then
            row_c.buyLimit = true
            row_c.limitRep = commoditData.repGradeCondition
          end
        end
        if 0 < commoditData.gradeCondition then
          local curLv = PlayerData:GetPlayerLevel()
          if curLv < commoditData.gradeCondition then
            row_c.buyLimit = true
            row_c.limitGrade = commoditData.gradeCondition
          end
        end
      end
      if commoditData.isTime == false or commoditData.isTime and TimeUtil:TimeIsActive(commoditData.startTime, commoditData.endTime) then
        table.insert(DataModel.storeList, row_c)
      end
    end
    local count = 0
    for k, v in pairs(removeIdx) do
      table.remove(DataModel.storeList, v - count)
      count = count + 1
    end
    table.sort(DataModel.storeList, function(a, b)
      if a.residue == 0 and b.residue > 0 then
        return false
      end
      if a.residue > 0 and b.residue == 0 then
        return true
      end
      if a.buyLimit and not b.buyLimit then
        return false
      end
      if not a.buyLimit and b.buyLimit then
        return true
      end
      return a.index < b.index
    end)
  end
end

function DataModel.PurchaseTypeList(type)
  local id
  if type == "Forever" then
    id = 80602487
  elseif type == "Daily" then
    id = 80602484
  elseif type == "Weekly" then
    id = 80602483
  elseif type == "Monthly" then
    id = 80602485
  end
  return id
end

return DataModel
