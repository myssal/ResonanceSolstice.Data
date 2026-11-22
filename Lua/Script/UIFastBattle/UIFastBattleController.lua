local View = require("UIFastBattle/UIFastBattleView")
local DataModel = require("UIFastBattle/UIFastBattleDataModel")
local Safe_Controller = require("UIFastBattle/UIFastBattleSafeController")
local XS_Controller = require("UIFastBattle/UIFastBattleXSController")
local XS_DataModel = require("UIFastBattle/UIFastBattleXSDataModel")
local Battle_Controller = require("UIFastBattle/UIFastBattleBattleController")
local Battle_DataModel = require("UIFastBattle/UIFastBattleBattleDataModel")
local Controller = {}

function Controller.Init()
  Controller.RefreshContentShow()
end

function Controller.RefreshContentShow()
  View.Group_Ding:SetActive(false)
  if DataModel.openType == 1 then
    View.Group_Safa.Group_Level:SetActive(false)
    View.Group_Safa.Group_XS:SetActive(false)
    Controller.RefreshSafePartShow()
    if DataModel.IsMainActivityIn then
      Controller.OnSafeElementBtnClick(DataModel.curSelectIndex)
      View.Group_Safa.ScrollGrid_Tab.grid.self:MoveToPos(DataModel.curSelectIndex)
    else
      Net:SendProto("building.level", function(json)
        PlayerData.ServerData.security_levels = json.special_level.security_levels
        DataModel.InitLevelData()
        XS_DataModel.InitRewardLevels(json.special_level.reward_level)
        Controller.OnSafeElementBtnClick(DataModel.curSelectIndex)
        View.Group_Safa.ScrollGrid_Tab.grid.self:MoveToPos(DataModel.curSelectIndex)
      end, nil)
    end
  elseif DataModel.openType == 2 then
    View.Group_Battle.Group_Battle:SetActive(false)
    Controller.RefreshBattlePartShow()
    Controller.OnBattleElementBtnClick(DataModel.curSelectIndex, false)
    View.Group_Battle.ScrollGrid_Tab.grid.self:MoveToPos(DataModel.curSelectIndex)
  end
end

