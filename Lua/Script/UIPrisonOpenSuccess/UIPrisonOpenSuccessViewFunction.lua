local View = require("UIPrisonOpenSuccess/UIPrisonOpenSuccessView")
local DataModel = require("UIPrisonOpenSuccess/UIPrisonOpenSuccessDataModel")
local ViewFunction = {
  PrisonOpenSuccess_Btn_Mask_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
