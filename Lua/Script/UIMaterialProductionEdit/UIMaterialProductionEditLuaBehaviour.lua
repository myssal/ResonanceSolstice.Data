local View = require("UIMaterialProductionEdit/UIMaterialProductionEditView")
local DataModel = require("UIMaterialProductionEdit/UIMaterialProductionEditDataModel")
local ViewFunction = require("UIMaterialProductionEdit/UIMaterialProductionEditViewFunction")
local Controller = require("UIMaterialProductionEdit/UIMaterialProductionEditController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      local data = Json.decode(initParams)
      DataModel.RoomTypeId = tonumber(data.roomTypeId)
      DataModel.JumpFormulaId = tonumber(data.jumpFormulaId) or 0
      if DataModel.CheckProductState() then
        Net:SendProto("prison.pre_receive_raw_material", function(json)
          if json.raw_material_workshops then
            for i, v in pairs(json.raw_material_workshops) do
              if PlayerData.ServerData.user_prison_info and PlayerData.ServerData.user_prison_info.raw_material_workshops then
                PlayerData.ServerData.user_prison_info.raw_material_workshops[tostring(i)] = v
              end
            end
          end
          if json.power then
            PlayerData.ServerData.user_prison_info.power = json.power
          end
          Controller:Init()
        end, tostring(DataModel.RoomTypeId))
      else
        Controller:Init()
      end
    else
      UIManager:GoBack()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    for i, v in ipairs(DataModel.TimeCount) do
      local productTime = TimeUtil:GetServerTimeStamp() - v.startTime + v.speedTime
      productTime = productTime < 0 and 0 or productTime
      local timeTable = TimeUtil:SecondToTableHMS(productTime)
      v.ctr:SetText(string.format("%02d:%02d:%02d", timeTable.hour, timeTable.minute, timeTable.second))
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    DataModel.TimeCount = {}
    DataModel.SelectFormulaId = 0
    local roomData = DataModel.GetRoomData()
    if roomData then
      Net:SendProto("prison.del_leave_replace", function()
      end, tostring(DataModel.RoomTypeId))
    end
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
