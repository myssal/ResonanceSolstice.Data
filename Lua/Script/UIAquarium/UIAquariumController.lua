local View = require("UIAquarium/UIAquariumView")
local DataModel = require("UIAquarium/UIAquariumDataModel")
local NPCDialog = require("Common/NPCDialog")
local Controller = {}

function Controller:Init()
  DataModel.InitData()
  local stationCfg = PlayerData:GetFactoryData(DataModel.StationId)
  View.Group_Main.Group_NpcInfo.Group_Station.Txt_Station:SetText(stationCfg.name)
  local buildingCfg = PlayerData:GetFactoryData(DataModel.BuildingId)
  View.Group_Main.Group_NpcInfo.Txt_Title:SetText(buildingCfg.name)
  View.Group_Main.Group_NpcInfo.Img_Icon:SetSprite(buildingCfg.buildingIconPath)
  NPCDialog.SetNPC(View.Group_NPCPos.Group_NPC, DataModel.NpcId)
  Controller:ShowNPCTalk(DataModel.NPCDialogEnum.enterText)
  View.Group_Store:SetActive(false)
  View.Group_Main:SetActive(true)
  Controller:RefreshResources()
  Controller.BatchRefresh()
end

function Controller:ReturnToMain()
  View.self:PlayAnim("Main")
  View.Group_Main.self:SetActive(true)
  View.Group_Store.self:SetActive(false)
end

function Controller:ClickTrade()
  Net:SendProto("shop.info", function(json)
    View.self:PlayAnim("Store")
    Controller:InitTradePanel()
    DataModel.InitShopData()
    DataModel.InitServerBuyData()
    DataModel.InitSellData()
    View.Group_Store:SetActive(true)
    Controller:SelectTab(DataModel.TradeType.Buy, true)
  end)
end

function Controller:InitTradePanel()
  local stationCfg = PlayerData:GetFactoryData(DataModel.StationId)
  View.Group_Store.Group_NpcInfoL.Group_Station.Txt_Station:SetText(stationCfg.name)
  local buildingCfg = PlayerData:GetFactoryData(DataModel.BuildingId)
  View.Group_Store.Group_NpcInfoL.Txt_Title:SetText(buildingCfg.name)
  View.Group_Store.Group_NpcInfoL.Img_Icon:SetSprite(buildingCfg.buildingIconPath)
end

function Controller:RefreshResources()
  View.Group_Store.Group_Resources.Group_GoldCoin.Txt_Num:SetText(PlayerData:GetUserInfo().gold)
end

