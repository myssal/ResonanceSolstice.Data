local View = require("UIIslandTask/UIIslandTaskView")
local DataModel = require("UIIslandTask/UIIslandTaskDataModel")
local NPCDialog = require("Common/NPCDialog")
local CommonItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  NPCDialog.SetNPC(View.Group_NPC, DataModel.npcId)
  View.Group_Main.ScrollGrid_.grid.self:SetDataCount(#DataModel.questInfos)
  View.Group_Main.ScrollGrid_.grid.self:MoveToTop()
  View.Group_Main.ScrollGrid_.grid.self:RefreshAllElement()
  Controller:RefreshLvInfo()
end

function Controller:RefreshElement(element, elementIndex)
  local info = DataModel.questInfos[elementIndex]
  local isComplete = info.state == EnumDefine.EQuestState.Finish
  local isReceive = info.state == EnumDefine.EQuestState.Receive
  local showTxt = info.describe
  if info.isShowProgress then
    showTxt = showTxt .. string.format("(%d/%d)", info.pcnt, info.maxPcnt)
  end
  element.Group_Info.Txt_Name:SetText(showTxt)
  element.Group_Info.Group_Reward.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
  element.Group_Info.Group_Reward.ScrollGrid_Reward.grid.self:SetDataCount(#info.rewardsList)
  element.Group_Info.Group_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
  element.Group_Info.Group_incomplete:SetActive(not isComplete and not isReceive)
  element.Group_Info.Group_Complete:SetActive(isComplete or isReceive)
  if isComplete or isReceive then
    element.Group_Info.Group_Complete.Group_Get:SetActive(not isReceive)
    element.Group_Info.Group_Complete.Group_Get.Btn_Get:SetClickParam(elementIndex)
    element.Group_Info.Group_Complete.Img_Tab:SetSprite(info.tabUI)
  else
    element.Group_Info.Group_incomplete.Img_Btm:SetSprite(info.isPlotTask and DataModel.plotInCompletePath or DataModel.inCompletePath)
    element.Group_Info.Group_incomplete.Img_Tab:SetSprite(info.tabUI)
    local isTraceSelf = DataModel.curQuestTraceId == info.id
    element.Group_Info.Group_incomplete.Group_Track:SetActive(not isTraceSelf)
    element.Group_Info.Group_incomplete.Group_Cancel:SetActive(isTraceSelf)
    if isTraceSelf then
      element.Group_Info.Group_incomplete.Group_Cancel.Img_CancelBg:SetSprite(info.isPlotTask and DataModel.plotCancelBg or DataModel.cancelBg)
    end
    element.Group_Info.Group_incomplete.Group_Track.Btn_Track:SetClickParam(elementIndex)
    element.Group_Info.Group_incomplete.Group_Cancel.Btn_Cancel:SetClickParam(elementIndex)
  end
  element.Group_Info.Group_Got:SetActive(isReceive)
end

function Controller:ClickTrace(btn, str)
  local info = DataModel.questInfos[tonumber(str)]
  PlayerData:SetPlayerPrefs("int", "PlaygroundQuestTrace" .. DataModel.initParams.playgroundId, info.id)
  DataModel.curQuestTraceId = info.id
  View.Group_Main.ScrollGrid_.grid.self:RefreshAllElement()
end

function Controller:ClickTraceCancel(btn, str)
  PlayerData:SetPlayerPrefs("int", "PlaygroundQuestTrace" .. DataModel.initParams.playgroundId, 0)
  DataModel.curQuestTraceId = 0
  View.Group_Main.ScrollGrid_.grid.self:RefreshAllElement()
end

function Controller:ClickGetReward(btn, str)
  local info = DataModel.questInfos[tonumber(str)]
  Net:SendProto("quest.recv_rewards", function(json)
    CommonTips.OpenShowItem(json.reward)
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
      [1] = info.id
    })
    QuestTrace.CompleteQuestOne(info.id)
    DataModel.Init()
    if DataModel.curQuestTraceId == info.id then
      local nextQuestTraceId = 0
      for _, v in ipairs(DataModel.questInfos) do
        if v.isPlotTask and v.state ~= EnumDefine.EQuestState.Receive then
          nextQuestTraceId = v.id
          break
        end
      end
      if nextQuestTraceId == 0 and 0 < #DataModel.questInfos then
        local v = DataModel.questInfos[1]
        if v.state ~= EnumDefine.EQuestState.Receive then
          nextQuestTraceId = v.id
        end
      end
      PlayerData:SetPlayerPrefs("int", "PlaygroundQuestTrace" .. DataModel.initParams.playgroundId, nextQuestTraceId)
      DataModel.curQuestTraceId = nextQuestTraceId
    end
    View.Group_Main.ScrollGrid_.grid.self:SetDataCount(#DataModel.questInfos)
    View.Group_Main.ScrollGrid_.grid.self:RefreshAllElement()
    Controller:RefreshLvInfo()
    CommonTips.OpenPlaygroundLevelUp()
  end, info.id)
end

function Controller:RefreshRewardElement(element, elementIndex)
  local info = DataModel.questInfos[tonumber(element.ParentParam)]
  local rewardInfo = info.rewardsList[elementIndex]
  CommonItem:SetItem(element.Group_Item, {
    id = rewardInfo.id
  })
  element.Group_Item.Btn_Item:SetClickParam(rewardInfo.id)
end

function Controller:RefreshLvInfo()
  local serverInfo = CommonCoachData.GetCurPlaygroundServerInfo(DataModel.initParams.playgroundId) or {}
  local lv = serverInfo.lv or 1
  local exp = serverInfo.exp or 0
  View.Group_IslandLv.Txt_Grade:SetText(string.format(GetText(80608245), lv))
  local playgroundCA = PlayerData:GetFactoryData(DataModel.initParams.playgroundId)
  if lv <= #playgroundCA.expList then
    local info = playgroundCA.expList[lv]
    local txt = exp .. "/" .. info.exp
    View.Group_IslandLv.Txt_Num:SetText(txt)
    local percent = exp / info.exp
    View.Group_IslandLv.Img_PB:SetFilledImgAmount(percent)
  else
    View.Group_IslandLv.Txt_Num:SetText("")
    View.Group_IslandLv.Img_PB:SetFilledImgAmount(1)
  end
end

function Controller:ClickRewardItem(btn, str)
  local itemId = tonumber(str)
  CommonTips.OpenRewardDetail(itemId)
end

function Controller:Return()
  UIManager:GoBack()
end

return Controller
