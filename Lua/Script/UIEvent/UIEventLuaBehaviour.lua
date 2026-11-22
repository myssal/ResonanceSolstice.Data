local View = require("UIEvent/UIEventView")
local DataModel = require("UIEvent/UIEventDataModel")
local ViewFunction = require("UIEvent/UIEventViewFunction")
local Controller = require("UIEvent/UIEventController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      DataModel.bookName = Json.decode(initParams).bookName
      Controller.Init()
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
