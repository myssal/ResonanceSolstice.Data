local View = require("UITokenPayTipsPlus/UITokenPayTipsPlusView")
local DataModel = require("UITokenPayTipsPlus/UITokenPayTipsPlusDataModel")
local ViewController = require("UITokenPayTipsPlus/UITokenPayTipsPlusViewController")
local ViewFunction = {
  TokenPayTipsPlus_Btn_Close_Click = function(btn, str)
  end,
  TokenPayTipsPlus_Btn_Affirm_Click = function(btn, str)
    ViewController:Confirm()
  end,
  TokenPayTipsPlus_Btn_Cancel_Click = function(btn, str)
    ViewController:Cancel()
  end,
  TokenPayTipsPlus_Group_Toggle_Btn_toggle_Click = function(btn, str)
    ViewController:ToggleTodayNoPrompt()
  end
}
return ViewFunction
