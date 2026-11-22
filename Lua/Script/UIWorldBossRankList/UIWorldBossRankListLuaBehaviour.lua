local View = require("UIWorldBossRankList/UIWorldBossRankListView")
local DataModel = require("UIWorldBossRankList/UIWorldBossRankListDataModel")
local ViewFunction = require("UIWorldBossRankList/UIWorldBossRankListViewFunction")
local Controller = require("UIWorldBossRankList/UIWorldBossRankListController")
local Luabehaviour = {
  serialize = function()
    local status = {}
    status.activityId = DataModel.activityId
    return Json.encode(status)
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      Controller:Init(data.activityId)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    DataModel.QuickClickTime = DataModel.QuickClickTime + 1
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
