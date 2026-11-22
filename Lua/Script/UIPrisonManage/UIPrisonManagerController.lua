local DataModel = require("UIPrisonManage/UIPrisonManageDataModel")
local MainData = require("UIPrisonMain/PrisonData")
local View = require("UIPrisonManage/UIPrisonManageView")
local PrisonerController = require("UIPrisonManage/ManagePrisonerController")
local Controller = {}
local WorkerElementStateType = {
  Lock = 0,
  Empty = 1,
  NoPrisoner = 2,
  HasPrisoner = 3
}

function Controller:InitView()
  DataModel.InitEditData()
  Controller:RefreshTopInfo()
  Controller:RefreshLockGrid()
  Controller:RefreshWorkerList()
  if DataModel.isFirst then
    View.self:StartC(LuaUtil.cs_generator(function()
      View.Group_Edit.Group_Prisoner:SetActive(true)
      View.Group_Edit.Group_Machine:SetActive(true)
      coroutine.yield(CS.UnityEngine.WaitForSeconds(0.01))
      Controller:SwitchBottomType(1)
      DataModel.isFirst = false
    end))
  else
    Controller:SwitchBottomType(1)
  end
  View.Group_UnLockEffect:SetActive(false)
  View.Group_Windows:SetActive(false)
  View.Btn_Left:SetActive(1 < DataModel.totalRoomCount)
  View.Btn_Light:SetActive(1 < DataModel.totalRoomCount)
  PrisonerController:ResetFilter()
end

function Controller:RefreshTopInfo()
  View.Group_Top.Group_WorkshopInfo.Txt_Workshop:SetText(string.format(GetText(80600296), DataModel.curRoomIndex))
  View.Group_Top.Group_PrisonIcon.Txt_Num:SetText(PrisonData.GetPrisonLv())
  View.Group_Top.Group_TotalNum.Txt_TotalNumCount:SetText(DataModel.GetRoomPrisonerCount(DataModel.curRoomIndex))
  local machineType = DataModel.GetCurRoomMachineType()
  if machineType == -1 then
    local cfg = PlayerData:GetFactoryData(12600593, "TagFactory")
    View.Group_Top.Group_WorkshopInfo.Txt_WorkshopName:SetText(cfg.typeName)
    View.Group_Top.Group_WorkshopInfo.Img_WorkshopIcon:SetSprite(cfg.iconPath)
  else
    local cfg = PlayerData:GetFactoryData(DataModel.GetCurRoomMachineType(), "TagFactory")
    View.Group_Top.Group_WorkshopInfo.Txt_WorkshopName:SetText(cfg.typeName)
    View.Group_Top.Group_WorkshopInfo.Img_WorkshopIcon:SetSprite(cfg.iconPath)
  end
  local monitorPid = DataModel.monitorData[DataModel.curRoomIndex]
  if monitorPid and monitorPid ~= "" then
    local pData = DataModel.prisonerData[monitorPid]
    local monitorCfg = PlayerData:GetFactoryData(pData.server.monitor)
    local buffCfg = PlayerData:GetFactoryData(monitorCfg.buffId)
    View.Group_Top.Group_Monitor.Txt_MonitorName:SetText(monitorCfg.monitorJobName)
    View.Group_Top.Group_Monitor.Txt_MonitorDescribe:SetText(string.format(buffCfg.desc, math.floor(pData.server.monitor_buff.buff_num * 100)))
    local prisonerId = pData.server.prisoner_id
    local face = PlayerData:GetFactoryData(prisonerId).prisonerIconPath
    View.Group_Top.Group_Monitor.Group_Avatar.Img_AvatarMask:SetActive(false)
    View.Group_Top.Group_Monitor.Group_Avatar.Img_AvatarFrame.Img_Mask:SetActive(true)
    View.Group_Top.Group_Monitor.Group_Avatar.Img_AvatarFrame.Img_Mask.Img_Avatar:SetSprite(face)
  else
    View.Group_Top.Group_Monitor.Group_Avatar.Img_AvatarMask:SetActive(true)
    View.Group_Top.Group_Monitor.Group_Avatar.Img_AvatarFrame.Img_Mask:SetActive(false)
    View.Group_Top.Group_Monitor.Txt_MonitorName:SetText(GetText(80607109))
    View.Group_Top.Group_Monitor.Txt_MonitorDescribe:SetText(GetText(80607110))
  end
end

function Controller:RefreshLockGrid()
  View.Group_Lock:SetActive(true)
  View.Group_Lock.StaticGrid_.grid.self:SetDataCount(6)
  View.Group_Lock.StaticGrid_.grid.self:RefreshAllElement()
end

function Controller:RefreshWorkerList()
  View.Group_WorkerList.StaticGrid_Unit.grid.self:SetDataCount(18)
  View.Group_WorkerList.StaticGrid_Unit.grid.self:RefreshAllElement()
end

