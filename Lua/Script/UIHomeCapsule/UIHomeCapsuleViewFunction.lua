local View = require("UIHomeCapsule/UIHomeCapsuleView")
local DataModel = require("UIHomeCapsule/UIHomeCapsuleDataModel")
local Controller = require("UIHomeCapsule/UIHomeCapsuleController")
local HomeStoreDataModel = require("UIHomeCapsule/UIHomeStoreDataModel")
local HomeStoreController = require("UIHomeCapsule/UIHomeStoreController")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  HomeCapsule_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  HomeCapsule_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  HomeCapsule_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  HomeCapsule_Group_JYB_Btn_Buy_Click = function(btn, str)
  end,
  HomeCapsule_Group_ND_Group_Pay_Group_One_Btn_1_Click = function(btn, str)
    Controller:OnePick()
  end,
  HomeCapsule_Group_ND_Group_Pay_Group_One1_Btn_1_Click = function(btn, str)
    Controller:OnePick()
  end,
  HomeCapsule_Group_ND_Group_Pay_Group_Ten_Btn_1_Click = function(btn, str)
    Controller:TenPick()
  end,
  HomeCapsule_Group_ND_Group_BQ_Group_1_Group_CZ_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    Controller:SelectPond(idx)
  end,
  HomeCapsule_Group_ND_Group_BQ_Group_1_Group_XS_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    Controller:SelectPond(idx)
  end,
  HomeCapsule_Group_ND_Group_BQ_Group_2_Group_CZ_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    Controller:SelectPond(idx)
  end,
  HomeCapsule_Group_ND_Group_BQ_Group_2_Group_XS_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    Controller:SelectPond(idx)
  end,
  HomeCapsule_Group_ND_Group_BQ_Group_3_Group_CZ_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    Controller:SelectPond(idx)
  end,
  HomeCapsule_Group_ND_Group_BQ_Group_3_Group_XS_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    Controller:SelectPond(idx)
  end,
  HomeCapsule_Group_ND_Group_BQ_Group_4_Group_CZ_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    Controller:SelectPond(idx)
  end,
  HomeCapsule_Group_ND_Group_BQ_Group_4_Group_XS_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    Controller:SelectPond(idx)
  end,
  HomeCapsule_Group_ND_Group_BQ_Group_5_Group_CZ_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    Controller:SelectPond(idx)
  end,
  HomeCapsule_Group_ND_Group_BQ_Group_5_Group_XS_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    Controller:SelectPond(idx)
  end,
  HomeCapsule_Group_ND_Group_Details_Btn_Close_Click = function(btn, str)
    View.Group_ND.Group_Details.self:SetActive(false)
  end,
  HomeCapsule_Group_YN_Btn_Buy_Click = function(btn, str)
  end,
  HomeCapsule_Group_HomeStore_Group_FurnitureStore_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local idx = tonumber(elementIndex)
    element.Btn_1:SetClickParam(idx)
    local row = HomeStoreDataModel.Now_List.shopFactory.shopList[idx]
    local data = PlayerData:GetFactoryData(row.id)
    element.Txt_Name:SetText(data.commodityName)
    element.Img_Item:SetSprite(data.commodityView)
    local qualityInt = data.qualityInt
    element.Img_Quality:SetSprite(UIConfig.HomeStoreQuality[qualityInt + 1])
    if HomeStoreDataModel.Now_List.server then
      for k, v in pairs(HomeStoreDataModel.Now_List.server.items) do
        if tonumber(v.id) == tonumber(row.id) then
          row.py_cnt = v.py_cnt
        end
      end
    end
    local purchase = data.purchase
    if purchase == true then
      local StoreDataModel = require("UIStore/UIStoreDataModel")
      local maxNum = StoreDataModel:GetPurchaseNum(data)
      row.residue = maxNum - (row.py_cnt or 0)
      if row.residue < 0 then
        row.residue = 0
      end
      element.Group_SY.self:SetActive(true)
      element.Group_SY.Txt_Num:SetText(string.format(GetText(row.residue), row.residue))
      if row.residue == 0 then
        element.Img_ShouWan.self:SetActive(true)
      else
        element.Img_ShouWan.self:SetActive(false)
      end
    else
      row.residue = 100
      element.Group_SY.self:SetActive(false)
      element.Img_ShouWan.self:SetActive(false)
    end
    row.storeType = HomeStoreDataModel.Now_List.shopFactory.storeType
    local money = data.moneyList[1]
    if money then
      element.Img_Money:SetActive(true)
      local left_money = PlayerData:GetFactoryData(tonumber(data.moneyList[1].moneyID))
      element.Img_Money.self:SetSprite(left_money.buyPath)
      element.Img_Money.Txt_MoneyNum:SetText(data.moneyList[1].moneyNum)
    else
      element.Btn_Item.Img_Money:SetActive(false)
    end
    element.Img_Time.self:SetActive(false)
  end,
  HomeCapsule_Group_HomeStore_Group_FurnitureStore_ScrollGrid_List_Group_Item_Btn_1_Click = function(btn, str)
    local row = HomeStoreDataModel.Now_List.shopFactory.shopList[tonumber(str)]
    if row.residue == 0 then
      CommonTips.OpenTips(80600077)
      return
    end
    row.commoditData = PlayerData:GetFactoryData(row.id)
    row.index = tonumber(str) - 1
    row.shopid = HomeStoreDataModel.ShopId
    row.name = row.commoditData.commodityName
    row.image = row.commoditData.commodityView
    row.qualityInt = row.commoditData.qualityInt + 1
    CommonTips.OpenBuyTips(row, function(cnt)
      local CoachDataModel = require("UIHomeCoach/UIHomeCoachDataModel")
      CoachDataModel.ResetFurnitureTypeData()
      Controller:RefreshCoin()
    end)
  end,
  HomeCapsule_Group_HomeStore_Group_Right_StaticGrid_BQ_SetGrid = function(element, elementIndex)
    element.Btn_Click:SetClickParam(elementIndex)
    element.Group_Weixuanzhong.self:SetActive(elementIndex ~= HomeStoreDataModel.curIndex)
    local isShow = elementIndex <= #HomeStoreDataModel.List
    element.self:SetActive(isShow)
    if isShow then
      local shopId = HomeStoreDataModel.List[elementIndex].shopid
      local storeConfig = PlayerData:GetFactoryData(shopId, "StoreFactory")
      element.Group_Xuanzhong.Txt_Name:SetText(storeConfig.storeName)
      element.Group_Xuanzhong.Img_Xuanzhong:SetSprite(storeConfig.pngSelect)
      element.Group_Weixuanzhong.Txt_Name:SetText(storeConfig.storeName)
      element.Group_Weixuanzhong.Img_Weixuanzhong:SetSprite(storeConfig.pngNotSelect)
    end
  end,
  HomeCapsule_Group_Zhu_Group_niudan_Btn_niudan_Click = function(btn, str)
    Controller:ChangeToView(1)
  end,
  HomeCapsule_Group_Zhu_Btn_shangdian_Click = function(btn, str)
    Controller:ChangeToView(2)
  end,
  HomeCapsule_Group_HomeStore_Group_Right_StaticGrid_BQ_Group_BQ_Btn_Click_Click = function(btn, str)
    local idx = tonumber(str)
    HomeStoreDataModel.curIndex = idx
    HomeStoreController:ChooseTab(idx)
    View.Group_HomeStore.Group_Right.StaticGrid_BQ.grid.self:RefreshAllElement()
  end,
  HomeCapsule_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  HomeCapsule_Group_ZC_Btn_Buy_Click = function(btn, str)
  end,
  HomeCapsule_Group_ND_Group_Tips_Btn_Tips_Click = function(btn, str)
    Controller.ShowRewardList()
  end,
  HomeCapsule_StaticGrid_Currency_SetGrid = function(element, elementIndex)
    local data = DataModel.CurrencyData[elementIndex]
    if data == nil then
      return
    end
    local cfg = GetCA(data.id)
    if cfg == nil then
      return
    end
    element.Img_Item:SetSprite(cfg.iconPath)
    element.Txt_Num:SetText(PlayerData:GetSpecialCurrencyById(data.key))
    element.Btn_Buy:SetClickParam(data.id)
    element.Btn_Buy:SetActive(data.showBtn and true)
    element.Img_BG:SetSprite(data.imgBG)
  end,
  HomeCapsule_StaticGrid_Currency_Group_CurrencyItem_Btn_Buy_Click = function(btn, str)
    local cValue = tonumber(str)
    Controller.ShowExchangeShop(cValue)
  end,
  HomeCapsule_Group_ND_Drag_Center_BeginDrag = function(direction, dragPos)
    if not DataModel.CanDrag then
      return
    end
    if DataModel.ReleaseDrag then
      return
    end
    DataModel.dragTempPos = dragPos.x
    DataModel.DragStart = true
  end,
  HomeCapsule_Group_ND_Drag_Center_EndDrag = function(direction, dragPos)
    if not DataModel.CanDrag then
      return
    end
    if not DataModel.DragStart then
      return
    end
    DataModel.DragStart = false
    local targetPos = 0
    if DataModel.ScreenWidth == nil then
      return
    end
    local curPos = View.Group_ND.Drag_Center:GetAnchoredPositionX()
    if curPos > DataModel.ScreenWidth * -0.5 then
      targetPos = 0
    else
      targetPos = -DataModel.ScreenWidth
    end
    if math.abs(curPos - targetPos) < 1 then
      return
    end
    DataModel.ReleaseDrag = true
    DataModel.dragStopTarPos = targetPos
  end,
  HomeCapsule_Group_ND_Drag_Center_OnDrag = function(direction, dragPos)
    if not DataModel.CanDrag then
      return
    end
    if DataModel.ReleaseDrag then
      return
    end
    if not DataModel.DragStart then
      return
    end
    local curPos = View.Group_ND.Drag_Center:GetAnchoredPositionX()
    local tempChange = dragPos.x - DataModel.dragTempPos
    curPos = curPos + tempChange
    DataModel.dragTempPos = dragPos.x
    if curPos == 0 then
      return
    end
    if 0 < curPos then
      DataModel.dragDir = -1
      curPos = curPos - DataModel.ScreenWidth
      View.Group_ND.Drag_Center:SetAnchoredPositionX(curPos)
      local anotherUIName = 3 - Controller.CurShowND
      local lastDataIndex = (DataModel.NDIndex - 2 + DataModel.NDPoolCount) % DataModel.NDPoolCount + 1
      Controller.ShowND(anotherUIName, lastDataIndex)
      local nd1Pos = View.Group_ND.Drag_Center.Group_ND1:GetAnchoredPositionX()
      View.Group_ND.Drag_Center.Group_ND1:SetAnchoredPositionX(View.Group_ND.Drag_Center.Group_ND2:GetAnchoredPositionX())
      View.Group_ND.Drag_Center.Group_ND2:SetAnchoredPositionX(nd1Pos)
      DataModel.hasChange = false
    elseif curPos < -DataModel.ScreenWidth then
      DataModel.dragDir = 1
      curPos = curPos + DataModel.ScreenWidth
      View.Group_ND.Drag_Center:SetAnchoredPositionX(curPos)
      local anotherUIName = 3 - Controller.CurShowND
      local nextDataIndex = DataModel.NDIndex % DataModel.NDPoolCount + 1
      Controller.ShowND(anotherUIName, nextDataIndex)
      local nd1Pos = View.Group_ND.Drag_Center.Group_ND1:GetAnchoredPositionX()
      View.Group_ND.Drag_Center.Group_ND1:SetAnchoredPositionX(View.Group_ND.Drag_Center.Group_ND2:GetAnchoredPositionX())
      View.Group_ND.Drag_Center.Group_ND2:SetAnchoredPositionX(nd1Pos)
      DataModel.hasChange = false
    else
      if DataModel.dragDir == -1 then
        if curPos > DataModel.ScreenWidth * -0.5 and not DataModel.hasChange then
          DataModel.NDIndex = (DataModel.NDIndex - 2 + DataModel.NDPoolCount) % DataModel.NDPoolCount + 1
          Controller.SetPageShow()
          Controller.CurShowND = 3 - Controller.CurShowND
          DataModel.hasChange = true
        elseif curPos < DataModel.ScreenWidth * -0.5 and DataModel.hasChange then
          DataModel.NDIndex = DataModel.NDIndex % DataModel.NDPoolCount + 1
          Controller.SetPageShow()
          Controller.CurShowND = 3 - Controller.CurShowND
          DataModel.hasChange = false
        end
      elseif DataModel.dragDir == 1 then
        if curPos < DataModel.ScreenWidth * -0.5 and not DataModel.hasChange then
          DataModel.NDIndex = DataModel.NDIndex % DataModel.NDPoolCount + 1
          Controller.SetPageShow()
          Controller.CurShowND = 3 - Controller.CurShowND
          DataModel.hasChange = true
        elseif curPos > DataModel.ScreenWidth * -0.5 and DataModel.hasChange then
          DataModel.NDIndex = (DataModel.NDIndex - 2 + DataModel.NDPoolCount) % DataModel.NDPoolCount + 1
          Controller.SetPageShow()
          Controller.CurShowND = 3 - Controller.CurShowND
          DataModel.hasChange = false
        end
      end
      View.Group_ND.Drag_Center:SetAnchoredPositionX(curPos)
    end
  end,
  HomeCapsule_Group_ZT_Btn_Close_Click = function(btn, str)
    View.Group_ZT:SetActive(false)
  end,
  HomeCapsule_Group_ND_Group_Pay_Group_One_Img_One_Btn__Click = function(btn, str)
    Controller:OnePick()
  end,
  HomeCapsule_Group_ND_Group_Pay_Group_Ten_Img_Ten_Btn__Click = function(btn, str)
    Controller:TenPick()
  end,
  HomeCapsule_Group_BuyItem_Btn_BG_Click = function(btn, str)
    View.Group_BuyItem.self:SetActive(false)
  end,
  HomeCapsule_Group_BuyItem_Group_Middle_Group_Item1_Btn_Item_Click = function(btn, str)
  end,
  HomeCapsule_Group_BuyItem_Group_Middle_Group_Item2_Btn_Item_Click = function(btn, str)
  end,
  HomeCapsule_Group_BuyItem_Btn_Confirm_Click = function(btn, str)
    if not DataModel.ConfirmType then
      View.Group_BuyItem.self:SetActive(false)
      return
    end
    
    local function cb(json)
      View.Group_BuyItem.self:SetActive(false)
      Controller:RefreshCoin()
      Controller.RefreshCanExchangeShow()
      if DataModel.AutoPickAfterBuy then
        Controller.DoPick(DataModel.PickType)
      end
    end
    
    if DataModel.ConfirmType == "ExchangeHD" then
      Net:SendProto("shop.buy", function(json)
        local items = {
          [DataModel.HDItemID] = DataModel.CostMoneyNum
        }
        PlayerData:RefreshUseItems(items)
        cb(json)
      end, tostring(DataModel.StoreID), DataModel.StoreIndex - 1, DataModel.NeedNum, DataModel.CommodityId)
    elseif DataModel.ConfirmType == "ExchangeHS" then
      if DataModel.NeedBuyMoney then
        View.Group_BuyItem.self:SetActive(false)
        
        local function callback()
          CommonTips.OpenStoreBuy()
        end
        
        CommonTips.OnPrompt(80600147, GetText(80600068), GetText(80600067), callback)
      else
        Net:SendProto("shop.buy", function(json)
          cb(json)
        end, tostring(DataModel.StoreID), DataModel.StoreIndex - 1, DataModel.NeedNum, DataModel.CommodityId)
      end
    elseif DataModel.ConfirmType == "Confirm" then
      Controller.DoPick(DataModel.PickType)
      View.Group_BuyItem.self:SetActive(false)
    end
  end,
  HomeCapsule_Group_BuyItem_Btn_Cancel_Click = function(btn, str)
    View.Group_BuyItem.self:SetActive(false)
  end,
  HomeCapsule_Group_Model_Btn_Skip_Click = function(btn, str)
    Controller:SkipAnime()
  end,
  HomeCapsule_Group_CurrencyItem_Btn_Buy_Click = function(btn, str)
  end,
  HomeCapsule_Group_Exchange_Btn_Close_Click = function(btn, str)
    View.Group_Exchange:SetActive(false)
    Controller.ClearShopBuyTempData()
  end,
  HomeCapsule_Group_Exchange_Group_Exchange_Group_Item1_Btn_Item_Click = function(btn, str)
  end,
  HomeCapsule_Group_Exchange_Group_Exchange_Group_Item2_Btn_Item_Click = function(btn, str)
  end,
  HomeCapsule_Group_Exchange_Group_Exchange_Group_Item3_Btn_Item_Click = function(btn, str)
  end,
  HomeCapsule_Group_Exchange_Group_Exchange_Group_Item4_Btn_Item_Click = function(btn, str)
  end,
  HomeCapsule_Group_Exchange_Group_Exchange_Group_Item5_Btn_Item_Click = function(btn, str)
  end,
  HomeCapsule_Group_Exchange_Group_Exchange_Group_Item6_Btn_Item_Click = function(btn, str)
  end,
  HomeCapsule_Group_Exchange_Group_Exchange_Group_ExchangeItem_Btn_Item_Click = function(btn, str)
  end,
  HomeCapsule_Group_Exchange_Group_Num_Btn_Min_Click = function(btn, str)
    DataModel.shopBuyNum = 1
    Controller.RefreshShopBuyShow()
    View.Group_Exchange.Group_Num.Group_Slider.Slider_Value:SetSliderValue(DataModel.shopBuyNum)
  end,
  HomeCapsule_Group_Exchange_Group_Num_Btn_Dec_Click = function(btn, str)
    if DataModel.shopBuyNum <= 1 then
      return
    end
    DataModel.shopBuyNum = DataModel.shopBuyNum - 1
    Controller.RefreshShopBuyShow()
    View.Group_Exchange.Group_Num.Group_Slider.Slider_Value:SetSliderValue(DataModel.shopBuyNum)
  end,
  HomeCapsule_Group_Exchange_Group_Num_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel.shopBuyNum = value
    Controller.RefreshShopBuyShow()
  end,
  HomeCapsule_Group_Exchange_Group_Num_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  HomeCapsule_Group_Exchange_Group_Num_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  HomeCapsule_Group_Exchange_Group_Num_Btn_Add_Click = function(btn, str)
    if DataModel.shopBuyNum >= DataModel.maxCanBuy then
      return
    end
    DataModel.shopBuyNum = DataModel.shopBuyNum + 1
    Controller.RefreshShopBuyShow()
    View.Group_Exchange.Group_Num.Group_Slider.Slider_Value:SetSliderValue(DataModel.shopBuyNum)
  end,
  HomeCapsule_Group_Exchange_Group_Num_Btn_Max_Click = function(btn, str)
    DataModel.shopBuyNum = DataModel.maxCanBuy
    Controller.RefreshShopBuyShow()
    View.Group_Exchange.Group_Num.Group_Slider.Slider_Value:SetSliderValue(DataModel.shopBuyNum)
  end,
  HomeCapsule_Group_Exchange_Btn_Cancel_Click = function(btn, str)
    View.Group_Exchange:SetActive(false)
    Controller.ClearShopBuyTempData()
  end,
  HomeCapsule_Group_Exchange_Btn_Use_Click = function(btn, str)
    local function cb(json)
      View.Group_Exchange.self:SetActive(false)
      
      Controller:RefreshCoin()
      Controller.RefreshCanExchangeShow()
      Controller.ClearShopBuyTempData()
    end
    
    if DataModel.ConfirmType == "ExchangeHD" then
      Net:SendProto("shop.buy", function(json)
        local items = {
          [DataModel.HDItemID] = math.floor(DataModel.shopBuyNum * DataModel.singlePrice)
        }
        PlayerData:RefreshUseItems(items)
        cb(json)
      end, tostring(DataModel.StoreID), 1, math.floor(DataModel.shopBuyNum), DataModel.CommodityId)
    elseif DataModel.ConfirmType == "ExchangeHS" then
      CommonTips.OnPrompt(80609996, nil, nil, function()
        Net:SendProto("shop.buy", function(json)
          cb(json)
        end, tostring(DataModel.StoreID), 1, math.floor(DataModel.shopBuyNum), DataModel.CommodityId)
      end)
    elseif DataModel.ConfirmType == "ExchangeOld" then
      Net:SendProto("shop.buy", function(json)
        local items = {
          [DataModel.costOldId] = math.floor(DataModel.shopBuyNum * DataModel.singlePrice)
        }
        PlayerData:RefreshUseItems(items)
        cb(json)
        local data = DataModel.NDPool[DataModel.NDIndex]
        Controller.ShowOldChange(data.data.oldCoinStoreId)
        UIManager:Open("UI/Monopoly/UI/ShowItem/MonopolyShowItem", Json.encode({
          rewards = json.reward,
          title = nil,
          ignoreCloseTime = true,
          cfgId = DataModel.NDPool[DataModel.NDIndex].data.id
        }))
      end, tostring(DataModel.StoreID), 1, math.floor(DataModel.shopBuyNum), DataModel.CommodityId)
    end
  end,
  HomeCapsule_Group_ZT_Group_probability_Btn_On_Click = function(btn, str)
    View.Group_ZT.Group_probability.Btn_On:SetActive(false)
    View.Group_ZT.Group_probability.Btn_Off:SetActive(true)
    Controller.SetRewardRateShow(true)
  end,
  HomeCapsule_Group_ZT_Group_probability_Btn_Off_Click = function(btn, str)
    View.Group_ZT.Group_probability.Btn_On:SetActive(true)
    View.Group_ZT.Group_probability.Btn_Off:SetActive(false)
    Controller.SetRewardRateShow(false)
  end,
  HomeCapsule_Group_ZT_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  HomeCapsule_Group_ZT_ScrollView_PrizeList_Viewport_Content_StaticGrid_1_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardsData[1][elementIndex]
    if data == nil then
      return
    end
    Controller.SetRewardItem(element, data)
  end,
  HomeCapsule_Group_ZT_ScrollView_PrizeList_Viewport_Content_StaticGrid_1_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  HomeCapsule_Group_ZT_ScrollView_PrizeList_Viewport_Content_StaticGrid_2_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardsData[2][elementIndex]
    if data == nil then
      return
    end
    Controller.SetRewardItem(element, data)
  end,
  HomeCapsule_Group_ZT_ScrollView_PrizeList_Viewport_Content_StaticGrid_2_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  HomeCapsule_Group_ZT_ScrollView_PrizeList_Viewport_Content_StaticGrid_3_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardsData[3][elementIndex]
    if data == nil then
      return
    end
    Controller.SetRewardItem(element, data)
  end,
  HomeCapsule_Group_ZT_ScrollView_PrizeList_Viewport_Content_StaticGrid_3_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  HomeCapsule_Group_ZT_ScrollView_PrizeList_Viewport_Content_StaticGrid_4_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardsData[4][elementIndex]
    if data == nil then
      return
    end
    Controller.SetRewardItem(element, data)
  end,
  HomeCapsule_Group_ZT_ScrollView_PrizeList_Viewport_Content_StaticGrid_4_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  HomeCapsule_Group_ZT_ScrollView_PrizeList_Viewport_Content_StaticGrid_5_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardsData[5][elementIndex]
    if data == nil then
      return
    end
    Controller.SetRewardItem(element, data)
  end,
  HomeCapsule_Group_ZT_ScrollView_PrizeList_Viewport_Content_StaticGrid_5_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  HomeCapsule_Group_ND_Btn_OldCoinStore_Click = function(btn, str)
    Controller.ShowOldChange(tonumber(str))
  end,
  HomeCapsule_Group_OldCoinStore_Btn_Close_Click = function(btn, str)
    View.Group_OldCoinStore:SetActive(false)
  end,
  HomeCapsule_Group_OldCoinStore_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local data = DataModel.oldChangeList[elementIndex]
    if data == nil then
      return
    end
    local cfg = PlayerData:GetFactoryData(data.id, "CommodityFactory")
    local getCfg = PlayerData:GetFactoryData(cfg.commodityItemList[1].id, "ItemFactory")
    element.Group_Get.Img_Icon:SetSprite(getCfg.iconPath)
    element.Group_Get.Group_Name.Txt_Name:SetText(getCfg.name)
    element.Group_Get.Txt_Num:SetText(cfg.commodityItemList[1].num)
    element.Group_Get.Img_Icon.Btn_:SetClickParam(getCfg.id)
    local costCfg = PlayerData:GetFactoryData(cfg.moneyList[1].moneyID, "ItemFactory")
    element.Group_Consume.Img_Icon:SetSprite(costCfg.iconPath)
    element.Group_Consume.Group_Name.Txt_Name:SetText(costCfg.name)
    element.Group_Consume.Txt_Num:SetText(cfg.moneyList[1].moneyNum)
    element.Group_Consume.Img_Icon.Btn_:SetClickParam(costCfg.id)
    element.Group_Btn.Group_Can.Btn_:SetClickParam(data.id)
    local costNum = PlayerData:GetGoodsById(costCfg.id).num
    local can = costNum >= cfg.moneyList[1].moneyNum
    element.Group_Btn.Group_Can:SetActive(can)
    element.Group_Btn.Group_Not:SetActive(not can)
    local eCfg = DataModel.NDPool[DataModel.NDIndex].data
    element.Img_Bg:SetSprite(DataModel.GetSpritePath(eCfg, eCfg.oldCoinStoreListPath))
    element.Img_Arrow:SetSprite(DataModel.GetSpritePath(eCfg, eCfg.oldCoinStoreArrowPath))
    element.Group_Get.Group_Name.Img_:SetSprite(DataModel.GetSpritePath(eCfg, eCfg.oldCoinStoreNamePath))
    element.Group_Consume.Group_Name.Img_:SetSprite(DataModel.GetSpritePath(eCfg, eCfg.oldCoinStoreNamePath))
    element.Group_Get.Img_NumBg:SetSprite(DataModel.GetSpritePath(eCfg, eCfg.oldCoinStoreNumPath))
    element.Group_Consume.Img_NumBg:SetSprite(DataModel.GetSpritePath(eCfg, eCfg.oldCoinStoreNumPath))
    element.Group_Btn.Group_Can.Img_:SetSprite(DataModel.GetSpritePath(eCfg, eCfg.oldCoinStoreBtnCanPath))
    element.Group_Btn.Group_Not.Img_:SetSprite(DataModel.GetSpritePath(eCfg, eCfg.oldCoinStoreBtnNotPath))
  end,
  HomeCapsule_Group_OldCoinStore_ScrollGrid_List_Group_Item_Group_Consume_Img_Icon_Btn__Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  HomeCapsule_Group_OldCoinStore_ScrollGrid_List_Group_Item_Group_Get_Img_Icon_Btn__Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  HomeCapsule_Group_OldCoinStore_ScrollGrid_List_Group_Item_Group_Btn_Group_Can_Btn__Click = function(btn, str)
    Controller.ShowExchangeShop_OldChange(tonumber(str))
  end
}
return ViewFunction
