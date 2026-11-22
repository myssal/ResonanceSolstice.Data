local View = require("UIHomeCapsule/UIHomeCapsuleView")
local DataModel = require("UIHomeCapsule/UIHomeCapsuleDataModel")
local HomeStoreDataModel = require("UIHomeCapsule/UIHomeStoreDataModel")
local HomeStoreController = require("UIHomeCapsule/UIHomeStoreController")
local CommonItem = require("Common/BtnItem")
local Controller = {}
local Enum_ItemQuality2Group = {
  Golden = 1,
  Yellow = 2,
  Purple = 3,
  Blue = 4
}
local tempNDName

function Controller:Init(defaultSelect)
  DataModel.Init()
  for i = 1, 5 do
    local element = View.Group_ND.Group_BQ["Group_" .. i]
    if element ~= nil then
      local data = DataModel.pondInfo[i]
      if data == nil then
        element.self:SetActive(false)
      else
        element.self:SetActive(true)
        element.Group_CZ.self:SetActive(not data.limit)
        element.Group_XS.self:SetActive(data.limit)
        element.Group_CZ.Img_XZ.Txt_Name:SetText(data.ca.themeName)
        element.Group_CZ.Img_WXZ.Txt_Name:SetText(data.ca.themeName)
        element.Group_XS.Img_XZ.Txt_Name:SetText(data.ca.themeName)
        element.Group_XS.Img_WXZ.Txt_Name:SetText(data.ca.themeName)
      end
      element.Group_CZ.Btn_:SetClickParam(i)
      element.Group_XS.Btn_:SetClickParam(i)
    end
  end
  Controller:RefreshCoin()
  if defaultSelect == true then
    Controller:SelectPond(1)
  end
end

function Controller:InitND(poolList)
  DataModel:GetNDPool(poolList)
  View.Group_ND.Img_BG1:SetAlpha(1)
  View.Group_ND.Img_BG2:SetAlpha(0)
  if 0 < DataModel.NDPoolCount then
    self.CurShowND = 1
    self.ShowND(self.CurShowND, DataModel.NDIndex)
    if 1 < DataModel.NDPoolCount then
      local nextData = DataModel.NDIndex % DataModel.NDPoolCount + 1
      self.ShowND(3 - self.CurShowND, nextData)
      DataModel.CanDrag = true
      View.Group_Change:SetActive(true)
      for m = 1, 5 do
        View.Group_Change.Group_ID["Group_ID_00" .. m]:SetActive(m <= DataModel.NDPoolCount)
        View.Group_Change.Group_ID["Group_ID_00" .. m].Img_Off:SetActive(m ~= DataModel.NDIndex)
        View.Group_Change.Group_ID["Group_ID_00" .. m].Img_On:SetActive(m == DataModel.NDIndex)
      end
    else
      DataModel.CanDrag = false
      View.Group_Change:SetActive(false)
    end
    View.Group_ND.Drag_Center:SetAnchoredPositionX(0)
  else
    DataModel.CanDrag = false
    View.Group_Change:SetActive(false)
  end
  DataModel.ScreenWidth = 1920
  local canvas = UIManager:GetCanvas():GetComponent(typeof(CS.UnityEngine.RectTransform))
  if canvas then
    DataModel.ScreenWidth = canvas.rect.width
  end
  View.Group_ND:SetWidth(DataModel.ScreenWidth)
  View.Group_ND.Drag_Center:SetWidth(DataModel.ScreenWidth * 2)
  View.Group_ND.Drag_Center.Group_ND1:SetWidth(DataModel.ScreenWidth)
  View.Group_ND.Drag_Center.Group_ND2:SetWidth(DataModel.ScreenWidth)
  View.Group_ND.Drag_Center.Group_ND1:SetAnchoredPositionX(0)
  View.Group_ND.Drag_Center.Group_ND2:SetAnchoredPositionX(DataModel.ScreenWidth)
  DataModel.dragDir = 1
  DataModel.ReleaseDrag = false
  DataModel.DragStart = false
  DataModel.dragTempPos = nil
  DataModel.dragStopTarPos = nil
  DataModel.hasChange = false
end

function Controller.SetPageShow()
  for m = 1, DataModel.NDPoolCount do
    View.Group_Change.Group_ID["Group_ID_00" .. m].Img_Off:SetActive(m ~= DataModel.NDIndex)
    View.Group_Change.Group_ID["Group_ID_00" .. m].Img_On:SetActive(m == DataModel.NDIndex)
  end
end

