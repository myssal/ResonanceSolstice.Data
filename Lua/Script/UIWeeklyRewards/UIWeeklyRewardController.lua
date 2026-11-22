local View = require("UIWeeklyRewards/UIWeeklyRewardsView")
local DataModel = require("UIWeeklyRewards/UIWeeklyRewardsDataModel")
local Controller = {}

function Controller.Init()
  Controller.RefreshContentShow()
  View.Group_Bg.Img_Title:SetSprite(GetResPath(88300167))
  Controller.RefreshTimeRemainShow()
  TimerHelper.Stop("MagicCube_WeeklyReward_Refresh_Timer")
  TimerHelper.Start("MagicCube_WeeklyReward_Refresh_Timer", 1, function()
    Controller.RefreshTimeRemainShow()
  end)
  local initIndex = DataModel.GetFirstOpenIndex() or 0
  if 0 < initIndex then
    View.ScrollView_RewardList.Viewport.Content:SetLocalPositionX((initIndex - 1) * -330)
  end
end

function Controller.Release()
  TimerHelper.Stop("MagicCube_WeeklyReward_Refresh_Timer")
end

function Controller.RefreshContentShow()
  View.Group_Num.Txt_Current:SetText(tostring(DataModel.GetCurScore()))
  View.Group_Num.Txt_All:SetText(tostring(DataModel.GetLimitScore()))
  if DataModel.rewardList and #DataModel.rewardList > 0 then
    View.ScrollView_RewardList.Viewport.Content.StaticGrid_List.grid.self:SetDataCount(#DataModel.rewardList)
    View.ScrollView_RewardList.Viewport.Content.StaticGrid_List.grid.self:RefreshAllElement()
  end
end

function Controller.RefreshRewardElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not DataModel.rewardList then
    return
  end
  local config = DataModel.rewardList[elementIndex]
  if not config then
    return
  end
  local itemInfo = PlayerData:GetFactoryData(config.id, "ItemFactory")
  if itemInfo then
    element.Btn_Rewards.Img_Reward:SetSprite(itemInfo.iconPath)
    local numStr = ""
    if config.id == 11400001 then
      numStr = tostring(PlayerData:TransitionNum(config.num))
    else
      numStr = tostring(config.num)
    end
    element.Btn_Rewards.Txt_Num:SetText(numStr)
  end
  element.Txt_RequiredNum:SetText(tostring(DataModel.GetCostNumByIndex(elementIndex)))
  local state = DataModel.GetRewardStateByIndex(elementIndex)
  if state == DataModel.rewardState.canNotGet then
    element.Group_UnClaimable:SetActive(true)
    element.Img_Unclaimable:SetActive(true)
    element.Img_Claimable:SetActive(false)
    element.Group_Claimed:SetActive(false)
    element.Txt_Claimable:SetActive(false)
    element.Img_Claimed:SetActive(false)
    element.Btn_ClaimAll:SetActive(false)
  elseif state == DataModel.rewardState.canGet then
    element.Img_Claimable:SetActive(true)
    element.Group_Claimed:SetActive(true)
    element.Txt_Claimable:SetActive(true)
    element.Group_UnClaimable:SetActive(false)
    element.Img_Unclaimable:SetActive(false)
    element.Img_Claimed:SetActive(false)
    element.Btn_ClaimAll:SetActive(true)
  else
    element.Group_Claimed:SetActive(true)
    element.Img_Claimed:SetActive(true)
    element.Img_Claimable:SetActive(false)
    element.Txt_Claimable:SetActive(false)
    element.Group_UnClaimable:SetActive(false)
    element.Img_Unclaimable:SetActive(false)
    element.Btn_ClaimAll:SetActive(false)
  end
  element.Btn_Rewards:SetClickFunction(function()
    CommonTips.OpenPreItemTips({
      itemId = config.id
    })
  end)
  element.Btn_ClaimAll:SetClickFunction(function()
    Controller.ReqGetAllReward()
  end)
end

function Controller.ReqGetAllReward()
  Net:SendProto("cube.weekly_reward", function(json)
    if string.nilorempty(json.rc) then
      CommonTips.OpenShowItem(json.reward)
      DataModel.SetRewardHasGetIndex(DataModel.GetCountCanGetReward() - 1)
      View.ScrollView_RewardList.Viewport.Content.StaticGrid_List.grid.self:RefreshAllElement()
    end
  end)
end

function Controller.RefreshTimeRemainShow()
  local remainTime = DataModel.GetRefreshTimeRemain() or 0
  if remainTime <= 0 then
    DataModel.SetRewardHasGetIndex(-1)
    DataModel.ResetCurScore()
    Controller.RefreshContentShow()
  end
  local dayList = TimeUtil:SecondToTable(remainTime)
  View.Group_Time.Txt_Time:SetText(string.format(GetText(80600954), dayList.day, dayList.hour))
end

return Controller
