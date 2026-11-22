local View = require("UIPrisonWarehouseBuy/UIPrisonWarehouseBuyView")
local DataModel = require("UIPrisonWarehouseBuy/UIPrisonWarehouseBuyDataModel")
local Controller = require("UIPrisonWarehouseBuy/UIPrisonWarehouseBuyController")
local ViewFunction = {
  PrisonWarehouseBuy_Btn_BG_Click = function(btn, str)
    UIManager:GoBack()
  end,
  PrisonWarehouseBuy_Group_Diamond_Btn_Diamond_Click = function(btn, str)
    Controller:SwitchExpandSpaceBuyMode(1)
  end,
  PrisonWarehouseBuy_Group_Gold_Btn_Gold_Click = function(btn, str)
    Controller:SwitchExpandSpaceBuyMode(2)
  end,
  PrisonWarehouseBuy_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel.BuySpaceNum = DataModel.NumRound(value)
    if DataModel.BuySpaceNum == 0 then
      DataModel.BuySpaceNum = 1
    end
    Controller:RefreshBuyTipsMoney(DataModel.BuySpaceNum)
  end,
  PrisonWarehouseBuy_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  PrisonWarehouseBuy_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  PrisonWarehouseBuy_Btn_Min_Click = function(btn, str)
    DataModel.BuySpaceNum = 1
    View.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BuySpaceNum)
    Controller:RefreshBuyTipsMoney(DataModel.BuySpaceNum)
  end,
  PrisonWarehouseBuy_Btn_Dec_Click = function(btn, str)
    if DataModel.BuySpaceNum - 1 < View.Group_Slider.Slider_Value.slider.minValue then
      return
    end
    DataModel.BuySpaceNum = DataModel.BuySpaceNum - 1
    View.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BuySpaceNum)
    Controller:RefreshBuyTipsMoney(DataModel.BuySpaceNum)
  end,
  PrisonWarehouseBuy_Btn_Add_Click = function(btn, str)
    if DataModel.BuySpaceNum + 1 > View.Group_Slider.Slider_Value.slider.maxValue then
      return
    end
    DataModel.BuySpaceNum = DataModel.BuySpaceNum + 1
    View.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BuySpaceNum)
    Controller:RefreshBuyTipsMoney(DataModel.BuySpaceNum)
  end,
  PrisonWarehouseBuy_Btn_Max_Click = function(btn, str)
    local maxValue = math.floor(View.Group_Slider.Slider_Value.slider.maxValue + 0.5)
    DataModel.BuySpaceNum = 0 < maxValue and maxValue or 1
    View.Group_Slider.Slider_Value.self:SetSliderValue(DataModel.BuySpaceNum)
    Controller:RefreshBuyTipsMoney(DataModel.BuySpaceNum)
  end,
  PrisonWarehouseBuy_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack()
  end,
  PrisonWarehouseBuy_Btn_Sale_Click = function(btn, str)
    Controller:ConfirmBuy()
  end,
  PrisonWarehouseBuy_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  PrisonWarehouseBuy_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  PrisonWarehouseBuy_Group_DiamondCount_Btn_Diamond_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end,
  PrisonWarehouseBuy_Group_DiamondCount_Btn_Add_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end
}
return ViewFunction
