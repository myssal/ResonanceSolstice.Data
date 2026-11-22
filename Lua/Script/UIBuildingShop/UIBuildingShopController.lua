local View = require("UIBuildingShop/UIBuildingShopView")
local DataModel = require("UIBuildingShop/UIBuildingShopDataModel")
local Controller = {}

function Controller:Init()
  DataModel.ShopIdToRecycle = {}
  DataModel.CanSaleList = {}
  DataModel.stationId = DataModel.initParams.stationId
  Controller:InitStore()
  Controller:RefreshStoreCoin()
  DataModel.curIndex = 0
  DataModel.curTradeType = 0
  Controller:ChooseTab(1, DataModel.TradeType.Buy)
end

function Controller:RefreshStoreCoin()
  View.Group_Store.Group_Resources.Group_GoldCoin.Txt_Num:SetText(PlayerData:GetGoodsById(11400001).num)
  if View.Group_Store.Group_Resources.Group_GoldCoin1 then
    View.Group_Store.Group_Resources.Group_GoldCoin1.Txt_Num:SetText(PlayerData:GetGoodsById(11400218).num)
  end
end

function Controller:ChooseTab(index, tradeType)
  local lastIndex = DataModel.curIndex
  local lastTradeType = DataModel.CurTradeType
  DataModel.curIndex = index
  DataModel.curTradeType = tradeType
  if lastTradeType ~= tradeType then
    if tradeType == DataModel.TradeType.Buy then
      DataModel.Now_List = DataModel.CanBuyList[index]
      DataModel.InitCanBuyList()
      DOTweenTools.DOLocalMoveXCallback(View.Group_Tab.Img_Selected.transform, -382.5, 0.25, function()
        View.Group_Tab.Btn_Buy.Group_On.self:SetActive(true)
        View.Group_Tab.Btn_Buy.Group_Off.self:SetActive(false)
        View.Group_Tab.Btn_Sell.Group_On.self:SetActive(false)
        View.Group_Tab.Btn_Sell.Group_Off.self:SetActive(true)
      end)
    else
      DataModel.InitCanSaleData()
      DOTweenTools.DOLocalMoveXCallback(View.Group_Tab.Img_Selected.transform, -83.5, 0.25, function()
        View.Group_Tab.Btn_Buy.Group_On.self:SetActive(false)
        View.Group_Tab.Btn_Buy.Group_Off.self:SetActive(true)
        View.Group_Tab.Btn_Sell.Group_On.self:SetActive(true)
        View.Group_Tab.Btn_Sell.Group_Off.self:SetActive(false)
      end)
    end
  end
  if tradeType == DataModel.TradeType.Buy then
    View.Group_Store.Group_Furniture.ScrollGrid_List.self:SetActive(true)
    View.Group_Store.Group_Furniture.Group_Nothing:SetActive(false)
    View.Group_Store.Group_Furniture.ScrollGrid_List.grid.self:SetDataCount(table.count(DataModel.Now_List.shopList))
    View.Group_Store.Group_Furniture.ScrollGrid_List.grid.self:RefreshAllElement()
    local isAutoRefresh = DataModel.Now_List.isAutoRefresh
    View.Group_Store.Group_Time.self:SetActive(isAutoRefresh)
    if isAutoRefresh then
      local time = storeFactory.refreshTimeList[1]
      local h = tonumber(string.sub(time.refreshTime, 1, 2))
      local m = tonumber(string.sub(time.refreshTime, 4, 5))
      local textId
      if storeFactory.refreshType == "Daily" then
        textId = 80600463
      elseif storeFactory.refreshType == "Weekly" then
        textId = 80600786
      elseif storeFactory.refreshType == "Monthly" then
        textId = 80600787
      end
      View.Group_Store.Group_Time.Txt_Time:SetText(string.format(GetText(textId), h, m))
    end
  else
    DataModel.Now_List = DataModel.CanSaleList[index]
    Controller:RefreshSaleScrollGrid()
    View.Group_Store.Group_Time.self:SetActive(false)
  end
  if lastIndex ~= index then
    View.Group_Store.Group_StoreTab.Img_BG.StaticGrid_.self:RefreshAllElement()
    View.self:PlayAnimOnce("Switch")
  end
