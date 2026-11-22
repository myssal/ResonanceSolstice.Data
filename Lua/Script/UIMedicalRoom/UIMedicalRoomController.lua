local DataModel = require("UIMedicalRoom/UIMedicalRoomDataModel")
local View = require("UIMedicalRoom/UIMedicalRoomView")
local Controller = {}

function Controller:Init()
  DataModel.isFirst = true
  View.Group_MedicalRoom:SetActive(true)
  DataModel.InitData()
  Controller:RefreshTop()
  Controller:RefreshBedList()
  Controller:RefreshReport(true)
end

function Controller:RefreshTop()
  local roomLevelId = PlayerData:GetFactoryData("87500015").roomList[DataModel.RoomLevel].config
  local roomCfg = PlayerData:GetFactoryData(roomLevelId)
  View.Group_Title.Group_LevelName.Txt_LevelName:SetText(roomCfg.roomDesc)
  View.Group_Title.Txt_Level:SetText("LV" .. DataModel.RoomLevel)
  DataModel.UsedBedNum = table.count(DataModel.HealingPrisonerData)
  View.Group_Detail.Group_Patient.Txt_PatientNum:SetText(string.format("<color=#FFB800>%d</color>/%d", DataModel.UsedBedNum, DataModel.TotalBedNum))
  View.Group_Detail.Group_Line.Txt_LineNum:SetText(table.count(DataModel.WaitingPrisonerData))
end

function Controller:SetBedElement(element, elementIndex)
  if elementIndex > DataModel.TotalBedNum and elementIndex <= DataModel.DefaultOpenGrid then
    element.Group_NoBed:SetActive(true)
    element.Group_Bed:SetActive(false)
  else
    element.Group_NoBed:SetActive(false)
    element.Group_Bed:SetActive(true)
    local row = DataModel.HealingPrisonerData[elementIndex]
    element.Group_Bed.Group_Prisoner:SetActive(row)
    element.Group_Bed.Group_Bed.Txt_:SetText(string.format(GetText(80608394), elementIndex))
    if row then
      local prisonerData = PrisonData.GetPrisoner(tostring(row.u_pid))
      local prisonerCfg = PlayerData:GetFactoryData(prisonerData.prisoner_id)
      element.Group_Bed.Group_Prisoner.Group_Card.Group_Detail.Txt_Num:SetText(string.format("%06d", prisonerData.clint_num))
      element.Group_Bed.Group_Prisoner.Group_Card.Group_Detail.Txt_Name:SetText(prisonerCfg.prisonerName)
      element.Group_Bed.Group_Prisoner.Group_Card.Group_Detail.Group_Health.Txt_HealthNum:SetText(prisonerData.healthy)
      local spineCfg = PlayerData:GetFactoryData(prisonerCfg.PrisonerAnimation)
      local animCfg = PlayerData:GetFactoryData(80302146).prisonerMedical[1]
      element.Group_Bed.Group_Prisoner.Group_Prisoner.Spine_:SetData(spineCfg.resDir, animCfg.actionName)
      local illCfg = PlayerData:GetFactoryData(row.illness)
      element.Group_Bed.Group_Prisoner.Group_Card.Group_Detail.Group_Medical.Img_Icon:SetSprite(illCfg.icon)
      element.Group_Bed.Group_Prisoner.Group_Card.Group_Detail.Group_Medical.Txt_HealthNum:SetText(illCfg.prisonerIll)
      element.Group_Bed.Group_Prisoner.Group_Card.Group_Detail.Group_CureHealth.Txt_HealthNum:SetText("+" .. illCfg.eventHealthReply + illCfg.naturalHealthReply)
      element.Group_Bed.Group_Prisoner.Group_Card:SetActive(false)
      local finishTime = row.start_ts + row.medicalTime
      local remainTime = finishTime - TimeUtil:GetServerTimeStamp()
      if 0 < remainTime then
        local timeTable = TimeUtil:SecondToTable(remainTime)
        element.Group_Bed.Group_Prisoner.Group_CureTime.Group_Bar.Txt_Time:SetText(string.format("%02d:%02d:%02d", timeTable.hour, timeTable.minute, timeTable.second))
        element.Group_Bed.Group_Prisoner.Group_CureTime.Group_Bar.Group_Bar.Img_Bar:SetFilledImgAmount(remainTime / row.medicalTime)
        local handle = {
          timeCtr = element.Group_Bed.Group_Prisoner.Group_CureTime.Group_Bar.Txt_Time,
          imgCtr = element.Group_Bed.Group_Prisoner.Group_CureTime.Group_Bar.Group_Bar.Img_Bar,
          finishTime = finishTime,
          totalTime = row.medicalTime
        }
        table.insert(DataModel.CountDownHandler, handle)
      else
        element.Group_Bed.Group_Prisoner.Group_CureTime.Group_Bar.Txt_Time:SetText("00:00:00")
        element.Group_Bed.Group_Prisoner.Group_CureTime.Group_Bar.Group_Bar.Img_Bar:SetFilledImgAmount(0)
      end
    end
    element.Group_Bed.Btn_:SetClickParam(elementIndex)
  end
