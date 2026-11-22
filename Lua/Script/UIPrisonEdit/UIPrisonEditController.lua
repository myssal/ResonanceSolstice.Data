local DataModel = require("UIPrisonEdit/UIPrisonEditDataModel")
local View = require("UIPrisonEdit/UIPrisonEditView")
local CommonItem = require("Common/BtnItem")
local Controller = {}
local WorkerElementStateType = {
  Lock = 0,
  NoPrisoner = 1,
  HasPrisoner = 2
}
local filterData = {}

local function ControllerFilterBtn()
  local characterData = filterData[View.PrisonerListManage.Group_Screen.Group_Career.name]
  local specialData = filterData[View.PrisonerListManage.Group_Screen.Group_Group.name]
  local qualityData = filterData[View.PrisonerListManage.Group_Screen.Group_Rarity.name]
  View.PrisonerListManage.Group_TopRightPrison.Btn_Screen.Img_P:SetActive(characterData ~= nil and characterData.count ~= 0 or specialData ~= nil and specialData.count ~= 0 or qualityData ~= nil and qualityData.count ~= 0)
end

local function SetFilterView(Type)
  local data = filterData[Type.name]
  for k, v in pairs(Type) do
    if k == "self" or k == "Txt_" then
    elseif data[k] ~= nil then
      v.Img_Select:SetActive(true)
    elseif v ~= nil then
      v.Img_Select:SetActive(false)
    end
  end
end

local function IsMeetFilter(data, property)
  local isMeet = false
  for k, v in pairs(data) do
    if k ~= "count" and k ~= "length" and k ~= "property" and (v == 0 or v == property) then
      isMeet = true
      break
    end
  end
  return isMeet
end

local function InitFilterRolesData(Type, property)
  local name = Type.name
  if type(filterData[name]) == "nil" then
    local length = 0
    if name == "Group_Career" then
      length = 0
      local config = PlayerData:GetFactoryData(99900017).prisonPersonalityNameList
      for i = 1, table.count(config) do
        local btn = "Btn_C0" .. i
        if 10 <= i then
          btn = "Btn_C" .. i
        end
        if Type[btn] then
          Type[btn].self:SetActive(true)
          Type[btn].Txt_:SetText(PlayerData:GetFactoryData(config[i].id).prisonerPersonalityName)
          length = length + 1
        end
      end
    end
    if name == "Group_Group" then
      length = 0
      local config = PlayerData:GetFactoryData(99900017).prisonSpecialityList
      for i = 1, table.count(config) do
        local btn = "Btn_G0" .. i
        if Type[btn] then
          Type[btn].self:SetActive(true)
          Type[btn].Txt_:SetText(PlayerData:GetFactoryData(config[i].id).prisonerSpeciality)
          length = length + 1
        end
      end
    end
    if name == "Group_Rarity" then
      length = 0
      local config = {
        [1] = {id = 12601046},
        [2] = {id = 12601047},
        [3] = {id = 12601048}
      }
      for k, v in pairs(config) do
        local btn = "Btn_R0" .. k
        if btn == "Btn_R04" then
          Type[btn].self:SetActive(false)
        else
          local row = PlayerData:GetFactoryData(v.id)
          if Type[btn] then
            Type[btn].self:SetActive(true)
            Type[btn].Txt_:SetText(row.enemyTypeName)
            length = length + 1
          end
        end
      end
    end
    filterData[name] = {}
    filterData[name].length = length
    filterData[name].property = property
  end
  local data = {}
  data.length = filterData[name].length
  data.property = filterData[name].property
  data[Type.Btn_All.name] = 0
  data.count = 0
  filterData[name] = data
  SetFilterView(Type)
  ControllerFilterBtn()
end

function Controller:Init()
  DataModel.InitData()
  Controller:InitFilter()
  Controller:InitView()
  Controller:SelectWorkerElement(DataModel.CurSelectWorkerIndex, true)
  DataModel.isFirst = true
  DataModel.SortState.index = 1
  DataModel.SortState.currentDown = true
  Controller:Reset(View.PrisonerListManage.Group_TopRightPrison.Btn_Level)
  View.Group_Edit.Group_Detail.Group_PrisonerInfo.Group_PrisonerInfo.Group_PrisonDetail.UI_WorkerLeads_02.self:SetActive(false)
  View.Group_Edit.Btn_QuickEdit.Img_RedPoint:SetActive(PrisonData.CheckProductRoomRedPoint(DataModel.CurRoomIndex))
end

function Controller:InitView()
  View.PrisonerListManage:SetActive(false)
  Controller:RefreshTopInfo()
  Controller:RefreshAllWorkerListElement()
  Controller:RefreshLockGrid()
  View.Btn_Left:SetActive(DataModel.TotalRoomCount > 1)
  View.Btn_Light:SetActive(DataModel.TotalRoomCount > 1)
end

local function GetAllCanChoosePrisoner()
  local rlt = {}
  for i, v in ipairs(DataModel.SortFilterPrisoner) do
    local state = DataModel.GetPrisonerState(v.u_pid)
    if (state == DataModel.PrisonerState.Free or state == DataModel.PrisonerState.InPrepare) and DataModel.SelectPrisonerPid2Index[v.u_pid] == nil then
      table.insert(rlt, v)
    end
  end
  return rlt
end

local function GetQuickSquadNextEmptyPos()
  local unlockGrid = DataModel.GetUnlockGridCount()
  for i = 1, unlockGrid do
    if DataModel.SelectPrisonerIndex2Pid[i] == nil then
      return true, i
    end
  end
  return false
end

