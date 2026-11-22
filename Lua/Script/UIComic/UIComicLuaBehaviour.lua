local View = require("UIComic/UIComicView")
local DataModel = require("UIComic/UIComicDataModel")
local ViewFunction = require("UIComic/UIComicViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    ApplicationHelper.OpenUrl("https://wiki.biligame.com/resonance/?curid=13715")
    UIManager:GoHome()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
