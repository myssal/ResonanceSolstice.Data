local MainController = require("UIHomeSafe/UIHomeSafeController")
local MainDataModel = require("UIHomeSafe/UIHomeSafeDataModel")
local DataModel = require("UIHomeSafe/UIRewardDataModel")
local View = require("UIHomeSafe/UIHomeSafeView")
local Controller = {}
local FastBattleDataModel = require("UIFastBattle/UIFastBattleDataModel")

function Controller:ClickShowRewardPanel(isRefresh)
  Net:SendProto("building.level", function(json)
    DataModel.CurSelectIdx = 0
    DataModel.InitRewardLevels(json.special_level.reward_level)
    Controller:ShowRewardPanel()
    MainController:RefreshResource(2)
    if not isRefresh then
      MainController:ShowNPCTalk(MainDataModel.NPCDialogEnum.enterOfferText)
    end
  end, MainDataModel.BuildingId)
end

function Controller:RefreshEmptyTimeTxt(remainTime)
  local t = TimeUtil:SecondToTable(remainTime)
  View.Group_XS.Group_Empty.Txt_Time:SetText(string.format("%02d:%02d:%02d", t.hour, t.minute, t.second))
end

function Controller:ShowRewardPanel()
  View.Group_Main.self:SetActive(false)
  View.Group_Zhu.self:SetActive(true)
  UIManager:LoadSplitPrefab(View, "UI/Home/HomeSafe/HomeSafe", "Group_Ding")
  View.Group_Ding.self:SetActive(true)
  UIManager:LoadSplitPrefab(View, "UI/Home/HomeSafe/HomeSafe", "Group_XS")
  if not View.Group_XS.self.IsActive then
    View.self:PlayAnim("XSList")
  end
  View.Group_XS.self:SetActive(true)
  View.Group_XS.Group_Tips.self:SetActive(false)
  local count = #DataModel.rewardLevels
  View.Group_XS.Group_Right.self:SetActive(true)
  View.Group_XS.Group_Right.ScrollGrid_Right.grid.self:MoveToTop()
  View.Group_XS.Group_Right.ScrollGrid_Right.grid.self:SetDataCount(count + 1)
  View.Group_XS.Group_Right.ScrollGrid_Right.grid.self:RefreshAllElement()
  Controller:RefreshLeftShow(1)
end

function Controller:RefreshLeftShow(defaultSelectIdx)
  local count = #DataModel.rewardLevels
  local ShowEmpty = count == 0
  View.Group_XS.Group_Empty.self:SetActive(ShowEmpty)
  View.Group_XS.Group_Information.self:SetActive(not ShowEmpty)
  if ShowEmpty then
    View.Group_XS.Group_Empty.Txt_Num:SetText(DataModel.CurRepInfo.offerAutoRefreshNum)
  elseif 0 < defaultSelectIdx then
    if defaultSelectIdx > count then
      defaultSelectIdx = count
    end
    Controller:SelectIdx(defaultSelectIdx, true)
  end
end

function Controller:RefreshRightElement(element, idx)
  local data = DataModel.rewardLevels[idx]
  local isHave = data ~= nil
  element.Group_Level.self:SetActive(isHave)
  element.Group_Add.self:SetActive(not isHave)
  if isHave then
    element.Group_Level.Btn_:SetClickParam(idx)
    local isSelected = idx == DataModel.CurSelectIdx
    local levelCA = PlayerData:GetFactoryData(data.id, "LevelFactory")
    local isNormal = levelCA.levelBgType == "Normal"
    element.Group_Level.Group_Off.self:SetActive(not isSelected)
    element.Group_Level.Group_On.self:SetActive(isSelected)
    if not isSelected then
      element.Group_Level.Group_Off.Img_Normal:SetActive(isNormal)
      element.Group_Level.Group_Off.Img_Hua:SetActive(not isNormal)
      element.Group_Level.Group_Off.Txt_Name:SetText(levelCA.levelName)
    else
      element.Group_Level.Group_On.Img_Normal:SetActive(isNormal)
      element.Group_Level.Group_On.Img_Hua:SetActive(not isNormal)
      element.Group_Level.Group_On.Txt_Name:SetText(levelCA.levelName)
    end
  else
    element.Group_Add.Btn_:SetClickParam(idx)
  end
end

