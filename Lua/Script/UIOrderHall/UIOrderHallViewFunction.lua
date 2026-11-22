local View = require("UIOrderHall/UIOrderHallView")
local DataModel = require("UIOrderHall/UIOrderHallDataModel")
local Controller = require("UIOrderHall/UIOrderHallController")
local ViewFunction = {
  OrderHall_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  OrderHall_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  OrderHall_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  OrderHall_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  OrderHall_Group_Order_Group_Order_Btn__Click = function(btn, str)
  end,
  OrderHall_Group_Order_StaticGrid_Order_SetGrid = function(element, elementIndex)
    Controller:SetOrderElement(element, elementIndex)
  end,
  OrderHall_Group_Order_StaticGrid_Order_Group_Order_Btn__Click = function(btn, str)
    Controller:SelectOrder(tonumber(str))
  end,
  OrderHall_Group_Hall_Btn_Reresh_Click = function(btn, str)
    Controller:TryRefreshHallOrder()
  end,
  OrderHall_Group_Hall_Btn_Received_Click = function(btn, str)
    Controller:SwitchTab(2)
  end,
  OrderHall_Group_Invite_Btn_ReturnHall_Click = function(btn, str)
    Controller:SwitchTab(1)
  end,
  OrderHall_Group_OrderInfo_Group_Team_StaticGrid_Member_SetGrid = function(element, elementIndex)
    Controller:SetTeamMemberElement(element, elementIndex)
  end,
  OrderHall_Group_OrderInfo_Group_Team_Btn_Join_Click = function(btn, str)
    Controller:TryJoinOrder()
  end,
  OrderHall_Group_OrderInfo_Group_Reward_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetRewardElement(element, elementIndex)
  end,
  OrderHall_Group_OrderInfo_Group_Reward_ScrollGrid_Reward_Group_Item_Btn__Click = function(btn, str)
    CommonTips.OpenRewardDetail(str)
  end,
  OrderHall_Btn_SerchOrder_Click = function(btn, str)
    Net:SendProto("quest.list", function(json)
      if json.quests.activity_day_quests then
        PlayerData.ServerData.quests.activity_day_quests = json.quests.activity_day_quests
      end
      PlayerData.ServerData.liveness_rewards = json.liveness_rewards
      UIManager:Open("UI/StageQuest/StageQuest", Json.encode({titleIndex = 4, orderTab = 2}))
    end, EnumDefine.QuestListDefine.BattlePassQuest)
  end,
  OrderHall_Group_Hall_Group_FilterTitle_Btn__Click = function(btn, str)
    local isActive = View.Group_Hall.Group_Filter.self.gameObject.activeSelf
    Controller.ShowSort(not isActive)
  end,
  OrderHall_Group_Hall_Group_Filter_StaticGrid__SetGrid = function(element, elementIndex)
    element.Group_UnSelect:SetActive(elementIndex ~= DataModel.sortType)
    element.Btn_Switch:SetClickParam(elementIndex)
  end,
  OrderHall_Group_Hall_Group_Filter_StaticGrid__Group_Select_Btn_Switch_Click = function(btn, str)
    if Controller.SelectSortType(tonumber(str)) then
      Controller:OpenHallPanel(true)
    end
  end,
  OrderHall_Group_OrderInfo_Group_Team_StaticGrid_Member_Group_Member_Btn_Switch_Click = function(btn, str)
  end
}
return ViewFunction