function Controller:SetBuyStoreElement(element, elementIndex)
  local row = DataModel.BuyCount[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Txt_Name:SetText(cfg.commodityName)
    element.Img_Mask.Img_Item:SetSprite(cfg.commodityView)
    local moneyCost = cfg.moneyList[1].moneyNum
    element.Group_Money.Txt_MoneyNum:SetText(moneyCost)
    element.Img_Picked:SetActive(DataModel.batchList[elementIndex])
    local purchase = cfg.purchase
    if purchase == true then
      local StoreDataModel = require("UIStore/UIStoreDataModel")
      local maxNum = StoreDataModel:GetPurchaseNum(cfg)
      row.residue = maxNum - (DataModel.GetItemBuyCount(elementIndex) or 0)
      if row.residue < 0 then
        row.residue = 0
      end
      if row.residue == 0 then
        element.Img_ShouWan.self:SetActive(true)
      else
        element.Img_ShouWan.self:SetActive(false)
      end
    else
      row.residue = 100
      element.Img_ShouWan.self:SetActive(false)
    end
    local item = cfg.commodityItemList[1]
    if item then
      local itemCA = PlayerData:GetFactoryData(item.id)
      if itemCA.plantScores then
        element.Group_Attribute.Group_AttributePlant.self:SetActive(0 < itemCA.plantScores)
        element.Group_Attribute.Group_AttributePlant.Txt_Scores:SetText(itemCA.plantScores)
      else
        element.Group_Attribute.Group_AttributePlant.self:SetActive(false)
      end
      if itemCA.fishScores then
        element.Group_Attribute.Group_AttributeFish.self:SetActive(0 < itemCA.fishScores)
        element.Group_Attribute.Group_AttributeFish.Txt_Scores:SetText(itemCA.fishScores)
      else
        element.Group_Attribute.Group_AttributeFish.self:SetActive(false)
      end
      if itemCA.petScores then
        element.Group_Attribute.Group_AttributePet.self:SetActive(0 < itemCA.petScores)
        element.Group_Attribute.Group_AttributePet.Txt_Scores:SetText(itemCA.petScores)
      else
        element.Group_Attribute.Group_AttributePet.self:SetActive(false)
      end
      if itemCA.foodScores then
        element.Group_Attribute.Group_AttributeAppetite.self:SetActive(0 < itemCA.foodScores)
        element.Group_Attribute.Group_AttributeAppetite.Txt_Scores:SetText(itemCA.foodScores)
      else
        element.Group_Attribute.Group_AttributeAppetite.self:SetActive(false)
      end
      if itemCA.petFoodNum then
        element.Group_Attribute.Group_AttributeAppetite.self:SetActive(0 < itemCA.petFoodNum)
        element.Group_Attribute.Group_AttributeAppetite.Txt_Scores:SetText(itemCA.petFoodNum)
      else
        element.Group_Attribute.Group_AttributeAppetite.self:SetActive(false)
      end
      if itemCA.comfort then
        element.Group_Attribute.Group_AttributeComfort.self:SetActive(0 < itemCA.comfort)
        element.Group_Attribute.Group_AttributeComfort.Txt_Scores:SetText(itemCA.comfort)
      else
        element.Group_Attribute.Group_AttributeComfort.self:SetActive(false)
      end
      if itemCA.dayLove then
        element.Group_Attribute.Group_AttributeLove.self:SetActive(0 < itemCA.dayLove)
        element.Group_Attribute.Group_AttributeLove.Txt_Scores:SetText(string.format(GetText(80601096), itemCA.dayLove))
      else
        element.Group_Attribute.Group_AttributeLove.self:SetActive(false)
      end
      if itemCA.addLove then
        element.Group_Attribute.Group_AttributeLove.self:SetActive(0 < itemCA.addLove)
        element.Group_Attribute.Group_AttributeLove.Txt_Scores:SetText(itemCA.addLove)
      else
        element.Group_Attribute.Group_AttributeLove.self:SetActive(false)
      end
    end
    element.Btn_1:SetClickParam(elementIndex)
  end
end

function Controller:RefreshBuyStoreList()
  View.Group_Store.Group_Buy:SetActive(true)
  View.Group_Store.Group_Sell:SetActive(false)
  local count = table.count(DataModel.BuyCount)
  View.Group_Store.Group_Buy.Group_General.ScrollGrid_List.grid.self:SetDataCount(count)
  View.Group_Store.Group_Buy.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
end

function Controller:SetSellStoreElement(element, elementIndex)
  local row = DataModel.SellCount[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.commodityId)
    element.Txt_Name:SetText(cfg.commodityName)
    element.Img_Mask.Img_Item:SetSprite(cfg.commodityView)
    local moneyGet = cfg.recycleMoneyList[1].moneyNum
    element.Group_Money.Txt_MoneyNum:SetText(moneyGet)
    element.Group_SY.Img_1.Txt_Num:SetText(row.num)
    element.Img_Picked:SetActive(DataModel.batchList[elementIndex])
    local item = cfg.recycleItem
    if item then
      local itemCA = PlayerData:GetFactoryData(item)
      if itemCA.plantScores then
        element.Group_Attribute.Group_AttributePlant.self:SetActive(itemCA.plantScores > 0)
        element.Group_Attribute.Group_AttributePlant.Txt_Scores:SetText(itemCA.plantScores)
      else
        element.Group_Attribute.Group_AttributePlant.self:SetActive(false)
      end
      if itemCA.fishScores then
        element.Group_Attribute.Group_AttributeFish.self:SetActive(0 < itemCA.fishScores)
        element.Group_Attribute.Group_AttributeFish.Txt_Scores:SetText(itemCA.fishScores)
      else
        element.Group_Attribute.Group_AttributeFish.self:SetActive(false)
      end
      if itemCA.petScores then
        element.Group_Attribute.Group_AttributePet.self:SetActive(0 < itemCA.petScores)
        element.Group_Attribute.Group_AttributePet.Txt_Scores:SetText(itemCA.petScores)
      else
        element.Group_Attribute.Group_AttributePet.self:SetActive(false)
      end
      if itemCA.foodScores then
        element.Group_Attribute.Group_AttributeAppetite.self:SetActive(0 < itemCA.foodScores)
        element.Group_Attribute.Group_AttributeAppetite.Txt_Scores:SetText(itemCA.foodScores)
      else
        element.Group_Attribute.Group_AttributeAppetite.self:SetActive(false)
      end
      if itemCA.petFoodNum then
        element.Group_Attribute.Group_AttributeAppetite.self:SetActive(0 < itemCA.petFoodNum)
        element.Group_Attribute.Group_AttributeAppetite.Txt_Scores:SetText(itemCA.petFoodNum)
      else
        element.Group_Attribute.Group_AttributeAppetite.self:SetActive(false)
      end
      if itemCA.comfort then
        element.Group_Attribute.Group_AttributeComfort.self:SetActive(0 < itemCA.comfort)
        element.Group_Attribute.Group_AttributeComfort.Txt_Scores:SetText(itemCA.comfort)
      else
        element.Group_Attribute.Group_AttributeComfort.self:SetActive(false)
      end
      if itemCA.dayLove then
        element.Group_Attribute.Group_AttributeLove.self:SetActive(0 < itemCA.dayLove)
        element.Group_Attribute.Group_AttributeLove.Txt_Scores:SetText(string.format(GetText(80601096), itemCA.dayLove))
      else
        element.Group_Attribute.Group_AttributeLove.self:SetActive(false)
      end
      if itemCA.addLove then
        element.Group_Attribute.Group_AttributeLove.self:SetActive(0 < itemCA.addLove)
        element.Group_Attribute.Group_AttributeLove.Txt_Scores:SetText(itemCA.addLove)
      else
        element.Group_Attribute.Group_AttributeLove.self:SetActive(false)
      end
    end
    element.Btn_1:SetClickParam(elementIndex)
  end
end

function Controller:RefreshSellStoreList()
  View.Group_Store.Group_Buy:SetActive(false)
  View.Group_Store.Group_Sell:SetActive(true)
  local count = table.count(DataModel.SellCount)
  View.Group_Store.Group_Sell.Group_General.ScrollGrid_List.grid.self:SetDataCount(count)
  View.Group_Store.Group_Sell.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
end

function Controller:SelectTab(tradeType, isInit)
  if not isInit and DataModel.CurTradeType == tradeType then
    return
  end
  View.Group_Main.self:SetActive(false)
  View.Group_Store.self:SetActive(true)
  DataModel.CurTradeType = tradeType
  if DataModel.CurTradeType == DataModel.TradeType.Buy then
    DOTweenTools.DOLocalMoveXCallback(View.Group_Store.Group_Tab.Img_Selected.transform, -382.5, 0.25, function()
      View.Group_Store.Group_Tab.Btn_Buy.Group_On:SetActive(DataModel.CurTradeType == DataModel.TradeType.Buy)
      View.Group_Store.Group_Tab.Btn_Sell.Group_On:SetActive(DataModel.CurTradeType == DataModel.TradeType.Sell)
      Controller.BatchRefresh()
      Controller:RefreshBuyStoreList()
      View.Group_Store.Group_Buy.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
      Controller:ShowNPCTalk(DataModel.NPCDialogEnum.fishStoreText)
    end)
  else
    DOTweenTools.DOLocalMoveXCallback(View.Group_Store.Group_Tab.Img_Selected.transform, -83.5, 0.25, function()
      View.Group_Store.Group_Tab.Btn_Buy.Group_On:SetActive(DataModel.CurTradeType == DataModel.TradeType.Buy)
      View.Group_Store.Group_Tab.Btn_Sell.Group_On:SetActive(DataModel.CurTradeType == DataModel.TradeType.Sell)
      Controller.BatchRefresh()
      Controller:RefreshSellStoreList()
      View.Group_Store.Group_Sell.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
      Controller:ShowNPCTalk(DataModel.NPCDialogEnum.fishSellText)
    end)
  end
end

function Controller:GeneralBuyClickItem(str)
  local idx = tonumber(str)
  local row = DataModel.BuyCount[idx]
  local cfg = PlayerData:GetFactoryData(row.id)
  local StoreDataModel = require("UIStore/UIStoreDataModel")
  local maxNum = StoreDataModel:GetPurchaseNum(cfg)
  local remain = maxNum - (DataModel.GetItemBuyCount(idx) or 0)
  if remain == 0 then
    CommonTips.OpenTips(80600077)
    return
  end
  row.commoditData = cfg
  row.index = idx - 1
  row.shopid = tostring(DataModel.BuyConfigId)
  row.name = cfg.commodityName
  row.image = cfg.commodityView
  row.qualityInt = cfg.qualityInt + 1
  CommonTips.OpenBuyTips(row, function(json)
    DataModel.InitServerBuyData()
    Controller:RefreshBuyStoreList()
    DataModel.InitSellData()
    Controller:RefreshResources()
  end)
end

function Controller:GeneralSellClickItem(str)
  local idx = tonumber(str)
  local row = DataModel.SellCount[idx]
  row.shopId = DataModel.SellConfigId
  CommonTips.OpenShopSaleTips(row, function()
    DataModel.InitSellData()
    Controller:RefreshSellStoreList()
    Controller:RefreshResources()
  end)
end

function Controller:ShowNPCTalk(dialogEnum)
  local npcConfig = PlayerData:GetFactoryData(DataModel.NpcId, "NPCFactory")
  local textTable = npcConfig[dialogEnum]
  if textTable == nil then
    return
  end
  NPCDialog.SetNPCText(View.Group_NPCPos.Group_NPC, textTable, dialogEnum)
end

function Controller.BatchRefresh()
  DataModel.batchList = {}
  DataModel.batchOpen = false
  DataModel.batchBuyMoney = 0
  DataModel.batchSaleMoney = 0
  local haveBatch = false
  local showTime = false
  if DataModel.CurTradeType == DataModel.TradeType.Buy then
    haveBatch = true
    showTime = true
    View.Group_Store.Group_Buy.Group_General.Btn_PL:SetActive(haveBatch)
    if haveBatch then
      local key = "Aquarium" .. DataModel.TradeType.Buy
      local batchOpen = PlayerData:GetPlayerPrefs("int", key) ~= 0
      DataModel.batchOpen = batchOpen
      View.Group_Store.Group_Buy.Group_General.Btn_PL.Group_On:SetActive(batchOpen)
      View.Group_Store.Group_Buy.Group_General.Btn_PL.Group_Off:SetActive(not batchOpen)
    end
    View.Group_Store.Group_Buy.Group_General.Group_Time:SetActive(showTime)
    View.Group_Store.Group_Buy.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
  else
    haveBatch = true
    showTime = true
    View.Group_Store.Group_Sell.Group_General.Btn_PL:SetActive(haveBatch)
    if haveBatch then
      local key = "Aquarium" .. DataModel.TradeType.Sell
      local batchOpen = PlayerData:GetPlayerPrefs("int", key) ~= 0
      DataModel.batchOpen = batchOpen
      View.Group_Store.Group_Sell.Group_General.Btn_PL.Group_On:SetActive(batchOpen)
      View.Group_Store.Group_Sell.Group_General.Btn_PL.Group_Off:SetActive(not batchOpen)
    end
    View.Group_Store.Group_Sell.Group_General.Group_Time:SetActive(showTime)
    View.Group_Store.Group_Sell.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
  end
end

function Controller.IsBuyBatchOpen()
  local key = "Aquarium" .. DataModel.TradeType.Buy
  return PlayerData:GetPlayerPrefs("int", key) ~= 0
end

function Controller.OpenBuyBatch()
  local key = "Aquarium" .. DataModel.TradeType.Buy
  PlayerData:SetPlayerPrefs("int", key, 1)
  DataModel.batchOpen = true
  DataModel.batchBuyMoney = 0
  View.Group_Store.Group_Buy.Group_General.Btn_PL.Group_On:SetActive(true)
  View.Group_Store.Group_Buy.Group_General.Btn_PL.Group_Off:SetActive(false)
  View.Group_Store.Group_Buy.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
  DataModel.batchList = {}
  View.Group_Store.Group_Buy.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
end

function Controller.CloseBuyBatch()
  local key = "Aquarium" .. DataModel.TradeType.Buy
  PlayerData:SetPlayerPrefs("int", key, 0)
  DataModel.batchOpen = false
  DataModel.batchBuyMoney = 0
  View.Group_Store.Group_Buy.Group_General.Btn_PL.Group_On:SetActive(false)
  View.Group_Store.Group_Buy.Group_General.Btn_PL.Group_Off:SetActive(true)
  View.Group_Store.Group_Buy.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
  DataModel.batchList = {}
  View.Group_Store.Group_Buy.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
end

function Controller.BatchBuyItemClick(index)
  index = tonumber(index)
  local info = DataModel.BuyCount[index]
  local id = info.id
  local ca = PlayerData:GetFactoryData(id, "CommodityFactory")
  local StoreDataModel = require("UIStore/UIStoreDataModel")
  local maxNum = StoreDataModel:GetPurchaseNum(ca)
  local remain = maxNum - (DataModel.GetItemBuyCount(index) or 0)
  if remain == 0 then
    CommonTips.OpenTips(80600077)
    return
  end
  local moneyNum = ca.moneyList[1] and ca.moneyList[1].moneyNum or 0
  if DataModel.batchList[index] then
    DataModel.batchList[index] = nil
    DataModel.batchBuyMoney = DataModel.batchBuyMoney - moneyNum
  else
    DataModel.batchList[index] = 1
    DataModel.batchBuyMoney = DataModel.batchBuyMoney + moneyNum
  end
  View.Group_Store.Group_Buy.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
  View.Group_Store.Group_Buy.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(DataModel.batchBuyMoney)
end

function Controller.IsSaleBatchOpen()
  local key = "Aquarium" .. DataModel.TradeType.Sell
  return PlayerData:GetPlayerPrefs("int", key) ~= 0
end

function Controller.OpenSaleBatch()
  local key = "Aquarium" .. DataModel.TradeType.Sell
  PlayerData:SetPlayerPrefs("int", key, 1)
  DataModel.batchOpen = true
  DataModel.batchSaleMoney = 0
  View.Group_Store.Group_Sell.Group_General.Btn_PL.Group_On:SetActive(true)
  View.Group_Store.Group_Sell.Group_General.Btn_PL.Group_Off:SetActive(false)
  View.Group_Store.Group_Sell.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
  DataModel.batchList = {}
  View.Group_Store.Group_Sell.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
end

function Controller.CloseSaleBatch()
  local key = "Aquarium" .. DataModel.TradeType.Sell
  PlayerData:SetPlayerPrefs("int", key, 0)
  DataModel.batchOpen = false
  DataModel.batchSaleMoney = 0
  View.Group_Store.Group_Sell.Group_General.Btn_PL.Group_On:SetActive(false)
  View.Group_Store.Group_Sell.Group_General.Btn_PL.Group_Off:SetActive(true)
  View.Group_Store.Group_Sell.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
  DataModel.batchList = {}
  View.Group_Store.Group_Sell.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
end

function Controller.BatchSaleItemClick(index)
  index = tonumber(index)
  local info = DataModel.SellCount[index]
  local id = info.commodityId
  local ca = PlayerData:GetFactoryData(id, "CommodityFactory")
  local moneyNum = ca.recycleMoneyList[1] and ca.recycleMoneyList[1].moneyNum or 0
  if DataModel.batchList[index] then
    DataModel.batchList[index] = nil
    DataModel.batchSaleMoney = DataModel.batchSaleMoney - moneyNum * info.num
  else
    DataModel.batchList[index] = info.num
    DataModel.batchSaleMoney = DataModel.batchSaleMoney + moneyNum * info.num
  end
  View.Group_Store.Group_Sell.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
  View.Group_Store.Group_Sell.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(DataModel.batchSaleMoney)
end

function Controller.RefreshGeneralBuyShop()
  local shopId = DataModel.BuyConfigId
  local storeFactory = PlayerData:GetFactoryData(shopId, "StoreFactory")
  local itemInfo = storeFactory.moneyList and storeFactory.moneyList[1]
  if itemInfo then
    local t = {}
    t.itemId = itemInfo.moneyID
    t.useNum = itemInfo.moneyNum
    local itemCA = PlayerData:GetFactoryData(t.itemId, "ItemFactory")
    CommonTips.OnItemPrompt(string.format(GetText(80600586), itemCA.name), t, function()
      Net:SendProto("shop.refresh", function(json)
        PlayerData:RefreshUseItems({
          [t.itemId] = t.useNum
        })
        DataModel.InitServerBuyData()
        DataModel.batchList = {}
        DataModel.batchBuyMoney = 0
        View.Group_Store.Group_Sell.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
        View.Group_Store.Group_Buy.Group_General.ScrollGrid_List.grid.self:SetDataCount(table.count(DataModel.BuyCount))
        View.Group_Store.Group_Buy.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
      end, shopId)
    end)
  end
end

function Controller.BatchBuyConfirm()
  if DataModel.batchBuyMoney == 0 then
    CommonTips.OpenTips(80609904)
    return
  end
  if PlayerData:GetGoodsById(11400001).num < DataModel.batchBuyMoney then
    CommonTips.OpenTips(80600539)
    return
  end
  local batchBuyInfo = {}
  for index, num in pairs(DataModel.batchList) do
    local shopInfo = DataModel.BuyCount[index]
    if shopInfo then
      table.insert(batchBuyInfo, index - 1 .. "_" .. shopInfo.id .. "_" .. num)
    end
  end
  if 0 < #batchBuyInfo then
    Net:SendProto("shop.buy_list", function(json)
      CommonTips.OpenShowItem(json.reward)
      DataModel.batchList = {}
      DataModel.batchBuyMoney = 0
      DataModel.InitServerBuyData()
      View.Group_Store.Group_Buy.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
      View.Group_Store.Group_Buy.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
      Controller:RefreshResources()
    end, DataModel.BuyConfigId, table.concat(batchBuyInfo, ","))
  end
end

function Controller.BatchSaleConfirm()
  if DataModel.batchSaleMoney == 0 then
    CommonTips.OpenTips(80609904)
    return
  end
  local batchBuyInfo = {}
  for index, num in pairs(DataModel.batchList) do
    local shopInfo = DataModel.SellCount[index]
    if shopInfo then
      table.insert(batchBuyInfo, shopInfo.commodityId .. "_" .. shopInfo.id .. "_" .. num)
    end
  end
  if 0 < #batchBuyInfo then
    Net:SendProto("shop.recycle_list", function(json)
      CommonTips.OpenShowItem(json.reward)
      for index, num in pairs(DataModel.batchList) do
        local shopInfo = DataModel.SellCount[index]
        if shopInfo then
          local serverData = PlayerData:GetHomeInfo().creatures[tostring(shopInfo.id)]
          serverData.num = serverData.num - num
        end
      end
      DataModel.batchList = {}
      DataModel.batchSaleMoney = 0
      DataModel.InitSellData()
      View.Group_Store.Group_Sell.Group_General.ScrollGrid_List.grid.self:SetDataCount(#DataModel.SellCount)
      View.Group_Store.Group_Sell.Group_General.ScrollGrid_List.grid.self:RefreshAllElement()
      View.Group_Store.Group_Sell.Group_General.Group_Time.Group_Money.Txt_MoneyNum:SetText(0)
      Controller:RefreshResources()
    end, DataModel.SellConfigId, table.concat(batchBuyInfo, ","))
  end
end

return Controller
