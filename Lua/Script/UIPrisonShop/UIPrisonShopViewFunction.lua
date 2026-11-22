local View = require("UIPrisonShop/UIPrisonShopView")
local DataModel = require("UIPrisonShop/UIPrisonShopDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  PrisonShop_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.self:CloseUI()
  end,
  PrisonShop_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PrisonShop_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonShop_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304352}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  PrisonShop_Group_Resources_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  PrisonShop_Group_Resources_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  PrisonShop_HomeCOCShop_Group_Store_Group_Exchange_Group_Middle_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local itemInfo = DataModel.currentShop.shopItems[elementIndex]
    local commodityId = itemInfo.commodityId
    local commodityCA = PlayerData:GetFactoryData(commodityId, "CommodityFactory")
    local itemId = commodityCA.commodityItemList[1].id
    local lockLv = commodityCA.prisonGradeCondition and commodityCA.prisonGradeCondition
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
    local showLock = lockLv and lockLv > createRoomLv
    element.Group_RestrictLV:SetActive(showLock)
    if lockLv then
      element.Group_RestrictLV.Txt_LV:SetText(lockLv)
    end
    element.Group_Name.Txt_Name:SetActive(not CommonTips.IsResEN())
    element.Group_Name.Txt_Name_EN:SetActive(CommonTips.IsResEN())
    if CommonTips.IsResEN() then
      element.Group_Name.Txt_Name_EN:SetText(commodityCA.commodityName)
    else
      element.Group_Name.Txt_Name:SetText(commodityCA.commodityName)
    end
    element.Img_Icon:SetSprite(commodityCA.commodityView)
    element.Img_Icon.Btn_:SetClickParam(itemId)
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
    element.Group_Target:SetActive(tonumber(DataModel.currentShop.shopId) == 40300063)
    if element.Group_Target.IsActive then
      local itemCA = PlayerData:GetFactoryData(itemId)
      element.Group_Target.Img_Item2:SetSprite(itemCA.breakPath)
    end
  end,
  PrisonShop_HomeCOCShop_Group_Store_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Img_Icon_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PrisonShop_HomeCOCShop_Group_Store_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_ScrollGrid_List_SetGrid = function(element, elementIndex)
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
  PrisonShop_HomeCOCShop_Group_Store_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_ScrollGrid_List_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PrisonShop_HomeCOCShop_Group_Store_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Btn_Group_Can_Btn__Click = function(btn, str)
    local itemInfo = DataModel.currentShop.shopItems[tonumber(str)]
    local commodityId = itemInfo.commodityId
    if DataModel.notEnoughMap[commodityId] then
      DataModel.NpcTalk(DataModel.NpcTalkEnum.CostUnEnough)
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
    end)
  end,
  PrisonShop_Group_Resources_Group_PrisonDian_Btn_GoldCoin_Click = function(btn, str)
  end,
  PrisonShop_Group_Resources_Group_PrisonDian_Btn_Add_Click = function(btn, str)
  end,
  PrisonShop_HomeCOCShop_Group_Store_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Btn_Group_Not_Btn__Click = function(btn, str)
  end,
  PrisonShop_HomeCOCShop_Group_Store_Group_Exchange_Group_Middle_ScrollGrid_List_Group_Item_Group_Extra_Img_Icon_Btn__Click = function(btn, str)
  end,
  PrisonShop_HomeCOCShop_Group_Store_Group_StoreTab_Group_Exchange_Btn_Purchase_Click = function(btn, str)
    DataModel.RefreshPurchase()
  end,
  PrisonShop_HomeCOCShop_Group_Store_Group_StoreTab_Group_Purchase_Btn_Exchange_Click = function(btn, str)
    DataModel.RefreshExchange()
  end
}
return ViewFunction
