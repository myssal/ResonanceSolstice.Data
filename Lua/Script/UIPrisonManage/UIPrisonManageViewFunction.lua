local View = require("UIPrisonManage/UIPrisonManageView")
local DataModel = require("UIPrisonManage/UIPrisonManageDataModel")
local ManagerController = require("UIPrisonManage/UIPrisonManagerController")
local PrisonerController = require("UIPrisonManage/ManagePrisonerController")
local ViewFunction = {
  PrisonManage_Btn_Left_Click = function(btn, str)
    ManagerController:GoLeftRoom()
  end,
  PrisonManage_Btn_Light_Click = function(btn, str)
    ManagerController:GoRightRoom()
  end,
  PrisonManage_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    local function cancelCallback()
      UIManager:GoBack()
    end
    
    local function confirmCallback()
      ManagerController:SaveChanges(true)
      UIManager:GoBack()
    end
    
    if table.count(DataModel.roomEditDirty) == 0 then
      if PrisonData.roomIndex ~= DataModel.curRoomIndex then
        PrisonController.ChangeRoom(DataModel.curRoomIndex)
      else
        PrisonController.InitRoom(DataModel.curRoomIndex)
      end
      UIManager:GoBack()
    else
      CommonTips.OnPrompt(80600202, nil, nil, confirmCallback, cancelCallback, nil, true)
    end
  end,
  PrisonManage_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    local function cancelCallback()
      DataModel.roomEditDirty = {}
      
      PrisonController.CloseRoom()
      UIManager:GoHome()
    end
    
    local function confirmCallback()
      ManagerController:SaveChanges(nil, true)
      PrisonController.CloseRoom()
      UIManager:GoHome()
    end
    
    if table.count(DataModel.roomEditDirty) == 0 then
      PrisonController.CloseRoom()
      UIManager:GoHome()
    else
      CommonTips.OnPrompt(80600202, nil, nil, confirmCallback, cancelCallback, nil, true)
    end
  end,
  PrisonManage_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonManage_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  PrisonManage_Group_Top_Group_PrisonIcon_Btn_Logo_Click = function(btn, str)
  end,
  PrisonManage_Group_WorkerList_Group_Unit_Group_PrisonerUnplace_Group_PrisonerEmpty_Img_PrisonerEmpty_Btn__Click = function(btn, str)
  end,
  PrisonManage_Group_WorkerList_Group_Unit_Group_PrisonerPlaced_Group_SewingMachine_Img_SewingMachine_Btn__Click = function(btn, str)
  end,
  PrisonManage_Group_WorkerList_Group_Unit_Group_PrisonerPlaced_Img_Prisoner_Btn__Click = function(btn, str)
  end,
  PrisonManage_Group_WorkerList_StaticGrid_Unit_SetGrid = function(element, elementIndex)
    ManagerController:SetWorkerListElement(element, elementIndex)
  end,
  PrisonManage_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerUnplace_Group_PrisonerEmpty_Img_PrisonerEmpty_Btn__Click = function(btn, str)
    if DataModel.RoomIsWorking(DataModel.curRoomIndex) then
      CommonTips.OpenTips(GetText(80607144))
      return
    end
    local idx = tonumber(str)
    DataModel.curChoosePosIndex = idx
    DataModel.PrisonerFilterTarget = 1
    ManagerController:ShowPrisonerPanel()
  end,
  PrisonManage_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerPlaced_Group_SewingMachine_Img_SewingMachine_Btn__Click = function(btn, str)
  end,
  PrisonManage_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerPlaced_Img_Prisoner_Btn__Click = function(btn, str)
    if DataModel.RoomIsWorking(DataModel.curRoomIndex) then
      CommonTips.OpenTips(GetText(80607144))
      return
    end
    local idx = tonumber(str)
    DataModel.curChoosePosIndex = idx
    DataModel.PrisonerFilterTarget = 1
    ManagerController:ShowPrisonerPanel()
  end,
  PrisonManage_Group_Lock_StaticGrid__SetGrid = function(element, elementIndex)
    ManagerController:SetLockListElement(element, elementIndex)
  end,
  PrisonManage_Group_Edit_Btn_NormalMachine_Click = function(btn, str)
    ManagerController:SwitchBottomType(1)
  end,
  PrisonManage_Group_Edit_Btn_Navigation_Click = function(btn, str)
    if View.Group_Windows.gameObject.activeSelf == false then
      ManagerController:OpenNavigation()
      View.Btn_Windows:SetActive(true)
    else
      View.Group_Windows:SetActive(false)
      View.Btn_Windows:SetActive(false)
    end
  end,
  PrisonManage_Group_Edit_Btn_Remove_Click = function(btn, str)
  end,
  PrisonManage_Group_Edit_Btn_Place_Click = function(btn, str)
  end,
  PrisonManage_Group_WorkerList_Group_Unit_Group_PrisonerUnplace_Group_SewingMachine_Img_SewingMachine_Btn__Click = function(btn, str)
  end,
  PrisonManage_Group_WorkerList_Group_Unit_Group_PrisonerUnplace_Group_SewingMachine_Img_SewingMachine_Btn__LongPress = function(btn, str)
  end,
  PrisonManage_Group_WorkerList_Group_Unit_Group_PrisonerPlaced_Group_SewingMachine_Img_SewingMachine_Btn__LongPress = function(btn, str)
  end,
  PrisonManage_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerUnplace_Group_SewingMachine_Img_SewingMachine_Btn__Click = function(btn, str)
  end,
  PrisonManage_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerUnplace_Group_SewingMachine_Img_SewingMachine_Btn__LongPress = function(btn, str)
    local idx = tonumber(str)
    ManagerController:LongPressWorkerListItem(idx, true)
  end,
  PrisonManage_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerPlaced_Group_SewingMachine_Img_SewingMachine_Btn__LongPress = function(btn, str)
    local idx = tonumber(str)
    ManagerController:LongPressWorkerListItem(idx, true)
  end,
  PrisonManage_Group_Edit_Btn_hold_Click = function(btn, str)
    ManagerController:SaveChanges()
  end,
  PrisonManage_PrisonerListManage_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.PrisonerListManage:SetActive(false)
  end,
  PrisonManage_PrisonerListManage_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    local function cancelCallback()
      DataModel.roomEditDirty = {}
      
      PrisonController.CloseRoom()
      UIManager:GoHome()
    end
    
    local function confirmCallback()
      ManagerController:SaveChanges(nil, true)
      PrisonController.CloseRoom()
      UIManager:GoHome()
    end
    
    if table.count(DataModel.roomEditDirty) == 0 then
      PrisonController.CloseRoom()
      UIManager:GoHome()
    else
      CommonTips.OnPrompt(80600202, nil, nil, confirmCallback, cancelCallback, nil, true)
    end
  end,
  PrisonManage_PrisonerListManage_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonManage_PrisonerListManage_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  PrisonManage_PrisonerListManage_Btn_Passenger_Click = function(btn, str)
  end,
  PrisonManage_PrisonerListManage_Group_TopRightPrison_Btn_Level_Click = function(btn, str)
    PrisonerController:FilterRefresh(EnumDefine.EPrisonerSortType.Efficiency)
    ManagerController:RefreshPrisonerList()
  end,
  PrisonManage_PrisonerListManage_Group_TopRightPrison_Btn_Rarity_Click = function(btn, str)
    PrisonerController:FilterRefresh(EnumDefine.EPrisonerSortType.Energy)
    ManagerController:RefreshPrisonerList()
  end,
  PrisonManage_PrisonerListManage_Group_TopRightPrison_Btn_Time_Click = function(btn, str)
    PrisonerController:FilterRefresh(EnumDefine.EPrisonerSortType.DayCount)
    ManagerController:RefreshPrisonerList()
  end,
  PrisonManage_PrisonerListManage_Group_TopRightPrison_Btn_Screen_Click = function(btn, str)
    View.PrisonerListManage.Group_Screen:SetActive(true)
  end,
  PrisonManage_PrisonerListManage_ScrollGrid_Prison_SetGrid = function(element, elementIndex)
    ManagerController:SetPrisonerListElement(element, elementIndex)
  end,
  PrisonManage_PrisonerListManage_ScrollGrid_Prison_Group_Item_Btn_Working_Click = function(btn, str)
    local idx = tonumber(str)
    ManagerController:PrisonerToWork(idx)
  end,
  PrisonManage_PrisonerListManage_ScrollGrid_Prison_Group_Item_Btn_Rest_Click = function(btn, str)
    ManagerController:PrisonerToRest()
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Btn_BG_Click = function(btn, str)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Working_Btn_All_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 0)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Working_Btn_C01_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 1)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Working_Btn_C02_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 2)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Working_Btn_C03_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 3)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Working_Btn_C04_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 4)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Career_Btn_All_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 0)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Career_Btn_C01_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 1)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Career_Btn_C02_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 2)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Career_Btn_C03_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 3)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Career_Btn_C04_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 4)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Career_Btn_C05_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 5)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Career_Btn_C06_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 6)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Career_Btn_C07_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 7)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Career_Btn_C08_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 8)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Career_Btn_C09_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 9)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Group_Btn_All_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 0)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Group_Btn_G01_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 1)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Group_Btn_G02_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 2)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Group_Btn_G03_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 3)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Group_Btn_G04_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 4)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Group_Btn_G05_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 5)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Group_Btn_G06_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 6)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Group_Btn_G07_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 7)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Group_Btn_G08_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 8)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Group_Btn_G09_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 9)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Rarity_Btn_All_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 0)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R01_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 1)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R02_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 2)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R03_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 3)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R04_Click = function(btn, str)
    PrisonerController.ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 4)
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Btn_OK_Click = function(btn, str)
    PrisonerController.Filter()
    View.PrisonerListManage.Group_Screen:SetActive(false)
    ManagerController:RefreshPrisonerList()
  end,
  PrisonManage_PrisonerListManage_Group_Screen_Btn_Cancel_Click = function(btn, str)
    View.PrisonerListManage.Group_Screen:SetActive(false)
  end,
  PrisonManage_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerPlaced_Img_Prisoner_Btn__LongPress = function(btn, str)
    local idx = tonumber(str)
    ManagerController:LongPressWorkerListItem(idx, false)
  end,
  PrisonManage_Group_WorkerList_Group_Unit_Group_PrisonerPlaced_Img_Prisoner_Btn__LongPress = function(btn, str)
  end,
  PrisonManage_Group_Windows_Img_Base_StaticGrid_Train_SetGrid = function(element, elementIndex)
    ManagerController:SetRoomNaviElement(element, elementIndex)
  end,
  PrisonManage_Group_Windows_Img_Base_StaticGrid_Train_Group_train_Btn_train_Click = function(btn, str)
    local idx = tonumber(str)
    ManagerController:NaviChangeRoom(idx)
  end,
  PrisonManage_Group_Windows_Group_train_Btn_train_Click = function(btn, str)
  end,
  PrisonManage_PrisonerListManage_ScrollGrid_Prison_Group_Item_Btn_NoMonitor_Click = function(btn, str)
    ManagerController:SetRoomMonitor(false)
  end,
  PrisonManage_PrisonerListManage_ScrollGrid_Prison_Group_Item_Btn_Monitor_Click = function(btn, str)
    local idx = tonumber(str)
    ManagerController:SetRoomMonitor(true, DataModel.filterPrisoner[idx].u_pid)
  end,
  PrisonManage_Group_Lock_Group_Lock_Group_Mask_Btn_Lock_Click = function(btn, str)
  end,
  PrisonManage_Group_Lock_StaticGrid__Group_Lock_Group_Mask_Btn_Lock_Click = function(btn, str)
    ManagerController:TryUnlockNextArea()
  end,
  PrisonManage_Group_UnLockEffect_Group_Mask_Btn_Lock_Click = function(btn, str)
  end,
  PrisonManage_Btn_Windows_Click = function(btn, str)
    View.Group_Windows:SetActive(false)
    View.Btn_Windows:SetActive(false)
  end,
  PrisonManage_Group_Top_Group_Monitor_Group_Avatar_Btn_Avatar_Click = function(btn, str)
    if DataModel.RoomIsWorking(DataModel.curRoomIndex) then
      CommonTips.OpenTips(GetText(80607144))
      return
    end
    DataModel.PrisonerFilterTarget = 2
    ManagerController:ShowPrisonerPanel()
  end,
  PrisonManage_Group_Edit_Group_Machine_Btn_ChangeMachine_Click = function(btn, str)
  end,
  PrisonManage_Group_Edit_Group_Machine_Btn_ChangeMachine_Group_MachineList_Btn_Sewing_Click = function(btn, str)
  end,
  PrisonManage_Group_Edit_Group_Machine_Btn_UpMachine_Click = function(btn, str)
    ManagerController:TryUpgradeMachine()
  end,
  PrisonManage_Group_Edit_Group_Machine_NewScrollGrid_MachineList_SetGrid = function(element, elementIndex)
    ManagerController:SetBottomMachineElement(element, elementIndex)
  end,
  PrisonManage_Group_Edit_Group_Machine_NewScrollGrid_MachineList_Group_Item_Btn_Item_Click = function(btn, str)
    DataModel.CurSelectMachineUId = DataModel.GetWorkMachineUid(DataModel.curRoomIndex, tonumber(str)) or ""
    ManagerController:RefreshBottom()
  end,
  PrisonManage_Group_Edit_Group_Machine_NewScrollGrid_MachineList_Group_Item_Btn_Item_LongPress = function(btn, str)
    ManagerController:BeginDrag(tonumber(str), true)
  end,
  PrisonManage_Group_Edit_Group_Machine_NewScrollGrid_MachineList_Group_Item_Btn_Item_Btn_Tips_Click = function(btn, str)
  end,
  PrisonManage_Group_Edit_Btn_NormalPrisoner_Click = function(btn, str)
    ManagerController:SwitchBottomType(2)
  end,
  PrisonManage_Group_Edit_Group_Prisoner_Btn_Monitor_Click = function(btn, str)
    if DataModel.CurSelectPrisonerUId ~= "" then
      ManagerController:SetRoomMonitor(true, DataModel.CurSelectPrisonerUId)
    end
  end,
  PrisonManage_Group_Edit_Group_Prisoner_Btn_Manage_Click = function(btn, str)
    ManagerController:OneBtnToPutPrisoner()
  end,
  PrisonManage_Group_Edit_Group_Prisoner_Group_PrisonerAdd_Btn_Jia_Click = function(btn, str)
    ManagerController:AddPrisonerToWork()
  end,
  PrisonManage_Group_Edit_Group_Prisoner_Group_PrisonerAdd_Btn_Jian_Click = function(btn, str)
    ManagerController:RemovePrisonerFromWork()
  end,
  PrisonManage_Group_Edit_Group_Prisoner_NewScrollGrid_PrisonerList_SetGrid = function(element, elementIndex)
    ManagerController:SetBottomPrisonerElement(element, elementIndex)
  end,
  PrisonManage_Group_Edit_Group_Prisoner_NewScrollGrid_PrisonerList_Group_Item_Btn_Item_Click = function(btn, str)
    DataModel.CurSelectPrisonerUId = DataModel.GetWorkPrisonerUid(DataModel.curRoomIndex, tonumber(str)) or ""
    ManagerController:RefreshBottom()
  end,
  PrisonManage_Group_Edit_Group_Prisoner_NewScrollGrid_PrisonerList_Group_Item_Btn_Item_LongPress = function(btn, str)
  end,
  PrisonManage_Group_Edit_Group_Prisoner_NewScrollGrid_PrisonerList_Group_Item_Btn_Item_Group_Prisoner_Btn_Tips_Click = function(btn, str)
  end,
  PrisonManage_Group_Edit_Group_Prisoner_NewScrollGrid_PrisonerList_Group_Item_Btn_Item_Btn_Tips_Click = function(btn, str)
  end,
  PrisonManage_Group_Edit_NewScrollGrid_MachineList_SetGrid = function(element, elementIndex)
    ManagerController:SetMachineBagElement(element, elementIndex)
  end,
  PrisonManage_Group_Edit_NewScrollGrid_MachineList_Group_Item_Btn_Item_LongPress = function(btn, str)
    local idx = tonumber(str)
    ManagerController:LongPressWorkerListItem(idx, true)
  end,
  PrisonManage_Group_Edit_NewScrollGrid_MachineList_Group_Item_Btn_Item_Btn_Tips_Click = function(btn, str)
    ManagerController:ShowMachineDetailPanel(2, btn, str)
  end,
  PrisonManage_Group_Edit_NewScrollGrid_MachineList_Group_Item_Btn_Item_Btn_LevelUp_Click = function(btn, str)
    local idx = tonumber(str)
    ManagerController:TryUpgradeMachine(idx)
  end,
  PrisonManage_Group_Edit_Group_BoxBtn_Img_Mask_StaticGrid_Type_SetGrid = function(element, elementIndex)
    ManagerController:RefreshBagTitleElement(element, elementIndex)
  end,
  PrisonManage_Group_Edit_Group_BoxBtn_Img_Mask_StaticGrid_Type_Group_Btn_Btn_Custom_Click = function(btn, str)
    local idx = tonumber(str)
    local machineType = DataModel.machineTypes[idx]
    ManagerController:SelectMachineType(machineType)
  end,
  PrisonManage_Group_Edit_Group_BoxBtn_Img_Mask_Group_Btn_Btn_Custom_Click = function(btn, str)
  end,
  PrisonManage_Group_Edit_Btn_Edit_Click = function(btn, str)
  end,
  PrisonManage_Group_Lock_Group_Lock_Btn_Lock_Click = function(btn, str)
  end,
  PrisonManage_Group_Lock_StaticGrid__Group_Lock_Btn_Lock_Click = function(btn, str)
    ManagerController:TryUnlockNextArea()
  end,
  PrisonManage_PrisonerList_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.PrisonerList:SetActive(false)
  end,
  PrisonManage_PrisonerList_ScrollGrid_Prison_SetGrid = function(element, elementIndex)
    ManagerController:SetPrisonerListElement(element, elementIndex)
  end
}
return ViewFunction
