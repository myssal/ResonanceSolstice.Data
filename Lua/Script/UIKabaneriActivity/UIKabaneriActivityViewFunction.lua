local View = require("UIKabaneriActivity/UIKabaneriActivityView")
local DataModel = require("UIKabaneriActivity/UIKabaneriActivityDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = require("UIKabaneriActivity/UIKabaneriActivityController")
local ViewFunction = {
  KabaneriActivity_Group_NotJoin_Group_Add_Btn__Click = function(btn, str)
    if DataModel.isCanJoin == false then
      CommonTips.OpenTips(80602587)
      return
    end
    if TimeUtil:IsActive(DataModel.startTime, DataModel.endTime) == false and not DataModel.continue then
      return
    end
    local levelId = DataModel.levelId
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false
    }
    local cfg = PlayerData:GetFactoryData(20101355)
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Activity/ActivityMain"
    PlayerData.Last_Chapter_Parms = {
      id = DataModel.activityId
    }
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end,
  KabaneriActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardPreviewList[elementIndex]
    CommonItem:SetActivityPreviewItem(element.Group_Item, data)
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  KabaneriActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local id = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(id)
  end,
  KabaneriActivity_Group_Join_Group_Quest_Btn__Click = function(btn, str)
    local parms = {}
    parms.activityId = DataModel.activityId
    UIManager:Open("UI/Activity/Kabaneri/KabaneriMission", Json.encode(parms))
  end,
  KabaneriActivity_Group_Join_Group_Store_Btn__Click = function(btn, str)
    local parms = {}
    parms.activityId = DataModel.activityId
    parms.shopId = DataModel.shopId
    Net:SendProto("shop.info", function(json)
      UIManager:Open("UI/Activity/Kabaneri/KabaneriStore", Json.encode(parms))
    end)
  end,
  KabaneriActivity_Group_Join_Group_Card_Btn__Click = function(btn, str)
    UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({
      cardPackId = DataModel.cardPackId,
      activityName = DataModel.activityName
    }), function()
      Controller.RefreshCardInfo(DataModel.cardPackId)
      require("UIActivityMain/UIActivityMainView").Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
    end)
  end,
  KabaneriActivity_Group_Join_Group_Level_Btn__Click = function(btn, str)
    if not DataModel.levelQuestIsComplete then
      local questName = PlayerData:GetFactoryData(DataModel.levelQuestId).name
      CommonTips.OpenTips(string.format(GetText(80607102), questName))
      return
    end
    local firstOpened = PlayerData:GetPlayerPrefs("int", "KabaneriLevelFirstOpen") == 1
    if not firstOpened then
      UIManager:Open("UI/Activity/Kabaneri/Group_KabaneriLevelFirstOpen")
    else
      UIManager:Open("UI/Activity/Kabaneri/KabaneriLevel")
    end
  end,
  KabaneriActivity_Group_Join_Group_SkipKabaneri_Btn__Click = function(btn, str)
    if not DataModel.gameQuestIsComplete then
      local tips = DataModel.GetGameUnlockTips()
      CommonTips.OpenTips(tips)
      return
    end
    PlayerData.OpenKabSettlelemt(DataModel.activityId)
  end,
  KabaneriActivity_Group_Join_Group_Finish_Btn_Kabaneri_Click = function(btn, str)
  end,
  KabaneriActivity_Group_Join_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.helpId)
  end
}
return ViewFunction
