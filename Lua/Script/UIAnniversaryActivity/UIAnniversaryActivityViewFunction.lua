local View = require("UIAnniversaryActivity/UIAnniversaryActivityView")
local DataModel = require("UIAnniversaryActivity/UIAnniversaryActivityDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = require("UIAnniversaryActivity/UIAnniversaryActivityController")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local ViewFunction = {
  AnniversaryActivity_Group_NotJoin_Group_Add_Btn__Click = function(btn, str)
    local isOpen = PlayerData:GetPlayerLevel() >= DataModel.openLv
    if not isOpen then
      CommonTips.OpenTips(80611097)
      return
    end
    if DataModel.isCanJoin == false then
      CommonTips.OpenTips(80602587)
      return
    end
    if TimeUtil:IsActive(DataModel.startTime, DataModel.endTime) == false and not DataModel.continue then
      return
    end
    Controller.JoinActivity()
  end,
  AnniversaryActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local data = DataModel.rewardPreviewList[elementIndex]
    CommonItem:SetActivityPreviewItem(element.Group_Item, data)
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  AnniversaryActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local id = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(id)
  end,
  AnniversaryActivity_Group_Join_Group_Quest_Btn__Click = function(btn, str)
    local parms = {}
    parms.activityId = DataModel.activityId
    UIManager:Open("UI/Activity/Anniversary/AnniversaryMission", Json.encode(parms))
  end,
  AnniversaryActivity_Group_Join_Group_Store_Btn__Click = function(btn, str)
    local parms = {}
    parms.activityId = DataModel.activityId
    parms.shopId = DataModel.shopId
    Net:SendProto("shop.info", function(json)
      UIManager:Open("UI/Activity/Anniversary/AnniversaryStore", Json.encode(parms))
    end)
  end,
  AnniversaryActivity_Group_Join_Group_Card_Btn__Click = function(btn, str)
    UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({
      cardPackId = DataModel.cardPackId,
      activityName = DataModel.activityName
    }), function()
      Controller.RefreshCardInfo(DataModel.cardPackId)
      require("UIActivityMain/UIActivityMainView").Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
    end)
  end,
  AnniversaryActivity_Group_Join_Group_Skip_Btn__Click = function(btn, str)
    if DataModel.sideQuestIsComplete then
      CommonTips.OpenTips(80607101)
      return
    end
    ActivityMainController:SkipStation(DataModel.SkipStationId)
  end,
  AnniversaryActivity_Group_Join_Group_Level_Btn__Click = function(btn, str)
    if not DataModel.levelQuestIsComplete then
      local questName = PlayerData:GetFactoryData(DataModel.levelQuestId).name
      CommonTips.OpenTips(string.format(GetText(80607102), questName))
      return
    end
    UIManager:Open("UI/Activity/Anniversary/AnniversaryLevel")
  end,
  AnniversaryActivity_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.helpId)
  end
}
return ViewFunction
