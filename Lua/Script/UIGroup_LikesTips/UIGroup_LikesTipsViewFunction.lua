local View = require("UIGroup_LikesTips/UIGroup_LikesTipsView")
local DataModel = require("UIGroup_LikesTips/UIGroup_LikesTipsDataModel")
local ViewFunction = {
  Group_LikesTips_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