function Controller:SelectIdx(idx, force)
  if not force and DataModel.CurSelectIdx == idx then
    return
  end
  local data = DataModel.rewardLevels[idx]
  if data ~= nil then
    DataModel.CurSelectIdx = idx
    local levelCA = PlayerData:GetFactoryData(data.id, "LevelFactory")
    local isShowPrisonLogo = FastBattleDataModel.GetLevelIsShowPrisonLogo(data.id)
    print(levelCA.levelName .. " \230\152\175\229\144\166\230\152\190\231\164\186\231\155\145\231\139\177\229\155\190\230\160\135\239\188\154" .. tostring(isShowPrisonLogo))
    View.Group_XS.Group_Information.Img_Prisoner:SetActive(isShowPrisonLogo)
    local starInt = levelCA.levelStarInt + 1
    View.Group_XS.Group_Information.Img_Bg:SetSprite(string.format(DataModel.StarBgPath, levelCA.levelStar))
    View.Group_XS.Group_Information.Group_Enemy.Img_EnemyBg:SetSprite(string.format(DataModel.EnemyBgPath, levelCA.levelStar))
    local element = View.Group_XS.Group_Information.Group_Top.Group_1.Group_Star
    for i = 1, 5 do
      element["Img_Star" .. i]:SetActive(starInt >= i)
    end
    View.Group_XS.Group_Information.ScrollView_Describe.Viewport.Txt_Describe:SetText(levelCA.description)
    local unitCA = PlayerData:GetFactoryData(data.bossId, "UnitFactory")
    local unitViewCA = PlayerData:GetFactoryData(unitCA.viewId, "UnitViewFactory")
    element = View.Group_XS.Group_Information.Group_Enemy
    element.Img_Mask.Img_EnemyIcon:SetSprite(unitViewCA.face)
    element.Txt_Name:SetText(unitCA.name)
    element.ScrollView_Describe.Viewport.Txt_Describe:SetText(unitCA.safeInformation)
    DataModel.CurShowDrop = PlayerData:GetLevelDropList(levelCA)
    local count = #DataModel.CurShowDrop
    if count <= 6 then
      View.Group_XS.Group_Information.Group_Reward.ScrollGrid_Reward.self:SetEnable(false)
      View.Group_XS.Group_Information.Group_Reward.ScrollGrid_Reward.grid.self:SetStartCorner("Center")
    else
      View.Group_XS.Group_Information.Group_Reward.ScrollGrid_Reward.self:SetEnable(true)
      View.Group_XS.Group_Information.Group_Reward.ScrollGrid_Reward.grid.self:SetStartCorner("Left")
    end
    View.Group_XS.Group_Information.Group_Reward.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.CurShowDrop)
    View.Group_XS.Group_Information.Group_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
    local level = PlayerData:GetPlayerLevel()
    if not levelCA.isEnemyLvEquilsPlayer then
      if data.recomGrade then
        level = data.recomGrade
      else
        level = levelCA.recomGrade
      end
    end
    View.Group_XS.Group_Information.Img_Tuijian.Txt_Grade:SetText(level)
    View.Group_XS.Group_Information.Group_TZ.Txt_Cost:SetText(levelCA.energyEnd)
    View.Group_XS.Group_Information.Group_TZ.Btn_QW.self:SetClickParam(idx)
    View.Group_XS.Group_Right.ScrollGrid_Right.grid.self:RefreshAllElement()
  elseif 0 < idx then
    Controller:AddRewardLevel()
  end
end

function Controller:ClickBattle(str)
  if Controller:CheckTimeRefresh(true) then
    return
  end
  local data = DataModel.rewardLevels[tonumber(str)]
  local levelId = tonumber(data.id)
  local levelCA = PlayerData:GetFactoryData(levelId, "LevelFactory")
  
  local function detailDo()
    local res = CommonTips.OpenBuyEnergyTips(levelId, function()
      MainController:RefreshResource(1)
    end)
    if res then
      return
    end
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false
    }
    if data.recomGrade then
      status.enemyLevel = data.recomGrade
    end
    status.serverIdx = data.serverIdx - 1
    PlayerData.TempCache.EventIndex = nil
    local t = {}
    t.buildingId = MainDataModel.BuildingId
    t.isCityMapIn = MainDataModel.IsCityMapIn
    t.autoShowLevel = 2
    t.npcId = MainDataModel.NpcId
    status.extraUIParamData = t
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Home/HomeSafe/HomeSafe"
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end
  
  if not levelCA.isEnemyLvEquilsPlayer and levelCA.recomGrade - PlayerData:GetPlayerLevel() >= 5 then
    local checkTipParam = {}
    checkTipParam.isCheckTip = true
    checkTipParam.checkTipKey = "HomeSafeLevelHardTip"
    checkTipParam.checkTipType = 1
    checkTipParam.showDanger = true
    CommonTips.OnPrompt(80601227, nil, nil, detailDo, nil, nil, nil, nil, checkTipParam)
  else
    detailDo()
  end
