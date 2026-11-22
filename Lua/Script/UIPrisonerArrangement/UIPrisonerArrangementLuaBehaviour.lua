local View = require("UIPrisonerArrangement/UIPrisonerArrangementView")
local DataModel = require("UIPrisonerArrangement/UIPrisonerArrangementDataModel")
local ViewFunction = require("UIPrisonerArrangement/UIPrisonerArrangementViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local param = Json.decode(initParams)
      DataModel.uidList = param.uidList
    end
    DataModel:Init()
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
