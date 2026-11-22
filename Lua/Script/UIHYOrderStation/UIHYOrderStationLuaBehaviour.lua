local View = require("UIHYOrderStation/UIHYOrderStationView")
local DataModel = require("UIHYOrderStation/UIHYOrderStationDataModel")
local ViewFunction = require("UIHYOrderStation/UIHYOrderStationViewFunction")
local OrderData = require("UIHYOrderStation/PrisonHyOrderData")
local WeekOrderData = require("UIHYOrderStation/PrisonHyWeekOrderData")
local Controller = require("UIHYOrderStation/UIHYOrderStationController")
local Luabehaviour = {
  serialize = function()
    return Json.encode({
      curMenuTab = DataModel.curMenuTab
    })
  end,
  deserialize = function(initParams)
    DataModel.InitData()
    OrderData.InitData()
    DataModel.SetJsonData(initParams)
    Controller.RefreshOnShow()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    for orderIndex, element in pairs(OrderData.orderTabTimeList) do
      local time = OrderData.GetRemainRefreshTime(orderIndex)
      if 0 < time then
        local timeTbl = TimeUtil:SecondToTableHMS(time)
        element.Group_Known.Img_NoOrder.Txt_Time:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
        element.Group_Known.Img_NoOrderPicked.Txt_Time:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
        if OrderData.orderIndex == orderIndex and View.Group_Quest.Img_BG.Group_NoOrder.IsActive then
          View.Group_Quest.Img_BG.Group_NoOrder.Txt_Time:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
        end
      else
        element.Group_Known.Img_NoOrderPicked:SetActive(false)
        element.Group_Known.Img_NoOrder:SetActive(false)
        element.Group_Known.Img_On:SetActive(OrderData.orderIndex == orderIndex)
        element.Group_Known.Img_Off:SetActive(OrderData.orderIndex ~= orderIndex)
        element.Group_Known.Img_RedDot:SetActive(OrderData.orderIndex ~= orderIndex)
        element.Group_Known.Img_RedDot:SetActive(true)
        local orderInfo = OrderData.orders[orderIndex]
        local orderId = orderInfo.data.oid
        local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
        local itemCfg = orderCA.requireItemList[1]
        if itemCfg then
          element.Group_Known.Img_Item:SetActive(true)
          local goodsCA = PlayerData:GetFactoryData(itemCfg.id, "HomeGoodsFactory")
          element.Group_Known.Img_Item:SetSprite(goodsCA.tipsPath)
        end
        if OrderData.orderIndex == orderIndex then
          Controller.RefreshOrderInfo()
        end
        OrderData.orderTabTimeList[orderIndex] = nil
      end
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
