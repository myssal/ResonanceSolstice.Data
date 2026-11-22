local View = require("UIWiki/UIWikiView")
local DataModel = require("UIWiki/UIWikiDataModel")
local ViewFunction = require("UIWiki/UIWikiViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    ApplicationHelper.OpenUrl("https://wiki.biligame.com/resonance")
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
