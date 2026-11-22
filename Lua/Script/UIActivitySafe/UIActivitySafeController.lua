local View = require("UIActivitySafe/UIActivitySafeView")
local DataModel = require("UIActivitySafe/UIActivitySafeDataModel")
local NPCDialog = require("Common/NPCDialog")
local FastBattle_DataModel = require("UIFastBattle/UIFastBattleDataModel")
local XS_DataModel = require("UIFastBattle/UIFastBattleXSDataModel")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local Controller = {}

function Controller.Init()
  Controller.RefreshNPCPartShow()
  Controller.RefreshSafePartShow()
  Controller.RefreshBattlePartShow()
  Controller.RefreshRewardPartShow()
  if PlayerData:GetPlayerPrefs("int", "ActivitySafeRedDotState") == 0 then
    PlayerData:SetPlayerPrefs("int", "ActivitySafeRedDotState", 1)
    local timeTable = TimeUtil:GetLogicServerDayTable()
    if timeTable then
      PlayerData:SetPlayerPrefs("int", "LastFastBattleLoginDay", timeTable.day)
    end
  end
  if ActivityMainController then
    ActivityMainController:RefreshLeftRedState()
  end
  View.Group_Top.Btn_Entrust.Img_RedPoint:SetActive(PlayerData.IsEntrustShowRed())
end

function Controller.RefreshJoinState()
  local isJoin = FastBattle_DataModel.IsJoinedActivity()
  if not isJoin then
    Net:SendProto("main.participate", function(Jsons)
      if Jsons and string.nilorempty(Jsons.rc) then
        if Jsons.activity then
          PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)] = Jsons.activity
        end
        if ActivityMainController then
          ActivityMainController:RefreshLeftRedState()
        end
      end
    end, DataModel.activityId)
  end
end

function Controller.RefreshNPCPartShow()
  local ca = DataModel.GetActivityConfig()
  if not ca then
    return
  end
  local npcCa = PlayerData:GetFactoryData(ca.npcId, "NPCFactory")
  if npcCa then
    View.Group_NPC.Img_Name.Txt_Name:SetText(npcCa.name)
    View.Group_NPC.SpineAnimation_Character:SetData(npcCa.spineUrl, "")
    View.Group_NPC.SpineAnimation_Character:SetAnchoredPositionX(npcCa.spineOffsetX)
    View.Group_NPC.SpineAnimation_Character:SetAnchoredPositionY(npcCa.spineOffsetY)
    View.Group_NPC.SpineAnimation_Character:SetLocalScale(Vector3(1, 1, 1) * npcCa.spineScale)
    Controller.ShowNPCTalk(DataModel.NPCDialogEnum.enterText)
  end
end

function Controller.ShowNPCTalk(dialogEnum)
  local ca = DataModel.GetActivityConfig()
  if not ca then
    return
  end
  local npcConfig = PlayerData:GetFactoryData(ca.npcId, "NPCFactory")
  local textTable = npcConfig[dialogEnum]
  if textTable == nil then
    return
  end
  NPCDialog.SetNPCText(View.Group_NPC, textTable, dialogEnum)
end

function Controller.RefreshSafePartShow()
  local progress = DataModel.GetSafeProgressValue()
  View.Group_Safe.Group_UnLock.Group_Schedule.Txt_Num:SetText(string.format(GetText(80611108), progress))
  View.Group_Safe.Group_UnLock.Group_Tips1.Txt_Num:SetText(DataModel.GetSafetTips1Count())
  View.Group_Safe.Group_UnLock.Group_Tips2.Txt_Num:SetText(DataModel.GetSafetTips2Count())
  local isUnlock = DataModel.GetSafeIsUnlock()
  if isUnlock then
    View.Group_Safe.Group_Lock:SetActive(false)
    View.Group_Safe.Group_UnLock.Img_Go:SetActive(true)
  else
    View.Group_Safe.Group_Lock:SetActive(true)
    View.Group_Safe.Group_UnLock.Img_Go:SetActive(false)
    local quickCa = DataModel.GetQuickConfig()
    if quickCa then
      local questId = quickCa.safeLevelLimit
      local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
      View.Group_Safe.Group_Lock.Txt_Des:SetText(string.format(GetText(80611110), questCA.name))
    end
  end
