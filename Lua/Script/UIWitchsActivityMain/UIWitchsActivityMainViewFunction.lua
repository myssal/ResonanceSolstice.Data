local View = require("UIWitchsActivityMain/UIWitchsActivityMainView")
local DataModel = require("UIWitchsActivityMain/UIWitchsActivityMainDataModel")
local CommonItem = require("Common/BtnItem")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local ViewFunction = {
  WitchsActivityMain_Group_NotJoin_Group_Add_Btn__Click = function(btn, str)
    if not DataModel.IsMainQuestCompleted() then
      CommonTips.OpenTips(80602587)
      return
    end
    
    local function callBack()
      Net:SendProto("main.participate", function(json)
        if json.activity then
          PlayerData.ServerData.all_activities.ing[tostring(DataModel.ActivityId)] = json.activity
        end
        PlayerData.ConvertActivityItem(DataModel.ActivityId)
        DataModel.RefreshJoin()
      end, DataModel.ActivityId)
    end
    
    local joinPlotId = DataModel.ActivityCA.joinPlotId
    if not DataModel.IsActivityJoin() and joinPlotId and 0 < joinPlotId and joinPlotId ~= "" then
      UIManager:Open("UI/Dialog/Dialog", Json.encode({id = joinPlotId}), callBack, callBack)
    else
      callBack()
    end
  end,
  WitchsActivityMain_Group_NotJoin_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local data = DataModel.ActivityCA.rewardPreviewList[elementIndex]
    CommonItem:SetActivityPreviewItem(element.Group_Item, data)
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  WitchsActivityMain_Group_NotJoin_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local id = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(id)
  end,
  WitchsActivityMain_Group_Join_Group_Quest_Btn__Click = function(btn, str)
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Mission/WitcheslMission", DataModel.ActivityId), Json.encode({
      activityId = DataModel.ActivityId
    }))
  end,
  WitchsActivityMain_Group_Join_Group_Store_Btn__Click = function(btn, str)
    local activityCA = DataModel.ActivityCA
    UIManager:Open("UI/Home/HomeCapsule", Json.encode(activityCA.bannerCapsuleList))
  end,
  WitchsActivityMain_Group_Join_Group_Card_Btn__Click = function(btn, str)
    local activityCA = DataModel.ActivityCA
    UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({
      cardPackId = activityCA.activityCardPack,
      activityName = activityCA.name
    }), function()
      DataModel.RefreshCard(activityCA.activityCardPack)
      require("UIActivityMain/UIActivityMainView").Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
    end)
  end,
  WitchsActivityMain_Group_Join_Group_Skip_Btn__Click = function(btn, str)
    if DataModel.IsSkipQuestCompleted() then
      CommonTips.OpenTips(80607101)
      return
    end
    ActivityMainController:SkipStation(DataModel.ActivityCA.skipStationStart)
  end,
  WitchsActivityMain_Group_Join_Group_Level_Group_Can_Group_Ticket_Btn_Buy_Click = function(btn, str)
    local dayRemainBuyNum = WitchData.GetDayRemainTicketBuyNum(DataModel.ActivityId)
    if dayRemainBuyNum == 0 then
      CommonTips.OpenTips(80610279)
      return
    end
    UIManager:Open(WitchData.GetUIPath("UI/Witches/ActivityMain/TicketTips", DataModel.ActivityId), Json.encode({
      activityId = DataModel.ActivityId
    }))
  end,
  WitchsActivityMain_Group_Join_Group_Level_Btn__Click = function(btn, str)
    DataModel.OpenWitchScene()
  end,
  WitchsActivityMain_Group_Join_Group_Rank_Btn__Click = function(btn, str)
    local WitchRankDataModel = require("UIWitchesRanking/UIWitchesRankingDataModel")
    local rankId = WitchRankDataModel.RankForeverId
    local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
    local levelTween = WitchData.GetSelfLevelTween(rankId)
    Net:SendProto("main.roll_rank", function(json)
      WitchRankDataModel.RefreshServerRankData(json)
      WitchRankDataModel.RefreshServerRankCacheInfo(json)
      WitchRankDataModel.RefreshSeverRankShowLimitNum(json.has_more)
      UIManager:Open(WitchData.GetUIPath("UI/Witches/Ranking/WitchesRanking", DataModel.ActivityId), Json.encode({
        tab = 2,
        activityId = DataModel.ActivityId
      }))
    end, rankCA.rankType, rankCA.timeType, levelTween, rankCA.peopleNum, nil, nil, nil, nil, DataModel.ActivityId)
  end,
  WitchsActivityMain_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.ActivityCA.helpId)
  end,
  WitchsActivityMain_Group_Join_Group_Handbook_Btn__Click = function(btn, str)
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/GuKaHandbook", DataModel.ActivityId), Json.encode({
      activityId = DataModel.ActivityId
    }))
  end
}
return ViewFunction
