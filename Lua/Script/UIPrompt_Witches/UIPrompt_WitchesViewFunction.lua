local View = require("UIPrompt_Witches/UIPrompt_WitchesView")
local DataModel = require("UIPrompt_Witches/UIPrompt_WitchesDataModel")
local ViewFunction = {
  Prompt_Witches_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end,
  Prompt_Witches_Btn_Cancel_Witches_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Cancel()
  end,
  Prompt_Witches_Btn_Confirm_Witches_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Confirm()
  end,
  Prompt_Witches_Group_Tip_Txt_Tip_Btn_Tip_Click = function(btn, str)
  end
}
return ViewFunction
