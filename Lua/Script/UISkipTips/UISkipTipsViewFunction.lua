local View = require("UISkipTips/UISkipTipsView")
local DataModel = require("UISkipTips/UISkipTipsDataModel")
local ViewFunction = {
  SkipTips_Group_Page2_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  SkipTips_Group_Page2_Btn_Sale_Click = function(btn, str)
    View.self:Confirm()
    UIManager:GoBack(false)
  end
}
return ViewFunction
