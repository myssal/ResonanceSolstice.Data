local View = require("UIQuest/UIQuestView")
local CommonItem = require("Common/BtnItem")
local DataModel = require("UIQuest/UIQuestDataModel")
local Controller = {}

function Controller:RequestAllQuest()
  View.Group_Info.self:SetActive(false)
  View.ScrollView_QuestList.self:SetActive(false)
  Net:SendProto("quest.list", function(json)
    PlayerData.ServerData.quests = json.quests
    QuestTrace.InitCacheQuestIng()
    QuestProcess.UpdateCacheQuest(true)
    DataModel.InitAllQuests(json.quests)
    View.ScrollView_QuestList.Viewport.Content.ScrollGrid_COCQuest.self:SetHeight(DataModel.ConstChildElementHeight)
    View.ScrollView_QuestList.Viewport.Content.ScrollGrid_MainQuest.self:SetHeight(DataModel.ConstChildElementHeight)
    View.ScrollView_QuestList.Viewport.Content.ScrollGrid_SideQuest.self:SetHeight(DataModel.ConstChildElementHeight)
    View.ScrollView_QuestList.self:SetActive(true)
    Controller:FirstShow()
    View.self:PlayAnim("In_02")
  end, EnumDefine.QuestListDefine.All)
end

local function autoSelectQuest(questId)
  local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
  if questCA == nil then
    return false
  end
  local type = DataModel.QuestType[questCA.questType]
  for k, v in pairs(DataModel.AllQuests[type]) do
    local id = v.id
    if questId == id then
      local mergeIdx = DataModel.GetMergeIdx(type, k)
      if type == DataModel.QuestType.Order then
        Controller:ShowOrderDetailInfo(mergeIdx)
      else
        Controller:ShowDetailInfo(mergeIdx)
      end
      Controller:SelectMainTitle(type, nil, true)
      return true
    end
  end
  return false
end

function Controller:FirstShow()
  local element = View.ScrollView_QuestList.Viewport.Content
  element.ScrollGrid_MainQuest.self:SetActive(false)
  element.ScrollGrid_SideQuest.self:SetActive(false)
  element.ScrollGrid_COCQuest.self:SetActive(false)
  element.ScrollGrid_OrderQuest.self:SetActive(false)
  element.Btn_MainQuest.Group_UnSelected:SetActive(true)
  element.Btn_MainQuest.Group_Selected:SetActive(false)
  element.Btn_SideQuest.Group_UnSelected:SetActive(true)
  element.Btn_SideQuest.Group_Selected:SetActive(false)
  element.Btn_COCQuest.Group_UnSelected:SetActive(true)
  element.Btn_COCQuest.Group_Selected:SetActive(false)
  element.Btn_OrderQuest.Group_UnSelected:SetActive(true)
  element.Btn_OrderQuest.Group_Selected:SetActive(false)
  Controller:RefreshMainTitleViewState(DataModel.QuestType.Main)
  Controller:RefreshMainTitleViewState(DataModel.QuestType.Side)
  Controller:RefreshMainTitleViewState(DataModel.QuestType.Home)
  Controller:RefreshMainTitleViewState(DataModel.QuestType.Order)
  View.Group_Info.self:SetActive(false)
  if DataModel.Data and DataModel.Data.questId and autoSelectQuest(DataModel.Data.questId) then
    return
  end
  if DataModel.QuestTrace ~= nil and autoSelectQuest(DataModel.QuestTrace.id) then
    return
  end
  local type = DataModel.QuestType.Main
  if #DataModel.AllQuests[type] > 0 then
    local mergeIdx = DataModel.GetMergeIdx(type, 1)
    Controller:ShowDetailInfo(mergeIdx)
    Controller:SelectMainTitle(type)
    return
  end
  type = DataModel.QuestType.Side
  if #DataModel.AllQuests[type] > 0 then
    local mergeIdx = DataModel.GetMergeIdx(type, 1)
    Controller:ShowDetailInfo(mergeIdx)
    Controller:SelectMainTitle(type)
    return
  end
  type = DataModel.QuestType.Home
  if #DataModel.AllQuests[type] > 0 then
    local mergeIdx = DataModel.GetMergeIdx(type, 1)
    Controller:ShowDetailInfo(mergeIdx)
    Controller:SelectMainTitle(type)
    return
  end
  type = DataModel.QuestType.Order
  if #DataModel.AllQuests[type] > 0 then
    local mergeIdx = DataModel.GetMergeIdx(type, 1)
    Controller:ShowOrderDetailInfo(mergeIdx)
    Controller:SelectMainTitle(type)
    return
  end
  View.Group_Info.self:SetActive(false)
  View.Group_Null.self:SetActive(true)
