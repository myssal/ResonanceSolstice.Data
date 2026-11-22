local View = require("UIIslandTask/UIIslandTaskView")
local DataModel = require("UIIslandTask/UIIslandTaskDataModel")
local Controller = require("UIIslandTask/UIIslandTaskController")
local ViewFunction = {
  IslandTask_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  IslandTask_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  IslandTask_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  IslandTask_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  IslandTask_Group_Main_ScrollGrid__SetGrid = function(element, elementIndex)
    Controller:RefreshElement(element, elementIndex)
  end,
  IslandTask_Group_Main_ScrollGrid__Group_Item_Group_Info_Group_incomplete_Group_Track_Btn_Track_Click = function(btn, str)
    Controller:ClickTrace(btn, str)
  end,
  IslandTask_Group_Main_ScrollGrid__Group_Item_Group_Info_Group_incomplete_Group_Cancel_Btn_Cancel_Click = function(btn, str)
    Controller:ClickTraceCancel(btn, str)
  end,
  IslandTask_Group_Main_ScrollGrid__Group_Item_Group_Info_Group_Complete_Group_Get_Btn_Get_Click = function(btn, str)
    Controller:ClickGetReward(btn, str)
  end,
  IslandTask_Group_Main_ScrollGrid__Group_Item_Group_Info_Group_Reward_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RefreshRewardElement(element, elementIndex)
  end,
  IslandTask_Group_Main_ScrollGrid__Group_Item_Group_Info_Group_Reward_ScrollGrid_Reward_Group_Reward_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(btn, str)
  end,
  IslandTask_Group_IslandLv_Btn_Reputation_Click = function(btn, str)
  end
}
return ViewFunction
