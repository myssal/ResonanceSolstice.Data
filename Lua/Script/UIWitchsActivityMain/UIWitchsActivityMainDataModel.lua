local View = require("UIWitchsActivityMain/UIWitchsActivityMainView")
local DataModel = {}
DataModel.ActivityId = WitchData.GetActivityId()
DataModel.closeTime = 0
DataModel.isCityMapIn = false

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.ActivityId = tonumber(data.activityId) or DataModel.ActivityId
  WitchData.SetActiveGameActivityId(DataModel.ActivityId)
  DataModel.closeTime = data.closeTime
  DataModel.isCityMapIn = data.isCityMapIn
end

function DataModel.InitData()
  DataModel.ActivityCA = WitchData.GetActivityCA(DataModel.ActivityId)
end

function DataModel.RefreshOnShow()
  DataModel.RefreshJoin()
  View.Group_Bg.Img_Icon:SetSprite(WitchData.GetUIPath(GetResPath(88300234), DataModel.ActivityId))
end

function DataModel.RefreshJoin()
  local activityCA = DataModel.ActivityCA
  local join = DataModel.IsActivityJoin()
  View.Group_Join:SetActive(join)
  View.Group_NotJoin:SetActive(not join)
  if join then
    local inTime = DataModel.IsInActivityTime()
    View.Group_Join.Group_Finish:SetActive(not inTime)
    View.Group_Join.Group_Level:SetActive(inTime)
    if not inTime then
      View.Group_Join.Group_Finish.Txt_Time:SetText(DataModel.GetCloseTime())
    end
    local skipQuestCompleted = DataModel.IsSkipQuestCompleted()
    View.Group_Join.Group_Skip.Group_Can:SetActive(not skipQuestCompleted)
    View.Group_Join.Group_Skip.Group_Finish:SetActive(skipQuestCompleted)
    local entranceQuestCompleted = DataModel.IsEntranceQuestCompleted()
    View.Group_Join.Group_Level.Group_Can:SetActive(entranceQuestCompleted)
    if entranceQuestCompleted then
      DataModel.RefreshJoinInMapRedPoint()
    end
    View.Group_Join.Group_Level.Group_Quest:SetActive(not entranceQuestCompleted)
    local bannerCapCfg = PlayerData:GetFactoryData(activityCA.bannerCapsuleList[1].id)
    local costItemCfg = PlayerData:GetFactoryData(bannerCapCfg.costList[1].id)
    View.Group_Join.Group_Store.Txt_Num:SetText(PlayerData:GetGoodsById(bannerCapCfg.costList[1].id).num)
    View.Group_Join.Group_Store.Img_Coin:SetSprite(costItemCfg.buyPath)
    DataModel.RefreshTicket()
    DataModel.RefreshMissionRedPoint()
    DataModel.RefreshHandbookRedPoint()
    DataModel.RefreshCard()
  else
    local questCompleted = DataModel.IsMainQuestCompleted()
    View.Group_NotJoin.Group_Add.Group_Can:SetActive(questCompleted)
    View.Group_NotJoin.Group_Add.Group_Quest:SetActive(not questCompleted)
    local remainTime = TimeUtil:TimeStamp(DataModel.closeTime) - TimeUtil:GetServerTimeStamp()
    local remainDay = math.ceil(remainTime / 86400)
    local remainDayStr = string.format(GetText(80607097), remainDay)
    if questCompleted then
      View.Group_NotJoin.Group_Add.Group_Can.Txt_Time:SetText(remainDayStr)
    else
      local questCA = PlayerData:GetFactoryData(activityCA.questId, "QuestFactory")
      View.Group_NotJoin.Group_Add.Group_Quest.Txt_Quest:SetText(string.format(GetText(activityCA.unlockTips), questCA.name))
      View.Group_NotJoin.Group_Add.Group_Quest.Txt_Time:SetText(remainDayStr)
    end
    View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(table.count(activityCA.rewardPreviewList))
    View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
  end
  DataModel.RefreshTime()
end

function DataModel.RefreshTicket(activityId)
  activityId = tonumber(activityId) or DataModel.ActivityId
  local parkCA = WitchData.GetParkMapCA(activityId)
  View.Group_Join.Group_Level.Group_Can.Group_Ticket.Txt_TicketNum:SetText(WitchData.GetTicketTotalNum(activityId))
  local buyNum = WitchData.GetDayBuyNum(activityId)
  View.Group_Join.Group_Level.Group_Can.Group_Ticket.Txt_Limit:SetText(string.format(GetText(80600798), buyNum, parkCA.ticketLimit))
