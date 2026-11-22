local View = require("UIPrisonTask/UIPrisonTaskView")
local NPCDialog = require("Common/NPCDialog")
local DataModel = {}
DataModel.stationId = 83000017
DataModel.npcId = 83700087
DataModel.prisonCA = nil
DataModel.questList = {}
DataModel.curQuestTraceId = nil

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.stationId = data.stationId
end

local function GetSort(questId)
  local state = PlayerData.GetQuestState(questId)
  if state == EnumDefine.EQuestState.Finish then
    return 0
  elseif state == EnumDefine.EQuestState.Receive then
    return 2
  end
  return 1
end

function DataModel.InitData()
  local prisonCA = PrisonData.GetPrisonCA()
  DataModel.prisonCA = prisonCA
  DataModel.InitQuestData()
  DataModel.curQuestTraceId = PlayerData:GetPlayerPrefs("int", "PrisonQuestTrace")
end

function DataModel.RefreshOnShow()
  View.Group_NPC.self:SetActive(true)
  NPCDialog.SetNPC(View.Group_NPC, DataModel.npcId)
  DataModel.PlayNPCTalk(DataModel.npcId, "enterText")
  DataModel.RefreshPrisonLV()
  View.Group_Main.ScrollGrid_.grid.self:SetDataCount(#DataModel.questList)
  View.Group_Main.ScrollGrid_.grid.self:RefreshAllElement()
end

function DataModel.RefreshPrisonLV()
  local prisonLv = PrisonData.GetPrisonLv()
  local exp = PrisonData.GetPrisonExp()
  local lvCfg = DataModel.prisonCA.lvList[prisonLv]
  View.Group_IslandLv.Group_Level.Txt_LV:SetText(string.format(GetText(80607996), prisonLv))
  View.Group_IslandLv.Txt_Num:SetText(string.format("%d/%d", exp, lvCfg.exp))
  View.Group_IslandLv.Img_PB:SetFilledImgAmount(exp / lvCfg.exp)
end

function DataModel.PlayNPCTalk(npcId, talk_type)
  local npcConfig = PlayerData:GetFactoryData(npcId, "NPCFactory")
  local textTable = npcConfig[talk_type]
  if textTable then
    NPCDialog.SetNPCText(View.Group_NPC, textTable, talk_type)
  end
end

function DataModel.TraceQuest(questId)
  questId = tonumber(questId)
  PlayerData:SetPlayerPrefs("int", "PrisonQuestTrace", questId)
  DataModel.curQuestTraceId = questId
  View.Group_Main.ScrollGrid_.grid.self:RefreshAllElement()
  if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
    local UIPrisonDataModel = require("UIPrison/UIPrisonDataModel")
    UIPrisonDataModel.QuestTraceRefresh()
  end
  if UIManager:IsPanelOpened("UI/Prison/Main/PrisonMain") then
    local UIPrisonMainDataModel = require("UIPrisonMain/UIPrisonMainDataModel")
    UIPrisonMainDataModel.QuestTraceRefresh()
  end
  if UIManager:IsPanelOpened("UI/Prison/Main/PrisonAccomodation/PrisonAccomodation") then
    local UIPrisonAccomodationDataModel = require("UIPrisonAccomodation/UIPrisonAccomodationDataModel")
    UIPrisonAccomodationDataModel.QuestTraceRefresh()
  end
end

function DataModel.CancelQuestTrace()
  PlayerData:SetPlayerPrefs("int", "PrisonQuestTrace", 0)
  DataModel.curQuestTraceId = 0
  View.Group_Main.ScrollGrid_.grid.self:RefreshAllElement()
  if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
    local UIPrisonDataModel = require("UIPrison/UIPrisonDataModel")
    UIPrisonDataModel.QuestTraceRefresh()
  end
  if UIManager:IsPanelOpened("UI/Prison/Main/PrisonMain") then
    local UIPrisonMainDataModel = require("UIPrisonMain/UIPrisonMainDataModel")
    UIPrisonMainDataModel.QuestTraceRefresh()
  end
  if UIManager:IsPanelOpened("UI/Prison/Main/PrisonAccomodation/PrisonAccomodation") then
    local UIPrisonAccomodationDataModel = require("UIPrisonAccomodation/UIPrisonAccomodationDataModel")
    UIPrisonAccomodationDataModel.QuestTraceRefresh()
  end
end

function DataModel.ReceiveReward(questId)
  questId = tonumber(questId)
  Net:SendProto("quest.recv_rewards", function(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    if json.current_quests ~= nil then
      for k, v in pairs(json.current_quests) do
        local questCA = PlayerData:GetFactoryData(k, "QuestFactory")
        local serverKey = ""
        if questCA.questType == "Main" then
          serverKey = "mq_quests"
        elseif questCA.questType == "Side" then
          serverKey = "branch_quests"
        end
        if serverKey ~= "" then
          PlayerData.ServerData.quests[serverKey][k] = v
        end
      end
    end
    GuideManager:CompleteQuestCallBack({
      [1] = questId
    })
    QuestTrace.CompleteQuestOne(questId)
    if DataModel.curQuestTraceId == questId then
      PlayerData:SetPlayerPrefs("int", "PrisonQuestTrace", 0)
      DataModel.curQuestTraceId = 0
    end
    DataModel.InitQuestData()
    PrisonData.QuestRefresh()
    View.Group_Main.ScrollGrid_.grid.self:SetDataCount(#DataModel.questList)
    View.Group_Main.ScrollGrid_.grid.self:RefreshAllElement()
  end, tostring(questId))
end

function DataModel.InitQuestData()
  DataModel.questList = PrisonData.GetShowQuest()
  table.sort(DataModel.questList, function(a, b)
    return GetSort(a) < GetSort(b)
  end)
end

return DataModel
