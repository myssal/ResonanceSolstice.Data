local View = require("UIPlayground/UIPlaygroundView")
local DataModel = require("UIPlayground/UIPlaygroundDataModel")
local Controller = require("UIPlayground/UIPlaygroundController")
local ViewFunction = require("UIPlayground/UIPlaygroundViewFunction")
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.initParams)
  end,
  deserialize = function(initParams)
    if initParams and initParams ~= "" then
      DataModel.initParams = Json.decode(initParams)
      PlayerData.TempCache.backSceneName = DataModel.initParams.backSceneName
    end
    Controller:LoadHome()
    local FriendListDataModel = require("UIFriendList/UIFriendListDataModel")
    FriendListDataModel.curVisitFriendUid = nil
    PlayerData:SetPlayerPrefs("int", "playgroundFriendListSort", 0)
  end,
  awake = function()
    Controller:SetDefaultPanel()
    DataModel.isLoad = false
    DataModel.cacheBattleChaInfo = {}
    DataModel.cacheEventChaIdInfo = {}
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
    QuestProcess.RemoveQuestCallBack(View.self.url)
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
