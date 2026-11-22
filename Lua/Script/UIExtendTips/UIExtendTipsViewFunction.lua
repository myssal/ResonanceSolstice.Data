local View = require("UIExtendTips/UIExtendTipsView")
local DataModel = require("UIExtendTips/UIExtendTipsDataModel")
local Controller = require("UIExtendTips/UIExtendTipsController")
local ViewFunction = {
  ExtendTips_Btn_BG_Click = function(btn, str)
    Controller:Return()
  end,
  ExtendTips_Btn_Add_Click = function(btn, str)
    Controller:Add()
  end,
  ExtendTips_Btn_Dec_Click = function(btn, str)
    Controller:Sub()
  end,
  ExtendTips_Img_Icon_Btn__Click = function(btn, str)
    Controller:ClickItem()
  end,
  ExtendTips_Btn_Affirm_Click = function(btn, str)
    Controller:UseItem()
  end,
  ExtendTips_Btn_Cancel_Click = function(btn, str)
    Controller:Return()
  end
}
return ViewFunction
