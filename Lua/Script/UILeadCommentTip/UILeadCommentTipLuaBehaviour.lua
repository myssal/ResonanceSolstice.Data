local View = require("UILeadCommentTip/UILeadCommentTipView")
local DataModel = require("UILeadCommentTip/UILeadCommentTipDataModel")
local ViewFunction = require("UILeadCommentTip/UILeadCommentTipViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
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
