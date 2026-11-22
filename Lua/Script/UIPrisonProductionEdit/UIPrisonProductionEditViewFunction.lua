local View = require("UIPrisonProductionEdit/UIPrisonProductionEditView")
local DataModel = require("UIPrisonProductionEdit/UIPrisonProductionEditDataModel")
local Controller = require("UIPrisonProductionEdit/UIPrisonProductionEditController")
local ViewFunction = {
  PrisonProductionEdit_Btn_QuickEdit_Click = function(btn, str)
  end,
  PrisonProductionEdit_Btn_Left_Click = function(btn, str)
  end,
  PrisonProductionEdit_Btn_Light_Click = function(btn, str)
  end,
  PrisonProductionEdit_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if PrisonData.roomIndex ~= DataModel.CurRoomIndex then
      PrisonController.ChangeRoom(DataModel.CurRoomIndex, View.self)
    end
    UIManager:GoBack()
  end,
  PrisonProductionEdit_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PrisonProductionEdit_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonProductionEdit_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80303794}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  PrisonProductionEdit_Group_WorkerList_Group_Unit_Group_PrisonerEmpty_Img_PrisonerEmpty_Btn__Click = function(btn, str)
  end,
  PrisonProductionEdit_Group_WorkerList_Group_Unit_Group_PrisonerPlaced_Btn_Pick_Click = function(btn, str)
  end,
  PrisonProductionEdit_Group_WorkerList_StaticGrid_Unit_SetGrid = function(element, elementIndex)
    Controller:SetWorkPlaceElement(element, elementIndex)
  end,
  PrisonProductionEdit_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerEmpty_Img_PrisonerEmpty_Btn__Click = function(btn, str)
  end,
  PrisonProductionEdit_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerPlaced_Btn_Pick_Click = function(btn, str)
    Controller:ClickWorkerElement(tonumber(str))
  end,
  PrisonProductionEdit_Group_Lock_Group_Lock_Group_Mask_Btn_Lock_Click = function(btn, str)
  end,
  PrisonProductionEdit_Group_Lock_StaticGrid__SetGrid = function(element, elementIndex)
    Controller:SetLockElement(element, elementIndex)
  end,
  PrisonProductionEdit_Group_Lock_StaticGrid__Group_Lock_Group_Mask_Btn_Lock_Click = function(btn, str)
    Controller:TryUnlockNextArea()
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_Group_Type_Group_BoxBtn_Img_Mask_Group_Btn_Btn_Custom_Click = function(btn, str)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_Group_Type_Group_BoxBtn_Img_Mask_StaticGrid_Type_SetGrid = function(element, elementIndex)
    Controller:SetFormulaTypeElement(element, elementIndex)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_Group_Type_Group_BoxBtn_Img_Mask_StaticGrid_Type_Group_Btn_Btn_Custom_Click = function(btn, str)
    local row = DataModel.CurRoomFormulaType[tonumber(str)]
    if row then
      Controller:SwitchFormulaType(row.id)
    end
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_Group_Type_Btn_NormalFormula_Click = function(btn, str)
    Controller:SwitchFormulaType(-1)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_Group_Type_Btn_Zhankai_Click = function(btn, str)
    Controller:ShowExpandFormulaList()
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_NewScrollGrid_FormulaList_SetGrid = function(element, elementIndex)
    Controller:SetFormulaGroupListElement(element, elementIndex)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_NewScrollGrid_FormulaList_Group_Item_Btn_Item_Click = function(btn, str)
    local row = DataModel.CurRoomFormulaGroup[tostring(DataModel.CurSelectFormulaType)][tonumber(str)]
    if row then
      Controller:SelectFormula(row.id)
    end
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_NewScrollGrid_FormulaList_Group_Item_Btn_Item_LongPress = function(btn, str)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_NewScrollGrid_FormulaList_Group_Item_Group_NoGet_Btn__Click = function(btn, str)
    local scalex = UIManager:GetCanvas().transform.localScale.x
    local posx = btn.transform.position.x / scalex
    Controller:OpenGetWayPanel(tonumber(str), posx)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Programme_Group_PrisonerNum_Btn_All_Click = function(btn, str)
    Controller:OneBtnChooseAll()
  end,
  PrisonProductionEdit_Group_Bottom_Group_Programme_Group_Programme_ScrollGrid_Required_SetGrid = function(element, elementIndex)
    Controller:SetRequireItemElement(element, elementIndex)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Programme_Group_Programme_ScrollGrid_Required_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenGoodsTips(tonumber(str), 1)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Programme_Group_Programme_Btn_Confirm_Click = function(btn, str)
    Controller:TrySetProductPlant()
  end,
  PrisonProductionEdit_Btn_Windows_Click = function(btn, str)
    Controller:ShowRoomWindow()
  end,
  PrisonProductionEdit_Group_Windows_ScrollGrid_QuickJump_SetGrid = function(element, elementIndex)
    Controller:SetRoomIndexElement(element, elementIndex)
  end,
  PrisonProductionEdit_Group_UnLockEffect_Group_Mask_Btn_Lock_Click = function(btn, str)
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_Group_Type_Group_BoxBtn_Img_Mask_Group_Btn_Btn_Custom_Click = function(btn, str)
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_Group_Type_Group_BoxBtn_Img_Mask_StaticGrid_Type_SetGrid = function(element, elementIndex)
    Controller:SetExpandFormulaTypeElement(element, elementIndex)
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_Group_Type_Group_BoxBtn_Img_Mask_StaticGrid_Type_Group_Btn_Btn_Custom_Click = function(btn, str)
    local row = DataModel.CurRoomFormulaType[tonumber(str)]
    if row then
      Controller:SwitchFormulaType(row.id)
    end
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_Group_Type_Btn_NormalFormula_Click = function(btn, str)
    Controller:SwitchFormulaType(-1)
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_Group_Type_Btn_Shouqi_Click = function(btn, str)
    View.Group_FormulaList:SetActive(false)
    View.Group_Bottom.Group_Formula:SetActive(true)
    DataModel.IsExpand = false
    Controller:RefreshFormulaTypeList()
    Controller:RefreshFormulaList()
    Controller:RefreshLockElement()
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_NewScrollGrid_FormulaList_SetGrid = function(element, elementIndex)
    Controller:SetExpandFormulaGroupListElement(element, elementIndex)
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_NewScrollGrid_FormulaList_Group_Item_Btn_Item_Click = function(btn, str)
    local row = DataModel.CurRoomFormulaGroup[tostring(DataModel.CurSelectFormulaType)][tonumber(str)]
    if row then
      Controller:SelectFormula(row.id)
    end
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_NewScrollGrid_FormulaList_Group_Item_Btn_Item_LongPress = function(btn, str)
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_NewScrollGrid_FormulaList_Group_Item_Group_NoGet_Btn__Click = function(btn, str)
    local scalex = UIManager:GetCanvas().transform.localScale.x
    local posx = btn.transform.position.x / scalex
    Controller:OpenGetWayPanel(tonumber(str), posx)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Programme_Group_Programme_Group_Time_Group_TimeGrid_Btn_Choose_Click = function(btn, str)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Programme_Group_Programme_Group_Time_StaticGrid_Time_SetGrid = function(element, elementIndex)
    Controller:SetTimeElement(element, elementIndex)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Programme_Group_Programme_Group_Time_StaticGrid_Time_Group_TimeGrid_Btn_Choose_Click = function(btn, str)
    DataModel.CurSelectTimeIdx = tonumber(str)
    Controller:RefreshRequirePanel()
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_Group_Type_Group_Btn_Zuijin_Btn_Custom_Click = function(btn, str)
    Controller:SwitchFormulaType(0)
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_Group_Type_Group_Btn_Zuijin_Btn_Custom_Click = function(btn, str)
    Controller:SwitchFormulaType(0)
  end,
  PrisonProductionEdit_Group_Bottom_Group_Programme_Group_PrisonerNum_Btn_AllCancel_Click = function(btn, str)
    Controller:OneBtnCancelAll()
  end,
  PrisonProductionEdit_Group_Windows_Btn__Click = function(btn, str)
    View.Group_Windows:SetActive(false)
  end,
  PrisonProductionEdit_Group_Windows_ScrollGrid_QuickJump_Group_Item_Btn__Click = function(btn, str)
    Controller:ChangeRoom(tonumber(str))
  end,
  PrisonProductionEdit_Group_Bottom_Group_Formula_Group_Type_NewScrollGrid_FormulaList_Group_Item_Btn_Tips_Click = function(btn, str)
    CommonTips.OpenGoodsTips(tonumber(str), 1)
  end,
  PrisonProductionEdit_Group_FormulaList_Group_Formula_Group_Type_NewScrollGrid_FormulaList_Group_Item_Btn_Tips_Click = function(btn, str)
    CommonTips.OpenGoodsTips(tonumber(str), 1)
  end
}
return ViewFunction
