local View = require("UIAD/UIADView")
local DataModel = require("UIAD/UIADDataModel")
local Controller = require("UIAD/UIADController")
local ViewFunction = {
  AD_Btn_Close_Click = function(btn, str)
    Controller:Close()
  end,
  AD_Btn_AD_Click = function(btn, str)
    Controller:ClickAD()
  end
}
return ViewFunction
