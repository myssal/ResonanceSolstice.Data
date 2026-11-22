local View = require("UICubeRogueMission/UICubeRogueMissionView")
local DataModel = require("UICubeRogueMission/UICubeRogueMissionDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  Controller:RefreshTabInfo()
  Controller:ClickTab(DataModel.curSelectTabType, true)
  View.Group_Title.Img_Title:SetSprite(PlayerData:GetFactoryData(88300248).filePath)
end

function Controller:RefreshTabInfo()
  local function SetTabInfo(element, questInfo)
    element.Group_Off.Txt_Title:SetText(questInfo.name)
    
    element.Group_Off.Txt_Progress:SetText(questInfo.completeCount .. "/" .. #questInfo.questList)
    element.Group_On.Txt_Title:SetText(questInfo.name)
    element.Group_On.Txt_Progress:SetText(questInfo.completeCount .. "/" .. #questInfo.questList)
  end
  
  SetTabInfo(View.Group_Tab.Group_Tab1, DataModel.questInfo[1])
  SetTabInfo(View.Group_Tab.Group_Tab2, DataModel.questInfo[2])
  local isShow = DataModel.IsType1CanRecevive()
  View.Group_Tab.Group_Tab1.Group_RedPoint.self:SetActive(isShow)
  isShow = DataModel.IsType2CanRecevive()
  View.Group_Tab.Group_Tab2.Group_RedPoint.self:SetActive(isShow)
end

function Controller:ClickTab(tabType, force)
  if tabType == DataModel.curSelectTabType and not force then
    return
  end
  DataModel.curSelectTabType = tabType
  View.Group_Tab.Group_Tab1.Group_Off:SetActive(tabType ~= 1)
  View.Group_Tab.Group_Tab1.Group_On:SetActive(tabType == 1)
  View.Group_Tab.Group_Tab2.Group_Off:SetActive(tabType ~= 2)
  View.Group_Tab.Group_Tab2.Group_On:SetActive(tabType == 2)
  View.NewScrollGrid_Mission.grid.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
    View.NewScrollGrid_Mission.grid.self:SetDataCount(#DataModel.questInfo[tabType].questList)
    View.NewScrollGrid_Mission.grid.self:MoveToTop()
    View.NewScrollGrid_Mission.grid.self:RefreshAllElement()
  end))
end

function Controller:RefreshQuestElement(element, elementIndex)
  local questInfo = DataModel.questInfo[DataModel.curSelectTabType].questList[elementIndex]
  element.Txt_TypeName:SetText(questInfo.name)
  element.Group_Des.Txt_TxtType:SetText(questInfo.story)
  element.Group_Des.Group_NumType:SetActive(DataModel.curSelectTabType == 2)
  if DataModel.curSelectTabType == 2 then
    element.Group_Des.Group_NumType.Txt_:SetText(string.format(GetText(80610771), questInfo.pcnt))
  end
  element.ScrollGrid_Rewards.grid.self:SetParentParam(elementIndex)
  element.ScrollGrid_Rewards.grid.self:SetDataCount(questInfo.rewardsList and #questInfo.rewardsList or 0)
  element.ScrollGrid_Rewards.grid.self:RefreshAllElement()
  element.Btn_Completed:SetActive(questInfo.state == EnumDefine.EQuestState.Finish)
  element.Btn_Completed:SetClickParam(elementIndex)
  element.Group_Got:SetActive(questInfo.state == EnumDefine.EQuestState.Receive)
end

function Controller:ClickQuestComplete(str)
  local idx = tonumber(str)
  local info = DataModel.questInfo[DataModel.curSelectTabType]
  local questInfo = info.questList[idx]
  Net:SendProto("quest.recv_rewards", function(json)
    for k, v in pairs(PlayerData.ServerData.quests) do
      local detailServerInfo = v[tostring(questInfo.id)]
      if detailServerInfo then
        detailServerInfo.recv = TimeUtil:GetServerTimeStamp()
        break
      end
    end
    info.completeCount = info.completeCount + 1
    questInfo.state = EnumDefine.EQuestState.Receive
    DataModel.SortQuest(info.questList)
    Controller:RefreshTabInfo()
    View.NewScrollGrid_Mission.grid.self:RefreshAllElement()
    CommonTips.OpenShowItem(json.reward)
  end, questInfo.id)
end

function Controller:RefreshRewardElement(element, elementIndex)
  local rewardInfo = DataModel.questInfo[DataModel.curSelectTabType].questList[tonumber(element.ParentParam)].rewardsList[elementIndex]
  BtnItem:SetItem(element.Group_CommonItem, {
    id = rewardInfo.id
  })
  element.Group_CommonItem.Txt_Num:SetText("X" .. rewardInfo.num)
  element.Group_CommonItem.Btn_Item:SetClickParam(rewardInfo.id)
end

function Controller:ClickRewardItem(str)
  local id = tonumber(str)
  CommonTips.OpenRewardDetail(id)
end

function Controller:Return()
  UIManager:GoBack()
  View.self:Confirm()
end

return Controller
