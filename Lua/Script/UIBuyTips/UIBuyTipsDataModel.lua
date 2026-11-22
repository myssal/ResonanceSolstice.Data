local View = require("UIBuyTips/UIBuyTipsView")
local DataModel = {}
local money
DataModel.CommoditData = {}
DataModel.currentNum = 0
DataModel.EnumBtnType = {
  Add = 1,
  Subtraction = 2,
  Max = 3,
  Min = 4
}
DataModel.costResult = {}
DataModel.IsMonopoly = false

local function SetFurniture(element, data, isDetail)
  element:SetActive(true)
  element.Txt_Name:SetText(DataModel.commoditCA.commodityName)
  element.Img_Mask.Img_Item:SetSprite(DataModel.commoditCA.commodityView)
  View.Txt_Name:SetActive(false)
  local item = DataModel.commoditCA.commodityItemList[1]
  if item then
    local itemCA = PlayerData:GetFactoryData(item.id)
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
    if itemCA.comfort then
      element.Group_Attribute.Group_AttributeComfort.self:SetActive(0 < itemCA.comfort)
      element.Group_Attribute.Group_AttributeComfort.Txt_Scores:SetText(itemCA.comfort)
    else
      element.Group_Attribute.Group_AttributeComfort.self:SetActive(false)
    end
  end
end

local function SetItem(element)
  local data = DataModel.commoditCA
  element:SetActive(true)
  element.Txt_Num:SetActive(true)
  element.Txt_Num:SetText(data.commodityNum or 1)
  element.Img_Time:SetActive(false)
  element.Group_EType:SetActive(false)
  local commodity = data.commodityItemList[1]
  local factoryName = DataManager:GetFactoryNameById(commodity.id)
  local itemCA = PlayerData:GetFactoryData(commodity.id)
  View.Txt_Name:SetActive(true)
  View.Txt_Name:SetText(itemCA.name)
  element.Img_Item:SetSprite(itemCA.iconPath)
  element.Img_Bottom:SetSprite(UIConfig.BottomConfig[data.qualityInt + 1])
  element.Img_Mask:SetSprite(UIConfig.MaskConfig[data.qualityInt + 1])
  if factoryName == "EquipmentFactory" then
    local detailData = PlayerData:GetFactoryData(commodity.id)
    element.Group_EType:SetActive(true)
    local index = PlayerData:GetTypeInt("enumEquipTypeList", detailData.equipTagId)
    element.Group_EType.Img_Icon:SetSprite(UIConfig.EquipmentTypeMark[index])
    element.Group_EType.Img_IconBg:SetSprite(UIConfig.EquipmentTypeMarkBg[detailData.qualityInt])
  end
end

local function SetData(data)
  DataModel.CommoditData = data
  if data.id then
    DataModel.commoditCA = PlayerData:GetFactoryData(data.id)
  end
  if data.commoditData and data.commoditData.id then
    DataModel.commoditCA = PlayerData:GetFactoryData(data.commoditData.id)
  end
  DataModel.IsMonopoly = data.isMonopoly or false
  DataModel.ShopCA = PlayerData:GetFactoryData(data.shopid)
end

