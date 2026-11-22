local View = require("UIEntrustOpenTips/UIEntrustOpenTipsView")
local DataModel = require("UIEntrustOpenTips/UIEntrustOpenTipsDataModel")
local ViewFunction = {
  EntrustOpenTips_Btn_Open_Click = function(btn, str)
    UIManager:Open("UI/Entrust/Entrust")
  end
}
return ViewFunction
