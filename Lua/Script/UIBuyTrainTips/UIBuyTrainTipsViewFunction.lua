local View = require("UIBuyTrainTips/UIBuyTrainTipsView")
local DataModel = require("UIBuyTrainTips/UIBuyTrainTipsDataModel")
local Controller = require("UIBuyTrainTips/UIBuyTrainTipsController")
local ViewFunction = {
  BuyTrainTips_Btn_BG_Click = function(btn, str)
    UIManager:GoBack()
  end,
  BuyTrainTips_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  BuyTrainTips_Btn_Min_Click = function(btn, str)
    Controller.OnMinusMaxBtnClick()
  end,
  BuyTrainTips_Btn_Dec_Click = function(btn, str)
    Controller.OnMinusOneBtnClick()
  end,
  BuyTrainTips_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel.curCount = math.modf(value)
    Controller.RefreshCountShow()
  end,
  BuyTrainTips_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  BuyTrainTips_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  BuyTrainTips_Group_Cost_Img_Btm_StaticGrid__SetGrid = function(element, elementIndex)
    Controller.RefreshCostItemElement(element, elementIndex)
  end,
  BuyTrainTips_Btn_Add_Click = function(btn, str)
    Controller.OnAddOneBtnClick()
  end,
  BuyTrainTips_Btn_Max_Click = function(btn, str)
    Controller.OnAddMaxBtnClick()
  end,
  BuyTrainTips_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack()
  end,
  BuyTrainTips_Btn_Sale_Click = function(btn, str)
    Controller.OnSaleBtnClick()
  end
}
return ViewFunction
