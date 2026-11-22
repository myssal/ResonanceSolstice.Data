local View = require("UIPrisonShop/UIPrisonShopView")
local NPCDialog = require("Common/NPCDialog")
local DataModel = {}
DataModel.prisonCA = PrisonData.GetPrisonCA()
DataModel.npcId = 83700087
DataModel.shopList = {}
DataModel.currentShop = {}
DataModel.notEnoughMap = {}
DataModel.OpenTab = 1
DataModel.jumpCommodityId = nil
DataModel.menuElements = {}

function DataModel.SetJsonData(json)
  DataModel.OpenTab = 1
  DataModel.jumpCommodityId = nil
  if json then
    local data = Json.decode(json)
    DataModel.OpenTab = data.openTab and tonumber(data.openTab) or 1
    DataModel.jumpCommodityId = data.jumpCommodityId and tonumber(data.jumpCommodityId)
  end
end

function DataModel.InitData()
  DataModel.shopList = {}
  local prisonCA = DataModel.prisonCA
  for i, v in ipairs(prisonCA.prisonStoreList) do
    local shopCA = PlayerData:GetFactoryData(v.id, "StoreFactory")
    local data = {
      shopId = v.id,
      shopItems = {}
    }
    for i, v1 in ipairs(shopCA.shopList) do
      if v1.id > 0 then
        table.insert(data.shopItems, {
          commodityId = v1.id
        })
      end
    end
    DataModel.shopList[v.id] = data
  end
  DataModel.notEnoughMap = {}
  DataModel.menuElements = {}
end

function DataModel.RefreshOnShow()
  View.HomeCOCShop.Group_Store.Group_StoreTab.Group_Purchase:SetActive(true)
  View.HomeCOCShop.Group_Store.Group_StoreTab.Group_Exchange:SetActive(false)
  local goldNum = PlayerData:GetUserInfo().gold
  View.Group_Resources.Group_GoldCoin.Txt_Num:SetText(goldNum)
  local itemNum = PlayerData:GetGoodsById(11400119).num
  View.Group_Resources.Group_PrisonDian.Txt_Num:SetText(itemNum)
  if DataModel.OpenTab == 1 then
    DataModel.RefreshPurchase()
  elseif DataModel.OpenTab == 2 then
    DataModel.RefreshExchange()
  end
  NPCDialog.SetNPC(View.Group_NPC, DataModel.npcId)
  DataModel.NpcTalk(DataModel.NpcTalkEnum.Open)
  DataModel.RefreshLevel()
end

function DataModel.RefreshLevel()
  local prisonLv = PrisonData.GetPrisonLv()
  local exp = PrisonData.GetPrisonExp()
  local lvCfg = DataModel.prisonCA.lvList[prisonLv]
  View.Group_PrisonInfo.Group_level.Txt_PrisonEXP:SetText(string.format("%d/%d", exp, lvCfg.exp))
  View.Group_PrisonInfo.Group_level.Group_PrisonEXP.Img_EXPBar:SetFilledImgAmount(exp / lvCfg.exp)
  View.Group_PrisonInfo.Group_level.Txt_PrisonLV:SetText(string.format(GetText(80607996), prisonLv))
end

function DataModel.RefreshPurchase()
  View.HomeCOCShop.Group_Store.Group_StoreTab.Group_Purchase:SetActive(true)
  View.HomeCOCShop.Group_Store.Group_StoreTab.Group_Exchange:SetActive(false)
  local shop = DataModel.shopList[40300063]
  DataModel.currentShop = shop
  local dataCount = table.count(shop.shopItems)
  View.HomeCOCShop.Group_Store.Group_Exchange.Group_Middle.ScrollGrid_List.grid.self:SetDataCount(dataCount)
  View.HomeCOCShop.Group_Store.Group_Exchange.Group_Middle.ScrollGrid_List.grid.self:RefreshAllElement()
  local commodityId = DataModel.jumpCommodityId
  if commodityId then
    local index
    for i, v in ipairs(DataModel.currentShop.shopItems) do
      if v.commodityId == commodityId then
        index = i
        break
      end
    end
    if index then
      View.HomeCOCShop.Group_Store.Group_Exchange.Group_Middle.ScrollGrid_List.grid.self:MoveToPos(index)
    end
  else
    View.HomeCOCShop.Group_Store.Group_Exchange.Group_Middle.ScrollGrid_List.grid.self:MoveToTop()
  end
end

