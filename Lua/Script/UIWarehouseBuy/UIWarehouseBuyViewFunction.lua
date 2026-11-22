local View = require("UIWarehouseBuy/UIWarehouseBuyView")
local DataModel = require("UIWarehouseBuy/UIWarehouseBuyDataModel")
local Controller = require("UIWarehouseBuy/UIWarehouseBuyController")
local ViewFunction = {
  WarehouseBuy_Btn_BG_Click = function(btn, str)
    Controller:Return()
  end,
  WarehouseBuy_Group_Slider_Slider_Value_Slider = function(slider, value)
    Controller:SliderValueChange(value)
  end,
  WarehouseBuy_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  WarehouseBuy_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  WarehouseBuy_Btn_Min_Click = function(btn, str)
    Controller:SubToMin()
  end,
  WarehouseBuy_Btn_Dec_Click = function(btn, str)
    Controller:Sub()
  end,
  WarehouseBuy_Btn_Add_Click = function(btn, str)
    Controller:Add()
  end,
  WarehouseBuy_Btn_Max_Click = function(btn, str)
    Controller:AddToMax()
  end,
  WarehouseBuy_Btn_Cancel_Click = function(btn, str)
    Controller:Return()
  end,
  WarehouseBuy_Btn_Sale_Click = function(btn, str)
    Controller:ConfirmExpand()
  end
}
return ViewFunction
