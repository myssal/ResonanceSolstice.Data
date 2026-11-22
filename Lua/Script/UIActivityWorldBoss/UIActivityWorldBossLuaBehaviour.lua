local View = require("UIActivityWorldBoss/UIActivityWorldBossView")
local DataModel = require("UIActivityWorldBoss/UIActivityWorldBossDataModel")
local ViewFunction = require("UIActivityWorldBoss/UIActivityWorldBossViewFunction")
local Controller = require("UIActivityWorldBoss/UIActivityWorldBossController")
local uiData
local Luabehaviour = {
  serialize = function()
    return Json.encode(uiData)
  end,
  deserialize = function(initParams)
    uiData = Json.decode(initParams)
    Net:SendProto("activity.get_boss_info", function(json)
      PlayerData.ServerData.all_activities.ing[tostring(uiData.activityId)] = json.activity
      PlayerData.ServerData.all_activities.ing[tostring(uiData.activityId)].world_bosses = json.world_bosses
      DataModel.InitData(uiData)
      Controller.ShowPanel()
    end, uiData.activityId)
    View.Group_Bg.SoftMask_Role.self:MaskAllManaged()
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
