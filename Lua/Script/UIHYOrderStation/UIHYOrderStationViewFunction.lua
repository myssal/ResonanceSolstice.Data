local View = require("UIHYOrderStation/UIHYOrderStationView")
local DataModel = require("UIHYOrderStation/UIHYOrderStationDataModel")
local OrderData = require("UIHYOrderStation/PrisonHyOrderData")
local WeekOrderData = require("UIHYOrderStation/PrisonHyWeekOrderData")
local Controller = require("UIHYOrderStation/UIHYOrderStationController")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  HYOrderStation_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.curMenuTab ~= DataModel.MenuTab.None then
      Controller.RefreshMainPanel()
      View.self:PlayAnim("Back")
      DataModel.curMenuTab = DataModel.MenuTab.None
      OrderData.orderTabTimeList = {}
    elseif UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
      local UIPrisonDataModel = require("UIPrison/UIPrisonDataModel")
      UIPrisonDataModel.RefreshLeftBtn()
      View.self:CloseUI()
    else
      UIManager:GoBack()
    end
  end,
  HYOrderStation_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  HYOrderStation_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  HYOrderStation_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304348}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  HYOrderStation_Group_Main_Btn_Talk_Click = function(btn, str)
    Controller.NpcTalk()
  end,
  HYOrderStation_Group_Reputation_Btn_Reputation_Click = function(btn, str)
    local HomeCommon = require("Common/HomeCommon")
    HomeCommon.ClickReputationBtn(DataModel.StationId, nil, nil, function()
      HomeCommon.SetReputationElement(View.Group_Reputation, DataModel.StationId)
    end)
  end,
  HYOrderStation_Group_Main_Btn_Order_Click = function(btn, str)
    Controller.ClickOrderMenu()
  end,
  HYOrderStation_Group_Quest_ScrollGrid_Tab_SetGrid = function(element, elementIndex)
    local orderInfo = OrderData.orders[elementIndex]
    element.Img_Unknown:SetActive(not orderInfo)
    element.Group_Known:SetActive(orderInfo)
    if orderInfo then
      local orderId = orderInfo.data.oid
      local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
      local itemCfg = orderCA.requireItemList[1]
      local select = elementIndex == OrderData.orderIndex
      local remainTime = OrderData.GetRemainRefreshTime(elementIndex)
      local inRefresh = 0 < remainTime
      element.Group_Known.Img_On:SetActive(select and not inRefresh)
      element.Group_Known.Img_Off:SetActive(not select and not inRefresh)
      element.Group_Known.Img_NoOrderPicked:SetActive(select and inRefresh)
      element.Group_Known.Img_NoOrder:SetActive(not select and inRefresh)
      element.Group_Known.Img_Item:SetActive(not inRefresh)
      element.Group_Known.Btn_:SetClickParam(elementIndex)
      if inRefresh then
        local timeTbl = TimeUtil:SecondToTableHMS(remainTime)
        element.Group_Known.Img_NoOrder.Txt_Time:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
        element.Group_Known.Img_NoOrderPicked.Txt_Time:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
        OrderData.orderTabTimeList[elementIndex] = element
      elseif itemCfg then
        local goodsCA = PlayerData:GetFactoryData(itemCfg.id, "HomeGoodsFactory")
        element.Group_Known.Img_Item:SetSprite(goodsCA.tipsPath)
      end
      element.Group_Known.Txt_Name:SetText(orderCA.name)
      local recorded = OrderData.recordOrders[orderInfo.serverIndex]
      local canDeliver = OrderData.IsOrderCanDeliver(elementIndex)
      element.Group_Known.Img_TabNoted:SetActive(recorded and not canDeliver)
      element.Group_Known.Img_TabOk:SetActive(canDeliver)
      element.Group_Known.Img_RedDot:SetActive(OrderData.GetOrderRedPoint(elementIndex))
    else
      local prisonCA = PrisonData.GetPrisonCA()
      local lvCfg = prisonCA.lvList[PrisonData.GetPrisonLv()]
      local refreshNum = lvCfg and lvCfg.refreshNum
      local unLockLv
      for i = PrisonData.GetPrisonLv() + 1, #prisonCA.lvList do
        local cfg = prisonCA.lvList[i]
        if elementIndex <= cfg.refreshNum then
          unLockLv = cfg.level
          break
        end
      end
      element.Img_Unknown.Img_Level:SetActive(elementIndex > refreshNum and unLockLv)
      if unLockLv then
        element.Img_Unknown.Img_Level.Txt_:SetText(string.format(GetText(80608883), unLockLv))
      end
    end
  end,
  HYOrderStation_Group_Quest_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  HYOrderStation_Group_Quest_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_Order_StaticGrid_Requirements_SetGrid = function(element, elementIndex)
    local orderId = element.ParentParam
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local requireInfo = orderCA.requireItemList[elementIndex]
    local itemCA = PlayerData:GetFactoryData(requireInfo.id)
    element.Img_:SetSprite(itemCA.tipsPath)
    element.Txt_Name:SetText(itemCA.name)
    element.Txt_Num:SetText(requireInfo.num)
    element.Btn_:SetClickParam(requireInfo.id)
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_Order_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    local orderId = element.ParentParam
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local rewardInfo = orderCA.rewardsList[elementIndex]
    local itemCA = PlayerData:GetFactoryData(rewardInfo.id)
    element.Img_:SetSprite(itemCA.tipsPath)
    element.Img_Num.Txt_:SetText(rewardInfo.num)
    element.Btn_:SetClickParam(rewardInfo.id)
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_Order_Btn_Delete_Click = function(btn, str)
    Controller.DeleteOrderClick()
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_Order_Btn_Note_Click = function(btn, str)
    Controller.RecordOrderClick()
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_Order_Btn_Deliver_Click = function(btn, str)
    Controller.DeliverOrderClick()
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_Order_Btn_CannotDeliver_Click = function(btn, str)
  end,
  HYOrderStation_Group_Quest_ScrollGrid_Tab_Group_Item_Group_Known_Btn__Click = function(btn, str)
    Controller.ClickOrderTab(tonumber(str))
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_Order_StaticGrid_Requirements_Group_Require_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_Order_ScrollGrid_Rewards_Group_Item_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderStation_Group_Quest_Btn_Order_Click = function(btn, str)
    Controller.ShowRecordPanel()
  end,
  HYOrderStation_Group_Main_Btn_Exchange_Click = function(btn, str)
    local buildCA = PlayerData:GetFactoryData(84400137, "PrisonFactory")
    local shopList = {}
    for i, v in ipairs(buildCA.exchangeStoreList) do
      table.insert(shopList, v.id)
    end
    local shopIds = table.concat(shopList, ",")
    Net:SendProto("shop.info", function(json)
      PlayerData:RefreshShops(json.shops)
      Controller.RefreshExchange()
      View.self:PlayAnim("Exchange")
    end, shopIds)
  end,
  HYOrderStation_Group_Exchange_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  HYOrderStation_Group_Exchange_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  HYOrderStation_Group_Exchange_Group_Middle_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local itemInfo = DataModel.currentShop.shopItems[elementIndex]
    local commodityId = itemInfo.commodityId
    local commodityCA = PlayerData:GetFactoryData(commodityId, "CommodityFactory")
    local lockLv = commodityCA.prisonGradeCondition and commodityCA.prisonGradeCondition
    local showLock = lockLv and lockLv > PrisonData.GetPrisonLv()
    element.Group_Name.Txt_Name:SetText(commodityCA.commodityName)
    element.Img_Icon:SetSprite(commodityCA.commodityView)
    element.Img_Icon.Btn_:SetClickParam(commodityCA.commodityItemList[1].id)
    element.ScrollGrid_List.grid.self:SetParentParam(commodityId)
    local dataCount = #commodityCA.moneyList
    element.ScrollGrid_List.grid.self.ScrollRect.enabled = 3 < dataCount
    if dataCount < 3 then
      dataCount = 3
    end
    element.ScrollGrid_List.grid.self:SetDataCount(dataCount)
    element.ScrollGrid_List.grid.self:RefreshAllElement()
    local remainNum = DataModel.GetRemainBuyNum(commodityId)
    if remainNum < 0 then
      remainNum = 0
    end
    element.Group_Num.Txt_Num:SetText(string.format(GetText(80607402), remainNum))
    element.Group_Btn.Group_Can:SetActive(0 < remainNum and not showLock)
    element.Group_Btn.Group_Can.Btn_:SetClickParam(elementIndex)
    element.Group_Btn.Group_Not:SetActive(remainNum == 0 or showLock)
    local extraGiveList = commodityCA.extraGiveList
    local groupExtra = element.Group_Extra
    groupExtra:SetActive(0 < #extraGiveList)
    if 0 < #extraGiveList then
      groupExtra.Txt_Num:SetText(string.format(GetText(80601880), extraGiveList[1].num))
      groupExtra.Img_Icon:SetSprite(PlayerData:GetFactoryData(extraGiveList[1].id).iconPath)
      groupExtra.Img_Icon.Btn_:SetClickParam(extraGiveList[1].id)
    end
    element.Group_Allready:SetActive(remainNum == 0)
  end,
  HYOrderStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Img_Icon_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local commodityId = tonumber(element.ParentParam)
    local commodityCA = PlayerData:GetFactoryData(commodityId, "CommodityFactory")
    local costInfo = commodityCA.moneyList[elementIndex]
    element.Img_Empty:SetActive(not costInfo)
    element.Group_Item:SetActive(costInfo)
    element.Group_Cost:SetActive(costInfo)
    if costInfo then
      CommonItem:SetItem(element.Group_Item, {
        id = costInfo.moneyID
      })
      local itemId = costInfo.moneyID
      element.Group_Item.Btn_Item:SetClickParam(itemId)
      local needNum = costInfo.moneyNum
      element.Group_Cost.Txt_Need.Txt.text = PlayerData:NumToFormatString(needNum, 1)
      local haveNum = PlayerData:GetGoodsById(itemId).num
      element.Group_Cost.Txt_Have.Txt.text = PlayerData:NumToFormatString(haveNum, 1)
      if needNum > haveNum then
        element.Group_Cost.Txt_Have:SetColor(UIConfig.Color.Red)
        DataModel.notEnoughMap[commodityId] = true
      else
        element.Group_Cost.Txt_Have:SetColor(UIConfig.Color.White)
      end
    end
  end,
  HYOrderStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_ScrollGrid_List_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Btn_Group_Can_Btn__Click = function(btn, str)
    local itemInfo = DataModel.currentShop.shopItems[tonumber(str)]
    local commodityId = itemInfo.commodityId
    if DataModel.notEnoughMap[commodityId] then
      CommonTips.OpenTips(80601871)
      return
    end
    local shopId = DataModel.currentShop.shopId
    local remainBuyNum = DataModel.GetRemainBuyNum(commodityId)
    UIManager:Open("UI/Common/ExchangeTips", Json.encode({
      commodityId = commodityId,
      remainNum = remainBuyNum,
      shopId = shopId,
      index = tonumber(str)
    }), function()
      Controller.RefreshExchange()
    end)
  end,
  HYOrderStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Btn_Group_Not_Btn__Click = function(btn, str)
  end,
  HYOrderStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Extra_Img_Icon_Btn__Click = function(btn, str)
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_NoOrder_Group_Pick_Btn_Diamond_Click = function(btn, str)
    Controller.DiamondClick()
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_NoOrder_Group_Pick_Btn_Item_Click = function(btn, str)
    Controller.OtherItemClick()
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_NoOrder_Group_Pick_Btn_Confirm_Click = function(btn, str)
    Controller.GetOrderImmediately()
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_Order_ScrollGrid_Materials_SetGrid = function(element, elementIndex)
    local orderInfo = OrderData.orders[OrderData.orderIndex]
    local orderId = orderInfo.data.oid
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local formulaCA = PlayerData:GetFactoryData(orderCA.requireProduction, "ProductionFactory")
    local costCfg = formulaCA.costList[elementIndex]
    local itemId = costCfg.id
    local itemCA = PlayerData:GetFactoryData(itemId, "HomeGoodsFactory")
    element.Img_:SetSprite(itemCA.imagePath)
    element.Btn_:SetClickParam(itemId)
    element.Img_Num.Txt_:SetText(PrisonData.GetGoodsById(itemId))
  end,
  HYOrderStation_Group_Quest_Img_BG_Group_Order_ScrollGrid_Materials_Group_Item_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderStation_Group_Quest_Btn_Warehouse_Click = function(btn, str)
    if not PrisonData.GetSeverPrisonData() then
      CommonTips.OpenTips(80608796)
      return
    end
    UIManager:Open("UI/Prison/PrisonWarehouse/PrisonWarehouse", Json.encode({openStationTab = 2}))
  end,
  HYOrderStation_Group_Quest_Btn_Produce_Click = function(btn, str)
    local fursData = PlayerData:GetFurniture()
    for ufid, v in pairs(fursData) do
      local furCA = PlayerData:GetFactoryData(v.id, "HomeFurnitureFactory")
      local manufactureType = furCA.manufactureType
      if manufactureType == 12601174 then
        UIManager:Open("UI/Home_MachiningLathe/SewingMachine/Home_SewingMachine", Json.encode({
          ufid = ufid,
          furId = v.id
        }))
        return
      end
    end
    CommonTips.OpenTips(80608796)
  end,
  HYOrderStation_Group_Main_Btn_WeekOrder_Click = function(btn, str)
    Controller.ClickWeekOrderMenu()
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Group_Material_ScrollGrid_Materials_SetGrid = function(element, elementIndex)
    local orderIndex = WeekOrderData.orderIndex
    local orderId = WeekOrderData.orders[tonumber(orderIndex)]
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local productCA = PlayerData:GetFactoryData(orderCA.weekRequireProduction, "ProductionFactory")
    local data = productCA.costList[elementIndex]
    local goodsCA = PlayerData:GetFactoryData(data.id, "HomeGoodsFactory")
    element.Img_:SetSprite(goodsCA.imagePath)
    element.Btn_:SetClickParam(data.id)
    element.Img_Num.Txt_:SetText(PrisonData.GetGoodsById(data.id))
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Group_Material_ScrollGrid_Materials_Group_Item_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Group_CompleteRewards_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    local orderIndex = WeekOrderData.orderIndex
    local orderId = WeekOrderData.orders[tonumber(orderIndex)]
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local data = orderCA.weekTotalRewardsList[elementIndex]
    local itemCA = PlayerData:GetFactoryData(data.id, "ItemFactory")
    element.Btn_:SetClickParam(data.id)
    element.Img_:SetSprite(itemCA.iconPath)
    element.Img_Num.Txt_:SetText(data.num)
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Group_CompleteRewards_ScrollGrid_Rewards_Group_Item_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Group_PerRewards_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    local orderIndex = WeekOrderData.orderIndex
    local orderId = WeekOrderData.orders[tonumber(orderIndex)]
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local data = orderCA.weekPerRewardsList[elementIndex]
    local itemCA = PlayerData:GetFactoryData(data.id, "ItemFactory")
    element.Btn_:SetClickParam(data.id)
    element.Img_:SetSprite(itemCA.iconPath)
    element.Img_Num.Txt_:SetText(data.num)
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Group_PerRewards_ScrollGrid_Rewards_Group_Item_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Btn_Note_Click = function(btn, str)
    Controller.ClickRecordWeekOrder()
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Btn_Deliver_Click = function(btn, str)
    Controller.ClickWeekOrderDeliver()
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Btn_CannotDeliver_Click = function(btn, str)
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Group_TotalRewards_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    local prisonCA = PrisonData.GetPrisonCA()
    local data = prisonCA.weekOrderRewardsList[elementIndex]
    local itemCA = PlayerData:GetFactoryData(data.id, "ItemFactory")
    element.Img_:SetSprite(itemCA.iconPath)
    element.Btn_:SetClickParam(data.id)
    element.Img_Num.Txt_:SetText(data.num)
    element.Txt_:SetText(itemCA.name)
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Group_TotalRewards_ScrollGrid_Rewards_Group_Item_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Btn_Get_Click = function(btn, str)
    Controller.ClickWeekOrderTotalReward()
  end,
  HYOrderStation_Group_WeekOrder_ScrollGrid_Tab_SetGrid = function(element, elementIndex)
    local orderId = WeekOrderData.orders[elementIndex]
    local orderIndex = WeekOrderData.orderIndex
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    element.Img_On:SetActive(elementIndex == orderIndex)
    element.Img_Off:SetActive(elementIndex ~= orderIndex)
    local lock = WeekOrderData.IsOrderLock(orderId)
    element.Btn_Lock:SetActive(lock)
    element.Btn_:SetActive(not lock)
    local canDeliver = WeekOrderData.IsOrderCanDeliver(orderId)
    element.Img_TabOk:SetActive(canDeliver)
    local completed = WeekOrderData.IsOrderCompleted(orderId)
    element.Img_complete:SetActive(completed)
    local recorded = WeekOrderData.IsOrderRecorded(orderId)
    element.Img_TabNoted:SetActive(recorded)
    element.Img_RedDot:SetActive(WeekOrderData.GetOrderRedPoint(elementIndex))
    element.Txt_Name:SetText(orderCA.name)
    element.Btn_:SetClickParam(elementIndex)
    local itemCfg = orderCA.weekRequireItemList[1]
    if itemCfg then
      local goodsCA = PlayerData:GetFactoryData(itemCfg.id, "HomeGoodsFactory")
      element.Img_Item:SetSprite(goodsCA.tipsPath)
    end
    element.StaticGrid_Star.grid.self:SetDataCount(orderCA.rarity)
    element.StaticGrid_Star.grid.self:RefreshAllElement()
  end,
  HYOrderStation_Group_WeekOrder_ScrollGrid_Tab_Group_Item_Btn__Click = function(btn, str)
    Controller.ClickWeekOrderTab(tonumber(str))
  end,
  HYOrderStation_Group_WeekOrder_ScrollGrid_Tab_Group_Item_StaticGrid_Star_SetGrid = function(element, elementIndex)
  end,
  HYOrderStation_Group_WeekOrder_ScrollGrid_Tab_Group_Item_Btn_Lock_Click = function(btn, str)
    CommonTips.OpenTips(80609084)
  end,
  HYOrderStation_Group_WeekOrder_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  HYOrderStation_Group_WeekOrder_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  HYOrderStation_Group_WeekOrder_Btn_Order_Click = function(btn, str)
    Controller.ShowRecordPanel()
  end,
  HYOrderStation_Group_WeekOrder_Btn_Warehouse_Click = function(btn, str)
    if not PrisonData.GetSeverPrisonData() then
      CommonTips.OpenTips(80608796)
      return
    end
    UIManager:Open("UI/Prison/PrisonWarehouse/PrisonWarehouse", Json.encode({openStationTab = 2}))
  end,
  HYOrderStation_Group_WeekOrder_Btn_Produce_Click = function(btn, str)
    local fursData = PlayerData:GetFurniture()
    for ufid, v in pairs(fursData) do
      local furCA = PlayerData:GetFactoryData(v.id, "HomeFurnitureFactory")
      local manufactureType = furCA.manufactureType
      if manufactureType == 12601174 then
        UIManager:Open("UI/Home_MachiningLathe/SewingMachine/Home_SewingMachine", Json.encode({
          ufid = ufid,
          furId = v.id
        }))
        return
      end
    end
    CommonTips.OpenTips(80608796)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Btn_BG_Click = function(btn, str)
    View.Group_WeekOrder.Group_BuyTips:SetActive(false)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Btn_Min_Click = function(btn, str)
    View.Group_WeekOrder.Group_BuyTips.Group_Slider.Slider_Value:SetSliderValue(1)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Btn_Dec_Click = function(btn, str)
    local deliverNum = WeekOrderData.deliverNum - WeekOrderData.perNum
    if deliverNum == 0 then
      return
    end
    View.Group_WeekOrder.Group_BuyTips.Group_Slider.Slider_Value:SetSliderValue(deliverNum / WeekOrderData.perNum)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Group_Slider_Slider_Value_Slider = function(slider, value)
    WeekOrderData.deliverNum = math.floor(tonumber(value)) * WeekOrderData.perNum
    View.Group_WeekOrder.Group_BuyTips.Group_Slider.Group_Num.Txt_Select:SetText(WeekOrderData.deliverNum)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Btn_Add_Click = function(btn, str)
    local deliverNum = WeekOrderData.deliverNum + WeekOrderData.perNum
    if deliverNum > WeekOrderData.maxDeliverNum then
      return
    end
    View.Group_WeekOrder.Group_BuyTips.Group_Slider.Slider_Value:SetSliderValue(deliverNum / WeekOrderData.perNum)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Btn_Max_Click = function(btn, str)
    View.Group_WeekOrder.Group_BuyTips.Group_Slider.Slider_Value:SetSliderValue(WeekOrderData.maxDeliverNum / WeekOrderData.perNum)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Btn_Cancel_Click = function(btn, str)
    View.Group_WeekOrder.Group_BuyTips:SetActive(false)
  end,
  HYOrderStation_Group_WeekOrder_Group_BuyTips_Btn_Sale_Click = function(btn, str)
    Controller.ClickDeliverConfirm()
  end,
  HYOrderStation_Group_WeekOrder_Img_BG_Group_WeekOrder_Group_Unaccept_Btn_Start_Click = function(btn, str)
    Controller.ClickWeekOrderSelect()
  end,
  HYOrderStation_Group_Main_Btn_Manufacture_Click = function(btn, str)
  end
}
return ViewFunction
