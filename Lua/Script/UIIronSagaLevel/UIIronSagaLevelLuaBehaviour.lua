local View = require("UIIronSagaLevel/UIIronSagaLevelView")
local DataModel = require("UIIronSagaLevel/UIIronSagaLevelDataModel")
local ViewFunction = require("UIIronSagaLevel/UIIronSagaLevelViewFunction")
local Controller = require("UIIronSagaLevel/UIIronSagaLevelController")
local Luabehaviour = {
  serialize = function()
    local t = {}
    t.curPos = DataModel.curPos
    t.curLevelIdx = DataModel.curLevelIdx
    t.isBattleReturn = DataModel.initParams.isBattleReturn
    return Json.encode(t)
  end,
  deserialize = function(initParams)
    DataModel.initParams = {}
    if initParams then
      DataModel.initParams = Json.decode(initParams)
    end
    Controller:Init()
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    if DataModel.toPlayFirstPassAnim and DataModel.waitToShowComplete and not LoadingManager.isLoading then
      DataModel.toPlayFirstPassAnim = false
      Controller:DoFirstPassAnim()
    end
    if DataModel.ironSagaLevelAutoBattle then
      DataModel.remainAutoBattleTime = DataModel.remainAutoBattleTime - 0.02
      Controller:RefreshAutoBattleRemainTime()
    end
  end,
  ondestroy = function()
    if DataModel.cacheTweenTransform[DataModel.curPos] then
      DOTweenTools.Kill(DataModel.cacheTweenTransform[DataModel.curPos])
    end
    DataModel.cacheScrollRect = nil
    DataModel.cacheTweenTransform = nil
    PlayerData:SetPlayerPrefs("int", "IronSagaLevelPos", DataModel.curPos)
    DataModel.toPlayFirstPassAnim = false
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