end

function Controller.RefreshBattlePartShow()
  local progress = DataModel.GetBattleProgressValue()
  View.Group_Battle.Group_UnLock.Group_Schedule.Txt_Num:SetText(string.format(GetText(80611108), progress))
  View.Group_Battle.Group_UnLock.Group_Tips1.Txt_Num:SetText(DataModel.GetBattleTipsCount())
  local isUnlock = DataModel.GetBattleIsUnlock()
  if isUnlock then
    View.Group_Battle.Group_Lock:SetActive(false)
    View.Group_Battle.Group_UnLock.Img_Go:SetActive(true)
  else
    View.Group_Battle.Group_Lock:SetActive(true)
    View.Group_Battle.Group_UnLock.Img_Go:SetActive(false)
    local quickCa = DataModel.GetQuickConfig()
    if quickCa then
      local questId = quickCa.battleLevelLimit
      local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
      View.Group_Battle.Group_Lock.Txt_Des:SetText(string.format(GetText(80611110), questCA.name))
    end
  end
end

function Controller.RefreshRewardPartShow()
  local isUnlock = DataModel.GetSafeIsUnlock()
  if isUnlock then
    View.Group_Reward:SetActive(true)
  else
    View.Group_Reward:SetActive(false)
  end
  View.Group_Reward.Img_RedPoint:SetActive(FastBattle_DataModel.GetAllLeverRewardRedDotState())
end

function Controller.OnNPCBtnClick()
  local ca = DataModel.GetActivityConfig()
  if not ca then
    return
  end
  local npcCa = PlayerData:GetFactoryData(ca.npcId, "ActivityFactory")
  if npcCa then
    Controller.ShowNPCTalk(DataModel.NPCDialogEnum.talkText)
  end
end

function Controller.OnSafeBtnClick()
  local isUnlock = DataModel.GetSafeIsUnlock()
  if not isUnlock then
    return
  end
  Net:SendProto("building.level", function(json)
    PlayerData.ServerData.security_levels = json.special_level.security_levels
    FastBattle_DataModel.InitLevelData()
    XS_DataModel.InitRewardLevels(json.special_level.reward_level)
    local openParamTab = FastBattle_DataModel.GetPanelOpenCachedParams(1)
    local safeType = 1
    local selectSafeIndex = 1
    local levelIndex = 1
    local xsIndex = 1
    if openParamTab then
      selectSafeIndex = openParamTab.selectIndex or 1
      safeType = openParamTab.safeType or 1
      levelIndex = openParamTab.levelIndex or 1
      xsIndex = openParamTab.xsIndex or 1
    end
    UIManager:Open("UI/Activity/ActivitySafe/FastBattle", Json.encode({
      openType = 1,
      isMainActivityIn = true,
      curSafeType = safeType,
      curSelectIndex = selectSafeIndex,
      curLevelIndex = levelIndex,
      curXsIndex = xsIndex
    }))
  end, nil)
end

function Controller.OnBattleBtnClick()
  local isUnlock = DataModel.GetBattleIsUnlock()
  if not isUnlock then
    return
  end
  local openParamTab = FastBattle_DataModel.GetPanelOpenCachedParams(2)
  local selectBattleIndex = 1
  local battleIndex = 1
  if openParamTab then
    selectBattleIndex = openParamTab.selectIndex or 1
    battleIndex = openParamTab.battleIndex or 1
  end
  UIManager:Open("UI/Activity/ActivitySafe/FastBattle", Json.encode({
    openType = 2,
    isMainActivityIn = true,
    curSelectIndex = selectBattleIndex,
    curBattleIndex = battleIndex
  }))
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
