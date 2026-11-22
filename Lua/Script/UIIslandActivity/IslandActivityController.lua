local CommonItem = require("Common/BtnItem")
local View = require("UIIslandActivity/UIIslandActivityView")
local DataModel = require("UIIslandActivity/UIIslandActivityDataModel")
local IslandTaskDataModel = require("UIIslandTask/UIIslandTaskDataModel")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local CardPackDataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
local Controller = {}

function Controller:Init(initParams)
  DataModel:Init(initParams)
  View.Group_Join.self:SetActive(DataModel.IsAdd)
  View.Group_NotJoin.self:SetActive(not DataModel.IsAdd)
  View.Group_Bg.Img_Icon:SetSprite(GetResPath(88300114))
  if not DataModel.IsAdd then
    if DataModel.ActivityCA.rewardPreviewList and table.count(DataModel.ActivityCA.rewardPreviewList) > 0 then
      DataModel.NotJoinReward = {}
      for k, v in pairs(DataModel.ActivityCA.rewardPreviewList) do
        table.insert(DataModel.RewardList, v)
      end
      View.Group_NotJoin.Group_Preview.self:SetActive(true)
      View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(table.count(DataModel.RewardList))
      View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
    end
    View.Group_NotJoin.Group_Add.Group_Quest.self:SetActive(false)
    View.Group_NotJoin.Group_Add.Group_Can.self:SetActive(false)
    if DataModel.ActivityCA.questId ~= -1 and DataModel:QuestIsFinish(DataModel.ActivityCA.questId) == false then
      DataModel.ConstructionType = DataModel.TypeList.Lock
      View.Group_NotJoin.Group_Add.Group_Quest.self:SetActive(true)
      local questCA = PlayerData:GetFactoryData(DataModel.ActivityCA.questId)
      View.Group_NotJoin.Group_Add.Group_Quest.Txt_Quest:SetText(string.format(GetText(DataModel.ActivityCA.unlockTips), questCA.name))
      return
    end
    View.Group_NotJoin.Group_Add.Group_Can.self:SetActive(true)
    DataModel.ConstructionType = DataModel.TypeList.NotEnabled
  else
    Controller:RefreshConstructionJoinPage()
  end
end

function Controller:RewardSetElemnt(element, elementIndex)
  local row = DataModel.RewardList[elementIndex]
  CommonItem:SetActivityPreviewItem(element.Group_Item, row)
  element.Group_Item.Btn_Item:SetClickParam(row.id)
end

function Controller:RewardClickElemnt(id)
  CommonTips.OpenPreRewardDetailTips(id)
end

function Controller:SkipStation(stationId)
  local parms = {}
  parms.index = DataModel.ChooseLeftIndex
  parms.id = DataModel.ActivityCA.id
  UIManager:Open("UI/MainUI/MainUI", Json.encode({isActivity = true}), function()
    UIManager:Open("UI/Activity/ActivityMain", Json.encode(parms))
  end)
  local MapController = require("UIHome/UIHomeMapController")
  MapController:AutoToClickStation(stationId, true)
end

function Controller:RefreshCard()
  View.Group_Join.Group_Card.self:SetActive(false)
  if DataModel.ActivityCA.activityCardPack <= 0 then
    return
  end
  DataModel.CardPackInfo = CardPackDataModel.GetCardPackInfo(DataModel.ActivityCA.activityCardPack)
  View.Group_Join.Group_Card.self:SetActive(true)
  View.Group_Join.Group_Card.Img_RedPoint:SetActive(DataModel.CardPackInfo.extraCardStatus == 1)
  View.Group_Join.Group_Card.Txt_Num:SetText(string.format(GetText(80607795), DataModel.CardPackInfo.ownCount, DataModel.CardPackInfo.allCount))
end

function Controller:RefreshStore()
  local ca = PlayerData:GetFactoryData(11400218)
  local sever = PlayerData:GetGoodsById(11400218)
  View.Group_Join.Group_Store.Img_Icon:SetSprite(ca.buyPath)
  View.Group_Join.Group_Store.Txt_Num:SetText(sever.num)
end

