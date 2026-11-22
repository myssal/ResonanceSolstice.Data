local View = require("UIEndlessBattle/UIEndlessBattleView")
local DataModel = require("UIEndlessBattle/UIEndlessBattleDataModel")
local Controller = require("UIEndlessBattle/UIEndlessBattleController")
local ViewFunction = require("UIEndlessBattle/UIEndlessBattleViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.activityId = data.activityId
      DataModel.lastDiff = data.lastDiff
      if data.isBattleEnd then
        DataModel.backToActivity = true
        Net:SendProto("endless.activity_main", function(json)
          PlayerData.ServerData.all_endless_activity[tostring(data.activityId)] = json.user_endless
          DataModel.user_endless = json.user_endless
          Controller:Init()
        end, data.activityId)
      else
        DataModel.backToActivity = false
        DataModel.user_endless = data.user_endless
        Controller:Init()
      end
    else
      Controller:Init()
    end
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
