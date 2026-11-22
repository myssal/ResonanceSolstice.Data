local View = require("UIPurchaseOrder/UIPurchaseOrderView")
local DataModel = require("UIPurchaseOrder/UIPurchaseOrderDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  PurchaseOrder_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
      local UIPrisonDataModel = require("UIPrison/UIPrisonDataModel")
      UIPrisonDataModel.RefreshLeftBtn()
      View.self:CloseUI()
    else
      View.self:CloseUI()
    end
  end,
  PurchaseOrder_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PurchaseOrder_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PurchaseOrder_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304354}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  PurchaseOrder_NewScrollGrid_Order_SetGrid = function(element, elementIndex)
    local info = DataModel.orderList[elementIndex]
    element.Group_Show:SetActive(info)
    element.Group_Empty:SetActive(not info)
    if not info then
      return
    end
    local orderId = info.prison_oid
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local orderStatus = info.status
    local time = 0
    if orderStatus == PrisonData.OrderStatus.NoStart then
      time = orderCA.costTime
    elseif orderStatus == PrisonData.OrderStatus.Working then
      time = info.purchase_ts + orderCA.costTime - TimeUtil.GetServerTimeStamp()
      if 0 < time then
        DataModel.timeElementList[element] = {orderInfo = info, remainTime = time}
      end
    end
    element.Group_Show.Group_Title.Txt_Cname:SetText(string.format(GetText(80607880), orderCA.name))
    local timeStr = DataModel.GetTimeStr(time)
    element.Group_Show.Group_Time.Group_Defult:SetActive(orderStatus == PrisonData.OrderStatus.NoStart)
    element.Group_Show.Group_Time.Group_Defult.Txt_Num:SetText(orderCA.targetNum)
    element.Group_Show.Group_Time.Group_Defult.Txt_Time:SetText(timeStr)
    element.Group_Show.Group_Time.Group_Waiting:SetActive(orderStatus == PrisonData.OrderStatus.Working)
    element.Group_Show.Group_Time.Group_Waiting.Txt_Num:SetText(orderCA.targetNum)
    element.Group_Show.Group_Time.Group_Waiting.Txt_Time:SetText(timeStr)
    element.Group_Show.Group_Time.Group_Finish:SetActive(orderStatus == PrisonData.OrderStatus.Completed)
    element.Group_Show.Group_Time.Group_Finish.Txt_Num:SetText(orderCA.targetNum)
    element.Group_Show.Group_Time.Group_Finish.Txt_Time:SetText(timeStr)
    element.Group_Show.Group_Defult:SetActive(orderStatus == PrisonData.OrderStatus.NoStart)
    element.Group_Show.Group_Defult.Btn_Buy:SetClickParam(elementIndex)
    element.Group_Show.Group_Waiting:SetActive(orderStatus == PrisonData.OrderStatus.Working)
    element.Group_Show.Group_Waiting.Btn_AddSpeed:SetClickParam(elementIndex)
    element.Group_Show.Group_Finished:SetActive(orderStatus == PrisonData.OrderStatus.Completed)
    element.Group_Show.Group_Finished.Btn_Get:SetClickParam(elementIndex)
    local goodsCA = PlayerData:GetFactoryData(orderCA.target, "HomeGoodsFactory")
    element.Group_Show.Group_Reward.Btn_Item:SetClickParam(orderCA.target)
    element.Group_Show.Group_Reward.Btn_Item.Img_Item:SetSprite(goodsCA.tipsPath)
    element.Group_Show.Group_Rare.StaticGrid_Rare.grid.self:SetDataCount(orderCA.rarity)
    element.Group_Show.Group_Rare.StaticGrid_Rare.grid.self:RefreshAllElement()
    element.Group_Show.Group_Cost:SetActive(orderStatus == PrisonData.OrderStatus.NoStart)
    element.Group_Show.Group_Cost.StaticGrid_CostList.grid.self:SetParentParam(elementIndex)
    element.Group_Show.Group_Cost.StaticGrid_CostList.grid.self:SetDataCount(3)
    element.Group_Show.Group_Cost.StaticGrid_CostList.grid.self:RefreshAllElement()
  end,
  PurchaseOrder_NewScrollGrid_Order_Group_Item_Group_Show_Group_Cost_StaticGrid_CostList_SetGrid = function(element, elementIndex)
    local info = DataModel.orderList[tonumber(element.ParentParam)]
    local orderId = info.prison_oid
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    local costInfo = orderCA.costList[elementIndex]
    if costInfo then
      CommonItem:SetItem(element.Group_Show.Group_Item, costInfo)
      element.Group_Show.Group_Item.Txt_Num:SetActive(false)
      element.Group_Show.Group_Item.Btn_Item:SetClickParam(costInfo.id)
      element.Group_Show.Group_Num.Txt_Need:SetText(costInfo.num)
      local ownNum = PrisonData.GetGoodsById(costInfo.id)
      element.Group_Show.Group_Num.Txt_Own:SetText(ownNum)
      local needColor = ownNum < costInfo.num and "#B65C55" or "#393939"
      element.Group_Show.Group_Num.Txt_Need:SetColor(needColor)
      element.Group_Show.Group_Num.Txt_0:SetActive(info.status == PrisonData.OrderStatus.NoStart)
      element.Group_Show.Group_Num.Txt_Own:SetActive(info.status == PrisonData.OrderStatus.NoStart)
    end
    element.Group_Show:SetActive(costInfo)
    element.Group_Empty:SetActive(not costInfo)
  end,
  PurchaseOrder_NewScrollGrid_Order_Group_Item_Group_Show_Group_Cost_StaticGrid_CostList_Group_Cost_Group_Show_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PurchaseOrder_NewScrollGrid_Order_Group_Item_Group_Show_Group_Reward_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PurchaseOrder_NewScrollGrid_Order_Group_Item_Group_Show_Group_Defult_Btn_Buy_Click = function(btn, str)
    local info = DataModel.orderList[tonumber(str)]
    
    local function callBack(json)
      DataModel.StartOrderRefresh()
      DataModel.RefreshOneButtonState()
    end
    
    PrisonData.StartPurchaseOrder({
      info.uid
    }, callBack)
  end,
  PurchaseOrder_NewScrollGrid_Order_Group_Item_Group_Show_Group_Waiting_Btn_AddSpeed_Click = function(btn, str)
    local info = DataModel.orderList[tonumber(str)]
    
    local function yesFun()
      local function callBack()
        DataModel.AddSpeedOrderRefresh()
        
        DataModel.RefreshOneButtonState()
      end
      
      PrisonData.PurchaseOrderAddSpeed(info.uid, callBack)
    end
    
    UIManager:Open("UI/Prison/PurchaseOrder/SkipTips", Json.encode({
      orderUid = info.uid
    }), yesFun)
  end,
  PurchaseOrder_NewScrollGrid_Order_Group_Item_Group_Show_Group_Finished_Btn_Get_Click = function(btn, str)
    local info = DataModel.orderList[tonumber(str)]
    local orderId = info.prison_oid
    local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
    
    local function callBack(json)
      local reward = {}
      table.insert(reward, {
        [tostring(orderCA.target)] = {
          num = orderCA.targetNum
        }
      })
      if #orderCA.expGet > 0 then
        table.insert(reward, {})
        local t = reward[#reward]
        for i, v in ipairs(orderCA.expGet) do
          t[tostring(v.id)] = {
            num = v.num
          }
        end
      end
      CommonTips.OpenShowItem(reward)
      DataModel.ReceiveOrderRefresh()
      DataModel.RefreshOneButtonState()
    end
    
    PrisonData.ReceivePurchaseOrder({
      info.uid
    }, callBack)
  end,
  PurchaseOrder_NewScrollGrid_Order_Group_Item_Group_Show_Group_Rare_StaticGrid_Rare_SetGrid = function(element, elementIndex)
  end,
  PurchaseOrder_NewScrollGrid_Order_Group_Item_Group_Empty_Btn_Add_Click = function(btn, str)
    local prisonCA = PrisonData.GetPrisonCA()
    local itemInfo = prisonCA.addProcurementList[1]
    if itemInfo then
      local function yesFun()
        local function callBack()
          DataModel.AddOrderRefresh()
          
          DataModel.RefreshOneButtonState()
        end
        
        PrisonData.AddPurchaseOrder(callBack)
      end
      
      local params = {}
      params.itemId = itemInfo.id
      params.useNum = itemInfo.costNum
      local itemCA = PlayerData:GetFactoryData(itemInfo.id)
      CommonTips.OnItemPromptBatch(string.format(GetText(80600495), itemCA.name), params, yesFun)
    end
  end,
  PurchaseOrder_Group_Left_Btn_BuyOne_Click = function(btn, str)
    local canStartList = PrisonData.GetAllCanStartPurchaseOrder(true)
    
    local function callBack(json)
      DataModel.StartOrderRefresh()
      DataModel.RefreshOneButtonState()
    end
    
    PrisonData.StartPurchaseOrder(canStartList, callBack)
  end,
  PurchaseOrder_Group_Left_Btn_CompleteOne_Click = function(btn, str)
    local canCompleteList = PrisonData.GetAllCanReceivePurchaseOrder(true)
    
    local function callBack(json, canGetOrderIdList)
      if canGetOrderIdList == nil or table.count(canGetOrderIdList) == 0 then
        DataModel.ReceiveOrderRefresh()
        return
      end
      local reward = {}
      for k, orderId in ipairs(canGetOrderIdList) do
        local orderCA = PlayerData:GetFactoryData(orderId)
        table.insert(reward, {
          [tostring(orderCA.target)] = {
            num = orderCA.targetNum
          }
        })
        if 0 < #orderCA.expGet then
          table.insert(reward, {})
          local t = reward[#reward]
          for i, v in ipairs(orderCA.expGet) do
            t[tostring(v.id)] = {
              num = v.num
            }
          end
        end
      end
      CommonTips.OpenShowItem(reward)
      DataModel.ReceiveOrderRefresh()
      DataModel.RefreshOneButtonState()
    end
    
    PrisonData.ReceivePurchaseOrder(canCompleteList, callBack)
  end
}
return ViewFunction
