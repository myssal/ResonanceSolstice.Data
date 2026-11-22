local View = require("UICubeSkill/UICubeSkillView")
local DataModel = require("UICubeSkill/UICubeSkillDataModel")
local ViewFunction = require("UICubeSkill/UICubeSkillViewFunction")
local Controller = require("UICubeSkill/UICubeSkillController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller.Init()
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
