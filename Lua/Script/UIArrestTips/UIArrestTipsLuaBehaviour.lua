local View = require("UIArrestTips/UIArrestTipsView")
local DataModel = require("UIArrestTips/UIArrestTipsDataModel")
local ViewFunction = require("UIArrestTips/UIArrestTipsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local param = Json.decode(initParams)
      DataModel:Init(param)
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
