local View = require("UIAnniversaryMission/UIAnniversaryMissionView")
local DataModel = require("UIAnniversaryMission/UIAnniversaryMissionDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init()
  DataModel.InitQuestInfo()
  Controller:RefreshGoldShow()
  Controller:RefreshTabRedPoint()
  Controller:ClickShowQuest(1)
end

function Controller:ClickShowQuest(showType)
  DataModel.curShowType = showType
  View.Group_Tab.Group_Tab1.Group_On.self:SetActive(showType == 1)
  View.Group_Tab.Group_Tab1.Group_Off.self:SetActive(showType ~= 1)
  View.Group_Tab.Group_Tab2.Group_On.self:SetActive(showType == 2)
  View.Group_Tab.Group_Tab2.Group_Off.self:SetActive(showType ~= 2)
  DataModel.GetCurShowQuest(showType)
  View.NewScrollGrid_Mission.grid.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
    View.NewScrollGrid_Mission.grid.self:SetDataCount(#DataModel.curShowQuest)
    View.NewScrollGrid_Mission.grid.self:MoveToTop()
    View.NewScrollGrid_Mission.grid.self:RefreshAllElement()
  end))
end

function Controller:RefreshTabRedPoint()
  local state1, state2 = DataModel.GetTabIsHadQuestCanGet()
  View.Group_Tab.Group_Tab1.Img_RedPoint:SetActive(state1)
  View.Group_Tab.Group_Tab2.Img_RedPoint:SetActive(state2)
end

function Controller:SetQuestElement(element, elementIndex)
  local info = DataModel.curShowQuest[elementIndex]
  local questCA = PlayerData:GetFactoryData(info.id)
  if questCA.showType == "Txt" then
    element.Group_Des.Txt_TxtType:SetActive(true)
    element.Group_Des.Group_NumType:SetActive(false)
    element.Group_Des.Txt_TxtType:SetText(questCA.story)
  else
    element.Group_Des.Txt_TxtType:SetActive(false)
    element.Group_Des.Group_NumType:SetActive(true)
    element.Group_Des.Group_NumType.Txt_LiveNum:SetText(info.pcnt)
    element.Group_Des.Group_NumType.Txt_TargetNum:SetText(questCA.num)
  end
  element.Txt_TypeName:SetText(questCA.name)
  element.ScrollGrid_Rewards.grid.self:SetParentParam(elementIndex)
  element.ScrollGrid_Rewards.grid.self:SetDataCount(#questCA.rewardsList)
  element.ScrollGrid_Rewards.grid.self:RefreshAllElement()
  element.Btn_Completed:SetActive(info.state == EnumDefine.EQuestState.Finish)
  element.Group_Got:SetActive(info.state == EnumDefine.EQuestState.Receive)
  if element.Img_GotBG then
    element.Img_GotBG:SetActive(info.state == EnumDefine.EQuestState.Receive)
  end
  if info.state == EnumDefine.EQuestState.Finish then
    element.Btn_Completed:SetClickParam(elementIndex)
    if element.Btn_Completed.Txt_TypeName then
      element.Btn_Completed.Txt_TypeName:SetText(questCA.name)
    end
    if element.Btn_Completed.Group_Des and element.Btn_Completed.Group_Des.Txt_TxtType then
      element.Btn_Completed.Group_Des.Txt_TxtType:SetText(questCA.story)
    end
  end
end

function Controller:ClickComplete(btn, str)
  local idx = tonumber(str)
  local info = DataModel.curShowQuest[idx]
  Net:SendProto("quest.recv_rewards", function(json)
    local serverActivityQuest = PlayerData.ServerData.quests.activity_quests
    local detailServerInfo = serverActivityQuest[tostring(info.id)]
    detailServerInfo.recv = TimeUtil:GetServerTimeStamp()
    info.state = EnumDefine.EQuestState.Receive
    DataModel.SortQuestInfo(DataModel.questInfo)
    DataModel.GetCurShowQuest(DataModel.curShowType)
    Controller:RefreshTabRedPoint()
    View.NewScrollGrid_Mission.grid.self:RefreshAllElement()
    CommonTips.OpenShowItem(json.reward)
  end, info.id)
end

function Controller:SetRewardElement(element, elementIndex)
  local info = DataModel.curShowQuest[tonumber(element.ParentParam)]
  local questCA = PlayerData:GetFactoryData(info.id)
  local rewardInfo = questCA.rewardsList[elementIndex]
  CommonItem:SetItem(element.Group_CommonItem, {
    id = rewardInfo.id,
    num = rewardInfo.num
  }, EnumDefine.ItemType.Item)
  element.Group_CommonItem.Btn_Item:SetClickParam(rewardInfo.id)
end

function Controller:ClickRewardItem(btn, str)
  local itemId = tonumber(str)
  CommonTips.OpenPreRewardDetailTips(itemId)
end

function Controller:Return()
  UIManager:GoBack()
end

function Controller:Home()
  UIManager:GoHome()
end

function Controller:RefreshGoldShow()
  local allGold = 0
  local activityData = PlayerData:GetActivityData(DataModel.decodeParams.activityId)
  if activityData then
    allGold = activityData.level_gold or 0
  end
  View.Group_Gold.Txt_Num:SetText(allGold)
end

return Controller
