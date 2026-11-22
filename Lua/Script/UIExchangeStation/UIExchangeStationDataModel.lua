local View = require("UIExchangeStation/UIExchangeStationView")
local NPCDialog = require("Common/NPCDialog")
local DataModel = {
  StationId = 0,
  NpcId = 0,
  BgPath = "",
  BgColor = "FFFFFF",
  NPCDialogEnum = {
    talkText = "talkText",
    enterText = "enterText",
    tabOrderText = "tabOrderText",
    tabBattleText = "tabBattleText",
    orderSuccessText = "orderSuccessText",
    notEnoughText = "notEnoughText",
    signText = "signText",
    cancelSignText = "cancelSignText",
    discardText = "discardText",
    enterExchangeText = "enterExchangeText",
    enterSaleText = "enterSaleText",
    exchangeSuccessText = "exchangeSuccessText",
    saleSuccessText = "saleSuccessText"
  },
  CacheEventList = {}
}

function DataModel:SetNPC()
  NPCDialog.SetNPC(View.Group_NPC, DataModel.NpcId)
  local HomeCommon = require("Common/HomeCommon")
  local repLv = HomeCommon.GetRepLv(DataModel.StationId)
  NPCDialog.HandleNPCTxtTable({repLv = repLv})
end

function DataModel:ShowNPCTalk(dialogEnum)
  if dialogEnum == DataModel.NPCDialogEnum.talkText and QuestProcess.CheckTalkDo(DataModel.CacheEventList, View, DataModel.BuildCA.id, function()
    View.Group_Main:SetActive(true)
  end) == 2 then
    View.Group_Main:SetActive(false)
    return
  end
  local npcConfig = PlayerData:GetFactoryData(DataModel.NpcId, "NPCFactory")
  local textTable = npcConfig[dialogEnum]
  if textTable == nil then
    return
  end
  NPCDialog.SetNPCText(View.Group_NPC, textTable, dialogEnum)
end

function DataModel:CheckQuestProcess(isRefresh)
  if isRefresh == nil then
    isRefresh = true
  end
  local params = {}
  params.url = View.self.url
  local status = {
    Current = "Chapter",
    squadIndex = PlayerData.BattleInfo.squadIndex,
    hasOpenThreeView = false
  }
  local t = {}
  t.buildingId = DataModel.BuildCA.id
  status.extraUIParamData = t
  params.status = status
  DataModel.CacheEventList = QuestProcess.CheckEventOpen(DataModel.BuildCA.id, params)
  local count = #DataModel.CacheEventList
  if 0 < count then
    QuestProcess.AddQuestCallBack(View.self.url, DataModel.CheckQuestProcess)
  end
  if isRefresh then
    View.Group_Main.StaticGrid_List.grid.self:RefreshAllElement()
  end
end