function DataModel.RefreshExchange()
  View.HomeCOCShop.Group_Store.Group_StoreTab.Group_Purchase:SetActive(false)
  View.HomeCOCShop.Group_Store.Group_StoreTab.Group_Exchange:SetActive(true)
  local shop = DataModel.shopList[40300062]
  DataModel.currentShop = shop
  local dataCount = table.count(shop.shopItems)
  View.HomeCOCShop.Group_Store.Group_Exchange.Group_Middle.ScrollGrid_List.grid.self:SetDataCount(dataCount)
  View.HomeCOCShop.Group_Store.Group_Exchange.Group_Middle.ScrollGrid_List.grid.self:RefreshAllElement()
  local commodityId = DataModel.jumpCommodityId
  if commodityId then
    local index
    for i, v in ipairs(DataModel.currentShop.shopItems) do
      if v.commodityId == commodityId then
        index = i
        break
      end
    end
    if index then
      View.HomeCOCShop.Group_Store.Group_Exchange.Group_Middle.ScrollGrid_List.grid.self:MoveToPos(index)
    end
  else
    View.HomeCOCShop.Group_Store.Group_Exchange.Group_Middle.ScrollGrid_List.grid.self:MoveToTop()
  end
end

function DataModel.GetRemainBuyNum(commodityId)
  local shopId = DataModel.currentShop.shopId
  local serverItems = PlayerData.ServerData.shops[tostring(shopId)].items
  local itemBuyCount = {}
  for k, v in pairs(serverItems) do
    itemBuyCount[tonumber(v.id)] = v.py_cnt
  end
  local commodityCA = PlayerData:GetFactoryData(commodityId, "CommodityFactory")
  local StoreDataModel = require("UIStore/UIStoreDataModel")
  local maxNum = StoreDataModel:GetPurchaseNum(commodityCA)
  return commodityCA.purchase ~= true and -1 or math.max(0, maxNum - (itemBuyCount[tonumber(commodityId)] or 0))
end

DataModel.NpcTalkEnum = {
  Open = "prisonOpenShopText",
  Exchange = "prisonExchangeText",
  CostUnEnough = "ItemText"
}

function DataModel.NpcTalk(dialogEnum)
  local npcConfig = PlayerData:GetFactoryData(DataModel.npcId, "NPCFactory")
  local textTable = npcConfig[dialogEnum]
  if textTable == nil then
    return
  end
  NPCDialog.SetNPCText(View.Group_NPC, textTable, dialogEnum)
end

function DataModel.JumpOpenExchangeTip()
  local commodityId = DataModel.jumpCommodityId
  if not commodityId then
    return
  end
  local index
  for i, v in ipairs(DataModel.currentShop.shopItems) do
    if v.commodityId == commodityId then
      index = i
      break
    end
  end
  if not index then
    return
  end
  if DataModel.notEnoughMap[commodityId] then
    return
  end
  local commodityCA = PlayerData:GetFactoryData(commodityId, "CommodityFactory")
  local lockLv = commodityCA.prisonGradeCondition
  if lockLv then
    local createRoomLv = 0
    local buildRoomList = PrisonData.GetBuildList()
    if buildRoomList["87500010"] then
      createRoomLv = buildRoomList["87500010"].lv
    else
      local roomTypeCA = PlayerData:GetFactoryData(87500010, "PrisonRoomTypeFactory")
      if roomTypeCA.isInitial then
        createRoomLv = 1
      end
    end
    if lockLv > createRoomLv then
      return
    end
  end
  local shopId = DataModel.currentShop.shopId
  local remainBuyNum = DataModel.GetRemainBuyNum(commodityId)
  if remainBuyNum == 0 then
    return
  end
  UIManager:Open("UI/Common/ExchangeTips", Json.encode({
    commodityId = commodityId,
    remainNum = remainBuyNum,
    shopId = shopId,
    index = tonumber(index)
  }), function()
    DataModel.NpcTalk(DataModel.NpcTalkEnum.Exchange)
    DataModel.notEnoughMap = {}
    local goldNum = PlayerData:GetUserInfo().gold
    View.Group_Resources.Group_GoldCoin.Txt_Num:SetText(goldNum)
    local itemNum = PlayerData:GetGoodsById(11400119).num
    View.Group_Resources.Group_PrisonDian.Txt_Num:SetText(itemNum)
    if View.HomeCOCShop.Group_Store.Group_StoreTab.Group_Exchange.IsActive then
      DataModel.RefreshExchange()
    else
      DataModel.RefreshPurchase()
    end
    if UIManager:IsPanelOpened("UI/Prison/PrisonerProduction/PrisonProductionEdit") then
      local controller = require("UIPrisonProductionEdit/UIPrisonProductionEditController")
      controller.RefreshAfterJumpToExchange()
    end
    if UIManager:IsPanelOpened("UI/Home_MachiningLathe/SewingMachine/Home_SewingMachine") then
      local controller = require("UIHome_MachiningLathe/HomeMakeFurController")
      controller.RefreshAfterJumpToExchange()
    end
    if UIManager:IsPanelOpened("UI/Home_MachiningLathe/SewingMachine/Home_SewingMachine") then
      local controller = require("UIHome_MachiningLathe/HomeMakeFurController")
      controller.RefreshAfterJumpToExchange()
    end
  end)
end

return DataModel
