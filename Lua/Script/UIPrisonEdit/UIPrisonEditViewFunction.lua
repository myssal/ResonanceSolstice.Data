local View = require("UIPrisonEdit/UIPrisonEditView")
local DataModel = require("UIPrisonEdit/UIPrisonEditDataModel")
local Controller = require("UIPrisonEdit/UIPrisonEditController")
local ViewFunction = {
  PrisonEdit_Btn_Left_Click = function(btn, str)
    local function cancelCallback()
    end
    
    local function confirmCallback()
      Controller:SaveChanges()
      Controller:GoLeftRoom()
    end
    
    if table.count(DataModel.roomEditDirty) == 0 then
      Controller:GoLeftRoom()
    else
      CommonTips.OnPrompt(80600202, nil, nil, confirmCallback, cancelCallback, nil, true)
    end
  end,
  PrisonEdit_Btn_Light_Click = function(btn, str)
    local function cancelCallback()
    end
    
    local function confirmCallback()
      Controller:SaveChanges()
      Controller:GoRightRoom()
    end
    
    if table.count(DataModel.roomEditDirty) == 0 then
      Controller:GoRightRoom()
    else
      CommonTips.OnPrompt(80600202, nil, nil, confirmCallback, cancelCallback, nil, true)
    end
  end,
  PrisonEdit_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    local function cancelCallback()
      UIManager:GoBack()
    end
    
    local function confirmCallback()
      Controller:SaveChanges(true)
      UIManager:GoBack()
    end
    
    if table.count(DataModel.roomEditDirty) == 0 then
      if PrisonData.roomIndex ~= DataModel.CurRoomIndex then
        PrisonController.ChangeRoom(DataModel.CurRoomIndex, View.self)
      end
      UIManager:GoBack()
    else
      CommonTips.OnPrompt(80600202, nil, nil, confirmCallback, cancelCallback, nil, true)
    end
  end,
  PrisonEdit_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    local function cancelCallback()
      DataModel.roomEditDirty = {}
      
      UIManager:GoHome()
    end
    
    local function confirmCallback()
      Controller:SaveChanges(nil, true)
      UIManager:GoHome()
    end
    
    if table.count(DataModel.roomEditDirty) == 0 then
      UIManager:GoHome()
    else
      CommonTips.OnPrompt(80600202, nil, nil, confirmCallback, cancelCallback, nil, true)
    end
  end,
  PrisonEdit_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonEdit_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80303794}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  PrisonEdit_Group_Top_Group_PrisonIcon_Btn_Logo_Click = function(btn, str)
    UIManager:Open("UI/Prison/Overview/PrisonLevel/PrisonLevel")
  end,
  PrisonEdit_Group_Top_Group_Monitor_Group_Avatar_Btn_Avatar_Click = function(btn, str)
  end,
  PrisonEdit_Group_WorkerList_Group_Unit_Group_PrisonerPlaced_Img_Prisoner_Btn__Click = function(btn, str)
    Controller:SelectWorkerElement(tonumber(str))
  end,
  PrisonEdit_Group_WorkerList_Group_Unit_Group_PrisonerPlaced_Img_Prisoner_Btn__LongPress = function(btn, str)
  end,
  PrisonEdit_Group_WorkerList_StaticGrid_Unit_SetGrid = function(element, elementIndex)
    Controller:SetWorkerListElement(element, elementIndex)
  end,
  PrisonEdit_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerPlaced_Img_Prisoner_Btn__Click = function(btn, str)
    Controller:SelectWorkerElement(tonumber(str))
  end,
  PrisonEdit_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerPlaced_Img_Prisoner_Btn__LongPress = function(btn, str)
    Controller:BeginDrag(tonumber(str))
  end,
  PrisonEdit_Group_Lock_Group_Lock_Group_Mask_Btn_Lock_Click = function(btn, str)
  end,
  PrisonEdit_Group_Lock_StaticGrid__SetGrid = function(element, elementIndex)
    Controller:SetLockListElement(element, elementIndex)
  end,
  PrisonEdit_Group_Lock_StaticGrid__Group_Lock_Group_Mask_Btn_Lock_Click = function(btn, str)
    Controller:TryUnlockNextArea()
  end,
  PrisonEdit_Group_Edit_Group_Detail_Group_MachineInfo_Btn_UpMachine_Click = function(btn, str)
    Controller:TryUpgradeMachine()
  end,
  PrisonEdit_Group_Edit_Group_Detail_Btn_hold_Click = function(btn, str)
    Controller:SaveChanges()
  end,
  PrisonEdit_Group_Windows_Img_Base_StaticGrid_Train_SetGrid = function(element, elementIndex)
  end,
  PrisonEdit_Group_Windows_Img_Base_StaticGrid_Train_Group_train_Btn_train_Click = function(btn, str)
  end,
  PrisonEdit_Group_Windows_Group_train_Btn_train_Click = function(btn, str)
  end,
  PrisonEdit_Btn_Windows_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.PrisonerListManage:SetActive(false)
  end,
  PrisonEdit_PrisonerListManage_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PrisonEdit_PrisonerListManage_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Btn_Passenger_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_TopRightPrison_Btn_Level_Click = function(btn, str)
    DataModel.SortState.index = 1
    Controller:Click(View.PrisonerListManage.Group_TopRightPrison.Btn_Level)
  end,
  PrisonEdit_PrisonerListManage_Group_TopRightPrison_Btn_Time_Click = function(btn, str)
    DataModel.SortState.index = 2
    Controller:Click(View.PrisonerListManage.Group_TopRightPrison.Btn_Time)
  end,
  PrisonEdit_PrisonerListManage_Group_TopRightPrison_Btn_Screen_Click = function(btn, str)
    View.PrisonerListManage.Group_Screen:SetActive(true)
  end,
  PrisonEdit_PrisonerListManage_ScrollGrid_Prison_SetGrid = function(element, elementIndex)
    Controller:SetPrisonerListElement(element, elementIndex)
  end,
  PrisonEdit_PrisonerListManage_ScrollGrid_Prison_Group_Item_Group_Character_Btn_Mask_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_ScrollGrid_Prison_Group_Item_Group_Character_Btn_Item_Click = function(btn, str)
    Controller:SelectPrisoner(tonumber(str))
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Btn_BG_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C01_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 1)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C02_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 2)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C03_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 3)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C04_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 4)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C05_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 5)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C06_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 6)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C07_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 7)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C08_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 8)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C09_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 9)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C10_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 10)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C11_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 11)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C12_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 12)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C13_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 13)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G01_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 1)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G02_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 2)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R01_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 1)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R02_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 2)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R03_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 3)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Btn_OK_Click = function(btn, str)
    View.PrisonerListManage.Group_Screen:SetActive(false)
    Controller:RefreshPrisonerList()
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Btn_Cancel_Click = function(btn, str)
    View.PrisonerListManage.Group_Screen:SetActive(false)
  end,
  PrisonEdit_PrisonerListManage_Group_Detail_Btn_Confirm_Click = function(btn, str)
    if DataModel.IsQuickSquad then
      local unlockGrid = DataModel.GetUnlockGridCount()
      local monitorPid = DataModel.monitorData[DataModel.CurRoomIndex]
      local needKeepMonitor = DataModel.SelectPrisonerPid2Index[monitorPid] ~= nil
      for i = 1, unlockGrid do
        local hasPlant = DataModel.IsWorkPlaceHasPlant(DataModel.CurRoomIndex, i)
        if not hasPlant then
          local pid = DataModel.SelectPrisonerIndex2Pid[i]
          Controller:PrisonerToRest(i, needKeepMonitor)
        else
          local pid = DataModel.SelectPrisonerIndex2Pid[i]
          if pid then
            local curPid = DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, i)
            if curPid ~= "" then
              DataModel.SelectPrisonerPid2Index[pid] = nil
              DataModel.SelectPrisonerIndex2Pid[i] = nil
            end
          end
        end
      end
      for u_pid, index in pairs(DataModel.SelectPrisonerPid2Index) do
        Controller:PrisonerToWork(u_pid, index, needKeepMonitor)
      end
    else
      Controller:PrisonerToRest(DataModel.CurSelectWorkerIndex)
      for u_pid, index in pairs(DataModel.SelectPrisonerPid2Index) do
        Controller:PrisonerToWork(u_pid, index)
      end
    end
  end,
  PrisonEdit_Group_UnLockEffect_Group_Mask_Btn_Lock_Click = function(btn, str)
  end,
  PrisonEdit_Group_Edit_Btn_ChangeMachine_Click = function(btn, str)
  end,
  PrisonEdit_Group_Edit_Btn_ChangeMachine_Group_MachineList_Btn_Sewing_Click = function(btn, str)
  end,
  PrisonEdit_Group_Edit_Btn_QuickEdit_Click = function(btn, str)
    Controller:ShowPrisonerList(true)
  end,
  PrisonEdit_Group_WorkerList_Group_Unit_Group_PrisonerEmpty_Img_PrisonerEmpty_Btn__Click = function(btn, str)
  end,
  PrisonEdit_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_PrisonerEmpty_Img_PrisonerEmpty_Btn__Click = function(btn, str)
    Controller:SelectWorkerElement(tonumber(str))
  end,
  PrisonEdit_Group_Edit_Group_Detail_Group_PrisonerInfo_Group_PrisonerInfo_Group_Empty_Btn_Empty_Click = function(btn, str)
    Controller:ShowPrisonerList()
  end,
  PrisonEdit_Group_Edit_Group_Detail_Group_PrisonerInfo_Group_PrisonerInfo_Group_PrisonDetail_Group_Btn_Btn_Monitor_Click = function(btn, str)
    local u_pid = DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, DataModel.CurSelectWorkerIndex)
    local room, pos = DataModel.GetPrisonerWorkingRoomAndPos(u_pid)
    local isWorking = DataModel.IsWorkPlaceHasPlant(room, pos)
    if isWorking then
      return
    end
    local lastUPid = DataModel.monitorData[DataModel.CurRoomIndex]
    if lastUPid and lastUPid ~= "" then
      local lastRoom, lastPos = DataModel.GetPrisonerWorkingRoomAndPos(lastUPid)
      local lastMonitorWorking = DataModel.IsWorkPlaceHasPlant(lastRoom, lastPos)
      if lastMonitorWorking then
        CommonTips.OpenTips(GetText(80608604))
        return
      end
    end
    if u_pid and u_pid ~= "" then
      Controller:SetRoomMonitor(true, DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, DataModel.CurSelectWorkerIndex))
    end
  end,
  PrisonEdit_Group_Edit_Group_Detail_Group_PrisonerInfo_Group_PrisonerInfo_Group_PrisonDetail_Group_Btn_Btn_Change_Click = function(btn, str)
    Controller:ShowPrisonerList()
  end,
  PrisonEdit_Group_Edit_Group_Detail_Group_PrisonerInfo_Group_PrisonerInfo_Group_PrisonDetail_Group_Btn_Btn_Down_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_Detail_Btn_All_Click = function(btn, str)
    Controller:OneBtnSelect()
  end,
  PrisonEdit_Group_Edit_Group_Detail_Group_PrisonerInfo_Group_PrisonerInfo_Group_PrisonDetail_Group_Btn_Btn_MonitorDown_Click = function(btn, str)
    Controller:SetRoomMonitor(false)
  end,
  PrisonEdit_Group_WorkerList_Group_Unit_Btn__Click = function(btn, str)
  end,
  PrisonEdit_Group_WorkerList_StaticGrid_Unit_Group_Unit_Btn__Click = function(btn, str)
    Controller:SelectWorkerElement(tonumber(str))
  end,
  PrisonEdit_PrisonerListManage_Group_Detail_Btn_AllCancel_Click = function(btn, str)
    Controller:OneBtnCancelAll()
  end,
  PrisonEdit_Group_Edit_Group_Detail_Group_MachineInfo_Group_Consume_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  PrisonEdit_Group_Edit_Group_Detail_Group_MachineInfo_Group_Consume_StaticGrid_Consume_SetGrid = function(element, elementIndex)
    Controller:SetUpgradeCostItemElement(element, elementIndex)
  end,
  PrisonEdit_Group_Edit_Group_Detail_Group_MachineInfo_Group_Consume_StaticGrid_Consume_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreItemTips({
      itemId = tonumber(str)
    })
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Working_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 0)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Working_Btn_C01_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 1)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Working_Btn_C02_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 2)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Working_Btn_C03_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Working, btn, 3)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Working_Btn_C04_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 0)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 0)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G03_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 3)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G04_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G05_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G06_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G07_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G08_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G09_Click = function(btn, str)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_All_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 0)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R04_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 4)
  end,
  PrisonEdit_Group_WorkerList_Group_Unit_Btn__LongPress = function(btn, str)
  end,
  PrisonEdit_Group_WorkerList_StaticGrid_Unit_Group_Unit_Btn__LongPress = function(btn, str)
    Controller:BeginDrag(tonumber(str))
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Career_Btn_C00_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Career, btn, 0)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Group_Btn_G00_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Group, btn, 0)
  end,
  PrisonEdit_PrisonerListManage_Group_Screen_Group_Rarity_Btn_R00_Click = function(btn, str)
    Controller:ScreenBtn(View.PrisonerListManage.Group_Screen.Group_Rarity, btn, 0)
  end,
  PrisonEdit_Group_Edit_Btn_Detail_Click = function(btn, str)
  end,
  PrisonEdit_Group_WorkerList_Group_Unit_Group_Machine_Img_Machine_Btn__Click = function(btn, str)
  end,
  PrisonEdit_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_Machine_Img_Machine_Btn__Click = function(btn, str)
    Controller:SelectWorkerElement(tonumber(str))
  end,
  PrisonEdit_Group_WorkerList_Group_Unit_Group_Machine_Img_Machine_Btn__LongPress = function(btn, str)
  end,
  PrisonEdit_Group_WorkerList_StaticGrid_Unit_Group_Unit_Group_Machine_Img_Machine_Btn__LongPress = function(btn, str)
  end
}
return ViewFunction
