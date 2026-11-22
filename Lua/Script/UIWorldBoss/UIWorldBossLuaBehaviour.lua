local View = require("UIWorldBoss/UIWorldBossView")
local DataModel = require("UIWorldBoss/UIWorldBossDataModel")
local ViewFunction = require("UIWorldBoss/UIWorldBossViewFunction")
local Controller = require("UIWorldBoss/UIWorldBossController")
local updateTime = 30
local tempTime = 0
local Luabehaviour = {
  serialize = function()
    return Json.encode({
      activityId = DataModel.activityId
    })
  end,
  deserialize = function(initParams)
    local uiData = Json.decode(initParams)
    DataModel.isBattleReturn = uiData.isBattleReturn
    if uiData.refresh then
      Net:SendProto("activity.get_boss_info", function(json)
        PlayerData.ServerData.all_activities.ing[tostring(uiData.activityId)] = json.activity
        PlayerData.ServerData.all_activities.ing[tostring(uiData.activityId)].world_bosses = json.world_bosses
        DataModel.InitData(uiData)
        Controller.ShowPanel()
      end, uiData.activityId)
    else
      DataModel.InitData(uiData)
      Controller.ShowPanel()
    end
    tempTime = 0
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    tempTime = tempTime + Time.fixedDeltaTime
    if tempTime >= updateTime then
      tempTime = 0
      Controller.RefreshPanel()
    end
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