end

function DataModel.RefreshJoinInMapRedPoint(activityId)
  activityId = tonumber(activityId) or DataModel.ActivityId
  View.Group_Join.Group_Level.Group_Can.Img_RedPoint:SetActive(WitchData.GetTicketTotalNum(activityId) > 0)
end

function DataModel.RefreshTime()
  local activityCA = DataModel.ActivityCA
  local timeStartDate = os.date("*t", TimeUtil:TimeStamp(activityCA.startTime))
  local timeStartStr = string.format("%02d/%02d  %02d:%02d", timeStartDate.month, timeStartDate.day, timeStartDate.hour, timeStartDate.min)
  local timeEndDate = os.date("*t", TimeUtil:TimeStamp(activityCA.endTime))
  local timeEndStr = string.format("%02d/%02d  %02d:%02d", timeEndDate.month, timeEndDate.day, timeEndDate.hour, timeEndDate.min)
  View.Group_Time.Txt_EndTime:SetText(string.format(GetText(80610564), timeStartStr, timeEndStr))
end

function DataModel.RefreshCard()
  local CardPackDataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
  local activityCA = DataModel.ActivityCA
  local info = CardPackDataModel.GetCardPackInfo(activityCA.activityCardPack)
  View.Group_Join.Group_Card.Img_RedPoint:SetActive(info.extraCardStatus == 1)
  View.Group_Join.Group_Card.Txt_Num:SetText(string.format(GetText(80607100), info.ownCount, info.allCount))
end

function DataModel.GetCloseTime()
  local remainTime = TimeUtil:TimeStamp(DataModel.closeTime) - TimeUtil:GetServerTimeStamp()
  if 86400 <= remainTime then
    local days = math.floor(remainTime / 86400)
    local hours = math.floor((remainTime - days * 86400) / 3600)
    return string.format(GetText(80607098), days, hours)
  else
    local hours = math.floor(remainTime / 3600)
    local minutes = math.floor((remainTime - hours * 3600) / 60)
    return string.format(GetText(80607099), hours, minutes)
  end
end

function DataModel.IsInActivityTime()
  local activityCA = DataModel.ActivityCA
  return TimeUtil:IsActive(activityCA.startTime, activityCA.endTime)
end

function DataModel.IsInGetRewardTime()
  local activityCA = DataModel.ActivityCA
  return TimeUtil:IsActive(activityCA.startTime, activityCA.rewardEndTime)
end

function DataModel.IsActivityJoin()
  return PlayerData:GetActivityAct(DataModel.ActivityId)
end

function DataModel.IsMainQuestCompleted()
  local questId = DataModel.ActivityCA.questId
  if 0 < questId then
    local questState = PlayerData.GetQuestState(questId)
    return questState == EnumDefine.EQuestState.Finish or questState == EnumDefine.EQuestState.Receive
  end
  return true
end

function DataModel.IsSkipQuestCompleted()
  local questId = DataModel.ActivityCA.skipQuestLimit
  if 0 < questId then
    local questState = PlayerData.GetQuestState(questId)
    return questState == EnumDefine.EQuestState.Finish or questState == EnumDefine.EQuestState.Receive
  end
  return true
end

function DataModel.IsEntranceQuestCompleted()
  local questId = DataModel.ActivityCA.witchesQuestLimit
  if 0 < questId then
    local questState = PlayerData.GetQuestState(questId)
    return questState == EnumDefine.EQuestState.Finish or questState == EnumDefine.EQuestState.Receive
  end
  return true
end