function Controller:RefreshExchange()
  local ca = PlayerData:GetFactoryData(11400212)
  local sever = PlayerData:GetGoodsById(11400212)
  View.Group_Join.Group_Exchange.Img_Icon:SetSprite(ca.buyPath)
  View.Group_Join.Group_Exchange.Txt_Num:SetText(sever.num)
end

function Controller:RefreshPublicity()
  View.Group_Join.Group_Publicity.self:SetActive(true)
  View.Group_Join.Group_Publicity.Group_Can.self:SetActive(false)
  View.Group_Join.Group_Publicity.Group_Not.self:SetActive(false)
  if DataModel.ActivityCA.skipQuestLimit ~= -1 and DataModel:QuestIsFinish(DataModel.ActivityCA.skipQuestLimit) == false then
    DataModel.SkipType = DataModel.BtnTypeList.NotFinish
    View.Group_Join.Group_Publicity.Group_Not.self:SetActive(true)
    return
  end
  View.Group_Join.Group_Publicity.Group_Can.self:SetActive(true)
  DataModel.SkipType = DataModel.BtnTypeList.Finish
end

function Controller:RefreshVolleyball()
  View.Group_Join.Group_Volleyball.self:SetActive(true)
  View.Group_Join.Group_Volleyball.Group_Can.self:SetActive(false)
  View.Group_Join.Group_Volleyball.Group_Not.self:SetActive(false)
  if DataModel.ActivityCA.islandGrade ~= -1 and CommonCoachData.GetCurPlaygroundServerInfo(DataModel.ActivityCA.correspondingScene).lv < DataModel.ActivityCA.islandGrade then
    DataModel.Volleyball = DataModel.VolleyballTypeList.NotArrivedGrade
    View.Group_Join.Group_Volleyball.Group_Not.self:SetActive(true)
    return
  end
  if DataModel.ActivityCA.skipQuestLimit ~= -1 and DataModel:QuestIsFinish(DataModel.ActivityCA.skipQuestLimit) == false then
    DataModel.Volleyball = DataModel.VolleyballTypeList.NotFinishQuest
    View.Group_Join.Group_Volleyball.Group_Not.self:SetActive(true)
    return
  end
  if DataModel.ActivityCA.correspondingFurniture ~= -1 then
    local tag = PlayerData:GetFactoryData(DataModel.ActivityCA.correspondingFurniture).bag
    if DataModel.VolleyballFurniture == nil then
      DataModel.VolleyballFurniture = false
      if PlayerData.ServerData.user_home_info.facility[tostring(tag)] then
        for k, v in pairs(PlayerData.ServerData.user_home_info.facility[tostring(tag)]) do
          if tonumber(v.id) == DataModel.ActivityCA.correspondingFurniture then
            DataModel.VolleyballFurniture = v.id
            break
          end
        end
      end
    end
  end
  if DataModel.VolleyballFurniture == false then
    DataModel.Volleyball = DataModel.VolleyballTypeList.NotHaveFurniture
    View.Group_Join.Group_Volleyball.Group_Not.self:SetActive(true)
    return
  end
  View.Group_Join.Group_Volleyball.Group_Can.self:SetActive(true)
  DataModel.Volleyball = DataModel.VolleyballTypeList.Finish
end

function Controller:RefreshLevel()
  View.Group_Join.Group_Level.self:SetActive(true)
  View.Group_Join.Group_Level.Group_Can.self:SetActive(false)
  View.Group_Join.Group_Level.Group_Not.self:SetActive(false)
  View.Group_Join.Group_Level.Group_Time.self:SetActive(false)
  if DataModel.ActivityCA.levelEndTime ~= "" then
    if TimeUtil:GetServerTimeStamp() > TimeUtil:TimeStamp(DataModel.ActivityCA.levelEndTime) then
      DataModel.LevelType = DataModel.BtnTypeList.TimeOut
      View.Group_Join.Group_Level.self:SetActive(false)
      return
    end
    View.Group_Join.Group_Level.Group_Time.self:SetActive(true)
    local lastTime = TimeUtil:LastTime(DataModel.ActivityCA.levelEndTime)
    DataModel.LevelLastTime = lastTime
    local time = TimeUtil:SecondToTable(lastTime)
    View.Group_Join.Group_Level.Group_Time.Txt_Time:SetText(string.format(GetText(80607797), time.day, time.hour < 10 and "0" .. time.hour or time.hour, 10 > time.minute and "0" .. time.minute or time.minute))
  end
  if DataModel.ActivityCA.levelQuestLimit ~= -1 and DataModel:QuestIsFinish(DataModel.ActivityCA.levelQuestLimit) == false then
    DataModel.LevelType = DataModel.BtnTypeList.NotFinish
    View.Group_Join.Group_Level.Group_Not.self:SetActive(true)
    return
  end
  View.Group_Join.Group_Level.Group_Can.self:SetActive(true)
  DataModel.LevelType = DataModel.BtnTypeList.Finish
