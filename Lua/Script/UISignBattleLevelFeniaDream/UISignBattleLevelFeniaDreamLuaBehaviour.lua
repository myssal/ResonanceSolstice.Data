local View = require("UISignBattleLevelFeniaDream/UISignBattleLevelFeniaDreamView")
local DataModel = require("UISignBattleLevelFeniaDream/UISignBattleLevelFeniaDreamDataModel")
local Controller = require("UISignBattleLevelFeniaDream/UISignBattleLevelFeniaDreamController")
local ViewFunction = require("UISignBattleLevelFeniaDream/UISignBattleLevelFeniaDreamViewFunction")
local Luabehaviour = {
  serialize = function()
    local params = {}
    params.activityId = DataModel.activityCA.id
    return Json.encode(params)
  end,
  deserialize = function(initParams)
    local params = Json.decode(initParams)
    DataModel.initParams = params
    local id = params.activityId
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
