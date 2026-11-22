local View = require("UIStopTips/UIStopTipsView")
local DataModel = require("UIStopTips/UIStopTipsDataModel")
local ViewFunction = {
  StopTips_Btn_Return_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Cancel()
  end,
  StopTips_Btn_Cancel_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Cancel()
  end,
  StopTips_Btn_Confirm_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Confirm()
  end
}
return ViewFunction
