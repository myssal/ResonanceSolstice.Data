local View = require("UIStealResultIn/UIStealResultInView")
local DataModel = require("UIStealResultIn/UIStealResultInDataModel")
local ViewFunction = {
  StealResultIn_Btn_OK_Click = function(btn, str)
    View.self:CloseUI()
  end,
  StealResultIn_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end
}
return ViewFunction
