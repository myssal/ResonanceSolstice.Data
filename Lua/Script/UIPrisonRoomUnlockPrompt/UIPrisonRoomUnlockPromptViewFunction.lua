local View = require("UIPrisonRoomUnlockPrompt/UIPrisonRoomUnlockPromptView")
local DataModel = require("UIPrisonRoomUnlockPrompt/UIPrisonRoomUnlockPromptDataModel")
local ViewFunction = {
  PrisonRoomUnlockPrompt_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end,
  PrisonRoomUnlockPrompt_Btn_Cancel_Click = function(btn, str)
    View.self:CloseUI()
  end,
  PrisonRoomUnlockPrompt_Btn_Confirm_Click = function(btn, str)
    local areaIndex = DataModel.areaIndex
    local areaId = PrisonData.CellRoomAreaIndexToAreaIdMap[areaIndex]
    
    local function callBack(json)
      View.self:CloseUI()
      View.self:Confirm()
      UIManager:Open("UI/Prison/Main/PrisonAccomodation/OpenRoomSuccess", nil, function()
        if json.reward then
          CommonTips.OpenShowItem(json.reward)
        end
      end)
      PrisonCellController.InitPlacedFur(DataModel.roomIndex, areaId)
    end
    
    PrisonData.OpenPrisonerRoomCell(callBack, DataModel.roomIndex, areaId)
  end,
  PrisonRoomUnlockPrompt_Group_Prompt_Group_Material_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tostring(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PrisonRoomUnlockPrompt_Group_Tip_Txt_Tip_Btn_Tip_Click = function(btn, str)
  end
}
return ViewFunction