function Controller.ShowND(ndIndex, dataIndex)
  if DataModel.NDPool and 0 < dataIndex and dataIndex <= #DataModel.NDPool then
    Controller:RefreshCoin()
    local curData = DataModel.NDPool[dataIndex]
    local cfg = curData.data
    DataModel.NDAnimeTimeConfig = cfg.ndTime
    DataModel.EggUpTime = cfg.eggup
    DataModel.EggOpenTime = cfg.eggopen
    if 0 < #cfg.imageList then
      View.Group_ND.Drag_Center["Group_ND" .. ndIndex].Img_ND:SetSprite(DataModel.GetSpritePath(cfg, cfg.imageList[1].image))
      View.Group_ND.Drag_Center["Group_ND" .. ndIndex].Img_ND:SetAnchoredPosition(Vector2(cfg.imageList[1].x, cfg.imageList[1].y))
      View.Group_ND.Drag_Center["Group_ND" .. ndIndex].Img_ND:SetNativeSize()
      View.Group_ND.Drag_Center["Group_ND" .. ndIndex].Img_ND.transform.localScale = Vector3.one * cfg.imageList[1].scale
    end
    View.Group_ND.Img_BG1:SetSprite(DataModel.GetSpritePath(cfg, cfg.imageBg))
    for i = 1, 6 do
      View.Group_ND["Img_Show" .. i]:SetActive(false)
    end
    local tempImgIndex = 1
    for k, v in pairs(cfg.showList) do
      local tempImg = View.Group_ND["Img_Show" .. tempImgIndex]
      tempImg:SetActive(true)
      tempImg:SetSprite(DataModel.GetSpritePath(cfg, v.image))
      tempImg:SetNativeSize()
      tempImg:SetAnchoredPosition(Vector2(v.x, v.y))
      tempImgIndex = tempImgIndex + 1
    end
    View.Group_ND.Group_Pay.Group_One.Img_One:SetSprite(DataModel.GetSpritePath(cfg, cfg.btnBg))
    View.Group_ND.Group_Pay.Group_One.Img_One:SetNativeSize()
    View.Group_ND.Group_Pay.Group_One:SetAnchoredPosition(Vector2(cfg.payOneX, cfg.payOneY))
    View.Group_ND.Group_Pay.Group_Ten.Img_Ten:SetSprite(DataModel.GetSpritePath(cfg, cfg.btnTenBg))
    View.Group_ND.Group_Pay.Group_Ten.Img_Ten:SetNativeSize()
    View.Group_ND.Group_Pay.Group_Ten:SetAnchoredPosition(Vector2(cfg.payTenX, cfg.payTenY))
    local limit = cfg.endTime ~= ""
    View.Group_ND.Group_Tips.Group_Time.self:SetActive(limit)
    View.Group_ND.Group_Tips.Btn_Tips:SetSprite(DataModel.GetSpritePath(cfg, cfg.titlePath))
    View.Group_ND.Group_Tips.Btn_Tips:SetNativeSize()
    View.Group_ND.Group_Tips:SetAnchoredPosition(Vector2(cfg.titleX, cfg.titleY))
    View.Group_ND.Group_Tips.Btn_Tips.Txt_:SetAnchoredPosition(Vector2(cfg.rewardBtnTxtX, cfg.rewardBtnTxtY))
    View.Group_Model.Btn_Skip:SetSprite(DataModel.GetSpritePath(cfg, cfg.skipPath))
    local showOther = cfg.id == 80500001
    View.Group_ND.Img_decorationFlash1:SetActive(showOther)
    View.Group_ND.Img_decorationFlash2:SetActive(showOther)
    View.Group_ND.Img_decoration1:SetActive(showOther)
    View.Group_ND.Img_decoration2:SetActive(showOther)
    View.Group_ND.Img_decoration3:SetActive(showOther)
    View.Group_ND.Img_decoration4:SetActive(showOther)
    View.Group_ND.Img_decoration5:SetActive(showOther)
    View.Group_BuyItem.Img_Mask.Img_B:SetSprite(DataModel.GetSpritePath(cfg, cfg.buyBgPath))
    View.Group_BuyItem.Img_Mask.Img_B:SetNativeSize()
    View.Group_BuyItem.Img_Mask.Img_B:SetAnchoredPosition(Vector2(cfg.buyBgX, cfg.buyBgY))
    View.Group_BuyItem.Group_Middle.Img_Arrow:SetSprite(DataModel.GetSpritePath(cfg, cfg.buyArrowPath))
    View.Group_BuyItem.Group_Middle.Img_Arrow:SetNativeSize()
    View.Group_BuyItem.Btn_Confirm:SetSprite(DataModel.GetSpritePath(cfg, cfg.buyOkPath))
    View.Group_BuyItem.Btn_Confirm:SetNativeSize()
    View.Group_BuyItem.Btn_Confirm:SetAnchoredPosition(Vector2(cfg.buyOkX, cfg.buyOkY))
    View.Group_BuyItem.Btn_Confirm.Group_.Img_Icon:SetSprite(DataModel.GetSpritePath(cfg, cfg.buyOkIconPath))
    View.Group_BuyItem.Btn_Confirm.Group_.Img_Icon:SetNativeSize()
    View.Group_BuyItem.Btn_Confirm.Group_.Txt_Confirm:SetColor(cfg.buyOkTxtColor)
    View.Group_BuyItem.Btn_Cancel:SetSprite(DataModel.GetSpritePath(cfg, cfg.buyNoPath))
    View.Group_BuyItem.Btn_Cancel:SetNativeSize()
    View.Group_BuyItem.Btn_Cancel:SetAnchoredPosition(Vector2(cfg.buyNoX, cfg.buyNoY))
    View.Group_BuyItem.Btn_Cancel.Group_.Img_Icon:SetSprite(DataModel.GetSpritePath(cfg, cfg.buyNoIconPath))
    View.Group_BuyItem.Btn_Cancel.Group_.Img_Icon:SetNativeSize()
    View.Group_BuyItem.Btn_Cancel.Group_.Txt_Cancel:SetColor(cfg.buyNoTxtColor)
    if limit then
      local month = string.sub(cfg.endTime, 6, 7)
      local day = string.sub(cfg.endTime, 9, 10)
      local hour = string.sub(cfg.endTime, 12, 13)
      local min = string.sub(cfg.endTime, 15, 16)
      View.Group_ND.Group_Tips.Group_Time.Txt_FinishTime:SetText(string.format(GetText(80600447), month, day, hour, min))
    end
    Controller.RefreshCanExchangeShow()
    View.Group_ND.Btn_OldCoinStore:SetActive(cfg.oldCoinStoreId and 0 < cfg.oldCoinStoreId)
    View.Group_ND.Btn_OldCoinStore:SetClickParam(cfg.oldCoinStoreId)
    View.Group_ND.Btn_OldCoinStore:SetSprite(DataModel.GetSpritePath(cfg, cfg.oldCoinStoreBtnPath))
    View.Group_ND.Btn_OldCoinStore.Txt_0:SetAnchoredPosition(Vector2(cfg.oldCoinEntranceTxtX, cfg.oldCoinEntranceTxtY))
    View.Group_ND.Btn_OldCoinStore.Txt_0:SetColor(cfg.oldCoinEntranceTxtColor)
    View.Group_ND.Btn_OldCoinStore:SetAnchoredPosition(Vector2(cfg.oldCoinStoreBtnX, cfg.oldCoinStoreBtnY))
    View.Group_ND.Btn_OldCoinStore:SetNativeSize()
    if 0 < cfg.oldCoinEntranceTxtSize then
      View.Group_ND.Btn_OldCoinStore.Txt_0:SetTxtFontSize(cfg.oldCoinEntranceTxtSize)
    end
    View.Group_OldCoinStore.Img_Di:SetSprite(DataModel.GetSpritePath(cfg, cfg.oldCoinStoreDiPath))
    View.Group_OldCoinStore.Img_Di:SetAnchoredPosition(Vector2(cfg.oldCoinStoreDiX, cfg.oldCoinStoreDiY))
    View.Group_OldCoinStore.Img_Di:SetNativeSize()
    View.Group_OldCoinStore.Txt_Title:SetAnchoredPosition(Vector2(cfg.oldCoinTitleTxtX, cfg.oldCoinTitleTxtY))
    View.Group_OldCoinStore.Txt_Title:SetColor(cfg.oldCoinTitleTxtColor)
    if 0 < cfg.oldCoinTitleTxtSize then
      View.Group_OldCoinStore.Txt_Title:SetTxtFontSize(cfg.oldCoinTitleTxtSize)
    end
  end