function Controller:SetWorkerListElement(element, elementIndex)
  local unlockGridCount = DataModel.GetUnlockGridCount(DataModel.CurRoomIndex)
  if elementIndex <= unlockGridCount then
    element.Group_Machine:SetActive(true)
    local machineId = DataModel.GetWorkMachineInfo(DataModel.CurRoomIndex, elementIndex).id
    local hasPrisoner = DataModel.HasWorkingPrisoner(DataModel.CurRoomIndex, elementIndex)
    local hasPlant, isFinish, remainTime = DataModel.IsWorkPlaceHasPlant(DataModel.CurRoomIndex, elementIndex)
    local machineCfg = PlayerData:GetFactoryData(machineId)
    element.Group_Machine.Img_Machine:SetSprite(machineCfg.iconPath)
    element.Group_Machine.Txt_MachineLevel:SetText("LV." .. machineCfg.Level)
    element.Group_PrisonerEmpty:SetActive(not hasPrisoner)
    element.Group_PrisonerPlaced:SetActive(hasPrisoner)
    element.Group_PrisonerPlaced.Group_Frame:SetActive(true)
    local isSelected = DataModel.CurSelectWorkerIndex == elementIndex
    element.Group_ProductCondition:SetActive(hasPlant)
    if hasPlant then
      local plantData = DataModel.GetWorkPlacePlantData(DataModel.CurRoomIndex, elementIndex)
      if not plantData then
        element.Group_ProductCondition:SetActive(false)
      else
        element.Group_ProductCondition:SetActive(true)
        element.Group_ProductCondition.Group_ProductStop:SetActive(false)
        element.Group_ProductCondition.Group_Producting:SetActive(not isFinish)
        element.Group_ProductCondition.Group_ProductFinish:SetActive(isFinish)
        element.Group_ProductCondition.Group_Mask:SetActive(true)
        if 0 < remainTime then
          local timeTbl = TimeUtil:SecondToTable(remainTime)
          element.Group_PrisonerPlaced.Group_Frame.Group_NoSelect.Txt_WorkTime:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
          element.Group_PrisonerPlaced.Group_Frame.Group_Select.Txt_WorkTime:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
          local handler = {
            finishTime = TimeUtil:GetServerTimeStamp() + remainTime,
            ctr1 = element.Group_PrisonerPlaced.Group_Frame.Group_NoSelect.Txt_WorkTime,
            ctr2 = element.Group_PrisonerPlaced.Group_Frame.Group_Select.Txt_WorkTime
          }
          table.insert(DataModel.CountDownHandler, handler)
        end
        element.Group_ProductCondition.Img_Item:SetSprite(PlayerData:GetFactoryData(plantData.formulaGroupId).iconPath)
        element.Group_ProductCondition.Txt_Num:SetText(DataModel.CalWorkerPlaceProductNum(elementIndex))
      end
    end
    if hasPrisoner then
      local pData = DataModel.GetWorkPrisonerInfo(DataModel.CurRoomIndex, elementIndex)
      local u_pid = DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, elementIndex)
      local prisonerId = pData.prisoner_id
      local prisonerCfg = PlayerData:GetFactoryData(prisonerId)
      element.Group_PrisonerPlaced.Img_Prisoner:SetSprite(prisonerCfg.prisonerIconPath)
      local isMonitor = DataModel.IsRoomMonitor(DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, elementIndex))
      element.Group_PrisonerPlaced.Group_Frame.Group_NoSelect:SetActive(not isSelected)
      element.Group_PrisonerPlaced.Group_Frame.Group_Select:SetActive(isSelected)
      element.Group_PrisonerPlaced.Group_Frame.Group_NoSelect.Group_Monitor:SetActive(isMonitor and not isSelected)
      element.Group_PrisonerPlaced.Group_Frame.Group_Select.Group_Monitor:SetActive(isMonitor and isSelected)
      local personalityCfg = PlayerData:GetFactoryData(pData.personality_id)
      local monitorCfg = PlayerData:GetFactoryData(pData.monitor)
      element.Group_PrisonerPlaced.Group_Character.Txt_CommonCharacter:SetActive(not isMonitor)
      element.Group_PrisonerPlaced.Group_Character.Txt_CommonCharacter:SetText(personalityCfg.prisonerPersonalityName)
      element.Group_PrisonerPlaced.Group_Character.Txt_MonitorPosition:SetActive(isMonitor)
      element.Group_PrisonerPlaced.Group_Character.Txt_MonitorPosition:SetText(monitorCfg.monitorJobName)
      element.Group_PrisonerPlaced.Group_Character.Txt_MonitorCharacter:SetActive(isMonitor)
      element.Group_PrisonerPlaced.Group_Character.Txt_MonitorCharacter:SetText(personalityCfg.prisonerPersonalityName)
      element.Group_PrisonerPlaced.Group_Frame.Group_NoSelect.Txt_WorkTime:SetText("--:--:--")
      element.Group_PrisonerPlaced.Group_Frame.Group_Select.Txt_WorkTime:SetText("--:--:--")
    else
      element.Group_PrisonerEmpty.Group_Frame.Group_NoSelect:SetActive(not isSelected)
      element.Group_PrisonerEmpty.Group_Frame.Group_Select:SetActive(isSelected)
    end
  else
    element.Group_Machine:SetActive(false)
    element.Group_PrisonerEmpty:SetActive(false)
    element.Group_PrisonerPlaced:SetActive(false)
    element.Group_ProductCondition:SetActive(false)
  end
  element.Btn_:SetClickParam(elementIndex)
end

function Controller:RefreshAllWorkerListElement()
  DataModel.CountDownHandler = {}
  View.Group_WorkerList.StaticGrid_Unit.grid.self:SetDataCount(18)
  View.Group_WorkerList.StaticGrid_Unit.grid.self:RefreshAllElement()
end

function Controller:SetLockListElement(element, elementIndex)
  local lv = PrisonData.GetPrisonLv()
  local prisonCfg = PlayerData:GetFactoryData("86800014")
  local lvCfg = prisonCfg.lvList[lv]
  local idx = (DataModel.CurRoomIndex - 1) * DataModel.designColCount + elementIndex
  local unlockCount = DataModel.GetUnlockGridCount(DataModel.CurRoomIndex) // DataModel.designRowCount
  local ctr = View.Group_Lock.StaticGrid_.grid[elementIndex]
  if elementIndex <= unlockCount then
    ctr:SetActive(false)
  else
    ctr.Group_Mask.Btn_Lock:SetActive(idx <= lvCfg.SpaceNum)
    ctr.Group_Mask.Effect_InTips:SetActive(idx <= lvCfg.SpaceNum)
    local ls = (DataModel.CurRoomIndex - 1) * 5 + 1
    local le = DataModel.CurRoomIndex * 5
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

function Controller:RefreshLockGrid()
  View.Group_Lock:SetActive(true)
  View.Group_Lock.StaticGrid_.grid.self:SetDataCount(6)
  View.Group_Lock.StaticGrid_.grid.self:RefreshAllElement()
end

function Controller:RefreshLevel()
  View.Group_Top.Group_PrisonIcon.Group_.Txt_Num:SetText(PrisonData.GetPrisonLv())
  local LevelDataModel = require("UIPrisonLevel/UIPrisonLevelDataModel")
  View.Group_Top.Group_PrisonIcon.Group_.Img_RedDot:SetActive(LevelDataModel.CheckHasRedPoint())
end

function Controller:RefreshTopInfo()
  View.Group_Top.Group_WorkshopInfo.Txt_Workshop:SetText(string.format(GetText(80600296), DataModel.CurRoomIndex))
  Controller:RefreshLevel()
  View.Group_Top.Group_TotalNum.Txt_TotalNumCount:SetText(DataModel.GetRoomPrisonerCount(DataModel.CurRoomIndex))
  if DataModel.GetUnlockGridCount() > 0 then
    local program = PlayerData.ServerData.user_prison_info.workshops_programme[tostring(DataModel.CurRoomIndex)] or "1"
    local type = PrisonData.GetPrisonCA().initialHomeFurnitureList[tonumber(program)].schemeType
    View.Group_Top.Group_WorkshopInfo.Txt_WorkshopName:SetText(PlayerData:GetFactoryData(type).typeName)
  else
    View.Group_Top.Group_WorkshopInfo.Txt_WorkshopName:SetText("")
  end
  local monitorPid = DataModel.monitorData[DataModel.CurRoomIndex]
  local pData = DataModel.prisonerData[monitorPid]
  if pData then
    local prisonCfg = PlayerData:GetFactoryData(pData.server.prisoner_id)
    local monitorCfg = PlayerData:GetFactoryData(prisonCfg.monitor)
    local buffCfg = PlayerData:GetFactoryData(monitorCfg.buffId)
    View.Group_Top.Group_Monitor.Txt_MonitorName:SetText(monitorCfg.monitorJobName)
    View.Group_Top.Group_Monitor.Txt_MonitorDescribe:SetText(string.format(buffCfg.desc, math.floor(buffCfg.probabilityParamClient)))
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

