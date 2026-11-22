local View = require("UIHelpRoleBattleSelect/UIHelpRoleBattleSelectView")
local DataModel = require("UIHelpRoleBattleSelect/UIHelpRoleBattleSelectDataModel")
local ViewFunction = require("UIHelpRoleBattleSelect/UIHelpRoleBattleSelectViewFunction")
local Controller = require("UIHelpRoleBattleSelect/UIHelpRoleBattleSelectController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local param = Json.decode(initParams)
      DataModel.curSquadsIndex = param.curSquadsIndex
      DataModel.curSelectedRoles = param.curSelectedRoles
      DataModel.levelRoleMap = param.levelRoleMap
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
    Controller:UpDateBtnRefresh()
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
