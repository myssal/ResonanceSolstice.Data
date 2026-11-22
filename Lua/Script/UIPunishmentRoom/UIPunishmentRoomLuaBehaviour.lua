local View = require("UIPunishmentRoom/UIPunishmentRoomView")
local DataModel = require("UIPunishmentRoom/UIPunishmentRoomDataModel")
local ViewFunction = require("UIPunishmentRoom/UIPunishmentRoomViewFunction")
local Controller = require("UIPunishmentRoom/UIPunishmentRoomController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Group_Report:SetActive(false)
    View.Group_PunishmentRoom:SetActive(false)
    Net:SendProto("prison.refresh", function(json)
      if json.user_prison_info.detention_room then
        PlayerData.ServerData.user_prison_info.detention_room = json.user_prison_info.detention_room
      end
      if json.user_prison_info.detention_report then
        PlayerData.ServerData.user_prison_info.detention_report = json.user_prison_info.detention_report
      end
      Controller:Init()
    end)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    local needRefresh = false
    for i, v in pairs(DataModel.CountDownHandler) do
      local remainTime = v.start_ts + v.punishTime - TimeUtil:GetServerTimeStamp()
      if remainTime <= -1 then
        needRefresh = true
      end
      remainTime = remainTime < 0 and 0 or remainTime
      local timeTable = TimeUtil:SecondToTable(math.floor(remainTime))
      if v.timeCtr and v.imgCtr then
        v.timeCtr:SetText(string.format("%02d:%02d:%02d", timeTable.hour, timeTable.minute, timeTable.second))
        v.imgCtr:SetFilledImgAmount(remainTime / v.punishTime)
      end
    end
    for i, v in pairs(DataModel.ReportTimeHandler) do
      local remainTime = v.startTime + v.punishTime - TimeUtil:GetServerTimeStamp()
      if remainTime <= 0 then
        needRefresh = true
      end
      remainTime = remainTime < 0 and 0 or remainTime
      local timeTable = TimeUtil:SecondToTable(math.floor(remainTime))
      if v.ctr then
        v.ctr:SetText(string.format("%02d:%02d:%02d", timeTable.hour, timeTable.minute, timeTable.second))
      end
    end
    if needRefresh then
      Net:SendProto("prison.reset_report", function(json)
        PlayerData.ServerData.user_prison_info.detention_report = {}
      end, "detention_report")
      Net:SendProto("prison.refresh", function(json)
        if json.user_prison_info.detention_room then
          PlayerData.ServerData.user_prison_info.detention_room = json.user_prison_info.detention_room
        end
        if json.user_prison_info.detention_report then
          PlayerData.ServerData.user_prison_info.detention_report = json.user_prison_info.detention_report
        end
        Controller:Init()
      end)
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    DataModel.CountDownHandler = {}
    Net:SendProto("prison.reset_report", function(json)
      PlayerData.ServerData.user_prison_info.detention_report = {}
    end, "detention_report")
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