function Controller:SetBottomMachineElement(element, elementIndex)
  local row = DataModel.GetWorkMachineInfo(DataModel.curRoomIndex, elementIndex)
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Btn_Item.Txt_Count:SetText(string.format("%02d", elementIndex))
    element.Btn_Item.Txt_Item:SetText(cfg.name)
    element.Btn_Item.Img_Pick:SetActive(row.u_fid == DataModel.CurSelectMachineUId)
    element.Btn_Item.Txt_Num:SetText(string.format("Lv%d", cfg.Level))
    element.Btn_Item.Img_Item:SetSprite(cfg.iconPath)
    element.Btn_Item.Img_Prisoner:SetActive(DataModel.HasWorkingPrisoner(DataModel.curRoomIndex, elementIndex))
    element.Btn_Item.Btn_Tips:SetClickParam(elementIndex)
    element.Btn_Item:SetClickParam(elementIndex)
  end
end

function Controller:RefreshBottomMachine()
  View.Group_Edit.Group_Machine.NewScrollGrid_MachineList.grid.self:SetDataCount(DataModel.GetUnlockGridCount())
  View.Group_Edit.Group_Machine.NewScrollGrid_MachineList.grid.self:RefreshAllElement()
end

function Controller:SetBottomPrisonerElement(element, elementIndex)
  local hasPrisoner = DataModel.HasWorkingPrisoner(DataModel.curRoomIndex, elementIndex)
  element.Btn_Item.Img_Empty:SetActive(not hasPrisoner)
  element.Btn_Item.Group_Prisoner:SetActive(hasPrisoner)
  if hasPrisoner then
    local row = DataModel.GetWorkPrisonerInfo(DataModel.curRoomIndex, elementIndex)
    if row then
      local prisonerCfg = PlayerData:GetFactoryData(row.id)
      element.Btn_Item.Group_Prisoner.Img_Item:SetSprite(prisonerCfg.prisonerIconPath)
      element.Btn_Item.Group_Prisoner.Txt_Count:SetText(string.format("%02d", elementIndex))
      element.Btn_Item.Group_Prisoner.Txt_Item:SetText(prisonerCfg.name)
      element.Btn_Item.Group_Prisoner.Txt_Monitor:SetActive(DataModel.IsRoomMonitor(row.u_pid, DataModel.curRoomIndex))
      element.Btn_Item.Group_Prisoner.Txt_Character:SetText(PlayerData:GetFactoryData(row.personality_id).prisonerPersonalityName)
      element.Btn_Item.Group_Prisoner.Txt_Item:SetText(string.format(GetText(80607161), string.format("%06d", tonumber(row.clint_num))))
      element.Btn_Item.Group_Prisoner.Img_Pick:SetActive(DataModel.CurSelectPrisonerUId ~= "" and DataModel.CurSelectPrisonerUId == row.u_pid)
      element.Btn_Item:SetClickParam(elementIndex)
    end
  end
end

function Controller:RefreshBottomPrisoner()
  View.Group_Edit.Group_Prisoner.Group_PrisonerAdd.Txt_Num:SetText(DataModel.GetRoomPrisonerCount(DataModel.curRoomIndex))
  View.Group_Edit.Group_Prisoner.Group_PrisonerAdd.Txt_NumMax:SetText(DataModel.GetUnlockGridCount(DataModel.curRoomIndex))
  View.Group_Edit.Group_Prisoner.NewScrollGrid_PrisonerList.grid.self:SetDataCount(DataModel.GetUnlockGridCount())
  View.Group_Edit.Group_Prisoner.NewScrollGrid_PrisonerList.grid.self:RefreshAllElement()
end

function Controller:RefreshBottom()
  if DataModel.CurBottomTab == 1 then
    Controller:RefreshBottomMachine()
  elseif DataModel.CurBottomTab == 2 then
    Controller:RefreshBottomPrisoner()
  end
end

function Controller:RefreshPrisonerList()
  local count = table.count(DataModel.filterPrisoner)
  View.PrisonerListManage.ScrollGrid_Prison.grid.self:SetDataCount(count)
  View.PrisonerListManage.ScrollGrid_Prison.grid.self:RefreshAllElement()
  View.PrisonerListManage.Group_NoPrison:SetActive(count == 0)
end

function Controller:RefreshBoxBtn()
  View.Group_Edit.Btn_Edit:SetActive(false)
  View.Group_Edit.Btn_hold:SetActive(true)
  View.Group_Edit.Btn_Place:SetActive(true)
  View.Group_Edit.Btn_Remove:SetActive(true)
end

local function RefreshMachineElement(ctr, u_fid)
  local data = DataModel.allMachine[u_fid]
  local machineIconCtr = ctr.Group_SewingMachine.Img_SewingMachine
  local txt_machineLevel = ctr.Group_SewingMachine.Txt_SewingLevel
  local cfg = PlayerData:GetFactoryData(data.id)
  machineIconCtr:SetSprite(cfg.iconPath)
  txt_machineLevel:SetText(string.format("%s Lv. %d", cfg.name, cfg.Level))
end