function Controller:PrisonerMeetFilter()
  local career = filterData[View.PrisonerListManage.Group_Screen.Group_Career.name]
  local campData = filterData[View.PrisonerListManage.Group_Screen.Group_Group.name]
  local qualityData = filterData[View.PrisonerListManage.Group_Screen.Group_Rarity.name]
  for k, v in pairs(DataModel.prisonerData) do
    v.server.workingIdx = DataModel.SearchPrisonerWorkingInt(v.server.u_pid)
    if DataModel.CheckPrisonerIsInTime(v.server.u_pid) and IsMeetFilter(career, v.server.personalityIdx) and IsMeetFilter(campData, v.server.specialityIdx) and IsMeetFilter(qualityData, v.server.rarityIdx) and DataModel.SelectPrisonerPid2Index[v.server.u_pid] == nil then
      if not DataModel.IsQuickSquad then
        if DataModel.GetPrisonerWorkingRoomAndPos(v.server.u_pid) ~= DataModel.CurRoomIndex then
          table.insert(DataModel.filterPrisoner, v.server)
        end
      else
        table.insert(DataModel.filterPrisoner, v.server)
      end
    end
  end
end

function Controller:FilterPrisoner()
  DataModel.filterPrisoner = {}
  Controller:PrisonerMeetFilter()
end

function Controller:SortFilterData()
  DataModel.SortFilterPrisoner = {}
  local index = DataModel.SortState.index
  if index == 1 then
    DataModel.SortFilterPrisoner = DataModel.filterPrisoner
    if DataModel.SortState.currentDown then
      Controller:SortDown(DataModel.SortFilterPrisoner)
    else
      Controller:SortUp(DataModel.SortFilterPrisoner)
    end
    return
  end
  if index == 2 then
    DataModel.SortFilterPrisoner = DataModel.filterPrisoner
    if DataModel.SortState.currentDown then
      Controller:TimeSortDown(DataModel.SortFilterPrisoner)
    else
      Controller:TimeSortUp(DataModel.SortFilterPrisoner)
    end
    return
  end
end

