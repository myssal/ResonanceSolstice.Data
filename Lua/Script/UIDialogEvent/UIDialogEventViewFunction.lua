local View = require("UIDialogEvent/UIDialogEventView")
local DataModel = require("UIDialogEvent/UIDialogEventDataModel")
local Controller = require("UIDialogEvent/UIDialogEventController")
local ViewFunction = {
  DialogEvent_Img_BG_Group_OneOption_Btn_Option_000_Click = function(btn, str)
    Controller.OnSelectClick(1)
  end,
  DialogEvent_Img_BG_Group_TwoOption_Btn_Option_000_Click = function(btn, str)
    Controller.OnSelectClick(1)
  end,
  DialogEvent_Img_BG_Group_TwoOption_Btn_Option_001_Click = function(btn, str)
    Controller.OnSelectClick(2)
  end
}
return ViewFunction
