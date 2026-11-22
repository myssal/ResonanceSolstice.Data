local View = require("UIMistSequenceMission/UIMistSequenceMissionView")
local DataModel = require("UIMistSequenceMission/UIMistSequenceMissionDataModel")
local ViewFunction = require("UIMistSequenceMission/UIMistSequenceMissionViewFunction")
local Controller = require("UIMistSequenceMission/UIMistSequenceMissionController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Group_Title.Img_Title:SetSprite((GetResPath(88300292)))
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
