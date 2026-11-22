local View = require("UIMedicalRoom/UIMedicalRoomView")
local DataModel = require("UIMedicalRoom/UIMedicalRoomDataModel")
local Controller = require("UIMedicalRoom/UIMedicalRoomController")
local ViewFunction = {
  MedicalRoom_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    PlayerData.ServerData.user_prison_info.medical_report = {}
    if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
      local UIPrisonDataModel = require("UIPrison/UIPrisonDataModel")
      UIPrisonDataModel.RefreshAllRoom()
      View.self:CloseUI()
    else
      View.self:CloseUI()
    end
  end,
  MedicalRoom_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    PlayerData.ServerData.user_prison_info.medical_report = {}
    UIManager:GoHome()
  end,
  MedicalRoom_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  MedicalRoom_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304353}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  MedicalRoom_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  MedicalRoom_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  MedicalRoom_Group_Report_Btn_Close_Click = function(btn, str)
    View.Group_Report:SetActive(false)
  end,
  MedicalRoom_Group_Report_Group_Report_ScrollView__Viewport_Content_Group_Cure_StaticGrid_Punish_SetGrid = function(element, elementIndex)
    Controller:SetReportCurePrisonerElement(element, elementIndex)
  end,
  MedicalRoom_Group_Report_Group_Report_ScrollView__Viewport_Content_Group_Release_StaticGrid_Punish_SetGrid = function(element, elementIndex)
    Controller:SetReportReleasePrisonerElement(element, elementIndex)
  end,
  MedicalRoom_Btn_Report_Click = function(btn, str)
    Controller:RefreshReport()
  end,
  MedicalRoom_Group_MedicalRoom_NewScrollGrid__SetGrid = function(element, elementIndex)
    Controller:SetBedElement(element, elementIndex)
  end,
  MedicalRoom_Group_MedicalRoom_NewScrollGrid__Group_Item_Group_Bed_Btn__Click = function(btn, str)
    local idx = tonumber(str)
    local row = DataModel.HealingPrisonerData[idx]
    if not row then
      return
    end
    local element = View.Group_MedicalRoom.NewScrollGrid_.grid.self:GetElementByIndex(idx - 1)
    if element then
      if element.Group_Bed.Group_Prisoner.Group_Card.self.IsActive == true then
        element.Group_Bed.Group_Prisoner.Group_Card.self:SetActive(false)
      else
        element.Group_Bed.Group_Prisoner.Group_Card.self:SetActive(true)
      end
    end
  end,
  MedicalRoom_Group_MedicalRoom_ScrollGrid__SetGrid = function(element, elementIndex)
    Controller:SetBedElement(element, elementIndex)
  end,
  MedicalRoom_Group_MedicalRoom_ScrollGrid__Group_Item_Group_Bed_Btn__Click = function(btn, str)
  end
}
return ViewFunction
