local View = require("UIGroup_LikesTips/UIGroup_LikesTipsView")
local DataModel = require("UIGroup_LikesTips/UIGroup_LikesTipsDataModel")
local ViewFunction = require("UIGroup_LikesTips/UIGroup_LikesTipsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.RefreshOnShow()
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
