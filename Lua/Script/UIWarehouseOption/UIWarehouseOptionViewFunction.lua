local View = require("UIWarehouseOption/UIWarehouseOptionView")
local DataModel = require("UIWarehouseOption/UIWarehouseOptionDataModel")
local Controller = require("UIWarehouseOption/UIWarehouseOptionController")
local ViewFunction = {
  WarehouseOption_Btn_BG_Click = function(btn, str)
    Controller:Return()
  end,
  WarehouseOption_Group_Buy_Btn__Click = function(btn, str)
    Controller:ClickElement(DataModel.EnumType.Buy)
  end,
  WarehouseOption_Group_Expand_Btn__Click = function(btn, str)
    Controller:ClickElement(DataModel.EnumType.Expand)
  end,
  WarehouseOption_Group_Transport_Btn__Click = function(btn, str)
    Controller:ClickElement(DataModel.EnumType.Transport)
  end
}
return ViewFunction