end

function Controller:RefreshMainTitleViewState(type)
  local element = View.ScrollView_QuestList.Viewport.Content
  local redPoint
  if type == DataModel.QuestType.Main then
    element.Btn_MainQuest.Img_New:SetActive(RedpointTree:GetRedpointCnt(RedpointTree.NodeNames.QuestMain) > 0)
    redPoint = element.Btn_MainQuest.Img_RedPoint
  elseif type == DataModel.QuestType.Side then
    element.Btn_SideQuest.Img_New:SetActive(0 < RedpointTree:GetRedpointCnt(RedpointTree.NodeNames.QuestSide))
    redPoint = element.Btn_SideQuest.Img_RedPoint
  elseif type == DataModel.QuestType.Home then
    element.Btn_COCQuest.Img_New:SetActive(0 < RedpointTree:GetRedpointCnt(RedpointTree.NodeNames.QuestHome))
    redPoint = element.Btn_COCQuest.Img_RedPoint
  elseif type == DataModel.QuestType.Order then
    element.Btn_OrderQuest.Img_New:SetActive(0 < RedpointTree:GetRedpointCnt(RedpointTree.NodeNames.QuestOrder))
    redPoint = element.Btn_OrderQuest.Img_RedPoint
  end
  if redPoint then
    redPoint:SetActive(DataModel.showReceiveCnt[type] and 0 < DataModel.showReceiveCnt[type])
  end
end

function Controller:SelectMainTitle(type, force, noAutoSelect)
  DataModel.CurSelectedMainTitle = type
  local childScroll = Controller:GetTypeScroll(type)
  local btn = Controller:GetTypeBtn(type)
  if DataModel.LastShowScroll ~= nil and DataModel.LastShowScroll ~= childScroll then
    DataModel.LastShowScroll.self:SetActive(false)
    DataModel.LastShowScroll = nil
  end
  if DataModel.LastSelectBtn ~= nil and DataModel.LastSelectBtn ~= btn then
    DataModel.LastSelectBtn.Group_UnSelected.self:SetActive(true)
    DataModel.LastSelectBtn.Group_Selected.self:SetActive(false)
  end
  local isActive = childScroll.self.IsActive and not force
  childScroll.self:SetActive(not isActive)
  btn.Group_UnSelected.self:SetActive(isActive)
  btn.Group_Selected.self:SetActive(not isActive)
  if not isActive then
    local count = #DataModel.AllQuests[type]
    local height = 1 <= count and 100 * (count - 1) + 120 or 50
    childScroll.grid.self:SetDataCount(count)
    childScroll.grid.self:MoveToTop()
    childScroll.grid.self:RefreshAllElement()
    if height > DataModel.ConstChildElementHeight then
      childScroll.self:SetHeight(DataModel.ConstChildElementHeight)
      childScroll.grid.self.ScrollRect.enabled = true
    else
      childScroll.self:SetHeight(height)
      childScroll.grid.self.ScrollRect.enabled = false
    end
    DataModel.LastShowScroll = childScroll
    DataModel.LastSelectBtn = btn
    if not noAutoSelect and 0 < count then
      local mergeIdx = DataModel.GetMergeIdx(type, 1)
      if type == DataModel.QuestType.Order then
        Controller:ShowOrderDetailInfo(mergeIdx)
      else
        Controller:ShowDetailInfo(mergeIdx)
      end
    end
  end
end

