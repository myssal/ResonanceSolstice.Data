local View = require("UIItemUse/UIItemUseView")
local DataModel = require("UIItemUse/UIItemUseDataModel")
local ViewFunction = {
  ItemUse_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end,
  ItemUse_Group_Use_Btn_Del_Click = function(btn, str)
    View.self:CloseUI()
  end,
  ItemUse_Group_Use_Btn_Sure_Click = function(btn, str)
    DataModel.UseItem(DataModel.itemId, DataModel.index)
  end,
  ItemUse_Group_Use_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end
}
return ViewFunction
