local View = require("UIHotelActivity/UIHotelActivityView")
local DataModel = require("UIHotelActivity/UIHotelActivityDataModel")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local CardPackDataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
local missionDataModel = require("UIHotelMission/UIHotelMissionDataModel")
local Controller = {}

function Controller.JoinActivity()
  Net:SendProto("main.participate", function(Jsons)
    if Jsons.activity then
      PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)] = Jsons.activity
    end
    View.Group_Join.Group_Store.Txt_Num:SetText(PlayerData:GetGoodsById(11400369).num or 0)
    DataModel.JoinActivity()
    View.Group_Join:SetActive(DataModel.isJoin)
    View.Group_NotJoin:SetActive(not DataModel.isJoin)
    local isOver = DataModel.ActivityOver()
    View.Group_Join.Group_Finish:SetActive(isOver)
    View.Group_Join.Group_Level:SetActive(not isOver)
    View.Group_Join.Group_Skip:SetActive(not isOver)
    if isOver then
      View.Group_Join.Group_Finish.Txt_Time:SetText(DataModel.GetCloseTimeInfo())
    end
    require("UIActivityMain/UIActivityMainView").Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
    View.Group_Join.Group_Skip.Group_Finish:SetActive(DataModel.sideQuestIsComplete)
    View.Group_Join.Group_Level.Group_Quest:SetActive(not DataModel.levelQuestIsComplete)
  end, DataModel.activityId)
end

function Controller.QuestIsFinish(mainQuestId, activityQuestId, levelQuestId)
  local isFinish1 = ActivityMainController:QuestIsFinish(mainQuestId)
  local isFinish2 = ActivityMainController:QuestIsFinish(activityQuestId)
  local isFinish3 = ActivityMainController:QuestIsFinish(levelQuestId)
  DataModel.SetIsCanJoin(isFinish1)
  DataModel.SetSideQuestStatus(isFinish2)
  DataModel.SetlevelQuestStatus(isFinish3)
end

function Controller.RefreshCardInfo(cardPackId)
  local info = CardPackDataModel.GetCardPackInfo(cardPackId)
  View.Group_Join.Group_Card.Img_RedPoint:SetActive(info.extraCardStatus == 1)
  View.Group_Join.Group_Card.Txt_Num:SetText(string.format(GetText(80607100), info.ownCount, info.allCount))
end

function Controller.RefreshQuestRedDot()
  local isRedDot = false
  if not missionDataModel then
    return false
  end
  isRedDot = missionDataModel.IsHadQuestCanGet(DataModel.activityId)
  View.Group_Join.Group_Quest.Img_RedPoint:SetActive(isRedDot)
  View.Group_Join.Group_Quest.Group_Progress.Txt_Num:SetText(string.format("%.0f%%", missionDataModel.GetQuestCompletePercent(DataModel.activityId) * 100))
end

function Controller.RefreshPanelDot(cardPackId)
  Controller.RefreshCardInfo(cardPackId)
  Controller.RefreshQuestRedDot()
end

function Controller.PanelRedDotStatus(activityId)
  local cfg = PlayerData:GetFactoryData(activityId)
  local isCanJoin = ActivityMainController:QuestIsFinish(cfg.questId)
  if isCanJoin == false then
    return false
  end
  local cardPackId = cfg.activityCardPack
  local isJoin = PlayerData:GetActivityAct(activityId)
  if not isJoin then
    local serverTime = TimeUtil:GetServerTimeStamp()
    local enTime = TimeUtil:TimeStamp(cfg.endTime)
    if 0 < enTime - serverTime or cfg.isTriggerTime then
      return true
    end
  end
  local info = CardPackDataModel.GetCardPackInfo(cardPackId)
  if info.extraCardStatus == 1 then
    return true
  end
  if missionDataModel and missionDataModel.IsHadQuestCanGet(DataModel.activityId) == true then
    return true
  end
  return false
end

return Controller