function Controller:GetTypeScroll(type)
  local childScroll
  if type == DataModel.QuestType.Main then
    childScroll = View.ScrollView_QuestList.Viewport.Content.ScrollGrid_MainQuest
  elseif type == DataModel.QuestType.Home then
    childScroll = View.ScrollView_QuestList.Viewport.Content.ScrollGrid_COCQuest
  elseif type == DataModel.QuestType.Side then
    childScroll = View.ScrollView_QuestList.Viewport.Content.ScrollGrid_SideQuest
  elseif type == DataModel.QuestType.Order then
    childScroll = View.ScrollView_QuestList.Viewport.Content.ScrollGrid_OrderQuest
  end
  return childScroll
end

function Controller:GetTypeBtn(type)
  local btn
  if type == DataModel.QuestType.Main then
    btn = View.ScrollView_QuestList.Viewport.Content.Btn_MainQuest
  elseif type == DataModel.QuestType.Home then
    btn = View.ScrollView_QuestList.Viewport.Content.Btn_COCQuest
  elseif type == DataModel.QuestType.Side then
    btn = View.ScrollView_QuestList.Viewport.Content.Btn_SideQuest
  elseif type == DataModel.QuestType.Order then
    btn = View.ScrollView_QuestList.Viewport.Content.Btn_OrderQuest
  end
  return btn
end

function Controller:SetChildElement(element, mergeIdx)
  local type, childIdx = DataModel.GetDetailTypeAndIdx(mergeIdx)
  local info = DataModel.AllQuests[type][childIdx]
  local isQuestTrace = DataModel.QuestTrace ~= nil and DataModel.QuestTrace.id == info.id
  element.Btn_Quest.Img_Target:SetActive(isQuestTrace)
  element.Btn_Quest.Group_Selected.Img_Target:SetActive(isQuestTrace)
  element.Btn_Quest.Group_Selected:SetActive(mergeIdx == DataModel.CurSelected)
  element.Btn_Quest.Txt_Name:SetActive(mergeIdx ~= DataModel.CurSelected)
  element.Btn_Quest.self:SetClickParam(mergeIdx)
  element.Btn_Quest.Txt_Name:SetText(info.questShowName)
  element.Btn_Quest.Group_Selected.Txt_Name:SetText(info.questShowName)
  element.Img_New:SetActive(info.isNew)
  element.Img_RedPoint:SetActive(info.isShowReceive)
  element.Btn_Quest.Txt_Position:SetActive(info.stationShowName and info.stationShowName ~= "")
  element.Btn_Quest.Txt_Position:SetText(info.stationShowName)
  element.Btn_Quest.Group_Selected.Txt_Position:SetActive(info.stationShowName and info.stationShowName ~= "")
  element.Btn_Quest.Group_Selected.Txt_Position:SetText(info.stationShowName)
end

function Controller:SetOrderChildElement(element, mergeIdx)
  local type, childIdx = DataModel.GetDetailTypeAndIdx(mergeIdx)
  local info = DataModel.AllQuests[type][childIdx]
  local isQuestTrace = DataModel.QuestTrace ~= nil and DataModel.QuestTrace.id == info.id
  element.Btn_Quest.Img_Target:SetActive(isQuestTrace)
  element.Btn_Quest.Group_Selected.Img_Target:SetActive(isQuestTrace)
  element.Btn_Quest.Group_Selected.self:SetActive(mergeIdx == DataModel.CurSelected)
  element.Btn_Quest.Txt_Name:SetActive(mergeIdx ~= DataModel.CurSelected)
  element.Btn_Quest.self:SetClickParam(mergeIdx)
  element.Btn_Quest.Txt_Name:SetText("")
  element.Btn_Quest.Group_Selected.Txt_Name:SetText("")
  element.Btn_Quest.Txt_OrderName:SetText(string.format(GetText(80601326), info.orderCA.name, info.stationCA.name))
  element.Btn_Quest.Group_Selected.Txt_OrderName:SetText(string.format(GetText(80601326), info.orderCA.name, info.stationCA.name))
  element.Btn_Quest.Group_Submit:SetActive(false)
  element.Btn_Quest.Group_Selected.Group_Submit:SetActive(false)
  element.Img_New:SetActive(info.isNew)
  local count_list = 0
  local count_e = 0
  for i = 1, 3 do
    if info.orderCA.requireItemList[i] then
      count_list = count_list + 1
      if info.orderCA.requireItemList[i].num <= PlayerData:GetGoodsById(info.orderCA.requireItemList[i].id).num then
        count_e = count_e + 1
      end
    end
  end
  info.isFinish = false
  if count_list == count_e then
    info.isFinish = true
    element.Btn_Quest.Group_Submit:SetActive(true)
    element.Btn_Quest.Group_Selected.Group_Submit:SetActive(true)
  end