end

function Controller.ShowOldChange(storeId)
  if storeId == nil or storeId <= 0 then
    return
  end
  View.Group_OldCoinStore:SetActive(true)
  local storeCfg = PlayerData:GetFactoryData(storeId, "StoreFactory")
  DataModel.oldChangeList = storeCfg.shopList
  View.Group_OldCoinStore.ScrollGrid_List.grid.self:SetDataCount(#DataModel.oldChangeList)
  View.Group_OldCoinStore.ScrollGrid_List.grid.self:RefreshAllElement()
end

function Controller.RefreshCanExchangeShow()
  if DataModel.NDPool == nil or DataModel.NDPool[DataModel.NDIndex] == nil then
    return
  end
  local data = DataModel.NDPool[DataModel.NDIndex]
  if data.itemNum == nil then
    TimerHelper.StartOnce("SetExchangeNumShow", 0.5, function()
      Controller.RefreshCanExchangeShow()
    end)
    return
  end
  local show = true
  if data.data.commodityId == nil or data.data.commodityId == "" or data.data.commodityId <= 0 then
    show = false
  end
  if not show then
    View.Group_exchangeNum:SetActive(false)
    Controller.RefreshLimit()
    return
  else
    View.Group_exchangeNum:SetActive(true)
  end
  local cost = data.data.costList[1]
  local temp = PlayerData:GetGoodsById(cost.id)
  DataModel.CanExchangeNum = math.max(0, data.itemNum - temp.num)
  local itemCfg = PlayerData:GetFactoryData(cost.id, "ItemFactory")
  View.Group_exchangeNum.Img_Bg.Txt_Num:SetText(math.floor(DataModel.CanExchangeNum))
  View.Group_exchangeNum.Img_Bg.Img_Item:SetSprite(itemCfg.iconPath)
  Controller.RefreshLimit()
end

function Controller.RefreshLimit()
  if DataModel.NDPool == nil or DataModel.NDPool[DataModel.NDIndex] == nil then
    return
  end
  local data = DataModel.NDPool[DataModel.NDIndex]
  View.Group_LimitCapsuleNum:SetActive(data.data.isLimitCapsuleNum)
  if data.data.isLimitCapsuleNum then
    DataModel.useCount = Controller.GetPoolRewardNum() - data.itemNum
    DataModel.canPickNum = data.maxNum - DataModel.useCount
    View.Group_LimitCapsuleNum.Txt_Num:SetText(string.format(GetText(80611118), DataModel.useCount, data.maxNum))
    View.Group_LimitCapsuleNum.Txt_Tips:SetText(string.format(GetText(80611120), data.data.dailyCapsuleNum, data.data.capsuleNumCeiling))
  end
end

function Controller.GetPoolRewardNum()
  if DataModel.NDPool == nil or DataModel.NDPool[DataModel.NDIndex] == nil then
    return 0
  end
  local data = DataModel.NDPool[DataModel.NDIndex]
  local result = 0
  for k, v in pairs(data.data.capsuleList) do
    result = result + v.limitNum
  end
  return result
end

function Controller:ChangeToView(type, poolList, force)
  if not force and DataModel.viewType == type then
    return
  end
  if type == 1 then
    Controller:InitND(poolList)
  elseif type == 2 then
    local a, b = PlayerData:OpenStoreCondition()
    if a == false then
      CommonTips.OpenTips(b[1].txt)
      return
    end
    Net:SendProto("shop.info", function(json)
      View.Group_Zhu.Group_niudan.Img_xuanzhong.self:SetActive(false)
      View.Group_Zhu.Group_niudan.Img_weixuanzhong.self:SetActive(true)
      View.Group_Zhu.Group_shangdian.Img_xuanzhong.self:SetActive(true)
      View.Group_Zhu.Group_shangdian.Img_weixuanzhong.self:SetActive(false)
      Controller:RefreshCoin()
      View.Group_ND.self:SetActive(false)
      View.Group_HomeStore.self:SetActive(true)
      HomeStoreController.InitStore()
      HomeStoreDataModel.curIndex = 1
      HomeStoreController:ChooseTab(HomeStoreDataModel.curIndex)
    end)
  end
  DataModel.viewType = type
end

function Controller.ShowRewardList()
  View.Group_ZT:SetActive(true)
  if DataModel.NDPool[DataModel.NDIndex] ~= nil then
    local poolData = DataModel.NDPool[DataModel.NDIndex]
    local cfg = poolData.data
    local netList = poolData.pool
    DataModel.rewardNumBg = DataModel.GetSpritePath(cfg, cfg.rewardNumBg)
    DataModel.noNumBg = DataModel.GetSpritePath(cfg, cfg.noNumBg)
    View.Group_ZT.Img_BG:SetSprite(DataModel.GetSpritePath(cfg, cfg.rewardBg))
    View.Group_ZT.Img_BG:SetNativeSize()
    View.Group_ZT.Group_TP.Img_Common:SetSprite(DataModel.GetSpritePath(cfg, cfg.decoratePath))
    View.Group_ZT.Group_TP.Img_Common:SetAnchoredPosition(Vector2(cfg.decorateX, cfg.decorateY))
    View.Group_ZT.Group_probability.Img_probability:SetSprite(DataModel.GetSpritePath(cfg, cfg.probability))
    View.Group_ZT.Group_probability.Img_probability:SetNativeSize()
    View.Group_ZT.Group_probability.Btn_On.Img_On:SetSprite(DataModel.GetSpritePath(cfg, cfg.probabilityOn))
    View.Group_ZT.Group_probability.Btn_On.Img_On:SetNativeSize()
    View.Group_ZT.Group_probability.Btn_Off.Img_Off:SetSprite(DataModel.GetSpritePath(cfg, cfg.probabilityOff))
    View.Group_ZT.Group_probability.Btn_Off.Img_Off:SetNativeSize()
    View.Group_ZT.Img_BG:SetAnchoredPosition(Vector2(cfg.rewardBgX, cfg.rewardBgY))
    View.Group_ZT.Group_probability:SetAnchoredPosition(Vector2(cfg.rewardProbilityX, cfg.rewardProbilityY))
    if cfg and netList then
      local sContent = View.Group_ZT.ScrollView_PrizeList.Viewport.Content
      sContent.Img_Line1.Img_Title:SetSprite(DataModel.GetSpritePath(cfg, cfg.treasurePath))
      sContent.Img_Line1.Img_Title:SetNativeSize()
      sContent.Img_Line1.Img_Title:SetAnchoredPosition(Vector2(cfg.rewardQualityTitleX, cfg.rewardQualityTitleY))
      sContent.Img_Line2.Img_Title:SetSprite(DataModel.GetSpritePath(cfg, cfg.preciousPath))
      sContent.Img_Line2.Img_Title:SetNativeSize()
      sContent.Img_Line2.Img_Title:SetAnchoredPosition(Vector2(cfg.rewardQualityTitleX, cfg.rewardQualityTitleY))
      sContent.Img_Line3.Img_Title:SetSprite(DataModel.GetSpritePath(cfg, cfg.rarePath))
      sContent.Img_Line3.Img_Title:SetNativeSize()
      sContent.Img_Line3.Img_Title:SetAnchoredPosition(Vector2(cfg.rewardQualityTitleX, cfg.rewardQualityTitleY))
      sContent.Img_Line4.Img_Title:SetSprite(DataModel.GetSpritePath(cfg, cfg.casualPath))
      sContent.Img_Line4.Img_Title:SetNativeSize()
      sContent.Img_Line4.Img_Title:SetAnchoredPosition(Vector2(cfg.rewardQualityTitleX, cfg.rewardQualityTitleY))
      sContent.Img_Line1:SetSprite(DataModel.GetSpritePath(cfg, cfg.titleLine))
      sContent.Img_Line2:SetSprite(DataModel.GetSpritePath(cfg, cfg.titleLine))
      sContent.Img_Line3:SetSprite(DataModel.GetSpritePath(cfg, cfg.titleLine))
      sContent.Img_Line4:SetSprite(DataModel.GetSpritePath(cfg, cfg.titleLine))
      View.Group_ZT.Txt_Name:SetText(cfg.tabName)
      View.Group_ZT.Txt_Index:SetText("0" .. DataModel.NDIndex)
      local itemsList = cfg.capsuleList
      DataModel.rewardsData = {}
      for k, v in pairs(itemsList) do
        local groupIndex = Enum_ItemQuality2Group[v.quality]
        DataModel.rewardsData[groupIndex] = DataModel.rewardsData[groupIndex] or {}
        table.insert(DataModel.rewardsData[groupIndex], v)
      end
      sContent.StaticGrid_1.grid.self:SetDataCount(#DataModel.rewardsData[1])
      sContent.StaticGrid_1.grid.self:RefreshAllElement()
      sContent.StaticGrid_2.grid.self:SetDataCount(#DataModel.rewardsData[2])
      sContent.StaticGrid_2.grid.self:RefreshAllElement()
      sContent.StaticGrid_3.grid.self:SetDataCount(#DataModel.rewardsData[3])
      sContent.StaticGrid_3.grid.self:RefreshAllElement()
      sContent.StaticGrid_4.grid.self:SetDataCount(#DataModel.rewardsData[4])
      sContent.StaticGrid_4.grid.self:RefreshAllElement()
    end
  end
  Controller.SetRewardRateShow(false)
  View.Group_ZT.Group_probability.Btn_On:SetActive(true)
  View.Group_ZT.Group_probability.Btn_Off:SetActive(false)
end

function Controller.SetRewardItem(element, data)
  if DataModel.onlyRefreshRate then
    element.Imgprobability:SetActive(DataModel.showRewardRate)
    return
  end
  local poolData = DataModel.NDPool[DataModel.NDIndex]
  local netList = poolData.pool
  element.Img_1:SetSprite(DataModel.rewardNumBg)
  element.Img_SoldOut:SetSprite(DataModel.noNumBg)
  local itemCount = netList[tostring(data.index)] or 0
  element.Img_Empty:SetActive(itemCount == 0)
  element.Img_SoldOut:SetActive(itemCount == 0)
  element.Txt_ResidueNum:SetText(string.format(GetText(80610309), itemCount))
  local rate = data.weight / poolData.totleWeight * 100
  element.Imgprobability:SetSprite(DataModel.rewardNumBg)
  local tempStr = "%.0f"
  if rate < 0.999 then
    tempStr = "%.1f"
  end
  element.Imgprobability.Txt_ProNum:SetText(string.format(tempStr, rate) .. "%")
  element.Img_label:SetActive(data.isFirst)
  element.Group_Item.Btn_Item:SetClickParam(data.id)
  CommonItem:SetItem(element.Group_Item, {
    id = data.id,
    num = data.num
  })
end

function Controller.SetRewardRateShow(value)
  DataModel.showRewardRate = value
  DataModel.onlyRefreshRate = true
  View.Group_ZT.ScrollView_PrizeList.Viewport.Content.StaticGrid_1.grid.self:RefreshAllElement()
  View.Group_ZT.ScrollView_PrizeList.Viewport.Content.StaticGrid_2.grid.self:RefreshAllElement()
  View.Group_ZT.ScrollView_PrizeList.Viewport.Content.StaticGrid_3.grid.self:RefreshAllElement()
  View.Group_ZT.ScrollView_PrizeList.Viewport.Content.StaticGrid_4.grid.self:RefreshAllElement()
  DataModel.onlyRefreshRate = nil
end

function Controller.ShowExchange(item1, item2, auto)
  CommonItem:SetItem(View.Group_BuyItem.Group_Middle.Group_Item1, item1)
  CommonItem:SetItem(View.Group_BuyItem.Group_Middle.Group_Item2, item2)
  View.Group_BuyItem.Group_Middle.Txt_Des:SetText(string.format(GetText(80610004), item1.num, item1.name, item2.num, item2.name))
  View.Group_BuyItem.Group_Middle.Txt_Have:SetText(string.format(GetText(80600521), PlayerData:GetGoodsById(item1.id).num))
  View.Group_BuyItem.Group_Middle.Txt_Have:SetActive(true)
  View.Group_BuyItem.self:SetActive(true)
end

function Controller.ClearShopBuyTempData()
  DataModel.singlePrice = nil
  DataModel.shopBuyNum = nil
  DataModel.maxCanBuy = nil
  DataModel.HDItemID = nil
  DataModel.ConfirmType = nil
  DataModel.CommodityId = nil
  DataModel.StoreID = nil
end

function Controller.RefreshShopBuyShow()
  View.Group_Exchange.Group_Exchange.Group_Item1.Txt_Num:SetText(math.floor(DataModel.shopBuyNum * DataModel.singlePrice))
  View.Group_Exchange.Group_Exchange.Group_ExchangeItem.Txt_Num:SetText(math.floor(DataModel.shopBuyNum * DataModel.buyValue))
  Controller.RefreshShopBuyTips()
end

function Controller.ShowExchangeShop(currencyData)
  if currencyData == 11400005 then
    View.Group_Exchange.self:SetActive(false)
    CommonTips.OpenStoreBuy()
    return
  end
  if DataModel.CanExchangeNum <= 0 then
    CommonTips.OpenTips(80609999)
    return
  end
  if DataModel.NDPool == nil or DataModel.NDPool[DataModel.NDIndex] == nil then
    return
  end
  local data = DataModel.NDPool[DataModel.NDIndex]
  if data.data == nil then
    return
  end
  local priceCfg = PlayerData:GetFactoryData(data.data.commodityId, "CommodityFactory")
  if priceCfg == nil then
    return
  end
  tempNDName = priceCfg.commodityName
  DataModel.shopBuyNum = 1
  DataModel.buyValue = priceCfg.commodityItemList[1].num
  CommonItem:SetItem(View.Group_Exchange.Group_Exchange.Group_ExchangeItem, {
    id = currencyData,
    num = DataModel.shopBuyNum
  })
  DataModel.singlePrice = priceCfg.moneyList[1].moneyNum
  local haveNum = PlayerData:GetGoodsById(priceCfg.moneyList[1].moneyID).num
  local storeCfg = PlayerData:GetFactoryData(data.data.storeId)
  
  local function findStoreIndex(shopList, shopId)
    for k, v in ipairs(shopList) do
      if v.id == shopId then
        return k
      end
    end
    return nil
  end
  
  if haveNum >= DataModel.singlePrice then
    DataModel.HDItemID = priceCfg.moneyList[1].moneyID
    DataModel.ConfirmType = "ExchangeHD"
    DataModel.CommodityId = data.data.commodityId
    DataModel.StoreID = data.data.storeId
    DataModel.StoreIndex = findStoreIndex(storeCfg.shopList, data.data.commodityId)
    CommonItem:SetItem(View.Group_Exchange.Group_Exchange.Group_Item1, {
      id = priceCfg.moneyList[1].moneyID,
      num = DataModel.singlePrice
    })
  else
    priceCfg = PlayerData:GetFactoryData(data.data.commodityId1, "CommodityFactory")
    tempNDName = priceCfg.commodityName
    DataModel.singlePrice = priceCfg.moneyList[1].moneyNum
    haveNum = PlayerData:GetGoodsById(priceCfg.moneyList[1].moneyID).num
    if haveNum < DataModel.singlePrice then
      CommonTips.OpenTips(80600488)
      return
    end
    CommonItem:SetItem(View.Group_Exchange.Group_Exchange.Group_Item1, {
      id = priceCfg.moneyList[1].moneyID,
      num = DataModel.singlePrice
    })
    DataModel.ConfirmType = "ExchangeHS"
    DataModel.CommodityId = data.data.commodityId1
    DataModel.StoreID = data.data.storeId
    DataModel.StoreIndex = findStoreIndex(storeCfg.shopList, data.data.commodityId1)
  end
  View.Group_Exchange:SetActive(true)
  DataModel.maxCanBuy = math.floor(haveNum / DataModel.singlePrice)
  DataModel.maxCanBuy = math.min(DataModel.CanExchangeNum, DataModel.maxCanBuy)
  View.Group_Exchange.Group_Num.Group_Slider.Slider_Value:SetMinAndMaxValue(1, DataModel.maxCanBuy, true)
  View.Group_Exchange.Group_Num.Group_Slider.Slider_Value:SetSliderValue(DataModel.shopBuyNum)
  Controller.RefreshShopBuyTips()
end

function Controller.ShowExchangeShop_OldChange(cId)
  local priceCfg = PlayerData:GetFactoryData(cId, "CommodityFactory")
  local data = DataModel.NDPool[DataModel.NDIndex]
  tempNDName = priceCfg.commodityName
  DataModel.shopBuyNum = 1
  DataModel.buyValue = priceCfg.commodityItemList[1].num
  DataModel.singlePrice = priceCfg.moneyList[1].moneyNum
  CommonItem:SetItem(View.Group_Exchange.Group_Exchange.Group_ExchangeItem, {
    id = priceCfg.commodityItemList[1].id,
    num = DataModel.buyValue
  })
  CommonItem:SetItem(View.Group_Exchange.Group_Exchange.Group_Item1, {
    id = priceCfg.moneyList[1].moneyID,
    num = DataModel.singlePrice
  })
  DataModel.ConfirmType = "ExchangeOld"
  DataModel.CommodityId = cId
  DataModel.StoreID = data.data.oldCoinStoreId
  DataModel.StoreIndex = 1
  DataModel.costOldId = priceCfg.moneyList[1].moneyID
  local haveNum = PlayerData:GetGoodsById(priceCfg.moneyList[1].moneyID).num
  View.Group_Exchange:SetActive(true)
  DataModel.maxCanBuy = math.floor(haveNum / DataModel.singlePrice)
  View.Group_Exchange.Group_Num.Group_Slider.Slider_Value:SetMinAndMaxValue(1, DataModel.maxCanBuy, true)
  View.Group_Exchange.Group_Num.Group_Slider.Slider_Value:SetSliderValue(DataModel.shopBuyNum)
  Controller.RefreshShopBuyTips()
end

function Controller.RefreshShopBuyTips()
  View.Group_Exchange.Txt_Dec:SetText(string.format(GetText(80609992), tempNDName, DataModel.shopBuyNum * DataModel.buyValue))
end

function Controller.ShowConfirm(_type)
  DataModel.ConfirmType = "Confirm"
  DataModel.PickType = _type
  local data = DataModel.NDPool[DataModel.NDIndex]
  local costList = _type == 1 and data.data.costList or data.data.costTenList
  local cost = costList[1]
  local costNum = cost.num
  local num = PlayerData:GetGoodsById(cost.id).num
  CommonItem:SetItem(View.Group_BuyItem.Group_Middle.Group_Item1, {
    id = cost.id,
    num = num
  })
  CommonItem:SetItem(View.Group_BuyItem.Group_Middle.Group_Item2, {
    id = cost.id,
    num = num - costNum
  })
  local name = PlayerData:GetFactoryData(cost.id).name
  View.Group_BuyItem.Group_Middle.Txt_Des:SetText(StringFormat(GetText(data.data.buyColorPath or 80600520), costNum, name))
  View.Group_BuyItem.Group_Middle.Txt_Have:SetActive(false)
  View.Group_BuyItem.self:SetActive(true)
end

function Controller:ClearView()
  if View.Group_ND.self.IsActive then
    for i = 1, 5 do
      local element = View.Group_ND.Group_BQ["Group_" .. i]
      if element ~= nil then
        element.self:SetActive(false)
      end
    end
  elseif View.Group_HomeStore.self.IsActive then
    View.Group_HomeStore.Group_FurnitureStore.ScrollGrid_List.grid.self:SetDataCount(0)
    View.Group_HomeStore.Group_Right.StaticGrid_BQ.grid.self:RefreshAllElement()
  end
end

function Controller:TimeRefresh()
  Net:SendProto("recruit.cap_info", function(json)
    PlayerData.ServerData.user_home_info.pool = json.pool
    local data = DataModel.pondInfo[DataModel.curSelectIdx]
    local id = data.id
    Controller:Init(false)
    local curSelectIdx = 1
    for k, v in pairs(DataModel.pondInfo) do
      if id == v.id then
        curSelectIdx = k
        break
      end
    end
    Controller:SelectPond(curSelectIdx)
  end)
end

function Controller:RefreshCoin()
  DataModel.InitCurrency()
  View.StaticGrid_Currency.grid.self:SetDataCount(#DataModel.CurrencyData)
  View.StaticGrid_Currency.grid.self:RefreshAllElement()
end

function Controller:SelectPond(idx, force)
  if not force and DataModel.curSelectIdx == idx then
    return
  end
  DataModel.curSelectIdx = idx
  local element = View.Group_ND.Group_BQ["Group_" .. idx]
  local data = DataModel.pondInfo[idx]
  if data == nil then
    return
  end
  local selectView
  if data.limit then
    selectView = element.Group_XS.Img_XZ
  else
    selectView = element.Group_CZ.Img_XZ
  end
  if DataModel.lastSelectView ~= nil then
    DataModel.lastSelectView.self:SetActive(false)
  end
  selectView.self:SetActive(true)
  DataModel.lastSelectView = selectView
  local imageInfo = data.ca.imageList[1]
  if imageInfo ~= nil then
    View.Group_ND.Drag_Center.Group_ND1.Img_ND:SetSprite(DataModel.GetSpritePath(data.ca, imageInfo.image))
    View.Group_ND.Drag_Center.Group_ND1.Img_ND:SetAnchoredPosition(Vector2(imageInfo.x, imageInfo.y))
    View.Group_ND.Drag_Center.Group_ND1.Img_ND:SetNativeSize()
  end
  View.Group_ND.Group_Pay.Group_Ten.Img_Ten.self:SetActive(not data.limit)
  View.Group_ND.Group_Pay.Group_Ten.Img_TenZhuti.self:SetActive(data.limit)
  View.Group_ZT.Group_TP.Img_Common:SetActive(not data.limit)
  View.Group_ZT.Group_TP.Img_Zhuti:SetActive(data.limit)
  View.Group_ND.Group_Tips.Group_Time.self:SetActive(data.limit)
  View.Group_ND.Group_Tips.Btn_Tips:SetActive(not data.limit)
  if data.limit then
    local month = string.sub(data.ca.endTime, 6, 7)
    local day = string.sub(data.ca.endTime, 9, 10)
    local hour = string.sub(data.ca.endTime, 12, 13)
    local min = string.sub(data.ca.endTime, 15, 16)
    View.Group_ND.Group_Tips.Group_Time.Txt_FinishTime:SetText(string.format(GetText(80600447), month, day, hour, min))
  end
  View.Group_ZT.Txt_Name:SetText(data.ca.pictureName)
  local temp = data.ca.costList[1]
  local itemCA = PlayerData:GetFactoryData(temp.id, "ItemFactory")
  View.Group_ND.Group_Pay.Group_One.Img_Item:SetSprite(itemCA.buyPath or itemCA.iconPath)
  View.Group_ND.Group_Pay.Group_One.Txt_Num:SetText(string.format(GetText(80600407), temp.num))
  View.Group_ND.Group_Pay.Group_One.Img_OneNot.self:SetActive(data.totalRemainCount == 0)
  View.Group_ND.Group_Pay.Group_One.Btn_1:SetActive(data.totalRemainCount ~= 0)
  View.Group_ND.Group_Pay.Group_One1.Img_Item:SetSprite(itemCA.buyPath or itemCA.iconPath)
  View.Group_ND.Group_Pay.Group_One1.Txt_Num:SetText(string.format(GetText(80600407), temp.num))
  View.Group_ND.Group_Pay.Group_One1.Img_OneNot.self:SetActive(data.totalRemainCount == 0)
  View.Group_ND.Group_Pay.Group_One1.Btn_1:SetActive(data.totalRemainCount ~= 0)
  temp = data.ca.costTenList[1]
  itemCA = PlayerData:GetFactoryData(temp.id, "ItemFactory")
  View.Group_ND.Group_Pay.Group_Ten.Img_Item:SetSprite(itemCA.buyPath or itemCA.iconPath)
  View.Group_ND.Group_Pay.Group_Ten.Txt_Num:SetText(string.format(GetText(80600407), temp.num))
  local count = #data.capsuleList
  Controller:RefreshPickShow()
end

function Controller:ReadyPick()
  DataModel.isSkipDone = false
  View.Group_Model.Btn_Skip:SetActive(false)
  local allLight = CS.UnityEngine.GameObject.FindObjectsOfType(typeof(CS.UnityEngine.Light))
  for i = 0, allLight.Length - 1 do
    local layerInt = CS.UnityEngine.LayerMask.NameToLayer("Box")
    if allLight[i].gameObject.layer ~= layerInt and allLight[i].gameObject.activeInHierarchy and allLight[i] ~= nil and allLight[i].cullingMask ~= nil then
      allLight[i].cullingMask = allLight[i].cullingMask & ~(1 << layerInt)
    end
  end
  View.Group_Model.self:SetActive(true)
  DataModel.NDModel.transform:SetParent(View.Group_Model.self.transform)
  local model_ani = DataModel.NDModel.transform:GetComponent(typeof(CS.UnityEngine.Animator))
  model_ani:Play("play")
  local balls = DataModel.NDModel.transform:Find("Balls")
  if balls then
    local ani = balls.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
    if ani and not ani:IsNull() then
      ani:Play("play")
    end
  end
  DataModel.pickStatus = "wait"
  DataModel.NDAnimeTime = DataModel.NDAnimeTimeConfig
end

function Controller:GetQuality(rewardlist)
  local qualityTable = {
    Blue = 0,
    Purple = 1,
    Yellow = 2,
    Golden = 3
  }
  local quality = 0
  for i, v in pairs(rewardlist) do
    local q = qualityTable[v.quality] or 0
    if quality < q then
      quality = q
    end
  end
  return quality
end

function Controller:SetQuality(quality)
  local egg = {
    [0] = DataModel.NDModel.transform:Find("Guadian/Ball/M_Monopoly_Ball_02_n"),
    [1] = DataModel.NDModel.transform:Find("Guadian/Ball/M_Monopoly_Ball_02_sr"),
    [2] = DataModel.NDModel.transform:Find("Guadian/Ball/M_Monopoly_Ball_02_ssr"),
    [3] = DataModel.NDModel.transform:Find("Guadian/Ball/M_Monopoly_Ball_02_ur")
  }
  local node
  for i, v in pairs(egg) do
    local isQuality = i == quality
    local rewardEffect = v:Find("reward")
    if rewardEffect then
      rewardEffect.gameObject:SetActive(false)
    end
    rewardEffect = v:Find("show")
    if rewardEffect then
      rewardEffect.gameObject:SetActive(false)
    end
    v.gameObject:SetActive(isQuality)
    if isQuality == true then
      node = v
    end
  end
  DataModel.QualityNode = node
end

function Controller:SetEffectQuality(quality)
  local egg = {
    [0] = DataModel.NDModel.transform:Find("Effect/n"),
    [1] = DataModel.NDModel.transform:Find("Effect/sr"),
    [2] = DataModel.NDModel.transform:Find("Effect/ssr"),
    [3] = DataModel.NDModel.transform:Find("Effect/ur")
  }
  local node
  for i, v in pairs(egg) do
    local isQuality = i == quality
    if v then
      v.gameObject:SetActive(false)
    end
    if isQuality == true then
      node = v
    end
  end
  DataModel.QualityOutEffect = node
end

function Controller:SkipAnime()
  if DataModel.isSkipDone == true then
    return
  end
  DataModel.isSkipDone = true
  if DataModel.pickSound ~= nil then
    DataModel.pickSound:Stop()
    DataModel.pickSound = nil
  end
  local model_ani = DataModel.NDModel:GetComponent(typeof(CS.UnityEngine.Animator))
  model_ani:Play("end")
  local ani = Controller:PickAnime()
  if ani and not ani:IsNull() then
    ani:Play("end")
  end
  DataModel.pickStatus = "rewardopen"
  DataModel.NDAnimeTime = 0
end

function Controller:PickAnime()
  DataModel.NDAnimeTime = DataModel.EggUpTime
  DataModel.pickStatus = "eggwait"
  local ani = DataModel.QualityNode:GetComponent(typeof(CS.UnityEngine.Animator))
  if ani and not ani:IsNull() then
    ani:Play("roll")
  end
  return ani
end

function Controller:PickResult()
  if DataModel.QualityOutEffect then
    DataModel.QualityOutEffect.gameObject:SetActive(true)
    local effect = DataModel.QualityOutEffect:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    effect:Play()
  end
  DataModel.NDAnimeTime = DataModel.CapsuleOpenPer
end

function Controller:ShowOpenEffect()
  DataModel.NDAnimeTime = DataModel.EggOpenTime
  local rewardEffect = DataModel.QualityNode:Find("reward")
  if rewardEffect then
    rewardEffect.gameObject:SetActive(true)
  end
  local showEffect = DataModel.QualityNode:Find("show")
  if showEffect then
    showEffect.gameObject:SetActive(true)
  end
end

function Controller:RewardTip()
  Controller:ShowReward()
  Controller:RefreshCoin()
  Controller:RefreshPickShow()
end

function Controller:ShowReward()
  if DataModel.rewardShow == nil or #DataModel.rewardShow == 0 then
    return
  end
  local t = {}
  t.clientCustom = DataModel.rewardShow
  
  local function cb()
    View.Group_Model.self:SetActive(false)
  end
  
  if DataModel.pickSound ~= nil then
    DataModel.pickSound = nil
  end
  UIManager:Open("UI/Monopoly/UI/ShowItem/MonopolyShowItem", Json.encode({
    rewards = t,
    title = nil,
    ignoreCloseTime = true,
    cfgId = DataModel.NDPool[DataModel.NDIndex].data.id
  }), cb)
end

function Controller:RefreshPickShow()
  local data = DataModel.NDPool[DataModel.NDIndex]
  View.Group_ND.Group_Pay.Group_One.self:SetActive(data.data.totalRemainCount == nil or data.data.totalRemainCount >= 10)
  View.Group_ND.Group_Pay.Group_One1.self:SetActive(data.data.totalRemainCount ~= nil and data.data.totalRemainCount < 10)
  View.Group_ND.Group_Pay.Group_Ten.self:SetActive(data.data.totalRemainCount == nil or data.data.totalRemainCount >= 10)
  View.Group_ND.Group_Pay.Group_One1.Img_OneNot.self:SetActive(data.data.totalRemainCount == 0)
  View.Group_ND.Group_Pay.Group_One1.Btn_1:SetActive(data.data.totalRemainCount ~= 0)
end

function Controller.CheckNDEnough(_type)
  if DataModel.NDPool == nil or DataModel.NDPool[DataModel.NDIndex] == nil then
    return false
  end
  local data = DataModel.NDPool[DataModel.NDIndex]
  if data.data == nil then
    return false
  end
  local costList = _type == 1 and data.data.costList or data.data.costTenList
  if costList == nil or #costList == 0 then
    return false
  end
  if data.data.isLimitCapsuleNum and DataModel.canPickNum and _type > DataModel.canPickNum then
    CommonTips.OpenTips(80600363)
    return false
  end
  local cost = costList[1]
  local costNum = cost.num
  data.itemNum = data.itemNum or 0
  if 0 >= data.itemNum then
    CommonTips.OpenTips(80609993)
    return false
  end
  if _type > data.itemNum then
    CommonTips.OpenTips(80610003)
    return false
  end
  DataModel.NDItemID = cost.id
  local temp = PlayerData:GetGoodsById(cost.id)
  if temp then
    if costNum > temp.num then
      if data.data.commodityId == nil or data.data.commodityId == "" or 0 >= data.data.commodityId then
        CommonTips.OpenTips(80600488)
        return false
      end
      local need = costNum - temp.num
      local priceCfg = PlayerData:GetFactoryData(data.data.commodityId, "CommodityFactory")
      local singlePrice = priceCfg.moneyList[1].moneyNum
      local have = PlayerData:GetGoodsById(priceCfg.moneyList[1].moneyID).num
      local _name = ""
      local storeCfg = PlayerData:GetFactoryData(data.data.storeId)
      
      local function findStoreIndex(shopList, shopId)
        for k, v in ipairs(shopList) do
          if v.id == shopId then
            return k
          end
        end
        return nil
      end
      
      DataModel.HDItemID = priceCfg.moneyList[1].moneyID
      if singlePrice <= have then
        local canChangeCount = math.floor(have / singlePrice)
        local auto = need <= canChangeCount
        DataModel.AutoPickAfterBuy = auto
        canChangeCount = math.min(canChangeCount, need)
        _name = PlayerData:GetFactoryData(priceCfg.moneyList[1].moneyID).name
        Controller.ShowExchange({
          id = priceCfg.moneyList[1].moneyID,
          num = canChangeCount * singlePrice,
          name = _name
        }, {
          id = cost.id,
          num = canChangeCount,
          name = priceCfg.commodityName
        }, auto)
        DataModel.ConfirmType = "ExchangeHD"
        DataModel.NeedNum = canChangeCount
        DataModel.CommodityId = data.data.commodityId
        DataModel.StoreID = data.data.storeId
        DataModel.StoreIndex = findStoreIndex(storeCfg.shopList, data.data.commodityId)
        DataModel.CostMoneyNum = canChangeCount * singlePrice
        DataModel.PickType = _type
        return false
      else
        if data.data.commodityId1 == nil or data.data.commodityId1 == "" or 0 > data.data.commodityId1 then
          return false
        end
        priceCfg = PlayerData:GetFactoryData(data.data.commodityId1, "CommodityFactory")
        singlePrice = priceCfg.moneyList[1].moneyNum
        local needMoney = singlePrice * need
        _name = PlayerData:GetFactoryData(priceCfg.moneyList[1].moneyID).name
        Controller.ShowExchange({
          id = priceCfg.moneyList[1].moneyID,
          num = needMoney,
          name = _name
        }, {
          id = cost.id,
          num = need,
          name = priceCfg.commodityName
        }, true)
        DataModel.ConfirmType = "ExchangeHS"
        DataModel.NeedNum = need
        DataModel.CommodityId = data.data.commodityId1
        DataModel.StoreID = data.data.storeId
        DataModel.StoreIndex = findStoreIndex(storeCfg.shopList, data.data.commodityId1)
        DataModel.NeedBuyMoney = needMoney > PlayerData:GetGoodsById(priceCfg.moneyList[1].moneyID).num
        DataModel.AutoPickAfterBuy = not DataModel.NeedBuyMoney
        DataModel.CostMoneyNum = needMoney
        DataModel.PickType = _type
        return false
      end
    else
      return true
    end
  else
    return false
  end
end

function Controller.OnePick()
  if not Controller.CheckNDEnough(1) then
    return
  end
  Controller.ShowConfirm(1)
end

function Controller.TenPick()
  if not Controller.CheckNDEnough(10) then
    return
  end
  Controller.ShowConfirm(10)
end

function Controller.DoPick(_type)
  local function cb()
    Controller:ReadyPick()
    
    Controller:SetQuality(DataModel.quality)
    Controller:SetEffectQuality(DataModel.quality)
    View.Group_Model.Btn_Skip:SetActive(true)
    DataModel.pickStatus = "get"
    Controller.RefreshLimit()
  end
  
  Net:SendProto("recruit.do_caps", function(json)
    local items = {
      [DataModel.NDItemID] = _type
    }
    DataModel.quality = Controller:GetQuality(json.reward_display)
    DataModel.pickSound = DataModel:PlaySound(30006450)
    PlayerData:RefreshUseItems(items)
    DataModel.rewardShow = json.reward_display
    DataModel.NDPool[DataModel.NDIndex].pool = json.pool.capsule or json.pool
    PlayerData.SetSingleCapsuleData(DataModel.NDPool[DataModel.NDIndex].data.id, json.pool)
    local goodsNum = 0
    for m, n in pairs(DataModel.NDPool[DataModel.NDIndex].pool) do
      goodsNum = goodsNum + n
    end
    DataModel.NDPool[DataModel.NDIndex].itemNum = goodsNum
    if type(cb) == "function" then
      cb()
    end
  end, DataModel.NDPool[DataModel.NDIndex].data.id, _type)
end

return Controller
