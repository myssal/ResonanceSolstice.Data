local View = require("UIExchangeStation/UIExchangeStationView")
local DataModel = require("UIExchangeStation/UIExchangeStationDataModel")
local ViewFunction = {
  ExchangeStation_Group_Zhu_Group_Construct_Btn_Construct_Click = function(btn, str)
    DataModel:OpenConstructStage()
  end,
  ExchangeStation_Group_Tab_Btn_Buy_Click = function(btn, str)
  end,
  ExchangeStation_Group_Tab_Btn_Sell_Click = function(btn, str)
  end,
  ExchangeStation_Group_Exchange_Group_Middle_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local itemId = DataModel.itemList[elementIndex].id
    local ca = PlayerData:GetFactoryData(itemId, "CommondityFactory")
    if DataModel.BuildCA.bottomPath ~= nil and DataModel.BuildCA.bottomPath ~= "" then
      element.Img_Di:SetSprite(DataModel.BuildCA.bottomPath)
    end
    element.Img_Icon.self:SetSprite(ca.commodityView)
    local itemParam = ca.commodityItemList[1].id
    element.Img_Icon.Btn_:SetClickParam(itemParam)
    local isShowQuality = false
    if DataManager:GetFactoryNameById(itemParam) == "EquipmentFactory" then
      isShowQuality = true
    end
    element.Group_Quality.self:SetActive(isShowQuality)
    if isShowQuality then
      local equipCA = PlayerData:GetFactoryData(itemParam)
      local qualityNum = equipCA.qualityInt + 1
      element.Group_Quality.Img_Quality:SetSprite(UIConfig.ItemTipQuality[qualityNum])
    end
    element.Group_Name.Txt_Name:SetActive(false)
    element.Group_Name.Txt_NameL:SetActive(true)
    element.Group_Name.Txt_NameL:SetText(string.format(GetText(80601981), ca.commodityName, ca.commodityNum))
    local moneyList = ca.moneyList
    local groupItem = element.Group_Item
    local consumeGrid = element.ScrollGrid_List
    consumeGrid.self:SetActive(3 < #moneyList)
    groupItem.self:SetActive(#moneyList <= 3)
    if #moneyList <= 3 then
      for i = 1, 3 do
        local isShow = i <= #moneyList
        local groupConsume = groupItem["Group_Consume" .. i]
        groupConsume.self:SetActive(isShow)
        if isShow then
          local moneyData = moneyList[i]
          DataModel:SetGroupConsume(groupConsume, moneyData, elementIndex)
        end
      end
    else
      consumeGrid.grid.self:SetParentParam(elementIndex)
      consumeGrid.grid.self:SetDataCount(#moneyList)
      consumeGrid.grid.self:RefreshAllElement()
      consumeGrid.grid.self:MoveToTop()
    end
    local isPurchase = ca.purchase
    element.Group_Num.self:SetActive(isPurchase)
    local groupBtn = element.Group_Btn
    groupBtn.Group_Can.Btn_:SetClickParam(elementIndex)
    if isPurchase then
      local StoreDataModel = require("UIStore/UIStoreDataModel")
      local maxNum = StoreDataModel:GetPurchaseNum(ca)
      local itemBuyCount = DataModel.itemBuyCount[tonumber(itemId)] or 0
      local remainCount = math.max(0, maxNum - itemBuyCount)
      local textIdEnuogh = 80601872
      local textIdUnEnuogh = 80601873
      if ca.limitBuyType == "Forever" then
        textIdEnuogh = 80601872
        textIdUnEnuogh = 80601873
      elseif ca.limitBuyType == "Daily" then
        textIdEnuogh = 80602203
        textIdUnEnuogh = 80602202
      elseif ca.limitBuyType == "Weekly" then
        textIdEnuogh = 80602204
        textIdUnEnuogh = 80602205
      elseif ca.limitBuyType == "Monthly" then
        textIdEnuogh = 80602206
        textIdUnEnuogh = 80602207
      end
      if 0 < remainCount then
        element.Group_Num.Txt_Num:SetText(string.format(GetText(textIdEnuogh), remainCount))
        groupBtn.Group_Can.Img_:SetSprite(DataModel.BuildCA.exchangeAffirmPath)
      else
        element.Group_Num.Txt_Num:SetText(GetText(textIdUnEnuogh))
        groupBtn.Group_Not.Img_:SetSprite(DataModel.BuildCA.exchangeCompletePath)
      end
      groupBtn.Group_Can.self:SetActive(0 < remainCount)
      groupBtn.Group_Not.self:SetActive(remainCount <= 0)
      element.Group_Allready.self:SetActive(remainCount <= 0)
    else
      element.Group_Allready.self:SetActive(false)
      groupBtn.Group_Can.self:SetActive(true)
      groupBtn.Group_Not.self:SetActive(false)
      groupBtn.Group_Can.Img_:SetSprite(DataModel.BuildCA.exchangeAffirmPath)
    end
    local extraGiveList = ca.extraGiveList
    local groupExtra = element.Group_Extra
    groupExtra.self:SetActive(0 < #extraGiveList)
    if 0 < #extraGiveList then
      groupExtra.Txt_Num:SetText(string.format(GetText(80601880), extraGiveList[1].num))
      groupExtra.Img_Icon:SetSprite(PlayerData:GetFactoryData(extraGiveList[1].id).iconPath)
      groupExtra.Img_Icon.Btn_:SetClickParam(extraGiveList[1].id)
    end
    local isTime = ca.isTime
    local groupTime = element.Group_Time
    groupTime.self:SetActive(isTime)
    if isTime then
      local remainTime = TimeUtil:SecondToTable(TimeUtil:LastTime(ca.endTime))
      groupTime.Txt_Time:SetText(string.format(GetText(80601059), remainTime.day, remainTime.hour))
    end
    local isGradeLimit = false
    if ca.isBuyCondition then
      local gradeCondition = ca.gradeCondition
      if gradeCondition > PlayerData:GetUserInfo().lv then
        isGradeLimit = true
        element.Group_Grade.Txt_Grade:SetText(string.format(GetText(80607663), gradeCondition))
      end
    end
    element.Group_Grade:SetActive(isGradeLimit)
  end,
  ExchangeStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Img_Icon_Btn__Click = function(btn, str)
    DataModel:ShowItemDes(str)
  end,
  ExchangeStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Item_Group_Consume1_Group_Item_Btn_Item_Click = function(btn, str)
    DataModel:ShowItemDes(str)
  end,
  ExchangeStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Item_Group_Consume2_Group_Item_Btn_Item_Click = function(btn, str)
    DataModel:ShowItemDes(str)
  end,
  ExchangeStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Item_Group_Consume3_Group_Item_Btn_Item_Click = function(btn, str)
    DataModel:ShowItemDes(str)
  end,
  ExchangeStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Btn_Group_Can_Btn__Click = function(btn, str)
    DataModel:OnClickItem(str)
  end,
  ExchangeStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Btn_Group_Not_Btn__Click = function(btn, str)
  end,
  ExchangeStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Extra_Img_Icon_Btn__Click = function(btn, str)
  end,
  ExchangeStation_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.idx then
      UIManager:GoBack()
      return
    end
    View.Group_Zhu.self:SetActive(false)
    if not View.Group_Main.IsActive then
      if View.Group_Exchange.self.IsActive then
        View.Group_Exchange.self:SetActive(false)
      elseif View.Group_OrderList.self.IsActive then
        View.Group_OrderList.self:SetActive(false)
      end
      View.Group_Main.self:SetActive(true)
      if DataModel.InitMode == nil then
        View.self:PlayAnim("Main")
        return
      end
    end
    if DataModel.IsCityMapIn then
      UIManager:Open("UI/CityMap/CityMap", Json.encode({
        stationId = DataModel.StationId
      }))
    else
      UIManager:GoBack()
    end
  end,
  ExchangeStation_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    CommonCoachData.GoHome()
  end,
  ExchangeStation_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  ExchangeStation_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    UIManager:Open("UI/Common/Group_Help", Json.encode({
      helpId = DataModel.HelpId
    }))
  end,
  ExchangeStation_Group_Main_Group_Btn_Btn_List_Click = function(btn, str)
  end,
  ExchangeStation_Group_Main_StaticGrid_List_SetGrid = function(element, elementIndex)
    local row = DataModel.BuildCA.exchangeOpenPageList[tonumber(elementIndex)]
    element.Btn_List:SetClickParam(elementIndex)
    element.Btn_List.Txt_Dec:SetText(row.name)
    element.Btn_List.Img_Icon:SetSprite(row.icon)
    if row.isStore == true then
      local isStoreOpen = false
      local storeRemainTime
      local storeList = DataModel.BuildCA.exchangeStoreList
      for i = 1, #storeList do
        isStoreOpen, storeRemainTime = PlayerData:IsStoreOpen(storeList[i].id)
        if isStoreOpen then
          break
        end
      end
      local imgLimit = element.Btn_List.Img_Limit
      local group_time = element.Btn_List.Group_Time
      imgLimit.self:SetActive(not isStoreOpen)
      group_time.self:SetActive(isStoreOpen and storeRemainTime ~= nil)
      if isStoreOpen then
        if storeRemainTime ~= nil then
          group_time.Txt_Time:SetText(string.format(GetText(80601093), math.floor(storeRemainTime / 86400)))
        end
      else
        imgLimit.Txt_Dec:SetText(row.name)
        imgLimit.Img_Icon:SetSprite(row.icon)
      end
    elseif row.isTalk then
      local count = #DataModel.CacheEventList
      element.Btn_List.Img_RedPoint:SetActive(0 < count)
      if count == 1 then
        local questCA = PlayerData:GetFactoryData(DataModel.CacheEventList[1].questId)
        element.Btn_List.Txt_Dec:SetText(questCA.name)
      end
    else
      element.Btn_List.Img_Limit.self:SetActive(false)
      element.Btn_List.Group_Time.self:SetActive(false)
    end
    if row.uiPath ~= nil and row.uiPath ~= "" then
      DataModel:RefreshWeaponStore()
    end
  end,
  ExchangeStation_Group_Main_StaticGrid_List_Group_Btn_Btn_List_Click = function(btn, str)
    local row = DataModel.BuildCA.exchangeOpenPageList[tonumber(str)]
    if row.isTalk == true then
      DataModel:ShowNPCTalk(DataModel.NPCDialogEnum.talkText)
      return
    end
    if row.showUI == "Group_Exchange" then
      DataModel:OpenStorePage()
    elseif row.showUI == "Group_OrderList" then
      DataModel:RefershOrderList()
    end
    if row.uiPath ~= nil and row.uiPath ~= "" then
      DataModel.isNewUiOpen = true
      if row.uiPath == "UI/WeaponStore/WeaponStore" then
        DataModel:OpenWeaponStore(row.uiPath)
      elseif row.uiPath == "UI/BuildLevel/BuildLevel" then
        DataModel:OpenBuildLevel(row.uiPath)
      elseif row.uiPath == "UI/HomeBattleCenter/HomeBattleCenter" then
        local t = {}
        t.stationId = DataModel.StationId
        t.npcId = DataModel.NpcId
        t.bgPath = DataModel.BgPath
        t.bgColor = DataModel.BgColor
        t.isCityMapIn = false
        t.name = DataModel.StationName
        t.noConstruction = not DataModel.BuildCA.isShowConstruct
        t.initGroup = row.showUI
        UIManager:Open(row.uiPath, Json.encode(t))
      end
    end
  end,
  ExchangeStation_Group_Zhu_Group_Reputation_Btn_Reputation_Click = function(btn, str)
    local HomeCommon = require("Common/HomeCommon")
    HomeCommon.ClickReputationBtn(DataModel.StationId, nil, nil, function()
      HomeCommon.SetReputationElement(View.Group_Zhu.Group_Reputation, DataModel.StationId)
    end)
  end,
  ExchangeStation_Group_Construction_Btn__Click = function(btn, str)
    DataModel:OpenActivityPanel()
  end,
  ExchangeStation_Group_OrderList_Group_Ding_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  ExchangeStation_Group_OrderList_Group_Ding_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  ExchangeStation_Group_OrderList_Group_Ding_Group_Tips_Btn_Tips_Click = function(btn, str)
  end,
  ExchangeStation_Group_OrderList_Group_Middle_ScrollGrid_List_SetGrid = function(element, elementIndex)
    DataModel:OnOrderListSetGrid(element, elementIndex)
  end,
  ExchangeStation_Group_OrderList_Group_Middle_ScrollGrid_List_Group_Item_Group_Information_Btn__Click = function(btn, str)
    DataModel:ShowItemDes(str)
  end,
  ExchangeStation_Group_OrderList_Group_Middle_ScrollGrid_List_Group_Item_Group_Information_Group_Reward_Group_ItemReward_Btn_Item_Click = function(btn, str)
  end,
  ExchangeStation_Group_OrderList_Group_Middle_ScrollGrid_List_Group_Item_Group_Information_Group_Reward_StaticGrid_RewardList_SetGrid = function(element, elementIndex)
    DataModel:OnOrderRewardListSetGrid(element, elementIndex)
  end,
  ExchangeStation_Group_OrderList_Group_Middle_ScrollGrid_List_Group_Item_Group_Information_Group_Reward_StaticGrid_RewardList_Group_Item_Btn_Item_Click = function(btn, str)
    DataModel:ShowItemDes(str)
  end,
  ExchangeStation_Group_OrderList_Group_Middle_ScrollGrid_List_Group_Item_Btn__Click = function(btn, str)
    if str == nil or str == "" then
      return
    end
    DataModel:OnClickOrderBtn(str)
  end,
  ExchangeStation_Group_Exchange_Group_Ding_Group_Top_Group_Time_Btn_Tips_Click = function(btn, str)
  end,
  ExchangeStation_Group_Exchange_Group_Ding_Group_Top_StaticGrid_Coin_SetGrid = function(element, elementIndex)
    DataModel:OnSetCoinGrid(element, elementIndex)
  end,
  ExchangeStation_Group_Exchange_Group_Ding_Group_Top_StaticGrid_Coin_Group_Coin_Btn_GoldCoin_Click = function(btn, str)
    DataModel:OnClickGoldCoin(btn, str)
  end,
  ExchangeStation_Group_Exchange_Group_Ding_Group_Top_StaticGrid_Coin_Group_Coin_Btn_Add_Click = function(btn, str)
  end,
  ExchangeStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local itemId = DataModel.itemList[tonumber(element.ParentParam)].id
    local ca = PlayerData:GetFactoryData(itemId, "CommondityFactory")
    DataModel:SetGroupConsume(element, ca.moneyList[elementIndex], element.ParentParam)
  end,
  ExchangeStation_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_ScrollGrid_List_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    DataModel:ShowItemDes(str)
  end
}
return ViewFunction
