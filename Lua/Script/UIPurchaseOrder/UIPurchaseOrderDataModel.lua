local View = require("UIPurchaseOrder/UIPurchaseOrderView")
local DataModel = {}
DataModel.prisonLvInfo = {}
DataModel.orderList = {}
DataModel.timeElementList = {}

function DataModel.GenerateOrder(orderUid)
  local data = Clone(PrisonData.GetPurchaseOrder(orderUid))
  data.uid = orderUid
  data.status = PrisonData.GetPurchaseOrderStatus(orderUid)
  return data
end

function DataModel.InitData()
  local prisonCA = PrisonData.GetPrisonCA()
  local prisonLv = PrisonData.GetPrisonLv()
  DataModel.prisonLvInfo = prisonCA.lvList[prisonLv]
  DataModel.timeElementList = {}
  DataModel.InitOrderList()
end

function DataModel.InitOrderList()
  DataModel.orderList = {}
  for uid, v in pairs(PrisonData.GetPurchaseOrderList()) do
    local data = DataModel.GenerateOrder(uid)
    table.insert(DataModel.orderList, data)
  end
  table.sort(DataModel.orderList, function(a, b)
    local orderCA1 = PlayerData:GetFactoryData(a.prison_oid, "PrisonProcurementFactory")
    local orderCA2 = PlayerData:GetFactoryData(b.prison_oid, "PrisonProcurementFactory")
    if a.status == b.status then
      if a.status == PrisonData.OrderStatus.Completed then
        local completedTime1 = a.purchase_ts + orderCA1.costTime
        local completedTime2 = b.purchase_ts + orderCA2.costTime
        return completedTime1 < completedTime2
      elseif a.status == PrisonData.OrderStatus.Working then
        local remainTime1 = a.purchase_ts + orderCA1.costTime - TimeUtil.GetServerTimeStamp()
        local remainTime2 = b.purchase_ts + orderCA2.costTime - TimeUtil.GetServerTimeStamp()
        return remainTime1 < remainTime2
      else
        local quality1 = PrisonData.GetPurchaseOrderQuality(a.prison_oid)
        local quality2 = PrisonData.GetPurchaseOrderQuality(b.prison_oid)
        if quality1 == quality2 then
          return tonumber(a.prison_oid) > tonumber(b.prison_oid)
        else
          return quality1 > quality2
        end
      end
    else
      return a.status > b.status
    end
  end)
end

function DataModel.RefreshOnShow()
  local maxCapacity = PrisonData.GetRawMaterialWarehouseMaxCapacity()
  local curCapacity = PrisonData.GetRawMaterialWarehouseCapacity()
  View.Group_TopRight.Group_Warehouse.Group_Num.Txt_Own:SetText(curCapacity)
  View.Group_TopRight.Group_Warehouse.Group_Num.Txt_Max:SetText(maxCapacity)
  View.Group_TopRight.Group_Warehouse.Img_Bar.Img_Fill:SetFilledImgAmount(curCapacity / maxCapacity)
  local maxOrderNum = DataModel.prisonLvInfo.refreshNum
  View.Group_TopRight.Group_OrderNum.Txt_Num:SetText(string.format(GetText(80600213), maxOrderNum))
  View.NewScrollGrid_Order.grid.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
    View.NewScrollGrid_Order.grid.self:SetDataCount(table.count(DataModel.orderList) + 1)
    View.NewScrollGrid_Order.grid.self:RefreshAllElement()
    View.NewScrollGrid_Order.grid.self:MoveToTop()
  end))
  DataModel.RefreshOneButtonState()
end

function DataModel.RefreshOneButtonState()
  local canBuyCount = table.count(PrisonData.GetAllCanStartPurchaseOrder(false))
  local canCompleteCount = table.count(PrisonData.GetAllCanReceivePurchaseOrder(false))
  View.Group_Left.Btn_BuyOne:SetActive(1 <= canBuyCount and canCompleteCount == 0)
  View.Group_Left.Btn_CompleteOne:SetActive(1 <= canCompleteCount)
end

function DataModel.StartOrderRefresh()
  DataModel.InitOrderList()
  DataModel.timeElementList = {}
  View.NewScrollGrid_Order.grid.self:SetDataCount(table.count(DataModel.orderList) + 1)
  View.NewScrollGrid_Order.grid.self:RefreshAllElement()
end

function DataModel.ReceiveOrderRefresh()
  local maxCapacity = PrisonData.GetRawMaterialWarehouseMaxCapacity()
  local curCapacity = PrisonData.GetRawMaterialWarehouseCapacity()
  View.Group_TopRight.Group_Warehouse.Group_Num.Txt_Own:SetText(curCapacity)
  View.Group_TopRight.Group_Warehouse.Group_Num.Txt_Max:SetText(maxCapacity)
  View.Group_TopRight.Group_Warehouse.Img_Bar.Img_Fill:SetFilledImgAmount(curCapacity / maxCapacity)
  DataModel.InitOrderList()
  DataModel.timeElementList = {}
  View.NewScrollGrid_Order.grid.self:SetDataCount(table.count(DataModel.orderList) + 1)
  View.NewScrollGrid_Order.grid.self:RefreshAllElement()
end

function DataModel.AddSpeedOrderRefresh()
  DataModel.InitOrderList()
  DataModel.timeElementList = {}
  View.NewScrollGrid_Order.grid.self:SetDataCount(table.count(DataModel.orderList) + 1)
  View.NewScrollGrid_Order.grid.self:RefreshAllElement()
end

function DataModel.AddOrderRefresh()
  DataModel.InitOrderList()
  DataModel.timeElementList = {}
  View.NewScrollGrid_Order.grid.self:SetDataCount(table.count(DataModel.orderList) + 1)
  View.NewScrollGrid_Order.grid.self:RefreshAllElement()
end

function DataModel.GetTimeStr(second)
  local timeStr = "00:00:00"
  local time = tonumber(second)
  if time then
    local hours = math.floor(time / 3600)
    local minutes = math.floor(time % 3600 / 60)
    local secs = math.floor(time % 60)
    if hours < 10 then
      hours = "0" .. hours
    end
    if minutes < 10 then
      minutes = "0" .. minutes
    end
    if secs < 10 then
      secs = "0" .. secs
    end
    timeStr = hours .. ":" .. minutes .. ":" .. secs
  end
  return timeStr
end

return DataModel