function Controller:SetPrisonerListElement(element, elementIndex)
  local row = DataModel.SortFilterPrisoner[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Group_Character.Group_Normal.Img_Pic:SetSprite(cfg.prisonerIconPath)
    element.Group_Character.Group_Normal.Group_Time.Txt_Num:SetText(row.days)
    element.Group_Character.Group_Normal.Txt_Name:SetText(cfg.prisonerName)
    element.Group_Character.Group_Normal.Group_ID.Img_Rarity:SetSprite(PlayerData:GetFactoryData(cfg.prisonerRarity).prisonerRarity)
    element.Group_Character.Group_Normal.Group_ID.Txt_ID:SetText(string.format("%06d", tonumber(row.clint_num)))
    element.Group_Character.Group_Normal.Group_Personality.Txt_:SetText(PlayerData:GetFactoryData(row.personality_id).prisonerPersonalityName)
    element.Group_Character.Group_Normal.Group_Personality.Img_:SetSprite(PlayerData:GetFactoryData(row.personality_id).icon)
    element.Group_Character.Group_Normal.Group_GoodAt.Txt_:SetText(PlayerData:GetFactoryData(row.speciality_id).prisonerSpeciality)
    element.Group_Character.Group_Normal.Group_GoodAt.Img_:SetSprite(PlayerData:GetFactoryData(row.speciality_id).icon)
    element.Group_Character.Group_Normal.Group_Skill.Txt_:SetText(PlayerData:GetFactoryData(cfg.monitor).monitorJobName)
    element.Group_Character.Group_Normal.Group_Outcome.Txt_Des:SetText(math.floor(cfg.extraOutputProbability * 100 + 0.5) .. "%")
    element.Group_Character.Group_Normal.Group_Health.Txt_:SetText(math.floor(row.healthy))
    element.Group_Character.Group_Normal.Group_Health.Img_Health:SetFilledImgAmount(row.healthy / 100)
    element.Group_Character.Group_InTeam:SetActive(DataModel.SelectPrisonerPid2Index[row.u_pid] ~= nil)
    local remainTime = math.ceil(row.remainTime / 86400)
    if remainTime < 0 then
      remainTime = 0
    end
    element.Group_Character.Group_Normal.Group_Time.Txt_Num:SetText(remainTime)
    local prisonerState = DataModel.GetPrisonerState(row.u_pid)
    element.Group_Character.Group_CantChoose:SetActive(prisonerState ~= DataModel.PrisonerState.Free and prisonerState ~= DataModel.PrisonerState.InPrepare)
    if prisonerState ~= DataModel.PrisonerState.Free and prisonerState ~= DataModel.PrisonerState.InPrepare then
      element.Group_Character.Group_CantChoose.Group_Medical:SetActive(prisonerState == DataModel.PrisonerState.InMedical)
      element.Group_Character.Group_CantChoose.Group_Punish:SetActive(prisonerState == DataModel.PrisonerState.InPunish)
      element.Group_Character.Group_CantChoose.Group_Produce:SetActive(prisonerState == DataModel.PrisonerState.InProduct)
    end
    local room, pos = DataModel.GetPrisonerWorkingRoomAndPos(row.u_pid)
    local hasPlaced = DataModel.SelectPrisonerPid2Index[row.u_pid] ~= nil
    if hasPlaced then
      element.Group_Character.Group_InTeam.Img_Label.Txt_:SetText(string.format(GetText(80608221), DataModel.SelectPrisonerPid2Index[row.u_pid]))
    end
    element.Group_Character.Img_Mask:SetActive(hasPlaced or prisonerState ~= DataModel.PrisonerState.Free and prisonerState ~= DataModel.PrisonerState.InPrepare)
    element.Group_Character.Group_Normal.Group_Workshop:SetActive(0 < room)
    if 0 < room then
      element.Group_Character.Group_Normal.Group_Workshop.Txt_:SetText(room)
    end
    element.Group_Character.Btn_Item:SetClickParam(elementIndex)
  end
end

function Controller:RefreshPrisonerList()
  Controller:FilterPrisoner()
  Controller:SortFilterData()
  if DataModel.IsQuickSquad then
    local unlockGrid = DataModel.GetUnlockGridCount()
    for i = unlockGrid, 1, -1 do
      if DataModel.SelectPrisonerIndex2Pid[i] ~= nil then
        local pId = DataModel.SelectPrisonerIndex2Pid[i]
        local pData = DataModel.prisonerData[pId]
        if pData and pData.server then
          table.insert(DataModel.SortFilterPrisoner, 1, pData.server)
        end
      end
    end
  else
    local pid = DataModel.SelectPrisonerIndex2Pid[DataModel.CurSelectWorkerIndex]
    local pData = DataModel.prisonerData[pid]
    if pData and pData.server then
      table.insert(DataModel.SortFilterPrisoner, 1, pData.server)
    end
  end
  Controller:RefreshPrisonerAllElement()
end

function Controller:RefreshPrisonerAllElement()
  local count = table.count(DataModel.SortFilterPrisoner)
  View.PrisonerListManage.ScrollGrid_Prison.grid.self:SetDataCount(count)
  View.PrisonerListManage.ScrollGrid_Prison.grid.self:RefreshAllElement()
  View.PrisonerListManage.Group_NoPrison:SetActive(count == 0)
end

function Controller:RefreshBottomInfoPanel()
  Controller:RefreshBottomMachinePanel()
  Controller:RefreshBottomPrisonerPanel()
end

function Controller:RefreshBottomMachinePanel()
  DataModel.UpgradeCostList = {}
  local row = DataModel.GetWorkMachineInfo(DataModel.CurRoomIndex, DataModel.CurSelectWorkerIndex)
  if row then
    local ctr = View.Group_Edit.Group_Detail.Group_MachineInfo
    local cfg = PlayerData:GetFactoryData(row.id)
    ctr.Group_Machine.Img_:SetSprite(cfg.iconPath)
    ctr.Group_Num.Img_titlebase.Txt_title:SetText("Lv.")
    ctr.Group_Num.Img_titlebase.Txt_LVNum:SetText(cfg.Level)
    ctr.Group_Num.Txt_NumData:SetText(math.floor(cfg.PrisonExtraOutputProbability * 100) .. "%")
    if cfg.upgrade == nil or cfg.upgrade < 0 then
      ctr.Btn_UpMachine:SetActive(false)
      ctr.Group_UpMachine:SetActive(false)
      ctr.Group_UpMachineMAX:SetActive(true)
      ctr.Group_Consume:SetActive(false)
    else
      ctr.Group_Consume:SetActive(true)
      local devLevel = PlayerData.ServerData.user_prison_info.rooms[tostring(87500010)].lv
      local levelCfg = PlayerData:GetFactoryData(PlayerData:GetFactoryData(87500010).roomList[devLevel].config)
      local unlockMachineLevel = PlayerData:GetFactoryData(levelCfg.unlockMachineList[1].id).Level
      local nextLevelCfg = PlayerData:GetFactoryData(cfg.upgrade)
      local isOverLevel = unlockMachineLevel < nextLevelCfg.Level
      ctr.Group_UpMachineMAX:SetActive(false)
      DataModel.UpgradeCostList = Clone(cfg.upgradeCostList)
      View.Group_Edit.Group_Detail.Group_MachineInfo.Group_Consume.StaticGrid_Consume.grid.self:SetDataCount(table.count(DataModel.UpgradeCostList))
      View.Group_Edit.Group_Detail.Group_MachineInfo.Group_Consume.StaticGrid_Consume.grid.self:RefreshAllElement()
      if isOverLevel then
        ctr.Group_UpMachine.Group_LevelLack.Txt_:SetText(string.format(GetText(80608053), DataModel.MachineLevelCache[tonumber(cfg.upgrade)]))
        ctr.Btn_UpMachine:SetActive(false)
        ctr.Group_UpMachine:SetActive(true)
      else
        ctr.Group_UpMachine:SetActive(false)
        ctr.Btn_UpMachine:SetActive(true)
      end
    end
  end
end

function Controller:AddUnit(num)
  local numTxt = tostring(num)
  if 1000 <= num and num < 1000000 then
    numTxt = tostring(math.floor(num / 1000)) .. "K"
  elseif 1000000 <= num and num < 1000000000 then
    numTxt = tostring(math.floor(num / 1000000)) .. "M"
  elseif 1000000000 <= num then
    numTxt = tostring(math.floor(num / 1000000000)) .. "G"
  end
  return numTxt
end

function Controller:SetUpgradeCostItemElement(element, elementIndex)
  local row = DataModel.UpgradeCostList[elementIndex]
  if row then
    CommonItem:SetItem(element.Group_Item, {
      id = row.id
    })
    local has = PlayerData:GetGoodsById(row.id).num
    local need = row.num
    if has < need then
      element.Txt_Need:SetText(string.format("<color=#CD5454>%s</color>", Controller:AddUnit(has)))
    else
      element.Txt_Need:SetText(string.format("%s", Controller:AddUnit(has)))
    end
    element.Txt_Have:SetText(string.format("%s", Controller:AddUnit(need)))
    element.Group_Item.Btn_Item:SetClickParam(row.id)
  end
end

function Controller:RefreshBottomPrisonerPanel()
  local hasPrisoner = DataModel.HasWorkingPrisoner(DataModel.CurRoomIndex, DataModel.CurSelectWorkerIndex)
  View.Group_Edit.Group_Detail.Group_PrisonerInfo.Group_PrisonerInfo.Group_Empty:SetActive(not hasPrisoner)
  View.Group_Edit.Group_Detail.Group_PrisonerInfo.Group_PrisonerInfo.Group_PrisonDetail:SetActive(hasPrisoner)
  if hasPrisoner then
    local data = DataModel.GetWorkPrisonerInfo(DataModel.CurRoomIndex, DataModel.CurSelectWorkerIndex)
    if not data then
      return
    end
    local cfg = PlayerData:GetFactoryData(data.id)
    local ctr = View.Group_Edit.Group_Detail.Group_PrisonerInfo.Group_PrisonerInfo.Group_PrisonDetail
    local prisonCfg = PlayerData:GetFactoryData(data.id)
    local monitorCfg = PlayerData:GetFactoryData(prisonCfg.monitor)
    ctr.Img_Side:SetSprite(PlayerData:GetFactoryData(cfg.prisonerSide).iconPath)
    ctr.Txt_Name:SetText(cfg.prisonerName)
    ctr.Img_pic:SetSprite(cfg.prisonerIconPath)
    local isMonitor = DataModel.IsRoomMonitor(data.u_pid, DataModel.CurRoomIndex)
    ctr.Group_Btn.Btn_Monitor:SetActive(not isMonitor)
    ctr.Group_Btn.Btn_MonitorDown:SetActive(isMonitor)
    ctr.Group_Personality.Txt_:SetText(PlayerData:GetFactoryData(data.personality_id).prisonerPersonalityName)
    ctr.Group_Personality.Img_:SetSprite(PlayerData:GetFactoryData(data.personality_id).icon)
    ctr.Group_GoodAt.Txt_:SetText(PlayerData:GetFactoryData(data.speciality_id).prisonerSpeciality)
    ctr.Group_GoodAt.Img_:SetSprite(PlayerData:GetFactoryData(data.speciality_id).icon)
    ctr.Group_Skill.Txt_:SetText(monitorCfg.monitorJobName)
    ctr.Group_Outcome.Txt_Des:SetText(math.floor(cfg.extraOutputProbability * 100) .. "%")
    ctr.Group_Time.Txt_Num:SetText(math.ceil(data.remainTime / 86400))
    ctr.Group_Cost.Txt_Num:SetText(string.format(GetText(80601033), cfg.prisonerCost[1].num))
    ctr.Group_Health.Txt_:SetText(math.floor(data.healthy))
    ctr.Group_Health.Img_Health:SetFilledImgAmount(data.healthy / 100)
    ctr.Img_MonitorFlag:SetActive(isMonitor)
    ctr.Group_ID.Img_Rarity:SetSprite(PlayerData:GetFactoryData(cfg.prisonerRarity).prisonerRarity)
    ctr.Group_Btn.Img_RedPoint:SetActive(DataModel.monitorData[DataModel.CurRoomIndex] == "")
  end
end

function Controller:PrisonerToWork(u_pid, toIdx, needKeepMonitor)
  local complete = DataModel.PrisonerToWork(u_pid, toIdx, needKeepMonitor)
  if complete then
    View.PrisonerListManage:SetActive(false)
    Controller:RefreshAllWorkerListElement()
    Controller:RefreshTopInfo()
    Controller:RefreshBottomInfoPanel()
  end
end

function Controller:PrisonerToRest(posIndex, needKeepMonitor)
  local targetPosIndex = posIndex or DataModel.CurSelectWorkerIndex
  local complete = DataModel.PrisonerToRest(DataModel.GetWorkPrisonerInfo(DataModel.CurRoomIndex, targetPosIndex).u_pid, targetPosIndex, needKeepMonitor)
  if complete then
    View.PrisonerListManage:SetActive(false)
    Controller:RefreshAllWorkerListElement()
    Controller:RefreshTopInfo()
    Controller:RefreshBottomInfoPanel()
  end
end

function Controller:SelectWorkerElement(idx, isInit)
  if DataModel.CurSelectWorkerIndex == idx and not isInit then
    return
  end
  local hasPlant, isFinish = DataModel.IsWorkPlaceHasPlant(DataModel.CurRoomIndex, idx)
  if hasPlant then
    if isFinish then
      return
    end
    if DataModel.HasWorkingPrisoner(DataModel.CurRoomIndex, idx) then
      return
    end
  end
  if idx > DataModel.GetUnlockGridCount() or idx <= 0 then
    return
  end
  local lastGrid = View.Group_WorkerList.StaticGrid_Unit.grid[DataModel.CurSelectWorkerIndex]
  local lastIdx = DataModel.CurSelectWorkerIndex
  local curGrid = View.Group_WorkerList.StaticGrid_Unit.grid[idx]
  DataModel.CurSelectWorkerIndex = idx
  if lastGrid then
    Controller:SetWorkerListElement(lastGrid, lastIdx)
  end
  if curGrid then
    Controller:SetWorkerListElement(curGrid, idx)
  end
  Controller:RefreshBottomInfoPanel()
end

function Controller:RefreshPrisonerListBottomPanel()
  local curCount = 0
  curCount = table.count(DataModel.SelectPrisonerIndex2Pid)
  local totalCount = DataModel.GetUnlockGridCount()
  View.PrisonerListManage.Group_Detail.Group_Prisoner.Txt_Num:SetText(string.format("<color=#FFB800>%d</color>/%d", curCount, totalCount))
  local hasCanChoose = 0 < table.count(GetAllCanChoosePrisoner())
  local hasNextPos = GetQuickSquadNextEmptyPos()
  View.PrisonerListManage.Group_Detail.Btn_All:SetActive(DataModel.IsQuickSquad and hasCanChoose and hasNextPos)
  View.PrisonerListManage.Group_Detail.Btn_AllCancel:SetActive(DataModel.IsQuickSquad and not hasCanChoose or not hasNextPos)
end

function Controller:ShowPrisonerList(isQuick)
  isQuick = isQuick or false
  DataModel.SelectPrisonerIndex2Pid = {}
  DataModel.SelectPrisonerPid2Index = {}
  DataModel.IsQuickSquad = isQuick
  if not isQuick then
    local pid = DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, DataModel.CurSelectWorkerIndex)
    if pid ~= "" then
      DataModel.SelectPrisonerPid2Index[pid] = DataModel.CurSelectWorkerIndex
      DataModel.SelectPrisonerIndex2Pid[DataModel.CurSelectWorkerIndex] = pid
    end
  else
    local unlockGrid = DataModel.GetUnlockGridCount()
    if not unlockGrid or unlockGrid == 0 then
      return
    end
    for i = 1, unlockGrid do
      local pid = DataModel.GetWorkPrisonerUid(DataModel.CurRoomIndex, i)
      if pid ~= "" then
        DataModel.SelectPrisonerPid2Index[pid] = i
        DataModel.SelectPrisonerIndex2Pid[i] = pid
      end
    end
  end
  View.PrisonerListManage:SetActive(true)
  Controller:RefreshPrisonerList()
  Controller:RefreshBottomInfoPanel()
  Controller:RefreshPrisonerListBottomPanel()
