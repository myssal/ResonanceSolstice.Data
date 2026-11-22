local View = require("UIBoxEnemy/UIBoxEnemyView")
local DataModel = require("UIBoxEnemy/UIBoxEnemyDataModel")
local ViewFunction = require("UIBoxEnemy/UIBoxEnemyViewFunction")
local Controller = require("UIBoxEnemy/UIBoxEnemyController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      local gridId = Json.decode(initParams).gridId
      local eventId = Json.decode(initParams).eventId
      local difficulty = Json.decode(initParams).difficulty
      local dialogEvent = Json.decode(initParams).dialogEvent
      local isInit = Json.decode(initParams).isInit
      DataModel.gridId = gridId
      DataModel.eventId = eventId
      DataModel.difficulty = difficulty
      DataModel.dialogEvent = dialogEvent
      DataModel.isInit = isInit
      Controller.Init()
    end
  end,
  awake = function()
  end,
  start = function()
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
