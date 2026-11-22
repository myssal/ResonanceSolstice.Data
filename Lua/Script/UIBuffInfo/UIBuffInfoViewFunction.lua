local View = require("UIBuffInfo/UIBuffInfoView")
local DataModel = require("UIBuffInfo/UIBuffInfoDataModel")
local ViewFunction = {
  BuffInfo_Btn__Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  BuffInfo_Group_Buff_Btn__Click = function(btn, str)
  end
}
return ViewFunction
