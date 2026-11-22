local DataModel = {}
local UIFlierView = require("UIFlier/UIFlierView")
local goldenWeekDataModel = require("UIGoldenWeek/UIGoldenWeekDataModel")
local this = DataModel
DataModel.stationId = 0
DataModel.maxHaveFlierNum = 0
DataModel.curSelectCopyFlierNum = 0
DataModel.curSelectSendFlierNum = 0
DataModel.curFlierSendStartPosId = 0
DataModel.selectSendStationId = 0
DataModel.NextFreeFlierTime = 0
DataModel.NextOverPrintTime = 0
DataModel.sendPosList = {}
DataModel.sendBasic = 1
DataModel.sendStationList = {}
DataModel.sendStationElementList = nil
DataModel.selectSendStationElement = nil
DataModel.sendPosElementList = nil
DataModel.selectSendPosElement = nil

function DataModel.Init()
  local config = PlayerData:GetFactoryData(99900061, "ConfigFactory")
  this.sendBasic = config.leafletDozen
  DataModel.nowActivity = require("UIGroup_EventWeek/WeekActivityData").FindNowWeekActivity()
  DataModel.activityStart = next(DataModel.nowActivity) ~= nil
  DataModel.StartCityList = {}
  if DataModel.activityStart then
    local passengerBufflList = require("UIGroup_EventWeek/WeekActivityData").GetPassengerBufflList(DataModel.nowActivity)
    for i, v in ipairs(passengerBufflList) do
      DataModel.StartCityList[tostring(v.cityId)] = 1
    end
  end
end

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  this.stationId = data.stationId
  local leafLetList = PlayerData:GetFactoryData(data.stationId, "HomeStationFactory").cityLeafletLest
  table.sort(leafLetList, function(a, b)
    local leafletCA1 = PlayerData:GetFactoryData(a.id, "ListFactory")
    local leafletCA2 = PlayerData:GetFactoryData(b.id, "ListFactory")
    return leafletCA1.placeWeight < leafletCA2.placeWeight
  end)
  this.sendPosList = leafLetList
end

function DataModel.InitData()
  local config = PlayerData:GetFactoryData(99900061, "ConfigFactory")
  this.maxHaveFlierNum = config.leafletMax + PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.RiseFliersSaveLimited)
  this.sendStationList = this.GetSendStationList(this.stationId)
  DataModel.selectSendStationId = this.sendStationList[1]
end

function DataModel.GetMaxCopyNum()
  local remainCopy = PlayerData.GetRemainCopyLeafLetNum()
  local maxRemainHave = this.maxHaveFlierNum - PlayerData.GetLeafLetNum()
  return remainCopy > maxRemainHave and maxRemainHave or remainCopy
end

function DataModel.IsStationCanSendFlier(stationId)
  local stationCA = PlayerData:GetFactoryData(stationId, "HomeStationFactory")
  if stationCA and stationCA.isLeaflet then
    local cityLeafletLest = PlayerData:GetFactoryData(stationId, "HomeStationFactory").cityLeafletLest
    return table.count(cityLeafletLest) > 0
  end
  return false
end

function DataModel.GetSendStationList(excludeStation)
  local t = {}
  for stationId, _ in pairs(PlayerData:GetHomeInfo().stations) do
    if tonumber(stationId) ~= tonumber(excludeStation) and PlayerData:GetHomeInfo().stations[stationId].is_unlock == 1 and this.IsStationCanSendFlier(stationId) then
      table.insert(t, stationId)
    end
  end
  if 1 < table.count(t) then
    table.sort(t, function(a, b)
      local stationCA1 = PlayerData:GetFactoryData(a, "HomeStationFactory")
      local stationCA2 = PlayerData:GetFactoryData(b, "HomeStationFactory")
      local curLv1 = PlayerData:GetHomeInfo().stations[a].rep_lv or 0
      local lock1 = curLv1 < stationCA1.leafletUnlock
      local curLv2 = PlayerData:GetHomeInfo().stations[b].rep_lv or 0
      local lock2 = curLv2 < stationCA2.leafletUnlock
      if lock1 and lock2 or not lock1 and not lock2 then
        return stationCA1.order < stationCA2.order
      elseif lock1 and not lock2 then
        return false
      elseif not lock1 and lock2 then
        return true
      end
    end)
  end
  return t
end

this.Init()
return DataModel