end

function Controller:ShowDetailInfo(mergeIdx)
  View.Group_Info.self:SetActive(true)
  View.Group_Null.self:SetActive(false)
  View.Group_Info.Img_Info:SetActive(true)
  DataModel.CurSelected = mergeIdx
  local questType, childIdx = DataModel.GetDetailTypeAndIdx(mergeIdx)
  local info = DataModel.AllQuests[questType][childIdx]
  View.Group_Info.self:SetActive(true)
  View.Group_Null.self:SetActive(false)
  local questCA = PlayerData:GetFactoryData(info.id, "QuestFactory")
  View.Group_Info.Txt_Name:SetText(questCA.name)
  View.Group_Info.Group_Btn.Btn_Cancel.self:SetActive(questType == DataModel.QuestType.Home)
  View.Group_Info.Group_Btn.Btn_Cancel.self:SetClickParam(tostring(mergeIdx))
  local isLevelLimit = questCA.startLevel and questCA.startLevel > PlayerData:GetPlayerLevel()
  local stationName = ""
  if info.endStation ~= nil and info.endStation > 0 then
    View.Group_Info.Txt_Position:SetActive(true)
    local stationCA = PlayerData:GetFactoryData(info.endStation, "HomeStationFactory")
    stationName = stationCA.name
    View.Group_Info.Txt_Position:SetText(stationName)
  else
    View.Group_Info.Txt_Position:SetActive(false)
  end
  local progressShowTxt = ""
  local serverKey = ""
  if questCA.isShowProgress and not isLevelLimit then
    if questCA.cocQuestType == "Buy" then
      local serverData
      local stationInfo = PlayerData:GetHomeInfo().stations[tostring(questCA.startStation)]
      if stationInfo ~= nil and stationInfo.quests.Buy ~= nil and stationInfo.quests.Buy[tostring(questCA.id)] ~= nil then
        serverData = stationInfo.quests.Buy[tostring(questCA.id)].info
      end
      local curNum = 0
      if serverData ~= nil and type(serverData) == "table" then
        curNum = serverData[tostring(questCA.goodsList[1].id)] or 0
      end
      local maxNum = questCA.goodsList[1].num
      progressShowTxt = string.format(GetText(80600776), curNum, maxNum)
    elseif questCA.questType == "Main" then
      serverKey = "mq_quests"
    elseif questCA.questType == "Side" then
      serverKey = "branch_quests"
    else
      progressShowTxt = ""
    end
    if serverKey ~= "" then
      local curNum = 0
      local serverData = PlayerData.ServerData.quests[serverKey]
      if info.curNum then
        curNum = info.curNum
      elseif serverData and serverData[tostring(questCA.id)] then
        curNum = serverData[tostring(questCA.id)].pcnt or 0
      end
      local maxNum = info.maxNum and info.maxNum or questCA.num
      progressShowTxt = string.format(GetText(80600776), curNum, maxNum)
    end
  end
  local afterTxt = ""
  if QuestProcess.CheckShowRecommendLevel(questCA.id) then
    afterTxt = string.format(GetText(80611098), questCA.recommendLevel)
  end
  if questCA.cocQuestType == "Buy" or questCA.cocQuestType == "Send" then
    View.Group_Info.Txt_Target:SetText(string.format(questCA.describeNew, stationName) .. progressShowTxt)
    View.Group_Info.ScrollView_Des.Viewport.Txt_Des:SetText(string.format(questCA.story, stationName) .. afterTxt)
  else
    local target = questCA.describeNew
    local des = questCA.story
    if isLevelLimit then
      target = string.format(GetText(80601044), questCA.startLevel)
      des = GetText(80606903)
    end
    View.Group_Info.Txt_Target:SetText(target .. progressShowTxt)
    View.Group_Info.ScrollView_Des.Viewport.Txt_Des:SetText(des .. afterTxt)
  end
  local rewardList = questCA.rewardsList
  DataModel.CurDetailReward = rewardList
  local rewardCount = #rewardList
  if questCA.reputationList ~= nil and 0 < #questCA.reputationList then
    rewardCount = rewardCount + 1
    DataModel.CurRepReward = questCA.reputationList
  end
  if not isLevelLimit then
    if rewardCount <= 7 then
      View.Group_Info.ScrollGrid_Reward.self:SetEnable(false)
      View.Group_Info.ScrollGrid_Reward.grid.self:SetStartCorner("Center")
    else
      View.Group_Info.ScrollGrid_Reward.self:SetEnable(true)
      View.Group_Info.ScrollGrid_Reward.grid.self:SetStartCorner("Left")
    end
    View.Group_Info.ScrollGrid_Reward.grid.self:SetDataCount(rewardCount)
    View.Group_Info.ScrollGrid_Reward.grid.self:RefreshAllElement()
  else
    View.Group_Info.ScrollGrid_Reward.grid.self:SetDataCount(0)
    View.Group_Info.ScrollGrid_Reward.grid.self:RefreshAllElement()
  end
  View.Group_Info.Group_Btn.Btn_Navigate.self:SetClickParam(mergeIdx)
  View.Group_Info.Group_Btn.Btn_CancelNavigate.self:SetClickParam(mergeIdx)
  if not isLevelLimit and QuestTrace.DeleteRedNodeData(info.id) then
    PlayerData:SetPlayerPrefs("int", "QuestRed" .. info.id, 1)
    Controller:RefreshMainTitleViewState(questType)
  end
  info.isNew = false
  local scroll = Controller:GetTypeScroll(questType)
  if scroll ~= nil and scroll.self.IsActive then
    scroll.grid.self:RefreshAllElement()
  end
  if questType ~= DataModel.LastShowType then
    scroll = Controller:GetTypeScroll(DataModel.LastShowType)
    if scroll ~= nil and scroll.self.IsActive then
      local row = DataModel.AllQuests[DataModel.LastShowType]
      if row and 0 < table.count(row) then
        scroll.grid.self:RefreshAllElement()
      end
    end
  end
  local isQuestTrace = DataModel.QuestTrace ~= nil and DataModel.QuestTrace.id == info.id
  View.Group_Info.Group_Btn.Btn_Navigate.self:SetActive(not isQuestTrace)
  View.Group_Info.Group_Btn.Btn_CancelNavigate.self:SetActive(isQuestTrace)
  View.Group_Info.Group_Order.self:SetActive(false)
  DataModel.LastShowType = questType
  View.Group_Info.Group_Btn.Btn_Receive:SetActive(info.isShowReceive)
  if info.isShowReceive then
    View.Group_Info.Group_Btn.Btn_Receive:SetClickParam(mergeIdx)
    View.Group_Info.Group_Btn.Btn_Cancel:SetActive(false)
    View.Group_Info.Group_Btn.Btn_CancelNavigate:SetActive(false)
    View.Group_Info.Group_Btn.Btn_Navigate:SetActive(false)
  end
