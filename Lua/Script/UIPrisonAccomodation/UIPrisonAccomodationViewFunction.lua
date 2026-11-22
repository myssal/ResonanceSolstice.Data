local View = require("UIPrisonAccomodation/UIPrisonAccomodationView")
local DataModel = require("UIPrisonAccomodation/UIPrisonAccomodationDataModel")
local ViewFunction = {
  PrisonAccomodation_Btn_Left_Click = function(btn, str)
    DataModel.ChangeArea(DataModel.areaIndex - 1)
  end,
  PrisonAccomodation_Btn_Light_Click = function(btn, str)
    DataModel.ChangeArea(DataModel.areaIndex + 1)
  end,
  PrisonAccomodation_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
    PrisonCellController.CloseRoom()
  end,
  PrisonAccomodation_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PrisonAccomodation_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonAccomodation_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304351}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  PrisonAccomodation_Group_Top_Group_PrisonIcon_Btn_Logo_Click = function(btn, str)
    UIManager:Open("UI/Prison/Overview/PrisonLevel/PrisonLevel")
  end,
  PrisonAccomodation_Group_Area_Group_6_Group_Locked_Group_Available_Btn_Pic_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_6_Group_Locked_Group_Available_Btn_Lock_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_6_Btn__Click = function(btn, str)
    DataModel.ChangeArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_5_Group_Locked_Group_Available_Btn_Pic_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_5_Group_Locked_Group_Available_Btn_Lock_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_5_Btn__Click = function(btn, str)
    DataModel.ChangeArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_4_Group_Locked_Group_Available_Btn_Pic_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_4_Group_Locked_Group_Available_Btn_Lock_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_4_Btn__Click = function(btn, str)
    DataModel.ChangeArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_3_Group_Locked_Group_Available_Btn_Pic_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_3_Group_Locked_Group_Available_Btn_Lock_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_3_Btn__Click = function(btn, str)
    DataModel.ChangeArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_2_Group_Locked_Group_Available_Btn_Pic_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_2_Group_Locked_Group_Available_Btn_Lock_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_2_Btn__Click = function(btn, str)
    DataModel.ChangeArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_1_Group_Locked_Group_Available_Btn_Pic_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_1_Group_Locked_Group_Available_Btn_Lock_Click = function(btn, str)
    DataModel.OpenArea(str)
  end,
  PrisonAccomodation_Group_Area_Group_1_Btn__Click = function(btn, str)
    DataModel.ChangeArea(str)
  end,
  PrisonAccomodation_Group_Top_Group_Prisoner_Btn__Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonerList/PrisonerList", Json.encode({Mode = "Prison"}))
  end,
  PrisonAccomodation_Group_Btn_Btn_MedicalAll_Click = function(btn, str)
    local list = PrisonData.GetCellRoomList()
    local u_pidList = {}
    for index, data in pairs(list) do
      for k, v in pairs(PrisonData.GetIllPrisonerInCell(tostring(index))) do
        table.insert(u_pidList, v.u_pid)
      end
    end
    if 0 < #u_pidList then
      local function callBack()
        PrisonCellController.MedicalAll(u_pidList)
        
        View.Group_Btn.Btn_MedicalAll:SetActive(false)
        CommonTips.OpenTips(string.format(GetText(80607968), #u_pidList))
      end
      
      PrisonData.SolveIll(callBack, u_pidList)
    end
  end,
  PrisonAccomodation_Group_Navigation_Btn_Quest_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonTask/PrisonTask", Json.encode({stationId = 83000017}))
  end,
  PrisonAccomodation_Group_Navigation_Btn_Navigation_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonTask/PrisonTask", Json.encode({stationId = 83000017}))
  end,
  PrisonAccomodation_Group_Area_Btn_QuickJump_Click = function(btn, str)
    View.Group_Windows:SetActive(true)
    View.Group_Windows.ScrollGrid_QuickJump.grid.self:SetDataCount(6)
    View.Group_Windows.ScrollGrid_QuickJump.grid.self:RefreshAllElement()
  end,
  PrisonAccomodation_Group_Windows_Btn__Click = function(btn, str)
    View.Group_Windows:SetActive(false)
  end,
  PrisonAccomodation_Group_Windows_ScrollGrid_QuickJump_SetGrid = function(element, elementIndex)
    local roomCount = table.count(PrisonData.GetCellRoomList())
    element.Group_Lock:SetActive(elementIndex > roomCount)
    element.Group_Lock.Txt_0:SetText("0" .. elementIndex)
    local name = string.format(GetText(80608937), elementIndex)
    element.Group_Lock.Txt_WorkShop:SetText(name)
    element.Group_Workshop:SetActive(elementIndex <= roomCount)
    element.Group_Workshop.Txt_0:SetText(string.format("%02d", elementIndex))
    if elementIndex <= roomCount then
      element.Group_Workshop.Txt_WorkShop:SetText(name)
    end
    local select = elementIndex == tonumber(DataModel.roomIndex)
    element.Img_Pick:SetActive(select)
    element.Btn_:SetClickParam(elementIndex)
  end,
  PrisonAccomodation_Group_Windows_ScrollGrid_QuickJump_Group_Item_Btn__Click = function(btn, str)
    local cellRoomList = PrisonData.GetCellRoomList()
    if not cellRoomList[str] then
      return
    end
    PrisonCellController.ChangeRoom(str, 1, View.self)
    DataModel.ChangeRoomRefresh()
    View.Group_Windows:SetActive(false)
  end
}
return ViewFunction
