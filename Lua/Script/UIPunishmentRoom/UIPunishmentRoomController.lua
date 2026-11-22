local View = require("UIPunishmentRoom/UIPunishmentRoomView")
local DataModel = require("UIPunishmentRoom/UIPunishmentRoomDataModel")
local Controller = {}

function Controller:PunishTimeDown(List)
  table.sort(List, function(a, b)
    return a.remainPunishTime > b.remainPunishTime
  end)
end

function Controller:PunishTimeUp(List)
  table.sort(List, function(a, b)
    return a.remainPunishTime < b.remainPunishTime
  end)
end

function Controller:DaySortDown(List)
  table.sort(List, function(a, b)
    return a.days > b.days
  end)
end

function Controller:DaySortUp(List)
  table.sort(List, function(a, b)
    return a.days < b.days
  end)
end

function Controller:Init()
  DataModel.isFirst = true
  DataModel:InitData()
  View.Group_PunishmentRoom:SetActive(true)
  DataModel.CurSortDown = false
  View.Group_TopRightPrison.Btn_PunishTime.Img_DeP:SetActive(true)
  View.Group_TopRightPrison.Btn_PunishTime.Img_AP:SetActive(false)
  View.Group_TopRightPrison.Group_PrisonDetails.Group_Safety.Txt_SafetyNum:SetText(PlayerData.ServerData.user_prison_info.safety)
  View.Group_TopRightPrison.Group_PrisonDetails.Group_Stability.Txt_StabilityNum:SetText(PlayerData.ServerData.user_prison_info.stability)
  View.Group_TopRightPrison.Group_PrisonDetails.Group_Obedience.Txt_ObedienceNum:SetText(PlayerData.ServerData.user_prison_info.obedience)
  View.Group_TopRightPrison.Group_PrisonDetails.Group_Hygiene.Txt_HygieneNum:SetText(PlayerData.ServerData.user_prison_info.hygiene)
  Controller:RefreshData()
  Controller:ShowPunishReport(true)
  View.self:PlayAnimOnce()
end

function Controller:RefreshData()
  Controller:RefreshTitle()
  Controller:RefreshPrisonerList()
  Controller:RefreshOneButton()
end

function Controller:SetPrisonerElement(element, elementIndex)
  local row = DataModel.SortShowList[elementIndex]
  if row then
    element.Group_Prisoner:SetActive(true)
    element.Group_Empty:SetActive(false)
    local prisonerCfg = PlayerData:GetFactoryData(row.id)
    local spineCfg = PlayerData:GetFactoryData(prisonerCfg.PrisonerAnimation)
    local animCfg = PlayerData:GetFactoryData(80302146).prisonerPunish[1]
    element.Group_Prisoner.Group_Prisoner.Spine_Pic:SetData(spineCfg.resDir, animCfg.actionName)
    element.Group_Prisoner.Group_Prisoner.Txt_Num:SetText(string.format(GetText(80607161), string.format("%06d", tonumber(row.clint_num))))
    element.Group_Prisoner.Group_Punish.Txt_:SetText(string.format(GetText(80608159), PlayerData:GetFactoryData(row.eventId).prisonerPersonalityFetterName))
    element.Group_Prisoner.Group_FriskBtn.Btn_Frisk:SetActive(row.frisk_count == 0)
    element.Group_Prisoner.Group_FriskBtn.Img_Frisk:SetActive(row.frisk_count > 0)
    element.Group_Prisoner.Group_FriskBtn.Btn_Frisk:SetClickParam(elementIndex)
    local remainPunishTime = row.start_ts + row.punishTime - TimeUtil:GetServerTimeStamp()
    remainPunishTime = remainPunishTime < 0 and 0 or remainPunishTime
    if 0 < remainPunishTime then
      element.Group_Prisoner.Group_Bar.Txt_Time:SetText(TimeUtil:SecondToTable(math.floor(remainPunishTime)))
      element.Group_Prisoner.Group_Bar:SetActive(true)
      local handler = {
        timeCtr = element.Group_Prisoner.Group_Bar.Txt_Time,
        imgCtr = element.Group_Prisoner.Group_Bar.Img_Bar,
        start_ts = row.start_ts,
        punishTime = row.punishTime
      }
      table.insert(DataModel.CountDownHandler, handler)
    else
      element.Group_Prisoner.Group_Bar:SetActive(false)
    end
  else
    element.Group_Prisoner:SetActive(false)
    element.Group_Empty:SetActive(true)
  end