end

function Controller:RefreshSkip()
  View.Group_Join.Group_Skip.self:SetActive(true)
  View.Group_Join.Group_Skip.Group_City.self:SetActive(false)
  View.Group_Join.Group_Skip.Group_Island.self:SetActive(false)
  if DataModel.ActivityCA.skipQuestLimit ~= -1 and DataModel:QuestIsFinish(DataModel.ActivityCA.skipQuestLimit) == false then
    DataModel.SkipType = DataModel.BtnTypeList.NotFinish
    View.Group_Join.Group_Skip.Group_City.self:SetActive(true)
    local questCA = PlayerData:GetFactoryData(DataModel.ActivityCA.skipQuestLimit)
    View.Group_Join.Group_Skip.Group_City.Txt_Quest:SetText(string.format(GetText(80607796), questCA.name))
    return
  end
  View.Group_Join.Group_Skip.Group_Island.self:SetActive(true)
  DataModel.SkipType = DataModel.BtnTypeList.Finish
end

function Controller:RefreshQuest()
  View.Group_Join.Group_Quest.Img_RedPoint:SetActive(IslandTaskDataModel.IsCanReceive(true, DataModel.ActivityCA.correspondingScene))
  View.Group_Join.Group_Quest.self:SetActive(true)
  View.Group_Join.Group_Quest.Group_Can.self:SetActive(false)
  View.Group_Join.Group_Quest.Group_Not.self:SetActive(false)
  if DataModel.ActivityCA.skipQuestLimit ~= -1 and DataModel:QuestIsFinish(DataModel.ActivityCA.skipQuestLimit) == false then
    DataModel.SkipType = DataModel.BtnTypeList.NotFinish
    View.Group_Join.Group_Quest.Group_Not.self:SetActive(true)
    return
  end
  View.Group_Join.Group_Quest.Group_Can.self:SetActive(true)
  DataModel.SkipType = DataModel.BtnTypeList.Finish
end

function Controller:RefreshConstructionJoinPage()
  View.Group_Join.self:SetActive(DataModel.IsAdd)
  View.Group_NotJoin.self:SetActive(not DataModel.IsAdd)
  Controller:RefreshCard()
  Controller:RefreshStore()
  Controller:RefreshExchange()
  Controller:RefreshQuest()
  Controller:RefreshPublicity()
  Controller:RefreshVolleyball()
  Controller:RefreshLevel()
  Controller:RefreshSkip()
end

function Controller:OpenVolleyball()
  if DataModel.Volleyball == DataModel.VolleyballTypeList.NotArrivedGrade then
    local text = string.format(GetText(80608169), DataModel.ActivityCA.islandGrade)
    CommonTips.OpenTips(text, true)
    return
  end
  if DataModel.Volleyball == DataModel.VolleyballTypeList.NotFinishQuest then
    local questCA = PlayerData:GetFactoryData(DataModel.ActivityCA.skipQuestLimit)
    local text = string.format(GetText(80607796), questCA.name)
    CommonTips.OpenTips(text, true)
    return
  end
  if DataModel.Volleyball == DataModel.VolleyballTypeList.NotHaveFurniture then
    local furnitureCA = PlayerData:GetFactoryData(DataModel.ActivityCA.correspondingFurniture)
    local text = string.format(GetText(80607799), furnitureCA.name)
    CommonTips.OpenTips(text, true)
    return
  end
  UIManager:Open("UI/VolleyBall/VolleyBall_open", Json.encode({isActivity = true}))
