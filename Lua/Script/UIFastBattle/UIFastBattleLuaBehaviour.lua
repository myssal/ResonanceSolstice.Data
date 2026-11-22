local View = require("UIFastBattle/UIFastBattleView")
local DataModel = require("UIFastBattle/UIFastBattleDataModel")
local ViewFunction = require("UIFastBattle/UIFastBattleViewFunction")
local Controller = require("UIFastBattle/UIFastBattleController")
local Safe_Controller = require("UIFastBattle/UIFastBattleSafeController")
local Battle_Controller = require("UIFastBattle/UIFastBattleBattleController")
local Battle_DataModel = require("UIFastBattle/UIFastBattleBattleDataModel")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.openType = DataModel.openType or 1
    DataModel.curSafeType = DataModel.curSafeType or 1
    DataModel.IsMainActivityIn = DataModel.IsMainActivityIn or false
    DataModel.curSelectIndex = DataModel.curSelectIndex or 1
    DataModel.curLevelSelectIdx = DataModel.curLevelSelectIdx or 1
    DataModel.curBattleIndex = DataModel.curBattleIndex or 0
    if initParams then
      local params = Json.decode(initParams)
      if params then
        local extraUIParam = params.extraUIParamData
        local getWayUIParam = params.getWayUIParamData
        if extraUIParam then
          DataModel.openType = extraUIParam.openType or 1
          DataModel.curSafeType = extraUIParam.curSafeType or 1
          DataModel.IsMainActivityIn = extraUIParam.isMainActivityIn
          DataModel.curSelectIndex = extraUIParam.curSelectIndex or 1
          DataModel.curLevelSelectIdx = extraUIParam.curLevelIndex or 1
          DataModel.curBattleIndex = extraUIParam.curBattleIndex or 0
          DataModel.curXsIndex = extraUIParam.curXsIndex or 1
        elseif getWayUIParam then
          DataModel.openType = getWayUIParam.openType or 1
          DataModel.curSafeType = getWayUIParam.curSafeType or 1
          DataModel.curSelectIndex = getWayUIParam.curSelectIndex or 1
          DataModel.curLevelSelectIdx = getWayUIParam.curLevelIndex or 1
          DataModel.curXsIndex = getWayUIParam.curXsIndex or 1
          DataModel.IsMainActivityIn = false
          if getWayUIParam.openType == 1 then
            local stationList = DataModel.GetAllSafeStationList()
            if getWayUIParam.curSafeType == 1 and DataModel.curSafeType == 1 then
              local levelList = PlayerData:GetFactoryData(stationList[DataModel.curSelectIndex].id).createQuestList
              DataModel.curLevelSelectIdx = 1
              for j, lv in ipairs(levelList) do
                if tonumber(lv.id) == tonumber(getWayUIParam.targetTabId) then
                  DataModel.curLevelSelectIdx = j
                  break
                end
              end
            end
          elseif getWayUIParam.openType == 2 then
            DataModel.curBattleIndex = DataModel.GetBattleTargetTab(getWayUIParam.targetTabId)
            if DataModel.curBattleIndex == 0 then
              CommonTips.OpenTips(80611128)
              DataModel.curBattleIndex = 1
            end
          end
        else
          DataModel.openType = params.openType or 1
          DataModel.curSafeType = params.curSafeType or 1
          DataModel.IsMainActivityIn = params.isMainActivityIn
          DataModel.curSelectIndex = params.curSelectIndex or 1
          DataModel.curLevelSelectIdx = params.curLevelIndex or 1
          DataModel.curBattleIndex = params.curBattleIndex or 0
          DataModel.curXsIndex = params.curXsIndex or 1
        end
      end
    end
    Controller.Init()
    DataModel.InitDayRefreshTime()
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    Safe_Controller:Update()
    if View.timer then
      View.timer:Update()
    end
    Safe_Controller:UpdateSliderView()
    if View.Group_Safa and View.Group_Safa.self.IsActive and View.Group_Safa.Group_Level.self.IsActive and DataModel.monsterLevelAutoBattle then
      DataModel.remainAutoBattleTime = DataModel.remainAutoBattleTime - 0.02
      Safe_Controller:RefreshRemainTime()
    end
    if View.Group_Battle and View.Group_Battle.self.IsActive and View.Group_Battle.Group_Battle.self.IsActive and Battle_DataModel.monsterLevelAutoBattle then
      Battle_DataModel.remainAutoBattleTime = Battle_DataModel.remainAutoBattleTime - 0.02
      Battle_Controller.RefreshRemainTime()
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
