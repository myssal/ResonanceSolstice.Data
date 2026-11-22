local View = require("UIEntrust/UIEntrustView")
local DataModel = require("UIEntrust/UIEntrustDataModel")
local Controller = require("UIEntrust/UIEntrustController")
local ViewFunction = {
  Entrust_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  Entrust_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:Home()
  end,
  Entrust_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Entrust_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    Controller:ClickHelp()
  end,
  Entrust_Btn_OneGet_Click = function(btn, str)
    Controller:ClickOneKeyGetBtn()
  end,
  Entrust_Btn_Schedule_Click = function(btn, str)
    Controller:ClickSchedule()
  end,
  Entrust_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshEntrustElement(element, elementIndex)
  end,
  Entrust_ScrollGrid_List_Group_Item_Group_List_Group_Reward_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshEntrustRewardElement(element, elementIndex)
  end,
  Entrust_ScrollGrid_List_Group_Item_Group_List_Btn__Click = function(btn, str)
    Controller:ClickEntrustElement(str)
  end,
  Entrust_Group_Right_Group_Time_Group_Select_Group_Time1_Btn__Click = function(btn, str)
    Controller:ClickTimeBtn(1)
  end,
  Entrust_Group_Right_Group_Time_Group_Select_Group_Time2_Btn__Click = function(btn, str)
    Controller:ClickTimeBtn(2)
  end,
  Entrust_Group_Right_Group_Time_Group_Select_Group_Time3_Btn__Click = function(btn, str)
    Controller:ClickTimeBtn(3)
  end,
  Entrust_Group_Right_Group_Time_Group_Select_Group_Time4_Btn__Click = function(btn, str)
    Controller:ClickTimeBtn(4)
  end,
  Entrust_Group_Right_Group_Reward_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshDetailRewardElement(element, elementIndex)
  end,
  Entrust_Group_Right_Group_Reward_StaticGrid_List_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickRewardItem(str)
  end,
  Entrust_Group_Right_Group_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Entrust_Group_Right_Group_Btn_Btn__Click = function(btn, str)
    Controller:ClickEntrustBtn()
  end,
  Entrust_Group_Left_Group_Queue_Group_Role_Btn_Click_Click = function(btn, str)
  end,
  Entrust_Group_Left_Group_Queue_Group_Role_Btn_Click_LongPress = function(btn, str)
  end,
  Entrust_Group_Left_Group_Queue_StaticGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:RefreshRoleElement(element, elementIndex)
  end,
  Entrust_Group_Left_Group_Queue_StaticGrid_RoleList_Group_Role_Btn_Click_Click = function(btn, str)
    Controller:ClickRole()
  end,
  Entrust_Group_Left_Group_Queue_StaticGrid_RoleList_Group_Role_Btn_Click_LongPress = function(btn, str)
  end,
  Entrust_Group_Left_Group_Queue_Group_Recommend_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshRecommendElement(element, elementIndex)
  end,
  Entrust_Group_Select_Btn__Click = function(btn, str)
    Controller:CloseSelectRoleView()
  end,
  Entrust_Group_Select_ScrollGrid_RoleList_SetGrid = function(element, elementIndex)
    Controller:RefreshSelectPanelRoleElement(element, elementIndex)
  end,
  Entrust_Group_Select_ScrollGrid_RoleList_Group_Item_Btn_Click_Click = function(btn, str)
    Controller:ClickSelectRoleElement(str)
  end,
  Entrust_Group_Select_Group_Item_Btn_Click_Click = function(btn, str)
  end,
  Entrust_Group_Right_Group_Reward_Btn_Tip_Click = function(btn, str)
    Controller:ClickSchedule()
  end,
  Entrust_Btn_MoonCard_Click = function(btn, str)
    UIManager:Open("UI/BP_Quest/BattlePass_Quest", Json.encode({openPay = true}))
  end,
  Entrust_Group_Right_Group_Btn_Group_GetNow_Btn_GetNow_Click = function(btn, str)
    Controller:CompleteImmediately()
  end,
  Entrust_Group_Right_Group_Btn_Group_GetNow_Btn_back_Click = function(btn, str)
    Controller:ClickEntrustBtn()
  end,
  Entrust_Group_Right_Group_Btn_Group_Get_Btn_Schedule_Click = function(btn, str)
    Controller:ClickSchedule()
  end,
  Entrust_Group_Right_Group_Btn_Group_GetNow_Btn_Schedule_Click = function(btn, str)
    Controller:ClickSchedule()
  end
}
return ViewFunction
