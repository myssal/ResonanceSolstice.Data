local View = require("UIBattleBoss/UIBattleBossView")
local DataModel = require("UIBattleBoss/UIBattleBossDataModel")
local Controller = require("UIBattleBoss/UIBattleBossController")
local ViewFunction = require("UIBattleBoss/UIBattleBossViewFunction")
local Luabehaviour = {
  serialize = function()
    local parms = {}
    parms.activityId = DataModel.ActivityId
    parms.turntableId = DataModel.TurntableCA.id
    parms.stationId = DataModel.StationId
    parms.index = DataModel.SelectIndex
    parms.isCityMapIn = DataModel.IsCityMapIn
    parms.batterInfo = DataModel.BatterInfo
    parms.towerScore = DataModel.TowerScore
    return Json.encode(parms)
  end,
  deserialize = function(initParams)
    local parms = Json.decode(initParams)
    DataModel:Init(parms)
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
