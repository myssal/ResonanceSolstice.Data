local View = require("UIHotelMission/UIHotelMissionView")
local DataModel = require("UIHotelMission/UIHotelMissionDataModel")
local ViewFunction = require("UIHotelMission/UIHotelMissionViewFunction")
local Controller = require("UIHotelMission/UIHotelMissionController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.initParams = initParams
    DataModel.decodeParams = Json.decode(initParams)
    Controller:Init()
    View.Group_Title.Img_Title:SetSprite(GetResPath(88300139))
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