function DataModel:OpenBuyTips(isOpen, data)
  if isOpen then
    SetData(data)
    DataModel.isConfig = PlayerData:GetStoreBuyTipsConfig(DataModel.commoditCA.commodityItemList[1].id)
    DataModel.moneyList = DataModel.commoditCA.moneyList[1]
    local commoditCA = DataModel.commoditCA
    
    local function GetMaxNum(costInfo)
      local now_max = 0
      local moneyNum = costInfo == nil and 0 or costInfo.moneyNum
      local moneyID = costInfo == nil and 0 or costInfo.moneyID
      local curHaveMoneyNum = PlayerData:GetGoodsById(moneyID).num
      if DataModel.CommoditData.endlessCoinId ~= nil and DataModel.CommoditData.endlessCoinId == moneyID then
        local EndlessDataModel = require("UIActivityEndlessBattle/UIActivityEndlessBattleDataModel")
        if EndlessDataModel.user_endless ~= nil then
          curHaveMoneyNum = EndlessDataModel.user_endless.coin or 0
        end
      end
      if commoditCA.isChange and 0 < costInfo.correspondPrice then
        local listCA = PlayerData:GetFactoryData(costInfo.correspondPrice, "ListFactory")
        local priceLength = #listCA.priceList
        for i = (DataModel.CommoditData.py_cnt or 0) + 1, priceLength do
          curHaveMoneyNum = curHaveMoneyNum - listCA.priceList[i].num
          if curHaveMoneyNum <= 0 then
            break
          end
          now_max = now_max + 1
        end
        if 0 < curHaveMoneyNum then
          local canBuyCount = math.floor(curHaveMoneyNum / listCA.priceList[priceLength].num)
          now_max = now_max + canBuyCount
        end
      else
        now_max = math.floor(curHaveMoneyNum / moneyNum)
      end
      return now_max
    end
    
    local now_max = GetMaxNum(DataModel.commoditCA.moneyList[1])
    local costLength = #DataModel.commoditCA.moneyList
    if 1 < costLength then
      for i = 2, costLength do
        local maxNum = GetMaxNum(DataModel.commoditCA.moneyList[i])
        if now_max > maxNum then
          now_max = maxNum
        end
      end
    end
    if commoditCA and commoditCA.oneTimeMax then
      local min = math.min(commoditCA.oneTimeMax, now_max)
      now_max = min
    end
    if commoditCA.purchase == true then
      local StoreDataModel = require("UIStore/UIStoreDataModel")
      local maxNum = StoreDataModel:GetPurchaseNum(commoditCA)
      local min = math.min(maxNum, now_max)
      now_max = min
    end
    now_max = data.residue and data.residue ~= "" and math.min(now_max, data.residue) or now_max
    if now_max == 0 then
      now_max = 1
    end
    DataModel.CommoditData.residue = now_max
    self.SetNumBtn(self, DataModel.EnumBtnType.Min)
    View.Img_Furniture.self:SetActive(false)
    View.Group_Item.self:SetActive(false)
    if DataModel.isConfig == true then
      SetFurniture(View.Img_Furniture)
    else
      local CommonItem = require("Common/BtnItem")
      CommonItem:SetItem(View.Group_Item, {
        id = commoditCA.commodityItemList[1].id,
        num = commoditCA.commodityNum
      })
      local commodity = commoditCA.commodityItemList[1]
      local itemCA = PlayerData:GetFactoryData(commodity.id)
      View.Txt_Name:SetActive(true)
      View.Txt_Name:SetText(itemCA.name or itemCA.SkinName)
    end
    View.Group_Slider.Slider_Value:SetMinAndMaxValue(1, now_max)
  else
    UIManager:GoBack(false, 1)
  end
end

function DataModel:Sale()
  self.OpenBuyTips(self, false)
  Net:SendProto("item.sell_items", function(json)
    PlayerData:RefreshUseItems({
      [DataModel.CommoditData.id] = math.ceil(DataModel.currentNum)
    })
    CommonTips.OpenShowItem(json.reward)
    UIManager:GoBack()
  end, tostring(DataModel.CommoditData.id), math.ceil(DataModel.currentNum))
end

