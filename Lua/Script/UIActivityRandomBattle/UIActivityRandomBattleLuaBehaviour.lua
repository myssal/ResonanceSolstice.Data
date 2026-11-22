local View = require("UIActivityRandomBattle/UIActivityRandomBattleView")
local DataModel = require("UIActivityRandomBattle/UIActivityRandomBattleDataModel")
local Controller = require("UIActivityRandomBattle/UIActivityRandomBattleController")
local ViewFunction = require("UIActivityRandomBattle/UIActivityRandomBattleViewFunction")
local Luabehaviour = {
  serialize = function()
    return {
      activityId = DataModel.activityCA.id
    }
  end,
  deserialize = function(initParams)
    if initParams then
      local parms = Json.decode(initParams)
      Controller:Init(parms)
    else
      Controller:Init()
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
