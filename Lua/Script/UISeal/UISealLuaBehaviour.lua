local View = require("UISeal/UISealView")
local DataModel = require("UISeal/UISealDataModel")
local ViewFunction = require("UISeal/UISealViewFunction")
local Controller = require("UISeal/UISealController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.WitchEventNextId = nil
    if initParams == "" or initParams == nil then
      DataModel.IsConvert = false
      DataModel.ConvertIndex = 0
      DataModel.TargetId = 0
      Controller:Init()
    else
      local params = Json.decode(initParams)
      DataModel.WitchEventNextId = params.witchEventNextId
      if DataModel.WitchEventNextId then
        DataModel.IsConvert = false
        DataModel.ConvertIndex = 0
        DataModel.TargetId = 0
      else
        DataModel.ConvertIndex = params.index
        DataModel.TargetId = params.targetId
        DataModel.IsConvert = true
      end
      Controller:Init()
    end
    local DataController = require("UIWitchMain/UIWitchMainDataController")
    DataController:SetCameraActive(false)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    local DataController = require("UIWitchMain/UIWitchMainDataController")
    DataController:SetCameraActive(true)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
