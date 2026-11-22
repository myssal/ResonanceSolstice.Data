local View = require("UIHYOrderRecord/UIHYOrderRecordView")
local DataModel = require("UIHYOrderRecord/UIHYOrderRecordDataModel")
local ViewFunction = {
  HYOrderRecord_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end,
  HYOrderRecord_ScrollGrid__SetGrid = function(element, elementIndex)
    local orderInfo = DataModel.recordOrders[elementIndex]
    local orderType = orderInfo.orderType
    local orderId = orderInfo.orderId
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local canDeliver = DataModel.IsOrderCanDeliver(orderId, orderType)
    element.Txt_Title:SetText(orderCA.name)
    element.Img_BG:SetActive(not canDeliver)
    element.Img_BG.Img_week:SetActive(orderType == DataModel.OrderType.Week)
    element.Img_BGDeliver:SetActive(canDeliver)
    element.Img_BGDeliver.Img_week:SetActive(orderType == DataModel.OrderType.Week)
    element.ScrollGrid_Rewards.grid.self:SetParentParam(elementIndex)
    if orderType == DataModel.OrderType.Normal then
      element.ScrollGrid_Rewards.grid.self:SetDataCount(table.count(orderCA.rewardsList))
    elseif orderType == DataModel.OrderType.Week then
      element.ScrollGrid_Rewards.grid.self:SetDataCount(table.count(orderCA.weekPerRewardsList))
    end
    element.ScrollGrid_Rewards.grid.self:RefreshAllElement()
    element.StaticGrid_.grid.self:SetParentParam(elementIndex)
    element.StaticGrid_.grid.self:SetDataCount(3)
    element.StaticGrid_.grid.self:RefreshAllElement()
  end,
  HYOrderRecord_ScrollGrid__Group_Item_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    local orderInfo = DataModel.recordOrders[tonumber(element.ParentParam)]
    local orderId = orderInfo.orderId
    local orderType = orderInfo.orderType
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local info
    if orderType == DataModel.OrderType.Normal then
      info = orderCA.rewardsList[elementIndex]
    elseif orderType == DataModel.OrderType.Week then
      info = orderCA.weekPerRewardsList[elementIndex]
    end
    local itemCA = PlayerData:GetFactoryData(info.id, "HomeGoodsFactory")
    element.Img_:SetSprite(itemCA.tipsPath)
    element.Img_Num.Txt_:SetText(info.num)
    element.Btn_:SetClickParam(info.id)
  end,
  HYOrderRecord_ScrollGrid__Group_Item_StaticGrid__SetGrid = function(element, elementIndex)
    local orderInfo = DataModel.recordOrders[tonumber(element.ParentParam)]
    local orderId = orderInfo.orderId
    local orderType = orderInfo.orderType
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local info
    if orderType == DataModel.OrderType.Normal then
      info = orderCA.requireItemList[elementIndex]
      if info then
        local itemCA = PlayerData:GetFactoryData(info.id, "HomeGoodsFactory")
        element.Img_:SetSprite(itemCA.tipsPath)
        element.Img_Num.Txt_:SetText(info.num)
        element.Btn_:SetClickParam(info.id)
      end
    elseif orderType == DataModel.OrderType.Week then
      info = orderCA.weekRequireItemList[elementIndex]
      if info then
        local itemCA = PlayerData:GetFactoryData(info.id, "HomeGoodsFactory")
        element.Img_:SetSprite(itemCA.tipsPath)
        element.Img_Num.Txt_:SetText(info.perNum)
        element.Btn_:SetClickParam(info.id)
      end
    end
    element.Btn_:SetActive(info)
    element.Img_BGEmpty:SetActive(not info)
    element.Img_BG:SetActive(info)
    element.Img_:SetActive(info)
    element.Img_Num:SetActive(info)
  end,
  HYOrderRecord_ScrollGrid__Group_Item_ScrollGrid_Rewards_Group_Item_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderRecord_ScrollGrid__Group_Item_StaticGrid__Group_Requirement_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end
}
return ViewFunction
