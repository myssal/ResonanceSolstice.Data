local View = require("UIWitcheslMission/UIWitcheslMissionView")
local DataModel = require("UIWitcheslMission/UIWitcheslMissionDataModel")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  Controller:RefreshMissionList()
  View.Group_Title.Img_Title:SetSprite(WitchData.GetUIPath(GetResPath(88300233), DataModel.ActivityId))
  View.Group_Money.Txt_:SetText(PlayerData:GetGoodsById(11400001).num)
end

function Controller:SetMissionElement(element, elementIndex)
  DataModel.CurSetMissionElementIndex = elementIndex
  local data = DataModel.MissionList[elementIndex]
  local cfg = PlayerData:GetFactoryData(data.id)
  element.ScrollGrid_Rewards.grid.self:SetDataCount(#cfg.rewardsList)
  element.ScrollGrid_Rewards.grid.self:RefreshAllElement()
  element.Group_Normal:SetActive(data.state == DataModel.QuestState.UnFinish)
  element.Btn_Completed:SetActive(data.state == DataModel.QuestState.Finish)
  element.Group_Got:SetActive(data.state == DataModel.QuestState.Receive)
  element.Group_Des.Txt_TxtType:SetText(cfg.name)
  element.Btn_Completed:SetClickParam(elementIndex)
end

function Controller:RefreshMissionList()
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
    View.NewScrollGrid_Mission.grid.self:SetDataCount(#DataModel.MissionList)
    View.NewScrollGrid_Mission.grid.self:RefreshAllElement()
  end))
end

function Controller:SetMissionRewardElement(element, elementIndex)
  local missionIdx = element.transform.parent.parent.parent.parent:GetComponent(typeof(CS.Seven.UIGridItemIndex)).Index
  local data = DataModel.MissionList[missionIdx + 1]
  local cfg = PlayerData:GetFactoryData(data.id)
  local reward = cfg.rewardsList[elementIndex]
  local itemCfg = PlayerData:GetFactoryData(reward.id)
  if itemCfg.mod == "\229\159\186\231\161\128\229\141\161\229\140\133" then
    element.Group_CommonItem.Img_Item:SetSprite(itemCfg.itemIconPath)
  else
    element.Group_CommonItem.Img_Item:SetSprite(itemCfg.iconPath)
  end
  element.Group_CommonItem.Txt_Num:SetText(reward.num)
  element.Group_CommonItem.Btn_Item:SetClickParam(reward.id)
end

function Controller:TryFinishMission(idx)
  local data = DataModel.MissionList[idx]
  if data.state ~= DataModel.QuestState.Finish then
    return
  end
  Net:SendProto("quest.recv_rewards", function(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    PlayerData.ServerData.quests.activity_quests[tostring(data.id)].recv = 1
    QuestTrace.CompleteQuestOne(data.id)
    DataModel.InitMission()
    Controller:RefreshMissionList()
  end, tostring(data.id))
end

return Controller
