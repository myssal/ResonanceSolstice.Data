local View = require("UIMonopolyBuyBuff/UIMonopolyBuyBuffView")
local DataModel = require("UIMonopolyBuyBuff/UIMonopolyBuyBuffDataModel")
local monopolyDataModel = require("UIMonopoly/UIMonopolyDataModel")

local function showItem(id, num)
  local reword = {
    material = {}
  }
  reword.material[tostring(id)] = {num = num}
  UIManager:Open("UI/Monopoly/UI/ShowItem/MonopolyShowItem", Json.encode({
    rewards = reword,
    title = nil,
    ignoreCloseTime = true
  }), nil)
end

local ViewFunction = {
  MonopolyBuyBuff_StaticGrid_BuffList_SetGrid = function(element, elementIndex)
    local data = DataModel.itemList[elementIndex]
    element:SetActive(false)
    if data then
      element:SetActive(true)
      local cfg = PlayerData:GetFactoryData(data.id)
      element.Img_Item:SetSprite(cfg.iconPath or cfg.imagePath)
      element.Txt_Name:SetText(cfg.name)
      element.Img_Num.Txt_Num:SetText(data.num)
      element.Txt_Des:SetText(cfg.des)
      element.Img_SoldOutMask:SetActive(data.num <= 0)
      element.Img_SoldOut:SetActive(data.num <= 0)
      local moneyCfg = PlayerData:GetFactoryData(data.moneyId)
      element.Group_Prise.Img_Icon:SetSprite(moneyCfg.buyPath)
      element.Group_Prise.Txt_Num:SetText(data.price)
      element.Btn_Buy:SetClickParam(elementIndex)
      local canBuy = PlayerData:GetGoodsById(data.moneyId).num >= data.price
      local color = canBuy and "#2D4362" or "#FF0808"
      element.Group_Prise.Txt_Num:SetColor(color)
    end
  end,
  MonopolyBuyBuff_StaticGrid_BuffList_Group_Buff_Btn_Buy_Click = function(btn, str)
    DataModel.nowIdx = tonumber(str)
    local data = DataModel.itemList[DataModel.nowIdx]
    local nowNum = PlayerData:GetGoodsById(data.moneyId).num
    if nowNum < data.price then
      CommonTips.OpenTips(80600062)
      return
    end
    if data.num <= 0 then
      CommonTips.OpenTips(80608827)
      return
    end
    local ownNum = monopolyDataModel.GetAllItemsCount()
    local remainBuyNum = DataModel.ownMaxNum - ownNum
    if remainBuyNum <= 0 then
      CommonTips.OpenTips(80609906)
      return
    end
    local buyNum = remainBuyNum <= data.num and remainBuyNum or data.num
    local maxNum = math.floor(nowNum / data.price)
    buyNum = buyNum > maxNum and maxNum or buyNum
    if buyNum == 1 then
      Net:SendProto("monopoly.grid_shop_buy", function(json)
        data.num = data.num - 1
        PlayerData:GetGoodsById(data.moneyId).num = PlayerData:GetGoodsById(data.moneyId).num - data.price
        View.StaticGrid_BuffList.grid.self:RefreshAllElement()
        monopolyDataModel.AddBackItemNum(data.id, 1)
        View.Img_Livia.Img_Des.Group_ItemNum.Txt_Own:SetText(monopolyDataModel.GetAllItemsCount())
        showItem(data.id, 1)
      end, data.id, 1)
    else
      View.Group_BuyTips:SetActive(true)
      DataModel.selectNum = 1
      DataModel.maxNum = buyNum
      DataModel.price = data.price
      local cfg = PlayerData:GetFactoryData(data.id)
      View.Group_BuyTips.Group_Main.Group_Item.Img_Item:SetSprite(cfg.iconPath or cfg.imagePath)
      View.Group_BuyTips.Group_Main.Txt_Name:SetText(cfg.name)
      View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.selectNum)
      View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Group_Num.Txt_Possess:SetText(DataModel.maxNum)
      local moneyCfg = PlayerData:GetFactoryData(data.moneyId)
      View.Group_BuyTips.Group_Main.Img_BG.Img_SourceItem:SetSprite(moneyCfg.buyPath)
      View.Group_BuyTips.Group_Main.Img_BG.Img_SourceItem.Txt_Num:SetText(data.price)
      View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Slider_Value:SetSliderValue(0)
    end
  end,
  MonopolyBuyBuff_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Net:SendProto("monopoly.com_grid", function()
      UIManager:ClosePanel()
    end, DataModel.shopId, nil)
  end,
  MonopolyBuyBuff_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  MonopolyBuyBuff_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  MonopolyBuyBuff_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  MonopolyBuyBuff_Group_BuyTips_Btn_Close_Click = function(btn, str)
    View.Group_BuyTips:SetActive(false)
  end,
  MonopolyBuyBuff_Group_BuyTips_Group_Main_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  MonopolyBuyBuff_Group_BuyTips_Group_Main_Group_Num_Btn_Min_Click = function(btn, str)
    DataModel.selectNum = 1
    View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.selectNum)
    View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Slider_Value:SetSliderValue(0)
  end,
  MonopolyBuyBuff_Group_BuyTips_Group_Main_Group_Num_Btn_Dec_Click = function(btn, str)
    DataModel.selectNum = DataModel.selectNum - 1
    DataModel.selectNum = DataModel.selectNum <= 1 and 1 or DataModel.selectNum
    View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.selectNum)
    local value = DataModel.selectNum / DataModel.maxNum
    value = DataModel.selectNum == 1 and 0 or value
    View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Slider_Value:SetSliderValue(value)
  end,
  MonopolyBuyBuff_Group_BuyTips_Group_Main_Group_Num_Group_Slider_Slider_Value_Slider = function(slider, value)
    if value == 0 then
      DataModel.selectNum = 1
    elseif value == 1 then
      DataModel.selectNum = DataModel.maxNum
    else
      DataModel.selectNum = math.floor(value * DataModel.maxNum)
      DataModel.selectNum = MathEx.Clamp(DataModel.selectNum, 1, DataModel.maxNum)
    end
    View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.selectNum)
    View.Group_BuyTips.Group_Main.Img_BG.Img_SourceItem.Txt_Num:SetText(DataModel.price * DataModel.selectNum)
  end,
  MonopolyBuyBuff_Group_BuyTips_Group_Main_Group_Num_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  MonopolyBuyBuff_Group_BuyTips_Group_Main_Group_Num_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  MonopolyBuyBuff_Group_BuyTips_Group_Main_Group_Num_Btn_Add_Click = function(btn, str)
    DataModel.selectNum = DataModel.selectNum + 1
    DataModel.selectNum = DataModel.selectNum >= DataModel.maxNum and DataModel.maxNum or DataModel.selectNum
    View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.selectNum)
    local value = DataModel.selectNum / DataModel.maxNum
    View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Slider_Value:SetSliderValue(value)
  end,
  MonopolyBuyBuff_Group_BuyTips_Group_Main_Group_Num_Btn_Max_Click = function(btn, str)
    DataModel.selectNum = DataModel.maxNum
    View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.selectNum)
    View.Group_BuyTips.Group_Main.Group_Num.Group_Slider.Slider_Value:SetSliderValue(1)
  end,
  MonopolyBuyBuff_Group_BuyTips_Group_Main_Btn_Cancel_Click = function(btn, str)
    View.Group_BuyTips:SetActive(false)
  end,
  MonopolyBuyBuff_Group_BuyTips_Group_Main_Btn_Use_Click = function(btn, str)
    local data = DataModel.itemList[DataModel.nowIdx]
    Net:SendProto("monopoly.grid_shop_buy", function(json)
      monopolyDataModel.AddBackItemNum(data.id, DataModel.selectNum)
      View.Group_BuyTips:SetActive(false)
      data.num = data.num - DataModel.selectNum
      PlayerData:GetGoodsById(data.moneyId).num = PlayerData:GetGoodsById(data.moneyId).num - data.price * DataModel.selectNum
      View.StaticGrid_BuffList.grid.self:RefreshAllElement()
      View.Img_Livia.Img_Des.Group_ItemNum.Txt_Own:SetText(monopolyDataModel.GetAllItemsCount())
      showItem(data.id, DataModel.selectNum)
    end, data.id, DataModel.selectNum)
  end
}
return ViewFunction