end

function Controller:SelectPrisoner(elementIdx)
  local row = DataModel.SortFilterPrisoner[elementIdx]
  if row then
    local pid = row.u_pid
    local room, pos = DataModel.GetPrisonerWorkingRoomAndPos(pid)
    local hasPlant = DataModel.IsWorkPlaceHasPlant(room, pos)
    local prisonerState = DataModel.GetPrisonerState(pid)
    if hasPlant or prisonerState ~= DataModel.PrisonerState.Free and prisonerState ~= DataModel.PrisonerState.InPrepare then
      return
    end
    local index = DataModel.SelectPrisonerPid2Index[pid]
    if DataModel.IsQuickSquad then
      if index and DataModel.SelectPrisonerIndex2Pid[index] ~= nil then
        if pid == DataModel.SelectPrisonerIndex2Pid[index] then
          DataModel.SelectPrisonerPid2Index[pid] = nil
          DataModel.SelectPrisonerIndex2Pid[index] = nil
        else
          local has, emptyIndex = GetQuickSquadNextEmptyPos()
          if not has then
            return
          end
          DataModel.SelectPrisonerIndex2Pid[emptyIndex] = pid
          DataModel.SelectPrisonerPid2Index[pid] = emptyIndex
        end
      else
        local has, emptyIndex = GetQuickSquadNextEmptyPos()
        if not has then
          return
        end
        DataModel.SelectPrisonerIndex2Pid[emptyIndex] = pid
        DataModel.SelectPrisonerPid2Index[pid] = emptyIndex
      end
    else
      index = DataModel.CurSelectWorkerIndex
      local lastPid = DataModel.SelectPrisonerIndex2Pid[index]
      if lastPid and DataModel.SelectPrisonerPid2Index[lastPid] ~= nil then
        if pid == DataModel.SelectPrisonerIndex2Pid[index] then
          DataModel.SelectPrisonerPid2Index[pid] = nil
          DataModel.SelectPrisonerIndex2Pid[index] = nil
        else
          DataModel.SelectPrisonerPid2Index[lastPid] = nil
          DataModel.SelectPrisonerPid2Index[pid] = index
          DataModel.SelectPrisonerIndex2Pid[index] = pid
        end
      else
        DataModel.SelectPrisonerPid2Index[pid] = index
        DataModel.SelectPrisonerIndex2Pid[index] = pid
      end
    end
  end
  Controller:RefreshPrisonerAllElement()
  Controller:RefreshPrisonerListBottomPanel()
end

