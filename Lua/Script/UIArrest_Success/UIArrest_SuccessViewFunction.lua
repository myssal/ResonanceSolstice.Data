local View = require("UIArrest_Success/UIArrest_SuccessView")
local DataModel = require("UIArrest_Success/UIArrest_SuccessDataModel")
local ViewFunction = {
  Arrest_Success_Group_Tips_Btn_Skip_Click = function(btn, str)
    UIManager:CloseTip("UI/Prison/ArrestPrisoner/Arrest_Success")
  end
}
return ViewFunction
