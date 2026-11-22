local View = require("UIMachineLevelTip/UIMachineLevelTipView")
local DataModel = require("UIMachineLevelTip/UIMachineLevelTipDataModel")
local ViewFunction = {
  MachineLevelTip_Btn_Close_Click = function(btn, str)
    UIManager:CloseTip("UI/Home_MachiningLathe/MachineLevelTip")
  end
}
return ViewFunction
