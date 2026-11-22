local View = require("UIPrisonAccomodationOpenSuccess/UIPrisonAccomodationOpenSuccessView")
local DataModel = require("UIPrisonAccomodationOpenSuccess/UIPrisonAccomodationOpenSuccessDataModel")
local ViewFunction = {
  PrisonAccomodationOpenSuccess_Btn_Mask_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Confirm()
  end
}
return ViewFunction
