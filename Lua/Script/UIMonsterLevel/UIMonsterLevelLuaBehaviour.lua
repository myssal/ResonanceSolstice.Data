local View = require("UIMonsterLevel/UIMonsterLevelView")
local DataModel = require("UIMonsterLevel/UIMonsterLevelDataModel")
local Controller = require("UIMonsterLevel/UIMonsterLevelController")
local ViewFunction = require("UIMonsterLevel/UIMonsterLevelViewFunction")
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
    View.Group_BG.Group_1.Img_Icon:SetSprite(GetResPath(88300042))
    View.Group_BG.Group_2.Img_Icon:SetSprite(GetResPath(88300043))
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
    if DataModel.monsterLevelAutoBattle then
      DataModel.remainAutoBattleTime = DataModel.remainAutoBattleTime - 0.02
      Controller:RefreshAutoBattleRemainTime()
    end
  end,
  ondestroy = function()
    PlayerData:SetPlayerPrefs("int", "MonsterLevelPos", DataModel.curPos)
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
