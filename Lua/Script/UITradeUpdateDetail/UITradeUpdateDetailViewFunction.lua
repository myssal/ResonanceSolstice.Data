local View = require("UITradeUpdateDetail/UITradeUpdateDetailView")
local DataModel = require("UITradeUpdateDetail/UITradeUpdateDetailDataModel")
local ViewFunction = {
  TradeUpdateDetail_Btn_Esc_Click = function(btn, str)
    UIManager:ClosePanel()
  end
}
return ViewFunction
