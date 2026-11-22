local View = require("UIPrisonMain/UIPrisonMainView")
local DataModel = {}
DataModel.program = nil
DataModel.master = nil
DataModel.curRoomCount = 0
DataModel.safety = 0
DataModel.stability = 0
DataModel.obedience = 0
DataModel.hygiene = 0

function DataModel.SetJsonData(json)
end

function DataModel.InitData()
  local prisonData = PrisonData.GetSeverPrisonData()
  DataModel.curRoomCount = prisonData and table.count(prisonData.workshops_front) or 0
  local roomIndex = PrisonData.roomIndex
  if prisonData then
    DataModel.program = prisonData.workshops_programme[tostring(roomIndex)]
    DataModel.master = PrisonData.GetPrisonerMaster(roomIndex)
    DataModel.curRoomCount = table.count(prisonData.workshops_front)
    DataModel.safety = prisonData.safety
    DataModel.stability = prisonData.stability
    DataModel.obedience = prisonData.obedience
    DataModel.hygiene = prisonData.hygiene
  end
  DataModel.prisonCA = PrisonData.GetPrisonCA()
end

function DataModel.RefreshOnShow()
  local prisonData = PrisonData.GetSeverPrisonData()
  View.Btn_QuickJump:SetActive(prisonData)
  View.Btn_Warehouse:SetActive(prisonData)
  View.Btn_Order:SetActive(prisonData)
  View.Group_ProductionBtn:SetActive(prisonData)
  View.Group_Navigation:SetActive(prisonData)
  if prisonData then
    DataModel.RefreshFunList()
  end
  View.Group_Windows:SetActive(false)
  DataModel.RefreshTop()
  DataModel.RefreshQuestRed()
  DataModel.QuestTraceRefresh()
  DataModel.RefreshOneButton()
  HomeManager.cam.ignoreUI = false
  TrainCameraManager:OpenCamera(3)
end

function DataModel.RefreshFunList()
  View.Group_ProductionBtn.Btn_PrisonEdit:SetActive(true)
  View.Group_ProductionBtn.Btn_PrisonProduct:SetActive(true)
  local roomIndex = PrisonData.roomIndex
  local allProducts = PrisonData.GetRoomProducts(roomIndex)
  local haveProductWorking = false
  local haveProductCanReceive = false
  local havePrisonerFree = false
  local roomList = PrisonData.GetProductRoomList()
  local roomData = roomList[tostring(roomIndex)]
  if roomData then
    for cellIndex, data in pairs(roomData) do
      if data and data ~= "" then
        local state = PrisonController.GetBubbleState(cellIndex)
        if state == 1 then
          havePrisonerFree = true
        end
      end
    end
  end
  local havePrisonerCanPlace = PrisonData.CheckProductRoomRedPoint(PrisonData.roomIndex)
  if allProducts then
    for cellIndex, v in pairs(allProducts) do
      local remainTime = PrisonData.GetProductRemainTime(roomIndex, cellIndex)
      if 0 < remainTime then
        haveProductWorking = true
      end
      local canReceive = PrisonData.IsProductCanReceive(roomIndex, cellIndex)
      if canReceive then
        haveProductCanReceive = true
      end
      if haveProductWorking and haveProductCanReceive then
        break
      end
    end
  end
  View.Group_ProductionBtn.Btn_WorkshopFaster:SetActive(haveProductWorking)
  View.Group_ProductionBtn.Btn_BatchGet:SetActive(haveProductCanReceive)
  View.Group_ProductionBtn.Btn_PrisonProduct.Img_RedPoint:SetActive(havePrisonerFree)
  View.Group_ProductionBtn.Btn_PrisonEdit.Img_RedPoint:SetActive(havePrisonerCanPlace)
end

