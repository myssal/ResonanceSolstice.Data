local View = require("UIInitChoose/UIInitChooseView")
local DataModel = require("UIInitChoose/UIInitChooseDataModel")
local ViewFunction = require("UIInitChoose/UIInitChooseViewFunction")
local Controller = require("UIInitChoose/UIInitChooseController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      Controller:Init(Json.decode(initParams))
    end
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
