local View = require("UISignBattleLevelSlokai/UISignBattleLevelSlokaiView")
local DataModel = require("UISignBattleLevelSlokai/UISignBattleLevelSlokaiDataModel")
local Controller = require("UISignBattleLevelSlokai/UISignBattleLevelSlokaiController")
local ViewFunction = require("UISignBattleLevelSlokai/UISignBattleLevelSlokaiViewFunction")
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
    DataModel:Init(id)
    View.ScrollGrid_Map.grid.self:SetActive(false)
    Net:SendProto("activity.get_cs_activity", function(json)
      DataModel:SetSignBattleData(json)
      View.self:StartC(LuaUtil.cs_generator(function()
        coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
        Controller:Init()
      end))
    end)
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
