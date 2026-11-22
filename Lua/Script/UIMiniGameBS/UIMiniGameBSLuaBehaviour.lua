local View = require("UIMiniGameBS/UIMiniGameBSView")
local DataModel = require("UIMiniGameBS/UIMiniGameBSDataModel")
local ViewFunction = require("UIMiniGameBS/UIMiniGameBSViewFunction")
local Controller = require("UIMiniGameBS/UIMiniGameBSController")
local Luabehaviour = {
  serialize = function()
    return DataModel.Serialize()
  end,
  deserialize = function(initParams)
    Controller.Init(initParams)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
    Controller.Update()
  end,
  update = function()
  end,
  ondestroy = function()
    Controller.Destroy()
  end,
  enable = function()
    Controller.Enable()
  end,
  disenable = function()
    Controller.Disable()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
