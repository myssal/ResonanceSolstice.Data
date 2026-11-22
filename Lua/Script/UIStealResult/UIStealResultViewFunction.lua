local View = require("UIStealResult/UIStealResultView")
local DataModel = require("UIStealResult/UIStealResultDataModel")
local ViewFunction = {
  StealResult_Btn_OK_Click = function(btn, str)
    View.self:CloseUI()
  end,
  StealResult_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end
}
return ViewFunction
