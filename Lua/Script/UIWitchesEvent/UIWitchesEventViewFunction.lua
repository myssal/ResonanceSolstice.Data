local View = require("UIWitchesEvent/UIWitchesEventView")
local DataModel = require("UIWitchesEvent/UIWitchesEventDataModel")
local ViewFunction = {
  WitchesEvent_Img_BG_Group_OneOption_Btn_Option_000_Click = function(btn, str)
    DataModel.SelectOption(1)
  end,
  WitchesEvent_Img_BG_Group_TwoOption_Btn_Option_000_Click = function(btn, str)
    DataModel.SelectOption(1)
  end,
  WitchesEvent_Img_BG_Group_TwoOption_Btn_Option_001_Click = function(btn, str)
    DataModel.SelectOption(2)
  end,
  WitchesEvent_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    DataModel.ReturnEvent()
  end,
  WitchesEvent_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  WitchesEvent_Group_Coin_Btn__Click = function(btn, str)
  end
}
return ViewFunction