function Controller:BeginDrag(idx)
  if DataModel.PosIsWorking(DataModel.CurRoomIndex, idx) then
    CommonTips.OpenTips(GetText(80607144))
    return
  end
  if DataModel.curFrameMouseUp then
    return
  end
  local id
  id = DataModel.GetWorkPrisonerInfo(DataModel.CurRoomIndex, idx).id
  if not id then
    return
  end
  DataModel.isDrag = true
  DataModel.dragIdx = idx
  DataModel.dragShowMode = 0
  local pos = Input.mousePosition
  View.Group_Temp.self:SetAnchoredPosition(Vector2(pos.x, pos.y))
  local dragInfo = {}
  dragInfo.pInfo = DataModel.AddDragInfo(id, false)
  View.Group_Temp.Img_TrainM:SetActive(false)
  View.Group_Temp.Img_TrainP:SetActive(dragInfo.pInfo ~= nil)
  View.Group_Temp.Img_TrainP:SetSprite(dragInfo.pInfo ~= nil and dragInfo.pInfo.thumbnail or nil)
  View.Group_Temp.self:SetActive(true)
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
    Controller:SwapPrison(DataModel.dragIdx, toIdx)
    Controller:RefreshAllWorkerListElement()
    Controller:RefreshBottomInfoPanel()
  end
  DataModel.dragIdx = 0
  View.Group_Temp.self:SetActive(false)
end

function Controller:CalcDraggingPos()
  local pos = View.Group_Edit.transform:InverseTransformPoint(View.Group_Temp.self.transform.position)
  local rect = View.Group_Edit.Img_Bg.Rect.rect
  local viewPos = View.Group_Edit.transform:InverseTransformPoint(View.Group_Edit.Img_Bg.transform.position)
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

function Controller:Click(btn)
  if DataModel.SortState.currentBtn == btn then
    Controller:Revert(btn)
    Controller:RefreshPrisonerList()
    return
  end
  Controller:Deactivate(DataModel.SortState.currentBtn)
  DataModel.SortState.currentBtn = btn
  Controller:Active(DataModel.SortState.currentBtn)
  Controller:RefreshPrisonerList()
end

function Controller:ScreenBtn(Type, btn, enumIndex)
  local name = Type.Btn_All.name
  if btn == nil then
    btn = Type.Btn_All
  end
  local data = filterData[Type.name] or {}
  local length = data.length
  if DataModel.PrisonerFilter == nil then
    DataModel.PrisonerFilter = {}
  end
  if DataModel.PrisonerFilter[Type.name] == nil then
    DataModel.PrisonerFilter[Type.name] = {}
    DataModel.PrisonerFilter[Type.name].index = {}
  end
  DataModel.PrisonerFilter[Type.name].btn = btn
  DataModel.PrisonerFilter[Type.name].type = Type
  if next(data) == nil or name == btn.name then
    DataModel.PrisonerFilter[Type.name].index = {}
    InitFilterRolesData(Type)
    return
  else
    if data[name] then
      data[name] = nil
    end
    if data[btn.name] == nil then
      data[btn.name] = enumIndex
      DataModel.PrisonerFilter[Type.name].index[btn.name] = enumIndex
      data.count = data.count + 1
      if data.count == length then
        InitFilterRolesData(Type)
        return
      end
    else
      data[btn.name] = nil
      DataModel.PrisonerFilter[Type.name].index[btn.name] = nil
      data.count = data.count - 1
      if data.count == 0 then
        InitFilterRolesData(Type)
        return
      end
    end
  end
  filterData[Type.name] = data
  SetFilterView(Type)
  ControllerFilterBtn()
end

function Controller:ResetActive(btn)
  for key, value in pairs(btn) do
    if key == "self" then
    elseif key == "Img_DeN" then
      btn[key]:SetActive(true)
    elseif key == "Img_DeP" then
      btn[key]:SetActive(true)
    else
      btn[key]:SetActive(false)
    end
  end
end

function Controller:Deactivate(btn)
  if btn.Img_DeP.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(false)
    btn.Img_DeN:SetActive(true)
  elseif btn.Img_AP.gameObject.activeInHierarchy then
    btn.Img_AP:SetActive(false)
    btn.Img_AN:SetActive(true)
  end
end

function Controller:Active(btn)
  if btn.Img_AN.gameObject.activeInHierarchy then
    btn.Img_AP:SetActive(true)
    btn.Img_AN:SetActive(false)
    DataModel.SortState.currentDown = false
  elseif btn.Img_DeN.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(true)
    btn.Img_DeN:SetActive(false)
    DataModel.SortState.currentDown = true
  end
end

function Controller:Revert(btn)
  if btn.Img_DeP.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(false)
    btn.Img_DeN:SetActive(false)
    btn.Img_AP:SetActive(true)
    btn.Img_AN:SetActive(false)
    DataModel.SortState.currentDown = false
  elseif btn.Img_AP.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(true)
    btn.Img_DeN:SetActive(false)
    btn.Img_AP:SetActive(false)
    btn.Img_AN:SetActive(false)
    DataModel.SortState.currentDown = true
  end
end

function Controller:Reset(btn)
  for key, value in pairs(View.PrisonerListManage.Group_TopRightPrison) do
    if key ~= "self" and key ~= "Btn_Screen" then
      Controller:ResetActive(value)
      Controller:Deactivate(value)
    end
  end
  DataModel.SortState.currentBtn = btn
  Controller:Active(DataModel.SortState.currentBtn)
end

function Controller:SortDown(List)
  table.sort(List, function(a, b)
    if a.workingIdx == 3 or b.workingIdx == 3 then
      if a.workingIdx == b.workingIdx then
        return a.extraOutputProbability > b.extraOutputProbability
      else
        return a.workingIdx < b.workingIdx
      end
    end
    return a.extraOutputProbability > b.extraOutputProbability
  end)
end

function Controller:SortUp(List)
  table.sort(List, function(a, b)
    if a.workingIdx == 3 or b.workingIdx == 3 then
      if a.workingIdx == b.workingIdx then
        return a.extraOutputProbability < b.extraOutputProbability
      else
        return a.workingIdx < b.workingIdx
      end
    end
    return a.extraOutputProbability < b.extraOutputProbability
  end)
end

function Controller:TimeSortDown(List)
  table.sort(List, function(a, b)
    if a.workingIdx == 3 or b.workingIdx == 3 then
      if a.workingIdx == b.workingIdx then
        return a.remainTime > b.remainTime
      else
        return a.workingIdx < b.workingIdx
      end
    end
    return a.remainTime > b.remainTime
  end)
end

function Controller:TimeSortUp(List)
  table.sort(List, function(a, b)
    if a.workingIdx == 3 or b.workingIdx == 3 then
      if a.workingIdx == b.workingIdx then
        return a.remainTime < b.remainTime
      else
        return a.workingIdx < b.workingIdx
      end
    end
    return a.remainTime < b.remainTime
  end)
end

function Controller:InitFilter()
  filterData = {}
  InitFilterRolesData(View.PrisonerListManage.Group_Screen.Group_Career, "careerInt")
  InitFilterRolesData(View.PrisonerListManage.Group_Screen.Group_Group, "specialInt")
  InitFilterRolesData(View.PrisonerListManage.Group_Screen.Group_Rarity, "qualityInt")
end

