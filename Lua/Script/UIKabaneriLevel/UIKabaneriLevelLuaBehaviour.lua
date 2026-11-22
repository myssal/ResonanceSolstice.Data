local View = require("UIKabaneriLevel/UIKabaneriLevelView")
local DataModel = require("UIKabaneriLevel/UIKabaneriLevelDataModel")
local Controller = require("UIKabaneriLevel/UIKabaneriLevelController")
local ViewFunction = require("UIKabaneriLevel/UIKabaneriLevelViewFunction")
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
  update = function()
    if DataModel.toPlayFirstPassAnim and DataModel.waitToShowComplete and not LoadingManager.isLoading then
      DataModel.toPlayFirstPassAnim = false
      Controller:DoFirstPassAnim()
    end
    if DataModel.hotelLevelAutoBattle then
      DataModel.remainAutoBattleTime = DataModel.remainAutoBattleTime - 0.02
      Controller:RefreshAutoBattleRemainTime()
    end
  end,
  ondestroy = function()
    PlayerData:SetPlayerPrefs("int", "KabaneriLevelPos", DataModel.curPos)
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