function DataModel:Init(first)
  local stationCA = PlayerData:GetFactoryData(DataModel.StationId, "HomeStationFactory")
  DataModel.StationCA = stationCA
  if first then
    if DataModel.InitMode == "Exchange" then
      DataModel:OpenStorePage(true)
    else
      if not DataModel.idx then
        View.self:PlayAnim("Main")
      end
      View.Group_Exchange:SetActive(false)
      View.Group_Main.self:SetActive(true)
      View.Group_Zhu.self:SetActive(false)
      View.Group_OrderList.self:SetActive(false)
    end
    DataModel:ShowNPCTalk(DataModel.NPCDialogEnum.enterText)
  end
  DataModel:CheckQuestProcess(false)
  View.Group_Main.self:SetActive(true)
  View.Group_Main.StaticGrid_List.grid.self:SetDataCount(#DataModel.BuildCA.exchangeOpenPageList)
  View.Group_Main.StaticGrid_List.grid.self:RefreshAllElement()
  DataModel:SetNPC()
  if DataModel.HideBg == true then
    View.Img_BG:SetActive(false)
  else
    View.Img_BG:SetActive(true)
    View.Img_BG:SetSprite(DataModel.BgPath)
    View.Img_BG:SetColor(DataModel.BgColor)
  end
  if self.BuildCA.correspondingActivity ~= nil and self.BuildCA.correspondingActivity > 0 then
    self:RefreshActivityConstruction()
  else
    View.Group_Construction.self:SetActive(false)
  end
  View.Group_CommonTopLeft.Btn_Help.self:SetActive(DataModel.HelpId ~= nil)
  if DataModel.StationCA ~= nil then
    View.Group_Main.Group_NpcInfo.Group_Dingwei.Txt_Station:SetText(DataModel.StationCA.name)
  end
  View.Group_Main.Group_NpcInfo.Txt_Name:SetText(DataModel.StationName)
  View.Group_Main.Group_NpcInfo.Img_Icon:SetSprite(DataModel.BuildCA.buildingPath)
  if self.BuildCA.isShowConstruct then
    Net:SendProto("station.construction_info", function()
      DataModel.StationList = PlayerData:GetHomeInfo().stations[tostring(DataModel.StationId)]
      DataModel.StationState = PlayerData:GetHomeInfo().stations[tostring(DataModel.StationId)].state
      DataModel:RefreshLeftData(first)
    end)
  end
  if self.BuildCA.isShowReputation then
    DataModel:RefreshGroupZhu()
    local HomeCommon = require("Common/HomeCommon")
    HomeCommon.SetReputationElement(View.Group_Zhu.Group_Reputation, DataModel.StationId)
  end
  local isShowTime = self.EndTime ~= nil and self.EndTime ~= ""
  View.Group_Time.self:SetActive(isShowTime)
  if isShowTime then
    local lastTime = TimeUtil:LastTime(self.EndTime)
    local time = TimeUtil:SecondToTable(lastTime)
    local timeStr = ""
    if 0 < time.day then
      timeStr = string.format(GetText(80607025), time.day, time.hour)
    else
      timeStr = string.format(GetText(80607026), time.hour, time.minute)
    end
    View.Group_Time.Txt_Time:SetText(timeStr)
    self.RefreshFrame = 1800
    self.curFrame = 0
  end
end

function DataModel:RefreshGroupZhu()
  local Group_Zhu = View.Group_Zhu
  Group_Zhu.Group_Dingwei.Txt_Station:SetText(DataModel.StationCA.name)
  Group_Zhu.Txt_Name:SetText(DataModel.StationName)
  Group_Zhu.Img_Icon:SetSprite(DataModel.BuildCA.buildingPath)
end

function DataModel:OpenConstructStage()
  local row = {}
  row.stationId = DataModel.StationId
  CommonTips.OpenConstructStage(row)
end

function DataModel:RefreshLeftData(first)
  DataModel.ConstructMaxNum = 0
  DataModel.ConstructNowNum = 0
  DataModel.ConstructNowCA = {}
  for k, v in pairs(DataModel.StationList.construction) do
    DataModel.ConstructNowNum = DataModel.ConstructNowNum + v.proportion
  end
  local count = 0
  for i = 1, #DataModel.StationCA.constructStageList do
    local row = DataModel.StationCA.constructStageList[i]
    DataModel.ConstructMaxNum = DataModel.ConstructMaxNum + row.constructNum
    DataModel.ConstructNowCA = row
    count = i
    if row.state and row.state ~= -1 and DataModel.ConstructNowNum >= DataModel.ConstructMaxNum and DataModel.StationState < row.state then
      DataModel.StationState = row.state
      PlayerData:GetHomeInfo().stations[tostring(DataModel.StationId)].state = row.state
    end
    if DataModel.ConstructNowNum < DataModel.ConstructMaxNum then
      break
    end
  end
  DataModel.Index_Construct = count
  DataModel:RefreshGroupZhu()
  local row_config = DataModel.StationCA.constructStageList[count]
  local row_server = DataModel.StationList.construction[count]
  local Group_Construct = View.Group_Zhu.Group_Construct
  Group_Construct.Txt_Num:SetText(row_server.proportion .. "/" .. row_config.constructNum)
  Group_Construct.Txt_Dec:SetText(DataModel.ConstructNowCA.name)
  Group_Construct.Img_PB:SetFilledImgAmount(row_server.proportion / row_config.constructNum)
  Group_Construct.Btn_Construct:SetSprite(DataModel.StationCA.constructIconPath)
  Group_Construct.Img_RedPoint:SetActive(PlayerData:GetConstructStageRewardState(DataModel.StationId))
end

function DataModel:OpenStorePage(isReopen)
  local storeList = self.BuildCA.exchangeStoreList
  local storeId, remainTime, isOpen
  for i = 1, #storeList do
    isOpen, remainTime = PlayerData:IsStoreOpen(storeList[i].id)
    if isOpen then
      storeId = storeList[i].id
      break
    end
  end
  if not isOpen then
    return
  end
  if isReopen then
    self:RefreshStoreInfo(storeId, remainTime)
    if self.BuildCA.isShowConstruct then
      self:RefreshStoreLeftData()
    end
  else
    Net:SendProto("shop.info", function(json)
      self:RefreshStoreInfo(storeId, remainTime)
    end, storeId)
    if self.BuildCA.isShowConstruct then
      Net:SendProto("station.construction_info", function()
        self:RefreshStoreLeftData()
      end)
    end
  end
end

function DataModel:RefreshStoreInfo(storeId, remainTime)
  self:ShowNPCTalk(self.NPCDialogEnum.enterExchangeText)
  View.Group_Main.self:SetActive(false)
  View.Group_OrderList.self:SetActive(false)
  View.Group_Construction.self:SetActive(false)
  View.Group_Zhu.self:SetActive(self.BuildCA.isShowConstruct or self.BuildCA.isShowReputation)
  View.Group_Zhu.Group_Reputation.self:SetActive(self.BuildCA.isShowReputation)
  View.Group_Zhu.Group_Construct.self:SetActive(self.BuildCA.isShowConstruct)
  local groupStore = View.Group_Exchange
  groupStore.self:SetActive(true)
  View.self:PlayAnim("Exchange")
  local storeCA = PlayerData:GetFactoryData(storeId, "StoreFactory")
  self.exchangeStoreCA = storeCA
  local storeTop = groupStore.Group_Ding.Group_Top
  storeTop.StaticGrid_Coin.grid.self:SetDataCount(#storeCA.currencyShow)
  storeTop.StaticGrid_Coin.grid.self:RefreshAllElement()
  local isTime = storeCA.isTime
  storeTop.Group_Time:SetActive(isTime)
  if isTime then
    storeTop.Group_Time.Txt_Time:SetText(string.format(GetText(80601093), math.floor(remainTime / 86400)))
  end
  local storeMid = groupStore.Group_Middle
  storeMid.Group_Title.Txt_Title:SetText(self.BuildCA.exchangeName)
  if self.BuildCA.exchangePath ~= nil and self.BuildCA.exchangePath ~= "" then
    storeMid.Group_Title.Img_Title:SetSprite(self.BuildCA.exchangePath)
  end
  if self.BuildCA.pagePath ~= nil and self.BuildCA.pagePath ~= "" then
    storeMid.Img_Di:SetSprite(self.BuildCA.pagePath)
  end
  local serverItems = PlayerData.ServerData.shops[tostring(storeCA.id)].items
  local itemBuyCount = {}
  for k, v in pairs(serverItems) do
    itemBuyCount[tonumber(v.id)] = v.py_cnt
  end
  self.itemBuyCount = itemBuyCount
  local shopList = storeCA.shopList
  local itemList = {}
  for i = 1, #shopList do
    local itemCA = PlayerData:GetFactoryData(shopList[i].id, "CommondityFactory")
    if itemCA.isTime then
      if TimeUtil:IsActive(itemCA.startTime, itemCA.endTime) then
        itemList[#itemList + 1] = shopList[i]
      end
    else
      itemList[#itemList + 1] = shopList[i]
    end
    itemList[#itemList].idx = #itemList
    itemList[#itemList].commodityIndex = i
  end
  table.sort(itemList, function(e1, e2)
    local w1 = self:GetItemWeight(e1.id)
    local w2 = self:GetItemWeight(e2.id)
    if w1 ~= w2 then
      return w1 > w2
    else
      return e1.idx < e2.idx
    end
  end)
  self.itemList = itemList
  self.notEnoughMap = {}
  storeMid.ScrollGrid_List.grid.self:SetDataCount(#itemList)
  storeMid.ScrollGrid_List.grid.self:RefreshAllElement()
  storeMid.ScrollGrid_List.grid.self:MoveToTop()
  if DataModel.InitItem ~= nil then
    local initIndex
    for i = 1, #DataModel.itemList do
      if tostring(DataModel.itemList[i].id) == tostring(DataModel.InitItem) then
        initIndex = i
      end
    end
    DataModel.InitItem = nil
    if initIndex ~= nil then
      DataModel:OnClickItem(initIndex)
    end
  end
end

function DataModel:OnSetCoinGrid(element, elementIndex)
  local coinData = self.exchangeStoreCA.currencyShow[elementIndex]
  local coinId = coinData.id
  local coinCA = PlayerData:GetFactoryData(coinId)
  element.Img_Icon:SetSprite(coinCA.buyPath)
  element.Txt_Num:SetText(PlayerData:GetGoodsById(coinId).num)
  if coinData.click == "Tips" then
    element.Btn_GoldCoin:SetClickParam(coinId)
  end
end

function DataModel:OnClickGoldCoin(btn, str)
  if str == nil or str == "" then
    return
  end
  self:ShowItemDes(str)
end

function DataModel:RefreshStoreLeftData()
  if not self.BuildCA.isShowConstruct then
    return
  end
  DataModel.StationList = PlayerData:GetHomeInfo().stations[tostring(DataModel.StationId)]
  DataModel.StationState = PlayerData:GetHomeInfo().stations[tostring(DataModel.StationId)].state
  DataModel:RefreshLeftData()
end

function DataModel:GetItemWeight(itemId)
  local ca = PlayerData:GetFactoryData(itemId)
  if ca.isBuyCondition then
    local gradeCondition = ca.gradeCondition
    if gradeCondition > PlayerData:GetUserInfo().lv then
      return 1
    end
  end
  if ca.purchase then
    local StoreDataModel = require("UIStore/UIStoreDataModel")
    local maxNum = StoreDataModel:GetPurchaseNum(ca)
    if maxNum - (self.itemBuyCount[tonumber(itemId)] or 0) <= 0 then
      return 0
    end
  end
  return 2
end

function DataModel:RefreshWeaponStore()
  local storeId = self:GetOpenWeaponStoreId()
  if storeId == nil then
    return
  end
  Net:SendProto("shop.info", function(json)
    DataModel.isWeaponReady = true
  end, storeId)
end

function DataModel:OpenWeaponStore(uiPath)
  if DataModel.isWeaponReady ~= true then
    return
  end
  local storeId = self:GetOpenWeaponStoreId()
  if storeId == nil then
    return
  end
  UIManager:Open(uiPath, Json.encode({storeId = storeId, inited = true}))
end

function DataModel:GetOpenWeaponStoreId()
  local storeList = self.BuildCA.exchangeWeaponList
  local storeId, remainTime, isOpen
  for i = 1, #storeList do
    isOpen, remainTime = PlayerData:IsStoreOpen(storeList[i].id)
    if isOpen then
      storeId = storeList[i].id
      break
    end
  end
  if not isOpen then
    return
  end
  return storeId
end

function DataModel:RefershOrderList(isResetGrid)
  if self.isOrderRefreshed ~= true then
    Net:SendProto("building.activity", function(json)
      self.isOrderRefreshed = true
      local buildInfo = json.building or {}
      for k, v in pairs(buildInfo) do
        if tonumber(k) == tonumber(self.BuildCA.id) then
          self.activityItems = {}
          for id, item in pairs(v.items) do
            if tonumber(id) ~= nil then
              local index = self:GetOrderListIndex(id)
              if index ~= nil then
                local rewardsId = self.BuildCA.activityOrderList[index]
                local rewardCA = PlayerData:GetFactoryData(rewardsId.rewardId)
                self.activityItems[#self.activityItems + 1] = {
                  id = tonumber(id),
                  deliver = item.deliver,
                  limit = item.limit,
                  once = item.once,
                  index = index,
                  rewardCA = rewardCA
                }
              end
            end
          end
          self:RefreshOrderListUI(isResetGrid)
          break
        end
      end
    end, self.BuildCA.id)
  else
    self:RefreshOrderListUI(isResetGrid)
  end
end

function DataModel:RefreshActivityConstruction()
  local group = View.Group_Construction
  group.self:SetActive(true)
  local ServerConstructionDataModel = require("UIServerConstruction/UIServerConstructionDataModel")
  local redPointAll = ServerConstructionDataModel:GetRedPointState("all", self.BuildCA.correspondingActivity)
  local redPointOne = ServerConstructionDataModel:GetRedPointState("one", self.BuildCA.correspondingActivity)
  local CardPackDataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
  local activeCA = PlayerData:GetFactoryData(self.BuildCA.correspondingActivity)
  local cardPackInfo = CardPackDataModel.GetCardPackInfo(activeCA.activityCardPack)
  group.Img_RedPoint:SetActive(redPointAll or redPointOne or cardPackInfo and cardPackInfo.extraCardStatus == 1)
  local curNum = PlayerData:GetActivityServerConstructionCstNum(self.BuildCA.correspondingActivity)
  local prog = math.min(curNum / activeCA.constructionLimit, 1)
  group.Txt_Num:SetText(string.format(GetText(80606881), math.floor(prog * 100)))
  group.Group_All.Img_Progress:SetFilledImgAmount(prog)
  curNum = PlayerData:GetActivityPersonalConstructionCstNum(self.BuildCA.correspondingActivity)
  local personlist = activeCA.personalConstructionList
  if personlist and 0 < #personlist then
    prog = math.min(curNum / personlist[#personlist].construction, 1)
  else
    prog = 1
  end
  group.Txt_PersonalNum:SetText(string.format(GetText(80606881), math.floor(prog * 100)))
  group.Group_Personal.Img_Progress:SetFilledImgAmount(prog)
end

function DataModel:RefreshOrderListUI(isResetGrid)
  if isResetGrid == nil then
    isResetGrid = true
  end
  DataModel:ShowNPCTalk(DataModel.NPCDialogEnum.tabOrderText)
  local mainGroup = View.Group_OrderList
  mainGroup.self:SetActive(true)
  View.Group_Main.self:SetActive(false)
  if isResetGrid then
    View.self:PlayAnim("Order")
  end
  mainGroup.Group_Ding.Group_GoldCoin.Txt_Num:SetText(PlayerData:GetUserInfo().gold or 0)
  local titleGroup = mainGroup.Group_Middle.Group_Title
  titleGroup.Txt_Title:SetText(GetText(self.BuildCA.orderTitle))
  titleGroup.Txt_Dec:SetText(GetText(self.BuildCA.orderDes))
  titleGroup.Img_Title:SetSprite(self.BuildCA.orderBgPath)
  table.sort(self.activityItems, function(e1, e2)
    local w1 = self:GetOrderListWeight(e1)
    local w2 = self:GetOrderListWeight(e2)
    if w1 ~= w2 then
      return w1 > w2
    else
      return e1.index < e2.index
    end
  end)
  mainGroup.Group_Middle.ScrollGrid_List.grid.self:SetDataCount(#self.activityItems)
  mainGroup.Group_Middle.ScrollGrid_List.grid.self:RefreshAllElement()
  if isResetGrid then
    mainGroup.Group_Middle.ScrollGrid_List.grid.self:MoveToTop()
  end
end

function DataModel:OnOrderListSetGrid(element, index)
  local itemInfo = self.activityItems[index]
  local itemCA = PlayerData:GetFactoryData(itemInfo.id)
  local infoGroup = element.Group_Information
  infoGroup.Txt_Name:SetText(itemCA.name)
  infoGroup.Txt_DeliveryNum:SetText(itemInfo.once)
  infoGroup.Img_Icon:SetSprite(itemCA.tipsPath)
  local residueGroup = infoGroup.Group_residueNum
  local deliver = itemInfo.deliver
  local limit = itemInfo.limit
  local isComplete = 0 < limit and deliver >= limit
  residueGroup.Group_Infinite.self:SetActive(limit <= 0)
  residueGroup.Group_Empty.self:SetActive(isComplete)
  residueGroup.Group_Num.self:SetActive(not isComplete)
  if 0 <= deliver and deliver < itemInfo.limit then
    residueGroup.Group_Num.Txt_Num:SetText(itemInfo.limit - deliver)
  end
  local isEnough = itemInfo.once <= PlayerData:GetGoodsById(itemInfo.id).num
  element.Group_Complete.self:SetActive(isComplete)
  element.Group_Enough.self:SetActive(isEnough and not isComplete)
  element.Group_NotEnough.self:SetActive(not isEnough and not isComplete)
  element.Btn_:SetClickParam(index)
  infoGroup.Btn_:SetClickParam(itemInfo.id)
  local rewardCA = itemInfo.rewardCA
  if rewardCA then
    infoGroup.Group_Reward.StaticGrid_RewardList.grid.self:SetParentParam(index)
    infoGroup.Group_Reward.StaticGrid_RewardList.grid.self:SetDataCount(#rewardCA.rewardList)
    infoGroup.Group_Reward.StaticGrid_RewardList.grid.self:RefreshAllElement()
  end
end

function DataModel:OnOrderRewardListSetGrid(element, index)
  local itemInfo = self.activityItems[tonumber(element.ParentParam)]
  local rewardCA = itemInfo.rewardCA
  if rewardCA then
    local rewardList = rewardCA.rewardList
    local reward = rewardList[index]
    element.Txt_Num:SetText(reward.num)
    local itemCA = PlayerData:GetFactoryData(reward.id)
    element.Img_Bottom:SetSprite(UIConfig.BottomConfig[itemCA.qualityInt + 1])
    element.Img_Mask:SetSprite(UIConfig.MaskConfig[itemCA.qualityInt + 1])
    element.Img_Item:SetSprite(itemCA.iconPath)
    element.Btn_Item:SetClickParam(reward.id)
  end
end

local checkTipParam = {
  checkTipType = 1,
  checkTipKey = "ActivityOrderList",
  isCheckTip = true
}

function DataModel:OnClickOrderBtn(str)
  local itemInfo = self.activityItems[tonumber(str)]
  local isEnough = itemInfo.once <= PlayerData:GetGoodsById(itemInfo.id).num
  local isCompleted = itemInfo.limit > 0 and itemInfo.deliver >= itemInfo.limit
  if isEnough and not isCompleted then
    if not PlayerData:GetNoPrompt(checkTipParam.checkTipKey, checkTipParam.checkTipType) then
      CommonTips.OnPrompt(GetText(80606897), 80600068, 80600067, function()
        self:DoBuildingDelivery(itemInfo)
      end, nil, nil, nil, nil, checkTipParam)
    else
      self:DoBuildingDelivery(itemInfo)
    end
  end
end

function DataModel:DoBuildingDelivery(itemInfo)
  Net:SendProto("building.delivery", function(json)
    DataModel:ShowNPCTalk(DataModel.NPCDialogEnum.orderSuccessText)
    local cost = {
      [itemInfo.id] = itemInfo.once
    }
    PlayerData:RefreshUseItems(cost)
    CommonTips.OpenShowItem(json.reward, nil, nil, true)
    itemInfo.deliver = itemInfo.deliver + 1
    self:RefershOrderList(false)
    if self.BuildCA.correspondingActivity ~= nil and self.BuildCA.correspondingActivity > 0 then
      self:RefreshActivityConstruction()
    end
  end, self.BuildCA.id, itemInfo.id)
end

function DataModel:GetOrderListIndex(id)
  local orderList = self.BuildCA.activityOrderList
  for i = 1, #orderList do
    if tonumber(orderList[i].id) == tonumber(id) then
      return i
    end
  end
end

function DataModel:GetOrderListWeight(orderList)
  if orderList.limit > 0 and orderList.deliver >= orderList.limit then
    return 0
  elseif orderList.once > PlayerData:GetGoodsById(orderList.id).num then
    return 1
  else
    return 2
  end
end

function DataModel:ShowItemDes(str)
  if str == nil then
    return
  end
  CommonTips.OpenPreRewardDetailTips(str, nil, true)
end

function DataModel:OpenActivityPanel()
  local activityId = self.BuildCA.correspondingActivity
  local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
  local activeList = ActivityMainDataModel:GetActivityCAList()
  for k, v in ipairs(activeList) do
    if v.id == activityId then
      UIManager:Open("UI/Activity/ActivityMain", Json.encode({index = k, id = activityId}))
      break
    end
  end
end

function DataModel:OpenBuildLevel(uiPath)
  UIManager:Open(uiPath, Json.encode({
    buildingId = self.BuildCA.id
  }))
end

function DataModel:SetGroupConsume(groupConsume, moneyData, elementIndex)
  local moneyCA = PlayerData:GetFactoryData(moneyData.moneyID)
  groupConsume.Group_Item.Img_Item:SetSprite(moneyCA.iconPath or moneyCA.imagePath)
  local quality = moneyCA.qualityInt + 1
  groupConsume.Group_Item.Img_Bottom:SetSprite(UIConfig.BottomConfig[quality])
  groupConsume.Group_Item.Img_Mask:SetSprite(UIConfig.MaskConfig[quality])
  groupConsume.Group_Item.Btn_Item:SetClickParam(moneyCA.id)
  local groupCost = groupConsume.Group_Cost
  local needNum = moneyData.moneyNum
  groupCost.Txt_Need.Txt.text = PlayerData:NumToFormatString(needNum, 1)
  local haveNum = PlayerData:GetGoodsById(moneyData.moneyID).num
  groupCost.Txt_Have.Txt.text = PlayerData:NumToFormatString(haveNum, 1)
  if needNum > haveNum then
    groupCost.Txt_Have:SetColor(UIConfig.Color.Red)
    if DataModel.notEnoughMap[tonumber(elementIndex)] ~= true then
      DataModel.notEnoughMap[tonumber(elementIndex)] = true
    end
  else
    groupCost.Txt_Have:SetColor(UIConfig.Color.White)
  end
end

function DataModel:OnClickItem(str)
  local itemId = DataModel.itemList[tonumber(str)].id
  local ca = PlayerData:GetFactoryData(itemId, "CommondityFactory")
  if ca.isBuyCondition then
    local gradeCondition = ca.gradeCondition
    if gradeCondition > PlayerData:GetUserInfo().lv then
      return
    end
  end
  if DataModel.notEnoughMap[tonumber(str)] then
    CommonTips.OpenTips(80601871)
    return
  end
  local isPurchase = ca.purchase
  local StoreDataModel = require("UIStore/UIStoreDataModel")
  local maxNum = StoreDataModel:GetPurchaseNum(ca)
  if isPurchase then
    local itemBuyCount = DataModel.itemBuyCount[tonumber(itemId)] or 0
    local remainCount = math.max(0, maxNum - itemBuyCount)
    if remainCount <= 0 then
      CommonTips.OpenTips(80609925)
      return
    end
  end
  local remainBuyNum = ca.purchase ~= true and -1 or math.max(0, maxNum - (DataModel.itemBuyCount[tonumber(itemId)] or 0))
  UIManager:Open("UI/Common/ExchangeTips", Json.encode({
    commodityId = itemId,
    remainNum = remainBuyNum,
    shopId = DataModel.exchangeStoreCA.id,
    index = DataModel.itemList[tonumber(str)].commodityIndex
  }), function()
    DataModel:OpenStorePage(true)
    DataModel:ShowNPCTalk(DataModel.NPCDialogEnum.exchangeSuccessText)
  end)
end

return DataModel
