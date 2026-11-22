local View = require("UIActivitySignBattleRanking/UIActivitySignBattleRankingView")
local DataModel = require("UIActivitySignBattleRanking/UIActivitySignBattleRankingDataModel")
local ViewFunction = require("UIActivitySignBattleRanking/UIActivitySignBattleRankingViewFunction")
local Controller = require("UIActivitySignBattleRanking/UIActivitySignBattleRankingController")
local Luabehaviour = {
  serialize = function()
    local data = {}
    data.activityId = DataModel.activityId
    return Json.encode(data)
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      DataModel.activityId = data.activityId
      local actCA = PlayerData:GetFactoryData(data.activityId)
      DataModel.RankForeverId = actCA.activityRankList[1].id
      DataModel.RankDailyId = actCA.activityRankList[1].id
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
