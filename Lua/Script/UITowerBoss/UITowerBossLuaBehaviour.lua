local View = require("UITowerBoss/UITowerBossView")
local DataModel = require("UITowerBoss/UITowerBossDataModel")
local ViewFunction = require("UITowerBoss/UITowerBossViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local battleBossCtrl = require("UIBattleBoss/UIBattleBossController")
    battleBossCtrl:RefreshBuffList(View)
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
