local Timer = require("Common/Timer")
local View = require("UIBlackLevel/UIBlackLevelView")
local DataModel = require("UIBlackLevel/UIBlackLevelDataModel")
local Controller = require("UIBlackLevel/UIBlackLevelController")
local ViewFunction = require("UIBlackLevel/UIBlackLevelViewFunction")
local Luabehaviour = {
  serialize = function()
    local params = {}
    params.activityId = DataModel.activityCA.id
    params.index = DataModel.openIndex
    return Json.encode(params)
  end,
  deserialize = function(initParams)
    local params = Json.decode(initParams)
    DataModel.initParams = params
    local id = params.activityId
    Controller:Init(id)
    if params.index then
      Controller:OpenRightPage(params.index)
    end
    View.timer = Timer.New(1, function()
      if DataModel.blackLevelAutoBattle then
        Controller:RefreshRemainTime()
        DataModel.blackLevelAutoBattleTime = DataModel.blackLevelAutoBattleTime - 1
      end
    end)
    View.timer:Start()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    View.timer:Update()
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
