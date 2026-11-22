local View = require("UIPrisonWarehouseOption/UIPrisonWarehouseOptionView")
local DataModel = require("UIPrisonWarehouseOption/UIPrisonWarehouseOptionDataModel")
local Controller = require("UIPrisonWarehouseOption/UIPrisonWarehouseOptionController")
local ViewFunction = {
  PrisonWarehouseOption_Btn_BG_Click = function(btn, str)
    Controller:Return()
  end,
  PrisonWarehouseOption_Group_Buy_Btn__Click = function(btn, str)
    Controller:ClickElement(DataModel.EnumType.Buy)
  end,
  PrisonWarehouseOption_Group_Expand_Btn__Click = function(btn, str)
    Controller:ClickElement(DataModel.EnumType.Expand)
  end
}
return ViewFunction
