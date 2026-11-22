local View = require("UIPrisonUpgradeSuccess/UIPrisonUpgradeSuccessView")
local DataModel = require("UIPrisonUpgradeSuccess/UIPrisonUpgradeSuccessDataModel")
local ViewFunction = {
  PrisonUpgradeSuccess_Btn_Mask_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