local function RefreshPrisonerElement(ctr, u_pid)
  if not u_pid or u_pid == "" then
    return
  end
  local data = DataModel.allPrisoner[u_pid]
  local cfg = PlayerData:GetFactoryData(data.id)
  ctr.Img_Prisoner:SetSprite(cfg.prisonerIconPath)
  local isMonitor = DataModel.IsRoomMonitor(data.u_pid)
  local mainCtr = isMonitor and ctr.Group_Frame.Group_MonitorFrame or ctr.Group_Frame.Group_CommonFrame
  local anotherCtr = isMonitor and ctr.Group_Frame.Group_CommonFrame or ctr.Group_Frame.Group_MonitorFrame
  ctr.Group_Frame.Group_CommonFrame.Txt_Number:SetText(string.format("UNIT-%06d", tonumber(data.clint_num)))
  mainCtr:SetActive(true)
  anotherCtr:SetActive(false)
  mainCtr.Txt_WorkTime = TimeUtil:GetStandardTime(TimeUtil:SecondToTable(7200))
  ctr.Group_Character.Txt_CommonCharacter:SetActive(not isMonitor)
  ctr.Group_Character.Txt_MonitorPosition:SetActive(isMonitor)
  ctr.Group_Character.Txt_MonitorPosition:SetText(PlayerData:GetFactoryData(data.monitor).monitorJobName)
  ctr.Group_Character.Txt_MonitorCharacter:SetActive(isMonitor)
  ctr.Group_Character.Txt_MonitorCharacter:SetText(PlayerData:GetFactoryData(data.personality_id).prisonerPersonalityName)
  ctr.Group_Character.Txt_CommonCharacter:SetText(PlayerData:GetFactoryData(data.personality_id).prisonerPersonalityName)
end

function Controller:RefreshAllWorkingRemainTime()
  for i, v in ipairs(DataModel.workerListData) do
    local ctr = View.Group_WorkerList.StaticGrid_Unit.grid[i]
    if v.isMonitor then
      ctr.Group_PrisonerPlaced.Group_MonitorFrame.Txt_WorkTime:SetText(TimeUtil:GetStandardTime(TimeUtil:SecondToTable(math.floor(v.remainTime))))
      v.remainTime = v.remainTime - Time.deltaTime
    else
      ctr.Group_PrisonerPlaced.Group_MonitorFrame.Txt_WorkTime:SetText(TimeUtil:GetStandardTime(TimeUtil:SecondToTable(math.floor(v.remainTime))))
      v.remainTime = v.remainTime - Time.deltaTime
    end
  end
end

function Controller:SetWorkerListElement(element, elementIndex)
  local emptyCtr = element.Group_Empty
  local noPrisonerCtr = element.Group_PrisonerUnplace
  local hasPrisonerCtr = element.Group_PrisonerPlaced
  local state = WorkerElementStateType.Lock
  if elementIndex <= DataModel.GetUnlockGridCount() then
    if DataModel.HasWorkingMachine(DataModel.curRoomIndex, elementIndex) then
      if DataModel.HasWorkingPrisoner(DataModel.curRoomIndex, elementIndex) then
        state = WorkerElementStateType.HasPrisoner
      else
        state = WorkerElementStateType.NoPrisoner
      end
    else
      state = WorkerElementStateType.Empty
    end
  end
  emptyCtr:SetActive(state == WorkerElementStateType.Empty)
  noPrisonerCtr:SetActive(state == WorkerElementStateType.NoPrisoner)
  hasPrisonerCtr:SetActive(state == WorkerElementStateType.HasPrisoner)
  if state == WorkerElementStateType.Empty then
  elseif state == WorkerElementStateType.NoPrisoner then
    RefreshMachineElement(noPrisonerCtr, DataModel.GetWorkMachineUid(DataModel.curRoomIndex, elementIndex))
  elseif state == WorkerElementStateType.HasPrisoner then
    RefreshMachineElement(hasPrisonerCtr, DataModel.GetWorkMachineUid(DataModel.curRoomIndex, elementIndex))
    RefreshPrisonerElement(hasPrisonerCtr, DataModel.GetWorkPrisonerUid(DataModel.curRoomIndex, elementIndex))
  end
  element.Group_PrisonerUnplace.Group_SewingMachine.Img_SewingMachine.Btn_:SetClickParam(elementIndex)
  element.Group_PrisonerPlaced.Group_SewingMachine.Img_SewingMachine.Btn_:SetClickParam(elementIndex)
  element.Group_PrisonerUnplace.Group_PrisonerEmpty.Img_PrisonerEmpty.Btn_:SetClickParam(elementIndex)
  element.Group_PrisonerPlaced.Img_Prisoner.Btn_:SetClickParam(elementIndex)
end

