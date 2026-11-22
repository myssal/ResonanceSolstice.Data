local View = require("UITransportLevelTip/UITransportLevelTipView")
local DataModel = require("UITransportLevelTip/UITransportLevelTipDataModel")
local ViewFunction = {
  TransportLevelTip_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
