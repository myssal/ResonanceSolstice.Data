local View = require("UIKabaneriSettlement/UIKabaneriSettlementView")
local DataModel = require("UIKabaneriSettlement/UIKabaneriSettlementDataModel")
local ViewFunction = require("UIKabaneriSettlement/UIKabaneriSettlementViewFunction")
local Controller = require("UIKabaneriSettlement/UIKabaneriSettlementController")
local Luabehaviour = {
  serialize = function()
    local data = {
      activityId = DataModel.activityCA.id
    }
    return data
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local param = Json.decode(initParams)
      DataModel.activityCA = PlayerData:GetFactoryData(param.activityId)
      DataModel.initIndex = param.initIndex
      Controller:Init(true)
    else
      Controller:Init()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.kabaneriAutoBattle then
      DataModel.remainAutoBattleTime = DataModel.remainAutoBattleTime - 0.02
      Controller:RefreshRemainTime()
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
