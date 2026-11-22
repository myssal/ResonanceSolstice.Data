local View = require("UIBSMission/UIBSMissionView")
local DataModel = require("UIBSMission/UIBSMissionDataModel")
local ViewFunction = require("UIBSMission/UIBSMissionViewFunction")
local Controller = require("UIBSMission/UIBSMissionController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Group_Title.Img_Title:SetSprite((GetResPath(88300356)))
    DataModel.initParams = initParams
    DataModel.decodeParams = Json.decode(initParams)
    Controller:Init()
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
