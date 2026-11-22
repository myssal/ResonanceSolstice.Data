local View = require("UIMedicalRoom/UIMedicalRoomView")
local DataModel = require("UIMedicalRoom/UIMedicalRoomDataModel")
local ViewFunction = require("UIMedicalRoom/UIMedicalRoomViewFunction")
local Controller = require("UIMedicalRoom/UIMedicalRoomController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Group_Report:SetActive(false)
    View.Group_MedicalRoom:SetActive(false)
    Net:SendProto("prison.refresh", function(json)
      if json.user_prison_info.medical_room then
        PlayerData.ServerData.user_prison_info.medical_room = json.user_prison_info.medical_room
      end
      if json.user_prison_info.medical_room_temporary then
        PlayerData.ServerData.user_prison_info.medical_room_temporary = json.user_prison_info.medical_room_temporary
      end
      if json.user_prison_info.medical_report then
        PlayerData.ServerData.user_prison_info.medical_report = json.user_prison_info.medical_report
      end
      Controller:Init()
    end)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    local function refreshFunc()
      Net:SendProto("prison.reset_report", function(json)
        PlayerData.ServerData.user_prison_info.medical_report = {}
      end, "medical_report")
      Net:SendProto("prison.refresh", function(json)
        if json.user_prison_info.medical_room then
          PlayerData.ServerData.user_prison_info.medical_room = json.medical_room
        end
        if json.user_prison_info.medical_room_temporary then
          PlayerData.ServerData.user_prison_info.medical_room_temporary = json.medical_room_temporary
        end
        if json.user_prison_info.medical_report then
          PlayerData.ServerData.user_prison_info.medical_report = json.medical_report
        end
        Controller:Init()
      end)
    end
    
    local needRefresh = false
    for i, v in ipairs(DataModel.CountDownHandler) do
      local remainTime = v.finishTime - TimeUtil:GetServerTimeStamp()
      if remainTime <= -1 then
        needRefresh = true
        break
      elseif v.timeCtr and v.imgCtr then
        local timeTable = TimeUtil:SecondToTable(remainTime)
        v.timeCtr:SetText(string.format("%02d:%02d:%02d", timeTable.hour, timeTable.minute, timeTable.second))
        v.imgCtr:SetFilledImgAmount(remainTime / v.totalTime)
      end
    end
    if needRefresh and #DataModel.CountDownHandler > 0 then
      refreshFunc()
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    DataModel.CountDownHandler = {}
    Net:SendProto("prison.reset_report", function(json)
      PlayerData.ServerData.user_prison_info.medical_report = {}
    end, "medical_report")
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
