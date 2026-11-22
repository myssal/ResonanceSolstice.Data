local View = require("UIActivitySignIn/UIActivitySignInView")
local Controller = require("UIActivitySignIn/UIActivitySignInController")
local DataModel = require("UIActivitySignIn/UIActivitySignInDataModel")
local ViewFunction = require("UIActivitySignIn/UIActivitySignInViewFunction")
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.initParams)
  end,
  deserialize = function(initParams)
    if initParams then
      DataModel:Init(initParams)
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
