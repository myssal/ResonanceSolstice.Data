local View = require("UIMoonMission/UIMoonMissionView")
local DataModel = require("UIMoonMission/UIMoonMissionDataModel")
local ViewFunction = require("UIMoonMission/UIMoonMissionViewFunction")
local Controller = require("UIMoonMission/UIMoonMissionController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Group_Title.Img_Title:SetSprite((GetResPath(88300353)))
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
