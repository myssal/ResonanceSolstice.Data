local View = require("UIPrisonPowerRoomPrompt/UIPrisonPowerRoomPromptView")
local DataModel = require("UIPrisonPowerRoomPrompt/UIPrisonPowerRoomPromptDataModel")
local ViewFunction = {
  PrisonPowerRoomPrompt_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end,
  PrisonPowerRoomPrompt_Btn_Cancel_Click = function(btn, str)
    View.self:CloseUI()
  end,
  PrisonPowerRoomPrompt_Btn_Confirm_Click = function(btn, str)
    local function callBack()
      View.self:Confirm()
      
      View.self:CloseUI()
      CommonTips.OpenTips(80608644)
    end
    
    PrisonData.SetPowerSocket(callBack)
  end,
  PrisonPowerRoomPrompt_Group_Prompt_Group_Material_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PrisonPowerRoomPrompt_Group_Prompt_Group_Material_Group_Item1_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PrisonPowerRoomPrompt_Group_Tip_Txt_Tip_Btn_Tip_Click = function(btn, str)
  end
}
return ViewFunction
