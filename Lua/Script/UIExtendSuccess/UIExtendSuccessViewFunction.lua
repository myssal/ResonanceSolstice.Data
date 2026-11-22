local View = require("UIExtendSuccess/UIExtendSuccessView")
local DataModel = require("UIExtendSuccess/UIExtendSuccessDataModel")
local ViewFunction = {
  ExtendSuccess_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