end

function Controller:OpenCardPage()
  local cardPackId = DataModel.ActivityCA.activityCardPack
  local activityName = DataModel.ActivityCA.name
  
  local function callBack()
    Controller:RefreshCard()
    ActivityMainController:RefreshLeftRedState()
  end
  
  UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({cardPackId = cardPackId, activityName = activityName}), callBack)
end

function Controller:OpenQuest()
  if DataModel.SkipType == DataModel.BtnTypeList.NotFinish then
    local questCA = PlayerData:GetFactoryData(DataModel.ActivityCA.skipQuestLimit)
    local text = string.format(GetText(80607796), questCA.name)
    CommonTips.OpenTips(text, true)
    return
  end
  local t = {}
  t.playgroundId = DataModel.ActivityCA.correspondingScene
  UIManager:Open("UI/Island_Task/IslandTask", Json.encode(t))
end

function Controller:OpenPublicity()
  if DataModel.SkipType == DataModel.BtnTypeList.NotFinish then
    local questCA = PlayerData:GetFactoryData(DataModel.ActivityCA.skipQuestLimit)
    local text = string.format(GetText(80607796), questCA.name)
    CommonTips.OpenTips(text, true)
    return
  end
  Net:SendProto("playground.playground_info", function(json)
    if json then
      PlayerData.SolicitData.leafletNum = json.own_leaflet
      PlayerData.SolicitData.copyLeafletNum = json.add_leaflet
      PlayerData:GetHomeInfo().visitors = json.visitors
    end
    UIManager:Open("UI/ParkPublicity/PublicizeMain", Json.encode({
      playgroundId = CommonCoachData.GetPlaygroundId()
    }))
  end, 87300002)
end

function Controller:OpenLevel()
  if DataModel.LevelType == DataModel.BtnTypeList.TimeOut then
    CommonTips.OpenTips(80607798)
    return
  end
  if DataModel.LevelType == DataModel.BtnTypeList.NotFinish then
    local questCA = PlayerData:GetFactoryData(DataModel.ActivityCA.levelQuestLimit)
    local text = string.format(GetText(80607796), questCA.name)
    CommonTips.OpenTips(text, true)
    return
  end
  UIManager:Open("UI/Island_Battle/Island_Battle", Json.encode({
    activityId = DataModel.ActivityCA.id
  }))
end

function Controller:OpenPlayground()
  if DataModel.SkipType == DataModel.BtnTypeList.NotFinish then
    Controller:SkipStation(DataModel.ActivityCA.skipStationStart)
    return
  end
  local t = {}
  t.playgroundId = DataModel.ActivityCA.correspondingScene
  t.backSceneName = MainManager.bgSceneName
  t.backUI = "UI/Activity/ActivityMain"
  t.backParams = {
    id = DataModel.ActivityCA.id
  }
  PlayerData.OpenToPlayground(t)
end

function Controller:AddActivity()
  if DataModel.ConstructionType == DataModel.TypeList.Lock then
    CommonTips.OpenTips(80602587)
  end
  if TimeUtil:IsActive(DataModel.ActivityCA.startTime, DataModel.ActivityCA.endTime) == false then
    return
  end
  if DataModel.ConstructionType == DataModel.TypeList.NotEnabled then
    local function callBack()
      Net:SendProto("main.participate", function(Jsons)
        if Jsons.activity then
          PlayerData.ServerData.all_activities.ing[tostring(DataModel.ActivityCA.id)] = Jsons.activity
        end
        DataModel.IsAdd = true
        Controller:RefreshConstructionJoinPage()
        ActivityMainController:RefreshLeftRedState()
      end, DataModel.ActivityCA.id)
    end
    
    if DataModel.ActivityCA.joinPlotId and DataModel.ActivityCA.joinPlotId ~= "" then
      UIManager:Open("UI/Dialog/Dialog", Json.encode({
        id = DataModel.ActivityCA.joinPlotId
      }), callBack, callBack)
    end
  end
end

return Controller
