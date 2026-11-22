local View = require("UIPrisonDormOpenSuccess/UIPrisonDormOpenSuccessView")
local DataModel = require("UIPrisonDormOpenSuccess/UIPrisonDormOpenSuccessDataModel")
local ViewFunction = {
  PrisonDormOpenSuccess_Btn_Mask_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Confirm()
  end
}
return ViewFunction
