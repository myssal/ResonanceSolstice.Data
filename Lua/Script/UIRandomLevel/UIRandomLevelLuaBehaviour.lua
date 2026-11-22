local View = require("UIRandomLevel/UIRandomLevelView")
local DataModel = require("UIRandomLevel/UIRandomLevelDataModel")
local Controller = require("UIRandomLevel/UIRandomLevelController")
local ViewFunction = require("UIRandomLevel/UIRandomLevelViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local param = Json.decode(initParams)
      if param ~= nil and param.isBattleBack ~= true then
        DataModel.backToActivity = false
        Controller:Init(Json.decode(initParams))
      else
        DataModel.backToActivity = true
        Net:SendProto("battle.melee", function(json)
          Controller:Init(json.melee)
        end)
      end
    else
      Net:SendProto("battle.melee", function(json)
        Controller:Init(json.melee)
      end)
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