function Controller:SetLockListElement(element, elementIndex)
  local lv = PrisonData.GetPrisonLv()
  local prisonCfg = PlayerData:GetFactoryData("86800014")
  local lvCfg = prisonCfg.lvList[lv]
  local idx = (DataModel.curRoomIndex - 1) * DataModel.designColCount + elementIndex
  local unlockCount = DataModel.GetUnlockGridCount(DataModel.curRoomIndex) // DataModel.designRowCount
  local ctr = View.Group_Lock.StaticGrid_.grid[elementIndex]
  if elementIndex <= unlockCount then
    ctr:SetActive(false)
  else
    ctr.Group_Mask.Btn_Lock:SetActive(idx <= lvCfg.SpaceNum)
    ctr.Group_Mask.Effect_InTips:SetActive(idx <= lvCfg.SpaceNum)
    local ls = (DataModel.curRoomIndex - 1) * 5 + 1
    local le = DataModel.curRoomIndex * 5
    for i = ls, le do
      if idx <= prisonCfg.lvList[i].SpaceNum then
        element.Group_Mask.Group_Num.Txt_NumunLock:SetActive(i <= PrisonData.GetPrisonLv())
        element.Group_Mask.Group_Num.Txt_NumLock:SetActive(i > PrisonData.GetPrisonLv())
        element.Group_Mask.Group_Level.Txt_leveunlLock:SetActive(i <= PrisonData.GetPrisonLv())
        element.Group_Mask.Group_Level.Txt_levelLock:SetActive(i > PrisonData.GetPrisonLv())
        element.Group_Mask.Group_Num.Txt_NumunLock:SetText(string.format("%02d", i))
        element.Group_Mask.Group_Num.Txt_NumLock:SetText(string.format("%02d", i))
        break
      end
    end
  end
end

function Controller:SetPrisonerListElement(element, elementIndex)
  local pData = DataModel.filterPrisoner[elementIndex]
  local roomIndex, posIndex = DataModel.GetPrisonerWorkingRoomAndPos(pData.u_pid)
  local cfg = PlayerData:GetFactoryData(pData.id)
  element.Group_Normal.Group_Time.Txt_Num:SetText(pData.days)
  element.Group_Normal.Img_PickBG:SetActive(pData.isCurChoose)
  element.Group_Normal.Group_UnitPick:SetActive(pData.isCurChoose)
  if DataModel.PrisonerFilterTarget == 1 then
    element.Btn_Rest:SetActive(pData.isCurChoose)
    element.Btn_Working:SetActive(not pData.isCurChoose)
  elseif DataModel.PrisonerFilterTarget == 2 then
    element.Btn_Rest:SetActive(false)
    element.Btn_Working:SetActive(false)
  end
  if DataModel.PrisonerFilterTarget == 1 then
    element.Btn_NoMonitor:SetActive(pData.isCurChoose and DataModel.IsRoomMonitor(pData.u_pid))
    element.Btn_Monitor:SetActive(pData.isCurChoose and not DataModel.IsRoomMonitor(pData.u_pid))
  else
    element.Btn_NoMonitor:SetActive(pData.isCurChoose)
    element.Btn_Monitor:SetActive(not pData.isCurChoose)
  end
  element.Group_Normal.Img_Pic:SetSprite(cfg.prisonerIconPath)
  element.Group_Normal.Txt_Name:SetText(cfg.prisonerName)
  element.Group_Normal.Txt_State:SetText(roomIndex == -1 and GetText(80601381) or string.format(GetText(80601357), roomIndex))
  element.Group_Normal.Group_ID.Txt_ID:SetText(string.format("%06d", tonumber(pData.clint_num)))
  element.Btn_Working:SetClickParam(elementIndex)
  element.Btn_Rest:SetClickParam(elementIndex)
  element.Btn_NoMonitor:SetClickParam(elementIndex)
  element.Btn_Monitor:SetClickParam(elementIndex)
end

function Controller:SetRoomNaviElement(element, elementIndex)
  element.Btn_train:SetClickParam(elementIndex)
  local machineType = DataModel.GetRoomMachineType(elementIndex)
  local icon
  if machineType == -1 then
    icon = PlayerData:GetFactoryData(12600593).iconPath
  else
    icon = PlayerData:GetFactoryData(machineType).iconPath
  end
  element.Btn_train.Img_Select.Img_Icon:SetSprite(icon)
  element.Btn_train.Img_UnSelect.Img_Icon:SetSprite(icon)
  element.Btn_train.Img_Select:SetActive(elementIndex == DataModel.curRoomIndex)
  element.Btn_train.Img_UnSelect:SetActive(elementIndex ~= DataModel.curRoomIndex)
  element.Btn_train.Img_Empty:SetActive(elementIndex > DataModel.totalRoomCount or DataModel.RoomIsWorking(elementIndex))
end

function Controller:GoLeftRoom()
  if DataModel.isDrag then
    return
  end
  DataModel.curRoomIndex = DataModel.curRoomIndex - 1
  if DataModel.curRoomIndex <= 0 then
    DataModel.curRoomIndex = DataModel.totalRoomCount
  end
  Controller:ChangeRoom()
end

function Controller:GoRightRoom()
  if DataModel.isDrag then
    return
  end
  DataModel.curRoomIndex = DataModel.curRoomIndex + 1
  if DataModel.curRoomIndex > DataModel.totalRoomCount then
    DataModel.curRoomIndex = 1
  end
  Controller:ChangeRoom()
