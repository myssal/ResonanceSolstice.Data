local View = require("UIRogueItemReplace/UIRogueItemReplaceView")
local DataModel = require("UIRogueItemReplace/UIRogueItemReplaceDataModel")
local Controller = require("UIRogueItemReplace/UIRogueItemReplaceController")
local ViewFunction = {
  RogueItemReplace_Group_Change_Group_New_Group_Buff_Btn__Click = function(btn, str)
  end,
  RogueItemReplace_Btn_Del_Click = function(btn, str)
    Controller.Cancel()
  end,
  RogueItemReplace_Btn_Sure_Click = function(btn, str)
    Controller.Confirm()
  end,
  RogueItemReplace_Group_Change_Group_Old_ScrollGrid_ItemOld_SetGrid = function(element, elementIndex)
    local data = PlayerData.TempCache.CubeRogueData.inside_item[elementIndex]
    Controller.ShowItem(element, data, elementIndex)
  end,
  RogueItemReplace_Group_Change_Group_Old_ScrollGrid_ItemOld_Group_Buff_Btn__Click = function(btn, str)
    Controller.Select(tonumber(str))
  end
}
return ViewFunction
