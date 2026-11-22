local View = require("UIPersonalLeaderboards/UIPersonalLeaderboardsView")
local DataModel = require("UIPersonalLeaderboards/UIPersonalLeaderboardsDataModel")
local ViewFunction = require("UIPersonalLeaderboards/UIPersonalLeaderboardsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local params = Json.decode(initParams)
      ViewFunction:Init(params)
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
