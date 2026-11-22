local View = require("UIDownload/UIDownloadView")
local DataModel = require("UIDownload/UIDownloadDataModel")
local Controller = require("UIDownload/UIDownloadController")
local ViewFunction = {
  Download_Btn_BG_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  Download_Group_Prompt_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  Download_Group_Prompt_Btn_Confirm_Click = function(btn, str)
    Controller.OnClickDownload()
  end,
  Download_Group_PromptNew_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  Download_Group_PromptNew_Btn_Confirm_Click = function(btn, str)
    Controller.OnClickDownload()
  end,
  Download_Group_PromptNew_Group_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Download_Group_PromptNew_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller.SetElement(element, elementIndex)
  end,
  Download_Group_PromptNew_Group_Reward_StaticGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller.SetItemBtn(str)
  end,
  Download_Group_Reward_Group_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Download_Group_Reward_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller.SetElement(element, elementIndex)
  end,
  Download_Group_Reward_Group_Reward_StaticGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller.SetItemBtn(str)
  end,
  Download_Group_Reward_Btn_Retry_Click = function(btn, str)
    Controller.OnClickDownload()
  end,
  Download_Group_Reward_Btn_Reward_Click = function(btn, str)
    Controller.OnClickReward()
  end,
  Download_Group_Loading_Btn_Retry_Click = function(btn, str)
    Controller.OnClickDownload()
  end
}
return ViewFunction
