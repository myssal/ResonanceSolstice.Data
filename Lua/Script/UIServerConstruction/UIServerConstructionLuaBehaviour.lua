local View = require("UIServerConstruction/UIServerConstructionView")
local DataModel = require("UIServerConstruction/UIServerConstructionDataModel")
local Controller = require("UIServerConstruction/UIServerConstructionController")
local ViewFunction = require("UIServerConstruction/UIServerConstructionViewFunction")
local Luabehaviour = {
  serialize = function()
    local parms = {}
    parms.type = DataModel.isAll == true and "All" or "One"
    parms.id = DataModel.activityId
    return Json.encode(parms)
  end,
  deserialize = function(initParams)
    local parms = Json.decode(initParams)
    local type = parms.type
    DataModel.isAll = type == "All"
    DataModel.activityId = parms.id
    Controller:Init()
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
