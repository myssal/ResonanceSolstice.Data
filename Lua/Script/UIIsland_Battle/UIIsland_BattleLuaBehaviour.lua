local View = require("UIIsland_Battle/UIIsland_BattleView")
local DataModel = require("UIIsland_Battle/UIIsland_BattleDataModel")
local ViewFunction = require("UIIsland_Battle/UIIsland_BattleViewFunction")
local Controller = require("UIIsland_Battle/UIIsland_BattleController")
local Luabehaviour = {
  serialize = function()
    local data = {}
    data.activityId = DataModel.activityId
    data.levelType = DataModel.levelType or 1
    data.backUI = DataModel.backUI
    data.initIndex = DataModel.curLevelIndex
    data.isPlayGround = DataModel.isPlayGround
    return Json.encode(data)
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local data = Json.decode(initParams)
      Controller:Init(data)
    end
    View.Img_title:SetSprite(GetResPath(88300115))
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.monsterLevelAutoBattle then
      DataModel.remainAutoBattleTime = DataModel.remainAutoBattleTime - 0.02
      Controller:RefreshRemainTime()
    end
    if DataModel.upDateLevelTime ~= nil then
      DataModel.upDateLevelTime = DataModel.upDateLevelTime - 0.02
      if DataModel.upDateLevelTime <= 0 then
        DataModel.isCurLevelLocked = true
        DataModel.upDateLevelTime = nil
        Controller:OnClickLevel(DataModel.curLevelIndex + 1)
      end
    end
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
