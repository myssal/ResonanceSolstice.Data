local View = require("UIActivityTrainBattle/UIActivityTrainBattleView")
local DataModel = require("UIActivityTrainBattle/UIActivityTrainBattleDataModel")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local CardPackDataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
local missionDataModel = require("UIKabaneriMission/UIKabaneriMissionDataModel")
local homeCapsule = require("UIHomeCapsule/UIHomeCapsuleController")
local Controller = {}

function Controller.JoinActivity()
  Net:SendProto("main.participate", function(Jsons)
    if Jsons.activity then
      PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)] = Jsons.activity
    end
    View.Group_Join.Group_Store.Group_Top.Txt_Num:SetText(PlayerData:GetGoodsById(11400389).num or 0)
    DataModel.JoinActivity()
    View.Group_Join:SetActive(DataModel.isJoin)
    View.Group_NotJoin:SetActive(not DataModel.isJoin)
    local isOver = DataModel.ActivityOver()
    View.Group_Join.Group_Finish:SetActive(isOver)
    View.Group_Join.Group_Level:SetActive(not isOver)
    if isOver then
      View.Group_Join.Group_Finish.Txt_Time:SetText(DataModel.GetCloseTimeInfo())
    end
    Controller.RefreshQuestRedDot(true)
    Controller.RefreshCapsuleShow()
    require("UIActivityMain/UIActivityMainView").Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
  end, DataModel.activityId)
end

function Controller.RefreshCapsuleShow()
  local activityCA = PlayerData:GetFactoryData(DataModel.activityId)
  local capId
  for k, v in pairs(activityCA.bannerCapsuleList) do
    capId = v.id
    break
  end
  if capId then
    local _, goodsNum = PlayerData.GetCapsuleRedDot(capId)
    View.Group_Join.Group_Store:SetActive(0 < goodsNum)
  else
    View.Group_Join.Group_Store:SetActive(false)
  end
end

function Controller.QuestIsFinish(mainQuestId, activityQuestId, levelQuestId)
  local isFinish1 = ActivityMainController:QuestIsFinish(mainQuestId)
  DataModel.SetIsCanJoin(isFinish1)
end

function Controller.RefreshCardInfo(cardPackId)
  local info = CardPackDataModel.GetCardPackInfo(cardPackId)
  View.Group_Join.Group_Card.Img_RedPoint:SetActive(info.extraCardStatus == 1)
  View.Group_Join.Group_Card.Txt_Num:SetText(string.format(GetText(80607100), info.ownCount, info.allCount))
end

function Controller.RefreshQuestRedDot(showCap)
  if not missionDataModel then
    return false
  end
  local isRedDot = false
  isRedDot = missionDataModel.IsHadQuestCanGet(DataModel.activityId)
  View.Group_Join.Group_Quest.Img_RedPoint:SetActive(isRedDot)
  local activityCA = PlayerData:GetFactoryData(DataModel.activityId)
  isRedDot = false
  for k, v in pairs(activityCA.bannerCapsuleList) do
    isRedDot = PlayerData.GetCapsuleRedDot(v.id)
    if isRedDot then
      break
    end
  end
  isRedDot = isRedDot or showCap
  PlayerData.TempCache.showCapsuleRedDot = showCap
  View.Group_Join.Group_Store.Img_RedPoint:SetActive(isRedDot)
end

function Controller.RefreshPanelDot(cardPackId)
  Controller.RefreshQuestRedDot()
end

function Controller.PanelRedDotStatus(activityId)
  if PlayerData.TempCache and PlayerData.TempCache.showCapsuleRedDot then
    return true
  end
  local cfg = PlayerData:GetFactoryData(activityId)
  local isJoin = PlayerData:GetActivityAct(activityId)
  if not isJoin then
    local serverTime = TimeUtil:GetServerTimeStamp()
    local enTime = TimeUtil:TimeStamp(cfg.endTime)
    if 0 < enTime - serverTime or cfg.isTriggerTime then
      return true
    end
  end
  if missionDataModel and missionDataModel.IsHadQuestCanGet(activityId) == true then
    return true
  end
  local activityCA = PlayerData:GetFactoryData(activityId)
  for k, v in pairs(activityCA.bannerCapsuleList) do
    if PlayerData.GetCapsuleRedDot(v.id) then
      return true
    end
  end
  return false
end

return Controller