function Controller.RefreshSafePartShow()
  View.Group_Safa:SetActive(true)
  View.Group_Battle:SetActive(false)
  local safeStationList = DataModel.GetAllSafeStationList()
  if not safeStationList then
    return
  end
  View.Group_Safa.ScrollGrid_Tab.grid.self:SetDataCount(#safeStationList)
  View.Group_Safa.ScrollGrid_Tab.grid.self:RefreshAllElement()
end

function Controller.RefreshSafeStationElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local safeStationList = DataModel.GetAllSafeStationList()
  if not safeStationList then
    return
  end
  local info = safeStationList[elementIndex]
  if not info then
    return
  end
  local buildInfo = PlayerData:GetFactoryData(info.id, "BuildingFactory")
  if not buildInfo then
    return
  end
  element.Img_RedPoint:SetActive(DataModel.GetLeverRewardRedDotState(info.id))
  local isStationUnlock = DataModel.GetSafeStationIsUnlock(info.id)
  if isStationUnlock then
    element.Group_Lock:SetActive(false)
    element.Group_UnLock:SetActive(true)
  else
    element.Group_UnLock:SetActive(false)
    element.Group_Lock:SetActive(true)
  end
  Controller.RefreshStationElementEnemyLvShow(element, isStationUnlock, elementIndex)
  element.Group_UnLock.Img_Icon:SetSprite(buildInfo.quickIconPath)
  element.Group_Lock.Img_Icon:SetSprite(buildInfo.quickIconPath)
  local stationCa = PlayerData:GetFactoryData(buildInfo.stationId, "BuildingFactory")
  if stationCa then
    element.Group_UnLock.Txt_Name:SetText(stationCa.name)
    element.Group_Lock.Txt_Name:SetText(stationCa.name)
  end
  local progress = DataModel.GetSafeStationProgressById(info.id)
  element.Group_UnLock.Group_Not.Txt_Num:SetText(string.format(GetText(80611108), progress))
  if 100 <= progress then
    element.Group_UnLock.Group_Not:SetActive(false)
    element.Group_UnLock.Group_Complete:SetActive(true)
  else
    element.Group_UnLock.Group_Not:SetActive(true)
    element.Group_UnLock.Group_Complete:SetActive(false)
  end
  if elementIndex == DataModel.curSelectIndex and isStationUnlock then
    element.Group_On:SetActive(true)
  else
    element.Group_On:SetActive(false)
  end
  element.Btn_:SetClickFunction(function()
    Controller.OnSafeElementBtnClick(elementIndex)
  end)
end

function Controller.OnSafeElementBtnClick(elementIndex)
  local build
  local safeStationList = DataModel.GetAllSafeStationList()
  if safeStationList and safeStationList[elementIndex] then
    build = safeStationList[elementIndex].id
  end
  if not build then
    return
  end
  local isStationUnlock = DataModel.GetSafeStationIsUnlock(build)
  if not isStationUnlock then
    return
  end
  DataModel.BuildingId = build
  Controller.RefreshSafeSwitchBtnPartShow()
  DataModel.curSelectIndex = elementIndex
  DataModel.curSafeSelectIndex = elementIndex
  View.Group_Safa.ScrollGrid_Tab.grid.self:RefreshAllElement()
  if DataModel.curSafeType == 1 then
    Controller.OnLevelBtnClick()
  elseif DataModel.curSafeType == 2 then
    Controller.OnXSBtnClick()
  end
end

function Controller.RefreshSafeSwitchBtnPartShow()
  local safeStationList = DataModel.GetAllSafeStationList()
  if not safeStationList then
    return
  end
  if not DataModel.BuildingId then
    return
  end
  local leverRedState = DataModel.GetLeverRewardRedDotState(DataModel.BuildingId)
  View.Group_Safa.Group_Switch.Group_Level.Img_RedPoint:SetActive(leverRedState)
  local xsIsUnlock = DataModel.GetXSTaskIsUnlock(DataModel.BuildingId)
  if xsIsUnlock then
    View.Group_Safa.Group_Switch.Group_XS.Group_Lock:SetActive(false)
    View.Group_Safa.Group_Switch.Group_XS.Group_Off:SetActive(true)
    View.Group_Safa.Group_Switch.Group_XS.Group_On:SetActive(false)
  else
    View.Group_Safa.Group_Switch.Group_XS.Group_Lock:SetActive(true)
    View.Group_Safa.Group_Switch.Group_XS.Group_Off:SetActive(false)
    View.Group_Safa.Group_Switch.Group_XS.Group_On:SetActive(false)
    local buildInfo = PlayerData:GetFactoryData(DataModel.BuildingId, "BuildingFactory")
    if buildInfo then
      View.Group_Safa.Group_Switch.Group_XS.Group_Lock.Txt_Limit:SetText(string.format(GetText(80611109), buildInfo.offerPrestige))
    end
  end
end

function Controller.OnLevelBtnClick()
  DataModel.curSafeType = 1
  View.Group_Safa.Group_Switch.Group_Level.Group_Off:SetActive(false)
  View.Group_Safa.Group_Switch.Group_Level.Group_On:SetActive(true)
  local isXSUnlock = DataModel.GetXSTaskIsUnlock(DataModel.BuildingId)
  if isXSUnlock then
    View.Group_Safa.Group_Switch.Group_XS.Group_Off:SetActive(true)
    View.Group_Safa.Group_Switch.Group_XS.Group_On:SetActive(false)
    View.Group_Safa.Group_Switch.Group_XS.Group_Lock:SetActive(false)
  else
    View.Group_Safa.Group_Switch.Group_XS.Group_Off:SetActive(false)
    View.Group_Safa.Group_Switch.Group_XS.Group_On:SetActive(false)
    View.Group_Safa.Group_Switch.Group_XS.Group_Lock:SetActive(true)
  end
  Controller.RefreshSafeLevelPartShow()
end

function Controller.OnXSBtnClick()
  local xsIsUnlock = DataModel.GetXSTaskIsUnlock(DataModel.BuildingId)
  if not xsIsUnlock then
    return
  end
  DataModel.curSafeType = 2
  View.Group_Safa.Group_Switch.Group_Level.Group_Off:SetActive(true)
  View.Group_Safa.Group_Switch.Group_Level.Group_On:SetActive(false)
  View.Group_Safa.Group_Switch.Group_XS.Group_Off:SetActive(false)
  View.Group_Safa.Group_Switch.Group_XS.Group_On:SetActive(true)
  View.Group_Safa.Group_Switch.Group_XS.Group_Lock:SetActive(false)
  Controller.RefreshSafeXSPartShow()
end

function Controller.RefreshSafeLevelPartShow()
  local isStationUnlock = DataModel.GetSafeStationIsUnlock(DataModel.BuildingId)
  if not isStationUnlock then
    View.Group_Safa.Group_Level:SetActive(false)
    View.Group_Safa.Group_XS:SetActive(false)
    View.Group_Ding:SetActive(false)
    return
  end
  View.Group_Safa.Group_Level:SetActive(true)
  View.Group_Safa.Group_XS:SetActive(false)
  if not DataModel.BuildingId then
    return
  end
  Safe_Controller:ClickShowLevelPanel(Controller.RefreshResource, DataModel.curLevelSelectIdx)
  View.Group_Safa.ScrollGrid_Tab.grid.self:RefreshAllElement()
end

function Controller.RefreshSafeXSPartShow()
  local isStationUnlock = DataModel.GetSafeStationIsUnlock(DataModel.BuildingId)
  if not isStationUnlock then
    View.Group_Safa.Group_Level:SetActive(false)
    View.Group_Safa.Group_XS:SetActive(false)
    View.Group_Ding:SetActive(false)
    return
  end
  View.Group_Safa.Group_Level:SetActive(false)
  View.Group_Safa.Group_XS:SetActive(true)
  XS_Controller:ClickShowRewardPanel(Controller.RefreshResource)
  View.Group_Safa.ScrollGrid_Tab.grid.self:RefreshAllElement()
end

function Controller.RefreshBattlePartShow()
  View.Group_Safa:SetActive(false)
  View.Group_Battle:SetActive(true)
  local battleStationList = DataModel.GetAllBattleStationList()
  if not battleStationList then
    return
  end
  DataModel.battleStationList = battleStationList
  View.Group_Battle.ScrollGrid_Tab.grid.self:SetDataCount(#battleStationList)
  View.Group_Battle.ScrollGrid_Tab.grid.self:RefreshAllElement()
end

function Controller.RefreshBattleElement(element, elementIndex)
  local battleStationList = DataModel.battleStationList
  if not battleStationList then
    return
  end
  local info = battleStationList[elementIndex]
  if not info then
    return
  end
  local homeInfo = PlayerData:GetFactoryData(info.id, "HomeStationFactory")
  if not homeInfo then
    return
  end
  local isBalletUnlock = DataModel.GetBattleStationIsUnlock(info.id)
  if isBalletUnlock then
    element.Group_Lock:SetActive(false)
    element.Group_UnLock:SetActive(true)
  else
    element.Group_UnLock:SetActive(false)
    element.Group_Lock:SetActive(true)
  end
  Controller.RefreshStationElementEnemyLvShow(element, isBalletUnlock, elementIndex)
  element.Group_UnLock.Img_Icon:SetSprite(homeInfo.quickIconPath)
  element.Group_Lock.Img_Icon:SetSprite(homeInfo.quickIconPath)
  element.Group_UnLock.Txt_Name:SetText(homeInfo.name)
  element.Group_Lock.Txt_Name:SetText(homeInfo.name)
  local progress = DataModel.GetBattleStationProgressById(info.id) or 0
  element.Group_UnLock.Group_Not.Txt_Num:SetText(string.format(GetText(80611108), progress))
  if 100 <= progress then
    element.Group_UnLock.Group_Not:SetActive(false)
    element.Group_UnLock.Group_Complete:SetActive(true)
  else
    element.Group_UnLock.Group_Not:SetActive(true)
    element.Group_UnLock.Group_Complete:SetActive(false)
  end
  if elementIndex == DataModel.curSelectIndex then
    element.Group_On:SetActive(true)
  else
    element.Group_On:SetActive(false)
  end
  element.Btn_:SetClickFunction(function()
    Controller.OnBattleElementBtnClick(elementIndex, true)
  end)
end

function Controller.OnBattleElementBtnClick(elementIndex, isResetIndex)
  local battleStationList = DataModel.battleStationList
  if battleStationList and battleStationList[elementIndex] then
    DataModel.BuildingId = battleStationList[elementIndex].id
  end
  if not DataModel.BuildingId then
    return
  end
  local isBalletUnlock = DataModel.GetBattleStationIsUnlock(DataModel.BuildingId)
  if not isBalletUnlock then
    return
  end
  View.Group_Battle.Group_Battle:SetActive(true)
  DataModel.curSelectIndex = elementIndex
  DataModel.curBattleSelectIndex = elementIndex
  View.Group_Battle.ScrollGrid_Tab.grid.self:RefreshAllElement()
  if isResetIndex then
    DataModel.curBattleIndex = 0
  end
  Battle_Controller.OpenBattlePage(Controller.RefreshResource)
end

function Controller.RefreshResource(showType)
  View.Group_Ding:SetActive(true)
  local initConfig = PlayerData:GetFactoryData(99900007, "ConfigFactory")
  local maxEnergy = PlayerData:GetUserInfo().max_energy or initConfig.energyMax
  UIManager:LoadSplitPrefab(View, "UI/Home/HomeSafe/HomeSafe", "Group_Ding")
  View.Group_Ding.Btn_Energy.Txt_Num:SetText(DataModel.GetEnergy() .. "/" .. maxEnergy)
  View.Group_Ding.Group_LevelNum.self:SetActive(showType == 2)
  View.Group_Ding.Group_Tips.self:SetActive(showType == 2)
  View.Group_Ding.Group_ExpelTips.self:SetActive(showType == 1)
  if showType == 2 then
    local rewardLevels = XS_DataModel.curLeverReward or {}
    View.Group_Ding.Group_LevelNum.Txt_Num:SetText(#rewardLevels .. "/" .. XS_DataModel.GetCurRepInfo().offerAutoRefreshNum)
  end
end

function Controller.RefreshStationElementEnemyLvShow(element, isUnlock, elementIndex)
  if not element then
    return
  end
  element.Group_UnLock.Group_Lv:SetActive(isUnlock)
  if not isUnlock then
    return
  end
  local minLv, maxLv = Controller.GetStationEnemyShowLv(elementIndex)
  minLv = minLv or 0
  maxLv = maxLv or 0
  if minLv == 0 or maxLv == 0 then
    element.Group_UnLock.Group_Lv:SetActive(false)
    return
  end
  element.Group_UnLock.Group_Lv.Txt_LVs:SetText(string.format(GetText(80611861), minLv))
  element.Group_UnLock.Group_Lv.Txt_LVb:SetText(string.format(GetText(80611861), maxLv))
end

function Controller.GetStationEnemyShowLv(stationIndex)
  local minLv = 0
  local maxLv = 0
  local build
  if DataModel.openType == 1 then
    local safeStationList = DataModel.GetAllSafeStationList()
    if safeStationList and safeStationList[stationIndex] then
      build = safeStationList[stationIndex].id
    end
    if not build then
      return minLv, maxLv
    end
    if DataModel.curSafeType == 1 then
      local levelInfo = DataModel.levels[build]
      if levelInfo then
        for i = 1, #levelInfo do
          local info = levelInfo[i]
          if info then
            local levelConfig = PlayerData:GetFactoryData(info.levelId, "LevelFactory")
            if levelConfig then
              local level = PlayerData:GetUserInfo().lv or 0
              if not levelConfig.isEnemyLvEquilsPlayer then
                level = levelConfig.recomGrade
              end
              if i == 1 then
                minLv = level
                maxLv = level
              else
                if level > maxLv then
                  maxLv = level
                end
                if level < minLv then
                  minLv = level
                end
              end
            end
          end
        end
      end
    elseif DataModel.curSafeType == 2 then
      local leverReward = XS_DataModel.rewardLevels[build]
      local xsIsUnlock = DataModel.GetXSTaskIsUnlock(build)
      if not xsIsUnlock then
        return minLv, maxLv
      end
      if leverReward then
        for i = 1, #leverReward do
          local data = leverReward[i]
          if data then
            local level = PlayerData:GetPlayerLevel()
            local levelCA = PlayerData:GetFactoryData(data.id, "LevelFactory")
            if levelCA and not levelCA.isEnemyLvEquilsPlayer then
              if data.recomGrade then
                level = data.recomGrade
              else
                level = levelCA.recomGrade
              end
            end
            if i == 1 then
              minLv = level
              maxLv = level
            else
              if level > maxLv then
                maxLv = level
              end
              if level < minLv then
                minLv = level
              end
            end
          end
        end
      end
    end
  elseif DataModel.openType == 2 then
    local battleStationList = DataModel.battleStationList
    if battleStationList and battleStationList[stationIndex] then
      build = battleStationList[stationIndex].id
    end
    if not build then
      return minLv, maxLv
    end
    local stationCA = PlayerData:GetFactoryData(build, "HomeStationFactory")
    if stationCA and stationCA.battleLevelList then
      local battleLevelList = stationCA.battleLevelList
      for i = 1, #battleLevelList do
        local ca = PlayerData:GetFactoryData(battleLevelList[i].id)
        if DataManager:GetFactoryNameById(tonumber(ca.id)) == "AbyssFactory" then
          ca = PlayerData:GetFactoryData(ca.levelList[#ca.levelList].id)
        end
        if ca then
          local level = PlayerData:GetUserInfo().lv
          if not ca.isEnemyLvEquilsPlayer then
            level = ca.recomGrade
          end
          if i == 1 then
            minLv = level
            maxLv = level
          else
            if level > maxLv then
              maxLv = level
            end
            if level < minLv then
              minLv = level
            end
          end
        end
      end
    end
  end
  return minLv, maxLv
end

function Controller.OnRewardBtnClick()
  Net:SendProto("building.level", function(json)
    if string.nilorempty(json.rc) then
      PlayerData.ServerData.security_levels = json.special_level.security_levels
      UIManager:Open("UI/Home/HomeSafe/ScheduleReward/ScheduleReward")
    end
  end, nil)
end

return Controller
