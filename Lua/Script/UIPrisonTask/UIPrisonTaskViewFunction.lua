local View = require("UIPrisonTask/UIPrisonTaskView")
local DataModel = require("UIPrisonTask/UIPrisonTaskDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  PrisonTask_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
      View.self:CloseUI()
    else
      UIManager:GoBack()
    end
  end,
  PrisonTask_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PrisonTask_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonTask_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  PrisonTask_Group_Main_ScrollGrid__SetGrid = function(element, elementIndex)
    local questId = DataModel.questList[elementIndex]
    local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
    local state, pcnt = PlayerData.GetQuestState(questId)
    local isComplete = state == EnumDefine.EQuestState.Finish
    local isReceive = state == EnumDefine.EQuestState.Receive
    local showTxt = questCA.describe
    if questCA.isShowProgress then
      showTxt = showTxt .. string.format("(%d/%d)", pcnt, questCA.num)
    end
    element.Group_Info.Txt_Name:SetText(showTxt)
    element.Group_Info.Group_Reward.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
    element.Group_Info.Group_Reward.ScrollGrid_Reward.grid.self:SetDataCount(#questCA.rewardsList)
    element.Group_Info.Group_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
    element.Group_Info.Group_incomplete:SetActive(not isComplete and not isReceive)
    element.Group_Info.Group_Complete:SetActive(isComplete or isReceive)
    if isComplete or isReceive then
      element.Group_Info.Group_Complete.Group_Get:SetActive(not isReceive)
      element.Group_Info.Group_Complete.Group_Get.Btn_Get:SetClickParam(questId)
      element.Group_Info.Group_Complete.Img_Tab:SetSprite(questCA.completeTab)
    else
      element.Group_Info.Group_incomplete.Img_Tab:SetSprite(questCA.questTab)
      local isTraceSelf = DataModel.curQuestTraceId == questId
      element.Group_Info.Group_incomplete.Group_Track:SetActive(not isTraceSelf)
      element.Group_Info.Group_incomplete.Group_Cancel:SetActive(isTraceSelf)
      element.Group_Info.Group_incomplete.Group_Track.Btn_Track:SetClickParam(questId)
      element.Group_Info.Group_incomplete.Group_Cancel.Btn_Cancel:SetClickParam(questId)
    end
    local questTypeTxt = GetText(questCA.questTabDes)
    element.Group_Info.Group_Complete.Img_Tab.Txt_:SetText(questTypeTxt)
    element.Group_Info.Group_incomplete.Img_Tab.Txt_:SetText(questTypeTxt)
    element.Group_Info.Group_Got:SetActive(isReceive)
  end,
  PrisonTask_Group_Main_ScrollGrid__Group_Item_Group_Info_Group_incomplete_Group_Track_Btn_Track_Click = function(btn, str)
    DataModel.TraceQuest(str)
  end,
  PrisonTask_Group_Main_ScrollGrid__Group_Item_Group_Info_Group_incomplete_Group_Cancel_Btn_Cancel_Click = function(btn, str)
    DataModel.CancelQuestTrace()
  end,
  PrisonTask_Group_Main_ScrollGrid__Group_Item_Group_Info_Group_Complete_Group_Get_Btn_Get_Click = function(btn, str)
    DataModel.ReceiveReward(str)
  end,
  PrisonTask_Group_Main_ScrollGrid__Group_Item_Group_Info_Group_Reward_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local questId = DataModel.questList[tonumber(element.ParentParam)]
    local questCA = PlayerData:GetFactoryData(questId, "QuestFactory")
    local rewardInfo = questCA.rewardsList[elementIndex]
    CommonItem:SetItem(element.Group_Item, {
      id = rewardInfo.id
    })
    element.Group_Item.Btn_Item:SetClickParam(rewardInfo.id)
  end,
  PrisonTask_Group_Main_ScrollGrid__Group_Item_Group_Info_Group_Reward_ScrollGrid_Reward_Group_Reward_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PrisonTask_Group_IslandLv_Btn_Reputation_Click = function(btn, str)
  end
}
return ViewFunction
