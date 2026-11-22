local View = require("UIExtendSuccess/UIExtendSuccessView")
local DataModel = require("UIExtendSuccess/UIExtendSuccessDataModel")
local ViewFunction = require("UIExtendSuccess/UIExtendSuccessViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Img_Title.self:SetSprite(GetResPath(88300113))
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
