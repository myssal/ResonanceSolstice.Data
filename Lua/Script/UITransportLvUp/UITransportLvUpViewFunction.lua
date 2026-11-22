local View = require("UITransportLvUp/UITransportLvUpView")
local DataModel = require("UITransportLvUp/UITransportLvUpDataModel")
local ViewFunction = {
  TransportLvUp_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
