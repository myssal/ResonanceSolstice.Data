local View = require("UIDownload/UIDownloadView")
local DataModel = require("UIDownload/UIDownloadDataModel")
local ViewFunction = require("UIDownload/UIDownloadViewFunction")
local Controller = require("UIDownload/UIDownloadController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller.Init(Json.decode(initParams).IsGameIn)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    Controller.UpdateDownloadView()
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
