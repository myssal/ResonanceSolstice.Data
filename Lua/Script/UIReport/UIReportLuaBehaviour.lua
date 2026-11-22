local View = require("UIReport/UIReportView")
local DataModel = require("UIReport/UIReportDataModel")
local Controller = require("UIReport/UIReportController")
local ViewFunction = require("UIReport/UIReportViewFunction")
local Luabehaviour = {
  serialize = function()
    return DataModel.params
  end,
  deserialize = function(initParams)
    DataModel.params = initParams
    DataModel.decodeParams = Json.decode(initParams)
    Controller:Init()
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
