local View = require("UIGroup_ShowGuka/UIGroup_ShowGukaView")
local DataModel = require("UIGroup_ShowGuka/UIGroup_ShowGukaDataModel")
local ViewFunction = {
  Group_ShowGuka_Btn_Close_Click = function(btn, str)
    View.self:Confirm()
    View.self:CloseUI()
  end
}
return ViewFunction
