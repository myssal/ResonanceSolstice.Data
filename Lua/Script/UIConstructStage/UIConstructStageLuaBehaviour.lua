local View = require("UIConstructStage/UIConstructStageView")
local DataModel = require("UIConstructStage/UIConstructStageDataModel")
local ViewFunction = require("UIConstructStage/UIConstructStageViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local t = Json.decode(initParams)
      DataModel:GetStationStageData(t.stationId)
      if t.index then
        DataModel.Index_Construct = t.index
      end
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
