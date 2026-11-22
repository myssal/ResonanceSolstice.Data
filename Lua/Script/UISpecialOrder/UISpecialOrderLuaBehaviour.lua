local View = require("UISpecialOrder/UISpecialOrderView")
local DataModel = require("UISpecialOrder/UISpecialOrderDataModel")
local ViewFunction = require("UISpecialOrder/UISpecialOrderViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams and initParams ~= "" then
      local params = Json.decode(initParams)
      if params then
        DataModel.ActivityId = params.activityId
      end
    end
    Net:SendProto("future.levy_activity_main", function(json)
      if json.user_future_activity then
        PlayerData.ServerData.user_info.user_future_activity = json.user_future_activity
        DataModel.Init()
      end
    end, DataModel.ActivityId)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
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
