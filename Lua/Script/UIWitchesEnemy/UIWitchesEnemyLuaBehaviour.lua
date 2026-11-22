local View = require("UIWitchesEnemy/UIWitchesEnemyView")
local DataModel = require("UIWitchesEnemy/UIWitchesEnemyDataModel")
local ViewFunction = require("UIWitchesEnemy/UIWitchesEnemyViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
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
