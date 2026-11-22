local View = require("UIMonsterActivity/UIMonsterActivityView")
local DataModel = require("UIMonsterActivity/UIMonsterActivityDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = require("UIMonsterActivity/UIMonsterActivityController")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local ViewFunction = {
  MonsterActivity_Group_NotJoin_Group_Add_Btn__Click = function(btn, str)
    if DataModel.isCanJoin == false then
      CommonTips.OpenTips(80602587)
      return
    end
    if TimeUtil:IsActive(DataModel.startTime, DataModel.endTime) == false and not DataModel.continue then
      return
    end
    UIManager:Open("UI/Dialog/Dialog", Json.encode({
      id = DataModel.plotId
    }), Controller.JoinActivity, Controller.JoinActivity)
  end,
  MonsterActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardPreviewList[elementIndex]
    CommonItem:SetActivityPreviewItem(element.Group_Item, data)
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  MonsterActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local id = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(id)
  end,
  MonsterActivity_Group_Join_Group_Quest_Btn__Click = function(btn, str)
    local parms = {}
    parms.activityId = DataModel.activityId
    if DataModel.activityId == 86000009 then
      UIManager:Open("UI/Activity/Monster/ActivityMission", Json.encode(parms))
    else
      UIManager:Open("UI/Activity/Hotel/ActivityMission", Json.encode(parms))
    end
  end,
  MonsterActivity_Group_Join_Group_Store_Btn__Click = function(btn, str)
    local parms = {}
    parms.activityId = DataModel.activityId
    parms.shopId = DataModel.shopId
    Net:SendProto("shop.info", function(json)
      UIManager:Open("UI/Activity/Monster/MonsterStore", Json.encode(parms))
    end)
  end,
  MonsterActivity_Group_Join_Group_Card_Btn__Click = function(btn, str)
    UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({
      cardPackId = DataModel.cardPackId,
      activityName = DataModel.activityName
    }), function()
      Controller.RefreshCardInfo(DataModel.cardPackId)
      require("UIActivityMain/UIActivityMainView").Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
    end)
  end,
  MonsterActivity_Group_Join_Group_Skip_Btn__Click = function(btn, str)
    if DataModel.sideQuestIsComplete then
      CommonTips.OpenTips(80607101)
      return
    end
    ActivityMainController:SkipStation(DataModel.SkipStationId)
  end,
  MonsterActivity_Group_Join_Group_Level_Btn__Click = function(btn, str)
    if not DataModel.levelQuestIsComplete then
      local questName = PlayerData:GetFactoryData(DataModel.levelQuestId).name
      CommonTips.OpenTips(string.format(GetText(80607102), questName))
      return
    end
    UIManager:Open("UI/Activity/Monster/MonsterLevel")
  end,
  MonsterActivity_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.helpId)
  end
}
return ViewFunction