end

function Controller:NaviChangeRoom(roomIndex)
  if roomIndex > DataModel.totalRoomCount then
    CommonTips.OpenTips(80607054)
    return
  end
  Controller:ChangeRoom(roomIndex)
  Controller:OpenNavigation()
end

function Controller:ChangeRoom(roomIndex)
  DataModel.curRoomIndex = roomIndex == nil and DataModel.curRoomIndex or roomIndex
  Controller:RefreshTopInfo()
  Controller:RefreshLockGrid()
  Controller:RefreshWorkerList()
  View.Group_Edit.NewScrollGrid_MachineList.grid.self:RefreshAllElement()
end

function Controller:ResetEdit()
end

function Controller:ExitEdit()
  Controller:RefreshLockGrid()
  Controller:RefreshBoxBtn()
  Controller:RefreshWorkerList()
  DataModel.roomEditDirty = {}
end

function Controller:LongPressWorkerListItem(index, isMachine)
  Controller:BeginDrag(index, isMachine)
end

function Controller:BeginDrag(idx, isMachine)
  if DataModel.RoomIsWorking(DataModel.curRoomIndex) then
    CommonTips.OpenTips(GetText(80607144))
    return
  end
  if DataModel.curFrameMouseUp then
    return
  end
  local id
  if isMachine then
    id = DataModel.GetWorkMachineInfo(DataModel.curRoomIndex, idx).id
  else
    id = DataModel.GetWorkPrisonerInfo(DataModel.curRoomIndex, idx).id
  end
  if not id then
    return
  end
  DataModel.isDrag = true
  DataModel.dragIdx = idx
  DataModel.dragShowMode = 0
  DataModel.isDragMachine = isMachine
  local pos = Input.mousePosition
  View.Group_Temp.self:SetAnchoredPosition(Vector2(pos.x, pos.y))
  local dragInfo = {}
  if isMachine then
    dragInfo.mInfo = DataModel.AddDragInfo(id, true)
    local pData = DataModel.GetWorkPrisonerInfo(DataModel.curRoomIndex, idx)
    if next(pData) ~= nil and not isMachineBag then
      dragInfo.pInfo = DataModel.AddDragInfo(pData.id, false)
    end
  else
    dragInfo.pInfo = DataModel.AddDragInfo(id, false)
  end
  View.Group_Temp.Img_TrainM:SetActive(dragInfo.mInfo ~= nil)
  View.Group_Temp.Img_TrainM:SetSprite(dragInfo.mInfo ~= nil and dragInfo.mInfo.thumbnail or nil)
  View.Group_Temp.Img_TrainP:SetActive(dragInfo.pInfo ~= nil)
  View.Group_Temp.Img_TrainP:SetSprite(dragInfo.pInfo ~= nil and dragInfo.pInfo.thumbnail or nil)
  View.Group_Temp.self:SetActive(true)
  View.Group_Edit.Img_TakeBack.self:SetActive(isMachine)
end

function Controller:Dragging()
  local res, toIdx = Controller:CalcDraggingPos()
  local mode = 0
  if res == -1 then
    mode = 1
  elseif res == 1 then
    mode = 1
  elseif res == 2 then
    if toIdx ~= -1 then
      mode = 2
    else
      mode = 1
    end
  end
  DataModel.dragShowMode = mode
end

function Controller:DragEnd()
  local res, toIdx = Controller:CalcDraggingPos()
  if res == -1 then
    View.Group_Temp.self:SetActive(false)
  elseif res == 2 and toIdx ~= -1 then
    if DataModel.isDragMachine then
      Controller:SwapMachine(DataModel.dragIdx, toIdx)
      Controller:SwapPrison(DataModel.dragIdx, toIdx)
    else
      Controller:SwapPrison(DataModel.dragIdx, toIdx)
    end
    local element1 = View.Group_WorkerList.StaticGrid_Unit.grid[DataModel.dragIdx]
    local element2 = View.Group_WorkerList.StaticGrid_Unit.grid[toIdx]
    Controller:SetWorkerListElement(element1, DataModel.dragIdx)
    Controller:SetWorkerListElement(element2, toIdx)
    Controller:RefreshBottom()
  end
  DataModel.dragIdx = 0
  View.Group_Temp.self:SetActive(false)
  View.Group_Edit.Img_TakeBack.self:SetActive(false)
end

