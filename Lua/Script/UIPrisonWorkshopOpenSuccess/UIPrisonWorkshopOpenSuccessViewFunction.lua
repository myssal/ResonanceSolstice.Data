local View = require("UIPrisonWorkshopOpenSuccess/UIPrisonWorkshopOpenSuccessView")
local DataModel = require("UIPrisonWorkshopOpenSuccess/UIPrisonWorkshopOpenSuccessDataModel")
local ViewFunction = {
  PrisonWorkshopOpenSuccess_Btn_Mask_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Confirm()
  end
}
return ViewFunction
