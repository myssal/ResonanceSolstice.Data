local View = require("UIActivityTrainBattle/UIActivityTrainBattleView")
local DataModel = require("UIActivityTrainBattle/UIActivityTrainBattleDataModel")
local Controller = require("UIActivityTrainBattle/UIActivityTrainBattleController")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  ActivityTrainBattle_Group_NotJoin_Group_Add_Btn__Click = function(btn, str)
    if DataModel.isCanJoin == false then
      CommonTips.OpenTips(80602587)
      return
    end
    if TimeUtil:IsActive(DataModel.startTime, DataModel.endTime) == false and not DataModel.continue then
      return
    end
    Controller.JoinActivity()
  end,
  ActivityTrainBattle_Group_NotJoin_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardPreviewList[elementIndex]
    CommonItem:SetActivityPreviewItem(element.Group_Item, data)
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  ActivityTrainBattle_Group_NotJoin_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local id = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(id)
  end,
  ActivityTrainBattle_Group_Join_Group_Quest_Btn__Click = function(btn, str)
    local parms = {}
    parms.activityId = DataModel.activityId
    UIManager:Open("UI/Activity/ActivityTrainBattle/ActivityTrainBattleMission", Json.encode(parms))
  end,
  ActivityTrainBattle_Group_Join_Group_Store_Btn__Click = function(btn, str)
    local activityCA = PlayerData:GetFactoryData(DataModel.activityId)
    UIManager:Open("UI/Home/HomeCapsule", Json.encode(activityCA.bannerCapsuleList))
  end,
  ActivityTrainBattle_Group_Join_Group_Card_Btn__Click = function(btn, str)
    UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({
      cardPackId = DataModel.cardPackId,
      activityName = DataModel.activityName
    }), function()
      Controller.RefreshCardInfo(DataModel.cardPackId)
      require("UIActivityMain/UIActivityMainView").Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
    end)
  end,
  ActivityTrainBattle_Group_Join_Group_Level_Btn__Click = function(btn, str)
    PlayerData.OpenKabSettlelemt(DataModel.activityId, nil, "UI/TrainBattle/TrainBattleSettlement")
  end,
  ActivityTrainBattle_Group_Join_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.helpId)
  end,
  ActivityTrainBattle_Group_Join_Group_SkipKabaneri_Btn__Click = function(btn, str)
  end
}
return ViewFunction