function DataModel.OpenWitchScene()
  if not DataModel.IsEntranceQuestCompleted() then
    return
  end
  WitchData.SetActiveGameActivityId(DataModel.ActivityId)
  local join = WitchData.IsJoin()
  if not join and WitchData.GetTicketTotalNum(DataModel.ActivityId) == 0 then
    local parkMapCA = WitchData.GetParkMapCA(DataModel.ActivityId)
    if parkMapCA and parkMapCA.ticketTips and 0 < parkMapCA.ticketTips then
      CommonTips.OpenWitchTip(parkMapCA.ticketTips)
    end
    return
  end
  
  local function cb()
    local WitchMainDataController = require("UIWitchMain/UIWitchMainDataController")
    WitchMainDataController:Clear()
    local SliceSceneManager = CBus:GetManager(CS.ManagerName.SliceSceneManager, true)
    if SliceSceneManager then
      SliceSceneManager.loadedScene:Clear()
    end
    local t = {}
    local backUIParams = {}
    t.backSceneName = MainManager.bgSceneName
    if DataModel.isCityMapIn then
      t.backUI = "UI/CityMap/CityMap"
      local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
      backUIParams.stationId = TradeDataModel.EndCity
    else
      t.backUI = "UI/Activity/ActivityMain"
      backUIParams.id = DataModel.ActivityId
    end
    t.backUIParams = backUIParams
    t.showTicket = 1
    local witchMainUIPath = WitchData.GetUIPath("UI/Witches/Main/WitchMain", DataModel.ActivityId)
    if CS.UIManager.persistantList:Contains(witchMainUIPath) ~= true then
      CS.UIManager.persistantList:Add(witchMainUIPath)
    end
    CBus:ChangeScene(WitchData.GetSceneName(DataModel.ActivityId), function()
      UIManager:Open(witchMainUIPath, Json.encode(t))
    end)
    GameSetting:LoadPlayerSetting()
    PlayerData:ResetCharacterFilter()
    PlayerData:ResetSuaqsFilter()
    PlayerData:ResetDepotFilter()
  end
  
  local function Loading(callBack)
    local parkMapCA = WitchData.GetParkMapCA(DataModel.ActivityId)
    local randomNum = math.random(1, #parkMapCA.loadingList)
    local imagePath = parkMapCA.loadingList[randomNum] and parkMapCA.loadingList[randomNum].imagePath
    if imagePath then
      CommonTips.OpenLoading(nil, "", imagePath, callBack)
    else
      CommonTips.OpenLoadingCB(callBack)
    end
  end
  
  if join then
    if not WitchData.IsSelectActionType() then
      UIManager:Open(WitchData.GetUIPath("UI/Witches/Main/Stamina", DataModel.ActivityId), nil, function()
        Loading(cb)
      end)
    else
      Loading(cb)
    end
  else
    local itemData = {}
    local useNum = 1
    local parkMapCA = WitchData.GetParkMapCA(DataModel.ActivityId)
    local itemId = parkMapCA.ticketList[1].id
    if PlayerData:GetGoodsById(itemId).num == 0 then
      itemId = parkMapCA.ticketCostExtra
      if PlayerData:GetGoodsById(itemId).num == 0 then
        return
      end
      useNum = 1
    else
      useNum = parkMapCA.ticketList[1].num
    end
    itemData.itemId = itemId
    itemData.useNum = useNum
    itemData.itemNum = WitchData.GetTicketTotalNum(DataModel.ActivityId)
    local itemCA = PlayerData:GetFactoryData(itemId)
    
    local function yesFun()
      local limitItemId
      if itemId == parkMapCA.ticketCostExtra then
        local items = {}
        for i, v in pairs(PlayerData:GetLimitedItems()) do
          if v.id == tostring(itemId) then
            table.insert(items, {
              uid = i,
              remainTime = v.dead_line
            })
          end
        end
        table.sort(items, function(a, b)
          return a.remainTime < b.remainTime
        end)
        limitItemId = items[1].uid
      end
      WitchData.ReqJoinActivity(itemId, useNum, limitItemId, function()
        UIManager:Open(WitchData.GetUIPath("UI/Witches/Main/Stamina", DataModel.ActivityId), nil, function()
          Loading(cb)
        end)
      end)
    end
    
    CommonTips.OpenWitchItemPrompt(string.format(GetText(80610288), itemCA.name), nil, nil, itemData, yesFun)
  end
end

function DataModel.RefreshMissionRedPoint()
  local questDataModel = require("UIWitcheslMission/UIWitcheslMissionDataModel")
  local redPoint = questDataModel.CheckMissionRedPoint(DataModel.ActivityId)
  View.Group_Join.Group_Quest.Img_RedPoint:SetActive(redPoint)
  local percent = questDataModel.GetMissionFinishPercent(DataModel.ActivityId)
  View.Group_Join.Group_Quest.Group_Progress.Txt_Num:SetText(string.format("%d%%", math.floor(percent * 100)))
end

function DataModel.RefreshHandbookRedPoint()
  local handbookDataModel = require("UIGuKaHandbook/UIGuKaHandbookDataModel")
  local redPoint = handbookDataModel.CheckRedPoint(DataModel.ActivityId)
  View.Group_Join.Group_Handbook.Img_RedPoint:SetActive(redPoint)
  local percent = handbookDataModel.GetHandbookPercent(DataModel.ActivityId)
  View.Group_Join.Group_Handbook.Group_Progress.Txt_Num:SetText(string.format("%d%%", math.floor(percent * 100)))
end

return DataModel
