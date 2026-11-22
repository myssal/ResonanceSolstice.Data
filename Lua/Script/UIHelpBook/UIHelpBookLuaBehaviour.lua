local View = require("UIHelpBook/UIHelpBookView")
local DataModel = require("UIHelpBook/UIHelpBookDataModel")
local ViewFunction = require("UIHelpBook/UIHelpBookViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.self:PlayAnim("HelpBook_in", function()
      View.self:SetEnableAnimator(false)
    end)
    DataModel.InitData()
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