function Controller:CalcDraggingPos()
  local pos = View.Group_Edit.transform:InverseTransformPoint(View.Group_Temp.self.transform.position)
  local rect = View.Group_Edit.Img_TakeBack.self.Rect.rect
  local viewPos = View.Group_Edit.transform:InverseTransformPoint(View.Group_Edit.Img_TakeBack.self.transform.position)
  local limitLeftX = viewPos.x - rect.width * 0.5
  local limitRightX = viewPos.x + rect.width * 0.5
  local limitTopY = viewPos.y + rect.height * 0.5
  local limitBottomY = viewPos.y - rect.height * 0.5
  if limitBottomY < pos.y and limitTopY > pos.y and limitLeftX < pos.x and limitRightX > pos.x then
    return -1
  end
  pos = View.Group_WorkerList.StaticGrid_Unit.self.transform:InverseTransformPoint(View.Group_Temp.self.transform.position)
  local halfX = DataModel.machineCellSize.x * 0.5
  local halfY = DataModel.machineCellSize.y * 0.5
  local toIdx = -1
  local maxCount = DataModel.GetUnlockGridCount()
  for i = 1, maxCount do
    local grid = View.Group_WorkerList.StaticGrid_Unit.grid[i]
    if grid ~= nil then
      local gridPos = grid.self.transform.localPosition
      local leftX = gridPos.x - halfX
      local rightX = gridPos.x + halfX
      local upY = gridPos.y + halfY
      local downY = gridPos.y - halfY
      if leftX < pos.x and rightX > pos.x and upY > pos.y and downY < pos.y then
        toIdx = i
        break
      end
    end
  end
  return 2, toIdx
end

function Controller:TryUnlockNextArea()
  local canUnlock, targetUnlockArea = DataModel.CheckNextAreaCanUnlock()
  if not canUnlock then
    return
  end
  if DataModel.RoomIsWorking(DataModel.curRoomIndex) then
    CommonTips.OpenTips(GetText(80607144))
    return
  end
  local prisonCfg = PrisonData.GetPrisonCA()
  local price = prisonCfg.buySpacePrice[1].num
  local t = {}
  t.itemId = 11400001
  t.useNum = price
  t.addUnit = true
  CommonTips.OnItemPrompt(string.format(GetText(80607111), price), t, function()
    if PlayerData:GetGoodsById(t.itemId).num < t.useNum then
      CommonTips.OpenTips(80600062)
      return
    end
    Net:SendProto("prison.unlock_front", function(json)
      if json.reward then
        CommonTips.OpenShowItem(json.reward)
      end
      if json.furniture then
        PlayerData.ServerData.user_prison_info.furniture = json.furniture
      end
      UIManager:Open("UI/Prison/Manage/OpenWorkshopSuccess", Json.encode({
        unlockIndex = targetUnlockArea,
        workshops_front = json.workshops_front
      }))
    end, tostring(DataModel.curRoomIndex))
  end)
end

function Controller:OneBtnToPutPrisoner(isAddOne)
  local unlockGridCount = DataModel.GetUnlockGridCount()
  local canWorkPrisoner = {}
  for i, v in pairs(DataModel.prisonerData) do
    if v.roomIndex == -1 and v.posIndex == -1 then
      table.insert(canWorkPrisoner, v.server)
    end
  end
  if #canWorkPrisoner == 0 then
    return
  end
  for i = 1, unlockGridCount do
    if DataModel.HasWorkingMachine(DataModel.curRoomIndex, i) and not DataModel.HasWorkingPrisoner(DataModel.curRoomIndex, i) and 0 < table.count(canWorkPrisoner) then
      DataModel.PrisonerToWork(canWorkPrisoner[1], i)
      table.remove(canWorkPrisoner, 1)
      if isAddOne then
        break
      end
    end
  end
  Controller:RefreshWorkerList()
  Controller:RefreshTopInfo()
  Controller:RefreshBottom()
end

function Controller:AddPrisonerToWork()
  local roomPrisonerCount = DataModel.GetRoomPrisonerCount(DataModel.curRoomIndex)
  local unlockGridCount = DataModel.GetUnlockGridCount(DataModel.curRoomIndex)
  if roomPrisonerCount >= unlockGridCount then
    return
  end
  Controller:OneBtnToPutPrisoner(true)
end

function Controller:RemovePrisonerFromWork()
  local roomPrisonerCount = DataModel.GetRoomPrisonerCount(DataModel.curRoomIndex)
  local unlockGridCount = DataModel.GetUnlockGridCount(DataModel.curRoomIndex)
  if roomPrisonerCount == 0 then
    return
  end
  for i = unlockGridCount, 1, -1 do
    if DataModel.HasWorkingPrisoner(DataModel.curRoomIndex, i) then
      Controller:PrisonerToRest(i)
      break
    end
  end
  Controller:RefreshWorkerList()
  Controller:RefreshTopInfo()
  Controller:RefreshBottom()
end

function Controller:PrisonerToWork(idx)
  local complete = DataModel.PrisonerToWork(DataModel.filterPrisoner[idx], DataModel.curChoosePosIndex)
  if complete then
    View.PrisonerListManage:SetActive(false)
    Controller:RefreshWorkerList()
    DataModel.curChoosePosIndex = -1
    Controller:RefreshTopInfo()
    Controller:RefreshBottom()
  end
end

