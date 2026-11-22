local View = require("UITips_Witches/UITips_WitchesView")
local DataModel = require("UITips_Witches/UITips_WitchesDataModel")
local ViewFunction = {
  Tips_Witches_Btn_Mask_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