end

function Controller:AddRewardLevel()
  local buildingCA = PlayerData:GetFactoryData(MainDataModel.BuildingId, "BuildingFactory")
  if #buildingCA.offerQuestList == 0 then
    CommonTips.OpenTips(80601097)
    return
  end
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  if #DataModel.rewardLevels >= homeConfig.offerQuestMax then
    CommonTips.OpenTips(80601098)
    return
  end
  local info = homeConfig.moneyList[1]
  local itemCA = PlayerData:GetFactoryData(info.id, "ItemFactory")
  local param = {}
  local num = PlayerData:GetGoodsById(info.id).num or 0
  local remainNum = homeConfig.offerQuestMax - #DataModel.rewardLevels
  param.itemId = info.id
  param.itemNum = num
  param.useNum = info.num
  param.maxNum = num < remainNum and num or remainNum
  CommonTips.OnItemPromptBatch(string.format(GetText(80601014), itemCA.name), param, function()
    if param.itemNum < info.num * PlayerData.TempCache.ItemPromptBatchNum then
      CommonTips.OpenTips(80600488)
      return
    end
    local t = {}
    t[param.itemId] = info.num * PlayerData.TempCache.ItemPromptBatchNum
    Net:SendProto("building.reward_level", function(json)
      PlayerData:RefreshUseItems(t)
      DataModel.CurSelectIdx = 0
      DataModel.InitRewardLevels(json.reward_level)
      MainController:RefreshResource(2)
      Controller:ShowRewardPanel()
    end, MainDataModel.BuildingId, PlayerData.TempCache.ItemPromptBatchNum)
  end)
end

function Controller:DeleteRewardLevel()
  if Controller:CheckTimeRefresh(true) then
    return
  end
  if DataModel.CurSelectIdx <= 0 or DataModel.CurSelectIdx > #DataModel.rewardLevels then
    return
  end
  
  local function detailDo()
    local info = DataModel.rewardLevels[DataModel.CurSelectIdx]
    Net:SendProto("building.remove_level", function(json)
      DataModel.InitRewardLevels(json.reward_level)
      local count = #DataModel.rewardLevels
      View.Group_XS.Group_Right.self:SetActive(true)
      View.Group_XS.Group_Right.ScrollGrid_Right.grid.self:SetDataCount(count + 1)
      View.Group_XS.Group_Right.ScrollGrid_Right.grid.self:RefreshAllElement()
      Controller:RefreshLeftShow(DataModel.CurSelectIdx)
      MainController:RefreshResource(2)
    end, MainDataModel.BuildingId, info.serverIdx - 1)
  end
  
  local checkTipParam = {}
  checkTipParam.isCheckTip = true
  checkTipParam.checkTipKey = "DeleteRewardLevelTip"
  checkTipParam.checkTipType = 1
  CommonTips.OnPrompt(80607573, nil, nil, detailDo, nil, nil, nil, nil, checkTipParam)
end

function Controller:CheckTimeRefresh(isShowTip)
  local defaultConfig = PlayerData:GetFactoryData(99900001, "ConfigFactory")
  local h = tonumber(string.sub(defaultConfig.dailyRefreshTime, 1, 2))
  local m = tonumber(string.sub(defaultConfig.dailyRefreshTime, 4, 5))
  local s = tonumber(string.sub(defaultConfig.dailyRefreshTime, 7, 8))
  if PlayerData.TempCache.rewardLevelRefresh == nil then
    PlayerData.TempCache.rewardLevelRefresh = PlayerData.ServerData.login_time
  end
  local targetTime = TimeUtil:GetNextSpecialTimeStamp(h, m, s, PlayerData.TempCache.rewardLevelRefresh)
  if targetTime <= TimeUtil:GetServerTimeStamp() then
    PlayerData.TempCache.rewardLevelRefresh = TimeUtil:GetServerTimeStamp()
    Controller:ClickShowRewardPanel(true)
    if isShowTip then
      CommonTips.OpenTips(80607574)
    end
    return true
  end
  return false
end

return Controller
