local View = require("UIArrestTips/UIArrestTipsView")
local DataModel = require("UIArrestTips/UIArrestTipsDataModel")
local ViewFunction = {
  ArrestTips_Btn_BG_Click = function(btn, str)
    UIManager:GoBack(false, 1)
    View.self:Cancel()
  end,
  ArrestTips_Group_Item_Btn_Item_Click = function(btn, str)
    DataModel:ShowItemDetails(str)
  end,
  ArrestTips_Btn_Min_Click = function(btn, str)
    DataModel:SetSelectNum(1)
  end,
  ArrestTips_Btn_Dec_Click = function(btn, str)
    DataModel:SetSelectNum(math.max(1, DataModel.curSelectNum - 1))
  end,
  ArrestTips_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel:OnSliderValue(value)
  end,
  ArrestTips_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  ArrestTips_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  ArrestTips_Btn_Add_Click = function(btn, str)
    DataModel:SetSelectNum(math.max(1, math.min(DataModel.maxNum, DataModel.curSelectNum + 1)))
  end,
  ArrestTips_Btn_Max_Click = function(btn, str)
    DataModel:SetSelectNum(math.max(1, DataModel.maxNum))
  end,
  ArrestTips_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack(false, 1)
    View.self:Cancel()
  end,
  ArrestTips_Btn_Sale_Click = function(btn, str)
    DataModel:DoArrest()
  end
}
return ViewFunction
