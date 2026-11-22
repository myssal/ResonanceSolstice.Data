local Timer = require("Common/Timer")
local View = require("UIStageQuest/UIStageQuestView")
local DataModel = require("UIStageQuest/UIStageQuestDataModel")
local Controller = require("UIStageQuest/UIStageQuestController")
local ViewFunction = require("UIStageQuest/UIStageQuestViewFunction")
local Luabehaviour = {
  serialize = function()
    local params = {
      titleIndex = DataModel.TitleChoose,
      battleLeftIndex = DataModel.BattleLeftIndex
    }
    if params.titleIndex == DataModel.TitleType.Order then
      params.orderTab = DataModel.CurrentOrderTab
      params.orderSelect = DataModel.CurrentOrderIndex
    end
    return Json.encode(params)
  end,
  deserialize = function(initParams)
    DataModel.Init()
    if initParams then
      local params = Json.decode(initParams)
      DataModel.TitleChoose = tonumber(params.titleIndex)
      DataModel.BattleLeftIndex = tonumber(params.battleLeftIndex)
      DataModel.TargetOrderIndex = params.orderTab or 1
      DataModel.TargetOrderSelect = params.orderSelect or 1
      DataModel.IsBattleReturn = params.isBattleReturn
      DataModel.IsBattleReturnRefresh = params.isRefresh
      DataModel.IsFromActivity = params.isFromActivity
    end
    Controller:Init()
    View.timer = Timer.New(1, function()
      if DataModel.TargetTimeCountDown and DataModel.TargetTimeCountDown > 0 then
        DataModel.TargetTimeCountDown = DataModel.TargetTimeCountDown - 1
      elseif DataModel.TitleChoose == DataModel.TitleType.Daily then
        Net:SendProto("quest.list", function(json)
          if PlayerData.ServerData.items["11400013"] then
            PlayerData.ServerData.items["11400013"].num = 0
          end
          if json.quests.activity_day_quests then
            PlayerData.ServerData.quests.activity_day_quests = json.quests.activity_day_quests
          end
          PlayerData.ServerData.liveness_rewards = json.liveness_rewards
          DataModel.DailyInit()
          Controller:RefreshDailyPage()
          DataModel.IsRefreshDaily = false
        end, EnumDefine.QuestListDefine.BattlePassQuest)
      end
      if DataModel.TitleChoose == DataModel.TitleType.Battle then
        DataModel.IsRefreshBattle = DataModel.GetRefreshBattle()
        if DataModel.IsRefreshBattle then
          Controller:OpenBattle()
        end
        Controller:SetBattleInfoReduceTime()
      end
      if DataModel.TitleChoose == DataModel.TitleType.Order then
        Controller:UpdateOrderTime()
      end
    end)
    View.timer:Start()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if View.timer then
      View.timer:Update()
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
