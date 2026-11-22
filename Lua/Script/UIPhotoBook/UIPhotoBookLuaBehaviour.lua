local View = require("UIPhotoBook/UIPhotoBookView")
local DataModel = require("UIPhotoBook/UIPhotoBookDataModel")
local ViewFunction = require("UIPhotoBook/UIPhotoBookViewFunction")
local Controller = require("UIPhotoBook/UIPhotoBookController")
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
