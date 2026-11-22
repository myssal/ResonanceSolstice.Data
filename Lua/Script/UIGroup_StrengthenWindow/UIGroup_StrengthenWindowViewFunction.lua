local View = require("UIGroup_StrengthenWindow/UIGroup_StrengthenWindowView")
local DataModel = require("UIGroup_StrengthenWindow/UIGroup_StrengthenWindowDataModel")
local ViewFunction = {
  Group_StrengthenWindow_Btn_Black_Click = function(btn, str)
    if DataModel.Data.reward and table.count(DataModel.Data.reward) > 0 then
      UIManager:GoBack(false, 1)
      CommonTips.OpenShowItem(DataModel.Data.reward)
    else
      UIManager:GoBack(false, 1)
    end
  end
}
return ViewFunction
