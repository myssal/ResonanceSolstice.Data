local View = require("UIGridMenu/UIGridMenuView")
local ViewFunction = require("UIGridMenu/UIGridMenuViewFunction")
local Manager = require("UIGridMenu/UIGridMenuManager")
local MonopolyManager = require("UIMonopoly/LuaMonopolyManager")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      local gridId = Json.decode(initParams).gridId
      local mapId = Json.decode(initParams).mapId
      Manager.MonopolyMgr = MonopolyManager
      Manager.Init(gridId, mapId)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    Manager.RefreshBuffGodRemainTime()
    Manager.RefreshCityLv()
    Manager.RefreshGetBtnShow()
  end,
  ondestroy = function()
    Manager.Release()
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