end

function Controller:SetPunishPrisoner(element, elementIndex)
  local row = DataModel.PunishPrisonerList[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    local eventCfg = PlayerData:GetFactoryData(row.eventId)
    if cfg and eventCfg then
      element.Group_Des.Txt_Des:SetText(string.format(GetText(80607666), cfg.prisonerName, eventCfg.prisonerPersonalityFetterName))
      local remainTime = row.startTime + row.punishTime - TimeUtil:GetServerTimeStamp()
      if 0 <= remainTime then
        local timeTable = TimeUtil:SecondToTable(row.punishTime)
        element.Group_Time.Txt_TimeNum:SetText(string.format("%02d:%02d:%02d", timeTable.hour, timeTable.minute, timeTable.second))
        local handler = {
          startTime = row.startTime,
          punishTime = row.punishTime,
          ctr = element.Group_Time.Txt_TimeNum
        }
        table.insert(DataModel.ReportTimeHandler, handler)
      end
    end
  end
end

function Controller:SetReleasePrisoner(element, elementIndex)
  local row = DataModel.ReleasePrisonerList[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    if cfg then
      element.Group_Prisoner.Group_Num.Txt_:SetText(string.format("NO.%06d", tonumber(row.clint_num)))
    end
  end
end

function Controller:RefreshTitle()
  View.Group_Title.Group_Title.Txt_Level:SetText("LV" .. DataModel.RoomLevel)
  local roomCfg = PlayerData:GetFactoryData(87500014)
  local roomLevelId = PlayerData:GetFactoryData(87500014).roomList[DataModel.RoomLevel].config
  local cfg = PlayerData:GetFactoryData(roomLevelId)
  View.Group_Title.Group_Title.Txt_RoomName:SetText(roomCfg.roomName)
  View.Group_Title.Group_Title.Group_LevelName.Txt_LevelName:SetText(cfg.roomDesc)
end

function Controller:RefreshPrisonerList()
  Controller:SortRefreshData()
  DataModel.CountDownHandler = {}
  local count = DataModel.DefaultOpenGrid
  if count < table.count(DataModel.SortShowList) then
    count = table.count(DataModel.SortShowList)
  end
  if count % 2 == 1 then
    count = count + 1
  end
  if DataModel.isFirst then
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      View.Group_PunishmentRoom.NewScrollGrid_.grid.self:SetDataCount(count)
      View.Group_PunishmentRoom.NewScrollGrid_.grid.self:RefreshAllElement()
      DataModel.isFirst = false
    end))
  else
    View.Group_PunishmentRoom.NewScrollGrid_.grid.self:SetDataCount(count)
    View.Group_PunishmentRoom.NewScrollGrid_.grid.self:RefreshAllElement()
  end
end

function Controller:RefreshOneButton()
  local pidList = {}
  for i, v in ipairs(DataModel.SortShowList) do
    local row = DataModel.SortShowList[i]
    if row and row.frisk_count == 0 then
      table.insert(pidList, row.u_pid)
    end
  end
  View.Btn_AllSearch:SetActive(0 < table.count(pidList))
end

function Controller:ShowPunishReport(isInit)
  local pCount = table.count(DataModel.PunishPrisonerList)
  local rCount = table.count(DataModel.ReleasePrisonerList)
  View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Punish.Group_Punish:SetActive(false)
  View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.Group_Punish:SetActive(false)
  if isInit and pCount == 0 and rCount == 0 then
    return
  end
  View.Group_Report:SetActive(true)
  View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Punish.StaticGrid_Punish.self:SetActive(0 < pCount)
  View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Punish.Group_NoInfo:SetActive(pCount == 0)
  if 0 < pCount then
    View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Punish.StaticGrid_Punish.grid.self:SetDataCount(pCount)
    View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Punish.StaticGrid_Punish.grid.self:RefreshAllElement()
  end
  View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.StaticGrid_Punish.self:SetActive(0 < rCount)
  View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.Group_NoInfo:SetActive(rCount == 0)
  if 0 < rCount then
    View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.StaticGrid_Punish.grid.self:SetDataCount(rCount)
    View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.StaticGrid_Punish.grid.self:RefreshAllElement()
  end
  LayoutRebuilder.ForceRebuildLayoutImmediate(View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Punish.self.Rect)
  LayoutRebuilder.ForceRebuildLayoutImmediate(View.Group_Report.Group_Report.ScrollView_.Viewport.Content.Group_Release.self.Rect)
  LayoutRebuilder.ForceRebuildLayoutImmediate(View.Group_Report.Group_Report.ScrollView_.Viewport.Content.self.Rect)
