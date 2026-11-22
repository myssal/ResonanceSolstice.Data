local View = require("UIPassageTrafficRank/UIPassageTrafficRankView")
local DataModel = require("UIPassageTrafficRank/UIPassageTrafficRankDataModel")
local ViewFunction = require("UIPassageTrafficRank/UIPassageTrafficRankViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if DataModel.refreshNetData then
      DataModel.refreshNetData = nil
      Net:SendProto("main.overview", function(json)
        DataModel.clearScore = json.current_clean or 1
        DataModel.InitData()
        DataModel.RefreshOnShow()
      end)
    else
      DataModel.InitData()
      DataModel.RefreshOnShow()
    end
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
