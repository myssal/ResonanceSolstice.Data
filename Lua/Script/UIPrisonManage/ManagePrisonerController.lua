local DataModel = require("UIPrisonManage/UIPrisonManageDataModel")
local View = require("UIPrisonManage/UIPrisonManageView")
local PrisonerController = {}
local filterData = {}

local function ControllerFilterBtn()
  local jobData = filterData[View.PrisonerListManage.Group_Screen.Group_Career.name]
  local campData = filterData[View.PrisonerListManage.Group_Screen.Group_Group.name]
  local qualityData = filterData[View.PrisonerListManage.Group_Screen.Group_Rarity.name]
  View.PrisonerListManage.Group_TopRightPrison.Btn_Screen.Img_P:SetActive(jobData ~= nil and jobData.count ~= 0 or campData ~= nil and campData.count ~= 0 or qualityData ~= nil and qualityData.count ~= 0)
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
    local config = {}
    if name == "Group_Working" then
      length = 0
      for i = 1, 4 do
        local btn = "Btn_C0" .. i
        if Type[btn] then
          Type[btn].self:SetActive(true)
          length = length + 1
        end
      end
    end
    if name == "Group_Career" then
      length = 0
      config = PlayerData:GetFactoryData(99900017).prisonPersonalityNameList
      for k, v in pairs(config) do
        local btn = "Btn_C0" .. k
        local row = PlayerData:GetFactoryData(v.id)
        if Type[btn] then
          Type[btn].self:SetActive(true)
          Type[btn].Txt_:SetText(row.prisonerPersonalityName)
          length = length + 1
        end
      end
    end
    if name == "Group_Group" then
      length = 0
      config = PlayerData:GetFactoryData(99900017).prisonSpecialityList
      for k, v in pairs(config) do
        local btn = "Btn_G0" .. k
        local row = PlayerData:GetFactoryData(v.id)
        if Type[btn] then
          Type[btn].self:SetActive(true)
          Type[btn].Txt_:SetText(row.prisonerSpeciality)
          length = length + 1
        end
      end
    end
    if name == "Group_Rarity" then
      length = 0
      config = {
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

PrisonerController.SortPrisoner = {
  [EnumDefine.StateSort.State] = function(a, b)
    local aRoomIndex = DataModel.prisonerData[a.u_pid].roomIndex
    local bRoomIndex = DataModel.prisonerData[b.u_pid].roomIndex
    if aRoomIndex == bRoomIndex then
      if a.efficiency == b.efficiency then
        return a.id < b.id
      end
      return a.efficiency < b.efficiency
    end
    return aRoomIndex < bRoomIndex
  end,
  [EnumDefine.EfficiencySort.EfficiencyDesc] = function(a, b)
    if a.efficiency ~= b.efficiency then
      return a.efficiency > b.efficiency
    end
    return a.id < b.id
  end,
  [EnumDefine.EfficiencySort.EfficiencyAsc] = function(a, b)
    if a.efficiency ~= b.efficiency then
      return a.efficiency < b.efficiency
    end
    return a.id < b.id
  end,
  [EnumDefine.EnergySort.EnergyDesc] = function(a, b)
    if tonumber(a.energy) ~= tonumber(b.energy) then
      return tonumber(a.energy) > tonumber(b.energy)
    end
    return a.id < b.id
  end,
  [EnumDefine.EnergySort.EnergyAsc] = function(a, b)
    if tonumber(a.energy) ~= tonumber(b.energy) then
      return tonumber(a.energy) < tonumber(b.energy)
    end
    return a.id < b.id
  end,
  [EnumDefine.DayCountSort.DayCountDesc] = function(a, b)
    if tonumber(a.days) ~= tonumber(b.days) then
      return tonumber(a.days) > tonumber(b.days)
    end
    return a.id < b.id
  end,
  [EnumDefine.DayCountSort.DayCountAsc] = function(a, b)
    if tonumber(a.days) ~= tonumber(b.days) then
      return tonumber(a.days) < tonumber(b.days)
    end
    return a.id < b.id
  end
}

function PrisonerController:ResetFilter()
  DataModel.Sort = EnumDefine.EPrisonerSortType.State
  DataModel.StateSort = EnumDefine.StateSort.State
  DataModel.EfficiencySort = EnumDefine.EfficiencySort.EfficiencyDesc
  DataModel.EnergySort = EnumDefine.EnergySort.EnergyDesc
  DataModel.DayCountSort = EnumDefine.DayCountSort.DayCountDesc
  for key, value in pairs(View.PrisonerListManage.Group_TopRightPrison) do
    if key ~= "self" and key ~= "Btn_Screen" then
      value.Img_DeP:SetActive(false)
      value.Img_DeN:SetActive(true)
      value.Img_AP:SetActive(false)
      value.Img_AN:SetActive(false)
    end
  end
end

function PrisonerController:FilterRefresh(currSort)
  local Group_TopRight = View.PrisonerListManage.Group_TopRightPrison
  if DataModel.Sort ~= currSort then
    local opCtr
    local type = 1
    if DataModel.Sort ~= 0 then
      if DataModel.Sort == EnumDefine.EPrisonerSortType.Efficiency then
        opCtr = Group_TopRight.Btn_Level
        type = DataModel.EfficiencySort == EnumDefine.EfficiencySort.EfficiencyDesc and 1 or 2
      elseif DataModel.Sort == EnumDefine.EPrisonerSortType.Energy then
        opCtr = Group_TopRight.Btn_Rarity
        type = DataModel.EnergySort == EnumDefine.EnergySort.EnergyDesc and 1 or 2
      elseif DataModel.Sort == EnumDefine.EPrisonerSortType.DayCount then
        opCtr = Group_TopRight.Btn_Time
        type = DataModel.DayCountSort == EnumDefine.DayCountSort.DayCountDesc and 1 or 2
      end
      opCtr.Img_DeP:SetActive(false)
      opCtr.Img_DeN:SetActive(true)
      opCtr.Img_AP:SetActive(false)
      opCtr.Img_AN:SetActive(false)
    end
    if currSort == EnumDefine.EPrisonerSortType.Efficiency then
      opCtr = Group_TopRight.Btn_Level
      type = DataModel.EfficiencySort == EnumDefine.EfficiencySort.EfficiencyDesc and 1 or 2
    elseif currSort == EnumDefine.EPrisonerSortType.Energy then
      opCtr = Group_TopRight.Btn_Rarity
      type = DataModel.EnergySort == EnumDefine.EnergySort.EnergyDesc and 1 or 2
    elseif currSort == EnumDefine.EPrisonerSortType.DayCount then
      opCtr = Group_TopRight.Btn_Time
      type = DataModel.DayCountSort == EnumDefine.DayCountSort.DayCountDesc and 1 or 2
    end
    opCtr.Img_DeP:SetActive(type == 1)
    opCtr.Img_DeN:SetActive(false)
    opCtr.Img_AP:SetActive(type == 2)
    opCtr.Img_AN:SetActive(false)
  else
    local opCtr
    local type = 1
    if currSort == EnumDefine.EPrisonerSortType.Efficiency then
      if DataModel.EfficiencySort == EnumDefine.EfficiencySort.EfficiencyDesc then
        DataModel.EfficiencySort = EnumDefine.EfficiencySort.EfficiencyAsc
      elseif DataModel.EfficiencySort == EnumDefine.EfficiencySort.EfficiencyAsc then
        DataModel.EfficiencySort = EnumDefine.EfficiencySort.EfficiencyDesc
      end
      opCtr = Group_TopRight.Btn_Level
      type = DataModel.EfficiencySort == EnumDefine.EfficiencySort.EfficiencyDesc and 1 or 2
    elseif currSort == EnumDefine.EPrisonerSortType.Energy then
      if DataModel.EnergySort == EnumDefine.EnergySort.EnergyDesc then
        DataModel.EnergySort = EnumDefine.EnergySort.EnergyAsc
      elseif DataModel.EnergySort == EnumDefine.EnergySort.EnergyAsc then
        DataModel.EnergySort = EnumDefine.EnergySort.EnergyDesc
      end
      opCtr = Group_TopRight.Btn_Rarity
      type = DataModel.EnergySort == EnumDefine.EnergySort.EnergyDesc and 1 or 2
    elseif currSort == EnumDefine.EPrisonerSortType.DayCount then
      if DataModel.DayCountSort == EnumDefine.DayCountSort.DayCountDesc then
        DataModel.DayCountSort = EnumDefine.DayCountSort.DayCountAsc
      elseif DataModel.DayCountSort == EnumDefine.DayCountSort.DayCountAsc then
        DataModel.DayCountSort = EnumDefine.DayCountSort.DayCountDesc
      end
      opCtr = Group_TopRight.Btn_Time
      type = DataModel.DayCountSort == EnumDefine.DayCountSort.DayCountDesc and 1 or 2
    end
    if opCtr then
      opCtr.Img_DeP:SetActive(type == 1)
      opCtr.Img_DeN:SetActive(false)
      opCtr.Img_AP:SetActive(type == 2)
      opCtr.Img_AN:SetActive(false)
    end
  end
  DataModel.Sort = currSort
  PrisonerController:Filter()
end

function PrisonerController:Filter()
  DataModel.filterPrisoner = {}
  local pData = {}
  if DataModel.PrisonerFilterTarget == 1 then
    pData = DataModel.GetWorkPrisonerInfo(DataModel.curRoomIndex, DataModel.curChoosePosIndex)
  elseif DataModel.PrisonerFilterTarget == 2 then
    local pId = DataModel.monitorData[DataModel.curRoomIndex]
    if pId ~= "" then
      pData = DataModel.prisonerData[pId].server
    end
  end
  local firstPid = -1
  local firstPData
  if pData and next(pData) then
    firstPid = pData.u_pid
    firstPData = Clone(pData)
  end
  if DataModel.PrisonerFilterTarget == 1 then
    PrisonerController:FilterPrisonerToWork(firstPid)
  else
    PrisonerController:FilterPrisonerToMonitor(firstPid)
  end
  local sort = DataModel.Sort or EnumDefine.EPrisonerSortType.State
  if sort == EnumDefine.EPrisonerSortType.State then
    table.sort(DataModel.filterPrisoner, PrisonerController.SortPrisoner[DataModel.StateSort])
  elseif sort == EnumDefine.EPrisonerSortType.Efficiency then
    table.sort(DataModel.filterPrisoner, PrisonerController.SortPrisoner[DataModel.EfficiencySort])
  elseif sort == EnumDefine.EPrisonerSortType.Energy then
    table.sort(DataModel.filterPrisoner, PrisonerController.SortPrisoner[DataModel.EnergySort])
  elseif sort == EnumDefine.EPrisonerSortType.DayCount then
    table.sort(DataModel.filterPrisoner, PrisonerController.SortPrisoner[DataModel.DayCountSort])
  end
  if firstPData then
    firstPData.isCurChoose = true
    table.insert(DataModel.filterPrisoner, 1, firstPData)
  end
end

function PrisonerController:FilterPrisonerToWork(firstPid)
  local workingData = filterData[View.PrisonerListManage.Group_Screen.Group_Working.name]
  local career = filterData[View.PrisonerListManage.Group_Screen.Group_Career.name]
  local campData = filterData[View.PrisonerListManage.Group_Screen.Group_Group.name]
  local qualityData = filterData[View.PrisonerListManage.Group_Screen.Group_Rarity.name]
  for k, v in pairs(DataModel.prisonerData) do
    if DataModel.CheckPrisonerIsInTime(v.server.u_pid) and IsMeetFilter(workingData, DataModel.GetPrisonerWorkStateType(v.server.u_pid)) and IsMeetFilter(career, v.server.personalityIdx) and IsMeetFilter(campData, v.server.specialityIdx) and IsMeetFilter(qualityData, v.server.rarityIdx) and v.server.u_pid ~= firstPid and not DataModel.RoomIsWorking(tonumber(v.roomIndex)) then
      table.insert(DataModel.filterPrisoner, v.server)
    end
  end
end

function PrisonerController:FilterPrisonerToMonitor(firstPid)
  local workingData = filterData[View.PrisonerListManage.Group_Screen.Group_Working.name]
  local career = filterData[View.PrisonerListManage.Group_Screen.Group_Career.name]
  local campData = filterData[View.PrisonerListManage.Group_Screen.Group_Group.name]
  local qualityData = filterData[View.PrisonerListManage.Group_Screen.Group_Rarity.name]
  local unlockGridCount = DataModel.GetUnlockGridCount(DataModel.curRoomIndex)
  for i = 1, unlockGridCount do
    local pData = DataModel.GetWorkPrisonerInfo(DataModel.curRoomIndex, i)
    if next(pData) ~= nil and DataModel.CheckPrisonerIsInTime(pData.u_pid) and IsMeetFilter(workingData, DataModel.GetPrisonerWorkStateType(pData.u_pid)) and IsMeetFilter(career, pData.personalityIdx) and IsMeetFilter(campData, pData.specialityIdx) and IsMeetFilter(qualityData, pData.rarityIdx) and pData.u_pid ~= firstPid and not DataModel.RoomIsWorking(DataModel.curRoomIndex) then
      table.insert(DataModel.filterPrisoner, pData)
    end
  end
end

function PrisonerController.ScreenBtn(Type, btn, enumIndex)
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

function PrisonerController.InitFilter()
  filterData = {}
  InitFilterRolesData(View.PrisonerListManage.Group_Screen.Group_Working, "workingInt")
  InitFilterRolesData(View.PrisonerListManage.Group_Screen.Group_Career, "jobInt")
  InitFilterRolesData(View.PrisonerListManage.Group_Screen.Group_Group, "campInt")
  InitFilterRolesData(View.PrisonerListManage.Group_Screen.Group_Rarity, "qualityInt")
end

return PrisonerController
