local View = require("UIPrisonExtendTips/UIPrisonExtendTipsView")
local DataModel = require("UIPrisonExtendTips/UIPrisonExtendTipsDataModel")
local Controller = require("UIPrisonExtendTips/UIPrisonExtendTipsController")
local ViewFunction = {
  PrisonExtendTips_Btn_BG_Click = function(btn, str)
    Controller:Return()
  end,
  PrisonExtendTips_Btn_Add_Click = function(btn, str)
    Controller:Add()
  end,
  PrisonExtendTips_Btn_Dec_Click = function(btn, str)
    Controller:Sub()
  end,
  PrisonExtendTips_Img_Icon_Btn__Click = function(btn, str)
    Controller:ClickItem()
  end,
  PrisonExtendTips_Btn_Affirm_Click = function(btn, str)
    Controller:UseItem()
  end,
  PrisonExtendTips_Btn_Cancel_Click = function(btn, str)
    Controller:Return()
  end
}
return ViewFunction
