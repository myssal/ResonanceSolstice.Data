local View = require("UIPrisonSpaceUnlockPrompt/UIPrisonSpaceUnlockPromptView")
local DataModel = require("UIPrisonSpaceUnlockPrompt/UIPrisonSpaceUnlockPromptDataModel")
local ViewFunction = {
  PrisonSpaceUnlockPrompt_Btn_BG_Click = function(btn, str)
  end,
  PrisonSpaceUnlockPrompt_Btn_Cancel_Click = function(btn, str)
    View.self:Cancel()
    UIManager:CloseTip("UI/Prison/Manage/PrisonSpaceUnlockPrompt")
  end,
  PrisonSpaceUnlockPrompt_Btn_Confirm_Click = function(btn, str)
    View.self:Confirm()
    UIManager:CloseTip("UI/Prison/Manage/PrisonSpaceUnlockPrompt")
  end,
  PrisonSpaceUnlockPrompt_Group_Prompt_Group_Material_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  PrisonSpaceUnlockPrompt_Group_Tip_Txt_Tip_Btn_Tip_Click = function(btn, str)
  end
}
return ViewFunction
