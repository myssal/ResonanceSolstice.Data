local View = require("UIPunishmentRoom/UIPunishmentRoomView")
local DataModel = require("UIPunishmentRoom/UIPunishmentRoomDataModel")
local Controller = require("UIPunishmentRoom/UIPunishmentRoomController")
local ViewFunction = {
  PunishmentRoom_Group_GoldCoin_Btn_GoldCoin_Click = function(btn, str)
  end,
  PunishmentRoom_Group_GoldCoin_Btn_Add_Click = function(btn, str)
  end,
  PunishmentRoom_Group_TopRightPrison_Btn_PunishTime_Click = function(btn, str)
    Controller:SortRevert()
  end,
  PunishmentRoom_Group_Report_Group_Report_ScrollView__Viewport_Content_Group_Punish_StaticGrid_Punish_SetGrid = function(element, elementIndex)
    Controller:SetPunishPrisoner(element, elementIndex)
  end,
  PunishmentRoom_Group_Report_Group_Report_ScrollView__Viewport_Content_Group_Release_StaticGrid_Punish_SetGrid = function(element, elementIndex)
    Controller:SetReleasePrisoner(element, elementIndex)
  end,
  PunishmentRoom_Group_Title_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
      local UIPrisonDataModel = require("UIPrison/UIPrisonDataModel")
      UIPrisonDataModel.RefreshAllRoom()
      View.self:CloseUI()
    else
      View.self:CloseUI()
    end
  end,
  PunishmentRoom_Group_Title_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PunishmentRoom_Group_Title_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PunishmentRoom_Group_Title_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304350}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  PunishmentRoom_Group_TopRightPrison_Btn_Report_Click = function(btn, str)
    Controller:ShowPunishReport()
  end,
  PunishmentRoom_Group_Report_Btn_Close_Click = function(btn, str)
    View.Group_Report:SetActive(false)
  end,
  PunishmentRoom_Group_PunishmentRoom_NewScrollGrid__SetGrid = function(element, elementIndex)
    Controller:SetPrisonerElement(element, elementIndex)
  end,
  PunishmentRoom_Group_PunishmentRoom_NewScrollGrid__Group_Item_Group_Prisoner_Group_FriskBtn_Btn_Frisk_Click = function(btn, str)
    Controller:TryFrisk(tonumber(str))
  end,
  PunishmentRoom_Btn_AllSearch_Click = function(btn, str)
    Controller:OneButtonFriskAll()
  end
}
return ViewFunction
