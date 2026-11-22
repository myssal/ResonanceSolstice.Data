local View = require("UIExtend/UIExtendView")
local DataModel = require("UIExtend/UIExtendDataModel")
local Controller = require("UIExtend/UIExtendController")
local ViewFunction = {
  Extend_Btn_Close_Click = function(btn, str)
    Controller:Close()
  end,
  Extend_StaticGrid_Cost_SetGrid = function(element, elementIndex)
    Controller:RefreshElement(element, elementIndex)
  end,
  Extend_StaticGrid_Cost_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickItem(btn, str)
  end,
  Extend_Btn_Cancel_Click = function(btn, str)
    Controller:Close()
  end,
  Extend_Btn_Confirm_Click = function(btn, str)
    Controller:Confirm()
  end
}
return ViewFunction