end

function Controller:ShowOrderDetailInfo(mergeIdx)
  View.Group_Info.self:SetActive(true)
  View.Group_Info.Img_Info:SetActive(false)
  View.Group_Null.self:SetActive(false)
  DataModel.CurSelected = mergeIdx
  local questType, childIdx = DataModel.GetDetailTypeAndIdx(mergeIdx)
  local info = DataModel.AllQuests[questType][childIdx]
  View.Group_Info.self:SetActive(true)
  View.Group_Null.self:SetActive(false)
  local orderCA = info.orderCA
  View.Group_Info.Txt_Name:SetText(info.orderCA.name)
  View.Group_Info.Group_Btn.Btn_Cancel.self:SetActive(questType == DataModel.QuestType.Home)
  View.Group_Info.Group_Btn.Btn_Cancel.self:SetClickParam(tostring(mergeIdx))
  local stationName = ""
  if info.Stationid ~= nil then
    View.Group_Info.Txt_Position:SetActive(true)
    stationName = info.stationCA.name
    View.Group_Info.Txt_Position:SetText(stationName)
  else
    View.Group_Info.Txt_Position:SetActive(false)
  end
  local progressShowTxt = ""
  local serverKey = ""
  if orderCA.isShowProgress then
    if orderCA.cocQuestType == "Buy" then
      local serverData
      local stationInfo = PlayerData:GetHomeInfo().stations[tostring(orderCA.startStation)]
      if stationInfo ~= nil and stationInfo.quests.Buy ~= nil and stationInfo.quests.Buy[tostring(orderCA.id)] ~= nil then
        serverData = stationInfo.quests.Buy[tostring(orderCA.id)].info
      end
      local curNum = 0
      if serverData ~= nil and type(serverData) == "table" then
        curNum = serverData[tostring(orderCA.goodsList[1].id)] or 0
      end
      local maxNum = orderCA.goodsList[1].num
      progressShowTxt = string.format(GetText(80600776), curNum, maxNum)
    elseif orderCA.questType == "Main" then
      serverKey = "mq_quests"
    elseif orderCA.questType == "Side" then
      serverKey = "branch_quests"
    else
      progressShowTxt = ""
    end
  end
  if orderCA.cocQuestType == "Buy" or orderCA.cocQuestType == "Send" then
    View.Group_Info.Txt_Target:SetText(string.format(orderCA.describeNew, stationName) .. progressShowTxt)
  else
    View.Group_Info.Txt_Target:SetText(orderCA.describeNew .. progressShowTxt)
  end
  View.Group_Info.ScrollView_Des.Viewport.Txt_Des:SetText("")
  local rewardList = orderCA.rewardsList
  DataModel.CurDetailReward = rewardList
  local rewardCount = #rewardList
  if orderCA.reputationList ~= nil and 0 < #orderCA.reputationList then
    rewardCount = rewardCount + 1
    DataModel.CurRepReward = orderCA.reputationList
  end
  if rewardCount <= 7 then
    View.Group_Info.ScrollGrid_Reward.self:SetEnable(false)
    View.Group_Info.ScrollGrid_Reward.grid.self:SetStartCorner("Center")
  else
    View.Group_Info.ScrollGrid_Reward.self:SetEnable(true)
    View.Group_Info.ScrollGrid_Reward.grid.self:SetStartCorner("Left")
  end
  View.Group_Info.ScrollGrid_Reward.grid.self:SetDataCount(rewardCount)
  View.Group_Info.ScrollGrid_Reward.grid.self:RefreshAllElement()
  View.Group_Info.Group_Btn.Btn_Navigate.self:SetClickParam(mergeIdx)
  View.Group_Info.Group_Btn.Btn_CancelNavigate.self:SetClickParam(mergeIdx)
  local isQuestTrace = DataModel.QuestTrace ~= nil and DataModel.QuestTrace.id == info.id
  View.Group_Info.Group_Btn.Btn_Navigate.self:SetActive(not isQuestTrace)
  View.Group_Info.Group_Btn.Btn_CancelNavigate.self:SetActive(isQuestTrace)
  local count_list = 0
  local count_e = 0
  for i = 1, 3 do
    local obj_name = "Group_Consume" .. i
    local obj = View.Group_Info.Group_Order.Group_Item[obj_name]
    obj:SetActive(false)
    if orderCA.requireItemList[i] then
      count_list = count_list + 1
      CommonItem:SetItem(obj.Group_Item, {
        id = orderCA.requireItemList[i].id,
        num = ""
      })
      obj.Group_Item.Btn_Item:SetClickParam(orderCA.requireItemList[i].id)
      obj.Group_Cost.Txt_Need:SetText(PlayerData:TransitionNum(orderCA.requireItemList[i].num))
      obj.Group_Cost.Txt_Have:SetText(PlayerData:TransitionNum(PlayerData:GetGoodsById(orderCA.requireItemList[i].id).num))
      obj.Group_Cost.Txt_Have:SetColor(UIConfig.Color.Red)
      if orderCA.requireItemList[i].num <= PlayerData:GetGoodsById(orderCA.requireItemList[i].id).num then
        obj.Group_Cost.Txt_Have:SetColor(UIConfig.Color.White)
        count_e = count_e + 1
      end
      obj:SetActive(true)
    end
  end
  View.Group_Info.Group_Order.self:SetActive(true)
  View.Group_Info.Group_Order.Img_Btm:SetActive(true)
  View.Group_Info.Group_Order.Group_Submit.self:SetActive(false)
  if count_list == count_e then
    View.Group_Info.Group_Order.Img_Btm:SetActive(false)
    View.Group_Info.Group_Order.Group_Submit.self:SetActive(true)
    View.Group_Info.Img_Info:SetActive(true)
    info.isFinish = true
  end
  if QuestTrace.DeleteRedNodeData(info.id) then
    PlayerData:SetPlayerPrefs("int", "QuestRed" .. info.id, 1)
    Controller:RefreshMainTitleViewState(questType)
  end
  info.isNew = false
  local scroll = Controller:GetTypeScroll(questType)
  if scroll ~= nil and scroll.self.IsActive then
    scroll.grid.self:RefreshAllElement()
  end
  if questType ~= DataModel.LastShowType then
    scroll = Controller:GetTypeScroll(DataModel.LastShowType)
    if scroll ~= nil and scroll.self.IsActive then
      scroll.grid.self:RefreshAllElement()
    end
  end
  DataModel.LastShowType = questType
  View.Group_Info.Group_Btn.Btn_Receive:SetActive(info.isShowReceive)
  if info.isShowReceive then
    View.Group_Info.Group_Btn.Btn_Receive:SetClickParam(mergeIdx)
    View.Group_Info.Group_Btn.Btn_Cancel:SetActive(false)
    View.Group_Info.Group_Btn.Btn_CancelNavigate:SetActive(false)
    View.Group_Info.Group_Btn.Btn_Navigate:SetActive(false)
  end
