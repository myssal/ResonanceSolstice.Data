local View = require("UIPrisonAccomodation/UIPrisonAccomodationView")
local DataModel = {}
DataModel.roomIndex = 1
DataModel.areaIndex = 1
DataModel.roomTypeId = 87500027
DataModel.unLockArea = {}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
end

function DataModel.InitData()
  local cellRoomIndex = PrisonData.cellRoomIndex
  DataModel.prisonCA = PrisonData.GetPrisonCA()
  for roomTypeId, roomIndex in pairs(PrisonData.CellRoomTypeIdToRoomIndexMap) do
    if roomIndex == tonumber(cellRoomIndex) then
      DataModel.roomTypeId = roomTypeId
      break
    end
  end
  DataModel.roomIndex = cellRoomIndex
  DataModel.areaIndex = PrisonData.cellRoomAreaIndex
end

function DataModel.RefreshOnShow()
  local cellRoomIndex = tostring(DataModel.roomIndex)
  local prisonCA = DataModel.prisonCA
  local roomTypeCA = PlayerData:GetFactoryData(DataModel.roomTypeId, "PrisonRoomTypeFactory")
  View.Group_Top.Group_AccomodationInfo.Txt_Title:SetText(roomTypeCA.roomName)
  local cellRoomList = PrisonData.GetCellRoomList() or {}
  local roomData = cellRoomList[cellRoomIndex] or {}
  local unLockNum = table.count(roomData) * prisonCA.roomPrisonerNum
  local maxNum = #prisonCA.prisonRoomPosition * prisonCA.roomPrisonerNum
  View.Group_Top.Group_AccomodationInfo.Group_BedNum.Txt_TotalNumCount:SetText(unLockNum .. "/" .. maxNum)
  DataModel.RefreshPrisonLV()
  local curLiveNum = table.count(PrisonData.GetPrisonerListInCell(cellRoomIndex))
  local totalNum = 0
  for i, v in pairs(cellRoomList) do
    totalNum = totalNum + table.count(v) * DataModel.prisonCA.roomPrisonerNum
  end
  View.Group_Top.Group_Prisoner.Group_Num.Txt_Own:SetText(curLiveNum)
  View.Group_Top.Group_Prisoner.Group_Num.Txt_Max:SetText(totalNum)
  DataModel.RefreshArea()
  local list = PrisonData.GetCellRoomList()
  local u_pidList = {}
  for index, data in pairs(list) do
    for k, v in pairs(PrisonData.GetIllPrisonerInCell(tostring(index))) do
      table.insert(u_pidList, v.u_pid)
    end
  end
  View.Group_Btn.Btn_MedicalAll:SetActive(0 < #u_pidList)
  DataModel.RefreshQuestRed()
  DataModel.QuestTraceRefresh()
  View.Group_Windows:SetActive(false)
  HomeManager.cam.ignoreUI = false
  TrainCameraManager:OpenCamera(3)
end

function DataModel.OpenArea(areaIndex)
  areaIndex = tonumber(areaIndex)
  
  local function callBack(json)
    local ctr = View.Group_Area["Group_" .. areaIndex]
    if ctr then
      ctr.Group_Locked:SetActive(false)
      ctr.Btn_:SetActive(true)
    end
    local prisonCA = DataModel.prisonCA
    local cellRoomList = PrisonData.GetCellRoomList()
    local unLockNum = table.count(cellRoomList[tostring(DataModel.roomIndex)]) * prisonCA.roomPrisonerNum
    local maxNum = #prisonCA.prisonRoomPosition * prisonCA.roomPrisonerNum
    View.Group_Top.Group_AccomodationInfo.Group_BedNum.Txt_TotalNumCount:SetText(unLockNum .. "/" .. maxNum)
    local totalNum = 0
    for i, v in pairs(cellRoomList) do
      totalNum = totalNum + table.count(v) * DataModel.prisonCA.roomPrisonerNum
    end
    View.Group_Top.Group_Prisoner.Group_Num.Txt_Max:SetText(totalNum)
    DataModel.RefreshArea()
  end
  
  UIManager:Open("UI/Prison/Main/PrisonAccomodation/PrisonRoomUnlockPrompt", Json.encode({
    roomIndex = DataModel.roomIndex,
    areaIndex = areaIndex
  }), callBack)
end

function DataModel.ChangeArea(areaIndex)
  local ctr = View.Group_Area["Group_" .. DataModel.areaIndex]
  if ctr then
    local areaId = PrisonData.CellRoomAreaIndexToAreaIdMap[DataModel.areaIndex]
    local oldAreaUnLock = DataModel.IsAreaUnLock(areaId)
    ctr.Group_Locked:SetActive(not oldAreaUnLock)
    ctr.Group_Selected:SetActive(false)
    ctr.Btn_:SetActive(oldAreaUnLock)
  end
  ctr = View.Group_Area["Group_" .. tonumber(areaIndex)]
  if ctr then
    ctr.Group_Locked:SetActive(false)
    ctr.Group_Selected:SetActive(true)
    ctr.Btn_:SetActive(false)
  end
  DataModel.areaIndex = tonumber(areaIndex)
  PrisonCellController.ChangeArea(areaIndex)
end

function DataModel.IsAreaUnLock(areaId)
  areaId = tostring(areaId)
  local cellRoomIndex = DataModel.roomIndex
  local cellRoomList = PrisonData.GetCellRoomList()
  for k, v in pairs(cellRoomList[tostring(cellRoomIndex)]) do
    if areaId == k then
      return true
    end
  end
  return false
end

function DataModel.RefreshArea()
  local prisonCA = DataModel.prisonCA
  local prisonLv = PrisonData.GetPrisonLv()
  local cellRoomList = PrisonData.GetCellRoomList()
  local totalAreaNum = 0
  for i, v in ipairs(prisonCA.lvList) do
    if v.level == prisonLv then
      totalAreaNum = v.roomNum
      break
    end
  end
  local curTotalAreaNum = 0
  for _, roomData in pairs(cellRoomList) do
    curTotalAreaNum = curTotalAreaNum + table.count(roomData)
  end
  local unLockArea = {}
  for areaId, v in pairs(cellRoomList[tostring(DataModel.roomIndex)]) do
    unLockArea[tonumber(areaId)] = 1
  end
  local curAreaNum = table.count(unLockArea)
  View.Group_Area.Group_Bottom.Group_UnlockRoom.Txt_Num:SetText(curAreaNum .. "/" .. #prisonCA.prisonRoomPosition)
  View.Group_Area.Group_Bottom.Group_Tip:SetActive(curAreaNum < #prisonCA.prisonRoomPosition)
  for i, v in ipairs(prisonCA.prisonRoomPosition) do
    local ctr = View.Group_Area["Group_" .. i]
    if ctr then
      local unLock = unLockArea[v.id]
      local select = DataModel.areaIndex == i
      ctr.Group_Selected:SetActive(select)
      ctr.Group_Locked:SetActive(not unLock and not select)
      ctr.Btn_:SetActive(unLock and not select)
      if not unLock then
        local canUnLock = totalAreaNum > curTotalAreaNum
        ctr.Group_Locked.Group_Available:SetActive(canUnLock)
        ctr.Group_Locked.Group_Unavailable:SetActive(not canUnLock)
      end
      ctr.Group_Locked.Group_Available.Btn_Pic:SetClickParam(i)
      ctr.Group_Locked.Group_Available.Btn_Lock:SetClickParam(i)
      ctr.Btn_:SetClickParam(i)
    end
  end
  local canUnLockLv
  for i, v in ipairs(prisonCA.lvList) do
    if curTotalAreaNum < v.roomNum then
      canUnLockLv = v.level
      break
    end
  end
  View.Group_Area.Group_Bottom.Group_Tip:SetActive(canUnLockLv)
  if canUnLockLv then
    View.Group_Area.Group_Bottom.Group_Tip.Txt_Num:SetText(string.format(GetText(80608521), canUnLockLv))
  end
end

function DataModel.RefreshPrisonLV()
  local prisonLv = PrisonData.GetPrisonLv()
  View.Group_Top.Group_PrisonIcon.Group_.Txt_Num:SetText(prisonLv)
  local LevelDataModel = require("UIPrisonLevel/UIPrisonLevelDataModel")
  View.Group_Top.Group_PrisonIcon.Group_.Img_RedDot:SetActive(LevelDataModel.CheckHasRedPoint())
  local prisonCA = DataModel.prisonCA
  local cellRoomList = PrisonData.GetCellRoomList()
  local curTotalAreaNum = 0
  for _, roomData in pairs(cellRoomList) do
    curTotalAreaNum = curTotalAreaNum + table.count(roomData)
  end
  local totalAreaNum = 0
  for i, v in ipairs(prisonCA.lvList) do
    if v.level == prisonLv then
      totalAreaNum = v.roomNum
      break
    end
  end
  for i, v in ipairs(prisonCA.prisonRoomPosition) do
    local ctr = View.Group_Area["Group_" .. i]
    if ctr then
      local canUnLock = curTotalAreaNum < totalAreaNum
      ctr.Group_Locked.Group_Available:SetActive(canUnLock)
      ctr.Group_Locked.Group_Unavailable:SetActive(not canUnLock)
    end
  end
end

function DataModel.RefreshQuestRed()
  View.Group_Navigation.Img_RedPoint:SetActive(PrisonData.IsHaveCanReceiveQuest())
end

function DataModel.QuestTraceRefresh()
  local questId = PlayerData:GetPlayerPrefs("int", "PrisonQuestTrace")
  View.Group_Navigation.Btn_Navigation.Txt_Target:SetActive(questId ~= 0)
  if questId ~= 0 then
    local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
    View.Group_Navigation.Btn_Navigation.Txt_Target:SetText(questCA.describe)
  end
end

function DataModel.ChangeRoomRefresh()
  local cellRoomIndex = PrisonData.cellRoomIndex
  for roomTypeId, roomIndex in pairs(PrisonData.CellRoomTypeIdToRoomIndexMap) do
    if roomIndex == tonumber(cellRoomIndex) then
      DataModel.roomTypeId = roomTypeId
      break
    end
  end
  DataModel.roomIndex = cellRoomIndex
  DataModel.areaIndex = PrisonData.cellRoomAreaIndex
  local roomTypeCA = PlayerData:GetFactoryData(DataModel.roomTypeId, "PrisonRoomTypeFactory")
  View.Group_Top.Group_AccomodationInfo.Txt_Title:SetText(roomTypeCA.roomName)
  local curLiveNum = table.count(PrisonData.GetPrisonerListInCell(cellRoomIndex))
  View.Group_Top.Group_Prisoner.Group_Num.Txt_Own:SetText(curLiveNum)
  DataModel.RefreshArea()
  local list = PrisonData.GetCellRoomList()
  local u_pidList = {}
  for index, data in pairs(list) do
    for k, v in pairs(PrisonData.GetIllPrisonerInCell(tostring(index))) do
      table.insert(u_pidList, v.u_pid)
    end
  end
  View.Group_Btn.Btn_MedicalAll:SetActive(0 < #u_pidList)
end

return DataModel
