local View = require("UIHelpRoleSelect/UIHelpRoleSelectView")
local DataModel = require("UIHelpRoleSelect/UIHelpRoleSelectDataModel")
local ViewFunction = require("UIHelpRoleSelect/UIHelpRoleSelectViewFunction")
local Controller = require("UIHelpRoleSelect/UIHelpRoleSelectController")
local Luabehaviour = {
  serialize = function()
    local data = {
      curSelectedIndex = -1,
      curSelectedRoles = DataModel.curSelectedRoles
    }
    return Json.encode(data)
  end,
  deserialize = function(initParams)
    if initParams then
      local param = Json.decode(initParams)
      DataModel.curSelectedIndex = param.curSelectedIndex or -1
      DataModel.curSelectedRoles = param.curSelectedRoles
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