end

function Controller:ClickReceive(btn, str)
  local mergeIdx = tonumber(str)
  local questType, childIdx = DataModel.GetDetailTypeAndIdx(mergeIdx)
  local info = DataModel.AllQuests[questType][childIdx]
  local id = info.id
  local questCA = PlayerData:GetFactoryData(id, "QuestFactory")
  if PlayerData.CheckExceedCapacityLimit(questCA.rewardsList, true) then
    return
  end
  Net:SendProto("quest.recv_rewards", function(json)
    local serverKey = ""
    if questCA.questType == "Main" then
      serverKey = "mq_quests"
    elseif questCA.questType == "Side" then
      serverKey = "branch_quests"
    end
    PlayerData.ServerData.quests[serverKey][tostring(id)] = nil
    if json.current_quests ~= nil then
      for k, v in pairs(json.current_quests) do
        questCA = PlayerData:GetFactoryData(k, "QuestFactory")
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
    DataModel.InitAllQuests(PlayerData.ServerData.quests)
    DataModel.CurSelected = 0
    View.Group_Info.self:SetActive(false)
    View.Group_Null.self:SetActive(true)
    if DataModel.CurSelectedMainTitle == questType then
      Controller:SelectMainTitle(DataModel.CurSelectedMainTitle, true)
    end
    Controller:RefreshMainTitleViewState(questType)
    QuestTrace.CompleteQuestOne(id)
    PlayerData.TempCache.AutoCompleteLevelsServerReward = json.reward
    CommonTips.OpenQuestsCompleteTip({
      [1] = id
    })
  end, id)
end

return Controller