end

function Controller:InitStore()
  DataModel.InitShopData()
  local buildCfg = PlayerData:GetFactoryData(DataModel.initParams.buildId)
  View.Group_Store.Group_StoreTab.Img_BG.StaticGrid_.self:SetDataCount(#buildCfg.StoreList)
  View.Group_Store.Group_StoreTab.Img_BG.StaticGrid_.self:RefreshAllElement()
end

function Controller:RefreshTabElement(element, elementIndex)
  element.Btn_Furniture:SetClickParam(elementIndex)
  element.Btn_Furniture.Group_On.self:SetActive(elementIndex == DataModel.curIndex)
  local shopId = DataModel.CanBuyList[elementIndex].shopId
  local storeConfig = PlayerData:GetFactoryData(shopId, "StoreFactory")
  element.Btn_Furniture.Group_On.Group_.Txt_Name:SetText(storeConfig.storeName)
  element.Btn_Furniture.Group_On.Group_.Img_Icon:SetSprite(storeConfig.pngSelect)
  element.Btn_Furniture.Group_Off.Txt_Name:SetText(storeConfig.storeName)
  element.Btn_Furniture.Group_Off.Img_Icon:SetSprite(storeConfig.pngNotSelect)
  local buildCfg = PlayerData:GetFactoryData(DataModel.initParams.buildId)
  element.Btn_Furniture.Group_On.Img_BG:SetSprite(buildCfg.selectPath)
end

function Controller:ClickTabElement(btn, str)
  local idx = tonumber(str)
  Controller:ChooseTab(idx, DataModel.curTradeType)
end

function Controller:ClickTradeType(type)
  Controller:ChooseTab(DataModel.curIndex, type)
end

function Controller:RefreshElement(element, elementIndex)
  if DataModel.curTradeType == DataModel.TradeType.Buy then
    Controller:RefreshBuyElement(element, elementIndex)
  else
    Controller:RefreshSaleElement(element, elementIndex)
  end
end

function Controller:ClickElement(btn, str)
  if DataModel.curTradeType == DataModel.TradeType.Buy then
    Controller:ClickBuyElement(btn, str)
  else
    Controller:ClickSaleElement(btn, str)
  end
end

function Controller:RefreshBuyElement(element, elementIndex)
  local idx = tonumber(elementIndex)
  element.Btn_1:SetClickParam(idx)
  local row = DataModel.Now_List.shopList[idx]
  local data = PlayerData:GetFactoryData(row.id)
  element.Txt_Num:SetActive(false)
  element.Txt_Name:SetText(data.commodityName)
  element.Img_Mask.Img_Item:SetSprite(data.commodityView)
  local qualityInt = data.qualityInt
  element.Img_Quality:SetSprite(UIConfig.HomeStoreQuality[qualityInt + 1])
  if data.purchase then
    element.Group_SY.self:SetActive(true)
    local textId = 0
    if data.limitBuyType == "Forever" then
      textId = 80600430
    elseif data.limitBuyType == "Daily" then
      textId = 80600798
    elseif data.limitBuyType == "Weekly" then
      textId = 80600800
    elseif data.limitBuyType == "Monthly" then
      textId = 80600801
    end
    local StoreDataModel = require("UIStore/UIStoreDataModel")
    local maxNum = StoreDataModel:GetPurchaseNum(data)
    element.Group_SY.Txt_Num:SetText(string.format(GetText(textId), row.residue, maxNum))
    if row.residue == 0 then
      element.Img_ShouWan.self:SetActive(true)
    else
      element.Img_ShouWan.self:SetActive(false)
    end
  else
    element.Group_SY.self:SetActive(false)
    element.Img_ShouWan.self:SetActive(false)
  end
  local money = data.moneyList[1]
  if money then
    element.Group_Money.self:SetActive(true)
    local left_money = PlayerData:GetFactoryData(tonumber(data.moneyList[1].moneyID))
    element.Group_Money.Img_Money:SetSprite(left_money.buyPath)
    element.Group_Money.Txt_MoneyNum:SetText(data.moneyList[1].moneyNum)
  else
    element.Group_Money.self:SetActive(false)
  end
  if data.moneyList[2] then
    element.Group_Money2.self:SetActive(true)
    local left_money = PlayerData:GetFactoryData(tonumber(data.moneyList[2].moneyID))
    element.Group_Money2.Img_Money:SetSprite(left_money.buyPath)
    element.Group_Money2.Txt_MoneyNum:SetText(data.moneyList[2].moneyNum)
  else
    element.Group_Money2.self:SetActive(false)
  end
  element.Img_Time.self:SetActive(false)
  local item = data.commodityItemList[1]
  if item then
    local itemCA = PlayerData:GetFactoryData(item.id)
    element.Group_Attribute.Group_AttributePlant.self:SetActive(0 < itemCA.plantScores)
    element.Group_Attribute.Group_AttributePlant.Txt_Scores:SetText(itemCA.plantScores)
    element.Group_Attribute.Group_AttributeFish.self:SetActive(0 < itemCA.fishScores)
    element.Group_Attribute.Group_AttributeFish.Txt_Scores:SetText(itemCA.fishScores)
    element.Group_Attribute.Group_AttributePet.self:SetActive(0 < itemCA.petScores)
    element.Group_Attribute.Group_AttributePet.Txt_Scores:SetText(itemCA.petScores)
    element.Group_Attribute.Group_AttributeAppetite.self:SetActive(0 < itemCA.foodScores)
    element.Group_Attribute.Group_AttributeAppetite.Txt_Scores:SetText(itemCA.foodScores)
    element.Group_Attribute.Group_AttributeComfort.self:SetActive(0 < itemCA.comfort)
    element.Group_Attribute.Group_AttributeComfort.Txt_Scores:SetText(itemCA.comfort)
  end
  element.Img_AllLimit.self:SetActive(false)
  element.Img_AllLimit.Group_1.Txt_Rep:SetActive(false)
  element.Img_AllLimit.Group_1.Txt_Grade:SetActive(false)
  element.Img_AllLimit.Group_1.Txt_Furniture:SetActive(false)
  if row.buyLimit then
    if 0 < row.limitRep then
      element.Img_AllLimit.self:SetActive(true)
      element.Img_AllLimit.Group_1.Txt_Rep:SetActive(true)
      element.Img_AllLimit.Group_1.Txt_Rep:SetText(string.format(GetText(80601109), row.limitRep))
    end
    if 0 < row.limitGrade then
      element.Img_AllLimit.self:SetActive(true)
      element.Img_AllLimit.Group_1.Txt_Grade:SetActive(true)
      element.Img_AllLimit.Group_1.Txt_Grade:SetText(string.format(GetText(80601022), row.limitGrade))
    end
  end
  local buildCfg = PlayerData:GetFactoryData(DataModel.initParams.buildId)
  element.Img_BG:SetSprite(buildCfg.bottomPath)
  element.Img_BG.Img_:SetSprite(buildCfg.commodityPath)
  if row.bindFurniture and not row.furUnLock then
    element.Img_AllLimit.self:SetActive(true)
    element.Img_AllLimit.Group_1.Txt_Furniture:SetActive(true)
    local furCfg = PlayerData:GetFactoryData(data.furnitureCondition)
    element.Img_AllLimit.Group_1.Txt_Furniture:SetText(string.format(GetText(80608150), furCfg.name, furCfg.Level))
  end
end

function Controller:ClickBuyElement(btn, str)
  local row = DataModel.Now_List.shopList[tonumber(str)]
  if row.residue == 0 then
    CommonTips.OpenTips(80600077)
    return
  end
  if row.buyLimit then
    CommonTips.OpenTips(80601023)
    return
  end
  if row.bindFurniture and not row.furUnLock then
    return
  end
  row.commoditData = PlayerData:GetFactoryData(row.id)
  row.index = tonumber(str) - 1
  local shopId = DataModel.Now_List.shopId
  row.shopid = shopId
  row.name = row.commoditData.commodityName
  row.image = row.commoditData.commodityView
  row.qualityInt = row.commoditData.qualityInt + 1
  CommonTips.OpenBuyTips(row, function(cnt)
    Controller:RefreshStoreCoin()
    DataModel.Now_List.server = PlayerData.ServerData.shops[tostring(shopId)]
    DataModel.InitCanBuyList()
    View.Group_Store.Group_Furniture.ScrollGrid_List.grid.self:RefreshAllElement()
    DataModel.CanSaleList = {}
  end)
end

function Controller:RefreshSaleElement(element, elementIndex)
  local info = DataModel.Now_List.commodityList[elementIndex]
  local commodityCA = PlayerData:GetFactoryData(info.commodityId, "CommodityFactory")
  element.Btn_1:SetClickParam(elementIndex)
  local moneyList = commodityCA.recycleMoneyList
  element.Txt_Num:SetActive(true)
  element.Txt_Num:SetText(info.num)
  element.Group_Money.Txt_MoneyNum:SetText(moneyList[1].moneyNum)
  element.Group_Money2:SetActive(moneyList[2])
  if moneyList[2] then
    element.Group_Money2.Txt_MoneyNum:SetText(moneyList[2].moneyNum)
  end
  element.Img_Mask.Img_Item:SetSprite(commodityCA.commodityView)
  element.Txt_Name:SetText(commodityCA.commodityName)
  element.Img_AllLimit.self:SetActive(false)
  element.Group_SY.self:SetActive(false)
  element.Img_ShouWan.self:SetActive(false)
  local itemCA = PlayerData:GetFactoryData(info.id)
  element.Group_Attribute.Group_AttributePlant.self:SetActive(itemCA.plantScores > 0)
  element.Group_Attribute.Group_AttributePlant.Txt_Scores:SetText(itemCA.plantScores)
  element.Group_Attribute.Group_AttributeFish.self:SetActive(0 < itemCA.fishScores)
  element.Group_Attribute.Group_AttributeFish.Txt_Scores:SetText(itemCA.fishScores)
  element.Group_Attribute.Group_AttributePet.self:SetActive(0 < itemCA.petScores)
  element.Group_Attribute.Group_AttributePet.Txt_Scores:SetText(itemCA.petScores)
  element.Group_Attribute.Group_AttributeAppetite.self:SetActive(0 < itemCA.foodScores)
  element.Group_Attribute.Group_AttributeAppetite.Txt_Scores:SetText(itemCA.foodScores)
  element.Group_Attribute.Group_AttributeComfort.self:SetActive(0 < itemCA.comfort)
  element.Group_Attribute.Group_AttributeComfort.Txt_Scores:SetText(itemCA.comfort)
end

function Controller:ClickSaleElement(btn, str)
  local idx = tonumber(str)
  local info = DataModel.Now_List.commodityList[idx]
  info.shopId = DataModel.Now_List.shopId
  CommonTips.OpenShopSaleTips(info, function()
    Controller:RefreshStoreCoin()
    DataModel.RefreshSpecialTypeData(DataModel.curIndex)
    DataModel.Now_List = DataModel.CanSaleList[DataModel.curIndex]
    Controller:RefreshSaleScrollGrid()
  end)
end

function Controller:RefreshSaleScrollGrid()
  local count = table.count(DataModel.Now_List.commodityList)
  local showSale = 0 < count
  View.Group_Store.Group_Furniture.ScrollGrid_List.self:SetActive(showSale)
  View.Group_Store.Group_Furniture.Group_Nothing.self:SetActive(not showSale)
  if showSale then
    View.Group_Store.Group_Furniture.ScrollGrid_List.grid.self:SetDataCount(count)
    View.Group_Store.Group_Furniture.ScrollGrid_List.grid.self:RefreshAllElement()
  end
end

function Controller:Return()
  View.self:CloseUI()
  View.self:Confirm()
end

function Controller:Home()
  CommonCoachData.GoHome()
end

function Controller:Help()
  local data = {helpId = 80301238}
  UIManager:Open("UI/Common/Group_Help", Json.encode(data))
end

return Controller