end

function Controller:SortRefreshData()
  DataModel.SortShowList = Clone(DataModel.PrisonerList)
  if DataModel.CurSortDown then
    Controller:PunishTimeDown(DataModel.SortShowList)
  else
    Controller:PunishTimeUp(DataModel.SortShowList)
  end
end

function Controller:OneButtonFriskAll()
  local pidList = {}
  for i, v in ipairs(DataModel.SortShowList) do
    local row = DataModel.SortShowList[i]
    if row and row.frisk_count == 0 then
      table.insert(pidList, row.u_pid)
    end
  end
  if table.count(pidList) == 0 then
    return
  end
  local max = PrisonData.GetProductWarehouseMaxCapacity()
  local cur = PrisonData.GetProductWarehouseCapacity()
  if max < cur + 3 * table.count(pidList) then
    CommonTips.OnPrompt(80608307, nil, nil, function()
      if table.count(pidList) > 0 then
        Net:SendProto("prison.frisk", function(json)
          if json.detention_room then
            PlayerData.ServerData.user_prison_info.detention_room = json.detention_room
          end
          if json.product then
            PlayerData.ServerData.user_prison_info.product = json.product
          end
          if json.reward then
            CommonTips.OpenShowItem(json.reward)
          end
          DataModel.CollectPrisonerList()
          Controller:RefreshPrisonerList()
          Controller:RefreshOneButton()
        end, Json.encode(pidList))
      end
    end)
  elseif table.count(pidList) > 0 then
    Net:SendProto("prison.frisk", function(json)
      if json.detention_room then
        PlayerData.ServerData.user_prison_info.detention_room = json.detention_room
      end
      if json.product then
        PlayerData.ServerData.user_prison_info.product = json.product
      end
      if json.reward then
        CommonTips.OpenShowItem(json.reward)
      end
      DataModel.CollectPrisonerList()
      Controller:RefreshPrisonerList()
      Controller:RefreshOneButton()
    end, Json.encode(pidList))
  end
end

function Controller:TryFrisk(idx)
  local row = DataModel.SortShowList[idx]
  if row then
    if row.frisk_count > 0 then
      return
    end
    local pidList = {}
    table.insert(pidList, row.u_pid)
    local max = PrisonData.GetProductWarehouseMaxCapacity()
    local cur = PrisonData.GetProductWarehouseCapacity()
    if max < cur + 3 then
      CommonTips.OnPrompt(80608307, nil, nil, function()
        Net:SendProto("prison.frisk", function(json)
          if json.detention_room then
            PlayerData.ServerData.user_prison_info.detention_room = json.detention_room
          end
          if json.product then
            PlayerData.ServerData.user_prison_info.product = json.product
          end
          if json.reward then
            CommonTips.OpenShowItem(json.reward)
          end
          DataModel.CollectPrisonerList()
          Controller:RefreshPrisonerList()
          Controller:RefreshOneButton()
        end, Json.encode(pidList))
      end)
    else
      Net:SendProto("prison.frisk", function(json)
        if json.detention_room then
          PlayerData.ServerData.user_prison_info.detention_room = json.detention_room
        end
        if json.product then
          PlayerData.ServerData.user_prison_info.product = json.product
        end
        if json.reward then
          CommonTips.OpenShowItem(json.reward)
        end
        DataModel.CollectPrisonerList()
        Controller:RefreshPrisonerList()
        Controller:RefreshOneButton()
      end, Json.encode(pidList))
    end
  end
end

function Controller:SortRevert()
  if DataModel.CurSortDown then
    DataModel.CurSortDown = false
    View.Group_TopRightPrison.Btn_PunishTime.Img_AP:SetActive(true)
    View.Group_TopRightPrison.Btn_PunishTime.Img_DeP:SetActive(false)
  else
    DataModel.CurSortDown = true
    View.Group_TopRightPrison.Btn_PunishTime.Img_DeP:SetActive(true)
    View.Group_TopRightPrison.Btn_PunishTime.Img_AP:SetActive(false)
  end
  Controller:RefreshPrisonerList()
end

return Controller
