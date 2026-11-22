local View = require("UIParoleRoom/UIParoleRoomView")
local DataModel = require("UIParoleRoom/UIParoleRoomDataModel")
local ViewFunction = require("UIParoleRoom/UIParoleRoomViewFunction")
local Controller = require("UIParoleRoom/UIParoleRoomController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Group_LawyerList:SetActive(false)
    View.ParoleRoomPrompt:SetActive(false)
    View.self:PlayAnimOnce("In")
    Net:SendProto("prison.refresh", function(json)
      if json.user_prison_info.cur_lawyer then
        PlayerData.ServerData.user_prison_info.cur_lawyer = json.user_prison_info.cur_lawyer
      end
      if json.user_prison_info.lawyers then
        PlayerData.ServerData.user_prison_info.lawyers = json.user_prison_info.lawyers
      end
      Controller:Init()
    end)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
