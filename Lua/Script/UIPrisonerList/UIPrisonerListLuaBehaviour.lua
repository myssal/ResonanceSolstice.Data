local View = require("UIPrisonerList/UIPrisonerListView")
local DataModel = require("UIPrisonerList/UIPrisonerListDataModel")
local ViewFunction = require("UIPrisonerList/UIPrisonerListViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      local parms = Json.decode(initParams)
      DataModel.PageMode = parms.Mode
      DataModel:Init()
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
