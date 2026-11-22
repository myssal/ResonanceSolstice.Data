local View = require("UILanguageSwitch/UILanguageSwitchView")
local DataModel = require("UILanguageSwitch/UILanguageSwitchDataModel")
local ViewFunction = {
  LanguageSwitch_Group_Confirm_Btn_Confirm_Click = function(btn, str)
  end,
  LanguageSwitch_Group_Confirm_Btn_Cancel_Click = function(btn, str)
  end,
  LanguageSwitch_Group_DownLoad_Btn_Cancel_Click = function(btn, str)
    DataModel:CancelDownload()
  end
}
return ViewFunction
