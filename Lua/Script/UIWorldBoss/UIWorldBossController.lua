local View = require("UIWorldBoss/UIWorldBossView")
local DataModel = require("UIWorldBoss/UIWorldBossDataModel")
local Controller = {}

function Controller.ShowPanel()
  View.Btn_Reward:SetSprite(GetResPath(88300307))
  Controller.RefreshBossItem()
end

function Controller.RefreshBossItem(onlyRefreshHp)
  DataModel.onlyRefreshStatus = onlyRefreshHp
  local netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
  View.Group_Times.Txt_Times:SetText(string.format(GetText(80611353), netData.times, DataModel.cfg.bossTimes))
  View.StaticGrid_Normal.grid.self:SetDataCount(#DataModel.cfg.bossNormalList)
  View.StaticGrid_Normal.grid.self:RefreshAllElement()
  View.StaticGrid_Final.grid.self:SetDataCount(#DataModel.cfg.bossFinalList)
  View.StaticGrid_Final.grid.self:RefreshAllElement()
  DataModel.onlyRefreshStatus = nil
  Controller.RefreshRedDot()
end

function Controller.RefreshRedDot()
  local data = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
  local hasReward = false
  for k, v in pairs(data.world_bosses) do
    local bossCfg = PlayerData:GetFactoryData(k)
    local maxRewardCount = #bossCfg.bossRewardList
    local canRecvCount = 0
    local curBossHpPercent = v.hp / bossCfg.bossHp
    for i = maxRewardCount, 1, -1 do
      if curBossHpPercent <= bossCfg.bossRewardList[i].ratio then
        canRecvCount = i
        break
      end
    end
    if canRecvCount > #data.boss[k].received then
      hasReward = true
      break
    end
  end
  View.Btn_Reward.Img_Red:SetActive(hasReward)
end

function Controller.SetBossItem(data, element)
  local bossId = tostring(data.id)
  local netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
  local isAlive = netData.world_bosses[bossId].hp > 0
  local isLocked = netData.world_bosses[bossId].status == 0 and isAlive
  if element.Group_Lock then
    element.Group_Lock:SetActive(isLocked)
  end
  element.Group_Win:SetActive(not isAlive)
  element.Btn_Boss:SetActive(not isLocked)
  local cfg = PlayerData:GetFactoryData(data.id)
  local completePlotId = tonumber(cfg.completePlotId) or 0
  element.Btn_Plot:SetActive(0 < completePlotId and not isAlive)
  element.Btn_Plot:SetClickParam(data.id)
  local plotBtnTextId = tonumber(cfg.plotBtnTextId) or 0
  element.Btn_Plot.Txt_T:SetText(0 < plotBtnTextId and GetText(plotBtnTextId) or "")
  local hasMiniGamePath = type(cfg.miniGamePath) == "string" and cfg.miniGamePath:find("%S") ~= nil
  element.Btn_MiniGame:SetActive(not isAlive and hasMiniGamePath)
  element.Btn_MiniGame:SetClickParam(data.id)
  local percent = netData.world_bosses[bossId].hp / cfg.bossHp
  element.Img_Bar:SetFilledImgAmount(percent)
  percent = math.floor(percent * 1000 + 0.5)
  local hpFormat = "%d"
  if 0 < percent % 10 then
    hpFormat = "%.1f"
  end
  element.Txt_Progress:SetText(string.format(hpFormat, percent * 0.1) .. "%")
  local spineColor = "#FFFFFF"
  if isLocked or not isAlive then
    spineColor = "#808080"
  end
  local CSpine = CS.FRef.getProperty(element.Spine_Boss, "_skeletonGraphic")
  if CSpine then
    local success, color = CS.UnityEngine.ColorUtility.TryParseHtmlString(spineColor)
    if success then
      CSpine.color = color
    end
  end
  if Controller.onlyRefreshStatus then
    return
  end
  element.Txt_Name:SetText(cfg.name)
  local viewCfg = PlayerData:GetFactoryData(cfg.bossViewId)
  element.Spine_Boss:SetData(viewCfg.resDir)
  element.Spine_Boss:SetAnchoredPosition(Vector2(cfg.bossSpineX, cfg.bossSpineY))
  element.Spine_Boss:SetLocalScale(cfg.bossSpineScaleX, cfg.bossSpineScaleY, 1)
  element.Btn_Detail:SetClickParam(data.id)
  element.Btn_Boss:SetClickParam(data.id)
end

function Controller.PlayBossPlot(id)
  if not id then
    return
  end
  local cfg = PlayerData:GetFactoryData(id)
  local plotId = cfg and tonumber(cfg.completePlotId) or 0
  if plotId <= 0 then
    return
  end
  local netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
  local bossData = netData and netData.world_bosses and netData.world_bosses[tostring(id)]
  if not (bossData and bossData.hp) or 0 < bossData.hp then
    return
  end
  UIManager:Open("UI/Dialog/Dialog", Json.encode({id = plotId}))
end

function Controller.OpenBossMiniGame(id)
  if not id then
    return
  end
  local cfg = PlayerData:GetFactoryData(id)
  local path = cfg and cfg.miniGamePath
  if type(path) ~= "string" or not path:find("%S") then
    return
  end
  local netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
  local bossData = netData and netData.world_bosses and netData.world_bosses[tostring(id)]
  if not (bossData and bossData.hp) or bossData.hp > 0 then
    return
  end
  UIManager:Open(path, Json.encode({
    activityId = DataModel.activityId,
    bossId = id
  }))
end

function Controller.OnBossBtnClick(id, tempView)
  local netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
  local bossId = tostring(id)
  local isAlive = netData.world_bosses[bossId].hp > 0
  local isLocked = netData.world_bosses[bossId].status == 0 and isAlive
  if isLocked then
    CommonTips.OpenTips(80611355)
    return
  end
  tempView:SetActive(true)
  local cfg = PlayerData:GetFactoryData(id)
  local percent = netData.world_bosses[bossId].hp / cfg.bossHp
  tempView.Img_Bar:SetFilledImgAmount(percent)
  percent = math.floor(percent * 1000 + 0.5)
  local hpFormat = "%d"
  if 0 < percent % 10 then
    hpFormat = "%.1f"
  end
  tempView.Txt_Progress:SetText(string.format(hpFormat, percent * 0.1) .. "%")
  tempView.Txt_hp:SetText(netData.world_bosses[bossId].hp .. "/" .. cfg.bossHp)
  tempView.Txt_Times:SetText(string.format(GetText(80611396), netData.times, DataModel.cfg.bossTimes))
  local curLevel = 1
  local levelCount = #cfg.levelList
  for i = levelCount, 1, -1 do
    local levelData = PlayerData.ServerData.chapter_level[tostring(cfg.levelList[i].id)]
    if levelData and levelData.progress and levelData.progress == 1 then
      curLevel = i + 1
      break
    end
  end
  curLevel = math.min(curLevel, levelCount)
  local viewCfg = PlayerData:GetFactoryData(cfg.bossViewId)
  tempView.Group_Boss.Spine_Boss:SetData(viewCfg.resDir)
  tempView.Group_Boss.Spine_Boss:SetAnchoredPosition(Vector2(cfg.spineX, cfg.spineY))
  tempView.Group_Boss.Spine_Boss:SetLocalScale(Vector3.one * cfg.spineScale)
  DataModel.curMaxLevel = math.max(curLevel, cfg.unLockLevel)
  DataModel.curBoss = bossId
  DataModel.curLevelList = cfg.levelList
  DataModel.curDiff = 1
  tempView.StaticGrid_Level.grid.self:SetDataCount(levelCount)
  tempView.StaticGrid_Level.grid.self:RefreshAllElement()
  DataModel.curDiff = nil
  tempView.Btn_Fight:SetBtnInteractable(true)
  Controller.SelectLevelDiff(tempView, curLevel)
end

function Controller.SetLevelItem(element, elementIndex)
  element.Btn_Level.Img_Selected:SetActive(elementIndex == DataModel.curDiff)
  if DataModel.onlyRefreshLevelSelect then
    return
  end
  element.Group_Lock:SetActive(elementIndex > DataModel.curMaxLevel)
  element.Btn_Level:SetActive(elementIndex <= DataModel.curMaxLevel)
  element.Btn_Level.Img_Bg:SetSprite("UI/Activity/ActivityWorldBoss/Images/d_" .. elementIndex)
  element.Btn_Level.Txt_Index:SetText(string.format(GetText(80611397), elementIndex))
  element.Group_Lock.Img_Lock:SetSprite("UI/Activity/ActivityWorldBoss/Images/d_" .. elementIndex)
  element.Group_Lock.Txt_Index:SetText(string.format(GetText(80611397), elementIndex))
  element.Btn_Level:SetClickParam(elementIndex)
  element.Btn_Level:SetBtnInteractable(true)
end

function Controller.SelectLevelDiff(tempView, elementIndex)
  if elementIndex > DataModel.curMaxLevel then
    return
  end
  if DataModel.curDiff == elementIndex then
    return
  end
  DataModel.curDiff = elementIndex
  DataModel.onlyRefreshLevelSelect = true
  tempView.StaticGrid_Level.grid.self:RefreshAllElement()
  DataModel.onlyRefreshLevelSelect = nil
  local data = DataModel.curLevelList[elementIndex]
  local cfg = PlayerData:GetFactoryData(data.id)
  tempView.Txt_Name:SetText(cfg.levelName)
  tempView.Txt_Des:SetText(cfg.description)
  tempView.Txt_Grade:SetText(string.format(GetText(80601531), cfg.recomGrade))
  tempView.Img_Bg5.Txt_T:SetText(string.format(GetText(80611399), data.bossHpReduce))
  tempView.Btn_Fight:SetClickParam(data.id)
  local equalList = cfg.equalList
  local stageList = cfg.stageList
  local allItem = {}
  for i, v in ipairs(equalList) do
    if v.id then
      allItem[v.id] = 1
    end
  end
  for _, v in ipairs(stageList) do
    if v.id then
      local cfg = PlayerData:GetFactoryData(v.id, "ListFactory")
      if cfg.leveldropList then
        for _, a in ipairs(cfg.leveldropList) do
          if a.id then
            allItem[a.id] = 2
          end
        end
      end
    end
  end
  DataModel.ChooseRewardList = {}
  for id, v in pairs(allItem) do
    local cfg = PlayerData:GetFactoryData(id)
    local quality = cfg.qualityInt == nil and 1 or cfg.qualityInt + 1
    table.insert(DataModel.ChooseRewardList, {
      type = v,
      id = id,
      quality = quality
    })
  end
  table.sort(DataModel.ChooseRewardList, function(a, b)
    if a.type == b.type then
      if a.quality == b.quality then
        return a.id < b.id
      else
        return a.quality > b.quality
      end
    end
    return a.type < b.type
  end)
  tempView.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.ChooseRewardList)
  tempView.ScrollGrid_Reward.grid.self:RefreshAllElement()
  tempView.ScrollGrid_Reward.grid.self:MoveToTop()
end

function Controller.GetReward(id)
  Net:SendProto("activity.recv_boss", function(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)].boss[tostring(id)].recv = 1
    Controller.ShowPanel()
  end, DataModel.activityId, id)
end

function Controller.TryStartBattle(id)
  local netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
  if netData.times <= 0 then
    if 0 >= netData.dailyBuy then
      CommonTips.OpenTips(80611356)
      return
    else
      UIManager:Open("UI/Activity/ActivityWorldBoss/WorldBossBuyTimes", Json.encode({
        activityId = DataModel.activityId,
        levelId = id
      }))
      return
    end
  end
  local status = {
    Current = "Chapter",
    squadIndex = PlayerData.BattleInfo.squadIndex
  }
  local t = {}
  t.activityId = DataModel.activityId
  t.refresh = true
  t.isBattleReturn = true
  status.extraUIParamData = t
  PlayerData.BattleInfo.battleStageId = id
  PlayerData.BattleCallBackPage = "UI/Activity/ActivityWorldBoss/WorldBoss"
  PlayerData.TempCache.tempWorldBossActivityId = tostring(DataModel.activityId)
  UIManager:Open("UI/Squads/Squads", Json.encode(status))
end

function Controller.RefreshPanel()
  Net:SendProto("activity.get_boss_info", function(json)
    PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)] = json.activity
    PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)].world_bosses = json.world_bosses
    Controller.RefreshBossItem(true)
  end, DataModel.activityId)
end

return Controller
