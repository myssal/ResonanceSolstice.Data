local View = require("UIOpenTips/UIOpenTipsView")
local DataModel = require("UIOpenTips/UIOpenTipsDataModel")
local ViewFunction = require("UIOpenTips/UIOpenTipsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    DataModel:Init(data)
    UIManager:OpenSpecialUI(DataModel.CurrentUrl, Json.encode({
      id = DataModel.openList[DataModel.Index]
    }))
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