function Controller:PrisonerToRest(posIndex)
  local targetPosIndex = posIndex or DataModel.curChoosePosIndex
  local complete = DataModel.PrisonerToRest(DataModel.GetWorkPrisonerInfo(DataModel.curRoomIndex, targetPosIndex).u_pid, targetPosIndex)
  if complete then
    View.PrisonerListManage:SetActive(false)
    Controller:RefreshWorkerList()
    DataModel.curChoosePosIndex = -1
    Controller:RefreshTopInfo()
    Controller:RefreshBottom()
  end
end

function Controller:SwapMachine(dragIdx, toIdx)
  if dragIdx == toIdx then
    return
  end
  DataModel.SwapMachine(dragIdx, toIdx)
end

function Controller:SwapPrison(dragIdx, toIdx)
  if dragIdx == toIdx then
    return
  end
  DataModel.SwapPrison(dragIdx, toIdx)
end

function Controller:RefreshBagTitleElement(element, elementIndex)
  local machineType = DataModel.machineTypes[elementIndex]
  local tagCA = PlayerData:GetFactoryData(machineType, "TagFactory")
  element.Btn_Custom.self:SetClickParam(elementIndex)
  local isSelect = machineType == DataModel.curMachineTypeSelect
  element.Btn_Custom.Img_CustomLight.self:SetActive(isSelect)
  element.Btn_Custom.Group_Custom.self:SetActive(not isSelect)
  if isSelect then
    element.Btn_Custom.Img_CustomLight.Img_Customselect:SetSprite(tagCA.iconPath)
    element.Btn_Custom.Img_CustomLight.Txt_Customselect:SetText(tagCA.typeName)
  else
    element.Btn_Custom.Group_Custom.Img_Custom:SetSprite(tagCA.iconPath)
    element.Btn_Custom.Group_Custom.Txt_Custom:SetText(tagCA.typeName)
  end
end

function Controller:SwitchBottomType(type)
  if type == DataModel.CurBottomTab then
    return
  end
  DataModel.CurBottomTab = type
  View.Group_Edit.Btn_NormalMachine.Img_NormalMachineLight:SetActive(type == 1)
  View.Group_Edit.Btn_NormalPrisoner.Img_NormalMachineLight:SetActive(type == 2)
  View.Group_Edit.Group_Machine:SetActive(type == 1)
  View.Group_Edit.Group_Prisoner:SetActive(type == 2)
  Controller:RefreshBottom()
end

function Controller:ShowMachineDetailPanel(type, btn, str)
  local idx = tonumber(str)
  local u_fid
  if type == 2 then
    u_fid = DataModel.GetCurMachineBagInfo(idx)
  end
  if not u_fid or u_fid == "" then
    return
  end
  local id = DataModel.allMachine[u_fid].id
  CommonTips.OpenFurnitureTip(id, table.count(DataModel.machineBagGridData[idx].machines))
end

function Controller:OpenNavigation()
  View.Group_Windows:SetActive(true)
  View.Group_Windows.Img_Base.StaticGrid_Train.grid.self:SetDataCount(6)
  View.Group_Windows.Img_Base.StaticGrid_Train.grid.self:RefreshAllElement()
end

function Controller:TryUpgradeMachine(bagIdx)
  local u_fid = DataModel.CurSelectMachineUId
  if u_fid == "" then
    return
  end
  local id = DataModel.allMachine[u_fid].id
  local cfg = PlayerData:GetFactoryData(id)
  if cfg == nil then
    return
  end
  if cfg.upgrade == -1 then
    return
  end
  if DataModel.RoomIsWorking(DataModel.curRoomIndex) then
    CommonTips.OpenTips(GetText(80607144))
    return
  end
  
  local function succCb()
    DataModel.UpdateMachineData(u_fid)
    Controller:RefreshWorkerList()
    Controller:RefreshBottom()
  end
  
  local t = {}
  t.furUfid = u_fid
  t.furId = id
  UIManager:Open("UI/HomeUpgrade/HomeUpgrade", Json.encode(t), succCb)
end

function Controller:ShowPrisonerPanel()
  PrisonerController.InitFilter()
  PrisonerController:Filter()
  View.PrisonerListManage:SetActive(true)
  View.PrisonerListManage.Group_Screen:SetActive(false)
  Controller:RefreshPrisonerList()
end

function Controller:SetRoomMonitor(isOn, u_pid)
  if isOn then
    DataModel.monitorData[DataModel.curRoomIndex] = u_pid
  else
    DataModel.monitorData[DataModel.curRoomIndex] = ""
  end
  DataModel.SetDirty()
  View.PrisonerListManage:SetActive(false)
  Controller:RefreshTopInfo()
  Controller:RefreshWorkerList()
  Controller:RefreshBottom()
  DataModel.curChoosePosIndex = -1
end

function Controller:CalEfficiency()
  local totalEff = 0
  local unlockGrid = DataModel.GetUnlockGridCount(DataModel.curRoomIndex)
  for i = 1, unlockGrid do
    local pData = DataModel.GetWorkPrisonerInfo(DataModel.curRoomIndex, i)
    if next(pData) ~= nil then
      totalEff = totalEff + 1
    end
  end
  return totalEff
end