function Controller:SetRoomMonitor(isOn, u_pid)
  if isOn then
    DataModel.monitorData[DataModel.CurRoomIndex] = u_pid
  else
    DataModel.monitorData[DataModel.CurRoomIndex] = ""
  end
  DataModel.SetDirty()
  View.PrisonerListManage:SetActive(false)
  Controller:RefreshTopInfo()
  Controller:RefreshAllWorkerListElement()
  Controller:RefreshBottomInfoPanel()
  if isOn then
    View.Group_Edit.Group_Detail.Group_PrisonerInfo.Group_PrisonerInfo.Group_PrisonDetail:SetActive(false)
    View.Group_Edit.Group_Detail.Group_PrisonerInfo.Group_PrisonerInfo.Group_PrisonDetail:SetActive(true)
    View.Group_Edit.Group_Detail.Group_PrisonerInfo.Group_PrisonerInfo.Group_PrisonDetail.UI_WorkerLeads_02.self:SetActive(true)
    local animatorCtr = View.Group_Edit.Group_Detail.Group_PrisonerInfo.Group_PrisonerInfo.Group_PrisonDetail.self
    View.self:SelectPlayAnim(animatorCtr, "WorkerLeads2", function()
      View.Group_Edit.Group_Detail.Group_PrisonerInfo.Group_PrisonerInfo.Group_PrisonDetail.UI_WorkerLeads_02.self:SetActive(false)
    end)
    local grid = View.Group_WorkerList.StaticGrid_Unit.grid[DataModel.CurSelectWorkerIndex]
    if grid then
      grid.UI_WorkerLeads_01.self:SetActive(false)
      grid.UI_WorkerLeads_01.self:SetActive(true)
    end
  end
end

function Controller:TryUnlockNextArea()
  local canUnlock, targetUnlockArea = DataModel.CheckNextAreaCanUnlock()
  if not canUnlock then
    return
  end
  local prisonCfg = PrisonData.GetPrisonCA()
  local price = prisonCfg.buySpacePrice[1].num
  local t = {}
  t.itemId = 11400001
  t.useNum = price
  t.addUnit = true
  local roomIndex = DataModel.CurRoomIndex
  
  local function confirmCb()
    Net:SendProto("prison.unlock_front", function(json)
      if json.furniture then
        PlayerData.ServerData.user_prison_info.furniture = json.furniture
      end
      if json.workshops_front then
        PlayerData.ServerData.user_prison_info.workshops_front = json.workshops_front
      end
      if json.workshops_furniture then
        PlayerData.ServerData.user_prison_info.workshops_furniture = json.workshops_furniture
      end
      DataModel.InitRoomUnlockCount()
      DataModel.InitMachineData()
      for i = 1, 3 do
        DataModel.SetWorkPrisonerInfo(roomIndex, (targetUnlockArea - 1) * 3 + i, "")
      end
      View.Group_Edit.Btn_QuickEdit.Img_RedPoint:SetActive(PrisonData.CheckProductRoomRedPoint(DataModel.CurRoomIndex))
      if json.reward then
        CommonTips.OpenShowItem(json.reward, function()
          UIManager:Open("UI/Prison/Manage/OpenWorkshopSuccess", Json.encode({roomIndex = roomIndex, unlockIndex = targetUnlockArea}))
        end)
      end
      Controller:RefreshTopInfo()
    end, tostring(roomIndex))
  end
  
  if PlayerData:GetGoodsById(t.itemId).num < t.useNum then
    CommonTips.OpenTips(80600062)
    return
  end
  UIManager:Open("UI/Prison/Manage/PrisonSpaceUnlockPrompt", Json.encode({roomIndex = roomIndex}), confirmCb)
end

function Controller:AreaUnlockCallBack(roomIndex, targetUnlockArea)
  if roomIndex < 0 or targetUnlockArea < 0 then
    return
  end
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.3))
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
        local element = View.Group_WorkerList.StaticGrid_Unit.grid[targetIndex]
        Controller:SetWorkerListElement(element, targetIndex)
      end
    end
    Controller:RefreshLockGrid()
    if PrisonData.roomIndex == DataModel.CurRoomIndex then
      PrisonController.InitRoom(DataModel.CurRoomIndex, View.self)
    end
  end))
end

function Controller:SaveChanges(isGoBack, isGoHome, isChangeRoom)
  if table.count(DataModel.roomEditDirty) == 0 then
    return
  end
  local changeRoomData = {}
  local changeRoomMonitorData = {}
  local changeRoomProgrammeData = {}
  for index, value in pairs(DataModel.roomEditDirty) do
    local unlockGridCount = DataModel.GetUnlockGridCount(index)
    local row = {}
    for i = 1, unlockGridCount do
      local u_pid = DataModel.GetWorkPrisonerUid(index, i) or ""
      if u_pid ~= "" and (not DataModel.CheckPrisonerIsInTime(u_pid) or not u_pid) then
        u_pid = ""
      end
      row[tostring(i)] = u_pid
    end
    changeRoomData[tostring(index)] = row
    for roomIndex, pid in pairs(DataModel.monitorData) do
      DataModel.monitorData[tonumber(roomIndex)] = DataModel.CheckPrisonerIsInTime(pid) and DataModel.monitorData[tonumber(roomIndex)] or ""
    end
    changeRoomMonitorData[tostring(index)] = DataModel.monitorData[tonumber(index)]
    for roomIndex, pid in pairs(DataModel.roomProgrammeDirty) do
      changeRoomProgrammeData[tostring(roomIndex)] = DataModel.roomProgrammeDirty[tonumber(roomIndex)]
    end
  end
  local masterInfo = Json.encode(changeRoomMonitorData)
  local frontInfo = Json.encode(changeRoomData)
  local programmeInfo = table.count(changeRoomProgrammeData) ~= 0 and Json.encode(changeRoomProgrammeData) or "{}"
  DataModel.roomEditDirty = {}
  DataModel.roomProgrammeDirty = {}
  Net:SendProto("prison.modify_front", function(json)
    if json.workshops_front then
      PlayerData.ServerData.user_prison_info.workshops_front = json.workshops_front
    end
    if json.workshops_master then
      PlayerData.ServerData.user_prison_info.workshops_master = json.workshops_master
    end
    if json.workshops_programme then
      PlayerData.ServerData.user_prison_info.workshops_programme = json.workshops_programme
    end
    if json.workshops_product_plant then
      PlayerData.ServerData.user_prison_info.workshops_product_plant = json.workshops_product_plant
    end
    if json.raw_material_workshops then
      PlayerData.ServerData.user_prison_info.raw_material_workshops = json.raw_material_workshops
    end
    DataModel.InitPrisonerData()
    Controller:RefreshTopInfo()
    Controller:RefreshAllWorkerListElement()
    View.Group_Edit.Btn_QuickEdit.Img_RedPoint:SetActive(PrisonData.CheckProductRoomRedPoint(DataModel.CurRoomIndex))
    if isChangeRoom then
      return
    end
    if not isGoHome then
      if isGoBack then
        if PrisonData.roomIndex == DataModel.CurRoomIndex then
          PrisonController.InitRoom(PrisonData.roomIndex, View.self)
        else
          PrisonController.ChangeRoom(DataModel.CurRoomIndex, View.self)
        end
        if UIManager:IsPanelOpened("UI/Prison/Main/PrisonMain") then
          local PrisonMainData = require("UIPrisonMain/UIPrisonMainDataModel")
          PrisonMainData.ModifyRefresh()
        end
      elseif PrisonData.roomIndex == DataModel.CurRoomIndex then
        PrisonController.InitRoom(PrisonData.roomIndex, View.self)
      elseif changeRoomData[tostring(PrisonData.roomIndex)] ~= nil then
        PrisonController.InitRoom(PrisonData.roomIndex, View.self)
      end
    end
    CommonTips.OpenTips(80600209)
  end, masterInfo, frontInfo, programmeInfo)
