local View = require("UIEvent/UIEventView")
local DataModel = require("UIEvent/UIEventDataModel")
local Controller = require("UIEvent/UIEventController")
local ViewFunction = {
  Event_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller.Close()
  end,
  Event_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  Event_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Event_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Event_Group_Filter_Btn_All_Click = function(btn, str)
    Controller.OnTabClick(1)
  end,
  Event_Group_Filter_Btn_Unlock_Click = function(btn, str)
    Controller.OnTabClick(2)
  end,
  Event_Group_Filter_Btn_Lock_Click = function(btn, str)
    Controller.OnTabClick(3)
  end,
  Event_ScrollGrid_EventList_SetGrid = function(element, elementIndex)
    Controller.RefreshEventElement(element, elementIndex)
  end,
  Event_ScrollGrid_EventList_Group_Item_Btn_Event_Click = function(btn, str)
  end,
  Event_Btn_Rewards_Click = function(btn, str)
    Controller.OnEventRewardClick()
  end
}
return ViewFunction
