local View = require("UIItemPrompt_Witches/UIItemPrompt_WitchesView")
local DataModel = require("UIItemPrompt_Witches/UIItemPrompt_WitchesDataModel")
local ViewFunction = {
  ItemPrompt_Witches_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenItem({itemId = itemId})
  end,
  ItemPrompt_Witches_Btn_Cancel_Witches_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Cancel()
  end,
  ItemPrompt_Witches_Btn_Confirm_Witches_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Confirm()
  end
}
return ViewFunction
