local View = require("UIBlackLevel/UIBlackLevelView")
local DataModel = require("UIBlackLevel/UIBlackLevelDataModel")
local Controller = {}

function Controller:Init(id)
  DataModel:Init(id)
  View.ScrollView_Map.Viewport.Group_BG.self:SetLocalPosition(Vector3(0, 0, 0))
  View.Group_SpLevelDetails.self:SetActive(false)
  View.ScrollView_Map.Viewport.Group_BG.StaticGrid_List.grid.self:RefreshAllElement()
end

function Controller:OpenRightPage(index)
  local data = DataModel.blackLevelList[index]
  local lastIndex = DataModel.openIndex
  DataModel.openIndex = index
  if index ~= lastIndex then
    View.ScrollView_Map.Viewport.Group_BG.StaticGrid_List.grid.self:RefreshAllElement()
  end
  View.Group_SpLevelDetails.self:SetActive(true)
  local levelData = PlayerData:GetFactoryData(data.id)
  DataModel.chooseLevelData = levelData
  View.Group_SpLevelDetails.Img_Icon:SetSprite(data.icon)
  View.Group_SpLevelDetails.Txt_LevelName:SetText(levelData.levelName)
  View.Group_SpLevelDetails.Txt_Grade:SetText(string.format(GetText(80609989), levelData.recomGrade))
  View.Group_SpLevelDetails.ScrollView_Describe.Viewport.Txt_Describe:SetText(levelData.description)
  DataModel:SetDropList(levelData)
  if table.count(DataModel.dropList) ~= 0 then
    View.Group_SpLevelDetails.ScrollGrid_Reward.self:SetActive(true)
    View.Group_SpLevelDetails.ScrollGrid_Reward.grid.self:SetDataCount(table.count(DataModel.dropList))
    View.Group_SpLevelDetails.ScrollGrid_Reward.grid.self:RefreshAllElement()
    View.Group_SpLevelDetails.ScrollGrid_Reward.grid.self:MoveToTop()
  else
    View.Group_SpLevelDetails.ScrollGrid_Reward.self:SetActive(false)
  end
  View.Group_SpLevelDetails.Group_Ding.Btn_Energy.Txt_Num:SetText(DataModel.GetEnergy() .. "/" .. DataModel.maxEnergy)
  View.Group_SpLevelDetails.Btn_Fight.Img_Cost.Txt_Cost:SetText(levelData.energyEnd)
  View.Group_SpLevelDetails.Group_Skip.Btn_Skip.Group_Cost.Txt_Num:SetText("-" .. levelData.energyEnd)
  View.Group_SpLevelDetails.Group_Skip.Btn_Fight.Img_Cost.Txt_Cost:SetText(levelData.energyEnd)
  DataModel.blackLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
  if DataModel.blackLevelAutoBattle then
    Controller:RefreshRemainTime()
  end
  Controller:RefreshAutoBtn(DataModel.blackLevelAutoBattle)
  local isPass = PlayerData:GetLevelPassBySelf(data.id)
  View.Group_SpLevelDetails.Btn_Fight:SetActive(isPass == false)
  View.Group_SpLevelDetails.Group_Skip.self:SetActive(isPass == true)
end

function Controller:RefreshRemainTime()
  if DataModel.blackLevelAutoBattleTime <= 0 then
    DataModel.blackLevelAutoBattle = false
    DataModel.blackLevelAutoBattleTime = DataModel.constAutoBattleTime
    PlayerData.SquadsTempData = nil
    Controller:TryBattle(true)
    return
  end
  View.Group_SpLevelDetails.Group_Auto.Txt_Time:SetText(string.format(GetText(80607112), math.ceil(DataModel.blackLevelAutoBattleTime)))
end

function Controller:RefreshAutoBtn(isAuto)
  DataModel.blackLevelAutoBattle = isAuto
  PlayerData.TempCache.MonsterLevelAutoBattle = DataModel.blackLevelAutoBattle
  View.Group_SpLevelDetails.Group_Auto.Btn_Auto.Group_Off.self:SetActive(not DataModel.blackLevelAutoBattle)
  View.Group_SpLevelDetails.Group_Auto.Btn_Auto.Group_On.self:SetActive(DataModel.blackLevelAutoBattle)
  View.Group_SpLevelDetails.Group_Auto.Txt_Time:SetActive(DataModel.blackLevelAutoBattle)
