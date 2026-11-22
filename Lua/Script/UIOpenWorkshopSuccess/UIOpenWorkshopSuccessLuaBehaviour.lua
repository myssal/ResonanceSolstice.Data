local View = require("UIOpenWorkshopSuccess/UIOpenWorkshopSuccessView")
local DataModel = require("UIOpenWorkshopSuccess/UIOpenWorkshopSuccessDataModel")
local ViewFunction = require("UIOpenWorkshopSuccess/UIOpenWorkshopSuccessViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local params = Json.decode(initParams)
      DataModel.roomIndex = params.roomIndex
      DataModel.unlockIndex = params.unlockIndex
      DataModel.isFromProductionEdit = params.isFromProductionEdit
    else
      DataModel.roomIndex = -1
      DataModel.unlockIndex = -1
      DataModel.isFromProductionEdit = false
    end
    View.self:PlayAnimOnce("OpenWorkshopSuccess_In")
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
