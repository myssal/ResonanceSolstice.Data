local View = require("UITeam_CubeNew/UITeam_CubeNewView")
local DataModel = require("UITeam_CubeNew/UITeam_CubeNewDataModel")
local ViewFunction = require("UITeam_CubeNew/UITeam_CubeNewViewFunction")
local Controller = require("UITeam_CubeNew/UITeam_CubeNewController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:SetDataModel("UITeam_CubeNew/UITeam_CubeNewDataModel")
    local isReopen = true
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.hasPrePanel = data.hasPrePanel
      DataModel.mode = data.mode
      DataModel.levelId = data.levelId
      isReopen = false
    end
    Controller:Init(isReopen)
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
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
