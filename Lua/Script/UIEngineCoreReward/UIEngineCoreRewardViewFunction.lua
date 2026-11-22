local View = require("UIEngineCoreReward/UIEngineCoreRewardView")
local DataModel = require("UIEngineCoreReward/UIEngineCoreRewardDataModel")
local Controller = require("UIEngineCoreReward/UIEngineCoreRewardController")
local ViewFunction = {
  EngineCoreReward_Btn_BG_Click = function(btn, str)
    UIManager:GoBack()
  end,
  EngineCoreReward_ScrollGrid_Tab_SetGrid = function(element, elementIndex)
    Controller.RefreshCoreElementShow(element, elementIndex)
  end,
  EngineCoreReward_ScrollGrid_Tab_Group_Item_Btn__Click = function(btn, str)
  end,
  EngineCoreReward_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller.RefreshCoreLvRewardElement(element, elementIndex)
  end,
  EngineCoreReward_ScrollGrid_List_Group_Item_Group_Can_Btn_Click_Click = function(btn, str)
  end,
  EngineCoreReward_ScrollGrid_List_Group_Item_Group_Reward_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller.RefreshRewardElement(element, elementIndex)
  end,
  EngineCoreReward_ScrollGrid_List_Group_Item_Group_Reward_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end
}
return ViewFunction
