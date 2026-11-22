local View = require("UITokenPayTips/UITokenPayTipsView")
local DataModel = require("UITokenPayTips/UITokenPayTipsDataModel")
local ViewController = require("UITokenPayTips/UITokenPayTipsViewController")
local ViewFunction = {
  TokenPayTips_Btn_Close_Click = function(btn, str)
    ViewController:Cancel()
  end,
  TokenPayTips_Btn_Affirm_Click = function(btn, str)
    ViewController:OK()
  end,
  TokenPayTips_Btn_Cancel_Click = function(btn, str)
    ViewController:Cancel()
  end
}
return ViewFunction
