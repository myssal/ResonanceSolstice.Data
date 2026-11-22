local View = require("UIParoleRoom/UIParoleRoomView")
local DataModel = require("UIParoleRoom/UIParoleRoomDataModel")
local Controller = require("UIParoleRoom/UIParoleRoomController")
local ViewFunction = {
  ParoleRoom_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if View.Group_LawyerList.self.IsActive == true then
      View.self:PlayAnimOnce("LawyerList_Back", function()
        View.Group_ParoleRoomList.Group_Prisoner:SetActive(true)
        View.Group_LawyerList:SetActive(false)
      end)
    else
      UIManager:GoBack()
    end
  end,
  ParoleRoom_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  ParoleRoom_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  ParoleRoom_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304349}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  ParoleRoom_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  ParoleRoom_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  ParoleRoom_Group_ParoleRoomList_Group_Lawyer_Btn_Stop_Click = function(btn, str)
    Controller:TryDoEmploy(-1, false)
  end,
  ParoleRoom_Group_ParoleRoomList_Group_Lawyer_Btn_Employ_Click = function(btn, str)
  end,
  ParoleRoom_Group_LawyerList_StaticGrid__SetGrid = function(element, elementIndex)
    Controller:SetLawyerListElement(element, elementIndex)
  end,
  ParoleRoom_Group_LawyerList_StaticGrid__Group_Lawyer_Btn_Stop_Click = function(btn, str)
    Controller:TryDoEmploy(tonumber(str), false)
  end,
  ParoleRoom_Group_LawyerList_StaticGrid__Group_Lawyer_Btn_Employ_Click = function(btn, str)
    Controller:TryDoEmploy(tonumber(str), true)
  end,
  ParoleRoom_Group_LawyerList_Btn_Refresh_Click = function(btn, str)
    Controller:TryRefreshLawyer()
  end,
  ParoleRoom_Group_ParoleRoomList_Group_NoLawyer_Btn__Click = function(btn, str)
    View.Group_LawyerList:SetActive(true)
    View.self:PlayAnimOnce("LawyerList_In", function()
      View.Group_ParoleRoomList.Group_Prisoner:SetActive(false)
    end)
    Controller:RefreshLawyerList()
  end,
  ParoleRoom_Group_LawyerSuccess_Group_Lawyer_Btn_Stop_Click = function(btn, str)
  end,
  ParoleRoom_Group_LawyerSuccess_Group_Lawyer_Btn_Employ_Click = function(btn, str)
  end,
  ParoleRoom_ParoleRoomPrompt_Btn_Confirm_Click = function(btn, str)
    Controller:TryParole()
  end,
  ParoleRoom_ParoleRoomPrompt_Btn_Cancel_Click = function(btn, str)
    DataModel.ChoosePrisonerList = {}
    View.ParoleRoomPrompt:SetActive(false)
  end,
  ParoleRoom_Group_ParoleRoomList_Group_Title_Group_LowestScore_Btn__Click = function(btn, str)
    View.Group_Tips:SetActive(true)
  end,
  ParoleRoom_Group_ParoleRoomList_Group_Prisoner_Group_Paixu_Btn_Choose_Click = function(btn, str)
    if View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Group_Choose.self.IsActive == true then
      View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Group_Choose:SetActive(false)
    else
      View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Group_Choose:SetActive(true)
      View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Group_Choose.Group_Time.Group_TimeLight:SetActive(DataModel.SortState.index == 1)
      View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Group_Choose.Group_Time.Btn_Time.Img_:SetActive(DataModel.SortState.index == 2)
      View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Group_Choose.Group_Score.Group_ScoreLight:SetActive(DataModel.SortState.index == 2)
      View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Group_Choose.Group_Score.Btn_Score.Img_:SetActive(DataModel.SortState.index == 1)
    end
  end,
  ParoleRoom_Group_ParoleRoomList_Group_Prisoner_Group_Paixu_Btn_Paixu_Click = function(btn, str)
    DataModel.SortState.currentDown = not DataModel.SortState.currentDown
    Controller:RefreshPrisonerList()
    View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Img_PaixuSheng:SetActive(not DataModel.SortState.currentDown)
    View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Img_PaixuJiang:SetActive(DataModel.SortState.currentDown)
  end,
  ParoleRoom_Group_ParoleRoomList_Group_Prisoner_Group_Paixu_Group_Choose_Group_Time_Btn_Time_Click = function(btn, str)
    DataModel.SortState.index = 1
    Controller:RefreshPrisonerList()
    View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Group_Choose:SetActive(false)
    View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Txt_:SetText(GetText(80608524))
  end,
  ParoleRoom_Group_ParoleRoomList_Group_Prisoner_Group_Paixu_Group_Choose_Group_Score_Btn_Score_Click = function(btn, str)
    DataModel.SortState.index = 2
    Controller:RefreshPrisonerList()
    View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Group_Choose:SetActive(false)
    View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Txt_:SetText(GetText(80608525))
  end,
  ParoleRoom_Group_LawyerList_Group_Lawyer_Btn_Stop_Click = function(btn, str)
  end,
  ParoleRoom_Group_LawyerList_Group_Lawyer_Btn_Employ_Click = function(btn, str)
  end,
  ParoleRoom_Group_Tips_Btn_Close_Click = function(btn, str)
    View.Group_Tips:SetActive(false)
  end,
  ParoleRoom_Group_ParoleRoomList_Group_Prisoner_Group_Prisoner_Group_PrisonerList_ScrollView__Viewport_Content_ScrollGrid__SetGrid = function(element, elementIndex)
    Controller:SetPrisonerElement(element, elementIndex)
  end,
  ParoleRoom_Group_ParoleRoomList_Group_Prisoner_Group_Prisoner_Group_PrisonerList_ScrollView__Viewport_Content_ScrollGrid__Group_Prisoner_Group_CanRelease_Btn__Click = function(btn, str)
    local row = DataModel.SortCanParolePrisonerData[tonumber(str)]
    if row then
      table.insert(DataModel.ChoosePrisonerList, row)
      Controller:OpenPrompt(row)
    end
  end,
  ParoleRoom_Group_ParoleRoomList_Group_Prisoner_Group_Prisoner_Group_PrisonerList_Group_Prisoner_Group_CanRelease_Btn__Click = function(btn, str)
  end,
  ParoleRoom_Group_ParoleRoomList_Btn_All_Click = function(btn, str)
    Controller:OpenPromptOneBtnParole()
  end,
  ParoleRoom_Btn__Click = function(btn, str)
  end
}
return ViewFunction
