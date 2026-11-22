local View = require("UISignBattleLevelWensheng/UISignBattleLevelWenshengView")
local DataModel = require("UISignBattleLevelWensheng/UISignBattleLevelWenshengDataModel")
local Controller = require("UISignBattleLevelWensheng/UISignBattleLevelWenshengController")
local ViewFunction = require("UISignBattleLevelWensheng/UISignBattleLevelWenshengViewFunction")
local Luabehaviour = {
  serialize = function()
    local params = {}
    params.activityId = DataModel.activityCA.id
    params.eventId = DataModel.eventId
    return Json.encode(params)
  end,
  deserialize = function(initParams)
    local params = Json.decode(initParams)
    DataModel.initParams = params
    local id = params.activityId
    DataModel.activityId = params.activityId
    DataModel.eventId = params.eventId
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      Controller:Init(id)
    end))
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
