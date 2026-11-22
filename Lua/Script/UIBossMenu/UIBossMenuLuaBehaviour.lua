local View = require("UIBossMenu/UIBossMenuView")
local DataModel = require("UIBossMenu/UIBossMenuDataModel")
local ViewFunction = require("UIBossMenu/UIBossMenuViewFunction")
local Controller = require("UIBossMenu/UIBossMenuController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      local bossLevel = Json.decode(initParams).bossLevel
      local monopolyId = Json.decode(initParams).monopolyId
      local isHelpBoss = Json.decode(initParams).isHelpBoss
      DataModel.SetBossLevelId(bossLevel, monopolyId)
      Controller.Init(isHelpBoss)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
    Controller.Release()
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