end

function Controller:RefreshBedList()
  local count = DataModel.DefaultOpenGrid
  if count < DataModel.TotalBedNum then
    count = DataModel.TotalBedNum
  end
  if count % 2 == 1 then
    count = count + 1
  end
  DataModel.CountDownHandler = {}
  if DataModel.isFirst then
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      View.Group_MedicalRoom.NewScrollGrid_.grid.self:SetDataCount(count)
      View.Group_MedicalRoom.NewScrollGrid_.grid.self:RefreshAllElement()
      DataModel.isFirst = false
    end))
  else
    View.Group_MedicalRoom.NewScrollGrid_.grid.self:SetDataCount(count)
    View.Group_MedicalRoom.NewScrollGrid_.grid.self:RefreshAllElement()
  end
end

function Controller:SetReportCurePrisonerElement(element, elementIndex)
  local row = DataModel.ReportCurePrisonerList[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Group_Prisoner.Img_Prisoner:SetSprite(cfg.prisonerIconPath)
    element.Group_Prisoner.Group_Num.Txt_:SetText(cfg.clint_num)
    local sideCfg = PlayerData:GetFactoryData(cfg.prisonerSide)
    element.Group_Prisoner.Img_:SetSprite(sideCfg.iconPath)
    local illCfg = PlayerData:GetFactoryData(row.illness)
    element.Group_Des.Group_Pain.Img_Icon:SetSprite(illCfg.icon)
    element.Group_Des.Group_Pain.Txt_Name:SetText(illCfg.prisonerIll)
    local illTime = DataModel.Ill2TimeCache[tostring(row.illness)]
    local timeTable = TimeUtil:SecondToTableHMS(illTime)
    element.Group_Time.Txt_TimeNum:SetText(string.format("%02d:%02d:%02d", timeTable.hour, timeTable.minute, timeTable.second))
  end
end

function Controller:SetReportReleasePrisonerElement(element, elementIndex)
  local row = DataModel.ReportReleasePrisonerList[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Group_Prisoner.Img_Prisoner:SetSprite(cfg.prisonerIconPath)
    element.Group_Prisoner.Group_Num.Txt_:SetText(cfg.clint_num)
    local sideCfg = PlayerData:GetFactoryData(cfg.prisonerSide)
    element.Group_Prisoner.Img_:SetSprite(sideCfg.iconPath)
  end
end

function Controller:RefreshReport(isInit)
  local cureCount = #DataModel.ReportCurePrisonerList
  local releaseCount = #DataModel.ReportReleasePrisonerList
  if isInit and cureCount == 0 and releaseCount == 0 then
    return
  end
  View.Group_Report:SetActive(true)
  View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Cure.Group_NoInfo:SetActive(cureCount == 0)
  View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Cure.StaticGrid_Punish.self:SetActive(cureCount ~= 0)
  if cureCount ~= 0 then
    View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Cure.StaticGrid_Punish.grid.self:SetDataCount(cureCount)
    View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Cure.StaticGrid_Punish.grid.self:RefreshAllElement()
  end
  View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.Group_NoInfo:SetActive(releaseCount == 0)
  View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.StaticGrid_Punish.self:SetActive(releaseCount ~= 0)
  if releaseCount ~= 0 then
    View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.StaticGrid_Punish.grid.self:SetDataCount(releaseCount)
    View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.StaticGrid_Punish.grid.self:RefreshAllElement()
  end
  LayoutRebuilder.ForceRebuildLayoutImmediate(View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.self.Rect)
  LayoutRebuilder.ForceRebuildLayoutImmediate(View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Cure.self.Rect)
end

return Controller