end

function Controller:CanUpgradeMachine(index)
  index = index or DataModel.CurSelectWorkerIndex
  local u_fid = DataModel.GetWorkMachineUid(DataModel.CurRoomIndex, index)
  if u_fid == "" then
    return false
  end
  local id = DataModel.allMachine[u_fid].id
  local cfg = PlayerData:GetFactoryData(id)
  if cfg == nil then
    return false
  end
  if cfg.upgrade == -1 then
    return false
  end
  local devLevel = PlayerData.ServerData.user_prison_info.rooms[tostring(87500010)].lv
  local levelCfg = PlayerData:GetFactoryData(PlayerData:GetFactoryData(87500010).roomList[devLevel].config)
  local unlockMachineLevel = PlayerData:GetFactoryData(levelCfg.unlockMachineList[1].id).Level
  local nextLevelCfg = PlayerData:GetFactoryData(cfg.upgrade)
  local isOverLevel = unlockMachineLevel < nextLevelCfg.Level
  if isOverLevel then
    return false
  end
  local items = {}
  for k, v in pairs(cfg.upgradeCostList) do
    if v.num > PlayerData:GetGoodsById(v.id).num then
      return false
    end
    items[v.id] = v.num
  end
  if DataModel.PosIsWorking(DataModel.CurRoomIndex, index) then
    return false
  end
  return true
end

function Controller:NeedJumpToNextMachineAfterUpgrade()
  local unlockGrid = DataModel.GetUnlockGridCount(DataModel.CurRoomIndex)
  local i = DataModel.CurSelectWorkerIndex
  while unlockGrid >= i do
    if Controller:CanUpgradeMachine(i) then
      if i ~= DataModel.CurSelectWorkerIndex then
        Controller:SelectWorkerElement(i)
      end
      return
    end
    i = i + 1
  end
  i = 1
  while i <= DataModel.CurSelectWorkerIndex do
    if Controller:CanUpgradeMachine(i) then
      if i ~= DataModel.CurSelectWorkerIndex then
        Controller:SelectWorkerElement(i)
      end
      return
    end
    i = i + 1
  end
end

function Controller:TryUpgradeMachine()
  if not Controller:CanUpgradeMachine() then
    return
  end
  local u_fid = DataModel.GetWorkMachineUid(DataModel.CurRoomIndex, DataModel.CurSelectWorkerIndex)
  local id = DataModel.allMachine[u_fid].id
  local cfg = PlayerData:GetFactoryData(id)
  local items = {}
  for k, v in pairs(cfg.upgradeCostList) do
    if v.num > PlayerData:GetGoodsById(v.id).num then
      CommonTips.OpenTips(80600696)
      return false
    end
    items[v.id] = v.num
  end
  
  local function succCb()
    DataModel.UpdateMachineData(u_fid)
    Controller:RefreshAllWorkerListElement()
    Controller:RefreshBottomInfoPanel()
    Controller:NeedJumpToNextMachineAfterUpgrade()
    local obj = View.self:GetRes("UI/UIEffect/particle/UI_prison/PrisonEdit/UI_PrisonEdit_LevelUp", View.Group_Edit.Group_Detail.Group_MachineInfo.Group_Machine.Group_EffNode.transform)
    obj:SetActive(true)
    table.insert(DataModel.UpgradeEffList, obj)
  end
  
  Net:SendProto("furniture.upgrade", function(json)
    PlayerData:RefreshUseItems(items)
    local serverData = PlayerData.ServerData.user_prison_info.furniture[tostring(u_fid)]
    serverData.id = tostring(cfg.upgrade)
    if succCb then
      succCb()
    end
  end, u_fid)
end

function Controller:SwapPrison(dragIdx, toIdx)
  if dragIdx == toIdx then
    return
  end
  if DataModel.PosIsWorking(DataModel.CurRoomIndex, dragIdx) or DataModel.PosIsWorking(DataModel.CurRoomIndex, toIdx) then
    CommonTips.OpenTips(GetText(80607144))
    return
  end
  DataModel.SwapPrison(dragIdx, toIdx)
end

function Controller:OneBtnSelect()
  local canChoosePrisoner = GetAllCanChoosePrisoner()
  local count = table.count(canChoosePrisoner)
  if count == 0 then
    return
  end
  for i = 1, count do
    if table.count(canChoosePrisoner) == 0 then
      break
    end
    local hasPos, pos = GetQuickSquadNextEmptyPos()
    if hasPos then
      DataModel.SelectPrisonerPid2Index[canChoosePrisoner[1].u_pid] = pos
      DataModel.SelectPrisonerIndex2Pid[pos] = canChoosePrisoner[1].u_pid
      table.remove(canChoosePrisoner, 1)
    else
      break
    end
  end
  Controller:RefreshPrisonerAllElement()
  Controller:RefreshPrisonerListBottomPanel()
end

function Controller:OneBtnCancelAll()
  local t = Clone(DataModel.SelectPrisonerIndex2Pid)
  for posIndex, pid in pairs(t) do
    local hasPlant = DataModel.IsWorkPlaceHasPlant(DataModel.CurRoomIndex, posIndex)
    if not hasPlant then
      DataModel.SelectPrisonerPid2Index[pid] = nil
      DataModel.SelectPrisonerIndex2Pid[posIndex] = nil
    end
  end
  Controller:RefreshPrisonerAllElement()
  Controller:RefreshPrisonerListBottomPanel()
end

function Controller:GoLeftRoom()
  if DataModel.isDrag then
    return
  end
  local targetRoomIndex = DataModel.CurRoomIndex - 1
  if targetRoomIndex < 1 then
    targetRoomIndex = DataModel.TotalRoomCount
  end
  local canEnter, posIndex = DataModel.CheckRoomCanEnter(targetRoomIndex)
  if not canEnter then
    CommonTips.OpenTips(80608257)
    return
  end
  DataModel.CurSelectWorkerIndex = posIndex
  DataModel.CurRoomIndex = targetRoomIndex
  Controller:ChangeRoom()
end

function Controller:GoRightRoom()
  if DataModel.isDrag then
    return
  end
  local targetRoomIndex = DataModel.CurRoomIndex + 1
  if targetRoomIndex > DataModel.TotalRoomCount then
    targetRoomIndex = 1
  end
  local canEnter, posIndex = DataModel.CheckRoomCanEnter(targetRoomIndex)
  if not canEnter then
    CommonTips.OpenTips(80608257)
    return
  end
  DataModel.CurSelectWorkerIndex = posIndex
  DataModel.CurRoomIndex = targetRoomIndex
  Controller:ChangeRoom()
end

function Controller:NaviChangeRoom(roomIndex)
  if roomIndex > DataModel.TotalRoomCount then
    CommonTips.OpenTips(80607054)
    return
  end
  Controller:ChangeRoom(roomIndex)
  Controller:OpenNavigation()
end

function Controller:ChangeRoom(roomIndex)
  DataModel.CurRoomIndex = roomIndex == nil and DataModel.CurRoomIndex or roomIndex
  Controller:RefreshTopInfo()
  Controller:RefreshLockGrid()
  Controller:RefreshAllWorkerListElement()
  Controller:RefreshBottomInfoPanel()
end

return Controller