function DataModel.RefreshTop()
  local prisonCA = DataModel.prisonCA
  local roomIndex = PrisonData.roomIndex
  local program = DataModel.program or 1
  local tagId = program and prisonCA.initialHomeFurnitureList[tonumber(program)].schemeType
  local tagCA = PlayerData:GetFactoryData(tagId, "TagFactory")
  View.Group_Top.Group_WorkshopInfo.Txt_WorkshopName:SetText(tagCA.typeName)
  View.Group_Top.Group_WorkshopInfo.Img_WorkshopIcon:SetSprite(tagCA.iconPath)
  local name = string.format(GetText(80600296), roomIndex)
  View.Group_Top.Group_WorkshopInfo.Txt_Workshop:SetText(name)
  local master = DataModel.master
  if not master then
    View.Group_Top.Group_Monitor.Txt_MonitorName:SetText(GetText(80607109))
    View.Group_Top.Group_Monitor.Txt_MonitorDescribe:SetText(GetText(80607110))
  else
    local buffShow = DataModel.GetMasterBuffShow()
    if buffShow then
      View.Group_Top.Group_Monitor.Txt_MonitorDescribe:SetText(buffShow)
    else
      View.Group_Top.Group_Monitor.Txt_MonitorDescribe:SetText(GetText(80607110))
    end
    local prisonerCA = PlayerData:GetFactoryData(master.prisoner_id, "PrisonerFactory")
    View.Group_Top.Group_Monitor.Group_Avatar.Img_AvatarFrame.Img_Mask.Img_Avatar:SetSprite(prisonerCA.prisonerIconPath)
    local tagCA = PlayerData:GetFactoryData(prisonerCA.monitor, "TagFactory")
    View.Group_Top.Group_Monitor.Txt_MonitorName:SetText(tagCA.monitorJobName)
  end
  View.Group_Top.Group_Monitor.Group_Avatar.Img_AvatarFrame.Img_Mask:SetActive(master)
  View.Group_Top.Group_Monitor.Group_Avatar.Img_AvatarMask:SetActive(not master)
  View.Group_Top.Group_Monitor.Group_Avatar.Btn_Avatar:SetActive(master)
  DataModel.RefreshPrisonLV()
  View.Group_Top.Group_PrisonDetails.Group_Safety.Txt_SafetyNum:SetText(DataModel.safety)
  View.Group_Top.Group_PrisonDetails.Group_Stability.Txt_StabilityNum:SetText(DataModel.stability)
  View.Group_Top.Group_PrisonDetails.Group_Obedience.Txt_ObedienceNum:SetText(DataModel.obedience)
  View.Group_Top.Group_PrisonDetails.Group_Hygiene.Txt_HygieneNum:SetText(DataModel.hygiene)
end

function DataModel.RefreshPrisonLV()
  local lv = PrisonData.GetPrisonLv()
  View.Group_Top.Group_PrisonIcon.Group_.Txt_Num:SetText(lv)
  local LevelDataModel = require("UIPrisonLevel/UIPrisonLevelDataModel")
  View.Group_Top.Group_PrisonIcon.Group_.Img_RedDot:SetActive(LevelDataModel.CheckHasRedPoint())
end

function DataModel.GetMasterBuffShow()
  local roomIndex = PrisonData.roomIndex
  local master = PrisonData.GetPrisonerMaster(roomIndex)
  if not master then
    return
  end
  local prisonerCA = PlayerData:GetFactoryData(master.prisoner_id, "PrisonerFactory")
  local tagCA = PlayerData:GetFactoryData(prisonerCA.monitor, "TagFactory")
  if tagCA.buffId <= 0 then
    return
  end
  local buffCA = PlayerData:GetFactoryData(tagCA.buffId, "HomeBuffFactory")
  return string.format(buffCA.desc, math.floor(buffCA.probabilityParamClient))
end

function DataModel.ModifyRefresh()
  local roomIndex = PrisonData.roomIndex
  DataModel.master = PrisonData.GetPrisonerMaster(roomIndex)
  DataModel.RefreshTop()
end

function DataModel.ChangeRoomRefresh(roomIndex)
  local prisonData = PrisonData.GetSeverPrisonData()
  DataModel.program = prisonData.workshops_programme[tostring(roomIndex)]
  DataModel.master = PrisonData.GetPrisonerMaster(roomIndex)
  View.Group_Windows:SetActive(false)
  DataModel.RefreshTop()
  DataModel.RefreshFunList()
end

function DataModel.ReceiveAll()
  local roomIndex = PrisonData.roomIndex
  local receiveIndexList = {}
  local allProducts = PrisonData.GetRoomProducts(roomIndex)
  if allProducts then
    for cellIndex, v in pairs(allProducts) do
      if PrisonData.IsProductCanReceive(roomIndex, cellIndex) then
        table.insert(receiveIndexList, cellIndex)
      end
    end
  end
  if 0 < #receiveIndexList then
    local function yesFun()
      local function callBack(json)
        for i, cellIndex in pairs(receiveIndexList) do
          PrisonController.ReceiveProduct(cellIndex)
        end
      end
      
      PrisonData.ReceiveProduct(callBack, roomIndex, receiveIndexList)
    end
    
    PrisonData.PreReceiveProduct(yesFun, roomIndex, receiveIndexList, 80608307)
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

function DataModel.RefreshOneButton()
  local illCount = 0
  local eventCount = 0
  if not PlayerData.ServerData.user_prison_info or next(PlayerData.ServerData.user_prison_info) == nil then
    illCount = 0
    eventCount = 0
  else
    illCount = PrisonData.GetPrisonerIllOrEventCount(1)
    eventCount = PrisonData.GetPrisonerIllOrEventCount(2)
  end
  View.Group_AllBtn.Btn_AllMedical.Txt_NUm:SetText(illCount)
  View.Group_AllBtn.Btn_AllEvent.Txt_NUm:SetText(eventCount)
  View.Group_AllBtn.Btn_AllMedical:SetActive(0 < illCount)
  View.Group_AllBtn.Btn_AllEvent:SetActive(0 < eventCount)
end

return DataModel
