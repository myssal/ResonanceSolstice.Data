local View = require("UIDailyAttendance/UIDailyAttendanceView")
local DataModel = require("UIDailyAttendance/UIDailyAttendanceDataModel")
local Controller = require("UIDailyAttendance/UIDailyAttendanceController")
local Timer = require("Common/Timer")
local ViewFunction = {
  DailyAttendance_Img_BG_Group_Top_Group_Item_Btn_AccumulationItem_Click = function(btn, str)
  end,
  DailyAttendance_Img_BG_Group_Top_StaticGrid_AccumulationItem_SetGrid = function(element, elementIndex)
    Controller:SetTotalSignInItemElement(element, elementIndex)
  end,
  DailyAttendance_Img_BG_Group_Top_StaticGrid_AccumulationItem_Group_Item_Btn_AccumulationItem_Click = function(btn, str)
    local idx = tonumber(str)
    local rewardId = DataModel.TotalSignRewardCfg[idx].id
    CommonTips.OpenPreItemTips({itemId = rewardId})
  end,
  DailyAttendance_Img_BG_Group_Main_StaticGrid_DayItem_SetGrid = function(element, elementIndex)
    Controller:SetDayItemElement(element, elementIndex)
  end,
  DailyAttendance_Img_BG_Group_Main_StaticGrid_DayItem_Group_DayItem_Btn_Item_Click = function(btn, str)
    local idx = tonumber(str)
    Controller:ClickDayItem(idx)
  end,
  DailyAttendance_Img_BG_Group_Main_ScrollGrid_Month_SetGrid = function(element, elementIndex)
    Controller:SetMonthItemElement(element, elementIndex)
  end,
  DailyAttendance_Img_BG_Group_Main_ScrollGrid_Month_Group_Item_Btn_Month_Click = function(btn, str)
    local idx = tonumber(str)
    Controller:ClickMonthItem(idx)
  end,
  DailyAttendance_Img_BG_Group_Bottom_Img_MonthCardBG_Group_MonthCardItem_Btn_MonthCardItem_Click = function(btn, str)
  end,
  DailyAttendance_Img_BG_Group_Bottom_Img_MonthCardBG_StaticGrid_MonthCardItem_SetGrid = function(element, elementIndex)
    Controller:SetMonthCardItemElement(element, elementIndex)
  end,
  DailyAttendance_Img_BG_Group_Bottom_Img_MonthCardBG_StaticGrid_MonthCardItem_Group_MonthCardItem_Btn_MonthCardItem_Click = function(btn, str)
    local idx = tonumber(str)
    local rewardId = DataModel.MonthCardReward[idx].id
    CommonTips.OpenPreItemTips({itemId = rewardId})
  end,
  DailyAttendance_Img_BG_Group_Bottom_Img_MonthCardBG_Group_RewardItem_Img_RewardItemBG_Btn_RewardItem_Click = function(btn, str)
    local rewardId = DataModel.RewardCfg[DataModel.CurSelectDay].id
    CommonTips.OpenPreItemTips({itemId = rewardId})
  end,
  DailyAttendance_Img_BG_Group_Bottom_Img_MonthCardBG_Group_RewardItem_Btn_RewardSign_Click = function(btn, str)
    Controller:TrySign()
  end,
  DailyAttendance_Img_BG_Group_Birthday_Btn_Letter_Click = function(btn, str)
    Controller:ClickLetter(str)
  end,
  DailyAttendance_Img_BG_Group_Birthday_Group_BirthdayCard_Btn_Close_Click = function(btn, str)
    View.self:PlayAnim("BirthdayOut")
    DataModel.CurSelectBirthDayRoleIdx = 1
  end,
  DailyAttendance_Img_BG_Group_Birthday_Group_BirthdayCard_Group_Multiple_Btn_Right_Click = function(btn, str)
    Controller:ClickLetterRightBtn()
  end,
  DailyAttendance_Img_BG_Group_Birthday_Group_BirthdayCard_Group_Multiple_Btn_Left_Click = function(btn, str)
    Controller:ClickLetterLeftBtn()
  end,
  DailyAttendance_Img_BG_Group_Birthday_Group_BirthdayCard_Img_BirthdayCard_Btn_BirthdayItem_Click = function(btn, str)
    CommonTips.OpenPreItemTips({
      itemId = DataModel.CurBirthDayCakeItemId
    })
  end,
  DailyAttendance_Img_BG_Group_Bottom_Img_MonthCardBG_Group_RewardItem_Btn_NotTime_Click = function(btn, str)
  end,
  DailyAttendance_Img_BG_Group_Bottom_Img_MonthCardBG_Group_RewardItem_Btn_Pass_Click = function(btn, str)
  end,
  DailyAttendance_Img_BG_Group_Bottom_Img_MonthCardBG_Group_RewardItem_Btn_Signed_Click = function(btn, str)
  end,
  DailyAttendance_Btn_Close_Click = function(btn, str)
    local MainView = require("UIMainUI/UIMainUIView")
    MainView.timer_2 = Timer.New(1, function()
      CommonTips.OpenMainUITips()
      MainView.timer_2:Stop()
      MainView.timer_2 = nil
    end)
    MainView.timer_2:Start()
    View.self:PlayAnim("Out")
    if DataModel.isAutoShow then
      UIManager:CloseTip("UI/DailyAttendance/DailyAttendance")
    else
      UIManager:GoBack()
    end
  end,
  DailyAttendance_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.self:PlayAnim("Out")
    UIManager:GoBack()
  end,
  DailyAttendance_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    View.self:PlayAnim("Out")
    UIManager:CloseTip("UI/DailyAttendance/DailyAttendance")
  end,
  DailyAttendance_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  DailyAttendance_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  DailyAttendance_Img_BG_Group_Bottom_Img_MonthCardBG_Group_RewardItem_Btn_SignType_Click = function(btn, str)
  end
}
return ViewFunction
