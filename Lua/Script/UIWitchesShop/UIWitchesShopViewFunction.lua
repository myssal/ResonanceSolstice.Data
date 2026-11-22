local View = require("UIWitchesShop/UIWitchesShopView")
local DataModel = require("UIWitchesShop/UIWitchesShopDataModel")
local ViewFunction = {
  WitchesShop_StaticGrid_BuffList_SetGrid = function(element, elementIndex)
    local data = DataModel.selectInfo[elementIndex]
    local itemId = tonumber(data.id)
    local eventCA = PlayerData:GetFactoryData(data.dialog_id, "MonopolyEventFactory")
    local goodInfo
    for i, v in ipairs(eventCA.goodsList) do
      if v.index == data.index then
        goodInfo = v
        break
      end
    end
    local itemCA = PlayerData:GetFactoryData(itemId)
    element.Img_Item:SetSprite(itemCA.iconPath)
    element.Txt_Name:SetText(itemCA.name)
    element.Txt_Des:SetText(itemCA.des)
    local currencyCA = PlayerData:GetFactoryData(goodInfo.currencyId)
    element.Group_Prise.Img_Icon:SetSprite(currencyCA.buyPath)
    element.Group_Prise.Txt_Num:SetText(goodInfo.currencyNum)
    local soldOut = data.limit == 0
    element.Img_SoldOutMask:SetActive(soldOut)
    element.Img_SoldOut:SetActive(soldOut)
    element.Btn_Buy:SetClickParam(elementIndex)
  end,
  WitchesShop_StaticGrid_BuffList_Group_Shop_Btn_Buy_Click = function(btn, str)
    local index = tonumber(str)
    local data = DataModel.selectInfo[index]
    if data.limit == 0 then
      return
    end
    local itemId = tonumber(data.id)
    local itemCA = PlayerData:GetFactoryData(itemId)
    local eventCA = PlayerData:GetFactoryData(data.dialog_id, "MonopolyEventFactory")
    local goodInfo
    for i, v in ipairs(eventCA.goodsList) do
      if v.index == data.index then
        goodInfo = v
        break
      end
    end
    if WitchData.GetItemNumById(goodInfo.currencyId) < goodInfo.currencyNum then
      CommonTips.OpenWitchTip(80611068)
      return
    end
    
    local function yesFun()
      local function cb(json)
        WitchData.OpenShowItem(json.reward)
        
        data.limit = data.limit - 1
        View.StaticGrid_BuffList.grid.self:RefreshAllElement()
        View.Group_Coin.Txt_Num:SetText(WitchData.GetCoin())
      end
      
      WitchData.ReqSelectShopItem(index, 1, cb)
    end
    
    local currencyCA = PlayerData:GetFactoryData(goodInfo.currencyId)
    local content = string.format(GetText(80610370), goodInfo.currencyNum, currencyCA.name, itemCA.name)
    CommonTips.OnPrompt(content, nil, nil, yesFun)
  end,
  WitchesShop_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    local function cb()
      UIManager:GoBack()
    end
    
    WitchData.ReqSelectShopItem(1, -1, cb)
  end,
  WitchesShop_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  WitchesShop_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  WitchesShop_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  WitchesShop_Group_Coin_Btn__Click = function(btn, str)
  end,
  WitchesShop_Group_Stamina_Btn__Click = function(btn, str)
  end
}
return ViewFunction
