local View = require("UIExchangeStation/UIExchangeStationView")
local DataModel = require("UIExchangeStation/UIExchangeStationDataModel")
local ViewFunction = require("UIExchangeStation/UIExchangeStationViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.isWeaponReady = false
    DataModel.isOrderRefreshed = false
    DataModel.RefreshFrame = nil
    DataModel.curFrame = nil
    if initParams ~= nil then
      local t = Json.decode(initParams)
      local buildingId = t.buildingId
      local buildCA = PlayerData:GetFactoryData(buildingId)
      DataModel.BuildCA = buildCA
      DataModel.IsCityMapIn = t.IsCityMapIn
      if buildCA.stationId ~= nil and buildCA.stationId > 0 then
        DataModel.StationId = tostring(buildCA.stationId)
      else
        DataModel.StationId = tostring(t.stationId)
      end
      if buildCA.npcId ~= nil and 0 < buildCA.npcId then
        DataModel.NpcId = buildCA.npcId
      else
        DataModel.NpcId = t.npcId
      end
      if buildCA.bgPath ~= nil and buildCA.bgPath ~= "" then
        DataModel.BgPath = buildCA.bgPath
      else
        DataModel.BgPath = t.bgPath
      end
      DataModel.BgColor = buildCA.bgColor or "FFFFFF"
      DataModel.BgColor = "#" .. DataModel.BgColor
      DataModel.StationName = t.name
      if DataModel.BuildCA.isShowConstruct then
        DataModel.StationList = PlayerData:GetHomeInfo().stations[DataModel.StationId]
        DataModel.StationState = DataModel.StationList.state
      end
      DataModel.Index_OutSide = 1
      DataModel.InitMode = t.initMode
      DataModel.HelpId = t.helpId
      DataModel.HideBg = t.hideBg
      DataModel.StartTime = t.startTime
      DataModel.EndTime = t.endTime
      DataModel.idx = t.idx
      DataModel.InitItem = t.initItem
      DataModel:Init(true)
      if DataModel.idx then
        View.Group_Main.self:SetActive(false)
        ViewFunction.ExchangeStation_Group_Main_StaticGrid_List_Group_Btn_Btn_List_Click(nil, t.idx)
      end
    else
      DataModel:Init()
      if View.Group_Exchange.IsActive then
        DataModel:OpenStorePage(true)
      elseif View.Group_OrderList.IsActive then
        DataModel:RefershOrderList(false)
      end
      if DataModel.isNewUiOpen == true then
        DataModel.isNewUiOpen = nil
        View.self:PlayAnim("Main")
      end
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.RefreshFrame == nil or DataModel.curFrame == nil then
      return
    end
    DataModel.curFrame = DataModel.curFrame + 1
    if DataModel.curFrame < DataModel.RefreshFrame then
      return
    else
      DataModel.curFrame = DataModel.curFrame - DataModel.RefreshFrame
    end
    if DataModel.EndTime ~= nil and DataModel.EndTime ~= "" then
      local lastTime = TimeUtil:LastTime(DataModel.EndTime)
      local time = TimeUtil:SecondToTable(lastTime)
      local timeStr = ""
      if time.day > 0 then
        timeStr = string.format(GetText(80607025), time.day, time.hour)
      else
        timeStr = string.format(GetText(80607026), time.hour, time.minute)
      end
      View.Group_Time.Txt_Time:SetText(timeStr)
    end
  end,
  ondestroy = function()
    local npcDialog = require("Common/NPCDialog")
    npcDialog.ClearAll()
  end,
  enable = function()
  end,
  disenable = function()
    QuestProcess.RemoveQuestCallBack(View.self.url)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
