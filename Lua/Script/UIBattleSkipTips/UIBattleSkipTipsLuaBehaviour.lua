local View = require("UIBattleSkipTips/UIBattleSkipTipsView")
local DataModel = require("UIBattleSkipTips/UIBattleSkipTipsDataModel")
local ViewFunction = require("UIBattleSkipTips/UIBattleSkipTipsViewFunction")
local Controller = require("UIBattleSkipTips/UIBattleSkipTipsController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.InitParams = {}
    local status
    if initParams ~= nil and initParams ~= "" then
      status = Json.decode(initParams)
      DataModel.InitParams = status
      DataModel.InitParams.NextDistance = PlayerData.TempCache.NextDistance or status.NextDistance
      DataModel.InitParams.Sid = PlayerData.TempCache.Sid or status.Sid
      DataModel.dialogId = status.dialogId
      DataModel.friendId = status.friendId
      DataModel.gridId = status.gridId
      DataModel.csActivityId = status.csActivityId
      DataModel.csIndex = status.csIndex
      PlayerData.SquadsTempData = DataModel.InitParams
    end
    DataModel:Init(status)
    Controller:Init()
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
