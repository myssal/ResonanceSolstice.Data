local DataModel = require("UIBulletTrainActivity/UIBulletTrainActivityDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = require("UIBulletTrainActivity/UIBulletTrainActivityController")
local ViewFunction = {
  BulletTrainActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardPreviewList[elementIndex]
    CommonItem:SetActivityPreviewItem(element.Group_Item, data)
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  BulletTrainActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local id = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(id)
  end,
  BulletTrainActivity_Group_NotJoin_Group_Add_Btn__Click = function(btn, str)
    if DataModel.isCanJoin == false then
      CommonTips.OpenTips(80602587)
      return
    end
    if TimeUtil:IsActive(DataModel.startTime, DataModel.endTime) == false and not DataModel.continue then
      return
    end
    if DataModel.plotId == -1 or DataModel.plotId == 0 or DataModel.plotId == nil then
      Controller.JoinActivity()
    else
      UIManager:Open("UI/Dialog/Dialog", Json.encode({
        id = DataModel.plotId
      }), function()
        Controller.JoinActivity()
      end, function()
        Controller.JoinActivity()
      end)
    end
  end,
  BulletTrainActivity_Group_Join_Group_Quest_Btn__Click = function(btn, str)
    local parms = {}
    parms.activityId = DataModel.activityId
    UIManager:Open("UI/Activity/BulletTrain/BulletTrainMission", Json.encode(parms))
  end,
  BulletTrainActivity_Group_Join_Group_Store_Btn__Click = function(btn, str)
    local parms = {}
    parms.activityId = DataModel.activityId
    parms.shopId = DataModel.shopId
    Net:SendProto("shop.info", function(json)
      UIManager:Open("UI/Activity/BulletTrain/BulletTrainStore", Json.encode(parms))
    end)
  end,
  BulletTrainActivity_Group_Join_Group_Card_Btn__Click = function(btn, str)
    UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({
      cardPackId = DataModel.cardPackId,
      activityName = DataModel.activityName
    }), function()
      Controller.RefreshCardInfo(DataModel.cardPackId)
      require("UIActivityMain/UIActivityMainView").Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
    end)
  end,
  BulletTrainActivity_Group_Join_Group_Skip_Btn__Click = function(btn, str)
    if DataModel.sideQuestIsComplete then
      CommonTips.OpenTips(80607101)
      return
    end
    UIManager:Open("UI/Quest/Quest", Json.encode({
      questId = DataModel.skipQuestId
    }))
  end,
  BulletTrainActivity_Group_Join_Group_Rank_Btn__Click = function(btn, str)
    local ca = PlayerData:GetFactoryData(DataModel.activityId)
    if not ca then
      return
    end
    local t = {}
    t.activityId = ca.signChallengeActivityId
    UIManager:Open("UI/Activity/ActivitySignBattle/ActivitySignBattleRanking", Json.encode(t))
  end,
  BulletTrainActivity_Group_Join_Group_Level_Group_Can_Btn__Click = function(btn, str)
    if not DataModel.levelQuestIsComplete then
      local questName = PlayerData:GetFactoryData(DataModel.levelQuestId).name
      CommonTips.OpenTips(string.format(GetText(80607102), questName))
      return
    end
    UIManager:Open("UI/Activity/BulletTrain/BulletTrainLevel")
  end,
  BulletTrainActivity_Group_Join_Group_Level_Group_Skin_Btn__Click = function(btn, str)
    if not DataModel.levelQuestIsComplete then
      local questName = PlayerData:GetFactoryData(DataModel.levelQuestId).name
      CommonTips.OpenTips(string.format(GetText(80607102), questName))
      return
    end
    local ca = PlayerData:GetFactoryData(DataModel.activityId)
    if not ca then
      return
    end
    if TimeUtil:IsActive(DataModel.startTime, DataModel.endTime) then
      local caBat = PlayerData:GetFactoryData(ca.signChallengeActivityId)
      if caBat and not string.nilorempty(caBat.signBattleUI) then
        UIManager:Open(caBat.signBattleUI, Json.encode({
          activityId = ca.signChallengeActivityId,
          mainActivityId = DataModel.activityId
        }))
      end
    end
  end,
  BulletTrainActivity_Group_Join_Group_Level_Group_SignBattle_Btn_SignBattle_Click = function(btn, str)
    if not DataModel.levelQuestIsComplete then
      local questName = PlayerData:GetFactoryData(DataModel.levelQuestId).name
      CommonTips.OpenTips(string.format(GetText(80607102), questName))
      return
    end
    local signBattleId = 86000244
    if TimeUtil:IsActive(DataModel.startTime, DataModel.endTime) then
      local caBat = PlayerData:GetFactoryData(signBattleId)
      if caBat and not string.nilorempty(caBat.signBattleUI) then
        UIManager:Open(caBat.signBattleUI, Json.encode({
          activityId = signBattleId,
          mainActivityId = DataModel.activityId
        }))
      end
    end
  end,
  BulletTrainActivity_Group_Join_Btn_Gacha_Click = function(btn, str)
    local ca = PlayerData:GetFactoryData(DataModel.activityId)
    local signBattleId = ca.signChallengeActivityId
    local signBattleCA = PlayerData:GetFactoryData(signBattleId)
    local t = {}
    t.poolId = signBattleCA.signBattleExtract
    UIManager:Open("UI/Gacha/GachaNew", Json.encode(t))
  end,
  BulletTrainActivity_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.helpId)
  end,
  BulletTrainActivity_Btn_Video_Click = function(btn, str)
    UIManager:Open("UI/Activity/ActivitySignBattle/SignBattleTipTistar")
  end
}
return ViewFunction
