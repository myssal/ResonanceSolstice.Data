local View = require("UIIsland_Battle/UIIsland_BattleView")
local DataModel = require("UIIsland_Battle/UIIsland_BattleDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init(data)
  DataModel.activityId = data.activityId
  DataModel.levelType = data.levelType or 1
  DataModel.activityCA = PlayerData:GetFactoryData(data.activityId)
  DataModel.backUI = data.backUI
  DataModel.isPlayGround = data.isPlayGround
  self.levelGrid = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level
  self:RefreshLevelList()
  if data.initIndex ~= nil and data.initIndex > 0 then
    Controller:RefreshAutoBtn(data.isAuto)
    local levelId = DataModel.levelIdList[data.initIndex]
    if PlayerData:GetLevelFirstRewardsReceived(levelId) and data.isCurLevelLocked == true then
      local imgWay = View.ScrollView_Select.Viewport.Content.Group_Select.Group_way["Img_way" .. data.initIndex]
      if imgWay and data.initIndex < #DataModel.levelIdList then
        DataModel.upDateLevelTime = 1
      end
    end
    self:OnClickLevel(data.initIndex)
  end
  View.Img_title:SetSprite(GetResPath(88300115))
end

function Controller:RefreshLevelList()
  self:CloseLevelDetail(true)
  DataModel.levelIdList = {}
  if DataModel.activityCA ~= nil then
    local levelListData = DataModel.activityCA.levelTypeList[DataModel.levelType]
    if levelListData ~= nil and levelListData.id ~= nil and levelListData.id > 0 then
      local levelListCA = PlayerData:GetFactoryData(levelListData.id)
      if levelListCA ~= nil and levelListCA.levelList ~= nil then
        for i = 1, #levelListCA.levelList do
          DataModel.levelIdList[#DataModel.levelIdList + 1] = levelListCA.levelList[i].id
        end
      end
    end
  end
  self.levelGrid.grid.self:SetDataCount(#DataModel.levelIdList)
  self.levelGrid.grid.self:RefreshAllElement()
end

function Controller:SetLevelGrid(element, elementIndex)
  local levelId = DataModel.levelIdList[elementIndex]
  if levelId == nil or levelId <= 0 then
    element.self:SetActive(false)
    return
  end
  local isUnlock = self:IsLevelUnlock(elementIndex)
  element.self:SetActive(isUnlock)
  local imgWay = View.ScrollView_Select.Viewport.Content.Group_Select.Group_way["Img_way" .. elementIndex - 1]
  if imgWay then
    imgWay:SetActive(isUnlock)
  end
  if not isUnlock then
    return
  end
  local isLevelSelect = DataModel.curLevelIndex == elementIndex
  element.self.transform:Find("UI_Island_Battle_003_Select").gameObject:SetActive(isLevelSelect)
  if isLevelSelect then
    element.self.transform:Find("UI_Island_Battle_003_Select"):GetComponent(typeof(CS.UnityEngine.ParticleSystem)):Play()
  end
  element.Btn_Select:SetClickParam(elementIndex)
  local levelCA = PlayerData:GetFactoryData(levelId)
  element.Img_Bg.Txt_Name:SetText(levelCA.levelName)
  if levelCA.levelIcon and levelCA.levelIcon ~= "" then
    element.Img_Bg:SetSprite(levelCA.levelIcon)
  end
  if 1 < elementIndex then
    local levelId = DataModel.levelIdList[elementIndex - 1]
    if PlayerData:GetLevelFirstRewardsReceived(levelId) and DataModel.isCurLevelLocked == true and isLevelSelect then
      View.ScrollView_Select.Viewport.Content.Group_Select.Group_way.gameObject:GetComponent(typeof(CS.UnityEngine.Animator)):Play("Img_way" .. elementIndex - 1)
      DataModel.isCurLevelLocked = false
      element.gameObject:GetComponent(typeof(CS.UnityEngine.Animator)):Play("StaticGrid_Level")
      element.self.transform:Find("UI_Island_Battle_004"):GetComponent(typeof(CS.UnityEngine.ParticleSystem)):Play()
    end
  end
end

function Controller:OnSelectLevel(index)
  if DataModel.curLevelIndex == index then
    return
  end
  DataModel.curLevelIndex = index
  self.levelGrid.grid.self:RefreshAllElement()
  local levelId = DataModel.levelIdList[DataModel.curLevelIndex]
  if PlayerData.TempCache.MonsterLevelAutoBattle == true and CommonTips.OpenBuyEnergyTips(levelId) then
    Controller:RefreshAutoBtn(false)
  end
  if not PlayerData:GetLevelPass(levelId) then
    Controller:RefreshAutoBtn(false)
  end
  DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
  self:AutoToPositioning(index)
end

function Controller:IsLevelUnlock(index)
  if index == 1 then
    return true
  end
  if DataModel.upDateLevelTime ~= nil and index == DataModel.curLevelIndex + 1 then
    return false
  end
  local levelId = DataModel.levelIdList[index - 1]
  return PlayerData:GetLevelFirstRewardsReceived(levelId)
end

function Controller:OnClickLevel(index)
  self:OnSelectLevel(index)
  Controller:OpenLevelDetail()
end

function Controller:OnClickReturn()
  if DataModel.isLevelDetailOpen then
    self:CloseLevelDetail()
  else
    UIManager:GoBack()
    if DataModel.backUI == "UI/Activity/ActivityMain" then
      UIManager:Open(DataModel.backUI, Json.encode({
        id = DataModel.activityId
      }))
    elseif DataModel.backUI == "UI/Playground/Playground" then
      local playgroundController = require("UIIslandActivity/IslandActivityController")
      local playgroundDataModel = require("UIIslandActivity/UIIslandActivityDataModel")
      if playgroundDataModel.ActivityCA == nil or next(playgroundDataModel.ActivityCA) == nil then
        playgroundDataModel.ActivityCA = DataModel.activityCA
      end
      playgroundController:OpenPlayground()
    end
  end
end

function Controller:CloseLevelDetail(isInit)
  DataModel.curLevelIndex = -1
  DataModel.isLevelDetailOpen = false
  View.Group_Right:SetActive(false)
  Controller:RefreshAutoBtn(false)
  DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
  if isInit ~= true then
    self.levelGrid.grid.self:RefreshAllElement()
  end
end

function Controller:OpenLevelDetail()
  if DataModel.isLevelDetailOpen ~= true then
    DataModel.isLevelDetailOpen = true
    View.Group_Right:SetActive(true)
  end
  self:UpdateEnergy()
  local levelId = DataModel.levelIdList[DataModel.curLevelIndex]
  local levelCA = PlayerData:GetFactoryData(levelId)
  if levelCA.levelIcon and levelCA.levelIcon ~= "" then
    View.Group_Right.Img_Icon:SetSprite(levelCA.levelIcon)
  end
  if levelCA.iconName and levelCA.iconName ~= "" then
    View.Group_Right.Img_Icon.Txt_Name:SetText(levelCA.iconName)
  end
  View.Group_Right.Group_Info.Txt_Name:SetText(levelCA.levelName)
  View.Group_Right.Group_Info.Txt_RecoLevel:SetText(string.format(GetText(80601819), levelCA.recomGrade))
  View.Group_Right.Group_Info.Txt_Text:SetActive(false)
  if levelCA.bossId ~= nil and levelCA.bossId > 0 then
    local bossCA = PlayerData:GetFactoryData(levelCA.bossId)
    if bossCA ~= nil then
      local campCA = PlayerData:GetFactoryData(bossCA.enemyCamp)
      if campCA then
        View.Group_Right.Group_Info.Txt_Text:SetActive(true)
        View.Group_Right.Group_Info.Txt_Text:SetText(campCA.sideName)
      end
    end
  end
  View.Group_Right.Group_Des.Txt_Desc:SetText(levelCA.description)
  local dropList = PlayerData:GetLevelDropList(levelCA)
  DataModel.dropList = dropList
  View.Group_Right.Group_Drop.ScrollGrid_Item.grid.self:SetDataCount(#dropList)
  View.Group_Right.Group_Drop.ScrollGrid_Item.grid.self:RefreshAllElement()
  View.Group_Right.Group_Drop.ScrollGrid_Item.grid.self:MoveToTop()
  View.Group_Right.Group_Fight.Btn_StartFight.Group_Energy.Txt_Cost:SetText("-" .. levelCA.energyStart + levelCA.energyEnd)
end

function Controller:OnSetRewardGrid(element, elementIndex)
  CommonItem:SetItem(element.Group_Item, DataModel.dropList[elementIndex])
end

function Controller:UpdateEnergy()
  local user_info = PlayerData:GetUserInfo()
  View.Group_Right.Btn_Energy.Txt_Num:SetText(user_info.energy .. "/" .. user_info.max_energy or 0)
end

function Controller:OpenEnergyBuy()
  local function callback()
    Controller:UpdateEnergy()
  end
  
  CommonTips.OpenEnergy(callback)
end

function Controller:TryBattle(isAutoBattle)
  local levelId = DataModel.levelIdList[DataModel.curLevelIndex]
  local levelCA = PlayerData:GetFactoryData(levelId)
  
  local function detailDo()
    local levelId = DataModel.levelIdList[DataModel.curLevelIndex]
    if CommonTips.OpenBuyEnergyTips(levelId) then
      return
    end
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false
    }
    local t = {}
    t.activityId = DataModel.activityId
    t.levelType = DataModel.levelType or 1
    t.initIndex = DataModel.curLevelIndex
    t.isAuto = isAutoBattle
    if DataModel.isPlayGround then
      t.backUI = "UI/Playground/Playground"
    else
      t.backUI = "UI/Activity/ActivityMain"
    end
    local levelId = DataModel.levelIdList[DataModel.curLevelIndex]
    if not PlayerData:GetLevelFirstRewardsReceived(levelId) then
      t.isCurLevelLocked = true
    end
    status.extraUIParamData = t
    status.isAutoBattle = isAutoBattle
    PlayerData.Last_Chapter_Parms = nil
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Island_Battle/Island_Battle"
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end
  
  if not isAutoBattle and not levelCA.isEnemyLvEquilsPlayer and levelCA.recomGrade - PlayerData:GetPlayerLevel() >= 5 then
    local checkTipParam = {}
    checkTipParam.isCheckTip = true
    checkTipParam.checkTipKey = "ActiveBuildLevelTip"
    checkTipParam.checkTipType = 1
    checkTipParam.showSafe = true
    CommonTips.OnPrompt(80601227, nil, nil, detailDo, nil, nil, nil, nil, checkTipParam)
  else
    detailDo()
  end
end

function Controller:OnClickBtnAuto()
  local levelId = DataModel.levelIdList[DataModel.curLevelIndex]
  if not PlayerData:GetLevelPass(levelId) then
    CommonTips.OpenTips(80607473)
    return
  end
  local levelCA = PlayerData:GetFactoryData(levelId)
  local levelData = PlayerData.ServerData.chapter_level[tostring(levelId)]
  if levelCA.limitNum > 0 and levelData ~= nil and levelData.challenge_times ~= nil and levelData.challenge_times >= levelCA.limitNum then
    CommonTips.OpenTips(80607474)
    return
  end
  if not PlayerData.TempCache.MonsterLevelAutoBattle and CommonTips.OpenBuyEnergyTips(levelId, nil, nil, nil, nil, true) then
    CommonTips.OpenTips(80607116)
    return
  end
  DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
  Controller:RefreshAutoBtn(not PlayerData.TempCache.MonsterLevelAutoBattle)
  self:RefreshRemainTime()
end

function Controller:RefreshAutoBtn(isAuto)
  PlayerData.TempCache.MonsterLevelAutoBattle = isAuto
  DataModel.monsterLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
  View.Group_Right.Group_Auto.Btn_Auto.Group_Off.self:SetActive(not DataModel.monsterLevelAutoBattle)
  View.Group_Right.Group_Auto.Btn_Auto.Group_On.self:SetActive(DataModel.monsterLevelAutoBattle)
  View.Group_Right.Group_Auto.Txt_Time:SetActive(DataModel.monsterLevelAutoBattle)
end

function Controller:RefreshRemainTime()
  if DataModel.remainAutoBattleTime <= 0 then
    DataModel.monsterLevelAutoBattle = false
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
    PlayerData.SquadsTempData = nil
    self:TryBattle(true)
    return
  end
  View.Group_Right.Group_Auto.Txt_Time:SetText(string.format(GetText(80607112), math.ceil(DataModel.remainAutoBattleTime)))
end

function Controller:AutoToPositioning(index)
  local parentWidth = View.ScrollView_Select.Viewport.Content.self.Rect.sizeDelta.x / 2
  local parentWidth2 = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.self.Rect.sizeDelta.x / 2
  local screenWidth = Screen.width / 5
  local pos = 0
  pos = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.grid.self:GetChildByIndex(index - 1)
  pos = pos.transform.localPosition
  local x = parentWidth - parentWidth2 - screenWidth - pos.x
  local content = View.ScrollView_Select.Viewport.Content.self
  DOTweenTools.Kill(content.transform)
  DOTweenTools.DOLocalMoveCallback(content.transform, x, -pos.y, 0, 0.5)
end

return Controller
