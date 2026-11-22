local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
local BattleBossTipDataModel = require("UIBattleBossTip/UIBattleBossTipDataModel")
local DataModel = {}

function DataModel:Init(openList)
  DataModel.Index = 1
  DataModel.openList = openList
  DataModel.MaxIndex = table.count(openList)
  DataModel:SetActivityCurrentUrl()
end

function DataModel:SetActivityCurrentUrl()
  local id = DataModel.openList[DataModel.Index]
  DataModel.CurrentUrl = PlayerData:GetFactoryData(id).showOpenTipsUI
end

function DataModel:SetActivityTipList()
  local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
  local activeList = DataModel.ActiveList or ActivityMainDataModel:GetActivityCAList()
  local openList = {}
  for k, v in pairs(activeList) do
    local ca = PlayerData:GetFactoryData(v.id)
    if ca then
      local index = ActivityMainDataModel.GetActivityTipsIndex(v.id)
      local newTips = PlayerData:GetPlayerPrefs("int", "ActivityTip" .. v.id .. index) == 0
      local isActive = ActivityMainDataModel.IsActiveNewTimeOpen(v.id, nil).isActive
      if (v.id == 86000001 or v.id == 86000009) and index == 1 then
        isActive = true
      end
      local isJoin = ca.isJoin and PlayerData:GetActivityAct(v.id)
      local isQuestFinish = ca.questId ~= -1 and ActivityMainDataModel:QuestIsFinish(ca.questId) == true or ca.questId == -1
      if v.id == 86000005 then
        isQuestFinish = BattleBossTipDataModel.IsFinish()
      end
      if v.id == 86000022 and isQuestFinish == true then
        if PlayerData.ServerData.user_prison_info and next(PlayerData.ServerData.user_prison_info) ~= nil then
          isJoin = true
        else
          local tradeLv = PlayerData:GetHomeInfo().trade_lv or 1
          local requireLv = PrisonData.GetPrisonCA().initialTradeLevel
          isQuestFinish = tradeLv >= requireLv
        end
      end
      if ca.showOpenTipsUI ~= "" and newTips and isActive and isQuestFinish and not isJoin then
        table.insert(openList, v.id)
      end
    end
  end
  return openList
end

function DataModel:SetNextOpenTip()
  local index = ActivityMainDataModel.GetActivityTipsIndex(DataModel.openList[DataModel.Index])
  PlayerData:SetPlayerPrefs("int", "ActivityTip" .. DataModel.openList[DataModel.Index] .. index, 1)
  DataModel.Index = DataModel.Index + 1
  UIManager:CloseSpecialUI(DataModel.CurrentUrl)
  if DataModel.Index > DataModel.MaxIndex then
    return
  end
  DataModel:SetActivityCurrentUrl()
  UIManager:OpenSpecialUI(DataModel.CurrentUrl, Json.encode({
    id = DataModel.openList[DataModel.Index]
  }))
end

return DataModel