function Controller:CheckLevelUp()
  local prisonCfg = PrisonData.GetPrisonCA()
  local maxLevel = table.count(prisonCfg.lvList)
  local exp = PlayerData.ServerData.user_prison_info.exp
  local lv = PlayerData.ServerData.user_prison_info.lv
  local curLvCfg = prisonCfg.lvList[lv]
  local targetLv = lv
  local targetExp = exp
  if maxLevel <= lv then
    return
  end
  if exp >= curLvCfg.exp then
    while targetExp >= curLvCfg.exp and maxLevel > targetLv do
      targetExp = targetExp - curLvCfg.exp
      targetLv = targetLv + 1
      curLvCfg = prisonCfg.lvList[targetLv]
    end
    if targetLv == maxLevel and targetExp > curLvCfg.exp then
      targetExp = curLvCfg.exp
    end
    PlayerData.ServerData.user_prison_info.lv = math.floor(targetLv)
    PlayerData.ServerData.user_prison_info.exp = math.floor(targetExp)
  else
    return
  end
end

function Controller:AreaUnlockCallBack(targetUnlockArea, workshops_front)
  if targetUnlockArea < 0 or workshops_front == nil then
    return
  end
  local unlockCtr = View.Group_UnLockEffect
  local baseCtr = View.Group_Lock.StaticGrid_.grid[targetUnlockArea]
  unlockCtr.self:SetActive(false)
  unlockCtr.Group_Mask.Group_Num.Txt_NumunLock:SetText(baseCtr.Group_Mask.Group_Num.Txt_NumunLock.Txt.text)
  unlockCtr.transform.position = baseCtr.self.transform.position
  unlockCtr.self:SetActive(true)
  local lockAnimator = unlockCtr.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
  lockAnimator:Play("UnLock")
  for i = 1, 3 do
    local targetIndex = (targetUnlockArea - 1) * 3 + i
    if 0 < targetIndex and targetIndex <= 18 then
      if not DataModel.workShopsData[tostring(DataModel.curRoomIndex)] then
        DataModel.workShopsData[tostring(DataModel.curRoomIndex)] = {}
      end
      DataModel.workShopsData[tostring(DataModel.curRoomIndex)][tostring(targetIndex)] = {u_fid = "", u_pid = ""}
      local element = View.Group_WorkerList.StaticGrid_Unit.grid[targetIndex]
      Controller:SetWorkerListElement(element, targetIndex)
    end
  end
  Controller:RefreshLockGrid()
  if PrisonData.roomIndex == DataModel.curRoomIndex then
    PrisonController.InitRoom(DataModel.curRoomIndex)
  end
end

function Controller:SaveChanges(isGoBack, isGoHome)
  if table.count(DataModel.roomEditDirty) == 0 then
    return
  end
  local changeRoomData = {}
  local changeRoomMonitorData = {}
  for index, value in pairs(DataModel.roomEditDirty) do
    local unlockGridCount = DataModel.GetUnlockGridCount(index)
    local row = {}
    for i = 1, unlockGridCount do
      local u_fid = DataModel.GetWorkMachineUid(index, i) or ""
      local u_pid = DataModel.GetWorkPrisonerUid(index, i) or ""
      if u_pid ~= "" and (not DataModel.CheckPrisonerIsInTime(u_pid) or not u_pid) then
        u_pid = ""
      end
      row[tostring(i)] = {u_fid = u_fid, u_pid = u_pid}
    end
    changeRoomData[tostring(index)] = row
    for roomIndex, pid in pairs(DataModel.monitorData) do
      DataModel.monitorData[tonumber(roomIndex)] = DataModel.CheckPrisonerIsInTime(pid) and DataModel.monitorData[tonumber(roomIndex)] or ""
    end
    changeRoomMonitorData[tostring(index)] = DataModel.monitorData[tonumber(index)]
  end
  DataModel.roomEditDirty = {}
  Net:SendProto("prison.modify_front", function(json)
    DataModel.UpdateWorkShopData(json.workshops_front, json.workshops_master)
    Controller:RefreshTopInfo()
    Controller:RefreshWorkerList()
    if not isGoHome then
      if isGoBack then
        if PrisonData.roomIndex == DataModel.curRoomIndex then
          PrisonController.InitRoom(PrisonData.roomIndex)
        else
          PrisonController.ChangeRoom(DataModel.curRoomIndex)
        end
        if UIManager:IsPanelOpened("UI/Prison/Main/PrisonMain") then
          local PrisonMainData = require("UIPrisonMain/UIPrisonMainDataModel")
          PrisonMainData.ModifyRefresh()
        end
      elseif PrisonData.roomIndex == DataModel.curRoomIndex then
        PrisonController.InitRoom(PrisonData.roomIndex)
      elseif changeRoomData[tostring(PrisonData.roomIndex)] ~= nil then
        PrisonController.InitRoom(PrisonData.roomIndex)
      end
    end
    CommonTips.OpenTips(80600209)
  end, Json.encode(changeRoomData), Json.encode(changeRoomMonitorData))
end

return Controller