end

function Controller:ClickSkipWin()
  local info = DataModel.chooseLevelData
  local levelId = info.id
  local levelDifficulty = PlayerData:GetLevelDifficulty(levelId)
  if CommonTips.OpenBuyEnergyTips(levelId, nil, nil, nil, levelDifficulty) then
    PlayerData.TempCache.MonsterLevelAutoBattle = false
    DataModel.blackLevelAutoBattle = false
    Controller:RefreshAutoBtn(DataModel.blackLevelAutoBattle)
    return
  end
  if DataModel.blackLevelAutoBattle == true then
    Controller:RefreshAutoBtn(false)
  end
  
  local function doSquad()
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false,
      difficulty = levelDifficulty,
      isAutoBattle = false
    }
    local t = {}
    t.activityId = DataModel.activityCA.id
    t.index = DataModel.openIndex
    t.isBattleReturn = true
    status.extraUIParamData = t
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Activity/BlackTea/BlackLevel"
    UIManager:Open("UI/Common/BattleSkipTips", Json.encode(status))
  end
  
  doSquad()
end

function Controller:TryBattle(isAutoBattle)
  local info = DataModel.chooseLevelData
  local levelId = info.id
  local levelCA = info
  local levelDifficulty = PlayerData:GetLevelDifficulty(levelId)
  
  local function doSquad()
    if CommonTips.OpenBuyEnergyTips(levelId, nil, nil, nil, levelDifficulty) then
      PlayerData.TempCache.MonsterLevelAutoBattle = false
      DataModel.blackLevelAutoBattle = false
      Controller:RefreshAutoBtn(DataModel.blackLevelAutoBattle)
      return
    end
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false,
      difficulty = levelDifficulty,
      isAutoBattle = isAutoBattle
    }
    local t = {}
    t.activityId = DataModel.activityCA.id
    t.index = DataModel.openIndex
    t.isBattleReturn = true
    status.extraUIParamData = t
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Activity/BlackTea/BlackLevel"
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end
  
  if not levelCA.isEnemyLvEquilsPlayer and levelCA.recomGrade + levelCA.extraLevelOffset * (levelDifficulty - 1) - PlayerData:GetPlayerLevel() >= 5 then
    local checkTipParam = {}
    checkTipParam.isCheckTip = true
    checkTipParam.checkTipKey = "BlackLevelTip"
    checkTipParam.checkTipType = 1
    checkTipParam.showDanger = true
    checkTipParam.showSafe = true
    CommonTips.OnPrompt(80601227, nil, nil, doSquad, nil, nil, nil, nil, checkTipParam)
  else
    doSquad()
  end
end

function Controller:OnClickBtnAuto()
  local info = DataModel.chooseLevelData
  local levelId = info.id
  local levelCA = info
  local levelData = PlayerData.ServerData.chapter_level[tostring(levelId)]
  if levelCA.limitNum > 0 and levelData ~= nil and levelData.challenge_times ~= nil and levelData.challenge_times >= levelCA.limitNum then
    CommonTips.OpenTips(80607474)
    return
  end
  if not DataModel.blackLevelAutoBattle and CommonTips.OpenBuyEnergyTips(levelId, nil, nil, nil, nil, true) then
    CommonTips.OpenTips(80607116)
    return
  end
  DataModel.blackLevelAutoBattleTime = DataModel.constAutoBattleTime
  Controller:RefreshRemainTime()
  Controller:RefreshAutoBtn(not DataModel.blackLevelAutoBattle)
end

function Controller:CloseChoose()
  View.Group_SpLevelDetails.self:SetActive(false)
  DataModel.openIndex = nil
  DataModel.blackLevelAutoBattle = false
  PlayerData.TempCache.MonsterLevelAutoBattle = false
  View.ScrollView_Map.Viewport.Group_BG.StaticGrid_List.grid.self:RefreshAllElement()
end

return Controller
