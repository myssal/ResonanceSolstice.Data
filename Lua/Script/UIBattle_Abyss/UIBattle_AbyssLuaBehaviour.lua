local View = require("UIBattle_Abyss/UIBattle_AbyssView")
local DataModel = require("UIBattle_Abyss/UIBattle_AbyssDataModel")
local Controller = require("UIBattle_Abyss/UIBattle_AbyssController")
local ViewFunction = require("UIBattle_Abyss/UIBattle_AbyssViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local param = Json.decode(initParams)
      DataModel.turntableId = param.id
      DataModel.activityId = param.activityId
      DataModel.isBattleReturn = param.isBattleReturn
      DataModel.curPeriodId = nil
      PlayerData:SaveAbyssTime()
      Controller:Init()
    else
      Controller:InitUI()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    DataModel.remainTime = DataModel.remainTime - 0.02
    if DataModel.remainTime <= 0 then
      DataModel.remainTime = DataModel.constTime
      Controller:Init()
      Controller:RefreshTime()
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