function DataModel.SetNum(maxNum)
  local num = DataModel.currentNum
  View.Group_Slider.Group_Num.Txt_Select:SetText(math.ceil(num))
  View.Group_Slider.Group_Num.Txt_Possess:SetText(maxNum)
  DataModel.costResult = {}
  View.Group_Cost.Img_Btm.StaticGrid_.grid.self:SetDataCount(#DataModel.commoditCA.moneyList)
  View.Group_Cost.Img_Btm.StaticGrid_.grid.self:RefreshAllElement()
end

function DataModel:SetNumBtn(btnType)
  local maxNum = DataModel.CommoditData.residue
  local num = DataModel.currentNum
  if btnType == DataModel.EnumBtnType.Add then
    if maxNum > num then
      num = num + 1
    else
      return
    end
  elseif btnType == DataModel.EnumBtnType.Subtraction then
    if 1 < num then
      num = num - 1
    else
      return
    end
  elseif btnType == DataModel.EnumBtnType.Max then
    num = maxNum
  elseif btnType == DataModel.EnumBtnType.Min then
    num = 1
  end
  DataModel.currentNum = num
  DataModel.SetNum(maxNum)
  View.Group_Slider.Slider_Value:SetSliderValue(num)
end

function DataModel:SetSlider(value)
  if DataModel.CommoditData.residue == 1 then
    return
  end
  DataModel.currentNum = math.modf(value)
  DataModel.SetNum(DataModel.CommoditData.residue)
end

function DataModel:BuyCommodit()
  local costEnough = true
  for moneyID, costNum in pairs(DataModel.costResult) do
    local ownNum = PlayerData:GetGoodsById(moneyID).num
    if DataModel.CommoditData.endlessCoinId ~= nil and DataModel.CommoditData.endlessCoinId == moneyID then
      local EndlessDataModel = require("UIActivityEndlessBattle/UIActivityEndlessBattleDataModel")
      if EndlessDataModel.user_endless ~= nil then
        ownNum = EndlessDataModel.user_endless.coin or 0
      end
    end
    if costNum > ownNum then
      local function callback()
        UIManager:GoBack(false)
        
        CommonTips.OpenStoreBuy()
      end
      
      local moneyName = PlayerData:GetFactoryData(moneyID).name
      if moneyID == 11400005 then
        CommonTips.OnPrompt(80600147, nil, nil, callback)
      elseif moneyID == 11400100 then
        local ca = PlayerData:GetFactoryData(moneyID, DataManager:GetFactoryNameById(moneyID))
        CommonTips.OpenTips(string.format(GetText(80601070), ca.name))
      else
        CommonTips.OpenTips(string.format(GetText(80601070), moneyName))
      end
      costEnough = false
      return
    end
  end
  if costEnough then
    local function callback(json)
      for moneyID, costNum in pairs(DataModel.costResult) do
        if DataModel.CommoditData.endlessCoinId ~= nil and DataModel.CommoditData.endlessCoinId == moneyID then
          local EndlessDataModel = require("UIActivityEndlessBattle/UIActivityEndlessBattleDataModel")
          
          if EndlessDataModel.user_endless ~= nil then
            EndlessDataModel.user_endless.coin = math.max(0, (EndlessDataModel.user_endless.coin or 0) - costNum)
          end
        else
          PlayerData:RefreshUseItems({
            [moneyID] = costNum
          })
        end
      end
      UIManager:GoBack(false)
    end
    
    if DataModel.ShopCA.storeType == "Regular" then
      Net:SendProto("shop.buy", function(json)
        EventMgr:SendEvent("event_monopoly_buy_dice_success", DataModel.CommoditData.index, math.ceil(DataModel.currentNum))
        self:OnBuySuccess({json = json})
        local row = json.reward
        row.Title = "\232\142\183\229\190\151\233\129\147\229\133\183"
        callback(json)
        View.self:Confirm()
        if not DataModel.CommoditData.noShowReward then
          CommonTips.OpenShowItem(json.reward)
        end
      end, tostring(DataModel.CommoditData.shopid), DataModel.CommoditData.index, math.ceil(DataModel.currentNum), DataModel.commoditCA.id)
    else
      if DataModel.CommoditData.type and DataModel.CommoditData.type == "role" then
        Net:SendProto("shop.buy", function(json)
          self:OnBuySuccess({json = json})
          print_r(json)
          local row = json.reward
          row.Title = "\232\142\183\229\190\151\232\167\146\232\137\178"
          callback(json)
          View.self:Confirm()
          if not DataModel.CommoditData.noShowReward then
            CommonTips.OpenShowItem(json.reward)
          end
          DataModel.RefreshState = 1
        end, tostring(DataModel.CommoditData.shopid), DataModel.CommoditData.index, 1, DataModel.CommoditData.id)
        return
      end
      Net:SendProto("shop.buy", function(json)
        EventMgr:SendEvent("event_monopoly_buy_dice_success", DataModel.CommoditData.index, math.ceil(DataModel.currentNum))
        self:OnBuySuccess({json = json})
        local row = json.reward
        row.Title = "\232\142\183\229\190\151\233\129\147\229\133\183"
        callback(json)
        View.self:Confirm()
        if not DataModel.CommoditData.noShowReward then
          if DataModel.IsMonopoly then
            UIManager:Open("UI/Monopoly/UI/ShowItem/MonopolyShowItem", Json.encode({
              rewards = json.reward,
              title = nil,
              ignoreCloseTime = true
            }), nil)
          else
            CommonTips.OpenShowItem(json.reward)
          end
        end
      end, tostring(DataModel.CommoditData.shopid), DataModel.CommoditData.index, math.ceil(DataModel.currentNum))
    end
  end
end

function DataModel:OnBuySuccess(args)
  local shopId = DataModel.CommoditData.shopid
  local itemIndex = DataModel.CommoditData.index
  local itemId = DataModel.CommoditData.id or 0
  local num = DataModel.currentNum
  if DataModel.CommoditData.type and DataModel.CommoditData.type == "role" then
    num = 1
  end
  SdkReporter.TrackShopBuy({
    shopId = shopId,
    index = itemIndex,
    itemId = itemId,
    num = num
  })
end

return DataModel
