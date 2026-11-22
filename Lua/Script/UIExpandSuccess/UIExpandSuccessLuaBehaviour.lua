local View = require("UIExpandSuccess/UIExpandSuccessView")
local DataModel = require("UIExpandSuccess/UIExpandSuccessDataModel")
local ViewFunction = require("UIExpandSuccess/UIExpandSuccessViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Txt_AddNum:SetText(string.format(GetText(80607469), initParams))
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
